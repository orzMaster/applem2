unit AsphyreSystemFonts;
//---------------------------------------------------------------------------
// AsphyreSystemFonts.pas                               Modified: 21-Feb-2007
// Asphyre System Font independent implementation                 Version 1.0
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
// The Original Code is AsphyreSystemFonts.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Windows, Types, SysUtils, D3DX9, Vectors2px;

//---------------------------------------------------------------------------
type
 TAsphyreSystemFonts = class;

//---------------------------------------------------------------------------
 TFontQualityType = (fqtDefault, fqtDraft, fqtProof, fqtNonAntialiased,
  fqtAntialiased, fqtClearType);

//---------------------------------------------------------------------------
 TFontWeightType = (fwtThin, fwtExtraLight, fwtLight, fwtNormal, fwtMedium,
  fwtSemiBold, fwtBold, fwtExtraBold, fwtHeavy);

//---------------------------------------------------------------------------
 TFontCharsetType = (fctAnsi, fctBaltic, fctChinesebig5, fctDefault,
  fctEastEurope, fctGb2312, fctGreek, fctHangul, fctMac, fctOem, fctRussian,
  fctShiftJis, fctSymbol, fctTurkish, fctVietnamese, fctJohab, fctArabic,
  fctHebrew, fctThai);

//---------------------------------------------------------------------------
 TFontFormatType = set of (fftTop, fftBottom, fftLeft, fftRight, fftCenter,
  fftVCenter, fftNoClip, fftExpandTabs, fftSingleLine, fftWordBreak);

//---------------------------------------------------------------------------
 TAsphyreSystemFont = class
 private
  FOwner    : TAsphyreSystemFonts;
  FName     : string;
  FDXFont   : ID3DXFont;
  FFontIndex: Integer;
  NoExclude : Boolean;

  function GetInitialized(): Boolean;
 protected
  procedure NotifyDeviceLost();
  procedure NotifyDeviceReset();
 public
  property Owner : TAsphyreSystemFonts read FOwner;
  property Name  : string read FName;
  property DXFont: ID3DXFont read FDXFont;

  property FontIndex  : Integer read FFontIndex;
  property Initialized: Boolean read GetInitialized;

  procedure TextOut(const Text: WideString; const Rect: TRect;
   Format: TFontFormatType; Color: Cardinal); overload;

  procedure TextOut(const Text: WideString; x, y: Integer;
   Color: Cardinal); overload;

  function TextExtent(const Text: WideString): TPoint2px;

  function TextWidth(const Text: WideString): Integer;
  function TextHeight(const Text: WideString): Integer;
  function Initialize(const FontName: string; Size: Integer; Italic: Boolean;
   Weight: TFontWeightType; Quality: TFontQualityType;
   Charset: TFontCharsetType): Boolean;
  procedure Finalize();

  constructor Create(AOwner: TAsphyreSystemFonts); virtual;
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
 TAsphyreSystemFonts = class
 private
  FDevice: TObject;
  Data: array of TAsphyreSystemFont;

  SearchObjects: array of Integer;
  SearchDirty  : Boolean;

  function GetCount(): Integer;
  function GetItem(Index: Integer): TAsphyreSystemFont;
  function CountSearchObjects(): Integer;
  procedure FillSearchObjects(Amount: Integer);
  procedure SortSearchObjects(Left, Right: Integer);
  procedure PrepareSearchObjects();
  function GetFont(const Name: string): TAsphyreSystemFont;

  procedure OnDeviceReset(Sender: TObject; EventParam: Pointer;
   var Success: Boolean); virtual;
  procedure OnDeviceLost(Sender: TObject; EventParam: Pointer;
   var Success: Boolean); virtual;
  procedure OnDeviceDestroy(Sender: TObject; EventParam: Pointer;
   var Success: Boolean); virtual;
 protected
  function FindEmptySlot(): Integer;
  function Insert(Element: TAsphyreSystemFont): Integer;
  function Include(Element: TAsphyreSystemFont): Integer;
  procedure Exclude(Element: TAsphyreSystemFont);
 public
  property Device: TObject read FDevice;

  property Count: Integer read GetCount;
  property Items[Index: Integer]: TAsphyreSystemFont read GetItem; default;
  property Font[const Name: string]: TAsphyreSystemFont read GetFont;

  function IndexOf(Element: TAsphyreSystemFont): Integer; overload;
  function IndexOf(const Name: string): Integer; overload;
  procedure Remove(Index: Integer);
  procedure RemoveAll();

  function CreateFont(const Name, SystemFontName: string; Size: Integer;
   Italic: Boolean = False; Weight: TFontWeightType = fwtNormal;
   Quality: TFontQualityType = fqtClearType;
   Charset: TFontCharsetType = fctAnsi): Integer;

  constructor Create(ADevice: TObject);
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreEvents, AsphyreDevices;

