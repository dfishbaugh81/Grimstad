page 50110 "User CRM Tasks Activities"
{
    Caption = 'CRM Tasks';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "To-Do";

    layout
    {
        area(content)
        {
            cuegroup("My CRM Tasks")
            {

                Caption = 'My CRM Tasks';
                field("ToDoTaskManagement.GetTotalRecCount(Rec)"; ToDoTaskManagement.GetTotalRecCount(Rec, UserId))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'User CRM Tasks';
                    Image = Checklist;
                    ToolTip = 'Specifies the number of CRM tasks that are assigned to you or to a group that you are a member of.';

                    trigger OnDrillDown()
                    var
                        UserSetup: Record "User Setup";
                        TaskList: Page "Task List";
                    begin
                        UserSetup.Get(UserId);
                        Rec.SetRange("Salesperson Code", UserSetup."Salespers./Purch. Code");
                        TaskList.SetTableView(Rec);
                        TaskList.RunModal();

                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        UserTaskManagement: Codeunit "User Task Management";
        ToDoTaskManagement: Codeunit toDoMgmt;
}

