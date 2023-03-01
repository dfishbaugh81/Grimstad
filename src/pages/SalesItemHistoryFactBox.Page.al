page 50112 "Sales Item History FactBox"
{
    Caption = 'Item/Sales History';
    PageType = ListPart;
    SourceTable = "Sales Invoice Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(InvoiceDate; Rec.InvoiceDate)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Invoice Date.';

                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the document number.';

                    trigger OnDrillDown()
                    var
                        pstdHead: Record "Sales Invoice Header";
                    begin
                        if pstdHead.Get(Rec."Document No.") then
                            GoToPstdDoc(pstdHead);
                    end;

                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the customer.';
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the line type.';
                    Visible = false;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';

                    trigger OnDrillDown()
                    var
                        item: Record Item;
                    begin
                        if item.Get(Rec."No.") then
                            ShowDetails(item);
                    end;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of units of the item specified on the line.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the discount percentage that is granted for the item on the line.';
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the discount amount that is granted for the item on the line.';
                    Visible = false;
                }
            }


        }
    }

    actions
    {
    }

    local procedure ShowDetails(var item: Record Item)
    begin
        PAGE.Run(PAGE::"Item Card", item);
    end;

    local procedure GoToPstdDoc(var pstdHead: Record "Sales Invoice Header")
    begin
        PAGE.Run(PAGE::"Posted Sales Invoice", pstdHead)
    end;
}

