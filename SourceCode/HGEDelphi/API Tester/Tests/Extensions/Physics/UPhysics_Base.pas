unit UPhysics_Base;

interface

uses
  HGEPhysics;

type
  TPopulateProc = procedure;

procedure InitializePhysicsTest(const APopulateProc: TPopulateProc);
procedure FinalizePhysicsTest;

var
  World: IHGEWorld;
  
implementation

uses
  Windows, HGE, HGEVector, HGEMatrix, HGESprite, HGEFont, UTestBase;

var
  PopulateProc: TPopulateProc;
  BoxSprite: IHGESprite;
  BombSprite: IHGESprite;
  StationarySprite: IHGESprite;
  Bomb: IHGEBody;
  RenderJoints: Boolean;

const
  WorldScale = 40;

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
    HGEK_J    : RenderJoints := not RenderJoints;
    HGEK_R    : begin
                  World.Clear;
                  Bomb := nil;
                  PopulateProc;
                end;
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

procedure RenderJoint(const Joint: IHGEJoint);
var
  M1, M2: THGEMatrix;
  P1, P2, J1, J2: THGEVector;
begin
  M1 := THGEMatrix.Create(Joint.Body1.Rotation);
  M2 := THGEMatrix.Create(Joint.Body2.Rotation);
  P1 := Joint.Body1.Position;
  P2 := Joint.Body2.Position;
  J1 := WorldToScreen(P1 + M1 * Joint.LocalAnchor1);
  J2 := WorldToScreen(P2 + M2 * Joint.LocalAnchor2);
  P1 := WorldToScreen(P1);
  P2 := WorldToScreen(P2);
  Engine.Gfx_RenderLine(P1.X,P1.Y,J1.X,J1.Y,$FFFFFF00);
  Engine.Gfx_RenderLine(P2.X,P2.Y,J2.X,J2.Y,$FFFFFF00);
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

  if (RenderJoints) then
    for I := 0 to World.Joints.Count - 1 do
      RenderJoint(World.Joints[I]);

  SmallFont.PrintF(10,10,HGETEXT_LEFT,
    'A=Toggle accumulation of impulses (currently %s)'#13+
    'P=Toggle position correction (currently %s)'#13+
    'S=Toggle split impulses (currently %s)'#13+
    'W=Toggle warm starting (currently %s)'#13+
    'J=Toggle joint rendering (currently %s)'#13+
    'R=Restart simulation'#13+
    'Space=Launch bomb'#13+
    'Live bodies: %d'#13+
    'Live joints: %d'#13+
    'Live arbiters: %d',
    [OnOff[THGEWorld.AccumulateImpulses],
     OnOff[THGEWorld.PositionCorrection],
     OnOff[THGEWorld.SplitImpules],
     OnOff[THGEWorld.WarmStarting],
     OnOff[RenderJoints],
     HGEBodyCount,HGEJointCount,HGEArbiterCount]);
  Engine.Gfx_EndScene;

  Result := False;
end;

procedure InitializePhysicsTest(const APopulateProc: TPopulateProc);
var
  Tex: ITexture;
begin
  Engine.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,RenderFunc);

  Tex := Engine.Texture_Load('Box.png');
  BoxSprite := THGESprite.Create(Tex,0,0,106,106);
  BoxSprite.SetHotSpot(53,53);
  BombSprite := THGESprite.Create(BoxSprite);
  BombSprite.SetColor($FFFF8080,0);
  BombSprite.SetColor($FF8080FF,1);
  BombSprite.SetColor($FF80FF80,2);
  BombSprite.SetColor($FFFFFF80,3);
  StationarySprite := THGESprite.Create(nil,0,0,8,8);
  StationarySprite.SetColor($FF4583E0);
  StationarySprite.SetHotSpot(4,4);

  World := THGEWorld.Create(THGEVector.Create(0,-10),10);
  THGEWorld.AccumulateImpulses := True;
  THGEWorld.SplitImpules := True;
  THGEWorld.WarmStarting := True;
  THGEWorld.PositionCorrection := True;
  RenderJoints := True;

  PopulateProc := APopulateProc;
  PopulateProc;
end;

procedure FinalizePhysicsTest;
begin
  World := nil;
  BoxSprite := nil;
  StationarySprite := nil;
  BombSprite := nil;
  Bomb := nil;

  Engine.System_SetState(HGE_FRAMEFUNC,DefaultFrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,nil);
end;

end.
