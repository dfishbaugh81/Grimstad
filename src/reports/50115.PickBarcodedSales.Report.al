report 50115 "Pick - Barcoded (Sales)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './layouts/BcPickingListSales.rdl';
    Caption = 'Picking List';

    dataset
    {
        dataitem("Warehouse Activity Header"; "Warehouse Activity Header")
        {
            DataItemTableView = SORTING(Type, "No.") WHERE(Type = FILTER(Pick | "Invt. Pick"));
            RequestFilterFields = "No.", "No. Printed";
            column(No_WhseActivHeader; "No.")
            {
            }


            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(myMediaBarcode; tbBarcode.Image)
                {

                }
                column(CompanyName; COMPANYPROPERTY.DisplayName())
                {
                }
                column(TodayFormatted; Format(Today, 0, 4))
                {
                }
                column(Time; Time)
                {
                }
                column(PickFilter; PickFilter)
                {
                }
                column(DirectedPutAwayAndPick; Location."Directed Put-away and Pick")
                {
                }
                column(BinMandatory; Location."Bin Mandatory")
                {
                }
                column(InvtPick; InvtPick)
                {
                }
                column(ShowLotSN; ShowLotSN)
                {
                }
                column(SumUpLines; SumUpLines)
                {
                }
                column(No_WhseActivHeaderCaption; "Warehouse Activity Header".FieldCaption("No."))
                {
                }
                column(WhseActivHeaderCaption; "Warehouse Activity Header".TableCaption + ': ' + PickFilter)
                {
                }
                column(LoctnCode_WhseActivHeader; "Warehouse Activity Header"."Location Code")
                {
                }
                column(SortingMtd_WhseActivHeader; "Warehouse Activity Header"."Sorting Method")
                {
                }
                column(AssgUserID_WhseActivHeader; "Warehouse Activity Header"."Assigned User ID")
                {
                }
                column(SourcDocument_WhseActLine; "Warehouse Activity Line"."Source Document")
                {
                }
                column(LoctnCode_WhseActivHeaderCaption; "Warehouse Activity Header".FieldCaption("Location Code"))
                {
                }
                column(SortingMtd_WhseActivHeaderCaption; "Warehouse Activity Header".FieldCaption("Sorting Method"))
                {
                }
                column(AssgUserID_WhseActivHeaderCaption; "Warehouse Activity Header".FieldCaption("Assigned User ID"))
                {
                }
                column(SourcDocument_WhseActLineCaption; "Warehouse Activity Line".FieldCaption("Source Document"))
                {
                }
                column(SourceNo_WhseActLineCaption; WhseActLine.FieldCaption("Source No."))
                {
                }
                column(ShelfNo_WhseActLineCaption; WhseActLine.FieldCaption("Shelf No."))
                {
                }
                column(VariantCode_WhseActLineCaption; WhseActLine.FieldCaption("Variant Code"))
                {
                }
                column(Description_WhseActLineCaption; WhseActLine.FieldCaption(Description))
                {
                }
                column(ItemNo_WhseActLineCaption; WhseActLine.FieldCaption("Item No."))
                {
                }
                column(UOMCode_WhseActLineCaption; WhseActLine.FieldCaption("Unit of Measure Code"))
                {
                }
                column(QtytoHandle_WhseActLineCaption; WhseActLine.FieldCaption("Qty. to Handle"))
                {
                }
                column(QtyBase_WhseActLineCaption; WhseActLine.FieldCaption("Qty. (Base)"))
                {
                }
                column(DestinatnType_WhseActLineCaption; WhseActLine.FieldCaption("Destination Type"))
                {
                }
                column(DestinationNo_WhseActLineCaption; WhseActLine.FieldCaption("Destination No."))
                {
                }
                column(ZoneCode_WhseActLineCaption; WhseActLine.FieldCaption("Zone Code"))
                {
                }
                column(BinCode_WhseActLineCaption; WhseActLine.FieldCaption("Bin Code"))
                {
                }
                column(ActionType_WhseActLineCaption; WhseActLine.FieldCaption("Action Type"))
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(PickingListCaption; PickingListCaptionLbl)
                {
                }
                column(WhseActLineDueDateCaption; WhseActLineDueDateCaptionLbl)
                {
                }
                column(QtyHandledCaption; QtyHandledCaptionLbl)
                {
                }
                column(myShipBarCode; shipBarcode.Image)
                {
                }
                column(WhseDocumentNo_WhseActLine; WhseActLine."Whse. Document No.")
                {
                }
                column(SalesPerson_WhseActLine; salesPerson)
                {
                }
                column(ShipToAddress1; ShipToAddr[1])
                {
                }
                column(ShipToAddress2; ShipToAddr[2])
                {
                }
                column(ShipToAddress3; ShipToAddr[3])
                {
                }
                column(ShipToAddress4; ShipToAddr[4])
                {
                }
                column(ShipToAddress5; ShipToAddr[5])
                {
                }
                column(ShipToAddress6; ShipToAddr[6])
                {
                }
                column(ShipToAddress7; ShipToAddr[7])
                {
                }
                column(ShipToAddress8; ShipToAddr[8])
                {
                }
                column(CustomerAddress1; CustAddr[1])
                {
                }
                column(CustomerAddress2; CustAddr[2])
                {
                }
                column(CustomerAddress3; CustAddr[3])
                {
                }
                column(CustomerAddress4; CustAddr[4])
                {
                }
                column(CustomerAddress5; CustAddr[5])
                {
                }
                column(CustomerAddress6; CustAddr[6])
                {
                }
                column(CustomerAddress7; CustAddr[7])
                {
                }
                column(CustomerAddress8; CustAddr[8])
                {
                }
                column(CustomerNo; CustomerNo)
                {
                }
                column(PaymentAccountNo; PaymentAccountNo)
                {
                }
                column(ShippingAgent; ShippingAgent)
                {
                }
                column(ShippingAgentService; ShippingAgentService)
                {
                }
                dataitem("Warehouse Activity Line"; "Warehouse Activity Line")
                {
                    DataItemLink = "Activity Type" = FIELD(Type), "No." = FIELD("No.");
                    DataItemLinkReference = "Warehouse Activity Header";
                    DataItemTableView = SORTING("Activity Type", "No.", "Sorting Sequence No.");

                    trigger OnAfterGetRecord()
                    var
                        salesHeader: Record "Sales Header";
                    begin
                        if SumUpLines and
                           ("Warehouse Activity Header"."Sorting Method" <>
                            "Warehouse Activity Header"."Sorting Method"::Document)
                        then begin
                            if TempWhseActivLine."No." = '' then begin
                                TempWhseActivLine := "Warehouse Activity Line";
                                TempWhseActivLine.Insert();
                                Mark(true);
                            end else begin
                                TempWhseActivLine.SetSumLinesFilters("Warehouse Activity Line");
                                if "Warehouse Activity Header"."Sorting Method" =
                                   "Warehouse Activity Header"."Sorting Method"::"Ship-To"
                                then begin
                                    TempWhseActivLine.SetRange("Destination Type", "Destination Type");
                                    TempWhseActivLine.SetRange("Destination No.", "Destination No.")
                                end;
                                if TempWhseActivLine.FindFirst() then begin
                                    TempWhseActivLine."Qty. (Base)" := TempWhseActivLine."Qty. (Base)" + "Qty. (Base)";
                                    TempWhseActivLine."Qty. to Handle" := TempWhseActivLine."Qty. to Handle" + "Qty. to Handle";
                                    TempWhseActivLine."Source No." := '';
                                    if "Warehouse Activity Header"."Sorting Method" <>
                                       "Warehouse Activity Header"."Sorting Method"::"Ship-To"
                                    then begin
                                        TempWhseActivLine."Destination Type" := TempWhseActivLine."Destination Type"::" ";
                                        TempWhseActivLine."Destination No." := '';
                                    end;
                                    TempWhseActivLine.Modify();
                                end else begin
                                    TempWhseActivLine := "Warehouse Activity Line";
                                    TempWhseActivLine.Insert();
                                    Mark(true);
                                end;
                            end;
                        end else
                            Mark(true);

                        if "Warehouse Activity Line"."Whse. Document No." = '' then
                            lcuBarcodeManagement.Generate128Barcode(shipBarcode, "Warehouse Activity Line"."Source No.", 128, 32)
                        else
                            lcuBarcodeManagement.Generate128Barcode(shipBarcode, "Warehouse Activity Line"."Whse. Document No.", 128, 32);
                        lcuBarcodeManagement.Run();
                    end;

                    trigger OnPostDataItem()
                    begin
                        MarkedOnly(true);
                    end;

                    trigger OnPreDataItem()
                    begin
                        TempWhseActivLine.SetRange("Activity Type", "Warehouse Activity Header".Type);
                        TempWhseActivLine.SetRange("No.", "Warehouse Activity Header"."No.");
                        TempWhseActivLine.DeleteAll();
                        if BreakbulkFilter then
                            TempWhseActivLine.SetRange("Original Breakbulk", false);
                        Clear(TempWhseActivLine);
                    end;
                }
                dataitem(WhseActLine; "Warehouse Activity Line")
                {
                    DataItemLink = "Activity Type" = FIELD(Type), "No." = FIELD("No.");
                    DataItemLinkReference = "Warehouse Activity Header";
                    DataItemTableView = SORTING("Activity Type", "No.", "Sorting Sequence No.");
                    column(SourceNo_WhseActLine; "Source No.")
                    {
                    }
                    column(FormatSourcDocument_WhseActLine; Format("Source Document"))
                    {
                    }
                    column(ShelfNo_WhseActLine; "Shelf No.")
                    {
                    }
                    column(ItemNo_WhseActLine; "Item No.")
                    {
                    }
                    column(Description_WhseActLine; Description)
                    {
                    }
                    column(VariantCode_WhseActLine; "Variant Code")
                    {
                    }
                    column(UOMCode_WhseActLine; "Unit of Measure Code")
                    {
                    }
                    column(DueDate_WhseActLine; Format("Due Date"))
                    {
                    }
                    column(QtytoHandle_WhseActLine; "Qty. to Handle")
                    {
                    }
                    column(QtyBase_WhseActLine; "Qty. (Base)")
                    {
                    }
                    column(DestinatnType_WhseActLine; "Destination Type")
                    {
                    }
                    column(DestinationNo_WhseActLine; "Destination No.")
                    {
                    }
                    column(ZoneCode_WhseActLine; "Zone Code")
                    {
                    }
                    column(BinCode_WhseActLine; "Bin Code")
                    {
                    }
                    column(ActionType_WhseActLine; "Action Type")
                    {
                    }
                    column(LotNo_WhseActLine; "Lot No.")
                    {
                    }
                    column(SerialNo_WhseActLine; "Serial No.")
                    {
                    }
                    column(LotNo_WhseActLineCaption; FieldCaption("Lot No."))
                    {
                    }
                    column(SerialNo_WhseActLineCaption; FieldCaption("Serial No."))
                    {
                    }
                    column(LineNo_WhseActLine; "Line No.")
                    {
                    }
                    column(BinRanking_WhseActLine; "Bin Ranking")
                    {
                    }
                    column(EmptyStringCaption; EmptyStringCaptionLbl)
                    {
                    }
                    column(myRecShipBarCode; shipRecBarcode.Image)
                    {
                    }
                    column(salesCommLine; salesCommLine)
                    {
                    }
                    column(salesCommHeader; salesCommHeader)
                    {
                    }
                    column(WhseDocNo_WhseActLine; "Whse. Document No.")
                    {
                    }
                    dataitem(WhseActLine2; "Warehouse Activity Line")
                    {
                        DataItemLink = "Activity Type" = FIELD("Activity Type"), "No." = FIELD("No."), "Bin Code" = FIELD("Bin Code"), "Item No." = FIELD("Item No."), "Action Type" = FIELD("Action Type"), "Variant Code" = FIELD("Variant Code"), "Unit of Measure Code" = FIELD("Unit of Measure Code"), "Due Date" = FIELD("Due Date");
                        DataItemLinkReference = WhseActLine;
                        DataItemTableView = SORTING("Activity Type", "No.", "Bin Code", "Breakbulk No.", "Action Type");
                        column(LotNo_WhseActLine2; "Lot No.")
                        {
                        }
                        column(SerialNo_WhseActLine2; "Serial No.")
                        {
                        }
                        column(QtyBase_WhseActLine2; "Qty. (Base)")
                        {
                        }
                        column(QtytoHandle_WhseActLine2; "Qty. to Handle")
                        {
                        }
                        column(LineNo_WhseActLine2; "Line No.")
                        {
                        }


                        dataitem(SalesLine; "Sales Line")
                        {
                            DataItemLink = "Document No." = FIELD("Source No."), "Line No." = FIELD("Source Line No."), "No." = FIELD("Item No."), "Variant Code" = FIELD("Variant Code"), "Unit of Measure Code" = FIELD("Unit of Measure Code");
                            DataItemLinkReference = WhseActLine;
                            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");


                        }
                    }

                    trigger OnAfterGetRecord()
                    var
                        salesHeader: Record "Sales Header";
                        salesCommentLine: Record "Sales Comment Line";
                        salesCommentHeader: Record "Sales Comment Line";
                        DshipPackOptions: Record "DSHIP Package Options";
                        test: Page "Warehouse Pick";
                    begin
                        lcuBarcodeManagement.Generate128Barcode(shipRecBarcode, "Warehouse Activity Line"."Whse. Document No.", 128, 32);
                        lcuBarcodeManagement.Run();
                        if SumUpLines then begin
                            TempWhseActivLine.Get("Activity Type", "No.", "Line No.");
                            "Qty. (Base)" := TempWhseActivLine."Qty. (Base)";
                            "Qty. to Handle" := TempWhseActivLine."Qty. to Handle";
                        end;

                        clear(salesCommLine);
                        salesCommentLine.Reset;
                        salesCommentLine.SetRange("Document Type", salesCommentLine."Document Type"::Order);
                        salesCommentLine.SetRange("No.", WhseActLine."Source No.");
                        salesCommentLine.SetRange("Document Line No.", WhseActLine."Source Line No.");
                        salesCommentLine.SetRange("Print On Pick Ticket", true);
                        if salesCommentLine.FindFirst() then
                            repeat
                                salesCommLine := salesCommLine + ' ' + salesCommentLine.Comment;
                            until salesCommentLine.Next = 0;

                        clear(salesCommHeader);
                        salesCommentHeader.Reset;
                        salesCommentHeader.SetRange("Document Type", salesCommentHeader."Document Type"::Order);
                        salesCommentHeader.SetRange("No.", WhseActLine."Source No.");
                        salesCommentHeader.SetRange("Document Line No.", 0);
                        salesCommentHeader.SetRange("Print On Pick Ticket", true);
                        if salesCommentHeader.FindFirst() then
                            repeat
                                salesCommHeader := salesCommHeader + ' ' + salesCommentHeader.Comment;
                            until salesCommentHeader.Next = 0;

                        salesHeader.Reset;
                        salesHeader.SetRange("Document Type", salesHeader."Document Type"::Order);
                        salesHeader.SetRange("No.", "Warehouse Activity Line"."Source No.");
                        if salesHeader.FindFirst() then
                            salesPerson := salesHeader."Salesperson Code"
                        else
                            salesPerson := '';


                        FormatAddr.SalesHeaderBillTo(CustAddr, salesHeader);
                        FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, salesHeader);

                        ShippingAgent := salesHeader."Shipping Agent Code";
                        ShippingAgentService := salesHeader."Shipping Agent Service Code";

                        CustomerNo := salesHeader."Sell-to Customer No.";

                        DshipPackOptions.Reset;
                        if DshipPackOptions.Get("No.") then
                            PaymentAccountNo := DshipPackOptions."Payment Account No."
                        else
                            PaymentAccountNo := '';
                    end;

                    trigger OnPreDataItem()
                    begin
                        Copy("Warehouse Activity Line");
                        Counter := Count;
                        if Counter = 0 then
                            CurrReport.Break();

                        if BreakbulkFilter then
                            SetRange("Original Breakbulk", false);
                    end;
                }

            }

            trigger OnAfterGetRecord()
            begin
                lcuBarcodeManagement.Generate128Barcode(tbBarcode, "Warehouse Activity Header"."No.", 128, 32);
                lcuBarcodeManagement.Run();

                GetLocation("Location Code");
                InvtPick := Type = Type::"Invt. Pick";
                if InvtPick then
                    BreakbulkFilter := false
                else
                    BreakbulkFilter := "Breakbulk Filter";



                if not IsReportInPreviewMode() then
                    CODEUNIT.Run(CODEUNIT::"Whse.-Printed", "Warehouse Activity Header");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Breakbulk; BreakbulkFilter)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Set Breakbulk Filter';
                        Editable = BreakbulkEditable;
                        ToolTip = 'Specifies if you do not want to view the intermediate lines that are created when the unit of measure is changed in pick instructions.';
                    }
                    field(SumUpLines; SumUpLines)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Sum up Lines';
                        Editable = SumUpLinesEditable;
                        ToolTip = 'Specifies if you want the lines to be summed up for each item, such as several pick lines that originate from different source documents that concern the same item and bins.';
                    }
                    field(LotSerialNo; ShowLotSN)
                    {
                        ApplicationArea = Warehouse;
                        Caption = 'Show Serial/Lot Number';
                        ToolTip = 'Specifies if you want to show lot and serial number information for items that use item tracking.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            SumUpLinesEditable := true;
            BreakbulkEditable := true;
        end;

        trigger OnOpenPage()
        begin
            if HideOptions then begin
                BreakbulkEditable := false;
                SumUpLinesEditable := false;
            end;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        PickFilter := "Warehouse Activity Header".GetFilters();
    end;

    var
        Location: Record Location;
        TempWhseActivLine: Record "Warehouse Activity Line" temporary;
        PickFilter: Text;
        InvtPick: Boolean;
        Counter: Integer;
        CurrReportPageNoCaptionLbl: Label 'Page';
        PickingListCaptionLbl: Label 'Picking List';
        WhseActLineDueDateCaptionLbl: Label 'Due Date';
        QtyHandledCaptionLbl: Label 'Qty. Handled';
        EmptyStringCaptionLbl: Label '____________';
        lcuBarcodeManagement: Codeunit "IWX Library - Barcode Gen";
        WhseActsLine: Record "Warehouse Activity Line";
        tbBarcode: Record "IWX Barcode" temporary;
        shipBarcode: Record "IWX Barcode" temporary;
        shipRecBarcode: Record "IWX Barcode" temporary;
        salesPerson: Code[20];
        salesCommLine: Text;
        salesCommHeader: Text;
        FormatAddr: Codeunit "Format Address";
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        CustomerNo: Code[20];
        SalesOrderNo: Code[20];
        ShippingAgent: Code[10];
        ShippingAgentService: Code[10];
        PaymentAccountNo: Text[100];

    protected var
        BreakbulkFilter: Boolean;
        HideOptions: Boolean;
        ShowLotSN: Boolean;
        SumUpLines: Boolean;
        [InDataSet]
        BreakbulkEditable: Boolean;
        [InDataSet]
        SumUpLinesEditable: Boolean;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.Init()
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview or MailManagement.IsHandlingGetEmailBody());
    end;

    procedure SetBreakbulkFilter(BreakbulkFilter2: Boolean)
    begin
        BreakbulkFilter := BreakbulkFilter2;
    end;

    procedure SetInventory(SetHideOptions: Boolean)
    begin
        HideOptions := SetHideOptions;
    end;


}

