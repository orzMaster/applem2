unit EditRcd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grobal2, ComCtrls, StdCtrls, Spin, HumDB, DBShare;

type
  TfrmEditRcd = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditChrName: TEdit;
    Label2: TLabel;
    EditAccount: TEdit;
    Label3: TLabel;
    EditPassword: TEdit;
    GroupBox2: TGroupBox;
    Label11: TLabel;
    EditIdx: TEdit;
    Label12: TLabel;
    EditCurMap: TEdit;
    Label13: TLabel;
    EditCurX: TSpinEdit;
    EditCurY: TSpinEdit;
    Label14: TLabel;
    Label15: TLabel;
    EditHomeMap: TEdit;
    EditHomeX: TSpinEdit;
    EditHomeY: TSpinEdit;
    GroupBox3: TGroupBox;
    ListViewMagic: TListView;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    ListViewStorage: TListView;
    ButtonSaveData: TButton;
    ButtonExportData: TButton;
    ButtonImportData: TButton;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    EditLevel: TSpinEdit;
    Label6: TLabel;
    Label7: TLabel;
    EditGold: TSpinEdit;
    Label8: TLabel;
    EditGameGold: TSpinEdit;
    EditGamePoint: TSpinEdit;
    Label9: TLabel;
    Label16: TLabel;
    EditCreditPoint: TSpinEdit;
    EditPKPoint: TSpinEdit;
    Label17: TLabel;
    Label18: TLabel;
    EditPullulation: TSpinEdit;
    EditExpRate: TSpinEdit;
    EditExpTime: TSpinEdit;
    Label20: TLabel;
    Label19: TLabel;
    EditDieMap: TEdit;
    Label33: TLabel;
    Label34: TLabel;
    EditDieX: TSpinEdit;
    EditDieY: TSpinEdit;
    EditGameDiamond: TSpinEdit;
    Label35: TLabel;
    Label36: TLabel;
    EditGameGird: TSpinEdit;
    CheckBoxChangeName: TCheckBox;
    EditExp: TSpinEdit;
    Label37: TLabel;
    EditMaxExp: TSpinEdit;
    Label38: TLabel;
    EditDBIdx: TEdit;
    TabSheet6: TTabSheet;
    EditCreateTime: TEdit;
    Label5: TLabel;
    EditLoginTime: TEdit;
    Label32: TLabel;
    EditBindGold: TSpinEdit;
    Label10: TLabel;
    EditStorageGold: TSpinEdit;
    Label21: TLabel;
    GroupBox7: TGroupBox;
    EditDearName: TEdit;
    Label4: TLabel;
    GroupBox8: TGroupBox;
    Label39: TLabel;
    EditMasterName1: TEdit;
    CheckBoxIsMaster: TCheckBox;
    EditMasterName2: TEdit;
    Label40: TLabel;
    EditMasterName3: TEdit;
    Label41: TLabel;
    EditMasterName4: TEdit;
    Label42: TLabel;
    EditMasterName5: TEdit;
    Label43: TLabel;
    EditMasterName6: TEdit;
    Label44: TLabel;
    EditMasterName7: TEdit;
    Label45: TLabel;
    GroupBox9: TGroupBox;
    ListBoxFirend: TListBox;
    GroupBox12: TGroupBox;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    EditC0: TSpinEdit;
    EditC1: TSpinEdit;
    EditC2: TSpinEdit;
    EditC3: TSpinEdit;
    EditC4: TSpinEdit;
    EditC5: TSpinEdit;
    EditC6: TSpinEdit;
    EditC7: TSpinEdit;
    EditC8: TSpinEdit;
    EditC9: TSpinEdit;
    EditC10: TSpinEdit;
    EditC11: TSpinEdit;
    EditC12: TSpinEdit;
    EditC13: TSpinEdit;
    EditC14: TSpinEdit;
    EditC15: TSpinEdit;
    EditC16: TSpinEdit;
    EditC17: TSpinEdit;
    EditC18: TSpinEdit;
    EditC19: TSpinEdit;
    GroupBox11: TGroupBox;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    EditNakedAC: TEdit;
    EditNakedMAC: TEdit;
    EditNakedDC: TEdit;
    EditNakedMC: TEdit;
    EditNakedSC: TEdit;
    EditNakedHP: TEdit;
    EditNakedPoint: TEdit;
    GroupBox6: TGroupBox;
    ListViewMakeMagic: TListView;
    Label22: TLabel;
    EditMakeMagic: TSpinEdit;
    TabSheet7: TTabSheet;
    GroupBox10: TGroupBox;
    ListViewBagItem: TListView;
    ListViewUserItem: TListView;
    procedure ButtonExportDataClick(Sender: TObject);
    procedure EditPasswordChange(Sender: TObject);
  private
    m_boOpened: Boolean;
    procedure RefShow();
    procedure RefShowRcd();
    procedure RefShowMagic();
    procedure RefShowUserItem();
    procedure RefShowBagItem();
    procedure RefShowStorage();
    procedure ProcessSaveRcdToFile();
    procedure ProcessLoadRcdformFile();
    procedure ProcessSaveRcd();
    { Private declarations }
  public
    m_ChrRcd: THumDataInfo;
    m_nIdx: Integer;
    procedure Open();
    { Public declarations }
  end;

