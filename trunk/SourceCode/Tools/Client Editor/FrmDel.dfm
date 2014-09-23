object FormDel: TFormDel
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Delete Data'
  ClientHeight = 128
  ClientWidth = 333
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
    Top = 8
    Width = 145
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
    Left = 159
    Top = 8
    Width = 166
    Height = 79
    Caption = 'Options'
    TabOrder = 1
    object rbQuiteDel: TRadioButton
      Left = 8
      Top = 21
      Width = 121
      Height = 17
      Caption = 'Completely remove'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 8
      Top = 47
      Width = 155
      Height = 17
      Caption = 'Replace With Empty Data'
      TabOrder = 1
    end
  end
  object btnGo: TButton
    Left = 62
    Top = 93
    Width = 75
    Height = 25
    Caption = 'Execute'
    TabOrder = 2
    OnClick = btnGoClick
  end
  object btnExit: TButton
    Left = 167
    Top = 93
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Exit'
    Default = True
    ModalResult = 2
    TabOrder = 3
  end
end
