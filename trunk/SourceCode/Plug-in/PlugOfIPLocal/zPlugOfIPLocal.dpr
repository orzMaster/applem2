library zPlugOfIPLocal;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  Windows,
  grobal2 in '..\..\Common\grobal2.pas',
  EngineType in '..\..\Common\EngineType.pas',
  EngineAPI in '..\..\Common\EngineAPI.pas',
  HUtil32 in '..\..\Common\HUtil32.pas',
  PlugMain in 'PlugMain.pas',
  CoralWry in 'CoralWry.pas';

{$R *.res}

const
  PlugName    = 'IP所在地区查询插件 (2009/04/22)';
  LoadPlus    = '加载IP所在地区查询插件成功...';
  UnLoadPlus = '卸载IP所在地区查询插件成功...';
  ProcName    = 'GetIPLocal';

type
  TMsgProc   = procedure(Msg:PChar;nMsgLen:Integer;nMode:Integer);stdcall;
  TFindProc  = function(sProcName:PChar;nNameLen:Integer):Pointer;stdcall;
  TFindObj   = function(sObjName:PChar;nNameLen:Integer):TObject;stdcall;
  TSetProc   = function(ProcAddr:Pointer;ProcName:PChar;nNameLen:Integer):Boolean;stdcall;

var
  OutMessage: TMsgProc;
  OutSetProc: TSetProc;


function Load(AppHandle:HWnd;MsgProc:TMsgProc;FindProc:TFindProc;SetProc:TSetProc;FindObj:TFindObj;LoadMode:Integer):PChar;stdcall;
begin
  MsgProc(LoadPlus,length(LoadPlus),LoadMode);
  OutMessage := MsgProc;
  OutSetProc := SetProc;
  InitPlug();
  OutSetProc(@GetIPLocal,ProcName,length(ProcName));
  Result:=PlugName;
end;

procedure UnLoad(boExit: Boolean);stdcall;
begin
  OutSetProc(nil,ProcName,length(ProcName));
  UnInitPlug(boExit);
  OutMessage(UnLoadPlus, length(UnLoadPlus), 1);
end;

function UnModule(ModuleHookType: Integer; OldPointer, NewPointer: Pointer): Boolean; stdcall;
begin
  Result := False;
end;

exports
  Load, UnLoad, UnModule;
begin
end.
