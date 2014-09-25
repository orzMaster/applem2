object FrmAttackSabukWall: TFrmAttackSabukWall
  Left = 513
  Top = 235
  BorderStyle = bsDialog
  Caption = 'Attack Sabuk Wall'
  ClientHeight = 360
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 8
    Top = 308
    Width = 36
    Height = 12
    Caption = 'Guild:'
  end
  object Label2: TLabel
    Left = 8
    Top = 332
    Width = 54
    Height = 12
    Caption = 'War Time:'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 281
    Height = 289
    Caption = 'Guild List'
    TabOrder = 0
    object ListBoxGuild: TListBox
      Left = 8
      Top = 16
      Width = 265
      Height = 265
      ItemHeight = 12
      TabOrder = 0
      OnClick = ListBoxGuildClick
    end
  end
  object EditGuildName: TEdit
    Left = 64
    Top = 304
    Width = 137
    Height = 20
    TabOrder = 1
    Text = 'EditGuildName'
  end
  object RzDateTimeEditAttackDate: TRzDateTimeEdit
    Left = 64
    Top = 328
    Width = 137
    Height = 20
    CaptionTodayBtn = #20170#22825#26085#26399
    CaptionClearBtn = #28165#38500#26085#26399
    EditType = etDate
    TabOrder = 2
  end
  object ButtonOK: TButton
    Left = 208
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Okay(&O)'
    TabOrder = 3
    OnClick = ButtonOKClick
  end
  object CheckBoxAll: TCheckBox
    Left = 216
    Top = 304
    Width = 73
    Height = 17
    Caption = 'All Guild'
    TabOrder = 4
    OnClick = CheckBoxAllClick
  end
end
