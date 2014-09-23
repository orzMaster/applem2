unit PlugMain;

interface

uses
  CoralWry,StrUtils,SysUtils, EngineAPI;



procedure InitPlug();
procedure UnInitPlug(boExit: Boolean);
function  GetIPLocal(Msg:PChar;LoMsg:PChar;LoMsgLen:Integer):integer;stdcall;



implementation

var
  QQwry:TCoralWry;

procedure InitPlug();
begin
  QQwry:=TCoralWry.Create(GetPlugDir^ + 'CoralWry.dat');
end;

procedure UnInitPlug(boExit: Boolean);
begin
  QQwry.Free;
end;

function  GetIPLocal(Msg:PChar;LoMsg:PChar;LoMsgLen:Integer):integer;stdcall;
var
  sMsg:String;
begin
  sMsg:=QQwry.GetIp(Msg);
  Move(sMsg[1],LoMsg^,Length(sMsg));
  Result:=0;
end;

end.
