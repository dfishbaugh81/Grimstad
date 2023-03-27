pageextension 50143 "FirmPlannedProdOrderLineExt" extends "Firm Planned Prod. Order Lines"
{
    layout
    {
        addbefore("Due Date")
        {
            field(ComponentCount; Rec.ComponentCount)
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Component Count';
            }
            field("Total Run Time";Rec."Total Run Time")
            {
                ApplicationArea = All;
                ToolTip = 'Total Run Time';
            }
        }
        modify("Description 2")
        {

            ApplicationArea = All;
            Visible = true;

        }
    }
}

