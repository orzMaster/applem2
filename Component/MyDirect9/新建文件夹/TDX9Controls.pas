unit TDX9Controls;

interface

uses
  Windows, Classes, Graphics, Controls, StrUtils, SysUtils, Grids, Clipbrd, imm, TDX9Canvas, TDX9Textures,
  WIL, HUtil32, MyDXBase, MyDirect3D9;
  
const
  AllowedChars = [#32..#254];
  AllowedIntegerChars = [#48..#57];
  AllowedEnglishChars = [#33..#126];
  AllowedStandard = [#48..#57, #65..#90, #97..#122];
  AllowedCDKey = [#48..#57, #65..#90, #95, #97..#122];

type
  pTDTreeNodes = ^TDTreeNodes;
  TDTreeNodes = packed record
    sName: string;
    Item: Pointer;
    ItemList: TList;
    boOpen: Boolean;
    nNameLen: Integer;
    boMaster: Boolean;
  end;
  
  TClickSound = (csNone, csStone, csGlass, csNorm);
  TDEditClass = (deNone, deInteger, deMonoCase, deChinese, deStandard, deEnglishAndInt, deCDKey);
  TMouseEntry = (msIn, msOut);
  TDControlStyle = (dsNone, dsTop, dsBottom);
  TMouseWheel = (mw_Down, mw_Up);

  TDControl = class;
  TOnDirectPaint = procedure(Sender: TObject; dsurface: TDirectDrawSurface) of object;
  TOnKeyPress = procedure(Sender: TObject; var Key: Char) of object;
  TOnKeyDown = procedure(Sender: TObject; var Key: word; Shift: TShiftState) of object;
  TOnKeyUp = procedure(Sender: TObject; var Key: word; Shift: TShiftState) of object;
  TOnMouseWheel = procedure(Shift: TShiftState; Wheel: TMouseWheel; X, Y: Integer) of object;
  TOnMouseMove = procedure(Sender: TObject; Shift: TShiftState; X, Y: integer) of object;
  TOnMouseDown = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer) of object;
  TOnMouseUp = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
  TOnClick = procedure(Sender: TObject) of object;
  TOnVisible = procedure(Sender: TObject; boVisible: Boolean) of object;
  TOnClickEx = procedure(Sender: TObject; X, Y: integer) of object;
  TOnInRealArea = procedure(Sender: TObject; X, Y: integer; var IsRealArea: Boolean) of object;
  TOnGridSelect = procedure(Sender: TObject; X, Y: integer; ACol, ARow: integer; Shift: TShiftState) of object;
  TOnItemIndex = procedure(Sender: TObject; ItemIndex, SubIndex: integer) of object;
  TOnGridPaint = procedure(Sender: TObject; ACol, ARow: integer; Rect: TRect; State: TGridDrawState;
    dsurface: TDirectDrawSurface) of object;
  TOnClickSound = procedure(Sender: TObject; Clicksound: TClickSound) of object;
  TOnMouseEntry = procedure(Sender: TObject; MouseEntry: TMouseEntry) of object;
  TOnCheckItem = procedure(Sender: TObject; ItemIndex: Integer; var ItemName: string) of object;
  TOnDrawEditImage = procedure(Sender: TObject; ImageSurface: TDirectDrawSurface; Rect: TRect; ImageIndex: Integer)
    of object;
  TOnTreeViewSelect = procedure(Sender: TObject; DTreeNodes: pTDTreeNodes) of object;
  TOnTreeClearItem = procedure(Sender: TObject; DTreeNodes: pTDTreeNodes) of object;

  TDControl = class(TCustomControl)
  private
    FCaption: string; 
    FDParent: TDControl;
    FReadOnly: Boolean;
    FMouseFocus: Boolean;
    FKeyFocus: Boolean;
    FOnDirectPaint: TOnDirectPaint; 
    FOnEndDirectPaint: TOnDirectPaint; 
    FOnKeyPress: TOnKeyPress; 
    FOnKeyDown: TOnKeyDown; 
    FOnKeyUp: TOnKeyUp;
    FWheelDControl: TDControl;
    FOnMouseWheel: TOnMouseWheel;
    FOnMouseMove: TOnMouseMove;
    FOnMouseDown: TOnMouseDown; 
    FOnMouseUp: TOnMouseUp; 
    FOnDblClick: TNotifyEvent; 
    FOnClick: TOnClickEx; 
    FOnInRealArea: TOnInRealArea; 
    FOnBackgroundClick: TOnClick; 
    FOnMouseEntry: TOnMouseEntry;
    FMouseEntry: TMouseEntry;
    FOnEnter: TOnClick;
    FOnLeave: TOnClick;
    FOnVisible: TOnVisible;
    FChangeCaption: Boolean;
    FSurface: TDirectDrawSurface;
    FAppendData: Pointer;
    FDFColor: TColor;
    FDFMoveColor: TColor;
    FDFEnabledColor: TColor;
    FDFDownColor: TColor;
    FDFBackColor: TColor;
    procedure SetCaption(str: string);
    procedure SetVisible(flag: Boolean);
  protected
    FVisible: Boolean;
    FIsHide: Boolean;
    FEnabled: Boolean;
    FTabDControl: TDControl;
  public
    Background: Boolean; 
    DControls: TList; 
    DTabControls: TList; 
    
    WLib: TWMImages; 
    FaceIndex: integer; 
    WantReturn: Boolean; 
    AppendTick: LongWord;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure Loaded; override;
    function SurfaceX(x: integer): integer;
    function SurfaceY(y: integer): integer;
    function LocalX(x: integer): integer;
    function LocalY(y: integer): integer;
    procedure AddChild(dcon: TDControl);
    procedure ChangeChildOrder(dcon: TDControl);
    function InRange(x, y: integer): Boolean; dynamic;
    function KeyPress(var Key: Char): Boolean; dynamic;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; dynamic;
    function KeyUp(var Key: Word; Shift: TShiftState): Boolean; dynamic;
    function MouseWheel(Shift: TShiftState; Wheel: TMouseWheel; X, Y: Integer): Boolean; dynamic;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; dynamic;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; dynamic;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; dynamic;
    function EscClose: Boolean; dynamic;
    function DblClick(X, Y: integer): Boolean; dynamic;
    function CheckTab(): Boolean; dynamic;
    procedure CloseSurface(); dynamic;
    procedure IsVisible(flag: Boolean); dynamic;

    function Click(X, Y: integer): Boolean; dynamic;
    function CanFocusMsg: Boolean;
    procedure Leave(); dynamic;
    procedure Enter(); dynamic;
    procedure SetFocus(); dynamic;
    Function Selected(): Boolean; dynamic;
    procedure SetImgIndex(Lib: TWMImages; index: integer);
    procedure CreateSurface(Lib: TWMImages; boActive: Boolean = True; index: integer = 0); dynamic;
    procedure DirectPaint(dsurface: TDirectDrawSurface); dynamic;
    property MouseEntry: TMouseEntry read FMouseEntry;
    property ChangeCaption: Boolean read FChangeCaption;
    property IsHide: Boolean read FIsHide;
    property Surface: TDirectDrawSurface read FSurface;
    property AppendData: Pointer read FAppendData write FAppendData;

  published
    property DFColor: TColor read FDFColor write FDFColor;
    property DFEnabledColor: TColor read FDFEnabledColor write FDFEnabledColor;
    property DFMoveColor: TColor read FDFMoveColor write FDFMoveColor;
    property DFDownColor: TColor read FDFDownColor write FDFDownColor;
    property DFBackColor: TColor read FDFBackColor write FDFBackColor;

    property OnDirectPaint: TOnDirectPaint read FOnDirectPaint write FOnDirectPaint;
    property OnEndDirectPaint: TOnDirectPaint read FOnEndDirectPaint write FOnEndDirectPaint;
    property OnKeyPress: TOnKeyPress read FOnKeyPress write FOnKeyPress;
    property OnKeyDown: TOnKeyDown read FOnKeyDown write FOnKeyDown;


    property OnMouseWheel: TOnMouseWheel read FOnMouseWheel write FOnMouseWheel;
    property OnMouseMove: TOnMouseMove read FOnMouseMove write FOnMouseMove;
    property OnMouseDown: TOnMouseDown read FOnMouseDown write FOnMouseDown;
    property OnMouseUp: TOnMouseUp read FOnMouseUp write FOnMouseUp;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnInRealArea: TOnInRealArea read FOnInRealArea write FOnInRealArea;
    property OnBackgroundClick: TOnClick read FOnBackgroundClick write
      FOnBackgroundClick;
    property OnMouseEntry: TOnMouseEntry read FOnMouseEntry write FOnMouseEntry;
    property OnEnter: TOnClick read FOnEnter write FOnEnter;
    property OnLeave: TOnClick read FOnLeave write FOnLeave;
    property OnVisible: TOnVisible read FOnVisible write FOnVisible;
    property WheelDControl: TDControl read FWheelDControl write FWheelDControl;
    property Caption: string read FCaption write SetCaption;
    property DParent: TDControl read FDParent write FDParent;
    property Visible: Boolean read FVisible write SetVisible;
    property Enabled: Boolean read FEnabled write FEnabled;
    property ReadOnly: Boolean read FReadOnly write FReadOnly default False;
    property MouseFocus: Boolean read FMouseFocus write FMouseFocus;
    property KeyFocus: Boolean read FKeyFocus write FKeyFocus;
    property Color;
    property Font;
    property Hint;
    property ShowHint;
    property Align;
  end;

  TOnPopIndex = procedure(Sender, DControl: TDControl; ItemIndex: integer; UserName: string) of object;

  TDButton = class(TDControl)
  private
    FClickSound: TClickSound;
    FOnClick: TOnClickEx;
    FOnClickSound: TOnClickSound;
  public
    Downed: Boolean;
    constructor Create(AOwner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
  published
    property ClickCount: TClickSound read FClickSound write FClickSound;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnClickSound: TOnClickSound read FOnClickSound write FOnClickSound;
  end;
  
  TDGrid = class(TDControl)
  private
    FColCount, FRowCount: integer;
    FColWidth, FRowHeight: integer;
    FColoffset, FRowoffset: Integer;
    FViewTopLine: integer;
    FSelectCell: TPoint;
    DownPos: TPoint;
    FOnGridSelect: TOnGridSelect;
    FOnGridMouseMove: TOnGridSelect;
    FOnGridPaint: TOnGridPaint;
    function GetColRow(x, y: integer; var acol, arow: integer): Boolean;
  public
    CX, CY: integer;
    Col, Row: integer;
    constructor Create(AOwner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer):
      Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer):
      Boolean; override;
    function Click(X, Y: integer): Boolean; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
  published
    property ColCount: integer read FColCount write FColCount;
    property RowCount: integer read FRowCount write FRowCount;
    property ColWidth: integer read FColWidth write FColWidth;
    property RowHeight: integer read FRowHeight write FRowHeight;
    property Coloffset: integer read FColoffset write FColoffset;
    property Rowoffset: integer read FRowoffset write FRowoffset;
    property ViewTopLine: integer read FViewTopLine write FViewTopLine;
    property OnGridSelect: TOnGridSelect read FOnGridSelect write FOnGridSelect;
    property OnGridMouseMove: TOnGridSelect read FOnGridMouseMove write FOnGridMouseMove;
    property OnGridPaint: TOnGridPaint read FOnGridPaint write FOnGridPaint;
  end;
  
  TDWindow = class(TDButton)
  private
    FFloating: Boolean;
    FEscClose: Boolean;
    
    SpotX, SpotY: integer;
    FControlStyle: TDControlStyle;
  protected
    procedure SetVisible(flag: Boolean);
  public
    DialogResult: TModalResult;
    constructor Create(AOwner: TComponent); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
    function EscClose: Boolean; override;
    procedure Show;
    function ShowModal: integer;
    procedure TopShow();
  published
    property Visible: Boolean read FVisible write SetVisible;
    property Floating: Boolean read FFloating write FFloating;
    property EscExit: Boolean read FEscClose write FEscClose;
    property ControlStyle: TDControlStyle read FControlStyle write FControlStyle;
    
  end;

  TDlgInfo = packed record
    Rect: TRect;
    //Surface: TDirectDrawSurface;
    WMImages: TWMImages;
    Index: Integer;
  end;

  TDModalWindow = class(TDWindow)
  public
    YesResult: TModalResult;
    NoResult: TModalResult;
    MsgList: TStringList;
    DlgInfo: array[0..7] of TDlgInfo;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ModalShow: integer;
    function ModalClose: integer;
  end;

  TDCheckBox = class(TDControl)
  private
    FChecked: Boolean;
    FFontSpace: Integer;
    FOnClick: TOnClickEx;
    FWidth: Integer;
    FHeight: Integer;
    FOffsetLeft: Integer;
    FOffsetTop: Integer;
    FOnCheckedChange: TOnClick;
  public
    constructor Create(AOwner: TComponent); override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer):
      Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer):
      Boolean; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
    function InRange(x, y: integer): Boolean; override;
  published
    property Checked: Boolean read FChecked write FChecked;
    property FontSpace: Integer read FFontSpace write FFontSpace;
    property OnClick: TOnClickEx read FOnClick write FOnClick;
    property OnChange: TOnClick read FOnCheckedChange write FOnCheckedChange;
    property OffsetLeft: Integer read FOffsetLeft write FOffsetLeft;
    property OffsetTop: Integer read FOffsetTop write FOffsetTop;
  end;

  TDUpDown = class(TDButton)
  private
    FUpButton: TDButton;
    FDownButton: TDButton;
    FMoveButton: TDButton;
    FPosition: Integer;
    FMaxPosition: Integer;
    FOnPositionChange: TOnClick;
    FTop: Integer;
    FAddTop: Integer;
    FMaxLength: Integer;
    FOffset: Integer;
    FBoMoveShow: Boolean;
    FboMoveFlicker: Boolean;
    StopY: Integer;
    FStopY: Integer;
    FClickTime: LongWord;
    FMovePosition: Integer;
    procedure SetButton(Button: TDButton);
    procedure SetPosition(value: Integer);
    procedure SetMaxPosition(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function MouseWheel(Shift: TShiftState; Wheel: TMouseWheel; X, Y: Integer): Boolean; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
    procedure ButtonMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure ButtonMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ButtonMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    property UpButton: TDButton read FUpButton;
    property DownButton: TDButton read FDownButton;
    property MoveButton: TDButton read FMoveButton;
  published
    property Position: Integer read FPosition write SetPosition;
    property Offset: Integer read FOffset write FOffset;
    property MovePosition: Integer read FMovePosition write FMovePosition;
    property MoveShow: Boolean read FBoMoveShow write FBoMoveShow;
    property MaxPosition: Integer read FMaxPosition write SetMaxPosition;
    property MoveFlicker: Boolean read FboMoveFlicker write FboMoveFlicker;
    property OnPositionChange: TOnClick read FOnPositionChange write FOnPositionChange;
  end;

  TDHooKKey = class(TDControl)
  private
    FShiftState: TShiftState;
    FKey: Word;
    FText: string;
    FFrameColor: TColor;
    FOnChange: TOnClick;
    procedure SetShiftState(Value: TShiftState);
    procedure SetKey(Value: Word);
  public
    constructor Create(AOwner: TComponent); override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer):
      Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer):
      Boolean; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    procedure RefHookKeyStr();
    property Text: string read FText;
  published
    property ShiftState: TShiftState read FShiftState write SetShiftState;
    property Key: Word read FKey write SetKey;
    property FrameColor: TColor read FFrameColor write FFrameColor;
    property OnChange: TOnClick read FOnChange write FOnChange;
  end;

  TDCustomEdit = class(TDControl)
  private
    FEditClass: TDEditClass;
    FPasswordChar: Char;
  public
    constructor Create(AOwner: TComponent); override;

    procedure Enter(); override;
    procedure Leave(); override;
    procedure IsVisible(flag: Boolean); override;
  published
    property EditClass: TDEditClass read FEditClass write FEditClass;
    property PasswordChar: Char read FPasswordChar write FPasswordChar default #0;
  end;

  TCursor = (deLeft, deRight);

  TDMemo = class(TDCustomEdit)
  private
    FLines: TStrings;
    FOnChange: TOnClick;
    FFrameColor: TColor;
    FCaretShowTime: LongWord;
    FCaretShow: Boolean;
    FTopIndex: Integer;
    FCaretX: Integer;
    FCaretY: Integer;
    FSCaretX: Integer;
    FSCaretY: Integer;
    FUpDown: TDUpDown;
    FMoveTick: LongWord;
    FInputStr: string;
    bDoubleByte: Boolean;
    KeyByteCount: Integer;
    FTransparent: Boolean;
    FMaxLength: integer;
    
    procedure DownCaret(X, Y: Integer);
    procedure MoveCaret(X, Y: Integer);
    procedure KeyCaret(Key: Word);
    procedure SetUpDown(const Value: TDUpDown);
    procedure SetCaret(boBottom: Boolean);
    function ClearKey(): Boolean;
    function GetKey(): string;
    procedure SetCaretY(const Value: Integer);
  public
    Downed: Boolean;
    KeyDowned: Boolean;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
    procedure IsVisible(flag: Boolean); override;
    function KeyPress(var Key: Char): Boolean; override;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    function KeyUp(var Key: Word; Shift: TShiftState): Boolean; override;

    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;

    procedure Enter(); override;
    procedure Leave(); override;
    procedure SetFocus(); override;
    function GetText(): string;
    Function Selected(): Boolean; override;
    procedure PositionChange(Sender: TObject);
    procedure TextChange();

    property Lines: TStrings read FLines;
    property ItemIndex: Integer read FCaretY write SetCaretY;

    procedure RefListWidth(ItemIndex: Integer; nCaret: Integer);
  published
    property OnChange: TOnClick read FOnChange write FOnChange;
    property FrameColor: TColor read FFrameColor write FFrameColor;

    property UpDown: TDUpDown read FUpDown write SetUpDown;
    property boTransparent: Boolean read FTransparent write FTransparent;
    property MaxLength: Integer read FMaxLength write FMaxLength default 0;
  end;

  TDMemoStringList = class(TStringList)
    DMemo: TDMemo;
  private
    procedure Put(Index: Integer; const Value: string);
    function SelfGet(Index: Integer): string;
  published
  public
    function Add(const S: string): Integer; override;
    function AddObject(const S: string; AObject: TObject): Integer; override;
    procedure InsertObject(Index: Integer; const S: string;
      AObject: TObject); override;
    function Get(Index: Integer): string; override;

    function GetText: PChar; override;
    procedure LoadFromFile(const FileName: string); override;
    procedure SaveToFile(const FileName: string); override;

    property Str[Index: Integer]: string read SelfGet write Put; default;
    procedure Assign(Source: TPersistent); override;
    procedure Clear; override;
  end;

  TDImageEdit = class(TDCustomEdit)
  private
    FMaxLength: Integer;
    FOnChange: TOnClick;
    FOnCheckItem: TOnCheckItem;
    FOnDrawEditImage: TOnDrawEditImage;
    FStartX: Integer;
    FStopX: Integer;
    FStartLine: Integer;
    FStopLine: Integer;
    FInputStr: string;
    FEditString: string;
    bDoubleByte: Boolean;
    KeyByteCount: Integer;
    FEditTextList: TStringList;
    FEditImageList: TStringList;
    FEditItemList: TStringList;
    FCaretPos: Word;
    FStartoffset: Byte;
    FImageWidth: Byte;
    FShowPos: Word;
    FShowLine: Integer;
    FShowLeft: Boolean;
    FCaretShowTime: LongWord;
    FCaretShow: Boolean;
    FOppShowPos: Integer;
    FBeginChar: Char;
    FEndChar: Char;
    FImageChar: Char;
    FItemCount: Integer;
    FImageCount: Integer;
    procedure AddStrToList(str: string);
    procedure MoveCaret(X, Y: Integer);
    function GetText: string;
    procedure SetText(const Value: string);
    function ClearKey(): Boolean;
    function GetCopy(): string;
    procedure SetBearing(boLeft: Boolean);
    function GetItemName(str: string; boName: Boolean): string;
    procedure FormatEditStr(str: string);
  public
    Downed: Boolean;
    KeyDowned: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function KeyPress(var Key: Char): Boolean; override;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    function KeyUp(var Key: Word; Shift: TShiftState): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
    procedure Enter(); override;
    procedure Leave(); override;
    procedure SetFocus(); override;
    procedure TextChange();
    procedure RefEditSurfce(boRef: Boolean = True);
    procedure RefEditText();
    Function Selected(): Boolean; override;
    Function AddItemToList(ItemName, ItemIndex: string): Byte;
    Function AddImageToList(ImageIndex: string): Byte;
  published
    property OnChange: TOnClick read FOnChange write FOnChange;
    property OnCheckItem: TOnCheckItem read FOnCheckItem write FOnCheckItem;
    property OnDrawEditImage: TOnDrawEditImage read FOnDrawEditImage write FOnDrawEditImage;
    property Text: string read GetText write SetText;
    property MaxLength: Integer read FMaxLength write FMaxLength default 0;
    property BeginChar: Char read FBeginChar write FBeginChar;
    property EndChar: Char read FEndChar write FEndChar;
    property ImageChar: Char read FImageChar write FImageChar;
    property ItemCount: Integer read FItemCount write FItemCount;
    property ImageCount: Integer read FImageCount write FImageCount;
  end;

  TDEdit = class(TDCustomEdit)
  private
    //FReadOnly: Boolean;
    FEditString: WideString;
    FFrameColor: TColor;
    FCaretShowTime: LongWord;
    FCaretShow: Boolean;
    FMaxLength: Integer;
    FInputStr: string;
    bDoubleByte: Boolean;
    KeyByteCount: Integer;
    FCursor: TCursor;
    FStartX: Integer;
    FStopX: Integer;
    FCaretStart: Integer; 
    FCaretStop: Integer; 
    FCaretPos: Integer; 
    FOnChange: TOnClick;
    FIndent: Integer;
    FCloseSpace: Boolean;
    FTransparent: Boolean;
    procedure SetCursorPos(cCursor: TCursor);
    procedure SetCursorPosEx(nLen: Integer);
    procedure SetText(Value: string);
    function GetText(): string;
    procedure MoveCaret(X, Y: Integer);
    function ClearKey(): Boolean;
    //function CloseIME: Boolean;
    function GetPasswordstr(str: string): string;
    function GetCopy(): string;
    function GetValue: Integer;
    procedure SetValue(const Value: Integer);
  public
    Downed: Boolean;
    KeyDowned: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function KeyPress(var Key: Char): Boolean; override;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean; override;
    function KeyUp(var Key: Word; Shift: TShiftState): Boolean; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer):
      Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer):
      Boolean; override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure Enter(); override;
    procedure Leave(); override;
    procedure SetFocus(); override;
    Function Selected(): Boolean; override;
    procedure TextChange();

    property Value: Integer read GetValue write SetValue;
  published
    property OnChange: TOnClick read FOnChange write FOnChange;
    //property ReadOnly: Boolean read FReadOnly write FReadOnly default False;
    property Text: string read GetText write SetText;
    property FrameColor: TColor read FFrameColor write FFrameColor;
    property MaxLength: Integer read FMaxLength write FMaxLength default 0;
    property CloseSpace: Boolean read FCloseSpace write FCloseSpace default False;
    property boTransparent: Boolean read FTransparent write FTransparent;

  end;

  TDComboBox = class(TDEdit)
  private
    FUpDown: TDUpDown;
    FItem: TStrings;
    FShowCount: Integer;
    FListHeight: Integer;
    FShowHeight: Integer;
    FListIndex: Integer;
    FX: Integer;
    FY: Integer;
    FDWidth: Integer;
    FItemIndex: Integer;
    FImageWidth: Integer;
    FOnChange: TOnClick;
    procedure SetUpDownButton(Button: TDUpDown);
    procedure SetShowCount(Value: Integer);
    procedure SetShowHeight(Value: Integer);
    procedure SetItem(const Value: TStrings);
    function GetItemIndex: Integer;
    procedure SetItemIndex(const Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer):
      Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer):
      Boolean; override;
    function InRange(x, y: integer): Boolean; override;
    property UpDown: TDUpDown read FUpDown;

    property ImageWidth: Integer read FImageWidth write FImageWidth;
  published
    property ShowCount: Integer read FShowCount write SetShowCount;
    property ShowHeight: Integer read FShowHeight write SetShowHeight;

    property Item: TStrings read FItem write SetItem;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property OnChange: TOnClick read FOnChange write FOnChange;
  end;

  TDBiDiMode = (dbLeft, dbCenter, dbRight);

  TDListViewHead = record
    sName: string[40];
    DBiDiMode: TDBiDiMode;
    nWidth: Word;
    Rect: TRect;
  end;
  pTDListViewHead = ^TDListViewHead;

  TDListView = class(TDControl)
  private
    FUpDown: TDUpDown;
    FHeadList: TList;
    FItemList: TList;
    FItemHeigth: Integer;
    FItemIndex: Integer;
    FItemCount: Integer;
    FOnItemIndex: TOnItemIndex;
    procedure SetUpDownButton(Button: TDUpDown);
    function GetItems(Index: Integer): TStringList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClearHead();
    procedure Clear();
    property HeadList: TList read FHeadList;
    function AddItem(): TStringList;
    procedure AddHead(sName: string; DBiDiMode: TDBiDiMode; Width: Word);
    property UpDown: TDUpDown read FUpDown;
    property Item[Index: Integer]: TStringList read GetItems;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
    property ItemIndex: Integer read FItemIndex;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer):
      Boolean; override;
  published
    property OnItemIndex: TOnItemIndex read FOnItemIndex write FOnItemIndex;
  end;

  TDPopUpMemu = class(TDControl)
  private
    FItem: TStrings;
    FHeightOffset: Integer;
    FItemIndex: Integer;
    FOnPopIndex: TOnPopIndex;
    FAlpha: Integer;
    FHeight: Integer;
    FWidth: Integer;
    FDlgWidth: Integer;
    FDlgHeight: Integer;
    FLineHeight: Integer;
    FSelectWidth: Integer;
    FDlgInfo: array[0..7] of TDlgInfo;
    FName: string;
    procedure SetItem(const Value: TStrings);
    procedure SetOffset(const Value: Integer);
    procedure SetItemIndex(const Value: Integer);
    procedure SetVisible2(const Value: Boolean);
  public
    m_boClose: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function InRange(x, y: integer): Boolean; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean; override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    procedure Popup(Sender: TObject; nLeft, nTop: Integer; sName: string);
    property ItemIndex: Integer read FItemIndex write SetItemIndex;
    procedure RefSize();
    property ShowHeight: Integer read FHeight;
    property ShowWidth: Integer read FWidth;
  published
    property Item: TStrings read FItem write SetItem;
    property HeightOffset: Integer read FHeightOffset write SetOffset;
    property OnPopIndex: TOnPopIndex read FOnPopIndex write FOnPopIndex;
    property Alpha: Integer read FAlpha write FAlpha;
    property Visible: Boolean read FVisible write SetVisible2;
  end;

  TDTreeView = class(TDButton)
  private
    FTreeItem: TList;
    FUpDown: TDUpDown;
    FMaxHeight: Integer;
    FTreeNodesHeigh: Integer;
    FImageWidth: Integer;
    FOpenImageIdx: Integer;
    FCloseImageIdx: Integer;
    FboChange: Boolean;
    FDownY: Integer;
    FSelectTreeModes: pTDTreeNodes;
    FOnTreeViewSelect: TOnTreeViewSelect;
    FOnTreeClearItem: TOnTreeClearItem;
    procedure ClearTreeNodes(DTreeNodes: pTDTreeNodes);
    Function DelTreeNodes(TreeNodes: pTDTreeNodes; boMaster: Boolean): Boolean;
    procedure SetUpDown(const Value: TDUpDown);
    function GetTreeNodesHeight(DTreeNodes: pTDTreeNodes): Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClearItem;
    function DelItem(TreeNodes: pTDTreeNodes; boMaster: Boolean): Boolean;
    procedure RefHeight;
    function InRange(x, y: integer): Boolean; override;
    procedure DirectPaint(dsurface: TDirectDrawSurface); override;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean; override;
    function NewTreeNodes(sName: string): pTDTreeNodes;
    procedure PositionChange(Sender: TObject);
    function GetTreeNodes(DTreeNodes: pTDTreeNodes; sName: string; boAdd: Boolean): pTDTreeNodes;
    property TreeItem: TList read FTreeItem;
    property Select: pTDTreeNodes read FSelectTreeModes write FSelectTreeModes;
    property ImageOpenIndex: Integer read FOpenImageIdx write FOpenImageIdx;
    property ImageCloseIndex: Integer read FCloseImageIdx write FCloseImageIdx;
  published
    property UpDown: TDUpDown read FUpDown write SetUpDown;
    property OnTreeViewSelect: TOnTreeViewSelect read FOnTreeViewSelect write FOnTreeViewSelect;
    property OnTreeClearItem: TOnTreeClearItem read FOnTreeClearItem write FOnTreeClearItem;
    property ImageHeigh: Integer read FTreeNodesHeigh write FTreeNodesHeigh;
    property ImageWidth: Integer read FImageWidth write FImageWidth;
  end;
  
  TDWinManager = class(TComponent)
  private
  public
    DWinList: TList; 
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddDControl(dcon: TDControl; visible: Boolean);
    procedure DelDControl(dcon: TDControl);
    procedure CloseSurface();
    procedure CloseModalShow();
    procedure ClearAll;
                      //TMouseWheel = (mw_Down, mw_Up);
    function KeyPress(var Key: Char): Boolean;
    function KeyDown(var Key: Word; Shift: TShiftState): Boolean;
    function KeyUp(var Key: Word; Shift: TShiftState): Boolean;
    function MouseWheel(Shift: TShiftState; Wheel: TMouseWheel; X, Y: Integer): Boolean;
    function MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
    function MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
    function MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
    function DblClick(X, Y: integer): Boolean;
    function Click(X, Y: integer): Boolean;
    function EscClose(): Boolean;
    procedure DirectPaint(dsurface: TDirectDrawSurface);
  end;
