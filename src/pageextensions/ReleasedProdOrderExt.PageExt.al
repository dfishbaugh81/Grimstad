pageextension 50137 "ReleasedProdOrderExt" extends "Released Production Orders"
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
        addafter("Due Date")
        {
            field("Finished Quantity"; Rec."Finished Quantity")
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Finished Quantity';
            }

            field("Firm Planned Order No."; Rec."Firm Planned Order No.")
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Firm Planned Order';
            }

            field("Production BOM"; Rec."Production BOM")
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Production BOM';
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
                begin
                    CurrPage.SetSelectionFilter(prodOrder);
                    prodOrderToRefresh.SetRange("Status", prodOrder.Status);
                    prodOrderToRefresh.SetRange("No.", prodOrder."No.");
                    REPORT.RunModal(REPORT::"Refresh Production Order", false, true, ProdOrderToRefresh);
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
    var
        fQty: Integer;
}

