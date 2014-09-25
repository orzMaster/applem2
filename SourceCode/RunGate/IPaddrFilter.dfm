object frmIPaddrFilter: TfrmIPaddrFilter
  Left = 376
  Top = 266
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Network Security Filtering'
  ClientHeight = 347
  ClientWidth = 704
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 116
    Height = 331
    Caption = 'Current Connection'
    TabOrder = 0
    object Label4: TLabel
      Left = 8
      Top = 16
      Width = 30
      Height = 12
      Caption = 'List:'
    end
    object ListBoxActiveList: TListBox
      Left = 8
      Top = 34
      Width = 99
      Height = 287
      ItemHeight = 12
      Items.Strings = (
        '888.888.888.888')
      ParentShowHint = False
      PopupMenu = ActiveListPopupMenu
      ShowHint = True
      Sorted = True
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 123
    Top = 8
    Width = 225
    Height = 331
    Caption = 'Filter List'
    TabOrder = 1
    object LabelTempList: TLabel
      Left = 8
      Top = 16
      Width = 48
      Height = 12
      Caption = 'Dynamic:'
    end
    object Label1: TLabel
      Left = 113
      Top = 16
      Width = 60
      Height = 12
      Caption = 'Permanent:'
    end
    object Label23: TLabel
      Left = 7
      Top = 187
      Width = 78
      Height = 12
      Caption = 'Filtering IP:'
    end
    object ListBoxBlockList: TListBox
      Left = 113
      Top = 34
      Width = 99
      Height = 146
      Hint = 
        'Permanent filter list, in this list of IP will not be able to es' +
        'tablish a connection, this list will be saved in the configurati' +
        'on file, restart when the program will re-load this list'
      ItemHeight = 12
      Items.Strings = (
        '888.888.888.888')
      ParentShowHint = False
      PopupMenu = BlockListPopupMenu
      ShowHint = True
      Sorted = True
      TabOrder = 0
    end
    object ListBoxTempList: TListBox
      Left = 8
      Top = 34
      Width = 99
      Height = 146
      Hint = 
        'Dynamic filter list, in this list of IP will not be able to esta' +
        'blish a connection, but when the program is restarted the inform' +
        'ation in this list will be empty'
      ItemHeight = 12
      Items.Strings = (
        '888.888.888.888')
      ParentShowHint = False
      PopupMenu = TempBlockListPopupMenu
      ShowHint = True
      Sorted = True
      TabOrder = 1
    end
    object ListBoxIpList: TListBox
      Left = 8
      Top = 204
      Width = 204
      Height = 117
      ItemHeight = 12
      Items.Strings = (
        '888.888.888.888')
      ParentShowHint = False
      PopupMenu = IPListPopupMenu
      ShowHint = True
      Sorted = True
      TabOrder = 2
    end
  end
  object GroupBox6: TGroupBox
    Left = 354
    Top = 8
    Width = 187
    Height = 331
    Caption = 'Attack Protection'
    TabOrder = 2
    object GroupBox4: TGroupBox
      Left = 10
      Top = 204
      Width = 168
      Height = 117
      Caption = 'Flow Control'
      TabOrder = 0
      object Label6: TLabel
        Left = 8
        Top = 44
        Width = 60
        Height = 12
        Caption = 'Max Limit:'
      end
      object Label8: TLabel
        Left = 8
        Top = 68
        Width = 60
        Height = 12
        Caption = 'Qaunt Res:'
      end
      object Label5: TLabel
        Left = 8
        Top = 20
        Width = 54
        Height = 12
        Caption = 'Crit Size'
      end
      object EditMaxSize: TSpinEdit
        Left = 64
        Top = 40
        Width = 65
        Height = 21
        Hint = 
          'The maximum limit data received, if more than this size, it is c' +
          'onsidered an attack.'
        Increment = 10
        MaxValue = 10000
        MinValue = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Value = 6000
        OnChange = EditMaxSizeChange
      end
      object EditMaxClientMsgCount: TSpinEdit
        Left = 64
        Top = 64
        Width = 65
        Height = 21
        Hint = 
          'A number of data received much more than the specified number wi' +
          'll be regarded as an attack.'
        MaxValue = 100
        MinValue = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Value = 5
        OnChange = EditMaxClientMsgCountChange
      end
      object CheckBoxLostLine: TCheckBox
        Left = 8
        Top = 91
        Width = 157
        Height = 17
        Hint = 
          'After opening this function, if the data sent by the client exce' +
          'eds the specified limit will be dropped directly'
        BiDiMode = bdLeftToRight
        Caption = 'Exception Hand Dropped'
        ParentBiDiMode = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = CheckBoxLostLineClick
      end
      object EditNomSize: TSpinEdit
        Left = 64
        Top = 16
        Width = 65
        Height = 21
        Hint = 
          'Critical information received data size exceeds this size, it is' +
          ' treated specially.'
        Increment = 10
        MaxValue = 1000
        MinValue = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        Value = 100
        OnChange = EditNomSizeChange
      end
    end
    object GroupBox7: TGroupBox
      Left = 10
      Top = 19
      Width = 168
      Height = 179
      Caption = 'Connection Protection'
      TabOrder = 1
      object Label7: TLabel
        Left = 57
        Top = 89
        Width = 54
        Height = 12
        Caption = 'Ms / Conn'
      end
      object Label2: TLabel
        Left = 57
        Top = 114
        Width = 54
        Height = 12
        Caption = 'Ms / Conn'
      end
      object Label9: TLabel
        Left = 7
        Top = 41
        Width = 66
        Height = 12
        Caption = 'Empty Conn:'
      end
      object Label3: TLabel
        Left = 7
        Top = 19
        Width = 66
        Height = 12
        Caption = 'Conn Limit:'
      end
      object Label10: TLabel
        Left = 119
        Top = 17
        Width = 48
        Height = 12
        Caption = 'Conn /IP'
      end
      object Label11: TLabel
        Left = 119
        Top = 41
        Width = 18
        Height = 12
        Caption = 'Sec'
      end
      object Label19: TLabel
        Left = 119
        Top = 64
        Width = 30
        Height = 12
        Caption = 'Point'
      end
      object Label20: TLabel
        Left = 7
        Top = 64
        Width = 72
        Height = 12
        Caption = 'Transfer TO:'
      end
      object Edit_CountLimit1: TSpinEdit
        Left = 126
        Top = 85
        Width = 38
        Height = 21
        Hint = 
          'Ultra-connection protection, the maximum allowable number of con' +
          'nections in the connection time specified.'
        MaxValue = 255
        MinValue = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Value = 1
        OnChange = Edit_CountLimit1Change
      end
      object Edit_CountLimit2: TSpinEdit
        Left = 126
        Top = 110
        Width = 38
        Height = 21
        Hint = 
          'Ultra-connection protection, the maximum allowable number of con' +
          'nections in the connection time specified.'
        MaxValue = 255
        MinValue = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Value = 1
        OnChange = Edit_CountLimit2Change
      end
      object Edit_LimitTime1: TSpinEdit
        Left = 7
        Top = 85
        Width = 47
        Height = 21
        Hint = 'Ultra-connection protection, connect the specified time.'
        Increment = 100
        MaxValue = 20000
        MinValue = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Value = 1
        OnChange = Edit_LimitTime1Change
      end
      object Edit_LimitTime2: TSpinEdit
        Left = 7
        Top = 110
        Width = 47
        Height = 21
        Hint = 'Ultra-connection protection, connect the specified time.'
        Increment = 100
        MaxValue = 20000
        MinValue = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        Value = 1
        OnChange = Edit_LimitTime2Change
      end
      object EditMaxConnect: TSpinEdit
        Left = 75
        Top = 14
        Width = 41
        Height = 21
        MaxValue = 1000
        MinValue = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Value = 50
        OnChange = EditMaxConnectChange
      end
      object EditClientTimeOutTime: TSpinEdit
        Left = 75
        Top = 37
        Width = 41
        Height = 21
        MaxValue = 60
        MinValue = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        Value = 5
        OnChange = EditClientTimeOutTimeChange
      end
      object EditSessionTimeOutTime: TSpinEdit
        Left = 75
        Top = 60
        Width = 41
        Height = 21
        Hint = 
          'And client communications interval, no data transmission over th' +
          'e time will be disconnected ..'
        MaxValue = 999
        MinValue = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        Value = 5
        OnChange = EditSessionTimeOutTimeChange
      end
      object CheckBoxCCProtect: TCheckBox
        Left = 7
        Top = 146
        Width = 158
        Height = 17
        Hint = 'This setting can prevent a certain amount of CC attack '
        Caption = 'Auto Det CCAtk Open Def'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = CheckBoxCCProtectClick
      end
    end
  end
  object ButtonOK: TButton
    Left = 616
    Top = 313
    Width = 79
    Height = 26
    Caption = 'Okay(&O)'
    TabOrder = 3
    OnClick = ButtonOKClick
  end
  object GroupBox5: TGroupBox
    Left = 547
    Top = 8
    Width = 148
    Height = 135
    Caption = 'Statement Settings'
    TabOrder = 4
    object Label12: TLabel
      Left = 120
      Top = 90
      Width = 18
      Height = 12
      Caption = 'Sec'
    end
    object Label13: TLabel
      Left = 120
      Top = 66
      Width = 30
      Height = 12
      Caption = 'Times'
    end
    object Label14: TLabel
      Left = 120
      Top = 42
      Width = 12
      Height = 12
      Caption = 'Ms'
    end
    object Label15: TLabel
      Left = 8
      Top = 43
      Width = 54
      Height = 12
      Caption = 'Interval:'
    end
    object Label16: TLabel
      Left = 8
      Top = 19
      Width = 66
      Height = 12
      Caption = 'Txt Length:'
    end
    object Label17: TLabel
      Left = 8
      Top = 67
      Width = 66
      Height = 12
      Caption = 'Statements:'
    end
    object Label18: TLabel
      Left = 8
      Top = 91
      Width = 54
      Height = 12
      Caption = 'Gag Time:'
    end
    object MsgMaxLenSpinEdit: TSpinEdit
      Left = 64
      Top = 14
      Width = 55
      Height = 21
      Enabled = False
      MaxLength = 2
      MaxValue = 99
      MinValue = 0
      TabOrder = 0
      Value = 0
      OnChange = MsgMaxLenSpinEditChange
    end
    object MsgTimeSpinEdit: TSpinEdit
      Left = 64
      Top = 38
      Width = 55
      Height = 21
      Enabled = False
      Increment = 1000
      MaxValue = 99999
      MinValue = 1
      TabOrder = 1
      Value = 3000
      OnChange = MsgTimeSpinEditChange
    end
    object MsgCountSpinEdit: TSpinEdit
      Left = 64
      Top = 62
      Width = 55
      Height = 21
      Enabled = False
      MaxValue = 100
      MinValue = 1
      TabOrder = 2
      Value = 1
      OnChange = MsgCountSpinEditChange
    end
    object MsgCloseTimeSpinEdit: TSpinEdit
      Left = 64
      Top = 86
      Width = 55
      Height = 21
      Enabled = False
      MaxValue = 65535
      MinValue = 1
      TabOrder = 3
      Value = 1
      OnChange = MsgCloseTimeSpinEditChange
    end
    object CheckBoxBlockSay: TCheckBox
      Left = 8
      Top = 111
      Width = 137
      Height = 19
      BiDiMode = bdLeftToRight
      Caption = 'Open Speech Ctrl'
      Enabled = False
      ParentBiDiMode = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = CheckBoxBlockSayClick
    end
  end
  object GroupBox3: TGroupBox
    Left = 547
    Top = 230
    Width = 148
    Height = 73
    Caption = 'Attack Actions'
    TabOrder = 5
    object RadioAddBlockList: TRadioButton
      Left = 16
      Top = 48
      Width = 129
      Height = 17
      Hint = 
        'Join this connection permanent IP filter list, and this forced b' +
        'reak all connected IP'
      Caption = 'Add Permanent'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = RadioAddBlockListClick
    end
    object RadioAddTempList: TRadioButton
      Left = 16
      Top = 32
      Width = 129
      Height = 17
      Hint = 
        'Join this dynamic IP connection filter list, and this forced bre' +
        'ak all connected IP'
      Caption = 'Add Dynamic'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = RadioAddTempListClick
    end
    object RadioDisConnect: TRadioButton
      Left = 16
      Top = 15
      Width = 129
      Height = 17
      Hint = 'Connect a simple disconnection processing'
      Caption = 'Disconnect'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = RadioDisConnectClick
    end
  end
  object GroupBox8: TGroupBox
    Left = 547
    Top = 149
    Width = 148
    Height = 75
    Caption = 'Variable Speed Control'
    TabOrder = 6
    object Label21: TLabel
      Left = 8
      Top = 20
      Width = 60
      Height = 12
      Caption = 'Speed Int:'
    end
    object Label22: TLabel
      Left = 8
      Top = 44
      Width = 60
      Height = 12
      Caption = 'ShiftTime:'
    end
    object EditSpeedTick: TSpinEdit
      Left = 64
      Top = 16
      Width = 65
      Height = 21
      Increment = 10
      MaxValue = 99999999
      MinValue = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Value = 5000
      OnChange = EditSpeedTickChange
    end
    object EditSpeedTime: TSpinEdit
      Left = 64
      Top = 40
      Width = 65
      Height = 21
      Increment = 10
      MaxValue = 99999999
      MinValue = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Value = 1000
      OnChange = EditSpeedTimeChange
    end
  end
  object BlockListPopupMenu: TPopupMenu
    OnPopup = BlockListPopupMenuPopup
    Left = 271
    Top = 117
    object BPOPMENU_REFLIST: TMenuItem
      Caption = #21047#26032'(&R)'
      OnClick = BPOPMENU_REFLISTClick
    end
    object BPOPMENU_SORT: TMenuItem
      Caption = #25490#24207'(&S)'
      OnClick = BPOPMENU_SORTClick
    end
    object BPOPMENU_ADD: TMenuItem
      Caption = #22686#21152'(&A)'
      OnClick = BPOPMENU_ADDClick
    end
    object BPOPMENU_ADDTEMPLIST: TMenuItem
      Caption = #21152#20837#21160#24577#36807#28388#21015#34920'(&A)'
      OnClick = BPOPMENU_ADDTEMPLISTClick
    end
    object BPOPMENU_DELETE: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = BPOPMENU_DELETEClick
    end
  end
  object TempBlockListPopupMenu: TPopupMenu
    OnPopup = TempBlockListPopupMenuPopup
    Left = 160
    Top = 118
    object TPOPMENU_REFLIST: TMenuItem
      Caption = #21047#26032'(&R)'
      OnClick = TPOPMENU_REFLISTClick
    end
    object TPOPMENU_SORT: TMenuItem
      Caption = #25490#24207'(&S)'
      OnClick = TPOPMENU_SORTClick
    end
    object TPOPMENU_ADD: TMenuItem
      Caption = #22686#21152'(&A)'
      OnClick = TPOPMENU_ADDClick
    end
    object TPOPMENU_BLOCKLIST: TMenuItem
      Caption = #21152#20837#27704#20037#36807#28388#21015#34920'(&D)'
      OnClick = TPOPMENU_BLOCKLISTClick
    end
    object TPOPMENU_DELETE: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = TPOPMENU_DELETEClick
    end
  end
  object ActiveListPopupMenu: TPopupMenu
    OnPopup = ActiveListPopupMenuPopup
    Left = 61
    Top = 204
    object APOPMENU_REFLIST: TMenuItem
      Caption = #21047#26032'(&R)'
      OnClick = APOPMENU_REFLISTClick
    end
    object APOPMENU_SORT: TMenuItem
      Caption = #25490#24207'(&S)'
      OnClick = APOPMENU_SORTClick
    end
    object APOPMENU_ADDTEMPLIST: TMenuItem
      Caption = #21152#20837#21160#24577#36807#28388#21015#34920'(&A)'
      OnClick = APOPMENU_ADDTEMPLISTClick
    end
    object APOPMENU_BLOCKLIST: TMenuItem
      Caption = #21152#20837#27704#20037#36807#28388#21015#34920'(&D)'
      OnClick = APOPMENU_BLOCKLISTClick
    end
    object APOPMENU_KICK: TMenuItem
      Caption = #36386#38500#19979#32447'(&K)'
      OnClick = APOPMENU_KICKClick
    end
  end
  object IPListPopupMenu: TPopupMenu
    OnPopup = IPListPopupMenuPopup
    Left = 215
    Top = 253
    object IPMENU_SORT: TMenuItem
      Caption = #25490#24207'(&S)'
      OnClick = IPMENU_SORTClick
    end
    object IPMENU_ADD: TMenuItem
      Caption = #22686#21152'IP'#27573'(&A)'
      OnClick = IPMENU_ADDClick
    end
    object IPMENU_DEL: TMenuItem
      Caption = #21024#38500'IP'#27573'(&D)'
      OnClick = IPMENU_DELClick
    end
  end
end
