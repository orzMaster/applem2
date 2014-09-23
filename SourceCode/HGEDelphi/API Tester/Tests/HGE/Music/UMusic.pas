unit UMusic;

interface

implementation

uses
  HGE, UTestBase;

procedure Test;
var
  Music: IMusic;
begin
  Music := Engine.Music_Load('Music.s3m');
  Music.Play(True); // Looped
  while Running do ;
end;

initialization
  RegisterTest('Music Functions','HGE\Music\UMusic',Test);

end.
