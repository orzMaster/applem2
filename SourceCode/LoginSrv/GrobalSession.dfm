object frmGrobalSession: TfrmGrobalSession
  Left = 290
  Top = 332
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #26597#30475#20840#23616#20250#35805
  ClientHeight = 208
  ClientWidth = 458
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object ButtonRefGrid: TButton
    Left = 377
    Top = 175
    Width = 73
    Height = 25
    Caption = #21047#26032'(&R)'
    TabOrder = 0
  end
  object PanelStatus: TPanel
    Left = 4
    Top = 8
    Width = 445
    Height = 161
    TabOrder = 1
    object GridSession: TStringGrid
      Left = 1
      Top = 1
      Width = 443
      Height = 159
      Align = alClient
      ColCount = 6
      DefaultRowHeight = 18
      FixedCols = 0
      RowCount = 9
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
      ExplicitWidth = 483
      ColWidths = (
        34
        132
        86
        56
        44
        58)
    end
  end
end
