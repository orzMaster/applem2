{
  MYC:2006/08/17 = To fix bug with stress Filenames in archive (tested with D6)
  - change TDFUnRar.hdrData from TRARHeaderData to TRARHeaderDataEx (line 74)
  - change calls to RARReadHeader() into calls to RARReadHeaderEx() (lines 372, 651, 719)
  - change TDFRARHeaderData.FileName assignments from "StrPas(hdrData.FileName)" to "WideCharToString(hdrData.FileNameW)"
    (lines 182, 502)
}
{
  TDFUnRar for Delphi (tested with D5)
  should work for all Windows-versions from Win95

  Copyright (C) 2003 by Dirk Frischalowski, All rights reserved
  eMail: dfrischalowski@del-net.com

  free, also for commercial use
}
unit DFUnRar;

interface

uses
  Windows, Messages, SysUtils, Classes, untUnRar;

type
  // Testing is the same as listening - so check the file-status in the event OnFileProcessing
  TDFRarMode = (DFRAR_EXTRACT, DFRAR_LIST);
  // Used for Status Messages in the event OnStatus
  TRarStatus = (RAR_ONOPEN, RAR_ONBEFOREOPEN, RAR_AFTERCLOSE, RAR_ONPASSWORD);
  // Override Options for overriding files
  TOverrideOptions = (OR_ALWAYS, OR_NEVER, OR_EVENT);

  // translated original header for easier usability
  TDFRARHeaderData = record
    ArchiveName: string; // Archiv-Name
    FileName: string; // FileName in Archiv with relativ Path
    FlagContinueNextVol: boolean; // File are continue in the next volumn
    FlagContinuePrevVol: boolean; // more of a File are in the previous volumn
    FlagNeedPassword: boolean; // you need a password to extract this file
    IsDirectory: boolean; // this is a directory entry
    DictionarySize: Integer; // size of the dictionary (not used here)
    PackSize: cardinal; // packed filesize
    UnpSize: cardinal; // unpacked filesize
    HostOS: string; // Name of Host Operation System
    FileCRC: string; // CRC-Code of File as 'F4F5F6F7'
    FileTime: TDateTime; // FileTime (Delphi-Format)
    MajorVersionNeeded: Cardinal; // Major Version needed to extract a file
    MinorVersionNeeded: Cardinal; // Minor Version needed to extract a file
    Method: string; // Compress Method - see constants in untUnRar.pas - COMPRESSMETHODxxxxx
    FAArchive: boolean; // FileAttribute Archiv is set
    FACompressed: boolean; // FileAttribute compressed is set
    FADirectory: boolean; // FileAttribute directory is set
    FAHidden: boolean; // FileAttribute hidden is set
    FANormal: boolean; // FileAttribute normal is set
    FAOffLine: boolean; // FileAttribute Offline is set
    FAReadOnly: boolean; // FileAttribute Readonly is set
    FASystem: boolean; // FileAttribute System is set
    FATempporary: boolean; // FileAttribute Temp is set
  end;

  // Function pointers for Events
  TRARFileProgress = procedure(Sender: TObject; FilesProcessed, FileCount: Cardinal) of object;
  TRARDataProgress = procedure(Sender: TObject; SizeProcessed, SizeCount: Int64) of object;
  TRAROverrideEvent = procedure(Sender: TObject; FileName: string; var CanOverride: boolean) of object;
  TRarErrorEvent = procedure(Sender: TObject; Message: string; MessageID: integer) of object;
  TRarStatusEvent = procedure(Sender: TObject; Message: string; status: TRarStatus) of object;
  TRarHeaderEvent = procedure(Sender: TObject; hdrData: TDFRARHeaderData; status: Integer) of object;
  TRarCommentEvent = procedure(Sender: TObject; Comment: string) of object;
  TRarChangeVolEvent = procedure(Sender: TObject; ArcName: PChar; Mode: integer) of object;
  TRarPromptPassEvent = procedure(Sender: TObject; var Password: string) of object;

  TDFUnRar = class(TComponent)
  private
    // Helper Data
