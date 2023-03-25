tableextension 50118 "ProdOrder" extends "Production Order"
{
    fields
    {
        field(50100; "Finished Quantity"; Decimal)
        {
            Caption = 'Finished Quantity';
            FieldClass = FlowField;
            CalcFormula = lookup("Prod. Order Line"."Finished Quantity" where("Prod. Order No." = field("No."), "Item No." = field("Source No.")));
        }

        field(50101; "Production BOM"; Code[20])
        {
            Caption = 'Production BOM';
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Production BOM No." where("No." = field("Source No.")));
        }
    }
}

