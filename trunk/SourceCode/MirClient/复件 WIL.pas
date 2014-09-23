unit WIL;

interface

uses
  Windows, Classes, Graphics, SysUtils, MyDirect3D9, TDX9Textures, DIB, wmUtil, HUtil32;

const
  VERFLAG = 88;

type
  TLibType = (ltLoadBmp, ltUseCache);

{$IFDEF VERREADWRITE}
  TColorEffect = (ceNone, ceGrayScale, ceBright, ceRed, ceGreen, ceBlue, ceYellow, ceFuchsia);
{$ENDIF}

  TDxImageArr = array[0..MaxListSize div 4] of TDxImage;
  PTDxImageArr = ^TDxImageArr;

  TWMImages = class(TComponent)
  private
    FFileName: string;
    FImageCount: integer;
    FLibType: TLibType;
    FDxDraw: TDxDraw;
    FDDraw: TDirectDraw;
    FAutoFreeMemorys: Boolean;
    FAutoFreeMemorysTick: LongWord;
    FFreeSurfaceTick: LongWord;
    //FBitType: TDxBitType;
    FInitialize: Boolean;
    FBitCount: Byte;
    btVersion: Byte;
    FAppr: Word;
    procedure LoadPalette;
    procedure LoadIndex(idxfile: string); overload;
    procedure LoadIndex(); overload;
    procedure LoadDxImage(position: integer; pdximg: PTDxImage);
    procedure FreeOldMemorys;
    function FGetImageSurface(index: integer): TDirectDrawSurface;
    function Decode(LineBuffer: PChar; width, height: Integer): Boolean;

    procedure FSetDxDraw(fdd: TDxDraw);
    function GetCachedSurface(index: integer): TDirectDrawSurface;
    function DecodeRLE(const Source, Target: Pointer; Count, ColorDepth: Cardinal): Integer;
    function DecodeWis(Target: Pointer; width, height: Integer): Boolean;
{$IFDEF VERREADWRITE}
    procedure FormatDib(TempDib: TDIB);
    function Encode(LineBuffer, SaveBuffer: PChar; width, height: Integer):Integer;
    function EncodeRLE(const Source, Target: Pointer; Count, BPP: Integer): Integer;
{$ENDIF}
  protected
    m_dwMemChecktTick: LongWord;
  public
    m_ImgArr: pTDxImageArr;
    m_IndexList: TList;
    m_FileStream: TFileStream;
    imginfo: TWMImageInfo;
    lsDib: TDib;
    MainPalette: TRgbQuads;
    FIdxFile: string;
    FHeader: TWMImageHeader;
    FIdxHeader: TWMIndexHeader;
{$IFDEF VERREADWRITE}

    boAutoCutOut: Boolean;
    boSetTransparentColor: Boolean;
    TransparentColor: Integer;
    ColorEffect: TColorEffect;
{$ENDIF}
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Initialize(RGBQuads: PRGBQuads = nil);
    procedure Finalize;
    procedure ClearCache;
    function MakeDIB(index: integer): Boolean;

    function GetCachedImage(index: integer; var px, py: integer): TDirectDrawSurface;
    function GetBitmap(index: integer; var Bitmap: TBitmap): Boolean; overload;
    function GetBitmap(index: integer; var px, py: integer; var Bitmap: TBitmap): Boolean; overload;

    property Images[index: integer]: TDirectDrawSurface read FGetImageSurface;
    property DDraw: TDirectDraw read FDDraw write FDDraw;
    property ImageCount: integer read FImageCount;
    property boInitialize: Boolean read FInitialize;
    property Version: Byte read btVersion;
    property BitCount: Byte read FBitCount;

{$IFDEF VERREADWRITE}
    procedure AddImages(px, py: Integer; TempDib: TDIB);
    procedure SaveIndex();
    function GetDibSize(TempDib: TDIB): Integer;
    function Getposition(Index: Integer): Integer;
    function GetNextposition(Index: Integer): Integer;
    function InsertImages(index, px, py: Integer; TempDib: TDIB): Integer;
    function ReplaceImages(position, index, px, py: Integer; TempDib: TDIB): Integer;
    procedure UpdateIndex(StartIdx, nSize: Integer);
    procedure GetImageInfo(Index: Integer; pimginfo: pTWMImageInfo);
    procedure SetImageInfo(Index: Integer; pimginfo: pTWMImageInfo);
{$ENDIF}
  published
    property FileName: string read FFileName write FFileName;
    property DxDraw: TDxDraw read FDxDraw write FSetDxDraw;
    property LibType: TLibType read FLibType write FLibType;
    property Appr: Word read FAppr write FAppr;
    //property BitType: TDxBitType read FBitType write FBitType;
    property AutoFreeMemorys: Boolean read FAutoFreeMemorys write FAutoFreeMemorys;
    property AutoFreeMemorysTick: LongWord read FAutoFreeMemorysTick write FAutoFreeMemorysTick;
    property FreeSurfaceTick: LongWord read FFreeSurfaceTick write FFreeSurfaceTick;
{$IFDEF VERREADWRITE}
{$ENDIF}
  end;

function TDXDrawRGBQuadsToPaletteEntries(const RGBQuads: TRGBQuads; AllowPalette256: Boolean): TPaletteEntries;

{$IFDEF VERREADWRITE}
procedure Bit16ToRGB(rscolor: WORD; nR, nG, nB: Integer; var R, G, B: Byte);
function Bit24To16Bit(R, G, B: Byte): WORD;
{$ENDIF}


procedure Register;

implementation

{$IFDEF VERREADWRITE}
uses
  Share;
{$ENDIF}

procedure Register;
begin
  RegisterComponents('MirGame', [TWmImages]);
end;

constructor TWMImages.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFileName := '';
  FImageCount := 0;
  //BitType := dbtAuto;
  FInitialize := False;
  FAutoFreeMemorys := False;
  FAutoFreeMemorysTick := 1000;
  FFreeSurfaceTick := 5 * 60 * 1000;
  FLibType := ltLoadBmp;
  FIdxFile := '';
  FDDraw := nil;
  FDxDraw := nil;
  m_FileStream := nil;
  m_ImgArr := nil;
  m_IndexList := TList.Create;
  //lsDib := nil;
  lsDib := TDib.Create;
  lsDib.BitCount := 8;
  FBitCount := 8;
  m_dwMemChecktTick := GetTickCount;
  btVersion := 0;
{$IFDEF VERREADWRITE}
  ColorEffect := ceNone;
{$ENDIF}
end;

