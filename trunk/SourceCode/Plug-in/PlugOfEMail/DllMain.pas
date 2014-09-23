unit DllMain;

interface
uses
  Windows, Classes, EngineAPI, EngineType, SysUtils;

procedure LoadPlug();
procedure UnLoadPlug(boExit: Boolean);

procedure APIUserLoginEnd(PlayObject: TObject); stdcall;
function PlayObjectOperateMessage(BaseObject: TObject; wIdent: Word; wParam: Word;
  nParam1: Integer; nParam2: Integer; nParam3: Integer; MsgObject: TObject;
  dwDeliveryTime: LongWord; pszMsg: PChar; var boReturn: Boolean): Boolean; stdcall;
procedure UserLoadAndSave(boLoad, boLoadFail, boRun, boGhost: Boolean; nDBIndex: Integer); stdcall;

procedure ReadEMailInfo(PlayObject: TObject; nIndex: Integer);
procedure DelEMailInfo(PlayObject: TObject; nIndex: Integer);
procedure DelEMailAll(PlayObject: TObject);
procedure AddEMailInfo(PlayObject: TObject; body: string);

var
  OLDUSERLOGINEND: _TOBJECTACTION;
  OLDPLAYOBJECTOPERATEMESSAGE: _TOBJECTOPERATEMESSAGE;
  OLDUSERLOADANDSAVE: _TOBJECTUSERLOADANDSAVE;

implementation
uses
  EMailDB, Grobal2, EMailMain, Hutil32, DateUtils;

