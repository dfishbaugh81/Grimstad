pageextension 50109 ProdBOMExt extends "Production BOM"
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
}

pageextension 50110 RoutListView extends "Routing List"
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
                    if RoutHead.FindFirst() then
                        repeat
                            RoutHead.Validate(Status, RoutHead.Status::"Under Development");
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
                    if RoutHead.FindFirst() then
                        repeat
                            RoutHead.Validate(Status, RoutHead.Status::"Certified");
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
                    if RoutHead.FindFirst() then
                        repeat
                            RoutLine.Reset;
                            RoutLine.SetRange("Routing No.", RoutHead."No.");
                            RoutLine.DeleteAll();
                        until RoutHead.Next() = 0;
                end;
            }
        }
    }
}

pageextension 50111 RoutHeader extends Routing
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
}

pageextension 50112 CustListView extends "Customer List"
{
    layout
    {
        addafter("Name 2")
        {
            field(City; Rec.City)
            {
                ApplicationArea = Basic, Suite;
            }

            field("Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies the Territory for the Customer.';
                Visible = true;
            }
        }
    }
}

pageextension 50113 ExtTextFactbox extends "Item Card"
{
    layout
    {
        addafter("Description")
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Specifies information in addition to the description.';
                Visible = true;
            }

            field(Manufacturer; Rec.Manufacturer)
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Specifies Manufacturer code.';
                Visible = true;
            }

            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Identifies Vendor Name.';
                Visible = true;
            }
        }
        addbefore(ItemAttributesFactbox)
        {

            part("Extended Text"; "Extended Text Lines")
            {
                ApplicationArea = All;
                Caption = 'Ext. Text';
                SubPageLink = "Table Name" = CONST(Item),
                                "No." = field("No.");
                Visible = ExtTextLnCnt > 0;
            }

        }

    }
    trigger OnAfterGetCurrRecord()
    begin
        ExtTextLine.Reset;
        ExtTextLine.Setrange("Table Name", ExtTextLine."Table Name"::Item);
        ExtTextLine.Setrange("No.", Rec."No.");
        ExtTextLnCnt := ExtTextLine.Count;
    end;

    var
        ExtTextLine: Record "Extended Text Line";
        ExtTextLnCnt: Integer;

}

pageextension 50114 ItemListExt extends "Item List"
{
    layout
    {
        addafter("Description")
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                ToolTip = 'Specifies information in addition to the description.';
                Visible = true;
            }

            field(Manufacturer; Rec.Manufacturer)
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Specifies Manufacturer code.';
                Visible = true;
            }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Identifies Vendor Name.';
                Visible = true;
            }
        }

        addbefore(ItemAttributesFactBox)
        {
            part("Where-Used"; "Where-Used Prod Lines")
            {
                ApplicationArea = All;
                Caption = 'Where-Used';
                SubPageLink = "No." = field("No.");

            }



            part("Extended Text"; "Extended Text Lines")
            {
                ApplicationArea = All;
                Caption = 'Ext. Text';
                SubPageLink = "Table Name" = CONST(Item),
                                "No." = field("No.");
                Visible = ExtTextLnCnt > 0;
            }


        }

    }

    trigger OnAfterGetCurrRecord()
    begin
        ExtTextLine.Reset;
        ExtTextLine.Setrange("Table Name", ExtTextLine."Table Name"::Item);
        ExtTextLine.Setrange("No.", Rec."No.");
        ExtTextLnCnt := ExtTextLine.Count;

        ProdOrdLine.Reset;
        ProdOrdLine.SetRange("No.", Rec."No.");
        IF ProdOrdLine.FindSet() then
            ProdBOMWhereUsed.SetRecord(ProdOrdLine)
        ELSE
            clear(ProdBOMWhereUsed);
        ProdBOMWhereUsed.Update(false);

    end;


    var
        ExtTextLine: Record "Extended Text Line";
        ExtTextLnCnt: Integer;
        test: Record "Sales Comment Line";
        ProdBOMWhereUsed: Page "Production BOM Lines";
        ProdOrdLine: Record "Production BOM Line";
}

