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

    procedure AddItemTextToSalesCommentLine(DocType: Enum "Sales Document Type"; DocNo: Code[29]; DocLineNo: Integer; DocLineDate: Date; Comment: Text[100])
    var
        SalesCommLine: Record "Sales Comment Line";
        CurrLineNo: Integer;
    begin
        clear(CurrLineNo);
        SalesCommLine.Reset;
        SalesCommLine.SetRange("Document Type", DocType);
        SalesCommLine.SetRange("No.", DocNo);
        SalesCommLine.SetRange("Document Line No.", DocLineNo);
        if SalesCommLine.FindLast() then begin
            CurrLineNo := SalesCommLine."Line No." + 10000;
            SalesCommLine.Init;
            SalesCommLine.Validate("Document Type", DocType);
            SalesCommLine.Validate("No.", DocNo);
            SalesCommLine.Validate("Document Line No.", DocLineNo);
            SalesCommLine.Validate("Line No.", CurrLineNo);
            SalesCommLine.Validate(Date, DocLineDate);
            if StrLen(Comment) > 80 then begin
                SalesCommLine.Validate(Comment, CopyStr(Comment, 1, 80));
                SalesCommLine.Insert(true);
                Commit;
                CurrLineNo := CurrLineNo + 10000;
                SalesCommLine.Init;
                SalesCommLine.Validate("Document Type", DocType);
                SalesCommLine.Validate("No.", DocNo);
                SalesCommLine.Validate("Document Line No.", DocLineNo);
                SalesCommLine.Validate("Line No.", CurrLineNo);
                SalesCommLine.Validate(Date, DocLineDate);
                SalesCommLine.Validate(Comment, CopyStr(Comment, 81));
                SalesCommLine.Insert(true);
                Commit;
            end else begin
                SalesCommLine.Validate(Comment, Comment);
                SalesCommLine.Insert(true);
                Commit;
            end;
        end else begin
            CurrLineNo := CurrLineNo + 10000;
            SalesCommLine.Init;
            SalesCommLine.Validate("Document Type", DocType);
            SalesCommLine.Validate("No.", DocNo);
            SalesCommLine.Validate("Document Line No.", DocLineNo);
            SalesCommLine.Validate("Line No.", CurrLineNo);
            SalesCommLine.Validate(Date, DocLineDate);
            if StrLen(Comment) > 80 then begin
                SalesCommLine.Validate(Comment, CopyStr(Comment, 1, 80));
                SalesCommLine.Insert(true);
                Commit;
                CurrLineNo := CurrLineNo + 10000;
                SalesCommLine.Init;
                SalesCommLine.Validate("Document Type", DocType);
                SalesCommLine.Validate("No.", DocNo);
                SalesCommLine.Validate("Document Line No.", DocLineNo);
                SalesCommLine.Validate("Line No.", CurrLineNo);
                SalesCommLine.Validate(Date, DocLineDate);
                SalesCommLine.Validate(Comment, CopyStr(Comment, 81));
                SalesCommLine.Insert(true);
                Commit;
            end else begin
                SalesCommLine.Validate(Comment, Comment);
                SalesCommLine.Insert(true);
                Commit;
            end;
        end;
    end;

    procedure AddItemTextToPurchCommentLine(DocType: Enum "Purchase Document Type"; DocNo: Code[29]; DocLineNo: Integer; DocLineDate: Date; Comment: Text[100])
    var
        PurchCommLine: Record "Purch. Comment Line";
        CurrLineNo: Integer;
    begin
        clear(CurrLineNo);
        PurchCommLine.Reset;
        PurchCommLine.SetRange("Document Type", DocType);
        PurchCommLine.SetRange("No.", DocNo);
        PurchCommLine.SetRange("Document Line No.", DocLineNo);
        if PurchCommLine.FindLast() then begin
            CurrLineNo := PurchCommLine."Line No." + 10000;
            PurchCommLine.Init;
            PurchCommLine.Validate("Document Type", DocType);
            PurchCommLine.Validate("No.", DocNo);
            PurchCommLine.Validate("Document Line No.", DocLineNo);
            PurchCommLine.Validate("Line No.", CurrLineNo);
            PurchCommLine.Validate(Date, DocLineDate);
            if StrLen(Comment) > 80 then begin
                PurchCommLine.Validate(Comment, CopyStr(Comment, 1, 80));
                PurchCommLine.Insert(true);
                Commit;
                CurrLineNo := CurrLineNo + 10000;
                PurchCommLine.Init;
                PurchCommLine.Validate("Document Type", DocType);
                PurchCommLine.Validate("No.", DocNo);
                PurchCommLine.Validate("Document Line No.", DocLineNo);
                PurchCommLine.Validate("Line No.", CurrLineNo);
                PurchCommLine.Validate(Date, DocLineDate);
                PurchCommLine.Validate(Comment, CopyStr(Comment, 81));
                PurchCommLine.Insert(true);
                Commit;
            end else begin
                PurchCommLine.Validate(Comment, Comment);
                PurchCommLine.Insert(true);
                Commit;
            end;
        end else begin
            CurrLineNo := CurrLineNo + 10000;
            PurchCommLine.Init;
            PurchCommLine.Validate("Document Type", DocType);
            PurchCommLine.Validate("No.", DocNo);
            PurchCommLine.Validate("Document Line No.", DocLineNo);
            PurchCommLine.Validate("Line No.", CurrLineNo);
            PurchCommLine.Validate(Date, DocLineDate);
            if StrLen(Comment) > 80 then begin
                PurchCommLine.Validate(Comment, CopyStr(Comment, 1, 80));
                PurchCommLine.Insert(true);
                Commit;
                CurrLineNo := CurrLineNo + 10000;
                PurchCommLine.Init;
                PurchCommLine.Validate("Document Type", DocType);
                PurchCommLine.Validate("No.", DocNo);
                PurchCommLine.Validate("Document Line No.", DocLineNo);
                PurchCommLine.Validate("Line No.", CurrLineNo);
                PurchCommLine.Validate(Date, DocLineDate);
                PurchCommLine.Validate(Comment, CopyStr(Comment, 81));
                PurchCommLine.Insert(true);
                Commit;
            end else begin
                PurchCommLine.Validate(Comment, Comment);
                PurchCommLine.Insert(true);
                Commit;
            end;
        end;
    end;
}
