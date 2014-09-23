program HGE_Tut08;
(*
** Haaf's Game Engine 1.7
** Copyright (C) 2003-2007, Relish Games
** hge.relishgames.com
**
** hge_tut08 - The Big Calm
*
** Delphi conversion by Erik van Bilsen
*)

{$R *.res}

uses
  Windows,
  Math,
  HGE,
  HGEFont,
  HGESprite,
  HGEDistort,
  HGEColor;

// Copy the files "font2.fnt", "font2.png",
// and "objects.png" from the folder "precompiled" to
// the folder with executable file.

// smaller sun & moon, underwater
// moon shape, hide stars behind the moon


// Pointer to the HGE interface.
// Helper classes require this to work.
var
  HGE: IHGE = nil;
  Fnt: IHGEFont = nil;

// Simulation constants
const
  SCREEN_WIDTH    = 800;
  SCREEN_HEIGHT    = 600;
  NUM_STARS        = 100;
  SEA_SUBDIVISION = 16;

  SKY_HEIGHT      = SCREEN_HEIGHT * 0.6;
  STARS_HEIGHT    = SKY_HEIGHT * 0.9;
  ORBITS_RADIUS    = SCREEN_WIDTH * 0.43;

const
  SkyTopColors: array [0..2] of Longword = ($FF15092A, $FF6C6480, $FF89B9D0);
  SkyBtmColors: array [0..2] of Longword = ($FF303E57, $FFAC7963, $FFCAD7DB);
  SeaTopColors: array [0..2] of Longword = ($FF3D546B, $FF927E76, $FF86A2AD);
  SeaBtmColors: array [0..2] of Longword = ($FF1E394C, $FF2F4E64, $FF2F4E64);

const
  Seq: array [0..8] of Integer = (0, 0, 1, 2, 2, 2, 1, 0, 0);

// Simulation resource handles

var
  TexObjects: ITexture;
  Sky, Sun, Moon, Glow, SeaGlow, Star: IHGESprite;
  Sea: IHGEDistortionMesh;
  ColWhite: THGEColor;

// Simulation state variables
var
  Time: Single;  // 0-24 hrs
  Speed: Single; // hrs per second
  SeqId: Integer;
  SeqResidue: Single;

  StarX, StarY, StarS, StarA: array [0..NUM_STARS - 1] of Single; // X, Y, Scale, Alpha

  SeaP: array [0..SEA_SUBDIVISION - 1] of Single; // phase shift array

  ColSkyTop, ColSkyBtm, ColSeaTop, ColSeaBtm: THGEColor;
  ColSun, ColSunGlow, ColMoon, ColMoonGlow, ColSeaGlow: THGEColor;

  SunX, SunY, SunS, SunGlowS: Single;
  MoonX, MoonY, MoonS, MoonGlowS: Single;
  SeaGlowX, SeaGlowSX, SeaGlowSY: Single;

// Simulation methods

function GetTime: Single;
var
  SysTime: TSystemTime;
begin
  GetLocalTime(SysTime);
  Result := SysTime.wSecond;
  Result := SysTime.wMinute + (Result / 60);
  Result := SysTime.wHour + (Result / 60);
end;

function InitSimulation: Boolean;
var
  I: Integer;
begin
  Result := False;

  // Load texture
  TexObjects := HGE.Texture_Load('objects.png');
  if (TexObjects = nil) then
    Exit;

  // Create sprites
  Sky := THGESprite.Create(nil,0,0,SCREEN_WIDTH,SKY_HEIGHT);
  Sea := THGEDistortionMesh.Create(SEA_SUBDIVISION,SEA_SUBDIVISION);
  Sea.SetTextureRect(0,0,SCREEN_WIDTH,SCREEN_HEIGHT - SKY_HEIGHT);

  Sun := THGESprite.Create(TexObjects,81,0,114,114);
  Sun.SetHotSpot(57,57);
  Moon := THGESprite.Create(TexObjects,0,0,81,81);
  Moon.SetHotSpot(40,40);
  Star := THGESprite.Create(TexObjects,72,81,9,9);
  Star.SetHotSpot(5,5);

  Glow := THGESprite.Create(TexObjects,128,128,128,128);
  Glow.SetHotSpot(64,64);
  Glow.SetBlendMode(BLEND_COLORADD or BLEND_ALPHABLEND or BLEND_NOZWRITE);
  SeaGlow := THGESprite.Create(TexObjects,128,224,128,32);
  SeaGlow.SetHotSpot(64,0);
  SeaGlow.SetBlendMode(BLEND_COLORADD or BLEND_ALPHAADD or BLEND_NOZWRITE);

  // Initialize simulation state
  ColWhite.SetHWColor($FFFFFFFF);
  Time := GetTime;
  Speed := 0;

  for I := 0 to NUM_STARS - 1 do begin
    StarX[I] := HGE.Random_Float(0,SCREEN_WIDTH);
    StarY[I] := HGE.Random_Float(0,STARS_HEIGHT);
    StarS[I] := HGE.Random_Float(0.1,0.7);
  end;

  for I := 0 to SEA_SUBDIVISION - 1 do // sea waves phase shifts
    SeaP[I] := I + HGE.Random_Float(-15,15);

  // Systems are ready now!

  Result := True;