pageextension 50115 BomLinesExt extends "Production BOM Lines"
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
}

pageextension 50116 WhseWmsRoleCenterExt extends "Sales & Relationship Mgr. RC"
{
    layout
    {
        addafter(Control56)
        {
            part(CrmTaskActivities; "User CRM Tasks Activities")
            {
                ApplicationArea = Suite;
            }
        }
    }
}

pageextension 50117 SalesOrdLineExt extends "Sales Order Subform"
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

        addafter("Tax Area Code")
        {
            field("Purchase Order No."; Rec."Purchase Order No.")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                ToolTip = 'Specifies information in addition to the description.';
                Visible = true;

            }

        }
    }
}

pageextension 50118 SalesCrMemLineExt extends "Sales Cr. Memo Subform"
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
}

pageextension 50119 PurchOrdLineExt extends "Purchase Order Subform"
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

        addafter("Tax Area Code")
        {
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                ToolTip = 'Specifies information in addition to the description.';
                Visible = true;

            }

        }
    }
}

pageextension 50120 PurchCrMemLineExt extends "Purch. Cr. Memo Subform"
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
}

pageextension 50121 ProdBomList extends "Production BOM List"
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
                    if prodBom.FindFirst() then
                        repeat
                            prodBomLine.Reset;
                            prodBomLine.SetRange("Production BOM No.", prodBom."No.");
                            prodBomLine.DeleteAll();
                            genCodeUnit.RemoveItemAssociatedWithBom(prodBom."No.");
                        until prodBom.Next() = 0;

                    prodBom.DeleteAll(true);
                    commit;
                end;
            }
        }
    }
}

pageextension 50122 ItemLookupExt extends "Item Lookup"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies information in addition to the description.';
                Visible = true;
            }

            field(Manufacturer; Rec.Manufacturer)
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies Manufacturer code.';
                Visible = true;
            }
        }
    }
}

pageextension 50123 WhseShipLine extends "Whse. Shipment Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies information in addition to the description.';
                Visible = true;
            }
        }
    }
}

pageextension 50124 WhseShipLines extends "Whse. Shipment Lines"
{
    layout
    {
        modify("Description 2")
        {
            ApplicationArea = All;
            Importance = Promoted;
            ToolTip = 'Specifies information in addition to the description.';
            Visible = true;
        }
    }
}

pageextension 50125 PstdWhseShipLine extends "Posted Whse. Shipment Subform"
{
    layout
    {
        modify("Description 2")
        {
            ApplicationArea = All;
            Importance = Promoted;
            ToolTip = 'Specifies information in addition to the description.';
            Visible = true;
        }
    }
}

pageextension 50126 CustCardView extends "Customer Card"
{
    layout
    {
        addafter("Search Name")
        {
            field("Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies the Territory for the Customer.';
                Visible = true;
            }
        }
    }
}

pageextension 50127 SalesOrder extends "Sales Order"
{
    layout
    {

        addafter("Work Description")
        {
            field("Created By"; Rec.GetUserNameFromSecurityId(Rec.SystemCreatedBy))
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Created By Record.';
                Visible = true;
            }
            field("Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies the Territory for the Customer.';
                Visible = true;
            }
        }

        addbefore(ApprovalFactBox)
        {
            part(SalesInvLines; "Sales Item History FactBox")
            {
                ApplicationArea = Basic, Suite;
                Provider = SalesLines;
                SubPageLink = "Sell-to Customer No." = FIELD("Sell-to Customer No."),
                                "No." = field("No.");
                Visible = true;


            }

        }
    }
}

pageextension 50128 SalesQuote extends "Sales Quote"
{
    layout
    {
        addafter("Work Description")
        {
            field("Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies the Territory for the Customer.';
                Visible = true;
            }
        }
    }
}

pageextension 50129 PstdSalesInv extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Work Description")
        {
            field("Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies the Territory for the Customer.';
                Visible = true;
            }
        }
    }
}

pageextension 50130 PstdSalesCrMem extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("Work Description")
        {
            field("Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies the Territory for the Customer.';
                Visible = true;
            }
        }
    }
}

