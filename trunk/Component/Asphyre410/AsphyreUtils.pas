unit AsphyreUtils;
//---------------------------------------------------------------------------
// AsphyreUtils.pas                                     Modified: 14-Feb-2007
// Asphyre utility routines                                       Version 1.0
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
// The Original Code is AsphyreUtils.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Types, Vectors2px;

//---------------------------------------------------------------------------
// returns True if the given point is within the specified rectangle
//---------------------------------------------------------------------------
function PointInRect(const Point: TPoint2px; const Rect: TRect): Boolean;

//---------------------------------------------------------------------------
// returns True if the given rectangle is within the specified rectangle
//---------------------------------------------------------------------------
function RectInRect(const Rect1, Rect2: TRect): Boolean;

//---------------------------------------------------------------------------
// returns True if the specified rectangles overlap
//---------------------------------------------------------------------------
function OverlapRect(const Rect1, Rect2: TRect): Boolean;

//---------------------------------------------------------------------------
// returns True if the specified point is inside the triangle
//---------------------------------------------------------------------------
function PointInTriangle(const Pos, v1, v2, v3: TPoint2px): Boolean;

//---------------------------------------------------------------------------
// returns the value of Catmull-Rom cubic spline
//---------------------------------------------------------------------------
function CatmullRom(x0, x1, x2, x3, Theta: Real): Real;

//---------------------------------------------------------------------------
function MinMax2(Value, Min, Max: Integer): Integer;
function Min2(a, b: Integer): Integer;
function Max2(a, b: Integer): Integer;
function Min3(a, b, c: Integer): Integer;
function Max3(a, b, c: Integer): Integer;

//---------------------------------------------------------------------------
// Fixed point 24:8 math routines
//---------------------------------------------------------------------------
function iMul8(x, y: Integer): Integer;
function iCeil8(x: Integer): Integer;
function iDiv8(x, y: Integer): Integer;

//---------------------------------------------------------------------------
// Fixed point 16:16 math routines
//---------------------------------------------------------------------------
function iMul16(x, y: Integer): Integer;
function iCeil16(x: Integer): Integer;
function iDiv16(x, y: Integer): Integer;

//---------------------------------------------------------------------------
implementation

//-----------------------------------------------------------------------------
function PointInRect(const Point: TPoint2px; const Rect: TRect): Boolean;
begin
 Result:= (Point.x >= Rect.Left)and(Point.x <= Rect.Right)and
  (Point.y >= Rect.Top)and(Point.y <= Rect.Bottom);
end;

//---------------------------------------------------------------------------
function RectInRect(const Rect1, Rect2: TRect): Boolean;
begin
 Result:= (Rect1.Left >= Rect2.Left)and(Rect1.Right <= Rect2.Right)and
  (Rect1.Top >= Rect2.Top)and(Rect1.Bottom <= Rect2.Bottom);
end;

//---------------------------------------------------------------------------
function OverlapRect(const Rect1, Rect2: TRect): Boolean;
begin
 Result:= (Rect1.Left < Rect2.Right)and(Rect1.Right > Rect2.Left)and
  (Rect1.Top < Rect2.Bottom)and(Rect1.Bottom > Rect2.Top);
end;

//---------------------------------------------------------------------------
function PointInTriangle(const Pos, v1, v2, v3: TPoint2px): Boolean;
var
 Aux: Integer;
begin
 Aux:= (Pos.y - v2.y) * (v3.x - v2.x) - (Pos.x - v2.x) * (v3.y - v2.y);

 Result:= (Aux * ((Pos.y - v1.y) * (v2.x - v1.x) - (Pos.x - v1.x) *
  (v2.y - v1.y)) > 0)and(Aux * ((Pos.y - v3.y) * (v1.x - v3.x) - (Pos.x -
  v3.x) * (v1.y - v3.y)) > 0);
end;

//---------------------------------------------------------------------------
function CatmullRom(x0, x1, x2, x3, Theta: Real): Real;
begin
 Result:= 0.5 * ((2.0 * x1) + Theta * (-x0 + x2 + Theta * (2.0 * x0 - 5.0 *
  x1 + 4.0 * x2 - x3 + Theta * (-x0 + 3.0 * x1 - 3.0 * x2 + x3))));
end;

//---------------------------------------------------------------------------
function MinMax2(Value, Min, Max: Integer): Integer;
asm { params: eax, edx, ecx }
 cmp eax, edx
 cmovl eax, edx
 cmp eax, ecx
 cmovg eax, ecx
end;

//---------------------------------------------------------------------------
function Min2(a, b: Integer): Integer;
asm { params: eax, edx }
 cmp   edx, eax
 cmovl eax, edx
end;

//---------------------------------------------------------------------------
function Max2(a, b: Integer): Integer;
asm { params: eax, edx }
 cmp   edx, eax
 cmovg eax, edx
end;

//---------------------------------------------------------------------------
function Min3(a, b, c: Integer): Integer;
asm { params: eax, edx, ecx }
 cmp   edx, eax
 cmovl eax, edx
 cmp   ecx, eax
 cmovl eax, ecx
end;

//---------------------------------------------------------------------------
function Max3(a, b, c: Integer): Integer;
asm { params: eax, edx, ecx }
 cmp   edx, eax
 cmovg eax, edx
 cmp   ecx, eax
 cmovg eax, ecx
end;

//---------------------------------------------------------------------------
function iMul8(x, y: Integer): Integer;
asm { params: eax, edx }
 imul edx
 shrd eax, edx, 8
end;

//---------------------------------------------------------------------------
function iCeil8(x: Integer): Integer;
asm
 add eax, $FF
 sar eax, 8
end;

//---------------------------------------------------------------------------
function iDiv8(x, y: Integer): Integer;
asm { params: eax, edx }
 mov ecx, edx
 mov edx, eax
 sar edx, 24
 shl eax, 8
 idiv ecx
end;

//---------------------------------------------------------------------------
function iMul16(x, y: Integer): Integer;
asm { params: eax, edx }
 imul edx
 shrd eax, edx, 16
end;

//---------------------------------------------------------------------------
function iCeil16(x: Integer): Integer;
asm
 add eax, $FFFF
 sar eax, 16
end;

//---------------------------------------------------------------------------
function iDiv16(x, y: Integer): Integer;
asm { params: eax, edx }
 mov ecx, edx
 mov edx, eax
 sar edx, 16
 shl eax, 16
 idiv ecx
end;

//---------------------------------------------------------------------------
end.
