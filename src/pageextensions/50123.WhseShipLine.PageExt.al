pageextension 50123 "WhseShipLine" extends "Whse. Shipment Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies information in addition to the description.';
                Visible = true;
            }
        }
    }
}

