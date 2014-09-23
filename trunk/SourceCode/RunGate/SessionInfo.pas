unit SessionInfo;

interface
uses
  Windows, Classes, SysUtils, StrUtils, GateShare, HUtil32;

type
  TCenterSessionInfo = record
    sAccount: string;
    sIPaddr: string;
    sUserName: string;
    nSessionID: Integer;
    boStartPlay: Boolean;
    dAddDate: TDateTime;
    LoginTime: TDateTime;
    nSockIndex: Integer;
    wGatePort: Word;
  end;
  pTCenterSessionInfo = ^TCenterSessionInfo;

var
  GlobaSessionList: TGList;
  m_sCenterMsg: string;
  S_SessionCount: Integer = 0;

procedure ClearAllSessionInfo();
procedure ProcessCenterMsg();
procedure ProcessAddSession(sData: string);
procedure ProcessDelSession(sData: string);
procedure ProcessGetOnlineCount(sData: string);
function CheckSession(sAccount, sName: string; nSessionID, nSockIndex: Integer): Boolean;
procedure DelSession(sAccount: string; nSessionID: Integer);
procedure SetSession(sAccount, sName: string; nSessionID, Port: Integer);

implementation
uses
  Common, GateCommon;

procedure ClearAllSessionInfo();
var
  i: integer;
  GlobaSessionInfo: pTCenterSessionInfo;
begin
  GlobaSessionList.Lock;
  try
    for I := 0 to GlobaSessionList.Count - 1 do begin
      GlobaSessionInfo := GlobaSessionList.Items[I];
      Dispose(GlobaSessionInfo);
    end;
    GlobaSessionList.Clear;
  finally
    GlobaSessionList.UnLock;
  end;
  S_SessionCount := 0;
end;

procedure ProcessCenterMsg();
var
  sScoketText: string;
  sData: string;
  sCode: string;
  sBody: string;
  nIdent: Integer;
begin
  sScoketText := m_sCenterMsg;
  while (Pos(')', sScoketText) > 0) do begin
    sScoketText := ArrestStringEx(sScoketText, '(', ')', sData);
    if sData = '' then
      break;
    sBody := GetValidStr3(sData, sCode, ['/']);
    nIdent := StrToIntDef(sCode, 0);
    case nIdent of
      SS_OPENSESSION {100}: ProcessAddSession(sBody);
      SS_CLOSESESSION {101}: ProcessDelSession(sBody);
      SS_KEEPALIVE {104}: ProcessGetOnlineCount(sBody);
    end;
  end;
  m_sCenterMsg := sScoketText;
end;

procedure ProcessAddSession(sData: string);
var
  sAccount, s10, s14, s18, s20, sIPaddr: string;
  GlobaSessionInfo: pTCenterSessionInfo;
begin
  sData := GetValidStr3(sData, sAccount, ['/']);
  sData := GetValidStr3(sData, s10, ['/']);
  sData := GetValidStr3(sData, s14, ['/']);
  sData := GetValidStr3(sData, s18, ['/']);
  sData := GetValidStr3(sData, s20, ['/']);
  sData := GetValidStr3(sData, sIPaddr, ['/']);
  New(GlobaSessionInfo);
  GlobaSessionInfo.sAccount := sAccount;
  GlobaSessionInfo.sIPaddr := sIPaddr;
  GlobaSessionInfo.nSessionID := StrToIntdef(s10, 0);
  GlobaSessionInfo.boStartPlay := False;
  GlobaSessionInfo.dAddDate := Now();
  GlobaSessionInfo.sUserName := '';
  GlobaSessionInfo.LoginTime := Now;
  GlobaSessionInfo.nSockIndex := -1;
  GlobaSessionInfo.wGatePort := 0;
  GlobaSessionList.Lock;
  try
    GlobaSessionList.Add(GlobaSessionInfo);
  finally
    GlobaSessionList.UnLock;
  end;
end;

