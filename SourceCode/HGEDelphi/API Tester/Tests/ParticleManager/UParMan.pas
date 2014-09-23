unit UParMan;

interface

implementation

uses
  Windows, Classes, SysUtils, HGE, HGESprite, HGEParticle, HGEFont, UTestBase;

var
  ParMan: IHGEParticleManager;
  PS1, PS2, PS3: IHGEParticleSystem;
  Texture: ITexture;

function FrameFunc: Boolean;
var
  DT, XMouse, YMouse, XPar, YPar: Single;
  PS: IHGEParticleSystem;

  procedure ToggleParSys(var ParSys: IHGEParticleSystem; const Filename: String;
    const TexX, TexY, XPos: Integer);
  var
    Params: THGEParticleSystemInfo;
  begin
    if ParMan.IsPSAlive(ParSys) then begin
      ParMan.KillPS(ParSys);
      ParSys := nil;
    end else begin
      Params.Sprite := THGESprite.Create(Texture,TexX,TexY,32,32);
      Params.Sprite.SetHotSpot(16,16);
      Params.Sprite.SetBlendMode(BLEND_COLORMUL or BLEND_ALPHAADD);
      with TFileStream.Create(Filename,fmOpenRead or fmShareDenyWrite) do try
        Position := 4;
        ReadBuffer(Params.Emission,SizeOf(Params) - 4);
      finally
        Free;
      end;
      ParSys := ParMan.SpawnPS(Params,XPos,300);
    end;
  end;

begin
  SetFocus(Engine.System_GetState(HGE_HWND));
  DT := Engine.Timer_GetDelta;

  case Engine.Input_GetKey of
    HGEK_1: ToggleParSys(PS1,'particle5.psi',64,64,200);
    HGEK_2: ToggleParSys(PS2,'particle1.psi',96,32,400);
    HGEK_3: ToggleParSys(PS3,'particle2.psi',96,96,600);
  end;

  if (Engine.Input_GetKeyState(HGEK_LBUTTON)) then
    PS := PS1
  else if (Engine.Input_GetKeyState(HGEK_MBUTTON)) then
    PS := PS2
  else if (Engine.Input_GetKeyState(HGEK_RBUTTON)) then
    PS := PS3
  else
    PS := nil;

  if Assigned(PS) then begin
    Engine.Input_GetMousePos(XMouse,YMouse);
    PS.GetPosition(XPar,YPar);
    PS.MoveTo(XPar + (XMouse - XPar) * 10 * DT,
              YPar + (YMouse - YPar) * 10 * DT);
  end;
  ParMan.Update(DT);
  Result := False;
end;

function RenderFunc: Boolean;
begin
  Engine.Gfx_BeginScene;
  Engine.Gfx_Clear(0);
  ParMan.Render;
  SmallFont.Render(10,10,HGETEXT_LEFT,'Use keys 1, 2 and 3 to toggle particle systems'#13+
    'Use left, middle and right mouse buttons to move particle systems');
  Engine.Gfx_EndScene;
  Result := False;
end;

procedure Test;
begin
  Engine.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,RenderFunc);
  Texture := Engine.Texture_Load('particles.png');
  ParMan := THGEParticleManager.Create;

  while Running do ;

  PS1 := nil;
  PS2 := nil;
  PS3 := nil;
  ParMan := nil;
  Texture := nil;

  Engine.System_SetState(HGE_FRAMEFUNC,DefaultFrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,nil);
end;

initialization
  RegisterTest('Multiple Particle Systems','ParticleManager\UParMan',Test,[toManualGfx]);

end.
