unit GMManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Spin, CheckLst;

type
  TFormGMManage = class(TForm)
    pgc1: TPageControl;
    ts1: TTabSheet;
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    grp1: TGroupBox;
    lstItems: TListBox;
    pgcts4: TPageControl;
    ts2: TTabSheet;
    ts3: TTabSheet;
    cbbSelectList: TComboBox;
    edtTime: TEdit;
    lbl7: TLabel;
    lbl5: TLabel;
    seMaxDura: TSpinEdit;
    lbl4: TLabel;
    seDura: TSpinEdit;
    lbl3: TLabel;
    lbl2: TLabel;
    edtID: TEdit;
    lbl1: TLabel;
    chklstBind1: TCheckListBox;
    chklstBind2: TCheckListBox;
    lbl6: TLabel;
    cbbWuXin: TComboBox;
    lbl8: TLabel;
    seFluteCount: TSpinEdit;
    lbl9: TLabel;
    seFlute1: TSpinEdit;
    lbl10: TLabel;
    seFlute2: TSpinEdit;
    lbl11: TLabel;
    seFlute3: TSpinEdit;
    lbl12: TLabel;
    cbbStrengthenMax: TComboBox;
    seStrengthenCount: TSpinEdit;
    lbl13: TLabel;
    seIndex: TSpinEdit;
    cbbStrengthen3: TComboBox;
    lbl14: TLabel;
    cbbStrengthen6: TComboBox;
    lbl18: TLabel;
    cbbStrengthen12: TComboBox;
    lbl15: TLabel;
    cbbStrengthen9: TComboBox;
    lbl16: TLabel;
    cbbStrengthen18: TComboBox;
    lbl17: TLabel;
    cbbStrengthen15: TComboBox;
    lbl19: TLabel;
    ts4: TTabSheet;
    se9: TSpinEdit;
    lbl20: TLabel;
    lbl21: TLabel;
    se10: TSpinEdit;
    se11: TSpinEdit;
    lbl22: TLabel;
    lbl23: TLabel;
    se12: TSpinEdit;
    lbl24: TLabel;
    se13: TSpinEdit;
    se14: TSpinEdit;
    lbl25: TLabel;
    lbl26: TLabel;
    se15: TSpinEdit;
    se16: TSpinEdit;
    lbl27: TLabel;
    lbl28: TLabel;
    se17: TSpinEdit;
    se18: TSpinEdit;
    lbl29: TLabel;
    lbl30: TLabel;
    se19: TSpinEdit;
    se20: TSpinEdit;
    lbl31: TLabel;
    lbl32: TLabel;
    se21: TSpinEdit;
    se22: TSpinEdit;
    lbl33: TLabel;
    lbl34: TLabel;
    se23: TSpinEdit;
    se24: TSpinEdit;
    lbl35: TLabel;
    lbl36: TLabel;
    se25: TSpinEdit;
    se26: TSpinEdit;
    lbl37: TLabel;
    lbl38: TLabel;
    se27: TSpinEdit;
    se28: TSpinEdit;
    lbl39: TLabel;
    lbl40: TLabel;
    se29: TSpinEdit;
    se30: TSpinEdit;
    lbl41: TLabel;
    lbl42: TLabel;
    se31: TSpinEdit;
    se32: TSpinEdit;
    lbl43: TLabel;
    se33: TSpinEdit;
    lbl44: TLabel;
    se34: TSpinEdit;
    lbl45: TLabel;
    se35: TSpinEdit;
    lbl46: TLabel;
    ts5: TTabSheet;
    grp2: TGroupBox;
    chk1: TCheckBox;
    btnSave: TButton;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    procedure cbbSelectListChange(Sender: TObject);
    procedure lstItemsClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure cbbStrengthenMaxChange(Sender: TObject);
    procedure seMaxDuraChange(Sender: TObject);
    procedure seFluteCountChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormGMManage: TFormGMManage;

procedure GMManageShow;

implementation
uses
  CLMain, MShare, Grobal2, Hutil32, EDcodeEx, Share;

const
  ColorSelect: array[Boolean] of TColor = (clScrollBar, clWindow);

{$R *.dfm}

