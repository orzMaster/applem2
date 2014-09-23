unit wmWoool;

interface
uses
  Windows, Classes, Graphics, SysUtils, MyDirect3D9, TDX9Textures, HUtil32, WIL;

type
  TWMImageHeader = packed record
    shTitle: array[0..31] of Char;
    shComp: DWord;
    shOffset: DWord;
  end;

  TWMIndexInfo = packed record
    siUnknown1: Byte;
    siFormat: Byte;
    siFrames: Word;
    siUnknown2: Word;
  end;
  pTWMImageInfo = ^TWMImageInfo;
  TWMImageInfo = packed record
    DXInfo: TDXTextureInfo;
    sfXBlocks: Byte;
    sfYBlocks: Byte;
  end;

  TWMWoolDefImages = class(TWMBaseImages)
  private
    FHeader: TWMImageHeader;
    FImageFormatList: TList;
    procedure LoadIndex();
    function DecodeFrame(FrameInfo: pTWMImageInfo; ADst: PByte; AWidthBytes: Integer; siFormat: Byte): Boolean;
    function CopyImageDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word): Boolean;
  protected
    function GetImageBitmapEx(index: integer; out btType: Byte): TBitmap; override;
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Initialize(): Boolean; override;
    procedure Finalize; override;

    function CopyDataToTexture(index: integer; Texture: TDXImageTexture): Boolean; override;
  end;

implementation

{ TWMWoolDefImages }

function TWMWoolDefImages.CopyDataToTexture(index: integer; Texture: TDXImageTexture): Boolean;
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
    if (nPosition = 0) or (FFileStream.Seek(nPosition, 0) <> nPosition) then
      exit;

    FFileStream.Read(imginfo, SizeOf(imginfo));
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    ReadSize := imginfo.DXInfo.nWidth * imginfo.DXInfo.nHeight * 2;
    GetMem(Buffer, ReadSize);
    try
      FillChar(Buffer^, ReadSize, 0);
      if DecodeFrame(@imginfo, PByte(Buffer), imginfo.DXInfo.nWidth * 2, Byte(FImageFormatList[index])) then begin
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
end;

function TWMWoolDefImages.CopyImageDataToTexture(Buffer: PChar; Texture: TDXImageTexture; Width, Height: Word): Boolean;
var
  Y: Integer;
  Access: TDXAccessInfo;
  WriteBuffer, ReadBuffer: PChar;
  //           SDBit, DDBit: PWORD;
begin
  Result := False;
  if Texture.Lock(lfWriteOnly, Access) then begin
    try
      FillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
      for Y := 0 to Height - 1 do begin
        WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
        ReadBuffer := @Buffer[Y * Width * 2];
        {for X := 0 to Width - 1 do begin
          SDBit := PWord(Integer(ReadBuffer) + X * 2);
          DDBit := PWord(Integer(WriteBuffer) + (Width - 1 - X) * 2);
          DDBit^ := SDBit^;
        end;    }

        Move(ReadBuffer^, WriteBuffer^, Width * 2);
        //LineR5G6B5_A4R4G4B4(ReadBuffer, WriteBuffer, Width);
      end;
      Result := True;
    finally
      Texture.Unlock;
    end;
  end;
end;

constructor TWMWoolDefImages.Create;
begin
  inherited;
  FReadOnly := True;
  FImageFormatList := TList.Create;
end;

