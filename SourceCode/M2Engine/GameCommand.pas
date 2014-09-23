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
  StringGridGameCmd.RowCount := 2;
  StringGridGameCmd.Cells[0, 0] := '游戏命令';
  StringGridGameCmd.Cells[1, 0] := '所需权限';
  StringGridGameCmd.Cells[2, 0] := '命令格式';
  StringGridGameCmd.Cells[3, 0] := '命令说明';

  StringGridGameMasterCmd.RowCount := 2;
  StringGridGameMasterCmd.Cells[0, 0] := '游戏命令';
  StringGridGameMasterCmd.Cells[1, 0] := '所需权限';
  StringGridGameMasterCmd.Cells[2, 0] := '命令格式';
  StringGridGameMasterCmd.Cells[3, 0] := '命令说明';

  StringGridGameDebugCmd.RowCount := 2;
  StringGridGameDebugCmd.Cells[0, 0] := '游戏命令';
  StringGridGameDebugCmd.Cells[1, 0] := '所需权限';
  StringGridGameDebugCmd.Cells[2, 0] := '命令格式';
  StringGridGameDebugCmd.Cells[3, 0] := '命令说明';

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
    '查看当前服务器日期时间');
  RefGameUserCmd(@g_GameCommand.PRVMSG,
    '@' + g_GameCommand.PRVMSG.sCmd,
    '禁止指定人物发的私聊信息');
  RefGameUserCmd(@g_GameCommand.ALLOWMSG,
    '@' + g_GameCommand.ALLOWMSG.sCmd,
    '禁止别人向自己发私聊信息');
  RefGameUserCmd(@g_GameCommand.LETSHOUT,
    '@' + g_GameCommand.LETSHOUT.sCmd,
    '禁止接收组队聊天信息');
  RefGameUserCmd(@g_GameCommand.LETTRADE,
    '@' + g_GameCommand.LETTRADE.sCmd,
    '禁止交易交易物品');
  RefGameUserCmd(@g_GameCommand.LETGUILD,
    '@' + g_GameCommand.LETGUILD.sCmd,
    '允许加入行会');
  RefGameUserCmd(@g_GameCommand.ENDGUILD,
    '@' + g_GameCommand.ENDGUILD.sCmd,
    '退出当前所加入的行会');
  RefGameUserCmd(@g_GameCommand.BANGUILDCHAT,
    '@' + g_GameCommand.BANGUILDCHAT.sCmd,
    '禁止接收行会聊天信息');
  RefGameUserCmd(@g_GameCommand.AUTHALLY,
    '@' + g_GameCommand.AUTHALLY.sCmd,
    '许行会进入联盟');
  RefGameUserCmd(@g_GameCommand.AUTH,
    '@' + g_GameCommand.AUTH.sCmd,
    '开始进行行会联盟');
  RefGameUserCmd(@g_GameCommand.AUTHCANCEL,
    '@' + g_GameCommand.AUTHCANCEL.sCmd,
    '取消行会联盟关系');
  RefGameUserCmd(@g_GameCommand.USERMOVE,
    '@' + g_GameCommand.USERMOVE.sCmd,
    '移动地图指定座标(需要戴传送装备)');
  RefGameUserCmd(@g_GameCommand.SEARCHING,
    '@' + g_GameCommand.SEARCHING.sCmd,
    '探测人物所在位置(需要戴探测装备)');
  RefGameUserCmd(@g_GameCommand.ALLOWGROUPCALL,
    '@' + g_GameCommand.ALLOWGROUPCALL.sCmd,
    '允许天地合一');
  RefGameUserCmd(@g_GameCommand.GROUPRECALLL,
    '@' + g_GameCommand.GROUPRECALLL.sCmd,
    '将组队人员传送到身边(需要戴记忆全套装备)');
  RefGameUserCmd(@g_GameCommand.ALLOWGUILDRECALL,
    '@' + g_GameCommand.ALLOWGUILDRECALL.sCmd,
    '允许行会合一');
  RefGameUserCmd(@g_GameCommand.GUILDRECALLL,
    '@' + g_GameCommand.GUILDRECALLL.sCmd,
    '将行会成员传送身边(需要戴行会传送装备)');
  RefGameUserCmd(@g_GameCommand.ALLOWFIREND,
    '@' + g_GameCommand.ALLOWFIREND.sCmd,
    '允许/拒绝加为好友');
  {RefGameUserCmd(@g_GameCommand.UNLOCKSTORAGE,
    '@' + g_GameCommand.UNLOCKSTORAGE.sCmd,
    '仓库解锁');
  RefGameUserCmd(@g_GameCommand.UnLock,
    '@' + g_GameCommand.UnLock.sCmd,
    '开启登录密码锁');
  RefGameUserCmd(@g_GameCommand.Lock,
    '@' + g_GameCommand.Lock.sCmd,
    '锁定仓库');
  RefGameUserCmd(@g_GameCommand.SETPASSWORD,
    '@' + g_GameCommand.SETPASSWORD.sCmd,
    '设置仓库密码');
  RefGameUserCmd(@g_GameCommand.CHGPASSWORD,
    '@' + g_GameCommand.CHGPASSWORD.sCmd,
    '修改仓库密码');
  RefGameUserCmd(@g_GameCommand.UNPASSWORD,
    '@' + g_GameCommand.UNPASSWORD.sCmd,
    '清除密码(先开锁再清除密码)');    }
  RefGameUserCmd(@g_GameCommand.DEAR,
    '@' + g_GameCommand.DEAR.sCmd,
    '查询夫妻位置');
  RefGameUserCmd(@g_GameCommand.ALLOWDEARRCALL,
    '@' + g_GameCommand.ALLOWDEARRCALL.sCmd,
    '允许夫妻传送');
  RefGameUserCmd(@g_GameCommand.DEARRECALL,
    '@' + g_GameCommand.DEARRECALL.sCmd,
    '夫妻将对方传送到身边');
  RefGameUserCmd(@g_GameCommand.MASTER,
    '@' + g_GameCommand.MASTER.sCmd,
    '查询师徒位置');
  RefGameUserCmd(@g_GameCommand.ALLOWMASTERRECALL,
    '@' + g_GameCommand.ALLOWMASTERRECALL.sCmd,
    '允许师徒传送');
  RefGameUserCmd(@g_GameCommand.MASTERECALL,
    '@' + g_GameCommand.MASTERECALL.sCmd,
    '师父将徒弟召唤到身边');
  RefGameUserCmd(@g_GameCommand.TAKEONHORSE,
    '@' + g_GameCommand.TAKEONHORSE.sCmd,
    '带马牌后骑上马');
  RefGameUserCmd(@g_GameCommand.TAKEOFHORSE,
    '@' + g_GameCommand.TAKEOFHORSE.sCmd,
    '从马上下来');
  {RefGameUserCmd(@g_GameCommand.LOCKLOGON,
    '@' + g_GameCommand.LOCKLOGON.sCmd,
    '开启/关闭登录锁');   }

  RefGameUserCmd(@g_GameCommand.AllSysMsg,
    '@' + g_GameCommand.AllSysMsg.sCmd,
    '千里传音');
  RefGameUserCmd(@g_GameCommand.MEMBERFUNCTION,
    '@' + g_GameCommand.MEMBERFUNCTION.sCmd,
    '调用QManage中的@Member');
  RefGameUserCmd(@g_GameCommand.MEMBERFUNCTIONEX,
    '@' + g_GameCommand.MEMBERFUNCTIONEX.sCmd,
    '调用QFunction中的@Member');
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
    Application.MessageBox('命令名称不能为空.', '提示信息',
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

  {RefGameMasterCmd(@g_GameCommand.CLRPASSWORD,
    '@' + g_GameCommand.CLRPASSWORD.sCmd + ' 人物名称',
    '清除人物仓库/登录密码(支持权限分配)'); }

  {RefGameMasterCmd(@g_GameCommand.WHO,
    '@' + g_GameCommand.WHO.sCmd,
    '查看当前服务器在线人数(支持权限分配)');  }

  {RefGameMasterCmd(@g_GameCommand.TOTAL,
    '@' + g_GameCommand.TOTAL.sCmd,
    '查看所有服务器在线人数(支持权限分配)');    }

  RefGameMasterCmd(@g_GameCommand.GAMEMASTER,
    '@' + g_GameCommand.GAMEMASTER.sCmd,
    '进入/退出管理员模式(进入模式后不会受到任何角色攻击)(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.OBSERVER,
    '@' + g_GameCommand.OBSERVER.sCmd,
    '进入/退出隐身模式(进入模式后别人看不到自己)(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.SUEPRMAN,
    '@' + g_GameCommand.SUEPRMAN.sCmd,
    '进入/退出无敌模式(进入模式后人物不会死亡)(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.MAKE,
    '@' + g_GameCommand.MAKE.sCmd + ' 物品名称 数量',
    '制造指定物品(支持权限分配，小于最大权限受允许、禁止制造列表限制)');

  RefGameMasterCmd(@g_GameCommand.SMAKE,
    '@' + g_GameCommand.SMAKE.sCmd + ' 参数详见使用说明',
    '调整自己身上的物品属性(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.Move,
    '@' + g_GameCommand.Move.sCmd + ' 地图号',
    '移动到指定地图(支持权限分配，小于最大权限受受禁止传送地图列表限制)');

  RefGameMasterCmd(@g_GameCommand.POSITIONMOVE,
    '@' + g_GameCommand.POSITIONMOVE.sCmd + ' 地图号 X Y',
    '移动到指定地图(支持权限分配，小于最大权限受受禁止传送地图列表限制)');

  RefGameMasterCmd(@g_GameCommand.RECALL,
    '@' + g_GameCommand.RECALL.sCmd + ' 人物名称',
    '将指定人物召唤到身边(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.REGOTO,
    '@' + g_GameCommand.REGOTO.sCmd + ' 人物名称',
    '跟踪指定人物(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.TING,
    '@' + g_GameCommand.TING.sCmd + ' 人物名称',
    '将指定人物随机传送(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.SUPERTING,
    '@' + g_GameCommand.SUPERTING.sCmd + ' 人物名称 范围大小',
    '将指定人物身边指定范围内的人物随机传送(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.MAPMOVE,
    '@' + g_GameCommand.MAPMOVE.sCmd + ' 源地图号 目标地图号',
    '将整个地图中的人物移动到其它地图中(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.INFO,
    '@' + g_GameCommand.INFO.sCmd + ' 人物名称',
    '看人物信息(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.HUMANLOCAL,
    '@' + g_GameCommand.HUMANLOCAL.sCmd + ' 地图号',
    '查询人物IP所在地区(需加载IP地区查询插件)(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.VIEWWHISPER,
    '@' + g_GameCommand.VIEWWHISPER.sCmd + ' 人物名称',
    '查看指定人物的私聊信息(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.MOBLEVEL,
    '@' + g_GameCommand.MOBLEVEL.sCmd,
    '查看身边角色信息(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.MOBCOUNT,
    '@' + g_GameCommand.MOBCOUNT.sCmd + ' 地图号',
    '查看地图中怪物数量(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.HUMANCOUNT,
    '@' + g_GameCommand.HUMANCOUNT.sCmd,
    '查看身边人数(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.Map,
    '@' + g_GameCommand.Map.sCmd,
    '显示当前所在地图相关信息(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.Level,
    '@' + g_GameCommand.Level.sCmd,
    '调整自己的等级(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.KICK,
    '@' + g_GameCommand.KICK.sCmd + ' 人物名称',
    '将指定人物踢下线(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.ReAlive,
    '@' + g_GameCommand.ReAlive.sCmd + ' 人物名称',
    '将指定人物复活(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.KILL,
    '@' + g_GameCommand.KILL.sCmd + '人物名称',
    '将指定人物或怪物杀死(杀怪物时需面对怪物)(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.CHANGEJOB,
    '@' + g_GameCommand.CHANGEJOB.sCmd +
    ' 人物名称 职业类型(Warr Wizard Taos)',
    '调整人物的职业(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.FREEPENALTY,
    '@' + g_GameCommand.FREEPENALTY.sCmd + ' 人物名称',
    '清除指定人物的PK值(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.PKPOINT,
    '@' + g_GameCommand.PKPOINT.sCmd + ' 人物名称',
    '查看指定人物的PK值(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.IncPkPoint,
    '@' + g_GameCommand.IncPkPoint.sCmd + ' 人物名称 点数',
    '增加指定人物的PK值(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.CHANGEGENDER,
    '@' + g_GameCommand.CHANGEGENDER.sCmd + ' 人物名称 性别(男、女)',
    '调整人物的性别(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.HAIR,
    '@' + g_GameCommand.HAIR.sCmd + ' 类型值',
    '更改指定人物的头发类型(支持权限分配)');

  {RefGameMasterCmd(@g_GameCommand.BonusPoint,
    '@' + g_GameCommand.BonusPoint.sCmd + ' 人物名称 属性点数',
    '调整人物的属性点数(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DELBONUSPOINT,
    '@' + g_GameCommand.DELBONUSPOINT.sCmd + ' 人物名称',
    '删除人物的属性点数(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.RESTBONUSPOINT,
    '@' + g_GameCommand.RESTBONUSPOINT.sCmd + ' 人物名称',
    '将人物的属性点数重新分配(支持权限分配)');  }

  RefGameMasterCmd(@g_GameCommand.SETPERMISSION,
    '@' + g_GameCommand.SETPERMISSION.sCmd +
    ' 人物名称 权限等级(0 - 10)',
    '调整人物的权限等级，可以将普通人物升为GM权限(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.RENEWLEVEL,
    '@' + g_GameCommand.RENEWLEVEL.sCmd +
    ' 人物名称 点数(为空则查看)',
    '调整查看人物的转生等级(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DELGOLD,
    '@' + g_GameCommand.DELGOLD.sCmd + ' 人物名称 数量',
    '删除人物指定数量的金币(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.ADDGOLD,
    '@' + g_GameCommand.ADDGOLD.sCmd + ' 人物名称 数量',
    '增加人物指定数量的金币(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.GAMEGOLD,
    '@' + g_GameCommand.GAMEGOLD.sCmd + ' 人物名称 控制符(+ - =) 数量',
    '调整人物的元宝数量(支持权限分配)');

  {RefGameMasterCmd(@g_GameCommand.GAMEPOINT,
    '@' + g_GameCommand.GAMEPOINT.sCmd +
    ' 人物名称 控制符(+ - =) 数量',
    '调整人物的游戏点数量(支持权限分配)');   }

  RefGameMasterCmd(@g_GameCommand.CREDITPOINT,
    '@' + g_GameCommand.CREDITPOINT.sCmd +
    ' 人物名称 控制符(+ - =) 点数',
    '调整人物的声望点数(支持权限分配)');

  {RefGameMasterCmd(@g_GameCommand.REFINEWEAPON,
    '@' + g_GameCommand.REFINEWEAPON.sCmd +
    ' 攻击力 魔法力 道术 准确度',
    '调整身上武器属性(支持权限分配)');  }

  RefGameMasterCmd(@g_GameCommand.ADJUESTLEVEL,
    '@' + g_GameCommand.ADJUESTLEVEL.sCmd + ' 人物名称 等级',
    '调整指定人物的等级(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.ADJUESTEXP,
    '@' + g_GameCommand.ADJUESTEXP.sCmd + ' 人物名称 经验值',
    '调整指定人物的经验值(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.CHANGEDEARNAME,
    '@' + g_GameCommand.CHANGEDEARNAME.sCmd +
    ' 人物名称 配偶名称(如果为 无 则清除)',
    '更改指定人物的配偶名称(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.CHANGEMASTERNAME,
    '@' + g_GameCommand.CHANGEMASTERNAME.sCmd +
    ' 人物名称 师徒名称(如果为 无 则清除)',
    '更改指定人物的师徒名称(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.RECALLMOB,
    '@' + g_GameCommand.RECALLMOB.sCmd + ' 怪物名称 数量 召唤等级',
    '召唤指定怪物为宝宝(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.TRAINING,
    '@' + g_GameCommand.TRAINING.sCmd +
    ' 人物名称  技能名称 修炼等级(0-3)',
    '调整人物的技能修炼等级(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.TRAININGSKILL,
    '@' + g_GameCommand.TRAININGSKILL.sCmd +
    ' 人物名称  技能名称 修炼等级(0-3)',
    '给指定人物增加技能(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DELETESKILL,
    '@' + g_GameCommand.DELETESKILL.sCmd + ' 人物名称 技能名称(All)',
    '删除人物的技能，All代表删除全部技能(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DELETEITEM,
    '@' + g_GameCommand.DELETEITEM.sCmd + ' 人物名称 物品名称 数量',
    '删除人物身上指定的物品(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.CLEARMISSION,
    '@' + g_GameCommand.CLEARMISSION.sCmd + ' 人物名称',
    '清除人物的任务标志(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.AddGuild,
    '@' + g_GameCommand.AddGuild.sCmd + ' 行会名称 掌门人',
    '新建一个行会(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DELGUILD,
    '@' + g_GameCommand.DELGUILD.sCmd + ' 行会名称',
    '删除一个行会(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.CHANGESABUKLORD,
    '@' + g_GameCommand.CHANGESABUKLORD.sCmd + ' 行会名称',
    '更改城堡所属行会(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.FORCEDWALLCONQUESTWAR,
    '@' + g_GameCommand.FORCEDWALLCONQUESTWAR.sCmd,
    '强行开始/停止攻城战(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.CONTESTPOINT,
    '@' + g_GameCommand.CONTESTPOINT.sCmd + ' 行会名称',
    '查看行会争霸赛得分情况(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.STARTCONTEST,
    '@' + g_GameCommand.STARTCONTEST.sCmd,
    '开始行会争霸赛(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.ENDCONTEST,
    '@' + g_GameCommand.ENDCONTEST.sCmd,
    '结束行会争霸赛(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.ANNOUNCEMENT,
    '@' + g_GameCommand.ANNOUNCEMENT.sCmd,
    '查看行会争霸赛结果(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.MOB,
    '@' + g_GameCommand.MOB.sCmd + ' 怪物名称 数量',
    '在身边放置指定类型数量的怪物(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.Mission,
    '@' + g_GameCommand.Mission.sCmd + ' X  Y',
    '设置怪物的集中点(举行怪物攻城用)(支持权限分配');

  RefGameMasterCmd(@g_GameCommand.MobPlace,
    '@' + g_GameCommand.MobPlace.sCmd + ' X  Y 怪物名称 怪物数量',
    '在当前地图指定XY放置怪物(支持权限分配(先必须设置怪物的集中点)，放置的怪物大刀守卫不会攻击这些怪物');

  RefGameMasterCmd(@g_GameCommand.CLEARMON,
    '@' + g_GameCommand.CLEARMON.sCmd +
    ' 地图号(* 为所有) 怪物名称(* 为所有) 掉物品(0,1)',
    '清除地图中的怪物(支持权限分配'')');

  RefGameMasterCmd(@g_GameCommand.DISABLESENDMSG,
    '@' + g_GameCommand.DISABLESENDMSG.sCmd + ' 人物名称',
    '将指定人物加入发言过滤列表，加入列表后自己发的文字自己可以看到，其他人看不到(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.ENABLESENDMSG,
    '@' + g_GameCommand.ENABLESENDMSG.sCmd,
    '将指定人物从发言过滤列表中删除(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DISABLESENDMSGLIST,
    '@' + g_GameCommand.DISABLESENDMSGLIST.sCmd,
    '查看发言过滤列表中的内容(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.SHUTUP,
    '@' + g_GameCommand.SHUTUP.sCmd + ' 人物名称',
    '将指定人物禁言(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.RELEASESHUTUP,
    '@' + g_GameCommand.RELEASESHUTUP.sCmd + ' 人物名称',
    '将指定人物从禁言列表中删除(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.SHUTUPLIST,
    '@' + g_GameCommand.SHUTUPLIST.sCmd,
    '查看禁言列表中的内容(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.SABUKWALLGOLD,
    '@' + g_GameCommand.SABUKWALLGOLD.sCmd,
    '查看城堡金币数(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.STARTQUEST,
    '@' + g_GameCommand.STARTQUEST.sCmd,
    '开始提问功能，游戏中所有人同时跳出问题窗口(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DENYIPLOGON,
    '@' + g_GameCommand.DENYIPLOGON.sCmd + ' IP地址 是否永久封(0,1)',
    '将指定IP地址加入禁止登录列表，以这些IP登录的用户将无法进入游戏(支持权限分配)');
    
  RefGameMasterCmd(@g_GameCommand.DELDENYIPLOGON,
    '@' + g_GameCommand.DELDENYIPLOGON.sCmd + ' IP地址',
    '将指定IP地址从禁止登录列表中删除(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.SHOWDENYIPLOGON,
    '@' + g_GameCommand.SHOWDENYIPLOGON.sCmd,
    '查看禁止登录IP地址列表中的内容(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DENYACCOUNTLOGON,
    '@' + g_GameCommand.DENYACCOUNTLOGON.sCmd +
    ' 登录帐号 是否永久封(0,1)',
    '将指定登录帐号加入禁止登录列表，以此帐号登录的用户将无法进入游戏(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DELDENYACCOUNTLOGON,
    '@' + g_GameCommand.DELDENYACCOUNTLOGON.sCmd + ' 登录帐号',
    '将指定登录帐号从禁止登录列表中删除(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.SHOWDENYACCOUNTLOGON,
    '@' + g_GameCommand.SHOWDENYACCOUNTLOGON.sCmd,
    '查看禁止登录帐号列表中的内容(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DENYCHARNAMELOGON,
    '@' + g_GameCommand.DENYCHARNAMELOGON.sCmd +
    ' 人物名称 是否永久封(0,1)',
    '将指定人物名称加入禁止登录列表，此人物将无法进入游戏(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.DELDENYCHARNAMELOGON,
    '@' + g_GameCommand.DELDENYCHARNAMELOGON.sCmd + ' 人物名称',
    '将指定人物名称从禁止登录列表中删除(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.SHOWDENYCHARNAMELOGON,
    '@' + g_GameCommand.SHOWDENYCHARNAMELOGON.sCmd,
    '查看禁止人物名称列表中的内容(支持权限分配)');

  RefGameMasterCmd(@g_GameCommand.SETMAPMODE,
    '@' + g_GameCommand.SETMAPMODE.sCmd,
    '设置地图模式');

  RefGameMasterCmd(@g_GameCommand.SHOWMAPMODE,
    '@' + g_GameCommand.SHOWMAPMODE.sCmd,
    '显示地图模式');

  RefGameMasterCmd(@g_GameCommand.SPIRIT,
    '@' + g_GameCommand.SPIRIT.sCmd,
    '开始祈祷生效宝宝叛变');

  RefGameMasterCmd(@g_GameCommand.SPIRITSTOP,
    '@' + g_GameCommand.SPIRITSTOP.sCmd,
    '停止祈祷生效宝宝叛变');

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
    '查看人物指定标识号状态');

  GameCmd := @g_GameCommand.SETFLAG;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '设置人物指定标识号状态(开/关)');

  GameCmd := @g_GameCommand.MOBNPC;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '创建一个新的NPC');

  GameCmd := @g_GameCommand.DELNPC;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '删除指定NPC');

  GameCmd := @g_GameCommand.LOTTERYTICKET;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '查看彩票中奖比例');

  GameCmd := @g_GameCommand.RELOADADMIN;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '重新加载管理员列表');

  GameCmd := @g_GameCommand.ReLoadNpc;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '重新加载NPC脚本');

  GameCmd := @g_GameCommand.RELOADMANAGE;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '重新加载登录脚本');

  GameCmd := @g_GameCommand.RELOADROBOTMANAGE;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '重新加载机器人配置');

  GameCmd := @g_GameCommand.RELOADROBOT;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '重新加载机器人脚本');

  GameCmd := @g_GameCommand.RELOADMONITEMS;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '重新加载怪物爆率配置');

  {GameCmd := @g_GameCommand.RELOADDIARY;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '未使用');  }

  GameCmd := @g_GameCommand.RELOADITEMDB;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '重新加载物品数据库');

  GameCmd := @g_GameCommand.RELOADMAGICDB;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '重新加载技能数据库');

  GameCmd := @g_GameCommand.RELOADMONSTERDB;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '重新加载怪物数据库');

  GameCmd := @g_GameCommand.RELOADMINMAP;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '重新加载小地图配置');

  GameCmd := @g_GameCommand.RELOADGUILD;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '重新加载行会信息');

  {GameCmd := @g_GameCommand.RELOADGUILDALL;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');  }

  GameCmd := @g_GameCommand.RELOADLINENOTICE;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '重新加载游戏公告信息');

  {GameCmd := @g_GameCommand.RELOADABUSE;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '重新加载脏话过滤配置');     }

  GameCmd := @g_GameCommand.BACKSTEP;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '人物后退');

  {GameCmd := @g_GameCommand.RECONNECTION;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '将指定人物重新切换网络连接');

  GameCmd := @g_GameCommand.DISABLEFILTER;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '禁用脏话过滤功能');    }

  GameCmd := @g_GameCommand.CHGUSERFULL;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '设置服务器最高上线人数');

  GameCmd := @g_GameCommand.CHGZENFASTSTEP;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '设置怪物行动速度');

  {GameCmd := @g_GameCommand.OXQUIZROOM;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');  }

  {GameCmd := @g_GameCommand.BALL;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    ''); }

  GameCmd := @g_GameCommand.FIREBURN;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '在自己当前坐标增加地图事件');

  GameCmd := @g_GameCommand.TESTFIRE;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '在自己周围范围内增加地图事件');

  GameCmd := @g_GameCommand.TESTSTATUS;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '设置人物状态时间');

  {GameCmd := @g_GameCommand.TESTGOLDCHANGE;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');   }

  {GameCmd := @g_GameCommand.GSA;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');

  GameCmd := @g_GameCommand.TESTGA;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '');   }

  GameCmd := @g_GameCommand.MAPINFO;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '显示地图详细信息');

  GameCmd := @g_GameCommand.CLEARBAG;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd,
    '清除背包全部物品');

  GameCmd := @g_GameCommand.SHOWEFFECT;
  RefGameDebugCmd(GameCmd,
    '@' + GameCmd.sCmd + ' 特效ID',
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
    Application.MessageBox('命令名称不能为空.', '提示信息',
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
    Application.MessageBox('命令名称不能为空.', '提示信息',
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

