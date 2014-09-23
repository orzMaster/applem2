unit UPhysics_Pendulum;

interface

implementation

uses
  HGEVector, HGEPhysics, UTestBase, UPhysics_Base;

procedure PopulateWorld;
var
  B1, B2: IHGEBody;
  J: IHGEJoint;
begin
  B1 := THGEBody.Create(THGEVector.Create(100,20));
  B1.Friction := 0.2;
  B1.Position := THGEVector.Create(0,-0.5 * B1.Size.Y);
  B1.Rotation := 0;
  World.Add(B1);

  B2 := THGEBody.Create(THGEVector.Create(1,1),100);
  B2.Friction := 0.2;
  B2.Position := THGEVector.Create(9,11);
  B2.Rotation := 0;
  World.Add(B2);

  J := THGEJoint.Create(B1,B2,THGEVector.Create(0,11));
  World.Add(J);
end;

procedure Test;
begin
  InitializePhysicsTest(PopulateWorld);
  while Running do ;
  FinalizePhysicsTest;
end;

initialization
  RegisterTest('Simple pendulum','Extensions\Physics\UPhysics_Pendulum',Test);

end.
