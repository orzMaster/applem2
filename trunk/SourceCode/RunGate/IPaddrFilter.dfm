object frmIPaddrFilter: TfrmIPaddrFilter
  Left = 376
  Top = 266
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #32593#32476#23433#20840#36807#28388
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
    Caption = #24403#21069#36830#25509
    TabOrder = 0
    object Label4: TLabel
      Left = 8
      Top = 16
      Width = 54
      Height = 12
      Caption = #36830#25509#21015#34920':'
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
    Caption = #36807#28388#21015#34920
    TabOrder = 1
    object LabelTempList: TLabel
      Left = 8
      Top = 16
      Width = 54
      Height = 12
      Caption = #21160#24577#36807#28388':'
    end
    object Label1: TLabel
      Left = 113
      Top = 16
      Width = 54
      Height = 12
      Caption = #27704#20037#36807#28388':'
    end
    object Label23: TLabel
      Left = 7
      Top = 187
      Width = 54
      Height = 12
      Caption = #36807#28388'IP'#27573':'
    end
    object ListBoxBlockList: TListBox
      Left = 113
      Top = 34
      Width = 99
      Height = 146
      Hint = #27704#20037#36807#28388#21015#34920#65292#22312#27492#21015#34920#20013#30340'IP'#23558#26080#27861#24314#31435#36830#25509#65292#27492#21015#34920#23558#20445#23384#20110#37197#32622#25991#20214#20013#65292#22312#31243#24207#37325#26032#21551#21160#26102#20250#37325#26032#21152#36733#27492#21015#34920
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
      Hint = #21160#24577#36807#28388#21015#34920#65292#22312#27492#21015#34920#20013#30340'IP'#23558#26080#27861#24314#31435#36830#25509#65292#20294#22312#31243#24207#37325#26032#21551#21160#26102#27492#21015#34920#30340#20449#24687#23558#34987#28165#31354
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
    Caption = #25915#20987#20445#25252
    TabOrder = 2
    object GroupBox4: TGroupBox
      Left = 10
      Top = 204
      Width = 168
      Height = 117
      Caption = #27969#37327#25511#21046
      TabOrder = 0
      object Label6: TLabel
        Left = 8
        Top = 44
        Width = 54
        Height = 12
        Caption = #26368#22823#38480#21046':'
      end
      object Label8: TLabel
        Left = 8
        Top = 68
        Width = 54
        Height = 12
        Caption = #25968#37327#38480#21046':'
      end
      object Label5: TLabel
        Left = 8
        Top = 20
        Width = 54
        Height = 12
        Caption = #20020#30028#22823#23567':'
      end
      object EditMaxSize: TSpinEdit
        Left = 64
        Top = 40
        Width = 65
        Height = 21
        Hint = #25509#25910#21040#30340#25968#25454#20449#24687#26368#22823#38480#21046#65292#22914#26524#36229#36807#27492#22823#23567#65292#21017#34987#35270#20026#25915#20987#12290
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
        Hint = #19968#27425#25509#25910#21040#25968#25454#20449#24687#30340#25968#37327#22810#23569#65292#36229#36807#25351#23450#25968#37327#23558#34987#35270#20026#25915#20987#12290
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
        Width = 97
        Height = 17
        Hint = #25171#24320#27492#21151#33021#21518#65292#22914#26524#23458#25143#31471#30340#21457#36865#30340#25968#25454#36229#36807#25351#23450#38480#21046#23558#20250#30452#25509#23558#20854#25481#32447
        BiDiMode = bdLeftToRight
        Caption = #24322#24120#25481#32447#22788#29702
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
        Hint = #25509#25910#21040#30340#25968#25454#20449#24687#20020#30028#22823#23567#65292#22914#26524#36229#36807#27492#22823#23567#65292#23558#34987#29305#27530#22788#29702#12290
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
      Caption = #36830#25509#20445#25252
      TabOrder = 1
      object Label7: TLabel
        Left = 57
        Top = 89
        Width = 66
        Height = 12
        Caption = #27627#31186'/'#36830#25509#25968
      end
      object Label2: TLabel
        Left = 57
        Top = 114
        Width = 66
        Height = 12
        Caption = #27627#31186'/'#36830#25509#25968
      end
      object Label9: TLabel
        Left = 7
        Top = 41
        Width = 66
        Height = 12
        Caption = #31354#36830#25509#36229#26102':'
      end
      object Label3: TLabel
        Left = 7
        Top = 19
        Width = 54
        Height = 12
        Caption = #36830#25509#38480#21046':'
      end
      object Label10: TLabel
        Left = 119
        Top = 17
        Width = 42
        Height = 12
        Caption = #36830#25509'/IP'
      end
      object Label11: TLabel
        Left = 119
        Top = 41
        Width = 12
        Height = 12
        Caption = #31186
      end
      object Label19: TLabel
        Left = 119
        Top = 64
        Width = 12
        Height = 12
        Caption = #20998
      end
      object Label20: TLabel
        Left = 7
        Top = 64
        Width = 66
        Height = 12
        Caption = #26080#20256#36755#36229#26102':'
      end
      object Edit_CountLimit1: TSpinEdit
        Left = 126
        Top = 85
        Width = 38
        Height = 21
        Hint = #36229#36830#25509#20445#25252#65292#22312#25351#23450#30340#36830#25509#26102#38388#20869#26368#22823#20801#35768#36830#25509#25968#12290
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
        Hint = #36229#36830#25509#20445#25252#65292#22312#25351#23450#30340#36830#25509#26102#38388#20869#26368#22823#20801#35768#36830#25509#25968#12290
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
        Hint = #36229#36830#25509#20445#25252#65292#36830#25509#25351#23450#26102#38388#12290
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
        Hint = #36229#36830#25509#20445#25252#65292#36830#25509#25351#23450#26102#38388#12290
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
        Hint = #19982#23458#25143#31471#36890#20449#38388#38548#26102#38388','#36229#36807#35813#26102#38388#27809#26377#25968#25454#20256#36755#23558#26029#24320#36830#25509'..'
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
        Width = 147
        Height = 17
        Hint = #26412#35774#32622#21487#38450#19968#23450#37327#30340'CC'#25915#20987#13#10#35831#19981#35201#24403#38450#28779#22681#20351#29992#65292#23545#20110#22823#27969#37327#30340#25915#20987#36824#26159#26080#33021#20026#21147#30340
        Caption = #33258#21160#21028#26029'CC'#24182#24320#21551#38450#24481
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
    Caption = #30830#23450'(&O)'
    TabOrder = 3
    OnClick = ButtonOKClick
  end
  object GroupBox5: TGroupBox
    Left = 547
    Top = 8
    Width = 148
    Height = 135
    Caption = #21457#35328#35774#32622
    TabOrder = 4
    object Label12: TLabel
      Left = 120
      Top = 90
      Width = 12
      Height = 12
      Caption = #31186
    end
    object Label13: TLabel
      Left = 120
      Top = 66
      Width = 12
      Height = 12
      Caption = #27425
    end
    object Label14: TLabel
      Left = 120
      Top = 42
      Width = 24
      Height = 12
      Caption = #27627#31186
    end
    object Label15: TLabel
      Left = 8
      Top = 43
      Width = 54
      Height = 12
      Caption = #26102#38388#38388#38548':'
    end
    object Label16: TLabel
      Left = 8
      Top = 19
      Width = 54
      Height = 12
      Caption = #25991#23383#38271#24230':'
    end
    object Label17: TLabel
      Left = 8
      Top = 67
      Width = 54
      Height = 12
      Caption = #21457#35328#27425#25968':'
    end
    object Label18: TLabel
      Left = 8
      Top = 91
      Width = 54
      Height = 12
      Caption = #31105#35328#26102#38388':'
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
      Width = 105
      Height = 19
      BiDiMode = bdLeftToRight
      Caption = #24320#21551#21457#35328#25511#21046
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
    Caption = #25915#20987#25805#20316
    TabOrder = 5
    object RadioAddBlockList: TRadioButton
      Left = 16
      Top = 48
      Width = 129
      Height = 17
      Hint = #23558#27492#36830#25509#30340'IP'#21152#20837#27704#20037#36807#28388#21015#34920#65292#24182#23558#27492'IP'#30340#25152#26377#36830#25509#24378#34892#20013#26029
      Caption = #21152#20837#27704#20037#36807#28388#21015#34920
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
      Hint = #23558#27492#36830#25509#30340'IP'#21152#20837#21160#24577#36807#28388#21015#34920#65292#24182#23558#27492'IP'#30340#25152#26377#36830#25509#24378#34892#20013#26029
      Caption = #21152#20837#21160#24577#36807#28388#21015#34920
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
      Hint = #23558#36830#25509#31616#21333#30340#26029#24320#22788#29702
      Caption = #26029#24320#36830#25509
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
    Caption = #21464#36895#25511#21046
    TabOrder = 6
    object Label21: TLabel
      Left = 8
      Top = 20
      Width = 54
      Height = 12
      Caption = #21464#36895#38388#38548':'
    end
    object Label22: TLabel
      Left = 8
      Top = 44
      Width = 54
      Height = 12
      Caption = #21464#36895#27425#25968':'
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
