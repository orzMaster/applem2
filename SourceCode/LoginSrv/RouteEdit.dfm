object frmRouteEdit: TfrmRouteEdit
  Left = 685
  Top = 549
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  ClientHeight = 216
  ClientWidth = 402
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 385
    Height = 201
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 20
      Width = 84
      Height = 12
      Caption = 'Login Gateway:'
    end
    object EditSelGate: TEdit
      Left = 106
      Top = 17
      Width = 97
      Height = 20
      TabOrder = 0
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 40
      Width = 369
      Height = 121
      Caption = 'Gateway Role'
      TabOrder = 3
      object Label2: TLabel
        Left = 16
        Top = 20
        Width = 12
        Height = 12
        Caption = '1:'
      end
      object Label3: TLabel
        Left = 16
        Top = 44
        Width = 12
        Height = 12
        Caption = '2:'
      end
      object Label4: TLabel
        Left = 16
        Top = 68
        Width = 12
        Height = 12
        Caption = '3:'
      end
      object Label5: TLabel
        Left = 16
        Top = 92
        Width = 12
        Height = 12
        Caption = '4:'
      end
      object Label6: TLabel
        Left = 192
        Top = 20
        Width = 12
        Height = 12
        Caption = '5:'
      end
      object Label7: TLabel
        Left = 192
        Top = 44
        Width = 12
        Height = 12
        Caption = '6:'
      end
      object Label8: TLabel
        Left = 192
        Top = 68
        Width = 12
        Height = 12
        Caption = '7:'
      end
      object Label9: TLabel
        Left = 192
        Top = 92
        Width = 12
        Height = 12
        Caption = '8:'
      end
      object EditGateIPaddr1: TEdit
        Left = 40
        Top = 16
        Width = 97
        Height = 20
        TabOrder = 0
      end
      object EditGateIPaddr2: TEdit
        Left = 40
        Top = 40
        Width = 97
        Height = 20
        TabOrder = 2
      end
      object EditGatePort1: TEdit
        Left = 144
        Top = 16
        Width = 41
        Height = 20
        TabOrder = 1
      end
      object EditGatePort2: TEdit
        Left = 144
        Top = 40
        Width = 41
        Height = 20
        TabOrder = 3
      end
      object EditGateIPaddr3: TEdit
        Left = 40
        Top = 64
        Width = 97
        Height = 20
        TabOrder = 4
      end
      object EditGatePort3: TEdit
        Left = 144
        Top = 64
        Width = 41
        Height = 20
        TabOrder = 5
      end
      object EditGateIPaddr4: TEdit
        Left = 40
        Top = 88
        Width = 97
        Height = 20
        TabOrder = 6
      end
      object EditGatePort4: TEdit
        Left = 144
        Top = 88
        Width = 41
        Height = 20
        TabOrder = 7
      end
      object EditGateIPaddr5: TEdit
        Left = 216
        Top = 16
        Width = 97
        Height = 20
        TabOrder = 8
      end
      object EditGatePort5: TEdit
        Left = 320
        Top = 16
        Width = 41
        Height = 20
        TabOrder = 9
      end
      object EditGateIPaddr6: TEdit
        Left = 216
        Top = 40
        Width = 97
        Height = 20
        TabOrder = 10
      end
      object EditGatePort6: TEdit
        Left = 320
        Top = 40
        Width = 41
        Height = 20
        TabOrder = 11
      end
      object EditGateIPaddr7: TEdit
        Left = 216
        Top = 64
        Width = 97
        Height = 20
        TabOrder = 12
      end
      object EditGatePort7: TEdit
        Left = 320
        Top = 64
        Width = 41
        Height = 20
        TabOrder = 13
      end
      object EditGateIPaddr8: TEdit
        Left = 216
        Top = 88
        Width = 97
        Height = 20
        TabOrder = 14
      end
      object EditGatePort8: TEdit
        Left = 320
        Top = 88
        Width = 41
        Height = 20
        TabOrder = 15
      end
    end
    object ButtonOK: TButton
      Left = 8
      Top = 168
      Width = 73
      Height = 25
      Caption = 'Okay(&O)'
      TabOrder = 1
      OnClick = ButtonOKClick
    end
    object ButtonCancel: TButton
      Left = 88
      Top = 168
      Width = 73
      Height = 25
      Caption = 'Cancel(&C)'
      TabOrder = 2
      OnClick = ButtonOKClick
    end
  end
end
