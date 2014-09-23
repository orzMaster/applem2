unit UPhysics_Dominos;

interface

implementation

uses
  HGEVector, HGEPhysics, UTestBase, UPhysics_Base;

procedure PopulateWorld;
var
  B, B1, B2, B3, B4, B5, B6: IHGEBody;
  J: IHGEJoint;
  I: Integer;
begin
  B1 := THGEBody.Create(THGEVector.Create(100,20));
  B1.Position := THGEVector.Create(0,-0.5 * B1.Size.Y);
  World.Add(B1);

  B := THGEBody.Create(THGEVector.Create(12,0.5));
  B.Position := THGEVector.Create(-1.5,10);
  World.Add(B);

  for I := 0 to 9 do begin
    B := THGEBody.Create(THGEVector.Create(0.2,2),10);
    B.Position := THGEVector.Create(-6 + I,11.125);
    B.Friction := 0.1;
    World.Add(B);
  end;

  B := THGEBody.Create(THGEVector.Create(14,0.5));
  B.Position := THGEVector.Create(1,6);
  B.Rotation := 0.3;
  World.Add(B);

  B2 := THGEBody.Create(THGEVector.Create(0.5,3));
  B2.Position := THGEVector.Create(-7,4);
  World.Add(B2);

  B3 := THGEBody.Create(THGEVector.Create(12,0.25),20);
  B3.Position := THGEVector.Create(-0.9,1);
  World.Add(B3);

  J := THGEJoint.Create(B1,B3,THGEVector.Create(-2,1));
  World.Add(J);

  B4 := THGEBody.Create(THGEVector.Create(0.5,0.5),10);
  B4.Position := THGEVector.Create(-10,15);
  World.Add(B4);

  J := THGEJoint.Create(B2,B4,THGEVector.Create(-7,15));
  World.Add(J);

  B5 := THGEBody.Create(THGEVector.Create(2,2),20);
  B5.Position := THGEVector.Create(6,2.5);
  B5.Friction := 0.1;
  World.Add(B5);

  J := THGEJoint.Create(B1,B5,THGEVector.Create(6,2.6));
  World.Add(J);

  B6 := THGEBody.Create(THGEVector.Create(2,0.2),10);
  B6.Position := THGEVector.Create(6,3.6);
  World.Add(B6);

  J := THGEJoint.Create(B5,B6,THGEVector.Create(7,3.5));
  World.Add(J);
end;

procedure Test;
begin
  InitializePhysicsTest(PopulateWorld);
  while Running do ;
  FinalizePhysicsTest;
end;

initialization
  RegisterTest('Dominos','Extensions\Physics\UPhysics_Dominos',Test);

end.
