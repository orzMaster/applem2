unit TDX9Textures;

interface
uses
  Windows, Types, MyDirect3D9, MyDXBase, Graphics;

type
  TDXTextureState = (tsNotReady, tsReady, tsLost, tsFailure);

  //---------------------------------------------------------------------------
  TDXTextureBehavior = (tbManaged, tbUnmanaged, tbDynamic, tbRTarget, tbSystem);

  //---------------------------------------------------------------------------
  TDXLockFlags = (lfNormal, lfReadOnly, lfWriteOnly);

  TDXAccessInfo = record
    Bits: Pointer;
    Pitch: Integer;
    Format: TColorFormat;
  end;

  TCompatibleCanvas = class
  public
    function TextWidth(Str: WideString): Integer;
    function TextHeight(Str: WideString): Integer;
    procedure TextOut(x, Y: Integer; Str: WideString; FColor: Integer);
  end;

  TDXTexture = class
  private
    FTexture9: IDirect3DTexture9;
    FSize: TPoint;
    FMipmapping: Boolean;
    FActive: Boolean;
    FPatternSize: TPoint;
    FDrawCanvas: TObject;
    procedure SetMipMapping(const Value: Boolean);
    procedure SetSize(const Value: TPoint);
    procedure SetBehavior(const Value: TDXTextureBehavior);
    procedure SetFormat(const Value: TD3DFormat);
    procedure SetActive(const Value: Boolean);
    function GetActive: Boolean;
    function GetPixel(X, Y: Integer): Cardinal;
    procedure SetPixel(X, Y: Integer; const Value: Cardinal);
    procedure SetPatternSize(const Value: TPoint);
  protected
    FState: TDXTextureState;
    FFormat: TD3DFormat;
    FBehavior: TDXTextureBehavior;
    function Prepare(): Boolean; virtual;
    function MakeReady(): Boolean; dynamic;
    procedure MakeNotReady(); dynamic;
    function RetreiveUsage(): Cardinal;
    procedure ChangeState(NewState: TDXTextureState);

  public
    constructor Create(DrawCanvas: TObject = nil); dynamic;
    destructor Destroy(); override;

    procedure Lost();
    procedure Recovered();

    procedure Clear(); dynamic;
    function Lock(Flags: TDXLockFlags; out Access: TDXAccessInfo): Boolean;
    function LockRect(const LockArea: TRect; Flags: TDXLockFlags; out Access: TDXAccessInfo): Boolean;
    function Unlock(): Boolean;
    function Activate(Stage: Cardinal): Boolean;
    procedure TextOutEx(X, Y: Integer; Text: WideString); overload;
    procedure TextOutEx(X, Y: Integer; Text: WideString; FColor: Cardinal); overload;
    procedure TextOutEx(X, Y: Integer; Text: WideString; FColor: Cardinal; BColor: Cardinal); overload;
    procedure CopyTexture(SourceTexture: TDXTexture); overload;
    procedure CopyTexture(X, Y: Integer; SourceTexture: TDXTexture); overload;
    procedure LineTo(nX, nY, nWidth: Integer; FColor: Cardinal);
    procedure CopyBitmap(const Bitmap: TBitmap);
    function ClientRect: TRect; dynamic;
    procedure Line(nX, nY, nLength: Integer; FColor: Cardinal); overload;
    function SelectTexture(TexCoord: TTexCoord; out Points: TPoint4): Boolean; dynamic;

    property Active: Boolean read GetActive write SetActive;
    function Width: Integer; dynamic;
    function Height: Integer; dynamic;


    property Texture9: IDirect3DTexture9 read FTexture9;
    property Size: TPoint read FSize write SetSize;
    property State: TDXTextureState read FState;
    property Canvas: TObject read FDrawCanvas write FDrawCanvas;
    property Format: TD3DFormat read FFormat write SetFormat;
    property Behavior: TDXTextureBehavior read FBehavior write SetBehavior;
    property MipMapping: Boolean read FMipmapping write SetMipMapping;
    property Pixels[X, Y: Integer]: Cardinal read GetPixel write SetPixel;
    property PatternSize: TPoint read FPatternSize write SetPatternSize;
    //property Canvas: TCompatibleCanvas read FCanvas;
    procedure Draw(X, Y: Integer; Source: TDXTexture; Transparent: Boolean); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent: Boolean); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent: Boolean; DrawFx: Cardinal); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Color, DrawFx: Cardinal); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal); overload;
    procedure StretchDraw(SrcRect, DesRect: TRect; Source: TDXTexture; Transparent: Boolean); overload;
    procedure StretchDraw(SrcRect, DesRect: TRect; Source: TDXTexture; DrawFx: Cardinal); overload;
  end;

  TDXImageTexture = class(TDXTexture)
  private
    FQuality: TAsphyreQuality;
    FAlphaLevel: TAlphaLevel;


    procedure SetAlphaLevel(const Value: TAlphaLevel);

    procedure SetQuality(const Value: TAsphyreQuality);
    function UpdateInfo(): Boolean;
  protected
    function Prepare(): Boolean; override;
  public
    constructor Create(DrawCanvas: TObject = nil); override;
    destructor Destroy(); override;

    function Width: Integer; override;
    function Height: Integer; override;

    procedure Clear(); override;
    function ClientRect(): TRect; override;
    property Quality: TAsphyreQuality read FQuality write SetQuality;
    property AlphaLevel: TAlphaLevel read FAlphaLevel write SetAlphaLevel;
    function SelectTexture(TexCoord: TTexCoord; out Points: TPoint4): Boolean; override;
  end;

  TDXRenderTargetTexture = class(TDXTexture)
  private
    FDepthBuffer: Boolean;
    TextureSurface: IDirect3DSurface9;
    DepthSurface: IDirect3DSurface9;
    PrevTarget: IDirect3DSurface9;
    PrevDepthBuf: IDirect3DSurface9;
    procedure SetDepthBuffer(const Value: Boolean);
  protected
    function Prepare(): Boolean; override;
    function MakeReady(): Boolean; override;
    procedure MakeNotReady(); override;
  public

    constructor Create(DrawCanvas: TObject = nil); override;
    destructor Destroy(); override;

    function BeginRender(): Boolean;
    procedure EndRender();

    property DepthBuffer: Boolean read FDepthBuffer write SetDepthBuffer;
  end;

  TDirectDrawSurface = TDXTexture;

