unit AsphyreArcSQX;
//---------------------------------------------------------------------------
// AsphyreArcSQX.pas                                    Modified: 14-Jan-2007
// Archive Wrapper for SQX file format                            Version 1.0
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
 AsphyreSQX;

//---------------------------------------------------------------------------
type
 TAsphyreArchiveSQX = class(TAsphyreCustomArchive)
 private
  ArchiveHandle: THandle;

  FileList: array of string;

  procedure ClearList();
  function AddToList(const FileName: string): Integer;
  function ListFiles(): Boolean;
 protected
  function GetItemCount(): Integer; override;
  function GetItemName(Num: Integer): string; override;
  function OpenArchive(const FileName: string): Boolean; override;
  procedure CloseArchive(); override;
  procedure DoCreate(); override;
 public
  function ExtractToDisk(const ItemName,
   DestPath: string): Boolean; override;
  function ExtractToStream(const ItemName: string;
   Stream: TStream): Boolean; override;
 end;

//---------------------------------------------------------------------------
procedure RegisterSQX(const Ext: string);

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
function SqxCallback(Param: Pointer;
 var CallbackInfo: TSqxCallbackInfo): Integer; stdcall;
begin
 Result:= SQX_PROGRESS_OK;
end;

//---------------------------------------------------------------------------
procedure TAsphyreArchiveSQX.DoCreate();
begin
 FAttributes:= [aaNoExtractToMem];
 ArchiveHandle:= 0;
end;

//---------------------------------------------------------------------------
procedure TAsphyreArchiveSQX.ClearList();
begin
 SetLength(FileList, 0);
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveSQX.AddToList(const FileName: string): Integer;
var
 Index: Integer;
begin
 Index:= Length(FileList);
 SetLength(FileList, Index + 1);

 FileList[Index]:= FileName;
 Result:= Index;
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveSQX.ListFiles(): Boolean;
var
 FileMaskList: THandle;
 ArcFileList : PSqxArcList;
 ArcInfo     : TSqxArcInfo;
 ListNode    : PSqxArcListNode;
begin
 // Create the lists.
 FileMaskList:= SqxInitFileList(ArchiveHandle);
 Result:= (FileMaskList <> 0);
 if (not Result) then Exit;

 ArcFileList := SqxInitArcFileList(ArchiveHandle);
 Result:= (ArcFileList <> nil);
 if (not Result) then Exit;

 // Initialize archive information.
 FillChar(ArcInfo, SizeOf(TSqxArcInfo), 0);
 ArcInfo.Size:= SizeOf(TSqxArcInfo);

 // Listing all files.
 SqxAppendFileList(ArchiveHandle, FileMaskList, PChar('*.*'));

 // List the archive.
 Result:= (SqxListFiles(ArchiveHandle, FileMaskList, ArcFileList,
  ArcInfo) = SQX_ERR_SUCCESS);
 if (not Result) then
  begin
   SqxDoneFileList(ArchiveHandle, FileMaskList);
   SqxDoneArcFileList(ArchiveHandle, ArcFileList);
  end;

 // Getting the first node.
 ListNode:= ArcFileList.Head;
 while (ListNode <> nil) do
  begin
   if (ListNode.ArcNode.Tagged) then
    AddToList(ListNode.ArcNode.FileName);
    
   ListNode:= ListNode.Next;
  end;

 // Free the lists.
 SqxDoneFileList(ArchiveHandle, FileMaskList);
 SqxDoneArcFileList(ArchiveHandle, ArcFileList);
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveSQX.OpenArchive(const FileName: string): Boolean;
begin
 // Initialize SQX archiver
 if (ArchiveHandle = 0) then
  begin
   Result:= (SqxInitArchive(PChar(FileName), SqxCallback, Self,
    ArchiveHandle) = SQX_ERR_SUCCESS);
   if (not Result) then Exit;
  end;

 ClearList();
 Result:= ListFiles();
end;

//---------------------------------------------------------------------------
procedure TAsphyreArchiveSQX.CloseArchive();
begin
 if (ArchiveHandle <> 0) then
  begin
   SqxDoneArchive(ArchiveHandle);
   ArchiveHandle:= 0;
  end;
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveSQX.GetItemCount(): Integer;
begin
 Result:= Length(FileList);
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveSQX.GetItemName(Num: Integer): string;
begin
 Assert((Num >= 0)and(Num < Length(FileList)), msgIndexOutOfBounds);
 Result:= FileList[Num];
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveSQX.ExtractToDisk(const ItemName,
 DestPath: string): Boolean;
var
 FileMaskList: THandle;
 ExtractOptions: TSqxExtractOptions;
begin
 // Create a file list.
 FileMaskList:= SqxInitFileList(ArchiveHandle);
 Result:= (FileMaskList <> 0);
 if (not Result) then Exit;

 // Extracting the specific file.
 SqxAppendFileList(ArchiveHandle, FileMaskList, PChar(ItemName));

 // Extract options.
 FillChar(ExtractOptions, SizeOf(TSqxExtractOptions), 0);
 ExtractOptions.Size:= SizeOf(TSqxExtractOptions);

 // Extract to the destination path.
 lstrcpy(@ExtractOptions.OutputPath, PChar(DestPath));
 ExtractOptions.CreateFolders:= True;
 ExtractOptions.OverwriteAlways:= True;

 // Extract the archive.
 Result:= SqxExtractFiles(ArchiveHandle, SqxCallback, Self, FileMaskList,
  ExtractOptions) = SQX_ERR_SUCCESS;

 // Free the file list.
 SqxDoneFileList(ArchiveHandle, FileMaskList);
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveSQX.ExtractToStream(const ItemName: string;
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
procedure RegisterSQX(const Ext: string);
begin
 ArchiveManager.RegisterExt(Ext, TAsphyreArchiveSQX);
end;

//---------------------------------------------------------------------------
end.
