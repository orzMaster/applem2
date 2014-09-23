unit ViewCompoundInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, SDK, Spin;

type
  TFrmViewCompoundInfo = class(TForm)
    GroupBox1: TGroupBox;
    lvCompoundInfo: TListView;
    StatusBar: TStatusBar;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    seColor1: TSpinEdit;
    Label2: TLabel;
    seColor2: TSpinEdit;
    Label3: TLabel;
    seColor3: TSpinEdit;
    Label4: TLabel;
    seColor4: TSpinEdit;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    eGoldFee1: TEdit;
    Label6: TLabel;
    eGoldFee2: TEdit;
    Label7: TLabel;
    eGoldFee3: TEdit;
    Label8: TLabel;
    eGoldFee4: TEdit;
    GroupBox4: TGroupBox;
    Label9: TLabel;
    eGameGoldFee1: TEdit;
    Label10: TLabel;
    eGameGoldFee2: TEdit;
    Label11: TLabel;
    eGameGoldFee3: TEdit;
    Label12: TLabel;
    eGameGoldFee4: TEdit;
    GroupBox5: TGroupBox;
    Label13: TLabel;
    seDropRate1: TSpinEdit;
    Label14: TLabel;
    seDropRate2: TSpinEdit;
    Label15: TLabel;
    seDropRate3: TSpinEdit;
    Label16: TLabel;
    seDropRate4: TSpinEdit;
    BtnSave: TButton;
    GroupBox6: TGroupBox;
    seValueLimit: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvCompoundInfoData(Sender: TObject; Item: TListItem);
    procedure lvCompoundInfoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lvCompoundInfoCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure seColorChange(Sender: TObject);
    procedure eGoldFeeChange(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure seDropRateChange(Sender: TObject);
  private
    FCompoundInfoSize: Integer;
    FArmStdItems: TGStringList;
    FChanged: Boolean;
  private
    procedure EditRecord(AItemIndex, ASubItem: Integer);
    procedure SetRecordValue(ASubItem, AValue: Integer); overload;
    procedure SetRecordValue(ASubItem, ALowValue, AHighValue, ARate: Integer); overload;
    procedure ModValue(const AChanged: Boolean);
  public
    procedure Open;
  end;

var
  FrmViewCompoundInfo: TFrmViewCompoundInfo;

implementation

uses
  CommCtrl, Grobal2, M2Share, EditCompoundInfo;

{$R *.dfm}

procedure TFrmViewCompoundInfo.FormCreate(Sender: TObject);
begin
  FCompoundInfoSize := High(TCompoundInfos) - Low(TCompoundInfos) + 1;
  FArmStdItems := TGStringList.Create;
end;

procedure TFrmViewCompoundInfo.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FArmStdItems);
end;

procedure TFrmViewCompoundInfo.lvCompoundInfoCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
  nIndex, nLevel: Integer;
begin
  if not (cdsHot in State) then
    exit;
  with Item do
  begin
    nIndex := Index div FCompoundInfoSize;
    nLevel := Index mod FCompoundInfoSize + 1;
    if (nIndex >= 0) and (nIndex < FArmStdItems.Count) then
    begin
      case nLevel of
        1:
          Sender.Canvas.Brush.Color := GetRGB(g_Config.vCompoundSet.Color[1]);
        2:
          Sender.Canvas.Brush.Color := GetRGB(g_Config.vCompoundSet.Color[2]);
        3:
          Sender.Canvas.Brush.Color := GetRGB(g_Config.vCompoundSet.Color[3]);
        4:
          Sender.Canvas.Brush.Color := GetRGB(g_Config.vCompoundSet.Color[4]);
      end;
    end;
  end;
end;

procedure TFrmViewCompoundInfo.lvCompoundInfoData(Sender: TObject;
  Item: TListItem);
var
  i, nIndex, nLevel: Integer;
  sItemName: string;
  pCompoundInfos: pTCompoundInfos;
begin
  with Item do
  begin
    nIndex := Index div FCompoundInfoSize;
    nLevel := Index mod FCompoundInfoSize + 1;
    if (nIndex >= 0) and (nIndex < FArmStdItems.Count) then
    begin
      sItemName := FArmStdItems.Strings[nIndex];
      pCompoundInfos := pTCompoundInfos(FArmStdItems.Objects[nIndex]);
      Caption := Format('%s[%d]', [sItemName, nLevel]);
      SubItems.Clear;
      if Assigned(pCompoundInfos) then
      begin
        SubItems.Add(format('%d', [pCompoundInfos[nLevel].Value]));
        SubItems.Add(format('%d', [pCompoundInfos[nLevel].Rate[High(pCompoundInfos[nLevel].Rate)]]));
        for i := Low(pCompoundInfos[nLevel].Value1) to High(pCompoundInfos[nLevel].Value1) do
          SubItems.Add(format('%d-%d(%d%%)', [LoWord(pCompoundInfos[nLevel].Value1[i]), HiWord(pCompoundInfos[nLevel].Value1[i]), pCompoundInfos[nLevel].Rate[i]]));
        for i := Low(pCompoundInfos[nLevel].Value2) to High(pCompoundInfos[nLevel].Value2) do
          SubItems.Add(format('%d-%d(%d%%)', [LoByte(pCompoundInfos[nLevel].Value2[i]), HiByte(pCompoundInfos[nLevel].Value2[i]), pCompoundInfos[nLevel].Rate[i + Length(pCompoundInfos[nLevel].Value1)]]));
      end
      else
        for i := 0 to lvCompoundInfo.Columns.Count - 2 do
          SubItems.Add('-');  
    end;
  end;
