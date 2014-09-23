unit UPhysics_Pyramid;

interface

implementation

uses
  HGEVector, HGEPhysics, UTestBase, UPhysics_Base;

procedure PopulateWorld;
var
  B: IHGEBody;
  V1, V2: THGEVector;
  I, J: Integer;
begin
  B := THGEBody.Create(THGEVector.Create(100,20));
  B.Friction := 0.2;
  B.Position := THGEVector.Create(0,-0.5 * B.Size.Y);
  B.Rotation := 0;
  World.Add(B);

  V1 := THGEVector.Create(-6,0.75);
  for I := 0 to 11 do begin
    V2 := V1;
    for J := I to 11 do begin
      B := THGEBody.Create(THGEVector.Create(1,1),10);
      B.Friction := 0.2;
      B.Position := V2;
      World.Add(B);
      V2.Increment(THGEVector.Create(1.125,0));
    end;
    V1.Increment(THGEVector.Create(0.5625,2));
  end;
end;

procedure Test;
begin
  InitializePhysicsTest(PopulateWorld);
  while Running do ;
  FinalizePhysicsTest;
end;

initialization
  RegisterTest('Pyramid stack','Extensions\Physics\UPhysics_Pyramid',Test);

end.
