pageextension 50120 "PurchCrMemLineExt" extends "Purch. Cr. Memo Subform"
{
    layout
    {
        modify("Description 2")
        {
            ApplicationArea = Basic, Suite;
            Importance = Additional;
            ToolTip = 'Specifies information in addition to the description.';
            Visible = true;
        }
    }
}
