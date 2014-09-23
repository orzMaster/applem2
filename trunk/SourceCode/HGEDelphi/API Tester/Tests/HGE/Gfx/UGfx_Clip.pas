unit UGfx_Clip;

interface

implementation

uses
  HGE, UTestBase;

procedure Test;
var
  I: Integer;
begin
  Engine.Gfx_SetClipping(200,100,400,400);
  for I := 0 to 99 do
    Engine.Gfx_RenderLine(
      Engine.Random_Float(0,799),
      Engine.Random_Float(0,599),
      Engine.Random_Float(0,799),
      Engine.Random_Float(0,599),
      Longword(Engine.Random_Int(0,$FFFFFF)) or $FF000000);
  Engine.Gfx_SetClipping;
end;

initialization
  RegisterTest('Gfx_SetClipping','HGE\Gfx\UGfx_Clip',Test);

end.
