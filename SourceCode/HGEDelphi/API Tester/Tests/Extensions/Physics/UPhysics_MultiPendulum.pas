unit UPhysics_MultiPendulum;

interface

implementation

uses
  HGEVector, HGEPhysics, UTestBase, UPhysics_Base;

procedure PopulateWorld;
const
  TimeStep = 1 / 600;
  Mass = 10;
  FrequencyHz = 4;
  DampingRatio = 0.7;
  Omega = 2 * Pi * FrequencyHz; // frequency in radians
  D = 2 * Mass * DampingRatio * Omega; // damping coefficient
  K = Mass * Omega * Omega; // spring stifness
  Softness = 1 / (D + TimeStep * K);
  BiasFactor = TimeStep * K / (D + TimeStep * K);
  Y = 12;
var
  B, B1: IHGEBody;
  J: IHGEJoint;
  V: THGEVector;
  I: Integer;
begin
  B1 := THGEBody.Create(THGEVector.Create(100,20));
  B1.Friction := 0.2;
  B1.Position := THGEVector.Create(0,-0.5 * B1.Size.Y);
  B1.Rotation := 0;
  World.Add(B1);

  for I := 0 to 14 do begin
    V := THGEVector.Create(0.5 + I,Y);
    B := THGEBody.Create(THGEVector.Create(0.75,0.25),Mass);
    B.Friction := 0.2;
    B.Position := V;
    World.Add(B);

    J := THGEJoint.Create(B1,B,THGEVector.Create(I,Y));
    J.Softness := Softness;
    J.BiasFactor := BiasFactor;
    World.Add(J);

    B1 := B;
  end;
end;

procedure Test;
begin
  InitializePhysicsTest(PopulateWorld);
  while Running do ;
  FinalizePhysicsTest;
end;

initialization
  RegisterTest('Multi-pendulum','Extensions\Physics\UPhysics_MultiPendulum',Test);

end.
