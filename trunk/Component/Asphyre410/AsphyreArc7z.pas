unit AsphyreArc7z;
//---------------------------------------------------------------------------
// AsphyreArc7z.pas                                     Modified: 07-Jan-2007
// Archive Wrapper for 7z file format                             Version 1.0
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
uses
 Windows, Classes, SysUtils, AsphyreAsserts, MediaUtils, AsphyreArchives,
 SevenZipVCL;

//---------------------------------------------------------------------------
type
 TAsphyreArchive7z = class(TAsphyreCustomArchive)
 private
  FArchive: TSevenZip;

  FileList: array of string;

  procedure ClearList();
  function AddToList(const FileName: string): Integer;
  procedure EventListFile(Sender: TObject; Filename: WideString; FileIndex,
   FileSizeU, FileSizeP, Fileattr, Filecrc: Cardinal; FileMethod: WideString;
   FileTime: Double);
 protected
  function GetItemCount(): Integer; override;
  function GetItemName(Num: Integer): string; override;
  function OpenArchive(const FileName: string): Boolean; override;
  procedure CloseArchive(); override;
  procedure DoCreate(); override;
 public
  property Archive: TSevenZip read FArchive;

  function ExtractToDisk(const ItemName,
   DestPath: string): Boolean; override;
  function ExtractToStream(const ItemName: string;
   Stream: TStream): Boolean; override;
 end;

//---------------------------------------------------------------------------
procedure Register7z(const Ext: string);

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
procedure TAsphyreArchive7z.DoCreate();
begin
 FAttributes:= [aaNoExtractToMem];
end;

//---------------------------------------------------------------------------
procedure TAsphyreArchive7z.ClearList();
begin
 SetLength(FileList, 0);
end;

//---------------------------------------------------------------------------
function TAsphyreArchive7z.AddToList(const FileName: string): Integer;
var
 Index: Integer;
begin
 Index:= Length(FileList);
 SetLength(FileList, Index + 1);

 FileList[Index]:= FileName;
 Result:= Index;
end;

//---------------------------------------------------------------------------
procedure TAsphyreArchive7z.EventListFile(Sender: TObject; FileName: WideString;
 FileIndex, FileSizeU, FileSizeP, Fileattr, Filecrc: Cardinal;
 FileMethod: WideString; FileTime: Double);
begin
 AddToList(FileName);
end;

//---------------------------------------------------------------------------
function TAsphyreArchive7z.OpenArchive(const FileName: string): Boolean;
begin
 Result:= True;

 if (FArchive = nil) then
  begin
   FArchive:= TSevenZip.Create(nil);
   FArchive.OnListfile:= EventListFile;
  end;

 if (FArchive.SZFileName <> FileName) then
  begin
   ClearList();

   FArchive.SZFileName:= FileName;

   Result:= True;
   try
    FArchive.List();
   except
    Result:= False;
   end;
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreArchive7z.CloseArchive();
begin
 if (FArchive <> nil) then
  begin
   FArchive.Free();
   FArchive:= nil;
  end;
end;

//---------------------------------------------------------------------------
function TAsphyreArchive7z.GetItemCount(): Integer;
begin
 Result:= Length(FileList);
end;

//---------------------------------------------------------------------------
function TAsphyreArchive7z.GetItemName(Num: Integer): string;
begin
 Assert((Num >= 0)and(Num < Length(FileList)), msgIndexOutOfBounds);
 Result:= FileList[Num];
end;

//---------------------------------------------------------------------------
function TAsphyreArchive7z.ExtractToDisk(const ItemName,
 DestPath: string): Boolean;
begin
 FArchive.ExtrBaseDir:= DestPath;
 FArchive.ExtractOptions:= FArchive.ExtractOptions + [ExtractOverwrite];

 FArchive.Files.Clear();
 FArchive.Files.AddString(IntToStr(FArchive.GetIndexByFilename(ItemName)));

 Result:= (FArchive.Extract() <> 1);
end;

//---------------------------------------------------------------------------
function TAsphyreArchive7z.ExtractToStream(const ItemName: string;
 Stream: TStream): Boolean;
var
 TempPath, TempFile: string;
 Aux: TFileStream;
begin
 TempPath:= GetTempPath();

 Result:= ExtractToDisk(ItemName, TempPath);
 if (Result) then
  begin
   TempFile:= MakeValidPath(TempPath) + MakeValidFileName(ItemName);

   try
    Aux:= TFileStream.Create(TempFile, fmOpenRead or fmShareDenyWrite);
   except
    Result:= False;
    DeleteFile(TempFile);
    Exit;
   end;

   try
    try
     Stream.CopyFrom(Aux, Aux.Size);
    except
     Result:= False;
    end;
   finally
    Aux.Free();
    DeleteFile(TempFile);
   end;
  end;
end;

//---------------------------------------------------------------------------
procedure Register7z(const Ext: string);
begin
 ArchiveManager.RegisterExt(Ext, TAsphyreArchive7z);
end;

//---------------------------------------------------------------------------
end.
