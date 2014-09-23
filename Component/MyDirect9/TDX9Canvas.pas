unit TDX9Canvas;

interface
uses
  Windows, Types, SysUtils, TDX9Textures, MyDirect3D9, TDX9Fonts, MyDXBase, Graphics;

type
  PVertexRecord = ^TVertexRecord;
  TVertexRecord = record
    Vertex: TD3DVector;
    rhw: Single;
    Color: Longword;
    u, v: Single;
    //test: Longword;
  end;

  TPrimitiveType = (cptPoints, cptLines, cptTriangles, cptNone);

  TDXCanvas = class
  private
    Initialized: Boolean;
    BuffersLost: Boolean;
    FVertexCache: Integer;

    VertexBuffer: IDirect3DVertexBuffer9;
    IndexBuffer: IDirect3DIndexBuffer9;

    FAntialias: Boolean;
    FDithering: Boolean;
    FAlphaTesting: Boolean;
    AfterFlush: Boolean;
    VertexArray: Pointer;
    IndexArray: Pointer;

    VertexAmount: Integer;
    IndexAmount: Integer;
    Primitives: Integer;
    PrimType: TPrimitiveType;
    CachedImage: TDXTexture;
    CachedDrawFx: Cardinal;

    FCacheStall: Integer;

    FFont: TDX9Font;

    function AllocateBuffers(): Boolean;
    procedure ReleaseBuffers();
    procedure PrepareVertexArray();
    function CreateVertexBuffer(): Boolean;
    function CreateIndexBuffer(): Boolean;
    procedure ResetCache();
    function UploadVertexBuffer(): Boolean;
    function UploadIndexBuffer(): Boolean;
    function PrepareDraw(): Boolean;
    function BufferDraw(): Boolean;
    procedure UnFlush();
    procedure BufferTex(const Quad, TexCoord: TPoint4; const Colors: TColor4;
      Image: TDXTexture; DrawFx: Cardinal);
    procedure RequestCache(PType: TPrimitiveType; Vertices, Indices: Integer; Image: TDXTexture; DrawFx: Cardinal);
    procedure AddVIndex(Index: Integer);
    function NextVertexEntry(): Pointer;
  public
    constructor Create(); dynamic;
    destructor Destroy(); override;
    function Initialize(): Boolean;
    function Finalize(): Boolean;
    function Notify(Msg: Cardinal): Boolean;
    procedure Flush();

    function TextWidth(Str: WideString): Integer;
    function TextHeight(Str: WideString): Integer;
    procedure TextOut(x, Y: Integer; FColor: Integer; Str: WideString); overload;
    procedure TextOut(x, Y: Integer; Str: WideString; FColor: Cardinal); overload;
    procedure TextOut(x, Y: Integer; Str: WideString; FColor: Cardinal; Alpha: Byte); overload;
    procedure TextRect(Rect: TRect; Text: WideString; FColor: Cardinal; TextFormat: TTextFormat = []);

    procedure TexMap(Image: TDXTexture; const Points: TPoint4; const Colors: TColor4; const TexCoord: TTexCoord; DrawFx: Cardinal);
    procedure SetDrawFx(DrawFx: Cardinal);

    property Font: TDX9Font read FFont write FFont;
    procedure BufferQuad(const Quad: TPoint4; const Colors: TColor4; DrawFx: Cardinal);
    procedure BufferLine(const p0, p1: TPoint2; Color0, Color1: Longword; DrawFx: Cardinal);
  end;

  TDXDrawCanvas = class(TDXCanvas)
  private
    FLineX: Single;
    FLineY: Single;
  public
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent: Boolean); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent: Boolean; Color: TColor4); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal; Color: TColor4); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal; Color: TColor4; Mirror, Flip: Boolean); overload;

    procedure DrawTriangle(Position, X, Y: Integer; const TexCoord: TTexCoord; Source: TDXTexture; Colors, DrawFx:
      Cardinal);
    procedure DrawQuadrangle(Position, X, Y: Integer; const TexCoord: TTexCoord; Source: TDXTexture; Colors, DrawFx:
      Cardinal);
    procedure DrawPentagon(Position, X, Y: Integer; const TexCoord: TTexCoord; Source: TDXTexture; Colors, DrawFx:
      Cardinal);
    procedure DrawHexagon(Position, X, Y: Integer; const TexCoord: TTexCoord; Source: TDXTexture; Colors, DrawFx:
      Cardinal);
    procedure DrawHeptagon(Position, X, Y: Integer; const TexCoord: TTexCoord; Source: TDXTexture; Colors, DrawFx:
      Cardinal);

    procedure DrawSquareSchedule(Position, X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Colors, DrawFx:
      Cardinal);

    procedure StretchDraw(StretchRect, SrcRect: TRect; Source: TDXTexture; Transparent: Boolean); overload;
    procedure StretchDraw(StretchRect, SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal; Color: TColor4); overload;
    procedure StretchDraw(StretchRect, SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal; Color: TColor4; Mirror, Flip: Boolean); overload;

    procedure FillRect(Left, Top, Width, Height: Integer; Color: Cardinal); overload;
    procedure FillRect(const Rect: TRect; Colors: TColor4; DrawFx: Cardinal); overload;
    procedure FillRect(const Rect: TRect; Color: Cardinal; DrawFx: Cardinal); overload;

    procedure FillTriangle(r1, r2, r3: TPoint2; Colors, DrawFx: Cardinal);
    procedure FillQuadrangle(r1, r2, r3, r4: TPoint2; Colors, DrawFx: Cardinal);
    procedure FillPentagon(r1, r2, r3, r4, r5: TPoint2; Colors, DrawFx: Cardinal);
    procedure FillHexagon(r1, r2, r3, r4, r5, r6: TPoint2; Colors, DrawFx: Cardinal);
    procedure FillHeptagon(r1, r2, r3, r4, r5, r6, r7: TPoint2; Colors, DrawFx: Cardinal);

    procedure FillSquareSchedule(Position: Integer; Rect: TRect; Colors, DrawFx: Cardinal); overload;
    procedure FillSquareSchedule(Position, Left, Top, Width, Height: Integer; Colors, DrawFx: Cardinal); overload;

    procedure LineTo(x, y: Single; Color: Cardinal); overload;
    procedure MoveTo(x, y: Single);

    procedure RoundRect(left, Top, Right, Bottom, X, Y: Integer; Color: Cardinal); overload;
    procedure RoundRect(left, Top, Right, Bottom: Integer; Color: Cardinal); overload;
  end;

  TDXCanva = TDXDrawCanvas;

implementation

const
  VertexType = D3DFVF_XYZRHW or D3DFVF_DIFFUSE or D3DFVF_TEX1;

  { TDXCanvas }

procedure TDXCanvas.AddVIndex(Index: Integer);
var
  Entry: PWord;
begin
  Entry := Pointer(Integer(IndexArray) + (IndexAmount * SizeOf(Word)));
  Entry^ := Index;

  Inc(IndexAmount);
end;

function TDXCanvas.AllocateBuffers: Boolean;
begin
  Result := CreateVertexBuffer();
  if (Result) then
    Result := CreateIndexBuffer();

  VertexAmount := 0;
  IndexAmount := 0;
  PrimType := cptNone;
  Primitives := 0;

  CachedImage := nil;
  CachedDrawFx := High(Cardinal);
end;

