unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, MyDirect3D9, MyDXBase,
  Dialogs, ExtCtrls, TDX9Devices, StdCtrls, WMFile, TDX9Textures, WIL, TDX9Fonts, Spin, LShare;

const
  NEWPOINTOX = 25;
  NEWPOINTOY = 4;
  MDLGCLICKOX = 20;
  MDLGCHICKOY = 1;
  MDLGMOVEIMAGE = 622;
  MDLGCHICKIMAGE = 623;


type

  PRGBQuads = ^TRGBQuads;
  TRGBQuads = array[0..255] of TRGBQuad;

  pTClickPoint = ^TClickPoint;
  TClickPoint = record
    rc: TRect;
    rstr: string;
    sstr: string;
    boNewPoint: Boolean;
    Color: TColor;
  end;

  pTNewShowHint = ^TNewShowHint;
  TNewShowHint = record
    Surfaces: TWMImages;
    IndexList: TStringList;
    nX, nY: Integer;
    Rect: TRect;
    Reduce: Byte;
    boTransparent: Boolean;
    Alpha: Byte;
    dwTime: LongWord;
    boMove: Boolean;
    boBlend: Boolean;
    boLine: Boolean;
    boRect: Boolean;
  end;

  TFormMain = class(TForm)
    Device: TDX9Device;
    TimerDraw: TTimer;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    PanelBG: TPanel;
    Panel2: TPanel;
    GroupBox2: TGroupBox;
    MemoText: TMemo;
    Panel4: TPanel;
    Label1: TLabel;
    eImageID: TSpinEdit;
    ckSndaMode: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    eImageWidth: TSpinEdit;
    eImageHeight: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure DeviceInitialize(Sender: TObject; var Success: Boolean; var ErrorMsg: string);
    procedure DeviceFinalize(Sender: TObject);
    procedure TimerDrawTimer(Sender: TObject);
    procedure DeviceRender(Sender: TObject);
    procedure MemoTextKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ScrollBar1Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MemoTextChange(Sender: TObject);
    procedure PanelBGMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PanelBGMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PanelBGMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DeviceNotifyEvent(Sender: TObject; Msg: Cardinal);
    procedure eImageIDChange(Sender: TObject);
    procedure ckSndaModeClick(Sender: TObject);
  private
    g_TempList: TStringList;
    g_DX9Font: TDX9Font;
    FSurface: TDirectDrawSurface;
    MDlgPoints: TList;
    MDlgDraws: TList;
    MDlgMove: TClickPoint;
    MDlgSelect: TClickPoint;
    boDown: Boolean;
    FShowTime: LongWord;
    FRect: TRect;
    FWidth: Integer;
    FHeight: Integer;
    FboCreate: Boolean;
    function GetRGB(c256: byte): LongWord;
    function DlgShowText(DSurface: TDirectDrawSurface; X, Y: Integer; Points, DrawList: TList; Msg: string;
      DefaultColor: TColor = clSilver): integer;
    procedure PrintScreenNow(nIdx: Integer);
  public
    FDefMainPalette: TRgbQuads;
  end;

const
  SndaMERCHANTMAXHEIGHT = 149;
  SndaMDLGMAXWIDTH = 356;
  SndaMDLGMAXHEIGHT = 1024;
  SndaImageID = 1933;

  JXMERCHANTMAXHEIGHT = 306;
  JXMDLGMAXWIDTH = 242;
  JXMDLGMAXHEIGHT = 1024;
  JXImageID = 136;

var
  FormMain: TFormMain;
  g_MERCHANTMAXHEIGHT: Integer = SndaMERCHANTMAXHEIGHT;
  g_MDLGMAXWIDTH: Integer = SndaMDLGMAXWIDTH;
  g_MDLGMAXHEIGHT: Integer = SndaMDLGMAXHEIGHT;
  g_ImageID: Integer = SndaImageID;


implementation

{$R *.dfm}
{$R ColorTable.RES}

uses
  HUtil32;

procedure TFormMain.ckSndaModeClick(Sender: TObject);
begin
  if ckSndaMode.Checked then
  begin
    g_MERCHANTMAXHEIGHT := SndaMERCHANTMAXHEIGHT;
    g_MDLGMAXWIDTH := SndaMDLGMAXWIDTH;
    g_MDLGMAXHEIGHT := SndaMDLGMAXHEIGHT;
    g_ImageID := SndaImageID;
  end
  else
  begin
    g_MERCHANTMAXHEIGHT := JXMERCHANTMAXHEIGHT;
    g_MDLGMAXWIDTH := JXMDLGMAXWIDTH;
    g_MDLGMAXHEIGHT := JXMDLGMAXHEIGHT;
    g_ImageID := JXImageID;
  end;
  eImageID.Value := g_ImageID;
  eImageWidth.Value := g_MDLGMAXWIDTH;
  eImageHeight.Value := g_MERCHANTMAXHEIGHT;
end;

procedure TFormMain.DeviceFinalize(Sender: TObject);
begin
  TimerDraw.Enabled := False;
  FSurface.Free;
  FSurface := nil;
