tableextension 50115 "PurchHead" extends "Purchase Header"
{
    fields
    {
        modify("Buy-from Vendor No.")
        {
        trigger OnAfterValidate()
        var
            orderAddress: Record "Order Address";
            DataExch: Record "Data Exch. Field Mapping";
        begin
            orderAddress.Reset;
            orderAddress.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
            if orderAddress.FindFirst()then begin
                Rec.Validate("Order Address Code", orderAddress.Code);
            end;
        end;
        }
    }
}
