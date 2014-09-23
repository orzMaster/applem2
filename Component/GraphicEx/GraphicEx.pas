unit GraphicEx;

// GraphicEx -
//   This unit is an extension of Graphics.pas, in order to
//   import other graphic files than those Delphi allows.
//
//   Currently supported image file types are:
//     - TIFF images (*.tif; *.tiff), base line implementation, 8 and 16 bits per channel
//       + byte order: little endian, big endian
//       + color spaces:
//         + B&W (uncompressed, packed bits)
//         + 256 colors with palette (uncompressed, LZW, packed bits)
//         + 4, 8 and 16 bit gray scale (uncompressed, LZW, packed bits)
//         + CMYK (uncompressed, LZW)
//         + L*a*b* (uncompressed, LZW)
//         + RGB (uncompressed, LZW)
//         + RGBA (uncompressed, LZW)
//     - SGI images (*.bw, *.rgb, *.rgba, *.sgi), 8 and 16 bit per channel
//       + byte order: big endian
//       + color spaces: B&W, 8 bit grayscale, RGB, RGBA (uncompressed, RLE)
//     - Autodesk images (*.cel, *.pic)
//       + color spaces: 256 colors (uncompressed)
//     - Truevision images (*.tga; *.vst; *.icb; *.vda; *.win) write support included
//       + color spaces: B&W, 256 colors, RGB, RGBA (uncompressed, RLE)
//     - ZSoft Paintbrush images (*.pcx, *.pcc)
//       + color spaces: B&W, 16 colors, 256 colors, RGB, gray scale (uncompressed, RLE)
//     - Word 5.x screen capture files (*.scr)
//       + color spaces: B&W, 16 colors, 256 colors, RGB, gray scale (uncompressed, RLE)
//     - Kodak Photo-CD images (*.pcd)
//       + sizes: Base16, Base4, Base
//       + orientations: landscape, portrait
//       + flipped, not flipped
//     - Portable pixel/gray map images (*.ppm, *.pgm, *.pbm)
//       + color spaces: B&W, gray scale, RGB (uncompressed)
//       + ASCII and Binary format
//     - Dr. Halo images (*.cut, *.pal)
//       + color spaces: 256 colors (RLE)
//       + external palette file (*.pal) is automatically loaded when specified while doing LoadFromStream
//         or when loading the image via LoadFromFile
//     - CompuServe images (*.gif)
//       + color spaces: B&W, 16 colors, 256 colors (LZW)
//       + interlaced, non-interlaced
//     - SGI Wavefront images (*.rla, *.rpf)
//       + color spaces: RGB(A) (RLE)
//     - Windows bitmaps (*.rle, *.dib)
//       these images are just different named *.bmp files
//     - Photoshop images (*.psd, *.pdd)
//       + byte order: big endian
//       + sample size: 1, 8 and 16 bits
//       + color spaces: B&W, 256 colors, RGB, CMYK, CIE L*a*b*, duo tone (uncompressed, packed bits)
//
//   Additionally, there are some support routines to manipulate images.
//
// version - 7.1
//
// 15-APR-2000 ml:
//   - PSD, GIF palette bug removed, GIF improved, GIF more error tolerant in decoding
//   - registration of DIB and RLE (can be loaded with TBitmap, Why aren't those types registered?)
// 13-APR-2000 ml:
//  Photoshop PSD
// 11-APR-2000 ml:
//   SGI 16 bits per sample bug fix
// 10-APR-2000 ml:
//   LZW decoder bugfix, TIFF palette bug fix, missing unregistration fix
// 09-APR-2000 ml:
//   RLA
// 07-APR-2000 ml:
//   PPM, PGM, GIF
// 06-APR-2000 ml:
//   SGI, PPM
// 05-APR-2000 ml:
//   SGI image class
// 03-APR-2000 ml:
//   bug fixes, SGI class restructured and improved
// 31-MAR-2000 ml:
//   test implementations for YCbCr color space and CCITT G3 compression didn't work (in particular CCITT is very strange
//   as I have tried 3 different approaches which all failed, so I must be doing something very wrong, can anybody help?)
// 26-MAR-2000 ml:
//   PCX format finished, PCD format implemented
// 25-MAR-2000 ml:
//   totally rewritten TIFF LZW decompression (much faster and really working now), bug fixes,
//   PCX/PCC format
// 19-MAR-2000 ml:
//   TIFF restructuring, packed bits encoding, CMYK color scheme
// 18-MAR-2000 ml:
//   TIFF complete restructuring
// 15-MAR-2000 ml:
//   prediction schemes in TIFF files, CMYK TIFF files
// 10-MAR-2000 ml:
//   little/big endian TIFF file support
// 12-FEB-2000 ml:
//   weight averaging in ApplyContributors
// 01-NOV-1999 ml:
//   implementation so far
//
// Note: The library provides usually only load support for the listed image formats but will perhaps be enhanced
//       in the future to save those types too.
//
// (c) Copyright 1999, 2000  Dipl. Ing. Mike Lischke (public@lischke-online.de)

{$R-}

interface

uses
  Windows, Classes, ExtCtrls, Graphics, SysUtils, JPEG, GraphicCompression, Trace;

type
  TCardinalArray = array of Cardinal;

  // *.bw, *.rgb, *.rgba, *.sgi images
  TSGIGraphic = class(TBitmap)
  private
    FStartPosition: Cardinal;
    FRowStart,               
    FRowSize: TCardinalArray;    // start and length of a line (if compressed)
    FRowBuffer: Pointer;         // buffer to hold one line while loading
    FStream: TStream;            // intermediate variable to avoid passing it to ReadAndDecode all the time
    FDecoder: TDecoder;          // ...same applies here
    FSampleSize: Byte;           // ... and here
    procedure ReadAndDecode(Red, Green, Blue, Alpha: PByte; Row, BPC: Integer);
  public
    procedure LoadFromStream(Stream: TStream); override;
  end;

  // *.cel, *.pic images
  TAutodeskGraphic = class(TBitmap)
  public
    procedure LoadFromStream(Stream: TStream); override;
  end;

  // *.tif, *.tiff images
  TTIFFHeader = packed record
    ByteOrder: Word;
    Version: Word;
    FirstIFD: Cardinal;
  end;

  // one entry in a an IFD (image file directory)
  TIFDEntry = packed record
    Tag: Word;
    DataType: Word;
    DataLength: Cardinal;
    Offset: Cardinal;
  end;

  TTIFFPalette = array[0..787] of Word;

  TTIFFGraphic = class(TBitmap)
  private
    FHeader: TTIFFHeader;
    FIFD: array of TIFDEntry; // the tags of one (the first) image file directory
    FBasePosition: Cardinal;
    FInternalPalette: Integer;
    FPalette: TTIFFPalette;
    function FindIFD(Tag: Cardinal; var Index: Cardinal): Boolean;
    procedure GetValueList(Stream: TStream; Tag: Cardinal; var Values: TCardinalArray);
    function GetValue(Tag: Cardinal; Default: Cardinal = 0): Cardinal;
    function GetValueLength(Tag: Cardinal; Default: Cardinal = 1): Cardinal;
    procedure MakePalette(BPS: Byte; Mode: Integer);
    procedure SwapIFD;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure SaveToTifFile(FileName: String; Compressing: Boolean);
    procedure LoadFromStream(Stream: TStream); override;
    // override inherited SaveToStream method...
    procedure SaveToStream(Stream: TStream); overload; override;
    // ...and introduce new SaveToStream method with an additional parameter
//    procedure SaveToStream(Stream: TStream; Compressed: Boolean); reintroduce; overload;
  end;

  // *.tga; *.vst; *.icb; *.vda; *.win images
  TTargaGraphic = class(TBitmap)
  private
    FImageID: String;
   public
    procedure LoadFromResourceName(Instance: THandle; const ResName: String);
    procedure LoadFromResourceID(Instance: THandle; ResID: Integer);
    procedure LoadFromStream(Stream: TStream); override;
    // override inherited SaveToStream method...
    procedure SaveToStream(Stream: TStream); overload; override;
    // ...and introduce new SaveToStream method with an additional parameter
    procedure SaveToStream(Stream: TStream; Compressed: Boolean); reintroduce; overload;

    property ImageID: String read FImageID write FImageID;
  end;

  // *.pcx; *.pcc; *.scr images
  // Note: Due to the badly designed format a PCX/SCR file cannot be part in a larger stream because the position of the
  //       color palette as well as the decoding size can only be determined by the size of the image.
  //       Hence the image must be the only one in the stream or the last one.
  TPCXGraphic = class(TBitmap)
  private
  public
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
  end;

  // *.pcd images
  TPCDResolution = (pcdBase16, pcdBase4, pcdBase, pcd4Base, pcd16Base, pcd64Base);

  // Note: By default the BASE resolution of a PCD image is loaded with LoadFromStream. You can override this
  //       behaviour by explicitly creating the TPCDGraphic class and set its Resolution property to whatever you like.
  //       Keep in mind only the 3 lowest resolutions are supported currently (Base16, Base4 and Base).
  TPCDGraphic = class(TBitmap)
  private
    FBasePosition: Cardinal;
    FResolution: TPCDResolution;
  public
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;

    property Resolution: TPCDResolution read FResolution write FResolution default pcdBase;
  end;

  // *.ppm, *.pgm, *.pbm images
  TPPMGraphic = class(TBitmap)
  private
    FStream: TStream;
    FBuffer: array[0..4095] of Char;
    FIndex: Integer;
    procedure CreateGrayScalePalette(BW: Boolean);
    function CurrentChar: Char;
    function GetChar: Char;
    function GetNumber: Cardinal;
    function ReadLine: String;
  public
    procedure LoadFromStream(Stream: TStream); override;
  end;

  // *.cut (+ *.pal) images
  // Note: Also this format should not be used in a stream unless it is the only image or the last one!
  TCUTGraphic = class(TBitmap)
  private
    FPaletteFile: String;
  protected
    procedure LoadPalette;
  public
    procedure LoadFromFile(const FileName: String); override;
    procedure LoadFromStream(Stream: TStream); override;

    property PaletteFile: String read FPaletteFile write FPaletteFile;
  end;

  TGIFGraphic = class(TBitmap)
  public
    procedure LoadFromStream(Stream: TStream); override;
  end;

  // implementation based on code from Dipl. Ing. Ingo Neumann (ingo@upstart.de, ingo_n@dialup.nacamar.de)
  TRLAGraphic = class(TBitmap)
  private
    procedure SwapHeader(var Header); // start position of the image header in the stream
  public
    procedure LoadFromStream(Stream: TStream); override;
  end;

  TPSDGraphic = class(TBitmap)
  private
    FPalette: array[0..767] of Byte;
    procedure MakePalette(BPS: Byte; Mode: Integer);
  public
    procedure LoadFromStream(Stream: TStream); override;
  end;

  // resampling support types
  TResamplingFilter = (sfBox, sfTriangle, sfHermite, sfBell, sfSpline, sfLanczos3, sfMitchell);

// Resampling support routines
procedure Stretch(NewWidth, NewHeight: Cardinal; Filter: TResamplingFilter; Radius: Single; Source, Target: TBitmap); overload;
procedure Stretch(NewWidth, NewHeight: Cardinal; Filter: TResamplingFilter; Radius: Single; Source: TBitmap); overload;

//----------------------------------------------------------------------------------------------------------------------

implementation

uses
  Consts, Dialogs, Math;

type
  // resampling support types
  TRGBInt = record
   R, G, B: Integer;
  end;

  PRGBWord = ^TRGBWord;
  TRGBWord = record
   R, G, B: Word;
  end;

  PRGBAWord = ^TRGBAWord;
  TRGBAWord = record
   R, G, B, A: Word;
  end;

  PBGR = ^TBGR;
  TBGR = packed record
   B, G, R: Byte;
  end;

  PBGRA = ^TBGRA;
  TBGRA = packed record
   B, G, R, A: Byte;
  end;

  PRGB = ^TRGB;
  TRGB = packed record
   R, G, B: Byte;
  end;

  PRGBA = ^TRGBA;
  TRGBA = packed record
   R, G, B, A: Byte;
  end;

  PPixelArray = ^TPixelArray;
  TPixelArray = array[0..0] of TBGR;

  TFilterFunction = function(Value: Single): Single;

  // contributor for a Pixel
  PContributor = ^TContributor;
  TContributor = record
   Weight: Integer; // Pixel Weight
   Pixel: Integer; // Source Pixel
  end;

  TContributors = array of TContributor;

  // list of source pixels contributing to a destination pixel
  TContributorEntry = record
   N: Integer;
   Contributors: TContributors;
  end;

  TContributorList = array of TContributorEntry;

const
  DefaultFilterRadius: array[TResamplingFilter] of Single = (0.5, 1, 1, 1.5, 2, 3, 2);

threadvar // globally used cache for current image (speeds up resampling about 10%)
  CurrentLineR: array of Integer;
  CurrentLineG: array of Integer;
  CurrentLineB: array of Integer;

//----------------- helper functions -----------------------------------------------------------------------------------

function IntToByte(Value: Integer): Byte;

begin
  Result := Max(0, Min(255, Value));
end;

//----------------- filter functions for stretching --------------------------------------------------------------------

function HermiteFilter(Value: Single): Single;

// f(t) = 2|t|^3 - 3|t|^2 + 1, -1 <= t <= 1

begin
  if Value < 0 then Value := -Value;
  if Value < 1 then Result := (2 * Value - 3) * Sqr(Value) + 1
               else Result := 0;
end;

//----------------------------------------------------------------------------------------------------------------------

function BoxFilter(Value: Single): Single;

// This filter is also known as 'nearest neighbour' Filter.

begin
  if (Value > -0.5) and (Value <= 0.5) then Result := 1
                                       else Result := 0;
end;

//----------------------------------------------------------------------------------------------------------------------

function TriangleFilter(Value: Single): Single;

// aka 'linear' or 'bilinear' filter

begin
  if Value < 0 then Value := -Value;
  if Value < 1 then Result := 1 - Value
               else Result := 0;
end;

//----------------------------------------------------------------------------------------------------------------------

function BellFilter(Value: Single): Single;

begin
  if Value < 0 then Value := -Value;
  if Value < 0.5 then Result := 0.75 - Sqr(Value)
                 else
    if Value < 1.5 then
    begin
      Value := Value - 1.5;
      Result := 0.5 * Sqr(Value);
    end
    else Result := 0;
end;

//----------------------------------------------------------------------------------------------------------------------

function SplineFilter(Value: Single): Single;

// B-spline filter

var
  Temp: Single;

begin
  if Value < 0 then Value := -Value;
  if Value < 1 then
  begin
    Temp := Sqr(Value);
    Result := 0.5 * Temp * Value - Temp + 2 / 3;
  end
  else
    if Value < 2 then
    begin
      Value := 2 - Value;
      Result := Sqr(Value) * Value / 6;
    end
    else Result := 0;
end;

//----------------------------------------------------------------------------------------------------------------------

function Lanczos3Filter(Value: Single): Single;

  //--------------- local function --------------------------------------------

  function SinC(Value: Single): Single;

  begin
    if Value <> 0 then
    begin
      Value := Value * Pi;
      Result := Sin(Value) / Value;
    end
    else Result := 1;
  end;

  //---------------------------------------------------------------------------

begin
  if Value < 0 then Value := -Value;
  if Value < 3 then Result := SinC(Value) * SinC(Value / 3)
               else Result := 0;
end;

//----------------------------------------------------------------------------------------------------------------------

function MitchellFilter(Value: Single): Single;

const
  B = 1 / 3;
  C = 1 / 3;

var Temp: Single;

begin
  if Value < 0 then Value := -Value;
  Temp := Sqr(Value);
  if Value < 1 then
  begin
    Value := (((12 - 9 * B - 6 * C) * (Value * Temp))
             + ((-18 + 12 * B + 6 * C) * Temp)
             + (6 - 2 * B));
    Result := Value / 6;
  end
  else
    if Value < 2 then
    begin
      Value := (((-B - 6 * C) * (Value * Temp))
               + ((6 * B + 30 * C) * Temp)
               + ((-12 * B - 48 * C) * Value)
               + (8 * B + 24 * C));
      Result := Value / 6;
    end
    else Result := 0;
end;

//----------------------------------------------------------------------------------------------------------------------

const
  FilterList: array[TResamplingFilter] of TFilterFunction = (
    BoxFilter,
    TriangleFilter,
    HermiteFilter,
    BellFilter,
    SplineFilter,
    Lanczos3Filter,
    MitchellFilter
  );

//----------------------------------------------------------------------------------------------------------------------

procedure FillLineChache(N, Delta: Integer; Line: Pointer);

var
  I: Integer;
  Run: PBGR;

begin
  Run := Line;
  for I := 0 to N - 1 do
  begin
    CurrentLineR[I] := Run.R;
    CurrentLineG[I] := Run.G;
    CurrentLineB[I] := Run.B;
    Inc(PByte(Run), Delta);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function ApplyContributors(N: Integer; Contributors: TContributors): TBGR;

var
  J: Integer;
  RGB: TRGBInt;
  Total,
  Weight: Integer;
  Pixel: Cardinal;
  Contr: ^TContributor;
    
begin
  RGB.R := 0;
  RGB.G := 0;
  RGB.B := 0;
  Total := 0;
  Contr := @Contributors[0];
  for J := 0 to N - 1 do
  begin
    Weight := Contr.Weight;
    Inc(Total, Weight);
    Pixel := Contr.Pixel;
    Inc(RGB.r, CurrentLineR[Pixel] * Weight);
    Inc(RGB.g, CurrentLineG[Pixel] * Weight);
    Inc(RGB.b, CurrentLineB[Pixel] * Weight);

    Inc(Contr);
  end;

  if Total = 0 then
  begin
    Result.R := IntToByte(RGB.R shr 8);
    Result.G := IntToByte(RGB.G shr 8);
    Result.B := IntToByte(RGB.B shr 8);
  end
  else
  begin
    Result.R := IntToByte(RGB.R div Total);
    Result.G := IntToByte(RGB.G div Total);
    Result.B := IntToByte(RGB.B div Total);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure DoStretch(Filter: TFilterFunction; Radius: Single; Source, Target: TBitmap);

// This is the actual scaling routine. Target must be allocated already with sufficient size. Source must
// contain valid data, Radius must not be 0 and Filter must not be nil.

var
  ScaleX,
  ScaleY: Single;  // Zoom scale factors
  I, J,
  K, N: Integer; // Loop variables
  Center: Single; // Filter calculation variables
  Width: Single;
  Weight: Integer;  // Filter calculation variables
  Left,
  Right: Integer; // Filter calculation variables
  Work: TBitmap;
  ContributorList: TContributorList;
  SourceLine,
  DestLine: PPixelArray;
  DestPixel: PBGR;
  Delta,
  DestDelta: Integer;
  SourceHeight,
  SourceWidth,
  TargetHeight,
  TargetWidth: Integer;

