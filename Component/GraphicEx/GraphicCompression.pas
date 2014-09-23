unit GraphicCompression;

// Support unit for GraphicEx.pas
// GraphicCompression contains routines to compress and decompress data using various compression
// methods. Currently supported methods are:
// - LZW (Lempel-Ziff-Welch)
//   + TIF
//   + GIF
// - RLE (run length encoding)
//   + TGA,
//   + PCX,
//   + TIFF packed bits
//   + SGI
//   + CUT
//   + RLA

interface

uses
  Classes, SysUtils;

const // LZW encoding and decoding support
  NoLZWCode = 4096;

type
  PByte = ^Byte;
  
  TByteStream = array[0..MaxInt - 1] of Byte;
  PByteStream = ^TByteStream;

  // abstract decoder class to define the base functionality of an encoder/decoder
  TDecoder = class
  public
    procedure Decode(var Source: Pointer; Dest: Pointer; PackedSize, UnpackedSize: Integer); virtual; abstract;
    procedure Encode(Source, Dest: Pointer; var FByteCounts: Cardinal); virtual; abstract;
  end;

  // Lempel-Ziff-Welch encoder/decoder class
  // TIFF LZW compression / decompression is a bit different to the common LZW code
  TTIFFLZW = class(TDecoder)
  private
    FCodeSize: Cardinal;
    FCodeMask: Cardinal;
    FFreeCode: Cardinal;
    FOldCode: Cardinal;
    FPrefix: array[0..4095] of Cardinal; // LZW prefix
    FSuffix,                             // LZW suffix
    FStack: array [0..4095] of Byte;     // stack
    FStackPointer: PByte;
    FTarget: PByte;
    FFirstChar: Byte;  // buffer for decoded byte
    FClearCode,
    FEOICode: Word;
    function DecodeLZW(Code: Cardinal): Boolean;
  public
    procedure Decode(var Source: Pointer; Dest: Pointer; PackedSize, UnpackedSize: Integer); override;
    procedure Encode(Source, Dest: Pointer; var FByteCounts: Cardinal); override;
  end;

  TPackbitsRLE = class(TDecoder)
  public
    procedure Decode(var Source: Pointer; Dest: Pointer; PackedSize, UnpackedSize: Integer); override;
    procedure Encode(Source, Dest: Pointer; var FByteCounts: Cardinal); override;
  end;

  TPCXRLE = class(TDecoder)
  public
    procedure Decode(var Source: Pointer; Dest: Pointer; PackedSize, UnpackedSize: Integer); override;
    procedure Encode(Source, Dest: Pointer; var FByteCounts: Cardinal); override;
  end;

  TSGIRLE = class(TDecoder)
  public
    SampleSize: Byte; // this value can be 1 (for 8 bits) or 2 (for 16 bits) and needs to be set before Decode is called
    procedure Decode(var Source: Pointer; Dest: Pointer; PackedSize, UnpackedSize: Integer); override;
    procedure Encode(Source, Dest: Pointer; var FByteCounts: Cardinal); override;
  end;

  TCUTRLE = class(TDecoder)
  public
    procedure Decode(var Source: Pointer; Dest: Pointer; PackedSize, UnpackedSize: Integer); override;
    procedure Encode(Source, Dest: Pointer; var FByteCounts: Cardinal); override;
  end;

  // Note: We need a different LZW decoder class for GIF because the bit order is reversed compared to that
  //       of TIFF and the code size increment is handled slightly different. 
  TGIFLZW = class(TDecoder)
  private
    FCodeSize: Cardinal;
    FCodeMask: Cardinal;
    FFreeCode: Cardinal;
    FOldCode: Cardinal;
    FPrefix: array[0..4095] of Cardinal; // LZW prefix
    FSuffix,                             // LZW suffix
    FStack: array [0..4095] of Byte;     // stack
    FStackPointer: PByte;
    FTarget: PByte;
    FFirstChar: Byte;  // buffer for decoded byte
    FClearCode,
    FEOICode: Word;
    function DecodeLZW(Code: Cardinal): Boolean;
  public
    InitialCodeSize: Byte; // must be set before decoding is started!
    procedure Decode(var Source: Pointer; Dest: Pointer; PackedSize, UnpackedSize: Integer); override;
    procedure Encode(Source, Dest: Pointer; var FByteCounts: Cardinal); override;
  end;

  TRLADecoder = class(TDecoder)
  public
    procedure Decode(var Source: Pointer; Dest: Pointer; PackedSize, UnpackedSize: Integer); override;
    procedure Encode(Source, Dest: Pointer; var FByteCounts: Cardinal); override;
  end;

