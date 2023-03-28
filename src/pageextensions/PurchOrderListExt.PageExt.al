pageextension 50142 "PurchOrderListExt" extends "Purchase Order List"
{
    actions
    {
        addbefore("Send IC Purchase Order")
        {
            action("Delete Purchase Orders")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Visible = true;

                trigger OnAction()
                var
                    purchLine: Record "Purchase Line";
                    purchHeader: Record "Purchase Header";
                begin
                    CurrPage.SetSelectionFilter(purchHeader);
                    if purchHeader.findfirst()then repeat purchLine.Reset;
                            purchLine.SetRange("Document Type", purchHeader."Document Type");
                            purchLine.SetRange("Document No.", purchHeader."No.");
                            if purchLine.FindFirst()then repeat purchLine.Delete(true);
                                until purchLine.Next() = 0;
                            purchHeader.Delete(true);
                        until purchHeader.Next() = 0 end;
            }
        }
    }
}
