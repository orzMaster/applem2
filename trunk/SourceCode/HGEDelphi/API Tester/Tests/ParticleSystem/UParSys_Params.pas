unit UParSys_Params;

interface

implementation

uses
  Windows, SysUtils, Classes, Math, HGE, HGEAnim, HGEParticle, HGEFont,
  UTestBase;

var
  ParSys: IHGEParticleSystem;
  Sprite: IHGEAnimation;
  SpriteNum, Preset, Param: Integer;
  LastLifeTime: Single;

procedure LoadPreset(const N: Integer);
begin
  Preset := N;
  with TFileStream.Create(Format('particle%d.psi',[Preset]),fmOpenRead or fmShareDenyWrite) do try
    ReadBuffer(SpriteNum,4);
    Sprite.SetBlendMode(SpriteNum shr 16);
    SpriteNum := SpriteNum and $FFFF;
    Sprite.SetFrame(SpriteNum);
    ReadBuffer(ParSys.Info.Emission,SizeOf(THGEParticleSystemInfo) - 4);
  finally
    Free;
  end;
end;

function FrameFunc: Boolean;
var
  Key, Change: Integer;
  DT, XMouse, YMouse, XPar, YPar: Single;
  Params: PHGEParticleSystemInfo;
begin
  SetFocus(Engine.System_GetState(HGE_HWND));
  DT := Engine.Timer_GetDelta;
  Key := Engine.Input_GetKey;
  if (Engine.Input_GetKeyState(HGEK_RBUTTON)) then begin
    Engine.Input_GetMousePos(XMouse,YMouse);
    ParSys.GetPosition(XPar,YPar);
    ParSys.MoveTo(XPar + (XMouse - XPar) * 10 * DT,
                  YPar + (YMouse - YPar) * 10 * DT);     
  end;

  Change := 0;
  Params := ParSys.Info;

  case Key of
    HGEK_B:
      if ((Sprite.GetBlendMode and BLEND_ALPHABLEND) <> 0) then
        Sprite.SetBlendMode(Sprite.GetBlendMode and not BLEND_ALPHABLEND)
      else
        Sprite.SetBlendMode(Sprite.GetBlendMode or BLEND_ALPHABLEND);
    HGEK_E:
      begin
        ParSys.Stop;
        if (Params.Lifetime = -1) then begin
          if (LastLifeTime < 0) then
            LastLifeTime := 3;
          Params.Lifetime := LastLifeTime
        end else begin
          LastLifeTime := Params.Lifetime;
          Params.Lifetime := -1;
        end;
        ParSys.Fire;
      end;
    HGEK_J:
      Params.Relative := not Params.Relative;
    HGEK_A,HGEK_C,HGEK_D,HGEK_F..HGEK_I,HGEK_K..HGEK_Z:
      Param := Key - HGEK_A;
    HGEK_0..HGEK_7:
      Param := Key - HGEK_0 + 26;
    HGEK_LEFT:
      Change := -1;
    HGEK_RIGHT:
      Change := 1;
    HGEK_F1..HGEK_F9:
      LoadPreset(Key - HGEK_F1 + 1);
  end;

  if (Change <> 0) then case Param of
     0: begin
          SpriteNum := (SpriteNum + Change) and 15;
          Sprite.SetFrame(SpriteNum);
        end;
     2: Inc(Params.Emission,Change * 3);
     3: begin
          ParSys.Stop;
          Params.Lifetime := Params.Lifetime + (Change / 2);
          ParSys.Fire;
        end;
     5: Params.ParticleLifeMin := Params.ParticleLifeMin + (Change / 10);
     6: Params.ParticleLifeMax := Params.ParticleLifeMax + (Change / 10);
     7: Params.Direction := Params.Direction + (Change * Pi / 90);
     8: Params.Spread := Params.Spread + (Change * Pi / 90);
    10: Params.SpeedMin := Params.SpeedMin + (Change / 10);
    11: Params.SpeedMax := Params.SpeedMax + (Change / 10);
    12: Params.GravityMin := Params.GravityMin + (Change / 10);
    13: Params.GravityMax := Params.GravityMax + (Change / 10);
    14: Params.RadialAccelMin := Params.RadialAccelMin + (Change / 10);
    15: Params.RadialAccelMax := Params.RadialAccelMax + (Change / 10);
    16: Params.TangentialAccelMin := Params.TangentialAccelMin + (Change / 10);
    17: Params.TangentialAccelMax := Params.TangentialAccelMax + (Change / 10);
    18: Params.SizeStart := Params.SizeStart + (Change / 10);
    19: Params.SizeEnd := Params.SizeEnd + (Change / 10);
    20: Params.SizeVar := Params.SizeVar + (Change / 50);
    21: Params.SpinStart := Params.SpinStart + (Change / 5);
    22: Params.SpinEnd := Params.SpinEnd + (Change / 5);
    23: Params.SpinVar := Params.SpinVar + (Change / 50);
    24: Params.ColorStart.R := Params.ColorStart.R + (Change / 50);
    25: Params.ColorStart.G := Params.ColorStart.G + (Change / 50);
    26: Params.ColorStart.B := Params.ColorStart.B + (Change / 50);
    27: Params.ColorStart.A := Params.ColorStart.A + (Change / 50);
    28: Params.ColorEnd.R := Params.ColorEnd.R + (Change / 50);
    29: Params.ColorEnd.G := Params.ColorEnd.G + (Change / 50);
    30: Params.ColorEnd.B := Params.ColorEnd.B + (Change / 50);
    31: Params.ColorEnd.A := Params.ColorEnd.A + (Change / 50);
    32: Params.ColorVar := Params.ColorVar + (Change / 50);
    33: Params.AlphaVar := Params.AlphaVar + (Change / 50);
  end;

  if (Engine.Input_GetKeyState(HGEK_LBUTTON)) then
    ParSys.FireAt(400,300);

  ParSys.Update(DT);
  Result := False;
