query 50100 "Run Time By Work Center"
{
    Caption = 'Run Time By Work Center';
    QueryType = Normal;

    elements
    {
        dataitem(ProdOrderRoutingLine; "Prod. Order Routing Line")
        {
            column(RoutingNo; "Routing No.")
            {
            }
            column(RoutingReferenceNo; "Routing Reference No.")
            {
            }
            column("Type"; "Type")
            {
            }
            column(No; "No.")
            {
            }

            column(Status; Status)
            {
            }
            column(ProdOrderNo; "Prod. Order No.")
            {
            }
            column(Sum_Run_Time; "Run Time")
            {
                ColumnFilter = Sum_Run_Time = filter(<>0);
                Method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
