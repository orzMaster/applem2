unit Unit9;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, DES, 
  Dialogs, StdCtrls;

type
  TForm9 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form9: TForm9;

implementation

{$R *.dfm}

procedure TForm9.Button1Click(Sender: TObject);
var
  str: array[0..8] of Char;
  I: Integer;
  k: Integer;
begin
  for I := 0 to 255 do begin
    for k := 0 to 8 do
      str[k] := Char(I);
    Memo1.Lines.Add(EncryStrHex(str, '12345678'));
  end;

end;

end.
