page 80001 "bmsPDFV PDF Viewer Factbox"
{

    Caption = 'PDF Viewer';
    PageType = CardPart;
    SourceTable = "Document Attachment";
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                ShowCaption = false;
                usercontrol(PDFViewer; "bmsPDFV PDF Viewer")
                {
                    ApplicationArea = All;
                    trigger onView()
                    begin
                        RunFullView();
                    end;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(PDFVViewFullDocument)
            {
                ApplicationArea = All;
                Image = View;
                Caption = 'View';
                ToolTip = 'View';
                trigger OnAction()
                begin
                    RunFullView();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        SetPDFDocument();
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

        CurrPage.PDFViewer.LoadPDF(PDFAsTxt, true);
        CurrPage.Update(false);
    end;

    local procedure RunFullView()
    var
        PDFViewerCard:
            Page "bmsPDFV PDF Viewer";
    begin
        PDFViewerCard.SetRecord(Rec);
        PDFViewerCard.RunModal();
    end;

}