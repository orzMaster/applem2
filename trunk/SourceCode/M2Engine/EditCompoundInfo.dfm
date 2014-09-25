object EditCompoundInfoForm: TEditCompoundInfoForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'EditCompoundInfoForm'
  ClientHeight = 97
  ClientWidth = 282
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
    Left = 8
    Top = 8
    Width = 102
    Height = 12
    Caption = 'Prop Random Rnge:'
  end
  object Label2: TLabel
    Left = 192
    Top = 11
    Width = 6
    Height = 12
    Caption = '-'
  end
  object Label3: TLabel
    Left = 8
    Top = 37
    Width = 42
    Height = 12
    Caption = 'Chance:'
  end
  object eLowValue: TEdit
    Left = 116
    Top = 8
    Width = 70
    Height = 20
    TabOrder = 0
    Text = 'eLowValue'
  end
  object eHighValue: TEdit
    Left = 203
    Top = 8
    Width = 70
    Height = 20
    TabOrder = 1
    Text = 'eHighValue'
  end
  object eRate: TEdit
    Left = 116
    Top = 34
    Width = 121
    Height = 20
    TabOrder = 2
    Text = 'eRate'
  end
  object BtnOK: TButton
    Left = 51
    Top = 60
    Width = 75
    Height = 25
    Caption = 'Okay(&O)'
    ModalResult = 1
    TabOrder = 3
    OnClick = BtnOKClick
  end
  object BtnCancel: TButton
    Left = 162
    Top = 60
    Width = 75
    Height = 25
    Caption = 'Cancel(&C)'
    ModalResult = 2
    TabOrder = 4
  end
end