//    frmPass: TForm; // Form-Variable for Password-Dialog
//    frmVol: TForm; // Form-Variable for Volumn-Dialog
    Comment: PChar; // Temporary place for the archive comment
    CommentResult: Cardinal; // Result for Loading the archive comment
    ArchiveHandle: Cardinal; // After opening y have to use this for accessing
    RAROpenMode: Cardinal; // OpenMode for Archive RAR_TEST or RAR_EXTRACT
    IsLoaded: boolean; // Is UnRar.dll loaded
    openArchiveStruc: TRAROpenArchiveData; // Data structure for opening a archive
    //MYC:2006/08/17    //hdrData: TRARHeaderData;            // Data for File-Headers - original
    hdrData: TRARHeaderDataEx; // Data for File-Headers - original
    hdrDFData: TDFRARHeaderData; // Data for File-Headers - translated
    // for properties
    FArchivComment: string; // Comments for archive
    FCanProgress: boolean; // Use Progress - takes another UnRar-Operation for calculating file count and file size
    FCommentSize: Cardinal; // size of comments
    FDirectory: string; // Target directory for extracting
    FDllVersion: integer; // Version of Unrar.dll
    FFileCount: Cardinal; // Files in Archive - only used if property CanProgress is true
    FFileList: TStringList; // List of files to extract (full PathName required)
    FFileName: string; // Archive-FileName
    FFilesProcessed: Cardinal; // Files processed form archiv (not working if y use a filelist)
    FMode: TDFRarMode; // Opening mode (DFRAR_EXTRACT or DFRAR_LIST)
    FOverrideEvent: TOverrideOptions; // what to do if file exists
    FPassword: string; // Password
    //FPromptForPass: boolean; // using Eventhandler for Password
    //FPromptForVolumn: boolean; // should prompt for volumn or use Event FOnVolChange
    FSizeCount: Int64; // Size of all files in archiv
    FSizeProcessed: Int64; // processed file size (not working if y use a filelist)
    FStopProcessing: boolean; // Flag for stop unrar
    FOnComment: TRarCommentEvent; // Eventhandler for Archiv Comment
    FOnError: TRarErrorEvent; // Eventhandler for Errors
    FOnFileProcessing: TRarHeaderEvent; // Eventhandler for processing one file
    FOnOverride: TRAROverrideEvent; // Eventhandler if FOverrideEvent is OR_EVENT
    FOnPassword: TRarPromptPassEvent; // Eventhandler for password
    FOnFileProgress: TRARFileProgress;
    FOnDataProgress: TRARDataProgress; // EventHandler for Progress
    FOnRarStatus: TRarStatusEvent; // Eventhandler for status messages
    FOnVolChange: TRarChangeVolEvent; // Eventhandler if new Volumn needed (if UnRar.dll cant find it automaticly)
    procedure ConvertHeader;
    function DoUnRarCallBack(msg: Cardinal; UserData, P1, P2: longint): integer; stdcall;
    procedure DoError(Message: string; MessageID: Integer);
    procedure DoStatus(Message: string; status: TRarStatus);
    procedure InitRAROpenArchiveStruct;
    procedure OpenRARArchive;
    procedure CloseRARArchive;
    procedure SetRARPassword;
    procedure ProcessFileHeader(ReadFileHeaderResult: integer);
    function ProcessFile(hArcData: THandle; Operation: Integer; DestPath, DestName: PChar): Integer;
    procedure SetMode(value: TDFRarMode);
    //procedure ShowPasswordDialog(var Passwd: string);
    //function ShowPromptDialog(OldVolName: string; NewVolName: PChar): boolean;
    //procedure btnPassDlgClick(Sender: TObject);
    //procedure btnVolDlgClick(Sender: TObject);
    procedure CalcProgress;
  protected
  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // extract or list archive content
    procedure Extract;
    // returns false if any erros occours
    function Test: boolean;
  published
    property ArchivComment: string read FArchivComment;
    property CanProgress: boolean read FCanProgress write FCanProgress;
    property CommentSize: Cardinal read FCommentSize;
    property Directory: string read FDirectory write FDirectory;
    property DllVersion: integer read FDllVersion;
    property FileList: TStringList read FFileList write FFileList;
    property FileName: string read FFileName write FFileName;
    property Mode: TDFRarMode read FMode write SetMode default DFRAR_LIST;
    property OverrideEvent: TOverrideOptions read FOverrideEvent write FOverrideEvent;
    property Password: string read FPassword write FPassword;
    //property PromptForPass: boolean read FPromptForPass write FPromptForPass;
    //property PromptForVolumn: boolean read FPromptForVolumn write FPromptForVolumn;
    property StopProcessing: boolean read FStopProcessing write FStopProcessing;
    property OnComment: TRarCommentEvent read FOnComment write FOnComment;
    property OnError: TRarErrorEvent read FOnError write FOnError;
    property OnFileProcessing: TRarHeaderEvent read FOnFileProcessing write FOnFileProcessing;
    property OnOverride: TRAROverrideEvent read FOnOverride write FOnOverride;
    property OnPassword: TRarPromptPassEvent read FOnPassword write FOnPassword;
    property OnFileProgress: TRARFileProgress read FOnFileProgress write FOnFileProgress;
    property OnDataProgress: TRARDataProgress read FOnDataProgress write FOnDataProgress;
    property OnRarStatus: TRarStatusEvent read FOnRarStatus write FOnRarStatus;
    property OnVolChange: TRarChangeVolEvent read FOnVolChange write FOnVolChange;
  end;

