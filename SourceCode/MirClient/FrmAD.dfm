object FormAD: TFormAD
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'FormAD'
  ClientHeight = 250
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clYellow
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 434
    Height = 19
    Align = alTop
    BevelOuter = bvNone
    Color = clBlack
    ParentBackground = False
    TabOrder = 0
    object ButtonClose: TSpeedButton
      Left = 392
      Top = 0
      Width = 42
      Height = 19
      Align = alRight
      Caption = #20851#38381
      Flat = True
      OnClick = ButtonCloseClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 19
    Width = 434
    Height = 231
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 1
    object wb2: TWebBrowserWithUI
      Left = 0
      Top = 0
      Width = 434
      Height = 231
      TabOrder = 1
      OnBeforeNavigate2 = wb2BeforeNavigate2
      UISettings.EnableScrollBars = False
      UISettings.EnableFlatScrollBars = True
      UISettings.EnableContextMenu = False
      UISettings.Enable3DBorder = False
      ControlData = {
        4C000000DB2C0000E01700000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
    object wb: TWebBrowserWithUI
      Left = 0
      Top = 0
      Width = 434
      Height = 231
      Align = alClient
      TabOrder = 0
      OnDownloadBegin = wbDownloadBegin
      OnNewWindow2 = wbNewWindow2
      OnNavigateComplete2 = wbNavigateComplete2
      OnDocumentComplete = wbDocumentComplete
      UISettings.EnableScrollBars = False
      UISettings.EnableFlatScrollBars = True
      UISettings.EnableContextMenu = False
      UISettings.Enable3DBorder = False
      ExplicitTop = 6
      ExplicitWidth = 297
      ControlData = {
        4C000000DB2C0000E01700000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
end
