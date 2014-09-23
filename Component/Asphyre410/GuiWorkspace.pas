unit GuiWorkspace;
//---------------------------------------------------------------------------
// GuiWorkspace.pas                                     Modified: 04-Feb-2007
// The workspace for Asphyre GUI foundation                       Version 1.1
//---------------------------------------------------------------------------
// Important Notice:
//
// If you modify/use this code or one of its parts either in original or
// modified form, you must comply with Mozilla Public License v1.1,
// specifically section 3, "Distribution Obligations". Failure to do so will
// result in the license breach, which will be resolved in the court.
// Remember that violating author's rights is considered a serious crime in
// many countries. Thank you!
//
// !! Please *read* Mozilla Public License 1.1 document located at:
//  http://www.mozilla.org/MPL/
//
// If you require any clarifications about the license, feel free to contact
// us or post your question on our forums at: http://www.afterwarp.net
//---------------------------------------------------------------------------
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS"
// basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
// License for the specific language governing rights and limitations
// under the License.
//
// The Original Code is GuiWorkspace.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Classes, Controls, Vectors2px, GuiTypes, GuiObjects, GuiControls;

//---------------------------------------------------------------------------
type
 TGuiWorkspace = class(TGuiControl)
 private
  FMousePos : TPoint2px;
  LastButton: TMouseButtonType;
  LastShift : TShiftState;
  LastOver  : TGuiControl;
  LastClick : TGuiControl;
  ClickLevel: Integer;
 protected
  procedure DoMouseEvent(const Pos: TPoint2px; Event: TMouseEventType;
   Button: TMouseButtonType; SpecialKeys: TSpecialKeyState); override;
  procedure DoKeyEvent(Key: Integer; Event: TKeyEventType;
   SpecialKeys: TSpecialKeyState); override;
 public
  property MousePos: TPoint2px read FMousePos;

  procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  procedure MouseMove(Shift: TShiftState; X, Y: Integer);
  procedure KeyDown(Key: Word; Shift: TShiftState);
  procedure KeyUp(Key: Word; Shift: TShiftState);
  procedure KeyPress(Key: Char);
  procedure Click();
  procedure DblClick();

  function FindCtrlAt(const Point: TPoint2px): TGuiControl; override;

  // Clears LastOver and LastClick references since the control is
  // being deleted.
  procedure RemoveRef();

  procedure Draw();

  constructor Create(AOwner: TGuiObject); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 GuiUtils, GuiForms;

//---------------------------------------------------------------------------
constructor TGuiWorkspace.Create(AOwner: TGuiObject);
begin
 inherited;

 FMousePos := Point(0, 0);
 LastOver  := nil;
 ClickLevel:= 0;
end;

//---------------------------------------------------------------------------
procedure TGuiWorkspace.MouseDown(Button: TMouseButton; Shift: TShiftState;
 X, Y: Integer);
begin
 FMousePos := Point(X, Y);
 LastButton:= Button2Gui(Button);
 LastShift := Shift;
 AcceptMouse(FMousePos, metDown, LastButton, ShiftState2Special(LastShift));
end;

//---------------------------------------------------------------------------
procedure TGuiWorkspace.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
 FMousePos := Point(X, Y);
 LastButton:= mbtUnknown;
 LastShift := Shift;
 AcceptMouse(FMousePos, metMove, LastButton, ShiftState2Special(LastShift));
end;

//---------------------------------------------------------------------------
procedure TGuiWorkspace.MouseUp(Button: TMouseButton; Shift: TShiftState;
 X, Y: Integer);
begin
 FMousePos := Point(X, Y);
 LastButton:= Button2Gui(Button);
 LastShift := Shift;
 AcceptMouse(FMousePos, metUp, LastButton, ShiftState2Special(LastShift));
end;

//---------------------------------------------------------------------------
procedure TGuiWorkspace.Click();
begin
 AcceptMouse(FMousePos, metClick, LastButton, ShiftState2Special(LastShift));
end;

//---------------------------------------------------------------------------
procedure TGuiWorkspace.DblClick();
begin
 AcceptMouse(FMousePos, metDblClick, LastButton, ShiftState2Special(LastShift));