procedure Register;

implementation

var
  MySelf: Pointer;

procedure Register;
begin
  RegisterComponents('DFrisch', [TDFUnRar]);
end;

function UnRarCallBack(msg: Cardinal; UserData, P1, P2: longint): integer; stdcall;
begin
  Result := TDFUnRar(MySelf).DoUnRarCallBack(msg, UserData, P1, P2);
end;

procedure TDFUnRar.CloseRARArchive;
begin
  if RARCloseArchive(ArchiveHandle) = ERAR_ECLOSE then
    DoError(MSG1, ERAR_ECLOSE);
  DoStatus('', RAR_AFTERCLOSE);
end;

procedure TDFUnRar.ConvertHeader;
var
  ft: _FILETIME;
  st: TSystemTime;
begin
  with hdrDFData do begin
    ArchiveName := StrPas(hdrData.ArcName);
    //MYC:2006/08/17 //    FileName            := StrPas(hdrData.FileName);
    FileName := WideCharToString(hdrData.FileNameW);
    FlagContinuePrevVol := (hdrData.Flags and $00000001) = $00000001;
    FlagContinueNextVol := (hdrData.Flags and $00000002) = $00000002;
    FlagNeedPassword := (hdrData.Flags and $00000004) = $00000004;
    IsDirectory := (hdrData.Flags and $00000070) = $00000070;
    DictionarySize := ((hdrData.Flags and $00000070) shr 4) * 64 * 1024;
    PackSize := hdrData.PackSize;
    UnpSize := hdrData.UnpSize;
    FileCRC := Format('%x', [hdrData.FileCRC]);

    case hdrData.HostOS of
      0: HostOS := 'DOS';
      1: HostOS := 'IBM OS/2';
      2: HostOS := 'Windows';
      3: HostOS := 'Unix';
    end;

    // Konverting MSDOS-Date to TDateTime-Format
    DosDateTimeToFileTime(HiWord(hdrData.FileTime),
      LoWord(hdrData.FileTime),
      ft);
    FileTimeToSystemTime(ft, st);
    FileTime := SystemTimeToDateTime(st);

    // Version = MajorVersion * 10 + MonirVersion
    MinorVersionNeeded := hdrData.UnpVer mod 10;
    MajorVersionNeeded := (hdrData.UnpVer - MinorVersionNeeded) div 10;

    // Checking for Compress-Method - NOT IN UNRAR.DLL - Description so be carefully
    case hdrData.Method of
      48: Method := COMPRESSMETHODSTORE;
      49: Method := COMPRESSMETHODFASTEST;
      50: Method := COMPRESSMETHODFAST;
      51: Method := COMPRESSMETHODNORMAL;
      52: Method := COMPRESSMETHODGOOD;
      53: Method := COMPRESSMETHODBEST;
    end;

    // Checking File Attributes
    FAArchive := (hdrData.FileAttr and FILE_ATTRIBUTE_ARCHIVE) > 0;
    FACompressed := (hdrData.FileAttr and FILE_ATTRIBUTE_COMPRESSED) > 0;
    FADirectory := (hdrData.FileAttr and FILE_ATTRIBUTE_DIRECTORY) > 0;
    FAHidden := (hdrData.FileAttr and FILE_ATTRIBUTE_HIDDEN) > 0;
    FANormal := (hdrData.FileAttr and FILE_ATTRIBUTE_NORMAL) > 0;
    FAOffLine := (hdrData.FileAttr and FILE_ATTRIBUTE_OFFLINE) > 0;
    FAReadOnly := (hdrData.FileAttr and FILE_ATTRIBUTE_READONLY) > 0;
    FASystem := (hdrData.FileAttr and FILE_ATTRIBUTE_SYSTEM) > 0;
    FATempporary := (hdrData.FileAttr and FILE_ATTRIBUTE_TEMPORARY) > 0;
  end;
