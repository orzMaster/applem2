unit GameCommand;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ComCtrls, StdCtrls, Spin, Grobal2;

type
  TfrmGameCmd = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    StringGridGameCmd: TStringGrid;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditUserCmdName: TEdit;
    EditUserCmdPerMission: TSpinEdit;
    Label6: TLabel;
    EditUserCmdOK: TButton;
    LabelUserCmdFunc: TLabel;
    LabelUserCmdParam: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditUserCmdSave: TButton;
    StringGridGameMasterCmd: TStringGrid;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    LabelGameMasterCmdFunc: TLabel;
    LabelGameMasterCmdParam: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    EditGameMasterCmdName: TEdit;
    EditGameMasterCmdPerMission: TSpinEdit;
    EditGameMasterCmdOK: TButton;
    EditGameMasterCmdSave: TButton;
    StringGridGameDebugCmd: TStringGrid;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    LabelGameDebugCmdFunc: TLabel;
    LabelGameDebugCmdParam: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    EditGameDebugCmdName: TEdit;
    EditGameDebugCmdPerMission: TSpinEdit;
    EditGameDebugCmdOK: TButton;
    EditGameDebugCmdSave: TButton;
    procedure FormCreate(Sender: TObject);
    procedure StringGridGameCmdClick(Sender: TObject);
    procedure EditUserCmdNameChange(Sender: TObject);
    procedure EditUserCmdPerMissionChange(Sender: TObject);
    procedure EditUserCmdOKClick(Sender: TObject);
    procedure EditUserCmdSaveClick(Sender: TObject);
    procedure StringGridGameMasterCmdClick(Sender: TObject);
    procedure EditGameMasterCmdNameChange(Sender: TObject);
    procedure EditGameMasterCmdPerMissionChange(Sender: TObject);
    procedure EditGameMasterCmdOKClick(Sender: TObject);
    procedure StringGridGameDebugCmdClick(Sender: TObject);
    procedure EditGameDebugCmdNameChange(Sender: TObject);
    procedure EditGameDebugCmdPerMissionChange(Sender: TObject);
    procedure EditGameDebugCmdOKClick(Sender: TObject);
    procedure EditGameMasterCmdSaveClick(Sender: TObject);
    procedure EditGameDebugCmdSaveClick(Sender: TObject);
  private
    nRefGameUserIndex: Integer;
    nRefGameMasterIndex: Integer;
    nRefGameDebugIndex: Integer;
    procedure RefUserCommand();
    procedure RefGameUserCmd(GameCmd: pTGameCmd; sCmdParam, sDesc: string);

    procedure RefGameMasterCommand();
    procedure RefGameMasterCmd(GameCmd: pTGameCmd; sCmdParam, sDesc: string);

    procedure RefDebugCommand();
    procedure RefGameDebugCmd(GameCmd: pTGameCmd; sCmdParam, sDesc: string);
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmGameCmd: TfrmGameCmd;

implementation

uses M2Share;

{$R *.dfm}

procedure TfrmGameCmd.FormCreate(Sender: TObject);
begin
  PageControl.ActivePageIndex := 0;
  StringGridGameCmd.RowCount := 50;
  StringGridGameCmd.Cells[0, 0] := 'Command';
  StringGridGameCmd.Cells[1, 0] := 'Permission';
  StringGridGameCmd.Cells[2, 0] := 'Command Paramaters';
  StringGridGameCmd.Cells[3, 0] := 'Description';

  StringGridGameMasterCmd.RowCount := 105;
  StringGridGameMasterCmd.Cells[0, 0] := 'Command';
  StringGridGameMasterCmd.Cells[1, 0] := 'Permission';
  StringGridGameMasterCmd.Cells[2, 0] := 'Command Paramaters';
  StringGridGameMasterCmd.Cells[3, 0] := 'Description';

  StringGridGameDebugCmd.RowCount := 41;
  StringGridGameDebugCmd.Cells[0, 0] := 'Command';
  StringGridGameDebugCmd.Cells[1, 0] := 'Permission';
  StringGridGameDebugCmd.Cells[2, 0] := 'Command Paramaters';
  StringGridGameDebugCmd.Cells[3, 0] := 'Description';

end;

procedure TfrmGameCmd.Open;
begin
  RefUserCommand();
  RefGameMasterCommand();
  RefDebugCommand();
  ShowModal;
end;

procedure TfrmGameCmd.RefGameUserCmd(GameCmd: pTGameCmd; sCmdParam, sDesc:
  string);
begin
  Inc(nRefGameUserIndex);
  if StringGridGameCmd.RowCount - 1 < nRefGameUserIndex then begin
    StringGridGameCmd.RowCount := nRefGameUserIndex + 1;
  end;

  StringGridGameCmd.Cells[0, nRefGameUserIndex] := GameCmd.sCmd;
  StringGridGameCmd.Cells[1, nRefGameUserIndex] :=
    IntToStr(GameCmd.nPermissionMin) + '/' + IntToStr(GameCmd.nPermissionMax);
  StringGridGameCmd.Cells[2, nRefGameUserIndex] := sCmdParam;
  StringGridGameCmd.Cells[3, nRefGameUserIndex] := sDesc;
  StringGridGameCmd.Objects[0, nRefGameUserIndex] := TObject(GameCmd);
end;

