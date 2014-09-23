unit HGECanvas;

interface

uses
  Windows, Graphics, DirectXGraphics, HGEBase, HGE, HGETextures, HGEFonts;

//const
//  cRect: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);

const
  bTransparent: array[Boolean] of Integer = (fxNone, fxBlend);

type
  TDXCanvas = class
  private
    FWidth, FHeight: Single;
    FTexWidth, FTexHeight: Integer;
    FFont: TDXFont;
    FDrawTexture: TDXTexture;
    procedure SetColor(Color: Cardinal); overload;
    procedure SetColor(Color1, Color2, Color3, Color4: Cardinal); overload;
    procedure SetPattern(Texture: ITexture; Rect: TRect);
    procedure SetMirror(MirrorX, MirrorY: Boolean);
  public
    constructor Create(Font: TDXFont); dynamic;
    destructor Destroy; override;

    procedure Draw(Texture: TDXTexture; X, Y: Integer; BlendMode: Integer; Color: LongWord = $FFFFFFFF; MirrorX: Boolean = False; MirrorY: Boolean = False);

    procedure DrawRect(Texture: TDXTexture; X, Y, Left, Top, Right, Bottom: Integer; BlendMode: Integer; Color: LongWord = $FFFFFFFF; MirrorX: Boolean = False; MirrorY: Boolean = False); overload;
    procedure DrawRect(Texture: TDXTexture; X, Y: Integer; Rect: TRect; BlendMode: Integer; Color: LongWord = $FFFFFFFF; MirrorX: Boolean = False; MirrorY: Boolean = False); overload;

    procedure DrawStretch(Texture: TDXTexture; X1, Y1, X2, Y2: Integer; BlendMode: Integer; Color: LongWord = $FFFFFFFF); overload;
    procedure DrawStretch(Texture: TDXTexture; X1, Y1, X2, Y2: Integer; Rect: TRect; BlendMode: Integer; Color: LongWord = $FFFFFFFF); overload;

    procedure DrawTurn(Texture: TDXTexture; X, Y: Integer; Level, Vertical: Boolean; BlendMode: Integer; Color: LongWord = $FFFFFFFF);

    procedure Circle(X, Y, Radius: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_Default); overload;
    procedure Circle(X, Y, Radius: Single; Width: Integer; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Triangle(X1, Y1, X2, Y2, X3, Y3: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Ellipse(X, Y, R1, R2: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Arc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal; DrawStartEnd, Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Arc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal; Width: Integer; DrawStartEnd, Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Line2Color(X1, Y1, X2, Y2: Single; Color1, Color2: Cardinal; BlendMode: Integer);
    procedure Rectangle(X, Y, Width, Height: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Quadrangle4Color(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; Color1, Color2, Color3, Color4: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Polygon(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT); overload;
    procedure Polygon(Points: array of TPoint; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT); overload;

    property Font: TDXFont read FFont;
    property DrawTexture: TDXTexture read FDrawTexture;
  end;

  TDXDrawCanvas = class(TDXCanvas)
  private
    FLineX: Single;
    FLineY: Single;
    procedure FillTriangle(r1, r2, r3: TPoint; Colors, DrawFx: Cardinal);
    procedure FillQuadrangle(r1, r2, r3, r4: TPoint; Colors, DrawFx: Cardinal);
    procedure FillPentagon(r1, r2, r3, r4, r5: TPoint; Colors, DrawFx: Cardinal);
    procedure FillHexagon(r1, r2, r3, r4, r5, r6: TPoint; Colors, DrawFx: Cardinal);
    procedure FillHeptagon(r1, r2, r3, r4, r5, r6, r7: TPoint; Colors, DrawFx: Cardinal);

    procedure DrawTriangle(Position, X, Y: Integer; Source: TDXTexture; Colors, DrawFx: Cardinal);
    procedure DrawQuadrangle(Position, X, Y: Integer; Source: TDXTexture; Colors, DrawFx: Cardinal);
    procedure DrawPentagon(Position, X, Y: Integer; Source: TDXTexture; Colors, DrawFx: Cardinal);
    procedure DrawHexagon(Position, X, Y: Integer; Source: TDXTexture; Colors, DrawFx: Cardinal);
    procedure DrawHeptagon(Position, X, Y: Integer; Source: TDXTexture; Colors, DrawFx: Cardinal);
  public
    constructor Create(Font: TDXFont); override;
    destructor Destroy; override;

    function TextWidth(Str: WideString): Integer;
    function TextHeight(Str: WideString): Integer;

    procedure TextOut(x, Y: Integer; FColor: Cardinal; Str: WideString); overload;
    procedure TextOut(x, Y: Integer; Str: WideString; FColor: Cardinal); overload;
    procedure TextOut(x, Y: Integer; Str: WideString; FColor: Cardinal; Alpha: Byte); overload;
    procedure TextRect(Rect: TRect; Text: WideString; FColor: Cardinal; TextFormat: TTextFormat = []);

    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent: Boolean); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent: Boolean; Color: TColor4); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal); overload;
    procedure Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal; Color: TColor4); overload;

    procedure StretchDraw(StretchRect, SrcRect: TRect; Source: TDXTexture; Transparent: Boolean); overload;
    procedure StretchDraw(StretchRect, SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal; Color: TColor4); overload;

    procedure FillRect(Left, Top, Width, Height: Integer; Color: Cardinal); overload;
    procedure FillRect(const Rect: TRect; Color: TColor4; DrawFx: Cardinal); overload;
    procedure FillRect(const Rect: TRect; Color: Cardinal; DrawFx: Cardinal); overload;

    procedure RoundRect(left, Top, Right, Bottom, X, Y: Integer; Color: Cardinal); overload;
    procedure RoundRect(left, Top, Right, Bottom: Integer; Color: Cardinal); overload;

    procedure LineTo(x, y: Single; Color: Cardinal);
    procedure MoveTo(x, y: Single);

    procedure FillSquareSchedule(Position: Integer; Rect: TRect; Colors, DrawFx: Cardinal); overload;
    procedure FillSquareSchedule(Position, Left, Top, Width, Height: Integer; Colors, DrawFx: Cardinal); overload;

    procedure DrawSquareSchedule(Position, X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Colors, DrawFx: Cardinal);
  end;

var
  g_DXCanvas: TDXDrawCanvas = nil;

implementation

{ TDXCanvas }

var
  FHGE: IHGE = nil;
  FQuad: THGEQuad;

procedure TDXCanvas.Circle(X, Y, Radius: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
begin
  FHGE.Gfx_RenderCircle(X, Y, Radius, Color, Filled, BlendMode);
end;

procedure TDXCanvas.Arc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal; DrawStartEnd, Filled: Boolean; BlendMode: Integer);
begin
  FHGE.Gfx_RenderArc(X, Y, Radius, StartRadius, EndRadius, Color, DrawStartEnd, Filled, BlendMode);
end;

procedure TDXCanvas.Arc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal; Width: Integer; DrawStartEnd, Filled: Boolean; BlendMode: Integer);
var
  I: Integer;
