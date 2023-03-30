codeunit 50102 "toDoMgmt"
{
    Permissions = tabledata 99000771 = rimd;
    EventSubscriberInstance = StaticAutomatic;

    trigger OnRun()
    begin
    end;

    var
        SLine: Record "Sales Line";
        PLine: Record "Purchase Line";

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
        if not typeMatch then currType := whseAct."Whse. Document Type";
        if not DocNoMatch then currNo := whseAct."Whse. Document No.";
        if not LineNoMatch then currLine := whseAct."Whse. Document Line No.";
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
        if prodBomLine.Get(prodBomNo, versCode, LineNo) then prodBomLine.Delete(true);
        Commit;
        prodBom.Reset;
        prodBom.SetRange("No.", prodBomNo);
        if prodBom.FindFirst() then begin
            prodBom.Validate(Status, prodBom.Status::Certified);
            commit;
            exit(prodBom.Modify(true))
        end
        else
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
            end
            else begin
                SalesCommLine.Validate(Comment, Comment);
                SalesCommLine.Insert(true);
                Commit;
            end;
        end
        else begin
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
            end
            else begin
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
        PriceAssetEnt: Report 1401;
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
            end
            else begin
                PurchCommLine.Validate(Comment, Comment);
                PurchCommLine.Insert(true);
                Commit;
            end;
        end
        else begin
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
            end
            else begin
                PurchCommLine.Validate(Comment, Comment);
                PurchCommLine.Insert(true);
                Commit;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price Asset", 'OnBeforeVerifyConsistentAssetType', '', true, true)]
    procedure ValidateOnBeforeVerifyConsistentAssetType(var PriceAsset: Record "Price Asset"; var IsHandled: Boolean);
    begin
        if PriceAsset."Price Type" = PriceAsset."Price Type"::Purchase then if PriceAsset."Asset Type" = PriceAsset."Asset Type"::"Item Discount Group" then IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidatePurchasingCode', '', true, true)]
    procedure OnBeforeValidatePurchasingCode(var SalesLine: Record "Sales Line"; var IsHandled: Boolean);
    var
        PurchCode: Record Purchasing;
    begin
        if PurchCode.Get(SalesLine."Purchasing Code") then
            if PurchCode."Special Order" = true then
                if SalesLine.Type = SalesLine.Type::" " then begin
                    SalesLine."Special Order" := true;
                    SalesLine."Outstanding Quantity" := -1;
                    IsHandled := true;
                end;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Get Sales Orders", 'OnBeforeOnPreReport', '', true, true)]
    procedure OnBeforeOnPreReport(var HideDialog: Boolean);
    begin
        HideDialog := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", 'OnAfterOnInsert', '', true, true)]
    procedure OnAfterOnInsert(RequisitionWkshName: Record "Requisition Wksh. Name"; ReqWkshTemplate: Record "Req. Wksh. Template"; var RequisitionLine: Record "Requisition Line");
    var
        ProbReqLine: Record "Requisition Line";
        NewReqLine: Record "Requisition Line";
        needsToModify: Boolean;
    begin
        needsToModify := false;
        ProbReqLine.Reset;
        ProbReqLine.SetRange(Type, ProbReqLine.Type::" ");
        if ProbReqLine.FindFirst() then
            repeat
                NewReqLine.Reset;
                NewReqLine.SetRange("Sales Order No.", ProbReqLine."Sales Order No.");
                if NewReqLine.FindFirst() then begin
                    ProbReqLine.Validate("Supply From", NewReqLine."Supply From");
                    ProbReqLine.Validate("Vendor No.", NewReqLine."Vendor No.");
                    needsToModify := true;
                end;
            until ProbReqLine.Next() = 0;
        if needsToModify then ProbReqLine.Modify(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnBeforeCheckRequisitionLine', '', true, true)]
    procedure OnBeforeCheckRequisitionLine(SuppressCommit: Boolean; var IsHandled: Boolean; var ReqLine2: Record "Requisition Line");
    begin
        IsHandled := true;
        SuppressCommit := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnCodeOnBeforeFinalizeOrderHeader', '', true, true)]
    procedure OnCodeOnBeforeFinalizeOrderHeader(PurchOrderHeader: Record "Purchase Header"; sender: Codeunit "Req. Wksh.-Make Order"; var IsHandled: Boolean; var ReqLine: Record "Requisition Line");
    var
        pl: Record "Purchase Line";
        sl: Record "Sales Line";
    begin
        if ReqLine.Type = ReqLine.Type::" " then begin
            sl.Reset;
            sl.SetRange("Document Type", sl."Document Type"::Order);
            sl.SetRange("Document No.", ReqLine."Sales Order No.");
            sl.SetRange("Line No.", 0, ReqLine."Sales Order Line No.");
            sl.SetRange(Type, sl.Type::Item);
            if sl.FindLast() then begin
                pl.Reset;
                pl.SetRange("Document No.", sl."Special Order Purchase No.");
                pl.SetRange("Line No.", sl."Special Order Purch. Line No.");
                if pl.FindFirst() then begin
                    PurchOrderHeader.Get(pl."Document Type", pl."Document No.");
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnBeforeCheckInsertFinalizePurchaseOrderHeader', '', true, true)]
    procedure OnBeforeCheckInsertFinalizePurchaseOrderHeader(PrevLocationCode: Code[10]; ReceiveDateReq: Date; RequisitionLine: Record "Requisition Line"; sender: Codeunit "Req. Wksh.-Make Order"; var CheckAddressDetailsResult: Boolean; var CheckInsert: Boolean; var OrderCounter: Integer; var PrevPurchCode: Code[10]; var PrevShipToCode: Code[10]; var PurchaseHeader: Record "Purchase Header"; var UpdateAddressDetails: Boolean);
    var
        pl: Record "Purchase Line";
        sl: Record "Sales Line";
    begin
        if RequisitionLine.Type = RequisitionLine.Type::" " then begin
            sl.Reset;
            sl.SetRange("Document Type", sl."Document Type"::Order);
            sl.SetRange("Document No.", RequisitionLine."Sales Order No.");
            sl.SetRange("Line No.", 0, RequisitionLine."Sales Order Line No.");
            sl.SetRange(Type, sl.Type::Item);
            if sl.FindLast() then begin
                pl.Reset;
                pl.SetRange("Document No.", sl."Special Order Purchase No.");
                pl.SetRange("Line No.", sl."Special Order Purch. Line No.");
                if pl.FindFirst() then begin
                    PurchaseHeader.Get(pl."Document Type", pl."Document No.");
                    OrderCounter := 1;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnBeforeInsertPurchOrderLine', '', true, true)]
    procedure OnBeforeInsertPurchOrderLine(PurchasingCode: Record Purchasing; TempDocumentEntry: Record "Document Entry"; var HideProgressWindow: Boolean; var IsHandled: Boolean; var LineCount: Integer; var NextLineNo: Integer; var OrderCounter: Integer; var OrderDateReq: Date; var PlanningResiliency: Boolean; var PostingDateReq: Date; var PrevLocationCode: Code[10]; var PrevPurchCode: Code[10]; var PrevShipToCode: Code[10]; var PurchaseHeader: Record "Purchase Header"; var PurchOrderHeader: Record "Purchase Header"; var PurchOrderLine: Record "Purchase Line"; var ReceiveDateReq: Date; var ReferenceReq: Text[35]; var RequisitionLine: Record "Requisition Line"; var SuppressCommit: Boolean);
    var
        pl: Record "Purchase Line";
        sl: Record "Sales Line";
        intCounter: Integer;
    begin
        intCounter := 500;
        if RequisitionLine.Type = RequisitionLine.Type::" " then begin
            sl.Reset;
            sl.SetRange("Document Type", sl."Document Type"::Order);
            sl.SetRange("Document No.", RequisitionLine."Sales Order No.");
            sl.SetRange("Line No.", 0, RequisitionLine."Sales Order Line No.");
            sl.SetRange(Type, sl.Type::Item);
            if sl.FindLast() then begin
                pl.Reset;
                pl.SetRange("Document No.", sl."Special Order Purchase No.");
                pl.SetRange("Line No.", sl."Special Order Purch. Line No.");
                if pl.FindFirst() then begin
                    NextLineNo := pl."Line No." + intCounter;
                    while PurchOrderLine.Get(pl."Document Type", pl."Document No.", NextLineNo) do begin
                        if PurchOrderLine.Description = RequisitionLine.Description then
                            exit
                        else begin
                            intCounter := Round((intCounter / 2), 1, '>');
                            NextLineNo := NextLineNo + intCounter;
                        end;
                    end;
                    PurchOrderLine.Init;
                    PurchOrderLine.Validate("Document Type", pl."Document Type");
                    PurchOrderLine.Validate("Document No.", pl."Document No.");
                    PurchOrderLine.Validate("Line No.", NextLineNo);
                    PurchOrderLine.Validate(Type, PurchOrderLine.Type::" ");
                    PurchOrderLine.Validate(Description, RequisitionLine."Description");
                    PurchOrderLine.Insert(true);
                    commit;
                    IsHandled := true;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Report Selection Warehouse", 'OnBeforePrintDocument', '', true, true)]
    procedure OnBeforePrintDocument(RecVarToPrint: Variant; ShowRequestPage: Boolean; TempReportSelectionWarehouse: Record "Report Selection Warehouse"; var IsHandled: Boolean)
    var
        WhseActHead: Record "Warehouse Activity Header";
        WhseActLine: Record "Warehouse Activity Line";
        RecRef: RecordRef;
        temptxt: Text;
        BcPickListSales: Report "Pick - Barcoded (Sales)";
        BcPickList: Report "Picking List - Barcoded";
    begin
        if TempReportSelectionWarehouse.Usage = TempReportSelectionWarehouse.Usage::Pick then begin
            //if RecVarToPrint.IsRecord then
            RecRef.GetTable(RecVarToPrint);
            RecRef.SetTable(WhseActHead);
            if WhseActHead.FindFirst() then begin
                WhseActLine.Reset;
                WhseActLine.SetRange("No.", WhseActHead."No.");
                if WhseActLine.Findfirst() then begin
                    if WhseActLine."Source Type" = 37 then
                        Report.Run(50115, ShowRequestPage, false, RecVarToPrint)
                    else
                        Report.Run(50109, ShowRequestPage, false, RecVarToPrint);
                    IsHandled := true;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", 'OnInsertPurchOrderLineOnBeforeSalesOrderLineModify', '', true, true)]
    procedure OnInsertPurchOrderLineOnBeforeSalesOrderLineModify(var PurchOrderLine: Record "Purchase Line"; var RequisitionLine: Record "Requisition Line"; var SalesOrderLine: Record "Sales Line");
    var
        pl: Record "Purchase Line";
        SalesCommentLine: Record "Sales Comment Line";
    begin
        SalesCommentLine.Reset;
        SalesCommentLine.SetRange("Document Type", SalesOrderLine."Document Type");
        SalesCommentLine.SetRange("No.", SalesOrderLine."Document No.");
        SalesCommentLine.SetRange("Document Line No.", SalesOrderLine."Line No.");
        if SalesCommentLine.FindFirst() then
            repeat
                AddItemTextToPurchCommentLine(PurchOrderLine."Document Type", PurchOrderLine."Document No.", PurchOrderLine."Line No.", WorkDate(), SalesCommentLine.Comment);
            until SalesCommentLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Req. Worksheet", 'OnBeforeCarryOutActionMsg', '', true, true)]
    procedure OnBeforeCarryOutActionMsg(var IsHandled: Boolean; var RequisitionLine: Record "Requisition Line")
    var
        ReqLineCheck: Record "Requisition Line";
        IsOnlySpecialComments: Boolean;
        IsSpecial: Boolean;
        UpdateReqLine: Record "Requisition Line";
    begin
        IsOnlySpecialComments := true;
        IsSpecial := false;
        ReqLineCheck.Reset;
        ReqLineCheck.SetRange("Worksheet Template Name", RequisitionLine."Worksheet Template Name");
        ReqLineCheck.SetRange("Journal Batch Name", RequisitionLine."Journal Batch Name");
        ReqLineCheck.SetRange("Purchasing Code", 'SPECIAL');
        if ReqLineCheck.FindFirst() then
            repeat
                IsSpecial := true;
                if ReqLineCheck.Type <> ReqLineCheck.Type::" " then IsOnlySpecialComments := false;
            until ReqLineCheck.Next() = 0;
        if IsSpecial then
            if not IsOnlySpecialComments then begin
                UpdateReqLine.Reset;
                UpdateReqLine.SetRange("Worksheet Template Name", RequisitionLine."Worksheet Template Name");
                UpdateReqLine.SetRange("Journal Batch Name", RequisitionLine."Journal Batch Name");
                UpdateReqLine.SetRange("Purchasing Code", 'SPECIAL');
                UpdateReqLine.SetRange("Accept Action Message", true);
                UpdateReqLine.SetRange(Type, UpdateReqLine.Type::" ");
                if UpdateReqLine.FindFirst() then begin
                    repeat
                        UpdateReqLine.Validate("Accept Action Message", false);
                        UpdateReqLine.Modify(true);
                    until UpdateReqLine.Next() = 0;
                    IsHandled := true;
                end;
            end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Req. Worksheet", 'OnActionGetSalesOrdersOnBeforeGetSalesOrderRunModal', '', true, true)]
    procedure OnActionGetSalesOrdersOnBeforeGetSalesOrderRunModal(var GetSalesOrder: Report "Get Sales Orders"; var RequisitionLine: Record "Requisition Line");
    var
        NewGetSalesOrder: Report "New Get Sales Orders";
        ProbReqLine: Record "Requisition Line";
        NewReqLine: Record "Requisition Line";
    begin
        NewGetSalesOrder.SetReqWkshLine(RequisitionLine, 1);
        NewGetSalesOrder.RunModal();
        Clear(NewGetSalesOrder);
        GetSalesOrder.UseRequestPage(false);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Req. Worksheet", 'OnGetSalesOrderActionOnBeforeGetSalesOrderRunModal', '', true, true)]
    procedure OnGetSalesOrderActionOnBeforeGetSalesOrderRunModal(var GetSalesOrder: Report "Get Sales Orders"; var RequisitionLine: Record "Requisition Line");
    var
        NewGetSalesOrder: Report "New Get Sales Orders";
        ProbReqLine: Record "Requisition Line";
        NewReqLine: Record "Requisition Line";
    begin
        NewGetSalesOrder.SetReqWkshLine(RequisitionLine, 0);
        NewGetSalesOrder.RunModal();
        Clear(NewGetSalesOrder);
        GetSalesOrder.UseRequestPage(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeCheckOutstandingPurchaseDocuments', '', false, false)]
    local procedure OnBeforeCheckOutstandingPurchaseDocuments(var IsHandled: Boolean; Vendor: Record Vendor)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnCopySalesDocLineOnBeforeCheckLocationOnWMS', '', false, false)]
    local procedure OnCopySalesDocLineOnBeforeCheckLocationOnWMS(IncludeHeader: Boolean; RecalculateLines: Boolean; var FromSalesLine: Record "Sales Line"; var IsHandled: Boolean; var ToSalesHeader: Record "Sales Header"; var ToSalesLine: Record "Sales Line")
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', false, false)]
    local procedure OnSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        if ReportId = Report::"Customer Statements" then NewReportId := Report::"GrimCustStatements";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Dist. Integration", 'OnBeforeGetSpecialOrders', '', true, true)]
    procedure OnBeforeGetSpecialOrders(PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean);
    var
        Vendor: Record Vendor;
        NextLineNo: Integer;
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        SalesHeader: Record "Sales Header";
    begin
        IsHandled := true;
        SalesHeader.SetCurrentKey("Document Type", "Sell-to Customer No.");
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Sell-to Customer No.", PurchaseHeader."Sell-to Customer No.");
        if (PAGE.RunModal(PAGE::"Sales List", SalesHeader) <> ACTION::LookupOK) or (SalesHeader."No." = '') then exit;
        PurchaseHeader.LockTable();
        SalesHeader.TestField("Document Type", SalesHeader."Document Type"::Order);
        PurchaseHeader.TestField("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
        CheckShipToCode(PurchaseHeader, SalesHeader);
        CheckAddSpecialOrderToAddress(PurchaseHeader, SalesHeader);
        if Vendor.Get(PurchaseHeader."Buy-from Vendor No.") then PurchaseHeader.Validate("Shipment Method Code", Vendor."Shipment Method Code");
        PLine.LockTable();
        SLine.LockTable();
        PLine.SetRange("Document Type", PLine."Document Type"::Order);
        PLine.SetRange("Document No.", PurchaseHeader."No.");
        if PLine.FindLast() then
            NextLineNo := PLine."Line No." + 10000
        else
            NextLineNo := 10000;
        SLine.Reset();
        SLine.SetRange("Document Type", SLine."Document Type"::Order);
        SLine.SetRange("Document No.", SalesHeader."No.");
        SLine.SetRange("Special Order", true);
        SLine.SetFilter("Outstanding Quantity", '<>0');
        SLine.SetRange("Special Order Purch. Line No.", 0);
        if SLine.FindSet() then
            repeat
                ProcessSalesLine(SLine, PLine, NextLineNo, PurchaseHeader);
            until SLine.Next() = 0;
        PurchaseHeader.Modify(); // Only version check
        SalesHeader.Modify(); // Only version check
    end;

    local procedure CheckShipToCode(var PurchHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header")
    begin
        if PurchHeader."Ship-to Code" <> '' then PurchHeader.TestField("Ship-to Code", SalesHeader."Ship-to Code");
    end;

    local procedure CheckAddSpecialOrderToAddress(var PurchHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header")
    begin
        if PurchHeader.SpecialOrderExists(SalesHeader) then begin
            PurchHeader.Validate("Location Code", SalesHeader."Location Code");
            PurchHeader.AddSpecialOrderToAddress(SalesHeader, true);
        end;
    end;

    local procedure ProcessSalesLine(var SalesLine: Record "Sales Line"; var PurchLine: Record "Purchase Line"; var NextLineNo: Integer; PurchHeader: Record "Purchase Header")
    var
        PurchLine2: Record "Purchase Line";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then exit;
        PurchLine.Init();
        PurchLine."Document Type" := PurchLine."Document Type"::Order;
        PurchLine."Document No." := PurchHeader."No.";
        PurchLine."Line No." := NextLineNo;
        CopyDocMgt.TransfldsFromSalesToPurchLine(SalesLine, PurchLine);
        PurchLine.GetItemTranslation();
        PurchLine."Special Order" := true;
        PurchLine."Purchasing Code" := SalesLine."Purchasing Code";
        PurchLine."Special Order Sales No." := SalesLine."Document No.";
        PurchLine."Special Order Sales Line No." := SalesLine."Line No.";
        PurchLine.Quantity := 0;
        PurchLine.Insert();
        NextLineNo := NextLineNo + 10000;
        SalesLine."Unit Cost (LCY)" := PurchLine."Unit Cost (LCY)";
        //SalesLine.Validate("Unit Cost (LCY)");
        SalesLine."Special Order Purchase No." := PurchLine."Document No.";
        SalesLine."Special Order Purch. Line No." := PurchLine."Line No.";
        SalesLine.Modify();
        if TransferExtendedText.PurchCheckIfAnyExtText(PurchLine, false) then begin
            TransferExtendedText.InsertPurchExtText(PurchLine);
            PurchLine2.SetRange("Document Type", PurchHeader."Document Type");
            PurchLine2.SetRange("Document No.", PurchHeader."No.");
            if PurchLine2.FindLast() then NextLineNo := PurchLine2."Line No.";
            NextLineNo := NextLineNo + 10000;
        end;
    end;
}