begin
  // shortcut variables
  SourceHeight := Source.Height;
  SourceWidth := Source.Width;
  TargetHeight := Target.Height;
  TargetWidth := Target.Width;
  // create intermediate image to hold horizontal zoom
  Work := TBitmap.Create;
  try
    Work.PixelFormat := pf24Bit;
    Work.Height := SourceHeight;
    Work.Width := TargetWidth;
    if SourceWidth = 1 then ScaleX :=  TargetWidth / SourceWidth
                       else ScaleX :=  (TargetWidth - 1) / (SourceWidth - 1);
    if SourceHeight = 1 then ScaleY :=  TargetHeight / SourceHeight
                        else ScaleY :=  (TargetHeight - 1) / (SourceHeight - 1);

    // pre-calculate filter contributions for a row
    SetLength(ContributorList, TargetWidth);
    // horizontal sub-sampling
    if ScaleX < 1 then
    begin
      // scales from bigger to smaller Width
      Width := Radius / ScaleX;
      for I := 0 to TargetWidth - 1 do
      begin
        ContributorList[I].N := 0;
        SetLength(ContributorList[I].Contributors, Trunc(2 * Width + 1));
        Center := I / ScaleX;
        Left := Floor(Center - Width);
        Right := Ceil(Center + Width);
        for J := Left to Right do
        begin
          Weight := Round(Filter((Center - J) * ScaleX) * ScaleX * 256);
          if Weight <> 0 then
          begin
            if J < 0 then N := -J
                     else
              if J >= SourceWidth then N := SourceWidth - J + SourceWidth - 1
                                  else N := J;
            K := ContributorList[I].N;
            Inc(ContributorList[I].N);
            ContributorList[I].Contributors[K].Pixel := N;
            ContributorList[I].Contributors[K].Weight := Weight;
          end;
        end;
      end;
    end
    else
    begin
      // horizontal super-sampling
      // scales from smaller to bigger Width
      for I := 0 to TargetWidth - 1 do
      begin
        ContributorList[I].N := 0;
        SetLength(ContributorList[I].Contributors, Trunc(2 * Radius + 1));
        Center := I / ScaleX;
        Left := Floor(Center - Radius);
        Right := Ceil(Center + Radius);
        for J := Left to Right do
        begin
          Weight := Round(Filter(Center - J) * 256);
          if Weight <> 0 then
          begin
            if J < 0 then N := -J
                     else
             if J >= SourceWidth then N := SourceWidth - J + SourceWidth - 1
                                 else N := J;
            K := ContributorList[I].N;
            Inc(ContributorList[I].N);
            ContributorList[I].Contributors[K].Pixel := N;
            ContributorList[I].Contributors[K].Weight := Weight;
          end;
        end;
      end;
    end;

    // now apply filter to sample horizontally from Src to Work
    SetLength(CurrentLineR, SourceWidth);
    SetLength(CurrentLineG, SourceWidth);
    SetLength(CurrentLineB, SourceWidth);
    for K := 0 to SourceHeight - 1 do
    begin
      SourceLine := Source.ScanLine[K];
      FillLineChache(SourceWidth, 3, SourceLine);
      DestPixel := Work.ScanLine[K];
      for I := 0 to TargetWidth - 1 do
        with ContributorList[I] do
        begin
          DestPixel^ := ApplyContributors(N, ContributorList[I].Contributors);
          // move on to next column
          Inc(DestPixel);
        end;
    end;

    // free the memory allocated for horizontal filter weights, since we need the stucture again
    for I := 0 to TargetWidth - 1 do ContributorList[I].Contributors := nil;
    ContributorList := nil;

    // pre-calculate filter contributions for a column
    SetLength(ContributorList, TargetHeight);
    // vertical sub-sampling
    if ScaleY < 1 then
    begin
      // scales from bigger to smaller height
      Width := Radius / ScaleY;
      for I := 0 to TargetHeight - 1 do
      begin
        ContributorList[I].N := 0;
        SetLength(ContributorList[I].Contributors, Trunc(2 * Width + 1));
        Center := I / ScaleY;
        Left := Floor(Center - Width);
        Right := Ceil(Center + Width);
        for J := Left to Right do
        begin
          Weight := Round(Filter((Center - J) * ScaleY) * ScaleY * 256);
          if Weight <> 0 then
          begin
            if J < 0 then N := -J
                     else
              if J >= SourceHeight then N := SourceHeight - J + SourceHeight - 1
                                   else N := J;
            K := ContributorList[I].N;
            Inc(ContributorList[I].N);
            ContributorList[I].Contributors[K].Pixel := N;
            ContributorList[I].Contributors[K].Weight := Weight;
          end;
        end;
      end
    end
    else
    begin
      // vertical super-sampling
      // scales from smaller to bigger height
      for I := 0 to TargetHeight - 1 do
      begin
        ContributorList[I].N := 0;
        SetLength(ContributorList[I].Contributors, Trunc(2 * Radius + 1));
        Center := I / ScaleY;
        Left := Floor(Center - Radius);
        Right := Ceil(Center + Radius);
        for J := Left to Right do
        begin
          Weight := Round(Filter(Center - J) * 256);
          if Weight <> 0 then
          begin
            if J < 0 then N := -J
                     else
              if J >= SourceHeight then N := SourceHeight - J + SourceHeight - 1
                                   else N := J;
            K := ContributorList[I].N;
            Inc(ContributorList[I].N);
            ContributorList[I].Contributors[K].Pixel := N;
            ContributorList[I].Contributors[K].Weight := Weight;
          end;
        end;
      end;
    end;

    // apply filter to sample vertically from Work to Target
    SetLength(CurrentLineR, SourceHeight);
    SetLength(CurrentLineG, SourceHeight);
    SetLength(CurrentLineB, SourceHeight);


    SourceLine := Work.ScanLine[0];
    Delta := Integer(Work.ScanLine[1]) - Integer(SourceLine);
    DestLine := Target.ScanLine[0];
    DestDelta := Integer(Target.ScanLine[1]) - Integer(DestLine);
    for K := 0 to TargetWidth - 1 do
    begin
      DestPixel := Pointer(DestLine);
      FillLineChache(SourceHeight, Delta, SourceLine);
      for I := 0 to TargetHeight - 1 do
        with ContributorList[I] do
        begin
          DestPixel^ := ApplyContributors(N, ContributorList[I].Contributors);
          Inc(Integer(DestPixel), DestDelta);
        end;
      Inc(SourceLine);
      Inc(DestLine);
    end;

    // free the memory allocated for vertical filter weights
    for I := 0 to TargetHeight - 1 do ContributorList[I].Contributors := nil;
    // this one is done automatically on exit, but is here for completeness
    ContributorList := nil;

  finally
    Work.Free;
    CurrentLineR := nil;
    CurrentLineG := nil;
    CurrentLineB := nil;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure Stretch(NewWidth, NewHeight: Cardinal; Filter: TResamplingFilter; Radius: Single; Source, Target: TBitmap);

// Scales the source bitmap to the given size (NewWidth, NewHeight) and stores the Result in Target.
// Filter describes the filter function to be applied and Radius the size of the filter area.
// Is Radius = 0 then the recommended filter area will be used (see DefaultFilterRadius).

begin
  if Radius = 0 then Radius := DefaultFilterRadius[Filter];
  Target.FreeImage;
  Target.PixelFormat := pf24Bit;
  Target.Width := NewWidth;
  Target.Height := NewHeight;
  Source.PixelFormat := pf24Bit;
  DoStretch(FilterList[Filter], Radius, Source, Target);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure Stretch(NewWidth, NewHeight: Cardinal; Filter: TResamplingFilter; Radius: Single; Source: TBitmap);

var
  Target: TBitmap;

begin
  if Radius = 0 then Radius := DefaultFilterRadius[Filter];
  Target := TBitmap.Create;
  try
    Target.PixelFormat := pf24Bit;
    Target.Width := NewWidth;
    Target.Height := NewHeight;
    Source.PixelFormat := pf24Bit;
    DoStretch(FilterList[Filter], Radius, Source, Target);
    Source.Assign(Target);
  finally
    Target.Free;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure SwapShort(P: PWord; Count: Cardinal); 

// swaps high and low byte of 16 bit values
// EAX contains P, EDX contains Count

asm
@@Loop:
              MOV CX, [EAX]
              XCHG CH, CL
              MOV [EAX], CX
              ADD EAX, 2
              DEC EDX
              JNZ @@Loop
end;

//----------------------------------------------------------------------------------------------------------------------

procedure SwapLong(P: PInteger; Count: Cardinal); overload;

// swaps high and low bytes of 32 bit values
// EAX contains P, EDX contains Count

asm
@@Loop:
              MOV ECX, [EAX]
              BSWAP ECX
              MOV [EAX], ECX
              ADD EAX, 4
              DEC EDX
              JNZ @@Loop
end;

//----------------------------------------------------------------------------------------------------------------------

function SwapLong(Value: Cardinal): Cardinal; overload;

// swaps high and low bytes of the given 32 bit value

asm
              BSWAP EAX
end;

//----------------- various conversion routines ------------------------------------------------------------------------

procedure CIED65ToCIED50(var X, Y, Z: Extended);

// Converts values of the XYZ color space using the D65 white point to D50 white point.
// The values were taken from www.srgb.com/hpsrgbprof/sld005.htm

var
  Xn, Yn, Zn: Extended;
  
begin
  Xn :=   1.0479 * X + 0.0299 * Y - 0.0502 * Z;
  Yn :=   0.0296 * X + 0.9904 * Y - 0.0171 * Z;
  Zn :=  -0.0092 * X + 0.0151 * Y + 0.7519 * Z;
  X := Xn;
  Y := Yn;
  Z := Zn;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure Gray16(Source, Target: Pointer; BitsPerSample: Byte; Count: Cardinal);

// converts each color component from a 16bits per sample to 8 bit used in Windows DIBs
// Count is the number of entries in Source and Target

var
  SourceRun: PWord;
  TargetRun: PByte;

begin
  SourceRun := Source;
  TargetRun := Target;
  while Count > 0 do
  begin
    TargetRun^ := SourceRun^ shr 8;
    Inc(SourceRun);
    Inc(TargetRun);
    Dec(Count);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

type
  PCMYK = ^TCMYK;
  TCMYK = packed record
    C, M, Y, K: Byte;
  end;

  PCMYK16 = ^TCMYK16;
  TCMYK16 = packed record
    C, M, Y, K: Word;
  end;

//----------------------------------------------------------------------------------------------------------------------

procedure CMYK2BGR(Source, Target: Pointer; BitsPerSample: Byte; Count: Cardinal); overload;

// converts a stream of Count CMYK values to BGR

var
  R, G, B, K: Integer;
  I: Integer;
  SourcePtr: PCMYK;
  SourcePtr16: PCMYK16;
  TargetPtr: PByte;

begin
  case BitsPerSample of
    8:
      begin
        SourcePtr := Source;
        TargetPtr := Target;
        Count := Count div 4;
        for I := 0 to Count - 1 do
        begin
          K := SourcePtr.K;
          R := 255 - (SourcePtr.C - MulDiv(SourcePtr.C, K, 255) + K);
          G := 255 - (SourcePtr.M - MulDiv(SourcePtr.M, K, 255) + K);
          B := 255 - (SourcePtr.Y - MulDiv(SourcePtr.Y, K, 255) + K);
          TargetPtr^ := Max(0, Min(255, B));
          Inc(TargetPtr);
          TargetPtr^ := Max(0, Min(255, G));
          Inc(TargetPtr);
          TargetPtr^ := Max(0, Min(255, R));
          Inc(TargetPtr);
          Inc(SourcePtr);
        end;
      end;
    16:
      begin
        SourcePtr16 := Source;
        TargetPtr := Target;
        Count := Count div 4;
        for I := 0 to Count - 1 do
        begin
          K := SourcePtr16.K;
          R := 255 - (SourcePtr16.C - MulDiv(SourcePtr16.C, K, 65535) + K) shr 8;
          G := 255 - (SourcePtr16.M - MulDiv(SourcePtr16.M, K, 65535) + K) shr 8;
          B := 255 - (SourcePtr16.Y - MulDiv(SourcePtr16.Y, K, 65535) + K) shr 8;
          TargetPtr^ := Max(0, Min(255, B));
          Inc(TargetPtr);
          TargetPtr^ := Max(0, Min(255, G));
          Inc(TargetPtr);
          TargetPtr^ := Max(0, Min(255, R));
          Inc(TargetPtr);
          Inc(SourcePtr16);
        end;
      end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure CMYK2BGR(C, M, Y, K, Target: Pointer; BitsPerSample: Byte; Count: Cardinal); overload;

// converts a stream of Count CMYK values to BGR

var
  R, G, B: Integer;
  C8, M8, Y8, K8: PByte;
  C16, M16, Y16, K16: PWord;
  I: Integer;
  TargetPtr: PByte;
  
begin
  case BitsPerSample of
    8:
      begin
        C8 := C;
        M8 := M;
        Y8 := Y;
        K8 := K;
        TargetPtr := Target;
        Count := Count div 4;
        for I := 0 to Count - 1 do
        begin
          R := 255 - (C8^ - MulDiv(C8^, K8^, 255) + K8^);
          G := 255 - (M8^ - MulDiv(M8^, K8^, 255) + K8^);
          B := 255 - (Y8^ - MulDiv(Y8^, K8^, 255) + K8^);
          TargetPtr^ := Max(0, Min(255, B));
          Inc(TargetPtr);
          TargetPtr^ := Max(0, Min(255, G));
          Inc(TargetPtr);
          TargetPtr^ := Max(0, Min(255, R));
          Inc(TargetPtr);
          Inc(C8);
          Inc(M8);
          Inc(Y8);
          Inc(K8);
        end;
      end;
    16:
      begin
        C16 := C;
        M16 := M;
        Y16 := Y;
        K16 := K;
        TargetPtr := Target;
        Count := Count div 4;
        for I := 0 to Count - 1 do
        begin
          R := 255 - (C16^ - MulDiv(C16^, K16^, 65535) + K16^) shr 8;
          G := 255 - (M16^ - MulDiv(M16^, K16^, 65535) + K16^) shr 8;
          B := 255 - (Y16^ - MulDiv(Y16^, K16^, 65535) + K16^) shr 8;
          TargetPtr^ := Max(0, Min(255, B));
          Inc(TargetPtr);
          TargetPtr^ := Max(0, Min(255, G));
          Inc(TargetPtr);
          TargetPtr^ := Max(0, Min(255, R));
          Inc(TargetPtr);
          Inc(C16);
          Inc(M16);
          Inc(Y16);
          Inc(K16);
        end;
      end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure CIELAB2BGR(Source, Target: Pointer; BitsPerSample: Byte; Count: Cardinal); overload;

// conversion of the CIE L*a*b color space to RGB using a two way approach assuming a D65 white point,
// first a conversion to CIE XYZ is performed and then from there to RGB

var
  FinalR,
  FinalG,
  FinalB: Integer;
  L, a, b,
  X, Y, Z, // color values in float format
  T,
  YYn3: Double;  // intermediate results
  SourcePtr,
  TargetPtr: PByte;
  PixelCount: Cardinal;

begin
  SourcePtr := Source;
  TargetPtr := Target;
  PixelCount := Count div 3;

  while PixelCount > 0 do
  begin
    // L should be in the range of 0..100 but at least Photoshop stores the luminance
    // in the range of 0..255
    L := SourcePtr^ / 2.55;
    Inc(SourcePtr);
    a := ShortInt(SourcePtr^);
    Inc(SourcePtr);
    b := ShortInt(SourcePtr^);
    Inc(SourcePtr);

    // CIE L*a*b can be calculated from CIE XYZ by:
    // L = 116 * ((Y / Yn)^1/3) - 16   if (Y / Yn) > 0.008856
    // L = 903.3 * Y / Yn              if (Y / Yn) <= 0.008856
    // a = 500 * (f(X / Xn) - f(Y / Yn))
    // b = 200 * (f(Y / Yn) - f(Z / Zn))
    //   where f(t) = t^(1/3) with (Y / Yn) > 0.008856
	  //         f(t) = 7.787 * t + 16 / 116 with (Y / Yn) <= 0.008856
    //
    // by reordering the above equations we get can calculate CEI L*a*b -> XYZ as follows:
    // L is in the range 0..100 and a as well as b in -127..127
    YYn3 := (L + 16) / 116; // this corresponds to (Y/Yn)^1/3
    if L < 7.9996 then
    begin
      Y := L / 903.3;
      X := a / 3893.5 + Y;
      Z := Y - b / 1557.4;
    end
    else
    begin
			T := YYn3 + a / 500;
			X := T * T * T;
			Y := YYn3 * YYn3 * YYn3;
			T := YYn3 - b / 200;
			Z := T * T * T;
    end;

    // once we have CIE XYZ it is easy (yet quite expensive) to calculate RGB values from this
    FinalR := Round(255 * ( 2.998 * X - 1.458 * Y - 0.541 * Z));
    FinalG := Round(255 * (-0.952 * X + 1.893 * Y + 0.059 * Z));
    FinalB := Round(255 * ( 0.099 * X - 0.198 * Y + 1.099 * Z));

    TargetPtr^ := Max(0, Min(255, FinalB));
    Inc(TargetPtr);
    TargetPtr^ := Max(0, Min(255, FinalG));
    Inc(TargetPtr);
    TargetPtr^ := Max(0, Min(255, FinalR));
    Inc(TargetPtr);

    Dec(PixelCount);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure CIELAB2BGR(LSource, aSource, bSource: PByte; Target: Pointer; BitsPerSample: Byte; Count: Cardinal); overload;

// conversion of the CIE L*a*b color space to RGB using a two way approach assuming a D65 white point,
// first a conversion to CIE XYZ is performed and then from there to RGB

var
  FinalR,
  FinalG,
  FinalB: Integer;
  L, a, b,
  X, Y, Z, // color values in float format
  T,
  YYn3: Double;  // intermediate results
  TargetPtr: PByte;
  PixelCount: Cardinal;

begin
  TargetPtr := Target;
  PixelCount := Count div 3;

  while PixelCount > 0 do
  begin
    // L should be in the range of 0..100 but at least Photoshop stores the luminance
    // in the range of 0..256
    L := LSource^ / 2.55;
    Inc(LSource);
    a := ShortInt(aSource^);
    Inc(aSource);
    b := ShortInt(bSource^);
    Inc(bSource);

    // CIE L*a*b can be calculated from CIE XYZ by:
    // L = 116 * ((Y / Yn)^1/3) - 16   if (Y / Yn) > 0.008856
    // L = 903.3 * Y / Yn              if (Y / Yn) <= 0.008856
    // a = 500 * (f(X / Xn) - f(Y / Yn))
    // b = 200 * (f(Y / Yn) - f(Z / Zn))
    //   where f(t) = t^(1/3) with (Y / Yn) > 0.008856
	  //         f(t) = 7.787 * t + 16 / 116 with (Y / Yn) <= 0.008856
    //
    // by reordering the above equations we get can calculate CEI L*a*b -> XYZ as follows:
    // L is in the range 0..100 and a as well as b in -127..127
    YYn3 := (L + 16) / 116; // this corresponds to (Y/Yn)^1/3
    if L < 7.9996 then
    begin
      Y := L / 903.3;
      X := a / 3893.5 + Y;
      Z := Y - b / 1557.4;
    end
    else
    begin
			T := YYn3 + a / 500;
			X := T * T * T;
			Y := YYn3 * YYn3 * YYn3;
			T := YYn3 - b / 200;
			Z := T * T * T;
    end;

    // once we have CIE XYZ it is easy (yet quite expensive) to calculate RGB values from this
    FinalR := Round(255 * ( 2.998 * X - 1.458 * Y - 0.541 * Z));
    FinalG := Round(255 * (-0.952 * X + 1.893 * Y + 0.059 * Z));
    FinalB := Round(255 * ( 0.099 * X - 0.198 * Y + 1.099 * Z));

    TargetPtr^ := Max(0, Min(255, FinalB));
    Inc(TargetPtr);
    TargetPtr^ := Max(0, Min(255, FinalG));
    Inc(TargetPtr);
    TargetPtr^ := Max(0, Min(255, FinalR));
    Inc(TargetPtr);

    Dec(PixelCount);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure RGB2BGR(Source, Target: Pointer; BitsPerSample: Byte; Count: Cardinal); overload;

// reorders a stream of "Count" RGB values to BGR, additionally an eventual sample size adjustment is done

var
  SourceRun16: PRGBWord;
  SourceRun8: PRGB;
  TargetRun: PBGR;

begin
  Count := Count div 3;
  // usually only 8 bit samples are used but Photoshop allows for 16 bit samples
  case BitsPerSample of
    8:
      begin
        SourceRun8 := Source;
        TargetRun := Target;
        while Count > 0 do
        begin
          TargetRun.R := SourceRun8.R;
          TargetRun.G := SourceRun8.G;
          TargetRun.B := SourceRun8.B;
          Inc(SourceRun8);
          Inc(TargetRun);
          Dec(Count);
        end;
      end;
    16:
      begin
        SourceRun16 := Source;
        TargetRun := Target;
        while Count > 0 do
        begin
          TargetRun.R := SourceRun16.R shr 8;
          TargetRun.G := SourceRun16.G shr 8;
          TargetRun.B := SourceRun16.B shr 8;
          Inc(SourceRun16);
          Inc(TargetRun);
          Dec(Count);
        end;
      end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure RGB2BGR(R, G, B, Target: Pointer; BitsPerSample: Byte; Count: Cardinal); overload;

// reorders a stream of "Count" RGB values to BGR, additionally an eventual sample size adjustment is done

var
  R8, G8, B8: PByte;
  R16, G16, B16: PWord;
  TargetRun: PByte;

begin
  Count := Count div 3;
  // usually only 8 bits samples are used but Photoshop allows 16 bits samples too
  case BitsPerSample of
    8:
      begin
        R8 := R;
        G8 := G;
        B8 := B;
        TargetRun := Target;
        while Count > 0 do
        begin
          TargetRun^ := B8^;
          Inc(B8);
          Inc(TargetRun);
          TargetRun^ := G8^;
          Inc(G8);
          Inc(TargetRun);
          TargetRun^ := R8^;
          Inc(R8);
          Inc(TargetRun);
          Dec(Count);
        end;
      end;
    16:
      begin
        R16 := R;
        G16 := G;
        B16 := B;
        TargetRun := Target;
        while Count > 0 do
        begin
          TargetRun^ := B16^ shr 8;
          Inc(B16);
          Inc(TargetRun);
          TargetRun^ := G16^ shr 8;
          Inc(G16);
          Inc(TargetRun);
          TargetRun^ := R16^ shr 8;
          Inc(R16);
          Inc(TargetRun);
          Dec(Count);
        end;
      end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure RGBA2BGRA(Source, Target: Pointer; BitsPerSample: Byte; Count: Cardinal);

// reorders a stream of "Count" RGBA values to BGRA, additionally an eventual sample size adjustment is done

var
  SourceRun16: PRGBAWord;
  SourceRun8: PRGBA;
  TargetRun: PBGRA;

begin
  Count := Count div 4;
  // usually only 8 bit samples are used but Photoshop allows for 16 bit samples
  case BitsPerSample of
    8:
      begin
        SourceRun8 := Source;
        TargetRun := Target;
        while Count > 0 do
        begin
          TargetRun.R := SourceRun8.R;
          TargetRun.G := SourceRun8.G;
          TargetRun.B := SourceRun8.B;
          TargetRun.A := SourceRun8.A;
          Inc(SourceRun8);
          Inc(TargetRun);
          Dec(Count);
        end;
      end;
    16:
      begin
        SourceRun16 := Source;
        TargetRun := Target;
        while Count > 0 do
        begin
          TargetRun.R := SourceRun16.B shr 8;
          TargetRun.G := SourceRun16.G shr 8;
          TargetRun.B := SourceRun16.R shr 8;
          TargetRun.A := SourceRun16.A shr 8;
          Inc(SourceRun16);
          Inc(TargetRun);
          Dec(Count);
        end;
      end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure Depredict1(P: Pointer; Count: Cardinal);

// EAX contains P and EDX Count

asm
@@1:
              MOV CL, [EAX]
              ADD [EAX + 1], CL
              INC EAX
              DEC EDX
              JNZ @@1
end;

//----------------------------------------------------------------------------------------------------------------------

procedure Depredict3(P: Pointer; Count: Cardinal); 

// EAX contains P and EDX Count

asm
              MOV ECX, EDX
              SHL ECX, 1
              ADD ECX, EDX         // 3 * Count
@@1:
              MOV DL, [EAX]
              ADD [EAX + 3], DL
              INC EAX
              DEC ECX
              JNZ @@1
end;

//----------------------------------------------------------------------------------------------------------------------

procedure Depredict4(P: Pointer; Count: Cardinal);

// EAX contains P and EDX Count

asm
              SHL EDX, 2          // 4 * Count
@@1:
              MOV CL, [EAX]
              ADD [EAX + 4], CL
              INC EAX
              DEC EDX
              JNZ @@1
end;

//----------------- TAutodeskGraphic -----------------------------------------------------------------------------------

procedure TAutodeskGraphic.LoadFromStream(Stream: TStream);

