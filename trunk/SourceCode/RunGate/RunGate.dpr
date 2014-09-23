program RunGate;

uses
  Forms,
  Main in 'Main.pas' {FrmMain},
  GateShare in 'GateShare.pas',
  GeneralConfig in 'GeneralConfig.pas' {frmGeneralConfig},
  IPaddrFilter in 'IPaddrFilter.pas' {frmIPaddrFilter},
  Grobal2 in '..\Common\Grobal2.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  PrefConfig in 'PrefConfig.pas' {frmPrefConfig},
  OnLineHum in 'OnLineHum.pas' {FrmOnLineHum},
  Common in '..\Common\Common.pas',
  EDcode in '..\Common\EDcode.pas',
  SessionInfo in 'SessionInfo.pas',
  GateCommon in '..\Common\GateCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.HintHidePause := 10000;
  Application.HintPause := 100;
  Application.Title := 'RunGate';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TfrmGeneralConfig, frmGeneralConfig);
  Application.CreateForm(TfrmIPaddrFilter, frmIPaddrFilter);
  Application.CreateForm(TfrmPrefConfig, frmPrefConfig);
  Application.CreateForm(TFrmOnLineHum, FrmOnLineHum);
  Application.Run;
end.

