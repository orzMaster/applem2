program HGE_Tut05;
(*
** Haaf's Game Engine 1.7
** Copyright (C) 2003-2007, Relish Games
** hge.relishgames.com
**
** hge_tut05 - Using distortion mesh
**
** Delphi conversion by Erik van Bilsen
*)

{$R *.res}

uses
  Windows,
  Math,
  HGE,
  HGEFont,
  HGEDistort;

// Copy the files "texture.jpg", "font1.fnt" and "font1.png" from
// the folder "precompiled" to the folder with
// executable file.

// Pointer to the HGE interface.
// Helper classes require this to work.
var
  HGE: IHGE = nil;

// Pointers to the HGE objects we will use
var
  Dis: IHGEDistortionMesh;
  Fnt: IHGEFont;

// Handles for HGE resourcces
var
  Tex: ITexture;

// Some "gameplay" variables and constants
const
  Rows = 16;
  Cols = 16;
  CellW = 512 / (Cols - 1);
  CellH = 512 / (Rows - 1);
  MeshX = 144;
  MeshY = 44;

var
  T: Single = 0;
  Trans: Integer = 0;

function FrameFunc: Boolean;
var
  DT: Single;
  I, J, Col: Integer;
  R, A, DX, DY: Single;
begin
  DT := HGE.Timer_GetDelta;
  T := T + DT;

  // Process keys
  case HGE.Input_GetKey of
    HGEK_ESCAPE:
      begin
        Result := True;
        Exit;
      end;
    HGEK_SPACE:
      begin
        Inc(Trans);
        if (Trans > 2) then
          Trans := 0;
        Dis.Clear($FF000000);
      end;
  end;

  // Calculate new displacements and coloring for one of the three effects
  case Trans of
    0: begin
         for I := 1 to Rows - 2 do
           for J := 1 to Cols - 2 do
             Dis.SetDisplacement(J,I,Cos(T * 10 + (I + J) / 2) * 5,
               Sin(T * 10 + (I + J) / 2) * 5,HGEDISP_NODE);
       end;
    1: begin
         for I := 0 to Rows - 1 do
           for J := 1 to Cols - 2 do begin
             Dis.SetDisplacement(J,I,Cos(T * 5 + J / 2) * 15,0,HGEDISP_NODE);
             Col := Trunc((Cos(T * 5 + (I + J) / 2) + 1) * 35);
             Dis.SetColor(J,I,($FF shl 24) or (Col shl 16) or (Col shl 8) or Col);
           end;
       end;
    2: begin
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
       end;
  end;
  Result := False;
end;

function RenderFunc: Boolean;
begin
  // Render graphics
  HGE.Gfx_BeginScene;
  HGE.Gfx_Clear(0);
  Dis.Render(MeshX,MeshY);
  Fnt.PrintF(5,5,HGETEXT_LEFT,'dt:%.3f'#13'FPS:%d'#13#13'Use your'#13'SPACE!',
    [HGE.Timer_GetDelta,HGE.Timer_GetFPS]);
  HGE.Gfx_EndScene;

  Result := False;
end;

procedure Main;
begin
  HGE := HGECreate(HGE_VERSION);

  HGE.System_SetState(HGE_LOGFILE,'hge_tut05.log');
  HGE.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  HGE.System_SetState(HGE_RENDERFUNC,RenderFunc);
  HGE.System_SetState(HGE_TITLE,'HGE Tutorial 05 - Using distortion mesh');
  HGE.System_SetState(HGE_WINDOWED,True);
  HGE.System_SetState(HGE_SCREENWIDTH,800);
  HGE.System_SetState(HGE_SCREENHEIGHT,600);
  HGE.System_SetState(HGE_SCREENBPP,32);
  HGE.System_SetState(HGE_USESOUND,False);

  if (HGE.System_Initiate) then begin
    // Load texture
    Tex := HGE.Texture_Load('texture.jpg');
    if (Tex = nil) then begin
      // If one of the data files is not found, display
      // an error message and shutdown.
      MessageBox(0,'Can''t load TEXTURE.JPG','Error',MB_OK or MB_ICONERROR or MB_APPLMODAL);
      HGE.System_Shutdown();
      HGE := nil;
      Exit;
    end;

    // Create a distortion mesh
    Dis := THGEDistortionMesh.Create(Cols,Rows);
    Dis.SetTexture(Tex);
    Dis.SetTextureRect(0,0,512,512);
    Dis.SetBlendMode(BLEND_COLORADD or BLEND_ALPHABLEND or BLEND_ZWRITE);
    Dis.Clear($FF000000);

    // Load a font
    Fnt := THGEFont.Create('Font1.fnt');


    // Let's rock now!
    HGE.System_Start;
  end else
    MessageBox(0,PChar(HGE.System_GetErrorMessage),'Error',MB_OK or MB_ICONERROR or MB_SYSTEMMODAL);

  HGE.System_Shutdown;
  HGE := nil;
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  Main;
end.
