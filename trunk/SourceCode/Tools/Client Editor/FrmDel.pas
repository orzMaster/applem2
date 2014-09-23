unit FrmDel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Spin;

type
  TFormDel = class(TForm)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    rbQuiteDel: TRadioButton;
    RadioButton2: TRadioButton;
    btnGo: TButton;
    btnExit: TButton;
    edtIndexStart: TSpinEdit;
    edtIndexEnd: TSpinEdit;
    procedure btnGoClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open();
  end;

var
  FormDel: TFormDel;

implementation

{$R *.dfm}

uses
  ZShare,
  FrmMain,
  wmMyImage;

{ TFormDel }

procedure TFormDel.btnGoClick(Sender: TObject);
var
  StartInt, EndInt, StartPos, EndPos, ChangePos: Integer;
  WMImages: wmMyImage.TWMMyImageImages;
begin
  if (g_WMImages = nil) or (not g_WMImages.boInitialize) or (g_WMImages.ReadOnly) or
    (not (g_WMImages is TWMMyImageImages)) then
    exit;
  edtIndexStart.Enabled := False;
  edtIndexEnd.Enabled := False;
  rbQuiteDel.Enabled := False;
  RadioButton2.Enabled := False;
  btnGo.Enabled := False;
  btnExit.Enabled := False;
  Try
    WMImages := TWMMyImageImages(g_WMImages);
    StartInt := StrToIntDef(edtIndexStart.Text, -1);
    EndInt := StrToIntDef(edtIndexEnd.Text, -1);
    if (StartInt < 0) then begin
      Application.MessageBox('数据起始编号设置错误', '提示信息', MB_OK or MB_ICONASTERISK);
      exit;
    end;
    if (EndInt < 0) then begin
      Application.MessageBox('数据结束编号设置错误', '提示信息', MB_OK or MB_ICONASTERISK);
      exit;
    end;
    if (EndInt >= g_WMImages.ImageCount) then begin
      Application.MessageBox('数据结束编号设置错误，不能大于总数据数量', '提示信息', MB_OK or MB_ICONASTERISK);
      exit;
    end;
    if (StartInt > EndInt) then begin
      Application.MessageBox('数据起始编号设置错误，不能大于结号编号', '提示信息', MB_OK or MB_ICONASTERISK);
      exit;
    end;
    StartPos := WMImages.GetDataOffset(StartInt, False);
    EndPos := WMImages.GetDataOffset(EndInt + 1, False);
    if (StartPos > 0) and (EndPos > 0) and (EndPos >= StartPos) then begin
      ChangePos := EndPos - StartPos;
      if ChangePos > 0 then begin
        RemoveData(WMImages.FileName, StartPos, ChangePos); //删除空间
      end;
      WMImages.ChangeOffsetToList(StartInt, EndInt, ChangePos, rbQuiteDel.Checked);
      g_WMImages.SaveIndexList;
      FormMain.DrawGrid.RowCount := WMImages.ImageCount div 6 + 1;
      FormMain.DrawGrid.Repaint;
      Application.MessageBox('删除数据完成', '提示信息', MB_OK or MB_ICONASTERISK);
      Close;
    end;
  Finally
    edtIndexStart.Enabled := True;
    edtIndexEnd.Enabled := True;
    rbQuiteDel.Enabled := True;
    RadioButton2.Enabled := True;
    btnGo.Enabled := True;
    btnExit.Enabled := True;
  End;
end;

procedure TFormDel.Open;
begin
  edtIndexStart.MaxValue := g_WMImages.ImageCount - 1;
  edtIndexEnd.MaxValue := g_WMImages.ImageCount - 1;
  edtIndexStart.Value := g_SelectImageIndex;
  edtIndexEnd.Value := g_SelectImageIndex;
  //FormMain.DrawGrid.cell
  ShowModal;
end;

end.

