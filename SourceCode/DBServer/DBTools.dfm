object frmDBTool: TfrmDBTool
  Left = 582
  Top = 223
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #25968#25454#31649#29702#24037#20855
  ClientHeight = 272
  ClientWidth = 573
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 555
    Height = 257
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #25968#25454#24211#20449#24687
      object GroupBox1: TGroupBox
        Left = 3
        Top = 3
        Width = 267
        Height = 221
        Caption = #20154#29289#20449#24687#25968#25454#24211'(Mir.DB)'
        TabOrder = 0
        object GridMirDBInfo: TStringGrid
          Left = 8
          Top = 16
          Width = 250
          Height = 194
          ColCount = 2
          DefaultRowHeight = 18
          RowCount = 10
          TabOrder = 0
          ColWidths = (
            64
            181)
        end
      end
      object GroupBox2: TGroupBox
        Left = 276
        Top = 3
        Width = 267
        Height = 221
        Caption = #20154#29289#25968#25454#24211'(Hum.DB)'
        TabOrder = 1
        object GridHumDBInfo: TStringGrid
          Left = 8
          Top = 16
          Width = 250
          Height = 194
          ColCount = 2
          DefaultRowHeight = 18
          RowCount = 10
          TabOrder = 0
          ColWidths = (
            64
            181)
        end
      end
    end
  end
  object TimerShowInfo: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerShowInfoTimer
    Left = 104
    Top = 248
  end
end
