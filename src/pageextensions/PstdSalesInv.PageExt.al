pageextension 50129 "PstdSalesInv" extends "Posted Sales Invoice"
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

