object frmOverWrite: TfrmOverWrite
  Left = 236
  Top = 185
  BorderStyle = bsDialog
  Caption = 'Datei '#40666'erschreiben ...'
  ClientHeight = 101
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 9
    Width = 202
    Height = 13
    AutoSize = False
    Caption = 'Die folgende Datei ist bereits vorhanden:'
  end
  object lblFileName: TLabel
    Left = 8
    Top = 27
    Width = 3
    Height = 13
  end
  object Label3: TLabel
    Left = 8
    Top = 47
    Width = 175
    Height = 13
    Caption = 'Wollen Sie die Datei '#40666'erschreiben ?'
  end
  object btnYes: TButton
    Tag = 1
    Left = 6
    Top = 70
    Width = 75
    Height = 25
    Caption = 'Ja'
    ModalResult = 6
    TabOrder = 0
  end
  object btnNo: TButton
    Tag = 2
    Left = 86
    Top = 70
    Width = 75
    Height = 25
    Caption = 'Nein'
    ModalResult = 7
    TabOrder = 1
  end
  object btnAlways: TButton
    Tag = 3
    Left = 166
    Top = 70
    Width = 75
    Height = 25
    Caption = 'Immer'
    ModalResult = 10
    TabOrder = 2
  end
  object btnNever: TButton
    Tag = 4
    Left = 247
    Top = 70
    Width = 75
    Height = 25
    Caption = 'Nie'
    ModalResult = 9
    TabOrder = 3
  end
end