//---------------------------------------------------------------------------
const
 CLEARTYPE_QUALITY = 5;
 HANGUL_CHARSET    = HANGEUL_CHARSET;

//---------------------------------------------------------------------------
 API_WEIGHT: array[TFontWeightType] of Integer = (FW_THIN, FW_EXTRALIGHT,
  FW_LIGHT, FW_NORMAL, FW_MEDIUM, FW_SEMIBOLD, FW_BOLD, FW_EXTRABOLD,
  FW_HEAVY);

//---------------------------------------------------------------------------
 API_QUALITY: array[TFontQualityType] of Cardinal = (DEFAULT_QUALITY,
  DRAFT_QUALITY, PROOF_QUALITY, NONANTIALIASED_QUALITY, ANTIALIASED_QUALITY,
  CLEARTYPE_QUALITY);

//---------------------------------------------------------------------------
 API_CHARSET: array[TFontCharsetType] of Cardinal = (ANSI_CHARSET,
  BALTIC_CHARSET, CHINESEBIG5_CHARSET, DEFAULT_CHARSET, EASTEUROPE_CHARSET,
  GB2312_CHARSET, GREEK_CHARSET, HANGUL_CHARSET, MAC_CHARSET, OEM_CHARSET,
  RUSSIAN_CHARSET, SHIFTJIS_CHARSET, SYMBOL_CHARSET, TURKISH_CHARSET,
  VIETNAMESE_CHARSET, JOHAB_CHARSET, ARABIC_CHARSET, HEBREW_CHARSET,
  THAI_CHARSET);

//---------------------------------------------------------------------------
var
 PixelsPerInch: Integer = 1;

//---------------------------------------------------------------------------
procedure RetreivePixelsPerInch();
var
 DC: HDC;
begin
 DC:= GetDC(0);
 PixelsPerInch:= GetDeviceCaps(DC, LOGPIXELSY);
 ReleaseDC(0, DC);
end;

//---------------------------------------------------------------------------
function API_Format(Format: TFontFormatType): Cardinal;
begin
 Result:= 0;

 if (fftTop in Format) then Result:= Result or DT_TOP;
 if (fftBottom in Format) then Result:= Result or DT_BOTTOM;
 if (fftLeft in Format) then Result:= Result or DT_LEFT;
 if (fftRight in Format) then Result:= Result or DT_RIGHT;
 if (fftCenter in Format) then Result:= Result or DT_CENTER;
 if (fftVCenter in Format) then Result:= Result or DT_VCENTER;
 if (fftNoClip in Format) then Result:= Result or DT_NOCLIP;
 if (fftExpandTabs in Format) then Result:= Result or DT_EXPANDTABS;
 if (fftSingleLine in Format) then Result:= Result or DT_SINGLELINE;
 if (fftWordBreak in Format) then Result:= Result or DT_WORDBREAK;
end;

//---------------------------------------------------------------------------
constructor TAsphyreSystemFont.Create(AOwner: TAsphyreSystemFonts);
begin
 inherited Create();

 FFontIndex:= -1;
 FOwner    := AOwner;
 NoExclude := False;

 FDXFont:= nil;

 FOwner.Insert(Self);