type
  TFileHeader = packed record
    Width,
    Height,
    XCoord,
    YCoord: Word;
    Depth,
    Compress: Byte;
    DataSize: Cardinal;
    Reserved: array[0..15] of Byte;
  end;

var
  FileID: Word;
  FileHeader: TFileHeader;
  LogPalette: TMaxLogPalette;
  I: Integer;

begin
  with Stream do
  begin
    Read(FileID, 2);
    if FileID <> $9119 then raise Exception.Create('Cannot load image. Only old style Autodesk images are supported.')
                       else
    begin
      // read image dimensions
      Read(FileHeader, SizeOf(FileHeader));
      // read palette entries and create a palette
      FillChar(LogPalette, SizeOf(LogPalette), 0);
      LogPalette.palVersion := $300;
      LogPalette.palNumEntries := 256;
      for I := 0 to 255 do
      begin
        Read(LogPalette.palPalEntry[I], 3);
        LogPalette.palPalEntry[I].peBlue := LogPalette.palPalEntry[I].peBlue shl 2;
        LogPalette.palPalEntry[I].peGreen := LogPalette.palPalEntry[I].peGreen shl 2;
        LogPalette.palPalEntry[I].peRed := LogPalette.palPalEntry[I].peRed shl 2;
      end;

      // setup bitmap properties
      PixelFormat := pf8Bit;
      Palette := CreatePalette(PLogPalette(@LogPalette)^);
      Width := FileHeader.Width;
      Height := FileHeader.Height;
      // finally read image data
      for I := 0 to Height - 1 do
        Read(Scanline[I]^, FileHeader.Width);
    end;
  end;
end;

//----------------- TSGIGraphic ----------------------------------------------------------------------------------------

const
  SGIMagic = 474;

  SGI_COMPRESSION_VERBATIM = 0;
  SGI_COMPRESSION_RLE = 1;

type
  TSGIHeader = packed record
    Magic: SmallInt;         // IRIS image file magic number
    Storage,                 // Storage format
    BPC: Byte;               // Number of bytes per pixel channel (1 or 2)
    Dimension: Word;         // Number of dimensions
                             //   1 - one single scanline (and one channel) of length XSize
                             //   2 - two dimensional (one channel) of size XSize x YSize
                             //   3 - three dimensional (ZSize channels) of size XSize x YSize
    XSize,                   // width of image
    YSize,                   // height of image
    ZSize: Word;             // number of channels/planes in image (3 for RGB, 4 for RGBA etc.)
    PixMin,                  // Minimum pixel value
    PixMax: Integer;         // Maximum pixel value
    Dummy: Cardinal;         // ignored
    ImageName: array[0..79] of Char;
    ColorMap: Integer;       // Colormap ID
                             //  0 - default, almost all images are stored with this flag
                             //  1 - dithered, only one channel of data (pixels are packed), obsolete
                             //  2 - screen (palette) image, obsolete
                             //  3 - no image data, palette only, not displayable
    Dummy2: array[0..403] of Byte; // ignored
  end;

procedure TSGIGraphic.ReadAndDecode(Red, Green, Blue, Alpha: PByte; Row, BPC: Integer);

var
  Count: Cardinal;
  Run: PWord;

  //--------------- local functions -------------------------------------------

  procedure Convert16(Target: PByte);

  begin
    FStream.Read(FRowBuffer^, 2 * Width);
    Run := FRowBuffer;
    Count := Width;
    while Count > 0 do
    begin
      Target^ := Run^ shr 8;
      Inc(Target);
      Inc(Run);
    end;
  end;

  //--------------- end local functions ---------------------------------------

begin
  with FStream do
    // compressed image?
    if Assigned(FDecoder) then
    begin
      if Assigned(Red) then
      begin
        Position := FStartPosition + FRowStart[Row + 0 * Height];
        Count := FSampleSize * FRowSize[Row + 0 * Height];
        Read(FRowBuffer^, Count);
        FDecoder.Decode(FRowBuffer, Red, Count, Width);
      end;

      if Assigned(Green) then
      begin
        Position := FStartPosition + FRowStart[Row + 1 * Height];
        Count := FSampleSize * FRowSize[Row + 1 * Height];
        Read(FRowBuffer^, Count);
        FDecoder.Decode(FRowBuffer, Green, Count, Width);
      end;

      if Assigned(Blue) then
      begin
        Position := FStartPosition + FRowStart[Row + 2 * Height];
        Count := FSampleSize * FRowSize[Row + 2 * Height];
        Read(FRowBuffer^, Count);
        FDecoder.Decode(FRowBuffer, Blue, Count, Width);
      end;

      if Assigned(Alpha) then
      begin
        Position := FStartPosition + FRowStart[Row + 3 * Height];
        Count := FSampleSize * FRowSize[Row + 3 * Height];
        Read(FRowBuffer^, Count);
        FDecoder.Decode(FRowBuffer, Alpha, Count, Width);
      end;
    end
    else
    begin
      if Assigned(Red) then
      begin
        Position := Integer(FStartPosition) + 512 + (Row * Width) + (0 * Width * Height);
        if BPC = 1 then Read(Red^, Width)
                   else Convert16(Red);
      end;

      if Assigned(Green) then
      begin
        Position := Integer(FStartPosition) + 512 + (Row * Width) + (1 * Width * Height);
        if BPC = 1 then Read(Green^, Width)
                   else Convert16(Green);
      end;

      if Assigned(Blue) then
      begin
        Position := Integer(FStartPosition) + 512 + (Row * Width) + (2 * Width * Height);
        if BPC = 1 then Read(Blue^, Width)
                   else Convert16(Blue);
      end;

      if Assigned(Alpha) then
      begin
        Position := Integer(FStartPosition) + 512 + (Row * Width) + (3 * Width * Height);
        if BPC = 1 then Read(Alpha^, Width)
                   else Convert16(Alpha);
      end;
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TSGIGraphic.LoadFromStream(Stream: TStream);

var
  X, Y: Integer;
  RedBuffer,
  GreenBuffer,
  BlueBuffer,
  AlphaBuffer,
  R, G, B, A,
  Target: PByte;
  LogPalette: TMaxLogPalette;
  Header: TSGIHeader;
  Count: Cardinal;
 
begin
  // free previous image
  Handle := 0;

  // keep stream reference and start position for seek operations
  FStream := Stream;
  FStartPosition := Stream.Position;

  // allocate memory and do endian to endian conversion
  with FStream do
  begin
    Read(Header, SizeOf(Header));
    // SGI images are stored in big endian style, so we need to swap all word and integer values in the header
    with Header do
    begin
      Magic := Swap(Magic);
      Dimension := Swap(Dimension);
      XSize := Swap(XSize);
      YSize := Swap(YSize);
      ZSize := Swap(ZSize);
      PixMin := SwapLong(PixMin);
      PixMax := SwapLong(PixMax);
      ColorMap := SwapLong(ColorMap);
    end;

    if Header.Magic <> SGIMagic then raise Exception.Create('Not a valid sgi, bw or rgb(a) image.');

    // allocate the raw data buffer once, the worst case for compressed data is that it is
    // twice the size of the uncompressed data, add some extra bytes for 16 bits per channel data
    FSampleSize := Header.BPC;
    GetMem(FRowBuffer, 3 * FSampleSize * Header.XSize);

    if Header.Storage = SGI_COMPRESSION_RLE then
    begin
      Count := Header.YSize * Header.ZSize * SizeOf(Cardinal);
      SetLength(FRowStart, Count);
      SetLength(FRowSize, Count);
      // read line starts and sizes from stream
      Read(FRowStart[0], Count);
      SwapLong(@FRowStart[0], Count div SizeOf(Cardinal));
      Read(FRowSize[0], Count);
      SwapLong(@FRowSize[0], Count div SizeOf(Cardinal));
      FDecoder := TSGIRLE.Create;
      TSGIRLE(FDecoder).SampleSize := Header.BPC;
    end
    else FDecoder := nil;

    // set pixel format before size to avoid possibly large conversion operation
    case Header.ZSize of
      4:
        PixelFormat := pf32Bit;
      3:
        PixelFormat := pf24Bit;
    else
      PixelFormat := pf8Bit;
    end;

    Width := Header.XSize;
    Height := Header.YSize;

    GetMem(RedBuffer, Width);
    GetMem(GreenBuffer, Width);
    GetMem(BlueBuffer, Width);
    GetMem(AlphaBuffer, Width);

    // read lines and put it into the bitmap
    case Header.ZSize of
      4: // RGBA image
        begin
          for  Y := 0 to Height - 1 do
          begin
            ReadAndDecode(RedBuffer, GreenBuffer, BlueBuffer, AlphaBuffer, Y, Header.BPC);
            Target := ScanLine[Height - Y - 1];
            R := RedBuffer;
            G := GreenBuffer;
            B := BlueBuffer;
            A := AlphaBuffer;
            // convert single component buffers into a scanline 
            for X := 0 to Width - 1 do
            begin
              Target^ := B^;
              Inc(Target);
              Inc(B);
              Target^ := G^;
              Inc(Target);
              Inc(G);
              Target^ := R^;
              Inc(Target);
              Inc(R);
              Target^ := A^;
              Inc(Target);
              Inc(A);
            end;
          end;
        end;
      3: // RGB image
        begin
          for  Y := 0 to Height - 1 do
          begin
            ReadAndDecode(RedBuffer, GreenBuffer, BlueBuffer, nil, Y, Header.BPC);
            Target := ScanLine[Height - Y - 1];
            R := RedBuffer;
            G := GreenBuffer;
            B := BlueBuffer;
            // convert single component buffers into a scanline
            for X := 0 to Width - 1 do
            begin
              Target^ := B^;
              Inc(Target);
              Inc(B);
              Target^ := G^;
              Inc(Target);
              Inc(G);
              Target^ := R^;
              Inc(Target);
              Inc(R);
            end;
          end;
        end;
    else
      // any other format is interpreted as being 256 gray scales
      PixelFormat := pf8Bit;
      FillChar(LogPalette, SizeOf(LogPalette), 0);
      LogPalette.palVersion := $300;
      LogPalette.palNumEntries := 256;
      for Y := 0 to 255 do
      begin
        LogPalette.palPalEntry[Y].peBlue := Y;
        LogPalette.palPalEntry[Y].peGreen := Y;
        LogPalette.palPalEntry[Y].peRed := Y;
      end;

      // setup bitmap properties
      Palette := CreatePalette(PLogPalette(@LogPalette)^);
      for  Y := 0 to Height - 1 do
        ReadAndDecode(ScanLine[Height - Y - 1], nil, nil, nil, Y, Header.BPC);
    end;
    
    FreeMem(RedBuffer);
    FreeMem(GreenBuffer);
    FreeMem(BlueBuffer);
    FreeMem(AlphaBuffer);
    FDecoder.Free;
  end;

  // free raw buffer, dynamic arrays are automatically freed
  FreeMem(FRowBuffer);
end;

//----------------- TTIFFGraphic ---------------------------------------------------------------------------------------

