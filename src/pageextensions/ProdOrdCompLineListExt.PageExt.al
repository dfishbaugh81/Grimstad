pageextension 50144 "ProdOrdCompLineListExt" extends "Prod. Order Comp. Line List"
{
    layout
    {
        addafter("Prod. Order Line No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Line No.';
                Visible = true;
            }
        }
        addafter("Remaining Quantity")
        {
            field("Qty. Picked"; Rec."Qty. Picked")
            {
                ApplicationArea = All;
                ToolTip = 'Qty. Picked';
            }
        }
    }
}
