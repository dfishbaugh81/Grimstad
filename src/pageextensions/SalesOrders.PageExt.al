pageextension 50131 "SalesOrders" extends "Sales Order List"
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

