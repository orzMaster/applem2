unit EMailMain;

interface
uses
  Windows, SysUtils, Classes, Grobal2, EngineAPI, EMailDB, DateUtils;

type
  TEMailMsgType = (mt_Add, mt_Del);
  pTEMailUserInfo = ^TEMailUserInfo;
  TEMailUserInfo = packed record
    boChange: Boolean;
    EMailList: TList;
  end;

  pTEMailUserData = ^TEMailUserData;
  TEMailUserData = packed record
    nIndex: Integer;
    boChange: Boolean;
    EMailInfo: pTEMailInfo;
  end;

  pTEMailMsgInfo = ^TEMailMsgInfo;
  TEMailMsgInfo = packed record
    MsgType: TEMailMsgType;
    nDBIndex: Integer;
    nIndex: Integer;
    EMailInfo: pTEMailInfo;
  end;

procedure Lock();
procedure UnLock();

procedure ClearUserEMailByIndex(nDBIndex: Integer);
procedure LoadUserEMailByIndex(nDBIndex: Integer);
procedure SaveUserEMailByIndex(nDBIndex: Integer);
procedure RunMsg();

var

  EMAIL_CS: TRTLCriticalSection;
  m_UserList: array[0..PLAYOBJECTINDEXCOUNT - 1] of pTEMailUserInfo;
  m_MsgList: TList;
  m_TempMsgList: TList;

implementation

procedure SaveUserEMailByIndex(nDBIndex: Integer);
var
  SaveList: TList;
  I: integer;
  EMailUserData: pTEMailUserData;
begin
  try
    SaveList := TList.Create;
    try
      Lock;
      try
        if (nDBIndex > 0) and (nDBIndex < PLAYOBJECTINDEXCOUNT) then begin
          if (m_UserList[nDBIndex] <> nil) and (m_UserList[nDBIndex].boChange) then begin
            for I := 0 to m_UserList[nDBIndex].EMailList.Count - 1 do begin
              EMailUserData := m_UserList[nDBIndex].EMailList[i];
              if EMailUserData.boChange then begin
                EMailUserData.boChange := False;
                SaveList.Add(EMailUserData);
              end;
            end;
          end;
        end;
      finally
        UnLock;
      end;
      if SaveList.Count > 0 then begin
        try
          FileEMailDB.Open;
          for I := 0 to SaveList.Count - 1 do begin
            EMailUserData := SaveList[i];
            FileEMailDB.Update(EMailUserData.nIndex, EMailUserData.EMailInfo);
          end;
        finally
          FileEMailDB.Close;
        end;
      end;
    finally
      SaveList.Free;
    end;
  except
    on E: Exception do begin
      MainOutMessage(PChar(E.Message));
      MainOutMessage('[Exception] zPlugOfEMail.SaveUserEMailByIndex');
    end;
  end;
end;

procedure LoadUserEMailByIndex(nDBIndex: Integer);
var
  I, nIdx: integer;
  EMailInfo: pTEMailInfo;
  EMailUserInfo: pTEMailUserInfo;
  EMailUserData: pTEMailUserData;
  dTime: TDateTime;
