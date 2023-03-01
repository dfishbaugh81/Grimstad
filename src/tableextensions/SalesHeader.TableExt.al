tableextension 50112 "SalesHeader" extends "Sales Header"
{
    fields
    {
        field(50101; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Territory Code" where("No." = field("Sell-to Customer No.")));

        }
        field(50100; "Item No Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(50102; "ASN"; Boolean)
        {
            Caption = 'ASN';
            FieldClass = Normal;
        }

        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                Cust: Record Customer;
            begin
                if Cust.Get(Rec."Sell-to Customer No.") then
                    if Cust.ASN then
                        Rec.Validate(ASN, true);
            end;
        }
    }

    procedure GetUserNameFromSecurityId(userSecurityID: Guid): Code[50]
    var
        User: Record User;
        UserName: Text;
    begin
        UserName := '';
        if userSecurityID <> '{00000000-0000-0000-0000-000000000000}' then begin
            User.Get(userSecurityID);
            UserName := User."User Name";
        end;

        exit(UserName);
    end;
}

