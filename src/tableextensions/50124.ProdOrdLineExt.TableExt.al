tableextension 50124 "ProdOrdLineExt" extends "Prod. Order Line"
{
    fields
    {
        field(50101; ComponentCount; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Prod. Order Component" where("Prod. Order No." = field("Prod. Order No."), "Prod. Order Line No." = field("Line No.")));
        }
    }
}

