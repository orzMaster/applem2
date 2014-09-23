unit EMailDB;

interface

uses
  Windows, SysUtils, Classes, Grobal2, DateUtils;

Resourcestring
  sDBHeaderDesc = '信件系统数据库文件 2009/03/26';
  sDBIdxHeaderDesc = '信件系统数据库索引文件 2006/03/26';

Const
  MAXEMAILCOUNT = 30;
  MAXEMAILTIME = 15;
  SENDMAILMONEY = 2000;

type
  pTDBHeader = ^TDBHeader;
  TDBHeader = packed record
    sDesc: string[$23];
    nLastIndex: Integer;
    dLastDate: TDateTime;
    nCount: Integer;
    dUpdateDate: TDateTime;
  end;

  TEMailHeaderInfo = packed record
    boDelete: Boolean;
    boRead: Boolean;
    dCreateTime: TDateTime;
    nReadIndex: Integer;
  end;

  TDBIdxInfo = packed record
    boDelete: Boolean;
    nDBIndex: integer;
    nUserIndex: Integer;
  end;

  pTEMailInfo = ^TEMailInfo;
  TEMailInfo = packed record
    Header: TEMailHeaderInfo;
    boSystem: Boolean;
    sReadName: string[ActorNameLen];
    sSendName: string[ActorNameLen];
    sTitle: string[22];
    TextLen: Word;
    Text: array[0..400] of char;
  end;

  TFileEMailDB = class
    m_Header: TDBHeader;
    m_nLastIndex: Integer; //0x1C
    m_dUpdateTime: TDateTime;
    m_nFileHandle: Integer;
    m_sDBFileName: string; //0xAC
    m_sIdxFileName: string; //0xB0
    m_DeleteList: TList;
    m_UserIndex: array[0..PLAYOBJECTINDEXCOUNT - 1] of TList;
  private
    DB_CS: TRTLCriticalSection;
    procedure ClearUserIndexList;
//    function LoadDBIndex: Boolean;
    procedure LoadQuickList;
//    procedure SaveIndex();
    function AddUserInfoToList(nUserIndex, nDBIndex: integer): Boolean;
  public
    constructor Create(sFileName: string);
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
    function Open(): Boolean;
    procedure Close();
    function Count(): Integer;
    function UserCount(): Integer;
    function Get(nIndex: Integer): pTEMailInfo;
    function Update(nIndex: Integer; EMailInfo: pTEMailInfo): Boolean;
    function Add(nDBIndex: Integer; EMailInfo: pTEMailInfo): Integer;
    function Del(nDBIndex, nIndex: Integer): Boolean;
  end;

var
  FileEMailDB: TFileEMailDB;

implementation

{ TFileEMailDB }

