unit TDX9Fonts;

interface
uses
  Windows, Classes, Graphics, MyDirect3D9, MyDXBase, TDX9Textures;

type
  TFontData = array of array of Word;
  pTFontData = ^TFontData;
  
  TDX9Font = class
  private
    Fkerning: Integer;
    FInitialize: Boolean;
    function GetAsciiRect(nIndex: Word): TRect;
    function GetFontData: pTFontData;

  protected
    FTexture: TDXTexture;
    FAsciiRect: array[Word] of TRect;
    FFontData: TFontData;
    FboLost: Boolean;
  public
    constructor Create();
    destructor Destroy(); override;
    function CreateTexture(): Integer;
    function Initialize(FontName: String; FontSize: Integer): Boolean;
    function Lost: Boolean;
    function Recovered: Boolean;
    function Finalize(): Boolean;
    property DXTexture: TDXTexture read FTexture;
    property boInitialize: Boolean read FInitialize;
    property AsciiRect[nIndex: Word]: TRect read GetAsciiRect;
    property kerning: Integer read Fkerning write Fkerning;
    property FontData: pTFontData read GetFontData;
  end;

implementation

const
  //IMAGEWIDTH = 148 * 14;
  //IMAGEHEIGHT = 148 * 14;
  IMAGEWIDTH = 88 * 14;
  IMAGEHEIGHT = 88 * 14;

{ TDX9Font }