procedure TfrmGameCmd.RefUserCommand;
begin
  EditUserCmdOK.Enabled := False;
  nRefGameUserIndex := 0;

  RefGameUserCmd(@g_GameCommand.Data,
    '@' + g_GameCommand.Data.sCmd,
                   'Shows system date');
  RefGameUserCmd(@g_GameCommand.PRVMSG,
    '@' + g_GameCommand.PRVMSG.sCmd,
                   'Block private messages');
  RefGameUserCmd(@g_GameCommand.ALLOWMSG,
    '@' + g_GameCommand.ALLOWMSG.sCmd,
                   'Allow chat to show');
  RefGameUserCmd(@g_GameCommand.LETSHOUT,
    '@' + g_GameCommand.LETSHOUT.sCmd,
                   'Allow shouts to show');
  RefGameUserCmd(@g_GameCommand.LETTRADE,
    '@' + g_GameCommand.LETTRADE.sCmd,
                   'Allow trading');
  RefGameUserCmd(@g_GameCommand.LETGUILD,
    '@' + g_GameCommand.LETGUILD.sCmd,
                   'Allow player to join a guild');
  RefGameUserCmd(@g_GameCommand.ENDGUILD,
    '@' + g_GameCommand.ENDGUILD.sCmd,
                   'Leaves the players current guild');
  RefGameUserCmd(@g_GameCommand.BANGUILDCHAT,
    '@' + g_GameCommand.BANGUILDCHAT.sCmd,
                   'Block guild chats from showing');
  RefGameUserCmd(@g_GameCommand.AUTHALLY,
    '@' + g_GameCommand.AUTHALLY.sCmd,
                   'Allow allying of two guilds');
  RefGameUserCmd(@g_GameCommand.AUTH,
    '@' + g_GameCommand.AUTH.sCmd,
                   'Ally two guilds');
  RefGameUserCmd(@g_GameCommand.AUTHCANCEL,
    '@' + g_GameCommand.AUTHCANCEL.sCmd,
                   'Cancel a guild alliance');
  RefGameUserCmd(@g_GameCommand.ALLOWFIREND,
    '@' + g_GameCommand.ALLOWFIREND.sCmd,
                    'Allow Friendship');
  RefGameUserCmd(@g_GameCommand.AllSysMsg,
    '@' + g_GameCommand.AllSysMsg.sCmd,
                    '千里传音');     //Translate
  Exit;

  StringGridGameCmd.Cells[0, 12] := g_GameCommand.DIARY.sCmd;
  StringGridGameCmd.Cells[1, 12] := IntToStr(g_GameCommand.DIARY.nPermissionMin);
  StringGridGameCmd.Cells[2, 12] := '@' + g_GameCommand.DIARY.sCmd;
  StringGridGameCmd.Objects[0, 12] := TObject(@g_GameCommand.DIARY);

  StringGridGameCmd.Cells[0, 13] := g_GameCommand.USERMOVE.sCmd;
  StringGridGameCmd.Cells[1, 13] := IntToStr(g_GameCommand.USERMOVE.nPermissionMin);
  StringGridGameCmd.Cells[2, 13] := '@' + g_GameCommand.USERMOVE.sCmd;
  StringGridGameCmd.Objects[0, 13] := TObject(@g_GameCommand.USERMOVE);

  StringGridGameCmd.Cells[0, 14] := g_GameCommand.SEARCHING.sCmd;
  StringGridGameCmd.Cells[1, 14] := IntToStr(g_GameCommand.SEARCHING.nPermissionMin);
  StringGridGameCmd.Cells[2, 14] := '@' + g_GameCommand.SEARCHING.sCmd;
  StringGridGameCmd.Objects[0, 14] := TObject(@g_GameCommand.SEARCHING);

  StringGridGameCmd.Cells[0, 15] := g_GameCommand.ALLOWGROUPCALL.sCmd;
  StringGridGameCmd.Cells[1, 15] := IntToStr(g_GameCommand.ALLOWGROUPCALL.nPermissionMin);
  StringGridGameCmd.Cells[2, 15] := '@' + g_GameCommand.ALLOWGROUPCALL.sCmd;
  StringGridGameCmd.Objects[0, 15] := TObject(@g_GameCommand.ALLOWGROUPCALL);

  StringGridGameCmd.Cells[0, 16] := g_GameCommand.GROUPRECALLL.sCmd;
  StringGridGameCmd.Cells[1, 16] := IntToStr(g_GameCommand.GROUPRECALLL.nPermissionMin);
  StringGridGameCmd.Cells[2, 16] := '@' + g_GameCommand.GROUPRECALLL.sCmd;
  StringGridGameCmd.Objects[0, 16] := TObject(@g_GameCommand.GROUPRECALLL);

  StringGridGameCmd.Cells[0, 17] := g_GameCommand.ALLOWGUILDRECALL.sCmd;
  StringGridGameCmd.Cells[1, 17] := IntToStr(g_GameCommand.ALLOWGUILDRECALL.nPermissionMin);
  StringGridGameCmd.Cells[2, 17] := '@' + g_GameCommand.ALLOWGUILDRECALL.sCmd;
  StringGridGameCmd.Objects[0, 17] := TObject(@g_GameCommand.ALLOWGUILDRECALL);

  StringGridGameCmd.Cells[0, 18] := g_GameCommand.GUILDRECALLL.sCmd;
  StringGridGameCmd.Cells[1, 18] := IntToStr(g_GameCommand.GUILDRECALLL.nPermissionMin);
  StringGridGameCmd.Cells[2, 18] := '@' + g_GameCommand.GUILDRECALLL.sCmd;
  StringGridGameCmd.Objects[0, 18] := TObject(@g_GameCommand.GUILDRECALLL);

  StringGridGameCmd.Cells[0, 19] := g_GameCommand.UNLOCKSTORAGE.sCmd;
  StringGridGameCmd.Cells[1, 19] := IntToStr(g_GameCommand.UNLOCKSTORAGE.nPermissionMin);
  StringGridGameCmd.Cells[2, 19] := '@' + g_GameCommand.UNLOCKSTORAGE.sCmd;
  StringGridGameCmd.Objects[0, 19] := TObject(@g_GameCommand.UNLOCKSTORAGE);

  StringGridGameCmd.Cells[0, 20] := g_GameCommand.UnLock.sCmd;
  StringGridGameCmd.Cells[1, 20] := IntToStr(g_GameCommand.UnLock.nPermissionMin);
  StringGridGameCmd.Cells[2, 20] := '@' + g_GameCommand.UnLock.sCmd;
  StringGridGameCmd.Objects[0, 20] := TObject(@g_GameCommand.UnLock);

  StringGridGameCmd.Cells[0, 21] := g_GameCommand.Lock.sCmd;
  StringGridGameCmd.Cells[1, 21] := IntToStr(g_GameCommand.Lock.nPermissionMin);
  StringGridGameCmd.Cells[2, 21] := '@' + g_GameCommand.Lock.sCmd;
  StringGridGameCmd.Objects[0, 21] := TObject(@g_GameCommand.Lock);

  StringGridGameCmd.Cells[0, 22] := g_GameCommand.SETPASSWORD.sCmd;
  StringGridGameCmd.Cells[1, 22] := IntToStr(g_GameCommand.SETPASSWORD.nPermissionMin);
  StringGridGameCmd.Cells[2, 22] := '@' + g_GameCommand.SETPASSWORD.sCmd;
  StringGridGameCmd.Objects[0, 22] := TObject(@g_GameCommand.SETPASSWORD);

  StringGridGameCmd.Cells[0, 23] := g_GameCommand.CHGPASSWORD.sCmd;
  StringGridGameCmd.Cells[1, 23] := IntToStr(g_GameCommand.CHGPASSWORD.nPermissionMin);
  StringGridGameCmd.Cells[2, 23] := '@' + g_GameCommand.CHGPASSWORD.sCmd;
  StringGridGameCmd.Objects[0, 23] := TObject(@g_GameCommand.CHGPASSWORD);

  StringGridGameCmd.Cells[0, 24] := g_GameCommand.UNPASSWORD.sCmd;
  StringGridGameCmd.Cells[1, 24] := IntToStr(g_GameCommand.UNPASSWORD.nPermissionMin);
  StringGridGameCmd.Cells[2, 24] := '@' + g_GameCommand.UNPASSWORD.sCmd;
  StringGridGameCmd.Objects[0, 24] := TObject(@g_GameCommand.UNPASSWORD);

   StringGridGameCmd.Cells[0, 26] := g_GameCommand.DEAR.sCmd;
  StringGridGameCmd.Cells[1, 26] := IntToStr(g_GameCommand.DEAR.nPermissionMin);
  StringGridGameCmd.Cells[2, 26] := '@' + g_GameCommand.DEAR.sCmd;
  StringGridGameCmd.Objects[0, 26] := TObject(@g_GameCommand.DEAR);

  StringGridGameCmd.Cells[0, 27] := g_GameCommand.ALLOWDEARRCALL.sCmd;
  StringGridGameCmd.Cells[1, 27] := IntToStr(g_GameCommand.ALLOWDEARRCALL.nPermissionMin);
  StringGridGameCmd.Cells[2, 27] := '@' + g_GameCommand.ALLOWDEARRCALL.sCmd;
  StringGridGameCmd.Objects[0, 27] := TObject(@g_GameCommand.ALLOWDEARRCALL);

  StringGridGameCmd.Cells[0, 28] := g_GameCommand.DEARRECALL.sCmd;
  StringGridGameCmd.Cells[1, 28] := IntToStr(g_GameCommand.DEARRECALL.nPermissionMin);
  StringGridGameCmd.Cells[2, 28] := '@' + g_GameCommand.DEARRECALL.sCmd;
  StringGridGameCmd.Objects[0, 28] := TObject(@g_GameCommand.DEARRECALL);

  StringGridGameCmd.Cells[0, 29] := g_GameCommand.Master.sCmd;
  StringGridGameCmd.Cells[1, 29] := IntToStr(g_GameCommand.Master.nPermissionMin);
  StringGridGameCmd.Cells[2, 29] := '@' + g_GameCommand.Master.sCmd;
  StringGridGameCmd.Objects[0, 29] := TObject(@g_GameCommand.Master);

  StringGridGameCmd.Cells[0, 30] := g_GameCommand.ALLOWMASTERRECALL.sCmd;
  StringGridGameCmd.Cells[1, 30] := IntToStr(g_GameCommand.ALLOWMASTERRECALL.nPermissionMin);
  StringGridGameCmd.Cells[2, 30] := '@' + g_GameCommand.ALLOWMASTERRECALL.sCmd;
  StringGridGameCmd.Objects[0, 30] := TObject(@g_GameCommand.ALLOWMASTERRECALL);

  StringGridGameCmd.Cells[0, 31] := g_GameCommand.MASTERECALL.sCmd;
  StringGridGameCmd.Cells[1, 31] := IntToStr(g_GameCommand.MASTERECALL.nPermissionMin);
  StringGridGameCmd.Cells[2, 31] := '@' + g_GameCommand.MASTERECALL.sCmd;
  StringGridGameCmd.Objects[0, 31] := TObject(@g_GameCommand.MASTERECALL);

  StringGridGameCmd.Cells[0, 34] := g_GameCommand.TAKEONHORSE.sCmd;
  StringGridGameCmd.Cells[1, 34] := IntToStr(g_GameCommand.TAKEONHORSE.nPermissionMin);
  StringGridGameCmd.Cells[2, 34] := '@' + g_GameCommand.TAKEONHORSE.sCmd;
  StringGridGameCmd.Objects[0, 34] := TObject(@g_GameCommand.TAKEONHORSE);

  StringGridGameCmd.Cells[0, 35] := g_GameCommand.TAKEOFHORSE.sCmd;
  StringGridGameCmd.Cells[1, 35] := IntToStr(g_GameCommand.TAKEOFHORSE.nPermissionMin);
  StringGridGameCmd.Cells[2, 35] := '@' + g_GameCommand.TAKEOFHORSE.sCmd;
  StringGridGameCmd.Objects[0, 35] := TObject(@g_GameCommand.TAKEOFHORSE);

  StringGridGameCmd.Cells[0, 37] := g_GameCommand.LOCKLOGON.sCmd;
  StringGridGameCmd.Cells[1, 37] := IntToStr(g_GameCommand.LOCKLOGON.nPermissionMin);
  StringGridGameCmd.Cells[2, 37] := '@' + g_GameCommand.LOCKLOGON.sCmd;
  StringGridGameCmd.Objects[0, 37] := TObject(@g_GameCommand.LOCKLOGON);

  StringGridGameCmd.Cells[0, 25] := g_GameCommand.MEMBERFUNCTION.sCmd;
  StringGridGameCmd.Cells[1, 25] := IntToStr(g_GameCommand.MEMBERFUNCTION.nPermissionMin);
  StringGridGameCmd.Cells[2, 25] := '@' + g_GameCommand.MEMBERFUNCTION.sCmd;
  StringGridGameCmd.Objects[0, 25] := TObject(@g_GameCommand.MEMBERFUNCTION);

  StringGridGameCmd.Cells[0, 36] := g_GameCommand.MEMBERFUNCTIONEX.sCmd;
  StringGridGameCmd.Cells[1, 36] := IntToStr(g_GameCommand.MEMBERFUNCTIONEX.nPermissionMin);
  StringGridGameCmd.Cells[2, 36] := '@' + g_GameCommand.MEMBERFUNCTIONEX.sCmd;
  StringGridGameCmd.Objects[0, 36] := TObject(@g_GameCommand.MEMBERFUNCTIONEX);
end;

procedure TfrmGameCmd.StringGridGameCmdClick(Sender: TObject);
var
  nIndex: Integer;
  GameCmd: pTGameCmd;
begin
  nIndex := StringGridGameCmd.Row;
  GameCmd := pTGameCmd(StringGridGameCmd.Objects[0, nIndex]);
  if GameCmd <> nil then begin
    EditUserCmdName.Text := GameCmd.sCmd;
    EditUserCmdPerMission.Value := GameCmd.nPermissionMin;
    LabelUserCmdParam.Caption := StringGridGameCmd.Cells[2, nIndex];
    LabelUserCmdFunc.Caption := StringGridGameCmd.Cells[3, nIndex];
  end;
  EditUserCmdOK.Enabled := False;
end;

procedure TfrmGameCmd.EditUserCmdNameChange(Sender: TObject);
begin
  EditUserCmdOK.Enabled := True;
  EditUserCmdSave.Enabled := True;
end;

procedure TfrmGameCmd.EditUserCmdPerMissionChange(Sender: TObject);
begin
  EditUserCmdOK.Enabled := True;
  EditUserCmdSave.Enabled := True;
end;

procedure TfrmGameCmd.EditUserCmdOKClick(Sender: TObject);
var
  nIndex: Integer;
  GameCmd: pTGameCmd;
  sCmd: string;
  nPermission: Integer;
begin
  sCmd := Trim(EditUserCmdName.Text);
  nPermission := EditUserCmdPerMission.Value;
  if sCmd = '' then begin
    Application.MessageBox('Command name can not be empty!!!','Message',
      MB_OK +
      MB_ICONERROR);
    EditUserCmdName.SetFocus;
    exit;
  end;

  nIndex := StringGridGameCmd.Row;
  GameCmd := pTGameCmd(StringGridGameCmd.Objects[0, nIndex]);
  if GameCmd <> nil then begin
    GameCmd.sCmd := sCmd;
    GameCmd.nPermissionMin := nPermission;
  end;
  RefUserCommand();
end;

