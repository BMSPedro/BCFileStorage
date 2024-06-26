pageextension 80000 "Company Information" extends "Company Information"
{
    layout
    {
        addafter(Picture)
        {
            field("File Storage Type"; Rec."File Storage Type")
            {
                ApplicationArea = all;
                ToolTip = 'File Storage Type';
            }
            group(SharePoint)
            {
                ShowCaption = false;
                Visible = rec."File Storage Type" = rec."File Storage Type"::SharePoint;
                field("SharePoint Site Base Url"; Rec."SharePoint Site Base Url")
                {
                    ApplicationArea = all;
                    ToolTip = 'SharePoint Site Base Url';
                }
                field("Microsoft ENTRA App. Client ID"; Rec."Microsoft ENTRA App. Client ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Microsoft ENTRA App. Client ID';
                }
                field("Microsoft ENTRA App. Secret Value Key"; appSecretValue)
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
            group(AzureStorage)
            {
                ShowCaption = false;
                Visible = rec."File Storage Type" = rec."File Storage Type"::"Azure File Share";
                field("Azure Storage Account"; Rec."Azure Storage Account")
                {
                    ApplicationArea = all;
                    ToolTip = 'Azure Storage Account';
                }
                field("AFS SaaS Connection String"; rec."AFS SaaS Connection String")
                {
                    ApplicationArea = all;
                    ToolTip = 'Azure File Share SaaS Connzction String';
                    ExtendedDatatype = Masked;
                    Caption = 'Azure File Share SaaS Connzction String';
                }
            }
        }
    }
    var
        appSecretValue: text;

    trigger OnOpenPage()
    begin
        if not IsNullGuid(Rec."Microsoft ENTRA App Sec. Value") then
            appSecretValue := '***';
    end;


}