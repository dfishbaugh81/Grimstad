report 50101 "Production Order Routing"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ProdOrderRouting.rdl';
    AdditionalSearchTerms = 'production order routing';
    ApplicationArea = Manufacturing;
    Caption = 'Prod. Order Routing';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Production Order"; "Production Order")
        {
            dataitem("Prod. Order Line"; "Prod. Order Line")
            {
                DataItemLink = "Prod. Order No." = field("No.");
                dataitem("Prod. Order Comment Line"; "Prod. Order Comment Line")
                {
                    DataItemLink = "Prod. Order No." = field("Prod. Order No."), "Line No." = field("Line No.");
                    column(fldCOmment; "Prod. Order Comment Line".Comment)
                    {
                    }
                    column(xSection2; 'Integer')
                    {
                    }
                    column(Prod__Order_Comment_Line_Status; "Prod. Order Comment Line".Status)
                    {
                    }
                    column(Prod__Order_Comment_Line_Prod__Order_No_; "Prod. Order Comment Line"."Prod. Order No.")
                    {
                    }
                    column(Prod__Order_Comment_Line_Line_No_; "Prod. Order Comment Line"."Line No.")
                    {
                    }
                }

                dataitem("Prod. Order Component"; "Prod. Order Component")
                {
                    DataItemLink = "Prod. Order No." = field("Prod. Order No."), "Prod. Order Line No." = field("Line No.");
                    column(Prod_Comp_Item_Number; "Prod. Order Component"."Item No.")
                    {
                    }
                    column(xSection3; 'Integer')
                    {
                    }
                    column(Prod_Comp_Description; "Prod. Order Component".Description)
                    {
                    }
                    column(Prod_Comp_Quantity; "Prod. Order Component".Quantity)
                    {
                    }
                    column(Prod_Comp_Shelf; "Prod. Order Component"."Bin Code")
                    {
                    }
                    column(Prod__Order_Component_Status; "Prod. Order Component".Status)
                    {
                    }
                    column(Prod__Order_Component_Prod__Order_No_; "Prod. Order Component"."Prod. Order No.")
                    {
                    }
                    column(Prod__Order_Component_Prod__Order_Line_No_; "Prod. Order Component"."Prod. Order Line No.")
                    {
                    }
                    column(Prod__Order_Component_Line_No_; "Prod. Order Component"."Line No.")
                    {
                    }
                }
                dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
                {
                    DataItemLink = "Prod. Order No." = field("Prod. Order No."), "Routing Reference No." = field("Line No.");
                    dataitem("Prod. Order Rtng Comment Line"; "Prod. Order Rtng Comment Line")
                    {
                        DataItemLink = "Prod. Order No." = field("Prod. Order No."), "Routing No." = field("Routing No."), "Routing Reference No." = field("Routing Reference No."), "Operation No." = field("Operation No.");
                        column(fldRtngComment; "Prod. Order Rtng Comment Line".Comment)
                        {
                        }
                        column(Prod__Order_Rtng_Comment_Line_Status; "Prod. Order Rtng Comment Line".Status)
                        {
                        }
                        column(Prod__Order_Rtng_Comment_Line_Prod__Order_No_; "Prod. Order Rtng Comment Line"."Prod. Order No.")
                        {
                        }
                        column(Prod__Order_Rtng_Comment_Line_Line_No_; "Prod. Order Rtng Comment Line"."Line No.")
                        {
                        }
                    }
                    column(xSection4; 'Integer')
                    {
                    }
                    column(Prod__Order_Routing_Line__Operation_No__; "Prod. Order Routing Line"."Operation No.")
                    {
                    }
                    column(Prod_Routing_Work_Center; "Prod. Order Routing Line"."Work Center No.")
                    {
                    }
                    column(Prod_Routing_Description; "Prod. Order Routing Line".Description)
                    {
                    }
                    column(Prod_Routing_Est_Time; "Prod. Order Routing Line"."Maximum Process Time")
                    {
                    }
                    column(Prod_Routing_BarcodeText; 'Text')
                    {
                    }
                    column(Prod_Routing_SetupBarcodeText; 'Text')
                    {
                    }
                    column(Prod_Routing_BarcodeBlob; 'Blob')
                    {
                    }
                    column(Prod_Routing_SetupBarcodeBlob; 'Blob')
                    {
                    }
                    column(Prod__Order_Routing_Line_Status; "Prod. Order Routing Line".Status)
                    {
                    }
                    column(Prod__Order_Routing_Line_Prod__Order_No_; "Prod. Order Routing Line"."Prod. Order No.")
                    {
                    }
                    column(Prod__Order_Routing_Line_Routing_Reference_No_; "Prod. Order Routing Line"."Routing Reference No.")
                    {
                    }
                    column(Prod__Order_Routing_Line_Routing_No_; "Prod. Order Routing Line"."Routing No.")
                    {
                    }
                }
                column(fldProdOrderNo; "Prod. Order Line"."Prod. Order No.")
                {
                }
                column(xSection1; 'Integer')
                {
                }
                column(fldSectionator; 'Integer')
                {
                }
                column(Prod_Order_Source_No; "Prod. Order Line"."Item No.")
                {
                }
                column(Prod_Order_Shelf_No; "Prod. Order Line"."Bin Code")
                {
                }
                column(Prod_Order_Quantity; "Prod. Order Line".Quantity)
                {
                }
                column(Prod_Order_Est_Weight; 'Decimal')
                {
                }
                column(Prod_Order_Start_Date; "Prod. Order Line"."Starting Date")
                {
                }
                column(Prod_Order_End_Date; "Prod. Order Line"."Ending Date")
                {
                }
                column(Prod_Order_Description; "Prod. Order Line".Description)
                {
                }
                column(Prod_Order_Description2; "Prod. Order Line"."Description 2")
                {
                }
                column(fldBarcode; 'Blob')
                {
                }
                column(Production_Order_Status; "Prod. Order Line".Status)
                {
                }
                column(Prod_Order_Line_Line_No; "Prod. Order Line"."Line No.")
                {
                }
                column(Prod_Order_Line_Item_No; "Prod. Order Line"."Item No.")
                {
                }
            }
        }
    }
    var
        recItem: Record Item;
        iSection: Integer;
        sOperBarcode: Text;
        sSetupBarcode: Text;
        codToolNo: Code[20];
        sToolDescription: Text;
        codPersonNo: Code[20];
        sPersonDescription: Text;
        codQualityMeasure: Code[50];
        sQualityDescription: Text;
        sQualityText: Text;
        recTools: Record "Prod. Order Routing Tool";
        recPersonnel: Record "Prod. Order Routing Personnel";
        recQualityMeasures: Record "Prod. Order Rtng Qlty Meas.";
        iIndex: Integer;
        tcQualityText: Label 'QC Test';
        cuBarcodeMgmt: codeunit "SFI Barcode Mgmt";
        trecRoutingBarcode: Record "SFI TempBlob" temporary;
        trecRoutingSetupBarcode: Record "SFI TempBlob" temporary;
        iBarcodeWidth: Integer;
        iBarcodeHeight: Integer;
        bIsAzureBarcode: Boolean;
}
