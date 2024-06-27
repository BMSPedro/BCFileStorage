pageextension 80001 "bmsDocument Attachment Details" extends "Document Attachment Details"
{
    layout
    {
        addafter(Name)
        {
            field("bmsFile Path"; Rec."bmsFile Path")
            {
                ApplicationArea = all;
                ToolTip = 'File Path';
                Caption = 'File Path';
            }
        }
        addlast(FactBoxes)
        {
            part("bmsPDFV PDF Viewer Factbox"; "bmsPDFV PDF Viewer Factbox")
            {
                ApplicationArea = all;
                SubPageLink = "Table ID" = field("Table ID"), "No." = field("No."), "Document Type" = field("Document Type"), "Line No." = field("Line No."), ID = field(ID);
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        //CurrPage."bmsPDFV PDF Viewer Factbox".Page.Update(false);
    end;

    trigger OnAfterGetRecord()
    begin
        //CurrPage.Update(false);
        //CurrPage."bmsPDFV PDF Viewer Factbox".Page.Update(false);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        companyInformation: Record "Company Information";
        sharePointMngt: Codeunit "bmsSharePoint Storage Mngt";
        AzureStorageMngt: Codeunit "bmsAzure Storage Mngt";
        docInstream: InStream;
    begin
        companyInformation.get();
        if companyInformation."bmsFile Storage Type" = companyInformation."bmsFile Storage Type"::SharePoint then
            sharePointMngt.HandlingFilesOnSharepoint(rec."File Name", docInstream, rec, 'Delete');

        if companyInformation."bmsFile Storage Type" = companyInformation."bmsFile Storage Type"::"Azure File Share" then
            AzureStorageMngt.HandlingFilesOnafs(rec."File Name", docInstream, rec, 'Delete');
    end;
}