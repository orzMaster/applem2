unit ViewKernelInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Grids, M2Share, Menus;

type
  TfrmViewKernelInfo = class(TForm)
    Timer: TTimer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditLoadHumanDBCount: TEdit;
    EditLoadHumanDBErrorCoun: TEdit;
    EditSaveHumanDBCount: TEdit;
    EditHumanDBQueryID: TEdit;
    GroupBox4: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    EditItemNumber: TEdit;
    EditItemNumberEx: TEdit;
    TabSheet3: TTabSheet;
    TabSheet5: TTabSheet;
    GroupBox7: TGroupBox;
    GridThread: TStringGrid;
    ListViewInteger: TListView;
    ListViewString: TListView;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    MainMenu1: TMainMenu;
    V1: TMenuItem;
    A1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    EditWinLotteryLevel1: TEdit;
    EditWinLotteryLevel2: TEdit;
    EditWinLotteryLevel3: TEdit;
    EditWinLotteryLevel4: TEdit;
    EditWinLotteryLevel5: TEdit;
    EditWinLotteryLevel6: TEdit;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    EditWinLotteryCount: TEdit;
    EditNoWinLotteryCount: TEdit;

    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ListViewIntegerDblClick(Sender: TObject);
    procedure ListViewStringDblClick(Sender: TObject);
  private
    boIsRun: Boolean;
    procedure GridThreadAdd(ThreadInfo: pTThreadInfo; Index: Integer);
    procedure RefGlobalVal();
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmViewKernelInfo: TfrmViewKernelInfo;

implementation

uses Hutil32;

{$R *.dfm}

{ TfrmViewKernelInfo }