begin
  try
    ClearUserEMailByIndex(nDBIndex);
    if (nDBIndex > 0) and (nDBIndex < PLAYOBJECTINDEXCOUNT) then begin
      EMailUserInfo := nil;
      try
        FileEMailDB.Open;
        if (FileEMailDB.m_UserIndex[nDBIndex] <> nil) then begin
          New(EMailUserInfo);
          EMailUserInfo.boChange := False;
          EMailUserInfo.EMailList := TList.Create;
          dTime := now;
          for I := FileEMailDB.m_UserIndex[nDBIndex].Count - 1 downto 0 do begin
            nIdx := Integer(FileEMailDB.m_UserIndex[nDBIndex][i]);
            EMailInfo := FileEMailDB.Get(nIdx);
            if (EMailInfo <> nil) then begin
              if (DaysBetween(dTime, EMailInfo.Header.dCreateTime) >= MAXEMAILTIME) then begin
                EMailInfo.Header.boDelete := True;
                FileEMailDB.Update(nIdx, EMailInfo);
                FileEMailDB.m_UserIndex[nDBIndex].Delete(i);
                FileEMailDB.m_DeleteList.Add(Pointer(nIdx));
                Dispose(EMailInfo);
                Continue;
              end;
              New(EMailUserData);
              EMailUserData.nIndex := nIdx;
              EMailUserData.boChange := False;
              EMailUserData.EMailInfo := EMailInfo;
              EMailUserInfo.EMailList.Add(EMailUserData);
            end;
          end;
          if FileEMailDB.m_UserIndex[nDBIndex].Count <= 0 then begin
            FileEMailDB.m_UserIndex[nDBIndex].Free;
            FileEMailDB.m_UserIndex[nDBIndex] := nil;
          end;

          if EMailUserInfo.EMailList.Count <= 0 then begin
            EMailUserInfo.EMailList.Free;
            Dispose(EMailUserInfo);
            EMailUserInfo := nil;
          end;
        end;
      finally
        FileEMailDB.Close;
      end;
      Lock;
      try
        m_UserList[nDBIndex] := EMailUserInfo;
      finally
        UnLock;
      end;
    end;
  except
    on E: Exception do begin
      MainOutMessage(PChar(E.Message));
      MainOutMessage('[Exception] zPlugOfEMail.LoadUserEMailByIndex');
    end;
  end;
end;

procedure ClearUserEMailByIndex(nDBIndex: Integer);
var
  i: integer;
  EMailUserInfo: pTEMailUserInfo;
  EMailUserData: pTEMailUserData;
begin
  try
    if (nDBIndex > 0) and (nDBIndex < PLAYOBJECTINDEXCOUNT) then begin
      Lock;
      try
        EMailUserInfo := m_UserList[nDBIndex];
        m_UserList[nDBIndex] := nil;
      finally
        UnLock;
      end;
      if EMailUserInfo <> nil then begin
        for i := 0 to EMailUserInfo.EMailList.Count - 1 do begin
          EMailUserData := EMailUserInfo.EMailList[i];
          Dispose(EMailUserData.EMailInfo);
          Dispose(EMailUserData);
        end;
        EMailUserInfo.EMailList.Free;
        Dispose(EMailUserInfo);
      end;
    end;
  except
    on E: Exception do begin
      MainOutMessage(PChar(E.Message));
      MainOutMessage('[Exception] zPlugOfEMail.ClearUserEMailByIndex');
    end;
  end;
end;

procedure RunMsg();
var
  TempList: TList;
  i, nIndex: Integer;
  EMailMsgInfo: pTEMailMsgInfo;
  SendObject, PlayObject: TObject;
  EMailUserData: pTEMailUserData;
  ClientEMailHeader: TClientEMailHeader;
