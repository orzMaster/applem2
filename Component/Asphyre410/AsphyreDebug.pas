unit AsphyreDebug;
//---------------------------------------------------------------------------
// AsphyreDebug.pas                                     Modified: 08-Jan-2007
// Utility routines for debugging Asphyre applications            Version 1.0
//---------------------------------------------------------------------------
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS"
// basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
// License for the specific language governing rights and limitations
// under the License.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
{$include Asphyre4.inc}

//---------------------------------------------------------------------------
// Enable the following option to dump debug text to Delphi's event console.
//---------------------------------------------------------------------------
{$DEFINE UseOutputDebugString}

//---------------------------------------------------------------------------
// Enable the following option to dump debug text to external file.
// The file will have the same name as the application, ending with ".log".
//---------------------------------------------------------------------------
{$DEFINE UseLogFile}

//---------------------------------------------------------------------------
{$i-}

//---------------------------------------------------------------------------
{$IFDEF UseOutputDebugString}
uses
 Windows, SysUtils;{$ENDIF}

//---------------------------------------------------------------------------
{$IFDEF DebugMode}
procedure DebugLog(const Text: string);
{$ENDIF}

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
{$IFDEF UseLogFile}
var
 LogFile: TextFile;
{$ENDIF}

//---------------------------------------------------------------------------
{$IFDEF UseLogFile}
procedure InitializeLog();
begin
 AssignFile(LogFile, ChangeFileExt(ParamStr(0), '.log'));
 ReWrite(LogFile);

 WriteLn(LogFile, 'Executed name: ' + ExtractFileName(ParamStr(0)));
 WriteLn(LogFile, 'Executed date: ' + DateTimeToStr(Now()));
 WriteLn(LogFile, '-------------------- ENTRY -----------------------');
 CloseFile(LogFile);
end;
{$ENDIF}

//---------------------------------------------------------------------------
{$IFDEF UseLogFile}
procedure FinalizeLog();
begin
 Append(LogFile);
 WriteLn(LogFile, '-------------------- EXIT ------------------------');
 CloseFile(LogFile);
end;
{$ENDIF}

//---------------------------------------------------------------------------
{$IFDEF DebugMode}
procedure DebugLog(const Text: string);
begin
 {$IFDEF UseOutputDebugString}
 OutputDebugString(PChar(Text));
 {$ENDIF}

{$IFDEF UseLogFile}
 Append(LogFile);
 WriteLn(LogFile, Text);
 CloseFile(LogFile);
 {$ENDIF}
end;
{$ENDIF}

//---------------------------------------------------------------------------
initialization
 {$IFDEF DebugMode}
 {$IFDEF UseLogFile}
 InitializeLog();
 {$ENDIF}
 {$ENDIF}

//---------------------------------------------------------------------------
finalization
 {$IFDEF DebugMode}
 {$IFDEF UseLogFile}
 FinalizeLog();
 {$ENDIF}
 {$ENDIF}

//---------------------------------------------------------------------------
end.