procedure TfrmGameCmd.EditUserCmdSaveClick(Sender: TObject);
begin
  EditUserCmdSave.Enabled := False;
  CommandConf.WriteString('Command', 'Data', g_GameCommand.Data.sCmd);
  CommandConf.WriteString('Command', 'PRVMSG', g_GameCommand.PRVMSG.sCmd);
  CommandConf.WriteString('Command', 'ALLOWMSG', g_GameCommand.ALLOWMSG.sCmd);
  CommandConf.WriteString('Command', 'LETSHOUT', g_GameCommand.LETSHOUT.sCmd);
  CommandConf.WriteString('Command', 'LETTRADE', g_GameCommand.LETTRADE.sCmd);
  CommandConf.WriteString('Command', 'LETGUILD', g_GameCommand.LETGUILD.sCmd);
  CommandConf.WriteString('Command', 'ENDGUILD', g_GameCommand.ENDGUILD.sCmd);
  CommandConf.WriteString('Command', 'BANGUILDCHAT', g_GameCommand.BANGUILDCHAT.sCmd);
  CommandConf.WriteString('Command', 'AUTHALLY', g_GameCommand.AUTHALLY.sCmd);
  CommandConf.WriteString('Command', 'AUTH', g_GameCommand.AUTH.sCmd);
  CommandConf.WriteString('Command', 'AUTHCANCEL', g_GameCommand.AUTHCANCEL.sCmd);
  CommandConf.WriteString('Command', 'USERMOVE', g_GameCommand.USERMOVE.sCmd);
  CommandConf.WriteString('Command', 'SEARCHING', g_GameCommand.SEARCHING.sCmd);
  CommandConf.WriteString('Command', 'ALLOWGROUPCALL', g_GameCommand.ALLOWGROUPCALL.sCmd);
  CommandConf.WriteString('Command', 'GROUPRECALLL', g_GameCommand.GROUPRECALLL.sCmd);
  CommandConf.WriteString('Command', 'ALLOWGUILDRECALL', g_GameCommand.ALLOWGUILDRECALL.sCmd);
  CommandConf.WriteString('Command', 'GUILDRECALLL', g_GameCommand.GUILDRECALLL.sCmd);
  CommandConf.WriteString('Command', 'UNLOCKSTORAGE', g_GameCommand.UNLOCKSTORAGE.sCmd);
  CommandConf.WriteString('Command', 'UnLock', g_GameCommand.UnLock.sCmd);
  CommandConf.WriteString('Command', 'Lock', g_GameCommand.Lock.sCmd);
  CommandConf.WriteString('Command', 'SETPASSWORD', g_GameCommand.SETPASSWORD.sCmd);
  CommandConf.WriteString('Command', 'CHGPASSWORD', g_GameCommand.CHGPASSWORD.sCmd);
  CommandConf.WriteString('Command', 'UNPASSWORD', g_GameCommand.UNPASSWORD.sCmd);
  CommandConf.WriteString('Command', 'DEAR', g_GameCommand.DEAR.sCmd);
  CommandConf.WriteString('Command', 'ALLOWDEARRCALL', g_GameCommand.ALLOWDEARRCALL.sCmd);
  CommandConf.WriteString('Command', 'DEARRECALL', g_GameCommand.DEARRECALL.sCmd);
  CommandConf.WriteString('Command', 'MASTER', g_GameCommand.MASTER.sCmd);
  CommandConf.WriteString('Command', 'ALLOWMASTERRECALL', g_GameCommand.ALLOWMASTERRECALL.sCmd);
  CommandConf.WriteString('Command', 'MASTERECALL', g_GameCommand.MASTERECALL.sCmd);
  CommandConf.WriteString('Command', 'ALLOWFIREND', g_GameCommand.ALLOWFIREND.sCmd);
  CommandConf.WriteString('Command', 'REST', g_GameCommand.REST.sCmd);
  CommandConf.WriteString('Command', 'TAKEONHORSE', g_GameCommand.TAKEONHORSE.sCmd);
  CommandConf.WriteString('Command', 'TAKEOFHORSE', g_GameCommand.TAKEOFHORSE.sCmd);
  CommandConf.WriteString('Command', 'LOCKLOGON', g_GameCommand.LOCKLOGON.sCmd);
  CommandConf.WriteString('Command', 'AllSysMsg', g_GameCommand.AllSysMsg.sCmd);
  CommandConf.WriteString('Command', 'MEMBERFUNCTION', g_GameCommand.MEMBERFUNCTION.sCmd);
  CommandConf.WriteString('Command', 'MEMBERFUNCTIONEX', g_GameCommand.MEMBERFUNCTIONEX.sCmd);

end;

procedure TfrmGameCmd.RefGameMasterCmd(GameCmd: pTGameCmd; sCmdParam, sDesc:
  string);
begin
  Inc(nRefGameMasterIndex);
  if StringGridGameMasterCmd.RowCount - 1 < nRefGameMasterIndex then begin
    StringGridGameMasterCmd.RowCount := nRefGameMasterIndex + 1;
  end;

  StringGridGameMasterCmd.Cells[0, nRefGameMasterIndex] := GameCmd.sCmd;
  StringGridGameMasterCmd.Cells[1, nRefGameMasterIndex] :=
    IntToStr(GameCmd.nPermissionMin) + '/' + IntToStr(GameCmd.nPermissionMax);
  StringGridGameMasterCmd.Cells[2, nRefGameMasterIndex] := sCmdParam;
  StringGridGameMasterCmd.Cells[3, nRefGameMasterIndex] := sDesc;
  StringGridGameMasterCmd.Objects[0, nRefGameMasterIndex] := TObject(GameCmd);
end;

