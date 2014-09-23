unit GuiSkins;
//---------------------------------------------------------------------------
// GuiSkins.pas                                         Modified: 03-Mar-2007
// Skinning and colors for Asphyre GUI foundation                 Version 1.0
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
// The Original Code is GuiSkins.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Types, AsphyreXML, AsphyreTypes, AsphyreImages, MediaUtils, GuiTypes;

//---------------------------------------------------------------------------
type
 TSkinDrawType = (sdtNormal, sdtOver, sdtDown, sdtFocused, sdtDisabled);

//---------------------------------------------------------------------------
 TGuiSkin = class
 private
  NormalSkinIndex  : Integer;
  OverSkinIndex    : Integer;
  DownSkinIndex    : Integer;
  FocusedSkinIndex : Integer;
  DisabledSkinIndex: Integer;

  FNormalSkin  : string;
  FNormalRect  : TRect;
  FOverSkin    : string;
  FOverRect    : TRect;
  FDownSkin    : string;
  FDownRect    : TRect;
  FFocusedSkin : string;
  FFocusedRect : TRect;
  FDisabledSkin: string;
  FDisabledRect: TRect;

  procedure SetNormalSkin(const Value: string);
  procedure SetOverSkin(const Value: string);
  procedure SetDownSkin(const Value: string);
  procedure SetFocusedSkin(const Value: string);
  procedure SetDisabledSkin(const Value: string);
  procedure HandleSkin(var SkinIndex: Integer; var Skin: string;
   var Image: TAsphyreCustomImage);
 public
  property NormalSkin: string read FNormalSkin write SetNormalSkin;
  property NormalRect: TRect read FNormalRect write FNormalRect;

  property OverSkin: string read FOverSkin write SetOverSkin;
  property OverRect: TRect read FOverRect write FOverRect;

  property DownSkin: string read FDownSkin write SetDownSkin;
  property DownRect: TRect read FDownRect write FDownRect;

  property FocusedSkin: string read FFocusedSkin write SetFocusedSkin;
  property FocusedRect: TRect read FFocusedRect write FFocusedRect;

  property DisabledSkin: string read FDisabledSkin write SetDisabledSkin;
  property DisabledRect: TRect read FDisabledRect write FDisabledRect;

  function UseImage(DrawType: TSkinDrawType): Boolean;

  procedure Assign(Source: TGuiSkin);
  procedure LoadFromXML(Parent: TXMLNode);

  constructor Create();
 end;

//---------------------------------------------------------------------------
 TGuiFontCol = class
 private
  FNormal  : TColor2;
  FOver    : TColor2;
  FDown    : TColor2;
  FFocused : TColor2;
  FDisabled: TColor2;
 public
  property Normal  : TColor2 read FNormal write FNormal;
  property Over    : TColor2 read FOver write FOver;
  property Down    : TColor2 read FDown write FDown;
  property Focused : TColor2 read FFocused write FFocused;
  property Disabled: TColor2 read FDisabled write FDisabled;

  function UseColor(DrawType: TSkinDrawType): TColor2;

  procedure Assign(Source: TGuiFontCol);
  procedure LoadFromXML(Parent: TXMLNode);

  constructor Create();
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
constructor TGuiSkin.Create();
begin
 inherited;

 FNormalSkin:= '';
 NormalSkinIndex:= -1;
 FOverSkin:= '';
 OverSkinIndex:= -1;
 FDownSkin:= '';
 DownSkinIndex:= -1;
 FFocusedSkin:= '';
 FocusedSkinIndex:= -1;
 FDisabledSkin:= '';
 DisabledSkinIndex:= -1;
end;

//---------------------------------------------------------------------------
procedure TGuiSkin.SetNormalSkin(const Value: string);
begin
 FNormalSkin:= Value;
 NormalSkinIndex:= -1;
end;

//---------------------------------------------------------------------------
procedure TGuiSkin.SetOverSkin(const Value: string);
begin
 FOverSkin:= Value;
 OverSkinIndex:= -1;
end;

//---------------------------------------------------------------------------
procedure TGuiSkin.SetDownSkin(const Value: string);
begin
 FDownSkin:= Value;
 DownSkinIndex:= -1;
end;

//---------------------------------------------------------------------------
procedure TGuiSkin.SetFocusedSkin(const Value: string);
begin
 FFocusedSkin:= Value;
 FocusedSkinIndex:= -1;
end;

