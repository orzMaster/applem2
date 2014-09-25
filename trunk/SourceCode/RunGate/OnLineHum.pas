unit OnLineHum;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  StdCtrls, ComCtrls, Main, ExtCtrls;

type
  TFrmOnLineHum = class(TForm)
    GroupBox1: TGroupBox;
    ButtonRef: TButton;
    ButtonKick: TButton;
    ButtonAddTempList: TButton;
    ButtonAddBlockList: TButton;
    ListViewOnLine: TListView;
    Timer1: TTimer;
    CheckBoxShowLogin: TCheckBox;
    procedure Timer1Timer(Sender: TObject);
    procedure ButtonRefClick(Sender: TObject);
    procedure ListViewOnLineClick(Sender: TObject);
    procedure ButtonKickClick(Sender: TObject);
    procedure ButtonAddTempListClick(Sender: TObject);
    procedure ButtonAddBlockListClick(Sender: TObject);
  private
    { Private declarations }
    procedure RefOnlineHum();
    //    procedure RefReceiveLength();
  public
    { Public declarations }
    procedure Open();
  end;

var
  FrmOnLineHum: TFrmOnLineHum;
  sSelIPaddr: string;
implementation
uses GateShare, SessionInfo;
{$R *.dfm}

function GetReceiveLength(SocketHandle: Integer): Integer;
var
  i: Integer;
  UserSession: pTSessionInfo;
begin
  Result := 0;
  for i := 0 to RUNATEMAXSESSION - 1 do begin
    UserSession := @SessionArray[i];
    if UserSession.Socket <> nil then begin
      if UserSession.nSckHandle = SocketHandle then begin
        Result := UserSession.nReceiveLength;
        break;
      end;
    end;
  end;
end;

procedure TFrmOnLineHum.RefOnlineHum();
var
  i: integer;
  GlobaSessionInfo: pTCenterSessionInfo;
  ListItem: TListItem;
  sSize: string;
begin
  ListViewOnLine.Clear;
  GlobaSessionList.Lock;
  try
    for I := 0 to GlobaSessionList.Count - 1 do begin
      GlobaSessionInfo := GlobaSessionList.Items[i];
      if GlobaSessionInfo.boStartPlay or not CheckBoxShowLogin.Checked then begin
        ListItem := ListViewOnLine.Items.Add;
        ListItem.Caption := IntToStr(I);
        ListItem.SubItems.Add(GlobaSessionInfo.sIPaddr);
        ListItem.SubItems.Add(GlobaSessionInfo.sAccount);
        ListItem.SubItems.Add(IntToStr(GlobaSessionInfo.nSessionID));
        sSize := '';
        if (GlobaSessionInfo.nSockIndex >= 0) and (GlobaSessionInfo.nSockIndex < RUNATEMAXSESSION) then begin
          sSize := IntToStr(SessionArray[GlobaSessionInfo.nSockIndex].dwSpeedTick);
        end;  
        ListItem.SubItems.Add(sSize);
        if GlobaSessionInfo.boStartPlay then
          ListItem.SubItems.Add('Has Logged [' + GlobaSessionInfo.sUserName + ']')
        else
        if GlobaSessionInfo.sUserName <> '' then
          ListItem.SubItems.Add('Has Logged [' + IntToStr(GlobaSessionInfo.wGatePort) + '][' + GlobaSessionInfo.sUserName + ']')
        else
          ListItem.SubItems.Add('Not Logged In');
      end;
    end;
  finally
    GlobaSessionList.UnLock;
  end;
  Caption := 'Global Session [' + IntToStr(ListViewOnLine.Items.Count) + ']';
end;

procedure TFrmOnLineHum.Open();
begin
  RefOnlineHum();
  ButtonAddTempList.Enabled := False;
  ButtonAddBlockList.Enabled := False;
  ButtonKick.Enabled := False;
  ShowModal;
end;

procedure TFrmOnLineHum.Timer1Timer(Sender: TObject);
begin
  RefOnlineHum();
end;

procedure TFrmOnLineHum.ButtonRefClick(Sender: TObject);
begin
  RefOnlineHum();
end;

procedure TFrmOnLineHum.ListViewOnLineClick(Sender: TObject);
var
  ListItem: TListItem;
begin
  if ListViewOnLine.ItemIndex > -1 then begin
    ListItem := ListViewOnLine.Selected;
    sSelIPaddr := ListItem.SubItems.Strings[0];
    ButtonKick.Enabled := True;
    ButtonAddTempList.Enabled := True;
    ButtonAddBlockList.Enabled := True;
  end
  else begin
    sSelIPaddr := '';
    ButtonKick.Enabled := False;
    ButtonAddTempList.Enabled := False;
    ButtonAddBlockList.Enabled := False;
  end;
end;

procedure TFrmOnLineHum.ButtonKickClick(Sender: TObject);
begin
  if Application.MessageBox(PChar('Are you sure to disconnect this connection?'),
    PChar('Confirmation - ' + sSelIPaddr), MB_OKCANCEL + MB_ICONQUESTION) <> IDOK
      then
    Exit;

  ButtonKick.Enabled := False;
  FrmMain.CloseConnect(sSelIPaddr);
  RefOnlineHum();
  ButtonKick.Enabled := True;
end;

procedure TFrmOnLineHum.ButtonAddTempListClick(Sender: TObject);
begin
  if
    Application.MessageBox(PChar('Are you sure this IP add dynamic filter list? After adding filter list, all connections to this IP will be forcibly interrupted established.'),
    PChar('Confirmation - ' + sSelIPaddr),
    MB_OKCANCEL + MB_ICONQUESTION
    ) <> IDOK then
    Exit;
  FrmMain.AddTempBlockIP(sSelIPaddr);
end;

procedure TFrmOnLineHum.ButtonAddBlockListClick(Sender: TObject);
begin
  if
    Application.MessageBox(PChar('Are you sure this IP add permanent filter list? After adding filter list, all connections to this IP will be forcibly interrupted established.'),
    PChar('Confirmation - ' + sSelIPaddr),
    MB_OKCANCEL + MB_ICONQUESTION
    ) <> IDOK then
    Exit;
  FrmMain.AddBlockIP(sSelIPaddr);
end;

end.


