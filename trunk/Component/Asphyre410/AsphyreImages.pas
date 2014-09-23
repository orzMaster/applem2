unit AsphyreImages;
//---------------------------------------------------------------------------
// AsphyreImages.pas                                    Modified: 20-Feb-2007
// The implementation of 2D images/texturing                      Version 2.1
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
// The Original Code is AsphyreImages.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Windows, Direct3D9, D3DX9, SysUtils, Vectors2px, AsphyreTypes,
 AsphyreTextures, MediaImages, MediaUtils;

//---------------------------------------------------------------------------
type
 TAsphyreImages = class;

//---------------------------------------------------------------------------
 TAsphyreCustomImage = class
 private
  FOwner: TAsphyreImages;
  FImageIndex: Integer;

  // NoExclude indicates that the component should not exclude itself
  // from the owner.
  NoExclude: Boolean;
 protected
  FName: string;
  FInitialized: Boolean;

  function GetTextureCount(): Integer; virtual;
  function GetTexture(TexNum: Integer): TAsphyreCustomTexture; virtual;
 public
  // The reference to the image holder.
  property Owner: TAsphyreImages read FOwner;

  // The unique image identifier
  property Name: string read FName;

  // The index assigned by the owner.
  property ImageIndex: Integer read FImageIndex;

  // Determines whether the image has been initialized successfully.
  property Initialized: Boolean read FInitialized;

  // Indicates the number of available textures.
  property TextureCount: Integer read GetTextureCount;

  // Retreives the texture for the specific level.
  property Texture[TexNum: Integer]: TAsphyreCustomTexture read GetTexture;

  function Initialize(Desc: PImageDesc): Boolean; virtual; abstract;
  procedure Finalize(); virtual; abstract;

  constructor Create(AOwner: TAsphyreImages); virtual;
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
 TAsphyreImage = class(TAsphyreCustomImage)
 private
  Textures: array of TAsphyrePlainTexture;

  FPatternSize : TPoint2px;
  FPatternCount: Integer;
  FPadding: TPoint2px;

  procedure ReleaseAll();

  procedure SetPatternSize(const Value: TPoint2px);
  procedure SetPadding(const Value: TPoint2px);
  function FindPatternTex(Pattern: Integer; out PatInRow,
   PatInCol: Integer): TAsphyrePlainTexture;
  procedure FindPatternMapping(Pattern, PatInRow, PatInCol: Integer;
   Tex: TAsphyrePlainTexture; Mapping: PPoint4); overload;
  procedure FindPatternMapping(Pattern, PatInRow, PatInCol, AddX, AddY, ViewX,
   ViewY: Integer; Tex: TAsphyrePlainTexture; Mapping: PPoint4); overload;
  function GetVisibleSize(): TPoint2px;
 protected
  function GetTextureCount(): Integer; override;
  function GetTexture(TexNum: Integer): TAsphyreCustomTexture; override;
 public
  // The size of individual sub-images inside the large image. Set to the
  // size of original image if not used; in this case, PatternCount is to
  // be set to 1.
  property PatternSize : TPoint2px read FPatternSize write SetPatternSize;
  property PatternCount: Integer read FPatternCount write FPatternCount;

  // The following parameter indicates how many pixels are skipped both
  // horizontally and vertically when drawing. This way, the image will
  // most likely appear smaller or stretched. The padding is centered
  // around the image so a value of 2 will cut the image by 1 pixel on
  // both left and right sides.
  property Padding: TPoint2px read FPadding write SetPadding;

  // The following property calculates the visible area of the image based
  // on previous padding parameter.
  property VisibleSize: TPoint2px read GetVisibleSize;

  // These routines attempt to find the selected sub-image inside the
  // large image and return its texture. 
  function RetreiveTex(Pattern: Integer;
   Mapping: PPoint4): TAsphyrePlainTexture; overload;
  function RetreiveTex(Pattern: Integer; const SrcRect: TRect;
   Mirror, Flip: Boolean; Mapping: PPoint4): TAsphyrePlainTexture; overload;

  function PatternToCoord(Pattern: Integer): TPoint4px;

  function Initialize(Desc: PImageDesc): Boolean; override;
  procedure Finalize(); override;
 end;

