unit OnlineEmail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmOnlineEmail = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditTitle: TEdit;
    Label2: TLabel;
    MemoText: TMemo;
    GroupBox2: TGroupBox;
    RButtonT: TRadioButton;
    RButtonAll: TRadioButton;
    MemoName: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure RButtonTClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open();
  end;

var
  frmOnlineEmail: TfrmOnlineEmail;

implementation

uses UsrEngn, M2Share, Grobal2, FrnEmail, Hutil32;

{$R *.dfm}

{ TfrmOnlineEmail }
{
procedure TfrmOnlineEmail.Button1Click(Sender: TObject);
var
  I: Integer;
  EMailInfo: pTEMailInfo;
  sName, sText, sTitle: string;
begin
  if (Trim(EditTitle.Text) <> '') and (MemoText.Lines.Text <> '') then begin
    sText := MemoText.Lines.Text;
    sTitle := Trim(EditTitle.Text);
    if RButtonAll.Checked then begin
      New(EMailInfo);
      SafeFillChar(EMailInfo^, SizeOf(TEMailInfo), #0);
      EMailInfo.boDelete := False;
      EMailInfo.Header.boRead := False;
      EMailInfo.Header.boSystem := True;
      EMailInfo.Header.sTitle := sTitle;
      EMailInfo.Header.sSendName := SYSEMAILNAME;
      EMailInfo.Header.CreateTime := Now;
      EMailInfo.sReadName := sName;
      EMailInfo.nGold := 0;
      EMailInfo.TextLen := _MIN(Length(sText), MAXEMAILTEXTLEN);
      Move(sText[1], EMailInfo.Text[0], EMailInfo.TextLen);
      UserEMail.SendMsg(EMS_ADDALLEMAIL, -1, 0, 0, 0, '', EMailInfo);
    end else
    if MemoName.Lines.Count > 0 then begin
      for I := 0 to MemoName.Lines.Count - 1 do begin
        sName := Trim(MemoName.Lines[I]);
        if sName <> '' then begin
          New(EMailInfo);
          SafeFillChar(EMailInfo^, SizeOf(TEMailInfo), #0);
          EMailInfo.boDelete := False;
          EMailInfo.Header.boRead := False;
          EMailInfo.Header.boSystem := True;
          EMailInfo.Header.sTitle := sTitle;
          EMailInfo.Header.sSendName := SYSEMAILNAME;
          EMailInfo.Header.CreateTime := Now;
          EMailInfo.sReadName := sName;
          EMailInfo.nGold := 0;
          EMailInfo.TextLen := _MIN(Length(sText), MAXEMAILTEXTLEN);
          Move(sText[1], EMailInfo.Text[0], EMailInfo.TextLen);
          UserEMail.SendMsg(EMS_ADDEMAIL, -1, 0, 0, 0, '', EMailInfo);
        end;
      end;
    end;
  end;
  Application.MessageBox('发送完成！', '提示信息', MB_OK + MB_ICONINFORMATION);
end;
}

procedure TfrmOnlineEmail.Button1Click(Sender: TObject);
var
  I: Integer;
  sName, sText, sTitle: string;
begin
  if (Trim(EditTitle.Text) <> '') and (MemoText.Lines.Text <> '') then begin
    sText := MemoText.Lines.Text;
    sTitle := Trim(EditTitle.Text);
    if RButtonAll.Checked then begin
      UserEMail.SendMail('', sText, sTitle, True);
    end else
    if MemoName.Lines.Count > 0 then begin
      for I := 0 to MemoName.Lines.Count - 1 do begin
        sName := Trim(MemoName.Lines[I]);
        if sName <> '' then
          UserEMail.SendMail(sName, sText, sTitle, False);
      end;
    end;
  end;
  Application.MessageBox('发送完成！', '提示信息', MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmOnlineEmail.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmOnlineEmail.Open;
begin
  ShowModal;
end;

procedure TfrmOnlineEmail.RButtonTClick(Sender: TObject);
begin
  MemoName.Enabled := RButtonT.Checked;
end;

end.