end;

procedure DoneSimulation;
begin
  { Resources are released automatically in Delphi version }
end;

procedure UpdateSimulation;
const
  CellW = SCREEN_WIDTH / (SEA_SUBDIVISION - 1);
var
  I, J, K: Integer;
  Zenith, A, DY, FTime: Single;
  PosX, S1, S2: Single;
  Col1, Col2: THGEColor;
  LWCol1, LWCol2: Longword;
begin
  // Update time of day
  if (Speed = 0) then
    Time := GetTime
  else begin
    Time := Time + HGE.Timer_GetDelta * Speed;
    if (Time >= 24) then
      Time := Time - 24;
  end;

  SeqId := Trunc(Time / 3);
  SeqResidue := (Time / 3) - SeqId;
  Zenith := -(Time / 12 * M_PI - M_PI_2);

  // Interpolate sea and sky colors

  Col1.SetHWColor(SkyTopColors[Seq[SeqId]]);
  Col2.SetHWColor(SkyTopColors[Seq[SeqId+1]]);
  ColSkyTop := Col2 * SeqResidue + Col1 * (1.0 - SeqResidue);

  Col1.SetHWColor(SkyBtmColors[Seq[SeqId]]);
  Col2.SetHWColor(SkyBtmColors[Seq[SeqId+1]]);
  ColSkyBtm := Col2 * SeqResidue + Col1 * (1.0 - SeqResidue);

  Col1.SetHWColor(SeaTopColors[Seq[SeqId]]);
  Col2.SetHWColor(SeaTopColors[Seq[SeqId+1]]);
  ColSeaTop := Col2 * SeqResidue + Col1 * (1.0 - SeqResidue);

  Col1.SetHWColor(SeaBtmColors[Seq[SeqId]]);
  Col2.SetHWColor(SeaBtmColors[Seq[SeqId+1]]);
  ColSeaBtm := Col2 * SeqResidue + Col1 * (1.0 - SeqResidue);

  // Update stars

  if (SeqId >= 6) or (SeqId < 2) then
    for I := 0 to NUM_STARS - 1 do begin
      A := 1.0 - StarY[I] / STARS_HEIGHT;
      A := A * HGE.Random_Float(0.6,1.0);
      if (SeqId >= 6) then
        A := A * Sin((Time - 18.0) / 6.0 * M_PI_2)
      else
        A := A * Sin((1.0 - Time / 6.0) * M_PI_2);
      StarA[I] := A;
    end;

  // Calculate sun position, scale and colors

  if (SeqId = 2) then
    A := Sin(SeqResidue * M_PI_2)
  else if (SeqId = 5) then
    A := Cos(SeqResidue * M_PI_2)
  else if (SeqId > 2) and (SeqId < 5) then
    A := 1.0
  else
    A := 0.0;

  ColSun.SetHWColor($FFEAE1BE);
  ColSun := ColSun * (1 - A) + ColWhite * A;

  A := (Cos(Time / 6.0 * M_PI) + 1.0) / 2.0;
  if (SeqId >= 2) and (SeqId <= 6) then begin
    ColSunGlow := ColWhite * A;
    ColSunGlow.A := 1.0;
  end else
    ColSunGlow.SetHWColor($FF000000);

  SunX := SCREEN_WIDTH * 0.5 + Cos(Zenith) * ORBITS_RADIUS;
  SunY := SKY_HEIGHT * 1.2 + Sin(Zenith) * ORBITS_RADIUS;
  SunS := 1.0 - 0.3 * Sin((Time - 6.0) / 12.0 * M_PI);
  SunGlowS := 3.0 * (1.0 - A) + 3.0;

  // Calculate moon position, scale and colors

  if (SeqId >= 6) then
    A := Sin((Time - 18.0) / 6.0 * M_PI_2)
  else
    A := Sin((1.0 - Time / 6.0) * M_PI_2);
  ColMoon.SetHWColor($20FFFFFF);
  ColMoon := ColMoon * (1 - A) + ColWhite * A;

  ColMoonGlow := ColWhite;
  ColMoonGlow.A := 0.5 * A;

  MoonX := SCREEN_WIDTH * 0.5 + Cos(Zenith - M_PI) * ORBITS_RADIUS;
  MoonY := SKY_HEIGHT * 1.2 + Sin(Zenith - M_PI) * ORBITS_RADIUS;
  MoonS := 1.0 - 0.3 * Sin((Time + 6.0) / 12.0 * M_PI);
  MoonGlowS := A * 0.4 + 0.5;

  // Calculate sea glow

  if (Time > 19.0) or (Time < 4.5) then begin // moon
    A := 0.2; // intensity
    if (Time > 19.0) and (Time < 20.0) then
      A := A * (Time - 19.0)
    else if (Time > 3.5) and (Time < 4.5) then
      A := A * (1.0 - (Time - 3.5));

    ColSeaGlow := ColMoonGlow;
    ColSeaGlow.A := A;
    SeaGlowX := MoonX;
    SeaGlowSX := MoonGlowS * 3.0;
    SeaGlowSY := MoonGlowS * 2.0;
  end else if (Time > 6.5) and (Time < 19.0) then begin// sun
    A := 0.3; // intensity
    if (Time < 7.5) then
      A := A * (Time - 6.5)
    else if (Time > 18.0) then
      A := A * (1.0 - (Time - 18.0));

    ColSeaGlow := ColSunGlow;
    ColSeaGlow.A := A;
    SeaGlowX := SunX;
    SeaGlowSX := SunGlowS;
    SeaGlowSY := SunGlowS * 0.6;
  end else
    ColSeaGlow.A := 0.0;

  // Move waves and update sea color

  for I := 1 to SEA_SUBDIVISION - 2 do begin
    A := I / (SEA_SUBDIVISION - 1);
    Col1 := ColSeaTop * (1 - A) + ColSeaBtm * A;
    LWCol1 := Col1.GetHWColor;
    FTime := 2.0 * HGE.Timer_GetTime;
    A := A * 20;

    for J := 0 to SEA_SUBDIVISION - 1 do begin
      Sea.SetColor(J,I,LWCol1);

      DY := A * Sin(SeaP[I] + (J / (SEA_SUBDIVISION - 1) - 0.5) * M_PI * 16.0 - FTime);
      Sea.SetDisplacement(J,I,0.0,DY,HGEDISP_NODE);
    end;
  end;

  LWCol1 := ColSeaTop.GetHWColor;
  LWCol2 := ColSeaBtm.GetHWColor;

  for J := 0 to SEA_SUBDIVISION - 1 do begin
    Sea.SetColor(J,0,LWCol1);
    Sea.SetColor(J,SEA_SUBDIVISION - 1,LWCol2);
  end;

  // Calculate light path

  if (Time > 19.0) or (Time < 5.0) then begin // moon
    A := 0.12; // intensity
    if (Time > 19.0) and (Time < 20.0) then
      A := A * (Time - 19.0)
    else if (Time > 4.0) and (Time < 5.0) then
      A := A * (1.0 - (Time - 4.0));
    PosX := MoonX;
  end  else if (Time > 7.0) and (Time < 17.0) then begin// sun
    A := 0.14; // intensity
    if (Time < 8.0) then
      A := A * (Time - 7.0)
    else if (Time > 16.0) then
      A := A * (1.0 - (Time - 16.0));
    PosX := SunX;
  end  else begin
    A := 0.0;
    PosX := 0;
  end;

  if (A <> 0.0) then begin
    K := Floor(PosX / CellW);
    S1 := (1.0 - (PosX - K * CellW) / CellW);
    S2 := (1.0- ((K + 1) * CellW - PosX) / CellW);

    if (S1 > 0.7) then
      S1 := 0.7;
    if (S2 > 0.7) then
      S2 := 0.7;

    S1 := S1 *A;
    S2 := S2 *A;

    I := 0;
    while (I < SEA_SUBDIVISION) do begin
      A := Sin(I / (SEA_SUBDIVISION - 1) * M_PI_2);

      Col1.SetHWColor(Sea.GetColor(K,I));
      Col1 := Col1 + (ColSun * S1 * (1 - A));
      Col1.Clamp;
      Sea.SetColor(K,I,Col1.GetHWColor);

      Col1.SetHWColor(Sea.GetColor(K + 1,I));
      Col1 := Col1 + (ColSun * S2 * (1 - A));
      Col1.Clamp;
      Sea.SetColor(K + 1,I,Col1.GetHWColor);

      Inc(I,2);
    end;
  end;
