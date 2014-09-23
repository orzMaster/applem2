object FormView: TFormView
  Left = 208
  Top = 112
  Caption = #26085#24535#20998#26512#31383#21475
  ClientHeight = 566
  ClientWidth = 1001
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1001
    Height = 90
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 25
      Top = 14
      Width = 48
      Height = 12
      Caption = #24320#22987#26085#26399
    end
    object Label2: TLabel
      Left = 201
      Top = 14
      Width = 48
      Height = 12
      Caption = #32467#26463#26085#26399
    end
    object DateTimeBegin: TDateTimePicker
      Left = 79
      Top = 10
      Width = 98
      Height = 20
      Date = 39234.007245185190000000
      Time = 39234.007245185190000000
      TabOrder = 0
    end
    object DateTimeEnd: TDateTimePicker
      Left = 255
      Top = 10
      Width = 98
      Height = 20
      Date = 39234.007245185190000000
      Time = 39234.007245185190000000
      TabOrder = 1
    end
    object BitBtnOK: TBitBtn
      Left = 914
      Top = 56
      Width = 81
      Height = 25
      Caption = #21047#26032'(&S)'
      TabOrder = 2
      OnClick = BitBtnOKClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333444444
        33333333333F8888883F33330000324334222222443333388F3833333388F333
        000032244222222222433338F8833FFFFF338F3300003222222AAAAA22243338
        F333F88888F338F30000322222A33333A2224338F33F8333338F338F00003222
        223333333A224338F33833333338F38F00003222222333333A444338FFFF8F33
        3338888300003AAAAAAA33333333333888888833333333330000333333333333
        333333333333333333FFFFFF000033333333333344444433FFFF333333888888
        00003A444333333A22222438888F333338F3333800003A2243333333A2222438
        F38F333333833338000033A224333334422224338338FFFFF8833338000033A2
        22444442222224338F3388888333FF380000333A2222222222AA243338FF3333
        33FF88F800003333AA222222AA33A3333388FFFFFF8833830000333333AAAAAA
        3333333333338888883333330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 38
      Width = 65
      Height = 17
      Caption = #20154#29289#21517#31216
      TabOrder = 3
    end
    object Edit2: TEdit
      Left = 79
      Top = 36
      Width = 98
      Height = 20
      TabOrder = 4
    end
    object Edit3: TEdit
      Left = 79
      Top = 62
      Width = 98
      Height = 20
      TabOrder = 5
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 64
      Width = 65
      Height = 17
      Caption = #29289#21697#21517#31216
      TabOrder = 6
    end
    object Edit4: TEdit
      Left = 255
      Top = 36
      Width = 98
      Height = 20
      TabOrder = 7
    end
    object CheckBox3: TCheckBox
      Left = 184
      Top = 38
      Width = 65
      Height = 17
      Caption = #20132#26131#23545#20687
      TabOrder = 8
    end
    object CheckBox4: TCheckBox
      Left = 184
      Top = 64
      Width = 65
      Height = 17
      Caption = #29289#21697'ID'
      TabOrder = 9
    end
    object Edit5: TEdit
      Left = 255
      Top = 62
      Width = 98
      Height = 20
      TabOrder = 10
    end
    object GroupBox1: TGroupBox
      Left = 490
      Top = 5
      Width = 418
      Height = 77
      Caption = #21160#20316#36873#25321
      TabOrder = 11
      object CheckBox5: TCheckBox
        Left = 8
        Top = 16
        Width = 73
        Height = 17
        Caption = #20154#29289#27515#20129
        TabOrder = 0
      end
      object CheckBox6: TCheckBox
        Left = 8
        Top = 35
        Width = 73
        Height = 17
        Caption = #37329#24065#25913#21464
        TabOrder = 1
      end
      object CheckBox7: TCheckBox
        Left = 8
        Top = 54
        Width = 73
        Height = 17
        Caption = #32465#37329#25913#21464
        TabOrder = 2
      end
      object CheckBox8: TCheckBox
        Left = 87
        Top = 16
        Width = 73
        Height = 17
        Caption = #28857#21367#25913#21464
        TabOrder = 3
      end
      object CheckBox9: TCheckBox
        Left = 87
        Top = 35
        Width = 73
        Height = 17
        Caption = #20803#23453#25913#21464
        TabOrder = 4
      end
      object CheckBox10: TCheckBox
        Left = 87
        Top = 54
        Width = 73
        Height = 17
        Caption = #31215#20998#25913#21464
        TabOrder = 5
      end
      object CheckBox11: TCheckBox
        Left = 166
        Top = 16
        Width = 73
        Height = 17
        Caption = #25968#37327#25913#21464
        TabOrder = 6
      end
      object CheckBox12: TCheckBox
        Left = 166
        Top = 35
        Width = 73
        Height = 17
        Caption = #22686#21152#29289#21697
        TabOrder = 7
      end
      object CheckBox13: TCheckBox
        Left = 166
        Top = 54
        Width = 73
        Height = 17
        Caption = #20943#23569#29289#21697
        TabOrder = 8
      end
      object CheckBox14: TCheckBox
        Left = 245
        Top = 16
        Width = 73
        Height = 17
        Caption = #20179#24211#23384#21462
        TabOrder = 9
      end
      object CheckBox15: TCheckBox
        Left = 245
        Top = 35
        Width = 73
        Height = 17
        Caption = #24378#21270#25913#21464
        TabOrder = 10
      end
      object CheckBox16: TCheckBox
        Left = 245
        Top = 54
        Width = 73
        Height = 17
        Caption = #35843#25972#29289#21697
        TabOrder = 11
      end
      object CheckBox17: TCheckBox
        Left = 324
        Top = 16
        Width = 73
        Height = 17
        Caption = #22768#26395#25913#21464
        TabOrder = 12
      end
      object CheckBox21: TCheckBox
        Left = 324
        Top = 33
        Width = 73
        Height = 17
        Caption = #20154#29289#21464#37327
        TabOrder = 13
      end
    end
    object Edit1: TEdit
      Left = 423
      Top = 36
      Width = 61
      Height = 20
      TabOrder = 12
    end
    object CheckBox18: TCheckBox
      Left = 359
      Top = 38
      Width = 57
      Height = 17
      Caption = #22791#27880#20108
      TabOrder = 13
    end
    object CheckBox19: TCheckBox
      Left = 360
      Top = 64
      Width = 57
      Height = 17
      Caption = #22791#27880#19977
      TabOrder = 14
    end
    object Edit6: TEdit
      Left = 423
      Top = 62
      Width = 61
      Height = 20
      TabOrder = 15
    end
    object CheckBox20: TCheckBox
      Left = 359
      Top = 13
      Width = 57
      Height = 17
      Caption = #22791#27880#19968
      TabOrder = 16
    end
    object Edit7: TEdit
      Left = 423
      Top = 10
      Width = 61
      Height = 20
      TabOrder = 17
    end
    object BitBtn1: TBitBtn
      Left = 914
      Top = 10
      Width = 81
      Height = 25
      Caption = #28165#38500'(&C)'
      TabOrder = 18
      OnClick = BitBtnOKClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333333333000033338833333333333333333F333333333333
        0000333911833333983333333388F333333F3333000033391118333911833333
        38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
        911118111118333338F3338F833338F3000033333911111111833333338F3338
        3333F8330000333333911111183333333338F333333F83330000333333311111
        8333333333338F3333383333000033333339111183333333333338F333833333
        00003333339111118333333333333833338F3333000033333911181118333333
        33338333338F333300003333911183911183333333383338F338F33300003333
        9118333911183333338F33838F338F33000033333913333391113333338FF833
        38F338F300003333333333333919333333388333338FFF830000333333333333
        3333333333333333333888330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
    object ComboBox1: TComboBox
      Left = 914
      Top = 35
      Width = 81
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 19
      Text = 'AND'
      Items.Strings = (
        'AND'
        'OR')
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 90
    Width = 1001
    Height = 476
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object LogGrid: TStringGrid
      Left = 0
      Top = 0
      Width = 1001
      Height = 476
      Align = alClient
      ColCount = 14
      DefaultRowHeight = 17
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
      PopupMenu = pm1
      TabOrder = 0
      OnMouseDown = LogGridMouseDown
      OnSelectCell = LogGridSelectCell
      ColWidths = (
        38
        70
        51
        37
        39
        92
        88
        67
        66
        88
        67
        66
        71
        124)
    end
  end
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 16
    Top = 97
  end
  object pm1: TPopupMenu
    AutoHotkeys = maManual
    AutoPopup = False
    Left = 80
    Top = 96
    object Menu_ItemName: TMenuItem
      Caption = #29289#21697#21517#31216
    end
    object Menu_ItemID: TMenuItem
      Caption = #29289#21697'ID'
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Menu_Write: TMenuItem
      Caption = #23548#20986#29289#21697#25968#25454'(&W)'
      OnClick = Menu_WriteClick
    end
  end
  object dlgSave1: TSaveDialog
    DefaultExt = '.item'
    Filter = #29289#21697#25968#25454'|*.item|'#25152#26377#25991#20214'|*.*'
    Options = [ofHideReadOnly, ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofNoReadOnlyReturn, ofNoNetworkButton, ofNoLongNames, ofEnableSizing]
    OptionsEx = [ofExNoPlacesBar]
    Left = 48
    Top = 96
  end
end
