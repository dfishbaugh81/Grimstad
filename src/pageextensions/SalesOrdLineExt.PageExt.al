pageextension 50117 "SalesOrdLineExt" extends "Sales Order Subform"
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
                    CurrLineNo:=Rec."Line No.";
                    if Rec.Type = Rec.Type::Item then Rec.Validate("Drop Shipment", Rec.dropship);
                    if Rec.dropship then begin
                        if Rec.Type = Rec.Type::" " then begin
                            SalesLine.Reset;
                            SalesLine.SetRange("Document Type", Rec."Document Type");
                            SalesLine.SetRange("Document No.", Rec."Document No.");
                            SalesLine.SetRange("Drop Shipment", true);
                            if SalesLine.FindFirst()then repeat if CurrLineNo > SalesLine."Line No." then begin
                                        DropShipItemNo:=SalesLine."No.";
                                        DropShipLineNo:=SalesLine."Line No.";
                                        DropShipPoNo:=SalesLine."Purchase Order No.";
                                        DropShipPoLineNo:=SalesLine."Purch. Order Line No.";
                                    end;
                                until((SalesLine.Next() = 0) or (CurrLineNo < SalesLine."Line No."));
                            ToDoMgmt.AddItemTextToSalesCommentLine(Rec."Document Type", Rec."Document No.", DropShipLineNo, Rec.GetDate(), Rec."Description");
                            if((DropShipPONo <> '') and (DropShipPoLineNo <> 0))then begin
                                ToDoMgmt.AddItemTextToPurchCommentLine(purchHeader."Document Type"::Order, DropShipPoNo, DropShipPOLineNo, Rec.GetDate(), Rec."Description");
                                Message('The Comment: %1 has been copied to Drop Ship Item No.: %2 on Purchase Order No.: %3 and Purchase Line No.: %4', Rec.Description, DropshipItemNo, DropShipPoNo, DropShipPoLineNo);
                            end;
                            if Confirm('The Comment: %1 has been copied to Drop Ship Item No.: %2. \\ Do you want to delete the comment here?', true, Rec.Description, DropShipItemNo)then Rec.Delete;
                        end;
                    end;
                end;
            }
        }
    }
}
