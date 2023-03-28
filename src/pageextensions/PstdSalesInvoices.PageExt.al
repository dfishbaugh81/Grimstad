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
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Payment Method Code';
            }
        }
    }
}

