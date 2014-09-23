object frmViewSession: TfrmViewSession
  Left = 606
  Top = 529
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #26597#30475#20840#23616#20250#35805
  ClientHeight = 175
  ClientWidth = 451
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object ButtonRefGrid: TButton
    Left = 367
    Top = 143
    Width = 73
    Height = 25
    Caption = #21047#26032'(&R)'
    TabOrder = 0
    OnClick = ButtonRefGridClick
  end
  object PanelStatus: TPanel
    Left = 8
    Top = 8
    Width = 433
    Height = 129
    TabOrder = 1
    object GridSession: TStringGrid
      Left = 1
      Top = 1
      Width = 431
      Height = 127
      Align = alClient
      BevelInner = bvNone
      BevelKind = bkFlat
      BevelOuter = bvNone
      ColCount = 6
      DefaultRowHeight = 18
      FixedCols = 0
      RowCount = 6
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
      ColWidths = (
        34
        121
        86
        44
        57
        61)
    end
  end
end