//---------------------------------------------------------------------------
 TAsphyreSurface = class(TAsphyreCustomImage)
 private
  FRenderTarget: TAsphyreRenderTarget;
 protected
  function GetTexture(TexNum: Integer): TAsphyreCustomTexture; override;
 public
  property RenderTarget: TAsphyreRenderTarget read FRenderTarget;

  function Initialize(Desc: PImageDesc): Boolean; override;
  procedure Finalize(); override;
 end;

//---------------------------------------------------------------------------
 TAsphyreDraft = class(TAsphyreCustomImage)
 private
  FDraft: TAsphyreDynamicTexture;
 protected
  function GetTexture(TexNum: Integer): TAsphyreCustomTexture; override;
 public
  property Draft: TAsphyreDynamicTexture read FDraft;

  function Initialize(Desc: PImageDesc): Boolean; override;
  procedure Finalize(); override;
 end;

//---------------------------------------------------------------------------
 TAsphyreImages = class
 private
  FDevice: TObject;
  Data: array of TAsphyreCustomImage;

  SearchObjects: array of Integer;
  SearchDirty  : Boolean;
  FMediaOption : string;

  function GetCount(): Integer;
  function GetItem(Num: Integer): TAsphyreCustomImage;
  function CountSearchObjects(): Integer;
  procedure FillSearchObjects(Amount: Integer);
  procedure SortSearchObjects(Left, Right: Integer);
  procedure PrepareSearchObjects();
  function GetImage(const Name: string): TAsphyreCustomImage;
  procedure OnDeviceLost(Sender: TObject; EventParam: Pointer;
   var Success: Boolean); virtual;
  procedure OnDeviceDestroy(Sender: TObject; EventParam: Pointer;
   var Success: Boolean); virtual;
 protected
  function FindEmptySlot(): Integer;
  function Insert(Element: TAsphyreCustomImage): Integer;
  function Include(Element: TAsphyreCustomImage): Integer;
  procedure Exclude(Element: TAsphyreCustomImage);
  procedure ReleaseVolatileObjects(); virtual;
 public
  property Device: TObject read FDevice;

  property MediaOption: string read FMediaOption write FMediaOption;

  property Count: Integer read GetCount;
  property Items[Num: Integer]: TAsphyreCustomImage read GetItem; default;
  property Image[const Name: string]: TAsphyreCustomImage read GetImage;

  function IndexOf(Element: TAsphyreCustomImage): Integer; overload;
  function IndexOf(const Name: string): Integer; overload;
  procedure Remove(Num: Integer);
  procedure RemoveAll();

  function ResolveImage(Name: string): Integer;

  procedure UnloadGroup(const GroupName: string);

  constructor Create(ADevice: TObject);
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreEvents, AsphyreDevices;

//---------------------------------------------------------------------------
constructor TAsphyreCustomImage.Create(AOwner: TAsphyreImages);
begin
 inherited Create();

 FImageIndex := -1;
 FOwner      := AOwner;
 FInitialized:= False;
 NoExclude   := False;

 if (FOwner <> nil) then FOwner.Insert(Self);
end;

//---------------------------------------------------------------------------
destructor TAsphyreCustomImage.Destroy();
begin
 if (FInitialized) then Finalize();
 if (not NoExclude)and(FOwner <> nil) then FOwner.Exclude(Self);

 inherited;
end;

//---------------------------------------------------------------------------
function TAsphyreCustomImage.GetTextureCount(): Integer;
begin
 Result:= 1;
end;

//---------------------------------------------------------------------------
function TAsphyreCustomImage.GetTexture(TexNum: Integer): TAsphyreCustomTexture;
begin
 Result:= nil;
end;

//---------------------------------------------------------------------------
function TAsphyreImage.GetTextureCount(): Integer;
begin
 Result:= Length(Textures);
end;

//---------------------------------------------------------------------------
function TAsphyreImage.GetTexture(TexNum: Integer): TAsphyreCustomTexture;
begin
 if (TexNum >= 0)and(TexNum < Length(Textures)) then
  Result:= Textures[TexNum] else Result:= nil;
end;

//---------------------------------------------------------------------------
procedure TAsphyreImage.ReleaseAll();
var
 i: Integer;
