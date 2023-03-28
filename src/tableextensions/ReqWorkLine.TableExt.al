tableextension 50117 "ReqWorkLine" extends "Requisition Line"
{
    fields
    {
        field(50100; "Vendor Name"; text[100])
        {
            Caption = 'Vendor Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No."=field("Vendor No.")));
        }
    }
}
