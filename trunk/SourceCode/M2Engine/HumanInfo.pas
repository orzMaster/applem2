unit HumanInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ObjBase, StdCtrls, Spin, ComCtrls, ExtCtrls, Grids, ObjPlay;

type
  TfrmHumanInfo = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    EditName: TEdit;
    EditMap: TEdit;
    EditXY: TEdit;
    EditAccount: TEdit;
    EditIPaddr: TEdit;
    EditLogonTime: TEdit;
    EditLogonLong: TEdit;
    GroupBox2: TGroupBox;
    Label12: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    EditLevel: TSpinEdit;
    EditGold: TSpinEdit;
    EditBindGold: TSpinEdit;
    EditExp: TSpinEdit;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    Timer: TTimer;
    GroupBox4: TGroupBox;
    CheckBoxMonitor: TCheckBox;
    GroupBox5: TGroupBox;
    EditHumanStatus: TEdit;
    ButtonKick: TButton;
    GroupBox7: TGroupBox;
    GroupBox9: TGroupBox;
    LabelGameGold: TLabel;
    LabelGamePoint: TLabel;
    LabelGameDiamond: TLabel;
    EditGameGold: TSpinEdit;
    EditGamePoint: TSpinEdit;
    EditCreditPoint: TSpinEdit;
    ButtonSave: TButton;
    GridUserItem: TStringGrid;
    GroupBox8: TGroupBox;
    GridBagItem: TStringGrid;
    GroupBox10: TGroupBox;
    GridStorageItem: TStringGrid;
    Label21: TLabel;
    EditMaxExp: TSpinEdit;
    GroupBox3: TGroupBox;
    Label11: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    EditAC: TEdit;
    EditMAC: TEdit;
    EditDC: TEdit;
    EditMC: TEdit;
    EditSC: TEdit;
    EditHP: TEdit;
    EditMP: TEdit;
    GroupBox11: TGroupBox;
    Label20: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    EditNakedAC: TEdit;
    EditNakedMAC: TEdit;
    EditNakedDC: TEdit;
    EditNakedMC: TEdit;
    EditNakedSC: TEdit;
    EditNakedHP: TEdit;
    EditNakedPoint: TEdit;
    EditGameDiamond: TSpinEdit;
    Label19: TLabel;
    Label26: TLabel;
    EditPKPoint: TSpinEdit;
    Label27: TLabel;
    EditGameGird: TSpinEdit;
    GroupBox12: TGroupBox;
    Label28: TLabel;
    EditC0: TSpinEdit;
    GroupBox6: TGroupBox;
    CheckBoxGameMaster: TCheckBox;
    CheckBoxSuperMan: TCheckBox;
    CheckBoxObserver: TCheckBox;
    EditPullulation: TSpinEdit;
    Label35: TLabel;
    EditC1: TSpinEdit;
    Label36: TLabel;
    EditC2: TSpinEdit;
    Label37: TLabel;
    Label29: TLabel;
    EditC3: TSpinEdit;
    Label32: TLabel;
    EditC4: TSpinEdit;
    Label33: TLabel;
    EditC5: TSpinEdit;
    Label34: TLabel;
    EditC6: TSpinEdit;
    Label38: TLabel;
    EditC7: TSpinEdit;
    Label39: TLabel;
    EditC8: TSpinEdit;
    Label40: TLabel;
    EditC9: TSpinEdit;
    Label41: TLabel;
    EditC10: TSpinEdit;
    Label42: TLabel;
    EditC11: TSpinEdit;
    Label43: TLabel;
    EditC12: TSpinEdit;
    Label44: TLabel;
    EditC13: TSpinEdit;
    Label45: TLabel;
    EditC14: TSpinEdit;
    Label46: TLabel;
    EditC15: TSpinEdit;
    Label47: TLabel;
    EditC16: TSpinEdit;
    Label48: TLabel;
    EditC17: TSpinEdit;
    Label49: TLabel;
    EditC18: TSpinEdit;
    Label50: TLabel;
    EditC19: TSpinEdit;
    EditStorageGold: TSpinEdit;
    Label51: TLabel;
    procedure TimerTimer(Sender: TObject);
    procedure CheckBoxMonitorClick(Sender: TObject);
    procedure ButtonKickClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure RefHumanInfo();
    { Private declarations }
  public
    PlayObject: TPlayObject;
    procedure Open();
    { Public declarations }
  end;

