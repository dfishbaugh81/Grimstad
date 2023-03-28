tableextension 50105 "ProdOrderRoutingLine" extends "Prod. Order Routing Line"
{
    fields
    {
    }
    keys
    {
        key(GRMKey1; "Routing No.", "Routing Reference No.", Status, "Prod. Order No.")
        {
            SumIndexFields = "Run Time";
        }
    }
}
