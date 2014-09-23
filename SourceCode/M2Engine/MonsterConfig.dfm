object frmMonsterConfig: TfrmMonsterConfig
  Left = 296
  Top = 429
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #24618#29289#35774#32622
  ClientHeight = 320
  ClientWidth = 616
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 601
    Height = 297
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #22522#26412#21442#25968
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 577
        Height = 257
        TabOrder = 0
        object GroupBox8: TGroupBox
          Left = 8
          Top = 16
          Width = 153
          Height = 73
          Caption = #29190#29289#21697#35774#32622
          TabOrder = 0
          object Label23: TLabel
            Left = 11
            Top = 24
            Width = 42
            Height = 12
            Caption = #37329#24065#22534':'
          end
          object EditMonOneDropGoldCount: TSpinEdit
            Left = 60
            Top = 20
            Width = 77
            Height = 21
            MaxValue = 99999999
            MinValue = 1
            TabOrder = 0
            Value = 10
            OnChange = EditMonOneDropGoldCountChange
          end
          object CheckBoxDropGoldToPlayBag: TCheckBox
            Left = 8
            Top = 48
            Width = 137
            Height = 17
            Caption = #37329#24065#30452#25509#20837#32972#21253
            TabOrder = 1
            OnClick = CheckBoxDropGoldToPlayBagClick
          end
        end
        object ButtonGeneralSave: TButton
          Left = 504
          Top = 221
          Width = 65
          Height = 25
          Caption = #20445#23384'(&S)'
          TabOrder = 1
          OnClick = ButtonGeneralSaveClick
        end
        object GroupBox2: TGroupBox
          Left = 8
          Top = 95
          Width = 153
          Height = 73
          Caption = #26174#31034#24618#29289#31561#32423
          TabOrder = 2
          object Label1: TLabel
            Left = 12
            Top = 44
            Width = 30
            Height = 12
            Caption = #26684#24335':'
          end
          object CheckBoxShowMonLevel: TCheckBox
            Left = 13
            Top = 18
            Width = 124
            Height = 17
            Caption = #26159#21542#21551#29992#26174#31034#31561#32423
            TabOrder = 0
            OnClick = CheckBoxShowMonLevelClick
          end
          object EditShowMonLevelFormat: TEdit
            Left = 60
            Top = 41
            Width = 78
            Height = 20
            TabOrder = 1
            Text = '(Lv:%d)\%s'
            OnChange = EditShowMonLevelFormatChange
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #24618#29289#31867#22411
      ImageIndex = 1
    end
  end
end
