unit HGETextures;

interface

uses
  Windows, SysUtils, Classes, HGE, DirectXGraphics, Graphics, HGEBase;

type
  TDXTextureBehavior = (tbManaged, tbUnmanaged, tbDynamic, tbRTarget, tbSystem);
  TDXLockFlags = (lfNormal, lfReadOnly, lfWriteOnly);
  TDXTextureState = (tsNotReady, tsReady, tsLost, tsFailure);

  TDXAccessInfo = record
    Bits: Pointer;
    Pitch: Integer;
    Format: TColorFormat;
  end;

  TDXTexture = class
  private
    FTexture: ITexture;
    FSize: TPoint;
    FPatternSize: TPoint;
    FFormat: TD3DFormat;
    FBehavior: TDXTextureBehavior;
    FActive: Boolean;
    FDrawCanvas: TObject;
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    procedure SetSize(const Value: TPoint);
    //procedure MakeTexture();
    procedure SetBehavior(const Value: TDXTextureBehavior);
    procedure SetFormat(const Value: TD3DFormat);
    procedure SetPatternSize(const Value: TPoint);
    function GetPool(): TD3DPool;
    procedure LoadBitmapToTexture(Stream: TStream);
    function GetPixel(X, Y: Integer): Cardinal;
    procedure SetPixel(X, Y: Integer; const Value: Cardinal);
  protected
    FState: TDXTextureState;
    function MakeReady(): Boolean; dynamic;
    procedure MakeNotReady(); dynamic;
    procedure ChangeState(NewState: TDXTextureState);
  public
    constructor Create(DrawCanvas: TObject = nil); dynamic;
    destructor Destroy; override;

    procedure LoadFromFile(FileName: string);
    function Lock(Flags: TDXLockFlags; out Access: TDXAccessInfo): Boolean;
    function LockRect(const LockArea: TRect; Flags: TDXLockFlags; out Access: TDXAccessInfo): Boolean;
    function Unlock(): Boolean;

    procedure Lost(); dynamic;
    procedure Recovered(); dynamic;
    function Clear(): Boolean;

    function ClientRect: TRect; dynamic;
    function Width: Integer; dynamic;
    function Height: Integer; dynamic;

    procedure CopyTexture(SourceTexture: TDXTexture); overload;
    procedure CopyTexture(X, Y: Integer; SourceTexture: TDXTexture); overload;
    procedure Line(nX, nY, nLength: Integer; FColor: Cardinal);
    procedure LineTo(nX, nY, nWidth: Integer; FColor: Cardinal);

    property Canvas: TObject read FDrawCanvas write FDrawCanvas;
    property Active: Boolean read GetActive write SetActive;
    property Size: TPoint read FSize write SetSize;
    property PatternSize: TPoint read FPatternSize write SetPatternSize;
    property Image: ITexture read FTexture write FTexture;
    property Format: TD3DFormat read FFormat write SetFormat;
    property Behavior: TDXTextureBehavior read FBehavior write SetBehavior;
    property Pixels[X, Y: Integer]: Cardinal read GetPixel write SetPixel;

    procedure TextOutEx(X, Y: Integer; Text: WideString); overload;
    procedure TextOutEx(X, Y: Integer; Text: WideString; FColor: Cardinal); overload;
    procedure TextOutEx(X, Y: Integer; Text: WideString; FColor: Cardinal; BColor: Cardinal; boClearMark: Boolean = False); overload;

    procedure Draw(X, Y: Integer; Source: TDXTexture; Transparent: Boolean); overload;
    procedure Draw(X, Y: Integer; Source: TDXTexture; Transparent, MirrorX, MirrorY: Boolean); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent: Boolean); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent, MirrorX, MirrorY: Boolean); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Color, DrawFx: Cardinal); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent: Boolean; DrawFx: Cardinal); overload;
    procedure StretchDraw(SrcRect, DesRect: TRect; Source: TDXTexture; Transparent: Boolean); overload;
    procedure StretchDraw(SrcRect, DesRect: TRect; Source: TDXTexture; DrawFx: Cardinal); overload;
    procedure StretchDraw(SrcRect, DesRect: TRect; Source: TDXTexture; dwColor: Cardinal; DrawFx: Cardinal); overload;
  end;

  TDXImageTexture = class(TDXTexture)
  public
    constructor Create(DrawCanvas: TObject = nil); override;

    function ClientRect: TRect; override;
    function Width: Integer; override;
    function Height: Integer; override;
  end;

  TDXRenderTargetTexture = class(TDXTexture)
  private
    FTarget: ITarget;
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
  protected
    function MakeReady(): Boolean; override;
    procedure MakeNotReady(); override;
  public
    constructor Create(DrawCanvas: TObject = nil); override;
    destructor Destroy; override;

    procedure Lost(); override;
    procedure Recovered(); override;

    property Target: ITarget read FTarget write FTarget;
    property Active: Boolean read GetActive write SetActive;
  end;

  TDirectDrawSurface = TDXTexture;

