unit wmMyImage;

interface
uses
  Windows, Classes, Graphics, SysUtils, MyDirect3D9, TDX9Textures, HUtil32, WIL;

const
  HEADERNAME = 'DATA';

type
  TWMImageHeader = packed record
    Title: array[0..3] of char;
    OffsetSize: Integer;
    ImageCount: integer;
    IndexOffset: integer;
    UpDateTime: TDateTime;
    nPre: array[0..7] of Byte;
  end;

  TWMImageInfo = packed record
    DXInfo: TDXTextureInfo;
    nDataSize: Integer;
    btFileType: Byte;
    boEncrypt: Boolean;
    boZip: Boolean;
    btZipLevel: Byte;
    nPre: Integer;
  end;
  pTWMImageInfo = ^TWMImageInfo;

  TWMMyImageImages = class(TWMBaseImages)
  private
    FHeader: TWMImageHeader;
    function DecodeRLE(const Source, Target: Pointer; Count: Cardinal): Boolean;
    procedure LoadIndex();
    function CopyImageDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word; Decode: Boolean): Boolean;
  protected
    procedure LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface); override;
    function GetStream(index: integer): TMemoryStream; override;
{$IFDEF WORKFILE}
    function GetImageBitmapEx(index: integer; out btType: Byte): TBitmap; override;
{$ENDIF}
  public
    constructor Create(); override;
    function Initialize(): Boolean; override;
{$IFDEF WORKFILE}
    function SaveIndexList(): Boolean; override;
    procedure UpdateImageXY(index, nX, nY: Integer);
    function GetDataImageInfo(index: Integer): TWMImageInfo;
    function GetDataOffset(index: Integer; boStart: Boolean): Integer;
    function AddDataToFile(ImageInfo: pTWMImageInfo; Buffer: PChar; BufferLen: Integer): Boolean; overload;
    function AddDataToFile(Offset: Integer; Buffer: PChar; BufferLen: Integer): Boolean; overload;
    procedure InsertOffsetToList(OffList: TList; index, StartPos, OffsetPos: Integer);
    procedure UpdateOffsetToList(OffList: TList; index, StartPos, OffsetPos: Integer);
    procedure ChangeOffsetToList(Startindex, Endindex, ChangePos: Integer; boDel: Boolean);
    function CopyDataToTexture(index: integer; Texture: TDXImageTexture): Boolean; override;
{$ENDIF}
  end;

implementation

{ TWMMyImageImages }

procedure TWMMyImageImages.LoadDxImage(index, position: integer; pDXTexture: pTDXTextureSurface);
var
  imginfo: TWMImageInfo;
  Buffer: PChar;
  ReadSize: Integer;
begin
  pDXTexture.boNotRead := True;
  if FFileStream.Seek(position, 0) = position then begin
    FFileStream.Read(imginfo, SizeOf(imginfo));

    if (imginfo.btFileType <> FILETYPE_IMAGE) or (imginfo.nDataSize <= 0) then
      exit;
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;

    ReadSize := imginfo.nDataSize;
    GetMem(Buffer, ReadSize);
    try
      if FFileStream.Read(Buffer^, ReadSize) = ReadSize then begin
        pDXTexture.Surface := MakeDXImageTexture(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight);
        if pDXTexture.Surface <> nil then begin
          if not CopyImageDataToTexture(Buffer, pDXTexture.Surface, imginfo.DXInfo.nWidth, imgInfo.DXInfo.nHeight,
            imginfo.boEncrypt) then begin
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

function TWMMyImageImages.CopyImageDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word; Decode: Boolean): Boolean;
var
  Y: Integer;
  Access: TDXAccessInfo;
  WriteBuffer, ReadBuffer, DecodeBuffer: PChar;
begin
  Result := False;
  if (Texture.Size.X < Width) or (Texture.Size.Y < Height) then
    exit;
  if Texture.Lock(lfWriteOnly, Access) then begin
    try
      FillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
      if (Texture.Size.X = Width) and (Texture.Size.Y = Height) then begin
        if Decode then begin
          Result := DecodeRLE(Buffer, Access.Bits, Width * Height * 2);
        end
        else begin
          Move(Buffer^, Access.Bits^, Width * Height * 2);
          Result := True;
        end;
      end
      else begin
        if Decode then begin
          DecodeBuffer := AllocMem(Width * Height * 2);
          Result := DecodeRLE(Buffer, DecodeBuffer, Width * Height * 2);
          if Result then begin
            for Y := 0 to Height - 1 do begin
              ReadBuffer := @DecodeBuffer[Y * Width * 2];
              WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
              Move(ReadBuffer^, WriteBuffer^, Width * 2);
            end;
          end;
        end
        else begin
          for Y := 0 to Height - 1 do begin
            ReadBuffer := @Buffer[Y * Width * 2];
            WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
            Move(ReadBuffer^, WriteBuffer^, Width * 2);
          end;
          Result := True;
        end;
      end;
    finally
      Texture.Unlock;
    end;
  end;
