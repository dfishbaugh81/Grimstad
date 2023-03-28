report 50110 "Dyn Packing List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './layouts/DynPackList.rdl';
    Caption = 'Packing List';

    dataset
    {
        dataitem("IWX LP Header"; "IWX LP Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Source Document", "Source No.", "Shipped Source Document", "Shipped Source No.";
            column(PackageNo; "No.")
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
            column(Package_Tracking_No_; "Package Tracking No.")
            {
            }
            column(Shipment_Tracking_URL; "Shipment Tracking URL")
            {
            }
            column(Shipment_Gross_Weight; "Shipment Gross Weight")
            {
            }
            column(Shipment_No_; "Shipment No.")
            {
            }
            column(Current_Item_Count; "Current Item Count")
            {
            }
            column(Description_Cons; Description)
            {
            }
            column(Shipment_Date; "Shipment Date")
            {
            }
            column(CustPONo; CustPONo)
            {
            }
            column(CustNo; CustNo)
            {
            }
            column(SalesOrdNo; SalesOrdNo)
            {
            }
            column(OrdDate; OrdDate)
            {
            }
            column(SalesPerson; SalesPerson)
            {
            }
            column(PayTerms; PayTerms)
            {
            }
            column(Shipped_Item_Count; "Shipped Item Count")
            {
            }
            column(SalesHeaderText; SalesHeaderText)
            {
            }
            column(ShipSummaryLine; ShipSummaryLine)
            {
            }
            dataitem("IWX LP Line"; "IWX LP Line")
            {
                DataItemLink = "License Plate No." = field("No.");
                DataItemLinkReference = "IWX LP Header";
                DataItemTableView = SORTING("License Plate No.", "Line No.");
                dataitem(Item; Item)
                {
                    DataItemLink = "No." = field("No.");
                    DataItemLinkReference = "IWX LP Line";
                    DataItemTableView = SORTING("No.");

                    column(Description; Description)
                    {
                    }
                    column(Description_2; "Description 2")
                    {
                    }
                    column(Unit_Price; "Unit Price")
                    {
                    }
                    column(Unit_Cost; "Unit Cost")
                    {
                    }
                    column(Vendor_Item_No_; "Vendor Item No.")
                    {
                    }
                    column(Vendor_No_; "Vendor No.")
                    {
                    }
                    column(Vendor_Name; "Vendor Name")
                    {
                    }
                    column(Unit_List_Price; "Unit List Price")
                    {
                    }
                    column(Gross_Weight; "Gross Weight")
                    {
                    }
                    column(Net_Weight; "Net Weight")
                    {
                    }
                    column(Tariff_No_; "Tariff No.")
                    {
                    }
                    column(Global_Dimension_1_Code; "Global Dimension 1 Code")
                    {
                    }
                    column(Global_Dimension_2_Code; "Global Dimension 2 Code")
                    {
                    }
                    column(Assembly_Policy; "Assembly Policy")
                    {
                    }
                    column(GTIN; GTIN)
                    {
                    }
                    column(Manufacturing_Policy; "Manufacturing Policy")
                    {
                    }
                    column(Item_Category_Code; "Item Category Code")
                    {
                    }
                    column(Service_Item_Group; "Service Item Group")
                    {
                    }
                    column(Assembly_BOM; "Assembly BOM")
                    {
                    }
                }

                column(No_; "No.")
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(UnitofMeasure; "Unit of Measure Code")
                {
                }
                column(lblComment_1; lblComment[1])
                {
                }
                column(lblComment_2; lblComment[2])
                {
                }
                column(lblComment_3; lblComment[3])
                {
                }
                column(lblComment_4; lblComment[4])
                {
                }
                column(lblComment_5; lblComment[5])
                {
                }
                column(lblComment_6; lblComment[6])
                {
                }
                column(lblComment_7; lblComment[7])
                {
                }
                column(lblComment_8; lblComment[8])
                {
                }
                column(lblComment_9; lblComment[9])
                {
                }
                column(lblComment_10; lblComment[10])
                {
                }
                column(ItemRefNo; ItemRefNo)
                {
                }
                column(QtyOnOrder; QtyOnOrder)
                {
                }
                column(QtyShipped; QtyShipped)
                {
                }
                column(QtyBack; QtyBack)
                {
                }
                column(LineNo_Line; "Line No.")
                {
                }
                column(Type_Line; Type_Line)
                {
                }
                trigger OnAfterGetRecord()
                var
                    SalesCommentLine: Record "Sales Comment Line";
                    iCommCount: Integer;
                begin
                    clear(Type_Line);
                    clear(ItemRefNo);
                    Clear(lblComment);
                    clear(QtyOnOrder);
                    clear(QtyShipped);
                    clear(QtyBack);
                    Line.Reset;
                    Line.SetRange("Document Type", Line."Document Type"::Order);
                    Line.SetRange("Document No.", "IWX LP Header"."Shipped Source No.");
                    Line.SetRange("No.", "No.");
                    //Line.SetFilter("Outstanding Quantity", '>%1', 0);
                    if Line.FindFirst() then begin
                        ItemRefNo := Line."Item Reference No.";
                        QtyOnOrder := Line.Quantity;
                        QtyShipped := Line."Qty. to Ship";
                        QtyBack := Line.Quantity - Line."Quantity Shipped" - Line."Qty. to Ship";
                        Type_Line := Line.Type;
                        iCommCount := 0;
                        SalesCommentLine.Reset;
                        SalesCommentLine.SetRange("Document Type", Line."Document Type");
                        SalesCommentLine.SetRange("No.", Line."Document No.");
                        SalesCommentLine.SetRange("Document Line No.", Line."Line No.");
                        SalesCommentLine.SetRange("Print On Order Confirmation", true);
                        if SalesCommentLine.FindFirst() then
                            repeat
                                iCommCount := iCommCount + 1;
                                lblComment[iCommCount] := SalesCommentLine.Comment;
                            until SalesCommentLine.Next() = 0;
                        if iCommCount > 0 then
                            CompressArray(lblComment);
                    end else begin
                        Line.Reset;
                        Line.SetRange("Document Type", Line."Document Type"::Order);
                        Line.SetRange("Document No.", "IWX LP Header"."Source No.");
                        Line.SetRange("No.", "No.");
                        //Line.SetFilter("Outstanding Quantity", '>%1', 0);
                        if Line.FindFirst() then begin
                            ItemRefNo := Line."Item Reference No.";
                            QtyOnOrder := Line.Quantity;
                            QtyShipped := Line."Qty. to Ship";
                            QtyBack := Line.Quantity - Line."Quantity Shipped" - Line."Qty. to Ship";
                            Type_Line := Line.Type;
                            iCommCount := 0;
                            SalesCommentLine.Reset;
                            SalesCommentLine.SetRange("Document Type", Line."Document Type");
                            SalesCommentLine.SetRange("No.", Line."Document No.");
                            SalesCommentLine.SetRange("Document Line No.", Line."Line No.");
                            SalesCommentLine.SetRange("Print On Order Confirmation", true);
                            if SalesCommentLine.FindFirst() then
                                repeat
                                    iCommCount := iCommCount + 1;
                                    lblComment[iCommCount] := SalesCommentLine.Comment;
                                until SalesCommentLine.Next() = 0;
                            if iCommCount > 0 then
                                CompressArray(lblComment);
                        end;
                    end;

                end;

            }

            trigger OnAfterGetRecord()
            var
                SalesHeaderComment: Record "Sales Comment Line";
                SalespersonPurchaser: Record "Salesperson/Purchaser";
            begin
                clear(CustPONo);
                clear(CustNo);
                clear(SalesOrdNo);
                clear(OrdDate);
                clear(SalesPerson);
                clear(PayTerms);
                clear(SalesHeaderText);

                FormatAddr.SalesHeaderBillTo(CustAddr, Header);
                FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, Header);
                CustPONo := Header."Your Reference";
                CustNo := Header."Sell-to Customer No.";
                SalesOrdNo := Header."No.";
                OrdDate := Header."Document Date";
                PayTerms := Header."Payment Terms Code";
                if SalespersonPurchaser.Get(Header."Salesperson Code") then
                    SalesPerson := SalespersonPurchaser.Name;
                clear(SalesHeaderText);
                SalesHeaderComment.Reset;
                SalesHeaderComment.SetRange("Document Type", Header."Document Type");
                SalesHeaderComment.SetRange("No.", Header."No.");
                SalesHeaderComment.SetRange("Document Line No.", 0);
                SalesHeaderComment.SetRange("Print On Shipment", true);
                if SalesHeaderComment.FindFirst() then
                    repeat
                        SalesHeaderText := SalesHeaderText + ' ' + SalesHeaderComment.Comment;
                    until SalesHeaderComment.Next() = 0;
                ShipSummaryLine := '***Shipment Summary                               ' + Format("Current Item Count") + ' Boxes       ' + Format("Shipment Gross Weight") + ' Lbs. Weight';
            end;

            trigger OnPreDataItem()
            begin
                if "Source Document" = "Source Document"::" " then
                    Evaluate("Source Document", GetFilter("Source Document"));
                if "Source No." = '' then
                    Evaluate("Source No.", GetFilter("Source No."));
                case "Source Document" of
                    "Source Document"::Shipment:
                        begin
                            WhHeader.Get("Source No.");
                            myRecRef.GetTable(WhHeader);
                            dshipPackMan.getPackageData(myRecRef, ptrecLineBuffer);
                        end;
                    "Source Document"::"Sales Order":
                        begin
                            Header.Get(Header."Document Type"::Order, "Source No.");
                            myRecRef.GetTable(Header);
                            dshipPackMan.getPackageData(myRecRef, ptrecLineBuffer);
                        end;
                    else
                        exit;
                end;

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

                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
        end;

        trigger OnOpenPage()
        begin

        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
    end;

    var
        SalesOrderNo: Code[20];
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        FormatAddr: Codeunit "Format Address";
        SalesHeaderText: Text;
        lblComment: array[10] of text[100];
        ItemRefNo: code[50];
        QtyOnOrder: Decimal;
        QtyShipped: Decimal;
        QtyBack: Decimal;
        OrdDate: Date;
        CustPONo: Text[35];
        SalesOrdNo: Code[20];
        CustNo: Code[20];
        SalesPerson: Text[50];
        PayTerms: Code[10];
        Type_Line: Enum "Item Type";
        ShipSummaryLine: Text;
        Header: Record "Sales Header";
        WhHeader: Record "Warehouse Shipment Header";
        Line: Record "Sales Line";
        WhLine: Record "Warehouse Shipment Line";
        ptrecLineBuffer: Record "DSHIP Package Line Buffer" temporary;
        dshipPackMan: Codeunit "DSHIP Package Management";
        myRecRef: RecordRef;
        sourceDocFilt: Option " ","Purchase Order","Sales Order","Inbound Transfer","Outbound Transfer","Prod. Order","Put-away",Pick,Movement,"Invt. Put-away","Invt. Pick",Receipt,Shipment,Reclass,"Purchase Return Order",Assembly,"Invt. Movement","Misc. Shipment";
        sourceDocFiltNo: Code[20];




}