pageextension 50133 "PstdSalesCrMemos" extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("Location Code")
        {
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