function DecodeRLE(const Source, Target: Pointer; Count, ColorDepth: Cardinal): Integer;
function EncodeRLE(const Source, Target: Pointer; Count, BPP: Integer): Integer;

//----------------------------------------------------------------------------------------------------------------------

implementation

//----------------- support routines -----------------------------------------------------------------------------------

function DecodeRLE(const Source, Target: Pointer; Count, ColorDepth: Cardinal): Integer;

// Decodes RLE compressed data from Source into Target. Count determines size of target buffer and ColorDepth
// the size of one data entry.
// Result is the amount of bytes decoded.

type
  PCardinalArray = ^TCardinalArray;
  TCardinalArray = array[0..MaxInt div 4 - 1] of Cardinal;

var
  I: Integer;
  SourcePtr,
  TargetPtr: PByte;
  RunLength: Cardinal;
  Counter: Cardinal;
  SourceCardinal: Cardinal;

begin
  Result := 0;
  Counter := 0;
  TargetPtr := Target;
  SourcePtr := Source;
  // unrolled decoder loop to speed up process
  case ColorDepth of
    8:
      while Counter < Count do
      begin
        RunLength := 1 + (SourcePtr^ and $7F);
        if SourcePtr^ > $7F then
        begin
          Inc(SourcePtr);
          FillChar(TargetPtr^, RunLength, SourcePtr^);
          Inc(TargetPtr, RunLength);
          Inc(SourcePtr);
          Inc(Result, 2);
        end
        else
        begin
          Inc(SourcePtr);
          Move(SourcePtr^, TargetPtr^, RunLength);
          Inc(SourcePtr, RunLength);
          Inc(TargetPtr, RunLength);
          Inc(Result, RunLength + 1)
        end;
        Inc(Counter, RunLength);
      end;
    15,
    16:
      while Counter < Count do
      begin
        RunLength := 1 + (SourcePtr^ and $7F);
        if SourcePtr^ > $7F then
        begin
          Inc(SourcePtr);
          for I := 0 to RunLength - 1 do
          begin
            TargetPtr^ := SourcePtr^;
            Inc(SourcePtr);
            Inc(TargetPtr);
            TargetPtr^ := SourcePtr^;
            Dec(SourcePtr);
            Inc(TargetPtr);
          end;
          Inc(SourcePtr, 2);
          Inc(Result, 3);
        end
        else
        begin
          Inc(SourcePtr);
          Move(SourcePtr^, TargetPtr^, 2 * RunLength);
          Inc(SourcePtr, 2 * RunLength);
          Inc(TargetPtr, 2 * RunLength);
          Inc(Result, RunLength * 2 + 1);
        end;
        Inc(Counter, 2 * RunLength);
      end;
    24:
      while Counter < Count do
      begin
        RunLength := 1 + (SourcePtr^ and $7F);
        if SourcePtr^ > $7F then
        begin
          Inc(SourcePtr);
          for I := 0 to RunLength - 1 do
          begin
            TargetPtr^ := SourcePtr^;
            Inc(SourcePtr);
            Inc(TargetPtr);
            TargetPtr^ := SourcePtr^;
            Inc(SourcePtr);
            Inc(TargetPtr);
            TargetPtr^ := SourcePtr^;
            Dec(SourcePtr, 2);
            Inc(TargetPtr);
          end;
          Inc(SourcePtr, 3);
          Inc(Result, 4);
        end
        else
        begin
          Inc(SourcePtr);
          Move(SourcePtr^, TargetPtr^, 3 * RunLength);
          Inc(SourcePtr, 3 * RunLength);
          Inc(TargetPtr, 3 * RunLength);
          Inc(Result, RunLength * 3 + 1);
        end;
        Inc(Counter, 3 * RunLength);
      end;
    32:
      while Counter < Count do
      begin
        RunLength := 1 + (SourcePtr^ and $7F);
        if SourcePtr^ > $7F then
        begin
          Inc(SourcePtr);
          SourceCardinal := PCardinalArray(SourcePtr)[0];
          for I := 0 to RunLength - 1 do
            PCardinalArray(TargetPtr)[I] := SourceCardinal;

          Inc(TargetPtr, 4 * RunLength);
          Inc(SourcePtr, 4);
          Inc(Result, 5);
        end
        else
        begin
          Inc(SourcePtr);
          Move(SourcePtr^, TargetPtr^, 4 * RunLength);
          Inc(SourcePtr, 4 * RunLength);
          Inc(TargetPtr, 4 * RunLength);
          Inc(Result,RunLength * 4 + 1);
        end;
        Inc(Counter, 4 * RunLength);
      end;
    end;
