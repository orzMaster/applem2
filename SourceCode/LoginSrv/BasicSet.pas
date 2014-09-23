unit BasicSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Spin;

type
  TFrmBasicSet = class(TForm)
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    ButtonSave: TButton;
    ButtonClose: TButton;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    EditGateAddr: TEdit;
    EditGatePort: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    EditMonAddr: TEdit;
    EditMonPort: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    EditServerAddr: TEdit;
    EditServerPort: TEdit;
    GroupBox8: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    EditSQLAddr: TEdit;
    EditSQLPort: TEdit;
    ButtonRestoreNet: TButton;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    CheckBoxDisabledCreateID: TCheckBox;
    CheckBoxDisabledChangePassword: TCheckBox;
    CheckBoxDisabledLostPassword: TCheckBox;
    procedure CheckBoxTestServerClick(Sender: TObject);
    procedure CheckBoxEnableMakingIDClick(Sender: TObject);
    procedure CheckBoxEnableGetbackPasswordClick(Sender: TObject);
    procedure CheckBoxAutoClearClick(Sender: TObject);
    procedure SpinEditAutoClearTimeChange(Sender: TObject);
    procedure CheckBoxAutoUnLockAccountClick(Sender: TObject);
    procedure SpinEditUnLockAccountTimeChange(Sender: TObject);
    procedure ButtonRestoreBasicClick(Sender: TObject);
    procedure EditGateAddrChange(Sender: TObject);
    procedure EditGatePortChange(Sender: TObject);
    procedure EditMonAddrChange(Sender: TObject);
    procedure EditMonPortChange(Sender: TObject);
    procedure EditServerAddrChange(Sender: TObject);
    procedure EditServerPortChange(Sender: TObject);
    procedure CheckBoxDynamicIPModeClick(Sender: TObject);
    procedure ButtonRestoreNetClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure EditSQLAddrChange(Sender: TObject);
    procedure EditSQLPortChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBoxDisabledCreateIDClick(Sender: TObject);
    procedure CheckBoxDisabledChangePasswordClick(Sender: TObject);
    procedure CheckBoxDisabledLostPasswordClick(Sender: TObject);
  private
    
    procedure LockSaveButtonEnabled();
    procedure UnLockSaveButtonEnabled();
  public
    
    procedure OpenBasicSet();
  end;

var
  FrmBasicSet: TFrmBasicSet;

implementation
uses HUtil32, LSShare;
var
  Config: pTConfig;
{$R *.dfm}

procedure TFrmBasicSet.LockSaveButtonEnabled();
begin
  ButtonSave.Enabled := False;
end;

procedure TFrmBasicSet.UnLockSaveButtonEnabled();
begin
  ButtonSave.Enabled := true;
end;

procedure TFrmBasicSet.OpenBasicSet();
begin
  Config := @g_Config;
  //CheckBoxTestServer.Checked := Config.boTestServer;
  //CheckBoxEnableMakingID.Checked := Config.boEnableMakingID;
  //CheckBoxEnableGetbackPassword.Checked := Config.boEnableGetbackPassword;
  //CheckBoxAutoClear.Checked := Config.boAutoClearID;
  //SpinEditAutoClearTime.Value := Config.dwAutoClearTime;

  //CheckBoxAutoUnLockAccount.Checked := Config.boUnLockAccount;
  //SpinEditUnLockAccountTime.Value := Config.dwUnLockAccountTime;

  EditGateAddr.Text := Config.sGateAddr;
  EditGatePort.Text := IntToStr(Config.nGatePort);

  EditServerAddr.Text := Config.sServerAddr;
  EditServerPort.Text := IntToStr(Config.nServerPort);

  EditMonAddr.Text := Config.sMonAddr;
  EditMonPort.Text := IntToStr(Config.nMonPort);

  EditSQLAddr.Text := Config.sSqlAddr;
  EditSqlPort.Text := IntToStr(Config.nSqlPort);

  CheckBoxDisabledCreateID.Checked := Config.boDisabledCreateAccount;
  CheckBoxDisabledChangePassword.Checked := Config.boDisabledChangePassword;
  CheckBoxDisabledLostPassword.Checked := Config.boDisabledLostPassword;

  //CheckBoxDynamicIPMode.Checked := Config.boDynamicIPMode;
  LockSaveButtonEnabled();
  ShowModal;