end;

constructor TDFUnRar.Create(AOwner: TComponent);
begin
  inherited;
  //LoadRarLibrary;
  //IsLoaded := IsRarLoaded;
  IsLoaded := True;

  if IsLoaded then
    FDllVersion := RARGetDllversion;

  FFileList := TStringList.Create;
end;

destructor TDFUnRar.Destroy;
begin
  //if IsLoaded then
    //UnLoadRarLibrary;

  FFileList.Free;
  inherited;
end;

procedure TDFUnRar.DoError(Message: string; MessageID: Integer);
begin
  if assigned(FOnError) then
    FOnError(self, Message, MessageID);
end;

procedure TDFUnRar.DoStatus(Message: string; status: TRarStatus);
begin
  if assigned(FOnRarStatus) then
    FOnRarStatus(self, Message, status);
end;

function TDFUnRar.DoUnRarCallBack(msg: Cardinal; UserData, P1, P2: Integer): integer;
var
  UnRarRef: TDFUnRar;
  FileName: string;
  //  Size: Integer;
  Passwd: string;
begin
  Result := 0;
  UnRarRef := TDFUnRar(MySelf);
  case msg of
    UCM_CHANGEVOLUME: begin
        FileName := StrPas(Pointer(P1));
        case P2 of
          RAR_VOL_ASK: begin
              // >= 0 => Weiter, -1 => Stop
              Result := 0;
              if assigned(FOnVolChange) then
                FOnVolChange(self, Pointer(P1), RAR_VOL_ASK);
              {else if FPromptForVolumn then begin
                if ShowPromptDialog(StrPas(hdrData.ArcName), Pointer(P1)) then begin
                  if StrPas(hdrData.ArcName) = StrPas(Pointer(P1)) then
                    Result := -1
                  else
                    Result := 0
                end
                else
                  Result := -1;
              end; }
              if StrPas(Pointer(P1)) = '' then
                Result := -1;
            end;
          RAR_VOL_NOTIFY: begin
              //                                            if assigned(FOnVolChange) then
              //                                              FOnVolChange(self, nil, RAR_VOL_NOTIFY);
                                                         // >= 0 => Weiter, -1 => Stop
              Result := 0;
            end;
        end;
      end;
    UCM_NEEDPASSWORD: begin
        Passwd := Password;
        if assigned(FOnPassword) then
          FOnPassword(self, Passwd)
        {else if FPromptForPass then begin
          ShowPasswordDialog(Passwd);
        end}
        else
          DoError(MSG2, 0);

        StrPCopy(Pointer(P1), Copy(Passwd, 1, P2));
        DoStatus(MSG3 + Password, RAR_ONPASSWORD);
      end;
    UCM_PROCESSDATA: begin
        // >= 0 => Weiter, -1 => Stop
        // never used - use OnFileProcessing instead
        // Size := P2;
        FSizeProcessed := FSizeProcessed + P2;
        if assigned(FOnDataProgress) then
          FOnDataProgress(self, FSizeProcessed, FSizeCount);
        if UnRarRef.StopProcessing then
          Result := -1
        else
          Result := 0;
      end;
  end;

  if UnRarRef.StopProcessing then
    Result := -1;
