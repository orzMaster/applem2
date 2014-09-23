program HGE_Tut06;
(*
** Haaf's Game Engine 1.7
** Copyright (C) 2003-2007, Relish Games
** hge.relishgames.com
**
** Tutorial 06 - Creating menus
*
** Delphi conversion by Erik van Bilsen
*)

{$R *.res}

uses
  Windows,
  Math,
  HGE,
  HGEGUI,
  HGEFont,
  HGESprite,
  MenuItem in 'MenuItem.pas';

// Copy the files "menu.wav", "font1.fnt", "font1.png", "cursor.png",
// "bg.png" and "cursor.png" from the folder "precompiled"
// to the folder with executable file. Also copy
// bass.dll to the same folder.

// Pointer to the HGE interface.
// Helper classes require this to work.
var
  HGE: IHGE = nil;

// Some resource handles
var
  Snd: IEffect;
  Tex: ITexture;
  Quad: THGEQuad;

// Pointers to the HGE objects we will use
var
  GUI: IHGEGUI;
  Fnt: IHGEFont;
  Spr: IHGESprite;

var
  T: Single = 0;
  LastId: Integer = 0;

function FrameFunc: Boolean;
var
  DT, TX, TY: Single;
  Id: INteger;
begin
  DT := HGE.Timer_GetDelta;

  // If ESCAPE was pressed, tell the GUI to finish

  if (HGE.Input_GetKeyState(HGEK_ESCAPE)) then begin
    LastId := 5;
    GUI.Leave;
  end;

  // We update the GUI and take an action if
  // one of the menu items was selected
  Id := GUI.Update(DT);
  if (Id = -1) then begin
    case LastId of
      1..4:
         begin
           GUI.SetFocus(1);
           GUI.Enter;
         end;
      5: begin
           Result := True;
           Exit;
         end;
    end;
  end else if (Id <> 0) then begin
    LastId := Id;
    GUI.Leave;
  end;

  // Here we update our background animation
  T := T + DT;
  TX := 50 * Cos(T / 60);
  TY := 50 * Sin(T / 60);

  Quad.V[0].TX := TX;        Quad.V[0].TY := TY;
  Quad.V[1].TX := TX+800/64; Quad.V[1].TY := TY;
  Quad.V[2].TX := TX+800/64; Quad.V[2].TY := TY+600/64;
  Quad.V[3].TX := TX;        Quad.V[3].TY := TY+600/64;

  Result := False;
end;

function RenderFunc: Boolean;
begin
  // Render graphics
  HGE.Gfx_BeginScene;
  HGE.Gfx_RenderQuad(Quad);
  GUI.Render;
  Fnt.SetColor($FFFFFFFF);
  Fnt.PrintF(5,5,HGETEXT_LEFT,'dt:%.3f'#13'FPS:%d',
    [HGE.Timer_GetDelta,HGE.Timer_GetFPS]);
  HGE.Gfx_EndScene;

  Result := False;
end;

procedure Main;
var
  I: Integer;
begin
  HGE := HGECreate(HGE_VERSION);

  HGE.System_SetState(HGE_LOGFILE,'hge_tut06.log');
  HGE.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  HGE.System_SetState(HGE_RENDERFUNC,RenderFunc);
  HGE.System_SetState(HGE_TITLE,'HGE Tutorial 06 - Creating menus');
  HGE.System_SetState(HGE_WINDOWED,True);
  HGE.System_SetState(HGE_SCREENWIDTH,800);
  HGE.System_SetState(HGE_SCREENHEIGHT,600);
  HGE.System_SetState(HGE_SCREENBPP,32);

  if (HGE.System_Initiate) then begin
    // Load sound and texture
    Quad.Tex := HGE.Texture_Load('bg.png');
    Tex := HGE.Texture_Load('cursor.png');
    Snd := HGE.Effect_Load('menu.wav');
    if (Quad.Tex = nil) or (Tex = nil) or (Snd = nil) then begin
      // If one of the data files is not found, display
      // an error message and shutdown.
      MessageBox(0,'Can''t load BG.PNG, CURSOR.PNG or MENU.WAV','Error',MB_OK or MB_ICONERROR or MB_APPLMODAL);
      HGE.System_Shutdown();
      HGE := nil;
      Exit;
    end;

    // Set up the quad we will use for background animation
    Quad.Blend := BLEND_ALPHABLEND or BLEND_COLORMUL or BLEND_NOZWRITE;

    for I := 0 to 3 do begin
      // Set up Z-coordinate of vertices
      Quad.V[I].Z := 0.5;
      // Set up color. The format of DWORD Col is 0xAARRGGBB
      Quad.V[I].Col := $FFFFFFFF;
    end;

    Quad.V[0].X := 0;   Quad.V[0].Y := 0;
    Quad.V[1].X := 800; Quad.V[1].Y := 0;
    Quad.V[2].X := 800; Quad.V[2].Y := 600;
    Quad.V[3].X := 0;   Quad.V[3].Y := 600;

    // Load the font, create the cursor sprite
    Fnt := THGEFont.Create('font1.fnt');
    Spr := THGESprite.Create(Tex,0,0,32,32);

    // Create and initialize the GUI
    GUI := THGEGUI.Create;

    GUI.AddCtrl(THGEGUIMenuItem.Create(1,Fnt,Snd,400,200,0.0,'Play'));
    GUI.AddCtrl(THGEGUIMenuItem.Create(2,Fnt,Snd,400,240,0.1,'Options'));
    GUI.AddCtrl(THGEGUIMenuItem.Create(3,Fnt,Snd,400,280,0.2,'Instructions'));
    GUI.AddCtrl(THGEGUIMenuItem.Create(4,Fnt,Snd,400,320,0.3,'Credits'));
    GUI.AddCtrl(THGEGUIMenuItem.Create(5,Fnt,Snd,400,360,0.4,'Exit'));

    GUI.SetNavMode(HGEGUI_UPDOWN or HGEGUI_CYCLED);
    GUI.SetCursor(Spr);
    GUI.SetFocus(1);
    GUI.Enter;

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
