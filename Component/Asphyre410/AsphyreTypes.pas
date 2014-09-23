unit AsphyreTypes;
//---------------------------------------------------------------------------
// AsphyreTypes.pas                                     Modified: 19-Feb-2007
// Asphyre types definitions                                      Version 1.0
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
// The Original Code is AsphyreTypes.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
{$include Asphyre4.inc}

//---------------------------------------------------------------------------
uses
 Types, Vectors2, AsphyreColors;

//---------------------------------------------------------------------------
type
 THorizontalAlign = (haLeft, haRight, haCenter, haJustified);
 TVerticalAlign   = (vaTop, vaBottom, vaCenter);

//---------------------------------------------------------------------------
 TAntialiasType = (atNone, atNormal, atBest);

//---------------------------------------------------------------------------
 TMipmappingType = (mtNone, mtSingle, mtSmooth);

//---------------------------------------------------------------------------
 PColor2 = ^TColor2;
 TColor2 = array[0..1] of Cardinal;

//---------------------------------------------------------------------------
 PColor4 = ^TColor4;
 TColor4 = array[0..3] of Cardinal;

//---------------------------------------------------------------------------
 PPoint4 = ^TPoint4;
 TPoint4 = array[0..3] of TPoint2;

//---------------------------------------------------------------------------
 PPoint4px = ^TPoint4px;
 TPoint4px = array[0..3] of TPoint;

//---------------------------------------------------------------------------
const
 clWhite1  : Cardinal = $FFFFFFFF;
 clBlack1  : Cardinal = $FF000000;
 clMaroon1 : Cardinal = $FF800000;
 clGreen1  : Cardinal = $FF008000;
 clOlive1  : Cardinal = $FF808000;
 clNavy1   : Cardinal = $FF000080;
 clPurple1 : Cardinal = $FF800080;
 clTeal1   : Cardinal = $FF008080;
 clGray1   : Cardinal = $FF808080;
 clSilver1 : Cardinal = $FFC0C0C0;
 clRed1    : Cardinal = $FFFF0000;
 clLime1   : Cardinal = $FF00FF00;
 clYellow1 : Cardinal = $FFFFFF00;
 clBlue1   : Cardinal = $FF0000FF;
 clFuchsia1: Cardinal = $FFFF00FF;
 clAqua1   : Cardinal = $FF00FFFF;
 clLtGray1 : Cardinal = $FFC0C0C0;
 clDkGray1 : Cardinal = $FF808080;
 clOpaque1 : Cardinal = $00FFFFFF;
 clUnknown : Cardinal = $00000000;

//---------------------------------------------------------------------------
 clWhite2  : TColor2 = ($FFFFFFFF, $FFFFFFFF);
 clBlack2  : TColor2 = ($FF000000, $FF000000);
 clMaroon2 : TColor2 = ($FF800000, $FF800000);
 clGreen2  : TColor2 = ($FF008000, $FF008000);
 clOlive2  : TColor2 = ($FF808000, $FF808000);
 clNavy2   : TColor2 = ($FF000080, $FF000080);
 clPurple2 : TColor2 = ($FF800080, $FF800080);
 clTeal2   : TColor2 = ($FF008080, $FF008080);
 clGray2   : TColor2 = ($FF808080, $FF808080);
 clSilver2 : TColor2 = ($FFC0C0C0, $FFC0C0C0);
 clRed2    : TColor2 = ($FFFF0000, $FFFF0000);
 clLime2   : TColor2 = ($FF00FF00, $FF00FF00);
 clYellow2 : TColor2 = ($FFFFFF00, $FFFFFF00);
 clBlue2   : TColor2 = ($FF0000FF, $FF0000FF);
 clFuchsia2: TColor2 = ($FFFF00FF, $FFFF00FF);
 clAqua2   : TColor2 = ($FF00FFFF, $FF00FFFF);
 clLtGray2 : TColor2 = ($FFC0C0C0, $FFC0C0C0);
 clDkGray2 : TColor2 = ($FF808080, $FF808080);
 clOpaque2 : TColor2 = ($00FFFFFF, $00FFFFFF);
 clUnknown2: TColor2 = ($00000000, $00000000);

