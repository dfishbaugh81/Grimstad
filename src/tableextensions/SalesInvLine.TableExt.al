tableextension 50123 "SalesInvLine" extends "Sales Invoice Line"
{
    fields
    {
        field(50105; InvoiceDate; Date)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Header"."Posting Date" where("No."=field("Document No.")));
        }
    }
}
