unit untDFFileLib;

interface

uses
  Windows, SysUtils, Classes, FileCtrl, ShellAPI, ShlObj, ActiveX;

  procedure DFDeleteLastSlash(var DirectoryName: string);
  function  DFIsDirectoryEmpty(DirectoryName: string): boolean;
  function  DFGetFileNameWithoutExt(FileName: string): string;
  function  DFGetFileExtension(FileName: string): string;
  function  DFGetTempPathPas: string;
  function  DFDeleteDirectory(DirectoryName: string; ShowProgressDialog: boolean): boolean;
  function  DFCopyDirectory(SourceDirectory, DestinationDirectory: string; ShowProgressDialog: boolean): boolean;
  function  DFMoveDirectory(SourceDirectory, DestinationDirectory: string; ShowProgressDialog: boolean): boolean;
  function  DFFileDirOperations(Action: string; RenameIfExists: boolean;
                              NoConfirmation: boolean; Silent: boolean;
                              ShowProgress: boolean;
                              SourceDirectory: string; DestinationDirectory: string): boolean;
  function  DFFileOperations(Action: string; RenameIfExists: boolean; ShowProgress: boolean;
                             SourceFiles, DestinationFiles: TStringList): boolean;
  function  DFBrowseForFolder(Owner: THandle; Title, DefaultDirectory: string): string;
  procedure DFGetFilesFromDirectory(Directory, Mask: string; Recurse: boolean; FileList: TStrings);
  procedure DFGetDirsFromDirectory(Directory, Mask: string; Recurse: boolean; FileList: TStrings);
  function  DFCreateTempFileName(DirectoryName, Prefix, Extension: string): string;
  function  DFGetTempFileNameWin(Directory, Prefix: string): string;
  procedure DFChangeFileDateTime(FileName, vDirName: string;
                              b1, b2, b3: boolean;
                              d1, t1, d2, t2, d3, t3: TDateTime);
  function  DFChangeDateTime(vFileList: TStrings; vDirName: string;
                          b1, b2, b3: boolean;
                          d1, t1, d2, t2, d3, t3: TDateTime): boolean;
  function  DFCompareFiles(File1, File2: string): integer;
  procedure DFSetFileAttributes(Directory, Mask: string; Recurse: boolean; FileAttributes: DWORD);
  procedure DFDeleteFilesInDirectory(Directory, Mask: string);
  function  DFReplaceTextInFile(FileName, SearchString, ReplaceString: string; CaseSensitve: Boolean): Integer;
  procedure DFRenameFiles(SourceList, DestinationList: TStringList);
  procedure DFCopyFiles(SourceList, DestinationList: TStringList; Overwrite: boolean; ShowProgress: boolean);
  procedure DOSToUnix(FileName: string);
  procedure UnixToDOS(FileName: string);

  {
  Dateien kopieren (von Verz. nach), überschreiben
  Dateiinhalte vergleichen
  Dateien verschieben
  Text von Fundstelle bis Fundstelle ersetzen
  }

implementation

var
  BrowseFolderDirectory: string;

procedure DFDeleteLastSlash(var DirectoryName: string);
var
  DirectoryNameLength: Integer;
begin
  DirectoryNameLength := Length(DirectoryName);

  if DirectoryNameLength > 1 then
  begin
    if DirectoryName[DirectoryNameLength] = '\' then
      Delete(DirectoryName, DirectoryNameLength, 1);
  end;
end;

function DFIsDirectoryEmpty(DirectoryName: string): boolean;
var
  SrcRec: TSearchRec;
  Found: boolean;
begin
  Result := true;
  Found := false;

  DFDeleteLastSlash(DirectoryName);

  try
    if FindFirst(DirectoryName + '\*.*', faAnyFile, SrcRec) = 0 then
    repeat
      Found := true;
      if (SrcRec.Name <> '.') and (SrcRec.Name <> '..') then
      begin
        Result := false;
        break;
      end;
    until FindNext(SrcRec) <> 0;
  finally
    if Found then
      FindClose(SrcRec);
  end;
end;

function DFGetFileNameWithoutExt(FileName: string): string;
var
  FileExtLength, FileNameLength: Integer;
begin
  FileName := ExtractFileName(FileName);
  FileExtLength  := Length(ExtractFileExt(FileName)); // including the dot
  FileNameLength := Length(FileName);
  Result := Copy(FileName, 1, FileNameLength - FileExtLength);
