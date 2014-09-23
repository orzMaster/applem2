unit untStatus;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmStatus = class(TForm)
    mmStatus: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmStatus: TfrmStatus;

implementation

{$R *.DFM}

procedure TfrmStatus.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
