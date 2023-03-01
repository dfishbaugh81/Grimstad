tableextension 50126 "CustomerExt" extends Customer
{
    fields
    {
        field(50101; ASN; Boolean)
        {
            FieldClass = Normal;
            Caption = 'ASN';
            trigger OnValidate()
            var
                SalesHeader: Record "Sales Header";
                shCount: Integer;
                SalesOrderMgmt: Codeunit "Release Sales Document";
            begin
                shCount := 0;
                SalesHeader.Reset;
                SalesHeader.SetRange("Sell-to Customer No.", Rec."No.");
                shCount := SalesHeader.Count();
                if shCount > 0 then
                    if Confirm('Would you like to assign existing Sales Orders the ASN flag?', true, true) then begin
                        if SalesHeader.FindFirst() then
                            repeat
                                if SalesHeader.Status = SalesHeader.Status::Open then begin
                                    SalesHeader.Validate(ASN, true);
                                    SalesHeader.Modify(true);
                                end else begin
                                    //alesOrderMgmt.PerformManualReopen(SalesHeader);
                                    SalesHeader.ASN := true;
                                    SalesHeader.Modify(false);
                                    //SalesOrderMgmt.PerformManualRelease(SalesHeader);
                                end;
                            until SalesHeader.Next() = 0;

                    end;
            end;

        }
    }
}