end;

procedure TDFUnRar.Extract;
var
  ReadFileHeaderResult: integer;
  ReadFileResult: Integer;
begin
  StopProcessing := false;

  if not IsLoaded then begin
    DoError(MSG4, 0);
    exit;
  end;

  FFilesProcessed := 0;
  FSizeProcessed := 0;
  if FCanProgress then
    CalcProgress;

  MySelf := self;

  InitRAROpenArchiveStruct;
  if FStopProcessing then
    exit;

  OpenRARArchive;
  try
    if FStopProcessing then
      exit;

    RARSetCallback(ArchiveHandle, UnRarCallBack, 0);

    SetRARPassword;

    ReadFileResult := RAR_SUCCESS;
    repeat
      //MYC:2006/08/17      //ReadFileHeaderResult := RARReadHeader(ArchiveHandle, @hdrData);
      ReadFileHeaderResult := RARReadHeaderEx(ArchiveHandle, @hdrData);
      if ReadFileHeaderResult = ERAR_END_ARCHIVE then
        break;

      ProcessFileHeader(ReadFileHeaderResult);
      if FStopProcessing then
        exit;

      if ReadFileHeaderResult = RAR_SUCCESS then
        ReadFileResult := ProcessFile(ArchiveHandle, RAROpenMode, PChar(Directory), nil);

      case ReadFileResult of
        ERAR_BAD_DATA: DoError(MSG5, ERAR_BAD_DATA);
        ERAR_BAD_ARCHIVE: DoError(MSG6, ERAR_BAD_ARCHIVE);
        ERAR_UNKNOWN_FORMAT: DoError(MSG7, ERAR_UNKNOWN_FORMAT);
        ERAR_EOPEN: DoError(MSG8, ERAR_EOPEN);
        ERAR_ECREATE: DoError(MSG9, ERAR_ECREATE);
        ERAR_ECLOSE: DoError(MSG10, ERAR_ECLOSE);
        ERAR_EREAD: DoError(MSG11, ERAR_EREAD);
        ERAR_EWRITE: DoError(MSG12, ERAR_EWRITE);
      end;

      if StopProcessing then
        exit;
      // alternativ y can try to unpack the next file and check only for ERAR_END_ARCHIVE
    until (ReadFileResult <> RAR_SUCCESS);
  finally
    CloseRARArchive;
  end;
  if assigned(FOnDataProgress) then
    FOnDataProgress(self, 1, 1);
end;

// Init Open

