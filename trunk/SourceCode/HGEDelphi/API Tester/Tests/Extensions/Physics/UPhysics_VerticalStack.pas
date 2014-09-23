unit UPhysics_VerticalStack;

interface

implementation

uses
  HGEVector, HGEPhysics, UTestBase, UPhysics_Base;

procedure PopulateWorld;
var
  B: IHGEBody;
  I: Integer;
begin
  B := THGEBody.Create(THGEVector.Create(100,20));
  B.Friction := 0.2;
  B.Position := THGEVector.Create(0,-0.5 * B.Size.Y);
  B.Rotation := 0;
  World.Add(B);

  for I := 0 to 9 do begin
    B := THGEBody.Create(THGEVector.Create(1,1),1);
    B.Friction := 0.2;
    B.Position := THGEVector.Create(Engine.Random_Float(-0.1,0.1),0.51 + 1.05 * I);
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
  RegisterTest('Vertical stack','Extensions\Physics\UPhysics_VerticalStack',Test);

end.
