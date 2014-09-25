object frmViewKernelInfo: TfrmViewKernelInfo
  Left = 818
  Top = 584
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Kernal Data View'
  ClientHeight = 389
  ClientWidth = 403
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 385
    Height = 373
    ActivePage = TabSheet5
    TabOrder = 0
    object TabSheet3: TTabSheet
      Caption = 'Global Variables'
      ImageIndex = 2
      object ListViewInteger: TListView
        Left = 9
        Top = 9
        Width = 359
        Height = 139
        Columns = <
          item
            Caption = 'No.'
          end
          item
            Caption = 'Current Value'
            Width = 285
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = ListViewIntegerDblClick
      end
      object ListViewString: TListView
        Left = 9
        Top = 163
        Width = 359
        Height = 139
        Columns = <
          item
            Caption = 'No.'
          end
          item
            Caption = 'Current String'
            Width = 285
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 1
        ViewStyle = vsReport
        OnDblClick = ListViewStringDblClick
      end
      object Button1: TButton
        Left = 8
        Top = 312
        Width = 80
        Height = 25
        Caption = 'Empty(&G)'
        TabOrder = 2
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 105
        Top = 312
        Width = 80
        Height = 25
        Caption = 'Empty(&A)'
        TabOrder = 3
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 289
        Top = 312
        Width = 80
        Height = 25
        Caption = 'Refresh(&R)'
        TabOrder = 4
        Visible = False
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Game Data'
      object GroupBox1: TGroupBox
        Left = 8
        Top = 4
        Width = 168
        Height = 133
        Caption = 'Game Database'
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 20
          Width = 78
          Height = 12
          Caption = 'Read Request:'
        end
        object Label2: TLabel
          Left = 8
          Top = 44
          Width = 78
          Height = 12
          Caption = 'Read Failure:'
        end
        object Label3: TLabel
          Left = 8
          Top = 68
          Width = 78
          Height = 12
          Caption = 'Save Request:'
        end
        object Label4: TLabel
          Left = 8
          Top = 92
          Width = 78
          Height = 12
          Caption = 'Identication:'
        end
        object EditLoadHumanDBCount: TEdit
          Left = 88
          Top = 16
          Width = 71
          Height = 20
          ReadOnly = True
          TabOrder = 0
        end
        object EditLoadHumanDBErrorCoun: TEdit
          Left = 88
          Top = 40
          Width = 71
          Height = 20
          ReadOnly = True
          TabOrder = 1
        end
        object EditSaveHumanDBCount: TEdit
          Left = 88
          Top = 64
          Width = 71
          Height = 20
          ReadOnly = True
          TabOrder = 2
        end
        object EditHumanDBQueryID: TEdit
          Left = 88
          Top = 88
          Width = 71
          Height = 20
          Hint = 'Request Identifcation Number'
          ReadOnly = True
          TabOrder = 3
        end
      end
      object GroupBox4: TGroupBox
        Left = 182
        Top = 4
        Width = 190
        Height = 133
        Caption = 'Items Serial No'
        TabOrder = 1
        object Label7: TLabel
          Left = 8
          Top = 20
          Width = 78
          Height = 12
          Caption = 'Monster Loot:'
        end
        object Label8: TLabel
          Left = 8
          Top = 44
          Width = 78
          Height = 12
          Caption = 'Manufactured:'
        end
        object EditItemNumber: TEdit
          Left = 88
          Top = 16
          Width = 93
          Height = 20
          ReadOnly = True
          TabOrder = 0
        end
        object EditItemNumberEx: TEdit
          Left = 88
          Top = 40
          Width = 93
          Height = 20
          ReadOnly = True
          TabOrder = 1
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 156
        Width = 168
        Height = 187
        Caption = 'Winning Percentage'
        TabOrder = 2
        object Label9: TLabel
          Left = 8
          Top = 20
          Width = 48
          Height = 12
          Caption = 'Prize 1:'
        end
        object Label10: TLabel
          Left = 8
          Top = 44
          Width = 48
          Height = 12
          Caption = 'Prize 2:'
        end
        object Label11: TLabel
          Left = 8
          Top = 68
          Width = 48
          Height = 12
          Caption = 'Prize 3:'
        end
        object Label12: TLabel
          Left = 8
          Top = 92
          Width = 48
          Height = 12
          Caption = 'Prize 4:'
        end
        object Label13: TLabel
          Left = 8
          Top = 116
          Width = 48
          Height = 12
          Caption = 'Prize 5:'
        end
        object Label14: TLabel
          Left = 8
          Top = 140
          Width = 48
          Height = 12
          Caption = 'Prize 6:'
        end
        object EditWinLotteryLevel1: TEdit
          Left = 88
          Top = 16
          Width = 71
          Height = 20
          ReadOnly = True
          TabOrder = 0
        end
        object EditWinLotteryLevel2: TEdit
          Left = 88
          Top = 40
          Width = 71
          Height = 20
          ReadOnly = True
          TabOrder = 1
        end
        object EditWinLotteryLevel3: TEdit
          Left = 88
          Top = 64
          Width = 71
          Height = 20
          ReadOnly = True
          TabOrder = 2
        end
        object EditWinLotteryLevel4: TEdit
          Left = 88
          Top = 88
          Width = 71
          Height = 20
          ReadOnly = True
          TabOrder = 3
        end
        object EditWinLotteryLevel5: TEdit
          Left = 88
          Top = 112
          Width = 71
          Height = 20
          ReadOnly = True
          TabOrder = 4
        end
        object EditWinLotteryLevel6: TEdit
          Left = 88
          Top = 136
          Width = 71
          Height = 20
          ReadOnly = True
          TabOrder = 5
        end
      end
      object GroupBox2: TGroupBox
        Left = 182
        Top = 156
        Width = 190
        Height = 187
        Caption = 'Lottery'
        TabOrder = 3
        object Label5: TLabel
          Left = 8
          Top = 20
          Width = 66
          Height = 12
          Caption = 'Total Wins:'
        end
        object Label6: TLabel
          Left = 8
          Top = 44
          Width = 78
          Height = 12
          Caption = 'Non Winners::'
        end
        object EditWinLotteryCount: TEdit
          Left = 88
          Top = 16
          Width = 93
          Height = 20
          ReadOnly = True
          TabOrder = 0
        end
        object EditNoWinLotteryCount: TEdit
          Left = 88
          Top = 40
          Width = 93
          Height = 20
          ReadOnly = True
          TabOrder = 1
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Worker Thread'
      ImageIndex = 4
      object GroupBox7: TGroupBox
        Left = 10
        Top = 3
        Width = 364
        Height = 137
        Caption = 'Thread State'
        TabOrder = 0
        object GridThread: TStringGrid
          Left = 10
          Top = 18
          Width = 343
          Height = 108
          DefaultRowHeight = 20
          FixedCols = 0
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
          TabOrder = 0
          ColWidths = (
            48
            50
            51
            102
            84)
        end
      end
    end
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 368
    Top = 360
  end
  object MainMenu1: TMainMenu
    Top = 272
    object V1: TMenuItem
      Caption = 'CheckOut(&V)'
      object N1: TMenuItem
        Caption = 'Update Rate(&U)'
        object N2: TMenuItem
          Caption = 'High(&H)'
        end
        object N3: TMenuItem
          Caption = 'Standard(&N)'
          Checked = True
        end
        object N4: TMenuItem
          Caption = 'Low(&L)'
        end
      end
    end
    object A1: TMenuItem
      Caption = 'Respect(&A)'
    end
  end
end
