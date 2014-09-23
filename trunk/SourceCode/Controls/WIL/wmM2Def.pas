unit wmM2Def;

interface
uses
  Windows, Classes, Graphics, SysUtils, TDX9Textures, HUtil32, WIL, MyDirect3D9;

type
  TWMImageHeader = packed record
    Title: string[40];
    bitCount: array[0..2] of byte;
    ImageCount: integer;
    ColorCount: integer;
    PaletteSize: integer;
    IndexOffset: integer;
  end;

  TWMIndexHeader = packed record
    Title: string[40];
    bitCount: array[0..2] of byte;
    IndexCount: integer;
    VerFlag: integer;
  end;
  PTWMIndexHeader = ^TWMIndexHeader;

  TWMImageInfo = packed record
    DXInfo: TDXTextureInfo;
    nSize: Integer;
  end;
  PTWMImageInfo = ^TWMImageInfo;


  TWMM2DefImages = class(TWMBaseImages)
  private
    FHeader: TWMImageHeader;
    FIdxHeader: TWMIndexHeader;
    FIdxFile: string;
    FNewFmt: Boolean;
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

    property NewFmt: Boolean read FNewFmt;
{$ENDIF}
    property bo16bit: Boolean read Fbo16bit;
  end;

  TWMM2DefBit16Images = class(TWMM2DefImages)
  //private
    //function CopyImageDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word): Boolean;
//{$IFDEF WORKFILE}
  //protected
    //procedure LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface); override;

//    function GetImageBitmapEx(index: integer; out btType: Byte): TBitmap; override;
  public
    constructor Create(); override;
    //function CopyDataToTexture(index: integer; Texture: TDXImageTexture): Boolean; override;
//{$ENDIF}
  end;

implementation

{ TWMM2DefImages }

{$IFDEF WORKFILE}
function TWMM2DefImages.GetImageBitmapEx(index: integer; out btType: Byte): TBitmap;
var
  nPosition: Integer;
  imginfo: TWMImageInfo;
  Buffer, WriteBuffer, ReadBuffer: PChar;
  ReadSize, nLen: Integer;
  Y: Integer;
begin
  Result := nil;
  btType := FILETYPE_IMAGE;
  if (index < 0) or (index >= FImageCount) then
    exit;
  if index < FIndexList.Count then begin
    nPosition := Integer(FIndexList[index]);
    if FFileStream.Seek(nPosition, 0) <> nPosition then exit;
    if not FNewFmt then
      FFileStream.Read(imginfo, SizeOf(imginfo) - SizeOf(Integer))
    else
      FFileStream.Read(imginfo, SizeOf(imginfo));
    //imginfo.DXInfo.nWidth := imginfo.DXInfo.nWidth xor 65427;
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    if Fbo16bit then begin
      nLen  := WidthBytes(16, imginfo.DXInfo.nWidth);
      ReadSize := nLen * imgInfo.DXInfo.nHeight; //;//* 2;
    end else begin
      nLen  := WidthBytes(8, imginfo.DXInfo.nWidth);
      ReadSize := nLen * imgInfo.DXInfo.nHeight;
    end;
    GetMem(Buffer, ReadSize);
    try
      SafeFillChar(Buffer^, ReadSize, 0);
      if FFileStream.Read(Buffer^, ReadSize) = ReadSize then begin
        FLastImageInfo := imginfo.DXInfo;
        if Fbo16bit then begin
          Result := TBitmap.Create;
          Result.PixelFormat := pf16bit;
          Result.Width := imginfo.DXInfo.nWidth;
          Result.Height := imginfo.DXInfo.nHeight;
          for Y := 0 to Result.Height - 1 do begin
            WriteBuffer := Result.ScanLine[Result.Height - Y - 1];
            ReadBuffer := @Buffer[Y * nLen];
            Move(ReadBuffer^, WriteBuffer^, Result.Width * 2);
          end;
        end else begin
          Result := TBitmap.Create;
          Result.PixelFormat := pf8bit;
          Result.Width := imginfo.DXInfo.nWidth;
          Result.Height := imginfo.DXInfo.nHeight;
          for Y := 0 to Result.Height - 1 do begin
            WriteBuffer := Result.ScanLine[Result.Height - Y - 1];
            ReadBuffer := @Buffer[Y * nLen];
            Move(ReadBuffer^, WriteBuffer^, Result.Width);
          end;
          SetDIBColorTable(Result.Canvas.Handle, 0, 256, m_DefMainPalette);
        end;
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;

function TWMM2DefImages.CopyDataToTexture(index: integer; Texture: TDXImageTexture): Boolean;
var
  nPosition: Integer;
  imginfo: TWMImageInfo;
  Buffer: PChar;
  ReadSize, nLen: Integer;