end;

//---------------------------------------------------------------------------
destructor TAsphyreSystemFont.Destroy();
begin
 Finalize();

 if (not NoExclude) then FOwner.Exclude(Self);

 inherited;
end;

//---------------------------------------------------------------------------
function TAsphyreSystemFont.GetInitialized(): Boolean;
begin
 Result:= FDXFont <> nil;
end;

//---------------------------------------------------------------------------
function TAsphyreSystemFont.Initialize(const FontName: string;
 Size: Integer; Italic: Boolean; Weight: TFontWeightType;
 Quality: TFontQualityType; Charset: TFontCharsetType): Boolean;
var
 Width: Integer;
begin
 if (FOwner = nil)or(FOwner.Device = nil)or
  (not (FOwner.Device is TAsphyreDevice))or(FDXFont <> nil) then
  begin
   Result:= False;
   Exit;
  end;

 Width:= -MulDiv(Size, PixelsPerInch, 72);

 Result:= Succeeded(D3DXCreateFont(TAsphyreDevice(FOwner.Device).Dev9,
  Width, 0, API_WEIGHT[Weight], D3DX_DEFAULT, Italic, API_CHARSET[Charset],
  OUT_DEFAULT_PRECIS, API_QUALITY[Quality], DEFAULT_PITCH or FF_DONTCARE,
  PChar(FontName), FDXFont));
end;

//---------------------------------------------------------------------------
procedure TAsphyreSystemFont.Finalize();
begin
 if (FDXFont <> nil) then FDXFont:= nil;
end;

//---------------------------------------------------------------------------
procedure TAsphyreSystemFont.NotifyDeviceReset();
begin
 if (FDXFont <> nil) then
  FDXFont.OnResetDevice();
end;

//---------------------------------------------------------------------------
procedure TAsphyreSystemFont.NotifyDeviceLost();
begin
 if (FDXFont <> nil) then
  FDXFont.OnLostDevice();
end;

//---------------------------------------------------------------------------
procedure TAsphyreSystemFont.TextOut(const Text: WideString;
 const Rect: TRect; Format: TFontFormatType; Color: Cardinal);
begin
 if (FDXFont = nil) then Exit;

 FDXFont.DrawTextW(nil, PWideChar(Text), Length(Text), @Rect,
  API_FORMAT(Format), Color);
end;

//---------------------------------------------------------------------------
procedure TAsphyreSystemFont.TextOut(const Text: WideString; x, y: Integer;
 Color: Cardinal);
var
 DrawRect: TRect;
begin
 if (FDXFont = nil) then Exit;

 DrawRect:= Bounds(x, y, 1, 1);

 FDXFont.DrawTextW(nil, PWideChar(Text), Length(Text), @DrawRect, DT_LEFT or
  DT_TOP or DT_NOCLIP or DT_SINGLELINE, Color);
end;

//---------------------------------------------------------------------------
function TAsphyreSystemFont.TextExtent(const Text: WideString): TPoint2px;
var
 DrawRect: TRect;
begin
 if (FDXFont = nil) then
  begin
   Result:= ZeroPoint2px;
   Exit;
  end;

 DrawRect:= Bounds(0, 0, 1, 1);

 FDXFont.DrawTextW(nil, PWideChar(Text), Length(Text), @DrawRect, DT_LEFT or
  DT_TOP or DT_NOCLIP or DT_SINGLELINE or DT_CALCRECT , 0);

 Result.X:= DrawRect.Right - DrawRect.Left;
 Result.Y:= DrawRect.Bottom - DrawRect.Top;
end;

//---------------------------------------------------------------------------
function TAsphyreSystemFont.TextWidth(const Text: WideString): Integer;
begin
 Result:= TextExtent(Text).x;
end;

//---------------------------------------------------------------------------
function TAsphyreSystemFont.TextHeight(const Text: WideString): Integer;
begin
 Result:= TextExtent(Text).y;
end;

