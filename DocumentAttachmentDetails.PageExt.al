pageextension 80001 "Document Attachment Details" extends "Document Attachment Details"
{
    layout
    {
        addafter(Name)
        {
            field("File Path"; Rec."File Path")
            {
                ApplicationArea = all;
                ToolTip = 'File Path';
            }
        }
    }
    trigger OnDeleteRecord(): Boolean
    var
        companyInformation: Record "Company Information";
        sharePointMngt: Codeunit "SharePoint Storage Mngt";
        AzureStorageMngt: Codeunit "Azure Storage Mngt";
        docInstream: InStream;
    begin
        companyInformation.get();
        if companyInformation."File Storage Type" = companyInformation."File Storage Type"::SharePoint then
            sharePointMngt.HandlingFilesOnSharepoint(rec."File Name", docInstream, rec, 'Delete');

        if companyInformation."File Storage Type" = companyInformation."File Storage Type"::"Azure File Share" then
            AzureStorageMngt.HandlingFilesOnafs(rec."File Name", docInstream, rec, 'Delete');
    end;
}