unit MenuItem;
(*
** Haaf's Game Engine 1.7
** Copyright (C) 2003-2007, Relish Games
** hge.relishgames.com
**
** Tutorial 06 - Creating menus
*
** Delphi conversion by Erik van Bilsen
*)

interface

uses
  HGE, HGEGUI, HGEFont, HGEColor;

(****************************************************************************
 * MenuItem.h
 ****************************************************************************)

type
  IHGEGUIMenuItem = interface(IHGEGUIObject)
  ['{238E3101-C3AF-4BAA-863A-BA51ACA26B6B}']
    { No new public functionality }
  end;

type
  THGEGUIMenuItem = class(THGEGUIObject,IHGEGUIMenuItem)
  protected
    { IHGEGUIObject}
    procedure Render; override;
    procedure Update(const DT: Single); override;

    procedure Enter; override;
    procedure Leave; override;
    function IsDone: Boolean; override;
    procedure Focus(const Focused: Boolean); override;
    procedure MouseOver(const Over: Boolean); override;

    function MouseLButton(const Down: Boolean): Boolean; override;
    function KeyClick(const Key, Chr: Integer): Boolean; override;
  private
    FFont: IHGEFont;
    FSnd: IEffect;
    FDelay: Single;
    FTitle: String;
    FSColor, FDColor, FSColor2, FDColor2, FSShadow, FDShadow: THGEColor;
    FColor, FShadow: THGEColor;
    FSOffset, FDOffset, FOffset: Single;
    FTimer, FTimer2: Single;
  public
    constructor Create(const AId: Integer; const AFont: IHGEFont;
      const ASnd: IEffect; const AX, AY, ADelay: Single; const ATitle: String);
  end;

implementation

uses
  HGERect;

(****************************************************************************
 * MenuItem.cpp
 ****************************************************************************)

{ THGEGUIMenuItem }

constructor THGEGUIMenuItem.Create(const AId: Integer; const AFont: IHGEFont;
  const ASnd: IEffect; const AX, AY, ADelay: Single; const ATitle: String);
var
  W: Single;
begin
  inherited Create;
  Id := AId;
  FFont := AFont;
  FSnd := ASnd;
  FDelay := ADelay;
  FTitle := ATitle;
  FColor.SetHWColor($FFFFE060);
  FShadow.SetHWColor($30000000);
  FTimer := -1;
  FTimer2 := -1;
  Visible := True;
  Enabled := True;
  W := FFont.GetStringWidth(FTitle);
  Rect := THGERect.Create(AX - W / 2,AY,AX + W / 2,AY + FFont.GetHeight);
end;

// This method is called when the GUI
// is about to appear on the screen
procedure THGEGUIMenuItem.Enter;
var
  TColor2: THGEColor;
begin
  FSColor2.SetHWColor($00FFE060);
  TColor2.SetHWColor($FFFFE060);
  FDColor2 := TColor2 - FSColor2;

  FSShadow.SetHWColor($00000000);
  TColor2.SetHWColor($30000000);
  FDShadow := TColor2 - FSShadow;

  FTimer2 := 0;
end;

// This method is called when the control
// receives or loses keyboard input focus
procedure THGEGUIMenuItem.Focus(const Focused: Boolean);
var
  TColor: THGEColor;
begin
  if (Focused) then begin
    FSnd.Play;
    FSColor.SetHWColor($FFFFE060);
    TColor.SetHWColor($FFFFFFFF);
    FSOffset := 0;
    FDOffset := 4;
  end else begin
    FSColor.SetHWColor($FFFFFFFF);
    TColor.SetHWColor($FFFFE060);
    FSOffset := 4;
    FDOffset := -4;
  end;
  FDColor := TColor - FSColor;
  FTimer := 0;
end;

// This method is called to test whether the control
// have finished it's Enter/Leave animation
function THGEGUIMenuItem.IsDone: Boolean;
begin
  Result := (FTimer2 = -1);
end;

// This method is called to notify the
// control that a key has been clicked.
// If it returns true - the caller will
// receive the control's ID
function THGEGUIMenuItem.KeyClick(const Key, Chr: Integer): Boolean;
begin
  if (Key = HGEK_ENTER) or (Key = HGEK_SPACE) then begin
    MouseLButton(True);
    Result := MouseLButton(False);
  end else
    Result := False;
end;

// This method is called when the GUI
// is about to disappear from the screen
procedure THGEGUIMenuItem.Leave;
var
  TColor2: THGEColor;
begin
  FSColor2.SetHWColor($FFFFE060);
  TColor2.SetHWColor($00FFE060);
  FDColor2 := TColor2 - FSColor2;

  FSShadow.SetHWColor($30000000);
  TColor2.SetHWColor($00000000);
  FDShadow := TColor2 - FSShadow;

  FTimer2 := 0;
end;

// This method is called to notify the control
// that the left mouse button state has changed.
// If it returns true - the caller will receive
// the control's ID
function THGEGUIMenuItem.MouseLButton(const Down: Boolean): Boolean;
begin
  if (not Down) then begin
    FOffset := 4;
    Result := True;
  end else begin
    FSnd.Play;
    FOffset := 0;
    Result := False;
  end;
end;

// This method is called to notify the control
// that the mouse cursor has entered or left it's area
procedure THGEGUIMenuItem.MouseOver(const Over: Boolean);
begin
  inherited;
  if (Over) then
    GUI.SetFocus(Id);
end;

// This method is called when the control should be rendered
procedure THGEGUIMenuItem.Render;
var
  R: PHGERect;
begin
  R := PRect;
  FFont.SetColor(FShadow.GetHWColor);
  FFont.Render(R.X1 + FOffset + 3,R.Y1 + 3,HGETEXT_LEFT,FTitle);
  FFont.SetColor(FColor.GetHWColor);
  FFont.Render(R.X1 - FOffset,R.Y1 - FOffset,HGETEXT_LEFT,FTitle);
end;

// This method is called each frame,
// we should update the animation here
procedure THGEGUIMenuItem.Update(const DT: Single);
begin
  if (FTimer2 <> -1) then begin
    FTimer2 := FTimer2 + DT;
    if (FTimer2 >= FDelay + 0.1) then begin
      FColor := FSColor2 + FDColor2;
      FShadow := FSShadow + FDShadow;
      FOffset := 0;
      FTimer2 := -1;
    end else begin
      if (FTimer2 < FDelay) then begin
        FColor := FSColor2;
        FShadow := FSShadow;
      end else begin
        FColor := FSColor2 + FDColor2 * (FTimer2 - FDelay) * 10;
        FShadow := FSShadow + FDShadow * (FTimer2 - FDelay) * 10;
      end;
    end;
  end else if (FTimer <> -1) then begin
    FTimer := FTimer + DT;
    if (FTimer >= 0.2) then begin
      FColor := FSColor + FDColor;
      FOffset := FSOffset + FDOffset;
      FTimer := -1;
    end else begin
      FColor := FSColor + FDColor * FTimer * 5;
      FOffset := FSOffset + FDOffset * FTimer * 5;
    end;
  end;
end;

end.
