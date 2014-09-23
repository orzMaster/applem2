unit MaskFont;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, trace, Math, mmsystem;

const
  PIXELCOUNTMAX = 32768; 

type

  TAAQuality = (aqHighest, aqHigh, aqNormal, aqLow, aqNone);
  {* 平滑字体显示精度类型
   |<PRE>
     aqHighest  - 5X5采样的最高显示精度，速度超慢
     aqHigh     - 4X4采样的最高显示精度，速度较慢
     aqNormal   - 3X3采样的普通显示精度，最佳性能速度比
     aqLow      - 2X2采样的低显示精度，速度较快
     aqNone     - 无平滑效果
   |</PRE>}

  TBlurStrength = 0..100;
  {* 模糊度类型，0为不模糊，100为最大模糊度}

  TLogPal = record
    lpal: TLogPalette;
    dummy: array[0..255] of TPaletteEntry;
  end;


  TRGBQuad = packed record
    rgbBlue: BYTE;
    rgbGreen: BYTE;
    rgbRed: BYTE;
    rgbReserved: BYTE;
  end;
  
  pRGBArray = ^TRGBArray;
  TRGBArray = array[0..PIXELCOUNTMAX] of TRGBTriple;

  pRGBQuadArray = ^TRGBQuadArray;
  TRGBQuadArray = array[0..PixelCountMax - 1] of TRGBQuad;
   
  TMaskFont = class(TPersistent)
  private
        GrayBmp, FMaskBmp, FMaskPathBmp: TBitmap;
        FQuality: TAAQuality;
        Scale: integer;
        AAFont: TFont;

        FPathPoints: array of TPoint;
        FPathTypes: array of Byte;
        FNumber: Integer;
        FCounter: Byte;

        procedure InitGrayBmp;
        procedure FreeGrayBmp;
        procedure SetQuality(const Value: TAAQuality);
  protected
  public
        constructor Create(AOwner: TFont);
        destructor Destroy;override;
        procedure DrawMask(Left, Top, W: integer; Text: string);

        procedure Blur(Mask: TBitmap; Blur: TBlurStrength);

        property MaskBmp: TBitmap read FMaskBmp;
        property MaskPathBmp: TBitmap read FMaskPathBmp;

        property Quality: TAAQuality read FQuality write SetQuality;
        {* 平滑字体绘制精度}
        function GetBits: pByteArray;
        procedure SetPixel(x, y: integer; color: integer);
        function  GetPixel(x, y: integer): integer;

  end;

var  
  LogPal: TLogPal;
  HGrayPal: HPALETTE = 0;

implementation

//--------------------------------------------------------//
//平滑字体蒙板                                         //
//--------------------------------------------------------//

//初始化灰度位图
procedure InitGrayPal;
var
  i: Integer;
begin
  LogPal.lpal.palVersion := $300;
  LogPal.lpal.palNumEntries := 256;
  for i := 0 to 255 do
  begin
    LogPal.dummy[i].peRed := i;
    LogPal.dummy[i].peGreen := i;
    LogPal.dummy[i].peBlue := i;
    LogPal.dummy[i].peFlags := 0;
  end;
  HGrayPal := CreatePalette(LogPal.lpal);
end;

//设置精度
procedure TMaskFont.SetQuality(const Value: TAAQuality);
begin
  FQuality := Value;
  case FQuality of
    aqHighest: Scale := 5;
    aqHigh: Scale := 4;
    aqNormal: Scale := 3;
    aqLow: Scale := 2;
    aqNone: Scale := 1;
  else
    Scale := 1;
  end;
end;

constructor TMaskFont.Create(AOwner: TFont);
begin
    InitGrayBmp;
    AAFont := AOwner;
end;

destructor TMaskFont.Destroy;
begin
    FreeGrayBmp;
    inherited;    
end;

