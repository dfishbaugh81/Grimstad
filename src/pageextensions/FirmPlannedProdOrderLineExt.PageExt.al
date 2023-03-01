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
            }
        }
        modify("Description 2")
        {

            ApplicationArea = All;
            Visible = true;

        }
    }
}