function TDXCanvas.BufferDraw: Boolean;
var
  Primitive: TD3DPrimitiveType;
begin
  // (1) POINTS are rendered as Non-Indexed
  if (PrimType = cptPoints) then begin
    Result := Succeeded(Direct3DDevice.DrawPrimitive(D3DPT_POINTLIST, 0, Primitives));
    Exit;
  end;

  // (2) What primitives are we talking about?
  Primitive := D3DPT_TRIANGLELIST;
  if (PrimType = cptLines) then
    Primitive := D3DPT_LINELIST;

  // (3) Render INDEXED primitives.
  Result := Succeeded(Direct3DDevice.DrawIndexedPrimitive(Primitive, 0, 0, VertexAmount, 0, Primitives));
end;

procedure TDXCanvas.BufferLine(const p0, p1: TPoint2; Color0, Color1: Longword; DrawFx: Cardinal);
var
  Entry: PVertexRecord;
begin
  // (1) Validate cache.
  RequestCache(cptLines, 2, 2, nil, DrawFx);
  // (2) Add indices.
  AddVIndex(VertexAmount);
  AddVIndex(VertexAmount + 1);

  // (3) Add vertices.
  // -> 1st point
  Entry := NextVertexEntry();
  Entry.Vertex.x := p0.x;
  Entry.Vertex.y := p0.y;
  Entry.Color := Color0;
  Inc(VertexAmount);
  // -> 2nd point
  Entry := NextVertexEntry();
  Entry.Vertex.x := p1.x;
  Entry.Vertex.y := p1.y;
  Entry.Color := Color1;
  Inc(VertexAmount);

  Inc(Primitives);
end;

procedure TDXCanvas.BufferQuad(const Quad: TPoint4; const Colors: TColor4; DrawFx: Cardinal);
var
  Entry: PVertexRecord;
  Index: Integer;
begin
  // (1) Diffuse color used?
  if ((Colors[0] and Colors[1] and Colors[2] and Colors[3]) <> $FFFFFFFF) then
    DrawFx := DrawFx or $10000000;

  // (2) Validate cache.
  RequestCache(cptTriangles, 4, 6, nil, DrawFx);

  //VertexAmount := 0;
  //IndexAmount := 0;

  // (3) Add indices.
  AddVIndex(VertexAmount);
  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 3);
  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 2);
  AddVIndex(VertexAmount + 3);

  // (4) Add vertices.
  for Index := 0 to 3 do begin
    Entry := NextVertexEntry();
    Entry.Vertex.x := Quad[Index].x;
    Entry.Vertex.y := Quad[Index].y;
    Entry.Color := DisplaceRB(Colors[Index]);
    Inc(VertexAmount);
  end;

  Inc(Primitives, 2);
end;

procedure TDXCanvas.BufferTex(const Quad, TexCoord: TPoint4; const Colors: TColor4; Image: TDXTexture;
  DrawFx: Cardinal);
var
  Entry: PVertexRecord;
  Index: Integer;
begin
  // (1) Diffuse color used?
  if ((Colors[0] and Colors[1] and Colors[2] and Colors[3]) <> $FFFFFFFF) then
    DrawFx := DrawFx or $10000000;

  // (2) Validate cache.
  RequestCache(cptTriangles, 4, 6, Image, DrawFx);
  //VertexAmount := 0;
  //IndexAmount := 0;

  // (3) Add indices.
  AddVIndex(VertexAmount);
  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 3);
  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 2);
  AddVIndex(VertexAmount + 3);

  // (4) Add vertices.
  for Index := 0 to 3 do begin
    Entry := NextVertexEntry();

    Entry.Vertex.x := Quad[Index].x - 0.5;
    Entry.Vertex.y := Quad[Index].y - 0.5;
    Entry.Color := DisplaceRB(Colors[Index]);
    Entry.u := TexCoord[Index].x;
    Entry.v := TexCoord[Index].y;

    Inc(VertexAmount);
  end;

  // (5) Update primitive count.
  Inc(Primitives, 2);

  // (6) Update statitics.
  //Inc(FBufVertices, 4);
  //Inc(FBufIndices, 6);
end;

constructor TDXCanvas.Create;
begin
  inherited;
  Initialized := False;
  BuffersLost := False;
  FVertexCache := 32;
  FAntialias := True;
  FDithering := False;
  FAlphaTesting := True;
  FFont := nil;
end;

function TDXCanvas.CreateIndexBuffer: Boolean;
begin
  Result := Succeeded(Direct3DDevice.CreateIndexBuffer(FVertexCache *
    SizeOf(Word), D3DUSAGE_WRITEONLY or D3DUSAGE_DYNAMIC, D3DFMT_INDEX16,
    D3DPOOL_DEFAULT, IndexBuffer, nil));
end;

function TDXCanvas.CreateVertexBuffer: Boolean;
begin
  Result := Succeeded(Direct3DDevice.CreateVertexBuffer(FVertexCache *
    SizeOf(TVertexRecord), D3DUSAGE_WRITEONLY or D3DUSAGE_DYNAMIC, VertexType,
    D3DPOOL_DEFAULT, VertexBuffer, nil));
end;

destructor TDXCanvas.Destroy;
begin
  if (Initialized) then
    Finalize();
  inherited;
end;

function TDXCanvas.Finalize: Boolean;
begin
  ReleaseBuffers();

  if (VertexArray <> nil) then begin
    FreeMem(VertexArray);
    VertexArray := nil;
  end;

  if (IndexArray <> nil) then begin
    FreeMem(IndexArray);
    IndexArray := nil;
  end;

  Result := True;
  Initialized := False;
end;

procedure TDXCanvas.Flush;
begin
  if (Initialized) then begin
    ResetCache();
    AfterFlush := True;
  end;
end;

function TDXCanvas.Initialize: Boolean;
begin
  Result := not Initialized;

  if (Result) then
    Result := AllocateBuffers();

  if (Result) then begin
    VertexArray := AllocMem(FVertexCache * 2 * SizeOf(TVertexRecord));
    IndexArray := AllocMem(FVertexCache * 2 * SizeOf(Word));
    PrepareVertexArray();
  end;

  AfterFlush := True;
  Initialized := Result;
end;

function TDXCanvas.NextVertexEntry: Pointer;
begin
  Result := Pointer(Integer(VertexArray) + (VertexAmount * SizeOf(TVertexRecord)));
end;

function TDXCanvas.Notify(Msg: Cardinal): Boolean;
begin
  Result := True;

  case Msg of
    msgDeviceInitialize:
      Result := Initialize();

    msgDeviceFinalize:
      Result := Finalize();

    msgDeviceLost:
      if (Initialized) then begin
        ReleaseBuffers();
        BuffersLost := True;
      end;

    msgDeviceRecovered:
      if (Initialized) then begin
        if (not AllocateBuffers()) then
          Finalize();
        BuffersLost := False;
      end;

    msgEndScene, msgMultiCanvasBegin:
      Flush();
  end;
end;

function TDXCanvas.PrepareDraw: Boolean;
begin
  with Direct3DDevice do begin
    // (1) Use our vertex buffer for displaying primitives.
    Result := Succeeded(SetStreamSource(0, VertexBuffer, 0, SizeOf(TVertexRecord)));

    // (2) Use our index buffer to indicate the vertices of our primitives.
    if (Result) then
      Result := Succeeded(SetIndices(IndexBuffer));

    // (3) Disable vertex shader.
    if (Result) then
      Result := Succeeded(SetVertexShader(nil));

    // (4) Set the flexible vertex format of our vertex buffer.
    if (Result) then
      Result := Succeeded(SetFVF(VertexType));
  end;