procedure TMaskFont.InitGrayBmp;
begin
    InitGrayPal;
    GrayBmp := TBitmap.Create;
    GrayBmp.PixelFormat := pf8bit;
    GrayBmp.Canvas.Brush.Style := bsSolid;
    GrayBmp.Canvas.Brush.Color := clBlack;
    GrayBmp.Palette := CopyPalette(HGrayPal);

    FMaskBmp := TBitmap.Create;
    FMaskBmp.PixelFormat := pf8bit;
    FMaskBmp.Canvas.Brush.Style := bsSolid;
    FMaskBmp.Canvas.Brush.Color := clBlack;
    FMaskBmp.Palette := CopyPalette(HGrayPal);

    FMaskPathBmp := TBitmap.Create;
    FMaskPathBmp.PixelFormat := pf8bit;
    FMaskPathBmp.Canvas.Brush.Style := bsSolid;
    FMaskPathBmp.Canvas.Brush.Color := clBlack;
    FMaskPathBmp.Palette := CopyPalette(HGrayPal);
end;

procedure TMaskFont.FreeGrayBmp;
var
  P: HPALETTE;
begin
  if GrayBmp <> nil then
  begin
    P := GrayBmp.Palette;
    GrayBmp.Palette := 0;
    FreeAndNil(GrayBmp);
    DeleteObject(P);
  end;

  if FMaskBmp <> nil then
  begin
    P := FMaskBmp.Palette;
    FMaskBmp.Palette := 0;
    FreeAndNil(FMaskBmp);
    DeleteObject(P);
  end;

  if FMaskPathBmp <> nil then
  begin
    P := FMaskPathBmp.Palette;
    FMaskPathBmp.Palette := 0;
    FreeAndNil(FMaskPathBmp);
    DeleteObject(P);
  end;

  DeleteObject(HGrayPal);
end;


//字体模糊
procedure TMaskFont.Blur(Mask: TBitmap; Blur: TBlurStrength);
type
  TLine = array[0..4] of Integer;
const
  csLine: array[0..4] of TLine = (
    (0, 0, 0, 1, 2), (-1, -1, 0, 1, 2), (-2, -1, 0, 1, 2),
    (-2, -1, 0, 1, 1), (-2, -1, 0, 0, 0)); //边界处理常量
var
  pTempBuff: PByteArray;
  pSour: array[0..4] of PByteArray;
  pDes: PByteArray;
  xLine: TLine;
  yLine: TLine;
  x, y, i: Integer;
  Sum: Integer;
  ABlur: Byte;
begin

    ABlur := Round(Blur * 255 / 100);
    for y := 0 to Mask.Height - 1 do         //边界处理
    begin
      if y = 0 then
        yLine := csLine[0]
      else if y = 1 then
        yLine := csLine[1]
      else if y = Mask.Height - 2 then
        yLine := csLine[3]
      else if y = Mask.Height - 1 then
        yLine := csLine[4]
      else
        yLine := csLine[2];
      for i := 0 to 4 do
        pSour[i] := Mask.ScanLine[yLine[i] + y];
        pDes := Mask.ScanLine[y];
      for x := 0 to Mask.Width - 1 do        //边界处理
      begin
        if x = 0 then
          xLine := csLine[0]
        else if x = 1 then
          xLine := csLine[1]
        else if x = Mask.Width - 2 then
          xLine := csLine[3]
        else if x = Mask.Width - 1 then
          xLine := csLine[4]
        else
          xLine := csLine[2];
        Sum := 0;
        for i := 0 to 4 do              //5X5均值处理
          Inc(Sum, pSour[i]^[x + xLine[0]] + pSour[i]^[x + xLine[1]] +
            pSour[i]^[x + xLine[2]] + pSour[i]^[x + xLine[3]] +
            pSour[i]^[x + xLine[3]]);
        if ABlur = 255 then             //模糊度
          pDes^[x] := Round(Sum / 25)
        else
          pDes^[x] := (Round(Sum / 25) - pDes^[x]) * ABlur shr 8 + pDes^[x];
      end;
    end;

end;


procedure TMaskFont.DrawMask(Left, Top, W: integer; Text: string);
var
    x, y, j, i: integer;
    tot: integer;
    DestScan, BigScan: pByteArray;

//    LogFont: TLogFont;
//    OldFont: HFont;

    t1: int64;

    PointIdx: integer;
    LastMove: TPoint;