procedure TfrmGameCmd.RefGameMasterCommand;
//var
//  GameCmd: pTGameCmd;
//  sDesc: string;
//  sCmdParam: string;
begin
  EditGameMasterCmdOK.Enabled := False;
  nRefGameMasterIndex := 0;

  RefGameMasterCmd(@g_GameCommand.CLRPASSWORD,
    '@' + g_GameCommand.CLRPASSWORD.sCmd + ' <Username>',
                   'Clears a users password if they forget it');

  RefGameMasterCmd(@g_GameCommand.WHO,
    '@' + g_GameCommand.WHO.sCmd,
                   'Shows total no of users connected to current server');

  RefGameMasterCmd(@g_GameCommand.TOTAL,
    '@' + g_GameCommand.TOTAL.sCmd,
                   'Shows total no of users connected accross all servers');

  RefGameMasterCmd(@g_GameCommand.GAMEMASTER,
    '@' + g_GameCommand.GAMEMASTER.sCmd,
                   'Puts a user in/out of GameMaster mode (Invisible to mobs)');

  RefGameMasterCmd(@g_GameCommand.OBSERVER,
    '@' + g_GameCommand.OBSERVER.sCmd,
                   'Puts a user in/out of observer mode (Invisible to all)');

  RefGameMasterCmd(@g_GameCommand.SUEPRMAN,
    '@' + g_GameCommand.SUEPRMAN.sCmd,
                   'Makes the user invincible');

  RefGameMasterCmd(@g_GameCommand.MAKE,
    '@' + g_GameCommand.MAKE.sCmd + ' <Itemname> <Amount>',
                   'Manually creates an item');

  RefGameMasterCmd(@g_GameCommand.SMAKE,
    '@' + g_GameCommand.SMAKE.sCmd + ' <Itemname> <DC> <MC> <SC>',
                   'Creates an item with added stats');

  RefGameMasterCmd(@g_GameCommand.Move,
    '@' + g_GameCommand.Move.sCmd + ' <Map No>',
                   'Moves a player to a random location on the specified map');

  RefGameMasterCmd(@g_GameCommand.POSITIONMOVE,
    '@' + g_GameCommand.POSITIONMOVE.sCmd + ' <Map No> <X Co-ordinate> <Y Co-ordinate>',
                   'Moves a player to a set location on the specified map');

  RefGameMasterCmd(@g_GameCommand.RECALL,
    '@' + g_GameCommand.RECALL.sCmd + ' <Username>',
                   'Teleports specified player to your location');

  RefGameMasterCmd(@g_GameCommand.REGOTO,
    '@' + g_GameCommand.REGOTO.sCmd + ' <Username>',
                   'Teleports command user to the specified users location');

  RefGameMasterCmd(@g_GameCommand.TING,
    '@' + g_GameCommand.TING.sCmd + ' <Username>',
                   'Randomly teleports a player');

  RefGameMasterCmd(@g_GameCommand.SUPERTING,
    '@' + g_GameCommand.SUPERTING.sCmd + ' <Username> <Amount(0 - 10)>',
                   'Randomly teleports a player and the surrounding players');

  RefGameMasterCmd(@g_GameCommand.MAPMOVE,
    '@' + g_GameCommand.MAPMOVE.sCmd + ' <Old map no> <New map no>',
                   '? gives a map a new map no ?');

  RefGameMasterCmd(@g_GameCommand.INFO,
    '@' + g_GameCommand.INFO.sCmd + ' <Username>',
                   'Shows a users full details');

  RefGameMasterCmd(@g_GameCommand.HUMANLOCAL,
    '@' + g_GameCommand.HUMANLOCAL.sCmd + ' <Map no>',
                   'Shows the no of players on the specified map');

  RefGameMasterCmd(@g_GameCommand.VIEWWHISPER,
    '@' + g_GameCommand.VIEWWHISPER.sCmd + ' <Username>',
                   'Interceps a copy of any PMs sent to the specified user');

  RefGameMasterCmd(@g_GameCommand.MOBLEVEL,
    '@' + g_GameCommand.MOBLEVEL.sCmd,
                   'Shows the data of the surroumnding mobs');

  RefGameMasterCmd(@g_GameCommand.MOBCOUNT,
    '@' + g_GameCommand.MOBCOUNT.sCmd + ' <Map no>',
                   'Displays how many mobs there are on the specified map');

  RefGameMasterCmd(@g_GameCommand.HUMANCOUNT,
    '@' + g_GameCommand.HUMANCOUNT.sCmd,
                   'No of players on the current map');

  RefGameMasterCmd(@g_GameCommand.Map,
    '@' + g_GameCommand.Map.sCmd,
                   'Displays the current map filename');

  RefGameMasterCmd(@g_GameCommand.Level,
    '@' + g_GameCommand.Level.sCmd,
                   'Changes your own level');

  RefGameMasterCmd(@g_GameCommand.KICK,
    '@' + g_GameCommand.KICK.sCmd + ' <Username>',
                   'Disconnecs a user');

  RefGameMasterCmd(@g_GameCommand.ReAlive,
    '@' + g_GameCommand.ReAlive.sCmd + ' <Username>',
                   'Brings a player back to life');

  RefGameMasterCmd(@g_GameCommand.KILL,
    '@' + g_GameCommand.KILL.sCmd + '<Username>',
                   'Kills a player instantly');

  RefGameMasterCmd(@g_GameCommand.CHANGEJOB,
    '@' + g_GameCommand.CHANGEJOB.sCmd + ' <Username> <Job(Warrior, Wizard, Taos, Sin)>',
                   'Changes the specified users job');

  RefGameMasterCmd(@g_GameCommand.FREEPENALTY,
    '@' + g_GameCommand.FREEPENALTY.sCmd + ' <Username>',
                   'Resets specified users PK value back to 0');

  RefGameMasterCmd(@g_GameCommand.PKPOINT,
    '@' + g_GameCommand.PKPOINT.sCmd + ' <Username>',
                   'Displays the specified users PK points');

  RefGameMasterCmd(@g_GameCommand.IncPkPoint,
    '@' + g_GameCommand.IncPkPoint.sCmd + ' <Username> <Points>',
                   'Increases the specified users PK points by the specified amount');

  RefGameMasterCmd(@g_GameCommand.CHANGEGENDER,
    '@' + g_GameCommand.CHANGEGENDER.sCmd + ' <Username> <Sex(M, F)>',
                   'Changes a players sex');

  RefGameMasterCmd(@g_GameCommand.HAIR,
    '@' + g_GameCommand.HAIR.sCmd + ' <Style no(0 or 1)>',
                   'Sets the specified hairstyle');

  RefGameMasterCmd(@g_GameCommand.BonusPoint,
    '@' + g_GameCommand.BonusPoint.sCmd + ' <Username> <Amount of points>',
                   'Displays specified users bonus points');

  RefGameMasterCmd(@g_GameCommand.DELBONUSPOINT,
    '@' + g_GameCommand.DELBONUSPOINT.sCmd + ' <Username>',
                   'Deletes specified users bonus points');

  RefGameMasterCmd(@g_GameCommand.RESTBONUSPOINT,
    '@' + g_GameCommand.RESTBONUSPOINT.sCmd + ' <Username>',
                   'Rest points');

  RefGameMasterCmd(@g_GameCommand.SETPERMISSION,
    '@' + g_GameCommand.SETPERMISSION.sCmd + ' <Username> <Permission level(0 - 10)>',
                   'Sets specified uses commands acces permissions');

  RefGameMasterCmd(@g_GameCommand.RENEWLEVEL,
    '@' + g_GameCommand.RENEWLEVEL.sCmd + ' <Username> <Points(Blank for View)>',
                   'Sets specified users rebirth level');

  RefGameMasterCmd(@g_GameCommand.DELGOLD,
    '@' + g_GameCommand.DELGOLD.sCmd + ' <Username> <Amount>',
                   'Removes specified amount of gold from specified players bag');

  RefGameMasterCmd(@g_GameCommand.ADDGOLD,
    '@' + g_GameCommand.ADDGOLD.sCmd + ' <Username> <Amount>',
                   'Adds specified amount of gold to specified players bag');

  RefGameMasterCmd(@g_GameCommand.GAMEGOLD,
    '@' + g_GameCommand.GAMEGOLD.sCmd + ' <Username> <Action(+ - =)> <Amount>',
                   'Shows(if only <username> used)/adds/removes/sets specified players gamegold');

  RefGameMasterCmd(@g_GameCommand.GAMEPOINT,
    '@' + g_GameCommand.GAMEPOINT.sCmd + ' <Username> <Action(+ - =)> <Amount>',
                   'Shows(if only <username> used)/adds/removes/sets specified players gamepoints');

  RefGameMasterCmd(@g_GameCommand.CREDITPOINT,
    '@' + g_GameCommand.CREDITPOINT.sCmd + ' <Username> <Action(+ - =)> <Points>',
                   'Shows(if only <username> used)/adds/removes/sets specified players creditpoints');

  RefGameMasterCmd(@g_GameCommand.REFINEWEAPON,
    '@' + g_GameCommand.REFINEWEAPON.sCmd + ' <DC> <MC> <SC> <Accuracy>',
                   'Refines the weapon equipped with the specified stats');

  RefGameMasterCmd(@g_GameCommand.ADJUESTLEVEL,
    '@' + g_GameCommand.ADJUESTLEVEL.sCmd + ' <Username> <Level>',
                   'Adjusts the specified players level to the specified level');

  RefGameMasterCmd(@g_GameCommand.ADJUESTEXP,
    '@' + g_GameCommand.ADJUESTEXP.sCmd + ' <Username> <Experience points>',
                   'Adjusts the specified players exp to the specified amount');


  RefGameMasterCmd(@g_GameCommand.CHANGEDEARNAME,
    '@' + g_GameCommand.CHANGEDEARNAME.sCmd + ' <Username> <Partners name(must be online)>',
                   'Creates a married couple');

  RefGameMasterCmd(@g_GameCommand.CHANGEMASTERNAME,
    '@' + g_GameCommand.CHANGEMASTERNAME.sCmd + ' <Username> <Masters name(must be online)>',
                   'Creates a master and slave couple');

  RefGameMasterCmd(@g_GameCommand.RECALLMOB,
    '@' + g_GameCommand.RECALLMOB.sCmd + ' <Mob name> <Amount> <Mob level(0-9)>',
                   'Spawns specified mob for the specified player at the specified level as a pet');

  RefGameMasterCmd(@g_GameCommand.TRAINING,
    '@' + g_GameCommand.TRAINING.sCmd + ' <Username> <Skill name> <Skill level(0-3)>',
                   'Sets the specified skill of the specified player to the specified level');


  RefGameMasterCmd(@g_GameCommand.TRAININGSKILL,
    '@' + g_GameCommand.TRAININGSKILL.sCmd + ' <Username> <Skill name> <Skill level(0-3)>',
                   'Sets the specified skill of the specified player to the specified level');

  RefGameMasterCmd(@g_GameCommand.DELETESKILL,
    '@' + g_GameCommand.DELETESKILL.sCmd + ' <Username> <Skill name(All)>',
                   'Removes specified skill from specified player');

  RefGameMasterCmd(@g_GameCommand.DELETEITEM,
    '@' + g_GameCommand.DELETEITEM.sCmd + ' <Username> <Itemname> <Amount>',
                   'Removes the specified amount of the specified item form the specified user');

  RefGameMasterCmd(@g_GameCommand.CLEARMISSION,
    '@' + g_GameCommand.CLEARMISSION.sCmd + ' <Username>',
                   'Stops the misson that has been set and mobs will revert to normal');

  RefGameMasterCmd(@g_GameCommand.AddGuild,
    '@' + g_GameCommand.AddGuild.sCmd + ' <Guildname> <Guildchief>',
                   'Creates a guild manually');

  RefGameMasterCmd(@g_GameCommand.DELGUILD,
    '@' + g_GameCommand.DELGUILD.sCmd + ' <Guildname>',
                   'Deletes a guild');

  RefGameMasterCmd(@g_GameCommand.CHANGESABUKLORD,
    '@' + g_GameCommand.CHANGESABUKLORD.sCmd + ' <Castlename> <Guildname>',
                   'Changes ownership of named wall to named guild');

  RefGameMasterCmd(@g_GameCommand.FORCEDWALLCONQUESTWAR,
    '@' + g_GameCommand.FORCEDWALLCONQUESTWAR.sCmd,
                   'Forces the start of a castle war');

  RefGameMasterCmd(@g_GameCommand.CONTESTPOINT,
    '@' + g_GameCommand.CONTESTPOINT.sCmd + ' <Guildname>',
                   'View Guild Competition scores');

  RefGameMasterCmd(@g_GameCommand.STARTCONTEST,
    '@' + g_GameCommand.STARTCONTEST.sCmd,
                   'Competition will start line');

  RefGameMasterCmd(@g_GameCommand.ENDCONTEST,
    '@' + g_GameCommand.ENDCONTEST.sCmd,
                   'Competition will end line');

  RefGameMasterCmd(@g_GameCommand.ANNOUNCEMENT,
                   '@' + g_GameCommand.ANNOUNCEMENT.sCmd + ' <Message>',
                   'Sends in-game message');

  RefGameMasterCmd(@g_GameCommand.MOB,
    '@' + g_GameCommand.MOB.sCmd + ' <Mobname> <Amount>',
                   'Use to manually spawn a mob');

  RefGameMasterCmd(@g_GameCommand.Mission,
    '@' + g_GameCommand.Mission.sCmd + ' <X> <Y>',
                   'Sets the start of a mob mission');

  RefGameMasterCmd(@g_GameCommand.MobPlace,
    '@' + g_GameCommand.MobPlace.sCmd + ' <X> <Y> <Mobname> <Amount>',
                   'Place mob at designated co-ordinates.  Guards will not atactk a placed mob.');

  RefGameMasterCmd(@g_GameCommand.CLEARMON,
                   '@' + g_GameCommand.CLEARMON.sCmd + ' <Map(* for all)> <Mob name(* for all)> <Drop items(0,1)>',
                   'Clears a map of all mob - including any pets');

  RefGameMasterCmd(@g_GameCommand.DISABLESENDMSG,
    '@' + g_GameCommand.DISABLESENDMSG.sCmd + ' <Username>',
                   'Block a user from sending messages');

  RefGameMasterCmd(@g_GameCommand.ENABLESENDMSG,
    '@' + g_GameCommand.ENABLESENDMSG.sCmd,
                   'Allow a user to chat again after being banned');

  RefGameMasterCmd(@g_GameCommand.DISABLESENDMSGLIST,
    '@' + g_GameCommand.DISABLESENDMSGLIST.sCmd,
                   'View the contents of the speech filter list');

  RefGameMasterCmd(@g_GameCommand.SHUTUP,
    '@' + g_GameCommand.SHUTUP.sCmd + ' <Username>',
                   'Ban a player from chatting');

  RefGameMasterCmd(@g_GameCommand.RELEASESHUTUP,
    '@' + g_GameCommand.RELEASESHUTUP.sCmd + ' <Username>',
                   'Allow a player to chat again after being banned');

  RefGameMasterCmd(@g_GameCommand.SHUTUPLIST,
    '@' + g_GameCommand.SHUTUPLIST.sCmd,
                   'Displays a list of users that are banned from chatting');

  RefGameMasterCmd(@g_GameCommand.SABUKWALLGOLD,
    '@' + g_GameCommand.SABUKWALLGOLD.sCmd,
                   'View the castle gold');

  RefGameMasterCmd(@g_GameCommand.STARTQUEST,
    '@' + g_GameCommand.STARTQUEST.sCmd,
                   'Begin a quest, Skips problem game windows');

  RefGameMasterCmd(@g_GameCommand.DENYIPLOGON,
    '@' + g_GameCommand.DENYIPLOGON.sCmd + ' <IP Address> <Disable/Enable(0,1)>',
                   'Block a user from logging in from a specific IP address');

  RefGameMasterCmd(@g_GameCommand.DELDENYIPLOGON,
    '@' + g_GameCommand.DELDENYIPLOGON.sCmd,
                   'Un-Block a user from logging in from a specific IP address');

  RefGameMasterCmd(@g_GameCommand.SHOWDENYIPLOGON,
    '@' + g_GameCommand.SHOWDENYIPLOGON.sCmd,
                   'Shows a list of banned IP addresses');

  RefGameMasterCmd(@g_GameCommand.DENYACCOUNTLOGON,
    '@' + g_GameCommand.DENYACCOUNTLOGON.sCmd + ' <AccountID> <Disable/Enable(0,1)>',
                   'Block a user from logging in from a specific account');

  RefGameMasterCmd(@g_GameCommand.DELDENYACCOUNTLOGON,
    '@' + g_GameCommand.DELDENYACCOUNTLOGON.sCmd,
                   'Un-Block a user from logging in from a specific account');

  RefGameMasterCmd(@g_GameCommand.SHOWDENYACCOUNTLOGON,
    '@' + g_GameCommand.SHOWDENYACCOUNTLOGON.sCmd,
                   'Shows a list of banned accounts');

  RefGameMasterCmd(@g_GameCommand.DENYCHARNAMELOGON,
    '@' + g_GameCommand.DENYCHARNAMELOGON.sCmd + ' <Username> <Disable/Enable(0,1)>',
                   'Block a user from logging in from a specific player name');

  RefGameMasterCmd(@g_GameCommand.DELDENYCHARNAMELOGON,
    '@' + g_GameCommand.DELDENYCHARNAMELOGON.sCmd,
                   'Un-Block a user from logging in from a specific player name');

  RefGameMasterCmd(@g_GameCommand.SHOWDENYCHARNAMELOGON,
    '@' + g_GameCommand.SHOWDENYCHARNAMELOGON.sCmd,
                   'Shows a list of banned player names');

  RefGameMasterCmd(@g_GameCommand.SetMapMode,
    '@' + g_GameCommand.SetMapMode.sCmd,
                   'Set map mode');

  RefGameMasterCmd(@g_GameCommand.SHOWMAPMODE,
    '@' + g_GameCommand.SHOWMAPMODE.sCmd,
                   'Show map mode');

  RefGameMasterCmd(@g_GameCommand.SPIRIT,
    '@' + g_GameCommand.SPIRIT.sCmd,
    '');

  RefGameMasterCmd(@g_GameCommand.SPIRITSTOP,
    '@' + g_GameCommand.SPIRITSTOP.sCmd,
    '');

