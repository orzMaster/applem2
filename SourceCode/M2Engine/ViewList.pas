unit ViewList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Grids, Spin, Grobal2, Menus, ExtCtrls;

type
  TfrmViewList = class(TForm)
    PageControl1: TPageControl;
    TabSheet15: TTabSheet;
    PageControlViewList: TPageControl;
    TabSheet10: TTabSheet;
    GroupBox12: TGroupBox;
    ListBoxAdminList: TListBox;
    GroupBox15: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    LabelAdminIPaddr: TLabel;
    EditAdminName: TEdit;
    EditAdminPremission: TSpinEdit;
    ButtonAdminListAdd: TButton;
    ButtonAdminListChange: TButton;
    ButtonAdminListDel: TButton;
    EditAdminIPaddr: TEdit;
    ButtonAdminLitsSave: TButton;
    TabSheet8: TTabSheet;
    GroupBox8: TGroupBox;
    ListBoxGameLogList: TListBox;
    ButtonGameLogAdd: TButton;
    ButtonGameLogDel: TButton;
    ButtonGameLogAddAll: TButton;
    ButtonGameLogDelAll: TButton;
    ButtonGameLogSave: TButton;
    GroupBox9: TGroupBox;
    ListBoxitemList2: TListBox;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    ListBoxItem: TListBox;
    GroupBox18: TGroupBox;
    CheckBoxMake: TCheckBox;
    CheckBoxDropHint: TCheckBox;
    CheckBoxDropDown: TCheckBox;
    CheckBoxSave: TCheckBox;
    chkBox: TCheckBox;
    CheckBoxSell: TCheckBox;
    CheckBoxDeath: TCheckBox;
    CheckBoxBoxs: TCheckBox;
    CheckBoxGhost: TCheckBox;
    CheckBoxPlaySell: TCheckBox;
    CheckBoxResell: TCheckBox;
    CheckBoxNoDrop: TCheckBox;
    CheckBoxDropHint2: TCheckBox;
    CheckBoxNoLevel: TCheckBox;
    CheckBoxButchItem: TCheckBox;
    CheckBoxHeroBag: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBoxNoTakeOff: TCheckBox;
    ButtonAllAdd: TButton;
    ButtonAllClose: TButton;
    ButtonRuleSave: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    TabSheet2: TTabSheet;
    GroupBox2: TGroupBox;
    ListBox1: TListBox;
    GroupBox3: TGroupBox;
    EditMonDropName: TEdit;
    ButtonMonDropAdd: TButton;
    Label1: TLabel;
    Label2: TLabel;
    EditMonDropMaxCount: TSpinEdit;
    Label3: TLabel;
    EditMonDropMinCount: TSpinEdit;
    StringGridMonDropLimit: TStringGrid;
    Label6: TLabel;
    EditMonDropYear: TSpinEdit;
    Label7: TLabel;
    EditMonDropMonth: TSpinEdit;
    Label8: TLabel;
    EditMonDropDay: TSpinEdit;
    ButtonMonDropDel: TButton;
    ButtonMonDropSave: TButton;
    ButtonMonDropLoad: TButton;
    Label9: TLabel;
    EditMonDropHour: TSpinEdit;
    ButtonMonDropClear: TButton;
    ButtonMonDropEdit: TButton;
    TabSheet3: TTabSheet;
    GroupBox4: TGroupBox;
    StringGridUserCmd: TStringGrid;
    Label10: TLabel;
    EditUserCmdName: TEdit;
    EditUserCmdID: TSpinEdit;
    Label11: TLabel;
    Label12: TLabel;
    ButtonUserCmdAdd: TButton;
    ButtonUserCmdDel: TButton;
    ButtonUserCmdEdit: TButton;
    ButtonUserCmdSave: TButton;
    TabSheet4: TTabSheet;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox5: TGroupBox;
    ListBoxSetItems: TListBox;
    ListViewSuit: TListView;
    Label14: TLabel;
    EditHP: TSpinEdit;
    Label15: TLabel;
    EditMP: TSpinEdit;
    Label16: TLabel;
    EditACt: TSpinEdit;
    Label17: TLabel;
    EditMAC3: TSpinEdit;
    Label18: TLabel;
    EditDC: TSpinEdit;
    Label19: TLabel;
    EditMC: TSpinEdit;
    Label20: TLabel;
    EditSC: TSpinEdit;
    Label21: TLabel;
    EditSC2: TSpinEdit;
    Label22: TLabel;
    EditAC: TSpinEdit;
    Label23: TLabel;
    EditAC2: TSpinEdit;
    Label24: TLabel;
    EditMAC: TSpinEdit;
    Label25: TLabel;
    EditMAC2: TSpinEdit;
    Label32: TLabel;
    EditHitPoint: TSpinEdit;
    Label31: TLabel;
    EditSpeedPoint: TSpinEdit;
    Label26: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label27: TLabel;
    Label28: TLabel;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    Label29: TLabel;
    SpinEdit8: TSpinEdit;
    Label35: TLabel;
    SpinEdit9: TSpinEdit;
    Label36: TLabel;
    SpinEdit10: TSpinEdit;
    Label37: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label30: TLabel;
    Edit1: TEdit;
    PopupMenu1: TPopupMenu;
    A1: TMenuItem;
    Label33: TLabel;
    SpinEdit5: TSpinEdit;
    Label34: TLabel;
    SpinEdit6: TSpinEdit;
    Label38: TLabel;
    SpinEdit7: TSpinEdit;
    GroupBox10: TGroupBox;
    Label13: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label49: TLabel;
    Label48: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Label50: TLabel;
    SpinEdit11: TSpinEdit;
    Label51: TLabel;
    SpinEdit12: TSpinEdit;
    CheckBox2: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure ButtonMonDropLimitRefClick(Sender: TObject);
    procedure ListBoxGameLogListClick(Sender: TObject);
    procedure ListBoxitemList2Click(Sender: TObject);
    procedure ButtonGameLogAddClick(Sender: TObject);
    procedure ButtonGameLogDelClick(Sender: TObject);
    procedure ButtonGameLogAddAllClick(Sender: TObject);
    procedure ButtonGameLogDelAllClick(Sender: TObject);
    procedure ButtonGameLogSaveClick(Sender: TObject);
    procedure ButtonNoClearMonSaveClick(Sender: TObject);
    procedure ButtonAdminLitsSaveClick(Sender: TObject);
    procedure ListBoxAdminListClick(Sender: TObject);
    procedure ButtonAdminListChangeClick(Sender: TObject);
    procedure ButtonAdminListAddClick(Sender: TObject);
    procedure ButtonAdminListDelClick(Sender: TObject);
    procedure ButtonItemBindAcountModClick(Sender: TObject);
    procedure ButtonItemBindAcountRefClick(Sender: TObject);
    procedure ButtonItemBindAcountAddClick(Sender: TObject);
    procedure ButtonItemBindAcountDelClick(Sender: TObject);
    procedure ButtonItemBindCharNameAddClick(Sender: TObject);
    procedure ButtonItemBindCharNameModClick(Sender: TObject);
    procedure ButtonItemBindCharNameDelClick(Sender: TObject);
    procedure ButtonItemBindCharNameRefClick(Sender: TObject);
    procedure ButtonItemBindIPaddrAddClick(Sender: TObject);
    procedure ButtonItemBindIPaddrModClick(Sender: TObject);
    procedure ButtonItemBindIPaddrDelClick(Sender: TObject);
    procedure ButtonItemBindIPaddrRefClick(Sender: TObject);
    procedure ButtonItemNameRefClick(Sender: TObject);
    procedure ListBoxItemDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure CheckBox1Click(Sender: TObject);
    procedure ListBoxItemClick(Sender: TObject);
    procedure ButtonRuleSaveClick(Sender: TObject);
    procedure CheckBoxMakeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListBox1Click(Sender: TObject);
    procedure ButtonMonDropLoadClick(Sender: TObject);
    procedure ButtonMonDropClearClick(Sender: TObject);
    procedure ButtonMonDropSaveClick(Sender: TObject);
    procedure ButtonMonDropAddClick(Sender: TObject);
    procedure StringGridMonDropLimitClick(Sender: TObject);
    procedure ButtonMonDropDelClick(Sender: TObject);
    procedure ButtonMonDropEditClick(Sender: TObject);
    procedure StringGridUserCmdClick(Sender: TObject);
    procedure ButtonUserCmdDelClick(Sender: TObject);
    procedure ButtonUserCmdEditClick(Sender: TObject);
    procedure ButtonUserCmdAddClick(Sender: TObject);
    procedure ButtonUserCmdSaveClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure A1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure EditHPChange(Sender: TObject);
    procedure ListViewSuitClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    boOpened: Boolean;
    boModValued: Boolean;

    procedure ModValue();
    procedure uModValue();
    procedure RefMonDropLimit();
    procedure RefAdminList;
    procedure RefNoClearMonList();
    procedure RefItemBindAccount();
    procedure RefItemBindCharName();
    procedure RefItemBindIPaddr();
    procedure RefItemCustomNameList();
    procedure RefMsgFilterList();
    procedure RefRuleCheckBoxAll(ItemRule: pTItemRule);
    procedure RefLoadItems();
    procedure RefUserCmd();
    procedure RefSetItems();
    //function CheckItemUseCount(sItemName: string; nIndex: Integer): Integer;
  public
    procedure Open();

  end;

