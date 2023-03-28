pageextension 50112 "CustListView" extends "Customer List"
{
    layout
    {
        addafter("Name 2")
        {
            field(City; Rec.City)
            {
                ApplicationArea = Basic, Suite;
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
