object frmDlgConfig: TfrmDlgConfig
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #28216#25103#31383#21475#35774#32622
  ClientHeight = 351
  ClientWidth = 359
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 203
    Height = 335
    Caption = #28216#25103#31383#21475#21015#34920
    TabOrder = 0
    object TreeView: TTreeView
      Left = 8
      Top = 18
      Width = 185
      Height = 307
      Indent = 19
      TabOrder = 0
      OnChange = TreeViewChange
    end
  end
  object GameWindowName: TGroupBox
    Left = 217
    Top = 8
    Width = 133
    Height = 175
    Caption = #30456#20851#35774#32622
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 18
      Width = 24
      Height = 12
      Caption = 'Top:'
    end
    object Label3: TLabel
      Left = 8
      Top = 42
      Width = 30
      Height = 12
      Caption = 'Left:'
    end
    object Label4: TLabel
      Left = 8
      Top = 66
      Width = 36
      Height = 12
      Caption = 'Width:'
    end
    object Label5: TLabel
      Left = 8
      Top = 90
      Width = 42
      Height = 12
      Caption = 'Height:'
    end
    object Label6: TLabel
      Left = 8
      Top = 114
      Width = 36
      Height = 12
      Caption = 'Image:'
    end
    object EditTop: TSpinEdit
      Left = 59
      Top = 12
      Width = 65
      Height = 21
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
      OnChange = EditImageChange
    end
    object EditLeft: TSpinEdit
      Left = 59
      Top = 36
      Width = 65
      Height = 21
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
      OnChange = EditImageChange
    end
    object EditHeight: TSpinEdit
      Left = 59
      Top = 84
      Width = 65
      Height = 21
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
      OnChange = EditImageChange
    end
    object EditWidth: TSpinEdit
      Left = 59
      Top = 60
      Width = 65
      Height = 21
      MaxValue = 0
      MinValue = 0
      TabOrder = 3
      Value = 0
      OnChange = EditImageChange
    end
    object EditImage: TSpinEdit
      Left = 59
      Top = 108
      Width = 65
      Height = 21
      MaxValue = 0
      MinValue = 0
      TabOrder = 4
      Value = 0
      OnChange = EditImageChange
    end
    object ButtonShow: TButton
      Left = 26
      Top = 139
      Width = 73
      Height = 25
      Caption = #26174#31034#31383#21475
      TabOrder = 5
      OnClick = ButtonShowClick
    end
  end
end
