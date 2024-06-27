codeunit 80001 "bmsAzure Storage Mngt"
{
    procedure HandlingFilesOnAFS(fileName: text; InStream: InStream; var documentAttachment: Record "Document Attachment"; fileAction: Text[20])
    var
        afsOpReponse: Codeunit "AFS Operation Response";
        folderName: text[250];
    begin
        afsConnection();

        folderName := getSPFolder(documentAttachment);

        case fileAction of
            'Download':
                if documentAttachment."bmsFile Path" <> '' then begin
                    afsFileClient.GetFileAsStream(documentAttachment."bmsFile Path", InStream);
                    fileName := documentAttachment."File Name" + '.' + documentAttachment."File Extension";
                    DownloadFromStream(InStream, '', '', '', fileName);
                end;
            'Delete':
                if documentAttachment."bmsFile Path" <> '' then
                    afsFileClient.DeleteFile(documentAttachment."bmsFile Path");
            'Upload':
                begin
                    afsOpReponse := afsFileClient.CreateFile(folderName + '/' + format(documentAttachment."Table ID") + '-' + documentAttachment."No." + '-' + fileName, InStream);
                    afsOpReponse := afsFileClient.PutFileStream(folderName + '/' + format(documentAttachment."Table ID") + '-' + documentAttachment."No." + '-' + fileName, InStream);
                    documentAttachment."bmsFile Path" := folderName + '/' + format(documentAttachment."Table ID") + '-' + documentAttachment."No." + '-' + fileName;
                end;
            'Show':
                if documentAttachment."bmsFile Path" <> '' then
                    afsFileClient.GetFileAsStream(documentAttachment."bmsFile Path", InStream);
        end;

    end;

    local procedure afsConnection()
    var
        companyInformation: Record "Company Information";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        storageAuthorization: Interface "Storage Service Authorization";
    begin
        companyInformation.Get();

        storageAuthorization := StorageServiceAuthorization.UseReadySAS(companyInformation."bmsAFS SaaS Connection String");

        afsFileClient.Initialize(
             copystr(companyInformation."bmsAzure Storage Account", 1, StrPos(companyInformation."bmsAzure Storage Account", '/') - 1),
             copystr(companyInformation."bmsAzure Storage Account", StrPos(companyInformation."bmsAzure Storage Account", '/') + 1, StrLen(companyInformation."bmsAzure Storage Account")),
             storageAuthorization);
    end;

    local procedure getSPFolder(documentAttachment: Record "Document Attachment"): text[250]
    var
        companyInformation: Record "Company Information";
        TempafsDirectoryContent: Record "AFS Directory Content" temporary;
        customer: Record Customer;
        vendor: Record Vendor;
        tableMetadata: Record "Table Metadata";
        recordref: RecordRef;
        fieldRef: FieldRef;
        folderName: Text[250];
        recordNo: text[20];
    begin
        companyInformation.get();

        afsFileClient.ListDirectory(copystr(companyInformation."bmsAzure Storage Account", StrPos(companyInformation."bmsAzure Storage Account", '/') + 1, StrLen(companyInformation."bmsAzure Storage Account")), TempafsDirectoryContent);
        TempafsDirectoryContent.SetRange(Name, companyInformation.Name);
        if TempafsDirectoryContent.IsEmpty then
            afsFileClient.CreateDirectory(companyInformation.Name);

        case documentAttachment."Table ID" of
            18, 36, 110, 112, 114:
                begin
                    if documentAttachment."Table ID" <> 18 then begin
                        recordref.Open(documentAttachment."Table ID");
                        fieldRef := recordref.Field(3);
                        fieldRef.SetRange(documentAttachment."No.");
                        if recordref.FindFirst() then begin
                            customer.get(recordref.Field(2).Value);
                            recordNo := customer."No.";
                        end;
                    end else
                        recordNo := documentAttachment."No.";

                    tableMetadata.get(18);
                    folderName := tableMetadata.Caption;
                end;
            23, 120, 122, 124:
                begin
                    if documentAttachment."Table ID" <> 23 then begin
                        recordref.Open(documentAttachment."Table ID");
                        fieldRef := recordref.Field(3);
                        fieldRef.SetRange(documentAttachment."No.");
                        if recordref.FindFirst() then begin
                            vendor.get(recordref.Field(2).Value);
                            recordNo := vendor."No.";
                        end;
                    end else
                        recordNo := documentAttachment."No.";

                    tableMetadata.get(23);
                    folderName := tableMetadata.Caption;
                end;
            else begin
                tableMetadata.get(documentAttachment."Table ID");
                folderName := tableMetadata.Caption;
                recordNo := documentAttachment."No.";
            end;
        end;

        afsFileClient.ListDirectory(DelChr(companyInformation.Name, '=', '"*<>?/\|.'), TempafsDirectoryContent);
        TempafsDirectoryContent.SetRange(Name, folderName);
        if TempafsDirectoryContent.IsEmpty then
            afsFileClient.CreateDirectory(companyInformation.Name + '/' + folderName);

        afsFileClient.ListDirectory(folderName, TempafsDirectoryContent);
        TempafsDirectoryContent.SetRange(Name, recordNo);
        if TempafsDirectoryContent.IsEmpty then
            afsFileClient.CreateDirectory(companyInformation.Name + '/' + folderName + '/' + recordNo);


        exit(copystr((DelChr(companyInformation.Name, '=', '"*<>?/\|.') + '/' + folderName + '/' + recordNo), 1, 250));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnInsertAttachmentOnBeforeImportStream', '', true, true)]
    local procedure HandlingInsertAFSStorage(var DocumentAttachment: Record "Document Attachment"; DocInStream: InStream; FileName: Text; var IsHandled: Boolean)
    var
        companyInformation: Record "Company Information";
        lfileName: Text[250];
    begin
        companyInformation.Get();
        if companyInformation."bmsFile Storage Type" = companyInformation."bmsFile Storage Type"::"Azure File Share" then begin
            IsHandled := true;
            lfileName := CopyStr(FileName, 1, 250);
            HandlingFilesOnAFS(lfileName, DocInStream, DocumentAttachment, 'Upload');
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Document Attachment", 'OnInsertOnBeforeCheckDocRefID', '', true, true)]
    local procedure AllwingInsertAFSStorage(var IsHandled: Boolean; var DocumentAttachment: Record "Document Attachment")
    var
        companyInformation: Record "Company Information";
        fileMngt: Codeunit "File Management";
    begin
        companyInformation.get();
        if companyInformation."bmsFile Storage Type" = companyInformation."bmsFile Storage Type"::"Azure File Share" then begin
            IsHandled := true;
            DocumentAttachment."File Name" := copystr(fileMngt.GetFileNameWithoutExtension(DocumentAttachment."bmsFile Path"), 1, 50);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Document Attachment", 'OnBeforeExport', '', true, true)]
    local procedure HandlingExportAFSStorage(var DocumentAttachment: Record "Document Attachment"; var IsHandled: Boolean)
    var
        companyInformation: Record "Company Information";
        DocInStream: InStream;
    begin
        companyInformation.get();
        if companyInformation."bmsFile Storage Type" = companyInformation."bmsFile Storage Type"::"Azure File Share" then begin
            HandlingFilesOnAFS(DocumentAttachment."File Name", DocInStream, DocumentAttachment, 'Download');
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Document Attachment", 'OnBeforeHasContent', '', true, true)]
    local procedure AllwingExportAFSStorage(var IsHandled: Boolean; var DocumentAttachment: Record "Document Attachment"; var AttachmentIsAvailable: Boolean)
    var
        companyInformation: Record "Company Information";
    begin
        companyInformation.get();
        if companyInformation."bmsFile Storage Type" = companyInformation."bmsFile Storage Type"::"Azure File Share" then
            if DocumentAttachment."bmsFile Path" <> '' then begin
                IsHandled := true;
                AttachmentIsAvailable := true;
            end;
    end;

    var
        afsFileClient: Codeunit "AFS File Client";
}






