unit USystem_Log;

interface

implementation

uses
  HGE, UTestBase;

procedure Test;
begin
  // After execution, open logfile.txt in application directory
  Engine.System_SetState(HGE_LOGFILE,'logfile.txt');
  Engine.System_Log('This line is logged to logfile.txt');
  Engine.System_Log('This line is %s',['formatted']);
  Engine.System_SetState(HGE_LOGFILE,'');
end;

initialization
  RegisterTest('System_Log','HGE\System\USystem_Log',Test);
  
end.
