object FrmBasicSet: TFrmBasicSet
  Left = 648
  Top = 183
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = ' Basic Settings'
  ClientHeight = 240
  ClientWidth = 419
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 401
    Height = 193
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Accounts'
      ImageIndex = 1
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 193
        Height = 97
        Caption = 'Gateway Settings'
        TabOrder = 0
        object CheckBoxDisabledCreateID: TCheckBox
          Left = 15
          Top = 21
          Width = 138
          Height = 17
          Caption = 'Disable New Account'
          TabOrder = 0
          OnClick = CheckBoxDisabledCreateIDClick
        end
        object CheckBoxDisabledChangePassword: TCheckBox
          Left = 15
          Top = 44
          Width = 162
          Height = 17
          Caption = 'Disable Change Password'
          TabOrder = 1
          OnClick = CheckBoxDisabledChangePasswordClick
        end
        object CheckBoxDisabledLostPassword: TCheckBox
          Left = 15
          Top = 67
          Width = 175
          Height = 17
          Caption = 'Disable Retrieve Password'
          TabOrder = 2
          OnClick = CheckBoxDisabledLostPasswordClick
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Ports / IPs'
      ImageIndex = 1
      object GroupBox3: TGroupBox
        Left = 8
        Top = 8
        Width = 185
        Height = 65
        Caption = 'Game Addr / Port'
        TabOrder = 0
        object Label3: TLabel
          Left = 8
          Top = 18
          Width = 60
          Height = 12
          Caption = 'Gate Addr:'
        end
        object Label4: TLabel
          Left = 8
          Top = 42
          Width = 60
          Height = 12
          Caption = 'Game Port:'
        end
        object EditGateAddr: TEdit
          Left = 72
          Top = 14
          Width = 105
          Height = 20
          TabOrder = 0
          OnChange = EditGateAddrChange
        end
        object EditGatePort: TEdit
          Left = 72
          Top = 38
          Width = 57
          Height = 20
          TabOrder = 1
          OnChange = EditGatePortChange
        end
      end
      object GroupBox4: TGroupBox
        Left = 199
        Top = 79
        Width = 185
        Height = 65
        Caption = 'RMON Settings'
        TabOrder = 1
        object Label5: TLabel
          Left = 8
          Top = 18
          Width = 60
          Height = 12
          Caption = 'Bind Addr:'
        end
        object Label6: TLabel
          Left = 8
          Top = 42
          Width = 60
          Height = 12
          Caption = 'Bind Port:'
        end
        object EditMonAddr: TEdit
          Left = 72
          Top = 14
          Width = 105
          Height = 20
          TabOrder = 0
          OnChange = EditMonAddrChange
        end
        object EditMonPort: TEdit
          Left = 72
          Top = 38
          Width = 57
          Height = 20
          TabOrder = 1
          OnChange = EditMonPortChange
        end
      end
      object GroupBox5: TGroupBox
        Left = 8
        Top = 79
        Width = 185
        Height = 65
        Caption = 'Server Addr /  Port'
        TabOrder = 2
        object Label7: TLabel
          Left = 8
          Top = 18
          Width = 72
          Height = 12
          Caption = 'Server Addr:'
        end
        object Label8: TLabel
          Left = 8
          Top = 42
          Width = 72
          Height = 12
          Caption = 'Server Port:'
        end
        object EditServerAddr: TEdit
          Left = 72
          Top = 12
          Width = 105
          Height = 20
          TabOrder = 0
          OnChange = EditServerAddrChange
        end
        object EditServerPort: TEdit
          Left = 72
          Top = 38
          Width = 57
          Height = 20
          TabOrder = 1
          OnChange = EditServerPortChange
        end
      end
      object GroupBox8: TGroupBox
        Left = 199
        Top = 8
        Width = 185
        Height = 65
        Caption = 'SQL Network Settings'
        TabOrder = 3
        object Label11: TLabel
          Left = 8
          Top = 18
          Width = 42
          Height = 12
          Caption = 'SQL IP:'
        end
        object Label12: TLabel
          Left = 8
          Top = 42
          Width = 48
          Height = 12
          Caption = 'SQL Port'
        end
        object EditSQLAddr: TEdit
          Left = 72
          Top = 14
          Width = 105
          Height = 20
          TabOrder = 0
          OnChange = EditSQLAddrChange
        end
        object EditSQLPort: TEdit
          Left = 72
          Top = 38
          Width = 57
          Height = 20
          TabOrder = 1
          OnChange = EditSQLPortChange
        end
      end
    end
  end
  object ButtonSave: TButton
    Left = 253
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Save(&S)'
    TabOrder = 1
    OnClick = ButtonSaveClick
  end
  object ButtonClose: TButton
    Left = 334
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Close(&O)'
    TabOrder = 2
    OnClick = ButtonCloseClick
  end
  object ButtonRestoreNet: TButton
    Left = 172
    Top = 206
    Width = 75
    Height = 26
    Caption = 'Default(&D)'
    TabOrder = 3
    OnClick = ButtonRestoreNetClick
  end
end
