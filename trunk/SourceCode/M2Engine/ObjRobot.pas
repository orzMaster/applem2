unit ObjRobot;

interface
uses
  Windows, Classes, SysUtils, DateUtils, ObjBase, Grobal2, ObjPlay;
const
  sROAUTORUN = '#AUTORUN';

  sRONPCLABLEJMP = 'NPC';
  nRONPCLABLEJMP = 100;

  sRODAY = 'DAY';
  nRODAY = 200;
  sROHOUR = 'HOUR';
  nROHOUR = 201;
  sROMIN = 'MIN';
  nROMIN = 202;
  sROSEC = 'SEC';
  nROSEC = 203;
  sRUNONWEEK = 'RUNONWEEK'; //指定星期几运行
  nRUNONWEEK = 300;
  sRUNONDAY = 'RUNONDAY'; //指定几日运行
  nRUNONDAY = 301;
  sRUNONHOUR = 'RUNONHOUR'; //指定小时运行
  nRUNONHOUR = 302;
  sRUNONMIN = 'RUNONMIN'; //指定分钟运行
  nRUNONMIN = 303;
  sRUNONSEC = 'RUNONSEC'; //指定秒运行
  nRUNONSEC = 304;
  sRUNDATETIME = 'RUNDATETIME'; //指定时间运行，只运行一次
  nRUNDATETIME = 305;

type
  TOpType = (o_NPC);
  TAutoRunInfo = record
    dwRunTick: LongWord; //上一次运行时间记录
    dwRunTimeLen: LongWord; //运行间隔时间长
    nRunCmd: Integer; //自动运行类型
    nMoethod: Integer;
    sParam1: string; //运行脚本标签
    sParam2: string; //传送到脚本参数内容
    sParam3: string;
    sParam4: string;
    nParam1: Integer;
    nParam2: Integer;
    nParam3: Integer;
    nParam4: Integer;
    boStatus: Boolean;
    m_nWeek: Integer;
    m_nYear: Integer;
    m_nMonth: Integer;
    m_nDay: Integer;
    m_nHour: Integer;
    m_nMin: Integer;
    m_nSec: Integer;
  end;
  pTAutoRunInfo = ^TAutoRunInfo;
  TRobotObject = class(TPlayObject)
    m_sScriptFileName: string;
    m_AutoRunList: TList;


    function GetNPCLabelIdx(sLabel: string): Integer;
  private
    procedure LoadScript();
    procedure ClearScript();
    procedure ProcessAutoRun();
    procedure AutoRun(AutoRunInfo: pTAutoRunInfo);
    procedure AutoRunOfOnWeek(AutoRunInfo: pTAutoRunInfo);
    procedure AutoRunOfOnDay(AutoRunInfo: pTAutoRunInfo);
    procedure AutoRunOfOnHour(AutoRunInfo: pTAutoRunInfo);
    procedure AutoRunOfOnMin(AutoRunInfo: pTAutoRunInfo);
    procedure AutoRunOfOnSec(AutoRunInfo: pTAutoRunInfo);
    procedure AutoRunOfDateTime(AutoRunInfo: pTAutoRunInfo);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure SendSocket(DefMsg: pTDefaultMessage; sMsg: string); override;
    procedure ReloadScript();
    procedure Run(); override;
    procedure ScriptRun();
  end;
  TRobotManage = class
    RobotHumanList: TStringList;
  private

    procedure UnLoadRobot();
  public
    constructor Create();
    procedure LoadRobot();
    destructor Destroy; override;
    procedure RELOADROBOT();
    procedure Run;
  end;
implementation

uses M2Share, HUtil32, ObjNpc;

{ TRobotObject }

