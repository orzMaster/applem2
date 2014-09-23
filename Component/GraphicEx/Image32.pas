unit Image32;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, ToolWin, ImgList, GraphicEx, Jpeg,
  Buttons, Math, Trace, mmsystem;

const
    PixelCountMax = 32768;
    bias = $00800080;
    // Some predefined color constants



type
  TRGBQuad = packed record
    rgbBlue: BYTE;
    rgbGreen: BYTE;
    rgbRed: BYTE;
    rgbReserved: BYTE;
  end;


  PColor32 = ^TColor32;
  TColor32 = type Cardinal;

  PColor32Array = ^TColor32Array;
  TColor32Array = array [0..0] of TColor32;
  TArrayOfColor32 = array of TColor32;

  pRGBQuadArray = ^TRGBQuadArray;
  TRGBQuadArray = array[0..PixelCountMax - 1] of TRGBQuad;

  PRGBArray = ^TRGBArray;
  {* RGB数组指针}
  TRGBArray = array[0..8192] of tagRGBTriple;
  {* RGB数组类型}




  TGradualStyle = (gsLeftToRight, gsRightToLeft, gsTopToBottom, gsBottomToTop,
    gsCenterToLR, gsCenterToTB);
  {* 渐变方式类型
   |<PRE>
     gsLeftToRight      - 从左向右渐变
     gsRightToLeft      - 从右向左渐变
     gsTopToBottom      - 从上向下渐变
     gsBottomToTop      - 从下向上渐变
     gsCenterToLR       - 从中间向左右渐变
     gsCenterToTB       - 从中间向上下渐变
   |</PRE>}
  TTextureMode = (tmTiled, tmStretched, tmCenter, tmNormal);
  {* 纹理图像显示模式
   |<PRE>
     tmTiled            - 平铺显示
     tmStretched        - 自动缩放显示
     tmCenter           - 在中心位置显示
     tmNormal           - 在左上角显示
   |</PRE>}    


  function RedComponent(Color32: TColor32): Integer;
  function GreenComponent(Color32: TColor32): Integer;
  function BlueComponent(Color32: TColor32): Integer;
  function AlphaComponent(Color32: TColor32): Integer;
  function Intensity(Color32: TColor32): Integer;
  function RGBA(R, G, B: Byte; A: Byte = $FF): TColor32;
  function RGBAToColor32(RGBA: TRGBQuad): TColor32;
  function Color32ToRGBA(Color32: TColor32): TRGBQuad;

  { An analogue of FillChar for 32 bit values }
  procedure FillLongword(var X; Count: Integer; Value: Longword);

const
  clBlack32               : TColor32 = $FF000000;
  clDimGray32             : TColor32 = $FF3F3F3F;
  clGray32                : TColor32 = $FF7F7F7F;
  clLightGray32           : TColor32 = $FFBFBFBF;
  clWhite32               : TColor32 = $FFFFFFFF;
  clMaroon32              : TColor32 = $FF7F0000;
  clGreen32               : TColor32 = $FF007F00;
  clOlive32               : TColor32 = $FF7F7F00;
  clNavy32                : TColor32 = $FF00007F;
  clPurple32              : TColor32 = $FF7F007F;
  clTeal32                : TColor32 = $FF007F7F;
  clRed32                 : TColor32 = $FFFF0000;
  clLime32                : TColor32 = $FF00FF00;
  clYellow32              : TColor32 = $FFFFFF00;
  clBlue32                : TColor32 = $FF0000FF;
  clFuchsia32             : TColor32 = $FFFF00FF;
  clAqua32                : TColor32 = $FF00FFFF;

  // Some semi-transparent color constants
  clTrWhite32             : TColor32 = $7FFFFFFF;
  clTrBlack32             : TColor32 = $7F000000;
  clTrRed32               : TColor32 = $7FFF0000;
  clTrGreen32             : TColor32 = $7F00FF00;
  clTrBlue32              : TColor32 = $7F0000FF;      

