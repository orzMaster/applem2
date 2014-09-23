unit DropGroupPas;

interface

uses
  Windows, Messages, SysUtils, Classes, StdCtrls, Controls;

type
  TDropFileGroupBox = class(TGroupBox)
  private
    FDropFileList: TStringList;
    FOnDropFile: TNotifyEvent;
    FActive: Boolean;
    FAutoActive: Boolean;
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure SetActive(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoDropFile;
    property Files: TStringList read FDropFileList;
  protected
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure DestroyWindowHandle; override;
    procedure ChangeActive(boActive: Boolean);
  published
    property OnDropFile: TNotifyEvent read FOnDropFile write FOnDropFile;
    property Active: Boolean read FActive write SetActive;
    property AutoActive: Boolean read FAutoActive write FAutoActive;
  end;

  procedure Register;

implementation

uses ShellAPI;

{ TDropFileGroupBox }

procedure Register;
begin
  RegisterComponents('Standard', [TDropFileGroupBox]);
end;

procedure TDropFileGroupBox.ChangeActive(boActive: Boolean);
begin
  if boActive then begin
    if not FActive then DragAcceptFiles(Handle, True);
    FActive := True;
  end else begin
    if FActive then DragFinish(Handle);
    FActive := False;
  end;
end;

constructor TDropFileGroupBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDropFileList := TStringList.Create;
  FOnDropFile := nil;
  FActive := False;
  FAutoActive := True;
end;

procedure TDropFileGroupBox.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited;
  if FAutoActive then ChangeActive(True);
end;

destructor TDropFileGroupBox.Destroy;
begin
  
  FDropFileList.Free;
  inherited;
end;

procedure TDropFileGroupBox.DestroyWindowHandle;
begin
  ChangeActive(False);
  inherited;
end;

procedure TDropFileGroupBox.DoDropFile;
begin
  if Assigned(FOnDropFile) then FOnDropFile(Self);
end;

procedure TDropFileGroupBox.SetActive(const Value: Boolean);
begin
  ChangeActive(Value);
end;

procedure TDropFileGroupBox.WMDropFiles(var Msg: TWMDropFiles);
var
  AFileName: array[0..MAX_PATH] of Char;
  nFiles, I: Integer;
begin
  nFiles := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0);
  FDropFileList.Clear;
  for I := 0 to nFiles - 1 do begin
    if DragQueryFile(Msg.Drop, I, AFileName, MAX_PATH) > 0 then begin
      FDropFileList.Add(AFileName);
    end;
  end;
  
  if FDropFileList.Count > 0 then DoDropFile;
end;

end.




