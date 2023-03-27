pageextension 50141 "firmPlanProdOrdersExt" extends "Firm Planned Prod. Orders"
{
    layout
    {
        addbefore("Due Date")
        {
            field("IWX Sched. Original Due Date"; Rec."IWX Sched. Original Due Date")
            {
                ApplicationArea = All;
                ToolTip = 'Original Due Date';
            }
        }
        addafter("Routing No.")
        {
            field("Planned Order No."; Rec."Planned Order No.")
            {
                ApplicationArea = All;
                Caption = 'Orig Prod No.';
                ToolTip = 'Orig Prod No.';
                Visible = true;
            }

            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                Caption = 'Description';
                ToolTip = 'Description';
                Visible = true;
            }
            field("Production BOM"; Rec."Production BOM")
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
        addafter("Assigned User ID")
        {
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                ApplicationArea = All;
                Caption = 'Created';
                ToolTip = 'Created';
                Visible = true;
                Editable = false;
            }
        }
    }
    actions
    {
        addbefore("Change &Status")
        {
            action("Delete Lines")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Visible = true;

                trigger OnAction()
                var
                    prodOrder: Record "Production Order";
                begin
                    CurrPage.SetSelectionFilter(prodOrder);
                    prodOrder.DeleteAll();
                end;
            }

            action("Refresh Production Orders")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Visible = true;

                trigger OnAction()
                var
                    prodOrder: Record "Production Order";
                    prodOrderToRefresh: Record "Production Order";
                    test: Report "DSHIP Bill of Lading";
                begin
                    CurrPage.SetSelectionFilter(prodOrder);
                    prodOrderToRefresh.SetRange("Status", prodOrder.Status);
                    prodOrderToRefresh.SetRange("No.", prodOrder."No.");
                    REPORT.RunModal(REPORT::"Refresh Production Order", false, true, ProdOrderToRefresh);
                end;
            }

            action("Release All")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Visible = true;

                trigger OnAction()
                var
                    prodOrder: Record "Production Order";
                    relProdOrd: Record "Production Order";
                    prodMan: Codeunit "Prod. Order Status Management";
                begin
                    CurrPage.SetSelectionFilter(prodOrder);
                    if prodOrder.FindFirst() then
                        repeat
                            prodMan.ChangeProdOrderStatus(prodOrder, Rec.Status::Released, WorkDate(), false);
                            Commit;
                        until prodOrder.Next() = 0;
                end;
            }

            action("Release All & Pick")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Visible = true;

                trigger OnAction()
                var
                    prodOrder: Record "Production Order";
                    relProdOrd: Record "Production Order";
                    prodMan: Codeunit "Prod. Order Status Management";
                begin
                    CurrPage.SetSelectionFilter(prodOrder);
                    if prodOrder.FindFirst() then
                        repeat
                            prodMan.ChangeProdOrderStatus(prodOrder, Rec.Status::Released, WorkDate(), false);
                            Commit;
                            relProdOrd.Reset;
                            relProdOrd.SetRange("Firm Planned Order No.", prodOrder."No.");
                            relProdOrd.SetHideValidationDialog(true);
                            if relProdOrd.FindFirst() then
                                relProdOrd.CreatePick(UserId, 0, false, false, false);
                        until prodOrder.Next() = 0;
                end;
            }

            action("Production &BOM")
            {
                ApplicationArea = All;
                Image = BOM;
                Visible = true;
                ShortcutKey = 'Alt+b';

                trigger OnAction()
                var
                    prodBom: Page "Production BOM";
                    prodBomHeader: Record "Production BOM Header";
                    item: Record Item;
                begin

                    if item.Get(Rec."Source No.") then
                        if prodBomHeader.Get(item."Production BOM No.") then begin
                            prodBom.SetRecord(prodBomHeader);
                            prodBom.RunModal();
                        end;


                end;
            }
        }
    }
}