procedure TRobotObject.AutoRun(AutoRunInfo: pTAutoRunInfo);
begin
  if (g_RobotNPC = nil) or (AutoRunInfo = nil) then begin
    Exit;
  end;
  if GetTickCount - AutoRunInfo.dwRunTick > AutoRunInfo.dwRunTimeLen then begin
    case AutoRunInfo.nRunCmd of //
      nRONPCLABLEJMP: begin
          case AutoRunInfo.nMoethod of //
            nRODAY: begin
                if GetTickCount >= AutoRunInfo.dwRunTick then begin
                  AutoRunInfo.dwRunTick := GetTickCount() + 24 * 60 * 60 * 1000 * LongWord(AutoRunInfo.nParam1);
                  g_RobotNPC.GotoLable(Self, AutoRunInfo.nParam2, False);
                end;
              end;
            nROHOUR: begin
                if GetTickCount >= AutoRunInfo.dwRunTick then begin
                  AutoRunInfo.dwRunTick := GetTickCount() + 60 * 60 * 1000 * LongWord(AutoRunInfo.nParam1);
                  g_RobotNPC.GotoLable(Self, AutoRunInfo.nParam2, False);
                end;
              end;
            nROMIN: begin
                if GetTickCount >= AutoRunInfo.dwRunTick then begin
                  AutoRunInfo.dwRunTick := GetTickCount() + 60 * 1000 * LongWord(AutoRunInfo.nParam1);
                  g_RobotNPC.GotoLable(Self, AutoRunInfo.nParam2, False);
                end;
              end;
            nROSEC: begin
                if GetTickCount >= AutoRunInfo.dwRunTick then begin
                  AutoRunInfo.dwRunTick := GetTickCount() + 1000 * LongWord(AutoRunInfo.nParam1);
                  g_RobotNPC.GotoLable(Self, AutoRunInfo.nParam2, False);
                end;
              end;
            nRUNONWEEK: AutoRunOfOnWeek(AutoRunInfo);
            nRUNONDAY: AutoRunOfOnDay(AutoRunInfo);
            nRUNONHOUR: AutoRunOfOnHour(AutoRunInfo);
            nRUNONMIN: AutoRunOfOnMin(AutoRunInfo);
            nRUNONSEC: AutoRunOfOnSec(AutoRunInfo);
            nRUNDATETIME: AutoRunOfDateTime(AutoRunInfo);
          end; // case
        end;
      1: ;
      2: ;
      3: ;
    end; // case
  end;
end;

procedure TRobotObject.AutoRunOfDateTime(AutoRunInfo: pTAutoRunInfo);
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
  if not AutoRunInfo.boStatus then begin
    if GetTickCount > AutoRunInfo.dwRunTick then begin
      AutoRunInfo.dwRunTick := GetTickCount + 2000;
      DecodeDate(Now, Year, Month, Day);
      if (AutoRunInfo.m_nYear = Year) and (AutoRunInfo.m_nMonth = Month) and (AutoRunInfo.m_nDay = Day) then begin
        DecodeTime(Time, Hour, Min, Sec, MSec);
        if (AutoRunInfo.m_nHour = Hour) and (AutoRunInfo.m_nMin = Min) then begin
          AutoRunInfo.boStatus := True;
          g_RobotNPC.GotoLable(Self, AutoRunInfo.nParam2, False);
        end;
      end;
    end;
  end;
end;

procedure TRobotObject.AutoRunOfOnDay(AutoRunInfo: pTAutoRunInfo);
var
  wHour, wMin, wSec, wMSec: Word;
begin
  if GetTickCount > AutoRunInfo.dwRunTick then begin
    AutoRunInfo.dwRunTick := GetTickCount + 2000;
    DecodeTime(Time, wHour, wMin, wSec, wMSec);
    if (AutoRunInfo.m_nHour in [0..24]) and (AutoRunInfo.m_nMin in [0..60]) then begin
      if (wHour = AutoRunInfo.m_nHour) then begin
        if (wMin = AutoRunInfo.m_nMin) then begin
          if not AutoRunInfo.boStatus then begin
            g_RobotNPC.GotoLable(Self, AutoRunInfo.nParam2, False);
            AutoRunInfo.boStatus := True;
          end;
        end
        else begin
          AutoRunInfo.boStatus := False;
        end;
      end;
    end;
  end;
end;

procedure TRobotObject.AutoRunOfOnHour(AutoRunInfo: pTAutoRunInfo);
begin

end;

procedure TRobotObject.AutoRunOfOnMin(AutoRunInfo: pTAutoRunInfo);
begin

end;

procedure TRobotObject.AutoRunOfOnSec(AutoRunInfo: pTAutoRunInfo);
begin

end;

procedure TRobotObject.AutoRunOfOnWeek(AutoRunInfo: pTAutoRunInfo);
var
  wWeek, wHour, wMin, wSec, wMSec: Word;