var
  frmHumanInfo: TfrmHumanInfo;

implementation

uses UsrEngn, M2Share, Grobal2;

{$R *.dfm}
var
  boRefHuman: Boolean = False;
  { TfrmHumanInfo }

procedure TfrmHumanInfo.FormCreate(Sender: TObject);
begin
  GridUserItem.Cells[0, 0] := '装备位置';
  GridUserItem.Cells[1, 0] := '装备名称';
  GridUserItem.Cells[2, 0] := '系列号';
  GridUserItem.Cells[3, 0] := '持久';
  GridUserItem.Cells[4, 0] := '攻';
  GridUserItem.Cells[5, 0] := '魔';
  GridUserItem.Cells[6, 0] := '道';
  GridUserItem.Cells[7, 0] := '防';
  GridUserItem.Cells[8, 0] := '魔防';
  GridUserItem.Cells[9, 0] := '附加属性';

  GridUserItem.Cells[0, 1] := '衣服';
  GridUserItem.Cells[0, 2] := '武器';
  GridUserItem.Cells[0, 3] := '头盔';
  GridUserItem.Cells[0, 4] := '项链';
  GridUserItem.Cells[0, 5] := '照明物';
  GridUserItem.Cells[0, 6] := '左手镯';
  GridUserItem.Cells[0, 7] := '右手镯';
  GridUserItem.Cells[0, 8] := '左戒指';
  GridUserItem.Cells[0, 9] := '右戒指';
  GridUserItem.Cells[0, 10] := '符毒';
  GridUserItem.Cells[0, 11] := '腰带';
  GridUserItem.Cells[0, 12] := '鞋子';
  GridUserItem.Cells[0, 13] := '宝石';
  GridUserItem.Cells[0, 14] := '马牌';
  GridUserItem.Cells[0, 15] := '道具';

  GridBagItem.Cells[0, 0] := '序号';
  GridBagItem.Cells[1, 0] := '装备名称';
  GridBagItem.Cells[2, 0] := '系列号';
  GridBagItem.Cells[3, 0] := '持久';
  GridBagItem.Cells[4, 0] := '攻';
  GridBagItem.Cells[5, 0] := '魔';
  GridBagItem.Cells[6, 0] := '道';
  GridBagItem.Cells[7, 0] := '防';
  GridBagItem.Cells[8, 0] := '魔防';
  GridBagItem.Cells[9, 0] := '附加属性';

  GridStorageItem.Cells[0, 0] := '序号';
  GridStorageItem.Cells[1, 0] := '装备名称';
  GridStorageItem.Cells[2, 0] := '系列号';
  GridStorageItem.Cells[3, 0] := '持久';
  GridStorageItem.Cells[4, 0] := '攻';
  GridStorageItem.Cells[5, 0] := '魔';
  GridStorageItem.Cells[6, 0] := '道';
  GridStorageItem.Cells[7, 0] := '防';
  GridStorageItem.Cells[8, 0] := '魔防';
  GridStorageItem.Cells[9, 0] := '附加属性';
  PageControl1.ActivePageIndex := 0;
end;

procedure TfrmHumanInfo.Open;
begin
  RefHumanInfo();
  ButtonKick.Enabled := True;
  Timer.Enabled := True;
  ShowModal;
  CheckBoxMonitor.Checked := False;
  Timer.Enabled := False;
end;

procedure TfrmHumanInfo.RefHumanInfo;
var
  i, n, k: Integer;
//  nTotleUsePoint: Integer;
  StdItem: pTStdItem;
  Item: TStdItem;
  UserItem: pTUserItem;
