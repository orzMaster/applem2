unit GuiControls;
//---------------------------------------------------------------------------
// GuiControls.pas                                      Modified: 03-Mar-2007
// Standard GUI controls for Asphyre GUI foundation               Version 1.0
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
// The Original Code is GuiControls.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Types, Classes, Vectors2px, GuiTypes, GuiShapeRep, GuiObjects, GuiSkins;

//---------------------------------------------------------------------------
type
 TGuiControl = class(TGuiObject)
 private
  FShape    : string;
  FOrigin   : TPoint2px;
  FVisible  : Boolean;
  FEnabled  : Boolean;
  FSkin     : TGuiSkin;
  FMouseOver: Boolean;
  FMouseDown: Boolean;

  FOnMove: TNotifyEvent;
  FOnShow: TNotifyEvent;
  FOnHide: TNotifyEvent;

  FOnMouse     : TGuiMouseEvent;
  FOnKey       : TGuiKeyEvent;
  FOnClick     : TNotifyEvent;
  FOnDblClick  : TNotifyEvent;
  FOnMouseEnter: TNotifyEvent;
  FOnMouseLeave: TNotifyEvent;

  procedure SetOrigin(const Value: TPoint2px);
  procedure SetVisible(const Value: Boolean);
  procedure SetEnabled(const Value: Boolean);
  function GetFocused(): Boolean;
  function FindControlForFocus(): Integer;
  procedure RefreshFocusIndex();
 protected
  FocusIndex: Integer;

  procedure DoDestroy(); override;
  procedure DoObjectLinked(Index: Integer; Obj: TGuiObject); override;
  procedure DoObjectUnlinked(Index: Integer; Obj: TGuiObject); override;
  procedure MoveToFront(Index: Integer); override;
  procedure MoveToBack(Index: Integer); override;
  function GetBoundBox(const Shape: string): TRect;

  procedure DoDescribe(); override;
  procedure WriteProperty(Code: Cardinal; Source: Pointer); override;

  procedure DoMove(); virtual;
  procedure DoShow(); virtual;
  procedure DoHide(); virtual;
  procedure DoEnable(); virtual;
  procedure DoDisable(); virtual;

  procedure DoMouseEvent(const Pos: TPoint2px; Event: TMouseEventType;
   Button: TMouseButtonType; SpecialKeys: TSpecialKeyState); virtual;
  procedure DoKeyEvent(Key: Integer; Event: TKeyEventType;
   SpecialKeys: TSpecialKeyState); virtual;

  function GetSkinDrawType(): TSkinDrawType; virtual;
  procedure DoDraw(const DrawPos: TPoint2px); virtual;
  procedure DrawSkin(const DrawPos: TPoint2px); virtual;
  procedure DrawAt(const AtPos: TPoint2px);
 public
  // The shape identifying the control's area.
  property Shape: string read FShape write FShape;

  // The origin of control's area
  property Origin: TPoint2px read FOrigin write SetOrigin;

  // Whether the control is visible or not.
  property Visible: Boolean read FVisible write SetVisible;

  // Whether the control can accept input or not.
  property Enabled: Boolean read FEnabled write SetEnabled;

  // Whether the mouse is inside the control's area
  property MouseOver: Boolean read FMouseOver;

  // Whether the control is being "clicked" on.
  property MouseDown: Boolean read FMouseDown;

  // Indicates whether the control has keyboard focus.
  property Focused: Boolean read GetFocused;

  // Control skinning helper
  property Skin: TGuiSkin read FSkin;

  // The events published for user convenience.
  property OnMove: TNotifyEvent read FOnMove write FOnMove;
  property OnShow: TNotifyEvent read FOnShow write FOnShow;
  property OnHide: TNotifyEvent read FOnHide write FOnHide;
  property OnMouse     : TGuiMouseEvent read FOnMouse write FOnMouse;
  property OnKey       : TGuiKeyEvent read FOnKey write FOnKey;
  property OnClick     : TNotifyEvent read FOnClick write FOnClick;
  property OnDblClick  : TNotifyEvent read FOnDblClick write FOnDblClick;
  property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
  property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;

  // Conversion utilities between screen pixel space and local space.
  function ScreenToLocal(const Point: TPoint2px): TPoint2px;
  function LocalToScreen(const Point: TPoint2px): TPoint2px;

  // Determines whether the specified point is inside the area of this
  // control
  function PointInside(const Shape: string;
   const Point: TPoint2px): Boolean;

  // Attempts to find the control at specified mouse position in screen
  // space (only visible controls are found this way).
  function FindCtrlAt(const Point: TPoint2px): TGuiControl; virtual;

  // The following methods move the control either to front or back drawing
  // queque.
  procedure BringToFront(); virtual;
  procedure SendToBack(); virtual;
  procedure SetFocus(); virtual;

  // The following two methods accept mouse and keyboard input.
  procedure AcceptMouse(const Pos: TPoint2px; Event: TMouseEventType;
   Button: TMouseButtonType; SpecialKeys: TSpecialKeyState);
  procedure AcceptKey(Key: Integer; Event: TKeyEventType;
   SpecialKeys: TSpecialKeyState);

  constructor Create(AOwner: TGuiObject); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreTypes, AsphyreUtils, AsphyreEffects, GuiUtils;

