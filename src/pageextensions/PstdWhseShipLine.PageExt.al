pageextension 50125 "PstdWhseShipLine" extends "Posted Whse. Shipment Subform"
{
    layout
    {
        modify("Description 2")
        {
            ApplicationArea = All;
            Importance = Promoted;
            ToolTip = 'Specifies information in addition to the description.';
            Visible = true;
        }
    }
}
