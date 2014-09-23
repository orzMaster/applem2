unit Uib;

interface
uses
  Windows, Classes, Graphics, SysUtils, HUtil32, HGETextures, Wil;

const
  IMAGESCOUNT = 10000;

type

 { pTDXTextureSurface = ^TDXTextureSurface;
  TDXTextureSurface = packed record
    nPx: SmallInt;
    nPy: SmallInt;
    Surface: TDXImageTexture;
    dwLatestTime: LongWord;
    boNotRead: Boolean;
  end;     }

  TUIBImages = class
  private
    FDxTextureArr: array of TDXTextureSurface;
    function FGetImageSurface(index: integer): TDXImageTexture;
    //function GetCachedSurface(index: integer): TDXImageTexture;
    procedure LoadDxImage(index: Integer; pDXTexture: pTDXTextureSurface);
    function CopyImageDataToTexture(Bitmap: TBitmap; Texture: TDXImageTexture; Width, Height: Word): Boolean;
//    procedure FreeOldMemorys;
  public
    constructor Create();
    destructor Destroy; override;
    function Initialize(): Boolean;
    procedure Finalize;
    property Images[index: integer]: TDXImageTexture read FGetImageSurface;
  end;

implementation


(*var
  g_UibFiles: array[0..IMAGESCOUNT - 1] of string = (
    'Data\minimap\301.mmap', {1}
    'Data\minimap\302.mmap', {2}
    'Data\minimap\303.mmap', {3}
    'Data\minimap\304.mmap', {4}
    'Data\minimap\305.mmap', {5}
    'Data\minimap\306.mmap', {6}
    'Data\minimap\307.mmap', {7}
    'Data\minimap\308.mmap', {8}
    'Data\minimap\309.mmap', {9}
    'Data\minimap\310.mmap', {10}
    'Data\minimap\311.mmap', {11}
    'Data\minimap\312.mmap', {12}
    'Data\minimap\313.mmap', {13}
    'Data\minimap\314.mmap', {14}
    'Data\minimap\315.mmap', {15}
    'Data\minimap\316.mmap', {16}
    'Data\minimap\317.mmap', {17}
    'Data\minimap\318.mmap', {18}
    'Data\minimap\319.mmap', {19}
    'Data\minimap\320.mmap', {20}
    'Data\minimap\321.mmap', {21}
    'Data\minimap\322.mmap', {22}
    'Data\minimap\323.mmap', {23}
    'Data\minimap\324.mmap', {24}
    'Data\minimap\325.mmap' {24}
    );           *)

