pageextension 50121 "ProdBomList" extends "Production BOM List"
{
    layout
    {
        modify("Description 2")
        {
            ApplicationArea = Basic, Suite;
            Importance = Additional;
            ToolTip = 'Specifies information in addition to the description.';
            Visible = true;
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
                    prodBom: Record "Production BOM Header";
                    toDoMgmt: Codeunit toDoMgmt;
                begin
                    CurrPage.SetSelectionFilter(prodBom);
                    prodBom.ModifyAll(Status, prodBom.Status::"Under Development", true);
                end;
            }
            action("Status update to Cert")
            {
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                var
                    prodBom: Record "Production BOM Header";
                    toDoMgmt: Codeunit toDoMgmt;
                    porder: Page "Purchase Order";
                begin
                    CurrPage.SetSelectionFilter(prodBom);
                    prodBom.ModifyAll(Status, prodBom.Status::Certified, true);
                end;
            }
            action("Delete Lines")
            {
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                var
                    prodBom: Record "Production BOM Header";
                    prodBomLine: Record "Production BOM Line";
                    genCodeUnit: Codeunit toDoMgmt;
                begin
                    CurrPage.SetSelectionFilter(prodBom);
                    if prodBom.FindFirst()then repeat prodBomLine.Reset;
                            prodBomLine.SetRange("Production BOM No.", prodBom."No.");
                            prodBomLine.DeleteAll();
                            genCodeUnit.RemoveItemAssociatedWithBom(prodBom."No.");
                        until prodBom.Next() = 0;
                    prodBom.DeleteAll(true);
                    commit;
                end;
            }
            action("Open Lines")
            {
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                var
                    prodBomLines: Page "Prod. BOM Lines";
                begin
                    prodBomLines.RunModal();
                end;
            }
        }
    }
}
