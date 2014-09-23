unit UGfx_Quad;

interface

implementation

uses
  Windows, HGE, HGEFont, UTestBase;

const
  COUNT = 50;

var
  Quads: array [0..COUNT - 1] of THGEQuad;
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

  Blend := Quads[0].Blend;
  Tex := Quads[0].Tex;
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
    Quads[I].Blend := Blend;
    Quads[I].Tex := Tex;

    for J := 0 to 3 do begin
      X := Quads[I].V[J].X + (DX[I] * DT);
      Y := Quads[I].V[J].Y + (DY[I] * DT);
      if (X < 0) or (X >= 800) then
        DX[I] := -DX[I];
      if (Y < 0) or (Y >= 600) then
        DY[I] := -DY[I];
      Quads[I].V[J].X := X;
      Quads[I].V[J].Y := Y;
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
    Engine.Gfx_RenderQuad(Quads[I]);
  LargeFont.PrintF(5,5,HGETEXT_LEFT,
    'FPS: %d'#13+
    'Blend mode: %d (use 1-4 keys)'#13+
    'Use spacebar to switch texture mode',
    [Engine.Timer_GetFPS,Quads[0].Blend + 1]);
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
  FillChar(Quads,SizeOf(Quads),0);
  // Create random Quads
  for I := 0 to COUNT - 1 do begin
    Quads[I].Tex := nil;
    Quads[I].Blend := BLEND_DEFAULT;
    X := Engine.Random_Float(100,700);
    Y := Engine.Random_Float(100,500);
    for J := 0 to 3 do begin
      if (J = 0) or (J = 3) then
        Quads[I].V[J].X := X + Engine.Random_Float(-100,1)
      else
        Quads[I].V[J].X := X + Engine.Random_Float(1,100);
      if (J < 2) then
        Quads[I].V[J].Y := Y + Engine.Random_Float(-100,1)
      else
        Quads[I].V[J].Y := Y + Engine.Random_Float(1,100);
      Quads[I].V[J].Z := 0.5;
      Quads[I].V[J].Col := Longword(Engine.Random_Int(0,$FFFFFF))
        or (Longword(Engine.Random_Int(0,255)) shl 24);
    end;
    Quads[I].V[1].TX := 1;
    Quads[I].V[2].TX := 1;
    Quads[I].V[2].TY := 1;
    Quads[I].V[3].TY := 1;
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
  RegisterTest('Gfx_RenderQuad','HGE\Gfx\UGfx_Quad',Test,[toManualGfx]);

end.