//---------------------------------------------------------------------------
procedure TGuiSkin.SetDisabledSkin(const Value: string);
begin
 FDisabledSkin:= Value;
 DisabledSkinIndex:= -1;
end;

//---------------------------------------------------------------------------
procedure TGuiSkin.HandleSkin(var SkinIndex: Integer; var Skin: string;
 var Image: TAsphyreCustomImage);
begin
 // attempt to retreive image by index first
 if (SkinIndex <> -1) then
  begin
   Image := GuiImages[SkinIndex];
   if (Image = nil) then SkinIndex:= -1;
  end else Image:= nil;

 // attempt to retreive Result by name
 if (SkinIndex = -1) then
  begin
   Image:= GuiImages.Image[Skin];
   if (Image = nil) then Skin:= '' else SkinIndex:= Image.ImageIndex;
  end;
end;

//---------------------------------------------------------------------------
function TGuiSkin.UseImage(DrawType: TSkinDrawType): Boolean;
var
 Image: TAsphyreCustomImage;
begin
 case DrawType of
  sdtNormal:
   begin
    HandleSkin(NormalSkinIndex, FNormalSkin, Image);

    Result:= (Image <> nil);
    if (Image <> nil) then
     GuiCanvas.UseImage(Image, pxRect4(FNormalRect));
   end;

  sdtOver:
   begin
    HandleSkin(OverSkinIndex, FOverSkin, Image);

    Result:= (Image <> nil);
    if (Image <> nil) then GuiCanvas.UseImage(Image, pxRect4(FOverRect))
     else Result:= UseImage(sdtNormal);
   end;

  sdtDown:
   begin
    HandleSkin(DownSkinIndex, FDownSkin, Image);

    Result:= (Image <> nil);
    if (Image <> nil) then GuiCanvas.UseImage(Image, pxRect4(FDownRect))
     else Result:= UseImage(sdtNormal);
   end;

  sdtFocused:
   begin
    HandleSkin(FocusedSkinIndex, FFocusedSkin, Image);

    Result:= (Image <> nil);
    if (Image <> nil) then GuiCanvas.UseImage(Image, pxRect4(FFocusedRect))
     else Result:= UseImage(sdtNormal);
   end;

  sdtDisabled:
   begin
    HandleSkin(DisabledSkinIndex, FDisabledSkin, Image);

    Result:= (Image <> nil);
    if (Image <> nil) then GuiCanvas.UseImage(Image, pxRect4(FDisabledRect))
     else Result:= UseImage(sdtNormal);
   end;

  else Result:= False;
 end;
end;

//---------------------------------------------------------------------------
procedure TGuiSkin.Assign(Source: TGuiSkin);
begin
 NormalSkin  := Source.NormalSkin;
 NormalRect  := Source.NormalRect;
 OverSkin    := Source.OverSkin;
 OverRect    := Source.OverRect;
 DownSkin    := Source.DownSkin;
 DownRect    := Source.DownRect;
 FocusedSkin := Source.FocusedSkin;
 FocusedRect := Source.FocusedRect;
 DisabledSkin:= Source.DisabledSkin;
 DisabledRect:= Source.DisabledRect;
end;

//---------------------------------------------------------------------------
procedure TGuiSkin.LoadFromXML(Parent: TXMLNode);
var
 Node: TXMLNode;
