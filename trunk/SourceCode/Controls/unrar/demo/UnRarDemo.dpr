program UnRarDemo;

uses
  Forms,
  untUnRarDemo in 'untUnRarDemo.pas' {frmMain},
  untUnRar in '..\src\untUnRar.pas',
  untStatus in 'untStatus.pas' {frmStatus},
  untOverWritePrompt in 'untOverWritePrompt.pas' {frmOverWrite},
  untDFFileLib in 'untDFFileLib.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
