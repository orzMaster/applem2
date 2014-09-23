unit AsphyrePrfl;

//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Windows, SysUtils;

//---------------------------------------------------------------------------
procedure BeginMeasure();
procedure EndMeasure();
function GetMeasure(): Single;
function GetMeasureFPS(): Single;
function MeasureText(): string;
function MeasureFPSText(): string;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
const
 SampleCount = 120;

//---------------------------------------------------------------------------
var
 Freq, InitTime, EndTime: Int64;
 Elapsed: Single;
 ElapsedAvg: array[0..SampleCount - 1] of Single;

//---------------------------------------------------------------------------
procedure BeginMeasure();
begin
 QueryPerformanceFrequency(Freq);
 QueryPerformanceCounter(InitTime);
end;

//---------------------------------------------------------------------------
procedure EndMeasure();
var
 Taken: Single;
 i: Integer;
begin
 QueryPerformanceCounter(EndTime);
 Taken:= 1000.0 * (EndTime - InitTime) / Freq;

 for i:= 0 to SampleCount - 2 do
  ElapsedAvg[i]:= ElapsedAvg[i + 1];

 ElapsedAvg[SampleCount - 1]:= Taken;

 Elapsed:= 0.0;
 for i:= 0 to SampleCount - 1 do
  Elapsed:= Elapsed + ElapsedAvg[i];

 Elapsed:= Elapsed / SampleCount;
end;

//---------------------------------------------------------------------------
function GetMeasure(): Single;
begin
 Result:= Elapsed;
end;

//---------------------------------------------------------------------------
function GetMeasureFPS(): Single;
begin
 if (Elapsed <> 0.0) then Result:= 1000.0 / Elapsed
  else Result:= 0.0;
end;

//---------------------------------------------------------------------------
function MeasureText(): string;
begin
 Result:= Format('%1.1f', [Elapsed]);
end;

//---------------------------------------------------------------------------
function MeasureFPSText(): string;
begin
 Result:= IntToStr(Round(GetMeasureFPS()));
end;

//---------------------------------------------------------------------------
end.
