tableextension 50110 "ItemExt" extends Item
{
    fields
    {

        modify("Description 2")
        {
            Caption = 'Description 2';

        }

        field(50101; "Manufacturer"; code[20])
        {
            Caption = 'Manufacturer';
        }

        field(50102; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
        }

    }
}

