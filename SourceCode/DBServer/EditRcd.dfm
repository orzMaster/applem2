object frmEditRcd: TfrmEditRcd
  Left = 407
  Top = 294
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Editing Character Data'
  ClientHeight = 370
  ClientWidth = 650
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl: TPageControl
    Left = 10
    Top = 9
    Width = 631
    Height = 323
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Basic'
      object GroupBox1: TGroupBox
        Left = 11
        Top = 3
        Width = 609
        Height = 284
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 44
          Width = 30
          Height = 12
          Caption = 'Name:'
        end
        object Label2: TLabel
          Left = 8
          Top = 68
          Width = 48
          Height = 12
          Caption = 'Account:'
        end
        object Label3: TLabel
          Left = 424
          Top = 68
          Width = 48
          Height = 12
          Caption = 'WH Pass:'
        end
        object Label11: TLabel
          Left = 8
          Top = 20
          Width = 42
          Height = 12
          Caption = 'Idx No:'
        end
        object Label12: TLabel
          Left = 8
          Top = 92
          Width = 54
          Height = 12
          Caption = 'Curr Map:'
        end
        object Label13: TLabel
          Left = 8
          Top = 116
          Width = 54
          Height = 12
          Caption = 'Curr X/Y:'
        end
        object Label14: TLabel
          Left = 8
          Top = 140
          Width = 54
          Height = 12
          Caption = 'City Map:'
        end
        object Label15: TLabel
          Left = 8
          Top = 164
          Width = 54
          Height = 12
          Caption = 'City X/Y:'
        end
        object Label6: TLabel
          Left = 232
          Top = 20
          Width = 36
          Height = 12
          Caption = 'Level:'
        end
        object Label7: TLabel
          Left = 232
          Top = 92
          Width = 30
          Height = 12
          Caption = 'Gold:'
        end
        object Label8: TLabel
          Left = 232
          Top = 116
          Width = 36
          Height = 12
          Caption = 'Ingot:'
        end
        object Label9: TLabel
          Left = 232
          Top = 140
          Width = 60
          Height = 12
          Caption = 'Point Val:'
        end
        object Label16: TLabel
          Left = 232
          Top = 213
          Width = 60
          Height = 12
          Caption = 'Rep Point:'
        end
        object Label17: TLabel
          Left = 232
          Top = 262
          Width = 54
          Height = 12
          Caption = 'PK Value:'
        end
        object Label18: TLabel
          Left = 232
          Top = 238
          Width = 42
          Height = 12
          Caption = 'Growth:'
        end
        object Label20: TLabel
          Left = 424
          Top = 44
          Width = 54
          Height = 12
          Caption = 'EXP Time:'
        end
        object Label19: TLabel
          Left = 424
          Top = 20
          Width = 54
          Height = 12
          Caption = 'EXP Magn:'
        end
        object Label33: TLabel
          Left = 8
          Top = 189
          Width = 60
          Height = 12
          Caption = 'Death Map:'
        end
        object Label34: TLabel
          Left = 8
          Top = 213
          Width = 60
          Height = 12
          Caption = 'Death X/Y:'
        end
        object Label35: TLabel
          Left = 232
          Top = 165
          Width = 42
          Height = 12
          Caption = 'Points:'
        end
        object Label36: TLabel
          Left = 232
          Top = 189
          Width = 54
          Height = 12
          Caption = 'Practice:'
        end
        object Label37: TLabel
          Left = 232
          Top = 44
          Width = 24
          Height = 12
          Caption = 'EXP:'
        end
        object Label38: TLabel
          Left = 232
          Top = 68
          Width = 60
          Height = 12
          Caption = 'Test Upgr:'
        end
        object Label5: TLabel
          Left = 8
          Top = 238
          Width = 48
          Height = 12
          Caption = 'Created:'
        end
        object Label32: TLabel
          Left = 8
          Top = 262
          Width = 60
          Height = 12
          Caption = 'LoginTime:'
        end
        object Label10: TLabel
          Left = 424
          Top = 92
          Width = 48
          Height = 12
          Caption = 'BindGold'
        end
        object Label21: TLabel
          Left = 424
          Top = 116
          Width = 48
          Height = 12
          Caption = 'WH Gold:'
        end
        object EditChrName: TEdit
          Left = 64
          Top = 40
          Width = 97
          Height = 20
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 0
        end
        object EditAccount: TEdit
          Left = 64
          Top = 64
          Width = 97
          Height = 20
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 1
        end
        object EditPassword: TEdit
          Left = 480
          Top = 64
          Width = 97
          Height = 20
          MaxLength = 12
          TabOrder = 2
          OnChange = EditPasswordChange
        end
        object EditIdx: TEdit
          Left = 64
          Top = 16
          Width = 45
          Height = 20
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 3
        end
        object EditCurMap: TEdit
          Left = 64
          Top = 88
          Width = 97
          Height = 20
          TabOrder = 4
          OnChange = EditPasswordChange
        end
        object EditCurX: TSpinEdit
          Left = 64
          Top = 112
          Width = 49
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 5
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditCurY: TSpinEdit
          Left = 112
          Top = 112
          Width = 49
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 6
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditHomeMap: TEdit
          Left = 64
          Top = 136
          Width = 97
          Height = 20
          TabOrder = 7
          OnChange = EditPasswordChange
        end
        object EditHomeX: TSpinEdit
          Left = 64
          Top = 160
          Width = 49
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 8
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditHomeY: TSpinEdit
          Left = 112
          Top = 160
          Width = 49
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 9
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditLevel: TSpinEdit
          Left = 288
          Top = 16
          Width = 97
          Height = 21
          MaxValue = 65535
          MinValue = 0
          TabOrder = 10
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditGold: TSpinEdit
          Left = 288
          Top = 88
          Width = 97
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 11
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditGameGold: TSpinEdit
          Left = 288
          Top = 112
          Width = 97
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 12
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditGamePoint: TSpinEdit
          Left = 288
          Top = 136
          Width = 97
          Height = 21
          Color = cl3DLight
          MaxValue = 0
          MinValue = 0
          ReadOnly = True
          TabOrder = 13
          Value = 0
        end
        object EditCreditPoint: TSpinEdit
          Left = 288
          Top = 209
          Width = 97
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 14
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditPKPoint: TSpinEdit
          Left = 288
          Top = 258
          Width = 97
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 15
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditPullulation: TSpinEdit
          Left = 288
          Top = 234
          Width = 97
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 16
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditExpRate: TSpinEdit
          Left = 480
          Top = 16
          Width = 97
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 17
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditExpTime: TSpinEdit
          Left = 480
          Top = 40
          Width = 97
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 18
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditDieMap: TEdit
          Left = 64
          Top = 185
          Width = 97
          Height = 20
          TabOrder = 19
          OnChange = EditPasswordChange
        end
        object EditDieX: TSpinEdit
          Left = 64
          Top = 209
          Width = 49
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 20
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditDieY: TSpinEdit
          Left = 112
          Top = 209
          Width = 49
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 21
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditGameDiamond: TSpinEdit
          Left = 288
          Top = 161
          Width = 97
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 22
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditGameGird: TSpinEdit
          Left = 288
          Top = 185
          Width = 97
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 23
          Value = 0
          OnChange = EditPasswordChange
        end
        object CheckBoxChangeName: TCheckBox
          Left = 167
          Top = 42
          Width = 57
          Height = 17
          Caption = 'Rename'
          TabOrder = 24
          OnClick = EditPasswordChange
        end
        object EditExp: TSpinEdit
          Left = 288
          Top = 40
          Width = 97
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 25
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditMaxExp: TSpinEdit
          Left = 288
          Top = 64
          Width = 97
          Height = 21
          Color = cl3DLight
          MaxValue = 0
          MinValue = 0
          ReadOnly = True
          TabOrder = 26
          Value = 0
        end
        object EditDBIdx: TEdit
          Left = 115
          Top = 16
          Width = 46
          Height = 20
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 27
        end
        object EditCreateTime: TEdit
          Left = 64
          Top = 234
          Width = 153
          Height = 20
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 28
          OnChange = EditPasswordChange
        end
        object EditLoginTime: TEdit
          Left = 64
          Top = 258
          Width = 153
          Height = 20
          Color = cl3DLight
          ReadOnly = True
          TabOrder = 29
          OnChange = EditPasswordChange
        end
        object EditBindGold: TSpinEdit
          Left = 480
          Top = 88
          Width = 97
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 30
          Value = 0
          OnChange = EditPasswordChange
        end
        object EditStorageGold: TSpinEdit
          Left = 480
          Top = 112
          Width = 97
          Height = 21
          MaxValue = 0
          MinValue = 0
          TabOrder = 31
          Value = 0
          OnChange = EditPasswordChange
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Data'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox2: TGroupBox
        Left = 7
        Top = 6
        Width = 609
        Height = 284
        TabOrder = 0
        object GroupBox12: TGroupBox
          Left = 173
          Top = 13
          Width = 311
          Height = 191
          Caption = 'Custom Variables'
          TabOrder = 0
          object Label46: TLabel
            Left = 6
            Top = 18
            Width = 24
            Height = 12
            Caption = 'Lit:'
          end
          object Label47: TLabel
            Left = 106
            Top = 18
            Width = 30
            Height = 12
            Caption = 'Dart:'
          end
          object Label48: TLabel
            Left = 206
            Top = 18
            Width = 30
            Height = 12
            Caption = 'Robb:'
          end
          object Label49: TLabel
            Left = 6
            Top = 42
            Width = 18
            Height = 12
            Caption = 'C3:'
          end
          object Label50: TLabel
            Left = 106
            Top = 42
            Width = 18
            Height = 12
            Caption = 'C4:'
          end
          object Label51: TLabel
            Left = 206
            Top = 42
            Width = 18
            Height = 12
            Caption = 'C5:'
          end
          object Label52: TLabel
            Left = 6
            Top = 66
            Width = 18
            Height = 12
            Caption = 'C6:'
          end
          object Label53: TLabel
            Left = 106
            Top = 66
            Width = 18
            Height = 12
            Caption = 'C7:'
          end
          object Label54: TLabel
            Left = 206
            Top = 66
            Width = 18
            Height = 12
            Caption = 'C8:'
          end
          object Label55: TLabel
            Left = 6
            Top = 90
            Width = 12
            Height = 12
            Caption = 'C9'
          end
          object Label56: TLabel
            Left = 106
            Top = 90
            Width = 24
            Height = 12
            Caption = 'C10:'
          end
          object Label57: TLabel
            Left = 206
            Top = 90
            Width = 24
            Height = 12
            Caption = 'C11:'
          end
          object Label58: TLabel
            Left = 6
            Top = 114
            Width = 24
            Height = 12
            Caption = 'C12:'
          end
          object Label59: TLabel
            Left = 106
            Top = 114
            Width = 24
            Height = 12
            Caption = 'C13:'
          end
          object Label60: TLabel
            Left = 206
            Top = 114
            Width = 24
            Height = 12
            Caption = 'C14:'
          end
          object Label61: TLabel
            Left = 6
            Top = 138
            Width = 24
            Height = 12
            Caption = 'C15:'
          end
          object Label62: TLabel
            Left = 106
            Top = 138
            Width = 24
            Height = 12
            Caption = 'C16:'
          end
          object Label63: TLabel
            Left = 206
            Top = 138
            Width = 24
            Height = 12
            Caption = 'C17:'
          end
          object Label64: TLabel
            Left = 6
            Top = 162
            Width = 24
            Height = 12
            Caption = 'C18:'
          end
          object Label65: TLabel
            Left = 106
            Top = 162
            Width = 24
            Height = 12
            Caption = 'C19:'
          end
          object EditC0: TSpinEdit
            Left = 38
            Top = 15
            Width = 61
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 0
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC1: TSpinEdit
            Left = 138
            Top = 15
            Width = 61
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 1
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC2: TSpinEdit
            Left = 238
            Top = 15
            Width = 65
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 2
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC3: TSpinEdit
            Left = 38
            Top = 39
            Width = 61
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 3
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC4: TSpinEdit
            Left = 138
            Top = 39
            Width = 61
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 4
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC5: TSpinEdit
            Left = 238
            Top = 39
            Width = 65
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 5
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC6: TSpinEdit
            Left = 38
            Top = 63
            Width = 61
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 6
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC7: TSpinEdit
            Left = 138
            Top = 63
            Width = 61
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 7
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC8: TSpinEdit
            Left = 238
            Top = 63
            Width = 65
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 8
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC9: TSpinEdit
            Left = 38
            Top = 87
            Width = 61
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 9
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC10: TSpinEdit
            Left = 138
            Top = 87
            Width = 61
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 10
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC11: TSpinEdit
            Left = 238
            Top = 87
            Width = 65
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 11
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC12: TSpinEdit
            Left = 38
            Top = 111
            Width = 61
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 12
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC13: TSpinEdit
            Left = 138
            Top = 111
            Width = 61
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 13
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC14: TSpinEdit
            Left = 238
            Top = 111
            Width = 65
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 14
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC15: TSpinEdit
            Left = 38
            Top = 135
            Width = 61
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 15
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC16: TSpinEdit
            Left = 138
            Top = 135
            Width = 61
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 16
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC17: TSpinEdit
            Left = 238
            Top = 135
            Width = 65
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 17
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC18: TSpinEdit
            Left = 38
            Top = 159
            Width = 61
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 18
            Value = 10
            OnChange = EditPasswordChange
          end
          object EditC19: TSpinEdit
            Left = 138
            Top = 159
            Width = 61
            Height = 21
            MaxValue = 2000000000
            MinValue = 0
            TabOrder = 19
            Value = 10
            OnChange = EditPasswordChange
          end
        end
        object GroupBox11: TGroupBox
          Left = 14
          Top = 13
          Width = 153
          Height = 193
          Caption = 'People Attributes'
          TabOrder = 1
          object Label66: TLabel
            Left = 8
            Top = 19
            Width = 18
            Height = 12
            Caption = 'AC:'
          end
          object Label67: TLabel
            Left = 8
            Top = 43
            Width = 24
            Height = 12
            Caption = 'MAC:'
          end
          object Label68: TLabel
            Left = 8
            Top = 67
            Width = 18
            Height = 12
            Caption = 'DC:'
          end
          object Label69: TLabel
            Left = 8
            Top = 91
            Width = 18
            Height = 12
            Caption = 'MC:'
          end
          object Label70: TLabel
            Left = 8
            Top = 115
            Width = 18
            Height = 12
            Caption = 'SC:'
          end
          object Label71: TLabel
            Left = 8
            Top = 139
            Width = 42
            Height = 12
            Caption = 'Health:'
          end
          object Label72: TLabel
            Left = 8
            Top = 163
            Width = 42
            Height = 12
            Caption = 'Remain:'
          end
          object EditNakedAC: TEdit
            Left = 56
            Top = 16
            Width = 81
            Height = 20
            ReadOnly = True
            TabOrder = 0
            Text = 'EditNakedAC'
          end
          object EditNakedMAC: TEdit
            Left = 56
            Top = 40
            Width = 81
            Height = 20
            ReadOnly = True
            TabOrder = 1
            Text = 'EditNakedMAC'
          end
          object EditNakedDC: TEdit
            Left = 56
            Top = 64
            Width = 81
            Height = 20
            ReadOnly = True
            TabOrder = 2
            Text = 'EditNakedDC'
          end
          object EditNakedMC: TEdit
            Left = 56
            Top = 88
            Width = 81
            Height = 20
            ReadOnly = True
            TabOrder = 3
            Text = 'EditNakedMC'
          end
          object EditNakedSC: TEdit
            Left = 56
            Top = 112
            Width = 81
            Height = 20
            ReadOnly = True
            TabOrder = 4
            Text = 'EditNakedSC'
          end
          object EditNakedHP: TEdit
            Left = 56
            Top = 136
            Width = 81
            Height = 20
            ReadOnly = True
            TabOrder = 5
            Text = 'EditNakedHP'
          end
          object EditNakedPoint: TEdit
            Left = 56
            Top = 160
            Width = 81
            Height = 20
            ReadOnly = True
            TabOrder = 6
            Text = 'EditNakedPoint'
          end
        end
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Communication'
      ImageIndex = 5
      object GroupBox7: TGroupBox
        Left = 11
        Top = 11
        Width = 190
        Height = 46
        Caption = 'Martial Relationship'
        TabOrder = 0
        object Label4: TLabel
          Left = 12
          Top = 21
          Width = 36
          Height = 12
          Caption = 'Spouse'
        end
        object EditDearName: TEdit
          Left = 72
          Top = 18
          Width = 97
          Height = 20
          MaxLength = 14
          TabOrder = 0
          OnChange = EditPasswordChange
        end
      end
      object GroupBox8: TGroupBox
        Left = 11
        Top = 63
        Width = 190
        Height = 225
        Caption = 'Mentoring Relationship'
        TabOrder = 1
        object Label39: TLabel
          Left = 12
          Top = 42
          Width = 42
          Height = 12
          Caption = 'Master:'
        end
        object Label40: TLabel
          Left = 12
          Top = 68
          Width = 66
          Height = 12
          Caption = 'Apprentice:'
        end
        object Label41: TLabel
          Left = 12
          Top = 94
          Width = 60
          Height = 12
          Caption = 'Apprentice'
        end
        object Label42: TLabel
          Left = 12
          Top = 120
          Width = 66
          Height = 12
          Caption = 'Apprentice:'
        end
        object Label43: TLabel
          Left = 12
          Top = 146
          Width = 66
          Height = 12
          Caption = 'Apprentice:'
        end
        object Label44: TLabel
          Left = 12
          Top = 172
          Width = 66
          Height = 12
          Caption = 'Apprentice:'
        end
        object Label45: TLabel
          Left = 12
          Top = 198
          Width = 66
          Height = 12
          Caption = 'Apprentice:'
        end
        object EditMasterName1: TEdit
          Left = 72
          Top = 39
          Width = 97
          Height = 20
          MaxLength = 14
          TabOrder = 0
          OnChange = EditPasswordChange
        end
        object CheckBoxIsMaster: TCheckBox
          Left = 72
          Top = 16
          Width = 81
          Height = 17
          Caption = 'Master'
          TabOrder = 1
          OnClick = EditPasswordChange
        end
        object EditMasterName2: TEdit
          Left = 72
          Top = 65
          Width = 97
          Height = 20
          MaxLength = 14
          TabOrder = 2
          OnChange = EditPasswordChange
        end
        object EditMasterName3: TEdit
          Left = 72
          Top = 91
          Width = 97
          Height = 20
          MaxLength = 14
          TabOrder = 3
          OnChange = EditPasswordChange
        end
        object EditMasterName4: TEdit
          Left = 72
          Top = 117
          Width = 97
          Height = 20
          MaxLength = 14
          TabOrder = 4
          OnChange = EditPasswordChange
        end
        object EditMasterName5: TEdit
          Left = 72
          Top = 143
          Width = 97
          Height = 20
          MaxLength = 14
          TabOrder = 5
          OnChange = EditPasswordChange
        end
        object EditMasterName6: TEdit
          Left = 72
          Top = 169
          Width = 97
          Height = 20
          MaxLength = 14
          TabOrder = 6
          OnChange = EditPasswordChange
        end
        object EditMasterName7: TEdit
          Left = 72
          Top = 195
          Width = 97
          Height = 20
          MaxLength = 14
          TabOrder = 7
          OnChange = EditPasswordChange
        end
      end
      object GroupBox9: TGroupBox
        Left = 207
        Top = 11
        Width = 154
        Height = 277
        Caption = 'Friend Relations'
        TabOrder = 2
        object ListBoxFirend: TListBox
          Left = 7
          Top = 18
          Width = 138
          Height = 249
          ItemHeight = 12
          TabOrder = 0
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Skills'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox3: TGroupBox
        Left = 7
        Top = 6
        Width = 433
        Height = 284
        Caption = 'Ordinary Skill'
        TabOrder = 0
        object ListViewMagic: TListView
          Left = 8
          Top = 16
          Width = 417
          Height = 257
          Columns = <
            item
              Caption = 'Skill ID'
              Width = 60
            end
            item
              Caption = 'Skill Name'
              Width = 120
            end
            item
              Caption = 'Level'
              Width = 60
            end
            item
              Caption = 'Practice Point'
              Width = 90
            end>
          GridLines = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
      object GroupBox6: TGroupBox
        Left = 446
        Top = 6
        Width = 170
        Height = 284
        Caption = 'Life Skills'
        TabOrder = 1
        object Label22: TLabel
          Left = 10
          Top = 255
          Width = 48
          Height = 12
          Caption = 'Remaing:'
        end
        object ListViewMakeMagic: TListView
          Left = 8
          Top = 16
          Width = 153
          Height = 226
          Columns = <
            item
              Caption = 'Skill Name'
              Width = 100
            end
            item
              Caption = 'Level'
              Width = 40
            end>
          GridLines = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
        end
        object EditMakeMagic: TSpinEdit
          Left = 82
          Top = 252
          Width = 79
          Height = 21
          MaxValue = 65535
          MinValue = 0
          TabOrder = 1
          Value = 0
          OnChange = EditPasswordChange
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Equipment'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox4: TGroupBox
        Left = 7
        Top = 6
        Width = 609
        Height = 284
        TabOrder = 0
        object ListViewUserItem: TListView
          Left = 8
          Top = 16
          Width = 591
          Height = 257
          Columns = <
            item
              Caption = 'Location'
              Width = 60
            end
            item
              Caption = 'Identifcation'
              Width = 75
            end
            item
              Caption = 'Item Name'
              Width = 90
            end
            item
              Alignment = taCenter
              Caption = 'Long Lasting'
              Width = 85
            end
            item
              Caption = 'Parameters'
              Width = 260
            end>
          GridLines = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'Backpack'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox10: TGroupBox
        Left = 7
        Top = 6
        Width = 609
        Height = 284
        TabOrder = 0
        object ListViewBagItem: TListView
          Left = 8
          Top = 16
          Width = 591
          Height = 257
          Columns = <
            item
              Caption = 'No.'
              Width = 40
            end
            item
              Caption = 'Identification'
              Width = 80
            end
            item
              Caption = 'Item Name'
              Width = 90
            end
            item
              Alignment = taCenter
              Caption = 'Long Lasting'
              Width = 90
            end
            item
              Caption = 'Parameters'
              Width = 270
            end>
          GridLines = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Warehouse'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox5: TGroupBox
        Left = 7
        Top = 6
        Width = 609
        Height = 284
        TabOrder = 0
        object ListViewStorage: TListView
          Left = 8
          Top = 16
          Width = 591
          Height = 257
          Columns = <
            item
              Caption = 'No.'
              Width = 40
            end
            item
              Caption = 'Identifcation'
              Width = 80
            end
            item
              Caption = 'Item Name'
              Width = 90
            end
            item
              Alignment = taCenter
              Caption = 'Long Lasting'
              Width = 90
            end
            item
              Caption = 'Parameters'
              Width = 270
            end>
          GridLines = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
    end
  end
  object ButtonSaveData: TButton
    Left = 560
    Top = 338
    Width = 81
    Height = 25
    Caption = 'Save(&S)'
    TabOrder = 1
    OnClick = ButtonExportDataClick
  end
  object ButtonExportData: TButton
    Left = 386
    Top = 338
    Width = 81
    Height = 25
    Caption = 'Export(&E)'
    TabOrder = 2
    OnClick = ButtonExportDataClick
  end
  object ButtonImportData: TButton
    Left = 473
    Top = 338
    Width = 81
    Height = 25
    Caption = 'Import(&I)'
    TabOrder = 3
    OnClick = ButtonExportDataClick
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'hum'
    Filter = #20154#29289#25968#25454' (*.hum)|*.hum'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 192
    Top = 336
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'hum'
    Filter = #20154#29289#25968#25454' (*.hum)|*.hum'
    Left = 232
    Top = 336
  end
end
