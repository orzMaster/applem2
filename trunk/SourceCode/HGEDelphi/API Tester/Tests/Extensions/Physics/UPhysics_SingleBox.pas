unit UPhysics_SingleBox;

interface

implementation

uses
  Windows, HGE, HGEVector, HGEMatrix, HGESprite, HGEFont, HGEPhysics, UTestBase;

var
  World: IHGEWorld;
  BoxSprite: IHGESprite;
  BombSprite: IHGESprite;
  StationarySprite: IHGESprite;
  Bomb: IHGEBody;

const
  WorldScale = 40;

procedure PopulateWorld;
var
  Body: IHGEBody;
begin
  World.Clear;
  Bomb := nil;

  Body := THGEBody.Create(THGEVector.Create(100,20));
  Body.Position := THGEVector.Create(0,-0.5 * Body.Size.Y);
  World.Add(Body);

  Body := THGEBody.Create(THGEVector.Create(1,1),200);
  Body.Position := THGEVector.Create(0,4);
  World.Add(Body);
end;

procedure LaunchBomb;
begin
  if (Bomb = nil) then begin
    Bomb := THGEBody.Create(THGEVector.Create(1,1),50);
    Bomb.Friction := 0.2;
    World.Add(Bomb);
  end;
  Bomb.Position := THGEVector.Create(Engine.Random_Float(-15,15),15);
  Bomb.Rotation := Engine.Random_Float(-1.5,1.5);
  Bomb.Velocity := -1.5 * Bomb.Position;
  Bomb.AngularVelocity := Engine.Random_Float(-20,20);
end;

function FrameFunc: Boolean;
begin
  SetFocus(Engine.System_GetState(HGE_HWND));
  case Engine.Input_GetKey of
    HGEK_A    : THGEWorld.AccumulateImpulses := not THGEWorld.AccumulateImpulses;
    HGEK_P    : THGEWorld.PositionCorrection := not THGEWorld.PositionCorrection;
    HGEK_S    : THGEWorld.SplitImpules := not THGEWorld.SplitImpules;
    HGEK_W    : THGEWorld.WarmStarting := not THGEWorld.WarmStarting;
    HGEK_R    : PopulateWorld;
    HGEK_SPACE: LaunchBomb;
  end;

  World.Step(Engine.Timer_GetDelta);
  Result := False;
end;

function WorldToScreen(const V: THGEVector): THGEVector;
begin
  Result.X := V.X * WorldScale + 400;
  Result.Y := 500 - V.Y * WorldScale;
end;

procedure RenderBody(const Body: IHGEBody);
var
  Sprite: IHGESprite;
  P: THGEVector;
begin
  if (Body.IsStationary) then
    Sprite := StationarySprite
  else if (Body = Bomb) then
    Sprite := BombSprite
  else
    Sprite := BoxSprite;

  P := WorldToScreen(Body.Position);
  Sprite.RenderEx(P.X,P.Y,-Body.Rotation,
    (Body.Size.X * WorldScale) / Sprite.GetWidth,
    (Body.Size.Y * WorldScale) / Sprite.GetHeight);
end;

function RenderFunc: Boolean;
const
  OnOff: array [Boolean] of String = ('OFF','ON');
var
  I: Integer;
begin
  Engine.Gfx_BeginScene;
  Engine.Gfx_Clear(0);

  for I := 0 to World.Bodies.Count - 1 do
    RenderBody(World.Bodies[I]);

  SmallFont.PrintF(10,10,HGETEXT_LEFT,
    'A=Toggle accumulation of impulses (currently %s)'#13+
    'P=Toggle position correction (currently %s)'#13+
    'S=Toggle split impulses (currently %s)'#13+
    'W=Toggle warm starting (currently %s)'#13+
    'R=Restart simulation'#13+
    'Space=Launch bomb',
    [OnOff[THGEWorld.AccumulateImpulses],
     OnOff[THGEWorld.PositionCorrection],
     OnOff[THGEWorld.SplitImpules],
     OnOff[THGEWorld.WarmStarting]]);
  Engine.Gfx_EndScene;

  Result := False;
end;

procedure Test;
var
  Tex: ITexture;
begin
  Engine.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,RenderFunc);

  Tex := Engine.Texture_Load('Box.png');
  BoxSprite := THGESprite.Create(Tex,0,0,106,106);
  BoxSprite.SetHotSpot(53,53);
  BombSprite := THGESprite.Create(BoxSprite);
  BombSprite.SetColor($FFFF8080);
  StationarySprite := THGESprite.Create(nil,0,0,8,8);
  StationarySprite.SetColor($FF4583E0);
  StationarySprite.SetHotSpot(4,4);

  World := THGEWorld.Create(THGEVector.Create(0,-10),10);
  THGEWorld.AccumulateImpulses := True;
  THGEWorld.SplitImpules := True;
  THGEWorld.WarmStarting := True;
  THGEWorld.PositionCorrection := True;
  PopulateWorld;

  while Running do ;

  World := nil;
  BoxSprite := nil;
  StationarySprite := nil;
  BombSprite := nil;
  Bomb := nil;

  Engine.System_SetState(HGE_FRAMEFUNC,DefaultFrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,nil);
end;

initialization
  RegisterTest('Single box','Extensions\Physics\UPhysics_SingleBox',Test);

end.
