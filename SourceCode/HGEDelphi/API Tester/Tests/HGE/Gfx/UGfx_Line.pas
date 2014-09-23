unit UGfx_Line;

interface

implementation

uses
  HGE, UTestBase;

procedure Test;
var
  I: Integer;
begin
  for I := 0 to 99 do
    Engine.Gfx_RenderLine(
      Engine.Random_Float(0,799),
      Engine.Random_Float(0,599),
      Engine.Random_Float(0,799),
      Engine.Random_Float(0,599),
      Longword(Engine.Random_Int(0,$FFFFFF)) or $FF000000);
end;

initialization
  RegisterTest('Gfx_RenderLine','HGE\Gfx\UGfx_Line',Test);

end.