end;

procedure TDXCanvas.PrepareVertexArray;
var
  Entry: PVertexRecord;
  Index: Integer;
begin
  Entry := VertexArray;
  for Index := 0 to FVertexCache - 1 do begin
    FillChar(Entry^, SizeOf(TVertexRecord), 0);

    Entry.Vertex.z := 0.0;
    Entry.rhw := 1.0;

    Inc(Entry);
  end;
end;

procedure TDXCanvas.ReleaseBuffers;
begin
  if (IndexBuffer <> nil) then
    IndexBuffer := nil;
  if (VertexBuffer <> nil) then
    VertexBuffer := nil;
end;

procedure TDXCanvas.RequestCache(PType: TPrimitiveType; Vertices, Indices: Integer; Image: TDXTexture;
  DrawFx: Cardinal);
begin
  // step 1. UnFlush, if needed
  if (AfterFlush) then
    UnFlush();

  // step 2. enough buffer space?
  if (VertexAmount + Vertices > FVertexCache) or
    (IndexAmount + Indices > FVertexCache) or ((PType <> PrimType) and (PrimType <> cptNone)) then
    ResetCache();

  // step 3. need to update DrawOp?
  if (DrawFx = High(Cardinal)) or (CachedDrawFx <> DrawFx) then begin
    ResetCache();
    SetDrawFx(DrawFx);
    CachedDrawFx := DrawFx;
  end;
  // step 4. need to update texture?
  if (CachedImage <> Image) { or ((Image <> nil) and Image.Dynamic) } then begin
    ResetCache();
    if (Image <> nil) then
      Image.Activate(0)
    else
      Direct3DDevice.SetTexture(0, nil);
    CachedImage := Image;
  end;

  // step 5. update cache type
  PrimType := PType;
end;

procedure TDXCanvas.ResetCache;
begin
  if (VertexAmount > 0) and (Primitives > 0) and (not BuffersLost) then begin
    if (UploadVertexBuffer()) and (UploadIndexBuffer()) and (PrepareDraw()) then
      BufferDraw();

    Inc(FCacheStall);
  end;

  // (2) Reset buffer info.
  VertexAmount := 0;
  IndexAmount := 0;
  PrimType := cptNone;
  Primitives := 0;
end;

procedure TDXCanvas.SetDrawFx(DrawFx: Cardinal);
const
  CoefD3D: array[TBlendCoef] of Cardinal = (D3DBLEND_ZERO, D3DBLEND_ONE, D3DBLEND_SRCCOLOR, D3DBLEND_INVSRCCOLOR,
    D3DBLEND_SRCALPHA, D3DBLEND_INVSRCALPHA, D3DBLEND_DESTALPHA, D3DBLEND_INVDESTALPHA, D3DBLEND_DESTCOLOR,
    D3DBLEND_INVDESTCOLOR, D3DBLEND_SRCALPHASAT, D3DBLEND_BOTHSRCALPHA, D3DBLEND_BOTHINVSRCALPHA, D3DBLEND_BLENDFACTOR,
    D3DBLEND_INVBLENDFACTOR);

  BlendOpD3D: array[TBlendOp] of Cardinal = (D3DBLENDOP_ADD, D3DBLENDOP_REVSUBTRACT, D3DBLENDOP_SUBTRACT,
    D3DBLENDOP_MIN, D3DBLENDOP_MAX);
var
  SrcCoef: TBlendCoef;
  DestCoef: TBlendCoef;
  BlendOp: TBlendOp;