end;

procedure TfrmGameCmd.RefGameDebugCmd(GameCmd: pTGameCmd; sCmdParam, sDesc:
  string);
begin
  Inc(nRefGameDebugIndex);
  if StringGridGameDebugCmd.RowCount - 1 < nRefGameDebugIndex then begin
    StringGridGameDebugCmd.RowCount := nRefGameDebugIndex + 1;
  end;

  StringGridGameDebugCmd.Cells[0, nRefGameDebugIndex] := GameCmd.sCmd;
  StringGridGameDebugCmd.Cells[1, nRefGameDebugIndex] :=
  IntToStr(GameCmd.nPermissionMin) + '/' + IntToStr(GameCmd.nPermissionMax);
  StringGridGameDebugCmd.Cells[2, nRefGameDebugIndex] := sCmdParam;
  StringGridGameDebugCmd.Cells[3, nRefGameDebugIndex] := sDesc;
  StringGridGameDebugCmd.Objects[0, nRefGameDebugIndex] := TObject(GameCmd);
end;

procedure TfrmGameCmd.RefDebugCommand;
var
  GameCmd: pTGameCmd;
begin
  EditGameDebugCmdOK.Enabled := False;
  nRefGameDebugIndex := 0;
  //  StringGridGameDebugCmd.RowCount:=41;

  GameCmd := @g_GameCommand.SHOWFLAG;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
                   'Shows the status of the specified flag');

  GameCmd := @g_GameCommand.SETFLAG;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
                   'Set the specified flag of a user');

  GameCmd := @g_GameCommand.MOBNPC;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');

  GameCmd := @g_GameCommand.DELNPC;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');

  GameCmd := @g_GameCommand.LOTTERYTICKET;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');

  GameCmd := @g_GameCommand.RELOADADMIN;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
                   'Reloads the GM list - users must log out/in to activate');

  GameCmd := @g_GameCommand.ReLoadNpc;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
                   'Reloads the NPCs that are on screen');

  GameCmd := @g_GameCommand.RELOADMANAGE;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
                   'Reloads the quest manager');


  GameCmd := @g_GameCommand.RELOADROBOTMANAGE;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
                   'Reloads the robot manager');

  GameCmd := @g_GameCommand.RELOADROBOT;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
                   'Reloads the robots');

  GameCmd := @g_GameCommand.RELOADMONITEMS;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
                   'Reloads all drop files');

  GameCmd := @g_GameCommand.RELOADDIARY;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
                   'Reloads the quest diray');

  GameCmd := @g_GameCommand.RELOADITEMDB;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
                   'Reloads the item database');

  GameCmd := @g_GameCommand.RELOADMAGICDB;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
                   'Reloads the magic database');

  GameCmd := @g_GameCommand.RELOADMONSTERDB;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
                   'Reloads the monster database');

  GameCmd := @g_GameCommand.RELOADMINMAP;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
                   'Reloads the minimap settings file');

  GameCmd := @g_GameCommand.RELOADGUILD;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd + ' <Guildname>',
                   'Reloads the specified guild');

  GameCmd := @g_GameCommand.RELOADGUILDALL;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
                   'Reloads ALL guilds');

  GameCmd := @g_GameCommand.RELOADLINENOTICE;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
                   'Reloads the line notices');

  GameCmd := @g_GameCommand.RELOADABUSE;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
                   'Reloads the abuse filter list');

  GameCmd := @g_GameCommand.BACKSTEP;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
                   'Makes user step backwards');

  GameCmd := @g_GameCommand.RECONNECTION;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd + ' <IP address> <Port>',
                   'The specified network connection switch characters again');

  GameCmd := @g_GameCommand.DISABLEFILTER;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
                   'Disables the abuse filter');

  GameCmd := @g_GameCommand.CHGUSERFULL;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd + ' <Amount>',
                   'Changes the amount of users that can connect simultaneously');

  GameCmd := @g_GameCommand.CHGZENFASTSTEP;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');

  GameCmd := @g_GameCommand.OXQUIZROOM;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');

  GameCmd := @g_GameCommand.BALL;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');

  GameCmd := @g_GameCommand.FIREBURN;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');

  GameCmd := @g_GameCommand.TESTFIRE;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');

  GameCmd := @g_GameCommand.TESTSTATUS;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');

  GameCmd := @g_GameCommand.TESTGOLDCHANGE;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');

  GameCmd := @g_GameCommand.GSA;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');

  GameCmd := @g_GameCommand.TESTGA;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');

  GameCmd := @g_GameCommand.MAPINFO;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd + ' <Map> <X> <Y>',
                   'Show map information');

  GameCmd := @g_GameCommand.CLEARBAG;
  RefGameDebugCmd(GameCmd,
                   '@' + GameCmd.sCmd + ' <Username>',
                   'Empties a users bag of all items');

  GameCmd := @g_GameCommand.SHOWEFFECT;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd + ' 特效ID',     //Translate
    '调试特效显示');

end;

procedure TfrmGameCmd.StringGridGameMasterCmdClick(Sender: TObject);
var
  nIndex: Integer;
  GameCmd: pTGameCmd;
begin
  nIndex := StringGridGameMasterCmd.Row;
  GameCmd := pTGameCmd(StringGridGameMasterCmd.Objects[0, nIndex]);
  if GameCmd <> nil then begin
    EditGameMasterCmdName.Text := GameCmd.sCmd;
    EditGameMasterCmdPerMission.Value := GameCmd.nPermissionMin;
    LabelGameMasterCmdParam.Caption := StringGridGameMasterCmd.Cells[2, nIndex];
    LabelGameMasterCmdFunc.Caption := StringGridGameMasterCmd.Cells[3, nIndex];
  end;
  EditGameMasterCmdOK.Enabled := False;
end;

procedure TfrmGameCmd.EditGameMasterCmdNameChange(Sender: TObject);
begin
  EditGameMasterCmdOK.Enabled := True;
  EditGameMasterCmdSave.Enabled := True;
end;

procedure TfrmGameCmd.EditGameMasterCmdPerMissionChange(Sender: TObject);
begin
  EditGameMasterCmdOK.Enabled := True;
  EditGameMasterCmdSave.Enabled := True;
end;

procedure TfrmGameCmd.EditGameMasterCmdOKClick(Sender: TObject);
var
  nIndex: Integer;
  GameCmd: pTGameCmd;
  sCmd: string;
  nPermission: Integer;
begin

  sCmd := Trim(EditGameMasterCmdName.Text);
  nPermission := EditGameMasterCmdPerMission.Value;
  if sCmd = '' then begin
    Application.MessageBox('Not a valid command permission level.','Error',
      MB_OK +
      MB_ICONERROR);
    EditGameMasterCmdName.SetFocus;
    exit;
  end;

  nIndex := StringGridGameMasterCmd.Row;
  GameCmd := pTGameCmd(StringGridGameMasterCmd.Objects[0, nIndex]);
  if GameCmd <> nil then begin
    GameCmd.sCmd := sCmd;
    GameCmd.nPermissionMin := nPermission;
  end;
  RefGameMasterCommand();
end;