var
  frmEditRcd: TfrmEditRcd;

implementation

{$R *.dfm}

{ TfrmEditRcd }

procedure TfrmEditRcd.RefShowRcd;
var
  I: Integer;
begin
  EditIdx.Text := IntToStr(m_nIdx);
  EditDBIdx.Text := IntToStr(m_ChrRcd.Data.nIdx);
  EditChrName.Text := m_ChrRcd.Data.sChrName;
  CheckBoxChangeName.Checked := m_ChrRcd.Data.boChangeName;
  EditAccount.Text := m_ChrRcd.Data.sAccount;

  EditCurMap.Text := m_ChrRcd.Data.sCurMap;
  EditCurX.Value := m_ChrRcd.Data.wCurX;
  EditCurY.Value := m_ChrRcd.Data.wCurY;

  EditHomeMap.Text := m_ChrRcd.Data.sHomeMap;
  EditHomeX.Value := m_ChrRcd.Data.wHomeX;
  EditHomeY.Value := m_ChrRcd.Data.wHomeY;

  EditDieMap.Text := m_ChrRcd.Data.sDieMap;
  EditDieX.Value := m_ChrRcd.Data.wDieX;
  EditDieY.Value := m_ChrRcd.Data.wDieY;

  EditCreateTime.Text := ForMatDateTime('yyyy-mm-dd hh:mm:ss', m_ChrRcd.Header.dwCreateDate);
  EditLoginTime.Text := ForMatDateTime('yyyy-mm-dd hh:mm:ss', m_ChrRcd.Header.dwUpdateDate);

  EditLevel.Value := m_ChrRcd.Data.Abil.Level;
  EditExp.Value := m_ChrRcd.Data.Abil.Exp;
  EditMaxExp.Value := m_ChrRcd.Data.Abil.MaxExp;
  EditGold.Value := m_ChrRcd.Data.nGold;
  EditGameGold.Value := m_ChrRcd.Data.nGameGold;
  EditGamePoint.Value := m_ChrRcd.Data.nGamePoint;
  EditGameDiamond.Value := m_ChrRcd.Data.nGameDiamond;
  EditGameGird.Value := m_ChrRcd.Data.nGameGird;
  EditCreditPoint.Value := m_ChrRcd.Data.btCreditPoint;
  EditPullulation.Value := m_ChrRcd.Data.nPullulation div MIDPULLULATION;
  EditPKPoint.Value := m_ChrRcd.Data.nPKPoint;

  EditExpRate.Value := m_ChrRcd.Data.nExpRate;
  EditExpTime.Value := m_ChrRcd.Data.nExpTime;


  EditPassword.Text := m_ChrRcd.Data.sStoragePwd;

  EditBindGold.Value := m_ChrRcd.Data.nBindGold;
  EditStorageGold.Value := m_ChrRcd.Data.nStorageGold;
  
  EditDearName.Text := m_ChrRcd.Data.sDearName;

  CheckBoxIsMaster.Checked := m_ChrRcd.Data.boMaster;
  EditMasterName1.Text := m_ChrRcd.Data.MasterName[0];
  if CheckBoxIsMaster.Checked then begin
    Label39.Caption := '徒弟一:';
    EditMasterName2.Text := m_ChrRcd.Data.MasterName[1];
    EditMasterName3.Text := m_ChrRcd.Data.MasterName[2];
    EditMasterName4.Text := m_ChrRcd.Data.MasterName[3];
    EditMasterName5.Text := m_ChrRcd.Data.MasterName[4];
    EditMasterName6.Text := m_ChrRcd.Data.MasterName[5];
    EditMasterName7.Text := m_ChrRcd.Data.MasterName[6];
  end else begin
    Label39.Caption := '师父名称:';
  end;

  ListBoxFirend.Items.Clear;
  for I := Low(m_ChrRcd.Data.FriendList) to High(m_ChrRcd.Data.FriendList) do begin
    if Trim(m_ChrRcd.Data.FriendList[I].sChrName) <> '' then
      ListBoxFirend.Items.Add(m_ChrRcd.Data.FriendList[I].sChrName);
  end;



  EditNakedAc.Text := IntToStr(m_ChrRcd.Data.NakedAbil.nAc);
  EditNakedMAc.Text := IntToStr(m_ChrRcd.Data.NakedAbil.nMAc);
  EditNakedDc.Text := IntToStr(m_ChrRcd.Data.NakedAbil.nDc);
  EditNakedMc.Text := IntToStr(m_ChrRcd.Data.NakedAbil.nMc);
  EditNakedSc.Text := IntToStr(m_ChrRcd.Data.NakedAbil.nSc);
  EditNakedHP.Text := IntToStr(m_ChrRcd.Data.NakedAbil.nHP);
  EditNakedPoint.Text := IntToStr(m_ChrRcd.Data.nNakedAbilCount) + '/' + IntToStr(m_ChrRcd.Data.wNakedBackCount);

  EditC0.Value := m_ChrRcd.Data.CustomVariable[0];
  EditC1.Value := m_ChrRcd.Data.CustomVariable[1];
  EditC2.Value := m_ChrRcd.Data.CustomVariable[2];
  EditC3.Value := m_ChrRcd.Data.CustomVariable[3];
  EditC4.Value := m_ChrRcd.Data.CustomVariable[4];
  EditC5.Value := m_ChrRcd.Data.CustomVariable[5];
  EditC6.Value := m_ChrRcd.Data.CustomVariable[6];
  EditC7.Value := m_ChrRcd.Data.CustomVariable[7];
  EditC8.Value := m_ChrRcd.Data.CustomVariable[8];
  EditC9.Value := m_ChrRcd.Data.CustomVariable[9];
  EditC10.Value := m_ChrRcd.Data.CustomVariable[10];
  EditC11.Value := m_ChrRcd.Data.CustomVariable[11];
  EditC12.Value := m_ChrRcd.Data.CustomVariable[12];
  EditC13.Value := m_ChrRcd.Data.CustomVariable[13];
  EditC14.Value := m_ChrRcd.Data.CustomVariable[14];
  EditC15.Value := m_ChrRcd.Data.CustomVariable[15];
  EditC16.Value := m_ChrRcd.Data.CustomVariable[16];
  EditC17.Value := m_ChrRcd.Data.CustomVariable[17];
  EditC18.Value := m_ChrRcd.Data.CustomVariable[18];
  EditC19.Value := m_ChrRcd.Data.CustomVariable[19];
