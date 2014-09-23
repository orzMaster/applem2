unit FIDHum;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, DB, DBTables, Grids, Buttons, HumDB,
    Grobal2;
type
  TFrmIDHum = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label3: TLabel;
    EdChrName: TEdit;
    BtnCreateChr: TSpeedButton;
    BtnEraseChr: TSpeedButton;
    BtnChrNameSearch: TSpeedButton;
    ChrGrid: TStringGrid;
    BtnSelAll: TSpeedButton;
    CbShowDelChr: TCheckBox;
    BtnDeleteChr: TSpeedButton;
    BtnRevival: TSpeedButton;
    SpeedButton1: TSpeedButton;
    Button1: TButton;
    Label2: TLabel;
    EdUserId: TEdit;
    BtnDeleteChrAllInfo: TSpeedButton;
    SpeedButton2: TSpeedButton;
    LabelCount: TLabel;
    SpeedButtonEditData: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnChrNameSearchClick(Sender: TObject);
    procedure BtnSelAllClick(Sender: TObject);
    procedure BtnEraseChrClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ChrGridClick(Sender: TObject);
    procedure ChrGridDblClick(Sender: TObject);
    procedure BtnDeleteChrClick(Sender: TObject);
    procedure BtnRevivalClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure BtnCreateChrClick(Sender: TObject);
    procedure BtnDeleteChrAllInfoClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure RefChrGrid(n08: Integer; HumDBRecord: THumInfo);
    procedure EdChrNameKeyPress(Sender: TObject; var Key: Char);
    procedure EdUserIdKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButtonEditDataClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmIDHum: TFrmIDHum;

implementation

uses HUtil32, MudUtil, CreateChr, FDBexpl, EditRcd;

{$R *.DFM}

procedure TFrmIDHum.FormCreate(Sender: TObject);
begin
  Edit1.Text := '';
  Edit2.Text := '';

  ChrGrid.Cells[0, 0] := '索引号';
  ChrGrid.Cells[1, 0] := '人物名称';
  ChrGrid.Cells[2, 0] := '登录帐号';
  ChrGrid.Cells[3, 0] := '是否禁用';
  ChrGrid.Cells[4, 0] := '禁用时间';
  ChrGrid.Cells[5, 0] := '操作计数';
  ChrGrid.Cells[6, 0] := '选择编号';
  ChrGrid.Cells[7, 0] := 'GM禁用';
end;

procedure TFrmIDHum.EdUserIdKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    Key := #0;
    SpeedButton3Click(Sender);
  end;
end;

procedure TFrmIDHum.EdChrNameKeyPress(Sender: TObject; var Key: Char);
//0x004A025C
begin
  if Key = #13 then begin
    Key := #0;
    BtnChrNameSearchClick(Sender);
  end;
end;

procedure TFrmIDHum.BtnChrNameSearchClick(Sender: TObject);
var
  s64: string;
  n08, nIndex: Integer;
  HumDBRecord: THumInfo;
begin
  s64 := EdChrName.Text;
  ChrGrid.RowCount := 1;
  try
    if HumChrDB.OpenEx then begin
      n08 := HumChrDB.Index(s64);
      if n08 >= 0 then begin
        nIndex := HumChrDB.Get(n08, HumDBRecord);
        if nIndex >= 0 then begin
          if CbShowDelChr.Checked then
            RefChrGrid(nIndex, HumDBRecord)
          else if not HumDBRecord.boDeleted then
            RefChrGrid(nIndex, HumDBRecord);
        end;
      end;
    end;
  finally
    HumChrDB.Close;
  end;
end;

procedure TFrmIDHum.BtnSelAllClick(Sender: TObject);
var
  sChrName: string;
  ChrList: TStringList;
  i, nIndex: Integer;
  HumDBRecord: THumInfo;
begin
  sChrName := EdChrName.Text;
  ChrGrid.RowCount := 1;
  ChrList := TStringList.Create;
  try
    if HumChrDB.OpenEx then begin
      if HumChrDB.FindByName(sChrName, ChrList) > 0 then begin
        for i := 0 to ChrList.Count - 1 do begin
          nIndex := Integer(ChrList.Objects[i]);
          if HumChrDB.GetBy(nIndex, HumDBRecord) then begin
            if CbShowDelChr.Checked then
              RefChrGrid(nIndex, HumDBRecord)
            else if not HumDBRecord.boDeleted then
              RefChrGrid(nIndex, HumDBRecord);
          end;
        end;
      end;
    end;
  finally
    HumChrDB.Close;
  end;
  ChrList.Free;
end;

