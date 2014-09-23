program Project9;

uses
  Forms,
  Unit9 in 'Unit9.pas' {Form9},
  Common in 'Common.pas',
  DES in 'DES.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm9, Form9);
  Application.Run;
end.
