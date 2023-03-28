tableextension 50124 "ProdOrdLineExt" extends "Prod. Order Line"
{
    fields
    {
        field(50101; ComponentCount; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Prod. Order Component" where("Prod. Order No."=field("Prod. Order No."), "Prod. Order Line No."=field("Line No.")));
            Editable = false;
        }
        field(50102; "Total Run Time"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Prod. Order Routing Line"."Run Time" where("Routing No."=field("Routing No."), "Routing Reference No."=field("Routing Reference No."), Status=field(Status), "Prod. Order No."=field("Prod. Order No.")));
            DecimalPlaces = 0: 5;
            Editable = false;
        }
    }
}