procedure TFrmIDHum.BtnEraseChrClick(Sender: TObject); //004A04DC
var
  sChrName: string;
begin
  sChrName := EdChrName.Text;
  if sChrName = '' then
    Exit;
  if MessageDlg('是否确认删除人物 ' + sChrName + ' ？', mtConfirmation, [mbYes,
    mbNo], 0) = mrYes then begin
    try
      if HumChrDB.Open then begin
        HumChrDB.Delete(sChrName);
      end;
    finally
      HumChrDB.Close;
    end;
  end;
end;

procedure TFrmIDHum.FormShow(Sender: TObject);
begin
  EdChrName.SetFocus;
end;

procedure TFrmIDHum.ChrGridClick(Sender: TObject);
var
  nRow: Integer;
begin
  nRow := ChrGrid.Row;
  if nRow < 1 then
    Exit;
  if ChrGrid.RowCount - 1 < nRow then
    Exit;
  EdChrName.Text := ChrGrid.Cells[1, nRow];
end;

procedure TFrmIDHum.ChrGridDblClick(Sender: TObject); //0x004A08C0
begin
  SpeedButtonEditDataClick(self);
end;

procedure TFrmIDHum.BtnDeleteChrClick(Sender: TObject);
var
  sChrName: string;
  nIndex: Integer;
  HumRecord: THumInfo;
