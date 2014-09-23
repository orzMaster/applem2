unit ZShare;

interface
uses
  Windows, Classes, SysUtils, WIL, commdlg, Graphics, TDX9Textures, ShlObj, pngImage, MyCommon;

type

  PRGBQuads = ^TRGBQuads;
  TRGBQuads = array[0..255] of TRGBQuad;

const
  IMAGEOFFSETDIR = 'Placements\';

var
  g_WMImages: TWMBaseImages;
  g_BackColor: TColor = $808080;
  g_AlphaColor: TColor = clWhite;
  g_SelectImageIndex: Integer = -1;
  g_TextureInfo: TDXTextureInfo;
  g_WILColorFormat: SmallInt;
  g_Texture: array[0..1] of TDXImageTexture;
  g_DefMainPalette: TRgbQuads;
  g_WILType: TWILType;
  g_DefDatImage: TBitmap;
  g_DefWavImage: TBitmap;
  g_DefMp3Image: TBitmap;
  g_CustomIndex: Integer;
  g_FileVersionInfo: TFileVersionInfo;
  MAINFORMCAPTION: string = 'RPGViewer ';

function GetSysColor(HWND: Integer; DefColor: TColor = $0): TColor;
function BrowseForFolder(hd: HWND; sTitle: string): string;
function DisplaceRB(Color: Cardinal): Cardinal;
function CountDiffPixels(P: PByte; BPP: Byte; Count: Integer): Integer;
function CountSamePixels(P: PByte; BPP: Byte; Count: Integer): Integer;
function RemoveData(FileName: string; Offset, Size: Int64): Boolean;
function AppendData(FileName: string; Offset, FSize: Int64): Boolean;
function LoadPNGtoBMP(Stream: TStream; Dest: TBitmap): Boolean; overload;

implementation

var
  g_rgbCustom: array[0..15] of TColor;

function LoadPNGtoBMP(Stream: TStream; Dest: TBitmap): Boolean; overload;
var
  Image: TPngObject;
  ScanIndex, i: Integer;
  PxScan: PLongword;
  PxAlpha: PByte;
begin
  Result := True;

  Image := TPngObject.Create();
  try
    Image.LoadFromStream(Stream);
  except
    Result := False;
  end;

  if (Result) then begin
    Image.AssignTo(Dest);

    if (Image.Header.ColorType = COLOR_RGBALPHA) or (Image.Header.ColorType = COLOR_GRAYSCALEALPHA) then begin
      Dest.PixelFormat := pf32bit;

      for ScanIndex := 0 to Dest.Height - 1 do begin
        PxScan := Dest.Scanline[ScanIndex];
        PxAlpha := @Image.AlphaScanline[ScanIndex][0];
        for i := 0 to Dest.Width - 1 do begin
          PxScan^ := (PxScan^ and $FFFFFF) or (Longword(Byte(PxAlpha^)) shl 24);
          Inc(PxScan);
          Inc(PxAlpha);
        end;
      end;
    end;
  end;

  Image.Free();
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
      if NextPixel = Pixel then
        Break;
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
    if NextPixel <> Pixel then
      Break;
    Inc(Result);
    Dec(Count);
  end;
end;

function DisplaceRB(Color: Cardinal): Cardinal;
asm
 mov eax, Color
 mov ecx, eax
 mov edx, eax
 and eax, 0FF00FF00h
 and edx, 0000000FFh
 shl edx, 16
 or eax, edx
 mov edx, ecx
 shr edx, 16
 and edx, 0000000FFh
 or eax, edx
 mov Result, eax
end;

function GetSysColor(HWND: Integer; DefColor: TColor): TColor;
var
  CC: TChooseColor;
begin
  Result := DefColor;
  CC.lStructSize := SizeOf(TChooseColor);
  CC.hWndOwner := HWND;
  cc.Flags := CC_ANYCOLOR;
  cc.rgbResult := DefColor;
  cc.lpCustColors := @g_rgbCustom;
  if ChooseColor(CC) then
    Result := cc.rgbResult;
end;

function BrowseForFolder(hd: HWND; sTitle: string): string;
var
  BrowseInfo: TBrowseInfo;
  sBuf: array[0..511] of Char;
