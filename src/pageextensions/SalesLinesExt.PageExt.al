pageextension 50136 "SalesLinesExt" extends "Sales Lines"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("Promised Delivery Date"; Rec."Promised Delivery Date")
            {
                ApplicationArea = All;
                ToolTip = 'Promised Delivery Date';
            }
        }

        addafter("No.")
        {
            field("Item Reference No."; Rec."Item Reference No.")
            {
                ApplicationArea = All;
                ToolTip = 'Item Reference No.';
            }
        }
    }
    actions
    {
        addafter("Item &Tracking Lines")
        {
            action("Delete Lines")
            {
                ApplicationArea = All;
                Image = EntriesList;
                ToolTip = 'Delete Lines';
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
                ToolTip = 'Validate Drop-Ship';
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

