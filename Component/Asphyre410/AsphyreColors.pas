unit AsphyreColors;
//---------------------------------------------------------------------------
// AsphyreColors.pas                                    Modified: 27-Apr-2007
// Fixed-point 24:8 true color implementation                    Version 1.02
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
// The Original Code is AsphyreColors.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// M. Sc. Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Direct3D9;

//---------------------------------------------------------------------------
type
 TAsphyreColor = record
  r, g, b, a: Integer;

  class operator Add(const a, b: TAsphyreColor): TAsphyreColor;
  class operator Subtract(const a, b: TAsphyreColor): TAsphyreColor;
  class operator Multiply(const a, b: TAsphyreColor): TAsphyreColor;
  class operator Divide(const a, b: TAsphyreColor): TAsphyreColor;

  class operator Multiply(const c: TAsphyreColor; k: Integer): TAsphyreColor;
  class operator Divide(const c: TAsphyreColor; k: Integer): TAsphyreColor;
  class operator Multiply(const c: TAsphyreColor; k: Real): TAsphyreColor;
  class operator Divide(const c: TAsphyreColor; k: Real): TAsphyreColor;

  class operator Implicit(const c: TAsphyreColor): Cardinal;
  class operator Implicit(c: Cardinal): TAsphyreColor;
  class operator Explicit(const c: TAsphyreColor): Cardinal;
  class operator Explicit(c: Cardinal): TAsphyreColor;

  class operator Implicit(const c: TAsphyreColor): TD3DColorValue;
  class operator Implicit(const c: TD3DColorValue): TAsphyreColor;
  class operator Explicit(const c: TAsphyreColor): TD3DColorValue;
  class operator Explicit(const c: TD3DColorValue): TAsphyreColor;
 end;

//---------------------------------------------------------------------------
 TAsphyreColor4 = array[0..3] of TAsphyreColor;

//---------------------------------------------------------------------------
function cColor(r, g, b, a: Integer): TAsphyreColor; overload;
function cColor(Gray, Alpha: Integer): TAsphyreColor; overload;
function cColor(Gray: Integer): TAsphyreColor; overload;
function cNoAlpha(const Src: TAsphyreColor): TAsphyreColor;
function cClamp(const c: TAsphyreColor): TAsphyreColor;
function cBlend(const Src, Dest: TAsphyreColor;
 Alpha: Integer): TAsphyreColor;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreUtils, SysUtils;

//---------------------------------------------------------------------------
function Inc8to16(Value: Integer): Integer; inline;
begin
 Result:= (Value * 65535) div 255;
end;

//---------------------------------------------------------------------------
function cColor(r, g, b, a: Integer): TAsphyreColor;
begin
 Result.r:= Inc8to16(r);
 Result.g:= Inc8to16(g);
 Result.b:= Inc8to16(b);
 Result.a:= Inc8to16(a);
end;

//---------------------------------------------------------------------------
function cColor(Gray, Alpha: Integer): TAsphyreColor;
begin
 Result:= cColor(Gray, Gray, Gray, Alpha);
end;

//---------------------------------------------------------------------------
function cColor(Gray: Integer): TAsphyreColor;
begin
 Result:= cColor(Gray, 255);
end;

//---------------------------------------------------------------------------
function cClamp(const c: TAsphyreColor): TAsphyreColor;
begin
 Result.r:= MinMax2(c.r, 0, 65535);
 Result.g:= MinMax2(c.g, 0, 65535);
 Result.b:= MinMax2(c.b, 0, 65535);
 Result.a:= MinMax2(c.a, 0, 65535);
end;

//---------------------------------------------------------------------------
function cBlend(const Src, Dest: TAsphyreColor;
 Alpha: Integer): TAsphyreColor;
begin
 Result.r:= Src.r + iMul8(Dest.r - Src.r, Alpha);
 Result.g:= Src.g + iMul8(Dest.g - Src.g, Alpha);
 Result.b:= Src.b + iMul8(Dest.b - Src.b, Alpha);
 Result.a:= Src.a + iMul8(Dest.a - Src.a, Alpha);
end;

//---------------------------------------------------------------------------
function cNoAlpha(const Src: TAsphyreColor): TAsphyreColor;
begin
 Result.r:= Src.r;
 Result.g:= Src.g;
 Result.b:= Src.b;
 Result.a:= 65535;
end;

//---------------------------------------------------------------------------
class operator TAsphyreColor.Add(const a, b: TAsphyreColor): TAsphyreColor;
begin
 Result.r:= a.r + b.r;
 Result.g:= a.g + b.g;
 Result.b:= a.b + b.b;
 Result.a:= a.a + b.a;
end;

//---------------------------------------------------------------------------
class operator TAsphyreColor.Subtract(const a, b: TAsphyreColor): TAsphyreColor;
begin
 Result.r:= a.r - b.r;
 Result.g:= a.g - b.g;
 Result.b:= a.b - b.b;
 Result.b:= a.a - b.a;
