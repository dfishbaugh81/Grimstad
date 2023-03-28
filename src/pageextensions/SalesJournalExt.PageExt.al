pageextension 50146 "SalesJournalExt" extends "Sales Journal"
{
    actions
    {
        addafter("Insert Conv. LCY Rndg. Lines")
        {
            action("Unselect Correction")
            {
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    CurrPage.SetSelectionFilter(GenJnlLine);
                    GenJnlLine.ModifyAll(Correction, false, true);
                end;
            }
        }
    }
}
