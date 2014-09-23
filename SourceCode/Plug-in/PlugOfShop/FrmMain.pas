unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ComCtrls, EngineType, EngineAPI, HUtil32;

type
  TFormMain = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ListViewShopList: TListView;
    ButtonAdd: TButton;
    ButtonDel: TButton;
    ButtonEdit: TButton;
    ButtonSave: TButton;
    ButtonRefur: TButton;
    Label8: TLabel;
    Label9: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    SpinEditIntegral: TSpinEdit;
    SpinEditTime: TSpinEdit;
    SpinEditItems: TSpinEdit;
    ComboBoxClass: TComboBox;
    EditName: TEdit;
    SpinEditPrice: TSpinEdit;
    EditText: TEdit;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    GroupBox4: TGroupBox;
    ListBoxitemList: TListBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Button1: TButton;
    procedure ListBoxitemListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBoxitemListClick(Sender: TObject);
    procedure ListViewShopListChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ButtonRefurClick(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ButtonDelClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonEditClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    boModValued: Boolean;
  public
    procedure Open();
    procedure RefStdItems();
    procedure RefShopItems();
    procedure ModValue;
    procedure uModValue;
  end;

var
  FormMain: TFormMain;

implementation
uses
  Share, ShopEngine, Grobal2;

{$R *.dfm}

procedure TFormMain.Button1Click(Sender: TObject);
var
  i, II: Integer;
  ShopItem: pTShopItem;
  SaveList: TStringList;
begin
  SaveList := TStringList.Create;
  for I := Low(m_ShopItemList) to High(m_ShopItemList) do
    for II := 0 to m_ShopItemList[i].Count - 1 do begin
      ShopItem := pTShopItem(m_ShopItemList[i].Items[ii]);
      if ShopItem.sHint <> '' then begin
        SaveList.Add(EncodeString(ShopItem.sName + '=' + ShopItem.sHint));
      end;
    end;
  SaveList.SaveToFile('.\ShopHint.dat');
  SaveList.Free;
  MessageBox(Handle, '生成完成...', '提示信息', MB_OK or MB_ICONASTERISK);
end;

procedure TFormMain.ButtonAddClick(Sender: TObject);
var
  I: Integer;
  Item: TListItem;
  ShopItem: pTShopItem;
begin
  for I := 0 to ListViewShopList.Items.Count - 1 do begin
    Item := ListViewShopList.Items.Item[I];
    if (Item.SubItems.Count > 0) and
      (CompareText(Item.SubItems.Strings[0], EditName.Text) = 0) and
      (CompareText(Item.Caption, ComboBoxClass.Text) = 0) and
      (CompareText(Item.SubItems.Strings[3], SpinEditTime.Text) = 0) then begin
      MessageBox(Handle, '添加的物品已经存在于列表当中...',
        '提示信息', MB_OK or MB_ICONASTERISK);
      exit;
    end;
  end;
  New(ShopItem);
  ShopItem.btIdx := ComboBoxClass.ItemIndex;
  ShopItem.sName := EditName.Text;
  ShopItem.wIdent := SpinEditItems.Value;
  ShopItem.nPrict := SpinEditPrice.Value;
  ShopItem.wTime := SpinEditTime.Value;
  ShopItem.nIntegral := SpinEditIntegral.Value;

  SetByteStatus(ShopItem.btStatus, Ib_NoDeal, CheckBox1.Checked);
  SetByteStatus(ShopItem.btStatus, Ib_NoSave, CheckBox2.Checked);
  SetByteStatus(ShopItem.btStatus, Ib_NoRepair, CheckBox3.Checked);
  SetByteStatus(ShopItem.btStatus, Ib_NoDrop, CheckBox4.Checked);
  SetByteStatus(ShopItem.btStatus, Ib_NoDown, CheckBox5.Checked);
  SetByteStatus(ShopItem.btStatus, Ib_NoMake, CheckBox6.Checked);

  ShopItem.sHint := EditText.Text;
  if (ShopItem.btIdx in [0..5]) and (ShopItem.wIdent > 0) then begin
    m_ShopItemList[ShopItem.btIdx].Add(ShopItem);
    Item := ListViewShopList.Items.Add;
    Item.Caption := ComboBoxClass.Items[ShopItem.btIdx];
    Item.SubItems.AddObject(ShopItem.sName, TObject(ShopItem));
    Item.SubItems.Add(IntToStr(ShopItem.wIdent));
    Item.SubItems.Add(IntToStr(ShopItem.nPrict));
    Item.SubItems.Add(SpinEditTime.Text);
    Item.SubItems.Add(SpinEditIntegral.Text);
    Item.SubItems.Add(STATUSTEXT[CheckBox1.Checked]);
    Item.SubItems.Add(STATUSTEXT[CheckBox2.Checked]);
    Item.SubItems.Add(STATUSTEXT[CheckBox3.Checked]);
    Item.SubItems.Add(STATUSTEXT[CheckBox4.Checked]);
    Item.SubItems.Add(STATUSTEXT[CheckBox5.Checked]);
    Item.SubItems.Add(STATUSTEXT[CheckBox6.Checked]);
    Item.SubItems.Add(ShopItem.sHint);
    ButtonAdd.Enabled := False;
    ModValue;
  end
  else begin
    Dispose(ShopItem);
    Application.MessageBox('提交的信息不正确，请认真检查！', '提示信息', MB_OK
      + MB_ICONINFORMATION);
  end;
end;

procedure TFormMain.ButtonDelClick(Sender: TObject);
var
  Item: TListItem;
begin
  if ListViewShopList.ItemIndex > -1 then begin
    Item := ListViewShopList.Items.Item[ListViewShopList.ItemIndex];
    if MessageBox(Handle,
      PChar('确定删除物品 ' + Item.SubItems.Strings[0] + '?'),
      '提示信息',
      MB_YESNO or MB_ICONQUESTION) = IDYES then begin
      DelShopItem(pTShopItem(Item.SubItems.Objects[0]));
      ListViewShopList.Items.Delete(ListViewShopList.ItemIndex);
      ButtonDel.Enabled := False;
      ButtonEdit.Enabled := False;
      ModValue;
    end;
  end;
end;

procedure TFormMain.ButtonEditClick(Sender: TObject);
var
  Item: TListItem;
  ShopItem: pTShopItem;
  i, II: Integer;
begin
  if ListViewShopList.ItemIndex > -1 then begin
    Item := ListViewShopList.Items.Item[ListViewShopList.ItemIndex];
    ShopItem := pTShopItem(Item.SubItems.Objects[0]);
    Try
      for I := Low(m_ShopItemList) to High(m_ShopItemList) do
        for II := 0 to m_ShopItemList[i].Count - 1 do begin
          if pTShopItem(m_ShopItemList[i].Items[ii]) = ShopItem then begin
            if ShopItem.btIdx = ComboBoxClass.ItemIndex then begin
              ShopItem.btIdx := ComboBoxClass.ItemIndex;
              ShopItem.nPrict := SpinEditPrice.Value;
              ShopItem.wTime := SpinEditTime.Value;
              ShopItem.nIntegral := SpinEditIntegral.Value;

              SetByteStatus(ShopItem.btStatus, Ib_NoDeal, CheckBox1.Checked);
              SetByteStatus(ShopItem.btStatus, Ib_NoSave, CheckBox2.Checked);
              SetByteStatus(ShopItem.btStatus, Ib_NoRepair, CheckBox3.Checked);
              SetByteStatus(ShopItem.btStatus, Ib_NoDrop, CheckBox4.Checked);
              SetByteStatus(ShopItem.btStatus, Ib_NoDown, CheckBox5.Checked);
              SetByteStatus(ShopItem.btStatus, Ib_NoMake, CheckBox6.Checked);

              ShopItem.sHint := EditText.Text;
            end else begin
              m_ShopItemList[i].Delete(ii);
              ListViewShopList.Items.Delete(ListViewShopList.ItemIndex);
              Dispose(ShopItem);
              ButtonAddClick(ButtonAdd);
            end;
            Exit;
          end;
        end;
    Finally
      RefShopItems;
      ModValue;
    End;
  end;
end;

procedure TFormMain.ButtonRefurClick(Sender: TObject);
begin
  if MessageBox(Handle,
    PChar('是否确定重新加载物品列表?...'),
    '提示信息',
    MB_YESNO or MB_ICONQUESTION) = IDYES then begin
    LoadShopList;
    RefShopItems;
  end;
end;

procedure TFormMain.ButtonSaveClick(Sender: TObject);
begin
  SaveShopList;
  ButtonAdd.Enabled := False;
  ButtonDel.Enabled := False;
  ButtonEdit.Enabled := False;
  uModValue;
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if boModValued then begin
    if
      Application.MessageBox('参数设置已经被修改，是否确认不保存修改的设置？', '确认信息',
        MB_YESNO + MB_ICONQUESTION) = IDYES then begin
      uModValue
    end
    else
      CanClose := False;
  end;
end;

procedure TFormMain.ListBoxitemListClick(Sender: TObject);
var
  StdItem: _LPTSTDITEM;
begin
  if ListBoxItemList.ItemIndex > -1 then begin
    StdItem := _LPTSTDITEM(ListBoxItemList.Items.Objects[ListBoxItemList.ItemIndex]);
    EditName.Text := StdItem.Name;
    SpinEditItems.Value := StdItem.Idx + 1;
    ButtonAdd.Enabled := True;
  end;
end;

procedure TFormMain.ListBoxitemListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  sIPaddr: string;
  I, nIdx: Integer;
begin
  if (ssCtrl in Shift) and (Key = word('F')) then begin
    sIPaddr := InputBox('查找信息', '请输入要查找的内容(支持模糊查找)', '');
    nIdx := ListBoxitemList.ItemIndex + 1;
    if nIdx >= ListBoxitemList.Count then
      nIdx := 0;
    for I := nIdx to ListBoxitemList.Count - 1 do begin
      if CompareLStr(ListBoxItemList.Items.Strings[I], sIPaddr, Length(sIPAddr)) then begin
        ListBoxitemList.Selected[I] := True;
        break;
      end;
    end;
  end;
end;

procedure TFormMain.ListViewShopListChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  i: integer;
begin
  if ListViewShopList.ItemIndex > -1 then begin
    try
      for I := 0 to ComboBoxClass.Items.Count - 1 do begin
        if (CompareText(ComboBoxClass.Items[i], Item.Caption) = 0) then begin
          ComboBoxClass.ItemIndex := i;
          break;
        end;
      end;
    except
    end;
    if Item.SubItems.Count > 10 then begin
      EditName.Text := Item.SubItems.Strings[0];
      SpinEditItems.Text := Item.SubItems.Strings[1];
      SpinEditPrice.Text := Item.SubItems.Strings[2];
      SpinEditTime.Text := Item.SubItems.Strings[3];
      SpinEditIntegral.Text := Item.SubItems.Strings[4];
      CheckBox1.Checked := (Item.SubItems.Strings[5] = STATUSTEXT[True]);
      CheckBox2.Checked := (Item.SubItems.Strings[6] = STATUSTEXT[True]);
      CheckBox3.Checked := (Item.SubItems.Strings[7] = STATUSTEXT[True]);
      CheckBox4.Checked := (Item.SubItems.Strings[8] = STATUSTEXT[True]);
      CheckBox5.Checked := (Item.SubItems.Strings[9] = STATUSTEXT[True]);
      CheckBox6.Checked := (Item.SubItems.Strings[10] = STATUSTEXT[True]);
      EditText.Text := Item.SubItems.Strings[11];
      ButtonDel.Enabled := True;
      ButtonEdit.Enabled := True;
    end;
  end;
end;

procedure TFormMain.ModValue;
begin
  ButtonSave.Enabled := True;
  boModValued := True;
end;

procedure TFormMain.Open;
begin
  uModValue();
  EnterCriticalSection(ProcessHumanCriticalSection^);
  try
    RefStdItems();
    RefShopItems();
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection^);
  end;
  ShowModal;