const // TIFF tags
  TIFFTAG_SUBFILETYPE = 254;                     // subfile data descriptor
    FILETYPE_REDUCEDIMAGE = $1;                  // reduced resolution version
    FILETYPE_PAGE = $2;                          // one page of many
    FILETYPE_MASK = $4;                          // transparency mask
  TIFFTAG_OSUBFILETYPE = 255;                    // kind of data in subfile (obsolete by revision 5.0)
    OFILETYPE_IMAGE = 1;                         // full resolution image data
    OFILETYPE_REDUCEDIMAGE = 2;                  // reduced size image data
    OFILETYPE_PAGE = 3;                          // one page of many
  TIFFTAG_IMAGEWIDTH = 256;                      // image width in pixels
  TIFFTAG_IMAGELENGTH = 257;                     // image height in pixels
  TIFFTAG_BITSPERSAMPLE = 258;                   // bits per channel (sample)
  TIFFTAG_COMPRESSION = 259;                     // data compression technique
    COMPRESSION_NONE = 1;                        // dump mode
    COMPRESSION_CCITTRLE = 2;                    // CCITT modified Huffman RLE
    COMPRESSION_CCITTFAX3 = 3;                   // CCITT Group 3 fax encoding
    COMPRESSION_CCITTFAX4 = 4;                   // CCITT Group 4 fax encoding
    COMPRESSION_LZW = 5;                         // Lempel-Ziv & Welch
    COMPRESSION_OJPEG = 6;                       // 6.0 JPEG
    COMPRESSION_JPEG = 7;                        // JPEG DCT compression
    COMPRESSION_NEXT = 32766;                    // next 2-bit RLE
    COMPRESSION_CCITTRLEW = 32771;               // #1 w/ Word alignment
    COMPRESSION_PACKBITS = 32773;                // Macintosh RLE
    COMPRESSION_THUNDERSCAN = 32809;             // ThunderScan RLE
    // codes 32895-32898 are reserved for ANSI IT8 TIFF/IT <dkelly@etsinc.com)
    COMPRESSION_IT8CTPAD = 32895;                // IT8 CT w/padding
    COMPRESSION_IT8LW = 32896;                   // IT8 Linework RLE
    COMPRESSION_IT8MP = 32897;                   // IT8 Monochrome picture
    COMPRESSION_IT8BL = 32898;                   // IT8 Binary line art
    // compression codes 32908-32911 are reserved for Pixar
    COMPRESSION_PIXARFILM = 32908;               // Pixar companded 10bit LZW
    COMPRESSION_PIXARLOG = 32909;                // Pixar companded 11bit ZIP
    COMPRESSION_DEFLATE = 32946;                 // Deflate compression
    // compression code 32947 is reserved for Oceana Matrix <dev@oceana.com>
    COMPRESSION_DCS = 32947;                     // Kodak DCS encoding
    COMPRESSION_JBIG = 34661;                    // ISO JBIG
  TIFFTAG_PHOTOMETRIC = 262;                     // photometric interpretation
    PHOTOMETRIC_MINISWHITE = 0;                  // min value is white
    PHOTOMETRIC_MINISBLACK = 1;                  // min value is black
    PHOTOMETRIC_RGB = 2;                         // RGB color model
    PHOTOMETRIC_PALETTE = 3;                     // color map indexed
    PHOTOMETRIC_MASK = 4;                        // holdout mask
    PHOTOMETRIC_SEPARATED = 5;                   // color separations
    PHOTOMETRIC_YCBCR = 6;                       // CCIR 601
    PHOTOMETRIC_CIELAB = 8;                      // 1976 CIE L*a*b*
  TIFFTAG_THRESHHOLDING = 263;                   // thresholding used on data (obsolete by revision 5.0)
    THRESHHOLD_BILEVEL = 1;                      // b&w art scan
    THRESHHOLD_HALFTONE = 2;                     // or dithered scan
    THRESHHOLD_ERRORDIFFUSE = 3;                 // usually floyd-steinberg
  TIFFTAG_CELLWIDTH = 264;                       // dithering matrix width (obsolete by revision 5.0)
  TIFFTAG_CELLLENGTH = 265;                      // dithering matrix height (obsolete by revision 5.0)
  TIFFTAG_FILLORDER = 266;                       // data order within a Byte
    FILLORDER_MSB2LSB = 1;                       // most significant -> least
    FILLORDER_LSB2MSB = 2;                       // least significant -> most
  TIFFTAG_DOCUMENTNAME = 269;                    // name of doc. image is from
  TIFFTAG_IMAGEDESCRIPTION = 270;                // info about image
  TIFFTAG_MAKE = 271;                            // scanner manufacturer name
  TIFFTAG_MODEL = 272;                           // scanner model name/number
  TIFFTAG_STRIPOFFSETS = 273;                    // Offsets to data strips
  TIFFTAG_ORIENTATION = 274;                     // image FOrientation (obsolete by revision 5.0)
    ORIENTATION_TOPLEFT = 1;                     // row 0 top, col 0 lhs
    ORIENTATION_TOPRIGHT = 2;                    // row 0 top, col 0 rhs
    ORIENTATION_BOTRIGHT = 3;                    // row 0 bottom, col 0 rhs
    ORIENTATION_BOTLEFT = 4;                     // row 0 bottom, col 0 lhs
    ORIENTATION_LEFTTOP = 5;                     // row 0 lhs, col 0 top
    ORIENTATION_RIGHTTOP = 6;                    // row 0 rhs, col 0 top
    ORIENTATION_RIGHTBOT = 7;                    // row 0 rhs, col 0 bottom
    ORIENTATION_LEFTBOT = 8;                     // row 0 lhs, col 0 bottom
  TIFFTAG_SAMPLESPERPIXEL = 277;                 // samples per pixel
  TIFFTAG_ROWSPERSTRIP = 278;                    // rows per strip of data
  TIFFTAG_STRIPBYTECOUNTS = 279;                 // bytes counts for strips
  TIFFTAG_MINSAMPLEVALUE = 280;                  // minimum sample value (obsolete by revision 5.0)
  TIFFTAG_MAXSAMPLEVALUE = 281;                  // maximum sample value (obsolete by revision 5.0)
  TIFFTAG_XRESOLUTION = 282;                     // pixels/resolution in x
  TIFFTAG_YRESOLUTION = 283;                     // pixels/resolution in y
  TIFFTAG_PLANARCONFIG = 284;                    // storage organization
    PLANARCONFIG_CONTIG = 1;                     // single image plane
    PLANARCONFIG_SEPARATE = 2;                   // separate planes of data
  TIFFTAG_PAGENAME = 285;                        // page name image is from
  TIFFTAG_XPOSITION = 286;                       // x page offset of image lhs
  TIFFTAG_YPOSITION = 287;                       // y page offset of image lhs
  TIFFTAG_FREEOFFSETS = 288;                     // byte offset to free block (obsolete by revision 5.0)
  TIFFTAG_FREEBYTECOUNTS = 289;                  // sizes of free blocks (obsolete by revision 5.0)
  TIFFTAG_GRAYRESPONSEUNIT = 290;                // gray scale curve accuracy
    GRAYRESPONSEUNIT_10S = 1;                    // tenths of a unit
    GRAYRESPONSEUNIT_100S = 2;                   // hundredths of a unit
    GRAYRESPONSEUNIT_1000S = 3;                  // thousandths of a unit
    GRAYRESPONSEUNIT_10000S = 4;                 // ten-thousandths of a unit
    GRAYRESPONSEUNIT_100000S = 5;                // hundred-thousandths
  TIFFTAG_GRAYRESPONSECURVE = 291;               // gray scale response curve
  TIFFTAG_GROUP3OPTIONS = 292;                   // 32 flag bits
    GROUP3OPT_2DENCODING = $1;                   // 2-dimensional coding
    GROUP3OPT_UNCOMPRESSED = $2;                 // data not compressed
    GROUP3OPT_FILLBITS = $4;                     // fill to byte boundary
  TIFFTAG_GROUP4OPTIONS = 293;                   // 32 flag bits
    GROUP4OPT_UNCOMPRESSED = $2;                 // data not compressed
  TIFFTAG_RESOLUTIONUNIT = 296;                  // units of resolutions
    RESUNIT_NONE = 1;                            // no meaningful units
    RESUNIT_INCH = 2;                            // english
    RESUNIT_CENTIMETER = 3;                      // metric
  TIFFTAG_PAGENUMBER = 297;                      // page numbers of multi-page
  TIFFTAG_COLORRESPONSEUNIT = 300;               // color curve accuracy
    COLORRESPONSEUNIT_10S = 1;                   // tenths of a unit
    COLORRESPONSEUNIT_100S = 2;                  // hundredths of a unit
    COLORRESPONSEUNIT_1000S = 3;                 // thousandths of a unit
    COLORRESPONSEUNIT_10000S = 4;                // ten-thousandths of a unit
    COLORRESPONSEUNIT_100000S = 5;               // hundred-thousandths
  TIFFTAG_TRANSFERFUNCTION = 301;                // colorimetry info
  TIFFTAG_SOFTWARE = 305;                        // name & release
  TIFFTAG_DATETIME = 306;                        // creation date and time
  TIFFTAG_ARTIST = 315;                          // creator of image
  TIFFTAG_HOSTCOMPUTER = 316;                    // machine where created
  TIFFTAG_PREDICTOR = 317;                       // prediction scheme w/ LZW
    PREDICTION_NONE = 1;                         // no prediction scheme used before coding
    PREDICTION_HORZ_DIFFERENCING = 2;            // horizontal differencing prediction scheme used
  TIFFTAG_WHITEPOINT = 318;                      // image white point
  TIFFTAG_PRIMARYCHROMATICITIES = 319;           // primary chromaticities
  TIFFTAG_COLORMAP = 320;                        // RGB map for pallette image
  TIFFTAG_HALFTONEHINTS = 321;                   // highlight+shadow info
  TIFFTAG_TILEWIDTH = 322;                       // rows/data tile
  TIFFTAG_TILELENGTH = 323;                      // cols/data tile
  TIFFTAG_TILEOFFSETS = 324;                     // offsets to data tiles
  TIFFTAG_TILEBYTECOUNTS = 325;                  // Byte counts for tiles
  TIFFTAG_BADFAXLINES = 326;                     // lines w/ wrong pixel count
  TIFFTAG_CLEANFAXDATA = 327;                    // regenerated line info
    CLEANFAXDATA_CLEAN = 0;                      // no errors detected
    CLEANFAXDATA_REGENERATED = 1;                // receiver regenerated lines
    CLEANFAXDATA_UNCLEAN = 2;                    // uncorrected errors exist
  TIFFTAG_CONSECUTIVEBADFAXLINES = 328;          // max consecutive bad lines
  TIFFTAG_SUBIFD = 330;                          // subimage descriptors
  TIFFTAG_INKSET = 332;                          // inks in separated image
    INKSET_CMYK = 1;                             // cyan-magenta-yellow-black
  TIFFTAG_INKNAMES = 333;                        // ascii names of inks
  TIFFTAG_DOTRANGE = 336;                        // 0% and 100% dot codes
  TIFFTAG_TARGETPRINTER = 337;                   // separation target
  TIFFTAG_EXTRASAMPLES = 338;                    // info about extra samples
    EXTRASAMPLE_UNSPECIFIED = 0;                 // unspecified data
    EXTRASAMPLE_ASSOCALPHA = 1;                  // associated alpha data
    EXTRASAMPLE_UNASSALPHA = 2;                  // unassociated alpha data
  TIFFTAG_SAMPLEFORMAT = 339;                    // data sample format
    SAMPLEFORMAT_UINT = 1;                       // unsigned integer data
    SAMPLEFORMAT_INT = 2;                        // signed integer data
    SAMPLEFORMAT_IEEEFP = 3;                     // IEEE floating point data
    SAMPLEFORMAT_VOID = 4;                       // untyped data
  TIFFTAG_SMINSAMPLEVALUE = 340;                 // variable MinSampleValue
  TIFFTAG_SMAXSAMPLEVALUE = 341;                 // variable MaxSampleValue
  TIFFTAG_JPEGTABLES = 347;                      // JPEG table stream

  // Tags 512-521 are obsoleted by Technical Note #2 which specifies a revised JPEG-in-TIFF scheme.

  TIFFTAG_JPEGPROC = 512;                        // JPEG processing algorithm
    JPEGPROC_BASELINE = 1;                       // baseline sequential
    JPEGPROC_LOSSLESS = 14;                      // Huffman coded lossless
  TIFFTAG_JPEGIFOFFSET = 513;                    // Pointer to SOI marker
  TIFFTAG_JPEGIFBYTECOUNT = 514;                 // JFIF stream length
  TIFFTAG_JPEGRESTARTINTERVAL = 515;             // restart interval length
  TIFFTAG_JPEGLOSSLESSPREDICTORS = 517;          // lossless proc predictor
  TIFFTAG_JPEGPOINTTRANSFORM = 518;              // lossless point transform
  TIFFTAG_JPEGQTABLES = 519;                     // Q matrice offsets
  TIFFTAG_JPEGDCTABLES = 520;                    // DCT table offsets
  TIFFTAG_JPEGACTABLES = 521;                    // AC coefficient offsets
  TIFFTAG_YCBCRCOEFFICIENTS = 529;               // RGB -> YCbCr transform
  TIFFTAG_YCBCRSUBSAMPLING = 530;                // YCbCr subsampling factors
  TIFFTAG_YCBCRPOSITIONING = 531;                // subsample positioning
    YCBCRPOSITION_CENTERED = 1;                  // as in PostScript Level 2
    YCBCRPOSITION_COSITED = 2;                   // as in CCIR 601-1
  TIFFTAG_REFERENCEBLACKWHITE = 532;             // colorimetry info
  // tags 32952-32956 are private tags registered to Island Graphics
  TIFFTAG_REFPTS = 32953;                        // image reference points
  TIFFTAG_REGIONTACKPOINT = 32954;               // region-xform tack point
  TIFFTAG_REGIONWARPCORNERS = 32955;             // warp quadrilateral
  TIFFTAG_REGIONAFFINE = 32956;                  // affine transformation mat
  // tags 32995-32999 are private tags registered to SGI
  TIFFTAG_MATTEING = 32995;                      // use ExtraSamples
  TIFFTAG_DATATYPE = 32996;                      // use SampleFormat
  TIFFTAG_IMAGEDEPTH = 32997;                    // z depth of image
  TIFFTAG_TILEDEPTH = 32998;                     // z depth/data tile

  // tags 33300-33309 are private tags registered to Pixar
  //
  // TIFFTAG_PIXAR_IMAGEFULLWIDTH and TIFFTAG_PIXAR_IMAGEFULLLENGTH
  // are set when an image has been cropped out of a larger image.
  // They reflect the size of the original uncropped image.
  // The TIFFTAG_XPOSITION and TIFFTAG_YPOSITION can be used
  // to determine the position of the smaller image in the larger one.

  TIFFTAG_PIXAR_IMAGEFULLWIDTH = 33300;          // full image size in x
  TIFFTAG_PIXAR_IMAGEFULLLENGTH = 33301;         // full image size in y
  // tag 33405 is a private tag registered to Eastman Kodak
  TIFFTAG_WRITERSERIALNUMBER = 33405;            // device serial number
  // tag 33432 is listed in the 6.0 spec w/ unknown ownership
  TIFFTAG_COPYRIGHT = 33432;                     // copyright string
  // 34016-34029 are reserved for ANSI IT8 TIFF/IT <dkelly@etsinc.com)
  TIFFTAG_IT8SITE = 34016;                       // site name
  TIFFTAG_IT8COLORSEQUENCE = 34017;              // color seq. [RGB,CMYK,etc]
  TIFFTAG_IT8HEADER = 34018;                     // DDES Header
  TIFFTAG_IT8RASTERPADDING = 34019;              // raster scanline padding
  TIFFTAG_IT8BITSPERRUNLENGTH = 34020;           // # of bits in short run
  TIFFTAG_IT8BITSPEREXTENDEDRUNLENGTH = 34021;   // # of bits in long run
  TIFFTAG_IT8COLORTABLE = 34022;                 // LW colortable
  TIFFTAG_IT8IMAGECOLORINDICATOR = 34023;        // BP/BL image color switch
  TIFFTAG_IT8BKGCOLORINDICATOR = 34024;          // BP/BL bg color switch
  TIFFTAG_IT8IMAGECOLORVALUE = 34025;            // BP/BL image color value
  TIFFTAG_IT8BKGCOLORVALUE = 34026;              // BP/BL bg color value
  TIFFTAG_IT8PIXELINTENSITYRANGE = 34027;        // MP pixel intensity value
  TIFFTAG_IT8TRANSPARENCYINDICATOR = 34028;      // HC transparency switch
  TIFFTAG_IT8COLORCHARACTERIZATION = 34029;      // color character. table
  // tags 34232-34236 are private tags registered to Texas Instruments
  TIFFTAG_FRAMECOUNT = 34232;                    // Sequence Frame Count
  // tag 34750 is a private tag registered to Pixel Magic
  TIFFTAG_JBIGOPTIONS = 34750;                   // JBIG options
  // tags 34908-34914 are private tags registered to SGI
  TIFFTAG_FAXRECVPARAMS = 34908;                 // encoded class 2 ses. parms
  TIFFTAG_FAXSUBADDRESS = 34909;                 // received SubAddr string
  TIFFTAG_FAXRECVTIME = 34910;                   // receive time (secs)
  // tag 65535 is an undefined tag used by Eastman Kodak
  TIFFTAG_DCSHUESHIFTVALUES = 65535;             // hue shift correction data

  // The following are ``pseudo tags'' that can be used to control codec-specific functionality.
  // These tags are not written to file.  Note that these values start at $FFFF + 1 so that they'll
  // never collide with Aldus-assigned tags.

  TIFFTAG_FAXMODE = 65536;                       // Group 3/4 format control
    FAXMODE_CLASSIC = $0000;                     // default, include RTC
    FAXMODE_NORTC = $0001;                       // no RTC at end of data
    FAXMODE_NOEOL = $0002;                       // no EOL code at end of row
    FAXMODE_BYTEALIGN = $0004;                   // Byte align row
    FAXMODE_WORDALIGN = $0008;                   // Word align row
    FAXMODE_CLASSF = FAXMODE_NORTC;              // TIFF class F
  TIFFTAG_JPEGQUALITY = 65537;                   // compression quality level
  // Note: quality level is on the IJG 0-100 scale.  Default value is 75
  TIFFTAG_JPEGCOLORMODE = 65538;                 // Auto RGB<=>YCbCr convert?
    JPEGCOLORMODE_RAW = $0000;                   // no conversion (default)
    JPEGCOLORMODE_RGB = $0001;                   // do auto conversion
  TIFFTAG_JPEGTABLESMODE = 65539;                // What to put in JPEGTables
    JPEGTABLESMODE_QUANT = $0001;                // include quantization tbls
    JPEGTABLESMODE_HUFF = $0002;                 // include Huffman tbls
  // Note: default is JPEGTABLESMODE_QUANT or JPEGTABLESMODE_HUFF
  TIFFTAG_FAXFILLFUNC = 65540;                   // G3/G4 fill function
  TIFFTAG_PIXARLOGDATAFMT = 65549;               // PixarLogCodec I/O data sz
    PIXARLOGDATAFMT_8BIT = 0;                    // regular u_char samples
    PIXARLOGDATAFMT_8BITABGR = 1;                // ABGR-order u_chars
    PIXARLOGDATAFMT_11BITLOG = 2;                // 11-bit log-encoded (raw)
    PIXARLOGDATAFMT_12BITPICIO = 3;              // as per PICIO (1.0==2048)
    PIXARLOGDATAFMT_16BIT = 4;                   // signed short samples
    PIXARLOGDATAFMT_FLOAT = 5;                   // IEEE float samples
  // 65550-65556 are allocated to Oceana Matrix <dev@oceana.com>
  TIFFTAG_DCSIMAGERTYPE = 65550;                 // imager model & filter
    DCSIMAGERMODEL_M3 = 0;                       // M3 chip (1280 x 1024)
    DCSIMAGERMODEL_M5 = 1;                       // M5 chip (1536 x 1024)
    DCSIMAGERMODEL_M6 = 2;                       // M6 chip (3072 x 2048)
    DCSIMAGERFILTER_IR = 0;                      // infrared filter
    DCSIMAGERFILTER_MONO = 1;                    // monochrome filter
    DCSIMAGERFILTER_CFA = 2;                     // color filter array
    DCSIMAGERFILTER_OTHER = 3;                   // other filter
  TIFFTAG_DCSINTERPMODE = 65551;                 // interpolation mode
    DCSINTERPMODE_NORMAL = $0;                   // whole image, default
    DCSINTERPMODE_PREVIEW = $1;                  // preview of image (384x256)
  TIFFTAG_DCSBALANCEARRAY = 65552;               // color balance values
  TIFFTAG_DCSCORRECTMATRIX = 65553;              // color correction values
  TIFFTAG_DCSGAMMA = 65554;                      // gamma value
  TIFFTAG_DCSTOESHOULDERPTS = 65555;             // toe & shoulder points
  TIFFTAG_DCSCALIBRATIONFD = 65556;              // calibration file desc
  // Note: quality level is on the ZLIB 1-9 scale. Default value is -1
  TIFFTAG_ZIPQUALITY = 65557;                    // compression quality level
  TIFFTAG_PIXARLOGQUALITY = 65558;               // PixarLog uses same scale

  // TIFF data types
  TIFF_NOTYPE = 0;                               // placeholder
  TIFF_BYTE = 1;                                 // 8-bit unsigned integer
  TIFF_ASCII = 2;                                // 8-bit bytes w/ last byte null
  TIFF_SHORT = 3;                                // 16-bit unsigned integer
  TIFF_LONG = 4;                                 // 32-bit unsigned integer
  TIFF_RATIONAL = 5;                             // 64-bit unsigned fraction
  TIFF_SBYTE = 6;                                // 8-bit signed integer
  TIFF_UNDEFINED = 7;                            // 8-bit untyped data
  TIFF_SSHORT = 8;                               // 16-bit signed integer
  TIFF_SLONG = 9;                                // 32-bit signed integer
  TIFF_SRATIONAL = 10;                           // 64-bit signed fraction
  TIFF_FLOAT = 11;                               // 32-bit IEEE floating point
  TIFF_DOUBLE = 12;                              // 64-bit IEEE floating point

  TIFF_BIGENDIAN = $4D4D;
  TIFF_LITTLEENDIAN = $4949;

  TIFF_VERSION = 42;
  
//----------------------------------------------------------------------------------------------------------------------

constructor TTIFFGraphic.Create;

begin
  inherited Create;
  PixelFormat := pf24bit;
  FInternalPalette := Palette;
end;

//----------------------------------------------------------------------------------------------------------------------

destructor TTIFFGraphic.Destroy;

begin
  inherited;
end;

//----------------------------------------------------------------------------------------------------------------------

function TTIFFGraphic.FindIFD(Tag: Cardinal; var Index: Cardinal): Boolean;

// looks through the currently loaded IFD for the entry indicated by Tag;
// returns True and the index of the entry in Index if the entry is there
// otherwise the result is False and Index undefined
// Note: The IFD is sorted so we can use a binary search here.

var
  L, H, I, C: Integer;

begin
  Result := False;
  L := 0;
  H := High(FIFD);
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := Integer(FIFD[I].Tag) - Integer(Tag);
    if C < 0 then L := I + 1
             else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        L := I;
      end;
    end;
  end;
  Index := L;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTIFFGraphic.GetValueList(Stream: TStream; Tag: Cardinal; var Values: TCardinalArray);

// returns the values of the IFD entry indicated by Tag

const
  DataTypeToSize: array[TIFF_NOTYPE..TIFF_SLONG] of Byte = (0, 1, 1, 2, 4, 0, 1, 0, 2, 4);

var
  Index,
  Value: Cardinal;
  I: Integer;

begin
  Values := nil;
  if FindIFD(Tag, Index) then 
  begin
    // prepare value list
    SetLength(Values, FIFD[Index].DataLength);
    if FIFD[Index].DataLength = 1 then Values[0] := FIFD[Index].Offset
                                  else
    begin
      Stream.Position := FBasePosition + FIFD[Index].Offset;
      for I := 0 to High(Values) do
      begin
        Stream.Read(Value, DataTypeToSize[FIFD[Index].DataType]);
        case FIFD[Index].DataType of
          TIFF_BYTE:
            Value := Byte(Value);
          TIFF_SHORT,
          TIFF_SSHORT:
            begin
              if FHeader.ByteOrder = TIFF_BIGENDIAN then Value := Swap(Word(Value))
                                                    else Value := Word(Value);
            end;
          TIFF_LONG,
          TIFF_SLONG:
            if FHeader.ByteOrder = TIFF_BIGENDIAN then Value := SwapLong(Value);
        end;
        Values[I] := Value;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TTIFFGraphic.GetValue(Tag: Cardinal; Default: Cardinal = 0): Cardinal;

// returns the value of the IFD entry indicated by Tag or the default value if the entry is not there

var
  Index: Cardinal;

begin
  if not FindIFD(Tag, Index) then Result := Default
                             else
  begin
    Result := FIFD[Index].Offset;
    // if the data length is > 1 then Offset is a real offset into the stream,
    // otherwise it is the value itself and must be shortend depending on the data type
    if FIFD[Index].DataLength = 1 then
    begin
      case FIFD[Index].DataType of
        TIFF_BYTE:
          Result := Byte(Result);
        TIFF_SHORT,
        TIFF_SSHORT:
          Result := Word(Result);
        TIFF_LONG,
        TIFF_SLONG: // nothing to do
          ;
      else
        Result := Default;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TTIFFGraphic.GetValueLength(Tag: Cardinal; Default: Cardinal = 1): Cardinal;

// returns the number of values of the IFD entry indicated by Tag or the default value if the entry is not there

var
  Index: Cardinal;

begin
  if not FindIFD(Tag, Index) then Result := Default
                             else
    case FIFD[Index].DataType of
      TIFF_BYTE:
        Result := Byte(FIFD[Index].DataLength);
      TIFF_SHORT,
      TIFF_SSHORT:
        Result := Word(FIFD[Index].DataLength);
      TIFF_LONG,
      TIFF_SLONG:
        Result := FIFD[Index].DataLength;
    else
      Result := Default;
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTIFFGraphic.SwapIFD;

// swap the member fields of all entries of the currently loaded IFD from big endian to little endian

var
  I: Integer;
    
begin
  for I := 0 to High(FIFD) do
    with FIFD[I] do
    begin
      Tag := Swap(Tag);
      DataType := Swap(DataType);
      DataLength := SwapLong(DataLength);
      case DataType of
        TIFF_SHORT,
        TIFF_SSHORT:
          if DataLength > 1 then Offset := SwapLong(Offset)
                            else Offset := Swap(Word(Offset));
        TIFF_LONG,
        TIFF_SLONG:
          Offset := SwapLong(Offset);
      else
        // should never happen, but just in case...
        Offset := 0;
      end;
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTIFFGraphic.LoadFromStream(Stream: TStream);

var
  IFDCount: Word;
  RowsPerStrip,
  BitsPerSample: TCardinalArray;
  PhotometricInterpretation,
  BitsPerPixel,
  SamplesPerPixel,
  ExtraSamples: Byte;
  Compression: Word;
  StripCount,
  StripOffsets,
  StripByteCounts: Cardinal;
  Stripe,
  CurrentLine: Integer;
  Buffer,
  Run: PChar;
  Pixels,
  EncodedData: Pointer;
  Offsets,
  ByteCounts: TCardinalArray;
  ColorMap: Cardinal;

  StripSize,
  RowSize: Cardinal;
  Decoder: TDecoder;

  // dynamically assigned handlers
  Deprediction: procedure(P: Pointer; Count: Cardinal);
  ColorConversion: procedure(Source, Target: Pointer; BitsPerSample: Byte; Count: Cardinal);

begin
  Handle := 0;
  ColorConversion := nil;
  Deprediction := nil;
  Decoder := nil;

  try
    // we need to keep the current stream position because all position information
    // are relative to this one
    FBasePosition := Stream.Position;
    Stream.ReadBuffer(FHeader, SizeOf(FHeader));
    if FHeader.ByteOrder = TIFF_BIGENDIAN then
    begin
      FHeader.Version := Swap(FHeader.Version);
      FHeader.FirstIFD := SwapLong(FHeader.FirstIFD);
    end;

    if FHeader.Version <> TIFF_VERSION then raise Exception.Create('Invalid TIFF file.');

    // Note: currently only the first image in a TIFF will be loaded!
  
    // read data of the first image file directory (IFD)
    Stream.Position := FBasePosition + FHeader.FirstIFD;
    Stream.ReadBuffer(IFDCount, SizeOf(IFDCount));
    if FHeader.ByteOrder = TIFF_BIGENDIAN then IFDCount := Swap(IFDCount);
    SetLength(FIFD, IFDCount);
    Stream.ReadBuffer(FIFD[0], IFDCount * SizeOf(TIFDEntry));
    if FHeader.ByteOrder = TIFF_BIGENDIAN then SwapIFD;

    // --- read the data of the directory which are needed to actually load the image:

    // photometric interpretation determines the color space (RGB, RGBA, CMYK, CIE L*a*b* etc.)
    PhotometricInterpretation := GetValue(TIFFTAG_PHOTOMETRIC);

    // data organization
    StripCount := GetValueLength(TIFFTAG_STRIPOFFSETS);
    GetValueList(Stream, TIFFTAG_ROWSPERSTRIP, RowsPerStrip);

    StripOffsets := GetValue(TIFFTAG_STRIPOFFSETS);
    StripByteCounts := GetValue(TIFFTAG_STRIPBYTECOUNTS);
    // number of color components per pixel (1 for b&w, 16 and 256 colors, 3 for RGB, 4 for CMYK etc.)
    SamplesPerPixel := GetValue(TIFFTAG_SAMPLESPERPIXEL, 1);
    // number of bits per color component
    GetValueList(Stream, TIFFTAG_BITSPERSAMPLE, BitsPerSample);
    if Length(BitsPerSample) = 0 then
    begin
      // set a default value
      SetLength(BitsPerSample, 1);
      BitsPerSample[0] := 1;
    end;
    // currently all bits per sample values are equal
    BitsPerPixel := BitsPerSample[0] * SamplesPerPixel;

    // positions and lengths of each strip in the image
    SetLength(Offsets, StripCount);
    SetLength(ByteCounts, StripCount);
    if StripCount > 1 then
    begin
      Stream.Position := FBasePosition + StripOffsets;
      Stream.ReadBuffer(Offsets[0], 4 * StripCount);
      if FHeader.ByteOrder = TIFF_BIGENDIAN then SwapLong(@Offsets[0], StripCount);
      Stream.Position := FBasePosition + StripByteCounts;
      Stream.ReadBuffer(ByteCounts[0], 4 * StripCount);
      if FHeader.ByteOrder = TIFF_BIGENDIAN then SwapLong(@ByteCounts[0], StripCount);
    end
    else
    begin
      Offsets[0] := StripOffsets;
      ByteCounts[0] := StripByteCounts;
    end;

    // determine pixelformat
    ExtraSamples := GetValue(TIFFTAG_EXTRASAMPLES);
    case SamplesPerPixel - ExtraSamples of
      1: // b&w and palette images
        begin
          case BitsPerSample[0] of
            1: // b&w
              PixelFormat := pf1Bit;
            4: // 16 colors or 4 bit grayscale
              PixelFormat := pf4Bit;
            8,
            16: // 256 colors or 8 bit grayscale
              begin
                // "16 bits per channel" is a format e.g. Photoshop allows to use
                PixelFormat := pf8Bit;
                if BitsPerSample[0] = 16 then ColorConversion := Gray16;
              end;
          end;

          // build a palette
          if PhotometricInterpretation = PHOTOMETRIC_PALETTE then
          begin
            ColorMap := GetValue(TIFFTAG_COLORMAP);
            Stream.Position := FBasePosition + ColorMap;
            // load as many entries a defined by color depth
            // (3 components each (r,g,b) and two bytes per component)
            Stream.ReadBuffer(FPalette[0] , 3 * 2 * (1 shl BitsPerPixel));
          end;
          // for b&w and grayscale images an implicit palette is needed
          // (without PhotometricInterpretation telling this)
          if FHeader.ByteOrder = TIFF_BIGENDIAN then SwapShort(@FPalette[0], 3 * (1 shl BitsPerPixel));
          MakePalette(BitsPerPixel, PhotometricInterpretation);
        end;
      3: // RGB
        begin
          case PhotometricInterpretation of
            PHOTOMETRIC_RGB:
              begin
                if ExtraSamples >= 1 then
                begin
                  // RGB with alpha channel
                  PixelFormat := pf32Bit;
                  ColorConversion := RGBA2BGRA;
                end
                else
                begin
                  // straight RGB format
                  PixelFormat := pf24Bit;
                  ColorConversion := RGB2BGR;
                end;
              end;
            PHOTOMETRIC_YCBCR: // CCIR 601
              begin
                PixelFormat := pf24Bit;
                // unsupported color conversion
              end;
            PHOTOMETRIC_CIELAB: // 1976 CIE L*a*b*
              begin
                PixelFormat := pf24Bit;
                ColorConversion := CIELAB2BGR;
              end;
          end;
        end;
      4: // RGBA, CMYK etc.
        begin
          case PhotometricInterpretation of
            PHOTOMETRIC_RGB:
              begin
                PixelFormat := pf32Bit;
                ColorConversion := RGBA2BGRA;
              end;
            PHOTOMETRIC_SEPARATED: // CMYK
              begin
                PixelFormat := pf24Bit;
                ColorConversion := CMYK2BGR;
              end;
          end;
        end;
    else
      // every other case
      PixelFormat := pfDevice;
    end;

    // now that the pixel format is set we can also set the (possibly large) image dimensions
    Width := GetValue(TIFFTAG_IMAGEWIDTH);
    Height := GetValue(TIFFTAG_IMAGELENGTH);
    if (Width = 0) or (Height = 0) then raise Exception.Create('Invalid TIFF file.');

    // intermediate buffer for data
    RowSize := (BitsPerPixel * Width + 7) div 8;
    // some images rely on the default size ($FFFFFFFF) if only one stripe is in the image,
    // make sure there's a valid value also in this case
    if StripCount = 1 then
    begin
      SetLength(RowsPerStrip, 1);
      RowsPerStrip[0] := Height;
    end;

    // determine prediction scheme
    case GetValue(TIFFTAG_PREDICTOR) of
      PREDICTION_HORZ_DIFFERENCING: // currently only one prediction scheme is defined
        case SamplesPerPixel of
          4:
            Deprediction := Depredict4;
          3:
            Deprediction := Depredict3;
        else
          Deprediction := Depredict1;
        end;
    end;

    // create decompressor for the image
    Compression := GetValue(TIFFTAG_COMPRESSION);
    case Compression of
      COMPRESSION_NONE:
        ;
      COMPRESSION_LZW:
        Decoder := TTIFFLZW.Create;
      COMPRESSION_PACKBITS:
        Decoder := TPackbitsRLE.Create;
    else
      {COMPRESSION_CCITTRLE
      COMPRESSION_CCITTFAX3
      COMPRESSION_CCITTFAX4
      COMPRESSION_OJPEG
      COMPRESSION_JPEG
      COMPRESSION_NEXT
      COMPRESSION_CCITTRLEW
      COMPRESSION_THUNDERSCAN
      COMPRESSION_IT8CTPAD
      COMPRESSION_IT8LW
      COMPRESSION_IT8MP
      COMPRESSION_IT8BL
      COMPRESSION_PIXARFILM
      COMPRESSION_PIXARLOG
      COMPRESSION_DEFLATE
      COMPRESSION_DCS
      COMPRESSION_JBIG}
      raise Exception.Create('TIFF: Unknown compression scheme');
    end;

    // go for each strip in the image (which might contain more than one line)
    CurrentLine := 0;
    for Stripe := 0 to StripCount - 1 do
    begin
      Stream.Position := FBasePosition + Offsets[Stripe];
      if Stripe < Length(RowsPerStrip) then StripSize := RowSize * RowsPerStrip[Stripe]
                                       else StripSize := RowSize * RowsPerStrip[High(RowsPerStrip)];
      GetMem(Buffer, StripSize);

      // decompress strip if necessary
      if Assigned(Decoder) then
      begin
        GetMem(EncodedData, ByteCounts[Stripe]);
        Stream.Read(EncodedData^, ByteCounts[Stripe]);
        Decoder.Decode(EncodedData, Buffer, ByteCounts[Stripe], StripSize);
        FreeMem(EncodedData);
      end
      else
      begin
        Stream.Read(Buffer^, StripSize);
      end;

      Run := Buffer;
      // go for each line (row) in the strip
      while (CurrentLine < Height) and ((Run - Buffer) < Integer(StripSize)) do
      begin
        Pixels := ScanLine[CurrentLine];

        // depredict strip if necessary
        if Assigned(Deprediction) then Deprediction(Run, Width - 1);
        // any color conversion comes last
        if Assigned(ColorConversion) then ColorConversion(Run, Pixels, BitsPerSample[0], Width * SamplesPerPixel)
                                     else Move(Run^, Pixels^, RowSize);
        Inc(PChar(Run), RowSize);
        Inc(CurrentLine);
      end;
      FreeMem(Buffer);
    end;
  finally
    Decoder.Free;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTIFFGraphic.SaveToStream(Stream: TStream);

