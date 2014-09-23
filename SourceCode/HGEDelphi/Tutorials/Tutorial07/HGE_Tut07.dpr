program HGE_Tut07;
(*
** Haaf's Game Engine 1.7
** Copyright (C) 2003-2007, Relish Games
** hge.relishgames.com
**
** hge_tut07 - Thousand of Hares
*
** Delphi conversion by Erik van Bilsen
*)

{$R *.res}

uses
  Windows,
  Math,
  HGE,
  HGESprite,
  HGEFont;

// Copy the files "font2.fnt", "font2.png", "bg2.png"
// and "zazaka.png" from the folder "precompiled" to
// the folder with executable file.

const
  SCREEN_WIDTH  = 800;
  SCREEN_HEIGHT = 600;

  MIN_OBJECTS    = 100;
  MAX_OBJECTS   = 2000;

type
  TSprObject = record
    X, Y: Single;
    DX, DY: Single;
    Scale, Rot: Single;
    DScale, DRot: Single;
    Color: Longword;
  end;

var
  Objects: array of TSprObject;
  NumObjects: Integer;
  Blend: Integer;

// Pointer to the HGE interface.
// Helper classes require this to work.
var
  HGE: IHGE = nil;

// Some resource handles
var
  Tex, BGTex: ITexture;
  Spr, BGSpr: IHGESprite;
  Fnt: IHGEFont;

// Set up blending mode for the scene
procedure SetBlend(const NewBlend: Integer);
const
  SprBlend: array [0..4] of Longword = (
    BLEND_COLORMUL or BLEND_ALPHABLEND or BLEND_NOZWRITE,
    BLEND_COLORADD or BLEND_ALPHABLEND or BLEND_NOZWRITE,
    BLEND_COLORMUL or BLEND_ALPHABLEND or BLEND_NOZWRITE,
    BLEND_COLORMUL or BLEND_ALPHAADD   or BLEND_NOZWRITE,
    BLEND_COLORMUL or BLEND_ALPHABLEND or BLEND_NOZWRITE);
  FntColor: array [0..4] of Longword = (
    $FFFFFFFF, $FF000000, $FFFFFFFF, $FF000000, $FFFFFFFF);
  SprColors: array [0..4,0..4] of Longword = (
    ($FFFFFFFF, $FFFFE080, $FF80A0FF, $FFA0FF80, $FFFF80A0),
    ($FF000000, $FF303000, $FF000060, $FF006000, $FF600000),
    ($80FFFFFF, $80FFE080, $8080A0FF, $80A0FF80, $80FF80A0),
    ($80FFFFFF, $80FFE080, $8080A0FF, $80A0FF80, $80FF80A0),
    ($40202020, $40302010, $40102030, $40203010, $40102030));
var
  I: Integer;
begin
  if (NewBlend > 4) then
    Blend := 0
  else
    Blend := NewBlend;
  Spr.SetBlendMode(SprBlend[Blend]);
  Fnt.SetColor(FntColor[Blend]);
  for I := 0 to MAX_OBJECTS - 1 do
    Objects[I].Color := SprColors[Blend,HGE.Random_Int(0,4)];
end;

function FrameFunc: Boolean;
var
  DT: Single;
  I: INteger;
begin
  DT := HGE.Timer_GetDelta;

  // Process keys
  case HGE.Input_GetKey of
    HGEK_UP:
      if (NumObjects < MAX_OBJECTS) then
        Inc(NumObjects,100);
    HGEK_DOWN:
      if (NumObjects > MIN_OBJECTS) then
        Dec(NumObjects,100);
    HGEK_SPACE:
      SetBlend(Blend + 1);
    HGEK_ESCAPE:
      begin
        Result := True;
        Exit;
      end;
  end;

  // Update the scene
  for I := 0 to NumObjects - 1 do
    with Objects[I] do begin
      X := X + DX * DT;
      if (X > SCREEN_WIDTH) or (X < 0) then
        DX := -DX;

      Y := Y + DY * DT;
      if (Y > SCREEN_HEIGHT) or (Y < 0) then
        DY := -DY;

      Scale := Scale + DScale * DT;
      if (Scale > 2) or (Scale < 0.5) then
        DScale := -DScale;

      Rot := Rot + DRot * DT;
    end;

  Result := False;
end;

function RenderFunc: Boolean;
var
  I: Integer;
begin
  // Render graphics
  HGE.Gfx_BeginScene;
  BGSpr.Render(0,0);
  for I := 0 to NumObjects - 1 do
    with Objects[I] do begin
      Spr.SetColor(Color);
      Spr.RenderEx(X,Y,Rot,Scale);
    end;
  Fnt.PrintF(7,7,HGETEXT_LEFT,'UP and DOWN to adjust number of hares: %d'#13+
    'SPACE to change blending mode: %d'#13+
    'FPS: %d',[NumObjects,Blend,HGE.Timer_GetFPS]);
  HGE.Gfx_EndScene;
  Result := False;
end;

procedure Main;
var
  I: Integer;
begin
  HGE := HGECreate(HGE_VERSION);

  HGE.System_SetState(HGE_LOGFILE,'hge_tut07.log');
  HGE.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  HGE.System_SetState(HGE_RENDERFUNC,RenderFunc);
  HGE.System_SetState(HGE_TITLE,'HGE Tutorial 07 - Thousand of Hares');
  HGE.System_SetState(HGE_USESOUND,False);
  HGE.System_SetState(HGE_WINDOWED,True);
  HGE.System_SetState(HGE_SCREENWIDTH,SCREEN_WIDTH);
  HGE.System_SetState(HGE_SCREENHEIGHT,SCREEN_HEIGHT);
  HGE.System_SetState(HGE_SCREENBPP,32);

  if (HGE.System_Initiate) then begin
    // Load textures
    BGTex := HGE.Texture_Load('bg2.png');
    Tex := HGE.Texture_Load('zazaka.png');
    if (BGTex = nil) or (Tex = nil) then begin
      // If one of the data files is not found, display
      // an error message and shutdown.
      MessageBox(0,'Can''t load BG2.PNG or ZAZAKA.PNG','Error',MB_OK or MB_ICONERROR or MB_APPLMODAL);
      HGE.System_Shutdown();
      HGE := nil;
      Exit;
    end;

    // Load font, create sprites

    Fnt := THGEFont.Create('font2.fnt');
    Spr := THGESprite.Create(Tex,0,0,64,64);
    Spr.SetHotSpot(32,32);

    BGSpr := THGESprite.Create(BGTex,0,0,800,600);
    BGSpr.SetBlendMode(BLEND_COLORADD or BLEND_ALPHABLEND or BLEND_NOZWRITE);
    BGSpr.SetColor($FF000000,0);
    BGSpr.SetColor($FF000000,1);
    BGSpr.SetColor($FF000040,2);
    BGSpr.SetColor($FF000040,3);

    // Initialize objects list

    SetLength(Objects,MAX_OBJECTS);
    NumObjects := 1000;

    for I := 0 to MAX_OBJECTS - 1 do
      with Objects[I] do begin
        X := HGE.Random_Float(0,SCREEN_WIDTH);
        Y := HGE.Random_Float(0,SCREEN_HEIGHT);
        DX := HGE.Random_Float(-200,200);
        DY := HGE.Random_Float(-200,200);
        Scale := HGE.Random_Float(0.5,2);
        DScale := HGE.Random_Float(-1,1);
        Rot := HGE.Random_Float(0,M_PI * 2);
        DRot := HGE.Random_Float(-1,1);
      end;

    SetBlend(0);

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
