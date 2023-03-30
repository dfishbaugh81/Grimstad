codeunit 50103 "Grimstad Events Subscriber"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnCodeOnAfterPostSourceDocuments', '', false, false)]
    local procedure OnCodeOnAfterPostSourceDocuments(var WarehouseReceiptHeader: Record "Warehouse Receipt Header"; WarehouseReceiptLine: Record "Warehouse Receipt Line");
    var
        PostedWhseReceiptHeader: Record "Posted Whse. Receipt Header";
    begin
        PostedWhseReceiptHeader.SetRange("Whse. Receipt No.", WarehouseReceiptHeader."No.");
        if PostedWhseReceiptHeader.FindFirst() then
            PostedWhseReceiptHeader.PrintItemLabels();
    end;

}