procedure InitializeTexturesInfo();

implementation

uses
  HGECanvas, HGEFonts;

var
  FHGE: IHGE = nil;

procedure InitializeTexturesInfo();
begin
  FHGE := HGECreate(HGE_VERSION);
end;

{ TDXTexture }

procedure TDXTexture.ChangeState(NewState: TDXTextureState);
begin
  if (FState = tsNotReady) and (NewState = tsReady) then
  begin
    if MakeReady() then
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

function TDXTexture.Clear(): Boolean;
var
  Access: TDXAccessInfo;
begin
  Result := False;
  if not Active then exit;
  if Lock(lfWriteOnly, Access) then begin
    Try
      FillChar(Access.Bits^, Access.Pitch * Size.Y, #0);
      Result := True;
    Finally
      Unlock();
    End;
  end;
end;

function TDXTexture.ClientRect: TRect;
begin
  Result.Left := 0;
  Result.Top := 0;
  Result.Right := FSize.X;
  Result.Bottom := FSize.Y;
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

constructor TDXTexture.Create(DrawCanvas: TObject);
begin
  inherited Create;
  FTexture := nil;
  FState := tsNotReady;
  FFormat := D3DFMT_A8R8G8B8;
  FBehavior := tbManaged;
  FActive := False;
  FDrawCanvas := DrawCanvas;
end;

destructor TDXTexture.Destroy;
begin
  if FTexture <> nil then
    FTexture.Handle := nil;
  FTexture := nil;
  inherited;
end;

procedure TDXTexture.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent: Boolean);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).DrawRect(Source, X, Y, SrcRect, bTransparent[Transparent]);
end;

procedure TDXTexture.Draw(X, Y: Integer; Source: TDXTexture; Transparent: Boolean);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).Draw(Source, X, Y, bTransparent[Transparent]);
end;

procedure TDXTexture.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Color, DrawFx: Cardinal);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).DrawRect(Source, X, Y, SrcRect, DrawFx, Color);
end;

procedure TDXTexture.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).DrawRect(Source, X, Y, SrcRect, DrawFx);
end;

function TDXTexture.GetActive: Boolean;
begin
  Result := (FTexture <> nil) and (FState = tsReady) and (FTexture.Handle <> nil);
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

function TDXTexture.GetPool: TD3DPool;
begin
  Result := D3DPOOL_DEFAULT;
  case FBehavior of
    tbManaged: Result := D3DPOOL_MANAGED;
    tbUnmanaged: ;
    tbDynamic: ;
    tbRTarget: ;
    tbSystem: Result := D3DPOOL_SYSTEMMEM;
  end;
end;

function TDXTexture.Height: Integer;
begin
  Result := FSize.Y;
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

procedure TDXTexture.LoadBitmapToTexture(Stream: TStream);
var
  Bitmap: TBitmap;
  Access: TDXAccessInfo;
  Y: Integer;
  WriteBuffer, ReadBuffer: PChar;
begin
  Bitmap := TBitmap.Create;
  Try
    Stream.Position := 0;
    Bitmap.LoadFromStream(Stream);
    FTexture := FHGE.Texture_Create(Bitmap.Width, Bitmap.Height, GetPool, FFormat);
    if (FTexture <> nil) and (FTexture.Handle <> nil) then begin
      if Lock(lfWriteOnly, Access) then begin
        for Y := 0 to Bitmap.Height - 1 do begin
          ReadBuffer := Bitmap.ScanLine[Y];
          WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
          Move(ReadBuffer^, WriteBuffer^, Bitmap.Width * 2);
        end;
        UnLock;
      end;
    end;
  Finally
    Bitmap.Free;
  End;
end;

procedure TDXTexture.LoadFromFile(FileName: string);
var
  MemoryStream: TMemoryStream;