end;

//---------------------------------------------------------------------------
class operator TAsphyreColor.Multiply(const a, b: TAsphyreColor): TAsphyreColor;
begin
 Result.r:= iMul16(a.r, b.r + 1);
 Result.g:= iMul16(a.g, b.g + 1);
 Result.b:= iMul16(a.b, b.b + 1);
 Result.a:= iMul16(a.a, b.a + 1);
end;

//---------------------------------------------------------------------------
class operator TAsphyreColor.Divide(const a, b: TAsphyreColor): TAsphyreColor;
begin
 Result.r:= iDiv16(a.r, b.r);
 Result.g:= iDiv16(a.g, b.g);
 Result.b:= iDiv16(a.b, b.b);
 Result.a:= iDiv16(a.a, b.a);
end;

//---------------------------------------------------------------------------
class operator TAsphyreColor.Multiply(const c: TAsphyreColor;
 k: Integer): TAsphyreColor;
begin
 Result.r:= c.r * k;
 Result.g:= c.g * k;
 Result.b:= c.b * k;
 Result.a:= c.a * k;
end;

//---------------------------------------------------------------------------
class operator TAsphyreColor.Divide(const c: TAsphyreColor;
 k: Integer): TAsphyreColor;
begin
 Result.r:= c.r div k;
 Result.g:= c.g div k;
 Result.b:= c.b div k;
 Result.a:= c.a div k;
end;

//---------------------------------------------------------------------------
class operator TAsphyreColor.Multiply(const c: TAsphyreColor;
 k: Real): TAsphyreColor;
begin
 Result.r:= Round(c.r * k);
 Result.g:= Round(c.g * k);
 Result.b:= Round(c.b * k);
 Result.a:= Round(c.a * k);
end;

//---------------------------------------------------------------------------
class operator TAsphyreColor.Divide(const c: TAsphyreColor;
 k: Real): TAsphyreColor;
begin
 Result.r:= Round(c.r / k);
 Result.g:= Round(c.g / k);
 Result.b:= Round(c.b / k);
 Result.a:= Round(c.a / k);
end;

//---------------------------------------------------------------------------
class operator TAsphyreColor.Implicit(c: Cardinal): TAsphyreColor;
begin
 Result.r:= Inc8to16((c shr 16) and $FF);
 Result.b:= Inc8to16(c and $FF);
 Result.g:= Inc8to16((c shr 8) and $FF);
 Result.a:= Inc8to16((c shr 24) and $FF);
end;

//---------------------------------------------------------------------------
class operator TAsphyreColor.Implicit(const c: TAsphyreColor): Cardinal;
begin
 Result:= (c.b shr 8) or ((c.g shr 8) shl 8) or ((c.r shr 8) shl 16) or
  ((c.a shr 8) shl 24);
end;

//---------------------------------------------------------------------------
class operator TAsphyreColor.Explicit(c: Cardinal): TAsphyreColor;
begin
 Result.r:= Inc8to16((c shr 16) and $FF);
 Result.b:= Inc8to16(c and $FF);
 Result.g:= Inc8to16((c shr 8) and $FF);
 Result.a:= Inc8to16((c shr 24) and $FF);
end;

//---------------------------------------------------------------------------
class operator TAsphyreColor.Explicit(const c: TAsphyreColor): Cardinal;
begin
 Result:= (c.b shr 8) or ((c.g shr 8) shl 8) or ((c.r shr 8) shl 16) or
  ((c.a shr 8) shl 24);
end;

//---------------------------------------------------------------------------
class operator TAsphyreColor.Implicit(const c: TD3DColorValue): TAsphyreColor;
begin
 Result.r:= Round(c.r * 65535.0);
 Result.g:= Round(c.g * 65535.0);
 Result.b:= Round(c.b * 65535.0);
 Result.a:= Round(c.a * 65535.0);
end;

//---------------------------------------------------------------------------
class operator TAsphyreColor.Implicit(const c: TAsphyreColor): TD3DColorValue;
begin
 Result.r:= c.r / 65535.0;
 Result.g:= c.g / 65535.0;
 Result.b:= c.b / 65535.0;
 Result.a:= c.a / 65535.0;
end;

//---------------------------------------------------------------------------
class operator TAsphyreColor.Explicit(const c: TD3DColorValue): TAsphyreColor;
begin
 Result.r:= Round(c.r * 65535);
 Result.g:= Round(c.g * 65535);
 Result.b:= Round(c.b * 65535);
 Result.a:= Round(c.a * 65535);
end;

//---------------------------------------------------------------------------
class operator TAsphyreColor.Explicit(const c: TAsphyreColor): TD3DColorValue;
begin
 Result.r:= c.r / 65535.0;
 Result.g:= c.g / 65535.0;
 Result.b:= c.b / 65535.0;
 Result.a:= c.a / 65535.0;
end;

//---------------------------------------------------------------------------
end.
