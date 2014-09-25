object frmGeneralConfig: TfrmGeneralConfig
  Left = 289
  Top = 143
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'General'
  ClientHeight = 158
  ClientWidth = 370
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
    Width = 185
    Height = 113
    Caption = 'IP / Ports'
    TabOrder = 0
    object LabelGateIPaddr: TLabel
      Left = 8
      Top = 20
      Width = 60
      Height = 12
      Caption = 'Gate Addr:'
    end
    object LabelGatePort: TLabel
      Left = 8
      Top = 44
      Width = 60
      Height = 12
      Caption = 'Gate Port:'
    end
    object LabelServerPort: TLabel
      Left = 8
      Top = 92
      Width = 72
      Height = 12
      Caption = 'Server Port:'
    end
    object LabelServerIPaddr: TLabel
      Left = 8
      Top = 68
      Width = 72
      Height = 12
      Caption = 'Server Addr:'
    end
    object EditGateIPaddr: TEdit
      Left = 80
      Top = 16
      Width = 97
      Height = 20
      TabOrder = 0
      Text = '127.0.0.1'
    end
    object EditGatePort: TEdit
      Left = 80
      Top = 40
      Width = 41
      Height = 20
      TabOrder = 1
      Text = '7200'
    end
    object EditServerPort: TEdit
      Left = 80
      Top = 88
      Width = 41
      Height = 20
      TabOrder = 2
      Text = '5000'
    end
    object EditServerIPaddr: TEdit
      Left = 80
      Top = 64
      Width = 97
      Height = 20
      TabOrder = 3
      Text = '127.0.0.1'
    end
  end
  object GroupBoxInfo: TGroupBox
    Left = 200
    Top = 8
    Width = 161
    Height = 113
    Caption = 'Server'
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
      Width = 84
      Height = 12
      Caption = 'Show Log Level'
    end
    object EditTitle: TEdit
      Left = 40
      Top = 16
      Width = 105
      Height = 20
      TabOrder = 0
      Text = 'Mir'
    end
    object TrackBarLogLevel: TTrackBar
      Left = 8
      Top = 56
      Width = 145
      Height = 25
      TabOrder = 1
    end
  end
  object ButtonOK: TButton
    Left = 296
    Top = 128
    Width = 65
    Height = 25
    Caption = 'Okay(&O)'
    TabOrder = 2
    OnClick = ButtonOKClick
  end
end
