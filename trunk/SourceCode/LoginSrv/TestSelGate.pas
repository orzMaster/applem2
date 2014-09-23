unit TestSelGate;

interface

uses
  SysUtils, Classes, Controls, Forms,
  StdCtrls;

type
  TfrmTestSelGate = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditSelGate: TEdit;
    Label2: TLabel;
    EditGameGate: TEdit;
    ButtonTest: TButton;
    Button1: TButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    procedure ButtonTestClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    
  public
    
  end;

var
  frmTestSelGate: TfrmTestSelGate;

implementation

uses LMain, LSShare, RouteManage;

{$R *.dfm}

procedure TfrmTestSelGate.ButtonTestClick(Sender: TObject);
var
  sSelGateIPaddr: string;
  sGameGateIPaddr: string;
  nGameGatePort: Integer;
begin
  sSelGateIPaddr := Trim(EditSelGate.Text);
  sGameGateIPaddr := GetSelGateInfo(@g_Config, sSelGateIPaddr, nGameGatePort);
  if sGameGateIPaddr = '' then begin
    EditGameGate.Text := '无此网关设置';
    Exit;
  end;
  EditGameGate.Text := format('%s:%d', [sGameGateIPaddr, nGameGatePort]);
end;

procedure TfrmTestSelGate.Button1Click(Sender: TObject);
begin
  frmRouteManage.Open;
end;

end.
