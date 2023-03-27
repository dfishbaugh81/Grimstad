pageextension 50134 "ReqWorksheetExt" extends "Req. Worksheet"
{
    layout
    {
        addafter("Vendor No.")
        {
            field("Purchasing Code"; Rec."Purchasing Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Purchasing Code.';
                Visible = true;
            }

            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Purchasing Code.';
                Visible = true;
            }
        }
    }

    actions
    {
        addbefore(CalculatePlan)
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