begin
  //SaveToStream(Stream, True);
end;

//----------------------------------------------------------------------------------------------------------------------

{procedure TTIFFGraphic.SaveToStream(Stream: TStream; Compressed: Boolean);

var
  Dummy: Cardinal;
  I, J: Word;
  Offset: Cardinal;
  BMPInfo: PBitmapInfo;
  Buffer,
  BufHead,
  CodeBuffer: Pointer;
  PaletteCount: Word;
  Usage: Integer;
  Encoder: TLZW;
  BCounts: Cardinal;
  offOffset,
  bcOffset,
  TagOffset,
  RowSize:DWord;

begin
  Offset := 0;
  offOffset := 0;
  bcOffset := 0;
  FIFD := TIFD.WriteCreate(Self, Compressed);
  Dummy := TIFF_LITTLEENDIAN;
  Stream.WriteBuffer(Dummy, 2);
  Inc(Offset, 2);
  Dummy := TIFF_VERSION;
  Stream.WriteBuffer(Dummy, 2);
  Inc(Offset, 2);
  Dummy := 8;
  Stream.WriteBuffer(Dummy, 4);
  Inc(Offset, 4);
  Dummy := TIFD(FIFD).FTagCount;
  Stream.WriteBuffer(Dummy, 2);
  Inc(Offset, 2);
  TagOffset := Offset;
  Stream.WriteBuffer(TIFD(FIFD).FTags[0], 12 * TIFD(FIFD).FTagCount);
  Inc(Offset, 12 * TIFD(FIFD).FTagCount);
  Dummy := 0;
  Stream.WriteBuffer(Dummy, 4);
  Inc(Offset, 4);
  
  if TIFD(FIFD).FStripCount > 1 then
  begin
    offOffset := Offset;
    Stream.WriteBuffer(TIFD(FIFD).FOffsets[0], 4 * TIFD(FIFD).FStripCount);
    Inc(Offset, 4 * TIFD(FIFD).FStripCount);
    bcOffSet := Offset;
    Stream.WriteBuffer(TIFD(FIFD).FByteCounts[0], 4 * TIFD(FIFD).FStripCount);
  end;

  case TIFD(FIFD).FBitsPerPixel of
    1:
      PaletteCount := 2;
    4:
      PaletteCount := 16;
    8:
      PaletteCount := 256;
    16,
    32:
      PaletteCount := 3;
  else
    PaletteCount := 0;
  end;

  if TIFD(FIFD).FBitsPerPixel = 1 then GetMem(BMPInfo, SizeOf(TBitMapInfoHeader) + PaletteCount * SizeOf(TRGBQuad))
                                  else GetMem(BMPInfo, SizeOf(TBitMapInfoHeader) + 2 * PaletteCount);

  with TIFD(FIFD), BMPInfo.bmiHeader do
  begin
    biSize := SizeOf(TBitMapInfoHeader);
    biWidth := Width;
    biHeight := -FLength;
    biPlanes := 1;
    biCompression := 0;
    biSizeImage := 0;
    biXPelsPerMeter := 0;
    biYPelsPerMeter := 0;
    biBitCount := FBitsPerPixel;
    biClrUsed := 0;
    biClrImportant := 0;
  end;

  case TIFD(FIFD).FBitsPerPixel of
    1:
      ScrambleBitmapPalette(TIFD(FIFD).FBitsPerPixel, TIFD(FIFD).FPhotometricInterpretation, BMPInfo);
    4:
      ScramblePalette(TIFD(FIFD).FBitsPerPixel, TIFD(FIFD).FPhotometricInterpretation);
    8:
      ScramblePalette(TIFD(FIFD).FBitsPerPixel, TIFD(FIFD).FPhotometricInterpretation);
  end;
  if TIFD(FIFD).FBitsPerPixel in [1, 24] then Usage := DIB_RGB_COLORS
                                         else Usage := DIB_PAL_COLORS;
  RowSize := (TIFD(FIFD).FBitsPerPixel * Width + 7) div 8;

  for J := 0 to TIFD(FIFD).FStripCount - 1 do
  begin
    I := TIFD(FIFD).FRowsPerStrip * J;
    BCounts := TIFD(FIFD).FByteCounts[J];
    Buffer := AllocMem(BCounts);
    BufHead := Buffer;
    while (I <= Height - 1) and (I div TIFD(FIFD).FRowsPerStrip <= J) do
    begin
      GetDIBits(Canvas.Handle, Handle, Height - I - 1, 1, Buffer, BMPInfo^, Usage);
      Inc(PByte(Buffer), RowSize);
      Inc(I);
    end;
    Buffer := BufHead;

    if TIFD(FIFD).FBitsPerPixel = 24 then
    begin
      if J < TIFD(FIFD).FStripCount - 1 then
        SwapRGB2BGR(Buffer, Cardinal(Width) * TIFD(FIFD).FRowsPerStrip)
                                        else
        SwapRGB2BGR(Buffer, Cardinal(Width) * (Cardinal(Height) -
                            TIFD(FIFD).FRowsPerStrip * (TIFD(FIFD).FStripCount - 1)));
    end;

    if Compressed then
    begin
      Encoder := TLZW.Create;
      BCounts := TIFD(FIFD).FByteCounts[J];
      CodeBuffer := AllocMem((3 * BCounts) div 2);
      Encoder.EncodeLZW(Buffer, CodeBuffer, TIFD(FIFD).FByteCounts[J]);
      if J < TIFD(FIFD).FStripCount - 1 then
        TIFD(FIFD).FOffsets[J + 1] :=  TIFD(FIFD).FOffsets[J] + TIFD(FIFD).FByteCounts[J];
      Stream.Position := TIFD(FIFD).FOffsets[J];
      Stream.WriteBuffer(CodeBuffer^, TIFD(FIFD).FByteCounts[J]);
      if Odd(TIFD(FIFD).FOffsets[J] + TIFD(FIFD).FByteCounts[J]) then
      begin
        Dummy := 0;
        Stream.WriteBuffer(Dummy, 1);
        If J < TIFD(FIFD).FStripCount - 1 then TIFD(FIFD).FOffsets[J + 1] :=  TIFD(FIFD).FOffsets[J + 1] + 1;
      end;
      FreeMem(CodeBuffer);
      Encoder.Free;
    end
    else
    begin
      Stream.Position := TIFD(FIFD).FOffsets[J];
      Stream.WriteBuffer(Buffer^, TIFD(FIFD).FByteCounts[J]);
    end;
    FreeMem(Buffer);
  end;

  if Compressed then
  begin
    if TIFD(FIFD).FStripCount > 1 Then
    begin
      Stream.Position := offOffset;
      Stream.WriteBuffer(TIFD(FIFD).FOffsets[0], 4 * TIFD(FIFD).FStripCount);
      Stream.Position := bcOffSet;
      Stream.WriteBuffer(TIFD(FIFD).FByteCounts[0], 4 * TIFD(FIFD).FStripCount);
    end
    else
    begin
      TIFD(FIFD).FTags[11].DataOrPointer := TIFD(FIFD).FByteCounts[0];
      Stream.Position := TagOffset;
      Stream.WriteBuffer(TIFD(FIFD).FTags[0], 12 * TIFD(FIFD).FTagCount);
    end;
  end;

  FreeMem(BMPInfo);
  FIFD.Free;
end;
}
//----------------------------------------------------------------------------------------------------------------------

procedure TTIFFGraphic.SaveToTifFile(FileName: String; Compressing: Boolean);

begin

end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTIFFGraphic.MakePalette(BPS: Byte; Mode: Integer);

var
  Pal: PLogPalette;
  hpal: HPALETTE;
  I: Integer;
  EntryCount: Word;
  
begin
  case BPS of
    1:
      EntryCount := 1;
    4:
      EntryCount := 15;
  else
    EntryCount := 255;
  end;

  GetMem(Pal, SizeOf(TLogPalette) + SizeOf(TPaletteEntry) * EntryCount);
  try
    Pal.palVersion := $300;
    Pal.palNumEntries := 1 + EntryCount;
    case BPS of
      1:
        case Mode of
          PHOTOMETRIC_MINISWHITE: // min value is white
            begin
              for I := 0 to EntryCount do
              begin
                Pal.palPalEntry[I].peRed := 255 * (1 - I);
                Pal.palPalEntry[I].peGreen  := 255 * (1 - I);
                Pal.palPalEntry[I].peBlue := 255 * (1 - I);
                Pal.palPalEntry[I].peFlags := 0;
              end;
            end;
          PHOTOMETRIC_MINISBLACK: // min value is black
            begin
              for I := 0 to EntryCount do
              begin
                Pal.palPalEntry[I].peRed := 255 * I;
                Pal.palPalEntry[I].peGreen  := 255 * I;
                Pal.palPalEntry[I].peBlue := 255 * I;
                Pal.palPalEntry[I].peFlags := 0;
              end;
            end;
        end;
      4:
        case Mode of
          PHOTOMETRIC_MINISWHITE:
            begin
              for I := 0 to EntryCount do
              begin
                Pal.palPalEntry[EntryCount - I].peRed  := 16 * I;
                Pal.palPalEntry[EntryCount - I].peGreen  := 16 * I;
                Pal.palPalEntry[EntryCount - I].peBlue  := 16 * I;
                Pal.palPalEntry[EntryCount - I].peFlags := 0;
              end;
            end;
          PHOTOMETRIC_MINISBLACK:
            begin
              for I := 0 to EntryCount do
              begin
                Pal.palPalEntry[I].peRed  := 16 * I;
                Pal.palPalEntry[I].peGreen  := 16 * I;
                Pal.palPalEntry[I].peBlue  := 16 * I;
                Pal.palPalEntry[I].peFlags := 0;
              end;
            end;
          PHOTOMETRIC_PALETTE:
            for I := 0 to EntryCount do
            begin
              Pal.palPalEntry[I].peRed := FPalette[0 * 16 + I] shr 8;
              Pal.palPalEntry[I].peGreen := FPalette[1 * 16 + I] shr 8;
              Pal.palPalEntry[I].peBlue := FPalette[2 * 16 + I] shr 8;
              Pal.palPalEntry[I].peFlags := 0;
            end;
        end;
    else
      // 8 and more bits per sample
      case Mode  of
        PHOTOMETRIC_MINISWHITE:
          for I :=  0 to EntryCount do
          begin
            Pal.palPalEntry[EntryCount - I].peRed := I;
            Pal.palPalEntry[EntryCount - I].peGreen := I;
            Pal.palPalEntry[EntryCount - I].peBlue := I;
            Pal.palPalEntry[EntryCount - I].peFlags := 0;
          end;
        PHOTOMETRIC_MINISBLACK:
          for I :=  0 to EntryCount do
          begin
            Pal.palPalEntry[I].peRed := I;
            Pal.palPalEntry[I].peGreen := I;
            Pal.palPalEntry[I].peBlue := I;
            Pal.palPalEntry[I].peFlags := 0;
          end;
        PHOTOMETRIC_PALETTE:
          for I := 0 to EntryCount do
          begin
            Pal.palPalEntry[I].peRed := FPalette[0 * 256 + I] shr 8;
            Pal.palPalEntry[I].peGreen := FPalette[1 * 256 + I] shr 8;
            Pal.palPalEntry[I].peBlue := FPalette[2 * 256 + I] shr 8;
            Pal.palPalEntry[I].peFlags := 0;
          end;
      end;
    end;
    hpal := CreatePalette(Pal^);
    if hpal <> 0 then Palette := hpal;
  finally
    FreeMem(Pal);
  end;
end;

//----------------- TTargaGraphic --------------------------------------------------------------------------------------

//  FILE STRUCTURE FOR THE ORIGINAL TRUEVISION TGA FILE
//    FIELD 1: NUMBER OF CHARACTERS IN ID FIELD (1 BYTES)
//    FIELD 2: COLOR MAP TYPE (1 BYTES)
//    FIELD 3: IMAGE TYPE CODE (1 BYTES)
//      = 0  NO IMAGE DATA INCLUDED
//      = 1  UNCOMPRESSED, COLOR-MAPPED IMAGE
//      = 2  UNCOMPRESSED, TRUE-COLOR IMAGE
//      = 3  UNCOMPRESSED, BLACK AND WHITE IMAGE
//      = 9  RUN-LENGTH ENCODED COLOR-MAPPED IMAGE
//      = 10 RUN-LENGTH ENCODED TRUE-COLOR IMAGE
//      = 11 RUN-LENGTH ENCODED BLACK AND WHITE IMAGE
//    FIELD 4: COLOR MAP SPECIFICATION (5 BYTES)
//      4.1: COLOR MAP ORIGIN (2 BYTES)
//      4.2: COLOR MAP LENGTH (2 BYTES)
//      4.3: COLOR MAP ENTRY SIZE (1 BYTES)
//    FIELD 5:IMAGE SPECIFICATION (10 BYTES)
//      5.1: X-ORIGIN OF IMAGE (2 BYTES)
//      5.2: Y-ORIGIN OF IMAGE (2 BYTES)
//      5.3: WIDTH OF IMAGE (2 BYTES)
//      5.4: HEIGHT OF IMAGE (2 BYTES)
//      5.5: IMAGE PIXEL SIZE (1 BYTE)
//      5.6: IMAGE DESCRIPTOR BYTE (1 BYTE)
//        bit 0..3: attribute bits per pixel
//        bit 4..5: image orientation:
//          0: bottom left
//          1: bottom right
//          2: top left
//          3: top right
//        bit 6..7: interleaved flag
//          0: two way (even-odd) interleave (e.g. IBM Graphics Card Adapter), obsolete
//          1: four way interleave (e.g. AT&T 6300 High Resolution), obsolete
//    FIELD 6: IMAGE ID FIELD (LENGTH SPECIFIED BY FIELD 1)
//    FIELD 7: COLOR MAP DATA (BIT WIDTH SPECIFIED BY FIELD 4.3 AND
//             NUMBER OF COLOR MAP ENTRIES SPECIFIED IN FIELD 4.2)
//    FIELD 8: IMAGE DATA FIELD (WIDTH AND HEIGHT SPECIFIED IN FIELD 5.3 AND 5.4)

const
  TARGA_NO_COLORMAP = 0;
  TARGA_COLORMAP = 1;

  TARGA_EMPTY_IMAGE = 0;
  TARGA_INDEXED_IMAGE = 1;
  TARGA_TRUECOLOR_IMAGE = 2;
  TARGA_BW_IMAGE = 3;
  TARGA_INDEXED_RLE_IMAGE = 9;
  TARGA_TRUECOLOR_RLE_IMAGE = 10;
  TARGA_BW_RLE_IMAGE = 11;

type
  TTargaHeader = packed record
    IDLength,
    ColorMapType,
    ImageType: Byte;
    ColorMapOrigin,
    ColorMapSize: Word;
    ColorMapEntrySize: Byte;
    XOrigin, YOrigin,
    Width, Height: Word;
    PixelSize: Byte;            //ÑÕÉ«Î»Êý
    ImageDescriptor: Byte;
  end;


//----------------------------------------------------------------------------------------------------------------------

procedure TTargaGraphic.LoadFromResourceName(Instance: THandle; const ResName: String);

var
  Stream: TResourceStream;

begin
  Stream := TResourceStream.Create(Instance, ResName, RT_RCDATA);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTargaGraphic.LoadFromResourceID(Instance: THandle; ResID: Integer);

var
  Stream: TResourceStream;
  
begin
  Stream := TResourceStream.CreateFromID(Instance, ResID, RT_RCDATA);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTargaGraphic.LoadFromStream(Stream: TStream);

var
  RLEBuffer: Pointer;
  I: Integer;
  LineSize: Integer;
  LineBuffer: Pointer;
  ReadLength: Integer;
  LogPalette: TMaxLogPalette;
//  Temp: Byte;
  Color16: Word;
  Header: TTargaHeader;
//  FlipH, ml: need to implement horizontal flipping of image
  FlipV: Boolean;

begin

  Stream.Read(Header, SizeOf(Header));
  // mirror image so that the leftmost pixel becomes rightmost
