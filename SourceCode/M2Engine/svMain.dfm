object FrmMain: TFrmMain
  Left = 549
  Top = 307
  ClientHeight = 319
  ClientWidth = 435
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object RzSplitter: TRzSplitter
    Left = 0
    Top = 235
    Width = 435
    Height = 84
    Orientation = orVertical
    Position = 55
    Percent = 66
    SplitterWidth = 2
    Align = alClient
    BorderShadow = clBtnFace
    Color = 16744448
    TabOrder = 0
    BarSize = (
      0
      55
      435
      57)
    UpperLeftControls = ()
    LowerRightControls = (
      RzSplitter1)
    object RzSplitter1: TRzSplitter
      Left = 0
      Top = 0
      Width = 435
      Height = 27
      Orientation = orVertical
      Position = 0
      Percent = 0
      SplitterWidth = 0
      Align = alClient
      TabOrder = 0
      BarSize = (
        0
        0
        435
        0)
      UpperLeftControls = ()
      LowerRightControls = ()
    end
  end
  object MemoLog: TMemo
    Left = 0
    Top = 0
    Width = 435
    Height = 176
    Align = alTop
    BevelInner = bvNone
    Color = clBlack
    Ctl3D = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clYellow
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
    OnChange = MemoLogChange
    OnDblClick = MemoLogDblClick
    OnKeyPress = MemoLogKeyPress
  end
  object GridGate: TStringGrid
    Left = 0
    Top = 235
    Width = 435
    Height = 84
    Align = alClient
    ColCount = 7
    Ctl3D = True
    DefaultRowHeight = 15
    FixedCols = 0
    RowCount = 8
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    ParentCtl3D = False
    TabOrder = 2
    ColWidths = (
      28
      110
      56
      54
      52
      50
      56)
  end
  object Panel1: TPanel
    Left = 0
    Top = 176
    Width = 435
    Height = 59
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object LbUserCount: TLabel
      Left = 361
      Top = 3
      Width = 66
      Height = 12
      Alignment = taRightJustify
      BiDiMode = bdLeftToRight
      Caption = 'LbUserCount'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentBiDiMode = False
      ParentFont = False
      Transparent = False
    end
    object LbRunTime: TLabel
      Left = 373
      Top = 16
      Width = 54
      Height = 12
      Alignment = taRightJustify
      Caption = 'LbRunTime'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label20: TLabel
      Left = 6
      Top = 29
      Width = 42
      Height = 12
      Caption = 'Label20'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 6
      Top = 16
      Width = 36
      Height = 12
      Caption = 'Label2'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 6
      Top = 3
      Width = 36
      Height = 12
      Caption = 'Label1'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object LabelMon: TLabel
      Left = 6
      Top = 43
      Width = 48
      Height = 12
      Caption = 'LabelMon'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object LabelVersion: TLabel
      Left = 355
      Top = 43
      Width = 72
      Height = 12
      Alignment = taRightJustify
      Caption = 'LabelVersion'
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    Left = 60
    Top = 12
  end
  object RunTimer: TTimer
    Enabled = False
    Interval = 1
    Left = 96
    Top = 12
  end
  object DBSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 6000
    OnConnect = DBSocketConnect
    OnDisconnect = DBSocketDisconnect
    OnRead = DBSocketRead
    OnError = DBSocketError
    Left = 24
    Top = 48
  end
  object ConnectTimer: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = ConnectTimerTimer
    Left = 60
    Top = 48
  end
  object StartTimer: TTimer
    Enabled = False
    Interval = 100
    Left = 132
    Top = 12
  end
  object SaveVariableTimer: TTimer
    Enabled = False
    Interval = 10000
    Left = 167
    Top = 12
  end
  object CloseTimer: TTimer
    Enabled = False
    Interval = 100
    Left = 96
    Top = 48
  end
  object MainMenu: TMainMenu
    Left = 167
    Top = 48
    object MENU_CONTROL: TMenuItem
      Caption = 'Control'
      OnClick = MENU_CONTROLClick
      object MENU_CONTROL_CLEARLOGMSG: TMenuItem
        Caption = 'Clear Log(&C)'
        OnClick = MENU_CONTROL_CLEARLOGMSGClick
      end
      object MENU_CONTROL_RELOAD: TMenuItem
        Caption = 'Reload(&R)'
        object MENU_CONTROL_RELOAD_ITEMDB: TMenuItem
          Caption = 'Item Database(&I)'
          OnClick = MENU_CONTROL_RELOAD_ITEMDBClick
        end
        object MENU_CONTROL_RELOAD_MAGICDB: TMenuItem
          Caption = 'Magic Database(&S)'
          OnClick = MENU_CONTROL_RELOAD_MAGICDBClick
        end
        object MENU_CONTROL_RELOAD_MONSTERDB: TMenuItem
          Caption = 'Monster Database(&M)'
          OnClick = MENU_CONTROL_RELOAD_MONSTERDBClick
        end
        object MENU_CONTROL_RELOAD_MONSTERSAY: TMenuItem
          Caption = 'Monster Talk Settings(&M)'
          OnClick = MENU_CONTROL_RELOAD_MONSTERSAYClick
        end
        object MENU_CONTROL_RELOAD_DISABLEMAKE: TMenuItem
          Caption = 'Data List(&D)'
          OnClick = MENU_CONTROL_RELOAD_DISABLEMAKEClick
        end
        object MENU_CONTROL_RELOAD_CONF: TMenuItem
          Caption = 'Parameter Settings(&C)'
          OnClick = MENU_CONTROL_RELOAD_CONFClick
        end
        object QFunctionNPC: TMenuItem
          Caption = 'Function Script(&Q)'
          OnClick = QFunctionNPCClick
        end
        object QManageNPC: TMenuItem
          Caption = 'Login Script(&L)'
          OnClick = QManageNPCClick
        end
        object P1: TMenuItem
          Caption = 'Map Event Script(&P)'
          object E1: TMenuItem
            Caption = 'Reload Map Event Configuration(&E)'
            OnClick = E1Click
          end
          object S1: TMenuItem
            Caption = 'Map Event Script Reload(&S)'
            OnClick = S1Click
          end
        end
        object RobotManageNPC: TMenuItem
          Caption = 'Robot Script(&R)'
          OnClick = RobotManageNPCClick
        end
        object MonItems: TMenuItem
          Caption = 'Monster Burst Rate(&M)'
          OnClick = MonItemsClick
        end
        object M1: TMenuItem
          Caption = 'Create a List(&K)'
          OnClick = M1Click
        end
        object N2: TMenuItem
          Caption = 'Script Constant List(&A)'
          OnClick = N2Click
        end
        object B1: TMenuItem
          Caption = 'Chest Configuration(&B)'
          OnClick = B1Click
        end
        object V1: TMenuItem
          Caption = 'Configuration Task Tips(&V)'
          OnClick = V1Click
        end
        object L1: TMenuItem
          Caption = 'Life Skills Build a List(&L)'
          OnClick = L1Click
        end
        object NPC1: TMenuItem
          Caption = 'All NPC Configuration'
          OnClick = NPC1Click
        end
        object F1: TMenuItem
          Caption = 'Filter the List(&F)'
          OnClick = F1Click
        end
      end
      object MENU_CONTROL_GATE: TMenuItem
        Caption = 'Game Gateway'
        object MENU_CONTROL_GATE_OPEN: TMenuItem
          Caption = 'Open(&O)'
          OnClick = MENU_CONTROL_GATE_OPENClick
        end
        object MENU_CONTROL_GATE_CLOSE: TMenuItem
          Caption = 'Close(&C)'
          OnClick = MENU_CONTROL_GATE_CLOSEClick
        end
      end
      object MENU_CONTROL_TESTSERVER: TMenuItem
        Caption = 'Test Server(&T)'
        Visible = False
        OnClick = MENU_CONTROL_TESTSERVERClick
      end
      object MENU_CONTROL_EXIT: TMenuItem
        Caption = 'Exit(&X)'
        OnClick = MENU_CONTROL_EXITClick
      end
    end
    object MENU_VIEW: TMenuItem
      Caption = 'View'
      object MENU_VIEW_ONLINEHUMAN: TMenuItem
        Caption = 'Online People(&O)'
        OnClick = MENU_VIEW_ONLINEHUMANClick
      end
      object MENU_VIEW_SESSION: TMenuItem
        Caption = 'Global Session(&S)'
        OnClick = MENU_VIEW_SESSIONClick
      end
      object MENU_VIEW_LEVEL: TMenuItem
        Caption = 'Level Properties(&L)'
        OnClick = MENU_VIEW_LEVELClick
      end
      object MENU_VIEW_LIST: TMenuItem
        Caption = 'List Information(&L)'
        OnClick = MENU_VIEW_LISTClick
      end
      object MENU_VIEW_COM: TMenuItem
        Caption = 'Equipment Synthesis(&C)'
        OnClick = MENU_VIEW_COMClick
      end
      object MENU_VIEW_KERNELINFO: TMenuItem
        Caption = 'Kernal Data(&K)'
        OnClick = MENU_VIEW_KERNELINFOClick
      end
    end
    object MENU_OPTION: TMenuItem
      Caption = 'Options'
      object MENU_OPTION_GENERAL: TMenuItem
        Caption = 'Basic Settings(&G)'
        OnClick = MENU_OPTION_GENERALClick
      end
      object MENU_OPTION_GAME: TMenuItem
        Caption = 'Parameter Settings(&O)'
        OnClick = MENU_OPTION_GAMEClick
      end
      object MENU_OPTION_ITEMFUNC: TMenuItem
        Caption = 'Equipment Items(&I)'
        OnClick = MENU_OPTION_ITEMFUNCClick
      end
      object MENU_OPTION_FUNCTION: TMenuItem
        Caption = 'Feature Set(&F)'
        OnClick = MENU_OPTION_FUNCTIONClick
      end
      object G1: TMenuItem
        Caption = 'Game Command(&C)'
        OnClick = G1Click
      end
      object MENU_OPTION_MONSTER: TMenuItem
        Caption = 'Monster Set(&M)'
        OnClick = MENU_OPTION_MONSTERClick
      end
      object MENU_OPTION_SERVERCONFIG: TMenuItem
        Caption = 'Server Configuration(&P)'
        OnClick = MENU_OPTION_SERVERCONFIGClick
      end
    end
    object MENU_MANAGE: TMenuItem
      Caption = 'Management '
      object MENU_MANAGE_ONLINEMSG: TMenuItem
        Caption = 'Send Message(&M)'
        OnClick = MENU_MANAGE_ONLINEMSGClick
      end
      object MENU_MANAGE_ONLINEEMAIL: TMenuItem
        Caption = 'Send E-MAIL(&E)'
        OnClick = MENU_MANAGE_ONLINEEMAILClick
      end
      object MENU_MANAGE_PLUG: TMenuItem
        Caption = 'Function Plugin(&P)'
        Visible = False
        OnClick = MENU_MANAGE_PLUGClick
      end
      object MENU_MANAGE_CASTLE: TMenuItem
        Caption = 'Castle Management(&C)'
        OnClick = MENU_MANAGE_CASTLEClick
      end
      object MENU_MANAGE_SHOP: TMenuItem
        Caption = 'Store Management(&S)'
        OnClick = MENU_MANAGE_SHOPClick
      end
    end
    object MENU_TOOLS: TMenuItem
      Caption = 'Tools'
      object MENU_TOOLS_MERCHANT: TMenuItem
        Caption = 'Trading NPC Configuration(&M)'
        OnClick = MENU_TOOLS_MERCHANTClick
      end
      object MENU_TOOLS_NPC: TMenuItem
        Caption = 'NPC Configuration Management(&N)'
        OnClick = MENU_TOOLS_NPCClick
      end
      object MENU_TOOLS_MONGEN: TMenuItem
        Caption = 'MonGen Configuration(&G)'
        OnClick = MENU_TOOLS_MONGENClick
      end
      object MENU_TOOLS_IPSEARCH: TMenuItem
        Caption = 'IP Search(&S)'
        OnClick = MENU_TOOLS_IPSEARCHClick
      end
      object MENU_TOOLS_TEST: TMenuItem
        Caption = 'Test'
        Visible = False
        OnClick = MENU_TOOLS_TESTClick
      end
      object MENU_TOOLS_OFFLINE: TMenuItem
        Caption = 'Offline Management(&O)'
        object MENU_TOOLS_OFFLINE_SAVENAME: TMenuItem
          Caption = 'Save Current Offline List(&S)'
          OnClick = MENU_TOOLS_OFFLINE_SAVENAMEClick
        end
        object MENU_TOOLS_OFFLINE_LOADNAME: TMenuItem
          Caption = 'Automatic Cut off from the List(&A)'
          OnClick = MENU_TOOLS_OFFLINE_LOADNAMEClick
        end
      end
    end
    object MENU_HELP: TMenuItem
      Caption = 'Help'
      object MENU_HELP_ABOUT: TMenuItem
        Caption = 'About(&A)'
        OnClick = MENU_HELP_ABOUTClick
      end
    end
  end
  object IdUDPClientLog: TIdUDPClient
    BufferSize = 81920
    Port = 0
    Left = 132
    Top = 48
  end
  object OpenDialog: TOpenDialog
    Left = 24
    Top = 12
  end
  object GateSocket: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnClientConnect = GateSocketClientConnect
    OnClientDisconnect = GateSocketClientDisconnect
    OnClientRead = GateSocketClientRead
    OnClientError = GateSocketClientError
    Left = 24
    Top = 80
  end
  object enmsg: TRSA
    CommonalityKey = '421166909'
    CommonalityMode = '78676586259407574469749356447'
    PrivateKey = '71362022359665638368808298557'
    Left = 56
    Top = 80
  end
end