end;

constructor TWMMyImageImages.Create;
begin
  inherited;
  FReadOnly := False;
end;

function TWMMyImageImages.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if Result then begin
    FFileStream.Read(FHeader, SizeOf(TWMImageHeader));
    FImageCount := FHeader.ImageCount;
    LoadIndex;
    InitializeTexture;
  end;
end;

procedure TWMMyImageImages.LoadIndex;
var
  i, value: integer;
  pvalue: PInteger;
begin
  FIndexList.Clear;
  FImageCount := 0;
  if FHeader.IndexOffset > 0 then begin
    FFileStream.Seek(FHeader.IndexOffset, soFromBeginning);
    GetMem(pvalue, 4 * FHeader.ImageCount);
    if FFileStream.Read(pvalue^, 4 * FHeader.ImageCount) = (4 * FHeader.ImageCount) then begin
      for i := 0 to FHeader.ImageCount - 1 do begin
        value := PInteger(integer(pvalue) + 4 * i)^;
        FIndexList.Add(pointer(value));
      end;
    end;
    FreeMem(pvalue);
  end else
    FHeader.IndexOffset := SizeOf(FHeader);
  FImageCount := FIndexList.Count;
end;

function TWMMyImageImages.DecodeRLE(const Source, Target: Pointer; Count: Cardinal): Boolean;
var
  I: Integer;
  SourcePtr,
    TargetPtr: PByte;
  RunLength: Cardinal;
  Counter: Cardinal;
begin
  Counter := 0;
  TargetPtr := Target;
  SourcePtr := Source;

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
    end
    else begin
      Inc(SourcePtr);
      Move(SourcePtr^, TargetPtr^, 2 * RunLength);
      Inc(SourcePtr, 2 * RunLength);
      Inc(TargetPtr, 2 * RunLength);
    end;
    Inc(Counter, 2 * RunLength);
  end;
  Result := Counter = Count;
end;

function TWMMyImageImages.GetStream(index: integer): TMemoryStream;
begin
  Result := nil;
end;

{$IFDEF WORKFILE}

function TWMMyImageImages.AddDataToFile(ImageInfo: pTWMImageInfo; Buffer: PChar; BufferLen: Integer): Boolean;
begin
  Result := False;
  if FFileStream.Seek(FHeader.IndexOffset, 0) = FHeader.IndexOffset then begin
    FFileStream.Write(ImageInfo^, SizeOf(TWMImageInfo));
    FFileStream.Write(Buffer^, BufferLen);
    FIndexList.Add(Pointer(FHeader.IndexOffset));
    Inc(FImageCount);
    Inc(FHeader.IndexOffset, BufferLen + SizeOf(TWMImageInfo));
    Result := True;
  end;
end;

function TWMMyImageImages.AddDataToFile(Offset: Integer; Buffer: PChar; BufferLen: Integer): Boolean;
begin
  Result := False;
  if FFileStream.Seek(Offset, 0) = Offset then begin
    FFileStream.Write(Buffer^, BufferLen);
    Result := True;
  end;
end;

function TWMMyImageImages.CopyDataToTexture(index: integer; Texture: TDXImageTexture): Boolean;
var
  nPosition: Integer;
  imginfo: TWMImageInfo;
  Buffer: PChar;
  ReadSize: Integer;
begin
  Result := False;
  if (index < 0) or (index >= FImageCount) or (Texture = nil) or (not Texture.Active) then
    exit;
  if index < FIndexList.Count then begin
    nPosition := Integer(FIndexList[index]);
    if FFileStream.Seek(nPosition, 0) <> nPosition then exit;
    FFileStream.Read(imginfo, SizeOf(imginfo));

    if (imginfo.btFileType <> FILETYPE_IMAGE) or (imginfo.nDataSize <= 0) then
      exit;
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    ReadSize := imginfo.nDataSize;
    Buffer := AllocMem(ReadSize);
    try
      if FFileStream.Read(Buffer^, ReadSize) = ReadSize then begin
        FLastImageInfo := imginfo.DXInfo;
        Texture.PatternSize := Point(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight);
        Result := CopyImageDataToTexture(Buffer, Texture, imginfo.DXInfo.nWidth,
          imgInfo.DXInfo.nHeight, imginfo.boEncrypt);
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;

