unit FrmVarsion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
  TFormVersion = class(TForm)
    lbl1: TLabel;
    seMajor: TSpinEdit;
    lbl2: TLabel;
    seMinor: TSpinEdit;
    lbl3: TLabel;
    seRelease: TSpinEdit;
    lbl4: TLabel;
    seBuild: TSpinEdit;
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
    procedure seMajorChange(Sender: TObject);
    procedure seMinorChange(Sender: TObject);
    procedure seReleaseChange(Sender: TObject);
    procedure seBuildChange(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open;
  end;

var
  FormVersion: TFormVersion;

implementation

{$R *.dfm}

uses
  LSShare;

procedure TFormVersion.btn1Click(Sender: TObject);
begin
  g_Config.IniConf.WriteInteger(sSectionServer, sMajor, g_Config.wMajor);
  g_Config.IniConf.WriteInteger(sSectionServer, sMinor, g_Config.wMinor);
  g_Config.IniConf.WriteInteger(sSectionServer, sRelease, g_Config.wRelease);
  g_Config.IniConf.WriteInteger(sSectionServer, sBuild, g_Config.wBuild);
  Close;
end;

procedure TFormVersion.Open;
begin
  seMajor.Value := g_Config.wMajor;
  seMinor.Value := g_Config.wMinor;
  seRelease.Value := g_Config.wRelease;
  seBuild.Value := g_Config.wBuild;
  ShowModal;
end;

procedure TFormVersion.seBuildChange(Sender: TObject);
begin
  g_Config.wBuild := seBuild.Value;
end;

procedure TFormVersion.seMajorChange(Sender: TObject);
begin
  g_Config.wMajor := seMajor.Value;
end;

procedure TFormVersion.seMinorChange(Sender: TObject);
begin
  g_Config.wMinor := seMinor.Value;
end;

procedure TFormVersion.seReleaseChange(Sender: TObject);
begin
  g_Config.wRelease := seRelease.Value;
end;

end.
