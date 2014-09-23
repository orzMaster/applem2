unit GuiHelpers;
//---------------------------------------------------------------------------
// GuiHelpers.pas                                       Modified: 04-Feb-2007
// Helper object for acquiring input events for Asphyre GUI       Version 1.1
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
// The Original Code is GuiHelpers.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Types, Classes, Controls, Forms, ExtCtrls, GuiTypes, GuiObjects,
 GuiControls, GuiWorkspace;

//---------------------------------------------------------------------------
type
 TGuiHelper = class
 private
  PrevMouseDown: TMouseEvent;
  PrevMouseUp  : TMouseEvent;
  PrevMouseMove: TMouseMoveEvent;
  PrevKeyDown  : TKeyEvent;
  PrevKeyUp    : TKeyEvent;
  PrevKeyPress : TKeyPressEvent;
  PrevClick    : TNotifyEvent;
  PrevDblClick : TNotifyEvent;

  FWorkspace : TGuiWorkspace;
  FActive    : Boolean;
  FEventForm : TForm;
  FEventPanel: TPanel;

  procedure AcquireFormEvents();
  procedure AcquirePanelEvents();
  procedure SetEventForm(const Value: TForm);
    procedure SetEventPanel(const Value: TPanel);
  procedure OwnerMouseDown(Sender: TObject; Button: TMouseButton;
   Shift: TShiftState; X, Y: Integer);
  procedure OwnerMouseUp(Sender: TObject; Button: TMouseButton;
   Shift: TShiftState; X, Y: Integer);
  procedure OwnerMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  procedure OwnerKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure OwnerKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure OwnerKeyPress(Sender: TObject; var Key: Char);
  procedure OwnerClick(Sender: TObject);
  procedure OwnerDblClick(Sender: TObject);

  function GetCtrl(const Name: string): TGuiControl;
 public
  property EventForm : TForm read FEventForm write SetEventForm;
  property EventPanel: TPanel read FEventPanel write SetEventPanel;

  property Workspace: TGuiWorkspace read FWorkspace;
  property Active   : Boolean read FActive write FActive;
  property Ctrl[const Name: string]: TGuiControl read GetCtrl;

  procedure Update();
  procedure Draw();

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
var
 GuiHelper: TGuiHelper = nil;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
constructor TGuiHelper.Create();
begin
 inherited;

 FWorkspace:= TGuiWorkspace.Create(nil);
 FActive  := True;
end;

//---------------------------------------------------------------------------
destructor TGuiHelper.Destroy();
begin
 FWorkspace.Free();

 inherited;
end;

//---------------------------------------------------------------------------
function TGuiHelper.GetCtrl(const Name: string): TGuiControl;
var
 Ctrl: TGuiObject;
begin
 Ctrl:= FWorkspace.Ctrl[Name];
 if (Ctrl <> nil)and(Ctrl is TGuiControl) then
  Result:= TGuiControl(Ctrl) else Result:= nil;
end;

//---------------------------------------------------------------------------
procedure TGuiHelper.OwnerMouseDown(Sender: TObject; Button: TMouseButton;
 Shift: TShiftState; X, Y: Integer);
begin
 if (Assigned(PrevMouseDown)) then PrevMouseDown(Sender, Button, Shift, X, Y);
 if (FActive) then FWorkspace.MouseDown(Button, Shift, X, Y);
end;

//---------------------------------------------------------------------------
procedure TGuiHelper.OwnerMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
 if (Assigned(PrevMouseMove)) then PrevMouseMove(Sender, Shift, X, Y);
 if (FActive) then FWorkspace.MouseMove(Shift, X, Y);
end;

//---------------------------------------------------------------------------
procedure TGuiHelper.OwnerMouseUp(Sender: TObject; Button: TMouseButton;
 Shift: TShiftState; X, Y: Integer);
begin
 if (Assigned(PrevMouseUp)) then PrevMouseUp(Sender, Button, Shift, X, Y);
 if (FActive) then FWorkspace.MouseUp(Button, Shift, X, Y);