//  str: string;
begin
  try
    Lock;
    try
      TempList := m_MsgList;
      m_MsgList := m_TempMsgList;
      m_TempMsgList := TempList;
    finally
      UnLock;
    end;
    if m_TempMsgList.Count <= 0 then exit;
    try
      FileEMailDB.Open;
      for I := 0 to m_TempMsgList.Count - 1 do begin
        EMailMsgInfo := m_TempMsgList[i];
        case EMailMsgInfo.MsgType of
          mt_Add: begin
              SendObject := TPlayObject_GetLoginPlay(EMailMsgInfo.nIndex);
              PlayObject := TPlayObject_GetLoginPlay(EMailMsgInfo.nDBIndex);
              if (EMailMsgInfo.nDBIndex > 0) and
                (EMailMsgInfo.nDBIndex < PLAYOBJECTINDEXCOUNT) and
                (FileEMailDB.m_UserIndex[EMailMsgInfo.nDBIndex] <> nil) and
                (FileEMailDB.m_UserIndex[EMailMsgInfo.nDBIndex].Count >= MAXEMAILCOUNT) then begin
                if (SendObject <> nil) and (not TBaseObject_boGhost(SendObject)^) then begin
                  if TPlayObject_IncGold(SendObject, SENDMAILMONEY) then begin
                    TBaseObject_GoldChanged(SendObject);

                    if GetGameLogGold()^ then begin
                      AddgameDataLog(SendObject, LOG_GOLDCHANGED, sSTRING_GOLDNAME, 0, TBaseObject_nGold(SendObject)^,
                        '信件', '+', PChar(IntToStr(SENDMAILMONEY)), '信件');
                    end;
                  end;
                  TBaseObject_SendDefMsg(SendObject, SendObject, SM_EMAIL, -3, 0, 0, 2, ''); //收件箱已满
                end;
                Dispose(EMailMsgInfo.EMailInfo);
                Continue;
              end;
              nIndex := FileEMailDB.Add(EMailMsgInfo.nDBIndex, EMailMsgInfo.EMailInfo);
              if nIndex > -1 then begin
                if (SendObject <> nil) and (not TBaseObject_boGhost(SendObject)^) then
                  TBaseObject_SendDefMsg(SendObject, SendObject, SM_EMAIL, 1, 0, 0, 2, ''); //发送成功
                if (PlayObject <> nil) and (EMailMsgInfo.nDBIndex > 0) and
                  (EMailMsgInfo.nDBIndex < PLAYOBJECTINDEXCOUNT) then begin
                  Lock;
                  try
                    if m_UserList[EMailMsgInfo.nDBIndex] = nil then begin
                      New(m_UserList[EMailMsgInfo.nDBIndex]);
                      m_UserList[EMailMsgInfo.nDBIndex].EMailList := TList.Create;
                    end;
                    New(EMailUserData);
                    EMailUserData.nIndex := nIndex;
                    EMailUserData.boChange := False;
                    EMailUserData.EMailInfo := EMailMsgInfo.EMailInfo;
                    ClientEMailHeader.nIdx := m_UserList[EMailMsgInfo.nDBIndex].EMailList.Add(EMailUserData);
                    ClientEMailHeader.sTitle := EMailMsgInfo.EMailInfo.sTitle;
                    ClientEMailHeader.sSendName := EMailMsgInfo.EMailInfo.sSendName;
                    ClientEMailHeader.dSendTime := EMailMsgInfo.EMailInfo.Header.dCreateTime;
                    ClientEMailHeader.boRead := EMailMsgInfo.EMailInfo.Header.boRead;
                    ClientEMailHeader.btTime := MAXEMAILTIME;
                    TBaseObject_SendDefSocket(PlayObject, PlayObject, SM_EMAIL, 2, 0, 0, 2,
                      PChar(EncodeBuffer(@ClientEMailHeader, SizeOf(ClientEMailHeader))));  //收件人接收信件

                  finally
                    UnLock;
                  end;
                end;
              end
              else begin
                if (SendObject <> nil) and (not TBaseObject_boGhost(SendObject)^) then begin
                  if TPlayObject_IncGold(SendObject, SENDMAILMONEY) then begin
                    TBaseObject_GoldChanged(SendObject);
                    if GetGameLogGold()^ then begin
                      AddgameDataLog(SendObject, LOG_GOLDCHANGED, sSTRING_GOLDNAME, 0, TBaseObject_nGold(SendObject)^,
                        '信件', '+', PChar(IntToStr(SENDMAILMONEY)), '信件');
                    end;
                  end;
                  TBaseObject_SendDefMsg(SendObject, SendObject, SM_EMAIL, -4, 0, 0, 2, ''); //系统错误,发送失败
                end;
                Dispose(EMailMsgInfo.EMailInfo);
              end;
            end;
          mt_Del: begin
              FileEMailDB.Del(EMailMsgInfo.nDBIndex, EMailMsgInfo.nIndex);
            end;
        end;
        Dispose(EMailMsgInfo);
      end;
    finally
      m_TempMsgList.Clear;
      FileEMailDB.Close;
    end;
  except
    on E: Exception do begin
      MainOutMessage(PChar(E.Message));
      MainOutMessage('[Exception] zPlugOfEMail.RunMsg');
    end;
  end;
end;

procedure Lock();
begin
  EnterCriticalSection(EMAIL_CS);
end;

procedure UnLock();
begin
  LeaveCriticalSection(EMAIL_CS);
end;

end.

