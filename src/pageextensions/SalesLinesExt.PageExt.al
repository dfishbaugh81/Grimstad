pageextension 50136 "SalesLinesExt" extends "Sales Lines"
{
    actions
    {
        addafter("Item &Tracking Lines")
        {
            action("Delete Lines")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Visible = true;

                trigger OnAction()
                var
                    salesLine: Record "Sales Line";
                    salesHeader: Record "Sales Header";
                    priceValue: Decimal;
                    qtyValue: Decimal;
                begin
                    CurrPage.SetSelectionFilter(salesLine);
                    salesLine.DeleteAll();
                end;
            }

            action("Validate Drop-Ship")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Visible = true;

                trigger OnAction()
                var
                    salesLine: Record "Sales Line";
                    salesHeader: Record "Sales Header";
                    priceValue: Decimal;
                    qtyValue: Decimal;
                begin
                    CurrPage.SetSelectionFilter(salesLine);
                    if salesLine.FindFirst() then
                        repeat
                            salesLine.Validate("Drop Shipment", true);
                            salesLine.Modify(true);
                        until salesLine.Next() = 0;
                end;
            }
        }
    }
}