end;

procedure TfrmEditRcd.Open;
begin
  RefShow();
  Caption := format('编辑人物数据 [%s]', [m_ChrRcd.Data.sChrName]);
  PageControl.ActivePageIndex := 0;
  ShowModal;
end;

procedure TfrmEditRcd.RefShow;
begin
  m_boOpened := False;
  RefShowRcd();
  RefShowMagic();
  RefShowUserItem();
  RefShowBagItem();
  RefShowStorage();
  m_boOpened := True;
end;

procedure TfrmEditRcd.RefShowBagItem;
var
  i: Integer;
  ListItem: TListItem;
  UserItem: TUserItem;
begin
  ListViewBagItem.Clear;
  for i := Low(m_ChrRcd.Data.BagItems) to High(m_ChrRcd.Data.BagItems) do begin
    UserItem := m_ChrRcd.Data.BagItems[i];
    if (UserItem.wIndex <= 0) or (UserItem.MakeIndex <= 0) then break;
    ListItem := ListViewBagItem.Items.Add;
    ListItem.Caption := IntToStr(I);
    ListItem.SubItems.Add(IntToStr(UserItem.MakeIndex));
    ListItem.SubItems.Add(GetStdItemName(UserItem.wIndex));
    ListItem.SubItems.Add(format('%d/%d', [UserItem.Dura, UserItem.DuraMax]));
    ListItem.SubItems.Add('0');
  end;
