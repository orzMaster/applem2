unit AsphyreFonts;
//---------------------------------------------------------------------------
// AsphyreFonts.pas                                     Modified: 21-Feb-2007
// Asphyre Native Font implementation                             Version 1.1
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
// The Original Code is AsphyreFonts.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Types, SysUtils, Vectors2px, HelperSets, AsphyreTypes, AsphyreUtils,
 MediaFonts, AsphyreEvents;

//---------------------------------------------------------------------------
type
 TAsphyreFonts = class;

//---------------------------------------------------------------------------
 PFontOptions = ^TFontOptions;
 TFontOptions = record
  // text shadow settings
  ShowShadow : Boolean;
  ShadowAlpha: Integer;
  ShadowDepth: TPoint2px;

  // text output parameters
  Kerning: Integer;
  Scale  : Integer;
  Shift  : TPoint2px;

  procedure Reset();
 end;

//---------------------------------------------------------------------------
 PFontBitmapMetrics = ^TFontBitmapMetrics;
 TFontBitmapMetrics = record
  FirstLetter: Integer;
  LetterCount: Integer;
  Interleave : Integer;
  BlankSpace : Integer;
 end;

//---------------------------------------------------------------------------
 TFontPerformEvent = procedure(Sender: TObject; Tag, CharCode,
  CharSpacing: Integer; const DrawRect: TRect; const CharSize: TPoint2px;
  const Colors: TColor2) of object;

//---------------------------------------------------------------------------
 TAsphyreNativeFont = class
 private
  FOwner    : TAsphyreFonts;
  FName     : string;
  FFontIndex: Integer;
  FOptions  : TFontOptions;
  CharWidths: array of Integer;

  FInitialized  : Boolean;
  FBitmapMetrics: TFontBitmapMetrics;
  FPatternSize  : TPoint2px;
  FImageIndex   : Integer;

  // NoExclude indicates that the component should not exclude itself
  // from the owner.
  NoExclude: Boolean;

  function GetOptions(): PFontOptions;
  function GetBitmapMetrics(): PFontBitmapMetrics;
  procedure InitCharWidths(Count, Space: Integer);
 protected
  procedure DrawAtFx(Sender: TObject; Tag, CharCode, CharSpacing: Integer;
   const DrawRect: TRect; const CharSize: TPoint2px;
   const Colors: TColor2); virtual;
  procedure EstimateSize(Sender: TObject; Tag, CharCode, CharSpacing: Integer;
   const DrawRect: TRect; const CharSize: TPoint2px;
   const Colors: TColor2); virtual;
  procedure EstimateRects(Sender: TObject; Tag, CharCode, CharSpacing: Integer;
   const DrawRect: TRect; const CharSize: TPoint2px;
   const Colors: TColor2); virtual;
 public
  // The reference to the font holder.
  property Owner: TAsphyreFonts read FOwner;

  // The unique image identifier
  property Name: string read FName;

  // The index assigned by the owner.
  property FontIndex: Integer read FFontIndex;

  // Determines whether the font has been initialized successfully.
  property Initialized: Boolean read FInitialized;

  // Options controlling font appearance.
  property Options: PFontOptions read GetOptions;

  // Bitmap font parameters like number of letters and such.
  property BitmapMetrics: PFontBitmapMetrics read GetBitmapMetrics;

  // The index of image representing bitmap font.
  property ImageIndex : Integer read FImageIndex;

  // The pattern size in the font image.
  property PatternSize: TPoint2px read FPatternSize;

  //-------------------------------------------------------------------------
  // The following routine performs the virtualized rendering of the text
  // at the specified position, calling specified callback function to render
  // the actual text or do any relevant task.
  //-------------------------------------------------------------------------
  procedure PerformAt(const Text: string; const DrawPos: TPoint2px;
   Colors: TColor2; Tag: Integer; Event: TFontPerformEvent);

  //-------------------------------------------------------------------------
  // Draw the text at the specified position and color(s).
  //-------------------------------------------------------------------------
  procedure TextOut(const Text: string; x, y: Integer;
   const Colors: TColor2); overload;
  procedure TextOut(const Text: string; x, y: Integer;
   Color: Cardinal); overload;

  //-------------------------------------------------------------------------
  // Estimates the width and height of text in pixels.
  //-------------------------------------------------------------------------
  function TextExtent(const Text: string): TPoint2px;

  //-------------------------------------------------------------------------
  // The following routines estimate either the width or the height of the
  // given text in pixels. They use TextExtent(), so for performance reasons
  // it is better to use TextExtent() if you need to determine the dimensions
  // for the text both horizontally and vertically.
  //-------------------------------------------------------------------------
  function TextWidth(const Text: string): Integer;
  function TextHeight(const Text: string): Integer;

  //-------------------------------------------------------------------------
  // The following method displays the text inside given rectangle using the
  // particular text alignment.
  //-------------------------------------------------------------------------
  procedure TextRect(const Text: string; const Rect: TRect;
   HorizontalAlign: THorizontalAlign; VerticalAlign: TVerticalAlign;
   const Colors: TColor2);

  //-------------------------------------------------------------------------
  // The following method estimates the rectangles occupied by individual
  // letters when rendered on the screen.
  //-------------------------------------------------------------------------
  procedure TextRects(const Text: string; List: TRectList);

  function Initialize(Desc: PFontDesc): Boolean;
  procedure Finalize();

  constructor Create(AOwner: TAsphyreFonts); virtual;
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
 TAsphyreFonts = class
 private
  FDevice: TObject;
  Data: array of TAsphyreNativeFont;

  SearchObjects: array of Integer;
  SearchDirty  : Boolean;
  FMediaOption : string;

  function GetCount(): Integer;
  function GetItem(Num: Integer): TAsphyreNativeFont;
  function CountSearchObjects(): Integer;
  procedure FillSearchObjects(Amount: Integer);
  procedure SortSearchObjects(Left, Right: Integer);
  procedure PrepareSearchObjects();
  function GetFont(const Name: string): TAsphyreNativeFont;
  procedure OnDeviceDestroy(Sender: TObject; EventParam: Pointer;
   var Success: Boolean);
 protected
  function FindEmptySlot(): Integer;
  function Insert(Element: TAsphyreNativeFont): Integer;
  function Include(Element: TAsphyreNativeFont): Integer;
  procedure Exclude(Element: TAsphyreNativeFont);
 public
  property Device: TObject read FDevice;

  property MediaOption: string read FMediaOption write FMediaOption;

  property Count: Integer read GetCount;
  property Items[Num: Integer]: TAsphyreNativeFont read GetItem; default;
  property Font[const Name: string]: TAsphyreNativeFont read GetFont;

  function IndexOf(Element: TAsphyreNativeFont): Integer; overload;
  function IndexOf(const Name: string): Integer; overload;
  procedure Remove(Num: Integer);
  procedure RemoveAll();

  function ResolveFont(Name: string): Integer;
  procedure UnloadGroup(const GroupName: string);

  constructor Create(ADevice: TObject);
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreEffects, AsphyreDevices, AsphyreImages;

