codeunit 50102 toDoMgmt
{
    Permissions = tabledata 99000771 = rimd;

    procedure GetTotalRecCount(var ToDo: Record "To-Do"; userCode: code[20]): Integer
    var
        userSetup: Record "User Setup";
    begin
        userSetup.Get(userCode);
        ToDo.SetRange("Salesperson Code", userSetup."Salespers./Purch. Code");
        exit(ToDo.Count());
    end;

    procedure VerifySplit(whseAct: Record "Warehouse Activity Line"; var currLine: Integer; var currNo: Code[20]; var currType: Enum "Warehouse Activity Type"): Boolean
    var
        typeMatch: Boolean;
        DocNoMatch: Boolean;
        LineNoMatch: Boolean;
    begin
        typeMatch := whseAct."Whse. Document Type" = currType;
        DocNoMatch := whseAct."Whse. Document No." = currNo;
        LineNoMatch := whseAct."Whse. Document Line No." = currLine;
        if not typeMatch then
            currType := whseAct."Whse. Document Type";
        if not DocNoMatch then
            currNo := whseAct."Whse. Document No.";
        if not LineNoMatch then
            currLine := whseAct."Whse. Document Line No.";
        exit(typeMatch and DocNoMatch and LineNoMatch);
    end;

    procedure ValidateBomStatus(prodBom: Record "Production BOM Header"; prodStatus: enum "Production Order Status"): Boolean
    var
        success: Boolean;
    begin
        if prodBom.FindFirst() then
            repeat
                prodBom.Validate(Status, prodStatus);
                success := prodBom.Modify(true);
            until prodBom.Next() = 0;
        exit(success);
    end;

    procedure RemoveLineFromCertProdBom(prodBomNo: Code[20]; versCode: Code[20]; LineNo: Integer): Boolean
    var
        success: Boolean;
        prodBom: Record "Production BOM Header";
        prodBomLine: Record "Production BOM Line";
    begin
        prodBom.Reset;
        prodBom.SetRange("No.", prodBomNo);
        if prodBom.FindFirst() then begin
            if prodBom.Status = prodBom.Status::Certified then begin
                prodBom.Validate(Status, prodBom.Status::New);
                prodBom.Modify(true);
                Commit();
            end
        end;

        Commit;
        if prodBomLine.Get(prodBomNo, versCode, LineNo) then
            prodBomLine.Delete(true);
        Commit;
        prodBom.Reset;
        prodBom.SetRange("No.", prodBomNo);
        if prodBom.FindFirst() then begin
            prodBom.Validate(Status, prodBom.Status::Certified);
            commit;
            exit(prodBom.Modify(true))
        end else
            exit(false);

    end;

    procedure RemoveItemAssociatedWithBom(ItemNo: Code[20])
    var
        item: Record Item;
    begin
        item.Reset;
        item.SetRange("No.", ItemNo);
        if item.FindFirst() then begin
            item.Validate("Production BOM No.", '');
            item.Modify();
            commit;
        end
    end;
}