pageextension 50131 SalesOrders extends "Sales Order List"
{
    layout
    {
        addafter("Location Code")
        {
            field("Created By"; Rec.GetUserNameFromSecurityId(Rec.SystemCreatedBy))
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Created By Record.';
                Visible = true;
            }
            field("Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies the Territory for the Customer.';
                Visible = true;
            }
        }
    }

    actions
    {
        addbefore("Pla&nning")
        {
            action("Validate Missing Items")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Visible = true;

                trigger OnAction()
                var
                    salesLine: Record "Sales Line";
                    salesHeader: Record "Sales Header";
                    priceValue: Decimal;
                    qtyValue: Decimal;
                    poOrderNo: Code[20];
                    poLineNo: Integer;
                    dShip: Boolean;
                    dialWindow: Dialog;
                    Text000: Label 'Refreshing Lines for Order: #1#####';
                    Text001: Label 'Progress #2###### % Complete';
                    i: integer;
                    iTotal: integer;
                begin
                    CurrPage.SetSelectionFilter(salesHeader);
                    i := 0;
                    iTotal := salesHeader.Count();
                    dialWindow.Open(Text000 + '\\' + Text001);
                    if salesHeader.FindFirst() then
                        repeat
                            i := i + 1;
                            dialWindow.Update(1, salesHeader."No.");
                            dialWindow.Update(2, Round(i / iTotal * 100, 1, '>'));
                            salesLine.Reset;
                            salesLine.SetRange("Document Type", salesHeader."Document Type");
                            salesLine.SetRange("Document No.", salesHeader."No.");
                            salesLine.SetFilter(Description, '%1', '');
                            salesLine.SetRange(Type, salesLine.Type::Item);
                            salesLine.SetFilter("No.", '<>%1', '');
                            if salesLine.FindFirst() then
                                repeat
                                    clear(poLineNo);
                                    clear(poOrderNo);
                                    dShip := false;
                                    if salesLine."Drop Shipment" then begin
                                        poOrderNo := salesLine."Purchase Order No.";
                                        poLineNo := salesLine."Purch. Order Line No.";
                                        dShip := true;
                                        salesLine."Drop Shipment" := false;
                                        salesLine."Purchase Order No." := '';
                                        salesLine."Purch. Order Line No." := 0;
                                        salesLine.Modify(true);
                                    end;
                                    priceValue := salesLine."Unit Price";
                                    qtyValue := salesLine.Quantity;
                                    salesLine.Validate("No.", salesLine."No.");
                                    salesLine.Modify(true);
                                    salesLine.Validate(Quantity, qtyValue);
                                    salesLine.Validate("Unit Price", priceValue);
                                    salesLine.Modify(true);
                                    commit;
                                    salesLine.Validate("Drop Shipment", dShip);
                                    salesLine.Validate("Purchase Order No.", poOrderNo);
                                    salesLine.Validate("Purch. Order Line No.", poLineNo);

                                    salesLine.Modify(true);
                                until salesLine.Next() = 0;
                        until salesHeader.Next() = 0;
                end;
            }

            action("Delete Sales Orders")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Visible = true;

                trigger OnAction()
                var
                    salesLine: Record "Sales Line";
                    salesHeader: Record "Sales Header";
                    priceValue: Decimal;
                    qtyValue: Decimal;
                begin
                    CurrPage.SetSelectionFilter(salesHeader);
                    salesHeader.DeleteAllSalesLines();
                    salesHeader.DeleteAll();
                end;

            }
        }
    }
}

pageextension 50132 PstdSalesInvoices extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Location Code")
        {
            field("Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies the Territory for the Customer.';
                Visible = true;
            }
        }
    }
}

pageextension 50133 PstdSalesCrMemos extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("Location Code")
        {
            field("Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies the Territory for the Customer.';
                Visible = true;
            }
        }
    }
}

pageextension 50134 ReqWorksheetExt extends "Req. Worksheet"
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

