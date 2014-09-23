unit UIni;

interface

implementation

uses
  SysUtils, HGE, HGEFont, UTestBase;

procedure Test;
var
  I: Integer;
  F: Single;
  S: String;
begin
  // After execution, open inifile.ini in application directory
  Engine.System_SetState(HGE_INIFILE,'inifile.ini');
  Engine.Ini_SetInt('section','intval',123);
  Engine.Ini_SetFloat('section','floatval',456.789);
  Engine.Ini_SetString('section','stringval','my string');

  I := Engine.Ini_GetInt('section','intval',0);
  F := Engine.Ini_GetFloat('section','floatval',0);
  S := Engine.Ini_GetString('section','stringval','');

  LargeFont.PrintF(10,10,HGETEXT_LEFT,'Integer value: %d',[I]);
  LargeFont.PrintF(10,40,HGETEXT_LEFT,'Float value: %g',[F]);
  LargeFont.PrintF(10,70,HGETEXT_LEFT,'String value: %s',[S]);
end;

initialization
  RegisterTest('Inifile Functions','HGE\Ini\UIni',Test);

end.