procedure SetDFocus(dcon: TDControl);
procedure ReleaseDFocus;
procedure SetDCapture(dcon: TDControl);
procedure ReleaseDCapture;
procedure SetDKocus(dcon: TDControl);
procedure ReleaseDKocus;

var
  MouseCaptureControl: TDControl;
  FocusedControl: TDControl;
  KeyControl: TDControl;
  MainWinHandle: integer;
  FrmMainWinHandle: Integer;
  FrmShowIME: Boolean = False;
  FrmIMEX: Integer = 0;
  FrmIMEY: Integer = 0;
  HklKeyboardLayout: LongWord = 0;
  ModalDWindowList: TList;
  ModalDWindow: TDControl;
  TopDWindow: TDControl = nil;
  PopUpDWindow: TDControl = nil;
  MouseEntryControl: TDControl = nil;
  KeyDownControl: TDControl = nil;
  DrawCanvas: TDXDrawCanvas = nil;
  

implementation

uses
  Share
{$IFDEF MIRWIND}

  , ClMain, cliUtil;
{$ELSE}
  ;
{$ENDIF}

var
  ChrBuff: PChar;

function FiltrateStandardChar(Char1, Char2: Byte): Boolean;
begin
  Result := False;
  case Char1 of
    161: Result := (Char2 in [162..254]);
    162: Result := (Char2 in [161..170, 177..226, 229..238, 241..252]);
    163: Result := (Char2 in [161..254]);
    164: Result := (Char2 in [161..243]);
    165: Result := (Char2 in [161..246]);
    166: Result := (Char2 in [161..184, 193..216, 224..235, 238..242, 244, 245]);
    167: Result := (Char2 in [161..193, 209..241]);
    168: Result := (Char2 in [{64..126, }128..149, 161..187, 189, 190, 192, 197..233]);
    169: Result := (Char2 in [{64..90, 92, 96..126, }128..136, 150, 164..239]);
    176..214, 216..247: Result := (Char2 in [161..254]);
    215: Result := (Char2 in [161..249]);
  end;
end;

function FiltrateChar(Char1, Char2: Byte): Boolean;
begin
  Result := False;
  case Char1 of
    161: Result := (Char2 in [161..254]);
    162: Result := (Char2 in [161..170, 177..226, 229..238, 241..252]);
    163: Result := (Char2 in [161..254]);
    164: Result := (Char2 in [161..243]);
    165: Result := (Char2 in [161..246]);
    166: Result := (Char2 in [161..184, 193..216, 224..235, 238..242, 244, 245]);
    167: Result := (Char2 in [161..193, 209..241]);
    168: Result := (Char2 in [64..126, 128..149, 161..187, 189, 190, 192, 197..233]);
    169: Result := (Char2 in [64..90, 92, 96..126, 128..136, 150, 164..239]);
    176..214, 216..247: Result := (Char2 in [161..254]);
    215: Result := (Char2 in [161..249]);
    {129..160, 176..214, 216..247: Result := (Char2 in [64..126, 128..254]);
    161: Result := (Char2 in [162..254]);
    162: Result := (Char2 in [161..170, 177..226, 229..238, 241..252]);
    163: Result := (Char2 in [161..254]);
    164: Result := (Char2 in [161..243]);
    165: Result := (Char2 in [161..246]);
    166: Result := (Char2 in [161..184, 193..216, 224..235, 238..242, 244, 245]);
    167: Result := (Char2 in [161..193, 209..241]);
    168: Result := (Char2 in [64..126, 128..149, 161..187, 189, 190, 192, 197..233]);
    169: Result := (Char2 in [64..90, 92, 96..126, 128..136, 150, 164..239]);
    170..175, 248..253: Result := (Char2 in [64..126, 128..160]);
    215: Result := (Char2 in [64..126, 128..249]);
    254: Result := (Char2 in [64..79]); }
  end;
end;

function GetValidStr3(Str: string; var Dest: string; const Divider: array of
  Char): string;
const
  BUF_SIZE = 20480; 
var
  Buf: array[0..BUF_SIZE] of Char;
  BufCount, Count, SrcLen, i, ArrCount: LongInt;
  Ch: Char;
label
  CATCH_DIV;
begin
  Ch := #0; 
  try
    SrcLen := Length(Str);
    BufCount := 0;
    Count := 1;

    if SrcLen >= BUF_SIZE - 1 then begin
      Result := '';
      Dest := '';
      Exit;
    end;

    if Str = '' then begin
      Dest := '';
      Result := Str;
      Exit;
    end;
    ArrCount := SizeOf(Divider) div SizeOf(Char);

    while True do begin
      if Count <= SrcLen then begin
        Ch := Str[Count];
        for i := 0 to ArrCount - 1 do
          if Ch = Divider[i] then
            goto CATCH_DIV;
      end;
      if (Count > SrcLen) then begin
        CATCH_DIV:
        if (BufCount > 0) then begin
          if BufCount < BUF_SIZE - 1 then begin
            Buf[BufCount] := #0;
            Dest := string(Buf);
            Result := Copy(Str, Count + 1, SrcLen - Count);
          end;
          break;
        end
        else begin
          if (Count > SrcLen) then begin
            Dest := '';
            Result := Copy(Str, Count + 2, SrcLen - 1);
            break;
          end;
        end;
      end
      else begin
        if BufCount < BUF_SIZE - 1 then begin
          Buf[BufCount] := Ch;
          Inc(BufCount);
        end; 
        
      end;
      Inc(Count);
    end;
  except
    Dest := '';
    Result := '';
  end;
end;
{
procedure BoldTextOutEx(surface: TDirectDrawSurface; x, y, fcolor, bcolor:
  integer; str: string);
var
  nLen: Integer;
begin
  if str = '' then
    Exit;
  with surface do begin
    nLen := Length(str);
    Move(str[1], ChrBuff^, nlen);
    DrawCanvas.Font.Color := bcolor;
    TextOut(Canvas.Handle, x, y - 1, ChrBuff, nlen);
    TextOut(Canvas.Handle, x, y + 1, ChrBuff, nlen);
    TextOut(Canvas.Handle, x - 1, y, ChrBuff, nlen);
    TextOut(Canvas.Handle, x + 1, y, ChrBuff, nlen);
    TextOut(Canvas.Handle, x - 1, y - 1, ChrBuff, nlen);
    TextOut(Canvas.Handle, x + 1, y + 1, ChrBuff, nlen);
    TextOut(Canvas.Handle, x - 1, y + 1, ChrBuff, nlen);
    TextOut(Canvas.Handle, x + 1, y - 1, ChrBuff, nlen);
    DrawCanvas.Font.Color := fcolor;
    TextOut(Canvas.Handle, x, y, ChrBuff, nlen);
  end;
end;

procedure BoldTextOut(surface: TDirectDrawSurface; x, y, fcolor, bcolor:
  integer; str: string);
begin
  with surface do begin
    DrawCanvas.Font.Color := bcolor;
    DrawCanvas.TextOut(x - 1, y, str);
    DrawCanvas.TextOut(x + 1, y, str);
    DrawCanvas.TextOut(x, y - 1, str);
    DrawCanvas.TextOut(x, y + 1, str);
    DrawCanvas.Font.Color := fcolor;
    DrawCanvas.TextOut(x, y, str);
  end;
end;

procedure TextRectEx(surface: TDirectDrawSurface; var Rect: TRect; var Text: string; fcolor, bcolor: integer;
  TextFormat: TTextFormat = []);
var
  dc: TRect;
begin
  with Surface.Canvas do begin
    Font.Color := bcolor;
    dc := Rect;
    Rect.Left := Rect.Left - 1;
    Rect.Right := Rect.Right - 1;
    TextRect(Rect, Text, TextFormat);
    Rect := dc;
    Rect.Left := Rect.Left + 1;
    Rect.Right := Rect.Right + 1;
    TextRect(Rect, Text, TextFormat);
    Rect := dc;
    Rect.Top := Rect.Top - 1;
    Rect.Bottom := Rect.Bottom - 1;
    TextRect(Rect, Text, TextFormat);
    Rect := dc;
    Rect.Top := Rect.Top + 1;
    Rect.Bottom := Rect.Bottom + 1;
    TextRect(Rect, Text, TextFormat);
    Font.Color := fcolor;
    Rect := dc;
    TextRect(Rect, Text, TextFormat);
  end;

end;             }



procedure SetDKocus(dcon: TDControl);
begin
  if KeyControl <> dcon then begin
    if (KeyControl <> nil) then
      KeyControl.Leave;
    dcon.Enter;
  end;
  KeyControl := dcon;
end;

procedure ReleaseDKocus;
begin
  if (KeyControl <> nil) then begin
    KeyControl.Leave;
  end;
  KeyControl := nil;
end;



procedure SetDFocus(dcon: TDControl);
begin
  FocusedControl := dcon;
  if dcon.FKeyFocus then
    SetDKocus(dcon);
end;

procedure ReleaseDFocus;
begin
  FocusedControl := nil;
end;

procedure SetDCapture(dcon: TDControl);
begin
  SetCapture(MainWinHandle);
  MouseCaptureControl := dcon;
end;

procedure ReleaseDCapture;
begin
  ReleaseCapture;
  MouseCaptureControl := nil;
end;



constructor TDControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DParent := nil;
  inherited Visible := FALSE;
  FMouseFocus := True;
  FOnVisible := nil;
  FEnabled := True;

  //FSurface := nil;
  FAppendData := nil;
  AppendTick := GetTickCount;
  
  FOnMouseWheel := nil;
  FKeyFocus := False;
  Background := FALSE;
  FReadOnly := False;
  FOnDirectPaint := nil;
  FOnEndDirectPaint := nil;
  FOnKeyPress := nil;
  FOnKeyDown := nil;
  FOnMouseMove := nil;
  FOnMouseDown := nil;
  FOnMouseUp := nil;
  FOnInRealArea := nil;
  DControls := TList.Create;
  DTabControls := TList.Create;
  FDParent := nil;
  FWheelDControl := nil;

  Width := 80;
  Height := 24;
  FCaption := '';
  FVisible := TRUE;
  FIsHide := True;
  
  WLib := nil;
  FaceIndex := 0;

  FMouseEntry := msOut;
  FOnEnter := nil;
  FOnLeave := nil;

  FTabDControl := nil;

  FDFColor := $C5D2BD;
  FDFMoveColor := $C5D2BD;
  FDFEnabledColor := $C5D2BD;
  FDFDownColor := clWhite;
  FDFBackColor := $8;
end;

procedure TDControl.CreateSurface(Lib: TWMImages; boActive: Boolean; index: integer);
var
  d: TDirectDrawSurface;
begin
  if FSurface <> nil then
    FSurface.Free;
  FSurface := nil;
  if Lib <> nil then begin
    d := Lib.Images[index];
    if d <> nil then begin
      FSurface := TDXImageTexture.Create(DrawCanvas);
      FSurface.Size := d.Size;
      FSurface.PatternSize := d.Size;
      FSurface.Format := d.Format;
      FSurface.Active := boActive;
    end;
  end else begin
    FSurface := TDXImageTexture.Create(DrawCanvas);
    FSurface.Size := Point(Width, Height);
    FSurface.PatternSize := Point(Width, Height);
    FSurface.Format := D3DFMT_A4R4G4B4;
    FSurface.Active := boActive;
  end;
end;

destructor TDControl.Destroy;
begin
  DControls.Free;
  DTabControls.Free;
  if FSurface <> nil then
    FSurface.Free;
  FSurface := nil;
  inherited Destroy;
end;

function TDControl.Selected: Boolean;
begin
  Result := False;
end;

procedure TDControl.SetCaption(str: string);
begin
  FCaption := str;
  FChangeCaption := True;
  if csDesigning in ComponentState then begin
    Refresh;
  end;
end;

procedure TDControl.SetFocus;
begin
  SetDFocus(Self);
end;


procedure TDControl.Paint;
begin
  if csDesigning in ComponentState then begin
    if self is TDWindow then begin
      with Canvas do begin
        Pen.Color := clBlack;
        MoveTo(0, 0);
        LineTo(Width - 1, 0);
        LineTo(Width - 1, Height - 1);
        LineTo(0, Height - 1);
        LineTo(0, 0);
        LineTo(Width - 1, Height - 1);
        MoveTo(Width - 1, 0);
        LineTo(0, Height - 1);
        TextOut((Width - TextWidth(Caption)) div 2, (Height -
          TextHeight(Caption)) div 2, Caption);
      end;
    end
    else begin
      with Canvas do begin
        Pen.Color := clBlack;
        MoveTo(0, 0);
        LineTo(Width - 1, 0);
        LineTo(Width - 1, Height - 1);
        LineTo(0, Height - 1);
        LineTo(0, 0);
        SetBkMode(Handle, TRANSPARENT);
        Font.Color := self.Font.Color;
        TextOut((Width - TextWidth(Caption)) div 2, (Height -
          TextHeight(Caption)) div 2, Caption);
      end;
    end;
  end;
end;

procedure TDControl.Leave();
begin
  if Assigned(FOnLeave) then
    FOnLeave(Self);
end;

procedure TDControl.Loaded;
var
  i: integer;
  dcon: TDControl;
begin
  if not (csDesigning in ComponentState) then begin
    if Parent <> nil then
      for i := 0 to TControl(Parent).ComponentCount - 1 do begin
        if TControl(Parent).Components[i] is TDControl then begin
          dcon := TDControl(TControl(Parent).Components[i]);
          if dcon.DParent = self then begin
            AddChild(dcon);
          end;
        end;
      end;
  end;
end;



function TDControl.SurfaceX(x: integer): integer;
var
  d: TDControl;
begin
  d := self;
  while TRUE do begin
    if d.DParent = nil then
      break;
    x := x + d.DParent.Left;
    d := d.DParent;
  end;
  Result := x;
end;

function TDControl.SurfaceY(y: integer): integer;
var
  d: TDControl;
begin
  d := self;
  while TRUE do begin
    if d.DParent = nil then
      break;
    y := y + d.DParent.Top;
    d := d.DParent;
  end;
  Result := y;
end;



function TDControl.LocalX(x: integer): integer;
var
  d: TDControl;
begin
  d := self;
  while TRUE do begin
    if d.DParent = nil then
      break;
    x := x - d.DParent.Left;
    d := d.DParent;
  end;
  Result := x;
end;

function TDControl.LocalY(y: integer): integer;
var
  d: TDControl;
begin
  d := self;
  while TRUE do begin
    if d.DParent = nil then
      break;
    y := y - d.DParent.Top;
    d := d.DParent;
  end;
  Result := y;
end;

procedure TDControl.AddChild(dcon: TDControl);
begin
  
  DControls.Add(Pointer(dcon));

  if dcon is TDEdit then begin
    DTabControls.Add(Pointer(dcon));
  end;
  
end;

procedure TDControl.ChangeChildOrder(dcon: TDControl);
var
  i: integer;
  DWindow: TDWindow;
begin
  if not (dcon is TDWindow) then
    exit;
  DWindow := TDWindow(dcon);
  if DWindow.FControlStyle = dsBottom then exit;
  for i := 0 to DControls.Count - 1 do begin
    if dcon = DControls[i] then begin
      DControls.Delete(i);
      break;
    end;
  end;
  if DWindow.FControlStyle = dsTop then begin
    DControls.Add(dcon);
    exit;
  end
  else if DWindow.FControlStyle = dsNone then begin
    for i := DControls.Count - 1 downto 0 do begin
      if TDControl(DControls[i]) is TDWindow then begin
        DWindow := TDWindow(DControls[i]);
        if (DWindow.FControlStyle <> dsTop) then begin
          if i = (DControls.Count - 1) then
            DControls.Add(dcon)
          else begin
            DControls.Insert(i + 1, dcon);
          end;
          exit;
        end;
      end;
    end;
  end;
  DControls.Add(dcon);
end;

function TDControl.CheckTab: Boolean;
var
  TabControl, TopControl: TDControl;
  I: Integer;
  boMy: Boolean;
begin
  boMy := False;
  Result := False;
  TopControl := nil;
  if DParent = nil then
    exit;
  for I := 0 to DParent.DTabControls.Count - 1 do begin
    TabControl := TDControl(DParent.DTabControls.Items[I]);
    if (TopControl = nil) and (TabControl.Visible) then
      TopControl := TabControl;
    if not boMy then begin
      if TabControl = self then
        boMy := True;
    end
    else begin
      if TabControl.Visible then begin
        TabControl.SetFocus;
        exit;
      end;
    end;
  end;
  if TopControl <> nil then
    TopControl.SetFocus;

end;

function TDControl.InRange(x, y: integer): Boolean;
var
  boinrange: Boolean;
  d: TDirectDrawSurface;
begin
  if  (x >= Left) and (x < Left + Width) and (y >= Top) and (y < Top + Height) then begin
    boinrange := TRUE;
    if Assigned(FOnInRealArea) then
      FOnInRealArea(self, x - Left, y - Top, boinrange)
    else if WLib <> nil then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        if d.Pixels[x - Left, y - Top] <= 0 then
          boinrange := FALSE;
    end;
    Result := boinrange;
  end
  else
    Result := FALSE;
end;

procedure TDControl.IsVisible(flag: Boolean);
var
  I: Integer;
begin
  for i := 0 to DControls.Count - 1 do
    TDControl(DControls[i]).IsVisible(flag);
  FIsHide := not flag;
  if not (csReading in ComponentState) then begin
    if Assigned(FOnVisible) then
      FOnVisible(Self, flag);
  end;
end;

function TDControl.KeyPress(var Key: Char): Boolean;
begin
  Result := FALSE;
  
  if (KeyControl = self) then begin
    if Assigned(FOnKeyPress) then
      FOnKeyPress(self, Key);
    Result := TRUE;
  end;
end;

function TDControl.KeyUp(var Key: Word; Shift: TShiftState): Boolean;
begin
  Result := FALSE;
  
  if (KeyControl = self) then begin
    if Assigned(FOnKeyUp) then
      FOnKeyUp(self, Key, Shift);
    Result := TRUE;
  end;
end;

function TDControl.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
begin
  Result := FALSE;
  if (KeyControl = self) then begin
    KeyDownControl := Self;
    if Assigned(FOnKeyDown) then
      FOnKeyDown(self, Key, Shift);
    Result := TRUE;
  end;
end;

function TDControl.CanFocusMsg: Boolean;
begin
  if (MouseCaptureControl = nil) or ((MouseCaptureControl <> nil) and
    ((MouseCaptureControl = self) or (MouseCaptureControl = DParent))) then
    Result := TRUE
  else
    Result := FALSE;
end;

function TDControl.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  i: integer;
begin
  Result := FALSE;
  for i := DControls.Count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).MouseMove(Shift, X - Left, Y - Top) then begin
        Result := TRUE;
        exit;
      end;

  if (MouseCaptureControl <> nil) then begin
    if (MouseCaptureControl = self) then begin
      if Assigned(FOnMouseMove) then
        FOnMouseMove(self, Shift, X, Y);
      Result := TRUE;
    end;
    exit;
  end;

  if Background then begin
    if (MouseEntryControl <> nil) and (MouseEntryControl <> self) then begin
      MouseEntryControl.FMouseEntry := msOut;
      if Assigned(MouseEntryControl.FOnMouseEntry) then
        MouseEntryControl.FOnMouseEntry(MouseEntryControl,
          MouseEntryControl.FMouseEntry);
      MouseEntryControl := nil;
    end;
    if (MouseEntryControl = nil) then begin
      MouseEntryControl := Self;
      FMouseEntry := msIn;
      if Assigned(FOnMouseEntry) then
        FOnMouseEntry(Self, FMouseEntry);
    end;
    exit;
  end;
  if InRange(X, Y) then begin
    if (MouseEntryControl <> nil) and (MouseEntryControl <> self) then begin
      MouseEntryControl.FMouseEntry := msOut;
      if Assigned(MouseEntryControl.FOnMouseEntry) then
        MouseEntryControl.FOnMouseEntry(MouseEntryControl,
          MouseEntryControl.FMouseEntry);
      MouseEntryControl := nil;
    end;
    if (MouseEntryControl = nil) then begin
      MouseEntryControl := Self;
      FMouseEntry := msIn;
      if Assigned(FOnMouseEntry) then
        FOnMouseEntry(MouseEntryControl, FMouseEntry);
    end;
    if Assigned(FOnMouseMove) then
      FOnMouseMove(self, Shift, X, Y);
    Result := TRUE;
  end;
end;

function TDControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  i: integer;
begin
  Result := FALSE;
  for i := DControls.Count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).MouseDown(Button, Shift, X - Left, Y - Top) then begin
        Result := TRUE;
        exit;
      end;
  if Background then begin
    if Assigned(FOnBackgroundClick) then begin
      WantReturn := FALSE;
      FOnBackgroundClick(self);
      if WantReturn then
        Result := TRUE;
    end;
    ReleaseDFocus;
    exit;
  end;
  if CanFocusMsg then begin
    if InRange(X, Y) or (MouseCaptureControl = self) then begin
      if Assigned(FOnMouseDown) then
        FOnMouseDown(self, Button, Shift, X, Y);
      if FMouseFocus  then
        SetDFocus(self);
      Result := TRUE;
    end;
  end;
end;

function TDControl.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y:
  Integer): Boolean;
var
  i: integer;
begin
  Result := FALSE;
  for i := DControls.Count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).MouseUp(Button, Shift, X - Left, Y - Top) then begin
        Result := TRUE;
        exit;
      end;

  if (MouseCaptureControl <> nil) then begin
    if (MouseCaptureControl = self) then begin
      if Assigned(FOnMouseUp) then
        FOnMouseUp(self, Button, Shift, X, Y);
      Result := TRUE;
    end;
    exit;
  end;

  if Background then
    exit;
  if InRange(X, Y) then begin
    if Assigned(FOnMouseUp) then
      FOnMouseUp(self, Button, Shift, X, Y);
    Result := TRUE;
  end;
end;

function TDControl.MouseWheel(Shift: TShiftState; Wheel: TMouseWheel; X, Y: Integer): Boolean;
var
  i: integer;
begin
  Result := False;
  for i := DControls.Count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).MouseWheel(Shift, Wheel, X - Left, Y - Top) then begin
        Result := TRUE;
        exit;
      end;

  if FWheelDControl <> nil then begin
    FWheelDControl.MouseWheel(Shift, Wheel, X - Left, Y - Top);
    Result := True;
  end;
end;

function TDControl.DblClick(X, Y: integer): Boolean;
var
  i: integer;
begin
  Result := FALSE;
  if (MouseCaptureControl <> nil) then begin 
    if (MouseCaptureControl = self) then begin
      if Assigned(FOnDblClick) then
        FOnDblClick(self);
      Result := TRUE;
    end;
    exit;
  end;
  for i := DControls.Count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).DblClick(X - Left, Y - Top) then begin
        Result := TRUE;
        exit;
      end;
  if Background then
    exit;
  if InRange(X, Y) then begin
    if Assigned(FOnDblClick) then
      FOnDblClick(self);
    Result := TRUE;
  end;
end;

function TDControl.Click(X, Y: integer): Boolean;
var
  i: integer;
begin
  Result := FALSE;
  if (MouseCaptureControl <> nil) then begin 
    if (MouseCaptureControl = self) then begin
      if Assigned(FOnClick) then
        FOnClick(self, X, Y);
      Result := TRUE;
    end;
    exit;
  end;
  for i := DControls.Count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).Click(X - Left, Y - Top) then begin
        Result := TRUE;
        exit;
      end;
  if Background then
    exit;
  if InRange(X, Y) then begin
    if Assigned(FOnClick) then
      FOnClick(self, X, Y);
    Result := TRUE;
  end;
end;

procedure TDControl.CloseSurface;
var
  i: integer;
begin
  for i := DControls.Count - 1 downto 0 do
    TDControl(DControls[i]).CloseSurface();

  if FSurface <> nil then begin
    FSurface.Free;
    FSurface := nil;
  end;
end;

procedure TDControl.SetImgIndex(Lib: TWMImages; index: integer);
var
  d: TDirectDrawSurface;
begin
  
  if Lib <> nil then begin
    d := Lib.Images[index];
    WLib := Lib;
    FaceIndex := index;
    if d <> nil then begin
      Width := d.Width;
      Height := d.Height;
    end;
  end;
end;

{
procedure TDControl.SetSurface(DDraw: TDirectDraw; Lib: TWMImages; index:
  integer);
var
  d: TDirectDrawSurface;
begin
  if FSurface <> nil then
    FSurface.Free;
  FSurface := nil;
  if DDraw <> nil then begin
    if Lib <> nil then begin
      d := Lib.Images[index];
      if d <> nil then begin
        FSurface := TDirectDrawSurface.Create(DDraw);
        FSurface.SystemMemory := True;
        FSurface.Canvas.Font.Name := DEFFONTNAME;
        FSurface.Canvas.Font.Size := DEFFONTSIZE;
        FSurface.SetSize(d.Width, d.Height);
        FSurface.Draw(0, 0, d.ClientRect, d, True);
      end;
    end
    else begin
      FSurface := TDirectDrawSurface.Create(DDraw);
      FSurface.SystemMemory := True;
      FSurface.Canvas.Font.Name := DEFFONTNAME;
      FSurface.Canvas.Font.Size := DEFFONTSIZE;
      FSurface.SetSize(Width, Height);
      FSurface.Fill(0);
    end;
  end;
end;        }

procedure TDControl.SetVisible(flag: Boolean);
begin
  if FVisible <> flag then
    IsVisible(flag);
  FVisible := flag;
end;

procedure TDControl.DirectPaint(dsurface: TDirectDrawSurface);
var
  i: integer;
  d: TDirectDrawSurface;
begin
  if Assigned(FOnDirectPaint) then
    FOnDirectPaint(self, dsurface)
  else if WLib <> nil then begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
  end;
  for i := 0 to DControls.Count - 1 do
    if TDControl(DControls[i]).Visible then
      TDControl(DControls[i]).DirectPaint(dsurface);

  if Assigned(FOnEndDirectPaint) then
    FOnEndDirectPaint(self, dsurface);
end;

procedure TDControl.Enter();
begin
  if Assigned(FOnEnter) then
    FOnEnter(Self)
end;



function TDControl.EscClose: Boolean;
var
  i: integer;
begin
  Result := FALSE;
  for i := DControls.Count - 1 downto 0 do
    if TDControl(DControls[i]).Visible then
      if TDControl(DControls[i]).EscClose then begin
        Result := TRUE;
        exit;
      end;
end;

constructor TDButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Downed := FALSE;
  FOnClick := nil;
  
  
  FClickSound := csNone;
end;

function TDButton.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if (not Background) and (not Result) then begin
    Result := inherited MouseMove(Shift, X, Y);
    if MouseCaptureControl = self then
      if InRange(X, Y) then
        Downed := TRUE
      else
        Downed := FALSE;
  end;
end;

procedure TDButton.DirectPaint(dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  FColor: TColor;
  i: integer;
begin
  if Assigned(FOnDirectPaint) then
    FOnDirectPaint(self, dsurface)
  else if WLib <> nil then begin
    if not FEnabled then begin
      d := WLib.Images[FaceIndex + 3];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
      FColor := FDFEnabledColor;
    end
    else if Downed then begin
      d := WLib.Images[FaceIndex + 2];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
      FColor := FDFDownColor;
    end
    else if MouseEntry = msIn then begin
      d := WLib.Images[FaceIndex + 1];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
      FColor := FDFMoveColor;
    end
    else begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
      FColor := FDFColor;
    end;
    with DrawCanvas do begin
      TextOut(SurfaceX(Left) + (Width - TextWidth(Caption)) div 2,
        SurfaceY(Top) + (Height - TextHeight(Caption)) div 2, Caption, FColor);
    end;
    {with dsurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      BoldTextOutEx(dsurface, SurfaceX(Left) + (Width - TextWidth(Caption)) div 2,
        SurfaceY(Top) + (Height - TextHeight(Caption)) div 2, FColor, FDFBackColor, Caption);
      Release;
    end; }
  end;
  for i := 0 to DControls.Count - 1 do
    if TDControl(DControls[i]).Visible then
      TDControl(DControls[i]).DirectPaint(dsurface);
  if Assigned(FOnEndDirectPaint) then
    FOnEndDirectPaint(self, dsurface);
end;

function TDButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := FALSE;
  if inherited MouseDown(Button, Shift, X, Y) and FEnabled then begin
    if (not Background) and (MouseCaptureControl = nil) then begin
      Downed := TRUE;
      SetDCapture(self);
    end;
    Result := TRUE;
  end;
end;

function TDButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y:
  Integer): Boolean;
