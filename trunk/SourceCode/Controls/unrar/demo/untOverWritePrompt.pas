unit untOverWritePrompt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmOverWrite = class(TForm)
    Label1: TLabel;
    lblFileName: TLabel;
    Label3: TLabel;
    btnYes: TButton;
    btnNo: TButton;
    btnAlways: TButton;
    btnNever: TButton;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmOverWrite: TfrmOverWrite;

implementation

{$R *.DFM}

end.