end;

procedure TFormMain.RefShopItems;
var
  ShopItem: pTShopItem;
  Item: TListItem;
  I, II: Integer;
begin
  ListViewShopList.Clear;
  for I := Low(m_ShopItemList) to High(m_ShopItemList) do
    for II := 0 to m_ShopItemList[i].Count - 1 do begin
      ShopItem := m_ShopItemList[i].Items[ii];
      Item := ListViewShopList.Items.Add;
      Item.Caption :=  ComboBoxClass.Items[ShopItem.btIdx];
      Item.SubItems.AddObject(ShopItem.sName, TObject(ShopItem));
      Item.SubItems.Add(IntToStr(ShopItem.wIdent));
      Item.SubItems.Add(IntToStr(ShopItem.nPrict));
      Item.SubItems.Add(IntToStr(ShopItem.wTime));
      Item.SubItems.Add(IntToStr(ShopItem.nIntegral));
      Item.SubItems.Add(STATUSTEXT[CheckByteStatus(ShopItem.btStatus, Ib_NoDeal)]);
      Item.SubItems.Add(STATUSTEXT[CheckByteStatus(ShopItem.btStatus, Ib_NoSave)]);
      Item.SubItems.Add(STATUSTEXT[CheckByteStatus(ShopItem.btStatus, Ib_NoRepair)]);
      Item.SubItems.Add(STATUSTEXT[CheckByteStatus(ShopItem.btStatus, Ib_NoDrop)]);
      Item.SubItems.Add(STATUSTEXT[CheckByteStatus(ShopItem.btStatus, Ib_NoDown)]);
      Item.SubItems.Add(STATUSTEXT[CheckByteStatus(ShopItem.btStatus, Ib_NoMake)]);
      Item.SubItems.Add(ShopItem.sHint);
    end;
  ButtonDel.Enabled := False;
  ButtonEdit.Enabled := False;
end;

procedure TFormMain.RefStdItems;
var
  StdItem: _LPTSTDITEM;
  Idx: Integer;
begin
  Idx := 1;
  StdItem := TUserEngine_GetStdItemByIndex(Idx);
  while StdItem <> nil do begin
    ListBoxitemList.AddItem(StdItem.Name, TObject(StdItem));
    Inc(Idx);
    StdItem := TUserEngine_GetStdItemByIndex(Idx);
  end;
end;

procedure TFormMain.uModValue;
begin
  ButtonSave.Enabled := False;
  boModValued := False;
end;

end.

