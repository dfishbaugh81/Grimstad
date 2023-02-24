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

page 50114 "Prod. Order Lines"
{
    Caption = 'Production Order Lines';
    PageType = List;
    SourceTable = "Prod. Order Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                field(Status; Rec.Status)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Do not modify';
                    Editable = false;
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Production Order No.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the number of the item that is to be produced.';
                }
                field(ComponentCount; Rec.ComponentCount)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Count of the number of Components';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the date when the produced item must be available. The date is copied from the header of the production order.';
                }
                field("Planning Flexibility"; Rec."Planning Flexibility")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies whether the supply represented by this line is considered by the planning system when calculating action messages.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the value of the Description field on the item card. If you enter a variant code, the variant description is copied to this field instead.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies an additional description.';
                }
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the number of the production BOM that is the basis for creating the Prod. Order Component list for this line.';
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the number of the routing used as the basis for creating the production order routing for this line.';
                }
                field("Production BOM Version Code"; Rec."Production BOM Version Code")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the version code of the production BOM.';
                    Visible = false;
                }
                field("Routing Version Code"; Rec."Routing Version Code")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the version number of the routing.';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the location code, if the produced items should be stored in a specific location.';
                    Visible = false;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the bin that the produced item is posted to as output, and from where it can be taken to storage or cross-docked.';
                    Visible = false;
                }
                field("Starting Date-Time"; Rec."Starting Date-Time")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the starting date and the starting time, which are combined in a format called "starting date-time".';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Starting Time"; StartingTime)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Starting Time';
                    ToolTip = 'Specifies the entry''s starting time, which is retrieved from the production order routing.';

                    trigger OnValidate()
                    begin
                        Rec.Validate("Starting Time", StartingTime);
                        CurrPage.Update(true);
                    end;
                }
                field("Starting Date"; StartingDate)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Starting Date';
                    ToolTip = 'Specifies the entry''s starting date, which is retrieved from the production order routing.';

                    trigger OnValidate()
                    begin
                        Rec.Validate("Starting Date", StartingDate);
                        CurrPage.Update(true);
                    end;
                }
                field("Ending Date-Time"; Rec."Ending Date-Time")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the ending date and the ending time, which are combined in a format called "ending date-time".';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Ending Time"; EndingTime)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Ending Time';
                    ToolTip = 'Specifies the entry''s ending time, which is retrieved from the production order routing.';

                    trigger OnValidate()
                    begin
                        Rec.Validate("Ending Time", EndingTime);
                        CurrPage.Update(true);
                    end;
                }
                field("Ending Date"; EndingDate)
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Ending Date';
                    ToolTip = 'Specifies the entry''s ending date, which is retrieved from the production order routing.';

                    trigger OnValidate()
                    begin
                        Rec.Validate("Ending Date", EndingDate);
                        CurrPage.Update(true);
                    end;
                }
                field("Scrap %"; Rec."Scrap %")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the percentage of the item that you expect to be scrapped in the production process.';
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the quantity to be produced if you manually fill in this line.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    ApplicationArea = Reservation;
                    ToolTip = 'Specifies how many units of this item have been reserved.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the cost of one unit of the item or resource on the line.';
                }
                field("Cost Amount"; Rec."Cost Amount")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the total cost on the line by multiplying the unit cost by the quantity.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }

            }
        }
    }

    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        [InDataSet]
        DescriptionIndent: Integer;
        StartingTime: Time;
        EndingTime: Time;
        StartingDate: Date;
        EndingDate: Date;
        DateAndTimeFieldVisible: Boolean;

}

page 50115 "Warehouse Entries - Editable"
{
    Caption = 'Warehouse Entries';
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Warehouse Entry";
    Permissions = tabledata "Warehouse Entry" = RIMD;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry type, which can be Negative Adjmt., Positive Adjmt., or Movement.';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the journal batch, a personalized journal layout, that the entries were posted from.';
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number of the warehouse document line or warehouse journal line that was registered.';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the location to which the entry is linked.';
                    Visible = false;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the serial number.';
                    Visible = false;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the lot number assigned to the warehouse entry.';
                    Visible = true;
                }

                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expiration date of the serial number.';
                    Visible = false;
                }
                field("Zone Code"; Rec."Zone Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the zone to which the entry is linked.';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bin where the items are picked or put away.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the item in the entry.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the warehouse entry.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the variant of the item on the line.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of units of the item in the warehouse entry.';
                }
                field("Qty. (Base)"; Rec."Qty. (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity of the entry, in the base unit of measure.';
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of base units of measure that are in the unit of measure specified for the item on the line.';
                    Visible = false;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the table number that is the source of the entry line, for example, 39 for a purchase line, 37 for a sales line.';
                    Visible = false;
                }
                field("Source Subtype"; Rec."Source Subtype")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source subtype of the document to which the warehouse entry line relates.';
                    Visible = false;
                }
                field("Source Document"; Rec."Source Document")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of document that the line relates to.';
                }
                field("Source No."; Rec."Source No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the source document that the entry originates from.';
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number of the source document that the entry originates from.';
                }
                field("Source Subline No."; Rec."Source Subline No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source subline number of the document from which the entry originates.';
                    Visible = false;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series from which entry or record numbers are assigned to new entries or records.';
                    Visible = false;
                }
                field(Cubage; Rec.Cubage)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total cubage of the items on the warehouse entry line.';
                    Visible = false;
                }
                field(Weight; Rec.Weight)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the weight of one item unit when measured in the specified unit of measure.';
                    Visible = false;
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the journal template, the basis of the journal batch, that the entries were posted from.';
                    Visible = false;
                }
                field("Whse. Document Type"; Rec."Whse. Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the document from which this entry originated.';
                }
                field("Whse. Document No."; Rec."Whse. Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the warehouse document from which this entry originated.';
                }
                field("Registering Date"; Rec."Registering Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the entry was registered.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';
                    Visible = false;

                    trigger OnDrillDown()
                    var
                        UserMgt: Codeunit "User Management";
                    begin
                        UserMgt.DisplayUserInformation(Rec."User ID");
                    end;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin

        //SetPackageTrackingVisibility();
    end;

}