function TWMWoolDefImages.DecodeFrame(FrameInfo: pTWMImageInfo; ADst: PByte; AWidthBytes: Integer; siFormat: Byte):
  Boolean;
  function SGL_RLE8_Decode(ASrc, ADst: PByte; ASrcSize, ADstSize: Integer): Boolean;
  var
    L: Byte;
  begin
    while (ASrcSize > 0) and (ADstSize > 0) do begin
      if (PByte(ASrc)^ and $80) = 0 then begin
        L := ASrc^;
        Inc(ASrc);
        Dec(ASrcSize, 2);
        if L > ADstSize then
          L := ADstSize;
        Dec(ADstSize, L);
        for L := 1 to L do begin
          ADst^ := ASrc^;
          Inc(ADst);
        end;
        Inc(ASrc);
      end
      else begin
        L := PByte(ASrc)^ and $7F;
        Inc(PByte(ASrc));
        Dec(ASrcSize, L + 1);
        if L > ADstSize then
          L := ADstSize;
        Dec(ADstSize, L);
        for L := 1 to L do begin
          ADst^ := ASrc^;
          Inc(ADst);
          Inc(ASrc);
        end;
      end;
    end;
    Result := True;
  end;

  function SGL_RLE16_Decode(ASrc, ADst: PWord; ASrcSize, ADstSize: Integer): Boolean;
  var
    L: Byte;
  begin
    while (ASrcSize > 0) and (ADstSize > 0) do begin
      if (PByte(ASrc)^ and $80) = 0 then begin
        L := PByte(ASrc)^;
        Inc(PByte(ASrc));
        Dec(ASrcSize, 3);
        if L > ADstSize then
          L := ADstSize;
        Dec(ADstSize, L * 2);
        for L := 1 to L do begin
          ADst^ := ASrc^;
          Inc(ADst);
        end;
        Inc(ASrc);
      end
      else begin
        L := PByte(ASrc)^ and $7F;
        Inc(PByte(ASrc));
        Dec(ASrcSize, L * 2 + 1);
        if L > ADstSize then
          L := ADstSize;
        Dec(ADstSize, L * 2);
        for L := 1 to L do begin
          ADst^ := ASrc^;
          Inc(ADst);
          Inc(ASrc);
        end;
      end;
    end;
    Result := True;
  end;

  procedure Blend(ScrCol: Word; var DesCol: Word);
  var
    Alpha: Byte;
    dR, dG, dB: Byte;
  begin
    //DesCol := ScrCol;
    Alpha := (ScrCol shr 12) and $0F;
    case Alpha of
      $00: ;
      $0F: DesCol := (((ScrCol shl 1) and $1E) or
          (((ScrCol shr 2) and $3C) shl 5) or
          (((ScrCol shr 7) and $1E) shl 11));
    else
      dB := DesCol and $1F;
      dG := (DesCol shr 5) and $3F;
      dR := (DesCol shr 11) and $1F;

      DesCol := ((Alpha * ((ScrCol shl 1) and $1E - dB) shr 4 + dB) or
        ((Alpha * ((ScrCol shr 2) and $3C - dG) shr 4 + dG) shl 5) or
        ((Alpha * ((ScrCol shr 7) and $1E - dR) shr 4 + dR) shl 11));
    end;
  end;

  procedure AlphaBlend(Alpha: Byte; ScrCol: Word; var DesCol: Word);
  var
    {sR, sG, sB: Byte;
    dR, dG, dB: Byte; }
    R, G, B: Byte;
  begin
    B := BYTE((ScrCol and $1F) shl 3);
    G := BYTE((ScrCol and $7E0) shr 3);
    R := BYTE((ScrCol and $F800) shr 8);
    DesCol := (Alpha and $F0 shl 8) +
      ((WORD(r) and $F0) shl 4) +
      (WORD(g) and $F0) +
      (WORD(b) shr 4);
    {case Alpha of
      $00: ;
      $0F: DesCol := ScrCol;
    else }
      {sB := ScrCol and $1F;
      sG := (ScrCol shr 5) and $3F;
      sR := (ScrCol shr 11) and $1F;    }
      {dB := DesCol and $1F;
      dG := (DesCol shr 5) and $3F;
      dR := (DesCol shr 11) and $1F;
      B := Alpha * (sB - dB) shr 8 + dB;
      G := Alpha * (sG - dG) shr 8 + dG;
      R := Alpha * (sR - dR) shr 8 + dR;

      DesCol := (B or (G shl 5) or (R shl 11));
    end;       }
  end;
var
  I: Integer;
  J: Integer;
  X: Integer;
  Y: Integer;
  W: Byte;
  H: Byte;
  nSize: DWord;
  lpSrc: PWord;
  lpData: PWord;
//  lpAlpha: PByte;
  lpDLine: PByte;
  lpSCur: PWord;
