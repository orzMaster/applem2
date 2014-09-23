unit UPhysics_Teeter;

interface

implementation

uses
  HGEVector, HGEPhysics, UTestBase, UPhysics_Base;

procedure PopulateWorld;
var
  B, B1, B2: IHGEBody;
  J: IHGEJoint;
begin
  B1 := THGEBody.Create(THGEVector.Create(100,20));
  B1.Position := THGEVector.Create(0,-0.5 * B1.Size.Y);
  World.Add(B1);

  B2 := THGEBody.Create(THGEVector.Create(12,0.25),100);
  B2.Position := THGEVector.Create(0,1);
  World.Add(B2);

  J := THGEJoint.Create(B1,B2,THGEVector.Create(0,1));
  World.Add(J);

  B := THGEBody.Create(THGEVector.Create(0.5,0.5),25);
  B.Position := THGEVector.Create(-5,2);
  World.Add(B);

  B := THGEBody.Create(THGEVector.Create(0.5,0.5),25);
  B.Position := THGEVector.Create(-5.5,2);
  World.Add(B);

  B := THGEBody.Create(THGEVector.Create(1,1),100);
  B.Position := THGEVector.Create(5.5,15);
  World.Add(B);
end;

procedure Test;
begin
  InitializePhysicsTest(PopulateWorld);
  while Running do ;
  FinalizePhysicsTest;
end;

initialization
  RegisterTest('Teeter','Extensions\Physics\UPhysics_Teeter',Test);

end.
