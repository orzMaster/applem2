object frmGameConfig: TfrmGameConfig
  Left = 173
  Top = 173
  ActiveControl = EditRepairDoorPrice
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Game Parameters'
  ClientHeight = 289
  ClientWidth = 504
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label14: TLabel
    Left = 8
    Top = 272
    Width = 432
    Height = 12
    Caption = #35843#25972#30340#21442#25968#31435#21363#29983#25928#65292#22312#32447#26102#35831#30830#35748#27492#21442#25968#30340#20316#29992#20877#35843#25972#65292#20081#35843#25972#23558#23548#33268#28216#25103#28151#20081
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object GameConfigControl: TPageControl
    Left = 6
    Top = 9
    Width = 489
    Height = 257
    ActivePage = CastleSheet
    TabOrder = 0
    OnChanging = GameConfigControlChanging
    object GeneralSheet: TTabSheet
      Caption = 'Enviroment Settings'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBoxInfo: TGroupBox
        Left = 168
        Top = 53
        Width = 153
        Height = 44
        Caption = 'Client Version Number'
        TabOrder = 0
        object Label16: TLabel
          Left = 8
          Top = 20
          Width = 38
          Height = 13
          Caption = 'Version:'
        end
        object EditSoftVersionDate: TEdit
          Left = 64
          Top = 16
          Width = 73
          Height = 21
          Hint = 
            'Client version date settings, this date number must be consisten' +
            't with the date identified on the client, otherwise it will prom' +
            'pt the wrong version when entering the game. Point of entry into' +
            ' force of the Save button.'
          TabOrder = 0
          Text = '20020522'
          OnChange = EditSoftVersionDateChange
        end
      end
      object GroupBox5: TGroupBox
        Left = 168
        Top = 5
        Width = 162
        Height = 44
        Caption = 'Console Displays No of Time(S)'
        TabOrder = 1
        object Label17: TLabel
          Left = 8
          Top = 20
          Width = 52
          Height = 13
          Caption = 'Display Int:'
        end
        object EditConsoleShowUserCountTime: TSpinEdit
          Left = 68
          Top = 16
          Width = 61
          Height = 22
          Hint = 'Program console displays Online intervals.'
          EditorEnabled = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 0
          Value = 10
          OnChange = EditConsoleShowUserCountTimeChange
        end
      end
      object GroupBox6: TGroupBox
        Left = 8
        Top = 101
        Width = 153
        Height = 100
        Caption = 'Announcements Interval (s)'
        TabOrder = 2
        object Label18: TLabel
          Left = 8
          Top = 20
          Width = 38
          Height = 13
          Caption = 'Interval:'
        end
        object Label19: TLabel
          Left = 8
          Top = 44
          Width = 27
          Height = 13
          Caption = 'Color:'
        end
        object Label21: TLabel
          Left = 8
          Top = 68
          Width = 29
          Height = 13
          Caption = 'Prefix:'
        end
        object EditShowLineNoticeTime: TSpinEdit
          Left = 64
          Top = 15
          Width = 57
          Height = 22
          Hint = 'Notice game information display time interval.'
          EditorEnabled = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 0
          Value = 10
          OnChange = EditShowLineNoticeTimeChange
        end
        object ComboBoxLineNoticeColor: TComboBox
          Left = 64
          Top = 40
          Width = 57
          Height = 21
          Hint = 'Announcement text display the default color.'
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 1
          OnChange = ComboBoxLineNoticeColorChange
        end
        object EditLineNoticePreFix: TEdit
          Left = 64
          Top = 64
          Width = 73
          Height = 21
          MaxLength = 20
          TabOrder = 2
          Text = #12310#20844#21578#12311
          OnChange = EditLineNoticePreFixChange
        end
      end
      object ButtonGeneralSave: TButton
        Left = 411
        Top = 184
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 3
        OnClick = ButtonGeneralSaveClick
      end
      object GroupBox35: TGroupBox
        Left = 333
        Top = 3
        Width = 145
        Height = 92
        Caption = 'Console Displays Information'
        TabOrder = 4
        object CheckBoxShowMakeItemMsg: TCheckBox
          Left = 8
          Top = 14
          Width = 97
          Height = 17
          Caption = 'GM Information'
          TabOrder = 0
          OnClick = CheckBoxShowMakeItemMsgClick
        end
        object CbViewHack: TCheckBox
          Left = 8
          Top = 30
          Width = 121
          Height = 17
          Caption = 'Velocity Anomalies'
          TabOrder = 1
          OnClick = CbViewHackClick
        end
        object CkViewAdmfail: TCheckBox
          Left = 8
          Top = 46
          Width = 129
          Height = 17
          Caption = 'Illegal Login'
          TabOrder = 2
          OnClick = CkViewAdmfailClick
        end
        object CheckBoxShowExceptionMsg: TCheckBox
          Left = 8
          Top = 62
          Width = 134
          Height = 17
          Caption = 'Exception Messages'
          TabOrder = 3
          OnClick = CheckBoxShowExceptionMsgClick
        end
      end
      object GroupBox51: TGroupBox
        Left = 8
        Top = 5
        Width = 153
        Height = 92
        Caption = 'Radio Online'
        TabOrder = 5
        object Label98: TLabel
          Left = 3
          Top = 36
          Width = 64
          Height = 13
          Caption = 'Magnifcation:'
        end
        object Label99: TLabel
          Left = 8
          Top = 60
          Width = 38
          Height = 13
          Caption = 'Interval:'
        end
        object Label100: TLabel
          Left = 128
          Top = 60
          Width = 19
          Height = 13
          Caption = 'Sec'
        end
        object EditSendOnlineCountRate: TSpinEdit
          Left = 44
          Top = 32
          Width = 53
          Height = 22
          Hint = 
            'The number of false magnification broadcast online characters, r' +
            'eal data is divided by 10, the default is doubled to 10 and 11 i' +
            's 1.1 times.'
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 10
          TabOrder = 0
          Value = 10
          OnChange = EditSendOnlineCountRateChange
        end
        object EditSendOnlineTime: TSpinEdit
          Left = 68
          Top = 56
          Width = 61
          Height = 22
          Hint = 'Radio Online interval.'
          EditorEnabled = False
          Increment = 10
          MaxValue = 200000
          MinValue = 5
          TabOrder = 1
          Value = 10
          OnChange = EditSendOnlineTimeChange
        end
        object CheckBoxSendOnlineCount: TCheckBox
          Left = 8
          Top = 14
          Width = 89
          Height = 17
          Hint = 
            'Later whether to enable online radio Online function, turn this ' +
            'feature will be displayed in red-line number in the game.'
          Caption = 'Radio Online'
          TabOrder = 2
          OnClick = CheckBoxSendOnlineCountClick
        end
      end
      object GroupBox52: TGroupBox
        Left = 168
        Top = 101
        Width = 153
        Height = 100
        Caption = 'Items Monster DB Magnification'
        TabOrder = 6
        object Label101: TLabel
          Left = 8
          Top = 20
          Width = 41
          Height = 13
          Caption = 'Monster:'
        end
        object Label102: TLabel
          Left = 8
          Top = 44
          Width = 32
          Height = 13
          Caption = 'Item 1:'
        end
        object Label103: TLabel
          Left = 8
          Top = 68
          Width = 32
          Height = 13
          Caption = 'Item 2:'
        end
        object EditMonsterPowerRate: TSpinEdit
          Left = 68
          Top = 16
          Width = 69
          Height = 22
          Hint = 
            'Monster property magnification (HP, MP, DC, MC, SC), the actual ' +
            'figure for the current data divided by 10.'
          EditorEnabled = False
          MaxValue = 20000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditMonsterPowerRateChange
        end
        object EditEditItemsPowerRate: TSpinEdit
          Left = 68
          Top = 40
          Width = 69
          Height = 22
          Hint = 
            'Item Specifics magnification (DC, MC, SC), the actual figure for' +
            ' the current data divided by 10.'
          EditorEnabled = False
          MaxValue = 20000000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditEditItemsPowerRateChange
        end
        object EditItemsACPowerRate: TSpinEdit
          Left = 68
          Top = 64
          Width = 69
          Height = 22
          Hint = 
            'Item Specifics magnification (AC, MAC two), the actual figure fo' +
            'r the current data is divided by 10.'
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 2
          Value = 10
          OnChange = EditItemsACPowerRateChange
        end
      end
      object GroupBox73: TGroupBox
        Left = 328
        Top = 101
        Width = 145
        Height = 49
        Caption = '#CALL'
        TabOrder = 7
        object chkCanNewCall: TCheckBox
          Left = 8
          Top = 18
          Width = 129
          Height = 17
          Caption = 'Use New #CALL'
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          OnClick = chkCanNewCallClick
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Game Options(1)'
      ImageIndex = 7
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox28: TGroupBox
        Left = 1
        Top = 0
        Width = 145
        Height = 102
        Caption = 'Game Mode'
        TabOrder = 0
        object CheckBoxTestServer: TCheckBox
          Left = 8
          Top = 14
          Width = 73
          Height = 17
          Hint = 
            'Test mode, open this mode, the server parameters and functions t' +
            'o be tested.'
          Caption = 'Test Mode'
          TabOrder = 0
          OnClick = CheckBoxTestServerClick
        end
        object CheckBoxServiceMode: TCheckBox
          Left = 8
          Top = 30
          Width = 73
          Height = 17
          Hint = 'Free mode, open the first item will not charge users.'
          Caption = 'Free Mode'
          TabOrder = 1
          OnClick = CheckBoxServiceModeClick
        end
        object CheckBoxVentureMode: TCheckBox
          Left = 8
          Top = 46
          Width = 121
          Height = 17
          Caption = 'Brush Strange Mode'
          TabOrder = 2
          OnClick = CheckBoxVentureModeClick
        end
        object CheckBoxNonPKMode: TCheckBox
          Left = 8
          Top = 62
          Width = 81
          Height = 17
          Caption = #31105#27490'PK'#27169#24335
          TabOrder = 3
          Visible = False
          OnClick = CheckBoxNonPKModeClick
        end
        object chkSafeOffLine: TCheckBox
          Left = 8
          Top = 62
          Width = 81
          Height = 17
          Caption = 'SZ Offline'
          TabOrder = 4
          OnClick = chkSafeOffLineClick
        end
        object seSafeOffLineLevel: TSpinEdit
          Left = 95
          Top = 60
          Width = 42
          Height = 22
          Hint = 'Specify how many more players before automatically hang up'
          MaxValue = 65535
          MinValue = 1
          TabOrder = 5
          Value = 10
          OnChange = seSafeOffLineLevelChange
        end
        object CheckBoxShopOffLine: TCheckBox
          Left = 8
          Top = 79
          Width = 109
          Height = 17
          Caption = 'Oflline Stall'
          TabOrder = 6
          OnClick = CheckBoxShopOffLineClick
        end
      end
      object GroupBox29: TGroupBox
        Left = 179
        Top = 134
        Width = 145
        Height = 93
        Caption = 'Test Mode'
        TabOrder = 1
        Visible = False
        object Label61: TLabel
          Left = 8
          Top = 20
          Width = 51
          Height = 13
          Caption = 'Start Level'
        end
        object Label62: TLabel
          Left = 8
          Top = 44
          Width = 50
          Height = 13
          Caption = 'Start Gold:'
        end
        object Label63: TLabel
          Left = 8
          Top = 68
          Width = 24
          Height = 13
          Caption = 'Limit:'
        end
        object EditTestLevel: TSpinEdit
          Left = 68
          Top = 16
          Width = 69
          Height = 22
          Hint = 'People Start Level'
          MaxValue = 20000
          MinValue = 0
          TabOrder = 0
          Value = 10
          OnChange = EditTestLevelChange
          OnKeyDown = EditTestLevelKeyDown
        end
        object EditTestGold: TSpinEdit
          Left = 68
          Top = 40
          Width = 69
          Height = 22
          Hint = 'People starting a few coins in test mode.'
          Increment = 1000
          MaxValue = 20000000
          MinValue = 0
          TabOrder = 1
          Value = 10
          OnChange = EditTestGoldChange
        end
        object EditTestUserLimit: TSpinEdit
          Left = 68
          Top = 64
          Width = 69
          Height = 22
          Hint = 'Test mode the maximum limit on the number line.'
          Increment = 10
          MaxValue = 2000
          MinValue = 0
          TabOrder = 2
          Value = 10
          OnChange = EditTestUserLimitChange
        end
      end
      object GroupBox30: TGroupBox
        Left = 335
        Top = 8
        Width = 129
        Height = 45
        Caption = 'People Start Setting'
        TabOrder = 2
        object Label60: TLabel
          Left = 8
          Top = 20
          Width = 53
          Height = 13
          Caption = 'Permission:'
        end
        object EditStartPermission: TSpinEdit
          Left = 68
          Top = 15
          Width = 53
          Height = 22
          Hint = 'People start the game privileges, the default is 0.'
          EditorEnabled = False
          MaxValue = 10
          MinValue = 0
          TabOrder = 0
          Value = 10
          OnChange = EditStartPermissionChange
        end
      end
      object ButtonOptionSave0: TButton
        Left = 411
        Top = 184
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 3
        OnClick = ButtonOptionSave0Click
      end
      object GroupBox31: TGroupBox
        Left = 3
        Top = 169
        Width = 169
        Height = 49
        Caption = 'Restrictions Number of Online'
        TabOrder = 4
        object Label64: TLabel
          Left = 8
          Top = 23
          Width = 40
          Height = 13
          Caption = 'Number:'
        end
        object EditUserFull: TSpinEdit
          Left = 54
          Top = 19
          Width = 53
          Height = 22
          Hint = 
            'The latest may limit the number of on-line, on-line after more t' +
            'han this number will prompt red.'
          MaxValue = 10000
          MinValue = 0
          TabOrder = 0
          Value = 1000
          OnChange = EditUserFullChange
        end
      end
      object GroupBox33: TGroupBox
        Left = 155
        Top = 2
        Width = 170
        Height = 71
        Caption = 'People Limit Number of Gold Coins'
        TabOrder = 5
        object Label68: TLabel
          Left = 8
          Top = 22
          Width = 30
          Height = 13
          Caption = 'Offical'
        end
        object Label69: TLabel
          Left = 8
          Top = 46
          Width = 31
          Height = 13
          Caption = 'Demo:'
        end
        object EditHumanMaxGold: TSpinEdit
          Left = 68
          Top = 18
          Width = 85
          Height = 22
          Increment = 10000
          MaxValue = 200000000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditHumanMaxGoldChange
        end
        object EditHumanTryModeMaxGold: TSpinEdit
          Left = 68
          Top = 42
          Width = 85
          Height = 22
          Increment = 10000
          MaxValue = 200000000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditHumanTryModeMaxGoldChange
        end
      end
      object GroupBox34: TGroupBox
        Left = 158
        Top = 74
        Width = 168
        Height = 61
        Caption = 'Demo Level Restrictions'
        TabOrder = 6
        object Label70: TLabel
          Left = 8
          Top = 20
          Width = 29
          Height = 13
          Caption = 'Level:'
        end
        object EditTryModeLevel: TSpinEdit
          Left = 68
          Top = 16
          Width = 61
          Height = 22
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditTryModeLevelChange
        end
        object CheckBoxTryModeUseStorage: TCheckBox
          Left = 8
          Top = 38
          Width = 121
          Height = 17
          Hint = 'Demo mode allows the use of the warehouse.'
          Caption = 'Demo Warehouse'
          TabOrder = 1
          OnClick = CheckBoxTryModeUseStorageClick
        end
      end
      object GroupBox19: TGroupBox
        Left = 335
        Top = 59
        Width = 129
        Height = 46
        Caption = 'Team Member Limit'
        TabOrder = 7
        object Label41: TLabel
          Left = 8
          Top = 20
          Width = 24
          Height = 13
          Caption = 'Limit:'
        end
        object EditGroupMembersMax: TSpinEdit
          Left = 68
          Top = 17
          Width = 53
          Height = 22
          Hint = 'The number of members of the team.'
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditGroupMembersMaxChange
        end
      end
      object GroupBox76: TGroupBox
        Left = 335
        Top = 111
        Width = 129
        Height = 66
        Caption = 'Guild Member Limit'
        TabOrder = 8
        object Label148: TLabel
          Left = 8
          Top = 20
          Width = 39
          Height = 13
          Caption = 'Starting:'
        end
        object Label162: TLabel
          Left = 8
          Top = 42
          Width = 45
          Height = 13
          Caption = 'Each Lvl:'
        end
        object EditDefGuildMemberLimit: TSpinEdit
          Left = 68
          Top = 17
          Width = 53
          Height = 22
          Hint = 'The number of guild members.'
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 100
          OnChange = EditDefGuildMemberLimitChange
        end
        object EditGuildMemberLevelInc: TSpinEdit
          Left = 68
          Top = 39
          Width = 53
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 1
          Value = 5
          OnChange = EditGuildMemberLevelIncChange
        end
      end
      object GroupBox81: TGroupBox
        Left = 3
        Top = 96
        Width = 145
        Height = 67
        Caption = 'Player Stall Taxes'
        TabOrder = 9
        object Label160: TLabel
          Left = 8
          Top = 22
          Width = 44
          Height = 13
          Caption = 'Stall Tax:'
        end
        object Label161: TLabel
          Left = 8
          Top = 50
          Width = 73
          Height = 13
          Caption = 'Acquistion Tax:'
        end
        object EditPersonShopSellRate: TSpinEdit
          Left = 92
          Top = 18
          Width = 46
          Height = 22
          MaxValue = 100
          MinValue = 0
          TabOrder = 0
          Value = 5
          OnChange = EditPersonShopSellRateChange
        end
        object EditPersonShopBuyRate: TSpinEdit
          Left = 92
          Top = 46
          Width = 46
          Height = 22
          MaxValue = 100
          MinValue = 0
          TabOrder = 1
          Value = 5
          OnChange = EditPersonShopBuyRateChange
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Game Options(2)'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox17: TGroupBox
        Left = 280
        Top = 8
        Width = 153
        Height = 169
        Caption = 'Running Through Control'
        TabOrder = 0
        object CheckBoxDisHumRun: TCheckBox
          Left = 7
          Top = 17
          Width = 134
          Height = 13
          Hint = 
            'After opening this function, the characters will not be allowed ' +
            'through the monsters or other characters'
          Caption = 'No Run Through PPL'
          TabOrder = 0
          OnClick = CheckBoxDisHumRunClick
        end
        object CheckBoxRunHum: TCheckBox
          Left = 7
          Top = 32
          Width = 142
          Height = 13
          Hint = 
            'After opening this function, the characters will be able to pass' +
            ' through the other characters'
          Caption = 'Allow Pass Through Chars'
          TabOrder = 1
          OnClick = CheckBoxRunHumClick
        end
        object CheckBoxRunMon: TCheckBox
          Left = 7
          Top = 51
          Width = 134
          Height = 13
          Hint = 
            'After opening this function, the characters will be able to pass' +
            ' through the monster'
          Caption = 'Allow Through Monster'
          TabOrder = 2
          OnClick = CheckBoxRunMonClick
        end
        object CheckBoxWarDisHumRun: TCheckBox
          Left = 7
          Top = 101
          Width = 142
          Height = 13
          Hint = 
            'After opening this function, the siege area, people will be forb' +
            'idden to wear and monsters'
          Caption = 'All Prohibited Siege Area'
          TabOrder = 3
          OnClick = CheckBoxWarDisHumRunClick
        end
        object CheckBoxRunNpc: TCheckBox
          Left = 7
          Top = 67
          Width = 119
          Height = 13
          Hint = 
            'After opening this function, the characters will be able to pass' +
            ' through the NPC'
          Caption = 'Allow Through NPC'
          TabOrder = 4
          OnClick = CheckBoxRunNpcClick
        end
        object CheckBoxGMRunAll: TCheckBox
          Left = 7
          Top = 119
          Width = 142
          Height = 13
          Hint = 
            'After opening this function, super game administrator from above' +
            ' set limits.'
          Caption = 'Admins Uncontrolled'
          TabOrder = 5
          OnClick = CheckBoxGMRunAllClick
        end
        object CheckBoxRunGuard: TCheckBox
          Left = 7
          Top = 83
          Width = 119
          Height = 13
          Hint = 
            'After opening this function, the characters will be able to pass' +
            ' through the guard (machetes, archers)'
          Caption = 'Allow Cross Guard'
          TabOrder = 6
          OnClick = CheckBoxRunGuardClick
        end
        object CheckBoxSafeArea: TCheckBox
          Left = 7
          Top = 136
          Width = 138
          Height = 17
          Caption = 'SZ Uncontrolled'
          TabOrder = 7
          OnClick = CheckBoxSafeAreaClick
        end
      end
      object ButtonOptionSave3: TButton
        Left = 411
        Top = 184
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 1
        OnClick = ButtonOptionSave3Click
      end
      object GroupBox53: TGroupBox
        Left = 3
        Top = 8
        Width = 134
        Height = 113
        Caption = 'Transaction Control'
        TabOrder = 2
        object Label20: TLabel
          Left = 3
          Top = 20
          Width = 69
          Height = 13
          Caption = 'Trade Interval:'
        end
        object Label104: TLabel
          Left = 3
          Top = 44
          Width = 68
          Height = 13
          Caption = 'Comfirm Trade'
        end
        object Label105: TLabel
          Left = 111
          Top = 20
          Width = 19
          Height = 13
          Caption = 'Sec'
        end
        object Label106: TLabel
          Left = 111
          Top = 43
          Width = 19
          Height = 13
          Caption = 'Sec'
        end
        object EditTryDealTime: TSpinEdit
          Left = 74
          Top = 16
          Width = 37
          Height = 22
          Hint = 
            'After closing the transaction, the transaction must be re-specif' +
            'ied time interval.'
          EditorEnabled = False
          MaxValue = 10
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditTryDealTimeChange
        end
        object EditDealOKTime: TSpinEdit
          Left = 74
          Top = 40
          Width = 37
          Height = 22
          Hint = 
            'After the transaction put items must wait a specified time and t' +
            'hen the OK button.'
          EditorEnabled = False
          MaxValue = 10
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditDealOKTimeChange
        end
        object CheckBoxCanNotGetBackDeal: TCheckBox
          Left = 11
          Top = 64
          Width = 110
          Height = 13
          Hint = 
            'After opening this function, items placed on the transaction wil' +
            'l not get back, only to cancel the transaction and re-deal.'
          Caption = 'No Retrieve Items'
          TabOrder = 2
          OnClick = CheckBoxCanNotGetBackDealClick
        end
        object CheckBoxDisableDeal: TCheckBox
          Left = 11
          Top = 80
          Width = 110
          Height = 13
          Hint = 
            'After the prohibition of trade in the game will not allow the tr' +
            'ansaction.'
          Caption = 'No Transaction'
          TabOrder = 3
          OnClick = CheckBoxDisableDealClick
        end
      end
      object GroupBox26: TGroupBox
        Left = 8
        Top = 128
        Width = 129
        Height = 49
        Caption = 'Green PSN - HP Time'
        TabOrder = 3
        object Label57: TLabel
          Left = 8
          Top = 20
          Width = 38
          Height = 13
          Caption = 'Interval:'
        end
        object EditPosionDecHealthTime: TSpinEdit
          Left = 68
          Top = 16
          Width = 53
          Height = 22
          Hint = 'People in the green poison, reducing life-time interval.'
          Increment = 100
          MaxValue = 20000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditPosionDecHealthTimeChange
        end
      end
      object GroupBox27: TGroupBox
        Left = 144
        Top = 128
        Width = 129
        Height = 49
        Caption = 'Red PSN Rate Cut Def'
        TabOrder = 4
        object Label59: TLabel
          Left = 8
          Top = 20
          Width = 28
          Height = 13
          Caption = 'Ratio:'
        end
        object EditPosionDamagarmor: TSpinEdit
          Left = 44
          Top = 16
          Width = 53
          Height = 22
          Hint = 
            'People in red poison lasting less defensive and articles ratio, ' +
            'this value is divided by 10 for the true value.'
          EditorEnabled = False
          MaxValue = 20000
          MinValue = 10
          TabOrder = 0
          Value = 10
          OnChange = EditPosionDamagarmorChange
        end
      end
      object GroupBox64: TGroupBox
        Left = 144
        Top = 8
        Width = 129
        Height = 113
        Caption = 'Throw Control'
        TabOrder = 5
        object Label118: TLabel
          Left = 8
          Top = 44
          Width = 61
          Height = 13
          Caption = 'Good Prices:'
        end
        object Label119: TLabel
          Left = 8
          Top = 68
          Width = 25
          Height = 13
          Caption = 'Gold:'
        end
        object EditCanDropPrice: TSpinEdit
          Left = 69
          Top = 40
          Width = 52
          Height = 22
          Hint = 
            'ess than this price items, disappeared immediately after the thr' +
            'ow, does not appear in the ground.'
          Increment = 100
          MaxValue = 20000000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditCanDropPriceChange
        end
        object CheckBoxControlDropItem: TCheckBox
          Left = 11
          Top = 20
          Width = 110
          Height = 13
          Hint = 
            'After opening this function will figure dropped to inspect the i' +
            'tems and gold coins, gold coins or less than the specified rules' +
            ' will not allow the items price dropped to, or dropped to disapp' +
            'ear immediately.'
          Caption = 'Enable Throw Ctrl'
          TabOrder = 1
          OnClick = CheckBoxControlDropItemClick
        end
        object EditCanDropGold: TSpinEdit
          Left = 68
          Top = 64
          Width = 53
          Height = 22
          Hint = 'Less than a specified number of coins, will be banned throw.'
          Increment = 100
          MaxValue = 20000000
          MinValue = 1
          TabOrder = 2
          Value = 10
          OnChange = EditCanDropGoldChange
        end
        object CheckBoxIsSafeDisableDrop: TCheckBox
          Left = 11
          Top = 92
          Width = 110
          Height = 13
          Hint = 
            'After opening this function, the safety zone will be allowed to ' +
            'throw items.'
          Caption = 'SZ No Throw'
          TabOrder = 3
          OnClick = CheckBoxIsSafeDisableDropClick
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Coordinate Range'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ButtonOptionSave: TButton
        Left = 411
        Top = 184
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 0
        OnClick = ButtonOptionSaveClick
      end
      object GroupBox16: TGroupBox
        Left = 8
        Top = 8
        Width = 105
        Height = 44
        Caption = 'SZ Range'
        TabOrder = 1
        object Label39: TLabel
          Left = 8
          Top = 20
          Width = 23
          Height = 13
          Caption = 'Size:'
        end
        object EditSafeZoneSize: TSpinEdit
          Left = 44
          Top = 16
          Width = 45
          Height = 22
          Hint = 'Safety zone range size.'
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditSafeZoneSizeChange
        end
      end
      object GroupBox18: TGroupBox
        Left = 8
        Top = 58
        Width = 105
        Height = 44
        Caption = 'New Char Range'
        TabOrder = 2
        object Label40: TLabel
          Left = 8
          Top = 20
          Width = 35
          Height = 13
          Caption = 'Range:'
        end
        object EditStartPointSize: TSpinEdit
          Left = 44
          Top = 16
          Width = 45
          Height = 22
          Hint = 
            'New-born point control, the default setting for the first three ' +
            'security zones.'
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditStartPointSizeChange
        end
      end
      object GroupBox20: TGroupBox
        Left = 120
        Top = 8
        Width = 145
        Height = 94
        Caption = 'Red Village'
        TabOrder = 3
        object Label42: TLabel
          Left = 8
          Top = 44
          Width = 41
          Height = 13
          Caption = 'Coord X:'
        end
        object Label43: TLabel
          Left = 8
          Top = 68
          Width = 41
          Height = 13
          Caption = 'Coord Y:'
        end
        object Label44: TLabel
          Left = 8
          Top = 20
          Width = 24
          Height = 13
          Caption = 'Map:'
        end
        object EditRedHomeX: TSpinEdit
          Left = 52
          Top = 40
          Width = 53
          Height = 22
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditRedHomeXChange
        end
        object EditRedHomeY: TSpinEdit
          Left = 52
          Top = 64
          Width = 53
          Height = 22
          MaxValue = 2000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditRedHomeYChange
        end
        object EditRedHomeMap: TEdit
          Left = 52
          Top = 16
          Width = 73
          Height = 21
          Hint = #32418#21517#20154#29289#38598#20013#28857#22320#22270#21517#31216#12290
          TabOrder = 2
          Text = '3'
          OnChange = EditRedHomeMapChange
        end
      end
      object GroupBox21: TGroupBox
        Left = 8
        Top = 108
        Width = 145
        Height = 89
        Caption = 'Red Death Back to City'
        TabOrder = 4
        object Label45: TLabel
          Left = 8
          Top = 44
          Width = 41
          Height = 13
          Caption = 'Coord X:'
        end
        object Label46: TLabel
          Left = 8
          Top = 68
          Width = 41
          Height = 13
          Caption = 'Coord Y:'
        end
        object Label47: TLabel
          Left = 8
          Top = 20
          Width = 24
          Height = 13
          Caption = 'Map:'
        end
        object EditRedDieHomeX: TSpinEdit
          Left = 52
          Top = 40
          Width = 53
          Height = 22
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditRedDieHomeXChange
        end
        object EditRedDieHomeY: TSpinEdit
          Left = 52
          Top = 64
          Width = 53
          Height = 22
          MaxValue = 2000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditRedDieHomeYChange
        end
        object EditRedDieHomeMap: TEdit
          Left = 52
          Top = 16
          Width = 73
          Height = 21
          TabOrder = 2
          Text = '3'
          OnChange = EditRedDieHomeMapChange
        end
      end
      object GroupBox22: TGroupBox
        Left = 272
        Top = 8
        Width = 145
        Height = 94
        Caption = 'Emergency Back to City'
        TabOrder = 5
        object Label48: TLabel
          Left = 8
          Top = 44
          Width = 41
          Height = 13
          Caption = 'Coord X:'
        end
        object Label49: TLabel
          Left = 8
          Top = 68
          Width = 41
          Height = 13
          Caption = 'Coord Y:'
        end
        object Label50: TLabel
          Left = 8
          Top = 20
          Width = 24
          Height = 13
          Caption = 'Map:'
        end
        object EditHomeX: TSpinEdit
          Left = 52
          Top = 40
          Width = 53
          Height = 22
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditHomeXChange
        end
        object EditHomeY: TSpinEdit
          Left = 52
          Top = 64
          Width = 53
          Height = 22
          MaxValue = 2000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditHomeYChange
        end
        object EditHomeMap: TEdit
          Left = 52
          Top = 16
          Width = 73
          Height = 21
          TabOrder = 2
          Text = '3'
          OnChange = EditHomeMapChange
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'PK Control'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ButtonOptionSave2: TButton
        Left = 411
        Top = 184
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 0
        OnClick = ButtonOptionSave2Click
      end
      object GroupBox23: TGroupBox
        Left = 8
        Top = 8
        Width = 153
        Height = 73
        Caption = 'Auto Cut PK Point Ctrl'
        TabOrder = 1
        object Label51: TLabel
          Left = 8
          Top = 20
          Width = 38
          Height = 13
          Caption = 'Interval:'
        end
        object Label52: TLabel
          Left = 8
          Top = 44
          Width = 56
          Height = 13
          Caption = 'Once Point:'
        end
        object Label53: TLabel
          Left = 128
          Top = 20
          Width = 19
          Height = 13
          Caption = 'Sec'
        end
        object EditDecPkPointTime: TSpinEdit
          Left = 68
          Top = 16
          Width = 53
          Height = 22
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditDecPkPointTimeChange
        end
        object EditDecPkPointCount: TSpinEdit
          Left = 68
          Top = 40
          Width = 53
          Height = 22
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditDecPkPointCountChange
        end
      end
      object GroupBox24: TGroupBox
        Left = 8
        Top = 87
        Width = 154
        Height = 49
        Caption = 'PK State Color(s)'
        TabOrder = 2
        object Label54: TLabel
          Left = 8
          Top = 21
          Width = 26
          Height = 13
          Caption = 'Time:'
        end
        object EditPKFlagTime: TSpinEdit
          Left = 44
          Top = 17
          Width = 53
          Height = 22
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditPKFlagTimeChange
        end
      end
      object GroupBox25: TGroupBox
        Left = 8
        Top = 142
        Width = 154
        Height = 49
        Caption = 'PK Point Increase'
        TabOrder = 3
        object Label55: TLabel
          Left = 8
          Top = 22
          Width = 27
          Height = 13
          Caption = 'Point:'
        end
        object EditKillHumanAddPKPoint: TSpinEdit
          Left = 44
          Top = 18
          Width = 53
          Height = 22
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditKillHumanAddPKPointChange
        end
      end
      object GroupBox32: TGroupBox
        Left = 168
        Top = 8
        Width = 265
        Height = 169
        Caption = 'PK Rules'
        TabOrder = 4
        object Label58: TLabel
          Left = 112
          Top = 20
          Width = 67
          Height = 13
          Caption = 'Incr No of Lvl:'
        end
        object Label65: TLabel
          Left = 112
          Top = 44
          Width = 65
          Height = 13
          Caption = 'Minus No Lvl:'
        end
        object Label66: TLabel
          Left = 115
          Top = 69
          Width = 68
          Height = 13
          Caption = 'Increase EXP:'
        end
        object Label56: TLabel
          Left = 112
          Top = 92
          Width = 65
          Height = 13
          Caption = 'Reduce EXP:'
        end
        object Label67: TLabel
          Left = 8
          Top = 92
          Width = 34
          Height = 13
          Caption = 'PK Lvl:'
        end
        object Label114: TLabel
          Left = 112
          Top = 116
          Width = 71
          Height = 13
          Caption = 'PK Protect Lvl:'
        end
        object Label115: TLabel
          Left = 32
          Top = 140
          Width = 151
          Height = 13
          Caption = 'Red Name PK Protection Level:'
        end
        object CheckBoxKillHumanWinLevel: TCheckBox
          Left = 8
          Top = 18
          Width = 97
          Height = 17
          Caption = 'Incr Lvl of PK'
          TabOrder = 0
          OnClick = CheckBoxKillHumanWinLevelClick
        end
        object CheckBoxKilledLostLevel: TCheckBox
          Left = 8
          Top = 36
          Width = 97
          Height = 17
          Caption = 'Killed Minus Lvl'
          TabOrder = 1
          OnClick = CheckBoxKilledLostLevelClick
        end
        object CheckBoxKilledLostExp: TCheckBox
          Left = 8
          Top = 68
          Width = 97
          Height = 17
          Caption = 'Killed Less EXP'
          TabOrder = 2
          OnClick = CheckBoxKilledLostExpClick
        end
        object CheckBoxKillHumanWinExp: TCheckBox
          Left = 8
          Top = 52
          Width = 97
          Height = 17
          Caption = 'PK Gain EXP'
          TabOrder = 3
          OnClick = CheckBoxKillHumanWinExpClick
        end
        object EditKillHumanWinLevel: TSpinEdit
          Left = 184
          Top = 16
          Width = 73
          Height = 22
          Hint = 'Increase Level when commit Murder'
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 4
          Value = 10
          OnChange = EditKillHumanWinLevelChange
        end
        object EditKilledLostLevel: TSpinEdit
          Left = 184
          Top = 40
          Width = 73
          Height = 22
          Hint = 'Reduce Level when PK'#39'd'
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 5
          Value = 10
          OnChange = EditKilledLostLevelChange
        end
        object EditKillHumanWinExp: TSpinEdit
          Left = 184
          Top = 64
          Width = 73
          Height = 22
          Increment = 1000
          MaxValue = 200000000
          MinValue = 1
          TabOrder = 6
          Value = 10
          OnChange = EditKillHumanWinExpChange
        end
        object EditKillHumanLostExp: TSpinEdit
          Left = 184
          Top = 88
          Width = 73
          Height = 22
          Increment = 1000
          MaxValue = 200000000
          MinValue = 1
          TabOrder = 7
          Value = 10
          OnChange = EditKillHumanLostExpChange
        end
        object EditHumanLevelDiffer: TSpinEdit
          Left = 48
          Top = 88
          Width = 49
          Height = 22
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 8
          Value = 10
          OnChange = EditHumanLevelDifferChange
        end
        object CheckBoxPKLevelProtect: TCheckBox
          Left = 8
          Top = 116
          Width = 98
          Height = 17
          Hint = 
            'PK protection function is enabled, turn this feature on, the gam' +
            'e character is higher than the level of protection will not kill' +
            ' people below the protection level (low-level characters except ' +
            'the first attack discoloration), lower than the protection level' +
            ' of the characters nor can kill higher protection Rating figures' +
            ' (except for high-grade character first attack discoloration).'
          Caption = 'Ord PK Protect'
          TabOrder = 9
          OnClick = CheckBoxPKLevelProtectClick
        end
        object EditPKProtectLevel: TSpinEdit
          Left = 184
          Top = 112
          Width = 73
          Height = 22
          Hint = 
            'Protection. This rating following figures protected, but the fir' +
            'st attack discoloration is unprotected.'
          EditorEnabled = False
          MaxValue = 65535
          MinValue = 1
          TabOrder = 10
          Value = 10
          OnChange = EditPKProtectLevelChange
        end
        object EditRedPKProtectLevel: TSpinEdit
          Left = 184
          Top = 136
          Width = 73
          Height = 22
          Hint = 
            'Red name characters PK protection, higher than the level of prot' +
            'ection can not kill red name figures below the protection level ' +
            'is not red name characters. Below the protection level is not re' +
            'd nor the name of the characters can kill higher level of protec' +
            'tion red name characters.'
          EditorEnabled = False
          MaxValue = 65535
          MinValue = 1
          TabOrder = 11
          Value = 10
          OnChange = EditRedPKProtectLevelChange
        end
      end
    end
    object GameSpeedSheet: TTabSheet
      Caption = 'Game Speed'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 97
        Height = 170
        Caption = 'Interval Ctrl (ms)'
        TabOrder = 0
        object Label1: TLabel
          Left = 11
          Top = 24
          Width = 22
          Height = 13
          Caption = 'Attk:'
        end
        object Label2: TLabel
          Left = 11
          Top = 48
          Width = 32
          Height = 13
          Caption = 'Magic:'
        end
        object Label3: TLabel
          Left = 11
          Top = 72
          Width = 29
          Height = 13
          Caption = 'Runn:'
        end
        object Label4: TLabel
          Left = 11
          Top = 96
          Width = 28
          Height = 13
          Caption = 'Walk:'
        end
        object Label5: TLabel
          Left = 3
          Top = 143
          Width = 43
          Height = 13
          Caption = 'DigMeat:'
        end
        object Label6: TLabel
          Left = 11
          Top = 120
          Width = 28
          Height = 13
          Caption = 'Steer:'
        end
        object EditHitIntervalTime: TSpinEdit
          Left = 44
          Top = 20
          Width = 45
          Height = 22
          EditorEnabled = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 0
          Value = 900
          OnChange = EditHitIntervalTimeChange
        end
        object EditMagicHitIntervalTime: TSpinEdit
          Left = 44
          Top = 44
          Width = 45
          Height = 22
          EditorEnabled = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 1
          Value = 800
          OnChange = EditMagicHitIntervalTimeChange
        end
        object EditRunIntervalTime: TSpinEdit
          Left = 44
          Top = 68
          Width = 45
          Height = 22
          EditorEnabled = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 2
          Value = 600
          OnChange = EditRunIntervalTimeChange
        end
        object EditWalkIntervalTime: TSpinEdit
          Left = 44
          Top = 92
          Width = 45
          Height = 22
          EditorEnabled = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 3
          Value = 600
          OnChange = EditWalkIntervalTimeChange
        end
        object EditTurnIntervalTime: TSpinEdit
          Left = 44
          Top = 116
          Width = 45
          Height = 22
          EditorEnabled = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 4
          Value = 600
          OnChange = EditTurnIntervalTimeChange
        end
        object EditDigUpIntervalTime: TSpinEdit
          Left = 44
          Top = 140
          Width = 45
          Height = 22
          EditorEnabled = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 5
          Value = 10
          OnChange = EditDigUpIntervalTimeChange
        end
      end
      object GroupBox2: TGroupBox
        Left = 112
        Top = 8
        Width = 81
        Height = 169
        Caption = 'Data Controller'
        TabOrder = 1
        object Label7: TLabel
          Left = 11
          Top = 24
          Width = 22
          Height = 13
          Caption = 'Attk:'
        end
        object Label8: TLabel
          Left = 11
          Top = 48
          Width = 32
          Height = 13
          Caption = 'Magic:'
        end
        object Label9: TLabel
          Left = 11
          Top = 72
          Width = 29
          Height = 13
          Caption = 'Runn:'
        end
        object Label10: TLabel
          Left = 11
          Top = 96
          Width = 28
          Height = 13
          Caption = 'Walk:'
        end
        object Label11: TLabel
          Left = 3
          Top = 144
          Width = 43
          Height = 13
          Caption = 'DigMeat:'
        end
        object Label12: TLabel
          Left = 11
          Top = 120
          Width = 28
          Height = 13
          Caption = 'Steer:'
        end
        object EditMaxHitMsgCount: TSpinEdit
          Left = 44
          Top = 20
          Width = 29
          Height = 22
          Hint = 
            'Allows simultaneous operation number, this parameter defaults to' +
            ' 1 (to increase this number, there will be double and fold attac' +
            'k)'
          EditorEnabled = False
          MaxValue = 50
          MinValue = 1
          TabOrder = 0
          Value = 2
          OnChange = EditMaxHitMsgCountChange
        end
        object EditMaxSpellMsgCount: TSpinEdit
          Left = 44
          Top = 44
          Width = 29
          Height = 22
          Hint = 
            'Allows simultaneous operation number, this parameter defaults to' +
            ' 1 (to increase this number, there will be double and fold attac' +
            'k)'
          EditorEnabled = False
          MaxValue = 50
          MinValue = 1
          TabOrder = 1
          Value = 2
          OnChange = EditMaxSpellMsgCountChange
        end
        object EditMaxRunMsgCount: TSpinEdit
          Left = 44
          Top = 68
          Width = 29
          Height = 22
          Hint = 
            'Allows simultaneous operation number, this parameter defaults to' +
            ' 1 (to increase this number, there will be double and fold attac' +
            'k)'
          EditorEnabled = False
          MaxValue = 50
          MinValue = 1
          TabOrder = 2
          Value = 2
          OnChange = EditMaxRunMsgCountChange
        end
        object EditMaxWalkMsgCount: TSpinEdit
          Left = 44
          Top = 92
          Width = 29
          Height = 22
          Hint = 
            'Allows simultaneous operation number, this parameter defaults to' +
            ' 1 (to increase this number, there will be double and fold attac' +
            'k)'
          EditorEnabled = False
          MaxValue = 50
          MinValue = 1
          TabOrder = 3
          Value = 2
          OnChange = EditMaxWalkMsgCountChange
        end
        object EditMaxTurnMsgCount: TSpinEdit
          Left = 44
          Top = 116
          Width = 29
          Height = 22
          Hint = 
            'Allows simultaneous operation number, this parameter defaults to' +
            ' 1 (to increase this number, there will be double and fold attac' +
            'k)'
          EditorEnabled = False
          MaxValue = 50
          MinValue = 1
          TabOrder = 4
          Value = 2
          OnChange = EditMaxTurnMsgCountChange
        end
        object EditMaxDigUpMsgCount: TSpinEdit
          Left = 44
          Top = 140
          Width = 29
          Height = 22
          Hint = 
            'Allows simultaneous operation number, this parameter defaults to' +
            ' 1 (to increase this number, there will be double and fold attac' +
            'k)'
          EditorEnabled = False
          MaxValue = 50
          MinValue = 1
          TabOrder = 5
          Value = 2
          OnChange = EditMaxDigUpMsgCountChange
        end
      end
      object GroupBox3: TGroupBox
        Left = 360
        Top = 72
        Width = 113
        Height = 49
        Caption = 'Speed'
        Enabled = False
        TabOrder = 2
        object Label13: TLabel
          Left = 19
          Top = 24
          Width = 34
          Height = 13
          Caption = 'Speed:'
        end
        object EditItemSpeedTime: TSpinEdit
          Left = 60
          Top = 20
          Width = 45
          Height = 22
          Hint = 
            'Control equipment to accelerate the case, the larger the number,' +
            ' the wider, more specifically less stringent'
          EditorEnabled = False
          Enabled = False
          MaxValue = 50
          MinValue = 1
          TabOrder = 0
          Value = 50
          OnChange = EditItemSpeedTimeChange
        end
      end
      object ButtonGameSpeedSave: TButton
        Left = 419
        Top = 163
        Width = 54
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 3
        OnClick = ButtonGameSpeedSaveClick
      end
      object GroupBox4: TGroupBox
        Left = 360
        Top = 8
        Width = 113
        Height = 57
        Caption = 'Speed Ctrl Mode'
        TabOrder = 4
        object RadioButtonDelyMode: TRadioButton
          Left = 8
          Top = 16
          Width = 97
          Height = 17
          Hint = 
            'Will exceed the speed of operation of any delay in order to main' +
            'tain normal speed, the use of this model will cause clients to u' +
            'se the acceleration phenomenon card.'
          Caption = 'Handling Pause'
          TabOrder = 0
          OnClick = RadioButtonDelyModeClick
        end
        object RadioButtonFilterMode: TRadioButton
          Left = 8
          Top = 32
          Width = 97
          Height = 17
          Hint = 
            'Will exceed the speed of operation of direct filtration treatmen' +
            't, discard super speed operation, the use of this model will res' +
            'ult in accelerated client card knife, a rebound phenomenon.'
          Caption = 'Bounce Card '
          TabOrder = 1
          OnClick = RadioButtonFilterModeClick
        end
      end
      object GroupBox7: TGroupBox
        Left = 200
        Top = 96
        Width = 129
        Height = 81
        Caption = 'PPL Over Control'
        TabOrder = 5
        Visible = False
        object Label22: TLabel
          Left = 9
          Top = 22
          Width = 48
          Height = 13
          Caption = 'Res Time:'
        end
        object EditStruckTime: TSpinEdit
          Left = 66
          Top = 18
          Width = 53
          Height = 22
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 10
          TabOrder = 0
          Value = 100
          OnChange = EditStruckTimeChange
        end
        object CheckBoxDisableStruck: TCheckBox
          Left = 9
          Top = 43
          Width = 117
          Height = 17
          Caption = 'PPL bending Action'
          Enabled = False
          TabOrder = 1
          OnClick = CheckBoxDisableStruckClick
        end
        object CheckBoxDisableSelfStruck: TCheckBox
          Left = 9
          Top = 59
          Width = 105
          Height = 17
          Caption = 'PPL do not stoop'
          Enabled = False
          TabOrder = 2
          OnClick = CheckBoxDisableSelfStruckClick
        end
      end
      object GroupBox15: TGroupBox
        Left = 199
        Top = 0
        Width = 163
        Height = 98
        Caption = 'Operation Data Control'
        TabOrder = 6
        object Label38: TLabel
          Left = 11
          Top = 72
          Width = 31
          Height = 13
          Caption = 'Views:'
        end
        object Label142: TLabel
          Left = 88
          Top = 72
          Width = 25
          Height = 13
          Caption = 'Filter:'
          Visible = False
        end
        object EditOverSpeedKickCount: TSpinEdit
          Left = 44
          Top = 68
          Width = 46
          Height = 22
          Hint = 
            'Speeding the number of ultra-specified number were kicked off th' +
            'e assembly line.'
          EditorEnabled = False
          MaxValue = 50
          MinValue = 1
          TabOrder = 0
          Value = 4
          OnChange = EditOverSpeedKickCountChange
        end
        object CheckBoxboKickOverSpeed: TCheckBox
          Left = 8
          Top = 47
          Width = 147
          Height = 17
          Hint = 'People will kick off the assembly line speed operation.'
          Caption = 'Dropped Speed Operation'
          TabOrder = 1
          OnClick = CheckBoxboKickOverSpeedClick
        end
        object EditDropOverSpeed: TSpinEdit
          Left = 114
          Top = 68
          Width = 41
          Height = 22
          Hint = 
            'Filtering overspeed operation data, the smaller the number the m' +
            'ore stringent, the client will appear card knife or a rebound ph' +
            'enomenon after filtration. (Ms)'
          EditorEnabled = False
          Increment = 10
          MaxValue = 1000
          MinValue = 1
          TabOrder = 2
          Value = 50
          Visible = False
          OnChange = EditDropOverSpeedChange
        end
        object CheckBoxSpellSendUpdateMsg: TCheckBox
          Left = 8
          Top = 15
          Width = 155
          Height = 17
          Hint = 
            'Control characters while the same magic manipulate data, while o' +
            'nly one magic attack operations'
          Caption = 'Data Ctrl Amount Magic'
          Enabled = False
          TabOrder = 3
          OnClick = CheckBoxSpellSendUpdateMsgClick
        end
        object CheckBoxActionSendActionMsg: TCheckBox
          Left = 8
          Top = 31
          Width = 152
          Height = 17
          Hint = 
            'Control characters operate simultaneously attack the same data, ' +
            'but only have a magic attack operations'
          Caption = 'Data amount Ctrl Atk Operation'
          Enabled = False
          TabOrder = 4
          OnClick = CheckBoxActionSendActionMsgClick
        end
      end
      object ButtonGameSpeedDefault: TButton
        Left = 360
        Top = 163
        Width = 54
        Height = 25
        Caption = 'Default(&D)'
        TabOrder = 7
        OnClick = ButtonGameSpeedDefaultClick
      end
      object ButtonActionSpeedConfig: TButton
        Left = 360
        Top = 130
        Width = 113
        Height = 25
        Caption = 'Comb Speed Setting(&A)'
        Enabled = False
        TabOrder = 8
        OnClick = ButtonActionSpeedConfigClick
      end
      object GroupBox78: TGroupBox
        Left = 8
        Top = 178
        Width = 270
        Height = 53
        Caption = 'Speed Parameter Settings(ms)'
        TabOrder = 9
        object Label151: TLabel
          Left = 136
          Top = 24
          Width = 70
          Height = 13
          Caption = 'Magic Interval:'
        end
        object Label152: TLabel
          Left = 11
          Top = 24
          Width = 50
          Height = 13
          Caption = 'Cooldown:'
        end
        object EditHitFrameTime: TSpinEdit
          Left = 73
          Top = 20
          Width = 45
          Height = 22
          EditorEnabled = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 0
          Value = 900
          OnChange = EditHitFrameTimeChange
        end
        object EditMagicHitFrameTime: TSpinEdit
          Left = 206
          Top = 20
          Width = 45
          Height = 22
          EditorEnabled = False
          Increment = 10
          MaxValue = 2000
          MinValue = 10
          TabOrder = 1
          Value = 800
          OnChange = EditMagicHitFrameTimeChange
        end
      end
    end
    object TabSheet10: TTabSheet
      Caption = 'State Control'
      ImageIndex = 13
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ButtonCharStatusSave: TButton
        Left = 411
        Top = 184
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 0
        OnClick = ButtonCharStatusSaveClick
      end
      object GroupBox72: TGroupBox
        Left = 3
        Top = 3
        Width = 142
        Height = 89
        Caption = 'Paralysis Control'
        TabOrder = 1
        object CheckBoxParalyCanRun: TCheckBox
          Left = 8
          Top = 16
          Width = 97
          Height = 17
          Hint = 
            'People are allowed to run after being paralyzed on the hook to a' +
            'llow running'
          Caption = 'Allow Running'
          TabOrder = 0
          OnClick = CheckBoxParalyCanRunClick
        end
        object CheckBoxParalyCanWalk: TCheckBox
          Left = 8
          Top = 32
          Width = 129
          Height = 17
          Hint = 
            'People are allowed to run after being paralyzed on the hook to a' +
            'llow the move'
          Caption = 'Allow to Move Around'
          TabOrder = 1
          OnClick = CheckBoxParalyCanWalkClick
        end
        object CheckBoxParalyCanHit: TCheckBox
          Left = 8
          Top = 48
          Width = 97
          Height = 17
          Hint = 
            'Whether to allow the running after the figure was paralyzed on t' +
            'he hook for allowing the attack'
          Caption = 'Allow to Attack'
          TabOrder = 2
          OnClick = CheckBoxParalyCanHitClick
        end
        object CheckBoxParalyCanSpell: TCheckBox
          Left = 8
          Top = 64
          Width = 113
          Height = 17
          Hint = 
            'People are allowed to run after being paralyzed on the hook to a' +
            'llow magic'
          Caption = 'Allow Magic Attack'
          TabOrder = 3
          OnClick = CheckBoxParalyCanSpellClick
        end
      end
    end
    object ExpSheet: TTabSheet
      Caption = 'Upgrade EXP'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox8: TGroupBox
        Left = 184
        Top = 8
        Width = 145
        Height = 89
        Caption = 'Shaguai EXP'
        TabOrder = 0
        object Label23: TLabel
          Left = 11
          Top = 24
          Width = 66
          Height = 13
          Caption = 'Magnification:'
        end
        object EditKillMonExpMultiple: TSpinEdit
          Left = 83
          Top = 20
          Width = 53
          Height = 22
          EditorEnabled = False
          MaxValue = 2000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditKillMonExpMultipleChange
        end
        object CheckBoxHighLevelKillMonFixExp: TCheckBox
          Left = 11
          Top = 45
          Width = 126
          Height = 17
          Hint = 'Experience the same high level of killing'
          Caption = 'EXP same Hi-Lvl Killin'
          TabOrder = 1
          OnClick = CheckBoxHighLevelKillMonFixExpClick
        end
        object CheckBoxHighLevelGroupFixExp: TCheckBox
          Left = 11
          Top = 64
          Width = 131
          Height = 17
          Hint = 'Experience the same high level of killing'
          Caption = 'EXP same Hi-Lvl Team'
          TabOrder = 2
          OnClick = CheckBoxHighLevelGroupFixExpClick
        end
      end
      object ButtonExpSave: TButton
        Left = 411
        Top = 184
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 1
        OnClick = ButtonExpSaveClick
      end
      object GroupBoxLevelExp: TGroupBox
        Left = 9
        Top = 8
        Width = 169
        Height = 200
        Caption = 'Upgrade Experience'
        TabOrder = 2
        object Label37: TLabel
          Left = 11
          Top = 176
          Width = 24
          Height = 13
          Caption = 'Plan:'
        end
        object ComboBoxLevelExp: TComboBox
          Left = 48
          Top = 173
          Width = 113
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 0
          OnClick = ComboBoxLevelExpClick
        end
        object GridLevelExp: TStringGrid
          Left = 8
          Top = 16
          Width = 153
          Height = 151
          ColCount = 2
          DefaultRowHeight = 18
          RowCount = 1001
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing]
          TabOrder = 1
          OnSetEditText = GridLevelExpSetEditText
          ColWidths = (
            64
            67)
          RowHeights = (
            18
            18
            19
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18
            18)
        end
      end
      object GroupBox74: TGroupBox
        Left = 335
        Top = 90
        Width = 143
        Height = 89
        Caption = 'After XP Prep of 1000'
        TabOrder = 3
        object Label15: TLabel
          Left = 6
          Top = 40
          Width = 53
          Height = 13
          Caption = 'Basic EXP:'
        end
        object Label145: TLabel
          Left = 6
          Top = 64
          Width = 49
          Height = 13
          Caption = 'Gain EXP:'
        end
        object CheckBoxFixExp: TCheckBox
          Left = 6
          Top = 16
          Width = 128
          Height = 17
          Caption = 'Internal Eng Fixed XP'
          TabOrder = 0
          OnClick = CheckBoxFixExpClick
        end
        object SpinEditBaseExp: TSpinEdit
          Left = 62
          Top = 36
          Width = 76
          Height = 22
          Hint = 'People basic experience'
          MaxValue = 2100000000
          MinValue = 0
          TabOrder = 1
          Value = 100000000
          OnChange = SpinEditBaseExpChange
        end
        object SpinEditAddExp: TSpinEdit
          Left = 62
          Top = 62
          Width = 76
          Height = 22
          Hint = 'Experience increments upgrade'
          MaxValue = 2100000000
          MinValue = 0
          TabOrder = 2
          Value = 1000000
          OnChange = SpinEditAddExpChange
        end
      end
      object GroupBox75: TGroupBox
        Left = 335
        Top = 8
        Width = 143
        Height = 75
        Caption = 'Level Limit'
        TabOrder = 4
        object Label146: TLabel
          Left = 8
          Top = 24
          Width = 56
          Height = 13
          Caption = 'Restrict Lvl:'
        end
        object Label147: TLabel
          Left = 8
          Top = 48
          Width = 56
          Height = 13
          Caption = 'Restrict XP:'
        end
        object Label155: TLabel
          Left = 120
          Top = 47
          Width = 8
          Height = 13
          Caption = '%'
        end
        object SpinEditLimitExpLevel: TSpinEdit
          Left = 64
          Top = 20
          Width = 65
          Height = 22
          Hint = 
            'When the level exceeds the level set value, the value obtained b' +
            'y the following set of experiences'
          EditorEnabled = False
          MaxValue = 65535
          MinValue = 1
          TabOrder = 0
          Value = 1000
          OnChange = SpinEditLimitExpLevelChange
        end
        object SpinEditLimitExpValue: TSpinEdit
          Left = 64
          Top = 43
          Width = 50
          Height = 22
          Hint = 
            'After the limit is reached proportions specified level of experi' +
            'ence gained Shaguai'
          EditorEnabled = False
          MaxValue = 100
          MinValue = 0
          TabOrder = 1
          Value = 1
          OnChange = SpinEditLimitExpValueChange
        end
      end
      object GroupBox80: TGroupBox
        Left = 184
        Top = 99
        Width = 145
        Height = 94
        Caption = 'EXP Low-Level '
        TabOrder = 5
        object Label158: TLabel
          Left = 6
          Top = 40
          Width = 77
          Height = 13
          Caption = 'Lowe then Mon:'
        end
        object Label159: TLabel
          Left = 6
          Top = 64
          Width = 86
          Height = 13
          Caption = 'Proport Gain EXP:'
        end
        object CheckBoxLowLevelKillMonContainExp: TCheckBox
          Left = 6
          Top = 16
          Width = 136
          Height = 17
          Hint = 
            'Whether to open when the monster character level is below the sp' +
            'ecified level of experience to get the ratio changes!'
          Caption = 'Enable Low-Lvl Kill Ctrl'
          TabOrder = 0
          OnClick = CheckBoxLowLevelKillMonContainExpClick
        end
        object EditLowLevelKillMonLevel: TSpinEdit
          Left = 88
          Top = 36
          Width = 51
          Height = 22
          MaxValue = 65535
          MinValue = 0
          TabOrder = 1
          Value = 0
          OnChange = EditLowLevelKillMonLevelChange
        end
        object EditLowLevelKillMonGetExpRate: TSpinEdit
          Left = 88
          Top = 61
          Width = 51
          Height = 22
          Hint = 
            'The current setting value divided by 100 is the actual multiple,' +
            ' 100 = 1 times (unchanged)'
          MaxValue = 65535
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditLowLevelKillMonGetExpRateChange
        end
      end
    end
    object CastleSheet: TTabSheet
      Caption = 'Castle Parameters'
      ImageIndex = 3
      object GroupBox9: TGroupBox
        Left = 8
        Top = 8
        Width = 161
        Height = 113
        Caption = 'Fee Income'
        TabOrder = 0
        object Label24: TLabel
          Left = 11
          Top = 16
          Width = 60
          Height = 13
          Caption = 'Repair Gate:'
        end
        object Label25: TLabel
          Left = 11
          Top = 40
          Width = 58
          Height = 13
          Caption = 'Repair Wall:'
        end
        object Label26: TLabel
          Left = 11
          Top = 64
          Width = 39
          Height = 13
          Caption = 'Archers:'
        end
        object Label27: TLabel
          Left = 11
          Top = 88
          Width = 37
          Height = 13
          Caption = 'Guards:'
        end
        object EditRepairDoorPrice: TSpinEdit
          Left = 72
          Top = 12
          Width = 81
          Height = 22
          Increment = 10000
          MaxValue = 100000000
          MinValue = 10000
          TabOrder = 0
          Value = 2000000
          OnChange = EditRepairDoorPriceChange
        end
        object EditRepairWallPrice: TSpinEdit
          Left = 72
          Top = 36
          Width = 81
          Height = 22
          Increment = 10000
          MaxValue = 100000000
          MinValue = 10000
          TabOrder = 1
          Value = 500000
          OnChange = EditRepairWallPriceChange
        end
        object EditHireArcherPrice: TSpinEdit
          Left = 72
          Top = 60
          Width = 81
          Height = 22
          Increment = 10000
          MaxValue = 100000000
          MinValue = 10000
          TabOrder = 2
          Value = 300000
          OnChange = EditHireArcherPriceChange
        end
        object EditHireGuardPrice: TSpinEdit
          Left = 72
          Top = 84
          Width = 81
          Height = 22
          Increment = 10000
          MaxValue = 100000000
          MinValue = 10000
          TabOrder = 3
          Value = 300000
          OnChange = EditHireGuardPriceChange
        end
      end
      object GroupBox10: TGroupBox
        Left = 8
        Top = 125
        Width = 161
        Height = 68
        Caption = 'Gold Cap'
        TabOrder = 1
        object Label31: TLabel
          Left = 11
          Top = 20
          Width = 32
          Height = 13
          Caption = 'Funds:'
        end
        object Label32: TLabel
          Left = 11
          Top = 44
          Width = 60
          Height = 13
          Caption = 'Day Income:'
        end
        object EditCastleGoldMax: TSpinEdit
          Left = 72
          Top = 16
          Width = 81
          Height = 22
          Increment = 10000
          MaxValue = 100000000
          MinValue = 10000
          TabOrder = 0
          Value = 10000000
          OnChange = EditCastleGoldMaxChange
        end
        object EditCastleOneDayGold: TSpinEdit
          Left = 72
          Top = 40
          Width = 81
          Height = 22
          Increment = 10000
          MaxValue = 100000000
          MinValue = 10000
          TabOrder = 1
          Value = 2000000
          OnChange = EditCastleOneDayGoldChange
        end
      end
      object GroupBox11: TGroupBox
        Left = 296
        Top = 58
        Width = 121
        Height = 87
        Caption = 'Back to City'
        TabOrder = 2
        object Label28: TLabel
          Left = 11
          Top = 16
          Width = 24
          Height = 13
          Caption = 'Map:'
        end
        object Label29: TLabel
          Left = 11
          Top = 40
          Width = 41
          Height = 13
          Caption = 'Coord X:'
        end
        object Label30: TLabel
          Left = 11
          Top = 64
          Width = 41
          Height = 13
          Caption = 'Coord Y:'
        end
        object EditCastleHomeX: TSpinEdit
          Left = 56
          Top = 36
          Width = 57
          Height = 22
          MaxValue = 1000
          MinValue = 1
          TabOrder = 0
          Value = 644
          OnChange = EditCastleHomeXChange
        end
        object EditCastleHomeY: TSpinEdit
          Left = 56
          Top = 60
          Width = 57
          Height = 22
          MaxValue = 1000
          MinValue = 1
          TabOrder = 1
          Value = 290
          OnChange = EditCastleHomeYChange
        end
        object EditCastleHomeMap: TEdit
          Left = 56
          Top = 12
          Width = 57
          Height = 21
          MaxLength = 20
          TabOrder = 2
          Text = '3'
          OnChange = EditCastleHomeMapChange
        end
      end
      object GroupBox12: TGroupBox
        Left = 176
        Top = 8
        Width = 113
        Height = 63
        Caption = 'Siege Regional'
        TabOrder = 3
        object Label34: TLabel
          Left = 11
          Top = 16
          Width = 41
          Height = 13
          Caption = 'Coord X:'
        end
        object Label35: TLabel
          Left = 11
          Top = 40
          Width = 41
          Height = 13
          Caption = 'Coord Y:'
        end
        object EditWarRangeX: TSpinEdit
          Left = 56
          Top = 12
          Width = 49
          Height = 22
          MaxValue = 1000
          MinValue = 1
          TabOrder = 0
          Value = 100
          OnChange = EditWarRangeXChange
        end
        object EditWarRangeY: TSpinEdit
          Left = 56
          Top = 36
          Width = 49
          Height = 22
          MaxValue = 1000
          MinValue = 1
          TabOrder = 1
          Value = 100
          OnChange = EditWarRangeYChange
        end
      end
      object ButtonCastleSave: TButton
        Left = 411
        Top = 184
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 4
        OnClick = ButtonCastleSaveClick
      end
      object GroupBox13: TGroupBox
        Left = 176
        Top = 74
        Width = 113
        Height = 63
        Caption = 'Tax'
        TabOrder = 5
        object Label36: TLabel
          Left = 11
          Top = 40
          Width = 26
          Height = 13
          Caption = 'Rate:'
        end
        object EditTaxRate: TSpinEdit
          Left = 56
          Top = 36
          Width = 49
          Height = 22
          MaxValue = 1000
          MinValue = 1
          TabOrder = 0
          Value = 5
          OnChange = EditTaxRateChange
        end
        object CheckBoxGetAllNpcTax: TCheckBox
          Left = 11
          Top = 13
          Width = 99
          Height = 17
          Caption = 'All NPC pay Tax'
          TabOrder = 1
          OnClick = CheckBoxGetAllNpcTaxClick
        end
      end
      object GroupBox14: TGroupBox
        Left = 296
        Top = 8
        Width = 121
        Height = 44
        Caption = 'Castle Name'
        TabOrder = 6
        object Label33: TLabel
          Left = 8
          Top = 20
          Width = 31
          Height = 13
          Caption = 'Name:'
        end
        object EditCastleName: TEdit
          Left = 40
          Top = 16
          Width = 73
          Height = 21
          TabOrder = 0
          Text = 'Sabuk'
          OnChange = EditCastleNameChange
        end
      end
      object GroupBox54: TGroupBox
        Left = 176
        Top = 146
        Width = 113
        Height = 47
        Caption = 'Member Discount'
        TabOrder = 7
        object Label107: TLabel
          Left = 11
          Top = 16
          Width = 26
          Height = 13
          Caption = 'Rate:'
        end
        object EditCastleMemberPriceRate: TSpinEdit
          Left = 56
          Top = 12
          Width = 49
          Height = 22
          Hint = 
            'Castle guild members to purchase items price discounts. Digital ' +
            'is a few percent.'
          MaxValue = 200
          MinValue = 10
          TabOrder = 0
          Value = 10
          OnChange = EditCastleMemberPriceRateChange
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Information Control'
      ImageIndex = 8
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox36: TGroupBox
        Left = 8
        Top = 8
        Width = 129
        Height = 73
        Caption = 'Send Msg Length'
        TabOrder = 0
        object Label71: TLabel
          Left = 11
          Top = 24
          Width = 48
          Height = 13
          Caption = 'Chat Msg:'
        end
        object Label72: TLabel
          Left = 11
          Top = 48
          Width = 51
          Height = 13
          Caption = 'Broadcast:'
        end
        object EditSayMsgMaxLen: TSpinEdit
          Left = 68
          Top = 20
          Width = 53
          Height = 22
          Hint = 'The maximum length of a text message sent.'
          MaxValue = 255
          MinValue = 1
          TabOrder = 0
          Value = 50
          OnChange = EditSayMsgMaxLenChange
        end
        object EditSayRedMsgMaxLen: TSpinEdit
          Left = 68
          Top = 44
          Width = 53
          Height = 22
          Hint = 'GM maximum length of the red teletext.'
          MaxValue = 255
          MinValue = 1
          TabOrder = 1
          Value = 50
          OnChange = EditSayRedMsgMaxLenChange
        end
      end
      object GroupBox37: TGroupBox
        Left = 8
        Top = 88
        Width = 129
        Height = 49
        Caption = 'Allow Shout Level'
        TabOrder = 1
        object Label73: TLabel
          Left = 11
          Top = 24
          Width = 29
          Height = 13
          Caption = 'Level:'
        end
        object EditCanShoutMsgLevel: TSpinEdit
          Left = 68
          Top = 20
          Width = 53
          Height = 22
          Hint = 
            'Before allowing propaganda levels, characters must reach the spe' +
            'cified level can be propaganda.'
          MaxValue = 65535
          MinValue = 1
          TabOrder = 0
          Value = 50
          OnChange = EditCanShoutMsgLevelChange
        end
      end
      object GroupBox38: TGroupBox
        Left = 144
        Top = 8
        Width = 137
        Height = 73
        Caption = 'BroadCast Info transmitted'
        TabOrder = 2
        object Label75: TLabel
          Left = 11
          Top = 40
          Width = 52
          Height = 13
          Caption = 'Send Cmd:'
        end
        object CheckBoxShutRedMsgShowGMName: TCheckBox
          Left = 8
          Top = 16
          Width = 105
          Height = 17
          Hint = 
            'Whether to display the names of the characters in red when GM se' +
            'nt a broadcast file information.'
          Caption = 'Show Character'
          TabOrder = 0
          OnClick = CheckBoxShutRedMsgShowGMNameClick
        end
        object EditGMRedMsgCmd: TEdit
          Left = 72
          Top = 37
          Width = 41
          Height = 21
          Hint = #21457#36865#32418#33394#24191#25773#25991#20214#20449#24687#21629#20196#31526#12290#40664#35748#20026#8216'!'#8217#12290
          MaxLength = 20
          TabOrder = 1
          OnChange = EditGMRedMsgCmdChange
        end
      end
      object ButtonMsgSave: TButton
        Left = 411
        Top = 184
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 3
        OnClick = ButtonMsgSaveClick
      end
      object GroupBox68: TGroupBox
        Left = 143
        Top = 88
        Width = 154
        Height = 105
        Caption = 'Send Msg Speed Ctrl'
        TabOrder = 4
        object Label135: TLabel
          Left = 11
          Top = 24
          Width = 62
          Height = 13
          Caption = 'Transmisson:'
        end
        object Label138: TLabel
          Left = 11
          Top = 48
          Width = 68
          Height = 13
          Caption = 'Send Number:'
        end
        object Label139: TLabel
          Left = 11
          Top = 72
          Width = 49
          Height = 13
          Caption = 'Gag Time:'
        end
        object Label140: TLabel
          Left = 131
          Top = 24
          Width = 19
          Height = 13
          Caption = 'Sec'
        end
        object Label141: TLabel
          Left = 131
          Top = 71
          Width = 19
          Height = 13
          Caption = 'Sec'
        end
        object EditSayMsgTime: TSpinEdit
          Left = 79
          Top = 20
          Width = 45
          Height = 22
          MaxValue = 1000000
          MinValue = 1
          TabOrder = 0
          Value = 50
          OnChange = EditSayMsgTimeChange
        end
        object EditSayMsgCount: TSpinEdit
          Left = 79
          Top = 43
          Width = 45
          Height = 22
          MaxValue = 255
          MinValue = 1
          TabOrder = 1
          Value = 50
          OnChange = EditSayMsgCountChange
        end
        object EditDisableSayMsgTime: TSpinEdit
          Left = 79
          Top = 68
          Width = 45
          Height = 22
          MaxValue = 100000
          MinValue = 1
          TabOrder = 2
          Value = 50
          OnChange = EditDisableSayMsgTimeChange
        end
      end
      object GroupBox71: TGroupBox
        Left = 8
        Top = 144
        Width = 129
        Height = 49
        Caption = 'Show Prefix Info'
        TabOrder = 5
        object CheckBoxShowPreFixMsg: TCheckBox
          Left = 8
          Top = 16
          Width = 105
          Height = 17
          Hint = 
            'Information-game chat box displays whether to display the prefix' +
            ' information.'
          Caption = 'Show Prefix'
          TabOrder = 0
          OnClick = CheckBoxShowPreFixMsgClick
        end
      end
    end
    object TabSheet8: TTabSheet
      Caption = 'Text Color'
      ImageIndex = 11
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ButtonMsgColorSave: TButton
        Left = 411
        Top = 184
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 0
        OnClick = ButtonMsgColorSaveClick
      end
      object GroupBox55: TGroupBox
        Left = 8
        Top = 8
        Width = 105
        Height = 63
        Caption = 'Chat'
        TabOrder = 1
        object Label108: TLabel
          Left = 11
          Top = 16
          Width = 24
          Height = 13
          Caption = 'Text:'
        end
        object Label109: TLabel
          Left = 11
          Top = 40
          Width = 18
          Height = 13
          Caption = 'BG:'
        end
        object LabeltHearMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelHearMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditHearMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditHearMsgFColorChange
        end
        object EdittHearMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EdittHearMsgBColorChange
        end
      end
      object GroupBox56: TGroupBox
        Left = 8
        Top = 75
        Width = 105
        Height = 63
        Caption = 'Whisper'
        TabOrder = 2
        object Label110: TLabel
          Left = 7
          Top = 17
          Width = 24
          Height = 13
          Caption = 'Text:'
        end
        object Label111: TLabel
          Left = 11
          Top = 40
          Width = 18
          Height = 13
          Caption = 'BG:'
        end
        object LabelWhisperMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelWhisperMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditWhisperMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditWhisperMsgFColorChange
        end
        object EditWhisperMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditWhisperMsgBColorChange
        end
      end
      object GroupBox57: TGroupBox
        Left = 8
        Top = 143
        Width = 105
        Height = 63
        Caption = 'GM Whisper'
        TabOrder = 3
        object Label112: TLabel
          Left = 11
          Top = 16
          Width = 24
          Height = 13
          Caption = 'Text:'
        end
        object Label113: TLabel
          Left = 11
          Top = 40
          Width = 18
          Height = 13
          Caption = 'BG:'
        end
        object LabelGMWhisperMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelGMWhisperMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditGMWhisperMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditGMWhisperMsgFColorChange
        end
        object EditGMWhisperMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditGMWhisperMsgBColorChange
        end
      end
      object GroupBox58: TGroupBox
        Left = 120
        Top = 8
        Width = 105
        Height = 63
        Caption = 'Red Prompt'
        TabOrder = 4
        object Label116: TLabel
          Left = 11
          Top = 16
          Width = 24
          Height = 13
          Caption = 'Text:'
        end
        object Label117: TLabel
          Left = 11
          Top = 40
          Width = 18
          Height = 13
          Caption = 'BG:'
        end
        object LabelRedMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelRedMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditRedMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditRedMsgFColorChange
        end
        object EditRedMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditRedMsgBColorChange
        end
      end
      object GroupBox59: TGroupBox
        Left = 120
        Top = 75
        Width = 105
        Height = 63
        Caption = 'Green Prompt'
        TabOrder = 5
        object Label120: TLabel
          Left = 11
          Top = 16
          Width = 24
          Height = 13
          Caption = 'Text:'
        end
        object Label121: TLabel
          Left = 11
          Top = 40
          Width = 18
          Height = 13
          Caption = 'BG:'
        end
        object LabelGreenMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelGreenMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditGreenMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditGreenMsgFColorChange
        end
        object EditGreenMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditGreenMsgBColorChange
        end
      end
      object GroupBox60: TGroupBox
        Left = 120
        Top = 143
        Width = 105
        Height = 63
        Caption = 'Blue Prompt'
        TabOrder = 6
        object Label124: TLabel
          Left = 11
          Top = 16
          Width = 24
          Height = 13
          Caption = 'Text:'
        end
        object Label125: TLabel
          Left = 11
          Top = 40
          Width = 18
          Height = 13
          Caption = 'BG:'
        end
        object LabelBlueMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelBlueMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditBlueMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditBlueMsgFColorChange
        end
        object EditBlueMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditBlueMsgBColorChange
        end
      end
      object GroupBox61: TGroupBox
        Left = 232
        Top = 8
        Width = 105
        Height = 63
        Caption = 'Shout'
        TabOrder = 7
        object Label128: TLabel
          Left = 11
          Top = 16
          Width = 24
          Height = 13
          Caption = 'Text:'
        end
        object Label129: TLabel
          Left = 11
          Top = 40
          Width = 18
          Height = 13
          Caption = 'BG:'
        end
        object LabelCryMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelCryMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditCryMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditCryMsgFColorChange
        end
        object EditCryMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditCryMsgBColorChange
        end
      end
      object GroupBox62: TGroupBox
        Left = 232
        Top = 75
        Width = 105
        Height = 63
        Caption = 'Guild'
        TabOrder = 8
        object Label132: TLabel
          Left = 11
          Top = 16
          Width = 24
          Height = 13
          Caption = 'Text:'
        end
        object Label133: TLabel
          Left = 11
          Top = 40
          Width = 18
          Height = 13
          Caption = 'BG:'
        end
        object LabelGuildMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelGuildMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditGuildMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditGuildMsgFColorChange
        end
        object EditGuildMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditGuildMsgBColorChange
        end
      end
      object GroupBox63: TGroupBox
        Left = 232
        Top = 143
        Width = 105
        Height = 63
        Caption = 'Group'
        TabOrder = 9
        object Label136: TLabel
          Left = 11
          Top = 16
          Width = 24
          Height = 13
          Caption = 'Text:'
        end
        object Label137: TLabel
          Left = 11
          Top = 40
          Width = 18
          Height = 13
          Caption = 'BG:'
        end
        object LabelGroupMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelGroupMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditGroupMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditGroupMsgFColorChange
        end
        object EditGroupMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditGroupMsgBColorChange
        end
      end
      object GroupBox65: TGroupBox
        Left = 344
        Top = 8
        Width = 105
        Height = 63
        Caption = 'Greetings'
        TabOrder = 10
        object Label122: TLabel
          Left = 11
          Top = 16
          Width = 24
          Height = 13
          Caption = 'Text:'
        end
        object Label123: TLabel
          Left = 11
          Top = 40
          Width = 18
          Height = 13
          Caption = 'BG:'
        end
        object LabelCustMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelCustMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditCustMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditCustMsgFColorChange
        end
        object EditCustMsgBColor: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditCustMsgBColorChange
        end
      end
      object GroupBox77: TGroupBox
        Left = 344
        Top = 75
        Width = 105
        Height = 62
        Caption = #21315#37324#20256#38899
        TabOrder = 11
        object Label149: TLabel
          Left = 11
          Top = 16
          Width = 24
          Height = 13
          Caption = 'Text:'
        end
        object Label150: TLabel
          Left = 11
          Top = 40
          Width = 18
          Height = 13
          Caption = 'BG:'
        end
        object LabelCudtMsgFColor: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object LabelCudtMsgBColor: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditCudtMsgFColor: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditCudtMsgFColorChange
        end
        object EditCudtMsgBColor: TSpinEdit
          Left = 40
          Top = 37
          Width = 41
          Height = 22
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditCudtMsgBColorChange
        end
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Time Control'
      ImageIndex = 9
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox39: TGroupBox
        Left = 8
        Top = 8
        Width = 105
        Height = 49
        Caption = 'Siege Days(APP)'
        TabOrder = 0
        object Label74: TLabel
          Left = 11
          Top = 24
          Width = 27
          Height = 13
          Caption = 'Days:'
        end
        object Label77: TLabel
          Left = 83
          Top = 24
          Width = 3
          Height = 13
        end
        object EditStartCastleWarDays: TSpinEdit
          Left = 44
          Top = 20
          Width = 37
          Height = 22
          Hint = 
            'The number of days required to apply the siege, including the da' +
            'y.'
          MaxValue = 10
          MinValue = 2
          TabOrder = 0
          Value = 4
          OnChange = EditStartCastleWarDaysChange
        end
      end
      object GroupBox40: TGroupBox
        Left = 8
        Top = 64
        Width = 105
        Height = 49
        Caption = 'Siege Start Time'
        TabOrder = 1
        object Label76: TLabel
          Left = 11
          Top = 24
          Width = 26
          Height = 13
          Caption = 'Time:'
        end
        object Label78: TLabel
          Left = 83
          Top = 24
          Width = 24
          Height = 13
          Caption = 'Point'
        end
        object EditStartCastlewarTime: TSpinEdit
          Left = 44
          Top = 20
          Width = 37
          Height = 22
          Hint = 'Began the siege time, 20 representatives of 20:00'
          MaxValue = 24
          MinValue = 1
          TabOrder = 0
          Value = 20
          OnChange = EditStartCastlewarTimeChange
        end
      end
      object GroupBox41: TGroupBox
        Left = 8
        Top = 119
        Width = 105
        Height = 44
        Caption = 'Siege End'
        TabOrder = 2
        object Label79: TLabel
          Left = 11
          Top = 20
          Width = 26
          Height = 13
          Caption = 'Time:'
        end
        object Label80: TLabel
          Left = 83
          Top = 20
          Width = 24
          Height = 13
          Caption = 'Point'
        end
        object EditShowCastleWarEndMsgTime: TSpinEdit
          Left = 44
          Top = 16
          Width = 37
          Height = 22
          Hint = 'Specified time before the end of the siege warfare tips.'
          MaxValue = 6000000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditShowCastleWarEndMsgTimeChange
        end
      end
      object GroupBox42: TGroupBox
        Left = 120
        Top = 8
        Width = 113
        Height = 49
        Caption = 'Siege Time'
        TabOrder = 3
        object Label81: TLabel
          Left = 3
          Top = 24
          Width = 36
          Height = 13
          Caption = 'Length:'
        end
        object Label82: TLabel
          Left = 86
          Top = 24
          Width = 24
          Height = 13
          Caption = 'Point'
        end
        object EditCastleWarTime: TSpinEdit
          Left = 40
          Top = 24
          Width = 45
          Height = 22
          Hint = 'Siege length of time, the default is 3 hours.'
          MaxValue = 6000000
          MinValue = 1
          TabOrder = 0
          Value = 180
          OnChange = EditCastleWarTimeChange
        end
      end
      object GroupBox43: TGroupBox
        Left = 120
        Top = 64
        Width = 105
        Height = 49
        Caption = 'Prohibit Occupation'
        TabOrder = 4
        object Label83: TLabel
          Left = 11
          Top = 24
          Width = 36
          Height = 13
          Caption = 'Length:'
        end
        object Label84: TLabel
          Left = 83
          Top = 24
          Width = 29
          Height = 13
          Caption = 'Points'
        end
        object EditGetCastleTime: TSpinEdit
          Left = 43
          Top = 20
          Width = 37
          Height = 22
          Hint = 
            'When the siege began, the occupation is not allowed within a spe' +
            'cified time.'
          MaxValue = 6000000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditGetCastleTimeChange
        end
      end
      object GroupBox44: TGroupBox
        Left = 239
        Top = 9
        Width = 105
        Height = 49
        Caption = 'Char Data Storage'
        TabOrder = 5
        object Label85: TLabel
          Left = 11
          Top = 24
          Width = 36
          Height = 13
          Caption = 'Length:'
        end
        object Label86: TLabel
          Left = 83
          Top = 24
          Width = 24
          Height = 13
          Caption = 'Point'
        end
        object EditSaveHumanRcdTime: TSpinEdit
          Left = 44
          Top = 20
          Width = 37
          Height = 22
          Hint = 'Character data is automatically saved interval'
          MaxValue = 6000000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditSaveHumanRcdTimeChange
        end
      end
      object GroupBox45: TGroupBox
        Left = 352
        Top = 8
        Width = 112
        Height = 49
        Caption = 'PPL Quit Release'
        TabOrder = 6
        object Label87: TLabel
          Left = 11
          Top = 24
          Width = 36
          Height = 13
          Caption = 'Length:'
        end
        object Label88: TLabel
          Left = 83
          Top = 24
          Width = 24
          Height = 13
          Caption = 'Point'
        end
        object EditHumanFreeDelayTime: TSpinEdit
          Left = 44
          Top = 20
          Width = 37
          Height = 22
          Hint = 
            'People back after a specified time release time, this time not t' +
            'oo short, it may cause errors.'
          Enabled = False
          MaxValue = 6000000
          MinValue = 1
          TabOrder = 0
          Value = 5
          OnChange = EditHumanFreeDelayTimeChange
        end
      end
      object GroupBox46: TGroupBox
        Left = 119
        Top = 119
        Width = 345
        Height = 44
        Caption = 'Clean Up Time'
        TabOrder = 7
        object Label89: TLabel
          Left = 121
          Top = 20
          Width = 30
          Height = 13
          Caption = '  Mon:'
        end
        object Label90: TLabel
          Left = 211
          Top = 20
          Width = 19
          Height = 13
          Caption = 'Sec'
        end
        object Label91: TLabel
          Left = 236
          Top = 20
          Width = 28
          Height = 13
          Caption = 'Items:'
        end
        object Label92: TLabel
          Left = 324
          Top = 20
          Width = 19
          Height = 13
          Caption = 'Sec'
        end
        object Label154: TLabel
          Left = 86
          Top = 20
          Width = 29
          Height = 13
          Caption = 'Points'
        end
        object Label153: TLabel
          Left = 9
          Top = 20
          Width = 23
          Height = 13
          Caption = 'PPL:'
        end
        object EditMakeGhostTime: TSpinEdit
          Left = 156
          Top = 15
          Width = 53
          Height = 22
          Hint = 'Clear the ground monster dead time.'
          MaxValue = 6000000
          MinValue = 1
          TabOrder = 0
          Value = 180
          OnChange = EditMakeGhostTimeChange
        end
        object EditClearDropOnFloorItemTime: TSpinEdit
          Left = 269
          Top = 16
          Width = 53
          Height = 22
          Hint = 'Time to clear the ground items'
          MaxValue = 6000000
          MinValue = 1
          TabOrder = 1
          Value = 3600
          OnChange = EditClearDropOnFloorItemTimeChange
        end
        object EditHumDieMaxTime: TSpinEdit
          Left = 41
          Top = 16
          Width = 45
          Height = 22
          Hint = 'People clean up time after death.'
          EditorEnabled = False
          MaxValue = 65535
          MinValue = 1
          TabOrder = 2
          Value = 120
          OnChange = EditHumDieMaxTimeChange
        end
      end
      object GroupBox47: TGroupBox
        Left = 232
        Top = 64
        Width = 113
        Height = 49
        Caption = 'Explosive can Pickup'
        TabOrder = 8
        object Label93: TLabel
          Left = 11
          Top = 24
          Width = 36
          Height = 13
          Caption = 'Length:'
        end
        object Label94: TLabel
          Left = 91
          Top = 24
          Width = 19
          Height = 13
          Caption = 'Sec'
        end
        object EditFloorItemCanPickUpTime: TSpinEdit
          Left = 44
          Top = 20
          Width = 45
          Height = 22
          Hint = 
            'Others blasting monsters or items can be picked up off the groun' +
            'd intervals.'
          MaxValue = 6000000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditFloorItemCanPickUpTimeChange
        end
      end
      object ButtonTimeSave: TButton
        Left = 411
        Top = 184
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 9
        OnClick = ButtonTimeSaveClick
      end
      object GroupBox70: TGroupBox
        Left = 352
        Top = 64
        Width = 113
        Height = 49
        Caption = 'Guild WarTime Long'
        TabOrder = 10
        object Label143: TLabel
          Left = 11
          Top = 24
          Width = 36
          Height = 13
          Caption = 'Length:'
        end
        object Label144: TLabel
          Left = 91
          Top = 24
          Width = 29
          Height = 13
          Caption = 'Points'
        end
        object EditGuildWarTime: TSpinEdit
          Left = 44
          Top = 20
          Width = 45
          Height = 22
          Hint = 'Line of battle length of time.'
          MaxValue = 6000000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditGuildWarTimeChange
        end
      end
      object GroupBox79: TGroupBox
        Left = 9
        Top = 168
        Width = 128
        Height = 44
        Caption = 'Yao Time Control'
        TabOrder = 11
        object Label156: TLabel
          Left = 11
          Top = 20
          Width = 26
          Height = 13
          Caption = 'Time:'
        end
        object Label157: TLabel
          Left = 97
          Top = 20
          Width = 14
          Height = 13
          Caption = 'Ms'
        end
        object EditEatTick: TSpinEdit
          Left = 44
          Top = 16
          Width = 50
          Height = 22
          Hint = 'Specify the use of drugs class interval of 0 is not restricted.'
          MaxValue = 6000000
          MinValue = 0
          TabOrder = 0
          Value = 10
          OnChange = EditEatTickChange
        end
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'Cost'
      ImageIndex = 10
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox48: TGroupBox
        Left = 8
        Top = 8
        Width = 137
        Height = 49
        Caption = 'Fees Apply for Guild'
        TabOrder = 0
        object Label95: TLabel
          Left = 11
          Top = 24
          Width = 29
          Height = 13
          Caption = 'Costs:'
        end
        object EditBuildGuildPrice: TSpinEdit
          Left = 44
          Top = 20
          Width = 77
          Height = 22
          Hint = 'Create a guild application cost.'
          MaxValue = 100000000
          MinValue = 1000
          TabOrder = 0
          Value = 1000000
          OnChange = EditBuildGuildPriceChange
        end
      end
      object GroupBox49: TGroupBox
        Left = 8
        Top = 64
        Width = 137
        Height = 49
        Caption = 'Fees Apply for Battle'
        TabOrder = 1
        object Label96: TLabel
          Left = 11
          Top = 24
          Width = 29
          Height = 13
          Caption = 'Costs:'
        end
        object EditGuildWarPrice: TSpinEdit
          Left = 44
          Top = 20
          Width = 77
          Height = 22
          Hint = 'The required application fee for Guild Wars.'
          MaxValue = 100000000
          MinValue = 1000
          TabOrder = 0
          Value = 30000
          OnChange = EditGuildWarPriceChange
        end
      end
      object GroupBox50: TGroupBox
        Left = 8
        Top = 120
        Width = 137
        Height = 49
        Caption = 'Lian Drug Prices'
        TabOrder = 2
        object Label97: TLabel
          Left = 11
          Top = 24
          Width = 27
          Height = 13
          Caption = 'Price:'
        end
        object EditMakeDurgPrice: TSpinEdit
          Left = 44
          Top = 20
          Width = 77
          Height = 22
          Hint = 'The cost of refining drugs.'
          MaxValue = 100000000
          MinValue = 10
          TabOrder = 0
          Value = 100
          OnChange = EditMakeDurgPriceChange
        end
      end
      object ButtonPriceSave: TButton
        Left = 411
        Top = 184
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 3
        OnClick = ButtonPriceSaveClick
      end
      object GroupBox66: TGroupBox
        Left = 152
        Top = 8
        Width = 153
        Height = 73
        Caption = 'Repair Items'
        TabOrder = 4
        object Label126: TLabel
          Left = 11
          Top = 24
          Width = 84
          Height = 13
          Caption = 'SR Price Multiple:'
        end
        object Label127: TLabel
          Left = 11
          Top = 48
          Width = 87
          Height = 13
          Caption = 'Course Of Lasting:'
        end
        object EditSuperRepairPriceRate: TSpinEdit
          Left = 101
          Top = 20
          Width = 37
          Height = 22
          Hint = 'Special repair items price multiples, the default is three-fold.'
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 0
          Value = 3
          OnChange = EditSuperRepairPriceRateChange
        end
        object EditRepairItemDecDura: TSpinEdit
          Left = 101
          Top = 43
          Width = 41
          Height = 22
          Hint = 'Points out the persistence of ordinary repairs.'
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 1
          Value = 3
          OnChange = EditRepairItemDecDuraChange
        end
      end
    end
    object TabSheet9: TTabSheet
      Caption = 'People Died'
      ImageIndex = 12
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ButtonHumanDieSave: TButton
        Left = 411
        Top = 184
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 0
        OnClick = ButtonHumanDieSaveClick
      end
      object GroupBox67: TGroupBox
        Left = 8
        Top = 8
        Width = 197
        Height = 105
        Caption = 'Death Rules Out Items'
        TabOrder = 1
        object CheckBoxKillByMonstDropUseItem: TCheckBox
          Left = 8
          Top = 15
          Width = 121
          Height = 17
          Hint = 
            'When a character is killed monster will drop by drop upon the ch' +
            'ance to wear the items.'
          Caption = 'Equipped Monster Killed off'
          TabOrder = 0
          OnClick = CheckBoxKillByMonstDropUseItemClick
        end
        object CheckBoxKillByHumanDropUseItem: TCheckBox
          Left = 8
          Top = 32
          Width = 145
          Height = 17
          Hint = 
            'When a person is killed by someone else would drop him wear a ch' +
            'ance to drop items.'
          Caption = 'Char Killed off Equipment'
          TabOrder = 1
          OnClick = CheckBoxKillByHumanDropUseItemClick
        end
        object CheckBoxDieScatterBag: TCheckBox
          Left = 8
          Top = 48
          Width = 145
          Height = 17
          Hint = 'When a person died will drop by drop probability backpack items.'
          Caption = 'Death BackPack Items'
          TabOrder = 2
          OnClick = CheckBoxDieScatterBagClick
        end
        object CheckBoxDieDropGold: TCheckBox
          Left = 8
          Top = 64
          Width = 113
          Height = 17
          Hint = 'When a person who died will drop coins.'
          Caption = 'Death Drop Gold'
          TabOrder = 3
          OnClick = CheckBoxDieDropGoldClick
        end
        object CheckBoxDieRedScatterBagAll: TCheckBox
          Left = 8
          Top = 80
          Width = 186
          Height = 17
          Hint = 'Red backpack full name figures drop items when killed.'
          Caption = 'Red Name off all Backpack Items'
          TabOrder = 4
          OnClick = CheckBoxDieRedScatterBagAllClick
        end
      end
      object GroupBox69: TGroupBox
        Left = 211
        Top = 8
        Width = 265
        Height = 89
        Caption = 'Off Items Probability'
        TabOrder = 2
        object Label130: TLabel
          Left = 8
          Top = 18
          Width = 49
          Height = 13
          Caption = 'Fall Equip:'
        end
        object Label131: TLabel
          Left = 8
          Top = 42
          Width = 54
          Height = 13
          Caption = 'Red Name:'
        end
        object Label134: TLabel
          Left = 8
          Top = 66
          Width = 52
          Height = 13
          Caption = 'Backpack:'
        end
        object ScrollBarDieDropUseItemRate: TScrollBar
          Left = 64
          Top = 16
          Width = 145
          Height = 17
          Hint = 
            'People who wear the probability of death falling objects, and se' +
            't the smaller the number, the greater the probability.'
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarDieDropUseItemRateChange
        end
        object EditDieDropUseItemRate: TEdit
          Left = 216
          Top = 16
          Width = 41
          Height = 19
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarDieRedDropUseItemRate: TScrollBar
          Left = 64
          Top = 40
          Width = 145
          Height = 17
          Hint = 
            'Red name figures who died wearing the probability of falling obj' +
            'ects, set the smaller the number, the greater the probability.'
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarDieRedDropUseItemRateChange
        end
        object EditDieRedDropUseItemRate: TEdit
          Left = 216
          Top = 40
          Width = 41
          Height = 19
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarDieScatterBagRate: TScrollBar
          Left = 64
          Top = 64
          Width = 145
          Height = 17
          Hint = 
            'People loot death probability backpack, set the smaller the numb' +
            'er, the greater the probability.'
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarDieScatterBagRateChange
        end
        object EditDieScatterBagRate: TEdit
          Left = 216
          Top = 64
          Width = 41
          Height = 19
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
      end
    end
  end
end