procedure GMManageShow;
begin
  if not Assigned(FormGMManage) then begin
    FormGMManage := TFormGMManage.Create(frmMain.Owner);
    FormGMManage.Show;
  end
  else
    FormGMManage.Show;
end;

procedure TFormGMManage.btnSaveClick(Sender: TObject);
var
  ClientItem: pTNewClientItem;
  UserItem: TUserItem;
  I: Integer;
  StdItem: TStdItem;
begin
  if lstItems.ItemIndex <> -1 then begin
    ClientItem := pTNewClientItem(lstItems.Items.Objects[lstItems.ItemIndex]);
    UserItem := ClientItem.UserItem;
    if GetStdItem(seIndex.Value).Name = '' then begin
      Application.MessageBox(PChar('保存失败，物品编号[' + IntToStr(seIndex.Value) + ']不存在！'), '', MB_OK +
        MB_ICONINFORMATION);
      exit;
    end;
    UserItem.wIndex := seIndex.Value;

    UserItem.DuraMax := seMaxDura.Value;
    UserItem.Dura := seDura.Value;
    if edtTime.Text <> '0' then begin
      try
        UserItem.TermTime := DateTimeToLongWord(StrToDateTime(edtTime.Text));
      except
        UserItem.TermTime := 0;
      end;
    end
    else
      UserItem.TermTime := 0;
    SetByteStatus(UserItem.btBindMode1, Ib_NoDeal, chklstBind1.Checked[0]);
    SetByteStatus(UserItem.btBindMode1, Ib_NoSave, chklstBind1.Checked[1]);
    SetByteStatus(UserItem.btBindMode1, Ib_NoRepair, chklstBind1.Checked[2]);
    SetByteStatus(UserItem.btBindMode1, Ib_NoDrop, chklstBind1.Checked[3]);
    SetByteStatus(UserItem.btBindMode1, Ib_NoDown, chklstBind1.Checked[4]);
    SetByteStatus(UserItem.btBindMode1, Ib_NoMake, chklstBind1.Checked[5]);
    SetByteStatus(UserItem.btBindMode1, Ib_NoSell, chklstBind1.Checked[6]);
    SetByteStatus(UserItem.btBindMode1, Ib_DropDestroy, chklstBind1.Checked[7]);

    SetByteStatus(UserItem.btBindMode2, Ib2_Unknown, chklstBind2.Checked[0]);
    //SetByteStatus(UserItem.btBindMode2, Ib2_Bind, chklstBind2.Checked[1]);

    UserItem.Value.btWuXin := cbbWuXin.ItemIndex;
    UserItem.Value.btFluteCount := seFluteCount.Value;
    if (seFlute1.Value > 0) then begin
      StdItem := GetStdItem(seFlute1.Value);
      if (StdItem.Name = '') or (StdItem.StdMode2 <> 46) or (StdItem.Shape <> 3) then begin
        Application.MessageBox(PChar('保存失败，凹槽1物品编号设置不正确！'), '', MB_OK + MB_ICONINFORMATION);
        exit;
      end;
    end;
    if (seFlute2.Value > 0) then begin
      StdItem := GetStdItem(seFlute2.Value);
      if (StdItem.Name = '') or (StdItem.StdMode2 <> 46) or (StdItem.Shape <> 3) then begin
        Application.MessageBox(PChar('保存失败，凹槽2物品编号设置不正确！'), '', MB_OK + MB_ICONINFORMATION);
        exit;
      end;
    end;
    if (seFlute3.Value > 0) then begin
      StdItem := GetStdItem(seFlute3.Value);
      if (StdItem.Name = '') or (StdItem.StdMode2 <> 46) or (StdItem.Shape <> 3) then begin
        Application.MessageBox(PChar('保存失败，凹槽3物品编号设置不正确！'), '', MB_OK + MB_ICONINFORMATION);
        exit;
      end;
    end;
    UserItem.Value.wFlute[0] := seFlute1.Value;
    UserItem.Value.wFlute[1] := seFlute2.Value;
    UserItem.Value.wFlute[2] := seFlute3.Value;

    UserItem.Value.StrengthenInfo.btCanStrengthenCount := cbbStrengthenMax.ItemIndex * 3;
    UserItem.Value.StrengthenInfo.btStrengthenCount := _MIN(seStrengthenCount.Value,
      UserItem.Value.StrengthenInfo.btCanStrengthenCount);

    UserItem.Value.StrengthenInfo.btStrengthenInfo[0] := cbbStrengthen3.ItemIndex;
    UserItem.Value.StrengthenInfo.btStrengthenInfo[1] := cbbStrengthen6.ItemIndex;
    UserItem.Value.StrengthenInfo.btStrengthenInfo[2] := cbbStrengthen9.ItemIndex;
    UserItem.Value.StrengthenInfo.btStrengthenInfo[3] := cbbStrengthen12.ItemIndex;
    UserItem.Value.StrengthenInfo.btStrengthenInfo[4] := cbbStrengthen15.ItemIndex;
    UserItem.Value.StrengthenInfo.btStrengthenInfo[5] := cbbStrengthen18.ItemIndex;

    for I := 0 to ts4.ControlCount - 1 do begin
      if ts4.Controls[I] is TSpinEdit then begin
        with ts4.Controls[I] as TSpinEdit do begin
          UserItem.Value.btValue[Tag] := Value;
        end;
      end;
    end;

    ClientItem.s := GetStdItem(seIndex.Value);
    ClientItem.UserItem := UserItem;
    frmMain.SendClientSocket(CM_GMUPDATESERVER, UserItem.MakeIndex, GMM_UPDATEITEM, cbbSelectList.ItemIndex, 0,
      EncodeBuffer(@UserItem, SizeOf(TUserItem)));
  end;