end;

//----------------------------------------------------------------------------------------------------------------------

function GetPixel(P: PByte; BPP: Byte): Cardinal;

// Retrieves a pixel value from a buffer. The actual size and order of the bytes is not important
// since we are only using the value for comparisons with other pixels.

begin
  Result := P^;
  Inc(P);
  Dec(BPP);
  while BPP > 0 do
  begin
    Result := Result shl 8;
    Result := Result or P^;
    Inc(P);
    Dec(BPP);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function CountDiffPixels(P: PByte; BPP: Byte; Count: Integer): Integer;

// counts pixels in buffer until two identical adjacent ones found

var
  N: Integer;
  Pixel,
  NextPixel: Cardinal;

begin
  N := 0;
  NextPixel := 0; // shut up compiler
  if Count = 1 then Result := Count
               else
  begin
    Pixel := GetPixel(P, BPP);
    while Count > 1 do
    begin
      Inc(P, BPP);
      NextPixel := GetPixel(P, BPP);
      if NextPixel = Pixel then Break;
      Pixel := NextPixel;
      Inc(N);
      Dec(Count);
    end;
    if NextPixel = Pixel then Result := N
                         else Result := N + 1;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function CountSamePixels(P: PByte; BPP: Byte; Count: Integer): Integer;

var
  Pixel,
  NextPixel: Cardinal;

begin
  Result := 1;
  Pixel := GetPixel(P, BPP);
  Dec(Count);
  while Count > 0 do
  begin
    Inc(P, BPP);
    NextPixel := GetPixel(P, BPP);
    if NextPixel <> Pixel then Break;
    Inc(Result);
    Dec(Count);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function EncodeRLE(const Source, Target: Pointer; Count, BPP: Integer): Integer;

// Encodes "Count" bytes pointed to by Source into the buffer supplied with Target and returns the
// number of bytes stored in Target. BPP denotes bytes per pixel color depth.
// Note: The target buffer must provide enough space to hold the compressed data. Using a size of
//       twice the size of the input buffer is sufficent.

var
  DiffCount, // pixel count until two identical
  SameCount: Integer; // number of identical adjacent pixels
  SourcePtr,
  TargetPtr: PByte;