var
  frmViewList: TfrmViewList;

implementation

uses M2Share, UsrEngn, Envir, HUtil32, LocalDB;

{$R *.dfm}

procedure TfrmViewList.ModValue;
begin
  boModValued := True;

  ButtonGameLogSave.Enabled := True;
  ButtonRuleSave.Enabled := True;
  Button4.Enabled := True;
end;

procedure TfrmViewList.uModValue;
begin
  boModValued := False;

  ButtonGameLogSave.Enabled := False;
  ButtonRuleSave.Enabled := False;
  Button4.Enabled := False;

end;

procedure TfrmViewList.Open;
var
  i: Integer;
  StdItem: pTStdItem;
begin
  boOpened := False;
  uModValue();
  ListBoxitemList2.Clear;
  ListBoxSetItems.Items.Clear;
  ListBoxItem.Clear;
  ListBox1.Items.Clear;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    ListBoxitemList2.Items.AddObject(g_sHumanDieEvent, TObject(nil));
    ListBoxitemList2.Items.AddObject(sSTRING_GOLDNAME, TObject(nil));
    ListBoxitemList2.Items.AddObject(sSTRING_BINDGOLDNAME, TObject(nil));
    ListBoxitemList2.Items.AddObject(sSTRING_GAMEGOLD, TObject(nil));
    ListBoxitemList2.Items.AddObject(sSTRING_GAMEPOINT, TObject(nil));
    ListBoxitemList2.Items.AddObject(sSTRING_GAMEDIAMOND, TObject(nil));
    ListBoxitemList2.Items.AddObject(sSTRING_CREDITPOINT, TObject(nil));
    ListBoxitemList2.Items.AddObject(sSTRING_CUSTOMVARIABLE, TObject(nil));

    for i := 0 to UserEngine.StdItemList.Count - 1 do begin
      StdItem := UserEngine.StdItemList.Items[i];
      ListBoxitemList2.Items.AddObject(StdItem.Name, TObject(StdItem));
      ListBoxItem.Items.AddObject(StdItem.Name, TObject(StdItem));
      ListBox1.Items.AddObject(StdItem.Name, TObject(StdItem));
      if sm_Arming in Stditem.StdModeEx then
        ListBoxSetItems.Items.AddObject(StdItem.Name, TObject(StdItem));
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;

  g_GameLogItemNameList.Lock;
  try
    for i := 0 to g_GameLogItemNameList.Count - 1 do begin
      ListBoxGameLogList.Items.Add(g_GameLogItemNameList.Strings[i]);
    end;
  finally
    g_GameLogItemNameList.UnLock;
  end;

  RefItemBindAccount();

  RefItemBindCharName();

  RefItemBindIPaddr();

  RefMonDropLimit();
  RefAdminList();
  RefNoClearMonList();
  RefItemCustomNameList();
  RefMsgFilterList();

  boOpened := True;
  PageControlViewList.ActivePageIndex := 0;
  PageControl1.TabIndex := 0;


  StringGridMonDropLimit.Cells[0, 0] := '物品名称';
  StringGridMonDropLimit.Cells[1, 0] := '已爆数量';
  StringGridMonDropLimit.Cells[2, 0] := '限制数量';
  StringGridMonDropLimit.Cells[3, 0] := '开始时间';
  ButtonMonDropLoadClick(ButtonMonDropLoad);

  StringGridUserCmd.Cells[0, 0] := '命令名称';
  StringGridUserCmd.Cells[1, 0] := '标识';
  StringGridUserCmd.Cells[2, 0] := '对应QFunction-0';

  RefUserCmd;
  RefSetItems();

  ShowModal;
end;

procedure TfrmViewList.PageControl1Change(Sender: TObject);
begin
  if PageControl1.TabIndex = 2 then begin
    ClientHeight := 504;
    ClientWidth := 915;
    PageControl1.Width := 899;
    PageControl1.Height := 488;
  end else begin
    ClientHeight := 419;
    ClientWidth := 731;
    PageControl1.Width := 713;
    PageControl1.Height := 401;
  end;

end;

procedure TfrmViewList.PopupMenu1Popup(Sender: TObject);
begin
  A1.Enabled := ListBoxSetItems.SelCount > 0;
end;

procedure TfrmViewList.FormCreate(Sender: TObject);
begin
  ClientHeight := 419;
  ClientWidth := 731;
  PageControl1.Width := 713;
  PageControl1.Height := 401;
  
  ButtonGameLogAdd.Enabled := False;
  ButtonGameLogDel.Enabled := False;

{$IF SoftVersion = VERDEMO}
  Caption := '查看列表信息[演示版本，所有设置调整有效，但不能保存]';
{$IFEND}

  EditAdminIPaddr.Visible := False;
  LabelAdminIPaddr.Visible := False;
end;

procedure TfrmViewList.RefMsgFilterList;
begin

end;

procedure TfrmViewList.RefMonDropLimit;
begin

end;

procedure TfrmViewList.ButtonMonDropAddClick(Sender: TObject);
var
  I: Integer;
  sName: string;
begin
  sName := Trim(EditMonDropName.Text);
  if sName <> '' then begin
    for I := 1 to StringGridMonDropLimit.RowCount - 1 do begin
      if CompareText(sName, StringGridMonDropLimit.Cells[0, I]) = 0 then begin
        Application.MessageBox('物品设置已经存在！', '提示信息', MB_OK +  MB_ICONINFORMATION);
        Exit;
      end;
    end;
    if StringGridMonDropLimit.RowCount = 2 then begin
      if StringGridMonDropLimit.Cells[0, 1] <> '' then begin
        I := StringGridMonDropLimit.RowCount;
        StringGridMonDropLimit.RowCount := StringGridMonDropLimit.RowCount + 1;
      end
      else
        I := 1;
    end else begin
      I := StringGridMonDropLimit.RowCount;
      StringGridMonDropLimit.RowCount := StringGridMonDropLimit.RowCount + 1;
    end;
    StringGridMonDropLimit.Cells[0, I] := sName;
    StringGridMonDropLimit.Cells[1, I] := EditMonDropMinCount.Text;
    StringGridMonDropLimit.Cells[2, I] := EditMonDropMaxCount.Text;
    StringGridMonDropLimit.Cells[3, I] := Format('%.4d%.2d%.2d%.2d', [EditMonDropYear.Value, EditMonDropMonth.Value, EditMonDropDay.Value, EditMonDropHour.Value]);

  end;
  ButtonMonDropAdd.Enabled := False;
  ButtonMonDropSave.Enabled := True;
end;