//---------------------------------------------------------------------------
const
 // The padding wired into Asphyre 4.x bitmap fonts.
 ConstantPadding = 2;

//---------------------------------------------------------------------------
procedure TFontOptions.Reset();
begin
 ShowShadow:= False;
 ShadowAlpha:= 128;
 ShadowDepth:= Point2px(2, 2);

 Kerning:= 0;
 Scale  := 65536;
 Shift  := ZeroPoint2px;
end;

//---------------------------------------------------------------------------
constructor TAsphyreNativeFont.Create(AOwner: TAsphyreFonts);
begin
 inherited Create();

 FOwner      := AOwner;
 NoExclude   := False;
 FFontIndex  := -1;
 FInitialized:= False;

 if (FOwner <> nil) then FOwner.Insert(Self);

 FImageIndex := -1;
 FPatternSize:= InfPoint2px;

 FOptions.Reset();
end;

//---------------------------------------------------------------------------
destructor TAsphyreNativeFont.Destroy();
begin
 if (FInitialized) then Finalize();

 if (not NoExclude)and(FOwner <> nil) then FOwner.Exclude(Self);

 inherited;
end;

//---------------------------------------------------------------------------
function TAsphyreNativeFont.GetOptions(): PFontOptions;
begin
 Result:= @FOptions;
end;

//---------------------------------------------------------------------------
function TAsphyreNativeFont.GetBitmapMetrics(): PFontBitmapMetrics;
begin
 if (FInitialized) then Result:= @FBitmapMetrics else Result:= nil;
end;

//---------------------------------------------------------------------------
procedure TAsphyreNativeFont.InitCharWidths(Count, Space: Integer);
var
 i: Integer;
begin
 SetLength(CharWidths, Count);

 for i:= 0 to Length(CharWidths) - 1 do
  CharWidths[i]:= Space;
end;

//---------------------------------------------------------------------------
function TAsphyreNativeFont.Initialize(Desc: PFontDesc): Boolean;
var
 Images: TAsphyreImages;
 i: Integer;