begin
  if FTexture <> nil then begin
    FTexture.Handle := nil;
    FTexture := nil;
  end;
  if FileExists(FileName) then begin
    MemoryStream := TMemoryStream.Create;
    Try
      MemoryStream.LoadFromFile(FileName);
      if MemoryStream.Size > 2 then begin
        if (PChar(MemoryStream.Memory)[0] + PChar(MemoryStream.Memory)[1]) = 'BM' then begin
          LoadBitmapToTexture(MemoryStream);
        end;
        if FTexture <> nil then begin
          FSize.X := FTexture.GetWidth;
          FSize.Y := FTexture.GetHeight;
          FPatternSize := FSize;
        end;
      end;
    Finally
      MemoryStream.Free;
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

  if (FTexture = nil) or (FTexture.Handle = nil) then
    Exit;

  // (2) Determine USAGE.
  Usage := 0;
  if (Flags = lfReadOnly) then
    Usage := D3DLOCK_READONLY;

  // (3) Lock the entire texture.
  Result := Succeeded(FTexture.Handle.LockRect(0, LockedRect, nil, Usage));

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
  if (FTexture = nil) or (FTexture.Handle = nil) then
    Exit;

  // (2) Determine USAGE.
  Usage := 0;
  if (Flags = lfReadOnly) then
    Usage := D3DLOCK_READONLY;

  // (3) Lock the entire texture.
  Result := Succeeded(FTexture.Handle.LockRect(0, LockedRect, @LockArea, Usage));

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
  if FTexture <> nil then
    FTexture.Handle := nil;
  FTexture := nil;
end;

function TDXTexture.MakeReady: Boolean;
var
//  Res: Integer;
  Pool: TD3DPool;
  //Usage: Cardinal;
  //Levels: Integer;
begin
  // (1) Determine texture POOL.
  Result := False;

  Pool := D3DPOOL_DEFAULT;
  case FBehavior of
    tbManaged: Pool := D3DPOOL_MANAGED;
    tbSystem: Pool := D3DPOOL_SYSTEMMEM;
  end;

  // (2) Apply MipMapping request.
  {if (FMipMapping) then
  begin
    Usage := D3DUSAGE_AUTOGENMIPMAP;
    Levels := 0;
  end
  else
  begin  }
  //Usage := 0;
  //Levels := 1;
  //end;

  // (3) Determine texture USAGE.
  {case FBehavior of
    tbDynamic: Usage := Usage or D3DUSAGE_DYNAMIC;
    tbRTarget: Usage := Usage or D3DUSAGE_RENDERTARGET;
  end;   }

  FTexture := FHGE.Texture_Create(FSize.X, FSize.Y, Pool, FFormat);
  if (FTexture <> nil) and (FTexture.Handle <> nil) then begin
    FSize.X := FTexture.GetWidth();
    FSize.Y := FTexture.GetHeight();
    Result := True;
  end else
    FTexture := nil;

  // (4) Attempt to create the texture.
  {Res := Direct3DDevice.CreateTexture(FSize.X, FSize.Y, Levels, Usage, FFormat, Pool, FTexture9, nil);
  if (Failed(Res)) then
  begin
    // -> Release textures that were created successfully.
    MakeNotReady();
  end
  else
    Result := True;   }
end;
 {
procedure TDXTexture.MakeTexture;
begin
  //
end;    }

procedure TDXTexture.Recovered;
begin
  ChangeState(tsReady);
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
  FBehavior := Value;
end;

procedure TDXTexture.SetFormat(const Value: TD3DFormat);
begin
  FFormat := Value;
end;

procedure TDXTexture.SetPatternSize(const Value: TPoint);
begin
  FPatternSize := Value;
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

procedure TDXTexture.SetSize(const Value: TPoint);
begin
  FSize := Value;
end;

procedure TDXTexture.StretchDraw(SrcRect, DesRect: TRect; Source: TDXTexture; dwColor: Cardinal; DrawFx: Cardinal);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).DrawStretch(Source, SrcRect.Left, SrcRect.Top, SrcRect.Right, SrcRect.Bottom, DesRect, DrawFx, dwColor);
end;

procedure TDXTexture.StretchDraw(SrcRect, DesRect: TRect; Source: TDXTexture; DrawFx: Cardinal);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).DrawStretch(Source, SrcRect.Left, SrcRect.Top, SrcRect.Right, SrcRect.Bottom, DesRect, DrawFx);
end;

