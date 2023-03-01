pageextension 50116 "WhseWmsRoleCenterExt" extends "Sales & Relationship Mgr. RC"
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