begin
 for i:= 0 to Length(Textures) - 1 do
  if (Textures[i] <> nil) then
   begin
    Textures[i].Free();
    Textures[i]:= nil;
   end;

 SetLength(Textures, 0);
end;

//---------------------------------------------------------------------------
procedure TAsphyreImage.SetPatternSize(const Value: TPoint2px);
var
 i: Integer;
begin
 FPatternSize:= Value;

 for i:= 0 to Length(Textures) - 1 do
  Textures[i].PatternSize:= Value;
end;

//---------------------------------------------------------------------------
procedure TAsphyreImage.SetPadding(const Value: TPoint2px);
var
 i: Integer;
begin
 FPadding:= Value;

 for i:= 0 to Length(Textures) - 1 do
  Textures[i].Padding:= Value;
end;

//---------------------------------------------------------------------------
function TAsphyreImage.GetVisibleSize(): TPoint2px;
begin
 Result.X:= FPatternSize.X - FPadding.X;
 Result.Y:= FPatternSize.Y - FPadding.Y;
end;

//---------------------------------------------------------------------------
function TAsphyreImage.Initialize(Desc: PImageDesc): Boolean;
var
 i: Integer;
begin
 Result:= False;
 if (FOwner = nil)or(not (FOwner is TAsphyreImages)) then Exit;

 // (1) Specify pattern information.
 FPatternSize := Desc.PatSize;
 FPatternCount:= Desc.PatCount;
 FPadding:= Desc.PatPadSize;

 // (2) Create individual textures.
 SetLength(Textures, Length(Desc.Textures));

 for i:= 0 to Length(Textures) - 1 do
  begin
   Textures[i]:= TAsphyrePlainTexture.Create(Owner.Device);
   Textures[i].PatternSize:= Desc.PatSize;
   Textures[i].Format     := Desc.Format;
   Textures[i].MipLevels  := Desc.MipLevels;
   Textures[i].Padding    := Desc.PatPadSize;

   Result:= Textures[i].InitializeEx(Desc.Textures[i], Desc.ColorKey);
   if (not Result) then
    begin
     ReleaseAll();
     Break;
    end;
  end;

 FInitialized:= Result;
end;

//---------------------------------------------------------------------------
procedure TAsphyreImage.Finalize();
begin
 ReleaseAll();
 FInitialized:= False;
end;

//---------------------------------------------------------------------------
function TAsphyreImage.PatternToCoord(Pattern: Integer): TPoint4px;
var
 PatInRow, PatInCol, x1, y1, x2, y2: Integer;
begin
 if (Length(Textures) < 1) then
  begin
   Result:= TexZero4px;
   Exit;
  end;

 PatInRow:= Textures[0].OrigSize.X div FPatternSize.X;
 PatInCol:= Textures[0].OrigSize.Y div FPatternSize.Y;

 x1:= (Pattern mod PatInRow) * FPatternSize.X + (FPadding.X div 2);
 y1:= ((Pattern div PatInRow) mod PatInCol) * FPatternSize.Y + (FPadding.Y div 2);
 x2:= x1 + FPatternSize.X - FPadding.X;
 y2:= y1 + FPatternSize.Y - FPadding.Y;

 Result[0].x:= x1;
 Result[0].y:= y1;
 Result[1].x:= x2;
 Result[1].y:= y1;
 Result[2].x:= x2;
 Result[2].y:= y2;
 Result[3].x:= x1;
 Result[3].y:= y2;
end;

//---------------------------------------------------------------------------
function TAsphyreImage.FindPatternTex(Pattern: Integer; out PatInRow,
 PatInCol: Integer): TAsphyrePlainTexture;
var
 TexIndex, PatInTex: Integer;
begin
 TexIndex:= 0;
 PatInTex:= -1;
 PatInRow:= 1;
 PatInCol:= 1;

 // Cycle through textures to find where Pattern is located.
 while (TexIndex < Length(Textures)) do
  begin
   PatInRow:= Textures[TexIndex].OrigSize.X div FPatternSize.X;
   PatInCol:= Textures[TexIndex].OrigSize.Y div FPatternSize.Y;
   PatInTex:= PatInRow * PatInCol;

   if (Pattern >= PatInTex) then
    begin
     Inc(TexIndex);
     Dec(Pattern, PatInTex);
    end else Break;
  end;

 // If couldn't find the desired texture, just exit.
 if (TexIndex >= Length(Textures))or(Pattern >= PatInTex) then
  begin
   Result:= nil;
   Exit;
  end;

 Result:= Textures[TexIndex];
