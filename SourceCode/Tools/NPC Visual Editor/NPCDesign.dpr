program NPCDesign;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  HUtil32 in '..\..\Common\HUtil32.pas',
  WMFile in 'WMFile.pas',
  LShare in '..\..\MirClient\LShare.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