end;

procedure TFormMain.DeviceInitialize(Sender: TObject; var Success: Boolean; var ErrorMsg: string);
begin

  Device.Canvas.Font := g_DX9Font;
  g_DX9Font.CreateTexture;
  Success := g_DX9Font.Initialize('MS Sans Serif', 9);
  if not Success then
  begin
    ErrorMsg := 'Font Initialize Error';
    exit;
  end;
  FSurface := TDXImageTexture.Create(Device.Canvas);
  FSurface.Size := Point(Device.Width, Device.Height);
  FSurface.PatternSize := Point(Device.Width, Device.Height);
  FSurface.Format := D3DFMT_A4R4G4B4;
  FSurface.Active := True;

  InitWMImagesLib('');
  TimerDraw.Enabled := True;
end;

procedure TFormMain.DeviceNotifyEvent(Sender: TObject; Msg: Cardinal);
begin
  case Msg of
    msgDeviceLost: begin
        g_DX9Font.Lost;
      end;
    msgDeviceRecovered: begin
        g_DX9Font.Recovered;
      end;
  end; 
end;

procedure TFormMain.DeviceRender(Sender: TObject);
{const
  MERCHANTMAXWIDTH = 242;
  MERCHANTMAXHEIGHT = 306;  }
var
  d: TDXTexture;
  ax, ay, I, Index, px, py: integer;
  rc, dc: TRect;
  pShowHint: pTNewShowHint;
  dwTime: LongWord;
  nMaxWidth, nMaxHeight: Integer;
