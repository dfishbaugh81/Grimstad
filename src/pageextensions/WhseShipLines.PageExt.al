pageextension 50124 "WhseShipLines" extends "Whse. Shipment Lines"
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

