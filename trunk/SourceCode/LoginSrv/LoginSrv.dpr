program LoginSrv;

uses
  Forms,
  MasSock in 'MasSock.pas' {FrmMasSoc},
  LMain in 'LMain.pas' {FrmMain},
  MonSoc in 'MonSoc.pas' {FrmMonSoc},
  LSShare in 'LSShare.pas',
  GrobalSession in 'GrobalSession.pas' {frmGrobalSession},
  MudUtil in '..\Common\MudUtil.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  SDK in 'SDK.pas',
  Common in '..\Common\Common.pas',
  BasicSet in 'BasicSet.pas' {FrmBasicSet},
  EDcode in '..\Common\EDcode.pas',
  TestSelGate in 'TestSelGate.pas' {frmTestSelGate},
  RouteManage in 'RouteManage.pas' {frmRouteManage},
  RouteEdit in 'RouteEdit.pas' {frmRouteEdit},
  MD5Unit in '..\Common\MD5Unit.pas',
  SqlSock in 'SqlSock.pas' {FrmSqlSock},
  FrmVarsion in 'FrmVarsion.pas' {FormVersion},
  IDDB in 'IDDB.pas',
  EditUserInfo in 'EditUserInfo.pas' {FrmUserInfoEdit},
  FrmFindId in 'FrmFindId.pas' {FrmFindUserId};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'LoginSrv';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmMasSoc, FrmMasSoc);
  Application.CreateForm(TFrmMonSoc, FrmMonSoc);
  Application.CreateForm(TFrmBasicSet, FrmBasicSet);
  Application.CreateForm(TfrmTestSelGate, frmTestSelGate);
  Application.CreateForm(TfrmRouteManage, frmRouteManage);
  Application.CreateForm(TfrmRouteEdit, frmRouteEdit);
  Application.CreateForm(TFrmSqlSock, FrmSqlSock);
  Application.CreateForm(TFrmUserInfoEdit, FrmUserInfoEdit);
  Application.CreateForm(TFrmFindUserId, FrmFindUserId);
  //Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

