tableextension 50110 ItemExt extends Item
{
    fields
    {

        modify("Description 2")
        {
            Caption = 'Description 2';

        }

        field(50101; "Manufacturer"; code[20])
        {
            Caption = 'Manufacturer';
        }

        field(50102; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
        }

    }
}

tableextension 50111 BomLines extends "Production BOM Line"
{
    fields
    {
        field(50100; "Description 2"; Text[60])
        {
            Caption = 'Description 2';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Description 2" where("No." = field("No.")));

        }

        field(50101; "Component Count"; Integer)
        {
            Caption = 'Component Count';
            FieldClass = FlowField;
            CalcFormula = count("Production BOM Line" where("Production BOM No." = field("No.")));
        }
    }
}

tableextension 50112 SalesHeader extends "Sales Header"
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

tableextension 50113 SalesInvHeader extends "Sales Invoice Header"
{
    fields
    {
        field(50101; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
        }
    }

    procedure GetFreightAmount(): Decimal
    var
        SalesInvLine: Record "Sales Invoice Line";
        fAmount: Decimal;
    begin
        fAmount := 0;
        SalesInvLine.SetRange("Document No.", Rec."No.");
        SalesInvLine.SetFilter(Type, '<>%1', SalesInvLine.Type::"Item");
        SalesInvLine.SetFilter(Description, '@*Freight*');
        if SalesInvLine.FindFirst() then
            repeat
                fAmount := fAmount + SalesInvLine."Line Amount";
            until SalesInvLine.Next() = 0;
        exit(fAmount);
    end;

    procedure GetMiscAmount(): Decimal
    var
        SalesInvLine: Record "Sales Invoice Line";
        mAmount: Decimal;
    begin
        mAmount := 0;
        SalesInvLine.SetRange("Document No.", Rec."No.");
        SalesInvLine.SetFilter(Type, '<>%1', SalesInvLine.Type::"Item");
        SalesInvLine.SetFilter(Description, '<>@*Freight*');
        if SalesInvLine.FindFirst() then
            repeat
                mAmount := mAmount + SalesInvLine."Line Amount";
            until SalesInvLine.Next() = 0;
        exit(mAmount);
    end;

    procedure GetSalesAmount(): Decimal
    var
        SalesInvLine: Record "Sales Invoice Line";
        sAmount: Decimal;
    begin
        sAmount := 0;
        SalesInvLine.SetRange("Document No.", Rec."No.");
        SalesInvLine.SetRange(Type, SalesInvLine.Type::"Item");
        if SalesInvLine.FindFirst() then
            repeat
                sAmount := sAmount + SalesInvLine.GetLineAmountExclVAT();
            until SalesInvLine.Next() = 0;
        exit(sAmount);
    end;
}

tableextension 50114 SalesCrMemHeader extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50101; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
        }
    }
}

tableextension 50115 PurchHead extends "Purchase Header"
{
    fields
    {
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            var
                orderAddress: Record "Order Address";
                DataExch: Record "Data Exch. Field Mapping";
            begin
                orderAddress.Reset;
                orderAddress.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
                if orderAddress.FindFirst() then begin
                    Rec.Validate("Order Address Code", orderAddress.Code);
                end;
            end;
        }
    }
}

tableextension 50116 SalesLine extends "Sales Line"
{
    fields
    {

        modify("Requested Delivery Date")
        {
            trigger OnAfterValidate()
            begin

            end;
        }
    }

}

tableextension 50117 ReqWorkLine extends "Requisition Line"
{
    fields
    {
        field(50100; "Vendor Name"; text[100])
        {
            Caption = 'Vendor Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
        }
    }
}

tableextension 50118 ProdOrder extends "Production Order"
{
    fields
    {
        field(50100; "Finished Quantity"; Decimal)
        {
            Caption = 'Finished Quantity';
            FieldClass = FlowField;
            CalcFormula = lookup("Prod. Order Line"."Finished Quantity" where("Prod. Order No." = field("No."), "Item No." = field("Source No.")));
        }
    }
}

tableextension 50122 ProdOrdComp extends "Prod. Order Component"
{
    fields
    {
        field(50100; "Description 2"; Text[60])
        {
            Caption = 'Description 2';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Description 2" where("No." = field("Item No.")));
        }

    }
}

tableextension 50123 SalesInvLine extends "Sales Invoice Line"
{
    fields
    {
        field(50105; InvoiceDate; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Header"."Posting Date" where("No." = field("Document No.")));
        }
    }
}

tableextension 50124 ProdOrdLineExt extends "Prod. Order Line"
{
    fields
    {
        field(50101; ComponentCount; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Prod. Order Component" where("Prod. Order No." = field("Prod. Order No."), "Prod. Order Line No." = field("Line No.")));
        }
    }
}



