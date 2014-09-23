unit WinCheckLst;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms,
  Messages, ExtCtrls, StdCtrls, Buttons, CommCtrl,
  CheckLst,
  winskindata,TypInfo,WinSubClass;

type
  TAcControl = class(TControl);
  TAcWinControl = class(TWinControl);

  TSkinCheckList = class(TSkinScrollBar)
  protected
     hHwnd: THandle;
//     procedure SetHeaderOwnerDraw;
//     procedure DrawHeaderItem(DrawItemStruct: TDrawItemStruct);
//     procedure Drawheader;
//     procedure drawitem(dc:HDC; rc:TRect;acolumn:TListColumn);
//     procedure WMNotify(var Message:TWMNotify);
    procedure DrawItem(dc:HDC;Index: Integer; Rc: TRect;
          State: TOwnerDrawState);
    procedure CNDrawItem(var Message: TWMDrawItem);
  public
//     Procedure InitScrollbar(acontrol:Twincontrol;sd:TSkinData;acanvas:TCanvas;sf:Tcomponent);override;
     function BeforeProc(var Message: TMessage):boolean;override;
//     procedure HeaderProc(var Message: TMessage);
  end;


implementation

function TSkinCheckList.BeforeProc(var Message: TMessage):boolean;
var
  DC: HDC;
begin
  case message.msg of
    CN_DRAWITEM:
    begin
        CNDrawItem(TWMDrawItem(message));
//      if border then begin
//        default(message);
//        DC := GetWindowDC(Control.Handle);
//        BENCPaint(DC);
//        ReleaseDC(Control.Handle, DC);
//        Result := False;
//      end else
      result:= false;//true;
    end
    else result:=inherited beforeProc(message);
  end;
end;

procedure TSkinCheckList.DrawItem(dc:HDC;Index: Integer; Rc: TRect;
  State: TOwnerDrawState);
var
  r,r1,r2:Trect;
  Enable: Boolean;
  list:TCheckListBox;
  cs,n,i,w,bs,w1,j,h:integer;
  aState: TCheckBoxState ;
  ws:widestring;
  dw:Dword;
begin

   if (fsd.Button=nil) or (fsd.button.checkmap.empty) then begin
      kind:=0;
//      if control<>nil then control.Invalidate;
      exit;
   end;

  list:=TChecklistbox(control);
  if Index >= list.Items.Count then exit;

   n:= fsd.button.checkframe;
   w:= fsd.button.checkmap.width div n;
   cs:= fsd.button.checkmap.height;
   //w1:=GetSystemMetrics(SM_CXMENUCHECK);
   if w<15 then w1:=w
   else w1 := w;


   r.top := rc.top + ( rc.bottom-rc.top- cs ) div 2;
   r.bottom := r.top+cs;
   r1:=rc;
   r2:=rc;

//  ACheckWidth := w1;//GetCheckWidth;
    Enable := list.Enabled and list.ItemEnabled[Index];
    if not list.Header[Index] then begin   //checkbox
      if not list.UseRightToLeftAlignment then begin
       r.left:=rc.left+2;
       r.right:=r.left+w1;
       r2.Left := r.Right+2;
       dw := DT_Left;
       if (control<>nil) and (control.BiDiMode = bdRighttoLeft) then
          dw := dw or dt_RtlReading;
      end else begin
       r.right:=rc.right   ;
       r.left:=r.right-w1;
       r2.Right:=r.Left-2;
       if (control<>nil) and (control.BiDiMode=bdRightToLeft) then
         dw := DT_Right or dt_RtlReading
       else dw := DT_Left;
     end;
     dw := dw or DT_EXPANDTABS or dt_WordBreak;
     astate:=list.State[index];

     case aState of
       cbChecked: i:=2;
       cbUnchecked: i:=1;
       else // cbGrayed
         i:=4
     end;
     if n=12 then begin
        j:=i;
        case j of
            2: i:=5;
            3: i:=4;
            4: i:=8;
        end;
     end;
     DrawSkinMap2(FCanvas.Handle ,r,fsd.button.checkmap,i,N);
     FCanvas.FillRect(r2);
     ws:=list.Items[index];

     r:=r2;
     r1:=r2;
     Tnt_DrawTextW(dc, ws,r1,dw or DT_CALCRECT or DT_NOCLIP);
     offsetrect(r2,0, (r2.Bottom-r2.Top-r1.bottom+r1.Top) div 2);
     Tnt_DrawTextW(dc,ws,r2,dw );

    end  else  begin //header
      fCanvas.Font.Color := list.HeaderColor;
      fCanvas.Brush.Color := list.HeaderBackgroundColor;
    end;
    if not Enable then
      fCanvas.Font.Color := clGrayText;


    if odFocused in State then DrawFocusRect(dc, r);

end;

procedure TSkinCheckList.CNDrawItem(var Message: TWMDrawItem);
var
  State: TOwnerDrawState;
begin
  with Message.DrawItemStruct^ do
  begin
    State := TOwnerDrawState(LoWord(itemState));
    FCanvas.Handle := hDC;
    FCanvas.Font := TAcWinControl(control).font;
    FCanvas.Brush := TAcWinControl(control).Brush;
    if (Integer(itemID) >= 0) and (odSelected in State) then
    begin
      FCanvas.Brush.Color := clHighlight;
      FCanvas.Font.Color := clHighlightText
    end;
    if Integer(itemID) >= 0 then begin
//      FCanvas.FillRect(rcItem);
      DrawItem(hdc,itemID, rcItem, State);
    end else FCanvas.FillRect(rcItem);
//    if odFocused in State then DrawFocusRect(hDC, rcItem);
    FCanvas.Handle := 0;
  end;
end;



end.