end;

//---------------------------------------------------------------------------
procedure TGuiHelper.OwnerKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
 if (Assigned(PrevKeyDown)) then PrevKeyDown(Sender, Key, Shift);
 if (FActive) then FWorkspace.KeyDown(Key, Shift);
end;

//---------------------------------------------------------------------------
procedure TGuiHelper.OwnerKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
 if (Assigned(PrevKeyUp)) then PrevKeyUp(Sender, Key, Shift);
 if (FActive) then FWorkspace.KeyUp(Key, Shift);
end;

//---------------------------------------------------------------------------
procedure TGuiHelper.OwnerKeyPress(Sender: TObject; var Key: Char);
begin
 if (Assigned(PrevKeyPress)) then PrevKeyPress(Sender, Key);
 if (FActive) then FWorkspace.KeyPress(Key);
end;

//---------------------------------------------------------------------------
procedure TGuiHelper.OwnerClick(Sender: TObject);
begin
 if (Assigned(PrevClick)) then PrevClick(Sender);
 FWorkspace.Click();
end;

//---------------------------------------------------------------------------
procedure TGuiHelper.OwnerDblClick(Sender: TObject);
begin
 if (Assigned(PrevDblClick)) then PrevDblClick(Sender);
 FWorkspace.DblClick();
end;

//---------------------------------------------------------------------------
procedure TGuiHelper.AcquireFormEvents();
begin
 with FEventForm do
  begin
   PrevMouseDown:= OnMouseDown;
   PrevMouseUp  := OnMouseUp;
   PrevMouseMove:= OnMouseMove;
   PrevKeyDown  := OnKeyDown;
   PrevKeyUp    := OnKeyUp;
   PrevKeyPress := OnKeyPress;
   PrevClick    := OnClick;
   PrevDblClick := OnDblClick;

   OnMouseDown  := OwnerMouseDown;
   OnMouseUp    := OwnerMouseUp;
   OnMouseMove  := OwnerMouseMove;
   OnKeyDown    := OwnerKeyDown;
   OnKeyUp      := OwnerKeyUp;
   OnKeyPress   := OwnerKeyPress;
   OnClick      := OwnerClick;
   OnDblClick   := OwnerDblClick;
  end;
end;

//---------------------------------------------------------------------------
procedure TGuiHelper.AcquirePanelEvents();
begin
 with FEventPanel do
  begin
   PrevMouseDown:= OnMouseDown;
   PrevMouseUp  := OnMouseUp;
   PrevMouseMove:= OnMouseMove;
   PrevClick    := OnClick;
   PrevDblClick := OnDblClick;

   OnMouseDown  := OwnerMouseDown;
   OnMouseUp    := OwnerMouseUp;
   OnMouseMove  := OwnerMouseMove;
   OnClick      := OwnerClick;
   OnDblClick   := OwnerDblClick;
  end;
end;

//---------------------------------------------------------------------------
procedure TGuiHelper.SetEventForm(const Value: TForm);
begin
 FEventForm:= Value;
 if (FEventForm <> nil) then AcquireFormEvents();
end;

//---------------------------------------------------------------------------
procedure TGuiHelper.SetEventPanel(const Value: TPanel);
begin
 FEventPanel:= Value;
 if (FEventPanel <> nil) then AcquirePanelEvents();
end;

//---------------------------------------------------------------------------
procedure TGuiHelper.Draw();
begin
 if (not FActive) then Exit;

 FWorkspace.Draw();
end;

//---------------------------------------------------------------------------
procedure TGuiHelper.Update();
begin
 if (not FActive) then Exit;
// FWorkspace.Update();
end;

//---------------------------------------------------------------------------
initialization
 GuiHelper:= TGuiHelper.Create();

//---------------------------------------------------------------------------
finalization
 GuiHelper.Free();
 GuiHelper:= nil;

//---------------------------------------------------------------------------
end.