end;

//---------------------------------------------------------------------------
procedure TAsphyreImage.FindPatternMapping(Pattern, PatInRow,
 PatInCol: Integer; Tex: TAsphyrePlainTexture; Mapping: PPoint4);
var
 SrcX, SrcY, EndX, EndY: Integer;
begin
 SrcX:= (Pattern mod PatInRow) * FPatternSize.X + (FPadding.X div 2);
 SrcY:= ((Pattern div PatInRow) mod PatInCol) * FPatternSize.Y + (FPadding.Y div 2);
 EndX:= SrcX + FPatternSize.X - FPadding.X;
 EndY:= SrcY + FPatternSize.Y - FPadding.Y;

 Mapping[0].x:= SrcX / Tex.OrigSize.X;
 Mapping[0].y:= SrcY / Tex.OrigSize.Y;

 Mapping[1].x:= EndX / Tex.OrigSize.X;
 Mapping[1].y:= Mapping[0].y;

 Mapping[2].x:= Mapping[1].x;
 Mapping[2].y:= EndY / Tex.OrigSize.Y;

 Mapping[3].x:= Mapping[0].x;
 Mapping[3].y:= Mapping[2].y;
end;

//---------------------------------------------------------------------------
procedure TAsphyreImage.FindPatternMapping(Pattern, PatInRow,
 PatInCol, AddX, AddY, ViewX, ViewY: Integer; Tex: TAsphyrePlainTexture;
 Mapping: PPoint4);
var
 SrcX, SrcY, EndX, EndY: Integer;
begin
 SrcX:= (Pattern mod PatInRow) * FPatternSize.X + (FPadding.X div 2) + AddX;
 SrcY:= ((Pattern div PatInRow) mod PatInCol) * FPatternSize.Y +
  (FPadding.Y div 2) + AddY;
 EndX:= SrcX + ViewX - FPadding.X;
 EndY:= SrcY + ViewY - FPadding.Y;

 Mapping[0].x:= SrcX / Tex.OrigSize.X;
 Mapping[0].y:= SrcY / Tex.OrigSize.Y;

 Mapping[1].x:= EndX / Tex.OrigSize.X;
 Mapping[1].y:= Mapping[0].y;

 Mapping[2].x:= Mapping[1].x;
 Mapping[2].y:= EndY / Tex.OrigSize.Y;

 Mapping[3].x:= Mapping[0].x;
 Mapping[3].y:= Mapping[2].y;
end;

//---------------------------------------------------------------------------
function TAsphyreImage.RetreiveTex(Pattern: Integer;
 Mapping: PPoint4): TAsphyrePlainTexture;
var
 PatInRow, PatInCol: Integer;
begin
 Result:= FindPatternTex(Pattern, PatInRow, PatInCol);
 if (Result = nil) then Exit;

 FindPatternMapping(Pattern, PatInRow, PatInCol, Result, Mapping);
end;

//---------------------------------------------------------------------------
function TAsphyreImage.RetreiveTex(Pattern: Integer; const SrcRect: TRect;
 Mirror, Flip: Boolean; Mapping: PPoint4): TAsphyrePlainTexture;
var
 PatInRow, PatInCol: Integer;
 Aux: Single;
begin
 Result:= FindPatternTex(Pattern, PatInRow, PatInCol);
 if (Result = nil) then Exit;

 FindPatternMapping(Pattern, PatInRow, PatInCol, SrcRect.Left, SrcRect.Top,
  SrcRect.Right - SrcRect.Left, SrcRect.Bottom - SrcRect.Top, Result, Mapping);

 if (Mirror) then
  begin
   Aux:= Mapping[0].x;

   Mapping[0].x:= Mapping[1].x;
   Mapping[3].x:= Mapping[1].x;
   Mapping[1].x:= Aux;
   Mapping[2].x:= Aux;
  end;
 if (Flip) then
  begin
   Aux:= Mapping[0].y;

   Mapping[0].y:= Mapping[2].y;
   Mapping[1].y:= Mapping[2].y;
   Mapping[2].y:= Aux;
   Mapping[3].y:= Aux;
  end;
