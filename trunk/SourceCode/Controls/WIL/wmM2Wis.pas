unit wmM2Wis;

interface
uses
  Windows, Classes, Graphics, SysUtils, TDX9Textures, HUtil32, WIL, MyDirect3D9;

type
  TWMIndexInfo = packed record
    nIndex: Integer;
    nSize: Integer;
    nUnknown: Integer;
  end;
  pTWMIndexInfo = ^TWMIndexInfo;

  TWMImageInfo = packed record
    nEncrypt: Integer;
    DXInfo: TDXTextureInfo;
  end;
  pTWMImageInfo = ^TWMImageInfo;

  TWMM2WisImages = class(TWMBaseImages)
  private
    FSizeList: TList;
    procedure LoadIndex();
{$IFDEF WORKFILE}
    function DecodeOfbit8(Source, Target: Pointer; TargetLen: LongWord): Boolean;
{$ENDIF}
    function DecodeOfbit8Tobit16(Source, Target: Pointer; TargetLen: LongWord): Boolean;
    function CopyImageDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word; Decode: Integer): Boolean;
  protected
    procedure LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface); override;
{$IFDEF WORKFILE}
    function GetImageBitmapEx(index: integer; out btType: Byte): TBitmap; override;
{$ENDIF}
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Initialize(): Boolean; override;
    procedure Finalize; override;

{$IFDEF WORKFILE}
    function CopyDataToTexture(index: integer; Texture: TDXImageTexture): Boolean; override;
{$ENDIF}
  end;

implementation

{ TWMM2WisImages }

procedure TWMM2WisImages.LoadDxImage(index: Integer; position: integer; pDXTexture: pTDXTextureSurface);
var
  imginfo: TWMImageInfo;
  Buffer: PChar;
  ReadSize: Integer;
begin
  pDXTexture.boNotRead := True;
  if FFileStream.Seek(position, 0) = position then begin
    ReadSize := Integer(FSizeList[index]);
    FFileStream.Read(imginfo, SizeOf(imginfo));
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;

    GetMem(Buffer, ReadSize);
    try
      if FFileStream.Read(Buffer^, ReadSize) = ReadSize then begin
        pDXTexture.Surface := MakeDXImageTexture(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight, WILFMT_A1R5G5B5);
        if pDXTexture.Surface <> nil then begin
          if not CopyImageDataToTexture(Buffer, pDXTexture.Surface, imginfo.DXInfo.nWidth, imgInfo.DXInfo.nHeight, imginfo.nEncrypt) then begin
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

function TWMM2WisImages.CopyImageDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word; DEcode: Integer): Boolean;
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
      SafeFillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
      {if (Texture.Size.X = Width) and (Texture.Size.Y = Height) then begin
        if Decode then begin
          Result := DecodeOfbit8Tobit16(Buffer, Access.Bits, Width * Height);
        end
        else begin
          LineX8_A4R4G4B4(Buffer, Access.Bits, Width * Height);
          Result := True;
        end;
      end
      else begin       }
      case DEcode of
        0: begin
            for Y := 0 to Height - 1 do begin
              ReadBuffer := @Buffer[Y * Width];
              WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
              LineX8_A1R5G5B5(ReadBuffer, WriteBuffer, Width);
            end;
            Result := True;
          end;
        1: begin
            DecodeBuffer := AllocMem(Width * Height * 2);
            Try
              Result := DecodeOfbit8Tobit16(Buffer, DecodeBuffer, Width * Height);
              if Result then begin
                for Y := 0 to Height - 1 do begin
                  ReadBuffer := @DecodeBuffer[Y * Width * 2];
                  WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
                  Move(ReadBuffer^, WriteBuffer^, Width * 2);
                end;
              end;
            Finally
              FreeMem(DecodeBuffer);
            End;
        end;
        2: begin
            for Y := 0 to Height - 1 do begin
              ReadBuffer := @Buffer[Y * Width * 2];
              WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
              LineR5G6B5_A1R5G5B5(ReadBuffer, WriteBuffer, Width);
            end;
            Result := True;
          end;
        3: begin

          end;
      end;
    finally
      Texture.Unlock;
    end;
  end;

end;

constructor TWMM2WisImages.Create;
begin
  inherited;
  FReadOnly := True;
  FSizeList := TList.Create;
end;

function TWMM2WisImages.DecodeOfbit8Tobit16(Source, Target: Pointer; TargetLen: LongWord): Boolean;
var
  SourcePtr: PByte;
  TargetPtr: PWord;
  RunLength: Cardinal;
  Counter: Cardinal;
  I: Integer;
  wColor: Word;
