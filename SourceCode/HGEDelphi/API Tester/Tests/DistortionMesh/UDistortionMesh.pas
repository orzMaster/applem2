unit UDistortionMesh;

interface

implementation

uses
  Windows, Math, HGE, HGEDistort, HGEFont, UTestBase;

const
  MeshX = 144;
  MeshY = 44;

var
  Texture: ITexture;
  Dis: IHGEDistortionMesh;
  Rows, Cols: Integer;
  CellW, CellH: Single;
  ShowGrid: Boolean;
  T: Single;

procedure CreateDistortionMesh(const ACols, ARows: Integer);
begin
  Cols := ACols;
  Rows := ARows;
  CellW := 512 / (Cols - 1);
  CellH := 512 / (Rows - 1);
  Dis := THGEDistortionMesh.Create(Cols,Rows);
  Dis.SetTexture(Texture);
  Dis.SetTextureRect(0,0,512,512);
  Dis.SetBlendMode(BLEND_COLORADD or BLEND_ALPHABLEND);
  Dis.Clear($FF000000);
end;

function FrameFunc: Boolean;
var
  DT, R, A, DX, DY: Single;
  I, J, Col: Integer;
begin
  SetFocus(Engine.System_GetState(HGE_HWND));
  case Engine.Input_GetKey of
    HGEK_SPACE: ShowGrid := not ShowGrid;
    HGEK_LEFT : CreateDistortionMesh(Max(2,Cols - 1),Rows);
    HGEK_RIGHT: CreateDistortionMesh(Min(100,Cols + 1),Rows);
    HGEK_DOWN : CreateDistortionMesh(Cols,Max(2,Rows - 1));
    HGEK_UP   : CreateDistortionMesh(Cols,Min(100,Rows + 1));
  end;

  DT := Engine.Timer_GetDelta;
  T := T + DT;
  for I := 0 to Rows - 1 do
    for J := 0 to Cols - 1 do begin
      R := Sqrt(Power(J - Cols / 2,2) + Power(I - Rows / 2,2));
      A := R * Cos(T * 2) * 0.1;
      DX := Sin(A) * (I * CellH - 256) + Cos(A) * (J * CellW - 256);
      DY := Cos(A) * (I * CellH - 256) - Sin(A) * (J * CellW - 256);
      Dis.SetDisplacement(J,I,DX,DY,HGEDISP_CENTER);
      Col := Trunc((Cos(R + T * 4) + 1) * 40);
      Dis.SetColor(J,I,($FF shl 24) or (Col shl 16) or ((Col div 2) shl 8));
    end;
  Result := False;
end;

function RenderFunc: Boolean;
var
  I, J: Integer;
  DX1, DY1, DX2, DY2: Single;
begin
  Engine.Gfx_BeginScene;
  Engine.Gfx_Clear(0);
  Dis.Render(MeshX,MeshY);
  SmallFont.PrintF(10,10,HGETEXT_LEFT,
    'Cursor Left/Right: change number of columns (%d)'#13+
    'Cursor Up/Down: change number of rows (%d)'#13+
    'Press spacebar to toggle grid display',[Cols,Rows]);

  if ShowGrid then
    for I := 0 to Rows - 2 do
      for J := 0 to Cols - 2 do begin
        Dis.GetDisplacement(J,I,DX1,DY1,HGEDISP_TOPLEFT);
        Dis.GetDisplacement(J+1,I,DX2,DY2,HGEDISP_TOPLEFT);
        Engine.Gfx_RenderLine(MeshX + DX1,MeshY + DY1,MeshX + DX2,MeshY + DY2);
        Dis.GetDisplacement(J,I+1,DX2,DY2,HGEDISP_TOPLEFT);
        Engine.Gfx_RenderLine(MeshX + DX1,MeshY + DY1,MeshX + DX2,MeshY + DY2);
      end;

  Engine.Gfx_EndScene;
  Result := False;
end;

procedure Test;
begin
  Engine.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,RenderFunc);
  T := 0; ShowGrid := True;
  Texture := Engine.Texture_Load('texture.jpg');

  CreateDistortionMesh(16,16);

  while Running do ;

  Dis := nil;
  Texture := nil;

  Engine.System_SetState(HGE_FRAMEFUNC,DefaultFrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,nil);
end;

initialization
  RegisterTest('Flexible grid mesh','DistortionMesh\UDistortionMesh',Test,[toManualGfx]);

end.
