pageextension 50118 "SalesCrMemLineExt" extends "Sales Cr. Memo Subform"
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
