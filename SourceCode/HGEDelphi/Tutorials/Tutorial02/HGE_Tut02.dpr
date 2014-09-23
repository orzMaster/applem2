program HGE_Tut02;
(*
** Haaf's Game Engine 1.7
** Copyright (C) 2003-2007, Relish Games
** hge.relishgames.com
**
** hge_tut02 - Using input, sound and rendering
**
** Delphi conversion by Erik van Bilsen
*)

{$R *.res}

uses
  Windows, HGE;

// Copy the files "particles.png" and "menu.wav"
// from the folder "precompiled" to the folder with
// executable file. Also copy bass.dll
// to the same folder.

var
  HGE: IHGE = nil;

// Quad is the basic primitive in HGE
// used for rendering graphics.
// Quad contains 4 vertices, numbered
// 0 to 3 clockwise.
var
  Quad: THGEQuad;

// Handle for a sound effect
var
  Snd: IEffect;

// Some "gameplay" variables and constants
var
  X: Single = 100;
  Y: Single = 100;
  DX: Single = 0;
  DY: Single = 0;

const
  Speed = 90;
  Friction = 0.98;

// This function plays collision sound with
// parameters based on sprite position and speed
procedure Boom;
var
  Pan: Integer;
  Pitch: Single;
begin
  Pan := Trunc((X - 400) / 4);
  Pitch := (DX * DX + DY * DY) * 0.0005 + 0.2;
  Snd.PlayEx(100,Pan,Pitch);
end;

function FrameFunc: Boolean;
var
  DT: Single;
begin
  // Get the time elapsed since last call of FrameFunc().
  // This will help us to synchronize on different
  // machines and video modes.
  DT := HGE.Timer_GetDelta;

  // Process keys
  if (HGE.Input_GetKeyState(HGEK_ESCAPE)) then begin
    Result := True;
    Exit;
  end;
  if (HGE.Input_GetKeyState(HGEK_LEFT)) then
    DX := DX - Speed * DT;
  if (HGE.Input_GetKeyState(HGEK_RIGHT)) then
    DX := DX + Speed * DT;
  if (HGE.Input_GetKeyState(HGEK_UP)) then
    DY := DY - Speed * DT;
  if (HGE.Input_GetKeyState(HGEK_DOWN)) then
    DY := DY + Speed * DT;

  // Do some movement calculations and collision detection
  DX := DX * Friction;
  DY := DY * Friction;
  X := X + DX;
  Y := Y + DY;
  if (X > 784) then begin
    X := 784 - (X - 784);
    DX := -DX;
    Boom;
  end;
  if (X < 16) then begin
    X := 16 + 16 - X;
    DX := -DX;
    Boom;
  end;
  if (Y > 584) then begin
    Y := 584 - (Y - 584);
    DY := -DY;
    Boom;
  end;
  if (Y < 16) then begin
    Y := 16 + 16 - Y;
    DY := -DY;
    Boom;
  end;

  // Set up Quad's screen coordinates
  Quad.V[0].X := X - 16; Quad.V[0].Y :=Y - 16;
  Quad.V[1].X := X + 16; Quad.V[1].Y :=Y - 16;
  Quad.V[2].X := X + 16; Quad.V[2].Y :=Y + 16;
  Quad.V[3].X := X - 16; Quad.V[3].Y :=Y + 16;

  // Continue execution
  Result := False;
end;

// This function will be called by HGE when
// the application window should be redrawn.
// Put your rendering code here.
function RenderFunc: Boolean;
begin
  // Begin rendering quads.
  // This function must be called
  // before any actual rendering.
  HGE.Gfx_BeginScene;

  // Clear screen with black color
  HGE.Gfx_Clear(0);

  // Render quads here. This time just
  // one of them will serve our needs.
  HGE.Gfx_RenderQuad(Quad);

  // End rendering and update the screen
  HGE.Gfx_EndScene;

  // RenderFunc should always return false
  Result := False;
end;

procedure Main;
var
  I: Integer;
begin
  // Get HGE interface
  HGE := HGECreate(HGE_VERSION);

  // Set up log file, frame function, render function and window title
  HGE.System_SetState(HGE_LOGFILE,'hge_tut02.log');
  HGE.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  HGE.System_SetState(HGE_RENDERFUNC,RenderFunc);
  HGE.System_SetState(HGE_TITLE,'HGE Tutorial 02 - Using input, sound and rendering');

  // Set up video mode
  HGE.System_SetState(HGE_WINDOWED,True);
  HGE.System_SetState(HGE_SCREENWIDTH,800);
  HGE.System_SetState(HGE_SCREENHEIGHT,600);
  HGE.System_SetState(HGE_SCREENBPP,32);

  if (HGE.System_Initiate) then begin
    // Load sound and texture
    Snd := HGE.Effect_Load('menu.wav');
    Quad.Tex := HGE.Texture_Load('particles.png');
    if (Snd = nil) or (Quad.Tex = nil) then begin
      // If one of the data files is not found, display
      // an error message and shutdown.
      MessageBox(0,'Can''t load MENU.WAV or PARTICLES.PNG','Error',MB_OK or MB_ICONERROR or MB_APPLMODAL);
      HGE.System_Shutdown();
      HGE := nil;
      Exit;
    end;

    // Set up quad which we will use for rendering sprite
    Quad.Blend := BLEND_ALPHAADD or BLEND_COLORMUL or BLEND_ZWRITE;

    for I := 0 to 3 do begin
      // Set up z-coordinate of vertices
      Quad.V[I].Z := 0.5;
      // Set up color. The format of DWORD Col is 0xAARRGGBB
      Quad.V[I].Col := $FFFFA000;
    end;

    // Set up Quad's texture coordinates.
    // 0,0 means top left corner and 1,1 -
    // bottom right corner of the texture.
    Quad.V[0].TX :=  96.0 / 128.0; Quad.V[0].TY := 64.0 / 128.0;
    Quad.V[1].TX := 128.0 / 128.0; Quad.V[1].TY := 64.0 / 128.0;
    Quad.V[2].TX := 128.0 / 128.0; Quad.V[2].TY := 96.0 / 128.0;
    Quad.V[3].TX :=  96.0 / 128.0; Quad.V[3].TY := 96.0 / 128.0;

    // Let's rock now!
    HGE.System_Start;
  end else
    MessageBox(0,PChar(HGE.System_GetErrorMessage),'Error',MB_OK or MB_ICONERROR or MB_SYSTEMMODAL);

  // Clean up and shutdown
  HGE.System_Shutdown;
  HGE := nil;
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  Main;
end.
