unit UGfx_Batch;

interface

implementation

uses
  Windows, HGE, HGEFont, UTestBase;

const
  COUNT = 50;

var
  Vertices: array [0..COUNT * 4 - 1] of THGEVertex;
  DX, DY: array [0..COUNT - 1] of Single;
  Texture, CurrentTexture: ITexture;
  CurrentBlend: Integer;

function FrameFunc: Boolean;
var
  DT, X, Y: Single;
  I, J: Integer;
begin
  DT := Engine.Timer_GetDelta;
  SetFocus(Engine.System_GetState(HGE_HWND));

  case Engine.Input_GetKey of
    HGEK_1: CurrentBlend := BLEND_COLORMUL or BLEND_ALPHAADD;
    HGEK_2: CurrentBlend := BLEND_COLORADD or BLEND_ALPHAADD;
    HGEK_3: CurrentBlend := BLEND_COLORMUL or BLEND_ALPHABLEND;
    HGEK_4: CurrentBlend := BLEND_COLORADD or BLEND_ALPHABLEND;
    HGEK_SPACE:
      if Assigned(CurrentTexture) then
        CurrentTexture := nil
      else
        CurrentTexture := Texture;
  end;

  for I := 0 to COUNT - 1 do begin
    for J := 0 to 3 do begin
      X := Vertices [I * 4 + j].X + (DX[I] * DT);
      Y := Vertices [I * 4 + j].Y + (DY[I] * DT);
      if (X < 0) or (X >= 800) then
        DX[I] := -DX[I];
      if (Y < 0) or (Y >= 600) then
        DY[I] := -DY[I];
      Vertices [I * 4 + j].X := X;
      Vertices [I * 4 + j].Y := Y;
    end;
  end;

  Result := False;
end;

function RenderFunc: Boolean;
var
  MaxPrim: Integer;
  V: PHGEVertexArray;
begin
  Engine.Gfx_BeginScene();
  Engine.Gfx_Clear(0);

  // Render all quads in a single batch
  V := Engine.Gfx_StartBatch(HGEPRIM_QUADS,CurrentTexture,CurrentBlend,MaxPrim);
  Move(Vertices,V^,COUNT * 4 * SizeOf(THGEVertex));
  Engine.Gfx_FinishBatch(COUNT);

  LargeFont.PrintF(5,5,HGETEXT_LEFT,
    'FPS: %d'#13+
    'Blend mode: %d (use 1-4 keys)'#13+
    'Use spacebar to switch texture mode',
    [Engine.Timer_GetFPS,CurrentBlend + 1]);
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
  CurrentTexture := nil;
  CurrentBlend := BLEND_DEFAULT;
  FillChar(Vertices,SizeOf(Vertices),0);
  // Create random Quads
  for I := 0 to COUNT - 1 do begin
    X := Engine.Random_Float(100,700);
    Y := Engine.Random_Float(100,500);
    for J := 0 to 3 do begin
      if (J = 0) or (J = 3) then
        Vertices[I * 4 + J].X := X + Engine.Random_Float(-100,1)
      else
        Vertices[I * 4 + J].X := X + Engine.Random_Float(1,100);
      if (J < 2) then
        Vertices[I * 4 + J].Y := Y + Engine.Random_Float(-100,1)
      else
        Vertices[I * 4 + J].Y := Y + Engine.Random_Float(1,100);
      Vertices[I * 4 + J].Z := 0.5;
      Vertices[I * 4 + J].Col := Longword(Engine.Random_Int(0,$FFFFFF))
        or (Longword(Engine.Random_Int(0,255)) shl 24);
    end;
    Vertices[I * 4 + 1].TX := 1;
    Vertices[I * 4 + 2].TX := 1;
    Vertices[I * 4 + 2].TY := 1;
    Vertices[I * 4 + 3].TY := 1;
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
  CurrentTexture := nil;
end;

initialization
  RegisterTest('Gfx Batch Processing','HGE\Gfx\UGfx_Batch',Test,[toManualGfx]);

end.
