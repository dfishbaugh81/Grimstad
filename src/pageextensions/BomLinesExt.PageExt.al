pageextension 50115 "BomLinesExt" extends "Production BOM Lines"
{
    layout
    {
        addbefore("No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Importance = Standard;
                ToolTip = 'Specifies Line No.';
                Visible = true;
            }
        }
    }
}
