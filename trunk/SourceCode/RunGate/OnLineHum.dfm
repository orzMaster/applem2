object FrmOnLineHum: TFrmOnLineHum
  Left = 301
  Top = 287
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #20840#23616#20250#35805
  ClientHeight = 320
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 617
    Height = 273
    Caption = #22312#32447#20154#29289
    TabOrder = 0
    object ListViewOnLine: TListView
      Left = 8
      Top = 16
      Width = 601
      Height = 249
      Columns = <
        item
          Caption = #24207#21495
        end
        item
          Caption = #30331#38470'IP'#22320#22336
          Width = 105
        end
        item
          Caption = #30331#24405#24080#21495
          Width = 110
        end
        item
          Caption = #20250#35805#26631#35782
          Width = 60
        end
        item
          Caption = #32593#32476#24310#26102
          Width = 60
        end
        item
          Caption = #24403#21069#29366#24577
          Width = 190
        end>
      GridLines = True
      Items.ItemData = {
        01B10000000100000000000000FFFFFFFFFFFFFFFF0500000000000000013100
        0F3200320032002E003200320032002E003200320032002E0032003200320010
        3100320033003400350036003700380039003000310032003300340035003600
        0764007300660061007300640066000364007300660012F25D7B76555F5B0039
        003600300030005D005B00004E8C4E094EDB56944E6D51034E5D00FFFFFFFFFF
        FFFFFFFFFF}
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListViewOnLineClick
    end
  end
  object ButtonRef: TButton
    Left = 8
    Top = 288
    Width = 75
    Height = 25
    Caption = #21047#26032'(&R)'
    TabOrder = 1
    OnClick = ButtonRefClick
  end
  object ButtonKick: TButton
    Left = 88
    Top = 288
    Width = 75
    Height = 25
    Caption = #36386#19979#32447'(&T)'
    TabOrder = 2
    OnClick = ButtonKickClick
  end
  object ButtonAddTempList: TButton
    Left = 360
    Top = 288
    Width = 129
    Height = 25
    Caption = #21152#20837#21160#24577#36807#28388#21015#34920'(&A)'
    TabOrder = 3
    OnClick = ButtonAddTempListClick
  end
  object ButtonAddBlockList: TButton
    Left = 496
    Top = 288
    Width = 129
    Height = 25
    Caption = #21152#20837#27704#20037#36807#28388#21015#34920'(&D)'
    TabOrder = 4
    OnClick = ButtonAddBlockListClick
  end
  object CheckBoxShowLogin: TCheckBox
    Left = 169
    Top = 292
    Width = 113
    Height = 17
    Caption = #21482#26597#30475#24050#30331#24405#20250#35805
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object Timer1: TTimer
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 40
    Top = 256
  end
end
