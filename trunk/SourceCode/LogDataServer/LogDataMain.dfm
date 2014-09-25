object FormMain: TFormMain
  Left = 230
  Top = 113
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'LogDataServer'
  ClientHeight = 38
  ClientWidth = 298
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 6
    Top = 6
    Width = 70
    Height = 13
    Caption = 'Current log file:'
  end
  object Label2: TLabel
    Left = 6
    Top = 23
    Width = 47
    Height = 13
    Caption = 'File Name'
  end
  object Label3: TLabel
    Left = 88
    Top = 6
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Memo1: TMemo
    Left = 0
    Top = 48
    Width = 297
    Height = 145
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object CheckBox1: TCheckBox
    Left = 218
    Top = 5
    Width = 72
    Height = 17
    Caption = 'View error'
    TabOrder = 1
    OnClick = CheckBox1Click
  end
  object MainMenu1: TMainMenu
    Left = 192
    Top = 8
    object V1: TMenuItem
      Caption = 'View'
      object MEMU_VIEW_LOGVIEW: TMenuItem
        Caption = 'Log Query (&L)'
        OnClick = MEMU_VIEW_LOGVIEWClick
      end
    end
    object H1: TMenuItem
      Caption = 'Help'
      object MEMU_HELP_ABOUT: TMenuItem
        Caption = 'About(&A)'
        OnClick = MEMU_HELP_ABOUTClick
      end
    end
  end
  object TimerSave: TTimer
    Interval = 3000
    OnTimer = TimerSaveTimer
    Left = 160
    Top = 8
  end
  object IdUDPServer: TIdUDPServer
    BufferSize = 81920
    Bindings = <
      item
        IP = '0.0.0.0'
        Port = 0
      end>
    DefaultPort = 0
    OnUDPRead = IdUDPServerUDPRead
    Left = 224
    Top = 8
  end
  object ADOQuery1: TADOQuery
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=.\db.mdb;Persist Se' +
      'curity Info=False'
    Parameters = <>
    SQL.Strings = (
      'sql')
    Left = 104
    Top = 8
  end
  object ApplicationEvents1: TApplicationEvents
    OnException = ApplicationEvents1Exception
    Left = 136
    Top = 8
  end
end
