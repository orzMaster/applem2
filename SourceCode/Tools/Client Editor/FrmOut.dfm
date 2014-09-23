object FormOut: TFormOut
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Exporting Data'
  ClientHeight = 209
  ClientWidth = 300
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 62
    Width = 153
    Height = 79
    Caption = 'Code'
    TabOrder = 0
    object Label2: TLabel
      Left = 8
      Top = 22
      Width = 25
      Height = 13
      Caption = 'Start:'
    end
    object Label3: TLabel
      Left = 8
      Top = 48
      Width = 22
      Height = 13
      Caption = 'End:'
    end
    object edtIndexStart: TSpinEdit
      Left = 68
      Top = 18
      Width = 69
      Height = 21
      MaxValue = 10000000
      MinValue = 0
      TabOrder = 0
      Value = 9
    end
    object edtIndexEnd: TSpinEdit
      Left = 68
      Top = 45
      Width = 69
      Height = 21
      MaxValue = 10000000
      MinValue = 0
      TabOrder = 1
      Value = 9
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 284
    Height = 48
    Caption = 'Setup'
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 21
      Width = 34
      Height = 13
      Caption = 'Saved:'
    end
    object edtSaveDir: TEdit
      Left = 68
      Top = 17
      Width = 143
      Height = 21
      TabOrder = 0
    end
    object Button1: TButton
      Left = 217
      Top = 16
      Width = 29
      Height = 21
      Caption = '...'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object GroupBox3: TGroupBox
    Left = 167
    Top = 62
    Width = 125
    Height = 79
    Caption = 'Options'
    TabOrder = 2
    object Out_Alpha: TCheckBox
      Left = 8
      Top = 16
      Width = 87
      Height = 17
      Caption = 'Export Alpha'
      TabOrder = 0
    end
    object Out_Offset: TCheckBox
      Left = 8
      Top = 35
      Width = 114
      Height = 17
      Caption = 'Export Coordinates'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = Out_OffsetClick
    end
    object Out_Format: TCheckBox
      Left = 20
      Top = 53
      Width = 93
      Height = 17
      Caption = 'Export Format'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object btnGo: TButton
    Left = 54
    Top = 155
    Width = 75
    Height = 25
    Caption = 'Execute'
    TabOrder = 3
    OnClick = btnGoClick
  end
  object btnExit: TButton
    Left = 159
    Top = 155
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Exit'
    Default = True
    ModalResult = 2
    TabOrder = 4
  end
  object ProgressBar: TProgressBar
    Left = 0
    Top = 197
    Width = 300
    Height = 12
    Align = alBottom
    TabOrder = 5
    ExplicitWidth = 275
  end
end