procedure TfrmGameCmd.EditGameMasterCmdSaveClick(Sender: TObject);
begin
  EditGameMasterCmdSave.Enabled := False;
  CommandConf.WriteString('Command', 'CLRPASSWORD',
    g_GameCommand.CLRPASSWORD.sCmd);
  CommandConf.WriteInteger('Permission', 'CLRPASSWORD',
    g_GameCommand.CLRPASSWORD.nPermissionMin);
  CommandConf.WriteString('Command', 'WHO', g_GameCommand.WHO.sCmd);
  CommandConf.WriteInteger('Permission', 'WHO',
    g_GameCommand.WHO.nPermissionMin);
  CommandConf.WriteString('Command', 'TOTAL', g_GameCommand.TOTAL.sCmd);
  CommandConf.WriteInteger('Permission', 'TOTAL',
    g_GameCommand.TOTAL.nPermissionMin);
  CommandConf.WriteString('Command', 'GAMEMASTER',
    g_GameCommand.GAMEMASTER.sCmd);
  CommandConf.WriteInteger('Permission', 'GAMEMASTER',
    g_GameCommand.GAMEMASTER.nPermissionMin);
  CommandConf.WriteString('Command', 'OBSERVER', g_GameCommand.OBSERVER.sCmd);
  CommandConf.WriteInteger('Permission', 'OBSERVER',
    g_GameCommand.OBSERVER.nPermissionMin);
  CommandConf.WriteString('Command', 'SUEPRMAN', g_GameCommand.SUEPRMAN.sCmd);
  CommandConf.WriteInteger('Permission', 'SUEPRMAN',
    g_GameCommand.SUEPRMAN.nPermissionMin);
  CommandConf.WriteString('Command', 'MAKE', g_GameCommand.MAKE.sCmd);
  CommandConf.WriteInteger('Permission', 'MAKE',
    g_GameCommand.MAKE.nPermissionMin);
  CommandConf.WriteString('Command', 'SMAKE', g_GameCommand.SMAKE.sCmd);
  CommandConf.WriteInteger('Permission', 'SMAKE',
    g_GameCommand.SMAKE.nPermissionMin);
  CommandConf.WriteString('Command', 'Move', g_GameCommand.Move.sCmd);
  CommandConf.WriteInteger('Permission', 'Move',
    g_GameCommand.Move.nPermissionMin);
  CommandConf.WriteString('Command', 'POSITIONMOVE',
    g_GameCommand.POSITIONMOVE.sCmd);
  CommandConf.WriteInteger('Permission', 'POSITIONMOVE',
    g_GameCommand.POSITIONMOVE.nPermissionMin);
  CommandConf.WriteString('Command', 'RECALL', g_GameCommand.RECALL.sCmd);
  CommandConf.WriteInteger('Permission', 'RECALL',
    g_GameCommand.RECALL.nPermissionMin);
  CommandConf.WriteString('Command', 'REGOTO', g_GameCommand.REGOTO.sCmd);
  CommandConf.WriteInteger('Permission', 'REGOTO',
    g_GameCommand.REGOTO.nPermissionMin);
  CommandConf.WriteString('Command', 'TING', g_GameCommand.TING.sCmd);
  CommandConf.WriteInteger('Permission', 'TING',
    g_GameCommand.TING.nPermissionMin);
  CommandConf.WriteString('Command', 'SUPERTING', g_GameCommand.SUPERTING.sCmd);
  CommandConf.WriteInteger('Permission', 'SUPERTING',
    g_GameCommand.SUPERTING.nPermissionMin);
  CommandConf.WriteString('Command', 'MAPMOVE', g_GameCommand.MAPMOVE.sCmd);
  CommandConf.WriteInteger('Permission', 'MAPMOVE',
    g_GameCommand.MAPMOVE.nPermissionMin);
  CommandConf.WriteString('Command', 'INFO', g_GameCommand.INFO.sCmd);
  CommandConf.WriteInteger('Permission', 'INFO',
    g_GameCommand.INFO.nPermissionMin);
  CommandConf.WriteString('Command', 'HUMANLOCAL',
    g_GameCommand.HUMANLOCAL.sCmd);
  CommandConf.WriteInteger('Permission', 'HUMANLOCAL',
    g_GameCommand.HUMANLOCAL.nPermissionMin);
  CommandConf.WriteString('Command', 'VIEWWHISPER',
    g_GameCommand.VIEWWHISPER.sCmd);
  CommandConf.WriteInteger('Permission', 'VIEWWHISPER',
    g_GameCommand.VIEWWHISPER.nPermissionMin);
  CommandConf.WriteString('Command', 'MOBLEVEL', g_GameCommand.MOBLEVEL.sCmd);
  CommandConf.WriteInteger('Permission', 'MOBLEVEL',
    g_GameCommand.MOBLEVEL.nPermissionMin);
  CommandConf.WriteString('Command', 'MOBCOUNT', g_GameCommand.MOBCOUNT.sCmd);
  CommandConf.WriteInteger('Permission', 'MOBCOUNT',
    g_GameCommand.MOBCOUNT.nPermissionMin);
  CommandConf.WriteString('Command', 'HUMANCOUNT',
    g_GameCommand.HUMANCOUNT.sCmd);
  CommandConf.WriteInteger('Permission', 'HUMANCOUNT',
    g_GameCommand.HUMANCOUNT.nPermissionMin);
  CommandConf.WriteString('Command', 'Map', g_GameCommand.Map.sCmd);
  CommandConf.WriteInteger('Permission', 'Map',
    g_GameCommand.Map.nPermissionMin);
  CommandConf.WriteString('Command', 'Level', g_GameCommand.Level.sCmd);
  CommandConf.WriteInteger('Permission', 'Level',
    g_GameCommand.Level.nPermissionMin);
  CommandConf.WriteString('Command', 'KICK', g_GameCommand.KICK.sCmd);
  CommandConf.WriteInteger('Permission', 'KICK',
    g_GameCommand.KICK.nPermissionMin);
  CommandConf.WriteString('Command', 'ReAlive', g_GameCommand.ReAlive.sCmd);
  CommandConf.WriteInteger('Permission', 'ReAlive',
    g_GameCommand.ReAlive.nPermissionMin);
  CommandConf.WriteString('Command', 'KILL', g_GameCommand.KILL.sCmd);
  CommandConf.WriteInteger('Permission', 'KILL',
    g_GameCommand.KILL.nPermissionMin);
  CommandConf.WriteString('Command', 'CHANGEJOB', g_GameCommand.CHANGEJOB.sCmd);
  CommandConf.WriteInteger('Permission', 'CHANGEJOB',
    g_GameCommand.CHANGEJOB.nPermissionMin);
  CommandConf.WriteString('Command', 'FREEPENALTY',
    g_GameCommand.FREEPENALTY.sCmd);
  CommandConf.WriteInteger('Permission', 'FREEPENALTY',
    g_GameCommand.FREEPENALTY.nPermissionMin);
  CommandConf.WriteString('Command', 'PKPOINT', g_GameCommand.PKPOINT.sCmd);
  CommandConf.WriteInteger('Permission', 'PKPOINT',
    g_GameCommand.PKPOINT.nPermissionMin);
  CommandConf.WriteString('Command', 'IncPkPoint',
    g_GameCommand.IncPkPoint.sCmd);
  CommandConf.WriteInteger('Permission', 'IncPkPoint',
    g_GameCommand.IncPkPoint.nPermissionMin);
  CommandConf.WriteString('Command', 'CHANGEGENDER',
    g_GameCommand.CHANGEGENDER.sCmd);
  CommandConf.WriteInteger('Permission', 'CHANGEGENDER',
    g_GameCommand.CHANGEGENDER.nPermissionMin);
  CommandConf.WriteString('Command', 'HAIR', g_GameCommand.HAIR.sCmd);
  CommandConf.WriteInteger('Permission', 'HAIR',
    g_GameCommand.HAIR.nPermissionMin);
  CommandConf.WriteString('Command', 'BonusPoint',
    g_GameCommand.BonusPoint.sCmd);
  CommandConf.WriteInteger('Permission', 'BonusPoint',
    g_GameCommand.BonusPoint.nPermissionMin);
  CommandConf.WriteString('Command', 'DELBONUSPOINT',
    g_GameCommand.DELBONUSPOINT.sCmd);
  CommandConf.WriteInteger('Permission', 'DELBONUSPOINT',
    g_GameCommand.DELBONUSPOINT.nPermissionMin);
  CommandConf.WriteString('Command', 'RESTBONUSPOINT',
    g_GameCommand.RESTBONUSPOINT.sCmd);
  CommandConf.WriteInteger('Permission', 'RESTBONUSPOINT',
    g_GameCommand.RESTBONUSPOINT.nPermissionMin);
  CommandConf.WriteString('Command', 'SETPERMISSION',
    g_GameCommand.SETPERMISSION.sCmd);
  CommandConf.WriteInteger('Permission', 'SETPERMISSION',
    g_GameCommand.SETPERMISSION.nPermissionMin);
  CommandConf.WriteString('Command', 'RENEWLEVEL',
    g_GameCommand.RENEWLEVEL.sCmd);
  CommandConf.WriteInteger('Permission', 'RENEWLEVEL',
    g_GameCommand.RENEWLEVEL.nPermissionMin);
  CommandConf.WriteString('Command', 'DELGOLD', g_GameCommand.DELGOLD.sCmd);
  CommandConf.WriteInteger('Permission', 'DELGOLD',
    g_GameCommand.DELGOLD.nPermissionMin);
  CommandConf.WriteString('Command', 'ADDGOLD', g_GameCommand.ADDGOLD.sCmd);
  CommandConf.WriteInteger('Permission', 'ADDGOLD',
    g_GameCommand.ADDGOLD.nPermissionMin);
  CommandConf.WriteString('Command', 'GAMEGOLD', g_GameCommand.GAMEGOLD.sCmd);
  CommandConf.WriteInteger('Permission', 'GAMEGOLD',
    g_GameCommand.GAMEGOLD.nPermissionMin);
  CommandConf.WriteString('Command', 'GAMEPOINT', g_GameCommand.GAMEPOINT.sCmd);
  CommandConf.WriteInteger('Permission', 'GAMEPOINT',
    g_GameCommand.GAMEPOINT.nPermissionMin);
  CommandConf.WriteString('Command', 'CREDITPOINT',
    g_GameCommand.CREDITPOINT.sCmd);
  CommandConf.WriteInteger('Permission', 'CREDITPOINT',
    g_GameCommand.CREDITPOINT.nPermissionMin);
  CommandConf.WriteString('Command', 'REFINEWEAPON',
    g_GameCommand.REFINEWEAPON.sCmd);
  CommandConf.WriteInteger('Permission', 'REFINEWEAPON',
    g_GameCommand.REFINEWEAPON.nPermissionMin);
  CommandConf.WriteString('Command', 'ADJUESTLEVEL',
    g_GameCommand.ADJUESTLEVEL.sCmd);
  CommandConf.WriteInteger('Permission', 'ADJUESTLEVEL',
    g_GameCommand.ADJUESTLEVEL.nPermissionMin);
  CommandConf.WriteString('Command', 'ADJUESTEXP',
    g_GameCommand.ADJUESTEXP.sCmd);
  CommandConf.WriteInteger('Permission', 'ADJUESTEXP',
    g_GameCommand.ADJUESTEXP.nPermissionMin);
  CommandConf.WriteString('Command', 'CHANGEDEARNAME',
    g_GameCommand.CHANGEDEARNAME.sCmd);
  CommandConf.WriteInteger('Permission', 'CHANGEDEARNAME',
    g_GameCommand.CHANGEDEARNAME.nPermissionMin);
  CommandConf.WriteString('Command', 'CHANGEMASTERNAME',
    g_GameCommand.CHANGEMASTERNAME.sCmd);
  CommandConf.WriteInteger('Permission', 'CHANGEMASTERNAME',
    g_GameCommand.CHANGEMASTERNAME.nPermissionMin);
  CommandConf.WriteString('Command', 'RECALLMOB', g_GameCommand.RECALLMOB.sCmd);
  CommandConf.WriteInteger('Permission', 'RECALLMOB',
    g_GameCommand.RECALLMOB.nPermissionMin);
  CommandConf.WriteString('Command', 'TRAINING', g_GameCommand.TRAINING.sCmd);
  CommandConf.WriteInteger('Permission', 'TRAINING',
    g_GameCommand.TRAINING.nPermissionMin);
  CommandConf.WriteString('Command', 'TRAININGSKILL',
    g_GameCommand.TRAININGSKILL.sCmd);
  CommandConf.WriteInteger('Permission', 'TRAININGSKILL',
    g_GameCommand.TRAININGSKILL.nPermissionMin);
  CommandConf.WriteString('Command', 'DELETESKILL',
    g_GameCommand.DELETESKILL.sCmd);
  CommandConf.WriteInteger('Permission', 'DELETESKILL',
    g_GameCommand.DELETESKILL.nPermissionMin);
  CommandConf.WriteString('Command', 'DELETEITEM',
    g_GameCommand.DELETEITEM.sCmd);
  CommandConf.WriteInteger('Permission', 'DELETEITEM',
    g_GameCommand.DELETEITEM.nPermissionMin);
  CommandConf.WriteString('Command', 'CLEARMISSION',
    g_GameCommand.CLEARMISSION.sCmd);
  CommandConf.WriteInteger('Permission', 'CLEARMISSION',
    g_GameCommand.CLEARMISSION.nPermissionMin);
  CommandConf.WriteString('Command', 'AddGuild', g_GameCommand.AddGuild.sCmd);
  CommandConf.WriteInteger('Permission', 'AddGuild',
    g_GameCommand.AddGuild.nPermissionMin);
  CommandConf.WriteString('Command', 'DELGUILD', g_GameCommand.DELGUILD.sCmd);
  CommandConf.WriteInteger('Permission', 'DELGUILD',
    g_GameCommand.DELGUILD.nPermissionMin);
  CommandConf.WriteString('Command', 'CHANGESABUKLORD',
    g_GameCommand.CHANGESABUKLORD.sCmd);
  CommandConf.WriteInteger('Permission', 'CHANGESABUKLORD',
    g_GameCommand.CHANGESABUKLORD.nPermissionMin);
  CommandConf.WriteString('Command', 'FORCEDWALLCONQUESTWAR',
    g_GameCommand.FORCEDWALLCONQUESTWAR.sCmd);
  CommandConf.WriteInteger('Permission', 'FORCEDWALLCONQUESTWAR',
    g_GameCommand.FORCEDWALLCONQUESTWAR.nPermissionMin);
  CommandConf.WriteString('Command', 'CONTESTPOINT',
    g_GameCommand.CONTESTPOINT.sCmd);
  CommandConf.WriteInteger('Permission', 'CONTESTPOINT',
    g_GameCommand.CONTESTPOINT.nPermissionMin);
  CommandConf.WriteString('Command', 'STARTCONTEST',
    g_GameCommand.STARTCONTEST.sCmd);
  CommandConf.WriteInteger('Permission', 'STARTCONTEST',
    g_GameCommand.STARTCONTEST.nPermissionMin);
  CommandConf.WriteString('Command', 'ENDCONTEST',
    g_GameCommand.ENDCONTEST.sCmd);
  CommandConf.WriteInteger('Permission', 'ENDCONTEST',
    g_GameCommand.ENDCONTEST.nPermissionMin);
  CommandConf.WriteString('Command', 'ANNOUNCEMENT',
    g_GameCommand.ANNOUNCEMENT.sCmd);
  CommandConf.WriteInteger('Permission', 'ANNOUNCEMENT',
    g_GameCommand.ANNOUNCEMENT.nPermissionMin);
  CommandConf.WriteString('Command', 'MOB', g_GameCommand.MOB.sCmd);
  CommandConf.WriteInteger('Permission', 'MOB',
    g_GameCommand.MOB.nPermissionMin);
  CommandConf.WriteString('Command', 'Mission', g_GameCommand.Mission.sCmd);
  CommandConf.WriteInteger('Permission', 'Mission',
    g_GameCommand.Mission.nPermissionMin);
  CommandConf.WriteString('Command', 'MobPlace', g_GameCommand.MobPlace.sCmd);
  CommandConf.WriteInteger('Permission', 'MobPlace',
    g_GameCommand.MobPlace.nPermissionMin);
  CommandConf.WriteString('Command', 'CLEARMON', g_GameCommand.CLEARMON.sCmd);
  CommandConf.WriteInteger('Permission', 'CLEARMON',
    g_GameCommand.CLEARMON.nPermissionMin);
  CommandConf.WriteString('Command', 'DISABLESENDMSG',
    g_GameCommand.DISABLESENDMSG.sCmd);
  CommandConf.WriteInteger('Permission', 'DISABLESENDMSG',
    g_GameCommand.DISABLESENDMSG.nPermissionMin);
  CommandConf.WriteString('Command', 'ENABLESENDMSG',
    g_GameCommand.ENABLESENDMSG.sCmd);
  CommandConf.WriteInteger('Permission', 'ENABLESENDMSG',
    g_GameCommand.ENABLESENDMSG.nPermissionMin);
  CommandConf.WriteString('Command', 'DISABLESENDMSGLIST',
    g_GameCommand.DISABLESENDMSGLIST.sCmd);
  CommandConf.WriteInteger('Permission', 'DISABLESENDMSGLIST',
    g_GameCommand.DISABLESENDMSGLIST.nPermissionMin);
  CommandConf.WriteString('Command', 'SHUTUP', g_GameCommand.SHUTUP.sCmd);
  CommandConf.WriteInteger('Permission', 'SHUTUP',
    g_GameCommand.SHUTUP.nPermissionMin);
  CommandConf.WriteString('Command', 'RELEASESHUTUP',
    g_GameCommand.RELEASESHUTUP.sCmd);
  CommandConf.WriteInteger('Permission', 'RELEASESHUTUP',
    g_GameCommand.RELEASESHUTUP.nPermissionMin);
  CommandConf.WriteString('Command', 'SHUTUPLIST',
    g_GameCommand.SHUTUPLIST.sCmd);
  CommandConf.WriteInteger('Permission', 'SHUTUPLIST',
    g_GameCommand.SHUTUPLIST.nPermissionMin);
  CommandConf.WriteString('Command', 'SABUKWALLGOLD',
    g_GameCommand.SABUKWALLGOLD.sCmd);
  CommandConf.WriteInteger('Permission', 'SABUKWALLGOLD',
    g_GameCommand.SABUKWALLGOLD.nPermissionMin);
  CommandConf.WriteString('Command', 'STARTQUEST',
    g_GameCommand.STARTQUEST.sCmd);
  CommandConf.WriteInteger('Permission', 'STARTQUEST',
    g_GameCommand.STARTQUEST.nPermissionMin);
  CommandConf.WriteString('Command', 'DENYIPLOGON',
    g_GameCommand.DENYIPLOGON.sCmd);
  CommandConf.WriteInteger('Permission', 'DENYIPLOGON',
    g_GameCommand.DENYIPLOGON.nPermissionMin);
  CommandConf.WriteString('Command', 'DENYACCOUNTLOGON',
    g_GameCommand.DENYACCOUNTLOGON.sCmd);
  CommandConf.WriteInteger('Permission', 'DENYACCOUNTLOGON',
    g_GameCommand.DENYACCOUNTLOGON.nPermissionMin);
  CommandConf.WriteString('Command', 'DENYCHARNAMELOGON',
    g_GameCommand.DENYCHARNAMELOGON.sCmd);
  CommandConf.WriteInteger('Permission', 'DENYCHARNAMELOGON',
    g_GameCommand.DENYCHARNAMELOGON.nPermissionMin);
  CommandConf.WriteString('Command', 'DELDENYIPLOGON',
    g_GameCommand.DELDENYIPLOGON.sCmd);
  CommandConf.WriteInteger('Permission', 'DELDENYIPLOGON',
    g_GameCommand.DELDENYIPLOGON.nPermissionMin);
  CommandConf.WriteString('Command', 'DELDENYACCOUNTLOGON',
    g_GameCommand.DELDENYACCOUNTLOGON.sCmd);
  CommandConf.WriteInteger('Permission', 'DELDENYACCOUNTLOGON',
    g_GameCommand.DELDENYACCOUNTLOGON.nPermissionMin);
  CommandConf.WriteString('Command', 'DELDENYCHARNAMELOGON',
    g_GameCommand.DELDENYCHARNAMELOGON.sCmd);
  CommandConf.WriteInteger('Permission', 'DELDENYCHARNAMELOGON',
    g_GameCommand.DELDENYCHARNAMELOGON.nPermissionMin);
  CommandConf.WriteString('Command', 'SHOWDENYIPLOGON',
    g_GameCommand.SHOWDENYIPLOGON.sCmd);
  CommandConf.WriteInteger('Permission', 'SHOWDENYIPLOGON',
    g_GameCommand.SHOWDENYIPLOGON.nPermissionMin);
  CommandConf.WriteString('Command', 'SHOWDENYACCOUNTLOGON',
    g_GameCommand.SHOWDENYACCOUNTLOGON.sCmd);
  CommandConf.WriteInteger('Permission', 'SHOWDENYACCOUNTLOGON',
    g_GameCommand.SHOWDENYACCOUNTLOGON.nPermissionMin);
  CommandConf.WriteString('Command', 'SHOWDENYCHARNAMELOGON',
    g_GameCommand.SHOWDENYCHARNAMELOGON.sCmd);
  CommandConf.WriteInteger('Permission', 'SHOWDENYCHARNAMELOGON',
    g_GameCommand.SHOWDENYCHARNAMELOGON.nPermissionMin);
  CommandConf.WriteString('Command', 'SETMAPMODE',
    g_GameCommand.SETMAPMODE.sCmd);
  CommandConf.WriteInteger('Permission', 'SETMAPMODE',
    g_GameCommand.SETMAPMODE.nPermissionMin);
  CommandConf.WriteString('Command', 'SHOWMAPMODE',
    g_GameCommand.SHOWMAPMODE.sCmd);
  CommandConf.WriteInteger('Permission', 'SHOWMAPMODE',
    g_GameCommand.SHOWMAPMODE.nPermissionMin);
  CommandConf.WriteString('Command', 'Attack', g_GameCommand.Attack.sCmd);
  CommandConf.WriteInteger('Permission', 'Attack',
    g_GameCommand.Attack.nPermissionMin);
  CommandConf.WriteString('Command', 'LUCKYPOINT',
    g_GameCommand.LUCKYPOINT.sCmd);
  CommandConf.WriteInteger('Permission', 'LUCKYPOINT',
    g_GameCommand.LUCKYPOINT.nPermissionMin);
  CommandConf.WriteString('Command', 'CHANGELUCK',
    g_GameCommand.CHANGELUCK.sCmd);
  CommandConf.WriteInteger('Permission', 'CHANGELUCK',
    g_GameCommand.CHANGELUCK.nPermissionMin);
  CommandConf.WriteString('Command', 'HUNGER', g_GameCommand.HUNGER.sCmd);
  CommandConf.WriteInteger('Permission', 'HUNGER',
    g_GameCommand.HUNGER.nPermissionMin);
  CommandConf.WriteString('Command', 'NAMECOLOR', g_GameCommand.NAMECOLOR.sCmd);
  CommandConf.WriteInteger('Permission', 'NAMECOLOR',
    g_GameCommand.NAMECOLOR.nPermissionMin);
  CommandConf.WriteString('Command', 'TRANSPARECY',
    g_GameCommand.TRANSPARECY.sCmd);
  CommandConf.WriteInteger('Permission', 'TRANSPARECY',
    g_GameCommand.TRANSPARECY.nPermissionMin);
  CommandConf.WriteString('Command', 'LEVEL0', g_GameCommand.LEVEL0.sCmd);
  CommandConf.WriteInteger('Permission', 'LEVEL0',
    g_GameCommand.LEVEL0.nPermissionMin);
  CommandConf.WriteString('Command', 'CHANGEITEMNAME',
    g_GameCommand.CHANGEITEMNAME.sCmd);
  CommandConf.WriteInteger('Permission', 'CHANGEITEMNAME',
    g_GameCommand.CHANGEITEMNAME.nPermissionMin);
  CommandConf.WriteString('Command', 'ADDTOITEMEVENT',
    g_GameCommand.ADDTOITEMEVENT.sCmd);
  CommandConf.WriteInteger('Permission', 'ADDTOITEMEVENT',
    g_GameCommand.ADDTOITEMEVENT.nPermissionMin);
  CommandConf.WriteString('Command', 'ADDTOITEMEVENTASPIECES',
    g_GameCommand.ADDTOITEMEVENTASPIECES.sCmd);
  CommandConf.WriteInteger('Permission', 'ADDTOITEMEVENTASPIECES',
    g_GameCommand.ADDTOITEMEVENTASPIECES.nPermissionMin);
  CommandConf.WriteString('Command', 'ItemEventList',
    g_GameCommand.ItemEventList.sCmd);
  CommandConf.WriteInteger('Permission', 'ItemEventList',
    g_GameCommand.ItemEventList.nPermissionMin);
  CommandConf.WriteString('Command', 'STARTINGGIFTNO',
    g_GameCommand.STARTINGGIFTNO.sCmd);
  CommandConf.WriteInteger('Permission', 'STARTINGGIFTNO',
    g_GameCommand.STARTINGGIFTNO.nPermissionMin);
  CommandConf.WriteString('Command', 'DELETEALLITEMEVENT',
    g_GameCommand.DELETEALLITEMEVENT.sCmd);
  CommandConf.WriteInteger('Permission', 'DELETEALLITEMEVENT',
    g_GameCommand.DELETEALLITEMEVENT.nPermissionMin);
  CommandConf.WriteString('Command', 'STARTITEMEVENT',
    g_GameCommand.STARTITEMEVENT.sCmd);
  CommandConf.WriteInteger('Permission', 'STARTITEMEVENT',
    g_GameCommand.STARTITEMEVENT.nPermissionMin);
  CommandConf.WriteString('Command', 'ITEMEVENTTERM',
    g_GameCommand.ITEMEVENTTERM.sCmd);
  CommandConf.WriteInteger('Permission', 'ITEMEVENTTERM',
    g_GameCommand.ITEMEVENTTERM.nPermissionMin);
  CommandConf.WriteString('Command', 'OPDELETESKILL',
    g_GameCommand.OPDELETESKILL.sCmd);
  CommandConf.WriteInteger('Permission', 'OPDELETESKILL',
    g_GameCommand.OPDELETESKILL.nPermissionMin);
  CommandConf.WriteString('Command', 'CHANGEWEAPONDURA',
    g_GameCommand.CHANGEWEAPONDURA.sCmd);
  CommandConf.WriteInteger('Permission', 'CHANGEWEAPONDURA',
    g_GameCommand.CHANGEWEAPONDURA.nPermissionMin);
  CommandConf.WriteString('Command', 'SBKDOOR', g_GameCommand.SBKDOOR.sCmd);
  CommandConf.WriteInteger('Permission', 'SBKDOOR',
    g_GameCommand.SBKDOOR.nPermissionMin);
  CommandConf.WriteString('Command', 'SPIRIT', g_GameCommand.SPIRIT.sCmd);
  CommandConf.WriteInteger('Permission', 'SPIRIT',
    g_GameCommand.SPIRIT.nPermissionMin);
  CommandConf.WriteString('Command', 'SPIRITSTOP',
    g_GameCommand.SPIRITSTOP.sCmd);
  CommandConf.WriteInteger('Permission', 'SPIRITSTOP',
    g_GameCommand.SPIRITSTOP.nPermissionMin);