begin
  Result := False;
  if (index < 0) or (index >= FImageCount) or (Texture = nil) then
    exit;
  if index < FIndexList.Count then begin
    nPosition := Integer(FIndexList[index]);
    if FFileStream.Seek(nPosition, 0) <> nPosition then exit;
    if not FNewFmt then
      FFileStream.Read(imginfo, SizeOf(imginfo) - SizeOf(Integer))
    else
      FFileStream.Read(imginfo, SizeOf(imginfo));
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    if Fbo16bit then begin
      nLen := WidthBytes(16, imginfo.DXInfo.nWidth);
      ReadSize := nLen * imgInfo.DXInfo.nHeight;
    end else begin
      nLen := WidthBytes(8, imginfo.DXInfo.nWidth);
      ReadSize := nLen * imgInfo.DXInfo.nHeight;
    end;
    GetMem(Buffer, ReadSize);
    try
      SafeFillChar(Buffer^, ReadSize, 0);
      if FFileStream.Read(Buffer^, ReadSize) = ReadSize then begin
        FLastImageInfo := imginfo.DXInfo;
        Texture.Active := False;
        Texture.Format := D3DFMT_A1R5G5B5;
        Texture.Size := Point(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight);
        Texture.PatternSize := Point(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight);
        Texture.Active := True;
        //Texture.PatternSize := Point(nLen, imginfo.DXInfo.nHeight);
        //if Fbo16bit then Result := CopyImageDataToTexture(Buffer, Texture, imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight)
        //else
        Result := CopyImageDataToTexture(Buffer, Texture, nLen, imginfo.DXInfo.nHeight);

      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;
{$ENDIF}

function TWMM2DefImages.CopyImageDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word): Boolean;
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

constructor TWMM2DefImages.Create;
begin
  inherited;
  FReadOnly := True;
  Fbo16bit := False;
end;

procedure TWMM2DefImages.Finalize;
begin
  inherited;
end;

function TWMM2DefImages.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if Result then begin
    FFileStream.Read(FHeader, SizeOf(TWMImageHeader));
    //if FHeader.ColorCount = $100000 then
    Fbo16bit := FHeader.ColorCount = $10000;
    if FHeader.IndexOffset <> 0 then begin //原老新格式
      FNewFmt := True;
      //FFormatName := 'MIR2 标准数据格式(新)';
      //btVersion := 1;
    end
    else begin //原老格式
      //btVersion := 0;
      //FFormatName := 'MIR2 标准数据格式(旧)';
      FNewFmt := False;
      FFileStream.Seek(-4, soFromCurrent);
    end;
    FImageCount := FHeader.ImageCount;
    FIdxFile := ExtractFilePath(FFileName) + ExtractFileNameOnly(FFileName) + '.WIX';
    LoadIndex(FIdxFile);
    InitializeTexture;
  end;
end;

procedure TWMM2DefImages.LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface);
var
  imginfo: TWMImageInfo;
  Buffer: PChar;
  ReadSize, nLen: Integer;
begin
  pDXTexture.boNotRead := True;
  if FFileStream.Seek(position, 0) = position then begin;
    if not FNewFmt then
      FFileStream.Read(imginfo, SizeOf(imginfo) - SizeOf(Integer))
    else
      FFileStream.Read(imginfo, SizeOf(imginfo));
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    if Fbo16bit then begin
      nLen := WidthBytes(16, imginfo.DXInfo.nWidth);
      ReadSize := nLen * imgInfo.DXInfo.nHeight;
    end else begin
      nLen := WidthBytes(8, imginfo.DXInfo.nWidth);
      ReadSize := nLen * imgInfo.DXInfo.nHeight;
    end;
    GetMem(Buffer, ReadSize);
    try
      if FFileStream.Read(Buffer^, ReadSize) = ReadSize then begin
        pDXTexture.Surface := MakeDXImageTexture(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight, WILFMT_A1R5G5B5);

        if pDXTexture.Surface <> nil then begin
          if not CopyImageDataToTexture(Buffer, pDXTexture.Surface, nLen, imginfo.DXInfo.nHeight) then
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
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;

procedure TWMM2DefImages.LoadIndex(idxfile: string);
var
  fhandle, i, value: integer;
  pvalue: PInteger;
  CharBuffer: array[0..4] of Char;
begin
  FIndexList.Clear;
  FImageCount := 0;
  if FileExists(idxfile) then begin
    fhandle := FileOpen(idxfile, fmOpenRead or fmShareDenyNone);
    if fhandle > 0 then begin
      FileRead(fhandle, CharBuffer[0], 5);
      if not (CompareText(CharBuffer, 'MirOf') = 0) then
        FileSeek(fHandle, 0, 0);
        
      if not FNewFmt then
        FileRead(fhandle, FIdxHeader, sizeof(TWMIndexHeader) - 4)
      else
        FileRead(fhandle, FIdxHeader, sizeof(TWMIndexHeader));

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