//---------------------------------------------------------------------------
constructor TAsphyreSystemFonts.Create(ADevice: TObject);
begin
 inherited Create();

 FDevice:= ADevice;

 EventDeviceReset.Subscribe(OnDeviceReset, FDevice);
 EventDeviceLost.Subscribe(OnDeviceLost, FDevice);
 EventDeviceDestroy.Subscribe(OnDeviceDestroy, FDevice);

 SearchDirty := False;
end;

//---------------------------------------------------------------------------
destructor TAsphyreSystemFonts.Destroy();
begin
 RemoveAll();

 EventDeviceDestroy.Unsubscribe(OnDeviceDestroy);
 EventDeviceLost.Unsubscribe(OnDeviceLost);
 EventDeviceReset.Unsubscribe(OnDeviceReset);

 inherited;
end;

//---------------------------------------------------------------------------
function TAsphyreSystemFonts.GetCount(): Integer;
begin
 Result:= Length(Data);
end;

//---------------------------------------------------------------------------
function TAsphyreSystemFonts.GetItem(Index: Integer): TAsphyreSystemFont;
begin
 if (Index >= 0)and(Index < Length(Data)) then
  Result:= Data[Index] else Result:= nil;
end;

//---------------------------------------------------------------------------
function TAsphyreSystemFonts.IndexOf(Element: TAsphyreSystemFont): Integer;
var
 i: Integer;
begin
 Result:= -1;
 for i:= 0 to Length(Data) - 1 do
  if (Data[i] = Element) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
function TAsphyreSystemFonts.CountSearchObjects(): Integer;
var
 i: Integer;
begin
 Result:= 0;

 for i:= 0 to Length(Data) - 1 do
  if (Data[i] <> nil) then Inc(Result);
end;

//---------------------------------------------------------------------------
procedure TAsphyreSystemFonts.FillSearchObjects(Amount: Integer);
var
 i, DestIndex: Integer;
begin
 SetLength(SearchObjects, Amount);

 DestIndex:= 0;
 for i:= 0 to Length(Data) - 1 do
  if (Data[i] <> nil) then
   begin
    SearchObjects[DestIndex]:= i;
    Inc(DestIndex);
   end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreSystemFonts.SortSearchObjects(Left, Right: Integer);
var
 Lo, Hi: Integer;
 TempIndex: Integer;
 MidValue: string;
begin
 Lo:= Left;
 Hi:= Right;
 MidValue:= Data[SearchObjects[(Left + Right) shr 1]].Name;

 repeat
  while (Data[SearchObjects[Lo]].Name < MidValue) do Inc(Lo);
  while (MidValue < Data[SearchObjects[Hi]].Name) do Dec(Hi);

  if (Lo <= Hi) then
   begin
    TempIndex:= SearchObjects[Lo];
    SearchObjects[Lo]:= SearchObjects[Hi];
    SearchObjects[Hi]:= TempIndex;

    Inc(Lo);
    Dec(Hi);
   end;
 until (Lo > Hi);

 if (Left < Hi) then SortSearchObjects(Left, Hi);
 if (Lo < Right) then SortSearchObjects(Lo, Right);
end;

//---------------------------------------------------------------------------
procedure TAsphyreSystemFonts.PrepareSearchObjects();
var
 Amount: Integer;
begin
 Amount:= CountSearchObjects();

 FillSearchObjects(Amount);

 if (Amount > 0) then
  SortSearchObjects(0, Amount - 1);

 SearchDirty:= False;
end;

//---------------------------------------------------------------------------
function TAsphyreSystemFonts.IndexOf(const Name: string): Integer;
var
 Lo, Hi, Mid: Integer;
begin
 if (SearchDirty) then PrepareSearchObjects();

 Result:= -1;

 Lo:= 0;
 Hi:= Length(SearchObjects) - 1;

 while (Lo <= Hi) do
  begin
   Mid:= (Lo + Hi) div 2;

   if (Data[SearchObjects[Mid]].Name = Name) then
    begin
     Result:= SearchObjects[Mid];
     Break;
    end;

   if (Data[SearchObjects[Mid]].Name > Name) then Hi:= Mid - 1
    else Lo:= Mid + 1;
 end;