constructor TDX9Font.Create;
begin
  inherited;
  FillChar(FAsciiRect, SizeOf(FAsciiRect), #0);
  FTexture := nil;
  Fkerning := -2;
  FInitialize := False;
  FFontData := nil;
  FboLost := True;
end;

function TDX9Font.CreateTexture: Integer;
begin
  FTexture := TDXTexture.Create;
  FTexture.Size := Point(IMAGEWIDTH, IMAGEHEIGHT);
  FTexture.Behavior := tbUnmanaged;
  FTexture.PatternSize := Point(IMAGEWIDTH, IMAGEHEIGHT);
  FTexture.Format := D3DFMT_A4R4G4B4;
  FTexture.Active := True;
  if not FTexture.Active then begin
    {Result := 2;
    FTexture.Free;
    FTexture := nil;

    FTexture := TDXTexture.Create;
    FTexture.Size := Point(2048, 2048);
    FTexture.Behavior := tbUnmanaged;
    FTexture.PatternSize := Point(IMAGEWIDTH, IMAGEHEIGHT);
    FTexture.Format := D3DFMT_A4R4G4B4;
    FTexture.Active := True;
    if not FTexture.Active then begin
      FTexture.Free;
      FTexture := nil;
      Result := -1;
    end;    }
    Result := -1;
  end else
    Result := 1;
end;

destructor TDX9Font.Destroy;
begin
  Finalize;
  inherited;
end;

function TDX9Font.GetAsciiRect(nIndex: Word): TRect;
begin
  Result := FAsciiRect[nIndex];
end;

function TDX9Font.GetFontData: pTFontData;
begin
  Result := @FFontData;
end;

function TDX9Font.Finalize: Boolean;
begin
  Result := False;
  FFontData := nil;
  if not FInitialize then exit;
  if FTexture <> nil then
    FTexture.Free;
  FTexture := nil;
  FInitialize := False;
  Result := FInitialize;
end;

function TDX9Font.Initialize(FontName: String; FontSize: Integer): Boolean;
  procedure TextOutBold(Canvas: TCanvas; x, y, fcolor, bcolor: integer; str: string);
  var
    nLen: Integer;
  begin
    nLen := Length(str);
    Canvas.Font.Color := bcolor;
    TextOut(Canvas.Handle, x, y - 1, PChar(str), nlen);
    TextOut(Canvas.Handle, x, y + 1, PChar(str), nlen);
    TextOut(Canvas.Handle, x - 1, y, PChar(str), nlen);
    TextOut(Canvas.Handle, x + 1, y, PChar(str), nlen);
    TextOut(Canvas.Handle, x - 1, y - 1, PChar(str), nlen);
    TextOut(Canvas.Handle, x + 1, y + 1, PChar(str), nlen);
    TextOut(Canvas.Handle, x - 1, y + 1, PChar(str), nlen);
    TextOut(Canvas.Handle, x + 1, y - 1, PChar(str), nlen);
    Canvas.Font.Color := fcolor;
    TextOut(Canvas.Handle, x, y, PChar(str), nlen);
  end;
var
  Bitmap: Graphics.TBitmap;
  I: Integer;
  Char1, Char2: Byte;
  Text: String;
  wText: WideString;
  nWidth, nX, nY, nI: Integer;
//  Access: TDXAccessInfo;
  BmpBuff: PRGBQuad;
  TextureBuff: PWord;
  btAlpha: Byte;
  index: Word;
  NoIndex: Word;
begin
  Result := False;
  if FInitialize then exit;
  SetLength(FFontData, IMAGEHEIGHT, IMAGEWIDTH);
  FillChar(FFontData[0][0], Length(FFontData), #0);
  FillChar(FAsciiRect, SizeOf(FAsciiRect), #0);
  if FTexture = nil then begin
    exit;
  end;
  Bitmap := TBitmap.Create;
  Bitmap.PixelFormat := pf32bit;
  Bitmap.Width := IMAGEWIDTH;
  Bitmap.Height := IMAGEHEIGHT;
  Bitmap.Canvas.Brush.Color := clRed;
  Bitmap.Canvas.FillRect(Rect(0, 0, IMAGEWIDTH, IMAGEHEIGHT));
  Bitmap.Canvas.Font.Name := FontName;
  Bitmap.Canvas.Font.Size := FontSize;
  SetBkMode(Bitmap.Canvas.Handle, TRANSPARENT);
  nI := 0;
  for I := Low(Word) to High(Word) do begin
    Char1 := LoByte(Word(I));
    Char2 := HiByte(Word(I));
    if I = 0 then begin
      Text := '¡õ';
      wText := Text;
      Move(wText[1], NoIndex, 2);
    end else begin
      if not FiltrateChar(Char1, Char2) then begin
        if (Char1 > 128) and (Char2 in [64..126, 128..254]) then begin
          Text := Char(Char1) + Char(Char2);
          wText := Text;
          Move(wText[1], index, 2);
          FAsciiRect[index] := FAsciiRect[NoIndex];
        end;
        Continue;
      end;
      if Char1 in [32..126] then Text := Char(Char1)
      else Text := Char(Char1) + Char(Char2);
    end;
    nWidth := Bitmap.Canvas.TextWidth(Text);
    nX := nI mod 88 * 14;
    nY := nI div 88 * 14;
    TextOutBold(Bitmap.Canvas, nX + 1, nY + 1, clWhite, clBlack, Text);
    wText := Text;
    Move(wText[1], index, 2);
    FAsciiRect[index].Left := nX;
    FAsciiRect[index].Top := nY;
    FAsciiRect[index].Right := nX + nWidth + 2;
    FAsciiRect[index].Bottom := nY + 14;
    Inc(nI);
  end;
  for nY := 0 to Bitmap.Height - 1 do begin
    BmpBuff := Bitmap.ScanLine[nY];
    TextureBuff := PWord(@FFontData[nY][0]);
    for nX := 0 to Bitmap.Width - 1 do begin
      if BmpBuff.rgbRed = 0 then btAlpha := 255
      else if BmpBuff.rgbGreen = 0 then btAlpha := 0
      else btAlpha := 255;
      if btAlpha <> 0 then
        TextureBuff^ := ((WORD(btAlpha) and $F0) shl 8) +
                        ((WORD(BmpBuff.rgbRed) and $F0) shl 4) +
                        (WORD(BmpBuff.rgbGreen) and $F0) +
                        (WORD(BmpBuff.rgbBlue) shr 4)
      else
        TextureBuff^ := 0;
      Inc(BmpBuff);
      Inc(TextureBuff);
    end;
  end;
  Bitmap.Free;
  FInitialize := True;
  Result := Recovered;
end;

function TDX9Font.Lost: Boolean;
begin
  Result := False;
  FTexture.Lost;
  FboLost := True;
end;

function TDX9Font.Recovered: Boolean;
var
  PrevTarget, Offscreen: IDirect3DSurface9;
  LockedRect: TD3DLockedRect;
  nY: Integer;
begin
  Result := False;
  if (not FboLost) or (not FInitialize) then exit;
  FTexture.Recovered;
  if not Succeeded(Direct3DDevice.CreateOffscreenPlainSurface(FTexture.Size.X, FTexture.Size.Y, FTexture.Format,
    D3DPOOL_SYSTEMMEM, PrevTarget, nil)) then
    Exit;
  Try
    if not Succeeded(FTexture.Texture9.GetSurfaceLevel(0, Offscreen)) then
      Exit;
    if Succeeded(PrevTarget.LockRect(LockedRect, nil, D3DLOCK_READONLY)) then begin
      Try
        for nY := 0 to FTexture.Height - 1 do
          Move(FFontData[nY][0], PWord(Integer(LockedRect.pBits) + LockedRect.Pitch * nY)^, IMAGEWIDTH * SizeOf(Word));
      Finally
        PrevTarget.UnlockRect;
      End;
    end;
    if not Succeeded(Direct3DDevice.UpdateSurface(PrevTarget, nil, Offscreen, nil)) then
      Exit;
    Result := True;
  Finally
    PrevTarget := nil;
    Offscreen := nil;
  End;
end;

end.

