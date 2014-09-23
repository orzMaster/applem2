unit DlgConfig;

interface

uses
  Classes, Controls, Forms,
  StdCtrls, Spin, ComCtrls, HGEGUI;

type
  TfrmDlgConfig = class(TForm)
    GroupBox1: TGroupBox;
    GameWindowName: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EditTop: TSpinEdit;
    EditLeft: TSpinEdit;
    EditHeight: TSpinEdit;
    EditWidth: TSpinEdit;
    EditImage: TSpinEdit;
    ButtonShow: TButton;
    TreeView: TTreeView;
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure ButtonShowClick(Sender: TObject);
    procedure EditImageChange(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open();
    procedure RefWindowsList();
    procedure RefWindowsListChild(TreeNode: TTreeNode; DControl: TDControl);
  end;

var
  frmDlgConfig: TfrmDlgConfig;
  sXML1: string = 'MS';
  sXML8: string = 'ET';

implementation
uses
  MShare;

var
  DefDControl: TDControl;

{$R *.dfm}

  { TfrmDlgConfig }

procedure TfrmDlgConfig.ButtonShowClick(Sender: TObject);
begin
  if DefDControl <> nil then
    DefDControl.Visible := not DefDControl.Visible;
end;

procedure TfrmDlgConfig.EditImageChange(Sender: TObject);
begin
  if DefDControl = nil then
    Exit;
  if Sender = EditTop then
    DefDControl.Top := EditTop.Value
  else if Sender = EditLeft then
    DefDControl.Left := EditLeft.Value
  else if Sender = EditHeight then
    DefDControl.Height := EditHeight.Value
  else if Sender = EditWidth then
    DefDControl.Width := EditWidth.Value
  else if Sender = EditImage then
    DefDControl.FaceIndex := EditImage.Value;
end;

procedure TfrmDlgConfig.Open;
begin
  DefDControl := nil;
  RefWindowsList();
  Show;
end;

procedure TfrmDlgConfig.RefWindowsList();
var
  i: Integer;
  DControl: TDControl;
begin
  TreeView.Items.Clear;
  for i := g_DWinMan.DWinList.Count - 1 downto 0 do begin
    DControl := g_DWinMan.DWinList.Items[i];
    RefWindowsListChild(nil, DControl);
  end;
end;

procedure TfrmDlgConfig.RefWindowsListChild(TreeNode: TTreeNode;
  DControl: TDControl);
var
  i: Integer;
  TempTreeNode: TTreeNode;
  TempDControl: TDControl;
begin
  for i := 0 to DControl.DControls.Count - 1 do begin
    TempDControl := DControl.DControls.Items[i];
    {if TempDControl.Caption = '' then
      TempTreeNode := TreeView.Items.AddChildObjectFirst(TreeNode,
        TempDControl.Name, TObject(TempDControl))
    else    }
    TempTreeNode := TreeView.Items.AddChildObjectFirst(TreeNode,
        TempDControl.Caption + '(' + TempDControl.Name + ')', TObject(TempDControl));
    RefWindowsListChild(TempTreeNode, TempDControl);
  end;
end;

procedure TfrmDlgConfig.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  if Node <> nil then begin
    DefDControl := Node.Data;
    EditTop.Value := DefDControl.Top;
    EditLeft.Value := DefDControl.Left;
    EditHeight.Value := DefDControl.Height;
    EditWidth.Value := DefDControl.Width;
    EditImage.Value := DefDControl.FaceIndex;
  end;
end;

end.