begin
  Result := 0;
  SourcePtr := Source;
  TargetPtr := Target;
  while Count > 0 do
  begin
    DiffCount := CountDiffPixels(SourcePtr, BPP, Count);
    SameCount := CountSamePixels(SourcePtr, BPP, Count);
    if DiffCount > 128 then DiffCount := 128;
    if SameCount > 128  then SameCount := 128;

    if DiffCount > 0 then
    begin
      // create a raw packet
      TargetPtr^ := DiffCount - 1; Inc(TargetPtr);
      Dec(Count, DiffCount);
      Inc(Result, (DiffCount * BPP) + 1);
      while DiffCount > 0 do
      begin
        TargetPtr^ := SourcePtr^; Inc(SourcePtr); Inc(TargetPtr);
        if BPP > 1 then begin TargetPtr^ := SourcePtr^; Inc(SourcePtr); Inc(TargetPtr); end;
        if BPP > 2 then begin TargetPtr^ := SourcePtr^; Inc(SourcePtr); Inc(TargetPtr); end;
        if BPP > 3 then begin TargetPtr^ := SourcePtr^; Inc(SourcePtr); Inc(TargetPtr); end;
        Dec(DiffCount);
      end;
    end;

    if SameCount > 1 then
    begin
      // create a RLE packet
      TargetPtr^ := (SameCount - 1) or $80; Inc(TargetPtr);
      Dec(Count, SameCount);
      Inc(Result, BPP + 1);
      Inc(SourcePtr, (SameCount - 1) * BPP);
      TargetPtr^ := SourcePtr^; Inc(SourcePtr); Inc(TargetPtr);
      if BPP > 1 then begin TargetPtr^ := SourcePtr^; Inc(SourcePtr); Inc(TargetPtr); end;
      if BPP > 2 then begin TargetPtr^ := SourcePtr^; Inc(SourcePtr); Inc(TargetPtr); end;
      if BPP > 3 then begin TargetPtr^ := SourcePtr^; Inc(SourcePtr); Inc(TargetPtr); end;
    end;
  end;
end;

//----------------- TTIFFLZW -------------------------------------------------------------------------------------------

function TTIFFLZW.DecodeLZW(Code: Cardinal): Boolean;

var
  InCode: Cardinal; // buffer for passed code

begin
  // handling of clear codes
  if Code = FClearCode then
  begin
    // reset of all variables
    FCodeSize := 9;
    FCodeMask := (1 shl FCodeSize) - 1;
    FFreeCode := FClearCode + 2;
    FOldCode := NoLZWCode;
    Result := True;
    Exit;
  end;

  // check whether it is a valid, already registered code
  if Code > FFreeCode then
    raise Exception.Create('TIF LZW: invalid opcode.');

  // handling for the first LZW code: print and keep it
  if FOldCode = NoLZWCode then
  begin
    FFirstChar := FSuffix[Code];
    FTarget^ := FFirstChar;
    Inc(FTarget);
    FOldCode := Code;
    Result := True;
    Exit;
  end;

  // keep the passed LZW code
  InCode := Code;  

  // the first LZW code is always smaller than FFirstCode
  if Code = FFreeCode then
  begin
    FStackPointer^ := FFirstChar;
    Inc(FStackPointer);
    Code := FOldCode;
  end;

  // loop to put decoded bytes onto the stack
  while Code > FClearCode do
  begin
    FStackPointer^ := FSuffix[Code];
    Inc(FStackPointer);
    Code := FPrefix[Code];
  end;

  // place new code into code table
  FFirstChar := FSuffix[Code];
  FStackPointer^ := FFirstChar;
  Inc(FStackPointer);
  FPrefix[FFreeCode] := FOldCode;
  FSuffix[FFreeCode] := FFirstChar;
  if FFreeCode < 4096 then Inc(FFreeCode);

  // increase code size if necessary
  if (FFreeCode = FCodeMask) and
     (FCodeSize < 12) then
  begin
    Inc(FCodeSize);
    FCodeMask := (1 shl FCodeSize) - 1;
  end;

  // put decoded bytes (from the stack) into the target buffer
  FOldCode := InCode;
  repeat
    Dec(FStackPointer);
    FTarget^ := FStackPointer^;
    Inc(FTarget);
  until Cardinal(FStackPointer) <= Cardinal(@FStack);

  Result := True;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTIFFLZW.Decode(var Source: Pointer; Dest: Pointer; PackedSize, UnpackedSize: Integer);

var
  I: Integer;
  Data,           // current data
  Bits,           // counter for bit management
  Code: Cardinal; // current code value
  SourcePtr: PByte;