//  FlipH := (Header.ImageDescriptor and $10) <> 0;
  // mirror image so that the topmost pixel becomes bottommost
  FlipV := (Header.ImageDescriptor and $20) <> 0;
  Header.ImageDescriptor := Header.ImageDescriptor and $F;
  if Header.IDLength > 0 then
  begin
    SetLength(FImageID, Header.IDLength);
    Stream.Read(FImageID[1], Header.IDLength);
  end
  else FImageID := '';

  case Header.PixelSize of
    8: PixelFormat := pf8Bit;
    15: PixelFormat := pf15Bit;
    16: PixelFormat := pf16Bit; // actually, 16 bit are meant being 15 bit
    24: PixelFormat := pf24Bit;
    32: PixelFormat := pf32Bit;
  end;

  if (Header.ColorMapType = 1) or (Header.ImageType in [TARGA_BW_IMAGE, TARGA_BW_RLE_IMAGE]) then
  begin
    // read palette entries and create a palette
    FillChar(LogPalette, SizeOf(LogPalette), 0);
    with LogPalette do
    begin
      palVersion := $300;
      palNumEntries := Header.ColorMapSize;

      if Header.ImageType in [TARGA_BW_IMAGE, TARGA_BW_RLE_IMAGE] then
      begin
        palNumEntries := 256;
        // black&white images implicitely use a grey scale ramp
        for I := 0 to 255 do
        begin
          palPalEntry[I].peBlue := I;
          palPalEntry[I].peGreen := I;
          palPalEntry[I].peRed := I;
        end;
      end
      else
        case Header.ColorMapEntrySize of
          32:
            for I := 0 to Header.ColorMapSize - 1 do
            begin
              Stream.Read(palPalEntry[I].peBlue, 1);
              Stream.Read(palPalEntry[I].peGreen, 1);
              Stream.Read(palPalEntry[I].peRed, 1);
              Stream.Read(palPalEntry[I].peFlags, 1); // ignore alpha value
            end;
          24:
            for I := 0 to Header.ColorMapSize - 1 do
            begin
              Stream.Read(palPalEntry[I].peBlue, 1);
              Stream.Read(palPalEntry[I].peGreen, 1);
              Stream.Read(palPalEntry[I].peRed, 1);
            end;
        else
          if PixelFormat = pf15Bit then begin
            // 15 and 16 bits per color map entry (handle both like 555 color format
            // but make 8 bit from 5 bit per color component)
            for I := 0 to Header.ColorMapSize - 1 do
            begin
              Stream.Read(Color16, 2);
              palPalEntry[I].peBlue := (Color16 and $1F) shl 3;
              palPalEntry[I].peGreen := (Color16 and $3E0) shr 2;
              palPalEntry[I].peRed := (Color16 and $7C00) shr 7;
            end;
          end else begin
            for I := 0 to Header.ColorMapSize - 1 do
            begin
              Stream.Read(Color16, 2);
              palPalEntry[I].peBlue := (Color16 and $1F) shl 3;
              palPalEntry[I].peGreen := (Color16 and $7E0) shr 3;
              palPalEntry[I].peRed := (Color16 and $F800) shr 8;
            end;
          end;
        end;
    end;
    Palette := CreatePalette(PLogPalette(@LogPalette)^);
  end;

  Width := Header.Width;
  Height := Header.Height;
  LineSize := Width * (Header.PixelSize div 8);

  TraceString(IntToStr(Header.PixelSize));  

  case Header.ImageType of
    TARGA_EMPTY_IMAGE: ;
      // nothing to do here
    TARGA_BW_IMAGE,
    TARGA_INDEXED_IMAGE,
    TARGA_TRUECOLOR_IMAGE:
      begin
        for I := 0 to Height - 1 do
        begin
          if FlipV then LineBuffer := ScanLine[I]
                   else LineBuffer := ScanLine[Header.Height - (I + 1)];
          if Stream.Read(LineBuffer^, LineSize) <> LineSize then raise Exception.Create('Targa: invalid image');
        end;
      end;
    TARGA_BW_RLE_IMAGE,
    TARGA_INDEXED_RLE_IMAGE,
    TARGA_TRUECOLOR_RLE_IMAGE:
      begin
        RLEBuffer := AllocMem(2 * LineSize);
        for I := 0 to Height - 1 do
        begin
          if FlipV then LineBuffer := ScanLine[I]
                    else LineBuffer := ScanLine[Header.Height - (I + 1)];
          ReadLength := Stream.Read(RLEBuffer^, 2 * LineSize);
          Stream.Position := Stream.Position - ReadLength + DecodeRLE(RLEBuffer, LineBuffer, LineSize, Header.PixelSize);
        end;
        FreeMem(RLEBuffer);
      end;
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTargaGraphic.SaveToStream(Stream: TStream);

begin                   
  SaveToStream(Stream, True);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTargaGraphic.SaveToStream(Stream: TStream; Compressed: Boolean);

// The format of the image to be saved depends on the current properties of the bitmap not
// on the values which may be set in the header during a former load.

var
  RLEBuffer: Pointer;
  I: Integer;
  LineSize: Integer;
  WriteLength: Integer;
  LogPalette: TMaxLogPalette;
  BPP: Byte;
  Header: TTargaHeader;

begin
  // prepare color depth
  case PixelFormat of
    pf1Bit,
    pf4Bit:
      if MessageDlg('Targa image: 1 or 4 bit color depth not allowed. Convert to 256 colors?',
                     mtWarning, mbOKCancel, 0) = idOK then
      begin
        PixelFormat := pf8Bit;
        BPP := 1;
      end
      else Exit;
    pf8Bit:
      BPP := 1;
    pf15Bit,
    pf16Bit:
      BPP := 2;
    pf24Bit:
      BPP := 3;
    pf32Bit:
      BPP := 4;
  else
    BPP := GetDeviceCaps(Canvas.Handle, BITSPIXEL) div 8;
  end;

  if not Empty then
  begin
    with Header do
    begin
      IDLength := Length(FImageID);
      if BPP = 1 then ColorMapType := 1
                 else ColorMapType := 0;
      if not Compressed then
        // can't distinct between a B&W and an color indexed image here, so I use always the latter
        if BPP = 1 then ImageType := TARGA_INDEXED_IMAGE
                   else ImageType := TARGA_TRUECOLOR_IMAGE
                        else
        if BPP = 1 then ImageType := TARGA_INDEXED_RLE_IMAGE
                   else ImageType := TARGA_TRUECOLOR_RLE_IMAGE;

      ColorMapOrigin := 0;
      // always save entire palette
      ColorMapSize := 256;
      // always save complete color information
      ColorMapEntrySize := 24;
      XOrigin := 0;
      YOrigin := 0;
      Width := Self.Width;
      Height := Self.Height;
      PixelSize := BPP shl 3;
      // if the image is a bottom-up DIB then indicate this in the image descriptor
      if Cardinal(Scanline[0]) > Cardinal(Scanline[1]) then ImageDescriptor := $20
                                                       else ImageDescriptor := 0;
    end;
  
    Stream.Write(Header, SizeOf(Header));
    if Header.IDLength > 0 then Stream.Write(FImageID[1], Header.IDLength);

    // store color palette if necessary
    if Header.ColorMapType = 1 then
      with LogPalette do
      begin
        // read palette entries
        GetPaletteEntries(Palette, 0, 256, palPalEntry);
        for I := 0 to 255 do
        begin
          Stream.Write(palPalEntry[I].peBlue, 1);
          Stream.Write(palPalEntry[I].peGreen, 1);
          Stream.Write(palPalEntry[I].peRed, 1);
        end;
      end;

    LineSize := Width * (Header.PixelSize div 8);

    // finally write image data
    if Compressed then
    begin
      RLEBuffer := AllocMem(2 * LineSize);
      for I := 0 to Height - 1 do
      begin
        WriteLength := EncodeRLE(ScanLine[I], RLEBuffer, Width, BPP);
        if Stream.Write(RLEBuffer^, WriteLength) <> WriteLength then
          raise Exception.Create('Targa: could not write image data');
      end;
      FreeMem(RLEBuffer);
    end
    else
    begin
      for I := 0 to Height - 1 do
        if Stream.Write(ScanLine[I]^, LineSize) <> LineSize then
          raise Exception.Create('Targa: could not write image data');
    end;
  end;
end;

//----------------- TPCXGraphic ----------------------------------------------------------------------------------------

type
  TPCXHeader = record
    FileID: Byte;                      // $0A for PCX files, $CD for SCR files
    Version: Byte;                     // 0: version 2.5; 2: 2.8 with palette; 3: 2.8 w/o palette; 5: version 3 
    Encoding: Byte;                    // 0: uncompressed; 1: RLE encoded
    BitsPerPixel: Byte;                         
    XMin,
    YMin,
    XMax,
    YMax,                              // coordinates of the corners of the image
    HRes,                              // horizontal resolution in dpi
    VRes: Word;                        // vertical resolution in dpi
    ColorMap: array[0..15] of TRGB;    // color table
    Reserved,
    ColorPlanes: Byte;                 // color planes (at most 4)
    BytesPerLine,                      // number of bytes of one line of one plane
    PaletteType: Word;                 // 1: color or b&w; 2: gray scale
    Fill: array[0..57] of Byte;
  end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPCXGraphic.LoadFromStream(Stream: TStream);

var
  Header: TPCXHeader;

  //--------------- local functions -------------------------------------------

  procedure MakePalette;

  // creates the physical palette for the image,

  var
    PCXPalette: array[0..255] of TRGB;
    Pal: TMaxLogPalette;
    hPal: HPALETTE;
    I: Integer;
    OldPos: Integer;
    Marker: Byte;

  begin
    Pal.palVersion := $300;
    if (Header.Version <> 3) or (PixelFormat = pf1Bit) then
    begin
      case PixelFormat of
        pf1Bit:
          begin
            Pal.palNumEntries := 2;
            Pal.palPalEntry[0].peRed := 0;
            Pal.palPalEntry[0].peGreen  := 0;
            Pal.palPalEntry[0].peBlue := 0;
            Pal.palPalEntry[0].peFlags := 0;
            Pal.palPalEntry[1].peRed := 255;
            Pal.palPalEntry[1].peGreen  := 255;
            Pal.palPalEntry[1].peBlue := 255;
            Pal.palPalEntry[1].peFlags := 0;
          end;
        pf4Bit:
          with Header do
          begin
            Pal.palNumEntries := 16;
            if paletteType = 2 then
            begin
              for I := 0 to 15 do
              begin
                Pal.palPalEntry[I].peRed := I * 16;
                Pal.palPalEntry[I].peGreen  := I * 16;
                Pal.palPalEntry[I].peBlue := I * 16;
                Pal.palPalEntry[I].peFlags := 0;
              end;
            end
            else
            begin
              for I := 0 to 15 do
              begin
                Pal.palPalEntry[I].peRed := ColorMap[I].R;
                Pal.palPalEntry[I].peGreen  := ColorMap[I].G;
                Pal.palPalEntry[I].peBlue := ColorMap[I].B;
                Pal.palPalEntry[I].peFlags := 0;
              end;
            end;
          end;
        pf8Bit:
          begin
            Pal.palNumEntries := 256;
            OldPos := Stream.Position;
            // 256 colors with 3 components plus one marker byte
            Stream.Position := Stream.Size - 769;
            Stream.Read(Marker, 1);
            if Marker <> $0C then
            begin
              // palette ID is wrong, perhaps gray scale?
              if Header.PaletteType = 2 then
              begin
                for I := 0 to 255 do
                begin
                  Pal.palPalEntry[I].peRed := I;
                  Pal.palPalEntry[I].peGreen := I;
                  Pal.palPalEntry[I].peBlue := I;
                  Pal.palPalEntry[I].peFlags := 0;
                end;
              end
              else Beep; // ignore palette
            end
            else
            begin
              Stream.Read(PCXPalette[0], 768);
              for I := 0 to 255 do
              begin
                Pal.palPalEntry[I].peRed := PCXPalette[I].R;
                Pal.palPalEntry[I].peGreen := PCXPalette[I].G;
                Pal.palPalEntry[I].peBlue := PCXPalette[I].B;
                Pal.palPalEntry[I].peFlags := 0;
              end;
            end;
            Stream.Position := OldPos;
          end;
      end;
      hpal := CreatePalette(PLogPalette(@Pal)^);
      if hpal <> 0 then Palette := hpal;
    end
    else
    begin
      // version 2.8 without palette information, just use the system palette
      // 256 colors will not be correct with this assignment...
      Palette := SystemPalette16;
    end;
  end;

  //--------------- end local functions ---------------------------------------

var
  PCXSize,
  Size: Cardinal;
  RawBuffer,
  DecodeBuffer: Pointer;
  Run: PByte;
  Plane1,
  Plane2,
  Plane3,
  Plane4: PByte;
  Value,
  Mask: Byte;
  Decoder: TPCXRLE;
  I, J: Integer;
  Line: PByte;
  Increment: Cardinal;

begin
  Handle := 0;
  Stream.Read(Header, SizeOf(Header));
  PCXSize := Stream.Size - Stream.Position;
  with Header do
  begin
    if not (FileID in [$0A, $CD]) then raise Exception.Create('Not a PCX or SCR file.');

    case BitsPerPixel of
      1: // b&w or 16 colors
        case ColorPlanes of
          1:
            PixelFormat := pf1Bit;
          4:
            PixelFormat := pf4Bit;
        end;
      8: // 256 colors or true color
        case ColorPlanes of
          1:
            PixelFormat := pf8Bit;
          3:
            PixelFormat := pf24Bit;
        end;
    end;

    // if none of the above compbinations were found then we have a wrong pixel format here
    if PixelFormat = pfDevice then raise Exception.Create('PCX: wrong pixel format');
    // take 256 colors palette (plus an ID byte) into account
    if PixelFormat = pf8Bit then Dec(PCXSize, 769);
    if PixelFormat <> pf24Bit then MakePalette;

    Width := Header.XMax - Header.XMin + 1;
    Height := Header.YMax - Header.YMin + 1;
                                                  
    // adjust alignment of line
    Increment := Header.ColorPlanes * Header.BytesPerLine;

    // buffer raw data
    GetMem(RawBuffer, PCXSize);
    Stream.ReadBuffer(RawBuffer^, PCXSize);
    if Encoding = 1 then
    begin
      Size := Increment * Cardinal(Height);
      GetMem(DecodeBuffer, Size);
      Decoder := TPCXRLE.Create;
      Decoder.Decode(RawBuffer, DecodeBuffer, PCXSize, Size);
      Decoder.Free;
      FreeMem(RawBuffer);
      RawBuffer := DecodeBuffer;
    end;
    Run := RawBuffer;

    for I := 0 to Height - 1 do
    begin
      Line := ScanLine[I];
      case PixelFormat of
        pf1Bit:
          Move(Run^, Line^, Width div 8);
        pf8Bit:
          Move(Run^, Line^, Width);
        pf4Bit:
          begin
            // four bitplanes planes need to be combined
            Plane1 := Run;
            PChar(Plane2) := PChar(Run) + Increment div 4;
            PChar(Plane3) := PChar(Run) + 2 * (Increment div 4);
            PChar(Plane4) := PChar(Run) + 3 * (Increment div 4);
            // number of bytes to write
            Size := Increment;
            Mask := 0;
            while Size > 0 do
            begin
              Value := 0;
              for J := 0 to 1 do
              asm
                   MOV AL, [Value]

                   MOV EDX, [Plane4]             // take the 4 MSBs from the 4 runs and build a nibble
                   SHL BYTE PTR [EDX], 1         // read MSB and prepare next run at the same time
                   RCL AL, 1                     // MSB from previous shift is in CF -> move it to AL

                   MOV EDX, [Plane3]             // now do the same with the other three runs
                   SHL BYTE PTR [EDX], 1
                   RCL AL, 1

                   MOV EDX, [Plane2]
                   SHL BYTE PTR [EDX], 1
                   RCL AL, 1

                   MOV EDX, [Plane1]
                   SHL BYTE PTR [EDX], 1
                   RCL AL, 1

                   MOV [Value], AL
              end;
              Line^ := Value;
              Inc(Line);
              Dec(Size);

              // two runs above (to construct two nibbles -> one byte), now update marker
              // to know when to switch to next byte in the planes
              Mask := (Mask + 2) mod 8;
              if Mask = 0 then
              begin
                Inc(Plane1);
                Inc(Plane2);
                Inc(Plane3);
                Inc(Plane4);
              end;
            end;
          end;
        pf24Bit:
          begin
            // three planes of colors need to be combined
            Plane1 := Run;
            PChar(Plane2) := PChar(Run) + Increment div 3;
            PChar(Plane3) := PChar(Run) + 2 * (Increment div 3);
            Size := Width;
            while Size > 0 do
            begin
              Line^ := Plane3^; Inc(Line); Inc(Plane3);
              Line^ := Plane2^; Inc(Line); Inc(Plane2);
              Line^ := Plane1^; Inc(Line); Inc(Plane1);
              Dec(Size);
            end;
          end;
      end;
      Inc(Run, Increment);
    end;

    FreeMem(RawBuffer);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPCXGraphic.SaveToStream(Stream: TStream);

begin

end;

//----------------- TPCDGraphic ----------------------------------------------------------------------------------------

const
  PCD_BEGIN_BASE16 = 8192;
  PCD_BEGIN_BASE4 = 47104;
  PCD_BEGIN_BASE = 196608;
  PCD_BEGIN_ORIENTATION = 194635;
  PCD_BEGIN = 2048;

  PCD_MAGIC = 'PCD_IPI';

//----------------------------------------------------------------------------------------------------------------------

constructor TPCDGraphic.Create;

begin
  inherited;
  FResolution := pcdBase;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPCDGraphic.LoadFromStream(Stream: TStream);

var
  FileID: array[0..6] of Char;
  Orientation: Byte; // landscape, portrait, flipped etc.
  LumaRow1,          // luminance/Y for 1. line
  LumaRow2,          // luminance/Y for 2. line
  Chroma1Row1,       // chrominance 1/Cb for 1. line
  Chroma2Row1,       // chrominance 2/Cr for 1. line
  Chroma1Row2,       // chrominance 1/Cb for 2. line
  Chroma2Row2: array[0..769] of Byte; // chrominance 2/Cr for 2. line
  Chroma1,           // chrominance 1/Cb for 2 lines
  Chroma2,           // chrominance 2/Cr for 2 lines
  Chroma3,           // chrominance 1/Cb for next 2 lines
  Chroma4: array [0..385] of Byte;   // chrominance 2/Cr for next 2 lines

  ImageWidth,
  ImageHeight: Cardinal; // dimensions of the image independant from orientation
  ImageData: Cardinal; // offset of data for a specific resolution in the stream
  Portrait,
  Flip: Boolean;
  X, Y: Integer;
  Line1,
  Line2: PByte;
  R, G, B: Integer;
  
begin
  Handle := 0;
  
  FBasePosition := Stream.Position;
  Stream.Position := FBasePosition + PCD_BEGIN;
  Stream.ReadBuffer(FileID, SizeOf(FileID));
  if FileID <> PCD_MAGIC then raise Exception.Create('PCD: wrong image format.');

  Stream.Position := FBasePosition + PCD_BEGIN_ORIENTATION;
  Stream.ReadBuffer(Orientation, SizeOf(Orientation));

  PixelFormat := pf24Bit;
  case FResolution of
    pcdBase16:
      begin
        ImageData := FBasePosition + PCD_BEGIN_BASE16;
        if (Orientation mod 4) <> 0 then
        begin
          // portrait image
          Width := 128;
          Height := 192;
        end
        else
        begin
          // landscape image
          Width := 192;
          Height := 128;
        end;
        ImageWidth := 192;
        ImageHeight := 128;
      end;
    pcdBase4:
      begin
        ImageData := FBasePosition + PCD_BEGIN_BASE4;
        if (Orientation mod 4) <> 0 then
        begin
          // portrait image
          Width := 256;
          Height := 384;
        end
        else
        begin
          // landscape image
          Width := 384;
          Height := 256;
        end;
        ImageWidth := 384;
        ImageHeight := 256;
      end;
    pcdBase:
      begin
        ImageData := FBasePosition + PCD_BEGIN_BASE;
        if (Orientation mod 4) <> 0 then
        begin
          // portrait image
          Width := 512;
          Height := 768;
        end
        else
        begin
          // landscape image
          Width := 768;
          Height := 512;
        end;
        ImageWidth := 768;
        ImageHeight := 512;
      end;
  else
    raise Exception.Create('PCD: image size currently not supported');
  end;

  case Orientation mod 4 of
    0:
      begin
        Portrait := False;
        Flip := False;
      end;
    1:   
      begin
        Portrait := True;
        Flip := False;
      end;
    2:
      begin
        Portrait := False;
        Flip := True;
      end;
  else
    begin
      Portrait := True;
      Flip := True;
    end;
  end;

  // now iterate through all lines (two lines per step)
  Y := 0;
  while Cardinal(Y) < ImageHeight do
  begin
    // set stream position
    Stream.Position := ImageData + Cardinal(Y div 2) * ImageWidth * 3;

    // read color information (Y, Cb, Cr) of two image lines
    Stream.ReadBuffer(LumaRow1, ImageWidth);  // Y - line 1
    Stream.ReadBuffer(LumaRow2, ImageWidth);  // Y - line 2
    Stream.ReadBuffer(Chroma1, ImageWidth div 2); // Cb
    Stream.ReadBuffer(Chroma2, ImageWidth div 2); // Cr

    // read chrominance values for next line
    if Cardinal(Y) >= (ImageHeight - 2) then  // last line pair?
    begin
      // yes, last pair
      Stream.Position := ImageData + Cardinal(Y div 2) * ImageWidth * 3 + 2 * ImageWidth;
    end
    else
    begin
      // no, normal line pair within the image
      Stream.Position := ImageData + Cardinal((Y + 2) div 2) * ImageWidth * 3 + 2 * ImageWidth;
    end;
    
    Stream.ReadBuffer(Chroma3, ImageWidth div 2); // Cb
    Stream.ReadBuffer(Chroma4, ImageWidth div 2); // Cr

    // interpolate missing chrominance values
    Chroma1[ImageWidth div 2] := Chroma1[ImageWidth div 2 - 1];  // fictive
    Chroma2[ImageWidth div 2] := Chroma2[ImageWidth div 2 - 1];  // point
    Chroma3[ImageWidth div 2] := Chroma3[ImageWidth div 2 - 1];  // on right
    Chroma4[ImageWidth div 2] := Chroma4[ImageWidth div 2 - 1];  // image border

    X := 0;
    while Cardinal(X) < ImageWidth do
    begin
      // upper left point (take it directly over)
      Chroma1Row1[X] := Chroma1[X div 2];
      Chroma2Row1[X] := Chroma2[X div 2];
      // upper right point (interpolate with right neighbour)
      Chroma1Row1[X + 1] := (Chroma1[X div 2] + Chroma1[X div 2 + 1]) shr 1;
      Chroma2Row1[X + 1] := (Chroma2[X div 2] + Chroma2[X div 2 + 1]) shr 1;
      // lower left point (interpolate with neighbour below)
      Chroma1Row2[X] := (Chroma1[X div 2] + Chroma3[X div 2]) shr 1;
      Chroma2Row2[X] := (Chroma2[X div 2] + Chroma4[X div 2]) shr 1;
      // lower right point (interpolate with all neighbours)
      Chroma1Row2[X + 1] := (Chroma1[X div 2] + Chroma1[X div 2 + 1] +
                             Chroma3[X div 2] + Chroma3[X div 2 + 1]) shr 2;
      Chroma2Row2[X + 1] := (Chroma2[X div 2] + Chroma2[X div 2 + 1] +
                             Chroma4[X div 2] + Chroma4[X div 2 + 1]) shr 2;
      Inc(X, 2);
    end;

    // convert YCbCr into RGB and put data into image
    if Portrait then
    begin
      for X := 0 to ImageWidth - 1 do
      begin
        // turn image 90?
        if Flip then PChar(Line1) := PChar(ScanLine[X]) + Y * 3
                else PChar(Line1) := PChar(ScanLine[Integer(ImageWidth) - X - 1]) + Y * 3;
         // 1. PCD line
         R := Round(1.3584 * LumaRow1[X] + 1.8215 * (Chroma2Row1[X] - 137));
         G := Round(1.3584 * LumaRow1[X] - 0.9271435 * (Chroma2Row1[X] - 137) - 0.4302726 * (Chroma1Row1[X] - 156));
         B := Round(1.3584 * LumaRow1[X] + 2.2179 * (Chroma1Row1[X] - 156));
         Line1^ := Max(0, Min(255, B));
         Inc(Line1);
         Line1^ := Max(0, Min(255, G));
         Inc(Line1);
         Line1^ := Max(0, Min(255, R));
         Inc(Line1);

         // 2. PCD line
         R := Round(1.3584 * LumaRow2[X] + 1.8215 * (Chroma2Row2[X] - 137));
         G := Round(1.3584 * LumaRow2[X] - 0.9271435 * (Chroma2Row2[X] - 137) - 0.4302726 * (Chroma1Row2[X] - 156));
         B := Round(1.3584 * LumaRow2[X] + 2.2179 * (Chroma1Row2[X] - 156));
         Line1^ := Max(0, Min(255, B));
         Inc(Line1);
         Line1^ := Max(0, Min(255, G));
         Inc(Line1);
         Line1^ := Max(0, Min(255, R));
      end;
    end
    else
    begin
      // image in landscape format
      if Flip then
      begin
        Line1 := ScanLine[Height - Y - 1];
        Line2 := ScanLine[Height - Y - 2];
      end
      else
      begin
        Line1 := ScanLine[Y];
        Line2 := ScanLine[Y + 1];
      end;
        
      for X := 0 to ImageWidth - 1 do
      begin
        // 1. PCD line
        R := Round(1.3584 * LumaRow1[X] + 1.8215 * (Chroma2Row1[X] - 137));
        G := Round(1.3584 * LumaRow1[X] - 0.9271435 * (Chroma2Row1[X] - 137) - 0.4302726 * (Chroma1Row1[X] - 156));
        B := Round(1.3584 * LumaRow1[X] + 2.2179 * (Chroma1Row1[X] - 156));
        Line1^ := Max(0, Min(255, B));
        Inc(Line1);
        Line1^ := Max(0, Min(255, G));
        Inc(Line1);
        Line1^ := Max(0, Min(255, R));
        Inc(Line1);

        // 2. PCD line
        R := Round(1.3584 * LumaRow2[X] + 1.8215 * (Chroma2Row2[X] - 137));
        G := Round(1.3584 * LumaRow2[X] - 0.9271435 * (Chroma2Row2[X] - 137) - 0.4302726 * (Chroma1Row2[X] - 156));
        B := Round(1.3584 * LumaRow2[X] + 2.2179 * (Chroma1Row2[X] - 156));
        Line2^ := Max(0, Min(255, B));
        Inc(Line2);
        Line2^ := Max(0, Min(255, G));
        Inc(Line2);
        Line2^ := Max(0, Min(255, R));
        Inc(Line2);
      end;
    end;  

    Inc(Y, 2);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPCDGraphic.SaveToStream(Stream: TStream);

