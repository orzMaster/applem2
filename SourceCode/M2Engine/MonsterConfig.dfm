object frmMonsterConfig: TfrmMonsterConfig
  Left = 296
  Top = 429
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Monster Set'
  ClientHeight = 320
  ClientWidth = 624
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
      Caption = 'Basic'
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
          Caption = 'Drops'
          TabOrder = 0
          object Label23: TLabel
            Left = 11
            Top = 24
            Width = 30
            Height = 12
            Caption = 'Gold:'
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
            Caption = 'Gold Drop in Bag'
            TabOrder = 1
            OnClick = CheckBoxDropGoldToPlayBagClick
          end
        end
        object ButtonGeneralSave: TButton
          Left = 504
          Top = 221
          Width = 65
          Height = 25
          Caption = 'Save(&S)'
          TabOrder = 1
          OnClick = ButtonGeneralSaveClick
        end
        object GroupBox2: TGroupBox
          Left = 8
          Top = 95
          Width = 153
          Height = 73
          Caption = 'Show Moster Level'
          TabOrder = 2
          object Label1: TLabel
            Left = 12
            Top = 44
            Width = 42
            Height = 12
            Caption = 'Format:'
          end
          object CheckBoxShowMonLevel: TCheckBox
            Left = 13
            Top = 18
            Width = 124
            Height = 17
            Caption = 'Display Level'
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
      Caption = 'Monster Type'
      ImageIndex = 1
    end
  end
end
