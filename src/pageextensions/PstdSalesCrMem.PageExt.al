pageextension 50130 "PstdSalesCrMem" extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("Work Description")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Posting Description';
            }
            field("Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies the Territory for the Customer.';
                Visible = true;
            }
        }
    }
}