//---------------------------------------------------------------------------
 clWhite4  : TColor4 = ($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF);
 clBlack4  : TColor4 = ($FF000000, $FF000000, $FF000000, $FF000000);
 clMaroon4 : TColor4 = ($FF800000, $FF800000, $FF800000, $FF800000);
 clGreen4  : TColor4 = ($FF008000, $FF008000, $FF008000, $FF008000);
 clOlive4  : TColor4 = ($FF808000, $FF808000, $FF808000, $FF808000);
 clNavy4   : TColor4 = ($FF000080, $FF000080, $FF000080, $FF000080);
 clPurple4 : TColor4 = ($FF800080, $FF800080, $FF800080, $FF800080);
 clTeal4   : TColor4 = ($FF008080, $FF008080, $FF008080, $FF008080);
 clGray4   : TColor4 = ($FF808080, $FF808080, $FF808080, $FF808080);
 clSilver4 : TColor4 = ($FFC0C0C0, $FFC0C0C0, $FFC0C0C0, $FFC0C0C0);
 clRed4    : TColor4 = ($FFFF0000, $FFFF0000, $FFFF0000, $FFFF0000);
 clLime4   : TColor4 = ($FF00FF00, $FF00FF00, $FF00FF00, $FF00FF00);
 clYellow4 : TColor4 = ($FFFFFF00, $FFFFFF00, $FFFFFF00, $FFFFFF00);
 clBlue4   : TColor4 = ($FF0000FF, $FF0000FF, $FF0000FF, $FF0000FF);
 clFuchsia4: TColor4 = ($FFFF00FF, $FFFF00FF, $FFFF00FF, $FFFF00FF);
 clAqua4   : TColor4 = ($FF00FFFF, $FF00FFFF, $FF00FFFF, $FF00FFFF);
 clLtGray4 : TColor4 = ($FFC0C0C0, $FFC0C0C0, $FFC0C0C0, $FFC0C0C0);
 clDkGray4 : TColor4 = ($FF808080, $FF808080, $FF808080, $FF808080);
 clOpaque4 : TColor4 = ($00FFFFFF, $00FFFFFF, $00FFFFFF, $00FFFFFF);
 clUnknown4: TColor4 = ($00000000, $00000000, $00000000, $00000000);

//---------------------------------------------------------------------------
 TexFull4: TPoint4 = ((x: 0.0; y: 0.0), (x: 1.0; y: 0.0), (x: 1.0; y: 1.0),
  (x: 0.0; y: 1.0));
 TexZero4px: TPoint4px = ((x: 0; y: 0), (x: 0; y: 0), (x: 0; y: 0),
  (x: 0; y: 0));

//---------------------------------------------------------------------------
function cRGB1(r, g, b: Cardinal; a: Cardinal = 255): Cardinal;
function cGray1(Gray: Cardinal): Cardinal;
function cAlpha1(Alpha: Cardinal): Cardinal;
function cColorAlpha1(Color, Alpha: Cardinal): Cardinal;
function cColorGrayAlpha1(Color, Gray, Alpha: Cardinal): Cardinal;

//---------------------------------------------------------------------------
function cColor2(Color0, Color1: Cardinal): TColor2; overload;
function cColor2(Color: Cardinal): TColor2; overload;
function cRGB2(r, g, b: Cardinal; a: Cardinal = 255): TColor2; overload;
function cRGB2(r1, g1, b1, a1, r2, g2, b2, a2: Cardinal): TColor2; overload;
function cGray2(Gray: Cardinal): TColor2; overload;
function cGray2(Gray1, Gray2: Cardinal): TColor2; overload;
function cAlpha2(Alpha: Cardinal): TColor2; overload;
function cAlpha2(Alpha1, Alpha2: Cardinal): TColor2; overload;
function cColorAlpha2(Color, Alpha: Cardinal): TColor2; overload;
function cColorAlpha2(Color1, Color2, Alpha1, Alpha2: Cardinal): TColor2; overload;

