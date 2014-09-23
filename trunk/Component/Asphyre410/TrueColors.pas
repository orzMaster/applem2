unit TrueColors;

//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Direct3D9, AsphyreTypes;

//---------------------------------------------------------------------------
type
 TTrueColor = record
  r, g, b, a: Single;

  class operator Add(const a, b: TTrueColor): TTrueColor;
  class operator Subtract(const a, b: TTrueColor): TTrueColor;
  class operator Multiply(const a, b: TTrueColor): TTrueColor;
  class operator Divide(const a, b: TTrueColor): TTrueColor;

  class operator Multiply(const c: TTrueColor; const k: Single): TTrueColor;
  class operator Divide(const c: TTrueColor; const k: Single): TTrueColor;

  class operator Implicit(const c: TTrueColor): Cardinal;
  class operator Implicit(c: Cardinal): TTrueColor;
  class operator Explicit(const c: TTrueColor): TD3DColorValue;

  procedure ClampMax();
  procedure ClampMin();
  procedure Clamp();
 end;

//---------------------------------------------------------------------------
 TTrueColor4 = array[0..3] of TTrueColor;

//---------------------------------------------------------------------------
function TrueColor(r, g, b, a: Single): TTrueColor;
function TrueColor4to4(const Colors: TColor4): TTrueColor4;
function AlphaBlendTC(const c1, c2: TTrueColor; Alpha: Single): TTrueColor;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
class operator TTrueColor.Add(const a, b: TTrueColor): TTrueColor;
begin
 Result.r:= a.r + b.r;
 Result.g:= a.g + b.g;
 Result.b:= a.b + b.b;
 Result.a:= a.a + b.a;
end;

//---------------------------------------------------------------------------
class operator TTrueColor.Subtract(const a, b: TTrueColor): TTrueColor;
begin
 Result.r:= a.r - b.r;
 Result.g:= a.g - b.g;
 Result.b:= a.b - b.b;
 Result.a:= a.a - b.a;
end;

//---------------------------------------------------------------------------
class operator TTrueColor.Multiply(const a, b: TTrueColor): TTrueColor;
begin
 Result.r:= a.r * b.r;
 Result.g:= a.g * b.g;
 Result.b:= a.b * b.b;
 Result.a:= a.a * b.a;
end;

//---------------------------------------------------------------------------
class operator TTrueColor.Divide(const a, b: TTrueColor): TTrueColor;
begin
 Result.r:= a.r / b.r;
 Result.g:= a.g / b.g;
 Result.b:= a.b / b.b;
 Result.a:= a.a / b.a;
end;

//---------------------------------------------------------------------------
class operator TTrueColor.Multiply(const c: TTrueColor;
 const k: Single): TTrueColor;
begin
 Result.r:= c.r * k;
 Result.g:= c.g * k;
 Result.b:= c.b * k;
 Result.a:= c.a * k;
end;

//---------------------------------------------------------------------------
class operator TTrueColor.Divide(const c: TTrueColor;
 const k: Single): TTrueColor;
begin
 Result.r:= c.r / k;
 Result.g:= c.g / k;
 Result.b:= c.b / k;
 Result.a:= c.a / k;
end;

//---------------------------------------------------------------------------
class operator TTrueColor.Explicit(const c: TTrueColor): TD3DColorValue;
begin
 Result.r:= c.r;
 Result.g:= c.g;
 Result.b:= c.b;
 Result.a:= c.a;
end;

//---------------------------------------------------------------------------
class operator TTrueColor.Implicit(const c: TTrueColor): Cardinal;
begin
 Result:= Round(c.b * 255.0) or (Round(c.g * 255.0) shl 8) or
  (Round(c.r * 255.0) shl 16) or (Round(c.a * 255.0) shl 24);
end;

//---------------------------------------------------------------------------
class operator TTrueColor.Implicit(c: Cardinal): TTrueColor;
begin
 Result.r:= ((c shr 16) and $FF) / 255.0;
 Result.g:= ((c shr 8) and $FF) / 255.0;
 Result.b:= (c and $FF) / 255.0;
 Result.a:= ((c shr 24) and $FF) / 255.0;
end;

//---------------------------------------------------------------------------
procedure TTrueColor.ClampMax();
begin
 if (r > 1.0) then r:= 1.0;
 if (g > 1.0) then g:= 1.0;
 if (b > 1.0) then b:= 1.0;
 if (a > 1.0) then a:= 1.0;
end;

//---------------------------------------------------------------------------
procedure TTrueColor.ClampMin();
begin
 if (r < 0.0) then r:= 0.0;
 if (g < 0.0) then g:= 0.0;
 if (b < 0.0) then b:= 0.0;
 if (a < 0.0) then a:= 0.0;
end;

//---------------------------------------------------------------------------
procedure TTrueColor.Clamp();
begin
 ClampMin();
 ClampMax();
end;

//---------------------------------------------------------------------------
function TrueColor(r, g, b, a: Single): TTrueColor;
begin
 Result.r:= r;
 Result.g:= g;
 Result.b:= b;
 Result.a:= a;
end;

//---------------------------------------------------------------------------
function TrueColor4to4(const Colors: TColor4): TTrueColor4;
var
 i: Integer;
begin
 for i:= 0 to 3 do
  Result[i]:= Colors[i];
end;

//---------------------------------------------------------------------------
function AlphaBlendTC(const c1, c2: TTrueColor; Alpha: Single): TTrueColor;
begin
 Result.r:= c1.r + (c2.r - c1.r) * Alpha;
 Result.g:= c1.g + (c2.g - c1.g) * Alpha;
 Result.b:= c1.b + (c2.b - c1.b) * Alpha;
 Result.a:= c1.a + (c2.a - c1.a) * Alpha;
end;

//---------------------------------------------------------------------------
end.
