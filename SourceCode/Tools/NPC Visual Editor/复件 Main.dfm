object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'NPC'#21487#35270#32534#36753#22120
  ClientHeight = 643
  ClientWidth = 563
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 563
    Height = 393
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object DxDraw: TDXDraw
      Left = 0
      Top = 0
      Width = 563
      Height = 393
      AutoInitialize = True
      AutoSize = True
      Color = clBlack
      Display.FixedBitCount = False
      Display.FixedRatio = True
      Display.FixedSize = True
      Options = [doAllowReboot, doWaitVBlank, doSystemMemory, doCenter, doDirectX7Mode, doHardware, doSelectDriver]
      SurfaceHeight = 393
      SurfaceWidth = 563
      OnInitialize = DxDrawInitialize
      Align = alClient
      TabOrder = 0
      Traces = <>
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 393
    Width = 563
    Height = 250
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 1
    object Label1: TLabel
      Left = 449
      Top = 157
      Width = 48
      Height = 12
      Caption = 'X'#20559#31227#37327':'
    end
    object Label2: TLabel
      Left = 449
      Top = 189
      Width = 48
      Height = 12
      Caption = 'Y'#20559#31227#37327':'
    end
    object Label4: TLabel
      Left = 8
      Top = 9
      Width = 546
      Height = 16
      Alignment = taCenter
      AutoSize = False
    end
    object Label3: TLabel
      Left = 8
      Top = 16
      Width = 546
      Height = 19
      Alignment = taCenter
      AutoSize = False
      Caption = #25991#23383#39068#33394#27979#35797' ABCDEFG abcdefg 1234567890'
    end
    object Button1: TButton
      Left = 471
      Top = 213
      Width = 75
      Height = 25
      Caption = #21047#26032'(&R)'
      TabOrder = 0
    end
    object EditY: TSpinEdit
      Left = 503
      Top = 154
      Width = 50
      Height = 21
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
    object EditX: TSpinEdit
      Left = 503
      Top = 186
      Width = 50
      Height = 21
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
    object Memo1: TMemo
      Left = 8
      Top = 88
      Width = 434
      Height = 150
      Lines.Strings = (
        'Memo1')
      TabOrder = 3
      OnChange = Memo1Change
    end
    object RadioGroup1: TRadioGroup
      Left = 448
      Top = 83
      Width = 105
      Height = 65
      Caption = #32972#26223#26694#36873#39033
      Items.Strings = (
        #39564#35777#25552#31034#26694
        #40664#35748'NPC'#26694)
      TabOrder = 4
      OnClick = RadioGroup1Click
    end
    object ScrollBar2: TScrollBar
      Left = 8
      Top = 60
      Width = 546
      Height = 17
      Max = 255
      PageSize = 0
      Position = 255
      TabOrder = 5
      OnChange = ScrollBar2Change
    end
    object ScrollBar1: TScrollBar
      Left = 8
      Top = 37
      Width = 546
      Height = 17
      Max = 255
      PageSize = 0
      TabOrder = 6
      OnChange = ScrollBar1Change
    end
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 80
    Top = 176
  end
end