//---------------------------------------------------------------------------
function cColor4(Color: Cardinal): TColor4; overload;
function cColor4(Color1, Color2, Color3, Color4: Cardinal): TColor4; overload;
function cRGB4(r, g, b: Cardinal; a: Cardinal = 255): TColor4; overload;
function cRGB4(r1, g1, b1, a1, r2, g2, b2, a2: Cardinal): TColor4; overload;
function cGray4(Gray: Cardinal): TColor4; overload;
function cGray4(Gray1, Gray2, Gray3, Gray4: Cardinal): TColor4; overload;
function cAlpha4(Alpha: Cardinal): TColor4; overload;
function cAlpha4(Alpha1, Alpha2, Alpha3, Alpha4: Cardinal): TColor4; overload;
function cGrayAlpha4(Gray, Alpha: Cardinal): TColor4; overload;
function cGrayAlpha4(Gray1, Gray2, Gray3, Gray4, Alpha1, Alpha2, Alpha3,
 Alpha4: Cardinal): TColor4; overload;
function cColorAlpha4(Color, Alpha: Cardinal): TColor4; overload;
function cColorAlpha4(Color1, Color2, Color3, Color4, Alpha1, Alpha2, Alpha3,
 Alpha4: Cardinal): TColor4; overload;
function cColorGrayAlpha4(Color, Gray, Alpha: Cardinal): TColor4; overload;
function cColorGrayAlpha4(Color1, Color2, Color3, Color4,
 Gray1, Gray2, Gray3, Gray4, Alpha1, Alpha2, Alpha3,
 Alpha4: Cardinal): TColor4; overload;

//---------------------------------------------------------------------------
function ColorToFixed4(const Colors: TColor4): TAsphyreColor4;
function FixedToColor4(const Colors: TAsphyreColor4): TColor4;

//---------------------------------------------------------------------------
// Point4 helper routines
//---------------------------------------------------------------------------
// point values -> TPoint4
function Point4(x1, y1, x2, y2, x3, y3, x4, y4: Real): TPoint4; overload;
function Point4(const p1, p2, p3, p4: TPoint2): TPoint4; overload;
// rectangle coordinates -> TPoint4
function pRect4(const Rect: TRect): TPoint4;
// rectangle coordinates -> TPoint4
function pBounds4(_Left, _Top, _Width, _Height: Real): TPoint4;
// rectangle coordinates, scaled -> TPoint4
function pBounds4s(_Left, _Top, _Width, _Height, Theta: Real): TPoint4;
// rectangle coordinates, scaled / centered -> TPoint4
function pBounds4sc(_Left, _Top, _Width, _Height, Theta: Real): TPoint4;
// mirrors the coordinates
function pMirror4(const Point4: TPoint4): TPoint4;
// flips the coordinates
function pFlip4(const Point4: TPoint4): TPoint4;
// shift the given points by the specified amount
function pShift4(const Points: TPoint4; const ShiftBy: TPoint2): TPoint4;
// rotated rectangle (Origin + Size) around (Middle) with Angle and Scale
function pRotate4(const Origin, Size, Middle: TPoint2; Angle: Real;
 Theta: Real = 1.0): TPoint4;
function pRotate4se(const Origin, Size, Middle: TPoint2; Angle: Real;
 Theta: Real = 1.0): TPoint4;
function pRotate4c(const Origin, Size: TPoint2; Angle: Real;
 Theta: Real = 1.0): TPoint4;

//---------------------------------------------------------------------------
function pxBounds4(Left, Top, Width, Height: Integer): TPoint4px;
function pxRect4(Left, Top, Right, Bottom: Integer): TPoint4px; overload;
function pxRect4(const Rect: TRect): TPoint4px; overload;
function pxRotate90r(const Points: TPoint4px): TPoint4px;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
function cRGB1(r, g, b: Cardinal; a: Cardinal = 255): Cardinal;
begin
 Result:= r or (g shl 8) or (b shl 16) or (a shl 24);
end;

//---------------------------------------------------------------------------
function cGray1(Gray: Cardinal): Cardinal;
begin
 Result:= ((Gray and $FF) or ((Gray and $FF) shl 8) or ((Gray and $FF) shl 16))
  or $FF000000;
end;

//---------------------------------------------------------------------------
function cAlpha1(Alpha: Cardinal): Cardinal;
begin
 Result:= $FFFFFF or ((Alpha and $FF) shl 24);
end;

//---------------------------------------------------------------------------
function cColorAlpha1(Color, Alpha: Cardinal): Cardinal;
begin
 Result:= TAsphyreColor(Color) * TAsphyreColor(cAlpha1(Alpha));
end;

