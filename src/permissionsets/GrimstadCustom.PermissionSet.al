permissionset 50100 "Grimstad Custom"
{
    Assignable = true;
    Caption = 'Grimstad Custom', MaxLength = 30;
    Permissions =
        table "Run Time Buffer" = X,
        tabledata "Run Time Buffer" = RMID,
        codeunit toDoMgmt = X,
        codeunit CreateWhseShipAfterRelease = X,
        page "Where-Used Prod Lines" = X,
        page "Warehouse Entries - Editable" = X,
        page "User CRM Tasks Activities" = X,
        page "Sales Item History FactBox" = X,
        page "Prod. Order Lines" = X,
        page "Prod. BOM Lines" = X,
        query "Run Time By Work Center" = X,
        report "Std. Purchase Order" = X,
        report "Standard Sales Quote" = X,
        report "Sales Return Auth." = X,
        report "Sales Order Acknowledgement" = X,
        report SalesCreditMemo = X,
        report "Purch. Return Order" = X,
        report "Purchase Quote" = X,
        report "Production Order Routing" = X,
        report "Posted Sales Order Invoice" = X,
        report "Picking List - Barcoded" = X,
        report "Pick - Barcoded (Sales)" = X,
        report "New Get Sales Orders" = X,
        report "Grimstad Stub/Check/Stub" = X,
        report GrimstadCustomerStatement = X,
        report GrimCustStatements = X,
        report "Dyn Packing List" = X;
}
