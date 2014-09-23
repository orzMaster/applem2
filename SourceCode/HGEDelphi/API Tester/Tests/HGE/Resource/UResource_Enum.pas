unit UResource_Enum;

interface

implementation

uses
  Windows, HGE, HGEFont, UTestBase;

procedure Test;
var
  Y: Integer;
  Wildcard, S: String;
begin
  // Enumerate .png files
  SmallFont.Render(5,5,HGETEXT_LEFT,'.PNG files in application directory:');
  Y := 20;
  Wildcard := '*.png';
  repeat
    S := Engine.Resource_EnumFiles(Wildcard);
    Wildcard := '';
    if (S <> '') then begin
      SmallFont.Render(20,Y,HGETEXT_LEFT,S);
      Inc(Y,Round(SmallFont.GetHeight));
    end;
  until (Y >= 600) or (S = '');

  // Enumerate root directories:
  SmallFont.Render(5,Y + 10,HGETEXT_LEFT,'Subdirectories in application directory:');
  Inc(Y,25);
  Wildcard := '*';
  repeat
    S := Engine.Resource_EnumFolders(Wildcard);
    Wildcard := '';
    if (S <> '') then begin
      SmallFont.Render(20,Y,HGETEXT_LEFT,S);
      Inc(Y,Round(SmallFont.GetHeight));
    end;
  until (Y >= 600) or (S = '');
end;

initialization
  RegisterTest('Resource Enumeration','HGE\Resource\UResource_Enum',Test);

end.