//---------------------------------------------------------------------------
function cColorGrayAlpha1(Color, Gray, Alpha: Cardinal): Cardinal;
begin
 Result:= TAsphyreColor(Color) * cColor(Gray, Gray, Gray, Alpha);
end;

//---------------------------------------------------------------------------
function cColor2(Color0, Color1: Cardinal): TColor2;
begin
 Result[0]:= Color0;
 Result[1]:= Color1;
 end;

//---------------------------------------------------------------------------
function cColor2(Color: Cardinal): TColor2;
begin
 Result[0]:= Color;
 Result[1]:= Color;
end;

//---------------------------------------------------------------------------
function cRGB2(r1, g1, b1, a1, r2, g2, b2, a2: Cardinal): TColor2; overload;
begin
 Result[0]:= cRGB1(r1, g1, b1, a1);
 Result[1]:= cRGB1(r1, g1, b1, a1);
end;

//---------------------------------------------------------------------------
function cRGB2(r, g, b: Cardinal; a: Cardinal = 255): TColor2; overload;
begin
 Result[0]:= cRGB1(r, g, b, a);
 Result[1]:= Result[0];
end;

//---------------------------------------------------------------------------
function cGray2(Gray: Cardinal): TColor2;
begin
 Result:= cColor2(((Gray and $FF) or ((Gray and $FF) shl 8) or
  ((Gray and $FF) shl 16)) or $FF000000);
end;

//---------------------------------------------------------------------------
function cGray2(Gray1, Gray2: Cardinal): TColor2;
begin
 Result[0]:= ((Gray1 and $FF) or ((Gray1 and $FF) shl 8) or
  ((Gray1 and $FF) shl 16)) or $FF000000;
 Result[1]:= ((Gray2 and $FF) or ((Gray2 and $FF) shl 8) or
  ((Gray2 and $FF) shl 16)) or $FF000000;
end;

//---------------------------------------------------------------------------
function cAlpha2(Alpha: Cardinal): TColor2;
begin
 Result:= cColor2($FFFFFF or ((Alpha and $FF) shl 24));
end;

//---------------------------------------------------------------------------
function cAlpha2(Alpha1, Alpha2: Cardinal): TColor2;
begin
 Result[0]:= $FFFFFF or ((Alpha1 and $FF) shl 24);
 Result[1]:= $FFFFFF or ((Alpha2 and $FF) shl 24);
end;

//---------------------------------------------------------------------------
function cColorAlpha2(Color, Alpha: Cardinal): TColor2; overload;
begin
 Result:= cColor2((Color and $FFFFFF) or ((Alpha and $FF) shl 24));
end;

//---------------------------------------------------------------------------
function cColorAlpha2(Color1, Color2, Alpha1, Alpha2: Cardinal): TColor2;
begin
 Result[0]:= cColorAlpha1(Color1, Alpha1);
 Result[1]:= cColorAlpha1(Color2, Alpha2);
end;

//---------------------------------------------------------------------------
function cColor4(Color: Cardinal): TColor4;
begin
 Result[0]:= Color;
 Result[1]:= Color;
 Result[2]:= Color;
 Result[3]:= Color;
end;

//---------------------------------------------------------------------------
function cColor4(Color1, Color2, Color3, Color4: Cardinal): TColor4;
begin
 Result[0]:= Color1;
 Result[1]:= Color2;
 Result[2]:= Color3;
 Result[3]:= Color4;
end;

//---------------------------------------------------------------------------
function cRGB4(r, g, b: Cardinal; a: Cardinal = 255): TColor4;
begin
 Result:= cColor4(cRGB1(r, g, b, a));
end;

//---------------------------------------------------------------------------
function cRGB4(r1, g1, b1, a1, r2, g2, b2, a2: Cardinal): TColor4;
begin
 Result[0]:= cRGB1(r1, g1, b1, a1);
 Result[1]:= Result[0];
 Result[2]:= cRGB1(r2, g2, b2, a2);
 Result[3]:= Result[2];
end;

//---------------------------------------------------------------------------
function cGray4(Gray: Cardinal): TColor4;
begin
 Result:= cColor4(((Gray and $FF) or ((Gray and $FF) shl 8) or
  ((Gray and $FF) shl 16)) or $FF000000);
end;

