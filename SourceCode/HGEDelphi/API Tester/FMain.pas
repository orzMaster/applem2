unit FMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, XPMan, HGE, HGEFont, UTestBase, ComCtrls, ImgList,
  USyntaxHighlighter, StdCtrls;

type
  TFrmMain = class(TForm)
    PnlRight: TPanel;
    PnlContainer: TPanel;
    TVTests: TTreeView;
    Images: TImageList;
    LBSource: TListBox;
    PnlCommands: TPanel;
    BtnExecute: TButton;
    LblStatus: TLabel;
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TVTestsChange(Sender: TObject; Node: TTreeNode);
    procedure LBSourceDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure BtnExecuteClick(Sender: TObject);
  private
    { Private declarations }
    FHighlighter: TSyntaxHighlighter;
    FSourceDir: String;
    FCurrentTest: TTest;
    procedure CMShowingChanged(var Msg: TMessage); message CM_SHOWINGCHANGED;
    procedure AddTests(const ParentNode: TTreeNode;
      const Categories: TTestCategories);
    procedure DisplaySourceCode(const Test: TTest);
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

const
  IMAGE_INDEX_CATEGORY = 0;
  IMAGE_INDEX_TEST = 1;

{ TFrmMain }

procedure TFrmMain.AddTests(const ParentNode: TTreeNode;
  const Categories: TTestCategories);
var
  I, J: Integer;
  Category: TTestCategory;
  Test: TTest;
  Node, TestNode: TTreeNode;
begin
  for I := 0 to Categories.Count - 1 do begin
    Category := Categories[I];
    Node := TVTests.Items.AddChild(ParentNode,Category.Name);
    Node.Data := Category;
    Node.ImageIndex := IMAGE_INDEX_CATEGORY;
    Node.SelectedIndex := IMAGE_INDEX_CATEGORY;
    AddTests(Node,Category.SubCategories);

    for J := 0 to Category.Tests.Count - 1 do begin
      Test := Category.Tests[J];
      TestNode := TVTests.Items.AddChild(Node,Test.Name);
      TestNode.Data := Test;
      TestNode.ImageIndex := IMAGE_INDEX_TEST;
      TestNode.SelectedIndex := IMAGE_INDEX_TEST;
    end;
  end;
end;

procedure TFrmMain.BtnExecuteClick(Sender: TObject);
begin
  IsRunning := True;
  BtnExecute.Enabled := False;
  LblStatus.Caption := 'Running...';
  LblStatus.Update;
  if (toManualGfx in FCurrentTest.Options) then
    FCurrentTest.TestProc
  else begin
    Engine.Gfx_BeginScene;
    Engine.Gfx_Clear(0);
    FCurrentTest.TestProc;
    Engine.Gfx_EndScene;
  end;
  LblStatus.Caption := '';
  BtnExecute.Enabled := (TVTests.Selected <> nil) and (TVTests.Selected.ImageIndex = IMAGE_INDEX_TEST);
end;

procedure TFrmMain.CMShowingChanged(var Msg: TMessage);
begin
  inherited;
  if (Showing) and (Engine = nil) then begin
    Engine := HGECreate(HGE_VERSION);
    Engine.System_SetState(HGE_FRAMEFUNC,DefaultFrameFunc);
    Engine.System_SetState(HGE_HWNDPARENT,PnlContainer.Handle);
    Engine.System_SetState(HGE_HIDEMOUSE,False);
    Engine.System_SetState(HGE_USESOUND,True);
    Engine.System_SetState(HGE_SCREENWIDTH,800);
    Engine.System_SetState(HGE_SCREENHEIGHT,600);
    Engine.System_SetState(HGE_SCREENBPP,32);
    if (not Engine.System_Initiate) then
      raise Exception.Create('Cannot initiate Engine system');
    if (not Engine.System_Start) then
      raise Exception.Create('Cannot start Engine system');

    SmallFont := THGEFont.Create('Font2.fnt');
    LargeFont := THGEFont.Create('Font1.fnt');
  end;
end;

procedure TFrmMain.DisplaySourceCode(const Test: TTest);
var
  Filename: String;
  F: TextFile;
  S, T: String;
  Mode: (InInterface, InImplementation, InUses, InSource);
begin
  if (FSourceDir = '') then
    Exit;
  Filename := FSourceDir + Test.SourceFile + '.pas';
  if (not FileExists(Filename)) then
    Exit;

  Mode := InInterface;
  LBSource.Items.BeginUpdate;
  try
    AssignFile(F,Filename);
    Reset(F);
    try
      while (not Eof(F)) do begin
        ReadLn(F,S);
        T := UpperCase(Trim(S));
        if (T = 'INITIALIZATION') then
          Break
        else if (T = 'IMPLEMENTATION') then
          Mode := InImplementation
        else if (T = 'USES') and (Mode = InImplementation) then
          Mode := InUses
        else if (Mode = InUses) and (T = '') then
          Mode := InSource
        else if (Mode = InSource) then
          LBSource.Items.Add(S);
      end;
    finally
      CloseFile(F);
    end;
    while (LBSource.Items.Count > 0) and (LBSource.Items[LBSource.Items.Count - 1] = '') do
      LBSource.Items.Delete(LBSource.Items.Count - 1);
  finally
    LBSource.Items.EndUpdate;
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  Node: TTreeNode;
begin
  Left := Screen.WorkAreaLeft + (Screen.WorkAreaWidth - Width) div 2;
  Top := Screen.WorkAreaTop;
  Height := Screen.WorkAreaHeight; 
  FHighlighter := TSyntaxHighlighter.Create;
  LBSource.Font := FHighlighter.EditorFont;
  LBSource.ItemHeight := Abs(LBSource.Font.Height) + 3;

  FSourceDir := ExtractFilePath(Application.ExeName);
  FSourceDir := ExcludeTrailingPathDelimiter(FSourceDir);
  FSourceDir := ExtractFilePath(FSourceDir) + 'Tests\';
  if (not DirectoryExists(FSourceDir)) then begin
    FSourceDir := '';
    ShowMessage('Directory with source code not found.'#10#13 +
      'Source code display not available.');
  end;

  Node := TVTests.Items.AddChild(nil,'Tests');
  AddTests(Node,TestRegister.Categories);
  Node.Expand(False);
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  Engine.System_Shutdown;
  Engine := nil;
  SmallFont := nil;
  LargeFont := nil;
  FHighlighter.Free;
end;

procedure TFrmMain.FormResize(Sender: TObject);
begin
  PnlRight.Width := 800;
  PnlContainer.Height := 600;
end;

procedure TFrmMain.LBSourceDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  LBSource.Canvas.Brush.Color := clWindow;
  LBSource.Canvas.FillRect(Rect);
  FHighlighter.Draw(LBSource.Canvas,Rect,LBSource.Items[Index]);
end;

procedure TFrmMain.TVTestsChange(Sender: TObject; Node: TTreeNode);
begin
  IsRunning := False;
  LBSource.Clear;
  Engine.Gfx_BeginScene;
  Engine.Gfx_Clear(0);
  Engine.Gfx_EndScene;
  
  if Assigned(Node) and (Node.ImageIndex = IMAGE_INDEX_TEST) then begin
    FCurrentTest := Node.Data;
    DisplaySourceCode(FCurrentTest);
    BtnExecute.Enabled := True;
  end else begin
    FCurrentTest := nil;
    BtnExecute.Enabled := False;
  end;
end;

end.
