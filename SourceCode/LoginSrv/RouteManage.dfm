object frmRouteManage: TfrmRouteManage
  Left = 276
  Top = 285
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Gateway Routing Configuration'
  ClientHeight = 223
  ClientWidth = 481
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 465
    Height = 209
    Caption = 'Gateway Routing Table'
    TabOrder = 0
    object ListViewRoute: TListView
      Left = 8
      Top = 16
      Width = 449
      Height = 153
      Columns = <
        item
          Caption = 'No.'
          Width = 40
        end
        item
          Caption = 'Login Gateway'
          Width = 80
        end
        item
          Caption = 'No of Gateways'
          Width = 60
        end
        item
          Caption = 'Game Gateway'
          Width = 1000
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ButtonDeleteClick
    end
    object ButtonEdit: TButton
      Left = 88
      Top = 176
      Width = 73
      Height = 25
      Hint = 'Modify the selected Gateway Routing'
      Caption = 'Edit(&E)'
      TabOrder = 1
      OnClick = ButtonDeleteClick
    end
    object ButtonDelete: TButton
      Left = 168
      Top = 176
      Width = 73
      Height = 25
      Hint = 'Delete the selected Gateway Routing'
      Caption = 'Delete(&D)'
      TabOrder = 2
      OnClick = ButtonDeleteClick
    end
    object ButtonOK: TButton
      Left = 384
      Top = 176
      Width = 73
      Height = 25
      Hint = 'Save gateway routing settings Exit'
      Caption = 'Okay(&O)'
      TabOrder = 3
      OnClick = ButtonDeleteClick
    end
    object ButtonAddRoute: TButton
      Left = 8
      Top = 176
      Width = 73
      Height = 25
      Hint = 'Modify the selected Gateway Routing'
      Caption = 'Add(&A)'
      TabOrder = 4
      OnClick = ButtonDeleteClick
    end
  end
end