implementation
uses
  TDX9Canvas, TDX9Fonts;

{ TDXTexture }

function TDXTexture.Activate(Stage: Cardinal): Boolean;
begin
  Result := (FTexture9 <> nil) and (Direct3DDevice <> nil) and
    (Succeeded(Direct3DDevice.SetTexture(Stage, FTexture9)));
end;

procedure TDXTexture.ChangeState(NewState: TDXTextureState);
begin
  if (FState = tsNotReady) and (NewState = tsReady) then
  begin
    if (Prepare()) and (MakeReady()) then
      FState := tsReady;
  end
  else if (NewState = tsNotReady) then
  begin
    if (FState = tsReady) then
      MakeNotReady();
    FState := tsNotReady;
  end
  else if (FState = tsReady) and (NewState = tsLost) and (FBehavior <> tbManaged) then
  begin
    MakeNotReady();
    FState := tsLost;
  end
  else if (FState = tsLost) and (NewState = tsReady) then
  begin
    if (MakeReady()) then
      FState := tsReady
    else
      FState := tsFailure;
  end
  else if (FState = tsFailure) and (NewState = tsReady) then
  begin
    if (MakeReady()) then
      FState := tsReady;
  end;
end;

function TDXTexture.ClientRect: TRect;
begin
  Result.Left := 0;
  Result.Top := 0;
  Result.Right := FSize.X;
  Result.Bottom := FSize.Y;
end;

procedure TDXTexture.CopyBitmap(const Bitmap: TBitmap);
{var
  SourceAccess: TDXAccessInfo;
  Access: TDXAccessInfo;
  srcleft, srcwidth, srctop, srcbottom, I: Integer;
  ReadBuffer, WriteBuffer: Pointer;   }
begin
  {if Lock(lfWriteOnly, Access) then begin
    Try
      for i := 0 to Height - 1 do begin
        ReadBuffer := Bitmap.ScanLine[i];
        WriteBuffer := Pointer(Integer(Access.Bits) + Access.Pitch * i);
        Move(ReadBuffer^, WriteBuffer^, Width * 2);
      end;
    Finally
      UnLock;
    End;
  end; }
end;

procedure TDXTexture.CopyTexture(X, Y: Integer; SourceTexture: TDXTexture);
var
  SourceAccess: TDXAccessInfo;
  Access: TDXAccessInfo;
  srcleft, srcwidth, srctop, srcbottom, I: Integer;
  ReadBuffer, WriteBuffer: Pointer;
begin
  if SourceTexture = nil then exit;
  if x >= FSize.X then exit;
  if y >= FSize.Y then exit;
  if x < 0 then begin
    srcleft := -x;
    srcwidth := SourceTexture.Width + x;
    x := 0;
  end
  else begin
    srcleft := 0;
    srcwidth := SourceTexture.Width;
  end;
  if y < 0 then begin
    srctop := -y;
    srcbottom := srctop + SourceTexture.Height + y;
    y := 0;
  end
  else begin
    srctop := 0;
    srcbottom := srctop + SourceTexture.Height;
  end;

  if (srcleft + srcwidth) > SourceTexture.Width then
    srcwidth := SourceTexture.Width - srcleft;
  if srcbottom > SourceTexture.Height then
    srcbottom := SourceTexture.Height;
  if (x + srcwidth) > FSize.X then
    srcwidth := FSize.X - x;

  if (y + srcbottom - srctop) > FSize.Y then
    srcbottom := FSize.Y - y + srctop;

  if (srcwidth <= 0) or (srcbottom <= 0) or (srcleft >= SourceTexture.Width) or (srctop >= SourceTexture.Height) then
    exit;

  if SourceTexture.Lock(lfReadOnly, SourceAccess) then begin
    Try
      if Lock(lfWriteOnly, Access) then begin
        Try
          for i := srctop to srcbottom - 1 do begin
            ReadBuffer := Pointer(Integer(SourceAccess.Bits) + SourceAccess.Pitch * I + (srcleft * 2));
            WriteBuffer := Pointer(Integer(Access.Bits) + Access.Pitch * (y + i - srctop) + (X * 2));
            Move(ReadBuffer^, WriteBuffer^, srcwidth * 2);
          end;
        Finally
          UnLock;
        End;
      end;
    Finally
      SourceTexture.Unlock;
    End;
  end;
end;

constructor TDXTexture.Create(DrawCanvas: TObject = nil);
begin
  inherited Create;

  FSize := Point(2, 2);
  FPatternSize := FSize;
  FState := tsNotReady;
  FBehavior := tbManaged;
  FMipMapping := False;
  FFormat := D3DFMT_UNKNOWN;
  FTexture9 := nil;
  FActive := False;
  FDrawCanvas := DrawCanvas;
  //FCanvas := TCompatibleCanvas.Create;
end;

