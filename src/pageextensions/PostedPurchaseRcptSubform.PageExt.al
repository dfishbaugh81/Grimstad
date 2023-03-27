pageextension 50154 "PostedPurchaseRcptSubform" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Sales Order No.";Rec."Sales Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Sales Order No.';                
            }
        }
    }
}
