object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Ranking Plugin'
  ClientHeight = 398
  ClientWidth = 796
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object LabelHint: TLabel
    Left = 8
    Top = 360
    Width = 226
    Height = 12
    AutoSize = False
    Caption = #31561#24453#25163#21160#21047#26032'...'
  end
  object TabControl: TTabControl
    Left = 240
    Top = 13
    Width = 548
    Height = 372
    MultiLine = True
    Style = tsButtons
    TabOrder = 0
    Tabs.Strings = (
      'Top Service'
      'Warrior Ranking'
      'Wizard Ranking'
      'Taoist Ranking'
      'Ares Ranking'
      'Top Wizard'
      'Top Taoist'
      'Top Regal'
      'Top Teacher'
      'Top Member'
      'Guard Ranking'
      'Top Robbers'
      'Reputation Ranking'
      'Wicked Ranking')
    TabIndex = 0
    OnChange = TabControlChange
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 200
    Width = 226
    Height = 97
    Caption = 'Timing Set'
    TabOrder = 1
    object Label59: TLabel
      Left = 112
      Top = 47
      Width = 12
      Height = 13
      Caption = #28857
    end
    object Label61: TLabel
      Left = 193
      Top = 47
      Width = 12
      Height = 13
      Caption = #20998
    end
    object Label60: TLabel
      Left = 112
      Top = 71
      Width = 24
      Height = 13
      Caption = #23567#26102
    end
    object Label62: TLabel
      Left = 193
      Top = 71
      Width = 12
      Height = 13
      Caption = #20998
    end
    object Radio1: TRadioButton
      Left = 11
      Top = 46
      Width = 49
      Height = 17
      Caption = 'Day'
      Checked = True
      Enabled = False
      TabOrder = 0
      TabStop = True
      OnClick = Radio1Click
    end
    object EditHour1: TSpinEdit
      Left = 67
      Top = 43
      Width = 42
      Height = 21
      EditorEnabled = False
      Enabled = False
      MaxValue = 23
      MinValue = 0
      TabOrder = 1
      Value = 6
      OnChange = EditMinLevelChange
    end
    object EditMinute1: TSpinEdit
      Left = 147
      Top = 43
      Width = 42
      Height = 21
      EditorEnabled = False
      Enabled = False
      MaxValue = 59
      MinValue = 0
      TabOrder = 2
      Value = 0
      OnChange = EditMinLevelChange
    end
    object Radio2: TRadioButton
      Left = 11
      Top = 67
      Width = 49
      Height = 17
      Caption = 'Intervals '
      Enabled = False
      TabOrder = 3
      OnClick = Radio1Click
    end
    object EditHour2: TSpinEdit
      Left = 67
      Top = 66
      Width = 42
      Height = 21
      EditorEnabled = False
      Enabled = False
      MaxValue = 100
      MinValue = 0
      TabOrder = 4
      Value = 1
      OnChange = EditMinLevelChange
    end
    object EditMinute2: TSpinEdit
      Left = 147
      Top = 66
      Width = 42
      Height = 21
      EditorEnabled = False
      Enabled = False
      MaxValue = 59
      MinValue = 0
      TabOrder = 5
      Value = 0
      OnChange = EditMinLevelChange
    end
    object CheckBoxAuto: TCheckBox
      Left = 11
      Top = 20
      Width = 105
      Height = 17
      Caption = 'Calculation Chart'
      TabOrder = 6
      OnClick = Radio1Click
    end
    object Button3: TButton
      Left = 147
      Top = 16
      Width = 62
      Height = 21
      Caption = 'Refresh'
      TabOrder = 7
      OnClick = Button3Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 226
    Height = 186
    Caption = 'Filter Settings'
    TabOrder = 2
    object Label1: TLabel
      Left = 11
      Top = 20
      Width = 37
      Height = 13
      Caption = 'Level  '#8805
    end
    object Label2: TLabel
      Left = 137
      Top = 20
      Width = 5
      Height = 13
      Caption = #8804
    end
    object Label4: TLabel
      Left = 11
      Top = 43
      Width = 28
      Height = 13
      Caption = 'Name'
    end
    object EditMaxLevel: TSpinEdit
      Left = 155
      Top = 16
      Width = 66
      Height = 21
      MaxLength = 5
      MaxValue = 65535
      MinValue = 0
      TabOrder = 0
      Value = 65535
      OnChange = EditMinLevelChange
    end
    object EditMinLevel: TSpinEdit
      Left = 65
      Top = 16
      Width = 66
      Height = 21
      MaxLength = 5
      MaxValue = 65535
      MinValue = 0
      TabOrder = 1
      Value = 65535
      OnChange = EditMinLevelChange
    end
    object ListBoxNames: TListBox
      Left = 65
      Top = 43
      Width = 108
      Height = 134
      ItemHeight = 13
      TabOrder = 2
    end
    object Button1: TButton
      Left = 179
      Top = 43
      Width = 41
      Height = 21
      Caption = 'Add'
      TabOrder = 3
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 179
      Top = 70
      Width = 41
      Height = 21
      Caption = 'Delete'
      TabOrder = 4
      OnClick = Button2Click
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 303
    Width = 226
    Height = 50
    Caption = 'Basic Settings'
    TabOrder = 3
    object Label3: TLabel
      Left = 11
      Top = 20
      Width = 48
      Height = 13
      Caption = #32479#35745#25968#37327
    end
    object Label5: TLabel
      Left = 119
      Top = 13
      Width = 84
      Height = 12
      Caption = 'M2Server: '#26410#30693
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 119
      Top = 28
      Width = 84
      Height = 12
      Caption = 'DBServer: '#26410#30693
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object EditMaxCount: TSpinEdit
      Left = 65
      Top = 16
      Width = 48
      Height = 21
      EditorEnabled = False
      Increment = 10
      MaxValue = 2000
      MinValue = 20
      TabOrder = 0
      Value = 100
      OnChange = EditMinLevelChange
    end
  end
  object PBar: TProgressBar
    Left = 8
    Top = 378
    Width = 226
    Height = 12
    TabOrder = 4
  end
  object TopGrid: TStringGrid
    Left = 240
    Top = 88
    Width = 548
    Height = 302
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 50
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 5
    ColWidths = (
      74
      107
      94
      131
      113)
  end
  object Timer1: TTimer
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 16
    Top = 64
  end
end
