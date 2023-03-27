pageextension 50147 "PurchPriceListLineExt" extends "Purchase Price List Lines"
{
    layout
    {
        addafter(AssignToNo)
        {
            field(AssignToName; Rec.AssignToName)
            {
                Caption = 'Vendor Name';
                ToolTip = 'Vendor Name';
                ApplicationArea = All;
                Visible = true;
            }
        }

    }
}

