object frmActionSpeed: TfrmActionSpeed
  Left = 515
  Top = 413
  ActiveControl = ButtonClose
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Operation Speed Setting'
  ClientHeight = 257
  ClientWidth = 318
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 12
  object Label5: TLabel
    Left = 8
    Top = 240
    Width = 288
    Height = 12
    Caption = #21442#25968#35843#25972#21518#65292#22312#28216#25103#20013#20154#29289#23567#36864#21518#29983#25928#65292#38750#31435#21363#29983#25928#12290
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 297
    Height = 193
    TabOrder = 0
    object GroupBox3: TGroupBox
      Left = 152
      Top = 16
      Width = 137
      Height = 49
      TabOrder = 0
      object Label15: TLabel
        Left = 11
        Top = 24
        Width = 54
        Height = 12
        Caption = 'Move Int:'
      end
      object EditRunLongHitIntervalTime: TSpinEdit
        Left = 68
        Top = 20
        Width = 53
        Height = 21
        Hint = 
          'Control moves assassination attack interval, the unit is (in mil' +
          'liseconds).'
        EditorEnabled = False
        Increment = 10
        MaxValue = 2000
        MinValue = 10
        TabOrder = 0
        Value = 350
        OnChange = EditRunLongHitIntervalTimeChange
      end
      object CheckBoxControlRunLongHit: TCheckBox
        Left = 8
        Top = -1
        Width = 121
        Height = 17
        Hint = 'Whether moves to assassinate control.'
        Caption = 'Enable Assa Ctrl'
        TabOrder = 1
        OnClick = CheckBoxControlRunLongHitClick
      end
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 16
      Width = 137
      Height = 49
      Caption = 'Operation Interval'
      TabOrder = 1
      object Label2: TLabel
        Left = 11
        Top = 24
        Width = 54
        Height = 12
        Caption = 'Interval:'
      end
      object EditActionIntervalTime: TSpinEdit
        Left = 68
        Top = 20
        Width = 53
        Height = 21
        Hint = 
          'Combination of normal operation control interval, the unit is (i' +
          'n milliseconds).'
        EditorEnabled = False
        Increment = 10
        MaxValue = 2000
        MinValue = 10
        TabOrder = 0
        Value = 350
        OnChange = EditActionIntervalTimeChange
      end
    end
    object CheckBoxControlActionInterval: TCheckBox
      Left = 8
      Top = -1
      Width = 177
      Height = 17
      Hint = 'Whether a combination of the operation control.'
      Caption = 'Enable Operation Ctrl'
      TabOrder = 2
      OnClick = CheckBoxControlActionIntervalClick
    end
    object GroupBox4: TGroupBox
      Left = 8
      Top = 72
      Width = 137
      Height = 49
      TabOrder = 3
      object Label1: TLabel
        Left = 11
        Top = 24
        Width = 54
        Height = 12
        Caption = 'Move Int:'
      end
      object EditRunHitIntervalTime: TSpinEdit
        Left = 68
        Top = 20
        Width = 53
        Height = 21
        Hint = 'Control moves to attack interval, the unit is (in milliseconds).'
        EditorEnabled = False
        Increment = 10
        MaxValue = 2000
        MinValue = 10
        TabOrder = 0
        Value = 350
        OnChange = EditRunHitIntervalTimeChange
      end
      object CheckBoxControlRunHit: TCheckBox
        Left = 8
        Top = -1
        Width = 130
        Height = 17
        Hint = 'Moves to control whether the attack.'
        Caption = 'Enable Move to Atk'
        TabOrder = 1
        OnClick = CheckBoxControlRunHitClick
      end
    end
    object GroupBox5: TGroupBox
      Left = 152
      Top = 72
      Width = 137
      Height = 49
      TabOrder = 4
      object Label3: TLabel
        Left = 11
        Top = 24
        Width = 54
        Height = 12
        Caption = 'Walk Int:'
      end
      object EditWalkHitIntervalTime: TSpinEdit
        Left = 68
        Top = 20
        Width = 53
        Height = 21
        Hint = 
          'Control the time between attacks take place, the unit is (in mil' +
          'liseconds).'
        EditorEnabled = False
        Increment = 10
        MaxValue = 2000
        MinValue = 10
        TabOrder = 0
        Value = 350
        OnChange = EditWalkHitIntervalTimeChange
      end
      object CheckBoxControlWalkHit: TCheckBox
        Left = 8
        Top = -1
        Width = 121
        Height = 17
        Hint = 'Moves to control whether the attack.'
        Caption = 'Enable Walk Atk'
        TabOrder = 1
        OnClick = CheckBoxControlWalkHitClick
      end
    end
    object GroupBox6: TGroupBox
      Left = 8
      Top = 128
      Width = 137
      Height = 49
      TabOrder = 5
      object Label4: TLabel
        Left = 8
        Top = 22
        Width = 54
        Height = 12
        Caption = 'Move Int:'
      end
      object EditRunMagicIntervalTime: TSpinEdit
        Left = 68
        Top = 20
        Width = 53
        Height = 21
        Hint = 'Control moves magic interval, the unit is (in milliseconds).'
        EditorEnabled = False
        Increment = 10
        MaxValue = 2000
        MinValue = 10
        TabOrder = 0
        Value = 350
        OnChange = EditRunMagicIntervalTimeChange
      end
      object CheckBoxControlRunMagic: TCheckBox
        Left = 8
        Top = -1
        Width = 121
        Height = 17
        Hint = 'Moves to control whether the attack.'
        Caption = 'Enable Magic Ctrl'
        TabOrder = 1
        OnClick = CheckBoxControlRunMagicClick
      end
    end
  end
  object ButtonSave: TButton
    Left = 80
    Top = 205
    Width = 65
    Height = 25
    Caption = 'Save(&S)'
    TabOrder = 1
    OnClick = ButtonSaveClick
  end
  object ButtonDefault: TButton
    Left = 8
    Top = 205
    Width = 65
    Height = 25
    Caption = 'Default(&D)'
    TabOrder = 2
    OnClick = ButtonDefaultClick
  end
  object ButtonClose: TButton
    Left = 240
    Top = 204
    Width = 65
    Height = 25
    Caption = 'Close(&C)'
    TabOrder = 3
    OnClick = ButtonCloseClick
  end
  object CheckBoxIncremeng: TCheckBox
    Left = 160
    Top = 208
    Width = 73
    Height = 17
    Caption = 'Tuning'
    TabOrder = 4
    OnClick = CheckBoxIncremengClick
  end
end