type
  TBitmap32 = class(TBitmap)
  private

  protected
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;                //重载，设置为32位
    procedure LoadFromFile(const Filename: string); override;       //重载，设置为32位

// +++++++ //
    procedure CombineAlphaPixel(var pDest: TRGBQuad; cr1: TRGBQuad; nAlpha1: integer; cr2: TRGBQuad; nAlpha2: integer);
    procedure CombineAlphaPixel1(var pDest: TRGBQuad; cr1: TRGBQuad; nAlpha1: integer; cr2: TRGBQuad; nAlpha2: integer);
    function  GetBits: PColor32Array;
    procedure SetPixel(x, y: integer; color: TColor32);
    function  GetPixel(x, y: integer): TColor32;
    procedure  Clear(color: TColor32);overload;
    procedure  Clear(Bitmap: TBitmap; color: TColor32);overload;
    procedure  Clear;overload;    
    procedure  FillRect(X1, Y1, X2, Y2: Integer; Value: TColor32);


    procedure  SetAlphaChannels(Alpha: BYTE);overload;                              //设置透明通道
    procedure  SetAlphaChannels(Bitmap: TBitmap; Alpha: Byte);overload;
    procedure  SetAlphaChannels(Bitmap: TBitmap);overload;

    procedure DrawFrom(DstX, DstY: Integer; Src: TBitmap32);                //把图像写到自身
    procedure DrawTo(DstX, DstY: Integer; Tge: TBitmap32);overload;         //把自身写到图像
    procedure DrawTo(DstX, DstY: Integer; Tge: TBitmap);overload;


    procedure CreateGradual(Style: TGradualStyle; StartColor, EndColor: TColor);
    procedure DrawTiled(Canvas: TCanvas; Rect: TRect; G: TGraphic);
    procedure CreateForeBmp(Mode: TTextureMode; G: TGraphic; BkColor: TColor);

  end;

implementation

procedure FillLongword(var X; Count: Integer; Value: Longword);
asm
// EAX = X
// EDX = Count
// ECX = Value
        PUSH    EDI

        MOV     EDI,EAX  // Point EDI to destination              
        MOV     EAX,ECX
        MOV     ECX,EDX
        TEST    ECX,ECX
        JS      @exit

        REP     STOSD    // Fill count dwords
@exit:
        POP     EDI
end;

function RedComponent(Color32: TColor32): Integer;
begin
  Result := (Color32 and $00FF0000) shr 16;
end;

function GreenComponent(Color32: TColor32): Integer;
begin
  Result := (Color32 and $0000FF00) shr 8;
end;

function BlueComponent(Color32: TColor32): Integer;
begin
  Result := Color32 and $000000FF;
end;

function AlphaComponent(Color32: TColor32): Integer;
begin
  Result := Color32 shr 24;
end;

function Intensity(Color32: TColor32): Integer;
begin
// (R * 61 + G * 174 + B * 21) / 256
  Result := (
    (Color32 and $00FF0000) shr 16 * 61 +
    (Color32 and $0000FF00) shr 8 * 174 +
    (Color32 and $000000FF) * 21
    ) shr 8;
end;

function RGBA(R, G, B: Byte; A: Byte = $FF): TColor32;
begin
  Result := A shl 24 + R shl 16 + G shl 8 + B;
end;

function RGBAToColor32(RGBA: TRGBQuad): TColor32;
begin
  Result := RGBA.rgbReserved shl 24 + RGBA.rgbRed shl 16 + RGBA.rgbGreen shl 8 + RGBA.rgbBlue;
end;

function Color32ToRGBA(Color32: TColor32): TRGBQuad;
var
    RGBA: TRGBQuad;
begin
     RGBA.rgbRed := RedComponent(Color32);
     RGBA.rgbRed := GreenComponent(Color32);
     RGBA.rgbRed := BlueComponent(Color32);
     RGBA.rgbRed := AlphaComponent(Color32);
     Result := RGBA;