end;

//---------------------------------------------------------------------------
procedure TGuiWorkspace.KeyPress(Key: Char);
begin
 AcceptKey(Byte(Key), ketPress, []);
end;

//---------------------------------------------------------------------------
procedure TGuiWorkspace.KeyDown(Key: Word; Shift: TShiftState);
begin
 AcceptKey(Byte(Key), ketDown, ShiftState2Special(Shift));
end;

//---------------------------------------------------------------------------
procedure TGuiWorkspace.KeyUp(Key: Word; Shift: TShiftState);
begin
 AcceptKey(Byte(Key), ketUp, ShiftState2Special(Shift));
end;

//---------------------------------------------------------------------------
procedure TGuiWorkspace.DoMouseEvent(const Pos: TPoint2px; Event: TMouseEventType;
 Button: TMouseButtonType; SpecialKeys: TSpecialKeyState);
var
 CtrlOver : TGuiControl;
 EventCtrl: TGuiControl;
begin
 // (1) Find the control pointed by the mouse.
 CtrlOver:= FindCtrlAt(MousePos);

 // (2) Whom to send mouse event?
 EventCtrl:= CtrlOver;
 if (LastClick <> nil) then EventCtrl:= LastClick;

 // (3) Check whether a user pressed mouse button.
 if (Event = metDown)and(CtrlOver <> nil) then
  begin
   if (ClickLevel <= 0) then
    begin
     CtrlOver.SetFocus();
     LastClick:= CtrlOver;
    end;

   if (LastClick is TGuiForm) then LastClick.SetFocus();
   Inc(ClickLevel);
  end;

 // (4) Verify if the user released mouse button.
 if (Event = metUp) then
  begin
   Dec(ClickLevel);
   if (ClickLevel <= 0) then LastClick:= nil;
  end;

 // (5) Notify control pointed by the mouse that it is being ENTERED
 if (ClickLevel <= 0)and(LastOver <> CtrlOver) then
  begin
   if (CtrlOver <> nil) then
    begin
     CtrlOver.AcceptMouse(MousePos, metEnter, Button, SpecialKeys);
//     CtrlOver.SkinAlpha:= 128;
    end;
  end;

 // (6) Send the mouse event
 if (EventCtrl <> nil)and(EventCtrl.Enabled) then
  EventCtrl.AcceptMouse(MousePos, Event, Button, SpecialKeys);

 // (7) Notify control no longer pointed by the mouse, that it is LEFT
 if (ClickLevel <= 0)and(LastOver <> CtrlOver) then
  begin
   if (LastOver <> nil) then
    begin
     LastOver.AcceptMouse(MousePos, metLeave, Button, SpecialKeys);
//     LastOver.SkinAlpha:= 255;
    end;
    
   LastOver:= CtrlOver;
  end;
end;

//---------------------------------------------------------------------------
function TGuiWorkspace.FindCtrlAt(const Point: TPoint2px): TGuiControl;
var
 Index: Integer;
begin
 Result:= nil;

 for Index:= 0 to ChildCount - 1 do
  if (Child[Index] is TGuiControl) then
   begin
    Result:= TGuiControl(Child[Index]).FindCtrlAt(Point);
    if (Result <> nil) then Break;
   end;
end;

//---------------------------------------------------------------------------
procedure TGuiWorkspace.DoKeyEvent(Key: Integer; Event: TKeyEventType;
 SpecialKeys: TSpecialKeyState);
var
 FocusChild: TGuiObject;
begin
 FocusChild:= Child[FocusIndex];
 if (FocusChild <> nil)and(FocusChild is TGuiControl) then
  TGuiControl(FocusChild).AcceptKey(Key, Event, SpecialKeys);
end;

//---------------------------------------------------------------------------
procedure TGuiWorkspace.RemoveRef();
begin
 LastOver:= nil;
 LastClick:= nil;
end;

//---------------------------------------------------------------------------
procedure TGuiWorkspace.Draw();
begin
 DrawAt(ZeroPoint2px);
end;

//---------------------------------------------------------------------------
end.
