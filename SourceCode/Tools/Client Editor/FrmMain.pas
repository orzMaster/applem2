unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms, TDX9Textures, MyDXBase,
  MyDirect3D9, GraphicEx, ShellAPI,
  Dialogs, Menus, ToolWin, ComCtrls, ExtCtrls, Grids, ImgList, StdCtrls, ZShare, WIL, TDX9Devices, TeCanvas, ExtDlgs;

type
  TFormMain = class(TForm)
    MainMainMenu: TMainMenu;
    MEMU_FILE: TMenuItem;
    MEMU_FILE_OPEN: TMenuItem;
    MEMU_FILE_NEW: TMenuItem;
    MEMU_FILE_CLOSE: TMenuItem;
    N2: TMenuItem;
    MEMU_FILE_AGOFILE: TMenuItem;
    MEMU_FILE_AGOFILE_PATHS: TMenuItem;
    N1: TMenuItem;
    MEMU_FILE_EXIT: TMenuItem;
    StatusBar: TStatusBar;
    Splitter1: TSplitter;
    DrawGrid: TDrawGrid;
    StandardToolBar: TToolBar;
    Tool_New: TToolButton;
    OpenButton: TToolButton;
    CloseButton: TToolButton;
    ToolbarImages: TImageList;
    Tool_Image_Add: TToolButton;
    Tool_Image_Put: TToolButton;
    Tool_Image_Del: TToolButton;
    ToolButton2: TToolButton;
    Tool_AUTOIMAGE: TToolButton;
    ToolButton8: TToolButton;
    Tool_Front: TToolButton;
    Tool_Next: TToolButton;
    ToolButton13: TToolButton;
    MEMU_WORK_: TMenuItem;
    MENU_VIER_: TMenuItem;
    MENU_OPTION: TMenuItem;
    MENU_HELP: TMenuItem;
    MENU_HELP_ABOUT: TMenuItem;
    MENU_VIER_TOOLBAR: TMenuItem;
    MENU_VIER_STATUSBAR: TMenuItem;
    MENU_OPTION_BACKCOLOR: TMenuItem;
    MENU_OPTION_BLENDCOLOR: TMenuItem;
    MEMU_WORK_AUTOIMAGE: TMenuItem;
    N6: TMenuItem;
    MEMU_WORK_ADDIMAGE: TMenuItem;
    MEMU_WORK_DELIMAGE: TMenuItem;
    MEMU_WORK_PUTIMAGE: TMenuItem;
    M1: TMenuItem;
    MEMU_FILE_OPEN_MIR2_OLD: TMenuItem;
    MEMU_FILE_OPEN_MIR2_16: TMenuItem;
    MEMU_FILE_OPEN_MIR2_WIS: TMenuItem;
    MEMU_FILE_OPEN_DIY: TMenuItem;
    MEMU_FILE_OPEN_MIR3: TMenuItem;
    MEMU_FILE_OPEN_WOOOL: TMenuItem;
    Tool_Image_Goto: TToolButton;
    ToolButton16: TToolButton;
    Panel2: TPanel;
    Tool_BlendMode: TComboBox;
    Tool_Zoom: TComboBox;
    Tool_Alpha: TTrackBar;
    OpenDialog: TOpenDialog;
    MyDevice: TDX9Device;
    Timer: TTimer;
    Tool_BlendColor: TButtonColor;
    Tool_BackColor: TButtonColor;
    SaveDialog: TSaveDialog;
    MEMU_WORK_NEXT: TMenuItem;
    MEMU_WORK_IMAGE_GOTO: TMenuItem;
    N5: TMenuItem;
    MEMU_WORK_FRONT: TMenuItem;
    N4: TMenuItem;
    MENU_OPTION_BACKIMAGE: TMenuItem;
    OpenPictureDialog: TOpenPictureDialog;
    Tool_Middle: TToolButton;
    ToolButton3: TToolButton;
    Tool_BackImage: TToolButton;
    Tool_Position: TToolButton;
    ToolButton4: TToolButton;
    Tool_Random: TToolButton;
    Tool_SrcBlend: TComboBox;
    Tool_DestBlend: TComboBox;
    Panel1: TPanel;
    ScrollBox: TScrollBox;
    PanelDraw: TPanel;
    PanelMusic: TPanel;
    PaintBox1: TPaintBox;
    ScrollBar1: TScrollBar;
    bt_Music_Pause: TButton;
    bt_Music_Play: TButton;
    bt_Music_Stop: TButton;
    TimerMusic: TTimer;
    N7: TMenuItem;
    S1: TMenuItem;
    MEMU_FILE_OPEN_WY: TMenuItem;
    MENU_OPTION_LEVEL: TMenuItem;
    MENU_OPTION_UPRIGHTNESS: TMenuItem;
    MEMU_FILE_OPEN_MIR2_ZIP: TMenuItem;
    N3M1: TMenuItem;
    MEMU_FILE_OPEN_MIR3Zip: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure MEMU_FILE_OPEN_MIR2_OLDClick(Sender: TObject);
    procedure MEMU_FILE_CLOSEClick(Sender: TObject);
    procedure Tool_BackColorClick(Sender: TObject);
    procedure Tool_BlendColorClick(Sender: TObject);
    procedure MENU_VIER_TOOLBARClick(Sender: TObject);
    procedure MENU_VIER_STATUSBARClick(Sender: TObject);
    procedure MyDeviceFinalize(Sender: TObject);
    procedure MyDeviceNotifyEvent(Sender: TObject; Msg: Cardinal);
    procedure MyDeviceRender(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure DrawGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure MEMU_FILE_OPEN_MIR2_16Click(Sender: TObject);
    procedure MEMU_FILE_OPEN_MIR2_WISClick(Sender: TObject);
    procedure MEMU_FILE_OPEN_MIR3Click(Sender: TObject);
    procedure MEMU_FILE_OPEN_WOOOLClick(Sender: TObject);
    procedure MEMU_FILE_OPEN_DIYClick(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure MEMU_FILE_EXITClick(Sender: TObject);
    procedure Tool_Image_GotoClick(Sender: TObject);
    procedure Tool_NextClick(Sender: TObject);
    procedure MENU_OPTION_BLENDCOLORClick(Sender: TObject);
    procedure Tool_NewClick(Sender: TObject);
    procedure MEMU_WORK_AUTOIMAGEClick(Sender: TObject);
    procedure MEMU_WORK_ADDIMAGEClick(Sender: TObject);
    procedure MEMU_WORK_PUTIMAGEClick(Sender: TObject);
    procedure MEMU_WORK_DELIMAGEClick(Sender: TObject);
    procedure Tool_BlendModeChange(Sender: TObject);
    procedure MENU_OPTION_BACKIMAGEClick(Sender: TObject);
    procedure Tool_AlphaChange(Sender: TObject);
    procedure Tool_ZoomChange(Sender: TObject);
    procedure PanelDrawMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PanelDrawMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PanelDrawMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MENU_HELP_ABOUTClick(Sender: TObject);
    procedure Tool_DestBlendChange(Sender: TObject);
    procedure MENU_TOOL_ALPHACHANGEClick(Sender: TObject);
    procedure MyDeviceInitialize(Sender: TObject; var Success: Boolean; var ErrorMsg: string);
    procedure PaintBox1Paint(Sender: TObject);
    procedure TimerMusicTimer(Sender: TObject);
    procedure bt_Music_PlayClick(Sender: TObject);
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure bt_Music_StopClick(Sender: TObject);
    procedure bt_Music_PauseClick(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure MEMU_FILE_OPEN_WYClick(Sender: TObject);
    procedure MENU_OPTION_LEVELClick(Sender: TObject);
    procedure MENU_OPTION_UPRIGHTNESSClick(Sender: TObject);
    procedure MEMU_FILE_AGOFILE_PATHSClick(Sender: TObject);
    procedure MEMU_FILE_OPEN_MIR2_ZIPClick(Sender: TObject);
    procedure MEMU_FILE_OPEN_MIR3ZipClick(Sender: TObject);
  private
    FAutoTick: LongWord;
    FBlend: Cardinal;
    FImageX: Integer;
    FImageY: Integer;
    FShowX: Integer;
    FShowY: Integer;
    FZoomSize: Extended;
    FSpotX: Integer;
    FSpotY: Integer;
    FDown: Boolean;
    FRenderSurface: TDXRenderTargetTexture;
    FSaveDir: string;
    FLastIndex: Integer;
    FRight, FBottom: Integer;
    { Private declarations }
    procedure ReadOpenFileList();
    procedure WriteOpenFileList();
    procedure AddOpenFileList(sFileName: string);
  public
    procedure Initializeg_WMImages(WILType: TWILType);
    procedure InitializeForm();
    procedure InitializeGrid();
    procedure RefStatusBar();
    procedure OpenWMFile(sFileName: string; WILType: TWILType);
    function SetDrawGridIndex(Index: Integer): Boolean;
    procedure DrawRender(Sender: TObject);
    procedure SaveRenderToBmp(sFileName: string);
  end;

var
  FormMain: TFormMain;
  time: Double; {乐曲总时间}

implementation

uses
  wmM2Def, wmM2Wis, wmMyImage, wmM2Zip, wmM3Zip, Hutil32, wmM3Def, wmWoool, FrmAdd, FrmDel, FrmOut, FrmAlpha, Bass, Registry, MyCommon;

{$R *.dfm}
{$R ColorTable.RES}
{$R FileBmp.res}

const
  MAXWIDTH = 800;
  MAXHEIGHT = 600;
  WINLEFT = 60;
  WINTOP = 60;
  WINRIGHT = MAXWIDTH - 60;
  BOTTOMEDGE = MAXHEIGHT - 60;

var
  BltBitmap: TBitmap;
  hs: HSTREAM;  {流句柄}
  FFTData: array[0..2048] of Single;
  FFTPeacks  : array [0..2048] of Integer;
  FFTFallOff : array [0..2048] of Integer;
  DataStream: TMemoryStream;
  boStop: Boolean;


procedure TFormMain.bt_Music_PauseClick(Sender: TObject);
begin
  boStop := False;
  TimerMusic.Enabled := False;
  BASS_ChannelPause(hs);
  bt_Music_Play.Enabled := True;
  bt_Music_Pause.Enabled := False;
  bt_Music_Stop.Enabled := True;
end;

procedure TFormMain.bt_Music_PlayClick(Sender: TObject);
begin
  TimerMusic.Enabled := True;
  BASS_ChannelPlay(hs, boStop);
  time := BASS_ChannelBytes2Seconds(hs, BASS_ChannelGetLength(hs, BASS_POS_BYTE)); {总秒数}
  ScrollBar1.Max := Trunc(time * 1000);
  ScrollBar1.Enabled := True;
  bt_Music_Play.Enabled := False;
  bt_Music_Pause.Enabled := True;
  bt_Music_Stop.Enabled := True;
end;

procedure TFormMain.bt_Music_StopClick(Sender: TObject);
begin
  boStop := True;
  TimerMusic.Enabled := False;
  BASS_ChannelStop(hs);
  bt_Music_Play.Enabled := True;
  bt_Music_Pause.Enabled := False;
  bt_Music_Stop.Enabled := False;
  ScrollBar1.Enabled := False;
end;

procedure TFormMain.DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  OldColor: TColor;
  BitMap, BitMap2: TBitmap;
  nRect, iRect: TRect;
  X, Y: Integer;
  Str: string;
  boStr: Boolean;
  btType: Byte;
begin
  if (g_WMImages <> nil) and g_WMImages.boInitialize then begin
    OldColor := 0;
    with DrawGrid.Canvas do begin
      if gdSelected in State then begin
        DrawGrid.Canvas.Brush.Color := clMenuHighlight;
        FillRect(Rect);
      end;
      BitMap2 := TBitmap.Create;
      BitMap := g_WMImages.Bitmap[ACol + ARow * 6, btType];
      case btType of
        FILETYPE_IMAGE: ;
        FILETYPE_DATA: begin
            if Bitmap = nil then
              BitMap := TBitmap.Create;
            Bitmap.Assign(g_DefDatImage);
          end;
        FILETYPE_WAVA: begin
            if Bitmap = nil then
              BitMap := TBitmap.Create;
            Bitmap.Assign(g_DefWavImage);
          end;
        FILETYPE_MP3: begin
            if Bitmap = nil then
              BitMap := TBitmap.Create;
            Bitmap.Assign(g_DefMp3Image);
          end;
      else begin
          if Bitmap <> nil then
            FreeAndNil(Bitmap);
        end;
      end;
      boStr := False;
      if (BitMap <> nil) then begin
        if Bitmap.PixelFormat = pf8bit then
          SetDIBColorTable(Bitmap.Canvas.Handle, 0, 256, g_DefMainPalette);
        BitMap2.Width := _MIN(BitMap.Width, DrawGrid.DefaultColWidth);
        BitMap2.Height := _MIN(BitMap.Height, DrawGrid.DefaultRowHeight);
        if BitMap2.Height > (DrawGrid.DefaultRowHeight - 12) then
          boStr := True;
        BitMap2.Canvas.StretchDraw(BitMap2.Canvas.ClipRect, BitMap);
        BitMap2.TransparentColor := 0;
        BitMap2.Transparent := True;
        nRect.Left := 0;
        nRect.Top := 0;
        nRect.Right := Bitmap2.Width;
        nRect.Bottom := Bitmap2.Height;
        iRect := Rect;
        iRect.Right := iRect.Left + _MIN(BitMap2.Width, DrawGrid.DefaultColWidth);
        iRect.Bottom := iRect.Top + _MIN(BitMap2.Height, DrawGrid.DefaultRowHeight);
        DrawGrid.Canvas.BrushCopy(iRect, Bitmap2, nRect, 0);
        BitMap.Free;
      end;

      Bitmap2.Free;
      if (ACol + ARow * 6) <= (g_WMImages.ImageCount - 1) then begin
        SetBkMode(Handle, TRANSPARENT);
        Str := Format('%.6d', [ACol + ARow * 6]);
        X := Rect.Right - DrawGrid.Canvas.TextWidth(Str);
        Y := Rect.Bottom - DrawGrid.Canvas.TextHeight(Str);
        if boStr then begin
          Font.Color := clBlack;
          DrawGrid.Canvas.TextOut(X - 1, Y, Str);
          DrawGrid.Canvas.TextOut(X + 1, Y, Str);
          DrawGrid.Canvas.TextOut(X, Y - 1, Str);
          DrawGrid.Canvas.TextOut(X, Y + 1, Str);
        end;
        if boStr then
          Font.Color := clWhite
        else
          Font.Color := clBlack;
        DrawGrid.Canvas.TextOut(X, Y, Str);
        if gdSelected in State then begin
          Font.Color := OldColor;
        end;
      end;
    end;
  end;
end;

procedure TFormMain.DrawGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
{var
  Access: TDXAccessInfo;
  WriteBuffer, ReadBuffer: PWord;
  X, Y: Integer;
  P32RGB: PRGBQuad;
  RGBQuad: TRGBQuad;
  Color: LongWord;    }
//var
  //TempDataStream: TMemoryStream;
begin
  bt_Music_StopClick(nil);
  BASS_StreamFree(hs);
  if DataStream <> nil then begin
    DataStream.Free;
    DataStream := nil;
  end;
  if (g_WMImages <> nil) and g_WMImages.boInitialize then begin
    g_SelectImageIndex := ACol + ARow * 6;
    FillChar(g_TextureInfo, SizeOf(g_TextureInfo), #0);
    g_WILColorFormat := -1;
    g_Texture[1].Clear;
    case g_WMImages.GetDataType(g_SelectImageIndex) of
      FILETYPE_IMAGE: begin
          PanelMusic.Visible := False;
          if g_WMImages.CopyDataToTexture(g_SelectImageIndex, g_Texture[1]) then begin
            FImageX := g_WMImages.LastImageInfo.px;
            FImageY := g_WMImages.LastImageInfo.py;
            g_TextureInfo := g_WMImages.LastImageInfo;
            if g_WMImages is TWMMyImageImages then
              g_WILColorFormat := Integer(g_WMImages.LastColorFormat);
            //测试
            (*if g_Texture[1].Lock(lfNormal, Access) then begin
              try
                Color := (DisplaceRB(g_BackColor));
                P32RGB := PRGBQuad(@Color);
                for Y := 0 to g_Texture[1].PatternSize.Y - 1 do begin
                  ReadBuffer  := PWord(Integer(Access.Bits) + (Access.Pitch * Y));
                  WriteBuffer := PWord(Integer(Access.Bits) + (Access.Pitch * Y) + g_Texture[1].PatternSize.X * 2);
                  for X := 0 to g_Texture[1].PatternSize.X - 1 do begin
                    if ReadBuffer^ > 0 then begin
                      RGBQuad.rgbRed := ReadBuffer^ and $F00 shr 4;
                      RGBQuad.rgbGreen := ReadBuffer^ and $F0;
                      RGBQuad.rgbBlue := ReadBuffer^ and $F shl 4;
                      RGBQuad.rgbRed := _MIN(Round(RGBQuad.rgbRed * 1.5), 255);
                      RGBQuad.rgbGreen := _MIN(Round(RGBQuad.rgbGreen * 1.5), 255);
                      RGBQuad.rgbBlue := _MIN(Round(RGBQuad.rgbBlue * 1.5), 255);
                      {RGBQuad.rgbRed := _MIN(255, Round(RGBQuad.rgbRed + (255 - RGBQuad.rgbRed) / 255 * P32RGB.rgbRed));
                      RGBQuad.rgbGreen := _MIN(255, Round(RGBQuad.rgbGreen + (255 - RGBQuad.rgbGreen) / 255 * P32RGB.rgbGreen));
                      RGBQuad.rgbBlue := _MIN(255, Round(RGBQuad.rgbBlue + (255 - RGBQuad.rgbBlue) / 255 * P32RGB.rgbBlue));}
                      WriteBuffer^ := ($F0 shl 8) + ((WORD(RGBQuad.rgbRed) and $F0) shl 4) +
                        (WORD(RGBQuad.rgbGreen) and $F0) + (WORD(RGBQuad.rgbBlue) shr 4);
                    end else
                      //WriteBuffer^ := ((WORD(P32RGB.rgbRed) and $F8) shl 8) + ((WORD(P32RGB.rgbGreen) and $FC)
                        //shl 3) + ((WORD(P32RGB.rgbBlue)) shr 3);
                      WriteBuffer^ := ((WORD(P32RGB.rgbRed) and $F0) shl 4) +
                        (WORD(P32RGB.rgbGreen) and $F0) + (WORD(P32RGB.rgbBlue) shr 4);
                    Inc(ReadBuffer);
                    Inc(WriteBuffer);
                  end;
                  //LineR5G6B5_A4R4G4B4(ReadBuffer, WriteBuffer, Width);
                end;
                g_Texture[1].PatternSize := Point(g_Texture[1].PatternSize.X * 2, g_Texture[1].PatternSize.Y * 2);
              finally
                g_Texture[1].Unlock;
              end;
            end;
                  *)
            //测试
          end;
        end;
      FILETYPE_WAVA,
        FILETYPE_MP3: begin
          PanelMusic.Visible := True;
          DataStream := g_WMImages.GetDataStream(g_SelectImageIndex, dtAll);
          if DataStream <> nil then begin
            hs := BASS_StreamCreateFile(True, DataStream.Memory, 0, DataStream.Size, 0);
          end;
        end;
      FILETYPE_DATA: begin
          PanelMusic.Visible := False;
        end;
    end;
    RefStatusBar();
  end;
end;

procedure TFormMain.DrawRender(Sender: TObject);
var
  Color4: TColor4;
  Rect: TRect;
  //nX, nY: Integer;
//  nZoom: Real;
begin
  Color4 := cColor4(Tool_Alpha.Position and $FF shl 24 or (g_AlphaColor and $FFFFFF));
  MyDevice.Canvas.Draw(0, 0, g_Texture[0].ClientRect, g_Texture[0], fxNone);
  Rect := g_Texture[1].ClientRect;
  Rect.Right := Round(Rect.Right * FZoomSize);
  Rect.Bottom := Round(Rect.Bottom * FZoomSize);

 { nZoom := 0.15;
  FZoomSize := 2;
  Rect.Right := Round(Rect.Right * 0.9);
  Rect.Bottom := Round(Rect.Bottom * 0.9);  }
  //nX := 0;
  //nY := 0;
  if Tool_Middle.Down then begin
    if Tool_Position.Down then begin
      Rect.Left := MAXWIDTH div 3 + FImageX;
      Rect.Top := MAXHEIGHT div 3 + FImageY;
    end
    else begin
      Rect.Left := (MAXWIDTH - Rect.Right) div 2;
      Rect.Top := (MAXHEIGHT - Rect.Bottom) div 2;
    end;
  end
  else if Tool_Random.Down then begin
    if Tool_Position.Down then begin
      Rect.Left := FImageX + FShowX;
      Rect.Top := FImageY + FShowY;
    end
    else begin
      Rect.Left := FShowX;
      Rect.Top := FShowY;
    end;
  end;
  Rect.Right := Rect.Right + Rect.Left;
  Rect.Bottom := Rect.Bottom + Rect.Top;
  FRight := Rect.Right - Rect.Left;
  FBottom := Rect.Bottom - Rect.Top;
  if FZoomSize <> 1 then
    MyDevice.Canvas.StretchDraw(Rect, g_Texture[1].ClientRect, g_Texture[1], FBlend, Color4,
      MENU_OPTION_LEVEL.Checked, MENU_OPTION_UPRIGHTNESS.Checked)
  else
    MyDevice.Canvas.Draw(Rect.Left, Rect.Top, g_Texture[1].ClientRect, g_Texture[1], FBlend, Color4,
      MENU_OPTION_LEVEL.Checked, MENU_OPTION_UPRIGHTNESS.Checked);

  {FImageX: Integer;
    FImageY: Integer;
    FShowX: Integer;
    FShowY: Integer;
    FZoomSize: Extended;}
  //MyDevice.Canvas.Draw(0, 0, g_Texture[1].ClientRect, g_Texture[1], FBlend, Color4);
  {MyDevice.Canvas.Draw(0, 0, Rect(0, 0, g_Texture[1].PatternSize.X div 2, g_Texture[1].PatternSize.Y),
    g_Texture[1], FBlend, Color4);      }
  {MyDevice.Canvas.Draw(g_Texture[1].PatternSize.X div 2, 0,
    Rect(g_Texture[1].PatternSize.X div 2, 0,
    g_Texture[1].PatternSize.X, g_Texture[1].PatternSize.Y),
    g_Texture[1], fxNone, clWhite4);  }
end;

procedure TFormMain.Tool_DestBlendChange(Sender: TObject);
begin
  FBlend := (Tool_SrcBlend.ItemIndex and $FF) or (Tool_DestBlend.ItemIndex and $FF shl 8);
  //FBlend := StrToIntDef(Tool_BlendMode_Custom.Text, $00000001);
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  Res: TResourceStream;
  {i: integer;
  tempstr: tstringlist;
  addstr: string;
  sword: word;
  db, dg, dr: Byte;  }
begin
  Randomize;
  GetFileVersion(ParamStr(0), @g_FileVersionInfo);
  MAINFORMCAPTION := MAINFORMCAPTION + g_FileVersionInfo.sVersion;
  ReadOpenFileList;
  g_DefDatImage := TBitmap.Create;
  g_DefWavImage := TBitmap.Create;
  g_DefMp3Image := TBitmap.Create;
  BltBitmap := TBitmap.Create;
  //DataStream := TMemoryStream.Create;
  FImageX := 0;
  FImageY := 0;
  FShowX := 0;
  FShowY := 0;
  FRight := 0;
  FBottom := 0;
  FZoomSize := 1;
  FLastIndex := -1;
  FDown := False;
  PanelDraw.Width := MAXWIDTH;
  PanelDraw.Height := MAXHEIGHT;
  PanelDraw.Left := 0;
  PanelDraw.Top := 0;
  FSaveDir := '';
  Res := TResourceStream.Create(Hinstance, '256RGB', 'RGB');
  try
    Res.Read(g_DefMainPalette, SizeOf(g_DefMainPalette));
  finally
    Res.Free;
  end;
  g_DefDatImage.LoadFromResourceName(Hinstance, 'DATFILE');
  g_DefWavImage.LoadFromResourceName(Hinstance, 'WAVFILE');
  g_DefMp3Image.LoadFromResourceName(Hinstance, 'MP3FILE');
  OpenButton.Enabled := False;
 { tempstr := Tstringlist.create;
  tempstr.add('Const');
  tempstr.add('  Alpha16: array[Word] of Word = (');
  for I := Low(Byte) to High(Byte) do begin
    if i = 0 then begin
      addstr := '  $0000, ';
      //tempstr.Add('$0000, ');
    end else begin
      if (i mod 16) = 0 then begin
        tempstr.Add(addstr);
        addstr := '  ';
      end;
      sword := i;
      dB := g_DefMainPalette[I].rgbBlue;
      dG := g_DefMainPalette[I].rgbGreen;
      dR := g_DefMainPalette[I].rgbRed;
      sword := $8000 +
              ((WORD(dr) and $F8) shl 7) +
              (WORD(dg) and $F8 shl 2) +
              (WORD(db) shr 3);
      addstr := addstr + '$' + IntToHex(sword, 4) + ', ';

    end;
  end;
  tempstr.add(addstr);
  tempstr.add('  ); ');
  tempstr.SaveToFile('d:\alpha8.txt');
  tempstr.free;    }
 (* tempstr := Tstringlist.create;
  tempstr.add('Const');
  tempstr.add('  Alpha16: array[Word] of Word = (');
  for I := Low(Word) to High(Word) do begin
    if i = 0 then begin
      addstr := '  $0000, ';
      //tempstr.Add('$0000, ');
    end else begin
      if (i mod 16) = 0 then begin
        tempstr.Add(addstr);
        addstr := '  ';
      end;
      sword := i;
      dB := BYTE((sword and $1F) shl 3);
      dG := BYTE((sword and $7E0) shr 3);
      dR := BYTE((sword and $F800) shr 8);
      sword := ($1 shl 15) +
              ((WORD(dr) and $F8) shl 7) +
              (WORD(dg) and $F8 shl 2) +
              (WORD(db) shr 3);
     { sword := ($F0 shl 8) +
              ((WORD(dr) and $F0) shl 4) +
              (WORD(dg) and $F0) +
              (WORD(db) shr 4); }
      addstr := addstr + '$' + IntToHex(sword, 4) + ', ';

    end;
  end;
  tempstr.add(addstr);
  tempstr.add('  ); ');
  tempstr.SaveToFile('d:\alpha16.txt');
  tempstr.free;      *)
  Caption := MAINFORMCAPTION + ' []';
  Tool_BackColor.SymbolColor := g_BackColor;
  Tool_BlendColor.SymbolColor := g_AlphaColor;
  PanelDraw.Color := g_BackColor;
  ScrollBox.Color := g_BackColor;
  InitializeForm;
  FBlend := $00000504;
  Tool_BlendMode.Items.Clear;
  Tool_BlendMode.Items.AddObject('Blend_None', TObject($00000001));
  Tool_BlendMode.Items.AddObject('Blend_Default', TObject($00000504));
  Tool_BlendMode.Items.AddObject('Blend_Anti', TObject($00000109));
  Tool_BlendMode.Items.AddObject('Blend_AlphaAdd', TObject($00000104)); //alphaadd
  Tool_BlendMode.Items.AddObject('Blend_AlphaAdd2', TObject($00000101)); //alphaadd2
  Tool_BlendMode.Items.AddObject('Blend_AlphaAdd3', TObject($00000302)); //alphaadd3
  Tool_BlendMode.Items.AddObject('Blend_AlphaAdd4', TObject($7FFFFFF0));
  Tool_BlendMode.Items.AddObject('Blend_ColorAdd', TObject($00000102));
  Tool_BlendMode.Items.AddObject('Blend_Shadow', TObject($00000500));
  Tool_BlendMode.Items.AddObject('Blend_Bright', TObject($00000201));
  Tool_BlendMode.Items.AddObject('Blend_IgnoreColor', TObject($7FFFFFF6));
  g_CustomIndex := Tool_BlendMode.Items.AddObject('Blend_Custom', TObject($00000001));
  Tool_SrcBlend.ItemIndex := 1;
  Tool_DestBlend.ItemIndex := 0;

  { Tool_BlendMode.Items.AddObject('None', TObject($00000001));
   Tool_BlendMode.Items.AddObject('Add', TObject($00000104));    //alphaadd
   Tool_BlendMode.Items.AddObject('Blend', TObject($00000504));
   Tool_BlendMode.Items.AddObject('Shadow', TObject($00000500));
   Tool_BlendMode.Items.AddObject('Multiply', TObject($00000200));
   Tool_BlendMode.Items.AddObject('InvMultiply', TObject($00000300));
   Tool_BlendMode.Items.AddObject('BlendNA', TObject($00000302)); //alphaadd3
   Tool_BlendMode.Items.AddObject('Sub', TObject($00010104));
   Tool_BlendMode.Items.AddObject('RevSub', TObject($00020104));
   Tool_BlendMode.Items.AddObject('Max', TObject($00040101));
   Tool_BlendMode.Items.AddObject('Min', TObject($00030101));
   Tool_BlendMode.Items.AddObject('Anti', TObject($00000109));
   Tool_BlendMode.Items.AddObject('AddX', TObject($00000101));  //alphaadd2
   Tool_BlendMode.Items.AddObject('SrcColorAdd', TObject($00000102));
   Tool_BlendMode.Items.AddObject('Invert', TObject($00000009));
   Tool_BlendMode.Items.AddObject('SrcBright', TObject($00000202));
   Tool_BlendMode.Items.AddObject('DestBright', TObject($00000808));
   Tool_BlendMode.Items.AddObject('InvSrcBright', TObject($00000303));
   Tool_BlendMode.Items.AddObject('InvDestBright', TObject($00000909));
   Tool_BlendMode.Items.AddObject('MultiplyX', TObject($00000800));
   Tool_BlendMode.Items.AddObject('MultiplyAlpha', TObject($00000600));
   Tool_BlendMode.Items.AddObject('InvMultiplyX', TObject($00000900));
   Tool_BlendMode.Items.AddObject('Add2X', TObject($7FFFFFF0));
   Tool_BlendMode.Items.AddObject('Light', TObject($7FFFFFF1));
   Tool_BlendMode.Items.AddObject('LightAdd', TObject($7FFFFFF2));
   Tool_BlendMode.Items.AddObject('Bright', TObject($7FFFFFF3));
   Tool_BlendMode.Items.AddObject('BrightAdd', TObject($7FFFFFF4));
   Tool_BlendMode.Items.AddObject('GrayScale', TObject($7FFFFFF5));
   Tool_BlendMode.Items.AddObject('OneColor', TObject($7FFFFFF6));
   FCustomIndex := Tool_BlendMode.Items.AddObject('Custom', TObject($00000001)); }
  Tool_BlendMode.ItemIndex := 1;
  PanelDraw.Left := 0;
  PanelDraw.Top := 0;
  PanelDraw.Width := MyDevice.Width;
  PanelDraw.Height := MyDevice.Height;
  MyDevice.WindowHandle := PanelDraw.Handle;

  if not MyDevice.Initialize then begin
    ShowMessage('Failed to initialize the device, error ' + MyDevice.InitError);
    exit;
  end;
  if not BASS_Init(-1, 44100, 0, 0, nil) then
    ShowMessage('Audio device initialization error');
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  WriteOpenFileList;
  TimerMusic.Enabled := False;
  if g_WMImages <> nil then
    g_WMImages.Free;
  g_WMImages := nil;
  g_DefDatImage.Free;
  g_DefWavImage.Free;
  g_DefMp3Image.Free;
  BASS_StreamFree(hs);
  BASS_Free;
  if DataStream <> nil then DataStream.Free;
end;

procedure TFormMain.InitializeForm;
begin
  MEMU_WORK_AUTOIMAGE.Checked := False;
  Tool_AUTOIMAGE.ImageIndex := 28;
  MEMU_FILE_CLOSE.Enabled := g_WMImages <> nil;
  CloseButton.Enabled := g_WMImages <> nil;

  MEMU_WORK_IMAGE_GOTO.Enabled := g_WMImages <> nil;
  MEMU_WORK_FRONT.Enabled := g_WMImages <> nil;
  MEMU_WORK_NEXT.Enabled := g_WMImages <> nil;

  Tool_Image_Goto.Enabled := g_WMImages <> nil;
  Tool_Front.Enabled := g_WMImages <> nil;
  Tool_Next.Enabled := g_WMImages <> nil;
  //Tool_BlendMode.Enabled := g_WMImages <> nil;
  //Tool_BlendMode_Custom.Enabled := g_WMImages <> nil;
  //Tool_Zoom.Enabled := g_WMImages <> nil;
  //Tool_Alpha.Enabled := g_WMImages <> nil;
  Tool_AUTOIMAGE.Enabled := g_WMImages <> nil;
  MEMU_WORK_AUTOIMAGE.Enabled := g_WMImages <> nil;
  MEMU_WORK_ADDIMAGE.Enabled := (g_WMImages <> nil) and (not g_WMImages.ReadOnly);
  MEMU_WORK_DELIMAGE.Enabled := (g_WMImages <> nil) and (not g_WMImages.ReadOnly);
  MEMU_WORK_PUTIMAGE.Enabled := g_WMImages <> nil;
  Tool_Image_Add.Enabled := (g_WMImages <> nil) and (not g_WMImages.ReadOnly);
  Tool_Image_Put.Enabled := g_WMImages <> nil;
  Tool_Image_Del.Enabled := (g_WMImages <> nil) and (not g_WMImages.ReadOnly);

  //MEMU_WORK_INSERTIMAGE.Enabled := (g_WMImages <> nil) and (not g_WMImages.ReadOnly);

  //MEMU_WORK_BATCHADD.Enabled := (g_WMImages <> nil) and (not g_WMImages.ReadOnly);
  //MEMU_WORK_BATCHPUT.Enabled := g_WMImages <> nil;
  DrawGrid.RowCount := 1;
  RefStatusBar;
end;

procedure TFormMain.InitializeGrid;
begin
  if g_WMImages <> nil then begin
    DrawGrid.RowCount := g_WMImages.ImageCount div 6 + 1;
    DrawGrid.Repaint;
  end;
end;

procedure TFormMain.Initializeg_WMImages(WILType: TWILType);
var
  FileName: string;
begin
  OpenDialog.FileName := '';
  if OpenDialog.Execute(Handle) and (OpenDialog.FileName <> '') then begin
    FileName := OpenDialog.FileName;
    OpenButton.Enabled := True;
    OpenWMFile(FileName, WILType);
    AddOpenFileList(FileName + ' [' + IntToStr(Integer(WILType)) + ']');
  end;
end;

procedure TFormMain.MEMU_FILE_CLOSEClick(Sender: TObject);
begin
  if g_WMImages <> nil then begin
    FreeAndNil(g_WMImages);
    Caption := MAINFORMCAPTION + ' []';
  end;
  InitializeForm;
end;

procedure TFormMain.MEMU_FILE_EXITClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.MEMU_FILE_OPEN_MIR2_16Click(Sender: TObject);
begin
  OpenDialog.FileName := '';
  OpenDialog.Filter := 'Mir2 Image Files(565)|*_16.wil';
  Initializeg_WMImages(t_wmM2Def16);
end;

procedure TFormMain.MEMU_FILE_OPEN_MIR2_OLDClick(Sender: TObject);
begin
  OpenDialog.FileName := '';
  OpenDialog.Filter := 'MIR2 Standard Image Files|*.wil';
  Initializeg_WMImages(t_wmM2Def);
end;

procedure TFormMain.MEMU_FILE_OPEN_MIR2_WISClick(Sender: TObject);
begin
  OpenDialog.FileName := '';
  OpenDialog.Filter := 'Mir2 Encrypted Image Files|*.wis';
  Initializeg_WMImages(t_wmM2Wis);
end;

procedure TFormMain.MEMU_FILE_OPEN_MIR2_ZIPClick(Sender: TObject);
begin
  OpenDialog.FileName := '';
  OpenDialog.Filter := 'Mir2 Compressed Image Files|*.wzl';
  Initializeg_WMImages(t_wmM2Zip);
end;

procedure TFormMain.MEMU_FILE_OPEN_MIR3Click(Sender: TObject);
begin
  OpenDialog.FileName := '';
  OpenDialog.Filter := 'Mir3 Standard Image File|*.wil';
  Initializeg_WMImages(t_wmM3Def);
end;

procedure TFormMain.MEMU_FILE_OPEN_MIR3ZipClick(Sender: TObject);
begin
  OpenDialog.FileName := '';
  OpenDialog.Filter := 'Mir3 Compressed Image File|*.miz';
  Initializeg_WMImages(t_wmM3Zip);
end;

procedure TFormMain.MEMU_FILE_OPEN_WOOOLClick(Sender: TObject);
begin
  OpenDialog.FileName := '';
  OpenDialog.Filter := 'Woool Standard Image File|*.sgl';
  Initializeg_WMImages(t_wmWoool);
end;

procedure TFormMain.MEMU_FILE_OPEN_WYClick(Sender: TObject);
begin
  OpenDialog.FileName := '';
  OpenDialog.Filter := 'WY Standard Image File|*.521g';
  Initializeg_WMImages(t_wm521g);
end;

procedure TFormMain.MEMU_WORK_ADDIMAGEClick(Sender: TObject);
begin
  if (g_WMImages <> nil) and (g_WMImages.boInitialize) then begin
    FormAdd.Open;
  end;
end;

procedure TFormMain.MEMU_WORK_AUTOIMAGEClick(Sender: TObject);
begin
  MEMU_WORK_AUTOIMAGE.Checked := not MEMU_WORK_AUTOIMAGE.Checked;
  FAutoTick := GetTickCount;
  Tool_AUTOIMAGE.ImageIndex := 28 + Integer(MEMU_WORK_AUTOIMAGE.Checked);
end;

procedure TFormMain.MEMU_WORK_DELIMAGEClick(Sender: TObject);
begin
  if (g_WMImages <> nil) and (g_WMImages.boInitialize) then begin
    FormDel.Open;
  end;
end;

procedure TFormMain.MEMU_WORK_PUTIMAGEClick(Sender: TObject);
begin
  if (g_WMImages <> nil) and (g_WMImages.boInitialize) then begin
    FormOut.Open;
  end;
end;

procedure TFormMain.MENU_HELP_ABOUTClick(Sender: TObject);
begin
  ShellAbout(0, PChar(MAINFORMCAPTION), 'Copyright (C) 2009-2010', Application.Icon.Handle);
end;

procedure TFormMain.MENU_OPTION_BACKIMAGEClick(Sender: TObject);
var
  Picture: TPicture;
  Access: TDXAccessInfo;
  Y, nWidth, nHeight: Integer;
  WriteBuffer, ReadBuffer: PChar;
  Bitmap: TBitmap;
  boFree: Boolean;
  //  i: integer;
begin
  if OpenPictureDialog.Execute(Handle) then begin
    Picture := TPicture.Create;
    try
      Picture.LoadFromFile(OpenPictureDialog.FileName);
      boFree := False;
      if not (Picture.Graphic is TBitmap) then begin
        Bitmap := TBitmap.Create;
        Bitmap.Assign(Picture.Graphic);
        boFree := True;
      end
      else
        Bitmap := TBitmap(Picture.Graphic);
      Bitmap.PixelFormat := pf32bit;
      g_Texture[0].PatternSize := Point(1, 1);
      nWidth := _MIN(Bitmap.Width, g_Texture[0].Size.X);
      nHeight := _MIN(Bitmap.Height, g_Texture[0].Size.Y);
      if g_Texture[0].Lock(lfWriteOnly, Access) then begin
        try
          for Y := 0 to nHeight - 1 do begin
            ReadBuffer := Bitmap.ScanLine[Y];
            WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
            Move(ReadBuffer^, WriteBuffer^, nWidth * 4);
          end;
          g_Texture[0].PatternSize := Point(nWidth, nHeight);
        finally
          g_Texture[0].Unlock;
        end;
      end;
      if boFree then
        Bitmap.Free;
    finally
      Picture.Free;
    end;
  end;
end;

procedure TFormMain.MENU_OPTION_BLENDCOLORClick(Sender: TObject);
begin
  if Sender = MENU_OPTION_BLENDCOLOR then begin
    SendMessage(Tool_BlendColor.Handle, BM_CLICK, 0, 0);
  end
  else begin
    SendMessage(Tool_BackColor.Handle, BM_CLICK, 0, 0);
  end;
end;

procedure TFormMain.MENU_OPTION_LEVELClick(Sender: TObject);
begin
  MENU_OPTION_LEVEL.Checked := not MENU_OPTION_LEVEL.Checked;
end;

procedure TFormMain.MENU_OPTION_UPRIGHTNESSClick(Sender: TObject);
begin
  MENU_OPTION_UPRIGHTNESS.Checked := not MENU_OPTION_UPRIGHTNESS.Checked;
end;

procedure TFormMain.MENU_TOOL_ALPHACHANGEClick(Sender: TObject);
begin
  FormAlpha.Open;
end;

procedure TFormMain.MENU_VIER_STATUSBARClick(Sender: TObject);
begin
  MENU_VIER_STATUSBAR.Checked := not MENU_VIER_STATUSBAR.Checked;
  StatusBar.Visible := MENU_VIER_STATUSBAR.Checked;
end;

procedure TFormMain.MENU_VIER_TOOLBARClick(Sender: TObject);
begin
  MENU_VIER_TOOLBAR.Checked := not MENU_VIER_TOOLBAR.Checked;
  StandardToolBar.Visible := MENU_VIER_TOOLBAR.Checked;
end;

procedure TFormMain.MyDeviceFinalize(Sender: TObject);
begin
  Timer.Enabled := False;
  g_Texture[0].Free;
  g_Texture[0] := nil;
  g_Texture[1].Free;
  g_Texture[1] := nil;
  FRenderSurface.Free;
  FRenderSurface := nil;
end;

procedure TFormMain.MyDeviceInitialize(Sender: TObject; var Success: Boolean; var ErrorMsg: string);
begin
  Timer.Enabled := True;
  g_Texture[0] := TDXImageTexture.Create;
  with g_Texture[0] do begin
    Size := Point(1024, 1024);
    PatternSize := Point(1, 1);
    Format := D3DFMT_A8R8G8B8;
    Active := True;
  end;
  g_Texture[1] := TDXImageTexture.Create;
  with g_Texture[1] do begin
    Size := Point(1024, 1024);
    PatternSize := Point(1, 1);
    //Format := D3DFMT_R5G6B5;
    //Active := True;
  end;
  FRenderSurface := TDXRenderTargetTexture.Create(nil);
  FRenderSurface.Size := Point(PresentParams.BackBufferWidth, PresentParams.BackBufferHeight);
  FRenderSurface.Format := D3DFMT_A4R4G4B4;
  FRenderSurface.MipMapping := False;
  FRenderSurface.Behavior := tbRTarget;
  FRenderSurface.Active := True;
end;

procedure TFormMain.MyDeviceNotifyEvent(Sender: TObject; Msg: Cardinal);
begin
  case Msg of
    msgDeviceLost: begin
      FRenderSurface.Lost;
    end;
    msgDeviceRecovered: begin
      FRenderSurface.Recovered;
    end;
  end;
end;

procedure TFormMain.MyDeviceRender(Sender: TObject);
begin
  MyDevice.Canvas.Draw(0, 0, FRenderSurface.ClientRect, FRenderSurface, fxBlend, clWhite4);
end;

procedure TFormMain.MEMU_FILE_AGOFILE_PATHSClick(Sender: TObject);
var
  sFileName, sType: string;
begin
  with Sender as TMenuitem do begin
    if Hint <> '' then begin
      sType := GetValidStr3(Hint, sFileName, [' ']);
      ArrestStringEx(sType, '[', ']', sType);
      if (sFileName <> '') and (sType <> '') then begin
        OpenWMFile(sFileName, TWILType(StrToIntDef(sType, 0)));
      end;
    end;
  end;
end;

procedure TFormMain.OpenButtonClick(Sender: TObject);
begin
  Initializeg_WMImages(g_WILType);
end;

procedure TFormMain.OpenWMFile(sFileName: string; WILType: TWILType);
begin
  if FileExists(sFileName) then begin
    OpenButton.Enabled := True;
    g_WILType := WILType;
    Caption := MAINFORMCAPTION + ' [' + sFileName + ']';
    if g_WMImages <> nil then begin
      g_WMImages.Free;
      g_WMImages := nil;
    end;
    g_SelectImageIndex := -1;
    g_WMImages := CreateWMImages(WILType);
    if g_WMImages <> nil then begin
      g_WMImages.FileName := sFileName;
      g_WMImages.LibType := ltLoadBmp;
      //g_WMImages.Password := '5d54273c';
      //g_WMImages.ChangeAlpha := True;
      g_WMImages.Initialize;
      DrawGrid.RowCount := g_WMImages.ImageCount div 6 + 1;
      DrawGrid.Repaint;
      if (WILType = t_wmMyImage) and (g_WMImages <> nil) and (g_WMImages.boInitialize) then
        Caption := MAINFORMCAPTION + ' [' + sFileName + '] ' + DateTimeToStr(TWMMyImageImages(g_WMImages).UpDateTime);
    end;
    InitializeForm;
    InitializeGrid;
  end;
end;

procedure TFormMain.PaintBox1Paint(Sender: TObject);
begin
  PaintBox1.Canvas.StretchDraw(Bounds(0, 0, PaintBox1.Width, PaintBox1.Height), BltBitmap);
end;

procedure TFormMain.PanelDrawMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FSpotX := X;
  FSpotY := Y;
  FDown := Tool_Random.Down;
end;

procedure TFormMain.PanelDrawMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  al, at: integer;
begin
  if not FDown then exit;
  with PanelDraw do begin
    if (FSpotX <> X) or (FSpotY <> Y) then begin
      al := FShowX + (X - FSpotX);
      at := FShowY + (Y - FSpotY);
      if al + Width < WINLEFT then
        al := WINLEFT - Width;
      if al > WINRIGHT then
        al := WINRIGHT;
      if at + Height < WINTOP then
        at := WINTOP - Height;
      if at > BOTTOMEDGE then
        at := BOTTOMEDGE;
      FShowX := al;
      FShowY := at;
      FSpotX := X;
      FSpotY := Y;
      RefStatusBar();
    end;
  end;
end;

procedure TFormMain.PanelDrawMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FDown := False;
end;

procedure TFormMain.MEMU_FILE_OPEN_DIYClick(Sender: TObject);
begin
  OpenDialog.FileName := '';
  OpenDialog.Filter := 'PAK File|*' + MYFILEEXT;
  Initializeg_WMImages(t_wmMyImage);
end;

procedure TFormMain.RefStatusBar;
begin
  if g_WMImages <> nil then begin
    StatusBar.Panels[0].Text := Format('Number: %d/%d', [g_SelectImageIndex, g_WMImages.ImageCount - 1]);
    StatusBar.Panels[1].Text := 'Format: Unknown';
    if g_WMImages is TWMM2DefImages then begin
      if TWMM2DefImages(g_WMImages).bo16bit then
        StatusBar.Panels[1].Text := 'Format: Mir2 Standard (16)'
      else
      if TWMM2DefImages(g_WMImages).NewFmt then
        StatusBar.Panels[1].Text := 'Format: MIR2 Standard (New)'
      else
        StatusBar.Panels[1].Text := 'Format: MIR2 Standard (Old)';
    end
    else if g_WMImages is TWMM2DefBit16Images then
      StatusBar.Panels[1].Text := 'Format: MIR2 Specific Data (16)'
    else if g_WMImages is TWMM2ZipImages then
      StatusBar.Panels[1].Text := 'Format: MIR2 Standard Compression'
    else if g_WMImages is TWMM2WisImages then
      StatusBar.Panels[1].Text := 'Format: MIR2 Specific Encryption'
    else if g_WMImages is TWMWoolDefImages then
      StatusBar.Panels[1].Text := 'Format: Woool'
    else if g_WMImages is TWMM3DefImages then begin
      if TWMM3DefImages(g_WMImages).NewFmt then
        StatusBar.Panels[1].Text := 'Format: MIR3 Standard (New)'
      else
        StatusBar.Panels[1].Text := 'Format: MIR3 Standard (Old)';
    end
    else if g_WMImages is TWMM3ZipImages then
      StatusBar.Panels[1].Text := 'Format: MIR3 Standard Compression'
    else if g_WMImages is TWMMyImageImages then begin
      StatusBar.Panels[1].Text := 'Format: Custom Image File'
    end;
  end
  else begin
    StatusBar.Panels[0].Text := 'Number: 0/0';
    StatusBar.Panels[1].Text := 'Format: Unknown';
  end;
  StatusBar.Panels[2].Text := Format('Format: %d * %d', [g_TextureInfo.nWidth, g_TextureInfo.nHeight]);
  StatusBar.Panels[3].Text := Format('CoordinateX: %d', [g_TextureInfo.px]);
  StatusBar.Panels[4].Text := Format('CoordinateY: %d', [g_TextureInfo.py]);
  case g_WILColorFormat of
    -1: StatusBar.Panels[5].Text := 'Format: Default';
    0: StatusBar.Panels[5].Text := 'Format: A4R4G4B4';
    1: StatusBar.Panels[5].Text := 'Format: A1R5G5B5';
    2: StatusBar.Panels[5].Text := 'Format: R5G6B5';
    3: StatusBar.Panels[5].Text := 'Format: A8R8G8B8';
    else StatusBar.Panels[5].Text := 'Format: Unknown';
  end;
  StatusBar.Panels[6].Text := Format('Transparency: %d', [Tool_Alpha.Position]);
  StatusBar.Panels[7].Text := Format('Test: (%d,%d)', [FShowX, FShowY]);
end;

procedure TFormMain.S1Click(Sender: TObject);
begin
  {FSaveDir := InputBox('设置保存位置', '保存路径', FSaveDir);
  if FSaveDir = '' then
    FLastIndex := -1;     }
end;

procedure TFormMain.SaveRenderToBmp(sFileName: string);
var
  PrevTarget, Offscreen: IDirect3DSurface9;
  DRect: TRect;
  BItmap: TBitmap;
  LockedRect: TD3DLockedRect;
  y: Integer;
  WriteBuffer, ReadBuffer: PChar;
begin
  PrevTarget := nil;
  Offscreen := nil;
  Try
    if not Succeeded(Direct3DDevice.CreateOffscreenPlainSurface(FRenderSurface.Width,
      FRenderSurface.Height, FRenderSurface.Format, D3DPOOL_SYSTEMMEM, PrevTarget, nil)) then Exit;

    DRect := Rect(0, 0, FRenderSurface.Width, FRenderSurface.Height);

    if not Succeeded(FRenderSurface.Texture9.GetSurfaceLevel(0, Offscreen)) then Exit;
    if not Succeeded(Direct3DDevice.GetRenderTargetData(Offscreen, PrevTarget)) then Exit;
    if Succeeded(PrevTarget.LockRect(LockedRect, nil, D3DLOCK_READONLY)) then begin
      Bitmap := TBitmap.Create;
      Try
        Bitmap.PixelFormat := pf32bit;
        Bitmap.Width := FRight;
        Bitmap.Height := FBottom;
        for Y := 0 to Bitmap.Height - 1 do begin
          ReadBuffer := PChar(Integer(LockedRect.pBits) + LockedRect.Pitch * Y);
          WriteBuffer := Bitmap.ScanLine[Y];
          Move(ReadBuffer^, WriteBuffer^, Bitmap.Width * 4);
        end;
        Bitmap.SaveToFile(sFileName);
      Finally
        Bitmap.Free;
        PrevTarget.UnlockRect;
      End;
    end;
  Finally
    PrevTarget := nil;
    Offscreen := nil;
  End;

end;

procedure TFormMain.ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
var
  Position: Int64;
begin
  bt_Music_PauseClick(nil);
  Position := BASS_ChannelSeconds2Bytes(hs, ScrollPos / 1000);
  BASS_ChannelSetPosition(hs, Position, BASS_POS_BYTE);
end;

function TFormMain.SetDrawGridIndex(Index: Integer): Boolean;
begin
  Result := False;
  if (g_WMImages <> nil) and g_WMImages.boInitialize then begin
    if (Index >= 0) and (Index <= (g_WMImages.ImageCount - 1)) then begin
      DrawGrid.Row := Index div 6;
      DrawGrid.Col := Index mod 6;
      Result := True;
    end;
  end;
end;

procedure TFormMain.TimerMusicTimer(Sender: TObject);
const
  w = 3;
var
  i,di: Integer;
  s: Double; {当前秒数}
begin

  if BASS_ChannelIsActive(hs) <> BASS_ACTIVE_PLAYING then begin
    bt_Music_StopClick(nil);
    Exit;
  end;

  s := BASS_ChannelBytes2Seconds(hs, BASS_ChannelGetPosition(hs, BASS_POS_BYTE));
  ScrollBar1.Position := Trunc(s * 1000);

  BASS_ChannelGetData(hs, @FFTData, BASS_DATA_FFT4096);

  BltBitmap.Width := PaintBox1.Width;
  BltBitmap.Height := PaintBox1.Height;
  BltBitmap.Canvas.Brush.Color := clBlack;
  BltBitmap.Canvas.FillRect(Rect(0, 0, BltBitmap.Width, BltBitmap.Height));

  BltBitmap.Canvas.Pen.Color := clLime;
  for i := 0 to Length(FFTData) - 1 do
  begin
    di := Trunc(Abs(FFTData[i]) * 500);

    if di > BltBitmap.Height then di := BltBitmap.Height;
    if di >= FFTPeacks[i] then FFTPeacks[i] := di else FFTPeacks[i] := FFTPeacks[i] - 1;
    if di >= FFTFallOff[i] then FFTFallOff[i] := di else FFTFallOff[i] := FFTFallOff[i] - 3;
    if (BltBitmap.Height - FFTPeacks[i]) > BltBitmap.Height then FFTPeacks[i] := 0;
    if (BltBitmap.Height - FFTFallOff[i]) > BltBitmap.Height then FFTFallOff[i] := 0;

//    BltBitmap.Canvas.MoveTo(i, BltBitmap.Height);
//    BltBitmap.Canvas.LineTo(i, BltBitmap.Height - FFTFallOff[i]);
//    BltBitmap.Canvas.Pixels[i, BltBitmap.Height - FFTPeacks[i]] := BltBitmap.Canvas.Pen.Color;

    BltBitmap.Canvas.Pen.Color := BltBitmap.Canvas.Pen.Color;
    BltBitmap.Canvas.MoveTo(i * (w + 1), BltBitmap.Height - FFTPeacks[i]);
    BltBitmap.Canvas.LineTo(i * (w + 1) + w, BltBitmap.Height - FFTPeacks[i]);

    BltBitmap.Canvas.Pen.Color := BltBitmap.Canvas.Pen.Color;
    BltBitmap.Canvas.Brush.Color := BltBitmap.Canvas.Pen.Color;
    BltBitmap.Canvas.Rectangle(i * (w + 1), BltBitmap.Height - FFTFallOff[i], i * (w + 1) + w, BltBitmap.Height);
  end;

  BitBlt(PaintBox1.Canvas.Handle, 0, 0, PaintBox1.Width, PaintBox1.Height, BltBitmap.Canvas.Handle, 0, 0, SRCCOPY);
end;

procedure TFormMain.TimerTimer(Sender: TObject);
const
  boRun: Boolean = False;
  WriteIndex: Byte = 0;
begin
  if boRun then
    exit;
  boRun := True;
  if MEMU_WORK_AUTOIMAGE.Checked and (GetTickCount > FAutoTick) then begin
    FAutoTick := GetTickCount + 200;
    if not SetDrawGridIndex(DrawGrid.Row * 6 + DrawGrid.Col + 1) then begin
      MEMU_WORK_AUTOIMAGE.Checked := False;
      Tool_AUTOIMAGE.ImageIndex := 28;
    end;
  end;
  try
    MyDevice.RenderOn(FRenderSurface, DrawRender, g_BackColor, True);
    if (FSaveDir <> '') and (FLastIndex <> g_SelectImageIndex) then begin
      FLastIndex := g_SelectImageIndex;
      SaveRenderToBmp(FSaveDir + Format('%.6d.bmp', [g_SelectImageIndex]));

      {FLastIndex := g_SelectImageIndex;
      SaveRenderToBmp(FSaveDir + Format('%.6d.bmp', [WriteIndex]));
      Inc(WriteIndex);
      if WriteIndex >= 4 then WriteIndex := 0;
      self.Caption := IntToStr(WriteIndex);  }
    end;
    MyDevice.Render(g_BackColor, True);
    MyDevice.Flip;

  finally
    boRun := False;
  end;
end;

procedure TFormMain.Tool_AlphaChange(Sender: TObject);
begin
  RefStatusBar;
end;

procedure TFormMain.Tool_BackColorClick(Sender: TObject);
begin
  g_BackColor := Tool_BackColor.SymbolColor;
  PanelDraw.Color := g_BackColor;
  ScrollBox.Color := g_BackColor;
  RefStatusBar;
end;

procedure TFormMain.Tool_BlendColorClick(Sender: TObject);
begin
  g_AlphaColor := Tool_BlendColor.SymbolColor;
  RefStatusBar;
end;

procedure TFormMain.Tool_BlendModeChange(Sender: TObject);
begin
  if (Tool_BlendMode.ItemIndex <> -1) and (Tool_BlendMode.ItemIndex < Tool_BlendMode.Items.Count) then
    FBlend := Cardinal(Tool_BlendMode.Items.Objects[Tool_BlendMode.ItemIndex]);
  Tool_SrcBlend.Enabled := g_CustomIndex = Tool_BlendMode.ItemIndex;
  Tool_DestBlend.Enabled := g_CustomIndex = Tool_BlendMode.ItemIndex;
  if Tool_SrcBlend.Enabled then
    Tool_DestBlendChange(Tool_DestBlend);
end;

procedure TFormMain.Tool_Image_GotoClick(Sender: TObject);
begin
  if (g_WMImages <> nil) and g_WMImages.boInitialize then begin
    SetDrawGridIndex(StrToIntDef(InputBox('跳转', '请输入图片索引号', IntToStr(g_SelectImageIndex)), 1));
  end;
end;

procedure TFormMain.Tool_NewClick(Sender: TObject);
var
  fhandle: THandle;
  sFileName: string;
  WMImageHeader: wmMyImage.TWMImageHeader;
begin
  SaveDialog.FileName := '';
  SaveDialog.Filter := '自定义数据存储文件(*' + MYFILEEXT + ')|*' + MYFILEEXT;
  if SaveDialog.Execute(Handle) and (SaveDialog.FileName <> '') then begin
    sFileName := SaveDialog.FileName;
    if CompareText(RightStr(sFileName, 4), MYFILEEXT) <> 0 then
      sFileName := sFileName + MYFILEEXT;

    if FileExists(sFileName) then begin
      if MessageBox(Handle, '文件已经存在，是否覆盖原文件？', '提示信息', MB_OKCANCEL + MB_ICONWARNING) =
        IDCANCEL then
        exit;
      DeleteFile(sFileName);
    end;
    fhandle := FileCreate(sFileName, fmOpenWrite);
    if fhandle > 0 then begin
      FillChar(WMImageHeader, SizeOf(WMImageHeader), #0);
      WMImageHeader.Title := HEADERNAME;
      WMImageHeader.CopyRight := COPYRIGHTNAME;
      WMImageHeader.UpDateTime := Now();
      FileWrite(fhandle, WMImageHeader, SizeOf(WMImageHeader));
      FileClose(fhandle);
      if MessageBox(Handle, '是否打开新创建的文件？', '提示信息', MB_YESNO + MB_ICONQUESTION) = IDYES then
        OpenWMFile(sFileName, t_wmMyImage);
    end;
  end;
end;

procedure TFormMain.Tool_NextClick(Sender: TObject);
begin
  if (g_WMImages <> nil) and g_WMImages.boInitialize then begin
    if (Sender = Tool_Next) or (Sender = MEMU_WORK_NEXT) then
      SetDrawGridIndex(DrawGrid.Row * 6 + DrawGrid.Col + 1)
    else
      SetDrawGridIndex(DrawGrid.Row * 6 + DrawGrid.Col - 1);
  end;
end;

procedure TFormMain.Tool_ZoomChange(Sender: TObject);
var
  sInput: string;
  nInput: Integer;
begin
  case Tool_Zoom.ItemIndex of
    0: FZoomSize := 0.5;
    1: FZoomSize := 1;
    2: FZoomSize := 2;
    3: FZoomSize := 4;
    4: FZoomSize := 8;
    5: begin
      if not InputQuery('设置缩放比例', '例如：10 代表 10%', sInput) then
        Exit;
      nInput := StrToIntDef(sInput, 100);
      FZoomSize := nInput / 100;
    end;
  end;
end;

const
  REGPATH = 'SOFTWARE\Jason\RPGViewer\Path';

procedure TFormMain.AddOpenFileList(sFileName: string);
var
  Item: TMenuItem;
  i: Integer;
begin
  if sFileName = '' then exit;
  Item := TMenuItem.Create(MEMU_FILE_AGOFILE);
  Item.Caption := '&0 ' + sFileName;
  Item.Hint := sFileName;
  item.OnClick := MEMU_FILE_AGOFILE_PATHSClick;
  MEMU_FILE_AGOFILE.Insert(0, Item);
  for I := MEMU_FILE_AGOFILE.Count - 1 downto 1 do begin
    item := MEMU_FILE_AGOFILE.Items[I];
    if (item.Hint = '') or (item.Hint = sFileName) then begin
      MEMU_FILE_AGOFILE.Delete(I);
      item.Free;
    end else begin
      Item.Caption := '&' + IntToStr(I) + ' ' + item.Hint;
    end;
  end;
  if MEMU_FILE_AGOFILE.Count > 10 then
    MEMU_FILE_AGOFILE.Delete(10);
end;

procedure TFormMain.ReadOpenFileList;
var
  Reg: TRegistry;
  I: Integer;
  sFileName: string;
  Item: TMenuItem;
begin
  Reg := TRegistry.Create;
  Try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(REGPATH, False) then begin
      for I := 0 to 9 do begin
        sFileName := Trim(Reg.ReadString(IntToStr(I)));
        if sFileName <> '' then begin
          if I = 0 then begin
            item := MEMU_FILE_AGOFILE.Items[0];
            item.Enabled := True;
            Item.Caption := '&' + IntToStr(I) + ' ' + sFileName;
            Item.Hint := sFileName;
            item.OnClick := MEMU_FILE_AGOFILE_PATHSClick;
          end else begin
            Item := TMenuItem.Create(MEMU_FILE_AGOFILE);
            Item.Caption := '&' + IntToStr(I) + ' ' + sFileName;
            Item.Hint := sFileName;
            item.OnClick := MEMU_FILE_AGOFILE_PATHSClick;
            MEMU_FILE_AGOFILE.Add(Item);
          end;
        end else break;
      end;
    end;
    Reg.CloseKey;
  Finally
    Reg.Free;
  End;
end;

procedure TFormMain.WriteOpenFileList;
var
  Reg: TRegistry;
  I: Integer;
begin
  Reg := TRegistry.Create;
  Try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(REGPATH, True) then begin
      for I := 0 to MEMU_FILE_AGOFILE.Count - 1 do begin
        Reg.WriteString(IntToStr(I), MEMU_FILE_AGOFILE.Items[I].Hint);
      end;
    end;
    Reg.CloseKey;
  Finally
    Reg.Free;
  End;
end;

end.

