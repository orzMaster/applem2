unit WIL;

interface
uses
  Windows, Classes, Graphics, SysUtils, MyDirect3D9, TDX9Textures, HUtil32, ZLIB;

{$INCLUDE BitChange.inc}

type
  TWILColorFormat = (WILFMT_A4R4G4B4, WILFMT_A1R5G5B5, WILFMT_R5G6B5, WILFMT_A8R8G8B8);

const
  MAXIMAGECOUNT = 10000000;
  MINIMAGESIZE = 2;
  MAXIMAGESIZE = 4095;
  //位移宽高，进行加密
  //图像最大宽高不能大于 4095 不然会出错，要修改位移时的处理

  FILETYPE_IMAGE = $1F; //图像文件
  FILETYPE_DATA = $2F; //数据文件
  FILETYPE_WAVA = $3F; //WAVA文件
  FILETYPE_MP3 = $4F; //MP3文件

  ColorFormat: array[TWILColorFormat] of _D3DFORMAT = (D3DFMT_A4R4G4B4, D3DFMT_A1R5G5B5, D3DFMT_R5G6B5, D3DFMT_A8R8G8B8);

type
  PRGBQuads = ^TRGBQuads;
  TRGBQuads = array[0..255] of TRGBQuad;

  TColorEffect = (ceNone, ceGrayScale, ceBright, ceRed, ceGreen, ceBlue, ceYellow, ceFuchsia);
  TDataType = (dtAll, dtMusic, dtData, dtMP3, dtWav);

  TLibType = (ltLoadBmp, ltUseCache, ltFileData);

  TWILType = (t_wmM2Def, t_wmM2Def16, t_wmM2wis, t_wmMyImage, t_wmM3Def, t_wmWoool, t_wm521g, t_wmM2Zip, t_wmM3Zip);

  TZIPLevel = 0..9;

  pTDXTextureSurface = ^TDXTextureSurface;
  TDXTextureSurface = packed record
    nPx: SmallInt;
    nPy: SmallInt;
    Surface: TDXImageTexture;
    dwLatestTime: LongWord;
    boNotRead: Boolean;
  end;

  TDXTextureInfo = record
    nWidth: Word;
    nHeight: Word;
    px: smallint;
    py: smallint;
  end;
  pTDXTextureInfo = ^TDXTextureInfo;

  TWMBaseImages = class
  private
    FAutoFreeMemorys: Boolean;
    FAutoFreeMemorysTick: LongWord;
    FAutoFreeMemorysTime: LongWord;
    FFreeSurfaceTick: LongWord;
    function GetImageSurface(index: integer): TDXImageTexture;
{$IFDEF WORKFILE}
    function GetImageBitmap(index: integer; out btType: Byte): TBitmap;
{$ENDIF}
    function GetMemoryStream(index: integer): TMemoryStream;
  protected
    FLibType: TLibType;
    FBoChangeAlpha: Boolean;
    FSurfaceCount: Integer;
{$IFDEF WORKFILE}
    FLastImageInfo: TDXTextureInfo;
    FLastColorFormat: TWILColorFormat;
{$ENDIF}
    FFileName: string;
    FPassword: string;
    //FFormatName: string;
    FInitialize: Boolean;
    FImageCount: integer;
    FReadOnly: Boolean;
    FboEncryVer: Boolean;
    FFileStream: TFileStream;
    FDxTextureArr: array of TDXTextureSurface;

{$IFDEF WORKFILE}
    function GetImageBitmapEx(index: integer; out btType: Byte): TBitmap; dynamic;
{$ENDIF}
    function InitializeTexture(): Boolean;
    procedure LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface); dynamic;
    function GetStream(index: integer): TMemoryStream; dynamic;
    function GetFormatBitLen(AFormat: TWILColorFormat): Byte;
  public
    FIndexList: TList;
    m_DefMainPalette: TRgbQuads;
    constructor Create(); dynamic;
    destructor Destroy; override;

    function Initialize(): Boolean; dynamic;
    procedure Finalize; dynamic;
    procedure FreeTexture;
    procedure FreeTextureByTime;
    function GetDataStream(index: Integer; DataType: TDataType): TMemoryStream; dynamic;

    function GetCachedImage(index: integer; var px, py: integer): TDXImageTexture;

