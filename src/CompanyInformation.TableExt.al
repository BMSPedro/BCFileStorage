tableextension 80000 "Company Information" extends "Company Information"
{
    fields
    {

        field(80000; "File Storage Type"; Enum "File Storage Options")
        {
        }
        field(80001; "SharePoint Site Base Url"; Text[250])
        {
            ExtendedDatatype = URL;
        }
        field(80002; "Azure Storage Account"; Text[100])
        {
        }
        field(80003; "Microsoft ENTRA App. Client ID"; guid)
        {
        }
        field(80004; "Microsoft ENTRA App Sec. Value"; guid)
        {
        }
        field(80005; "AFS SaaS Connection String"; text[1024])
        {
        }
    }

    var
        UnableToSetAPPSecretValueLbl: Label 'Unable to set APP Secret value';

    trigger OnDelete()
    begin
        if not IsNullGuid(Rec."Microsoft ENTRA App Sec. Value") then
            if IsolatedStorage.Delete(Rec."Microsoft ENTRA App Sec. Value") then;
    end;

    [NonDebuggable]
    procedure SetSecretValue(Password: SecretText)
    begin
        if IsNullGuid(Rec."Microsoft ENTRA App Sec. Value") then
            Rec."Microsoft ENTRA App Sec. Value" := CreateGuid();

        if not IsolatedStorage.Set(Format(Rec."Microsoft ENTRA App Sec. Value"), Password, DataScope::Company) then
            Error(UnableToSetAPPSecretValueLbl);
    end;

    [NonDebuggable]
    procedure GetSecretValue(PasswordKey: Guid) Password: SecretText
    begin
        if not IsolatedStorage.Get(Format(PasswordKey), DataScope::Company, Password) then
            Error(UnableToSetAPPSecretValueLbl);
    end;

}