procedure TDXTexture.TextOutEx(X, Y: Integer; Text: WideString);
begin
  TextOutEx(X, Y, Text, clWhite);
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

procedure TDXTexture.TextOutEx(X, Y: Integer; Text: WideString; FColor, BColor: Cardinal; boClearMark: Boolean);
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

  if boClearMark then begin
    wBColor := 0;
  end
  else begin
    BColor := DisplaceRB(BColor or $FF000000);
    RGBQuad := PRGBQuad(@BColor)^;
    wBColor := ($F0 shl 8) + ((WORD(RGBQuad.rgbRed) and $F0) shl 4) + (WORD(RGBQuad.rgbGreen) and $F0) + (WORD(RGBQuad.rgbBlue) shr 4);

  end;
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

procedure TDXTexture.StretchDraw(SrcRect, DesRect: TRect; Source: TDXTexture; Transparent: Boolean);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).DrawStretch(Source, SrcRect.Left, SrcRect.Top, SrcRect.Right, SrcRect.Bottom, DesRect, bTransparent[Transparent]);
end;

function TDXTexture.Unlock: Boolean;
begin
  Result := (FTexture <> nil) and (FTexture.Handle <> nil) and (Succeeded(FTexture.Handle.UnlockRect(0)));
end;

function TDXTexture.Width: Integer;
begin
  Result := FSize.X;
end;

procedure TDXTexture.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent: Boolean; DrawFx: Cardinal);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).DrawRect(Source, X, Y, SrcRect, DrawFx, $7DFFFFFF);
end;

procedure TDXTexture.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent, MirrorX, MirrorY: Boolean);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).DrawRect(Source, X, Y, SrcRect, bTransparent[Transparent], $FFFFFFFF, MirrorX, MirrorY);
end;

procedure TDXTexture.Draw(X, Y: Integer; Source: TDXTexture; Transparent, MirrorX, MirrorY: Boolean);
begin
  if FDrawCanvas <> nil then
    TDXCanvas(FDrawCanvas).Draw(Source, X, Y, bTransparent[Transparent], $FFFFFFFF, MirrorX, MirrorY);
end;

{ TDXImageTexture }

function TDXImageTexture.ClientRect: TRect;
begin
  Result.Left := 0;
  Result.Top := 0;
  Result.Right := FPatternSize.X;
  Result.Bottom := FPatternSize.Y;
end;

constructor TDXImageTexture.Create(DrawCanvas: TObject);
begin
  inherited Create(DrawCanvas);
  FFormat := D3DFMT_A1R5G5B5;
  FBehavior := tbManaged;
end;

function TDXImageTexture.Height: Integer;
begin
  Result := FPatternSize.Y;
end;

function TDXImageTexture.Width: Integer;
begin
  Result := FPatternSize.X;
end;

{ TDXRenderTargetTexture }

constructor TDXRenderTargetTexture.Create(DrawCanvas: TObject);
begin
  inherited;
  FTarget := nil;
end;

destructor TDXRenderTargetTexture.Destroy;
begin
  FTarget := nil;
  FTexture := nil;
  inherited;
end;

function TDXRenderTargetTexture.GetActive: Boolean;
begin
  Result := (FTarget <> nil) and (FTexture <> nil);
end;

procedure TDXRenderTargetTexture.Lost;
begin
  FTexture := nil;
end;

procedure TDXRenderTargetTexture.MakeNotReady;
begin
  FTarget := nil;
end;

function TDXRenderTargetTexture.MakeReady: Boolean;
begin
  Result := False;
  if FTarget = nil then begin
    FTarget := FHGE.Target_Create(FSize.X, FSize.Y, False);
    if FTarget <> nil then begin
      FTexture := FTarget.GetTexture;
      if FTexture <> nil then begin
        FPatternSize.X := FSize.X;
        FPatternSize.Y := FSize.Y;
        FSize.X := FTexture.GetWidth();
        FSize.Y := FTexture.GetHeight();
      end;
    end;
    Result := (FTarget <> nil) and (FTexture <> nil);
  end;
end;

procedure TDXRenderTargetTexture.Recovered;
begin
  if FTarget <> nil then FTexture := FTarget.GetTexture;
end;

procedure TDXRenderTargetTexture.SetActive(const Value: Boolean);
begin
  if Value then MakeReady
  else MakeNotReady;
end;

initialization
  FHGE := nil;

finalization
  FHGE := nil;


end.

