table 50101 "Run Time Buffer"
{
    Caption = 'Run Time Buffer';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            DataClassification = ToBeClassified;
            TableRelation = "Routing Header"."No.";
        }
        field(2; "Routing Reference No."; Integer)
        {
            Caption = 'Routing Reference No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            DataClassification = ToBeClassified;
        }
        field(4; Status; Enum "Production Order Status")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
        }
        field(5; Type; Enum "Capacity Type")
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
        }

        field(8; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST("Work Center")) "Work Center"
            ELSE
            IF (Type = CONST("Machine Center")) "Machine Center";
            DataClassification = ToBeClassified;
        }
        field(9; "Run Time"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Run Time';
            DecimalPlaces = 0 : 5;
        }
    }
    keys
    {
        key(PK; "Routing No.", "Routing Reference No.", Status, "Prod. Order No.", Type, "No.")
        {
            Clustered = true;
        }
    }
}