end;

procedure TFormGMManage.Button1Click(Sender: TObject);
var
  FileStream: TFileStream;
  UserItem: TUserItem;
  ClientItem: pTNewClientItem;
  MakeIndex: Integer;
begin
  OpenDialog1.FileName := '';
  if OpenDialog1.Execute(Handle) then begin
    if OpenDialog1.FileName <> '' then begin
      FileStream := TFileStream.Create(OpenDialog1.FileName, fmOpenRead);
      if lstItems.ItemIndex <> -1 then begin
        ClientItem := pTNewClientItem(lstItems.Items.Objects[lstItems.ItemIndex]);
        UserItem := ClientItem.UserItem;
        MakeIndex := UserItem.MakeIndex;
        FileStream.Read(UserItem, SizeOf(UserItem));
        UserItem.MakeIndex := MakeIndex;
        frmMain.SendClientSocket(CM_GMUPDATESERVER, UserItem.MakeIndex, GMM_UPDATEITEM, cbbSelectList.ItemIndex, 0,
          EncodeBuffer(@UserItem, SizeOf(TUserItem)));
        
      end;
    end;
  end;
end;

procedure TFormGMManage.cbbSelectListChange(Sender: TObject);
var
  i: Integer;
begin
  case cbbSelectList.ItemIndex of
    1: begin
        lstItems.Clear;
        for I := Low(g_ItemArr) to High(g_ItemArr) do begin
          if g_ItemArr[I].s.Name <> '' then begin
            lstItems.Items.AddObject(g_ItemArr[I].s.Name, TObject(@g_ItemArr[I]));
          end;
        end;
      end;
    2: begin
        lstItems.Clear;
        for I := Low(g_UseItems) to High(g_UseItems) do begin
          if g_UseItems[I].s.Name <> '' then begin
            lstItems.Items.AddObject(g_UseItems[I].s.Name, TObject(@g_UseItems[I]));
          end;
        end;
      end;
  end;
end;

procedure TFormGMManage.cbbStrengthenMaxChange(Sender: TObject);
begin
  cbbStrengthen3.Enabled := cbbStrengthenMax.ItemIndex > 0;
  cbbStrengthen6.Enabled := cbbStrengthenMax.ItemIndex > 1;
  cbbStrengthen9.Enabled := cbbStrengthenMax.ItemIndex > 2;
  cbbStrengthen12.Enabled := cbbStrengthenMax.ItemIndex > 3;
  cbbStrengthen15.Enabled := cbbStrengthenMax.ItemIndex > 4;
  cbbStrengthen18.Enabled := cbbStrengthenMax.ItemIndex > 5;
  cbbStrengthen3.Color := ColorSelect[cbbStrengthen3.Enabled];
  cbbStrengthen6.Color := ColorSelect[cbbStrengthen6.Enabled];
  cbbStrengthen9.Color := ColorSelect[cbbStrengthen9.Enabled];
  cbbStrengthen12.Color := ColorSelect[cbbStrengthen12.Enabled];
  cbbStrengthen15.Color := ColorSelect[cbbStrengthen15.Enabled];
  cbbStrengthen18.Color := ColorSelect[cbbStrengthen18.Enabled];
  seStrengthenCount.MaxValue := cbbStrengthenMax.ItemIndex * 3;
