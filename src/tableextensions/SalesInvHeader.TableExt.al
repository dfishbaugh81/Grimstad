tableextension 50113 "SalesInvHeader" extends "Sales Invoice Header"
{
    fields
    {
        field(50101; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
        }
    }
    procedure GetFreightAmount(): Decimal var
        SalesInvLine: Record "Sales Invoice Line";
        fAmount: Decimal;
    begin
        fAmount:=0;
        SalesInvLine.SetRange("Document No.", Rec."No.");
        SalesInvLine.SetFilter(Type, '<>%1', SalesInvLine.Type::"Item");
        SalesInvLine.SetFilter(Description, '@*Freight*');
        if SalesInvLine.FindFirst()then repeat fAmount:=fAmount + SalesInvLine."Line Amount";
            until SalesInvLine.Next() = 0;
        exit(fAmount);
    end;
    procedure GetMiscAmount(): Decimal var
        SalesInvLine: Record "Sales Invoice Line";
        mAmount: Decimal;
    begin
        mAmount:=0;
        SalesInvLine.SetRange("Document No.", Rec."No.");
        SalesInvLine.SetFilter(Type, '<>%1', SalesInvLine.Type::"Item");
        SalesInvLine.SetFilter(Description, '<>@*Freight*');
        if SalesInvLine.FindFirst()then repeat mAmount:=mAmount + SalesInvLine."Line Amount";
            until SalesInvLine.Next() = 0;
        exit(mAmount);
    end;
    procedure GetSalesAmount(): Decimal var
        SalesInvLine: Record "Sales Invoice Line";
        sAmount: Decimal;
    begin
        sAmount:=0;
        SalesInvLine.SetRange("Document No.", Rec."No.");
        SalesInvLine.SetRange(Type, SalesInvLine.Type::"Item");
        if SalesInvLine.FindFirst()then repeat sAmount:=sAmount + SalesInvLine.GetLineAmountExclVAT();
            until SalesInvLine.Next() = 0;
        exit(sAmount);
    end;
}