begin
  sChrName := EdChrName.Text;
  if sChrName = '' then
    Exit;
  if MessageDlg('是否确认禁用人物 ' + sChrName + ' ？', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    try
      if HumChrDB.Open then begin
        nIndex := HumChrDB.Index(sChrName);
        HumChrDB.Get(nIndex, HumRecord);
        //HumRecord.boDeleted := True;
        HumRecord.boGMDeleted := True;
        HumRecord.dModDate := Now();
        Inc(HumRecord.btCount);
        HumChrDB.Update(nIndex, HumRecord);
      end;
    finally
      HumChrDB.Close;
    end;
  end;
end;

procedure TFrmIDHum.BtnRevivalClick(Sender: TObject);
//0x004A0D28
var
  sChrName: string;
  nIndex: Integer;
  HumRecord: THumInfo;
begin
  sChrName := EdChrName.Text;
  if sChrName = '' then
    Exit;
  if MessageDlg('是否确认启用人物 ' + sChrName + ' ？', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    try
      if HumChrDB.Open then begin
        nIndex := HumChrDB.Index(sChrName);
        HumChrDB.Get(nIndex, HumRecord);
        HumRecord.boDeleted := False;
        HumRecord.boGMDeleted := False;
        Inc(HumRecord.btCount);
        HumChrDB.Update(nIndex, HumRecord);
      end;
    finally
      HumChrDB.Close;
    end;
  end;
end;

procedure TFrmIDHum.SpeedButton1Click(Sender: TObject);
begin
  FrmFDBExplore.Show;
end;

procedure TFrmIDHum.BtnCreateChrClick(Sender: TObject);
var
  nCheckCode: Integer;
  HumRecord: THumInfo;
begin
  if not FrmCreateChr.IncputChrInfo then
    Exit;
  nCheckCode := 0;
  try
    if HumChrDB.Open then begin
      if HumChrDB.ChrCountOfAccount(FrmCreateChr.sUserId) < 3 then begin
        HumRecord.Header.nSelectID := FrmCreateChr.nSelectID;
        HumRecord.sChrName := FrmCreateChr.sChrName;
        HumRecord.sAccount := FrmCreateChr.sUserId;
        HumRecord.boDeleted := False;
        HumRecord.btCount := 0;
        HumRecord.Header.sName := FrmCreateChr.sChrName;
        if HumRecord.Header.sName <> '' then begin
          if not HumChrDB.Add(HumRecord) then
            nCheckCode := 2;
        end;
      end
      else
        nCheckCode := 3;
    end;
  finally
    HumChrDB.Close;
  end;
  if nCheckCode = 0 then
    ShowMessage('人物创建成功...')
  else
    ShowMessage('人物创建失败！！！')
end;

procedure TFrmIDHum.BtnDeleteChrAllInfoClick(Sender: TObject); //0x004A0610
var
  sChrName: string;
begin
  sChrName := EdChrName.Text;
  if sChrName = '' then
    Exit;
  if MessageDlg('是否确认删除人物 ' + sChrName + ' 及人物数据？', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    try
      if HumChrDB.Open then begin
        HumChrDB.Delete(sChrName);
      end;
    finally
      HumChrDB.Close;
    end;
    try
      if HumDataDB.Open then
        HumDataDB.Delete(sChrName);
    finally
      HumDataDB.Close;
    end;
  end;
end;

procedure TFrmIDHum.SpeedButton2Click(Sender: TObject); //0x004A0B64
var
  nIndex: Integer;
  HumRecord: THumInfo;
  nRow: Integer;
begin
  nRow := ChrGrid.Row;
  if nRow < 1 then
    Exit;
  if ChrGrid.RowCount - 1 < nRow then
    Exit;
  nIndex := StrToIntDef(ChrGrid.Cells[0, nRow], 0);
  if MessageDlg('是否确认禁用记录 ' + IntToStr(nIndex) + ' ？', mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then begin
    try
      if HumChrDB.Open then begin
        if HumChrDB.GetBy(nIndex, HumRecord) then begin
          HumRecord.boDeleted := True;
          HumRecord.dModDate := Now();
          Inc(HumRecord.btCount);
          HumChrDB.UpdateBy(nIndex, HumRecord);
        end;
      end;
    finally
      HumChrDB.Close;
    end;
  end;
end;

procedure TFrmIDHum.SpeedButton3Click(Sender: TObject);
var
  sAccount: string;
  ChrList: TStringList;
  i, nIndex: Integer;
  HumDBRecord: THumInfo;
begin
  sAccount := EdUserId.Text;
  ChrGrid.RowCount := 1;
  if sAccount <> '' then begin
    ChrList := TStringList.Create;
    try
      if HumChrDB.OpenEx then begin
        HumChrDB.FindByAccount(sAccount, ChrList);
        for i := 0 to ChrList.Count - 1 do begin
          nIndex := pTQuickID(ChrList.Objects[i]).nIndex;
          if nIndex >= 0 then begin
            HumChrDB.GetBy(nIndex, HumDBRecord);
            if CbShowDelChr.Checked then
              RefChrGrid(nIndex, HumDBRecord)
            else if not HumDBRecord.boDeleted then
              RefChrGrid(nIndex, HumDBRecord);
          end;
        end;
      end;
    finally
      HumChrDB.Close;
    end;
    ChrList.Free;
  end;
end;

procedure TFrmIDHum.RefChrGrid(n08: Integer; HumDBRecord: THumInfo); //0x004A00C4
const
  IsHeroName: array[Boolean] of string = ('', '英雄');
var
  nRowCount: Integer;
begin
  ChrGrid.RowCount := ChrGrid.RowCount + 1;
  ChrGrid.FixedRows := 1;
  nRowCount := ChrGrid.RowCount - 1;
  ChrGrid.Cells[0, nRowCount] := IntToStr(n08);
  ChrGrid.Cells[1, nRowCount] := HumDBRecord.sChrName;
  ChrGrid.Cells[2, nRowCount] := HumDBRecord.sAccount;
  ChrGrid.Cells[3, nRowCount] := BoolToStr(HumDBRecord.boDeleted);
  if HumDBRecord.boDeleted then
    ChrGrid.Cells[4, nRowCount] := DateTimeToStr(HumDBRecord.dModDate)
  else
    ChrGrid.Cells[4, nRowCount] := '';

  ChrGrid.Cells[5, nRowCount] := IntToStr(HumDBRecord.btCount);
  ChrGrid.Cells[6, nRowCount] := IntToStr(HumDBRecord.Header.nSelectID);
  ChrGrid.Cells[7, nRowCount] := BoolToStr(HumDBRecord.boGMDeleted);
  LabelCount.Caption := IntToStr(ChrGrid.RowCount - 1);
end;

procedure TFrmIDHum.SpeedButtonEditDataClick(Sender: TObject);
var
  nRow, nIdx: Integer;
  sName: string;
  ChrRecord: THumDataInfo;
  boOpen: Boolean;
begin
  sName := '';
  nRow := ChrGrid.Row;
  boOpen := False;
  if (nRow >= 1) and (ChrGrid.RowCount - 1 >= nRow) then
    sName := ChrGrid.Cells[1, nRow];
  if sName = '' then
    Exit;
  try
    if HumDataDB.OpenEx then begin
      nIdx := HumDataDB.Index(sName);
      if nIdx >= 0 then begin
        if HumDataDB.Get(nIdx, ChrRecord) >= 0 then begin
          frmEditRcd.m_nIdx := nIdx;
          frmEditRcd.m_ChrRcd := ChrRecord;
          boOpen := True;
        end;
      end;
    end;
  finally
    HumDataDB.Close;
  end;
  if boOpen then begin
    frmEditRcd.Left := FrmIDHum.Left + 50;
    frmEditRcd.Top := FrmIDHum.Top + 50;
    frmEditRcd.Open;
  end;
end;

end.