end;

procedure TfrmEditRcd.RefShowMagic;
var
  i: Integer;
  ListItem: TListItem;
  MagicInfo: THumMagic;
begin
  ListViewMagic.Clear;
  for i := Low(m_ChrRcd.Data.HumMagics) to High(m_ChrRcd.Data.HumMagics) do begin
    MagicInfo := m_ChrRcd.Data.HumMagics[i];
    if MagicInfo.wMagIdx = 0 then break;
    ListItem := ListViewMagic.Items.Add;
    ListItem.Caption := IntToStr(MagicInfo.wMagIdx);
    ListItem.SubItems.Add(GetMagicName(MagicInfo.wMagIdx));
    ListItem.SubItems.Add(IntToStr(MagicInfo.btLevel));
    ListItem.SubItems.Add(IntToStr(MagicInfo.nTranPoint));
  end;
  EditMakeMagic.Value := m_ChrRcd.Data.MakeMagicPoint;
  for i := Low(m_ChrRcd.Data.MakeMagic) to High(m_ChrRcd.Data.MakeMagic) do begin
    ListItem := ListViewMakeMagic.Items[i];
    ListItem.SubItems.Strings[0] := IntToStr(m_ChrRcd.Data.MakeMagic[i]);
  end;
end;

procedure TfrmEditRcd.RefShowUserItem;
var
  i: Integer;
  ListItem: TListItem;
  UserItem: TUserItem;
const
  Names: array[0..14] of String[6] = ('衣服', '武器', '头盔', '项链', '照明物', '左手镯', '右手镯', '左戒指', '右戒指', '符毒', '腰带', '靴子', '宝石', '马牌', '道具');
begin
  ListViewUserItem.Clear;
  for i := Low(m_ChrRcd.Data.HumItems) to High(m_ChrRcd.Data.HumItems) do begin
    if I > High(Names) then Break;
    ListItem := ListViewUserItem.Items.Add;
    ListItem.Caption := Names[i];
    ListItem.SubItems.Add('0');
    ListItem.SubItems.Add('0');
    ListItem.SubItems.Add('0');
    ListItem.SubItems.Add('0');

    UserItem := m_ChrRcd.Data.HumItems[i];
    if UserItem.wIndex <= 0 then Continue;
    ListItem.SubItems[0] := IntToStr(UserItem.MakeIndex);
    ListItem.SubItems[1] := GetStdItemName(UserItem.wIndex);
    ListItem.SubItems[2] := format('%d/%d', [UserItem.Dura, UserItem.DuraMax])
  end;
end;

procedure TfrmEditRcd.RefShowStorage;
var
  i: Integer;
  ListItem: TListItem;
  UserItem: TUserItem;
