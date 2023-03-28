page 50101 "Run Time by Work Center"
{
    Caption = 'Run Time by Work Center';
    PageType = ListPart;
    SourceTable = "Run Time Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                ShowCaption = false;

                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Routing No. field.';
                }
                field("Routing Reference No."; Rec."Routing Reference No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Routing Reference No. field.';
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Prod. Order No. field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Run Time"; Rec."Run Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Run Time field.';
                }
            }
        }
    }
    trigger OnFindRecord(Which: Text): Boolean begin
        FillTempTable();
        exit(Find(Which));
    end;
    local procedure FillTempTable()
    var
        RunTimeByWorkCenter: Query "Run Time By Work Center";
    begin
        RunTimeByWorkCenter.SetRange(RoutingNo, Rec.GetRangeMin("Routing No."));
        RunTimeByWorkCenter.SetRange(RoutingReferenceNo, Rec.GetRangeMin("Routing Reference No."));
        RunTimeByWorkCenter.SetRange(Status, Rec.GetRangeMin(Status));
        RunTimeByWorkCenter.SetRange(ProdOrderNo, Rec.GetRangeMin("Prod. Order No."));
        RunTimeByWorkCenter.SetFilter(No, '<>%1', '');
        RunTimeByWorkCenter.Open();
        Rec.DeleteAll();
        while(RunTimeByWorkCenter.Read())do begin
            Rec.Init();
            Rec."Routing No.":=RunTimeByWorkCenter.RoutingNo;
            Rec."Routing Reference No.":=RunTimeByWorkCenter.RoutingReferenceNo;
            Rec."Prod. Order No.":=RunTimeByWorkCenter.ProdOrderNo;
            Rec.Status:=RunTimeByWorkCenter.Status;
            Rec.Type:=RunTimeByWorkCenter.Type;
            Rec."No.":=RunTimeByWorkCenter.No;
            if Rec.Find()then begin
                Rec."Run Time"+=RunTimeByWorkCenter.Sum_Run_Time;
                Rec.Modify();
            end
            else
            begin
                Rec."Run Time":=RunTimeByWorkCenter.Sum_Run_Time;
                Rec.Insert();
            end;
        end;
    end;
}
