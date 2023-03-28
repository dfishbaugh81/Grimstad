pageextension 50138 "WhsePickExt" extends "Warehouse Pick"
{
    actions
    {
        addbefore("Autofill Qty. to Handle")
        {
            action("Split Pick")
            {
                ApplicationArea = All;
                Image = Splitlines;
                Visible = true;

                trigger OnAction()
                var
                    whseActHeader: Record "Warehouse Activity Header";
                    whseActHeaderLast: Record "Warehouse Activity Header";
                    whseActLine: Record "Warehouse Activity Line";
                    whseActToHeader: Record "Warehouse Activity Header";
                    whseActToLine: Record "Warehouse Activity Line";
                    nextActHeadNo: Code[20];
                    noOfSplitsToMake: Integer;
                    countOfSplits: Integer;
                    arrOfLineNos: List of[Integer];
                    currWhseLineNo: Integer;
                    currRecCounter: Integer;
                    totRecCount: Integer;
                    currWhseNo: Code[20];
                    currWhseType: Enum "Warehouse Activity Type";
                    checkActLine: Codeunit toDoMgmt;
                    dialWindow: Dialog;
                    Text000: Label 'Progress from #1##### to #2#####';
                    test: Page "Released Production Order";
                begin
                    clear(nextActHeadNo);
                    clear(noOfSplitsToMake);
                    clear(countOfSplits);
                    clear(arrOfLineNos);
                    whseActHeader.Get(Rec.Type, Rec."No.");
                    whseActLine.Reset;
                    whseActLine.SetRange("No.", Rec."No.");
                    totRecCount:=whseActLine.Count();
                    currRecCounter:=0;
                    dialWindow.Open(Text000, currRecCounter, totRecCount);
                    if whseActLine.FindFirst()then repeat currRecCounter:=currRecCounter + 1;
                            dialWindow.Update();
                            if not checkActLine.VerifySplit(whseActLine, currWhseLineNo, currWhseNo, currWhseType)then begin
                                noOfSplitsToMake:=noOfSplitsToMake + 1;
                                arrOfLineNos.Add(currWhseLineNo);
                            end;
                        until whseActLine.Next() = 0;
                    dialWindow.Close();
                    dialWindow.Open(Text000, countOfSplits, noOfSplitsToMake);
                    for countOfSplits:=1 to noOfSplitsToMake do begin
                        dialWindow.Update();
                        if nextActHeadNo = '' then begin
                            whseActHeaderLast.Reset;
                            whseActHeaderLast.SetRange(Type, whseActHeaderLast.Type::Pick);
                            whseActHeaderLast.SetRange("No. Series", 'WHPICK');
                            whseActHeaderLast.FindLast();
                            nextActHeadNo:=whseActHeaderLast."No.";
                        end;
                        nextActHeadNo:=IncStr(nextActHeadNo);
                        whseActToHeader.Init();
                        whseActToHeader.TransferFields(whseActHeader);
                        whseActToHeader."No.":=nextActHeadNo;
                        whseActToHeader.Insert(true);
                        whseActLine.Reset;
                        whseActLine.SetRange("Activity Type", Rec.Type);
                        whseActLine.SetRange("No.", Rec."No.");
                        whseActLine.SetRange("Whse. Document Line No.", arrOfLineNos.Get(countOfSplits));
                        if whseActLine.findfirst()then repeat whseActToLine.Init;
                                whseActToLine.TransferFields(whseActLine);
                                whseActToLine."No.":=nextActHeadNo;
                                whseActToLine.Insert(true);
                            until whseActLine.Next() = 0;
                    end;
                    dialWindow.Close();
                    whseActHeader.Delete(true);
                end;
            }
        }
    }
}
