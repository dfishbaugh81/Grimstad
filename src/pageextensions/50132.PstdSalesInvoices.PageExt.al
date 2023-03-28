pageextension 50132 "PstdSalesInvoices" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Location Code")
        {
            field("Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies the Territory for the Customer.';
                Visible = true;
            }
        }
    }
}