begin
 // (1) Initialization requires a valid Owner to have reference to existing
 // device that is initialized.
 if (FOwner = nil)or(FOwner.Device = nil)or
  (not (FOwner.Device is TAsphyreDevice))or
  (not TAsphyreDevice(FOwner.Device).Initialized) then
  begin
   Result:= False;
   Exit;
  end;

 // (2) Make sure the font has corresponding bitmap image in the system.
 Images:= TAsphyreDevice(FOwner.FDevice).Images;
 FImageIndex:= Images.ResolveImage(Desc.Image);
 Result:= (FImageIndex <> -1)and(Images[FImageIndex] is TAsphyreImage);
 if (not Result) then Exit;

 // (3) Initialize bitmap metrics that will be used later on to rasterize
 // individual characters.
 FBitmapMetrics.FirstLetter:= Desc.FirstLetter;
 FBitmapMetrics.LetterCount:= Desc.PatCount;
 FBitmapMetrics.Interleave := Desc.Interleave;
 FBitmapMetrics.BlankSpace := Round((Desc.PatSize.X - ConstantPadding) *
  Desc.BlankSpace);

 // (4) The pattern size specified in the font overrides the information
 // specified for the image (for convenience).
 FPatternSize:= Desc.PatSize;

 // (5) Override image specification in case such information was not
 // provided in XML file.
 with Images[FImageIndex] as TAsphyreImage do
  begin
   Padding     := Point2px(ConstantPadding, ConstantPadding);
   PatternCount:= Desc.PatCount;
   PatternSize := Desc.PatSize;
  end;

 // (6) Since not all characters may have their width described in XML file,
 // the list is initially filled with blank space size.
 InitCharWidths(FBitmapMetrics.LetterCount, FBitmapMetrics.BlankSpace);

 // (7) Fill characters that are described in XML file with their respective
 // width values.
 for i:= 0 to Length(Desc.CharInfo) - 1 do
  CharWidths[Desc.CharInfo[i].AsciiCode -
   Desc.FirstLetter]:= Desc.CharInfo[i].Width;

 // (8) Indicate that the initialization was successful.
 FInitialized:= True;
end;

//---------------------------------------------------------------------------
procedure TAsphyreNativeFont.Finalize();
begin
 FillChar(FBitmapMetrics, SizeOf(TFontBitmapMetrics), 0);

 FPatternSize:= InfPoint2px;
 FImageIndex := -1;

 FInitialized:= False;
end;

//---------------------------------------------------------------------------
procedure TAsphyreNativeFont.PerformAt(const Text: string;
 const DrawPos: TPoint2px; Colors: TColor2; Tag: Integer;
 Event: TFontPerformEvent);
var
 Index: Integer;
 DrawSize: TPoint2px;
 CharSize: TPoint2px;
 Spacing : Integer;
 AtPos   : TPoint2px;
 CharCode: Integer;
begin
 // The initial drawing position.
 AtPos:= Point2px(DrawPos.x + iMul16(FOptions.Shift.x, FOptions.Scale),
  DrawPos.y + iMul16(FOptions.Shift.y, FOptions.Scale));

 // Precalculate the drawing size of individual patterns.
 DrawSize.x:= iMul16(FPatternSize.x - ConstantPadding, FOptions.Scale);
 DrawSize.y:= iMul16(FPatternSize.y - ConstantPadding, FOptions.Scale);

 // Character height is constant, so it can be precalculated.
 CharSize.y:= DrawSize.y;

 Index:= 1;
 while (Index <= Length(Text)) do
  begin
   // (1) Retreive character code, which is the index to character width
   // array and is the actual pattern to draw.
   CharCode:= Byte(Text[Index]) - FBitmapMetrics.FirstLetter;

   // (2) If there is no width associated with the character, consider it
   // as a blank space.
   if (CharCode < 0)or(CharCode > Length(CharWidths)) then
    begin
     CharCode  := -1;
     CharSize.x:= FBitmapMetrics.BlankSpace;
    end else CharSize.x:= CharWidths[CharCode] + FBitmapMetrics.Interleave;

   // (3) Add kerning, if not the last character to display.
   Spacing:= CharSize.x;
   if (Index < Length(Text)) then Inc(Spacing, FOptions.Kerning);

   // (4) Apply scaling to character width and its spacing.
   CharSize.x:= iMul16(CharSize.x, FOptions.Scale);
   Spacing   := iMul16(Spacing, FOptions.Scale);

   // (5) Call the specified event to do the relevant task.
   Event(Self, Tag, CharCode, Spacing, Bounds(AtPos.x, AtPos.y, DrawSize.x,
    DrawSize.y), CharSize, Colors);

   // (6) Advance both in text string and horizontal position.
   Inc(AtPos.x, Spacing);
   Inc(Index);
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreNativeFont.DrawAtFx(Sender: TObject; Tag, CharCode,
 CharSpacing: Integer; const DrawRect: TRect; const CharSize: TPoint2px;
 const Colors: TColor2);
