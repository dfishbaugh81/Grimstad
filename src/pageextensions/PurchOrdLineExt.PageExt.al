pageextension 50119 "PurchOrdLineExt" extends "Purchase Order Subform"
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

        addafter("Tax Area Code")
        {
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                ToolTip = 'Specifies information in addition to the description.';
                Visible = true;

            }

        }
    }
}