//---------------------------------------------------------------------------
const
 PropBase = $100;

//---------------------------------------------------------------------------
constructor TGuiControl.Create(AOwner: TGuiObject);
begin
 inherited;

 FVisible:= True;
 FEnabled:= True;

 FSkin:= TGuiSkin.Create();

 FocusIndex:= -1;
end;

//---------------------------------------------------------------------------
procedure TGuiControl.DoDestroy();
begin
 FSkin.Free();
end;

//---------------------------------------------------------------------------
procedure TGuiControl.DoObjectLinked(Index: Integer; Obj: TGuiObject);
begin
 if (FocusIndex = -1) then FocusIndex:= Index;
end;

//---------------------------------------------------------------------------
function TGuiControl.FindControlForFocus(): Integer;
var
 i: Integer;
begin
 Result:= -1;

 for i:= 0 to ChildCount - 1 do
  if (Child[i] is TGuiControl)and(TGuiControl(Child[i]).Visible)and
   (TGuiControl(Child[i]).Enabled) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
procedure TGuiControl.RefreshFocusIndex();
begin
 FocusIndex:= FindControlForFocus();
end;

//---------------------------------------------------------------------------
procedure TGuiControl.DoObjectUnlinked(Index: Integer; Obj: TGuiObject);
begin
 if (FocusIndex = Index) then
  RefreshFocusIndex();
end;

//---------------------------------------------------------------------------
procedure TGuiControl.DoHide();
begin
 if (Owner <> nil)and(Owner is TGuiControl) then
  with Owner as TGuiControl do
   if (FocusIndex = IndexOf(Self)) then
    RefreshFocusIndex();
end;

//---------------------------------------------------------------------------
procedure TGuiControl.DoShow();
begin
 if (Owner <> nil)and(Owner is TGuiControl) then
  with Owner as TGuiControl do
   if (FocusIndex = -1) then
    RefreshFocusIndex();
end;

//---------------------------------------------------------------------------
procedure TGuiControl.MoveToFront(Index: Integer);
begin
 if (FocusIndex = Index) then FocusIndex:= 0;

 inherited;
end;

//---------------------------------------------------------------------------
procedure TGuiControl.MoveToBack(Index: Integer);
begin
 if (FocusIndex = Index) then FocusIndex:= ChildCount - 1;

 inherited;
end;

//---------------------------------------------------------------------------
procedure TGuiControl.DoMove();
begin
 // no code
end;

//---------------------------------------------------------------------------
procedure TGuiControl.DoDisable();
begin
 // no code
end;

//---------------------------------------------------------------------------
procedure TGuiControl.DoEnable();
begin
 // no code
end;

//---------------------------------------------------------------------------
procedure TGuiControl.DoMouseEvent(const Pos: TPoint2px; Event: TMouseEventType;
 Button: TMouseButtonType; SpecialKeys: TSpecialKeyState);
begin
 // no code
end;

//---------------------------------------------------------------------------
procedure TGuiControl.DoKeyEvent(Key: Integer; Event: TKeyEventType;
 SpecialKeys: TSpecialKeyState);
begin
 // no code
end;

//---------------------------------------------------------------------------
procedure TGuiControl.DoDraw(const DrawPos: TPoint2px);
begin
 // no code
end;

//---------------------------------------------------------------------------
procedure TGuiControl.SetOrigin(const Value: TPoint2px);
begin
 FOrigin:= Value;

 DoMove();

 if (Assigned(FOnMove)) then FOnMove(Self);
end;

