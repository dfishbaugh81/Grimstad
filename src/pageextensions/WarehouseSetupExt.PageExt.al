pageextension 50157 "Warehouse Setup Ext." extends "Warehouse Setup"
{
    layout
    {
        addlast(General)
        {
            field("Print Item Label on Receipt"; Rec."Print Item Label on Receipt")
            {
                ApplicationArea = All;
                ToolTip = 'Print Item Label on Receipt';
            }
        }
    }
}