constructor TUIBImages.Create();
begin
  SetLength(FDxTextureArr, IMAGESCOUNT);
  SafeFillChar(FDxTextureArr[0], IMAGESCOUNT * SizeOf(TDXTextureSurface), #0);
end;

destructor TUIBImages.Destroy;
begin
  Finalize;
  FDxTextureArr := nil;
  inherited Destroy;
end;

function TUIBImages.Initialize: Boolean;
begin
  Result := True;
end;

procedure TUIBImages.Finalize;
var
  i: integer;
begin
  for I := Low(FDxTextureArr) to High(FDxTextureArr) do begin
    if FDxTextureArr[I].Surface <> nil then begin
      FDxTextureArr[I].Surface.Free;
      FDxTextureArr[I].Surface := nil;
    end;
  end;
end;
  {
procedure TUIBImages.FreeOldMemorys;
var
  i: integer;
begin
  try
    for I := 0 to IMAGESCOUNT - 1 do begin
      if m_ImgArr[I].Surface <> nil then begin
        if (GetTickCount - m_ImgArr[I].dwLatestTime) > 5 * 60 * 1000 then begin
          m_ImgArr[i].Surface.Free;
          m_ImgArr[i].Surface := nil;
        end;
      end;
    end;
  except
    DebugOutStr('[Exception] TUIBImages.FreeOldMemorys');
  end;
end;    }

function TUIBImages.FGetImageSurface(index: integer): TDXImageTexture;
begin
  Result := nil;
  if (index < 0) or (index >= IMAGESCOUNT) then exit;

  if (FDxTextureArr[index].Surface = nil) and (not FDxTextureArr[index].boNotRead) then begin
    Try
      LoadDxImage(index, @FDxTextureArr[index]);
    Except
      FDxTextureArr[index].Surface := nil;
      FDxTextureArr[index].boNotRead := True;
    End;
  end;
  Result := FDxTextureArr[index].Surface;
  //px := FDxTextureArr[index].nPx;
  //py := FDxTextureArr[index].nPy;
  FDxTextureArr[index].dwLatestTime := GetTickCount;
end;

procedure TUIBImages.LoadDxImage(index: Integer; pDXTexture: pTDXTextureSurface);
var
  Bitmap: TBitmap;
  sFileName: string;
begin
  pDXTexture.boNotRead := True;
  if index < 100 then sFileName := 'Data\minimap\' + IntToStr(301 + index) + '.mmap'
  else sFileName := 'Data\minimap\' + IntToStr(index + 1) + '.mmap';
  if FileExists(sFileName) then begin
    Bitmap := TBitmap.Create;
    Try
      Bitmap.LoadFromFile(sFileName);
      if (Bitmap.Width > 2) and (Bitmap.Height > 2) and (Bitmap.PixelFormat = pf8bit) then begin
        pDXTexture.Surface := MakeDXImageTexture(Bitmap.Width, Bitmap.Height, WILFMT_A1R5G5B5);
        if pDXTexture.Surface <> nil then begin
          if not CopyImageDataToTexture(Bitmap, pDXTexture.Surface, Bitmap.Width, Bitmap.Height) then
          begin
            pDXTexture.Surface.Free;
            pDXTexture.Surface := nil;
          end
          else begin
            pDXTexture.boNotRead := False;
            pDXTexture.nPx := 0;
            pDXTexture.nPy := 0;
          end;
        end;
      end;
    Finally
      Bitmap.Free;
    End;
  end;

end;

function TUIBImages.CopyImageDataToTexture(Bitmap: TBitmap; Texture: TDXImageTexture; Width, Height: Word): Boolean;
var
  Y: Integer;
  Access: TDXAccessInfo;
  WriteBuffer, ReadBuffer: PChar;
begin
  Result := False;
  if Texture.Lock(lfWriteOnly, Access) then begin
    try
      SafeFillChar(Access.Bits^, Access.Pitch * Texture.Size.Y, #0);
      WriteBuffer := Pointer(Integer(Access.Bits));

      for Y := 0 to Height - 1 do begin
        ReadBuffer := Bitmap.ScanLine[Y];
        LineX8_A1R5G5B5(ReadBuffer, WriteBuffer, Width);
        Inc(WriteBuffer, Access.Pitch);
      end;
      Result := True;
    finally
      Texture.Unlock;
    end;
  end;
end;
 {
function TUIBImages.GetCachedSurface(index: integer): TDXImageTexture;
begin
  Result := nil;
  try
    if FileExists(g_UibFiles[index]) then begin
      lsDib.Clear;
      lsDib.LoadFromFile(g_UibFiles[index]);
      m_ImgArr[index].surface := TDirectDrawSurface.Create(FDDraw);
      m_ImgArr[index].surface.SystemMemory := TRUE;
      m_ImgArr[index].surface.SetSize(lsDib.Width, lsDib.Height);
      m_ImgArr[index].surface.Canvas.Draw(0, 0, lsDib);
      m_ImgArr[index].surface.Canvas.Release;

      m_ImgArr[index].surface.TransparentColor := 0;
      m_ImgArr[index].dwLatestTime := GetTickCount;
      m_ImgArr[index].nIdx := 0;
      Result := m_ImgArr[index].surface;
    end;
  except
    DebugOutStr('[Exception] TUIBImages.GetCachedSurface');
  end;
end;     }

end.