procedure TWMMyImageImages.UpdateImageXY(index, nX, nY: Integer);
var
  nPosition: Integer;
  DXInfo: TDXTextureInfo;
begin
  if (index < 0) or (index >= FImageCount)  then
    exit;
  if index < FIndexList.Count then begin
    nPosition := Integer(FIndexList[index]);
    if FFileStream.Seek(nPosition, 0) <> nPosition then exit;
    FFileStream.Read(DXInfo, SizeOf(TDXTextureInfo));
    FFileStream.Seek(-SizeOf(TDXTextureInfo), soFromCurrent);
    DXInfo.px := nX;
    DXInfo.py := nY;
    FFileStream.Write(DXInfo, SizeOf(TDXTextureInfo));
  end;
end;

function TWMMyImageImages.GetDataImageInfo(index: Integer): TWMImageInfo;
var
  nPosition: Integer;
begin
  FillChar(Result, SizeOf(TWMImageInfo), #0);
  if (index < 0) or (index >= FImageCount)  then
    exit;
  if index < FIndexList.Count then begin
    nPosition := Integer(FIndexList[index]);
    if FFileStream.Seek(nPosition, 0) <> nPosition then exit;
    FFileStream.Read(Result, SizeOf(TWMImageInfo));
  end;
end;

function TWMMyImageImages.GetDataOffset(index: Integer; boStart: Boolean): Integer;
begin
  Result := FHeader.IndexOffset;
  if (index < 0) or (index >= FImageCount) or (index >= FIndexList.Count) then
      exit;
  if boStart then begin
    while index >= 0 do begin
      Result := Integer(FIndexList[index]);
      if Result > 0 then exit;
      Dec(index);
    end;
    Result := SizeOf(FHeader);
  end else begin
    while index < FIndexList.Count do begin
      Result := Integer(FIndexList[index]);
      if Result > 0 then exit;
      Inc(index);
    end;
    Result := FHeader.IndexOffset;
  end;
end;

function TWMMyImageImages.GetImageBitmapEx(index: integer; out btType: Byte): TBitmap;
  function Blend(ScrCol: Word): Word;
  var
    Alpha: Byte;
    dR, dG, dB: Byte;
  begin
    Alpha := (ScrCol shr 12) and $0F;
    case Alpha of
      $00: Result := 0;
      $0F: Result := (((ScrCol shl 1) and $1E) or
          (((ScrCol shr 2) and $3C) shl 5) or
          (((ScrCol shr 7) and $1E) shl 11));
    else
      dB := 0;
      dG := 0;
      dR := 0;

      Result := ((Alpha * ((ScrCol shl 1) and $1E - dB) shr 4 + dB) or
        ((Alpha * ((ScrCol shr 2) and $3C - dG) shr 4 + dG) shl 5) or
        ((Alpha * ((ScrCol shr 7) and $1E - dR) shr 4 + dR) shl 11));
    end;
  end;
var
  nPosition: Integer;
  imginfo: TWMImageInfo;
  Buffer, DecodeBuffer: PChar;
  WriteBuffer, ReadBuffer: PWord;
  ReadSize: Integer;
  Y, X: Integer;
begin
  Result := nil;
  btType := FILETYPE_IMAGE;
  if (index < 0) or (index >= FImageCount) {or (FLibType <> ltLoadBmp)} then
    exit;
  if index < FIndexList.Count then begin
    nPosition := Integer(FIndexList[index]);
    if FFileStream.Seek(nPosition, 0) <> nPosition then exit;
    FFileStream.Read(imginfo, SizeOf(imginfo));

    btType := imginfo.btFileType;
    if (imginfo.btFileType <> FILETYPE_IMAGE) or (imginfo.nDataSize <= 0) then
      exit;
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    ReadSize := imginfo.nDataSize;
    Buffer := AllocMem(ReadSize);
    try
      if FFileStream.Read(Buffer^, ReadSize) = ReadSize then begin
        FLastImageInfo := imginfo.DXInfo;
        if imginfo.boEncrypt then begin
          GetMem(DecodeBuffer, imginfo.DXInfo.nWidth * imgInfo.DXInfo.nHeight * 2);
          Try
            if DecodeRLE(Buffer, DecodeBuffer, imginfo.DXInfo.nWidth * imgInfo.DXInfo.nHeight * 2) then begin
              Result := TBitmap.Create;
              Result.PixelFormat := pf16bit;
              Result.Width := imginfo.DXInfo.nWidth;
              Result.Height := imginfo.DXInfo.nHeight;
              for Y := 0 to Result.Height - 1 do begin
                WriteBuffer := Result.ScanLine[Y];
                ReadBuffer := @DecodeBuffer[Y * Result.Width * 2];
                for X := 0 to Result.Width - 1 do begin
                  WriteBuffer^ := Blend(ReadBuffer^);
                  Inc(WriteBuffer);
                  Inc(ReadBuffer);
                end;
              end;
            end;
          Finally
            FreeMem(DecodeBuffer);
          End;
        end else begin
          Result := TBitmap.Create;
          Result.PixelFormat := pf16bit;
          Result.Width := imginfo.DXInfo.nWidth;
          Result.Height := imginfo.DXInfo.nHeight;
          for Y := 0 to Result.Height - 1 do begin
            WriteBuffer := Result.ScanLine[Y];
            ReadBuffer := @Buffer[Y * Result.Width * 2];
            for X := 0 to Result.Width - 1 do begin
              WriteBuffer^ := Blend(ReadBuffer^);
              Inc(WriteBuffer);
              Inc(ReadBuffer);
            end;
          end;
        end;
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;

 {
function TWMMyImageImages.GetStream(index: integer): TMemoryStream;
begin
  Result := nil;
end;
        }
procedure TWMMyImageImages.InsertOffsetToList(OffList: TList; index, StartPos, OffsetPos: Integer);
var
  i: integer;
  nPos: Integer;
begin
  for I := 0 to OffList.Count - 1 do begin
    nPos := Integer(OffList[I]);
    if nPos = -1 then FIndexList.Insert(index + I, nil)
    else FIndexList.Insert(index + I, Pointer(nPos + StartPos));
  end;
  while (index + Offlist.Count) < FindexList.Count do begin
    nPos := Integer(FindexList[index + Offlist.Count]);
    if nPos > 0 then
      FindexList[index + Offlist.Count] := Pointer(nPos + OffsetPos);
    Inc(index);
  end;
  FImageCount := FIndexList.Count;
  FHeader.ImageCount := FImageCount;
  Inc(FHeader.IndexOffset, OffsetPos);
end;

procedure TWMMyImageImages.UpdateOffsetToList(OffList: TList; index, StartPos, OffsetPos: Integer);
var
  i: integer;
  nPos: Integer;
begin
  i := 0;
  while index < FindexList.Count do begin
    if i < OffList.Count then begin
      nPos := Integer(OffList[I]);
      if nPos = -1 then FindexList[index] := nil
      else FindexList[index] := Pointer(nPos + StartPos);
    end else begin
      nPos := Integer(FindexList[index]);
      if nPos > 0 then
        FindexList[index] := Pointer(nPos + OffsetPos);
    end;
    Inc(index);
    Inc(I);
  end;
  Inc(FHeader.IndexOffset, OffsetPos);
end;

procedure TWMMyImageImages.ChangeOffsetToList(Startindex, Endindex, ChangePos: Integer; boDel: Boolean);
var
  index: Integer;
  nPos: Integer;
begin
  if ChangePos > 0 then begin
    index := Endindex + 1;
    while index < FindexList.Count do begin
      nPos := Integer(FindexList[index]);
      if nPos > 0 then begin
        Dec(nPos, ChangePos);
        FindexList[index] := Pointer(nPos);
      end;
      Inc(index);
    end;
    Dec(FHeader.IndexOffset, ChangePos);
  end;
  for index := Endindex downto Startindex do begin
    if boDel then FindexList.Delete(index)
    else FindexList[index] := nil;
  end;
  FImageCount := FIndexList.Count;
  FHeader.ImageCount := FImageCount;
end;

function TWMMyImageImages.SaveIndexList: Boolean;
begin
  Result := False;
  FHeader.ImageCount := FIndexList.Count;
  FFileStream.Seek(0, soFromBeginning);
  FFileStream.Write(FHeader, SizeOf(FHeader));
  if FIndexList.Count > 0 then begin
    FFileStream.Seek(FHeader.IndexOffset - SizeOf(FHeader), soFromCurrent);
    FFileStream.Write(FIndexList.List[0], FIndexList.Count * SizeOf(Pointer));
  end;
end;
{$ENDIF}

end.

