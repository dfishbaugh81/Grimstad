tableextension 50114 "SalesCrMemHeader" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50101; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
        }
    }

    procedure GetRemainingAmount(): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.SetRange("Customer No.", "Bill-to Customer No.");
        CustLedgerEntry.SetRange("Posting Date", "Posting Date");
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SetRange("Document No.", "No.");
        CustLedgerEntry.SetAutoCalcFields("Remaining Amount");

        if not CustLedgerEntry.FindFirst() then
            exit(0);

        exit(CustLedgerEntry."Remaining Amount");
    end;

    procedure GetFreightAmount(): Decimal
    var
        SalesCrMemLine: Record "Sales Cr.Memo Line";
        fAmount: Decimal;
    begin
        fAmount := 0;
        SalesCrMemLine.SetRange("Document No.", Rec."No.");
        SalesCrMemLine.SetFilter(Type, '<>%1', SalesCrMemLine.Type::"Item");
        SalesCrMemLine.SetFilter(Description, '@*Freight*');
        if SalesCrMemLine.FindFirst() then
            repeat
                fAmount := fAmount + SalesCrMemLine."Line Amount";
            until SalesCrMemLine.Next() = 0;
        exit(fAmount * -1);
    end;

    procedure GetMiscAmount(): Decimal
    var
        SalesCrMemLine: Record "Sales Cr.Memo Line";
        mAmount: Decimal;
    begin
        mAmount := 0;
        SalesCrMemLine.SetRange("Document No.", Rec."No.");
        SalesCrMemLine.SetFilter(Type, '<>%1', SalesCrMemLine.Type::"Item");
        SalesCrMemLine.SetFilter(Description, '<>@*Freight*');
        if SalesCrMemLine.FindFirst() then
            repeat
                mAmount := mAmount + SalesCrMemLine."Line Amount" + SalesCrMemLine."Line Discount Amount";
                ;
            until SalesCrMemLine.Next() = 0;
        exit(mAmount * -1);
    end;

    procedure GetCreMemAmount(): Decimal
    var
        SalesCrMemLine: Record "Sales Cr.Memo Line";
        sAmount: Decimal;
    begin
        sAmount := 0;
        SalesCrMemLine.SetRange("Document No.", Rec."No.");
        SalesCrMemLine.SetRange(Type, SalesCrMemLine.Type::"Item");
        if SalesCrMemLine.FindFirst() then
            repeat
                sAmount := sAmount + SalesCrMemLine.GetLineAmountExclVAT() + SalesCrMemLine."Line Discount Amount";
                ;
            until SalesCrMemLine.Next() = 0;
        exit(sAmount * -1);
    end;

    procedure GetVatAmount(): Decimal
    var
        SalesCrMemLine: Record "Sales Cr.Memo Line";
        sAmount: Decimal;
    begin
        sAmount := 0;
        SalesCrMemLine.SetRange("Document No.", Rec."No.");
        SalesCrMemLine.SetRange(Type, SalesCrMemLine.Type::"Item");
        if SalesCrMemLine.FindFirst() then
            repeat
                sAmount := sAmount + (SalesCrMemLine."Amount Including VAT" - SalesCrMemLine.GetLineAmountExclVAT());
            until SalesCrMemLine.Next() = 0;
        exit(sAmount * -1);
    end;

    procedure GetDiscAmount(): Decimal
    var
        SalesCrMemLine: Record "Sales Cr.Memo Line";
        sAmount: Decimal;
    begin
        sAmount := 0;
        SalesCrMemLine.SetRange("Document No.", Rec."No.");
        SalesCrMemLine.SetRange(Type, SalesCrMemLine.Type::"Item");
        if SalesCrMemLine.FindFirst() then
            repeat
                sAmount := sAmount + SalesCrMemLine."Line Discount Amount";
            until SalesCrMemLine.Next() = 0;
        exit(sAmount);
    end;

    procedure GetSubTotalTotAmount(): Decimal
    var
        SalesCrMemLine: Record "Sales Cr.Memo Line";
        sAmount: Decimal;
    begin
        sAmount := 0;
        SalesCrMemLine.SetRange("Document No.", Rec."No.");
        //SalesCrMemLine.SetRange(Type, SalesCrMemLine.Type::"Item");
        if SalesCrMemLine.FindFirst() then
            repeat
                sAmount := sAmount + SalesCrMemLine."Amount Including VAT" + SalesCrMemLine."Line Discount Amount";
            until SalesCrMemLine.Next() = 0;
        exit(sAmount * -1);
    end;
}

