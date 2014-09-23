object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #21830#38138#31649#29702#35774#32622
  ClientHeight = 411
  ClientWidth = 750
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000000020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000001111100000000000000000000000000011111000000000000000
    00000000000011111000000000000000000000000353B8700000000000000000
    000000000353B8700000000000000700000000000353B8700000000000007B30
    000077000353B87070000000000007B3000330460353B876007000000000007B
    3000B6660353B8766607000000000007B306BB860353B8766660700000000000
    7B76BBB80353B876666607000000000077BBBBBB0353B8766666600000000000
    07BBBBBB0353B8766666660000000000066BBB8B0353B8766666660000000000
    6666BB860353B876666666070000007066666B660353B8766666666000000070
    666666660353B8766B86666000000006666666660353B8766BB6666000000006
    666666660353B87B6BB8666000000070666666660353B87BBBBB866000000070
    666666660353B87BBBBBB86000000000666666660353B878BBB8BB0700000000
    666666010353B8778BB68B3700000007066660011333B711188666B300000000
    06666660011373310686603B30000000706666666001110666660073B7000000
    0706666666600666666000073B70000000706666666666666600000003B70000
    0007006666666666600000000000000000000700466666000700000000070000
    000000070000007700000000000000000000000000000000000000000000FFC0
    07FFFFC007FFFFC007FFFFF01FFFFFF01FFF3FF01FFF1E0007FF8E0001FFC600
    00FFE000007FF000003FF000003FF000001FE000001FE000000FC000000FC000
    000FC000000FC000000FC000000FC000000FE000000FE000000FE000000FF000
    0007F0000003F8000061FC0000F8FE0001FCFF8003FEFFE00FFFFFFFFFFF}
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 734
    Height = 393
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #21830#38138#21015#34920#37197#32622
      object Label8: TLabel
        Left = 442
        Top = 259
        Width = 12
        Height = 12
        Caption = #22825
      end
      object Label9: TLabel
        Left = 442
        Top = 235
        Width = 36
        Height = 12
        Caption = #29289#21697'ID'
      end
      object Label5: TLabel
        Left = 321
        Top = 235
        Width = 18
        Height = 12
        Caption = 'Id:'
      end
      object Label6: TLabel
        Left = 321
        Top = 259
        Width = 30
        Height = 12
        Caption = #26399#38480':'
      end
      object Label7: TLabel
        Left = 321
        Top = 283
        Width = 30
        Height = 12
        Caption = #31215#20998':'
      end
      object Label4: TLabel
        Left = 160
        Top = 307
        Width = 54
        Height = 12
        Caption = #29289#21697#25551#36848':'
      end
      object Label3: TLabel
        Left = 160
        Top = 283
        Width = 54
        Height = 12
        Caption = #29289#21697#20215#26684':'
      end
      object Label2: TLabel
        Left = 160
        Top = 259
        Width = 54
        Height = 12
        Caption = #29289#21697#21517#31216':'
      end
      object Label1: TLabel
        Left = 160
        Top = 235
        Width = 54
        Height = 12
        Caption = #29289#21697#31867#21035':'
      end
      object ListViewShopList: TListView
        Left = 160
        Top = 24
        Width = 557
        Height = 205
        Columns = <
          item
            Caption = #29289#21697#31867#21035
            Width = 60
          end
          item
            Caption = #29289#21697#21517#31216
            Width = 100
          end
          item
            Caption = 'ID'
            Width = 40
          end
          item
            Caption = #20215#26684
          end
          item
            Caption = #26399#38480
            Width = 40
          end
          item
            Caption = #31215#20998
            Width = 40
          end
          item
            Caption = #20132
            Width = 23
          end
          item
            Caption = #23384
            Width = 23
          end
          item
            Caption = #20462
            Width = 23
          end
          item
            Caption = #20002
            Width = 23
          end
          item
            Caption = #25481
            Width = 23
          end
          item
            Caption = #36896
            Width = 23
          end
          item
            Caption = #29289#21697#25551#36848
            Width = 200
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = ListViewShopListChange
      end
      object ButtonAdd: TButton
        Left = 160
        Top = 330
        Width = 75
        Height = 23
        Caption = #22686#21152'(&A)'
        Enabled = False
        TabOrder = 1
        OnClick = ButtonAddClick
      end
      object ButtonDel: TButton
        Left = 241
        Top = 330
        Width = 75
        Height = 23
        Caption = #21024#38500'(&D)'
        Enabled = False
        TabOrder = 2
        OnClick = ButtonDelClick
      end
      object ButtonEdit: TButton
        Left = 322
        Top = 330
        Width = 75
        Height = 23
        Caption = #20462#25913'(&E)'
        Enabled = False
        TabOrder = 3
        OnClick = ButtonEditClick
      end
      object ButtonSave: TButton
        Left = 403
        Top = 330
        Width = 75
        Height = 23
        Caption = #20445#23384'(&S)'
        TabOrder = 4
        OnClick = ButtonSaveClick
      end
      object ButtonRefur: TButton
        Left = 484
        Top = 330
        Width = 75
        Height = 23
        Caption = #37325#21152#36733'(&R)'
        TabOrder = 5
        OnClick = ButtonRefurClick
      end
      object SpinEditIntegral: TSpinEdit
        Left = 357
        Top = 280
        Width = 79
        Height = 21
        MaxValue = 0
        MinValue = 0
        TabOrder = 6
        Value = 0
      end
      object SpinEditTime: TSpinEdit
        Left = 357
        Top = 256
        Width = 79
        Height = 21
        MaxValue = 0
        MinValue = 0
        TabOrder = 7
        Value = 0
      end
      object SpinEditItems: TSpinEdit
        Left = 357
        Top = 232
        Width = 79
        Height = 21
        Color = clSilver
        Enabled = False
        MaxValue = 0
        MinValue = 0
        TabOrder = 8
        Value = 100
      end
      object ComboBoxClass: TComboBox
        Left = 216
        Top = 232
        Width = 99
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        ItemIndex = 0
        TabOrder = 9
        Text = #26032#21697#19978#24066
        Items.Strings = (
          #26032#21697#19978#24066
          #25512#33616#21830#21697
          #20010#24615#35013#39280
          #28216#25103#34917#32473
          #22909#21451#24198#20856
          #24378#21270#35013#22791)
      end
      object EditName: TEdit
        Left = 216
        Top = 256
        Width = 99
        Height = 20
        Color = clSilver
        Enabled = False
        TabOrder = 10
      end
      object SpinEditPrice: TSpinEdit
        Left = 216
        Top = 280
        Width = 99
        Height = 21
        MaxValue = 0
        MinValue = 0
        TabOrder = 11
        Value = 0
      end
      object EditText: TEdit
        Left = 216
        Top = 304
        Width = 501
        Height = 20
        MaxLength = 127
        TabOrder = 12
        Text = #29289#21697#21151#33021'|'#29289#21697#35814#32454#35828#26126#19968'|'#29289#21697#35814#32454#35828#26126#20108
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 19
        Width = 146
        Height = 334
        Caption = #29289#21697#21015#34920'(Ctrl+F'#26597#25214')'
        TabOrder = 13
        object ListBoxitemList: TListBox
          Left = 8
          Top = 16
          Width = 129
          Height = 305
          ItemHeight = 12
          TabOrder = 0
          OnClick = ListBoxitemListClick
          OnKeyDown = ListBoxitemListKeyDown
        end
      end
      object CheckBox1: TCheckBox
        Left = 488
        Top = 234
        Width = 65
        Height = 17
        Caption = #19981#21487#20132#26131
        TabOrder = 14
      end
      object CheckBox2: TCheckBox
        Left = 568
        Top = 235
        Width = 65
        Height = 17
        Caption = #19981#21487#23384#20179
        TabOrder = 15
      end
      object CheckBox3: TCheckBox
        Left = 488
        Top = 257
        Width = 65
        Height = 17
        Caption = #19981#21487#20462#29702
        TabOrder = 16
      end
      object CheckBox4: TCheckBox
        Left = 568
        Top = 258
        Width = 65
        Height = 17
        Caption = #19981#21487#20002#24323
        TabOrder = 17
      end
      object CheckBox5: TCheckBox
        Left = 488
        Top = 280
        Width = 65
        Height = 17
        Caption = #27704#19981#25481#33853
        TabOrder = 18
      end
      object CheckBox6: TCheckBox
        Left = 568
        Top = 280
        Width = 65
        Height = 17
        Caption = #19981#21487#25171#36896
        TabOrder = 19
      end
      object Button1: TButton
        Left = 565
        Top = 330
        Width = 73
        Height = 23
        Caption = #29983#25104#35828#26126'(&W)'
        TabOrder = 20
        OnClick = Button1Click
      end
    end
  end
end