{$IFDEF WORKFILE}
    procedure DrawZoom(paper: TCanvas; x, y, index: integer; zoom: Real);
    procedure DrawZoomEx(paper: TCanvas; x, y, index: integer; zoom: Real; leftzero: Boolean);
    function CopyDataToTexture(index: integer; Texture: TDXImageTexture): Boolean; dynamic;
    function GetDataType(index: Integer): Integer; dynamic;
    property Bitmap[index: integer; out btType: Byte]: TBitmap read GetImageBitmap;

    procedure AddIndex(nIndex, nOffset: Integer); dynamic;
    function SaveIndexList(): Boolean; dynamic;
    property LastImageInfo: TDXTextureInfo read FLastImageInfo;
    property LastColorFormat: TWILColorFormat read FLastColorFormat;
    property FileStream: TFileStream read FFileStream;
{$ENDIF}

    property boInitialize: Boolean read FInitialize;
    property ImageCount: integer read FImageCount;
    property FileName: string read FFileName write FFileName;
    property Password: string read FPassword write FPassword;
    property LibType: TLibType read FLibType write FLibType;
    property EncryVer: Boolean read FboEncryVer;
    property SurfaceCount: Integer read FSurfaceCount;
//    property ChangeAlpha: Boolean read FBoChangeAlpha write FBoChangeAlpha;
    //property FormatName: string read FFormatName;
    property ReadOnly: Boolean read FReadOnly;
    property Images[index: integer]: TDXImageTexture read GetImageSurface;
    property Files[index: integer]: TMemoryStream read GetMemoryStream;

    property AutoFreeMemorys: Boolean read FAutoFreeMemorys write FAutoFreeMemorys;
    property AutoFreeMemorysTick: LongWord read FAutoFreeMemorysTick write FAutoFreeMemorysTick;
    property FreeSurfaceTick: LongWord read FFreeSurfaceTick write FFreeSurfaceTick;
  end;

  TWMImages = TWMBaseImages;

procedure LineX8_A1R5G5B5(Source, Dest: Pointer; Count: Integer);
procedure LineR5G6B5_A1R5G5B5(Source, Dest: Pointer; Count: Integer);
function CreateWMImages(WILType: TWILType): TWMBaseImages;
function ZIPCompress(const InBuf: Pointer; InBytes: Integer; Level: TZIPLevel; out OutBuf: PChar): Integer;
function ZIPDecompress(const InBuf: Pointer; InBytes: Integer; OutEstimate: Integer; out OutBuf: PChar): Integer;
function MakeDXImageTexture(nWidth, nHeight: Word; WILColorFormat: TWILColorFormat): TDXImageTexture;
function WidthBytes(nBit, nWidth: Integer): Integer;
//function WidthBytes16(w: Integer): Integer;

implementation

uses
  wmM2Def, wmM2Wis, wmMyImage, wmM2Zip, wmM3Zip
{$IFDEF WORKFILE}
  , wmM3Def, wmWoool, wm521g;
{$ELSE}
  ;
{$ENDIF}

function WidthBytes(nBit, nWidth: Integer): Integer;
begin
  Result := (((nWidth * nBit) + 31) shr 5) * 4;
end;
{
function WidthBytes16(w: Integer): Integer;
begin
  Result := (((w * 16) + 31) shr 5) * 4;
end;  }

function CreateWMImages(WILType: TWILType): TWMBaseImages;
begin
  Result := nil;
  case WILType of
    t_wmM2Def: Result := TWMM2DefImages.Create;
    t_wmM2Def16: Result := TWMM2DefBit16Images.Create;
    t_wmM2wis: Result := TWMM2WisImages.Create;
    t_wmMyImage: Result := TWMMyImageImages.Create;
{$IFDEF WORKFILE}
    t_wmM3Def: Result := TWMM3DefImages.Create;
    t_wmWoool: Result := TWMWoolDefImages.Create;
    t_wm521g: Result := TWM521gDefImages.Create;
{$ENDIF}
    t_wmM2Zip: Result := TWMM2ZipImages.Create;
    t_wmM3Zip: Result := TWMM3ZipImages.Create;
  end;
end;

function CCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then
    raise ECompressionError.Create('ZIP Error'); //!!
end;

function DCheck(code: Integer): Integer;
begin
  Result := code;
  if code < 0 then
    raise EDecompressionError.Create('ZIP Error'); //!!
end;

function ZIPCompress(const InBuf: Pointer; InBytes: Integer; Level: TZIPLevel; out OutBuf: PChar): Integer;
var
  strm: TZStreamRec;
  P: Pointer;
