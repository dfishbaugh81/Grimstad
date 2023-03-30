tableextension 50106 "Psted Whse Rcpt. Header Ext." extends "Posted Whse. Receipt Header"
{
    procedure PrintItemLabels()
    var
        PostedWhseReceiptLine: Record "Posted Whse. Receipt Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        WarehouseSetup: Record "Warehouse Setup";
        WHIItemBarcodeLabel: Report "WHI Item Barcode Label";
    begin
        WarehouseSetup.Get();
        if not WarehouseSetup."Print Item Label on Receipt" then exit;

        PostedWhseReceiptLine.SetRange("No.", Rec."No.");
        if PostedWhseReceiptLine.FindSet() then
            repeat
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
                ItemLedgerEntry.SetRange("Document No.", PostedWhseReceiptLine."Posted Source No.");
                ItemLedgerEntry.SetRange("Item No.", PostedWhseReceiptLine."Item No.");

                clear(WHIItemBarcodeLabel);
                WHIItemBarcodeLabel.SetTableView(ItemLedgerEntry);
                WHIItemBarcodeLabel.UseRequestPage(false);
                WHIItemBarcodeLabel.RunModal();
            until PostedWhseReceiptLine.Next() = 0;
    end;
}
