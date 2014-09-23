unit UPhysics_Bridge;

interface

implementation

uses
  HGEVector, HGEPhysics, UTestBase, UPhysics_Base;

procedure PopulateWorld;
const
  TimeStep = 1 / 10000;
  NumPlanks = 15;
  Mass = 50;
  FrequencyHz = 2;
  DampingRatio = 0.7;
  Omega = 2 * Pi * FrequencyHz; // frequency in radians
  D = 2 * Mass * DampingRatio * Omega; // damping coefficient
  K = Mass * Omega * Omega; // spring stifness
  Softness = 1 / (D + TimeStep * K);
  BiasFactor = TimeStep * K / (D + TimeStep * K);
var
  Bodies: array [0..NumPlanks] of IHGEBody;
  B: IHGEBody;
  J: IHGEJoint;
  I: Integer;
begin
  B := THGEBody.Create(THGEVector.Create(100,20));
  B.Friction := 0.2;
  B.Position := THGEVector.Create(0,-0.5 * B.Size.Y);
  B.Rotation := 0;
  World.Add(B);
  Bodies[0] := B;

  for I := 0 to NumPlanks - 1 do begin
    B := THGEBody.Create(THGEVector.Create(1,0.25),Mass);
    B.Friction := 0.2;
    B.Position := THGEVector.Create(-8.5 + 1.25 * I,5);
    World.Add(B);
    Bodies[I + 1] := B;
  end;

	// Tuning
  for I := 0 to NumPlanks - 1 do begin
    J := THGEJoint.Create(Bodies[I],Bodies[I + 1],
      THGEVector.Create(-9.125 + 1.25 * I,5));
    J.Softness := Softness;
    J.BiasFactor := BiasFactor;
    World.Add(J);
  end;

  J := THGEJoint.Create(Bodies[NumPlanks],Bodies[0],
    THGEVector.Create(-9.125 + 1.25 * NumPlanks,5));
  J.Softness := Softness;
  J.BiasFactor := BiasFactor;
  World.Add(J);
end;

procedure Test;
begin
  InitializePhysicsTest(PopulateWorld);
  while Running do ;
  FinalizePhysicsTest;
end;

initialization
  RegisterTest('Suspension Bridge','Extensions\Physics\UPhysics_Bridge',Test);

end.