begin
  ListViewStorage.Clear;
  for i := Low(m_ChrRcd.Data.StorageItems) to High(m_ChrRcd.Data.StorageItems) do begin
    UserItem := m_ChrRcd.Data.StorageItems[i].UserItem;
    if (UserItem.wIndex <= 0) or (UserItem.MakeIndex <= 0) then break;
    ListItem := ListViewStorage.Items.Add;
    ListItem.Caption := '0/' + IntToStr(I);
    ListItem.SubItems.Add(IntToStr(UserItem.MakeIndex));
    ListItem.SubItems.Add(GetStdItemName(UserItem.wIndex));
    ListItem.SubItems.Add(format('%d/%d', [UserItem.Dura, UserItem.DuraMax]));
    ListItem.SubItems.Add('0');
  end;
  for i := Low(m_ChrRcd.Data.StorageItems2) to High(m_ChrRcd.Data.StorageItems2) do begin
    UserItem := m_ChrRcd.Data.StorageItems2[i].UserItem;
    if (UserItem.wIndex <= 0) or (UserItem.MakeIndex <= 0) then break;
    ListItem := ListViewStorage.Items.Add;
    ListItem.Caption := '0/' + IntToStr(I);
    ListItem.SubItems.Add(IntToStr(UserItem.MakeIndex));
    ListItem.SubItems.Add(GetStdItemName(UserItem.wIndex));
    ListItem.SubItems.Add(format('%d/%d', [UserItem.Dura, UserItem.DuraMax]));
    ListItem.SubItems.Add('0');
  end;
  for i := Low(m_ChrRcd.Data.StorageItems3) to High(m_ChrRcd.Data.StorageItems3) do begin
    UserItem := m_ChrRcd.Data.StorageItems3[i].UserItem;
    if (UserItem.wIndex <= 0) or (UserItem.MakeIndex <= 0) then break;
    ListItem := ListViewStorage.Items.Add;
    ListItem.Caption := '0/' + IntToStr(I);
    ListItem.SubItems.Add(IntToStr(UserItem.MakeIndex));
    ListItem.SubItems.Add(GetStdItemName(UserItem.wIndex));
    ListItem.SubItems.Add(format('%d/%d', [UserItem.Dura, UserItem.DuraMax]));
    ListItem.SubItems.Add('0');
  end;
end;

procedure TfrmEditRcd.ButtonExportDataClick(Sender: TObject);
begin
  if Sender = ButtonExportData then begin
    ProcessSaveRcdToFile();
  end
  else if Sender = ButtonImportData then begin
    ProcessLoadRcdformFile();
  end
  else if Sender = ButtonSaveData then begin
    ProcessSaveRcd();
  end;
end;

procedure TfrmEditRcd.ProcessSaveRcdToFile;
var
  sSaveFileName: string;
  nFileHandle: Integer;