end;

function DFGetFileExtension(FileName: string): string;
begin
  Result := ExtractFileExt(FileName);
  if Result[1] = '.' then
    Delete(Result, 1, 1);
end;

function DFGetTempPathPas: string;
var
  TempDirectory: array[0..255] of char;
begin
  GetTempPath(255, TempDirectory);
  Result := StrPas(TempDirectory);
  DFDeleteLastSlash(Result);
end;

function DFDeleteDirectory(DirectoryName: string; ShowProgressDialog: boolean): boolean;
begin
  Result := DFFileDirOperations('DELETE', false, true, ShowProgressDialog,
                              false, DirectoryName, '');
end;

function DFFileDirOperations(Action: string; RenameIfExists: boolean;
                           NoConfirmation: boolean; Silent: boolean;
                           ShowProgress: boolean;
                           SourceDirectory: string; DestinationDirectory: string): boolean;
var
  SHFileOpStruct: TSHFileOpStruct;
  SourceBuffer, DestinationBuffer: array[0..255] of char;
begin
  try
    if not DirectoryExists(SourceDirectory) then
    begin
      Result := False;
      exit;
    end;
    Fillchar(SHFileOpStruct, sizeof(SHFileOpStruct), 0);
    FillChar(SourceBuffer, sizeof(SourceBuffer), 0);
    FillChar(DestinationBuffer, sizeof(DestinationBuffer), 0);
    StrPCopy(SourceBuffer, SourceDirectory);
    StrPCopy(DestinationBuffer, DestinationDirectory);
    with SHFileOpStruct do
    begin
      Wnd    := 0;
      if UpperCase(Action) = 'COPY'   then wFunc := FO_COPY;
      if UpperCase(Action) = 'DELETE' then wFunc := FO_DELETE;
      if UpperCase(Action) = 'MOVE'   then wFunc := FO_MOVE;
      if UpperCase(Action) = 'RENAME' then wFunc := FO_RENAME;
      pFrom  := @SourceBuffer;
      pTo    := @DestinationBuffer;
      fFlags := FOF_ALLOWUNDO;
      hNameMappings := nil;
      lpszProgressTitle := nil;
      if RenameIfExists  then fFlags := fFlags or FOF_RENAMEONCOLLISION;
      if NoConfirmation  then fFlags := fFlags or FOF_NOCONFIRMATION;
      if Silent          then fFlags := fFlags or FOF_SILENT;
      if ShowProgress    then fFlags := fFlags or FOF_SIMPLEPROGRESS;
      fFlags := fFlags or FOF_NOCONFIRMMKDIR;
      end;
    Result := (SHFileOperation(SHFileOpStruct) = 0);
  except
    Result := False;
  end;
end;

function DFMoveDirectory(SourceDirectory, DestinationDirectory: string; ShowProgressDialog: boolean): boolean;
begin
  Result := DFFileDirOperations('MOVE', false, true, ShowProgressDialog, false,
                                SourceDirectory, DestinationDirectory);
end;

procedure DFBrowserCallBackProc(HWindow: HWND; uMsg: Integer; lPar: LPARAM; lpBrowseFolder: LPARAM); stdcall;
begin
  case uMsg of
    BFFM_INITIALIZED:
      begin
        SendMessage(HWindow, BFFM_SETSELECTION, Ord(True), LongInt(PChar(BrowseFolderDirectory)));
      end;
  end;
end;

function DFBrowseForFolder(Owner: THandle; Title, DefaultDirectory: string): string;
var
  BrowseInfo: TBrowseInfo;
  Buffer: PChar;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: LongWord;
begin
  Result := '';
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
    begin
    Buffer := ShellMalloc.Alloc(MAX_PATH);
    try
      SHGetDesktopFolder(IDesktopFolder);
      IDesktopFolder.ParseDisplayName(Owner, nil,
        POleStr(Title), Eaten, RootItemIDList, Flags);
      with BrowseInfo do
        begin
        hwndOwner := Owner;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PChar('Wählen Sie bitte einen Ordner aus ...');
        lpfn := @DFBrowserCallBackProc;
