unit UParSys_BoundingBox;

interface

implementation

uses
  HGE, HGESprite, HGEParticle, HGEFont, HGERect, UTestBase;

var
  ParSys: IHGEParticleSystem;

function FrameFunc: Boolean;
var
  DT, XMouse, YMouse, XPar, YPar: Single;
begin
  DT := Engine.Timer_GetDelta;
  if (Engine.Input_GetKeyState(HGEK_LBUTTON)) then begin
    Engine.Input_GetMousePos(XMouse,YMouse);
    ParSys.GetPosition(XPar,YPar);
    ParSys.MoveTo(XPar + (XMouse - XPar) * 10 * DT,
                  YPar + (YMouse - YPar) * 10 * DT);
  end;
  ParSys.Update(DT);
  Result := False;
end;

function RenderFunc: Boolean;
var
  R: THGERect;
begin
  Engine.Gfx_BeginScene;
  Engine.Gfx_Clear(0);
  ParSys.Render;
  ParSys.GetBoundingBox(R);
  Engine.Gfx_RenderLine(R.X1,R.Y1,R.X2,R.Y1);
  Engine.Gfx_RenderLine(R.X2,R.Y1,R.X2,R.Y2);
  Engine.Gfx_RenderLine(R.X2,R.Y2,R.X1,R.Y2);
  Engine.Gfx_RenderLine(R.X1,R.Y2,R.X1,R.Y1-1);
  SmallFont.Render(10,10,HGETEXT_LEFT,'Use left mouse button to move particle system');
  Engine.Gfx_EndScene;
  Result := False;
end;

procedure Test;
var
  Texture: ITexture;
  Sprite: IHGESprite;
begin
  Engine.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,RenderFunc);

  Texture := Engine.Texture_Load('particles.png');
  Sprite := THGESprite.Create(Texture,64,64,32,32);
  Sprite.SetHotSpot(16,16);
  Sprite.SetBlendMode(BLEND_COLORMUL or BLEND_ALPHAADD);
  ParSys := THGEParticleSystem.Create('particle5.psi',Sprite);
  ParSys.TrackBoundingBox(True);
  ParSys.FireAt(400,300);

  while Running do ;

  Sprite := nil;
  ParSys := nil;

  Engine.System_SetState(HGE_FRAMEFUNC,DefaultFrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,nil);
end;

initialization
  RegisterTest('Bounding Box','ParticleSystem\UParSys_BoundingBox',Test,[toManualGfx]);

end.
