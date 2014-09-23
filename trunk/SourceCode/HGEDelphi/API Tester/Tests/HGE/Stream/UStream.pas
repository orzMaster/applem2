unit UStream;

interface

implementation

uses
  HGE, UTestBase;

procedure Test;
var
  Stream: IStream;
begin
  Stream := Engine.Stream_Load('Stream.ogg');
  Stream.Play(True); // Looped
  while Running do ;
end;

initialization
  RegisterTest('Stream Functions','HGE\Stream\UStream',Test);

end.
