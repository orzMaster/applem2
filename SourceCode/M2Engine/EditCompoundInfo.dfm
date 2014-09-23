object EditCompoundInfoForm: TEditCompoundInfoForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'EditCompoundInfoForm'
  ClientHeight = 154
  ClientWidth = 318
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 6
    Top = 45
    Width = 102
    Height = 12
    Caption = #38468#21152#23646#24615#38543#26426#33539#22260':'
  end
  object Label2: TLabel
    Left = 183
    Top = 45
    Width = 6
    Height = 12
    Caption = '-'
  end
  object Label3: TLabel
    Left = 78
    Top = 88
    Width = 30
    Height = 12
    Caption = #20960#29575':'
  end
  object eLowValue: TEdit
    Left = 108
    Top = 42
    Width = 70
    Height = 20
    TabOrder = 0
    Text = 'eLowValue'
  end
  object eHighValue: TEdit
    Left = 195
    Top = 42
    Width = 70
    Height = 20
    TabOrder = 1
    Text = 'eHighValue'
  end
  object eRate: TEdit
    Left = 108
    Top = 85
    Width = 121
    Height = 20
    TabOrder = 2
    Text = 'eRate'
  end
  object BtnOK: TButton
    Left = 64
    Top = 121
    Width = 75
    Height = 25
    Caption = #30830#23450'(&O)'
    ModalResult = 1
    TabOrder = 3
    OnClick = BtnOKClick
  end
  object BtnCancel: TButton
    Left = 168
    Top = 121
    Width = 75
    Height = 25
    Caption = #21462#28040'(&C)'
    ModalResult = 2
    TabOrder = 4
  end
end