procedure TfrmViewList.ButtonMonDropClearClick(Sender: TObject);
var
  I: Integer;
begin
  if Application.MessageBox('是否确定清空已爆数量设置？', '提示信息', MB_OKCANCEL + MB_ICONQUESTION) = IDOK then
  begin
    for I := 1 to StringGridMonDropLimit.RowCount - 1 do begin
      StringGridMonDropLimit.Cells[1, I] := '0';
    end;
    ButtonMonDropSave.Enabled := True;
  end;
end;

procedure TfrmViewList.ButtonMonDropDelClick(Sender: TObject);
var
  Idx: Integer;
  I: Integer;
begin
  Idx := StringGridMonDropLimit.Row;
  if idx > 0 then begin
    if StringGridMonDropLimit.RowCount = 2 then begin
      StringGridMonDropLimit.Cells[0, 1] := '';
      StringGridMonDropLimit.Cells[1, 1] := '';
      StringGridMonDropLimit.Cells[2, 1] := '';
      StringGridMonDropLimit.Cells[3, 1] := '';
    end else begin
      for I := Idx + 1 to StringGridMonDropLimit.RowCount - 1 do begin
        StringGridMonDropLimit.Cells[0, I - 1] := StringGridMonDropLimit.Cells[0, I];
        StringGridMonDropLimit.Cells[1, I - 1] := StringGridMonDropLimit.Cells[1, I];
        StringGridMonDropLimit.Cells[2, I - 1] := StringGridMonDropLimit.Cells[2, I];
        StringGridMonDropLimit.Cells[3, I - 1] := StringGridMonDropLimit.Cells[3, I];
      end;
      StringGridMonDropLimit.RowCount := StringGridMonDropLimit.RowCount - 1;
    end;
  end;
end;

procedure TfrmViewList.ButtonMonDropEditClick(Sender: TObject);
var
  Idx: Integer;
begin
  Idx := StringGridMonDropLimit.Row;
  if idx > 0 then begin
    StringGridMonDropLimit.Cells[1, idx] := EditMonDropMinCount.Text;
    StringGridMonDropLimit.Cells[2, idx] := EditMonDropMaxCount.Text;
    StringGridMonDropLimit.Cells[3, idx] := Format('%.4d%.2d%.2d%.2d', [EditMonDropYear.Value, EditMonDropMonth.Value, EditMonDropDay.Value, EditMonDropHour.Value]);
    ButtonMonDropSave.Enabled := True;
  end;
end;

procedure TfrmViewList.ButtonMonDropLimitRefClick(Sender: TObject);
begin
  RefMonDropLimit();
end;

procedure TfrmViewList.ButtonMonDropLoadClick(Sender: TObject);
var
  I: Integer;
  MonDropLimitInfo: pTMonDropLimitInfo;
begin
  StringGridMonDropLimit.RowCount := _MAX(2, g_MonDropLimitList.Count + 1);
  StringGridMonDropLimit.Cells[0, 1] := '';
  StringGridMonDropLimit.Cells[1, 1] := '';
  StringGridMonDropLimit.Cells[2, 1] := '';
  StringGridMonDropLimit.Cells[3, 1] := '';
  for I := 0 to g_MonDropLimitList.Count - 1 do begin
    MonDropLimitInfo := g_MonDropLimitList[I];
    StringGridMonDropLimit.Cells[0, I + 1] := MonDropLimitInfo.sItemName;
    StringGridMonDropLimit.Cells[1, I + 1] := IntToStr(MonDropLimitInfo.nMinCount);
    StringGridMonDropLimit.Cells[2, I + 1] := IntToStr(MonDropLimitInfo.nMaxCount);
    StringGridMonDropLimit.Cells[3, I + 1] := IntToStr(MonDropLimitInfo.dwTime);
  end;
  ButtonMonDropSave.Enabled := False;
  ButtonMonDropAdd.Enabled := False;
  ButtonMonDropEdit.Enabled := False;
  ButtonMonDropDel.Enabled := False;
end;

procedure TfrmViewList.ButtonMonDropSaveClick(Sender: TObject);
var
  I: Integer;
  StdItem: pTStdItem;
  StdItemLimit: pTStdItemLimit;
  MonDropLimit: pTMonDropLimitInfo;
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    for i := 0 to UserEngine.StdItemLimitList.Count - 1 do begin
      //StdItem := UserEngine.StdItemList.Items[i];
      StdItemLimit := UserEngine.StdItemLimitList.Items[i];
      StdItemLimit.MonDropLimit := nil;
    end;
    for I := 0 to g_MonDropLimitList.Count - 1 do begin
      MonDropLimit := pTMonDropLimitInfo(g_MonDropLimitList[I]);
      Dispose(MonDropLimit);
    end;
    g_MonDropLimitList.Clear;
    for I := 1 to StringGridMonDropLimit.RowCount - 1 do begin
      if StringGridMonDropLimit.Cells[0, I] <> '' then begin
        New(MonDropLimit);
        MonDropLimit.sItemName := StringGridMonDropLimit.Cells[0, I];
        MonDropLimit.nMinCount := StrToIntDef(StringGridMonDropLimit.Cells[1, I], 0);
        MonDropLimit.nMaxCount := StrToIntDef(StringGridMonDropLimit.Cells[2, I], 0);
        MonDropLimit.dwTime := StrToIntDef(StringGridMonDropLimit.Cells[3, I], 0);
        g_MonDropLimitList.Add(MonDropLimit);
      end;
    end;
    for i := 0 to UserEngine.StdItemLimitList.Count - 1 do begin
      StdItem := UserEngine.StdItemList.Items[i];
      StdItemLimit := UserEngine.StdItemLimitList.Items[i];
      StdItemLimit.MonDropLimit := GetMonDropLimitByName(StdItem.Name);
    end;
    SaveMonDropLimitList();
    ButtonMonDropSave.Enabled := False;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TfrmViewList.ListBoxGameLogListClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if ListBoxGameLogList.ItemIndex >= 0 then
    ButtonGameLogDel.Enabled := True;
end;

procedure TfrmViewList.ListBoxItemClick(Sender: TObject);
begin
  if ListBoxItem.SelCount > 1 then begin
    RefRuleCheckBoxAll(nil);
  end
  else if (ListBoxItem.ItemIndex >= 0) and (ListBoxItem.ItemIndex < ListBoxItem.Count) then begin
    RefRuleCheckBoxAll(pTItemRule(pTStdItem(ListBoxItem.Items.Objects[ListBoxItem.ItemIndex]).Rule));
  end;
end;

procedure TfrmViewList.ListBoxItemDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Flags: Longint;
  Data: string;
  Stditem: pTStdItem;
begin
  ListBoxItem.Canvas.FillRect(Rect);
  if Index < ListBoxItem.Count then begin
    Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
    if not UseRightToLeftAlignment then
      Inc(Rect.Left, 2)
    else
      Dec(Rect.Right, 2);
    Data := ListBoxItem.Items[Index];
    Stditem := pTStditem(ListBoxItem.Items.Objects[Index]);
    if (Stditem <> nil) and (pTItemRule(Stditem.Rule).nCheck > 0) then begin
      if odSelected in State then
        ListBoxItem.Canvas.Font.Color := clHighlightText
      else
        ListBoxItem.Canvas.Font.Color := clBlue;
    end;
    DrawText(ListBoxItem.Canvas.Handle, PChar(Data), Length(Data), Rect, Flags);
  end;
end;

