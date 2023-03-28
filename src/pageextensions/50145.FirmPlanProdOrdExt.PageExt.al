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

