unit UTestBase;

interface

uses
  Classes, HGE, HGEFont;

type
  TTestProc = procedure;
  TTestOption = (toManualGfx);
  TTestOptions = set of TTestOption;

type
  TTestCategories = class;
  TTests = class;

  TTestCategory = class
  private
    FSubCategories: TTestCategories;
    FTests: TTests;
    FName: String;
  public
    constructor Create(const AName: String);
    destructor Destroy; override;

    property SubCategories: TTestCategories read FSubCategories;
    property Tests: TTests read FTests;
    property Name: String read FName;
  end;

  TTestCategories = class
  private
    FItems: TStringList;
    function GetCategory(const Index: Integer): TTestCategory;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(const Category: TTestCategory);
    function Find(const Name: String): TTestCategory;

    property Count: Integer read GetCount;
    property Categories[const Index: Integer]: TTestCategory read GetCategory; default;
  end;

  TTest = class
  private
    FName: String;
    FSourceFile: String;
    FTestProc: TTestProc;
    FOptions: TTestOptions;
  public
    constructor Create(const AName, ASourceFile: String;
      const ATestProc: TTestProc; const AOptions: TTestOptions);

    property Name: String read FName;
    property SourceFile: String read FSourceFile;
    property TestProc: TTestProc read FTestProc;
    property Options: TTestOptions read FOptions;
  end;

  TTests = class
  private
    FItems: TStringList;
    function GetCount: Integer;
    function GetTest(const Index: Integer): TTest;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(const Test: TTest);

    property Count: Integer read GetCount;
    property Tests[const Index: Integer]: TTest read GetTest; default;
  end;

type
  TTestRegister = class
  private
    FCategories: TTestCategories;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Register(const Name, SourceFile: String;
      const TestProc: TTestProc; const Options: TTestOptions);

    property Categories: TTestCategories read FCategories;
  end;

var
  Engine: IHGE = nil;
  SmallFont: IHGEFont = nil;
  LargeFont: IHGEFont = nil;
  IsRunning: Boolean = False;

function TestRegister: TTestRegister;

procedure RegisterTest(const Name, SourceFile: String;
  const TestProc: TTestProc; const Options: TTestOptions = []);

procedure Error(const Msg: String);

function DefaultFrameFunc: Boolean;

function Running: Boolean;

implementation

uses
  Forms, SysUtils;

var
  GlobalRegister: TTestRegister = nil;

function TestRegister: TTestRegister;
begin
  if (GlobalRegister = nil) then
    GlobalRegister := TTestRegister.Create;
  Result := GlobalRegister;
end;

procedure RegisterTest(const Name, SourceFile: String;
  const TestProc: TTestProc; const Options: TTestOptions);
begin
  TestRegister.Register(Name,SourceFile,TestProc,Options);
end;

procedure Error(const Msg: String);
begin
  raise Exception.Create(Msg);
end;

function DefaultFrameFunc: Boolean;
begin
  Result := False;
end;

function Running: Boolean;
begin
  Engine.System_Start;
  Application.ProcessMessages;
  if (Application.Terminated) then
    IsRunning := False;
  Result := IsRunning;
end;

{ TTestCategory }

constructor TTestCategory.Create(const AName: String);
begin
  inherited Create;
  FName := AName;
  FSubCategories := TTestCategories.Create;
  FTests := TTests.Create;
end;

destructor TTestCategory.Destroy;
begin
  FTests.Free;
  FSubCategories.Free;
  inherited;
end;

{ TTestCategories }

procedure TTestCategories.Add(const Category: TTestCategory);
begin
  FItems.AddObject(Category.Name,Category);
end;

constructor TTestCategories.Create;
begin
  inherited;
  FItems := TStringList.Create;
end;

destructor TTestCategories.Destroy;
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
    FItems.Objects[I].Free;
  FItems.Free;
  inherited;
end;

function TTestCategories.Find(const Name: String): TTestCategory;
var
  I: Integer;
begin
  I := FItems.IndexOf(Name);
  if (I < 0) then
    Result := nil
  else
    Result := FItems.Objects[I] as TTestCategory;
end;

function TTestCategories.GetCategory(const Index: Integer): TTestCategory;
begin
  Result := FItems.Objects[Index] as TTestCategory;
end;

function TTestCategories.GetCount: Integer;
begin
  Result := FItems.Count;
end;

{ TTest }

constructor TTest.Create(const AName, ASourceFile: String;
  const ATestProc: TTestProc; const AOptions: TTestOptions);
begin
  inherited Create;
  FName := AName;
  FSourceFile := ASourceFile;
  FTestProc := ATestProc;
  FOptions := AOptions;
end;

{ TTests }

procedure TTests.Add(const Test: TTest);
begin
  FItems.AddObject(Test.Name,Test);
end;

constructor TTests.Create;
begin
  inherited;
  FItems := TStringList.Create;
end;

destructor TTests.Destroy;
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
    FItems.Objects[I].Free;
  FItems.Free;
  inherited;
end;

function TTests.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TTests.GetTest(const Index: Integer): TTest;
begin
  Result := FItems.Objects[Index] as TTest;
end;

{ TTestRegister }

constructor TTestRegister.Create;
begin
  FCategories := TTestCategories.Create;
end;

destructor TTestRegister.Destroy;
begin
  FCategories.Free;
  inherited;
end;

procedure TTestRegister.Register(const Name, SourceFile: String;
  const TestProc: TTestProc; const Options: TTestOptions);
var
  S, T: String;
  I: Integer;
  Categories: TTestCategories;
  Category: TTestCategory;
  Test: TTest;
begin
  S := SourceFile;
  Category := nil;
  Categories := FCategories;
  repeat
    I := Pos('\',S);
    if (I <> 0) then begin
      T := Copy(S,1,I - 1);
      S := Copy(S,I + 1,MaxInt);
      Category := Categories.Find(T);
      if (Category = nil) then begin
        Category := TTestCategory.Create(T);
        Categories.Add(Category);
      end;
      Categories := Category.SubCategories;
    end;
  until (I = 0);
  Assert(Assigned(Category));

  Test := TTest.Create(Name,SourceFile,TestProc,Options);
  Category.Tests.Add(Test);
end;

initialization

finalization
  GlobalRegister.Free;

end.
