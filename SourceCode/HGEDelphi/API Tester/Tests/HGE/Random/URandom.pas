unit URandom;

interface

implementation

uses
  SysUtils, HGE, HGEFont, UTestBase;

procedure Test;
var
  I, J: Integer;
  F: Single;
begin
  Engine.Random_Seed(123456);
  for J := 0 to 29 do begin
    I := Engine.Random_Int(4,9);
    F := Engine.Random_Float(4,9);
    SmallFont.PrintF(10,10 + J * 15,HGETEXT_LEFT,
      'Random int: %d, Random float: %g',[I,F]);
  end;
end;

initialization
  RegisterTest('Random Functions','HGE\Random\URandom',Test);

end.