procedure LoadPlug();
begin
  InitializeCriticalSection(EMAIL_CS);
  m_MsgList := TList.Create;
  m_TempMsgList := TList.Create;
  FileEMailDB := TFileEMailDB.Create(GetUserDataDir()^ + 'EMail.DB');
  FillChar(m_UserList, SizeOf(m_UserList), #0);

  OLDUSERLOGINEND := TPlayObject_GetHookUserLoginEnd();
  TPlayObject_SetHookUserLoginEnd(APIUserLoginEnd);

  OLDPLAYOBJECTOPERATEMESSAGE := TPlayObject_GetHookPlayOperateMessage();
  TPlayObject_SetHookPlayOperateMessage(PlayObjectOperateMessage);

  OLDUSERLOADANDSAVE := API_GetHookUserLoadAndSave();
  API_SetHookUserLoadAndSave(UserLoadAndSave);
end;

procedure UnLoadPlug(boExit: Boolean);
var
  i, ii: Integer;
begin
  if not boExit then begin
    if not API_UnModule(MODULE_USERLOGINEND, @APIUserLoginEnd, @OLDUSERLOGINEND) then
      TPlayObject_SetHookUserLoginEnd(OLDUSERLOGINEND);

    if not API_UnModule(MODULE_PLAYOPERATEMESSAGE, @PlayObjectOperateMessage, @OLDPLAYOBJECTOPERATEMESSAGE) then
      TPlayObject_SetHookPlayOperateMessage(OLDPLAYOBJECTOPERATEMESSAGE);

    if not API_UnModule(MODULE_USERLOADANDSAVE, @UserLoadAndSave, @OLDUSERLOADANDSAVE) then
      API_SetHookUserLoadAndSave(OLDUSERLOADANDSAVE);
  end;

  FileEMailDB.Free;
  for I := 0 to m_MsgList.Count - 1 do
    Dispose(pTEMailMsgInfo(m_MsgList[i]));
  for I := 0 to m_TempMsgList.Count - 1 do
    Dispose(pTEMailMsgInfo(m_TempMsgList[i]));
  m_MsgList.Free;
  m_TempMsgList.Free;
  Lock;
  Try
    for i := Low(m_UserList) to High(m_UserList) do begin
      if m_UserList[i] <> nil then begin
        if (m_UserList[i].EMailList <> nil) then begin
          for II := 0 to m_UserList[i].EMailList.Count - 1 do
            Dispose(pTEMailUserData(m_UserList[i].EMailList[II]));
          m_UserList[i].EMailList.Free;
        end;
        Dispose(pTEMailUserInfo(m_UserList[i]));
      end;
    end;
  Finally
    UnLock;
  End;
  DeleteCriticalSection(EMAIL_CS);
end;

procedure APIUserLoginEnd(PlayObject: TObject); stdcall;
var
  nDBIndex, I: Integer;
  EMailUserData: pTEMailUserData;
  EMailUserInfo: pTEMailUserInfo;
  ClientEMailHeader: TClientEMailHeader;
  sSendMsg: string;
  nTime: Integer;
  EMailMsgInfo: pTEMailMsgInfo;
  dTime: TDateTime;
begin
  try
    nDBIndex := TPlayObject_GetDBIndex(PlayObject);
    sSendMsg := '';
    Lock;
    try
      if (nDBIndex > 0) and (nDBIndex < PLAYOBJECTINDEXCOUNT) then begin
        dTime := Now;
        EMailUserInfo := m_UserList[nDBIndex];
        if EMailUserInfo <> nil then begin
          for I := EMailUserInfo.EMailList.Count - 1 downto 0 do begin
            EMailUserData := EMailUserInfo.EMailList[i];
            if EMailUserData <> nil then begin
              nTime := MAXEMAILTIME - DaysBetween(dTime, EMailUserData.EMailInfo.Header.dCreateTime);
              if (nTime > 0) and (nTime <= MAXEMAILTIME)  then begin
                ClientEMailHeader.nIdx := I;
                ClientEMailHeader.sTitle := EMailUserData.EMailInfo.sTitle;
                ClientEMailHeader.sSendName := EMailUserData.EMailInfo.sSendName;
                ClientEMailHeader.dSendTime := EMailUserData.EMailInfo.Header.dCreateTime;
                ClientEMailHeader.boRead := EMailUserData.EMailInfo.Header.boRead;
                ClientEMailHeader.btTime := nTime;
                sSendMsg := sSendMsg + EncodeBuffer(@ClientEMailHeader, SizeOf(ClientEMailHeader)) + '/';
              end else begin
                New(EMailMsgInfo);
                EMailMsgInfo.MsgType := mt_Del;
                EMailMsgInfo.nDBIndex := nDBIndex;
                EMailMsgInfo.nIndex := EMailUserData.nIndex;
                EMailMsgInfo.EMailInfo := nil;
                m_MsgList.Add(EMailMsgInfo);
                Dispose(EMailUserData.EMailInfo);
                Dispose(EMailUserData);
                EMailUserInfo.EMailList.Delete(i);
              end;
            end;
          end;
        end;
      end;
    finally
      UnLock;
    end;
    if sSendMsg <> '' then
      TBaseObject_SendDefSocket(PlayObject, PlayObject, SM_EMAIL, 0, 0, 0, 0, PChar(sSendMsg));
  except
    on E: Exception do begin
      MainOutMessage(PChar(E.Message));
      MainOutMessage('[Exception] zPlugOfEMail.APIUserLoginEnd');
    end;
  end;
  //调用下一个插件处理
  if Assigned(OLDUSERLOGINEND) then
    OLDUSERLOGINEND(PlayObject);
end;

//获取信件详细信息

procedure ReadEMailInfo(PlayObject: TObject; nIndex: Integer);
var
  nDBIndex: Integer;
  EMailUserData: pTEMailUserData;
  EMailUserInfo: pTEMailUserInfo;
begin
  try
    nDBIndex := TPlayObject_GetDBIndex(PlayObject);
    Lock;
    try
      if (nDBIndex > 0) and (nDBIndex < PLAYOBJECTINDEXCOUNT) then begin
        EMailUserInfo := m_UserList[nDBIndex];
        if EMailUserInfo <> nil then begin
          if (nIndex >= 0) and (nIndex < EMailUserInfo.EMailList.Count) then begin
            EMailUserData := EMailUserInfo.EMailList[nIndex];
            if EMailUserData <> nil then begin
              if not EMailUserData.EMailInfo.Header.boRead then begin
                EMailUserData.EMailInfo.Header.boRead := True;
                EMailUserData.boChange := True;
                EMailUserInfo.boChange := True;
              end;
              TBaseObject_SendDefMsg(PlayObject, PlayObject, SM_EMAIL, nIndex, 0, 0, 1,
                PChar(string(EMailUserData.EMailInfo.Text)));
              exit;
            end;
          end;
        end;
      end;
    finally
      UnLock;
    end;
    TBaseObject_SendDefMsg(PlayObject, PlayObject, SM_EMAIL, -1, 0, 0, 1, '');
  except
    on E: Exception do begin
      MainOutMessage(PChar(E.Message));
      MainOutMessage('[Exception] zPlugOfEMail.ReadEMailInfo');
    end;
  end;
end;

procedure DelEMailAll(PlayObject: TObject);
var
  nDBIndex: Integer;
  nDelIndex: Integer;
  EMailUserData: pTEMailUserData;
  EMailUserInfo: pTEMailUserInfo;
  EMailMsgInfo: pTEMailMsgInfo;
  i: integer;
begin
  try
    nDBIndex := TPlayObject_GetDBIndex(PlayObject);
    Lock;
    try
      if (nDBIndex > 0) and (nDBIndex < PLAYOBJECTINDEXCOUNT) then begin
        EMailUserInfo := m_UserList[nDBIndex];
        if EMailUserInfo <> nil then begin
          for i := 0 to EMailUserInfo.EMailList.Count - 1 do begin
            EMailUserData := EMailUserInfo.EMailList[i];
            //EMailUserInfo.EMailList.Delete(nIndex);
            nDelIndex := EMailUserData.nIndex;
            Dispose(EMailUserData.EMailInfo);
            Dispose(EMailUserData);
            New(EMailMsgInfo);
            EMailMsgInfo.MsgType := mt_Del;
            EMailMsgInfo.nDBIndex := nDBIndex;
            EMailMsgInfo.nIndex := nDelIndex;
            EMailMsgInfo.EMailInfo := nil;
            m_MsgList.Add(EMailMsgInfo);
          end;
          EMailUserInfo.EMailList.Free;
          Dispose(EMailUserInfo);
          m_UserList[nDBIndex] := nil;
        end;
      end;
    finally
      UnLock;
    end;
  except
    on E: Exception do begin
      MainOutMessage(PChar(E.Message));
      MainOutMessage('[Exception] zPlugOfEMail.DelEMailInfo');
    end;
  end;
end;

procedure DelEMailInfo(PlayObject: TObject; nIndex: Integer);
var
  nDBIndex: Integer;
  nDelIndex: Integer;
  EMailUserData: pTEMailUserData;
  EMailUserInfo: pTEMailUserInfo;
  EMailMsgInfo: pTEMailMsgInfo;
begin
  try
    nDBIndex := TPlayObject_GetDBIndex(PlayObject);
    Lock;
    try
      if (nDBIndex > 0) and (nDBIndex < PLAYOBJECTINDEXCOUNT) then begin
        EMailUserInfo := m_UserList[nDBIndex];
        if EMailUserInfo <> nil then begin
          if (nIndex >= 0) and (nIndex < EMailUserInfo.EMailList.Count) then begin
            EMailUserData := EMailUserInfo.EMailList[nIndex];
            EMailUserInfo.EMailList.Delete(nIndex);
            nDelIndex := EMailUserData.nIndex;
            Dispose(EMailUserData.EMailInfo);
            Dispose(EMailUserData);
            New(EMailMsgInfo);
            EMailMsgInfo.MsgType := mt_Del;
            EMailMsgInfo.nDBIndex := nDBIndex;
            EMailMsgInfo.nIndex := nDelIndex;
            EMailMsgInfo.EMailInfo := nil;
            m_MsgList.Add(EMailMsgInfo);
          end;
        end;
      end;
    finally
      UnLock;
    end;
  except
    on E: Exception do begin
      MainOutMessage(PChar(E.Message));
      MainOutMessage('[Exception] zPlugOfEMail.DelEMailInfo');
    end;
  end;
end;

procedure AddEMailInfo(PlayObject: TObject; body: string);
var
  sUserName: string;
  sTitle: string;
  sText: string;
  FriendList: TAPIStringList;
  nSendDBIndex: Integer;
  i: integer;
  EMailInfo: pTEMailInfo;
  EMailMsgInfo: pTEMailMsgInfo;
  nCode: Integer;
  pGold: pInteger;
  sChrName: string;
//  str: string;
begin
  try
    nCode := 1; //内容不完整
    nSendDBIndex := 0;
    pGold := TBaseObject_nGold(PlayObject);
    if pGold^ < SENDMAILMONEY then begin
      nCode := -5;
    end;
    if (nCode = 1) and (body <> '') then begin
      nCode := -1; //内容不完整
      body := GetValidStr3(body, sUserName, ['/']);
      body := GetValidStr3(body, sTitle, ['/']);
      body := GetValidStr3(body, sText, ['/']);
      sUserName := DecodeString(sUserName);
      sTitle := DecodeString(sTitle);
      sText := DecodeString(sText);
      if (sUserName <> '') and (sTitle <> '') and (sText <> '') then begin
        FriendList := TPlayObject_FriendList(PlayObject);
        if FriendList <> nil then begin
          for I := 0 to TStringList_Count(FriendList) - 1 do begin
            if CompareText(TStringList_Strings(FriendList, I), sUserName) = 0 then begin
              nSendDBIndex := Integer(TStringList_Objects(FriendList, I));
              break;
            end;
          end;
        end;
        nCode := -2; //收信人不存在好友列表当中
        if nSendDBIndex > 0 then begin
          sChrName := TBaseObject_sCharName(PlayObject)^;
          Dec(pGold^, SENDMAILMONEY);
          if GetGameLogGold()^ then begin
            AddgameDataLog(PlayObject, LOG_GOLDCHANGED, sSTRING_GOLDNAME, 0, TBaseObject_nGold(PlayObject)^,
              '信件', '-', PChar(IntToStr(SENDMAILMONEY)), '信件');
          end;
          TBaseObject_GoldChanged(PlayObject);
          New(EMailInfo);
          FillChar(EMailInfo^, SizeOf(TEMailInfo), #0);
          EMailInfo.Header.boDelete := False;
          EMailInfo.Header.boRead := False;
          EMailInfo.Header.dCreateTime := Now;
          EMailInfo.Header.nReadIndex := nSendDBIndex;
          EMailInfo.boSystem := False;
          EMailInfo.sReadName := sUserName;
          EMailInfo.sSendName := sChrName;
          EMailInfo.sTitle := sTitle;
          EMailInfo.TextLen := SizeOf(EMailInfo.Text);
          if Length(sText) < EMailInfo.TextLen then
            EMailInfo.TextLen := Length(sText);
          Move(sText[1], EMailInfo.Text[0], EMailInfo.TextLen);

          New(EMailMsgInfo);
          EMailMsgInfo.MsgType := mt_Add;
          EMailMsgInfo.nDBIndex := nSendDBIndex;
          EMailMsgInfo.nIndex := TPlayObject_GetDBIndex(PlayObject);
          EMailMsgInfo.EMailInfo := EMailInfo;
          Lock;
          try
            m_MsgList.Add(EMailMsgInfo);
          finally
            UnLock;
          end;
          exit;
        end;
      end;
    end;
    TBaseObject_SendDefMsg(PlayObject, PlayObject, SM_EMAIL, nCode, 0, 0, 2, '');
  except
    on E: Exception do begin
      MainOutMessage(PChar(E.Message));
      MainOutMessage('[Exception] zPlugOfEMail.AddEMailInfo');
    end;
  end;
end;

function PlayObjectOperateMessage(BaseObject: TObject; wIdent: Word; wParam: Word;
  nParam1: Integer; nParam2: Integer; nParam3: Integer; MsgObject: TObject;
  dwDeliveryTime: LongWord; pszMsg: PChar; var boReturn: Boolean): Boolean; stdcall;
begin
  Result := True; //该返回值暂时无作用
  boReturn := False; //返回 False 程序将不再匹配
  case wIdent of
    CM_EMAIL: begin
        case wParam of
          0: ReadEMailInfo(BaseObject, nParam1);
          1: DelEMailInfo(BaseObject, nParam1);
          2: AddEMailInfo(BaseObject, pszMsg);
          3: DelEMailAll(BaseObject);
        end;
      end;
  else begin
      if Assigned(OldPlayObjectOperateMessage) then begin //传递给下一个插件继续处理
        Result := OldPlayObjectOperateMessage(BaseObject, wIdent, wParam, nParam1,
          nParam2, nParam3, BaseObject, dwDeliveryTime, pszMsg, boReturn);
      end
      else
        boReturn := True; //返回 True 交给程序继续匹配
    end;
  end;
end;

procedure UserLoadAndSave(boLoad, boLoadFail, boRun, boGhost: Boolean; nDBIndex: Integer); stdcall;
begin
  if boLoadFail then begin
    ClearUserEMailByIndex(nDBIndex);
  end
  else if boLoad then begin
    LoadUserEMailByIndex(nDBIndex);
  end
  else if boRun then begin
    RunMsg();
  end else begin
    SaveUserEMailByIndex(nDBIndex);
    if boGhost then
      ClearUserEMailByIndex(nDBIndex);
  end;
  if Assigned(OLDUSERLOADANDSAVE) then begin //传递给下一个插件继续处理
    OLDUSERLOADANDSAVE(boLoad, boLoadFail, boRun, boGhost, nDBIndex);
  end;
end;

end.