begin

end;

//----------------- TPPMGraphic ----------------------------------------------------------------------------------------

procedure TPPMGraphic.CreateGrayScalePalette(BW: Boolean);

var
  LogPalette: TMaxLogPalette;
  I: Integer;
  
begin
  FillChar(LogPalette, SizeOf(LogPalette), 0);
  LogPalette.palVersion := $300;
  if BW then
  begin
    // black & white palette
    LogPalette.palNumEntries := 2;

    LogPalette.palPalEntry[0].peBlue := 255;
    LogPalette.palPalEntry[0].peGreen := 255;
    LogPalette.palPalEntry[0].peRed := 255;
  end
  else
  begin
    // create a gray scale palette
    LogPalette.palNumEntries := 256;
    // no external palette so use gray scale
    for I := 0 to 255 do
    begin
      LogPalette.palPalEntry[I].peBlue := I;
      LogPalette.palPalEntry[I].peGreen := I;
      LogPalette.palPalEntry[I].peRed := I;
    end;
  end;
  // finally create palette
  Palette := CreatePalette(PLogPalette(@LogPalette)^);
end;

//----------------------------------------------------------------------------------------------------------------------

function TPPMGraphic.CurrentChar: Char;

begin
  if FIndex = SizeOf(FBuffer) then Result := #0
                              else Result := FBuffer[FIndex];
end;

//----------------------------------------------------------------------------------------------------------------------

function TPPMGraphic.GetChar: Char;

// buffered I/O

begin
  if FIndex = SizeOf(FBuffer) then
  begin
    if FStream.Position = FStream.Size then raise Exception.Create('PPM: Stream read error.');
    FIndex := 0;
    FStream.Read(FBuffer, SizeOf(FBuffer));
  end;
  Result := FBuffer[FIndex];
  Inc(FIndex);
end;

//----------------------------------------------------------------------------------------------------------------------

function TPPMGraphic.GetNumber: Cardinal;

// reads the next number from the stream (and skips all characters which are not in 0..9)

var
  Ch: Char;

begin
  // skip all non-numbers
  repeat
    Ch := GetChar;
    // skip comments
    if Ch = '#' then
    begin
      ReadLine;
      Ch := GetChar;
    end;
  until Ch in ['0'..'9'];

  // read the number characters and convert meanwhile
  Result := 0;
  repeat
    Result := 10 * Result + Ord(Ch) - $30;
    Ch := GetChar;
  until not (Ch in ['0'..'9']);
end;

//----------------------------------------------------------------------------------------------------------------------

function TPPMGraphic.ReadLine: String;

// reads one text line from stream and skips comments

var
  Ch: Char;
  I: Integer;

