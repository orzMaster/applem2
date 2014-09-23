object frmTestSelGate: TfrmTestSelGate
  Left = 466
  Top = 183
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #27979#35797#36873#25321#32593#20851
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
      Width = 54
      Height = 12
      Caption = #30331#24405#32593#20851':'
    end
    object Label2: TLabel
      Left = 8
      Top = 44
      Width = 54
      Height = 12
      Caption = #28216#25103#32593#20851':'
    end
    object EditSelGate: TEdit
      Left = 64
      Top = 16
      Width = 193
      Height = 20
      TabOrder = 0
      Text = '127.0.0.1'
    end
    object EditGameGate: TEdit
      Left = 64
      Top = 40
      Width = 193
      Height = 20
      TabOrder = 1
    end
    object ButtonTest: TButton
      Left = 105
      Top = 66
      Width = 73
      Height = 26
      Caption = #27979#35797'(&T)'
      TabOrder = 2
      OnClick = ButtonTestClick
    end
    object Button1: TButton
      Left = 184
      Top = 66
      Width = 73
      Height = 26
      Caption = #37197#32622'(&C)'
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
      Width = 78
      Height = 12
      Caption = #27979#35797#36873#25321#32593#20851':'
    end
  end
end