procedure TDFUnRar.InitRAROpenArchiveStruct;
begin
  CommentResult := 0;

  with openArchiveStruc do begin
    OpenResult := 0; // Init with RAR_SUCCESS

    // Testing is the same like listing
    if (FMode = DFRAR_LIST) then
      OpenMode := RAR_OM_LIST
    else
      OpenMode := RAR_OM_EXTRACT;

    ArcName := PChar(FileName);
    GetMem(Comment, MAXRARCOMMENTSIZE); // Max
    CmtBuf := Comment;
    CmtBufSize := MAXRARCOMMENTSIZE;
    CmtSize := FCommentSize;
    CmtState := CommentResult;
  end;
end;

procedure TDFUnRar.OpenRARArchive;
begin
  DoStatus('', RAR_ONBEFOREOPEN);
  ArchiveHandle := RAROpenArchive(@openArchiveStruc);
  DoStatus('', RAR_ONOPEN);

  case openArchiveStruc.CmtState of
    ERAR_COMMENTS_EXISTS: begin
        FArchivComment := StrPas(Comment);
        FCommentSize := Length(FArchivComment);
        if assigned(FOnComment) then
          FOnComment(self, Comment);
      end; // not from UnRar-Dll !
    ERAR_NO_COMMENTS: begin
        FArchivComment := '';
        FCommentSize := 0;
      end; // not from UnRar-Dll !
    ERAR_NO_MEMORY: DoError(MSG14, ERAR_NO_MEMORY);
    ERAR_BAD_DATA: DoError(MSG5, ERAR_BAD_DATA);
    ERAR_UNKNOWN_FORMAT: DoError(MSG7, ERAR_UNKNOWN_FORMAT);
    ERAR_SMALL_BUF: DoError(MSG16, ERAR_SMALL_BUF);
  end;
end;

procedure TDFUnRar.SetRARPassword;
begin
  if FPassword <> '' then
    RARSetPassword(ArchiveHandle, PChar(FPassword));
end;

procedure TDFUnRar.SetMode(value: TDFRarMode);
begin
  FMode := value;

  if Mode = DFRAR_LIST then
    RAROpenMode := RAR_TEST
  else
    RAROpenMode := RAR_EXTRACT;
end;

procedure TDFUnRar.ProcessFileHeader(ReadFileHeaderResult: integer);
begin
  if ReadFileHeaderResult = ERAR_BAD_DATA then
    DoError(MSG17, ERAR_BAD_DATA)
  else begin
    if assigned(FOnFileProcessing) or assigned(FOnFileProgress) then begin
      ConvertHeader;

      if assigned(FOnFileProcessing) then
        FOnFileProcessing(self, hdrDFData, ReadFileHeaderResult);
      if assigned(FOnFileProgress) then begin
        Inc(FFilesProcessed);
        FOnFileProgress(self, FFilesProcessed, FFileCount);
      end;
    end;
  end;
end;

function TDFUnRar.ProcessFile(hArcData: THandle; Operation: Integer; DestPath, DestName: PChar): Integer;
var
  FileName: string;
  IsDirectory: boolean;
  CanOverride: boolean;
begin
  Result := 0;
  if FOverrideEvent = OR_ALWAYS then
    Result := RARProcessFile(hArcData, Operation, DestPath, DestName)
  else begin
    IsDirectory := (hdrData.Flags and $00000070) = $00000070;
    //MYC:2006/08/17    //FileName := DestPath + '\' + StrPas(hdrData.FileName);
    FileName := DestPath + '\' + WideCharToString(hdrData.FileNameW);

    if FFileList.Count > 0 then
      if FFileList.IndexOf(FileName) = -1 then begin
        Result := RARProcessFile(hArcData, RAR_SKIP, DestPath, DestName);
        exit;
      end;

    if not IsDirectory then begin
      if FileExists(FileName) and (Operation = RAR_EXTRACT) then begin
        case FOverrideEvent of
          OR_NEVER: Result := RARProcessFile(hArcData, RAR_SKIP, DestPath, DestName);
          OR_EVENT: begin
              CanOverride := false;
              if assigned(FOnOverride) then
                FOnOverride(self, FileName, CanOverride);
              if CanOverride then
                Result := RARProcessFile(hArcData, Operation, DestPath, DestName)
              else
                Result := RARProcessFile(hArcData, RAR_SKIP, DestPath, DestName);
            end;
        end;
      end
      else
        Result := RARProcessFile(hArcData, Operation, DestPath, DestName);
    end
    else
      Result := RARProcessFile(hArcData, Operation, DestPath, DestName);
  end;
