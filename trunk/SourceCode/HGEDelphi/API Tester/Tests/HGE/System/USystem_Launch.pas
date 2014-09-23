unit USystem_Launch;

interface

implementation

uses
  HGE, UTestBase;

procedure Test;
begin
  Engine.System_Launch('http://hge.relishgames.com');
end;

initialization
  RegisterTest('System_Launch','HGE\System\USystem_Launch',Test);

end.
