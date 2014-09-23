unit UsrSoc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, WinSock, Common,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, JSocket, SyncObjs, IniFiles,
  Grobal2, DBShare;
type
  TFrmUserSoc = class(TForm)
    UserSocket: TServerSocket;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure UserSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure UserSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure UserSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure UserSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Timer2Timer(Sender: TObject);
  private
    CS_GateSession: TCriticalSection;
    //    n2DC: Integer;
    //    n2E0: Integer;
    //    n2E4: Integer;
    GateList: TList;
//    CurGate: pTGateInfo;
//    MapList: TStringList;

    function LoadChrNameList(sFileName: string): Boolean;
    function LoadClearMakeIndexList(sFileName: string): Boolean;
    procedure ProcessGateMsg(var GateInfo: pTGateInfo);
    procedure SendKeepAlivePacket(Socket: TCustomWinSocket);
    procedure ProcessUserMsg(var UserInfo: pTUserInfo; sMsg: String; var GateInfo: pTGateInfo);
    procedure CloseUser(sArryIndex, sSockIndex: string; var GateInfo: pTGateInfo);
    procedure OpenUser(sArryIndex, sSockIndex, sIP: string; var GateInfo: pTGateInfo);
    procedure DeCodeUserMsg(sData: string; var UserInfo: pTUserInfo; var GateInfo: pTGateInfo);
    function QueryChr(sData: string; var UserInfo: pTUserInfo; var GateInfo: pTGateInfo): Boolean;

    procedure OutOfConnect(const UserInfo: pTUserInfo; GateInfo: pTGateInfo);

    function SelectChr(sData: string; var UserInfo: pTUserInfo; var GateInfo: pTGateInfo): Boolean;
    procedure SendUserSocket(GateInfo: pTGateInfo; sArrayIndex, sSessionID, sSendMsg: string);
//    function GetMapIndex(sMap: string): Integer;

    //function GateRoutePort(sGateIP: string): Integer;
//    function CheckDenyChrName(sChrName: string): Boolean;

    { Private declarations }
  public
    procedure NewChr(sData: string; var UserInfo: pTUserInfo; var GateInfo: pTGateInfo);
    function DelChr(sData: string; var UserInfo: pTUserInfo; GateInfo: pTGateInfo; boHero: Boolean = False): Boolean;
    procedure ViewChr(var UserInfo: pTUserInfo; GateInfo: pTGateInfo);
    function RenewHum(sData: string; var UserInfo: pTUserInfo; GateInfo: pTGateInfo): Boolean;
    function GateRouteIP(sGateIP: string; var nPort: Integer): string;
    procedure LoadServerInfo();
    procedure AddNewChr(sData: string);
    procedure SaveServerInfo();
    function NewChrData(sChrName: string; nSex, nJob, nHair: Integer; boHero:
      Boolean = False): Boolean;
    function GetUserCount(): Integer;
    procedure SendKickUser(Socket: TCustomWinSocket; SocketHandle: string;
      nKickType: Integer);
    { Public declarations }
  end;

var
  FrmUserSoc: TFrmUserSoc;

implementation

uses HumDB, HUtil32, IDSocCli, EDcode, MudUtil, DBSMain;

{$R *.DFM}

procedure TFrmUserSoc.UserSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  GateInfo: pTGateInfo;
  sIPaddr: string;
begin
  sIPaddr := Socket.RemoteAddress;
  {if not CheckServerIP(sIPaddr) then begin
    MainOutMessage('非法网关连接: ' + sIPaddr);
    Socket.Close;
    Exit;
  end;   }
  UserSocketClientConnected := True;
  User_sRemoteAddress := sIPaddr;
  User_nRemotePort := Socket.RemotePort;
  if not boOpenDBBusy then begin
    New(GateInfo);
    GateInfo.Socket := Socket;
    GateInfo.sGateaddr := sIPaddr;
    GateInfo.sText := '';
    GateInfo.UserList := TList.Create;
    GateInfo.dwTick10 := GetTickCount();
    GateInfo.sSendMsg := '';
    //GateInfo.nGateID   := GetGateID(sIPaddr);
    CS_GateSession.Enter;
    try
      GateList.Add(GateInfo);
    finally
      CS_GateSession.Leave;
    end;
  end
  else begin
    Socket.Close;
  end;
end;

procedure TFrmUserSoc.UserSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i, ii: Integer;
  GateInfo: pTGateInfo;
  UserInfo: pTUserInfo;
begin
  CS_GateSession.Enter;
  try
    {User_sRemoteAddress:='';
    User_nRemotePort:=0;
    UserSocketClientConnected:=FALSE;}
    for i := 0 to GateList.Count - 1 do begin
      GateInfo := GateList.Items[i];
      if GateInfo <> nil then begin
        for ii := 0 to GateInfo.UserList.Count - 1 do begin
          UserInfo := GateInfo.UserList.Items[ii];
          Dispose(UserInfo);
        end;
        GateInfo.UserList.Free;
        GateInfo.UserList := nil;
      end;
      GateList.Delete(i);
      Dispose(GateInfo);
      break;
    end;
  finally
    CS_GateSession.Leave;
  end;
end;

procedure TFrmUserSoc.UserSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
  User_sRemoteAddress := '';
  User_nRemotePort := 0;
  UserSocketClientConnected := False;
end;

procedure TFrmUserSoc.UserSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i: Integer;
  //sReviceMsg: string;
  GateInfo: pTGateInfo;
begin
  CS_GateSession.Enter;
  try
    for i := 0 to GateList.Count - 1 do begin
      GateInfo := GateList.Items[i];
      if GateInfo.Socket = Socket then begin
        GateInfo.sText := GateInfo.sText + Socket.ReceiveText;
        if GateInfo.sText <> '' then begin
          ProcessGateMsg(GateInfo);
        end;
      end;
    end;
  finally
    CS_GateSession.Leave;
  end;
end;

procedure TFrmUserSoc.ViewChr(var UserInfo: pTUserInfo; GateInfo: pTGateInfo);
var
  ChrList: TStringList;
  I, nChrCount, nIndex: Integer;
  HumRecord: THumInfo;
  s40, sChrName, sJob, sLevel: string;
  QuickID: pTQuickID;
  ChrRecord: THumDataInfo;
  btSex: Byte;