end;

procedure TFrmViewCompoundInfo.SetRecordValue(ASubItem, AValue: Integer);
var
  i, nIndex, nLevel: Integer;
  pCompoundInfos: pTCompoundInfos;
begin
  i := -1;
  while True do
  begin
    i := ListView_GetNextItem(lvCompoundInfo.Handle, i, LVNI_SELECTED);
    if (i = -1) then
      Break;
    nIndex := i div FCompoundInfoSize;
    nLevel := i mod FCompoundInfoSize + 1;
    if (nIndex < 0) or (nIndex >= FArmStdItems.Count) then
      Continue;
    pCompoundInfos := pTCompoundInfos(FArmStdItems.Objects[nIndex]);
    if not Assigned(pCompoundInfos) then
    begin
      New(pCompoundInfos);
      ZeroMemory(pCompoundInfos, SizeOf(TCompoundInfos));
      g_CompoundInfoList.AddObject(FArmStdItems.Strings[nIndex], TObject(pCompoundInfos));
      FArmStdItems.Objects[nIndex] := TObject(pCompoundInfos);
    end;
    case ASubItem of
      1:
        pCompoundInfos[nLevel].Value := AValue;
      2:
        pCompoundInfos[nLevel].Rate[13] := AValue;  
    end;
  end;
end;

procedure TFrmViewCompoundInfo.SetRecordValue(ASubItem, ALowValue, AHighValue, ARate: Integer);
var
  i, nIndex, nLevel: Integer;
  pCompoundInfos: pTCompoundInfos;
begin
  i := -1;
  while True do
  begin
    i := ListView_GetNextItem(lvCompoundInfo.Handle, i, LVNI_SELECTED);
    if (i = -1) then
      Break;
    nIndex := i div FCompoundInfoSize;
    nLevel := i mod FCompoundInfoSize + 1;
    if (nIndex < 0) or (nIndex >= FArmStdItems.Count) then
      Continue;
    pCompoundInfos := pTCompoundInfos(FArmStdItems.Objects[nIndex]);
    if not Assigned(pCompoundInfos) then
    begin
      New(pCompoundInfos);
      ZeroMemory(pCompoundInfos, SizeOf(TCompoundInfos));
      g_CompoundInfoList.AddObject(FArmStdItems.Strings[nIndex], TObject(pCompoundInfos));
      FArmStdItems.Objects[nIndex] := TObject(pCompoundInfos);
    end;
    case ASubItem of
      3 .. 9:
        begin
          pCompoundInfos[nLevel].Value1[ASubItem - 3] := MakeLong(ALowValue, AHighValue);
          pCompoundInfos[nLevel].Rate[ASubItem - 3] := ARate;
        end;
      10 .. 15:
        begin
          pCompoundInfos[nLevel].Value2[ASubItem - 10] := MakeWord(ALowValue, AHighValue);
          pCompoundInfos[nLevel].Rate[ASubItem - 3] := ARate;
        end;
    end;
  end;
end;

procedure TFrmViewCompoundInfo.EditRecord(AItemIndex, ASubItem: Integer);
var
  nIndex, nLevel, nValue: Integer;
  sItemName, sCaption, sValue: string;
  pCompoundInfos: pTCompoundInfos;
  boChanged: Boolean;