end;

constructor TBitmap32.Create;
begin
    inherited Create;
    PixelFormat := pf32bit;
end;

destructor TBitmap32.Destroy;
begin
    inherited Destroy;
end;

function TBitmap32.GetBits: PColor32Array;
begin
    Result := ScanLine[Height - 1];
end;

procedure TBitmap32.DrawFrom(DstX, DstY: Integer; Src: TBitmap32);
var
    x, y: integer;
    TR, SR: TRect;
    Source, Target: pRGBQuadArray;
begin

    TR := Rect(0, 0, Width, Height);
    SR := Rect(DstX, DstY, DstX + Src.Width, DstY + Src.Height);

    if IntersectRect(TR, TR, SR) = false then
    exit;

    for y := Tr.Top to Tr.Bottom - 1 do
    begin
        Source := Src.ScanLine[y - Dsty];
        Target := ScanLine[y];
        for x := TR.Left to Tr.Right - 1 do
        begin
            CombineAlphaPixel(Target^[x], Target^[x], Target^[x].rgbReserved, Source^[x - DstX], Source^[x- DstX].rgbReserved);
        end;
    end;
end;

procedure TBitmap32.DrawTo(DstX, DstY: Integer; Tge: TBitmap32);
var
    x, y: integer;
    TR, SR: TRect;
    Source, Target: pRGBQuadArray;
begin

    TR := Rect(0, 0, TGe.Width, Tge.Height);
    SR := Rect(DstX, DstY, DstX + Width, DstY + Height);

    if IntersectRect(TR, TR, SR) = false then
    exit;

    for y := Tr.Top to Tr.Bottom - 1 do
    begin
        Target := Tge.ScanLine[y];
        Source := ScanLine[y - Dsty];
        for x := TR.Left to Tr.Right - 1 do
        begin
            CombineAlphaPixel(Target^[x], Target^[x], Target^[x].rgbReserved, Source^[x - DstX], Source^[x- DstX].rgbReserved);
        end;
    end;

end;

procedure TBitmap32.DrawTo(DstX, DstY: Integer; Tge: TBitmap);
var
    x, y: integer;
    TR, SR: TRect;
    Source, Target: pRGBQuadArray;
begin
    Tge.PixelFormat := pf32bit;
    SetAlphaChannels(Tge, $FF);

    Tr := Rect(0, 0, Tge.Width, Tge.Height);
    SR := Rect(DstX, DstY, DstX + Width, DstY + Height);

    if IntersectRect(Tr, Tr, SR) = false then
    exit;

    for y := Tr.Top to Tr.Bottom - 1 do
    begin
        Target := Tge.ScanLine[y];
        Source := ScanLine[y - Dsty];
        for x := Tr.Left to Tr.Right - 1 do
        begin
            CombineAlphaPixel(Target^[x], Target^[x], Target^[x].rgbReserved, Source^[x - DstX], Source^[x- DstX].rgbReserved);
        end;
    end;

end;


procedure  TBitmap32.Clear(color: TColor32);
var
    x, y: integer;
begin
    FillLongword(GetBits^[0], Width * Height, Color);
end;


procedure TBitmap32.FillRect(X1, Y1, X2, Y2: Integer; Value: TColor32);
var
  j: Integer;
  P: PColor32Array;
begin
  for j := Y1 to Y2 - 1 do
  begin
    P := Pointer(ScanLine[j]);
    FillLongword(P[X1], X2 - X1, Value);
  end;
end;

procedure  TBitmap32.Clear(Bitmap: TBitmap; color: TColor32);
var
    bits: PColor32Array;
begin
    Bitmap.PixelFormat := pf32bit;
    bits := Bitmap.ScanLine[Bitmap.Height - 1];

    FillLongword(Bits^[0], Width * Height, Color);
  
