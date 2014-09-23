unit EditCompoundInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TEditCompoundInfoForm = class(TForm)
    Label1: TLabel;
    eLowValue: TEdit;
    Label2: TLabel;
    eHighValue: TEdit;
    Label3: TLabel;
    eRate: TEdit;
    BtnOK: TButton;
    BtnCancel: TButton;
    procedure BtnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FLowValue: Integer;
    FHighValue: Integer;
    FRate: Integer;
  public
    property LowValue: Integer read FLowValue write FLowValue;
    property HighValue: Integer read FHighValue write FHighValue;
    property Rate: Integer read FRate write FRate;
  end;

var
  EditCompoundInfoForm: TEditCompoundInfoForm;

implementation

{$R *.dfm}

procedure TEditCompoundInfoForm.BtnOKClick(Sender: TObject);
begin
  FLowValue := StrToIntDef(eLowValue.Text, 0);
  FHighValue := StrToIntDef(eHighValue.Text, 0);
  FRate := StrToIntDef(eRate.Text, 0);
end;

procedure TEditCompoundInfoForm.FormShow(Sender: TObject);
begin
  eLowValue.Text := IntToStr(FLowValue);
  eHighValue.Text := IntToStr(FHighValue);
  eRate.Text := IntToStr(FRate);
end;

end.
