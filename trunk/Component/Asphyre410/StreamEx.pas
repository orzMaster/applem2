unit StreamEx;

//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Types, Classes;

//---------------------------------------------------------------------------
function stReadLongint(Stream: TStream): Longint;
procedure stWriteLongint(Stream: TStream; const Value: Longint);
function stReadLongword(Stream: TStream): Longword;
procedure stWriteLongword(Stream: TStream; const Value: Longword);
function stReadInt64(Stream: TStream): Int64;
procedure stWriteInt64(Stream: TStream; const Value: Int64);
function stReadByte(Stream: TStream): Byte;
procedure stWriteByte(Stream: TStream; const Value: Byte);
function stReadShortInt(Stream: TStream): ShortInt;
procedure stWriteShortInt(Stream: TStream; const Value: ShortInt);
function stReadWord(Stream: TStream): Word;
procedure stWriteWord(Stream: TStream; const Value: Word);
function stReadSmallInt(Stream: TStream): SmallInt;
procedure stWriteSmallInt(Stream: TStream; const Value: SmallInt);
function stReadChar(Stream: TStream): Char;
function stReadSingle(Stream: TStream): Single;
procedure stWriteSingle(Stream: TStream; const Value: Single);
function stReadDouble(Stream: TStream): Double;
procedure stWriteDouble(Stream: TStream; const Value: Double);
procedure stWriteChar(Stream: TStream; const Value: Char);
function stReadBool(Stream: TStream): Boolean;
procedure stWriteBool(Stream: TStream; const Value: Boolean);
function stReadPoint(Stream: TStream): TPoint;
procedure stWritePoint(Stream: TStream; const Value: TPoint);
function stReadString(Stream: TStream): string;
procedure stWriteString(Stream: TStream; const Value: string);

// Floating-point 3:4 (-8.0 to 7.9375)
procedure stWriteFloat34(Stream: TStream; Value: Single);
function stReadFloat34(Stream: TStream): Single;
//----------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
function stReadLongint(Stream: TStream): Longint;
begin
 // read a single integer
 Stream.Read(Result, SizeOf(Longint));
end;

//---------------------------------------------------------------------------
procedure stWriteLongint(Stream: TStream; const Value: Longint);
begin
 // write a single integer
 Stream.Write(Value, SizeOf(Longint));
end;

//---------------------------------------------------------------------------
function stReadLongword(Stream: TStream): Longword;
begin
 // read a single Longword
 Stream.Read(Result, SizeOf(Longword));
end;

//---------------------------------------------------------------------------
procedure stWriteLongword(Stream: TStream; const Value: Longword);
begin
 // write a single Longword
 Stream.Write(Value, SizeOf(Longword));
end;

//---------------------------------------------------------------------------
function stReadInt64(Stream: TStream): Int64;
begin
 // read a single 64-bit integer
 Stream.Read(Result, SizeOf(Int64));
end;

//---------------------------------------------------------------------------
procedure stWriteInt64(Stream: TStream; const Value: Int64);
begin
 // write a single 64-bit integer
 Stream.Write(Value, SizeOf(Int64));
end;

//---------------------------------------------------------------------------
function stReadChar(Stream: TStream): Char;
begin
 // read a single character
 Stream.Read(Result, SizeOf(Char));
end;

//---------------------------------------------------------------------------
procedure stWriteChar(Stream: TStream; const Value: Char);
begin
 // write a single character
 Stream.Write(Value, SizeOf(Char));
end;

//---------------------------------------------------------------------------
function stReadByte(Stream: TStream): Byte;
begin
 // read a single character
 Stream.Read(Result, SizeOf(Byte));
end;

//---------------------------------------------------------------------------
procedure stWriteByte(Stream: TStream; const Value: Byte);
begin
 // write a single character
 Stream.Write(Value, SizeOf(Byte));
end;

//---------------------------------------------------------------------------
function stReadShortInt(Stream: TStream): ShortInt;
begin
 // read a single character
 Stream.Read(Result, SizeOf(ShortInt));
end;

//---------------------------------------------------------------------------
procedure stWriteShortInt(Stream: TStream; const Value: ShortInt);
begin
 // write a single character
 Stream.Write(Value, SizeOf(ShortInt));
end;

//---------------------------------------------------------------------------
function stReadWord(Stream: TStream): Word;
begin
 // read a single character
 Stream.Read(Result, SizeOf(Word));
end;

//---------------------------------------------------------------------------
procedure stWriteWord(Stream: TStream; const Value: Word);
begin
 // write a single character
 Stream.Write(Value, SizeOf(Word));
end;

//---------------------------------------------------------------------------
function stReadSmallInt(Stream: TStream): SmallInt;
begin
 Stream.Read(Result, SizeOf(Word));
end;

//---------------------------------------------------------------------------
procedure stWriteSmallInt(Stream: TStream; const Value: SmallInt);
begin
 Stream.Write(Value, SizeOf(SmallInt));
end;

//---------------------------------------------------------------------------
function stReadDouble(Stream: TStream): Double;
begin
 // read a single character
 Stream.Read(Result, SizeOf(Double));
end;

//---------------------------------------------------------------------------
procedure stWriteDouble(Stream: TStream; const Value: Double);
begin
 // write a single character
 Stream.Write(Value, SizeOf(Double));
end;

//---------------------------------------------------------------------------
function stReadSingle(Stream: TStream): Single;
begin
 // read a single character
 Stream.Read(Result, SizeOf(Single));
end;

//---------------------------------------------------------------------------
procedure stWriteSingle(Stream: TStream; const Value: Single);
begin
 // write a single character
 Stream.Write(Value, SizeOf(Single));
end;

//---------------------------------------------------------------------------
function stReadBool(Stream: TStream): Boolean;
begin
 Stream.Read(Result, SizeOf(Boolean));
end;

//---------------------------------------------------------------------------
procedure stWriteBool(Stream: TStream; const Value: Boolean);
begin
 Stream.Write(Value, SizeOf(Boolean));
end;

//---------------------------------------------------------------------------
function stReadPoint(Stream: TStream): TPoint;
begin
 Stream.Read(Result, SizeOf(TPoint));
end;

//---------------------------------------------------------------------------
procedure stWritePoint(Stream: TStream; const Value: TPoint);
begin
 Stream.Write(Value, SizeOf(TPoint));
end;

//---------------------------------------------------------------------------
function stReadString(Stream: TStream): string;
var
 Count, i: Integer;
begin
 // read string length
 Count:= stReadLongint(Stream);

 // define result length
 SetLength(Result, Count);

 // read char by char
 for i:= 0 to Count - 1 do
  Result[i + 1]:= stReadChar(Stream);
end;

//---------------------------------------------------------------------------
procedure stWriteString(Stream: TStream; const Value: string);
var
 i: Integer;
begin
 // write string length
 stWriteLongint(Stream, Length(Value));

 // write char by char
 for i:= 0 to Length(Value) - 1 do
  stWriteChar(Stream, Value[i + 1]);
end;

//----------------------------------------------------------------------------
procedure stWriteFloat34(Stream: TStream; Value: Single);
var
 Aux: Integer;
begin
 Aux:= Round(Value * 16.0);
 if (Aux > 127) then Aux:= 127;
 if (Aux < -128) then Aux:= -128;

 stWriteShortInt(Stream, Aux);
end;

//----------------------------------------------------------------------------
function stReadFloat34(Stream: TStream): Single;
begin
 Result:= stReadShortInt(Stream) / 16.0;
end;

//----------------------------------------------------------------------------
end.