pageextension 50135 PlannWorksheetExt extends "Planning Worksheet"
{
    layout
    {
        addafter("Ref. Order No.")
        {
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Sales Order No.';
                Visible = true;
            }
            field("Sales Order Line No."; Rec."Sales Order Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Sales Order Line No.';
                Visible = true;
            }
        }

    }

    actions
    {

        addbefore(Action109)
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

pageextension 50136 SalesLinesExt extends "Sales Lines"
{
    actions
    {
        addafter("Item &Tracking Lines")
        {
            action("Delete Lines")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Visible = true;

                trigger OnAction()
                var
                    salesLine: Record "Sales Line";
                    salesHeader: Record "Sales Header";
                    priceValue: Decimal;
                    qtyValue: Decimal;
                begin
                    CurrPage.SetSelectionFilter(salesLine);
                    salesLine.DeleteAll();
                end;
            }

            action("Validate Drop-Ship")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Visible = true;

                trigger OnAction()
                var
                    salesLine: Record "Sales Line";
                    salesHeader: Record "Sales Header";
                    priceValue: Decimal;
                    qtyValue: Decimal;
                begin
                    CurrPage.SetSelectionFilter(salesLine);
                    if salesLine.FindFirst() then
                        repeat
                            salesLine.Validate("Drop Shipment", true);
                            salesLine.Modify(true);
                        until salesLine.Next() = 0;
                end;
            }
        }
    }
}

pageextension 50137 ReleasedProdOrderExt extends "Released Production Orders"
{
    layout
    {
        addafter("Due Date")
        {
            field("Finished Quantity"; Rec."Finished Quantity")
            {
                ApplicationArea = All;
                Visible = true;
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
                    test: Report "SFI Production Order";
                begin
                    CurrPage.SetSelectionFilter(prodOrder);
                    prodOrderToRefresh.SetRange("Status", prodOrder.Status);
                    prodOrderToRefresh.SetRange("No.", prodOrder."No.");
                    REPORT.RunModal(REPORT::"Refresh Production Order", false, true, ProdOrderToRefresh);
                end;
            }
        }
    }
    var
        fQty: Integer;
}

pageextension 50138 WhsePickExt extends "Warehouse Pick"
{
    actions
    {
        addbefore("Autofill Qty. to Handle")
        {
            action("Split Pick")
            {
                ApplicationArea = All;
                Image = Splitlines;
                Visible = true;
                trigger OnAction()
                var
                    whseActHeader: Record "Warehouse Activity Header";
                    whseActLine: Record "Warehouse Activity Line";
                    whseActToHeader: Record "Warehouse Activity Header";
                    whseActToLine: Record "Warehouse Activity Line";
                    nextActHeadNo: Code[20];
                    noOfSplitsToMake: Integer;
                    countOfSplits: Integer;
                    arrOfLineNos: List of [Integer];
                    currWhseLineNo: Integer;
                    currRecCounter: Integer;
                    totRecCount: Integer;
                    currWhseNo: Code[20];
                    currWhseType: Enum "Warehouse Activity Type";
                    checkActLine: Codeunit toDoMgmt;
                    dialWindow: Dialog;
                    Text000: Label 'Progress from #1##### to #2#####';
                    test: Page "Released Production Order";
                begin
                    clear(nextActHeadNo);
                    clear(noOfSplitsToMake);
                    clear(countOfSplits);
                    clear(arrOfLineNos);
                    whseActHeader.Get(Rec.Type, Rec."No.");
                    whseActLine.Reset;
                    whseActLine.SetRange("No.", Rec."No.");
                    totRecCount := whseActLine.Count();
                    currRecCounter := 0;
                    dialWindow.Open(Text000, currRecCounter, totRecCount);
                    if whseActLine.FindFirst() then
                        repeat
                            currRecCounter := currRecCounter + 1;
                            dialWindow.Update();
                            if not checkActLine.VerifySplit(whseActLine, currWhseLineNo, currWhseNo, currWhseType) then begin
                                noOfSplitsToMake := noOfSplitsToMake + 1;
                                arrOfLineNos.Add(currWhseLineNo);
                            end;
                        until whseActLine.Next() = 0;
                    dialWindow.Close();
                    dialWindow.Open(Text000, countOfSplits, noOfSplitsToMake);
                    for countOfSplits := 1 to noOfSplitsToMake do begin
                        dialWindow.Update();
                        if nextActHeadNo = '' then
                            nextActHeadNo := whseActHeader."No.";

                        nextActHeadNo := IncStr(nextActHeadNo);
                        whseActToHeader.Init();
                        whseActToHeader.TransferFields(whseActHeader);
                        whseActToHeader."No." := nextActHeadNo;
                        whseActToHeader.Insert(true);
                        whseActLine.Reset;
                        whseActLine.SetRange("Activity Type", Rec.Type);
                        whseActLine.SetRange("No.", Rec."No.");
                        whseActLine.SetRange("Whse. Document Line No.", arrOfLineNos.Get(countOfSplits));
                        if whseActLine.findfirst() then
                            repeat
                                whseActToLine.Init;
                                whseActToLine.TransferFields(whseActLine);
                                whseActToLine."No." := nextActHeadNo;
                                whseActToLine.Insert(true);
                            until whseActLine.Next() = 0;
                    end;
                    dialWindow.Close();

                    whseActHeader.Delete(true);
                end;
            }
        }
    }
}