end;

procedure TFormGMManage.FormCreate(Sender: TObject);
var
  sBack: string;
begin
  cbbStrengthen3.Items.Clear;
  while True do begin
    sBack := GetStrengthenText(3, cbbStrengthen3.Items.Count);
    if sBack = '' then break;
    cbbStrengthen3.Items.Add(sBack);
  end;
  cbbStrengthen3.ItemIndex := 0;

  cbbStrengthen6.Items.Clear;
  while True do begin
    sBack := GetStrengthenText(6, cbbStrengthen6.Items.Count);
    if sBack = '' then break;
    cbbStrengthen6.Items.Add(sBack);
  end;
  cbbStrengthen6.ItemIndex := 0;

  cbbStrengthen9.Items.Clear;
  while True do begin
    sBack := GetStrengthenText(9, cbbStrengthen9.Items.Count);
    if sBack = '' then break;
    cbbStrengthen9.Items.Add(sBack);
  end;
  cbbStrengthen9.ItemIndex := 0;

  cbbStrengthen12.Items.Clear;
  while True do begin
    sBack := GetStrengthenText(12, cbbStrengthen12.Items.Count);
    if sBack = '' then break;
    cbbStrengthen12.Items.Add(sBack);
  end;
  cbbStrengthen12.ItemIndex := 0;

  cbbStrengthen15.Items.Clear;
  while True do begin
    sBack := GetStrengthenText(15, cbbStrengthen15.Items.Count);
    if sBack = '' then break;
    cbbStrengthen15.Items.Add(sBack);
  end;
  cbbStrengthen15.ItemIndex := 0;

  cbbStrengthen18.Items.Clear;
  while True do begin
    sBack := GetStrengthenText(18, cbbStrengthen18.Items.Count);
    if sBack = '' then break;
    cbbStrengthen18.Items.Add(sBack);
  end;
  cbbStrengthen18.ItemIndex := 0;


end;

procedure TFormGMManage.lstItemsClick(Sender: TObject);

var
  ClientItem: pTNewClientItem;
  UserItem: pTUserItem;
  I: Integer;