begin
  Result := FALSE;
  if inherited MouseUp(Button, Shift, X, Y) and FEnabled then begin
    ReleaseDCapture;
    if not Background then begin
      if Downed and InRange(X, Y) then begin
        if Assigned(FOnClickSound) then
          FOnClickSound(self, FClickSound);
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
      end;
    end;
    Downed := FALSE;
    Result := TRUE;
    exit;
  end
  else begin
    ReleaseDCapture;
    Downed := FALSE;
  end;
end;



constructor TDGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColCount := 8;
  FRowCount := 5;
  FColWidth := 36;
  FRowHeight := 32;
  FOnGridSelect := nil;
  FOnGridMouseMove := nil;
  FOnGridPaint := nil;
  FColoffset := 0;
  FRowoffset := 0;
  FSelectCell.X := -1;
  FSelectCell.Y := -1;
end;

function TDGrid.GetColRow(x, y: integer; var acol, arow: integer): Boolean;
var
  nX, nY: Integer;
begin
  Result := FALSE;
  if InRange(x, y) then begin
    nX := x - Left;
    nY := y - Top;
    acol := nX div (FColWidth + FColoffset);
    arow := nY div (FRowHeight + FRowoffset);
    if (nX - (FColWidth + FColoffset) * (acol) - FColWidth <= 0) and
      (nY - (FRowHeight + FRowoffset) * (arow) - FRowHeight <= 0) then
      Result := TRUE;
  end;
end;

function TDGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y:
  Integer): Boolean;
var
  acol, arow: integer;
begin
  Result := FALSE;
  if mbLeft = Button then begin
    if GetColRow(X, Y, acol, arow) then begin
      FSelectCell.X := acol;
      FSelectCell.Y := arow;
      DownPos.X := X;
      DownPos.Y := Y;
      SetDCapture(self);
      Result := TRUE;
    end;
  end;
end;

function TDGrid.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  acol, arow: integer;
begin
  Result := FALSE;
  if InRange(X, Y) then begin
    if GetColRow(X, Y, acol, arow) then begin
      if Assigned(FOnGridMouseMove) then
        FOnGridMouseMove(Self, X, Y, acol, arow, Shift);
    end;
    Result := TRUE;
  end;
end;

function TDGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  acol, arow: integer;
begin
  Result := FALSE;
  if mbLeft = Button then begin
    if GetColRow(X, Y, acol, arow) then begin
      if (FSelectCell.X = acol) and (FSelectCell.Y = arow) then begin
        Col := acol;
        Row := arow;
        if Assigned(FOnGridSelect) then
          FOnGridSelect(Self, X, Y, acol, arow, Shift);
      end;
      Result := TRUE;
    end;
    ReleaseDCapture;
    FSelectCell.X := -1;
    FSelectCell.Y := -1;
  end;
end;

function TDGrid.Click(X, Y: integer): Boolean;
begin
  Result := FALSE;
  
end;

procedure TDGrid.DirectPaint(dsurface: TDirectDrawSurface);
var
  i, j: integer;
  rc: TRect;
begin
  if Assigned(FOnGridPaint) then
    for i := 0 to FRowCount - 1 do
      for j := 0 to FColCount - 1 do begin
        rc.Top := Top + i * FRowHeight + i * FRowoffset;
        rc.Left := Left + j * FColWidth + j * FColoffset;
        rc.Right := rc.Left + FColWidth;
        rc.Bottom := rc.Top + FRowHeight;

        if (FSelectCell.Y = i) and (FSelectCell.X = j) then
          FOnGridPaint(self, j, i, rc, [gdSelected], dsurface)
        else
          FOnGridPaint(self, j, i, rc, [], dsurface);
      end;
end;



constructor TDWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFloating := FALSE;
  FEscClose := False;
  
  Width := 120;
  Height := 120;
  FControlStyle := dsNone;
end;

procedure TDWindow.SetVisible(flag: Boolean);
begin
  if FVisible <> flag then begin
    IsVisible(flag);
    if flag and FMouseFocus  then
      SetDFocus(self)
    else
    if FocusedControl = self then
      ReleaseDFocus
  end;
  FVisible := flag;
  
  if DParent <> nil then
    DParent.ChangeChildOrder(self);


end;

function TDWindow.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  al, at: integer;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Result and FFloating and (MouseCaptureControl = self) and (ssLeft in Shift) then begin
    if (SpotX <> X) or (SpotY <> Y) then begin
      al := Left + (X - SpotX);
      at := Top + (Y - SpotY);
      if al + Width < WINLEFT then
        al := WINLEFT - Width;
      if al > WINRIGHT then
        al := WINRIGHT;
      if at + Height < WINTOP then
        at := WINTOP - Height;
      if at  > BOTTOMEDGE then
        at := BOTTOMEDGE ;
      Left := al;
      Top := at;
      SpotX := X;
      SpotY := Y;
    end;
  end;
end;

procedure TDWindow.DirectPaint(dsurface: TDirectDrawSurface);
var
  i: integer;
  d: TDirectDrawSurface;
begin
  if Assigned(FOnDirectPaint) then
    FOnDirectPaint(self, dsurface)
  else if WLib <> nil then begin
    d := WLib.Images[FaceIndex];
    if d <> nil then
      dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
  end;
  for i := 0 to DControls.Count - 1 do
    if TDControl(DControls[i]).Visible then
      TDControl(DControls[i]).DirectPaint(dsurface);

  if Assigned(FOnEndDirectPaint) then
    FOnEndDirectPaint(self, dsurface);
end;

function TDWindow.EscClose: Boolean;
begin
  Result := inherited EscClose;
  if (not Result) and FEscClose then begin
    Visible := False;
    Result := True;
  end;
end;

function TDWindow.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y:
  Integer): Boolean;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
  if Result then begin
    
    if DParent <> nil then
      DParent.ChangeChildOrder(self);
    
    SpotX := X;
    SpotY := Y;
  end;
end;

function TDWindow.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y:
  Integer): Boolean;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
end;

procedure TDWindow.Show;
begin
  Visible := TRUE;
  
  if DParent <> nil then
    DParent.ChangeChildOrder(self);
  
  if FMouseFocus  then
    SetDFocus(self);
end;

procedure TDWindow.TopShow();
begin
  Show;
  TopDWindow := self;
end;

function TDWindow.ShowModal: integer;
begin
  Result := 0; 
  Visible := TRUE;
  ModalDWindow := self;
  if FMouseFocus  then
    SetDFocus(self);
end;



constructor TDWinManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DWinList := TList.Create;
  MouseCaptureControl := nil;
  FocusedControl := nil;
  KeyControl := nil;
  MouseEntryControl := nil;
  ModalDWindow := nil;
end;

destructor TDWinManager.Destroy;
begin
  inherited Destroy;
end;

procedure TDWinManager.ClearAll;
begin
  DWinList.Clear;
end;

procedure TDWinManager.AddDControl(dcon: TDControl; visible: Boolean);
begin
  dcon.Visible := visible;
  DWinList.Add(dcon);
end;

procedure TDWinManager.DelDControl(dcon: TDControl);
var
  i: integer;
begin
  for i := 0 to DWinList.Count - 1 do
    if DWinList[i] = dcon then begin
      DWinList.Delete(i);
      break;
    end;
end;

function TDWinManager.KeyPress(var Key: Char): Boolean;
begin
  Result := FALSE;
  
  if Key = #9 then begin
    if KeyControl <> nil then begin
      if KeyControl.Visible and KeyControl.Enabled and (not KeyControl.IsHide) then begin
        if KeyControl.CheckTab then begin

        end;
      end
      else
        ReleaseDKocus;
    end;
  end;
  if KeyDownControl <> nil then begin
    if KeyDownControl.Visible and KeyDownControl.Enabled and (not KeyDownControl.IsHide) then
      KeyDownControl.KeyPress(Key);
    Result := True;
  end else
  if KeyControl <> nil then begin
    if KeyControl.Visible and KeyControl.Enabled and (not KeyControl.IsHide) then
      Result := KeyControl.KeyPress(Key)
    else
      ReleaseDKocus;
  end;
end;

function TDWinManager.KeyUp(var Key: Word; Shift: TShiftState): Boolean;
begin
  Result := FALSE;
  if KeyDownControl <> nil then begin
    if KeyDownControl.Visible and KeyDownControl.Enabled and (not KeyDownControl.IsHide) then
      KeyDownControl.KeyUp(Key, Shift);
    Result := True;
  end else
  if KeyControl <> nil then begin
    if KeyControl.Visible and KeyControl.Enabled and (not KeyControl.IsHide) then
      Result := KeyControl.KeyUp(Key, Shift)
    else
      ReleaseDKocus;
  end;
  KeyDownControl := nil;
end;

function TDWinManager.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
begin
  Result := FALSE;
  if KeyControl <> nil then begin
    if KeyControl.Visible and KeyControl.Enabled and (not KeyControl.IsHide) then
      Result := KeyControl.KeyDown(Key, Shift)
    else
      ReleaseDKocus;
  end else
  if Key = 27 then begin
    Result := EscClose;
  end;
end;

function TDWinManager.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  i: integer;
  MDWindow: TDModalWindow;
begin
  Result := FALSE;

  if PopUpDWindow <> nil then begin
    if PopUpDWindow.Visible then begin
      with PopUpDWindow do
        MouseMove(Shift, LocalX(X), LocalY(Y));
      Result := True;
      exit;
    end
    else
      PopUpDWindow := nil;
  end;

  if ModalDWindowList.Count > 0 then begin
    for I := ModalDWindowList.Count - 1 downto 0 do begin
      MDWindow := TDModalWindow(ModalDWindowList[i]);
      if MDWindow.Visible then begin
        with MDWindow do
          MouseMove(Shift, LocalX(X), LocalY(Y));
        Result := TRUE;
        exit;
      end else ModalDWindowList.delete(i);
    end;
  end;

  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        MouseMove(Shift, LocalX(X), LocalY(Y));
      Result := TRUE;
      exit;
    end
    else
      MOdalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := MouseMove(Shift, LocalX(X), LocalY(Y));
  end
  else
    for i := 0 to DWinList.Count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).MouseMove(Shift, X, Y) then begin
          Result := TRUE;
          break;
        end;
      end;
    end;
end;

function TDWinManager.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y:
  Integer): Boolean;
var
  i: integer;
  MDWindow: TDModalWindow;
begin
  Result := FALSE;
  if PopUpDWindow <> nil then begin
    if PopUpDWindow.Visible then begin
      with PopUpDWindow do
        MouseDown(Button, Shift, LocalX(X), LocalY(Y));
      Result := TRUE;
      exit;
    end else PopUpDWindow := nil;
  end;
  {if PopUpDWindow <> nil then begin
    if PopUpDWindow.Visible then begin
      with PopUpDWindow do
        Result := MouseDown(Button, Shift, LocalX(X), LocalY(Y));
    end;
    if not Result then begin
      PopUpDWindow.Visible := False;
      PopUpDWindow := nil;
    end
    else
      exit;
  end;    }
  {if PopUpDWindow <> nil then begin
    if PopUpDWindow.Visible then begin
      with PopUpDWindow do
        MouseDown(Button, Shift, LocalX(X), LocalY(Y));
      if not Result then begin
        PopUpDWindow.Visible := False;
        PopUpDWindow := nil;
      end;
      Result := True;
      exit;
    end else
      PopUpDWindow := nil;
  end;      }

  if ModalDWindowList.Count > 0 then begin
    for I := ModalDWindowList.Count - 1 downto 0 do begin
      MDWindow := TDModalWindow(ModalDWindowList[i]);
      if MDWindow.Visible then begin
        with MDWindow do
          MouseDown(Button, Shift, LocalX(X), LocalY(Y));
        Result := TRUE;
        exit;
      end else ModalDWindowList.delete(i);
    end;
  end;

  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        MouseDown(Button, Shift, LocalX(X), LocalY(Y));
      Result := TRUE;
      exit;
    end
    else
      ModalDWindow := nil;
  end;

  if TopDWindow <> nil then begin
    if TopDWindow.Visible then begin
      with TopDWindow do
        MouseDown(Button, Shift, LocalX(X), LocalY(Y));
      Result := TRUE;
      exit;
    end else TopDWindow := nil;
  end;

  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := MouseDown(Button, Shift, LocalX(X), LocalY(Y));
  end
  else
    for i := 0 to DWinList.Count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).MouseDown(Button, Shift, X, Y) then begin
          Result := TRUE;
          break;
        end;
      end;
    end;
end;

function TDWinManager.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
var
  i: integer;
  MDWindow: TDModalWindow;
begin
  Result := TRUE;
  if PopUpDWindow <> nil then begin
    if PopUpDWindow.Visible then begin
      with PopUpDWindow do
        Result := MouseUp(Button, Shift, LocalX(X), LocalY(Y));
      if not Result then begin
        Result := True;
        with PopUpDWindow as TDPopupMemu do begin
          if m_boClose then begin
            ReleaseDCapture;
            if MouseEntryControl <> nil then begin
              MouseEntryControl.FMouseEntry := msOut;
              if Assigned(MouseEntryControl.FOnMouseEntry) then
                MouseEntryControl.FOnMouseEntry(MouseEntryControl, MouseEntryControl.FMouseEntry);
            end;
            MouseEntryControl := PopUpDWindow;
            m_boClose := False;
            exit;
          end;
          PopUpDWindow.Visible := False;
          PopUpDWindow := nil;
        end;
      end;
      exit;
    end else PopUpDWindow := nil;
  end;
  {if PopUpDWindow <> nil then begin
    if PopUpDWindow.Visible then begin
      with PopUpDWindow do
        Result := MouseUp(Button, Shift, LocalX(X), LocalY(Y));
      if Result then
        exit;
    end
    else
      PopUpDWindow := nil;
  end;     }
  {if PopUpDWindow <> nil then begin
    if PopUpDWindow.Visible then begin
      with PopUpDWindow do
        MouseUp(Button, Shift, LocalX(X), LocalY(Y));
      exit;
    end
    else
      PopUpDWindow := nil;
  end;  }

  if ModalDWindowList.Count > 0 then begin
    for I := ModalDWindowList.Count - 1 downto 0 do begin
      MDWindow := TDModalWindow(ModalDWindowList[i]);
      if MDWindow.Visible then begin
        with MDWindow do
          Result := MouseUp(Button, Shift, LocalX(X), LocalY(Y));
        exit;
      end else ModalDWindowList.delete(i);
    end;
  end;

  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        Result := MouseUp(Button, Shift, LocalX(X), LocalY(Y));
      exit;
    end
    else
      ModalDWindow := nil;
  end;

  if TopDWindow <> nil then begin
    if TopDWindow.Visible then begin
      with TopDWindow do
        Result := MouseUp(Button, Shift, LocalX(X), LocalY(Y));
      if not Result then begin
        Result := True;
        TopDWindow.Visible := False;
        TopDWindow := nil;
      end;
      exit;
    end else TopDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := MouseUp(Button, Shift, LocalX(X), LocalY(Y));
  end
  else
    for i := 0 to DWinList.Count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).MouseUp(Button, Shift, X, Y) then begin
          Result := TRUE;
          break;
        end;
      end;
    end;
end;

function TDWinManager.MouseWheel(Shift: TShiftState; Wheel: TMouseWheel; X, Y: Integer): Boolean;
var
  i: integer;
  MDWindow: TDModalWindow;
begin
  Result := FALSE;

  if PopUpDWindow <> nil then begin
    if PopUpDWindow.Visible then begin
      with PopUpDWindow do
        Result := MouseWheel(Shift, Wheel, LocalX(X), LocalY(Y));
    end
    else
      PopUpDWindow := nil;
    if Result then
      Exit;
  end;

  if ModalDWindowList.Count > 0 then begin
    for I := ModalDWindowList.Count - 1 downto 0 do begin
      MDWindow := TDModalWindow(ModalDWindowList[i]);
      if MDWindow.Visible then begin
        with MDWindow do
          MouseWheel(Shift, Wheel, LocalX(X), LocalY(Y));
        Result := TRUE;
        exit;
      end else ModalDWindowList.delete(i);
    end;
  end;

  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        MouseWheel(Shift, Wheel, LocalX(X), LocalY(Y));
      Result := TRUE;
      exit;
    end
    else
      MOdalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := MouseWheel(Shift, Wheel, LocalX(X), LocalY(Y));
  end
  else
  if FocusedControl <> nil then begin
    with FocusedControl do
      Result := MouseWheel(Shift, Wheel, LocalX(X), LocalY(Y));
  end;

    {for i := 0 to DWinList.Count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).MouseWheel(Shift, Wheel, X, Y) then begin
          Result := TRUE;
          break;
        end;
      end;
    end;   }
end;

function TDWinManager.DblClick(X, Y: integer): Boolean;
var
  i: integer;
  MDWindow: TDModalWindow;
begin
  Result := TRUE;

  if ModalDWindowList.Count > 0 then begin
    for I := ModalDWindowList.Count - 1 downto 0 do begin
      MDWindow := TDModalWindow(ModalDWindowList[i]);
      if MDWindow.Visible then begin
        with MDWindow do
          Result := DblClick(LocalX(X), LocalY(Y));
        exit;
      end else ModalDWindowList.delete(i);
    end;
  end;

  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        Result := DblClick(LocalX(X), LocalY(Y));
      exit;
    end
    else
      ModalDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := DblClick(LocalX(X), LocalY(Y));
  end
  else
    for i := 0 to DWinList.Count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).DblClick(X, Y) then begin
          Result := TRUE;
          break;
        end;
      end;
    end;
end;

function TDWinManager.Click(X, Y: integer): Boolean;
var
  i: integer;
  MDWindow: TDModalWindow;
begin
  Result := TRUE;

  if ModalDWindowList.Count > 0 then begin
    for I := ModalDWindowList.Count - 1 downto 0 do begin
      MDWindow := TDModalWindow(ModalDWindowList[i]);
      if MDWindow.Visible then begin
        with MDWindow do
          Result := Click(LocalX(X), LocalY(Y));
        exit;
      end else ModalDWindowList.delete(i);
    end;
  end;

  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      with ModalDWindow do
        Result := Click(LocalX(X), LocalY(Y));
      exit;
    end
    else
      ModalDWindow := nil;
  end;
  if TopDWindow <> nil then begin
    if TopDWindow.Visible then begin
      with TopDWindow do
        Click(LocalX(X), LocalY(Y));
      exit;
    end else TopDWindow := nil;
  end;
  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := Click(LocalX(X), LocalY(Y));
  end
  else
    for i := 0 to DWinList.Count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).Click(X, Y) then begin
          Result := TRUE;
          break;
        end;
      end;
    end;
end;

procedure TDWinManager.CloseModalShow();
var
  i: integer;
begin
  for I := 0 to ModalDWindowList.Count - 1 do begin
    TDModalWindow(ModalDWindowList[i]).Visible := False;
  end;
  ModalDWindowList.Clear;
  if ModalDWindow <> nil then begin
    ModalDWindow.Visible := False;
    ModalDWindow := nil;
  end;
end;

procedure TDWinManager.CloseSurface;
var
  i: integer;
begin
  if PopUpDWindow <> nil then begin
    if PopUpDWindow.Visible then PopUpDWindow.Visible := False;
    PopUpDWindow := nil;
  end;
  CloseModalShow();
  for i := 0 to DWinList.Count - 1 do
    TDControl(DWinList[i]).CloseSurface();
end;

procedure TDWinManager.DirectPaint(dsurface: TDirectDrawSurface);
var
  i: integer;
  boVisible, boPopVisible: Boolean;
  MDWindow: TDModalWindow;
begin
  boVisible := False;
  if ModalDWindow <> nil then begin
    boVisible := ModalDWindow.Visible;
    if boVisible then
      ModalDWindow.Visible := False;
  end;
  boPopVisible := False;
  if PopUpDWindow <> nil then begin
    boPopVisible := PopUpDWindow.Visible;
    if boPopVisible then
      PopUpDWindow.Visible := False;
  end;
  for i := 0 to DWinList.Count - 1 do begin
    if TDControl(DWinList[i]).Visible then begin
      TDControl(DWinList[i]).DirectPaint(dsurface);
    end;
  end;
  if ModalDWindow <> nil then begin
    if boVisible then begin
      ModalDWindow.Visible := True;
      with ModalDWindow do
        DirectPaint(dsurface);
    end;
  end;

  if ModalDWindowList.Count > 0 then begin
    for I := 0 to ModalDWindowList.Count - 1 do begin
      MDWindow := TDModalWindow(ModalDWindowList[i]);
      if MDWindow.Visible then
        with MDWindow do
          DirectPaint(dsurface);
    end;
  end;

  if PopUpDWindow <> nil then begin
    if boPopVisible then begin
      PopUpDWindow.Visible := True;
      with PopUpDWindow do
        DirectPaint(dsurface);
    end;
  end;
end;



function TDWinManager.EscClose: Boolean;
var
  i: integer;
  MDWindow: TDModalWindow;
begin
  Result := FALSE;

  if PopUpDWindow <> nil then begin
    if PopUpDWindow.Visible then begin
      PopUpDWindow.Visible := False;
      PopUpDWindow := nil;
      Result := True;
      exit;
    end
    else
      PopUpDWindow := nil;
  end;

  if ModalDWindowList.Count > 0 then begin
    for I := ModalDWindowList.Count - 1 downto 0 do begin
      MDWindow := TDModalWindow(ModalDWindowList[i]);
      if MDWindow.Visible then begin
        MDWindow.Visible := False;
        ModalDWindowList.delete(i);
        Result := TRUE;
        exit;
      end else ModalDWindowList.delete(i);
    end;
  end;

  if ModalDWindow <> nil then begin
    if ModalDWindow.Visible then begin
      ModalDWindow.Visible := False;
      ModalDWindow := nil;
      Result := TRUE;
      exit;
    end
    else
      ModalDWindow := nil;
  end;

  if TopDWindow <> nil then begin
    if TopDWindow.Visible then begin
      TopDWindow.Visible := False;
      TopDWindow := nil;
      Result := True;
      exit;
    end else TopDWindow := nil;
  end;

  if MouseCaptureControl <> nil then begin
    with MouseCaptureControl do
      Result := MouseCaptureControl.EscClose;
  end
  else
    for i := 0 to DWinList.Count - 1 do begin
      if TDControl(DWinList[i]).Visible then begin
        if TDControl(DWinList[i]).EscClose then begin
          Result := TRUE;
          break;
        end;
      end;
    end;
end;

constructor TDCheckBox.Create(AOwner: TComponent);
begin
  inherited;
  FChecked := False;
  FFontSpace := 3;
  FWidth := 0;
  FHeight := 0;
  FOnClick := nil;
  
  
  FOffsetLeft := 0;
  FOffsetTop := 0;
  FDFColor := $C4C9BA;
  FDFMoveColor := $C5D2BD;
  FDFEnabledColor := $C5D2BD;
  FDFDownColor := clWhite;
  FDFBackColor := $8;
  FOnCheckedChange := nil;
end;

procedure TDCheckBox.DirectPaint(dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
begin
  if FChangeCaption then begin
    FWidth := DrawCanvas.TextWidth(Caption);
    FHeight := DrawCanvas.TextHeight(Caption);
    FChangeCaption := False;
  end;
  if Assigned(FOnDirectPaint) then
    FOnDirectPaint(self, dsurface)
  else if WLib <> nil then begin
    if Checked then begin
      d := WLib.Images[FaceIndex + 1];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
    end
    else begin
      d := WLib.Images[FaceIndex];
      if d <> nil then
        dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, TRUE);
    end;
    if d <> nil then begin
      with DrawCanvas do begin
        if Checked then
          TextOut(SurfaceX(Left) + d.Width + FFontSpace + FOffsetLeft,
                  SurfaceY(Top) + d.Height div 2 - FHeight div 2 + FOffsetTop,
                  Caption,
                  FDFDownColor)
        else
          TextOut(SurfaceX(Left) + d.Width + FFontSpace + FOffsetLeft,
                  SurfaceY(Top) + d.Height div 2 - FHeight div 2 + FOffsetTop,
                  Caption,
                  FDFColor);
      end;
    end;
  end;
end;

function TDCheckBox.InRange(x, y: integer): Boolean;
var
  boinrange: Boolean;
  nWidth, nHeight: Integer;
begin
  nWidth := FWidth + FFontSpace + Width;
  nHeight := _MAX(Height, FHeight);
  if (x >= Left) and (x < Left + nWidth + FOffsetLeft) and (y >= Top) and (y < Top + nHeight) then begin
    boinrange := TRUE;
    if Assigned(FOnInRealArea) then
      FOnInRealArea(self, x - Left, y - Top, boinrange);
    Result := boinrange;
  end
  else
    Result := FALSE;
end;

function TDCheckBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
begin
  Result := FALSE;
  if inherited MouseDown(Button, Shift, X, Y) and FEnabled then begin
    if (not Background) and (MouseCaptureControl = nil) then begin
      SetDCapture(self);
    end;
    Result := TRUE;
  end;
end;

function TDCheckBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
begin
  Result := FALSE;
  if inherited MouseUp(Button, Shift, X, Y) and FEnabled then begin
    ReleaseDCapture;
    if not Background then begin
      if InRange(X, Y) then begin
        FChecked := not FChecked;
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
        if Assigned(FOnCheckedChange) then
          FOnCheckedChange(Self);
      end;
    end;
    Result := TRUE;
    exit;
  end
  else begin
    ReleaseDCapture;
  end;
end;

procedure TDUpDown.ButtonMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FClickTime := GetTickCount;
  if Sender = FUpButton then begin
    if FPosition >= FMovePosition then
      Dec(FPosition, FMovePosition)
    else
      FPosition := 0;
    FAddTop := Round(FMaxLength / FMaxPosition * FPosition);
    if Assigned(FOnPositionChange) then
      FOnPositionChange(Self);
  end
  else if Sender = FDownButton then begin
    if (FPosition + FMovePosition) <= FMaxPosition then
      Inc(FPosition, FMovePosition)
    else
      FPosition := FMaxPosition;
    FAddTop := Round(FMaxLength / FMaxPosition * FPosition);
    if Assigned(FOnPositionChange) then
      FOnPositionChange(Self);
  end
  else if Sender = FMoveButton then begin
    StopY := Y;
    FStopY := FAddTop;
  end;
  if Assigned(FOnMouseDown) then
    FOnMouseDown(self, Button, Shift, X, Y);
end;

procedure TDUpDown.ButtonMouseMove(Sender: TObject; Shift: TShiftState; X, Y:
  Integer);
var
  nIdx: Integer;
  OldPosition: Integer;
  nY: Integer;
  DButton: TDButton;
begin
  if Sender = FUpButton then begin
    DButton := TDButton(Sender);
    if (DButton.Downed) and ((GetTickCount - FClickTime) > 100) then
      ButtonMouseDown(Sender, mbLeft, Shift, X, Y);
  end
  else if Sender = FDownButton then begin
    DButton := TDButton(Sender);
    if (DButton.Downed) and ((GetTickCount - FClickTime) > 100) then
      ButtonMouseDown(Sender, mbLeft, Shift, X, Y);
  end
  else if Sender = FMoveButton then begin
    if (StopY < 0) or (StopY = y) then begin
      if Assigned(FOnMouseMove) then
        FOnMouseMove(self, Shift, X, Y);
      Exit;
    end;

    nY := Y - StopY;
    FAddTop := FStopY + nY;
    if FAddTop < 0 then
      FAddTop := 0;
    if FAddTop > FMaxLength then
      FAddTop := FMaxLength;

    OldPosition := FPosition;
    nIdx := Round(FAddTop / (FMaxLength / FMaxPosition));
    if nIdx <= 0 then
      FPosition := 0
    else if nIdx >= FMaxPosition then
      FPosition := FMaxPosition
    else
      FPosition := nIdx;
    if OldPosition <> FPosition then
      if Assigned(FOnPositionChange) then
        FOnPositionChange(Self);
  end;
  if Assigned(FOnMouseMove) then
    FOnMouseMove(self, Shift, X, Y);
end;

procedure TDUpDown.ButtonMouseUp(Sender: TObject; Button: TMouseButton; Shift:
  TShiftState; X, Y: Integer);
begin
  StopY := -1;
  if Assigned(FOnMouseUp) then
    FOnMouseUp(self, Button, Shift, X, Y);