destructor TDXTexture.Destroy;
begin
  if (FState <> tsNotReady) then
    ChangeState(tsNotReady);
  if FTexture9 <> nil then
    FTexture9 := nil;
  //FCanvas.Free;
  inherited;
end;

procedure TDXTexture.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal);
begin
  if (FDrawCanvas <> nil) and (Source <> nil) then
    TDXDrawCanvas(FDrawCanvas).Draw(X, Y, SrcRect, Source, DrawFx, clWhite4);
end;

procedure TDXTexture.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Color, DrawFx: Cardinal);
begin
  if (FDrawCanvas <> nil) and (Source <> nil) then
    TDXDrawCanvas(FDrawCanvas).Draw(X, Y, SrcRect, Source, DrawFx, cColor4(Color));
end;

procedure TDXTexture.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent: Boolean; DrawFx: Cardinal);
begin
  if (FDrawCanvas <> nil) and (Source <> nil) then
    TDXDrawCanvas(FDrawCanvas).Draw(X, Y, SrcRect, Source, DrawFx, cColor4($7DFFFFFF));
end;

procedure TDXTexture.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent: Boolean);
begin
  if (FDrawCanvas <> nil) and (Source <> nil) then
    TDXDrawCanvas(FDrawCanvas).Draw(X, Y, SrcRect, Source, Transparent);
end;

procedure TDXTexture.Draw(X, Y: Integer; Source: TDXTexture; Transparent: Boolean);
begin
  if (FDrawCanvas <> nil) and (Source <> nil) then
    TDXDrawCanvas(FDrawCanvas).Draw(X, Y, Source.ClientRect, Source, Transparent);
end;

procedure TDXTexture.Clear;
var
  Access: TDXAccessInfo;