begin
  if (Direct3DDevice = nil) then
    Exit;
  Fx2Blend(DrawFx, SrcCoef, DestCoef, BlendOp);

  with Direct3DDevice do begin
    if (SrcCoef <> bcOne) or (DestCoef <> bcZero) or (BlendOp <> boAdd) then begin
      SetRenderState(D3DRS_ALPHABLENDENABLE, iTrue);

      if (FAlphaTesting) then
        SetRenderState(D3DRS_ALPHATESTENABLE, iTrue);

      SetRenderState(D3DRS_SRCBLEND, CoefD3D[SrcCoef]);
      SetRenderState(D3DRS_DESTBLEND, CoefD3D[DestCoef]);
      SetRenderState(D3DRS_BLENDOP, BlendOpD3D[BlendOp]);
    end
    else begin
      SetRenderState(D3DRS_ALPHABLENDENABLE, iFalse);
      if (FAlphaTesting) then
        SetRenderState(D3DRS_ALPHATESTENABLE, iFalse);

    end;

    case DrawFx of
      $7FFFFFF0: {// fxAdd2x} begin
          SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
          SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
          SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE2X);
          SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
        end;

      $7FFFFFF1: {//  fxLight} begin
          SetRenderState(D3DRS_SRCBLEND, D3DBLEND_DESTCOLOR);
          SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
          SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE2X);
          SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
        end;

      $7FFFFFF2: {//  fxLightAdd} begin
          SetRenderState(D3DRS_SRCBLEND, D3DBLEND_DESTCOLOR);
          SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
          SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE4X);
          SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
        end;
      $7FFFFFF3: {//  fxBright} begin
          SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
          SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
          SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE2X);
          SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
        end;
      $7FFFFFF4: {//  fxBrightAdd} begin
          SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
          SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
          SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE4X);
          SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
        end;
      $7FFFFFF5: {//  fxGrayScale} begin
          SetRenderState(D3DRS_TextureFactor, $BBFFBBFF {Integer((RGB(255, 255, 155, 255)))});
          SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_DOTPRODUCT3);
          SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_TFACTOR);
        end;
      $7FFFFFF6: {//  fxOneColor} begin
          SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
          SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
          SetTextureStageState(0, D3DTSS_COLOROP, 25);
          SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
        end;
    else begin
        SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
        SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
      end;
    end;
  end;
end;

procedure TDXCanvas.TexMap(Image: TDXTexture; const Points: TPoint4; const Colors: TColor4;
  const TexCoord: TTexCoord; DrawFx: Cardinal);
var
  TexPts: TPoint4;
begin
  if BuffersLost or (not Image.Active) or (not Image.SelectTexture(TexCoord, TexPts)) then exit;

  BufferTex(Points, TexPts, Colors, Image, DrawFx);
end;

function TDXCanvas.TextHeight(Str: WideString): Integer;
begin
  Result := 12;
end;

procedure TDXCanvas.TextOut(x, Y: Integer; Str: WideString; FColor: Cardinal; Alpha: Byte);
var
  i: integer;
  sWord: Word;
  Texture: TDXTexture;
  AsciiRect: TRect;
  nWidth: Integer;
  TexCoord: TTexCoord;
  color4: TColor4;
begin
  if (FFont = nil) or (not FFont.boInitialize) then
    exit;
  nWidth := 0;
  Dec(X);
  Dec(Y);
  Color4 := cColor4((Alpha shl 24) or FColor);
  Texture := Font.DXTexture;
  if Texture = nil then
    exit;
  for I := 1 to Length(Str) do begin
    Move(Str[i], sWord, 2);
    AsciiRect := Font.AsciiRect[sWord];
    if (AsciiRect.Right > 4) then begin
      TexCoord.Mirror := False;
      TexCoord.Flip := False;
      TexCoord.x := AsciiRect.Left;
      TexCoord.y := AsciiRect.Top;
      TexCoord.w := AsciiRect.Right - AsciiRect.Left;
      TexCoord.h := AsciiRect.Bottom - AsciiRect.Top;
      TexMap(Texture, pBounds4(X + nWidth, Y, TexCoord.w, TexCoord.h), Color4, TexCoord, fxBlend);
      Inc(nWidth, TexCoord.w + Font.kerning);
    end;
  end;
end;

procedure TDXCanvas.TextOut(x, Y, FColor: Integer; Str: WideString);
begin
  if FFont = nil then
    exit;
  TextOut(X, Y, Str, FColor, 255);
end;

procedure TDXCanvas.TextRect(Rect: TRect; Text: WideString; FColor: Cardinal; TextFormat: TTextFormat = []);
var
  Color4: TColor4;
  nY, nX, I: Integer;
  Texture: TDXTexture;
  AsciiRect: TRect;
  nWidth, nHeight, FontWidth: Integer;
  TexCoord: TTexCoord;
  sWord: Word;

begin
  if Text = '' then
    exit;
  FontWidth := 0;
  Color4 := cColor4($FF000000 or FColor);

  nWidth := Rect.Right - Rect.Left;
  nHeight := Rect.Bottom - Rect.Top;
  if (nWidth <= 0) or (nHeight <= 0) then
    exit;
  nY := (nHeight - TextHeight('жа')) div 2;
  if nY < 0 then
    nY := 0;

  if tfRight in TextFormat then begin
    nX := Rect.Right;
    Texture := Font.DXTexture;
    if Texture = nil then
      exit;
    for I := Length(Text) downto 1 do begin
      if (FontWidth + Font.kerning) >= nWidth then
        break;
      Move(Text[i], sWord, 2);
      AsciiRect := Font.AsciiRect[sWord];
      if (AsciiRect.Right > 4) then begin
        TexCoord.Mirror := False;
        TexCoord.Flip := False;
        TexCoord.x := AsciiRect.Left;
        TexCoord.y := AsciiRect.Top;
        TexCoord.w := AsciiRect.Right - AsciiRect.Left;
        TexCoord.h := AsciiRect.Bottom - AsciiRect.Top;
        if (nY + TexCoord.h) > nHeight then begin
          TexCoord.h := nHeight - nY;
          if TexCoord.h <= 0 then
            Continue;
        end;
        if (FontWidth + TexCoord.w) > nWidth then begin
          TexCoord.x := TexCoord.x + (TexCoord.w) - (nWidth - FontWidth);
          TexCoord.w := nWidth - FontWidth;
        end;
        TexMap(Texture, pBounds4(nX - FontWidth - TexCoord.w, nY + Rect.Top, TexCoord.w, TexCoord.h), Color4, TexCoord,
          fxBlend);
        Inc(FontWidth, TexCoord.w + Font.kerning);
      end;
    end;
  end
  else if tfCenter in TextFormat then begin

  end
  else begin
    nX := Rect.Left;
    Texture := Font.DXTexture;
    if Texture = nil then
      exit;
    for I := 1 to Length(Text) do begin
      if (FontWidth + Font.kerning) >= nWidth then
        break;
      Move(Text[i], sWord, 2);
      AsciiRect := Font.AsciiRect[sWord];
      if (AsciiRect.Right > 4) then begin
        TexCoord.Mirror := False;
        TexCoord.Flip := False;
        TexCoord.x := AsciiRect.Left;
        TexCoord.y := AsciiRect.Top;
        TexCoord.w := AsciiRect.Right - AsciiRect.Left;
        TexCoord.h := AsciiRect.Bottom - AsciiRect.Top;
        if (nY + TexCoord.h) > nHeight then begin
          TexCoord.h := nHeight - nY;
          if TexCoord.h <= 0 then
            Continue;
        end;
        if (FontWidth + TexCoord.w) > nWidth then begin
          TexCoord.w := nWidth - FontWidth;
        end;
        TexMap(Texture, pBounds4(nX + FontWidth, nY + Rect.Top, TexCoord.w, TexCoord.h), Color4, TexCoord, fxBlend);
        Inc(FontWidth, TexCoord.w + Font.kerning);
      end;
    end;
  end;
end;

procedure TDXCanvas.TextOut(x, Y: Integer; Str: WideString; FColor: Cardinal);
begin
  if FFont = nil then
    exit;
  TextOut(X, Y, Str, FColor, 255);
end;

function TDXCanvas.TextWidth(Str: WideString): Integer;
var
  sWord: Word;
  I: Integer;
begin
  Result := 0;
  if FFont <> nil then
    for I := 1 to Length(Str) do begin
      Move(Str[I], sWord, 2);
      if Font.AsciiRect[sWord].Right > 0 then
        Inc(Result, Font.AsciiRect[sWord].Right - Font.AsciiRect[sWord].Left + Font.kerning);
    end;
  {Result := Result - Font.kerning;
  if Result < 0 then
    Result := 0; }
end;

procedure TDXCanvas.UnFlush;
{var
 i: Integer;  }
begin
  if (Direct3DDevice = nil) or (not Initialized) then
    Exit;

  VertexAmount := 0;
  IndexAmount := 0;
  PrimType := cptNone;
  Primitives := 0;

  CachedImage := nil;
  CachedDrawFx := High(Cardinal);

  with Direct3DDevice do begin
    //========================================================================
    // In the following code, we try to disable any Direct3D states that might
    // affect or disrupt our behavior.
    //========================================================================
    SetRenderState(D3DRS_LIGHTING, iFalse);
    SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE);
    SetRenderState(D3DRS_ZENABLE, D3DZB_FALSE);
    SetRenderState(D3DRS_FOGENABLE, iFalse);

    SetRenderState(D3DRS_ALPHAFUNC, D3DCMP_GREATEREQUAL);
    SetRenderState(D3DRS_ALPHAREF, $00000001);
    SetRenderState(D3DRS_ALPHATESTENABLE, iFalse);

    //for i:= 0 to 7 do
     //begin
    SetTextureStageState(0 {i}, D3DTSS_TEXCOORDINDEX, 0);
    SetTextureStageState(0 {i}, D3DTSS_TEXTURETRANSFORMFLAGS, D3DTTFF_DISABLE);

    SetTexture(0 {i}, nil);

    SetTextureStageState(0 {i}, D3DTSS_COLORARG1, D3DTA_TEXTURE);
    SetTextureStageState(0 {i}, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);

    SetTextureStageState(0 {i}, D3DTSS_COLORARG2, D3DTA_DIFFUSE);
    SetTextureStageState(0 {i}, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);
    //end;

   //==========================================================================
   // Update user-specified states.
   //==========================================================================
    SetRenderState(D3DRS_DITHERENABLE, Cardinal(FDithering));

    if (FAntialias) then begin
      SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
      SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
    end
    else begin
      SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_POINT);
      SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_POINT);
    end;
  end;

  AfterFlush := False;
  FCacheStall := 0;
  //FBufVertices:= 0;
  //FBufIndices := 0;
end;

function TDXCanvas.UploadIndexBuffer: Boolean;
var
  MemAddr: Pointer;
  BufSize: Integer;
