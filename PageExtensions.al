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
        addbefore("No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Importance = Standard;
                ToolTip = 'Specifies Line No.';
                Visible = true;
            }
        }
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = Manufacturing;
                Importance = Additional;
                ToolTip = 'Specifies information in addition to the description.';
                Visible = true;
            }

            field("Component Count"; Rec."Component Count")
            {
                ApplicationArea = Manufacturing;
                Importance = Additional;
                ToolTip = 'Indicates the number of components if sub-assembly.';
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

        modify("Unit Price")
        {
            BlankZero = false;
            Style = Unfavorable;
            StyleExpr = Rec."Unit Price" = 0;
        }

        modify("Line Amount")
        {
            BlankZero = false;
            Style = Unfavorable;
            StyleExpr = Rec."Unit Price" = 0;
        }

        modify("Drop Shipment")
        {
            ApplicationArea = None;
            Visible = false;
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
            field("Drop Ship"; Rec.dropship)
            {
                Caption = 'Drop Shipment';
                Visible = true;
                ApplicationArea = Basic, Suite;

                trigger OnValidate()
                var
                    SalesLine: Record "Sales Line";
                    CurrLineNo: Integer;
                    DropShipItemNo: Code[20];
                    DropShipPoNo: Code[20];
                    DropShipPoLineNo: Integer;
                    DropShipLineNo: Integer;
                    ToDoMgmt: Codeunit toDoMgmt;
                    purchHeader: Record "Purchase Header";
                begin
                    clear(DropShipItemNo);
                    clear(DropShipLineNo);
                    clear(DropShipPoNo);
                    clear(DropShipPoLineNo);
                    CurrLineNo := Rec."Line No.";
                    if Rec.Type = Rec.Type::Item then
                        Rec.Validate("Drop Shipment", Rec.dropship);
                    if Rec.dropship then begin
                        if Rec.Type = Rec.Type::" " then begin
                            SalesLine.Reset;
                            SalesLine.SetRange("Document Type", Rec."Document Type");
                            SalesLine.SetRange("Document No.", Rec."Document No.");
                            SalesLine.SetRange("Drop Shipment", true);
                            if SalesLine.FindFirst() then
                                repeat
                                    if CurrLineNo > SalesLine."Line No." then begin
                                        DropShipItemNo := SalesLine."No.";
                                        DropShipLineNo := SalesLine."Line No.";
                                        DropShipPoNo := SalesLine."Purchase Order No.";
                                        DropShipPoLineNo := SalesLine."Purch. Order Line No.";
                                    end;
                                until ((SalesLine.Next() = 0) or (CurrLineNo < SalesLine."Line No."));
                            ToDoMgmt.AddItemTextToSalesCommentLine(Rec."Document Type", Rec."Document No.", DropShipLineNo, Rec.GetDate(), Rec."Description");
                            if ((DropShipPONo <> '') and (DropShipPoLineNo <> 0)) then begin
                                ToDoMgmt.AddItemTextToPurchCommentLine(purchHeader."Document Type"::Order, DropShipPoNo, DropShipPOLineNo, Rec.GetDate(), Rec."Description");
                                Message('The Comment: %1 has been copied to Drop Ship Item No.: %2 on Purchase Order No.: %3 and Purchase Line No.: %4', Rec.Description, DropshipItemNo, DropShipPoNo, DropShipPoLineNo);

                            end;
                            if Confirm('The Comment: %1 has been copied to Drop Ship Item No.: %2. \\ Do you want to delete the comment here?', true, Rec.Description, DropShipItemNo) then
                                Rec.Delete;

                        end;
                    end;
                end;
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

            field(ASN; Rec.ASN)
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'ASN trigger.';
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

        addafter("Requested Delivery Date")
        {
            field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
            {
                ApplicationArea = All;
                Importance = Standard;
                ToolTip = 'Applies-to Type';
                Visible = false;
            }

            field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = All;
                Importance = Standard;
                ToolTip = 'Applies-to Doc No.';
                Visible = false;
            }

            field(ASN; Rec.ASN)
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'ASN trigger.';
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
                    test: Record "Routing Comment Line";
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

            field("Firm Planned Order No."; Rec."Firm Planned Order No.")
            {
                ApplicationArea = All;
                Visible = true;
            }

            field("Production BOM"; Rec."Production BOM")
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
                    whseActHeaderLast: Record "Warehouse Activity Header";
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
                        if nextActHeadNo = '' then begin
                            whseActHeaderLast.Reset;
                            whseActHeaderLast.FindLast();
                            nextActHeadNo := whseActHeaderLast."No.";
                        end;


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
    layout
    {
        addafter("Routing No.")
        {
            field("Planned Order No."; Rec."Planned Order No.")
            {
                ApplicationArea = All;
                Caption = 'Orig Prod No.';
                Visible = true;
            }

            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                Caption = 'Description';
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

pageextension 50143 FirmPlannedProdOrderLineExt extends "Firm Planned Prod. Order Lines"
{
    layout
    {
        addbefore("Due Date")
        {
            field(ComponentCount; Rec.ComponentCount)
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
        modify("Description 2")
        {

            ApplicationArea = All;
            Visible = true;

        }
    }
}

pageextension 50144 ProdOrdCompLineListExt extends "Prod. Order Comp. Line List"
{
    layout
    {
        addafter("Prod. Order Line No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
    }
}

pageextension 50145 FirmPlanProdOrdExt extends "Firm Planned Prod. Order"
{
    layout
    {
        addafter("Source No.")
        {
            field("Planned Order No."; Rec."Planned Order No.")
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
    }

    actions
    {
        addafter("Plannin&g")
        {
            action("Open Lines")
            {
                ApplicationArea = Basic, Suite;

                trigger OnAction()
                var
                    prodOrdLines: Page "Prod. Order Lines";
                begin
                    prodOrdLines.RunModal();
                end;
            }
        }
    }
}

pageextension 50146 SalesJournalExt extends "Sales Journal"
{
    actions
    {
        addafter("Insert Conv. LCY Rndg. Lines")
        {
            action("Unselect Correction")
            {
                ApplicationArea = Basic, Suite;
                trigger OnAction()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    CurrPage.SetSelectionFilter(GenJnlLine);
                    GenJnlLine.ModifyAll(Correction, false, true);

                end;
            }
        }
    }
}

pageextension 50147 PurchPriceListLineExt extends "Purchase Price List Lines"
{
    layout
    {
        addafter(AssignToNo)
        {
            field(AssignToName; Rec.AssignToName)
            {
                Caption = 'Vendor Name';
                ApplicationArea = All;
                Visible = true;
            }
        }

    }
}

pageextension 50148 RelProdOrdLineExt extends "Released Prod. Order Lines"
{
    layout
    {
        modify("Description 2")
        {
            Caption = 'Description 2';
            ApplicationArea = All;
            Visible = true;
        }
    }
}

pageextension 50149 BinContentsExt extends "Bin Contents"
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
                begin
                    if UserSetup.Get(UserId()) then
                        if UserSetup."User ID" = 'BCADMIN' then
                            WarEntEd.Run();
                end;
            }
        }
    }
}