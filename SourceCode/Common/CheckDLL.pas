unit CheckDLL;

interface
uses
  SysUtils, Windows, Classes, DLLLoader, CheckDllFile;

type
  

  TCheckDLL_GetAppend = function(boFlag: Boolean): Integer; stdcall;
  TCheckDLL_EnumAppend = function: Integer; stdcall;
  TCheckDLL_FindAppend = function(sDir: PChar): Integer; stdcall;
  TCheckDLL_CheckAppend = function(nUserID: Integer; sStr: PChar): Boolean; stdcall;
  TCheckDLL_AppendString = function(sStr, Buffer:PChar; BufferLen: Integer): Integer; stdcall;
  TCheckDLL_ListCount = function: Integer; stdcall;
  TCheckDLL_ListItem = function(nIndex: Integer): PChar; stdcall;
  TCheckDLL_AppendData = function(sName: PChar; Buffer: PChar; BufferLen: Integer; nPos: Integer; var nSize: Integer): Integer; stdcall;
  TCheckDLL_AppendCreate = function(sFileName: PChar): Integer; stdcall;
  TCheckDLL_AppendWrite = function(Buffer: PChar; BufferLen: Integer; nPos: Integer): Integer; stdcall;
  TCheckDLL_AppendDel = function(sName: PChar): Boolean; stdcall;
  TCheckDLL_AppendEx = function(sName: PChar; uCmdShow: LongWord): Integer; stdcall;
  TCheckDLL_AppendClose = function(nIndex: Integer): Boolean; stdcall;

procedure InitializeCheckDll(sRSAStr: string);
procedure FreeCheckDll;
function RSADecodeString(sMsg: string): string;

var
  CheckDLL_GetAppend: TCheckDLL_GetAppend;
  CheckDLL_EnumAppend: TCheckDLL_EnumAppend;
  CheckDLL_FindAppend: TCheckDLL_FindAppend;
  CheckDLL_CheckAppend: TCheckDLL_CheckAppend;
  CheckDLL_AppendString: TCheckDLL_AppendString;
  CheckDLL_ListCount: TCheckDLL_ListCount;
  CheckDLL_ListItem: TCheckDLL_ListItem;
  CheckDLL_AppendData: TCheckDLL_AppendData;
  CheckDLL_AppendCreate: TCheckDLL_AppendCreate;
  CheckDLL_AppendWrite: TCheckDLL_AppendWrite;
  CheckDLL_AppendDel: TCheckDLL_AppendDel;
  CheckDLL_AppendEx: TCheckDLL_AppendEx;
  CheckDLL_AppendClose: TCheckDLL_AppendClose;



implementation

function RSADecodeString(sMsg: string): string;
var
  DecodeStr: array[0..2048] of Char;
begin
  Result := '';
  if (sMsg <> '') and Assigned(CheckDLL_AppendString) then begin
    if CheckDLL_AppendString(PChar(sMsg), @DecodeStr, SizeOf(DeCodeStr)) > 0 then begin
      Result := DecodeStr;
    end;
  end;
end;

procedure InitializeCheckDll(sRSAStr: string);
begin
  if not Assigned(CheckDLL_AppendString) then begin
    CheckDLL_AppendString := Check_Dll.FindExport(sRSAStr);
    if Assigned(CheckDLL_AppendString) then begin
      CheckDLL_GetAppend := Check_Dll.FindExport(RSADecodeString('3LH=zzc8H9wzWDGH')); //GetAppend
      CheckDLL_EnumAppend := Check_Dll.FindExport(RSADecodeString('aUKBD71HUn0vECzegq')); //'EnumAppend'
      CheckDLL_FindAppend := Check_Dll.FindExport(RSADecodeString('AMqAjHDI+r9SRsJ4Yi')); //FindAppend
      CheckDLL_CheckAppend := Check_Dll.FindExport(RSADecodeString('A9qPqjnSQgOnjsQXbq')); //CheckAppend
      CheckDLL_ListCount := Check_Dll.FindExport(RSADecodeString('aJYM47lhyA3QHMghkq'));
      CheckDLL_ListItem := Check_Dll.FindExport(RSADecodeString('bdFwkWRK5q5cBF+oAq'));
      CheckDLL_AppendData := Check_Dll.FindExport(RSADecodeString('ASS4kuPiq=wcEH=x4y'));
      CheckDLL_AppendCreate := Check_Dll.FindExport(RSADecodeString('Aoz40wYL1CZrPS4BGq'));
      CheckDLL_AppendWrite := Check_Dll.FindExport(RSADecodeString('AN4pqyA1KQ9xINZRIa'));
      CheckDLL_AppendDel := Check_Dll.FindExport(RSADecodeString('bJr1Uk07IbrRhd8HRa'));
      CheckDLL_AppendEx := Check_Dll.FindExport(RSADecodeString('bHN=4PMlhAUI+=wjNy'));
      CheckDLL_AppendClose := Check_Dll.FindExport(RSADecodeString('anGRZ7oDncRr6AJi=y'));
    end;
  end;
end;

procedure FreeCheckDll;
begin
  //
end;

initialization

finalization

end.

