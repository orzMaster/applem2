unit FWeb;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, ExtCtrls, WebBrowserWithUI;

type
  TFrmWeb = class(TForm)
    wb: TWebBrowserWithUI;
    pnl1: TPanel;
    procedure wbNavigateComplete2(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    procedure wbDocumentComplete(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    procedure FormHide(Sender: TObject);
    procedure wbTitleChange(ASender: TObject; const Text: WideString);
    procedure wbProgressChange(ASender: TObject; Progress, ProgressMax: Integer);
    procedure wbDownloadBegin(Sender: TObject);
  private
    { Private declarations }
    FTitle: string;
    FMainOK: Boolean;
  public
    m_sTitle: string;
    procedure ShowWeb(sUrl: string);
  end;

var
  FrmWeb: TFrmWeb;
  sXML7: string = 'G';
  sXML2: string = 'XML';

implementation
uses
  ActiveX;

{$R *.dfm}

procedure TFrmWeb.FormHide(Sender: TObject);
begin
  wb.Stop;
end;

procedure TFrmWeb.ShowWeb(sUrl: string);
begin
  m_sTitle := 'Loading page, please wait ...... 0%';
  FTitle := 'Untitled';
  FMainOK := False;
  pnl1.Visible := True;
  if sUrl <> '' then begin
    Show;
    wb.Navigate(sUrl);
  end;
end;

procedure TFrmWeb.wbDocumentComplete(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
begin
  if not FMainOK then begin
    if wb.Application = pDisp then begin
      m_sTitle := FTitle;
      FMainOK := True;
      pnl1.Visible := False;
    end;
  end
  else begin
    m_sTitle := FTitle;
  end;
end;

procedure TFrmWeb.wbDownloadBegin(Sender: TObject);
begin
  wb.Silent := True;
end;

procedure TFrmWeb.wbNavigateComplete2(ASender: TObject; const pDisp: IDispatch; var URL: OleVariant);
begin
  wb.Silent := True;
end;

procedure TFrmWeb.wbProgressChange(ASender: TObject; Progress, ProgressMax: Integer);
begin
  if ProgressMax <= 0 then exit;
  if (Progress <> -1) and (Progress < ProgressMax) then
    m_sTitle := 'Loading page, please wait ...... ' + IntToStr(Round(Progress / ProgressMax * 100)) + '%';
end;

procedure TFrmWeb.wbTitleChange(ASender: TObject; const Text: WideString);
begin
  FTitle := Text;
end;

initialization
  OleInitialize(nil);

finalization
  try
    OleUninitialize;
  except
  end;

end.

