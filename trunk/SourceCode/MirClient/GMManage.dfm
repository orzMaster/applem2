object FormGMManage: TFormGMManage
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'GM Mnagement'
  ClientHeight = 310
  ClientWidth = 538
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pgc1: TPageControl
    Left = 9
    Top = 9
    Width = 520
    Height = 301
    ActivePage = ts1
    Align = alClient
    Style = tsButtons
    TabOrder = 0
    object ts5: TTabSheet
      Caption = 'Basic Options'
      ImageIndex = 1
      object grp2: TGroupBox
        Left = 3
        Top = 3
        Width = 134
        Height = 254
        Caption = 'Basic Settings'
        TabOrder = 0
        object chk1: TCheckBox
          Left = 16
          Top = 24
          Width = 115
          Height = 17
          Caption = 'Show Item ID No.'
          TabOrder = 0
        end
      end
    end
    object ts1: TTabSheet
      Caption = 'Item Adjustment'
      object grp1: TGroupBox
        Left = 2
        Top = 3
        Width = 135
        Height = 263
        BiDiMode = bdLeftToRight
        Caption = 'List of items'
        ParentBiDiMode = False
        TabOrder = 0
        object lstItems: TListBox
          Left = 8
          Top = 40
          Width = 118
          Height = 216
          ItemHeight = 13
          TabOrder = 0
          OnClick = lstItemsClick
        end
        object cbbSelectList: TComboBox
          Left = 8
          Top = 14
          Width = 118
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 1
          OnChange = cbbSelectListChange
          Items.Strings = (
            ''
            #32972#21253#29289#21697
            #36523#19978#35013#22791)
        end
      end
      object pgcts4: TPageControl
        Left = 152
        Top = 8
        Width = 356
        Height = 259
        ActivePage = ts3
        Style = tsButtons
        TabOrder = 1
        object ts2: TTabSheet
          Caption = 'Basic Attributes'
          object lbl7: TLabel
            Left = 3
            Top = 88
            Width = 26
            Height = 13
            Caption = 'Time:'
          end
          object lbl5: TLabel
            Left = 3
            Top = 111
            Width = 53
            Height = 13
            Caption = 'Item Mode:'
          end
          object lbl4: TLabel
            Left = 143
            Top = 61
            Width = 50
            Height = 13
            Caption = 'Sustained:'
          end
          object lbl3: TLabel
            Left = 1
            Top = 61
            Width = 40
            Height = 13
            Caption = 'Durable:'
          end
          object lbl2: TLabel
            Left = 1
            Top = 35
            Width = 63
            Height = 13
            Caption = 'Item Number:'
          end
          object lbl1: TLabel
            Left = 3
            Top = 9
            Width = 37
            Height = 13
            Caption = 'Item ID:'
          end
          object edtTime: TEdit
            Left = 63
            Top = 85
            Width = 214
            Height = 21
            TabOrder = 0
            Text = '1234567890'
          end
          object seMaxDura: TSpinEdit
            Left = 203
            Top = 58
            Width = 74
            Height = 21
            MaxValue = 65535
            MinValue = 1
            TabOrder = 1
            Value = 1
            OnChange = seMaxDuraChange
          end
          object seDura: TSpinEdit
            Left = 63
            Top = 58
            Width = 74
            Height = 21
            MaxValue = 65535
            MinValue = 1
            TabOrder = 2
            Value = 1
          end
          object edtID: TEdit
            Left = 63
            Top = 6
            Width = 74
            Height = 21
            Color = clScrollBar
            ReadOnly = True
            TabOrder = 3
            Text = '1234567890'
          end
          object chklstBind1: TCheckListBox
            Left = 63
            Top = 110
            Width = 114
            Height = 116
            BevelInner = bvNone
            BevelOuter = bvNone
            Color = clBtnFace
            ItemHeight = 14
            Items.Strings = (
              'Cannot Trade'
              'Cannote Save'
              'Cannot Repaire'
              'Cannot Discard'
              'Cannot Drop'
              'Cannot Upgrade'
              'Cannot Sell'
              'Cannot Disappear')
            Style = lbOwnerDrawFixed
            TabOrder = 4
          end
          object chklstBind2: TCheckListBox
            Left = 190
            Top = 110
            Width = 91
            Height = 116
            BevelInner = bvNone
            BevelOuter = bvNone
            Color = clBtnFace
            ItemHeight = 14
            Items.Strings = (
              'No Opening'
              'Bound')
            Style = lbOwnerDrawFixed
            TabOrder = 5
          end
          object seIndex: TSpinEdit
            Left = 63
            Top = 32
            Width = 74
            Height = 21
            MaxValue = 65535
            MinValue = 1
            TabOrder = 6
            Value = 1
          end
          object Button1: TButton
            Left = 143
            Top = 4
            Width = 66
            Height = 23
            Caption = 'Import Data'
            TabOrder = 7
            OnClick = Button1Click
          end
        end
        object ts3: TTabSheet
          Caption = 'Special Attributes'
          ImageIndex = 1
          object lbl6: TLabel
            Left = 3
            Top = 9
            Width = 41
            Height = 13
            Caption = 'Element:'
          end
          object lbl8: TLabel
            Left = 3
            Top = 35
            Width = 26
            Height = 13
            Caption = 'Slots:'
          end
          object lbl9: TLabel
            Left = 3
            Top = 62
            Width = 35
            Height = 13
            Caption = 'Slot ID:'
          end
          object lbl10: TLabel
            Left = 119
            Top = 62
            Width = 50
            Height = 13
            Caption = #20985#27133#20108'ID:'
          end
          object lbl11: TLabel
            Left = 235
            Top = 62
            Width = 50
            Height = 13
            Caption = #20985#27133#19977'ID:'
          end
          object lbl12: TLabel
            Left = 119
            Top = 89
            Width = 51
            Height = 13
            Caption = #21487#24378#21270#25968':'
          end
          object lbl13: TLabel
            Left = 3
            Top = 89
            Width = 31
            Height = 13
            Caption = 'Count:'
          end
          object lbl14: TLabel
            Left = 3
            Top = 116
            Width = 33
            Height = 13
            Caption = #24378#21270'3:'
          end
          object lbl18: TLabel
            Left = 178
            Top = 116
            Width = 33
            Height = 13
            Caption = #24378#21270'6:'
          end
          object lbl15: TLabel
            Left = 178
            Top = 142
            Width = 39
            Height = 13
            Caption = #24378#21270'12:'
          end
          object lbl16: TLabel
            Left = 3
            Top = 142
            Width = 33
            Height = 13
            Caption = #24378#21270'9:'
          end
          object lbl17: TLabel
            Left = 178
            Top = 168
            Width = 39
            Height = 13
            Caption = #24378#21270'18:'
          end
          object lbl19: TLabel
            Left = 3
            Top = 168
            Width = 39
            Height = 13
            Caption = #24378#21270'15:'
          end
          object cbbWuXin: TComboBox
            Left = 63
            Top = 6
            Width = 50
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 0
            Text = #26080
            Items.Strings = (
              #26080
              #37329
              #26408
              #27700
              #28779
              #22303)
          end
          object seFluteCount: TSpinEdit
            Left = 63
            Top = 32
            Width = 50
            Height = 22
            MaxValue = 3
            MinValue = 0
            TabOrder = 1
            Value = 1
            OnChange = seFluteCountChange
          end
          object seFlute1: TSpinEdit
            Left = 63
            Top = 59
            Width = 50
            Height = 22
            MaxValue = 65535
            MinValue = 0
            TabOrder = 2
            Value = 1
          end
          object seFlute2: TSpinEdit
            Left = 179
            Top = 59
            Width = 50
            Height = 22
            MaxValue = 65535
            MinValue = 0
            TabOrder = 3
            Value = 1
          end
          object seFlute3: TSpinEdit
            Left = 295
            Top = 59
            Width = 50
            Height = 22
            MaxValue = 65535
            MinValue = 0
            TabOrder = 4
            Value = 1
          end
          object cbbStrengthenMax: TComboBox
            Left = 179
            Top = 86
            Width = 50
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 5
            Text = '0'
            OnChange = cbbStrengthenMaxChange
            Items.Strings = (
              '0'
              '3'
              '6'
              '9'
              '12'
              '15'
              '18')
          end
          object seStrengthenCount: TSpinEdit
            Left = 63
            Top = 86
            Width = 50
            Height = 22
            MaxValue = 18
            MinValue = 0
            TabOrder = 6
            Value = 1
          end
          object cbbStrengthen3: TComboBox
            Left = 51
            Top = 113
            Width = 120
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 7
          end
          object cbbStrengthen6: TComboBox
            Left = 223
            Top = 113
            Width = 120
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 8
          end
          object cbbStrengthen12: TComboBox
            Left = 223
            Top = 139
            Width = 120
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 9
          end
          object cbbStrengthen9: TComboBox
            Left = 51
            Top = 139
            Width = 120
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 10
          end
          object cbbStrengthen18: TComboBox
            Left = 223
            Top = 165
            Width = 120
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 11
          end
          object cbbStrengthen15: TComboBox
            Left = 51
            Top = 165
            Width = 120
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 12
          end
        end
        object ts4: TTabSheet
          Caption = 'Additional Attributes'
          ImageIndex = 2
          object lbl20: TLabel
            Left = 3
            Top = 32
            Width = 49
            Height = 13
            Caption = #39764#27861'MC2:'
          end
          object lbl21: TLabel
            Left = 3
            Top = 9
            Width = 47
            Height = 13
            Caption = #38450#24481'AC2:'
          end
          object lbl22: TLabel
            Left = 3
            Top = 55
            Width = 50
            Height = 13
            Caption = #39764#24481'MAC:'
          end
          object lbl23: TLabel
            Left = 3
            Top = 78
            Width = 41
            Height = 13
            Caption = #36947#26415'SC:'
          end
          object lbl24: TLabel
            Left = 3
            Top = 101
            Width = 27
            Height = 13
            Caption = #20934#30830':'
          end
          object lbl25: TLabel
            Left = 3
            Top = 124
            Width = 51
            Height = 13
            Caption = #27602#29289#36530#36991':'
          end
          object lbl26: TLabel
            Left = 3
            Top = 148
            Width = 51
            Height = 13
            Caption = #39764#27861#24674#22797':'
          end
          object lbl27: TLabel
            Left = 3
            Top = 172
            Width = 27
            Height = 13
            Caption = #35781#21650':'
          end
          object lbl28: TLabel
            Left = 117
            Top = 9
            Width = 56
            Height = 13
            Caption = #39764#24481'MAC2:'
          end
          object lbl29: TLabel
            Left = 117
            Top = 32
            Width = 47
            Height = 13
            Caption = #36947#26415'SC2:'
          end
          object lbl30: TLabel
            Left = 117
            Top = 55
            Width = 42
            Height = 13
            Caption = #25915#20987'DC:'
          end
          object lbl31: TLabel
            Left = 117
            Top = 78
            Width = 39
            Height = 13
            Caption = #29983#21629#20540':'
          end
          object lbl32: TLabel
            Left = 117
            Top = 101
            Width = 27
            Height = 13
            Caption = #25935#25463':'
          end
          object lbl33: TLabel
            Left = 117
            Top = 124
            Width = 51
            Height = 13
            Caption = #20985#27133#25968#37327':'
          end
          object lbl34: TLabel
            Left = 117
            Top = 148
            Width = 51
            Height = 13
            Caption = #27602#29289#24674#22797':'
          end
          object lbl35: TLabel
            Left = 117
            Top = 172
            Width = 51
            Height = 13
            Caption = #20260#23475#21152#25104':'
          end
          object lbl36: TLabel
            Left = 233
            Top = 9
            Width = 48
            Height = 13
            Caption = #25915#20987'DC2:'
          end
          object lbl37: TLabel
            Left = 233
            Top = 32
            Width = 41
            Height = 13
            Caption = #38450#24481'AC:'
          end
          object lbl38: TLabel
            Left = 233
            Top = 55
            Width = 43
            Height = 13
            Caption = #39764#27861'MC:'
          end
          object lbl39: TLabel
            Left = 233
            Top = 78
            Width = 39
            Height = 13
            Caption = #39764#27861#20540':'
          end
          object lbl40: TLabel
            Left = 233
            Top = 101
            Width = 51
            Height = 13
            Caption = #27494#22120#24378#24230':'
          end
          object lbl41: TLabel
            Left = 233
            Top = 124
            Width = 51
            Height = 13
            Caption = #20307#21147#24674#22797':'
          end
          object lbl42: TLabel
            Left = 233
            Top = 148
            Width = 27
            Height = 13
            Caption = #24184#36816':'
          end
          object lbl43: TLabel
            Left = 233
            Top = 172
            Width = 51
            Height = 13
            Caption = #20260#23475#21560#25910':'
          end
          object lbl44: TLabel
            Left = 233
            Top = 196
            Width = 51
            Height = 13
            Caption = #33268#21629#19968#20987':'
          end
          object lbl45: TLabel
            Left = 117
            Top = 196
            Width = 51
            Height = 13
            Caption = #20116#34892#38450#24481':'
          end
          object lbl46: TLabel
            Left = 3
            Top = 196
            Width = 51
            Height = 13
            Caption = #20116#34892#25915#20987':'
          end
          object se9: TSpinEdit
            Left = 63
            Top = 6
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 0
            Value = 1
          end
          object se10: TSpinEdit
            Tag = 3
            Left = 63
            Top = 29
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 1
            Value = 1
          end
          object se11: TSpinEdit
            Tag = 6
            Left = 63
            Top = 52
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 2
            Value = 1
          end
          object se12: TSpinEdit
            Tag = 9
            Left = 63
            Top = 75
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 3
            Value = 1
          end
          object se13: TSpinEdit
            Tag = 12
            Left = 63
            Top = 98
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 4
            Value = 1
          end
          object se14: TSpinEdit
            Tag = 15
            Left = 63
            Top = 121
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 5
            Value = 1
          end
          object se15: TSpinEdit
            Tag = 18
            Left = 63
            Top = 145
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 6
            Value = 1
          end
          object se16: TSpinEdit
            Tag = 21
            Left = 63
            Top = 169
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 7
            Value = 1
          end
          object se17: TSpinEdit
            Tag = 1
            Left = 177
            Top = 6
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 8
            Value = 1
          end
          object se18: TSpinEdit
            Tag = 4
            Left = 177
            Top = 29
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 9
            Value = 1
          end
          object se19: TSpinEdit
            Tag = 7
            Left = 177
            Top = 52
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 10
            Value = 1
          end
          object se20: TSpinEdit
            Tag = 10
            Left = 177
            Top = 75
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 11
            Value = 1
          end
          object se21: TSpinEdit
            Tag = 13
            Left = 177
            Top = 98
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 12
            Value = 1
          end
          object se22: TSpinEdit
            Tag = 16
            Left = 177
            Top = 121
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 13
            Value = 1
          end
          object se23: TSpinEdit
            Tag = 19
            Left = 177
            Top = 145
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 14
            Value = 1
          end
          object se24: TSpinEdit
            Tag = 22
            Left = 177
            Top = 169
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 15
            Value = 1
          end
          object se25: TSpinEdit
            Tag = 2
            Left = 293
            Top = 6
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 16
            Value = 1
          end
          object se26: TSpinEdit
            Tag = 5
            Left = 293
            Top = 29
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 17
            Value = 1
          end
          object se27: TSpinEdit
            Tag = 8
            Left = 293
            Top = 52
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 18
            Value = 1
          end
          object se28: TSpinEdit
            Tag = 11
            Left = 293
            Top = 75
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 19
            Value = 1
          end
          object se29: TSpinEdit
            Tag = 14
            Left = 293
            Top = 98
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 20
            Value = 1
          end
          object se30: TSpinEdit
            Tag = 17
            Left = 293
            Top = 121
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 21
            Value = 1
          end
          object se31: TSpinEdit
            Tag = 20
            Left = 293
            Top = 145
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 22
            Value = 1
          end
          object se32: TSpinEdit
            Tag = 23
            Left = 293
            Top = 169
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 23
            Value = 1
          end
          object se33: TSpinEdit
            Tag = 26
            Left = 293
            Top = 193
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 24
            Value = 1
          end
          object se34: TSpinEdit
            Tag = 25
            Left = 177
            Top = 193
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 25
            Value = 1
          end
          object se35: TSpinEdit
            Tag = 24
            Left = 63
            Top = 193
            Width = 50
            Height = 22
            MaxValue = 255
            MinValue = 0
            TabOrder = 26
            Value = 1
          end
        end
      end
      object btnSave: TButton
        Left = 159
        Top = 250
        Width = 54
        Height = 18
        Caption = 'Save'
        TabOrder = 2
        OnClick = btnSaveClick
      end
    end
  end
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 538
    Height = 9
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
  end
  object pnl2: TPanel
    Left = 0
    Top = 9
    Width = 9
    Height = 301
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 2
  end
  object pnl3: TPanel
    Left = 529
    Top = 9
    Width = 9
    Height = 301
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 3
  end
  object OpenDialog1: TOpenDialog
    Left = 384
    Top = 72
  end
end