begin
  if GetTickCount > AutoRunInfo.dwRunTick then begin
    AutoRunInfo.dwRunTick := GetTickCount + 2000;
    DecodeTime(Time, wHour, wMin, wSec, wMSec);
    wWeek := DayOfTheWeek(Now);
    if (AutoRunInfo.m_nWeek in [1..7]) and (AutoRunInfo.m_nHour in [0..23]) and (AutoRunInfo.m_nMin in [0..59]) then begin
      if (wWeek = AutoRunInfo.m_nWeek) and (wHour = AutoRunInfo.m_nHour) then begin
        if (wMin = AutoRunInfo.m_nMin) then begin
          if not AutoRunInfo.boStatus then begin
            g_RobotNPC.GotoLable(Self, AutoRunInfo.nParam2, False);
            AutoRunInfo.boStatus := True;
          end;
        end
        else begin
          AutoRunInfo.boStatus := False;
        end;
      end;
    end;
  end;
end;

procedure TRobotObject.ClearScript;
var
  i: Integer;
begin
  for i := 0 to m_AutoRunList.Count - 1 do begin
    if pTAutoRunInfo(m_AutoRunList.Items[i]) <> nil then
      DisPose(pTAutoRunInfo(m_AutoRunList.Items[i]));
  end;
  m_AutoRunList.Clear;
end;

constructor TRobotObject.Create;
begin
  inherited;
  m_AutoRunList := TList.Create;
  m_boSuperMan := True;
end;

destructor TRobotObject.Destroy;
begin
  ClearScript();
  m_AutoRunList.Free;
  inherited;
end;

function TRobotObject.GetNPCLabelIdx(sLabel: string): Integer;
var
  i: integer;
  SayingRecord: pTSayingRecord;
begin
  Result := -1;
  if g_RobotNPC <> nil then begin
    for i := 0 to g_RobotNPC.m_ScriptList.Count - 1 do begin
      SayingRecord := g_RobotNPC.m_ScriptList[i];
      if CompareText(sLabel, SayingRecord.sLabel) = 0 then begin
        Result := i;
        break;
      end;
    end;

  end;

end;

