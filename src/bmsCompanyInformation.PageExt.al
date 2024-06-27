pageextension 80000 "bmsCompany Information" extends "Company Information"
{
    layout
    {
        addafter(Picture)
        {
            field("bmsFile Storage Type"; Rec."bmsFile Storage Type")
            {
                ApplicationArea = all;
                ToolTip = 'File Storage Type';
                Caption = 'File Storage Type';
            }
            group(bmsSharePoint)
            {
                ShowCaption = false;
                Visible = rec."bmsFile Storage Type" = rec."bmsFile Storage Type"::SharePoint;
                field("bmsSharePoint Site Base Url"; Rec."bmsSharePoint Site Base Url")
                {
                    ApplicationArea = all;
                    ToolTip = 'SharePoint Site Base Url';
                    Caption = 'SharePoint Site Base Url';
                }
                field("bmsMicrosoft ENTRA App. Client ID"; Rec."bmsMicrosoft ENTRA Client ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Microsoft ENTRA App. Client ID';
                    Caption = 'Microsoft ENTRA App. Client ID';
                }
                field("bmsMicrosoft ENTRA App. Secret Value Key"; appSecretValue)
                {
                    ApplicationArea = all;
                    ToolTip = 'Microsoft ENTRA App. Secret Value Key';
                    ExtendedDatatype = Masked;
                    Caption = 'Microsoft ENTRA App. Secret Value Key';
                    trigger OnValidate()
                    begin
                        rec.SetSecretValue(appSecretValue);
                    end;
                }
            }
            group(bmsAzureStorage)
            {
                ShowCaption = false;
                Visible = rec."bmsFile Storage Type" = rec."bmsFile Storage Type"::"Azure File Share";
                field("bmsAzure Storage Account"; Rec."bmsAzure Storage Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Azure Storage Account';
                    Caption = 'File Storage Type';
                }
                field("bmsAFS SaaS Connection String"; rec."bmsAFS SaaS Connection String")
                {
                    ApplicationArea = all;
                    ToolTip = 'Azure File Share SaaS Connzction String';
                    ExtendedDatatype = Masked;
                    Caption = 'Azure File Share SaaS Connection String';
                }
            }
        }
    }
    var
        appSecretValue: text;

    trigger OnOpenPage()
    begin
        if not IsNullGuid(Rec."bmsMicrosoft ENTRA Sec. Value") then
            appSecretValue := '***';
    end;


}