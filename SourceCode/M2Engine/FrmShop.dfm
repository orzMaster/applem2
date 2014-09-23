object FormShop: TFormShop
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #21830#38138#31649#29702
  ClientHeight = 409
  ClientWidth = 753
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
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
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label5: TLabel
        Left = 321
        Top = 235
        Width = 24
        Height = 12
        Caption = 'Idx:'
      end
      object Label6: TLabel
        Left = 321
        Top = 283
        Width = 30
        Height = 12
        Caption = #25240#25187':'
      end
      object Label4: TLabel
        Left = 160
        Top = 347
        Width = 54
        Height = 12
        Caption = #29289#21697#25551#36848':'
        Visible = False
      end
      object Label2: TLabel
        Left = 160
        Top = 236
        Width = 54
        Height = 12
        Caption = #29289#21697#21517#31216':'
      end
      object Label1: TLabel
        Left = 160
        Top = 259
        Width = 54
        Height = 12
        Caption = #29289#21697#31867#21035':'
      end
      object Label7: TLabel
        Left = 160
        Top = 307
        Width = 54
        Height = 12
        Caption = #38480#37327#38144#21806':'
      end
      object Label3: TLabel
        Left = 321
        Top = 259
        Width = 30
        Height = 12
        Caption = #26399#38480':'
      end
      object Label8: TLabel
        Left = 160
        Top = 282
        Width = 54
        Height = 12
        Caption = #29289#21697#20215#26684':'
      end
      object Label10: TLabel
        Left = 321
        Top = 307
        Width = 30
        Height = 12
        Caption = #24050#21806':'
      end
      object Label9: TLabel
        Left = 412
        Top = 235
        Width = 54
        Height = 12
        Hint = #35774#32622#24403#21069#29289#21697#26159#21542#20801#35768#20351#29992#37329#24065#36141#20080#65292#20026'0'#21017#19981#20801#35768
        Caption = #37329#24065#20215#26684':'
      end
      object ButtonAdd: TButton
        Left = 216
        Top = 330
        Width = 75
        Height = 23
        Caption = #22686#21152'(&A)'
        Enabled = False
        TabOrder = 0
        OnClick = ButtonAddClick
      end
      object ButtonDel: TButton
        Left = 297
        Top = 330
        Width = 75
        Height = 23
        Caption = #21024#38500'(&D)'
        Enabled = False
        TabOrder = 1
        OnClick = ButtonDelClick
      end
      object ButtonEdit: TButton
        Left = 378
        Top = 330
        Width = 75
        Height = 23
        Caption = #20462#25913'(&E)'
        Enabled = False
        TabOrder = 2
        OnClick = ButtonEditClick
      end
      object ButtonSave: TButton
        Left = 459
        Top = 330
        Width = 75
        Height = 23
        Caption = #20445#23384'(&S)'
        TabOrder = 3
        OnClick = ButtonSaveClick
      end
      object ButtonRefur: TButton
        Left = 540
        Top = 330
        Width = 75
        Height = 23
        Caption = #37325#21152#36733'(&R)'
        TabOrder = 4
        OnClick = ButtonRefurClick
      end
      object SpinEditItems: TSpinEdit
        Left = 357
        Top = 232
        Width = 52
        Height = 21
        Color = clSilver
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        MaxValue = 0
        MinValue = 0
        ParentFont = False
        ReadOnly = True
        TabOrder = 5
        Value = 100
      end
      object EditName: TEdit
        Left = 216
        Top = 233
        Width = 99
        Height = 20
        Color = clSilver
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 6
      end
      object EditText: TEdit
        Left = 216
        Top = 343
        Width = 501
        Height = 20
        MaxLength = 127
        TabOrder = 7
        Visible = False
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 19
        Width = 146
        Height = 334
        Caption = #29289#21697#21015#34920'(Ctrl+F'#26597#25214')'
        TabOrder = 8
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
        Left = 550
        Top = 235
        Width = 65
        Height = 17
        Caption = #19981#21487#20132#26131
        TabOrder = 9
      end
      object CheckBox2: TCheckBox
        Tag = 1
        Left = 629
        Top = 236
        Width = 65
        Height = 17
        Caption = #19981#21487#23384#20179
        TabOrder = 10
      end
      object CheckBox3: TCheckBox
        Tag = 2
        Left = 550
        Top = 251
        Width = 65
        Height = 17
        Caption = #19981#21487#20462#29702
        TabOrder = 11
      end
      object CheckBox4: TCheckBox
        Tag = 3
        Left = 629
        Top = 251
        Width = 65
        Height = 17
        Caption = #19981#21487#20002#24323
        TabOrder = 12
      end
      object CheckBox5: TCheckBox
        Tag = 4
        Left = 550
        Top = 267
        Width = 65
        Height = 17
        Caption = #27704#19981#25481#33853
        TabOrder = 13
      end
      object CheckBox6: TCheckBox
        Tag = 5
        Left = 629
        Top = 267
        Width = 65
        Height = 17
        Caption = #19981#21487#25171#36896
        TabOrder = 14
      end
      object ButtonOutHint: TButton
        Left = 494
        Top = 340
        Width = 96
        Height = 23
        Caption = #29983#25104#35828#26126'(&W)'
        TabOrder = 15
        Visible = False
        OnClick = ButtonOutHintClick
      end
      object ComboBoxAgio: TComboBox
        Left = 357
        Top = 280
        Width = 52
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        ItemIndex = 0
        TabOrder = 16
        Text = '10.0'
        Items.Strings = (
          '10.0'
          '9.5'
          '9'
          '8.5'
          '8'
          '7.5'
          '7'
          '6.5'
          '6'
          '5.5'
          '5'
          '4.5'
          '4'
          '3.5'
          '3'
          '2.5'
          '2'
          '1.5'
          '1'
          '0.5')
      end
      object CheckBox7: TCheckBox
        Tag = 6
        Left = 550
        Top = 281
        Width = 65
        Height = 17
        Caption = #19981#21487#20986#21806
        TabOrder = 17
      end
      object CheckBox8: TCheckBox
        Tag = 7
        Left = 629
        Top = 281
        Width = 65
        Height = 17
        Caption = #20002#24323#28040#22833
        TabOrder = 18
      end
      object ComboBoxClass: TComboBox
        Left = 216
        Top = 256
        Width = 99
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        ItemIndex = 0
        TabOrder = 19
        Text = #28216#25103#34917#32473
        Items.Strings = (
          #28216#25103#34917#32473
          #24378#21270#35013#22791
          #22909#21451#35013#39280
          #20854#23427#36947#20855)
      end
      object SpinEditCount: TSpinEdit
        Left = 216
        Top = 304
        Width = 49
        Height = 21
        MaxValue = 30000
        MinValue = -1
        TabOrder = 20
        Value = -1
      end
      object SpinEditTime: TSpinEdit
        Left = 357
        Top = 256
        Width = 52
        Height = 21
        MaxValue = 0
        MinValue = 0
        TabOrder = 21
        Value = 0
      end
      object SpinEditPrice: TSpinEdit
        Left = 216
        Top = 279
        Width = 99
        Height = 21
        MaxValue = 0
        MinValue = 0
        TabOrder = 22
        Value = 0
        OnChange = SpinEditPriceChange
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
            Caption = #24050#21806
            Width = 40
          end
          item
            Caption = 'ID'
            Width = 36
          end
          item
            Caption = #20215#26684
          end
          item
            Caption = #26399#38480
            Width = 36
          end
          item
            Caption = #25240#25187
            Width = 36
          end
          item
            Caption = #25968#37327
            Width = 36
          end
          item
            Caption = #20132
            Width = 24
          end
          item
            Caption = #23384
            Width = 24
          end
          item
            Caption = #20462
            Width = 24
          end
          item
            Caption = #20002
            Width = 24
          end
          item
            Caption = #32465
            Width = 24
          end
          item
            Caption = #36896
            Width = 24
          end
          item
            Caption = #21806
            Width = 24
          end
          item
            Caption = #28040
            Width = 24
          end
          item
            Caption = #37329#24065#20215#26684
            Width = 60
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 23
        ViewStyle = vsReport
        OnChange = ListViewShopListChange
        OnColumnClick = ListViewShopListColumnClick
        OnCompare = ListViewShopListCompare
      end
      object SpinEditSellCount: TSpinEdit
        Left = 357
        Top = 304
        Width = 52
        Height = 21
        MaxValue = 65535
        MinValue = 0
        TabOrder = 24
        Value = 0
      end
      object ComboBoxSupplyType: TComboBox
        Left = 415
        Top = 304
        Width = 152
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        ItemIndex = 0
        TabOrder = 25
        Text = #25163#21160#19978#26550
        Items.Strings = (
          #25163#21160#19978#26550
          #21334#23436#33258#21160#19978#26550
          #25351#23450#26102#38388#19978#26550
          #25351#23450#26102#38388#21334#23436#19978#26550)
      end
      object SpinEditSupplyCount: TSpinEdit
        Left = 267
        Top = 304
        Width = 48
        Height = 21
        Hint = #33258#21160#19978#26550#25968#37327#35774#23450
        MaxValue = 30000
        MinValue = -1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 26
        Value = -1
      end
      object ComboBoxSupplyTime: TComboBox
        Left = 573
        Top = 304
        Width = 65
        Height = 20
        Style = csDropDownList
        ItemHeight = 12
        ItemIndex = 0
        TabOrder = 27
        Text = #26143#26399#19968
        Items.Strings = (
          #26143#26399#19968
          #26143#26399#20108
          #26143#26399#19977
          #26143#26399#22235
          #26143#26399#20116
          #26143#26399#20845
          #26143#26399#26085)
      end
      object Button1: TButton
        Left = 621
        Top = 330
        Width = 92
        Height = 23
        Caption = #28165#31354#38144#21806'(&R)'
        TabOrder = 28
        OnClick = Button1Click
      end
      object EditGold: TSpinEdit
        Left = 468
        Top = 232
        Width = 66
        Height = 21
        Hint = #35774#32622#24403#21069#29289#21697#26159#21542#20801#35768#20351#29992#37329#24065#36141#20080#65292#20026'0'#21017#19981#20801#35768
        MaxValue = 0
        MinValue = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 29
        Value = 0
        OnChange = SpinEditPriceChange
      end
    end
  end
end