begin
 // -> "normal" node
 Node:= Parent.ChildNode['normal'];
 if (Node <> nil) then
  begin
   NormalSkin:= Node.FieldValue['skin'];
   FNormalRect.Left  := ParseInt(Node.FieldValue['left'], 0);
   FNormalRect.Top   := ParseInt(Node.FieldValue['top'], 0);
   FNormalRect.Right := ParseInt(Node.FieldValue['right'], 0);
   FNormalRect.Bottom:= ParseInt(Node.FieldValue['bottom'], 0);

   Inc(FNormalRect.Right);
   Inc(FNormalRect.Bottom);
  end;

 // -> "over" node
 Node:= Parent.ChildNode['over'];
 if (Node <> nil) then
  begin
   OverSkin:= Node.FieldValue['skin'];
   FOverRect.Left  := ParseInt(Node.FieldValue['left'], 0);
   FOverRect.Top   := ParseInt(Node.FieldValue['top'], 0);
   FOverRect.Right := ParseInt(Node.FieldValue['right'], 0);
   FOverRect.Bottom:= ParseInt(Node.FieldValue['bottom'], 0);

   Inc(FOverRect.Right);
   Inc(FOverRect.Bottom);
  end;

 // -> "down" node
 Node:= Parent.ChildNode['down'];
 if (Node <> nil) then
  begin
   DownSkin:= Node.FieldValue['skin'];
   FDownRect.Left  := ParseInt(Node.FieldValue['left'], 0);
   FDownRect.Top   := ParseInt(Node.FieldValue['top'], 0);
   FDownRect.Right := ParseInt(Node.FieldValue['right'], 0);
   FDownRect.Bottom:= ParseInt(Node.FieldValue['bottom'], 0);

   Inc(FDownRect.Right);
   Inc(FDownRect.Bottom);
  end;

 // -> "focused" node
 Node:= Parent.ChildNode['focused'];
 if (Node <> nil) then
  begin
   FocusedSkin:= Node.FieldValue['skin'];
   FFocusedRect.Left  := ParseInt(Node.FieldValue['left'], 0);
   FFocusedRect.Top   := ParseInt(Node.FieldValue['top'], 0);
   FFocusedRect.Right := ParseInt(Node.FieldValue['right'], 0);
   FFocusedRect.Bottom:= ParseInt(Node.FieldValue['bottom'], 0);

   Inc(FFocusedRect.Right);
   Inc(FFocusedRect.Bottom);
  end;

 // -> "disabled" node
 Node:= Parent.ChildNode['disabled'];
 if (Node <> nil) then
  begin
   DisabledSkin:= Node.FieldValue['skin'];
   FDisabledRect.Left  := ParseInt(Node.FieldValue['left'], 0);
   FDisabledRect.Top   := ParseInt(Node.FieldValue['top'], 0);
   FDisabledRect.Right := ParseInt(Node.FieldValue['right'], 0);
   FDisabledRect.Bottom:= ParseInt(Node.FieldValue['bottom'], 0);

   Inc(FDisabledRect.Right);
   Inc(FDisabledRect.Bottom);
  end;
end;

//---------------------------------------------------------------------------
constructor TGuiFontCol.Create();
begin
 inherited;

 FNormal  := clWhite2;
 FOver    := clUnknown2;
 FDown    := clUnknown2;
 FFocused := clUnknown2;
 FDisabled:= clUnknown2;
end;

//---------------------------------------------------------------------------
function TGuiFontCol.UseColor(DrawType: TSkinDrawType): TColor2;
begin
 case DrawType of
  sdtNormal:
   Result:= FNormal;

  sdtOver:
   if (FOver[0] <> clUnknown)or(FOver[1] <> clUnknown) then
    Result:= FOver else Result:= FNormal;

  sdtDown:
   if (FDown[0] <> clUnknown)or(FDown[1] <> clUnknown) then
    Result:= FDown else Result:= FNormal;

  sdtFocused:
   if (FFocused[0] <> clUnknown)or(FFocused[1] <> clUnknown) then
    Result:= FFocused else Result:= FNormal;

  sdtDisabled:
   if (FDisabled[0] <> clUnknown)or(FDisabled[1] <> clUnknown) then
    Result:= FDisabled else Result:= FNormal;
 end;
end;

//---------------------------------------------------------------------------
procedure TGuiFontCol.Assign(Source: TGuiFontCol);
begin
 FNormal  := Source.Normal;
 FOver    := Source.Over;
 FDown    := Source.Down;
 FFocused := Source.Focused;
 FDisabled:= Source.Disabled;
end;

//---------------------------------------------------------------------------
procedure TGuiFontCol.LoadFromXML(Parent: TXMLNode);
var
 Node: TXMLNode;
begin
 // -> "normal" node
 Node:= Parent.ChildNode['normal'];
 if (Node <> nil) then
  FNormal:= ParseColor2Field(Node);

 // -> "over" node
 Node:= Parent.ChildNode['over'];
 if (Node <> nil) then
  FOver:= ParseColor2Field(Node);

 // -> "down" node
 Node:= Parent.ChildNode['down'];
 if (Node <> nil) then
  FDown:= ParseColor2Field(Node);

 // -> "focused" node
 Node:= Parent.ChildNode['focused'];
 if (Node <> nil) then
  FFocused:= ParseColor2Field(Node);

 // -> "disabled" node
 Node:= Parent.ChildNode['disabled'];
 if (Node <> nil) then
  FDisabled:= ParseColor2Field(Node);
end;

//---------------------------------------------------------------------------
end.
