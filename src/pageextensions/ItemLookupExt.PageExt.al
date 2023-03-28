pageextension 50122 "ItemLookupExt" extends "Item Lookup"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies information in addition to the description.';
                Visible = true;
            }
            field(Manufacturer; Rec.Manufacturer)
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies Manufacturer code.';
                Visible = true;
            }
        }
    }
}