procedure TfrmViewList.ListBoxitemList2Click(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if ListBoxitemList2.ItemIndex >= 0 then
    ButtonGameLogAdd.Enabled := True;
end;

procedure TfrmViewList.ListViewSuitClick(Sender: TObject);
  function GetEdit(nTag: Integer): TEdit;
  var
    I: Integer;
  begin
    Result := nil;
    for I := 0 to GroupBox10.ControlCount - 1 do begin
      if GroupBox10.Controls[I] is TEdit then
        if TEdit(GroupBox10.Controls[I]).Tag = nTag then begin
          Result := TEdit(GroupBox10.Controls[I]);
          Break;
        end;
    end;
  end;
var
  sStr, sItemStr, sTagStr: string;
  TempList: TStringList;
  I, k: Integer;
  Control: TControl;
  boAdd: Boolean;
  Item: TListItem;
  StdItem: pTStdItem;
  btWhere: Integer;
  Edit: TEdit;
begin
  Item := ListViewSuit.Selected;
  if Item <> nil then begin
    Button2.Enabled := True;
    Button3.Enabled := True;
    Edit1.Text := Item.Caption;
    sStr := Item.SubItems[0];
    for I := 0 to GroupBox10.ControlCount - 1 do begin
      if (GroupBox10.Controls[I] is TEdit) then begin
        TEdit(GroupBox10.Controls[I]).Text := '';
      end;
    end;
    while True do begin
      if sStr = '' then break;
      sStr := GetValidStr3(sStr, sItemStr, [',']);
      if sItemStr = '' then break;
      I := ListBoxSetItems.Items.IndexOf(sItemStr);
      if I > -1 then begin
        StdItem := pTStdItem(ListBoxSetItems.Items.Objects[I]);
        if sm_Arming in StdItem.StdModeEx then begin
          btWhere := GetTakeOnPosition(StdItem.StdMode);
          if btWhere in [Low(THumanUseItems)..High(THumanUseItems)] then begin
            if (btWhere = U_DRESS) and (StdItem.StdMode2 = 11) then
              btWhere := U_BUJUK;
            if (btWhere = U_RINGL) then begin
              Edit := GetEdit(U_RINGL);
              if (Edit <> nil) and (Edit.Text <> '') then
                btWhere := U_RINGR;
            end;

            if (btWhere = U_ARMRINGL) then begin
              Edit := GetEdit(U_ARMRINGL);
              if (Edit <> nil) and (Edit.Text <> '') then
                btWhere := U_ARMRINGR;
            end;

            Edit := GetEdit(btWhere);
            if (Edit <> nil) then
              Edit.Text := ListBoxSetItems.Items[I];
            Button1.Enabled := True;
          end;
        end;
      end;
      //ListBox3.Items.Add(sItemStr);
    end;
    TempList := TStringList.Create;
    sStr := Item.SubItems[1];
    while True do begin
      if sStr = '' then break;
      sStr := GetValidStr3(sStr, sItemStr, [',']);
      if sItemStr = '' then break;
      sItemStr := GetValidStr3(sItemStr, sTagStr, ['.']);
      if sItemStr = '' then break;
      TempList.AddObject(sItemStr, TObject(StrToIntDef(sTagStr, -1)));
    end;
    for I := 0 to GroupBox6.ControlCount - 1 do begin
      Control := GroupBox6.Controls[I];
      if Control is TSpinEdit then begin
        boAdd := False;
        for K := 0 to TempList.Count - 1 do begin
          if TSpinEdit(Control).Tag = Integer(TempList.Objects[k]) then begin
            TSpinEdit(Control).Value := StrToIntDef(TempList[k], 0);
            boAdd := True;
            Break;
          end;
        end;
        if not boAdd then TSpinEdit(Control).Value := 0;
      end;
    end;
    TempList.Free;
    CheckBox2.Checked := StrToBoolDef(Item.SubItems[2], False);
  end;
end;

procedure TfrmViewList.ButtonGameLogAddClick(Sender: TObject);
var
  i: Integer;
begin
  if ListBoxitemList2.ItemIndex >= 0 then begin
    for i := 0 to ListBoxGameLogList.Items.Count - 1 do begin
      if ListBoxGameLogList.Items.Strings[i] =
        ListBoxitemList2.Items.Strings[ListBoxitemList2.ItemIndex] then begin
        Application.MessageBox('此物品已在列表中.', '错误信息', MB_OK + MB_ICONERROR);
        Exit;
      end;
    end;
    ListBoxGameLogList.Items.Add(ListBoxitemList2.Items.Strings[ListBoxitemList2.ItemIndex]);
    ModValue();
  end;
end;

procedure TfrmViewList.ButtonGameLogDelClick(Sender: TObject);
begin
  if ListBoxGameLogList.ItemIndex >= 0 then begin
    ListBoxGameLogList.Items.Delete(ListBoxGameLogList.ItemIndex);
    ModValue();
  end;
  if ListBoxGameLogList.ItemIndex < 0 then
    ButtonGameLogDel.Enabled := False;
end;

procedure TfrmViewList.ButtonGameLogAddAllClick(Sender: TObject);
var
  i: Integer;
begin
  ListBoxGameLogList.Items.Clear;
  for i := 0 to ListBoxitemList2.Items.Count - 1 do begin
    ListBoxGameLogList.Items.Add(ListBoxitemList2.Items.Strings[i]);
  end;
  ModValue();
end;

procedure TfrmViewList.ButtonGameLogDelAllClick(Sender: TObject);
begin
  ListBoxGameLogList.Items.Clear;
  ButtonGameLogDel.Enabled := False;
  ModValue();
end;

procedure TfrmViewList.ButtonGameLogSaveClick(Sender: TObject);
var
  i: Integer;
begin

  g_GameLogItemNameList.Lock;
  try
    g_GameLogItemNameList.Clear;
    for i := 0 to ListBoxGameLogList.Items.Count - 1 do begin
      g_GameLogItemNameList.Add(ListBoxGameLogList.Items.Strings[i])
    end;
  finally
    g_GameLogItemNameList.UnLock;
  end;
  uModValue();
{$IF SoftVersion <> VERDEMO}
  SaveGameLogItemNameList();
{$IFEND}
  if
    Application.MessageBox('此设置必须重新加载物品数据库才能生效，是否重新加载？',
    '确认信息', MB_YESNO + MB_ICONQUESTION) = mrYes then begin
    FrmDB.LoadItemsDB();
    RefLoadItems;
  end;
end;

procedure TfrmViewList.RefAdminList();
var
  i: Integer;
  AdminInfo: pTAdminInfo;
begin
  ListBoxAdminList.Clear;
  EditAdminName.Text := '';
  EditAdminIPaddr.Text := '';
  EditAdminPremission.Value := 0;
  ButtonAdminListChange.Enabled := False;
  ButtonAdminListDel.Enabled := False;
  UserEngine.m_AdminList.Lock;
  try
    for i := 0 to UserEngine.m_AdminList.Count - 1 do begin
      AdminInfo := pTAdminInfo(UserEngine.m_AdminList.Items[i]);
{$IF VEROWNER = WL}
      ListBoxAdminList.Items.Add(AdminInfo.sChrName + ' - ' +
        IntToStr(AdminInfo.nLv) + ' - ' + AdminInfo.sIPaddr)
{$ELSE}
      ListBoxAdminList.Items.Add(AdminInfo.sChrName + ' - ' +
        IntToStr(AdminInfo.nLv))
{$IFEND}
    end;
  finally
    UserEngine.m_AdminList.UnLock;
  end;
end;

procedure TfrmViewList.RefNoClearMonList;

begin

end;

procedure TfrmViewList.RefRuleCheckBoxAll(ItemRule: pTItemRule);
var
  i, ii: integer;
  Control: TControl;
begin
  for I := 0 to GroupBox18.ControlCount - 1 do begin
    Control := GroupBox18.Controls[I];
    if Control is TCheckBox then begin
      TCheckBox(Control).Checked := False;
      if ItemRule <> nil then begin
        for II := Low(ItemRule.Rule) to High(ItemRule.Rule) do begin
          if II = TCheckBox(Control).Tag then begin
            TCheckBox(Control).Checked := ItemRule.Rule[II];
            break;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmViewList.RefSetItems;
var
  I, k: Integer;
  Item: TListItem;
  SetItems: pTSetItems;
  sAddStr: string;
begin
  ListViewSuit.Items.Clear;
  for I := 0 to g_SetItemsList.Count - 1 do begin
    SetItems := pTSetItems(g_SetItemsList[I]);
    Item := ListViewSuit.Items.Add;
    Item.Caption := SetItems.sHint;
    sAddStr := '';
    for k := Low(SetItems.Items) to High(SetItems.Items) do
      if SetItems.Items[k] <> '' then sAddStr := sAddStr + SetItems.Items[k] + ',';
    Item.SubItems.Add(sAddStr);

    sAddStr := '';
    for k := Low(SetItems.Value) to High(SetItems.Value) do
      if SetItems.Value[k] > 0 then sAddStr := sAddStr + IntToStr(k) + '.' + IntToStr(SetItems.Value[k]) + ',';
    Item.SubItems.Add(sAddStr);

    Item.SubItems.Add(BoolToStr(SetItems.HideValue));
  end;
end;

procedure TfrmViewList.RefUserCmd;
var
  I: Integer;
begin
  if g_UserCmdList.Count > 1 then StringGridUserCmd.RowCount := g_UserCmdList.Count + 1
  else StringGridUserCmd.RowCount := 2;
  StringGridUserCmd.Cells[0, 1] := '';
  StringGridUserCmd.Cells[1, 1] := '';
  StringGridUserCmd.Cells[2, 1] := '';
  
  g_UserCmdList.Lock;
  Try
    for I := 0 to g_UserCmdList.Count - 1 do begin
      StringGridUserCmd.Cells[0, I + 1] := g_UserCmdList[I];
      StringGridUserCmd.Cells[1, I + 1] := IntToStr(Integer(g_UserCmdList.Objects[I]));
      StringGridUserCmd.Cells[2, I + 1] := SUSERCMD + IntToStr(Integer(g_UserCmdList.Objects[I]));
    end;
  Finally
    g_UserCmdList.UnLock;
  End;
end;

procedure TfrmViewList.StringGridMonDropLimitClick(Sender: TObject);
var
  Idx: Integer;
begin

  Idx := StringGridMonDropLimit.Row;
  if Idx > 0 then begin
    EditMonDropName.Text := StringGridMonDropLimit.Cells[0, Idx];
    EditMonDropMaxCount.Text := StringGridMonDropLimit.Cells[2, Idx];
    EditMonDropMinCount.Text := StringGridMonDropLimit.Cells[1, Idx];
    EditMonDropYear.Value := StrToIntDef(Copy(StringGridMonDropLimit.Cells[3, Idx], 1, 4), 0);
    EditMonDropMonth.Value := StrToIntDef(Copy(StringGridMonDropLimit.Cells[3, Idx], 5, 2), 0);
    EditMonDropDay.Value := StrToIntDef(Copy(StringGridMonDropLimit.Cells[3, Idx], 7, 2), 0);
    EditMonDropHour.Value := StrToIntDef(Copy(StringGridMonDropLimit.Cells[3, Idx], 9, 2), 0);
    ButtonMonDropAdd.Enabled := False;
    ButtonMonDropEdit.Enabled := True;
    ButtonMonDropDel.Enabled := True;
  end;
end;

procedure TfrmViewList.StringGridUserCmdClick(Sender: TObject);
var
  Idx: Integer;
begin
  Idx := StringGridUserCmd.Row;
  if Idx > 0 then begin
    EditUserCmdName.Text := StringGridUserCmd.Cells[0, Idx];
    EditUserCmdID.Text := StringGridUserCmd.Cells[1, Idx];
    ButtonUserCmdDel.Enabled := True;
    ButtonUserCmdEdit.Enabled := True;
  end;
end;

procedure TfrmViewList.ButtonNoClearMonSaveClick(Sender: TObject);

begin

  uModValue();
end;

procedure TfrmViewList.ButtonRuleSaveClick(Sender: TObject);
begin
  SaveRuleItemList;
  uModValue();
end;

procedure TfrmViewList.ButtonUserCmdAddClick(Sender: TObject);
var
  sName, sID: string;
  I: Integer;
begin
  sName := Trim(EditUserCmdName.Text);
  sID := EditUserCmdID.Text;
  if sName <> '' then begin
    for I := 1 to StringGridUserCmd.RowCount - 1 do begin
      if CompareText(sName, StringGridUserCmd.Cells[0, I]) = 0 then begin
        Application.MessageBox('该命令名称已经存在！', '提示信息', MB_OK +  MB_ICONINFORMATION);
        Exit;
      end else
      if CompareText(sID, StringGridUserCmd.Cells[1, I]) = 0 then begin
        Application.MessageBox('该命令标识已经存在！', '提示信息', MB_OK +  MB_ICONINFORMATION);
        Exit;
      end;
    end;
    if StringGridUserCmd.RowCount = 2 then begin
      if StringGridUserCmd.Cells[0, 1] <> '' then begin
        I := StringGridUserCmd.RowCount;
        StringGridUserCmd.RowCount := StringGridUserCmd.RowCount + 1;
      end
      else
        I := 1;
    end else begin
      I := StringGridUserCmd.RowCount;
      StringGridUserCmd.RowCount := StringGridUserCmd.RowCount + 1;
    end;
    StringGridUserCmd.Cells[0, I] := EditUserCmdName.Text;
    StringGridUserCmd.Cells[1, I] := EditUserCmdID.Text;
    StringGridUserCmd.Cells[2, I] := SUSERCMD + EditUserCmdID.Text;
    ButtonUserCmdSave.Enabled := True;
  end;
end;

procedure TfrmViewList.ButtonUserCmdDelClick(Sender: TObject);
var
  Idx: Integer;
  I: Integer;
begin
  Idx := StringGridUserCmd.Row;
  if idx > 0 then begin
    if StringGridUserCmd.RowCount = 2 then begin
      StringGridUserCmd.Cells[0, 1] := '';
      StringGridUserCmd.Cells[1, 1] := '';
      StringGridUserCmd.Cells[2, 1] := '';
      ButtonUserCmdSave.Enabled := True;
    end else begin
      for I := Idx + 1 to StringGridUserCmd.RowCount - 1 do begin
        StringGridUserCmd.Cells[0, I - 1] := StringGridUserCmd.Cells[0, I];
        StringGridUserCmd.Cells[1, I - 1] := StringGridUserCmd.Cells[1, I];
        StringGridUserCmd.Cells[2, I - 1] := StringGridUserCmd.Cells[2, I];
      end;
      StringGridUserCmd.RowCount := StringGridUserCmd.RowCount - 1;
      ButtonUserCmdSave.Enabled := True;
    end;
  end;
end;

procedure TfrmViewList.ButtonUserCmdEditClick(Sender: TObject);
var
  Idx, I: Integer;
  sName, sID: string;
begin
  Idx := StringGridUserCmd.Row;
  if idx > 0 then begin
    sName := Trim(EditUserCmdName.Text);
    sID := EditUserCmdID.Text;
    for I := 1 to StringGridUserCmd.RowCount - 1 do begin
      if I = Idx then Continue;
      if CompareText(sName, StringGridUserCmd.Cells[0, I]) = 0 then begin
        Application.MessageBox('该命令名称已经存在！', '提示信息', MB_OK +  MB_ICONINFORMATION);
        Exit;
      end else
      if CompareText(sID, StringGridUserCmd.Cells[1, I]) = 0 then begin
        Application.MessageBox('该命令标识已经存在！', '提示信息', MB_OK +  MB_ICONINFORMATION);
        Exit;
      end;
    end;
    StringGridUserCmd.Cells[0, idx] := sName;
    StringGridUserCmd.Cells[1, idx] := sID;
    StringGridUserCmd.Cells[2, idx] := SUSERCMD + sID;
    ButtonUserCmdSave.Enabled := True;
  end;
end;

procedure TfrmViewList.ButtonUserCmdSaveClick(Sender: TObject);
var
  I: Integer;
  SaveList: TStringList;
begin
  g_UserCmdList.Lock;
  SaveList := TStringList.Create;
  SaveList.Add(';自定义GM命令配置文件');
  SaveList.Add(';命令名称'#9'对应编号');
  Try
    g_UserCmdList.Clear;
    for I := 1 to StringGridUserCmd.RowCount - 1 do begin
      g_UserCmdList.AddObject(StringGridUserCmd.Cells[0, I], TObject(StrToIntDef(StringGridUserCmd.Cells[1, I], 0)));
      SaveList.Add(StringGridUserCmd.Cells[0, I] + #9 + StringGridUserCmd.Cells[1, I]);
    end;
    SaveList.SaveToFile(g_Config.sEnvirDir + 'UserCmd.txt');
  Finally
    SaveList.Free;
    g_UserCmdList.UnLock;
  End;
  ButtonUserCmdSave.Enabled := False;
end;

procedure TfrmViewList.CheckBox1Click(Sender: TObject);
var
  i, Idx: integer;
  StdItem: pTStdItem;
begin
  ListBoxItem.Clear;
  ComboBox1.Enabled := CheckBox1.Checked;
  Idx := ComboBox1.ItemIndex - 1;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    for i := 0 to UserEngine.StdItemList.Count - 1 do begin
      StdItem := UserEngine.StdItemList.Items[i];
      if (CheckBox1.Checked and (((pTItemRule(StdItem.Rule).nCheck > 0) and (Idx = -1))) or pTItemRule(StdItem.Rule).Rule[Idx]) or
        (not CheckBox1.Checked) then
        ListBoxItem.Items.AddObject(StdItem.Name, TObject(StdItem));
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TfrmViewList.CheckBoxMakeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
begin
  with Sender as TCheckBox do begin
    if Tag in [0..RULE_COUNT - 1] then begin
      if ListBoxItem.SelCount > 1 then begin
        for I := 0 to ListBoxItem.Count - 1 do begin
          if ListBoxItem.Selected[I] then
            pTStdItem(ListBoxItem.Items.Objects[I]).Rule.Rule[Tag] := Checked;
        end;
      end
      else if (ListBoxItem.ItemIndex >= 0) and (ListBoxItem.ItemIndex < ListBoxItem.Count) then begin
        pTStdItem(ListBoxItem.Items.Objects[ListBoxItem.ItemIndex]).Rule.Rule[Tag] := Checked;
      end;
    end;
  end;
  ModValue();
end;

procedure TfrmViewList.EditHPChange(Sender: TObject);
begin
  with Sender as TSpinEdit do begin
    if Value > 0 then Color := clLime
    else Color := clWhite;
  end;
end;

procedure TfrmViewList.ButtonAdminLitsSaveClick(Sender: TObject);
begin
  SaveAdminList();
  ButtonAdminLitsSave.Enabled := False;
end;

procedure TfrmViewList.ListBox1Click(Sender: TObject);
begin
  if not boOpened then
    Exit;
  if ListBox1.ItemIndex >= 0 then begin
    ButtonMonDropAdd.Enabled := True;
    ButtonMonDropEdit.Enabled := False;
    ButtonMonDropDel.Enabled := False;
    EditMonDropName.Text := pTStdItem(ListBox1.Items.Objects[ListBox1.ItemIndex]).Name;
  end;
end;

procedure TfrmViewList.ListBox1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  sIPaddr: string;
  I, nIdx: Integer;
begin
  if (ssCtrl in Shift) and (Key = word('F')) then begin
    sIPaddr := InputBox('查找信息', '请输入要查找的内容(支持模糊查找)', '');
    nIdx := TListBox(Sender).ItemIndex + 1;
    if nIdx >= TListBox(Sender).Count then
      nIdx := 0;
    for I := nIdx to TListBox(Sender).Count - 1 do begin
      if CompareLStr(TListBox(Sender).Items.Strings[I], sIPaddr, Length(sIPAddr)) then begin
        TListBox(Sender).Selected[I] := True;
        break;
      end;
    end;
  end;
end;

procedure TfrmViewList.ListBoxAdminListClick(Sender: TObject);
var
  nIndex: Integer;
  AdminInfo: pTAdminInfo;
begin
  nIndex := ListBoxAdminList.ItemIndex;
  UserEngine.m_AdminList.Lock;
  try
    if (nIndex < 0) and (nIndex >= UserEngine.m_AdminList.Count) then
      Exit;
    ButtonAdminListChange.Enabled := True;
    ButtonAdminListDel.Enabled := True;
    AdminInfo := UserEngine.m_AdminList.Items[nIndex];
    EditAdminName.Text := AdminInfo.sChrName;
    EditAdminIPaddr.Text := AdminInfo.sIPaddr;
    EditAdminPremission.Value := AdminInfo.nLv;
  finally
    UserEngine.m_AdminList.UnLock;
  end;
end;

procedure TfrmViewList.A1Click(Sender: TObject);
  {function CheckItemUseCount(sItemName: string): Integer;
  var
    Item: TListItem;
    I: Integer;
  begin
    Result := 0;
    for I := 0 to ListViewSuit.Items.Count - 1 do begin
      Item := ListViewSuit.Items[I];
      if Pos(sItemName + ',', Item.SubItems[0]) > 0 then
        Inc(Result);
    end;
  end;   }

  function GetEdit(nTag: Integer): TEdit;
  var
    I: Integer;
  begin
    Result := nil;
    for I := 0 to GroupBox10.ControlCount - 1 do begin
      if GroupBox10.Controls[I] is TEdit then
        if TEdit(GroupBox10.Controls[I]).Tag = nTag then begin
          Result := TEdit(GroupBox10.Controls[I]);
          Break;
        end;
    end;
  end;
  
var
  I: Integer;
  StdItem: pTStdItem;
  btWhere: Integer;
  Edit: TEdit;
begin
  for I := 0 to ListBoxSetItems.Count - 1 do begin
    if ListBoxSetItems.Selected[I] then begin
      StdItem := pTStdItem(ListBoxSetItems.Items.Objects[I]);
      if sm_Arming in StdItem.StdModeEx then begin
        btWhere := GetTakeOnPosition(StdItem.StdMode);
        if btWhere in [Low(THumanUseItems)..High(THumanUseItems)] then begin
         { if CheckItemUseCount(StdItem.Name) > 1 then begin
            Application.MessageBox(PChar(string(StdItem.Name + ' 添加失败，同一件装备最多只允许创建两个套装！')), '提示信息', MB_OK + MB_ICONERROR);
            Continue;
          end;       }
          if (btWhere = U_DRESS) and (StdItem.StdMode2 = 11) then
            btWhere := U_BUJUK;
          if (btWhere = U_RINGL) then begin
            Edit := GetEdit(U_RINGL);
            if (Edit <> nil) and (Edit.Text <> '') then
              btWhere := U_RINGR;
          end;

          if (btWhere = U_ARMRINGL) then begin
            Edit := GetEdit(U_ARMRINGL);
            if (Edit <> nil) and (Edit.Text <> '') then
              btWhere := U_ARMRINGR;
          end;
           
          Edit := GetEdit(btWhere);
          if (Edit <> nil) then
            Edit.Text := ListBoxSetItems.Items[I];
          Button1.Enabled := True;
        end;
      end;
    end;
  end;
end;
 {
function TfrmViewList.CheckItemUseCount(sItemName: string; nIndex: Integer): Integer;
var
  Item: TListItem;
  I: Integer;
begin
  Result := 0;
  for I := 0 to ListViewSuit.Items.Count - 1 do begin
    Item := ListViewSuit.Items[I];
    if I = nIndex then Continue;
    if Pos(sItemName + ',', Item.SubItems[0]) > 0 then
      Inc(Result);
  end;
end;    }

procedure TfrmViewList.Button1Click(Sender: TObject);
var
  sTempStr, sTempStr2: string;
  I: Integer;
  Item: TListItem;
  Control: TControl;
  nCount: Integer;
begin
 { if ListBox3.Items.Count < 1 then begin
    Application.MessageBox('至少需要指定一件装备才能组成套装！', '提示信息', MB_OK + MB_ICONERROR);
    Exit;
  end;  }

  sTempStr := '';
  nCount := 0;
  for I := 0 to GroupBox10.ControlCount - 1 do begin
    if (GroupBox10.Controls[I] is TEdit) and (Trim(TEdit(GroupBox10.Controls[I]).Text) <> '') then begin
      if ListBoxSetItems.Items.IndexOf(Trim(TEdit(GroupBox10.Controls[I]).Text)) = -1 then begin
        Application.MessageBox(PChar(Trim(TEdit(GroupBox10.Controls[I]).Text) + ' 物品名称设置错误！'), '提示信息', MB_OK + MB_ICONERROR);
        Exit;
      end;
      {if CheckItemUseCount(Trim(TEdit(GroupBox10.Controls[I]).Text), -1) >= 2 then begin
        Application.MessageBox(PChar(Trim(TEdit(GroupBox10.Controls[I]).Text) + ' 添加失败！' + #13#10 + '同一件装备最多只允许创建两套套装！'), '提示信息', MB_OK + MB_ICONERROR);
        Exit;
      end;   }
      sTempStr := sTempStr + Trim(TEdit(GroupBox10.Controls[I]).Text) + ',';
      Inc(nCount);
    end;
  end;
  if nCount < 1 then begin
    Application.MessageBox('至少需要指定一件装备才能组成套装！', '提示信息', MB_OK + MB_ICONERROR);
    Exit;
  end;
  for I := 0 to ListViewSuit.Items.Count - 1 do begin
    Item := ListViewSuit.Items[I];
    if CompareText(Item.SubItems[0], sTempStr) = 0 then begin
      Application.MessageBox('已经存在相同的套装装备配置！', '提示信息', MB_OK + MB_ICONERROR);
      Exit;
    end;
  end;
  sTempStr2 := '';
  for I := 0 to GroupBox6.ControlCount - 1 do begin
    Control := GroupBox6.Controls[I];
    if Control is TSpinEdit then begin
      if TSpinEdit(Control).Value > 0 then
        sTempStr2 := sTempStr2 + IntToStr(TSpinEdit(Control).Tag) + '.' + TSpinEdit(Control).Text + ',';
    end;
  end;
  if sTempStr2 = '' then begin
    Application.MessageBox('至少需要设置一种套装属性！', '提示信息', MB_OK + MB_ICONERROR);
    Exit;
  end;
  Item := ListViewSuit.Items.Add;
  Item.Caption := Edit1.Text;
  Item.SubItems.Add(sTempStr);
  Item.SubItems.Add(sTempStr2);
  Item.SubItems.Add(BoolToStr(CheckBox2.Checked));
  Button1.Enabled := False;
  Button2.Enabled := False;
  Button3.Enabled := False;
  Button4.Enabled := True;
  for I := 0 to GroupBox10.ControlCount - 1 do begin
    if (GroupBox10.Controls[I] is TEdit) then begin
      TEdit(GroupBox10.Controls[I]).Text := '';
    end;
  end;
  Edit1.Text := '';
  for I := 0 to GroupBox6.ControlCount - 1 do begin
    Control := GroupBox6.Controls[I];
    if Control is TSpinEdit then begin
      TSpinEdit(Control).Value := 0;
    end;
  end;
end;

procedure TfrmViewList.Button2Click(Sender: TObject);
var
  sTempStr, sTempStr2: string;
  I: Integer;
  Item: TListItem;
  Control: TControl;
  nCount: Integer;
begin
  if ListViewSuit.ItemIndex = -1 then begin
    Application.MessageBox('请先选择要修改的套装！', '提示信息', MB_OK + MB_ICONERROR);
    Exit;
  end;

  sTempStr := '';
  nCount := 0;
  for I := 0 to GroupBox10.ControlCount - 1 do begin
    if (GroupBox10.Controls[I] is TEdit) and (Trim(TEdit(GroupBox10.Controls[I]).Text) <> '') then begin
      if ListBoxSetItems.Items.IndexOf(Trim(TEdit(GroupBox10.Controls[I]).Text)) = -1 then begin
        Application.MessageBox(PChar(Trim(TEdit(GroupBox10.Controls[I]).Text) + ' 物品名称设置错误！'), '提示信息', MB_OK + MB_ICONERROR);
        Exit;
      end;
      {if CheckItemUseCount(Trim(TEdit(GroupBox10.Controls[I]).Text), ListViewSuit.ItemIndex) >= 2 then begin
        Application.MessageBox(PChar(Trim(TEdit(GroupBox10.Controls[I]).Text) + ' 添加失败！' + #13#10 + '同一件装备最多只允许创建两套套装！'), '提示信息', MB_OK + MB_ICONERROR);
        Exit;
      end;    }
      sTempStr := sTempStr + Trim(TEdit(GroupBox10.Controls[I]).Text) + ',';
      Inc(nCount);
    end;
  end;
  if nCount < 1 then begin
    Application.MessageBox('至少需要指定一件装备才能组成套装！', '提示信息', MB_OK + MB_ICONERROR);
    Exit;
  end;

  for I := 0 to ListViewSuit.Items.Count - 1 do begin
    if I = ListViewSuit.ItemIndex then Continue;
    Item := ListViewSuit.Items[I];
    if CompareText(Item.SubItems[0], sTempStr) = 0 then begin
      Application.MessageBox('已经存在相同的套装装备配置！', '提示信息', MB_OK + MB_ICONERROR);
      Exit;
    end;
  end;
  sTempStr2 := '';
  for I := 0 to GroupBox6.ControlCount - 1 do begin
    Control := GroupBox6.Controls[I];
    if Control is TSpinEdit then begin
      if TSpinEdit(Control).Value > 0 then
        sTempStr2 := sTempStr2 + IntToStr(TSpinEdit(Control).Tag) + '.' + TSpinEdit(Control).Text + ',';
    end;
  end;
  if sTempStr2 = '' then begin
    Application.MessageBox('至少需要设置一种套装属性！', '提示信息', MB_OK + MB_ICONERROR);
    Exit;
  end;
  Item := ListViewSuit.Items[ListViewSuit.ItemIndex];
  Item.Caption := Edit1.Text;
  Item.SubItems[0] := sTempStr;
  Item.SubItems[1] := sTempStr2;
  Item.SubItems[2] := BoolToStr(CheckBox2.Checked);
  Button2.Enabled := False;
  Button4.Enabled := True; 
end;

procedure TfrmViewList.Button3Click(Sender: TObject);
var
  I: Integer;
  Control: TControl;
begin
  if ListViewSuit.ItemIndex = -1 then begin
    Application.MessageBox('请先选择要删除的套装！', '提示信息', MB_OK + MB_ICONERROR);
    Exit;
  end;
  ListViewSuit.Items.Delete(ListViewSuit.ItemIndex);
  Button3.Enabled := False;
  Button2.Enabled := False;
  Button4.Enabled := True;
  for I := 0 to GroupBox10.ControlCount - 1 do begin
    if (GroupBox10.Controls[I] is TEdit) then begin
      TEdit(GroupBox10.Controls[I]).Text := '';
    end;
  end;
  Edit1.Text := '';
  for I := 0 to GroupBox6.ControlCount - 1 do begin
    Control := GroupBox6.Controls[I];
    if Control is TSpinEdit then begin
      TSpinEdit(Control).Value := 0;
    end;
  end;   
end;

procedure TfrmViewList.Button4Click(Sender: TObject);
var
  SaveList: TStringList;
  I: Integer;
  Item: TListItem;
begin
  SaveList := TStringList.Create;
  Try
    for I := 0 to ListViewSuit.Items.Count - 1 do begin
      Item := ListViewSuit.Items[I];
      SaveList.Add(Item.SubItems[0] + #9 + Item.SubItems[1] + #9 + '"' + Item.Caption + '"' + #9 + Item.SubItems[2]);  
    end;
    SaveList.SaveToFile(g_Config.sGameDataDir + 'SetItems.txt');
  Finally
    SaveList.Free;
  End;
  FrmDB.LoadItemsDB();
  RefLoadItems();
  uModValue();
end;

procedure TfrmViewList.ButtonAdminListAddClick(Sender: TObject);
var
  i: Integer;
  sAdminName: string;
  sAdminIPaddr: string;
  nAdminPerMission: Integer;
  AdminInfo: pTAdminInfo;
begin
  sAdminName := Trim(EditAdminName.Text);
  sAdminIPaddr := Trim(EditAdminIPaddr.Text);
  nAdminPerMission := EditAdminPremission.Value;
  if (nAdminPerMission < 1) or (sAdminName = '') or not (nAdminPerMission in
    [0..10]) then begin
    Application.MessageBox('输入不正确.', '提示信息', MB_OK + MB_ICONERROR);
    EditAdminName.SetFocus;
    Exit;
  end;
{$IF VEROWNER = WL}
  if (sAdminIPaddr = '') then begin
    Application.MessageBox('登录IP输入不正确.', '提示信息', MB_OK + MB_ICONERROR);
    EditAdminIPaddr.SetFocus;
    Exit;
  end;
{$IFEND}

  UserEngine.m_AdminList.Lock;
  try
    for i := 0 to UserEngine.m_AdminList.Count - 1 do begin
      if CompareText(pTAdminInfo(UserEngine.m_AdminList.Items[i]).sChrName, sAdminName) = 0 then begin
        Application.MessageBox('输入的角色名已经在GM列表中.', '提示信息', MB_OK + MB_ICONERROR);
        Exit;
      end;
    end;
    New(AdminInfo);
    AdminInfo.nLv := nAdminPerMission;
    AdminInfo.sChrName := sAdminName;
    AdminInfo.sIPaddr := sAdminIPaddr;
    UserEngine.m_AdminList.Add(AdminInfo);
  finally
    UserEngine.m_AdminList.UnLock;
  end;
  RefAdminList();
  ButtonAdminLitsSave.Enabled := True;
end;

procedure TfrmViewList.ButtonAdminListChangeClick(Sender: TObject);
var
  nIndex: Integer;
  sAdminName: string;
  sAdminIPaddr: string;
  nAdminPerMission: Integer;
  AdminInfo: pTAdminInfo;
begin
  nIndex := ListBoxAdminList.ItemIndex;
  if nIndex < 0 then
    Exit;

  sAdminName := Trim(EditAdminName.Text);
  sAdminIPaddr := Trim(EditAdminIPaddr.Text);
  nAdminPerMission := EditAdminPremission.Value;
  if (nAdminPerMission < 1) or (sAdminName = '') or not (nAdminPerMission in [0..10]) then begin
    Application.MessageBox('输入不正确.', '提示信息', MB_OK + MB_ICONERROR);
    EditAdminName.SetFocus;
    Exit;
  end;
{$IF VEROWNER = WL}
  if (sAdminIPaddr = '') then begin
    Application.MessageBox('登录IP输入不正确.', '提示信息', MB_OK + MB_ICONERROR);
    EditAdminIPaddr.SetFocus;
    Exit;
  end;
{$IFEND}
  UserEngine.m_AdminList.Lock;
  try
    if (nIndex < 0) and (nIndex >= UserEngine.m_AdminList.Count) then
      Exit;
    AdminInfo := UserEngine.m_AdminList.Items[nIndex];
    AdminInfo.sChrName := sAdminName;
    AdminInfo.nLv := nAdminPerMission;
    AdminInfo.sIPaddr := sAdminIPaddr;
  finally
    UserEngine.m_AdminList.UnLock;
  end;
  RefAdminList();
  ButtonAdminLitsSave.Enabled := True;
end;

procedure TfrmViewList.ButtonAdminListDelClick(Sender: TObject);
var
  nIndex: Integer;
begin
  nIndex := ListBoxAdminList.ItemIndex;
  if nIndex < 0 then Exit;
  UserEngine.m_AdminList.Lock;
  try
    if (nIndex < 0) and (nIndex >= UserEngine.m_AdminList.Count) then Exit;
    DisPose(pTAdminInfo(UserEngine.m_AdminList.Items[nIndex]));
    UserEngine.m_AdminList.Delete(nIndex);
  finally
    UserEngine.m_AdminList.UnLock;
  end;
  RefAdminList();
  ButtonAdminLitsSave.Enabled := True;
end;

procedure TfrmViewList.RefItemBindAccount;
begin

end;

procedure TfrmViewList.ButtonItemBindAcountModClick(Sender: TObject);
begin
  RefItemBindAccount();
end;

procedure TfrmViewList.ButtonItemBindAcountRefClick(Sender: TObject);
begin
  RefItemBindAccount();
end;

procedure TfrmViewList.ButtonItemBindAcountAddClick(Sender: TObject);

begin

  RefItemBindAccount();
end;

procedure TfrmViewList.ButtonItemBindAcountDelClick(Sender: TObject);

begin

  RefItemBindAccount();
end;

procedure TfrmViewList.RefItemBindCharName;

begin

end;

procedure TfrmViewList.ButtonItemBindCharNameAddClick(Sender: TObject);

begin

  RefItemBindCharName();
end;

procedure TfrmViewList.ButtonItemBindCharNameModClick(Sender: TObject);

begin

  RefItemBindCharName();

end;

procedure TfrmViewList.ButtonItemBindCharNameDelClick(Sender: TObject);

begin

  RefItemBindCharName();
end;

procedure TfrmViewList.ButtonItemBindCharNameRefClick(Sender: TObject);
begin
  RefItemBindCharName();
end;

procedure TfrmViewList.RefItemBindIPaddr;

begin

end;

procedure TfrmViewList.ButtonItemBindIPaddrAddClick(Sender: TObject);

begin

  RefItemBindIPaddr();
end;

procedure TfrmViewList.ButtonItemBindIPaddrModClick(Sender: TObject);

begin

  RefItemBindIPaddr();
end;

procedure TfrmViewList.ButtonItemBindIPaddrDelClick(Sender: TObject);

begin

  RefItemBindIPaddr();
end;

procedure TfrmViewList.ButtonItemBindIPaddrRefClick(Sender: TObject);
begin
  RefItemBindIPaddr();
end;

procedure TfrmViewList.RefItemCustomNameList;

begin

end;

procedure TfrmViewList.RefLoadItems;
var
  I: Integer;
  StdItem: pTStditem;
begin
  //
  ListBoxitemList2.Items.Clear;
  ListBox1.Items.Clear;
  ListBoxSetItems.Items.Clear;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    ListBoxitemList2.Items.AddObject(g_sHumanDieEvent, TObject(nil));
    ListBoxitemList2.Items.AddObject(sSTRING_GOLDNAME, TObject(nil));
    ListBoxitemList2.Items.AddObject(sSTRING_BINDGOLDNAME, TObject(nil));
    ListBoxitemList2.Items.AddObject(sSTRING_GAMEGOLD, TObject(nil));
    ListBoxitemList2.Items.AddObject(sSTRING_GAMEPOINT, TObject(nil));
    ListBoxitemList2.Items.AddObject(sSTRING_GAMEDIAMOND, TObject(nil));
    ListBoxitemList2.Items.AddObject(sSTRING_CREDITPOINT, TObject(nil));
    ListBoxitemList2.Items.AddObject(sSTRING_CUSTOMVARIABLE, TObject(nil));

    for i := 0 to UserEngine.StdItemList.Count - 1 do begin
      StdItem := UserEngine.StdItemList.Items[i];
      ListBoxitemList2.Items.AddObject(StdItem.Name, TObject(StdItem));
      ListBox1.Items.AddObject(StdItem.Name, TObject(StdItem));
      if sm_Arming in Stditem.StdModeEx then
        ListBoxSetItems.Items.AddObject(StdItem.Name, TObject(StdItem));
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;

  CheckBox1Click(CheckBox1);
end;

procedure TfrmViewList.ButtonItemNameRefClick(Sender: TObject);
begin
  RefItemCustomNameList();
end;

end.