//---------------------------------------------------------------------------
function cGray4(Gray1, Gray2, Gray3, Gray4: Cardinal): TColor4;
begin
 Result[0]:= ((Gray1 and $FF) or ((Gray1 and $FF) shl 8) or ((Gray1 and $FF)
  shl 16)) or $FF000000;
 Result[1]:= ((Gray2 and $FF) or ((Gray2 and $FF) shl 8) or ((Gray2 and $FF)
  shl 16)) or $FF000000;
 Result[2]:= ((Gray3 and $FF) or ((Gray3 and $FF) shl 8) or ((Gray3 and $FF)
  shl 16)) or $FF000000;
 Result[3]:= ((Gray4 and $FF) or ((Gray4 and $FF) shl 8) or ((Gray4 and $FF)
  shl 16)) or $FF000000;
end;

//---------------------------------------------------------------------------
function cAlpha4(Alpha: Cardinal): TColor4;
begin
 Result:= cColor4($FFFFFF or ((Alpha and $FF) shl 24));
end;

//---------------------------------------------------------------------------
function cAlpha4(Alpha1, Alpha2, Alpha3, Alpha4: Cardinal): TColor4;
begin
 Result[0]:= $FFFFFF or ((Alpha1 and $FF) shl 24);
 Result[1]:= $FFFFFF or ((Alpha2 and $FF) shl 24);
 Result[2]:= $FFFFFF or ((Alpha3 and $FF) shl 24);
 Result[3]:= $FFFFFF or ((Alpha4 and $FF) shl 24);
end;

//---------------------------------------------------------------------------
function cGrayAlpha4(Gray, Alpha: Cardinal): TColor4;
begin
 Result:= cColor4(((Gray and $FF) or ((Gray and $FF) shl 8) or
  ((Gray and $FF) shl 16)) or (Alpha shl 24));
end;

//---------------------------------------------------------------------------
function cGrayAlpha4(Gray1, Gray2, Gray3, Gray4, Alpha1, Alpha2, Alpha3,
 Alpha4: Cardinal): TColor4;
begin
 Result[0]:= ((Gray1 and $FF) or ((Gray1 and $FF) shl 8) or ((Gray1 and $FF)
  shl 16)) or (Alpha1 shl 24);
 Result[1]:= ((Gray2 and $FF) or ((Gray2 and $FF) shl 8) or ((Gray2 and $FF)
  shl 16)) or (Alpha2 shl 24);
 Result[2]:= ((Gray3 and $FF) or ((Gray3 and $FF) shl 8) or ((Gray3 and $FF)
  shl 16)) or (Alpha3 shl 24);
 Result[3]:= ((Gray4 and $FF) or ((Gray4 and $FF) shl 8) or ((Gray4 and $FF)
  shl 16)) or (Alpha4 shl 24);
end;

//---------------------------------------------------------------------------
function cColorAlpha4(Color, Alpha: Cardinal): TColor4; overload;
begin
 Result:= cColor4(cColorAlpha1(Color, Alpha));
end;

//---------------------------------------------------------------------------
function cColorAlpha4(Color1, Color2, Color3, Color4, Alpha1, Alpha2, Alpha3,
 Alpha4: Cardinal): TColor4;
begin
 Result[0]:= cColorAlpha1(Color1, Alpha1);
 Result[1]:= cColorAlpha1(Color2, Alpha2);
 Result[2]:= cColorAlpha1(Color3, Alpha3);
 Result[3]:= cColorAlpha1(Color4, Alpha4);
end;

//---------------------------------------------------------------------------
function cColorGrayAlpha4(Color, Gray, Alpha: Cardinal): TColor4; overload;
begin
 Result:= cColor4(cColorGrayAlpha1(Color, Gray, Alpha));
end;

//---------------------------------------------------------------------------
function cColorGrayAlpha4(Color1, Color2, Color3, Color4,
 Gray1, Gray2, Gray3, Gray4, Alpha1, Alpha2, Alpha3,
 Alpha4: Cardinal): TColor4; overload;
begin
 Result[0]:= cColorGrayAlpha1(Color1, Gray1, Alpha1);
 Result[1]:= cColorGrayAlpha1(Color2, Gray2, Alpha2);
 Result[2]:= cColorGrayAlpha1(Color3, Gray3, Alpha3);
 Result[3]:= cColorGrayAlpha1(Color4, Gray4, Alpha4);