{ TWMM2DefBit16Images }
{$IFDEF WORKFILE}
{
function TWMM2DefBit16Images.GetImageBitmapEx(index: integer; out btType: Byte): TBitmap;
var
  nPosition: Integer;
  imginfo: TWMImageInfo;
  Buffer, WriteBuffer, ReadBuffer: PChar;
  ReadSize: Integer;
  Y: Integer;
begin
  Result := nil;
  btType := FILETYPE_IMAGE;
  if (index < 0) or (index >= FImageCount)  then
    exit;
  if index < FIndexList.Count then begin
    nPosition := Integer(FIndexList[index]);
    if FFileStream.Seek(nPosition, 0) <> nPosition then exit;
    if not FNewFmt then
      FFileStream.Read(imginfo, SizeOf(imginfo) - SizeOf(Integer))
    else
      FFileStream.Read(imginfo, SizeOf(imginfo));
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    ReadSize := imginfo.DXInfo.nWidth * imgInfo.DXInfo.nHeight * 2;
    GetMem(Buffer, ReadSize);
    try
      SafeFillChar(Buffer^, ReadSize, 0);
      if FFileStream.Read(Buffer^, ReadSize) = ReadSize then begin
        FLastImageInfo := imginfo.DXInfo;
        Result := TBitmap.Create;
        Result.PixelFormat := pf16bit;
        Result.Width := imginfo.DXInfo.nWidth;
        Result.Height := imginfo.DXInfo.nHeight;
        for Y := 0 to Result.Height - 1 do begin
          WriteBuffer := Result.ScanLine[Result.Height - Y - 1];
          ReadBuffer := @Buffer[Y * Result.Width * 2];
          Move(ReadBuffer^, WriteBuffer^, Result.Width * 2);
        end;
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;     }
  {
function TWMM2DefBit16Images.CopyDataToTexture(index: integer; Texture: TDXImageTexture): Boolean;
var
  nPosition: Integer;
  imginfo: TWMImageInfo;
  Buffer: PChar;
  ReadSize: Integer;
begin
  Result := False;
  if (index < 0) or (index >= FImageCount) or (Texture = nil) then
    exit;
  if index < FIndexList.Count then begin
    nPosition := Integer(FIndexList[index]);
    if FFileStream.Seek(nPosition, 0) <> nPosition then exit;
    if not FNewFmt then
      FFileStream.Read(imginfo, SizeOf(imginfo) - SizeOf(Integer))
    else
      FFileStream.Read(imginfo, SizeOf(imginfo));
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    ReadSize := imginfo.DXInfo.nWidth * imgInfo.DXInfo.nHeight * 2;
    GetMem(Buffer, ReadSize);
    try
      SafeFillChar(Buffer^, ReadSize, 0);
      if FFileStream.Read(Buffer^, ReadSize) = ReadSize then begin
        FLastImageInfo := imginfo.DXInfo;
        Texture.Active := False;
        Texture.Format := D3DFMT_A4R4G4B4;
        Texture.Size := Point(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight);
        Texture.PatternSize := Point(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight);
        Texture.Active := True;
        Result := CopyImageDataToTexture(Buffer, Texture, imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight);
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;       }
{$ENDIF}
{
function TWMM2DefBit16Images.CopyImageDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word): Boolean;
var
  Y: Integer;
  Access: TDXAccessInfo;
  WriteBuffer, ReadBuffer: PChar;
begin
  Result := False;
  if Texture.Lock(lfWriteOnly, Access) then begin
    try
      SafeFillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
      for Y := 0 to Height - 1 do begin
        WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
        ReadBuffer := @Buffer[(Height - 1 - Y) * Width * 2];
        LineR5G6B5_A4R4G4B4(ReadBuffer, WriteBuffer, Width);
      end;
      Result := True;
    finally
      Texture.Unlock;
    end;
  end;
end;      }
 {
procedure TWMM2DefBit16Images.LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface);
var
  imginfo: TWMImageInfo;
  Buffer: PChar;
  ReadSize: Integer;
begin
  pDXTexture.boNotRead := True;
  if FFileStream.Seek(position, 0) = position then begin;
    if not FNewFmt then
      FFileStream.Read(imginfo, SizeOf(imginfo) - SizeOf(Integer))
    else
      FFileStream.Read(imginfo, SizeOf(imginfo));
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    ReadSize := imginfo.DXInfo.nWidth * imgInfo.DXInfo.nHeight * 2;
    GetMem(Buffer, ReadSize);
    try
      if FFileStream.Read(Buffer^, ReadSize) = ReadSize then begin
        pDXTexture.Surface := MakeDXImageTexture(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight, WILFMT_A1R5G5B5);
        if pDXTexture.Surface <> nil then begin
          if not CopyImageDataToTexture(Buffer, pDXTexture.Surface, imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight) then
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
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;    }

{ TWMM2DefBit16Images }

constructor TWMM2DefBit16Images.Create;
begin
  inherited;
  Fbo16bit := True;
end;

end.

