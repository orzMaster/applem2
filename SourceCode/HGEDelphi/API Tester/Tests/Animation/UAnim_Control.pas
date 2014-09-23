unit UAnim_Control;

interface

implementation

uses
  Windows, HGE, HGEFont, HGEAnim, UTestBase;

var
  Anim: IHGEAnimation;

function FrameFunc: Boolean;
var
  Mode, NewMode: Integer;
  Rev, PingPong, Loop: Boolean;
begin
  SetFocus(Engine.System_GetState(HGE_HWND));
  Mode := Anim.GetMode;
  Rev := ((Mode and HGEANIM_REV) <> 0);
  PingPong := ((Mode and HGEANIM_PINGPONG) <> 0);
  Loop := ((Mode and HGEANIM_LOOP) <> 0);

  case Engine.Input_GetKey of
    HGEK_P: Anim.Play;
    HGEK_S: Anim.Stop;
    HGEK_R: Anim.Resume;
    HGEK_LEFT : Anim.SetSpeed(Anim.GetSpeed * 0.95);
    HGEK_RIGHT: Anim.SetSpeed(Anim.GetSpeed * 1.05);
    HGEK_1: Rev := not Rev;
    HGEK_2: Loop := not Loop;
    HGEK_3: PingPong := not PingPong;
  end;

  NewMode := 0;
  if (Rev) then
    NewMode := NewMode or HGEANIM_REV;
  if (PingPong) then
    NewMode := NewMode or HGEANIM_PINGPONG;
  if (Loop) then
    NewMode := NewMode or HGEANIM_LOOP;
  if (Mode <> NewMode) then
    Anim.SetMode(NewMode);

  Anim.Update(Engine.Timer_GetDelta);
  Result := False;
end;

function RenderFunc: Boolean;
begin
  Engine.Gfx_BeginScene;
  Engine.Gfx_Clear(0);
  LargeFont.PrintF(10,10,HGETEXT_LEFT,
    'P=Play from beginning'#13+
    'S=Stop'#13+
    'R=Resume'#13+
    'Cursor Left/Right=Decrease/Increase speed'#13+
    '1=Toggle forward/reverse'#13+
    '2=Toggle looping'#13+
    '3=Toggle ping-pong cycle'#13#13+
    'IsPlaying: %d'#13+
    'Render speed: %d FPS'#13+
    'Animation speed: %.1f FPS'#13+
    'Frame: %d',
    [Ord(Anim.IsPlaying),Engine.Timer_GetFPS,Anim.GetSpeed,Anim.GetFrame]);
  Anim.Render(400,300);
  Engine.Gfx_EndScene;

  Result := False;
end;

procedure Test;
var
  Texture: ITexture;
begin
  Engine.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,RenderFunc);

  Texture := Engine.Texture_Load('animation.png');
  Anim := THGEAnimation.Create(Texture,16,20,0,0,64,64);
  Anim.SetHotSpot(32,32);
  Anim.Play;

  while Running do ;

  Texture := nil;
  Engine.System_SetState(HGE_FRAMEFUNC,DefaultFrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,nil);
end;

initialization
  RegisterTest('Animation control','Animation\UAnim_Control',Test,[toManualGfx]);

end.
