unit PlugInManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SDK;
type
  TftmPlugInManage = class(TForm)

    ListBoxPlugin: TListBox;
    ButtonInit: TButton;
    ButtonUnInit: TButton;
    Button2: TButton;
    ButtonConfig: TButton;
    procedure ListBoxPluginClick(Sender: TObject);
    procedure ListBoxPluginDblClick(Sender: TObject);
    procedure ButtonUnInitClick(Sender: TObject);
    procedure ButtonConfigClick(Sender: TObject);
    procedure ButtonInitClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure RefPlugin();
    { Private declarations }
  public
    procedure Open();
    { Public declarations }

  end;

var
  ftmPlugInManage: TftmPlugInManage;

implementation


uses M2Share, {$IFDEF PLUGOPEN}PlugOfEngine,{$ENDIF} svMain;

var
  ConfigProc: TStartProc = nil;
  //UnModule: TUnModule = nil;
  {$IFDEF PLUGOPEN}
  PlugInfo: pTPlugInfo = nil;
  {$ENDIF}

{$R *.dfm}

procedure TftmPlugInManage.Open;
begin
  ConfigProc := nil;
  //UnModule := nil;
  {$IFDEF PLUGOPEN}
  PlugInfo := nil;
  {$ENDIF}
  ButtonConfig.Enabled := False;
  RefPlugin();
  Self.ShowModal;
end;

procedure TftmPlugInManage.RefPlugin;
var
  i: Integer;
begin
  ConfigProc := nil;
  //UnModule := nil;
  {$IFDEF PLUGOPEN}
  PlugInfo := nil;
  {$ENDIF}
  ListBoxPlugin.Clear;
  ButtonUnInit.Enabled := False;
  ButtonConfig.Enabled := False;
  {$IFDEF PLUGOPEN}
  for i := 0 to PlugInEngine.PlugList.Count - 1 do begin
    ListBoxPlugin.Items.AddObject(PlugInEngine.PlugList.Strings[i],
      PlugInEngine.PlugList.Objects[i]);
  end;
  {$ENDIF}
end;

procedure TftmPlugInManage.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TftmPlugInManage.ButtonConfigClick(Sender: TObject);
begin
  if Assigned(ConfigProc) then
    TStartProc(ConfigProc);
end;

procedure TftmPlugInManage.ButtonInitClick(Sender: TObject);
begin
  {$IFDEF PLUGOPEN}
  with FrmMain.OpenDialog do begin
    Filter := '游戏插件(DLL)|zPlugOf*.dll|标准动态链接库(DLL)|*.dll|所有文件|*.*';
    Execute(Handle);
    SetCurrentDir(g_Config.sCurrentDir);
    if FileName <> '' then begin
      PlugInEngine.LoadPlugIn(Filename);
      RefPlugin();
      FileName := '';
    end;
  end;
  {$ENDIF}
end;

procedure TftmPlugInManage.ButtonUnInitClick(Sender: TObject);
{$IFDEF PLUGOPEN}
var
  i: Integer;
{$ENDIF}
begin
  {$IFDEF PLUGOPEN}
  if (PlugInfo <> nil) and Assigned(PlugInfo.UnModule) then begin
    if Application.MessageBox(PChar(Format('是否确定卸载插件[%s]？',
      [PlugInfo.sDesc])), '提示信息', MB_OKCANCEL + MB_ICONQUESTION) = IDOK then begin
      PlugInEngine.UnLoadPlugIn(PlugInfo, False);
      for i := 0 to PlugInEngine.PlugList.Count - 1 do begin
        if pTPlugInfo(PlugInEngine.PlugList.Objects[i]) = PlugInfo then begin
          Dispose(PlugInfo);
          PlugInEngine.PlugList.Delete(i);
          Break;
        end;
      end;
      RefPlugin();
    end;
  end;
  {$ENDIF}
end;

procedure TftmPlugInManage.ListBoxPluginClick(Sender: TObject);
begin
  {$IFDEF PLUGOPEN}
  try
    ConfigProc := nil;
    //UnModule := nil;
    PlugInfo := pTPlugInfo(ListBoxPlugin.Items.Objects[ListBoxPlugin.ItemIndex]);
    ConfigProc := GetProcAddress(PlugInfo.Module, 'Config');
    if Assigned(ConfigProc) then
      ButtonConfig.Enabled := True
    else
      ButtonConfig.Enabled := False;
    if Assigned(PlugInfo.UnModule) then
      ButtonUnInit.Enabled := True
    else
      ButtonUnInit.Enabled := False;
  except
    ButtonConfig.Enabled := False;
    ConfigProc := nil;
  end;
  {$ENDIF}
end;

procedure TftmPlugInManage.ListBoxPluginDblClick(Sender: TObject);
begin
  if Assigned(ConfigProc) then
    TStartProc(ConfigProc);
end;


end.
