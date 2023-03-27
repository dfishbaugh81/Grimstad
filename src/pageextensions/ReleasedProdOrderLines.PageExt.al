pageextension 50153 "ReleasedProdOrderLines" extends "Released Prod. Order Lines"
{
    layout
    {
        addafter("Due Date")
        {
            field(ComponentCount; Rec.ComponentCount)
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Component Count';
            }
            field("Total Run Time"; Rec."Total Run Time")
            {
                ApplicationArea = All;
                ToolTip = 'Total Run Time';
            }
        }
        modify("Description 2")
        {
            Caption = 'Description 2';
            ApplicationArea = All;
            Visible = true;
        }
    }
}