begin
  FTarget := Dest;
  SourcePtr := Source;

  // initialize parameter
  FClearCode := 1 shl 8;
  FEOICode := FClearCode + 1;
  FFreeCode := FClearCode + 2;
  FOldCode := NoLZWCode;
  FCodeSize := 9;
  FCodeMask := (1 shl FCodeSize) - 1; 

  // init code table
  for I := 0 to FClearCode - 1 do
  begin
    FPrefix[I] := NoLZWCode;
    FSuffix[I] := I;
  end;

  // initialize stack
  FStackPointer := @FStack;

  Data := 0;
  Bits := 0;  
  for I := 0 to PackedSize - 1 do
  begin
    // read code from bit stream
    Inc(Data, Cardinal(SourcePtr^) shl (24 - Bits));
    Inc(Bits, 8);
    while Bits >= FCodeSize do
    begin
      // current code
      Code := (Data and ($FFFFFFFF - FCodeMask)) shr (32 - FCodeSize);
      // mask it
      Data := Data shl FCodeSize;
      Dec(Bits, FCodeSize);

      // EOICode -> decoding finished, check also for badly written codes and
      // terminate the loop as soon as the target is filled up
      if (Code = FEOICode) or
         ((PChar(FTarget) - PChar(Dest)) >= UnpackedSize) then Exit;

      if not DecodeLZW(Code) then Break;
    end;
    Inc(SourcePtr);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TTIFFLZW.Encode(Source, Dest: Pointer; var FByteCounts: Cardinal);

begin

end;

//----------------- TPackbitsRLE ---------------------------------------------------------------------------------------

procedure TPackbitsRLE.Decode(var Source: Pointer; Dest: Pointer; PackedSize, UnpackedSize: Integer);

// decodes a simple run-length encoded strip of size PackedSize

var
  SourcePtr,
  TargetPtr: PByte;
  N: SmallInt;

begin
  TargetPtr := Dest;
  SourcePtr := Source;
  while PackedSize > 0 do
  begin
    N := ShortInt(SourcePtr^);
    Inc(SourcePtr);
    Dec(PackedSize);
    if N < 0 then // replicate next Byte -N + 1 times
    begin
      if N = -128 then Continue; // nop
      N := -N + 1;
      FillChar(TargetPtr^, N, SourcePtr^);
      Inc(SourcePtr);
      Inc(TargetPtr, N);
      Dec(PackedSize);
    end
    else
    begin // copy next N + 1 bytes literally
      Move(SourcePtr^, TargetPtr^, N + 1);
      Inc(TargetPtr, N + 1);
      Inc(SourcePtr, N + 1);
      Dec(PackedSize, N + 1);
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPackbitsRLE.Encode(Source, Dest: Pointer; var FByteCounts: Cardinal);

begin

end;

//----------------- TPCXRLE --------------------------------------------------------------------------------------------

procedure TPCXRLE.Decode(var Source: Pointer; Dest: Pointer; PackedSize, UnpackedSize: Integer);

var
  Count: Integer;
  SourcePtr,
  TargetPtr: PByte;
  
begin
  SourcePtr := Source;
  TargetPtr := Dest;
  while UnpackedSize > 0 do
  begin
    if (SourcePtr^ and $C0) = $C0 then
    begin
      // RLE-Code
      Count := SourcePtr^ and $3F;
      Inc(SourcePtr);
      if UnpackedSize < Count then Count := UnpackedSize;
      FillChar(TargetPtr^, Count, SourcePtr^);
      Inc(SourcePtr);
      Inc(TargetPtr, Count);
      Dec(UnpackedSize, Count);
    end
    else
    begin
      // not compressed
      TargetPtr^ := SourcePtr^;
      Inc(SourcePtr);
      Inc(TargetPtr);
      Dec(UnpackedSize);
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TPCXRLE.Encode(Source, Dest: Pointer; var FByteCounts: Cardinal);

begin

end;

//----------------- TSGIRLE --------------------------------------------------------------------------------------------

procedure TSGIRLE.Decode(var Source: Pointer; Dest: Pointer; PackedSize, UnpackedSize: Integer);

var
  SourcePtr,
  TargetPtr: PByte;
  Source16Ptr: ^Word;
  Pixel: Byte;
  Pixel16: Word;
  RunLength: Cardinal;

