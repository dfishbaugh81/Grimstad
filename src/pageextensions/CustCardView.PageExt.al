pageextension 50126 "CustCardView" extends "Customer Card"
{
    layout
    {
        addafter("Search Name")
        {
            field("Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies the Territory for the Customer.';
                Visible = true;
            }

            field(ASN; Rec.ASN)
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'ASN trigger.';
                Visible = true;
            }
        }
    }
}