begin
  if lstItems.ItemIndex <> -1 then begin
    ClientItem := pTNewClientItem(lstItems.Items.Objects[lstItems.ItemIndex]);
    UserItem := @ClientItem.UserItem;
    edtID.Text := IntToStr(UserItem.MakeIndex);
    seindex.Value := UserItem.wIndex;
    seDura.Value := UserItem.Dura;
    seMaxDura.Value := UserItem.DuraMax;
    seDura.MaxValue := seMaxDura.Value;
    if UserItem.TermTime > 0 then
      edtTime.Text := DateTimeToStr(LongWordToDateTime(UserItem.TermTime))
    else
      edtTime.Text := '0';

    chklstBind1.Checked[0] := CheckByteStatus(UserItem.btBindMode1, Ib_NoDeal);
    chklstBind1.Checked[1] := CheckByteStatus(UserItem.btBindMode1, Ib_NoSave);
    chklstBind1.Checked[2] := CheckByteStatus(UserItem.btBindMode1, Ib_NoRepair);
    chklstBind1.Checked[3] := CheckByteStatus(UserItem.btBindMode1, Ib_NoDrop);
    chklstBind1.Checked[4] := CheckByteStatus(UserItem.btBindMode1, Ib_NoDown);
    chklstBind1.Checked[5] := CheckByteStatus(UserItem.btBindMode1, Ib_NoMake);
    chklstBind1.Checked[6] := CheckByteStatus(UserItem.btBindMode1, Ib_NoSell);
    chklstBind1.Checked[7] := CheckByteStatus(UserItem.btBindMode1, Ib_DropDestroy);

    chklstBind2.Checked[0] := CheckByteStatus(UserItem.btBindMode2, Ib2_Unknown);
    //chklstBind2.Checked[1] := CheckByteStatus(UserItem.btBindMode2, Ib2_Bind);

    cbbWuXin.ItemIndex := UserItem.Value.btWuXin;
    seFluteCount.Value := UserItem.Value.btFluteCount;
    seFlute1.Value := UserItem.Value.wFlute[0];
    seFlute2.Value := UserItem.Value.wFlute[1];
    seFlute3.Value := UserItem.Value.wFlute[2];
    seFlute1.Enabled := seFluteCount.Value > 0;
    seFlute2.Enabled := seFluteCount.Value > 1;
    seFlute3.Enabled := seFluteCount.Value > 2;
    seFlute1.Color := ColorSelect[seFlute1.Enabled];
    seFlute2.Color := ColorSelect[seFlute2.Enabled];
    seFlute3.Color := ColorSelect[seFlute3.Enabled];
    seStrengthenCount.Value := UserItem.Value.StrengthenInfo.btStrengthenCount;
    cbbStrengthenMax.ItemIndex := UserItem.Value.StrengthenInfo.btCanStrengthenCount div 3;
    cbbStrengthen3.ItemIndex := UserItem.Value.StrengthenInfo.btStrengthenInfo[0];
    cbbStrengthen6.ItemIndex := UserItem.Value.StrengthenInfo.btStrengthenInfo[1];
    cbbStrengthen9.ItemIndex := UserItem.Value.StrengthenInfo.btStrengthenInfo[2];
    cbbStrengthen12.ItemIndex := UserItem.Value.StrengthenInfo.btStrengthenInfo[3];
    cbbStrengthen15.ItemIndex := UserItem.Value.StrengthenInfo.btStrengthenInfo[4];
    cbbStrengthen18.ItemIndex := UserItem.Value.StrengthenInfo.btStrengthenInfo[5];
    cbbStrengthen3.Enabled := cbbStrengthenMax.ItemIndex > 0;
    cbbStrengthen6.Enabled := cbbStrengthenMax.ItemIndex > 1;
    cbbStrengthen9.Enabled := cbbStrengthenMax.ItemIndex > 2;
    cbbStrengthen12.Enabled := cbbStrengthenMax.ItemIndex > 3;
    cbbStrengthen15.Enabled := cbbStrengthenMax.ItemIndex > 4;
    cbbStrengthen18.Enabled := cbbStrengthenMax.ItemIndex > 5;
    cbbStrengthen3.Color := ColorSelect[cbbStrengthen3.Enabled];
    cbbStrengthen6.Color := ColorSelect[cbbStrengthen6.Enabled];
    cbbStrengthen9.Color := ColorSelect[cbbStrengthen9.Enabled];
    cbbStrengthen12.Color := ColorSelect[cbbStrengthen12.Enabled];
    cbbStrengthen15.Color := ColorSelect[cbbStrengthen15.Enabled];
    cbbStrengthen18.Color := ColorSelect[cbbStrengthen18.Enabled];
    seStrengthenCount.MaxValue := cbbStrengthenMax.ItemIndex * 3;

    for I := 0 to ts4.ControlCount - 1 do begin
      if ts4.Controls[I] is TSpinEdit then begin
        with ts4.Controls[I] as TSpinEdit do begin
          Value := UserItem.Value.btValue[Tag];
        end;
      end;
    end;
  end;
end;

procedure TFormGMManage.seFluteCountChange(Sender: TObject);
begin
  seFlute1.Enabled := seFluteCount.Value > 0;
  seFlute2.Enabled := seFluteCount.Value > 1;
  seFlute3.Enabled := seFluteCount.Value > 2;
  seFlute1.Color := ColorSelect[seFlute1.Enabled];
  seFlute2.Color := ColorSelect[seFlute2.Enabled];
  seFlute3.Color := ColorSelect[seFlute3.Enabled];
end;

procedure TFormGMManage.seMaxDuraChange(Sender: TObject);
begin
  seDura.MaxValue := seMaxDura.Value;
end;

end.

