tableextension 50116 "SalesLine" extends "Sales Line"
{
    fields
    {
        modify("Drop Shipment")
        {
        trigger OnAfterValidate()
        begin
            dropship:=Rec."Drop Shipment";
        end;
        }
        modify("Requested Delivery Date")
        {
        trigger OnAfterValidate()
        begin
        end;
        }
        field(50100; dropship; Boolean)
        {
            trigger OnValidate()
            begin
            end;
        }
    }
}
