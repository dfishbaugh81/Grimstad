pageextension 50109 ProdBOMExt extends "Production BOM"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = Manufacturing;
            }

        }

    }
}

pageextension 50110 RoutListView extends "Routing List"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = Manufacturing;
            }
        }
    }
}

pageextension 50111 RoutHeader extends Routing
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = Manufacturing;
            }
        }
    }
}

pageextension 50112 CustListView extends "Customer List"
{
    layout
    {
        addafter("Name 2")
        {
            field(City; Rec.City)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}

pageextension 50113 ExtTextFactbox extends "Item Card"
{
    layout
    {
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

pageextension 50114 ItemListExt extends "Item List"
{
    layout
    {
        addbefore(ItemAttributesFactBox)
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

pageextension 50115 BomLinesExt extends "Production BOM Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = Manufacturing;
            }
        }
    }
}

pageextension 50116 WhseWmsRoleCenterExt extends "Sales & Relationship Mgr. RC"
{
    layout
    {
        addafter(Control56)
        {
            part(CrmTaskActivities; "User CRM Tasks Activities")
            {
                ApplicationArea = Suite;
            }
        }
    }
}