end;

//---------------------------------------------------------------------------
function TAsphyreSurface.Initialize(Desc: PImageDesc): Boolean;
begin
 if (FOwner = nil)or(not (FOwner is TAsphyreImages)) then
  begin
   Result:= False;
   Exit;
  end;

 FRenderTarget:= TAsphyreRenderTarget.Create(FOwner.Device);
 FRenderTarget.Size     := Desc.Size;
 FRenderTarget.Format   := Desc.Format;
 FRenderTarget.MipLevels:= Desc.MipLevels;
 FRenderTarget.UseDepthStencil:= Desc.DepthStencil;

 Result:= FRenderTarget.Initialize();
 if (not Result) then
  begin
   FRenderTarget.Free();
   FRenderTarget:= nil;
  end;

 FInitialized:= Result;
end;

//---------------------------------------------------------------------------
procedure TAsphyreSurface.Finalize();
begin
 if (FRenderTarget <> nil) then
  begin
   FRenderTarget.Free();
   FRenderTarget:= nil;
  end;

 FInitialized:= False;
end;

//---------------------------------------------------------------------------
function TAsphyreSurface.GetTexture(TexNum: Integer): TAsphyreCustomTexture;
begin
 Result:= FRenderTarget;
end;

//---------------------------------------------------------------------------
function TAsphyreDraft.Initialize(Desc: PImageDesc): Boolean;
begin
 if (FOwner = nil)or(not (FOwner is TAsphyreImages)) then
  begin
   Result:= False;
   Exit;
  end;

 FDraft:= TAsphyreDynamicTexture.Create(FOwner.Device);
 FDraft.Size     := Desc.Size;
 FDraft.Format   := Desc.Format;
 FDraft.MipLevels:= Desc.MipLevels;

 Result:= FDraft.Initialize();
 if (not Result) then
  begin
   FDraft.Free();
   FDraft:= nil;
  end;

 FInitialized:= Result;
end;

//---------------------------------------------------------------------------
procedure TAsphyreDraft.Finalize();
begin
 if (FDraft <> nil) then
  begin
   FDraft.Free();
   FDraft:= nil;
  end;

 FInitialized:= False;
end;

//---------------------------------------------------------------------------
function TAsphyreDraft.GetTexture(TexNum: Integer): TAsphyreCustomTexture;
begin
 Result:= FDraft;
end;

//---------------------------------------------------------------------------
constructor TAsphyreImages.Create(ADevice: TObject);
begin
 inherited Create();

 FDevice:= ADevice;

 EventDeviceLost.Subscribe(OnDeviceLost, FDevice);
 EventDeviceDestroy.Subscribe(OnDeviceDestroy, FDevice);

 FMediaOption:= '';
 SearchDirty := False;
end;

//---------------------------------------------------------------------------
destructor TAsphyreImages.Destroy();
begin
 RemoveAll();

 EventDeviceDestroy.Unsubscribe(OnDeviceDestroy);
 EventDeviceLost.Unsubscribe(OnDeviceLost);

 inherited;
end;

//---------------------------------------------------------------------------
function TAsphyreImages.GetCount(): Integer;
begin
 Result:= Length(Data);
end;

//---------------------------------------------------------------------------
function TAsphyreImages.GetItem(Num: Integer): TAsphyreCustomImage;
begin
 if ((Num >= 0)and(Num < Length(Data))) then
  Result:= Data[Num] else Result:= nil;
end;

//---------------------------------------------------------------------------
function TAsphyreImages.IndexOf(Element: TAsphyreCustomImage): Integer;
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
function TAsphyreImages.CountSearchObjects(): Integer;
var
 i: Integer;
begin
 Result:= 0;

 for i:= 0 to Length(Data) - 1 do
  if (Data[i] <> nil) then Inc(Result);
end;

//---------------------------------------------------------------------------
procedure TAsphyreImages.FillSearchObjects(Amount: Integer);
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
procedure TAsphyreImages.SortSearchObjects(Left, Right: Integer);
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
procedure TAsphyreImages.PrepareSearchObjects();
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
function TAsphyreImages.IndexOf(const Name: string): Integer;
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
function TAsphyreImages.FindEmptySlot(): Integer;
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
function TAsphyreImages.Insert(Element: TAsphyreCustomImage): Integer;
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
 Element.FImageIndex:= Slot;

 SearchDirty:= True;
 Result:= Slot;
