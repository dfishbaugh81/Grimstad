pageextension 50128 "SalesQuote" extends "Sales Quote"
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

