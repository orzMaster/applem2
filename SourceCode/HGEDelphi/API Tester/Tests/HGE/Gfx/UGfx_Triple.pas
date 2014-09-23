unit UGfx_Triple;

interface

implementation

uses
  Windows, HGE, HGEFont, UTestBase;

const
  COUNT = 50;

var
  Triples: array [0..COUNT - 1] of THGETriple;
  DX, DY: array [0..COUNT - 1] of Single;
  Texture: ITexture;

function FrameFunc: Boolean;
var
  DT, X, Y: Single;
  I, J, Blend: Integer;
  Tex: ITexture;
begin
  DT := Engine.Timer_GetDelta;
  SetFocus(Engine.System_GetState(HGE_HWND));

  Blend := Triples[0].Blend;
  Tex := Triples[0].Tex;
  case Engine.Input_GetKey of
    HGEK_1: Blend := BLEND_COLORMUL or BLEND_ALPHAADD;
    HGEK_2: Blend := BLEND_COLORADD or BLEND_ALPHAADD;
    HGEK_3: Blend := BLEND_COLORMUL or BLEND_ALPHABLEND;
    HGEK_4: Blend := BLEND_COLORADD or BLEND_ALPHABLEND;
    HGEK_SPACE:
      if Assigned(Tex) then
        Tex := nil
      else
        Tex := Texture;
  end;

  for I := 0 to COUNT - 1 do begin
    Triples[I].Blend := Blend;
    Triples[I].Tex := Tex;

    for J := 0 to 2 do begin
      X := Triples[I].V[J].X + (DX[I] * DT);
      Y := Triples[I].V[J].Y + (DY[I] * DT);
      if (X < 0) or (X >= 800) then
        DX[I] := -DX[I];
      if (Y < 0) or (Y >= 600) then
        DY[I] := -DY[I];
      Triples[I].V[J].X := X;
      Triples[I].V[J].Y := Y;
    end;
  end;

  Result := False;
end;

function RenderFunc: Boolean;
var
  I: Integer;
begin
  Engine.Gfx_BeginScene();
  Engine.Gfx_Clear(0);
  for I := 0 to COUNT - 1 do
    Engine.Gfx_RenderTriple(Triples[I]);
  LargeFont.PrintF(5,5,HGETEXT_LEFT,
    'FPS: %d'#13+
    'Blend mode: %d (use 1-4 keys)'#13+
    'Use spacebar to switch texture mode',
    [Engine.Timer_GetFPS,Triples[0].Blend + 1]);
  Engine.Gfx_EndScene();

  Result := False;
end;

procedure Test;
var
  I, J: Integer;
  X, Y: Single;
begin
  Engine.Random_Seed(123);
  Texture := Engine.Texture_Load('texture.jpg');
  FillChar(Triples,SizeOf(Triples),0);
  // Create random triples
  for I := 0 to COUNT - 1 do begin
    Triples[I].Tex := nil;
    Triples[I].Blend := BLEND_DEFAULT;
    X := Engine.Random_Float(100,700);
    Y := Engine.Random_Float(100,500);
    for J := 0 to 2 do begin
      Triples[I].V[J].X := X + Engine.Random_Float(-100,100);
      Triples[I].V[J].Y := Y + Engine.Random_Float(-100,100);
      Triples[I].V[J].Z := 0.5;
      Triples[I].V[J].Col := Longword(Engine.Random_Int(0,$FFFFFF))
        or (Longword(Engine.Random_Int(0,255)) shl 24);
    end;
    Triples[I].V[1].TX := 1;
    Triples[I].V[2].TY := 1;
    DX[I] := Engine.Random_Float(-300,300);
    DY[I] := Engine.Random_Float(-300,300);
  end;

  // Run animation
  Engine.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,RenderFunc);
  while Running do;
  Engine.System_SetState(HGE_FRAMEFUNC,DefaultFrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,nil);

  Texture := nil;
end;

initialization
  RegisterTest('Gfx_RenderTriple','HGE\Gfx\UGfx_Triple',Test,[toManualGfx]);

end.