begin
  if SampleSize = 1 then
  begin
    SourcePtr := Source;
    TargetPtr := Dest;
    while True do
    begin
      Pixel := SourcePtr^;
      Inc(SourcePtr);
      RunLength := Pixel and $7F;
      if RunLength = 0 then Break;

      if (Pixel and $80) <> 0 then
      begin
        Move(SourcePtr^, TargetPtr^, RunLength);
        Inc(TargetPtr, RunLength);
        Inc(SourcePtr, RunLength);
      end
      else
      begin
        Pixel := SourcePtr^;
        Inc(SourcePtr);
        FillChar(TargetPtr^, RunLength, Pixel);
        Inc(TargetPtr, RunLength);
      end;
    end;
  end
  else
  begin
    // 16 bits per sample
    Source16Ptr := Source;
    TargetPtr := Dest;
    while True do
    begin
      Pixel16 := Swap(Source16Ptr^);
      Inc(Source16Ptr);
      RunLength := Pixel16 and $7F;
      if RunLength = 0 then Break;

      if (Pixel16 and $80) <> 0 then
      begin
        while RunLength > 0 do
        begin
          // swapping to little endian and doing a shift right 8 bits is the same as
          // just taking the lower 8 bits
          TargetPtr^ := Byte(Source16Ptr^);
          Inc(TargetPtr);
          Inc(Source16Ptr);
          Dec(RunLength);
        end;
      end
      else
      begin
        Pixel := Byte(Source16Ptr^);
        Inc(Source16Ptr);
        FillChar(TargetPtr^, RunLength, Pixel);
        Inc(TargetPtr, RunLength);
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TSGIRLE.Encode(Source, Dest: Pointer; var FByteCounts: Cardinal);

begin
end;

//----------------- TCUTRLE --------------------------------------------------------------------------------------------

procedure TCUTRLE.Decode(var Source: Pointer; Dest: Pointer; PackedSize, UnpackedSize: Integer);

var
  TargetPtr: PByte;
  Pixel: Byte;
  RunLength: Cardinal;

begin
  TargetPtr := Dest;
  // skip first two bytes per row (I don't know their meaning)
  Inc(PByte(Source), 2);
  while True do
  begin
    Pixel := PByte(Source)^;
    Inc(PByte(Source));
    if Pixel = 0 then Break;

    RunLength := Pixel and $7F;
    if (Pixel and $80) = 0 then
    begin
      Move(Source^, TargetPtr^, RunLength);
      Inc(TargetPtr, RunLength);
      Inc(PByte(Source), RunLength);
    end
    else
    begin
      Pixel := PByte(Source)^;
      Inc(PByte(Source));
      FillChar(TargetPtr^, RunLength, Pixel);
      Inc(TargetPtr, RunLength);
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TCUTRLE.Encode(Source, Dest: Pointer; var FByteCounts: Cardinal);

begin

end;

//----------------- TGIFLZW --------------------------------------------------------------------------------------------

function TGIFLZW.DecodeLZW(Code: Cardinal): Boolean;

var
  InCode: Cardinal; // buffer for passed code

