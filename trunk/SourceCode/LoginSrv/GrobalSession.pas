unit GrobalSession;

interface

uses
  SysUtils, Classes, Controls, Forms,
  Grids, ExtCtrls, StdCtrls;

type
  TfrmGrobalSession = class(TForm)
    ButtonRefGrid: TButton;
    PanelStatus: TPanel;
    GridSession: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    procedure RefGridSession();
    
  public
    procedure Open();
    
  end;

var
  frmGrobalSession: TfrmGrobalSession;

implementation

uses LSShare, LMain, HUtil32;

{$R *.dfm}


procedure TfrmGrobalSession.FormCreate(Sender: TObject);
begin
  GridSession.Cells[0, 0] := '序号';
  GridSession.Cells[1, 0] := '登录帐号';
  GridSession.Cells[2, 0] := '登录地址';
  GridSession.Cells[3, 0] := '服务器名';
  GridSession.Cells[4, 0] := '会话ID';
  GridSession.Cells[5, 0] := '数据库ID';
end;

procedure TfrmGrobalSession.Open;
begin
  RefGridSession();
  Self.ShowModal;
end;

procedure TfrmGrobalSession.RefGridSession;
var
  I: Integer;
  ConnInfo: pTConnInfo;
  Config: pTConfig;
begin
  Config := @g_Config;
  PanelStatus.Caption := '正在取得数据...';
  GridSession.Visible := False;
  GridSession.Cells[0, 1] := '';
  GridSession.Cells[1, 1] := '';
  GridSession.Cells[2, 1] := '';
  GridSession.Cells[3, 1] := '';
  GridSession.Cells[4, 1] := '';
  GridSession.Cells[5, 1] := '';
  Config.SessionList.Lock;
  try
    if Config.SessionList.Count <= 0 then begin
      GridSession.RowCount := 2;
      GridSession.FixedRows := 1;
    end
    else begin
      GridSession.RowCount := Config.SessionList.Count + 1;
    end;
    for I := 0 to Config.SessionList.Count - 1 do begin
      ConnInfo := Config.SessionList.Items[I];
      GridSession.Cells[0, I + 1] := IntToStr(I);
      GridSession.Cells[1, I + 1] := ConnInfo.sAccount;
      GridSession.Cells[2, I + 1] := ConnInfo.sIPaddr;
      GridSession.Cells[3, I + 1] := ConnInfo.sServerName;
      GridSession.Cells[4, I + 1] := IntToStr(ConnInfo.nSessionID);
      GridSession.Cells[5, I + 1] := IntToStr(ConnInfo.nUserCDKey);
    end;
  finally
    Config.SessionList.UnLock;
  end;
  GridSession.Visible := true;
end;

end.
