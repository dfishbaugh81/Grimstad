pageextension 50127 "SalesOrder" extends "Sales Order"
{
    layout
    {

        addafter("Work Description")
        {
            field("Created By"; Rec.GetUserNameFromSecurityId(Rec.SystemCreatedBy))
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Created By Record.';
                Visible = true;
            }
            field("Territory Code"; Rec."Territory Code")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies the Territory for the Customer.';
                Visible = true;
            }
        }

        addafter("Requested Delivery Date")
        {
            field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
            {
                ApplicationArea = All;
                Importance = Standard;
                ToolTip = 'Applies-to Type';
                Visible = false;
            }

            field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = All;
                Importance = Standard;
                ToolTip = 'Applies-to Doc No.';
                Visible = false;
            }

            field(ASN; Rec.ASN)
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'ASN trigger.';
                Visible = true;
            }
        }

        addbefore(ApprovalFactBox)
        {
            part(SalesInvLines; "Sales Item History FactBox")
            {
                ApplicationArea = Basic, Suite;
                Provider = SalesLines;
                SubPageLink = "Sell-to Customer No." = FIELD("Sell-to Customer No."),
                                "No." = field("No.");
                Visible = true;


            }

        }
    }
}

