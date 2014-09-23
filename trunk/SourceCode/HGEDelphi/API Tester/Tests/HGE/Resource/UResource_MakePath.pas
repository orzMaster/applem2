unit UResource_MakePath;

interface

implementation

uses
  Windows, HGE, HGEFont, UTestBase;

procedure Test;
var
  FullPath: String;
begin
  FullPath := Engine.Resource_MakePath('testfile.dat');
  SmallFont.Render(10,10,HGETEXT_LEFT,FullPath);
end;

initialization
  RegisterTest('Resource_MakePath','HGE\Resource\UResource_MakePath',Test);

end.