begin
  if Filled then
    FHGE.Gfx_RenderArc(X, Y, Radius + Width, StartRadius, EndRadius, Color, DrawStartEnd, Filled, BlendMode)
  else
    for I := 0 to 4 * (Width - 1) do
      FHGE.Gfx_RenderArc(X, Y, Radius + I * 0.15, StartRadius, EndRadius, Color, DrawStartEnd, Filled, BlendMode);
end;

procedure TDXCanvas.Circle(X, Y, Radius: Single; Width: Integer; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
var
  I: Integer;
begin
  if Filled then
    FHGE.Gfx_RenderCircle(X, Y, Radius + Width, Color, Filled, BlendMode)
  else
    for I := 0 to 3 * (Width - 1) do
      FHGE.Gfx_RenderCircle(X, Y, Radius + I * 0.3, Color, Filled, BlendMode);
end;

constructor TDXCanvas.Create(Font: TDXFont);
begin
  inherited Create;
  FHGE := HGECreate(HGE_VERSION);
  FFont := Font;
  SetColor($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF);
  FDrawTexture := TDXImageTexture.Create(Self);
  FDrawTexture.Size := Point(8, 8);
  FDrawTexture.PatternSize := Point(8, 8);
  FDrawTexture.Active := True;
end;

destructor TDXCanvas.Destroy;
begin
  FDrawTexture.Free;
  FHGE := nil;
  inherited;
end;

procedure TDXCanvas.DrawRect(Texture: TDXTexture; X, Y, Left, Top, Right, Bottom: Integer; BlendMode: Integer; Color: LongWord; MirrorX: Boolean; MirrorY: Boolean);
begin
  DrawRect(Texture, X, Y, Rect(Left, Top, Right, Bottom), BlendMode, Color, MirrorX, MirrorY);
end;

procedure TDXCanvas.Draw(Texture: TDXTexture; X, Y: Integer; BlendMode: Integer; Color: LongWord; MirrorX: Boolean; MirrorY: Boolean);
var
  TempX1, TempY1, TempX2, TempY2: Single;
begin
  if (Texture = nil) or (Texture.Image = nil) or (Texture.Image.Handle = nil) then
    Exit;
  SetPattern(Texture.Image, Texture.ClientRect);
  SetColor(DisplaceRB(Color));
  TempX1 := X;
  TempY1 := Y;
  TempX2 := X + FWidth;
  TempY2 := Y + FHeight;

  FQuad.V[0].X := TempX1;
  FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2;
  FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2;
  FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1;
  FQuad.V[3].Y := TempY2;

  SetMirror(MirrorX, MirrorY);
  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure TDXCanvas.DrawRect(Texture: TDXTexture; X, Y: Integer; Rect: TRect; BlendMode: Integer; Color: LongWord; MirrorX: Boolean; MirrorY: Boolean);
var
  TempX1, TempY1, TempX2, TempY2: Single;
begin
  if (Texture = nil) or (Texture.Image = nil) or (Texture.Image.Handle = nil) or (Rect.Right <= Rect.Left) or (Rect.Bottom <= Rect.Top) then
    Exit;
  SetPattern(Texture.Image, Rect);
  SetColor(DisplaceRB(Color));
  TempX1 := X;
  TempY1 := Y;
  TempX2 := X + FWidth;
  TempY2 := Y + FHeight;

  FQuad.V[0].X := TempX1;
  FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2;
  FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2;
  FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1;
  FQuad.V[3].Y := TempY2;

  SetMirror(MirrorX, MirrorY);
  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure TDXCanvas.DrawStretch(Texture: TDXTexture; X1, Y1, X2, Y2: Integer; Rect: TRect; BlendMode: Integer; Color: LongWord);
begin
  if (Texture = nil) or (Texture.Image = nil) or (Texture.Image.Handle = nil) then
    Exit;
  SetPattern(Texture.Image, Rect);
  SetColor(Color);
  FQuad.V[0].X := X1;
  FQuad.V[0].Y := Y1;
  FQuad.V[1].X := X2;
  FQuad.V[1].Y := Y1;
  FQuad.V[2].X := X2;
  FQuad.V[2].Y := Y2;
  FQuad.V[3].X := X1;
  FQuad.V[3].Y := Y2;
  //SetMirror(MirrorX, MirrorY);
  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure TDXCanvas.DrawTurn(Texture: TDXTexture; X, Y: Integer; Level, Vertical: Boolean; BlendMode: Integer; Color: LongWord);
var
  TempX1, TempY1, TempX2, TempY2: Single;
begin
  if (Texture = nil) or (Texture.Image = nil) or (Texture.Image.Handle = nil) then
    Exit;
  SetPattern(Texture.Image, Texture.ClientRect);
  SetColor(Color);
  TempX1 := X;
  TempY1 := Y;
  TempX2 := X + FWidth;
  TempY2 := Y + FHeight;

  FQuad.V[0].X := TempX1;
  FQuad.V[0].Y := TempY1;
  FQuad.V[1].X := TempX2;
  FQuad.V[1].Y := TempY1;
  FQuad.V[2].X := TempX2;
  FQuad.V[2].Y := TempY2;
  FQuad.V[3].X := TempX1;
  FQuad.V[3].Y := TempY2;

  SetMirror(Level, Vertical);

  FQuad.Blend := BlendMode;
  FHGE.Gfx_RenderQuad(FQuad);
end;

procedure TDXCanvas.DrawStretch(Texture: TDXTexture; X1, Y1, X2, Y2: Integer; BlendMode: Integer; Color: LongWord);
begin
  DrawStretch(Texture, X1, Y1, X2, Y2, Texture.ClientRect, BlendMode, Color);
end;

procedure TDXCanvas.Ellipse(X, Y, R1, R2: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
begin
  FHGE.Gfx_RenderEllipse(X, Y, R1, R2, Color, Filled, BlendMode);
end;

procedure TDXCanvas.Line2Color(X1, Y1, X2, Y2: Single; Color1, Color2: Cardinal; BlendMode: Integer);
begin
  FHGE.Gfx_RenderLine2Color(X1, Y1, X2, Y2, Color1, Color2, BlendMode);
end;

procedure TDXCanvas.Polygon(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
begin
  FHGE.Gfx_RenderPolygon(Points, NumPoints, Color, Filled, BlendMode);
end;

procedure TDXCanvas.Polygon(Points: array of TPoint; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
begin
  FHGE.Gfx_RenderPolygon(Points, High(Points) + 1, Color, Filled, BlendMode);
end;

procedure TDXCanvas.Quadrangle4Color(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; Color1, Color2, Color3, Color4: Cardinal; Filled: Boolean; BlendMode: Integer);
begin
  FHGE.Gfx_RenderQuadrangle4Color(X1, Y1, X2, Y2, X3, Y3, X4, Y4, Color1, Color2, Color3, Color4, Filled, BlendMode);
end;

procedure TDXCanvas.Rectangle(X, Y, Width, Height: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
begin
  FHGE.Gfx_RenderQuadrangle4Color(X, Y, X + Width, Y, X + Width, Y + Height, X, Y + Height, Color, Color, Color, Color, Filled, BlendMode);
end;

procedure TDXCanvas.SetColor(Color: Cardinal);
begin
  FQuad.V[0].Col := Color;
  FQuad.V[1].Col := Color;
  FQuad.V[2].Col := Color;
  FQuad.V[3].Col := Color;
end;

procedure TDXCanvas.SetColor(Color1, Color2, Color3, Color4: Cardinal);
begin
  FQuad.V[0].Col := Color1;
  FQuad.V[1].Col := Color2;
  FQuad.V[2].Col := Color3;
  FQuad.V[3].Col := Color4;
end;

procedure TDXCanvas.SetMirror(MirrorX, MirrorY: Boolean);
var
  TX, TY: Single;
begin
  if (MirrorX) then begin
    TX := FQuad.V[0].TX;
    FQuad.V[0].TX := FQuad.V[1].TX;
    FQuad.V[1].TX := TX;

    TY := FQuad.V[0].TY;
    FQuad.V[0].TY := FQuad.V[1].TY;
    FQuad.V[1].TY := TY;

    TX := FQuad.V[3].TX;
    FQuad.V[3].TX := FQuad.V[2].TX;
    FQuad.V[2].TX := TX;

    TY := FQuad.V[3].TY;
    FQuad.V[3].TY := FQuad.V[2].TY;
    FQuad.V[2].TY := TY;
  end;

  if (MirrorY) then begin
    TX := FQuad.V[0].TX;
    FQuad.V[0].TX := FQuad.V[3].TX;
    FQuad.V[3].TX := TX;

    TY := FQuad.V[0].TY;
    FQuad.V[0].TY := FQuad.V[3].TY;
    FQuad.V[3].TY := TY;

    TX := FQuad.V[1].TX;
    FQuad.V[1].TX := FQuad.V[2].TX;
    FQuad.V[2].TX := TX;

    TY := FQuad.V[1].TY;
    FQuad.V[1].TY := FQuad.V[2].TY;
    FQuad.V[2].TY := TY;
  end;
end;

procedure TDXCanvas.SetPattern(Texture: ITexture; Rect: TRect);
var
  TexX1, TexY1, TexX2, TexY2: Single;
  Left, Top: Integer;
begin
  if Assigned(Texture) then begin
    FTexWidth := FHGE.Texture_GetWidth(Texture);
    FTexHeight := FHGE.Texture_GetHeight(Texture);
  end
  else begin
    FTexWidth := 1;
    FTexHeight := 1;
  end;
  FQuad.Tex := Texture;

  Left := Rect.Left;
  Top := Rect.Top;
  FWidth := Rect.Right - Left;
  FHeight := Rect.Bottom - Top;

  TexX1 := Left / FTexWidth;
  TexY1 := Top / FTexHeight;
  TexX2 := (Left + FWidth) / FTexWidth;
  TexY2 := (Top + FHeight) / FTexHeight;

  FQuad.V[0].TX := TexX1;
  FQuad.V[0].TY := TexY1;
  FQuad.V[1].TX := TexX2;
  FQuad.V[1].TY := TexY1;
  FQuad.V[2].TX := TexX2;
  FQuad.V[2].TY := TexY2;
  FQuad.V[3].TX := TexX1;
  FQuad.V[3].TY := TexY2;
end;

procedure TDXCanvas.Triangle(X1, Y1, X2, Y2, X3, Y3: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
begin
  FHGE.Gfx_RenderTriangle(X1, Y1, X2, Y2, X3, Y3, Color, Filled, BlendMode);
end;

{ TDXDrawCanvas }

procedure TDXDrawCanvas.FillRect(Left, Top, Width, Height: Integer; Color: Cardinal);
begin
  Rectangle(Left, Top, Width, Height, DisplaceRB(Color), True);
end;

constructor TDXDrawCanvas.Create(Font: TDXFont);
begin
  inherited;
  g_DXCanvas := Self;
end;

destructor TDXDrawCanvas.Destroy;
begin
  g_DXCanvas := nil;
  inherited;
end;

procedure TDXDrawCanvas.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent: Boolean; Color: TColor4);
begin
  DrawRect(Source, X, Y, SrcRect, bTransparent[Transparent], Color[0]);
end;

procedure TDXDrawCanvas.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Transparent: Boolean);
begin
  DrawRect(Source, X, Y, SrcRect, bTransparent[Transparent]);
end;

procedure TDXDrawCanvas.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal; Color: TColor4);
begin
  DrawRect(Source, X, Y, SrcRect, DrawFx, Color[0]);
end;

procedure TDXDrawCanvas.DrawHeptagon(Position, X, Y: Integer; Source: TDXTexture; Colors, DrawFx: Cardinal);
var
  nMidX, nMidY, nTop, nLeft: Single;
  Vertex: array of THGEVertex;
begin
  if (Source = nil) or (Source.Image = nil) or (Source.Image.Handle = nil) then Exit;

  FTexWidth := FHGE.Texture_GetWidth(Source.Image);
  FTexHeight := FHGE.Texture_GetHeight(Source.Image);


  nLeft := 0;
  nTop := 0;
  FWidth := Source.Width;
  FHeight := Source.Height;

  nMidX := FWidth / 2;
  nMidY := FHeight / 2;

  Position := Round(nMidX / ((99 - 87) / (Position - 87)));

  SetLength(Vertex, 15);
  FillChar(Vertex[0], SizeOf(THGEVertex) * Length(Vertex), #0);

  Vertex[0].X := X + nMidX;
  Vertex[0].Y := Y;
  Vertex[0].Col := Colors;
  Vertex[0].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[0].TY := nTop / FTexHeight;

  Vertex[1].X := X + nMidX;
  Vertex[1].Y := Y + nMidY;
  Vertex[1].Col := Colors;
  Vertex[1].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[1].TY := (nTop + nMidY) / FTexHeight;
  
  Vertex[2].X := X + FWidth;
  Vertex[2].Y := Y;
  Vertex[2].Col := Colors;
  Vertex[2].TX := (nLeft + FWidth) / FTexWidth;
  Vertex[2].TY := nTop / FTexHeight;

  Vertex[3].X := X + nMidX;
  Vertex[3].Y := Y + nMidY;
  Vertex[3].Col := Colors;
  Vertex[3].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[3].TY := (nTop + nMidY) / FTexHeight;
  
  Vertex[4].X := X + FWidth;
  Vertex[4].Y := Y;
  Vertex[4].Col := Colors;
  Vertex[4].TX := (nLeft + FWidth) / FTexWidth;
  Vertex[4].TY := nTop / FTexHeight;

  Vertex[5].X := X + FWidth;
  Vertex[5].Y := Y + FHeight;
  Vertex[5].Col := Colors;
  Vertex[5].TX := (nLeft + FWidth) / FTexWidth;
  Vertex[5].TY := (nTop + FHeight) / FTexHeight;

  Vertex[6].X := X + nMidX;
  Vertex[6].Y := Y + nMidY;
  Vertex[6].Col := Colors;
  Vertex[6].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[6].TY := (nTop + nMidY) / FTexHeight;

  Vertex[7].X := X + FWidth;
  Vertex[7].Y := Y + FHeight;
  Vertex[7].Col := Colors;
  Vertex[7].TX := (nLeft + FWidth) / FTexWidth;
  Vertex[7].TY := (nTop + FHeight) / FTexHeight;

  Vertex[8].X := X;
  Vertex[8].Y := Y + FHeight;
  Vertex[8].Col := Colors;
  Vertex[8].TX := (nLeft) / FTexWidth;
  Vertex[8].TY := (nTop + FHeight) / FTexHeight;

  Vertex[9].X := X + nMidX;
  Vertex[9].Y := Y + nMidY;
  Vertex[9].Col := Colors;
  Vertex[9].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[9].TY := (nTop + nMidY) / FTexHeight;

  Vertex[10].X := X;
  Vertex[10].Y := Y + FHeight;
  Vertex[10].Col := Colors;
  Vertex[10].TX := nLeft / FTexWidth;
  Vertex[10].TY := (nTop + FHeight) / FTexHeight;

  Vertex[11].X := X;
  Vertex[11].Y := Y;
  Vertex[11].Col := Colors;
  Vertex[11].TX := nLeft / FTexWidth;
  Vertex[11].TY := nTop / FTexHeight;

  Vertex[12].X := X + nMidX;
  Vertex[12].Y := Y + nMidY;
  Vertex[12].Col := Colors;
  Vertex[12].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[12].TY := (nTop + nMidY) / FTexHeight;

  Vertex[13].X := X;
  Vertex[13].Y := Y;
  Vertex[13].Col := Colors;
  Vertex[13].TX := nLeft / FTexWidth;
  Vertex[13].TY := nTop / FTexHeight;

  Vertex[14].X := X + Position;
  Vertex[14].Y := Y;
  Vertex[14].Col := Colors;
  Vertex[14].TX := (nLeft + Position) / FTexWidth;
  Vertex[14].TY := nTop / FTexHeight;

  FHGE.Gfx_DrawPolygon(Vertex, Source.Image, DrawFx);
  Vertex := nil;
end;

procedure TDXDrawCanvas.DrawHexagon(Position, X, Y: Integer; Source: TDXTexture; Colors, DrawFx: Cardinal);
var
  nMidX, nMidY, nTop, nLeft: Single;
  Vertex: array of THGEVertex;
begin
  if (Source = nil) or (Source.Image = nil) or (Source.Image.Handle = nil) then Exit;

  FTexWidth := FHGE.Texture_GetWidth(Source.Image);
  FTexHeight := FHGE.Texture_GetHeight(Source.Image);


  nLeft := 0;
  nTop := 0;
  FWidth := Source.Width;
  FHeight := Source.Height;

  nMidX := FWidth / 2;
  nMidY := FHeight / 2;

  Position := Round(FHeight / ((87 - 62) / (Position - 62)));

  SetLength(Vertex, 12);
  FillChar(Vertex[0], SizeOf(THGEVertex) * Length(Vertex), #0);

  Vertex[0].X := X + nMidX;
  Vertex[0].Y := Y;
  Vertex[0].Col := Colors;
  Vertex[0].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[0].TY := nTop / FTexHeight;

  Vertex[1].X := X + nMidX;
  Vertex[1].Y := Y + nMidY;
  Vertex[1].Col := Colors;
  Vertex[1].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[1].TY := (nTop + nMidY) / FTexHeight;
  
  Vertex[2].X := X + FWidth;
  Vertex[2].Y := Y;
  Vertex[2].Col := Colors;
  Vertex[2].TX := (nLeft + FWidth) / FTexWidth;
  Vertex[2].TY := nTop / FTexHeight;

  Vertex[3].X := X + nMidX;
  Vertex[3].Y := Y + nMidY;
  Vertex[3].Col := Colors;
  Vertex[3].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[3].TY := (nTop + nMidY) / FTexHeight;
  
  Vertex[4].X := X + FWidth;
  Vertex[4].Y := Y;
  Vertex[4].Col := Colors;
  Vertex[4].TX := (nLeft + FWidth) / FTexWidth;
  Vertex[4].TY := nTop / FTexHeight;

  Vertex[5].X := X + FWidth;
  Vertex[5].Y := Y + FHeight;
  Vertex[5].Col := Colors;
  Vertex[5].TX := (nLeft + FWidth) / FTexWidth;
  Vertex[5].TY := (nTop + FHeight) / FTexHeight;

  Vertex[6].X := X + nMidX;
  Vertex[6].Y := Y + nMidY;
  Vertex[6].Col := Colors;
  Vertex[6].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[6].TY := (nTop + nMidY) / FTexHeight;

  Vertex[7].X := X + FWidth;
  Vertex[7].Y := Y + FHeight;
  Vertex[7].Col := Colors;
  Vertex[7].TX := (nLeft + FWidth) / FTexWidth;
  Vertex[7].TY := (nTop + FHeight) / FTexHeight;

  Vertex[8].X := X;
  Vertex[8].Y := Y + FHeight;
  Vertex[8].Col := Colors;
  Vertex[8].TX := (nLeft) / FTexWidth;
  Vertex[8].TY := (nTop + FHeight) / FTexHeight;

  Vertex[9].X := X + nMidX;
  Vertex[9].Y := Y + nMidY;
  Vertex[9].Col := Colors;
  Vertex[9].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[9].TY := (nTop + nMidY) / FTexHeight;

  Vertex[10].X := X;
  Vertex[10].Y := Y + FHeight;
  Vertex[10].Col := Colors;
  Vertex[10].TX := nLeft / FTexWidth;
  Vertex[10].TY := (nTop + FHeight) / FTexHeight;

  Vertex[11].X := X;
  Vertex[11].Y := Y + (FHeight - Position);
  Vertex[11].Col := Colors;
  Vertex[11].TX := nLeft / FTexWidth;
  Vertex[11].TY := (nTop + (FHeight - Position)) / FTexHeight;

  FHGE.Gfx_DrawPolygon(Vertex, Source.Image, DrawFx);
  Vertex := nil;
end;

procedure TDXDrawCanvas.DrawPentagon(Position, X, Y: Integer; Source: TDXTexture; Colors, DrawFx: Cardinal);
var
  nMidX, nMidY, nTop, nLeft: Single;
  Vertex: array of THGEVertex;
begin
  if (Source = nil) or (Source.Image = nil) or (Source.Image.Handle = nil) then Exit;

  FTexWidth := FHGE.Texture_GetWidth(Source.Image);
  FTexHeight := FHGE.Texture_GetHeight(Source.Image);


  nLeft := 0;
  nTop := 0;
  FWidth := Source.Width;
  FHeight := Source.Height;

  nMidX := FWidth / 2;
  nMidY := FHeight / 2;

  Position := Round(FWidth / ((62 - 37) / (Position - 37)));

  SetLength(Vertex, 9);
  FillChar(Vertex[0], SizeOf(THGEVertex) * Length(Vertex), #0);

  Vertex[0].X := X + nMidX;
  Vertex[0].Y := Y;
  Vertex[0].Col := Colors;
  Vertex[0].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[0].TY := nTop / FTexHeight;

  Vertex[1].X := X + nMidX;
  Vertex[1].Y := Y + nMidY;
  Vertex[1].Col := Colors;
  Vertex[1].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[1].TY := (nTop + nMidY) / FTexHeight;
  
  Vertex[2].X := X + FWidth;
  Vertex[2].Y := Y;
  Vertex[2].Col := Colors;
  Vertex[2].TX := (nLeft + FWidth) / FTexWidth;
  Vertex[2].TY := nTop / FTexHeight;

  Vertex[3].X := X + nMidX;
  Vertex[3].Y := Y + nMidY;
  Vertex[3].Col := Colors;
  Vertex[3].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[3].TY := (nTop + nMidY) / FTexHeight;
  
  Vertex[4].X := X + FWidth;
  Vertex[4].Y := Y;
  Vertex[4].Col := Colors;
  Vertex[4].TX := (nLeft + FWidth) / FTexWidth;
  Vertex[4].TY := nTop / FTexHeight;

  Vertex[5].X := X + FWidth;
  Vertex[5].Y := Y + FHeight;
  Vertex[5].Col := Colors;
  Vertex[5].TX := (nLeft + FWidth) / FTexWidth;
  Vertex[5].TY := (nTop + FHeight) / FTexHeight;

  Vertex[6].X := X + nMidX;
  Vertex[6].Y := Y + nMidY;
  Vertex[6].Col := Colors;
  Vertex[6].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[6].TY := (nTop + nMidY) / FTexHeight;

  Vertex[7].X := X + FWidth;
  Vertex[7].Y := Y + FHeight;
  Vertex[7].Col := Colors;
  Vertex[7].TX := (nLeft + FWidth) / FTexWidth;
  Vertex[7].TY := (nTop + FHeight) / FTexHeight;

  Vertex[8].X := X + (FWidth - Position);
  Vertex[8].Y := Y + FHeight;
  Vertex[8].Col := Colors;
  Vertex[8].TX := (nLeft + (FWidth - Position)) / FTexWidth;
  Vertex[8].TY := (nTop + FHeight) / FTexHeight;

  FHGE.Gfx_DrawPolygon(Vertex, Source.Image, DrawFx);
  Vertex := nil;
end;

procedure TDXDrawCanvas.DrawQuadrangle(Position, X, Y: Integer; Source: TDXTexture; Colors, DrawFx: Cardinal);
var
  nMidX, nMidY, nTop, nLeft: Single;
  Vertex: array of THGEVertex;
begin
  if (Source = nil) or (Source.Image = nil) or (Source.Image.Handle = nil) then Exit;

  FTexWidth := FHGE.Texture_GetWidth(Source.Image);
  FTexHeight := FHGE.Texture_GetHeight(Source.Image);


  nLeft := 0;
  nTop := 0;
  FWidth := Source.Width;
  FHeight := Source.Height;

  nMidX := FWidth / 2;
  nMidY := FHeight / 2;

  Position := Round(FHeight / ((37 - 12) / (Position - 12)));

  SetLength(Vertex, 6);
  FillChar(Vertex[0], SizeOf(THGEVertex) * Length(Vertex), #0);

  Vertex[0].X := X + nMidX;
  Vertex[0].Y := Y;
  Vertex[0].Col := Colors;
  Vertex[0].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[0].TY := nTop / FTexHeight;

  Vertex[1].X := X + nMidX;
  Vertex[1].Y := Y + nMidY;
  Vertex[1].Col := Colors;
  Vertex[1].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[1].TY := (nTop + nMidY) / FTexHeight;
  
  Vertex[2].X := X + FWidth;
  Vertex[2].Y := Y;
  Vertex[2].Col := Colors;
  Vertex[2].TX := (nLeft + FWidth) / FTexWidth;
  Vertex[2].TY := nTop / FTexHeight;

  Vertex[3].X := X + nMidX;
  Vertex[3].Y := Y + nMidY;
  Vertex[3].Col := Colors;
  Vertex[3].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[3].TY := (nTop + nMidY) / FTexHeight;
  
  Vertex[4].X := X + FWidth;
  Vertex[4].Y := Y;
  Vertex[4].Col := Colors;
  Vertex[4].TX := (nLeft + FWidth) / FTexWidth;
  Vertex[4].TY := nTop / FTexHeight;

  Vertex[5].X := X + FWidth;
  Vertex[5].Y := Y + Position;
  Vertex[5].Col := Colors;
  Vertex[5].TX := (nLeft + FWidth) / FTexWidth;
  Vertex[5].TY := (nTop + Position) / FTexHeight;

  FHGE.Gfx_DrawPolygon(Vertex, Source.Image, DrawFx);
  Vertex := nil;
end;

procedure TDXDrawCanvas.DrawSquareSchedule(Position, X, Y: Integer; SrcRect: TRect; Source: TDXTexture; Colors, DrawFx: Cardinal);
begin
  if Source = nil then exit;
  case Position of
    1..12: begin
        DrawTriangle(Position, X, Y, Source, DisplaceRB(Colors), DrawFx);
      end;
    13..37: begin
        DrawQuadrangle(Position, X, Y, Source, DisplaceRB(Colors), DrawFx);
      end;
    38..62: begin
        DrawPentagon(Position, X, Y, Source, DisplaceRB(Colors), DrawFx);
      end;
    63..87: begin
        DrawHexagon(Position, X, Y, Source, DisplaceRB(Colors), DrawFx);
      end;
    88..99: begin
        DrawHeptagon(Position, X, Y, Source, DisplaceRB(Colors), DrawFx);
      end;
    100: begin
        Draw(X, Y, SrcRect, Source, DrawFx, cColor4(Colors));
      end;
  end;
end;

procedure TDXDrawCanvas.DrawTriangle(Position, X, Y: Integer; Source: TDXTexture; Colors, DrawFx: Cardinal);
var
  nMidX, nMidY, nTop, nLeft: Single;
  Vertex: array of THGEVertex;
begin
  if (Source = nil) or (Source.Image = nil) or (Source.Image.Handle = nil) then Exit;

  FTexWidth := FHGE.Texture_GetWidth(Source.Image);
  FTexHeight := FHGE.Texture_GetHeight(Source.Image);


  nLeft := 0;
  nTop := 0;
  FWidth := Source.Width;
  FHeight := Source.Height;

  nMidX := FWidth / 2;
  nMidY := FHeight / 2;

  Position := Round(nMidX / (12 / Position));

  SetLength(Vertex, 3);
  FillChar(Vertex[0], SizeOf(THGEVertex) * Length(Vertex), #0);

  Vertex[0].X := X + nMidX;
  Vertex[0].Y := Y;
  Vertex[0].Col := Colors;
  Vertex[0].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[0].TY := nTop / FTexHeight;

  Vertex[1].X := X + nMidX;
  Vertex[1].Y := Y + nMidY;
  Vertex[1].Col := Colors;
  Vertex[1].TX := (nLeft + nMidX) / FTexWidth;
  Vertex[1].TY := (nTop + nMidY) / FTexHeight;
  
  Vertex[2].X := X + nMidX + Position;
  Vertex[2].Y := Y;
  Vertex[2].Col := Colors;
  Vertex[2].TX := (nLeft + nMidX + Position) / FTexWidth;
  Vertex[2].TY := nTop / FTexHeight;

  FHGE.Gfx_DrawPolygon(Vertex, Source.Image, DrawFx);
  Vertex := nil;
end;

procedure TDXDrawCanvas.Draw(X, Y: Integer; SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal);
begin
  DrawRect(Source, X, Y, SrcRect, DrawFx);
end;

procedure TDXDrawCanvas.FillHeptagon(r1, r2, r3, r4, r5, r6, r7: TPoint; Colors, DrawFx: Cardinal);
var
  P: array[0..14] of TPoint;
begin
  P[0] := r1;
  P[1] := r2;
  P[2] := r3;

  P[3] := r3;
  P[4] := r4;
  P[5] := r5;

  P[6] := r3;
  P[7] := r5;
  P[8] := r6;

  P[9] := r3;
  P[10] := r6;
  P[11] := r7;

  P[12] := r3;
  P[13] := r7;
  P[14] := r1;
  FHGE.Gfx_RenderSquareSchedule(P, High(P) + 1, Colors, DrawFx);
end;

procedure TDXDrawCanvas.FillHexagon(r1, r2, r3, r4, r5, r6: TPoint; Colors, DrawFx: Cardinal);
var
  P: array[0..11] of TPoint;
begin
  P[0] := r1;
  P[1] := r2;
  P[2] := r3;

  P[3] := r3;
  P[4] := r4;
  P[5] := r5;

  P[6] := r3;
  P[7] := r5;
  P[8] := r6;

  P[9] := r3;
  P[10] := r6;
  P[11] := r1;
  FHGE.Gfx_RenderSquareSchedule(P, High(P) + 1, Colors, DrawFx);
end;

procedure TDXDrawCanvas.FillPentagon(r1, r2, r3, r4, r5: TPoint; Colors, DrawFx: Cardinal);
var
  P: array[0..4] of TPoint;
begin
  P[0] := r1;
  P[1] := r2;
  P[2] := r3;
  P[3] := r4;
  P[4] := r5;
  Polygon(P, Colors, True, DrawFx);
end;

procedure TDXDrawCanvas.FillQuadrangle(r1, r2, r3, r4: TPoint; Colors, DrawFx: Cardinal);
begin
  Quadrangle4Color(r1.X, r1.Y, r2.X, r2.Y, r3.X, r3.Y, r4.X, r4.Y, Colors, Colors, Colors, Colors, True, DrawFx);
end;

procedure TDXDrawCanvas.FillRect(const Rect: TRect; Color: TColor4; DrawFx: Cardinal);
begin
  Rectangle(Rect.Left, Rect.Top, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top, DisplaceRB(Color[0]), True, DrawFx);
end;

procedure TDXDrawCanvas.FillSquareSchedule(Position: Integer; Rect: TRect; Colors, DrawFx: Cardinal);
var
  nMidX, nMidY: Integer;
begin
  nMidX := (Rect.Right - Rect.Left) div 2;
  nMidY := (Rect.Bottom - Rect.Top) div 2;
  Colors := DisplaceRB(Colors);
  case Position of
    0: FillRect(Rect, Colors, DrawFx);
    1..12: begin
        FillHeptagon(
          Point(Rect.Left, Rect.Top),
          Point(Rect.Left + nMidX, Rect.Top),
          Point(Rect.Left + nMidX, Rect.Top + nMidY),
          Point(Rect.Left + nMidX + Round(nMidX / (12 / Position)), Rect.Top),
          Point(Rect.Right, Rect.Top),
          Point(Rect.Right, Rect.Bottom),
          Point(Rect.Left, Rect.Bottom),
          Colors, DrawFx);
      end;
    13..37: begin
        FillHexagon(
          Point(Rect.Left, Rect.Top),
          Point(Rect.Left + nMidX, Rect.Top),
          Point(Rect.Left + nMidX, Rect.Top + nMidY),
          Point(Rect.Right, Rect.Top + Round((Rect.Bottom - Rect.Top) / ((37 - 12) / (Position - 12)))),
          Point(Rect.Right, Rect.Bottom),
          Point(Rect.Left, Rect.Bottom),
          Colors, DrawFx);
      end;
    38..62: begin
        FillPentagon(
          Point(Rect.Left, Rect.Top),
          Point(Rect.Left + nMidX, Rect.Top),
          Point(Rect.Left + nMidX, Rect.Top + nMidY),
          Point(Rect.Right - Round((Rect.Right - Rect.Left) / ((62 - 37) / (Position - 37))), Rect.Bottom),
          Point(Rect.Left, Rect.Bottom),
          Colors, DrawFx);
      end;
    63..87: begin
        FillQuadrangle(
          Point(Rect.Left, Rect.Top),
          Point(Rect.Left + nMidX, Rect.Top),
          Point(Rect.Left + nMidX, Rect.Top + nMidY),
          Point(Rect.Left, Rect.Bottom - Round((Rect.Bottom - Rect.Top) / ((87 - 62) / (Position - 62)))),
          Colors, DrawFx);
      end;
    88..99: begin
        FillTriangle(
          Point(Rect.Left + Round(nMidX / ((99 - 87) / (Position - 87))), Rect.Top),
          Point(Rect.Left + nMidX, Rect.Top),
          Point(Rect.Left + nMidX, Rect.Top + nMidY),
          Colors, DrawFx);
      end;
  end;
end;

procedure TDXDrawCanvas.FillSquareSchedule(Position, Left, Top, Width, Height: Integer; Colors, DrawFx: Cardinal);
begin
  FillSquareSchedule(Position, Rect(Left, Top, Width, Height), Colors, DrawFx);
end;

procedure TDXDrawCanvas.FillTriangle(r1, r2, r3: TPoint; Colors, DrawFx: Cardinal);
begin
  Triangle(r1.X, r1.Y, r2.X, r2.Y, r3.X, r3.Y, Colors, True, DrawFx);
end;

procedure TDXDrawCanvas.LineTo(x, y: Single; Color: Cardinal);
begin
  Color := DisplaceRB(Color) or $FF000000;
  Line2Color(FLineX, FLIneY, X, Y, Color, Color, fxBlend);
  FLineX := X;
  FLineY := Y;
end;

procedure TDXDrawCanvas.MoveTo(x, y: Single);
begin
  FLineX := X;
  FLIneY := Y;
end;

procedure TDXDrawCanvas.RoundRect(left, Top, Right, Bottom, X, Y: Integer; Color: Cardinal);
var
  P: array[0..7] of TPoint;
begin
  X := X div 2;
  Y := Y div 2;
  P[0].X := Left + X;
  P[0].Y := Top;
  P[1].X := Right - X;
  P[1].Y := Top;
  P[2].X := Right;
  P[2].Y := Top + Y;
  P[3].X := Right;
  P[3].Y := Bottom - Y;
  P[4].X := Right - X;
  P[4].Y := Bottom;
  P[5].X := Left + X;
  P[5].Y := Bottom;
  P[6].X := Left;
  P[6].Y := Bottom - Y;
  P[7].X := Left;
  P[7].Y := Top + Y;
  Polygon(P, DisplaceRB($FF000000 or Color), False);
end;

procedure TDXDrawCanvas.RoundRect(left, Top, Right, Bottom: Integer; Color: Cardinal);
begin
  Rectangle(Left, Top, Right - Left, Bottom - Top, DisplaceRB($FF000000 or Color), False);
end;

procedure TDXDrawCanvas.StretchDraw(StretchRect, SrcRect: TRect; Source: TDXTexture; Transparent: Boolean);
begin
  DrawStretch(Source, StretchRect.Left, StretchRect.Top, StretchRect.Right, StretchRect.Bottom, SrcRect, bTransparent[Transparent]);
end;

procedure TDXDrawCanvas.StretchDraw(StretchRect, SrcRect: TRect; Source: TDXTexture; DrawFx: Cardinal; Color: TColor4);
begin
  DrawStretch(Source, StretchRect.Left, StretchRect.Top, StretchRect.Right, StretchRect.Bottom, SrcRect, DrawFx, Color[0]);
end;

function TDXDrawCanvas.TextHeight(Str: WideString): Integer;
begin
  Result := 12;
end;

procedure TDXDrawCanvas.TextOut(x, Y: Integer; Str: WideString; FColor: Cardinal);
begin
  if FFont = nil then
    exit;
  TextOut(X, Y, Str, FColor, 255);
end;

procedure TDXDrawCanvas.TextOut(x, Y: Integer; FColor: Cardinal; Str: WideString);
begin
  if FFont = nil then
    exit;
  TextOut(X, Y, Str, FColor, 255);
end;

procedure TDXDrawCanvas.TextOut(x, Y: Integer; Str: WideString; FColor: Cardinal; Alpha: Byte);
var
  i: integer;
  sWord: Word;
  Texture: TDXTexture;
  AsciiRect: TRect;
  nWidth: Integer;
begin
  if (FFont = nil) or (not FFont.boInitialize) then
    exit;
  nWidth := 0;
  Dec(X);
  Dec(Y);
  Texture := Font.DXTexture;
  if Texture = nil then
    exit;
  for I := 1 to Length(Str) do begin
    Move(Str[i], sWord, 2);
    AsciiRect := Font.AsciiRect[sWord];
    if (AsciiRect.Right > 4) then begin
      DrawRect(Texture, X + nWidth, Y, AsciiRect.Left, AsciiRect.Top, AsciiRect.Right, AsciiRect.Bottom, fxBlend, (Alpha shl 24) or FColor);
      Inc(nWidth, (AsciiRect.Right - AsciiRect.Left) + Font.kerning);
    end;
  end;
end;

procedure TDXDrawCanvas.TextRect(Rect: TRect; Text: WideString; FColor: Cardinal; TextFormat: TTextFormat);
var
  Color4: LongWord;
  nY, nX, I: Integer;
  Texture: TDXTexture;
  AsciiRect: TRect;
  nWidth, nHeight, FontWidth: Integer;
  sWord: Word;
  x, y, w, h: Integer;
begin
  if Text = '' then
    exit;
  FontWidth := 0;
  Color4 := $FF000000 or FColor;

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
        x := AsciiRect.Left;
        y := AsciiRect.Top;
        w := AsciiRect.Right - AsciiRect.Left;
        h := AsciiRect.Bottom - AsciiRect.Top;
        if (nY + h) > nHeight then begin
          h := nHeight - nY;
          if h <= 0 then
            Continue;
        end;
        if (FontWidth + w) > nWidth then begin
          x := x + (w) - (nWidth - FontWidth);
          w := nWidth - FontWidth;
        end;
        DrawRect(Texture, nX - FontWidth - w, nY + Rect.Top, x, y, w + x, y + h, fxBlend, Color4);
        Inc(FontWidth, w + Font.kerning);
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
        x := AsciiRect.Left;
        y := AsciiRect.Top;
        w := AsciiRect.Right - AsciiRect.Left;
        h := AsciiRect.Bottom - AsciiRect.Top;
        if (nY + h) > nHeight then begin
          h := nHeight - nY;
          if h <= 0 then
            Continue;
        end;
        if (FontWidth + w) > nWidth then begin
          w := nWidth - FontWidth;
        end;
        DrawRect(Texture, nX + FontWidth, nY + Rect.Top, x, y, w + x, y + h, fxBlend, Color4);
        Inc(FontWidth, w + Font.kerning);
      end;
    end;
  end;
end;

function TDXDrawCanvas.TextWidth(Str: WideString): Integer;
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
end;

procedure TDXDrawCanvas.FillRect(const Rect: TRect; Color, DrawFx: Cardinal);
begin
  Rectangle(Rect.Left, Rect.Top, Rect.Right - Rect.Left, Rect.Bottom - Rect.Top, Color, True, DrawFx);
end;

initialization
  FHGE := nil;

finalization
  FHGE := nil;

end.

