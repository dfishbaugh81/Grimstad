pageextension 50145 "FirmPlanProdOrdExt" extends "Firm Planned Prod. Order"
{
    layout
    {
        addafter("Source No.")
        {
            field("Planned Order No."; Rec."Planned Order No.")
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Planned Order No.';
            }
        }
        addlast(factboxes)
        {
            part(RunTimeByWorkCenter; "Run Time by Work Center")
            {
                ApplicationArea = All;
                Provider = ProdOrderLines;
                Caption = 'Run Time by Work Center';
                SubPageLink = "Routing No."=field("Routing No."), "Routing Reference No."=field("Routing Reference No."), Status=field(Status), "Prod. Order No."=field("Prod. Order No.");
            }
        }
    }
    actions
    {
        addafter("Plannin&g")
        {
            action("Open Lines")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Open Lines';
                Caption = 'Open Lines';

                trigger OnAction()
                var
                    prodOrdLines: Page "Prod. Order Lines";
                begin
                    prodOrdLines.RunModal();
                end;
            }
        }
    }
}
