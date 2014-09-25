object frmGeneralConfig: TfrmGeneralConfig
  Left = 387
  Top = 312
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Basic Settings'
  ClientHeight = 185
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBoxNet: TGroupBox
    Left = 8
    Top = 8
    Width = 209
    Height = 169
    Caption = 'Network Settings'
    TabOrder = 0
    object LabelGateIPaddr: TLabel
      Left = 8
      Top = 20
      Width = 78
      Height = 12
      Caption = 'Gateway Addr:'
    end
    object LabelGatePort: TLabel
      Left = 8
      Top = 44
      Width = 78
      Height = 12
      Caption = 'Gateway Port:'
    end
    object LabelServerPort: TLabel
      Left = 8
      Top = 92
      Width = 66
      Height = 12
      Caption = 'ServerPort:'
    end
    object LabelServerIPaddr: TLabel
      Left = 8
      Top = 68
      Width = 72
      Height = 12
      Caption = 'Server Addr:'
    end
    object Label5: TLabel
      Left = 8
      Top = 118
      Width = 90
      Height = 12
      Caption = 'CtrlCenterAddr:'
    end
    object Label6: TLabel
      Left = 8
      Top = 144
      Width = 90
      Height = 12
      Caption = 'CtrlCenterPort:'
    end
    object EditGateIPaddr: TEdit
      Left = 93
      Top = 16
      Width = 97
      Height = 20
      Hint = 
        #27492#22320#22336#19968#33324#40664#35748#20026' 0.0.0.0 '#65292#36890#24120#19981#38656#35201#26356#25913#12290#13#10#22914#26524#21333#26426#19978#26377#22810#20010'IP'#22320#22336#26102#65292#21487#35774#32622#20026#26412#26426#20854#13#10#20013#19968#20010'IP'#65292#20197#23454#29616#21516#31471#21475#19981 +
        #21516'IP'#30340#32465#23450#12290
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '0.0.0.0'
    end
    object EditGatePort: TEdit
      Left = 93
      Top = 40
      Width = 41
      Height = 20
      Hint = #32593#20851#23545#22806#24320#25918#30340#31471#21475#21495#65292#27492#31471#21475#26631#20934#20026' 7200'#65292#13#10#27492#31471#21475#21487#26681#25454#33258#24049#30340#35201#27714#36827#34892#20462#25913#12290
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = '7200'
    end
    object EditServerPort: TEdit
      Left = 93
      Top = 88
      Width = 41
      Height = 20
      Hint = #28216#25103#26381#21153#22120#30340#31471#21475#65292#27492#31471#21475#26631#20934#20026' 5000'#65292#13#10#22914#26524#20351#29992#30340#28216#25103#26381#21153#22120#31471#20462#25913#36807#65292#21017#25913#20026#13#10#30456#24212#30340#31471#21475#23601#34892#20102#12290
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = '5000'
    end
    object EditServerIPaddr: TEdit
      Left = 93
      Top = 64
      Width = 97
      Height = 20
      Hint = #28216#25103#26381#21153#22120#30340'IP'#22320#22336#65292#22914#26524#26159#21333#26426#36816#34892#26381#21153#13#10#22120#31471#26102#65292#19968#33324#23601#29992' 127.0.0.1 '#12290
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = '127.0.0.1'
    end
    object EditCenterIPaddr: TEdit
      Left = 93
      Top = 114
      Width = 97
      Height = 20
      TabOrder = 4
      Text = '127.0.0.1'
    end
    object EditCenterPort: TEdit
      Left = 93
      Top = 140
      Width = 97
      Height = 20
      BiDiMode = bdLeftToRight
      MaxLength = 5
      ParentBiDiMode = False
      TabOrder = 5
      Text = '5600'
    end
  end
  object GroupBoxInfo: TGroupBox
    Left = 223
    Top = 8
    Width = 161
    Height = 121
    Caption = 'Basic Parameters'
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 36
      Height = 12
      Caption = 'Title:'
    end
    object LabelShowLogLevel: TLabel
      Left = 8
      Top = 44
      Width = 90
      Height = 12
      Caption = 'Show Log Level:'
    end
    object LabelShowBite: TLabel
      Left = 8
      Top = 92
      Width = 78
      Height = 12
      Caption = 'Flow Display:'
    end
    object EditTitle: TEdit
      Left = 40
      Top = 16
      Width = 105
      Height = 20
      Hint = 
        'The title is displayed on the program name, the name for display' +
        ' only '
      ImeMode = imHanguel
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = 'Mir'
    end
    object TrackBarLogLevel: TTrackBar
      Left = 8
      Top = 56
      Width = 145
      Height = 25
      Hint = 'Program running log shows the level of detail.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object ComboBoxShowBite: TComboBox
      Left = 88
      Top = 88
      Width = 57
      Height = 20
      Hint = 
        'Monitoring data on the program'#39's main interface displays traffic' +
        ' display units.'
      Style = csDropDownList
      ItemHeight = 12
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Items.Strings = (
        'KB'
        'B')
    end
  end
  object ButtonOK: TButton
    Left = 319
    Top = 152
    Width = 65
    Height = 25
    Hint = 'Save the current settings, network settings at the next start '
    Caption = 'Okay(&O)'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = ButtonOKClick
  end
end
