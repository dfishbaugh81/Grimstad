pageextension 50110 "RoutListView" extends "Routing List"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = Manufacturing;
                Importance = Additional;
                ToolTip = 'Specifies information in addition to the description.';
                Visible = true;
            }
        }
    }
    actions
    {
        addafter("Where-used")
        {
            action("Status update to UD")
            {
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                var
                    RoutHead: Record "Routing Header";
                begin
                    CurrPage.SetSelectionFilter(RoutHead);
                    if RoutHead.FindFirst()then repeat RoutHead.Validate(Status, RoutHead.Status::"Under Development");
                            RoutHead.Modify(true);
                        until RoutHead.Next() = 0;
                end;
            }
            action("Status update to Cert")
            {
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                var
                    RoutHead: Record "Routing Header";
                begin
                    CurrPage.SetSelectionFilter(RoutHead);
                    if RoutHead.FindFirst()then repeat RoutHead.Validate(Status, RoutHead.Status::"Certified");
                            RoutHead.Modify(true);
                        until RoutHead.Next() = 0;
                end;
            }
            action("Delete Lines")
            {
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                var
                    RoutHead: Record "Routing Header";
                    RoutLine: Record "Routing Line";
                begin
                    CurrPage.SetSelectionFilter(RoutHead);
                    if RoutHead.FindFirst()then repeat RoutLine.Reset;
                            RoutLine.SetRange("Routing No.", RoutHead."No.");
                            RoutLine.DeleteAll();
                        until RoutHead.Next() = 0;
                end;
            }
        }
    }
}
