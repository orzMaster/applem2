unit UPhysics_Friction;

interface

implementation

uses
  HGEVector, HGEPhysics, UTestBase, UPhysics_Base;

procedure PopulateWorld;
const
  Friction: array [0..4] of Single = (0.75,0.5,0.35,0.1,0);
var
  B: IHGEBody;
  I: Integer;
begin
  B := THGEBody.Create(THGEVector.Create(100,20));
  B.Position := THGEVector.Create(0,-0.5 * B.Size.Y);
  World.Add(B);

  B := THGEBody.Create(THGEVector.Create(13,0.25));
  B.Position := THGEVector.Create(-2,11);
  B.Rotation := -0.25;
  World.Add(B);

  B := THGEBody.Create(THGEVector.Create(0.25,1));
  B.Position := THGEVector.Create(5.25,9.5);
  World.Add(B);

  B := THGEBody.Create(THGEVector.Create(13,0.25));
  B.Position := THGEVector.Create(2,7);
  B.Rotation := 0.25;
  World.Add(B);

  B := THGEBody.Create(THGEVector.Create(0.25,1));
  B.Position := THGEVector.Create(-5.25,5.5);
  World.Add(B);

  B := THGEBody.Create(THGEVector.Create(13,0.25));
  B.Position := THGEVector.Create(-2,3);
  B.Rotation := -0.25;
  World.Add(B);

  for I := 0 to 4 do begin
    B := THGEBody.Create(THGEVector.Create(0.5,0.5),25);
    B.Position := THGEVector.Create(-7.5 + 2 * I,14);
    B.Friction := Friction[I];
    World.Add(B);
  end;
end;

procedure Test;
begin
  InitializePhysicsTest(PopulateWorld);
  while Running do ;
  FinalizePhysicsTest;
end;

initialization
  RegisterTest('Various friction coefficients','Extensions\Physics\UPhysics_Friction',Test);

end.