end;

//---------------------------------------------------------------------------
function ColorToFixed4(const Colors: TColor4): TAsphyreColor4;
begin
 Result[0]:= Colors[0];
 Result[1]:= Colors[1];
 Result[2]:= Colors[2];
 Result[3]:= Colors[3];
end;

//---------------------------------------------------------------------------
function FixedToColor4(const Colors: TAsphyreColor4): TColor4;
begin
 Result[0]:= Colors[0];
 Result[1]:= Colors[1];
 Result[2]:= Colors[2];
 Result[3]:= Colors[3];
end;

//---------------------------------------------------------------------------
function Point4(x1, y1, x2, y2, x3, y3, x4, y4: Real): TPoint4;
begin
 Result[0].x:= x1;
 Result[0].y:= y1;
 Result[1].x:= x2;
 Result[1].y:= y2;
 Result[2].x:= x3;
 Result[2].y:= y3;
 Result[3].x:= x4;
 Result[3].y:= y4;
end;

//---------------------------------------------------------------------------
function Point4(const p1, p2, p3, p4: TPoint2): TPoint4;
begin
 Result:= Point4(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x, p4.y);
end;

//---------------------------------------------------------------------------
function pRect4(const Rect: TRect): TPoint4;
begin
 Result[0].x:= Rect.Left;
 Result[0].y:= Rect.Top;
 Result[1].x:= Rect.Right;
 Result[1].y:= Rect.Top;
 Result[2].x:= Rect.Right;
 Result[2].y:= Rect.Bottom;
 Result[3].x:= Rect.Left;
 Result[3].y:= Rect.Bottom;
end;

//---------------------------------------------------------------------------
function pBounds4(_Left, _Top, _Width, _Height: Real): TPoint4;
begin
 Result[0].X:= _Left;
 Result[0].Y:= _Top;
 Result[1].X:= _Left + _Width;
 Result[1].Y:= _Top;
 Result[2].X:= _Left + _Width;
 Result[2].Y:= _Top + _Height;
 Result[3].X:= _Left;
 Result[3].Y:= _Top + _Height;
end;

//---------------------------------------------------------------------------
function pBounds4s(_Left, _Top, _Width, _Height, Theta: Real): TPoint4;
begin
 Result:= pBounds4(_Left, _Top, Round(_Width * Theta), Round(_Height * Theta));
end;

//---------------------------------------------------------------------------
function pBounds4sc(_Left, _Top, _Width, _Height, Theta: Real): TPoint4;
var
 Left, Top: Real;
 Width, Height: Real;
begin
 if (Theta = 1.0) then
  Result:= pBounds4(_Left, _Top, _Width, _Height)
 else
  begin
   Width := _Width * Theta;
   Height:= _Height * Theta;
   Left  := _Left + ((_Width - Width) * 0.5);
   Top   := _Top + ((_Height - Height) * 0.5);
   Result:= pBounds4(Left, Top, Round(Width), Round(Height));
  end;
end;

//---------------------------------------------------------------------------
function pMirror4(const Point4: TPoint4): TPoint4;
begin
 Result[0].X:= Point4[1].X;
 Result[0].Y:= Point4[0].Y;
 Result[1].X:= Point4[0].X;
 Result[1].Y:= Point4[1].Y;
 Result[2].X:= Point4[3].X;
 Result[2].Y:= Point4[2].Y;
 Result[3].X:= Point4[2].X;
 Result[3].Y:= Point4[3].Y;
end;

//---------------------------------------------------------------------------
function pFlip4(const Point4: TPoint4): TPoint4;
begin
 Result[0].X:= Point4[0].X;
 Result[0].Y:= Point4[2].Y;
 Result[1].X:= Point4[1].X;
 Result[1].Y:= Point4[3].Y;
 Result[2].X:= Point4[2].X;
 Result[2].Y:= Point4[0].Y;
 Result[3].X:= Point4[3].X;
 Result[3].Y:= Point4[1].Y;
end;