end;

constructor TDUpDown.Create(AOwner: TComponent);
begin
  inherited;
  FUpButton := TDButton.Create(nil);
  FDownButton := TDButton.Create(nil);
  FMoveButton := TDButton.Create(nil);
  
  
  SetButton(UpButton);
  SetButton(DownButton);
  SetButton(MoveButton);

  FOffset := 1;
  FBoMoveShow := False;
  FboMoveFlicker := False;

  FMovePosition := 1;
  FPosition := 0;
  FMaxPosition := 0;
  FMaxLength := 0;
  FTop := 0;
  FAddTop := 0;
  StopY := -1;
  FWheelDControl := Self;
end;

destructor TDUpDown.Destroy;
begin
  FUpButton.Free;
  FDownButton.Free;
  FMoveButton.Free;
  inherited;
end;

procedure TDUpDown.DirectPaint(dsurface: TDirectDrawSurface);
var
  d: TDirectDrawSurface;
  dc, rc: TRect;
begin
  if WLib <> nil then begin
    d := WLib.Images[FaceIndex];
    if d <> nil then begin
      dc.Left := SurfaceX(Left);
      dc.Top := SurfaceY(Top);
      dc.Right := SurfaceX(left + Width);
      dc.Bottom := SurfaceY(top + Height);
      rc.Left := 0;
      rc.Top := 0;
      rc.Right := d.ClientRect.Right;
      rc.Bottom := d.ClientRect.Bottom;
      dsurface.StretchDraw(dc, rc, d, True);
    end;
    if FUpButton <> nil then begin
      with FUpButton do begin
        Left := FOffset;
        Top := FOffset;
        if Downed then begin
          d := WLib.Images[FaceIndex + 1 + Integer(FBoMoveShow)];
        end
        else if MouseEntry = msIn then begin
          d := WLib.Images[FaceIndex + Integer(FBoMoveShow)];
        end
        else begin
          d := WLib.Images[FaceIndex];
        end;
        if d <> nil then begin
          FTop := d.Height + Top;
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
        end;
      end;
    end;
    if FDownButton <> nil then begin
      with FDownButton do begin
        Left := FOffset;
        if FBoMoveShow then
          Top := Self.Height - d.Height + 1
        else
          Top := Self.Height - d.Height - 1;

        if Downed then begin
          d := WLib.Images[FaceIndex + 1 + Integer(FBoMoveShow)];
        end
        else if MouseEntry = msIn then begin
          d := WLib.Images[FaceIndex + Integer(FBoMoveShow)];
        end
        else begin
          d := WLib.Images[FaceIndex];
        end;
        if d <> nil then begin
          FMaxLength := Top - FTop;
          dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
        end;
      end;
    end;
    if FMoveButton <> nil then begin
      with FMoveButton do begin
        Left := FOffset;
        if FBoMoveShow then begin
          if Downed then begin
            d := WLib.Images[FaceIndex + 2];
          end
          else if MouseEntry = msIn then begin
            d := WLib.Images[FaceIndex + 1];
          end
          else begin
            if FboMoveFlicker and ((GetTickCount - AppendTick) mod 400 < 200) then begin
              d := WLib.Images[FaceIndex + 1];
            end else
              d := WLib.Images[FaceIndex];
          end;
          if (d <> nil) then begin
            Dec(FMaxLength, d.Height);
            Top := FTop + FAddTop;
            if FMaxPosition > 0 then
              dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
          end;
        end
        else begin
          d := WLib.Images[FaceIndex];
          if d <> nil then begin
            Dec(FMaxLength, d.Height);
            Top := FTop + FAddTop;
            dsurface.Draw(SurfaceX(Left), SurfaceY(Top), d.ClientRect, d, True);
          end;
        end;
      end;
    end;
  end;
end;

function TDUpDown.MouseWheel(Shift: TShiftState; Wheel: TMouseWheel; X, Y: Integer): Boolean;
begin
  Result := True;
  if Wheel = mw_Up then
    ButtonMouseDown(FUpButton, mbLeft, Shift, X, Y)
  else if Wheel = mw_Down then
    ButtonMouseDown(FDownButton, mbLeft, Shift, X, Y);
end;

procedure TDUpDown.SetButton(Button: TDButton);
begin
  Button.DParent := Self;
  Button.OnMouseMove := ButtonMouseMove;
  Button.FWheelDControl := Self;
  Button.OnMouseDown := ButtonMouseDown;
  Button.OnMouseUp := ButtonMouseUp;
  AddChild(Button);
end;

procedure TDUpDown.SetMaxPosition(const Value: Integer);
var
  OldPosition: integer;
begin
  OldPosition := FMaxPosition;
  FMaxPosition := _Max(Value, 0);
  if OldPosition <> FMaxPosition then begin
    if FPosition > FMaxPosition then
      FPosition := FMaxPosition;
    if FMaxPosition > 0 then
      FAddTop := Round(FMaxLength / FMaxPosition * FPosition);
  end;
end;

procedure TDUpDown.SetPosition(value: Integer);
var
  OldPosition: integer;
begin
  OldPosition := FPosition;
  FPosition := _Max(Value, 0);
  if FPosition > FMaxPosition then
    FPosition := FMaxPosition;
  if OldPosition <> FPosition then begin
    if FMaxPosition > 0 then
      FAddTop := Round(FMaxLength / FMaxPosition * FPosition);
  end;
end;



constructor TDHooKKey.Create(AOwner: TComponent);
begin
  inherited;
  FShiftState := [];
  FKey := 0;
  FText := '';
  Color := clBlack;
  FrameColor := clSilver;
  FKeyFocus := True;
  FOnChange := nil;
  
  
end;

procedure TDHooKKey.DirectPaint(dsurface: TDirectDrawSurface);
var
  dc{, rc}: TRect;
  //d: TDirectDrawSurface;
  
{  OldColor, OldSize: Integer;
  OldName: string;   }
begin

  {d := nil;
  dc.Left := SurfaceX(Left);
  dc.Top := SurfaceY(Top);
  dc.Right := SurfaceX(left + Width);
  dc.Bottom := SurfaceY(top + Height);
  if WLib <> nil then
    d := WLib.Images[FaceIndex];
  if d <> nil then begin
    rc.Left := 0;
    rc.Top := 0;
    rc.Right := d.ClientRect.Right;
    rc.Bottom := d.ClientRect.Bottom;
    dsurface.StretchDraw(dc, rc, d, FALSE);
  end
  else begin
    dsurface.Canvas.Brush.Color := Color;
    dsurface.Canvas.Pen.Color := FrameColor;
    dsurface.Canvas.Pen.Style := psAlternate;
    dsurface.Canvas.RoundRect(dc.Left, dc.Top, dc.Right, dc.Bottom, 0, 0);
    if (KeyControl = self) then begin
      dc.Left := SurfaceX(Left + 1);
      dc.Top := SurfaceY(Top + 1);
      dc.Right := SurfaceX(left + Width - 1);
      dc.Bottom := SurfaceY(top + Height - 1);
      dsurface.Canvas.RoundRect(dc.Left, dc.Top, dc.Right, dc.Bottom, 0, 0);
    end;
  end;    }
  with DrawCanvas do begin
    if FText <> '' then begin
      dc.Left := SurfaceX(Left + 3);
      dc.Top := SurfaceY(Top);
      dc.Right := SurfaceX(left + Width - 5);
      dc.Bottom := SurfaceY(top + Height);
      TextRect(dc, FText, Self.Font.Color, [tfSingleLine, tfCenter, tfVerticalCenter]);
    end;
  end;
  {with dsurface.Canvas do begin
    if FText <> '' then begin
      SetBkMode(Handle, TRANSPARENT);
      OldColor := Font.Color;
      OldName := Font.Name;
      OldSize := Font.Size;
      try
        Font.Color := self.Font.Color;
        Font.Name := self.Font.Name;
        Font.Size := self.Font.Size;
        dc.Left := SurfaceX(Left + 3);
        dc.Top := SurfaceY(Top);
        dc.Right := SurfaceX(left + Width - 5);
        dc.Bottom := SurfaceY(top + Height);
        TextRect(dc, FText, [tfSingleLine, tfCenter, tfVerticalCenter]);
      finally
        Font.Color := OldColor;
        Font.Name := OldName;
        Font.Size := OldSize;
      end;
    end;
    Release;
  end;    }
  if Assigned(FOnDirectPaint) then
    FOnDirectPaint(self, dsurface)

end;

function TDHooKKey.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
begin
  Result := False;
  if (KeyControl = self) then begin
    KeyDownControl := Self;
    if Assigned(FOnKeyDown) then
      FOnKeyDown(self, Key, Shift);
    if Key <> 0 then begin
      if (Key = VK_BACK) or (Key = VK_DELETE) then begin
        FShiftState := [];
        FKey := 0;
        Key := 0;
        RefHookKeyStr();
      end
      else begin
        FShiftState := Shift;
        FKey := Key;
        Key := 0;
        RefHookKeyStr();
      end;
      if Assigned(FOnChange) then
        FOnChange(self);
    end;
    Result := True;
  end;
end;

function TDHooKKey.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
begin
  Result := FALSE;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    if (not Background) and (MouseCaptureControl = nil) then begin
      SetDCapture(self);
    end;
    Result := TRUE;
  end;
end;

function TDHooKKey.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
begin
  Result := FALSE;
  if inherited MouseUp(Button, Shift, X, Y) then begin
    ReleaseDCapture;
    if not Background then begin
      if InRange(X, Y) then begin
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
      end;
    end;
    Result := TRUE;
    exit;
  end
  else begin
    ReleaseDCapture;
  end;
end;

procedure TDHooKKey.RefHookKeyStr;
var
  ShowStr: string;
begin
  ShowStr := '';
  if ssCtrl in FShiftState then
    ShowStr := 'Ctrl';

  if ssAlt in FShiftState then
    if ShowStr <> '' then
      ShowStr := ShowStr + '+Alt'
    else
      ShowStr := 'Alt';

  if ssShift in FShiftState then
    if ShowStr <> '' then
      ShowStr := ShowStr + '+Shift'
    else
      ShowStr := 'Shift';

  case FKey of
    VK_F1: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+F1'
        else
          ShowStr := 'F1';
      end;
    VK_F2: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+F2'
        else
          ShowStr := 'F2';
      end;
    VK_F3: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+F3'
        else
          ShowStr := 'F3';
      end;
    VK_F4: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+F4'
        else
          ShowStr := 'F4';
      end;
    VK_F5: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+F5'
        else
          ShowStr := 'F5';
      end;
    VK_F6: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+F6'
        else
          ShowStr := 'F6';
      end;
    VK_F7: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+F7'
        else
          ShowStr := 'F7';
      end;
    VK_F8: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+F8'
        else
          ShowStr := 'F8';
      end;
    VK_F9: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+F9'
        else
          ShowStr := 'F9';
      end;
    VK_F10: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+F10'
        else
          ShowStr := 'F10';
      end;
    VK_F11: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+F11'
        else
          ShowStr := 'F11';
      end;
    VK_F12: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+F12'
        else
          ShowStr := 'F12';
      end;
    VK_TAB: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+Tab'
        else
          ShowStr := 'Tab';
      end;
    VK_PAUSE: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+Pause'
        else
          ShowStr := 'Pause';
      end;
    VK_HOME: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+Home'
        else
          ShowStr := 'Home';
      end;
    VK_LEFT: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+Left'
        else
          ShowStr := 'Left';
      end;
    VK_UP: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+Up'
        else
          ShowStr := 'Up';
      end;
    VK_RIGHT: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+Right'
        else
          ShowStr := 'Right';
      end;
    VK_DOWN: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+Down'
        else
          ShowStr := 'Down';
      end;
    VK_SPACE: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+Space'
        else
          ShowStr := 'Space';
      end;
    VK_CAPITAL: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+CapsLock'
        else
          ShowStr := 'CapsLock';
      end;
    VK_ESCAPE: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+Esc'
        else
          ShowStr := 'Esc';
      end;
    VK_PRIOR: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+Prior'
        else
          ShowStr := 'Prior';
      end;
    VK_NEXT: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+Next'
        else
          ShowStr := 'Next';
      end;
    VK_END: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+End'
        else
          ShowStr := 'End';
      end;
    VK_SELECT: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+Select'
        else
          ShowStr := 'Select';
      end;
    VK_PRINT: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+Print'
        else
          ShowStr := 'Print';
      end;
    VK_EXECUTE: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+Execute'
        else
          ShowStr := 'Execute';
      end;
    VK_SNAPSHOT: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+Snapshot'
        else
          ShowStr := 'Snapshot';
      end;
    VK_INSERT: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+Insert'
        else
          ShowStr := 'Insert';
      end;
    VK_HELP: begin
        if ShowStr <> '' then
          ShowStr := ShowStr + '+Help'
        else
          ShowStr := 'Help';
      end;
    VK_SHIFT,
      VK_CONTROL,
      VK_MENU: begin

      end
  else begin
      if ShowStr <> '' then
        ShowStr := ShowStr + '+' + Char(FKey)
      else
        ShowStr := Char(FKey);
    end;
  end;

  FText := ShowStr;
end;

procedure TDHooKKey.SetKey(Value: Word);
begin
  FKey := Value;
  RefHookKeyStr;
  
end;

procedure TDHooKKey.SetShiftState(Value: TShiftState);
begin
  FShiftState := Value;
  RefHookKeyStr;
  
end;



function TDEdit.ClearKey: Boolean;
begin
  Result := False;
  if (FStartX > -1) and (FStopX > -1) and (FStartX <> FStopX) then begin
    if FStartX > FStopX then begin
      Delete(FEditString, FStopX, FStartX - FStopX);
      FCaretPos := FStopX;
    end
    else begin
      Delete(FEditString, FStartX, FStopX - FStartX);
      FCaretPos := FStartX;
    end;
    if FCaretPos < FCaretStart then
      FCaretStart := FCaretPos;
    FStartX := -1;
    FStopX := -1;
    FCursor := deLeft;
    Result := True;
  end;
  FStartX := -1;
  FStopX := -1;
