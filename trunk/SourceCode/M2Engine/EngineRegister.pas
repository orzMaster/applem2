unit EngineRegister;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, svMain, IniFiles, RzButton, Mask, RzEdit;

type
  TFrmRegister = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditUserName: TRzEdit;
    EditRegisterName: TRzEdit;
    EditRegisterCode: TRzEdit;
    RzBitBtnRegister: TRzBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Open();
  end;

var
  FrmRegister: TFrmRegister;

implementation
uses M2Share, SDK;
{$R *.dfm}

procedure TFrmRegister.Open();
begin

end;

end.
