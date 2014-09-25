object frmConfigMerchant: TfrmConfigMerchant
  Left = 190
  Top = 330
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Trading NPC Configuration'
  ClientHeight = 510
  ClientWidth = 826
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
  object GroupBoxNPC: TGroupBox
    Left = 8
    Top = 332
    Width = 401
    Height = 137
    Caption = 'Related Settings'
    Enabled = False
    TabOrder = 0
    object Label2: TLabel
      Left = 8
      Top = 20
      Width = 42
      Height = 12
      Caption = 'Script:'
    end
    object Label3: TLabel
      Left = 208
      Top = 20
      Width = 54
      Height = 12
      Caption = 'Map Name:'
    end
    object Label4: TLabel
      Left = 8
      Top = 44
      Width = 48
      Height = 12
      Caption = 'Coord X:'
    end
    object Label5: TLabel
      Left = 120
      Top = 44
      Width = 12
      Height = 12
      Caption = 'Y:'
    end
    object Label6: TLabel
      Left = 4
      Top = 66
      Width = 30
      Height = 12
      Caption = 'Name:'
    end
    object Label7: TLabel
      Left = 208
      Top = 68
      Width = 24
      Height = 12
      Caption = 'Dir:'
    end
    object Label8: TLabel
      Left = 295
      Top = 68
      Width = 30
      Height = 12
      Caption = 'Looks'
    end
    object Label10: TLabel
      Left = 208
      Top = 44
      Width = 24
      Height = 12
      Caption = 'Map:'
    end
    object Label11: TLabel
      Left = 288
      Top = 92
      Width = 42
      Height = 12
      Caption = 'Mobile:'
    end
    object EditScriptName: TEdit
      Left = 64
      Top = 16
      Width = 121
      Height = 20
      Hint = #33050#26412#25991#20214#21517#31216#12290#25991#20214#21517#31216#20197#27492#21517#23383#21152#22320#22270#21517#32452#21512#20026#23454#38469#25991#20214#21517#12290
      TabOrder = 0
      OnChange = EditScriptNameChange
    end
    object EditMapName: TEdit
      Left = 264
      Top = 16
      Width = 121
      Height = 20
      Hint = 'Map name.'
      TabOrder = 1
      OnChange = EditMapNameChange
    end
    object EditShowName: TEdit
      Left = 64
      Top = 64
      Width = 121
      Height = 20
      TabOrder = 2
      OnChange = EditShowNameChange
    end
    object CheckBoxOfCastle: TCheckBox
      Left = 64
      Top = 88
      Width = 113
      Height = 17
      Hint = 
        'The castle belongs to the specified NPC management, when the sie' +
        'ge NPC will stop operating.'
      Caption = 'Belong to Castle'
      TabOrder = 3
      OnClick = CheckBoxOfCastleClick
    end
    object ComboBoxDir: TComboBox
      Left = 240
      Top = 64
      Width = 49
      Height = 20
      Hint = 'Default standing direction.'
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 4
      OnChange = ComboBoxDirChange
    end
    object EditImageIdx: TSpinEdit
      Left = 336
      Top = 63
      Width = 49
      Height = 21
      Hint = 'Exterior graphics.'
      EditorEnabled = False
      MaxValue = 65535
      MinValue = 0
      TabOrder = 5
      Value = 0
      OnChange = EditImageIdxChange
    end
    object EditX: TSpinEdit
      Left = 64
      Top = 39
      Width = 49
      Height = 21
      EditorEnabled = False
      MaxValue = 1000
      MinValue = 1
      TabOrder = 6
      Value = 1
      OnChange = EditXChange
    end
    object EditY: TSpinEdit
      Left = 136
      Top = 39
      Width = 49
      Height = 21
      EditorEnabled = False
      MaxValue = 1000
      MinValue = 1
      TabOrder = 7
      Value = 1
      OnChange = EditYChange
    end
    object EditMapDesc: TEdit
      Left = 264
      Top = 40
      Width = 121
      Height = 20
      Enabled = False
      ReadOnly = True
      TabOrder = 8
    end
    object CheckBoxAutoMove: TCheckBox
      Left = 208
      Top = 88
      Width = 81
      Height = 17
      Hint = 'NPC will have to move with the map'
      Caption = 'Auto Move'
      TabOrder = 9
      OnClick = CheckBoxAutoMoveClick
    end
    object EditMoveTime: TSpinEdit
      Left = 344
      Top = 87
      Width = 41
      Height = 21
      Hint = 'Random movement interval seconds'
      EditorEnabled = False
      MaxValue = 65535
      MinValue = 0
      TabOrder = 10
      Value = 0
      OnChange = EditMoveTimeChange
    end
  end
  object GroupBoxScript: TGroupBox
    Left = 416
    Top = 8
    Width = 401
    Height = 494
    Caption = 'Script Editor'
    Enabled = False
    TabOrder = 1
    object MemoScript: TMemo
      Left = 8
      Top = 136
      Width = 385
      Height = 351
      ScrollBars = ssBoth
      TabOrder = 0
      OnChange = MemoScriptChange
    end
    object ButtonScriptSave: TButton
      Left = 341
      Top = 59
      Width = 57
      Height = 25
      Hint = 'Save the script file.'
      Caption = 'Save(&S)'
      TabOrder = 1
      OnClick = ButtonScriptSaveClick
    end
    object GroupBox3: TGroupBox
      Left = 8
      Top = 16
      Width = 329
      Height = 113
      TabOrder = 2
      object Label9: TLabel
        Left = 8
        Top = 88
        Width = 54
        Height = 12
        Caption = 'Discount:'
        Visible = False
      end
      object CheckBoxBuy: TCheckBox
        Left = 8
        Top = 16
        Width = 33
        Height = 17
        Caption = 'Buy'
        TabOrder = 0
        OnClick = CheckBoxBuyClick
      end
      object CheckBoxSell: TCheckBox
        Left = 8
        Top = 32
        Width = 33
        Height = 17
        Caption = 'Sell'
        TabOrder = 1
        OnClick = CheckBoxSellClick
      end
      object CheckBoxStorage: TCheckBox
        Left = 72
        Top = 32
        Width = 65
        Height = 17
        Caption = 'Take WH'
        TabOrder = 2
        OnClick = CheckBoxStorageClick
      end
      object CheckBoxGetback: TCheckBox
        Left = 72
        Top = 16
        Width = 65
        Height = 17
        Caption = 'Give WH'
        TabOrder = 3
        OnClick = CheckBoxGetbackClick
      end
      object CheckBoxMakedrug: TCheckBox
        Left = 240
        Top = 48
        Width = 73
        Height = 17
        Caption = 'Synth Mat'
        TabOrder = 4
        OnClick = CheckBoxMakedrugClick
      end
      object CheckBoxArmStrengthen: TCheckBox
        Left = 152
        Top = 16
        Width = 97
        Height = 17
        Caption = 'Strengthen'
        TabOrder = 5
        OnClick = CheckBoxArmStrengthenClick
      end
      object CheckBoxArmUnseal: TCheckBox
        Left = 152
        Top = 32
        Width = 82
        Height = 17
        Caption = 'Equip Open'
        TabOrder = 6
        OnClick = CheckBoxArmUnsealClick
      end
      object CheckBoxRepair: TCheckBox
        Left = 240
        Top = 16
        Width = 73
        Height = 17
        Caption = 'Repair '
        TabOrder = 7
        OnClick = CheckBoxRepairClick
      end
      object CheckBoxS_repair: TCheckBox
        Left = 240
        Top = 32
        Width = 94
        Height = 17
        Caption = 'Special Rep'
        TabOrder = 8
        OnClick = CheckBoxS_repairClick
      end
      object EditPriceRate: TSpinEdit
        Left = 64
        Top = 84
        Width = 49
        Height = 21
        Hint = 'NPC transaction discount, 80 to 80%'
        EditorEnabled = False
        MaxValue = 500
        MinValue = 60
        TabOrder = 9
        Value = 60
        Visible = False
      end
      object CheckBoxSendMsg: TCheckBox
        Left = 72
        Top = 48
        Width = 73
        Height = 17
        Caption = 'Greeting'
        TabOrder = 10
        OnClick = CheckBoxSendMsgClick
      end
      object CheckBoxArmRemoveStone: TCheckBox
        Left = 152
        Top = 48
        Width = 82
        Height = 17
        Caption = 'Remov Stone'
        TabOrder = 11
        OnClick = CheckBoxArmRemoveStoneClick
      end
      object CheckBoxUpgradeNow: TCheckBox
        Left = 72
        Top = 64
        Width = 73
        Height = 17
        Caption = 'Upgr Weap'
        TabOrder = 12
        OnClick = CheckBoxUpgradeNowClick
      end
      object CheckBoxGetBackUpgnow: TCheckBox
        Left = 152
        Top = 64
        Width = 86
        Height = 17
        Caption = 'Retriev Wep'
        TabOrder = 13
        OnClick = CheckBoxGetBackUpgnowClick
      end
      object CheckBoxArmAbilityMove: TCheckBox
        Left = 240
        Top = 64
        Width = 81
        Height = 17
        Caption = 'Prop Trans'
        TabOrder = 14
        OnClick = CheckBoxArmAbilityMoveClick
      end
    end
    object ButtonReLoadNpc: TButton
      Left = 341
      Top = 28
      Width = 57
      Height = 25
      Hint = 'Reload NPC script.'
      Caption = 'Load(&L)'
      Enabled = False
      TabOrder = 3
      OnClick = ButtonReLoadNpcClick
    end
  end
  object ButtonSave: TButton
    Left = 8
    Top = 476
    Width = 57
    Height = 25
    Hint = 'Save the transaction NPC settings'
    Caption = 'Save(&S)'
    TabOrder = 2
    OnClick = ButtonSaveClick
  end
  object CheckBoxDenyRefStatus: TCheckBox
    Left = 328
    Top = 476
    Width = 73
    Height = 17
    Hint = 
      'Using this method, you can refresh the NPC data in the game. Tur' +
      'n this option off after a few seconds, the parameter changes wil' +
      'l refresh the NPC in the game.'
    Caption = 'Refresh'
    TabOrder = 3
    OnClick = CheckBoxDenyRefStatusClick
  end
  object ButtonClearTempData: TButton
    Left = 168
    Top = 476
    Width = 89
    Height = 25
    Hint = 
      'NPC clear all temporary files, including temporary price list an' +
      'd trading goods inventory, you can use this feature to clean up ' +
      'the sale of goods when there is a problem in the NPC.'
    Caption = 'Clear(&C)'
    TabOrder = 4
    OnClick = ButtonClearTempDataClick
  end
  object ButtonViewData: TButton
    Left = 72
    Top = 476
    Width = 89
    Height = 25
    Caption = 'View(&V)'
    TabOrder = 5
    Visible = False
    OnClick = ButtonClearTempDataClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 401
    Height = 318
    Caption = 'NPC List'
    TabOrder = 6
    object ListBoxMerChant: TListBox
      Left = 8
      Top = 16
      Width = 385
      Height = 290
      ItemHeight = 12
      TabOrder = 0
      OnClick = ListBoxMerChantClick
    end
  end
end
