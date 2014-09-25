object frmOnlineMsg: TfrmOnlineMsg
  Left = 367
  Top = 319
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Send Message'
  ClientHeight = 332
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 4
    Top = 169
    Width = 48
    Height = 12
    Caption = 'Message:'
  end
  object ComboBoxMsg: TComboBox
    Left = 63
    Top = 165
    Width = 374
    Height = 20
    Style = csSimple
    ItemHeight = 12
    TabOrder = 0
    OnChange = ComboBoxMsgChange
    OnKeyPress = ComboBoxMsgKeyPress
  end
  object MemoMsg: TMemo
    Left = 3
    Top = 4
    Width = 434
    Height = 153
    Lines.Strings = (
      'MemoMsg')
    TabOrder = 1
    OnChange = MemoMsgChange
  end
  object StringGrid: TStringGrid
    Left = 3
    Top = 219
    Width = 434
    Height = 106
    ColCount = 1
    DefaultColWidth = 430
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    ScrollBars = ssVertical
    TabOrder = 2
    OnClick = StringGridClick
    OnDblClick = StringGridDblClick
  end
  object ButtonAdd: TButton
    Left = 367
    Top = 191
    Width = 67
    Height = 23
    Caption = 'Add(&A)'
    Enabled = False
    TabOrder = 3
    OnClick = ButtonAddClick
  end
  object ButtonDelete: TButton
    Left = 293
    Top = 191
    Width = 67
    Height = 23
    Caption = 'Delete(&D)'
    Enabled = False
    TabOrder = 4
    OnClick = ButtonDeleteClick
  end
  object ButtonSend: TButton
    Left = 148
    Top = 190
    Width = 67
    Height = 23
    Caption = 'Send(&S)'
    TabOrder = 5
    OnClick = ButtonSendClick
  end
end
