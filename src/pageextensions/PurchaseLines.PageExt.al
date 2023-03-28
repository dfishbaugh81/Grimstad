pageextension 50156 "PurchaseLines" extends "Purchase Lines"
{
    layout
    {
        addbefore("Expected Receipt Date")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
                ToolTip = 'Order Date';
            }
        }
    }
    actions
    {
        addbefore("Show Document")
        {
            action("Validate Missing Items")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Visible = true;

                trigger OnAction()
                var
                    purchLine: Record "Purchase Line";
                    purchHeader: Record "Purchase Header";
                    priceValue: Decimal;
                    qtyValue: Decimal;
                begin
                    CurrPage.SetSelectionFilter(purchLine);
                    if purchLine.FindFirst()then repeat purchLine.Validate("No.", purchLine."No.");
                            purchLine.Modify(true);
                        until purchLine.Next() = 0;
                end;
            }
        }
    }
}
