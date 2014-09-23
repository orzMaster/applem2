unit wm521g;

interface
uses
  Windows, Classes, Graphics, SysUtils, MyDirect3D9, TDX9Textures, HUtil32, WIL;

type
  TWMImageHeader = packed record
    sTitle: array[0..67] of Char;
    nIndexOffset: Integer;
    nDataBegin: Integer;
    nImageCount: Integer;
    nVarOffset: Integer;
  end;

  TWMIndexInfo = packed record
    nDataOffset: Integer;
    nDataSize: Integer;
    nWidth: Word;
    nHeight: Word;
    sUnknown: array[0..11] of Char;
  end;

  TWM521gDefImages = class(TWMBaseImages)
  private
    FHeader: TWMImageHeader;
    FIndexInfo: array of TWMIndexInfo;
    procedure LoadIndex();
  protected
{$IFDEF WORKFILE}
    function GetImageBitmapEx(index: integer; out btType: Byte): TBitmap; override;
{$ENDIF}
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Initialize(): Boolean; override;
  end;

implementation

{ TWMWoolDefImages }


{ TWM521gDefImages }

constructor TWM521gDefImages.Create;
begin
  inherited;
  FReadOnly := True;
  FIndexInfo := nil;
end;

destructor TWM521gDefImages.Destroy;
begin
  FIndexInfo := nil;
  inherited;
end;

function TWM521gDefImages.GetImageBitmapEx(index: integer; out btType: Byte): TBitmap;
var
  nPosition: Integer;
  imginfo: TDXTextureInfo;
  Buffer, WriteBuffer, ReadBuffer{, DecodeBuffer}: PChar;
  ReadSize: Integer;
  Y: Integer;
begin
  Result := nil;
  btType := FILETYPE_IMAGE;
  if (index < 0) or (index >= FImageCount) {or (FLibType <> ltLoadBmp)} then
    exit;
  if index < FIndexList.Count then begin
    nPosition := Integer(FIndexList[index]);
    ReadSize := FIndexInfo[index].nDataSize;
    if FFileStream.Seek(nPosition, 0) <> nPosition then
      exit;
    imginfo.nWidth := FIndexInfo[index].nWidth;
    imginfo.nHeight := FIndexInfo[index].nHeight;
    //FFileStream.Read(imginfo, SizeOf(imginfo));

    if (imginfo.nWidth > MAXIMAGESIZE) or (imgInfo.nHeight > MAXIMAGESIZE) then
      Exit;
    if (imginfo.nWidth < MINIMAGESIZE) or (imgInfo.nHeight < MINIMAGESIZE) then
      Exit;
    //ReadSize := imginfo.DXInfo.nWidth * imgInfo.DXInfo.nHeight;
    GetMem(Buffer, ReadSize);
    try
      if FFileStream.Read(Buffer^, ReadSize) = ReadSize then begin
        FLastImageInfo := imginfo;
        Result := TBitmap.Create;
        Result.PixelFormat := pf16bit;
        Result.Width := imginfo.nWidth;
        Result.Height := imginfo.nHeight;
        for Y := 0 to Result.Height - 1 do begin
          WriteBuffer := Result.ScanLine[Y];
          ReadBuffer := @Buffer[Y * Result.Width * 2];
          Move(ReadBuffer^, WriteBuffer^, Result.Width * 2);
        end;
      end;
    finally
      FreeMem(Buffer);
    end;
  end;
end;

function TWM521gDefImages.Initialize: Boolean;
begin
  Result := inherited Initialize;
  if Result then begin
    FFileStream.Read(FHeader, SizeOf(TWMImageHeader));
    LoadIndex;
    InitializeTexture;
  end;
end;

procedure TWM521gDefImages.LoadIndex;
var
  i: Integer;
  //WMIndexInfo: TWMIndexInfo;
begin
  FIndexList.Clear;
  FFileStream.Seek(FHeader.nIndexOffset + 392 {不知道为什么}, soFromBeginning);
  SetLength(FIndexInfo, FHeader.nImageCount);
  if FFileStream.Read(FIndexInfo[0], SizeOf(TWMIndexInfo) * FHeader.nImageCount) = SizeOf(TWMIndexInfo) * FHeader.nImageCount then begin
    for I := Low(FIndexInfo) to High(FIndexInfo) do begin
      FIndexList.Add(Pointer(FIndexInfo[I].nDataOffset));
    end;
  end;
  FImageCount := FIndexList.Count;
end;

end.
