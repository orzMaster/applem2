program SelGate;

uses
  Forms,
  Main in 'Main.pas' {FrmMain},
  GateShare in 'GateShare.pas',
  GeneralConfig in 'GeneralConfig.pas' {frmGeneralConfig},
  IPaddrFilter in 'IPaddrFilter.pas' {frmIPaddrFilter},
  HUtil32 in '..\Common\HUtil32.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  Common in '..\Common\Common.pas',
  EDcode in '..\Common\EDcode.pas',
  GateCommon in '..\Common\GateCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SelGate';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TfrmGeneralConfig, frmGeneralConfig);
  Application.CreateForm(TfrmIPaddrFilter, frmIPaddrFilter);
  Application.Run;
end.

