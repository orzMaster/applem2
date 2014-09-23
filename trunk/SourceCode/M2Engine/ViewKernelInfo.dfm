object frmViewKernelInfo: TfrmViewKernelInfo
  Left = 818
  Top = 584
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #20869#26680#25968#25454#26597#30475
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
      Caption = #20840#23616#21464#37327
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ListViewInteger: TListView
        Left = 9
        Top = 9
        Width = 359
        Height = 139
        Columns = <
          item
            Caption = #24207#21495
          end
          item
            Caption = #24403#21069#25968#20540
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
            Caption = #24207#21495
          end
          item
            Caption = #24403#21069#23383#31526#20018
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
        Caption = #28165#31354#21464#37327'&G'
        TabOrder = 2
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 105
        Top = 312
        Width = 80
        Height = 25
        Caption = #28165#31354#21464#37327'&A'
        TabOrder = 3
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 289
        Top = 312
        Width = 80
        Height = 25
        Caption = #21047#26032'(R)'
        TabOrder = 4
        Visible = False
      end
    end
    object TabSheet1: TTabSheet
      Caption = #28216#25103#25968#25454
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox1: TGroupBox
        Left = 8
        Top = 4
        Width = 168
        Height = 133
        Caption = #28216#25103#25968#25454#24211
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 20
          Width = 78
          Height = 12
          Caption = #35835#21462#35831#27714#27425#25968':'
        end
        object Label2: TLabel
          Left = 8
          Top = 44
          Width = 78
          Height = 12
          Caption = #35835#21462#22833#36133#27425#25968':'
        end
        object Label3: TLabel
          Left = 8
          Top = 68
          Width = 78
          Height = 12
          Caption = #20445#23384#35831#27714#27425#25968':'
        end
        object Label4: TLabel
          Left = 8
          Top = 92
          Width = 78
          Height = 12
          Caption = #35831#27714#26631#35782#25968#23383':'
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
          ReadOnly = True
          TabOrder = 3
        end
      end
      object GroupBox4: TGroupBox
        Left = 182
        Top = 4
        Width = 190
        Height = 133
        Caption = #29289#21697#31995#21015#21495
        TabOrder = 1
        object Label7: TLabel
          Left = 8
          Top = 20
          Width = 78
          Height = 12
          Caption = #24618#29289#25481#33853#29289#21697':'
        end
        object Label8: TLabel
          Left = 8
          Top = 44
          Width = 78
          Height = 12
          Caption = #21629#20196#21046#36896#29289#21697':'
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
        Caption = #20013#22870#27604#20363
        TabOrder = 2
        object Label9: TLabel
          Left = 8
          Top = 20
          Width = 42
          Height = 12
          Caption = #19968#31561#22870':'
        end
        object Label10: TLabel
          Left = 8
          Top = 44
          Width = 42
          Height = 12
          Caption = #20108#31561#22870':'
        end
        object Label11: TLabel
          Left = 8
          Top = 68
          Width = 42
          Height = 12
          Caption = #19977#31561#22870':'
        end
        object Label12: TLabel
          Left = 8
          Top = 92
          Width = 42
          Height = 12
          Caption = #22235#31561#22870':'
        end
        object Label13: TLabel
          Left = 8
          Top = 116
          Width = 42
          Height = 12
          Caption = #20116#31561#22870':'
        end
        object Label14: TLabel
          Left = 8
          Top = 140
          Width = 42
          Height = 12
          Caption = #20845#31561#22870':'
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
        Caption = #20013#22870#25968#37327
        TabOrder = 3
        object Label5: TLabel
          Left = 8
          Top = 20
          Width = 54
          Height = 12
          Caption = #20013#22870#24635#25968':'
        end
        object Label6: TLabel
          Left = 8
          Top = 44
          Width = 54
          Height = 12
          Caption = #26410#20013#22870#25968':'
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
      Caption = #24037#20316#32447#31243
      ImageIndex = 4
      object GroupBox7: TGroupBox
        Left = 10
        Top = 3
        Width = 364
        Height = 137
        Caption = #32447#31243#29366#24577
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
      Caption = #26597#30475'(&V)'
      object N1: TMenuItem
        Caption = #26356#26032#36895#24230'(&U)'
        object N2: TMenuItem
          Caption = #39640'(&H)'
        end
        object N3: TMenuItem
          Caption = #26631#20934'(&N)'
          Checked = True
        end
        object N4: TMenuItem
          Caption = #20302'(&L)'
        end
      end
    end
    object A1: TMenuItem
      Caption = #20851#20110'(&A)'
    end
  end
end