//---------------------------------------------------------------------------
function pShift4(const Points: TPoint4; const ShiftBy: TPoint2): TPoint4;
begin
 Result[0].x:= Points[0].x + ShiftBy.x;
 Result[0].y:= Points[0].y + ShiftBy.y;
 Result[1].x:= Points[1].x + ShiftBy.x;
 Result[1].y:= Points[1].y + ShiftBy.y;
 Result[2].x:= Points[2].x + ShiftBy.x;
 Result[2].y:= Points[2].y + ShiftBy.y;
 Result[3].x:= Points[3].x + ShiftBy.x;
 Result[3].y:= Points[3].y + ShiftBy.y;
end;

//---------------------------------------------------------------------------
function pRotate4(const Origin, Size, Middle: TPoint2; Angle: Real;
 Theta: Real): TPoint4;
var
 CosPhi: Real;
 SinPhi: Real;
 Index : Integer;
 Points: TPoint4;
 Point : TPoint2;
begin
 CosPhi:= Cos(Angle);
 SinPhi:= Sin(Angle);

 // create 4 points centered at (0, 0)
 Points:= pBounds4(-Middle.x, -Middle.y, Size.x, Size.y);

 // process the created points
 for Index:= 0 to 3 do
  begin
   // scale the point
   Points[Index].x:= Points[Index].x * Theta;
   Points[Index].y:= Points[Index].y * Theta;

   // rotate the point around Phi
   Point.x:= (Points[Index].x * CosPhi) - (Points[Index].y * SinPhi);
   Point.y:= (Points[Index].y * CosPhi) + (Points[Index].x * SinPhi);

   // translate the point to (Origin)
   Points[Index].x:= Point.x + Origin.x;
   Points[Index].y:= Point.y + Origin.y;
  end;

 Result:= Points;
end;

//---------------------------------------------------------------------------
function pRotate4se(const Origin, Size, Middle: TPoint2; Angle: Real;
 Theta: Real): TPoint4;
var
 CosPhi: Real;
 SinPhi: Real;
 Index : Integer;
 Points: TPoint4;
 Point : TPoint2;
begin
 CosPhi:= Cos(Angle);
 SinPhi:= Sin(Angle);

 // create 4 points centered at (0, 0)
 Points:= pBounds4(-Middle.x, -Middle.y, Size.x, Size.y);

 // process the created points
 for Index:= 0 to 3 do
  begin
   // scale the point
   Points[Index].x:= Points[Index].x * Theta;
   Points[Index].y:= Points[Index].y * Theta;

   // rotate the point around Phi
   Point.x:= (Points[Index].x * CosPhi) - (Points[Index].y * SinPhi);
   Point.y:= (Points[Index].y * CosPhi) + (Points[Index].x * SinPhi);

   // translate the point to (Origin)
   Points[Index].x:= Point.x + Origin.x + Middle.x;
   Points[Index].y:= Point.y + Origin.y + Middle.y;
  end;

 Result:= Points;
end;

//---------------------------------------------------------------------------
function pRotate4c(const Origin, Size: TPoint2; Angle: Real;
 Theta: Real): TPoint4;
begin
 Result:= pRotate4(Origin, Size, Point2(Size.x * 0.5, Size.y * 0.5), Angle,
  Theta);
end;

//-----------------------------------------------------------------------------
function pxBounds4(Left, Top, Width, Height: Integer): TPoint4px;
begin
 Result[0].X:= Left;
 Result[0].Y:= Top;
 Result[1].X:= Left + Width;
 Result[1].Y:= Top;
 Result[2].X:= Left + Width;
 Result[2].Y:= Top + Height;
 Result[3].X:= Left;
 Result[3].Y:= Top + Height;
end;

//-----------------------------------------------------------------------------
function pxRect4(Left, Top, Right, Bottom: Integer): TPoint4px;
begin
 Result[0].X:= Left;
 Result[0].Y:= Top;
 Result[1].X:= Right;
 Result[1].Y:= Top;
 Result[2].X:= Right;
 Result[2].Y:= Bottom;
 Result[3].X:= Left;
 Result[3].Y:= Bottom;
end;

//---------------------------------------------------------------------------
function pxRect4(const Rect: TRect): TPoint4px; overload;
begin
 Result:= pxRect4(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom);
end;

//---------------------------------------------------------------------------
function pxRotate90r(const Points: TPoint4px): TPoint4px;
begin
 Result[0]:= Points[3];
 Result[1]:= Points[0];
 Result[2]:= Points[1];
 Result[3]:= Points[2];
end;

//---------------------------------------------------------------------------
end.
