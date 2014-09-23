object FrmWeb: TFrmWeb
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'FrmWeb'
  ClientHeight = 250
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object wb: TWebBrowserWithUI
    Left = 0
    Top = 0
    Width = 434
    Height = 250
    Align = alClient
    TabOrder = 0
    OnProgressChange = wbProgressChange
    OnDownloadBegin = wbDownloadBegin
    OnTitleChange = wbTitleChange
    OnNavigateComplete2 = wbNavigateComplete2
    OnDocumentComplete = wbDocumentComplete
    UISettings.EnableScrollBars = False
    UISettings.EnableFlatScrollBars = True
    UISettings.EnableContextMenu = False
    UISettings.Enable3DBorder = False
    ExplicitLeft = 72
    ExplicitTop = 16
    ExplicitWidth = 300
    ExplicitHeight = 150
    ControlData = {
      4C000000DB2C0000D71900000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 434
    Height = 250
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
  end
end