end;

procedure TfrmGameCmd.StringGridGameDebugCmdClick(Sender: TObject);
var
  nIndex: Integer;
  GameCmd: pTGameCmd;
begin
  nIndex := StringGridGameDebugCmd.Row;
  GameCmd := pTGameCmd(StringGridGameDebugCmd.Objects[0, nIndex]);
  if GameCmd <> nil then begin
    EditGameDebugCmdName.Text := GameCmd.sCmd;
    EditGameDebugCmdPerMission.Value := GameCmd.nPermissionMin;
    LabelGameDebugCmdParam.Caption := StringGridGameDebugCmd.Cells[2, nIndex];
    LabelGameDebugCmdFunc.Caption := StringGridGameDebugCmd.Cells[3, nIndex];
  end;
  EditGameDebugCmdOK.Enabled := False;
end;

procedure TfrmGameCmd.EditGameDebugCmdNameChange(Sender: TObject);
begin
  EditGameDebugCmdOK.Enabled := True;
  EditGameDebugCmdSave.Enabled := True;
end;

procedure TfrmGameCmd.EditGameDebugCmdPerMissionChange(Sender: TObject);
begin
  EditGameDebugCmdOK.Enabled := True;
  EditGameDebugCmdSave.Enabled := True;
end;

procedure TfrmGameCmd.EditGameDebugCmdOKClick(Sender: TObject);
var
  nIndex: Integer;
  GameCmd: pTGameCmd;
  sCmd: string;
  nPermission: Integer;
