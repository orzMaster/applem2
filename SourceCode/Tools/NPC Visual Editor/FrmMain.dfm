object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Visual Editor'
  ClientHeight = 616
  ClientWidth = 1156
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 804
    Height = 616
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 0
      Top = 0
      Width = 804
      Height = 616
      Align = alClient
      TabOrder = 0
      object PanelBG: TPanel
        Left = 2
        Top = 14
        Width = 800
        Height = 600
        Align = alClient
        Caption = 'PanelBG'
        TabOrder = 0
        OnMouseDown = PanelBGMouseDown
        OnMouseMove = PanelBGMouseMove
        OnMouseUp = PanelBGMouseUp
      end
    end
  end
  object Panel2: TPanel
    Left = 804
    Top = 0
    Width = 352
    Height = 616
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object GroupBox2: TGroupBox
      Left = 0
      Top = 0
      Width = 352
      Height = 616
      Align = alClient
      TabOrder = 0
      object MemoText: TMemo
        Left = 2
        Top = 15
        Width = 348
        Height = 399
        Align = alClient
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'Test Content')
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        OnChange = MemoTextChange
        OnKeyDown = MemoTextKeyDown
        ExplicitTop = 14
        ExplicitHeight = 400
      end
      object Panel4: TPanel
        Left = 2
        Top = 414
        Width = 348
        Height = 200
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object Label1: TLabel
          Left = 8
          Top = 8
          Width = 46
          Height = 13
          Caption = 'Image ID:'
        end
        object Label2: TLabel
          Left = 8
          Top = 38
          Width = 31
          Height = 13
          Caption = 'Width:'
        end
        object Label3: TLabel
          Left = 8
          Top = 68
          Width = 34
          Height = 13
          Caption = 'Height:'
        end
        object eImageID: TSpinEdit
          Left = 60
          Top = 3
          Width = 50
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 0
          Value = 1933
          OnChange = eImageIDChange
        end
        object ckSndaMode: TCheckBox
          Left = 8
          Top = 180
          Width = 97
          Height = 17
          Caption = 'Sdo Mode'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = ckSndaModeClick
        end
        object eImageWidth: TSpinEdit
          Left = 60
          Top = 33
          Width = 50
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 2
          Value = 356
          OnChange = eImageIDChange
        end
        object eImageHeight: TSpinEdit
          Left = 60
          Top = 63
          Width = 50
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 3
          Value = 149
          OnChange = eImageIDChange
        end
      end
    end
  end
  object Device: TDX9Device
    Width = 300
    Height = 344
    BitDepth = bdLow
    Refresh = 0
    Windowed = True
    VSync = False
    HardwareTL = True
    LockBackBuffer = True
    DepthBuffer = True
    WindowHandle = 0
    OnInitialize = DeviceInitialize
    OnFinalize = DeviceFinalize
    OnRender = DeviceRender
    OnNotifyEvent = DeviceNotifyEvent
    AutoInitialize = False
    Left = 24
    Top = 40
  end
  object TimerDraw: TTimer
    Enabled = False
    Interval = 10
    OnTimer = TimerDrawTimer
    Left = 56
    Top = 40
  end
end