begin
  if (PlayObject = nil) then begin
    Exit;
  end;
  {if PlayObject.m_boNotOnlineAddExp then
    EditSayMsg.Enabled := True
  else
    EditSayMsg.Enabled := False; }
  //EditSayMsg.Text := '';
  EditName.Text := PlayObject.m_sCharName;
  EditMap.Text := PlayObject.m_sMapName + '(' + PlayObject.m_PEnvir.sMapDesc + ')';
  EditXY.Text := IntToStr(PlayObject.m_nCurrX) + ':' + IntToStr(PlayObject.m_nCurrY);
  EditAccount.Text := PlayObject.m_sUserID;
  EditIPaddr.Text := PlayObject.m_sIPaddr;
  EditLogonTime.Text := DateTimeToStr(PlayObject.m_dLogonTime);
  EditLogonLong.Text := IntToStr((GetTickCount - PlayObject.m_dwLogonTick) div (60 * 1000)) + ' 分钟';
  EditLevel.Value := PlayObject.m_Abil.Level;
  EditGold.Value := PlayObject.m_nGold;
  EditBindGold.Value := PlayObject.m_nBindGold;
  EditPKPoint.Value := PlayObject.m_nPkPoint;
  EditExp.Value := PlayObject.m_Abil.Exp;
  EditMaxExp.Value := PlayObject.m_Abil.MaxExp;
  EditStorageGold.Value := PlayObject.m_nStorageGold;

  EditAC.Text := IntToStr(LoWord(PlayObject.m_WAbil.AC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.AC));
  EditMAC.Text := IntToStr(LoWord(PlayObject.m_WAbil.MAC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.MAC));
  EditDC.Text := IntToStr(LoWord(PlayObject.m_WAbil.DC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.DC));
  EditMC.Text := IntToStr(LoWord(PlayObject.m_WAbil.MC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.MC));
  EditSC.Text := IntToStr(LoWord(PlayObject.m_WAbil.SC)) + '/' + IntToStr(HiWord(PlayObject.m_WAbil.SC));
  EditHP.Text := IntToStr(PlayObject.m_WAbil.HP) + '/' + IntToStr(PlayObject.m_WAbil.MaxHP);
  EditMP.Text := IntToStr(PlayObject.m_WAbil.MP) + '/' + IntToStr(PlayObject.m_WAbil.MaxMP);

  EditNakedAc.Text := IntToStr(PlayObject.m_NakedAbil.nAc);
  EditNakedMAc.Text := IntToStr(PlayObject.m_NakedAbil.nMAc);
  EditNakedDc.Text := IntToStr(PlayObject.m_NakedAbil.nDc);
  EditNakedMc.Text := IntToStr(PlayObject.m_NakedAbil.nMc);
  EditNakedSc.Text := IntToStr(PlayObject.m_NakedAbil.nSc);
  EditNakedHP.Text := IntToStr(PlayObject.m_NakedAbil.nHP);
  EditNakedPoint.Text := IntToStr(PlayObject.m_nNakedCount) + '/' + IntToStr(PlayObject.m_nNakedBackCount);



  EditGameGold.Value := PlayObject.m_nGameGold;
  EditGamePoint.Value := PlayObject.m_nGamePoint;
  EditGameDiamond.Value := PlayObject.m_nGameDiamond;
  EditGameGird.Value := PlayObject.m_nGameGird;
  EditPullulation.Value := PlayObject.m_nPullulation div MIDPULLULATION;
  EditCreditPoint.Value := PlayObject.m_nCreditPoint;

  EditC0.Value := PlayObject.m_CustomVariable[0];
  EditC1.Value := PlayObject.m_CustomVariable[1];
  EditC2.Value := PlayObject.m_CustomVariable[2];
  EditC3.Value := PlayObject.m_CustomVariable[3];
  EditC4.Value := PlayObject.m_CustomVariable[4];
  EditC5.Value := PlayObject.m_CustomVariable[5];
  EditC6.Value := PlayObject.m_CustomVariable[6];
  EditC7.Value := PlayObject.m_CustomVariable[7];
  EditC8.Value := PlayObject.m_CustomVariable[8];
  EditC9.Value := PlayObject.m_CustomVariable[9];
  EditC10.Value := PlayObject.m_CustomVariable[10];
  EditC11.Value := PlayObject.m_CustomVariable[11];
  EditC12.Value := PlayObject.m_CustomVariable[12];
  EditC13.Value := PlayObject.m_CustomVariable[13];
  EditC14.Value := PlayObject.m_CustomVariable[14];
  EditC15.Value := PlayObject.m_CustomVariable[15];
  EditC16.Value := PlayObject.m_CustomVariable[16];
  EditC17.Value := PlayObject.m_CustomVariable[17];
  EditC18.Value := PlayObject.m_CustomVariable[18];
  EditC19.Value := PlayObject.m_CustomVariable[19];

  CheckBoxGameMaster.Checked := PlayObject.m_boAdminMode;
  CheckBoxSuperMan.Checked := PlayObject.m_boSuperMan;
  CheckBoxObserver.Checked := PlayObject.m_boObMode;

  if PlayObject.m_boDeath then begin
    EditHumanStatus.Text := '死亡';
  end
  else
  if PlayObject.m_boSafeOffLine then begin
    EditHumanStatus.Text := '离线挂机';
  end
  else if PlayObject.m_boGhost then begin
    EditHumanStatus.Text := '下线';
    PlayObject := nil;
  end
  else
    EditHumanStatus.Text := '在线';
  for i := Low(PlayObject.m_UseItems) to High(PlayObject.m_UseItems) do begin
    UserItem := @PlayObject.m_UseItems[i];
    if UserItem.wIndex <= 0 then begin
      GridUserItem.Cells[1, i + 1] := '';
      GridUserItem.Cells[2, i + 1] := '';
      GridUserItem.Cells[3, i + 1] := '';
      GridUserItem.Cells[4, i + 1] := '';
      GridUserItem.Cells[5, i + 1] := '';
      GridUserItem.Cells[6, i + 1] := '';
      GridUserItem.Cells[7, i + 1] := '';
      GridUserItem.Cells[8, i + 1] := '';
      GridUserItem.Cells[9, i + 1] := '';
      Continue;
    end;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if StdItem = nil then begin
      GridUserItem.Cells[1, i + 1] := '';
      GridUserItem.Cells[2, i + 1] := '';
      GridUserItem.Cells[3, i + 1] := '';
      GridUserItem.Cells[4, i + 1] := '';
      GridUserItem.Cells[5, i + 1] := '';
      GridUserItem.Cells[6, i + 1] := '';
      GridUserItem.Cells[7, i + 1] := '';
      GridUserItem.Cells[8, i + 1] := '';
      GridUserItem.Cells[9, i + 1] := '';
      Continue;
    end;
    Item := StdItem^;
    ItemUnit.GetItemAddValue(PlayObject.m_btWuXin, UserItem, Item);

    GridUserItem.Cells[1, i + 1] := Item.Name;
    GridUserItem.Cells[2, i + 1] := IntToStr(UserItem.MakeIndex);
    GridUserItem.Cells[3, i + 1] := format('%d/%d', [UserItem.Dura, UserItem.DuraMax]);
    GridUserItem.Cells[4, i + 1] := format('%d/%d', [Item.nDC, Item.nDC2]);
    GridUserItem.Cells[5, i + 1] := format('%d/%d', [Item.nMC, Item.nMC2]);
    GridUserItem.Cells[6, i + 1] := format('%d/%d', [Item.nSC, Item.nSC2]);
    GridUserItem.Cells[7, i + 1] := format('%d/%d', [Item.nAC, Item.nAC2]);
    GridUserItem.Cells[8, i + 1] := format('%d/%d', [Item.nMAC, Item.nMAC2]);
  end;

  if PlayObject.m_ItemList.Count <= 0 then
    GridBagItem.RowCount := 2
  else
    GridBagItem.RowCount := PlayObject.m_ItemList.Count + 1;

  for i := 0 to PlayObject.m_ItemList.Count - 1 do begin
    UserItem := PlayObject.m_ItemList.Items[i];
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if StdItem = nil then begin
      GridBagItem.Cells[1, i + 1] := '';
      GridBagItem.Cells[2, i + 1] := '';
      GridBagItem.Cells[3, i + 1] := '';
      GridBagItem.Cells[4, i + 1] := '';
      GridBagItem.Cells[5, i + 1] := '';
      GridBagItem.Cells[6, i + 1] := '';
      GridBagItem.Cells[7, i + 1] := '';
      GridBagItem.Cells[8, i + 1] := '';
      GridBagItem.Cells[9, i + 1] := '';
      Continue;
    end;
    Item := StdItem^;
    ItemUnit.GetItemAddValue(PlayObject.m_btWuXin, UserItem, Item);
    GridBagItem.Cells[0, i + 1] := IntToStr(i);
    GridBagItem.Cells[1, i + 1] := Item.Name;
    GridBagItem.Cells[2, i + 1] := IntToStr(UserItem.MakeIndex);
    GridBagItem.Cells[3, i + 1] := format('%d/%d', [UserItem.Dura, UserItem.DuraMax]);
    GridBagItem.Cells[4, i + 1] := format('%d/%d', [Item.nDC, Item.nDC2]);
    GridBagItem.Cells[5, i + 1] := format('%d/%d', [Item.nMC, Item.nMC2]);
    GridBagItem.Cells[6, i + 1] := format('%d/%d', [Item.nSC, Item.nSC2]);
    GridBagItem.Cells[7, i + 1] := format('%d/%d', [Item.nAC, Item.nAC2]);
    GridBagItem.Cells[8, i + 1] := format('%d/%d', [Item.nMAC, Item.nMAC2]);
  end;
  n := 0;
  for I := Low(PlayObject.m_StorageItemList) to High(PlayObject.m_StorageItemList) do begin
    Inc(n, PlayObject.m_StorageItemList[I].Count);
  end;
  if n <= 0 then
    GridStorageItem.RowCount := 2
  else
    GridStorageItem.RowCount := n + 1;
  n := 1;
  for I := Low(PlayObject.m_StorageItemList) to High(PlayObject.m_StorageItemList) do begin
    for k := 0 to PlayObject.m_StorageItemList[I].Count - 1 do begin
      UserItem := @pTStorageItem(PlayObject.m_StorageItemList[I].Items[k])^.UserItem;
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem = nil then begin
        GridStorageItem.Cells[1, n] := '';
        GridStorageItem.Cells[2, n] := '';
        GridStorageItem.Cells[3, n] := '';
        GridStorageItem.Cells[4, n] := '';
        GridStorageItem.Cells[5, n] := '';
        GridStorageItem.Cells[6, n] := '';
        GridStorageItem.Cells[7, n] := '';
        GridStorageItem.Cells[8, n] := '';
        GridStorageItem.Cells[9, n] := '';
        Inc(n);
        Continue;
      end;
      Item := StdItem^;
      ItemUnit.GetItemAddValue(PlayObject.m_btWuXin, UserItem, Item);

      GridStorageItem.Cells[0, n] := IntToStr(i) + '/' + IntToStr(k);
      GridStorageItem.Cells[1, n] := Item.Name;
      GridStorageItem.Cells[2, n] := IntToStr(UserItem.MakeIndex);
      GridStorageItem.Cells[3, n] := format('%d/%d', [UserItem.Dura, UserItem.DuraMax]);
      GridStorageItem.Cells[4, n] := format('%d/%d', [Item.nDC, Item.nDC2]);
      GridStorageItem.Cells[5, n] := format('%d/%d', [Item.nMC, Item.nMC2]);
      GridStorageItem.Cells[6, n] := format('%d/%d', [Item.nSC, Item.nSC2]);
      GridStorageItem.Cells[7, n] := format('%d/%d', [Item.nAC, Item.nAC2]);
      GridStorageItem.Cells[8, n] := format('%d/%d', [Item.nMAC, Item.nMAC2]);
      Inc(n);
    end;
  end;
