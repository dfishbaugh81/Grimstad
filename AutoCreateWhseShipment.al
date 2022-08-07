// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!


codeunit 50101 CreateWhseShipAfterRelease
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure OnAfterReleaseSalesDoc(SalesHeader: Record "Sales Header")
    var
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
        WhseRelDoc: Codeunit "Whse.-Shipment Release";
        WhseShipLine: Record "Warehouse Shipment Line";
        WhseShipHeader: Record "Warehouse Shipment Header";
    begin
        if SalesHeader.Status = SalesHeader.Status::Released then begin
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

}

reportextension 50102 ProdOrdRepExt extends "Prod. Order - Job Card"
{

}

codeunit 50102 toDoMgmt
{
    procedure GetTotalRecCount(var ToDo: Record "To-Do"; userCode: code[20]): Integer
    var
        userSetup: Record "User Setup";
    begin
        userSetup.Get(userCode);
        ToDo.SetRange("Salesperson Code", userSetup."Salespers./Purch. Code");
        exit(ToDo.Count());
    end;
}

tableextension 50110 ItemExt extends Item
{
    fields
    {
        modify("Common Item No.")
        {
            Caption = 'Mfr/Vnd';
        }
    }
}

tableextension 50111 BomLines extends "Production BOM Line"
{
    fields
    {
        field(50100; "Description 2"; Text[258])
        {

        }
    }
}

reportextension 50111 mytest extends "Standard Sales - Order Conf."
{

}