begin
  Result := '';
  repeat
    Ch := GetChar;
    if Ch in [#13, #10] then Break
                        else Result := Result + Ch;
  until False;
  // eat #13#10 combination
  if (Ch = #13) and (CurrentChar = #10) then GetChar;

  // delete comments
  I := Pos('#', Result);
  if I > 0 then Delete(Result, I, MaxInt);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPPMGraphic.LoadFromStream(Stream: TStream);

var
  Buffer: String;
  Line24: PBGR;
  Line8: PByte;
  X, Y: Integer;
  Pixel: Byte;

begin
  Handle := 0;
  // copy reference for buffered access
  FStream := Stream;
  // set index pointer to end of buffer to cause reload
  FIndex := SizeOf(FBuffer);
  with Stream do
  begin
    Buffer := ReadLine;
    if Buffer[1] <> 'P' then raise Exception.Create('Not a valid ppm file.');
    case StrToInt(Buffer[2]) of
      1: // PBM ASCII format (black & white)
        begin
          PixelFormat := pf1Bit;
          Width := GetNumber;
          Height := GetNumber;
          CreateGrayScalePalette(True);

          // read image data
          for Y := 0 to Height - 1 do
          begin
            Line8 := ScanLine[Y];
            Pixel := 0;
            for X := 1 to Width do
            begin
              Pixel := (Pixel shl 1) or (GetNumber and 1);
              if (X mod 8) = 0 then
              begin
                Line8^ := Pixel;
                Inc(Line8);
                Pixel := 0;
              end;
            end;
            if (Width mod 8) <> 0 then Line8^ := Pixel shl (8 - (Width mod 8));
          end;
        end;
      2: // PGM ASCII form (gray scale)
        begin
          PixelFormat := pf8Bit;
          Width := GetNumber;
          Height := GetNumber;
          // skip maximum color value
          GetNumber;
          CreateGrayScalePalette(False);

          // read image data
          for Y := 0 to Height - 1 do
          begin
            Line8 := ScanLine[Y];
            for X := 0 to Width - 1 do
            begin
              Line8^ := GetNumber;
              Inc(Line8);
            end;
          end;
        end;
      3: // PPM ASCII form (true color)
        begin
          PixelFormat := pf24Bit;
          Width := GetNumber;
          Height := GetNumber;
          // skip maximum color value
          GetNumber;

          for Y := 0 to Height - 1 do
          begin
            Line24 := ScanLine[Y];
            for X := 0 to Width - 1 do
            begin
              Line24.R := GetNumber;
              Line24.G := GetNumber;
              Line24.B := GetNumber;
              Inc(Line24);
            end;
          end;
        end;
      4: // PBM binary format (black & white)
        begin
          PixelFormat := pf1Bit;
          Width := GetNumber;
          Height := GetNumber;
          CreateGrayScalePalette(True);

          // read image data
          for Y := 0 to Height - 1 do
          begin
            Line8 := ScanLine[Y];
            for X := 0 to (Width div 8) - 1 do
            begin
              Line8^ := Byte(GetChar);
              Inc(Line8);
            end;
            if (Width mod 8) <> 0 then Line8^ := Byte(GetChar);
          end;
        end;
      5: // PGM binary form (gray scale)
        begin
          PixelFormat := pf8Bit;
          Width := GetNumber;
          Height := GetNumber;
          // skip maximum color value
          GetNumber;
          CreateGrayScalePalette(False);

          // read image data
          for Y := 0 to Height - 1 do
          begin
            Line8 := ScanLine[Y];
            for X := 0 to Width - 1 do
            begin
              Line8^ := Byte(GetChar);
              Inc(Line8);
            end;
          end;
        end;
      6: // PPM binary form (true color)
        begin
          PixelFormat := pf24Bit;
          Width := GetNumber;
          Height := GetNumber;
          // skip maximum color value
          GetNumber;

          // Pixel values are store linearly (but RGB instead BGR).
          // There's one allowed white space which will automatically be skipped by the first
          // GetChar call below
          // now read the pixels
          for Y := 0 to Height - 1 do
          begin
            Line24 := ScanLine[Y];
            for X := 0 to Width - 1 do
            begin
              Line24.R := Byte(GetChar);
              Line24.G := Byte(GetChar);
              Line24.B := Byte(GetChar);
              Inc(Line24);
            end;
          end;
        end;
    end;
  end;
end;

//----------------- TCUTGraphic ----------------------------------------------------------------------------------------

procedure TCUTGraphic.LoadFromFile(const FileName: String);

// overridden to extract an implicit palette file name
 
begin
  FPaletteFile := ChangeFileExt(FileName, '.pal');
  inherited;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TCUTGraphic.LoadFromStream(Stream: TStream);

var
  Buffer: PByte;
  Run: Pointer;
  Dummy: Word;
  Decoder: TCUTRLE;
  CUTSize: Cardinal;
  Y: Integer;

begin
  Handle := 0;

  PixelFormat := pf8Bit;
  Stream.ReadBuffer(Dummy, SizeOf(Dummy));
  Width := Dummy;
  Stream.ReadBuffer(Dummy, SizeOf(Dummy));
  Height := Dummy;
  Stream.ReadBuffer(Dummy, SizeOf(Dummy));
  LoadPalette;

  CutSize := Stream.Size - Stream.Position;
  GetMem(Buffer, CutSize);
  Stream.ReadBuffer(Buffer^, CUTSize);

  Decoder := TCUTRLE.Create;
  Run := Buffer;
  for Y := 0 to Height - 1 do
    Decoder.Decode(Run, ScanLine[Y], 0, Width);

  Decoder.Free;
  FreeMem(Buffer);
end;

//----------------------------------------------------------------------------------------------------------------------

type
  // the palette file header is actually more complex than the
  // image file's header, funny...
  PHaloPaletteHeader = ^THaloPaletteHeader;
  THaloPaletteHeader = packed record
    ID: array[0..1] of Char;  // should be 'AH'
    Version,
    Size: Word;
    FileType,
    SubType: Byte;
    BrdID,
    GrMode: Word;
    MaxIndex,
    MaxRed,
    MaxGreen,
    MaxBlue: Word; // colors = MaxIndex + 1
    Signature: array[0..7] of Char; // 'Dr. Halo'
    Filler: array[0..11] of Byte;
  end;

//----------------------------------------------------------------------------------------------------------------------

procedure TCUTGraphic.LoadPalette;

var
  Header: PHaloPaletteHeader;
  LogPalette: TMaxLogPalette;
  I: Integer;
  Buffer: array[0..511] of Byte;
  Run: PWord;

begin
  LogPalette.palVersion := $300;
  if FileExists(FPaletteFile) then
  begin
    with TFileStream.Create(FPaletteFile, fmOpenRead or fmShareDenyNone) do
    try
      // quite strange file organization here, we need always to load 512 bytes blocks
      // and skip occasionally some bytes
      ReadBuffer(Buffer, SizeOf(Buffer));
      Header := @Buffer;
      LogPalette.palNumEntries := Header.MaxIndex + 1;
      Run := @Buffer;
      Inc(PByte(Run), SizeOf(Header^));
      for I := 0 to LogPalette.palNumEntries - 1 do
      begin
        // load next 512 bytes buffer if necessary
        if (Integer(Run) - Integer(@Buffer)) > 506 then
        begin
          ReadBuffer(Buffer, SizeOf(Buffer));
          Run := @Buffer;
        end;
        LogPalette.palPalEntry[I].peRed := Run^;
        Inc(Run);
        LogPalette.palPalEntry[I].peGreen := Run^;
        Inc(Run);
        LogPalette.palPalEntry[I].peBlue := Run^;
        Inc(Run);
      end;
    finally
      Free;
    end;
  end
  else
  begin
    LogPalette.palNumEntries := 256;
    // no external palette so use gray scale
    for I := 0 to 255 do
    begin
      LogPalette.palPalEntry[I].peBlue := I;
      LogPalette.palPalEntry[I].peGreen := I;
      LogPalette.palPalEntry[I].peRed := I;
    end;
  end;

  // finally create palette
  Palette := CreatePalette(PLogPalette(@LogPalette)^);
end;

//----------------- TGIFGraphic ----------------------------------------------------------------------------------------

const
  // logical screen descriptor packed field masks
  GIF_GLOBALCOLORTABLE = $80;	
  GIF_COLORRESOLUTION = $70; 
  GIF_GLOBALCOLORTABLESORTED = $08; 
  GIF_COLORTABLESIZE = $07;

  // image flags
  GIF_LOCALCOLORTABLE = $80;
  GIF_INTERLACED = $40;
  GIF_LOCALCOLORTABLESORTED= $20;

  // block identifiers
  GIF_PLAINTEXT = $01;
  GIF_GRAPHICCONTROLEXTENSION = $F9;
  GIF_COMMENTEXTENSION = $FE;
  GIF_APPLICATIONEXTENSION = $FF;
  GIF_IMAGEDESCRIPTOR = Ord(',');
  GIF_EXTENSIONINTRODUCER = Ord('!');
  GIF_TRAILER = Ord(';');
  
type
  TGIFHeader = packed record
    Signature: array[0..2] of Char; // magic ID 'GIF'
    Version: array[0..2] of Char;   // '87a' or '89a' 
  end;

  TLogicalScreenDescriptor = packed record
    ScreenWidth: Word;
    ScreenHeight: Word;
    PackedFields,
    BackgroundColorIndex, // index into global color table
    AspectRatio: Byte;    // actual ratio = (AspectRatio + 15) / 64
  end;

  TImageDescriptor = packed record
    //Separator: Byte; // leave that out since we always read one bye ahead
    Left: Word;		 // X position of image with respect to logical screen
    Top: Word;		 // Y position
    Width: Word;
    Height: Word;
    PackedFields: Byte;
  end;

//----------------------------------------------------------------------------------------------------------------------

procedure TGIFGraphic.LoadFromStream(Stream: TStream);

var
  Header: TGIFHeader;
  ScreenDescriptor: TLogicalScreenDescriptor;
  ImageDescriptor: TImageDescriptor;
  LogPalette: TMaxLogPalette;
  I: Integer;
  BlockID: Byte;
  InitCodeSize: Byte;
  RawData,
  Run: PByte;
  TargetBuffer,
  TargetRun,
  Line: Pointer;
  Pass,
  Increment,
  Marker: Integer;
  Decoder: TDecoder;
  
begin
  // release old image
  Handle := 0;
  PixelFormat := pf8Bit;

  with Stream do
  begin
    ReadBuffer(Header, SizeOf(Header));
    if UpperCase(Header.Signature) <> 'GIF' then raise Exception.Create('Not a valid GIF file.');

    // general information
    ReadBuffer(ScreenDescriptor, SizeOf(ScreenDescriptor));

    FillChar(LogPalette, SizeOf(LogPalette), 0);
    LogPalette.palVersion := $300;
    // read global color table if given
    if (ScreenDescriptor.PackedFields and GIF_GLOBALCOLORTABLE) <> 0 then
    begin
      // the global color table immediately follows the screen descriptor
      LogPalette.palNumEntries := 2 shl (ScreenDescriptor.PackedFields and GIF_COLORTABLESIZE);
      for I := 0 to LogPalette.palNumEntries - 1 do
      begin
        ReadBuffer(LogPalette.palPalEntry[I].peRed, 1);
        ReadBuffer(LogPalette.palPalEntry[I].peGreen, 1);
        ReadBuffer(LogPalette.palPalEntry[I].peBlue, 1);
      end;
      // finally create palette
      Palette := CreatePalette(PLogPalette(@LogPalette)^);
    end;

    // iterate through the blocks until first image is found
    repeat
      ReadBuffer(BlockID, 1);
      if BlockID = GIF_EXTENSIONINTRODUCER then
      begin
        repeat
          ReadBuffer(BlockID, 1);
        until BlockID = 0;
      end;
    until (BlockID = GIF_IMAGEDESCRIPTOR) or (BlockID = GIF_TRAILER);

    // image found?
    if BlockID = GIF_IMAGEDESCRIPTOR then
    begin
      ReadBuffer(ImageDescriptor, SizeOf(TImageDescriptor));
      Width := ImageDescriptor.Width;
      if Width = 0 then Width := ScreenDescriptor.ScreenWidth;
      Height := ImageDescriptor.Height;
      if Height = 0 then Height := ScreenDescriptor.ScreenHeight;

      // if there is a local color table then override the already set one
      if (ImageDescriptor.PackedFields and GIF_LOCALCOLORTABLE) <> 0 then
      begin
        // the global color table immediately follows the image descriptor
        LogPalette.palNumEntries := 2 shl (ImageDescriptor.PackedFields and GIF_COLORTABLESIZE);
        for I := 0 to LogPalette.palNumEntries - 1 do
        begin
          ReadBuffer(LogPalette.palPalEntry[I].peRed, 1);
          ReadBuffer(LogPalette.palPalEntry[I].peGreen, 1);
          ReadBuffer(LogPalette.palPalEntry[I].peBlue, 1);
        end;
        Palette := CreatePalette(PLogPalette(@LogPalette)^);
      end;

      ReadBuffer(InitCodeSize, 1);
      // decompress data in one step
      // 1) count data
      Marker := Position;
      Pass := 0;
      Increment := 0;
      repeat
        if Read(Increment, 1) = 0 then Break;
        Inc(Pass, Increment);
        Seek(Increment, soFromCurrent);
      until Increment = 0;

      // 2) allocate enough memory
      GetMem(RawData, Pass);
      GetMem(TargetBuffer, Width * Height);

      // 3) read and decode data
      Position := Marker;
      Increment := 0;
      Run := RawData;
      repeat
        if Read(Increment, 1) = 0 then Break;
        Read(Run^, Increment);
        Inc(Run, Increment);
      until Increment = 0;

      Decoder := TGIFLZW.Create;
      TGIFLZW(Decoder).InitialCodeSize := InitCodeSize;
      Run := RawData;
      Decoder.Decode(Pointer(Run), TargetBuffer, Pass, Width * Height);
      Decoder.Free;

      // after decoding we need to move the data into the bitmap
      if (ImageDescriptor.PackedFields and GIF_INTERLACED) = 0 then
      begin
        TargetRun := TargetBuffer;
        for I := 0 to Height - 1 do
        begin
          Line := Scanline[I];
          Move(TargetRun^, Line^, Width);
          Inc(PByte(TargetRun), Width);
        end;
      end
      else
      begin
        TargetRun := TargetBuffer;
        // interlaced image, need to move in four passes
        for Pass := 0 to 3 do
        begin
          // determine start line and increment of the pass
          case Pass of
            0:
              begin
                I := 0;
                Increment := 8;
              end;
            1:
              begin
                I := 4;
                Increment := 8;
              end;
            2:
              begin
                I := 2;
                Increment := 4;
              end;
          else
            I := 1;
            Increment := 2;
          end;

          while I < Height do
          begin
            Line := Scanline[I];
            Move(TargetRun^, Line^, Width);
            Inc(PByte(TargetRun), Width);
            Inc(I, Increment);
          end;
        end;
      end;

      FreeMem(TargetBuffer);
      FreeMem(RawData);
    end;
  end;
end;

//----------------- TRLAGraphic ----------------------------------------------------------------------------------------

// This implementation is based on code from Dipl. Ing. Ingo Neumann (ingo@upstart.de, ingo_n@dialup.nacamar.de).

type
  TRLAWindow = packed record
    Left,
    Right,
    Bottom,
    Top: SmallInt;
  end;

  TRLAHeader = packed record
    Window,                            // overall image size
    Active_window: TRLAWindow;         // size of non-zero portion of image (we use this as actual image size)
    Frame,                             // frame number if part of a sequence
    Storage_type,                      // type of image channels (0 - integer data, 1 - float data)
    Num_chan,                          // samples per pixel (usually 3: r, g, b)
    Num_matte,                         // number of matte channels (usually only 1)
    Num_aux,                           // number of auxiliary channels, usually 0
    Revision: SmallInt;                // always $FFFE
    Gamma: array[0..15] of Char;       // gamma single value used when writing the image
    Red_pri: array[0..23] of Char;     // used chromaticity for red channel (typical format: "%7.4f %7.4f")
    Green_pri: array[0..23] of Char;   // used chromaticity for green channel
    Blue_pri: array[0..23] of Char;    // used chromaticity for blue channel
    White_pt: array[0..23] of Char;    // used chromaticity for white point
    Job_num: Integer;                  // rendering speciifc
    Name: array[0..127] of Char;       // original file name
    Desc: array[0..127] of Char;       // a file description
    ProgramName: array[0..63] of Char; // name of program which created the image
    Machine: array[0..31] of Char;     // name of computer on which the image was rendered
    User: array[0..31] of Char;        // user who ran the creation program of the image
    Date: array[0..19] of Char;        // creation data of image (ex: Sep 30 12:29 1993)
    Aspect: array[0..23] of Char;      // aspect format of the file (external resource)
    Aspect_ratio: array[0..7] of Char; // float number Width /Height
    Chan: array[0..31] of Char;        // color space (can be: rgb, xyz, sampled or raw)
    Field: SmallInt;                   // 0 - non-field rendered data, 1 - field rendered data
    Time: array[0..11] of Char;        // time needed to create the image (used when rendering)
    Filter: array[0..31] of Char;      // filter name to post-process image data
    Chan_bits,                         // bits per sample
    Matte_type,                        // type of matte channel (see aux_type)
    Matte_bits,                        // precision of a pixel's matte channel (1..32)
    Aux_type,                          // type of aux channel (0 - integer data; 4 - single (float) data
    Aux_bits: SmallInt;                // bits precision of the pixel's aux channel (1..32 bits)
    Aux: array[0..31] of Char;         // auxiliary channel as either range or depth
    Space: array[0..35] of Char;       // unused
    Next: Integer;                     // offset for next header if multi-frame image
  end;
  
//----------------------------------------------------------------------------------------------------------------------

procedure TRLAGraphic.LoadFromStream(Stream: TStream);

var
  BasePosition: Cardinal;
  Header: TRLAHeader;
  BottomUp: Boolean;
  Offsets: TCardinalArray;
  RLELength: Word;
  LineBGR: PBGR;
  LineBGRA: PBGRA;
  R, G, B, A: PByte;
  X, Y: Integer;

  // RLE buffers
  RawBuffer,
  RedBuffer,
  GreenBuffer,
  BlueBuffer,
  AlphaBuffer: Pointer;
  Decoder: TRLADecoder;
  
begin
  // free previous image data
  Handle := 0;
  with Stream do
  begin
    // keep start position to address data relatively
    BasePosition := Stream.Position;

    ReadBuffer(Header, SizeOf(Header));
    // data is always given in big endian order, so swap data which needs this
    SwapHeader(Header);

    // determine base properties of image
    if not (Header.num_chan in [3, 4]) then raise Exception.Create('RLA: image must be RGB(A).');

    // num_matte determines available alpha channel
    if Header.Num_matte = 0 then PixelFormat := pf24Bit
                            else PixelFormat := pf32Bit;

    // dimension of image, top might be larger than bottom denoting a bottom up image
    Width := Header.Active_window.Right - Header.Active_window.Left + 1;
    Height := Abs(Header.Active_window.Bottom - Header.Active_window.Top) + 1;
    BottomUp := (Header.Active_window.Bottom - Header.Active_window.Top) < 0;

    // each scanline is organized in RLE compressed strips whose location in the stream
    // is determined by the offsets table
    SetLength(Offsets, Height);
    ReadBuffer(Offsets[0], Height * SizeOf(Cardinal));
    SwapLong(@Offsets[0], Height);

    // setup intermediate storage
    Decoder := TRLADecoder.Create;
    GetMem(RawBuffer, 2 * Width);
    GetMem(RedBuffer, Width);
    GetMem(GreenBuffer, Width);
    GetMem(BlueBuffer, Width);
    GetMem(AlphaBuffer, Width);

    // no go for each scanline
    if PixelFormat = pf24Bit then
    begin
      for Y := 0 to Height - 1 do
      begin
        Stream.Position := BasePosition + Offsets[Y];
        if BottomUp then LineBGR := ScanLine[Height - Y - 1]
                    else LineBGR := ScanLine[Y];
        // read channel data to decode
        // red
        ReadBuffer(RLELength, SizeOf(RLELength));
        RLELength := Swap(RLELength);
        ReadBuffer(RawBuffer^, RLELength);
        Decoder.Decode(RawBuffer, RedBuffer, RLELength, Width);
        // green
        ReadBuffer(RLELength, SizeOf(RLELength));
        RLELength := Swap(RLELength);
        ReadBuffer(RawBuffer^, RLELength);
        Decoder.Decode(RawBuffer, GreenBuffer, RLELength, Width);
        // blue
        ReadBuffer(RLELength, SizeOf(RLELength));
        RLELength := Swap(RLELength);
        ReadBuffer(RawBuffer^, RLELength);
        Decoder.Decode(RawBuffer, BlueBuffer, RLELength, Width);

        // make pixels
        R := RedBuffer;
        G := GreenBuffer;
        B := BlueBuffer;
        for X := 0 to Width - 1 do
        begin
          LineBGR.R := R^; Inc(R);
          LineBGR.G := G^; Inc(G);
          LineBGR.B := B^; Inc(B);
          Inc(LineBGR);
        end;
      end;
    end
    else
    begin
      for Y := 0 to Height - 1 do
      begin
        Stream.Position := BasePosition + Offsets[Y];
        if BottomUp then LineBGRA := ScanLine[Height - Y - 1]
                    else LineBGRA := ScanLine[Y];
        // read channel data to decode
        // red
        ReadBuffer(RLELength, SizeOf(RLELength));
        RLELength := Swap(RLELength);
        ReadBuffer(RawBuffer^, RLELength);
        Decoder.Decode(RawBuffer, RedBuffer, RLELength, Width);
        // green
        ReadBuffer(RLELength, SizeOf(RLELength));
        RLELength := Swap(RLELength);
        ReadBuffer(RawBuffer^, RLELength);
        Decoder.Decode(RawBuffer, GreenBuffer, RLELength, Width);
        // blue
        ReadBuffer(RLELength, SizeOf(RLELength));
        RLELength := Swap(RLELength);
        ReadBuffer(RawBuffer^, RLELength);
        Decoder.Decode(RawBuffer, BlueBuffer, RLELength, Width);
        // alpha
        ReadBuffer(RLELength, SizeOf(RLELength));
        RLELength := Swap(RLELength);
        ReadBuffer(RawBuffer^, RLELength);
        Decoder.Decode(RawBuffer, AlphaBuffer, RLELength, Width);
        
        // make pixels
        R := RedBuffer;
        G := GreenBuffer;
        B := BlueBuffer;
        A := AlphaBuffer;
        for X := 0 to Width - 1 do
        begin
          LineBGRA.R := R^; Inc(R);
          LineBGRA.G := G^; Inc(G);
          LineBGRA.B := B^; Inc(B);
          LineBGRA.A := A^; Inc(A);
          Inc(LineBGRA);
        end;
      end;
    end;
  end;

  FreeMem(RawBuffer);
  FreeMem(RedBuffer);
  FreeMem(GreenBuffer);
  FreeMem(BlueBuffer);
  FreeMem(AlphaBuffer);
  Decoder.Free;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TRLAGraphic.SwapHeader(var Header);

// separate swap method to ease reading the main flow of the LoadFromStream method

begin
  with TRLAHeader(Header) do
  begin
    SwapShort(@Window, 4);
    SwapShort(@Active_window, 4);
    Frame := Swap(Frame);
    Storage_type := Swap(Storage_type);
    Num_chan := Swap(Num_chan);
    Num_matte := Swap(Num_matte);
    Num_aux := Swap(Num_aux);
    Revision := Swap(Revision);
    Job_num  := SwapLong(Job_num);
    Field := Swap(Field);
    Chan_bits := Swap(Chan_bits);
    Matte_type := Swap(Matte_type);
    Matte_bits := Swap(Matte_bits);
    Aux_type := Swap(Aux_type);
    Aux_bits := Swap(Aux_bits);
    Next := SwapLong(Next);
  end;
end;

//----------------- TPDSGraphic ----------------------------------------------------------------------------------------

const
  // color modes
  PSD_BITMAP = 0;
  PSD_GRAYSCALE = 1;
  PSD_INDEXED = 2;
  PSD_RGB = 3;
  PSD_CMYK = 4;
  PSD_MULTICHANNEL = 7;
  PSD_DUOTONE = 8;
  PSD_LAB = 9;

  PSD_COMPRESSION_NONE = 0;
  PSD_COMPRESSION_RLE = 1; // RLE compression (same as TIFF packed bits)

type
  TPSDHeader = packed record
    Signature: array[0..3] of Char; // always '8BPS'
    Version: Word;                  // always 1
    Reserved: array[0..5] of Byte;  // reserved, always 0
    Channels: Word;                 // 1..24, number of channels in the image (including alpha)
    Rows,
    Columns: Cardinal;              // 1..30000, size of image
    Depth: Word;                    // 1, 8, 16 bits per channel
    Mode: Word;                     // color mode (see constants above)
  end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPSDGraphic.MakePalette(BPS: Byte; Mode: Integer);

var
  Pal: TMaxLogPalette;
  hpal: HPALETTE;
  I: Integer;
  EntryCount: Word;

begin
  case BPS of
    1:
      EntryCount := 1;
    4:
      EntryCount := 15;
  else
    EntryCount := 255;
  end;

  Pal.palVersion := $300;
  Pal.palNumEntries := 1 + EntryCount;
  case BPS of
    1:
      begin
        Pal.palPalEntry[0].peRed := 255;
        Pal.palPalEntry[0].peGreen  := 255;
        Pal.palPalEntry[0].peBlue := 255;
        Pal.palPalEntry[0].peFlags := 0;

        Pal.palPalEntry[1].peRed := 0;
        Pal.palPalEntry[1].peGreen  := 0;
        Pal.palPalEntry[1].peBlue := 0;
        Pal.palPalEntry[1].peFlags := 0;
      end;
  else
    // 8 bits per sample
    case Mode  of
      PSD_DUOTONE,
      PSD_GRAYSCALE:
        for I :=  0 to EntryCount do
        begin
          Pal.palPalEntry[I].peRed := I;
          Pal.palPalEntry[I].peGreen := I;
          Pal.palPalEntry[I].peBlue := I;
          Pal.palPalEntry[I].peFlags := 0;
        end;
    else
      // PSD_INDEXED
      for I := 0 to EntryCount do
      begin
        // palette data is organized rrr...ggg...bbb...
        Pal.palPalEntry[I].peRed := FPalette[0 * 256 + I];
        Pal.palPalEntry[I].peGreen := FPalette[1 * 256 + I];
        Pal.palPalEntry[I].peBlue := FPalette[2 * 256 + I];
        Pal.palPalEntry[I].peFlags := 0;
      end;
    end;
  end;
  hpal := CreatePalette(PLogPalette(@Pal)^);
  if hpal <> 0 then Palette := hpal;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPSDGraphic.LoadFromStream(Stream: TStream);

var
  Header: TPSDHeader;
  Count: Integer;
  Compression: Word;
  Decoder: TDecoder;
  RLELength: array of Word;

  Y: Integer;
  BPS: Integer;        // bytes per sample either 1 or 2 for 8 bits per channel and 16 bits per channel respectively 
  ChannelSize: Integer; // size of one channel (taking BPS into account)

  // RLE buffers
  RawBuffer,           // all image data compressed
  Buffer: Pointer;     // all iamge data uncompressed
  Run1,                // running pointer in Buffer 1
  Run2,                // etc.
  Run3,
  Run4: PByte;

begin
  with Stream do
  begin
    ReadBuffer(Header, SizeOf(Header));
    if Header.Signature <> '8BPS' then raise Exception.Create('Not a valid psd file.');

    with Header do
    begin
      // PSD files are big endian only
      Channels := Swap(Channels);
      Rows := SwapLong(Rows);
      Columns := SwapLong(Columns);
      Depth := Swap(Depth);
      Mode := Swap(Mode);
    end;

    // color space
    case Header.Mode of
      PSD_BITMAP: // B&W
        PixelFormat := pf1Bit;
      PSD_DUOTONE, // duo tone should be handled as grayscale
      PSD_GRAYSCALE,
      PSD_INDEXED: // 8 bits only are assumed because 16 bit wouldn't make sense here
        PixelFormat := pf8Bit;
      PSD_RGB:
        PixelFormat := pf24Bit;
      PSD_CMYK: // CMYK
        PixelFormat := pf24Bit;
      PSD_MULTICHANNEL: // Mulitchannel
        ;
      PSD_LAB: // CIE L*a*b*
        PixelFormat := pf24Bit;
    end;

    ReadBuffer(Count, SizeOf(Count));
    Count := SwapLong(Count);
    // setup the palette if necessary, color data immediately follows header
    if Header.Mode in [PSD_BITMAP, PSD_GRAYSCALE, PSD_INDEXED] then
    begin
      if Header.Mode = PSD_INDEXED then ReadBuffer(FPalette, Count);
      MakePalette(Header.Depth, Header.Mode);
    end;

    Width := Header.Columns;
    Height := Header.Rows;

    // skip resource and layers section
    ReadBuffer(Count, SizeOf(Count));
    Count := SwapLong(Count);
    Seek(Count, soFromCurrent);
    ReadBuffer(Count, SizeOf(Count));
    Count := SwapLong(Count);
    Seek(Count, soFromCurrent);

    // now read out image data
    RawBuffer := nil;

    ReadBuffer(Compression, SizeOf(Compression));
    Compression := Swap(Compression);
    if Compression = 1 then
    begin
      Decoder := TPackbitsRLE.Create;
      SetLength(RLELength, Header.Rows * Header.Channels);
      ReadBuffer(RLELength[0], 2 * Length(RLELength));
      SwapShort(@RLELength[0], Header.Rows * Header.Channels);
    end
    else Decoder := nil;

    try
      case Header.Mode of
        PSD_BITMAP,
        PSD_DUOTONE,
        PSD_GRAYSCALE,
        PSD_INDEXED:
          begin
            if Assigned(Decoder) then
            begin
              // determine whole compressed size
              Count := 0;
              for Y := 0 to Height - 1 do Inc(Count, RLELength[Y]);
              GetMem(RawBuffer, Count);
              ReadBuffer(RawBuffer^, Count);
              Run1 := RawBuffer;
              for Y := 0 to Height - 1 do
              begin
                Count := RLELength[Y];
                Decoder.Decode(Pointer(Run1), ScanLine[Y], Count, Width);
                Inc(Run1, Count);
              end;
              FreeMem(RawBuffer);
            end
            else // uncompressed data 
              for Y := 0 to Height - 1 do ReadBuffer(ScanLine[Y]^, Width);
          end;
        PSD_RGB,
        PSD_CMYK,
        PSD_LAB:
          begin
            // Color plane organization is planar. This means first all red rows, then all green and finally all blue rows.
            // For some color schemes (CMYK, L*a*b*) we need all three/four channels being present at the same time.
            // Hence we must load the entire picture into memory before we can process the data.
            BPS := Header.Depth div 8;
            ChannelSize := BPS * Width * Height;

            GetMem(Buffer, Header.Channels * ChannelSize);

            // first run: load image data and decompress it if necessary
            if Assigned(Decoder) then
            begin
              // determine whole compressed size
              Count := 0;
              for Y := 0 to High(RLELength) do Inc(Count, RLELength[Y]);
              Count := Count * BPS;
              GetMem(RawBuffer, Count);
              Run1 := RawBuffer;
              ReadBuffer(RawBuffer^, Count);
              Decoder.Decode(RawBuffer, Buffer, Count, Header.Channels * ChannelSize);
              FreeMem(RawBuffer);
            end
            else
            begin
              ReadBuffer(Buffer^, Header.Channels * ChannelSize);
              // swap word entries if sample size is 16 bits
              if BPS = 2 then SwapShort(Buffer, Header.Channels * ChannelSize div 2);
            end;

            // second run: put data into image (convert color space if necessary)
            case Header.Mode of
              PSD_RGB:
                begin
                  Run1 := Buffer;
                  Run2 := Run1; Inc(Run2, ChannelSize);
                  Run3 := Run2; Inc(Run3, ChannelSize);
                  for Y := 0 to Height - 1 do
                  begin
                    RGB2BGR(Run1, Run2, Run3, Scanline[Y], Header.Depth, 3 * Width);
                    Inc(Run1, BPS * Width);
                    Inc(Run2, BPS * Width);
                    Inc(Run3, BPS * Width);
                  end;
                end;
              PSD_CMYK:
                begin
                  // Photoshop CMYK values are given with 0 for maximum values, but the
                  // (general) CMYK conversion works with 255 as maxium value. Hence we must reverse
                  // all entries in the buffer.
                  Run1 := Buffer;
                  for Y := 1 to 4 * ChannelSize do
                  begin
                    Run1^ := 255 - Run1^;
                    Inc(Run1);
                  end;

                  Run1 := Buffer;
                  Run2 := Run1; Inc(Run2, ChannelSize);
                  Run3 := Run2; Inc(Run3, ChannelSize);
                  Run4 := Run3; Inc(Run4, ChannelSize);
                  for Y := 0 to Height - 1 do
                  begin
                    CMYK2BGR(Run1, Run2, Run3, Run4, ScanLine[Y], Header.Depth, 4 * Width);
                    Inc(Run1, BPS * Width);
                    Inc(Run2, BPS * Width);
                    Inc(Run3, BPS * Width);
                    Inc(Run4, BPS * Width);
                  end;
                end;
              PSD_LAB:
                begin
                  // Photoshop L*a*b* chrominance values are given within the range of 0..255, but the
                  // (general) CIELab conversion works with a range of -128..127. Hence we must offset
                  // all chrominance entries in the buffer.
                  Run1 := Buffer; Inc(Run1, ChannelSize);
                  for Y := 1 to 2 * ChannelSize do
                  begin
                    Run1^ := Run1^ - 128;
                    Inc(Run1);
                  end;

                  Run1 := Buffer;
                  Run2 := Run1; Inc(Run2, ChannelSize);
                  Run3 := Run2; Inc(Run3, ChannelSize);
                  for Y := 0 to Height - 1 do
                  begin
                    CIELAB2BGR(Run1, Run2, Run3, ScanLine[Y], Header.Depth, 3 * Width);
                    Inc(Run1, BPS * Width);
                    Inc(Run2, BPS * Width);
                    Inc(Run3, BPS * Width);
                  end;
                end;
            end;
          end;
      end;

    finally
      Decoder.Free;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

initialization
  TPicture.RegisterFileFormat('win', 'Truevision images', TTargaGraphic);
  TPicture.RegisterFileFormat('vst', 'Truevision images', TTargaGraphic);;
  TPicture.RegisterFileFormat('vda', 'Truevision images', TTargaGraphic);
  TPicture.RegisterFileFormat('tiff', 'TIFF images', TTIFFGraphic);
  TPicture.RegisterFileFormat('tif', 'TIFF images', TTIFFGraphic);
  TPicture.RegisterFileFormat('tga', 'Truevision images', TTargaGraphic);
  TPicture.RegisterFileFormat('sgi', 'SGI true color images', TSGIGraphic);
  TPicture.RegisterFileFormat('scr', 'Word 5.x screen capture images', TPCXGraphic);
  TPicture.RegisterFileFormat('rpf', 'SGI Wavefront images', TRLAGraphic);
  TPicture.RegisterFileFormat('rle', 'Windows bitmap', TBitmap);
  TPicture.RegisterFileFormat('rla', 'SGI Wavefront images', TRLAGraphic);
  TPicture.RegisterFileFormat('rgba', 'SGI true color images', TSGIGraphic);
  TPicture.RegisterFileFormat('rgb', 'SGI true color images', TSGIGraphic);
  TPicture.RegisterFileFormat('psd', 'Photoshop images', TPSDGraphic);
  TPicture.RegisterFileFormat('ppm', 'Portable pixel map images', TPPMGraphic);
  TPicture.RegisterFileFormat('pgm', 'Portable grayscale images', TPPMGraphic);
  TPicture.RegisterFileFormat('pbm', 'Portable b&w images', TPPMGraphic);
  TPicture.RegisterFileFormat('pic', 'Autodesk images', TAutodeskGraphic);
  TPicture.RegisterFileFormat('pcx', 'ZSoft PCX images', TPCXGraphic);
  TPicture.RegisterFileFormat('pdd', 'Photoshop images', TPSDGraphic);
  TPicture.RegisterFileFormat('pcd', 'Kodak Photo-CD images', TPCDGraphic);
  TPicture.RegisterFileFormat('pcc', 'ZSoft PCC images', TPCXGraphic);
  TPicture.RegisterFileFormat('icb', 'Truevision images', TTargaGraphic);
  TPicture.RegisterFileFormat('gif', 'CompuServe images', TGIFGraphic);
  TPicture.RegisterFileFormat('dib', 'Windows bitmap', TBitmap);
  TPicture.RegisterFileFormat('cut', 'Dr. Halo images', TCUTGraphic);
  TPicture.RegisterFileFormat('cel', 'Autodesk images', TAutodeskGraphic);
  TPicture.RegisterFileFormat('bw', 'SGI black/white images', TSGIGraphic);
finalization
  TPicture.UnregisterGraphicClass(TTargaGraphic);
  TPicture.UnregisterGraphicClass(TTIFFGraphic);
  TPicture.UnregisterGraphicClass(TSGIGraphic);
  TPicture.UnregisterGraphicClass(TPCXGraphic);
  TPicture.UnregisterGraphicClass(TAutodeskGraphic);
  TPicture.UnregisterGraphicClass(TPCDGraphic);
  TPicture.UnregisterGraphicClass(TPPMGraphic);
  TPicture.UnregisterGraphicClass(TCUTGraphic);
  TPicture.UnregisterGraphicClass(TGIFGraphic);
  TPicture.UnregisterGraphicClass(TRLAGraphic);
  TPicture.UnregisterGraphicClass(TPSDGraphic);
end.
