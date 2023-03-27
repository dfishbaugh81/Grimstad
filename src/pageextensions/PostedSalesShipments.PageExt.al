pageextension 50140 "PostedSalesShipments" extends "Posted Sales Shipments"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = All;
                ToolTip = 'Order Date';
            }
            field("Promised Delivery Date"; Rec."Promised Delivery Date")
            {
                ApplicationArea = All;
                ToolTip = 'Promised Delivery Date';
            }
        }
    }
}