end;

procedure RenderSimulation;
var
  I: Integer;
begin
  // Render sky

  Sky.SetColor(ColSkyTop.GetHWColor,0);
  Sky.SetColor(ColSkyTop.GetHWColor,1);
  Sky.SetColor(ColSkyBtm.GetHWColor,2);
  Sky.SetColor(ColSkyBtm.GetHWColor,3);
  Sky.Render(0,0);

  // Render stars

  if (SeqId >= 6) or (SeqId < 2) then
    for I := 0 to NUM_STARS - 1 do begin
      Star.SetColor((Trunc(StarA[I] * 255.0) shl 24) or $FFFFFF);
      Star.RenderEx(StarX[I],StarY[I],0.0,StarS[I]);
    end;

  // Render sun

  Glow.SetColor(ColSunGlow.GetHWColor);
  Glow.RenderEx(SunX,SunY,0.0,SunGlowS);
  Sun.SetColor(ColSun.GetHWColor);
  Sun.RenderEx(SunX,SunY,0.0,SunS);

  // Render moon

  Glow.SetColor(ColMoonGlow.GetHWColor);
  Glow.RenderEx(MoonX,MoonY,0.0,MoonGlowS);
  Moon.SetColor(ColMoon.GetHWColor);
  Moon.RenderEx(MoonX,MoonY,0.0,MoonS);

  // Render sea

  Sea.Render(0,SKY_HEIGHT);
  SeaGlow.SetColor(ColSeaGlow.GetHWColor);
  SeaGlow.RenderEx(SeaGlowX,SKY_HEIGHT,0.0,SeaGlowSX,SeaGlowSY);