begin
  SafeFillChar(strm, sizeof(strm), 0);
  strm.zalloc := zlibAllocMem;
  strm.zfree := zlibFreeMem;
  Result := ((InBytes + (InBytes div 10) + 12) + 255) and not 255;
  GetMem(OutBuf, Result);
  try
    strm.next_in := InBuf;
    strm.avail_in := InBytes;
    strm.next_out := OutBuf;
    strm.avail_out := Result;
    CCheck(deflateInit_(strm, Level, zlib_version, sizeof(strm)));
    try
      while CCheck(deflate(strm, Z_FINISH)) <> Z_STREAM_END do begin
        P := OutBuf;
        Inc(Result, 256);
        ReallocMem(OutBuf, Result);
        strm.next_out := PChar(Integer(OutBuf) + (Integer(strm.next_out) - Integer(P)));
        strm.avail_out := 256;
      end;
    finally
      CCheck(deflateEnd(strm));
    end;
    ReallocMem(OutBuf, strm.total_out);
    Result := strm.total_out;
  except
    FreeMem(OutBuf);
    OutBuf := nil;
    //raise
  end;
end;

function ZIPDecompress(const InBuf: Pointer; InBytes: Integer; OutEstimate: Integer; out OutBuf: PChar): Integer;
var
  strm: TZStreamRec;
  P: Pointer;
  BufInc: Integer;
begin
  SafeFillChar(strm, sizeof(strm), 0);
  strm.zalloc := zlibAllocMem;
  strm.zfree := zlibFreeMem;
  BufInc := (InBytes + 255) and not 255;
  if OutEstimate = 0 then
    Result := BufInc
  else
    Result := OutEstimate;
  GetMem(OutBuf, Result);
  try
    strm.next_in := InBuf;
    strm.avail_in := InBytes;
    strm.next_out := OutBuf;
    strm.avail_out := Result;
    DCheck(inflateInit_(strm, zlib_version, sizeof(strm)));
    try
      while DCheck(inflate(strm, Z_FINISH)) <> Z_STREAM_END do begin
        P := OutBuf;
        Inc(Result, BufInc);
        ReallocMem(OutBuf, Result);
        strm.next_out := PChar(Integer(OutBuf) + (Integer(strm.next_out) - Integer(P)));
        strm.avail_out := BufInc;
      end;
    finally
      DCheck(inflateEnd(strm));
    end;
    ReallocMem(OutBuf, strm.total_out);
    Result := strm.total_out;
  except
    FreeMem(OutBuf);
    OutBuf := nil;
    //raise
  end;
end;

procedure LineR5G6B5_A1R5G5B5(Source, Dest: Pointer; Count: Integer);
begin
  asm
    push esi
    push edi
    push ebx
    push edx

    mov esi, Source
    mov edi, Dest
    mov ecx, Count
    lea edx, R5G6B5_A1R5G5B5

  @pixloop:
    movzx eax, [esi].Word
    add esi, 2

    shl eax, 1
    mov ax, [edx+eax].word

    mov [edi], ax
    add edi, 2

    dec ecx
    jnz @pixloop

    pop edx
    pop ebx
    pop edi
    pop esi
  end;
end;

procedure LineX8_A1R5G5B5(Source, Dest: Pointer; Count: Integer);
begin
  asm
    push esi
    push edi
    push ebx
    push edx

    mov esi, Source
    mov edi, Dest
    mov ecx, Count
    lea edx, X8_A1R5G5B5

  @pixloop:
    movzx eax, [esi].byte
    add esi, 1

    shl eax, 1
    mov ax, [edx+eax].word

    mov [edi], ax
    add edi, 2

    dec ecx
    jnz @pixloop

    pop edx
    pop ebx
    pop edi
    pop esi
  end;
end;

{ TWMBaseImages }