constructor TFileEMailDB.Create(sFileName: string);
begin
  inherited Create;
  InitializeCriticalSection(DB_CS);
  FillChar(m_UserIndex, SizeOf(m_UserIndex), #0);
  m_sDBFileName := sFileName;
  m_sIdxFileName := sFileName + '.idx';
  m_DeleteList := TList.Create;
  m_nLastIndex := -1;
  //if not LoadDBIndex then
  LoadQuickList();
end;

destructor TFileEMailDB.Destroy;
begin
//  SaveIndex;
  ClearUserIndexList;
  m_DeleteList.Free;
  DeleteCriticalSection(DB_CS);
  inherited;
end;

function TFileEMailDB.Get(nIndex: Integer): pTEMailInfo;
begin
  Result := nil;
  if FileSeek(m_nFileHandle, nIndex * SizeOf(TEMailInfo) + SizeOf(TDBHeader), 0) <> -1 then begin
    New(Result);
    FileRead(m_nFileHandle, Result^, SizeOf(TEMailInfo));
  end;
end;

{
function TFileEMailDB.LoadDBIndex: Boolean;
var
  nIdxFileHandle: Integer;
  IdxHeader: TDBHeader;
  DBHeader: TDBHeader;
  EMailRecord: TEMailInfo;
  IdxRecord: TDBIdxInfo;
  i: Integer;
begin
  Result := False;
  nIdxFileHandle := 0;
  ClearUserIndexList;
  m_DeleteList.Clear;
  FillChar(IdxHeader, SizeOf(IdxHeader), #0);
  if FileExists(m_sIdxFileName) then nIdxFileHandle := FileOpen(m_sIdxFileName, fmOpenReadWrite or fmShareDenyNone);
  if nIdxFileHandle > 0 then begin
    Result := True;
    FileRead(nIdxFileHandle, IdxHeader, SizeOf(IdxHeader));
    try
      if Open then begin
        FileSeek(m_nFileHandle, 0, 0);
        if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
          if IdxHeader.nCount <> DBHeader.nCount then
            Result := False;
          if IdxHeader.sDesc <> sDBIdxHeaderDesc then
            Result := False;
          if IdxHeader.nLastIndex <> DBHeader.nLastIndex then
            Result := False;
        end;
        if IdxHeader.nLastIndex > -1 then begin
          FileSeek(m_nFileHandle, IdxHeader.nLastIndex * SizeOf(TEMailInfo) + SizeOf(TDBHeader), 0);
          if FileRead(m_nFileHandle, EMailRecord, SizeOf(TEMailInfo)) = SizeOf(TEMailInfo) then
            if IdxHeader.dUpdateDate <> EMailRecord.Header.dUpdateDate then
              Result := False;
        end;
      end;
    finally
      Close;
    end;
    if Result then begin
      m_nLastIndex := IdxHeader.nLastIndex;
      m_dUpdateTime := IdxHeader.dUpdateDate;
      for i := 0 to IdxHeader.nCount - 1 do begin
        if FileRead(nIdxFileHandle, IdxRecord, SizeOf(TDBIdxInfo)) = SizeOf(TDBIdxInfo) then begin
          if IdxRecord.boDelete then begin
            m_DeleteList.Add(Pointer(IdxRecord.nDBIndex));
          end else
          if not AddUserInfoToList(IdxRecord.nUserIndex, IdxRecord.nDBIndex) then begin
            Result := False;
            break;
          end;
        end
        else begin
          Result := False;
          break;
        end;
      end;
    end; //0048ACC5
    FileClose(nIdxFileHandle);
  end;
end;
         }
procedure TFileEMailDB.LoadQuickList;
var
  DBHeader: TDBHeader;
  i: integer;
  RecordHeader: TEMailInfo;
  dTime: TDateTime;
begin
  ClearUserIndexList;
  m_DeleteList.Clear;
  try
    if Open then begin
      FileSeek(m_nFileHandle, 0, 0);
      if FileRead(m_nFileHandle, DBHeader, SizeOf(TDBHeader)) = SizeOf(TDBHeader) then begin
        m_nLastIndex := DBHeader.nLastIndex;
        m_dUpdateTime := DBHeader.dLastDate;
        dTime := Now;
        for i := 0 to DBHeader.nCount - 1 do begin
          if FileRead(m_nFileHandle, RecordHeader, SizeOf(TEMailInfo)) <> SizeOf(TEMailInfo) then break;
          if (not RecordHeader.Header.boDelete) and
            (DaysBetween(dTime, RecordHeader.Header.dCreateTime) < MAXEMAILTIME) then begin
            AddUserInfoToList(RecordHeader.Header.nReadIndex, I);
          end
          else begin
            m_DeleteList.Add(Pointer(i));
          end;
        end;
      end;
    end;
  finally
    Close;
  end;
end;

procedure TFileEMailDB.Lock;
begin
  EnterCriticalSection(DB_CS);
end;

procedure TFileEMailDB.UnLock;
begin
  LeaveCriticalSection(DB_CS);
end;


function TFileEMailDB.Update(nIndex: Integer; EMailInfo: pTEMailInfo): Boolean;
var
  nPosion: Integer;
begin
  Result := False;
  nPosion := nIndex * SizeOf(TEMailInfo) + SizeOf(TDBHeader);
  if FileSeek(m_nFileHandle, nPosion, 0) = nPosion then begin
    m_nLastIndex := nIndex;
    m_dUpdateTime := Now;
    FileWrite(m_nFileHandle, EMailInfo^, SizeOf(TEMailInfo));
    FileSeek(m_nFileHandle, 0, 0);
    m_Header.nLastIndex := nIndex;
    m_Header.dLastDate := m_dUpdateTime;
    m_Header.dUpdateDate := m_dUpdateTime;
    FileWrite(m_nFileHandle, m_Header, SizeOf(TDBHeader));
    Result := True;
  end;
end;

function TFileEMailDB.Del(nDBIndex, nIndex: Integer): Boolean;
var
  I: Integer;
  Header: TEMailHeaderInfo;
  nPosion: Integer;
begin
  Result := False;
  if (nDBIndex > 0) and (nDBIndex < PLAYOBJECTINDEXCOUNT) then begin
    if (m_UserIndex[nDBIndex] <> nil) then begin
      for I := 0 to m_UserIndex[nDBIndex].Count - 1 do begin
        if nIndex = Integer(m_UserIndex[nDBIndex][i]) then begin
          Header.boDelete := True;
          Header.dCreateTime := Now;
          nPosion := nIndex * SizeOf(TEMailInfo) + SizeOf(TDBHeader);
          if FileSeek(m_nFileHandle, nPosion, 0) = nPosion then begin
            FileWrite(m_nFileHandle, Header, SizeOf(Header));
            m_UserIndex[nDBIndex].Delete(I);
            Result := True;
          end;
          break;
        end;
      end;
      if m_UserIndex[nDBIndex].Count <= 0 then
        FreeAndNil(m_UserIndex[nDBIndex]);
    end;
  end;
end;


function TFileEMailDB.Add(nDBIndex: Integer; EMailInfo: pTEMailInfo): Integer;
var
  nIdx: Integer;
begin
  Result := -1;
  if (nDBIndex > 0) and (nDBIndex < PLAYOBJECTINDEXCOUNT) then begin
    if m_DeleteList.Count > 0 then begin
      nIdx := Integer(m_DeleteList.Items[0]);
      m_DeleteList.Delete(0);
    end
    else begin
      nIdx := m_Header.nCount;
      Inc(m_Header.nCount);
    end;
    if Update(nIdx, EMailInfo) then begin
      if m_UserIndex[nDBIndex] = nil then m_UserIndex[nDBIndex] := TList.Create;
      m_UserIndex[nDBIndex].Add(Pointer(nIdx));
      Result := nIdx;
    end;
  end;
end;

function TFileEMailDB.UserCount: Integer;
var
  i: integer;
begin
  Result := 0;
  for I := Low(m_UserIndex) to High(m_UserIndex) do begin
    if m_UserIndex[i] <> nil then Inc(Result, m_UserIndex[i].Count)
  end;
end;

function TFileEMailDB.Open: Boolean;
begin
  Lock();
  if FileExists(m_sDBFileName) then begin
    m_nFileHandle := FileOpen(m_sDBFileName, fmOpenReadWrite or fmShareDenyNone);
    if m_nFileHandle > 0 then
      FileRead(m_nFileHandle, m_Header, SizeOf(TDBHeader));
  end
  else begin
    m_nFileHandle := FileCreate(m_sDBFileName);
    if m_nFileHandle > 0 then begin
      m_Header.sDesc := sDBHeaderDesc;
      m_Header.nCount := 0;
      m_Header.nLastIndex := -1;
      m_Header.dLastDate := now;
      m_Header.dUpdateDate := now;
      FileWrite(m_nFileHandle, m_Header, SizeOf(TDBHeader));
    end;
  end;
  if m_nFileHandle > 0 then Result := True
  else Result := False;
end;
{
procedure TFileEMailDB.SaveIndex;
var
  IdxHeader: TDBHeader;
  nIdxFileHandle: Integer;
  i, ii: Integer;
  IdxRecord: TDBIdxInfo;
begin
  FillChar(IdxHeader, SizeOf(TDBHeader), #0);
  IdxHeader.sDesc := sDBIdxHeaderDesc;
  IdxHeader.nCount := m_Header.nCount;
  IdxHeader.nLastIndex := m_nLastIndex;
  IdxHeader.dUpdateDate := m_dUpdateTime;
  if FileExists(m_sIdxFileName) then
    nIdxFileHandle := FileOpen(m_sIdxFileName, fmOpenReadWrite or fmShareDenyNone)
  else
    nIdxFileHandle := FileCreate(m_sIdxFileName);

  if nIdxFileHandle > 0 then begin
    FileWrite(nIdxFileHandle, IdxHeader, SizeOf(TDBHeader));
    for I := Low(m_UserIndex) to High(m_UserIndex) do begin
      if m_UserIndex[i] <> nil then begin
        for ii := 0 to m_UserIndex[i].Count - 1 do begin
          IdxRecord.boDelete := False;
          IdxRecord.nDBIndex := Integer(m_UserIndex[i][ii]);
          IdxRecord.nUserIndex := i;
          FileWrite(nIdxFileHandle, IdxRecord, SizeOf(TDBIdxInfo));
        end;
      end;
    end;
    for i := 0 to m_DeleteList.Count - 1 do begin
      IdxRecord.boDelete := True;
      IdxRecord.nDBIndex := Integer(m_DeleteList[i]);
      IdxRecord.nUserIndex := 0;
      FileWrite(nIdxFileHandle, IdxRecord, SizeOf(TDBIdxInfo));
    end;
    FileClose(nIdxFileHandle);
  end;
end;    }

function TFileEMailDB.AddUserInfoToList(nUserIndex, nDBIndex: integer): Boolean;
begin
  Result := False;
  if (nUserIndex > 0) and (nUserIndex < PLAYOBJECTINDEXCOUNT) then begin
    if m_UserIndex[nUserIndex] = nil then  m_UserIndex[nUserIndex] := TList.Create;
    m_UserIndex[nUserIndex].Add(Pointer(nDBIndex));
    Result := True;
  end;
end;

procedure TFileEMailDB.ClearUserIndexList;
var
  i: integer;
begin
  for I := Low(m_UserIndex) to High(m_UserIndex) do begin
    if m_UserIndex[i] <> nil then begin
      m_UserIndex[i].Free;
      m_UserIndex[i] := nil;
    end;
  end;
end;

procedure TFileEMailDB.Close;
begin
  FileClose(m_nFileHandle);
  UnLock();
end;

function TFileEMailDB.Count: Integer;
begin
  Result := m_Header.nCount;
end;

end.
