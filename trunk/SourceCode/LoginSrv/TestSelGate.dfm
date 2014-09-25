object frmTestSelGate: TfrmTestSelGate
  Left = 466
  Top = 183
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Test Selection Gateway'
  ClientHeight = 133
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
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
    Top = 26
    Width = 265
    Height = 99
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 84
      Height = 12
      Caption = 'Login Gateway:'
    end
    object Label2: TLabel
      Left = 8
      Top = 44
      Width = 78
      Height = 12
      Caption = 'Game Gateway:'
    end
    object EditSelGate: TEdit
      Left = 98
      Top = 16
      Width = 159
      Height = 20
      TabOrder = 0
      Text = '127.0.0.1'
    end
    object EditGameGate: TEdit
      Left = 92
      Top = 40
      Width = 165
      Height = 20
      TabOrder = 1
    end
    object ButtonTest: TButton
      Left = 105
      Top = 66
      Width = 73
      Height = 26
      Caption = 'Test(&T)'
      TabOrder = 2
      OnClick = ButtonTestClick
    end
    object Button1: TButton
      Left = 184
      Top = 66
      Width = 73
      Height = 26
      Caption = 'Config(&C)'
      Default = True
      TabOrder = 3
      OnClick = Button1Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 5
    Width = 265
    Height = 28
    TabOrder = 1
    object Label3: TLabel
      Left = 8
      Top = 10
      Width = 6
      Height = 12
      Caption = ':'
    end
  end
end
