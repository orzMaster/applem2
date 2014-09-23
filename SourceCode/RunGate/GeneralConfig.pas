unit GeneralConfig;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  StdCtrls, ComCtrls, IniFiles;

type
  TfrmGeneralConfig = class(TForm)
    GroupBoxNet: TGroupBox;
    LabelGateIPaddr: TLabel;
    EditGateIPaddr: TEdit;
    EditGatePort: TEdit;
    LabelGatePort: TLabel;
    EditServerPort: TEdit;
    LabelServerPort: TLabel;
    LabelServerIPaddr: TLabel;
    EditServerIPaddr: TEdit;
    GroupBoxInfo: TGroupBox;
    Label1: TLabel;
    EditTitle: TEdit;
    TrackBarLogLevel: TTrackBar;
    LabelShowLogLevel: TLabel;
    LabelShowBite: TLabel;
    ComboBoxShowBite: TComboBox;
    ButtonOK: TButton;
    EditCenterIPaddr: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    EditCenterPort: TEdit;
    procedure ButtonOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGeneralConfig: TfrmGeneralConfig;

implementation

uses HUtil32, GateShare;

{$R *.dfm}

procedure TfrmGeneralConfig.ButtonOKClick(Sender: TObject);
var
  sGateIPaddr, sServerIPaddr, sTitle, sCenterIPaddr: string;
  nGatePort, nServerPort, nShowBite, nShowLogLv, nCenterPort: Integer;
begin
  sGateIPaddr := Trim(EditGateIPaddr.Text);
  nGatePort := StrToIntDef(Trim(EditGatePort.Text), -1);
  sServerIPaddr := Trim(EditServerIPaddr.Text);
  nServerPort := StrToIntDef(Trim(EditServerPort.Text), -1);
  sCenterIPaddr := Trim(EditCenterIPaddr.Text);
  nCenterPort := StrToIntDef(Trim(EditCenterPort.Text), -1);
  sTitle := Trim(EditTitle.Text);
  nShowBite := ComboBoxShowBite.ItemIndex;
  nShowLogLv := TrackBarLogLevel.Position;

  if not IsIPaddr(sCenterIPaddr) then begin
    Application.MessageBox('控制中心地址设置错误！！！', '错误信息',
      MB_OK + MB_ICONERROR);
    EditCenterIPaddr.SetFocus;
    Exit;
  end;

  if (nCenterPort < 0) or (nCenterPort > 65535) then begin
    Application.MessageBox('控制中心端口设置错误！！！', '错误信息',
      MB_OK +
      MB_ICONERROR);
    EditCenterPort.SetFocus;
    Exit;
  end;

  if not IsIPaddr(sGateIPaddr) then begin
    Application.MessageBox('网关地址设置错误！！！', '错误信息',
      MB_OK +
      MB_ICONERROR);
    EditGateIPaddr.SetFocus;
    Exit;
  end;

  if (nGatePort < 0) or (nGatePort > 65535) then begin
    Application.MessageBox('网关端口设置错误！！！', '错误信息',
      MB_OK +
      MB_ICONERROR);
    EditGatePort.SetFocus;
    Exit;
  end;

  if not IsIPaddr(sServerIPaddr) then begin
    Application.MessageBox('服务器地址设置错误！！！',
      '错误信息', MB_OK +
      MB_ICONERROR);
    EditServerIPaddr.SetFocus;
    Exit;
  end;

  if (nServerPort < 0) or (nServerPort > 65535) then begin
    Application.MessageBox('服务器端口设置错误！！！', '错误信息',
      MB_OK +
      MB_ICONERROR);
    EditServerPort.SetFocus;
    Exit;
  end;
  if sTitle = '' then begin
    Application.MessageBox('标题设置错误！！！', '错误信息', MB_OK
      +
      MB_ICONERROR);
    EditTitle.SetFocus;
    Exit;
  end;
  if nShowBite < 0 then begin
    Application.MessageBox('流量显示单位设置错误！！！',
      '错误信息', MB_OK +
      MB_ICONERROR);
    ComboBoxShowBite.SetFocus;
    Exit;
  end;
  nShowLogLevel := nShowLogLv;
  TitleName := sTitle;
  ServerAddr := sServerIPaddr;
  ServerPort := nServerPort;
  GateAddr := sGateIPaddr;
  GatePort := nGatePort;
  CenterAddr := sCenterIPaddr;
  CenterPort := nCenterPort;
  boShowBite := Boolean(nShowBite);

  Conf.WriteString(GateClass, 'Title', TitleName);
  Conf.WriteString(GateClass, 'ServerAddr', ServerAddr);
  Conf.WriteInteger(GateClass, 'ServerPort', ServerPort);
  Conf.WriteString(GateClass, 'GateAddr', GateAddr);
  Conf.WriteInteger(GateClass, 'GatePort', GatePort);
  Conf.WriteString(GateClass, 'CenterAddr', CenterAddr);
  Conf.WriteInteger(GateClass, 'CenterPort', CenterPort);

  Conf.WriteInteger(GateClass, 'ShowLogLevel', nShowLogLevel);
  Conf.WriteBool(GateClass, 'ShowBite', boShowBite);
  Close;
end;

end.