end;

procedure TBitmap32.Clear;
begin
  Clear(clBlack32);
end;

procedure  TBitmap32.SetAlphaChannels(Alpha: BYTE);
var
    x, y: integer;
    SS: pRGBQuadArray;
begin
    for y := 0 to Height-1 do
    begin
        SS := ScanLine[y];
        for x := 0 to Width-1 do
        begin
            SS^[x].rgbReserved := Alpha;
        end;
    end;
end;
{
procedure  TBitmap32.SetAlphaChannels(Bitmap: TBitmap);
var
    x, y: integer;
    DS: pRGBQuadArray;
    SS: pByteArray;
begin
    for y := 0 to Height-1 do
    begin
        DS := ScanLine[y];
        SS := Bitmap.ScanLine[y];
        for x := 0 to Width-1 do
        begin
            DS^[x].rgbReserved := SS^[x];
        end;
    end;
end;
}
procedure  TBitmap32.SetAlphaChannels(Bitmap: TBitmap);
var
    x, y: integer;
    DS: pRGBQuadArray;
    SS: pByteArray;
    Bits1: pRGBQuadArray;
    Bits2: pByteArray;

begin
{    Bits1 := ScanLine[Height-1];
    Bits2 := Bitmap.ScanLine[Bitmap.height-1];

    for x := 0 to Width * Height-1 do
    begin
        Bits1^[x].rgbReserved := 1;
    end;
}


    for y := 0 to Height-1 do
    begin
        DS := ScanLine[y];
        SS := Bitmap.ScanLine[y];
        for x := 0 to Width-1 do
        begin
            DS^[x].rgbReserved := SS^[x];
        end;
    end;

end;



procedure  TBitmap32.SetAlphaChannels(Bitmap: TBitmap; Alpha: Byte);
var
    x, y: integer;
    SS: pRGBQuadArray;
begin
    for y := 0 to Bitmap.Height-1 do
    begin
        SS := Bitmap.ScanLine[Bitmap.Height - y -1];
        for x := 0 to Bitmap.Width-1 do
        begin
            SS^[x].rgbReserved := Alpha;
        end;
    end;
end;

procedure TBitmap32.SetPixel(x, y: integer; color: TColor32);
begin
    if (X >= 0) and (X < Width) and (Y >= 0) and (Y < Height) then
    GetBits^[x + (Height - y -1) * Width] := color;
end;

function  TBitmap32.GetPixel(x, y: integer): TColor32;
begin
    Result := $00000000;
    if (X >= 0) and (X < Width) and (Y >= 0) and (Y < Height) then
    Result :=  GetBits^[x + (Height - y -1) * Width];
end;

procedure TBitmap32.LoadFromFile(const Filename: string);
begin
    inherited LoadFromFile(FileName);
    PixelFormat := pf32bit;
end;

procedure TBitmap32.Assign(Source: TPersistent);
begin
    inherited Assign(Source);
    PixelFormat := pf32bit;
end;

//===================================================================
// 计算两个32bit象素的等效象素，这个函数非常重要(speed)，安全检查就不做了
// cr1：背景    cr2：前景

procedure  TBitmap32.CombineAlphaPixel(var pDest: TRGBQuad; cr1: TRGBQuad; nAlpha1: integer; cr2: TRGBQuad; nAlpha2: integer);
var
    nTmp1, nTmp12, nTemp, nTmp2: integer;
