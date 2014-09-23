unit Conndll;

interface
uses
  Windows;

function GetDllFileName(): String;
function GetConnectPort(): Integer;
function GetConnectPassword(): String;

implementation

Const
  CONNDLL_NAME = 'myconn.dll';
  CONNDLL_GETCONNECTPROTNAME = 'GetConnectPort';
  CONNDLL_GETCONNECTPASSWORDNAME = 'GetConnectPassword';

type
  TConnDll_GetConnectPort = function(): Integer; stdcall;
  TConnDll_GetConnectPassword = function(lpFilename: PChar; nSize: Integer): Boolean; stdcall;

var
  ConnDll_Moudle: THandle = 0;
  ConnDll_GetConnectPort: TConnDll_GetConnectPort;
  ConnDll_GetConnectPassword: TConnDll_GetConnectPassword;

function GetDllFileName(): String;
begin
  Result := CONNDLL_NAME;
end;

function GetConnectPassword(): String;
var
  Password : String;
begin
  Result := '';
  if (ConnDll_Moudle > 32) and Assigned(ConnDll_GetConnectPassword) then begin
    SetLength(Password, 200);
    if ConnDll_GetConnectPassword(PChar(Password), Length(Password)) then
      Result := PChar(Password);
  end;
end;

function GetConnectPort(): Integer;
begin
  Result := 0;
  if (ConnDll_Moudle > 32) and Assigned(ConnDll_GetConnectPort) then begin
    Result := ConnDll_GetConnectPort();
  end;
end;

initialization
  begin
    ConnDll_Moudle := LoadLibrary(CONNDLL_NAME);
    if ConnDll_Moudle > 32 then begin
      ConnDll_GetConnectPort := GetProcAddress(ConnDll_Moudle, CONNDLL_GETCONNECTPROTNAME);
      ConnDll_GetConnectPassword := GetProcAddress(ConnDll_Moudle, CONNDLL_GETCONNECTPASSWORDNAME);
    end;
  end;

finalization
  begin
    if ConnDll_Moudle > 32 then
      FreeLibrary(ConnDll_Moudle);
  end;

end.