end;

procedure TFrmBasicSet.CheckBoxTestServerClick(Sender: TObject);
begin
  {Config := @g_Config;
  Config.boTestServer := CheckBoxTestServer.Checked;
  UnLockSaveButtonEnabled(); }
end;

procedure TFrmBasicSet.CheckBoxEnableMakingIDClick(Sender: TObject);
begin
  {Config := @g_Config;
  Config.boEnableMakingID := CheckBoxEnableMakingID.Checked;
  UnLockSaveButtonEnabled();  }
end;

procedure TFrmBasicSet.CheckBoxEnableGetbackPasswordClick(Sender: TObject);
begin
  {Config := @g_Config;
  Config.boEnableGetbackPassword := CheckBoxEnableGetbackPassword.Checked;
  UnLockSaveButtonEnabled();  }
end;

procedure TFrmBasicSet.CheckBoxAutoClearClick(Sender: TObject);
begin
 { Config := @g_Config;
  Config.boAutoClearID := CheckBoxAutoClear.Checked;
  UnLockSaveButtonEnabled();  }
end;

procedure TFrmBasicSet.SpinEditAutoClearTimeChange(Sender: TObject);
begin
  {Config := @g_Config;
  Config.dwAutoClearTime := SpinEditAutoClearTime.Value;
  UnLockSaveButtonEnabled();  }
end;

procedure TFrmBasicSet.CheckBoxAutoUnLockAccountClick(Sender: TObject);
begin
  {Config := @g_Config;
  Config.boUnLockAccount := CheckBoxAutoUnLockAccount.Checked;
  UnLockSaveButtonEnabled();   }
end;

procedure TFrmBasicSet.CheckBoxDisabledChangePasswordClick(Sender: TObject);
begin
  Config := @g_Config;
  Config.boDisabledChangePassword := CheckBoxDisabledChangePassword.Checked;
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.CheckBoxDisabledLostPasswordClick(Sender: TObject);
begin
  Config := @g_Config;
  Config.boDisabledLostPassword := CheckBoxDisabledLostPassword.Checked;
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.SpinEditUnLockAccountTimeChange(Sender: TObject);
begin
  {Config := @g_Config;
  Config.dwUnLockAccountTime := SpinEditUnLockAccountTime.Value;
  UnLockSaveButtonEnabled(); }
end;

procedure TFrmBasicSet.ButtonRestoreBasicClick(Sender: TObject);
begin
  Config := @g_Config;
  //CheckBoxTestServer.Checked := true;
  //CheckBoxEnableMakingID.Checked := true;
  //CheckBoxEnableGetbackPassword.Checked := true;
  //CheckBoxAutoClear.Checked := true;
  //SpinEditAutoClearTime.Value := 1;
  //CheckBoxAutoUnLockAccount.Checked := False;
  //SpinEditUnLockAccountTime.Value := 10;
  //CheckBoxDynamicIPMode.Checked := False;
end;