begin
	if ((nAlpha1 <> 0) or (nAlpha2 <> 0)) then
	begin
		if (nAlpha2 = 0) then
		begin
			pDest.rgbBlue  := cr1.rgbBlue ;
			pDest.rgbGreen := cr1.rgbGreen ;
			pDest.rgbRed  := cr1.rgbRed ;
			pDest.rgbReserved := nAlpha1 ;
			exit;
		end;
		if ((nAlpha1 = 0) or (nAlpha2 = $FF)) then
		begin
			pDest.rgbBlue  := cr2.rgbBlue ;
			pDest.rgbGreen := cr2.rgbGreen ;
			pDest.rgbRed   := cr2.rgbRed ;
			pDest.rgbReserved := nAlpha2 ;
			exit;
        end;


		// 以下用不着判断[0,0xFF]，我验算过了
		nTmp1 := $FF * nAlpha1;
        nTmp2 := $FF * nAlpha2 ;
		nTmp12 := nAlpha1 * nAlpha2;
		nTemp  := nTmp1 + nTmp2 - nTmp12 ;
		pDest.rgbBlue  := (nTmp2 * cr2.rgbBlue  + (nTmp1 - nTmp12) * cr1.rgbBlue)  div nTemp ;
		pDest.rgbGreen := (nTmp2 * cr2.rgbGreen + (nTmp1 - nTmp12) * cr1.rgbGreen) div nTemp ;
		pDest.rgbRed   := (nTmp2 * cr2.rgbRed   + (nTmp1 - nTmp12) * cr1.rgbRed)   div nTemp ;
		pDest.rgbReserved := nTemp div $FF ;


//		下面的代码是未优化过的，可读性更好些
{
		nTemp :=  $FF * (nAlpha1 + nAlpha2) - nAlpha1*nAlpha2 ;
		pDest.rgbBlue  := min($FF, ($FF * cr2.rgbBlue  * nAlpha2 + ($FF - nAlpha2) * cr1.rgbBlue  * nAlpha1) div nTemp) ;
		pDest.rgbGreen := min($FF, ($FF * cr2.rgbGreen * nAlpha2 + ($FF - nAlpha2) * cr1.rgbGreen * nAlpha1) div nTemp) ;
		pDest.rgbRed   := min($FF, ($FF * cr2.rgbRed   * nAlpha2 + ($FF - nAlpha2) * cr1.rgbRed   * nAlpha1) div nTemp) ;
		pDest.rgbReserved := nTemp div $FF ;
}
	end
	else
	begin
		pDest.rgbBlue  := $FF;
        pDest.rgbGreen := $FF;
        pDest.rgbRed   := $FF;
		pDest.rgbReserved := 0 ;
	end;
end;

//===================================================================
// 计算两个32bit象素的等效象素，这个函数非常重要(speed)，安全检查就不做了
// cr1：背景    cr2：前景

//截断函数
function Bound(x, a, b:integer): integer;
begin
    if x < a then
    begin
        Result := a;
    end
    else
    begin
        if x>b then
        begin
            Result := b;
        end
        else
            Result := x;
    end;
end;
//#define BOUND(x,a,b) (((x) < (a)) ? (a) : (((x) > (b)) ? (b) : (x)))

procedure  TBitmap32.CombineAlphaPixel1(var pDest: TRGBQuad; cr1: TRGBQuad; nAlpha1: integer; cr2: TRGBQuad; nAlpha2: integer);
var
    nTmp1, nTmp12, nTemp, nTmp2: integer;
    r, g,b:integer;