constructor TWMBaseImages.Create;
begin
  inherited;
  FInitialize := False;
  FImageCount := 0;
  FFileName := '';
  FReadOnly := True;
  FAutoFreeMemorys := False;
  FAutoFreeMemorysTick := 10 * 1000;
  FFreeSurfaceTick := 60 * 1000;
  FAutoFreeMemorysTime := GetTickCount;
  FFileStream := nil;
  FDxTextureArr := nil;
  FIndexList := TList.Create;
  //FBoChangeAlpha := False;
  FSurfaceCount := 0;
  FPassword := '';
  //FFormatName := '未知';
{$IFDEF WORKFILE}
  SafeFillChar(FLastImageInfo, SizeOf(FLastImageInfo), #0);
{$ENDIF}
  FLibType := ltUseCache;
end;

procedure TWMBaseImages.FreeTexture;
var
  i: integer;
begin
  if FDxTextureArr <> nil then
    for I := 0 to High(FDxTextureArr) do begin
      if FDxTextureArr[I].Surface <> nil then begin
        FDxTextureArr[I].Surface.Free;
        FDxTextureArr[I].Surface := nil;
      end;
    end;
  FSurfaceCount := 0;
end;

procedure TWMBaseImages.FreeTextureByTime;
var
  i: integer;
begin
  if FDxTextureArr <> nil then
    for I := 0 to High(FDxTextureArr) do begin
      if (FDxTextureArr[I].Surface <> nil) and (GetTickCount - FDxTextureArr[I].dwLatestTime > FFreeSurfaceTick) then begin
        if FSurfaceCount > 0 then
          Dec(FSurfaceCount);
        FDxTextureArr[I].Surface.Free;
        FDxTextureArr[I].Surface := nil;
      end;
    end;
end;

destructor TWMBaseImages.Destroy;
begin
  Finalize;
  FDxTextureArr := nil;
  FIndexList.Free;
  inherited;
end;

function TWMBaseImages.GetCachedImage(index: integer; var px, py: integer): TDXImageTexture;
begin
  Result := nil;
  if (index < 0) or (index >= FImageCount) or (FLibType <> ltUseCache) or (not FInitialize) then
    exit;
  if (index < FIndexList.Count) then begin
    if (FDxTextureArr[index].Surface = nil) and (not FDxTextureArr[index].boNotRead) then begin
      try
        LoadDxImage(index, Integer(FIndexList[index]), @FDxTextureArr[index]);
        if FDxTextureArr[index].Surface <> nil then
          Inc(FSurfaceCount);
      except
        FDxTextureArr[index].Surface := nil;
        FDxTextureArr[index].boNotRead := True;
      end;
    end;
    Result := FDxTextureArr[index].Surface;
    px := FDxTextureArr[index].nPx;
    py := FDxTextureArr[index].nPy;
    FDxTextureArr[index].dwLatestTime := GetTickCount;
  end;
  if AutoFreeMemorys and (GetTickCount > FAutoFreeMemorysTime) then begin
    FAutoFreeMemorysTime := GetTickCount + FAutoFreeMemorysTick;
    FreeTextureByTime;
  end;
end;

function TWMBaseImages.GetDataStream(index: Integer; DataType: TDataType): TMemoryStream;
begin
  Result := nil;
end;

procedure TWMBaseImages.Finalize;
begin
  FInitialize := False;
  FreeTexture;
  FDxTextureArr := nil;
  FSurfaceCount := 0;
  if FFileStream <> nil then
    FFileStream.Free;
  FFileStream := nil;
end;

function TWMBaseImages.GetImageSurface(index: integer): TDXImageTexture;
var
  px, py: Integer;
begin
  Result := GetCachedImage(index, px, py);
end;

function TWMBaseImages.GetMemoryStream(index: integer): TMemoryStream;
begin
  Result := GetStream(index);
end;

function TWMBaseImages.GetStream(index: integer): TMemoryStream;
begin
  Result := nil;
end;

function TWMBaseImages.GetFormatBitLen(AFormat: TWILColorFormat): Byte;
begin
  if AFormat in [WILFMT_A4R4G4B4, WILFMT_A1R5G5B5, WILFMT_R5G6B5] then
    Result := 2
  else
    Result := 4;
end;

function TWMBaseImages.Initialize: Boolean;
begin
  Result := False;
  if (FFileName = '') or FInitialize or (FFileStream <> nil) or (not FileExists(FFileName)) then
    exit;
{$IFDEF WORKFILE}
  if FReadOnly then
    FFileStream := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyNone)
  else
    FFileStream := TFileStream.Create(FFileName, fmOpenReadWrite or fmShareDenyNone);
{$ELSE}
  FFileStream := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyNone);
{$ENDIF}
  Result := FFileStream <> nil;
  FInitialize := Result;
  if Result then begin
    FreeTexture;
    FDxTextureArr := nil;
    FSurfaceCount := 0;
  end;
end;

function TWMBaseImages.InitializeTexture: Boolean;
begin
  Result := False;
  FDxTextureArr := nil;
  if (not FInitialize) or (FImageCount <= 0) or (LibType <> ltUseCache) then
    exit;
  SetLength(FDxTextureArr, FImageCount);
  SafeFillChar(FDxTextureArr[0], FImageCount * SizeOf(TDXTextureSurface), #0);
  Result := True;
end;

procedure TWMBaseImages.LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface);
begin
  if pDXTexture.Surface <> nil then
    pDXTexture.Surface.Free;
  pDXTexture.Surface := nil;
  pDXTexture.boNotRead := True;
end;

