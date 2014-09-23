object frmOnlineEmail: TfrmOnlineEmail
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #32676#21457#37038#20214
  ClientHeight = 455
  ClientWidth = 309
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 136
    Width = 289
    Height = 273
    Caption = #21457#36865#20449#24687
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 54
      Height = 12
      Caption = #37038#20214#26631#39064':'
    end
    object Label2: TLabel
      Left = 16
      Top = 56
      Width = 54
      Height = 12
      Caption = #37038#20214#27491#25991':'
    end
    object EditTitle: TEdit
      Left = 76
      Top = 21
      Width = 197
      Height = 20
      MaxLength = 20
      TabOrder = 0
      Text = 'EditTitle'
    end
    object MemoText: TMemo
      Left = 76
      Top = 56
      Width = 197
      Height = 201
      Lines.Strings = (
        'MemoText')
      MaxLength = 999
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 289
    Height = 122
    Caption = #21457#36865#23545#20687
    TabOrder = 1
    object RButtonT: TRadioButton
      Left = 16
      Top = 24
      Width = 105
      Height = 17
      Caption = #21457#36865#32473#25351#23450#29609#23478
      TabOrder = 0
      OnClick = RButtonTClick
    end
    object RButtonAll: TRadioButton
      Left = 16
      Top = 47
      Width = 105
      Height = 17
      Caption = #21457#36865#32473#25152#26377#29609#23478
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = RButtonTClick
    end
    object MemoName: TMemo
      Left = 138
      Top = 24
      Width = 137
      Height = 89
      Enabled = False
      Lines.Strings = (
        'MemoName')
      ScrollBars = ssVertical
      TabOrder = 2
    end
  end
  object Button1: TButton
    Left = 54
    Top = 422
    Width = 75
    Height = 25
    Caption = #21457#36865'(&E)'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 182
    Top = 422
    Width = 75
    Height = 25
    Caption = #20851#38381'(&E)'
    TabOrder = 3
    OnClick = Button2Click
  end
end