begin
  // handling of clear codes
  if Code = FClearCode then
  begin
    // reset of all variables
    FCodeSize := InitialCodeSize + 1;
    FCodeMask := (1 shl FCodeSize) - 1;
    FFreeCode := FClearCode + 2;
    FOldCode := NoLZWCode;
    Result := True;
    Exit;
  end;

  // check whether it is a valid, already registered code
  if Code > FFreeCode then
    raise Exception.Create('GIF LZW: invalid opcode.');
  
  // handling for the first LZW code: print and keep it
  if FOldCode = NoLZWCode then
  begin
    FFirstChar := FSuffix[Code];
    FTarget^ := FFirstChar;
    Inc(FTarget);
    FOldCode := Code;
    Result := True;
    Exit;
  end;

  // keep the passed LZW code
  InCode := Code;  

  // the first LZW code is always smaller than FFirstCode
  if Code = FFreeCode then
  begin
    FStackPointer^ := FFirstChar;
    Inc(FStackPointer);
    Code := FOldCode;
  end;

  // loop to put decoded bytes onto the stack
  while Code > FClearCode do
  begin
    FStackPointer^ := FSuffix[Code];
    Inc(FStackPointer);
    Code := FPrefix[Code];
  end;

  // place new code into code table
  FFirstChar := FSuffix[Code];
  FStackPointer^ := FFirstChar;
  Inc(FStackPointer);
  FPrefix[FFreeCode] := FOldCode;
  FSuffix[FFreeCode] := FFirstChar;

  // increase code size if necessary
  if (FFreeCode = FCodeMask) and
     (FCodeSize < 12) then
  begin
    Inc(FCodeSize);
    FCodeMask := (1 shl FCodeSize) - 1;
  end;
  if FFreeCode < 4095 then Inc(FFreeCode);

  // put decoded bytes (from the stack) into the target buffer
  FOldCode := InCode;
  repeat
    Dec(FStackPointer);
    FTarget^ := FStackPointer^;
    Inc(FTarget);
  until FStackPointer = @FStack;

  Result := True;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TGIFLZW.Decode(var Source: Pointer; Dest: Pointer; PackedSize, UnpackedSize: Integer);

var
  I: Integer;
  Data,           // current data
  Bits,           // counter for bit management
  Code: Cardinal; // current code value
  SourcePtr: PByte;

begin
  FTarget := Dest;
  SourcePtr := Source;

  // initialize parameter
  FCodeSize := InitialCodeSize + 1;
  FClearCode := 1 shl InitialCodeSize;
  FEOICode := FClearCode + 1;
  FFreeCode := FClearCode + 2;
  FOldCode := NoLZWCode;
  FCodeMask := (1 shl FCodeSize) - 1;

  // init code table
  for I := 0 to FClearCode - 1 do
  begin
    FPrefix[I] := NoLZWCode;
    FSuffix[I] := I;
  end;

  // initialize stack
  FStackPointer := @FStack;

  Data := 0;
  Bits := 0;
  while PackedSize > 0 do
  begin
    // read code from bit stream
    Inc(Data, SourcePtr^ shl Bits);
    Inc(Bits, 8);
    while Bits >= FCodeSize do
    begin
      // current code
      Code := Data and FCodeMask;
      // prepare next run
      Data := Data shr FCodeSize;
      Dec(Bits, FCodeSize);

      // EOICode -> decoding finished, check also for badly written codes and
      // terminate the loop as soon as the target is filled up
      if (Code = FEOICode) or
         ((PChar(FTarget) - PChar(Dest)) >= UnpackedSize) then Exit;

      if not DecodeLZW(Code) then Break;
    end;
    Inc(SourcePtr);
    Dec(PackedSize);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TGIFLZW.Encode(Source, Dest: Pointer; var FByteCounts: Cardinal);

begin
end;

//----------------- TRLADecoder ----------------------------------------------------------------------------------------

procedure TRLADecoder.Decode(var Source: Pointer; Dest: Pointer; PackedSize, UnpackedSize: Integer);

// decodes a simple run-length encoded strip of size PackedSize
// this is very similar to TPackbitsRLE 

var
  SourcePtr,
  TargetPtr: PByte;
  N: SmallInt;

begin
  TargetPtr := Dest;
  SourcePtr := Source;
  while PackedSize > 0 do
  begin
    N := ShortInt(SourcePtr^);
    Inc(SourcePtr);
    Dec(PackedSize);
    if N >= 0 then // replicate next Byte N + 1 times
    begin
      FillChar(TargetPtr^, N + 1, SourcePtr^);
      Inc(TargetPtr, N + 1);
      Inc(SourcePtr);
      Dec(PackedSize);
    end
    else
    begin // copy next -N bytes literally
      Move(SourcePtr^, TargetPtr^, -N);
      Inc(TargetPtr, -N);
      Inc(SourcePtr, -N);
      Inc(PackedSize, N);
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TRLADecoder.Encode(Source, Dest: Pointer; var FByteCounts: Cardinal);

begin
end;

//----------------------------------------------------------------------------------------------------------------------

end.

