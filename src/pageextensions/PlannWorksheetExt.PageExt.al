pageextension 50135 "PlannWorksheetExt" extends "Planning Worksheet"
{
    layout
    {
        addafter("Ref. Order No.")
        {
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Sales Order No.';
                Visible = true;
            }
            field("Sales Order Line No."; Rec."Sales Order Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Sales Order Line No.';
                Visible = true;
            }
        }

    }

    actions
    {

        addbefore(Action109)
        {
            action("Toggle CAM")
            {
                ApplicationArea = All;
                Visible = true;
                Image = Calculator;

                trigger OnAction()
                var
                    ReqLine: Record "Requisition Line";
                    UnselectedCount: Integer;
                begin
                    UnselectedCount := 0;
                    CurrPage.SetSelectionFilter(ReqLine);
                    if ReqLine.FindFirst() then
                        repeat
                            if not ReqLine."Accept Action Message" then begin
                                UnselectedCount := UnselectedCount + 1;
                                ReqLine.Validate("Accept Action Message", true);
                                ReqLine.Modify(true);
                            end;
                        until ReqLine.Next() = 0;
                    if UnselectedCount = 0 then
                        ReqLine.ModifyAll("Accept Action Message", false, true);
                end;
            }
        }
    }
}