begin
  Result := False;
  Counter := 0;
  TargetPtr := Target;
  SourcePtr := Source;
  while Counter < TargetLen do begin
    RunLength := SourcePtr^;
    if RunLength = 0 then begin
      Inc(SourcePtr);
      RunLength := SourcePtr^;
      Inc(SourcePtr);
      for I := 0 to RunLength - 1 do begin
        TargetPtr^ := X8_A1R5G5B5[SourcePtr^];
        Inc(SourcePtr);
        Inc(TargetPtr);
      end;
      Inc(Counter, RunLength);
    end
    else begin
      Inc(SourcePtr);
      Inc(Counter, RunLength);
      wColor := X8_A1R5G5B5[SourcePtr^];
      Inc(SourcePtr);
      for I := 0 to RunLength - 1 do begin
        TargetPtr^ := wColor;
        Inc(TargetPtr);
      end;
    end;
  end;
  if Counter = TargetLen then
    Result := True;
end;

destructor TWMM2WisImages.Destroy;
begin
  FreeAndNil(FSizeList);
  inherited;
end;

procedure TWMM2WisImages.Finalize;
begin
  inherited;
end;

function TWMM2WisImages.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if Result then begin
    LoadIndex();
    InitializeTexture;
  end;
end;

procedure TWMM2WisImages.LoadIndex;
var
  WMIndexInfo: TWMIndexInfo;
  IndexList, SizeList: TList;
  I: Integer;
begin
  FIndexList.Clear;
  FSizeList.Clear;
  IndexList := TList.Create;
  SizeList := TList.Create;
  FImageCount := 0;
  FFileStream.Seek(-SizeOf(WMIndexInfo), soFromEnd);
  while True do begin
    if FFileStream.Read(WMIndexInfo, SizeOf(WMIndexInfo)) = SizeOf(WMIndexInfo) then begin
      IndexList.add(pointer(WMIndexInfo.nIndex));
      SizeList.add(pointer(WMIndexInfo.nSize));
      FFileStream.Seek(- (SizeOf(WMIndexInfo) * 2), soFromCurrent);
      if WMIndexInfo.nIndex = 512 then break;
      
    end
    else
      break;
  end;
  for I := IndexList.Count - 1 downto 0 do begin
    FIndexList.Add(IndexList[I]);
    FSizeList.Add(SizeList[I]);
  end;
  FImageCount := FIndexList.Count;
  {if FFileStream.Read(WMIndexInfo, SizeOf(WMIndexInfo)) = SizeOf(WMIndexInfo) then begin
    FFileStream.Seek(WMIndexInfo.nIndex + WMIndexInfo.nSize, soFromBeginning);
    while True do begin
      if FFileStream.Read(WMIndexInfo, SizeOf(WMIndexInfo)) = SizeOf(WMIndexInfo) then begin
        FIndexList.Add(pointer(WMIndexInfo.nIndex));
        FSizeList.Add(pointer(WMIndexInfo.nSize));
      end
      else
        break;
    end;
    FImageCount := FIndexList.Count;
  end; }
end;

//工作区-----------------------------------------------------------------------------------------------------------------
{$IFDEF WORKFILE}

function TWMM2WisImages.DecodeOfbit8(Source, Target: Pointer; TargetLen: LongWord): Boolean;
var
  SourcePtr, TargetPtr: PByte;
  RunLength: Cardinal;
  Counter: Cardinal;
begin
  Result := False;
  Counter := 0;
  TargetPtr := Target;
  SourcePtr := Source;
  while Counter < TargetLen do begin
    RunLength := SourcePtr^;
    if RunLength = 0 then begin
      Inc(SourcePtr);
      RunLength := SourcePtr^;
      Inc(SourcePtr);
      Move(SourcePtr^, TargetPtr^, RunLength);
      Inc(SourcePtr, RunLength);
      Inc(TargetPtr, RunLength);
      Inc(Counter, RunLength);
    end
    else begin
      Inc(SourcePtr);
      SafeFillChar(TargetPtr^, RunLength, SourcePtr^);
      Inc(TargetPtr, RunLength);
      Inc(SourcePtr);
      Inc(Counter, RunLength);
    end;
  end;
  if Counter = TargetLen then
    Result := True;
end;

