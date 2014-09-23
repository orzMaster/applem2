object FormAlpha: TFormAlpha
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #26032#26684#24335#36716#25442#24037#20855
  ClientHeight = 75
  ClientWidth = 389
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object DropFileGroupBox1: TDropFileGroupBox
    Left = 8
    Top = 8
    Width = 373
    Height = 57
    Caption = #23558#25991#20214#25176#25918#33267#35813#22788
    TabOrder = 0
    OnDropFile = DropFileGroupBox1DropFile
    Active = True
    AutoActive = True
    object ProgressBar1: TProgressBar
      Left = 16
      Top = 24
      Width = 345
      Height = 17
      TabOrder = 0
    end
  end
end
