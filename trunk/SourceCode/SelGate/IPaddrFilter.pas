unit IPaddrFilter;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, JSocket, WinSock, Menus, Spin, IniFiles;

type
  TfrmIPaddrFilter = class(TForm)
    BlockListPopupMenu: TPopupMenu;
    TempBlockListPopupMenu: TPopupMenu;
    ActiveListPopupMenu: TPopupMenu;
    APOPMENU_SORT: TMenuItem;
    APOPMENU_ADDTEMPLIST: TMenuItem;
    APOPMENU_BLOCKLIST: TMenuItem;
    APOPMENU_KICK: TMenuItem;
    TPOPMENU_SORT: TMenuItem;
    TPOPMENU_BLOCKLIST: TMenuItem;
    TPOPMENU_DELETE: TMenuItem;
    BPOPMENU_ADDTEMPLIST: TMenuItem;
    BPOPMENU_SORT: TMenuItem;
    BPOPMENU_DELETE: TMenuItem;
    APOPMENU_REFLIST: TMenuItem;
    TPOPMENU_REFLIST: TMenuItem;
    BPOPMENU_REFLIST: TMenuItem;
    TPOPMENU_ADD: TMenuItem;
    BPOPMENU_ADD: TMenuItem;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    ListBoxActiveList: TListBox;
    GroupBox2: TGroupBox;
    LabelTempList: TLabel;
    Label1: TLabel;
    ListBoxBlockList: TListBox;
    ListBoxTempList: TListBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    Label7: TLabel;
    Label2: TLabel;
    Label9: TLabel;
    Label3: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Edit_CountLimit1: TSpinEdit;
    Edit_CountLimit2: TSpinEdit;
    Edit_LimitTime1: TSpinEdit;
    Edit_LimitTime2: TSpinEdit;
    EditMaxConnect: TSpinEdit;
    EditClientTimeOutTime: TSpinEdit;
    ButtonOK: TButton;
    GroupBox3: TGroupBox;
    RadioAddBlockList: TRadioButton;
    RadioAddTempList: TRadioButton;
    RadioDisConnect: TRadioButton;
    EditConnectTimeOut: TSpinEdit;
    Label5: TLabel;
    Label6: TLabel;
    ListBoxIpList: TListBox;
    Label23: TLabel;
    IPListPopupMenu: TPopupMenu;
    IPMENU_SORT: TMenuItem;
    IPMENU_ADD: TMenuItem;
    IPMENU_DEL: TMenuItem;
    CheckBoxCheckClientMsg: TCheckBox;
    CheckBoxCCProtect: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure ActiveListPopupMenuPopup(Sender: TObject);
    procedure APOPMENU_KICKClick(Sender: TObject);
    procedure APOPMENU_SORTClick(Sender: TObject);
    procedure APOPMENU_ADDTEMPLISTClick(Sender: TObject);
    procedure APOPMENU_BLOCKLISTClick(Sender: TObject);
    procedure TPOPMENU_SORTClick(Sender: TObject);
    procedure TPOPMENU_BLOCKLISTClick(Sender: TObject);
    procedure TPOPMENU_DELETEClick(Sender: TObject);
    procedure BPOPMENU_SORTClick(Sender: TObject);
    procedure BPOPMENU_ADDTEMPLISTClick(Sender: TObject);
    procedure BPOPMENU_DELETEClick(Sender: TObject);
    procedure TempBlockListPopupMenuPopup(Sender: TObject);
    procedure BlockListPopupMenuPopup(Sender: TObject);
    procedure EditMaxConnectChange(Sender: TObject);
    procedure RadioDisConnectClick(Sender: TObject);
    procedure RadioAddBlockListClick(Sender: TObject);
    procedure RadioAddTempListClick(Sender: TObject);
    procedure APOPMENU_REFLISTClick(Sender: TObject);
    procedure TPOPMENU_REFLISTClick(Sender: TObject);
    procedure BPOPMENU_REFLISTClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure TPOPMENU_ADDClick(Sender: TObject);
    procedure BPOPMENU_ADDClick(Sender: TObject);
    procedure EditClientTimeOutTimeChange(Sender: TObject);
    procedure Edit_LimitTime1Change(Sender: TObject);
    procedure Edit_LimitTime2Change(Sender: TObject);
    procedure Edit_CountLimit1Change(Sender: TObject);
    procedure Edit_CountLimit2Change(Sender: TObject);
    procedure CheckBoxCheckClientMsgClick(Sender: TObject);
    procedure EditConnectTimeOutChange(Sender: TObject);
    procedure IPMENU_SORTClick(Sender: TObject);
    procedure IPMENU_ADDClick(Sender: TObject);
    procedure IPMENU_DELClick(Sender: TObject);
    procedure IPListPopupMenuPopup(Sender: TObject);
    procedure CheckBoxCCProtectClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmIPaddrFilter: TfrmIPaddrFilter;