begin
  boChanged := False;
  if lvCompoundInfo.Selected = nil then
    exit;
  nIndex := AItemIndex div FCompoundInfoSize;
  nLevel := AItemIndex mod FCompoundInfoSize + 1;
  sCaption := lvCompoundInfo.Columns.Items[ASubItem].Caption;
  pCompoundInfos := pTCompoundInfos(FArmStdItems.Objects[nIndex]);
  sItemName := FArmStdItems.Strings[nIndex];
  sItemName := Format('%s[%d]', [sItemName, nLevel]);
  if lvCompoundInfo.SelCount > 1 then
    sItemName := sItemName + '等';
  if ASubItem in [1 .. 2] then
  begin
    case ASubItem of
      1:
        if Assigned(pCompoundInfos) then
          sValue := IntToStr(pCompoundInfos[nLevel].Value)
        else
          sValue := '0';
      2:
        if Assigned(pCompoundInfos) then
          sValue := IntToStr(pCompoundInfos[nLevel].Rate[13])
        else
          sValue := '0';
    end;
    if not InputQuery(Format('%s的%s', [sItemName, sCaption]), format('输入%s:', [sCaption]), sValue) then
      exit;
    if not TryStrToInt(sValue, nValue) then
      exit;
    SetRecordValue(ASubItem, nValue);
    boChanged := True;
  end
  else if ASubItem in [3 .. 15] then
  begin
    EditCompoundInfoForm.Caption := Format('%s的%s', [sItemName, sCaption]);
    EditCompoundInfoForm.LowValue := 0;
    EditCompoundInfoForm.HighValue := 0;
    EditCompoundInfoForm.Rate := 0;
    if ASubItem in [3 .. 9] then
    begin
      if Assigned(pCompoundInfos) then
      begin
        EditCompoundInfoForm.LowValue := LoWord(pCompoundInfos[nLevel].Value1[ASubItem - 3]);
        EditCompoundInfoForm.HighValue := HiWord(pCompoundInfos[nLevel].Value1[ASubItem - 3]);
        EditCompoundInfoForm.Rate := pCompoundInfos[nLevel].Rate[ASubItem - 3];
      end;
    end;
    if ASubItem in [10 .. 15] then
    begin
      if Assigned(pCompoundInfos) then
      begin
        EditCompoundInfoForm.LowValue := LoByte(pCompoundInfos[nLevel].Value2[ASubItem - 10]);
        EditCompoundInfoForm.HighValue := HiByte(pCompoundInfos[nLevel].Value2[ASubItem - 10]);
        EditCompoundInfoForm.Rate := pCompoundInfos[nLevel].Rate[ASubItem - 3];
      end;
    end;
    if EditCompoundInfoForm.ShowModal <> mrOK then
      exit;
    SetRecordValue(ASubItem, EditCompoundInfoForm.LowValue, EditCompoundInfoForm.HighValue, EditCompoundInfoForm.Rate);
    boChanged := True;
  end;
  if boChanged then
  begin
    lvCompoundInfo.Refresh;
    ModValue(True);
  end;
end;

