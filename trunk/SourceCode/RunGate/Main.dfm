object FrmMain: TFrmMain
  Left = 445
  Top = 167
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'FrmMain'
  ClientHeight = 138
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesigned
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 115
    Top = 154
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object MemoLog: TMemo
    Left = 0
    Top = 115
    Width = 289
    Height = 4
    Align = alClient
    Color = clBlack
    Font.Charset = ANSI_CHARSET
    Font.Color = clYellow
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssHorizontal
    TabOrder = 0
    OnChange = MemoLogChange
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 119
    Width = 289
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = '????'
        Width = 45
      end
      item
        Alignment = taCenter
        Text = 'Not connected'
        Width = 90
      end
      item
        Alignment = taCenter
        Text = '0/0/0'
        Width = 90
      end
      item
        Alignment = taCenter
        Text = '????'
        Width = -1
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 289
    Height = 115
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    object GroupBox1: TGroupBox
      Left = 0
      Top = 0
      Width = 289
      Height = 66
      Align = alTop
      Caption = 'Network Traffic'
      TabOrder = 0
      object LabelReviceMsgSize: TLabel
        Left = 12
        Top = 15
        Width = 52
        Height = 13
        Caption = 'Receive: 0'
      end
      object LabelSendBlockSize: TLabel
        Left = 12
        Top = 31
        Width = 37
        Height = 13
        Caption = 'Send: 0'
      end
      object LabelBufferOfM2Size: TLabel
        Left = 115
        Top = 48
        Width = 91
        Height = 13
        Caption = 'Server Receives: 0'
      end
      object LabelSelfCheck: TLabel
        Left = 12
        Top = 48
        Width = 54
        Height = 13
        Caption = 'Self Test: 0'
      end
      object LabelPlayMsgSize: TLabel
        Left = 115
        Top = 32
        Width = 35
        Height = 13
        Caption = 'Data: 0'
      end
      object LabelLogonMsgSize: TLabel
        Left = 115
        Top = 16
        Width = 38
        Height = 13
        Caption = 'Login: 0'
      end
      object LabelProcessMsgSize: TLabel
        Left = 203
        Top = 32
        Width = 45
        Height = 13
        Caption = 'Coding: 0'
      end
      object LabelDeCodeMsgSize: TLabel
        Left = 203
        Top = 16
        Width = 58
        Height = 13
        Caption = 'Decoding: 0'
      end
    end
    object GroupBox2: TGroupBox
      Left = 0
      Top = 66
      Width = 289
      Height = 49
      Align = alClient
      Caption = 'Processing Time'
      TabOrder = 1
      object LabelReceTime: TLabel
        Left = 12
        Top = 15
        Width = 52
        Height = 13
        Caption = 'Receive: 0'
      end
      object LabelSendTime: TLabel
        Left = 12
        Top = 31
        Width = 37
        Height = 13
        Caption = 'Send: 0'
      end
      object LabelSendLimitTime: TLabel
        Left = 100
        Top = 31
        Width = 186
        Height = 13
        Caption = 'Transmission Processing Restrictions: 0'
      end
      object LabelReviceLimitTime: TLabel
        Left = 100
        Top = 15
        Width = 188
        Height = 13
        Caption = 'Receiving and Processing Limitations: 0'
      end
      object Label14: TLabel
        Left = 300
        Top = 15
        Width = 77
        Height = 13
        Caption = 'Data processing'
      end
      object LabelLoopTime: TLabel
        Left = 282
        Top = 31
        Width = 42
        Height = 12
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
      end
    end
  end
  object ServerSocket: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnListen = ServerSocketListen
    OnClientConnect = ServerSocketClientConnect
    OnClientDisconnect = ServerSocketClientDisconnect
    OnClientRead = ServerSocketClientRead
    OnClientError = ServerSocketClientError
    Left = 171
    Top = 222
  end
  object SendTimer: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = SendTimerTimer
    Left = 233
    Top = 222
  end
  object ClientSocket: TClientSocket
    Active = False
    Address = '127.0.0.1'
    ClientType = ctNonBlocking
    Port = 5000
    OnConnect = ClientSocketConnect
    OnDisconnect = ClientSocketDisconnect
    OnRead = ClientSocketRead
    OnError = ClientSocketError
    Left = 109
    Top = 222
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 279
    Top = 222
  end
  object DecodeTimer: TTimer
    Interval = 1
    OnTimer = DecodeTimerTimer
    Left = 347
    Top = 222
  end
  object MainMenu: TMainMenu
    Left = 383
    Top = 222
    object MENU_CONTROL: TMenuItem
      Caption = 'Control'
      object MENU_CONTROL_START: TMenuItem
        Caption = 'Start(&S)'
        Visible = False
        OnClick = MENU_CONTROL_STARTClick
      end
      object MENU_CONTROL_STOP: TMenuItem
        Caption = 'Stop(&T)'
        Visible = False
        OnClick = MENU_CONTROL_STOPClick
      end
      object MENU_CONTROL_RECONNECT: TMenuItem
        Caption = 'Reconnect(&R)'
        Visible = False
        OnClick = MENU_CONTROL_RECONNECTClick
      end
      object MENU_CONTROL_RELOADCONFIG: TMenuItem
        Caption = 'Reload Config(&R)'
        OnClick = MENU_CONTROL_RELOADCONFIGClick
      end
      object MENU_CONTROL_CLEAELOG: TMenuItem
        Caption = 'Clear(&C)'
        OnClick = MENU_CONTROL_CLEAELOGClick
      end
      object N1: TMenuItem
        Caption = 'Do Not Connect(&F)'
        OnClick = N1Click
      end
      object MENU_CONTROL_EXIT: TMenuItem
        Caption = 'Exit(&E)'
        OnClick = MENU_CONTROL_EXITClick
      end
    end
    object V1: TMenuItem
      Caption = 'View'
      object I2: TMenuItem
        Caption = 'Details(&I)'
        OnClick = I2Click
      end
      object G1: TMenuItem
        Caption = 'Global Session(&G)'
        OnClick = G1Click
      end
    end
    object MENU_OPTION: TMenuItem
      Caption = 'Options'
      object MENU_OPTION_GENERAL: TMenuItem
        Caption = 'General(&G)'
        OnClick = MENU_OPTION_GENERALClick
      end
      object MENU_OPTION_PERFORM: TMenuItem
        Caption = 'Performance Settings(&P)'
        OnClick = MENU_OPTION_PERFORMClick
      end
      object MENU_OPTION_IPFILTER: TMenuItem
        Caption = 'IP Filter(&S)'
        OnClick = MENU_OPTION_IPFILTERClick
      end
    end
    object H1: TMenuItem
      Caption = 'Help'
      object I1: TMenuItem
        Caption = 'About(&I)'
        OnClick = I1Click
      end
    end
  end
  object StartTimer: TTimer
    Interval = 200
    OnTimer = StartTimerTimer
    Left = 317
    Top = 222
  end
  object CenterSocket: TClientSocket
    Active = False
    Address = '127.0.0.1'
    ClientType = ctNonBlocking
    Port = 5600
    OnConnect = CenterSocketConnect
    OnDisconnect = CenterSocketDisconnect
    OnRead = CenterSocketRead
    OnError = CenterSocketError
    Left = 61
    Top = 214
  end
end