end;

//---------------------------------------------------------------------------
function TAsphyreSystemFonts.FindEmptySlot(): Integer;
var
 i: Integer;
begin
 Result:= -1;

 for i:= 0 to Length(Data) - 1 do
  if (Data[i] = nil) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
function TAsphyreSystemFonts.Insert(Element: TAsphyreSystemFont): Integer;
var
 Slot: Integer;
begin
 Slot:= FindEmptySlot();
 if (Slot = -1) then
  begin
   Slot:= Length(Data);
   SetLength(Data, Slot + 1);
  end;

 Data[Slot]:= Element;
 Element.FFontIndex:= Slot;

 SearchDirty:= True;
 Result:= Slot;
end;

//---------------------------------------------------------------------------
function TAsphyreSystemFonts.Include(Element: TAsphyreSystemFont): Integer;
begin
 Result:= IndexOf(Element);
 if (Result = -1) then Result:= Insert(Element);
end;

//---------------------------------------------------------------------------
procedure TAsphyreSystemFonts.Exclude(Element: TAsphyreSystemFont);
var
 Index: Integer;
begin
 Index:= IndexOf(Element);
 if (Index <> -1) then
  begin
   Data[Index]:= nil;
   SearchDirty:= True;
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreSystemFonts.Remove(Index: Integer);
begin
 if (Index < 0)or(Index >= Length(Data)) then Exit;
 

 Data[Index].NoExclude:= True;
 Data[Index].Free();
 Data[Index]:= nil;

 SearchDirty:= True;
end;

//---------------------------------------------------------------------------
procedure TAsphyreSystemFonts.RemoveAll();
var
 i: Integer;
begin
 for i:= 0 to Length(Data) - 1 do
  if (Data[i] <> nil) then
   begin
    Data[i].NoExclude:= True;
    Data[i].Free();
    Data[i]:= nil;
   end;

 SetLength(Data, 0);
 SetLength(SearchObjects, 0);
 SearchDirty:= False;
end;

//---------------------------------------------------------------------------
function TAsphyreSystemFonts.GetFont(const Name: string): TAsphyreSystemFont;
var
 Index: Integer;
begin
 Index:= IndexOf(Name);
 if (Index <> -1) then Result:= Data[Index] else Result:= nil;
end;

//---------------------------------------------------------------------------
procedure TAsphyreSystemFonts.OnDeviceLost(Sender: TObject; EventParam: Pointer;
 var Success: Boolean);
var
 i: Integer;
begin
 for i:= 0 to Length(Data) - 1 do
  Data[i].NotifyDeviceLost();
end;

//---------------------------------------------------------------------------
procedure TAsphyreSystemFonts.OnDeviceReset(Sender: TObject;
 EventParam: Pointer; var Success: Boolean);
var
 i: Integer;
begin
 for i:= 0 to Length(Data) - 1 do
  Data[i].NotifyDeviceReset();
end;

//---------------------------------------------------------------------------
procedure TAsphyreSystemFonts.OnDeviceDestroy(Sender: TObject;
 EventParam: Pointer; var Success: Boolean);
begin
 RemoveAll();
end;

//---------------------------------------------------------------------------
function TAsphyreSystemFonts.CreateFont(const Name, SystemFontName: string;
 Size: Integer; Italic: Boolean; Weight: TFontWeightType;
 Quality: TFontQualityType; Charset: TFontCharsetType): Integer;
var
 Font: TAsphyreSystemFont;
begin
 Font:= TAsphyreSystemFont.Create(Self);
 Font.FName:= Name;

 if (not Font.Initialize(SystemFontName, Size, Italic, Weight, Quality,
  Charset)) then
  begin
   Font.Free();
   Result:= -1;
   Exit;
  end;

 Result:= Font.FontIndex;
end;

//---------------------------------------------------------------------------
initialization
 RetreivePixelsPerInch();
 
//---------------------------------------------------------------------------
end.