begin
  ax := 0;
  ay := 0;
  d := g_WMain99Images.Images[g_ImageID];
  if d <> nil then
    Device.Canvas.Draw(0, 0, d.ClientRect, d, True);
  nMaxWidth := g_MDLGMAXWIDTH;
  nMaxHeight := g_MerchantMaxHeight;
  rc.Left := 0;
  rc.Top := 0;
  rc.Right := nMaxWidth;
  rc.Bottom := 0 + nMaxHeight;
  if ckSndaMode.Checked then begin
    Inc(ax, 20);
     Inc(ay, 18);
  end else begin
    Inc(ax, 20);
    Inc(ay, 20);
  end;

  dwTime := GetTickCount - FShowTime;
  for i := 0 to MDlgDraws.Count - 1 do
  begin
    pShowHint := MDlgDraws[i];
    if (pShowHint.Surfaces <> nil) and (pShowHint.IndexList <> nil) and (pShowHint.IndexList.Count > 0) then
    begin
      {case i of
        0: lbl1.Caption := IntToStr(pShowHint.IndexList.Count);
        1: lbl2.Caption := IntToStr(pShowHint.IndexList.Count);
        2: lbl3.Caption := IntToStr(pShowHint.IndexList.Count);
        3: lbl4.Caption := IntToStr(pShowHint.IndexList.Count);
        4: lbl5.Caption := IntToStr(pShowHint.IndexList.Count);
        5: lbl6.Caption := IntToStr(pShowHint.IndexList.Count);
        6: lbl7.Caption := IntToStr(pShowHint.IndexList.Count);
        7: lbl8.Caption := IntToStr(pShowHint.IndexList.Count);
        8: lbl9.Caption := IntToStr(pShowHint.IndexList.Count);
        9: lbl10.Caption := IntToStr(pShowHint.IndexList.Count);
        10: lbl11.Caption := IntToStr(pShowHint.IndexList.Count);
        11: lbl12.Caption := IntToStr(pShowHint.IndexList.Count);
        12: lbl13.Caption := IntToStr(pShowHint.IndexList.Count);
        13: lbl14.Caption := IntToStr(pShowHint.IndexList.Count);
        14: lbl15.Caption := IntToStr(pShowHint.IndexList.Count);
        15: lbl16.Caption := IntToStr(pShowHint.IndexList.Count);
        16: lbl17.Caption := IntToStr(pShowHint.IndexList.Count);
        17: lbl18.Caption := IntToStr(pShowHint.IndexList.Count);
        18: lbl19.Caption := IntToStr(pShowHint.IndexList.Count);
        19: lbl20.Caption := IntToStr(pShowHint.IndexList.Count);
        20: lbl21.Caption := IntToStr(pShowHint.IndexList.Count);
        21: lbl22.Caption := IntToStr(pShowHint.IndexList.Count);
        22: lbl23.Caption := IntToStr(pShowHint.IndexList.Count);
        23: lbl24.Caption := IntToStr(pShowHint.IndexList.Count);
      end;}
      Index := dwTime div pShowHint.dwTime mod LongWord(pShowHint.IndexList.Count);
      d := pShowHint.Surfaces.GetCachedImage(StrToIntDef(pShowHint.IndexList[Index], -1), px, py);
      if d <> nil then
      begin
        if pShowHint.boMove then
        begin
          px := pShowHint.nX + px;
          py := pShowHint.ny + py { - DMDlgUpDonw.Position};
        end
        else
        begin
          px := pShowHint.nX;
          py := pShowHint.ny { - DMDlgUpDonw.Position};
        end;
        if pShowHint.boRect then
          dc := pShowHint.Rect
        else
          dc := d.ClientRect;
        if px >= rc.Right then
          Continue;
        if py >= nMaxHeight then
          Continue;
        if px < 0 then
        begin
          dc.Left := -px;
          px := 0;
        end;
        if py < 0 then
        begin
          dc.Top := -py;
          py := 0;
        end;
        if (dc.Right - dc.Left + px) > rc.Right then
          dc.Right := rc.Right - px - dc.Left;
        if (dc.Bottom - dc.Top + py) > nMaxHeight then
          dc.Bottom := nMaxHeight - py - dc.Top;
        if (dc.Right - dc.Left) <= 0 then
          Continue;
        if (dc.Bottom - dc.Top) <= 0 then
          Continue;
        if pShowHint.boBlend then
        begin
          if not pShowHint.boTransparent then
            Device.Canvas.Draw(ax + px, ay + py, dc, d, fxBlend, cColor4($80FFFFFF))
          else
            Device.Canvas.Draw(ax + px, ay + py, dc, d, fxAnti);
        end
        else
        begin
          if pShowHint.Alpha < 255 then
          begin
            Device.Canvas.Draw(ax + px, ay + py, dc, d, pShowHint.boTransparent, cColor4(Byte(pShowHint.Alpha) shl 24 or $00FFFFFF));
          end
          else
          begin
            Device.Canvas.Draw(ax + px, ay + py, dc, d, pShowHint.boTransparent);
          end;
        end;
      end;
    end;
  end;
  Device.Canvas.Draw(ax, ay, rc, FSurface, True);
  if not ckSndaMode.Checked then
    Device.Canvas.Font.kerning := -1;
  try
    if (MDlgSelect.rstr <> '') and (boDown) then
    begin
      dc := MDlgSelect.rc;
      dc.Left := ax + dc.Left;
      dc.Right := ax + dc.Right;
      dc.Top := dc.Top { - DMDlgUpDonw.Position};
      dc.Bottom := dc.Bottom { - DMDlgUpDonw.Position};
      if (dc.Bottom > 0) and (dc.Top < rc.Bottom) then
      begin
        dc.Top := dc.Top + ay;
        dc.Bottom := dc.Bottom + ay;
        if MDlgMove.boNewPoint then
        begin
          dc.Top := dc.Top - 2;
          dc.Bottom := dc.Bottom + 3;
          Device.Canvas.FillRect(dc.Left + MDLGCLICKOX, dc.Top, 225 {dc.Right - dc.Left - NEWPOINTOX},
            dc.Bottom - dc.Top, $A062625A);
          Device.Canvas.TextOut(dc.Left + NEWPOINTOX + 1, dc.Top + 2 + NEWPOINTOY, MDlgMove.sstr, MDlgMove.Color);
          d := g_WMain99Images.Images[MDLGCHICKIMAGE];
          if d <> nil then
          begin
            Device.Canvas.Draw(dc.Left, dc.Top + 3, d.ClientRect, d, True);
          end;
        end
        else
        begin
          Device.Canvas.TextOut(dc.Left + 1, dc.Top + 1, MDlgSelect.sstr, clLime);
        end;
      end;
    end
    else if (MDlgMove.rstr <> '') and (not boDown) then
    begin
      dc := MDlgMove.rc;
      dc.Left := ax + dc.Left;
      dc.Right := ax + dc.Right;
      dc.Top := dc.Top { - DMDlgUpDonw.Position};
      dc.Bottom := dc.Bottom { - DMDlgUpDonw.Position};
      if (dc.Bottom > 0) and (dc.Top < rc.Bottom) then
      begin
        dc.Top := dc.Top + ay;
        dc.Bottom := dc.Bottom + ay;
        if MDlgMove.boNewPoint then
        begin
          dc.Top := dc.Top - 2;
          dc.Bottom := dc.Bottom + 3;
          Device.Canvas.FillRect(dc.Left + MDLGCLICKOX, dc.Top, 225 {dc.Right - dc.Left - NEWPOINTOX},
            dc.Bottom - dc.Top, $B4939594);
          Device.Canvas.TextOut(dc.Left + NEWPOINTOX, dc.Top + 1 + NEWPOINTOY, MDlgMove.sstr, MDlgMove.Color);
          d := g_WMain99Images.Images[MDLGMOVEIMAGE];
          if d <> nil then
          begin
            Device.Canvas.Draw(dc.Left, dc.Top + 3, d.ClientRect, d, True);
          end;
        end
        else
        begin
          Device.Canvas.TextOut(dc.Left, dc.Top, MDlgMove.sstr, clAqua);
          Device.Canvas.MoveTo(dc.Left - 1, dc.Top + Device.Canvas.TextHeight(MDlgMove.sstr));
          Device.Canvas.LineTo(dc.Right - 1, dc.Top + Device.Canvas.TextHeight(MDlgMove.sstr), clAqua);
        end;
      end;
    end;
  finally
    Device.Canvas.Font.kerning := -2;
  end;
  {if chk3.Checked and not chk4.Checked then
    Device.Canvas.FillRect(FRect, clGray4, fxAnti);}
  //Device.Canvas.FillRect(0, 0, 20, 20, $FF0000FF);   chk3