implementation

uses Main, GateShare, HUtil32;

{$R *.dfm}

procedure TfrmIPaddrFilter.FormCreate(Sender: TObject);
begin
  ListBoxActiveList.Clear;
  ListBoxTempList.Clear;
  ListBoxBlockList.Clear;
  //TrackBarAttack.Hint := '调整范围在：1-10。分别是：严格-宽松。等级为0时关闭攻击防御！当前等级：' + IntToStr(TrackBarAttack.Position);
end;

procedure TfrmIPaddrFilter.IPListPopupMenuPopup(Sender: TObject);
var
  boCheck: Boolean;
begin
  IPMENU_SORT.Enabled := ListBoxIpList.Items.Count > 0;

  boCheck := (ListBoxIpList.ItemIndex >= 0) and (ListBoxIpList.ItemIndex < ListBoxIpList.Items.Count);

  IPMENU_DEL.Enabled := boCheck;
end;

procedure TfrmIPaddrFilter.IPMENU_ADDClick(Sender: TObject);
var
  sIPaddress: string;
  nBeginaddr, nEndaddr: integer;
  Blockaddr: pTBlockaddr;
begin
  sIPaddress := '';
  if not InputQuery('过滤IP段信息', '请输入起始IP地址: ', sIPaddress) then Exit;
  nBeginaddr := inet_addr(PChar(sIPaddress));
  if nBeginaddr = INADDR_NONE then begin
    Application.MessageBox('输入的地址格式不正确！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  if not InputQuery('过滤IP段信息', '请输入结束IP地址: ', sIPaddress) then Exit;
  nEndaddr := inet_addr(PChar(sIPaddress));
  if nEndaddr = INADDR_NONE then begin
    Application.MessageBox('输入的地址格式不正确！', '提示信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  if LongWord(nEndaddr) >= LongWord(nBeginaddr) then begin
    New(Blockaddr);
    Blockaddr.nBeginAddr := nBeginaddr;
    Blockaddr.nEndAddr := nEndaddr;
    IpList.Add(Blockaddr);
    ListBoxIpList.AddItem(StrPas(inet_ntoa(TInAddr(nBeginAddr))) + ' - ' + StrPas(inet_ntoa(TInAddr(nEndAddr))),
      TObject(Blockaddr));
    SaveBlockIPList;
  end else
    Application.MessageBox('结束地址不能小于开始地址', '提示信息', MB_OK +
      MB_ICONINFORMATION);
end;

procedure TfrmIPaddrFilter.IPMENU_DELClick(Sender: TObject);
var
  i: Integer;
  Blockaddr: pTBlockaddr;
begin
  if (ListBoxIpList.ItemIndex >= 0) and (ListBoxIpList.ItemIndex < ListBoxIpList.Items.Count) then begin
    Blockaddr := pTBlockaddr(ListBoxIpList.Items.Objects[ListBoxIpList.ItemIndex]);
    ListBoxIpList.Items.Delete(ListBoxIpList.ItemIndex);
    for i := 0 to IPList.Count - 1 do begin
      if pTBlockaddr(IPList.Items[i]) = Blockaddr then begin
        IPList.Delete(i);
        Dispose(Blockaddr);
        break;
      end;
    end;
  end;
  SaveBlockIPList;
end;

procedure TfrmIPaddrFilter.IPMENU_SORTClick(Sender: TObject);
begin
  ListBoxIpList.Sorted := True;
end;

procedure TfrmIPaddrFilter.ActiveListPopupMenuPopup(Sender: TObject);
var
  boCheck: Boolean;
begin
  APOPMENU_SORT.Enabled := ListBoxActiveList.Items.Count > 0;

  boCheck := (ListBoxActiveList.ItemIndex >= 0) and (ListBoxActiveList.ItemIndex
    < ListBoxActiveList.Items.Count);

  APOPMENU_ADDTEMPLIST.Enabled := boCheck;
  APOPMENU_BLOCKLIST.Enabled := boCheck;
  APOPMENU_KICK.Enabled := boCheck;
end;

procedure TfrmIPaddrFilter.APOPMENU_KICKClick(Sender: TObject);
begin
  if (ListBoxActiveList.ItemIndex >= 0) and (ListBoxActiveList.ItemIndex <
    ListBoxActiveList.Items.Count) then begin
    if Application.MessageBox(PChar('是否确认将此连接断开？'),
      PChar('确认信息 - ' +
      ListBoxActiveList.Items.Strings[ListBoxActiveList.ItemIndex]), MB_OKCANCEL
      + MB_ICONQUESTION) <> IDOK then
      Exit;
    TCustomWinSocket(ListBoxActiveList.Items.Objects[ListBoxActiveList.ItemIndex]).Close;
    APOPMENU_REFLISTClick(Self);
  end;
end;

procedure TfrmIPaddrFilter.APOPMENU_SORTClick(Sender: TObject);
begin
  ListBoxActiveList.Sorted := True;
end;

procedure TfrmIPaddrFilter.APOPMENU_ADDTEMPLISTClick(Sender: TObject);
var
  sIPaddr: string;
begin
  if (ListBoxActiveList.ItemIndex >= 0) and (ListBoxActiveList.ItemIndex <
    ListBoxActiveList.Items.Count) then begin
    sIPaddr := ListBoxActiveList.Items.Strings[ListBoxActiveList.ItemIndex];
    if
      Application.MessageBox(PChar('是否确认将此IP加入动态过滤列表中？加入过滤列表后，此IP建立的所有连接将被强行中断。'),
      PChar('确认信息 - ' +
      ListBoxActiveList.Items.Strings[ListBoxActiveList.ItemIndex]),
      MB_OKCANCEL + MB_ICONQUESTION
      ) <> IDOK then
      Exit;
    ListBoxTempList.Items.Add(sIPaddr);
    FrmMain.AddTempBlockIP(sIPaddr);
    FrmMain.CloseConnect(sIPaddr);
    APOPMENU_REFLISTClick(Self);
  end;
end;

procedure TfrmIPaddrFilter.APOPMENU_BLOCKLISTClick(Sender: TObject);
var
  sIPaddr: string;
begin
  if (ListBoxActiveList.ItemIndex >= 0) and (ListBoxActiveList.ItemIndex <
    ListBoxActiveList.Items.Count) then begin
    sIPaddr := ListBoxActiveList.Items.Strings[ListBoxActiveList.ItemIndex];
    if
      Application.MessageBox(PChar('是否确认将此IP加入永久过滤列表中？加入过滤列表后，此IP建立的所有连接将被强行中断。'),
      PChar('确认信息 - ' +
      ListBoxActiveList.Items.Strings[ListBoxActiveList.ItemIndex]),
      MB_OKCANCEL + MB_ICONQUESTION
      ) <> IDOK then
      Exit;
    ListBoxBlockList.Items.Add(sIPaddr);
    FrmMain.AddBlockIP(sIPaddr);
    FrmMain.CloseConnect(sIPaddr);
    APOPMENU_REFLISTClick(Self);
  end;
end;

procedure TfrmIPaddrFilter.TPOPMENU_SORTClick(Sender: TObject);
begin
  ListBoxTempList.Sorted := True;
end;

procedure TfrmIPaddrFilter.TPOPMENU_BLOCKLISTClick(Sender: TObject);
var
  sIPaddr: string;
  I: Integer;
  nIPaddr: Integer;
begin
  if (ListBoxTempList.ItemIndex >= 0) and (ListBoxTempList.ItemIndex <
    ListBoxTempList.Items.Count) then begin
    sIPaddr := ListBoxTempList.Items.Strings[ListBoxTempList.ItemIndex];
    ListBoxTempList.Items.Delete(ListBoxTempList.ItemIndex);
    nIPaddr := inet_addr(PChar(sIPaddr));
    for I := 0 to TempBlockIPList.Count - 1 do begin
      if pTSockaddr(TempBlockIPList.Items[I]).nIPaddr = nIPaddr then begin
        TempBlockIPList.Delete(I);
        break;
      end;
    end;
    ListBoxBlockList.Items.Add(sIPaddr);
    FrmMain.AddBlockIP(sIPaddr);
  end;
end;

procedure TfrmIPaddrFilter.TPOPMENU_DELETEClick(Sender: TObject);
var
  sIPaddr: string;
  i: Integer;
  nIPaddr: Integer;
begin
  if (ListBoxTempList.ItemIndex >= 0) and (ListBoxTempList.ItemIndex <
    ListBoxTempList.Items.Count) then begin
    sIPaddr := ListBoxTempList.Items.Strings[ListBoxTempList.ItemIndex];
    ListBoxTempList.Items.Delete(ListBoxTempList.ItemIndex);
    nIPaddr := inet_addr(PChar(sIPaddr));
    for i := 0 to TempBlockIPList.Count - 1 do begin
      if pTSockaddr(TempBlockIPList.Items[i]).nIPaddr = nIPaddr then begin
        Dispose(pTSockaddr(TempBlockIPList[i]));
        TempBlockIPList.Delete(i);
        break;
      end;
    end;
  end;
end;

procedure TfrmIPaddrFilter.BPOPMENU_SORTClick(Sender: TObject);
begin
  ListBoxBlockList.Sorted := True;
end;

procedure TfrmIPaddrFilter.BPOPMENU_ADDTEMPLISTClick(Sender: TObject);
var
  sIPaddr: string;
  I: Integer;
  nIPaddr: Integer;
begin
  if (ListBoxBlockList.ItemIndex >= 0) and (ListBoxBlockList.ItemIndex <
    ListBoxBlockList.Items.Count) then begin
    sIPaddr := ListBoxBlockList.Items.Strings[ListBoxBlockList.ItemIndex];
    ListBoxBlockList.Items.Delete(ListBoxBlockList.ItemIndex);
    nIPaddr := inet_addr(PChar(sIPaddr));
    for I := 0 to BlockIPList.Count - 1 do begin
      if pTSockaddr(BlockIPList.Items[I]).nIPaddr = nIPaddr then begin
        BlockIPList.Delete(I);
        break;
      end;
    end;
    ListBoxTempList.Items.Add(sIPaddr);
    FrmMain.AddTempBlockIP(sIPaddr);
  end;
end;

procedure TfrmIPaddrFilter.BPOPMENU_DELETEClick(Sender: TObject);
var
  sIPaddr: string;
  i: Integer;
  nIPaddr: Integer;
begin
  if (ListBoxBlockList.ItemIndex >= 0) and (ListBoxBlockList.ItemIndex <
    ListBoxBlockList.Items.Count) then begin
    sIPaddr := ListBoxBlockList.Items.Strings[ListBoxBlockList.ItemIndex];
    nIPaddr := inet_addr(PChar(sIPaddr));
    ListBoxBlockList.Items.Delete(ListBoxBlockList.ItemIndex);
    for i := 0 to BlockIPList.Count - 1 do begin
      if pTSockaddr(BlockIPList.Items[i]).nIPaddr = nIPaddr then begin
        Dispose(pTSockaddr(BlockIPList[i]));
        BlockIPList.Delete(i);
        break;
      end;
    end;
  end;
  SaveBlockIPList();
end;

procedure TfrmIPaddrFilter.TempBlockListPopupMenuPopup(Sender: TObject);
var
  boCheck: Boolean;
begin
  TPOPMENU_SORT.Enabled := ListBoxTempList.Items.Count > 0;

  boCheck := (ListBoxTempList.ItemIndex >= 0) and (ListBoxTempList.ItemIndex <
    ListBoxTempList.Items.Count);

  TPOPMENU_BLOCKLIST.Enabled := boCheck;
  TPOPMENU_DELETE.Enabled := boCheck;
end;

procedure TfrmIPaddrFilter.BlockListPopupMenuPopup(Sender: TObject);
var
  boCheck: Boolean;
begin
  BPOPMENU_SORT.Enabled := ListBoxBlockList.Items.Count > 0;

  boCheck := (ListBoxBlockList.ItemIndex >= 0) and (ListBoxBlockList.ItemIndex <
    ListBoxBlockList.Items.Count);

  BPOPMENU_ADDTEMPLIST.Enabled := boCheck;
  BPOPMENU_DELETE.Enabled := boCheck;
end;

procedure TfrmIPaddrFilter.EditClientTimeOutTimeChange(Sender: TObject);
begin
  dwKeepConnectTimeOut := EditClientTimeOutTime.Value * 1000;
end;

procedure TfrmIPaddrFilter.EditConnectTimeOutChange(Sender: TObject);
begin
  dwConnectTimeOut := EditConnectTimeOut.Value * 1000;
end;

procedure TfrmIPaddrFilter.EditMaxConnectChange(Sender: TObject);
begin
  nMaxConnOfIPaddr := EditMaxConnect.Value;
end;

procedure TfrmIPaddrFilter.Edit_CountLimit1Change(Sender: TObject);
begin
  nIPCountLimit1 := Edit_CountLimit1.Value;
end;

procedure TfrmIPaddrFilter.Edit_CountLimit2Change(Sender: TObject);
begin
  nIPCountLimit2 := Edit_CountLimit2.Value;
end;

procedure TfrmIPaddrFilter.Edit_LimitTime1Change(Sender: TObject);
begin
  nIPCountLimitTime1 := Edit_LimitTime1.Value;
end;

procedure TfrmIPaddrFilter.Edit_LimitTime2Change(Sender: TObject);
begin
  nIPCountLimitTime2 := Edit_LimitTime2.Value;
end;

procedure TfrmIPaddrFilter.RadioDisConnectClick(Sender: TObject);
begin
  if RadioDisConnect.Checked then
    BlockMethod := mDisconnect;
end;

procedure TfrmIPaddrFilter.RadioAddBlockListClick(Sender: TObject);
begin
  if RadioAddBlockList.Checked then
    BlockMethod := mBlockList;
end;

procedure TfrmIPaddrFilter.RadioAddTempListClick(Sender: TObject);
begin
  if RadioAddTempList.Checked then
    BlockMethod := mBlock;
end;

procedure TfrmIPaddrFilter.APOPMENU_REFLISTClick(Sender: TObject);
var
  I: Integer;
  sIPaddr: string;
begin
  ListBoxActiveList.Clear;
  if FrmMain.ServerSocket.Active then
    for I := 0 to FrmMain.ServerSocket.Socket.ActiveConnections - 1 do begin
      sIPaddr := FrmMain.ServerSocket.Socket.Connections[I].RemoteAddress;
      if sIPaddr <> '' then
        ListBoxActiveList.Items.AddObject(sIPaddr,
          TObject(FrmMain.ServerSocket.Socket.Connections[I]));
    end;
end;

procedure TfrmIPaddrFilter.TPOPMENU_REFLISTClick(Sender: TObject);
var
  I: Integer;
begin
  ListBoxTempList.Clear;
  for I := 0 to TempBlockIPList.Count - 1 do begin
    frmIPaddrFilter.ListBoxTempList.Items.Add(StrPas(inet_ntoa(TInAddr(pTSockaddr(TempBlockIPList.Items[I]).nIPaddr))));
  end;
end;

procedure TfrmIPaddrFilter.BPOPMENU_REFLISTClick(Sender: TObject);
var
  I: Integer;
begin
  ListBoxBlockList.Clear;
  for I := 0 to BlockIPList.Count - 1 do begin
    frmIPaddrFilter.ListBoxTempList.Items.Add(StrPas(inet_ntoa(TInAddr(pTSockaddr(BlockIPList.Items[I]).nIPaddr))));
  end;
end;

procedure TfrmIPaddrFilter.ButtonOKClick(Sender: TObject);
var
  Conf: TIniFile;
begin
  if g_boTeledata then Conf := TIniFile.Create(TeledataConfigFileName)
  else Conf := TIniFile.Create(ConfigFileName);
  Conf.WriteInteger(GateClass, 'MaxConnOfIPaddr', nMaxConnOfIPaddr);
  Conf.WriteInteger(GateClass, 'KeepConnectTimeOut', dwKeepConnectTimeOut);
  Conf.WriteInteger(GateClass, 'ConnectTimeOut', dwConnectTimeOut);
  Conf.WriteInteger(GateClass, 'IPCountTime1', nIPCountLimitTime1);
  Conf.WriteInteger(GateClass, 'IPCountLimit1', nIPCountLimit1);
  Conf.WriteInteger(GateClass, 'IPCountTime2', nIPCountLimitTime2);
  Conf.WriteInteger(GateClass, 'IPCountLimit2', nIPCountLimit2);

  Conf.WriteInteger(GateClass, 'BlockMethod', Integer(BlockMethod));

  Conf.WriteBool(GateClass, 'CheckClientMsg', boCheckClientMsg);
  Conf.WriteBool(GateClass, 'CCProtect', boCCProtect);
  Conf.Free;
  Close;
end;

procedure TfrmIPaddrFilter.CheckBoxCCProtectClick(Sender: TObject);
begin
  boCCProtect := CheckBoxCCProtect.Checked;
end;

procedure TfrmIPaddrFilter.CheckBoxCheckClientMsgClick(Sender: TObject);
begin
  boCheckClientMsg := CheckBoxCheckClientMsg.Checked;
end;

procedure TfrmIPaddrFilter.TPOPMENU_ADDClick(Sender: TObject);
var
  sIPaddress: string;
begin
  sIPaddress := '';
  if not InputQuery('动态IP过滤', '请输入一个新的IP地址: ', sIPaddress) then
    Exit;
  if not IsIPaddr(sIPaddress) then begin
    Application.MessageBox('输入的地址格式错误！！！',
      '错误信息', MB_OK + MB_ICONERROR);
    Exit;
  end;
  ListBoxTempList.Items.Add(sIPaddress);
  FrmMain.AddTempBlockIP(sIPaddress);
end;

procedure TfrmIPaddrFilter.BPOPMENU_ADDClick(Sender: TObject);
var
  sIPaddress: string;
begin
  sIPaddress := '';
  if not InputQuery('永久IP过滤', '请输入一个新的IP地址: ',
    sIPaddress) then
    Exit;
  if not IsIPaddr(sIPaddress) then begin
    if
      Application.MessageBox('输入的地址格式不完整，是否添加？',
      '错误信息',
      MB_YESNO + MB_ICONQUESTION) <> ID_YES then
      Exit;
  end;
  ListBoxBlockList.Items.Add(sIPaddress);
  FrmMain.AddBlockIP(sIPaddress);
  SaveBlockIPList();
end;

end.

