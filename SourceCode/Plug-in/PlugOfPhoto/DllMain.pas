unit DllMain;

interface
uses
  Windows, Classes, EngineAPI, EngineType, SysUtils;

Type
  pTUserPhotoInfo = ^TUserPhotoInfo;
  TUserPhotoInfo = packed record
    boChange: Boolean;
    nLen: Integer;
    PhotoBuff: PChar;
    LoadTime: TDateTime;
  end;

procedure LoadPlug();
procedure UnLoadPlug(boExit: Boolean);
procedure Lock();
procedure UnLock();
procedure ClearUserPhotoInfo(nDBIndex: Integer);
procedure LoadUserPhotoInfo(nDBIndex: Integer);
procedure SaveUserPhotoInfo(nDBIndex: Integer);
procedure IsUpLoadPhoto(PlayObject: TObject);
procedure UserUpLoadPhoto(PlayObject: TObject; nSize: Integer; sBody: String);
procedure UserGetPhoto(PlayObject: TObject);
procedure UserGetPhoto2(PlayObject: TObject);


procedure APIUserLoginEnd(PlayObject: TObject); stdcall;
function PlayObjectOperateMessage(BaseObject: TObject; wIdent: Word; wParam: Word;
  nParam1: Integer; nParam2: Integer; nParam3: Integer; MsgObject: TObject;
  dwDeliveryTime: LongWord; pszMsg: PChar; var boReturn: Boolean): Boolean; stdcall;
procedure UserLoadAndSave(boLoad, boLoadFail, boRun, boGhost: Boolean; nDBIndex: Integer); stdcall;


var
  OLDUSERLOGINEND: _TOBJECTACTION;
  OLDPLAYOBJECTOPERATEMESSAGE: _TOBJECTOPERATEMESSAGE;
  OLDUSERLOADANDSAVE: _TOBJECTUSERLOADANDSAVE;

implementation
uses
  Grobal2, Hutil32, DateUtils, ImageHlp, MD5Unit;

Const
  FilePostfix = '.jpg';
  UpLoadTick = 72; //上传间隔小时
  UpLoadLevel = 40; //上传最小等级
  
var
  m_UserList: array[0..PLAYOBJECTINDEXCOUNT - 1] of pTUserPhotoInfo;
  PHOTO_CS: TRTLCriticalSection;
  PhotoDir: String;


