pageextension 50130 "PstdSalesCrMem" extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("Work Description")
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