end;

procedure TfrmHumanInfo.TimerTimer(Sender: TObject);
begin
  if PlayObject = nil then
    Exit;
  if PlayObject.m_boGhost then begin
    EditHumanStatus.Text := '下线';
    PlayObject := nil;
    Exit;
  end;
  if boRefHuman then
    RefHumanInfo();
end;

procedure TfrmHumanInfo.CheckBoxMonitorClick(Sender: TObject);
begin
  boRefHuman := CheckBoxMonitor.Checked;
  ButtonSave.Enabled := not boRefHuman;
end;

procedure TfrmHumanInfo.ButtonKickClick(Sender: TObject);
begin
  if PlayObject = nil then
    Exit;
  PlayObject.m_boEmergencyClose := True;
  PlayObject.m_boPlayOffLine := False;
  ButtonKick.Enabled := False;
end;

procedure TfrmHumanInfo.ButtonSaveClick(Sender: TObject);
var
  nLevel: Integer;
  nGold: Integer;
  nBindGold: Integer;
  nPKPOINT: Integer;
  nGameGold: Integer;
  nGamePoint: Integer;
  nGameDiamond: Integer;
  nCreditPoint: Integer;
  nGameGird: Integer;
  dwExp: LongWord;
  boGameMaster: Boolean;
  boObServer: Boolean;
  boSuperman: Boolean;
  nPullulation: Integer;
  nStorageGold: Integer;