procedure LoadPlug();
begin
  InitializeCriticalSection(PHOTO_CS);
  FillChar(m_UserList, SizeOf(m_UserList), #0);
  PhotoDir := GetUserDataDir()^ + 'UserPhoto\';
  MakeSureDirectoryPathExists(PChar(PhotoDir));

  OLDUSERLOGINEND := TPlayObject_GetHookUserLoginStart();
  TPlayObject_SetHookUserLoginStart(APIUserLoginEnd);

  OLDPLAYOBJECTOPERATEMESSAGE := TPlayObject_GetHookPlayOperateMessage();
  TPlayObject_SetHookPlayOperateMessage(PlayObjectOperateMessage);

  OLDUSERLOADANDSAVE := API_GetHookUserLoadAndSave();
  API_SetHookUserLoadAndSave(UserLoadAndSave);
end;

procedure UnLoadPlug(boExit: Boolean);
var
  i: integer;
begin
  if not boExit then begin
    if not API_UnModule(MODULE_USERLOGINSTART, @APIUserLoginEnd, @OLDUSERLOGINEND) then
      TPlayObject_SetHookUserLoginStart(OLDUSERLOGINEND);

    if not API_UnModule(MODULE_PLAYOPERATEMESSAGE, @PlayObjectOperateMessage, @OLDPLAYOBJECTOPERATEMESSAGE) then
      TPlayObject_SetHookPlayOperateMessage(OLDPLAYOBJECTOPERATEMESSAGE);

    if not API_UnModule(MODULE_USERLOADANDSAVE, @UserLoadAndSave, @OLDUSERLOADANDSAVE) then
      API_SetHookUserLoadAndSave(OLDUSERLOADANDSAVE);
  end;

  Lock;
  try
    for i := Low(m_UserList) to High(m_UserList) do begin
      if m_UserList[i] <> nil then begin
        if (m_UserList[i].PhotoBuff <> nil) then begin
          if m_UserList[i].boChange then
            SaveUserPhotoInfo(i);
          FreeMem(m_UserList[i].PhotoBuff);
        end;
        Dispose(pTUserPhotoInfo(m_UserList[i]));
      end;
    end;
  finally
    UnLock;
  end;
  DeleteCriticalSection(PHOTO_CS);
end;

procedure IsUpLoadPhoto(PlayObject: TObject);
var
  nDBIndex: Integer;
  UpLoadTime: PDateTime;
  Ability: _LPTABILITY;
  SendMsg: string;
  nHours: Integer;
begin
  nDBIndex := TPlayObject_GetDBIndex(PlayObject);
  Ability := TBaseObject_Ability(PlayObject);
  if Ability.Level < UpLoadLevel then begin
    SendMsg := '等级必需大于' + IntToStr(UpLoadLevel) + '级(包含' + IntToStr(UpLoadLevel)  + '级)以上才能上传';
    TPlayObject_SendDefMessage(PlayObject, SM_UPLOADUSERPHOTO_FAIL, 0, 0, 0, 0, PChar(SendMsg));
    exit;
  end;
  if (nDBIndex > 0) and (nDBIndex < PLAYOBJECTINDEXCOUNT) then begin
    Lock;
    try
      if m_UserList[nDBIndex] <> nil then begin
        UpLoadTime := TPlayObject_dwUpLoadPhotoTime(PlayObject);
        m_UserList[nDBIndex].LoadTime := GetTickCount;
        nHours := HoursBetween(Now, UpLoadTime^);
        if nHours < UpLoadTick then begin
          SendMsg := '在' + IntToStr(UpLoadTick - nHours) + '小时之后才能再次上传';
          TPlayObject_SendDefMessage(PlayObject, SM_UPLOADUSERPHOTO_FAIL, 0, 0, 0, 0, PChar(SendMsg));
          exit;
        end;
      end;
    finally
      UnLock;
    end;
  end;
  TPlayObject_SendDefMessage(PlayObject, SM_UPLOADUSERPHOTO, 0, 0, 0, 0, '');
end;

procedure UserGetPhoto(PlayObject: TObject);
var
  nDBIndex: Integer;
  m_Msg: _TDEFAULTMESSAGE;
begin
  nDBIndex := TPlayObject_GetDBIndex(PlayObject);
  if (nDBIndex > 0) and (nDBIndex < PLAYOBJECTINDEXCOUNT) then begin
    Lock;
    try
      if (m_UserList[nDBIndex] <> nil) and (GetTickCount > m_UserList[nDBIndex].LoadTime) then begin
        m_UserList[nDBIndex].LoadTime := GetTickCount + 5000;
        if (m_UserList[nDBIndex].PhotoBuff <> nil) and (m_UserList[nDBIndex].nLen > 0) then begin
          m_Msg.Recog := m_UserList[nDBIndex].nLen;
          m_Msg.Ident := SM_UPLOADUSERPHOTO;
          m_Msg.Series := 2;
          TPlayObject_SendSocket(PlayObject, @m_Msg,
            PChar(EncodeBuffer(m_UserList[nDBIndex].PhotoBuff, m_UserList[nDBIndex].nLen)));
          exit;
        end;
        TPlayObject_SendDefMessage(PlayObject, SM_UPLOADUSERPHOTO_FAIL, 0, 0, 0, 0, '获取失败,没有照片数据.');
        exit;
      end;
      TPlayObject_SendDefMessage(PlayObject, SM_UPLOADUSERPHOTO_FAIL, 0, 0, 0, 0, '请勿超速操作');
    finally
      UnLock;
    end;
  end;
end;

procedure UserGetPhoto2(PlayObject: TObject);
var
  nLookDBIndex: Integer;
  PLookDBIndex: PInteger;
  m_Msg: _TDEFAULTMESSAGE;
begin
  PLookDBIndex := TPlayObject_GetLookIndex(PlayObject);
  nLookDBIndex := PLookDBIndex^;
  if (nLookDBIndex > 0) and (nLookDBIndex < PLAYOBJECTINDEXCOUNT) then begin
    Lock;
    try
      if (m_UserList[nLookDBIndex] <> nil)  and (m_UserList[nLookDBIndex].PhotoBuff <> nil) and
        (m_UserList[nLookDBIndex].nLen > 0) then begin
        m_Msg.Recog := m_UserList[nLookDBIndex].nLen;
        m_Msg.Ident := SM_UPLOADUSERPHOTO;
        m_Msg.Series := 3;
        PLookDBIndex^ := -1;
        TPlayObject_SendSocket(PlayObject, @m_Msg,
          PChar(EncodeBuffer(m_UserList[nLookDBIndex].PhotoBuff, m_UserList[nLookDBIndex].nLen)));
        exit;
      end;
      TPlayObject_SendDefMessage(PlayObject, SM_UPLOADUSERPHOTO_FAIL, 0, 0, 0, 0, '获取失败,没有照片数据.');
    finally
      UnLock;
    end;
  end;
end;

procedure UserUpLoadPhoto(PlayObject: TObject; nSize: Integer; sBody: String);
var
  nDBIndex: Integer;
  UpLoadTime: PDateTime;
  Ability: _LPTABILITY;
  SendMsg: string;
  nHours: Integer;
  sPhotoName: string;
begin
  if (nSize > 10000) or (nSize < 10) or (Length(sbody) <> GetCodeMsgSize(nSize * 4 / 3)) then Exit;
  nDBIndex := TPlayObject_GetDBIndex(PlayObject);
  Ability := TBaseObject_Ability(PlayObject);
  if Ability.Level < UpLoadLevel then begin
    SendMsg := '等级必需大于' + IntToStr(UpLoadLevel) + '级(包含' + IntToStr(UpLoadLevel)  + '级)以上才能上传';
    TPlayObject_SendDefMessage(PlayObject, SM_UPLOADUSERPHOTO_FAIL, 0, 0, 0, 0, PChar(SendMsg));
    exit;
  end;
  if (nDBIndex > 0) and (nDBIndex < PLAYOBJECTINDEXCOUNT) then begin
    Lock;
    try
      UpLoadTime := TPlayObject_dwUpLoadPhotoTime(PlayObject);
      if m_UserList[nDBIndex] <> nil then begin
        m_UserList[nDBIndex].LoadTime := GetTickCount;
        nHours := HoursBetween(Now, UpLoadTime^);
        if nHours < UpLoadTick then begin
          SendMsg := '在' + IntToStr(UpLoadTick - nHours) + '小时之后才能再次上传';
          TPlayObject_SendDefMessage(PlayObject, SM_UPLOADUSERPHOTO_FAIL, 0, 0, 0, 0, PChar(SendMsg));
          exit;
        end;
        if m_UserList[nDBIndex].PhotoBuff <> nil then
          FreeMem(m_UserList[nDBIndex].PhotoBuff);
        m_UserList[nDBIndex].PhotoBuff := nil;
        m_UserList[nDBIndex].boChange := True;
      end else begin
        New(m_UserList[nDBIndex]);
        m_UserList[nDBIndex].boChange := True;
        m_UserList[nDBIndex].nLen := 0;
        m_UserList[nDBIndex].PhotoBuff := nil;
        m_UserList[nDBIndex].LoadTime := GetTickCount;
      end;
      GetMem(m_UserList[nDBIndex].PhotoBuff, nSize);
      m_UserList[nDBIndex].nLen := nSize;
      DecodeBuffer(sBody, m_UserList[nDBIndex].PhotoBuff, nSize);
      SaveUserPhotoInfo(nDBIndex);
      UpLoadTime^ := Now;
      sPhotoName := GetMD5TextOf16(TBaseObject_sCharName(PlayObject)^ + DateTimeToStr(Now));
      TPlayObject_SetPhotoName(PlayObject, PChar(sPhotoName));
      TPlayObject_SendDefMessage(PlayObject, SM_UPLOADUSERPHOTO, 0, 0, 0, 1, PChar(sPhotoName));
    finally
      UnLock;
    end;
  end;
end;

procedure APIUserLoginEnd(PlayObject: TObject); stdcall;
var
  nDBIndex: Integer;
begin
  nDBIndex := TPlayObject_GetDBIndex(PlayObject);
  if (nDBIndex > 0) and (nDBIndex < PLAYOBJECTINDEXCOUNT) then begin
    Lock;
    try
      if m_UserList[nDBIndex] = nil then
        TPlayObject_SetPhotoName(PlayObject, '')
      else
        m_UserList[nDBIndex].LoadTime := GetTickCount;
    finally
      UnLock;
    end;
  end;
  //调用下一个插件处理
  if Assigned(OLDUSERLOGINEND) then
    OLDUSERLOGINEND(PlayObject);
end;

function PlayObjectOperateMessage(BaseObject: TObject; wIdent: Word; wParam: Word;
  nParam1: Integer; nParam2: Integer; nParam3: Integer; MsgObject: TObject;
  dwDeliveryTime: LongWord; pszMsg: PChar; var boReturn: Boolean): Boolean; stdcall;
begin
  Result := True; //该返回值暂时无作用
  boReturn := False; //返回 False 程序将不再匹配
  case wIdent of
    CM_SAVEUSERPHOTO: begin
        case wParam of
          0: IsUpLoadPhoto(BaseObject); //是否可以上传图像
          1: UserUpLoadPhoto(BaseObject, nParam1, pszMsg);
          2: UserGetPhoto(BaseObject);
          3: UserGetPhoto2(BaseObject);
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
    ClearUserPhotoInfo(nDBIndex);
  end
  else if boLoad then begin
    LoadUserPhotoInfo(nDBIndex);
  end
  else if boRun then begin
    //RunMsg();
  end else begin
    SaveUserPhotoInfo(nDBIndex);
    if boGhost then
      ClearUserPhotoInfo(nDBIndex);
  end;
  if Assigned(OLDUSERLOADANDSAVE) then begin //传递给下一个插件继续处理
    OLDUSERLOADANDSAVE(boLoad, boLoadFail, boRun, boGhost, nDBIndex);
  end;
end;

procedure ClearUserPhotoInfo(nDBIndex: Integer);
begin
  if (nDBIndex > 0) and (nDBIndex < PLAYOBJECTINDEXCOUNT) then begin
    Lock;
    try
      if m_UserList[nDBIndex] <> nil then begin
        if m_UserList[nDBIndex].PhotoBuff <> nil then
          FreeMem(m_UserList[nDBIndex].PhotoBuff);
        Dispose(m_UserList[nDBIndex]);
        m_UserList[nDBIndex] := nil;
      end;
    finally
      UnLock;
    end;
  end;
end;

procedure LoadUserPhotoInfo(nDBIndex: Integer);
var
  FileStream: TFileStream;
  FileName: string;
begin
  if (nDBIndex > 0) and (nDBIndex < PLAYOBJECTINDEXCOUNT) then begin
    Lock;
    try
      FileName := PhotoDir + IntToStr(nDBIndex) + FilePostfix;
      if FileExists(FileName) then begin
        FileStream := TFileStream.Create(FileName, fmOpenRead  or fmShareDenyNone);
        Try
        if m_UserList[nDBIndex] = nil then begin
          New(m_UserList[nDBIndex]);
          m_UserList[nDBIndex].boChange := False;
          m_UserList[nDBIndex].nLen := 0;
          m_UserList[nDBIndex].PhotoBuff := nil;
        end else begin
          if m_UserList[nDBIndex].PhotoBuff <> nil then
            FreeMem(m_UserList[nDBIndex].PhotoBuff);
        end;
          m_UserList[nDBIndex].nLen := FileStream.Size;
          GetMem(m_UserList[nDBIndex].PhotoBuff, m_UserList[nDBIndex].nLen);
          FileStream.Read(m_UserList[nDBIndex].PhotoBuff^, m_UserList[nDBIndex].nLen);
        Finally
          FileStream.Free;
        End;
      end else begin
        if m_UserList[nDBIndex] <> nil then begin
          if m_UserList[nDBIndex].PhotoBuff <> nil then
            FreeMem(m_UserList[nDBIndex].PhotoBuff);
          Dispose(m_UserList[nDBIndex]);
          m_UserList[nDBIndex] := nil;
        end;
      end;
    finally
      UnLock;
    end;
  end;
end;

procedure SaveUserPhotoInfo(nDBIndex: Integer);
var
  FileStream: TFileStream;
  FileName: string;
begin
  if (nDBIndex > 0) and (nDBIndex < PLAYOBJECTINDEXCOUNT) then begin
    Lock;
    try
      if (m_UserList[nDBIndex] <> nil) and (m_UserList[nDBIndex].PhotoBuff <> nil) and (m_UserList[nDBIndex].boChange)
      then begin
        FileName := PhotoDir + IntToStr(nDBIndex) + FilePostfix;
        if FileExists(FileName) then
          DeleteFile(FileName);
        FileStream := TFileStream.Create(FileName, fmCreate);
        Try
          FileStream.Write(m_UserList[nDBIndex].PhotoBuff^, m_UserList[nDBIndex].nLen);
          m_UserList[nDBIndex].boChange := False;
        Finally
          FileStream.Free;
        End;
      end;

    finally
      UnLock;
    end;
  end;
end;

procedure Lock();
begin
  EnterCriticalSection(PHOTO_CS);
end;

procedure UnLock();
begin
  LeaveCriticalSection(PHOTO_CS);
end;


end.
