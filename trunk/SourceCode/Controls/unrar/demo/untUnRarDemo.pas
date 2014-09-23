unit untUnRarDemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DFUnRar, ComCtrls, ExtCtrls, Menus, ToolWin, ImgList,
  ActnList, AppEvnts, untOverWritePrompt, untDFFileLib, untStatus;

type
  TfrmMain = class(TForm)
    dfUnRar: TDFUnRar;
    opndlgMain: TOpenDialog;
    lstvwMain: TListView;
    prgbrUnRar: TProgressBar;
    mnuMain: TMainMenu;
    miFile: TMenuItem;
    miFileOpen: TMenuItem;
    miFileClose: TMenuItem;
    miSep1: TMenuItem;
    miFileExit: TMenuItem;
    miOperations: TMenuItem;
    miOperationsUnRar: TMenuItem;
    miOperationsArchiveInfo: TMenuItem;
    miSep3: TMenuItem;
    miOperationsDllInfo: TMenuItem;
    miOperationsStatus: TMenuItem;
    tlbrMain: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    ToolButton6: TToolButton;
    stbrMain: TStatusBar;
    acListMain: TActionList;
    imglstMain: TImageList;
    acFileOpen: TAction;
    acFileClose: TAction;
    acClose: TAction;
    acExtract: TAction;
    acArchiveInfo: TAction;
    acDllInfo: TAction;
    appevtMain: TApplicationEvents;
    acStatusInfo: TAction;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton3: TToolButton;
    acStop: TAction;
    procedure dfUnRarFileProcessing(Sender: TObject;
      hdrData: TDFRARHeaderData; status: Integer);
    procedure lstvwMainCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lstvwMainColumnClick(Sender: TObject; Column: TListColumn);
    procedure dfUnRarError(Sender: TObject; Message: String;
      MessageID: Integer);
    procedure dfUnRarRarStatus(Sender: TObject; Message: String;
      status: TRarStatus);
    procedure FormCreate(Sender: TObject);
    procedure dfUnRarComment(Sender: TObject; Comment: String);
    procedure dfUnRarOverride(Sender: TObject; FileName: String;
      var OverRide: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure acFileOpenExecute(Sender: TObject);
    procedure acDllInfoExecute(Sender: TObject);
    procedure acCloseExecute(Sender: TObject);
    procedure appevtMainIdle(Sender: TObject; var Done: Boolean);
    procedure acFileCloseExecute(Sender: TObject);
    procedure acArchiveInfoExecute(Sender: TObject);
    procedure acStatusInfoExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acExtractExecute(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure acStopExecute(Sender: TObject);
    procedure dfUnRarFileProgress(Sender: TObject; FilesProcessed, FileCount: Cardinal);
    procedure dfUnRarDataProgress(Sender: TObject; SizeProcessed, SizeCount: Int64);
  private
    IsExtracting: boolean;
    FComment: string;
    FPacked: Integer;
    FFilesCount: integer; // Counts Files in Archive
    FFileSizeCount: Integer; // Counts Filessizes in Archive
    IsRarLoaded: boolean;
    SLStatus: TStringList;
  public
  end;

var
  frmMain: TfrmMain;
  ColumnToSort: Integer;
  p1,p2: Int64;

implementation

uses untunrar;
{$R *.DFM}

procedure TfrmMain.dfUnRarFileProcessing(Sender: TObject;
  hdrData: TDFRARHeaderData; status: Integer);
var
  li: TListItem;
  Fattr: string;
begin
  {if not IsExtracting then
  begin   }
    FFilesCount := FFilesCount + 1;
    FFileSizeCount := FFileSizeCount + hdrData.UnpSize;
    FPacked := FPacked + hdrData.PackSize;

    //if dfUnRar.FileList.Count < 3 then
      //dfUnRar.FileList.Add(dfUnRar.Directory + '\' + hdrData.FileName);

    li := lstvwMain.Items.Add;
    li.Caption := ExtractFileName(hdrData.FileName);
    li.SubItems.Add(ExtractFilePath(hdrData.FileName));
    li.SubItems.Add(IntToStr(hdrData.UnpSize));
    li.SubItems.Add(IntToStr(hdrData.PackSize));

    if hdrData.FlagNeedPassword then
      li.SubItems.Add('*')
    else
      li.SubItems.Add('');
    if hdrData.IsDirectory then
      li.SubItems.Add('*')
    else
      li.SubItems.Add('');
    if hdrData.FlagContinuePrevVol then
      li.SubItems.Add('*')
    else
      li.SubItems.Add('');
    if hdrData.FlagContinueNextVol then
      li.SubItems.Add('*')
    else
      li.SubItems.Add('');

    li.SubItems.Add(hdrData.HostOS);
    li.SubItems.Add(hdrData.FileCRC);
    li.SubItems.Add(IntToStr(hdrData.DictionarySize));
    li.SubItems.Add(DateTimeToStr(hdrData.FileTime));
    li.SubItems.Add(IntToStr(hdrData.MajorVersionNeeded));
    li.SubItems.Add(IntToStr(hdrData.MinorVersionNeeded));
    li.SubItems.Add(hdrData.Method);

    if hdrData.FAArchive    then FAttr := FAttr + 'A';
    if hdrData.FACompressed then FAttr := FAttr + 'C';
    if hdrData.FADirectory  then FAttr := FAttr + 'D';
    if hdrData.FAHidden     then FAttr := FAttr + 'H';
    if hdrData.FANormal     then FAttr := FAttr + 'N';
    if hdrData.FAOffLine    then FAttr := FAttr + 'O';
    if hdrData.FAReadOnly   then FAttr := FAttr + 'R';
    if hdrData.FASystem     then FAttr := FAttr + 'S';
    if hdrData.FATempporary then FAttr := FAttr + 'T';

    li.SubItems.Add(FAttr);
  //end;
  
  Application.ProcessMessages;
end;

procedure TfrmMain.dfUnRarFileProgress(Sender: TObject; FilesProcessed, FileCount: Cardinal);
begin
  //if {(FFilesCount > 0) and }(IsExtracting) then begin
    //prgbrUnRar.Position := FilesProcessed{ * 100 div FFilesCount};
    self.Caption := Format('%d - %d', [FilesProcessed, FileCount]);
  //end;
end;

procedure TfrmMain.lstvwMainCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  ix: Integer;
begin
  if ColumnToSort = 0 then
    Compare := CompareText(Item1.Caption,Item2.Caption)
  else begin
   ix := ColumnToSort - 1;
   Compare := CompareText(Item1.SubItems[ix],Item2.SubItems[ix]);
  end;
end;

procedure TfrmMain.lstvwMainColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  ColumnToSort := Column.Index;
  (Sender as TCustomListView).AlphaSort;
end;

procedure TfrmMain.dfUnRarError(Sender: TObject; Message: String;
  MessageID: Integer);
begin
  SLStatus.Add('Fehler: ' + Message);
end;

procedure TfrmMain.dfUnRarRarStatus(Sender: TObject; Message: String;
  status: TRarStatus);
var
  msg2: string;
begin
  case status of
    RAR_ONOPEN         : msg2 := 'Archiv geöffnet';
    RAR_ONBEFOREOPEN   : msg2 := 'Archiv wird geöffnet';
    RAR_AFTERCLOSE     : msg2 := 'Nach Schließen';
    RAR_ONPASSWORD     : msg2 := 'Passwortabfrage';
  end;

  SLStatus.Add(Message + ': ' + msg2);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  IsRarLoaded  := false;
  IsExtracting := false;
  SLStatus     := TStringList.Create;
  p1 := 0;
  p2 := 0;
end;

procedure TfrmMain.dfUnRarComment(Sender: TObject; Comment: String);
begin
  FComment := Comment;
end;

procedure TfrmMain.dfUnRarDataProgress(Sender: TObject; SizeProcessed, SizeCount: Int64);
begin
  prgbrUnRar.Position := Round(SizeProcessed / SizeCount * 100);
end;

procedure TfrmMain.dfUnRarOverride(Sender: TObject; FileName: String;
  var OverRide: Boolean);
begin
  frmOverWrite := TfrmOverWrite.Create(nil);
  try
    frmOverWrite.lblFileName.Caption := FileName;
    case frmOverWrite.ShowModal of
      mrYes      : OverRide := true;
      mrYesToAll : dfUnRar.OverrideEvent := OR_ALWAYS;
      mrNo       : OverRide := false;
      mrNoToAll  : dfUnRar.OverrideEvent := OR_NEVER;
    end;
  finally
    frmOverWrite.Release;
  end;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
//  dfUnRar.StopProcessing := true;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
begin
{  ProgressBar1.Position := 0;
  Memo1.Clear;
  if OpenDialog1.Execute then
  begin
    UnRar.FileName := OpenDialog1.FileName;
    UnRar.Directory := 'C:\Temp';
    UnRar.Mode := DFRAR_LIST;
    UnRar.Extract;
    UnRar.Mode := DFRAR_EXTRACT;
    UnRar.Extract;
  end; }
end;

procedure TfrmMain.Button4Click(Sender: TObject);
begin
{  ProgressBar1.Position := 0;
  Memo1.Clear;
//  if OpenDialog1.Execute then
//  begin
//    ur2.FileName := OpenDialog1.FileName;
//    ur2.FileName := 'F:\Test\courses.part01.rar';
    UnRar2.FileName := 'F:\Test\courses.part01.rar';
//    ur2.Directory := 'F:\';
    UnRar2.Extract;
//  end; }
end;

procedure TfrmMain.Button5Click(Sender: TObject);
begin
{  ProgressBar1.Position := 0;
  Memo1.Clear;
//  if OpenDialog1.Execute then
//  begin
    UnRar2.FileName := 'F:\Demo.rar';
    UnRar2.Directory := 'F:\';
    UnRar2.Extract;
//  end; }
end;

function MyProcessDataProc(Addr: PByte; Size: integer): integer; stdcall;
begin
  frmMain.Caption := IntToStr(Size);
end;

procedure TfrmMain.acFileOpenExecute(Sender: TObject);
begin
  if opndlgMain.Execute then
  begin
    opndlgMain.InitialDir := ExtractFilePath(opndlgMain.FileName);
    p1 := 0;
    p2 := 0;
    FPacked := 0;
    FFilesCount := 0;
    FFileSizeCount := 0;
    lstvwMain.Items.Clear;
    stbrMain.SimpleText := '  ' + opndlgMain.FileName;
    IsRarLoaded := true;
    prgbrUnRar.Position := 0;

    with dfUnRar do
    begin
      IsExtracting := True;
      //RARSetProcessDataProc(ArchiveHandle, MyProcessDataProc);
      FileList.Clear;
      FileName := opndlgMain.FileName;
      //Mode := DFRAR_LIST;
      Mode := DFRAR_EXTRACT;
      //CanProgress := false;
      OverrideEvent := OR_EVENT;
      //StopProcessing := false;
      Directory := '.\temp';
      Extract;
      IsExtracting := False;
    end;
  end;
end;

procedure TfrmMain.acDllInfoExecute(Sender: TObject);
begin
  Application.MessageBox(PChar('Version: ' + IntToStr(dfUnRar.DllVersion)), 'UnRar-Dll-Info', MB_OK or MB_ICONINFORMATION);
end;

procedure TfrmMain.acCloseExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.appevtMainIdle(Sender: TObject; var Done: Boolean);
begin
  acFileClose.Enabled := IsRarLoaded;
  acArchiveInfo.Enabled := IsRarLoaded;
  acExtract.Enabled := IsRarLoaded;
  acStatusInfo.Enabled := IsRarLoaded;
  acStop.Enabled := IsRarLoaded;
end;

procedure TfrmMain.acFileCloseExecute(Sender: TObject);
begin
  dfUnRar.FileName := '';
  stbrMain.SimpleText := '';
  lstvwMain.Items.Clear;
  prgbrUnRar.Position := 0;
  IsRarLoaded := false;
end;

procedure TfrmMain.acArchiveInfoExecute(Sender: TObject);
begin
  Application.MessageBox(
    PChar('Dateien: ' + IntToStr(FFilesCount) + #10#13 +
          'Gepackte Größe: ' + IntToStr(FPacked) + #10#13 +
          'Ungepackte Größe: ' + IntToStr(FFileSizeCount) + #10#13 +
          'Kommentar: ' + FComment),
    'Archiv-Info',
    MB_OK or MB_ICONINFORMATION);
end;

procedure TfrmMain.acStatusInfoExecute(Sender: TObject);
begin
  frmStatus := TfrmStatus.Create(nil);
  try
    frmStatus.mmStatus.Lines.Assign(SLStatus);
    frmStatus.ShowModal;
  finally
    frmStatus.Free;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SLStatus.Free;
end;

procedure TfrmMain.acExtractExecute(Sender: TObject);
var
  FilePos: Integer;
  ExtractDir: string;
begin
  ExtractDir := DFBrowseForFolder(Handle, 'Entpacken nach...', opndlgMain.InitialDir);
  if ExtractDir <> '' then
  begin
    if lstvwMain.SelCount > 0 then
    begin
      dfUnRar.FileList.Clear;
      for FilePos := 0 to lstvwMain.Items.Count - 1 do
        if lstvwMain.Items[FilePos].Selected then
          dfUnRar.FileList.Add(ExtractDir + '\' +
                               lstvwMain.Items[FilePos].SubItems.Strings[0] +
                               lstvwMain.Items[FilePos].Caption);
    end
    else
      dfUnRar.FileList.Clear;

    IsExtracting := true;
    dfUnRar.OverrideEvent := OR_EVENT;
    dfUnRar.Directory := ExtractDir;
    dfUnRar.Mode := DFRAR_EXTRACT;
    dfUnRar.Extract;
    IsExtracting := false;
  end;
end;

procedure TfrmMain.ToolButton9Click(Sender: TObject);
begin
  dfUnRar.StopProcessing := true;
end;

procedure TfrmMain.acStopExecute(Sender: TObject);
begin
  dfUnRar.StopProcessing := true;
end;

end.