//        ulFlags := BIF_RETURNONLYFSDIRS;
        end;
      BrowseFolderDirectory := DefaultDirectory;
      ItemIDList := ShBrowseForFolder(BrowseInfo);
      if ItemIDList = nil then
        exit
      else
        begin
        ShGetPathFromIDList(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Result := Buffer;
        end;
    finally
      ShellMalloc.Free(Buffer);
    end{try};
    end;
end;

function DFCopyDirectory(SourceDirectory, DestinationDirectory: string;
                       ShowProgressDialog: boolean): boolean;
begin
  Result := DFFileDirOperations('COPY', false, true,
                                      false,     //Silent            : Boolean; //No progress dialog is shown
                                      false,    //ShowProgress      : Boolean; //displays progress dialog but no file names
                                      SourceDirectory,
                                      DestinationDirectory);
end;

procedure DFGetDirsFromDirectory(Directory, Mask: string; Recurse: boolean; FileList: TStrings);
var
  SearchRec: TSearchRec;
  Found: boolean;
begin
  Found := false;
  DFDeleteLastSlash(Directory);

  try
    if FindFirst(Directory + '\' + Mask, faDirectory, SearchRec) = 0 then
      repeat
        if ((SearchRec.Attr and faDirectory) <> 0) and
           (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          FileList.Add(Directory + '\' + SearchRec.Name);
          if Recurse then
            DFGetDirsFromDirectory(Directory + '\' + SearchRec.Name, Mask, true, FileList);
        end
      until FindNext(SearchRec) <> 0;
  finally
    if Found then
      FindClose(SearchRec);
  end;
end;

procedure DFGetFilesFromDirectory(Directory, Mask: string; Recurse: boolean; FileList: TStrings);
var
  SearchRec: TSearchRec;
  Found: boolean;
begin
  Found := false;
  DFDeleteLastSlash(Directory);

  try
    if FindFirst(Directory + '\' + Mask, faDirectory, SearchRec) = 0 then
      repeat
        if ((SearchRec.Attr and faDirectory) <> 0) and
           (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          if Recurse then
            DFGetFilesFromDirectory(Directory + '\' + SearchRec.Name, Mask, true, FileList);
        end
        else
          if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
            FileList.Add(Directory + '\' + SearchRec.Name);
      until FindNext(SearchRec) <> 0;
  finally
    if Found then
      FindClose(SearchRec);
  end;
end;

// uses only the first 3 Characters from prefix !
function DFGetTempFileNameWin(Directory, Prefix: string): string;
var
  TempFileName: array[0..255] of char;
begin
  GetTempFileName(PChar(Directory), PChar(Prefix), 10000, TempFileName);
  Result := StrPas(TempFileName);
end;

function DFCreateTempFileName(DirectoryName, Prefix, Extension: string): string;
var
  FileNo: integer;
  TempPath: string;
begin
  try
    if DirectoryName = '' then
      TempPath := DFGetTempPathPas
    else
      TempPath := DirectoryName;

    FileNo := 0;
    while FileExists (TempPath + '\~' + Prefix + IntToStr(FileNo) + '.tmp') do
      Inc (FileNo);

    Result := TempPath + '\~' + Prefix + IntToStr(FileNo) + '.tmp';
  except
    Result := '';
  end;
end;

function DFChangeDateTime(vFileList: TStrings; vDirName: string; b1, b2, b3: Boolean;
                          d1, t1, d2, t2, d3, t3: TDateTime): Boolean;
var
  HFileResult: HFILE;
  ofstr: _OFSTRUCT;
  FT1, FT2, FT3: FILETIME;
  ST1, ST2, ST3: SYSTEMTIME;
  i: Integer;
begin
  Result := False;

  try
    DecodeDate(d1, ST1.wYear, ST1.wMonth, ST1.wDay);
    DecodeDate(d2, ST2.wYear, ST2.wMonth, ST2.wDay);
    DecodeDate(d3, ST3.wYear, ST3.wMonth, ST3.wDay);
    DecodeTime(t1, ST1.wHour, ST1.wMinute, ST1.wSecond, ST1.wMilliseconds);
    DecodeTime(t2, ST2.wHour, ST2.wMinute, ST2.wSecond, ST2.wMilliseconds);
    DecodeTime(t3, ST3.wHour, ST3.wMinute, ST3.wSecond, ST3.wMilliseconds);

    ST1.wMilliseconds := 0;
    ST2.wMilliseconds := 0;
    ST3.wMilliseconds := 0;

    SystemTimeToFileTime(ST1, FT1);
    SystemTimeToFileTime(ST2, FT2);
    SystemTimeToFileTime(ST3, FT3);
    LocalFileTimeToFileTime(FT1, FT1);
    LocalFileTimeToFileTime(FT2, FT2);
    LocalFileTimeToFileTime(FT3, FT3);

    for i := 0 to vFileList.Count - 1 do
    begin
      if FileExists(vDirName + '\' + vFileList[i]) then
      begin
        HFileResult := OpenFile(PChar(vDirName + '\' + vFileList[i]), ofstr, OF_WRITE);
        if HFileResult <> HFILE_ERROR then
        begin
          if b1 then
            SetFileTime(HFileResult, @FT1, nil, nil);
          if b3 then
            SetFileTime(HFileResult, nil, nil, @FT2);
          if b2 then
            SetFileTime(HFileResult, nil, @FT3, nil);
        end;
        _lclose(HFileResult);
      end;
    end;
    Result := True;
  except

  end;
end;

procedure DFChangeFileDateTime(FileName, vDirName: string;
                            b1, b2, b3: Boolean;
                            d1, t1, d2, t2, d3, t3: TDateTime);
var
  vSL: TStringList;
begin
  vSL := TStringList.Create;
  try
    vSL.Add(FileName);
    DFChangeDateTime(vSL, vDirName, b1, b2, b3, d1, t1, d2, t2, d3, t3);
  finally
    vSL.Free;
  end;
end;

// -1 Fehler oder nicht gleiche Dateilänge, 0 gleich
function DFCompareFiles(File1, File2: string): integer;
const
  maxSize = 1024;
var
  fullCount, i: Integer;
  f1, f2: File;
  Src1Puffer, Src2Puffer: Pointer;
  cntRead1, cntRead2: Integer;
begin
  Result := -1;

  if (not FileExists(File1)) or (not FileExists(File2)) then
    raise Exception.Create('no files');

  GetMem(Src1Puffer, maxSize);
  GetMem(Src2Puffer, maxSize);

  try
    AssignFile(f1, File1);
    AssignFile(f2, File2);
    {$I+}
    try
      Reset(f1, 1);
      Reset(f2, 1);

      if FileSize(f1) <> FileSize(f2) then
        Result := -1
      else
      begin
        fullCount := 0;
        repeat
          BlockRead(f1, Src1Puffer^, maxSize, cntRead1);
          BlockRead(f2, Src2Puffer^, maxSize, cntRead2);

          if CompareMem(Src1Puffer, Src2Puffer, cntRead1) = false then
          begin
            i := 1;
            while (PChar(Src1Puffer) + i)^ = (PChar(Src2Puffer) + i)^ do
              Inc(i);

            Result := fullCount + i + 1;
            exit;
          end;

          fullCount := fullCount + cntRead1;
        until (cntRead1 = 0) or (cntRead1 <> cntRead2) or (cntRead2 = 0);
        Result := 0;
      end;
    finally
      CloseFile(f1);
      CloseFile(f2);
    end;
  finally
    FreeMem(Src1Puffer);
    FreeMem(Src2Puffer);
  end;
end;

procedure DFSetFileAttributes(Directory, Mask: string; Recurse: boolean; FileAttributes: DWORD);
var
  SearchRec: TSearchRec;
  Found: boolean;
begin
  Found := false;
  DFDeleteLastSlash(Directory);

  try
    if FindFirst(Directory + '\' + Mask, faDirectory, SearchRec) = 0 then
      repeat
        if ((SearchRec.Attr and faDirectory) <> 0) and
           (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          if Recurse then
            DFSetFileAttributes(Directory + '\' + SearchRec.Name, Mask, Recurse, FileAttributes);
        end
        else
          if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
            SetFileAttributes(PChar(Directory + '\' + SearchRec.Name), FileAttributes);
      until FindNext(SearchRec) <> 0;
  finally
    if Found then
      FindClose(SearchRec);
  end;
end;

procedure DFDeleteFilesInDirectory(Directory, Mask: string);
var
  SearchRec: TSearchRec;
  Found: boolean;
begin
  Found := false;
  DFDeleteLastSlash(Directory);

  try
    if FindFirst(Directory + '\' + Mask, faDirectory, SearchRec) = 0 then
      repeat
        if ((SearchRec.Attr and faDirectory) <> 0) and (SearchRec.Name <> '.') and
            (SearchRec.Name <> '..') then
          DeleteFile(PChar(Directory + '\' + SearchRec.Name));
      until FindNext(SearchRec) <> 0;
  finally
    if Found then
      FindClose(SearchRec);
  end;
end;

function DFReplaceTextInFile(FileName, SearchString, ReplaceString: string; CaseSensitve: Boolean): Integer;
var
  Stream: TStream;
  Size: Integer;
  S: string;
  vReplaceFlags: TReplaceFlags;
begin
  Result := 0;

  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareExclusive);
  try
    Size := Stream.Size - Stream.Position;
    SetString(S, nil, Size);
    Stream.Read(Pointer(S)^, Size);
  finally
    Stream.Free;
  end;

  vReplaceFlags := [rfReplaceAll];
  if(CaseSensitve) then
    vReplaceFlags := vReplaceFlags + [rfIgnoreCase];

  S := StringReplace(S, SearchString, ReplaceString, vReplaceFlags);

  Stream := TFileStream.Create(FileName, fmOpenWrite or fmShareExclusive);
  try
    Stream.WriteBuffer(Pointer(S)^, Length(S));
  finally
    Stream.Free;
  end;
end;

procedure DFRenameFiles(SourceList, DestinationList: TStringList);
var
  i: Integer;
begin
  if SourceList.Count <> DestinationList.Count then
    raise Exception.Create('Length of File lists are not equal.');
    
  for i := 0 to SourceList.Count - 1 do
    if FileExists(SourceList[i]) and not FileExists(DestinationList[i]) then
      RenameFile(SourceList[i], DestinationList[i]);
end;

procedure DFCopyFiles(SourceList, DestinationList: TStringList; Overwrite: boolean; ShowProgress: boolean);
begin
  DFFileOperations('COPY', Overwrite, ShowProgress,
                   SourceList, DestinationList);
end;

function DFFileOperations(Action: string; RenameIfExists: boolean; ShowProgress: boolean;
                           SourceFiles, DestinationFiles: TStringList): boolean;
var
  SHFileOpStruct: TSHFileOpStruct;
  s1, s2: string;
  i: Integer;
begin
  try
    Fillchar(SHFileOpStruct, sizeof(SHFileOpStruct), 0);
    with SHFileOpStruct do
    begin
      Wnd    := 0;
      if UpperCase(Action) = 'COPY'   then wFunc := FO_COPY;
      if UpperCase(Action) = 'DELETE' then wFunc := FO_DELETE;
      if UpperCase(Action) = 'MOVE'   then wFunc := FO_MOVE;
      if UpperCase(Action) = 'RENAME' then wFunc := FO_RENAME;

      for i := 0 to SourceFiles.Count - 1do
        s1 := s1 + SourceFiles[i] + #0;
      s1 := s1 + #0;
      for i := 0 to DestinationFiles.Count - 1 do
        s2 := s2 + DestinationFiles[i] + #0;
      s2 := s2 + #0;

      pFrom  := PChar(s1);
      pTo    := PChar(s2);
      hNameMappings := nil;
      lpszProgressTitle := nil;
      if RenameIfExists  then fFlags := fFlags or FOF_RENAMEONCOLLISION;
      if not ShowProgress then fFlags := fFlags or FOF_SILENT;
      fFlags := fFlags or FOF_NOCONFIRMMKDIR;
      end;
    Result := (SHFileOperation(SHFileOpStruct) = 0);
  except
    Result := False;
  end;
end;

procedure UnixToDOS(FileName: string);
var
  S: TStringList;
begin
  S := TStringList.Create;

  try
    S.LoadFromFile(FileName);
    S.SaveToFile(FileName);
  finally
    S.Free;
  end;
end;

procedure DOSToUnix(FileName: string);
var
  S: TStringList;
  LineCount: Integer;
  F: System.TextFile;
begin
  S := TStringList.Create;

  try
    S.LoadFromFile(FileName);
    AssignFile(F, FileName);
    ReWrite(F);

    for LineCount := 0 to S.Count - 1 do
      write(F, S[LineCount], chr($0A));
    CloseFile(F);
  finally
    S.Free;
  end;
end;

end.