end;


 {
function TDEdit.CloseIME: Boolean;
var
  hklKeyboardLayout: LongWord;
begin
  Result := False;
  if (FPasswordChar <> #0) or (FEditClass = deInteger) or (FEditClass = deMonoCase) then begin
    Result := True;
    hklKeyboardLayout := GetKeyboardLayout(0);
    if ImmIsIME(hklKeyboardLayout) then
      ImmSimulateHotKey(FrmMainWinHandle, IME_CHotKey_IME_NonIME_Toggle);
  end;
end;     }

constructor TDEdit.Create(AOwner: TComponent);
begin
  inherited;
  FOnChange := nil;
  
  
  FKeyFocus := True;
  FCaretShowTime := GetTickCount;
  FrameColor := clSilver;
  FMaxLength := 0;
  FInputStr := '';
  bDoubleByte := False;
  KeyByteCount := 0;
  FCaretPos := 1;
  FCaretStart := 1;
  FCaretStop := 1;
  FCursor := deLeft;
  FStartX := -1;
  FStopX := -1;
  FIndent := 2;
  FTransparent := True;
  FCloseSpace := False;
  Color := clBlack;
  Font.Name := DEFFONTNAME;
  Font.Color := clWhite;
  Font.Size := DEFFONTSIZE;
  {Canvas.Font.Name := Font.Name;
  DrawCanvas.Font.Color := Font.Color;
  DrawCanvas.Font.Size := Font.Size; }
  FDFColor := clWhite;
end;

destructor TDEdit.Destroy;
begin
  inherited;
end;

procedure TDEdit.DirectPaint(dsurface: TDirectDrawSurface);
var
  dc,  fDc: TRect;
  nLeft: integer;
  
  ShowStr: string;
  StopX, StartX, CaretIdx: Integer;
  boLeft: byte;
begin
  
  dc.Left := SurfaceX(Left);
  dc.Top := SurfaceY(Top);
  dc.Right := SurfaceX(left + Width);
  dc.Bottom := SurfaceY(top + Height);

  if not FTransparent then begin
    DrawCanvas.FillRect(dc.Left, dc.Top, Width, Height, $FF000000 or LongWord(Color));
    DrawCanvas.RoundRect(dc.Left, dc.Top, dc.Right, dc.Bottom, FrameColor);
    {dsurface.Canvas.Brush.Color := Color;
    dsurface.Canvas.Pen.Color := FrameColor;
    dsurface.Canvas.Pen.Style := psAlternate;
    dsurface.Canvas.RoundRect(dc.Left, dc.Top, dc.Right, dc.Bottom, 0, 0);   }
  end;

  if (GetTickCount - FCaretShowTime) > 500 then begin 
    FCaretShowTime := GetTickCount;
    FCaretShow := not FCaretShow;
  end;
  nLeft := 0;
  boLeft := 0;
  with DrawCanvas do begin
    if FEditString <> '' then begin
      if (FStartX <> FStopX) and (FStopX >= 0) and (FStartX >= 0) then begin
        StopX := FStopX;
        StartX := FStartX;
        CaretIdx := FCaretStart;
        //SetBkMode(Handle, TRANSPARENT);
        //Brush.Color := $C66931;
        if Height < 14 then begin
          dc.Top := SurfaceY(Top);
          dc.Bottom := SurfaceY(top + Height);
        end
        else begin
          dc.Top := SurfaceY(Top + (Height - 14) div 2);
          dc.Bottom := SurfaceY(top + Height - (Height - 14) div 2);
        end;
        if StartX > StopX then begin
          StartX := FStopX;
          StopX := FStartX;
          boLeft := 1;
        end;
        if StartX < CaretIdx then begin
          dc.Left := SurfaceX(Left + FIndent);
          ShowStr := Copy(FEditString, CaretIdx, StopX - CaretIdx);
          dc.Right := dc.Left + TextWidth(ShowStr);
          boLeft := 2;
        end
        else begin
          if FCaretStart > 0 then begin
            ShowStr := Copy(FEditString, CaretIdx, StartX - CaretIdx);
            dc.Left := SurfaceX(Left + FIndent) + TextWidth(ShowStr);
          end
          else begin
            ShowStr := Copy(FEditString, CaretIdx, StartX - CaretIdx);
            dc.Left := SurfaceX(Left + FIndent) + TextWidth(ShowStr);
          end;
          ShowStr := Copy(FEditString, StartX, StopX - StartX);
          dc.Right := dc.Left + TextWidth(ShowStr);
        end;
        dc.Right := _MIN(dc.Right, SurfaceX(Left + Width - FIndent * 2));
        FillRect(dc, $C9C66931, fxBlend);
        fDc := dc;
      end;

      {Font.Color := self.Font.Color;
      Font.Name := self.Font.Name;
      Font.Size := self.Font.Size;   }
      dc.Left := SurfaceX(Left + FIndent);
      dc.Top := SurfaceY(Top);
      dc.Right := SurfaceX(left + Width - FIndent * 2);
      dc.Bottom := SurfaceY(top + Height);
      if FCursor = deLeft then begin
        ShowStr := Copy(FEditString, FCaretStart, Length(FEditString));
        ShowStr := GetPasswordstr(ShowStr);
        TextRect(dc, ShowStr, FDFColor, [tfSingleLine, tfLeft, tfVerticalCenter]);
        nLeft := _MIN(TextWidth(Copy(FEditString, FCaretStart, FCaretPos - FCaretStart)), Width - FIndent * 2);
        if FDFColor <> clWhite then begin
          ShowStr := GetPasswordstr(GetCopy);
          if ShowStr <> '' then begin
            //Font.Color := clWhite;
            if boLeft = 1 then
              TextRect(Fdc, ShowStr, clWhite, [tfSingleLine, tfleft, tfVerticalCenter])
            else
              TextRect(Fdc, ShowStr, clWhite, [tfSingleLine, tfRight, tfVerticalCenter]);
          end;
        end;
      end
      else begin
        ShowStr := copy(FEditString, 1, FCaretStop - 1);
        ShowStr := GetPasswordstr(ShowStr);
        TextRect(dc, ShowStr, FDFColor, [tfSingleLine, tfRight, tfVerticalCenter]);
        ShowStr := Copy(FEditString, FCaretPos, FCaretStop - FCaretPos);
        nLeft := _MIN(Width - FIndent * 3 - TextWidth(ShowStr), Width - FIndent * 3);
        if FDFColor <> clWhite then begin
          ShowStr := GetPasswordstr(GetCopy);
          if ShowStr <> '' then begin
            //Font.Color := clWhite;
            TextRect(Fdc, ShowStr, clWhite, [tfSingleLine, tfLeft, tfVerticalCenter]);
          end;
        end;
      end;
    end;
    
    if FCaretShow and (KeyControl = Self) then begin
      FrmIMEX := SurfaceX(nLeft + FIndent + left);
      if Height < 16 then begin
        RoundRect(SurfaceX(nLeft + FIndent + left), SurfaceY(Top),
          SurfaceX(left + FIndent + 1 + nLeft), SurfaceY(top + Height), clWhite);
        FrmIMEY := SurfaceY(Top);
      end
      else begin
        RoundRect(SurfaceX(nLeft + FIndent + left), SurfaceY(Top + 1),
          SurfaceX(left + FIndent + 1 + nLeft), SurfaceY(top + (Height - 2)), clWhite);
        FrmIMEY := SurfaceY(Top + 1);
      end;
    end;
  end;  
end;

procedure TDEdit.Enter;
begin
  //CloseIME;
  inherited;
end;

function TDEdit.GetCopy: string;
begin
  Result := '';
  if FStartX > FStopX then begin
    Result := Copy(FEditString, FStopX, FStartX - FStopX);
  end
  else begin
    Result := Copy(FEditString, FStartX, FStopX - FStartX);
  end;
end;

function TDEdit.GetPasswordstr(str: string): string;
var
  i: Integer;
begin
  Result := str;
  if str = '' then
    Exit;
  if PasswordChar <> #0 then begin
    Result := '';
    for I := 1 to Length(str) do
      Result := Result + PasswordChar;
  end;
end;

function TDEdit.GetText: string;
begin
  Result := string(FEditString);
end;

function TDEdit.GetValue: Integer;
begin
  Result := StrToIntDef(string(FEditString), 0);
end;

function TDEdit.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  i: integer;
  Clipboard: TClipboard;
  AddTx: string;
  nKey: Char;
  boChange: Boolean;
begin
  Result := FALSE;
  
  if (KeyControl = self) then begin
    KeyDownControl := Self;
    if Assigned(FOnKeyDown) then
      FOnKeyDown(self, Key, Shift);
    if Key = 0 then
      exit;

    if (ssCtrl in Shift) and (not Downed) and (Key = Word('X')) then begin
      if (FPasswordChar = #0) then begin
        if (FStartX > -1) and (FStopX > -1) and (FStartX <> FStopX) then begin
          Clipboard := TClipboard.Create;

          Clipboard.AsText := GetCopy;
          Clipboard.Free;
          ClearKey();
          TextChange();
        end;
      end;
      Key := 0;
      Result := True;
      Exit;
    end
    else if (ssCtrl in Shift) and (not Downed) and (Key = Word('C')) then begin
      if (FPasswordChar = #0) then begin
        if (FStartX > -1) and (FStopX > -1) and (FStartX <> FStopX) then begin
          Clipboard := TClipboard.Create;
          Clipboard.AsText := GetCopy;
          Clipboard.Free;
        end;
      end;
      Key := 0;
      Result := True;
      Exit;
    end
    else if (ssCtrl in Shift) and (not Downed) and (Key = Word('V')) then begin
      if (FPasswordChar = #0) then begin
        ClearKey();
        Clipboard := TClipboard.Create;
        AddTx := Clipboard.AsText;
        for I := 1 to Length(AddTx) do begin
          nKey := AddTx[i];
          if (nKey = #13) or (nKey = #10) then
            Continue;
          KeyPress(nKey);
        end;

        Clipboard.Free;
      end;
      Key := 0;
      Result := True;
      Exit;
    end
    else if (ssCtrl in Shift) and (not Downed) and (Key = Word('A')) then begin
      SetFocus;
      Key := 0;
      Result := True;
      Exit;
    end
    else if (ssShift in Shift) and (not Downed) then begin
      KeyDowned := True;

      if FStartX < 0 then
        FStartX := FCaretPos;
    end
    else
      KeyDowned := False;
    case Key of
      VK_RIGHT: begin
          if not Downed then
            SetCursorPos(deRight);
          if (ssShift in Shift) then begin
            FCursor := deLeft;
            FStopX := FCaretPos
          end
          else begin
            FStartX := -1;
            FStopX := -1;
            KeyDowned := False;
          end;
          Key := 0;
          Result := TRUE;
        end;
      VK_LEFT: begin
          if not Downed then
            SetCursorPos(deLeft);
          if (ssShift in Shift) then begin
            FCursor := deLeft;
            FStopX := FCaretPos
          end
          else begin
            FStartX := -1;
            FStopX := -1;
            KeyDowned := False;
          end;
          Key := 0;
          Result := TRUE;
        end;
      VK_DELETE: begin
          boChange := ClearKey;
          if (not FReadOnly) and (not Downed) and (not KeyDowned) and (not
            boChange) then begin
            Delete(FEditString, FCaretPos, 1);
            FCaretPos := _Min(FCaretPos, Length(FEditString) + 1);
            FCursor := deLeft;
            TextChange();
          end
          else if boChange then
            TextChange();
          Key := 0;
          Result := TRUE;
        end;
    end;
    
    
  end;
end;

function TDEdit.KeyPress(var Key: Char): Boolean;
var
  boChange: Boolean;
begin
  Result := False;
  if (KeyControl = Self) then begin
    Result := TRUE;
    if (not Downed) and (not FReadOnly) then begin
      if Assigned(FOnKeyPress) then
        FOnKeyPress(self, Key);
      if Key = #0 then
        Exit;
      case Key of
        Char(VK_BACK): begin
            boChange := ClearKey;
            if (FEditString <> '') and (not boChange) then begin
              FCursor := deleft;
              Delete(FEditString, FCaretPos - 1, 1);
              SetCursorPos(deLeft);
              TextChange();
            end
            else if boChange then
              TextChange();
          end;
      else begin

          if (FEditClass = deInteger) and (not (key in AllowedIntegerChars)) then begin
            Key := #0;
            exit;
          end
          else if ((FEditClass = deMonoCase) or (FPasswordChar <> #0)) and (not (key in AllowedEnglishChars)) then begin
            Key := #0;
            exit;
          end;
          if (FEditClass = deEnglishAndInt) and (not (key in AllowedStandard)) then begin
            key := #0;
            exit;
          end;
          if (FEditClass = deCDKey) and (not (key in AllowedCDKey)) then begin
            key := #0;
            exit;
          end;

          if (key in AllowedChars) then begin
            if IsDBCSLeadByte(Ord(Key)) or bDoubleByte then begin
              bDoubleByte := true;
              Inc(KeyByteCount);
              FInputStr := FInputStr + key;
            end;
            if not bDoubleByte then begin
              if FCloseSpace and (Key = #32) then begin
                Key := #0;
                exit;
              end;
              if (FEditClass = deStandard) and (not (key in AllowedStandard)) then begin
                Key := #0;
                exit;
              end;

              ClearKey;
              if (MaxLength > 0) and (Length(string(FEditString)) >= MaxLength) then begin
                Key := #0;
                exit;
              end;
              if FCaretPos <= Length(FEditString) then begin
                Insert(Key, FEditString, FCaretPos);
                SetCursorPosEx(1);
              end
              else begin
                FEditString := FEditString + Key;
                SetCursorPos(deRight);
              end;
              Key := #0;
              TextChange();
            end
            else if KeyByteCount >= 2 then begin
              if length(FInputStr) <> 2 then begin
                bDoubleByte := false;
                KeyByteCount := 0;
                FInputStr := '';
                Key := #0;
                exit;
              end;
              if (FEditClass = deStandard) and (not FiltrateStandardChar(Ord(FInputStr[1]), Ord(FInputStr[2]))) then begin
                bDoubleByte := false;
                KeyByteCount := 0;
                FInputStr := '';
                Key := #0;
                exit;
              end;
              if (FEditClass = deChinese) and (not FiltrateChar(Ord(FInputStr[1]), Ord(FInputStr[2]))) then begin
                bDoubleByte := false;
                KeyByteCount := 0;
                FInputStr := '';
                Key := #0;
                exit;
              end;
              ClearKey;
              if (MaxLength > 0) and (Length(string(FEditString)) >= (MaxLength - 1)) then begin
                bDoubleByte := false;
                KeyByteCount := 0;
                FInputStr := '';
                Key := #0;
                exit;
              end;
              if FCaretPos <= Length(FEditString) then begin
                Insert(FInputStr, FEditString, FCaretPos);
                SetCursorPosEx(1);
              end
              else begin
                FEditString := FEditString + FInputStr;
                SetCursorPos(deRight);
              end;
              TextChange();
              bDoubleByte := false;
              KeyByteCount := 0;
              FInputStr := '';
              Key := #0;
            end;
          end;
        end;
      end;
    end;
    Key := #0;
  end;
end;

function TDEdit.KeyUp(var Key: Word; Shift: TShiftState): Boolean;
begin
  Result := FALSE;
  if (KeyControl = self) then begin
    //CloseIME;
    if (Key = VK_SHIFT) then begin
      KeyDowned := False;
      if FStopX = -1 then
        FStartX := -1;
    end;
    if Assigned(FOnKeyUp) then
      FOnKeyUp(self, Key, Shift);
    Key := 0;
    Result := TRUE;
  end;
end;

procedure TDEdit.Leave;
begin
  FStartX := -1;
  FStopX := -1;
  inherited;
end;

function TDEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
begin
  {if Self Is TDComboBox then begin
    Result := inherited MouseDown(Button, Shift, X, Y);
    exit;
  end;  }
  Result := FALSE;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    if (not Background) and (MouseCaptureControl = nil) then begin
      KeyDowned := False;
      if mbLeft = Button then begin
        FStartX := -1;
        FStopX := -1;
        if (FocusedControl = self) then begin
          MoveCaret(X - left, Y - top);
        end;
        Downed := True;
      end;
      SetDCapture(self);
    end;
    Result := TRUE;
  end;
end;

function TDEdit.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  {if Self Is TDComboBox then begin
    Result := inherited MouseMove(Shift, X, Y);
    exit;
  end;     }
  Result := inherited MouseMove(Shift, X, Y);
  if Result and (MouseCaptureControl = self) then begin
    if Downed and (not KeyDowned) then
      MoveCaret(X - left, Y - top);
  end;
end;

function TDEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
begin
  Result := FALSE;
  Downed := False;
  {if Self Is TDComboBox then begin
    Result := inherited MouseUp(Button, Shift, X, Y);
    exit;
  end;  }
  if inherited MouseUp(Button, Shift, X, Y) then begin
    ReleaseDCapture;
    if not Background then begin
      if InRange(X, Y) then begin
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
      end;
    end;
    Result := TRUE;
    exit;
  end
  else begin
    ReleaseDCapture;
  end;
end;

procedure TDEdit.MoveCaret(X, Y: Integer);
var
  i: Integer;
  temstr: WideString;
begin
  FCursor := deLeft;
  if Length(FEditString) > 0 then begin
    if (X <= DrawCanvas.TextWidth('A')) and (FCaretStart > 1) then
      Dec(FCaretStart);
    for i := FCaretStart to Length(FEditString) do begin
      temstr := Copy(FEditString, FCaretStart, I - FCaretStart + 1);

      if DrawCanvas.TextWidth(temstr) > X then begin
        while I <> FCaretPos do begin
          if I > FCaretPos then begin
            SetCursorPos(deRight)
          end
          else begin
            SetCursorPos(deLeft);
          end;
        end;
        if Downed or KeyDowned then
          FStopX := FCaretPos
        else
          FStartX := FCaretPos;
        exit;
      end;
    end;
    while (Length(FEditString) + 1) <> FCaretPos do begin
      if (Length(FEditString) + 1) > FCaretPos then begin
        SetCursorPos(deRight)
      end
      else begin
        SetCursorPos(deLeft);
      end;
    end;
    if Downed or KeyDowned then
      FStopX := FCaretPos
    else
      FStartX := FCaretPos;
  end;
end;

function TDEdit.Selected: Boolean;
begin
  Result := False;
  if (FStartX > -1) and (FStopX > -1) and (FStartX <> FStopX) then
    Result := True;

end;

procedure TDEdit.SetCursorPos(cCursor: TCursor);
var
  tempstr: WideString;
begin
  if cCursor = deRight then begin
    Inc(FCaretPos);
    if FCaretPos > (Length(FEditString) + 1) then
      FCaretPos := (Length(FEditString) + 1);
    while True do begin
      tempstr := Copy(FEditString, FCaretStart, FCaretPos - FCaretStart);
      if (FCaretStart < FCaretPos) and (DrawCanvas.TextWidth(tempstr) > (Width - FIndent * 2)) then begin
        FCursor := deRight;
        Inc(FCaretStart);
        FCaretStop := FCaretPos;
      end
      else if FCaretPos > FCaretStop then begin
        FCaretStop := FCaretPos;
      end
      else
        Break;
    end;
  end
  else begin
    if FCaretPos > 1 then
      Dec(FCaretPos);
    if (FCaretPos <= FCaretStart) and (FCaretStart > 1) then begin
      FCursor := deleft;
      Dec(FCaretStart);
      FCaretStop := FCaretPos;
    end;
  end;
end;

procedure TDEdit.SetCursorPosEx(nLen: Integer);
var
  tempstr: WideString;
begin
  FCursor := deLeft;
  Inc(FCaretPos, nLen);
  if FCaretPos > (Length(FEditString) + 1) then
    FCaretPos := (Length(FEditString) + 1);
  while True do begin
    tempstr := Copy(FEditString, FCaretStart, FCaretPos - FCaretStart);
    if (FCaretStart < FCaretPos) and (DrawCanvas.TextWidth(tempstr) > (Width - FIndent * 2)) then begin
      FCursor := deRight;
      Inc(FCaretStart);
      FCaretStop := FCaretPos;
    end
    else if FCaretPos > FCaretStop then begin
      FCaretStop := FCaretPos;
    end
    else
      Break;
  end;
end;

procedure TDEdit.SetFocus;
begin
  inherited;
  if FEditString <> '' then begin
    FStartX := 1;
    FStopX := Length(FEditString) + 1;
  end;
end;

procedure TDEdit.SetText(Value: string);
var
  i: Integer;
  nKey: Char;
  OldKeyControl: TDControl;
  OldFOnChange: TOnClick;
  OldReadOnly: Boolean;
begin
  FEditString := '';
  FCursor := deLeft;
  FCaretStart := 1;
  FCaretStop := 1;
  FCaretPos := 1;
  FStartX := -1;
  OldKeyControl := KeyControl;
  KeyControl := Self;
  OldFOnChange := FOnChange;
  FOnChange := nil;
  OldReadOnly := ReadOnly;
  ReadOnly := False;
  try
    for I := 1 to Length(Value) do begin
      nKey := Value[i];
      KeyPress(nKey);
    end;
  finally
    KeyControl := OldKeyControl;
    FOnChange := OldFOnChange;
    ReadOnly := OldReadOnly;
  end;
end;

procedure TDEdit.SetValue(const Value: Integer);
begin
  SetText(IntToStr(Value));
end;

procedure TDEdit.TextChange;
begin
  if Assigned(FOnChange) then
    FOnChange(self);
end;



constructor TDComboBox.Create(AOwner: TComponent);
begin
  inherited;

  
  FUpDown := TDUpDown.Create(nil);
  SetUpDownButton(FUpDown);
  FItem := TStringList.Create;
  ReadOnly := True;
  FShowCount := 5;
  FShowHeight := 18;
  FListIndex := 0;
  FDWidth := 0;
  FImageWidth := 0;
  FItemIndex := -1;
  FOnChange := nil;
  DFColor := $DEDBDE;
end;

destructor TDComboBox.Destroy;
begin
  FItem.Free;
  FUpDown.Free;
  inherited;
end;

procedure TDComboBox.DirectPaint(dsurface: TDirectDrawSurface);
var
  dc: TRect;
  d: TDirectDrawSurface;
  ShowStr: string;
  nI: Integer;
  I: Integer;
  nShowCount: Integer;
begin
  if Assigned(FOnDirectPaint) then
    FOnDirectPaint(self, dsurface)
  else begin

    dc.Left := SurfaceX(Left);
    dc.Top := SurfaceY(Top);
    dc.Right := SurfaceX(left + Width);
    dc.Bottom := SurfaceY(top + Height);

    if not FTransparent then begin
      DrawCanvas.FillRect(dc.Left, dc.Top, Width, Height, $FF000000 or LongWord(Color));
      DrawCanvas.RoundRect(dc.Left, dc.Top, dc.Right, dc.Bottom, FrameColor);
    end;
    if WLib <> nil then begin
      d := WLib.Images[FaceIndex];
      if d <> nil then begin
        dsurface.Draw(dc.Right - d.Width, dc.Top + (Height - d.Height) div 2, d.ClientRect, d, True);
      end;
    end;
    
    if (GetTickCount - FCaretShowTime) > 500 then begin
      FCaretShowTime := GetTickCount;
      FCaretShow := not FCaretShow;
    end;

    with DrawCanvas do begin
      if FItemIndex >= FItem.Count then
        FItemIndex := -1;
      if FItemIndex > -1 then begin
        //SetBkMode(Handle, TRANSPARENT);
        
        
        dc.Left := SurfaceX(Left + FIndent);
        dc.Top := SurfaceY(Top);
        dc.Right := SurfaceX(left + Width - FIndent * 2 - FImageWidth);
        dc.Bottom := SurfaceY(top + Height);
        ShowStr := FItem.Strings[FItemIndex];
        TextRect(dc, ShowStr, DFColor, [tfSingleLine, tfLeft, tfVerticalCenter]);
          
        
      end;
      dc.Left := SurfaceX(Left);
      dc.Top := SurfaceY(Top);
      dc.Right := SurfaceX(left + Width);
      dc.Bottom := SurfaceY(top + Height);
      {dsurface.Canvas.Brush.Color := FrameColor;
      dsurface.Canvas.Pen.Color := FrameColor;
      dsurface.Canvas.Pen.Style := psAlternate; }
      
      if (FocusedControl = self) then begin
        FillRect(SurfaceX(Left), SurfaceY(top + Height), Width, MAX(10, FListHeight), $A0000000);
        //Release;
        //DrawAlphaOfColor(dsurface, SurfaceX(Left), SurfaceY(top + Height), Width, MAX(10, FListHeight), 0, 160);
        //SetBkMode(Handle, TRANSPARENT);
        //Brush.Style := bsClear;
        //Pen.Color := $737D73;
        //Pen.Style := psAlternate;
        nShowCount := MIN(FShowCount, FItem.Count);
        FListHeight := nShowCount * FShowHeight;
        if FUpDown.Visible then begin
          FDWidth := Width - FUpDown.Width;
        end
        else
          FDWidth := Width;
        RoundRect(SurfaceX(Left),
          SurfaceY(top + Height),
          SurfaceX(left + Width),
          SurfaceY(top + Height + MAX(10, FListHeight)), $FF737D73);

        FUpDown.Height := FListHeight - 2;
        FUpDown.Top := Height + 1;
        FUpDown.Left := Width - FUpDown.Width;

        
        dc.Left := SurfaceX(Left) + 2;
        dc.Right := dc.Left + FDWidth - 3;
        dc.Top := SurfaceY(top + Height) + 2;
        dc.Bottom := dc.Top + FShowHeight - 5;
       
        {Font.Color := self.Font.Color;
        Font.Name := self.Font.Name;
        Font.Size := self.Font.Size;
        SetBkMode(Handle, TRANSPARENT);  }

        nI := 0;
        for I := FUpDown.Position to (FUpDown.Position + nShowCount - 1) do begin
          if I >= FItem.Count then begin
            FUpDown.Position := 0;
            break;
          end;
          ShowStr := FItem[i];
          if (SurfaceX(FX) >= dc.Left) and (SurfaceX(FX) < dc.Right) and
            (SurfaceY(FY) >= dc.Top) and (SurfaceY(FY) < dc.Bottom) then begin
            FillRect(dc.Left, dc.Top, dc.Right - dc.Left, dc.Bottom - dc.Top, $A062625A);
            {Release;
            DrawAlphaOfColor(dsurface, dc.Left, dc.Top, dc.Right - dc.Left, dc.Bottom - dc.Top, 38099, 160);
            SetBkMode(Handle, TRANSPARENT);   }
          end;
          TextRect(dc, ShowStr, DFColor, [tfSingleLine, tfLeft, tfVerticalCenter]);
          
          dc.Top := SurfaceY(top + Height) + 1 + FShowHeight * (nI + 1);
          dc.Bottom := dc.Top + FShowHeight - 2;
          Inc(nI);
        end;
      end
      else
        FUpDown.Visible := False;
    end;
    if FUpDown.Visible then
      FUpDown.DirectPaint(dsurface);
  end;       
end;

function TDComboBox.GetItemIndex: Integer;
begin
  if FItemIndex >= FItem.Count then
    FItemIndex := -1;
  Result := FItemIndex;
end;

function TDComboBox.InRange(x, y: integer): Boolean;
var
  boinrange: Boolean;

begin
  if  ((x >= Left) and (x < Left + Width) and (y >= Top) and (y < Top + Height)) or
    ((FocusedControl = self) and (x >= Left) and (x < Left + FDWidth) and (y >= Top) and
      (y < Top + Height + FListHeight))
  then begin
    boinrange := TRUE;
    if Assigned(FOnInRealArea) then
      FOnInRealArea(self, x - Left, y - Top, boinrange);
    
    Result := boinrange;
  end
  else
    Result := FALSE;
end;

function TDComboBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
var
  i: Integer;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
  if Result and (FocusedControl = self) then begin
    if InRange(x, y) and (Y > Top + height) then begin
      i := (Y - Top - Height) div FShowHeight + FUpDown.Position;
      if (I < FItem.Count) and (I >= 0) and (FItemIndex <> I) then begin
        FItemIndex := I;
        if Assigned(FOnChange) then
          FOnChange(Self);
      end;
      
      FocusedControl := nil;
      FUpDown.Visible := False;
    end
    else begin
      if FItem.Count > FShowCount then begin
        FUpDown.MaxPosition := FItem.Count - FShowCount;
        if FUpDown.Position > (FItem.Count - FShowCount) then
          FUpDown.Position := 0;

        FUpDown.Visible := True;
      end;
    end;
  end;
end;

function TDComboBox.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Result and (FocusedControl = self) then begin
    FX := X;
    FY := Y;
  end;
end;

function TDComboBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
end;

procedure TDComboBox.SetItem(const Value: TStrings);
begin
  if Assigned(FItem) then
    FItem.Assign(Value)
  else
    FItem := Value;
  if FItem.Count > FShowCount then begin
    FUpDown.MaxPosition := FItem.Count - FShowCount;
    if FUpDown.Position > (FItem.Count - FShowCount) then
      FUpDown.Position := 0;
  end
  else
    FUpDown.Visible := False;
end;

procedure TDComboBox.SetItemIndex(const Value: Integer);
begin
  if Value >= FItem.Count then
    FItemIndex := -1
  else
    FItemIndex := Value;
end;

procedure TDComboBox.SetShowCount(Value: Integer);
begin
  FShowCount := Value;
  FListHeight := FShowCount * FShowHeight;
end;

procedure TDComboBox.SetShowHeight(Value: Integer);
begin
  FShowHeight := Value;
  FListHeight := FShowCount * FShowHeight;
end;

procedure TDComboBox.SetUpDownButton(Button: TDUpDown);
begin
  Button.DParent := Self;
  Button.Visible := False;
  Button.Offset := 0;
  Button.MoveShow := True;
  Button.FMouseFocus := False;
  Button.UpButton.FMouseFocus := False;
  Button.DownButton.FMouseFocus := False;
  Button.MoveButton.FMouseFocus := False;
  AddChild(Button);
end;



procedure TDListView.AddHead(sName: string; DBiDiMode: TDBiDiMode; Width: Word);
var
  DListViewHead: pTDListViewHead;
begin
  if (sName <> '') then begin
    New(DListViewHead);
    DListViewHead.sName := sName;
    DListViewHead.DBiDiMode := DBiDiMode;
    DListViewHead.nWidth := Width;
    FHeadList.Add(DListViewHead);
  end;
end;

function TDListView.AddItem: TStringList;
var
  StringList: TStringList;
begin
  StringList := TStringList.Create;
  FItemList.Add(StringList);
  Result := StringList;
end;

procedure TDListView.Clear;
var
  StringList: TStringList;
  I: Integer;
begin
  for I := 0 to FItemList.Count - 1 do begin
    StringList := FItemList.Items[i];
    StringList.Free;
  end;
  FItemList.Clear;
  FUpDown.Position := 0;
end;

procedure TDListView.ClearHead;
var
  DListViewHead: pTDListViewHead;
  I: Integer;
begin
  for I := 0 to FHeadList.Count - 1 do begin
    DListViewHead := FHeadList.Items[i];
    Dispose(DListViewHead);
  end;
  FHeadList.Clear;
end;

constructor TDListView.Create(AOwner: TComponent);
begin
  inherited;
  FUpDown := TDUpDown.Create(nil);
  SetUpDownButton(FUpDown);
  FHeadList := TList.Create;
  FItemList := TList.Create;
  Color := $004A8494;
  FItemHeigth := 18;
  FItemIndex := -1;
  FOnItemIndex := nil;
end;

destructor TDListView.Destroy;
begin
  Clear;
  ClearHead;
  FHeadList.Free;
  FUpDown.Free;
  FItemList.Free;
  inherited;
end;

procedure TDListView.DirectPaint(dsurface: TDirectDrawSurface);
{var
  ndc, dc: TRect;
  nLeft, nTop, I, ii: Integer;
  DListViewHead: pTDListViewHead;
  TempStr: string;
  StringList: TStringList;   }
begin
  {with dsurface.Canvas do begin
    SetBkMode(Handle, TRANSPARENT);
    Brush.Color := Color;
    ndc.Left := SurfaceX(left);
    ndc.Top := SurfaceY(top);
    ndc.Right := ndc.Left + Width;
    ndc.Bottom := ndc.Top + Height;
    FrameRect(ndc);
    nLeft := ndc.Left;
    nTop := ndc.Top;
    FItemCount := (ndc.Bottom - ndc.Top) div FItemHeigth - 1;
    FUpDown.MaxPosition := FItemList.Count - FItemCount;
    Release;
    for I := 0 to FHeadList.Count - 1 do begin
      SetBkMode(Handle, TRANSPARENT);
      DListViewHead := FHeadList.Items[i];
      dc.Left := nLeft;
      dc.Top := nTop;
      dc.Right := dc.Left + DListViewHead.nWidth + 1;
      dc.Bottom := dc.Top + FItemHeigth;
      DListViewHead.Rect.Left := nLeft + 6;
      DListViewHead.Rect.Top := nTop;
      DListViewHead.Rect.Right := dc.Left + DListViewHead.nWidth + 1 - 6;
      DListViewHead.Rect.Bottom := dc.Top + FItemHeigth;
      FrameRect(dc);
      Inc(nLeft, DListViewHead.nWidth);
      TempStr := DListViewHead.sName;
      Font.Color := clSilver;
      Font.Style := [fsBold];
      Release;
      SetBkMode(Handle, TRANSPARENT);
      case DListViewHead.DBiDiMode of
        dbLeft: TextRect(DListViewHead.Rect, TempStr, [tfSingleLine, tfLeft, tfVerticalCenter]);
        dbCenter: TextRect(DListViewHead.Rect, TempStr, [tfSingleLine, tfCenter, tfVerticalCenter]);
        dbRight: TextRect(DListViewHead.Rect, TempStr, [tfSingleLine, tfRight, tfVerticalCenter]);
      end;
      Release;
    end;
    SetBkMode(Handle, TRANSPARENT);
    dc.Left := nLeft;
    dc.Top := nTop;
    dc.Right := ndc.Right;
    dc.Bottom := dc.Top + FItemHeigth;
    FrameRect(dc);
    Release;
    SetBkMode(Handle, TRANSPARENT);
    nTop := ndc.Top + FItemHeigth;
    Font.Style := [];
    Font.Color := clWhite;
    for I := Max(FUpDown.Position, 0) to (Max(FUpDown.Position, 0) + FItemCount
      - 1) do begin
      if (i >= FItemList.Count) or (i < 0) then
        Break;
      StringList := FItemList.Items[i];
      if FItemIndex = i then
        Font.Color := clRed
      else
        Font.Color := clWhite;
      for ii := 0 to StringList.Count - 1 do begin
        if ii >= FHeadList.Count then
          Break;
        DListViewHead := FHeadList.Items[ii];
        DListViewHead.Rect.Top := nTop;
        DListViewHead.Rect.Bottom := DListViewHead.Rect.Top + FItemHeigth;
        TempStr := StringList.Strings[ii];
        case DListViewHead.DBiDiMode of
          dbLeft: TextRect(DListViewHead.Rect, TempStr, [tfSingleLine, tfLeft, tfVerticalCenter]);
          dbCenter: TextRect(DListViewHead.Rect, TempStr, [tfSingleLine, tfCenter, tfVerticalCenter]);
          dbRight: TextRect(DListViewHead.Rect, TempStr, [tfSingleLine, tfRight, tfVerticalCenter]);
        end;
      end;
      Inc(nTop, FItemHeigth);
    end;
    Release;
  end;         }
  if FItemList.Count > FItemCount then begin
    FUpDown.Top := FItemHeigth + 1;
    FUpDown.Left := Width - FUpDown.Width - 1;
    FUpDown.Height := Height - FItemHeigth - 2;
    FUpDown.DirectPaint(dsurface);
  end
  else
    FUpDown.Position := 0;
end;

function TDListView.GetItems(Index: Integer): TStringList;
begin
  Result := nil;
  if (Index >= 0) and (Index < FItemList.Count) then
    Result := FItemList.Items[Index];
end;

function TDListView.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
var
  i: Integer;
  DListViewHead: pTDListViewHead;
begin
  Result := inherited MouseDown(Button, Shift, X, Y);
  if Result and (FocusedControl = self) and ((X - left) < (Width -
    FUpDown.Width)) and
    (FItemIndex <> -1) then begin
    Dec(x, left);
    for I := 0 to FHeadList.Count - 1 do begin
      DListViewHead := FHeadList.Items[i];
      if X < DListViewHead.nWidth then begin
        if Assigned(FOnItemIndex) then
          FOnItemIndex(Self, FItemIndex, I);
        Break;
      end;
      Dec(X, DListViewHead.nWidth);
    end;
  end;
end;

function TDListView.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Result and (InRange(x, y)) then begin
    if (Y - top) <= FItemHeigth then begin
      FItemIndex := -1;
    end
    else
      FItemIndex := ((Y - top) - FItemHeigth) div FItemHeigth +
        FUpDown.Position;
    if (FItemIndex - FUpDown.Position) > (FItemCount - 1) then
      FItemIndex := -1;

  end;
end;

procedure TDListView.SetUpDownButton(Button: TDUpDown);
begin
  Button.DParent := Self;
  Button.Visible := True;

  AddChild(Button);
end;



function TDMemo.ClearKey: Boolean;
var
  nStartY, nStopY: Integer;
  nStartX, nStopX: Integer;
  TempStr: WideString;
  i: Integer;
begin
  Result := False;
  if FLines.Count > 0 then begin
    if (FCaretX <> FSCaretX) or (FSCaretY <> FCaretY) then begin

      if FSCaretY < 0 then
        FSCaretY := 0;
      if FSCaretY >= FLines.Count then
        FSCaretY := FLines.Count - 1;

      if FCaretY < 0 then
        FCaretY := 0;
      if FCaretY >= FLines.Count then
        FCaretY := FLines.Count - 1;

      if FSCaretY = FCaretY then begin
        if FSCaretX > FCaretX then begin
          nStartX := FCaretX;
          nStopX := FSCaretX;
        end
        else begin
          nStartX := FSCaretX;
          nStopX := FCaretX;
        end;

        TempStr := TDMemoStringList(FLines).Str[FCaretY];
        Delete(TempStr, nStartX + 1, nStopX - nStartX);
        TDMemoStringList(FLines).Str[FCaretY] := TempStr;
        RefListWidth(FCaretY, 0);
        FCaretX := nStartX;
        SetCaret(True);
        Result := True;
      end
      else begin
        if FSCaretY > FCaretY then begin
          nStartY := FCaretY;
          nStopY := FSCaretY;
          nStartX := FCaretX;
          nStopX := FSCaretX;
        end
        else begin
          nStartY := FSCaretY;
          nStopY := FCaretY;
          nStartX := FSCaretX;
          nStopX := FCaretX;
        end;
        TempStr := TDMemoStringList(FLines).Str[nStartY];
        Delete(TempStr, nStartX + 1, 255);
        TDMemoStringList(FLines).Str[nStartY] := TempStr;

        TempStr := TDMemoStringList(FLines).Str[nStopY];
        Delete(TempStr, 1, nStopX);
        TDMemoStringList(FLines).Str[nStartY] :=
          TDMemoStringList(FLines).Str[nStartY] + TempStr;
        FLines.Objects[nStartY] := FLines.Objects[nStopY];
        FLines.Delete(nStopY);
        if (nStopY - nStartY) > 1 then
          for i := nStopY - 1 downto nStartY + 1 do
            FLines.Delete(i);
        RefListWidth(nStartY, nStartX);
        SetCaret(True);
        Result := True;
      end;
    end;
  end;
end;

constructor TDMemo.Create(AOwner: TComponent);
begin
  inherited;
  FKeyFocus := True;
  FCaretShowTime := GetTickCount;

  Downed := False;
  KeyDowned := False;

  FUpDown := nil;

  FTopIndex := 0;
  FCaretY := 0;
  FCaretX := 0;

  FSCaretX := 0;
  FSCaretY := 0;

  FInputStr := '';
  bDoubleByte := False;
  KeyByteCount := 0;

  FTransparent := False;

  FMaxLength := 0;

  FOnChange := nil;
  FReadOnly := False;
  FFrameColor := clBlack;
  Color := clBlack;

  FLines := TDMemoStringList.Create;
  TDMemoStringList(FLines).DMemo := Self;

  Font.Name := DEFFONTNAME;
  Font.Color := clWhite;
  Font.Size := DEFFONTSIZE;
  //DrawCanvas.Font.Name := Font.Name;
  //DrawCanvas.Font.Color := Font.Color;
  //DrawCanvas.Font.Size := Font.Size;

  FMoveTick := GetTickCount;
end;

destructor TDMemo.Destroy;
begin
  FLines.Free;
  inherited;
end;

procedure TDMemo.DirectPaint(dsurface: TDirectDrawSurface);
var
  dc: TRect;
  nShowCount, i: Integer;
  ax, ay: Integer;
  TempStr: string;
  nStartY, nStopY: Integer;
  nStartX, nStopX: Integer;
  addax: Integer;
begin
  dc.Left := SurfaceX(Left);
  dc.Top := SurfaceY(Top);
  dc.Right := SurfaceX(left + Width);
  dc.Bottom := SurfaceY(top + Height);


  if not FTransparent then begin
    DrawCanvas.FillRect(dc, LongWord(Color) or $FF000000, fxBlend);
    DrawCanvas.RoundRect(dc.Left, dc.Top, dc.Right, dc.Bottom, FrameColor);
   { dsurface.Canvas.Brush.Color := Color;
    dsurface.Canvas.Pen.Color := FrameColor;
    dsurface.Canvas.Pen.Style := psAlternate;
    dsurface.Canvas.RoundRect(dc.Left, dc.Top, dc.Right, dc.Bottom, 0, 0);}
  end;
  if (GetTickCount - FCaretShowTime) > 500 then begin
    FCaretShowTime := GetTickCount;
    FCaretShow := not FCaretShow;
  end;

  nShowCount := (Height - 1) div 14;
  if (FTopIndex + nShowCount - 1) > Lines.Count then begin
    FTopIndex := Max(Lines.Count - nShowCount + 1, 0);
  end;
  if (FCaretY >= Lines.Count) then
    FCaretY := Max(Lines.Count - 1, 0);
  if FCaretY < 0 then begin
    FTopIndex := 0;
    FCaretY := 0;
  end;

  if Lines.Count > nShowCount then begin
    if FUpDown <> nil then begin
      if not FUpDown.Visible then
        FUpDown.Visible := True;
      FUpDown.MaxPosition := Lines.Count - nShowCount;
      FUpDown.Position := FTopIndex;
    end;
  end
  else begin
    if FUpDown <> nil then begin
      if FUpDown.Visible then
        FUpDown.Visible := False;
      FTopIndex := 0;
    end;
  end;

  if FSCaretY > FCaretY then begin
    nStartY := FCaretY;
    nStopY := FSCaretY;
    nStartX := FCaretX;
    nStopX := FSCaretX;
  end
  else begin
    nStartY := FSCaretY;
    nStopY := FCaretY;
    nStartX := FSCaretX;
    nStopX := FCaretX;
  end;
  if FSCaretY = FCaretY then begin
    if FSCaretX > FCaretX then begin
      nStartX := FCaretX;
      nStopX := FSCaretX;
    end
    else if FSCaretX < FCaretX then begin
      nStartX := FSCaretX;
      nStopX := FCaretX;
    end
    else begin
      nStartX := -1;
    end;
  end;
  ax := SurfaceX(Left) + 2;
  ay := SurfaceY(Top) + 2;
  with DrawCanvas do begin
    //Font.Color := FDFColor;
    //SetBkMode(Handle, TRANSPARENT);
    for i := FTopIndex to (FTopIndex + nShowCount - 1) do begin
      if i >= Lines.Count then
        Break;
      if nStartY <> nStopY then begin
        if i = nStartY then begin
          TempStr := Copy(WideString(Lines[i]), 1, nStartX);
          TextOut(ax, ay + (i - FTopIndex) * 14, TempStr, FDFColor);
          addax := TextWidth(TempStr);
          //Release;
          TempStr := Copy(WideString(Lines[i]), nStartX + 1, 255);
          //SetBkMode(Handle, OPAQUE);
          //Brush.Color := $C66931;
          FillRect(ax + addax, ay + (i - FTopIndex) * 14 - 1, TextWidth(TempStr), 16, $C9C66931);
          TextOut(ax + addax, ay + (i - FTopIndex) * 14, TempStr, FDFColor);
          //Release;
          //SetBkMode(Handle, TRANSPARENT);
        end
        else if i = nStopY then begin
          //Release;
          TempStr := Copy(WideString(Lines[i]), 1, nStopX);
          addax := TextWidth(TempStr);
          //SetBkMode(Handle, OPAQUE);
          //Brush.Color := $C66931;
          FillRect(ax, ay + (i - FTopIndex) * 14 - 1, addax, 16, $C9C66931);
          TextOut(ax, ay + (i - FTopIndex) * 14, TempStr, FDFColor);
          //Release;
          //SetBkMode(Handle, TRANSPARENT);
          TempStr := Copy(WideString(Lines[i]), nStopX + 1, 255);
          TextOut(ax + addax, ay + (i - FTopIndex) * 14, TempStr, FDFColor);
        end
        else if (i > nStartY) and (i < nStopY) then begin
          //Release;
          //SetBkMode(Handle, OPAQUE);
          //Brush.Color := $C66931;
          FillRect(ax, ay + (i - FTopIndex) * 14 - 1, TextWidth(Lines[i]), 16, $C9C66931);
          TextOut(ax, ay + (i - FTopIndex) * 14, Lines[i], FDFColor);
          //Release;
          //SetBkMode(Handle, TRANSPARENT);
        end
        else
          TextOut(ax, ay + (i - FTopIndex) * 14, Lines[i], FDFColor);
      end
      else begin
        if (nStartX <> -1) and (i = FSCaretY) then begin
          TempStr := Copy(WideString(Lines[i]), 1, nStartX);
          TextOut(ax, ay + (i - FTopIndex) * 14, TempStr, FDFColor);
          addax := TextWidth(TempStr);
          //Release;
          TempStr := Copy(WideString(Lines[i]), nStartX + 1, nStopX - nStartX);
          //SetBkMode(Handle, OPAQUE);
          //Brush.Color := $C66931;
          FillRect(ax + addax, ay + (i - FTopIndex) * 14 - 1, TextWidth(TempStr), 16, $C9C66931);
          TextOut(ax + addax, ay + (i - FTopIndex) * 14, TempStr, FDFColor);
          addax := addax + TextWidth(TempStr);
          //Release;
          //SetBkMode(Handle, TRANSPARENT);
          TempStr := Copy(WideString(Lines[i]), nStopX + 1, 255);
          TextOut(ax + addax, ay + (i - FTopIndex) * 14, TempStr, FDFColor);
        end
        else
          TextOut(ax, ay + (i - FTopIndex) * 14, Lines[i], FDFColor);
      end;
    end;
    if (FCaretY >= FTopIndex) and (FCaretY < (FTopIndex + nShowCount)) then begin
      ay := ay + (Max(FCaretY - FTopIndex, 0)) * 14;
      if FCaretY < Lines.Count then begin
        TempStr := LeftStr(WideString(Lines[FCaretY]), FCaretX);
        ax := ax + TextWidth(TempStr);
      end;
      if FCaretShow and (KeyControl = Self) then begin
        //Pen.Color := Self.Font.Color;
        FrmIMEX := ax;
        FrmIMEY := ay;
        RoundRect(ax, ay, ax + 1, ay + 12, clWhite);
      end;
    end;
    //Release;
  end;        
  for i := 0 to DControls.Count - 1 do
    if TDControl(DControls[i]).Visible then
      TDControl(DControls[i]).DirectPaint(dsurface);
end;

procedure TDMemo.Enter;
begin
  inherited;
end;

function TDMemo.GetKey: string;
var
  nStartY, nStopY: Integer;
  nStartX, nStopX: Integer;
  TempStr: WideString;
  i: Integer;
begin
  Result := '';
  if FLines.Count > 0 then begin
    if (FCaretX <> FSCaretX) or (FSCaretY <> FCaretY) then begin

      if FSCaretY < 0 then
        FSCaretY := 0;
      if FSCaretY >= FLines.Count then
        FSCaretY := FLines.Count - 1;

      if FCaretY < 0 then
        FCaretY := 0;
      if FCaretY >= FLines.Count then
        FCaretY := FLines.Count - 1;

      if FSCaretY = FCaretY then begin
        if FSCaretX > FCaretX then begin
          nStartX := FCaretX;
          nStopX := FSCaretX;
        end
        else begin
          nStartX := FSCaretX;
          nStopX := FCaretX;
        end;
        TempStr := FLines[FCaretY];
        Result := Copy(TempStr, nStartX + 1, nStopX - nStartX);
      end
      else begin
        if FSCaretY > FCaretY then begin
          nStartY := FCaretY;
          nStopY := FSCaretY;
          nStartX := FCaretX;
          nStopX := FSCaretX;
        end
        else begin
          nStartY := FSCaretY;
          nStopY := FCaretY;
          nStartX := FSCaretX;
          nStopX := FCaretX;
        end;
        TempStr := FLines[nStartY];
        Result := Copy(TempStr, nStartX + 1, 255);
        if Integer(FLines.Objects[nStartY]) = 13 then
          Result := Result + #13#10;
        if (nStopY - nStartY) > 1 then
          for i := nStartY + 1 to nStopY - 1 do begin
            Result := Result + FLines[i];
            if Integer(FLines.Objects[i]) = 13 then
              Result := Result + #13#10;
          end;
        TempStr := FLines[nStopY];
        Result := Result + Copy(TempStr, 1, nStopX);
        if Integer(FLines.Objects[nStopY]) = 13 then
          Result := Result + #13#10;
      end;
    end;
  end;
end;

function TDMemo.GetText: string;
var
  P: PChar;
begin
  P := FLines.GetText;
  Result := P;
  StrDispose(P);
end;

procedure TDMemo.IsVisible(flag: Boolean);
begin
  inherited;
  if FUpDown <> nil then begin
    FUpDown.Visible := flag;
  end;
end;

procedure TDMemo.KeyCaret(Key: Word);
var
  TempStr: WideString;
  nShowCount: Integer;
begin
  if FLines.Count > 0 then begin
    if FCaretY < 0 then
      FCaretY := 0;
    if FCaretY >= FLines.Count then
      FCaretY := FLines.Count - 1;
    TempStr := TDMemoStringList(FLines).Str[FCaretY];
    case Key of
      VK_UP: begin
          if FCaretY > 0 then
            Dec(FCaretY);
        end;
      VK_DOWN: begin
          if FCaretY < (FLines.Count - 1) then
            Inc(FCaretY);
        end;
      VK_RIGHT: begin
          if FCaretX < Length(TempStr) then
            Inc(FCaretX)
          else begin
            if FCaretY < (FLines.Count - 1) then begin
              Inc(FCaretY);
              FCaretX := 0;
            end;
          end;
        end;
      VK_LEFT: begin
          if FCaretX > 0 then
            Dec(FCaretX)
          else begin
            if FCaretY > 0 then begin
              Dec(FCaretY);
              FCaretX :=
                Length(WideString(TDMemoStringList(FLines).Str[FCaretY]));
            end;
          end;
        end;
    end;
    nShowCount := (Height - 1) div 14;
    if FCaretY < FTopIndex then
      FTopIndex := FCaretY
    else begin
      if (FCaretY - FTopIndex) >= nShowCount then begin
        FTopIndex := _Max(FCaretY - nShowCount + 1, 0);
      end;
    end;

    if not KeyDowned then
      SetCaret(False);
  end;
end;

function TDMemo.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  Clipboard: TClipboard;
  AddTx, Data: string;
  boAdd: Boolean;
  TempStr: WideString;
  nKey: Char;
  I: Integer;
begin
  Result := FALSE;

  if (KeyControl = self) then begin
    if not FReadOnly then
      KeyDownControl := Self;
    if Assigned(FOnKeyDown) then
      FOnKeyDown(self, Key, Shift);
    if Key = 0 then
      exit;
    if (ssCtrl in Shift) and (not Downed) and (Key = Word('A')) then begin
      if FLines.Count > 0 then begin
        FCaretY := FLines.Count - 1;
        FCaretX := Length(WideString(TDMemoStringList(FLines).Str[FCaretY]));
        SetCaret(True);
        FSCaretX := 0;
        FSCaretY := 0;
      end;
      Key := 0;
      Result := True;
      Exit;
    end
    else if (ssCtrl in Shift) and (not Downed) and (Key = Word('X')) then begin
      if not FReadOnly then begin
        AddTx := GetKey;
        if AddTx <> '' then begin
          Clipboard := TClipboard.Create;
          Clipboard.AsText := AddTx;
          Clipboard.Free;
          ClearKey();
          TextChange();
        end;
        Key := 0;
      end;
      Result := True;
      Exit;
    end
    else if (ssCtrl in Shift) and (not Downed) and (Key = Word('C')) then begin
      AddTx := GetKey;
      if AddTx <> '' then begin
        Clipboard := TClipboard.Create;
        Clipboard.AsText := AddTx;
        Clipboard.Free;
      end;
      Key := 0;
      Result := True;
      Exit;
    end
    else if (ssCtrl in Shift) and (not Downed) and (Key = Word('V')) then begin
      if not FReadOnly then begin
        ClearKey();
      
        Clipboard := TClipboard.Create;
        AddTx := Clipboard.AsText;
        boAdd := False;
        while True do begin
          if AddTx = '' then break;
          AddTx := GetValidStr3(AddTx, data, [#13]);
          if Data <> '' then begin
            data := AnsiReplaceText(data, #10, '');
            if (MaxLength > 0) and ((Length(GetText) + Length(data)) >= MaxLength) then begin
              for I := 1 to Length(data) do begin
                nKey := data[i];
                if (nKey = #13) or (nKey = #10) then Continue;
                KeyPress(nKey);
              end;
              break;
            end;

            if Data = '' then Data := #9;
            if FLines.Count <= 0 then begin
              FLines.AddObject(Data, TObject(13));
              FCaretY := 0;
              RefListWidth(FCaretY, -1);
            end
            else if boAdd then begin
              Inc(FCaretY);
              FLines.InsertObject(FCaretY, Data, TObject(13));
              FCaretX := 0;
              RefListWidth(FCaretY, -1);
            end
            else begin
              TempStr := TDMemoStringList(FLines).Str[FCaretY];
              Insert(Data, TempStr, FCaretX + 1);
              TDMemoStringList(FLines).Str[FCaretY] := TempStr;
              Inc(FCaretX, Length(WideString(Data)));
              FLines.Objects[FCaretY] := TObject(13);
              RefListWidth(FCaretY, FCaretX);
            end;

            boAdd := True;
          end;
        end;
        if boAdd then TextChange();
        Clipboard.Free;
      end;
      Key := 0;
      Result := True;
      Exit;
    end
    else if (ssShift in Shift) and (not Downed) then begin
      KeyDowned := True;
    end
    else
      KeyDowned := False;
    if FLines.Count <= 0 then
      exit;
    case Key of
      VK_UP,
        VK_DOWN,
        VK_RIGHT,
        VK_LEFT: begin
          KeyCaret(Key);
          Key := 0;
          Result := TRUE;
        end;
      VK_BACK: begin
          if (not FReadOnly) then begin
            if not ClearKey then begin
              while True do begin
                TempStr := TDMemoStringList(FLines).Str[FCaretY];
                if FCaretX > 0 then begin
                  Delete(TempStr, FCaretX, 1);
                  if TempStr = '' then begin
                    FLines.Delete(FCaretY);
                    if FCaretY > 0 then begin
                      Dec(FCaretY);
                      FCaretX :=
                        Length(WideString(TDMemoStringList(FLines).Str[FCaretY]));
                      SetCaret(True);
                    end
                    else begin
                      FCaretY := 0;
                      FCaretX := 0;
                      SetCaret(False);
                    end;
                    Exit;
                  end
                  else begin
                    TDMemoStringList(FLines).Str[FCaretY] := TempStr;
                    Dec(FCaretX);
                  end;
                  break;
                end
                else if FCaretX = 0 then begin
                  if FCaretY > 0 then begin
                    if Integer(FLines.Objects[FCaretY - 1]) = 13 then begin
                      FLines.Objects[FCaretY - 1] := nil;
                      Break;
                    end
                    else begin
                      FLines.Objects[FCaretY - 1] := FLines.Objects[FCaretY];
                      FCaretX :=
                        Length(WideString(TDMemoStringList(FLines).Str[FCaretY -
                        1]));
                      TDMemoStringList(FLines).Str[FCaretY - 1] :=
                        TDMemoStringList(FLines).Str[FCaretY - 1] +
                        TDMemoStringList(FLines).Str[FCaretY];
                      FLines.Delete(FCaretY);
                      Dec(FCaretY);
                    end;
                  end
                  else
                    Break;
                end
                else
                  Break;
              end;
              RefListWidth(FCaretY, FCaretX);
              SetCaret(True);
            end;
            TextChange();
          end;
          Key := 0;
          Result := TRUE;
        end;
      VK_DELETE: begin
          if (not FReadOnly) then begin
            if not ClearKey then begin
              while True do begin
                TempStr := TDMemoStringList(FLines).Str[FCaretY];
                if Length(TempStr) > FCaretX then begin
                  Delete(TempStr, FCaretX + 1, 1);
                  if TempStr = '' then begin
                    FLines.Delete(FCaretY);
                    if FCaretY > 0 then begin
                      Dec(FCaretY);
                      FCaretX :=
                        Length(WideString(TDMemoStringList(FLines).Str[FCaretY]));
                      SetCaret(True);
                    end
                    else begin
                      FCaretY := 0;
                      FCaretX := 0;
                      SetCaret(False);
                    end;
                    Exit;
                  end
                  else
                    TDMemoStringList(FLines).Str[FCaretY] := TempStr;
                  break;
                end
                else if Integer(FLines.Objects[FCaretY]) = 13 then begin
                  FLines.Objects[FCaretY] := nil;
                  break;
                end
                else begin
                  if (FCaretY + 1) < FLines.Count then begin
                    TDMemoStringList(FLines).Str[FCaretY] :=
                      TDMemoStringList(FLines).Str[FCaretY] +
                      TDMemoStringList(FLines).Str[FCaretY + 1];
                    FLines.Objects[FCaretY] := FLines.Objects[FCaretY + 1];
                    FLines.Delete(FCaretY + 1);
                  end
                  else
                    Break;
                end;
              end;
              RefListWidth(FCaretY, FCaretX);
              SetCaret(True);
            end;
            TextChange();
          end;
          Key := 0;
          Result := TRUE;
        end;
    end;
    
    
  end;
end;

function TDMemo.KeyPress(var Key: Char): Boolean;
var
  
  TempStr, Temp: WideString;
  OldObject: Integer;
begin
  Result := False;
  if (KeyControl = Self) then begin
    if (not Downed) and (not FReadOnly) then begin
      Result := True;
      if Assigned(FOnKeyPress) then
        FOnKeyPress(self, Key);
      if Key = #0 then
        Exit;

      if (FCaretY >= Lines.Count) then
        FCaretY := _Max(Lines.Count - 1, 0);
      if FCaretY < 0 then begin
        FTopIndex := 0;
        FCaretY := 0;
      end;
      if Key = #13 then begin
        if (MaxLength > 0) and (Length(GetText) >= MaxLength) then begin
          Key := #0;
          exit;
        end;
        if FLines.Count <= 0 then begin
          FLines.AddObject('', TObject(13));
          FLines.AddObject('', TObject(13));
          FCaretX := 0;
          FCaretY := 1;
          SetCaret(True);
        end
        else begin
          Temp := TDMemoStringList(FLines).Str[FCaretY];
          OldObject := Integer(FLines.Objects[FCaretY]);

          TempStr := Copy(Temp, 1, FCaretX);
          TDMemoStringList(FLines).Str[FCaretY] := TempStr;
          FLines.Objects[FCaretY] := TObject(13);

          TempStr := Copy(Temp, FCaretX + 1, 255);
          if TempStr <> '' then begin
            FLines.InsertObject(FCaretY + 1, TempStr, TObject(OldObject));
          end
          else begin
            FLines.InsertObject(FCaretY + 1, '', TObject(OldObject));
          end;
          RefListWidth(FCaretY + 1, 0);
          FCaretY := FCaretY + 1;
          FCaretX := 0;
          SetCaret(True);
        end;
        exit;
      end;

      if (FEditClass = deInteger) and (not (key in AllowedIntegerChars)) then begin
        Key := #0;
        exit;
      end
      else if (FEditClass = deMonoCase) and (not (key in AllowedEnglishChars)) then begin
        Key := #0;
        exit;
      end;
      if (FEditClass = deEnglishAndInt) and (not (key in AllowedStandard)) then begin
        key := #0;
        exit;
      end;
      if (FEditClass = deCDKey) and (not (key in AllowedCDKey)) then begin
        key := #0;
        exit;
      end;

      if (key in AllowedChars) then begin
        if IsDBCSLeadByte(Ord(Key)) or bDoubleByte then begin
          bDoubleByte := true;
          Inc(KeyByteCount);
          FInputStr := FInputStr + key;
        end;
        if not bDoubleByte then begin
          if (FEditClass = deStandard) and (not (key in AllowedStandard)) then begin
            Key := #0;
            exit;
          end;
          ClearKey;
          if (MaxLength > 0) and (Length(GetText) >= MaxLength) then begin
            Key := #0;
            exit;
          end;
          if FLines.Count <= 0 then begin
            FLines.AddObject(Key, nil);
            FCaretX := 1;
            FCaretY := 0;
          end
          else begin
            TempStr := TDMemoStringList(FLines).Str[FCaretY];
            Insert(Key, TempStr, FCaretX + 1);
            TDMemoStringList(FLines).Str[FCaretY] := TempStr;
            Inc(FCaretX);
            RefListWidth(FCaretY, FCaretX);
          end;
          SetCaret(True);
          Key := #0;
          TextChange();
        end
        else if KeyByteCount >= 2 then begin
          if length(FInputStr) <> 2 then begin
            bDoubleByte := false;
            KeyByteCount := 0;
            FInputStr := '';
            Key := #0;
            exit;
          end;
          if (FEditClass = deStandard) and (not FiltrateStandardChar(Ord(FInputStr[1]), Ord(FInputStr[2]))) then begin
            bDoubleByte := false;
            KeyByteCount := 0;
            FInputStr := '';
            Key := #0;
            exit;
          end;
          if (FEditClass = deChinese) and (not FiltrateChar(Ord(FInputStr[1]), Ord(FInputStr[2]))) then begin
            bDoubleByte := false;
            KeyByteCount := 0;
            FInputStr := '';
            Key := #0;
            exit;
          end;
          ClearKey;
          if (MaxLength > 0) and (Length(string(GetText)) >= (MaxLength - 1)) then begin
            bDoubleByte := false;
            KeyByteCount := 0;
            FInputStr := '';
            Key := #0;
            exit;
          end;
          if FLines.Count <= 0 then begin
            FLines.AddObject(FInputStr, nil);
            FCaretX := 1;
            FCaretY := 0;
          end
          else begin
            TempStr := TDMemoStringList(FLines).Str[FCaretY];
            Insert(FInputStr, TempStr, FCaretX + 1);
            TDMemoStringList(FLines).Str[FCaretY] := TempStr;
            Inc(FCaretX);
            RefListWidth(FCaretY, FCaretX);
          end;
          SetCaret(True);
          bDoubleByte := false;
          KeyByteCount := 0;
          FInputStr := '';
          Key := #0;
          TextChange();
        end;
      end;
      Key := #0;
    end else begin
      Result := False;
    end;
  end;
end;

function TDMemo.KeyUp(var Key: Word; Shift: TShiftState): Boolean;
begin
  Result := FALSE;

  if (KeyControl = self) then begin
    if (ssShift in Shift) then begin
      KeyDowned := False;
    end;
    if Assigned(FOnKeyUp) then
      FOnKeyUp(self, Key, Shift);
    Key := 0;
    Result := TRUE;
  end;
end;

procedure TDMemo.Leave;
begin
  inherited;
end;

function TDMemo.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
begin
  Result := FALSE;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    if (not Background) and (MouseCaptureControl = nil) then begin
      KeyDowned := False;
      if mbLeft = Button then begin
        if (FocusedControl = self) then begin
          DownCaret(X - left, Y - top);
        end;
        SetCaret(False);
        Downed := True;
      end;
      SetDCapture(self);
    end;
    Result := TRUE;
  end;
end;

function TDMemo.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Result and (MouseCaptureControl = self) then begin
    if Downed and (not KeyDowned) then
      MoveCaret(X - left, Y - top);
  end;
end;

function TDMemo.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
begin
  Result := FALSE;
  Downed := False;
  if inherited MouseUp(Button, Shift, X, Y) then begin
    ReleaseDCapture;
    if not Background then begin
      if InRange(X, Y) then begin
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
      end;
    end;
    Result := TRUE;
    exit;
  end
  else begin
    ReleaseDCapture;
  end;
end;

procedure TDMemo.MoveCaret(X, Y: Integer);
var
  tempstrw: WideString;
  nShowCount, i: Integer;
  tempstr: string;
begin
  nShowCount := (Height - 1) div 14;
  if Y < 0 then begin 
    if (GetTickCount - FMoveTick) < 50 then
      Exit;
    if FTopIndex > 0 then
      Dec(FTopIndex);
    FCaretY := FTopIndex;
  end
  else if Y > Height then begin 
    if (GetTickCount - FMoveTick) < 50 then
      Exit;
    Inc(FCaretY);
    if FCaretY >= FLines.Count then
      FCaretY := _Max(FLines.Count - 1, 0);
    FTopIndex := _Max(FCaretY - nShowCount + 1, 0);
  end
  else
    FCaretY := (y - 1) div 14 + FTopIndex;
  FMoveTick := GetTickCount;

  if FCaretY >= FLines.Count then
    FCaretY := _Max(FLines.Count - 1, 0);
  FCaretX := 0;
  if FCaretY < FLines.Count then begin
    tempstrw := TDMemoStringList(FLines).Str[FCaretY];
    if tempstrw <> '' then begin
      for i := 1 to Length(tempstrw) do begin
        tempstr := Copy(tempstrw, 1, i);
        if (DrawCanvas.TextWidth(tempstr)) > (X) then
          exit;
        FCaretX := i;
      end;
    end;
  end;
end;

procedure TDMemo.PositionChange(Sender: TObject);
begin
  FTopIndex := FUpDown.Position;
end;

procedure TDMemo.RefListWidth(ItemIndex: Integer; nCaret: Integer);
var
  i, Fi, nIndex, nY: Integer;
  TempStr, AddStr: WideString;
begin
  TempStr := '';
  nIndex := 0;
  while True do begin
    if ItemIndex >= FLines.Count then
      Break;
    TempStr := TempStr + TDMemoStringList(FLines).Str[ItemIndex];
    nIndex := Integer(Lines.Objects[ItemIndex]);
    FLines.Delete(ItemIndex);
    if nIndex = 13 then
      Break;
  end;
  if TempStr <> '' then begin
    AddStr := '';
    Fi := 1;
    nY := ItemIndex;
    for i := 1 to Length(TempStr) + 1 do begin
      AddStr := Copy(TempStr, Fi, i - Fi + 1);
      if DrawCanvas.TextWidth(AddStr) > (Width - 20) then begin
        AddStr := Copy(TempStr, Fi, i - Fi);
        Fi := i;
        FLines.InsertObject(ItemIndex, AddStr, nil);
        nIndex := ItemIndex;
        Inc(ItemIndex);
        nY := ItemIndex;
        AddStr := '';
      end;
      if i = nCaret then begin
        FCaretX := i - Fi + 1;
        FCaretY := nY;
        SetCaret(True);
      end;
    end;
    if AddStr <> '' then begin
      FLines.InsertObject(ItemIndex, AddStr, TObject(13));
      nIndex := ItemIndex;
    end
    else begin
      FLines.Objects[nIndex] := TObject(13);
    end;
    if nCaret = -1 then begin
      FCaretY := nIndex;
      FCaretX := Length(WideString(TDMemoStringList(FLines).Str[nIndex]));
      SetCaret(True);
    end;
    
  end;
  if FCaretY >= FLines.Count then begin
    FCaretY := _Max(FLines.Count - 1, 0);
    SetCaret(True);
  end;
end;

procedure TDMemo.DownCaret(X, Y: Integer);
var
  tempstrw: WideString;
  i: Integer;
  tempstr: string;
begin
  FCaretY := (y - 1) div 14 + FTopIndex;
  if FCaretY >= FLines.Count then
    FCaretY := _Max(FLines.Count - 1, 0);
  FCaretX := 0;
  if FCaretY < FLines.Count then begin
    tempstrw := TDMemoStringList(FLines).Str[FCaretY];
    if tempstrw <> '' then begin
      for i := 1 to Length(tempstrw) do begin
        tempstr := Copy(tempstrw, 1, i);
        if (DrawCanvas.TextWidth(tempstr)) > (X) then
          exit;
        FCaretX := i;
      end;
    end;
  end;
end;

function TDMemo.Selected: Boolean;
begin
  Result := False;
  if FLines.Count > 0 then begin
    if (FCaretX <> FSCaretX) or (FSCaretY <> FCaretY) then begin
      Result := True;
    end;
  end;
end;

procedure TDMemo.SetCaret(boBottom: Boolean);
var
  nShowCount: Integer;
begin
  FSCaretX := FCaretX;
  FSCaretY := FCaretY;
  if boBottom then begin
    nShowCount := (Height - 1) div 14;
    if FCaretY < FTopIndex then
      FTopIndex := FCaretY
    else begin
      if (FCaretY - FTopIndex) >= nShowCount then begin
        FTopIndex := _Max(FCaretY - nShowCount + 1, 0);
      end;
    end;
  end;
end;

procedure TDMemo.SetCaretY(const Value: Integer);
begin
  FCaretY := Value;
  if FCaretY >= FLines.Count then
    FCaretY := _Max(FLines.Count - 1, 0);
  if FCaretY < 0 then
    FCaretY := 0;
  SetCaret(True);
end;

procedure TDMemo.SetFocus;
begin
  inherited;
end;

procedure TDMemo.SetUpDown(const Value: TDUpDown);
begin
  FUpDown := Value;
  FWheelDControl := Value;
  if FUpDown <> nil then begin
    FUpDown.OnPositionChange := PositionChange;
    FUpDown.Visible := False;
    FUpDown.MaxPosition := 0;
    FUpDown.Position := 0;
  end;
end;

procedure TDMemo.TextChange;
begin
  if Assigned(FOnChange) then
    FOnChange(self);
end;



function TDMemoStringList.Add(const S: string): Integer;
begin
  Result := AddObject(S, TObject(13));
  DMemo.RefListWidth(Result, -1);
end;

function TDMemoStringList.AddObject(const S: string; AObject: TObject): Integer;
var
  AddStr: string;
begin
  AddStr := AnsiReplaceText(S, #13, '');
  AddStr := AnsiReplaceText(AddStr, #10, '');
  if AddStr = '' then begin
    Result := inherited AddObject(#9, AObject);
  end
  else
    Result := inherited AddObject(AddStr, AObject);
end;

procedure TDMemoStringList.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  DMemo.FCaretY := 0;
  DMemo.FCaretX := 0;
  DMemo.SetCaret(False);
end;

procedure TDMemoStringList.Clear;
begin
  inherited;
  DMemo.FCaretY := 0;
  DMemo.FCaretX := 0;
  DMemo.SetCaret(False);
end;

function TDMemoStringList.Get(Index: Integer): string;
begin
  Result := inherited Get(Index);
  Result := AnsiReplaceText(Result, #9, '');
end;

procedure TDMemoStringList.InsertObject(Index: Integer; const S: string;
  AObject: TObject);
var
  AddStr: string;
begin
  AddStr := AnsiReplaceText(S, #13, '');
  AddStr := AnsiReplaceText(AddStr, #10, '');
  if AddStr = '' then begin
    inherited InsertObject(Index, #9, AObject);
  end
  else
    inherited InsertObject(Index, AddStr, AObject);
end;

function TDMemoStringList.GetText: PChar;
var
  i: Integer;
  AddStr: string;
begin
  AddStr := '';
  for i := 0 to Count - 1 do begin
    AddStr := AddStr + Get(i);
    if Char(Objects[i]) = #13 then begin
      AddStr := AddStr + #13;
    end;
  end;
  Result := StrNew(PChar(AddStr));
end;

procedure TDMemoStringList.SaveToFile(const FileName: string);
var
  TempString: TStringList;
  i: Integer;
  AddStr: string;
begin
  TempString := TStringList.Create;
  try
    AddStr := '';
    for i := 0 to Count - 1 do begin
      AddStr := AddStr + Get(i);
      if Char(Objects[i]) = #13 then begin
        TempString.Add(AddStr);
        AddStr := '';
      end;
    end;
    if AddStr <> '' then
      TempString.Add(AddStr);

    TempString.SaveToFile(FileName);
  finally
    TempString.Free;
  end;
end;

procedure TDMemoStringList.LoadFromFile(const FileName: string);
var
  TempString: TStringList;
  i: Integer;
begin
  Clear;
  TempString := TStringList.Create;
  try
    if FileExists(Filename) then begin
      TempString.LoadFromFile(FileName);
      for i := 0 to TempString.Count - 1 do begin
        Add(TempString[i]);
      end;
    end;
  finally
    TempString.Free;
  end;
end;

procedure TDMemoStringList.Put(Index: Integer; const Value: string);
var
  AddStr: string;
begin
  if Value <> '' then begin
    AddStr := AnsiReplaceText(Value, #13, '');
    AddStr := AnsiReplaceText(AddStr, #10, '');
  end
  else
    AddStr := #9;
  inherited Put(Index, AddStr);
end;

function TDMemoStringList.SelfGet(Index: Integer): string;
begin
  Result := inherited Get(Index);
end;



constructor TDPopUpMemu.Create(AOwner: TComponent);
begin
  inherited;
  FItem := TStringList.Create;
  FVisible := False;
  FIsHide := True;
  FOnPopIndex := nil;
  FHeight := 0;
  FWidth := 0;
  FItemIndex := -1;
  //DrawCanvas.Font.Name := DEFFONTNAME;
  //DrawCanvas.Font.Size := DEFFONTSIZE;
  FHeightOffset := 16;
  FAlpha := 220;
  FDlgWidth := 6;
  FDlgHeight := 6;
  FLineHeight := 6;
  FSelectWidth := 24;
  m_boClose := False;
  FillChar(FDlgInfo, SizeOf(FDlgInfo), #0);
end;

destructor TDPopUpMemu.Destroy;
begin
  FItem.Free;
  inherited;
end;

procedure TDPopUpMemu.DirectPaint(dsurface: TDirectDrawSurface);
var
  i, nHeight, nLeft: Integer;
  d: TDXTexture;
begin
  DrawCanvas.FillRect(left + 2, top + 2, FWidth - 4, FHeight - 4, $DC080808);
  for I := 0 to 3 do begin
    if FDlgInfo[I].WMImages = nil then Continue;
    d := FDlgInfo[I].WMImages.Images[FDlgInfo[I].Index];
    if d <> nil then begin
      DrawCanvas.StretchDraw(Rect(FDlgInfo[I].Rect.Left + Left, FDlgInfo[I].Rect.Top + Top,
                                  FDlgInfo[I].Rect.Right + Left, FDlgInfo[I].Rect.Bottom + Top),
                                  d.ClientRect, d, True);
    end;
  end;
  for I := 4 to 7 do begin
    if FDlgInfo[I].WMImages = nil then Continue;
    d := FDlgInfo[I].WMImages.Images[FDlgInfo[I].Index];
    if d <> nil then begin
      DrawCanvas.Draw(FDlgInfo[I].Rect.Left + Left, FDlgInfo[I].Rect.Top + Top, d.ClientRect, d, True);
    end;
  end;
  DrawCanvas.FillRect(FDlgWidth + Left, FDlgHeight + Top, FSelectWidth, FHeight - FDlgHeight * 2, $DC303030);
  with DrawCanvas do begin
    nHeight := FDlgHeight;
    nLeft := FDlgWidth + FSelectWidth + 4;
    for i := 0 to FItem.Count - 1 do begin
      if FItem[i] <> '-' then begin
        if FItem.Objects[i] = nil then begin
          TextOut(Left + nLeft, Top + nHeight + (FHeightOffset - 12) div 2, FDFEnabledColor, FItem[i]);
        end else
        if Integer(FItem.Objects[i]) = -1 then begin
          TextOut(Left + nLeft, Top + nHeight + (FHeightOffset - 12) div 2, FDFDownColor, FItem[i]);
        end else begin
          if FItemIndex = i then begin
            FillRect(Left + FDlgWidth + 1, Top + nHeight, (FWidth - FDlgWidth * 2 - 2), FHeightOffset, $A062625A);
          end;
          TextOut(Left + nLeft, Top + nHeight + (FHeightOffset - 12) div 2, FDFColor, FItem[i]);
        end;
        Inc(nHeight, FHeightOffset);
      end else begin
        MoveTo(Left + nLeft - 2, Top + nHeight + (FLineHeight - 2) div 2);
        LineTo(Left + (FWidth - FDlgWIdth - 2), Top + nHeight + (FLineHeight - 2) div 2, FDFEnabledColor);
        Inc(nHeight, FLineHeight);
      end;
    end;
  end;
end;

function TDPopUpMemu.InRange(x, y: integer): Boolean;
begin
  if  (x >= Left) and (x < Left + FWidth) and (y >= Top) and (y < Top + FHeight) then
    Result := TRUE
  else
    Result := FALSE;
end;

function TDPopUpMemu.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer): Boolean;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
  if Result and (FocusedControl = self) then begin
    if (FItemIndex > -1) and (FItemIndex < FItem.Count) and (FItem[FItemIndex] <> '-')
      and (FItem.Objects[FItemIndex] <> nil) and (Integer(FItem.Objects[FItemIndex]) <> -1)then begin
      if (AppendData <> nil) and (TObject(AppendData) is TDControl) and (TDControl(AppendData).Visible) then
        Visible := False;
        if Assigned(FOnPopIndex) then
          FOnPopIndex(Self, TDControl(AppendData), FItemIndex, FName);
    end;
  end;
end;

function TDPopUpMemu.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
var
  nHeight, nY, i: integer;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Result and (MouseEntryControl = Self) then begin
    FItemIndex := -1;
    nHeight := FDlgHeight;
    nY := y - Top;
    if nY >= nHeight then begin
      for i := 0 to FItem.Count - 1 do begin
        if FItem[i] <> '-' then begin
          if nY <= (nHeight + FHeightOffSet) then begin
            FItemIndex := i;
            break;
          end;
          Inc(nHeight, FHeightOffSet);
        end else begin
          if nY <= (nHeight + FLineHeight) then begin
            FItemIndex := i;
            break;
          end;
          Inc(nHeight, FLineHeight);
        end;
      end;
    end;
  end;
end;

procedure TDPopUpMemu.Popup(Sender: TObject; nLeft, nTop: Integer; sName: string);
begin
  Visible := True;
  if MouseEntryControl <> nil then begin
    MouseEntryControl.FMouseEntry := msOut;
    if Assigned(MouseEntryControl.FOnMouseEntry) then
      MouseEntryControl.FOnMouseEntry(MouseEntryControl, MouseEntryControl.FMouseEntry);
  end;

  //if (MouseCaptureControl <> nil) then
  MouseEntryControl := Self;
  //SetDCapture(Self);
  FItemIndex := -1;
  FName := sName;
  Left := nLeft + 2;
  Top := nTop + 2;
  if (Left + FWidth + 20) >= SCREENWIDTH then
    Left := _Max(0, Left - FWidth);
  if (Top + FHeight + 40) > SCREENHEIGHT then
    Top := _Max(0, Top - FHeight);
  AppendData := Sender;

  if (PopUpDWindow <> Self) and (PopUpDWindow <> nil) then
    PopUpDWindow.Visible := False;
  PopUpDWindow := Self;
end;

procedure TDPopUpMemu.RefSize;
var
  i: Integer;
{.$IFDEF MIRWIND}
  d: TDirectDrawSurface;
{.$ENDIF}
begin
  FHeight := FDlgHeight * 2;
  for i := 0 to FItem.Count - 1 do begin
    if (DrawCanvas.TextWidth(FItem[i]) + FDlgWidth * 2 + FSelectWidth + 24) > FWidth then
      FWidth := DrawCanvas.TextWidth(FItem[i]) + FDlgWidth * 2 + FSelectWidth + 24;
    if FItem[i] <> '-' then Inc(FHeight, FHeightOffset)
    else Inc(FHeight, FLineHeight);
  end;
  if FWidth < 140 then FWidth := 140;
{.$IFDEF MIRWIND}
  FillChar(FDlgInfo, SizeOf(FDlgInfo), #0);

  d := WLib.Images[FaceIndex + 4];
  if d <> nil then begin
    FDlgInfo[0].WMImages := WLib;
    FDlgInfo[0].Index := FaceIndex + 4;
    FDlgInfo[0].Rect.Left := 2;
    FDlgInfo[0].Rect.Top := 0;
    FDlgInfo[0].Rect.Bottom := d.Height;
    FDlgInfo[0].Rect.Right := FWidth - 4;
  end;
  d := WLib.Images[FaceIndex + 5];
  if d <> nil then begin
    FDlgInfo[1].WMImages := WLib;
    FDlgInfo[1].Index := FaceIndex + 5;
    FDlgInfo[1].Rect.Left := 2;
    FDlgInfo[1].Rect.Top := FHeight - d.Height;
    FDlgInfo[1].Rect.Bottom := FHeight;
    FDlgInfo[1].Rect.Right := FWidth - 4;
  end;
  d := WLib.Images[FaceIndex + 6];
  if d <> nil then begin
    FDlgInfo[2].WMImages := WLib;
    FDlgInfo[2].Index := FaceIndex + 6;
    FDlgInfo[2].Rect.Left := 0;
    FDlgInfo[2].Rect.Top := 2;
    FDlgInfo[2].Rect.Bottom := FHeight - 4;
    FDlgInfo[2].Rect.Right := d.Width;
  end;
  d := WLib.Images[FaceIndex + 7];
  if d <> nil then begin
    FDlgInfo[3].WMImages := WLib;
    FDlgInfo[3].Index := FaceIndex + 7;
    FDlgInfo[3].Rect.Left := FWidth - d.Width;
    FDlgInfo[3].Rect.Top := 2;
    FDlgInfo[3].Rect.Bottom := FHeight - 4;
    FDlgInfo[3].Rect.Right := FWidth;
  end;

  d := WLib.Images[FaceIndex];
  if d <> nil then begin
    FDlgInfo[4].WMImages := WLib;
    FDlgInfo[4].Index := FaceIndex;
    FDlgInfo[4].Rect.Left := 0;
    FDlgInfo[4].Rect.Top := 0;
  end;
  d := WLib.Images[FaceIndex + 2];
  if d <> nil then begin
    FDlgInfo[5].WMImages := WLib;
    FDlgInfo[5].Index := FaceIndex + 2;
    FDlgInfo[5].Rect.Left := FWidth - FDlgHeight;
    FDlgInfo[5].Rect.Top := 0;
  end;
  d := WLib.Images[FaceIndex + 1];
  if d <> nil then begin
    FDlgInfo[6].WMImages := WLib;
    FDlgInfo[6].Index := FaceIndex + 1;
    FDlgInfo[6].Rect.Left := 0;
    FDlgInfo[6].Rect.Top := FHeight - FDlgWidth;
  end;
  d := WLib.Images[FaceIndex + 3];
  if d <> nil then begin
    FDlgInfo[7].WMImages := WLib;
    FDlgInfo[7].Index := FaceIndex + 3;
    FDlgInfo[7].Rect.Left := FWidth - FDlgHeight;
    FDlgInfo[7].Rect.Top := FHeight - FDlgWidth;
  end;
{.$ENDIF}
end;

procedure TDPopUpMemu.SetItem(const Value: TStrings);
begin
  if Assigned(FItem) then
    FItem.Assign(Value)
  else
    FItem := Value;
  FItemIndex := -1;
  //RefSize;
end;

procedure TDPopUpMemu.SetItemIndex(const Value: Integer);
begin
  
  FItemIndex := Value;
end;

procedure TDPopUpMemu.SetOffset(const Value: Integer);
begin
  FHeightOffset := Value;
  //RefSize;
end;



procedure TDPopUpMemu.SetVisible2(const Value: Boolean);
begin
  ReleaseDCapture;
  inherited Visible := Value;
 // FVisible := Value;
end;

procedure TDImageEdit.RefEditText();
var
  i: integer;
  nLen, TextLen: integer;
  sstr: string;
begin
  nLen := FStartoffset;
  FEditString := '';
  for I := 0 to FEditTextList.Count - 1 do begin
    sstr := FEditTextList[i];
    if sstr <> '' then begin
      if sstr[1] = #13 then begin
        Inc(nLen, FImageWidth);
        FEditString := FEditString + FImageChar + Trim(sstr) + FImageChar;
      end
      else if sstr[1] = #10 then begin
        FEditString := FEditString + GetItemName(sstr, False);
        TextLen := DrawCanvas.TextWidth(GetItemName(sstr, True));
        Inc(nLen, TextLen);
      end
      else begin
        FEditString := FEditString + sstr;
        TextLen := DrawCanvas.TextWidth(sstr);
        Inc(nLen, TextLen);
      end;
      FEditTextList.Objects[i] := TObject(nLen);
    end;
  end; 
end;

Function TDImageEdit.AddImageToList(ImageIndex: string): Byte;
var
  LenStr: string;
  i: integer;
  str: string;
  nCount: Integer;
begin
  Result := 1;
  if (ImageIndex = '') then exit;
  Result := 2;
  LenStr := FImageChar + Trim(ImageIndex) + FImageChar;
  nCount := 0;
  if (MaxLength = 0) or (Length(FEditString + LenStr) <= MaxLength) then begin
    for I := 0 to FEditTextList.Count - 1 do begin
      str := FEditTextList[i];
      if (str <> '') and (str[1] = #13) then Inc(nCount);
    end;
    if nCount >= FImageCount then begin
      Result := 4;
      exit;
    end;
    Result := 0;
    ClearKey;
    if FCaretPos > FEditTextList.Count then
      FCaretPos := FEditTextList.Count;
    FEditTextList.Insert(FCaretPos, #13 + Trim(ImageIndex));
    Inc(FCaretPos);
    RefEditText();
    RefEditSurfce();
    TextChange;
  end;
end;

Function  TDImageEdit.AddItemToList(ItemName, ItemIndex: string): Byte;
var
  LenStr: string;
  AddStr, str: string;
  i: integer;
  nCount: Integer;
begin
  Result := 1;
  if (ItemName = '') or (ItemIndex = '') then exit;
  LenStr := FBeginChar + Trim(ItemIndex) + FEndChar;
  Result := 2;
  nCount := 0;
  if (MaxLength = 0) or (Length(FEditString + LenStr) <= MaxLength) then begin
    AddStr := #10 + ItemName + '/' + ItemIndex;
    for I := 0 to FEditTextList.Count - 1 do begin
      str := FEditTextList[i];
      if AddStr = str then begin
        Result := 3;
        exit;
      end else
      if (str <> '') and (str[1] = #10) then Inc(nCount);
    end;
    if nCount >= FItemCount then begin
      Result := 4;
      exit;
    end;
    Result := 0;
    ClearKey;
    if FCaretPos > FEditTextList.Count then
      FCaretPos := FEditTextList.Count;
    FEditTextList.Insert(FCaretPos, AddStr);
    Inc(FCaretPos);
    RefEditText();
    RefEditSurfce();
    TextChange;
  end;
end;

procedure TDImageEdit.AddStrToList(str: string);
begin
  if str = '' then
    exit;
  if FCaretPos > FEditTextList.Count then
    FCaretPos := FEditTextList.Count;
  FEditTextList.Insert(FCaretPos, str);
  Inc(FCaretPos);
  RefEditText();
  RefEditSurfce();
end;

procedure TDImageEdit.MoveCaret(X, Y: Integer);
var
  i: integer;
  nLen: Integer;
  OldLen: Integer;
begin
  if FEditTextList.Count <= 0 then
    exit;
  if FCaretPos > FEditTextList.Count then
    FCaretPos := FEditTextList.Count;
  if FShowPos >= FEditTextList.Count then
    FShowPos := FEditTextList.Count - 1;

  if (X < FStartoffset) and (FCaretPos > 0) then begin
    Dec(FCaretPos);
    RefEditSurfce;
  end
  else if (x > (Width - FStartoffset)) and (FCaretPos < FEditTextList.Count) then begin
    Inc(FCaretPos);
    RefEditSurfce;
  end;
  if FShowLeft then begin
    if FShowPos > 0 then
      OldLen := Integer(FEditTextList.Objects[FShowPos - 1])
    else
      OldLen := FStartoffset;
    for i := FShowPos to FEditTextList.Count - 1 do begin
      nLen := Integer(FEditTextList.Objects[i]) - OldLen;
      if nLen >= X then begin
        FCaretPos := i;
        if Downed or KeyDowned then
          FStopX := FCaretPos
        else
          FStartX := FCaretPos;
        RefEditSurfce;
        exit;
      end;
    end;
    FCaretPos := FEditTextList.Count;
    if Downed or KeyDowned then
      FStopX := FCaretPos
    else
      FStartX := FCaretPos;
    RefEditSurfce;
    exit;
  end
  else begin
    OldLen := Integer(FEditTextList.Objects[FShowPos]);
    for i := FShowPos downto 0 do begin
      nLen := Width - (OldLen - Integer(FEditTextList.Objects[i])) - FStartoffset - 2;
      if nLen <= X then begin
        FCaretPos := i + 1;
        if Downed or KeyDowned then
          FStopX := FCaretPos
        else
          FStartX := FCaretPos;
        RefEditSurfce;
        exit;
      end;
    end;
  end;
end;

procedure TDImageEdit.RefEditSurfce(boRef: Boolean);
var
  i: integer;
  nRight, nLeft: Integer;
  nLen, nTextLen: Integer;
  nStart, nStop: Integer;
  boAdd: Boolean;
  ShowStr, ShowStr2: string;
  ShowStrList: TStringList;
begin
  FEditItemList.Clear;
  FEditImageList.Clear;
  if FSurface = nil then
    exit;
  FSurface.Clear;
  FShowLine := FStartoffset;
  if FEditTextList.Count <= 0 then
    exit;
  if FCaretPos > FEditTextList.Count then
    FCaretPos := FEditTextList.Count;
  if FShowPos >= FEditTextList.Count then
    FShowPos := FEditTextList.Count - 1;

  if (FCaretPos > FShowPos) then begin
    nRight := Integer(FEditTextList.Objects[FCaretPos - 1]) + FStartoffset;
    if FShowPos > 0 then
      nLeft := Max(0, Integer(FEditTextList.Objects[FShowPos]) - FStartoffset)
    else
      nLeft := 0;
    if FShowLeft then begin
      if (nRight - nLeft) >= Width then begin
        FShowLeft := False;
        FShowPos := Max(0, FCaretPos - 1);
      end;
    end
    else begin
      FShowPos := Max(0, FCaretPos - 1);
    end;
  end
  else if (FCaretPos <= FShowPos) then begin
    nRight := Integer(FEditTextList.Objects[FShowPos]) + FStartoffset;
    if FCaretPos > 0 then
      nLeft := Max(0, Integer(FEditTextList.Objects[FCaretPos - 1]) - FStartoffset)
    else
      nLeft := 0;
    if FShowLeft then begin
      FShowPos := Max(0, FCaretPos - 1);
    end
    else begin
      if (nRight - nLeft) >= Width then begin
        FShowLeft := True;
        FShowPos := Max(0, FCaretPos - 1);
      end;
    end;
  end;
  nStart := -1;
  nStop := -1;
  if (FStartX > -1) and (FStopX > -1) and (FStartX <> FStopX) then begin
    if FStartX < FStopX then begin
      nStart := FStartX;
      nStop := FStopX;
    end
    else begin
      nStart := FStopX;
      nStop := FStartX;
    end;
    if nStart = nStop then begin
      FStartX := -1;
      FStopX := -1;
      nStart := -1;
    end;
  end;
  if nStart > FEditTextList.Count then
    nStart := FEditTextList.Count;
  if nStop > FEditTextList.Count then
    nStop := FEditTextList.Count;

  FStartLine := 0;
  FStopLine := 0;
  FOppShowPos := 0;
  boAdd := False;
  with FSurface do begin
    if FShowLeft then begin
      //SetBkMode(Handle, TRANSPARENT);
      nLen := FStartoffset;
      FStartLine := nLen;
      for i := FShowPos to FEditTextList.Count - 1 do begin
        if i = nStart then
          FStartLine := nLen;
        ShowStr := FEditTextList[i];
        if ShowStr <> '' then begin
          if ShowStr[1] = #13 then begin
            FEditImageList.AddObject(Trim(ShowStr), TObject(nLen));
            nTextLen := FImageWidth;
          end
          else if ShowStr[1] = #10 then begin
            ShowStr := GetItemName(ShowStr, True);
            TextOutEx(nLen, (Height - 12) div 2, ShowStr);
            nTextLen := DrawCanvas.TextWidth(ShowStr);
            FEditItemList.AddObject(ShowStr, TObject(MakeLong(Word(nLen), Word(nLen + nTextLen))));
          end
          else begin
            TextOutEx(nLen, (Height - 12) div 2, ShowStr);
            nTextLen := DrawCanvas.TextWidth(ShowStr);
          end;
          Inc(nLen, nTextLen);
        end;
        if i = (nStop - 1) then
          FStopLine := nLen;
        if i = (FCaretPos - 1) then
          FShowLine := nLen;
        if (not boAdd) and (nLen > (Width - FStartoffset)) then begin
          boAdd := True;
          FOppShowPos := i - 1;
        end;
      end;
      //Release;
    end
    else begin
      //SetBkMode(Handle, TRANSPARENT);
      nLen := Width - FStartoffset;
      FStopLine := nLen;
      FStartLine := nLen;
      ShowStr2 := '';
      ShowStrList := TStringList.Create;
      for i := FShowPos downto 0 do begin
        if i = (nStop - 1) then
          FStopLine := nLen;
        if i = (FCaretPos - 1) then
          FShowLine := nLen;
        ShowStr := FEditTextList[i];
        if ShowStr <> '' then begin
          if ShowStr[1] = #13 then begin
            if ShowStr2 <> '' then
              ShowStrList.AddObject(ShowStr2, TObject(nLen));
            Dec(nLen, FImageWidth);
            FEditImageList.AddObject(Trim(ShowStr), TObject(nLen));
            ShowStr2 := '';
          end
          else if ShowStr[1] = #10 then begin
            ShowStr := GetItemName(ShowStr, True);
            nTextLen := DrawCanvas.TextWidth(ShowStr);
            ShowStr2 := ShowStr + ShowStr2;
            //TextOutEx(nLen, (Height - 12) div 2, ShowStr);
            Dec(nLen, nTextLen);
            FEditItemList.AddObject(ShowStr, TObject(MakeLong(Word(nLen), Word(nLen + nTextLen))));
          end
          else begin
            nTextLen := DrawCanvas.TextWidth(ShowStr);
            ShowStr2 := ShowStr + ShowStr2;
            Dec(nLen, nTextLen);
            //TextOutEx(nLen, (Height - 12) div 2, ShowStr);
          end;
        end;
        if i = nStart then
          FStartLine := nLen;
        if (not boAdd) and (nLen < FStartoffset) then begin
          boAdd := True;
          FOppShowPos := i + 1;
        end;
      end;
      for I := ShowStrList.Count - 1 downto 0 do begin
        TextOutEx(Integer(ShowStrList.Objects[i]), (Height - 12) div 2, ShowStrList[I]);
      end;
      ShowStrList.Free;
      if ShowStr2 <> '' then
        TextOutEx(nLen, (Height - 12) div 2, ShowStr2);
      //Release;
      if (nLen > FStartoffset) and (boRef) then begin
        FShowLeft := True;
        FShowPos := 0;
        RefEditSurfce(False);
        exit;
      end;
    end;
  end;
  if FStartLine < FStartoffset then
    FStartLine := FStartoffset;
  if FStopLine > (Width - FStartoffset) then
    FStopLine := Width - FStartoffset;
  if FStopLine < FStartoffset then
    FStopLine := FStartoffset;
  if FStartLine > (Width - FStartoffset) then
    FStartLine := Width - FStartoffset;
end;

function TDImageEdit.GetCopy: string;
var
  i: integer;
  nStart, nStop: Integer;
  sstr: string;
begin
  Result := '';
  if (FStartX > -1) and (FStopX > -1) and (FStartX <> FStopX) then begin
    if FStartX < FStopX then begin
      nStart := FStartX;
      nStop := FStopX;
    end
    else begin
      nStart := FStopX;
      nStop := FStartX;
    end;
    for I := nStart to nStop - 1 do begin
      if i < 0 then
        break;
      if i >= FEditTextList.Count then
        break;
      sstr := FEditTextList[i];
      if sstr <> '' then begin
        if sstr[1] = #13 then begin
          Result := Result + FImageChar + Trim(sstr) + FImageChar;
        end
        else if sstr[1] = #10 then begin
          Result := Result + GetItemName(sstr, False);
        end
        else begin
          Result := Result + sstr;
        end;
      end;
    end;
  end;
end;

function TDImageEdit.GetItemName(str: string; boName: Boolean): string;
var
  sname, sitemindex: string;
begin
  str := GetValidStr3(str, sname, ['/']);
  str := GetValidStr3(str, sitemindex, ['/']);
  if boName then
    Result := '<' + Trim(sname) + '>'
  else
    Result := FBeginChar + Trim(sitemindex) + FEndChar;
end;

function TDImageEdit.ClearKey: Boolean;
var
  i: integer;
  nStart, nStop: Integer;
begin
  Result := False;
  if (FStartX > -1) and (FStopX > -1) and (FStartX <> FStopX) then begin
    if FStartX < FStopX then begin
      nStart := FStartX;
      nStop := FStopX;
    end
    else begin
      nStart := FStopX;
      nStop := FStartX;
    end;
    Result := True;
    for I := (nStop - 1) downto nStart do begin
      if i < 0 then
        break;
      if i >= FEditTextList.Count then
        break;
      
      FEditTextList.Delete(i);
      
    end;
    FStartX := -1;
    FStopX := -1;
    FCaretPos := nStart;
    SetBearing(True);
    RefEditText;
    RefEditSurfce;
  end;
end;

constructor TDImageEdit.Create(AOwner: TComponent);
begin
  inherited;
  FOnChange := nil;
  FKeyFocus := True;
  FMaxLength := 0;
  
  Color := clBlack;
  Font.Name := DEFFONTNAME;
  Font.Color := clWhite;
  Font.Size := DEFFONTSIZE;
  //DrawCanvas.Font.Name := Font.Name;
  //DrawCanvas.Font.Color := Font.Color;
  //DrawCanvas.Font.Size := Font.Size;
  
  FStartX := -1;
  FStopX := -1;
  FInputStr := '';
  bDoubleByte := False;
  KeyByteCount := 0;
  
  FEditTextList := TStringList.Create;
  FEditImageList := TStringList.Create;
  FEditItemList := TStringList.Create;
  FCaretPos := 0;
  FEditString := '';
  FStartoffset := 3;
  FShowLeft := True;
  FShowPos := 0;
  FImageWidth := 20;
  FShowLine := FStartoffset;
  FCaretShowTime := GetTickCount;
  FBeginChar := '{';
  FEndChar := '}';
  FImageChar := '#';
  FDFColor := clWhite;
  
  FDFEnabledColor := clYellow;
  FOnCheckItem := nil;
  FOnDrawEditImage := nil;
  FItemCount := 5;
  FImageCount := 5;
  
  
end;

destructor TDImageEdit.Destroy;
begin
  FEditTextList.Free;
  FEditItemList.Free;
  inherited;
end;

procedure TDImageEdit.DirectPaint(dsurface: TDirectDrawSurface);
var
  dc, Rect: TRect;
  i: Integer;
  nLeft: Integer;
  ax, ay: integer;
begin
  if FSurface = nil then exit;

  dc.Left := SurfaceX(Left);
  dc.Top := SurfaceY(Top);
  dc.Right := SurfaceX(left + Width);
  dc.Bottom := SurfaceY(top + Height);
  
  with DrawCanvas do begin
    if (FStartX > -1) and (FStopX > -1) then begin
      dc.Left := SurfaceX(Left + FStartLine);
      dc.Right := SurfaceX(left + FStopLine);
      if Height > 16 then begin
        dc.Top := SurfaceY(Top + 2);
        dc.Bottom := SurfaceY(top + Height - 2);
      end else begin
        dc.Top := SurfaceY(Top);
        dc.Bottom := SurfaceY(top + Height);
      end;
      //Brush.Color := $C66931;
      FillRect(dc, cColor4($C9C66931), fxBlend);
    end;
    //Release;
    ax := SurfaceX(Left);
    ay := SurfaceY(Top);
    dc := FSurface.ClientRect;
    dc.Left := FStartoffset - 1;
    dc.Right := (Width - (FStartoffset - 1));
    dsurface.Draw(ax + (FStartoffset - 1), ay, dc, FSurface, True);

    if FEditImageList.Count > 0 then begin
      //FImageSurface.Fill(0);
      for I := 0 to FEditImageList.Count - 1 do begin
        nLeft := Integer(FEditImageList.Objects[i]);
        Rect.Left := ax + nLeft;
        Rect.Right := Rect.Left + FImageWidth;
        Rect.Top := ay;
        Rect.Bottom := ay + Height;
        if (Rect.Right >= FStartoffset) and (Rect.Left <= (Width - FStartoffset)) then
          if Assigned(FOnDrawEditImage) then
            FOnDrawEditImage(Self, FSurface, Rect, StrToIntDef(FEditImageList[i], -1));
      end;
      //dsurface.Draw(ax + (FStartoffset - 1), ay, dc, FImageSurface, True);
    end;

    if (GetTickCount - FCaretShowTime) > 500 then begin 
      FCaretShowTime := GetTickCount;
      FCaretShow := not FCaretShow;
    end;
    if FCaretShow and (KeyControl = Self) then begin
      FrmIMEX := SurfaceX(FShowLine + left);
      if Height < 16 then begin
        RoundRect(SurfaceX(FShowLine + left), SurfaceY(Top),
          SurfaceX(left + FShowLine + 1), SurfaceY(top + Height), clWhite);
        FrmIMEY := SurfaceY(Top);
      end
      else begin
        RoundRect(SurfaceX(FShowLine + left), SurfaceY(Top + 2),
          SurfaceX(left + FShowLine + 1), SurfaceY(top + Height - 2), clWhite);
        FrmIMEY := SurfaceY(Top + 2);
      end;
    end;
  end; 
end;

procedure TDImageEdit.Enter;
begin
  inherited;
end;

procedure TDImageEdit.FormatEditStr(str: string);
var
  Key: Char;
  boImage, boItem: Boolean;
  TempStr, ItemName: string;
  i: integer;
begin
  boImage := False;
  boItem := False;
  if str <> '' then
    for I := 1 to length(str) do begin
      Key := str[i];
      if (Key = #13) or (Key = #10) then
        Continue;
      if boImage then begin
        if Key = FImageChar then begin
          boImage := False;
          AddImageToList(TempStr);
        end
        else
          TempStr := TempStr + Key;
      end
      else if boItem then begin
        if Key = FEndChar then begin
          boItem := False;
          ItemName := '';
          if Assigned(FOnCheckItem) then
            FOnCheckItem(self, StrToIntDef(TempStr, 0), ItemName);
          if ItemName <> '' then
            AddItemToList(ItemName, TempStr);
        end
        else
          TempStr := TempStr + Key;
      end
      else if Key = FImageChar then begin
        boImage := True;
        TempStr := '';
      end
      else if Key = FBeginChar then begin
        boItem := True;
        TempStr := '';
      end
      else
        KeyPress(Key);
    end;
end;

function TDImageEdit.GetText: string;
begin
  Result := FEditString;
end;

function TDImageEdit.KeyDown(var Key: Word; Shift: TShiftState): Boolean;
var
  Clipboard: TClipboard;
  boChange: Boolean;
  OldOnChange: TOnClick;
  str: string;
begin
  Result := FALSE;
  if (KeyControl = self) then begin
    KeyDownControl := Self;
    if Assigned(FOnKeyDown) then
      FOnKeyDown(self, Key, Shift);
    if Key = 0 then
      exit;

    if (ssCtrl in Shift) and (not Downed) and (Key = Word('X')) then begin
      if (FStartX > -1) and (FStopX > -1) and (FStartX <> FStopX) then begin
        Clipboard := TClipboard.Create;
        Clipboard.AsText := GetCopy;
        Clipboard.Free;
        ClearKey();
        TextChange();
      end;
      Key := 0;
      Result := True;
      Exit;
    end
    else if (ssCtrl in Shift) and (not Downed) and (Key = Word('C')) then begin

      if (FStartX > -1) and (FStopX > -1) and (FStartX <> FStopX) then begin
        Clipboard := TClipboard.Create;
        Clipboard.AsText := GetCopy;
        Clipboard.Free;
      end;
      Key := 0;
      Result := True;
      Exit;
    end
    else if (ssCtrl in Shift) and (not Downed) and (Key = Word('V')) then begin
      
      ClearKey();
      Clipboard := TClipboard.Create;
      str := Clipboard.AsText;
      OldOnChange := FOnChange;
      try
        FormatEditStr(str);
      finally
        FOnChange := OldOnChange;
        Clipboard.Free;
        TextChange;
      end;
      Key := 0;
      Result := True;
      Exit;
    end
    else if (ssCtrl in Shift) and (not Downed) and (Key = Word('A')) then begin
      SetFocus;
      Key := 0;
      Result := True;
      Exit;
    end
    else if (ssShift in Shift) and (not Downed) then begin
      KeyDowned := True;
      if FStartX < 0 then
        FStartX := FCaretPos;
    end
    else begin
      KeyDowned := False;
    end;
    case Key of
      VK_RIGHT: begin
          if FCaretPos < FEditTextList.Count then begin
            Inc(FCaretPos);
            if (ssShift in Shift) then begin
              FStopX := FCaretPos;
            end
            else begin
              FStartX := -1;
              FStopX := -1;
              KeyDowned := False;
            end;
            RefEditSurfce();
          end
          else begin
            if (ssShift in Shift) then begin
              FStopX := FCaretPos;
            end
            else begin
              FStartX := -1;
              FStopX := -1;
              KeyDowned := False;
            end;
            RefEditSurfce();
          end;
          Key := 0;
          Result := TRUE;
        end;
      VK_LEFT: begin
          if FCaretPos > 0 then begin
            Dec(FCaretPos);
            if (ssShift in Shift) then begin
              FStopX := FCaretPos;
            end
            else begin
              FStartX := -1;
              FStopX := -1;
              KeyDowned := False;
            end;
            RefEditSurfce();
          end
          else begin
            if (ssShift in Shift) then begin
              FStopX := FCaretPos;
            end
            else begin
              FStartX := -1;
              FStopX := -1;
              KeyDowned := False;
            end;
            RefEditSurfce();
          end;
          Key := 0;
          Result := TRUE;
        end;
      VK_DELETE: begin
          boChange := ClearKey;
          if (not boChange) and (FEditTextList.Count > 0) then begin
            if FCaretPos < FEditTextList.Count then
              FEditTextList.Delete(FCaretPos);
            SetBearing(True);
            RefEditText;
            RefEditSurfce;
            TextChange();
          end
          else if boChange then
            TextChange();
          Key := 0;
          Result := TRUE;
        end;
    end;
  end;
end;

function TDImageEdit.KeyPress(var Key: Char): Boolean;
var
  boChange: Boolean;
begin
  Result := False;
  if (KeyControl = Self) then begin
    Result := TRUE;
    if (not Downed)  then begin
      if Assigned(FOnKeyPress) then
        FOnKeyPress(self, Key);
      if Key = #0 then
        Exit;
      case Key of
        Char(VK_BACK): begin
            boChange := ClearKey;
            if (not boChange) and (FEditTextList.Count > 0) and (FCaretPos > 0) then begin
              if FCaretPos > FEditTextList.Count then
                FCaretPos := FEditTextList.Count;
              FEditTextList.Delete(FCaretPos - 1);
              Dec(FCaretPos);
              SetBearing(True);
              RefEditText;
              RefEditSurfce;
              TextChange();
            end
            else if boChange then
              TextChange();
          end;
      else begin

          

          if (key in AllowedChars) then begin
            if IsDBCSLeadByte(Ord(Key)) or bDoubleByte then begin
              bDoubleByte := true;
              Inc(KeyByteCount);
              FInputStr := FInputStr + key;
            end;
            if not bDoubleByte then begin
              
              if (Key = FBeginChar) or (Key = FEndChar) or (Key = FImageChar) then begin
                Key := #0;
                exit;
              end;

              
              ClearKey;

              if (MaxLength > 0) and (Length(FEditString) >= MaxLength) then begin
                Key := #0;
                exit;
              end;
              AddStrToList(Key);
              Key := #0;
              TextChange();
            end
            else if KeyByteCount >= 2 then begin
              if length(FInputStr) <> 2 then begin
                bDoubleByte := false;
                KeyByteCount := 0;
                FInputStr := '';
                Key := #0;
                exit;
              end;
              
              ClearKey;
              if (MaxLength > 0) and (Length(FEditString) >= (MaxLength - 1)) then begin
                bDoubleByte := false;
                KeyByteCount := 0;
                FInputStr := '';
                Key := #0;
                exit;
              end;
              AddStrToList(FInputStr);
              TextChange();
              bDoubleByte := false;
              KeyByteCount := 0;
              FInputStr := '';
              Key := #0;
            end;
          end;
        end;
      end;
    end;
    Key := #0;
  end;
end;

function TDImageEdit.KeyUp(var Key: Word; Shift: TShiftState): Boolean;
begin
  Result := FALSE;
  if (KeyControl = self) then begin
    if (Key = VK_SHIFT) then begin
      KeyDowned := False;
      if FStopX = -1 then
        FStartX := -1;
    end;
    if Assigned(FOnKeyUp) then
      FOnKeyUp(self, Key, Shift);
    Key := 0;
    Result := TRUE;
  end;
end;

procedure TDImageEdit.Leave;
begin
  FStartX := -1;
  FStopX := -1;
  RefEditSurfce();
  inherited;
end;

function TDImageEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := FALSE;
  if inherited MouseDown(Button, Shift, X, Y) then begin
    if (not Background) and (MouseCaptureControl = nil) then begin
      KeyDowned := False;
      if mbLeft = Button then begin
        FStartX := -1;
        FStopX := -1;
        if (FocusedControl = self) then begin
          MoveCaret(X - left, Y - top);
        end;
        Downed := True;
      end;
      SetDCapture(self);
    end;
    Result := TRUE;
  end;
end;

function TDImageEdit.MouseMove(Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y);
  if Result and (MouseCaptureControl = self) then begin
    if Downed and (not KeyDowned) then
      MoveCaret(X - left, Y - top);
  end;
end;

function TDImageEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := FALSE;
  Downed := False;
  if inherited MouseUp(Button, Shift, X, Y) then begin
    ReleaseDCapture;
    if not Background then begin
      if InRange(X, Y) then begin
        if Assigned(FOnClick) then
          FOnClick(self, X, Y);
      end;
    end;
    Result := TRUE;
    exit;
  end
  else begin
    ReleaseDCapture;
  end;
end;

function TDImageEdit.Selected: Boolean;
begin
  Result := False;
  if (FStartX > -1) and (FStopX > -1) and (FStartX <> FStopX) then
    Result := True;
end;

procedure TDImageEdit.SetBearing(boLeft: Boolean);
begin
  
  if not FShowLeft then begin
    FShowLeft := True;
    FShowPos := FOppShowPos;
  end;
  
end;

procedure TDImageEdit.SetFocus;
begin
  inherited;
  if FEditTextList.Count > 0 then begin
    FStartX := 0;
    FStopX := FEditTextList.Count;
    FCaretPos := FEditTextList.Count;
    FShowPos := FEditTextList.Count - 1;
    FShowLeft := False;
    RefEditSurfce();
  end;
end;
{
procedure TDImageEdit.SetSurface(DDraw: TDirectDraw; Lib: TWMImages; index: integer);
var
  d: TDirectDrawSurface;
begin
  inherited SetSurface(DDraw, Lib, index);
  if FImageSurface <> nil then
    FImageSurface.Free;
  FImageSurface := nil;
  if DDraw <> nil then begin
    if Lib <> nil then begin
      d := Lib.Images[index];
      if d <> nil then begin
        FImageSurface := TDirectDrawSurface.Create(DDraw);
        FImageSurface.SystemMemory := True;
        FImageSurface.Canvas.Font.Name := DEFFONTNAME;
        FImageSurface.Canvas.Font.Size := DEFFONTSIZE;
        FImageSurface.SetSize(d.Width, d.Height);
        FImageSurface.Draw(0, 0, d.ClientRect, d, True);
      end;
    end
    else begin
      FImageSurface := TDirectDrawSurface.Create(DDraw);
      FImageSurface.SystemMemory := True;
      FImageSurface.Canvas.Font.Name := DEFFONTNAME;
      FImageSurface.Canvas.Font.Size := DEFFONTSIZE;
      FImageSurface.SetSize(Width, Height);
      FImageSurface.Fill(0);
    end;
  end;
end;     }

procedure TDImageEdit.SetText(const Value: string);
var
  OldOnChange: TOnClick;
  OldKeyControl: TDControl;
begin
  OldOnChange := FOnChange;
  OldKeyControl := KeyControl;
  KeyControl := Self;
  FOnChange := nil;
  FEditTextList.Clear;
  try
    FormatEditStr(Value);
  finally
    FOnChange := OldOnChange;
    KeyControl := OldKeyControl;
  end;
  RefEditText;
  RefEditSurfce();
  TextChange;
  SetFocus;
  FStartX := -1;
  FStopX := -1;
end;

procedure TDImageEdit.TextChange;
begin
  if Assigned(FOnChange) then
    FOnChange(self);
end;



constructor TDModalWindow.Create(AOwner: TComponent);
begin
  inherited;
  MsgList := TStringList.Create;
  FillChar(DlgInfo, SizeOf(DlgInfo), #0);
end;

destructor TDModalWindow.Destroy;
begin
  MsgList.Free;
  inherited;
end;

function TDModalWindow.ModalClose: integer;
var
  i: integer;
begin
  Result := 0;
  for I := 0 to DControls.Count - 1 do begin
    if MouseCaptureControl = DControls[i] then MouseCaptureControl := nil;
    if FocusedControl = DControls[i] then FocusedControl := nil;
    if KeyControl = DControls[i] then KeyControl := nil;
    if ModalDWindow = DControls[i] then ModalDWindow := nil;
    if TopDWindow = DControls[i] then TopDWindow := nil;
    if PopUpDWindow = DControls[i] then PopUpDWindow := nil;
    if MouseEntryControl = DControls[i] then MouseEntryControl := nil;
    if KeyDownControl = DControls[i] then KeyDownControl := nil;

  end;
  DControls.Clear;
  if MouseCaptureControl = Self then MouseCaptureControl := nil;
  if FocusedControl = Self then FocusedControl := nil;
  if KeyControl = Self then KeyControl := nil;
  if ModalDWindow = Self then ModalDWindow := nil;
  if TopDWindow = Self then TopDWindow := nil;
  if PopUpDWindow = Self then PopUpDWindow := nil;
  if MouseEntryControl = Self then MouseEntryControl := nil;
  if KeyDownControl = Self then KeyDownControl := nil;
  

  for I := 0 to ModalDWindowList.Count - 1 do begin
    if ModalDWindowList[i] = Self then begin
      ModalDWindowList.Delete(i);
      break;
    end;
  end;
end;

function TDModalWindow.ModalShow: integer;
begin
  Result := ModalDWindowList.Add(Pointer(Self));
  Visible := True;
  SetDFocus(Self);
end;

{ TDTreeView }

procedure TDTreeView.ClearItem;
var
  i, ii: integer;
  DTreeNodes: pTDTreeNodes;
begin
  for I := 0 to FTreeItem.Count - 1 do begin
    DTreeNodes := FTreeItem[i];
    for ii := 0 to DTreeNodes.ItemList.Count - 1 do begin
      ClearTreeNodes(pTDTreeNodes(DTreeNodes.ItemList[ii]));
      if Assigned(FOnTreeClearItem) then
        FOnTreeClearItem(Self, pTDTreeNodes(DTreeNodes.ItemList[ii]));
      Dispose(pTDTreeNodes(DTreeNodes.ItemList[ii]));
    end;
    DTreeNodes.ItemList.Free;
    Dispose(DTreeNodes);
  end;
  FTreeItem.Clear;
  FSelectTreeModes := nil;
end;

function TDTreeView.DelItem(TreeNodes: pTDTreeNodes; boMaster: Boolean): Boolean;
var
  i, ii: integer;
  DTreeNodes, DTreeNodes2: pTDTreeNodes;
begin
  Result := False;
  if TreeNodes = nil then exit;
  for I := 0 to FTreeItem.Count - 1 do begin
    DTreeNodes := FTreeItem[i];
    if TreeNodes = DTreeNodes then begin
      if Assigned(FOnTreeClearItem) then
        FOnTreeClearItem(Self, DTreeNodes);
      if DTreeNodes = FSelectTreeModes then
        FSelectTreeModes := nil;
      FTreeItem.Delete(I);
      Dispose(DTreeNodes);
      Result := True;
      break;
    end else begin
      for ii := 0 to DTreeNodes.ItemList.Count - 1 do begin
        DTreeNodes2 := pTDTreeNodes(DTreeNodes.ItemList[ii]);
        if DTreeNodes2 = TreeNodes then begin
          if Assigned(FOnTreeClearItem) then
            FOnTreeClearItem(Self, DTreeNodes2);
          if TreeNodes = FSelectTreeModes then
            FSelectTreeModes := nil;
          DTreeNodes.ItemList.Delete(ii);
          Dispose(DTreeNodes2);
          Result := True;
          break;
        end else begin
          Result := DelTreeNodes(DTreeNodes2, boMaster);
          if Result then break;
        end;
      end;
      if boMaster and (DTreeNodes.ItemList.Count <= 0) then begin
        FTreeItem.Delete(I);
        Dispose(DTreeNodes);
        break;
      end;
    end;
    if Result then break;
  end;
  if Result then RefHeight;
end;

Function TDTreeView.DelTreeNodes(TreeNodes: pTDTreeNodes; boMaster: Boolean): Boolean;
var
  ii: integer;
  DTreeNodes2: pTDTreeNodes;
begin
  Result := False;
  for ii := 0 to TreeNodes.ItemList.Count - 1 do begin
    DTreeNodes2 := pTDTreeNodes(TreeNodes.ItemList[ii]);
    if DTreeNodes2 = TreeNodes then begin
      if Assigned(FOnTreeClearItem) then
        FOnTreeClearItem(Self, DTreeNodes2);
      if TreeNodes = FSelectTreeModes then
        FSelectTreeModes := nil;
      TreeNodes.ItemList.Delete(ii);
      Dispose(DTreeNodes2);
      Result := True;
      break;
    end else begin
      Result := DelTreeNodes(DTreeNodes2, boMaster);
      if Result then break;
    end;
  end;
end;

procedure TDTreeView.ClearTreeNodes(DTreeNodes: pTDTreeNodes);
var
  ii: integer;
begin
  for ii := 0 to DTreeNodes.ItemList.Count - 1 do begin
    ClearTreeNodes(pTDTreeNodes(DTreeNodes.ItemList[ii]));
    if Assigned(FOnTreeClearItem) then
      FOnTreeClearItem(Self, pTDTreeNodes(DTreeNodes.ItemList[ii]));
    Dispose(pTDTreeNodes(DTreeNodes.ItemList[ii]));
  end;
  DTreeNodes.ItemList.Free;
end;

constructor TDTreeView.Create(AOwner: TComponent);
begin
  inherited;
  FTreeItem := TList.Create;
  FUpDown := nil;
  FTreeNodesHeigh := 18;
  FImageWidth := 18;
  FOpenImageIdx := 0;
  FCloseImageIdx := 0;
  FboChange := False;
  FDownY := -1;
  FSelectTreeModes := nil;
  FOnTreeViewSelect := nil;
  FOnTreeClearItem := nil;
end;

destructor TDTreeView.Destroy;
begin
  ClearItem;
  FTreeItem.Free;
  inherited;
end;

procedure TDTreeView.DirectPaint(dsurface: TDirectDrawSurface);
var
  nHeight: Integer;
  i: integer;


  procedure TreeNodesDirectPaint(nX: Integer; DTreeNodes: pTDTreeNodes);
  var
    ii: integer;
    d: TDirectDrawSurface;
    boDown: Boolean;
  begin
    if (FDownY > -1) and (FDownY >= nHeight) and (FDownY <= (nHeight + FTreeNodesHeigh)) then
      boDown := True
    else
      boDown := False;

    if DTreeNodes.boMaster and (DTreeNodes.ItemList.Count <= 0) then boDown := False;

    with FSurface do begin
      if (DTreeNodes.ItemList.Count > 0) or DTreeNodes.boMaster then begin
        if (nHeight + FTreeNodesHeigh > 0) and (nHeight < Height) then begin
          if WLib <> nil then begin
            if DTreeNodes.boOpen or ((DTreeNodes.ItemList.Count <= 0) and DTreeNodes.boMaster) then d := WLib.Images[ImageCloseIndex]
            else d := WLib.Images[ImageOpenIndex];
            if d <> nil then begin
              CopyTexture(nX, nHeight + (FTreeNodesHeigh - d.Height) div 2, d);
              //Draw(nX, nHeight + (FTreeNodesHeigh - d.Height) div 2, d.ClientRect, d, True);
              //Release;
              //FSurface.Draw(nX, nHeight + (FTreeNodesHeigh - d.Height) div 2, d.ClientRect, d, True);
              //SetBkMode(Handle, TRANSPARENT);
            end;
          end;
          TextOutEx(nX + FImageWidth, nHeight + (FTreeNodesHeigh -12) div 2, DTreeNodes.sName, FDFMoveColor);
        end;
        Inc(nHeight, FTreeNodesHeigh);
        if DTreeNodes.boOpen and (DTreeNodes.ItemList.Count > 0) then
          for ii := 0 to DTreeNodes.ItemList.Count - 1 do begin
            TreeNodesDirectPaint(nX + 10, pTDTreeNodes(DTreeNodes.ItemList[ii]));
          end;
        if boDown then begin
          DTreeNodes.boOpen := not DTreeNodes.boOpen;
        end; 
      end else begin
        if (nHeight + FTreeNodesHeigh > 0) and (nHeight < Height) then begin
          if FSelectTreeModes = DTreeNodes then
            TextOutEx(nX + FImageWidth, nHeight + (FTreeNodesHeigh -12) div 2, DTreeNodes.sName, FDFDownColor)
          else
            TextOutEx(nX + FImageWidth, nHeight + (FTreeNodesHeigh -12) div 2, DTreeNodes.sName, FDFColor);
        end;
        Inc(nHeight, FTreeNodesHeigh);
        if boDown then begin
          FSelectTreeModes := DTreeNodes;
        end;
      end;
      if boDown then begin
        if Assigned(FOnTreeViewSelect) then
          FOnTreeViewSelect(Self, DTreeNodes);
      end;
    end;
  end;

begin
  if (FSurface <> nil) then begin
    if FboChange then begin
      FSurface.Clear;
      FboChange := False;
      if (UpDown <> nil) and (UpDown.Visible) then nHeight := -UpDown.Position
      else nHeight := 0;
      //with FSurface.Canvas do begin
        //SetBkMode(Handle, TRANSPARENT);
      for I := 0 to FTreeItem.Count - 1 do begin
        TreeNodesDirectPaint(0, pTDTreeNodes(FTreeItem[i]));
      end;
        //Release;
      //end;
      if FDownY <> -1 then
        RefHeight;
      FDownY := -1;
    end;
    DrawCanvas.Draw(SurfaceX(Left), SurfaceY(Top), FSurface.ClientRect, FSurface, True);
  end;
end;

function TDTreeView.GetTreeNodes(DTreeNodes: pTDTreeNodes; sName: string; boAdd: Boolean): pTDTreeNodes;
var
  i: integer;
  DTreeNodes37: pTDTreeNodes;
begin
  Result := nil;
  if DTreeNodes <> nil then begin
    for I := 0 to DTreeNodes.ItemList.Count - 1 do begin
      DTreeNodes37 := DTreeNodes.ItemList[i];
      if CompareText(sName, DTreeNodes37.sName) = 0 then begin
        Result := DTreeNodes37;
        exit;
      end;
    end;
    if boAdd then begin
      DTreeNodes37 := NewTreeNodes(sName);
      DTreeNodes.ItemList.Add(DTreeNodes37);
      Result := DTreeNodes37;
    end;
  end else begin
    for I := 0 to FTreeItem.Count - 1 do begin
      DTreeNodes37 := FTreeItem[i];
      if CompareText(sName, DTreeNodes37.sName) = 0 then begin
        Result := DTreeNodes37;
        exit;
      end;
    end;
    if boAdd then begin
      DTreeNodes37 := NewTreeNodes(sName);
      Result := DTreeNodes37;
      FTreeItem.Add(DTreeNodes37);
    end;
  end;
end;

function TDTreeView.GetTreeNodesHeight(DTreeNodes: pTDTreeNodes): Integer;
var
  ii: integer;
  DTreeNodes37: pTDTreeNodes;
begin
  Result := FTreeNodesHeigh;
  for ii := 0 to DTreeNodes.ItemList.Count - 1 do begin
    DTreeNodes37 := DTreeNodes.ItemList[ii];
    if DTreeNodes37.boOpen and (DTreeNodes37.ItemList.Count > 0) then begin
      Inc(Result, GetTreeNodesHeight(DTreeNodes37));
    end else
      Inc(Result, FTreeNodesHeigh);
  end;
end;

function TDTreeView.InRange(x, y: integer): Boolean;
begin
  if  (x >= Left) and (x < Left + Width) and (y >= Top) and (y < Top + Height) then
    Result := TRUE
  else
    Result := FALSE;
end;

function TDTreeView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer): Boolean;
begin
  Result := inherited MouseUp(Button, Shift, X, Y);
  if Result and (FocusedControl = self) then begin
    FDownY := Y - Top;
    FboChange := True;
  end;
end;

function TDTreeView.NewTreeNodes(sName: string): pTDTreeNodes;
begin
  New(Result);
  Result.sName := sName;
  Result.Item := nil;
  Result.ItemList := TList.Create;
  Result.boOpen := False;
  Result.nNameLen := DrawCanvas.TextWidth(sName) + FImageWidth;
  Result.boMaster := False;
end;


procedure TDTreeView.PositionChange(Sender: TObject);
begin
  FboChange := True;
end;

procedure TDTreeView.RefHeight;
var
  i: integer;
  DTreeNodes: pTDTreeNodes;
begin
  FMaxHeight := 0;
  for I := 0 to FTreeItem.Count - 1 do begin
    DTreeNodes := FTreeItem[i];
    if DTreeNodes.boOpen and (DTreeNodes.ItemList.Count > 0) then begin
      Inc(FMaxHeight, GetTreeNodesHeight(DTreeNodes));
    end else
      Inc(FMaxHeight, FTreeNodesHeigh);
  end;
  if UpDown <> nil then begin
    if FMaxHeight > Height then begin
      UpDown.Visible := True;
      UpDown.MaxPosition := FMaxHeight - Height;
    end else
      UpDown.Visible := False;
  end;
  FboChange := True;
end;

procedure TDTreeView.SetUpDown(const Value: TDUpDown);
begin
  FUpDown := Value;
  FWheelDControl := Value;
  if FUpDown <> nil then begin
    FUpDown.OnPositionChange := PositionChange;
    FUpDown.Visible := False;
    FUpDown.MaxPosition := 0;
    FUpDown.Position := 0;
  end;
end;

{ TDCustomEdit }

constructor TDCustomEdit.Create(AOwner: TComponent);
begin
  inherited;
  FEditClass := deNone;
  FPasswordChar := #0;
end;

procedure TDCustomEdit.Enter;
begin
  inherited;
  if (FPasswordChar <> #0) or (FEditClass = deInteger) or (FEditClass = deMonoCase) then begin
    if ImmIsIME(GetKeyboardLayout(0)) then begin
      FrmShowIME := True;
      ImmSimulateHotKey(FrmMainWinHandle, IME_CHotKey_IME_NonIME_Toggle);
    end;
    FrmShowIME := False;
  end else begin
    FrmShowIME := True;
    if HklKeyboardLayout <> 0 then
      ActivateKeyboardLayout(HklKeyboardLayout, KLF_ACTIVATE);
    FrmIMEX := Left + 20;
    FrmIMEY := Top;
  end;
end;

procedure TDCustomEdit.IsVisible(flag: Boolean);
begin
  inherited;
  if (not flag) and (KeyControl = Self) then begin
    KeyControl.Leave;
    KeyControl := nil;
  end;
end;

procedure TDCustomEdit.Leave;
begin
  inherited;
  if not ((FPasswordChar <> #0) or (FEditClass = deInteger) or (FEditClass = deMonoCase)) then begin
    HklKeyboardLayout := GetKeyboardLayout(0);
  end;
  if ImmIsIME(GetKeyboardLayout(0)) then begin
    FrmShowIME := True;
    ImmSimulateHotKey(FrmMainWinHandle, IME_CHotKey_IME_NonIME_Toggle);
  end;
  FrmShowIME := False;
end;

initialization
  begin
    GetMem(ChrBuff, 2048);
    ModalDWindowList := TList.Create;
  end;

finalization
  begin
    FreeMem(ChrBuff);
    ModalDWindowList.Free;
  end;

end.