begin
  FillChar(BrowseInfo, SizeOf(TBrowseInfo), #0);
  BrowseInfo.hwndOwner := hd;
  BrowseInfo.lpszTitle := PChar(sTitle);
  BrowseInfo.ulFlags := 64;
  SHGetPathFromIDList(SHBrowseForFolder(BrowseInfo), @sBuf);
  Result := Trim(sBuf);
end;

function RemoveData(FileName: string; Offset, Size: Int64): Boolean;
{var
  Buffer: PChar;
  FileSize, CopySize: Int64;
begin
  Result := True;
  FileSize := FileStream.Size;
  CopySize := FileSize - Offset - Size;
  FileStream.Seek(Offset + Size, soFromBeginning);
  GetMem(Buffer, CopySize);
  Try
    FileStream.Read(Buffer^, CopySize);
    FileStream.Seek(Offset, soFromBeginning);
    FileStream.Write(Buffer^, CopySize);
    SetEndOfFile(FileStream.Handle);
  Finally
    FreeMem(Buffer, CopySize);
  End;  }


var
  FData: PByte;
  FHandle, FMapHandle: THandle;
  FFileSize: Integer;
  FSize, FOffset: Int64;
begin
  Result := True;
  FHandle := FileOpen(FileName, fmOpenReadWrite or fmShareDenyNone);
  FFileSize := GetFileSize(FHandle, nil);
  FMapHandle := CreateFileMapping(FHandle, nil, PAGE_READWRITE, 0, FFileSize, PChar('RPG_PAK_' + IntToStr(Random(9999) + 1000)));
  FData := MapViewOfFile(FMapHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
  if Size > (FFileSize - Offset) then
    FSize := FFileSize - Offset
  else
    FSize := Size;
  if Offset > FFileSize then
    FOffset := FFileSize
  else
    FOffset := Offset;
  CopyMemory(Pointer(LongInt(FData) + FOffset), Pointer(LongInt(FData) + FOffset + FSize), FFileSize - FOffset - FSize);
  if FData <> nil then
    UnMapViewOfFile(FData);
  if FMapHandle <> 0 then
    CloseHandle(FMapHandle);
  Fileseek(Fhandle, -FSize, 2);
  SetEndOfFile(FHandle);
  if FHandle <> 0 then
    CloseHandle(FHandle);
end;

function AppendData(FileName: string; Offset, FSize: Int64): Boolean;
{var
  Buffer: PChar;
  FileSize, CopySize: Int64;
begin
  Result := True;
  FileSize := FileStream.Size;
  CopySize := FileSize - Offset;
  FileStream.Seek(Offset, soFromBeginning);
  GetMem(Buffer, CopySize);
  Try
    FileStream.Read(Buffer^, CopySize);
    FileStream.Seek(Offset + FSize, soFromBeginning);
    FileStream.Write(Buffer^, CopySize);
  Finally
    FreeMem(Buffer, CopySize);                         
  End;   }
var
  FData: PByte;
  FHandle, FMapHandle: THandle;
  FFileSize: Integer;
  FOffset: Int64;
begin
  Result := True;
  FHandle := FileOpen(FileName, fmOpenReadWrite or fmShareDenyNone);
  FFileSize := GetFileSize(FHandle, nil);
  if Offset > FFileSize then
    FOffset := FFileSize
  else                              
    FOffset := Offset;
  FMapHandle := CreateFileMapping(FHandle, nil, PAGE_READWRITE, 0, FFileSize + FSize, PChar('RPG_PAK_' + IntToStr(Random(9999) + 1000)));
  FData := MapViewOfFile(FMapHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
  CopyMemory(Pointer(LongInt(FData) + FOffset + FSize), Pointer(LongInt(FData) + FOffset), FFileSize - FOffset);
  if FData <> nil then
    UnMapViewOfFile(FData);
  if FMapHandle <> 0 then
    CloseHandle(FMapHandle);
  if FHandle <> 0 then
    CloseHandle(FHandle);
end;

initialization
  begin
    FillChar(g_TextureInfo, SizeOf(g_TextureInfo), #0);
    g_rgbCustom[0] := clWhite;
    g_rgbCustom[1] := clWhite;
    g_rgbCustom[2] := clWhite;
    g_rgbCustom[3] := clWhite;
    g_rgbCustom[4] := clWhite;
    g_rgbCustom[5] := clWhite;
    g_rgbCustom[6] := clWhite;
    g_rgbCustom[7] := clWhite;
    g_rgbCustom[8] := clWhite;
    g_rgbCustom[9] := clWhite;
    g_rgbCustom[10] := clWhite;
    g_rgbCustom[11] := clWhite;
    g_rgbCustom[12] := clWhite;
    g_rgbCustom[13] := clWhite;
    g_rgbCustom[14] := clWhite;
    g_rgbCustom[15] := clWhite;
  end;

finalization

end.

