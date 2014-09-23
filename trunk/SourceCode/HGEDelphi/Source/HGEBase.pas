unit HGEBase;

interface
uses
  Windows, SysUtils, Classes, DirectXGraphics;

const
  AllowedChars = [#32..#254];
  AllowedIntegerChars = [#48..#57];
  AllowedEnglishChars = [#33..#126];
  AllowedStandard = [#48..#57, #65..#90, #97..#122];
  AllowedCDKey = [#48..#57, #65..#90, #95, #97..#122];



type
  TColorFormat = (COLOR_R3G3B2, COLOR_R5G6B5, COLOR_X8R8G8B8, COLOR_X1R5G5B5,
    COLOR_X4R4G4B4, COLOR_A8R8G8B8, COLOR_A1R5G5B5, COLOR_A4R4G4B4,
    COLOR_A8R3G3B2, COLOR_A2R2G2B2, COLOR_A8, COLOR_UNKNOWN);

  PColor4 = ^TColor4;
  TColor4 = array[0..3] of Cardinal;

  EDirectXError = class(Exception);

const
  Format2Bytes: array[TColorFormat] of Integer = (1, 2, 4, 2, 2, 4, 2, 2, 2, 1, 1, 0);

  Format2Bits: array[TColorFormat] of Cardinal = ($0233, $0565, $0888, $0555, $0444, $8888, $1555, $4444, $8233, $2222, $8000, $0000);


  clWhite4  : TColor4 = ($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF);
  clBlack4  : TColor4 = ($FF000000, $FF000000, $FF000000, $FF000000);
  clMaroon4 : TColor4 = ($FF000080, $FF000080, $FF000080, $FF000080);
  clGreen4  : TColor4 = ($FF008000, $FF008000, $FF008000, $FF008000);
  clOlive4  : TColor4 = ($FF008080, $FF008080, $FF008080, $FF008080);
  clNavy4   : TColor4 = ($FF800000, $FF800000, $FF800000, $FF800000);
  clPurple4 : TColor4 = ($FF800080, $FF800080, $FF800080, $FF800080);
  clTeal4   : TColor4 = ($FF808000, $FF808000, $FF808000, $FF808000);
  clGray4   : TColor4 = ($FF808080, $FF808080, $FF808080, $FF808080);
  clSilver4 : TColor4 = ($FFC0C0C0, $FFC0C0C0, $FFC0C0C0, $FFC0C0C0);
  clRed4    : TColor4 = ($FF0000FF, $FF0000FF, $FF0000FF, $FF0000FF);
  clLime4   : TColor4 = ($FF00FF00, $FF00FF00, $FF00FF00, $FF00FF00);
  clYellow4 : TColor4 = ($FF00FFFF, $FF00FFFF, $FF00FFFF, $FF00FFFF);
  clBlue4   : TColor4 = ($FFFF0000, $FFFF0000, $FFFF0000, $FFFF0000);
  clFuchsia4: TColor4 = ($FFFF00FF, $FFFF00FF, $FFFF00FF, $FFFF00FF);

  clAqua4   : TColor4 = ($FFFFFF00, $FFFFFF00, $FFFFFF00, $FFFFFF00);
  clLtGray4 : TColor4 = ($FFC0C0C0, $FFC0C0C0, $FFC0C0C0, $FFC0C0C0);
  clDkGray4 : TColor4 = ($FF808080, $FF808080, $FF808080, $FF808080);
  clOpaque4 : TColor4 = ($00FFFFFF, $00FFFFFF, $00FFFFFF, $00FFFFFF);
  
function D3DToFormat(Fmt: TD3DFormat): TColorFormat;

function Point(x, y: Integer): TPoint;

function Rect(Left, Top, Right, Bottom: Integer): TRect;

function FiltrateChar(Char1, Char2: Byte): Boolean;

function DisplaceRB(Color: Cardinal): Cardinal; stdcall;

function PixelXto32(Source: Pointer; SrcFmt: TColorFormat): Longword;
procedure Pixel32toX(Source: Longword; Dest: Pointer; DestFmt: TColorFormat);

function Max(Val1, Val2: Integer): Integer;
function Min(Val1, Val2: Integer): Integer;

function cColor4(Color: Cardinal):TColor4; overload;
function cColor4(Color1, Color2, Color3, Color4: Cardinal): TColor4; overload;

function PixelA8R8G8B8_R3G3B2(Color: Longword): Byte; stdcall;
function PixelA8R8G8B8_R5G6B5(Color: Longword): Word; stdcall;
function PixelA8R8G8B8_A2R2G2B2(Color: Longword): Byte; stdcall;
function PixelA8R8G8B8_A8R3G3B2(Color: Longword): Word; stdcall;
function PixelA8R8G8B8_A4R4G4B4(Color: Longword): Word; stdcall;
function PixelA8R8G8B8_X4R4G4B4(Color: Longword): Word; stdcall;
function PixelA8R8G8B8_X1R5G5B5(Color: Longword): Word; stdcall;
function PixelA8R8G8B8_A1R5G5B5(Color: Longword): Word; stdcall;
procedure LineA8R8G8B8_R3G3B2(Source, Dest: Pointer; Count: Integer); stdcall;
procedure LineA8R8G8B8_R5G6B5(Source, Dest: Pointer; Count: Integer); stdcall;
procedure LineA8R8G8B8_X1R5G5B5(Source, Dest: Pointer; Count: Integer); stdcall;
procedure LineA8R8G8B8_X4R4G4B4(Source, Dest: Pointer; Count: Integer); stdcall;
procedure LineA8R8G8B8_A1R5G5B5(Source, Dest: Pointer; Count: Integer); stdcall;
procedure LineA8R8G8B8_A4R4G4B4(Source, Dest: Pointer; Count: Integer); stdcall;
procedure LineA8R8G8B8_A8R3G3B2(Source, Dest: Pointer; Count: Integer); stdcall;
procedure LineA8R8G8B8_A2R2G2B2(Source, Dest: Pointer; Count: Integer); stdcall;


implementation

{$INCLUDE include\bitconv32.inc}

function DisplaceRB(Color: Cardinal): Cardinal; stdcall;
asm
  mov eax, Color
  mov ecx, eax
  mov edx, eax
  and eax, 0FF00FF00h
  and edx, 0000000FFh
  shl edx, 16
  or eax, edx
  mov edx, ecx
  shr edx, 16
  and edx, 0000000FFh
  or eax, edx
  mov Result, eax
end;

function PixelXto32(Source: Pointer; SrcFmt: TColorFormat): Longword;
const
  bAnd: array[0..8] of Longword = (0, 1, 3, 7, 15, 31, 63, 127, 255);
var
  Px: Longword;
  Bits: Word;
  RedBits, GreenBits, BlueBits, AlphaBits: Integer;
  Red, Green, Blue, Alpha: Longword;
begin
  Px := 0;
  Move(Source^, Px, Format2Bytes[SrcFmt]);

  Bits := Format2Bits[SrcFmt];

  RedBits := Bits and $F;
  Red := BitConv32[RedBits, Px and bAnd[RedBits]];

  GreenBits := (Bits shr 4) and $F;
  Green := BitConv32[GreenBits, (Px shr RedBits) and bAnd[GreenBits]];

  BlueBits := (Bits shr 8) and $F;
  Blue := BitConv32[BlueBits, (Px shr (RedBits + GreenBits)) and bAnd[BlueBits]];

  AlphaBits := (Bits shr 12) and $F;
  Alpha := BitConv32[AlphaBits, (Px shr (RedBits + GreenBits + BlueBits)) and bAnd[AlphaBits]];

  Result := Red or (Green shl 8) or (Blue shl 16) or (Alpha shl 24);
end;


function PixelA8R8G8B8_R3G3B2(Color: Longword): Byte; stdcall;
const
  x1 = 0;
  a1 = 8;
  r1 = 8;
  g1 = 8;
  b1 = 8;
  r2 = 3;
  g2 = 3;
  b2 = 2;
begin
{$DEFINE PxInDWORD}{$DEFINE PxOutBYTE}
{$INCLUDE include\pixasm.inc}
end;

//---------------------------------------------------------------------------
// A8R8G8B8 (32-bit) -> R5G6B5 (16-bit)
//---------------------------------------------------------------------------

function PixelA8R8G8B8_R5G6B5(Color: Longword): Word; stdcall;
const
  x1 = 0;
  a1 = 8;
  r1 = 8;
  g1 = 8;
  b1 = 8;
  r2 = 5;
  g2 = 6;
  b2 = 5;
begin
{$DEFINE PxInDWORD}{$DEFINE PxOutWORD}
{$INCLUDE include\pixasm.inc}
end;

//---------------------------------------------------------------------------
// A8R8G8B8 (32-bit) -> X1R5G5B5 (16-bit)
//---------------------------------------------------------------------------

function PixelA8R8G8B8_X1R5G5B5(Color: Longword): Word; stdcall;
const
  x1 = 0;
  a1 = 8;
  r1 = 8;
  g1 = 8;
  b1 = 8;
  r2 = 5;
  g2 = 5;
  b2 = 5;
begin
{$DEFINE PxInDWORD}{$DEFINE PxOutWORD}
{$INCLUDE include\pixasm.inc}
end;

//---------------------------------------------------------------------------
// A8R8G8B8 (32-bit) -> X4R4G4B4 (16-bit)
//---------------------------------------------------------------------------

function PixelA8R8G8B8_X4R4G4B4(Color: Longword): Word; stdcall;
const
  x1 = 0;
  a1 = 8;
  r1 = 8;
  g1 = 8;
  b1 = 8;
  r2 = 4;
  g2 = 4;
  b2 = 4;
begin
{$DEFINE PxInDWORD}{$DEFINE PxOutWORD}
{$INCLUDE include\pixasm.inc}
end;

//---------------------------------------------------------------------------
// A8R8G8B8 (32-bit) -> A1R5G5B5 (16-bit)
//---------------------------------------------------------------------------

function PixelA8R8G8B8_A1R5G5B5(Color: Longword): Word; stdcall;
const
  x1 = 0;
  a1 = 8;
  r1 = 8;
  g1 = 8;
  b1 = 8;
  a2 = 1;
  r2 = 5;
  g2 = 5;
  b2 = 5;
begin
{$DEFINE PxInDWORD}{$DEFINE PxALPHA}{$DEFINE PxOutWORD}
{$INCLUDE include\pixasm.inc}
end;

//---------------------------------------------------------------------------
// A8R8G8B8 (32-bit) -> A4R4G4B4 (16-bit)
//---------------------------------------------------------------------------

function PixelA8R8G8B8_A4R4G4B4(Color: Longword): Word; stdcall;
const
  x1 = 0;
  a1 = 8;
  r1 = 8;
  g1 = 8;
  b1 = 8;
  a2 = 4;
  r2 = 4;
  g2 = 4;
  b2 = 4;
begin
{$DEFINE PxInDWORD}{$DEFINE PxALPHA}{$DEFINE PxOutWORD}
{$INCLUDE include\pixasm.inc}
end;

//---------------------------------------------------------------------------
// A8R8G8B8 (32-bit) -> A8R3G3B2 (16-bit)
//---------------------------------------------------------------------------

function PixelA8R8G8B8_A8R3G3B2(Color: Longword): Word; stdcall;
const
  x1 = 0;
  a1 = 8;
  r1 = 8;
  g1 = 8;
  b1 = 8;
  a2 = 8;
  r2 = 3;
  g2 = 3;
  b2 = 2;
begin
{$DEFINE PxInDWORD}{$DEFINE PxALPHA}{$DEFINE PxOutWORD}
{$INCLUDE include\pixasm.inc}
end;

//---------------------------------------------------------------------------
// A8R8G8B8 (32-bit) -> A2R2G2B2 (8-bit)
//---------------------------------------------------------------------------

function PixelA8R8G8B8_A2R2G2B2(Color: Longword): Byte; stdcall;
const
  x1 = 0;
  a1 = 8;
  r1 = 8;
  g1 = 8;
  b1 = 8;
  a2 = 2;
  r2 = 2;
  g2 = 2;
  b2 = 2;
begin
{$DEFINE PxInDWORD}{$DEFINE PxALPHA}{$DEFINE PxOutBYTE}
{$INCLUDE include\pixasm.inc}
end;

//---------------------------------------------------------------------------
// line A8R8G8B8 (32-bit) -> R3G3B2 (8-bit)
//---------------------------------------------------------------------------

procedure LineA8R8G8B8_R3G3B2(Source, Dest: Pointer; Count: Integer); stdcall;
const
  x1 = 0;
  a1 = 8;
  r1 = 8;
  g1 = 8;
  b1 = 8;
  r2 = 3;
  g2 = 3;
  b2 = 2;
begin
{$DEFINE PxInDWORD}{$DEFINE PxOutBYTE}
{$INCLUDE include\lineasm.inc}
end;

//---------------------------------------------------------------------------
// line A8R8G8B8 (32-bit) -> R5G6B5 (16-bit)
//---------------------------------------------------------------------------

procedure LineA8R8G8B8_R5G6B5(Source, Dest: Pointer; Count: Integer); stdcall;
const
  x1 = 0;
  a1 = 8;
  r1 = 8;
  g1 = 8;
  b1 = 8;
  r2 = 5;
  g2 = 6;
  b2 = 5;
begin
{$DEFINE PxInDWORD}{$DEFINE PxOutWORD}
{$INCLUDE include\lineasm.inc}
end;

//---------------------------------------------------------------------------
// line A8R8G8B8 (32-bit) -> X1R5G5B5 (16-bit)
//---------------------------------------------------------------------------

procedure LineA8R8G8B8_X1R5G5B5(Source, Dest: Pointer; Count: Integer); stdcall;
const
  x1 = 0;
  a1 = 8;
  r1 = 8;
  g1 = 8;
  b1 = 8;
  r2 = 5;
  g2 = 5;
  b2 = 5;
begin
{$DEFINE PxInDWORD}{$DEFINE PxOutWORD}
{$INCLUDE include\lineasm.inc}
end;

//---------------------------------------------------------------------------
// line A8R8G8B8 (32-bit) -> X4R4G4B4 (16-bit)
//---------------------------------------------------------------------------

procedure LineA8R8G8B8_X4R4G4B4(Source, Dest: Pointer; Count: Integer); stdcall;
const
  x1 = 0;
  a1 = 8;
  r1 = 8;
  g1 = 8;
  b1 = 8;
  r2 = 4;
  g2 = 4;
  b2 = 4;
begin
{$DEFINE PxInDWORD}{$DEFINE PxOutWORD}
{$INCLUDE include\lineasm.inc}
end;

//---------------------------------------------------------------------------
// line A8R8G8B8 (32-bit) -> A1R5G5B5 (16-bit)
//---------------------------------------------------------------------------

procedure LineA8R8G8B8_A1R5G5B5(Source, Dest: Pointer; Count: Integer); stdcall;
const
  x1 = 0;
  a1 = 8;
  r1 = 8;
  g1 = 8;
  b1 = 8;
  a2 = 1;
  r2 = 5;
  g2 = 5;
  b2 = 5;
begin
{$DEFINE PxInDWORD}{$DEFINE PxALPHA}{$DEFINE PxOutWORD}
{$INCLUDE include\lineasm.inc}
end;

//---------------------------------------------------------------------------
// line A8R8G8B8 (32-bit) -> A4R4G4B4 (16-bit)
//---------------------------------------------------------------------------

procedure LineA8R8G8B8_A4R4G4B4(Source, Dest: Pointer; Count: Integer); stdcall;
const
  x1 = 0;
  a1 = 8;
  r1 = 8;
  g1 = 8;
  b1 = 8;
  a2 = 4;
  r2 = 4;
  g2 = 4;
  b2 = 4;
begin
{$DEFINE PxInDWORD}{$DEFINE PxALPHA}{$DEFINE PxOutWORD}
{$INCLUDE include\lineasm.inc}
end;

//---------------------------------------------------------------------------
// line A8R8G8B8 (32-bit) -> A8R3G3B2 (16-bit)
//---------------------------------------------------------------------------

procedure LineA8R8G8B8_A8R3G3B2(Source, Dest: Pointer; Count: Integer); stdcall;
const
  x1 = 0;
  a1 = 8;
  r1 = 8;
  g1 = 8;
  b1 = 8;
  a2 = 8;
  r2 = 3;
  g2 = 3;
  b2 = 2;
begin
{$DEFINE PxInDWORD}{$DEFINE PxALPHA}{$DEFINE PxOutWORD}
{$INCLUDE include\lineasm.inc}
end;

//---------------------------------------------------------------------------
// line A8R8G8B8 (32-bit) -> A2R2G2B2 (8-bit)
//---------------------------------------------------------------------------

procedure LineA8R8G8B8_A2R2G2B2(Source, Dest: Pointer; Count: Integer); stdcall;
const
  x1 = 0;
  a1 = 8;
  r1 = 8;
  g1 = 8;
  b1 = 8;
  a2 = 2;
  r2 = 2;
  g2 = 2;
  b2 = 2;
begin
{$DEFINE PxInDWORD}{$DEFINE PxALPHA}{$DEFINE PxOutBYTE}
{$INCLUDE include\lineasm.inc}
end;

procedure Pixel32toX(Source: Longword; Dest: Pointer; DestFmt: TColorFormat);
begin
  case DestFmt of
    COLOR_R3G3B2: PByte(Dest)^ := PixelA8R8G8B8_R3G3B2(Source);
    COLOR_R5G6B5: PWord(Dest)^ := PixelA8R8G8B8_R5G6B5(Source);
    COLOR_X1R5G5B5: PWord(Dest)^ := PixelA8R8G8B8_X1R5G5B5(Source);
    COLOR_X4R4G4B4: PWord(Dest)^ := PixelA8R8G8B8_X4R4G4B4(Source);
    COLOR_A1R5G5B5: PWord(Dest)^ := PixelA8R8G8B8_A1R5G5B5(Source);
    COLOR_A4R4G4B4: PWord(Dest)^ := PixelA8R8G8B8_A4R4G4B4(Source);
    COLOR_A8R3G3B2: PWord(Dest)^ := PixelA8R8G8B8_A8R3G3B2(Source);
    COLOR_A2R2G2B2: PByte(Dest)^ := PixelA8R8G8B8_A2R2G2B2(Source);
    COLOR_X8R8G8B8: PLongword(Dest)^ := Source or $FF000000;
    COLOR_A8R8G8B8: PLongword(Dest)^ := Source;
    COLOR_A8: PByte(Dest)^ := Source shr 24;
  end;
end;

function D3DToFormat(Fmt: TD3DFormat): TColorFormat;
begin
  Result := COLOR_UNKNOWN;
  case Fmt of
    D3DFMT_R3G3B2: Result := COLOR_R3G3B2;
    D3DFMT_R5G6B5: Result := COLOR_R5G6B5;
    D3DFMT_X8R8G8B8: Result := COLOR_X8R8G8B8;
    D3DFMT_X1R5G5B5: Result := COLOR_X1R5G5B5;
    D3DFMT_X4R4G4B4: Result := COLOR_X4R4G4B4;
    D3DFMT_A8R8G8B8: Result := COLOR_A8R8G8B8;
    D3DFMT_A1R5G5B5: Result := COLOR_A1R5G5B5;
    D3DFMT_A4R4G4B4: Result := COLOR_A4R4G4B4;
    D3DFMT_A8R3G3B2: Result := COLOR_A8R3G3B2;
    D3DFMT_A8: Result := COLOR_A8;
  end;
end;

function Point(x, y: Integer): TPoint;
begin
  Result.X := X;
  Result.Y := Y;
end;

function Rect(Left, Top, Right, Bottom: Integer): TRect;
begin
  Result.Left := Left;
  Result.Top := Top;
  Result.Right := Right;
  Result.Bottom := Bottom;
end;

function FiltrateChar(Char1, Char2: Byte): Boolean;
begin
  Result := False;
  case Char1 of
    32..126: Result := Char2 = 0;
    161: Result := (Char2 in [161..254]);
    162: Result := (Char2 in [161..170, 177..226, 229..238, 241..250{252}]);
    163: Result := (Char2 in [161..254]);
    164: Result := (Char2 in [161..243]);
    165: Result := (Char2 in [161..246]);
    166: Result := (Char2 in [161..184, 193..216, 224..235, 238..242, 244, 245]);
    167: Result := (Char2 in [161..193, 209..241]);
    168: Result := (Char2 in [64..126, 128..149, 161..187, {189, 190, }192, 197..233]);
    169: Result := (Char2 in [64..90, 92, 96..126, 128..136, 150, 164..239]);
    176..214, 216..247: Result := (Char2 in [161..254]);
    215: Result := (Char2 in [161..249]);
  end;
end;

function Max(Val1, Val2: Integer): Integer;
begin
  if Val1>=Val2 then Result := Val1 else Result := Val2;
end;

function Min(Val1, Val2: Integer): Integer;
begin
  if Val1<=Val2 then Result := Val1 else Result := Val2;
end;

function cColor4(Color: Cardinal):TColor4;
begin
  Result[0] := Color;
  Result[1] := Color;
  Result[2] := Color;
  Result[3] := Color;
end;

function cColor4(Color1, Color2, Color3, Color4: Cardinal): TColor4;
begin
  Result[0]:= Color1;
  Result[1]:= Color2;
  Result[2]:= Color3;
  Result[3]:= Color4;
end;

end.