var
 Image: TAsphyreCustomImage;
begin
 if (CharCode <> -1) then
  begin
   Image:= TAsphyreDevice(FOwner.FDevice).Images[FImageIndex];
   if (Image <> nil) then
    with TAsphyreDevice(FOwner.FDevice).Canvas do
     begin
      UseImage(Image, CharCode);
      TexMap(pRect4(DrawRect), cColor4(Colors[0], Colors[0], Colors[1],
       Colors[1]), Tag);
     end
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreNativeFont.TextOut(const Text: string; x, y: Integer;
 const Colors: TColor2);
var
 AddVec: TPoint2px;
begin
 if (FOptions.ShowShadow) then
  begin
   AddVec.x:= iMul16(FOptions.ShadowDepth.x, FOptions.Scale);
   AddVec.y:= iMul16(FOptions.ShadowDepth.y, FOptions.Scale);

   PerformAt(Text, Point2px(x, y) + AddVec, Colors, fxFullShadow,
    DrawAtFx);
  end;

 PerformAt(Text, Point2px(x, y), Colors, fxFullBlend, DrawAtFx);
end;

//---------------------------------------------------------------------------
procedure TAsphyreNativeFont.TextOut(const Text: string; x, y: Integer;
 Color: Cardinal);
begin
 TextOut(Text, x, y, cColor2(Color));
end;

//---------------------------------------------------------------------------
procedure TAsphyreNativeFont.TextRect(const Text: string;
 const Rect: TRect; HorizontalAlign: THorizontalAlign;
 VerticalAlign: TVerticalAlign; const Colors: TColor2);
var
 Size, DrawPos: TPoint2px;
begin
 Size:= TextExtent(Text);

 case HorizontalAlign of
  haRight:
   DrawPos.x:= Rect.Right - Size.x;

  haCenter:
   DrawPos.x:= Rect.Left + ((Rect.Right - (Rect.Left + Size.x)) div 2);

  else DrawPos.x:= Rect.Left;
 end;

 case VerticalAlign of
  vaBottom:
   DrawPos.y:= Rect.Bottom - Size.y;

  vaCenter:
   DrawPos.y:= Rect.Top + ((Rect.Bottom - (Rect.Top + Size.y)) div 2);

  else DrawPos.x:= Rect.Left;
 end;

 TextOut(Text, DrawPos.x, DrawPos.y, Colors);
end;

//---------------------------------------------------------------------------
procedure TAsphyreNativeFont.EstimateRects(Sender: TObject; Tag,
 CharCode, CharSpacing: Integer; const DrawRect: TRect;
 const CharSize: TPoint2px; const Colors: TColor2);
var
 List: TRectList;
begin
 List:= TRectList(Tag);
 List.Add(DrawRect.Left, DrawRect.Top, CharSize.x, CharSize.y);
end;

//---------------------------------------------------------------------------
procedure TAsphyreNativeFont.TextRects(const Text: string; List: TRectList);
begin
 PerformAt(Text, ZeroPoint2px, clWhite2, Integer(List), EstimateRects);
end;

//---------------------------------------------------------------------------
procedure TAsphyreNativeFont.EstimateSize(Sender: TObject; Tag,
 CharCode, CharSpacing: Integer; const DrawRect: TRect;
 const CharSize: TPoint2px; const Colors: TColor2);
var
 Size: PPoint2px;
begin
 Size:= Pointer(Tag);

 Inc(Size.x, CharSpacing);
 Size.y:= Max2(Size.y, CharSize.y);
end;

//---------------------------------------------------------------------------
function TAsphyreNativeFont.TextExtent(const Text: string): TPoint2px;
begin
 Result:= ZeroPoint2px;
 PerformAt(Text, ZeroPoint2px, clWhite2, Integer(@Result), EstimateSize);
end;

//---------------------------------------------------------------------------
function TAsphyreNativeFont.TextWidth(const Text: string): Integer;
begin
 Result:= TextExtent(Text).x;
end;

//---------------------------------------------------------------------------
function TAsphyreNativeFont.TextHeight(const Text: string): Integer;
begin
 Result:= TextExtent(Text).y;
end;

//---------------------------------------------------------------------------
constructor TAsphyreFonts.Create(ADevice: TObject);
begin
 inherited Create();

 FDevice:= ADevice;
 EventDeviceDestroy.Subscribe(OnDeviceDestroy, FDevice);

 FMediaOption:= '';
 SearchDirty := False;
