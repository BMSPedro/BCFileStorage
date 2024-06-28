page 80000 "bmsPDF Viewer"
{

    Caption = 'PDF Viewer';
    PageType = CardPart;
    UsageCategory = None;
    DataCaptionExpression = pageTitle;
    SourceTable = "Document Attachment";

    layout
    {
        area(content)
        {
            group(General)
            {
                ShowCaption = false;
                usercontrol(PDFViewer; "bmsPDF Viewer")
                {
                    ApplicationArea = All;

                    trigger ControlAddinReady()
                    begin
                        SetPDFDocument();
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        pageTitle := rec."bmsFile Path"
    end;

    local procedure SetPDFDocument()
    var
        companyInformation: Record "Company Information";
        Base64Convert: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        bmsSharePointStorageMngt: Codeunit "bmsSharePoint Storage Mngt";
        bmsAzureStorage: Codeunit "bmsAzure Storage Mngt";
        InStreamVar: InStream;
        OutStreamVar: OutStream;
        PDFAsTxt: Text;
    begin
        companyInformation.get();
        case companyInformation."bmsFile Storage Type" of
            companyInformation."bmsFile Storage Type"::" ":
                begin
                    if not rec."Document Reference ID".HasValue then
                        exit;

                    TempBlob.CreateInStream(InStreamVar);
                    TempBlob.CreateOutStream(OutStreamVar);
                    Rec."Document Reference ID".ExportStream(OutStreamVar);
                end;
            companyInformation."bmsFile Storage Type"::SharePoint:
                bmsSharePointStorageMngt.HandlingFilesOnSharepoint('', InStreamVar, Rec, 'Show');
            companyInformation."bmsFile Storage Type"::"Azure File Share":
                bmsAzureStorage.HandlingFilesOnAFS('', InStreamVar, rec, 'Show');
            else
        end;
        CurrPage.PDFViewer.SetVisible(true);
        PDFAsTxt := Base64Convert.ToBase64(InStreamVar);

        CurrPage.PDFViewer.LoadPDF(PDFAsTxt, false);
    end;

    var
        pageTitle: text;
}