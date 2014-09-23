unit FrmAD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, WebBrowserWithUI, ExtCtrls, Buttons, StdCtrls;

type
  TFormAD = class(TForm)
    Panel1: TPanel;
    ButtonClose: TSpeedButton;
    Panel2: TPanel;
    wb: TWebBrowserWithUI;
    wb2: TWebBrowserWithUI;
    procedure wbDocumentComplete(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    procedure wbDownloadBegin(Sender: TObject);
    procedure wbNavigateComplete2(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    procedure ButtonCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure wbNewWindow2(ASender: TObject; var ppDisp: IDispatch; var Cancel: WordBool);
    procedure wb2BeforeNavigate2(ASender: TObject; const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
      var Cancel: WordBool);
  private
    { Private declarations }
  public
    procedure Open(nWidth, nHeight: Integer; sUrl: string);
  end;

var
  FormAD: TFormAD;

implementation


uses
  ShellAPI;

{$R *.dfm}

procedure TFormAD.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAD.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFormAD.FormDestroy(Sender: TObject);
begin
  FormAD := nil;
end;

procedure TFormAD.Open(nWidth, nHeight: Integer; sUrl: string);
var
  R: TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @R, 0);
  Left := Screen.Width - nWidth;
  Top := Screen.Height - nHeight - (Screen.Height - R.Bottom);
  Width := nWidth;
  Height := nHeight;
  wb.Navigate(sUrl);
  Show;
end;

procedure TFormAD.wb2BeforeNavigate2(ASender: TObject; const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
  var Cancel: WordBool);
begin
  ShellExecute(Handle, 'Open', PChar(string(Url)), '', '', SW_SHOW);
  Close;
end;

procedure TFormAD.wbDocumentComplete(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
begin
  if wb.Application = pDisp then begin

  end;
end;

procedure TFormAD.wbDownloadBegin(Sender: TObject);
begin
  wb.Silent := True;
end;

procedure TFormAD.wbNavigateComplete2(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
begin
  wb.Silent := True;
end;

procedure TFormAD.wbNewWindow2(ASender: TObject; var ppDisp: IDispatch; var Cancel: WordBool);
begin
  Cancel:= False;
  ppDIsp := wb2.Application;
end;

end.

