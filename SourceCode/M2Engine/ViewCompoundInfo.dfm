object FrmViewCompoundInfo: TFrmViewCompoundInfo
  Left = 0
  Top = 0
  Caption = #35013#22791#21512#25104
  ClientHeight = 600
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 1000
    Height = 90
    Align = alTop
    Caption = #22522#26412#35774#32622
    TabOrder = 0
    object GroupBox2: TGroupBox
      Left = 8
      Top = 10
      Width = 190
      Height = 70
      Caption = #39068#33394#35774#32622
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Top = 20
        Width = 30
        Height = 12
        Caption = #19968#31561':'
      end
      object Label2: TLabel
        Left = 100
        Top = 19
        Width = 30
        Height = 12
        Caption = #20108#31561':'
      end
      object Label3: TLabel
        Left = 8
        Top = 43
        Width = 30
        Height = 12
        Caption = #19977#31561':'
      end
      object Label4: TLabel
        Left = 100
        Top = 43
        Width = 30
        Height = 12
        Caption = #22235#31561':'
      end
      object seColor1: TSpinEdit
        Left = 44
        Top = 16
        Width = 48
        Height = 21
        MaxValue = 255
        MinValue = 0
        TabOrder = 0
        Value = 0
        OnChange = seColorChange
      end
      object seColor2: TSpinEdit
        Left = 136
        Top = 16
        Width = 48
        Height = 21
        MaxValue = 255
        MinValue = 0
        TabOrder = 1
        Value = 0
        OnChange = seColorChange
      end
      object seColor3: TSpinEdit
        Left = 44
        Top = 41
        Width = 48
        Height = 21
        MaxValue = 255
        MinValue = 0
        TabOrder = 2
        Value = 0
        OnChange = seColorChange
      end
      object seColor4: TSpinEdit
        Left = 136
        Top = 41
        Width = 48
        Height = 21
        MaxValue = 255
        MinValue = 0
        TabOrder = 3
        Value = 0
        OnChange = seColorChange
      end
    end
    object GroupBox3: TGroupBox
      Left = 210
      Top = 10
      Width = 240
      Height = 70
      Caption = #36153#29992#35774#32622'('#37329#24065')'
      TabOrder = 1
      object Label5: TLabel
        Left = 8
        Top = 19
        Width = 30
        Height = 12
        Caption = #19968#31561':'
      end
      object Label6: TLabel
        Left = 128
        Top = 19
        Width = 30
        Height = 12
        Caption = #20108#31561':'
      end
      object Label7: TLabel
        Left = 8
        Top = 43
        Width = 30
        Height = 12
        Caption = #19977#31561':'
      end
      object Label8: TLabel
        Left = 128
        Top = 43
        Width = 30
        Height = 12
        Caption = #22235#31561':'
      end
      object eGoldFee1: TEdit
        Left = 44
        Top = 16
        Width = 70
        Height = 20
        TabOrder = 0
        Text = '0'
        OnChange = eGoldFeeChange
      end
      object eGoldFee2: TEdit
        Left = 163
        Top = 16
        Width = 70
        Height = 20
        TabOrder = 1
        Text = '0'
        OnChange = eGoldFeeChange
      end
      object eGoldFee3: TEdit
        Left = 44
        Top = 41
        Width = 70
        Height = 20
        TabOrder = 2
        Text = '0'
        OnChange = eGoldFeeChange
      end
      object eGoldFee4: TEdit
        Left = 164
        Top = 41
        Width = 70
        Height = 20
        TabOrder = 3
        Text = '0'
        OnChange = eGoldFeeChange
      end
    end
    object GroupBox4: TGroupBox
      Left = 462
      Top = 10
      Width = 240
      Height = 70
      Caption = #36153#29992#35774#32622'('#20803#23453')'
      TabOrder = 2
      object Label9: TLabel
        Left = 8
        Top = 19
        Width = 30
        Height = 12
        Caption = #19968#31561':'
      end
      object Label10: TLabel
        Left = 128
        Top = 19
        Width = 30
        Height = 12
        Caption = #20108#31561':'
      end
      object Label11: TLabel
        Left = 8
        Top = 43
        Width = 30
        Height = 12
        Caption = #19977#31561':'
      end
      object Label12: TLabel
        Left = 128
        Top = 43
        Width = 30
        Height = 12
        Caption = #22235#31561':'
      end
      object eGameGoldFee1: TEdit
        Left = 44
        Top = 16
        Width = 70
        Height = 20
        TabOrder = 0
        Text = '0'
        OnChange = eGoldFeeChange
      end
      object eGameGoldFee2: TEdit
        Left = 163
        Top = 16
        Width = 70
        Height = 20
        TabOrder = 1
        Text = '0'
        OnChange = eGoldFeeChange
      end
      object eGameGoldFee3: TEdit
        Left = 44
        Top = 41
        Width = 70
        Height = 20
        TabOrder = 2
        Text = '0'
        OnChange = eGoldFeeChange
      end
      object eGameGoldFee4: TEdit
        Left = 164
        Top = 41
        Width = 70
        Height = 20
        TabOrder = 3
        Text = '0'
        OnChange = eGoldFeeChange
      end
    end
    object GroupBox5: TGroupBox
      Left = 714
      Top = 10
      Width = 190
      Height = 70
      Caption = #25481#33853#20960#29575
      TabOrder = 3
      object Label13: TLabel
        Left = 8
        Top = 19
        Width = 30
        Height = 12
        Caption = #19968#31561':'
      end
      object Label14: TLabel
        Left = 100
        Top = 19
        Width = 30
        Height = 12
        Caption = #20108#31561':'
      end
      object Label15: TLabel
        Left = 8
        Top = 43
        Width = 30
        Height = 12
        Caption = #19977#31561':'
      end
      object Label16: TLabel
        Left = 98
        Top = 43
        Width = 30
        Height = 12
        Caption = #22235#31561':'
      end
      object seDropRate1: TSpinEdit
        Left = 44
        Top = 16
        Width = 48
        Height = 21
        MaxValue = 100
        MinValue = 0
        TabOrder = 0
        Value = 0
        OnChange = seDropRateChange
      end
      object seDropRate2: TSpinEdit
        Left = 136
        Top = 16
        Width = 48
        Height = 21
        MaxValue = 100
        MinValue = 0
        TabOrder = 1
        Value = 0
        OnChange = seDropRateChange
      end
      object seDropRate3: TSpinEdit
        Left = 44
        Top = 41
        Width = 48
        Height = 21
        MaxValue = 100
        MinValue = 0
        TabOrder = 2
        Value = 0
        OnChange = seDropRateChange
      end
      object seDropRate4: TSpinEdit
        Left = 136
        Top = 41
        Width = 48
        Height = 21
        MaxValue = 100
        MinValue = 0
        TabOrder = 3
        Value = 0
        OnChange = seDropRateChange
      end
    end
    object BtnSave: TButton
      Left = 915
      Top = 55
      Width = 75
      Height = 25
      Caption = #20445#23384'(&S)'
      TabOrder = 4
      OnClick = BtnSaveClick
    end
    object GroupBox6: TGroupBox
      Left = 910
      Top = 10
      Width = 80
      Height = 40
      Caption = #20801#35768#20998#31867#24046
      TabOrder = 5
      object seValueLimit: TSpinEdit
        Left = 10
        Top = 14
        Width = 60
        Height = 21
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 10
        OnChange = seDropRateChange
      end
    end
  end
  object lvCompoundInfo: TListView
    Left = 0
    Top = 90
    Width = 1000
    Height = 491
    Align = alClient
    Columns = <
      item
        AutoSize = True
        Caption = #35013#22791#21517#31216
      end
      item
        Caption = #20998#31867
        Width = 40
      end
      item
        Caption = #25104#21151#29575
      end
      item
        Caption = #38450#24481
        Width = 65
      end
      item
        Caption = #39764#27861#38450#24481
        Width = 65
      end
      item
        Caption = #25915#20987
        Width = 65
      end
      item
        Caption = #39764#27861
        Width = 65
      end
      item
        Caption = #36947#26415
        Width = 65
      end
      item
        Caption = #29983#21629#20540
        Width = 65
      end
      item
        Caption = #39764#27861#20540
        Width = 65
      end
      item
        Caption = #20934#30830
        Width = 60
      end
      item
        Caption = #25935#25463
        Width = 60
      end
      item
        Caption = #33268#21629#19968#20987
        Width = 60
      end
      item
        Caption = #20260#23475#21152#25104
        Width = 60
      end
      item
        Caption = #20260#23475#21560#25910
        Width = 60
      end
      item
        Caption = #39764#27861#36530#36991
        Width = 60
      end>
    GridLines = True
    HotTrackStyles = [htHandPoint]
    MultiSelect = True
    OwnerData = True
    RowSelect = True
    ShowWorkAreas = True
    TabOrder = 1
    ViewStyle = vsReport
    OnCustomDrawItem = lvCompoundInfoCustomDrawItem
    OnData = lvCompoundInfoData
    OnMouseDown = lvCompoundInfoMouseDown
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 581
    Width = 1000
    Height = 19
    Panels = <
      item
        Text = #20351#29992'Ctrl'#12289'Shift'#21487#20197#22810#36873#65292#28857#20987#21491#38190#21487#20197#23545#20540#36827#34892#20462#25913#65292#20462#25913#32467#26524#21363#26102#29983#25928#65292#35831#27880#24847#20445#23384#20462#25913#32467#26524#65292#20998#31867#20026'0'#30340#35774#32622#23558#19981#20250#34987#20445#23384
        Width = 50
      end>
  end
end
