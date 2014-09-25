object frmIPaddrFilter: TfrmIPaddrFilter
  Left = 276
  Top = 168
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Network Security Filtering'
  ClientHeight = 331
  ClientWidth = 550
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
    Height = 316
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
      Height = 271
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
    Height = 316
    Caption = 'Filter the List'
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
      Width = 126
      Height = 12
      Caption = 'Filtering IP segment:'
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
      Top = 202
      Width = 204
      Height = 103
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
    Height = 283
    Caption = 'Attack Protection'
    TabOrder = 2
    object GroupBox7: TGroupBox
      Left = 10
      Top = 19
      Width = 168
      Height = 142
      Caption = 'Connection Protection'
      TabOrder = 0
      object Label7: TLabel
        Left = 57
        Top = 91
        Width = 54
        Height = 12
        Caption = 'Ms / Conn'
      end
      object Label2: TLabel
        Left = 57
        Top = 116
        Width = 54
        Height = 12
        Caption = 'Ms / Conn'
      end
      object Label9: TLabel
        Left = 7
        Top = 41
        Width = 48
        Height = 12
        Caption = 'Timeout:'
      end
      object Label3: TLabel
        Left = 7
        Top = 19
        Width = 36
        Height = 12
        Caption = 'Limit:'
      end
      object Label10: TLabel
        Left = 119
        Top = 17
        Width = 42
        Height = 12
        Caption = 'Conn/IP'
      end
      object Label11: TLabel
        Left = 119
        Top = 41
        Width = 18
        Height = 12
        Caption = 'Sec'
      end
      object Label5: TLabel
        Left = 7
        Top = 65
        Width = 66
        Height = 12
        Caption = 'Empty Conn:'
      end
      object Label6: TLabel
        Left = 119
        Top = 65
        Width = 18
        Height = 12
        Caption = 'Sec'
      end
      object Edit_CountLimit1: TSpinEdit
        Left = 126
        Top = 87
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
        Top = 112
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
        Top = 87
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
        Top = 112
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
        MaxValue = 999
        MinValue = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        Value = 5
        OnChange = EditClientTimeOutTimeChange
      end
      object EditConnectTimeOut: TSpinEdit
        Left = 75
        Top = 61
        Width = 41
        Height = 21
        MaxValue = 999
        MinValue = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        Value = 5
        OnChange = EditConnectTimeOutChange
      end
    end
    object GroupBox3: TGroupBox
      Left = 10
      Top = 167
      Width = 168
      Height = 73
      Caption = 'Attack Actions'
      TabOrder = 1
      object RadioAddBlockList: TRadioButton
        Left = 16
        Top = 48
        Width = 149
        Height = 17
        Hint = 
          'Join this connection permanent IP filter list, and this forced b' +
          'reak all connected IP'
        Caption = 'Add Permanent Filter'
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
        Caption = 'Add Dynamic Filter'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = RadioAddTempListClick
      end
      object RadioDisConnect: TRadioButton
        Left = 16
        Top = 16
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
    object CheckBoxCCProtect: TCheckBox
      Left = 10
      Top = 260
      Width = 174
      Height = 17
      Hint = 'This setting can prevent a certain amount of CC attack '
      Caption = 'Auto Det CC Atk Open Def'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = CheckBoxCCProtectClick
    end
    object CheckBoxCheckClientMsg: TCheckBox
      Left = 10
      Top = 245
      Width = 129
      Height = 17
      Hint = 'Open the packet filter to detect'
      Caption = 'Open Packet Filter'
      TabOrder = 3
      OnClick = CheckBoxCheckClientMsgClick
    end
  end
  object ButtonOK: TButton
    Left = 475
    Top = 297
    Width = 66
    Height = 27
    Caption = 'Okay(&O)'
    TabOrder = 3
    OnClick = ButtonOKClick
  end
  object BlockListPopupMenu: TPopupMenu
    OnPopup = BlockListPopupMenuPopup
    Left = 264
    Top = 120
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
    Left = 168
    Top = 120
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
    Left = 56
    Top = 160
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
