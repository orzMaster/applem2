object frmOnlineEmail: TfrmOnlineEmail
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Ingame E-Mail'
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
    Caption = 'Send Message'
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 36
      Height = 12
      Caption = 'Title:'
    end
    object Label2: TLabel
      Left = 16
      Top = 56
      Width = 48
      Height = 12
      Caption = 'Message:'
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
    Caption = 'Send to:'
    TabOrder = 1
    object RButtonT: TRadioButton
      Left = 3
      Top = 24
      Width = 134
      Height = 17
      Caption = 'Designated Player'
      TabOrder = 0
      OnClick = RButtonTClick
    end
    object RButtonAll: TRadioButton
      Left = 3
      Top = 47
      Width = 118
      Height = 17
      Caption = 'All Players'
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
    Caption = 'Send(&S)'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 182
    Top = 422
    Width = 75
    Height = 25
    Caption = 'Close(&E)'
    TabOrder = 3
    OnClick = Button2Click
  end
end