//  lpDCur: PWord;
//  lpACur: PByte;
begin
  Result := False;
  case siFormat of
    //------------------------------------------------------------------------------
    $02: {//未压缩  （高速版本）} begin
       { for Y := 0 to FrameInfo.sfYBlocks - 1 do
          for X := 0 to FrameInfo.sfXBlocks - 1 do begin
            FFileStream.Read(W, SizeOf(Byte));
            FFileStream.Read(H, SizeOf(Byte));
            nSize := (H + 1) * (W + 1) * 2;
            if (FFileStream.Position + nSize > FFileStream.Size) or
              (FrameInfo.DXInfo.nHeight * FrameInfo.DXInfo.nWidth * 2 <> nSize) then
              Exit;
            FFileStream.Read(ADst^, nSize);}
            {GetMem(lpSrc, nSize);
            try
              FFileStream.Read(lpSrc^, nSize);

              lpSCur := lpSrc;
              lpDLine := PByte(Integer(ADst) + Y * 256 * AWidthBytes + X * 256 * 2);
              for J := 0 to H do begin
                lpDCur := PWord(lpDLine);
                for I := 0 to W do begin
                  Blend(lpSCur^, lpDCur^);
                  Inc(lpSCur);
                  Inc(lpDCur);
                end;
                Inc(lpDLine, AWidthBytes);
              end;

            finally
              FreeMem(lpSrc);
            end;   }
          //end;
        //Result := True;
      end;
    //------------------------------------------------------------------------------
    $82: {//未压缩 有Alpha （高速版本）} begin
        {nSize := FrameInfo.DXInfo.nHeight * FrameInfo.DXInfo.nWidth * 2;
        if FFileStream.Position + nSize > FFileStream.Size then
          Exit;
        FFileStream.Read(ADst^, nSize);       }
        {GetMem(lpSrc, nSize);
        try
          FFileStream.Read(lpSrc^, nSize);

          nSize := FrameInfo.DXInfo.nHeight * FrameInfo.DXInfo.nWidth;
          if FFileStream.Position + nSize > FFileStream.Size then
            Exit;
          GetMem(lpAlpha, nSize);
          try
            FFileStream.Read(lpAlpha^, nSize);

            lpACur := lpAlpha;
            lpSCur := lpSrc;
            lpDLine := PByte(ADst);
            for Y := 1 to FrameInfo.DXInfo.nHeight do begin
              lpDCur := PWord(lpDLine);
              for X := 1 to FrameInfo.DXInfo.nWidth do begin
                AlphaBlend(lpACur^, lpSCur^, lpDCur^);
                Inc(lpACur);
                Inc(lpSCur);
                Inc(lpDCur);
              end;
              Inc(lpDLine, AWidthBytes);
            end;

            Result := True;
          finally
            FreeMem(lpAlpha);
          end;
        finally
          FreeMem(lpSrc);
        end; }
      end;
    //------------------------------------------------------------------------------
    $88: {//未压缩  （高速版本）} begin
       { nSize := FrameInfo.DXInfo.nHeight * FrameInfo.DXInfo.nWidth * 2;
        if FFileStream.Position + nSize > FFileStream.Size then
          Exit;
        FFileStream.Read(ADst^, nSize);   }
        {GetMem(lpSrc, nSize);
        try
          FFileStream.Read(lpSrc^, nSize);

          lpSCur := lpSrc;
          lpDLine := PByte(ADst);
          for Y := 1 to FrameInfo.DXInfo.nHeight do begin
            lpDCur := PWord(lpDLine);
            for X := 1 to FrameInfo.DXInfo.nWidth do begin
              if (lpSCur^ <> $FF00) then
                lpDCur^ := lpSCur^;
              Inc(lpSCur);
              Inc(lpDCur);
            end;
            Inc(lpDLine, AWidthBytes);
          end;

          Result := True;
        finally
          FreeMem(lpSrc);
        end; }

      end;
    //------------------------------------------------------------------------------
    $06: {//已压缩 有Alpha（高速版本）} begin
       (* FFileStream.Read(nSize, SizeOf(DWord));
        if FFileStream.Position + nSize > FFileStream.Size then
          Exit;
        I := FrameInfo.DXInfo.nHeight * FrameInfo.DXInfo.nWidth * 2;
        GetMem(lpSrc, I);
        try
          GetMem(lpData, nSize);
          try
            FFileStream.Read(lpData^, nSize);
            SGL_RLE16_Decode(lpData, lpSrc, nSize, I);
          finally
            FreeMem(lpData);
          end;
          //Move(lpSrc^, PChar(ADst)[J], I);
          //Inc(J, I);
          FFileStream.Read(nSize, SizeOf(DWord));
          if FFileStream.Position + nSize > FFileStream.Size then
            Exit;
          I := FrameInfo.DXInfo.nHeight * FrameInfo.DXInfo.nWidth;
          GetMem(lpAlpha, I);
          try
            GetMem(lpData, nSize);
            try
              FFileStream.Read(lpData^, nSize);
              SGL_RLE8_Decode(PByte(lpData), lpAlpha, nSize, I);
            finally
              FreeMem(lpData);
            end;

            lpACur := lpAlpha;
            lpSCur := lpSrc;
            lpDLine := PByte(ADst);
            for Y := 1 to FrameInfo.DXInfo.nHeight do begin
              lpDCur := PWord(lpDLine);
              for X := 1 to FrameInfo.DXInfo.nWidth do begin
                AlphaBlend(lpACur^, lpSCur^, lpDCur^);
                Inc(lpACur);
                Inc(lpSCur);
                Inc(lpDCur);
              end;
              Inc(lpDLine, AWidthBytes);
            end;

            Result := True;
          finally
            FreeMem(lpAlpha);
          end;
        finally
          FreeMem(lpSrc);
        end;      *)
      end;
    //------------------------------------------------------------------------------
    $18: {//已压缩  （高速版本）} begin
        (*exit;
        FFileStream.Read(nSize, SizeOf(DWord));
        if FFileStream.Position + nSize > FFileStream.Size then
          Exit;

        I := FrameInfo.DXInfo.nHeight * FrameInfo.DXInfo.nWidth * 2;
        GetMem(lpSrc, I);
        try
          GetMem(lpData, nSize);
          try
            FFileStream.Read(lpData^, nSize);
            SGL_RLE16_Decode(lpData, lpSrc, nSize, I);
          finally
            FreeMem(lpData);
          end;
          Move(lpSrc^, PChar(ADst)[J], I);
          Inc(J, I);
          {lpSCur := lpSrc;
          lpDLine := PByte(ADst);
          for Y := 1 to FrameInfo.DXInfo.nHeight do begin
            lpDCur := PWord(lpDLine);
            for X := 1 to FrameInfo.DXInfo.nWidth do begin
              if (lpSCur^ <> $FF00) then
                lpDCur^ := lpSCur^;
              Inc(lpSCur);
              Inc(lpDCur);
            end;
            Inc(lpDLine, AWidthBytes);
          end;

          Result := True; }
        finally
          FreeMem(lpSrc);
        end; *)
      end;
    //------------------------------------------------------------------------------
    $28: ;
    //------------------------------------------------------------------------------
    //------------------------------------------------------------------------------
    $11, $12: {//已压缩  （高画质版本）} begin
        //j := 0;
        for Y := 0 to FrameInfo.sfYBlocks - 1 do
          for X := 0 to FrameInfo.sfXBlocks - 1 do begin
            FFileStream.Read(W, SizeOf(Byte));
            FFileStream.Read(H, SizeOf(Byte));
            FFileStream.Read(nSize, SizeOf(DWord));
            if FFileStream.Position + nSize > FFileStream.Size then
              Exit;

            I := (H + 1) * (W + 1) * 2;
            GetMem(lpSrc, I);
            try
              GetMem(lpData, nSize);
              try
                FFileStream.Read(lpData^, nSize);
                SGL_RLE16_Decode(lpData, lpSrc, nSize, I);
              finally
                FreeMem(lpData);
              end;

              lpSCur := lpSrc;
              lpDLine := PByte(Integer(ADst) + Y * AWidthBytes * 256 + X * 256 * 2);
              for J := 0 to H do begin
                Move(lpSCur^, lpDLine^, (W + 1) * 2);
                Inc(lpSCur, W + 1);
                Inc(lpDLine, AWidthBytes);
              end;
            finally
              FreeMem(lpSrc);
            end;
          end;
        Result := True;
      end;
    //------------------------------------------------------------------------------
    $22: ;
    $62: ;
  end;
end;

destructor TWMWoolDefImages.Destroy;
begin
  FImageFormatList.Free;
  inherited;
end;

procedure TWMWoolDefImages.Finalize;
begin
  inherited;

end;

function TWMWoolDefImages.GetImageBitmapEx(index: integer; out btType: Byte): TBitmap;
  procedure Blend(ScrCol: Word; var DesCol: Word);
  var
    Alpha: Byte;
    dR, dG, dB: Byte;
  begin
    //DesCol := ScrCol;
    Alpha := (ScrCol shr 12) and $0F;
    case Alpha of
      $00: ;
      $0F: DesCol := (((ScrCol shl 1) and $1E) or
          (((ScrCol shr 2) and $3C) shl 5) or
          (((ScrCol shr 7) and $1E) shl 11));
    else
      dB := DesCol and $1F;
      dG := (DesCol shr 5) and $3F;
      dR := (DesCol shr 11) and $1F;

      DesCol := ((Alpha * ((ScrCol shl 1) and $1E - dB) shr 4 + dB) or
        ((Alpha * ((ScrCol shr 2) and $3C - dG) shr 4 + dG) shl 5) or
        ((Alpha * ((ScrCol shr 7) and $1E - dR) shr 4 + dR) shl 11));
    end;
  end;
var
  nPosition: Integer;
  imginfo: TWMImageInfo;
  Buffer: PChar;
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
    if (nPosition = 0) or (FFileStream.Seek(nPosition, 0) <> nPosition) then
      exit;

    FFileStream.Read(imginfo, SizeOf(imginfo));
    if (imginfo.DXInfo.nWidth > MAXIMAGESIZE) or (imgInfo.DXInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.DXInfo.nWidth < MINIMAGESIZE) or (imgInfo.DXInfo.nHeight < MINIMAGESIZE) then
      Exit;
    ReadSize := imginfo.DXInfo.nWidth * imginfo.DXInfo.nHeight * 2;
    GetMem(Buffer, ReadSize);
    try
      FillChar(Buffer^, ReadSize, 0);
      if DecodeFrame(@imginfo, PByte(Buffer), imginfo.DXInfo.nWidth * 2, Byte(FImageFormatList[index])) then begin
        FLastImageInfo := imginfo.DXInfo;
        Result := TBitmap.Create;
        Result.Canvas.Brush.Color := clBlack;
        Result.PixelFormat := pf16bit;
        Result.Width := imginfo.DXInfo.nWidth;
        Result.Height := imginfo.DXInfo.nHeight;
        //DecodeBuffer := Buffer; //temp
        for Y := 0 to Result.Height - 1 do begin
          ReadBuffer := @Buffer[Y * Result.Width * 2];
          WriteBuffer := Result.ScanLine[Y];
          for X := 0 to Result.Width - 1 do begin
            Blend(ReadBuffer^, WriteBuffer^);
            Inc(ReadBuffer);
            Inc(WriteBuffer);
          end;
        end;
      end;
    finally
      FreeMem(Buffer);
    end;
    {ReadSize := imginfo.dwImageLength * 2;
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
    end;   }
  end;
end;

function TWMWoolDefImages.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if Result then begin
    FFileStream.Read(FHeader, SizeOf(TWMImageHeader));
    LoadIndex;
    InitializeTexture;
  end;
end;

procedure TWMWoolDefImages.LoadIndex;
var
  ImageOffs, FFrameOffs: array of DWord;
  i, nCount, nBlocks, nSize: integer;
  FImageInfo: TWMIndexInfo;
  FFrames: TWMImageInfo;
begin
  FIndexList.Clear;
  FImageFormatList.Clear;
  FFileStream.Position := FHeader.shOffset;
  FFileStream.Read(FImageCount, SizeOf(Integer));
  if (Int64(FHeader.shOffset) + Int64(FImageCount * (SizeOf(DWord) + 16))) > FFileStream.Size then
    Exit;
  SetLength(ImageOffs, FImageCount);
  FImageCount := 0;
  FFileStream.Read(ImageOffs[0], Length(ImageOffs) * SizeOf(DWord));
  for I := 0 to High(ImageOffs) do begin
    if ImageOffs[i] = 0 then begin
      {Inc(FImageCount);
      FIndexList.Add(nil);
      FImageFormatList.Add(nil);    }
      Continue;
    end;
    FFileStream.Position := ImageOffs[i];
    FFileStream.Read(FImageInfo, SizeOf(FImageInfo));
    nCount := FImageInfo.siFrames;
    if nCount > 0 then begin
      SetLength(FFrameOffs, nCount);
      FillChar(FFrameOffs[0], nCount * SizeOf(DWord), 0);
      for nCount := 0 to nCount - 1 do begin
        FFrameOffs[nCount] := FFileStream.Position;
        Inc(FImageCount);
        FIndexList.Add(Pointer(FFileStream.Position));
        FImageFormatList.Add(Pointer(FImageInfo.siFormat));
        FFileStream.Read(FFrames, SizeOf(FFrames));
        with FFrames do
          case FImageInfo.siFormat of
            (* $82: {//未压缩 有Alpha （高速版本）} begin
                 nSize := DXInfo.nHeight * DXInfo.nWidth * 4;
                 FFileStream.Seek(nSize, soCurrent);
               end;

             $88: {//未压缩  （高速版本）} begin
                 nSize := DXInfo.nHeight * DXInfo.nWidth * 2;
                 FFileStream.Seek(nSize, soCurrent);
               end;

             $06: {//已压缩 有Alpha（高速版本）} begin
                 FFileStream.ReadBuffer(nSize, SizeOf(Integer));
                 FFileStream.Seek(nSize, soCurrent);
                 FFileStream.ReadBuffer(nSize, SizeOf(Integer));
                 FFileStream.Seek(nSize, soCurrent);
               end;

             $18, $28: {//已压缩  （高速版本）} begin
                 FFileStream.ReadBuffer(nSize, SizeOf(Integer));
                 FFileStream.Seek(nSize, soCurrent);
               end;

             $02: {//未压缩 （高速版本）} begin
                 nBlocks := sfXBlocks * sfYBlocks;
                 for nBlocks := 1 to nBlocks do begin
                   FFileStream.ReadBuffer(nSize, SizeOf(Word));
                   FFileStream.Seek((nSize and $00FF) * (nSize and $FF00) * 2, soCurrent);
                 end;
               end;
                     *)
            $11, $12 {, $22}: {//已压缩  （高画质版本）} begin
                nBlocks := sfXBlocks * sfYBlocks;
                for nBlocks := 1 to nBlocks do begin
                  FFileStream.Seek(2, soCurrent);
                  FFileStream.ReadBuffer(nSize, SizeOf(Integer));
                  FFileStream.Seek(nSize, soCurrent);
                end;
              end;

            (*   $62: {//已压缩  有Alpha（高画质版本）} begin
                   nBlocks := sfXBlocks * sfYBlocks;
                   for nBlocks := 1 to nBlocks do begin
                     FFileStream.Seek(2, soCurrent);
                     FFileStream.ReadBuffer(nSize, SizeOf(Integer));
                     FFileStream.Seek(nSize, soCurrent);
                     FFileStream.ReadBuffer(nSize, SizeOf(Integer));
                     FFileStream.Seek(nSize, soCurrent);
                   end;
                 end;  *)
          else
            raise Exception.Create(FFileName + ' 未支持的文件格式 ' +
              IntToStr(FImageInfo.siFormat) + ' ($' + IntToHex(FImageInfo.siFormat, 0) + ')');
          end;
      end;
    end;
  end;

  ImageOffs := nil;
end;

end.

