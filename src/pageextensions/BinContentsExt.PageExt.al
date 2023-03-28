pageextension 50149 "BinContentsExt" extends "Bin Contents"
{
    actions
    {
        addafter("Warehouse Entries")
        {
            action("Nav-to-Edit")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    WarEntEd: Page "Warehouse Entries - Editable";
                    UserSetup: Record "User Setup";
                    test2: Report "Return Order";
                    Test: Page "Warehouse Shipment";
                    test1: Record "DSHIP Package Line Buffer";
                    TEST3: Record "DSHIP Label Data";
                begin
                    if UserSetup.Get(UserId())then if UserSetup."User ID" = 'BCADMIN' then WarEntEd.Run();
                end;
            }
        }
    }
}