procedure ProcessDelSession(sData: string);
var
  sAccount: string;
  i, nSessionID: Integer;
  GlobaSessionInfo: pTCenterSessionInfo;
begin
  sData := GetValidStr3(sData, sAccount, ['/']);
  nSessionID := StrToIntDef(sData, 0);
  GlobaSessionList.Lock;
  try
    for i := 0 to GlobaSessionList.Count - 1 do begin
      GlobaSessionInfo := GlobaSessionList.Items[i];
      if GlobaSessionInfo <> nil then begin
        if (GlobaSessionInfo.nSessionID = nSessionID) and
          (GlobaSessionInfo.sAccount = sAccount) then begin
          if GlobaSessionInfo.boStartPlay then
            Dec(S_SessionCount);
          Dispose(GlobaSessionInfo);
          GlobaSessionList.Delete(i);
          break;
        end;
      end;
    end;
  finally
    GlobaSessionList.UnLock;
  end;
end;

procedure DelSession(sAccount: string; nSessionID: Integer);
var
  i: integer;
  GlobaSessionInfo: pTCenterSessionInfo;
begin
  GlobaSessionList.Lock;
  try
    for I := 0 to GlobaSessionList.Count - 1 do begin
      GlobaSessionInfo := GlobaSessionList.Items[i];
      if (GlobaSessionInfo.nSessionID = nSessionID) and
        (GlobaSessionInfo.sAccount = sAccount) and
        (GlobaSessionInfo.boStartPlay) then begin
        SendMapMsg(gt_RunGate, GS_USERGHOST, sAccount + '/' + IntToStr(nSessionID));
        GlobaSessionInfo.boStartPlay := False;
        GlobaSessionInfo.LoginTime := Now;
        GlobaSessionInfo.sUserName := '';
        GlobaSessionInfo.nSockIndex := -1;
        GlobaSessionInfo.wGatePort := 0;
        Dec(S_SessionCount);
        break;
      end;
    end;
  finally
    GlobaSessionList.UnLock;
  end;
end;

function CheckSession(sAccount, sName: string; nSessionID, nSockIndex: Integer): Boolean;
var
  i: integer;
  GlobaSessionInfo: pTCenterSessionInfo;
begin
  Result := False;
  GlobaSessionList.Lock;
  try
    for I := 0 to GlobaSessionList.Count - 1 do begin
      GlobaSessionInfo := GlobaSessionList.Items[i];
      if (GlobaSessionInfo.nSessionID = nSessionID) and
        (GlobaSessionInfo.sAccount = sAccount) and
        (not GlobaSessionInfo.boStartPlay) then begin
        GlobaSessionInfo.boStartPlay := True;
        GlobaSessionInfo.LoginTime := Now;
        GlobaSessionInfo.sUserName := sName;
        GlobaSessionInfo.nSockIndex := nSockIndex;
        SendMapMsg(gt_RunGate, GS_USERLOGIN, sAccount + '/' + IntToStr(nSessionID) + '/' + sName + '/' + IntToStr(GatePort));
        Inc(S_SessionCount);
        Result := True;
        break;
      end;
    end;
  finally
    GlobaSessionList.UnLock;
  end;
end;

procedure SetSession(sAccount, sName: string; nSessionID, Port: Integer);
var
  i: integer;
  GlobaSessionInfo: pTCenterSessionInfo;
begin
  GlobaSessionList.Lock;
  try
    for I := 0 to GlobaSessionList.Count - 1 do begin
      GlobaSessionInfo := GlobaSessionList.Items[i];
      if (GlobaSessionInfo.nSessionID = nSessionID) and (GlobaSessionInfo.sAccount = sAccount) then begin
        GlobaSessionInfo.sUserName := sName;
        GlobaSessionInfo.wGatePort := Port;
        break;
      end;
    end;
  finally
    GlobaSessionList.UnLock;
  end;
end;

procedure ProcessGetOnlineCount(sData: string);
begin
  //
end;

end.

