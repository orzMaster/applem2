object FrmOnLineHum: TFrmOnLineHum
  Left = 301
  Top = 287
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Global Session'
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
    Caption = 'Online People'
    TabOrder = 0
    object ListViewOnLine: TListView
      Left = 8
      Top = 16
      Width = 601
      Height = 249
      Columns = <
        item
          Caption = 'No.'
        end
        item
          Caption = 'Login IP Addr'
          Width = 105
        end
        item
          Caption = 'Login Account'
          Width = 110
        end
        item
          Caption = 'Session ID'
          Width = 60
        end
        item
          Caption = 'Network Delay'
          Width = 60
        end
        item
          Caption = 'Current Status'
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
    Caption = 'Refresh(&R)'
    TabOrder = 1
    OnClick = ButtonRefClick
  end
  object ButtonKick: TButton
    Left = 88
    Top = 288
    Width = 75
    Height = 25
    Caption = 'KickOff(&T)'
    TabOrder = 2
    OnClick = ButtonKickClick
  end
  object ButtonAddTempList: TButton
    Left = 360
    Top = 288
    Width = 129
    Height = 25
    Caption = 'Add Dynamic(&A)'
    TabOrder = 3
    OnClick = ButtonAddTempListClick
  end
  object ButtonAddBlockList: TButton
    Left = 496
    Top = 288
    Width = 129
    Height = 25
    Caption = 'Add Permanent(&D)'
    TabOrder = 4
    OnClick = ButtonAddBlockListClick
  end
  object CheckBoxShowLogin: TCheckBox
    Left = 169
    Top = 292
    Width = 160
    Height = 17
    Caption = 'View Only Login Session'
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
