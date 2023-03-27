pageextension 50155 "PostedPurchaseInvoice" extends "Posted Purchase Invoice"
{
    layout
    {
        addlast(General)
        {
            field("On Hold"; Rec."On Hold")
            {
                ApplicationArea = All;
                ToolTip = 'On Hold';
            }
        }
    }
}
