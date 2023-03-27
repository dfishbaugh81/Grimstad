pageextension 50148 "Released Production Order" extends "Released Production Order"
{
    layout
    {
        addlast(factboxes)
        {
            part(RunTimeByWorkCenter; "Run Time by Work Center")
            {
                ApplicationArea = All;
                Provider = ProdOrderLines;
                Caption = 'Run Time by Work Center';
                SubPageLink = "Routing No." = field("Routing No."), "Routing Reference No." = field("Routing Reference No."), Status = field(Status), "Prod. Order No." = field("Prod. Order No.");
            }
        }
    }
}
