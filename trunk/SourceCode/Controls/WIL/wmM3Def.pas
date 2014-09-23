unit wmM3Def;

interface
uses
  Windows, Classes, Graphics, SysUtils, MyDirect3D9, TDX9Textures, HUtil32, WIL;

type

  PTWMImageHeader = ^TWMImageHeader;
  TWMImageHeader = packed record
    shComp: WORD;
    Title: string[19];
    VerFlag: Word;
    ImageCount: integer;
    nFlag: Integer;
  end;

  TWMIndexHeader = packed record
    Title: string[19];
    IndexCount: integer;
    VerFlag: integer;
    nFlag: Integer;
  end;
  PTWMIndexHeader = ^TWMIndexHeader;

  TWMImageInfo = packed record
    DXInfo: TDXTextureInfo;
    bShadow: CHAR;
    shShadowPX: SmallInt;
    shShadowPY: SmallInt;
    dwImageLength: DWORD;
  end;
  PTWMImageInfo = ^TWMImageInfo;

  TWMM3DefImages = class(TWMBaseImages)
  private
    FHeader: TWMImageHeader;
    FIdxHeader: TWMIndexHeader;
    FIdxFile: string;
    FNewFmt: Boolean;
    function LoadIndex(idxfile: string): Boolean;
    function Decode(Source, Target: PChar; Width, Height: Integer): Boolean;
    function CopyImageDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word): Boolean;
  protected
    function GetImageBitmapEx(index: integer; out btType: Byte): TBitmap; override;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Initialize(): Boolean; override;
    procedure Finalize; override;

    property NewFmt: Boolean read FNewFmt;
    function CopyDataToTexture(index: integer; Texture: TDXImageTexture): Boolean; override;
  end;

implementation

{ TWMM3DefImages }

function TWMM3DefImages.CopyDataToTexture(index: integer; Texture: TDXImageTexture): Boolean;
var
  nPosition: Integer;
  imginfo: TWMImageInfo;
  Buffer, DecodeBuffer: PChar;
  ReadSize: Integer;
begin
  Result := False;
  if (index < 0) or (index >= FImageCount) or (Texture = nil) then
    exit;
  if index < FIndexList.Count then begin
    nPosition := Integer(FIndexList[index]);
    if FFileStream.Seek(nPosition, 0) <> nPosition then
      exit;
    if not FNewFmt then
      FFileStream.Read(imginfo, SizeOf(imginfo) - SizeOf(Integer))
    else
      FFileStream.Read(imginfo, SizeOf(imginfo));
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    ReadSize := imginfo.dwImageLength * 2;
    GetMem(Buffer, ReadSize);
    try
      FillChar(Buffer^, ReadSize, 0);
      if FFileStream.Read(Buffer^, ReadSize) = ReadSize then begin
        FLastImageInfo := imginfo.DXInfo;
        GetMem(DecodeBuffer, imginfo.DXInfo.nWidth * imginfo.DXInfo.nHeight * 2);
        FillChar(DecodeBuffer^, imginfo.DXInfo.nWidth * imginfo.DXInfo.nHeight * 2, #0);
        Result := Decode(Buffer, DecodeBuffer, imginfo.DXInfo.nWidth * 2, imginfo.DXInfo.nHeight);
        if Result then begin
          FLastImageInfo := imginfo.DXInfo;
          Texture.Active := False;
          Texture.Format := D3DFMT_A1R5G5B5;
          Texture.Size := Point(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight);
          Texture.PatternSize := Point(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight);
          Texture.Active := True;
          //Texture.PatternSize := Point(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight);
          Result := CopyImageDataToTexture(DecodeBuffer, Texture, imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight);
        end;
        FreeMem(DecodeBuffer);
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;

function TWMM3DefImages.CopyImageDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word): Boolean;
var
  Y: Integer;
  Access: TDXAccessInfo;
  WriteBuffer, ReadBuffer: PChar;
begin
  Result := False;
  if Texture.Lock(lfWriteOnly, Access) then begin
    try
      FillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
      for Y := 0 to Height - 1 do begin
        WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
        ReadBuffer := @Buffer[(Height - 1 - Y) * Width * 2];
        LineR5G6B5_A1R5G5B5(ReadBuffer, WriteBuffer, Width);
      end;
      Result := True;
    finally
      Texture.Unlock;
    end;
  end;
end;

constructor TWMM3DefImages.Create;
begin
  inherited;
  FReadOnly := True;
end;

function TWMM3DefImages.Decode(Source, Target: PChar; Width, Height: Integer): Boolean;
var
  nY, nX: Integer;
  nWidthEnd, nWidthStart, nCurrWidth, nCntCopyWord, nLastWidth: integer;
  SourcePtr: PWord;