end;
 {
procedure TDFUnRar.ShowPasswordDialog(var Passwd: string);
var
  btnOk: TButton;
  btnCancel: TButton;
  edtPass: TEdit;
begin
  frmPass := TForm.Create(nil);
  try
    with frmPass do begin
      Left := 192;
      Top := 107;
      BorderStyle := bsDialog;
      Caption := PASSDLGCAPTION;
      ClientHeight := 69;
      ClientWidth := 168;
      Color := clBtnFace;
      Position := poScreenCenter;
    end;

    edtPass := TEdit.Create(frmPass);
    with edtPass do begin
      Parent := frmPass;
      Left := 8;
      Top := 8;
      Width := 153;
      Height := 21;
      MaxLength := 120;
      PasswordChar := '*';
      TabOrder := 0;
    end;

    btnOk := TButton.Create(frmPass);
    with btnOk do begin
      Parent := frmPass;
      Left := 7;
      Top := 37;
      Width := 75;
      Height := 25;
      Caption := OKCAPTION;
      TabOrder := 1;
      Default := true;
      OnClick := btnPassDlgClick;
    end;

    btnCancel := TButton.Create(frmPass);
    with btnCancel do begin
      Parent := frmPass;
      Left := 87;
      Top := 37;
      Width := 75;
      Height := 25;
      Caption := CANCELCAPTION;
      TabOrder := 2;
      OnClick := btnPassDlgClick;
    end;

    frmPass.ShowModal;
    PassWd := edtPass.Text;
  finally
    frmPass.Release;
  end;
end;

procedure TDFUnRar.btnPassDlgClick(Sender: TObject);
begin
  if (Sender as TButton).Name = 'btnOk' then
    frmPass.ModalResult := mrOk
  else
    frmPass.ModalResult := mrCancel;
end;               }

procedure TDFUnRar.CalcProgress;
var
  ReadFileHeaderResult: integer;
  ReadFileResult: Integer;
begin
  if not IsLoaded then begin
    DoError(MSG4, 0);
    exit;
  end;

  FFileCount := 0;
  FSizeCount := 0;
  CommentResult := 0;

  with openArchiveStruc do begin
    OpenResult := 0; // Init with RAR_SUCCESS
    OpenMode := RAR_TEST;
    ArcName := PChar(FileName);
    GetMem(Comment, MAXRARCOMMENTSIZE); // Max
    CmtBuf := Comment;
    CmtBufSize := MAXRARCOMMENTSIZE;
    CmtSize := FCommentSize;
    CmtState := CommentResult;
  end;

  if FStopProcessing then
    exit;

  OpenRARArchive;
  try
    if FStopProcessing then
      exit;

    RARSetCallback(ArchiveHandle, UnRarCallBack, 0);
    SetRARPassword;

    ReadFileResult := RAR_SUCCESS;
    repeat
      //MYC:2006/08/17      //ReadFileHeaderResult := RARReadHeader(ArchiveHandle, @hdrData);
      ReadFileHeaderResult := RARReadHeaderEx(ArchiveHandle, @hdrData);
      if ReadFileHeaderResult = ERAR_END_ARCHIVE then
        break;

      if FStopProcessing then
        exit;

      if ReadFileHeaderResult = RAR_SUCCESS then begin
        ReadFileResult := RARProcessFile(ArchiveHandle, RAR_SKIP, PChar(Directory), nil);
        if ReadFileResult = RAR_SUCCESS then begin
          if not ((hdrData.Flags and $00000001) = $00000001) then begin
            Inc(FFileCount);
            FSizeCount := FSizeCount + hdrData.UnpSize;
          end;
        end;
      end;

      if StopProcessing then
        exit;
    until (ReadFileResult <> RAR_SUCCESS);
  finally
    CloseRARArchive;
  end;
