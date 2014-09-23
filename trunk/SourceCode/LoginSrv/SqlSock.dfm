object FrmSqlSock: TFrmSqlSock
  Left = 0
  Top = 0
  Caption = 'FrmSqlSock'
  ClientHeight = 100
  ClientWidth = 151
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 72
    Top = 32
  end
  object SqlSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = SqlSocketConnect
    OnDisconnect = SqlSocketDisconnect
    OnRead = SqlSocketRead
    OnError = SqlSocketError
    Left = 40
    Top = 32
  end
end
