tableextension 80000 "bmsCompany Information" extends "Company Information"
{
    fields
    {

        field(80000; "bmsFile Storage Type"; Enum "bmsFile Storage Options")
        {
        }
        field(80001; "bmsSharePoint Site Base Url"; Text[250])
        {
            ExtendedDatatype = URL;
        }
        field(80002; "bmsAzure Storage Account"; Text[100])
        {
        }
        field(80003; "bmsMicrosoft ENTRA Client ID"; guid)
        {
        }
        field(80004; "bmsMicrosoft ENTRA Sec. Value"; guid)
        {
        }
        field(80005; "bmsAFS SaaS Connection String"; text[1024])
        {
        }
    }

    var
        UnableToSetAPPSecretValueLbl: Label 'Unable to set APP Secret value';

    trigger OnDelete()
    begin
        if not IsNullGuid(Rec."bmsMicrosoft ENTRA Sec. Value") then
            if IsolatedStorage.Delete(Rec."bmsMicrosoft ENTRA Sec. Value") then;
    end;

    [NonDebuggable]
    procedure SetSecretValue(Password: SecretText)
    begin
        if IsNullGuid(Rec."bmsMicrosoft ENTRA Sec. Value") then
            Rec."bmsMicrosoft ENTRA Sec. Value" := CreateGuid();

        if not IsolatedStorage.Set(Format(Rec."bmsMicrosoft ENTRA Sec. Value"), Password, DataScope::Company) then
            Error(UnableToSetAPPSecretValueLbl);
    end;

    [NonDebuggable]
    procedure GetSecretValue(PasswordKey: Guid) Password: SecretText
    begin
        if not IsolatedStorage.Get(Format(PasswordKey), DataScope::Company, Password) then
            Error(UnableToSetAPPSecretValueLbl);
    end;

}