unit AsphyreArcASDb;
//---------------------------------------------------------------------------
// AsphyreArcASDb.pas                                   Modified: 07-Jan-2007
// Archive Wrapper for ASDb file format                           Version 1.0
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
 Classes, SysUtils, AsphyreAsserts, AsphyreDb,  MediaUtils, AsphyreArchives;

//---------------------------------------------------------------------------
type
 TAsphyreArchiveASDb = class(TAsphyreCustomArchive)
 private
  FArchive: TASDb;
 protected
  function GetItemCount(): Integer; override;
  function GetItemName(Num: Integer): string; override;
  function OpenArchive(const FileName: string): Boolean; override;
  procedure CloseArchive(); override;
  procedure DoCreate(); override;
 public
  property Archive: TASDb read FArchive;

  function ExtractToDisk(const ItemName,
   DestPath: string): Boolean; override;
  function ExtractToStream(const ItemName: string;
   Stream: TStream): Boolean; override;
 end;

//---------------------------------------------------------------------------
procedure RegisterASDb(const Ext: string);

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
procedure TAsphyreArchiveASDb.DoCreate();
begin
 FAttributes:= [];
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveASDb.OpenArchive(const FileName: string): Boolean;
begin
 Result:= True;

 if (FArchive = nil) then
  begin
   FArchive:= TASDb.Create();
   FArchive.OpenMode:= opReadOnly;
  end;

 if (FArchive.FileName <> FileName) then
  begin
   FArchive.FileName:= FileName;
   Result:= FArchive.UpdateOnce();
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreArchiveASDb.CloseArchive();
begin
 if (FArchive <> nil) then
  begin
   FArchive.Free();
   FArchive:= nil;
  end;
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveASDb.GetItemCount(): Integer;
begin
 Assert((FArchive <> nil)and(FArchive.FileName <> ''), msgArchiveNotOpened);

 Result:= FArchive.RecordCount;
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveASDb.GetItemName(Num: Integer): string;
begin
 Assert((FArchive <> nil)and(FArchive.FileName <> ''), msgArchiveNotOpened);

 Result:= FArchive.RecordKey[Num];
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveASDb.ExtractToStream(const ItemName: string;
 Stream: TStream): Boolean;
begin
 Assert((FArchive <> nil)and(FArchive.FileName <> ''), msgArchiveNotOpened);

 Result:= FArchive.ReadStream(ItemName, Stream);
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveASDb.ExtractToDisk(const ItemName,
 DestPath: string): Boolean;
var
 Stream: TFileStream;
begin
 Stream:= TFileStream.Create(MakeValidPath(DestPath) +
  MakeValidFileName(ItemName), fmCreate or fmShareExclusive);
 try
  try
   Result:= FArchive.ReadStream(ItemName, Stream);
  except
   Result:= False;
  end;
 finally
  Stream.Free();
 end;
end;

//---------------------------------------------------------------------------
procedure RegisterASDb(const Ext: string);
begin
 ArchiveManager.RegisterExt(Ext, TAsphyreArchiveASDb);
end;

//---------------------------------------------------------------------------
end.
