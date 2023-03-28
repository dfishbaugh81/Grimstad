pageextension 50109 "ProdBOMExt" extends "Production BOM"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = Manufacturing;
                Importance = Additional;
                ToolTip = 'Specifies information in addition to the description.';
                Visible = true;
            }
        }
    }
}