end;

function RenderFunc: Boolean;
const
  BlendModes: array [Boolean] of String = ('additive','blend');
  OnOff: array [Boolean] of String = ('off','on');
var
  UseBlend: Boolean;
begin
  Engine.Gfx_BeginScene;
  Engine.Gfx_Clear(0);
  ParSys.Render;

  UseBlend := ((Sprite.GetBlendMode and BLEND_ALPHABLEND) <> 0);
  SmallFont.PrintF(10,10,HGETEXT_LEFT,
    'A: Change sprite: %d'#13+
    'B: Toggle blend mode: %s'#13+
    'C: Emission: %d p/sec'#13+
    'D: System lifetime: %.1f sec'#13+
    'E: Toggle continuous particle generation: %s'#13+
    'F: Particle lifetime min: %.1f sec'#13+
    'G: Particle lifetime max: %.1f sec'#13+
    'H: Direction: %.1f deg'#13+
    'I: Spread: %.1f deg'#13+
    'J: Toggle relative direction: %s'#13+
    'K: Speed min: %.1f pix/sec'#13+
    'L: Speed max: %.1f pix/sec'#13+
    'M: Gravity min: %.1f'#13+
    'N: Gravity max: %.1f'#13+
    'O: Radial acceleration min: %.1f'#13+
    'P: Radial acceleration max: %.1f'#13+
    'Q: Tangential acceleration min: %.1f'#13+
    'R: Tangential acceleration max: %.1f'#13+
    'S: Particle size start: %.1f'#13+
    'T: Particle size end: %.1f'#13+
    'U: Particle size variance: %.2f'#13+
    'V: Particle spin start: %.1f'#13+
    'W: Particle spin end: %.1f'#13+
    'X: Particle spin variance: %.2f'#13+
    'Y: Color start Red: %.2f'#13+
    'Z: Color start Green: %.2f'#13+
    '0: Color start Blue: %.2f'#13+
    '1: Color start Alpha: %.2f'#13+
    '2: Color end Red: %.2f'#13+
    '3: Color end Green: %.2f'#13+
    '4: Color end Blue: %.2f'#13+
    '5: Color end Alpha: %.2f'#13+
    '6: Color variance: %.2f'#13+
    '7: Alpha variance: %.2f'#13#13+
    'Render speed: %d fps'#13+
    'Particles alive: %d'#13#13+
    'A-Z, 0-7: Change parameter'#13+
    'Cursor Left/Right: Change value of parameter'#13+
    'F1-F9: Load preset (%d)'#13+
    'Left mouse button: fire particle system'#13+
    'Right mouse button: move particle system',
    [SpriteNum,
     BlendModes[UseBlend],
     ParSys.Info.Emission,
     ParSys.Info.Lifetime,
     OnOff[ParSys.Info.Lifetime = -1],
     ParSys.Info.ParticleLifeMin,
     ParSys.Info.ParticleLifeMax,
     RadToDeg(ParSys.Info.Direction),
     RadToDeg(ParSys.Info.Spread),
     OnOff[ParSys.Info.Relative],
     ParSys.Info.SpeedMin,
     ParSys.Info.SpeedMax,
     ParSys.Info.GravityMin,
     ParSys.Info.GravityMax,
     ParSys.Info.RadialAccelMin,
     ParSys.Info.RadialAccelMax,
     ParSys.Info.TangentialAccelMin,
     ParSys.Info.TangentialAccelMax,
     ParSys.Info.SizeStart,
     ParSys.Info.SizeEnd,
     ParSys.Info.SizeVar,
     ParSys.Info.SpinStart,
     ParSys.Info.SpinEnd,
     ParSys.Info.SpinVar,
     ParSys.Info.ColorStart.R,
     ParSys.Info.ColorStart.G,
     ParSys.Info.ColorStart.B,
     ParSys.Info.ColorStart.A,
     ParSys.Info.ColorEnd.R,
     ParSys.Info.ColorEnd.G,
     ParSys.Info.ColorEnd.B,
     ParSys.Info.ColorEnd.A,
     ParSys.Info.ColorVar,
     ParSys.Info.AlphaVar,
     Engine.Timer_GetFPS,
     ParSys.GetParticlesAlive,
     Preset]);
  Engine.Gfx_EndScene;

  Result := False;
end;

procedure Test;
var
  Texture: ITexture;
begin
  Engine.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,RenderFunc);
  Engine.System_SetState(HGE_FPS,50);

  Texture := Engine.Texture_Load('particles.png');
  Sprite := THGEAnimation.Create(Texture,16,20,0,0,32,32);
  Sprite.SetHotSpot(16,16);
  ParSys := THGEParticleSystem.Create('particle1.psi',Sprite);
  ParSys.FireAt(400,300);
  LoadPreset(1);
  Param := -1;
  LastLifeTime := -1;

  while Running do ;

  Sprite := nil;
  ParSys := nil;

  Engine.System_SetState(HGE_FRAMEFUNC,DefaultFrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,nil);
  Engine.System_SetState(HGE_FPS,HGEFPS_UNLIMITED);
end;

initialization
  RegisterTest('Parameters','ParticleSystem\UParSys_Params',Test,[toManualGfx]);

end.