begin
	if ((nAlpha1 <> 0) or (nAlpha2 <> 0)) then
	begin
		if (nAlpha2 = 0) then
		begin
			pDest.rgbBlue  := cr1.rgbBlue ;
			pDest.rgbGreen := cr1.rgbGreen ;
			pDest.rgbRed  := cr1.rgbRed ;
			pDest.rgbReserved := nAlpha1 ;
			exit;
		end;
		if ((nAlpha1 = 0) or (nAlpha2 = $FF)) then
		begin
			pDest.rgbBlue  := cr2.rgbBlue ;
			pDest.rgbGreen := cr2.rgbGreen ;
			pDest.rgbRed   := cr2.rgbRed ;
			pDest.rgbReserved := nAlpha2 ;
			exit;
        end;
		// 以下用不着判断[0,0xFF]，我验算过了
{
        nTmp1 := $FF * nAlpha1;
        nTmp2 := $FF * nAlpha2 ;
		nTmp12 := nAlpha1 * nAlpha2;
		nTemp  := nTmp1 + nTmp2 - nTmp12 ;
		pDest.rgbBlue  := (nTmp2 * cr2.rgbBlue  + (nTmp1 - nTmp12) * cr1.rgbBlue)  div nTemp ;
		pDest.rgbGreen := (nTmp2 * cr2.rgbGreen + (nTmp1 - nTmp12) * cr1.rgbGreen) div nTemp ;
		pDest.rgbRed   := (nTmp2 * cr2.rgbRed   + (nTmp1 - nTmp12) * cr1.rgbRed)   div nTemp ;
		pDest.rgbReserved := nTemp div $FF ;
}

		nTemp :=  $FF * (nAlpha1 + nAlpha2) - nAlpha1*nAlpha2 ;
		pDest.rgbBlue  := min($FF, ($FF * cr2.rgbBlue  * nAlpha2 + $FF * cr1.rgbBlue  * nAlpha1 - nAlpha2 * cr1.rgbBlue  * nAlpha1) div nTemp) ;
		pDest.rgbGreen := min($FF, ($FF * cr2.rgbGreen * nAlpha2 + $FF * cr1.rgbGreen  * nAlpha1 - nAlpha2 * cr1.rgbGreen  * nAlpha1) div nTemp) ;
		pDest.rgbRed   := min($FF, ($FF * cr2.rgbRed  * nAlpha2 + $FF * cr1.rgbRed  * nAlpha1 - nAlpha2 * cr1.rgbRed  * nAlpha1) div nTemp) ;
		pDest.rgbReserved := nTemp div $FF ;


//		下面的代码是未优化过的，可读性更好些
{
		nTemp :=  $FF * (nAlpha1 + nAlpha2) - nAlpha1*nAlpha2 ;
		pDest.rgbBlue  := min($FF, ($FF * cr2.rgbBlue  * nAlpha2 + ($FF - nAlpha2) * cr1.rgbBlue  * nAlpha1) div nTemp) ;
		pDest.rgbGreen := min($FF, ($FF * cr2.rgbGreen * nAlpha2 + ($FF - nAlpha2) * cr1.rgbGreen * nAlpha1) div nTemp) ;
		pDest.rgbRed   := min($FF, ($FF * cr2.rgbRed   * nAlpha2 + ($FF - nAlpha2) * cr1.rgbRed   * nAlpha1) div nTemp) ;
		pDest.rgbReserved := nTemp div $FF ;
}
	end
	else
	begin
		pDest.rgbBlue  := $FF;
        pDest.rgbGreen := $FF;
        pDest.rgbRed   := $FF;
		pDest.rgbReserved := 0 ;
	end;
end;

procedure StrectchDrawGraphic(ACanvas: TCanvas; ARect: TRect; AGraphic: TGraphic;
  BkColor: TColor);
var
  Bmp: TBitmap;
begin
  if AGraphic is TIcon then
  begin
    // TIcon 不支持缩放绘制，通过 TBitmap 中转
    Bmp := TBitmap.Create;
    try
      Bmp.Canvas.Brush.Color := BkColor;
      Bmp.Canvas.Brush.Style := bsSolid;
      Bmp.Width := AGraphic.Width;
      Bmp.Height := AGraphic.Height;
      //Bmp.Canvas.FillRect(Rect(0, 0, Bmp.Width, Bmp.Height));
      Bmp.Canvas.Draw(0, 0, AGraphic);
      ACanvas.StretchDraw(ARect, Bmp);
    finally
      Bmp.Free;
    end;
  end
  else
    ACanvas.StretchDraw(ARect, AGraphic);
end;

//绘制平铺图
procedure TBitmap32.DrawTiled(Canvas: TCanvas; Rect: TRect; G: TGraphic);
var
  R, Rows, C, Cols: Integer;