end;

function TDFUnRar.Test: boolean;
var
  ReadFileHeaderResult: integer;
  ReadFileResult: Integer;
begin
  Result := false;

  if not IsLoaded then begin
    DoError(MSG4, 0);
    exit;
  end;

  CommentResult := 0;

  with openArchiveStruc do begin
    OpenResult := 0; // Init with RAR_SUCCESS
    OpenMode := RAR_TEST;
    ArcName := PChar(FileName);
    GetMem(Comment, MAXRARCOMMENTSIZE); // Max
    CmtBuf := Comment;
    CmtBufSize := MAXRARCOMMENTSIZE;
    CmtSize := FCommentSize;
    CmtState := CommentResult;
  end;

  if FStopProcessing then
    exit;

  OpenRARArchive;
  try
    if FStopProcessing then
      exit;

    RARSetCallback(ArchiveHandle, UnRarCallBack, 0);
    SetRARPassword;

    ReadFileResult := RAR_SUCCESS;
    repeat
      //MYC:2006/08/17      //ReadFileHeaderResult := RARReadHeader(ArchiveHandle, @hdrData);
      ReadFileHeaderResult := RARReadHeaderEx(ArchiveHandle, @hdrData);
      if ReadFileHeaderResult = ERAR_END_ARCHIVE then
        break;

      if FStopProcessing then
        exit;

      if ReadFileHeaderResult = RAR_SUCCESS then
        ReadFileResult := ProcessFile(ArchiveHandle, RAR_OM_LIST, PChar(Directory), nil);

      if StopProcessing then
        exit;
    until (ReadFileResult <> RAR_SUCCESS);
  finally
    CloseRARArchive;
  end;
end;
  {
function TDFUnRar.ShowPromptDialog(OldVolName: string; NewVolName: PChar): boolean;
var
  btnOk: TButton;
  btnCancel: TButton;
  edtVol: TEdit;
begin
  frmVol := TForm.Create(nil);
  try
    with frmVol do begin
      Left := 192;
      Top := 107;
      BorderStyle := bsDialog;
      Caption := VOLDLGCAPTION;
      ClientHeight := 69;
      ClientWidth := 168;
      Color := clBtnFace;
      Position := poScreenCenter;
    end;

    edtVol := TEdit.Create(frmVol);
    with edtVol do begin
      Parent := frmVol;
      Left := 8;
      Top := 8;
      Width := 153;
      Height := 21;
      MaxLength := 120;
      PasswordChar := #0;
      TabOrder := 0;
      Text := OldVolName;
    end;

    btnOk := TButton.Create(frmVol);
    with btnOk do begin
      Parent := frmVol;
      Left := 7;
      Top := 37;
      Width := 75;
      Height := 25;
      Caption := OKCAPTION;
      TabOrder := 1;
      Default := true;
      OnClick := btnVolDlgClick;
    end;

    btnCancel := TButton.Create(frmVol);
    with btnCancel do begin
      Parent := frmVol;
      Left := 87;
      Top := 37;
      Width := 75;
      Height := 25;
      Caption := CANCELCAPTION;
      TabOrder := 2;
      OnClick := btnVolDlgClick;
    end;

    Result := frmVol.ShowModal = mrOk;
    StrPCopy(NewVolName, edtVol.Text);
  finally
    frmVol.Release;
  end;
end;

procedure TDFUnRar.btnVolDlgClick(Sender: TObject);
begin
  if (Sender as TButton).Name = 'btnOk' then
    frmVol.ModalResult := mrOk
  else
    frmVol.ModalResult := mrCancel;
end;      }

end.