begin
  SaveDialog.FileName := m_ChrRcd.Data.sChrName;
  SaveDialog.InitialDir := '.\';
  if not SaveDialog.Execute then Exit;
  sSaveFileName := SaveDialog.FileName;
  if FileExists(sSaveFileName) then
    nFileHandle := FileOpen(sSaveFileName, fmOpenReadWrite or fmShareDenyNone)
  else
    nFileHandle := FileCreate(sSaveFileName);
  if nFileHandle <= 0 then begin
    MessageBox(Handle, '保存文件出现错误！！！', '错误信息', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;
  FileWrite(nFileHandle, m_ChrRcd, SizeOf(THumDataInfo));
  FileClose(nFileHandle);
  MessageBox(Handle, '人物数据导出成功！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmEditRcd.ProcessLoadRcdformFile;
var
  sLoadFileName: string;
  nFileHandle: Integer;
  ChrRcd: THumDataInfo;
begin
  OpenDialog.FileName := m_ChrRcd.Data.sChrName;
  OpenDialog.InitialDir := '.\';
  if not OpenDialog.Execute then Exit;
  sLoadFileName := OpenDialog.FileName;

  if not FileExists(sLoadFileName) then begin
    MessageBox(Handle, '指定的文件未找到！！！', '错误信息', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;
  nFileHandle := FileOpen(sLoadFileName, fmOpenReadWrite or fmShareDenyNone);

  if nFileHandle <= 0 then begin
    MessageBox(Handle, '打开文件出现错误！！！', '错误信息', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;
  if not FileRead(nFileHandle, ChrRcd, SizeOf(THumDataInfo)) = SizeOf(THumDataInfo) then begin
    MessageBox(Handle, '读取文件出现错误！！！'#13#13'文件格式可能不正确', '错误信息', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;
  ChrRcd.Header := m_ChrRcd.Header;
  ChrRcd.Data.sChrName := m_ChrRcd.Data.sChrName;
  ChrRcd.Data.sAccount := m_ChrRcd.Data.sAccount;
  FillChar(m_ChrRcd.Data.FriendList, SizeOf(THumanFriends), #0);
  m_ChrRcd := ChrRcd;
  FileClose(nFileHandle);
  RefShow();
  MessageBox(Handle, '人物数据导入成功！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmEditRcd.ProcessSaveRcd;
var
  nIdx: Integer;
  boSaveOK: Boolean;
begin
  boSaveOK := False;
  try
    if HumDataDB.Open then begin
      nIdx := HumDataDB.Index(m_ChrRcd.Header.sName);
      if (nIdx >= 0) then begin
        HumDataDB.Update(nIdx, m_ChrRcd);
        boSaveOK := True;
      end;
    end;
  finally
    HumDataDB.Close;
  end;
  if boSaveOK then begin
    MessageBox(Handle, '人物数据保存成功！！！', '提示信息', MB_OK + MB_ICONINFORMATION);
  end
  else begin
    MessageBox(Handle, '人物数据保存失败！！！', '错误信息', MB_OK + MB_ICONEXCLAMATION);
  end;
end;

procedure TfrmEditRcd.EditPasswordChange(Sender: TObject);
begin
  if not m_boOpened then
    Exit;

  if Sender = EditCurMap then begin
    m_ChrRcd.Data.sCurMap := Trim(EditCurMap.Text);
  end
  else if Sender = EditCurX then begin
    m_ChrRcd.Data.wCurX := EditCurX.Value;
  end
  else if Sender = EditCurY then begin
    m_ChrRcd.Data.wCurY := EditCurY.Value;
  end
  else if Sender = EditHomeMap then begin
    m_ChrRcd.Data.sHomeMap := Trim(EditHomeMap.Text);
  end
  else if Sender = EditHomeX then begin
    m_ChrRcd.Data.wHomeX := EditHomeX.Value;
  end
  else if Sender = EditHomeY then begin
    m_ChrRcd.Data.wHomeY := EditHomeY.Value;
  end
  else if Sender = EditDieMap then begin
    m_ChrRcd.Data.sDieMap := Trim(EditDieMap.Text);
  end
  else if Sender = EditDieX then begin
    m_ChrRcd.Data.wDieX := EditDieX.Value;
  end
  else if Sender = EditDieY then begin
    m_ChrRcd.Data.wDieY := EditDieY.Value;
  end
  else if Sender = EditLevel then begin
    m_ChrRcd.Data.Abil.Level := EditLevel.Value;
  end
  else if Sender = EditExp then begin
    m_ChrRcd.Data.Abil.Exp := EditExp.Value;
  end
  else if Sender = EditGold then begin
    m_ChrRcd.Data.nGold := EditGold.Value;
  end
  else if Sender = EditGameGold then begin
    m_ChrRcd.Data.nGameGold := EditGameGold.Value;
  end
  else if Sender = EditGameDiamond then begin
    m_ChrRcd.Data.nGameDiamond := EditGameDiamond.Value;
  end
  else if Sender = EditGameGird then begin
    m_ChrRcd.Data.nGameGird := EditGameGird.Value;
  end
  else if Sender = EditCreditPoint then begin
    m_ChrRcd.Data.btCreditPoint := EditCreditPoint.Value;
  end
  else if Sender = EditPullulation then begin
    m_ChrRcd.Data.nPullulation := EditPullulation.Value * MIDPULLULATION;
  end
  else if Sender = EditPKPoint then begin
    m_ChrRcd.Data.nPKPoint := EditPKPoint.Value;
  end

  else if Sender = EditExpRate then begin
    m_ChrRcd.Data.nExpRate := EditExpRate.Value;
  end
  else if Sender = EditExpTime then begin
    m_ChrRcd.Data.nExpTime := EditExpTime.Value;
  end
  else if Sender = EditPassword then begin
    m_ChrRcd.Data.sStoragePwd := Trim(EditPassword.Text);
  end
  else if Sender = EditBindGold then begin
    m_ChrRcd.Data.nBindGold := EditBindGold.Value;
  end
  else if Sender = EditStorageGold then begin
    m_ChrRcd.Data.nStorageGold := EditStorageGold.Value;
  end
  else if Sender = EditC0 then begin
    m_ChrRcd.Data.CustomVariable[0] := EditC0.Value;
  end
  else if Sender = EditC1 then begin
    m_ChrRcd.Data.CustomVariable[1] := EditC1.Value;
  end
  else if Sender = EditC2 then begin
    m_ChrRcd.Data.CustomVariable[2] := EditC2.Value;
  end
  else if Sender = EditC3 then begin
    m_ChrRcd.Data.CustomVariable[3] := EditC3.Value;
  end
  else if Sender = EditC4 then begin
    m_ChrRcd.Data.CustomVariable[4] := EditC4.Value;
  end
  else if Sender = EditC5 then begin
    m_ChrRcd.Data.CustomVariable[5] := EditC5.Value;
  end
  else if Sender = EditC6 then begin
    m_ChrRcd.Data.CustomVariable[6] := EditC6.Value;
  end
  else if Sender = EditC7 then begin
    m_ChrRcd.Data.CustomVariable[7] := EditC7.Value;
  end
  else if Sender = EditC8 then begin
    m_ChrRcd.Data.CustomVariable[8] := EditC8.Value;
  end
  else if Sender = EditC9 then begin
    m_ChrRcd.Data.CustomVariable[9] := EditC9.Value;
  end
  else if Sender = EditC10 then begin
    m_ChrRcd.Data.CustomVariable[10] := EditC10.Value;
  end
  else if Sender = EditC11 then begin
    m_ChrRcd.Data.CustomVariable[11] := EditC11.Value;
  end
  else if Sender = EditC12 then begin
    m_ChrRcd.Data.CustomVariable[12] := EditC12.Value;
  end
  else if Sender = EditC13 then begin
    m_ChrRcd.Data.CustomVariable[13] := EditC13.Value;
  end
  else if Sender = EditC14 then begin
    m_ChrRcd.Data.CustomVariable[14] := EditC14.Value;
  end
  else if Sender = EditC15 then begin
    m_ChrRcd.Data.CustomVariable[15] := EditC15.Value;
  end
  else if Sender = EditC16 then begin
    m_ChrRcd.Data.CustomVariable[16] := EditC16.Value;
  end
  else if Sender = EditC17 then begin
    m_ChrRcd.Data.CustomVariable[17] := EditC17.Value;
  end
  else if Sender = EditC18 then begin
    m_ChrRcd.Data.CustomVariable[18] := EditC18.Value;
  end
  else if Sender = EditC19 then begin
    m_ChrRcd.Data.CustomVariable[19] := EditC19.Value;
  end
  else if Sender = EditMakeMagic then begin
    m_ChrRcd.Data.MakeMagicPoint := EditMakeMagic.Value;
  end
  else if Sender = EditDearName then begin
    m_ChrRcd.Data.sDearName := Trim(EditDearName.Text);
  end
  else if Sender = CheckBoxIsMaster then begin
    m_ChrRcd.Data.boMaster := CheckBoxIsMaster.Checked;
  end
  else if Sender = EditMasterName1 then begin
    m_ChrRcd.Data.MasterName[0] := Trim(EditMasterName1.Text);
  end
  else if Sender = EditMasterName2 then begin
    m_ChrRcd.Data.MasterName[1] := Trim(EditMasterName2.Text);
  end
  else if Sender = EditMasterName3 then begin
    m_ChrRcd.Data.MasterName[2] := Trim(EditMasterName3.Text);
  end
  else if Sender = EditMasterName4 then begin
    m_ChrRcd.Data.MasterName[3] := Trim(EditMasterName4.Text);
  end
  else if Sender = EditMasterName5 then begin
    m_ChrRcd.Data.MasterName[4] := Trim(EditMasterName5.Text);
  end
  else if Sender = EditMasterName6 then begin
    m_ChrRcd.Data.MasterName[5] := Trim(EditMasterName6.Text);
  end
  else if Sender = EditMasterName7 then begin
    m_ChrRcd.Data.MasterName[6] := Trim(EditMasterName7.Text);
  end
end;

end.