begin
  if (G <> nil) and (not G.Empty) then
  begin
    Rows := ((Rect.Bottom - Rect.Top) div G.Height) + 1;
    Cols := ((Rect.Right - Rect.Left) div G.Width) + 1;
    for R := 1 to Rows do
      for C := 1 to Cols do
        Canvas.Draw(Rect.Left + (C - 1) * G.Width, Rect.Top + (R - 1) * G.Height, G);
  end;
end;


//创建纹理图

procedure TBitmap32.CreateForeBmp(Mode: TTextureMode; G: TGraphic; BkColor: TColor);
begin

    PixelFormat := pf24bit;

  Canvas.Brush.Color := Canvas.Font.Color;
  Canvas.Brush.Style := bsSolid;
  Canvas.FillRect(Rect(0, 0, Width, Height));
  case Mode of
    tmTiled:                            //平铺
        DrawTiled(Canvas, Rect(0, 0, Width, Height), G);
    tmStretched:                        //拉伸
        StrectchDrawGraphic(Canvas, Rect(0, 0, Width, Height), G, Canvas.Font.Color);
    tmCenter:                           //中心
        Canvas.Draw((Width - G.Width) div 2, (Height - G.Height) div 2, G);
    tmNormal:                           //普通
        Canvas.Draw(0, 0, G);
  end;
    PixelFormat := pf32bit;
end;

//创建渐变色前景
procedure TBitmap32.CreateGradual(Style: TGradualStyle; StartColor, EndColor: TColor);
var
  Buf, Dst: PRGBArray;
  BufLen, Len: Integer;
  SCol, ECol: TColor;
  sr, sb, sg: Byte;
  er, eb, eg: Byte;
  BufSize: Integer;
  i, j: Integer;
begin
    PixelFormat := pf24bit;

  if Style in [gsLeftToRight, gsRightToLeft, gsCenterToLR] then
    BufLen := Width                     // 缓冲区长度
  else
    BufLen := Height;
  if Style in [gsCenterToLR, gsCenterToTB] then
    Len := (BufLen + 1) div 2           // 渐变带长度
  else
    Len := BufLen;
  BufSize := BufLen * 3;
  GetMem(Buf, BufSize);
  try
    // 创建渐变色带缓冲区
    if Style in [gsLeftToRight, gsTopToBottom] then
    begin
      SCol := ColorToRGB(StartColor);
      ECol := ColorToRGB(EndColor);
    end
    else begin
      SCol := ColorToRGB(EndColor);
      ECol := ColorToRGB(StartColor);
    end;
    sr := GetRValue(SCol);              //起始色
    sg := GetGValue(SCol);
    sb := GetBValue(SCol);
    er := GetRValue(ECol);              //结束色
    eg := GetGValue(ECol);
    eb := GetBValue(ECol);
    for i := 0 to Len - 1 do
    begin
      Buf[i].rgbtRed := sr + (er - sr) * i div Len;
      Buf[i].rgbtGreen := sg + (eg - sg) * i div Len;
      Buf[i].rgbtBlue := sb + (eb - sb) * i div Len;
    end;

    if Style in [gsCenterToLR, gsCenterToTB] then // 对称渐变
      for i := 0 to Len - 1 do
        Buf[BufLen - 1 - i] := Buf[i];

    if Style in [gsLeftToRight, gsRightToLeft, gsCenterToLR] then
      for i := 0 to Height - 1 do  // 水平渐变
        Move(Buf[0], ScanLine[Height - i - 1]^, BufSize)
    else
      for i := 0 to Height - 1 do  // 垂直渐变
      begin
        Dst := ScanLine[Height - i - 1];
        for j := 0 to Width - 1 do
          Dst^[j] := Buf[i];
      end;
  finally
    FreeMem(Buf);
  end;

      PixelFormat := pf32bit;
end;

end.