end;


///////////////////////// Implementation ///////////////////////////

function FrameFunc: Boolean;
begin
  // Process keys

  case HGE.Input_GetKey of
    HGEK_0: Speed := 0.0;
    HGEK_1: Speed := 0.1;
    HGEK_2: Speed := 0.2;
    HGEK_3: Speed := 0.4;
    HGEK_4: Speed := 0.8;
    HGEK_5: Speed := 1.6;
    HGEK_6: Speed := 3.2;
    HGEK_7: Speed := 6.4;
    HGEK_8: Speed := 12.8;
    HGEK_9: Speed := 25.6;
    HGEK_ESCAPE:
      begin
        Result := True;
        Exit;
      end;
  end;

  // Update scene

  UpdateSimulation;

  Result := False;
end;

function RenderFunc: Boolean;
var
  Hrs, Mins, Secs: Integer;
  Tmp: Single;
begin
  // Calculate display time

  Hrs := Floor(Time);
  Tmp := (Time - Hrs) * 60;
  Mins := Floor(Tmp);
  Secs := Floor((Tmp - Mins) * 60);

  // Render scene

  HGE.Gfx_BeginScene;
  RenderSimulation;
  Fnt.PrintF(7,7,HGETEXT_LEFT,'Keys 1-9 to adjust simulation speed, 0 - real time'#13+
    'FPS: %d',[HGE.Timer_GetFPS]);
  Fnt.PrintF(SCREEN_WIDTH - 50,7,HGETEXT_LEFT,'%2d:%2d:%2d',[Hrs,Mins,Secs]);
  HGE.Gfx_EndScene;

  Result := False;
end;

procedure Main;
begin
  HGE := HGECreate(HGE_VERSION);

  HGE.System_SetState(HGE_LOGFILE,'hge_tut08.log');
  HGE.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  HGE.System_SetState(HGE_RENDERFUNC,RenderFunc);
  HGE.System_SetState(HGE_TITLE,'HGE Tutorial 08 - The Big Calm');
  HGE.System_SetState(HGE_USESOUND,False);
  HGE.System_SetState(HGE_WINDOWED,True);
  HGE.System_SetState(HGE_SCREENWIDTH,SCREEN_WIDTH);
  HGE.System_SetState(HGE_SCREENHEIGHT,SCREEN_HEIGHT);
  HGE.System_SetState(HGE_SCREENBPP,32);

  if (HGE.System_Initiate) then begin
    Fnt := THGEFont.Create('font2.fnt');

    if (not InitSimulation) then begin
      // If one of the data files is not found, display an error message and shutdown
      MessageBox(0,'Can''t load resources. See log for details.','Error',MB_OK or MB_ICONERROR or MB_APPLMODAL);
      HGE.System_Shutdown;
      Exit;
    end;

    // Let's rock now!
    HGE.System_Start;

    DoneSimulation;
  end else
    MessageBox(0,PChar(HGE.System_GetErrorMessage),'Error',MB_OK or MB_ICONERROR or MB_SYSTEMMODAL);

  HGE.System_Shutdown;
  HGE := nil;
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  Main;
end.
