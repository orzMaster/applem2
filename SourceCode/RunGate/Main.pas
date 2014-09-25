unit Main;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Classes, Controls, Forms,
  JSocket, ExtCtrls, StdCtrls, WinSock, Grobal2, IniFiles, Menus, GateShare,
  ComCtrls, Common;

type
  TFrmMain = class(TForm)
    ServerSocket: TServerSocket;
    SendTimer: TTimer;
    ClientSocket: TClientSocket;
    Timer: TTimer;
    DecodeTimer: TTimer;
    MainMenu: TMainMenu;
    MENU_CONTROL: TMenuItem;
    MENU_CONTROL_START: TMenuItem;
    MENU_CONTROL_STOP: TMenuItem;
    MENU_CONTROL_EXIT: TMenuItem;
    StartTimer: TTimer;
    MENU_CONTROL_CLEAELOG: TMenuItem;
    MENU_CONTROL_RECONNECT: TMenuItem;
    MENU_OPTION: TMenuItem;
    MENU_OPTION_GENERAL: TMenuItem;
    MENU_OPTION_IPFILTER: TMenuItem;
    MENU_OPTION_PERFORM: TMenuItem;
    MENU_CONTROL_RELOADCONFIG: TMenuItem;
    H1: TMenuItem;
    I1: TMenuItem;
    MemoLog: TMemo;
    StatusBar: TStatusBar;
    Label1: TLabel;
    CenterSocket: TClientSocket;
    V1: TMenuItem;
    G1: TMenuItem;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    LabelReviceMsgSize: TLabel;
    LabelSendBlockSize: TLabel;
    LabelBufferOfM2Size: TLabel;
    LabelSelfCheck: TLabel;
    LabelPlayMsgSize: TLabel;
    LabelLogonMsgSize: TLabel;
    LabelProcessMsgSize: TLabel;
    LabelDeCodeMsgSize: TLabel;
    GroupBox2: TGroupBox;
    LabelReceTime: TLabel;
    LabelSendTime: TLabel;
    LabelSendLimitTime: TLabel;
    LabelReviceLimitTime: TLabel;
    Label14: TLabel;
    LabelLoopTime: TLabel;
    I2: TMenuItem;
    N1: TMenuItem;
    procedure DecodeTimerTimer(Sender: TObject);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure MENU_CONTROL_EXITClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MENU_CONTROL_STARTClick(Sender: TObject);
    procedure MENU_CONTROL_STOPClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StartTimerTimer(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure MemoLogChange(Sender: TObject);
    procedure SendTimerTimer(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure MENU_CONTROL_CLEAELOGClick(Sender: TObject);
    procedure MENU_CONTROL_RECONNECTClick(Sender: TObject);
    procedure MENU_OPTION_GENERALClick(Sender: TObject);
    procedure MENU_OPTION_IPFILTERClick(Sender: TObject);
    procedure MENU_OPTION_PERFORMClick(Sender: TObject);
    procedure MENU_CONTROL_RELOADCONFIGClick(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure MENU_VIEW_LOGMSGClick(Sender: TObject);
    procedure CenterSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ServerSocketListen(Sender: TObject; Socket: TCustomWinSocket);
    procedure CenterSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CenterSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure CenterSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure G1Click(Sender: TObject);
    procedure I2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    dwShowMainLogTick: LongWord;
    boShowLocked: Boolean;
    TempLogList: TStringList;
    dwCheckClientTick: LongWord;
    dwProcessPacketTick: LongWord;

    boServerReady: Boolean;
    dwLoopCheckTick: LongWord;
    dwLoopTime: LongWord;
    dwProcessServerMsgTime: LongWord;
    dwProcessClientMsgTime: LongWord;
    dwReConnectServerTime: LongWord;
    dwReConnectCenterTime: LongWord;
    dwRefConsolMsgTick: LongWord;
    nBufferOfM2Size: Integer;
    dwRefConsoleMsgTick: LongWord;
    nReviceMsgSize: Integer;
    nDeCodeMsgSize: Integer;
    nSendBlockSize: Integer;
    nProcessMsgSize: Integer;
    nHumLogonMsgSize: Integer;
    nHumPlayMsgSize: Integer;
    ClientSocketBuffer: PChar;
    ClientSocketLen: Integer;
    SendIndex: Word;

    nCCConnCount: Integer;
    nCCHeadOffCount: Integer;
    boOpenCCProtect: Boolean;
    dwOpenCCProtectTick: LongWord;
    procedure SendServerMsg(nIdent: Integer; wSocketIndex: Word; nSocket,
      nUserListIndex: Integer; nLen: Integer; Data: PChar);
    procedure SendUserSocket();
    procedure ShowMainLogMsg();
    procedure LoadConfig();
    procedure StartService();
    procedure StopService();
    procedure RestSessionArray();
    procedure ProcReceiveBuffer(tBuffer: PChar; nMsgLen: Integer);
    procedure ProcessUserPacket(UserData: pTSendUserData);
    procedure ProcessPacket(UserSession: pTSessionInfo);
    procedure ProcessMakeSocketStr(nSocket, nSocketIndex: Integer; Buffer:
      PChar; nMsgLen: Integer);
    //    function FilterSayMsg(var sMsg: string; UserData: pTSendUserData): Boolean;
    //    function CheckSayMsg(UserData: pTSendUserData): Boolean;
    function IsBlockIP(sIPaddr: string): Boolean;
    function IsConnLimited(sIPaddr: string; nSocketHandle: Integer): Boolean;
    procedure AddAttackInfo(sIPaddr: string; Socket: TCustomWinSocket);
    //function AddAttackIP(sIPaddr: string): Boolean;
//    function CheckDefMsg(DefMsg: pTDefaultMessage; SessionInfo: pTSessionInfo):
//      Integer;
    //    procedure CloseAllUser(); dynamic;
    //procedure SendClientMsg(SessionInfo: pTSessionInfo; sMsg: string; MsgColor: Byte = 0);
    //    procedure SendActionFail(Socket: TCustomWinSocket);
        { Private declarations }
    procedure SendKeepAlivePacket();
    procedure OpenCCProtect(boOpen: Boolean);
    procedure SendSpeedClose(nSocketIndex: Integer; UserSession: pTSessionInfo);


  public
    function CloseConnect(sIPaddr: string): Integer;
    function AddBlockIP(sIPaddr: string): Integer;
    function AddTempBlockIP(sIPaddr: string): Integer;

    //function GetConnectCountOfIP(sIPaddr: string): Integer;
    //function GetAttackIPCount(sIPaddr: string): Integer;
    procedure MyMessage(var MsgData: TWmCopyData); message WM_COPYDATA;
    procedure OnProgramException(Sender: TObject; E: Exception);
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses EDcode, HUtil32, GeneralConfig, IPaddrFilter, GateCommon,
  PrefConfig, OnLineHum, SessionInfo;

{$R *.dfm}

procedure TFrmMain.SendServerMsg(nIdent: Integer; wSocketIndex: Word; nSocket,
  nUserListIndex: Integer; nLen: Integer; Data: PChar);
var
  GateMsg: TMsgHeader;
  SendBuffer: PChar;
  nBuffLen: Integer;
  //  nBack: Integer;
begin
  //SendBuffer:=nil;
  GateMsg.dwCode := RUNGATECODE;
  GateMsg.nSocket := nSocket;
  GateMsg.wGSocketIdx := wSocketIndex;
  GateMsg.wIdent := nIdent;
  GateMsg.wUserListIndex := nUserListIndex;
  GateMsg.nLength := nLen;
  nBuffLen := nLen + SizeOf(TMsgHeader);
  GetMem(SendBuffer, nBuffLen);
  Move(GateMsg, SendBuffer^, SizeOf(TMsgHeader));
  if Data <> nil then begin
    Move(Data^, SendBuffer[SizeOf(TMsgHeader)], nLen);
  end; //0045505E
  ReallocMem(ClientSocketBuffer, ClientSocketLen + nBuffLen);
  Move(SendBuffer^, ClientSocketBuffer[ClientSocketLen], nBuffLen);
  Inc(ClientSocketLen, nBuffLen);
  FreeMem(SendBuffer);
end;

procedure TFrmMain.SendSpeedClose(nSocketIndex: Integer; UserSession: pTSessionInfo);
var
  Buffer: PChar;
  DefMsg: TDefaultMessage;
begin
  DefMsg := MakeDefaultMsg(CM_SPEEDCLOSE, 0, 0, 0, 0);
  GetMem(Buffer, SizeOf(TDefaultMessage));
  Move(DefMsg, Buffer^, SizeOf(TDefaultMessage));
  SendServerMsg(GM_DATA, nSocketIndex, UserSession.Socket.SocketHandle, UserSession.nUserListIndex, SizeOf(TDefaultMessage), Buffer);
  FreeMem(Buffer);
end;

procedure TFrmMain.SendUserSocket();
var
  SendBuffer, SaveBuffer: PChar;
  SendLen: Integer;
begin
  if (ClientSocketLen > 0) and (ClientSocketBuffer <> nil) then begin
    SendBuffer := ClientSocketBuffer;
    SendLen := ClientSocketLen;
    if boServerReady then begin
      while SendLen > 0 do begin
        if SendLen > MAXSOCKETBUFFLEN then begin
          if ClientSocket.Socket.SendBuf(SendBuffer^, MAXSOCKETBUFFLEN) <> -1 then begin
            SendBuffer := PChar(Integer(SendBuffer) + MAXSOCKETBUFFLEN);
            Inc(nBufferOfM2Size, MAXSOCKETBUFFLEN);
            Dec(SendLen, MAXSOCKETBUFFLEN);
          end
          else
            break;
        end
        else begin
          if ClientSocket.Socket.SendBuf(SendBuffer^, SendLen) <> -1 then begin
            SendLen := 0;
            Inc(nBufferOfM2Size, SendLen);
          end;
          break;
        end;
      end;
      if SendLen <> ClientSocketLen then begin
        if SendLen > 0 then begin
          GetMem(SaveBuffer, SendLen);
          Move(SendBuffer^, SaveBuffer^, SendLen);
          FreeMem(ClientSocketBuffer);
          ClientSocketBuffer := SaveBuffer;
          ClientSocketLen := SendLen;
        end
        else begin
          FreeMem(ClientSocketBuffer);
          ClientSocketBuffer := nil;
          ClientSocketLen := 0;
        end;
      end;
    end;
  end;
end;

procedure TFrmMain.DecodeTimerTimer(Sender: TObject);
const
  boRun: Boolean = False;
var
  dwLoopProcessTime, dwProcessReviceMsgLimiTick: LongWord;
  UserData: pTSendUserData;
  //  i: Integer;
  //  tUserData: TSendUserData;
  UserSession: pTSessionInfo;
  boCheckTimeLimit: Boolean;
  nIdx: Integer;
  boAddTime: Boolean;
const
  sMsg = '%d/%d/%d/%d/%d/%d/%d';
begin
  if boRun then
    exit;
  boRun := True;
  try
    ShowMainLogMsg();
    boAddTime := False;
    if not boDecodeMsgLock then begin
      dwLoopCheckTick := GetTickCount();
      try
        if (GetTickCount - dwRefConsoleMsgTick) >= 1000 then begin
          dwRefConsoleMsgTick := GetTickCount();
          if not boShowBite then begin
            LabelReviceMsgSize.Caption := 'Receive: ' + IntToStr(nReviceMsgSize div 1024);
            LabelBufferOfM2Size.Caption := 'Server Communication: ' + IntToStr(nBufferOfM2Size div 1024);
            LabelProcessMsgSize.Caption := 'Coding: ' + IntToStr(nProcessMsgSize div 1024);
            LabelLogonMsgSize.Caption := 'Login: ' + IntToStr(nHumLogonMsgSize div 1024);
            LabelPlayMsgSize.Caption := 'Data: ' + IntToStr(nHumPlayMsgSize div 1024);
          end
          else begin
            LabelReviceMsgSize.Caption := 'Receive: ' + IntToStr(nReviceMsgSize);
            LabelBufferOfM2Size.Caption := 'Server Communication: ' + IntToStr(nBufferOfM2Size);
            LabelProcessMsgSize.Caption := 'Coding: ' + IntToStr(nProcessMsgSize);
            LabelLogonMsgSize.Caption := 'Login: ' + IntToStr(nHumLogonMsgSize);
            LabelPlayMsgSize.Caption := 'Data: ' + IntToStr(nHumPlayMsgSize);
          end;
          LabelDeCodeMsgSize.Caption := 'Decoding: ' + IntToStr(nDeCodeMsgSize);
          LabelSendBlockSize.Caption := 'Send: ' + IntToStr(nSendBlockSize);
          LabelSelfCheck.Caption := 'Self Test: ' + IntToStr(dwCheckServerTimeMin) + '/' + IntToStr(dwCheckServerTimeMax);
          if dwCheckServerTimeMax > 0 then
            Dec(dwCheckServerTimeMax);
          if ServerSocket.Socket.ActiveConnections >= 3 then begin
            if nReviceMsgSize = 0 then begin
            end
            else begin
            end;
          end;
          nBufferOfM2Size := 0;
          nReviceMsgSize := 0;
          nDeCodeMsgSize := 0;
          nSendBlockSize := 0;
          nProcessMsgSize := 0;
          nHumLogonMsgSize := 0;
          nHumPlayMsgSize := 0;
        end; //00455664
        try
          dwProcessReviceMsgLimiTick := GetTickCount();
          while (True) do begin
            if ReviceMsgList.Count <= 0 then break;
            UserData := ReviceMsgList.Items[0];
            ReviceMsgList.Delete(0);
            ProcessUserPacket(UserData);
            Dispose(UserData);
            if (GetTickCount - dwProcessReviceMsgLimiTick) > dwProcessReviceMsgTimeLimit then
              break;
          end;
        except
          on E: Exception do begin
            AddMainLogMsg('[Exception] DecodeTimerTImer->ProcessUserPacket', 1);
          end;
        end;
        try
          SendUserSocket();
        except
          on E: Exception do begin
            AddMainLogMsg('[Exception] DecodeTimerTImer->SendUserSocket', 1);
          end;
        end;
        try //004556F6
          dwProcessReviceMsgLimiTick := GetTickCount();
          boCheckTimeLimit := False;
          nIdx := SendIndex;
          while True do begin
            if (nIdx < 0) or (nIdx >= RUNATEMAXSESSION) then break;
            UserSession := @SessionArray[nIdx];
            Inc(nIdx);
            if (UserSession.Socket <> nil) and (UserSession.sSendData <> '') and (GetTickCount > UserSession.dwSuspendedTick) then begin
              ProcessPacket(UserSession);
            end;
            if (GetTickCount - dwProcessReviceMsgLimiTick) > dwProcessSendMsgTimeLimit then begin
              boAddTime := True;
              boCheckTimeLimit := True;
              SendIndex := nIdx;
              break;
            end;
          end;
          if not boCheckTimeLimit then
            SendIndex := 0;
        except
          on E: Exception do begin
            AddMainLogMsg('[Exception] DecodeTimerTImer->ProcessPacket', 1);
          end;
        end;
        try //00455788
          //        dwProcessReviceMsgLimiTick := GetTickCount();
          if (GetTickCount - dwProcessPacketTick) > 300 then begin
            dwProcessPacketTick := GetTickCount();
            if ReviceMsgList.Count > 0 then begin
              if dwProcessReviceMsgTimeLimit < 300 then
                Inc(dwProcessReviceMsgTimeLimit);
            end
            else begin
              if dwProcessReviceMsgTimeLimit > 30 then
                Dec(dwProcessReviceMsgTimeLimit);
            end;
            if boAddTime then begin
              if dwProcessSendMsgTimeLimit < 300 then
                Inc(dwProcessSendMsgTimeLimit);
            end
            else begin
              if dwProcessSendMsgTimeLimit > 30 then
                Dec(dwProcessSendMsgTimeLimit);
            end;
            //00455826
            {for i := 0 to RUNATEMAXSESSION - 1 do begin
              UserSession := @SessionArray[i];
              if (UserSession.Socket <> nil) and (UserSession.sSendData <> '') then begin
                tUserData.nSocketIdx := i;
                tUserData.nSocketHandle := UserSession.nSckHandle;
                tUserData.sMsg := '';
                ProcessPacket(@tUserData);
                if (GetTickCount - dwProcessReviceMsgLimiTick) > 20 then
                  break;
              end;
            end;       }
          end; //00455894
        except
          on E: Exception do begin
            AddMainLogMsg('[Exception] DecodeTimerTImer->ProcessPacket 2', 1);
          end;
        end;
        //每二秒向游戏服务器发送一个检查信号
        if (GetTickCount - dwCheckClientTick) > 2000 then begin
          dwCheckClientTick := GetTickCount();
          if (GetTickCount - dwCheckServerTick) > dwCheckServerTimeOutTime then begin
            //        if (GetTickCount - dwCheckServerTick) > 60 * 1000 then begin
            boCheckServerFail := True;
            ClientSocket.Close;
          end;
          if boGateReady then begin
            SendServerMsg(GM_CHECKCLIENT, 0, 0, 0, 0, nil);
            dwCheckServerTick := GetTickCount;
          end;
          if dwLoopTime > 0 then
            Dec(dwLoopTime);
          if dwProcessServerMsgTime > 1 then
            Dec(dwProcessServerMsgTime);
          if dwProcessClientMsgTime > 1 then
            Dec(dwProcessClientMsgTime);
        end;
        boDecodeMsgLock := False;
      except
        on E: Exception do begin
          AddMainLogMsg('[Exception] DecodeTimer', 1);
          boDecodeMsgLock := False;
        end;
      end;
      dwLoopProcessTime := GetTickCount - dwLoopCheckTick;

      if dwLoopTime < dwLoopProcessTime then begin
        dwLoopTime := dwLoopProcessTime;
      end;
      if (GetTickCount - dwRefConsolMsgTick) > 1000 then begin
        dwRefConsolMsgTick := GetTickCount();
        {LabelProcessMsg.Caption := Format('%d/%d/%d/%d',
          [dwLoopTime,
          dwProcessClientMsgTime,
            dwProcessServerMsgTime,
            dwProcessReviceMsgTimeLimit,
            dwProcessSendMsgTimeLimit]);   }
        LabelLoopTime.Caption := IntToStr(dwLoopTime);
        LabelReviceLimitTime.Caption := 'Receiving and processing limitations: ' + IntToStr(dwProcessReviceMsgTimeLimit);
        LabelSendLimitTime.Caption := 'Transmission processing restrictions: ' + IntToStr(dwProcessSendMsgTimeLimit);
        LabelReceTime.Caption := 'Receive: ' + IntToStr(dwProcessClientMsgTime);
        LabelSendTime.Caption := 'Send: ' + IntToStr(dwProcessServerMsgTime);
      end;
    end;
  finally
    boRun := False;
  end;
end;
{
procedure TFrmMain.SendActionFail(Socket: TCustomWinSocket);
begin
  if (Socket <> nil) and (Socket.Connected) then
    Socket.SendText(g_CodeHead + sSTATUS_FAIL + IntToStr(GetTickCount) +
      g_CodeEnd);
end;   }

procedure TFrmMain.ProcessUserPacket(UserData: pTSendUserData);
  function GetCertification(sMsg: string; var sAccount: string; var sChrName:
    string; var nSessionID: Integer; var nClientVersion: Integer; var boFlag:
    Boolean): Boolean;
  var
    sData: string;
    sCodeStr, sClientVersion: string;
    sIdx: string;
  resourcestring
    sExceptionMsg = '[Exception] GetCertification';
  begin
    Result := False;
    sData := DecodeString(sMsg);
    try
      if (Length(sData) > 2) and (sData[1] = '*') and (sData[2] = '*') then begin
        sData := Copy(sData, 3, Length(sData) - 2);
        sData := GetValidStr3(sData, sAccount, ['/']);
        sData := GetValidStr3(sData, sChrName, ['/']);
        sData := GetValidStr3(sData, sCodeStr, ['/']);
        sData := GetValidStr3(sData, sClientVersion, ['/']);
        sIdx := sData;
        nSessionID := StrToIntDef(sCodeStr, 0);
        if sIdx = '0' then begin
          boFlag := True;
        end
        else begin
          boFlag := False;
        end;
        if (sAccount <> '') and (sChrName <> '') and (nSessionID >= 2) then begin
          nClientVersion := StrToIntDef(sClientVersion, 0);
          Result := True;
        end;
      end;
    except
      AddMainLogMsg(sExceptionMsg, 0);
    end;
  end;
var
  sMsg, sData, sDefMsg, sDataMsg, sDataText, sHumName: string;
  Buffer: PChar;
  nPacketIdx, nDataLen, n14: Integer;
  DefMsg: TDefaultMessage;
  btSpeedControlMode: Integer;
  boEDCode: Boolean;
  sAccount, sChrName: string;
  nSessionID: Integer;
  boFlag: Boolean;
  nClientVersion: Integer;
begin
  try
    n14 := 0;
    //Inc(nProcessMsgSize, Length(UserData.sMsg));
    if (UserData.nSocketIdx >= 0) and (UserData.nSocketIdx < RUNATEMAXSESSION) then begin
      if (UserData.nSocketHandle = SessionArray[UserData.nSocketIdx].nSckHandle) and
         (SessionArray[UserData.nSocketIdx].nPacketErrCount < 10) then begin
        if Length(SessionArray[UserData.nSocketIdx].sSocData) > MSGMAXLENGTH then begin
          SessionArray[UserData.nSocketIdx].sSocData := '';
          SessionArray[UserData.nSocketIdx].nPacketErrCount := 99;
          UserData.sMsg := '';
        end; //00455F7A
        sMsg := SessionArray[UserData.nSocketIdx].sSocData + UserData.sMsg;
        while (True) do begin
          sData := '';
          sMsg := ArrestStringEx(sMsg, g_CodeHead, g_CodeEnd, sData);
          if Length(sData) > 2 then begin
            nPacketIdx := StrToIntDef(sData[1], 99);
            //将数据名第一位的序号取出
            if SessionArray[UserData.nSocketIdx].nPacketIdx = nPacketIdx then begin
              //如果序号重复则增加错误计数
              Inc(SessionArray[UserData.nSocketIdx].nPacketErrCount);
            end
            else begin
              //nOPacketIdx := SessionArray[UserData.nSocketIdx].nPacketIdx;
              SessionArray[UserData.nSocketIdx].nPacketIdx := nPacketIdx;
              sData := Copy(sData, 2, Length(sData) - 1);
              nDataLen := Length(sData);
              if (nDataLen >= DEFBLOCKSIZE) then begin
                if SessionArray[UserData.nSocketIdx].boStartLogon then begin
                  //第一个人物登录数据包
                  Inc(nHumLogonMsgSize, Length(sData));
                  if (GetCertification(sData, sAccount, sChrName, nSessionID, nClientVersion, boFlag)) and
                    (CheckSession(sAccount, sChrName, nSessionID, UserData.nSocketIdx)) then begin

                    SendServerMsg(GM_OPEN, UserData.nSocketIdx,
                      SessionArray[UserData.nSocketIdx].nSckHandle, 0,
                      Length(SessionArray[UserData.nSocketIdx].sRemoteAddr) + 1,
                      PChar(SessionArray[UserData.nSocketIdx].sRemoteAddr));

                    SessionArray[UserData.nSocketIdx].boStartLogon := False;
                    SessionArray[UserData.nSocketIdx].sUserName := sChrName;
                    SessionArray[UserData.nSocketIdx].nSessionID := nSessionID;
                    SessionArray[UserData.nSocketIdx].sAccount := sAccount;
                    sData := g_CodeHead + IntToStr(nPacketIdx) + sData + g_CodeEnd;
                    GetMem(Buffer, Length(sData) + 1);
                    Move(sData[1], Buffer^, Length(sData) + 1);
                    SendServerMsg(GM_DATA,
                      UserData.nSocketIdx,
                      SessionArray[UserData.nSocketIdx].Socket.SocketHandle,
                      SessionArray[UserData.nSocketIdx].nUserListIndex,
                      Length(sData) + 1,
                      Buffer);
                    FreeMem(Buffer);
                  end
                  else begin
                    AddMainLogMsg('[Global Authentication failed]：' + SessionArray[UserData.nSocketIdx].sRemoteAddr, 2);
                    SessionArray[UserData.nSocketIdx].sSocData := '';
                    AddAttackInfo(SessionArray[UserData.nSocketIdx].sRemoteAddr, SessionArray[UserData.nSocketIdx].Socket);
                    //SessionArray[UserData.nSocketIdx].Socket.Close;
                    exit;
                  end;
                end
                else begin
                  //普通数据包

                  if nDataLen = DEFBLOCKSIZE then begin
                    sDefMsg := sData;
                    sDataMsg := '';
                  end
                  else begin
                    sDefMsg := Copy(sData, 1, DEFBLOCKSIZE);
                    sDataMsg := Copy(sData, DEFBLOCKSIZE + 1, nDataLen - DEFBLOCKSIZE);
                    Inc(nHumPlayMsgSize, nDataLen - DEFBLOCKSIZE);
                  end;
                  DefMsg := DecodeMessage(sDefMsg);
                  Inc(nDeCodeMsgSize);

                  if (DefMsg.Ident > RG_MAXMSGINDEX) or (DefMsg.Ident < RG_MINMSGINDEX) then begin
                    AddMainLogMsg('Illegal Code: ' + IntToStr(DefMsg.Ident), 3);
                    SessionArray[UserData.nSocketIdx].sSocData := '';
                    AddAttackInfo(SessionArray[UserData.nSocketIdx].sRemoteAddr, SessionArray[UserData.nSocketIdx].Socket);
                    Exit;
                  end;

                  //外挂控制
                  {if g_Config.boCheckSpeed then begin
                    btSpeedControlMode := CheckDefMsg(@DefMsg,
                      @SessionArray[UserData.nSocketIdx]);
                    if btSpeedControlMode > 0 then begin
                      if btSpeedControlMode = 2 then begin
                        SendActionFail(SessionArray[UserData.nSocketIdx].Socket);
                      end;
                      Continue;
                    end;
                  end;   }

                  if sDataMsg <> '' then begin
                    {if DefMsg.Ident = CM_SAY then begin
                      if boBlockSayMsg or boBlockSay then begin
                        boEDCode := False;
                        sDataText := DecodeString(sDataMsg);
                        if (sDataText <> '') and (sDataText[1] <> '@') then begin
                          sHumName := '';
                          if sDataText[1] = '/' then begin
                            sDataText := GetValidStr3(sDataText, sHumName,
                              [' ']);
                            sHumName := sHumName + ' ';
                          end;
                          //检测发言速度
                          if boBlockSay then begin
                            if CheckSayMsg(UserData) then
                              Continue;
                            if length(sDataText) > nSayMsgMaxLen then begin
                              sDataText := Copy(sDataText, 1, nSayMsgMaxLen);
                              boEDCode := True;
                            end;
                          end;
                          //检测过滤内容
                          if boBlockSayMsg then begin
                            boEDCode := FilterSayMsg(sDataText, UserData) or
                              boEDCode;
                          end;
                          if sDataText = '' then
                            Continue;
                          if boEDCode then
                            sDataMsg := EncodeString(sHumName + sDataText);
                        end;
                      end;
                    end;       }
                    GetMem(Buffer, Length(sDataMsg) + SizeOf(TDefaultMessage) + 1);
                    Move(DefMsg, Buffer^, SizeOf(TDefaultMessage));
                    Move(sDataMsg[1], Buffer[SizeOf(TDefaultMessage)], Length(sDataMsg) + 1);
                    SendServerMsg(GM_DATA,
                      UserData.nSocketIdx,
                      SessionArray[UserData.nSocketIdx].Socket.SocketHandle,
                      SessionArray[UserData.nSocketIdx].nUserListIndex,
                      Length(sDataMsg) + SizeOf(TDefaultMessage) + 1,
                      Buffer);
                    FreeMem(Buffer);
                  end
                  else begin
                    GetMem(Buffer, SizeOf(TDefaultMessage));
                    Move(DefMsg, Buffer^, SizeOf(TDefaultMessage));
                    SendServerMsg(GM_DATA,
                      UserData.nSocketIdx,
                      SessionArray[UserData.nSocketIdx].Socket.SocketHandle,
                      SessionArray[UserData.nSocketIdx].nUserListIndex,
                      SizeOf(TDefaultMessage),
                      Buffer);
                    FreeMem(Buffer);
                  end;
                end;
              end;
            end;
          end
          else begin
            if n14 >= 1 then
              sMsg := ''
            else
              Inc(n14);
          end;
          if TagCount(sMsg, g_CodeEnd) < 1 then
            break;
        end;
        SessionArray[UserData.nSocketIdx].sSocData := sMsg;
      end
      else begin
        AddMainLogMsg('Packet Attack: ' + SessionArray[UserData.nSocketIdx].sRemoteAddr + ' ' +
          IntToStr(SessionArray[UserData.nSocketIdx].nPacketErrCount), 1);
        AddAttackInfo(SessionArray[UserData.nSocketIdx].sRemoteAddr,
          SessionArray[UserData.nSocketIdx].Socket);
        {SessionArray[UserData.nSocketIdx].sSocData := ''; SessionArray[UserData.nSocketIdx].nPacketErrCount
        SessionArray[UserData.nSocketIdx].Socket.Close;  }
        exit;
      end;
    end;
  except
    if (UserData.nSocketIdx >= 0) and (UserData.nSocketIdx < RUNATEMAXSESSION) then begin
      sData := '[' + SessionArray[UserData.nSocketIdx].sRemoteAddr + ']';
    end;
    AddMainLogMsg('[Exception] ProcessUserPacket' + sData, 1);
  end;
end;

procedure TFrmMain.ProcessPacket(UserSession: pTSessionInfo);
var
  sData: string;
  sWriteStr: string;
  //UserSession: pTSessionInfo;
  nSendLen: Integer;
begin
  sWriteStr := UserSession.sSendData;
  Try
    while (sWriteStr <> '') do begin
      nSendLen := Length(sWriteStr);
      if nSendLen > MAXSOCKETBUFFLEN then begin
        sData := Copy(sWriteStr, 1, MAXSOCKETBUFFLEN);
        if UserSession.Socket.SendText(sData) <> -1 then begin
          sWriteStr := Copy(sWriteStr, MAXSOCKETBUFFLEN + 1, nSendLen - MAXSOCKETBUFFLEN);
          Inc(nSendBlockSize, MAXSOCKETBUFFLEN);
          UserSession.dwSuspendedCount := 0;
        end
        else begin
          Inc(UserSession.dwSuspendedCount);
          UserSession.dwSuspendedTick := GetTickCount + LongWord(200 * UserSession.dwSuspendedCount);
          if UserSession.dwSuspendedCount >= 100 then begin
            UserSession.Socket.Close;
            UserSession.Socket := nil;
            UserSession.nSckHandle := -1;
            AddMainLogMsg('Disconnect: transmission failure ' + UserSession.sRemoteAddr, 3);
          end;
          break;
        end;
      end
      else begin
        if UserSession.Socket.SendText(sWriteStr) <> -1 then begin
          Inc(nSendBlockSize, nSendLen);
          sWriteStr := '';
          UserSession.dwSuspendedCount := 0;
        end else begin
          Inc(UserSession.dwSuspendedCount);
          UserSession.dwSuspendedTick := GetTickCount + LongWord(200 * UserSession.dwSuspendedCount);
          if UserSession.dwSuspendedCount >= 100 then begin
            UserSession.Socket.Close;
            UserSession.Socket := nil;
            UserSession.nSckHandle := -1;
            AddMainLogMsg('Disconnect: transmission failure ' + UserSession.sRemoteAddr, 3);
          end;
        end;
        break;
      end;
    end;
  Finally
    UserSession.sSendData := sWriteStr;
  End;
  //if (UserData.nSocketIdx >= 0) and (UserData.nSocketIdx < RUNATEMAXSESSION) then begin
    //UserSession := @SessionArray[UserData.nSocketIdx];
    //if UserSession.nSckHandle = UserData.nSocketHandle then begin
  //Inc(nDeCodeMsgSize, Length(UserData.sMsg));
  //sData := UserSession.sSendData;// + UserData.sMsg;

  //防止发送失败,累加发送数据大于指定值时清空
  //if Length(sData) > MSGMAXLENGTH then sData := '';

 (* while sData <> '' do begin
    if Length(sData) > MAXSOCKETBUFFLEN then begin
      sSendBlock := Copy(sData, 1, MAXSOCKETBUFFLEN);
      sData := Copy(sData, MAXSOCKETBUFFLEN + 1, Length(sData) - MAXSOCKETBUFFLEN);
      nSendLen := MAXSOCKETBUFFLEN;
    end
    else begin
      sSendBlock := sData;
      sData := '';
      nSendLen := Length(sSendBlock);
    end;
    if (UserSession.Socket <> nil) and (UserSession.Socket.Connected) then begin
      {//080716 增加防止缓冲区满了，未发送成功}
      nSendCount := UserSession.Socket.SendText(sSendBlock);
      if nSendCount = -1 then begin
        sData := sSendBlock + sData;
        break;
      end
      else if (nSendCount < nSendLen) and (nSendCount > 0) then begin
        AddMainLogMsg('[Exception] SendError ' + IntToStr(nSendCount) + '/' + IntToStr(nSendLen), 1);
        sData := Copy(sSendBlock, nSendCount + 1, nSendLen - nSendCount) + sData;
        break;
      end
      else
        Inc(nSendBlockSize, Length(sSendBlock));
    end;
    //Inc(UserSession.nCheckSendLength, Length(sSendBlock));
  end; //while sc <> '' do begin
  UserSession.sSendData := sData;  *)
    //end;
  //end;
end;
{
function TFrmMain.FilterSayMsg(var sMsg: string; UserData: pTSendUserData):
  Boolean;
var
  i: Integer;
  sReplaceText: string;
  sFilterText: string;
begin
  Result := False;
  CS_FilterMsg.Enter;
  try
    for i := 0 to AbuseList.Count - 1 do begin
      sFilterText := AbuseList.Strings[i];
      sReplaceText := '';
      if AnsiContainsText(sMsg, sFilterText) then begin
        Result := True;
        case BlockSysMode of
          mAllBlock: sMsg := sDropFilterMsgAlert;
          mSelfBolck: sMsg := AnsiReplaceText(sMsg, sFilterText, sDropFilterMsgAlert);
          mClose: begin
              sMsg := '';
              //SessionArray[UserData.nSocketIdx].Socket.Close;
              //Result:=True;
            end;
          mDisMsg: sMsg := '';
          mDisMsgorSys: begin
              sMsg := '';
              SendClientMsg(@SessionArray[UserData.nSocketIdx],
                AnsiReplaceText(sDropFilterMsgAlert, '%s', sFilterText));
              //MakeClientMsg(EncodeSendClientMsg(0,SM_SYSMESSAGE,14591,0,0,sDropFilterMsgAlert),UserData);
            end;
        end;
      end;
    end;
  finally
    CS_FilterMsg.Leave;
  end;
end;     }

procedure TFrmMain.ClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
  boServerReady := False;
  if ClientSocketBuffer <> nil then begin
    FreeMem(ClientSocketBuffer);
  end;
  ClientSocketBuffer := nil;
  ClientSocketLen := 0;
end;

procedure TFrmMain.MENU_CONTROL_EXITClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if boClose then
    Exit;
  if Application.MessageBox('Are you sure to exit the server?',
    'Confirmation',
    MB_YESNO + MB_ICONQUESTION) = IDYES then begin
    if boServiceStart then begin
      StartTimer.Enabled := True;
      CanClose := False;
    end;
  end
  else
    CanClose := False;
end;

procedure TFrmMain.MENU_CONTROL_STARTClick(Sender: TObject);
begin
  StartService();
end;

procedure TFrmMain.StartService;
begin
  try
    SendGameCenterMsg(SG_STARTNOW, IntToStr(Self.Handle));
    {AddMainLogMsg(g_sVersion, 0);
    AddMainLogMsg(g_sUpDateTime, 0);
    AddMainLogMsg(g_sProgram, 0);
    AddMainLogMsg(g_sWebSite, 0);    }
    //AddMainLogMsg('正在启动服务...', 2);
    boServiceStart := True;
    boGateReady := False;
    boCenterReady := False;
    boCheckServerFail := False;
    boSendHoldTimeOut := False;
    MENU_CONTROL_START.Enabled := False;
    //POPMENU_START.Enabled := False;
    //POPMENU_CONNSTOP.Enabled := True;
    MENU_CONTROL_STOP.Enabled := True;
    SessionCount := 0;
    CurrIPaddrList := TGList.Create;
    BlockIPList := TGList.Create;
    TempBlockIPList := TGList.Create;
    IpList := TGList.Create;
    //AttackIPaddrList := TGList.Create;

    LoadConfig();
    Caption := GateName + ' - ' + TitleName;

    RestSessionArray();
    dwProcessReviceMsgTimeLimit := 50;
    dwProcessSendMsgTimeLimit := 50;

    boServerReady := False;
    dwReConnectServerTime := GetTickCount - 25000;
    dwReConnectCenterTime := GetTickCount - 25000;

    dwRefConsolMsgTick := GetTickCount();

    ServerSocket.Active := False;
    ServerSocket.Address := GateAddr;
    ServerSocket.Port := GatePort;
    ServerSocket.Active := True;

    ClientSocket.Active := False;
    ClientSocket.Address := ServerAddr;
    ClientSocket.Port := ServerPort;
    ClientSocket.Active := True;

    CenterSocket.Active := False;
    CenterSocket.Address := CenterAddr;
    CenterSocket.Port := CenterPort;
    CenterSocket.Active := True;

    SendTimer.Enabled := True;
    //AddMainLogMsg('服务已启动成功...', 2);
    SendGameCenterMsg(SG_STARTOK, IntToStr(Self.Handle));
  except
    on E: Exception do begin
      MENU_CONTROL_START.Enabled := True;
      MENU_CONTROL_STOP.Enabled := False;
      //POPMENU_START.Enabled := True;
      //POPMENU_CONNSTOP.Enabled := False;
      AddMainLogMsg(E.Message, 0);
    end;
  end;
end;

procedure TFrmMain.StopService;
var
  i, nSockIdx: Integer;
  IPaddr: pTSockaddr;
begin
  AddMainLogMsg('Stopping RunGate Server...', 2);

  boServiceStart := False;
  boGateReady := False;
  boCenterReady := False;
  MENU_CONTROL_START.Enabled := True;
  MENU_CONTROL_STOP.Enabled := False;
  //POPMENU_START.Enabled := True;
  //POPMENU_CONNSTOP.Enabled := False;
  for nSockIdx := 0 to RUNATEMAXSESSION - 1 do begin
    if SessionArray[nSockIdx].Socket <> nil then
      SessionArray[nSockIdx].Socket.Close;
  end;
  ServerSocket.Close;
  ClientSocket.Close;
  CenterSocket.Close;

  SaveBlockIPList;

  CurrIPaddrList.Lock;
  try
    for i := 0 to CurrIPaddrList.Count - 1 do begin
      IPaddr := CurrIPaddrList.Items[I];
      Dispose(IPaddr);
    end;
  finally
    CurrIPaddrList.UnLock;
    CurrIPaddrList.Free;
  end;

  BlockIPList.Lock;
  try
    for i := 0 to BlockIPList.Count - 1 do begin
      IPaddr := pTSockaddr(BlockIPList.Items[i]);
      Dispose(IPaddr);
    end;
  finally
    BlockIPList.UnLock;
    BlockIPList.Free;
  end;

  TempBlockIPList.Lock;
  try
    for i := 0 to TempBlockIPList.Count - 1 do begin
      IPaddr := pTSockaddr(TempBlockIPList.Items[i]);
      Dispose(IPaddr);
    end;
  finally
    TempBlockIPList.UnLock;
    TempBlockIPList.Free;
  end;

  IpList.Lock;
  try
    for i := 0 to IpList.Count - 1 do begin
      Dispose(pTBlockaddr(IpList[i]));
    end;
  finally
    IpList.UnLock;
    IpList.free;
  end;

  {AttackIPaddrList.Lock;
  try
    for i := 0 to AttackIPaddrList.Count - 1 do begin
      IPaddr := pTSockaddr(AttackIPaddrList.Items[i]);
      Dispose(IPaddr);
    end;
  finally
    AttackIPaddrList.UnLock;
    AttackIPaddrList.Free;
  end;              }

  AddMainLogMsg('RunGate Server stop complete.', 2);
end;

procedure TFrmMain.MENU_CONTROL_STOPClick(Sender: TObject);
begin
  if Application.MessageBox('Are you sure to stop the service?', 'Confirmation', MB_YESNO + MB_ICONQUESTION) = IDYES then
    StopService();
end;

procedure TFrmMain.LoadConfig;
begin
  //AddMainLogMsg('正在加载配置信息...', 3);
  if Conf <> nil then begin
    TitleName := Conf.ReadString(GateClass, 'Title', TitleName);
    ServerAddr := Conf.ReadString(GateClass, 'ServerAddr', ServerAddr);
    ServerPort := Conf.ReadInteger(GateClass, 'ServerPort', ServerPort);
    GateAddr := Conf.ReadString(GateClass, 'GateAddr', GateAddr);
    GatePort := Conf.ReadInteger(GateClass, 'GatePort', GatePort);
    CenterAddr := Conf.ReadString(GateClass, 'CenterAddr', CenterAddr);
    CenterPort := Conf.ReadInteger(GateClass, 'CenterPort', CenterPort);

    //nShowLogLevel := Conf.ReadInteger(GateClass, 'ShowLogLevel', nShowLogLevel);
    boShowBite := Conf.ReadBool(GateClass, 'ShowBite', boShowBite);

    {if Conf.ReadInteger(GateClass, 'AttackTick', -1) <= 0 then
      Conf.WriteInteger(GateClass, 'AttackTick', dwAttackTick);

    if Conf.ReadInteger(GateClass, 'AttackCount', -1) <= 0 then
      Conf.WriteInteger(GateClass, 'AttackCount', nAttackCount); }

    //dwAttackTick := Conf.ReadInteger(GateClass, 'AttackTick', dwAttackTick);
    //nAttackCount := Conf.ReadInteger(GateClass, 'AttackCount', nAttackCount);
    nMaxConnOfIPaddr := Conf.ReadInteger(GateClass, 'MaxConnOfIPaddr', nMaxConnOfIPaddr);
    dwClientTimeOutTime := Conf.ReadInteger(GateClass, 'KeepConnectTimeOutEx', dwClientTimeOutTime);
    dwSessionTimeOutTime := Conf.ReadInteger(GateClass, 'SessionTimeOutTime', dwSessionTimeOutTime);

    nIPCountLimitTime1 := Conf.ReadInteger(GateClass, 'IPCountTime1', nIPCountLimitTime1);
    nIPCountLimit1 := Conf.ReadInteger(GateClass, 'IPCountLimit1', nIPCountLimit1);
    nIPCountLimitTime2 := Conf.ReadInteger(GateClass, 'IPCountTime2', nIPCountLimitTime2);
    nIPCountLimit2 := Conf.ReadInteger(GateClass, 'IPCountLimit2', nIPCountLimit2);

    BlockMethod := TBlockIPMethod(Conf.ReadInteger(GateClass, 'BlockMethod', Integer(BlockMethod)));

    nMaxClientPacketSize := Conf.ReadInteger(GateClass, 'MaxClientPacketSize', nMaxClientPacketSize);
    nNomClientPacketSize := Conf.ReadInteger(GateClass, 'NomClientPacketSize', nNomClientPacketSize);

    nEditSpeedTick := Conf.ReadInteger(GateClass, 'SpeedTick', nEditSpeedTick);
    nEditSpeedCount := Conf.ReadInteger(GateClass, 'SpeedCount', nEditSpeedCount);

    nMaxClientMsgCount := Conf.ReadInteger(GateClass, 'MaxClientMsgCount', nMaxClientMsgCount);
    bokickOverPacketSize := Conf.ReadBool(GateClass, 'kickOverPacket', bokickOverPacketSize);

    boBlockSay := Conf.ReadBool(GateClass, 'BlockSay', boBlockSay);
    nSayMsgMaxLen := Conf.ReadInteger(GateClass, 'SayMsgMaxLen', nSayMsgMaxLen);
    nSayMsgTime := Conf.ReadInteger(GateClass, 'SayMsgTime', nSayMsgTime);
    nSayMsgCount := Conf.ReadInteger(GateClass, 'SayMsgCount', nSayMsgCount);
    nSayMsgCloseTime := Conf.ReadInteger(GateClass, 'SayMsgCloseTime', nSayMsgCloseTime);

    dwCheckServerTimeOutTime := Conf.ReadInteger(GateClass, 'ServerCheckTimeOut', dwCheckServerTimeOutTime);
    nClientSendBlockSize := Conf.ReadInteger(GateClass, 'ClientSendBlockSize', nClientSendBlockSize);

    g_Config.boCheckSpeed := Conf.ReadBool('Setup', 'CheckSpeed', g_Config.boCheckSpeed);

    g_Config.boHit := Conf.ReadBool('Setup', 'HitSpeed', g_Config.boHit);
    g_Config.boSpell := Conf.ReadBool('Setup', 'SpellSpeed', g_Config.boSpell);
    g_Config.boRun := Conf.ReadBool('Setup', 'RunSpeed', g_Config.boRun);
    g_Config.boWalk := Conf.ReadBool('Setup', 'WalkSpeed', g_Config.boWalk);
    g_Config.boTurn := Conf.ReadBool('Setup', 'TurnSpeed', g_Config.boTurn);

    g_Config.nHitTime := Conf.ReadInteger('Setup', 'HitTime', g_Config.nHitTime);
    g_Config.nSpellTime := Conf.ReadInteger('Setup', 'SpellTime', g_Config.nSpellTime);
    g_Config.nRunTime := Conf.ReadInteger('Setup', 'RunTime', g_Config.nRunTime);
    g_Config.nWalkTime := Conf.ReadInteger('Setup', 'WalkTime', g_Config.nWalkTime);
    g_Config.nTurnTime := Conf.ReadInteger('Setup', 'TurnTime', g_Config.nTurnTime);

    g_Config.nHitCount := Conf.ReadInteger('Setup', 'HitCount', g_Config.nHitCount);
    g_Config.nSpellCount := Conf.ReadInteger('Setup', 'SpellCount', g_Config.nSpellCount);
    g_Config.nRunCount := Conf.ReadInteger('Setup', 'RunCount', g_Config.nRunCount);
    g_Config.nWalkCount := Conf.ReadInteger('Setup', 'WalkCount', g_Config.nWalkCount);
    g_Config.nTurnCount := Conf.ReadInteger('Setup', 'TurnCount', g_Config.nTurnCount);

    g_Config.nIncErrorCount := Conf.ReadInteger('Setup', 'IncErrorCount', g_Config.nIncErrorCount);
    g_Config.nDecErrorCount := Conf.ReadInteger('Setup', 'DecErrorCount', g_Config.nDecErrorCount);

    g_Config.btSpeedControlMode := Conf.ReadInteger('Setup', 'SpeedControlMode', g_Config.btSpeedControlMode);
    g_Config.boSpeedShowMsg := Conf.ReadBool('Setup', 'HintSpeed', g_Config.boSpeedShowMsg);
    g_Config.sSpeedShowMsg := Conf.ReadString('Setup', 'HintSpeedMsg', g_Config.sSpeedShowMsg);
    g_Config.btMsgColor := Conf.ReadInteger('Setup', 'MsgColor', g_Config.btMsgColor);

    boBlockSayMsg := Conf.ReadBool('Setup', 'BlockSayMsg', boBlockSayMsg);
    BlockSysMode := TBlockSysMode(Conf.ReadInteger('Setup', 'BlockSysMode', Integer(BlockSysMode)));
    sDropFilterMsgAlert := Conf.ReadString('Setup', 'DropFilterMsgAlert', sDropFilterMsgAlert);
    boCCProtect := Conf.ReadBool(GateClass, 'CCProtect', boCCProtect);
  end;
  LoadBlockIPList;
  //AddMainLogMsg('配置信息加载完成...', 3);
end;

procedure TFrmMain.ShowMainLogMsg;
var
  i: Integer;
begin
  if (GetTickCount - dwShowMainLogTick) < 200 then
    Exit;
  dwShowMainLogTick := GetTickCount();
  try
    boShowLocked := True;
    try
      CS_MainLog.Enter;
      if MainLogMsgList.Count > 5 then begin
        TempLogList.add(MainLogMsgList.Strings[MainLogMsgList.Count - 1] + ' ['
          +
          IntToStr(MainLogMsgList.Count) + ']');
      end
      else begin
        for i := 0 to MainLogMsgList.Count - 1 do begin
          TempLogList.Add(MainLogMsgList.Strings[i]);
        end;
      end;
      MainLogMsgList.Clear;
    finally
      CS_MainLog.Leave;
    end;
    for i := 0 to TempLogList.Count - 1 do begin
      MemoLog.Lines.Add(TempLogList.Strings[i]);
    end;
    TempLogList.Clear;

  finally
    boShowLocked := False;
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  nX, nY: Integer;
begin
  g_dwGameCenterHandle := StrToIntDef(ParamStr(1), 0);
  nX := StrToIntDef(ParamStr(2), -1);
  nY := StrToIntDef(ParamStr(3), -1);
  g_boTeledata := False;
  if (nX >= 0) or (nY >= 0) then begin
    Left := nX;
    Top := nY;
  end;
  nCCConnCount := 0;
  boOpenCCProtect := False;
  AddMapHandle(gt_RunGate, Handle);
  if g_boTeledata then
    sConfigFileName := TeledataConfigFileName
  else
    sConfigFileName := ConfigFileName;
  Conf := TIniFile.Create(sConfigFileName);
  nShowLogLevel := Conf.ReadInteger(GateClass, 'ShowLogLevel', nShowLogLevel);
  ClientSocketBuffer := nil;
  ClientSocketLen := 0;
  SendIndex := 0;
  Application.OnException := OnProgramException;
  TempLogList := TStringList.Create;
  GlobaSessionList := TGList.Create;
  dwLoopCheckTick := GetTickCount();
  SendGameCenterMsg(SG_FORMHANDLE, IntToStr(Self.Handle));
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  DelMapHandle(gt_RunGate, Handle);
  GlobaSessionList.Free;
  TempLogList.Free;
  Conf.Free;
end;

procedure TFrmMain.G1Click(Sender: TObject);
begin
  FrmOnLineHum.Open();
end;

procedure TFrmMain.StartTimerTimer(Sender: TObject);
begin
  if boStarted then begin
    StartTimer.Enabled := False;
    StopService();
    boClose := True;
    Close;
  end
  else begin
    boStarted := True;
    StartTimer.Enabled := False;
    StartService();
  end;
end;

procedure TFrmMain.TimerTimer(Sender: TObject);
begin
  if ServerSocket.Active then begin
    StatusBar.Panels[0].Text := IntToStr(ServerSocket.Port);
    //POPMENU_PORT.Caption := IntToStr(ServerSocket.Port);
    if boSendHoldTimeOut then begin
      //LabelUserInfo.Caption := Format(sMsg, [ServerSocket.Socket.ActiveConnections, ServerSocket.Socket.ActiveConnections, ServerSocket.Port]);
      StatusBar.Panels[2].Text := IntToStr(S_SessionCount) + '/' +
        IntToStr(SessionCount) + '/#' +
        IntToStr(ServerSocket.Socket.ActiveConnections);
    end
    else begin
      //LabelUserInfo.Caption := Format(sMsg, [ServerSocket.Socket.ActiveConnections, 0, ServerSocket.Port]);
      StatusBar.Panels[2].Text := IntToStr(S_SessionCount) + '/' +
        IntToStr(SessionCount) + '/' +
        IntToStr(ServerSocket.Socket.ActiveConnections);

    end;
  end
  else begin
    //LabelUserInfo.Caption := Format(sMsg, [0, 0, 0]);
    StatusBar.Panels[0].Text := '????';
    StatusBar.Panels[2].Text := '????';
    //POPMENU_CONNCOUNT.Caption := '????';
  end;
end;

procedure TFrmMain.RestSessionArray;
var
  i: Integer;
  tSession: pTSessionInfo;
begin
  for i := 0 to RUNATEMAXSESSION - 1 do begin
    tSession := @SessionArray[i];
    tSession.Socket := nil;
    tSession.sSocData := '';
    tSession.sSendData := '';
    tSession.nUserListIndex := 0;
    tSession.nPacketIdx := -1;
    tSession.nPacketErrCount := 0;
    tSession.boStartLogon := True;
    tSession.boSendLock := False;
    tSession.boOverNomSize := False;
    tSession.nOverNomSizeCount := 0;
    tSession.dwSendLatestTime := GetTickCount();
    //tSession.boSendAvailable := True;
    //tSession.boSendCheck := False;
    //tSession.nCheckSendLength := 0;
    tSession.nReceiveLength := 0;
    tSession.dwSendClientCheckTick := GetTickCount;
    tSession.dwReceiveTick := GetTickCount();
    tSession.dwSpeedTick := 0;
    tSession.boLuck := False;
    tSession.nSpeedTimeCount := 0;
    tSession.nSckHandle := -1;
    tSession.dwSayMsgTick := GetTickCount();
    tSession.dwSayMsgCount := 0;
    tSession.dwSayMsgCloseTime := GetTickCount();
    tSession.sUserName := '';
    tSession.nSessionID := 0;
    tSession.sAccount := '';

    tSession.GameSpeed.dwHitTimeTick := GetTickCount();
    tSession.GameSpeed.dwSpellTimeTick := GetTickCount();
    tSession.GameSpeed.dwRunTimeTick := GetTickCount();
    tSession.GameSpeed.dwWalkTimeTick := GetTickCount();
    tSession.GameSpeed.dwTurnTimeTick := GetTickCount();
    tSession.GameSpeed.nHitCount := 0;
    tSession.GameSpeed.nSpellCount := 0;
    tSession.GameSpeed.nRunCount := 0;
    tSession.GameSpeed.nWalkCount := 0;
    tSession.GameSpeed.nTurnCount := 0;
  end;
end;

procedure TFrmMain.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  nSockIdx: Integer;
  sRemoteAddress: string;
  UserSession: pTSessionInfo;
begin
  Socket.nIndex := -1;
  Inc(nCCConnCount);
  if N1.Checked then begin
    Socket.Close;
    Exit;
  end;
  sRemoteAddress := Socket.RemoteAddress;
  if boGateReady and boCenterReady then begin

    if IsBlockIP(sRemoteAddress) then begin
      Inc(nCCHeadOffCount);
      AddMainLogMsg('Filter connection: ' + sRemoteAddress, 3);
      Socket.Close;
      Exit;
    end;

    if IsConnLimited(sRemoteAddress, Socket.SocketHandle) then begin
      case BlockMethod of
        mDisconnect: begin
            if Socket <> nil then
              Socket.Close;
          end;
        mBlock: begin
            AddTempBlockIP(sRemoteAddress);
            Inc(nCCHeadOffCount, CloseConnect(sRemoteAddress));
          end;
        mBlockList: begin
            AddBlockIP(sRemoteAddress);
            CloseConnect(sRemoteAddress);
          end;
      end;
      AddMainLogMsg('Port attack: ' + sRemoteAddress, 3);
      Exit;
    end;

    try
      for nSockIdx := 0 to RUNATEMAXSESSION - 1 do begin
        UserSession := @SessionArray[nSockIdx];
        if UserSession.Socket = nil then begin
          UserSession.Socket := Socket;
          UserSession.sSocData := '';
          UserSession.sSendData := '';
          UserSession.nUserListIndex := 0;
          UserSession.nPacketIdx := -1;
          UserSession.nPacketErrCount := 0;
          UserSession.boStartLogon := True;
          UserSession.boSendLock := False;
          UserSession.dwSendLatestTime := GetTickCount();
          //UserSession.boSendAvailable := True;
          //UserSession.boSendCheck := False;
          //UserSession.nCheckSendLength := 0;
          UserSession.nReceiveLength := 0;
          UserSession.dwReceiveTick := GetTickCount();
          UserSession.dwSpeedTick := 0;
          UserSession.boLuck := False;
          UserSession.nSpeedTimeCount := 0;
          UserSession.dwSendClientCheckTick := GetTickCount;
          UserSession.nSckHandle := Socket.SocketHandle;
          UserSession.sRemoteAddr := sRemoteAddress;
          UserSession.boOverNomSize := False;
          UserSession.nOverNomSizeCount := 0;
          UserSession.dwSayMsgTick := GetTickCount();
          UserSession.dwSayMsgCount := 0;
          UserSession.dwSayMsgCloseTime := GetTickCount();
          UserSession.nReceiveLength := 0;
          UserSession.dwReceiveLengthTick := GetTickCount();
          UserSession.sUserName := '';
          UserSession.nSessionID := 0;
          UserSession.sAccount := '';
          UserSession.dwSuspendedTick := 0;
          UserSession.dwSuspendedCount := 0;

          UserSession.GameSpeed.dwHitTimeTick := GetTickCount();
          UserSession.GameSpeed.dwSpellTimeTick := GetTickCount();
          UserSession.GameSpeed.dwRunTimeTick := GetTickCount();
          UserSession.GameSpeed.dwWalkTimeTick := GetTickCount();
          UserSession.GameSpeed.dwTurnTimeTick := GetTickCount();
          UserSession.GameSpeed.nHitCount := 0;
          UserSession.GameSpeed.nSpellCount := 0;
          UserSession.GameSpeed.nRunCount := 0;
          UserSession.GameSpeed.nWalkCount := 0;
          UserSession.GameSpeed.nTurnCount := 0;
          Socket.nIndex := nSockIdx;
          Inc(SessionCount);
          break;
        end;
      end;
    finally

    end;
    if Socket.nIndex > -1 then begin
      {SendServerMsg(GM_OPEN, nSockIdx, Socket.SocketHandle, 0,
        Length(Socket.RemoteAddress) + 1, PChar(Socket.RemoteAddress));}
      //Socket.nIndex := nSockIdx;
      AddMainLogMsg('Begin Connect: ' + sRemoteAddress, 5);
    end
    else begin
      Socket.nIndex := -1;
      Socket.Close;
      AddMainLogMsg('Connect at full strength: ' + sRemoteAddress, 3);
    end;
  end
  else begin
    Socket.nIndex := -1;
    Socket.Close;
    AddMainLogMsg('Did not connect: ' + sRemoteAddress, 3);
  end;
end;

procedure TFrmMain.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  nSockIndex: Integer;
  sRemoteAddr: string;
  UserSession: pTSessionInfo;
  IPaddr: pTSockaddr;
  nIPaddr: Integer;
  i: Integer;
  //  IPList: TList;
begin
  sRemoteAddr := Socket.RemoteAddress;
  nSockIndex := Socket.nIndex;
  nIPaddr := inet_addr(PChar(sRemoteAddr));
  CurrIPaddrList.Lock;
  try
    for I := 0 to CurrIPaddrList.Count - 1 do begin
      IPaddr := CurrIPaddrList.Items[I];
      if IPaddr.nIPaddr = nIPaddr then begin
        Dec(IPaddr.nCount);
        if IPaddr.nCount <= 0 then begin
          Dispose(IPaddr);
          CurrIPaddrList.Delete(I);
        end;
        Break;
      end;
    end;
  finally
    CurrIPaddrList.UnLock;
  end;
  if (nSockIndex >= 0) and (nSockIndex < RUNATEMAXSESSION) then begin
    UserSession := @SessionArray[nSockIndex];
    if not UserSession.boStartLogon then begin
      DelSession(UserSession.sAccount, UserSession.nSessionID);
    end;
    UserSession.Socket := nil;
    UserSession.nSckHandle := -1;
    UserSession.sSocData := '';
    UserSession.sSendData := '';
    Socket.nIndex := -1;
    Dec(SessionCount);
    if boGateReady then begin
      SendServerMsg(GM_CLOSE, 0, Socket.SocketHandle, 0, 0, nil);
      AddMainLogMsg('Disconnect: ' + Socket.RemoteAddress, 5);
    end;
  end;
end;

procedure TFrmMain.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  //  AddMainLogMsg('连接错误: ' + Socket.RemoteAddress,2);
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmMain.ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  dwProcessMsgTick, dwProcessMsgTime: LongWord;
  nReviceLen: Integer;
  sReviceMsg: string;
  sRemoteAddress: string;
  nSocketIndex: Integer;
  nPos: Integer;
  UserData: pTSendUserData;
  nMsgCount: Integer;
  UserSession: pTSessionInfo;
  nSpeedTick: Integer;
  boLuck: Boolean;
  //  i: integer;
begin
  try
    dwProcessMsgTick := GetTickCount();
    //nReviceLen:=Socket.ReceiveLength;
    sRemoteAddress := Socket.RemoteAddress;
    nSocketIndex := Socket.nIndex;
    sReviceMsg := Socket.ReceiveText;
    nReviceLen := Length(sReviceMsg);
    if (nSocketIndex >= 0) and (nSocketIndex < RUNATEMAXSESSION) and (sReviceMsg <> '') and boServerReady then begin
      if nReviceLen > nNomClientPacketSize then begin
        nMsgCount := TagCount(sReviceMsg, g_CodeEnd);
        if (nMsgCount > nMaxClientMsgCount){ or (nReviceLen > nMaxClientPacketSize)} then begin
          if bokickOverPacketSize then begin
            AddMainLogMsg('Kicks connection: IP(' + sRemoteAddress + '),The amount of information(' + IntToStr(nMsgCount) + ')', 1);
            AddAttackInfo(sRemoteAddress, Socket);
          end;
         { if bokickOverPacketSize then begin
            AddMainLogMsg('Kicked connection: IP(' + sRemoteAddress + '), Number of messages(' + IntToStr(nMsgCount) + '), Packet length(' +
              IntToStr(nReviceLen) + ')', 1);
            AddAttackInfo(sRemoteAddress, Socket);
          end;}
          Exit;
        end;
      end;
      Inc(nReviceMsgSize, nReviceLen);
      //if CheckBoxShowData.Checked then AddMainLogMsg(sReviceMsg, 0);
      UserSession := @SessionArray[nSocketIndex];
      if UserSession.Socket = Socket then begin
        UserSession.nReceiveLength := nReviceLen;
        nPos := Pos(g_ClientCheck, sReviceMsg);
        boLuck := UserSession.boLuck;
        sReviceMsg := Copy(sReviceMsg, 1, nPos - 1) + Copy(sReviceMsg, nPos + 1, Length(sReviceMsg));
        if nPos > 0 then begin
          //UserSession.boSendAvailable := True;
          //UserSession.boSendCheck := False;
          //UserSession.nCheckSendLength := 0;
          nSpeedTick := GetTickCount - UserSession.dwReceiveTick;
          //AddMainLogMsg(IntToStr(GetTickCount - UserSession.dwReceiveTick), 0);
          UserSession.dwReceiveTick := GetTickCount();
          UserSession.dwSpeedTick := nSpeedTick;
          UserSession.sSendData := UserSession.sSendData + g_ClientCheck;
          if nSpeedTick < nEditSpeedTick then begin //变速
            Inc(UserSession.nSpeedTimeCount);
            if UserSession.nSpeedTimeCount >= nEditSpeedCount then begin
              (*UserSession.boLuck := True;
              sReviceMsg := '';
              if ReviceMsgList.Count > 0 then begin
                for i := 0 to ReviceMsgList.Count - 1 do
                  Dispose(pTSendUserData(ReviceMsgList[i]));
                ReviceMsgList.Clear;
              end;
              if not boLuck then begin
                {New(UserData);
                UserData.nSocketIdx := nSocketIndex;
                UserData.nSocketHandle := UserSession.nSckHandle;
                UserData.sMsg := g_CodeHead + sSTATUS_SPEED + g_CodeEnd;
                SendMsgList.Add(UserData);   }
                AddMainLogMsg('Variable speed operation: IP(' + sRemoteAddress + '), Delay(' + IntToStr(nSpeedTick) + ')', 1);
                SendClientMsg(UserSession, 'Please take care of the game environment, do not use illegal acceleration software!');
                UserSession.Socket.Close;
                exit;
              end;
              boLuck := True; *)
              {AddMainLogMsg('Variable Speed Operation: IP(' + sRemoteAddress + '), Delay(' + IntToStr(nSpeedTick) + ')', 1);
              SendClientMsg(UserSession, 'Please take care of the game environment, do not use illegal acceleration software!');
              UserSession.Socket.Close;   }
              SendSpeedClose(nSocketIndex, UserSession);
            end;
            boLuck := False;
          end
          else begin
            (*if boLuck then begin
              {New(UserData);
              UserData.nSocketIdx := nSocketIndex;
              UserData.nSocketHandle := UserSession.nSckHandle;
              UserData.sMsg := g_CodeHead + sSTATUS_TIME + g_CodeEnd;
              SendMsgList.Add(UserData); }
              UserSession.sSendData := UserSession.sSendData + g_CodeHead + sSTATUS_TIME + g_CodeEnd;
            end;  *)
            UserSession.boLuck := False;
            UserSession.nSpeedTimeCount := 0;
            boLuck := False;

          end;
        end;
        if (sReviceMsg <> '') and boGateReady and (not boCheckServerFail) and (not boLuck) then begin
          New(UserData);
          UserData.nSocketIdx := nSocketIndex;
          UserData.nSocketHandle := Socket.SocketHandle;
          UserData.sMsg := sReviceMsg;
          ReviceMsgList.Add(UserData);
        end;
      end;
    end;
    dwProcessMsgTime := GetTickCount - dwProcessMsgTick;
    if dwProcessMsgTime > dwProcessClientMsgTime then
      dwProcessClientMsgTime := dwProcessMsgTime;
  except
    AddMainLogMsg('[Exception] ClientRead', 1);
  end;
end;

procedure TFrmMain.ServerSocketListen(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  AddMainLogMsg('Port Binding(' + Socket.LocalAddress + ':' + IntToStr(Socket.LocalPort) + ')...', 0);
end;

procedure TFrmMain.MemoLogChange(Sender: TObject);
begin
  if MemoLog.Lines.Count > nMaxMemoListCount then
    MemoLog.Clear;
end;

procedure TFrmMain.SendTimerTimer(Sender: TObject);
var
  i: Integer;
  UserSession: pTSessionInfo;
  //  UserData: pTSendUserData;
const
  sMsg = '%d/%d';
begin
  if boCCProtect or boOpenCCProtect then begin
    if boOpenCCProtect then begin
      if ((nCCConnCount < 30) and (GetTickCount - dwOpenCCProtectTick > (30000))) or (not boCCProtect) then begin
        boOpenCCProtect := False;
        OpenCCProtect(boOpenCCProtect);
      end;
    end else begin
      if nCCConnCount >= 200 then begin
        boOpenCCProtect := True;
        OpenCCProtect(boOpenCCProtect);
        dwOpenCCProtectTick := GetTickCount;
      end;
    end;
  end;
  nCCConnCount := 0;
  if (GetTickCount - dwSendHoldTick) > 3000 then begin
    boSendHoldTimeOut := False;
  end;
  if boGateReady and not boCheckServerFail then begin
    for i := 0 to RUNATEMAXSESSION - 1 do begin
      UserSession := @SessionArray[i];
      if UserSession.Socket <> nil then begin
        if UserSession.boStartLogon and ((GetTickCount - UserSession.dwSendClientCheckTick) > dwClientTimeOutTime) then begin
          {UserSession.Socket.Close;
          UserSession.Socket := nil;
          UserSession.nSckHandle := -1;  }
          AddMainLogMsg('Air connection:  ' + UserSession.sRemoteAddr, 3);
          AddAttackInfo(UserSession.sRemoteAddr, UserSession.Socket);
        end
        else if (GetTickCount - UserSession.dwReceiveTick) > dwSessionTimeOutTime then begin
          UserSession.Socket.Close;
          UserSession.Socket := nil;
          UserSession.nSckHandle := -1;
          AddMainLogMsg('Disconnect: No Transfer Timeout ' + UserSession.sRemoteAddr, 3);
        end;
        {else if UserSession.Socket.Connected and ((GetTickCount -
          UserSession.dwSendClientCheckTick) > dwSendClientCheckTime) then begin
          UserSession.dwSendClientCheckTick := GetTickCount;
          New(UserData);
          UserData.nSocketIdx := i;
          UserData.nSocketHandle := UserSession.nSckHandle;
          UserData.sMsg := g_ClientCheck;
          SendMsgList.Add(UserData);
        end;   }

      end;
    end;
  end;

  if not boCenterReady then begin
    if ((GetTickCount - dwReConnectCenterTime) > 3000 {30 * 1000}) and
      boServiceStart then begin
      dwReConnectCenterTime := GetTickCount();
      CenterSocket.Active := False;
      CenterSocket.Address := CenterAddr;
      CenterSocket.Port := CenterPort;
      CenterSocket.Active := True;
    end;
  end
  else
    SendKeepAlivePacket;
  if not boGateReady then begin
    StatusBar.Panels[1].Text := 'Not connected';
    StatusBar.Panels[3].Text := '????';
    //POPMENU_CHECKTICK.Caption := '????';
    if ((GetTickCount - dwReConnectServerTime) > 2000 {30 * 1000}) and
      boServiceStart then begin
      dwReConnectServerTime := GetTickCount();
      ClientSocket.Active := False;
      ClientSocket.Address := ServerAddr;
      ClientSocket.Port := ServerPort;
      ClientSocket.Active := True;
    end;
  end
  else begin //00457302
    if boCheckServerFail then begin
      Inc(nCheckServerFail);
      //LabelMsg.Caption := Format(sMsg, [nCheckServerFail, 1]);
      StatusBar.Panels[1].Text := 'Timeout';
    end
    else begin //00457320
      //LabelMsg.Caption := Format(sMsg, [nCheckServerFail, 0]);
      StatusBar.Panels[1].Text := 'Connected';
    end;
    //dwCheckServerTimeMin := GetTickCount - dwCheckServerTick;
    //if dwCheckServerTimeMin > dwCheckServerTimeMax then dwCheckServerTimeMax := dwCheckServerTimeMin;
    //LabelCheckServerTime.Caption := Format(sMsg, [dwCheckServerTimeMin, dwCheckServerTimeMax]);
    StatusBar.Panels[3].Text := IntToStr(dwCheckServerTimeMin) + '/' + IntToStr(dwCheckServerTimeMax);
  end;
end;

procedure TFrmMain.ClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if not boGateReady then
    AddMainLogMsg('Connected to server(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ').', 0);
  boGateReady := True;
  dwCheckServerTick := GetTickCount();
  RestSessionArray();
  boServerReady := True;
  dwCheckServerTimeMax := 0;
  dwCheckServerTimeMax := 0;
  if ClientSocketBuffer <> nil then begin
    FreeMem(ClientSocketBuffer);
  end;
  ClientSocketBuffer := nil;
  ClientSocketLen := 0;
end;

procedure TFrmMain.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  i: Integer;
  UserSession: pTSessionInfo;
begin
  if boGateReady then
    AddMainLogMsg('Disconnected(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')...', 0);
  for i := 0 to RUNATEMAXSESSION - 1 do begin
    UserSession := @SessionArray[i];
    if UserSession.Socket <> nil then begin
      UserSession.Socket.Close;
      UserSession.Socket := nil;
      UserSession.nSckHandle := -1;
    end;
  end;
  RestSessionArray();
  if SocketBuffer <> nil then begin
    FreeMem(SocketBuffer);
  end;
  SocketBuffer := nil;

  if ClientSocketBuffer <> nil then begin
    FreeMem(ClientSocketBuffer);
  end;
  ClientSocketBuffer := nil;
  ClientSocketLen := 0;

  for i := 0 to List_45AA58.Count - 1 do begin

  end;
  List_45AA58.Clear;
  boGateReady := False;
  boServerReady := False;

end;

procedure TFrmMain.ClientSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  dwTime10, dwTick14: LongWord;
  nMsgLen: Integer;
  tBuffer: PChar;
begin
  try
    dwTick14 := GetTickCount();
    nMsgLen := Socket.ReceiveLength;
    GetMem(tBuffer, nMsgLen);
    nMsgLen := Socket.ReceiveBuf(tBuffer^, nMsgLen);
    ProcReceiveBuffer(tBuffer, nMsgLen);
    Inc(nBufferOfM2Size, nMsgLen);
    dwTime10 := GetTickCount - dwTick14;
    if dwProcessServerMsgTime < dwTime10 then begin
      dwProcessServerMsgTime := dwTime10;
    end;
  except
    on E: Exception do begin
      AddMainLogMsg('[Exception] ClientSocketRead', 1);
    end;
  end;
end;

procedure TFrmMain.ProcReceiveBuffer(tBuffer: PChar; nMsgLen: Integer);
var
  nLen: Integer;
  Buff: PChar;
  pMsg: pTMsgHeader;
  MsgBuff: PChar;
  TempBuff: PChar;
begin
  try
    ReallocMem(SocketBuffer, nBuffLen + nMsgLen);
    Move(tBuffer^, SocketBuffer[nBuffLen], nMsgLen);
    FreeMem(tBuffer);
    nLen := nBuffLen + nMsgLen;
    nBuffLen := nLen;
    Buff := SocketBuffer;
    if nLen >= SizeOf(TMsgHeader) then begin
      while (True) do begin
        pMsg := pTMsgHeader(Buff);
        if pMsg.dwCode = RUNGATECODE then begin
          if (abs(pMsg.nLength) + SizeOf(TMsgHeader)) > nLen then
            break; // -> 0045525C
          MsgBuff := Ptr(LongInt(Buff) + SizeOf(TMsgHeader));
          case pMsg.wIdent of
            GM_CHECKSERVER: begin
                boCheckServerFail := False;
                dwCheckServerTimeMin := GetTickCount - dwCheckServerTick;
                if dwCheckServerTimeMin > dwCheckServerTimeMax then
                  dwCheckServerTimeMax := dwCheckServerTimeMin;
                //dwCheckServerTick := GetTickCount();
              end;
            GM_SERVERUSERINDEX: begin
                if (pMsg.wGSocketIdx < RUNATEMAXSESSION) and (pMsg.nSocket =
                  SessionArray[pMsg.wGSocketIdx].nSckHandle) then begin
                  SessionArray[pMsg.wGSocketIdx].nUserListIndex := pMsg.wUserListIndex;
                end;
              end;
            GM_RECEIVE_OK: begin
                {dwCheckServerTimeMin := GetTickCount - dwCheckRecviceTick;
                if dwCheckServerTimeMin > dwCheckServerTimeMax then dwCheckServerTimeMax := dwCheckServerTimeMin;
                dwCheckRecviceTick := GetTickCount(); }
                SendServerMsg(GM_RECEIVE_OK, 0, 0, 0, 0, nil);
              end;
            GM_DATA: begin
                ProcessMakeSocketStr(pMsg.nSocket, pMsg.wGSocketIdx, MsgBuff, pMsg.nLength);
              end;
            GM_TEST: begin

              end;
          end;
          Buff := @Buff[SizeOf(TMsgHeader) + abs(pMsg.nLength)];
          //Buff:=Ptr(LongInt(Buff) + (abs(pMsg.nLength) + SizeOf(TMsgHeader)));
          nLen := nLen - (abs(pMsg.nLength) + SizeOf(TMsgHeader));
        end
        else begin
          Inc(Buff);
          Dec(nLen);
        end;
        if nLen < SizeOf(TMsgHeader) then
          break;
      end;
      if nLen > 0 then begin
        if nLen = nBuffLen then
          exit;
        GetMem(TempBuff, nLen);
        Move(Buff^, TempBuff^, nLen);
        FreeMem(SocketBuffer);
        SocketBuffer := TempBuff;
        nBuffLen := nLen;
      end
      else begin
        if SocketBuffer <> nil then
          FreeMem(SocketBuffer);
        SocketBuffer := nil;
        nBuffLen := 0;
      end;
    end;

  except
    on E: Exception do begin
      AddMainLogMsg('[Exception] ProcReceiveBuffer', 1);
    end;
  end;
end;

procedure TFrmMain.ProcessMakeSocketStr(nSocket, nSocketIndex: Integer; Buffer: PChar; nMsgLen: Integer);
var
  sSendMsg: string;
  pDefMsg: pTDefaultMessage;
  //  UserData: pTSendUserData;
  UserSession: pTSessionInfo;
  //  UserSession: pTSessionInfo;
begin
  try
    sSendMsg := '';
    //    pDefMsg := nil;
    if nMsgLen < 0 then begin
      sSendMsg := g_CodeHead + string(Buffer) + g_CodeEnd;
      //Inc(nProcessMsgSize);
    end
    else begin
      if (nMsgLen >= SizeOf(TDefaultMessage)) then begin
        pDefMsg := pTDefaultMessage(Buffer);
        if nMsgLen > SizeOf(TDefaultMessage) then begin
          sSendMsg := g_CodeHead + EncodeMessage(pDefMsg^) + string(PChar(@Buffer[SizeOf(TDefaultMessage)])) + g_CodeEnd;
        end
        else begin
          sSendMsg := g_CodeHead + EncodeMessage(pDefMsg^) + g_CodeEnd;
        end;
        Inc(nProcessMsgSize);
      end;
    end;
    if (nSocketIndex >= 0) and (nSocketIndex < RUNATEMAXSESSION) and (sSendMsg <> '') then begin
      {New(UserData);
      UserData.nSocketIdx := nSocketIndex;
      UserData.nSocketHandle := nSocket;
      UserData.sMsg := sSendMsg;
      SendMsgList.Add(UserData); }
      UserSession := @SessionArray[nSocketIndex];
      if UserSession.nSckHandle = nSocket then begin
        UserSession.sSendData := UserSession.sSendData + sSendMsg;
      end;
    end;
  except
    on E: Exception do begin
      AddMainLogMsg('[Exception] ProcessMakeSocketStr', 1);
    end;
  end;
end;

procedure TFrmMain.MENU_CONTROL_CLEAELOGClick(Sender: TObject);
begin
  if Application.MessageBox('Are you sure you want to clear log information?',
    'Confirmation',
    MB_OKCANCEL + MB_ICONQUESTION
    ) <> IDOK then
    Exit;
  MemoLog.Clear;
end;

procedure TFrmMain.MENU_CONTROL_RECONNECTClick(Sender: TObject);
begin
  dwReConnectServerTime := 0;
end;

procedure TFrmMain.MENU_OPTION_GENERALClick(Sender: TObject);
begin
  frmGeneralConfig.Top := Self.Top + 20;
  frmGeneralConfig.Left := Self.Left;
  with frmGeneralConfig do begin
    EditGateIPaddr.Text := GateAddr;
    EditGatePort.Text := IntToStr(GatePort);
    EditServerIPaddr.Text := ServerAddr;
    EditServerPort.Text := IntToStr(ServerPort);
    EditCenterIPaddr.Text := CenterAddr;
    EditCenterPort.Text := IntToStr(CenterPort);
    EditTitle.Text := TitleName;
    TrackBarLogLevel.Position := nShowLogLevel;
    ComboBoxShowBite.ItemIndex := Integer(boShowBite);
  end;
  frmGeneralConfig.ShowModal;
end;

function TFrmMain.IsBlockIP(sIPaddr: string): Boolean;
var
  i: Integer;
  IPaddr: pTSockaddr;
  nIPaddr: Integer;
  Blockaddr: pTBlockaddr;
begin
  Result := False;
  nIPaddr := inet_addr(PChar(sIPaddr));
  IpList.Lock;
  try
    for i := 0 to IpList.Count - 1 do begin
      Blockaddr := IpList[i];
      if (LongWord(nIPaddr) >= Blockaddr.nBeginAddr) and (LongWord(nIPaddr) <= Blockaddr.nEndAddr) then begin
        Result := True;
        break;
      end;
    end;
  finally
    IpList.UnLock;
  end;

  if not Result then begin
    TempBlockIPList.Lock;
    try
      for i := 0 to TempBlockIPList.Count - 1 do begin
        IPaddr := pTSockaddr(TempBlockIPList.Items[i]);
        if IPaddr.nIPaddr = nIPaddr then begin
          Result := True;
          break;
        end;
      end;
    finally
      TempBlockIPList.UnLock;
    end;
    //-------------------------------
    if not Result then begin
      BlockIPList.Lock;
      try
        for i := 0 to BlockIPList.Count - 1 do begin
          IPaddr := pTSockaddr(BlockIPList.Items[i]);
          if IPaddr.nIPaddr = nIPaddr then begin
            Result := True;
            break;
          end;
        end;
      finally
        BlockIPList.UnLock;
      end;
    end;
  end;
end;

procedure TFrmMain.AddAttackInfo(sIPaddr: string; Socket: TCustomWinSocket);
begin
  case BlockMethod of
    mDisconnect: begin
        if Socket <> nil then
          Socket.Close;
      end;
    mBlock: begin
        AddTempBlockIP(sIPaddr);
        CloseConnect(sIPaddr);
      end;
    mBlockList: begin
        AddBlockIP(sIPaddr);
        CloseConnect(sIPaddr);
      end;
  end;
end;

function TFrmMain.AddBlockIP(sIPaddr: string): Integer;
var
  i: Integer;
  IPaddr: pTSockaddr;
  nIPaddr: Integer;
begin
  BlockIPList.Lock;
  try
    Result := 0;
    nIPaddr := inet_addr(PChar(sIPaddr));
    for i := 0 to BlockIPList.Count - 1 do begin
      IPaddr := pTSockaddr(BlockIPList.Items[i]);
      if IPaddr.nIPaddr = nIPaddr then begin
        Result := BlockIPList.Count;
        break;
      end;
    end;
    if Result <= 0 then begin
      New(IPaddr);
      IPaddr^.nIPaddr := nIPaddr;
      BlockIPList.Add(IPaddr);
      Result := BlockIPList.Count;
    end;
  finally
    BlockIPList.UnLock;
  end;
end;

function TFrmMain.AddTempBlockIP(sIPaddr: string): Integer;
var
  i: Integer;
  IPaddr: pTSockaddr;
  nIPaddr: Integer;
begin
  TempBlockIPList.Lock;
  try
    Result := 0;
    nIPaddr := inet_addr(PChar(sIPaddr));
    for i := 0 to TempBlockIPList.Count - 1 do begin
      IPaddr := pTSockaddr(TempBlockIPList.Items[i]);
      if IPaddr.nIPaddr = nIPaddr then begin
        Result := TempBlockIPList.Count;
        break;
      end;
    end;
    if Result <= 0 then begin
      New(IPaddr);
      IPaddr^.nIPaddr := nIPaddr;
      TempBlockIPList.Add(IPaddr);
      Result := TempBlockIPList.Count;
    end;
  finally
    TempBlockIPList.UnLock;
  end;
end;

function TFrmMain.IsConnLimited(sIPaddr: string; nSocketHandle: Integer):
  Boolean;
var
  i: Integer;
  IPaddr: pTSockaddr;
  nIPaddr: Integer;
  boDenyConnect: Boolean;
begin
  Result := False;
  boDenyConnect := False;
  nIPaddr := inet_addr(PChar(sIPaddr));
  CurrIPaddrList.Lock;
  try
    for I := 0 to CurrIPaddrList.Count - 1 do begin
      IPaddr := CurrIPaddrList.Items[I];
      if IPaddr.nIPaddr = nIPaddr then begin
        Inc(IPaddr.nCount);
        if GetTickCount - IPaddr.dwIPCountTick1 < nIPCountLimitTime1 then begin
          Inc(IPaddr.nIPCount1);
          if IPaddr.nIPCount1 >= nIPCountLimit1 then
            boDenyConnect := True;
        end
        else begin
          IPaddr.dwIPCountTick1 := GetTickCount();
          IPaddr.nIPCount1 := 0;
        end;
        if GetTickCount - IPaddr.dwIPCountTick2 < nIPCountLimitTime2 then begin
          Inc(IPaddr.nIPCount2);
          if IPaddr.nIPCount2 >= nIPCountLimit2 then
            boDenyConnect := True;
        end
        else begin
          IPaddr.dwIPCountTick2 := GetTickCount();
          IPaddr.nIPCount2 := 0;
        end;
        if IPaddr.nCount > nMaxConnOfIPaddr then
          boDenyConnect := True;

        Result := boDenyConnect;
        exit;
      end;
    end;
    New(IPaddr);
    SafeFillChar(IPaddr^, SizeOf(TSockaddr), 0);
    IPaddr.nIPaddr := nIPaddr;
    IPaddr.nCount := 1;
    CurrIPaddrList.Add(IPaddr);
  finally
    CurrIPaddrList.UnLock;
  end;
end;

(*
function TFrmMain.GetConnectCountOfIP(sIPaddr: string): Integer;
var
  i: Integer;
  IPaddr: pTSockaddr;
  nIPaddr: Integer;
  //  bo01: Boolean;
  IPList: TList;
begin
  Result := 0;
  CurrIPaddrList.Lock;
  try
    nIPaddr := inet_addr(PChar(sIPaddr));
    for i := 0 to CurrIPaddrList.Count - 1 do begin
      IPList := TList(CurrIPaddrList.Items[i]);
      if (IPList <> nil) and (IPList.Count > 0) then begin
        IPaddr := pTSockaddr(IPList.Items[0]);
        if IPaddr <> nil then begin
          if IPaddr.nIPaddr = nIPaddr then begin
            Result := IPList.Count;
            break;
          end;
        end;
      end;
    end;
  finally
    CurrIPaddrList.UnLock;
  end;
end;           *)

procedure TFrmMain.MENU_OPTION_IPFILTERClick(Sender: TObject);
var
  i: Integer;
  sIPaddr: string;
begin
  with frmIPaddrFilter do begin
    Top := Self.Top + 20;
    Left := Self.Left;
    ListBoxTempList.Clear;
    ListBoxBlockList.Clear;
    ListBoxActiveList.Clear;
    ListBoxIpList.Clear;
    if ServerSocket.Active then
      for i := 0 to ServerSocket.Socket.ActiveConnections - 1 do begin
        sIPaddr := ServerSocket.Socket.Connections[i].RemoteAddress;
        if sIPaddr <> '' then
          ListBoxActiveList.Items.AddObject(sIPaddr,
            Tobject(ServerSocket.Socket.Connections[i]));
      end;
    for i := 0 to IPList.Count - 1 do begin
      ListBoxIpList.Items.AddObject(StrPas(inet_ntoa(TInAddr(pTBlockaddr(IPList[i]).nBeginAddr))) + ' - ' +
        StrPas(inet_ntoa(TInAddr(pTBlockaddr(IPList[i]).nEndAddr))), TObject(IPList[i]));
    end;
    for i := 0 to TempBlockIPList.Count - 1 do begin
      ListBoxTempList.Items.Add(StrPas(inet_ntoa(TInAddr(pTSockaddr(TempBlockIPList.Items[i]).nIPaddr))));
    end;
    for i := 0 to BlockIPList.Count - 1 do begin
      ListBoxBlockList.Items.Add(StrPas(inet_ntoa(TInAddr(pTSockaddr(BlockIPList.Items[i]).nIPaddr))));
    end;
    EditMaxConnect.Value := nMaxConnOfIPaddr;
    case BlockMethod of
      mDisconnect: RadioDisConnect.Checked := True;
      mBlock: RadioAddTempList.Checked := True;
      mBlockList: RadioAddBlockList.Checked := True;
    end;
    //.SpinEditAttackTick.Value := dwAttackTick;
    //.SpinEditAttackCount.Value := nAttackCount;
    EditMaxConnect.Value := nMaxConnOfIPaddr;
    EditClientTimeOutTime.Value := dwClientTimeOutTime div 1000;
    EditSessionTimeOutTime.Value := dwSessionTimeOutTime div 1000 div 60;
    Edit_CountLimit2.Value := nIPCountLimit2;
    Edit_CountLimit1.Value := nIPCountLimit1;
    Edit_LimitTime2.Value := nIPCountLimitTime2;
    Edit_LimitTime1.Value := nIPCountLimitTime1;
    MsgMaxLenSpinEdit.Value := nSayMsgMaxLen;
    MsgTimeSpinEdit.Value := nSayMsgTime;
    MsgCountSpinEdit.Value := nSayMsgCount;
    MsgCloseTimeSpinEdit.Value := nSayMsgCloseTime div 1000;
    CheckBoxBlockSay.Checked := boBlockSay;

    EditMaxSize.Value := nMaxClientPacketSize;
    EditNomSize.Value := nNomClientPacketSize;
    EditSpeedTick.Value := nEditSpeedTick;
    EditSpeedTime.Value := nEditSpeedCount;
    EditMaxClientMsgCount.Value := nMaxClientMsgCount;
    CheckBoxLostLine.Checked := bokickOverPacketSize;
    CheckBoxCCProtect.Checked := boCCProtect;
    ShowModal;
  end;
end;

function TFrmMain.CloseConnect(sIPaddr: string): Integer;
var
  i: Integer;
  boCheck: Boolean;
begin
  Result := 0;
  if ServerSocket.Active then
    while (ServerSocket.Socket.ActiveConnections > 0) do begin
      boCheck := False;
      for i := 0 to ServerSocket.Socket.ActiveConnections - 1 do begin
        if sIPaddr = ServerSocket.Socket.Connections[i].RemoteAddress then begin
          ServerSocket.Socket.Connections[i].Close;
          Inc(Result);
          boCheck := True;
          break;
        end;
      end;
      if not boCheck then
        break;
    end;
end;

procedure TFrmMain.MENU_OPTION_PERFORMClick(Sender: TObject);
begin
  frmPrefConfig.boShowOK := False;
  frmPrefConfig.Top := Self.Top + 20;
  frmPrefConfig.Left := Self.Left;
  with frmPrefConfig do begin
    EditServerCheckTimeOut.Value := dwCheckServerTimeOutTime div 1000;
    EditSendBlockSize.Value := nClientSendBlockSize;
    {
    EditGateIPaddr.Text:=GateAddr;
    EditGatePort.Text:=IntToStr(GatePort);
    EditServerIPaddr.Text:=ServerAddr;
    EditServerPort.Text:=IntToStr(ServerPort);
    EditTitle.Text:=TitleName;
    TrackBarLogLevel.Position:=nShowLogLevel;
    ComboBoxShowBite.ItemIndex:=Integer(boShowBite);
    }
    boShowOK := True;
    ShowModal;
  end;
end;
 {
procedure TFrmMain.SendClientMsg(SessionInfo: pTSessionInfo; sMsg: string;
  MsgColor: Byte = 0);
var
  DefMsg: TDefaultMessage;
  sSendText: string;
begin
  if (SessionInfo <> nil) and (SessionInfo.Socket <> nil) and
    SessionInfo.Socket.Connected then begin
    case MsgColor of
      0: DefMsg := MakeDefaultMsg(SM_SYSMESSAGE, 0, MakeWord(btRedMsgFColor, btRedMsgBColor), 0, 1);
      1: DefMsg := MakeDefaultMsg(SM_SYSMESSAGE, 0, MakeWord(btBlueMsgFColor, btBlueMsgBColor), 0, 1);
      2: DefMsg := MakeDefaultMsg(SM_SYSMESSAGE, 0, MakeWord(btGreenMsgFColor, btGreenMsgBColor), 0, 1);
    else
      DefMsg := MakeDefaultMsg(SM_SYSMESSAGE, 0, MakeWord(btRedMsgFColor, btRedMsgBColor), 0, 1);
    end;
    sSendText := g_CodeHead + EncodeMessage(DefMsg) + EncodeString(sMsg) + g_CodeEnd;
    SessionInfo.Socket.SendText(sSendText);
  end;
end;    }

procedure TFrmMain.SendKeepAlivePacket;
begin
  if CenterSocket.Socket.Connected then
    CenterSocket.Socket.SendText('(' + IntToStr(SS_SERVERINFO) + '/' +
      TitleName + '/' + IntToStr(GatePort) + '/' + IntToStr(S_SessionCount) + ')');

end;

procedure TFrmMain.CenterSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if not boCenterReady then
    AddMainLogMsg('Connected to server(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ').', 0);
  boCenterReady := True;
  m_sCenterMsg := '';
  ClearAllSessionInfo();
end;

procedure TFrmMain.CenterSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if boCenterReady then
    AddMainLogMsg('Disconnected(' + Socket.RemoteAddress + ':' + IntToStr(Socket.RemotePort) + ')...', 0);
  boCenterReady := False;
  ClearAllSessionInfo();
  m_sCenterMsg := '';
end;

procedure TFrmMain.CenterSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmMain.CenterSocketRead(Sender: TObject; Socket: TCustomWinSocket);
begin
  m_sCenterMsg := m_sCenterMsg + Socket.ReceiveText;
  if Pos(')', m_sCenterMsg) > 0 then begin
    ProcessCenterMsg();
  end;
end;
(*
function TFrmMain.CheckDefMsg(DefMsg: pTDefaultMessage; SessionInfo:
  pTSessionInfo): Integer;
var
  boSpeedShowMsg: Boolean;
begin
  Result := 0;
  boSpeedShowMsg := False;
  case DefMsg.Ident of
    CM_WALK: begin
        if g_Config.boWalk then begin
          if (GetTickCount - SessionInfo.GameSpeed.dwWalkTimeTick) >
            LongWord(g_Config.nWalkTime) then begin
            SessionInfo.GameSpeed.dwWalkTimeTick := GetTickCount();
            if SessionInfo.GameSpeed.nWalkCount > g_Config.nDecErrorCount then
              Dec(SessionInfo.GameSpeed.nWalkCount, g_Config.nDecErrorCount)
            else
              SessionInfo.GameSpeed.nWalkCount := 0;
            //if SessionInfo.GameSpeed.nAttackCount >= g_Config.nAttackCount then boSpeedShowMsg := True;
          end
          else begin
            SessionInfo.GameSpeed.dwWalkTimeTick := GetTickCount();
            Inc(SessionInfo.GameSpeed.nWalkCount, g_Config.nIncErrorCount);
            if SessionInfo.GameSpeed.nWalkCount >= g_Config.nWalkCount then begin
              boSpeedShowMsg := True;
              Result := g_Config.btSpeedControlMode + 1;
            end;
          end;
        end;
      end;
    CM_RUN: begin
        if g_Config.boRun then begin
          if (GetTickCount - SessionInfo.GameSpeed.dwRunTimeTick) >
            LongWord(g_Config.nRunTime) then begin
            SessionInfo.GameSpeed.dwRunTimeTick := GetTickCount();
            if SessionInfo.GameSpeed.nRunCount > g_Config.nDecErrorCount then
              Dec(SessionInfo.GameSpeed.nRunCount, g_Config.nDecErrorCount)
            else
              SessionInfo.GameSpeed.nRunCount := 0;
            //if SessionInfo.GameSpeed.nAttackCount >= g_Config.nAttackCount then boSpeedShowMsg := True;
          end
          else begin
            SessionInfo.GameSpeed.dwRunTimeTick := GetTickCount();
            Inc(SessionInfo.GameSpeed.nRunCount, g_Config.nIncErrorCount);
            if SessionInfo.GameSpeed.nRunCount >= g_Config.nRunCount then begin
              boSpeedShowMsg := True;
              Result := g_Config.btSpeedControlMode + 1;
            end;
          end;
        end;
      end;
    CM_TURN: begin
        if g_Config.boTurn then begin
          if (GetTickCount - SessionInfo.GameSpeed.dwTurnTimeTick) >
            LongWord(g_Config.nTurnTime) then begin
            SessionInfo.GameSpeed.dwTurnTimeTick := GetTickCount();
            if SessionInfo.GameSpeed.nTurnCount > g_Config.nDecErrorCount then
              Dec(SessionInfo.GameSpeed.nTurnCount, g_Config.nDecErrorCount)
            else
              SessionInfo.GameSpeed.nTurnCount := 0;
          end
          else begin
            SessionInfo.GameSpeed.dwTurnTimeTick := GetTickCount();
            Inc(SessionInfo.GameSpeed.nTurnCount, g_Config.nIncErrorCount);
            if SessionInfo.GameSpeed.nTurnCount >= g_Config.nTurnCount then begin
              boSpeedShowMsg := True;
              Result := g_Config.btSpeedControlMode + 1;
            end;
          end;
        end;
      end;
    CM_HIT, CM_HEAVYHIT, CM_BIGHIT, CM_POWERHIT, CM_LONGHIT, CM_WIDEHIT,
      CM_FIREHIT, CM_CRSHIT, CM_TWNHIT: begin
        if g_Config.boHit then begin
          if (GetTickCount - SessionInfo.GameSpeed.dwHitTimeTick) >
            LongWord(g_Config.nHitTime) then begin
            SessionInfo.GameSpeed.dwHitTimeTick := GetTickCount();
            if SessionInfo.GameSpeed.nHitCount > g_Config.nDecErrorCount then
              Dec(SessionInfo.GameSpeed.nHitCount, g_Config.nDecErrorCount)
            else
              SessionInfo.GameSpeed.nHitCount := 0;
          end
          else begin
            SessionInfo.GameSpeed.dwHitTimeTick := GetTickCount();
            Inc(SessionInfo.GameSpeed.nHitCount, g_Config.nIncErrorCount);
            if SessionInfo.GameSpeed.nHitCount >= g_Config.nHitCount then begin
              boSpeedShowMsg := True;
              Result := g_Config.btSpeedControlMode + 1;
            end;
          end;
        end;
      end;
    CM_SPELL: begin
        if g_Config.boSpell then begin
          if (GetTickCount - SessionInfo.GameSpeed.dwSpellTimeTick) >
            LongWord(g_Config.nSpellTime) then begin
            SessionInfo.GameSpeed.dwSpellTimeTick := GetTickCount();
            if SessionInfo.GameSpeed.nSpellCount > 0 then
              Dec(SessionInfo.GameSpeed.nSpellCount);
            //if SessionInfo.GameSpeed.nAttackCount >= g_Config.nAttackCount then boSpeedShowMsg := True;
          end
          else begin
            SessionInfo.GameSpeed.dwSpellTimeTick := GetTickCount();
            Inc(SessionInfo.GameSpeed.nSpellCount, g_Config.nIncErrorCount);
            if SessionInfo.GameSpeed.nSpellCount >= g_Config.nSpellCount then begin
              boSpeedShowMsg := True;
              Result := g_Config.btSpeedControlMode + 1;
            end;
          end;
        end;
      end;

    { CM_DROPITEM: begin
       end;
     CM_PICKUP: begin
       end;   }
  end;
  if g_Config.boSpeedShowMsg and boSpeedShowMsg then
    SendClientMsg(SessionInfo, g_Config.sSpeedShowMsg, g_Config.btMsgColor);
end;

function TFrmMain.CheckSayMsg(UserData: pTSendUserData): Boolean;
resourcestring
  sText = 'Prohibit Chat';
  sText1 = 'Because you speak too fast, the %d minute ban chat! ! !';
var
  LTime: LongWord;
begin
  Result := False;
  LTime := GetTickCount();
  if LTime < SessionArray[UserData.nSocketIdx].dwSayMsgCloseTime then begin
    SendClientMsg(@SessionArray[UserData.nSocketIdx],
      sText);
    Result := True;
  end
  else if (LTime - SessionArray[UserData.nSocketIdx].dwSayMsgTick) < nSayMsgTime then begin
    if SessionArray[UserData.nSocketIdx].dwSayMsgCount >= nSayMsgCount then begin
      SessionArray[UserData.nSocketIdx].dwSayMsgCloseTime := LTime +
        nSayMsgCloseTime;
      SendClientMsg(@SessionArray[UserData.nSocketIdx],
        Format(sText1, [_MAX(nSayMsgCloseTime div 60000, 1)]));
      Result := True;
    end
    else begin
      Inc(SessionArray[UserData.nSocketIdx].dwSayMsgCount);
    end;
  end
  else begin
    SessionArray[UserData.nSocketIdx].dwSayMsgCount := 0;
  end;
  SessionArray[UserData.nSocketIdx].dwSayMsgTick := LTime;
end;    *)

{procedure TFrmMain.CloseAllUser;
var
  nSockIdx: Integer;
begin
  for nSockIdx := 0 to RUNATEMAXSESSION - 1 do begin
    if SessionArray[nSockIdx].Socket <> nil then
      SessionArray[nSockIdx].Socket.Close;
  end;
end;         }

procedure TFrmMain.MENU_CONTROL_RELOADCONFIGClick(Sender: TObject);
begin
  if Application.MessageBox('Are you sure to reload the configuration information?', 'Confirmation', MB_OKCANCEL + MB_ICONQUESTION) <> IDOK
    then
    Exit;
  LoadConfig();
  AddMainLogMsg('Reload configuration complete.', 0);
end;

procedure TFrmMain.I1Click(Sender: TObject);
begin
  //AddMainLogMsg('----------------------------------', 0);
  AddMainLogMsg(g_sUpDateTime, 0);
  AddMainLogMsg(g_sProgram, 0);
  AddMainLogMsg(g_sWebSite, 0);
end;

procedure TFrmMain.I2Click(Sender: TObject);
begin
  I2.Checked := not I2.Checked;
  Panel1.Visible := I2.Checked;
  MemoLog.Visible := not I2.Checked;
end;

procedure TFrmMain.MENU_VIEW_LOGMSGClick(Sender: TObject);
begin
  FrmOnLineHum := TFrmOnLineHum.Create(Owner);
  FrmOnLineHum.Open;
  FrmOnLineHum.Free;
end;

procedure TFrmMain.MyMessage(var MsgData: TWmCopyData);
var
  sData, sAccount, sSessionID, sName, sPort: string;
  wIdent: Word;
begin
  wIdent := HiWord(MsgData.From);
  sData := StrPas(MsgData.CopyDataStruct^.lpData);
  case wIdent of
    GS_USERLOGIN: begin
        sData := GetValidStr3(sData, sAccount, ['/']);
        sData := GetValidStr3(sData, sSessionID, ['/']);
        sPort := GetValidStr3(sData, sName, ['/']);
        SetSession(sAccount, sName, StrToIntDef(sSessionID, 0), StrToIntDef(sPort, 0));
      end;
    GS_USERGHOST: begin
        sSessionID := GetValidStr3(sData, sAccount, ['/']);
        SetSession(sAccount, '', StrToIntDef(sSessionID, 0), 0);
      end;
    GS_QUIT: begin
        if boServiceStart then begin
          StartTimer.Enabled := True;
        end
        else begin
          boClose := True;
          Close();
        end;
      end;
    1: ;
    2: ;
    3: ;
  end;
end;

procedure TFrmMain.N1Click(Sender: TObject);
begin
  N1.Checked := not N1.Checked;
end;

procedure TFrmMain.OnProgramException(Sender: TObject; E: Exception);
begin
  AddMainLogMsg(E.Message, 0);
end;

procedure TFrmMain.OpenCCProtect(boOpen: Boolean);
var
  I: Integer;
begin
  if boOpen then begin
    nCCHeadOffCount := 0;

    nOldShowLogLevel := nShowLogLevel;
    nOldIPCountLimitTime1 := nIPCountLimitTime1;
    nOldIPCountLimit1 := nIPCountLimit1;
    nOldIPCountLimitTime2 := nIPCountLimitTime2;
    nOldIPCountLimit2 := nIPCountLimit2;
    OldBlockMethod := BlockMethod;
    dwOldClientTimeOutTime := dwClientTimeOutTime;
    dwOldSessionTimeOutTime := dwSessionTimeOutTime;
    nOldMaxConnOfIPaddr := nMaxConnOfIPaddr;

    nShowLogLevel := 0;
    nIPCountLimitTime1 := 1000;
    nIPCountLimit1 := 10;
    nIPCountLimitTime2 := 3000;
    nIPCountLimit2 := 20;
    BlockMethod := mBlock;
    dwSessionTimeOutTime := 3 * 60 * 1000;
    dwClientTimeOutTime := 10 * 1000;
    nMaxConnOfIPaddr := 30;

    AddMainLogMsg('CC attack is detected, Starting anti defense.', 0);
  end else begin
    nShowLogLevel := nOldShowLogLevel;
    nIPCountLimitTime1 := nOldIPCountLimitTime1;
    nIPCountLimit1 := nOldIPCountLimit1;
    nIPCountLimitTime2 := nOldIPCountLimitTime2;
    nIPCountLimit2 := nOldIPCountLimit2;
    BlockMethod := OldBlockMethod;
    dwSessionTimeOutTime := dwOldSessionTimeOutTime;
    dwClientTimeOutTime := dwOldClientTimeOutTime;
    nMaxConnOfIPaddr := nOldMaxConnOfIPaddr;
    TempBlockIPList.Lock;
    try
      for i := 0 to TempBlockIPList.Count - 1 do begin
        Dispose(pTSockaddr(TempBlockIPList.Items[i]));
      end;
      TempBlockIPList.Clear;
    finally
      TempBlockIPList.UnLock;
    end;
    AddMainLogMsg('CC defense interception '+ IntToStr(nCCHeadOffCount) +' Attacks...', 0);
  end;
end;

end.