pageextension 50139 cashRecJnlExt extends "Cash Receipt Journal"
{
    actions
    {
        addbefore("Renumber Document Numbers")
        {
            action("Add Bal Acct")
            {
                ApplicationArea = All;
                Image = Splitlines;
                Visible = true;
                trigger OnAction()
                var
                    genJnlLine: Record "Gen. Journal Line";
                begin
                    CurrPage.SetSelectionFilter(genJnlLine);
                    if genJnlLine.FindFirst() then
                        repeat
                            genJnlLine.Validate("Bal. Account No.", '4601');
                            genJnlLine.Modify(true);
                        until genJnlLine.Next() = 0
                end;
            }
        }
    }
}

pageextension 50140 purchOrdersExt extends "Purchase Lines"
{
    actions
    {

        addbefore("Show Document")
        {
            action("Validate Missing Items")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Visible = true;

                trigger OnAction()
                var
                    purchLine: Record "Purchase Line";
                    purchHeader: Record "Purchase Header";
                    priceValue: Decimal;
                    qtyValue: Decimal;
                begin
                    CurrPage.SetSelectionFilter(purchLine);
                    if purchLine.FindFirst() then
                        repeat
                            purchLine.Validate("No.", purchLine."No.");
                            purchLine.Modify(true);
                        until purchLine.Next() = 0;
                end;
            }
        }
    }
}

pageextension 50141 firmPlanProdOrdersExt extends "Firm Planned Prod. Orders"
{
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
                    test: Report "SFI Production Order";
                begin
                    CurrPage.SetSelectionFilter(prodOrder);
                    prodOrderToRefresh.SetRange("Status", prodOrder.Status);
                    prodOrderToRefresh.SetRange("No.", prodOrder."No.");
                    REPORT.RunModal(REPORT::"Refresh Production Order", false, true, ProdOrderToRefresh);
                end;
            }

            action("Releasae All")
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

            action("Releasae All & Pick")
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
        }
    }
}

pageextension 50142 PurchOrderListExt extends "Purchase Order List"
{
    actions
    {
        addbefore("Send IC Purchase Order")
        {
            action("Delete Purchase Orders")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Visible = true;

                trigger OnAction()
                var
                    purchLine: Record "Purchase Line";
                    purchHeader: Record "Purchase Header";
                begin
                    CurrPage.SetSelectionFilter(purchHeader);
                    if purchHeader.findfirst() then
                        repeat
                            purchLine.Reset;
                            purchLine.SetRange("Document Type", purchHeader."Document Type");
                            purchLine.SetRange("Document No.", purchHeader."No.");
                            if purchLine.FindFirst() then
                                repeat
                                    purchLine.Delete(true);
                                until purchLine.Next() = 0;
                            purchHeader.Delete(true);
                        until purchHeader.Next() = 0

                end;

            }
        }
    }

}