destructor TWMImages.Destroy;
begin
  m_IndexList.Free;
  if m_FileStream <> nil then
    m_FileStream.Free;
  lsDib.Free;
  inherited Destroy;
end;

procedure TWMImages.Initialize(RGBQuads: PRGBQuads);
begin
  if not (csDesigning in ComponentState) then begin
    if FFileName = '' then begin
      //raise Exception.Create('FileName not assigned..');
      exit;
    end;
    //lsDib.Clear;
    if FileExists(FFileName) then begin
      FillChar(FHeader, SizeOf(FHeader), #0);
      if m_FileStream = nil then
{$IFDEF VERREADWRITE}
        m_FileStream := TFileStream.Create(FFileName, fmOpenReadWrite or fmShareDenyNone);
      boAutoCutOut := False;
      boSetTransparentColor := False;
      TransparentColor := 0;
{$ELSE}
        m_FileStream := TFileStream.Create(FFileName, fmOpenRead or fmShareDenyNone);
{$ENDIF}
      m_FileStream.Read(FHeader, SizeOf(TWMImageHeader));

      if FHeader.cTitle = 'WIS' then begin  //盛大新版Wis文件
        btVersion := 3;
      end else
      if FHeader.nFlag = VERFLAG then begin //真彩版本
        btVersion := 2;
        FBitCount := FHeader.ColorCount;
        if not (FBitCount in [8, 16]) then FBitCount := 16;
      end
      else if FHeader.IndexOffset <> 0 then begin //原老新格式
        btVersion := 1;
      end
      else begin //原老格式
        btVersion := 0;
        m_FileStream.Seek(-4, soFromCurrent);
      end;

      FImageCount := FHeader.ImageCount;
      if btVersion <> 2 then begin
        lsDib.PixelFormat.RBitMask := $FF0000;
        lsDib.PixelFormat.GBitMask := $00FF00;
        lsDib.PixelFormat.BBitMask := $0000FF;
        lsDib.BitCount := 8;
        if btVersion = 3 then begin
          if RGBQuads = nil then
            raise Exception.Create(self.Name + ' 缺少调色版数据');
          MainPalette := RGBQuads^;
          lsDib.ColorTable := MainPalette;
          lsDib.UpdatePalette;
          LoadIndex();
        end else begin
          FIdxFile := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.WIX';
          LoadPalette;
          LoadIndex(FIdxFile);
        end;
      end
      else begin
        if FBitCount = 16 then begin
          lsDib.PixelFormat.RBitMask := $F800;
          lsDib.PixelFormat.GBitMask := $07E0;
          lsDib.PixelFormat.BBitMask := $001F;
          lsDib.BitCount := 16;
        end
        else begin
          lsDib.PixelFormat.RBitMask := $FF0000;
          lsDib.PixelFormat.GBitMask := $00FF00;
          lsDib.PixelFormat.BBitMask := $0000FF;
          lsDib.BitCount := 8;
          LoadPalette;
        end;
        LoadIndex('');
      end;
      if FLibType <> ltLoadBmp then begin
        m_ImgArr := AllocMem(SizeOf(TDxImage) * FImageCount);
        if m_ImgArr = nil then
          raise Exception.Create(self.Name + ' ImgArr = nil');
      end;
      FInitialize := True;
    end;
  end;
end;

procedure TWMImages.Finalize;
begin
  if not FInitialize then exit;
  ClearCache();
  if m_FileStream <> nil then begin
    m_FileStream.Free;
    m_FileStream := nil;
  end;
  FInitialize := False;
end;

function TDXDrawRGBQuadsToPaletteEntries(const RGBQuads: TRGBQuads;
  AllowPalette256: Boolean): TPaletteEntries;
var
  Entries: TPaletteEntries;
  dc: THandle;
  i: Integer;
begin
  Result := RGBQuadsToPaletteEntries(RGBQuads);

  if not AllowPalette256 then begin
    dc := GetDC(0);
    GetSystemPaletteEntries(dc, 0, 256, Entries);
    ReleaseDC(0, dc);

    for i := 0 to 9 do
      Result[i] := Entries[i];

    for i := 256 - 10 to 255 do
      Result[i] := Entries[i];
  end;

  for i := 0 to 255 do
    Result[i].peFlags := D3DPAL_READONLY;
end;

procedure TWMImages.LoadPalette;
begin
  if btVersion = 0 then
    m_FileStream.Seek(sizeof(TWMImageHeader) - 4, 0)
  else
    m_FileStream.Seek(sizeof(TWMImageHeader), 0);

  m_FileStream.Read(MainPalette, sizeof(TRgbQuad) * 256);

  lsDib.ColorTable := MainPalette;
  lsDib.UpdatePalette;
end;

procedure TWMImages.LoadIndex();
var
  WMIndexInfo: TWisWMIndexInfo;
begin
  m_IndexList.Clear;
  FImageCount := 0;
  m_FileStream.Seek(-SizeOf(WMIndexInfo), soFromEnd);
  if m_FileStream.Read(WMIndexInfo, SizeOf(WMIndexInfo)) = SizeOf(WMIndexInfo) then begin
    m_FileStream.Seek(WMIndexInfo.nIndex + WMIndexInfo.nSize, soFromBeginning);
    while True do begin
      if m_FileStream.Read(WMIndexInfo, SizeOf(WMIndexInfo)) = SizeOf(WMIndexInfo) then begin
        m_IndexList.Add(pointer(WMIndexInfo.nIndex));
        Inc(FImageCount);
      end else
        break;
    end;
  end;
end;

procedure TWMImages.LoadIndex(idxfile: string);
var
  fhandle, i, value: integer;
  pvalue: PInteger;
begin
  m_IndexList.Clear;
  if btVersion <> 2 then begin
    if FileExists(idxfile) then begin
      fhandle := FileOpen(idxfile, fmOpenRead or fmShareDenyNone);
      if fhandle > 0 then begin
        if btVersion = 0 then
          FileRead(fhandle, FIdxHeader, sizeof(TWMIndexHeader) - 4)
        else
          FileRead(fhandle, FIdxHeader, sizeof(TWMIndexHeader));

        GetMem(pvalue, 4 * FIdxHeader.IndexCount);
        FileRead(fhandle, pvalue^, 4 * FIdxHeader.IndexCount);
        for i := 0 to FIdxHeader.IndexCount - 1 do begin
          value := PInteger(integer(pvalue) + 4 * i)^;
          m_IndexList.Add(pointer(value));
        end;
        FreeMem(pvalue);
        FileClose(fhandle);
      end;
    end;
  end
  else begin
    if FHeader.IndexOffset > 0 then begin
      m_FileStream.Seek(FHeader.IndexOffset, soFromBeginning);
      GetMem(pvalue, 4 * FHeader.ImageCount);
      m_FileStream.Read(pvalue^, 4 * FHeader.ImageCount);
      for i := 0 to FHeader.ImageCount - 1 do begin
        value := PInteger(integer(pvalue) + 4 * i)^;
        m_IndexList.Add(pointer(value));
      end;
      FreeMem(pvalue);
    end;
  end;
end;

function TWMImages.FGetImageSurface(index: integer): TDirectDrawSurface;
begin
  Result := nil;
  if not FInitialize then exit;
  if FLibType = ltUseCache then begin
    Result := GetCachedSurface(index);
  end;
end;

procedure TWMImages.FSetDxDraw(fdd: TDxDraw);
begin
  FDxDraw := fdd;
end;

procedure TWMImages.LoadDxImage(position: integer; pdximg: PTDxImage);
begin
  Try
    if MakeDIB(position) then begin
      pdximg.nPx := imginfo.px;
      pdximg.nPy := imginfo.py;
      pdximg.surface := TDirectDrawSurface.Create(FDDraw);
      pdximg.surface.SystemMemory := TRUE;
      pdximg.surface.SetSize(imginfo.nWidth, imginfo.nHeight);
      pdximg.surface.Canvas.Draw(0, 0, lsDib);
      pdximg.surface.Canvas.Release;
      pdximg.surface.TransparentColor := 0;
    end;
  Except
    pdximg.nPx := 0;
    pdximg.nPy := 0;
    pdximg.surface := TDirectDrawSurface.Create(FDDraw);
    pdximg.surface.SystemMemory := TRUE;
    pdximg.surface.SetSize(1, 1);
    pdximg.surface.Fill(0);
    pdximg.surface.TransparentColor := 0;
  End;
end;

function GetPixel(P: PByte; BPP: Byte): Cardinal;
begin
  Result := P^;
  Inc(P);
  Dec(BPP);
  while BPP > 0 do begin
    Result := Result shl 8;
    Result := Result or P^;
    Inc(P);
    Dec(BPP);
  end;
end;

function CountDiffPixels(P: PByte; BPP: Byte; Count: Integer): Integer;
var
  N: Integer;
  Pixel,
    NextPixel: Cardinal;

begin
  N := 0;
  NextPixel := 0; // shut up compiler
  if Count = 1 then
    Result := Count
  else begin
    Pixel := GetPixel(P, BPP);
    while Count > 1 do begin
      Inc(P, BPP);
      NextPixel := GetPixel(P, BPP);
      if NextPixel = Pixel then Break;
      Pixel := NextPixel;
      Inc(N);
      Dec(Count);
    end;
    if NextPixel = Pixel then
      Result := N
    else
      Result := N + 1;
  end;
end;
//----------------------------------------------------------------------------------------------------------------------

function CountSamePixels(P: PByte; BPP: Byte; Count: Integer): Integer;

var
  Pixel,
    NextPixel: Cardinal;

begin
  Result := 1;
  Pixel := GetPixel(P, BPP);
  Dec(Count);
  while Count > 0 do begin
    Inc(P, BPP);
    NextPixel := GetPixel(P, BPP);
    if NextPixel <> Pixel then Break;
    Inc(Result);
    Dec(Count);
  end;
end;

function TWMImages.Decode(LineBuffer: PChar; width, height: Integer): Boolean;
var
  RLEBuffer, Buffer: Pointer;
  LineSize: Integer;
  i, ReadLength: Integer;
begin
  //  Result := False;
  LineSize := Width * (FBitCount div 8);
  RLEBuffer := AllocMem(2 * LineSize);
  for I := 0 to Height - 1 do begin
    Buffer := @LineBuffer[LineSize * i];
    ReadLength := m_FileStream.Read(RLEBuffer^, 2 * LineSize);
    m_FileStream.Position := m_FileStream.Position - ReadLength +
      DecodeRLE(RLEBuffer, Buffer, LineSize, FBitCount);
  end;
  FreeMem(RLEBuffer);
  Result := True;
end;

function TWMImages.MakeDIB(index: integer): Boolean;
var
  nLeng, y: Integer;
  WisBuffer: PChar;
  WisWMImageInfo: TWisWMImageInfo;
  sptr, dptr: PChar;
  SBits, DBits: PByte;
begin
  Result := False;
  if index <= 0 then Exit;
  m_FileStream.Seek(index, 0);
  if btVersion = 3 then begin
    m_FileStream.Read(WisWMImageInfo, SizeOf(WisWMImageInfo));
    Move(WisWMImageInfo.nWidth, imginfo, SizeOf(imginfo) - SizeOf(Integer));
    imginfo.nSize := WisWMImageInfo.nEncrypt;
  end else begin
    if btVersion = 0 then
      m_FileStream.Read(imginfo, SizeOf(imginfo) - SizeOf(Integer))
    else
      m_FileStream.Read(imginfo, SizeOf(imginfo));
  end;

  if (imginfo.nWidth > 2048) or (imgInfo.nHeight > 1536) or (imginfo.nWidth < 2) or (imgInfo.nHeight < 2) then
    Exit;

  lsDib.Width := imginfo.nWidth;
  lsDib.Height := imginfo.nHeight;
  lsDib.Fill(0);
  nLeng := lsDib.Width * lsDib.Height;

  if btVersion = 3 then begin
    GetMem(WisBuffer, nLeng);
    FillChar(WisBuffer^, nLeng, 0);
    Try
      if WisWMImageInfo.nEncrypt <> 0 then begin //加密版
        Result := DecodeWis(WisBuffer, lsDib.Width, lsDib.Height);
        SBits := PByte(WisBuffer);
        for y := 0 to lsDib.Height - 1 do begin
          DBits := PByte(lsdib.ScanLine[y]);
          Move(SBits^, DBits^, lsDib.Width);
          Inc(SBits, lsDib.Width);
        end;  
      end else begin  //未加密
        if m_FileStream.Read(WisBuffer^, nLeng) = nLeng then Result := True;
        if Result then
          for y := lsDib.Height - 1 downto 0 do begin
            sptr := PChar(Integer(WisBuffer) + (lsDib.Height - 1 - y) * lsDib.Width);
            dptr := PChar(Integer(lsDib.PBits) + y * lsDib.Width);
            Move(sptr^, dptr^, lsDib.Width);
          end;
      end;
    Finally
      FreeMem(WisBuffer);
    End;
  end else
  if btVersion = 2 then begin
    Result := Decode(lsDib.PBits, lsDib.Width, lsDib.Height);
  end
  else begin
    if m_FileStream.Read(lsDib.PBits^, nLeng) = nLeng then Result := True;
  end;
end;

procedure TWMImages.ClearCache;
var
  i: integer;
begin
  if not FInitialize then exit;
  if FLibType <> ltLoadBmp then begin
    for i := 0 to FImageCount - 1 do begin
      if m_ImgArr[i].Surface <> nil then begin
        m_ImgArr[i].Surface.Free;
        m_ImgArr[i].Surface := nil;
      end;
    end;
  end;
end;

procedure TWMImages.FreeOldMemorys;
var
  i: integer;
begin
  for i := 0 to FImageCount - 1 do begin
    if m_ImgArr[i].Surface <> nil then begin
      if ((GetTickCount - m_ImgArr[i].dwLatestTime) > FFreeSurfaceTick) then begin
        m_ImgArr[i].Surface.Free;
        m_ImgArr[i].Surface := nil;
      end;
    end;
  end;
end;

function TWMImages.GetCachedSurface(index: integer): TDirectDrawSurface;
var
  nPosition: Integer;
begin
  Result := nil;
  if (index < 0) or (index >= FImageCount) then exit;
  if FAutoFreeMemorys and ((GetTickCount - m_dwMemChecktTick) >
    FAutoFreeMemorysTick) then begin
    m_dwMemChecktTick := GetTickCount;
    FreeOldMemorys;
  end;
  if m_ImgArr[index].Surface = nil then begin
    if index < m_IndexList.Count then begin
      nPosition := Integer(m_IndexList[index]);
      LoadDxImage(nPosition, @m_ImgArr[index]);
      m_ImgArr[index].dwLatestTime := GetTickCount;
      Result := m_ImgArr[index].Surface;
    end;
  end
  else begin
    m_ImgArr[index].dwLatestTime := GetTickCount;
    Result := m_ImgArr[index].Surface;
  end;
end;

function TWMImages.GetCachedImage(index: integer; var px, py: integer):
  TDirectDrawSurface;
var
  position: integer;
begin
  Result := nil;
  if not FInitialize then exit;
  if (index < 0) or (index >= FImageCount) or (FLibType <> ltUseCache) then
    exit;

  if FAutoFreeMemorys and ((GetTickCount - m_dwMemChecktTick) >
    FAutoFreeMemorysTick) then begin
    m_dwMemChecktTick := GetTickCount;
    FreeOldMemorys;
  end;
  if m_ImgArr[index].Surface = nil then begin
    if index < m_IndexList.Count then begin
      position := Integer(m_IndexList[index]);
      LoadDxImage(position, @m_ImgArr[index]);
      m_ImgArr[index].dwLatestTime := GetTickCount;
      px := m_ImgArr[index].nPx;
      py := m_ImgArr[index].nPy;
      Result := m_ImgArr[index].Surface;
    end;
  end
  else begin
    m_ImgArr[index].dwLatestTime := GetTickCount;
    px := m_ImgArr[index].nPx;
    py := m_ImgArr[index].nPy;
    Result := m_ImgArr[index].Surface;
  end;
end;

function TWMImages.GetBitmap(index: integer; var Bitmap: TBitmap): Boolean;
var
  nPosition: Integer;
begin
  Result := False;
  if (index >= 0) and (index < FImageCount) and (index < m_IndexList.Count) then begin
    nPosition := Integer(m_IndexList[index]);
    if MakeDIB(nPosition) then begin
      Bitmap.Width := lsDib.Width;
      Bitmap.Height := lsDib.Height;
      Bitmap.Canvas.Draw(0, 0, lsDib);
      Result := True;
    end;
  end;
end;

function TWMImages.GetBitmap(index: integer; var px, py: integer; var Bitmap: TBitmap): Boolean;
var
  nPosition: Integer;
begin
  Result := False;
  if (index >= 0) and (index < FImageCount) and (index < m_IndexList.Count) then begin
    nPosition := Integer(m_IndexList[index]);
    if MakeDIB(nPosition) then begin
      Bitmap.Width := lsDib.Width;
      Bitmap.Height := lsDib.Height;
      Bitmap.Canvas.Draw(0, 0, lsDib);
      px := imginfo.px;
      py := imginfo.py;
      Result := True;
    end;
  end;
end;

{-----------------------------修改工作区---------------------------------------}

{$IFDEF VERREADWRITE}

function TWMImages.Encode(LineBuffer, SaveBuffer: PChar; width, height: Integer): Integer;
var
  RLEBuffer, Buffer: Pointer;
  LineSize: Integer;
  i, WriteLength: Integer;
begin
  Result := 0;
  if btVersion = 3 then exit;
  LineSize := Width * (FBitCount div 8);
  RLEBuffer := AllocMem(2 * LineSize);
  for I := 0 to Height - 1 do begin
    Buffer := @LineBuffer[LineSize * i];
    WriteLength := EncodeRLE(Buffer, RLEBuffer, Width, FBitCount div 8);
    Move(RLEBuffer^, SaveBuffer[Result], WriteLength);
    Inc(Result, WriteLength);
  end;
  FreeMem(RLEBuffer);
end;

procedure TWMImages.AddImages(px, py: Integer; TempDib: TDIB);
var
  position, nSize: Integer;
  imageinfo: TWMImageInfo;
  i: Integer;
  SaveBuff: PChar;
begin
  if btVersion = 3 then exit;
  if (TempDib.Width > 1) and (TempDib.Height > 1) then begin
    FormatDib(TempDib);
    imginfo.px := px;
    imginfo.py := py;
    imginfo.nWidth := lsDib.Width;
    imginfo.nHeight := lsDib.Height;
    position := 0;
    if btVersion = 2 then begin
      if m_IndexList.Count > 0 then begin
        for i := m_IndexList.Count - 1 downto 0 do begin
          position := Integer(m_IndexList.Items[i]);
          if position <> 0 then Break;
        end;
        if position = 0 then
          position := FHeader.IndexOffset
        else begin
          m_FileStream.Seek(position, soFromBeginning);
          m_FileStream.Read(imageinfo, SizeOf(TWMImageInfo));
          position := position + SizeOf(TWMImageInfo) + imageinfo.nSize;
        end;
      end
      else begin
        position := FHeader.IndexOffset {SizeOf(TWMImageHeader)};
      end;
      GetMem(SaveBuff, imginfo.nWidth * imginfo.nHeight * 4);
      nSize := Encode(lsDib.PBits, SaveBuff, imginfo.nWidth, imginfo.nHeight);
      imginfo.nSize := nSize;
      m_FileStream.Seek(position, soFromBeginning);
      m_FileStream.Write(imginfo, SizeOf(TWMImageInfo));
      m_FileStream.Write(SaveBuff^, nSize);
      FreeMem(SaveBuff);
    end
    else begin
      nSize := imginfo.nWidth * imginfo.nHeight;
      position := m_FileStream.Seek(0, soFromEnd);
      if btVersion = 0 then
        m_FileStream.Write(imginfo, SizeOf(TWMImageInfo) - 4)
      else
        m_FileStream.Write(imginfo, SizeOf(TWMImageInfo));
      m_FileStream.Write(lsDib.PBits^, nSize);
    end;
  end
  else begin
    position := 0;
    nSize := 0;
  end;
  m_IndexList.Add(Pointer(position));
  FHeader.ImageCount := m_IndexList.Count;
  FImageCount := FHeader.ImageCount;
  if (btVersion = 2) and (nSize > 0) then begin
    FHeader.IndexOffset := position + SizeOf(TWMImageInfo) + nSize;
  end;
end;

procedure TWMImages.SaveIndex();
var
  fhandle, i: integer;
  pvalue: PInteger;
begin
  if btVersion = 3 then exit;
  FHeader.ImageCount := m_IndexList.Count;
  FIdxHeader.IndexCount := m_IndexList.Count;
  FImageCount := FHeader.ImageCount;
  m_FileStream.Seek(0, soFromBeginning);
  if btVersion = 0 then
    m_FileStream.Write(FHeader, SizeOf(TWMImageHeader) - 4)
  else
    m_FileStream.Write(FHeader, SizeOf(TWMImageHeader));

  if btVersion = 2 then begin
    RemoveData(FFileName, FHeader.IndexOffset, m_FileStream.Size); //删除原数据
    GetMem(pvalue, 4 * FHeader.ImageCount);
    for i := 0 to m_IndexList.Count - 1 do begin
      PInteger(integer(pvalue) + 4 * i)^ := Integer(m_IndexList.Items[I]);
    end;
    m_FileStream.Seek(FHeader.IndexOffset, soFromBeginning);
    m_FileStream.Write(pvalue^, 4 * FHeader.ImageCount);
    FreeMem(pvalue);
  end
  else if FileExists(FIdxFile) then begin
    fhandle := FileOpen(FIdxFile, fmOpenWrite or fmShareDenyNone);
    if fhandle > 0 then begin
      RemoveData(FIdxFile, 0, m_FileStream.Size); //删除原数据
      if btVersion = 0 then
        FileWrite(fhandle, FIdxHeader, Sizeof(TWMIndexHeader) - 4)
      else
        FileWrite(fhandle, FIdxHeader, Sizeof(TWMIndexHeader));

      GetMem(pvalue, 4 * FIdxHeader.IndexCount);
      for i := 0 to m_IndexList.Count - 1 do begin
        PInteger(integer(pvalue) + 4 * i)^ := Integer(m_IndexList.Items[I]);
      end;
      FileWrite(fhandle, pvalue^, 4 * FIdxHeader.IndexCount);
      FreeMem(pvalue);
      FileClose(fhandle);
    end;
  end;
end;

procedure Bit16ToRGB(rscolor: WORD; nR, nG, nB: Integer; var R, G, B: Byte);
begin
  {B := BYTE((rscolor and $1F) shl 3);
  G := BYTE((rscolor and $7E0) shr 3);
  R := BYTE((rscolor and $F800) shr 8);   }
  B := BYTE((rscolor and nB) shl 3);
  G := BYTE((rscolor and nG) shr 3);
  R := BYTE((rscolor and nR) shr 8);
end;

function Bit24To16Bit(R, G, B: Byte): WORD;
begin
  ReSult := ((WORD(R) and $F8) shl 8) + ((WORD(G) and $FC) shl 3) + ((WORD(B)) shr 3)
end;

procedure TWMImages.FormatDib(TempDib: TDIB);
var
  x, y, nColor, n: Integer;
  pal1, pal2: TRGBQuad;
  j, MinDif, ColDif: integer;
  MatchColor: byte;
  btColor: Byte;
  bo24: Boolean;
  wColor: Word;
  nX, nY: Integer;
begin
  if btVersion = 3 then exit;
  if (btVersion = 2) and (FBitCount = 16) then begin
    nX := 0;
    nY := 0;
    if (TempDib.BitCount = 16) and (ColorEffect = ceNone) and (TempDib.PixelFormat.RBitMask = $F800) and
      (TempDib.PixelFormat.GBitMask = $07E0) and
      (TempDib.PixelFormat.BBitMask = $001F) then begin
      lsDib.Assign(TempDib);
      if boSetTransparentColor or boAutoCutOut then begin
        for x := 0 to lsDib.Width - 1 do
          for Y := 0 to lsDib.Height - 1 do begin
            wColor := lsDib.Pixels[x, y];
            if boSetTransparentColor then begin
              if wColor = TransparentColor then begin
                lsDib.Pixels[x, y] := 0;
              end
              else begin
                if wColor = 0 then begin
                  lsDib.Pixels[x, y] := 1;
                end;
              end;
            end;
            if wColor <> 0 then begin
              if X > nX then nX := X;
              if Y > nY then nY := y;
            end;
          end;
      end;
    end
    else begin
      TempDib.PixelFormat.RBitMask := $FF0000;
      TempDib.PixelFormat.GBitMask := $00FF00;
      TempDib.PixelFormat.BBitMask := $0000FF;
      TempDib.BitCount := 24;
      lsDib.Width := TempDib.Width;
      lsDib.Height := TempDib.Height;
      for x := 0 to TempDib.Width - 1 do
        for Y := 0 to TempDib.Height - 1 do begin
          nColor := TempDib.Pixels[x, y];
          pal1.rgbRed := GetRValue(nColor);
          pal1.rgbGreen := GetGValue(nColor);
          pal1.rgbBlue := GetBValue(nColor);
          wColor := Bit24To16Bit(pal1.rgbRed, pal1.rgbGreen, pal1.rgbBlue);
          if boSetTransparentColor then begin
            if wColor = TransparentColor then begin
              wColor := 0;
            end
            else begin
              if wColor = 0 then wColor := 1;
            end;
          end;
          if wColor <> 0 then begin
            n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
            case ColorEffect of
              ceGrayScale: wColor := _MAX(Bit24To16Bit(n, n, n), $1);
              ceRed: wColor := _MAX(Bit24To16Bit(n, 0, 0), $1);
              ceGreen: wColor := _MAX(Bit24To16Bit(0, n, 0), $1);
              ceBlue: wColor := _MAX(Bit24To16Bit(0, 0, n), $1);
              ceYellow: wColor := _MAX(Bit24To16Bit(n, n, 0), $1);
              ceFuchsia: wColor := _MAX(Bit24To16Bit(n, 0, n), $1);
              ceBright: begin
                pal1.rgbRed := _MIN(Round(pal1.rgbRed * 1.5), 255);
                pal1.rgbGreen := _MIN(Round(pal1.rgbGreen * 1.5), 255);
                pal1.rgbBlue := _MIN(Round(pal1.rgbBlue * 1.5), 255);
                wColor := _MAX(Bit24To16Bit(n, n, n), $1);
              end;
            end;
          end;
          lsDib.Pixels[x, y] := wColor;
          if wColor <> 0 then begin
            if X > nX then nX := X;
            if Y > nY then nY := y;
          end;
        end;
    end;
    Inc(nX);
    Inc(nY);
    if boAutoCutOut and ((nX < lsDib.Width) or (nY < lsDib.Height)) then begin
      if Odd(nX) then Inc(nX);
      if Odd(nY) then Inc(nY);
      TempDib.Clear;
      TempDib.Assign(lsDib);
      lsDib.Width := nX;
      lsDib.Height := nY;
      lsDib.Fill(0);
      lsDib.Canvas.Draw(0, 0, TempDib);
    end;
  end
  else begin
    bo24 := False;
    lsDib.Width := TempDib.Width;
    lsDib.Height := TempDib.Height;
    if (TempDib.BitCount <> 8) or (ColorEffect <> ceNone) then begin
      TempDib.PixelFormat.RBitMask := $FF0000;
      TempDib.PixelFormat.GBitMask := $00FF00;
      TempDib.PixelFormat.BBitMask := $0000FF;
      TempDib.BitCount := 24;
      bo24 := True;
    end;
    for x := 0 to TempDib.Width - 1 do
      for Y := 0 to TempDib.Height - 1 do begin
        if bo24 then begin
          nColor := TempDib.Pixels[x, y];
          pal1.rgbRed := GetRValue(nColor);
          pal1.rgbGreen := GetGValue(nColor);
          pal1.rgbBlue := GetBValue(nColor);
          if (pal1.rgbBlue = 0) and
            (pal1.rgbGreen = 0) and
            (pal1.rgbRed = 0) then begin
            lsDib.Pixels[x, y] := 0;
            Continue;
          end;
          n := (pal1.rgbRed + pal1.rgbGreen + pal1.rgbBlue) div 3;
          case ColorEffect of
            ceGrayScale: begin
                pal1.rgbRed := n;
                pal1.rgbGreen := n;
                pal1.rgbBlue := n;
              end;
            ceRed: begin
                pal1.rgbRed := n;
                pal1.rgbGreen := 0;
                pal1.rgbBlue := 0;
              end;
            ceGreen: begin
                pal1.rgbRed := 0;
                pal1.rgbGreen := n;
                pal1.rgbBlue := 0;
              end;
            ceBlue: begin
                pal1.rgbRed := 0;
                pal1.rgbGreen := 0;
                pal1.rgbBlue := n;
              end;
            ceYellow: begin
                pal1.rgbRed := n;
                pal1.rgbGreen := n;
                pal1.rgbBlue := 0;
              end;
            ceFuchsia: begin
                pal1.rgbRed := n;
                pal1.rgbGreen := 0;
                pal1.rgbBlue := n;
              end;
            ceBright: begin
                pal1.rgbRed := _MIN(Round(pal1.rgbRed * 1.5), 255);
                pal1.rgbGreen := _MIN(Round(pal1.rgbGreen * 1.5), 255);
                pal1.rgbBlue := _MIN(Round(pal1.rgbBlue * 1.5), 255);
              end;
          end;
        end
        else begin
          btColor := TempDib.Pixels[x, y];
          pal1 := TempDib.ColorTable[btColor];
          pal2 := MainPalette[btColor];
          if (pal1.rgbBlue = pal2.rgbBlue) and
            (pal1.rgbGreen = pal2.rgbGreen) and
            (pal1.rgbRed = pal2.rgbRed) then begin
            lsDib.Pixels[x, y] := btColor;
            Continue;
          end
          else if (pal1.rgbBlue = 0) and
            (pal1.rgbGreen = 0) and
            (pal1.rgbRed = 0) then begin
            lsDib.Pixels[x, y] := 0;
            Continue;
          end;
        end;
        MinDif := 768;
        MatchColor := 18;
        for j := 1 to 255 do begin
          pal2 := DefMainPalette[j];
          ColDif := Abs(pal2.rgbRed - pal1.rgbRed) +
            Abs(pal2.rgbGreen - pal1.rgbGreen) +
            Abs(pal2.rgbBlue - pal1.rgbBlue);
          if ColDif < MinDif then begin
            MinDif := ColDif;
            MatchColor := j;
          end;
        end;
        lsDib.Pixels[x, y] := MatchColor;
      end;
  end;
end;

function TWMImages.GetDibSize(TempDib: TDIB): Integer;
begin
  if (TempDib.Width > 1) and (TempDib.Height > 1) then begin
    if btVersion = 2 then begin
      Result := TempDib.Width * TempDib.Height * 4 + SizeOf(TWMImageInfo);
    end
    else if btVersion = 1 then begin
      Result := TempDib.Width * TempDib.Height + SizeOf(TWMImageInfo);
    end
    else
      Result := TempDib.Width * TempDib.Height + SizeOf(TWMImageInfo) - 4;
  end
  else
    Result := 0;
end;

function TWMImages.GetNextposition(Index: Integer): Integer;
var
  position: Integer;
  i: Integer;
  boNext: Boolean;
begin
  Result := -1;
  boNext := False;
  if Index = m_IndexList.Count then begin
    if btVersion = 2 then
      Result := FHeader.IndexOffset
    else
      Result := m_FileStream.Seek(0, soFromEnd);
  end
  else if (Index >= 0) and (Index < m_IndexList.Count) then begin
    Result := 0;
    for i := Index to m_IndexList.Count - 1 do begin
      position := Integer(m_IndexList[i]);
      if position <> 0 then begin
        if boNext then Break;
        boNext := True;
        Result := position;
      end;
    end;
    if Result = 0 then begin
      if btVersion = 2 then
        Result := FHeader.IndexOffset
      else
        Result := m_FileStream.Seek(0, soFromEnd);
    end;
  end;
end;

function TWMImages.Getposition(Index: Integer): Integer;
var
  position: Integer;
  i: Integer;
begin
  Result := -1;
  if (Index >= 0) and (Index < m_IndexList.Count) then begin
    position := 0;
    for i := Index to m_IndexList.Count - 1 do begin
      position := Integer(m_IndexList[i]);
      if position <> 0 then Break;
    end;
    if position = 0 then begin
      if btVersion = 2 then
        position := FHeader.IndexOffset
      else
        position := m_FileStream.Seek(0, soFromEnd);
    end;
    Result := position;
  end;
end;

procedure TWMImages.UpdateIndex(StartIdx, nSize: Integer);
var
  I: Integer;
begin
  if btVersion = 3 then exit;
  if (nSize <> 0) and ((StartIdx + 1) < m_IndexList.Count) then begin
    for I := (StartIdx + 1) to (m_IndexList.Count - 1) do begin
      if Integer(m_IndexList.Items[I]) <> 0 then
        m_IndexList.Items[I] := Pointer(Integer(m_IndexList.Items[I]) + nSize)
    end;
  end;
end;

function TWMImages.InsertImages(index, px, py: Integer; TempDib: TDIB): Integer;
var
  position, nSize: Integer;
  SaveBuff: PChar;
begin
  Result := -1;
  if btVersion = 3 then exit;
  FormatDib(TempDib);
  imginfo.px := px;
  imginfo.py := py;
  imginfo.nWidth := lsDib.Width;
  imginfo.nHeight := lsDib.Height;
  position := Getposition(Index);
  if position = -1 then Exit;

  if btVersion = 2 then begin
    GetMem(SaveBuff, imginfo.nWidth * imginfo.nHeight * 4);
    nSize := Encode(lsDib.PBits, SaveBuff, imginfo.nWidth, imginfo.nHeight);
    imginfo.nSize := nSize;
    m_FileStream.Seek(position, soFromBeginning);
    m_FileStream.Write(imginfo, SizeOf(TWMImageInfo));
    m_FileStream.Write(SaveBuff^, nSize);
    FreeMem(SaveBuff);
    Result := SizeOf(TWMImageInfo) + nSize;
  end
  else begin
    nSize := imginfo.nWidth * imginfo.nHeight;
    m_FileStream.Seek(position, soFromBeginning);
    if btVersion = 0 then begin
      m_FileStream.Write(imginfo, SizeOf(TWMImageInfo) - 4);
      Result := SizeOf(TWMImageInfo) + nSize - 4;
    end
    else begin
      m_FileStream.Write(imginfo, SizeOf(TWMImageInfo));
      Result := SizeOf(TWMImageInfo) + nSize;
    end;
    m_FileStream.Write(lsDib.PBits^, nSize);
  end;
  m_IndexList.Insert(Index, Pointer(position));
  UpdateIndex(Index, Result); //更新索引表
  FHeader.ImageCount := m_IndexList.Count;
  FImageCount := FHeader.ImageCount;
  if btVersion = 2 then begin
    Inc(FHeader.IndexOffset, Result);
  end;
end;

function TWMImages.ReplaceImages(position, index, px, py: Integer; TempDib: TDIB): Integer;
var
  nSize: Integer;
  SaveBuff: PChar;
begin
  Result := -1;
  if btVersion = 3 then exit;
  FormatDib(TempDib);
  imginfo.px := px;
  imginfo.py := py;
  imginfo.nWidth := lsDib.Width;
  imginfo.nHeight := lsDib.Height;

  if btVersion = 2 then begin
    GetMem(SaveBuff, imginfo.nWidth * imginfo.nHeight * 4);
    nSize := Encode(lsDib.PBits, SaveBuff, imginfo.nWidth, imginfo.nHeight);
    imginfo.nSize := nSize;
    m_FileStream.Seek(position, soFromBeginning);
    m_FileStream.Write(imginfo, SizeOf(TWMImageInfo));
    m_FileStream.Write(SaveBuff^, nSize);
    FreeMem(SaveBuff);
    Result := SizeOf(TWMImageInfo) + nSize;
  end
  else begin
    nSize := imginfo.nWidth * imginfo.nHeight;
    m_FileStream.Seek(position, soFromBeginning);
    if btVersion = 0 then begin
      m_FileStream.Write(imginfo, SizeOf(TWMImageInfo) - 4);
      Result := SizeOf(TWMImageInfo) + nSize - 4;
    end
    else begin
      m_FileStream.Write(imginfo, SizeOf(TWMImageInfo));
      Result := SizeOf(TWMImageInfo) + nSize;
    end;
    m_FileStream.Write(lsDib.PBits^, nSize);
  end;
  m_IndexList.Items[index] := Pointer(position);
end;

procedure TWMImages.GetImageInfo(Index: Integer; pimginfo: pTWMImageInfo);
var
  position: Integer;
begin
  FillChar(pimginfo^, SizeOf(TWMImageInfo), #0);
  if (Index >= 0) and (Index < m_IndexList.Count) then begin
    position := Integer(m_IndexList[Index]);
    if position > 0 then begin
      m_FileStream.Seek(position, soFromBeginning);
      m_FileStream.Read(pimginfo^, SizeOf(TWMImageInfo));
    end;
  end;
end;

procedure TWMImages.SetImageInfo(Index: Integer; pimginfo: pTWMImageInfo);
var
  position: Integer;
begin
  if (Index >= 0) and (Index < m_IndexList.Count) then begin
    position := Integer(m_IndexList[Index]);
    if position > 0 then begin
      m_FileStream.Seek(position, soFromBeginning);
      if btVersion = 0 then
        m_FileStream.Write(pimginfo^, SizeOf(TWMImageInfo) - 4)
      else
        m_FileStream.Write(pimginfo^, SizeOf(TWMImageInfo));
    end;
  end;
end;

function TWMImages.EncodeRLE(const Source, Target: Pointer; Count, BPP: Integer): Integer;
var
  DiffCount, // pixel count until two identical
  SameCount: Integer; // number of identical adjacent pixels
  SourcePtr,
    TargetPtr: PByte;

begin
  Result := 0;
  SourcePtr := Source;
  TargetPtr := Target;
  while Count > 0 do begin
    DiffCount := CountDiffPixels(SourcePtr, BPP, Count);
    SameCount := CountSamePixels(SourcePtr, BPP, Count);
    if DiffCount > 128 then DiffCount := 128;
    if SameCount > 128 then SameCount := 128;

    if DiffCount > 0 then begin
      // create a raw packet
      TargetPtr^ := DiffCount - 1;
      Inc(TargetPtr);
      Dec(Count, DiffCount);
      Inc(Result, (DiffCount * BPP) + 1);
      while DiffCount > 0 do begin
        TargetPtr^ := SourcePtr^;
        Inc(SourcePtr);
        Inc(TargetPtr);
        if BPP > 1 then begin
          TargetPtr^ := SourcePtr^;
          Inc(SourcePtr);
          Inc(TargetPtr);
        end;
        Dec(DiffCount);
      end;
    end;

    if SameCount > 1 then begin
      // create a RLE packet
      TargetPtr^ := (SameCount - 1) or $80;
      Inc(TargetPtr);
      Dec(Count, SameCount);
      Inc(Result, BPP + 1);
      Inc(SourcePtr, (SameCount - 1) * BPP);
      TargetPtr^ := SourcePtr^;
      Inc(SourcePtr);
      Inc(TargetPtr);
      if BPP > 1 then begin
        TargetPtr^ := SourcePtr^;
        Inc(SourcePtr);
        Inc(TargetPtr);
      end;
    end;
  end;
end;

{$ENDIF}

function TWMImages.DecodeRLE(const Source, Target: Pointer; Count, ColorDepth: Cardinal): Integer;
var
  I: Integer;
  SourcePtr,
    TargetPtr: PByte;
  RunLength: Cardinal;
  Counter: Cardinal;
  //  SourceCardinal: Cardinal;

begin
  Result := 0;
  Counter := 0;
  TargetPtr := Target;
  SourcePtr := Source;
  if ColorDepth = 8 then begin
    while Counter < Count do begin
      RunLength := 1 + (SourcePtr^ and $7F);
      if SourcePtr^ > $7F then begin
        Inc(SourcePtr);
        FillChar(TargetPtr^, RunLength, SourcePtr^);
        Inc(TargetPtr, RunLength);
        Inc(SourcePtr);
        Inc(Result, 2);
      end
      else begin
        Inc(SourcePtr);
        Move(SourcePtr^, TargetPtr^, RunLength);
        Inc(SourcePtr, RunLength);
        Inc(TargetPtr, RunLength);
        Inc(Result, RunLength + 1)
      end;
      Inc(Counter, RunLength);
    end;
  end
  else begin
    while Counter < Count do begin
      RunLength := 1 + (SourcePtr^ and $7F);
      if SourcePtr^ > $7F then begin
        Inc(SourcePtr);
        for I := 0 to RunLength - 1 do begin
          TargetPtr^ := SourcePtr^;
          Inc(SourcePtr);
          Inc(TargetPtr);
          TargetPtr^ := SourcePtr^;
          Dec(SourcePtr);
          Inc(TargetPtr);
        end;
        Inc(SourcePtr, 2);
        Inc(Result, 3);
      end
      else begin
        Inc(SourcePtr);
        Move(SourcePtr^, TargetPtr^, 2 * RunLength);
        Inc(SourcePtr, 2 * RunLength);
        Inc(TargetPtr, 2 * RunLength);
        Inc(Result, RunLength * 2 + 1);
      end;
      Inc(Counter, 2 * RunLength);
    end;
  end;
end;

function TWMImages.DecodeWis(Target: Pointer; width, height: Integer): Boolean;
var
  SourcePtr, TargetPtr: PByte;
  RunLength: Cardinal;
  Counter: Cardinal;
  nSize: Cardinal;
  Source: Pointer;
begin
  nSize := width * height;
  GetMem(Source, nSize);
  Try
    m_FileStream.Read(Source^, nSize);
    Counter := 0;
    TargetPtr := Target;
    SourcePtr := Source;
    while Counter < nSize do begin
      RunLength := SourcePtr^;
      if RunLength = 0 then begin
        Inc(SourcePtr);
        RunLength := SourcePtr^;
        Inc(SourcePtr);
        Move(SourcePtr^, TargetPtr^, RunLength);
        Inc(SourcePtr, RunLength);
        Inc(TargetPtr, RunLength);
        Inc(Counter, RunLength);
      end else begin
        Inc(SourcePtr);
        FillChar(TargetPtr^, RunLength, SourcePtr^);
        Inc(TargetPtr, RunLength);
        Inc(SourcePtr);
        Inc(Counter, RunLength);
      end;
    end;
  Finally
    FreeMem(Source);
  End;
  Result := True;
end;

end.