begin
  BufSize := IndexAmount * SizeOf(Word);
  Result := Succeeded(IndexBuffer.Lock(0, BufSize, MemAddr, D3DLOCK_DISCARD));

  if (Result) then begin
    Move(IndexArray^, MemAddr^, BufSize);
    Result := Succeeded(IndexBuffer.Unlock());
  end;
end;

function TDXCanvas.UploadVertexBuffer: Boolean;
var
  MemAddr: Pointer;
  BufSize: Integer;
begin
  BufSize := VertexAmount * SizeOf(TVertexRecord);
  Result := Succeeded(VertexBuffer.Lock(0, BufSize, MemAddr, D3DLOCK_DISCARD));

  if (Result) then begin
    Move(VertexArray^, MemAddr^, BufSize);
    Result := Succeeded(VertexBuffer.Unlock());
  end;
end;

{ TDXDrawCanvas }

procedure TDXDrawCanvas.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent: Boolean);
begin
  if Transparent then
    Draw(X, Y, SrcRect, Source, fxBlend, clWhite4)
  else
    Draw(X, Y, SrcRect, Source, fxNone, clWhite4);
end;

procedure TDXDrawCanvas.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent: Boolean; Color: TColor4);
begin
  if Transparent then
    Draw(X, Y, SrcRect, Source, fxBlend, Color)
  else
    Draw(X, Y, SrcRect, Source, fxNone, Color);
end;

procedure TDXDrawCanvas.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal);
begin
  Draw(X, Y, SrcRect, Source, DrawFx, clWhite4);
end;

procedure TDXDrawCanvas.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal; Color: TColor4);
var
  TexCoord: TTexCoord;
begin
  if Source = nil then
    exit;
  TexCoord.Mirror := False;
  TexCoord.Flip := False;
  TexCoord.x := SrcRect.Left;
  TexCoord.y := SrcRect.Top;
  TexCoord.w := SrcRect.Right - SrcRect.Left;
  TexCoord.h := SrcRect.Bottom - SrcRect.Top;
  if TexCoord.x < 0 then begin
    TexCoord.x := 0;
  end;
  if TexCoord.y < 0 then begin
    TexCoord.y := 0;
  end;
  if (TexCoord.w + TexCoord.x) > Source.Width then
    TexCoord.w := Source.Width - TexCoord.x;
  if (TexCoord.h + TexCoord.y) > Source.Height then
    TexCoord.h := Source.Height - TexCoord.y;
  if Source.Width <= TexCoord.X then
    exit;
  if Source.Height <= TexCoord.Y then
    exit;
  TexMap(Source, pBounds4(X, Y, TexCoord.w, TexCoord.h), Color, TexCoord, DrawFx);
end;

procedure TDXDrawCanvas.DrawHeptagon(Position, X, Y: Integer; const TexCoord: TTexCoord; Source: TDXTexture; Colors,
  DrawFx: Cardinal);
var
  nMidX, nMidY: Integer;
  Entry: PVertexRecord;
begin
  if BuffersLost or (not Source.Active) then
    exit;

  nMidX := TexCoord.w div 2;
  nMidY := TexCoord.h div 2;

  if (Colors <> $FFFFFFFF) then
    DrawFx := DrawFx or $10000000;

  RequestCache(cptTriangles, 7, 15, Source, DrawFx);

  AddVIndex(VertexAmount);
  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 2);

  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 2);
  AddVIndex(VertexAmount + 3);
  
  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 3);
  AddVIndex(VertexAmount + 4);

  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 4);
  AddVIndex(VertexAmount + 5);

  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 5);
  AddVIndex(VertexAmount + 6);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + (TexCoord.w - nMidX)) - 0.5;
  Entry.Vertex.y := Y - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + (TexCoord.w - nMidX)) / Source.Size.X;
  Entry.v := TexCoord.Y / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + (TexCoord.w - nMidX)) - 0.5;
  Entry.Vertex.y := (Y + (TexCoord.h - nMidY)) - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + (TexCoord.w - nMidX)) / Source.Size.X;
  Entry.v := (TexCoord.Y + (TexCoord.h - nMidY)) / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + TexCoord.w) - 0.5;
  Entry.Vertex.y := Y - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + TexCoord.w) / Source.Size.X;
  Entry.v := TexCoord.Y / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + TexCoord.w) - 0.5;
  Entry.Vertex.y := (Y + TexCoord.h) - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + TexCoord.w) / Source.Size.X;
  Entry.v := (TexCoord.Y + TexCoord.h) / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := X - 0.5;
  Entry.Vertex.y := (Y + TexCoord.h) - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := TexCoord.X / Source.Size.X;
  Entry.v := (TexCoord.Y + TexCoord.h) / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := X - 0.5;
  Entry.Vertex.y := Y - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := TexCoord.X / Source.Size.X;
  Entry.v := TexCoord.Y / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + Position) - 0.5;
  Entry.Vertex.y := Y - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + Position) / Source.Size.X;
  Entry.v := TexCoord.Y / Source.Size.Y;
  Inc(VertexAmount);

  Inc(Primitives, 5);
end;

procedure TDXDrawCanvas.DrawHexagon(Position, X, Y: Integer; const TexCoord: TTexCoord; Source: TDXTexture; Colors,
  DrawFx: Cardinal);
var
  nMidX, nMidY: Integer;
  Entry: PVertexRecord;
begin
  if BuffersLost or (not Source.Active) then
    exit;

  nMidX := TexCoord.w div 2;
  nMidY := TexCoord.h div 2;

  if (Colors <> $FFFFFFFF) then
    DrawFx := DrawFx or $10000000;

  RequestCache(cptTriangles, 6, 12, Source, DrawFx);

  AddVIndex(VertexAmount);
  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 2);

  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 2);
  AddVIndex(VertexAmount + 3);
  
  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 3);
  AddVIndex(VertexAmount + 4);

  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 4);
  AddVIndex(VertexAmount + 5);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + (TexCoord.w - nMidX)) - 0.5;
  Entry.Vertex.y := Y - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + (TexCoord.w - nMidX)) / Source.Size.X;
  Entry.v := TexCoord.Y / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + (TexCoord.w - nMidX)) - 0.5;
  Entry.Vertex.y := (Y + (TexCoord.h - nMidY)) - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + (TexCoord.w - nMidX)) / Source.Size.X;
  Entry.v := (TexCoord.Y + (TexCoord.h - nMidY)) / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + TexCoord.w) - 0.5;
  Entry.Vertex.y := Y - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + TexCoord.w) / Source.Size.X;
  Entry.v := TexCoord.Y / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + TexCoord.w) - 0.5;
  Entry.Vertex.y := (Y + TexCoord.h) - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + TexCoord.w) / Source.Size.X;
  Entry.v := (TexCoord.Y + TexCoord.h) / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := X - 0.5;
  Entry.Vertex.y := (Y + TexCoord.h) - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := TexCoord.X / Source.Size.X;
  Entry.v := (TexCoord.Y + TexCoord.h) / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := X - 0.5;
  Entry.Vertex.y := (Y + (TexCoord.h - Position)) - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := TexCoord.X / Source.Size.X;
  Entry.v := (TexCoord.Y + (TexCoord.h - Position)) / Source.Size.Y;
  Inc(VertexAmount);

  Inc(Primitives, 4);
