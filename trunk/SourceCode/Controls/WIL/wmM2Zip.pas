unit wmM2Zip;

interface
uses
  Windows, Classes, Graphics, SysUtils, TDX9Textures, HUtil32, WIL, MyDirect3D9;

type
  TWZIndexHeader = record
    Title: string[43];
    IndexCount: Integer;
  end;
  PTWZIndexHeader = ^TWZIndexHeader;

  TWZImageInfo = record
    Encode: Byte;
    unKnow1: array [0 .. 2] of Byte;
    DXInfo: TDXTextureInfo;
    nSize: Integer;
  end;
  PTWZImageInfo = ^TWZImageInfo;


  TWMM2ZipImages = class(TWMBaseImages)
  private
    FIdxHeader: TWZIndexHeader;
    FIdxFile: string;
    Fbo16bit: Boolean;
    procedure LoadIndex(idxfile: string);
    function CopyImageDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word): Boolean;
  protected
    procedure LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface); override;
{$IFDEF WORKFILE}
    function GetImageBitmapEx(index: integer; out btType: Byte): TBitmap; override;
{$ENDIF}
  public
    constructor Create(); override;
    function Initialize(): Boolean; override;
    procedure Finalize; override;
{$IFDEF WORKFILE}
    function CopyDataToTexture(index: integer; Texture: TDXImageTexture): Boolean; override;

{$ENDIF}
  end;

implementation

{ TWMM2ZipImages }

{$IFDEF WORKFILE}
function TWMM2ZipImages.GetImageBitmapEx(index: integer; out btType: Byte): TBitmap;
var
  nPosition: Integer;
  imginfo: TWZImageInfo;
  inBuffer, outBuffer, WriteBuffer, ReadBuffer: PChar;
  {outSize, }nLen: Integer;
  Y: Integer;
begin
  Result := nil;
  btType := FILETYPE_IMAGE;
  if (index < 0) or (index >= FImageCount) then
    exit;
  if index < FIndexList.Count then begin
    nPosition := Integer(FIndexList[index]);
    if FFileStream.Seek(nPosition, 0) <> nPosition then exit;
    FFileStream.Read(imginfo, SizeOf(TWZImageInfo));
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    Fbo16bit := imginfo.Encode = 5;
    if Fbo16bit then begin
      nLen  := WidthBytes(16, imginfo.DXInfo.nWidth);
      //ReadSize := nLen * imgInfo.DXInfo.nHeight; //;//* 2;
    end else begin
      nLen  := WidthBytes(8, imginfo.DXInfo.nWidth);
      //ReadSize := nLen * imgInfo.DXInfo.nHeight;
    end;
    if (imginfo.nSize <= 0) then
      exit;
    GetMem(inBuffer, imginfo.nSize);
    outBuffer := nil;
    try
      if FFileStream.Read(inBuffer^, imginfo.nSize) = imginfo.nSize then
      begin
        {outSize := }ZIPDecompress(inBuffer, imginfo.nSize, 0, outBuffer);
        FLastImageInfo := imginfo.DXInfo;
        if Fbo16bit then begin
          Result := TBitmap.Create;
          Result.PixelFormat := pf16bit;
          Result.Width := imginfo.DXInfo.nWidth;
          Result.Height := imginfo.DXInfo.nHeight;
          for Y := 0 to Result.Height - 1 do
          begin
            WriteBuffer := Result.ScanLine[Result.Height - Y - 1];
            ReadBuffer := @outBuffer[Y * nLen];
            Move(ReadBuffer^, WriteBuffer^, Result.Width * 2);
          end;
        end else begin
          Result := TBitmap.Create;
          Result.PixelFormat := pf8bit;
          Result.Width := imginfo.DXInfo.nWidth;
          Result.Height := imginfo.DXInfo.nHeight;
          for Y := 0 to Result.Height - 1 do begin
            WriteBuffer := Result.ScanLine[Result.Height - Y - 1];
            ReadBuffer := @outBuffer[Y * nLen];
            Move(ReadBuffer^, WriteBuffer^, Result.Width);
          end;
          SetDIBColorTable(Result.Canvas.Handle, 0, 256, m_DefMainPalette);
        end;
        FreeMem(outBuffer);
      end;
    finally
      FreeMem(inBuffer);
    end;
  end;
end;

function TWMM2ZipImages.CopyDataToTexture(index: integer; Texture: TDXImageTexture): Boolean;
var
  nPosition: Integer;
  imginfo: TWZImageInfo;
  inBuffer, outBuffer: PChar;
  {outSize, }nLen: Integer;