begin
  sCmd := Trim(EditGameDebugCmdName.Text);
  nPermission := EditGameDebugCmdPerMission.Value;
  if sCmd = '' then begin
    Application.MessageBox('Invalid debug permission.','Error',
      MB_OK +
      MB_ICONERROR);
    EditGameDebugCmdName.SetFocus;
    exit;
  end;

  nIndex := StringGridGameDebugCmd.Row;
  GameCmd := pTGameCmd(StringGridGameDebugCmd.Objects[0, nIndex]);
  if GameCmd <> nil then begin
    GameCmd.sCmd := sCmd;
    GameCmd.nPermissionMin := nPermission;
  end;
  RefDebugCommand();
end;

procedure TfrmGameCmd.EditGameDebugCmdSaveClick(Sender: TObject);
begin
  EditGameDebugCmdSave.Enabled := False;
  CommandConf.WriteString('Command', 'SHOWFLAG', g_GameCommand.SHOWFLAG.sCmd);
  CommandConf.WriteString('Command', 'SETFLAG', g_GameCommand.SETFLAG.sCmd);
  CommandConf.WriteString('Command', 'SHOWOPEN', g_GameCommand.SHOWOPEN.sCmd);
  CommandConf.WriteString('Command', 'SETOPEN', g_GameCommand.SETOPEN.sCmd);
  CommandConf.WriteString('Command', 'SHOWUNIT', g_GameCommand.SHOWUNIT.sCmd);
  CommandConf.WriteString('Command', 'SETUNIT', g_GameCommand.SETUNIT.sCmd);
  CommandConf.WriteString('Command', 'MOBNPC', g_GameCommand.MOBNPC.sCmd);
  CommandConf.WriteString('Command', 'DELNPC', g_GameCommand.DELNPC.sCmd);
  CommandConf.WriteString('Command', 'LOTTERYTICKET',
    g_GameCommand.LOTTERYTICKET.sCmd);
  CommandConf.WriteString('Command', 'RELOADADMIN',
    g_GameCommand.RELOADADMIN.sCmd);
  CommandConf.WriteString('Command', 'ReLoadNpc', g_GameCommand.ReLoadNpc.sCmd);
  CommandConf.WriteString('Command', 'RELOADMANAGE',
    g_GameCommand.RELOADMANAGE.sCmd);
  CommandConf.WriteString('Command', 'RELOADROBOTMANAGE',
    g_GameCommand.RELOADROBOTMANAGE.sCmd);
  CommandConf.WriteString('Command', 'RELOADROBOT',
    g_GameCommand.RELOADROBOT.sCmd);
  CommandConf.WriteString('Command', 'RELOADMONITEMS',
    g_GameCommand.RELOADMONITEMS.sCmd);
  CommandConf.WriteString('Command', 'RELOADDIARY',
    g_GameCommand.RELOADDIARY.sCmd);
  CommandConf.WriteString('Command', 'RELOADITEMDB',
    g_GameCommand.RELOADITEMDB.sCmd);
  CommandConf.WriteString('Command', 'RELOADMAGICDB',
    g_GameCommand.RELOADMAGICDB.sCmd);
  CommandConf.WriteString('Command', 'RELOADMONSTERDB',
    g_GameCommand.RELOADMONSTERDB.sCmd);
  CommandConf.WriteString('Command', 'RELOADMINMAP',
    g_GameCommand.RELOADMINMAP.sCmd);
  CommandConf.WriteString('Command', 'RELOADGUILD',
    g_GameCommand.RELOADGUILD.sCmd);
  CommandConf.WriteString('Command', 'RELOADGUILDALL',
    g_GameCommand.RELOADGUILDALL.sCmd);
  CommandConf.WriteString('Command', 'RELOADLINENOTICE',
    g_GameCommand.RELOADLINENOTICE.sCmd);
  CommandConf.WriteString('Command', 'RELOADABUSE',
    g_GameCommand.RELOADABUSE.sCmd);
  CommandConf.WriteString('Command', 'BACKSTEP', g_GameCommand.BACKSTEP.sCmd);
  CommandConf.WriteString('Command', 'RECONNECTION',
    g_GameCommand.RECONNECTION.sCmd);
  CommandConf.WriteString('Command', 'DISABLEFILTER',
    g_GameCommand.DISABLEFILTER.sCmd);
  CommandConf.WriteString('Command', 'CHGUSERFULL',
    g_GameCommand.CHGUSERFULL.sCmd);
  CommandConf.WriteString('Command', 'CHGZENFASTSTEP',
    g_GameCommand.CHGZENFASTSTEP.sCmd);
  CommandConf.WriteString('Command', 'OXQUIZROOM',
    g_GameCommand.OXQUIZROOM.sCmd);
  CommandConf.WriteString('Command', 'BALL', g_GameCommand.BALL.sCmd);
  CommandConf.WriteString('Command', 'FIREBURN', g_GameCommand.FIREBURN.sCmd);
  CommandConf.WriteString('Command', 'TESTFIRE', g_GameCommand.TESTFIRE.sCmd);
  CommandConf.WriteString('Command', 'TESTSTATUS',
    g_GameCommand.TESTSTATUS.sCmd);
  CommandConf.WriteString('Command', 'TESTGOLDCHANGE',
    g_GameCommand.TESTGOLDCHANGE.sCmd);
  CommandConf.WriteString('Command', 'GSA', g_GameCommand.GSA.sCmd);
  CommandConf.WriteString('Command', 'TESTGA', g_GameCommand.TESTGA.sCmd);
  CommandConf.WriteString('Command', 'MAPINFO', g_GameCommand.MAPINFO.sCmd);
  CommandConf.WriteString('Command', 'CLEARBAG', g_GameCommand.CLEARBAG.sCmd);

end;

end.

