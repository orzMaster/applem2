unit GuiEdit;
//---------------------------------------------------------------------------
// GuiEdit.pas                                          Modified: 03-Mar-2007
// A simple edit box for Asphyre GUI foundation                   Version 1.0
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
// The Original Code is GuiEdit.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Windows, Types, Classes, Clipbrd, Vectors2px, HelperSets, AsphyreTypes,
 AsphyreUtils, AsphyreEffects, AsphyreFonts, GuiSkins, GuiTypes, GuiUtils,
 GuiShapeRep, GuiObjects, GuiControls;

//---------------------------------------------------------------------------
type
 TGuiEdit = class(TGuiControl)
 private
  FTextOpt : TFontOptions;
  FTextCol : TGuiFontCol;
  FTextFont: string;
  FTextRect: TRect;
  FText    : string;
  FOnChange: TNotifyEvent;

  FSideSpace: Integer;
  FScrollPos: Integer;

  FReadOnly : Boolean;
  FMaxLength: Integer;

  CachedFont : TAsphyreNativeFont;

  PrevDrawPos: TPoint2px;
  TextDrawPos: TPoint2px;
  TextSize   : TPoint2px;
  VirtualSize: TPoint2px;
  LocalRects : TRectList;
  ScreenRects: TRectList;

  FCaretPos   : Integer;
  SelectedPos : Integer;
  FCaretColor : Cardinal;
  FCaretAlpha : Integer;
  FSelectColor: Cardinal;
  FSelectAlpha: Integer;


  function GetTextOpt(): PFontOptions;
  procedure SetText(const Value: string);
  procedure SetMaxLength(const Value: Integer);
  procedure SetScrollPos(const Value: Integer);
  function GetCaretSize(): TPoint2px;
  function UpdateTextRects(): Boolean;
  procedure DrawCaret();
  procedure DrawSelected();
  function NeedToScroll(): Boolean;
  procedure ConstraintScroll();
  procedure ScrollToLeft(Index: Integer);
  procedure ScrollToRight(Index: Integer);
  procedure StripInvalidChars(var Text: string);
  function CharAtPos(const Pos: TPoint2px): Integer;
 protected
  procedure DoDestroy(); override;
  procedure DoDraw(const DrawPos: TPoint2px); override;
  procedure DoKeyEvent(Key: Integer; Event: TKeyEventType;
   SpecialKeys: TSpecialKeyState); override;
  procedure DoMouseEvent(const Pos: TPoint2px; Event: TMouseEventType;
   Button: TMouseButtonType; SpecialKeys: TSpecialKeyState); override;

  procedure DoDescribe(); override;
  procedure WriteProperty(Code: Cardinal; Source: Pointer); override;

  function GetSkinDrawType(): TSkinDrawType; override;
 public
  property TextOpt : PFontOptions read GetTextOpt;
  property TextCol : TGuiFontCol read FTextCol;
  property TextFont: string read FTextFont write FTextFont;
  property TextRect: TRect read FTextRect write FTextRect;

  property SideSpace: Integer read FSideSpace write FSideSpace;
  property ScrollPos: Integer read FScrollPos write SetScrollPos;
  property CaretPos : Integer read FCaretPos write FCaretPos;

  property ReadOnly : Boolean read FReadOnly write FReadOnly;
  property MaxLength: Integer read FMaxLength write SetMaxLength;

  property CaretColor : Cardinal read FCaretColor write FCaretColor;
  property CaretAlpha : Integer read FCaretAlpha write FCaretAlpha;
  property SelectColor: Cardinal read FSelectColor write FSelectColor;
  property SelectAlpha: Integer read FSelectAlpha write FSelectAlpha;

  property OnChange: TNotifyEvent read FOnChange write FOnChange;

  property Text: string read FText write SetText;

  constructor Create(AOwner: TGuiObject); override;
 end;

//---------------------------------------------------------------------------
implementation

uses
 SysUtils;

//---------------------------------------------------------------------------
const
 PropBase = $1000;