procedure TRobotObject.LoadScript;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
  sLineText: string;
  sActionType: string;
  sRunCmd: string;
  sMoethod: string;
  sParam1: string;
  sParam2: string;
  sParam3: string;
  sParam4: string;
  AutoRunInfo: pTAutoRunInfo;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
  sFileName := g_Config.sEnvirDir + 'Robot_def\' + m_sScriptFileName + '.txt';
  if MyFileExists(sFileName) then begin
    LoadList := TMsgStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do begin
      sLineText := LoadList.Strings[i];
      if (sLineText <> '') and (sLineText[1] <> ';') then begin
        sLineText := UserEngine.GetDefiniensConstText(sLineText);
        sLineText := GetValidStr3(sLineText, sActionType, [' ', '/', #9]);
        sLineText := GetValidStr3(sLineText, sRunCmd, [' ', '/', #9]);
        sLineText := GetValidStr3(sLineText, sMoethod, [' ', '/', #9]);
        sLineText := GetValidStr3(sLineText, sParam1, [' ', '/', #9]);
        sLineText := GetValidStr3(sLineText, sParam2, [' ', '/', #9]);
        sLineText := GetValidStr3(sLineText, sParam3, [' ', '/', #9]);
        sLineText := GetValidStr3(sLineText, sParam4, [' ', '/', #9]);
        if CompareText(sActionType, sROAUTORUN) = 0 then begin
          if CompareText(sRunCmd, sRONPCLABLEJMP) = 0 then begin
            New(AutoRunInfo);
            AutoRunInfo.dwRunTick := GetTickCount;
            AutoRunInfo.dwRunTimeLen := 0;
            AutoRunInfo.boStatus := False;
            AutoRunInfo.nRunCmd := nRONPCLABLEJMP;
            AutoRunInfo.sParam1 := sParam1;
            AutoRunInfo.sParam2 := sParam2;
            AutoRunInfo.sParam3 := sParam3;
            AutoRunInfo.sParam4 := sParam4;
            AutoRunInfo.nParam1 := StrToIntDef(sParam1, 1);
            AutoRunInfo.nParam2 := GetNPCLabelIdx(sParam2);

            if CompareText(sMoethod, sRODAY) = 0 then begin
              AutoRunInfo.nMoethod := nRODAY;
              AutoRunInfo.dwRunTick := GetTickCount + 24 * 60 * 60 * 1000 * LongWord(AutoRunInfo.nParam1);
            end;
            if CompareText(sMoethod, sROHOUR) = 0 then begin
              AutoRunInfo.nMoethod := nROHOUR;
              AutoRunInfo.dwRunTick := GetTickCount + 60 * 60 * 1000 * LongWord(AutoRunInfo.nParam1);
            end;
            if CompareText(sMoethod, sROMIN) = 0 then begin
              AutoRunInfo.nMoethod := nROMIN;
              AutoRunInfo.dwRunTick := GetTickCount + 60 * 1000 * LongWord(AutoRunInfo.nParam1);
            end;
            if CompareText(sMoethod, sROSEC) = 0 then begin
              AutoRunInfo.nMoethod := nROSEC;
              AutoRunInfo.dwRunTick := GetTickCount + 1000 * LongWord(AutoRunInfo.nParam1);
            end;
            if CompareText(sMoethod, sRUNONWEEK) = 0 then begin
              AutoRunInfo.nMoethod := nRUNONWEEK;
              sLineText := AutoRunInfo.sParam1;
              sLineText := GetValidStr3(sLineText, sParam1, [':']);
              sLineText := GetValidStr3(sLineText, sParam2, [':']);
              sLineText := GetValidStr3(sLineText, sParam3, [':']);
              AutoRunInfo.m_nWeek := StrToIntDef(sParam1, -1);
              AutoRunInfo.m_nHour := StrToIntDef(sParam2, -1);
              AutoRunInfo.m_nMin := StrToIntDef(sParam3, -1);
            end;
            if CompareText(sMoethod, sRUNONDAY) = 0 then begin
              AutoRunInfo.nMoethod := nRUNONDAY;
              sLineText := AutoRunInfo.sParam1;
              sLineText := GetValidStr3(sLineText, sParam1, [':']);
              sLineText := GetValidStr3(sLineText, sParam2, [':']);
              AutoRunInfo.m_nHour := StrToIntDef(sParam1, -1);
              AutoRunInfo.m_nMin := StrToIntDef(sParam2, -1);
            end;
            if CompareText(sMoethod, sRUNONHOUR) = 0 then begin
              AutoRunInfo.nMoethod := nRUNONHOUR;
            end;
            if CompareText(sMoethod, sRUNONMIN) = 0 then begin
              AutoRunInfo.nMoethod := nRUNONMIN;
            end;
            if CompareText(sMoethod, sRUNONSEC) = 0 then begin
              AutoRunInfo.nMoethod := nRUNONSEC;
            end;
            if CompareText(sMoethod, sRUNDATETIME) = 0 then begin
              DecodeDate(Now, Year, Month, Day);
              DecodeTime(Time, Hour, Min, Sec, MSec);
              AutoRunInfo.nMoethod := nRUNDATETIME;
              sLineText := AutoRunInfo.sParam1;
              sLineText := GetValidStr3(sLineText, sParam1, [':']);
              sLineText := GetValidStr3(sLineText, sParam2, [':']);
              sLineText := GetValidStr3(sLineText, sParam3, [':']);
              AutoRunInfo.m_nYear := StrToIntDef(sParam1, -1);
              AutoRunInfo.m_nMonth := StrToIntDef(sParam2, -1);
              AutoRunInfo.m_nDay := StrToIntDef(sParam3, -1);
              sLineText := GetValidStr3(sLineText, sParam1, [':']);
              sLineText := GetValidStr3(sLineText, sParam2, [':']);
              AutoRunInfo.m_nHour := StrToIntDef(sParam1, -1);
              AutoRunInfo.m_nMin := StrToIntDef(sParam2, -1);
              if (Year <= AutoRunInfo.m_nYear) and (Month <= AutoRunInfo.m_nMonth) and (Day <= AutoRunInfo.m_nDay) then begin

              end else begin
                Dispose(AutoRunInfo);
                Continue;
              end;
            end;
            m_AutoRunList.Add(AutoRunInfo);
          end;
        end;

      end;
    end;
    LoadList.Free;
  end;
end;

procedure TRobotObject.ProcessAutoRun;
var
  i: Integer;
  AutoRunInfo: pTAutoRunInfo;
begin
  for i := 0 to m_AutoRunList.Count - 1 do begin
    AutoRunInfo := pTAutoRunInfo(m_AutoRunList.Items[i]);
    if AutoRunInfo <> nil then
      AutoRun(AutoRunInfo);
  end;
end;

procedure TRobotObject.ReloadScript;
begin
  ClearScript();
  LoadScript();
end;

procedure TRobotObject.Run;
var
  i: Integer;
begin
  EnterCriticalSection(ProcessMsgCriticalSection);
  try
    if m_MsgList.Count > 0 then begin
      for I := m_MsgList.Count - 1 downto 0 do begin
        DisPose(pTSendMessage(m_MsgList[i]));
      end;
      m_MsgList.Clear;
    end;
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
  ProcessAutoRun();
  //  inherited;
end;

procedure TRobotObject.ScriptRun;
var
  i: Integer;
  NPCDelayGoto: pTNPCDelayGoto;
begin
  EnterCriticalSection(ProcessMsgCriticalSection);
  try
    if m_MsgList.Count > 0 then begin
      for I := m_MsgList.Count - 1 downto 0 do begin
        DisPose(pTSendMessage(m_MsgList[i]));
      end;
      m_MsgList.Clear;
    end;
  finally
    LeaveCriticalSection(ProcessMsgCriticalSection);
  end;
  if m_DelayGotoList.Count > 0 then begin
    for I := m_DelayGotoList.Count - 1 downto 0 do begin
      NPCDelayGoto := m_DelayGotoList[I];
      if (GetTickCount > NPCDelayGoto.dwTimeGotoTick) then begin
        NPCDelayGoto.GotoNPC.GotoLable(Self, NPCDelayGoto.nGotoLable, False, NPCDelayGoto.sParam);
        m_DelayGotoList.Delete(I);
        Dispose(NPCDelayGoto);
      end;
    end;
  end;
end;

procedure TRobotObject.SendSocket(DefMsg: pTDefaultMessage; sMsg: string);
begin
  //
end;

{ TRobotManage }

constructor TRobotManage.Create;
begin
  RobotHumanList := TStringList.Create;
  SystemObject := TRobotObject.Create;
  SystemObject.m_sCharName := 'System';
end;

destructor TRobotManage.Destroy;
begin
  UnLoadRobot();
  SystemObject.Free;
  RobotHumanList.Free;
  inherited;
end;

procedure TRobotManage.LoadRobot;
var
  i: Integer;
  LoadList: TStringList;
  sFileName: string;
  sLineText: string;
  sRobotName: string;
  sScriptFileName: string;
  RobotHuman: TRobotObject;
begin
  sFileName := g_Config.sEnvirDir + 'Robot.txt';
  if MyFileExists(sFileName) then begin
    LoadList := TMsgStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for i := 0 to LoadList.Count - 1 do begin
      sLineText := LoadList.Strings[i];
      if (sLineText <> '') and (sLineText[1] <> ';') then begin
        sLineText := GetValidStr3(sLineText, sRobotName, [' ', '/', #9]);
        sLineText := GetValidStr3(sLineText, sScriptFileName, [' ', '/', #9]);
        if (sRobotName <> '') and (sScriptFileName <> '') then begin
          RobotHuman := TRobotObject.Create;
          RobotHuman.m_sCharName := sRobotName;
          RobotHuman.m_sScriptFileName := sScriptFileName;
          RobotHuman.LoadScript;
          RobotHumanList.AddObject(RobotHuman.m_sCharName, RobotHuman);
        end;
      end;
    end;
    LoadList.Free;
  end;
end;

procedure TRobotManage.RELOADROBOT;
begin
  UnLoadRobot();
  LoadRobot();
end;

procedure TRobotManage.Run;
var
  i: Integer;
  RobotObject: TRobotObject;
resourcestring
  sExceptionMsg = '[Exception] TRobotManage::Run';
begin
  try
    SystemObject.ScriptRun;
    for i := 0 to RobotHumanList.Count - 1 do begin
      RobotObject := TRobotObject(RobotHumanList.Objects[i]);
      if RobotObject <> nil then
        RobotObject.Run;
    end;
  except
    {on E: Exception do begin
      MainOutMessage(sExceptionMsg);
      MainOutMessage(E.Message);
    end; }
  end;
end;

procedure TRobotManage.UnLoadRobot;
var
  i: Integer;
begin
  for i := 0 to RobotHumanList.Count - 1 do begin
    TRobotObject(RobotHumanList.Objects[i]).Free;
  end;
  RobotHumanList.Clear;
end;

end.