procedure TFrmViewCompoundInfo.lvCompoundInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  HitInfo: TLVHitTestInfo;
begin
  if (ssDouble in Shift) or (ssRight in Shift) then
  begin
    FillChar(HitInfo, SizeOf(TLVHitTestInfo), #0);
    HitInfo.pt := Point(X, Y);
    ListView_SubItemHitTest(TListView(Sender).Handle, @HitInfo);
    if (HitInfo.iItem >= 0) and (HitInfo.iItem < lvCompoundInfo.Items.Count) then
      EditRecord(HitInfo.iItem, HitInfo.iSubItem);
    {if (HitInfo.iItem >= 0) and (HitInfo.iItem < Length(FList)) then
      EditRecord(HitInfo.iItem, HitInfo.iSubItem)
    else if ssCtrl in Shift then
      NewRecord;}
  end;
end;

procedure TFrmViewCompoundInfo.Open;
var
  i: Integer;
  StdItem: pTStdItem;
begin
  FArmStdItems.Lock;
  try
    FArmStdItems.Clear;
    for i := 0 to UserEngine.StdItemList.Count - 1 do begin
      StdItem := UserEngine.StdItemList.Items[i];
      if sm_Arming in Stditem.StdModeEx then
        FArmStdItems.AddObject(StdItem.Name, TObject(GetCompoundInfos(StdItem.Name)));
    end;
  finally
    FArmStdItems.UnLock;
  end;
  lvCompoundInfo.Items.Count := FArmStdItems.Count * FCompoundInfoSize;

  seColor1.Value := g_Config.vCompoundSet.Color[1];
  seColor2.Value := g_Config.vCompoundSet.Color[2];
  seColor3.Value := g_Config.vCompoundSet.Color[3];
  seColor4.Value := g_Config.vCompoundSet.Color[4];

  eGoldFee1.Text := IntToStr(g_Config.vCompoundSet.Gold[1]);
  eGoldFee2.Text := IntToStr(g_Config.vCompoundSet.Gold[2]);
  eGoldFee3.Text := IntToStr(g_Config.vCompoundSet.Gold[3]);
  eGoldFee4.Text := IntToStr(g_Config.vCompoundSet.Gold[4]);

  eGameGoldFee1.Text := IntToStr(g_Config.vCompoundSet.GameGold[1]);
  eGameGoldFee2.Text := IntToStr(g_Config.vCompoundSet.GameGold[2]);
  eGameGoldFee3.Text := IntToStr(g_Config.vCompoundSet.GameGold[3]);
  eGameGoldFee4.Text := IntToStr(g_Config.vCompoundSet.GameGold[4]);

  seDropRate1.Value := g_Config.vCompoundSet.DropRate[1];
  seDropRate2.Value := g_Config.vCompoundSet.DropRate[2];
  seDropRate3.Value := g_Config.vCompoundSet.DropRate[3];
  seDropRate4.Value := g_Config.vCompoundSet.DropRate[4];

  seValueLimit.Value := g_Config.vCompoundSet.ValueLimit;

  seColorChange(nil);
  ModValue(False);
  ShowModal;
end;

procedure TFrmViewCompoundInfo.seColorChange(Sender: TObject);
begin
  if not Assigned(Sender) then
  begin
    seColor1.Color := GetRGB(seColor1.Value);
    seColor2.Color := GetRGB(seColor2.Value);
    seColor3.Color := GetRGB(seColor3.Value);
    seColor4.Color := GetRGB(seColor4.Value);
  end
  else with Sender as TSpinEdit do
    Color := GetRGB(Value);

  ModValue(True);
end;

procedure TFrmViewCompoundInfo.seDropRateChange(Sender: TObject);
begin
  ModValue(True);
end;

procedure TFrmViewCompoundInfo.eGoldFeeChange(Sender: TObject);
begin
  with Sender as TEdit do
    Text := IntToStr(StrToIntDef(Text, 0));

  ModValue(True);
end;

procedure TFrmViewCompoundInfo.BtnSaveClick(Sender: TObject);
var
  i: Integer;
begin
  g_Config.vCompoundSet.Color[1] := seColor1.Value;
  g_Config.vCompoundSet.Color[2] := seColor2.Value;
  g_Config.vCompoundSet.Color[3] := seColor3.Value;
  g_Config.vCompoundSet.Color[4] := seColor4.Value;

  g_Config.vCompoundSet.Gold[1] := StrToIntDef(eGoldFee1.Text, 0);
  g_Config.vCompoundSet.Gold[2] := StrToIntDef(eGoldFee2.Text, 0);
  g_Config.vCompoundSet.Gold[3] := StrToIntDef(eGoldFee3.Text, 0);
  g_Config.vCompoundSet.Gold[4] := StrToIntDef(eGoldFee4.Text, 0);

  g_Config.vCompoundSet.GameGold[1] := StrToIntDef(eGameGoldFee1.Text, 0);
  g_Config.vCompoundSet.GameGold[2] := StrToIntDef(eGameGoldFee2.Text, 0);
  g_Config.vCompoundSet.GameGold[3] := StrToIntDef(eGameGoldFee3.Text, 0);
  g_Config.vCompoundSet.GameGold[4] := StrToIntDef(eGameGoldFee4.Text, 0);

  g_Config.vCompoundSet.DropRate[1] := StrToIntDef(seDropRate1.Text, 0);
  g_Config.vCompoundSet.DropRate[2] := StrToIntDef(seDropRate2.Text, 0);
  g_Config.vCompoundSet.DropRate[3] := StrToIntDef(seDropRate3.Text, 0);
  g_Config.vCompoundSet.DropRate[4] := StrToIntDef(seDropRate4.Text, 0);

  g_Config.vCompoundSet.ValueLimit := seValueLimit.Value;

  Config.WriteInteger('CompoundSet', 'ValueLimit', g_Config.vCompoundSet.ValueLimit);

  for i := Low(g_Config.vCompoundSet.Color) to High(g_Config.vCompoundSet.Color) do
    Config.WriteInteger('CompoundSet', 'Color' + IntToStr(i), g_Config.vCompoundSet.Color[i]);

  for i := Low(g_Config.vCompoundSet.Gold) to High(g_Config.vCompoundSet.Gold) do
    Config.WriteInteger('CompoundSet', 'Gold' + IntToStr(i), g_Config.vCompoundSet.Gold[i]);

  for i := Low(g_Config.vCompoundSet.GameGold) to High(g_Config.vCompoundSet.GameGold) do
    Config.WriteInteger('CompoundSet', 'GameGold' + IntToStr(i), g_Config.vCompoundSet.GameGold[i]);

  for i := Low(g_Config.vCompoundSet.DropRate) to High(g_Config.vCompoundSet.DropRate) do
    Config.WriteInteger('CompoundSet', 'DropRate' + IntToStr(i), g_Config.vCompoundSet.DropRate[i]);

  SaveCompoundInfos();

  ModValue(False);
end;

procedure TFrmViewCompoundInfo.ModValue(const AChanged: Boolean);
begin
  FChanged := AChanged;
  BtnSave.Enabled := FChanged;
end;

end.
