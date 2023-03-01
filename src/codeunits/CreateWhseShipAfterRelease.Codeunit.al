// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!


codeunit 50101 "CreateWhseShipAfterRelease"
{
    /*CUSTOMER REQUESTED THIS FEATURE BE TURNED OFF 
    
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure OnAfterReleaseSalesDoc(SalesHeader: Record "Sales Header")
    var
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
        WhseRelDoc: Codeunit "Whse.-Shipment Release";
        WhseShipLine: Record "Warehouse Shipment Line";
        WhseShipHeader: Record "Warehouse Shipment Header";
        WhseShipLine2: Record "Warehouse Shipment Line";
    begin
        if SalesHeader.Status = SalesHeader.Status::Released then begin
            WhseShipLine2.Reset;
            WhseShipLine2.SetRange("Source No.", SalesHeader."No.");
            if not WhseShipLine2.FindFirst() then begin
                GetSourceDocOutbound.CreateFromSalesOrder(SalesHeader);
                Commit;
                WhseShipLine.Reset;
                WhseShipLine.SetRange("Source No.", SalesHeader."No.");
                if WhseShipLine.FindFirst() then
                    repeat
                        if WhseShipHeader.Get(WhseShipLine."No.") then begin
                            if WhseShipHeader.Status <> WhseShipHeader.Status::Released then
                                WhseRelDoc.Release(WhseShipHeader);
                        end;
                    until WhseShipLine.Next() = 0;
                Commit;
            end;
        end;
    end; */

}