begin
  if PlayObject = nil then Exit;
  nLevel := EditLevel.Value;
  nGold := EditGold.Value;
  nBindGold := EditBindGold.Value;
  nPKPOINT := EditPKPoint.Value;
  nGameGold := EditGameGold.Value;
  nGamePoint := EditGamePoint.Value;
  nCreditPoint := EditCreditPoint.Value;
  nGameDiamond := EditGameDiamond.Value;
  nGameGird := EditGameGird.Value;
  nStorageGold := EditStorageGold.Value;
  nPullulation := EditPullulation.Value;
  boGameMaster := CheckBoxGameMaster.Checked;
  boObServer := CheckBoxObserver.Checked;
  boSuperman := CheckBoxSuperMan.Checked;
  dwExp := EditExp.Value;
  if (nLevel < 0) or (nLevel > High(Word)) or (nGold < 0) or (nGold > MAXINTCOUNT) or (nBindGold < 0) or (nBindGold > MAXINTCOUNT)
    or (dwExp > MAXINTCOUNT) or (nGameDiamond > MAXINTCOUNT) or (nGameDiamond < 0) or (nGameGird > MAXINTCOUNT) or (nGameGird < 0)
    or (nPullulation > 10000) or (nPullulation < 0) or (nStorageGold < 0) or (nStorageGold > MAXINTCOUNT)
    or (nPKPOINT < 0) or (nPKPOINT > 65535) or (nCreditPoint < 0) or (nCreditPoint > MAXINTCOUNT) then begin
    MessageBox(Handle, '输入数据不正确.', '错误信息', MB_OK);
    Exit;
  end;
  PlayObject.m_CustomVariable[0] := EditC0.Value;
  PlayObject.m_CustomVariable[1] := EditC1.Value;
  PlayObject.m_CustomVariable[2] := EditC2.Value;
  PlayObject.m_CustomVariable[3] := EditC3.Value;
  PlayObject.m_CustomVariable[4] := EditC4.Value;
  PlayObject.m_CustomVariable[5] := EditC5.Value;
  PlayObject.m_CustomVariable[6] := EditC6.Value;
  PlayObject.m_CustomVariable[7] := EditC7.Value;
  PlayObject.m_CustomVariable[8] := EditC8.Value;
  PlayObject.m_CustomVariable[9] := EditC9.Value;
  PlayObject.m_CustomVariable[10] := EditC10.Value;
  PlayObject.m_CustomVariable[11] := EditC11.Value;
  PlayObject.m_CustomVariable[12] := EditC12.Value;
  PlayObject.m_CustomVariable[13] := EditC13.Value;
  PlayObject.m_CustomVariable[14] := EditC14.Value;
  PlayObject.m_CustomVariable[15] := EditC15.Value;
  PlayObject.m_CustomVariable[16] := EditC16.Value;
  PlayObject.m_CustomVariable[17] := EditC17.Value;
  PlayObject.m_CustomVariable[18] := EditC18.Value;
  PlayObject.m_CustomVariable[19] := EditC19.Value;
  PlayObject.m_Abil.Exp := dwExp;
  PlayObject.m_Abil.Level := nLevel;
  PlayObject.m_nGold := nGold;
  PlayObject.m_nBindGold := nBindGold;
  PlayObject.m_nPkPoint := nPKPOINT;
  PlayObject.m_nGameGold := nGameGold;
  PlayObject.m_nGamePoint := nGamePoint;
  PlayObject.m_nCreditPoint := nCreditPoint;
  PlayObject.m_nGameDiamond := nGameDiamond;
  PlayObject.m_nGameGird := nGameGird;
  PlayObject.m_nStorageGold := nStorageGold;
  PlayObject.m_nPullulation := nPullulation * MIDPULLULATION;
  PlayObject.m_boAdminMode := boGameMaster;
  PlayObject.m_boObMode := boObServer;
  PlayObject.m_boSuperMan := boSuperman;
  PlayObject.HasLevelUp(1);
  PlayObject.GoldChanged;
  PlayObject.GameGirdChanged;
  PlayObject.DiamondChanged;
  PlayObject.GameGoldChanged;
  MessageBox(Handle, '人物数据已保存。', '提示信息', MB_OK);
end;

end.