procedure TFrmBasicSet.EditGateAddrChange(Sender: TObject);
begin
  Config := @g_Config;
  Config.sGateAddr := Trim(EditGateAddr.Text);
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.EditGatePortChange(Sender: TObject);
begin
  Config := @g_Config;
  Config.nGatePort := StrToIntDef(Trim(EditGatePort.Text), 5500);
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.EditMonAddrChange(Sender: TObject);
begin
  Config := @g_Config;
  Config.sMonAddr := Trim(EditMonAddr.Text);
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.EditMonPortChange(Sender: TObject);
begin
  Config := @g_Config;
  Config.nMonPort := StrToIntDef(Trim(EditMonPort.Text), 3000);
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.EditServerAddrChange(Sender: TObject);
begin
  Config := @g_Config;
  Config.sServerAddr := Trim(EditServerAddr.Text);
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.EditServerPortChange(Sender: TObject);
begin
  Config := @g_Config;
  Config.nServerPort := StrToIntDef(Trim(EditServerPort.Text), 5600);
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.EditSQLAddrChange(Sender: TObject);
begin
  Config := @g_Config;
  Config.sSQLAddr := Trim(EditSQLAddr.Text);
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.EditSQLPortChange(Sender: TObject);
begin
  Config := @g_Config;
  Config.nSQLPort := StrToIntDef(Trim(EditSQLPort.Text), 8888);
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.FormCreate(Sender: TObject);
begin
{$IF RUNVAR = VAR_DB}
  GroupBox8.Visible := False;
  PageControl1.TabIndex := 0;
{$IFEND}
end;

procedure TFrmBasicSet.CheckBoxDisabledCreateIDClick(Sender: TObject);
begin
  Config := @g_Config;
  Config.boDisabledCreateAccount := CheckBoxDisabledCreateID.Checked;
  UnLockSaveButtonEnabled();
end;

procedure TFrmBasicSet.CheckBoxDynamicIPModeClick(Sender: TObject);
begin
 { Config := @g_Config;
  Config.boDynamicIPMode := CheckBoxDynamicIPMode.Checked;
  UnLockSaveButtonEnabled();   }
end;

procedure TFrmBasicSet.ButtonRestoreNetClick(Sender: TObject);
begin
  EditGateAddr.Text := '0.0.0.0';
  EditGatePort.Text := '5500';
  EditServerAddr.Text := '0.0.0.0';
  EditServerPort.Text := '5600';
  EditMonAddr.Text := '0.0.0.0';
  EditMonPort.Text := '3000';
  EditSQLAddr.Text := '127.0.0.1';
  EditSQLPort.Text := '8888';
end;

procedure WriteConfig(Config: pTConfig);
  procedure WriteConfigString(sSection, sIdent, sDefault: string);
  begin
    Config.IniConf.WriteString(sSection, sIdent, sDefault);
  end;
  procedure WriteConfigInteger(sSection, sIdent: string; nDefault: Integer);
  begin
    Config.IniConf.WriteInteger(sSection, sIdent, nDefault);
  end;
  procedure WriteConfigBoolean(sSection, sIdent: string; boDefault: Boolean);
  begin
    Config.IniConf.WriteBool(sSection, sIdent, boDefault);
  end;
begin
  WriteConfigString(sSectionServer, sIdentServerAddr, Config.sServerAddr);
  WriteConfigInteger(sSectionServer, sIdentServerPort, Config.nServerPort);
  WriteConfigString(sSectionServer, sIdentGateAddr, Config.sGateAddr);
  WriteConfigInteger(sSectionServer, sIdentGatePort, Config.nGatePort);
  WriteConfigString(sSectionServer, sIdentMonAddr, Config.sMonAddr);
  WriteConfigInteger(sSectionServer, sIdentMonPort, Config.nMonPort);
  WriteConfigString(sSectionServer, sIdentSqlAddr, Config.sSQLAddr);
  WriteConfigInteger(sSectionServer, sIdentSqlPort, Config.nSQLPort);
  //WriteConfigString(sSectionServer, sIdentIdDir, Config.sIdDir);
  WriteConfigString(sSectionServer, sIdentCountLogDir, Config.sChrLogDir);
  Config.IniConf.WriteBool(sSectionServer, 'DisabledCreateAccount', Config.boDisabledCreateAccount);
  Config.IniConf.WriteBool(sSectionServer, 'DisabledChangePassword', Config.boDisabledChangePassword);
  Config.IniConf.WriteBool(sSectionServer, 'DisabledLostPassword', Config.boDisabledLostPassword);
end;

procedure TFrmBasicSet.ButtonSaveClick(Sender: TObject);
begin
  WriteConfig(Config);
  LockSaveButtonEnabled();
end;

procedure TFrmBasicSet.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

end.