begin
  Result := False;
  nWidthStart := 0;
  nWidthEnd := 0;
  nCurrWidth := 0;
  for nY := Height - 1 downto 0 do begin
    SourcePtr := @Source[nWidthStart * 2];
    nWidthEnd := nWidthEnd + SourcePtr^; //循环取字节
    Inc(nWidthStart);
    nX := nWidthStart;
    Inc(SourcePtr);
    while nX < nWidthEnd do begin
      if (SourcePtr^ = $C0) then begin
        Inc(nX);
        Inc(SourcePtr);
        nCntCopyWord := SourcePtr^;
        Inc(nX);
        Inc(SourcePtr);
        nCurrWidth := nCurrWidth + nCntCopyWord;
      end
      else if (SourcePtr^ = $C1) or (SourcePtr^ = $C2) or (SourcePtr^ = $C3) then begin
        Inc(nX);
        Inc(SourcePtr);
        nCntCopyWord := SourcePtr^;
        Inc(nX);
        Inc(SourcePtr);
        nLastWidth := nCurrWidth;
        nCurrWidth := nCurrWidth + nCntCopyWord;
        Move(SourcePtr^, Target[(nY * Width) + (nLastWidth) * 2], nCntCopyWord * 2);
        nX := nX + nCntCopyWord;
        Inc(SourcePtr, nCntCopyWord);
      end else exit;
    end;
    inc(nWidthEnd);
    nWidthStart := nWidthEnd;
    nCurrWidth := 0;
  end;
  Result := True;
end;

destructor TWMM3DefImages.Destroy;
begin

  inherited;
end;

procedure TWMM3DefImages.Finalize;
begin
  FIndexList.Clear;
  inherited;
end;

function TWMM3DefImages.GetImageBitmapEx(index: integer; out btType: Byte): TBitmap;
var
  nPosition: Integer;
  imginfo: TWMImageInfo;
  Buffer, WriteBuffer, ReadBuffer, DecodeBuffer: PChar;
  ReadSize: Integer;
  Y: Integer;
begin
  Result := nil;
  btType := FILETYPE_IMAGE;
  if (index < 0) or (index >= FImageCount) {or (FLibType <> ltLoadBmp)} then
    exit;
  if index < FIndexList.Count then begin
    nPosition := Integer(FIndexList[index]);
    if (nPosition = 0) or (FFileStream.Seek(nPosition, 0) <> nPosition) then
      exit;
    if not FNewFmt then
      FFileStream.Read(imginfo, SizeOf(imginfo) - SizeOf(Integer))
    else
      FFileStream.Read(imginfo, SizeOf(imginfo));
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    ReadSize := imginfo.dwImageLength * 2;
    GetMem(Buffer, ReadSize);
    try
      FillChar(Buffer^, ReadSize, 0);
      if FFileStream.Read(Buffer^, ReadSize) = ReadSize then begin
        FLastImageInfo := imginfo.DXInfo;
        Result := TBitmap.Create;
        Result.PixelFormat := pf16bit;
        Result.Width := imginfo.DXInfo.nWidth;
        Result.Height := imginfo.DXInfo.nHeight;
        GetMem(DecodeBuffer, Result.Width * Result.Height * 2);
        FillChar(DecodeBuffer^, Result.Width * Result.Height * 2, #0);
        if Decode(Buffer, DecodeBuffer, Result.Width * 2, Result.Height) then begin
          for Y := 0 to Result.Height - 1 do begin
            ReadBuffer := @DecodeBuffer[Y * Result.Width * 2];
            WriteBuffer := Result.ScanLine[Result.Height - Y - 1];
            Move(ReadBuffer^, WriteBuffer^, Result.Width * 2);
          end;
        end else begin
          Result.Free;
          Result := nil;
        end;
        FreeMem(DecodeBuffer);
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;

function TWMM3DefImages.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if Result then begin
    FIdxFile := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.WIX';
    Result := LoadIndex(FIdxFile);
    if not Result then begin
      Finalize;
      exit;
    end;
    FFileStream.Read(FHeader, SizeOf(TWMImageHeader));
    if FHeader.ImageCount = FIndexList.Count then begin
      FImageCount := FHeader.ImageCount;
      InitializeTexture;
    end
    else begin
      Finalize;
      raise Exception.Create(FFileName + ' 对应文件数量不一致');
    end;
  end;
end;

function TWMM3DefImages.LoadIndex(idxfile: string): Boolean;
var
  fhandle, i, value: integer;
  pvalue: PInteger;
begin
  Result := False;
  FIndexList.Clear;
  if FileExists(idxfile) then begin
    fhandle := FileOpen(idxfile, fmOpenRead or fmShareDenyNone);
    if fhandle > 0 then begin
      FileRead(fhandle, FIdxHeader, sizeof(TWMIndexHeader) - 4);
      if (FIdxHeader.VerFlag and $FFFF0000) = $B13A0000 then
        FNewFmt := True
      else
        FNewFmt := False;

      GetMem(pvalue, 4 * FIdxHeader.IndexCount);
      FileRead(fhandle, pvalue^, 4 * FIdxHeader.IndexCount);
      for i := 0 to FIdxHeader.IndexCount - 1 do begin
        value := PInteger(integer(pvalue) + 4 * i)^;
        FIndexList.Add(pointer(value));
      end;
      FreeMem(pvalue);
      FileClose(fhandle);
      Result := True;
    end;
  end;
end;

end.