function MakeDXImageTexture(nWidth, nHeight: Word; WILColorFormat: TWILColorFormat): TDXImageTexture;
{ function GetSize(nOldSize: Word): Word;
 begin
   if nOldSize < 2 then begin
     Result := 2;
   end else
   if nOldSize < 4 then begin
     Result := 4;
   end else
   if nOldSize < 8 then begin
     Result :=8;
   end else
   if nOldSize < 16 then begin
     Result := 16;
   end else
   if nOldSize < 32 then begin
     Result := 32;
   end else
   if nOldSize < 64 then begin
     Result := 64;
   end else
   if nOldSize < 128 then begin
     Result := 128;
   end else
   if nOldSize < 256 then begin
     Result := 256;
   end else
   if nOldSize < 512 then begin
     Result := 512;
   end else
   if nOldSize < 1024 then begin
     Result := 1024;
   end else
   if nOldSize < 2048 then begin
     Result := 2048;
   end;
 end;      }
begin
  Result := TDXImageTexture.Create;
  with Result do begin
    //Behavior := tbDynamic;
    //Size := Point(GetSize(nWidth), GetSize(nHeight));
    Size := Point(nWidth, nHeight);
    PatternSize := Point(nWidth, nHeight);
    Format := {D3DFMT_A4R4G4B4} ColorFormat[WILColorFormat];
    Active := True;
  end;
  if not Result.Active then begin
    Result.Free;
    Result := nil;
  end;
end;

//工作区-----------------------------------------------------------------------------------------------------------------
{$IFDEF WORKFILE}

procedure TWMBaseImages.DrawZoom(paper: TCanvas; x, y, index: integer; zoom: Real);
var
  rc: TRect;
  bmp: TBitmap;
  btType: Byte;
begin
  if LibType <> ltLoadBmp then exit;
  bmp := Self.Bitmap[index, btType];
  if bmp <> nil then begin
    rc.Left := x;
    rc.Top := y;
    rc.Right := x + Round(bmp.Width * zoom);
    rc.Bottom := y + Round(bmp.Height * zoom);
    if (rc.Right > rc.Left) and (rc.Bottom > rc.Top) then begin
      paper.StretchDraw(rc, Bmp);
      //FreeBitmap(index);
    end;
    bmp.Free;
  end;
end;

procedure TWMBaseImages.DrawZoomEx(paper: TCanvas; x, y, index: integer; zoom: Real; leftzero: Boolean);
var
  rc: TRect;
  bmp, bmp2: TBitmap;
  btType: Byte;
begin
  if LibType <> ltLoadBmp then exit;
  bmp := Self.Bitmap[index, btType];
  if bmp <> nil then begin
    Bmp2 := TBitmap.Create;
    Bmp2.Width := Round(Bmp.Width * zoom);
    Bmp2.Height := Round(Bmp.Height * zoom);
    rc.Left := x;
    rc.Top := y;
    rc.Right := x + Round(bmp.Width * zoom);
    rc.Bottom := y + Round(bmp.Height * zoom);
    if (rc.Right > rc.Left) and (rc.Bottom > rc.Top) then begin
      Bmp2.Canvas.StretchDraw(Rect(0, 0, Bmp2.Width, Bmp2.Height), Bmp);
      if leftzero then begin
        SpliteBitmap(paper.Handle, X, Y, Bmp2, $0)
      end
      else begin
        SpliteBitmap(paper.Handle, X, Y - Bmp2.Height, Bmp2, $0);
      end;
    end;
    bmp.Free;
    bmp2.Free;
  end;
end;

function TWMBaseImages.GetDataType(index: Integer): Integer;
begin
  Result := FILETYPE_IMAGE;
end;

function TWMBaseImages.SaveIndexList(): Boolean;
begin
  Result := False;
end;

function TWMBaseImages.GetImageBitmapEx(index: integer; out btType: Byte): TBitmap;
begin
  Result := nil;
  btType := FILETYPE_IMAGE;
end;

function TWMBaseImages.GetImageBitmap(index: integer; out btType: Byte): TBitmap;
begin
  Result := GetImageBitmapEx(index, btType);
end;

procedure TWMBaseImages.AddIndex(nIndex, nOffset: Integer);
begin
  if FReadOnly or (not FInitialize) or ((nIndex > -1) and (nIndex > FIndexList.Count)) then
    exit;
  if nIndex = -1 then
    FIndexList.Add(Pointer(nOffset))
  else
    FIndexList.Insert(nIndex, Pointer(nOffset));
  Inc(FImageCount);
end;

function TWMBaseImages.CopyDataToTexture(index: integer; Texture: TDXImageTexture): Boolean;
begin
  Result := False;
end;

{$ENDIF}

end.

