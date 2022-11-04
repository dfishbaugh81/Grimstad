page 50110 "User CRM Tasks Activities"
{
    Caption = 'CRM Tasks';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "To-Do";

    layout
    {
        area(content)
        {
            cuegroup("My CRM Tasks")
            {

                Caption = 'My CRM Tasks';
                field("ToDoTaskManagement.GetTotalRecCount(Rec)"; ToDoTaskManagement.GetTotalRecCount(Rec, UserId))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'User CRM Tasks';
                    Image = Checklist;
                    ToolTip = 'Specifies the number of CRM tasks that are assigned to you or to a group that you are a member of.';

                    trigger OnDrillDown()
                    var
                        UserSetup: Record "User Setup";
                        TaskList: Page "Task List";
                    begin
                        UserSetup.Get(UserId);
                        Rec.SetRange("Salesperson Code", UserSetup."Salespers./Purch. Code");
                        TaskList.SetTableView(Rec);
                        TaskList.RunModal();

                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        UserTaskManagement: Codeunit "User Task Management";
        ToDoTaskManagement: Codeunit toDoMgmt;
}

page 50111 "Where-Used Prod Lines"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DataCaptionFields = "Production BOM No.";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SaveValues = true;
    SourceTable = "Production BOM Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Production BOM No.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of production BOM line.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the production BOM line.';
                }
                field("Calculation Formula"; Rec."Calculation Formula")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how to calculate the Quantity field.';
                    Visible = false;
                }
                field(Length; Rec.Length)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the length of one item unit when measured in the specified unit of measure.';
                    Visible = false;
                }
                field(Width; Rec.Width)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the width of one item unit when measured in the specified unit of measure.';
                    Visible = false;
                }
                field(Depth; Rec.Depth)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the depth of one item unit when measured in the specified unit of measure.';
                    Visible = false;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the weight of one item unit when measured in the specified unit of measure.';
                    Visible = false;
                }
                field("Quantity per"; Rec."Quantity per")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many units of the component are required to produce the parent item.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Scrap %"; Rec."Scrap %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the percentage of the item that you expect to be scrapped in the production process.';
                }
                field("Routing Link Code"; Rec."Routing Link Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the routing link code.';
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the position of the component on the bill of material.';
                    Visible = false;
                }
                field("Position 2"; Rec."Position 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies more exactly whether the component is to appear at a certain position in the BOM to represent a certain production process.';
                    Visible = false;
                }
                field("Position 3"; Rec."Position 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the third reference number for the component position on a bill of material, such as the alternate position number of a component on a print card.';
                    Visible = false;
                }
                field("Lead-Time Offset"; Rec."Lead-Time Offset")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of days required to produce this item.';
                    Visible = false;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date from which this production BOM is valid.';
                    Visible = false;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date from which this production BOM is no longer valid.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Component")
            {
                Caption = '&Component';
                Image = Components;
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    ToolTip = 'View or add comments for the record.';

                    trigger OnAction()
                    begin
                        ShowComment;
                    end;
                }
                action("Where-Used")
                {
                    ApplicationArea = All;
                    Caption = 'Where-Used';
                    Image = "Where-Used";
                    ToolTip = 'View a list of BOMs in which the item is used.';

                    trigger OnAction()
                    begin
                        ShowWhereUsed;
                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    var
        todoMgt: Codeunit toDoMgmt;
        prodBom: Record "Production BOM Header";
    begin
        prodBom.Reset;
        prodBom.SetRange("No.", Rec."Production BOM No.");
        if prodBom.FindFirst() then
            if not todoMgt.RemoveLineFromCertProdBom(Rec."Production BOM No.", Rec."Version Code", Rec."Line No.") then
                error('Something went wrong');
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := xRec.Type;
    end;

    local procedure ShowComment()
    var
        ProdOrderCompComment: Record "Production BOM Comment Line";
    begin
        ProdOrderCompComment.SetRange("Production BOM No.", Rec."Production BOM No.");
        ProdOrderCompComment.SetRange("BOM Line No.", Rec."Line No.");
        ProdOrderCompComment.SetRange("Version Code", Rec."Version Code");

        PAGE.Run(PAGE::"Prod. Order BOM Cmt. Sheet", ProdOrderCompComment);
    end;

    local procedure ShowWhereUsed()
    var
        Item: Record Item;
        ProdBomHeader: Record "Production BOM Header";
        ProdBOMWhereUsed: Page "Prod. BOM Where-Used";
    begin
        if Rec.Type = Rec.Type::" " then
            exit;

        case Rec.Type of
            Rec.Type::Item:
                begin
                    Item.Get(Rec."No.");
                    ProdBOMWhereUsed.SetItem(Item, WorkDate);
                end;
            Rec.Type::"Production BOM":
                begin
                    ProdBomHeader.Get(Rec."No.");
                    ProdBOMWhereUsed.SetProdBOM(ProdBomHeader, WorkDate);
                end;
        end;
        ProdBOMWhereUsed.RunModal();
        Clear(ProdBOMWhereUsed);
    end;

}

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

page 50113 "Prod. BOM Lines"
{
    Caption = 'Production BOM Lines';
    PageType = List;
    SourceTable = "Production BOM Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of production BOM line.';
                }
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the production BOM line.';
                }
                field("Calculation Formula"; Rec."Calculation Formula")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how to calculate the Quantity field.';
                    Visible = false;
                }
                field(Length; Rec.Length)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the length of one item unit when measured in the specified unit of measure.';
                    Visible = false;
                }
                field(Width; Rec.Width)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the width of one item unit when measured in the specified unit of measure.';
                    Visible = false;
                }
                field(Depth; Rec.Depth)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the depth of one item unit when measured in the specified unit of measure.';
                    Visible = false;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the weight of one item unit when measured in the specified unit of measure.';
                    Visible = false;
                }
                field("Quantity per"; Rec."Quantity per")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many units of the component are required to produce the parent item.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Scrap %"; Rec."Scrap %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the percentage of the item that you expect to be scrapped in the production process.';
                }
                field("Routing Link Code"; Rec."Routing Link Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the routing link code.';
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the position of the component on the bill of material.';
                    Visible = false;
                }
                field("Position 2"; Rec."Position 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies more exactly whether the component is to appear at a certain position in the BOM to represent a certain production process.';
                    Visible = false;
                }
                field("Position 3"; Rec."Position 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the third reference number for the component position on a bill of material, such as the alternate position number of a component on a print card.';
                    Visible = false;
                }
                field("Lead-Time Offset"; Rec."Lead-Time Offset")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of days required to produce this item.';
                    Visible = false;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date from which this production BOM is valid.';
                    Visible = false;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date from which this production BOM is no longer valid.';
                    Visible = false;
                }
            }
        }
    }
}