begin
  if not Active then exit;
  
  if Lock(lfWriteOnly, Access) then begin
    Try
      FillChar(Access.Bits^, Access.Pitch * Size.Y, #0);
    Finally
      Unlock();
    End;
  end;
end;

function TDXTexture.GetActive: Boolean;
begin
  Result := FState = tsReady;
end;

procedure TDXTexture.Line(nX, nY, nLength: Integer; FColor: Cardinal);
var
  Access: TDXAccessInfo;
  wColor: Word;
  RGBQuad: TRGBQuad;
  WriteBuffer: Pointer;
begin
  if nY < 0 then exit;
  if nY > FSize.Y then exit;
  if nX > FSize.X then exit;
  if nX < 0 then begin
    nLength := nLength - nX;
    nX := 0;
  end;
  if (nX + nLength) > FSize.X then
    nLength := FSize.X - nX;
  if nLength <= 0 then exit;
  FColor := DisplaceRB(FColor or $FF000000);
  RGBQuad := PRGBQuad(@FColor)^;
  wColor := ($F0 shl 8) + ((WORD(RGBQuad.rgbRed) and $F0) shl 4) + (WORD(RGBQuad.rgbGreen) and $F0) + (WORD(RGBQuad.rgbBlue) shr 4);
  if Lock(lfWriteOnly, Access) then begin
    Try
      WriteBuffer := Pointer(Integer(Access.Bits) + Access.Pitch * nY + nX * 2);
      asm
        push edi
        push edx
        push eax

        mov edi, WriteBuffer
        mov ecx, nLength
        mov dx,  wColor
      @pixloop:
        mov ax, [edi].word
        mov [edi], dx
        add edi, 2
        
        dec ecx
        jnz @pixloop
        pop eax
        pop edx
        pop edi
      end;
    Finally
      UnLock;
    End;
  end;
{ var
  Access: TDXAccessInfo;
  sWord: Word;
  AsciiRect: TRect;
  I, nY, wY, kerning, nFontWidth: Integer;
  ReadBuffer, WriteBuffer: Pointer;
  wColor: Word;
  RGBQuad: TRGBQuad;
  FontData: pTFontData;
begin
  if Text = '' then exit;
  Dec(X);
  Dec(Y);
  FColor := DisplaceRB(FColor or $FF000000);
  RGBQuad := PRGBQuad(@FColor)^;
  wColor := ($F0 shl 8) +
            ((WORD(RGBQuad.rgbRed) and $F0) shl 4) +
            (WORD(RGBQuad.rgbGreen) and $F0) +
            (WORD(RGBQuad.rgbBlue) shr 4);
  if (FDrawCanvas <> nil) and (TDXDrawCanvas(FDrawCanvas).Font <> nil) then begin
    FontData := TDXDrawCanvas(FDrawCanvas).Font.FontData;
    kerning := TDXDrawCanvas(FDrawCanvas).Font.kerning;
    if Lock(lfWriteOnly, Access) then begin
      Try
        for I := 1 to Length(Text) do begin
          if X >= FSize.X then break;
          Move(Text[i], sWord, 2);
          AsciiRect := TDXDrawCanvas(FDrawCanvas).Font.AsciiRect[sWord];
          if (AsciiRect.Right > 4) then begin
            wY := Y;
            nFontWidth := AsciiRect.Right - AsciiRect.Left;
            if X < 0 then begin
              if (AsciiRect.Left - X) >= AsciiRect.Right then begin
                Inc(X, (AsciiRect.Right - AsciiRect.Left) + kerning);
                Continue;
              end;
              AsciiRect.Left := AsciiRect.Left - X;
              nFontWidth := AsciiRect.Right - AsciiRect.Left;
              X := 0;
            end else
            if (X + nFontWidth) >= FSize.X then begin
              nFontWidth := FSize.X - X;
            end;
            if nFontWidth > 0 then begin
              for nY := AsciiRect.Top to AsciiRect.Bottom - 1 do begin
                if wY < 0 then begin
                  Inc(wY);
                  Continue;
                end else
                if wY >= FSize.Y then break;
                ReadBuffer := @(FontData^[ny][AsciiRect.Left]);
                WriteBuffer := Pointer(Integer(Access.Bits) + Access.Pitch * wY + X * 2);
                asm
                  push esi
                  push edi
                  push ebx
                  push edx

                  mov esi, ReadBuffer
                  mov edi, WriteBuffer
                  mov ecx, nFontWidth
                  mov dx,  wColor
                @pixloop:
                  mov ax, [esi].word
                  add esi, 2

                  cmp ax, 0
                  JE  @@Next

                  and ax, dx
                  mov [edi], ax
                @@Next:
                  add edi, 2

                  dec ecx
                  jnz @pixloop

                  pop edx
                  pop ebx
                  pop edi
                  pop esi
                end;
                Inc(wY);
              end;
            end;
            Inc(X, (AsciiRect.Right - AsciiRect.Left) + kerning);
          end;
        end;
      Finally
        UnLock;
      End;
    end;
  end;}
end;

procedure TDXTexture.LineTo(nX, nY, nWidth: Integer; FColor: Cardinal);
var
  Access: TDXAccessInfo;
  I: Integer;
  WriteBuffer: PWord;
  wColor: Word;
  RGBQuad: TRGBQuad;
begin
  if nX < 0 then begin
    nWidth := nWidth + nX;
    nX := 0;
  end;
  if nY < 0 then Exit;
  if nX >= FSize.X then Exit;
  if nY >= FSize.Y then exit;
  if (nX + nWidth) > FSize.X then
    nWidth := FSize.X - nX;
  if nWidth <= 0 then Exit;
  RGBQuad := PRGBQuad(@FColor)^;
  wColor := ($F0 shl 8) +
            ((WORD(RGBQuad.rgbRed) and $F0) shl 4) +
            (WORD(RGBQuad.rgbGreen) and $F0) +
            (WORD(RGBQuad.rgbBlue) shr 4);
  if Lock(lfWriteOnly, Access) then begin
    Try
      WriteBuffer := PWord(Integer(Access.Bits) + (Access.Pitch * nY) + (nX * 2));
      for i := nX to nWidth + nX do begin
        WriteBuffer^ := wColor;
        Inc(WriteBuffer);
      end;
    Finally
      UnLock;
    End;
  end;
end;

function TDXTexture.Lock(Flags: TDXLockFlags; out Access: TDXAccessInfo): Boolean;
var
  LockedRect: TD3DLocked_Rect;
  Usage: Cardinal;
begin
  // (1) Verify conditions.
  Result := False;

  if (FTexture9 = nil) then
    Exit;

  // (2) Determine USAGE.
  Usage := 0;
  if (Flags = lfReadOnly) then
    Usage := D3DLOCK_READONLY;

  // (3) Lock the entire texture.
  Result := Succeeded(FTexture9.LockRect(0, LockedRect, nil, Usage));

  // (4) Return access information.
  if (Result) then
  begin
    Access.Bits := LockedRect.pBits;
    Access.Pitch := LockedRect.Pitch;
    Access.Format := D3DToFormat(FFormat);
  end;
end;

function TDXTexture.LockRect(const LockArea: TRect; Flags: TDXLockFlags; out Access: TDXAccessInfo): Boolean;
var
  LockedRect: TD3DLocked_Rect;
  Usage: Cardinal;
begin
  // (1) Verify conditions.
  Result := False;
  if (FTexture9 = nil) then
    Exit;

  // (2) Determine USAGE.
  Usage := 0;
  if (Flags = lfReadOnly) then
    Usage := D3DLOCK_READONLY;

  // (3) Lock the entire texture.
  Result := Succeeded(FTexture9.LockRect(0, LockedRect, @LockArea, Usage));

  // (4) Return access information.
  if (Result) then
  begin
    Access.Bits := LockedRect.pBits;
    Access.Pitch := LockedRect.Pitch;
    Access.Format := D3DToFormat(FFormat);
  end;
end;

procedure TDXTexture.Lost;
begin
  ChangeState(tsLost);
end;

procedure TDXTexture.MakeNotReady;
begin
  if (FTexture9 <> nil) then
    FTexture9 := nil;
end;

function TDXTexture.MakeReady: Boolean;
var
  Res: Integer;
  Pool: TD3DPool;
  Usage: Cardinal;
  Levels: Integer;
begin
  // (1) Determine texture POOL.
  Result := False;

  Pool := D3DPOOL_DEFAULT;
  case FBehavior of
    tbManaged: Pool := D3DPOOL_MANAGED;
    tbSystem: Pool := D3DPOOL_SYSTEMMEM;
  end;

  // (2) Apply MipMapping request.
  if (FMipMapping) then
  begin
    Usage := D3DUSAGE_AUTOGENMIPMAP;
    Levels := 0;
  end
  else
  begin
    Usage := 0;
    Levels := 1;
  end;

  // (3) Determine texture USAGE.
  case FBehavior of
    tbDynamic: Usage := Usage or D3DUSAGE_DYNAMIC;
    tbRTarget: Usage := Usage or D3DUSAGE_RENDERTARGET;
  end;

  // (4) Attempt to create the texture.
  Res := Direct3DDevice.CreateTexture(FSize.X, FSize.Y, Levels, Usage, FFormat, Pool, FTexture9, nil);
  if (Failed(Res)) then
  begin
    // -> Release textures that were created successfully.
    MakeNotReady();
  end
  else
    Result := True;
end;

function TDXTexture.GetPixel(X, Y: Integer): Cardinal;
var
  Access: TDXAccessInfo;
  PPixel: Pointer;
begin
  Result := 0;
  if (X < 0) or (Y < 0) or (X > Size.X) or (Y > Size.Y) then
    exit;
  
  // (1) Lock the desired texture.
  if (not Lock(lfReadOnly, Access)) then
  begin
    Result := 0;
    Exit;
  end;
  try
    PPixel := Pointer(Integer(Access.Bits) + (Access.Pitch * Y) + (X * Format2Bytes[Access.Format]));
    Result := DisplaceRB(PixelXto32(PPixel, Access.Format));
  finally
    Unlock();
  end;
end;

function TDXTexture.Height: Integer;
begin
  Result := Size.Y;
end;

procedure TDXTexture.SetPatternSize(const Value: TPoint);
begin
  FPatternSize := Value;
  if FPatternSize.X > FSize.X then FPatternSize.X := FSize.X;
  if FPatternSize.Y > FSize.Y then FPatternSize.Y := FSize.Y;
end;

procedure TDXTexture.SetPixel(X, Y: Integer; const Value: Cardinal);
var
  Access: TDXAccessInfo;
  PPixel: Pointer;
begin
  // (1) Lock the desired texture.
  if (X < 0) or (Y < 0) or (X > Size.X) or (Y > Size.Y) then
    exit;
  if (not Lock(lfWriteOnly, Access)) then
    Exit;

  try
    // (2) Get pointer to the requested pixel.
    PPixel := Pointer(Integer(Access.Bits) + (Access.Pitch * Y) + (X * Format2Bytes[Access.Format]));

    // (3) Apply format conversion.
    Pixel32toX(DisplaceRB(Value), PPixel, Access.Format);
  finally
    // (4) Unlock the texture.
    Unlock();
  end;
end;

function TDXTexture.Prepare: Boolean;
begin
  Result := True;
end;

procedure TDXTexture.Recovered;
begin
  ChangeState(tsReady);
end;

function TDXTexture.RetreiveUsage: Cardinal;
begin
  Result := 0;
  if (FMipMapping) then
    Result := D3DUSAGE_AUTOGENMIPMAP;
end;

function TDXTexture.SelectTexture(TexCoord: TTexCoord; out Points: TPoint4): Boolean;
var
  u1, v1: Real;
  u2, v2: Real;
begin
  if (FState = tsNotReady) then
  begin
    Result := False;
    Exit;
  end;

  u1 := TexCoord.X / Size.X;
  v1 := TexCoord.Y / Size.Y;
  
  if (TexCoord.w > 0) then
    u2 := ((TexCoord.X + TexCoord.w) / Size.X)
  else
    u2 := ((TexCoord.X + Size.X) / Size.X);

  if (TexCoord.h > 0) then
    v2 := ((TexCoord.Y + TexCoord.h) / Size.Y)
  else
    v2 := ((TexCoord.Y + Size.Y) / Size.Y);

  if (TexCoord.Mirror) then
  begin
    Points[0].x := u2;
    Points[1].x := u1;
    Points[3].x := u2;
    Points[2].x := u1;
  end
  else
  begin
    Points[0].x := u1;
    Points[1].x := u2;
    Points[3].x := u1;
    Points[2].x := u2;
  end;

  if (TexCoord.Flip) then
  begin
    Points[0].y := v2;
    Points[1].y := v2;
    Points[3].y := v1;
    Points[2].y := v1;
  end
  else
  begin
    Points[0].y := v1;
    Points[1].y := v1;
    Points[3].y := v2;
    Points[2].y := v2;
  end;

  Result := True;
end;

procedure TDXTexture.SetActive(const Value: Boolean);
begin
  if Value then
    ChangeState(tsReady)
  else
    ChangeState(tsNotReady);
  FActive := FState = tsReady;
end;

procedure TDXTexture.SetBehavior(const Value: TDXTextureBehavior);
begin
  if (FState = tsNotReady) then
    FBehavior := Value;
end;

procedure TDXTexture.SetFormat(const Value: TD3DFormat);
begin
  if (FState = tsNotReady) then
    FFormat := Value;
end;

procedure TDXTexture.SetMipMapping(const Value: Boolean);
begin
  if (FState = tsNotReady) then
    FMipMapping := Value;
end;

procedure TDXTexture.SetSize(const Value: TPoint);
begin
  if (FState = tsNotReady) then begin
    FSize := Value;
    if Direct3DCompatible then begin
      if FSize.X > 1024 then FSize.X := 2048
      else if FSize.X > 512 then FSize.X := 1024
      else if FSize.X > 256 then FSize.X := 512
      else if FSize.X > 128 then FSize.X := 256
      else if FSize.X > 64 then FSize.X := 128
      else if FSize.X > 32 then FSize.X := 64
      else if FSize.X > 16 then FSize.X := 32
      else if FSize.X > 8 then FSize.X := 16
      else FSize.X := 8;

      if FSize.Y > 1024 then FSize.Y := 2048
      else if FSize.Y > 512 then FSize.Y := 1024
      else if FSize.Y > 256 then FSize.Y := 512
      else if FSize.Y > 128 then FSize.Y := 256
      else if FSize.Y > 64 then FSize.Y := 128
      else if FSize.Y > 32 then FSize.Y := 64
      else if FSize.Y > 16 then FSize.Y := 32
      else if FSize.Y > 8 then FSize.Y := 16
      else FSize.Y := 8;
    end;
  end;
end;

procedure TDXTexture.StretchDraw(SrcRect, DesRect: TRect; Source: TDXTexture; Transparent: Boolean);
begin
  if (FDrawCanvas <> nil) and (Source <> nil) then
    TDXDrawCanvas(FDrawCanvas).StretchDraw(SrcRect, DesRect, Source, Transparent);
end;

procedure TDXTexture.StretchDraw(SrcRect, DesRect: TRect; Source: TDXTexture; DrawFx: Cardinal);
begin
  if (FDrawCanvas <> nil) and (Source <> nil) then
    TDXDrawCanvas(FDrawCanvas).StretchDraw(SrcRect, DesRect, Source, DrawFx, clWhite4);
end;

procedure TDXTexture.TextOutEx(X, Y: Integer; Text: WideString; FColor: Cardinal; BColor: Cardinal);
var
  Access: TDXAccessInfo;
  sWord: Word;
  AsciiRect: TRect;
  I, j, nY, kerning, nFontWidth, nFontHeight: Integer;
  ReadBuffer, WriteBuffer: Pointer;
  wColor, wBColor: Word;
  RGBQuad: TRGBQuad;
  FontData: pTFontData;
begin
  if Text = '' then exit;
  if BColor = 0 then begin
    TextOutEx(X, Y, Text, FColor);
    exit;
  end;
  Dec(X);
  Dec(Y);
  FColor := DisplaceRB(FColor or $FF000000);
  RGBQuad := PRGBQuad(@FColor)^;
  wColor := ($F0 shl 8) + ((WORD(RGBQuad.rgbRed) and $F0) shl 4) + (WORD(RGBQuad.rgbGreen) and $F0) + (WORD(RGBQuad.rgbBlue) shr 4);

  BColor := DisplaceRB(BColor or $FF000000);
  RGBQuad := PRGBQuad(@BColor)^;
  wBColor := ($F0 shl 8) + ((WORD(RGBQuad.rgbRed) and $F0) shl 4) + (WORD(RGBQuad.rgbGreen) and $F0) + (WORD(RGBQuad.rgbBlue) shr 4);
  if (FDrawCanvas <> nil) and (TDXDrawCanvas(FDrawCanvas).Font <> nil) then begin
    FontData := TDXDrawCanvas(FDrawCanvas).Font.FontData;
    kerning := TDXDrawCanvas(FDrawCanvas).Font.kerning;
    if Lock(lfWriteOnly, Access) then begin
      Try
        for I := 1 to Length(Text) do begin
          if X >= Width then break;
          Move(Text[i], sWord, 2);
          AsciiRect := TDXDrawCanvas(FDrawCanvas).Font.AsciiRect[sWord];
          if (AsciiRect.Right > 4) then begin
            nY := Y;
            nFontWidth := AsciiRect.Right - AsciiRect.Left;
            if nFontWidth < 4 then Continue;
            if X < 0 then begin
              if (-X) >= (nFontWidth + kerning) then begin
                Inc(X, nFontWidth + kerning);
                Continue;
              end;
              AsciiRect.Left := AsciiRect.Left - X;
              nFontWidth := AsciiRect.Right - AsciiRect.Left;
              if nFontWidth <= 0 then begin
                X := kerning;
                Continue;
              end;
              X := 0;
            end;
            if (X + nFontWidth) >= Width then begin
              nFontWidth := Width - X;
              if nFontWidth <= 0 then Exit;
            end;
            //
            if nY < 0 then begin
              AsciiRect.Top := AsciiRect.Top - nY;
              nY := 0;
            end;
            nFontHeight := AsciiRect.Bottom - AsciiRect.Top;
            if nFontHeight <= 0 then begin
              Inc(X, nFontWidth + kerning);
              Continue;
            end;
            //nHeight := 0;
            for j := AsciiRect.Top to AsciiRect.Bottom - 1 do begin
              if nY >= Height then break;
              ReadBuffer := @(FontData^[j][AsciiRect.Left]);
              WriteBuffer := Pointer(Integer(Access.Bits) + Access.Pitch * nY + X * 2);
              asm
                push esi
                push edi
                push ebx
                push edx

                mov esi, ReadBuffer
                mov edi, WriteBuffer
                mov ecx, nFontWidth
                mov dx,  wColor
                mov bx,  wBColor
              @pixloop:
                mov ax, [esi].word
                add esi, 2

                cmp ax, 0
                JE  @@Next
                  
                cmp ax, $F000
                JE  @@AddBColor

                and ax, dx
                mov [edi], dx
                JMP @@Next
              @@AddBColor:
                mov [edi], bx

              @@Next:
                add edi, 2

                dec ecx
                jnz @pixloop

                pop edx
                pop ebx
                pop edi
                pop esi
              end;
              Inc(nY);
            end;
            Inc(X, nFontWidth + kerning);
          end;
        end;
      Finally
        UnLock;
      End;
    end;
  end;
end;

procedure TDXTexture.TextOutEx(X, Y: Integer; Text: WideString; FColor: Cardinal);
var
  Access: TDXAccessInfo;
  sWord: Word;
  AsciiRect: TRect;
  I, j, nY, kerning, nFontWidth, nFontHeight: Integer;
  ReadBuffer, WriteBuffer: Pointer;
  wColor: Word;
  RGBQuad: TRGBQuad;
  FontData: pTFontData;
begin
  if Text = '' then exit;
  Dec(X);
  Dec(Y);
  FColor := DisplaceRB(FColor or $FF000000);
  RGBQuad := PRGBQuad(@FColor)^;
  wColor := ($F0 shl 8) + ((WORD(RGBQuad.rgbRed) and $F0) shl 4) + (WORD(RGBQuad.rgbGreen) and $F0) + (WORD(RGBQuad.rgbBlue) shr 4);
  if (FDrawCanvas <> nil) and (TDXDrawCanvas(FDrawCanvas).Font <> nil) then begin
    FontData := TDXDrawCanvas(FDrawCanvas).Font.FontData;
    kerning := TDXDrawCanvas(FDrawCanvas).Font.kerning;
    if Lock(lfWriteOnly, Access) then begin
      Try
        for I := 1 to Length(Text) do begin
          if X >= Width then break;
          Move(Text[i], sWord, 2);
          AsciiRect := TDXDrawCanvas(FDrawCanvas).Font.AsciiRect[sWord];
          if (AsciiRect.Right > 4) then begin
            nY := Y;
            nFontWidth := AsciiRect.Right - AsciiRect.Left;
            if nFontWidth < 4 then Continue;
            if X < 0 then begin
              if (-X) >= (nFontWidth + kerning) then begin
                Inc(X, nFontWidth + kerning);
                Continue;
              end;
              AsciiRect.Left := AsciiRect.Left - X;
              nFontWidth := AsciiRect.Right - AsciiRect.Left;
              if nFontWidth <= 0 then begin
                X := kerning;
                Continue;
              end;
              X := 0;
            end;
            if (X + nFontWidth) >= Width then begin
              nFontWidth := Width - X;
              if nFontWidth <= 0 then Exit;
            end;
            //
            if nY < 0 then begin
              AsciiRect.Top := AsciiRect.Top - nY;
              nY := 0;
            end;
            nFontHeight := AsciiRect.Bottom - AsciiRect.Top;
            if nFontHeight <= 0 then begin
              Inc(X, nFontWidth + kerning);
              Continue;                           
            end;
            //nHeight := 0;
            for j := AsciiRect.Top to AsciiRect.Bottom - 1 do begin
              if nY >= Height then break;
              ReadBuffer := @(FontData^[j][AsciiRect.Left]);
              WriteBuffer := Pointer(Integer(Access.Bits) + Access.Pitch * nY + X * 2);
              asm
                push esi
                push edi
                push ebx
                push edx

                mov esi, ReadBuffer
                mov edi, WriteBuffer
                mov ecx, nFontWidth
                mov dx,  wColor
              @pixloop:
                mov ax, [esi].word
                add esi, 2

                cmp ax, 0
                JE  @@Next

                and ax, dx
                mov [edi], ax
              @@Next:
                add edi, 2

                dec ecx
                jnz @pixloop

                pop edx
                pop ebx
                pop edi
                pop esi
              end;
              Inc(nY);
            end;
            Inc(X, nFontWidth + kerning);
          end;
        end;
      Finally
        UnLock;
      End;
    end;
  end;
end;

procedure TDXTexture.CopyTexture(SourceTexture: TDXTexture);
var
  SourceAccess: TDXAccessInfo;
  Access: TDXAccessInfo;
begin
  if SourceTexture = nil then exit;
  if Active then
    ChangeState(tsNotReady);
  FSize := SourceTexture.Size;
  FPatternSize := SourceTexture.PatternSize;
  FFormat := SourceTexture.Format;
  ChangeState(tsReady);
  if SourceTexture.Lock(lfReadOnly, SourceAccess) then begin
    Try
      if Lock(lfWriteOnly, Access) then begin
        Try
          Move(SourceAccess.Bits^, Access.Bits^, Access.Pitch * FSize.Y);
        Finally
          UnLock;
        End;
      end;
    Finally
      SourceTexture.Unlock;
    End;
  end;
end;

procedure TDXTexture.TextOutEx(X, Y: Integer; Text: WideString);
begin
  TextOutEx(X, Y, Text, clWhite);
end;

function TDXTexture.Unlock(): Boolean;
begin
  Result := (FTexture9 <> nil) and (Succeeded(FTexture9.UnlockRect(0)));
end;

function TDXTexture.Width: Integer;
begin
  Result := Size.X;
end;

{ function TDXTexture.Width: Integer;
begin

end;

TDXImageTexture }

procedure TDXImageTexture.Clear;
begin
  inherited;
//  FPatternSize.X := 1;
//  FPatternSize.Y := 1;
end;

function TDXImageTexture.ClientRect: TRect;
begin
  Result.Left := 0;
  Result.Top := 0;
  Result.Right := FPatternSize.X;
  Result.Bottom := FPatternSize.Y;
end;

constructor TDXImageTexture.Create(DrawCanvas: TObject = nil);
begin
  inherited;
  FQuality := aqHigh;
  FAlphaLevel := alFull;
end;

destructor TDXImageTexture.Destroy;
begin

  inherited;
end;

function TDXImageTexture.Height: Integer;
begin
  Result := FPatternSize.Y;
end;

function TDXImageTexture.Prepare: Boolean;
begin
  Result := UpdateInfo();
  {if (Result) then
  begin
    FFormat := D3DFMT_A4R4G4B4;  }
    //FFormat := DXApproxFormat(FQuality, FAlphaLevel, RetreiveUsage());
    //Result := (FFormat <> D3DFMT_UNKNOWN);
  //end;
end;


function TDXImageTexture.SelectTexture(TexCoord: TTexCoord; out Points: TPoint4): Boolean;
var
  u1, v1: Real;
  u2, v2: Real;
begin
  if (FState = tsNotReady) then
  begin
    Result := False;
    Exit;
  end;

  u1 := TexCoord.X / Size.X;
  v1 := TexCoord.Y / Size.Y;
  if (TexCoord.w > 0) then
    u2 := ((TexCoord.X + TexCoord.w) / Size.X)
  else
    u2 := ((TexCoord.X + PatternSize.X) / Size.X);

  if (TexCoord.h > 0) then
    v2 := ((TexCoord.Y + TexCoord.h) / Size.Y)
  else
    v2 := ((TexCoord.Y + PatternSize.Y) / Size.Y);

  if (TexCoord.Mirror) then
  begin
    Points[0].x := u2;
    Points[1].x := u1;
    Points[3].x := u2;
    Points[2].x := u1;
  end
  else
  begin
    Points[0].x := u1;
    Points[1].x := u2;
    Points[3].x := u1;
    Points[2].x := u2;
  end;

  if (TexCoord.Flip) then
  begin
    Points[0].y := v2;
    Points[1].y := v2;
    Points[3].y := v1;
    Points[2].y := v1;
  end
  else
  begin
    Points[0].y := v1;
    Points[1].y := v1;
    Points[3].y := v2;
    Points[2].y := v2;
  end;

  Result := True;
end;

procedure TDXImageTexture.SetAlphaLevel(const Value: TAlphaLevel);
begin
  if (FState = tsNotReady) then
    FAlphaLevel := Value;
end;

procedure TDXImageTexture.SetQuality(const Value: TAsphyreQuality);
begin
  if (FState = tsNotReady) then
    FQuality := Value;
end;

function TDXImageTexture.UpdateInfo: Boolean;
begin
  Result := True;

  if (FPatternSize.X < 1) then
    FPatternSize.X := Size.X;
  if (FPatternSize.Y < 1) then
    FPatternSize.Y := Size.Y;

  if (Size.X < 1) or (Size.Y < 1) or (FPatternSize.X > Size.X) or (FPatternSize.Y > Size.Y) then
  begin
    Result := False;
    Exit;
  end;

end;

function TDXImageTexture.Width: Integer;
begin
  Result := FPatternSize.X;
end;

{ TDXRenderTargetTexture }

function TDXRenderTargetTexture.BeginRender: Boolean;
begin
  Result := (State = tsReady);
  if (not Result) then
    Exit;

  // (3) Retreive previous render target.
  Result := Succeeded(Direct3DDevice.GetRenderTarget(0, PrevTarget));
  if (not Result) then
    Exit;

  // (4) Retreive previous depth-stencil buffer.
  if (FDepthBuffer) then
  begin
    Result := Succeeded(Direct3DDevice.GetDepthStencilSurface(PrevDepthBuf));
    if (not Result) then
      Exit;
  end;

  Result := Succeeded(Direct3DDevice.SetRenderTarget(0, TextureSurface));
  if (not Result) then
    Exit;

  if (FDepthBuffer) then
  begin
    Result := Succeeded(Direct3DDevice.SetDepthStencilSurface(DepthSurface));
    if (not Result) then
      Exit;
  end;
  //TextureSurface := nil;
end;

constructor TDXRenderTargetTexture.Create(DrawCanvas: TObject = nil);
begin
  inherited;
  FBehavior := tbRTarget;
  FDepthBuffer := False;
  MipMapping := False;

  DepthSurface := nil;
  PrevTarget := nil;
  PrevDepthBuf := nil;
  //TextureSurface := nil;
end;

destructor TDXRenderTargetTexture.Destroy;
begin
  if (DepthSurface <> nil) then
    DepthSurface := nil;
  if (PrevTarget <> nil) then
    PrevTarget := nil;
  if (PrevDepthBuf <> nil) then
    PrevDepthBuf := nil;
  if (TextureSurface <> nil) then
    TextureSurface := nil;
  inherited;
end;

procedure TDXRenderTargetTexture.EndRender;
begin
  if (PrevTarget <> nil) then
  begin
    Direct3DDevice.SetRenderTarget(0, PrevTarget);
    PrevTarget := nil;
  end;

  if (PrevDepthBuf <> nil) then
  begin
    Direct3DDevice.SetDepthStencilSurface(PrevDepthBuf);
    PrevDepthBuf := nil;
  end;
end;

procedure TDXRenderTargetTexture.MakeNotReady;
begin
  if (DepthSurface <> nil) then
    DepthSurface := nil;
  if (PrevTarget <> nil) then
    PrevTarget := nil;
  if (PrevDepthBuf <> nil) then
    PrevDepthBuf := nil;
  if (TextureSurface <> nil) then
    TextureSurface := nil;

  inherited MakeNotReady();
end;

function TDXRenderTargetTexture.MakeReady: Boolean;
begin
  Result := inherited MakeReady();
  if (not Result) then
    Exit;

  Result := Succeeded(Texture9.GetSurfaceLevel(0, TextureSurface));
  if (not Result) then
    Exit;
  // create Depth-Buffer, if necessary
  if (FDepthBuffer) then
  begin
    with Direct3DDevice, PresentParams do
    begin
      Result := Succeeded(CreateDepthStencilSurface(Size.X, Size.Y,
        AutoDepthStencilFormat, MultiSampleType, MultiSampleQuality, True,
        DepthSurface, nil));
      if not Result then
        exit;
    end;
  end;
end;

function TDXRenderTargetTexture.Prepare: Boolean;
begin
  FFormat := PresentParams.BackBufferFormat;
  Result := (FFormat <> D3DFMT_UNKNOWN);
end;

procedure TDXRenderTargetTexture.SetDepthBuffer(const Value: Boolean);
begin
  if (FState = tsNotReady) then
    FDepthBuffer := Value;
end;

{ TCompatibleCanvas }

function TCompatibleCanvas.TextHeight(Str: WideString): Integer;
begin
  Result := 12;
end;

procedure TCompatibleCanvas.TextOut(x, Y: Integer; Str: WideString; FColor: Integer);
begin
  //
end;

function TCompatibleCanvas.TextWidth(Str: WideString): Integer;
begin
  Result := 0;
end;

end.