end;

//---------------------------------------------------------------------------
destructor TAsphyreFonts.Destroy();
begin
 RemoveAll();

 EventDeviceDestroy.Unsubscribe(OnDeviceDestroy);

 inherited;
end;

//---------------------------------------------------------------------------
function TAsphyreFonts.GetCount(): Integer;
begin
 Result:= Length(Data);
end;

//---------------------------------------------------------------------------
function TAsphyreFonts.GetItem(Num: Integer): TAsphyreNativeFont;
begin
 if (Num >= 0)and(Num < Length(Data)) then
  Result:= Data[Num] else Result:= nil;
end;

//---------------------------------------------------------------------------
function TAsphyreFonts.IndexOf(Element: TAsphyreNativeFont): Integer;
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
function TAsphyreFonts.CountSearchObjects(): Integer;
var
 i: Integer;
begin
 Result:= 0;

 for i:= 0 to Length(Data) - 1 do
  if (Data[i] <> nil) then Inc(Result);
end;

//---------------------------------------------------------------------------
procedure TAsphyreFonts.FillSearchObjects(Amount: Integer);
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
procedure TAsphyreFonts.SortSearchObjects(Left, Right: Integer);
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
procedure TAsphyreFonts.PrepareSearchObjects();
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
function TAsphyreFonts.IndexOf(const Name: string): Integer;
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
function TAsphyreFonts.FindEmptySlot(): Integer;
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
function TAsphyreFonts.Insert(Element: TAsphyreNativeFont): Integer;
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
function TAsphyreFonts.Include(Element: TAsphyreNativeFont): Integer;
begin
 Result:= IndexOf(Element);
 if (Result = -1) then Result:= Insert(Element);
end;

//---------------------------------------------------------------------------
procedure TAsphyreFonts.Exclude(Element: TAsphyreNativeFont);
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
procedure TAsphyreFonts.Remove(Num: Integer);
begin
 if (Num < 0)or(Num >= Length(Data)) then Exit;

 Data[Num].NoExclude:= True;
 Data[Num].Free();
 Data[Num]:= nil;

 SearchDirty:= True;
end;

//---------------------------------------------------------------------------
procedure TAsphyreFonts.RemoveAll();
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
function TAsphyreFonts.ResolveFont(Name: string): Integer;
var
 Index  : Integer;
 FontDesc: PFontDesc;
 Instance: TAsphyreNativeFont;
begin
 // (1) Identifiers are not case-sensitive.
 Name:= LowerCase(Name);

 // (2) Check whether the font has been previously loaded
 Index:= IndexOf(Name);
 if (Index <> -1) then
  begin
   Result:= Index;
   Exit;
  end;

 // (3) Determine if description for the font exists.
 FontDesc:= FontGroups.Find(Name, MediaOption);
 if (FontDesc = nil) then
  begin
   EventResolveFailed.Notify(FDevice, Self, PChar(Name));
   Result:= -1;
   Exit;
  end;

 // (4) Create the particular image type.
 Instance:= TAsphyreNativeFont.Create(Self);

 // (5) Notify about symbol load.
 EventSymbolResolve.Notify(FDevice, Self, PChar(Name));

 // (6) Load and initialize image specification.
 Instance.FName:= LowerCase(Name);

 if (not Instance.Initialize(FontDesc)) then
  begin
   EventResolveFailed.Notify(FDevice, Self, PChar(Name));

   Instance.Free();
   Result:= -1;
   Exit;
  end;

 // (7) Ok, we have a new font symbol in the list.
 Result:= Instance.FontIndex;
end;

//---------------------------------------------------------------------------
function TAsphyreFonts.GetFont(const Name: string): TAsphyreNativeFont;
var
 Index: Integer;
begin
 Index:= ResolveFont(Name);
 if (Index <> -1) then Result:= Data[Index] else Result:= nil;
end;

//---------------------------------------------------------------------------
procedure TAsphyreFonts.OnDeviceDestroy(Sender: TObject; EventParam: Pointer;
 var Success: Boolean);
begin
 RemoveAll();
end;

//---------------------------------------------------------------------------
procedure TAsphyreFonts.UnloadGroup(const GroupName: string);
var
 i: Integer;
 Group: TFontGroup;
 Desc: PFontDesc;
begin
 Group:= FontGroups.Group[GroupName];
 if (Group = nil) then Exit;

 for i:= 0 to Length(Data) - 1 do
  begin
   Desc:= Group.Find(Data[i].Name);
   if (Desc <> nil) then Remove(i);
  end;
end;

//---------------------------------------------------------------------------
end.
