pageextension 50113 "ExtTextFactbox" extends "Item Card"
{
    layout
    {
        addafter("Description")
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Specifies information in addition to the description.';
                Visible = true;
            }

            field(Manufacturer; Rec.Manufacturer)
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Specifies Manufacturer code.';
                Visible = true;
            }

            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = 'Identifies Vendor Name.';
                Visible = true;
            }
        }
        addbefore(ItemAttributesFactbox)
        {

            part("Extended Text"; "Extended Text Lines")
            {
                ApplicationArea = All;
                Caption = 'Ext. Text';
                SubPageLink = "Table Name" = CONST(Item),
                                "No." = field("No.");
                Visible = ExtTextLnCnt > 0;
            }

        }

    }
    trigger OnAfterGetCurrRecord()
    begin
        ExtTextLine.Reset;
        ExtTextLine.Setrange("Table Name", ExtTextLine."Table Name"::Item);
        ExtTextLine.Setrange("No.", Rec."No.");
        ExtTextLnCnt := ExtTextLine.Count;
    end;

    var
        ExtTextLine: Record "Extended Text Line";
        ExtTextLnCnt: Integer;

}