end;

//---------------------------------------------------------------------------
function TAsphyreImages.Include(Element: TAsphyreCustomImage): Integer;
begin
 Result:= IndexOf(Element);
 if (Result = -1) then Result:= Insert(Element);
end;

//---------------------------------------------------------------------------
procedure TAsphyreImages.Exclude(Element: TAsphyreCustomImage);
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
procedure TAsphyreImages.Remove(Num: Integer);
begin
 if (Num < 0)or(Num >= Length(Data)) then Exit;

 Data[Num].NoExclude:= True;
 Data[Num].Free();
 Data[Num]:= nil;

 SearchDirty:= True;
end;

//---------------------------------------------------------------------------
procedure TAsphyreImages.RemoveAll();
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
function TAsphyreImages.ResolveImage(Name: string): Integer;
var
 Index: Integer;
 ImageDesc: PImageDesc;
 Instance : TAsphyreCustomImage;
begin
 // (1) Identifiers are not case-sensitive.
 Name:= LowerCase(Name);

 // (2) Check whether the image has been previously loaded
 Index:= IndexOf(Name);
 if (Index <> -1) then
  begin
   Result:= Index;
   Exit;
  end;

 // (3) Determine if description for the image exists.
 ImageDesc:= ImageGroups.Find(Name, MediaOption);
 if (ImageDesc = nil) then
  begin
   EventResolveFailed.Notify(FDevice, Self, PChar(Name));

   Result:= -1;
   Exit;
  end;

 // (5) Create the particular image type.
 Instance:= nil;
 case ImageDesc.DescType of
  idtImage:
   Instance:= TAsphyreImage.Create(Self);

  idtSurface:
   Instance:= TAsphyreSurface.Create(Self);

  idtDraft:
   Instance:= TAsphyreDraft.Create(Self);
 end;

 // (6) Notify about symbol load.
 EventSymbolResolve.Notify(FDevice, Self, PChar(Name));

 // (7) Load and initialize image specification.
 Instance.FName:= LowerCase(Name);

 if (not Instance.Initialize(ImageDesc)) then
  begin
   EventResolveFailed.Notify(FDevice, Self, PChar(Name));

   Instance.Free();
   Result:= -1;
   Exit;
  end;

 // (8) Ok, we have a new image symbol in the list.
 Result:= Instance.ImageIndex;
end;

//---------------------------------------------------------------------------
function TAsphyreImages.GetImage(const Name: string): TAsphyreCustomImage;
var
 Index: Integer;
begin
 Index:= ResolveImage(Name);
 if (Index <> -1) then Result:= Data[Index] else Result:= nil;
end;

//---------------------------------------------------------------------------
procedure TAsphyreImages.ReleaseVolatileObjects();
var
 i: Integer;
begin
 for i:= 0 to Length(Data) - 1 do
  if (Data[i] <> nil)and((Data[i] is TAsphyreSurface)or
   (Data[i] is TAsphyreDraft)) then
   begin
    Data[i].NoExclude:= True;
    Data[i].Free();
    Data[i]:= nil;
   end;

 SearchDirty:= True;
end;

//---------------------------------------------------------------------------
procedure TAsphyreImages.OnDeviceLost(Sender: TObject; EventParam: Pointer;
 var Success: Boolean);
begin
 ReleaseVolatileObjects();
end;

//---------------------------------------------------------------------------
procedure TAsphyreImages.OnDeviceDestroy(Sender: TObject; EventParam: Pointer;
 var Success: Boolean);
begin
 RemoveAll();
end;

//---------------------------------------------------------------------------
procedure TAsphyreImages.UnloadGroup(const GroupName: string);
var
 i: Integer;
 Group: TImageGroup;
 Desc: PImageDesc;
begin
 Group:= ImageGroups.Group[GroupName];
 if (Group = nil) then Exit;

 for i:= 0 to Length(Data) - 1 do
  begin
   Desc:= Group.Find(Data[i].Name);
   if (Desc <> nil) then Remove(i);
  end;
end;

//---------------------------------------------------------------------------
end.
