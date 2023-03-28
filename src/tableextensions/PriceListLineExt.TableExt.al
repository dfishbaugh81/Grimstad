tableextension 50125 "PriceListLineExt" extends "Price List Line"
{
    fields
    {
        field(50101; AssignToName; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No."=field("Source No.")));
        }
    }
}