begin
  Result := False;
  if (index < 0) or (index >= FImageCount) or (Texture = nil) then
    exit;
  if index < FIndexList.Count then begin
    nPosition := Integer(FIndexList[index]);
    if FFileStream.Seek(nPosition, 0) <> nPosition then exit;
    FFileStream.Read(imginfo, SizeOf(imginfo));
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    Fbo16bit := imginfo.Encode = 5;
    if Fbo16bit then begin
      nLen := WidthBytes(16, imginfo.DXInfo.nWidth);
      //ReadSize := nLen * imgInfo.DXInfo.nHeight;
    end else begin
      nLen := WidthBytes(8, imginfo.DXInfo.nWidth);
      //ReadSize := nLen * imgInfo.DXInfo.nHeight;
    end;
    if (imginfo.nSize <= 0) then
      exit;
    GetMem(inBuffer, imginfo.nSize);
    outBuffer := nil;
    try
      if FFileStream.Read(inBuffer^, imginfo.nSize) = imginfo.nSize then begin
        {outSize := }ZIPDecompress(inBuffer, imginfo.nSize, 0, outBuffer);
        FLastImageInfo := imginfo.DXInfo;
        Texture.Active := False;
        Texture.Format := D3DFMT_A1R5G5B5;
        Texture.Size := Point(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight);
        Texture.PatternSize := Point(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight);
        Texture.Active := True;
        Result := CopyImageDataToTexture(outBuffer, Texture, nLen, imginfo.DXInfo.nHeight);
        FreeMem(outBuffer);
      end;
    finally
      FreeMem(inBuffer);
    end;
  end;
end;
{$ENDIF}

function TWMM2ZipImages.CopyImageDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word): Boolean;
var
  Y: Integer;
  Access: TDXAccessInfo;
  WriteBuffer, ReadBuffer: PChar;
begin
  Result := False;
  if Texture.Lock(lfWriteOnly, Access) then begin
    try
      if Fbo16bit then begin
        SafeFillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
        for Y := 0 to Height - 1 do begin
          WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
          ReadBuffer := @Buffer[(Height - 1 - Y) * Width];
          LineR5G6B5_A1R5G5B5(ReadBuffer, WriteBuffer, Texture.Width);
        end;
      end else begin
        SafeFillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
        WriteBuffer := Pointer(Integer(Access.Bits));
        ReadBuffer := @Buffer[(Height - 1) * Width];
        for Y := 0 to Height - 1 do begin
          LineX8_A1R5G5B5(ReadBuffer, WriteBuffer, Texture.Width);
          Inc(WriteBuffer, Access.Pitch);
          Dec(ReadBuffer, Width);
        end;
      end;
      Result := True;
    finally
      Texture.Unlock;
    end;
  end;
end;

constructor TWMM2ZipImages.Create;
begin
  inherited;
  FReadOnly := True;
end;

procedure TWMM2ZipImages.Finalize;
begin
  inherited;
end;

function TWMM2ZipImages.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if Result then begin
    FIdxFile := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.WZX';
    LoadIndex(FIdxFile);
    InitializeTexture;
  end;
end;

procedure TWMM2ZipImages.LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface);
var
  imginfo: TWZImageInfo;
  inBuffer, outBuffer: PChar;
  {outSize, }nLen: Integer;
begin
  pDXTexture.boNotRead := True;
  if FFileStream.Seek(position, 0) = position then begin;
    FFileStream.Read(imginfo, SizeOf(imginfo));
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    Fbo16bit := imginfo.Encode = 5;
    if Fbo16bit then begin
      nLen := WidthBytes(16, imginfo.DXInfo.nWidth);
      //ReadSize := nLen * imgInfo.DXInfo.nHeight;
    end else begin
      nLen := WidthBytes(8, imginfo.DXInfo.nWidth);
      //ReadSize := nLen * imgInfo.DXInfo.nHeight;
    end;
    if (imginfo.nSize <= 0) then
      exit;
    GetMem(inBuffer, imginfo.nSize);
    outBuffer := nil;
    try
      if FFileStream.Read(inBuffer^, imginfo.nSize) = imginfo.nSize then begin
        {outSize := }ZIPDecompress(inBuffer, imginfo.nSize, 0, outBuffer);
        pDXTexture.Surface := MakeDXImageTexture(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight, WILFMT_A1R5G5B5);
        if pDXTexture.Surface <> nil then begin
          if not CopyImageDataToTexture(outBuffer, pDXTexture.Surface, nLen, imginfo.DXInfo.nHeight) then
          begin
            pDXTexture.Surface.Free;
            pDXTexture.Surface := nil;
          end
          else begin
            pDXTexture.boNotRead := False;
            pDXTexture.nPx := imginfo.DXInfo.px;
            pDXTexture.nPy := imginfo.DXInfo.py;
          end;
        end;
        FreeMem(outBuffer);
      end;
    finally
      FreeMem(inBuffer);
    end;
  end;
end;

procedure TWMM2ZipImages.LoadIndex(idxfile: string);
var
  fhandle, i, value: integer;
  pvalue: PInteger;
begin
  FIndexList.Clear;
  FImageCount := 0;
  if FileExists(idxfile) then begin
    fhandle := FileOpen(idxfile, fmOpenRead or fmShareDenyNone);
    if fhandle > 0 then begin
      FileSeek(fHandle, 0, 0);
      FileRead(fhandle, FIdxHeader, sizeof(TWZIndexHeader));
      if FIdxHeader.IndexCount > MAXIMAGECOUNT then exit;
      GetMem(pvalue, 4 * FIdxHeader.IndexCount);
      if FileRead(fhandle, pvalue^, 4 * FIdxHeader.IndexCount) = (4 * FIdxHeader.IndexCount) then begin
        for i := 0 to FIdxHeader.IndexCount - 1 do begin
          value := PInteger(integer(pvalue) + 4 * i)^;
          FIndexList.Add(pointer(value));
        end;
      end;
      FreeMem(pvalue);
      FileClose(fhandle);
    end;
    FImageCount := FIndexList.Count;
  end;
end;

end.