begin

   t1 := timegettime;


    GrayBmp.Canvas.Brush.Color := clBlack;
    GrayBmp.Canvas.FillRect(GrayBmp.Canvas.ClipRect);

    GrayBmp.Canvas.Font.Assign(AAFont);

    FMaskBmp.Width := GrayBmp.Canvas.TextExtent(Text).cx;
    FMaskBmp.Height := GrayBmp.Canvas.TextExtent(Text).cy;


  GrayBmp.Width := FMaskBmp.Width * Scale;
  GrayBmp.Height := FMaskBmp.Height * Scale;

  FMaskBmp.Width := GrayBmp.Canvas.TextExtent(Text).cx + Left;
  FMaskBmp.Height := GrayBmp.Canvas.TextExtent(Text).cy + Top;

//  TraceString(IntToStr(GrayBmp.Canvas.TextExtent(Text).cx));

{
  GetObject(GrayBmp.Canvas.Font.Handle, SizeOf(TLogFont), @LogFont);
  with LogFont do
  begin
    lfHeight := lfHeight * Scale;
    lfWidth := lfWidth * Scale;
    lfQuality := DEFAULT_QUALITY;
  end;

  GrayBmp.Canvas.Font.Handle := CreateFontIndirect(LogFont);
}
  GrayBmp.Canvas.Font.Size := GrayBmp.Canvas.Font.Size * Scale;

//  GrayBmp.Canvas.Font.Color := clWhite;
  BeginPath(GrayBmp.Canvas.Handle);
    SetBkMode(GrayBmp.Canvas.Handle, TRANSPARENT);
    GrayBmp.Canvas.TextOut(0, 0, Text);
  EndPath(GrayBmp.Canvas.Handle);

  GrayBmp.Canvas.Brush.Color := clWhite;
  FillPath(GrayBmp.Canvas.Handle);

    for y := 0 to GrayBmp.Height Div Scale -1 do
    begin
      DestScan := FMaskBmp.ScanLine[y];
      for x := 0 to GrayBmp.Width Div Scale -1 do
      begin
        tot := 0;

        for j := 0 to Scale - 1 do
        begin
          BigScan := pByteArray(GrayBmp.ScanLine[Scale * y + j] );
          for i := 0 to Scale -1 do
          begin
            tot := tot + BigScan[Scale * x+i];
          end;
        end;
        DestScan[x] := tot div (Scale * Scale);
      end;
    end;

//    MaskBmp.SaveToFile('m.bmp');
{
  OldFont := GrayBmp.Canvas.Font.Handle;
  GrayBmp.Canvas.Font.Handle := 0;
  DeleteObject(OldFont);
}
// GrayBmp 清0
    GrayBmp.Canvas.Brush.Color := clBlack;
    GrayBmp.Canvas.FillRect(GrayBmp.Canvas.ClipRect);

    GrayBmp.Canvas.Font.Assign(AAFont);

    FMaskPathBmp.Width := GrayBmp.Canvas.TextExtent(Text).cx;
    FMaskPathBmp.Height := GrayBmp.Canvas.TextExtent(Text).cy;

    GrayBmp.Width := FMaskPathBmp.Width * Scale;
    GrayBmp.Height := FMaskPathBmp.Height * Scale;

    FMaskPathBmp.Width := GrayBmp.Canvas.TextExtent(Text).cx + Left;
    FMaskPathBmp.Height := GrayBmp.Canvas.TextExtent(Text).cy + Top;

//   TraceString(IntToStr(GrayBmp.Canvas.TextExtent(Text).cx));
{
  GetObject(GrayBmp.Canvas.Font.Handle, SizeOf(TLogFont), @LogFont);
  with LogFont do
  begin
    lfHeight := lfHeight * Scale;
    lfWidth := lfWidth * Scale;
    lfQuality := DEFAULT_QUALITY;
  end;

  GrayBmp.Canvas.Font.Handle := CreateFontIndirect(LogFont);
}
  GrayBmp.Canvas.Font.Size := GrayBmp.Canvas.Font.Size * Scale;

  BeginPath(GrayBmp.Canvas.Handle);
    SetBkMode(GrayBmp.Canvas.Handle, TRANSPARENT);
    GrayBmp.Canvas.TextOut(0, 0, Text);
  EndPath(GrayBmp.Canvas.Handle);