end;

function TFormMain.DlgShowText(DSurface: TDirectDrawSurface; X, Y: Integer; Points, DrawList: TList;
  Msg: string; DefaultColor: TColor): integer;
var
  lx, ly, sx, i: integer;
  str, data, fdata, cmdstr, cmdparam, sTemp: string;
  pcp: PTClickPoint;
  d: TDirectDrawSurface;
  boNewPoint: Boolean;

  function ColorText(sStr: string; DefColor: TColor; boDef, boLength: Boolean; var ClickColor: TColor): string;
  var
    sdata, sfdata, scmdstr, scmdparam, scmdcolor: string;
    ii: Integer;
    mfid, mx, my: Integer;
    sName, sparam, sMin, sMax: string;
    boMove, boBlend: Boolean;
    boTransparent: Boolean;
    dwTime: LongWord;
    nAlpha: Integer;
    Idx, nMin, nMax: Integer;
    Color: TColor;
    ShowHint: pTNewShowHint;
    backText: string;
    TempList: TStringList;
    DRect: TRect;
    boRect: Boolean;
  begin
    Color := DefColor;
    with DSurface do
    begin
      backText := '';
      sdata := sStr;
      sfdata := '';
      while (pos('{', sdata) > 0) and (pos('}', sdata) > 0) and (sdata <> '') do
      begin
        sfdata := '';
        if sdata[1] <> '{' then
        begin
          sdata := '{' + GetValidStr3(sdata, sfdata, ['{']);
        end;
        scmdparam := '';
        scmdstr := '';
        sdata := ArrestStringEx(sdata, '{', '}', scmdstr);
        if scmdstr <> '' then
        begin
          scmdparam := GetValidStr3(scmdstr, scmdstr, ['=']);
          scmdcolor := GetValidStr3(scmdparam, scmdparam, ['=']);
        end;
        if sfdata <> '' then
        begin
          if boLength then
          begin
            backText := backText + sfdata;
          end
          else
          begin
            TextOutEx(lx + sx, ly, sfdata, DefColor);
            sx := sx + Device.Canvas.TextWidth(sfdata);
          end;
          sfdata := '';
        end;
        Color := DefColor;
        if CompareLStr(scmdparam, 'item', length('item')) then
        begin //new
          New(ShowHint);
          g_TempList.Clear;
          g_TempList.Add('671');
          SafeFillChar(ShowHint^, SizeOf(TNewShowHint), #0);
          ShowHint.Surfaces := g_WMain99Images;
          ShowHint.IndexList := g_TempList;
          ShowHint.nX := lx + sx;
          ShowHint.nY := ly;
          ShowHint.boTransparent := False;
          ShowHint.Alpha := 255;
          ShowHint.dwTime := 100;
          ShowHint.boBlend := False;
          ShowHint.boMove := False;
          DrawList.Add(ShowHint);
          g_TempList := TStringList.Create;
          scmdstr := '';
        end
        else if CompareLStr(scmdparam, 'img', length('img')) then
        begin //new
          boTransparent := True;
          boMove := False;
          boBlend := False;
          mfid := -1;
          mx := 0;
          my := 0;
          dwTime := 80;
          nAlpha := 255;
          boRect := False;
          while True do
          begin
            if scmdstr = '' then
              Break;
            scmdstr := GetValidStr3(scmdstr, stemp, [',']);
            if stemp = '' then
              Break;
            sTemp := LowerCase(stemp);
            sparam := GetValidStr3(stemp, sName, ['.']);
            if (sName <> '') and (sparam <> '') then
            begin
              case sName[1] of
                'f':
                  begin
                    mfid := StrToIntDef(sparam, -1);
                    if not (mfid in [Images_Begin..Images_End]) then
                      mfid := -1;
                  end;
                'i':
                  begin
                    g_TempList.Clear;
                    if ExtractStrings(['+'], [], PChar(sparam), g_TempList) > 0 then
                    begin
                      Idx := 0;
                      while True do
                      begin
                        if Idx >= g_TempList.Count then
                          Break;
                        sTemp := g_TempList[Idx];
                        if pos('-', sTemp) > 0 then
                        begin
                          sMax := GetValidStr3(stemp, sMin, ['-']);
                          nMin := StrToIntDef(sMin, 0);
                          nMax := StrToIntDef(sMax, 0);
                          if (nMin + 1000) < nMax then
                            nMax := nMin + 1000;
                          if nMin = 0 then
                            nMin := nMax;
                          if nMax = 0 then
                            nMax := nMin;
                          if nMin > nMax then
                            nMin := nMax;
                          g_TempList.Delete(Idx);
                          if nMin <> 0 then
                          begin
                            for ii := nMin to nMax do
                            begin
                              g_TempList.Insert(Idx, IntToStr(ii));
                              Inc(idx);
                            end;
                          end;

                        end
                        else
                          Inc(Idx);
                      end;
                    end
                    else
                      g_TempList.Add(sparam);
                  end;
                'x': mx := StrToIntDef(sparam, 0);
                'y': my := StrToIntDef(sparam, 0);
                'b': boBlend := (sparam = '1');
                'p': boTransparent := (sparam = '1');
                'm': boMove := (sparam = '1');
                't': dwTime := StrToIntDef(sparam, 0);
                'a': nAlpha := StrToIntDef(sparam, 255);
                'r':
                  begin
                    TempList := TStringList.Create;
                    if ExtractStrings(['+'], [], PChar(sparam), TempList) > 3 then
                    begin
                      boRect := True;
                      DRect.Left := StrToIntDef(TempList[0], 0);
                      DRect.Top := StrToIntDef(TempList[1], 0);
                      DRect.Right := StrToIntDef(TempList[2], 0);
                      DRect.Bottom := StrToIntDef(TempList[3], 0);
                    end;
                    TempList.Free;
                  end;
              end;
            end;
          end;
          if (mfid > -1) and (g_ClientImages[mfid] <> nil) and (g_TempList.Count > 0) then
          begin
            if mx = 0 then
              mx := lx + sx;
            if my = 0 then
              my := ly;
            New(ShowHint);
            FillChar(ShowHint^, SizeOf(TNewShowHint), #0);
            ShowHint.Surfaces := g_ClientImages[mfid];
            ShowHint.IndexList := g_TempList;
            ShowHint.nX := mx;
            ShowHint.nY := mY;
            ShowHint.boTransparent := boTransparent;
            ShowHint.Alpha := nAlpha;
            ShowHint.dwTime := dwTime;
            ShowHint.boBlend := boBlend;
            ShowHint.boMove := boMove;
            ShowHint.boRect := boRect;
            ShowHint.Rect := DRect;
            DrawList.Add(ShowHint);
            g_TempList := TStringList.Create;
          end;
          sfdata := '';
          scmdparam := '';
          scmdstr := '';
          Continue;
        end
        else if CompareLStr(scmdparam, 'X', length('X')) then
        begin //new
          sx := sx + StrToIntDef(scmdstr, 0);
          sfdata := '';
          scmdparam := '';
          scmdstr := '';
          Continue;
        end
        else if CompareLStr(scmdparam, 'Y', length('Y')) then
        begin //new
          ly := ly + StrToIntDef(scmdstr, 0);
          sfdata := '';
          scmdparam := '';
          scmdstr := '';
          Continue;
        end
        else if CompareText(scmdparam, 'FCO') = 0 then
        begin
          g_TempList.Clear;
          if ExtractStrings([','], [], PChar(scmdcolor), g_TempList) > 0 then
          begin
            scmdcolor := g_TempList.Strings[0];
          end;
          Color := GetRGB(Lobyte(StrToIntDef(scmdcolor, 255)));
        end;
        if boDef then
          Color := DefColor;
        if boLength then
        begin
          backText := backText + scmdstr;
        end
        else
        begin
          TextOutEx(lx + sx, ly, scmdstr, Color);
          sx := sx + Device.Canvas.TextWidth(scmdstr);
        end;
      end; //end while
      if sdata <> '' then
      begin
        if boLength then
        begin
          backText := backText + sdata;
        end
        else
        begin
          TextOutEx(x + sx, ly, sdata, DefColor);
          sx := sx + Device.Canvas.TextWidth(sdata);
        end;
      end;
      Result := backText;
    end;
    ClickColor := Color;
  end;
var
  ClickColor: TColor;
begin
  with DSurface do
  begin
    if not ckSndaMode.Checked then
      Device.Canvas.Font.kerning := -1;
    try
      for i := 0 to DrawList.count - 1 do
      begin
        if pTNewShowHint(DrawList[i]).IndexList <> nil then
          pTNewShowHint(DrawList[i]).IndexList.Free;
        Dispose(pTNewShowHint(DrawList[i]));
      end;
      DrawList.Clear;
      lx := x;
      ly := y;
      str := Msg;
      while TRUE do
      begin
        if str = '' then
          break;
        str := GetValidStr3(str, data, ['\']);
        if data <> '' then
        begin
          sx := 0;
          while (pos('<', data) > 0) and (pos('>', data) > 0) and (data <> '') do
          begin
            fdata := '';
            if data[1] <> '<' then
            begin
              data := '<' + GetValidStr3(data, fdata, ['<']);
            end;
            data := ArrestStringEx(data, '<', '>', cmdstr);
            cmdparam := GetValidStr3(cmdstr, cmdstr, ['/']);
            if fdata <> '' then
            begin
              ColorText(fdata, DefaultColor, False, False, ClickColor);
              fdata := '';
            end;
            if Length(cmdstr) > 1 then
            begin
              boNewPoint := False;
              if cmdstr[1] = '&' then
              begin
                boNewPoint := True;
                cmdstr := Copy(cmdstr, 2, Length(cmdstr) - 1);
              end;
              if (cmdparam <> '') then
              begin //new
                if boNewPoint then
                begin
                  new(pcp);
                  sTemp := ColorText(cmdstr, DefaultColor, False, True, ClickColor);
                  pcp.rc := Rect(lx + sx, ly + 1, lx + sx + DSurface.Width, ly + 20);
                  pcp.rstr := cmdparam;
                  pcp.sstr := sTemp;
                  pcp.boNewPoint := True;
                  pcp.Color := ClickColor;
                  Points.Add(pcp);
                end
                else
                begin
                  new(pcp);
                  sTemp := ColorText(cmdstr, clYellow, False, True, ClickColor);
                  pcp.rc := Rect(lx + sx, ly, lx + sx + Device.Canvas.TextWidth(sTemp), ly + 14);
                  pcp.RStr := cmdparam;
                  pcp.sstr := sTemp;
                  pcp.boNewPoint := False;
                  pcp.Color := ClickColor;
                  Points.Add(pcp);
                end;
              end;
              if cmdparam = '' then
              begin
                ColorText(cmdstr, clRed, False, False, ClickColor);
              end
              else
              begin
                if boNewPoint then
                begin
                  d := g_WMain99Images.Images[621];
                  if d <> nil then
                  begin
                    CopyTexture(lx + sx, ly + 1, d);
                  end;
                  Inc(ly, NEWPOINTOY);
                  Inc(sx, NEWPOINTOX);
                  ColorText(cmdstr, DefaultColor, False, False, ClickColor);
                  Inc(ly, 4);
                end
                else
                  ColorText(cmdstr, clYellow, False, False, ClickColor);
              end;
            end;
          end;
          if data <> '' then
            ColorText(data, DefaultColor, False, False, ClickColor);
        end;
        Inc(ly, 16);
        if ly >= g_MDLGMAXHEIGHT then
          break;
      end;
    finally
      Device.Canvas.Font.kerning := -2;
    end;
  end;
  Result := ly;
end;

procedure TFormMain.eImageIDChange(Sender: TObject);
var
  nValue: Integer;
begin
  nValue := TSpinEdit(Sender).Value;
  if Sender = eImageID then
  begin
    g_ImageID := nValue;
  end
  else if Sender = eImageWidth then
  begin
    g_MDLGMAXWIDTH := nValue;
  end
  else if Sender = eImageHeight then
  begin
    g_MERCHANTMAXHEIGHT := nValue;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  Res: TResourceStream;
begin
  FboCreate := False;
  if not CheckMirDir(ExtractFilePath(Application.ExeName), True) then
  begin
    Application.MessageBox('Please run the tool inside your Client folder.', 'Message', MB_OK + MB_ICONSTOP);
    //PostMessage(Handle, WM_Close, 0, 0);
    Application.Terminate;
    Exit;
  end;
  Res := TResourceStream.Create(Hinstance, '256RGB', 'RGB');
  try
    Res.Read(FDefMainPalette, SizeOf(FDefMainPalette));
  finally
    Res.Free;
  end;
  g_TempList := TStringList.Create;
  MDlgPoints := TList.Create;
  MDlgDraws := TList.Create;
  boDown := False;
  g_DX9Font := TDX9Font.Create;
  Device.Width := PanelBG.Width;
  Device.Height := PanelBG.Height;
  Device.Windowed := True;
  Device.WindowHandle := PanelBG.Handle;
  LoadWMImagesLib(nil);
  FShowTime := GetTickCount;
  FboCreate := True;
  if not Device.Initialize then
  begin
    Application.MessageBox('Video device failed to initialize!', '', MB_OK + MB_ICONWARNING);
    exit;
  end;

  //ScrollBar1Change(ScrollBar1);
  MemoTextChange(MemoText);
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  if FboCreate then
  begin

    UnLoadWMImagesLib;
    g_TempList.Free;
    MDlgPoints.Free;
    MDlgDraws.Free;
    g_DX9Font.Free;
  end;
end;

function TFormMain.GetRGB(c256: byte): LongWord;
begin
  Result := RGB(FDefMainPalette[c256].rgbRed, FDefMainPalette[c256].rgbGreen, FDefMainPalette[c256].rgbBlue);
end;

procedure TFormMain.MemoTextChange(Sender: TObject);
var
  MemoChr: PChar;
  ShowStr: string;
  I: Integer;
begin
  MemoChr := MemoText.Lines.GetText;
  ShowStr := string(MemoChr);
  StrDispose(MemoChr);
  FSurface.Clear;
  if ShowStr <> '' then
  begin

    for i := 0 to MDlgPoints.count - 1 do
      Dispose(pTClickPoint(MDlgPoints[i]));
    for i := 0 to MDlgDraws.count - 1 do
    begin
      if pTNewShowHint(MDlgDraws[i]).IndexList <> nil then
        pTNewShowHint(MDlgDraws[i]).IndexList.Free;
      Dispose(pTNewShowHint(MDlgDraws[i]));
    end;
    MDlgPoints.Clear;
    MDlgDraws.Clear;
    if ckSndaMode.Checked then DlgShowText(FSurface, 0, 0, MDlgPoints, MDlgDraws, ShowStr, clWhite)
    else DlgShowText(FSurface, 0, 0, MDlgPoints, MDlgDraws, ShowStr);

  end;
end;

procedure TFormMain.MemoTextKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = Word('A')) then
  begin
    with Sender as TMemo do
      SelectAll;
  end;
end;

procedure TFormMain.PanelBGMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, L, T: Integer;
  p: pTClickPoint;
begin
  MDlgSelect.rstr := '';
  boDown := True;
  if ckSndaMode.Checked then begin
    L := 20;
    T := 18;
    if ((X - 20) < g_MDLGMAXWIDTH) and ((Y - 18) < g_MERCHANTMAXHEIGHT) then begin
      Y := Y {+ DMDlgUpDonw.Position};
      //with DMerchantDlg do begin
      for i := 0 to MDlgPoints.count - 1 do
      begin
        p := pTClickPoint(MDlgPoints[i]);
        if (X >= (L + p.rc.Left)) and (X <= (L + p.rc.Right)) and
          (Y >= (T + p.rc.Top)) and (Y <= (T + p.rc.Bottom)) then
        begin
          MDlgSelect := p^;
          exit;
        end;
      end;
      //end;
    end;
  end else begin
    L := 20;
    T := 20;
    if ((X - 20) < g_MDLGMAXWIDTH) and ((Y - 20) < g_MERCHANTMAXHEIGHT) then begin
      Y := Y {+ DMDlgUpDonw.Position};
      //with DMerchantDlg do begin
      for i := 0 to MDlgPoints.count - 1 do
      begin
        p := pTClickPoint(MDlgPoints[i]);
        if (X >= (L + p.rc.Left)) and (X <= (L + p.rc.Right)) and
          (Y >= (T + p.rc.Top)) and (Y <= (T + p.rc.Bottom)) then
        begin
          MDlgSelect := p^;
          exit;
        end;
      end;
      //end;
    end;
  end;
end;

procedure TFormMain.PanelBGMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  i, L, T: Integer;
  p: pTClickPoint;
begin
  MDlgMove.rstr := '';
  if boDown then
    exit;
  MDlgSelect.rstr := '';
  if ckSndaMode.Checked then begin
    L := 20;
    T := 18;
    if ((X - 20) < g_MDLGMAXWIDTH) and ((Y - 18) < g_MERCHANTMAXHEIGHT) then
    begin
      Y := Y {+ DMDlgUpDonw.Position};
      //with DMerchantDlg do begin
      for i := 0 to MDlgPoints.count - 1 do
      begin
        p := pTClickPoint(MDlgPoints[i]);
        if (X >= (L + p.rc.Left)) and (X <= (L + p.rc.Right)) and
          (Y >= (T + p.rc.Top)) and (Y <= (T + p.rc.Bottom)) then
        begin
          MDlgMove := p^;
          break;
        end;
      end;
      //end;
    end;
  end else begin
    L := 20;
    T := 20;
    if ((X - 20) < g_MDLGMAXWIDTH) and ((Y - 20) < g_MERCHANTMAXHEIGHT) then
    begin
      Y := Y {+ DMDlgUpDonw.Position};
      //with DMerchantDlg do begin
      for i := 0 to MDlgPoints.count - 1 do
      begin
        p := pTClickPoint(MDlgPoints[i]);
        if (X >= (L + p.rc.Left)) and (X <= (L + p.rc.Right)) and
          (Y >= (T + p.rc.Top)) and (Y <= (T + p.rc.Bottom)) then
        begin
          MDlgMove := p^;
          break;
        end;
      end;
      //end;
    end;
  end;
end;

procedure TFormMain.PanelBGMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  boDown := False;
end;

procedure TFormMain.PrintScreenNow(nIdx: Integer);
var
  flname, Dirname: string;
  //JPG: TJPEGImage;
  BItmap: TBitmap;
  Bitmap2: TBitmap;
  PrevTarget, Offscreen: IDirect3DSurface9;
  //  DRect: TRect;
  LockedRect: TD3DLockedRect;
  ImageBuffer, WriteBuffer, ReadBuffer: PChar;
  Y: Integer;
begin
  //PlaySoundEx(bmg_Camera);
  if (Direct3DDevice = nil) or (not Device.boInitialized) then
    exit;
  try
    if not Succeeded(Direct3DDevice.CreateOffscreenPlainSurface(PresentParams.BackBufferWidth,
      PresentParams.BackBufferHeight, PresentParams.BackBufferFormat, D3DPOOL_SYSTEMMEM, PrevTarget, nil)) then
      Exit;

    //DRect := Rect(0, 0, PresentParams.BackBufferWidth, PresentParams.BackBufferHeight);

    if not Succeeded(Direct3DDevice.GetBackBuffer(0, 0, D3DBACKBUFFER_TYPE_MONO, Offscreen)) then
      Exit;
    if not Succeeded(Direct3DDevice.GetRenderTargetData(Offscreen, PrevTarget)) then
      Exit;

    if Succeeded(PrevTarget.LockRect(LockedRect, nil, D3DLOCK_READONLY)) then
    begin
      Bitmap := TBitmap.Create;
      //JPG := TJPEGImage.Create;
      ImageBuffer := nil;
      try
        Dirname := GetCurrentDir;
        if Copy(Dirname, Length(Dirname), 1) <> '\' then
          Dirname := Dirname + '\';
        Dirname := Dirname + 'Screenshot\';
        if not DirectoryExists(Dirname) then
          CreateDir(Dirname);
        flname := Dirname + Format('%.3d', [nIdx]) + '.bmp';
        {while True do begin
          flname := Dirname + 'Images' + IntToStr2(g_nCaptureSerial) + '.jpg';
          if not FileExists(flname) then
            break;
          Inc(g_nCaptureSerial);
        end;     }
        Bitmap.Width := PresentParams.BackBufferWidth;
        Bitmap.Height := PresentParams.BackBufferHeight;
        case D3DDataSize(PresentParams.BackBufferFormat) of
          1:
            begin
              {Bitmap.PixelFormat := pf8bit;
              SetDIBColorTable(Bitmap.Canvas.Handle, 0, 256, g_ColorTable);
              for Y := 0 to Bitmap.Height - 1 do begin
                ReadBuffer := PChar(Integer(LockedRect.pBits) + LockedRect.Pitch * Y);
                WriteBuffer := Bitmap.ScanLine[Y];
                Move(ReadBuffer^, WriteBuffer^, LockedRect.Pitch);
              end;  }
            end;
          2:
            begin
              case PresentParams.BackBufferFormat of
                D3DFMT_X1R5G5B5: Bitmap.PixelFormat := pf15bit;
                D3DFMT_R5G6B5: Bitmap.PixelFormat := pf16bit;
              else
                exit;
              end;
              for Y := 0 to Bitmap.Height - 1 do
              begin
                ReadBuffer := PChar(Integer(LockedRect.pBits) + LockedRect.Pitch * (Y + FRect.Top));
                WriteBuffer := Bitmap.ScanLine[Y];
                Move(ReadBuffer^, WriteBuffer^, Bitmap.Width * 2);
              end;
            end;
          {3: begin
            Bitmap.PixelFormat := pf24bit;
            for Y := 0 to Bitmap.Height - 1 do begin
              RGBQuadBuffer := PRGBQuad(Integer(LockedRect.pBits) + LockedRect.Pitch * Y);
              RGBTripleBuffer := Bitmap.ScanLine[Y];
              for X := 0 to Bitmap.Width - 1 do begin
                RGBTripleBuffer.rgbtRed := RGBQuadBuffer.rgbRed;
                RGBTripleBuffer.rgbtGreen := RGBQuadBuffer.rgbGreen;
                RGBTripleBuffer.rgbtBlue := RGBQuadBuffer.rgbBlue;
                Inc(RGBQuadBuffer);
                Inc(RGBTripleBuffer);
              end;
            end;
          end; }
          3, 4:
            begin
              Bitmap.PixelFormat := pf32bit;
              for Y := 0 to Bitmap.Height - 1 do
              begin
                ReadBuffer := PChar(Integer(LockedRect.pBits) + LockedRect.Pitch * (Y + FRect.Top));
                WriteBuffer := Bitmap.ScanLine[Y];
                Move(ReadBuffer^, WriteBuffer^, Bitmap.Width * 4);
              end;
            end;
        end;
      finally
        PrevTarget.UnlockRect;
        //        n := 0;

                //JPG.Assign(Bitmap); //FormatDateTime('YYYY-MM-DD HH:MM:SS', Now)
                //Jpg.CompressionQuality := 100;
                //Jpg.SaveToFile(flname);

                //JPG.Free;

        Bitmap.SaveToFile(flname);
        Bitmap.Free;
        if ImageBuffer <> nil then
          FreeMem(ImageBuffer);
        PrevTarget := nil;
        //DScreen.AddSysMsg('[截图保存位置：' + flname + ']', clWhite);
      end;
    end;
  finally
    PrevTarget := nil;
    Offscreen := nil;
  end;
end;

procedure TFormMain.ScrollBar1Change(Sender: TObject);
begin
  //Label3.Color := GetRGB(ScrollBar1.Position);
  //Label4.Color := GetRGB(ScrollBar1.Position);
  //Label3.Font.Color := GetRGB(ScrollBar2.Position);
  //Label3.Caption := Format('文字颜色 ABCDEFG 123456 (F%d,B%d)', [ScrollBar2.Position, ScrollBar1.Position]);
end;

procedure TFormMain.TimerDrawTimer(Sender: TObject);
begin
  Device.Render(0{ $FFFFFFFF}, True);
  Device.Flip;
end;

end.