//---------------------------------------------------------------------------
procedure TGuiControl.SetVisible(const Value: Boolean);
begin
 if (FVisible <> Value) then
  begin
   FVisible:= Value;

   if (FVisible) then
    begin
     DoShow();
     if (Assigned(FOnShow)) then FOnShow(Self);
    end else
    begin
     if (Assigned(FOnHide)) then FOnHide(Self);
     DoHide();
    end;
  end;
end;

//---------------------------------------------------------------------------
procedure TGuiControl.SetEnabled(const Value: Boolean);
begin
 if (FEnabled <> Value) then
  begin
   FEnabled:= Value;
   if (FEnabled) then DoEnable() else DoDisable();
  end;
end;

//---------------------------------------------------------------------------
function TGuiControl.GetFocused(): Boolean;
begin
 if (Owner = nil)or(not (Owner is TGuiControl)) then
  begin
   Result:= True;
   Exit;
  end;

 with Owner as TGuiControl do
  Result:= (FocusIndex = IndexOf(Self))and(Focused);
end;

//---------------------------------------------------------------------------
function TGuiControl.LocalToScreen(const Point: TPoint2px): TPoint2px;
var
 Temp: TGuiControl;
begin
 Result:= Point + FOrigin;

 Temp:= nil;
 if (Owner <> nil)and(Owner is TGuiControl) then
  Temp:= TGuiControl(Owner);

 while (Temp <> nil) do
  begin
   Result:= Result + Temp.Origin;

   if (Temp.Owner <> nil)and(Temp.Owner is TGuiControl) then
    Temp:= TGuiControl(Temp.Owner) else Temp:= nil;
  end;
end;

//---------------------------------------------------------------------------
function TGuiControl.ScreenToLocal(const Point: TPoint2px): TPoint2px;
var
 Temp: TGuiControl;
begin
 Result:= Point - FOrigin;

 Temp:= nil;
 if (Owner <> nil)and(Owner is TGuiControl) then
  Temp:= TGuiControl(Owner);

 while (Temp <> nil) do
  begin
   Result:= Result - Temp.Origin;

   if (Temp.Owner <> nil)and(Temp.Owner is TGuiControl) then
    Temp:= TGuiControl(Temp.Owner) else Temp:= nil;
  end;
end;

//---------------------------------------------------------------------------
function TGuiControl.PointInside(const Shape: string;
 const Point: TPoint2px): Boolean;
var
 GShape: TGuiShape;
begin
 GShape:= GuiShapes.Shape[Shape];
 if (GShape <> nil) then
  Result:= GShape.PointInside(ScreenToLocal(Point)) else Result:= False;
end;

//---------------------------------------------------------------------------
function TGuiControl.GetBoundBox(const Shape: string): TRect;
var
 GShape: TGuiShape;
begin
 GShape:= GuiShapes.Shape[Shape];
 if (GShape <> nil) then Result:= GShape.BoundingBox
  else Result:= Rect(0, 0, 1, 1);
end;

//---------------------------------------------------------------------------
function TGuiControl.FindCtrlAt(const Point: TPoint2px): TGuiControl;
var
 Index: Integer;
 Temp : TGuiControl;
begin
 // Verify first if the mouse is within this control's area.
 if (not FVisible)or(not PointInside(FShape, Point)) then
  begin
   Result:= nil;
   Exit;
  end;

 // This control is selected by default.
 Result:= Self;

 // Check whether some of the child controls is selected.
 for Index:= 0 to ChildCount - 1 do
  begin
   Temp:= nil;

   if (Child[Index] is TGuiControl) then
    Temp:= TGuiControl(Child[Index]).FindCtrlAt(Point);

   if (Temp <> nil) then
    begin
     Result:= Temp;
     Break;
    end;
  end;
end;

//---------------------------------------------------------------------------
procedure TGuiControl.BringToFront();
begin
 if (Owner <> nil)and(Owner is TGuiControl) then
  TGuiControl(Owner).MoveToFront(Owner.IndexOf(Self));
end;

//---------------------------------------------------------------------------
procedure TGuiControl.SendToBack();
begin
 if (Owner <> nil)and(Owner is TGuiControl) then
  TGuiControl(Owner).MoveToBack(Owner.IndexOf(Self));
end;

//---------------------------------------------------------------------------
procedure TGuiControl.SetFocus();
begin
 if (Owner <> nil)and(Owner is TGuiControl) then
  with Owner as TGuiControl do
   begin
    FocusIndex:= IndexOf(Self);
    SetFocus();
   end;