end;

procedure TDXDrawCanvas.DrawPentagon(Position, X, Y: Integer; const TexCoord: TTexCoord; Source: TDXTexture; Colors,
  DrawFx: Cardinal);
var
  nMidX, nMidY: Integer;
  Entry: PVertexRecord;
begin
  if BuffersLost or (not Source.Active) then
    exit;

  nMidX := TexCoord.w div 2;
  nMidY := TexCoord.h div 2;

  if (Colors <> $FFFFFFFF) then
    DrawFx := DrawFx or $10000000;

  RequestCache(cptTriangles, 5, 9, Source, DrawFx);

  AddVIndex(VertexAmount);
  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 2);

  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 2);
  AddVIndex(VertexAmount + 3);
  
  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 3);
  AddVIndex(VertexAmount + 4);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + (TexCoord.w - nMidX)) - 0.5;
  Entry.Vertex.y := Y - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + (TexCoord.w - nMidX)) / Source.Size.X;
  Entry.v := TexCoord.Y / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + (TexCoord.w - nMidX)) - 0.5;
  Entry.Vertex.y := (Y + (TexCoord.h - nMidY)) - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + (TexCoord.w - nMidX)) / Source.Size.X;
  Entry.v := (TexCoord.Y + (TexCoord.h - nMidY)) / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + TexCoord.w) - 0.5;
  Entry.Vertex.y := Y - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + TexCoord.w) / Source.Size.X;
  Entry.v := TexCoord.Y / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + TexCoord.w) - 0.5;
  Entry.Vertex.y := (Y + TexCoord.h) - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + TexCoord.w) / Source.Size.X;
  Entry.v := (TexCoord.Y + TexCoord.h) / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + (TexCoord.w - Position)) - 0.5;
  Entry.Vertex.y := (Y + TexCoord.h) - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + (TexCoord.w - Position)) / Source.Size.X;
  Entry.v := (TexCoord.Y + TexCoord.h) / Source.Size.Y;
  Inc(VertexAmount);

  Inc(Primitives, 3);
end;

procedure TDXDrawCanvas.DrawQuadrangle(Position, X, Y: Integer; const TexCoord: TTexCoord; Source: TDXTexture; Colors,
  DrawFx: Cardinal);
var
  nMidX, nMidY: Integer;
  Entry: PVertexRecord;
begin
  if BuffersLost or (not Source.Active) then
    exit;

  nMidX := TexCoord.w div 2;
  nMidY := TexCoord.h div 2;

  if (Colors <> $FFFFFFFF) then
    DrawFx := DrawFx or $10000000;

  RequestCache(cptTriangles, 4, 6, Source, DrawFx);

  AddVIndex(VertexAmount);
  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 2);

  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 2);
  AddVIndex(VertexAmount + 3);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + (TexCoord.w - nMidX)) - 0.5;
  Entry.Vertex.y := Y - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + (TexCoord.w - nMidX)) / Source.Size.X;
  Entry.v := TexCoord.Y / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + (TexCoord.w - nMidX)) - 0.5;
  Entry.Vertex.y := (Y + (TexCoord.h - nMidY)) - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + (TexCoord.w - nMidX)) / Source.Size.X;
  Entry.v := (TexCoord.Y + (TexCoord.h - nMidY)) / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + TexCoord.w) - 0.5;
  Entry.Vertex.y := Y - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + TexCoord.w) / Source.Size.X;
  Entry.v := TexCoord.Y / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + TexCoord.w) - 0.5;
  Entry.Vertex.y := (Y + Position) - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + TexCoord.w) / Source.Size.X;
  Entry.v := (TexCoord.Y + Position) / Source.Size.Y;
  Inc(VertexAmount);

  Inc(Primitives, 2);
end;

procedure TDXDrawCanvas.DrawSquareSchedule(Position, X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Colors,
  DrawFx: Cardinal);
var
  TexCoord: TTexCoord;
  nMidX {, nMidY}: Integer;
begin
  if Source = nil then
    exit;
  TexCoord.Mirror := False;
  TexCoord.Flip := False;
  TexCoord.x := SrcRect.Left;
  TexCoord.y := SrcRect.Top;
  TexCoord.w := SrcRect.Right - SrcRect.Left;
  TexCoord.h := SrcRect.Bottom - SrcRect.Top;
  if TexCoord.x < 0 then begin
    TexCoord.x := 0;
  end;
  if TexCoord.y < 0 then begin
    TexCoord.y := 0;
  end;
  if (TexCoord.w + TexCoord.x) > Source.Width then
    TexCoord.w := Source.Width - TexCoord.x;
  if (TexCoord.h + TexCoord.y) > Source.Height then
    TexCoord.h := Source.Height - TexCoord.y;
  if Source.Width <= TexCoord.X then
    exit;
  if Source.Height <= TexCoord.Y then
    exit;

  nMidX := TexCoord.w div 2;
  //nMidY := TexCoord.h div 2;
  case Position of
    1..12: begin
        DrawTriangle(Round(nMidX / (12 / Position)), X, Y, TexCoord, Source, Colors, DrawFx);
      end;
    13..37: begin
        DrawQuadrangle(Round(TexCoord.h / ((37 - 12) / (Position - 12))),
          X, Y, TexCoord, Source, Colors, DrawFx);
      end;
    38..62: begin
        DrawPentagon(Round(TexCoord.w / ((62 - 37) / (Position - 37))),
          X, Y, TexCoord, Source, Colors, DrawFx);
      end;
    63..87: begin
        DrawHexagon(Round(TexCoord.h / ((87 - 62) / (Position - 62))),
          X, Y, TexCoord, Source, Colors, DrawFx);
      end;
    88..99: begin
        DrawHeptagon(Round((TexCoord.w - nMidX) / ((99 - 87) / (Position - 87))),
          X, Y, TexCoord, Source, Colors, DrawFx);

      end;
    100: begin
        TexMap(Source, pBounds4(X, Y, TexCoord.w, TexCoord.h), cColor4(Colors), TexCoord, DrawFx);
      end;
  end;
end;

procedure TDXDrawCanvas.DrawTriangle(Position, X, Y: Integer; const TexCoord: TTexCoord; Source: TDXTexture; Colors,
  DrawFx: Cardinal);
var
  nMidX, nMidY: Integer;
  Entry: PVertexRecord;