//---------------------------------------------------------------------------
 CaretDrawSpeed  = 1.0;
 SelectDrawSpeed = 1.2;
 AllowedChars    = [#32..#255];
 SpaceToCaret    = 1;


//---------------------------------------------------------------------------
constructor TGuiEdit.Create(AOwner: TGuiObject);
begin
 inherited;

 FTextCol   := TGuiFontCol.Create();
 LocalRects := TRectList.Create();
 ScreenRects:= TRectList.Create();

 FSideSpace := 2;
 FScrollPos := 0;
 FReadOnly  := False;
 FMaxLength := 0;

 SelectedPos := -1;
 FCaretAlpha := 96;
 FSelectAlpha:= 32;

 FText:= '';
 FTextOpt.Reset();
end;

//---------------------------------------------------------------------------
procedure TGuiEdit.DoDestroy();
begin
 ScreenRects.Free();
 LocalRects.Free();
 FTextCol.Free();

 inherited;
end;

//---------------------------------------------------------------------------
function TGuiEdit.GetTextOpt(): PFontOptions;
begin
 Result:= @FTextOpt;
end;

//---------------------------------------------------------------------------
procedure TGuiEdit.SetText(const Value: string);
var
 Changed: Boolean;
begin
 Changed:= (Value <> FText);
 FText:= Value;

 if (FMaxLength > 0)and(Length(FText) > FMaxLength) then
  FText:= Copy(FText, 1, FMaxLength);

 FCaretPos:= Length(FText);
 if (NeedToScroll()) then ScrollToRight(FCaretPos);

 if (Changed)and(Assigned(OnChange)) then OnChange(Self)
end;

//---------------------------------------------------------------------------
procedure TGuiEdit.SetMaxLength(const Value: Integer);
begin
 FMaxLength:= Value;

 if (FMaxLength > 0)and(Length(FText) > FMaxLength) then
  begin
   FText:= Copy(FText, 1, FMaxLength);
   if (FScrollPos > Length(FText)) then FScrollPos:= Length(FText);
  end;
end;

//---------------------------------------------------------------------------
procedure TGuiEdit.SetScrollPos(const Value: Integer);
begin
 FScrollPos:= Value;
 if (FScrollPos < 0) then FScrollPos:= 0;
 if (FScrollPos > Length(FText)) then FScrollPos:= Length(FText);
end;

//---------------------------------------------------------------------------
function TGuiEdit.GetCaretSize(): TPoint2px;
begin
 Result.x:= (FTextRect.Bottom - FTextRect.Top) div 3;
 Result.y:= (FTextRect.Bottom - FTextRect.Top) - (SideSpace * 2);
end;

//---------------------------------------------------------------------------
function TGuiEdit.UpdateTextRects(): Boolean;
var
 i: Integer;
 CaretSize: TPoint2px;
begin
 CachedFont:= GuiFonts.Font[FTextFont];
 if (CachedFont = nil) then
  begin
   Result:= False;
   Exit;
  end;

 CachedFont.Options^:= FTextOpt;

 // (1) Determine the complete text and caret size.
 TextSize := CachedFont.TextExtent(FText);
 CaretSize:= GetCaretSize();

 // (2) Determine the "virtualized" text size, including caret.
 VirtualSize.x:= TextSize.x + SpaceToCaret + CaretSize.x;
 VirtualSize.y:= (FTextRect.Bottom - FTextRect.Top) - (FSideSpace * 2);

 // (4) The position in screen space to draw text and caret at.
 TextDrawPos.x:= PrevDrawPos.x + FSideSpace + FTextRect.Left - FScrollPos;
 TextDrawPos.y:= PrevDrawPos.y +  FTextRect.Top + ((FTextRect.Bottom -
  FTextRect.Top) - TextSize.y) div 2;

 // (5) Find individual letter rectangles.
 LocalRects.Clear();
 CachedFont.TextRects(FText, LocalRects);

// (6) Include caret in rectangle list. 
 if (LocalRects.Count > 0) then
  LocalRects.Add(TextSize.x + SpaceToCaret, 0, CaretSize.x, VirtualSize.y)
   else LocalRects.Add(0, 0, CaretSize.x, VirtualSize.y);

 ScreenRects.Clear();
 for i:= 0 to LocalRects.Count - 1 do
  ScreenRects.Add(TextDrawPos.x + LocalRects[i].Left, PrevDrawPos.y +
   FTextRect.Top + FSideSpace, LocalRects[i].Right - LocalRects[i].Left,
   (FTextRect.Bottom - FTextRect.Top) - (FSideSpace * 2));

 Result:= True;
end;

//---------------------------------------------------------------------------
procedure TGuiEdit.DoDraw(const DrawPos: TPoint2px);
var
 PrevClipRect: TRect;
begin
 PrevDrawPos:= DrawPos;
 if (not UpdateTextRects()) then Exit;

 PrevClipRect:= GuiCanvas.ClipRect;
 GuiCanvas.ClipRect:= MoveRect(FTextRect, DrawPos);
 CachedFont.TextOut(FText, TextDrawPos.x, TextDrawPos.y,
  FTextCol.UseColor(GetSkinDrawType()));

 if (SelectedPos <> -1)and(SelectedPos <> FCaretPos) then DrawSelected();
 if (Focused) then DrawCaret();

 GuiCanvas.ClipRect:= PrevClipRect;
end;

//---------------------------------------------------------------------------
procedure TGuiEdit.DrawCaret();
var
 Theta: Real;
 Alpha: Integer;
begin
 if (FCaretPos < 0)or(FCaretPos >= ScreenRects.Count) then Exit;

 Theta:= (Sin(GetTickCount() * CaretDrawSpeed / 100.0) + 1.0) * 0.5;
 Theta:= 0.5 + (Theta * 0.5);
 Alpha:= Round(Theta * FCaretAlpha);

 GuiCanvas.FillQuad(pRect4(ScreenRects[FCaretPos]^), cColorAlpha4(FCaretColor,
  Alpha), fxuBlend);
 GuiCanvas.WireQuadHw(pRect4(ScreenRects[FCaretPos]^), cColorAlpha4(FCaretColor,
  Alpha), fxuBlend);
end;

//---------------------------------------------------------------------------
procedure TGuiEdit.DrawSelected();
var
 Theta: Real;
 Alpha: Integer;
begin
 if (SelectedPos < 0)or(SelectedPos >= ScreenRects.Count) then Exit;

 Theta:= (Sin(GetTickCount() * SelectDrawSpeed / 100.0) + 1.0) * 0.5;
 Theta:= 0.5 + (Theta * 0.5);
 Alpha:= Round(Theta * FSelectAlpha);

 GuiCanvas.FillQuad(pRect4(ScreenRects[SelectedPos]^),
  cColorAlpha4(FSelectColor,  Alpha), fxuBlend);
 GuiCanvas.WireQuadHw(pRect4(ScreenRects[SelectedPos]^),
  cColorAlpha4(FSelectColor, Alpha), fxuBlend);
end;

//---------------------------------------------------------------------------
function TGuiEdit.NeedToScroll(): Boolean;
var
 ChRect, CutRect: TRect;
begin
 if (not UpdateTextRects())or(FCaretPos < 0)or
  (FCaretPos >= LocalRects.Count) then
  begin
   Result:= False;
   Exit;
  end;

 ChRect := MoveRect(LocalRects[FCaretPos]^, Point2px(-FScrollPos, 0));
 CutRect:= ShortRect(ChRect, Bounds(0, 0, (FTextRect.Right - FTextRect.Left) -
  (FSideSpace * 2), FTextRect.Bottom - FTextRect.Top));

 Result:= (CutRect.Right - CutRect.Left) < (ChRect.Right - ChRect.Left);
end;

//---------------------------------------------------------------------------
procedure TGuiEdit.ConstraintScroll();
var
 MaxScroll: Integer;
begin
 MaxScroll:= TextSize.x;
 if (MaxScroll = 0) then MaxScroll:= GetCaretSize().x
  else Inc(MaxScroll, SpaceToCaret + GetCaretSize().x);

 MaxScroll:= Max2(MaxScroll - ((FTextRect.Right - FTextRect.Left) -
  (FSideSpace * 2)), 0);

 FScrollPos:= MinMax2(FScrollPos, 0, MaxScroll); 
end;

//---------------------------------------------------------------------------
procedure TGuiEdit.ScrollToLeft(Index: Integer);
var
 ChRect: TRect;
begin
 if (not UpdateTextRects())or(Index < 0)or
  (Index >= LocalRects.Count) then Exit;

 ChRect:= LocalRects[Index]^;
 if (ChRect.Right <= ChRect.Left)and(ChRect.Right = 0) then Exit;

 FScrollPos:= ChRect.Left;
 ConstraintScroll();
end;

//---------------------------------------------------------------------------
procedure TGuiEdit.ScrollToRight(Index: Integer);
var
 ChRect: TRect;
begin
 if (not UpdateTextRects())or(Index < 0)or
  (Index >= LocalRects.Count) then Exit;

 ChRect:= LocalRects[Index]^;
 if (ChRect.Right <= ChRect.Left)and(ChRect.Right = 0) then Exit;

 FScrollPos:= ChRect.Right - ((FTextRect.Right - FTextRect.Left) -
  (FSideSpace * 2));
 ConstraintScroll();
end;

//---------------------------------------------------------------------------
procedure TGuiEdit.StripInvalidChars(var Text: string);
var
 i: Integer;
begin
 Text:= Trim(Text);

 for i:= Length(Text) downto 1 do
  if (not (Text[i] in AllowedChars)) then Delete(Text, i, 1);
end;

//---------------------------------------------------------------------------
procedure TGuiEdit.DoKeyEvent(Key: Integer; Event: TKeyEventType;
 SpecialKeys: TSpecialKeyState);
var
 Ch: Char;
 Clipboard: TClipboard;
 AddTx: string;
begin
 if (Event = ketDown) then
  begin
   case Key of
    VK_RIGHT:
     begin
      if (FCaretPos < LocalRects.Count - 1) then Inc(FCaretPos);
      if (NeedToScroll()) then ScrollToRight(FCaretPos);
     end;
    VK_LEFT:
     begin
      if (FCaretPos > 0) then Dec(FCaretPos);
      if (NeedToScroll()) then ScrollToLeft(FCaretPos);
     end;
    VK_BACK:
     if (not FReadOnly) then
      begin
       Delete(FText, FCaretPos, 1);

       if (FCaretPos > 0) then Dec(FCaretPos);
       if (NeedToScroll()) then ScrollToRight(FCaretPos);

       if (Assigned(FOnChange)) then FOnChange(Self);
      end;
    VK_DELETE:
     if (not FReadOnly) then
      begin
       Delete(FText, FCaretPos + 1, 1);
       if (Assigned(FOnChange)) then FOnChange(Self);
      end;

    VK_HOME:
     begin
      FCaretPos:= 0;
      if (NeedToScroll()) then ScrollToLeft(FCaretPos);
     end;

    VK_END:
     begin
      FCaretPos:= Length(FText);
      if (NeedToScroll()) then ScrollToRight(FCaretPos);
     end;
   end;

   if (Key = Byte('V'))and(sksCtrl in SpecialKeys)and(not FReadOnly) then
    begin
     Clipboard:= TClipboard.Create();

     AddTx:= Clipboard.AsText;
     StripInvalidChars(AddTx);

     Insert(AddTx, FText, FCaretPos + 1);
     Inc(FCaretPos, Length(AddTx));

     if (FMaxLength > 0)and(Length(FText) > FMaxLength) then
      begin
       FText:= Copy(FText, 1, FMaxLength);
       if (FCaretPos > Length(FText)) then FCaretPos:= Length(FText);
      end;

     if (NeedToScroll()) then ScrollToRight(FCaretPos);

     Clipboard.Free();

     if (Assigned(FOnChange)) then FOnChange(Self);
    end;

   Exit;
  end else if (Event <> ketPress)or(FReadOnly) then Exit;

 Ch:= Char(Key);

 if (Ch in AllowedChars)and((FMaxLength < 1)or(Length(FText) < FMaxLength)) then
  begin
   if (FText = '')or(FCaretPos >= Length(FText)) then FText:= FText + Ch
    else Insert(Ch, FText, FCaretPos + 1);

   Inc(FCaretPos);
   if (NeedToScroll()) then ScrollToRight(FCaretPos);

   if (Assigned(FOnChange)) then FOnChange(Self);
  end;

{ if (Ch = #9) then
  FocusNextTabOrder();}
end;

//---------------------------------------------------------------------------
function TGuiEdit.CharAtPos(const Pos: TPoint2px): Integer;
var
 ScreenRect: TRect;
 i: Integer;
begin
 ScreenRect:= MoveRect(FTextRect, PrevDrawPos);

 Result:= -1;
 for i:= 0 to ScreenRects.Count - 1 do
  if (PointInRect(Pos, ShortRect(ScreenRects[i]^, ScreenRect))) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
procedure TGuiEdit.DoMouseEvent(const Pos: TPoint2px; Event: TMouseEventType;
 Button: TMouseButtonType; SpecialKeys: TSpecialKeyState);
var
 LocalPos: TPoint2px;
begin
 LocalPos:= ScreenToLocal(Pos);
 if (not PointInRect(LocalPos, FTextRect)) then Exit;

 SelectedPos:= CharAtPos(Pos);
 if (Event = metDown)and(Button = mbtLeft)and(SelectedPos <> -1) then
  begin
   FCaretPos:= SelectedPos;

   if (LocalPos.x > GetBoundBox(Shape).Right div 2) then
    ScrollToRight(FCaretPos) else ScrollToLeft(FCaretPos);
  end;
end;

//---------------------------------------------------------------------------
procedure TGuiEdit.DoDescribe();
begin
 inherited;

 Describe(PropBase + $0, 'TextOpt',     gdtFontOpt);
 Describe(PropBase + $1, 'TextCol',     gdtFontColor);
 Describe(PropBase + $2, 'TextFont',    gdtString);
 Describe(PropBase + $3, 'TextRect',    gdtRect);
 Describe(PropBase + $4, 'SideSpace',   gdtInteger);
 Describe(PropBase + $5, 'ReadOnly',    gdtBoolean);
 Describe(PropBase + $6, 'MaxLength',   gdtInteger);
 Describe(PropBase + $7, 'CaretColor',  gdtColor);
 Describe(PropBase + $8, 'CaretAlpha',  gdtInteger);
 Describe(PropBase + $9, 'SelectColor', gdtColor);
 Describe(PropBase + $A, 'SelectAlpha', gdtInteger);
 Describe(PropBase + $B, 'Text',        gdtString);
end;

//---------------------------------------------------------------------------
procedure TGuiEdit.WriteProperty(Code: Cardinal; Source: Pointer);
begin
 case Code of
  PropBase + $0:
   FTextOpt:= PFontOptions(Source)^;

  PropBase + $1:
   FTextCol.Assign(TGuiFontCol(Source));

  PropBase + $2:
   FTextFont:= PChar(Source);

  PropBase + $3:
   FTextRect:= PRect(Source)^;

  PropBase + $4:
   FSideSpace:= PInteger(Source)^;

  PropBase + $5:
   FReadOnly:= PBoolean(Source)^;

  PropBase + $6:
   FMaxLength:= PInteger(Source)^;

  PropBase + $7:
   FCaretColor:= PCardinal(Source)^;

  PropBase + $8:
   FCaretAlpha:= PInteger(Source)^;

  PropBase + $9:
   FSelectColor:= PCardinal(Source)^;

  PropBase + $A:
   FSelectAlpha:= PInteger(Source)^;

  PropBase + $B:
   Text:= PChar(Source);

  else inherited WriteProperty(Code, Source);
 end;
end;

//---------------------------------------------------------------------------
function TGuiEdit.GetSkinDrawType(): TSkinDrawType;
begin
 Result:= sdtNormal;

 if (MouseOver) then Result:= sdtOver;
 if (MouseDown) then Result:= sdtDown;
 if (Focused) then Result:= sdtFocused;
 if (not Enabled) then Result:= sdtDisabled;
end;

//---------------------------------------------------------------------------
end.
