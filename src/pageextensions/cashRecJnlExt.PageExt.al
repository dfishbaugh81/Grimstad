pageextension 50139 "cashRecJnlExt" extends "Cash Receipt Journal"
{
    actions
    {
        addbefore("Renumber Document Numbers")
        {
            action("Add Bal Acct")
            {
                ApplicationArea = All;
                Image = Splitlines;
                Visible = true;
                trigger OnAction()
                var
                    genJnlLine: Record "Gen. Journal Line";
                begin
                    CurrPage.SetSelectionFilter(genJnlLine);
                    if genJnlLine.FindFirst() then
                        repeat
                            genJnlLine.Validate("Bal. Account No.", '4601');
                            genJnlLine.Modify(true);
                        until genJnlLine.Next() = 0
                end;
            }
        }
    }
}