//  if not FlattenPath(Canvas.Handle) then Exit;
//    FlattenPath(GrayBmp.Canvas.Handle);
  FNumber := GetPath(GrayBmp.Canvas.Handle, Pointer(nil^), Pointer(nil^), 0);
  SetLength(FPathPoints, FNumber);
  SetLength(FPathTypes, FNumber);
  FNumber := GetPath(GrayBmp.Canvas.Handle, FPathPoints[0], FPathTypes[0], FNumber);

  PointIdx := 0;    

  GrayBmp.Canvas.Pen.Color := clWhite;
  GrayBmp.Canvas.Pen.Width := w;

//    StrokePath(GrayBmp.Canvas.Handle);


//+++  描边//
    while PointIdx < FNumber do begin

    case FPathTypes[PointIdx] of PT_MOVETO:
        begin
            GrayBmp.Canvas.MoveTo(FPathPoints[PointIdx].X, FPathPoints[PointIdx].Y);
            LastMove := FPathPoints[PointIdx];
            inc(PointIdx, 1);
        end;
        PT_LINETO:
        begin
            GrayBmp.Canvas.LineTo(FPathPoints[PointIdx].X, FPathPoints[PointIdx].Y);
            inc(PointIdx, 1);
        end;
        PT_BEZIERTO:
        begin
            PolyBezierTo(GrayBmp.Canvas.Handle, FPathPoints[PointIdx], 3);
            inc(PointIdx, 3);
        end;
        PT_LINETO or PT_CLOSEFIGURE:
        begin
            GrayBmp.Canvas.LineTo(FPathPoints[PointIdx].X, FPathPoints[PointIdx].y);
            GrayBmp.Canvas.LineTo(LastMove.x, LastMove.y);
            inc(PointIdx, 1);
        end;
        PT_BEZIERTO or PT_CLOSEFIGURE:
        begin
            PolyBezierTo(GrayBmp.Canvas.Handle, FPathPoints[PointIdx], 3);
            GrayBmp.Canvas.LineTo(LastMove.x, LastMove.y);
            inc(PointIdx, 3);
        end;
    end;
    end; 


  SetLength(FPathPoints, 0);
  SetLength(FPathTypes, 0);


    for y := 0 to GrayBmp.Height Div Scale -1 do
    begin
      DestScan := FMaskPathBmp.ScanLine[y];
      for x := 0 to GrayBmp.Width Div Scale -1 do
      begin
        tot := 0;

        for j := 0 to Scale - 1 do
        begin
          BigScan := pByteArray(GrayBmp.ScanLine[Scale * y + j] );
          for i := 0 to Scale -1 do
          begin
            tot := tot + BigScan[Scale * x+i];
          end;
        end;
        DestScan[x] := tot div (Scale * Scale);
      end;
    end;

{
  OldFont := GrayBmp.Canvas.Font.Handle;
  GrayBmp.Canvas.Font.Handle := 0;
  DeleteObject(OldFont);
}
    tracestring(':'+inttostr(timegettime-t1));


end;


function  TMaskFont.GetBits: pByteArray;
begin
//  DestScan := Image1.Picture.Bitmap.ScanLine[Image1.Picture.Bitmap.Height-1];  //取得图像缓冲区首地址
//  Integer(BitMap.ScanLine[0]) + FIX_WIDTH*3 为图像缓冲区结束地址
    Result := FMaskBmp.ScanLine[FMaskBmp.Height - 1];
end;

procedure TMaskFont.SetPixel(x, y: integer; color: integer);
begin
    GetBits^[x + (MaskBmp.Height - y -1) * BytesPerScanline(MaskBmp.Width, 8, 32)] := color;
end;
function  TMaskFont.GetPixel(x, y: integer): integer;
begin
    Result := GetBits^[(MaskBmp.Height - y -1) * BytesPerScanline(MaskBmp.Width, 8, 32) + x];
end;


end.
