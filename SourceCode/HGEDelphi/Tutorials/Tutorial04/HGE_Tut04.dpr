program HGE_Tut04;
(*
** Haaf's Game Engine 1.7
** Copyright (C) 2003-2007, Relish Games
** hge.relishgames.com
**
** hge_tut04 - Using render targets
**
** Delphi conversion by Erik van Bilsen
*)

{$R *.res}

uses
  Windows,
  HGE,
  HGESprite,
  HGEFont,
  HGEParticle;

// Copy the files "particles.png", "menu.wav",
// "font1.fnt", "font1.png" and "trail.psi" from
// the folder "precompiled" to the folder with
// executable file. Also copy bass.dll
// to the same folder.

// Pointer to the HGE interface.
// Helper classes require this to work.
var
  HGE: IHGE = nil;

// Pointers to the HGE objects we will use
var
  Spr: IHGESprite;
  Spt: IHGESprite;
  Tar: IHGESprite;
  Fnt: IHGEFont;
  Par: IHGEParticleSystem;

// Handles for HGE resourcces
var
  Tex: ITexture;
  Snd: IEffect;
  Target: ITarget;

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
  Pan := Trunc((X - 256) / 2.56);
  Pitch := (DX * DX + DY * DY) * 0.0005 + 0.2;
  Snd.PlayEx(100,Pan,Pitch);
end;

// This function will be called by HGE when
// render targets were lost and have been just created
// again. We use it here to update the render
// target's texture handle that changes during recreation.
function GfxRestoreFunc: Boolean;
begin
  if Assigned(Tar) and Assigned(Target) then
    Tar.SetTexture(Target.GetTexture);
  Result := False;
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
  if (X > 496) then begin
    X := 496 - (X - 496);
    DX := -DX;
    Boom;
  end;
  if (X < 16) then begin
    X := 16 + 16 - X;
    DX := -DX;
    Boom;
  end;
  if (Y > 496) then begin
    Y := 496 - (Y - 496);
    DY := -DY;
    Boom;
  end;
  if (Y < 16) then begin
    Y := 16 + 16 - Y;
    DY := -DY;
    Boom;
  end;

  // Update particle system
  Par.Info.Emission := Trunc(DX * DX + DY * DY);
  Par.MoveTo(X,Y);
  Par.Update(DT);

  // Continue execution
  Result := False;
end;

function RenderFunc: Boolean;
var
  I: Integer;
begin
  // Render graphics to the texture
  HGE.Gfx_BeginScene(Target);
  HGE.Gfx_Clear(0);
  Par.Render;
  Spr.Render(X,Y);
  HGE.Gfx_EndScene;

  // Now put several instances of the rendered texture to the screen
  HGE.Gfx_BeginScene;
  HGE.Gfx_Clear(0);
  for I := 0 to 5 do begin
    Tar.SetColor($FFFFFF or (((5 - I) * 40 + 55) shl 24));
    Tar.RenderEx(I * 100,I * 50,I * M_PI / 8,1 - I * 0.1);
  end;

  Fnt.PrintF(5,5,HGETEXT_LEFT,'dt:%.3f'#13'FPS:%d (constant)',
    [HGE.Timer_GetDelta,HGE.Timer_GetFPS]);
  HGE.Gfx_EndScene();

  Result := False;
end;

procedure Main;
begin
  HGE := HGECreate(HGE_VERSION);

  HGE.System_SetState(HGE_LOGFILE,'hge_tut04.log');
  HGE.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  HGE.System_SetState(HGE_RENDERFUNC,RenderFunc);
  HGE.System_SetState(HGE_GFXRESTOREFUNC,GfxRestoreFunc);
  HGE.System_SetState(HGE_TITLE,'HGE Tutorial 04 - Using render targets');
  HGE.System_SetState(HGE_FPS,100);
  HGE.System_SetState(HGE_WINDOWED,True);
  HGE.System_SetState(HGE_SCREENWIDTH,800);
  HGE.System_SetState(HGE_SCREENHEIGHT,600);
  HGE.System_SetState(HGE_SCREENBPP,32);

  if (HGE.System_Initiate) then begin
    // Load sound and texture
    Snd := HGE.Effect_Load('menu.wav');
    Tex := HGE.Texture_Load('particles.png');
    if (Snd = nil) or (Tex = nil) then begin
      // If one of the data files is not found, display
      // an error message and shutdown.
      MessageBox(0,'Can''t load one of the following files:'#13#10 +
        'MENU.WAV, PARTICLES.PNG, FONT1.FNT, FONT1.PNG, TRAIL.PSI','Error',MB_OK or MB_ICONERROR or MB_APPLMODAL);
      HGE.System_Shutdown();
      HGE := nil;
      Exit;
    end;

    // Create and set up a sprite
    Spr := THGESprite.Create(Tex,96,64,32,32);
    Spr.SetColor($FFFFA000);
    Spr.SetHotSpot(16,16);

    // Load a font
    Fnt := THGEFont.Create('Font1.fnt');

    // Create and set up a particle system
    Spt := THGESprite.Create(Tex,32,32,32,32);
    Spt.SetBlendMode(BLEND_COLORMUL or BLEND_ALPHAADD or BLEND_NOZWRITE);
    Spt.SetHotSpot(16,16);
    Par := THGEParticleSystem.Create('trail.psi',Spt);
    Par.Fire;

    // Create a render target and a sprite for it
    Target := HGE.Target_Create(512,512,False);
    Tar := THGESprite.Create(Target.GetTexture,0,0,512,512);
    Tar.SetBlendMode(BLEND_COLORMUL or BLEND_ALPHAADD or BLEND_NOZWRITE);

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
