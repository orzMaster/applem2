program LogDataServer;

uses
  Forms,
  LogDataMain in 'LogDataMain.pas' {FormMain},
  LogShare in 'LogShare.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  FrmViewLog in 'FrmViewLog.pas' {FormView};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'LogDataServer';
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
