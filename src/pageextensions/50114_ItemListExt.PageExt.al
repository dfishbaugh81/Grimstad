pageextension 50114 "ItemListExt" extends "Item List"
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

