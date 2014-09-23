object FormAdd: TFormAdd
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Import Data'
  ClientHeight = 403
  ClientWidth = 558
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 259
    Height = 49
    Caption = 'Importing Content'
    TabOrder = 0
    object ImageStream: TRadioButton
      Left = 7
      Top = 20
      Width = 59
      Height = 17
      Caption = 'Image'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = ImageStreamClick
    end
    object WavaStream: TRadioButton
      Left = 72
      Top = 20
      Width = 59
      Height = 17
      Caption = 'Audio'
      TabOrder = 1
      OnClick = ImageStreamClick
    end
    object DataStream: TRadioButton
      Left = 137
      Top = 20
      Width = 59
      Height = 17
      Caption = 'Other'
      TabOrder = 2
      OnClick = ImageStreamClick
    end
    object NoneStream: TRadioButton
      Left = 202
      Top = 20
      Width = 45
      Height = 17
      Caption = 'Air'
      TabOrder = 3
      OnClick = ImageStreamClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 350
    Top = 8
    Width = 200
    Height = 376
    Caption = #25991#20214#21015#34920
    TabOrder = 3
    object File_List: TListBox
      Left = 7
      Top = 20
      Width = 186
      Height = 285
      ItemHeight = 13
      MultiSelect = True
      Sorted = True
      TabOrder = 0
    end
    object File_Add: TButton
      Left = 7
      Top = 311
      Width = 58
      Height = 25
      Caption = 'File'
      TabOrder = 2
      OnClick = File_AddClick
    end
    object File_Del: TButton
      Left = 71
      Top = 342
      Width = 58
      Height = 25
      Caption = 'Delete'
      TabOrder = 3
      OnClick = File_DelClick
    end
    object File_Clear: TButton
      Left = 135
      Top = 342
      Width = 58
      Height = 25
      Caption = 'Empty'
      TabOrder = 4
      OnClick = File_ClearClick
    end
    object File_Begin: TButton
      Left = 7
      Top = 342
      Width = 58
      Height = 25
      Caption = 'Execute'
      TabOrder = 1
      OnClick = File_BeginClick
    end
    object File_AddDIR: TButton
      Left = 71
      Top = 311
      Width = 58
      Height = 25
      Caption = 'Directory'
      TabOrder = 5
      OnClick = File_AddDIRClick
    end
    object File_AddDIRALL: TButton
      Left = 135
      Top = 311
      Width = 58
      Height = 25
      Caption = 'List All'
      TabOrder = 6
      OnClick = File_AddDIRALLClick
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 306
    Width = 166
    Height = 78
    Caption = 'Importing Way'
    TabOrder = 1
    object Mode_after: TRadioButton
      Left = 8
      Top = 18
      Width = 123
      Height = 17
      Caption = 'Add From  End'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = ImageStreamClick
    end
    object Mode_Insert: TRadioButton
      Left = 8
      Top = 35
      Width = 155
      Height = 17
      Caption = 'According To Label Insert'
      TabOrder = 1
      OnClick = ImageStreamClick
    end
    object Mode_Bestrow: TRadioButton
      Left = 8
      Top = 52
      Width = 136
      Height = 17
      Caption = 'Coverage by Number'
      TabOrder = 2
      OnClick = ImageStreamClick
    end
  end
  object GroupBox5: TGroupBox
    Left = 180
    Top = 306
    Width = 149
    Height = 78
    Caption = 'Code'
    TabOrder = 2
    object Label3: TLabel
      Left = 8
      Top = 49
      Width = 22
      Height = 13
      Caption = 'End:'
      Enabled = False
    end
    object Label2: TLabel
      Left = 8
      Top = 23
      Width = 25
      Height = 13
      Caption = 'Start:'
      Enabled = False
    end
    object Index_Start: TSpinEdit
      Left = 68
      Top = 18
      Width = 69
      Height = 21
      MaxValue = 10000000
      MinValue = 0
      TabOrder = 0
      Value = 9
      OnChange = ImageStreamClick
    end
    object Index_End: TSpinEdit
      Left = 68
      Top = 45
      Width = 69
      Height = 21
      MaxValue = 10000000
      MinValue = 0
      TabOrder = 1
      Value = 9
    end
  end
  object ProgressBar: TProgressBar
    Left = 0
    Top = 391
    Width = 558
    Height = 12
    Align = alBottom
    TabOrder = 5
    ExplicitWidth = 483
  end
  object NoneOption: TGroupBox
    Left = 8
    Top = 63
    Width = 259
    Height = 237
    Caption = #31354#25968#25454#36873#39033
    TabOrder = 6
    object Label6: TLabel
      Left = 8
      Top = 22
      Width = 27
      Height = 13
      Caption = #25968#37327':'
    end
    object None_Count: TSpinEdit
      Left = 41
      Top = 19
      Width = 62
      Height = 21
      MaxValue = 100000
      MinValue = 1
      TabOrder = 0
      Value = 1
    end
  end
  object WavaOption: TGroupBox
    Left = 8
    Top = 63
    Width = 259
    Height = 237
    Caption = #38899#39057#36873#39033
    TabOrder = 4
    object GroupBox8: TGroupBox
      Left = 10
      Top = 17
      Width = 237
      Height = 51
      Caption = #21387#32553#36873#39033
      TabOrder = 0
      object Label4: TLabel
        Left = 94
        Top = 22
        Width = 73
        Height = 13
        Caption = #21387#32553#31561#32423'(0~9)'
      end
      object Wava_ZIP: TCheckBox
        Left = 10
        Top = 20
        Width = 65
        Height = 17
        Caption = 'ZIP'#21387#32553
        TabOrder = 0
        OnClick = ImageStreamClick
      end
      object Wava_ZIP_Level: TSpinEdit
        Left = 180
        Top = 18
        Width = 43
        Height = 21
        EditorEnabled = False
        MaxValue = 9
        MinValue = 0
        TabOrder = 1
        Value = 0
      end
    end
  end
  object DataOption: TGroupBox
    Left = 8
    Top = 63
    Width = 259
    Height = 237
    Caption = #25968#25454#36873#39033
    TabOrder = 8
    object GroupBox9: TGroupBox
      Left = 10
      Top = 17
      Width = 237
      Height = 51
      Caption = #21387#32553#36873#39033
      TabOrder = 0
      object Label5: TLabel
        Left = 94
        Top = 22
        Width = 73
        Height = 13
        Caption = #21387#32553#31561#32423'(0~9)'
      end
      object Data_ZIP: TCheckBox
        Left = 10
        Top = 20
        Width = 65
        Height = 17
        Caption = 'ZIP'#21387#32553
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = ImageStreamClick
      end
      object Data_ZIP_Level: TSpinEdit
        Left = 180
        Top = 18
        Width = 43
        Height = 21
        EditorEnabled = False
        MaxValue = 9
        MinValue = 0
        TabOrder = 1
        Value = 9
      end
    end
  end
  object ImageOption: TGroupBox
    Left = 8
    Top = 63
    Width = 321
    Height = 237
    Caption = 'Image Options'
    TabOrder = 7
    object GroupBox7: TGroupBox
      Left = 10
      Top = 17
      Width = 295
      Height = 152
      Caption = 'Import Options'
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Top = 71
        Width = 84
        Height = 13
        Caption = 'Transparent Color'
      end
      object Label7: TLabel
        Left = 8
        Top = 97
        Width = 58
        Height = 13
        Caption = 'Mixed Mode'
      end
      object Label8: TLabel
        Left = 8
        Top = 123
        Width = 64
        Height = 13
        Caption = 'Image Format'
      end
      object Image_ImgAndOffset: TRadioButton
        Left = 8
        Top = 20
        Width = 126
        Height = 17
        Caption = 'Pictures + Coordinate'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = ImageStreamClick
      end
      object Image_Img: TRadioButton
        Left = 140
        Top = 20
        Width = 62
        Height = 17
        Caption = 'Picture'
        TabOrder = 1
        OnClick = ImageStreamClick
      end
      object Image_Offset: TRadioButton
        Left = 210
        Top = 20
        Width = 71
        Height = 17
        Caption = 'Coordinate'
        TabOrder = 2
        OnClick = ImageStreamClick
      end
      object Image_Alpha: TCheckBox
        Left = 8
        Top = 43
        Width = 98
        Height = 17
        Caption = 'Alpha Channel'
        TabOrder = 3
        OnClick = ImageStreamClick
      end
      object Image_RLE: TCheckBox
        Left = 112
        Top = 43
        Width = 102
        Height = 17
        Caption = 'RLE Compression'
        Checked = True
        State = cbChecked
        TabOrder = 4
        OnClick = ImageStreamClick
      end
      object Image_Cut: TCheckBox
        Left = 230
        Top = 43
        Width = 61
        Height = 17
        Caption = 'Reverse'
        TabOrder = 5
        OnClick = ImageStreamClick
      end
      object Image_TColor: TRzColorEdit
        Left = 100
        Top = 68
        Width = 73
        Height = 21
        SelectedColor = clBlack
        ShowCustomColor = True
        TabOrder = 6
      end
      object Image_Blend: TComboBox
        Left = 70
        Top = 94
        Width = 120
        Height = 21
        Hint = #28151#21512#27169#24335
        Style = csDropDownList
        Ctl3D = False
        DropDownCount = 10
        ItemHeight = 13
        ParentCtl3D = False
        TabOrder = 7
        OnChange = Image_BlendChange
      end
      object Image_Format: TComboBox
        Left = 80
        Top = 120
        Width = 120
        Height = 21
        Hint = #28151#21512#27169#24335
        Style = csDropDownList
        Ctl3D = False
        DropDownCount = 10
        ItemHeight = 13
        ParentCtl3D = False
        TabOrder = 8
        OnChange = ImageStreamClick
        Items.Strings = (
          '16'#20301#30495#24425#26684#24335'(A4R4G4B4)'
          #20256#32479#20256#22855#26684#24335'(A1R5G5B5)'
          #26080#36879#26126#33394#26684#24335'(R5G6B5)'
          '32'#20301#30495#24425#26684#24335'(A8R8G8B8)')
      end
      object Image_Window: TCheckBox
        Left = 188
        Top = 70
        Width = 61
        Height = 17
        Caption = 'Window'
        TabOrder = 9
        OnClick = ImageStreamClick
      end
      object Image_Format_byFile: TCheckBox
        Left = 220
        Top = 122
        Width = 45
        Height = 17
        Caption = 'File'
        TabOrder = 10
        OnClick = ImageStreamClick
      end
    end
    object GroupBox6: TGroupBox
      Left = 10
      Top = 175
      Width = 295
      Height = 50
      Caption = 'Coordinates of Availability'
      TabOrder = 1
      object Image_Offset_File: TRadioButton
        Left = 8
        Top = 21
        Width = 146
        Height = 17
        Caption = 'Same Name Coordinate'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = ImageStreamClick
      end
      object Image_Offset_App: TRadioButton
        Left = 160
        Top = 21
        Width = 50
        Height = 17
        Caption = 'Fixed'
        TabOrder = 1
        OnClick = ImageStreamClick
      end
      object Image_Offset_AppData: TEdit
        Left = 220
        Top = 19
        Width = 64
        Height = 21
        TabOrder = 2
        Text = '0,0'
      end
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 
      #25152#26377#21487#35835#25991#20214'|*.*|BMP (*.bmp;*.dib)|*.bmp;*.dib|TARGA (*.tga)|*.tga|PNG' +
      ' (*.png)|*.png|WAV (*.wav)|*.wav|MP3 (*.mp3)|*.mp3'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 285
    Top = 34
  end
end
