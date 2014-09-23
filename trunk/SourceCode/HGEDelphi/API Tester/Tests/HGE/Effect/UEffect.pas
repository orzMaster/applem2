unit UEffect;

interface

implementation

uses
  Windows, HGE, UTestBase;

procedure Test;
var
  Effect: IEffect;
  I: Integer;
begin
  Effect := Engine.Effect_Load('menu.wav');
  // Play with increasing volume
  for I := 0 to 4 do begin
    Effect.PlayEx(20 + I * 20);
    Sleep(200);
  end;
  Sleep(200);
  // Play panned from left to right
  for I := 0 to 4 do begin
    Effect.PlayEx(100,(I - 2) * 50);
    Sleep(200);
  end;
  Sleep(200);
  // Play pitched from 0.5 to 2.0
  for I := 0 to 4 do begin
    if (I < 2) then
      Effect.PlayEx(100,0,0.5 + I * 0.25)
    else
      Effect.PlayEx(100,0,I * 0.5);
    Sleep(200);
  end;
end;

initialization
  RegisterTest('Effect Functions','HGE\Effect\UEffect',Test);

end.
