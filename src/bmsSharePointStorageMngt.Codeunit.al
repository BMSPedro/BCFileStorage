codeunit 80000 "bmsSharePoint Storage Mngt"
{

    procedure HandlingFilesOnSharepoint(fileName: text[250]; var InStream: InStream; var documentAttachment: Record "Document Attachment"; fileAction: Text[20])
    var
        TempsharePointFolder: Record "SharePoint Folder" temporary;
        TempsharePointFile: Record "SharePoint File" temporary;
    begin
        sharePointConnection();

        TempsharePointFolder := getSPFolder(documentAttachment);

        case fileAction of
            'Download':
                if documentAttachment."bmsFile Path" <> '' then begin
                    sharePointClient.GetFolderFilesByServerRelativeUrl(TempsharePointFolder."Server Relative Url", TempsharePointFile);
                    TempSharePointFile.SetRange(Name, documentAttachment."File Name" + '.' + documentAttachment."File Extension");
                    if TempSharePointFile.FindFirst() then
                        SharePointClient.DownloadFileContent(TempSharePointFile.OdataId, documentAttachment."File Name" + '.' + documentAttachment."File Extension");
                end;
            'Delete':
                if documentAttachment."bmsFile Path" <> '' then begin
                    sharePointClient.GetFolderFilesByServerRelativeUrl(TempsharePointFolder."Server Relative Url", TempsharePointFile);
                    TempSharePointFile.SetRange(Name, documentAttachment."File Name" + '.' + documentAttachment."File Extension");
                    if TempSharePointFile.FindFirst() then
                        SharePointClient.DeleteFile(TempsharePointFile.OdataId)
                end;
            'Upload':
                begin
                    sharePointClient.AddFileToFolder(TempsharePointFolder."Server Relative Url", format(documentAttachment."Table ID") + '-' + documentAttachment."No." + '-' + filename, InStream, TempsharePointFile);
                    documentAttachment."bmsFile Path" := TempsharePointFile."Server Relative Url";
                end;
            'Show':
                if documentAttachment."bmsFile Path" <> '' then begin
                    sharePointClient.GetFolderFilesByServerRelativeUrl(TempsharePointFolder."Server Relative Url", TempsharePointFile);
                    TempSharePointFile.SetRange(Name, documentAttachment."File Name" + '.' + documentAttachment."File Extension");
                    if TempSharePointFile.FindFirst() then
                        SharePointClient.DownloadFileContent(TempSharePointFile.OdataId, InStream);
                end;
        end;
    end;

    local procedure sharePointConnection()
    var
        companyInformation: Record "Company Information";
        sharePointAuth: codeunit "SharePoint Auth.";
        azureTenant: Codeunit "Azure AD Tenant";
        sharePointAuthInt: Interface "SharePoint Authorization";
    begin
        companyInformation.Get();
        sharePointAuthInt := sharePointAuth.CreateAuthorizationCode(azureTenant.GetAadTenantId(), companyInformation."bmsMicrosoft ENTRA Client ID", companyInformation.GetSecretValue(companyInformation."bmsMicrosoft ENTRA Sec. Value"), 'https://axiansfrance.sharepoint.com/.default');
        sharePointClient.Initialize(companyInformation."bmsSharePoint Site Base Url", sharePointAuthInt);
    end;

    local procedure getSPFolder(documentAttachment: Record "Document Attachment"): Record "SharePoint Folder"
    var
        companyInformation: Record "Company Information";
        TempsharePointFolder: Record "SharePoint Folder" temporary;
        tableMetadata: Record "Table Metadata";
        customer: Record Customer;
        vendor: Record Vendor;
        recordref: RecordRef;
        fieldRef: FieldRef;
        folderName: Text[80];
        recordNo: text[20];
        fileRelativeUrl: text;
    begin
        companyInformation.get();

        fileRelativeUrl := copystr(companyInformation."bmsSharePoint Site Base Url", StrPos(companyInformation."bmsSharePoint Site Base Url", 'sites') - 1, StrLen(companyInformation."bmsSharePoint Site Base Url")) + 'Shared Documents/';

        sharePointClient.GetSubFoldersByServerRelativeUrl(fileRelativeUrl, TempsharePointFolder);
        TempsharePointFolder.SetRange(Name, DelChr(companyInformation.Name, '=', '"*<>?/\|.'));
        if TempsharePointFolder.IsEmpty then
            sharePointClient.CreateFolder(fileRelativeUrl + DelChr(companyInformation.Name, '=', '"*<>?/\|.'), TempsharePointFolder);

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

        sharePointClient.GetSubFoldersByServerRelativeUrl(fileRelativeUrl + TempsharePointFolder.Name, TempsharePointFolder);
        TempsharePointFolder.SetRange(Name, folderName);
        if TempsharePointFolder.IsEmpty then begin
            sharePointClient.CreateFolder(fileRelativeUrl + DelChr(companyInformation.Name, '=', '"*<>?/\|.') + '/' + folderName, TempsharePointFolder);
            sharePointClient.CreateFolder(fileRelativeUrl + DelChr(companyInformation.Name, '=', '"*<>?/\|.') + '/' + folderName + '/' + recordNo, TempsharePointFolder)
        end else begin
            sharePointClient.GetSubFoldersByServerRelativeUrl(fileRelativeUrl + TempsharePointFolder.Name + folderName, TempsharePointFolder);
            TempsharePointFolder.SetRange(Name, recordNo);
            if TempsharePointFolder.IsEmpty then
                sharePointClient.CreateFolder(fileRelativeUrl + DelChr(companyInformation.Name, '=', '"*<>?/\|.') + '/' + folderName + '/' + recordNo, TempsharePointFolder)
        end;

        exit(TempsharePointFolder);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnInsertAttachmentOnBeforeImportStream', '', true, true)]
    local procedure HandlingInsertSPStorage(var DocumentAttachment: Record "Document Attachment"; DocInStream: InStream; FileName: Text; var IsHandled: Boolean)
    var
        companyInformation: Record "Company Information";
        lfileName: Text[250];
    begin
        companyInformation.Get();
        if companyInformation."bmsFile Storage Type" = companyInformation."bmsFile Storage Type"::SharePoint then begin
            IsHandled := true;
            lfileName := CopyStr(FileName, 1, 250);
            HandlingFilesOnSharepoint(lfileName, DocInStream, DocumentAttachment, 'Upload');
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Document Attachment", 'OnInsertOnBeforeCheckDocRefID', '', true, true)]
    local procedure AllowingInsertSPStorage(var IsHandled: Boolean; var DocumentAttachment: Record "Document Attachment")
    var
        companyInformation: Record "Company Information";
        fileMngt: Codeunit "File Management";
    begin
        companyInformation.get();
        if companyInformation."bmsFile Storage Type" = companyInformation."bmsFile Storage Type"::SharePoint then begin
            IsHandled := true;
            DocumentAttachment."File Name" := copystr(fileMngt.GetFileNameWithoutExtension(DocumentAttachment."bmsFile Path"), 1, 50);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Document Attachment", 'OnBeforeExport', '', true, true)]
    local procedure HandlingExportSPStorage(var DocumentAttachment: Record "Document Attachment"; var IsHandled: Boolean)
    var
        companyInformation: Record "Company Information";
        DocInStream: InStream;
    begin
        companyInformation.get();
        if companyInformation."bmsFile Storage Type" = companyInformation."bmsFile Storage Type"::SharePoint then begin
            HandlingFilesOnSharepoint(DocumentAttachment."File Name", DocInStream, DocumentAttachment, 'Download');
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Document Attachment", 'OnBeforeHasContent', '', true, true)]
    local procedure AllowingExportSPStorage(var IsHandled: Boolean; var DocumentAttachment: Record "Document Attachment"; var AttachmentIsAvailable: Boolean)
    var
        companyInformation: Record "Company Information";
    begin
        companyInformation.get();
        if companyInformation."bmsFile Storage Type" = companyInformation."bmsFile Storage Type"::SharePoint then
            if DocumentAttachment."bmsFile Path" <> '' then begin
                IsHandled := true;
                AttachmentIsAvailable := true;
            end;
    end;

    var
        sharePointClient: codeunit "SharePoint Client";

}