object frmFunctionConfig: TfrmFunctionConfig
  Left = 269
  Top = 149
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Feature Set'
  ClientHeight = 383
  ClientWidth = 471
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label14: TLabel
    Left = 8
    Top = 359
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
  object FunctionConfigControl: TPageControl
    Left = 6
    Top = 8
    Width = 457
    Height = 345
    ActivePage = TabSheet1
    MultiLine = True
    TabOrder = 0
    OnChanging = FunctionConfigControlChanging
    object TabSheetGeneral: TTabSheet
      Caption = 'Basic'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 42
      ExplicitWidth = 0
      ExplicitHeight = 299
      object ButtonGeneralSave: TButton
        Left = 368
        Top = 253
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 0
        OnClick = ButtonGeneralSaveClick
      end
      object GroupBox34: TGroupBox
        Left = 0
        Top = 4
        Width = 137
        Height = 163
        Caption = 'Name Color Display'
        TabOrder = 1
        object Label85: TLabel
          Left = 11
          Top = 22
          Width = 54
          Height = 12
          Caption = 'AtkState:'
        end
        object LabelPKFlagNameColor: TLabel
          Left = 112
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label87: TLabel
          Left = 11
          Top = 46
          Width = 66
          Height = 12
          Caption = 'NameStatus:'
        end
        object LabelPKLevel1NameColor: TLabel
          Left = 112
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label89: TLabel
          Left = 11
          Top = 70
          Width = 48
          Height = 12
          Caption = 'RedName:'
        end
        object LabelPKLevel2NameColor: TLabel
          Left = 112
          Top = 62
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label91: TLabel
          Left = 11
          Top = 94
          Width = 54
          Height = 12
          Caption = 'AlliaWar:'
        end
        object LabelAllyAndGuildNameColor: TLabel
          Left = 112
          Top = 86
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label93: TLabel
          Left = 11
          Top = 118
          Width = 60
          Height = 12
          Caption = 'HostilWar:'
        end
        object LabelWarGuildNameColor: TLabel
          Left = 112
          Top = 110
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label95: TLabel
          Left = 11
          Top = 142
          Width = 48
          Height = 12
          Caption = 'WarZone:'
        end
        object LabelInFreePKAreaNameColor: TLabel
          Left = 112
          Top = 134
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditPKFlagNameColor: TSpinEdit
          Left = 71
          Top = 19
          Width = 41
          Height = 21
          Hint = 'When people attack other people name colors, the default is 47'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditPKFlagNameColorChange
        end
        object EditPKLevel1NameColor: TSpinEdit
          Left = 71
          Top = 43
          Width = 41
          Height = 21
          Hint = 
            'When the characters PK point more than 100 points names of color' +
            's, the default is 251'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditPKLevel1NameColorChange
        end
        object EditPKLevel2NameColor: TSpinEdit
          Left = 71
          Top = 64
          Width = 41
          Height = 21
          Hint = 
            'When the characters PK point more than 200 points names of color' +
            's, the default is 249'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditPKLevel2NameColorChange
        end
        object EditAllyAndGuildNameColor: TSpinEdit
          Left = 71
          Top = 91
          Width = 41
          Height = 21
          Hint = 
            'When will the war character line, the Bank and Union Bank will b' +
            'e the name of the color of the characters, the default is 180'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditAllyAndGuildNameColorChange
        end
        object EditWarGuildNameColor: TSpinEdit
          Left = 71
          Top = 115
          Width = 41
          Height = 21
          Hint = 
            'When the character line will war, hostilities guild character na' +
            'me colors, the default is 69'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 4
          Value = 100
          OnChange = EditWarGuildNameColorChange
        end
        object EditInFreePKAreaNameColor: TSpinEdit
          Left = 71
          Top = 139
          Width = 41
          Height = 21
          Hint = 
            'When the character line character name will be war zone color, d' +
            'efault is 221'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 5
          Value = 100
          OnChange = EditInFreePKAreaNameColorChange
        end
      end
      object GroupBox62: TGroupBox
        Left = 164
        Top = 177
        Width = 198
        Height = 106
        Caption = 'Map Event Triggers'
        TabOrder = 2
        object chkStartDropItemMapEvent: TCheckBox
          Left = 11
          Top = 15
          Width = 174
          Height = 17
          Caption = 'Throwing Open Items Maps'
          TabOrder = 0
          OnClick = chkStartDropItemMapEventClick
        end
        object chkStartPickUpItemMapEvent: TCheckBox
          Left = 9
          Top = 33
          Width = 152
          Height = 17
          Caption = 'Pickup Items Map Event '
          TabOrder = 1
          OnClick = chkStartPickUpItemMapEventClick
        end
        object chkStartHeavyHitMapEvent: TCheckBox
          Left = 9
          Top = 50
          Width = 152
          Height = 17
          Caption = 'Open Mining Map Event'
          TabOrder = 2
          OnClick = chkStartHeavyHitMapEventClick
        end
        object chkStartWalkMapEvent: TCheckBox
          Left = 9
          Top = 67
          Width = 160
          Height = 17
          Caption = 'Open Walking Map Event'
          TabOrder = 3
          OnClick = chkStartWalkMapEventClick
        end
        object chkStartRunMapEvent: TCheckBox
          Left = 9
          Top = 84
          Width = 144
          Height = 17
          Caption = 'Open Running Map Event'
          TabOrder = 4
          OnClick = chkStartRunMapEventClick
        end
      end
      object GroupBox7: TGroupBox
        Left = 156
        Top = 8
        Width = 285
        Height = 163
        Caption = 'BloodStone / MagicBlood Stone Settings'
        TabOrder = 3
        object Label147: TLabel
          Left = 9
          Top = 22
          Width = 24
          Height = 12
          Caption = 'HP <'
        end
        object Label148: TLabel
          Left = 89
          Top = 22
          Width = 96
          Height = 12
          Caption = '% OpenBloodStone'
        end
        object Label149: TLabel
          Left = 239
          Top = 22
          Width = 18
          Height = 12
          Caption = 'Sec'
        end
        object Label150: TLabel
          Left = 9
          Top = 46
          Width = 126
          Height = 12
          Caption = 'HP is Incr BloodStone'
        end
        object Label151: TLabel
          Left = 203
          Top = 46
          Width = 6
          Height = 12
          Caption = '%'
        end
        object Label152: TLabel
          Left = 9
          Top = 94
          Width = 24
          Height = 12
          Caption = 'MP <'
        end
        object Label153: TLabel
          Left = 89
          Top = 94
          Width = 102
          Height = 12
          Caption = '% OpenMagicBlood:'
        end
        object Label154: TLabel
          Left = 239
          Top = 94
          Width = 18
          Height = 12
          Caption = 'Sec'
        end
        object Label155: TLabel
          Left = 207
          Top = 118
          Width = 6
          Height = 12
          Caption = '%'
        end
        object Label156: TLabel
          Left = 9
          Top = 118
          Width = 138
          Height = 12
          Caption = 'MP BloodStone Incr Last'
        end
        object Label157: TLabel
          Left = 207
          Top = 70
          Width = 30
          Height = 12
          Caption = 'Point'
        end
        object Label158: TLabel
          Left = 9
          Top = 70
          Width = 138
          Height = 12
          Caption = 'Every Stone ReduceValue'
        end
        object Label159: TLabel
          Left = 9
          Top = 142
          Width = 138
          Height = 12
          Caption = 'Every Stone ReduceValue'
        end
        object Label160: TLabel
          Left = 207
          Top = 142
          Width = 30
          Height = 12
          Caption = 'Point'
        end
        object SpinEditHPStoneStartRate: TSpinEdit
          Left = 43
          Top = 18
          Width = 43
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = SpinEditHPStoneStartRateChange
        end
        object SpinEditHPStoneIntervalTime: TSpinEdit
          Left = 197
          Top = 18
          Width = 39
          Height = 21
          EditorEnabled = False
          MaxValue = 100000
          MinValue = 0
          TabOrder = 1
          Value = 1
          OnChange = SpinEditHPStoneIntervalTimeChange
        end
        object SpinEditHPStoneAddRate: TSpinEdit
          Left = 146
          Top = 42
          Width = 55
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = SpinEditHPStoneAddRateChange
        end
        object SpinEditMPStoneStartRate: TSpinEdit
          Left = 43
          Top = 90
          Width = 43
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 4
          Value = 100
          OnChange = SpinEditMPStoneStartRateChange
        end
        object SpinEditMPStoneIntervalTime: TSpinEdit
          Left = 197
          Top = 90
          Width = 39
          Height = 21
          EditorEnabled = False
          MaxValue = 100000
          MinValue = 0
          TabOrder = 5
          Value = 1
          OnChange = SpinEditMPStoneIntervalTimeChange
        end
        object SpinEditMPStoneAddRate: TSpinEdit
          Left = 146
          Top = 114
          Width = 55
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 6
          Value = 100
          OnChange = SpinEditMPStoneAddRateChange
        end
        object SpinEditHPStoneDecDura: TSpinEdit
          Left = 146
          Top = 66
          Width = 55
          Height = 21
          EditorEnabled = False
          MaxValue = 100000
          MinValue = 0
          TabOrder = 3
          Value = 1000
          OnChange = SpinEditHPStoneDecDuraChange
        end
        object SpinEditMPStoneDecDura: TSpinEdit
          Left = 146
          Top = 138
          Width = 55
          Height = 21
          EditorEnabled = False
          MaxValue = 100000
          MinValue = 0
          TabOrder = 7
          Value = 1000
          OnChange = SpinEditMPStoneDecDuraChange
        end
      end
      object grp1: TGroupBox
        Left = 0
        Top = 169
        Width = 137
        Height = 60
        Caption = 'Other Options'
        TabOrder = 4
        object chkMonSayMsg: TCheckBox
          Left = 8
          Top = 16
          Width = 126
          Height = 17
          Caption = 'Open Monster Speak'
          TabOrder = 0
          OnClick = chkMonSayMsgClick
        end
        object chkCheckGuild: TCheckBox
          Left = 8
          Top = 40
          Width = 120
          Height = 17
          Caption = 'CheckGuild'
          TabOrder = 1
          Visible = False
          OnClick = chkCheckGuildClick
        end
      end
      object GroupBox55: TGroupBox
        Left = 3
        Top = 235
        Width = 137
        Height = 50
        Caption = 'Natural Growth'
        TabOrder = 5
        object Label140: TLabel
          Left = 11
          Top = 22
          Width = 66
          Height = 12
          Caption = 'Incr PerMin'
        end
        object EditPullulation: TSpinEdit
          Left = 77
          Top = 19
          Width = 52
          Height = 21
          Hint = 
            'Setting natural growth point increase per minute quantities. 1:0' +
            '0 natural growth point = 60. The default setting 10'
          MaxValue = 100000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditPullulationChange
        end
      end
    end
    object TabSheet33: TTabSheet
      Caption = 'Mentoring'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 42
      ExplicitWidth = 0
      ExplicitHeight = 299
      object GroupBox21: TGroupBox
        Left = 8
        Top = 8
        Width = 161
        Height = 153
        Caption = 'Apprenticeship'
        TabOrder = 0
        object GroupBox22: TGroupBox
          Left = 8
          Top = 16
          Width = 145
          Height = 49
          Caption = 'Rating'
          TabOrder = 0
          object Label29: TLabel
            Left = 8
            Top = 18
            Width = 36
            Height = 12
            Caption = 'Level:'
          end
          object EditMasterOKLevel: TSpinEdit
            Left = 68
            Top = 15
            Width = 53
            Height = 21
            Hint = 
              'Apprenticeship level setting, the characters in the coach, to th' +
              'e specified rating will automatically apprenticeship.'
            MaxValue = 65535
            MinValue = 1
            TabOrder = 0
            Value = 10
            OnChange = EditMasterOKLevelChange
          end
        end
        object GroupBox23: TGroupBox
          Left = 8
          Top = 72
          Width = 145
          Height = 73
          Caption = 'Master Income'
          TabOrder = 1
          object Label30: TLabel
            Left = 8
            Top = 18
            Width = 60
            Height = 12
            Caption = 'Rep Point:'
          end
          object Label31: TLabel
            Left = 8
            Top = 42
            Width = 42
            Height = 12
            Caption = 'Points:'
          end
          object EditMasterOKCreditPoint: TSpinEdit
            Left = 68
            Top = 15
            Width = 53
            Height = 21
            Hint = 'After the apprentice apprenticeship, Master get prestige points.'
            MaxValue = 1000
            MinValue = 0
            TabOrder = 0
            Value = 10
            OnChange = EditMasterOKCreditPointChange
          end
          object EditMasterOKBonusPoint: TSpinEdit
            Left = 68
            Top = 39
            Width = 53
            Height = 21
            Hint = 
              'After the apprentice apprenticeship, Master resulting distributi' +
              'on points.'
            MaxValue = 1000
            MinValue = 0
            TabOrder = 1
            Value = 10
            OnChange = EditMasterOKBonusPointChange
          end
        end
      end
      object ButtonMasterSave: TButton
        Left = 360
        Top = 157
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 1
        OnClick = ButtonMasterSaveClick
      end
    end
    object TabSheet38: TTabSheet
      Caption = 'Reincarnation'
      ImageIndex = 9
      ExplicitLeft = 0
      ExplicitTop = 42
      ExplicitWidth = 0
      ExplicitHeight = 299
      object GroupBox29: TGroupBox
        Left = 8
        Top = 8
        Width = 113
        Height = 257
        Caption = 'Auto Color'
        TabOrder = 0
        object Label56: TLabel
          Left = 11
          Top = 16
          Width = 12
          Height = 12
          Caption = '1:'
        end
        object LabelReNewNameColor1: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label58: TLabel
          Left = 11
          Top = 40
          Width = 12
          Height = 12
          Caption = '2:'
        end
        object LabelReNewNameColor2: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label60: TLabel
          Left = 11
          Top = 64
          Width = 12
          Height = 12
          Caption = '3:'
        end
        object LabelReNewNameColor3: TLabel
          Left = 88
          Top = 62
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label62: TLabel
          Left = 11
          Top = 88
          Width = 12
          Height = 12
          Caption = '4:'
        end
        object LabelReNewNameColor4: TLabel
          Left = 88
          Top = 86
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label64: TLabel
          Left = 11
          Top = 112
          Width = 12
          Height = 12
          Caption = '5:'
        end
        object LabelReNewNameColor5: TLabel
          Left = 88
          Top = 110
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label66: TLabel
          Left = 11
          Top = 136
          Width = 12
          Height = 12
          Caption = '6:'
        end
        object LabelReNewNameColor6: TLabel
          Left = 88
          Top = 134
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label68: TLabel
          Left = 11
          Top = 160
          Width = 12
          Height = 12
          Caption = '7:'
        end
        object LabelReNewNameColor7: TLabel
          Left = 88
          Top = 158
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label70: TLabel
          Left = 11
          Top = 184
          Width = 12
          Height = 12
          Caption = '8:'
        end
        object LabelReNewNameColor8: TLabel
          Left = 88
          Top = 182
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label72: TLabel
          Left = 11
          Top = 208
          Width = 12
          Height = 12
          Caption = '9:'
        end
        object LabelReNewNameColor9: TLabel
          Left = 88
          Top = 206
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label74: TLabel
          Left = 11
          Top = 232
          Width = 18
          Height = 12
          Caption = '10:'
        end
        object LabelReNewNameColor10: TLabel
          Left = 88
          Top = 230
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditReNewNameColor1: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditReNewNameColor1Change
        end
        object EditReNewNameColor2: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditReNewNameColor2Change
        end
        object EditReNewNameColor3: TSpinEdit
          Left = 40
          Top = 60
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditReNewNameColor3Change
        end
        object EditReNewNameColor4: TSpinEdit
          Left = 40
          Top = 84
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditReNewNameColor4Change
        end
        object EditReNewNameColor5: TSpinEdit
          Left = 40
          Top = 108
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 4
          Value = 100
          OnChange = EditReNewNameColor5Change
        end
        object EditReNewNameColor6: TSpinEdit
          Left = 40
          Top = 132
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 5
          Value = 100
          OnChange = EditReNewNameColor6Change
        end
        object EditReNewNameColor7: TSpinEdit
          Left = 40
          Top = 156
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 6
          Value = 100
          OnChange = EditReNewNameColor7Change
        end
        object EditReNewNameColor8: TSpinEdit
          Left = 40
          Top = 180
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 7
          Value = 100
          OnChange = EditReNewNameColor8Change
        end
        object EditReNewNameColor9: TSpinEdit
          Left = 40
          Top = 204
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 8
          Value = 100
          OnChange = EditReNewNameColor9Change
        end
        object EditReNewNameColor10: TSpinEdit
          Left = 40
          Top = 228
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 9
          Value = 100
          OnChange = EditReNewNameColor10Change
        end
      end
      object ButtonReNewLevelSave: TButton
        Left = 360
        Top = 157
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 1
        OnClick = ButtonReNewLevelSaveClick
      end
      object GroupBox30: TGroupBox
        Left = 128
        Top = 8
        Width = 145
        Height = 65
        Caption = 'Name of Discoloration'
        TabOrder = 2
        object Label57: TLabel
          Left = 8
          Top = 42
          Width = 54
          Height = 12
          Caption = 'Interval:'
        end
        object Label59: TLabel
          Left = 111
          Top = 39
          Width = 18
          Height = 12
          Caption = 'Sec'
        end
        object EditReNewNameColorTime: TSpinEdit
          Left = 68
          Top = 41
          Width = 37
          Height = 21
          Hint = 
            'Apprenticeship level setting, the characters in the coach, to th' +
            'e specified rating will automatically apprenticeship.'
          EditorEnabled = False
          MaxValue = 10
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditReNewNameColorTimeChange
        end
        object CheckBoxReNewChangeColor: TCheckBox
          Left = 8
          Top = 16
          Width = 89
          Height = 17
          Hint = 
            'After opening this function, the reincarnation of the names of t' +
            'he characters change color automatically.'
          Caption = 'Auto Color'
          TabOrder = 1
          OnClick = CheckBoxReNewChangeColorClick
        end
      end
      object GroupBox33: TGroupBox
        Left = 128
        Top = 80
        Width = 145
        Height = 41
        Caption = 'Reincarnation Ctrl'
        TabOrder = 3
        object CheckBoxReNewLevelClearExp: TCheckBox
          Left = 8
          Top = 16
          Width = 113
          Height = 17
          Hint = 'Are Clear has some experience when reincarnated.'
          Caption = 'Clear has EXP'
          TabOrder = 0
          OnClick = CheckBoxReNewLevelClearExpClick
        end
      end
    end
    object TabSheet39: TTabSheet
      Caption = 'Baby Upgrade?'
      ImageIndex = 10
      ExplicitLeft = 0
      ExplicitTop = 42
      ExplicitWidth = 0
      ExplicitHeight = 299
      object ButtonMonUpgradeSave: TButton
        Left = 365
        Top = 245
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 0
        OnClick = ButtonMonUpgradeSaveClick
      end
      object GroupBox32: TGroupBox
        Left = 9
        Top = 3
        Width = 113
        Height = 233
        Caption = 'Level Color'
        TabOrder = 1
        object Label65: TLabel
          Left = 11
          Top = 16
          Width = 12
          Height = 12
          Caption = '1:'
        end
        object LabelMonUpgradeColor1: TLabel
          Left = 88
          Top = 14
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label67: TLabel
          Left = 11
          Top = 40
          Width = 12
          Height = 12
          Caption = '2:'
        end
        object LabelMonUpgradeColor2: TLabel
          Left = 88
          Top = 38
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label69: TLabel
          Left = 11
          Top = 64
          Width = 12
          Height = 12
          Caption = '3:'
        end
        object LabelMonUpgradeColor3: TLabel
          Left = 88
          Top = 62
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label71: TLabel
          Left = 11
          Top = 88
          Width = 12
          Height = 12
          Caption = '4:'
        end
        object LabelMonUpgradeColor4: TLabel
          Left = 88
          Top = 86
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label73: TLabel
          Left = 11
          Top = 112
          Width = 12
          Height = 12
          Caption = '5:'
        end
        object LabelMonUpgradeColor5: TLabel
          Left = 88
          Top = 110
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label75: TLabel
          Left = 11
          Top = 136
          Width = 12
          Height = 12
          Caption = '6:'
        end
        object LabelMonUpgradeColor6: TLabel
          Left = 88
          Top = 134
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label76: TLabel
          Left = 11
          Top = 157
          Width = 12
          Height = 12
          Caption = '7:'
        end
        object LabelMonUpgradeColor7: TLabel
          Left = 88
          Top = 158
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label77: TLabel
          Left = 11
          Top = 184
          Width = 12
          Height = 12
          Caption = '8:'
        end
        object LabelMonUpgradeColor8: TLabel
          Left = 88
          Top = 182
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label86: TLabel
          Left = 11
          Top = 208
          Width = 12
          Height = 12
          Caption = '9:'
        end
        object LabelMonUpgradeColor9: TLabel
          Left = 88
          Top = 206
          Width = 9
          Height = 17
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditMonUpgradeColor1: TSpinEdit
          Left = 40
          Top = 12
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditMonUpgradeColor1Change
        end
        object EditMonUpgradeColor2: TSpinEdit
          Left = 40
          Top = 36
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditMonUpgradeColor2Change
        end
        object EditMonUpgradeColor3: TSpinEdit
          Left = 40
          Top = 60
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditMonUpgradeColor3Change
        end
        object EditMonUpgradeColor4: TSpinEdit
          Left = 40
          Top = 84
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditMonUpgradeColor4Change
        end
        object EditMonUpgradeColor5: TSpinEdit
          Left = 40
          Top = 108
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 4
          Value = 100
          OnChange = EditMonUpgradeColor5Change
        end
        object EditMonUpgradeColor6: TSpinEdit
          Left = 40
          Top = 132
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 5
          Value = 100
          OnChange = EditMonUpgradeColor6Change
        end
        object EditMonUpgradeColor7: TSpinEdit
          Left = 40
          Top = 156
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 6
          Value = 100
          OnChange = EditMonUpgradeColor7Change
        end
        object EditMonUpgradeColor8: TSpinEdit
          Left = 40
          Top = 180
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 7
          Value = 100
          OnChange = EditMonUpgradeColor8Change
        end
        object EditMonUpgradeColor9: TSpinEdit
          Left = 40
          Top = 204
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 8
          Value = 100
          OnChange = EditMonUpgradeColor9Change
        end
      end
      object GroupBox31: TGroupBox
        Left = 128
        Top = 8
        Width = 97
        Height = 233
        Caption = 'Upgr Kill Several'
        TabOrder = 2
        object Label61: TLabel
          Left = 11
          Top = 16
          Width = 12
          Height = 12
          Caption = '1:'
        end
        object Label63: TLabel
          Left = 11
          Top = 40
          Width = 12
          Height = 12
          Caption = '2:'
        end
        object Label78: TLabel
          Left = 11
          Top = 64
          Width = 12
          Height = 12
          Caption = '3:'
        end
        object Label79: TLabel
          Left = 11
          Top = 88
          Width = 12
          Height = 12
          Caption = '4:'
        end
        object Label80: TLabel
          Left = 11
          Top = 112
          Width = 12
          Height = 12
          Caption = '5:'
        end
        object Label81: TLabel
          Left = 11
          Top = 136
          Width = 12
          Height = 12
          Caption = '6:'
        end
        object Label82: TLabel
          Left = 11
          Top = 160
          Width = 12
          Height = 12
          Caption = '7:'
        end
        object Label83: TLabel
          Left = 11
          Top = 184
          Width = 24
          Height = 12
          Caption = 'Base'
        end
        object Label84: TLabel
          Left = 11
          Top = 208
          Width = 42
          Height = 12
          Caption = 'Magnif:'
        end
        object EditMonUpgradeKillCount1: TSpinEdit
          Left = 40
          Top = 12
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditMonUpgradeKillCount1Change
        end
        object EditMonUpgradeKillCount2: TSpinEdit
          Left = 40
          Top = 36
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditMonUpgradeKillCount2Change
        end
        object EditMonUpgradeKillCount3: TSpinEdit
          Left = 40
          Top = 60
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditMonUpgradeKillCount3Change
        end
        object EditMonUpgradeKillCount4: TSpinEdit
          Left = 40
          Top = 84
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditMonUpgradeKillCount4Change
        end
        object EditMonUpgradeKillCount5: TSpinEdit
          Left = 40
          Top = 108
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 4
          Value = 100
          OnChange = EditMonUpgradeKillCount5Change
        end
        object EditMonUpgradeKillCount6: TSpinEdit
          Left = 40
          Top = 132
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 5
          Value = 100
          OnChange = EditMonUpgradeKillCount6Change
        end
        object EditMonUpgradeKillCount7: TSpinEdit
          Left = 40
          Top = 156
          Width = 49
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 6
          Value = 100
          OnChange = EditMonUpgradeKillCount7Change
        end
        object EditMonUpLvNeedKillBase: TSpinEdit
          Left = 40
          Top = 180
          Width = 49
          Height = 21
          Hint = #26432#24618#25968#37327'='#31561#32423' * '#20493#29575' + '#31561#32423' + '#22522#25968' + '#27599#32423#25968#37327
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 7
          Value = 100
          OnChange = EditMonUpLvNeedKillBaseChange
        end
        object EditMonUpLvRate: TSpinEdit
          Left = 40
          Top = 204
          Width = 49
          Height = 21
          Hint = #26432#24618#25968#37327'='#24618#29289#31561#32423' * '#20493#29575' + '#31561#32423' + '#22522#25968' + '#27599#32423#25968#37327
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 8
          Value = 100
          OnChange = EditMonUpLvRateChange
        end
      end
      object GroupBox35: TGroupBox
        Left = 232
        Top = 8
        Width = 137
        Height = 113
        Caption = 'Master Ctrl Death'
        TabOrder = 3
        object Label88: TLabel
          Left = 11
          Top = 40
          Width = 54
          Height = 12
          Caption = 'Mutation:'
        end
        object Label90: TLabel
          Left = 11
          Top = 64
          Width = 54
          Height = 12
          Caption = 'Incr Atk:'
        end
        object Label92: TLabel
          Left = 11
          Top = 88
          Width = 66
          Height = 12
          Caption = 'Incr Speed:'
        end
        object CheckBoxMasterDieMutiny: TCheckBox
          Left = 8
          Top = 16
          Width = 113
          Height = 17
          Caption = 'After Dead Owner'
          TabOrder = 0
          OnClick = CheckBoxMasterDieMutinyClick
        end
        object EditMasterDieMutinyRate: TSpinEdit
          Left = 72
          Top = 36
          Width = 49
          Height = 21
          Hint = 'The smaller the number, the greater the chances of variation.'
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditMasterDieMutinyRateChange
        end
        object EditMasterDieMutinyPower: TSpinEdit
          Left = 72
          Top = 60
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditMasterDieMutinyPowerChange
        end
        object EditMasterDieMutinySpeed: TSpinEdit
          Left = 72
          Top = 84
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditMasterDieMutinySpeedChange
        end
      end
      object GroupBox47: TGroupBox
        Left = 232
        Top = 128
        Width = 137
        Height = 73
        Caption = 'Colorful Baby'
        TabOrder = 4
        object Label112: TLabel
          Left = 11
          Top = 40
          Width = 54
          Height = 12
          Caption = 'Interval:'
        end
        object CheckBoxBBMonAutoChangeColor: TCheckBox
          Left = 8
          Top = 16
          Width = 113
          Height = 17
          Caption = 'Auto Color'
          TabOrder = 0
          OnClick = CheckBoxBBMonAutoChangeColorClick
        end
        object EditBBMonAutoChangeColorTime: TSpinEdit
          Left = 72
          Top = 36
          Width = 49
          Height = 21
          Hint = 'The smaller the number, the faster the color, the unit (s).'
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 1
          TabOrder = 1
          Value = 100
          OnChange = EditBBMonAutoChangeColorTimeChange
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Skill Magic'
      ImageIndex = 1
      object ButtonSkillSave: TButton
        Left = 379
        Top = 275
        Width = 68
        Height = 23
        Caption = #20445#23384'(&S)'
        TabOrder = 0
        OnClick = ButtonSkillSaveClick
      end
      object MagicPageControl: TPageControl
        Left = 0
        Top = 2
        Width = 446
        Height = 269
        ActivePage = TabSheet15
        TabOrder = 1
        object TabSheet54: TTabSheet
          Caption = 'Basic'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object GroupBox17: TGroupBox
            Left = 8
            Top = 8
            Width = 169
            Height = 49
            Caption = 'Magic Attack Range Limit'
            TabOrder = 0
            object Label12: TLabel
              Left = 8
              Top = 21
              Width = 36
              Height = 12
              Caption = 'Range:'
            end
            object EditMagicAttackRage: TSpinEdit
              Left = 68
              Top = 18
              Width = 60
              Height = 21
              Hint = 
                'Effective distance magic attack, more than a specified distance ' +
                'attacks ineffective.'
              EditorEnabled = False
              MaxValue = 20
              MinValue = 1
              TabOrder = 0
              Value = 10
              OnChange = EditMagicAttackRageChange
            end
          end
          object GroupBox75: TGroupBox
            Left = 7
            Top = 68
            Width = 194
            Height = 49
            Caption = 'Magic Monster Dmg Magnifcation'
            TabOrder = 1
            object Label186: TLabel
              Left = 8
              Top = 21
              Width = 66
              Height = 12
              Caption = 'Injury Rate'
            end
            object EditMagicAttackMonsteRate: TSpinEdit
              Left = 80
              Top = 18
              Width = 60
              Height = 21
              MaxValue = 10000
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditMagicAttackMonsteRateChange
            end
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'Warrior'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object PageControl2: TPageControl
            Left = 3
            Top = 3
            Width = 432
            Height = 237
            ActivePage = TabSheet24
            TabOrder = 0
            object TabSheet3: TTabSheet
              Caption = 'Fencing'
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox9: TGroupBox
                Left = 8
                Top = 8
                Width = 225
                Height = 41
                Caption = 'Unlimited Assassination'
                TabOrder = 0
                object CheckBoxLimitSwordLong: TCheckBox
                  Left = 8
                  Top = 16
                  Width = 209
                  Height = 17
                  Hint = 
                    'After opening this function will check to check whether there is' +
                    ' every bit roles exist to prohibit knife assassination.'
                  Caption = 'Prohibit Unlimited Assassination'
                  TabOrder = 0
                  OnClick = CheckBoxLimitSwordLongClick
                end
              end
              object GroupBox10: TGroupBox
                Left = 8
                Top = 56
                Width = 129
                Height = 41
                Caption = 'Multiple Attack'
                TabOrder = 1
                object Label4: TLabel
                  Left = 8
                  Top = 20
                  Width = 30
                  Height = 12
                  Caption = 'Multi'
                end
                object Label10: TLabel
                  Left = 96
                  Top = 20
                  Width = 24
                  Height = 12
                  Caption = '/100'
                end
                object EditSwordLongPowerRate: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 45
                  Height = 21
                  Hint = 
                    'Attack multiple, digital size divided by 100 is the actual multi' +
                    'ple.'
                  EditorEnabled = False
                  MaxValue = 1000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = EditSwordLongPowerRateChange
                end
              end
            end
            object TabSheet4: TTabSheet
              Caption = 'Toru Nail'
              ImageIndex = 1
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox56: TGroupBox
                Left = 159
                Top = 86
                Width = 138
                Height = 51
                Caption = 'Use Interval'
                TabOrder = 0
                Visible = False
                object Label119: TLabel
                  Left = 10
                  Top = 24
                  Width = 30
                  Height = 12
                  Caption = 'Time:'
                end
                object Label120: TLabel
                  Left = 114
                  Top = 24
                  Width = 18
                  Height = 12
                  Caption = 'Sec'
                end
                object SpinEditSkill39Sec: TSpinEdit
                  Left = 50
                  Top = 20
                  Width = 57
                  Height = 21
                  MaxValue = 100
                  MinValue = 0
                  TabOrder = 0
                  Value = 10
                  OnChange = SpinEditSkill39SecChange
                end
              end
              object GroupBox57: TGroupBox
                Left = 9
                Top = 65
                Width = 137
                Height = 46
                Caption = 'Allow PK'
                TabOrder = 1
                object CheckBoxDedingAllowPK: TCheckBox
                  Left = 9
                  Top = 18
                  Width = 97
                  Height = 17
                  Caption = 'Allow PK'
                  TabOrder = 0
                  OnClick = CheckBoxDedingAllowPKClick
                end
              end
              object GroupBox52: TGroupBox
                Left = 9
                Top = 9
                Width = 152
                Height = 50
                Caption = 'Skill Parameters'
                TabOrder = 2
                object Label135: TLabel
                  Left = 10
                  Top = 24
                  Width = 72
                  Height = 12
                  Caption = 'Power Factor'
                end
                object SpinEditDidingPowerRate: TSpinEdit
                  Left = 88
                  Top = 19
                  Width = 51
                  Height = 21
                  Hint = 'The actual multiples equal to the current number of 100'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = SpinEditDidingPowerRateChange
                end
              end
            end
            object TabSheet5: TTabSheet
              Caption = 'Idiom'
              ImageIndex = 2
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox48: TGroupBox
                Left = 3
                Top = 3
                Width = 150
                Height = 59
                Caption = 'Paralysis Option'
                TabOrder = 0
                object CheckBoxGroupMbAttackPlayObject: TCheckBox
                  Left = 8
                  Top = 16
                  Width = 129
                  Height = 17
                  Hint = 'After opening this function, you can figure paralysis'
                  Caption = 'Allow para figures'
                  TabOrder = 0
                  OnClick = CheckBoxGroupMbAttackPlayObjectClick
                end
                object CheckBoxGroupMbAttackSlave: TCheckBox
                  Left = 8
                  Top = 36
                  Width = 97
                  Height = 17
                  Caption = 'Allow Palsy '
                  TabOrder = 1
                  OnClick = CheckBoxGroupMbAttackSlaveClick
                end
              end
            end
            object TabSheet6: TTabSheet
              Caption = 'Qinlong '
              ImageIndex = 3
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox50: TGroupBox
                Left = 8
                Top = 8
                Width = 201
                Height = 65
                Caption = 'Catch Figures'
                TabOrder = 0
                object CheckBoxPullPlayObject: TCheckBox
                  Left = 9
                  Top = 17
                  Width = 136
                  Height = 17
                  Caption = 'Allow Catch figures'
                  TabOrder = 0
                  OnClick = CheckBoxPullPlayObjectClick
                end
                object CheckBoxPullCrossInSafeZone: TCheckBox
                  Left = 9
                  Top = 40
                  Width = 189
                  Height = 17
                  Caption = 'PPL Caught SZ is Prohibited'
                  TabOrder = 1
                  OnClick = CheckBoxPullCrossInSafeZoneClick
                end
              end
            end
            object ts1: TTabSheet
              Caption = 'Three Lore'
              ImageIndex = 4
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object grp3: TGroupBox
                Left = 10
                Top = 9
                Width = 159
                Height = 50
                Caption = 'Skill Parameters'
                TabOrder = 0
                object lbl3: TLabel
                  Left = 10
                  Top = 24
                  Width = 84
                  Height = 12
                  Caption = 'Power Factor'#65306
                end
                object seSkill110PowerRate: TSpinEdit
                  Left = 91
                  Top = 19
                  Width = 51
                  Height = 21
                  Hint = 'The actual multiples equal to the current number of 100'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = seSkill110PowerRateChange
                end
              end
            end
            object ts2: TTabSheet
              Caption = 'Thorn Heart'
              ImageIndex = 5
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object grp4: TGroupBox
                Left = 10
                Top = 9
                Width = 151
                Height = 50
                Caption = 'Skill Parameters'
                TabOrder = 0
                Visible = False
                object lbl4: TLabel
                  Left = 10
                  Top = 24
                  Width = 78
                  Height = 12
                  Caption = 'Power factor:'
                end
                object seSkill111PowerRate: TSpinEdit
                  Left = 91
                  Top = 19
                  Width = 51
                  Height = 21
                  Hint = 'The actual multiples equal to the current number of 100'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = seSkill111PowerRateChange
                end
              end
            end
            object ts3: TTabSheet
              Caption = 'CutOff Yue'
              ImageIndex = 6
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object grp5: TGroupBox
                Left = 10
                Top = 9
                Width = 167
                Height = 50
                Caption = 'Skills Parameters'
                TabOrder = 0
                object lbl5: TLabel
                  Left = 10
                  Top = 24
                  Width = 72
                  Height = 12
                  Caption = 'Power Factor'
                end
                object seSkill112PowerRate: TSpinEdit
                  Left = 91
                  Top = 19
                  Width = 51
                  Height = 21
                  Hint = 'The actual multiples equal to the current number of 100'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = seSkill112PowerRateChange
                end
              end
            end
            object ts4: TTabSheet
              Caption = 'Total Annihilation'
              ImageIndex = 7
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object grp6: TGroupBox
                Left = 10
                Top = 9
                Width = 159
                Height = 50
                Caption = 'Skill Parameters'
                TabOrder = 0
                object lbl6: TLabel
                  Left = 10
                  Top = 24
                  Width = 72
                  Height = 12
                  Caption = 'Power Factor'
                end
                object seSkill113PowerRate: TSpinEdit
                  Left = 88
                  Top = 19
                  Width = 51
                  Height = 21
                  Hint = 'The actual multiples equal to the current number of 100'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = seSkill113PowerRateChange
                end
              end
            end
            object TabSheet24: TTabSheet
              Caption = 'Ten Steps to a kill'
              ImageIndex = 8
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox59: TGroupBox
                Left = 10
                Top = 9
                Width = 167
                Height = 195
                Caption = 'Skills parameters'
                TabOrder = 0
                object Label142: TLabel
                  Left = 10
                  Top = 21
                  Width = 72
                  Height = 12
                  Caption = 'Power Factor'
                end
                object EditSkill70PowerRate: TSpinEdit
                  Left = 99
                  Top = 18
                  Width = 51
                  Height = 21
                  Hint = 'The actual number is divided by 100 equals the current multiples'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = EditSkill70PowerRateChange
                end
                object CheckBoxSkill70MbAttackMon: TCheckBox
                  Left = 10
                  Top = 40
                  Width = 143
                  Height = 17
                  Caption = 'Allow Para Monster'
                  TabOrder = 1
                  OnClick = CheckBoxSkill70MbAttackMonClick
                end
                object CheckBoxSkill70MbAttackHuman: TCheckBox
                  Left = 10
                  Top = 57
                  Width = 135
                  Height = 17
                  Caption = 'Allow Para Figures'
                  TabOrder = 2
                  OnClick = CheckBoxSkill70MbAttackHumanClick
                end
                object CheckBoxSkill70MbAttackSlave: TCheckBox
                  Left = 10
                  Top = 74
                  Width = 107
                  Height = 17
                  Caption = 'Allow Palsy'
                  TabOrder = 3
                  OnClick = CheckBoxSkill70MbAttackSlaveClick
                end
                object CheckBoxSkill70MbFastParalysis: TCheckBox
                  Left = 10
                  Top = 91
                  Width = 127
                  Height = 17
                  Hint = 
                    'When the character or monster paralyzed the skills, whether it b' +
                    'e attacked immediately cancel paralysis.'
                  Caption = 'Allow Rapid Para'
                  TabOrder = 4
                  OnClick = CheckBoxSkill70MbFastParalysisClick
                end
                object CheckBoxSkill70RunGuard: TCheckBox
                  Left = 10
                  Top = 158
                  Width = 127
                  Height = 13
                  Hint = 
                    'After opening this function, the characters will be able to pass' +
                    ' through the guard (machetes, archers)'
                  Caption = 'Allow Cross Guard'
                  TabOrder = 5
                  OnClick = CheckBoxSkill70RunGuardClick
                end
                object CheckBoxSkill70RunNpc: TCheckBox
                  Left = 10
                  Top = 142
                  Width = 127
                  Height = 13
                  Hint = 
                    'After opening this function, the characters will be able to pass' +
                    ' through the NPC'
                  Caption = 'Allow Through NPC'
                  TabOrder = 6
                  OnClick = CheckBoxSkill70RunNpcClick
                end
                object CheckBoxSkill70RunMon: TCheckBox
                  Left = 10
                  Top = 126
                  Width = 154
                  Height = 13
                  Hint = 
                    'After opening this function, the characters will be able to pass' +
                    ' through the monster'
                  Caption = 'Allow Through Monster'
                  TabOrder = 7
                  OnClick = CheckBoxSkill70RunMonClick
                end
                object CheckBoxSkill70RunHum: TCheckBox
                  Left = 10
                  Top = 110
                  Width = 154
                  Height = 13
                  Hint = 
                    'After opening this function, the characters will be able to pass' +
                    ' through the other characters'
                  Caption = 'Allow Pass Through Char'
                  TabOrder = 8
                  OnClick = CheckBoxSkill70RunHumClick
                end
                object CheckBoxSkill70WarDisHumRun: TCheckBox
                  Left = 10
                  Top = 174
                  Width = 143
                  Height = 13
                  Hint = 'After opening this function, all the prohibited area in siege'
                  Caption = 'All Prohibited Siege area'
                  TabOrder = 9
                  OnClick = CheckBoxSkill70WarDisHumRunClick
                end
              end
            end
          end
        end
        object TabSheet7: TTabSheet
          Caption = 'Wizard'
          ImageIndex = 2
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object PageControl3: TPageControl
            Left = 3
            Top = 3
            Width = 432
            Height = 236
            ActivePage = TabSheet25
            TabOrder = 0
            object TabSheet8: TTabSheet
              Caption = 'Light Temptation'
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox38: TGroupBox
                Left = 8
                Top = 8
                Width = 113
                Height = 41
                Caption = 'Monster Lvl Restr'
                TabOrder = 0
                object Label98: TLabel
                  Left = 8
                  Top = 20
                  Width = 24
                  Height = 12
                  Caption = 'Lvl:'
                end
                object EditMagTammingLevel: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 61
                  Height = 21
                  Hint = 
                    'Specify the level of the following monsters will be tempted to l' +
                    'ure the monster than specified grade is invalid.'
                  EditorEnabled = False
                  MaxValue = 65535
                  MinValue = 1
                  TabOrder = 0
                  Value = 1
                  OnChange = EditMagTammingLevelChange
                end
              end
              object GroupBox45: TGroupBox
                Left = 128
                Top = 8
                Width = 113
                Height = 41
                Caption = 'Temptation No'
                TabOrder = 1
                object Label111: TLabel
                  Left = 8
                  Top = 20
                  Width = 36
                  Height = 12
                  Caption = 'Quant:'
                end
                object EditTammingCount: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 61
                  Height = 21
                  Hint = 'Can lure the monster number'
                  EditorEnabled = False
                  MaxValue = 65535
                  MinValue = 1
                  TabOrder = 0
                  Value = 1
                  OnChange = EditTammingCountChange
                end
              end
              object GroupBox39: TGroupBox
                Left = 8
                Top = 56
                Width = 113
                Height = 73
                Caption = 'Temptation Prob'
                TabOrder = 2
                object Label99: TLabel
                  Left = 8
                  Top = 20
                  Width = 48
                  Height = 12
                  Caption = 'Mon Lvl:'
                end
                object Label100: TLabel
                  Left = 8
                  Top = 44
                  Width = 42
                  Height = 12
                  Caption = 'Mon HP:'
                end
                object EditMagTammingTargetLevel: TSpinEdit
                  Left = 64
                  Top = 15
                  Width = 41
                  Height = 21
                  Hint = 
                    'Monster level ratio, the smaller the number the greater the prob' +
                    'ability.'
                  EditorEnabled = False
                  MaxValue = 65535
                  MinValue = 1
                  TabOrder = 0
                  Value = 1
                  OnChange = EditMagTammingTargetLevelChange
                end
                object EditMagTammingHPRate: TSpinEdit
                  Left = 64
                  Top = 39
                  Width = 41
                  Height = 21
                  Hint = 
                    'Monster blood ratio, the higher the number, the greater the prob' +
                    'ability.'
                  EditorEnabled = False
                  MaxValue = 65535
                  MinValue = 1
                  TabOrder = 1
                  Value = 1
                  OnChange = EditMagTammingHPRateChange
                end
              end
            end
            object TabSheet12: TTabSheet
              Caption = 'Burst Of Flame'
              ImageIndex = 4
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox13: TGroupBox
                Left = 8
                Top = 8
                Width = 113
                Height = 41
                Caption = 'Attack Range'
                TabOrder = 0
                object Label7: TLabel
                  Left = 8
                  Top = 20
                  Width = 36
                  Height = 12
                  Caption = 'Range:'
                end
                object EditFireBoomRage: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 61
                  Height = 21
                  Hint = 'Magic attack radius.'
                  EditorEnabled = False
                  MaxValue = 12
                  MinValue = 1
                  TabOrder = 0
                  Value = 1
                  OnChange = EditFireBoomRageChange
                end
              end
            end
            object TabSheet9: TTabSheet
              Caption = 'FireWall'
              ImageIndex = 1
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox53: TGroupBox
                Left = 8
                Top = 55
                Width = 185
                Height = 74
                Caption = 'Skill Parameters'
                TabOrder = 0
                object Label117: TLabel
                  Left = 8
                  Top = 20
                  Width = 84
                  Height = 12
                  Caption = 'Effective Mult'
                end
                object Label116: TLabel
                  Left = 8
                  Top = 44
                  Width = 72
                  Height = 12
                  Caption = 'Power Factor'
                end
                object SpinEditFireDelayTime: TSpinEdit
                  Left = 96
                  Top = 16
                  Width = 81
                  Height = 21
                  Hint = 'In addition to the actual factor equal to the current number 100'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = SpinEditFireDelayTimeChange
                end
                object SpinEditFirePower: TSpinEdit
                  Left = 96
                  Top = 40
                  Width = 81
                  Height = 21
                  Hint = 'The actual number is divided by 100 equals the current multiples'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 1
                  Value = 100
                  OnChange = SpinEditFirePowerChange
                end
              end
              object GroupBox46: TGroupBox
                Left = 8
                Top = 8
                Width = 113
                Height = 41
                Caption = 'No FireWall SZ'
                TabOrder = 1
                object CheckBoxFireCrossInSafeZone: TCheckBox
                  Left = 8
                  Top = 16
                  Width = 97
                  Height = 17
                  Hint = #25171#24320#27492#21151#33021#21518#65292#22312#23433#20840#21306#19981#20801#35768#25918#28779#22681#12290
                  Caption = 'No FireWall'
                  TabOrder = 0
                  OnClick = CheckBoxFireCrossInSafeZoneClick
                end
              end
              object GroupBox63: TGroupBox
                Left = 127
                Top = 8
                Width = 134
                Height = 41
                Caption = 'Disapear Chng Map'
                TabOrder = 2
                object CheckBoxFireChgMapExtinguish: TCheckBox
                  Left = 8
                  Top = 16
                  Width = 108
                  Height = 17
                  Caption = 'Auto Disapear'
                  TabOrder = 0
                  OnClick = CheckBoxFireChgMapExtinguishClick
                end
              end
              object grp2: TGroupBox
                Left = 199
                Top = 55
                Width = 143
                Height = 74
                Caption = 'Dmg Interval'
                TabOrder = 3
                object lbl1: TLabel
                  Left = 8
                  Top = 20
                  Width = 24
                  Height = 12
                  Caption = 'PPL:'
                end
                object lbl2: TLabel
                  Left = 8
                  Top = 44
                  Width = 24
                  Height = 12
                  Caption = 'Mon:'
                end
                object seFirePlayDamageTimeRate: TSpinEdit
                  Left = 50
                  Top = 17
                  Width = 81
                  Height = 21
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = seFirePlayDamageTimeRateChange
                end
                object seFireMonDamageTimeRate: TSpinEdit
                  Left = 50
                  Top = 41
                  Width = 81
                  Height = 21
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 1
                  Value = 100
                  OnChange = seFireMonDamageTimeRateChange
                end
              end
            end
            object TabSheet11: TTabSheet
              Caption = 'Hell Leiguang'
              ImageIndex = 3
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox15: TGroupBox
                Left = 8
                Top = 8
                Width = 113
                Height = 41
                Caption = 'Attack Range'
                TabOrder = 0
                object Label9: TLabel
                  Left = 8
                  Top = 20
                  Width = 36
                  Height = 12
                  Caption = 'Range:'
                end
                object EditElecBlizzardRange: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 61
                  Height = 21
                  Hint = 'Magic attack radius.'
                  EditorEnabled = False
                  MaxValue = 12
                  MinValue = 1
                  TabOrder = 0
                  Value = 1
                  OnChange = EditElecBlizzardRangeChange
                end
              end
            end
            object TabSheet10: TTabSheet
              Caption = 'Word Surgery'
              ImageIndex = 2
              ExplicitLeft = 0
              ExplicitTop = 32
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox37: TGroupBox
                Left = 8
                Top = 8
                Width = 153
                Height = 41
                Caption = 'Mon Level Restrictions'
                TabOrder = 0
                object Label97: TLabel
                  Left = 8
                  Top = 20
                  Width = 36
                  Height = 12
                  Caption = 'Level:'
                end
                object EditMagTurnUndeadLevel: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 61
                  Height = 21
                  Hint = 
                    'Specify grade monsters will be following the Word, the Word mons' +
                    'ter specified above grade invalid.'
                  EditorEnabled = False
                  MaxValue = 65535
                  MinValue = 1
                  TabOrder = 0
                  Value = 1
                  OnChange = EditMagTurnUndeadLevelChange
                end
              end
            end
            object TabSheet13: TTabSheet
              Caption = 'Ice Roar'
              ImageIndex = 5
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox14: TGroupBox
                Left = 8
                Top = 8
                Width = 113
                Height = 41
                Caption = 'Attack Range'
                TabOrder = 0
                object Label8: TLabel
                  Left = 8
                  Top = 20
                  Width = 36
                  Height = 12
                  Caption = 'Range:'
                end
                object EditSnowWindRange: TSpinEdit
                  Left = 44
                  Top = 15
                  Width = 61
                  Height = 21
                  Hint = 'Magic attack radius.'
                  EditorEnabled = False
                  MaxValue = 12
                  MinValue = 1
                  TabOrder = 0
                  Value = 1
                  OnChange = EditSnowWindRangeChange
                end
              end
            end
            object TabSheet17: TTabSheet
              Caption = 'SkyFire'
              ImageIndex = 7
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox51: TGroupBox
                Left = 8
                Top = 8
                Width = 121
                Height = 49
                Caption = 'Less MP Value'
                TabOrder = 0
                object CheckBoxPlayObjectReduceMP: TCheckBox
                  Left = 8
                  Top = 18
                  Width = 110
                  Height = 17
                  Caption = 'MP Hits - Value'
                  TabOrder = 0
                  OnClick = CheckBoxPlayObjectReduceMPClick
                end
              end
            end
            object TabSheet36: TTabSheet
              Caption = 'Frost, Snow and Rain'
              ImageIndex = 13
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox70: TGroupBox
                Left = 8
                Top = 8
                Width = 153
                Height = 49
                Caption = 'Less MP Value'
                TabOrder = 0
                object CheckBoxSkill66ReduceMP: TCheckBox
                  Left = 8
                  Top = 18
                  Width = 121
                  Height = 17
                  Caption = 'MP hits - Value'
                  TabOrder = 0
                  OnClick = CheckBoxSkill66ReduceMPClick
                end
              end
            end
            object TabSheet27: TTabSheet
              Caption = 'Yixinghuanwei'
              ImageIndex = 12
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox64: TGroupBox
                Left = 10
                Top = 9
                Width = 207
                Height = 102
                Caption = 'Skill Parameters'
                TabOrder = 0
                object CheckBoxSkill63RunGuard: TCheckBox
                  Left = 10
                  Top = 65
                  Width = 167
                  Height = 13
                  Hint = 
                    'After opening this function, the characters will be overlapping ' +
                    'guard (machetes, archers)'
                  Caption = 'Allow OverLapping Guard'
                  TabOrder = 0
                  OnClick = CheckBoxSkill63RunGuardClick
                end
                object CheckBoxSkill63RunNpc: TCheckBox
                  Left = 10
                  Top = 49
                  Width = 143
                  Height = 13
                  Hint = 
                    'After opening this function, the characters will be able to over' +
                    'lap NPC'
                  Caption = 'Allow OverLap NPC'
                  TabOrder = 1
                  OnClick = CheckBoxSkill63RunNpcClick
                end
                object CheckBoxSkill63RunMon: TCheckBox
                  Left = 10
                  Top = 33
                  Width = 151
                  Height = 13
                  Hint = 
                    'After opening this function, the characters will be able to over' +
                    'lap monster'
                  Caption = 'Allow OverLap Monster'
                  TabOrder = 2
                  OnClick = CheckBoxSkill63RunMonClick
                end
                object CheckBoxSkill63RunHum: TCheckBox
                  Left = 10
                  Top = 17
                  Width = 167
                  Height = 13
                  Hint = 
                    'After opening this function, the characters will be able to over' +
                    'lap the other characters'
                  Caption = 'Allow Overlapping Figures'
                  TabOrder = 3
                  OnClick = CheckBoxSkill63RunHumClick
                end
                object CheckBoxSkill63WarDisHumRun: TCheckBox
                  Left = 10
                  Top = 81
                  Width = 194
                  Height = 13
                  Hint = 'After opening this function, all the prohibited area in siege'
                  Caption = 'Allow Prohibited Siege Area'
                  TabOrder = 4
                  OnClick = CheckBoxSkill63WarDisHumRunClick
                end
              end
            end
            object ts5: TTabSheet
              Caption = 'Ssangyong Break'
              ImageIndex = 7
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object grp7: TGroupBox
                Left = 10
                Top = 9
                Width = 151
                Height = 50
                Caption = 'Skill Parameters'
                TabOrder = 0
                object lbl7: TLabel
                  Left = 10
                  Top = 24
                  Width = 78
                  Height = 12
                  Caption = 'Power Factor:'
                end
                object seSkill114PowerRate: TSpinEdit
                  Left = 91
                  Top = 19
                  Width = 51
                  Height = 21
                  Hint = 'The actual multiples equal to the current number of 100'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = seSkill114PowerRateChange
                end
              end
            end
            object ts6: TTabSheet
              Caption = 'FengWu Technology'
              ImageIndex = 8
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object grp8: TGroupBox
                Left = 10
                Top = 9
                Width = 159
                Height = 50
                Caption = 'Skill Parameters'
                TabOrder = 0
                object lbl8: TLabel
                  Left = 10
                  Top = 24
                  Width = 78
                  Height = 12
                  Caption = 'Power Factor:'
                end
                object seSkill115PowerRate: TSpinEdit
                  Left = 83
                  Top = 19
                  Width = 51
                  Height = 21
                  Hint = 'The actual multiples equal to the current number of 100'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = seSkill115PowerRateChange
                end
              end
            end
            object ts7: TTabSheet
              Caption = 'Thunder Burst'
              ImageIndex = 9
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object grp9: TGroupBox
                Left = 10
                Top = 9
                Width = 151
                Height = 50
                Caption = 'Skill Parameters'
                TabOrder = 0
                object lbl9: TLabel
                  Left = 10
                  Top = 24
                  Width = 78
                  Height = 12
                  Caption = 'Power Factor:'
                end
                object seSkill116PowerRate: TSpinEdit
                  Left = 90
                  Top = 19
                  Width = 51
                  Height = 21
                  Hint = 'The actual multiples equal to the current number of 100'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = seSkill116PowerRateChange
                end
              end
            end
            object ts8: TTabSheet
              Caption = 'Ice and Snow'
              ImageIndex = 10
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object grp10: TGroupBox
                Left = 10
                Top = 9
                Width = 159
                Height = 50
                Caption = 'Skill Parameters'
                TabOrder = 0
                object lbl10: TLabel
                  Left = 10
                  Top = 24
                  Width = 72
                  Height = 12
                  Caption = 'Power Factor'
                end
                object seSkill117PowerRate: TSpinEdit
                  Left = 83
                  Top = 19
                  Width = 51
                  Height = 21
                  Hint = 'The actual multiples equal to the current number of 100'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = seSkill117PowerRateChange
                end
              end
            end
            object TabSheet25: TTabSheet
              Caption = 'Frost group Rain'
              ImageIndex = 11
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox60: TGroupBox
                Left = 10
                Top = 9
                Width = 183
                Height = 133
                Caption = 'Skill Parameters'
                TabOrder = 0
                object Label143: TLabel
                  Left = 10
                  Top = 24
                  Width = 72
                  Height = 12
                  Caption = 'Power Factor'
                end
                object EditSkill71PowerRate: TSpinEdit
                  Left = 83
                  Top = 19
                  Width = 51
                  Height = 21
                  Hint = 'The actual number is divided by 100 equals the current multiples'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = EditSkill71PowerRateChange
                end
                object CheckBoxSkill71MbAttackMon: TCheckBox
                  Left = 10
                  Top = 46
                  Width = 135
                  Height = 17
                  Caption = 'Allow Para Monster'
                  TabOrder = 1
                  OnClick = CheckBoxSkill71MbAttackMonClick
                end
                object CheckBoxSkill71MbAttackHuman: TCheckBox
                  Left = 10
                  Top = 66
                  Width = 135
                  Height = 17
                  Caption = 'Allow Para Figures'
                  TabOrder = 2
                  OnClick = CheckBoxSkill71MbAttackHumanClick
                end
                object CheckBoxSkill71MbAttackSlave: TCheckBox
                  Left = 10
                  Top = 87
                  Width = 107
                  Height = 17
                  Caption = 'Allow Palsy'
                  TabOrder = 3
                  OnClick = CheckBoxSkill71MbAttackSlaveClick
                end
                object CheckBoxSkill71MbFastParalysis: TCheckBox
                  Left = 10
                  Top = 107
                  Width = 107
                  Height = 17
                  Hint = 
                    'When the character or monster paralyzed the skills, whether it b' +
                    'e attacked immediately cancel paralysis.'
                  Caption = 'Allow Rapid Para'
                  TabOrder = 4
                  OnClick = CheckBoxSkill71MbFastParalysisClick
                end
              end
            end
          end
        end
        object TabSheet15: TTabSheet
          Caption = 'Taoist'
          ImageIndex = 3
          object PageControl4: TPageControl
            Left = 3
            Top = 3
            Width = 432
            Height = 236
            ActivePage = TabSheet16
            TabOrder = 0
            object TabSheet16: TTabSheet
              Caption = 'Shi Poison'
              object GroupBox16: TGroupBox
                Left = 8
                Top = 8
                Width = 137
                Height = 49
                Caption = 'PSN Drop Points'
                TabOrder = 0
                object Label11: TLabel
                  Left = 8
                  Top = 18
                  Width = 60
                  Height = 12
                  Caption = 'Ctrl Point'
                end
                object EditAmyOunsulPoint: TSpinEdit
                  Left = 74
                  Top = 15
                  Width = 53
                  Height = 21
                  Hint = 
                    'Within a specified time after the poisoning drop points, the act' +
                    'ual number of points with the skill level and the level of infor' +
                    'mation about itself Taoism, this parameter is only tune which al' +
                    'gorithm parameters, the smaller the number, the greater the numb' +
                    'er of points.'
                  EditorEnabled = False
                  MaxValue = 100
                  MinValue = 1
                  TabOrder = 0
                  Value = 10
                  OnChange = EditAmyOunsulPointChange
                end
              end
            end
            object TabSheet18: TTabSheet
              Caption = 'Summon Skeleton'
              ImageIndex = 1
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox5: TGroupBox
                Left = 5
                Top = 2
                Width = 124
                Height = 204
                Caption = 'Basic Settings'
                TabOrder = 0
                object Label2: TLabel
                  Left = 8
                  Top = 18
                  Width = 78
                  Height = 12
                  Caption = 'Monster Name:'
                end
                object Label3: TLabel
                  Left = 8
                  Top = 58
                  Width = 48
                  Height = 12
                  Caption = 'Call No:'
                end
                object EditBoneFammName: TEdit
                  Left = 8
                  Top = 32
                  Width = 105
                  Height = 20
                  Hint = #35774#32622#40664#35748#21484#21796#30340#24618#29289#21517#31216#12290
                  TabOrder = 0
                  OnChange = EditBoneFammNameChange
                end
                object EditBoneFammCount: TSpinEdit
                  Left = 60
                  Top = 55
                  Width = 53
                  Height = 21
                  Hint = 'Setting the maximum number of calls.'
                  EditorEnabled = False
                  MaxValue = 255
                  MinValue = 1
                  TabOrder = 1
                  Value = 10
                  OnChange = EditBoneFammCountChange
                end
              end
              object GroupBox6: TGroupBox
                Left = 135
                Top = 2
                Width = 284
                Height = 204
                Caption = 'Advanced Settings'
                TabOrder = 1
                object GridBoneFamm: TStringGrid
                  Left = 8
                  Top = 16
                  Width = 265
                  Height = 177
                  ColCount = 4
                  DefaultRowHeight = 18
                  FixedCols = 0
                  RowCount = 11
                  Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
                  TabOrder = 0
                  OnSetEditText = GridBoneFammSetEditText
                  ColWidths = (
                    55
                    76
                    57
                    52)
                end
              end
            end
            object TabSheet19: TTabSheet
              Caption = 'Call animal'
              ImageIndex = 2
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox11: TGroupBox
                Left = 5
                Top = 2
                Width = 124
                Height = 204
                Caption = 'Basic Settings'
                TabOrder = 0
                object Label5: TLabel
                  Left = 8
                  Top = 18
                  Width = 78
                  Height = 12
                  Caption = 'Monster Name:'
                end
                object Label6: TLabel
                  Left = 8
                  Top = 58
                  Width = 42
                  Height = 12
                  Caption = 'Call No'
                end
                object EditDogzName: TEdit
                  Left = 8
                  Top = 32
                  Width = 105
                  Height = 20
                  TabOrder = 0
                  OnChange = EditDogzNameChange
                end
                object EditDogzCount: TSpinEdit
                  Left = 60
                  Top = 55
                  Width = 53
                  Height = 21
                  Hint = 'Setting the maximum number of calls.'
                  EditorEnabled = False
                  MaxValue = 255
                  MinValue = 1
                  TabOrder = 1
                  Value = 10
                  OnChange = EditDogzCountChange
                end
              end
              object GroupBox12: TGroupBox
                Left = 135
                Top = 2
                Width = 284
                Height = 204
                Caption = 'Advanced Setting'
                TabOrder = 1
                object GridDogz: TStringGrid
                  Left = 8
                  Top = 16
                  Width = 265
                  Height = 179
                  ColCount = 4
                  DefaultRowHeight = 18
                  FixedCols = 0
                  RowCount = 11
                  Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
                  TabOrder = 0
                  OnSetEditText = GridBoneFammSetEditText
                  ColWidths = (
                    55
                    76
                    57
                    52)
                end
              end
            end
            object TabSheet31: TTabSheet
              Caption = 'Summon Spirit month'
              ImageIndex = 9
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox67: TGroupBox
                Left = 5
                Top = 2
                Width = 124
                Height = 204
                Caption = 'Basic Settings'
                TabOrder = 0
                object Label161: TLabel
                  Left = 8
                  Top = 18
                  Width = 78
                  Height = 12
                  Caption = 'Monster Name:'
                end
                object Label162: TLabel
                  Left = 8
                  Top = 58
                  Width = 42
                  Height = 12
                  Caption = 'Call No'
                end
                object EditMoonSpiritName: TEdit
                  Left = 8
                  Top = 32
                  Width = 105
                  Height = 20
                  Hint = #35774#32622#40664#35748#21484#21796#30340#24618#29289#21517#31216#12290
                  TabOrder = 0
                  OnChange = EditDogzNameChange
                end
                object EditMoonSpiritCount: TSpinEdit
                  Left = 60
                  Top = 55
                  Width = 53
                  Height = 21
                  Hint = 'Setting the maximum number of calls.'
                  EditorEnabled = False
                  MaxValue = 255
                  MinValue = 1
                  TabOrder = 1
                  Value = 10
                  OnChange = EditMoonSpiritCountChange
                end
              end
              object GroupBox68: TGroupBox
                Left = 135
                Top = 2
                Width = 284
                Height = 204
                Caption = 'Advanced Settings'
                TabOrder = 1
                object GridMoonSpirit: TStringGrid
                  Left = 8
                  Top = 16
                  Width = 265
                  Height = 179
                  ColCount = 4
                  DefaultRowHeight = 18
                  FixedCols = 0
                  RowCount = 11
                  Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
                  TabOrder = 0
                  OnSetEditText = GridBoneFammSetEditText
                  ColWidths = (
                    55
                    76
                    57
                    52)
                end
              end
            end
            object TabSheet20: TTabSheet
              Caption = 'Fire Ice'
              ImageIndex = 3
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox41: TGroupBox
                Left = 8
                Top = 8
                Width = 145
                Height = 73
                Caption = 'Class Probability '
                TabOrder = 0
                object Label101: TLabel
                  Left = 8
                  Top = 18
                  Width = 60
                  Height = 12
                  Caption = 'Difference'
                end
                object Label102: TLabel
                  Left = 8
                  Top = 42
                  Width = 72
                  Height = 12
                  Caption = 'Restrictions'
                end
                object EditMabMabeHitRandRate: TSpinEdit
                  Left = 89
                  Top = 12
                  Width = 53
                  Height = 21
                  Hint = 
                    'Difference between the level of attack was to attack both hit pr' +
                    'obability, the larger the number the smaller the chance.'
                  EditorEnabled = False
                  MaxValue = 20
                  MinValue = 1
                  TabOrder = 0
                  Value = 10
                  OnChange = EditMabMabeHitRandRateChange
                end
                object EditMabMabeHitMinLvLimit: TSpinEdit
                  Left = 89
                  Top = 39
                  Width = 53
                  Height = 21
                  Hint = 
                    'Difference between the level of attack was to attack both hit pr' +
                    'obability, the minimum limit, the lower the number the smaller t' +
                    'he probability.'
                  EditorEnabled = False
                  MaxValue = 20
                  MinValue = 1
                  TabOrder = 1
                  Value = 10
                  OnChange = EditMabMabeHitMinLvLimitChange
                end
              end
              object GroupBox43: TGroupBox
                Left = 160
                Top = 8
                Width = 185
                Height = 49
                Caption = 'Paralysis Time Magnification'
                TabOrder = 1
                object Label104: TLabel
                  Left = 8
                  Top = 18
                  Width = 90
                  Height = 12
                  Caption = 'Hit Probability'
                end
                object EditMabMabeHitMabeTimeRate: TSpinEdit
                  Left = 104
                  Top = 15
                  Width = 53
                  Height = 21
                  Hint = 
                    'Paralysis length of time magnification, base and role of magic r' +
                    'elated.'
                  EditorEnabled = False
                  MaxValue = 20
                  MinValue = 1
                  TabOrder = 0
                  Value = 10
                  OnChange = EditMabMabeHitMabeTimeRateChange
                end
              end
              object GroupBox42: TGroupBox
                Left = 8
                Top = 88
                Width = 193
                Height = 49
                Caption = 'Para Hit Porbability'
                TabOrder = 2
                object Label103: TLabel
                  Left = 8
                  Top = 18
                  Width = 90
                  Height = 12
                  Caption = 'Hit Probability'
                end
                object EditMabMabeHitSucessRate: TSpinEdit
                  Left = 104
                  Top = 15
                  Width = 53
                  Height = 21
                  Hint = 
                    'Paralysis attack probability, the minimum limit, the lower the n' +
                    'umber the smaller the probability.'
                  EditorEnabled = False
                  MaxValue = 20
                  MinValue = 0
                  TabOrder = 0
                  Value = 10
                  OnChange = EditMabMabeHitSucessRateChange
                end
              end
            end
            object TabSheet32: TTabSheet
              Caption = 'Crack rune'
              ImageIndex = 10
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
            end
            object ts9: TTabSheet
              Caption = 'Tigers decision'
              ImageIndex = 4
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object grp11: TGroupBox
                Left = 10
                Top = 9
                Width = 151
                Height = 50
                Caption = 'Skill Parameter'
                TabOrder = 0
                object lbl11: TLabel
                  Left = 10
                  Top = 24
                  Width = 72
                  Height = 12
                  Caption = 'Power Factor'
                end
                object seSkill118PowerRate: TSpinEdit
                  Left = 83
                  Top = 19
                  Width = 51
                  Height = 21
                  Hint = 'The actual multiples equal to the current number of 100'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = seSkill118PowerRateChange
                end
              end
            end
            object ts10: TTabSheet
              Caption = 'Bagua'
              ImageIndex = 5
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object grp12: TGroupBox
                Left = 10
                Top = 9
                Width = 151
                Height = 50
                Caption = 'Skill Parameters'
                TabOrder = 0
                object lbl12: TLabel
                  Left = 10
                  Top = 24
                  Width = 78
                  Height = 12
                  Caption = 'Power Factor:'
                end
                object seSkill119PowerRate: TSpinEdit
                  Left = 91
                  Top = 19
                  Width = 51
                  Height = 21
                  Hint = 'The actual multiples equal to the current number of 100'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = seSkill119PowerRateChange
                end
              end
            end
            object ts11: TTabSheet
              Caption = 'Three flame curse'
              ImageIndex = 6
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object grp13: TGroupBox
                Left = 10
                Top = 9
                Width = 151
                Height = 50
                Caption = 'Skill Parameters'
                TabOrder = 0
                object lbl13: TLabel
                  Left = 10
                  Top = 24
                  Width = 78
                  Height = 12
                  Caption = 'Power Factor:'
                end
                object seSkill120PowerRate: TSpinEdit
                  Left = 91
                  Top = 19
                  Width = 51
                  Height = 21
                  Hint = 'The actual multiples equal to the current number of 100'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = seSkill120PowerRateChange
                end
              end
            end
            object ts12: TTabSheet
              Caption = 'Wan Jian Zong return'
              ImageIndex = 7
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object grp14: TGroupBox
                Left = 10
                Top = 9
                Width = 175
                Height = 50
                Caption = 'Skill Parameters'
                TabOrder = 0
                object lbl14: TLabel
                  Left = 10
                  Top = 24
                  Width = 78
                  Height = 12
                  Caption = 'Power Factor:'
                end
                object seSkill121PowerRate: TSpinEdit
                  Left = 91
                  Top = 19
                  Width = 51
                  Height = 21
                  Hint = 'The actual multiples equal to the current number of 100'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = seSkill121PowerRateChange
                end
              end
            end
            object TabSheet26: TTabSheet
              Caption = 'Eye of Death'
              ImageIndex = 8
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox61: TGroupBox
                Left = 10
                Top = 9
                Width = 207
                Height = 174
                Caption = 'Skill Parameters'
                TabOrder = 0
                object Label144: TLabel
                  Left = 9
                  Top = 22
                  Width = 78
                  Height = 12
                  Caption = 'Power Factor:'
                end
                object EditSkill72PowerRate: TSpinEdit
                  Left = 99
                  Top = 19
                  Width = 51
                  Height = 21
                  Hint = 'The actual number is divided by 100 equals the current multiples'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = EditSkill72PowerRateChange
                end
                object CheckBoxSkill72MbAttackMon: TCheckBox
                  Left = 10
                  Top = 46
                  Width = 140
                  Height = 17
                  Caption = 'Allow Para Monster'
                  TabOrder = 1
                  OnClick = CheckBoxSkill72MbAttackMonClick
                end
                object CheckBoxSkill72MbAttackHuman: TCheckBox
                  Left = 10
                  Top = 66
                  Width = 140
                  Height = 17
                  Caption = 'Allow Para Figures'
                  TabOrder = 2
                  OnClick = CheckBoxSkill72MbAttackHumanClick
                end
                object CheckBoxSkill72MbAttackSlave: TCheckBox
                  Left = 10
                  Top = 87
                  Width = 107
                  Height = 17
                  Caption = 'Allow Palsy'
                  TabOrder = 3
                  OnClick = CheckBoxSkill72MbAttackSlaveClick
                end
                object CheckBoxSkill72Damagearmor: TCheckBox
                  Left = 10
                  Top = 107
                  Width = 107
                  Height = 17
                  Caption = 'Allow Red PSN'
                  TabOrder = 4
                  OnClick = CheckBoxSkill72DamagearmorClick
                end
                object CheckBoxSkill72DecHealth: TCheckBox
                  Left = 10
                  Top = 127
                  Width = 119
                  Height = 17
                  Caption = 'Allow Green PSN'
                  TabOrder = 5
                  OnClick = CheckBoxSkill72DecHealthClick
                end
                object CheckBoxSkill72MbFastParalysis: TCheckBox
                  Left = 10
                  Top = 150
                  Width = 159
                  Height = 17
                  Hint = 
                    'When the character or monster paralyzed the skills, whether it b' +
                    'e attacked immediately cancel paralysis.'
                  Caption = 'Allow Rapid Paralysis'
                  TabOrder = 6
                  OnClick = CheckBoxSkill72MbFastParalysisClick
                end
              end
            end
          end
        end
        object TabSheet28: TTabSheet
          Caption = 'Generic'
          ImageIndex = 4
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object PageControl1: TPageControl
            Left = 3
            Top = 3
            Width = 432
            Height = 236
            ActivePage = TabSheet29
            TabOrder = 0
            object TabSheet29: TTabSheet
              Caption = 'Aegis'
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox69: TGroupBox
                Left = 8
                Top = 8
                Width = 319
                Height = 130
                Caption = 'Skill Parameters'
                TabOrder = 0
                object Label163: TLabel
                  Left = 8
                  Top = 21
                  Width = 126
                  Height = 12
                  Caption = 'Skill Lvl0 Trig Prob:'
                end
                object Label164: TLabel
                  Left = 190
                  Top = 21
                  Width = 60
                  Height = 12
                  Caption = '%OffSetDmg'
                end
                object Label165: TLabel
                  Left = 303
                  Top = 21
                  Width = 6
                  Height = 12
                  Caption = '%'
                end
                object Label166: TLabel
                  Left = 8
                  Top = 48
                  Width = 126
                  Height = 12
                  Caption = 'Skill Lvl1 Trig Prob:'
                end
                object Label167: TLabel
                  Left = 190
                  Top = 48
                  Width = 60
                  Height = 12
                  Caption = '%OffSetDmg'
                end
                object Label168: TLabel
                  Left = 303
                  Top = 48
                  Width = 6
                  Height = 12
                  Caption = '%'
                end
                object Label169: TLabel
                  Left = 8
                  Top = 75
                  Width = 126
                  Height = 12
                  Caption = 'Skill Lvl2 Trig Prob:'
                end
                object Label170: TLabel
                  Left = 190
                  Top = 75
                  Width = 60
                  Height = 12
                  Caption = '%OffSetDmg'
                end
                object Label171: TLabel
                  Left = 303
                  Top = 75
                  Width = 6
                  Height = 12
                  Caption = '%'
                end
                object Label172: TLabel
                  Left = 8
                  Top = 102
                  Width = 126
                  Height = 12
                  Caption = 'Skill Lvl3 Trig Prob:'
                end
                object Label173: TLabel
                  Left = 190
                  Top = 102
                  Width = 60
                  Height = 12
                  Caption = '%OffSetDmg'
                end
                object Label174: TLabel
                  Left = 303
                  Top = 102
                  Width = 6
                  Height = 12
                  Caption = '%'
                end
                object EditProtectShieldRunRate0: TSpinEdit
                  Left = 143
                  Top = 18
                  Width = 41
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 100
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = EditProtectShieldRunRate0Change
                end
                object EditProtectShieldDelDamage0: TSpinEdit
                  Left = 256
                  Top = 18
                  Width = 41
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 100
                  MinValue = 1
                  TabOrder = 1
                  Value = 100
                  OnChange = EditProtectShieldDelDamage0Change
                end
                object EditProtectShieldRunRate1: TSpinEdit
                  Left = 143
                  Top = 45
                  Width = 41
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 100
                  MinValue = 1
                  TabOrder = 2
                  Value = 100
                  OnChange = EditProtectShieldRunRate1Change
                end
                object EditProtectShieldDelDamage1: TSpinEdit
                  Left = 256
                  Top = 45
                  Width = 41
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 100
                  MinValue = 1
                  TabOrder = 3
                  Value = 100
                  OnChange = EditProtectShieldDelDamage1Change
                end
                object EditProtectShieldRunRate2: TSpinEdit
                  Left = 143
                  Top = 72
                  Width = 41
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 100
                  MinValue = 1
                  TabOrder = 4
                  Value = 100
                  OnChange = EditProtectShieldRunRate2Change
                end
                object EditProtectShieldDelDamage2: TSpinEdit
                  Left = 256
                  Top = 72
                  Width = 41
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 100
                  MinValue = 1
                  TabOrder = 5
                  Value = 100
                  OnChange = EditProtectShieldDelDamage2Change
                end
                object EditProtectShieldRunRate3: TSpinEdit
                  Left = 143
                  Top = 99
                  Width = 41
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 100
                  MinValue = 1
                  TabOrder = 6
                  Value = 100
                  OnChange = EditProtectShieldRunRate3Change
                end
                object EditProtectShieldDelDamage3: TSpinEdit
                  Left = 256
                  Top = 99
                  Width = 41
                  Height = 21
                  EditorEnabled = False
                  MaxValue = 100
                  MinValue = 1
                  TabOrder = 7
                  Value = 100
                  OnChange = EditProtectShieldDelDamage3Change
                end
              end
            end
            object TabSheet30: TTabSheet
              Caption = 'Metin '
              ImageIndex = 1
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object GroupBox65: TGroupBox
                Left = 8
                Top = 8
                Width = 145
                Height = 49
                Caption = 'Attack Range'
                TabOrder = 0
                object Label145: TLabel
                  Left = 8
                  Top = 21
                  Width = 36
                  Height = 12
                  Caption = 'Range:'
                end
                object EditEtenMagicSize: TSpinEdit
                  Left = 68
                  Top = 18
                  Width = 53
                  Height = 21
                  Hint = 
                    'Effective distance magic attack, more than a specified distance ' +
                    'attacks ineffective.'
                  EditorEnabled = False
                  MaxValue = 10
                  MinValue = 1
                  TabOrder = 0
                  Value = 10
                  OnChange = EditEtenMagicSizeChange
                end
              end
              object GroupBox66: TGroupBox
                Left = 8
                Top = 64
                Width = 161
                Height = 50
                Caption = 'Skill Parameters'
                TabOrder = 1
                object Label146: TLabel
                  Left = 8
                  Top = 24
                  Width = 78
                  Height = 12
                  Caption = 'Power Factor:'
                end
                object EditEtenPowerRate: TSpinEdit
                  Left = 84
                  Top = 19
                  Width = 53
                  Height = 21
                  Hint = 'The actual multiples equal to the current number of 100'
                  MaxValue = 10000
                  MinValue = 1
                  TabOrder = 0
                  Value = 100
                  OnChange = EditEtenPowerRateChange
                end
              end
            end
          end
        end
      end
    end
    object TabSheet34: TTabSheet
      Caption = 'Upgrade Weapons'
      ImageIndex = 6
      ExplicitLeft = 2
      ExplicitTop = 64
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox8: TGroupBox
        Left = 8
        Top = 8
        Width = 161
        Height = 121
        Caption = 'Basic'
        TabOrder = 0
        object Label13: TLabel
          Left = 8
          Top = 18
          Width = 60
          Height = 12
          Caption = 'No Points:'
        end
        object Label15: TLabel
          Left = 8
          Top = 42
          Width = 30
          Height = 12
          Caption = 'Cost:'
        end
        object Label16: TLabel
          Left = 8
          Top = 66
          Width = 54
          Height = 12
          Caption = 'Time Req:'
        end
        object Label17: TLabel
          Left = 8
          Top = 90
          Width = 48
          Height = 12
          Caption = 'Expires:'
        end
        object Label18: TLabel
          Left = 136
          Top = 65
          Width = 18
          Height = 12
          Caption = 'Sec'
        end
        object Label19: TLabel
          Left = 136
          Top = 89
          Width = 24
          Height = 12
          Caption = 'Days'
        end
        object EditUpgradeWeaponMaxPoint: TSpinEdit
          Left = 68
          Top = 15
          Width = 61
          Height = 21
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditUpgradeWeaponMaxPointChange
        end
        object EditUpgradeWeaponPrice: TSpinEdit
          Left = 68
          Top = 39
          Width = 61
          Height = 21
          EditorEnabled = False
          MaxValue = 1000000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditUpgradeWeaponPriceChange
        end
        object EditUPgradeWeaponGetBackTime: TSpinEdit
          Left = 68
          Top = 63
          Width = 61
          Height = 21
          EditorEnabled = False
          MaxValue = 36000000
          MinValue = 1
          TabOrder = 2
          Value = 10
          OnChange = EditUPgradeWeaponGetBackTimeChange
        end
        object EditClearExpireUpgradeWeaponDays: TSpinEdit
          Left = 68
          Top = 87
          Width = 61
          Height = 21
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 3
          Value = 10
          OnChange = EditClearExpireUpgradeWeaponDaysChange
        end
      end
      object GroupBox18: TGroupBox
        Left = 176
        Top = 8
        Width = 265
        Height = 89
        Caption = 'DC Upgrade'
        TabOrder = 1
        object Label20: TLabel
          Left = 8
          Top = 18
          Width = 60
          Height = 12
          Caption = '1 Chances:'
        end
        object Label21: TLabel
          Left = 8
          Top = 42
          Width = 60
          Height = 12
          Caption = '2 Chances:'
        end
        object Label22: TLabel
          Left = 8
          Top = 66
          Width = 60
          Height = 12
          Caption = '3 Chances:'
        end
        object ScrollBarUpgradeWeaponDCRate: TScrollBar
          Left = 64
          Top = 16
          Width = 145
          Height = 17
          Hint = 
            'Upgrade Attack Points probability of success, the probability fo' +
            'r the left and right big small.'
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarUpgradeWeaponDCRateChange
        end
        object EditUpgradeWeaponDCRate: TEdit
          Left = 216
          Top = 16
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarUpgradeWeaponDCTwoPointRate: TScrollBar
          Left = 64
          Top = 40
          Width = 145
          Height = 17
          Hint = 
            'Get two o'#39'clock attribute probability, the probability for the l' +
            'eft and right big small.'
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarUpgradeWeaponDCTwoPointRateChange
        end
        object EditUpgradeWeaponDCTwoPointRate: TEdit
          Left = 216
          Top = 40
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarUpgradeWeaponDCThreePointRate: TScrollBar
          Left = 64
          Top = 64
          Width = 145
          Height = 17
          Hint = 
            'Get three attributes probability, the probability for the left a' +
            'nd right big small.'
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarUpgradeWeaponDCThreePointRateChange
        end
        object EditUpgradeWeaponDCThreePointRate: TEdit
          Left = 216
          Top = 64
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
      end
      object GroupBox19: TGroupBox
        Left = 175
        Top = 96
        Width = 265
        Height = 97
        Caption = 'SC Upgrade'
        TabOrder = 2
        object Label23: TLabel
          Left = 8
          Top = 18
          Width = 60
          Height = 12
          Caption = '1 Chances:'
        end
        object Label24: TLabel
          Left = 8
          Top = 42
          Width = 60
          Height = 12
          Caption = '2 Chances:'
        end
        object Label25: TLabel
          Left = 8
          Top = 66
          Width = 60
          Height = 12
          Caption = '3 Chances:'
        end
        object ScrollBarUpgradeWeaponSCRate: TScrollBar
          Left = 64
          Top = 16
          Width = 145
          Height = 17
          Hint = 
            'Upgrade Taoism points probability of success, the probability fo' +
            'r the left and right big small.'
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarUpgradeWeaponSCRateChange
        end
        object EditUpgradeWeaponSCRate: TEdit
          Left = 216
          Top = 16
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarUpgradeWeaponSCTwoPointRate: TScrollBar
          Left = 64
          Top = 40
          Width = 145
          Height = 17
          Hint = 
            'Get two o'#39'clock attribute probability, the probability for the l' +
            'eft and right big small.'
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarUpgradeWeaponSCTwoPointRateChange
        end
        object EditUpgradeWeaponSCTwoPointRate: TEdit
          Left = 216
          Top = 40
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarUpgradeWeaponSCThreePointRate: TScrollBar
          Left = 64
          Top = 64
          Width = 145
          Height = 17
          Hint = 
            'Get three attributes probability, the probability for the left a' +
            'nd right big small.'
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarUpgradeWeaponSCThreePointRateChange
        end
        object EditUpgradeWeaponSCThreePointRate: TEdit
          Left = 216
          Top = 64
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
      end
      object GroupBox20: TGroupBox
        Left = 175
        Top = 189
        Width = 265
        Height = 89
        Caption = 'MC Upgrade'
        TabOrder = 3
        object Label26: TLabel
          Left = 8
          Top = 18
          Width = 60
          Height = 12
          Caption = '1 Chances:'
        end
        object Label27: TLabel
          Left = 8
          Top = 42
          Width = 60
          Height = 12
          Caption = '2 Chances:'
        end
        object Label28: TLabel
          Left = 8
          Top = 66
          Width = 60
          Height = 12
          Caption = '3 Chances:'
        end
        object ScrollBarUpgradeWeaponMCRate: TScrollBar
          Left = 64
          Top = 16
          Width = 145
          Height = 17
          Hint = 
            'Upgrade magic points probability of success, the probability for' +
            ' the left and right big small.'
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarUpgradeWeaponMCRateChange
        end
        object EditUpgradeWeaponMCRate: TEdit
          Left = 216
          Top = 16
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarUpgradeWeaponMCTwoPointRate: TScrollBar
          Left = 64
          Top = 40
          Width = 145
          Height = 17
          Hint = 
            'Get two o'#39'clock attribute probability, the probability for the l' +
            'eft and right big small.'
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarUpgradeWeaponMCTwoPointRateChange
        end
        object EditUpgradeWeaponMCTwoPointRate: TEdit
          Left = 216
          Top = 40
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarUpgradeWeaponMCThreePointRate: TScrollBar
          Left = 64
          Top = 64
          Width = 145
          Height = 17
          Hint = 
            'Get three attributes probability, the probability for the left a' +
            'nd right big small.'
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarUpgradeWeaponMCThreePointRateChange
        end
        object EditUpgradeWeaponMCThreePointRate: TEdit
          Left = 216
          Top = 64
          Width = 41
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
      end
      object ButtonUpgradeWeaponSave: TButton
        Left = 8
        Top = 258
        Width = 65
        Height = 20
        Caption = 'Save(&S)'
        TabOrder = 4
        OnClick = ButtonUpgradeWeaponSaveClick
      end
      object ButtonUpgradeWeaponDefaulf: TButton
        Left = 79
        Top = 258
        Width = 65
        Height = 20
        Caption = 'Default(&D)'
        TabOrder = 5
        OnClick = ButtonUpgradeWeaponDefaulfClick
      end
    end
    object TabSheet35: TTabSheet
      Caption = 'Mining Control'
      ImageIndex = 7
      ExplicitLeft = 2
      ExplicitTop = 52
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox24: TGroupBox
        Left = 8
        Top = 8
        Width = 273
        Height = 60
        Caption = 'Get Ore Probability'
        TabOrder = 0
        object Label32: TLabel
          Left = 8
          Top = 18
          Width = 66
          Height = 12
          Caption = 'Hit Chance:'
        end
        object Label33: TLabel
          Left = 8
          Top = 36
          Width = 72
          Height = 12
          Caption = 'Mining Prob:'
        end
        object ScrollBarMakeMineHitRate: TScrollBar
          Left = 73
          Top = 15
          Width = 129
          Height = 15
          Hint = 'The smaller the number the greater the chance of setting.'
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarMakeMineHitRateChange
        end
        object EditMakeMineHitRate: TEdit
          Left = 208
          Top = 16
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarMakeMineRate: TScrollBar
          Left = 73
          Top = 36
          Width = 128
          Height = 15
          Hint = 'The smaller the number the greater the chance of setting.'
          Max = 500
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarMakeMineRateChange
        end
        object EditMakeMineRate: TEdit
          Left = 208
          Top = 36
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
      end
      object GroupBox25: TGroupBox
        Left = 8
        Top = 72
        Width = 273
        Height = 217
        Caption = 'Probability Ore Types'
        TabOrder = 1
        object Label34: TLabel
          Left = 8
          Top = 18
          Width = 66
          Height = 12
          Caption = 'Ore Factor:'
        end
        object Label35: TLabel
          Left = 8
          Top = 38
          Width = 30
          Height = 12
          Caption = 'Gold:'
        end
        object Label36: TLabel
          Left = 8
          Top = 56
          Width = 42
          Height = 12
          Caption = 'Silver:'
        end
        object Label37: TLabel
          Left = 8
          Top = 76
          Width = 42
          Height = 12
          Caption = 'Copper:'
        end
        object Label38: TLabel
          Left = 8
          Top = 96
          Width = 54
          Height = 12
          Caption = 'BIO Rate:'
          Visible = False
        end
        object ScrollBarStoneTypeRate: TScrollBar
          Left = 72
          Top = 16
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarStoneTypeRateChange
        end
        object EditStoneTypeRate: TEdit
          Left = 208
          Top = 16
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarGoldStoneMax: TScrollBar
          Left = 72
          Top = 36
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarGoldStoneMaxChange
        end
        object EditGoldStoneMax: TEdit
          Left = 208
          Top = 36
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarSilverStoneMax: TScrollBar
          Left = 72
          Top = 56
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarSilverStoneMaxChange
        end
        object EditSilverStoneMax: TEdit
          Left = 208
          Top = 56
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
        object ScrollBarSteelStoneMax: TScrollBar
          Left = 72
          Top = 76
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 6
          OnChange = ScrollBarSteelStoneMaxChange
        end
        object EditSteelStoneMax: TEdit
          Left = 208
          Top = 76
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 7
        end
        object EditBlackStoneMax: TEdit
          Left = 208
          Top = 96
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 8
          Visible = False
        end
        object ScrollBarBlackStoneMax: TScrollBar
          Left = 72
          Top = 96
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 9
          Visible = False
          OnChange = ScrollBarBlackStoneMaxChange
        end
      end
      object ButtonMakeMineSave: TButton
        Left = 367
        Top = 256
        Width = 65
        Height = 22
        Caption = 'Save(&S)'
        TabOrder = 2
        OnClick = ButtonMakeMineSaveClick
      end
      object GroupBox26: TGroupBox
        Left = 288
        Top = 8
        Width = 153
        Height = 121
        Caption = 'Ore Quality'
        TabOrder = 3
        object Label39: TLabel
          Left = 8
          Top = 18
          Width = 78
          Height = 12
          Caption = 'Minimum Qaul:'
        end
        object Label40: TLabel
          Left = 8
          Top = 42
          Width = 84
          Height = 12
          Caption = 'Ordinary Qual:'
        end
        object Label41: TLabel
          Left = 8
          Top = 66
          Width = 90
          Height = 12
          Caption = 'High Qaul Chnc:'
        end
        object Label42: TLabel
          Left = 8
          Top = 90
          Width = 78
          Height = 12
          Caption = 'High Quality:'
        end
        object EditStoneMinDura: TSpinEdit
          Left = 92
          Top = 15
          Width = 45
          Height = 21
          Hint = 'Ore occurs lowest quality points.'
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditStoneMinDuraChange
        end
        object EditStoneGeneralDuraRate: TSpinEdit
          Left = 92
          Top = 39
          Width = 45
          Height = 21
          Hint = 'Ore quality random points range.'
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditStoneGeneralDuraRateChange
        end
        object EditStoneAddDuraRate: TSpinEdit
          Left = 92
          Top = 63
          Width = 45
          Height = 21
          Hint = 
            'Ore with high-quality points probability, high-quality products ' +
            'that can reach 20 or more points.'
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 2
          Value = 10
          OnChange = EditStoneAddDuraRateChange
        end
        object EditStoneAddDuraMax: TSpinEdit
          Left = 92
          Top = 87
          Width = 45
          Height = 21
          Hint = 'High-quality ore quality random points range.'
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 3
          Value = 10
          OnChange = EditStoneAddDuraMaxChange
        end
      end
      object ButtonMakeMineDefault: TButton
        Left = 296
        Top = 256
        Width = 65
        Height = 22
        Caption = 'Default(&D)'
        TabOrder = 4
        OnClick = ButtonMakeMineDefaultClick
      end
    end
    object TabSheet42: TTabSheet
      Caption = 'Blessing Oil'
      ImageIndex = 12
      ExplicitLeft = 0
      ExplicitTop = 42
      ExplicitWidth = 0
      ExplicitHeight = 299
      object GroupBox44: TGroupBox
        Left = 8
        Top = 8
        Width = 273
        Height = 143
        Caption = 'Probability Set'
        TabOrder = 0
        object Label105: TLabel
          Left = 8
          Top = 18
          Width = 66
          Height = 12
          Caption = 'Curse Prob:'
        end
        object Label106: TLabel
          Left = 8
          Top = 38
          Width = 54
          Height = 12
          Caption = '1 Points:'
        end
        object Label107: TLabel
          Left = 8
          Top = 56
          Width = 54
          Height = 12
          Caption = '2 Points:'
        end
        object Label108: TLabel
          Left = 8
          Top = 76
          Width = 60
          Height = 12
          Caption = '2 Chances:'
        end
        object Label109: TLabel
          Left = 8
          Top = 96
          Width = 54
          Height = 12
          Caption = '3 Points:'
        end
        object Label110: TLabel
          Left = 8
          Top = 116
          Width = 60
          Height = 12
          Caption = '3 Chances:'
        end
        object ScrollBarWeaponMakeUnLuckRate: TScrollBar
          Left = 72
          Top = 16
          Width = 129
          Height = 15
          Hint = 
            'Use blessing oil curse probability, the larger the number the sm' +
            'aller the chance.'
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarWeaponMakeUnLuckRateChange
        end
        object EditWeaponMakeUnLuckRate: TEdit
          Left = 208
          Top = 16
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarWeaponMakeLuckPoint1: TScrollBar
          Left = 72
          Top = 36
          Width = 129
          Height = 15
          Hint = 
            'Use blessing oil is 100% successful when small arms lucky point ' +
            'this point.'
          Max = 500
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarWeaponMakeLuckPoint1Change
        end
        object EditWeaponMakeLuckPoint1: TEdit
          Left = 207
          Top = 40
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarWeaponMakeLuckPoint2: TScrollBar
          Left = 72
          Top = 56
          Width = 129
          Height = 15
          Hint = 
            'Use blessing lucky point when oil weapon is less than this numbe' +
            'r of points specified probability decide whether to press the pl' +
            'us lucky.'
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarWeaponMakeLuckPoint2Change
        end
        object EditWeaponMakeLuckPoint2: TEdit
          Left = 208
          Top = 56
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
        object ScrollBarWeaponMakeLuckPoint2Rate: TScrollBar
          Left = 72
          Top = 76
          Width = 129
          Height = 15
          Hint = 
            'Probability points, the larger the number the smaller the chance' +
            '.'
          Max = 500
          PageSize = 0
          TabOrder = 6
          OnChange = ScrollBarWeaponMakeLuckPoint2RateChange
        end
        object EditWeaponMakeLuckPoint2Rate: TEdit
          Left = 208
          Top = 76
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 7
        end
        object EditWeaponMakeLuckPoint3: TEdit
          Left = 208
          Top = 96
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 8
        end
        object ScrollBarWeaponMakeLuckPoint3: TScrollBar
          Left = 72
          Top = 96
          Width = 129
          Height = 15
          Hint = 
            'Use blessing lucky point when oil weapon is less than this numbe' +
            'r of points specified probability decide whether to press the pl' +
            'us lucky.'
          Max = 500
          PageSize = 0
          TabOrder = 9
          OnChange = ScrollBarWeaponMakeLuckPoint3Change
        end
        object ScrollBarWeaponMakeLuckPoint3Rate: TScrollBar
          Left = 72
          Top = 116
          Width = 129
          Height = 15
          Hint = 
            'Probability points, the larger the number the smaller the chance' +
            '.'
          Max = 500
          PageSize = 0
          TabOrder = 10
          OnChange = ScrollBarWeaponMakeLuckPoint3RateChange
        end
        object EditWeaponMakeLuckPoint3Rate: TEdit
          Left = 208
          Top = 116
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 11
        end
      end
      object ButtonWeaponMakeLuckDefault: TButton
        Left = 305
        Top = 258
        Width = 65
        Height = 20
        Caption = 'Default(&D)'
        TabOrder = 1
        OnClick = ButtonWeaponMakeLuckDefaultClick
      end
      object ButtonWeaponMakeLuckSave: TButton
        Left = 376
        Top = 258
        Width = 65
        Height = 20
        Caption = 'Save(&S)'
        TabOrder = 2
        OnClick = ButtonWeaponMakeLuckSaveClick
      end
      object GroupBox58: TGroupBox
        Left = 287
        Top = 7
        Width = 143
        Height = 55
        Caption = 'Highest No Points'
        TabOrder = 3
        object Label141: TLabel
          Left = 12
          Top = 22
          Width = 72
          Height = 12
          Caption = 'Incr Points:'
        end
        object EditUnLuckMaxCount: TSpinEdit
          Left = 86
          Top = 19
          Width = 49
          Height = 21
          Hint = #35774#32622#31069#31119#27833#36798#21040#25351#23450#23450#25968#21518#25165'100%'#21457#25381#26368#22823#25915#20987#65292#40664#35748#20026' 7'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 1
          TabOrder = 0
          Value = 100
          OnChange = EditUnLuckMaxCountChange
        end
      end
    end
    object TabSheet37: TTabSheet
      Caption = 'Lottery Control'
      ImageIndex = 8
      ExplicitLeft = 0
      ExplicitTop = 42
      ExplicitWidth = 0
      ExplicitHeight = 299
      object GroupBox27: TGroupBox
        Left = 8
        Top = 8
        Width = 273
        Height = 169
        Caption = 'Chances of winning'
        TabOrder = 0
        object Label43: TLabel
          Left = 8
          Top = 42
          Width = 48
          Height = 12
          Caption = 'Prize 1:'
        end
        object Label44: TLabel
          Left = 8
          Top = 62
          Width = 48
          Height = 12
          Caption = 'Prize 2:'
        end
        object Label45: TLabel
          Left = 8
          Top = 80
          Width = 48
          Height = 12
          Caption = 'Prize 3:'
        end
        object Label46: TLabel
          Left = 8
          Top = 100
          Width = 48
          Height = 12
          Caption = 'Prize 4:'
        end
        object Label47: TLabel
          Left = 8
          Top = 120
          Width = 48
          Height = 12
          Caption = 'Prize 5:'
        end
        object Label48: TLabel
          Left = 8
          Top = 140
          Width = 48
          Height = 12
          Caption = 'Prize 6:'
        end
        object Label49: TLabel
          Left = 8
          Top = 18
          Width = 42
          Height = 12
          Caption = 'Factor:'
        end
        object ScrollBarWinLottery1Max: TScrollBar
          Left = 56
          Top = 40
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarWinLottery1MaxChange
        end
        object EditWinLottery1Max: TEdit
          Left = 192
          Top = 40
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarWinLottery2Max: TScrollBar
          Left = 56
          Top = 60
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarWinLottery2MaxChange
        end
        object EditWinLottery2Max: TEdit
          Left = 192
          Top = 60
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarWinLottery3Max: TScrollBar
          Left = 56
          Top = 80
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarWinLottery3MaxChange
        end
        object EditWinLottery3Max: TEdit
          Left = 192
          Top = 80
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
        object ScrollBarWinLottery4Max: TScrollBar
          Left = 56
          Top = 100
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 6
          OnChange = ScrollBarWinLottery4MaxChange
        end
        object EditWinLottery4Max: TEdit
          Left = 192
          Top = 100
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 7
        end
        object EditWinLottery5Max: TEdit
          Left = 192
          Top = 120
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 8
        end
        object ScrollBarWinLottery5Max: TScrollBar
          Left = 56
          Top = 120
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 9
          OnChange = ScrollBarWinLottery5MaxChange
        end
        object ScrollBarWinLottery6Max: TScrollBar
          Left = 56
          Top = 140
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 10
          OnChange = ScrollBarWinLottery6MaxChange
        end
        object EditWinLottery6Max: TEdit
          Left = 192
          Top = 140
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 11
        end
        object EditWinLotteryRate: TEdit
          Left = 192
          Top = 16
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 12
        end
        object ScrollBarWinLotteryRate: TScrollBar
          Left = 56
          Top = 16
          Width = 129
          Height = 15
          Max = 100000
          PageSize = 0
          TabOrder = 13
          OnChange = ScrollBarWinLotteryRateChange
        end
      end
      object GroupBox28: TGroupBox
        Left = 288
        Top = 8
        Width = 145
        Height = 169
        Caption = 'Bonus'
        TabOrder = 1
        object Label50: TLabel
          Left = 8
          Top = 18
          Width = 48
          Height = 12
          Caption = 'Prize 1:'
        end
        object Label51: TLabel
          Left = 8
          Top = 42
          Width = 48
          Height = 12
          Caption = 'Prize 2:'
        end
        object Label52: TLabel
          Left = 8
          Top = 66
          Width = 48
          Height = 12
          Caption = 'Prize 3:'
        end
        object Label53: TLabel
          Left = 8
          Top = 90
          Width = 48
          Height = 12
          Caption = 'Prize 4:'
        end
        object Label54: TLabel
          Left = 8
          Top = 114
          Width = 48
          Height = 12
          Caption = 'Prize 5:'
        end
        object Label55: TLabel
          Left = 8
          Top = 138
          Width = 48
          Height = 12
          Caption = 'Prize 6:'
        end
        object EditWinLottery1Gold: TSpinEdit
          Left = 56
          Top = 15
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 0
          Value = 100000000
          OnChange = EditWinLottery1GoldChange
        end
        object EditWinLottery2Gold: TSpinEdit
          Left = 56
          Top = 39
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditWinLottery2GoldChange
        end
        object EditWinLottery3Gold: TSpinEdit
          Left = 56
          Top = 63
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 2
          Value = 10
          OnChange = EditWinLottery3GoldChange
        end
        object EditWinLottery4Gold: TSpinEdit
          Left = 56
          Top = 87
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 3
          Value = 10
          OnChange = EditWinLottery4GoldChange
        end
        object EditWinLottery5Gold: TSpinEdit
          Left = 56
          Top = 111
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 4
          Value = 10
          OnChange = EditWinLottery5GoldChange
        end
        object EditWinLottery6Gold: TSpinEdit
          Left = 56
          Top = 135
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 5
          Value = 10
          OnChange = EditWinLottery6GoldChange
        end
      end
      object ButtonWinLotterySave: TButton
        Left = 376
        Top = 277
        Width = 65
        Height = 20
        Caption = #20445#23384'(&S)'
        ModalResult = 1
        TabOrder = 2
        OnClick = ButtonWinLotterySaveClick
      end
      object ButtonWinLotteryDefault: TButton
        Left = 296
        Top = 277
        Width = 65
        Height = 20
        Caption = #40664#35748'(&D)'
        TabOrder = 3
        OnClick = ButtonWinLotteryDefaultClick
      end
    end
    object TabSheet40: TTabSheet
      Caption = 'Prayer'
      ImageIndex = 11
      ExplicitLeft = 0
      ExplicitTop = 42
      ExplicitWidth = 0
      ExplicitHeight = 299
      object GroupBox36: TGroupBox
        Left = 8
        Top = 9
        Width = 193
        Height = 89
        Caption = 'Prayer Force'
        TabOrder = 0
        object Label94: TLabel
          Left = 11
          Top = 40
          Width = 60
          Height = 12
          Caption = 'Long Time:'
        end
        object Label96: TLabel
          Left = 11
          Top = 64
          Width = 42
          Height = 12
          Caption = 'Energy:'
          Enabled = False
        end
        object CheckBoxSpiritMutiny: TCheckBox
          Left = 8
          Top = 16
          Width = 182
          Height = 17
          Caption = 'Special Feature Enable Pray'
          TabOrder = 0
          OnClick = CheckBoxSpiritMutinyClick
        end
        object EditSpiritMutinyTime: TSpinEdit
          Left = 72
          Top = 36
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditSpiritMutinyTimeChange
        end
        object EditSpiritPowerRate: TSpinEdit
          Left = 72
          Top = 60
          Width = 49
          Height = 21
          EditorEnabled = False
          Enabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditSpiritPowerRateChange
        end
      end
      object ButtonSpiritMutinySave: TButton
        Left = 365
        Top = 245
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 1
        OnClick = ButtonSpiritMutinySaveClick
      end
    end
    object TabSheet14: TTabSheet
      Caption = 'Life Skills'
      ImageIndex = 10
      ExplicitLeft = 0
      ExplicitTop = 42
      ExplicitWidth = 0
      ExplicitHeight = 299
      object ButtonMakeMagicSave: TButton
        Left = 365
        Top = 253
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 0
        OnClick = ButtonMakeMagicSaveClick
      end
      object GroupBox1: TGroupBox
        Left = 183
        Top = 6
        Width = 186
        Height = 158
        Caption = 'Basic Parameters'
        TabOrder = 1
        object Label1: TLabel
          Left = 12
          Top = 22
          Width = 102
          Height = 12
          Caption = 'Incr No of Points'
        end
        object Label113: TLabel
          Left = 12
          Top = 49
          Width = 114
          Height = 12
          Caption = 'Consumption Points:'
        end
        object Label114: TLabel
          Left = 12
          Top = 76
          Width = 102
          Height = 12
          Caption = 'Incr Probability:'
        end
        object Label115: TLabel
          Left = 12
          Top = 103
          Width = 84
          Height = 12
          Caption = 'Highest Level:'
        end
        object lbl15: TLabel
          Left = 12
          Top = 129
          Width = 90
          Height = 12
          Caption = 'Starting Level:'
        end
        object EditMakeMagicAddPoint: TSpinEdit
          Left = 120
          Top = 19
          Width = 49
          Height = 21
          Hint = 'How many lives per level player skill points.'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditMakeMagicAddPointChange
        end
        object EditMakeMagicUsePoint: TSpinEdit
          Left = 121
          Top = 46
          Width = 49
          Height = 21
          Hint = 'Players each additional one life skills consume skill points.'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditMakeMagicUsePointChange
        end
        object EditMakeMagicAddRate: TSpinEdit
          Left = 120
          Top = 73
          Width = 49
          Height = 21
          Hint = 
            'How much life skills per level increased probability of success.' +
            ' The actual increase in the probability = skill level / current ' +
            'settings '
          EditorEnabled = False
          MaxValue = 200
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditMakeMagicAddRateChange
        end
        object EditMakeMagicMaxLevel: TSpinEdit
          Left = 121
          Top = 99
          Width = 49
          Height = 21
          Hint = 
            'Life skills can only be increased to the maximum number of grade' +
            's'
          EditorEnabled = False
          MaxValue = 100
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditMakeMagicMaxLevelChange
        end
        object seEditMakeMagicMaxBeginLevel: TSpinEdit
          Left = 121
          Top = 126
          Width = 49
          Height = 21
          Hint = 
            'When the character level reaches a specified level began to auto' +
            'matically increase the skill points.'
          EditorEnabled = False
          MaxValue = 65535
          MinValue = 0
          TabOrder = 4
          Value = 100
          OnChange = seEditMakeMagicMaxBeginLevelChange
        end
      end
      object grp15: TGroupBox
        Left = 8
        Top = 6
        Width = 169
        Height = 283
        Caption = 'Level Control'
        TabOrder = 2
        object GridMakeMagic: TStringGrid
          Left = 10
          Top = 42
          Width = 149
          Height = 234
          ColCount = 2
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 12
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
          TabOrder = 0
          OnSetEditText = GridMakeMagicSetEditText
          ColWidths = (
            72
            71)
        end
        object ComboBoxMakeMagicType: TComboBox
          Left = 10
          Top = 17
          Width = 149
          Height = 20
          Style = csDropDownList
          ItemHeight = 0
          ItemIndex = 0
          TabOrder = 1
          Text = #25171#36896#27494#22120
          OnChange = ComboBoxMakeMagicTypeChange
          Items.Strings = (
            #25171#36896#27494#22120
            #25171#36896#26381#35013
            #25171#36896#22836#30420
            #25171#36896#39033#38142
            #25171#36896#25163#38255
            #25171#36896#25106#25351
            #25171#36896#33136#24102
            #25171#36896#38772#23376
            #25171#36896#33647#21697
            #25171#36896#26448#26009)
        end
      end
    end
    object TabSheet21: TTabSheet
      Caption = 'Attribute Points'
      ImageIndex = 11
      ExplicitLeft = 0
      ExplicitTop = 42
      ExplicitWidth = 0
      ExplicitHeight = 299
      object GroupBox2: TGroupBox
        Left = 8
        Top = 6
        Width = 185
        Height = 83
        Caption = 'Basic Parameters'
        TabOrder = 0
        object Label118: TLabel
          Left = 12
          Top = 22
          Width = 96
          Height = 12
          Caption = 'Increase Points:'
        end
        object Label124: TLabel
          Left = 12
          Top = 49
          Width = 90
          Height = 12
          Caption = 'Starting Level:'
        end
        object EditNakedAddPoint: TSpinEdit
          Left = 114
          Top = 19
          Width = 49
          Height = 21
          Hint = 'How many players attribute points per level points.'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditNakedAddPointChange
        end
        object EditNakedBeginLevel: TSpinEdit
          Left = 113
          Top = 46
          Width = 49
          Height = 21
          Hint = 
            'When the character level reaches a specified level began to auto' +
            'matically increase attribute points points.'
          EditorEnabled = False
          MaxValue = 65535
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditNakedBeginLevelChange
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 95
        Width = 313
        Height = 186
        Caption = 'Add Little Detail Settings'
        TabOrder = 1
        object Label121: TLabel
          Left = 12
          Top = 22
          Width = 30
          Height = 12
          Caption = 'AC ->'
        end
        object Label122: TLabel
          Left = 53
          Top = 22
          Width = 42
          Height = 12
          Caption = 'Points:'
        end
        object Label123: TLabel
          Left = 165
          Top = 22
          Width = 90
          Height = 12
          Caption = 'Incr Low Limit:'
        end
        object Label125: TLabel
          Left = 12
          Top = 49
          Width = 36
          Height = 12
          Caption = 'MAC ->'
        end
        object Label126: TLabel
          Left = 53
          Top = 49
          Width = 42
          Height = 12
          Caption = 'Points:'
        end
        object Label127: TLabel
          Left = 165
          Top = 49
          Width = 96
          Height = 12
          Caption = 'Incr Low Limit::'
        end
        object Label128: TLabel
          Left = 12
          Top = 76
          Width = 30
          Height = 12
          Caption = 'DC ->'
        end
        object Label129: TLabel
          Left = 53
          Top = 76
          Width = 42
          Height = 12
          Caption = 'Points:'
        end
        object Label130: TLabel
          Left = 165
          Top = 76
          Width = 96
          Height = 12
          Caption = 'Incr Low Limit::'
        end
        object Label131: TLabel
          Left = 12
          Top = 103
          Width = 30
          Height = 12
          Caption = 'MC ->'
        end
        object Label132: TLabel
          Left = 53
          Top = 103
          Width = 42
          Height = 12
          Caption = 'Points:'
        end
        object Label133: TLabel
          Left = 165
          Top = 103
          Width = 90
          Height = 12
          Caption = 'Incr Low Limit:'
        end
        object Label134: TLabel
          Left = 12
          Top = 130
          Width = 30
          Height = 12
          Caption = 'SC ->'
        end
        object Label136: TLabel
          Left = 53
          Top = 130
          Width = 42
          Height = 12
          Caption = 'Points:'
        end
        object Label137: TLabel
          Left = 165
          Top = 130
          Width = 90
          Height = 12
          Caption = 'Incr Low Limit:'
        end
        object Label138: TLabel
          Left = 12
          Top = 157
          Width = 30
          Height = 12
          Caption = 'HP ->'
        end
        object Label139: TLabel
          Left = 53
          Top = 157
          Width = 42
          Height = 12
          Caption = 'Points:'
        end
        object EditNakedAc2Point: TSpinEdit
          Left = 113
          Top = 19
          Width = 49
          Height = 21
          Hint = 
            'Each additional attribute points that consume the number of defe' +
            'nse'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 100
          OnChange = EditNakedAc2PointChange
        end
        object EditNakedAcPoint: TSpinEdit
          Left = 249
          Top = 19
          Width = 49
          Height = 21
          Hint = 'Current consumption points per set, add a little defense limit.'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditNakedAcPointChange
        end
        object EditNakedMac2Point: TSpinEdit
          Left = 113
          Top = 46
          Width = 49
          Height = 21
          Hint = 
            'Royal consume each additional attribute points a little magic nu' +
            'mber'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditNakedMac2PointChange
        end
        object EditNakedMacPoint: TSpinEdit
          Left = 249
          Top = 46
          Width = 49
          Height = 21
          Hint = 
            'Current consumption points per set, add a little magic Royal lim' +
            'it.'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditNakedMacPointChange
        end
        object EditNakedDc2Point: TSpinEdit
          Left = 113
          Top = 73
          Width = 49
          Height = 21
          Hint = 
            'Each additional attribute points that the number of attacks cons' +
            'umption'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 4
          Value = 100
          OnChange = EditNakedDc2PointChange
        end
        object EditNakedDcPoint: TSpinEdit
          Left = 249
          Top = 73
          Width = 49
          Height = 21
          Hint = 'Current consumption points per set, add a little attack limit.'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 5
          Value = 100
          OnChange = EditNakedDcPointChange
        end
        object EditNakedMC2Point: TSpinEdit
          Left = 113
          Top = 100
          Width = 49
          Height = 21
          Hint = 'Add a little magic consumption per amount of attribute points'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 6
          Value = 100
          OnChange = EditNakedMC2PointChange
        end
        object EditNakedMCPoint: TSpinEdit
          Left = 249
          Top = 100
          Width = 49
          Height = 21
          Hint = 'Current consumption points per set, add a little magic limit.'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 7
          Value = 100
          OnChange = EditNakedMCPointChange
        end
        object EditNakedSC2Point: TSpinEdit
          Left = 113
          Top = 127
          Width = 49
          Height = 21
          Hint = 
            'Each additional point of Taoism quantity consumed attribute poin' +
            'ts'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 8
          Value = 100
          OnChange = EditNakedSC2PointChange
        end
        object EditNakedSCPoint: TSpinEdit
          Left = 249
          Top = 127
          Width = 49
          Height = 21
          Hint = 
            'Current consumption points per set, increase the lower limit a l' +
            'ittle tract surgery.'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 9
          Value = 100
          OnChange = EditNakedSCPointChange
        end
        object EditNakedHPPoint: TSpinEdit
          Left = 113
          Top = 154
          Width = 49
          Height = 21
          Hint = 
            'Each additional point value of life consume the number of attrib' +
            'ute points'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 10
          Value = 100
          OnChange = EditNakedHPPointChange
        end
      end
      object ButtonNakedSave: TButton
        Left = 365
        Top = 253
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 2
        OnClick = ButtonNakedSaveClick
      end
    end
    object TabSheet22: TTabSheet
      Caption = 'Liberary Talent'
      ImageIndex = 12
      ExplicitLeft = 0
      ExplicitTop = 42
      ExplicitWidth = 0
      ExplicitHeight = 299
      object GroupBox4: TGroupBox
        Left = 8
        Top = 6
        Width = 185
        Height = 283
        Caption = 'EXP magnification control'
        TabOrder = 0
        object GridLiterary: TStringGrid
          Left = 15
          Top = 22
          Width = 167
          Height = 258
          Hint = #32463#39564#20493#25968#65292'100 = 1'#20493
          ColCount = 2
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 31
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
          TabOrder = 0
          OnSetEditText = GridLiterarySetEditText
          ColWidths = (
            72
            71)
        end
      end
      object ButtonLiterarySave: TButton
        Left = 365
        Top = 229
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 1
        OnClick = ButtonLiterarySaveClick
      end
    end
    object TabSheet23: TTabSheet
      Caption = 'Options'
      ImageIndex = 13
      ExplicitLeft = 0
      ExplicitTop = 42
      ExplicitWidth = 0
      ExplicitHeight = 299
      object GroupBox40: TGroupBox
        Left = 10
        Top = 6
        Width = 207
        Height = 114
        Caption = 'Client Settings'
        TabOrder = 0
        object CheckBoxShowStrengthenInfo: TCheckBox
          Left = 13
          Top = 19
          Width = 191
          Height = 17
          Caption = 'Display Equip to Strengthen'
          TabOrder = 0
          OnClick = CheckBoxShowStrengthenInfoClick
        end
        object CheckBoxShowCBOForm: TCheckBox
          Left = 13
          Top = 41
          Width = 168
          Height = 17
          Caption = 'Display Combo Skill Panel'
          TabOrder = 1
          OnClick = CheckBoxShowCBOFormClick
        end
        object CheckBoxShowMakeMagicForm: TCheckBox
          Left = 13
          Top = 64
          Width = 168
          Height = 17
          Caption = 'Display Life Skill Panel'
          TabOrder = 2
          OnClick = CheckBoxShowMakeMagicFormClick
        end
        object CheckBoxCancelDropItemHint: TCheckBox
          Left = 13
          Top = 88
          Width = 180
          Height = 17
          Hint = 
            'Once selected, customers will no longer throw items confirmation' +
            ' window pops up. '
          Caption = 'Cancel Throw Item pop-up'
          TabOrder = 3
          OnClick = CheckBoxCancelDropItemHintClick
        end
      end
      object ButtonFunSave: TButton
        Left = 365
        Top = 253
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 1
        OnClick = ButtonFunSaveClick
      end
      object GroupBox49: TGroupBox
        Left = 223
        Top = 6
        Width = 218
        Height = 92
        Caption = 'M2 Settings'
        TabOrder = 2
        object CheckBoxExpIsCumulative: TCheckBox
          Left = 13
          Top = 19
          Width = 188
          Height = 17
          Caption = 'Double EXP Time Accumulated'
          TabOrder = 0
          OnClick = CheckBoxExpIsCumulativeClick
        end
        object CheckBoxExpOffLienSave: TCheckBox
          Left = 13
          Top = 41
          Width = 202
          Height = 17
          Caption = 'Double EXP Offline to Save'
          TabOrder = 1
          OnClick = CheckBoxExpOffLienSaveClick
        end
        object CheckBoxExpOffLineRunTime: TCheckBox
          Left = 13
          Top = 64
          Width = 204
          Height = 17
          Caption = 'Continue to save Computing Time'
          TabOrder = 2
          OnClick = CheckBoxExpOffLineRunTimeClick
        end
      end
      object GroupBox54: TGroupBox
        Left = 10
        Top = 126
        Width = 231
        Height = 74
        Caption = 'Set Within Client Hang'
        TabOrder = 3
        object CheckBoxWarLongWide: TCheckBox
          Left = 13
          Top = 19
          Width = 228
          Height = 17
          Caption = 'Allow Soliders to kill every bit.'
          TabOrder = 0
          OnClick = CheckBoxWarLongWideClick
        end
        object CheckBoxNotShiftKey: TCheckBox
          Left = 13
          Top = 41
          Width = 149
          Height = 17
          Hint = 
            'When the Shift key after hanging select Free, whether free Shift' +
            ' is always on, no need to press the Shift key to switch.'
          Caption = 'Enable Free Shift Key'
          TabOrder = 1
          OnClick = CheckBoxNotShiftKeyClick
        end
      end
    end
    object TabSheet41: TTabSheet
      Caption = 'Horse'
      ImageIndex = 14
      ExplicitLeft = 0
      ExplicitTop = 42
      ExplicitWidth = 0
      ExplicitHeight = 299
      object GroupBox71: TGroupBox
        Left = 10
        Top = 6
        Width = 199
        Height = 75
        Caption = 'Ordinary Mount'
        TabOrder = 0
        object Label175: TLabel
          Left = 12
          Top = 45
          Width = 84
          Height = 12
          Caption = 'Gain EXP Ratio'
        end
        object Label180: TLabel
          Left = 151
          Top = 46
          Width = 6
          Height = 12
          Caption = '%'
        end
        object CheckBoxAllow32HorseGetExp: TCheckBox
          Left = 13
          Top = 19
          Width = 180
          Height = 17
          Hint = 
            'The proposal to open, otherwise ordinary horse will not be upgra' +
            'ded to gain experience'
          Caption = 'Allow non-riding gain EXP'
          TabOrder = 0
          OnClick = CheckBoxAllow32HorseGetExpClick
        end
        object Edit32HorseGetExpRate: TSpinEdit
          Left = 102
          Top = 42
          Width = 49
          Height = 21
          EditorEnabled = False
          Enabled = False
          MaxValue = 999
          MinValue = 0
          TabOrder = 1
          Value = 20
          OnChange = Edit32HorseGetExpRateChange
        end
      end
      object ButtonSaveHorse: TButton
        Left = 365
        Top = 245
        Width = 65
        Height = 25
        Caption = 'Save(&S)'
        TabOrder = 1
        OnClick = ButtonSaveHorseClick
      end
      object GroupBox72: TGroupBox
        Left = 10
        Top = 87
        Width = 199
        Height = 98
        Caption = 'Battle Riding Options'
        TabOrder = 2
        object Label176: TLabel
          Left = 12
          Top = 45
          Width = 114
          Height = 12
          Caption = 'non-riding gain EXP'
        end
        object Label177: TLabel
          Left = 12
          Top = 72
          Width = 120
          Height = 12
          Caption = 'Riding Gain XP Ratio'
        end
        object Label181: TLabel
          Left = 187
          Top = 46
          Width = 6
          Height = 12
          Caption = '%'
        end
        object Label182: TLabel
          Left = 187
          Top = 73
          Width = 6
          Height = 12
          Caption = '%'
        end
        object CheckBoxAllow33HorseGetExp: TCheckBox
          Left = 13
          Top = 19
          Width = 180
          Height = 17
          Hint = 
            'Battle ride can attack monsters to gain experience, whether to a' +
            'llow your own treatment.'
          Caption = 'Allow non-riding gain EXP'
          TabOrder = 0
          OnClick = CheckBoxAllow33HorseGetExpClick
        end
        object Edit33HorseGetExpRate: TSpinEdit
          Left = 132
          Top = 42
          Width = 49
          Height = 21
          EditorEnabled = False
          Enabled = False
          MaxValue = 999
          MinValue = 0
          TabOrder = 1
          Value = 20
          OnChange = Edit33HorseGetExpRateChange
        end
        object Edit33HorseGetExpRate2: TSpinEdit
          Left = 132
          Top = 69
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 999
          MinValue = 0
          TabOrder = 2
          Value = 20
          OnChange = Edit33HorseGetExpRate2Change
        end
      end
      object GroupBox73: TGroupBox
        Left = 215
        Top = 6
        Width = 199
        Height = 75
        Caption = 'Share Mount Options'
        TabOrder = 3
        object Label178: TLabel
          Left = 3
          Top = 22
          Width = 120
          Height = 12
          Caption = 'ResTime Horse Death:'
        end
        object Label179: TLabel
          Left = 167
          Top = 23
          Width = 18
          Height = 12
          Caption = 'Min'
        end
        object Label183: TLabel
          Left = 3
          Top = 45
          Width = 72
          Height = 12
          Caption = 'Launch Prep:'
        end
        object Label184: TLabel
          Left = 167
          Top = 46
          Width = 18
          Height = 12
          Caption = 'Sec'
        end
        object EditHorseAliveTime: TSpinEdit
          Left = 120
          Top = 19
          Width = 41
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 10
          OnChange = EditHorseAliveTimeChange
        end
        object EditTakeOnHorseUseTime: TSpinEdit
          Left = 96
          Top = 42
          Width = 65
          Height = 21
          MaxValue = 10000
          MinValue = 0
          TabOrder = 1
          Value = 10
          OnChange = EditTakeOnHorseUseTimeChange
        end
      end
      object GroupBox74: TGroupBox
        Left = 215
        Top = 88
        Width = 199
        Height = 97
        Caption = 'Domesticated Horse Options'
        TabOrder = 4
        object Label185: TLabel
          Left = 12
          Top = 22
          Width = 90
          Height = 12
          Caption = 'Probab Success:'
        end
        object EditDomesticationRate: TSpinEdit
          Left = 96
          Top = 19
          Width = 46
          Height = 21
          Hint = #25968#23383#36234#22823#25104#21151#26426#29575#36234#22823
          EditorEnabled = False
          MaxValue = 100
          MinValue = 0
          TabOrder = 0
          Value = 10
          OnChange = EditDomesticationRateChange
        end
        object CheckBoxDomesticationUseWeapon: TCheckBox
          Left = 12
          Top = 44
          Width = 184
          Height = 17
          Hint = 'Dedicated domesticated weapons Stdmode = 9'
          Caption = 'Necessary Equip(Special Wep)'
          TabOrder = 1
          OnClick = CheckBoxDomesticationUseWeaponClick
        end
        object CheckBoxDomesticationCheckLevel: TCheckBox
          Left = 12
          Top = 64
          Width = 165
          Height = 17
          Caption = 'Player Level Higher than'
          TabOrder = 2
          OnClick = CheckBoxDomesticationCheckLevelClick
        end
      end
    end
  end
end