begin
  nChrCount := 0;
  s40 := '';
  ChrList := TStringList.Create;
  try
    if HumChrDB.Open and (HumChrDB.FindByAccount(UserInfo.sAccount, ChrList) >= 0) then begin
      try
        if HumDataDB.OpenEx then begin
          for I := 0 to ChrList.Count - 1 do begin
            QuickID := pTQuickID(ChrList.Objects[I]);
            if HumChrDB.GetBy(QuickID.nIndex, HumRecord) and HumRecord.boDeleted and
              (not HumRecord.boGMDeleted) then begin
              sChrName := QuickID.sChrName;
              nIndex := HumDataDB.Index(sChrName);
              if (nIndex < 0) then
                Continue;
              if HumDataDB.Get(nIndex, ChrRecord) >= 0 then begin
                btSex := ChrRecord.Data.btSex;
                sJob := IntToStr(ChrRecord.Data.btJob);
                //sHair := IntToStr(ChrRecord.Data.btHair);
                sLevel := IntToStr(ChrRecord.Data.Abil.Level);
                s40 := s40 + sChrName + '/' + sJob + '/' {+ sHair + '/' }+ sLevel
                  + '/' + IntToStr(btSex) + '/' + IntToStr(ChrRecord.Data.btWuXin) + '/';
                Inc(nChrCount);
              end;
            end;
          end;
        end;
      finally
        HumDataDB.Close;
      end;
    end;
  finally
    HumChrDB.Close;
  end;
  ChrList.Free;
  SendUserSocket(GateInfo,
    UserInfo.sConnID,
    UserInfo.sSockIndex,
    EncodeMessage(MakeDefaultMsg(SM_DELHUM, nChrCount, 0, 0, 0)) +
    EncodeString(s40));
end;

procedure TFrmUserSoc.FormCreate(Sender: TObject);
begin
  CS_GateSession := TCriticalSection.Create;
  GateList := TList.Create;
  //MapList := TStringList.Create;
  UserSocket.Port := g_nGatePort;
  UserSocket.Address := g_sGateAddr;
  UserSocket.Active := True;
  LoadServerInfo();
  LoadChrNameList('DenyChrName.txt');
  LoadClearMakeIndexList('ClearMakeIndex.txt');
  Timer2.Enabled := True;
end;

procedure TFrmUserSoc.FormDestroy(Sender: TObject);
var
  i, ii: Integer;
  GateInfo: pTGateInfo;
  UserInfo: pTUserInfo;
begin
  for i := 0 to GateList.Count - 1 do begin
    GateInfo := GateList.Items[i];
    if GateInfo <> nil then begin
      for ii := 0 to GateInfo.UserList.Count - 1 do begin
        UserInfo := GateInfo.UserList.Items[ii];
        Dispose(UserInfo);
      end;
      GateInfo.UserList.Free;
    end;
    GateList.Delete(i);
    break;
  end;
  GateList.Free;
  //MapList.Free;
  CS_GateSession.Free;
end;

procedure TFrmUserSoc.Timer1Timer(Sender: TObject);
var
  n8: Integer;
begin
  n8 := g_nQueryChrCount + nHackerNewChrCount + nHackerDelChrCount +
    nHackerSelChrCount + n4ADC1C + n4ADC20 + n4ADC24 + n4ADC28;
  if n4ADBB8 <> n8 then begin
    n4ADBB8 := n8;
    MainOutMessage('H-QyChr=' + IntToStr(g_nQueryChrCount) + ' ' +
      'H-NwChr=' + IntToStr(nHackerNewChrCount) + ' ' +
      'H-DlChr=' + IntToStr(nHackerDelChrCount) + ' ' +
      'Dubl-Sl=' + IntToStr(nHackerSelChrCount) + ' ' +
      'H-Er-P1=' + IntToStr(n4ADC1C) + ' ' +
      'Dubl-P2=' + IntToStr(n4ADC20) + ' ' +
      'Dubl-P3=' + IntToStr(n4ADC24) + ' ' +
      'Dubl-P4=' + IntToStr(n4ADC28));
  end;
end;

procedure TFrmUserSoc.Timer2Timer(Sender: TObject);
var
  i: Integer;
  GateInfo: pTGateInfo;
  nSendLen: Integer;
  sData: string;
begin
  CS_GateSession.Enter;
  try
    for i := 0 to GateList.Count - 1 do begin
      GateInfo := GateList.Items[i];
      if (GateInfo.Socket <> nil) and (GateInfo.sSendMsg <> '') then begin
        while (GateInfo.sSendMsg <> '') do begin
          nSendLen := Length(GateInfo.sSendMsg);
          if nSendLen > MAXSOCKETBUFFLEN then begin
            sData := Copy(GateInfo.sSendMsg, 1, MAXSOCKETBUFFLEN);
            if GateInfo.Socket.SendText(sData) <> -1 then begin
              GateInfo.sSendMsg := Copy(GateInfo.sSendMsg, MAXSOCKETBUFFLEN + 1, nSendLen - MAXSOCKETBUFFLEN);
            end
            else
              break;
          end
          else begin
            if GateInfo.Socket.SendText(GateInfo.sSendMsg) <> -1 then
              GateInfo.sSendMsg := '';
            break;
          end;
        end;
      end;
    end;
  finally
    CS_GateSession.Leave;
  end;
end;

function TFrmUserSoc.GetUserCount(): Integer;
var
  i: Integer;
  GateInfo: pTGateInfo;
  nUserCount: Integer;
begin
  nUserCount := 0;
  CS_GateSession.Enter;
  try
    for i := 0 to GateList.Count - 1 do begin
      GateInfo := GateList.Items[i];
      Inc(nUserCount, GateInfo.UserList.Count);
    end;
  finally
    CS_GateSession.Leave;
  end;
  Result := nUserCount;
end;

function TFrmUserSoc.NewChrData(sChrName: string; nSex, nJob, nHair: Integer;
  boHero: Boolean = False): Boolean;
var
  ChrRecord: THumDataInfo;