end;

//---------------------------------------------------------------------------
function TGuiControl.GetSkinDrawType(): TSkinDrawType;
begin
 Result:= sdtNormal;

 if (Focused) then Result:= sdtFocused;
 if (FMouseOver) then Result:= sdtOver;
 if (FMouseDown) then Result:= sdtDown;
 if (not FEnabled) then Result:= sdtDisabled;
end;

//---------------------------------------------------------------------------
procedure TGuiControl.DrawSkin(const DrawPos: TPoint2px);
var
 BoundBox: TRect;
begin
 if (not FSkin.UseImage(GetSkinDrawType())) then Exit;

 BoundBox:= GetBoundBox(FShape);

 GuiCanvas.TexMap(pRect4(MoveRect(BoundBox, DrawPos)), clWhite4,
  fxuBlend);
end;

//---------------------------------------------------------------------------
procedure TGuiControl.AcceptMouse(const Pos: TPoint2px; Event: TMouseEventType;
 Button: TMouseButtonType; SpecialKeys: TSpecialKeyState);
begin
 DoMouseEvent(Pos, Event, Button, SpecialKeys);

 if (Assigned(FOnMouse)) then FOnMouse(Self, Pos, Event, Button, SpecialKeys);

 if (Event = metClick)and(FEnabled)and(Assigned(FOnClick))and
  (PointInside(FShape, Pos)) then FOnClick(Self);

 if (Event = metDblClick)and(FEnabled)and(Assigned(FOnDblClick))and
  (PointInside(FShape, Pos)) then FOnDblClick(Self);

 if (Event = metDown)and(FEnabled)and(Button = mbtLeft) then
  FMouseDown:= True;

 if (Event = metUp)and(FEnabled)and(Button = mbtLeft) then
  FMouseDown:= False;

 if (Event = metEnter) then
  begin
   FMouseOver:= True;
   if (Assigned(FOnMouseEnter)) then FOnMouseEnter(Self);
  end;

 if (Event = metLeave) then
  begin
   FMouseOver:= False;
   if (Assigned(FOnMouseLeave)) then FOnMouseLeave(Self);
  end;
end;

//---------------------------------------------------------------------------
procedure TGuiControl.AcceptKey(Key: Integer; Event: TKeyEventType;
 SpecialKeys: TSpecialKeyState);
var
 FocusChild: TGuiObject;
begin
 FocusChild:= Child[FocusIndex];
 if (FocusChild <> nil)and(FocusChild is TGuiControl) then
  begin
   TGuiControl(FocusChild).AcceptKey(Key, Event, SpecialKeys);
  end else
  begin
   DoKeyEvent(Key, Event, SpecialKeys);
   if (Assigned(FOnKey)) then FOnKey(Self, Key, Event, SpecialKeys);
  end;
end;

//---------------------------------------------------------------------------
procedure TGuiControl.DrawAt(const AtPos: TPoint2px);
var
 DrawPos: TPoint2px;
 i: Integer;
begin
 DrawPos:= AtPos + FOrigin;

 DrawSkin(DrawPos);

 DoDraw(DrawPos);

 for i:= ChildCount - 1 downto 0 do
  if (Child[i] is TGuiControl)and(TGuiControl(Child[i]).Visible) then
   TGuiControl(Child[i]).DrawAt(DrawPos);
end;

//---------------------------------------------------------------------------
procedure TGuiControl.DoDescribe();
begin
 inherited;

 Describe(PropBase + $0, 'Origin',  gdtPoint);
 Describe(PropBase + $1, 'Visible', gdtBoolean);
 Describe(PropBase + $2, 'Enabled', gdtBoolean);
 Describe(PropBase + $3, 'Skin',    gdtSkin);
 Describe(PropBase + $4, 'Shape',   gdtString);
end;

//---------------------------------------------------------------------------
procedure TGuiControl.WriteProperty(Code: Cardinal; Source: Pointer);
begin
 case Code of
  PropBase + $0:
   FOrigin:= PPoint2px(Source)^;

  PropBase + $1:
   FVisible:= PBoolean(Source)^;

  PropBase + $2:
   FEnabled:= PBoolean(Source)^;

  PropBase + $3:
   FSkin.Assign(TGuiSkin(Source));

  PropBase + $4:
   FShape:= PChar(Source);

  else inherited WriteProperty(Code, Source);
 end;
end;

//---------------------------------------------------------------------------
end.