function TWMM2WisImages.GetImageBitmapEx(index: integer; out btType: Byte): TBitmap;
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
    ReadSize := Integer(FSizeList[index]);
    if FFileStream.Seek(nPosition, 0) <> nPosition then
      exit;
    FFileStream.Read(imginfo, SizeOf(imginfo));

    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
      
    //ReadSize := imginfo.DXInfo.nWidth * imgInfo.DXInfo.nHeight;
    GetMem(Buffer, ReadSize);
    try
      if FFileStream.Read(Buffer^, ReadSize) = ReadSize then begin
        FLastImageInfo := imginfo.DXInfo;
        if imginfo.nEncrypt = 1 then begin //加密8bit
          GetMem(DecodeBuffer, imginfo.DXInfo.nWidth * imgInfo.DXInfo.nHeight);
          if DecodeOfbit8(Buffer, DecodeBuffer, imginfo.DXInfo.nWidth * imgInfo.DXInfo.nHeight) then begin
            Result := TBitmap.Create;
            Result.PixelFormat := pf8bit;
            Result.Width := imginfo.DXInfo.nWidth;
            Result.Height := imginfo.DXInfo.nHeight;
            for Y := 0 to Result.Height - 1 do begin
              WriteBuffer := Result.ScanLine[Y];
              ReadBuffer := @DecodeBuffer[Y * Result.Width];
              Move(ReadBuffer^, WriteBuffer^, Result.Width);
            end;
          end;
          FreeMem(DecodeBuffer);
        end
        else
        if imginfo.nEncrypt = 2 then begin //未加密16bit
          Result := TBitmap.Create;
          Result.PixelFormat := pf16bit;
          Result.Width := imginfo.DXInfo.nWidth;
          Result.Height := imginfo.DXInfo.nHeight;
          for Y := 0 to Result.Height - 1 do begin
            WriteBuffer := Result.ScanLine[Y];
            ReadBuffer := @Buffer[Y * Result.Width * 2];
            Move(ReadBuffer^, WriteBuffer^, Result.Width * 2);
          end;
        end
        else
        if imginfo.nEncrypt = 3 then begin //加密16bit
          {GetMem(DecodeBuffer, imginfo.DXInfo.nWidth * imgInfo.DXInfo.nHeight * 2);
          //if
          //DecodeOfbit8(Buffer, DecodeBuffer, imginfo.DXInfo.nWidth * imgInfo.DXInfo.nHeight);// then begin
            Result := TBitmap.Create;
            Result.PixelFormat := pf16bit;
            Result.Width := imginfo.DXInfo.nWidth;
            Result.Height := imginfo.DXInfo.nHeight;
            for Y := 0 to Result.Height div 2 do begin
              WriteBuffer := Result.ScanLine[Y];
              ReadBuffer := @Buffer[Y * Result.Width * 2];
              Move(ReadBuffer^, WriteBuffer^, Result.Width * 2);
            end;
          //end;
          FreeMem(DecodeBuffer); }
        end
        else
        if imginfo.nEncrypt = 0 then begin //未加密8bit
          Result := TBitmap.Create;
          Result.PixelFormat := pf8bit;
          Result.Width := imginfo.DXInfo.nWidth;
          Result.Height := imginfo.DXInfo.nHeight;
          for Y := 0 to Result.Height - 1 do begin
            WriteBuffer := Result.ScanLine[Y];
            ReadBuffer := @Buffer[Y * Result.Width];
            Move(ReadBuffer^, WriteBuffer^, Result.Width);
          end;
        end else begin
          Result := nil;
          raise Exception.Create ('not Encrypt code ' + IntToStr(imginfo.nEncrypt));
          exit;
        end;
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;

function TWMM2WisImages.CopyDataToTexture(index: integer; Texture: TDXImageTexture): Boolean;
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
    ReadSize := Integer(FSizeList[index]);
    if FFileStream.Seek(nPosition, 0) <> nPosition then
      exit;

    FFileStream.Read(imginfo, SizeOf(imginfo));

    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    GetMem(Buffer, ReadSize);
    try
      if FFileStream.Read(Buffer^, ReadSize) = ReadSize then begin
        FLastImageInfo := imginfo.DXInfo;
        Texture.Active := False;
        Texture.Format := D3DFMT_A1R5G5B5;
        Texture.Size := Point(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight);
        Texture.PatternSize := Point(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight);
        Texture.Active := True;
        //Texture.PatternSize := Point(imginfo.DXInfo.nWidth, imginfo.DXInfo.nHeight);
        Result := CopyImageDataToTexture(Buffer, Texture, imginfo.DXInfo.nWidth, imgInfo.DXInfo.nHeight, imginfo.nEncrypt);
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;
{$ENDIF}

end.