begin
  if BuffersLost or (not Source.Active) then
    exit;

  nMidX := TexCoord.w div 2;
  nMidY := TexCoord.h div 2;

  if (Colors <> $FFFFFFFF) then
    DrawFx := DrawFx or $10000000;

  RequestCache(cptTriangles, 3, 3, Source, DrawFx);

  AddVIndex(VertexAmount);
  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 2);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + (TexCoord.w - nMidX)) - 0.5;
  Entry.Vertex.y := Y - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + (TexCoord.w - nMidX)) / Source.Size.X;
  Entry.v := TexCoord.Y / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + (TexCoord.w - nMidX)) - 0.5;
  Entry.Vertex.y := (Y + (TexCoord.h - nMidY)) - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + (TexCoord.w - nMidX)) / Source.Size.X;
  Entry.v := (TexCoord.Y + (TexCoord.h - nMidY)) / Source.Size.Y;
  Inc(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := (X + (TexCoord.w - nMidX) + Position) - 0.5;
  Entry.Vertex.y := Y - 0.5;
  Entry.Color := DisplaceRB(Colors);
  Entry.u := (TexCoord.X + (TexCoord.w - nMidX) + Position) / Source.Size.X;
  Entry.v := TexCoord.Y / Source.Size.Y;
  Inc(VertexAmount);

  Inc(Primitives, 1);
end;

procedure TDXDrawCanvas.FillRect(Left, Top, Width, Height: Integer; Color: Cardinal);
begin
  FillRect(Rect(Left, Top, Left + Width, Top + Height), cColor4(Color), fxBlend);
end;

procedure TDXDrawCanvas.FillRect(const Rect: TRect; Colors: TColor4; DrawFx: Cardinal);
begin
  BufferQuad(pRect4(Rect), Colors, DrawFx);
end;

procedure TDXDrawCanvas.FillHeptagon(r1, r2, r3, r4, r5, r6, r7: TPoint2; Colors, DrawFx: Cardinal);
var
  Entry: PVertexRecord;
begin
  // (1) Diffuse color used?
  if (Colors <> $FFFFFFFF) then
    DrawFx := DrawFx or $10000000;

  // (2) Validate cache.
  RequestCache(cptTriangles, 7, 15, nil, DrawFx);

  // (3) Add indices.
  AddVIndex(VertexAmount);
  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 2);

  AddVIndex(VertexAmount + 2);
  AddVIndex(VertexAmount + 3);
  AddVIndex(VertexAmount + 4);

  AddVIndex(VertexAmount + 2);
  AddVIndex(VertexAmount + 4);
  AddVIndex(VertexAmount + 5);

  AddVIndex(VertexAmount + 2);
  AddVIndex(VertexAmount + 5);
  AddVIndex(VertexAmount + 6);

  AddVIndex(VertexAmount + 2);
  AddVIndex(VertexAmount + 6);
  AddVIndex(VertexAmount);

  Entry := NextVertexEntry();
  Entry.Vertex.x := r1.x;
  Entry.Vertex.y := r1.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r2.x;
  Entry.Vertex.y := r2.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r3.x;
  Entry.Vertex.y := r3.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r4.x;
  Entry.Vertex.y := r4.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r5.x;
  Entry.Vertex.y := r5.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r6.x;
  Entry.Vertex.y := r6.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r7.x;
  Entry.Vertex.y := r7.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);

  Inc(Primitives, 5);
end;

procedure TDXDrawCanvas.FillHexagon(r1, r2, r3, r4, r5, r6: TPoint2; Colors, DrawFx: Cardinal);
var
  Entry: PVertexRecord;
begin
  // (1) Diffuse color used?
  if (Colors <> $FFFFFFFF) then
    DrawFx := DrawFx or $10000000;

  // (2) Validate cache.
  RequestCache(cptTriangles, 6, 12, nil, DrawFx);

  // (3) Add indices.
  AddVIndex(VertexAmount);
  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 2);

  AddVIndex(VertexAmount + 2);
  AddVIndex(VertexAmount + 3);
  AddVIndex(VertexAmount + 4);

  AddVIndex(VertexAmount + 2);
  AddVIndex(VertexAmount + 4);
  AddVIndex(VertexAmount + 5);

  AddVIndex(VertexAmount + 2);
  AddVIndex(VertexAmount + 5);
  AddVIndex(VertexAmount + 0);

  Entry := NextVertexEntry();
  Entry.Vertex.x := r1.x;
  Entry.Vertex.y := r1.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r2.x;
  Entry.Vertex.y := r2.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r3.x;
  Entry.Vertex.y := r3.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r4.x;
  Entry.Vertex.y := r4.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r5.x;
  Entry.Vertex.y := r5.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r6.x;
  Entry.Vertex.y := r6.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);

  Inc(Primitives, 4);
end;

procedure TDXDrawCanvas.FillPentagon(r1, r2, r3, r4, r5: TPoint2; Colors, DrawFx: Cardinal);
var
  Entry: PVertexRecord;
begin
  // (1) Diffuse color used?
  if (Colors <> $FFFFFFFF) then
    DrawFx := DrawFx or $10000000;

  // (2) Validate cache.
  RequestCache(cptTriangles, 5, 9, nil, DrawFx);

  // (3) Add indices.
  AddVIndex(VertexAmount);
  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 2);

  AddVIndex(VertexAmount + 2);
  AddVIndex(VertexAmount + 3);
  AddVIndex(VertexAmount + 4);

  AddVIndex(VertexAmount + 2);
  AddVIndex(VertexAmount + 4);
  AddVIndex(VertexAmount + 0);

  Entry := NextVertexEntry();
  Entry.Vertex.x := r1.x;
  Entry.Vertex.y := r1.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r2.x;
  Entry.Vertex.y := r2.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r3.x;
  Entry.Vertex.y := r3.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r4.x;
  Entry.Vertex.y := r4.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r5.x;
  Entry.Vertex.y := r5.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);

  Inc(Primitives, 3);
end;

procedure TDXDrawCanvas.FillQuadrangle(r1, r2, r3, r4: TPoint2; Colors, DrawFx: Cardinal);
var
  Entry: PVertexRecord;
begin
  // (1) Diffuse color used?
  if (Colors <> $FFFFFFFF) then
    DrawFx := DrawFx or $10000000;

  // (2) Validate cache.
  RequestCache(cptTriangles, 4, 6, nil, DrawFx);

  // (3) Add indices.
  AddVIndex(VertexAmount);
  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 2);

  AddVIndex(VertexAmount + 2);
  AddVIndex(VertexAmount + 3);
  AddVIndex(VertexAmount + 0);

  Entry := NextVertexEntry();
  Entry.Vertex.x := r1.x;
  Entry.Vertex.y := r1.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r2.x;
  Entry.Vertex.y := r2.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r3.x;
  Entry.Vertex.y := r3.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r4.x;
  Entry.Vertex.y := r4.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);

  Inc(Primitives, 2);
end;

procedure TDXDrawCanvas.FillTriangle(r1, r2, r3: TPoint2; Colors, DrawFx: Cardinal);
var
  Entry: PVertexRecord;
begin
  // (1) Diffuse color used?
  if (Colors <> $FFFFFFFF) then
    DrawFx := DrawFx or $10000000;

  // (2) Validate cache.
  RequestCache(cptTriangles, 3, 3, nil, DrawFx);

  // (3) Add indices.
  AddVIndex(VertexAmount);
  AddVIndex(VertexAmount + 1);
  AddVIndex(VertexAmount + 2);

  Entry := NextVertexEntry();
  Entry.Vertex.x := r1.x;
  Entry.Vertex.y := r1.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r2.x;
  Entry.Vertex.y := r2.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);
  Entry := NextVertexEntry();
  Entry.Vertex.x := r3.x;
  Entry.Vertex.y := r3.y;
  Entry.Color := DisplaceRB(Colors);
  Inc(VertexAmount);

  Inc(Primitives, 1);
end;

procedure TDXDrawCanvas.FillRect(const Rect: TRect; Color, DrawFx: Cardinal);
begin
  FillRect(Rect, cColor4(Color), DrawFx);
end;

procedure TDXDrawCanvas.FillSquareSchedule(Position, Left, Top, Width, Height: Integer; Colors, DrawFx: Cardinal);
begin
  FillSquareSchedule(Position, Rect(Left, Top, Width, Height), Colors, DrawFx);