begin
  Result := False;
  try
    if HumDataDB.Open and (HumDataDB.Index(sChrName) = -1) then begin
      SafeFillChar(ChrRecord, SizeOf(THumDataInfo), #0);
      ChrRecord.Header.sName := sChrName;
      ChrRecord.Data.sChrName := sChrName;
      {ChrRecord.Data.btSex := nSex;
      ChrRecord.Data.btJob := Random(3);
      ChrRecord.Data.Abil.Level := Random(150) + 1;
      ChrRecord.Data.Abil.Exp := Random(5000000);
      ChrRecord.Data.btMasterCount := Random(200);
      ChrRecord.Data.btHair := 1 {nHair};
      //ChrRecord.Data.boHero := Random(2)=0;
      ChrRecord.Data.btSex := nSex;
      ChrRecord.Data.btJob := nJob;
      ChrRecord.Data.btHair := 1 {nHair};
      Chrrecord.Data.btWuXin := nHair;
      //ChrRecord.Data.boHero := boHero;
      HumDataDB.Add(ChrRecord);
      Result := True;
    end;
  finally
    HumDataDB.Close;
  end;
end;

procedure TFrmUserSoc.SaveServerInfo();
var
  I, II: Integer;
  sTest: string;
  SaveList: TStringList;
begin
  SaveList := TStringList.Create;
  try
    SaveList.Clear;
    for I := Low(g_RouteInfo) to High(g_RouteInfo) do begin
      sTest := '';
      if (g_RouteInfo[I].sSelGateIP <> '') and (g_RouteInfo[I].nGateCount > 0)
        then begin
        sTest := g_RouteInfo[I].sSelGateIP;
        for II := 0 to g_RouteInfo[I].nGateCount - 1 do begin
          if (g_RouteInfo[I].sGameGateIP[II] <> '') and
            (g_RouteInfo[I].nGameGatePort[II] > 0) then
            sTest := sTest + ' ' + g_RouteInfo[I].sGameGateIP[II] + ' ' +
              IntToStr(g_RouteInfo[I].nGameGatePort[II]);
        end;
        SaveList.Add(sTest);
      end;
    end;
    SaveList.SaveToFile(sGateConfFileName);
  finally
    SaveList.Free;
  end;
end;

procedure TFrmUserSoc.LoadServerInfo;
var
  i: Integer;
  LoadList: TStringList;
  nRouteIdx, nGateIdx{, nServerIndex}: Integer;
  sLineText, sSelGateIPaddr, sGameGateIPaddr, sGameGate, sGameGatePort
    {sMapName, sMapInfo, sServerIndex}: string;
  //Conf: TIniFile;
begin
  try
    LoadList := TStringList.Create;
    SafeFillChar(g_RouteInfo, SizeOf(g_RouteInfo), #0);
    LoadList.LoadFromFile(sGateConfFileName);
    nRouteIdx := 0;
    //    nGateIdx := 0;
    for i := 0 to LoadList.Count - 1 do begin
      sLineText := Trim(LoadList.Strings[i]);
      if (sLineText <> '') and (sLineText[1] <> ';') then begin
        sGameGate := GetValidStr3(sLineText, sSelGateIPaddr, [' ', #9]);
        if (sGameGate = '') or (sSelGateIPaddr = '') then
          Continue;
        g_RouteInfo[nRouteIdx].sSelGateIP := Trim(sSelGateIPaddr);
        g_RouteInfo[nRouteIdx].nGateCount := 0;
        nGateIdx := 0;
        while (sGameGate <> '') do begin
          sGameGate := GetValidStr3(sGameGate, sGameGateIPaddr, [' ', #9]);
          sGameGate := GetValidStr3(sGameGate, sGameGatePort, [' ', #9]);
          g_RouteInfo[nRouteIdx].sGameGateIP[nGateIdx] := Trim(sGameGateIPaddr);
          g_RouteInfo[nRouteIdx].nGameGatePort[nGateIdx] :=
            StrToIntDef(sGameGatePort, 0);
          Inc(nGateIdx);
        end;
        g_RouteInfo[nRouteIdx].nGateCount := nGateIdx;
        Inc(nRouteIdx);
      end;
    end;
    {Conf := TIniFile.Create(sConfFileName);
    sMapFile := Conf.ReadString('Setup', 'MapFile', sMapFile);
    Conf.Free;
    MapList.Clear;
    if FileExists(sMapFile) then begin
      LoadList.Clear;
      LoadList.LoadFromFile(sMapFile);
      for i := 0 to LoadList.Count - 1 do begin
        sLineText := LoadList.Strings[i];
        if (sLineText <> '') and (sLineText[1] = '[') then begin
          sLineText := ArrestStringEx(sLineText, '[', ']', sMapName);
          sMapInfo := GetValidStr3(sMapName, sMapName, [#32, #9]);
          sServerIndex := Trim(GetValidStr3(sMapInfo, sMapInfo, [#32, #9]));
          nServerIndex := StrToIntDef(sServerIndex, 0);
          MapList.AddObject(sMapName, TObject(nServerIndex));
        end;
      end;
    end; }
    LoadList.Free;
  finally
  end;
end;

function TFrmUserSoc.LoadChrNameList(sFileName: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  if FileExists(sFileName) then begin
    DenyChrNameList.LoadFromFile(sFileName);
    i := 0;
    while (True) do begin
      if DenyChrNameList.Count <= i then
        break;
      if Trim(DenyChrNameList.Strings[i]) = '' then begin
        DenyChrNameList.Delete(i);
        Continue;
      end;
      Inc(i);
    end;
    Result := True;
  end;
end;

function TFrmUserSoc.LoadClearMakeIndexList(sFileName: string): Boolean;
var
  i: Integer;
  nIndex: Integer;
  sLineText: string;
begin
  Result := False;
  if FileExists(sFileName) then begin
    g_ClearMakeIndex.LoadFromFile(sFileName);
    i := 0;
    while (True) do begin
      if g_ClearMakeIndex.Count <= i then
        break;
      sLineText := g_ClearMakeIndex.Strings[i];
      nIndex := StrToIntDef(sLineText, -1);
      if nIndex < 0 then begin
        g_ClearMakeIndex.Delete(i);
        Continue;
      end;
      g_ClearMakeIndex.Objects[i] := TObject(nIndex);
      Inc(i);
    end;
    Result := True;
  end;
end;

procedure TFrmUserSoc.ProcessGateMsg(var GateInfo: pTGateInfo);
var
  sSockIndex: string;
  sArryIndex: string;
  s10: string;
  s19: Char;
  i: Integer;
  UserInfo: pTUserInfo;
  //nCount: Integer;
begin
  //nCount := 0;
  while True do begin
    if Pos(MG_CodeEnd, GateInfo.sText) <= 0 then break;
    GateInfo.sText := ArrestStringEx(GateInfo.sText, MG_CodeHead, MG_CodeEnd, s10);
    //%O308/127.0.0.1/127.0.0.1$
    //%A308/#2<<<<<BL<<<<<<<<<H?<lH>xq!$
    if s10 <> '' then begin
      s19 := s10[1];
      s10 := Copy(s10, 2, Length(s10) - 1);
      //s19:=UpperCase(s19);
      case s19 of
        '-': begin
            SendKeepAlivePacket(GateInfo.Socket);
            dwKeepAliveTick := GetTickCount();
          end;
        MG_SendUser: begin
            s10 := GetValidStr3(s10, sArryIndex, ['/']);
            s10 := GetValidStr3(s10, sSockIndex, ['/']);
            if sSockIndex <> '' then begin
              i := 0;
              while True do begin
              //for i := 0 to GateInfo.UserList.Count - 1 do begin
                if i >= GateInfo.UserList.Count then break;
                UserInfo := GateInfo.UserList.Items[i];
                if UserInfo <> nil then begin
                  if UserInfo.sConnID = sArryIndex then begin
                    if Length(s10) < 256 then begin
                      ProcessUserMsg(UserInfo, s10, GateInfo);
                    end;
                    break;
                  end;
                end;
                Inc(i);
              end;
            end;
          end;
        MG_OpenUser: begin
            s10 := GetValidStr3(s10, sArryIndex, ['/']);
            s10 := GetValidStr3(s10, sSockIndex, ['/']);
            if sSockIndex <> '' then
              OpenUser(sArryIndex, sSockIndex, s10, GateInfo);
          end;
        MG_CloseUser: begin
            sSockIndex := GetValidStr3(s10, sArryIndex, ['/']);
            if sSockIndex <> '' then
              CloseUser(sArryIndex, sSockIndex, GateInfo);
          end;
      else begin
          GateInfo.sText := '';
          break;
        end;
      end;
    end;
  end;
end;

procedure TFrmUserSoc.SendKeepAlivePacket(Socket: TCustomWinSocket);
begin
  if Socket.Connected then
    Socket.SendText('%++$');
end;

procedure TFrmUserSoc.SendKickUser(Socket: TCustomWinSocket; SocketHandle:
  string; nKickType: Integer);
begin
  if (Socket <> nil) and Socket.Connected then begin
    case nKickType of
      0: Socket.SendText('%+-' + SocketHandle + '$');
      1: Socket.SendText('%+T' + SocketHandle + '$');
      2: Socket.SendText('%+B' + SocketHandle + '$');
    end;
  end;
end;

procedure TFrmUserSoc.ProcessUserMsg(var UserInfo: pTUserInfo; sMsg: String; var GateInfo: pTGateInfo);
var
  s10: string;
begin
  ArrestStringEx(sMsg, g_CodeHead, g_CodeEnd, s10);
  if s10 <> '' then begin
    s10 := Copy(s10, 2, Length(s10) - 1);
    if Length(s10) >= DEFBLOCKSIZE then begin
      DeCodeUserMsg(s10, UserInfo, GateInfo);
    end
    else
      Inc(n4ADC20);
  end
  else begin
    Inc(n4ADC1C);
  end;
end;

procedure TFrmUserSoc.OpenUser(sArryIndex, sSockIndex, sIP: string; var
  GateInfo: pTGateInfo);
var
  i: Integer;
  UserInfo: pTUserInfo;
  sUserIPaddr: string;
  sGateIPaddr: string;
begin
  sGateIPaddr := GetValidStr3(sIP, sUserIPaddr, ['/']);
  for i := 0 to GateInfo.UserList.Count - 1 do begin
    UserInfo := GateInfo.UserList.Items[i];
    if (UserInfo <> nil) and (UserInfo.sConnID = sArryIndex) then begin
      UserInfo.Socket := GateInfo.Socket;
      UserInfo.nSelGateID := GateInfo.nGateID;
      UserInfo.sSockIndex := sSockIndex;
      UserInfo.sAccount := '';
      UserInfo.nSessionID := 0;
      UserInfo.dwChrTick := 0;
      UserInfo.boWaitMsg := False;
      UserInfo.nWaitID := 0;
      Exit;
    end;
  end;
  New(UserInfo);
  UserInfo.sAccount := '';
  UserInfo.sUserIPaddr := sUserIPaddr;
  UserInfo.sGateIPaddr := sGateIPaddr;
  UserInfo.sConnID := sArryIndex;
  UserInfo.sSockIndex := sSockIndex;
  UserInfo.nSessionID := 0;
  UserInfo.Socket := GateInfo.Socket;
  //UserInfo.s2C := '';
  UserInfo.dwTick34 := GetTickCount();
  UserInfo.dwChrTick := 0;
  UserInfo.boChrSelected := False;
  UserInfo.boChrQueryed := False;
  UserInfo.nSelGateID := GateInfo.nGateID;
  UserInfo.nDataCount := 0;
  UserInfo.boWaitMsg := False;
  UserInfo.nWaitID := 0;
  GateInfo.UserList.Add(UserInfo);
end;

procedure TFrmUserSoc.CloseUser(sArryIndex, sSockIndex: string; var GateInfo:
  pTGateInfo);
var
  i: Integer;
  UserInfo: pTUserInfo;
begin
  for i := 0 to GateInfo.UserList.Count - 1 do begin
    UserInfo := GateInfo.UserList.Items[i];
    if (UserInfo <> nil) and (UserInfo.sConnID = sArryIndex) then begin
      if not FrmIDSoc.GetGlobaSessionStatus(UserInfo.nSessionID) then begin
        FrmIDSoc.SendSocketMsg(SS_SOFTOUTSESSION, UserInfo.sAccount + '/' + IntToStr(UserInfo.nSessionID));
        FrmIDSoc.CloseSession(UserInfo.sAccount, UserInfo.nSessionID);
      end;
      Dispose(UserInfo);
      GateInfo.UserList.Delete(i);
      break;
    end;
  end;
end;

procedure TFrmUserSoc.DeCodeUserMsg(sData: string; var UserInfo: pTUserInfo; var GateInfo: pTGateInfo);
var
  sDefMsg, s18: string;
  Msg: TDefaultMessage;
begin
  sDefMsg := Copy(sData, 1, DEFBLOCKSIZE);
  s18 := Copy(sData, DEFBLOCKSIZE + 1, Length(sData) - DEFBLOCKSIZE);
  Msg := DecodeMessage(sDefMsg);
  case Msg.Ident of
    CM_QUERYCHR: begin
        if not UserInfo.boWaitMsg then begin
          if (not UserInfo.boChrQueryed) or ((GetTickCount - UserInfo.dwChrTick) > 200) then begin
            UserInfo.dwChrTick := GetTickCount();
            if QueryChr(s18, UserInfo, GateInfo) then begin
              UserInfo.boChrQueryed := True;
            end;
          end
          else begin
            {if boAttack and AddAttackIP(UserInfo.sUserIPaddr) then
              SendKickUser(UserInfo.Socket, UserInfo.sConnID, 0); }
            Inc(g_nQueryChrCount);
            MainOutMessage('[超速操作] 查询人物 ' + UserInfo.sUserIPaddr);
          end;
        end;
      end;
    CM_NEWCHR: begin
        if not UserInfo.boWaitMsg then begin
          if (GetTickCount - UserInfo.dwChrTick) > 1000 then begin
            UserInfo.dwChrTick := GetTickCount();
            if (UserInfo.sAccount <> '') and
              FrmIDSoc.CheckSession(UserInfo.sAccount, UserInfo.sUserIPaddr, UserInfo.nSessionID) then begin
              NewChr(s18, UserInfo, GateInfo);
              UserInfo.boChrQueryed := False;
            end
            else begin
              OutOfConnect(UserInfo, GateInfo);
            end;
          end
          else begin
            {if boAttack and AddAttackIP(UserInfo.sUserIPaddr) then
              SendKickUser(UserInfo.Socket, UserInfo.sConnID, 1);   }
            Inc(nHackerNewChrCount);
            MainOutMessage('[超速操作] 创建人物 ' + UserInfo.sAccount + '/'
              +
              UserInfo.sUserIPaddr);
          end;
        end;
      end;
    CM_DELCHR: begin
        if not UserInfo.boWaitMsg then begin
          if (GetTickCount - UserInfo.dwChrTick) > 500 then begin
            UserInfo.dwChrTick := GetTickCount();
            if (UserInfo.sAccount <> '') and
              FrmIDSoc.CheckSession(UserInfo.sAccount, UserInfo.sUserIPaddr, UserInfo.nSessionID) then begin
              DelChr(s18, UserInfo, GateInfo);
              UserInfo.boChrQueryed := False;
            end
            else begin
              OutOfConnect(UserInfo, GateInfo);
            end;
          end
          else begin
            {if boAttack and AddAttackIP(UserInfo.sUserIPaddr) then
              SendKickUser(UserInfo.Socket, UserInfo.sConnID, 0);  }
            Inc(nHackerDelChrCount);
            MainOutMessage('[超速操作] 删除人物' + UserInfo.sAccount + '/'
              +
              UserInfo.sUserIPaddr);
          end;
        end;
      end;
    CM_SELCHR: begin
        if not UserInfo.boWaitMsg then begin
          if not UserInfo.boChrSelected then begin
            if (UserInfo.sAccount <> '') and
              FrmIDSoc.CheckSession(UserInfo.sAccount, UserInfo.sUserIPaddr, UserInfo.nSessionID) then begin
              if SelectChr(s18, UserInfo, GateInfo) then begin
                UserInfo.boChrSelected := True;
              end;
            end
            else begin
              OutOfConnect(UserInfo, GateInfo);
            end;
          end
          else begin
            {if boAttack and AddAttackIP(UserInfo.sUserIPaddr) then
              SendKickUser(UserInfo.Socket, UserInfo.sConnID, 1);  }
            Inc(nHackerSelChrCount);
            MainOutMessage('[端口攻击]' + UserInfo.sAccount + '/' + UserInfo.sUserIPaddr);
          end;
        end;
      end;
    CM_VIEWDELHUM: begin
        if not UserInfo.boWaitMsg then begin
          if (GetTIckCount - UserInfo.dwChrTick) > 200 then begin
            UserInfo.dwChrTick := GetTickCount();
            if (UserInfo.sAccount <> '') and
              FrmIDSoc.CheckSession(UserInfo.sAccount, UserInfo.sUserIPaddr, UserInfo.nSessionID) then begin
              ViewChr(UserInfo, GateInfo);
            end
            else begin
              OutOfConnect(UserInfo, GateInfo);
            end;
          end
          else begin
            //Inc(g_nViewDelHum);
            MainOutMessage('[超速操作] 查询已删人物 ' + UserInfo.sUserIPaddr);
          end;
        end;
      end;
    CM_RENEWHUM: begin
        if not UserInfo.boWaitMsg then begin
          if (GetTIckCount - UserInfo.dwChrTick) > 200 then begin
            UserInfo.dwChrTick := GetTickCount();
            if (UserInfo.sAccount <> '') and
              FrmIDSoc.CheckSession(UserInfo.sAccount, UserInfo.sUserIPaddr, UserInfo.nSessionID) then begin
              if RenewHum(s18, UserInfo, GateInfo) then
                SendUserSocket(GateInfo,
                  UserInfo.sConnID,
                  UserInfo.sSockIndex,
                  EncodeMessage(MakeDefaultMsg(SM_RENEWHUM, 1, 0, 0, 0)));
            end
            else begin
              OutOfConnect(UserInfo, GateInfo);
            end;

          end
          else begin
            //Inc(g_nRenewDelHum);
            MainOutMessage('[超速操作] 恢复人物 ' + UserInfo.sUserIPaddr);
          end;
        end;
      end;
  else begin
      Inc(n4ADC24);
    end;
  end;
end;

function TFrmUserSoc.QueryChr(sData: string; var UserInfo: pTUserInfo; var GateInfo: pTGateInfo): Boolean;
var
  sAccount: string;
  sSessionID: string;
  nSessionID: Integer;
  nChrCount: Integer;
  ChrList: TStringList;
  i: Integer;
  nIndex: Integer;
  ChrRecord: THumDataInfo;
  HumRecord: THumInfo;
  QuickID: pTQuickID;
  btSex: Byte;
  sChrName: string;
  sJob: string;
  sHair: string;
  sLevel: string;
  sWuXin: string;
  s40: string;
begin
  Result := False;
  sSessionID := GetValidStr3(DecodeString(sData), sAccount, ['/']);
  nSessionID := StrToIntDef(sSessionID, -2);
  UserInfo.nSessionID := nSessionID;
  nChrCount := 0;
  if FrmIDSoc.CheckSession(sAccount, UserInfo.sUserIPaddr, nSessionID) then begin
    FrmIDSoc.SetGlobaSessionNoPlay(nSessionID);
    UserInfo.sAccount := sAccount;
    ChrList := TStringList.Create;
    try
      if HumChrDB.Open and (HumChrDB.FindByAccount(sAccount, ChrList) >= 0) then
        begin
        try
          if HumDataDB.OpenEx then begin
            for i := 0 to ChrList.Count - 1 do begin
              QuickID := pTQuickID(ChrList.Objects[i]);
              //FrmDBSrv.MemoLog.Lines.Add('UserInfo.nSelGateID: '+IntToStr(UserInfo.nSelGateID)+' QuickID.nIndex: '+IntToStr(QuickID.nIndex));
              //如果选择ID不对,则跳过
              //if QuickID.nIndex <> UserInfo.nSelGateID then Continue;

              if HumChrDB.GetBy(QuickID.nIndex, HumRecord) and
                (not HumRecord.boDeleted) and (not HumRecord.boGMDeleted) then begin
                sChrName := QuickID.sChrName;
                nIndex := HumDataDB.Index(sChrName);
                if (nIndex < 0) or (nChrCount >= 3) then
                  Continue;
                if HumDataDB.Get(nIndex, ChrRecord) >= 0 then begin
                  btSex := ChrRecord.Data.btSex;
                  sJob := IntToStr(ChrRecord.Data.btJob);
                  sHair := IntToStr(ChrRecord.Data.btHair);
                  sLevel := IntToStr(ChrRecord.Data.Abil.Level);
                  sWuXin := IntToStr(ChrRecord.Data.btWuXin);
                  if HumRecord.boSelected then
                    s40 := s40 + '*';
                  s40 := s40 + sChrName + '/' + sJob + '/' + sWuXin + '/' + sLevel
                    + '/' + IntToStr(btSex) + '/';
                  Inc(nChrCount);
                end;
              end;
            end;
          end;
        finally
          HumDataDB.Close;
        end;
      end;
    finally
      HumChrDB.Close;
    end;
    ChrList.Free;
   SendUserSocket(GateInfo,
      UserInfo.sConnID,
      UserInfo.sSockIndex,
      EncodeMessage(MakeDefaultMsg(SM_QUERYCHR, nChrCount, 0, 1, 0)) +
      EncodeString(s40));
    //*ChrName/sJob/sHair/sLevel/sSex/
  end
  else begin
    SendUserSocket(GateInfo,
      UserInfo.sConnID,
      UserInfo.sSockIndex,
      EncodeMessage(MakeDefaultMsg(SM_QUERYCHR_FAIL, nChrCount, 0, 1, 0)));
    CloseUser(UserInfo.sConnID, UserInfo.sSockIndex, GateInfo);
  end;
end;

function TFrmUserSoc.RenewHum(sData: string; var UserInfo: pTUserInfo; GateInfo: pTGateInfo): Boolean;
var
  sChrName, sAccount: string;
  nIndex: Integer;
  HumRecord: THumInfo;
begin
  Result := False;
  if (sData = '') {or (FrmDBSrv.CheckBox1.Checked)} then
    exit;
  sChrName := DecodeString(sData);
  try
    if HumChrDB.Open then begin
      nIndex := HumChrDB.Index(sChrName);
      if HumChrDB.Get(nIndex, HumRecord) = -1 then
        exit;
      sAccount := HumRecord.sAccount;
      if HumRecord.boDeleted and (not HumRecord.boGMDeleted) and (sAccount = UserInfo.sAccount) then begin
        HumRecord.boDeleted := False;
        Inc(HumRecord.btCount);
        HumChrDB.Update(nIndex, HumRecord);
        Result := True;
      end;
    end;
  finally
    HumChrDB.Close;
  end;
end;

procedure TFrmUserSoc.OutOfConnect(const UserInfo: pTUserInfo; GateInfo: pTGateInfo);
var
  Msg: TDefaultMessage;
  sMsg: string;
begin
  Msg := MakeDefaultMsg(SM_OUTOFCONNECTION, 0, 0, 0, 0);
  sMsg := EncodeMessage(Msg);
  SendUserSocket(GateInfo, UserInfo.sConnID, UserInfo.sSockIndex, sMsg);
end;

function TFrmUserSoc.DelChr(sData: string; var UserInfo: pTUserInfo; GateInfo: pTGateInfo; boHero: Boolean = False): Boolean;
var
  sChrName: string;
  boCheck: Boolean;
  Msg: TDefaultMessage;
  sMsg: string;
  n10: Integer;
  HumRecord: THumInfo;
begin
  g_CheckCode.dwThread0 := 1000300;
  sChrName := DecodeString(sData);
  boCheck := False;
  Result := False;
  g_CheckCode.dwThread0 := 1000301;
  try
    if HumChrDB.Open then begin
      n10 := HumChrDB.Index(sChrName);
      if n10 >= 0 then begin
        HumChrDB.Get(n10, HumRecord);
        if boHero or (HumRecord.sAccount = UserInfo.sAccount) then begin
          HumRecord.boDeleted := True;
          HumRecord.dModDate := Now();
          HumChrDB.Update(n10, HumRecord);
          boCheck := True;
          Result := True;
        end;
      end;
    end;
  finally
    HumChrDB.Close;
  end;
  g_CheckCode.dwThread0 := 1000302;
  if not boHero then begin
    if boCheck then
      Msg := MakeDefaultMsg(SM_DELCHR_SUCCESS, 0, 0, 0, 0)
    else
      Msg := MakeDefaultMsg(SM_DELCHR_FAIL, 0, 0, 0, 0);

    sMsg := EncodeMessage(Msg);
    SendUserSocket(GateInfo, UserInfo.sConnID, UserInfo.sSockIndex, sMsg);
    g_CheckCode.dwThread0 := 1000303;
  end;
end;

procedure TFrmUserSoc.AddNewChr(sData: string);
var
  Data, sAccount, sChrName, sHair, sJob, sSex, sCode: string;
  nCode: Integer;
  Msg: TDefaultMessage;
  sMsg: string;
  HumRecord: THumInfo;
  i, II: integer;
  GateInfo: pTGateInfo;
  UserInfo: pTUserInfo;
  boSelect: Boolean;
  nWaitID: Integer;
  StrList: TStringList;
begin
  Data := GetValidStr3(sData, sCode, ['/']);
  Data := GetValidStr3(Data, sAccount, ['/']);
  Data := GetValidStr3(Data, sChrName, ['/']);
  Data := GetValidStr3(Data, sHair, ['/']);
  Data := GetValidStr3(Data, sJob, ['/']);
  Data := GetValidStr3(Data, sSex, ['/']);
  nWaitID := StrToIntDef(sCode, 0);
  nCode := 1;
  if (nWaitID <> 0) and (sAccount <> '') and (sChrName <> '') and (sSex <> '') then begin
    if nCode = 1 then begin
      nCode := -1;
      try
        HumDataDB.Lock;
        if HumDataDB.Index(sChrName) >= 0 then
          nCode := 1;
      finally
        HumDataDB.UnLock;
      end;
      if nCode = -1 then begin
        StrList := TStringList.Create;
        try
          if HumChrDB.Open then begin
            if (HumChrDB.ChrCountOfAccount(sAccount) < 3) then begin
              if HumChrDB.FindByAccount(sAccount, StrList) < 15 then begin
                SafeFillChar(HumRecord, SizeOf(THumInfo), #0);
                HumRecord.sChrName := sChrName;
                HumRecord.sAccount := sAccount;
                HumRecord.boDeleted := False;
                HumRecord.boGMDeleted := False;
                HumRecord.btCount := 0;
                HumRecord.Header.sName := sChrName;
                HumRecord.Header.nSelectID := 0;
                if HumRecord.Header.sName <> '' then
                  if not HumChrDB.Add(HumRecord) then
                    nCode := 3;
              end else
                nCode := 5;
            end
            else
              nCode := 2;
          end;
        finally
          HumChrDB.Close;
          StrList.Free;
        end;
        if nCode = -1 then begin
          if not NewChrData(sChrName, StrToIntDef(sSex, 0), StrToIntDef(sJob, 0), StrToIntDef(sHair, 0), False) then
            nCode := 1;
        end
        else begin
          FrmDBSrv.DelHum(sChrName);
        end;
      end;
    end else begin
      if nCode = -1 then nCode := 1
      else nCode := -2;
    end;
  end;
  boSelect := False;
  for i := 0 to GateList.Count - 1 do begin
    GateInfo := GateList.Items[i];
    if GateInfo.UserList <> nil then begin
      for ii := 0 to GateInfo.UserList.Count - 1 do begin
        UserInfo := GateInfo.UserList[ii];
        if (UserInfo.nWaitID = nWaitID) then begin
          UserInfo.boWaitMsg := False;
          UserInfo.nWaitID := 0;
          if nCode = -1 then begin
            Msg := MakeDefaultMsg(SM_NEWCHR_SUCCESS, 0, 0, 0, 0);
          end
          else begin
            Msg := MakeDefaultMsg(SM_NEWCHR_FAIL, nCode, 0, 0, 0);
          end;
          sMsg := EncodeMessage(Msg);
          SendUserSocket(GateInfo, UserInfo.sConnID, UserInfo.sSockIndex, sMsg);
          boSelect := True;
          break;
        end;
      end;
    end;
    if boSelect then break;
  end;

end;

procedure TFrmUserSoc.NewChr(sData: string; var UserInfo: pTUserInfo; var GateInfo: pTGateInfo);
var
  Data, sAccount, sChrName, sHair, sJob, sSex: string;
  nCode: Integer;
  Msg: TDefaultMessage;
  sMsg: string;
  StrList: TStringList;
//  HumRecord: THumInfo;
//  i: Integer;
begin
  nCode := -1;
  Data := DecodeString(sData);
  Data := GetValidStr3(Data, sAccount, ['/']);
  Data := GetValidStr3(Data, sChrName, ['/']);
  Data := GetValidStr3(Data, sHair, ['/']);
  Data := GetValidStr3(Data, sJob, ['/']);
  Data := GetValidStr3(Data, sSex, ['/']);
  if Trim(Data) <> '' then nCode := 0;
  sChrName := Trim(sChrName);
  if not (Length(sChrName) in [6..14]) then nCode := 4;
  if not CheckCorpsChr(sChrName) then nCode := 0;
  if CheckFiltrateUserName(sChrName) then nCode := 0;

  if nCode = -1 then begin
    try
      HumDataDB.Lock;
      if HumDataDB.Index(sChrName) >= 0 then
        nCode := 1;
    finally
      HumDataDB.UnLock;
    end;
  end;


  if nCode = -1 then begin
    StrList := TStringList.Create;
    try
      if HumChrDB.Open then begin
        if (HumChrDB.ChrCountOfAccount(sAccount) < 3) then begin
          if HumChrDB.FindByAccount(sAccount, StrList) < 15 then begin
            UserInfo.sCreateChrMsg := sChrName;
            UserInfo.boWaitMsg := True;
            UserInfo.nWaitID := GetWaitMsgID;
            if g_boTestServer then
              AddNewChr(IntToStr(UserInfo.nWaitID) + '/' + sAccount + '/' + sChrName+ '/' + sHair + '/' + sJob + '/' + sSex)
            else
              FrmIDSoc.SendSocketMsg(SS_CREATENEWCHR, IntToStr(UserInfo.nWaitID) + '/' + sHair + '/' + sJob + '/' + sSex + '/' + sAccount + '/' + sChrName);
            exit;
          end else
            nCode := 5;
        end
        else
          nCode := 2;
      end;
    finally
      HumChrDB.Close;
      StrList.Free;
    end;
  end;
  if nCode <> -1 then begin
    Msg := MakeDefaultMsg(SM_NEWCHR_FAIL, nCode, 0, 0, 0);
    sMsg := EncodeMessage(Msg);
    SendUserSocket(GateInfo, UserInfo.sConnID, UserInfo.sSockIndex, sMsg);
  end;

end;

function TFrmUserSoc.SelectChr(sData: string; var UserInfo: pTUserInfo; var GateInfo: pTGateInfo): Boolean;
var
  sAccount: string;
  sChrName: string;
  ChrList: TStringList;
  HumRecord: THumInfo;
  i: Integer;
  nIndex: Integer;
  nMapIndex: Integer;
  QuickID: pTQuickID;
  //ChrRecord: THumDataInfo;
  //sCurMap: string;
  boDataOK: Boolean;
  sDefMsg: string;
  sRouteMsg: string;
  sRouteIP: string;
  nRoutePort: Integer;
begin
  Result := False;
  sChrName := GetValidStr3(DecodeString(sData), sAccount, ['/']);
  boDataOK := False;
  if UserInfo.sAccount = sAccount then begin
    try
      if HumChrDB.Open then begin
        ChrList := TStringList.Create;
        if HumChrDB.FindByAccount(sAccount, ChrList) >= 0 then begin
          for i := 0 to ChrList.Count - 1 do begin
            QuickID := pTQuickID(ChrList.Objects[i]);
            nIndex := QuickID.nIndex;
            if HumChrDB.GetBy(nIndex, HumRecord) then begin
              if HumRecord.sChrName = sChrName then begin
                HumRecord.boSelected := True;
                HumChrDB.UpdateBy(nIndex, HumRecord);
              end
              else begin
                if HumRecord.boSelected then begin
                  HumRecord.boSelected := False;
                  HumChrDB.UpdateBy(nIndex, HumRecord);
                end;
              end;
            end;
          end;
        end;
        ChrList.Free;
      end;
    finally
      HumChrDB.Close;
    end;
    try
      if HumDataDB.OpenEx then begin
        nIndex := HumDataDB.Index(sChrName);
        if nIndex >= 0 then begin
          //HumDataDB.Get(nIndex, ChrRecord);
          //sCurMap := ChrRecord.Data.sCurMap;
          boDataOK := True;
        end;
      end;
    finally
      HumDataDB.Close;
    end;
  end;
  if boDataOK then begin
    nMapIndex := 0;
    sDefMsg := EncodeMessage(MakeDefaultMsg(SM_STARTPLAY, 0, 0, 0, 0));

    if g_boDynamicIPMode then
      sRouteIP := UserInfo.sGateIPaddr //使用动态IP
    else
      sRouteIP := GateRouteIP(GateInfo.sGateaddr, nRoutePort);
    //MainOutMessage('sRouteIP+nMapIndex+UserInfo.nSessionID:'+sRouteIP+IntToStr(nMapIndex)+IntToStr(UserInfo.nSessionID));
    sRouteMsg := EncodeString(sRouteIP + '/' + IntToStr(nRoutePort + nMapIndex));
    SendUserSocket(GateInfo,
      UserInfo.sConnID,
      UserInfo.sSockIndex,
      sDefMsg + sRouteMsg);
    FrmIDSoc.SetGlobaSessionPlay(UserInfo.nSessionID);
    Result := True;
  end
  else begin
    SendUserSocket(GateInfo,
      UserInfo.sConnID,
      UserInfo.sSockIndex,
      EncodeMessage(MakeDefaultMsg(SM_STARTFAIL, 0, 0, 0, 0)));
  end;
end;

{function TFrmUserSoc.GateRoutePort(sGateIP: string): Integer;
begin
  Result := 7200;
end;     }

function TFrmUserSoc.GateRouteIP(sGateIP: string; var nPort: Integer): string;
  function GetRoute(RouteInfo: pTRouteInfo; var nGatePort: Integer): string;
  var
    nGateIndex: Integer;
  begin
    nGateIndex := Random(RouteInfo.nGateCount);
    Result := RouteInfo.sGameGateIP[nGateIndex];
    nGatePort := RouteInfo.nGameGatePort[nGateIndex];
  end;
var
  i: Integer;
  RouteInfo: pTRouteInfo;
begin
  nPort := 0;
  Result := '';
  for i := Low(g_RouteInfo) to High(g_RouteInfo) do begin
    RouteInfo := @g_RouteInfo[i];
    if RouteInfo.sSelGateIP = sGateIP then begin
      Result := GetRoute(RouteInfo, nPort);
      break;
    end;
  end;
end;
 {
function TFrmUserSoc.GetMapIndex(sMap: string): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to MapList.Count - 1 do begin
    if MapList.Strings[i] = sMap then begin
      Result := Integer(MapList.Objects[i]);
      break;
    end;
  end;
end;     }

procedure TFrmUserSoc.SendUserSocket(GateInfo: pTGateInfo; sArrayIndex, sSessionID, sSendMsg: string);
begin
  sSendMsg := MG_CodeHead + sArrayIndex + '/' + sSessionID + '/' + g_CodeHead + sSendMsg + g_CodeEnd + MG_CodeEnd;
  if GateInfo.sSendMsg <> '' then begin
    GateInfo.sSendMsg := GateInfo.sSendMsg + sSendMsg;
  end else begin
    if GateInfo.Socket.SendText(sSendMsg) = -1 then
      GateInfo.sSendMsg := sSendMsg;
  end;
  {Socket.SendText(MG_CodeHead + sArrayIndex + '/' + sSessionID + '/' + g_CodeHead
    + sSendMsg + g_CodeEnd + MG_CodeEnd); }
end;
{
function TFrmUserSoc.CheckDenyChrName(sChrName: string): Boolean;
var
  i: Integer;
begin
  Result := True;
  g_CheckCode.dwThread0 := 1000700;
  for i := 0 to DenyChrNameList.Count - 1 do begin
    g_CheckCode.dwThread0 := 1000701;
    if CompareText(sChrName, DenyChrNameList.Strings[i]) = 0 then begin
      g_CheckCode.dwThread0 := 1000702;
      Result := False;
      break;
    end;
  end;
  g_CheckCode.dwThread0 := 1000703;
end;
      }
end.