procedure TfrmViewKernelInfo.Button1Click(Sender: TObject);
begin
  SafeFillChar(g_Config.GlobalVal, SizeOf(g_Config.GlobalVal), #0);
end;

procedure TfrmViewKernelInfo.Button2Click(Sender: TObject);
begin
  SafeFillChar(g_Config.GlobalAVal, SizeOf(g_Config.GlobalAVal), #0);
end;

procedure TfrmViewKernelInfo.FormCreate(Sender: TObject);
resourcestring
  sNo = '序号';
  sHandle = '句柄';
  sThreadID = '线程ID';
  sRunTime = '运行时间';
  sRunFlag = '运行状态';
var
  Config: pTConfig;
  ThreadInfo: pTThreadInfo;
begin
  boIsRun := False;
  PageControl1.TabIndex := 0;
  Config := @g_Config;
  GridThread.Cells[0, 0] := sNo;
  GridThread.Cells[1, 0] := sHandle;
  GridThread.Cells[2, 0] := sThreadID;
  GridThread.Cells[3, 0] := sRunTime;
  GridThread.Cells[4, 0] := sRunFlag;
  ThreadInfo := @Config.UserEngineThread;
  //ThreadInfo.hThreadHandle := 0;
  ThreadInfo.dwRunTick := 0;
  ThreadInfo.nRunTime := 0;
  ThreadInfo.nMaxRunTime := 0;
  ThreadInfo.nRunFlag := 0;
  ThreadInfo := @Config.IDSocketThread;
  //ThreadInfo.hThreadHandle := 0;
  ThreadInfo.dwRunTick := 0;
  ThreadInfo.nRunTime := 0;
  ThreadInfo.nMaxRunTime := 0;
  ThreadInfo.nRunFlag := 0;
  ThreadInfo := @Config.DBSOcketThread;
  //ThreadInfo.hThreadHandle := 0;
  ThreadInfo.dwRunTick := 0;
  ThreadInfo.nRunTime := 0;
  ThreadInfo.nMaxRunTime := 0;
  ThreadInfo.nRunFlag := 0;
end;

procedure TfrmViewKernelInfo.Open;
begin
  Timer.Enabled := True;
  RefGlobalVal();
  ShowModal;
  Timer.Enabled := False;
end;

procedure TfrmViewKernelInfo.RefGlobalVal;
var
  i: Integer;
  Item: TListItem;
begin
  for I := Low(g_Config.GlobalVal) to High(g_Config.GlobalVal) do begin
    if ListViewInteger.Items.Count <= I then
      Item := ListViewInteger.Items.Add
    else
      Item := ListViewInteger.Items[I];
    Item.Caption := IntToStr(I);
    if Item.SubItems.Count > 0 then
      Item.SubItems.Strings[0] := IntToStr(g_Config.GlobalVal[I])
    else
      Item.SubItems.Add(IntToStr(g_Config.GlobalVal[I]));
  end;
  for I := Low(g_Config.GlobalAVal) to High(g_Config.GlobalAVal) do begin
    if ListViewString.Items.Count <= I then
      Item := ListViewString.Items.Add
    else
      Item := ListViewString.Items[I];
    Item.Caption := IntToStr(I);
    if Item.SubItems.Count > 0 then
      Item.SubItems.Strings[0] := g_Config.GlobalAVal[I]
    else
      Item.SubItems.Add(g_Config.GlobalAVal[I]);
  end;

end;

procedure TfrmViewKernelInfo.TimerTimer(Sender: TObject);
var
  Config: pTConfig;
  ThreadInfo: pTThreadInfo;
begin
  if boIsRun then Exit;
  boIsRun := True;
  try
    Config := @g_Config;
    EditLoadHumanDBCount.Text := IntToStr(g_Config.nLoadDBCount);
    EditLoadHumanDBErrorCoun.Text := IntToStr(g_Config.nLoadDBErrorCount);
    EditSaveHumanDBCount.Text := IntToStr(g_Config.nSaveDBCount);
    EditHumanDBQueryID.Text := IntToStr(g_Config.nDBQueryID);

    EditItemNumber.Text := IntToStr(g_Config.nItemNumber);
    EditItemNumberEx.Text := IntToStr(g_Config.nItemNumberEx);

    EditWinLotteryCount.Text := IntToStr(g_Config.nWinLotteryCount);
    EditNoWinLotteryCount.Text := IntToStr(g_Config.nNoWinLotteryCount);
    EditWinLotteryLevel1.Text := IntToStr(g_Config.nWinLotteryLevel1);
    EditWinLotteryLevel2.Text := IntToStr(g_Config.nWinLotteryLevel2);
    EditWinLotteryLevel3.Text := IntToStr(g_Config.nWinLotteryLevel3);
    EditWinLotteryLevel4.Text := IntToStr(g_Config.nWinLotteryLevel4);
    EditWinLotteryLevel5.Text := IntToStr(g_Config.nWinLotteryLevel5);
    EditWinLotteryLevel6.Text := IntToStr(g_Config.nWinLotteryLevel6);

    ThreadInfo := @Config.UserEngineThread;
    GridThreadAdd(ThreadInfo, 0);
    ThreadInfo := @Config.IDSocketThread;
    GridThreadAdd(ThreadInfo, 1);
    ThreadInfo := @Config.DBSOcketThread;
    GridThreadAdd(ThreadInfo, 2);
    RefGlobalVal();
  finally
    boIsRun := False;
  end;
end;

procedure TfrmViewKernelInfo.GridThreadAdd(ThreadInfo: pTThreadInfo; Index:
  Integer);
begin
  GridThread.Cells[0, Index + 1] := format('%d', [Index]);
  GridThread.Cells[1, Index + 1] := format('%d', [ThreadInfo.hThreadHandle]);
  GridThread.Cells[2, Index + 1] := format('%d', [ThreadInfo.dwThreadID]);
  GridThread.Cells[3, Index + 1] := format('%d/%d/%d', [
      GetTickCount - ThreadInfo.dwRunTick,
      GetTickCount - LongWord(ThreadInfo.nRunTime),
      GetTickCount - LongWord(ThreadInfo.nMaxRunTime)]);
  GridThread.Cells[4, Index + 1] := format('%d', [ThreadInfo.nRunFlag]);
end;

procedure TfrmViewKernelInfo.ListViewIntegerDblClick(Sender: TObject);
var
  Index: Integer;
  sMsg: string;
begin
  Index := ListViewInteger.ItemIndex;
  if Index > -1 then begin
    sMsg := InputBox('设置变量', '数值变量(' + IntToStr(Index) + ')',
        IntToStr(g_Config.GlobalVal[Index]));
    g_Config.GlobalVal[Index] := StrToIntDef(sMsg, g_Config.GlobalVal[Index]);
  end;

end;

procedure TfrmViewKernelInfo.ListViewStringDblClick(Sender: TObject);
var
  Index: Integer;
  sMsg: string;
begin
  Index := ListViewString.ItemIndex;
  if Index > -1 then begin
    sMsg := InputBox('设置变量', '字符串变量(' + IntToStr(Index) + ')',
        g_Config.GlobalAVal[Index]);
    g_Config.GlobalAVal[Index] := sMsg;
  end;
end;

end.