end;

procedure TDXDrawCanvas.FillSquareSchedule(Position: Integer; Rect: TRect; Colors, DrawFx: Cardinal);
var
  nMidX, nMidY: Integer;
begin
  nMidX := (Rect.Right - Rect.Left) div 2;
  nMidY := (Rect.Bottom - Rect.Top) div 2;
  case Position of
    0: FillRect(Rect, Colors, DrawFx);
    1..12: begin
        FillHeptagon(
          Point2(Rect.Left, Rect.Top),
          Point2(Rect.Left + nMidX, Rect.Top),
          Point2(Rect.Left + nMidX, Rect.Top + nMidY),
          Point2(Rect.Left + nMidX + Round(nMidX / (12 / Position)), Rect.Top),
          Point2(Rect.Right, Rect.Top),
          Point2(Rect.Right, Rect.Bottom),
          Point2(Rect.Left, Rect.Bottom),
          Colors, DrawFx);
      end;
    13..37: begin
        FillHexagon(
          Point2(Rect.Left, Rect.Top),
          Point2(Rect.Left + nMidX, Rect.Top),
          Point2(Rect.Left + nMidX, Rect.Top + nMidY),
          Point2(Rect.Right, Rect.Top + Round((Rect.Bottom - Rect.Top) / ((37 - 12) / (Position - 12)))),
          Point2(Rect.Right, Rect.Bottom),
          Point2(Rect.Left, Rect.Bottom),
          Colors, DrawFx);
      end;
    38..62: begin
        FillPentagon(
          Point2(Rect.Left, Rect.Top),
          Point2(Rect.Left + nMidX, Rect.Top),
          Point2(Rect.Left + nMidX, Rect.Top + nMidY),
          Point2(Rect.Right - Round((Rect.Right - Rect.Left) / ((62 - 37) / (Position - 37))), Rect.Bottom),
          Point2(Rect.Left, Rect.Bottom),
          Colors, DrawFx);
      end;
    63..87: begin
        FillQuadrangle(
          Point2(Rect.Left, Rect.Top),
          Point2(Rect.Left + nMidX, Rect.Top),
          Point2(Rect.Left + nMidX, Rect.Top + nMidY),
          Point2(Rect.Left, Rect.Bottom - Round((Rect.Bottom - Rect.Top) / ((87 - 62) / (Position - 62)))),
          Colors, DrawFx);
      end;
    88..99: begin
        FillTriangle(
          Point2(Rect.Left + Round(nMidX / ((99 - 87) / (Position - 87))), Rect.Top),
          Point2(Rect.Left + nMidX, Rect.Top),
          Point2(Rect.Left + nMidX, Rect.Top + nMidY),
          Colors, DrawFx);
      end;
  end;
end;

procedure TDXDrawCanvas.LineTo(x, y: Single; Color: Cardinal);
var
  nColor: Cardinal;
begin
  if (X = FLineX) and (Y = FLineY) then
    exit;
  nColor := DisplaceRB(Color) or $FF000000;
  BufferLine(Point2(FLineX, FLIneY), Point2(x, y), nColor, nColor, fxBlend);
  FLineX := X;
  FLIneY := Y;
end;

procedure TDXDrawCanvas.MoveTo(x, y: Single);
begin
  FLineX := X;
  FLIneY := Y;
end;

procedure TDXDrawCanvas.RoundRect(left, Top, Right, Bottom, X, Y: Integer; Color: Cardinal);
begin
  X := X div 2;
  Y := Y div 2;
  MoveTo(Left, Top + Y);
  LineTo(Left, Bottom - Y, Color);
  LineTo(Left + X, Bottom, Color);
  LineTo(Right - X, Bottom, Color);
  LineTo(Right, Bottom - Y, Color);
  LineTo(Right, Top + Y, Color);
  LineTo(Right - X, Top, Color);
  LineTo(Left + X, Top, Color);
  LineTo(Left, Top + Y, Color);
end;

procedure TDXDrawCanvas.RoundRect(left, Top, Right, Bottom: Integer; Color: Cardinal);
begin
  MoveTo(Left, Top);
  LineTo(Left, Bottom - 1, Color);
  LineTo(Right - 1, Bottom - 1, Color);
  LineTo(Right - 1, Top, Color);
  LineTo(Left, Top, Color);
end;

procedure TDXDrawCanvas.StretchDraw(StretchRect, SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal; Color: TColor4;
  Mirror, Flip: Boolean);
var
  TexCoord: TTexCoord;
begin
  TexCoord.Mirror := Mirror;
  TexCoord.Flip := Flip;
  TexCoord.x := SrcRect.Left;
  TexCoord.y := SrcRect.Top;
  TexCoord.w := SrcRect.Right - SrcRect.Left;
  TexCoord.h := SrcRect.Bottom - SrcRect.Top;
  TexMap(Source, pBounds4(StretchRect.Left, StretchRect.Top,
    StretchRect.Right - StretchRect.Left, StretchRect.Bottom - StretchRect.Top), Color, TexCoord, DrawFx);
end;

procedure TDXDrawCanvas.StretchDraw(StretchRect, SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal; Color: TColor4);
var
  TexCoord: TTexCoord;
begin
  TexCoord.Mirror := False;
  TexCoord.Flip := False;
  TexCoord.x := SrcRect.Left;
  TexCoord.y := SrcRect.Top;
  TexCoord.w := SrcRect.Right - SrcRect.Left;
  TexCoord.h := SrcRect.Bottom - SrcRect.Top;
  TexMap(Source, pBounds4(StretchRect.Left, StretchRect.Top,
    StretchRect.Right - StretchRect.Left, StretchRect.Bottom - StretchRect.Top), Color, TexCoord, DrawFx)
end;

procedure TDXDrawCanvas.StretchDraw(StretchRect, SrcRect: TRect; Source: TDXTexture; Transparent: Boolean);
begin
  if Transparent then
    StretchDraw(StretchRect, SrcRect, Source, fxBlend, clWhite4)
  else
    StretchDraw(StretchRect, SrcRect, Source, fxNone, clWhite4);
end;

procedure TDXDrawCanvas.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal; Color: TColor4;
  Mirror, Flip: Boolean);
var
  TexCoord: TTexCoord;
begin
  if Source = nil then
    exit;
  TexCoord.Mirror := Mirror;
  TexCoord.Flip := Flip;
  TexCoord.x := SrcRect.Left;
  TexCoord.y := SrcRect.Top;
  TexCoord.w := SrcRect.Right - SrcRect.Left;
  TexCoord.h := SrcRect.Bottom - SrcRect.Top;
  if TexCoord.x < 0 then begin
    TexCoord.x := 0;
  end;
  if TexCoord.y < 0 then begin
    TexCoord.y := 0;
  end;
  if (TexCoord.w + TexCoord.x) > Source.Width then
    TexCoord.w := Source.Width - TexCoord.x;
  if (TexCoord.h + TexCoord.y) > Source.Height then
    TexCoord.h := Source.Height - TexCoord.y;
  if Source.Width <= TexCoord.X then
    exit;
  if Source.Height <= TexCoord.Y then
    exit;
  TexMap(Source, pBounds4(X, Y, TexCoord.w, TexCoord.h), Color, TexCoord, DrawFx);
end;

end.

