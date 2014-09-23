unit HGE;
(*
** Haaf's Game Engine 1.7
** Copyright (C) 2003-2007, Relish Games
** hge.relishgames.com
**
** Delphi conversion by Erik van Bilsen
*)

interface

uses
  Classes, Windows, DirectXGraphics;

(****************************************************************************
 * HGE.h
 ****************************************************************************)

const
  HGE_VERSION = $160;
  IRad = 1 / 360;
  TwoPI = 2 * 3.14159265358;

const
  msgDeviceInitialize = $100;
  msgDeviceFinalize   = $101;
  msgDeviceLost       = $102;
  msgDeviceRecovered  = $103;
  msgBeginScene       = $104;
  msgEndScene         = $105;
  msgMonoCanvasBegin  = $200;
  msgMultiCanvasBegin = $201;

(*
** HGE Handle types
*)
type
  ITexture = Interface
  ['{9D5C8783-956C-42E1-9307-CAD03DEC1E7A}']
    function GetHandle: IDirect3DTexture8;
    procedure SetHandle(const Value: IDirect3DTexture8);
    function GetWidth(const Original: Boolean = False): Integer;
    function GetHeight(const Original: Boolean = False): Integer;
    function Lock(const ReadOnly: Boolean = True; const Left: Integer = 0;
      const Top: Integer = 0; const Width: Integer = 0;
      const Height: Integer = 0): PLongword;
    procedure Unlock;

    property Handle: IDirect3DTexture8 read GetHandle write SetHandle;
  end;
(*
type
  IChannel = interface
  ['{32549D16-44B1-4912-A7FE-025BCFFFB950}']
    function GetHandle: HChannel;

    procedure SetPanning(const Pan: Integer);
    procedure SetVolume(const Volume: Integer);
    procedure SetPitch(const Pitch: Single);
    procedure Pause;
    procedure Resume;
    procedure Stop;
    function IsPlaying: Boolean;
    function IsSliding: Boolean;
    function GetLength: Single;
    function GetPos: Single;
    procedure SetPos(const Seconds: Single);
    procedure SlideTo(const Time: Single; const Volume: Integer;
      const Pan: Integer = -101; const Pitch: Single = -1);

    property Handle: HChannel read GetHandle;
  end;

type
  IEffect = interface
  ['{526AD139-7C58-4692-AF7E-84206531CEC2}']
    function GetHandle: HSample;

    function Play: IChannel;
    function PlayEx(const Volume: Integer = 100; const Pan: Integer = 0;
      const Pitch: Single = 1.0; const Loop: Boolean = False): IChannel;

    property Handle: HSample read GetHandle;
  end;

type
  IMusic = interface
  ['{15A0ADA4-DF3D-4821-B06E-5F72208709EA}']
    function GetHandle: HMusic;

    function Play(const Loop: Boolean; const Volume: Integer = 100;
      const Order: Integer = -1; const Row: Integer = -1): IChannel;
    function GetAmplification: Integer;
    function GetLength: Integer;
    procedure SetPos(const Order, Row: Integer);
    function GetPos(out Order, Row: Integer): Boolean;
    procedure SetInstrVolume(const Instr, Volume: Integer);
    function GetInstrVolume(const Instr: Integer): Integer;
    procedure SetChannelVolume(const Channel, Volume: Integer);
    function GetChannelVolume(const Channel: Integer): Integer;

    property Handle: HMusic read GetHandle;
  end;
     *)
type
  ITarget = interface
  ['{16FB54D6-6682-4496-82F0-4B4617FDF2D0}']
    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetTex: ITexture;
    function GetTexture: ITexture;

    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
    property Tex: ITexture read GetTex;
  end;
 (*
type
 IStream = interface
  ['{589A2704-27A7-4E18-B0EA-8F00E1E3A349}']
    function GetHandle: HStream;

    function Play(const Loop: Boolean; const Volume: Integer = 100): IChannel;

    property Handle: HStream read GetHandle;
  end;

type
  IResource = interface
  ['{BAA2A47B-87B1-4D26-A8EF-AE49E3B2BC6F}']
    function GetHandle: Pointer;
    function GetSize: Longword;

    property Handle: Pointer read GetHandle;
    property Size: Longword read GetSize;
  end;
         *)
(*
** Common math constants
*)
const
  M_PI   = 3.14159265358979323846;
  M_PI_2 = 1.57079632679489661923;
  M_PI_4 = 0.785398163397448309616;
  M_1_PI = 0.318309886183790671538;
  M_2_PI = 0.636619772367581343076;

(*
** Hardware color macros
*)
function ARGB(const A, R, G, B: Byte): Longword; inline;
function GetA(const Color: Longword): Byte; inline;
function GetR(const Color: Longword): Byte; inline;
function GetG(const Color: Longword): Byte; inline;
function GetB(const Color: Longword): Byte; inline;
function SetA(const Color: Longword; const A: Byte): Longword; inline;
function SetR(const Color: Longword; const A: Byte): Longword; inline;
function SetG(const Color: Longword; const A: Byte): Longword; inline;
function SetB(const Color: Longword; const A: Byte): Longword; inline;

(*
** HGE Blending constants
*)
const
  BLEND_COLORADD   = 1;
  BLEND_COLORMUL   = 0;
  BLEND_ALPHABLEND = 2;
  BLEND_ALPHAADD   = 0;
  BLEND_ZWRITE     = 4;
  BLEND_NOZWRITE   = 0;

  BLEND_DEFAULT     = BLEND_COLORMUL or BLEND_ALPHABLEND or BLEND_NOZWRITE;
  BLEND_DEFAULT_Z   = BLEND_COLORMUL or BLEND_ALPHABLEND or BLEND_ZWRITE;

  Blend_Add              = 100;
  Blend_SrcAlpha         = 101;
  Blend_SrcAlphaAdd      = 102;
  Blend_SrcColor         = 103;
  BLEND_SrcColorAdd      = 104;
  Blend_Invert           = 105;
  Blend_SrcBright        = 106;
  Blend_Multiply         = 107;
  Blend_InvMultiply      = 108;
  Blend_MultiplyAlpha    = 109;
  Blend_InvMultiplyAlpha = 110;
  Blend_DestBright       = 111;
  Blend_InvSrcBright     = 112;
  Blend_InvDestBright    = 113;
  Blend_Bright           = 114;
  Blend_BrightAdd        = 115;
  Blend_GrayScale        = 116;
  Blend_Light            = 117;
  Blend_LightAdd         = 118;
  Blend_Add2X            = 119;
  Blend_OneColor         = 120;
  Blend_XOR              = 121;
  fxNone                 = 122;
  fxBlend                = 123;
  fxAnti                 = 124;


{*
** HGE System state constants
*}
type
  THGEBoolState = (
    HGE_WINDOWED      = 12,   // bool    run in window?    (default: false)
    HGE_ZBUFFER       = 13,   // bool    use z-buffer?    (default: false)
    HGE_TEXTUREFILTER = 28,   // bool    texture filtering?  (default: true)

//    HGE_USESOUND      = 18,   // bool    use BASS for sound?  (default: true)

    HGE_DONTSUSPEND   = 24,   // bool    focus lost:suspend?  (default: false)
    HGE_HIDEMOUSE     = 25,   // bool    hide system cursor?  (default: true)

    HGE_SHOWSPLASH    = 27,   // bool		 hide system cursor?	(default: true)

    HGE_HARDWARE      = 30,   // bool

    HGEBOOLSTATE_FORCE_DWORD = $7FFFFFFF
  );

type
  THGEFuncState = (
    HGE_FRAMEFUNC      = 1,    // bool*()  frame function    (default: NULL) (you MUST set this)
    HGE_RENDERFUNC     = 2,    // bool*()  render function    (default: NULL)
    HGE_FOCUSLOSTFUNC  = 3,    // bool*()  focus lost function  (default: NULL)
    HGE_FOCUSGAINFUNC  = 4,    // bool*()  focus gain function  (default: NULL)
    HGE_GFXRESTOREFUNC = 5,    // bool*()	 exit function		(default: NULL)
    HGE_EXITFUNC       = 6,    // bool*()  exit function    (default: NULL)

    HGEFUNCSTATE_FORCE_DWORD = $7FFFFFFF
  );

  THGEFinalizeState = (
    HGE_FINALIZE       = 1,

    HGEFINALIZESTATE_FORCE_DWORD = $7FFFFFFF
  );

  THGEInitializeState = (
    HGE_INITIALIZE       = 1,

    HGEINITIALIZESTATE_FORCE_DWORD = $7FFFFFFF
  );

  THGENotifyEventState = (
    HGE_NOTIFYEVENT      = 1,

    HGENOTIFYEVENTSTATE_FORCE_DWORD = $7FFFFFFF
  );

type
  THGEHWndState = (
    HGE_HWND          = 26,  // int    window handle: read only
    HGE_HWNDPARENT    = 27,  // int    parent win handle  (default: 0)

    HGEHWNDSTATE_FORCE_DWORD = $7FFFFFFF
  );

type
  THGEIntState = (
    HGE_SCREENWIDTH    = 9,    // int    screen width    (default: 800)
    HGE_SCREENHEIGHT   = 10,    // int    screen height    (default: 600)
    HGE_SCREENBPP      = 11,   // int    screen bitdepth    (default: 32) (desktop bpp in windowed mode)

//    HGE_SAMPLERATE     = 19,   // int    sample rate      (default: 44100)
//    HGE_FXVOLUME       = 20,   // int    global fx volume  (default: 100)
//    HGE_MUSVOLUME      = 21,   // int    global music volume  (default: 100)

    HGE_FPS            = 23,  // int    fixed fps      (default: HGEFPS_UNLIMITED)

    HGEINTSTATE_FORCE_DWORD = $7FFFFFF
  );

type
  THGEStringState = (
    HGE_ICON        = 7,    // char*  icon resource    (default: NULL)
    HGE_TITLE       = 8,    // char*  window title    (default: "HGE")

//    HGE_INIFILE     = 15,   // char*  ini file      (default: NULL) (meaning no file)
    HGE_LOGFILE     = 16,   // char*  log file      (default: NULL) (meaning no file)

    HGESTRINGSTATE_FORCE_DWORD = $7FFFFFFF
  );

(*
** Callback protoype used by HGE
*)
type
  THGECallback = function: Boolean of object;
  TDeviceNotifyEvent = procedure(Sender: TObject; Msg: Cardinal) of object;
  TInitializeEvent = procedure(Sender: TObject; var Success: Boolean; var ErrorMsg: string) of object;

(*
** HGE_FPS system state special constants
*)
const
  HGEFPS_UNLIMITED =  0;
  HGEFPS_VSYNC     = -1;

(*
** HGE Primitive type constants
*)
const
  HGEPRIM_LINES    = 2;
  HGEPRIM_TRIPLES  = 3;
  HGEPRIM_QUADS    = 4;

(*
** HGE Vertex structure
*)
type
  THGEVertex = record
    X, Y: Single;   // screen position
    Z: Single;      // Z-buffer depth 0..1
    Col: Longword;  // color
    TX, TY: Single; // texture coordinates
  end;
  PHGEVertex = ^THGEVertex;
  THGEVertexArray = array [0..MaxInt div 32 - 1] of THGEVertex;
  PHGEVertexArray = ^THGEVertexArray;

(*
** HGE Triple structure
*)
type
  THGETriple = record
    V: array [0..2] of THGEVertex;
    Tex: ITexture;
    Blend: Integer;
  end;
  PHGETriple = ^THGETriple;

(*
** HGE Quad structure
*)
type
  THGEQuad = record
    V: array [0..3] of THGEVertex;
    Tex: ITexture;
    Blend: Integer;
  end;
  PHGEQuad = ^THGEQuad;

(*
** HGE Input Event structure
*)
type
  THGEInputEvent = record
    EventType: Integer;  // event type
    Key: Integer;        // key code
    Flags: Integer;      // event flags
    Chr: Integer;        // character code
    Wheel: Integer;      // wheel shift
    X: Single;          // mouse cursor x-coordinate
    Y: Single;          // mouse cursor y-coordinate
  end;

(*
** HGE Input Event type constants
*)
const
  INPUT_KEYDOWN      = 1;
  INPUT_KEYUP        = 2;
  INPUT_MBUTTONDOWN  = 3;
  INPUT_MBUTTONUP    = 4;
  INPUT_MOUSEMOVE    = 5;
  INPUT_MOUSEWHEEL  = 6;

(*
** HGE Input Event flags
*)
const
  HGEINP_SHIFT      = 1;
  HGEINP_CTRL        = 2;
  HGEINP_ALT        = 4;
  HGEINP_CAPSLOCK    = 8;
  HGEINP_SCROLLLOCK  = 16;
  HGEINP_NUMLOCK    = 32;
  HGEINP_REPEAT      = 64;

type
  IHGE = interface
  ['{14AD0876-19A5-4B13-B2D8-46ECE1E336BA}']
    function System_Initiate: Boolean;
    procedure System_Shutdown;
    function System_Start: Boolean;
    function System_GetErrorMessage: String;
    procedure System_Log(const S: String); overload;
    procedure System_Log(const Format: String; const Args: array of Const); overload;
    function System_Launch(const Url: String): Boolean;
    procedure System_Snapshot(const Filename: String);
    procedure System_SetState(const State: THGEBoolState; const Value: Boolean); overload;
    procedure System_SetState(const State: THGEFuncState; const Value: THGECallback); overload;
    procedure System_SetState(const State: THGEHWndState; const Value: HWnd); overload;
    procedure System_SetState(const State: THGEIntState; const Value: Integer); overload;
    procedure System_SetState(const State: THGEStringState; const Value: String); overload;
    procedure System_SetState(const State: THGEInitializeState; const Value: TInitializeEvent); overload;
    procedure System_SetState(const State: THGEFinalizeState; const Value: TNotifyEvent); overload;
    procedure System_SetState(const State: THGENotifyEventState; const Value: TDeviceNotifyEvent); overload;

    function System_GetState(const State: THGEBoolState): Boolean; overload;
    function System_GetState(const State: THGEFuncState): THGECallback; overload;
    function System_GetState(const State: THGEHWndState): HWnd; overload;
    function System_GetState(const State: THGEIntState): Integer; overload;
    function System_GetState(const State: THGEStringState): String; overload;
    function System_GetState(const State: THGEInitializeState): TInitializeEvent; overload;
    function System_GetState(const State: THGEFinalizeState): TNotifyEvent; overload;
    function System_GetState(const State: THGENotifyEventState): TDeviceNotifyEvent; overload;
    (*
    function Resource_Load(const Filename: String; const Size: PLongword = nil): IResource;
    { NOTE: ZIP passwords are not supported in Delphi version }
    function Resource_AttachPack(const Filename: String): Boolean;
    procedure Resource_RemovePack(const Filename: String);
    procedure Resource_RemoveAllPacks;
    function Resource_MakePath(const Filename: String = ''): String;
    function Resource_EnumFiles(const Wildcard: String = ''): String;
    function Resource_EnumFolders(const Wildcard: String = ''): String;
                *)
    procedure Ini_SetInt(const Section, Name: String; const Value: Integer);
    function Ini_GetInt(const Section, Name: String; const DefVal: Integer = 0): Integer;
    procedure Ini_SetFloat(const Section, Name: String; const Value: Single);
    function Ini_GetFloat(const Section, Name: String; const DefVal: Single): Single;
    procedure Ini_SetString(const Section, Name, Value: String);
    function Ini_GetString(const Section, Name, DefVal: String): String;

    procedure Random_Seed(const Seed: Integer = 0);
    function Random_Int(const Min, Max: Integer): Integer;
    function Random_Float(const Min, Max: Single): Single;

    function Timer_GetTime: Single;
    function Timer_GetDelta: Single;
    function Timer_GetFPS: Integer;

    {function Effect_Load(const Data: Pointer; const Size: Longword): IEffect; overload;
    function Effect_Load(const Filename: String): IEffect; overload;
    function Effect_Play(const Eff: IEffect): IChannel;
    function Effect_PlayEx(const Eff: IEffect; const Volume: Integer = 100;
      const Pan: Integer = 0; const Pitch: Single = 1.0; const Loop: Boolean = False): IChannel;

    function Music_Load(const Filename: String): IMusic; overload;
    function Music_Load(const Data: Pointer; const Size: Longword): IMusic; overload;
    function Music_Play(const Mus: IMusic; const Loop: Boolean;
      const Volume: Integer = 100; const Order: Integer = -1;
      const Row: Integer = -1): IChannel;
    procedure Music_SetAmplification(const Music: IMusic; const Ampl: Integer);
    function Music_GetAmplification(const Music: IMusic): Integer;
    function Music_GetLength(const Music: IMusic): Integer;
    procedure Music_SetPos(const Music: IMusic; const Order, Row: Integer);
    function Music_GetPos(const Music: IMusic; out Order, Row: Integer): Boolean;
    procedure Music_SetInstrVolume(const Music: IMusic; const Instr,
      Volume: Integer);
    function Music_GetInstrVolume(const Music: IMusic;
      const Instr: Integer): Integer;
    procedure Music_SetChannelVolume(const Music: IMusic; const Channel,
      Volume: Integer);
    function Music_GetChannelVolume(const Music: IMusic;
      const Channel: Integer): Integer;

    function Stream_Load(const Filename: String): IStream; overload;
    function Stream_Load(const Data: Pointer; const Size: Longword): IStream; overload;
    function Stream_Play(const Stream: IStream; const Loop: Boolean;
      const Volume: Integer = 100): IChannel;

    procedure Channel_SetPanning(const Chn: IChannel; const Pan: Integer);
    procedure Channel_SetVolume(const Chn: IChannel; const Volume: Integer);
    procedure Channel_SetPitch(const Chn: IChannel; const Pitch: Single);
    procedure Channel_Pause(const Chn: IChannel);
    procedure Channel_Resume(const Chn: IChannel);
    procedure Channel_Stop(const Chn: IChannel);
    procedure Channel_PauseAll;
    procedure Channel_ResumeAll;
    procedure Channel_StopAll;
    function Channel_IsPlaying(const Chn: IChannel): Boolean;
    function Channel_GetLength(const Chn: IChannel): Single;
    function Channel_GetPos(const Chn: IChannel): Single;
    procedure Channel_SetPos(const Chn: IChannel; const Seconds: Single);
    procedure Channel_SlideTo(const Channel: IChannel; const Time: Single;
      const Volume: Integer; const Pan: Integer = -101; const Pitch: Single = -1);
    function Channel_IsSliding(const Channel: IChannel): Boolean;
                        }
    procedure Input_GetMousePos(out X, Y: Single);
    procedure Input_SetMousePos(const X, Y: Single);
    function Input_GetMouseWheel: Integer;
    function Input_IsMouseOver: Boolean;
    function Input_KeyDown(const Key: Integer): Boolean;
    function Input_KeyUp(const Key: Integer): Boolean;
    function Input_GetKeyState(const Key: Integer): Boolean;
    function Input_GetKeyName(const Key: Integer): String;
    function Input_GetKey: Integer;
    function Input_GetChar: Integer;
    function Input_GetEvent(out Event: THGEInputEvent): Boolean;

    function Gfx_BeginScene(const Target: ITarget = nil): Boolean;
    procedure Gfx_EndScene;
    procedure Gfx_Clear(const Color: Longword);
    procedure Gfx_RenderLine(const X1, Y1, X2, Y2: Single; const Color: Longword = $FFFFFFFF; const Z: Single = 0.5);
    procedure Gfx_RenderCircle(X, Y, Radius: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_Default);
    procedure Gfx_RenderTriangle(X1, Y1, X2, Y2, X3, Y3: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderEllipse(X, Y, R1, R2: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderArc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal; DrawStartEnd, Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderLine2Color(X1, Y1, X2, Y2: Single; Color1, Color2: Cardinal; BlendMode: Integer);
    procedure Gfx_RenderQuadrangle4Color(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; Color1, Color2, Color3, Color4: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderPolygon(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderSquareSchedule(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderTriple(const Triple: THGETriple);
    procedure Gfx_RenderQuad(const Quad: THGEQuad);
    function Gfx_StartBatch(const PrimType: Integer; const Tex: ITexture;
      const Blend: Integer; out MaxPrim: Integer): PHGEVertexArray;
    procedure Gfx_FinishBatch(const NPrim: Integer);
    procedure Gfx_SetClipping(X: Integer = 0; Y: Integer = 0;
      W: Integer = 0; H: Integer = 0);
    procedure Gfx_SetTransform(const X: Single = 0; const Y: Single = 0;
      const DX: Single = 0; const DY: Single = 0; const Rot: Single = 0;
      const HScale: Single = 0; const VScale: Single = 0);

    function Target_Create(const Width, Height: Integer; const ZBuffer: Boolean): ITarget;
    function Target_GetTexture(const Target: ITarget): ITexture;

    function Texture_Create(const Width, Height: Integer): ITexture; overload;
    function Texture_Create(const Width, Height: Integer; Pool: TD3DPool; Format: TD3DFormat): ITexture; overload;
    function Texture_Create(const Width, Height: Integer; Tex: IDirect3DTexture8): ITexture; overload;
   { function Texture_Load(const Data: Pointer; const Size: Longword;
      const Mipmap: Boolean = False): ITexture; overload;    }
   { function Texture_Load(const Filename: String;
      const Mipmap: Boolean = False): ITexture; overload;  }
    function Texture_GetWidth(const Tex: ITexture; const Original: Boolean = False): Integer;
    function Texture_GetHeight(const Tex: ITexture; const Original: Boolean = False): Integer;
    function Texture_Lock(const Tex: ITexture; const ReadOnly: Boolean = True;
      const Left: Integer = 0; const Top: Integer = 0; const Width: Integer = 0;
      const Height: Integer = 0): PLongword;
    procedure Texture_Unlock(const Tex: ITexture);

    { Extensions }
   { function Texture_Load(const ImageData: Pointer; const ImageSize: Longword;
      const AlphaData: Pointer; const AlphaSize: Longword;
      const Mipmap: Boolean = False): ITexture; overload;    }
    {function Texture_Load(const ImageFilename, AlphaFilename: String;
      const Mipmap: Boolean = False): ITexture; overload;  }
    procedure RenderBatch(const EndScene: Boolean = False);
    function GetCurPrimType: Integer;
    procedure SetCurPrimType(const Value: Integer);
    procedure SetBlendMode(const Blend: Integer);
    function GetD3DDevice: IDirect3DDevice8;
    procedure CopyVertices(pVertices: PByte; numVertices: integer);
    function GetVertArray: PHGEVertexArray;

    function GetCurTexture: ITexture;
    procedure SetCurTexture(const Value: ITexture);

    property CurTexture: ITexture read GetCurTexture write SetCurTexture;
    property CurPrimType: Integer read GetCurPrimType write SetCurPrimType;
  end;

function HGECreate(const Ver: Integer): IHGE;

(*
** HGE Virtual-key codes
*)
const
  HGEK_LBUTTON    = $01;
  HGEK_RBUTTON    = $02;
  HGEK_MBUTTON    = $04;

  HGEK_ESCAPE      = $1B;
  HGEK_BACKSPACE  = $08;
  HGEK_TAB        = $09;
  HGEK_ENTER      = $0D;
  HGEK_SPACE      = $20;

  HGEK_SHIFT      = $10;
  HGEK_CTRL        = $11;
  HGEK_ALT        = $12;

  HGEK_LWIN        = $5B;
  HGEK_RWIN        = $5C;
  HGEK_APPS        = $5D;

  HGEK_PAUSE      = $13;
  HGEK_CAPSLOCK    = $14;
  HGEK_NUMLOCK    = $90;
  HGEK_SCROLLLOCK = $91;

  HGEK_PGUP        = $21;
  HGEK_PGDN        = $22;
  HGEK_HOME        = $24;
  HGEK_END        = $23;
  HGEK_INSERT      = $2D;
  HGEK_DELETE      = $2E;

  HGEK_LEFT        = $25;
  HGEK_UP          = $26;
  HGEK_RIGHT      = $27;
  HGEK_DOWN        = $28;

  HGEK_0          = $30;
  HGEK_1          = $31;
  HGEK_2          = $32;
  HGEK_3          = $33;
  HGEK_4          = $34;
  HGEK_5          = $35;
  HGEK_6          = $36;
  HGEK_7          = $37;
  HGEK_8          = $38;
  HGEK_9          = $39;

  HGEK_A          = $41;
  HGEK_B          = $42;
  HGEK_C          = $43;
  HGEK_D          = $44;
  HGEK_E          = $45;
  HGEK_F          = $46;
  HGEK_G          = $47;
  HGEK_H          = $48;
  HGEK_I          = $49;
  HGEK_J          = $4A;
  HGEK_K          = $4B;
  HGEK_L          = $4C;
  HGEK_M          = $4D;
  HGEK_N          = $4E;
  HGEK_O          = $4F;
  HGEK_P          = $50;
  HGEK_Q          = $51;
  HGEK_R          = $52;
  HGEK_S          = $53;
  HGEK_T          = $54;
  HGEK_U          = $55;
  HGEK_V          = $56;
  HGEK_W          = $57;
  HGEK_X          = $58;
  HGEK_Y          = $59;
  HGEK_Z          = $5A;

  HGEK_GRAVE      = $C0;
  HGEK_MINUS      = $BD;
  HGEK_EQUALS      = $BB;
  HGEK_BACKSLASH  = $DC;
  HGEK_LBRACKET    = $DB;
  HGEK_RBRACKET    = $DD;
  HGEK_SEMICOLON  = $BA;
  HGEK_APOSTROPHE = $DE;
  HGEK_COMMA      = $BC;
  HGEK_PERIOD      = $BE;
  HGEK_SLASH      = $BF;

  HGEK_NUMPAD0    = $60;
  HGEK_NUMPAD1    = $61;
  HGEK_NUMPAD2    = $62;
  HGEK_NUMPAD3    = $63;
  HGEK_NUMPAD4    = $64;
  HGEK_NUMPAD5    = $65;
  HGEK_NUMPAD6    = $66;
  HGEK_NUMPAD7    = $67;
  HGEK_NUMPAD8    = $68;
  HGEK_NUMPAD9    = $69;

  HGEK_MULTIPLY    = $6A;
  HGEK_DIVIDE      = $6F;
  HGEK_ADD        = $6B;
  HGEK_SUBTRACT    = $6D;
  HGEK_DECIMAL    = $6E;

  HGEK_F1          = $70;
  HGEK_F2          = $71;
  HGEK_F3          = $72;
  HGEK_F4          = $73;
  HGEK_F5          = $74;
  HGEK_F6          = $75;
  HGEK_F7          = $76;
  HGEK_F8          = $77;
  HGEK_F9          = $78;
  HGEK_F10        = $79;
  HGEK_F11        = $7A;
  HGEK_F12        = $7B;

implementation

uses
  Messages, Math, MMSystem, ShellAPI, SysUtils, Types, ZLib, D3DX81mo{, ZipUtils,
  UnZip};

const
  CRLF = #13#10;

(****************************************************************************
 * HGE.h - Macro implementations
 ****************************************************************************)

function ARGB(const A, R, G, B: Byte): Longword; inline;
begin
  Result := (A shl 24) or (R shl 16) or (G shl 8) or B;
end;

function GetA(const Color: Longword): Byte; inline;
begin
  Result := Color shr 24;
end;

function GetR(const Color: Longword): Byte; inline;
begin
  Result := (Color shr 16) and $FF;
end;

function GetG(const Color: Longword): Byte; inline;
begin
  Result := (Color shr 8) and $FF;
end;

function GetB(const Color: Longword): Byte; inline;
begin
  Result := Color and $FF;
end;

function SetA(const Color: Longword; const A: Byte): Longword; inline;
begin
  Result := (Color and $00FFFFFF) or (A shl 24);
end;

function SetR(const Color: Longword; const A: Byte): Longword; inline;
begin
  Result := (Color and $FF00FFFF) or (A shl 16);
end;

function SetG(const Color: Longword; const A: Byte): Longword; inline;
begin
  Result := (Color and $FFFF00FF) or (A shl 8);
end;

function SetB(const Color: Longword; const A: Byte): Longword; inline;
begin
  Result := (Color and $FFFFFF00) or A;
end;

(****************************************************************************
 * HGE_Impl.h
 ****************************************************************************)

{.$DEFINE DEMO}

const
  D3DFVF_HGEVERTEX   = D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1;
  VERTEX_BUFFER_SIZE = 4000;

type
  PResourceList = ^TResourceList;
  TResourceList = record
    Filename: String;
    // Password: String; // NOTE: ZIP passwords are not supported in Delphi version
    Next: PResourceList;
  end;

type
  PInputEventList = ^TInputEventList;
  TInputEventList = record
    Event: THGEInputEvent;
    Next: PInputEventList;
  end;

(*
** HGE Interface implementation
*)
type
  THGEImpl = class(TInterfacedObject,IHGE)
  protected
    { IHGE }
    function System_Initiate: Boolean;
    procedure System_Shutdown;
    function System_Start: Boolean;
    function System_GetErrorMessage: String;
    procedure System_Log(const S: String); overload;
    procedure System_Log(const Format: String; const Args: array of Const); overload;
    function System_Launch(const Url: String): Boolean;
    procedure System_Snapshot(const Filename: String);
    procedure System_SetState(const State: THGEBoolState; const Value: Boolean); overload;
    procedure System_SetState(const State: THGEFuncState; const Value: THGECallback); overload;
    procedure System_SetState(const State: THGEHWndState; const Value: HWnd); overload;
    procedure System_SetState(const State: THGEIntState; const Value: Integer); overload;
    procedure System_SetState(const State: THGEStringState; const Value: String); overload;
    procedure System_SetState(const State: THGEInitializeState; const Value: TInitializeEvent); overload;
    procedure System_SetState(const State: THGEFinalizeState; const Value: TNotifyEvent); overload;
    procedure System_SetState(const State: THGENotifyEventState; const Value: TDeviceNotifyEvent); overload;

    function System_GetState(const State: THGEBoolState): Boolean; overload;
    function System_GetState(const State: THGEFuncState): THGECallback; overload;
    function System_GetState(const State: THGEHWndState): HWnd; overload;
    function System_GetState(const State: THGEIntState): Integer; overload;
    function System_GetState(const State: THGEStringState): String; overload;
    function System_GetState(const State: THGEInitializeState): TInitializeEvent; overload;
    function System_GetState(const State: THGEFinalizeState): TNotifyEvent; overload;
    function System_GetState(const State: THGENotifyEventState): TDeviceNotifyEvent; overload;
    (*
    function Resource_Load(const Filename: String; const Size: PLongword = nil): IResource;
    function Resource_AttachPack(const Filename: String): Boolean;
    procedure Resource_RemovePack(const Filename: String);
    procedure Resource_RemoveAllPacks;
    function Resource_MakePath(const Filename: String = ''): String;
    function Resource_EnumFiles(const Wildcard: String = ''): String;
    function Resource_EnumFolders(const Wildcard: String = ''): String;
                    *)
    procedure Ini_SetInt(const Section, Name: String; const Value: Integer);
    function Ini_GetInt(const Section, Name: String; const DefVal: Integer = 0): Integer;
    procedure Ini_SetFloat(const Section, Name: String; const Value: Single);
    function Ini_GetFloat(const Section, Name: String; const DefVal: Single): Single;
    procedure Ini_SetString(const Section, Name, Value: String);
    function Ini_GetString(const Section, Name, DefVal: String): String;

    procedure Random_Seed(const Seed: Integer = 0);
    function Random_Int(const Min, Max: Integer): Integer;
    function Random_Float(const Min, Max: Single): Single;

    function Timer_GetTime: Single;
    function Timer_GetDelta: Single;
    function Timer_GetFPS: Integer;
    {
    function Effect_Load(const Data: Pointer; const Size: Longword): IEffect; overload;
    function Effect_Load(const Filename: String): IEffect; overload;
    function Effect_Play(const Eff: IEffect): IChannel;
    function Effect_PlayEx(const Eff: IEffect; const Volume: Integer = 100;
      const Pan: Integer = 0; const Pitch: Single = 1.0; const Loop: Boolean = False): IChannel;

    function Music_Load(const Filename: String): IMusic; overload;
    function Music_Load(const Data: Pointer; const Size: Longword): IMusic; overload;
    function Music_Play(const Mus: IMusic; const Loop: Boolean;
      const Volume: Integer = 100; const Order: Integer = -1;
      const Row: Integer = -1): IChannel;
    procedure Music_SetAmplification(const Music: IMusic; const Ampl: Integer);
    function Music_GetAmplification(const Music: IMusic): Integer;
    function Music_GetLength(const Music: IMusic): Integer;
    procedure Music_SetPos(const Music: IMusic; const Order, Row: Integer);
    function Music_GetPos(const Music: IMusic; out Order, Row: Integer): Boolean;
    procedure Music_SetInstrVolume(const Music: IMusic; const Instr,
      Volume: Integer);
    function Music_GetInstrVolume(const Music: IMusic;
      const Instr: Integer): Integer;
    procedure Music_SetChannelVolume(const Music: IMusic; const Channel,
      Volume: Integer);
    function Music_GetChannelVolume(const Music: IMusic;
      const Channel: Integer): Integer;

    function Stream_Load(const Filename: String): IStream; overload;
    function Stream_Load(const Data: Pointer; const Size: Longword): IStream; overload;
    function Stream_Load(const Resource: IResource; const Size: Longword): IStream; overload;
    function Stream_Play(const Stream: IStream; const Loop: Boolean;
      const Volume: Integer = 100): IChannel;

    procedure Channel_SetPanning(const Chn: IChannel; const Pan: Integer);
    procedure Channel_SetVolume(const Chn: IChannel; const Volume: Integer);
    procedure Channel_SetPitch(const Chn: IChannel; const Pitch: Single);
    procedure Channel_Pause(const Chn: IChannel);
    procedure Channel_Resume(const Chn: IChannel);
    procedure Channel_Stop(const Chn: IChannel);
    procedure Channel_PauseAll;
    procedure Channel_ResumeAll;
    procedure Channel_StopAll;
    function Channel_IsPlaying(const Chn: IChannel): Boolean;
    function Channel_GetLength(const Chn: IChannel): Single;
    function Channel_GetPos(const Chn: IChannel): Single;
    procedure Channel_SetPos(const Chn: IChannel; const Seconds: Single);
    procedure Channel_SlideTo(const Channel: IChannel; const Time: Single;
      const Volume: Integer; const Pan: Integer = -101; const Pitch: Single = -1);
    function Channel_IsSliding(const Channel: IChannel): Boolean;
                     }
    procedure Input_GetMousePos(out X, Y: Single);
    procedure Input_SetMousePos(const X, Y: Single);
    function Input_GetMouseWheel: Integer;
    function Input_IsMouseOver: Boolean;
    function Input_KeyDown(const Key: Integer): Boolean;
    function Input_KeyUp(const Key: Integer): Boolean;
    function Input_GetKeyState(const Key: Integer): Boolean;
    function Input_GetKeyName(const Key: Integer): String;
    function Input_GetKey: Integer;
    function Input_GetChar: Integer;
    function Input_GetEvent(out Event: THGEInputEvent): Boolean;

    function Gfx_BeginScene(const Target: ITarget = nil): Boolean;
    procedure Gfx_EndScene;
    procedure Gfx_Clear(const Color: Longword);
    procedure Gfx_RenderLine(const X1, Y1, X2, Y2: Single; const Color: Longword = $FFFFFFFF; const Z: Single = 0.5);
    procedure Gfx_RenderCircle(X, Y, Radius: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_Default);
    procedure Gfx_RenderTriangle(X1, Y1, X2, Y2, X3, Y3: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderEllipse(X, Y, R1, R2: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderArc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal; DrawStartEnd, Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderLine2Color(X1, Y1, X2, Y2: Single; Color1, Color2: Cardinal; BlendMode: Integer);
    procedure Gfx_RenderQuadrangle4Color(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; Color1, Color2, Color3, Color4: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderPolygon(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; Filled: Boolean; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderSquareSchedule(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; BlendMode: Integer = BLEND_DEFAULT);
    procedure Gfx_RenderTriple(const Triple: THGETriple);
    procedure Gfx_RenderQuad(const Quad: THGEQuad);
    function Gfx_StartBatch(const PrimType: Integer; const Tex: ITexture;
      const Blend: Integer; out MaxPrim: Integer): PHGEVertexArray;
    procedure Gfx_FinishBatch(const NPrim: Integer);
    procedure Gfx_SetClipping(X: Integer = 0; Y: Integer = 0;
      W: Integer = 0; H: Integer = 0);
    procedure Gfx_SetTransform(const X: Single = 0; const Y: Single = 0;
      const DX: Single = 0; const DY: Single = 0; const Rot: Single = 0;
      const HScale: Single = 0; const VScale: Single = 0);

    function Target_Create(const Width, Height: Integer; const ZBuffer: Boolean): ITarget;
    function Target_GetTexture(const Target: ITarget): ITexture;

    function Texture_Create(const Width, Height: Integer): ITexture; overload;
    function Texture_Create(const Width, Height:Integer; Pool: TD3DPool; Format: TD3DFormat): ITexture; overload;
    function Texture_Create(const Width, Height: Integer; Tex: IDirect3DTexture8): ITexture; overload;
{    function Texture_Load(const Data: Pointer; const Size: Longword;
      const Mipmap: Boolean = False): ITexture; overload;  }
{    function Texture_Load(const Filename: String;
      const Mipmap: Boolean = False): ITexture; overload;  }
    function Texture_GetWidth(const Tex: ITexture; const Original: Boolean = False): Integer;
    function Texture_GetHeight(const Tex: ITexture; const Original: Boolean = False): Integer;
    function Texture_Lock(const Tex: ITexture; const ReadOnly: Boolean = True;
      const Left: Integer = 0; const Top: Integer = 0; const Width: Integer = 0;
      const Height: Integer = 0): PLongword;
    procedure Texture_Unlock(const Tex: ITexture);

    { Extensions }
  {  function Texture_Load(const ImageData: Pointer; const ImageSize: Longword;
      const AlphaData: Pointer; const AlphaSize: Longword;
      const Mipmap: Boolean = False): ITexture; overload;  }
{    function Texture_Load(const ImageFilename, AlphaFilename: String;
      const Mipmap: Boolean = False): ITexture; overload; }
    procedure RenderBatch(const EndScene: Boolean = False);
    procedure SetBlendMode(const Blend: Integer);
    function GetD3DDevice: IDirect3DDevice8;
    procedure CopyVertices(pVertices: PByte; numVertices: integer);
    function GetVertArray: PHGEVertexArray;
    
    function GetCurPrimType: Integer;
    procedure SetCurPrimType(const Value: Integer);
    function GetCurTexture: ITexture;
    procedure SetCurTexture(const Value: ITexture);
  private
    //////// Implementation ////////
    FInstance: THandle;
    FWnd: HWnd;
    FActive: Boolean;
    FError: String;
    FAppPath: String;
    FFormatSettings: TFormatSettings;


    procedure FocusChange(const Act: Boolean);
    procedure PostError(const Error: String);
    class function InterfaceGet: THGEImpl;
  private
    // Extensions
    {function Texture_LoadJPEG2000(const Data: Pointer; const Size: Longword;
      const Mipmap: Boolean; const Format: TOPJ_CodecFormat): ITexture;  }
  private
    // System States
    FProcFrameFunc: THGECallback;
    FProcRenderFunc: THGECallback;
    FProcFocusLostFunc: THGECallback;
    FProcFocusGainFunc: THGECallback;
    FProcGfxRestoreFunc: THGECallback;
    FProcExitFunc: THGECallback;
    FOnFinalize: TNotifyEvent;
    FOnInitialize: TInitializeEvent;
    FOnNotifyEvent: TDeviceNotifyEvent;
    FIcon: String;
    FWinTitle: String;
    FScreenWidth: Integer;
    FScreenHeight: Integer;
    FScreenBPP: Integer;
    FWindowed: Boolean;
    FZBuffer: Boolean;
    FTextureFilter: Boolean;
    FIniFile: String;
    FLogFile: String;
    FUseSound: Boolean;
{    FSampleRate: Integer;
    FFXVolume: Integer;
    FMusVolume: Integer;   }
    FHGEFPS: Integer;
    FHideMouse: Boolean;
    FHardwareTL: Boolean;
    FDontSuspend: Boolean;
    FWndParent: HWnd;
  private
    // Graphics
    FD3DPP: PD3DPresentParameters;
    FD3DPPW: TD3DPresentParameters;
    FRectW: TRect;
    FStyleW: Longword;
    FD3DPPFS: TD3DPresentParameters;
    FRectFS: TRect;
    FStyleFS: Longword;
    FD3D: IDirect3D8;
    FD3DDevice: IDirect3DDevice8;
    FVB: IDirect3DVertexBuffer8;
    FIB: IDirect3DIndexBuffer8;
    FScreenSurf: IDirect3DSurface8;
    FScreenDepth: IDirect3DSurface8;
    FTargets: TList;
    FCurTarget: ITarget;
    FMatView: TD3DXMatrix;
    FMatProj: TD3DXMatrix;
    FVertArray: PHGEVertexArray;
    FPrim: Integer;
    FCurPrimType: Integer;
    FCurBlendMode: Integer;
    FCurTexture: ITexture;
    function GfxInit: Boolean;
    procedure GfxDone;
    function GfxRestore: Boolean;
    procedure AdjustWindow;
    procedure Resize(const Width, Height: Integer);
    function InitLost: Boolean;

    function FormatId(const Fmt: TD3DFormat): Integer;

    procedure SetProjectionMatrix(const Width, Height: Integer);
  private
     // Audio
//    FBass: THandle;
//    FSilent: Boolean;
//    function SoundInit: Boolean;
//    procedure SoundDone;
//    procedure SetMusVolume(const Vol: Integer);
//    procedure SetFXVolume(const Vol: Integer);
  private
    // Input
    FVKey: Integer;
    FChar: Integer;
    FZPos: Integer;
    FXPos: Single;
    FYPos: Single;
    FMouseOver: Boolean;
    FCaptured: Boolean;
    FKeyz: array [0..255] of Byte;
    FQueue: PInputEventList;
    procedure UpdateMouse;
    procedure InputInit;
    procedure ClearQueue;
    procedure BuildEvent(EventType, Key, Scan, Flags, X, Y: Integer);
  private
    // Resource
//    FTmpFilename: String;
//    FRes: PResourceList;
    FSearch: TSearchRec;
  private
    // Timer
    FTime: Single;
    FDeltaTime: Single;
    FFixedDelta: Longword;
    FFPS: Integer;
    FT0, FT0FPS, FDT: Longword;
    FCFPS: Integer;
  private
    constructor Create;
  public
    destructor Destroy; override;
  end;

var
  PHGE: THGEImpl = nil;
 (*
type
  IInternalChannel = interface(IChannel)
  ['{F7EFCB72-56E5-4FED-A89A-4B1D0AEE794D}']
    procedure SetHandle(const Value: HChannel);
  end;  *)

type
  IInternalTarget = interface(ITarget)
  ['{579FDCE5-3D0C-403F-9B58-44117B226A26}']
    function GetDepth: IDirect3DSurface8;

    procedure Restore;
    procedure Lost;

    property Depth: IDirect3DSurface8 read GetDepth;
  end;
 (*
type
  IInternalStream = interface(IStream)
  ['{37BFE886-0402-4CB7-B2A1-46D1C2ED0D82}']
    function GetData: IResource;

    property Data: IResource read GetData;
  end;
        *)
type
  TTexture = class(TInterfacedObject,ITexture)
  private
    FHandle: IDirect3DTexture8;
    FOriginalWidth: Integer;
    FOriginalHeight: Integer;
  protected
    { ITexture }
    function GetHandle: IDirect3DTexture8;
    procedure SetHandle(const Value: IDirect3DTexture8);
    function GetWidth(const Original: Boolean = False): Integer;
    function GetHeight(const Original: Boolean = False): Integer;
    function Lock(const ReadOnly: Boolean = True; const Left: Integer = 0;
      const Top: Integer = 0; const Width: Integer = 0;
      const Height: Integer = 0): PLongword;
    procedure Unlock;
  public
    constructor Create(const AHandle: IDirect3DTexture8;
      const AOriginalWidth, AOriginalHeight: Integer);
  end;
(*
type
  TChannel = class(TInterfacedObject,IChannel,IInternalChannel)
  private
    FHandle: HChannel;
  protected
    { IChannel }
    function GetHandle: HChannel;
    procedure SetPanning(const Pan: Integer);
    procedure SetVolume(const Volume: Integer);
    procedure SetPitch(const Pitch: Single);
    procedure Pause;
    procedure Resume;
    procedure Stop;
    function IsPlaying: Boolean;
    function IsSliding: Boolean;
    function GetLength: Single;
    function GetPos: Single;
    procedure SetPos(const Seconds: Single);
    procedure SlideTo(const Time: Single; const Volume: Integer;
      const Pan: Integer = -101; const Pitch: Single = -1);

    { IInternalChannel }
    procedure SetHandle(const Value: HChannel);
  public
    constructor Create(const AHandle: HChannel);
    destructor Destroy; override;
  end;

type
  TEffect = class(TInterfacedObject,IEffect)
  private
    FHandle: HSample;
    FChannel: IInternalChannel;
  protected
    { IEffect }
    function GetHandle: HSample;
    function Play: IChannel;
    function PlayEx(const Volume: Integer = 100; const Pan: Integer = 0;
      const Pitch: Single = 1.0; const Loop: Boolean = False): IChannel;
  public
    constructor Create(const AHandle: HSample);
    destructor Destroy; override;
  end;

type
  TMusic = class(TChannel,IMusic,IChannel)
  private
    function MusicGetLength: Integer;
    procedure MusicSetPos(const Order, Row: Integer);
    function MusicGetPos(out Order, Row: Integer): Boolean;
  protected
    { IMusic }
    function Play(const Loop: Boolean; const Volume: Integer = 100;
      const Order: Integer = -1; const Row: Integer = -1): IChannel;
    function GetAmplification: Integer;
    function IMusic.GetLength = MusicGetLength;
    procedure IMusic.SetPos = MusicSetPos;
    function IMusic.GetPos = MusicGetPos;
    procedure SetInstrVolume(const Instr, Volume: Integer);
    function GetInstrVolume(const Instr: Integer): Integer;
    procedure SetChannelVolume(const Channel, Volume: Integer);
    function GetChannelVolume(const Channel: Integer): Integer;
  public
    destructor Destroy; override;
  end;
        *)
type
  TTarget = class(TInterfacedObject,ITarget,IInternalTarget)
  private
    FWidth: Integer;
    FHeight: Integer;
    FTex: ITexture;
    FDepth: IDirect3DSurface8;
  protected
    { ITarget }
    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetTex: ITexture;
    function GetTexture: ITexture;
    { IInternalTarget }
    function GetDepth: IDirect3DSurface8;
    procedure Restore;
    procedure Lost;
  public
    constructor Create(const AWidth, AHeight: Integer; const ATex: ITexture;
      const ADepth: IDirect3DSurface8);
    destructor Destroy; override;
  end;
(*
type
  TStream = class(TChannel,IStream,IInternalStream,IChannel)
  private
    FData: IResource;
  protected
    { IStream }
    function Play(const Loop: Boolean; const Volume: Integer = 100): IChannel;
    { IInternalStream }
    function GetData: IResource;
  public
    constructor Create(const AHandle: HStream; const AData: IResource);
    destructor Destroy; override;
  end;

type
  TResource = class(TInterfacedObject,IResource)
  private
    FHandle: Pointer;
    FSize: Longword;
  protected
    { IResource }
    function GetHandle: Pointer;
    function GetSize: Longword;
  public
    constructor Create(const AHandle: Pointer; const ASize: Longword);
    destructor Destroy; override;
  end;
         *)
{ TTexture }

constructor TTexture.Create(const AHandle: IDirect3DTexture8;
  const AOriginalWidth, AOriginalHeight: Integer);
begin
  inherited Create;
  FHandle := AHandle;
  FOriginalWidth := AOriginalWidth;
  FOriginalHeight := AOriginalHeight;
end;

function TTexture.GetHandle: IDirect3DTexture8;
begin
  Result := FHandle;
end;

function TTexture.GetHeight(const Original: Boolean): Integer;
var
  Desc: TD3DSurfaceDesc;
begin
  if (Original) then
    Result := FOriginalHeight
  else if (Succeeded(FHandle.GetLevelDesc(0,Desc))) then
    Result := Desc.Height
  else
    Result := 0;
end;

function TTexture.GetWidth(const Original: Boolean): Integer;
var
  Desc: TD3DSurfaceDesc;
begin
  if (Original) then
    Result := FOriginalWidth
  else if (Succeeded(FHandle.GetLevelDesc(0,Desc))) then
    Result := Desc.Width
  else
    Result := 0;
end;

function TTexture.Lock(const ReadOnly: Boolean; const Left, Top, Width,
  Height: Integer): PLongword;
var
  Desc: TD3DSurfaceDesc;
  Rect: TD3DLockedRect;
  Region: TRect;
  PRec: PRect;
  Flags: Integer;
begin
  Result := nil;
  FHandle.GetLevelDesc(0,Desc);
  if (Desc.Format <> D3DFMT_A8R8G8B8) and (Desc.Format <> D3DFMT_X8R8G8B8) then
    Exit;

  if (Width <> 0) and (Height <> 0) then begin
    Region.Left := Left;
    Region.Top := Top;
    Region.Right := Left + Width;
    Region.Bottom := Top + Height;
    PRec := @Region;
  end else
    PRec := nil;

  if (ReadOnly) then
    Flags := D3DLOCK_READONLY
  else
    Flags := 0;

  if (Failed(FHandle.LockRect(0,Rect,PRec,Flags))) then
    PHGE.PostError('Can''t lock texture')
  else
    Result := Rect.pBits;
end;

procedure TTexture.SetHandle(const Value: IDirect3DTexture8);
begin
  FHandle := Value;
end;

procedure TTexture.Unlock;
begin
  FHandle.UnlockRect(0);
end;

{ TChannel }
(*
constructor TChannel.Create(const AHandle: HChannel);
begin
  inherited Create;
  FHandle := AHandle;
end;

destructor TChannel.Destroy;
begin
  FHandle := 0;
  inherited;
end;

function TChannel.GetHandle: HChannel;
begin
  Result := FHandle;
end;

function TChannel.GetLength: Single;
begin
  if (PHGE.FBass <> 0) then
    Result := BASS_ChannelBytes2Seconds(FHandle,BASS_ChannelGetLength(FHandle))
  else
    Result := -1;
end;

function TChannel.GetPos: Single;
begin
  if (PHGE.FBass <> 0) then
    Result := BASS_ChannelBytes2Seconds(FHandle,BASS_ChannelGetPosition(FHandle))
  else
    Result := -1;
end;

function TChannel.IsPlaying: Boolean;
begin
  if (PHGE.FBass <> 0) then
    Result := (BASS_ChannelIsActive(FHandle) = BASS_ACTIVE_PLAYING)
  else
    Result := False;
end;

function TChannel.IsSliding: Boolean;
begin
  if (PHGE.FBass <> 0) then
    Result := (BASS_ChannelIsSliding(FHandle) <> 0)
  else
    Result := False;
end;

procedure TChannel.Pause;
begin
  if (PHGE.FBass <> 0) then
    BASS_ChannelPause(FHandle);
end;

procedure TChannel.Resume;
begin
  if (PHGE.FBass <> 0) then
    BASS_ChannelPlay(FHandle,False);
end;

procedure TChannel.SetHandle(const Value: HChannel);
begin
  FHandle := Value;
end;

procedure TChannel.SetPanning(const Pan: Integer);
begin
  if (PHGE.FBass <> 0) then
    BASS_ChannelSetAttributes(FHandle,-1,-1,Pan);
end;

procedure TChannel.SetPitch(const Pitch: Single);
var
  Info: BASS_CHANNELINFO;
begin
  if (PHGE.FBass <> 0) then begin
    BASS_ChannelGetInfo(FHandle,Info);
    BASS_ChannelSetAttributes(FHandle,Trunc(Pitch * Info.freq),-1,-101);
  end;
end;

procedure TChannel.SetPos(const Seconds: Single);
begin
  if (PHGE.FBass <> 0) then
    BASS_ChannelSetPosition(FHandle,BASS_ChannelSeconds2Bytes(FHandle,Seconds));
end;

procedure TChannel.SetVolume(const Volume: Integer);
begin
  if (PHGE.FBass <> 0) then
    BASS_ChannelSetAttributes(FHandle,-1,Volume,-101);
end;

procedure TChannel.SlideTo(const Time: Single; const Volume, Pan: Integer;
  const Pitch: Single);
var
  Freq: Integer;
  Info: BASS_CHANNELINFO;
begin
  if (PHGE.FBass <> 0) then begin
    BASS_ChannelGetInfo(FHandle,Info);
    if (Pitch = -1) then
      Freq := -1
    else
      Freq := Trunc(Pitch * Info.Freq);
    BASS_ChannelSlideAttributes(FHandle,Freq,Volume,Pan,Trunc(Time * 1000));
  end;
end;

procedure TChannel.Stop;
begin
  if (PHGE.FBass <> 0) then
    BASS_ChannelStop(FHandle);
end;

{ TEffect }

constructor TEffect.Create(const AHandle: HSample);
begin
  inherited Create;
  FHandle := AHandle;
  FChannel := TChannel.Create(0);
end;

destructor TEffect.Destroy;
begin
  if (PHGE.FBass <> 0) then
    BASS_SampleFree(FHandle);
  FHandle := 0;
  inherited;
end;

function TEffect.GetHandle: HSample;
begin
  Result := FHandle;
end;

function TEffect.Play: IChannel;
begin
  if (PHGE.FBass <> 0) then begin
    FChannel.SetHandle(BASS_SampleGetChannel(FHandle,False));
    BASS_ChannelPlay(FChannel.Handle,True);
    Result := FChannel;
  end else
    Result := nil;
end;

function TEffect.PlayEx(const Volume, Pan: Integer; const Pitch: Single;
  const Loop: Boolean): IChannel;
var
  Info: BASS_SAMPLE;
  HC: HChannel;
begin
  if (PHGE.FBass <> 0) then begin
    BASS_SampleGetInfo(FHandle,Info);
    HC := BASS_SampleGetChannel(FHandle,False);
    FChannel.SetHandle(HC);
    BASS_ChannelSetAttributes(HC,Trunc(Pitch * Info.freq),Volume,Pan);
    Info.flags := Info.flags and (not BASS_SAMPLE_LOOP);
    if (Loop) then
      Info.flags := Info.flags or BASS_SAMPLE_LOOP;
    BASS_ChannelSetFlags(HC,Info.Flags);
    BASS_ChannelPlay(HC,True);
    Result := FChannel;
  end else
    Result := nil;
end;

{ TMusic }

destructor TMusic.Destroy;
begin
  if (PHGE.FBass <> 0) then
    BASS_MusicFree(FHandle);
  inherited;
end;

function TMusic.GetAmplification: Integer;
begin
  if (PHGE.FBass <> 0) then
    Result := BASS_MusicGetAttribute(FHandle,BASS_MUSIC_ATTRIB_AMPLIFY)
  else
    Result := -1;
end;

function TMusic.GetChannelVolume(const Channel: Integer): Integer;
begin
  if (PHGE.FBass <> 0) then
    Result := BASS_MusicGetAttribute(FHandle,BASS_MUSIC_ATTRIB_VOL_CHAN + Channel)
  else
    Result := -1;
end;

function TMusic.GetInstrVolume(const Instr: Integer): Integer;
begin
  if (PHGE.FBass <> 0) then
    Result := BASS_MusicGetAttribute(FHandle,BASS_MUSIC_ATTRIB_VOL_INST + Instr)
  else
    Result := -1;
end;

function TMusic.MusicGetLength: Integer;
begin
  if (PHGE.FBass <> 0) then
    Result := BASS_MusicGetOrders(FHandle)
  else
    Result := -1;
end;

function TMusic.MusicGetPos(out Order, Row: Integer): Boolean;
var
  Pos: Integer;
begin
  Result := False;
  if (PHGE.FBass <> 0) then begin
    Pos := BASS_MusicGetOrderPosition(FHandle);
    if (Pos <> -1) then begin
      Order := LOWORD(Pos);
      Row := HIWORD(Pos);
      Result := True;
    end;
  end;
end;

procedure TMusic.MusicSetPos(const Order, Row: Integer);
begin
  if (PHGE.FBass <> 0) then
    BASS_ChannelSetPosition(FHandle,MAKEMUSICPOS(Order,Row));
end;

function TMusic.Play(const Loop: Boolean; const Volume: Integer = 100;
  const Order: Integer = -1; const Row: Integer = -1): IChannel;
var
  Info: BASS_CHANNELINFO;
  Pos, O, R: Integer;
begin
  if (PHGE.FBass <> 0) then begin
    Pos := BASS_MusicGetOrderPosition(FHandle);
    if (Order = -1) then
      O := LOWORD(Pos)
    else
      O := Order;
    if (Row = -1) then
      R := HIWORD(Pos)
    else
      R := Row;
    BASS_ChannelSetPosition(FHandle,MAKEMUSICPOS(O,R));

    BASS_ChannelGetInfo(FHandle,Info);
    BASS_ChannelSetAttributes(FHandle,Info.freq,Volume,0);

    Info.flags := Info.flags and (not BASS_SAMPLE_LOOP);
    if (Loop) then
      Info.flags := Info.flags or BASS_SAMPLE_LOOP;

    BASS_ChannelSetFlags(FHandle,Info.flags);
    BASS_ChannelPlay(FHandle,False);
    Result := Self;
  end else
    Result := nil;
end;

procedure TMusic.SetChannelVolume(const Channel, Volume: Integer);
begin
  if (PHGE.FBass <> 0) then
    BASS_MusicSetAttribute(FHandle,BASS_MUSIC_ATTRIB_VOL_CHAN + Channel,Volume);
end;

procedure TMusic.SetInstrVolume(const Instr, Volume: Integer);
begin
  if (PHGE.FBass <> 0) then
    BASS_MusicSetAttribute(FHandle,BASS_MUSIC_ATTRIB_VOL_INST + Instr,Volume);
end;
            *)
{ TTarget }

constructor TTarget.Create(const AWidth, AHeight: Integer; const ATex: ITexture;
  const ADepth: IDirect3DSurface8);
begin
  inherited Create;
  FWidth := AWidth;
  FHeight := AHeight;
  FTex := ATex;
  FDepth := ADepth;
  PHGE.FTargets.Add(Self);
end;

destructor TTarget.Destroy;
begin
  PHGE.FTargets.Remove(Self);
  inherited;
end;

function TTarget.GetDepth: IDirect3DSurface8;
begin
  Result := FDepth;
end;

function TTarget.GetHeight: Integer;
begin
  Result := FHeight;
end;

function TTarget.GetTex: ITexture;
begin
  Result := FTex;
end;

function TTarget.GetTexture: ITexture;
begin
  Result := FTex;
end;

function TTarget.GetWidth: Integer;
begin
  Result := FWidth;
end;

procedure TTarget.Lost;
var
  DXTexture: IDirect3DTexture8;
begin
  if Assigned(FTex) then begin
    D3DXCreateTexture(PHGE.FD3DDevice,FWidth,FHeight,1,
      D3DUSAGE_RENDERTARGET,PHGE.FD3DPP.BackBufferFormat,D3DPOOL_DEFAULT,
      DXTexture);
    FTex.Handle := DXTexture;
  end;
  if Assigned(FDepth) then
    PHGE.FD3DDevice.CreateDepthStencilSurface(FWidth,FHeight,
      D3DFMT_D16,D3DMULTISAMPLE_NONE,FDepth);
end;

procedure TTarget.Restore;
begin
  FTex := nil;
  FDepth := nil;
end;

{ TStream }
 (*
constructor TStream.Create(const AHandle: HStream; const AData: IResource);
begin
  inherited Create(AHandle);
  FData := AData;
end;

destructor TStream.Destroy;
begin
  if (PHGE.FBass <> 0) then
    BASS_StreamFree(FHandle);
  inherited;
end;

function TStream.GetData: IResource;
begin
  Result := FData;
end;

function TStream.Play(const Loop: Boolean; const Volume: Integer): IChannel;
var
  Info: BASS_CHANNELINFO;
begin
  if (PHGE.FBass <> 0) then begin
    BASS_ChannelGetInfo(FHandle,Info);
    BASS_ChannelSetAttributes(FHandle,Info.freq,Volume,0);
    Info.flags := Info.flags and (not BASS_SAMPLE_LOOP);
    if (Loop) then
      Info.flags := Info.flags or BASS_SAMPLE_LOOP;
    BASS_ChannelSetFlags(FHandle,Info.Flags);
    BASS_ChannelPlay(FHandle,True);
    Result := Self;
  end else
    Result := nil;
end;

{ TResource }

constructor TResource.Create(const AHandle: Pointer; const ASize: Longword);
begin
  inherited Create;
  FHandle := AHandle;
  FSize := ASize;
end;

destructor TResource.Destroy;
begin
  FreeMem(FHandle);
  inherited;
end;

function TResource.GetHandle: Pointer;
begin
  Result := FHandle;
end;

function TResource.GetSize: Longword;
begin
  Result := FSize;
end;
          *)
(****************************************************************************
 * System.cpp, Graphics.cpp, Random.cpp, Sound.cpp, Timer.cpp, Input.cpp,
 * Resource.cpp
 ****************************************************************************)

const
  KeyNames: array [0..255] of String = (
    '?',
    'Left Mouse Button', 'Right Mouse Button', '?', 'Middle Mouse Button',
    '?', '?', '?', 'Backspace', 'Tab', '?', '?', '?', 'Enter', '?', '?',
    'Shift', 'Ctrl', 'Alt', 'Pause', 'Caps Lock', '?', '?', '?', '?', '?', '?',
    'Escape', '?', '?', '?', '?',
    'Space', 'Page Up', 'Page Down', 'End', 'Home',
    'Left Arrow', 'Up Arrow', 'Right Arrow', 'Down Arrow',
    '?', '?', '?', '?', 'Insert', 'Delete', '?',
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    '?', '?', '?', '?', '?', '?', '?',
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    'Left Win', 'Right Win', 'Application', '?', '?',
    'NumPad 0', 'NumPad 1', 'NumPad 2', 'NumPad 3', 'NumPad 4',
    'NumPad 5', 'NumPad 6', 'NumPad 7', 'NumPad 8', 'NumPad 9',
    'Multiply', 'Add', '?', 'Subtract', 'Decimal', 'Divide',
    'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    'Num Lock', 'Scroll Lock',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    'Semicolon', 'Equals', 'Comma', 'Minus', 'Period', 'Slash', 'Grave',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    '?', '?', '?', '?', '?', '?',
    'Left bracket', 'Backslash', 'Right bracket', 'Apostrophe',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    '?', '?', '?', '?', '?', '?', '?', '?', '?', '?',
    '?', '?', '?');

var
  GSeed: Longword = 0;

function LoWordInt(const N: Longword): Integer; inline;
begin
  Result := Smallint(LoWord(N));
end;

function HiWordInt(const N: Longword): Integer; inline;
begin
  Result := Smallint(HiWord(N));
end;

const
  WINDOW_CLASS_NAME = 'HGE__WNDCLASS';

function WindowProc(HWindow: HWnd; Msg, WParam, LParam: Longint): Longint; stdcall;
begin
  case Msg of
    WM_CREATE:
      begin
        Result := 0;
        Exit;
      end;
    WM_PAINT:
      begin
        if Assigned(PHGE.FProcRenderFunc) then
          PHGE.FProcFrameFunc;
      end;
    WM_DESTROY:
      begin
        PostQuitMessage(0);
        Result := 0;
        Exit;
      end;
    WM_ACTIVATEAPP:
      begin
        if Assigned(PHGE.FD3D) and (PHGE.FActive <> (WParam = 1)) then
          PHGE.FocusChange(WParam = 1);
        Result := 0;
        Exit;
      end;
    WM_SETCURSOR:
      begin
        if (PHGE.FActive or (PHGE.FWndParent <> 0)) and (LoWord(LParam) = HTCLIENT) and (PHGE.FHideMouse) then
          SetCursor(0)
        else
          SetCursor(LoadCursor(0,IDC_ARROW));
        Result := 0;
        Exit;
      end;
    WM_SYSKEYDOWN:
      begin
        if (WParam = VK_F4) then begin
          if Assigned(PHGE.FProcExitFunc) then begin
            if (PHGE.FProcExitFunc) then
              Result := DefWindowProc(HWindow,Msg,WParam,LParam)
            else
              Result := 0;
          end else
            Result :=DefWindowProc(HWindow,Msg,WParam,LParam);
        end else if (WParam = VK_RETURN) then begin
          PHGE.System_SetState(HGE_WINDOWED, not PHGE.System_GetState(HGE_WINDOWED));
          Result := 0;
        end else begin
          if ((LParam and $4000000) <> 0) then
            PHGE.BuildEvent(INPUT_KEYDOWN,WParam,HiWord(LParam) and $FF,HGEINP_REPEAT,-1,-1)
          else
            PHGE.BuildEvent(INPUT_KEYDOWN,WParam,HiWord(LParam) and $FF,0,-1,-1);
          Result := 0;
        end;
        Exit;
      end;
    WM_KEYDOWN:
      begin
        if ((LParam and $4000000) <> 0) then
          PHGE.BuildEvent(INPUT_KEYDOWN,WParam,HiWord(LParam) and $FF,HGEINP_REPEAT,-1,-1)
        else
          PHGE.BuildEvent(INPUT_KEYDOWN,WParam,HiWord(LParam) and $FF,0,-1,-1);
        Result := 0;
        Exit;
      end;
    WM_SYSKEYUP:
      begin
        PHGE.BuildEvent(INPUT_KEYUP,WParam,HiWord(LParam) and $FF,0,-1,-1);
        Result := 0;
        Exit;
      end;
    WM_KEYUP:
      begin
        PHGE.BuildEvent(INPUT_KEYUP,WParam,HiWord(LParam) and $FF,0,-1,-1);
        Result := 0;
        Exit;
      end;
    WM_LBUTTONDOWN:
      begin
        SetFocus(HWindow);
        PHGE.BuildEvent(INPUT_MBUTTONDOWN,HGEK_LBUTTON,0,0,LoWordInt(LParam),HiWordInt(LParam));
        Result := 0;
        Exit;
      end;
    WM_MBUTTONDOWN:
      begin
        SetFocus(HWindow);
        PHGE.BuildEvent(INPUT_MBUTTONDOWN,HGEK_MBUTTON,0,0,LoWordInt(LParam),HiWordInt(LParam));
        Result := 0;
        Exit;
      end;
    WM_RBUTTONDOWN:
      begin
        SetFocus(HWindow);
        PHGE.BuildEvent(INPUT_MBUTTONDOWN,HGEK_RBUTTON,0,0,LoWordInt(LParam),HiWordInt(LParam));
        Result := 0;
        Exit;
      end;
    WM_LBUTTONDBLCLK:
      begin
        PHGE.BuildEvent(INPUT_MBUTTONDOWN,HGEK_LBUTTON,0,HGEINP_REPEAT,LoWordInt(LParam),HiWordInt(LParam));
        Result := 0;
        Exit;
      end;
    WM_MBUTTONDBLCLK:
      begin
        PHGE.BuildEvent(INPUT_MBUTTONDOWN,HGEK_MBUTTON,0,HGEINP_REPEAT,LoWordInt(LParam),HiWordInt(LParam));
        Result := 0;
        Exit;
      end;
    WM_RBUTTONDBLCLK:
      begin
        PHGE.BuildEvent(INPUT_MBUTTONDOWN,HGEK_RBUTTON,0,HGEINP_REPEAT,LoWordInt(LParam),HiWordInt(LParam));
        Result := 0;
        Exit;
      end;
    WM_LBUTTONUP:
      begin
        PHGE.BuildEvent(INPUT_MBUTTONUP,HGEK_LBUTTON,0,0,LoWordInt(LParam),HiWordInt(LParam));
        Result := 0;
        Exit;
      end;
    WM_MBUTTONUP:
      begin
        PHGE.BuildEvent(INPUT_MBUTTONUP,HGEK_MBUTTON,0,0,LoWordInt(LParam),HiWordInt(LParam));
        Result := 0;
        Exit;
      end;
    WM_RBUTTONUP:
      begin
        PHGE.BuildEvent(INPUT_MBUTTONUP,HGEK_RBUTTON,0,0,LoWordInt(LParam),HiWordInt(LParam));
        Result := 0;
        Exit;
      end;
    WM_MOUSEMOVE:
      begin
        PHGE.BuildEvent(INPUT_MOUSEMOVE,0,0,0,LoWordInt(LParam),HiWordInt(LParam));
        Result := 0;
        Exit;
      end;
    WM_MOUSEWHEEL:
      begin
        PHGE.BuildEvent(INPUT_MOUSEWHEEL,Smallint(HiWord(WParam)) div 120,0,0,LoWordInt(LParam),HiWordInt(LParam));
        Result := 0;
        Exit;
      end;
    WM_SIZE:
      begin
        if (WParam = SIZE_RESTORED) then
          PHGE.Resize(LoWord(LParam),HiWord(LParam));
      end;
    WM_SYSCOMMAND:
      begin
        if (WParam = SC_CLOSE) then begin
          if Assigned(PHGE.FProcExitFunc) then begin
            if (PHGE.FProcExitFunc) then begin
              PHGE.FActive := False;
              Result := DefWindowProc(HWindow,Msg,WParam,LParam);
              Exit;
            end else begin
              Result := 0;
              Exit;
            end;
          end else begin
            PHGE.FActive := False;
            Result := DefWindowProc(HWindow,Msg,WParam,LParam);
            Exit;
          end;
        end;
      end;
  end;
  Result := DefWindowProc(HWindow,Msg,WParam,LParam);
end;

function HGECreate(const Ver: Integer): IHGE;
begin
  if (Ver = HGE_VERSION) then
    Result := THGEImpl.InterfaceGet
  else
    Result := nil;
end;

{ THGEImpl }

procedure THGEImpl.AdjustWindow;
var
  Rc: PRect;
  Style: Longword;
begin
  if (FWindowed) then begin
    Rc := @FRectW;
    Style := FStyleW;
  end else begin
    Rc := @FRectFS;
    Style := FStyleFS;
  end;
  SetWindowLong(FWnd,GWL_STYLE,Style);

  Style := GetWindowLong(FWnd,GWL_EXSTYLE);
  if (FWindowed) then begin
    SetWindowLong(FWnd,GWL_EXSTYLE,Style and (not WS_EX_TOPMOST));
    SetWindowPos(FWnd,HWND_NOTOPMOST,Rc.Left,Rc.Top,
      Rc.Right - Rc.Left,Rc.Bottom - Rc.Top,SWP_FRAMECHANGED);
  end else begin
    SetWindowLong(FWnd,GWL_EXSTYLE,Style or WS_EX_TOPMOST);
    SetWindowPos(FWnd,HWND_TOPMOST,Rc.Left,Rc.Top,
      Rc.Right - Rc.Left,Rc.Bottom - Rc.Top,SWP_FRAMECHANGED);
  end;
end;

procedure THGEImpl.BuildEvent(EventType, Key, Scan, Flags, X, Y: Integer);
var
  Last, EPtr: PInputEventList;
  KBState: TKeyboardState;
  Pt: TPoint;
begin
  New(EPtr);
  EPtr.Event.EventType := EventType;
  EPtr.Event.Chr := 0;
  Pt.X := X; Pt.Y := Y;

  GetKeyboardState(KBState);

  if (EventType = HGE.INPUT_KEYDOWN) then begin
    if ((Flags and HGEINP_REPEAT) = 0) then
      FKeyz[Key] := FKeyz[Key] or 1;
    ToAscii(Key,Scan,KBstate,@EPtr.Event.Chr,0);
  end;

  if (EventType = HGE.INPUT_KEYUP) then begin
    FKeyz[Key] := FKeyz[Key] or 2;
    ToAscii(Key,Scan,KBstate,@EPtr.Event.Chr,0);
  end;

  if (EventType = INPUT_MOUSEWHEEL) then begin
    EPtr.Event.Key := 0;
    EPtr.Event.Wheel := Key;
    ScreenToClient(FWnd,Pt);
  end else begin
    EPtr.Event.Key := Key;
    EPtr.Event.Wheel := 0;
  end;

  if (EventType = INPUT_MBUTTONDOWN) then begin
    FKeyz[Key] := FKeyz[Key] or 1;
    SetCapture(FWnd);
    FCaptured := True;
  end;
  if (EventType = INPUT_MBUTTONUP) then begin
    FKeyz[Key] := FKeyz[Key] or 2;
    ReleaseCapture;
    Input_SetMousePos(FXPos,FYPos);
    Pt.X := Trunc(FXPos);
    Pt.Y := Trunc(FYPos);
    FCaptured := False;
  end;

  if ((KBState[VK_SHIFT] and $80) <> 0) then
    Flags := Flags or HGEINP_SHIFT;
  if ((KBState[VK_CONTROL] and $80) <> 0) then
    Flags := Flags or HGEINP_CTRL;
  if ((KBState[VK_MENU] and $80) <> 0) then
    Flags := Flags or HGEINP_ALT;
  if ((KBState[VK_CAPITAL] and $1) <> 0) then
    Flags := Flags or HGEINP_CAPSLOCK;
  if ((KBState[VK_SCROLL] and $1) <> 0) then
    Flags := Flags or HGEINP_SCROLLLOCK;
  if ((KBState[VK_NUMLOCK] and $1) <> 0) then
    Flags := Flags or HGEINP_NUMLOCK;
  EPtr.Event.Flags := Flags;

  if (Pt.X = -1) then begin
    EPtr.Event.X := FXPos;
    EPtr.Event.Y := FYPos;
  end else begin
    if (Pt.X < 0) then
      Pt.X := 0;
    if (Pt.Y < 0) then
      Pt.Y := 0;
    if (Pt.X >= FScreenWidth) then
      Pt.X := FScreenWidth - 1;
    if (Pt.Y >= FScreenHeight) then
      Pt.Y := FScreenHeight - 1;

    EPtr.Event.X := Pt.X;
    EPtr.Event.Y := Pt.Y;
  end;

  EPtr.Next := nil;

  if (FQueue = nil) then
    FQueue := EPtr
  else begin
    Last := FQueue;
    while Assigned(Last.Next) do
      Last := Last.Next;
    Last.Next := EPtr;
  end;

  if (EPtr.Event.EventType = HGE.INPUT_KEYDOWN) or (EPtr.Event.EventType = INPUT_MBUTTONDOWN) then begin
    FVKey := EPtr.Event.Key;
    FChar := EPtr.Event.Chr;
  end else if (EPtr.Event.EventType = INPUT_MOUSEMOVE) then begin
    FXPos := EPtr.Event.X;
    FYPos := EPtr.Event.Y;
  end else if (EPtr.Event.EventType = INPUT_MOUSEWHEEL) then
    Inc(FZPos,EPtr.Event.Wheel);
end;
 (*
function THGEImpl.Channel_GetLength(const Chn: IChannel): Single;
begin
  Result := Chn.GetLength;
end;

function THGEImpl.Channel_GetPos(const Chn: IChannel): Single;
begin
  Result := Chn.GetPos;
end;

function THGEImpl.Channel_IsPlaying(const Chn: IChannel): Boolean;
begin
  Result := Chn.IsPlaying;
end;

function THGEImpl.Channel_IsSliding(const Channel: IChannel): Boolean;
begin
  Result := Channel.IsSliding;
end;

procedure THGEImpl.Channel_Pause(const Chn: IChannel);
begin
  Chn.Pause;
end;

procedure THGEImpl.Channel_PauseAll;
begin
  if (FBass <> 0) then 
    BASS_Pause;
end;

procedure THGEImpl.Channel_Resume(const Chn: IChannel);
begin
  Chn.Resume;
end;

procedure THGEImpl.Channel_ResumeAll;
begin
  if (FBass <> 0) then 
    BASS_Start;
end;

procedure THGEImpl.Channel_SetPanning(const Chn: IChannel; const Pan: Integer);
begin
  Chn.SetPanning(Pan);
end;

procedure THGEImpl.Channel_SetPitch(const Chn: IChannel; const Pitch: Single);
begin
  Chn.SetPitch(Pitch);
end;

procedure THGEImpl.Channel_SetPos(const Chn: IChannel; const Seconds: Single);
begin
  Chn.SetPos(Seconds);
end;

procedure THGEImpl.Channel_SetVolume(const Chn: IChannel;
  const Volume: Integer);
begin
  Chn.SetVolume(Volume);
end;

procedure THGEImpl.Channel_SlideTo(const Channel: IChannel; const Time: Single;
  const Volume, Pan: Integer; const Pitch: Single);
begin
  Channel.SlideTo(Time,Volume,Pan,Pitch);
end;

procedure THGEImpl.Channel_Stop(const Chn: IChannel);
begin
  Chn.Stop;
end;

procedure THGEImpl.Channel_StopAll;
begin
  if (FBass <> 0) then begin
    BASS_Stop;
    BASS_Start;
  end;
end;             *)

procedure THGEImpl.ClearQueue;
var
  NextEPtr, EPtr: PInputEventList;
begin
  FillChar(FKeyz,SizeOf(FKeyz),0);
  EPtr := FQueue;
  while Assigned(EPtr) do begin
    NextEPtr := EPtr.Next;
    Dispose(EPtr);
    EPtr := NextEPtr;
  end;

  FQueue := nil;
  FVKey := 0;
  FChar := 0;
  FZPos := 0;
end;

procedure THGEImpl.CopyVertices(pVertices: PByte; numVertices: integer);
var
  pVB: PByte;
begin
  FD3DDevice.SetVertexShader(D3DFVF_HGEVERTEX);
  FVB.Lock(0, SizeOf( THGEVertex) * numVertices, pVB, D3DLOCK_DISCARD);
  Move(pVertices^, pVB^, Sizeof( THGEVertex) * numVertices);
  FVB.Unlock;
  FD3DDevice.SetStreamSource(0, FVB, Sizeof( THGEVertex));
end;

constructor THGEImpl.Create;
var
  P: array [0..MAX_PATH] of Char;
begin
  inherited;
  FInstance := GetModuleHandle(nil);
  FActive := False;
  FHGEFPS := HGEFPS_UNLIMITED;
  FWinTitle := 'HGE';
  FScreenWidth := 800;
  FScreenHeight := 600;
  FScreenBPP := 32;
  FTextureFilter := True;
  FUseSound := True;
  {FSampleRate := 44100;
  FFXVolume := 100;
  FMusVolume := 100;  }
  FHideMouse := True;
  FHardwareTL := True;
  FZBuffer := False;
  GetModuleFileName(FInstance,P,MAX_PATH);
  FAppPath := ExtractFilePath(P);
  FSearch.FindHandle := INVALID_HANDLE_VALUE;
  FTargets := TList.Create;
  GetLocaleFormatSettings(GetThreadLocale,FFormatSettings);
  FFormatSettings.DecimalSeparator := '.';
  FFormatSettings.ThousandSeparator := ',';

  FProcFrameFunc := nil;
  FProcRenderFunc := nil;
  FProcFocusLostFunc := nil;
  FProcFocusGainFunc := nil;
  FProcGfxRestoreFunc := nil;
  FProcExitFunc := nil;
  FOnFinalize := nil;
  FOnInitialize := nil;
  FOnNotifyEvent := nil;
end;

destructor THGEImpl.Destroy;
begin
  if (FWnd <> 0) then begin
    System_Shutdown;
    //Resource_RemoveAllPacks;
    PHGE := nil;
  end;
  FTargets.Free;
  inherited;
end;
(*
function THGEImpl.Effect_Load(const Data: Pointer; const Size: Longword): IEffect;
var
  Length, Samples: Longword;
  HS: HSample;
  HStrm: HStream;
  Info: BASS_CHANNELINFO;
  Buffer: Pointer;
begin
  if (FBass <> 0) then begin
    if (FSilent) then begin
      Result := nil;
      Exit;
    end;

    HS := BASS_SampleLoad(True,Data,0,Size,4,BASS_SAMPLE_OVER_VOL);
    if (HS = 0) then begin
      HStrm := BASS_StreamCreateFile(True,Data,0,Size,BASS_STREAM_DECODE);
      if (HStrm <> 0) then begin
        Length := BASS_ChannelGetLength(HStrm);
        BASS_ChannelGetInfo(hstrm, &info);
        Samples := Length;
        if (Info.chans < 2) then
          Samples := Samples shr 1;
        if ((Info.flags and BASS_SAMPLE_8BITS) = 0) then
          Samples := Samples shr 1;
        Buffer := BASS_SampleCreate(Samples,Info.freq,2,4,Info.flags or BASS_SAMPLE_OVER_VOL);
        if (Buffer = nil) then begin
          BASS_StreamFree(HStrm);
          PostError('Can''t create sound effect: Not enough memory');
        end else begin
          BASS_ChannelGetData(HStrm,Buffer,Length);
          HS := BASS_SampleCreateDone;
          BASS_StreamFree(HStrm);
          if (HS = 0) then
            PostError('Can''t create sound effect');
        end;
      end;
    end;
    Result := TEffect.Create(HS);
  end else
    Result := nil;
end;

function THGEImpl.Effect_Load(const Filename: String): IEffect;
var
  Data: IResource;
  Size: Integer;
begin
  Data := Resource_Load(Filename,@Size);
  if (Data = nil) then
    Result := nil
  else begin
    Result := Effect_Load(Data.Handle,Size);
    Data := nil;
  end;
end;

function THGEImpl.Effect_Play(const Eff: IEffect): IChannel;
begin
  Result := Eff.Play;
end;

function THGEImpl.Effect_PlayEx(const Eff: IEffect; const Volume, Pan: Integer;
  const Pitch: Single; const Loop: Boolean): IChannel;
begin
  Result := Eff.PlayEx(Volume,Pan,Pitch,Loop);
end;
         *)
procedure THGEImpl.FocusChange(const Act: Boolean);
begin
  FActive := Act;
  if (FActive) then begin
    if Assigned(FProcFocusGainFunc) then
      FProcFocusGainFunc;
  end else begin
    if Assigned(FProcFocusLostFunc) then
      FProcFocusLostFunc;
  end;
end;

function THGEImpl.FormatId(const Fmt: TD3DFormat): Integer;
begin
  case Fmt of
    D3DFMT_R5G6B5:
      Result := 1;
    D3DFMT_X1R5G5B5:
      Result := 2;
    D3DFMT_A1R5G5B5:
      Result := 3;
    D3DFMT_X8R8G8B8:
      Result := 4;
    D3DFMT_A8R8G8B8:
      Result := 5;
  else
    Result := 0;
  end;
end;

function THGEImpl.GetCurPrimType: Integer;
begin
  Result := FCurPrimType;
end;

function THGEImpl.GetCurTexture: ITexture;
begin
  Result := FCurTexture;
end;

function THGEImpl.GetD3DDevice: IDirect3DDevice8;
begin
  Result := FD3DDevice;
end;

function THGEImpl.GetVertArray: PHGEVertexArray;
begin
  Result := FVertArray;
end;

procedure THGEImpl.GfxDone;
begin
  if Assigned(FOnFinalize) then
    FOnFinalize(Self);

  if Assigned(FOnNotifyEvent) then
    FOnNotifyEvent(Self, msgDeviceFinalize);

  FScreenSurf := nil;
  FScreenDepth := nil;
  FTargets.Clear;

  if Assigned(FIB) then begin
    FD3DDevice.SetIndices(nil,0);
    FIB := nil;
  end;
  if Assigned(FVB) then begin
    if Assigned(FVertArray) then begin
      FVB.Unlock;
      FVertArray := nil;
    end;
    FD3DDevice.SetStreamSource(0,nil,SizeOf(THGEVertex));
    FVB := nil;
  end;
  FD3DDevice := nil;
  FD3D := nil;
end;

function THGEImpl.GfxInit: Boolean;
const
  Formats: array [0..5] of String = (
    'UNKNOWN','R5G6B5','X1R5G5B5','A1R5G5B5','X8R8G8B8','A8R8G8B8');
var
  AdID: TD3DAdapterIdentifier8;
  Mode: TD3DDisplayMode;
  Format: TD3DFormat;
  NModes, I: Longword;
begin
  Result := False;
  Format := D3DFMT_UNKNOWN;

// Init D3D

  FD3D := Direct3DCreate8(D3D_SDK_VERSION); // 120 or D3D_SDK_VERSION
  if (FD3D = nil) then begin
    PostError('Can''t create D3D interface');
    Exit;
  end;

// Get adapter info

  FD3D.GetAdapterIdentifier(D3DADAPTER_DEFAULT,D3DENUM_NO_WHQL_LEVEL,AdID);
  System_Log('D3D Driver: %s',[AdID.Driver]);
  System_Log('Description: %s',[AdID.Description]);
  System_Log('Version: %d.%d.%d.%d',[
      HiWord(AdID.DriverVersionHighPart),
      LoWord(AdID.DriverVersionHighPart),
      HiWord(AdID.DriverVersionLowPart),
      LoWord(AdID.DriverVersionLowPart)]);

// Set up Windowed presentation parameters

  if(Failed(FD3D.GetAdapterDisplayMode(D3DADAPTER_DEFAULT,Mode)))
    or (Mode.Format =D3DFMT_UNKNOWN)
  then begin
    PostError('Can''t determine desktop video mode');
    if (FWindowed) then
      Exit;
  end;

  ZeroMemory(@FD3DPPW,SizeOf(FD3DPPW));

  FD3DPPW.BackBufferWidth  := FScreenWidth;
  FD3DPPW.BackBufferHeight := FScreenHeight;
  FD3DPPW.BackBufferFormat := Mode.Format;
  FD3DPPW.BackBufferCount  := 1;
  FD3DPPW.MultiSampleType  := D3DMULTISAMPLE_NONE;
  FD3DPPW.hDeviceWindow    := FWnd;
  FD3DPPW.Windowed         := True;

  if (FHGEFPS =HGEFPS_VSYNC) then
    FD3DPPW.SwapEffect := D3DSWAPEFFECT_COPY_VSYNC
  else
    FD3DPPW.SwapEffect := D3DSWAPEFFECT_COPY;

  if (FZBuffer) then begin
    FD3DPPW.EnableAutoDepthStencil := True;
    FD3DPPW.AutoDepthStencilFormat := D3DFMT_D16;
  end;

// Set up Full Screen presentation parameters

  NModes := FD3D.GetAdapterModeCount(D3DADAPTER_DEFAULT);
  for I := 0 to NModes - 1 do begin
    FD3D.EnumAdapterModes(D3DADAPTER_DEFAULT,I,Mode);
    if (Integer(Mode.Width) <> FScreenWidth) or (Integer(Mode.Height) <> FScreenHeight) then
      Continue;
    if (FScreenBPP =16) and (FormatId(Mode.Format) > FormatId(D3DFMT_A1R5G5B5)) then
      Continue;
    if (FormatId(Mode.Format) > FormatId(Format)) then
      Format := Mode.Format;
  end;
  if (Format = D3DFMT_UNKNOWN) then begin
    PostError('Can''t find appropriate full screen video mode');
    if (not FWindowed) then
      Exit;
  end;

  ZeroMemory(@FD3DPPFS,SizeOf(FD3DPPFS));

  FD3DPPFS.BackBufferWidth  := FScreenWidth;
  FD3DPPFS.BackBufferHeight := FScreenHeight;
  FD3DPPFS.BackBufferFormat := Format;
  FD3DPPFS.BackBufferCount  := 1;
  FD3DPPFS.MultiSampleType  := D3DMULTISAMPLE_NONE;
  FD3DPPFS.hDeviceWindow    := FWnd;
  FD3DPPFS.Windowed         := False;

  FD3DPPFS.SwapEffect       := D3DSWAPEFFECT_FLIP;
  FD3DPPFS.FullScreen_RefreshRateInHz := D3DPRESENT_RATE_DEFAULT;
  if (FHGEFPS =HGEFPS_VSYNC) then
    FD3DPPFS.FullScreen_PresentationInterval := D3DPRESENT_INTERVAL_ONE
  else
    FD3DPPFS.FullScreen_PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE;

   if (FZBuffer) then begin
    FD3DPPFS.EnableAutoDepthStencil := True;
    FD3DPPFS.AutoDepthStencilFormat := D3DFMT_D16;
  end;

  if (FWindowed) then
    FD3DPP := @FD3DPPW
  else
    FD3DPP := @FD3DPPFS;

  if (FormatId(FD3DPP.BackBufferFormat) < 4) then
    FScreenBPP := 16
  else
    FScreenBPP := 32;

// Create D3D Device

  if FHardwareTL then begin
    if (Failed(FD3D.CreateDevice(D3DADAPTER_DEFAULT,D3DDEVTYPE_HAL,FWnd, D3DCREATE_HARDWARE_VERTEXPROCESSING,FD3DPP^,FD3DDevice))) then begin
      PostError('Can''t create D3D device(HARDWARE)');
    end;
    if (Failed(FD3D.CreateDevice(D3DADAPTER_DEFAULT,D3DDEVTYPE_HAL,FWnd, D3DCREATE_SOFTWARE_VERTEXPROCESSING,FD3DPP^,FD3DDevice))) then begin
      PostError('Can''t create D3D device');
      Exit;
    end;
  end else begin
    if (Failed(FD3D.CreateDevice(D3DADAPTER_DEFAULT,D3DDEVTYPE_HAL,FWnd, D3DCREATE_SOFTWARE_VERTEXPROCESSING,FD3DPP^,FD3DDevice))) then begin
      PostError('Can''t create D3D device');
      Exit;
    end;
  end;

  {if (Failed(FD3D.CreateDevice(D3DADAPTER_DEFAULT,D3DDEVTYPE_HAL,FWnd,
    D3DCREATE_HARDWARE_VERTEXPROCESSING,FD3DPP^,FD3DDevice)))
  then begin
    PostError('Can''t create D3D device');
    Exit;
  end; }

  AdjustWindow;
  System_Log('Mode: %d x %d x %s' + CRLF,
    [FScreenWidth,FScreenHeight,Formats[FormatId(Format)]]);

// Create vertex batch buffer

  FVertArray := nil;

// Init all stuff that can be lost

  SetProjectionMatrix(FScreenWidth,FScreenHeight);
  D3DXMatrixIdentity(FMatView);

  if (not InitLost) then
    Exit;

  Gfx_Clear(0);

  Result := True;
end;

function THGEImpl.GfxRestore: Boolean;
var
  I: Integer;
  Target: TTarget;
begin
//  if(FD3DDevice.TestCooperativeLevel <> D3DERR_DEVICELOST) then
//    Exit;

  Result := False;
  if (FD3DDevice = nil) then
    Exit;
    
  FScreenSurf := nil;
  FScreenDepth := nil;

  for I := 0 to FTargets.Count - 1 do begin
    Target := TTarget(FTargets[I]);
    Target.Restore;
  end;

  if Assigned(FIB) then begin
    FD3DDevice.SetIndices(nil,0);
    FIB := nil;
  end;
  if Assigned(FVB) then begin
    FD3DDevice.SetStreamSource(0,nil,SizeOf(THGEVertex));
    FVB := nil;
  end;

  FD3DDevice.Reset(FD3DPP^);
  if (not InitLost) then
    Exit;

  if Assigned(FProcGfxRestoreFunc) then
    Result := FProcGfxRestoreFunc
  else
    Result := True;
end;


function THGEImpl.Gfx_BeginScene(const Target: ITarget): Boolean;
var
  Surf, Depth: IDirect3DSurface8;
  HR: HResult;
begin
  Result := False;

  HR := FD3DDevice.TestCooperativeLevel;
  if (HR = D3DERR_DEVICELOST) then
    Exit;
  if (HR = D3DERR_DEVICENOTRESET) then
    if (not GfxRestore) then
      Exit;

  if Assigned(FVertArray) then begin
    PostError('Gfx_BeginScene: Scene is already being rendered');
    Exit;
  end;

  if (Target <> FCurTarget) then begin
    if Assigned(Target) then begin
      Target.Tex.Handle.GetSurfaceLevel(0,Surf);
      Depth := (Target as IInternalTarget).Depth;
    end else begin
      Surf := FScreenSurf;
      Depth := FScreenDepth;
    end;
    if (Failed(FD3DDevice.SetRenderTarget(Surf,Depth))) then begin
      PostError('Gfx_BeginScene: Can''t set render target');
      Exit;
    end;
    if Assigned(Target) then begin
      Surf := nil;
      if Assigned((Target as IInternalTarget).Depth) then
        FD3DDevice.SetRenderState(D3DRS_ZENABLE,D3DZB_TRUE)
      else
        FD3DDevice.SetRenderState(D3DRS_ZENABLE,D3DZB_FALSE);
      SetProjectionMatrix(Target.Width,Target.Height);
    end else begin
      if (FZBuffer) then
        FD3DDevice.SetRenderState(D3DRS_ZENABLE,D3DZB_TRUE)
      else
        FD3DDevice.SetRenderState(D3DRS_ZENABLE,D3DZB_FALSE);
      SetProjectionMatrix(FScreenWidth,FScreenHeight);
    end;

    FD3DDevice.SetTransform(D3DTS_PROJECTION,FMatProj);
    D3DXMatrixIdentity(FMatView);
    FD3DDevice.SetTransform(D3DTS_VIEW,FMatView);

    FCurTarget := Target;
  end;
  FD3DDevice.BeginScene;
  FVB.Lock(0,0,PByte(FVertArray),0);
  Result := True;
end;

procedure THGEImpl.Gfx_Clear(const Color: Longword);
begin
  if Assigned(FCurTarget) then begin
    if Assigned((FCurTarget as IInternalTarget).Depth) then
      FD3DDevice.Clear(0,nil,D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER,Color,1.0,0)
    else
      FD3DDevice.Clear(0,nil,D3DCLEAR_TARGET,Color,1.0,0);
  end else begin
    if (FZBuffer) then
      FD3DDevice.Clear(0,nil,D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER,Color,1.0,0)
    else
      FD3DDevice.Clear(0,nil,D3DCLEAR_TARGET,Color,1.0,0);
  end;
end;

procedure THGEImpl.Gfx_EndScene;
begin
  RenderBatch(True);
  FD3DDevice.EndScene;
  if (FCurTarget = nil) then
    FD3DDevice.Present(nil,nil,0,nil);
end;

procedure THGEImpl.Gfx_FinishBatch(const NPrim: Integer);
begin
   FPrim := NPrim;
end;

procedure THGEImpl.Gfx_RenderArc(X, Y, Radius, StartRadius, EndRadius: Single; Color: Cardinal; DrawStartEnd, Filled: Boolean; BlendMode: Integer);
var
  Max, I: Integer;
  Ic, IInc: Single;
begin
  if Assigned(FVertArray) then begin
    if Radius > 1000 then
      Radius := 1000;

    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    Max := Round(Radius);
    IInc := 1 / Max;
    IInc := IInc * (EndRadius - StartRadius) * IRad;
    Ic := StartRadius * IRad;

    FVertArray[0].X := X;
    FVertArray[0].Y := Y;
    FVertArray[0].Col := Color;
    for I := 1 to Max + 1 do begin
      FVertArray[I].X := X + Radius * Cos(ic * TwoPI);
      FVertArray[I].Y := Y + Radius * Sin(ic * TwoPI);
      FVertArray[I].Col := Color;
      Ic := Ic + IInc;
    end;

    if DrawStartEnd then
      I := 0
    else
      I := 1;

    if (FCurTexture <> nil) then begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;

    if not Filled then begin
      FVertArray[0].X := FVertArray[Max + 1].X;
      FVertArray[0].Y := FVertArray[max + 1].Y;
      CopyVertices(@FVertArray^, Max + 2);
      FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, I, Max + (1 - I));
    end
    else begin
      CopyVertices(@FVertArray^, Max + 2);
      FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, Max);
    end;
  end;
end;

procedure THGEImpl.Gfx_RenderCircle(X, Y, Radius: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
var
  Max, I: Integer;
  Ic, IInc: Single;
begin
 if Assigned(FVertArray) then begin
    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    if Radius > 1000 then Radius := 1000;
    Max := Round(Radius);
    IInc := 1 / Max;
    Ic := 0;

    FVertArray[0].X := x;
    FVertArray[0].Y := y;
    FVertArray[0].col := Color;
    for I := 1 to Max + 1 do begin
      FVertArray[I].X := X + Radius * Cos(Ic * TwoPI);
      FVertArray[I].Y := Y + Radius * Sin(Ic * TwoPI);
      FVertArray[I].col := Color;
      Ic := Ic + IInc;
    end;

    if (FCurTexture <> nil) then begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;
    if not Filled then begin
      FVertArray[0].X := FVertArray[Max + 1].X;
      FVertArray[0].Y := FVertArray[Max + 1].Y;
      CopyVertices(@FVertArray^, Max + 2);
      FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, Max + 1);
    end
    else begin
      CopyVertices(@FVertArray^, Max + 2);
      FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, Max);
    end;
  end;
end;

procedure THGEImpl.Gfx_RenderEllipse(X, Y, R1, R2: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
var
  Max, I: Integer;
  Ic, IInc: Single;
begin
  if Assigned(FVertArray) then begin
    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    if R1 > 1000 then
      R1 := 1000;
    Max := Round(R1);
    IInc := 1 / Max;
    Ic := 0;
    
    FVertArray[0].X := X;
    FVertArray[0].Y := Y;
    FVertArray[0].Col := Color;
    for i := 1 to max + 1 do begin
      FVertArray[I].X := X + R1 * Cos(Ic * TwoPI);
      FVertArray[I].Y := y + R2 * Sin(Ic * TwoPI);
      FVertArray[I].Col := Color;
      Ic := Ic + IInc;
    end;


    if (FCurTexture <> nil) then begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;

    if not Filled then begin
      FVertArray[0].X := FVertArray[Max + 1].X;
      FVertArray[0].Y := FVertArray[Max + 1].Y;
      CopyVertices(@FVertArray^, Max + 2);
      FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, Max + 1);
    end
    else begin
      CopyVertices(@FVertArray^, Max + 2);
      FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, Max);
    end;
  end;
end;

procedure THGEImpl.Gfx_RenderLine(const X1, Y1, X2, Y2: Single;
  const Color: Longword; const Z: Single);
var
  I: Integer;
begin
  if Assigned(FVertArray) then begin
    if (FCurPrimType <> HGEPRIM_LINES)
      or (FPrim >= VERTEX_BUFFER_SIZE div HGEPRIM_LINES)
      or (FCurTexture <> nil) or (FCurBlendMode <> BLEND_DEFAULT)
    then begin
      RenderBatch;
      FCurPrimType := HGEPRIM_LINES;
      if (FCurBlendMode <> BLEND_DEFAULT) then
        SetBlendMode(BLEND_DEFAULT);
      if (FCurTexture <> nil) then begin
        FD3DDevice.SetTexture(0,nil);
        FCurTexture := nil;
      end;
    end;

    I := FPrim * HGEPRIM_LINES;
    FVertArray[I].X := X1; FVertArray[I+1].X := X2;
    FVertArray[I].Y := Y1; FVertArray[I+1].Y := Y2;
    FVertArray[I].Z     := Z;
    FVertArray[I+1].Z   := Z;
    FVertArray[I].Col   := Color;
    FVertArray[I+1].Col := Color;
    FVertArray[I].TX    := 0;
    FVertArray[I+1].TX  := 0;
    FVertArray[I].TY    := 0;
    FVertArray[I+1].TY  := 0;

    Inc(FPrim);
  end;
end;

procedure THGEImpl.Gfx_RenderLine2Color(X1, Y1, X2, Y2: Single; Color1, Color2: Cardinal; BlendMode: Integer);
begin
  if Assigned(FVertArray) then begin
    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    FVertArray[0].X := X1;
    FVertArray[0].Y := Y1;
    FVertArray[0].Col := Color1;
    FVertArray[1].X := X2;
    FVertArray[1].Y := Y2;
    FVertArray[1].Col := Color2;
    if (FCurTexture <> nil) then begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;
    CopyVertices(@FVertArray^, 2);
    FD3DDevice.DrawPrimitive(D3DPT_LINELIST, 0, 1);
  end;
end;

procedure THGEImpl.Gfx_RenderSquareSchedule(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; BlendMode: Integer = BLEND_DEFAULT);
var
  I: Integer;
begin
  if Assigned(FVertArray) then begin
    RenderBatch;
    FCurPrimType := HGEPRIM_TRIPLES;
    SetBlendMode(BlendMode);

    for I := 0 to NumPoints - 1 do begin
      FVertArray[I].X := Points[I].X;
      FVertArray[I].Y := PointS[I].Y;
      FVertArray[I].Col := Color;
    end;

    if (FCurTexture <> nil) then begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;

    CopyVertices(@FVertArray^, NumPoints);
    FD3DDevice.DrawPrimitive(D3DPT_TRIANGLELIST, 0, NumPoints div 3);
  end;
end;

procedure THGEImpl.Gfx_RenderPolygon(Points: array of TPoint; NumPoints: Integer; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
var
  I: Integer;
begin
  if Assigned(FVertArray) then begin
    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    for I := 0 to NumPoints - 1 do begin
      FVertArray[I].X := Points[I].X;
      FVertArray[I].Y := PointS[I].Y;
      FVertArray[I].Col := Color;
    end;

    if (FCurTexture <> nil) then begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;
    if Filled then begin
      CopyVertices(@FVertArray^, NumPoints);
      FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, NumPoints - 2);
    end
    else begin
      FVertArray[NumPoints].X := Points[0].X;
      FVertArray[NumPoints].y := Points[0].Y;
      FVertArray[NumPoints].Col := Color;
      CopyVertices(@FVertArray^, NumPoints + 1);
      FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, NumPoints);
    end;
  end;
end;

procedure THGEImpl.Gfx_RenderQuad(const Quad: THGEQuad);
begin
  if Assigned(FVertArray) then begin
    if (FCurPrimType <> HGEPRIM_QUADS)
      or (FPrim >= VERTEX_BUFFER_SIZE div HGEPRIM_QUADS)
      or (FCurTexture <> Quad.Tex)
      or (FCurBlendMode <> Quad.Blend)
    then begin
      RenderBatch;
      FCurPrimType := HGEPRIM_QUADS;
      if (FCurBlendMode <> Quad.Blend) then
        SetBlendMode(Quad.Blend);
      if (Quad.Tex <> FCurTexture) then begin
        if Assigned(Quad.Tex) then
          FD3DDevice.SetTexture(0,Quad.Tex.Handle)
        else
          FD3DDevice.SetTexture(0,nil);
        FCurTexture := Quad.Tex;
      end;
    end;

    Move(Quad.V,FVertArray[FPrim * HGEPRIM_QUADS], SizeOf(THGEVertex) * HGEPRIM_QUADS);
    Inc(FPrim);
  end;
end;

procedure THGEImpl.Gfx_RenderQuadrangle4Color(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single; Color1, Color2, Color3, Color4: Cardinal; Filled: Boolean; BlendMode: Integer);
begin
  if Assigned(FVertArray) then begin
    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    FVertArray[0].X := X1;
    FVertArray[0].Y := Y1;
    FVertArray[0].Col := Color1;
    FVertArray[1].X := X2;
    FVertArray[1].Y := Y2;
    FVertArray[1].Col := Color2;
    FVertArray[2].X := X3;
    FVertArray[2].Y := Y3;
    FVertArray[2].Col := Color3;
    FVertArray[3].X := X4;
    FVertArray[3].y := Y4;
    FVertArray[3].Col := Color4;

    
    if (FCurTexture <> nil) then begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;

    if Filled then begin
      CopyVertices(@FVertArray^, 4);
      FD3DDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, 2);
    end
    else begin
      FVertArray[4].X := X1;
      FVertArray[4].Y := Y1;
      FVertArray[4].Col := Color1;
      CopyVertices(@FVertArray^, 5);
      FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, 4);
    end;
  end;
end;

procedure THGEImpl.Gfx_RenderTriangle(X1, Y1, X2, Y2, X3, Y3: Single; Color: Cardinal; Filled: Boolean; BlendMode: Integer);
begin
  if Assigned(FVertArray) then begin
    RenderBatch;
    FCurPrimType := HGEPRIM_LINES;
    SetBlendMode(BlendMode);

    FVertArray[0].X := X1;
    FVertArray[0].Y := Y1;
    FVertArray[0].Col := Color;
    FVertArray[1].X := X2;
    FVertArray[1].y := Y2;
    FVertArray[1].Col := Color;
    FVertArray[2].X := X3;
    FVertArray[2].Y := Y3;
    FVertArray[2].Col := Color;


    if (FCurTexture <> nil) then begin
      FD3DDevice.SetTexture(0, nil);
      FCurTexture := nil;
    end;

    if Filled then begin
      CopyVertices(@FVertArray^, 3);
      FD3DDevice.DrawPrimitive(D3DPT_TRIANGLELIST, 0, 1);
    end
    else begin
      FVertArray[3].X := X1;
      FVertArray[3].Y := Y1;
      FVertArray[3].Col := Color;
      CopyVertices(@FVertArray^, 4);
      FD3DDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, 3);
    end;
  end;
end;

procedure THGEImpl.Gfx_RenderTriple(const Triple: THGETriple);
begin
  if Assigned(FVertArray) then begin
    if (FCurPrimType <> HGEPRIM_TRIPLES)
      or (FPrim >= VERTEX_BUFFER_SIZE div HGEPRIM_TRIPLES)
      or (FCurTexture <> Triple.Tex)
      or (FCurBlendMode <> Triple.Blend)
    then begin
      RenderBatch;
      FCurPrimType := HGEPRIM_TRIPLES;
      if (FCurBlendMode <> Triple.Blend) then
        SetBlendMode(Triple.Blend);
      if (Triple.Tex <> FCurTexture) then begin
        if Assigned(Triple.Tex) then
          FD3DDevice.SetTexture(0,Triple.Tex.Handle)
        else
          FD3DDevice.SetTexture(0,nil);
        FCurTexture := Triple.Tex;
      end;
    end;

    Move(Triple.V,FVertArray[FPrim * HGEPRIM_TRIPLES], SizeOf(THGEVertex) * HGEPRIM_TRIPLES);
    Inc(FPrim);
  end;
end;

procedure THGEImpl.Gfx_SetClipping(X, Y, W, H: Integer);
var
  VP: TD3DViewport8;
  ScrWidth, ScrHeight: Integer;
  Tmp: TD3DXMATRIX;
begin
  if (FCurTarget = nil) then begin
    ScrWidth := PHGE.System_GetState(HGE_SCREENWIDTH);
    ScrHeight := PHGE.System_GetState(HGE_SCREENHEIGHT);
  end else begin
    ScrWidth := Texture_GetWidth(FCurTarget.Tex);
    ScrHeight := Texture_GetHeight(FCurTarget.Tex);
  end;

  if (W = 0) then begin
    VP.X := 0;
    VP.Y := 0;
    VP.Width := ScrWidth;
    VP.Height := ScrHeight;
  end else begin
    if (X < 0) then begin
      Inc(W,X); X := 0;
    end;
    if (Y < 0) then begin
      Inc(H,Y); Y := 0;
    end;

    if (X + W > ScrWidth) then
      W := ScrWidth - X;
    if (Y + H > ScrHeight) then
      H := ScrHeight - Y;

    VP.X := X;
    VP.Y := Y;
    VP.Width := W;
    VP.Height := H;
  end;

  VP.MinZ := 0.0;
  VP.MaxZ := 1.0;

  RenderBatch;
  FD3DDevice.SetViewport(VP);

  D3DXMatrixScaling(FMatProj,1.0,-1.0,1.0);
  D3DXMatrixTranslation(Tmp,-0.5,+0.5,0.0);
  D3DXMatrixMultiply(FMatProj,FMatProj,Tmp);
  D3DXMatrixOrthoOffCenterLH(Tmp,VP.X,VP.X + VP.Width,-(VP.Y + VP.Height),
    -VP.Y,VP.MinZ,VP.MaxZ);
  D3DXMatrixMultiply(FMatProj,FMatProj,Tmp);
  FD3DDevice.SetTransform(D3DTS_PROJECTION,FMatProj);
end;

procedure THGEImpl.Gfx_SetTransform(const X, Y, DX, DY, Rot, HScale,
  VScale: Single);
var
  Tmp: TD3DXMATRIX;
begin
  if (VScale = 0.0) then
    D3DXMatrixIdentity(FMatView)
  else begin
    D3DXMatrixTranslation(FMatView,-X,-Y,0.0);
    D3DXMatrixScaling(Tmp,HScale,VScale,1.0);
    D3DXMatrixMultiply(FMatView,FMatView,Tmp);
    D3DXMatrixRotationZ(Tmp,-Rot);
    D3DXMatrixMultiply(FMatView,FMatView,Tmp);
    D3DXMatrixTranslation(Tmp,X + DX,Y + DY,0.0);
    D3DXMatrixMultiply(FMatView,FMatView,Tmp);
  end;

  RenderBatch;
  FD3DDevice.SetTransform(D3DTS_VIEW,FMatView);
end;

function THGEImpl.Gfx_StartBatch(const PrimType: Integer; const Tex: ITexture;
  const Blend: Integer; out MaxPrim: Integer): PHGEVertexArray;
begin
  if Assigned(FVertArray) then begin
    RenderBatch;

    FCurPrimType := PrimType;
    if (FCurBlendMode <> Blend) then
      SetBlendMode(Blend);
    if (Tex <> FCurTexture) then begin
      if Assigned(Tex) then
        FD3DDevice.SetTexture(0,Tex.Handle)
      else
        FD3DDevice.SetTexture(0,nil);
      FCurTexture := Tex;
    end;

    MaxPrim := VERTEX_BUFFER_SIZE div PrimType;
    Result := FVertArray;
  end else
    Result := nil;
end;

function THGEImpl.InitLost: Boolean;
var
  Target: TTarget;
  PIndices: PWord;
  N: Word;
  I: Integer;
begin
  Result := False;

// Store render target

  FScreenSurf := nil;
  FScreenDepth := nil;

  FD3DDevice.GetRenderTarget(FScreenSurf);
  FD3DDevice.GetDepthStencilSurface(FScreenDepth);

  for I := 0 to FTargets.Count - 1 do begin
    Target := TTarget(FTargets[I]);
    Target.Lost;
  end;

// Create Vertex buffer

  if (Failed(FD3DDevice.CreateVertexBuffer(VERTEX_BUFFER_SIZE * SizeOf(THGEVertex), D3DUSAGE_WRITEONLY,D3DFVF_HGEVERTEX,D3DPOOL_DEFAULT,FVB)))
  then begin
    PostError('Can''t create D3D vertex buffer');
    Exit;
  end;

  FD3DDevice.SetVertexShader(D3DFVF_HGEVERTEX);
  FD3DDevice.SetStreamSource(0,FVB,SizeOf(THGEVertex));

// Create and setup Index buffer

  if (Failed(FD3DDevice.CreateIndexBuffer(VERTEX_BUFFER_SIZE * 6 div 4 * SizeOf(Word),
    D3DUSAGE_WRITEONLY,D3DFMT_INDEX16,D3DPOOL_DEFAULT,FIB)))
  then begin
    PostError('Can''t create D3D index buffer');
    Exit;
  end;

  N := 0;
  if (Failed(FIB.Lock(0,0,PByte(PIndices),0))) then
  begin
    PostError('Can''t lock D3D index buffer');
    Exit;
  end;

  for I := 0 to (VERTEX_BUFFER_SIZE div 4) - 1 do begin
    PIndices^ := N  ; Inc(PIndices);
    PIndices^ := N+1; Inc(PIndices);
    PIndices^ := N+2; Inc(PIndices);
    PIndices^ := N+2; Inc(PIndices);
    PIndices^ := N+3; Inc(PIndices);
    PIndices^ := N;   Inc(PIndices);
    Inc(N,4);
  end;

  FIB.Unlock;
  FD3DDevice.SetIndices(FIB,0);

// Set common render states

  //pD3DDevice->SetRenderState( D3DRS_LASTPIXEL, FALSE );
  FD3DDevice.SetRenderState(D3DRS_CULLMODE,D3DCULL_NONE);
  FD3DDevice.SetRenderState(D3DRS_LIGHTING,0);

  FD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE,1);
  FD3DDevice.SetRenderState(D3DRS_SRCBLEND,D3DBLEND_SRCALPHA);
  FD3DDevice.SetRenderState(D3DRS_DESTBLEND,D3DBLEND_INVSRCALPHA);

  FD3DDevice.SetRenderState(D3DRS_ALPHATESTENABLE,1);
  FD3DDevice.SetRenderState(D3DRS_ALPHAREF,1);
  FD3DDevice.SetRenderState(D3DRS_ALPHAFUNC,D3DCMP_GREATEREQUAL);

  FD3DDevice.SetTextureStageState(0,D3DTSS_COLOROP,  D3DTOP_MODULATE);
  FD3DDevice.SetTextureStageState(0,D3DTSS_COLORARG1,D3DTA_TEXTURE);
  FD3DDevice.SetTextureStageState(0,D3DTSS_COLORARG2,D3DTA_DIFFUSE);

  FD3DDevice.SetTextureStageState(0,D3DTSS_ALPHAOP,  D3DTOP_MODULATE);
  FD3DDevice.SetTextureStageState(0,D3DTSS_ALPHAARG1,D3DTA_TEXTURE);
  FD3DDevice.SetTextureStageState(0,D3DTSS_ALPHAARG2,D3DTA_DIFFUSE);

  FD3DDevice.SetTextureStageState(0,D3DTSS_MIPFILTER, D3DTEXF_POINT);

  if (FTextureFilter) then begin
    FD3DDevice.SetTextureStageState(0,D3DTSS_MAGFILTER,D3DTEXF_LINEAR);
    FD3DDevice.SetTextureStageState(0,D3DTSS_MINFILTER,D3DTEXF_LINEAR);
  end else begin
    FD3DDevice.SetTextureStageState(0,D3DTSS_MAGFILTER,D3DTEXF_POINT);
    FD3DDevice.SetTextureStageState(0,D3DTSS_MINFILTER,D3DTEXF_POINT);
  end;

  FPrim := 0;
  FCurPrimType := HGEPRIM_QUADS;
  FCurBlendMode := BLEND_DEFAULT;
  FCurTexture := nil;

  FD3DDevice.SetTransform(D3DTS_VIEW,FMatView);
  FD3DDevice.SetTransform(D3DTS_PROJECTION,FMatProj);

  Result := True;
end;

function THGEImpl.Ini_GetFloat(const Section, Name: String;
  const DefVal: Single): Single;
var
  Buf: array [0..255] of Char;
begin
  Result := DefVal;
  if (FIniFile <> '') then
    if (GetPrivateProfileString(PChar(Section),PChar(Name),'',Buf,255,PChar(FIniFile)) <> 0) then
      Result := StrToFloatDef(Buf,DefVal,FFormatSettings);
end;

function THGEImpl.Ini_GetInt(const Section, Name: String;
  const DefVal: Integer): Integer;
var
  Buf: array [0..255] of Char;
begin
  Result := DefVal;
  if (FIniFile <> '') then
    if (GetPrivateProfileString(PChar(Section),PChar(Name),'',Buf,255,PChar(FIniFile)) <> 0) then
      Result := StrToIntDef(Buf,DefVal);
end;

function THGEImpl.Ini_GetString(const Section, Name, DefVal: String): String;
var
  Buf: array [0..255] of Char;
begin
  Result := DefVal;
  if (FIniFile <> '') then
    if (GetPrivateProfileString(PChar(Section),PChar(Name),'',Buf,255,PChar(FIniFile)) <> 0) then
      Result := Buf;
end;

procedure THGEImpl.Ini_SetFloat(const Section, Name: String;
  const Value: Single);
begin
  if (FIniFile <> '') then
    WritePrivateProfileString(PChar(Section),PChar(Name),
      PChar(FloatToStrF(Value,ffGeneral,7,0,FFormatSettings)),PChar(FIniFile));
end;

procedure THGEImpl.Ini_SetInt(const Section, Name: String;
  const Value: Integer);
begin
  if (FIniFile <> '') then
    WritePrivateProfileString(PChar(Section),PChar(Name),
      PChar(IntToStr(Value)),PChar(FIniFile));
end;

procedure THGEImpl.Ini_SetString(const Section, Name, Value: String);
begin
  if (FIniFile <> '') then
    WritePrivateProfileString(PChar(Section),PChar(Name),
      PChar(Value),PChar(FIniFile));
end;

procedure THGEImpl.InputInit;
var
  P: TPoint;
begin
  GetCursorPos(P);
  ScreenToClient(FWnd,P);
  FXPos := P.X;
  FYPos := P.Y;
  FillChar(FKeyz,SizeOf(FKeyz),0);
end;

function THGEImpl.Input_GetChar: Integer;
begin
  Result := FChar;
end;

function THGEImpl.Input_GetEvent(out Event: THGEInputEvent): Boolean;
var
  EPtr: PInputEventList;
begin
  if Assigned(FQueue) then begin
    EPtr := FQueue;
    Event := EPtr.Event;
    FQueue := EPtr.Next;
    Dispose(EPtr);
    Result := True;
  end else
    Result := False;
end;

function THGEImpl.Input_GetKey: Integer;
begin
  Result := FVKey;
end;

function THGEImpl.Input_GetKeyName(const Key: Integer): String;
begin
  Result := KeyNames[Key];
end;

function THGEImpl.Input_GetKeyState(const Key: Integer): Boolean;
begin
  Result := ((GetAsyncKeyState(Key) and $8000) <> 0)
end;

procedure THGEImpl.Input_GetMousePos(out X, Y: Single);
begin
  X := FXPos;
  Y := FYPos;
end;

function THGEImpl.Input_GetMouseWheel: Integer;
begin
  Result := FZPos;
end;

function THGEImpl.Input_IsMouseOver: Boolean;
begin
  Result := FMouseOver;
end;

function THGEImpl.Input_KeyDown(const Key: Integer): Boolean;
begin
  Result := ((FKeyz[Key] and 1) <> 0);
end;

function THGEImpl.Input_KeyUp(const Key: Integer): Boolean;
begin
  Result := ((FKeyz[Key] and 2) <> 0);
end;

procedure THGEImpl.Input_SetMousePos(const X, Y: Single);
var
  Pt: TPoint;
begin
  Pt.X := Trunc(X);
  Pt.Y := Trunc(Y);
  ClientToScreen(FWnd,Pt);
  SetCursorPos(Pt.X,Pt.Y);
end;

class function THGEImpl.InterfaceGet: THGEImpl;
begin
  if (PHGE = nil) then
    PHGE := THGEImpl.Create;
  Result := PHGE;
end;
(*
function THGEImpl.Music_Load(const Filename: String): IMusic;
var
  Data: IResource;
  Size: Integer;
begin
  Data := Resource_Load(Filename,@Size);
  if (Data = nil) then
    Result := nil
  else begin
    Result := Music_Load(Data.Handle,Size);
    Data := nil;
  end;
end;

function THGEImpl.Music_GetAmplification(const Music: IMusic): Integer;
begin
  Result := Music.GetAmplification;
end;

function THGEImpl.Music_GetChannelVolume(const Music: IMusic;
  const Channel: Integer): Integer;
begin
  Result := Music.GetChannelVolume(Channel);
end;

function THGEImpl.Music_GetInstrVolume(const Music: IMusic;
  const Instr: Integer): Integer;
begin
  Result := Music.GetInstrVolume(Instr);
end;

function THGEImpl.Music_GetLength(const Music: IMusic): Integer;
begin
  Result := Music.GetLength;
end;

function THGEImpl.Music_GetPos(const Music: IMusic; out Order, Row: Integer): Boolean;
begin
  Result := Music.GetPos(Order,Row);
end;

function THGEImpl.Music_Load(const Data: Pointer; const Size: Longword): IMusic;
var
  Handle: HMusic;
begin
  if (FBass <> 0) then begin
    Handle := BASS_MusicLoad(True,Data,0,Size,BASS_MUSIC_PRESCAN
      or BASS_MUSIC_POSRESETEX or BASS_MUSIC_RAMP,0);
    if (Handle = 0)  then begin
      Result := nil;
      PostError('Can''t load music');
    end else
      Result := TMusic.Create(Handle);
  end else
    Result := nil;
end;

function THGEImpl.Music_Play(const Mus: IMusic; const Loop: Boolean;
  const Volume: Integer = 100; const Order: Integer = -1;
  const Row: Integer = -1): IChannel;
begin
  Result := Mus.Play(Loop,Volume,Order,Row);
end;

procedure THGEImpl.Music_SetAmplification(const Music: IMusic;
  const Ampl: Integer);
begin

end;

procedure THGEImpl.Music_SetChannelVolume(const Music: IMusic; const Channel,
  Volume: Integer);
begin
  Music.SetChannelVolume(Channel,Volume);
end;

procedure THGEImpl.Music_SetInstrVolume(const Music: IMusic; const Instr,
  Volume: Integer);
begin
  Music.SetInstrVolume(Instr,Volume);
end;

procedure THGEImpl.Music_SetPos(const Music: IMusic; const Order, Row: Integer);
begin
  Music.SetPos(Order,Row);
end;
                *)
procedure THGEImpl.PostError(const Error: String);
begin
  System_Log(Error);
  FError := Error;
end;

function THGEImpl.Random_Float(const Min, Max: Single): Single;
begin
  GSeed := 214013 * GSeed + 2531011;
  //return min+g_seed*(1.0f/4294967295.0f)*(max-min);
  Result := Min + (GSeed shr 16) * (1.0 / 65535.0) * (Max - Min);
end;

function THGEImpl.Random_Int(const Min, Max: Integer): Integer;
begin
  GSeed := 214013 * GSeed + 2531011;
  Result := Min + Integer((GSeed xor GSeed shr 15) mod Cardinal(Max - Min + 1));
end;

procedure THGEImpl.Random_Seed(const Seed: Integer);
begin
  if (Seed = 0) then
    GSeed := timeGetTime
  else
    GSeed := Seed;
end;

procedure THGEImpl.RenderBatch(const EndScene: Boolean);
begin
  if Assigned(FVertArray) then begin
    FVB.Unlock;
    if (FPrim <> 0) then begin
      case FCurPrimType of
        HGEPRIM_QUADS:
          FD3DDevice.DrawIndexedPrimitive(D3DPT_TRIANGLELIST, 0, FPrim shl 2, 0, FPrim shl 1);
        HGEPRIM_TRIPLES:
          FD3DDevice.DrawPrimitive(D3DPT_TRIANGLELIST, 0, FPrim);
        HGEPRIM_LINES:
          FD3DDevice.DrawPrimitive(D3DPT_LINELIST, 0, FPrim);
      end;

      FPrim := 0;
    end;

    if (EndScene) then
      FVertArray := nil
    else
      FVB.Lock(0,0,PByte(FVertArray),0);
  end;
end;

procedure THGEImpl.Resize(const Width, Height: Integer);
begin
  if (FWndParent <> 0) then begin
//    if Assigned(FProcFocusLostFunc) then
//      FProcFocusLostFunc;

    FD3DPPW.BackBufferWidth := Width;
    FD3DPPW.BackBufferHeight := Height;
    FScreenWidth := Width;
    FScreenHeight := Height;

    SetProjectionMatrix(FScreenWidth,FScreenHeight);
    GfxRestore;

//    if Assigned(FProcFocusGainFunc) then
//      FProcFocusGainFunc;
  end;
end;
 (*
function THGEImpl.Resource_AttachPack(const Filename: String): Boolean;
var
  Name: String;
  ResItem: PResourceList;
  Zip: unzFile;
begin
  Result := False;
  ResItem := FRes;
  Name := UpperCase(Resource_MakePath(Filename));

  while Assigned(ResItem) do begin
    if (Name = ResItem.Filename) then
      Exit;
    ResItem := ResItem.Next;
  end;

  Zip := unzOpen(PChar(Name));
  if (Zip = nil) then
    Exit;
  unzClose(Zip);

  New(ResItem);
  ResItem.Filename := Name;
  ResItem.Next := FRes;
  FRes := ResItem;
  Result := True;
end;

function THGEImpl.Resource_EnumFiles(const Wildcard: String): String;
begin
  Result := '';
  if (Wildcard <> '') then begin
    FindClose(FSearch);
    if (FindFirst(Resource_MakePath(Wildcard),faAnyFile,FSearch) <> 0) then
      Exit;
    if ((FSearch.Attr and faDirectory) = 0) then
      Result := FSearch.Name
    else
      Result := Resource_EnumFiles;
  end else begin
    if (FSearch.FindHandle = INVALID_HANDLE_VALUE) then
      Exit;
    while True do begin
      if (FindNext(FSearch) <> 0) then begin
        FindClose(FSearch);
        Exit;
      end;
      if ((FSearch.Attr and faDirectory) = 0) then begin
        Result := FSearch.Name;
        Exit;
      end;
    end;
  end;
end;

function THGEImpl.Resource_EnumFolders(const Wildcard: String): String;
begin
  Result := '';
  if (Wildcard <> '') then begin
    FindClose(FSearch);
    if (FindFirst(Resource_MakePath(Wildcard),faAnyFile,FSearch) <> 0) then
      Exit;
    if ((FSearch.Attr and faDirectory) <> 0) and (FSearch.Name[1] <> '.') then
      Result := FSearch.Name
    else
      Result := Resource_EnumFolders;
  end else begin
    if (FSearch.FindHandle = INVALID_HANDLE_VALUE) then
      Exit;
    while True do begin
      if (FindNext(FSearch) <> 0) then begin
        FindClose(FSearch);
        Exit;
      end;
      if ((FSearch.Attr and faDirectory) <> 0) and (FSearch.Name[1] <> '.') then begin
        Result := FSearch.Name;
        Exit;
      end;
    end;
  end;
end;

function THGEImpl.Resource_Load(const Filename: String;
  const Size: PLongword): IResource;
const
  ResErr = 'Can''t load resource: %s';
var
  Data: Pointer;
  ResItem: PResourceList;
  Name, ZipName: String;
  PZipName: array [0..MAX_PATH] of Char;
  Zip: unzFile;
  FileInfo: unz_file_info;
  Done, I: Integer;
  F: THandle;
  BytesRead: Cardinal;
begin
  Result := nil;
  Data := nil;
  if (Filename = '') then
    Exit;
  ResItem := FRes;

  if (not (Filename[1] in ['\','/',':'])) then begin
    // Load from pack
    Name := UpperCase(Filename);
    for I := 1 to Length(Name) do
      if (Name[I] = '/') then
        Name[I] := '\';

    while Assigned(ResItem) do begin
      Zip := unzOpen(PChar(ResItem.Filename));
      Done := unzGoToFirstFile(Zip);
      while (Done = UNZ_OK) do begin
        unzGetCurrentFileInfo(Zip,@FileInfo,PZipName,MAX_PATH,nil,0,nil,0);
        ZipName := UpperCase(PZipName);
        for I := 1 to Length(ZipName) do
          if (ZipName[I] = '/') then
            ZipName[I] := '\';
        if (Name = ZipName) then begin
          if (unzOpenCurrentFile(Zip) <> UNZ_OK) then begin
            unzClose(Zip);
            PostError(Format(ResErr,[Filename]));
            Exit;
          end;

          try
            GetMem(Data,FileInfo.uncompressed_size);
          except
            unzCloseCurrentFile(Zip);
            unzClose(Zip);
            PostError(Format(ResErr,[Filename]));
            Exit;
          end;

          if (unzReadCurrentFile(Zip,Data,FileInfo.uncompressed_size) < 0) then begin
            unzCloseCurrentFile(Zip);
            unzClose(Zip);
            FreeMem(Data);
            PostError(Format(ResErr,[Filename]));
            Exit;
          end;
          Result := TResource.Create(Data,FileInfo.uncompressed_size);
          unzCloseCurrentFile(Zip);
          unzClose(Zip);
          if Assigned(Size) then
            Size^ := FileInfo.uncompressed_size;
          Exit;
        end;

        Done := unzGoToNextFile(Zip);
      end;

      unzClose(Zip);
      ResItem := ResItem.Next;
    end;
  end;

  // Load from file
  F := CreateFile(PChar(Resource_MakePath(Filename)),GENERIC_READ,
    FILE_SHARE_READ,nil,OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL or FILE_FLAG_RANDOM_ACCESS,0);
  if (F = INVALID_HANDLE_VALUE) then begin
    PostError(Format(ResErr,[Filename]));
    Exit;
  end;

  Result := nil;
  FileInfo.uncompressed_size := GetFileSize(F,nil);
  try
    GetMem(Data,FileInfo.uncompressed_size);
  except
    CloseHandle(F);
    PostError(Format(ResErr,[Filename]));
    Exit;
  end;

  if (not ReadFile(F,Data^,FileInfo.uncompressed_size,BytesRead,nil)) then begin
    CloseHandle(F);
    FreeMem(Data);
    PostError(Format(ResErr,[Filename]));
    Exit;
  end;

  Result := TResource.Create(Data,BytesRead);
  CloseHandle(F);
  if Assigned(Size) then
    Size^ := BytesRead;
end;

function THGEImpl.Resource_MakePath(const Filename: String = ''): String;
var
  I: Integer;
begin
  if (Filename = '') then
    FTmpFilename := FAppPath
  else if (Filename[1] in ['\','/',':']) then
    FTmpFilename := Filename
  else
    FTmpFilename := FAppPath + Filename;

  for I := 1 to Length(FTmpFilename) do
    if (FTmpFilename[I] = '/') then
      FTmpFilename[I] := '\';

  Result := FTmpFilename;
end;

procedure THGEImpl.Resource_RemoveAllPacks;
var
  ResItem, ResNextItem: PResourceList;
begin
  ResItem := FRes;
  while Assigned(ResItem) do begin
    ResNextItem := ResItem.Next;
    Dispose(ResItem);
    ResItem := ResNextItem;
  end;
  FRes := nil;
end;

procedure THGEImpl.Resource_RemovePack(const Filename: String);
var
  Name: String;
  ResItem, ResPrev: PResourceList;
begin
  ResItem := FRes;
  ResPrev := nil;
  Name := UpperCase(Resource_MakePath(Filename));

  while Assigned(ResItem) do begin
    if (Name = ResItem.Filename) then begin
      if Assigned(ResPrev) then
        ResPrev.Next := ResItem.Next
      else
        FRes := ResItem.Next;
      Dispose(ResItem);
      Break;
    end;
    ResPrev := ResItem;
    ResItem := ResItem.Next;
  end;
end;          *)

procedure THGEImpl.SetBlendMode(const Blend: Integer);
begin

  FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP,D3DTOP_MODULATE);
  FD3DDevice.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
  case Blend of
       Blend_Default:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND,D3DBLEND_INVSRCALPHA);
       end;
       Blend_ColorAdd:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND,D3DBLEND_INVSRCALPHA);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND,D3DBLEND_ONE);
         FD3DDevice.SetTextureStageState(0,D3DTSS_COLOROP,D3DTOP_ADD);
       end;
       Blend_Add:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ONE);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);

       end;
       Blend_SrcAlphaAdd:
       begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
       end;
       Blend_SrcColor:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCCOLOR);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCCOLOR);
       end;
       BLEND_SrcColorAdd:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCCOLOR);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
       end;
       Blend_Invert:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_INVDESTCOLOR);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ZERO);
       end;
       Blend_SrcBright:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCCOLOR);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_SRCCOLOR);
       end;
       Blend_Multiply:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_SRCCOLOR);
       end;
       Blend_InvMultiply:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCCOLOR);
       end;
       Blend_MultiplyAlpha:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_SRCALPHA);
       end;
       Blend_InvMultiplyAlpha:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
       end;
       Blend_DestBright:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_DESTCOLOR);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_DESTCOLOR);
       end;
       Blend_InvSrcBright:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_INVSRCCOLOR);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCCOLOR);
       end;
       Blend_InvDestBright:
       begin
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_INVDESTCOLOR);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVDESTCOLOR);
       end;
       Blend_Bright:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
         FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE2X);
       end;
       Blend_BrightAdd:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
         FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE4X);
       end;
       Blend_GrayScale:
       begin
         FD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, Integer(False));   // 255,255,155,155
         FD3DDevice.SetRenderState(D3DRS_TextureFactor,Integer((ARGB(255,255,155,155))));
         FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP,D3DTOP_DOTPRODUCT3);
         FD3DDevice.SetTextureStageState(0, D3DTSS_COLORARG2,D3DTA_TFACTOR);
       end;
       Blend_Light:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_DESTCOLOR);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
         FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE2X);
       end;
       Blend_LightAdd:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_DESTCOLOR);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
         FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE4X);
       end;
       Blend_Add2X:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
         FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE2X);
       end;
       Blend_OneColor:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND,  D3DBLEND_SRCALPHA);
         FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
         FD3DDevice.SetTextureStageState(0, D3DTSS_COLOROP, 25);
         FD3DDevice.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
       end;
       Blend_XOR:
       begin
         FD3DDevice.SetRenderState(D3DRS_SRCBLEND,  D3DBLEND_INVDESTCOLOR);
         FD3DDEvice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCCOLOR);
       end;
       fxNone:
       begin
          FD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, iTrue);
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ONE);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ZERO);
          FD3DDevice.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_DISABLE);
       end;
       fxBlend:
       begin
          FD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, iTrue);
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
          //FD3DDevice.SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);
       end;
       fxAnti:
       begin
          FD3DDevice.SetRenderState(D3DRS_ALPHABLENDENABLE, iTrue);
          FD3DDevice.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_INVDESTCOLOR);
          FD3DDevice.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
          //FD3DDevice.SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);
       end;
  end;

  FCurBlendMode := Blend;
end;

procedure THGEImpl.SetCurPrimType(const Value: Integer);
begin
  FCurPrimType := Value;
end;

procedure THGEImpl.SetCurTexture(Const Value: ITexture);
begin
  FCurTexture := Value;
end;
 {
procedure THGEImpl.SetFXVolume(const Vol: Integer);
begin
  if (FBass <> 0) then
    BASS_SetConfig(BASS_CONFIG_GVOL_SAMPLE,Vol);
end;

procedure THGEImpl.SetMusVolume(const Vol: Integer);
begin
  if (FBass <> 0) then
    BASS_SetConfig(BASS_CONFIG_GVOL_MUSIC,Vol);
end;         }

procedure THGEImpl.SetProjectionMatrix(const Width, Height: Integer);
var
  Tmp: TD3DXMatrix;
begin
  D3DXMatrixScaling(FMatProj,1.0,-1.0,1.0);
  D3DXMatrixTranslation(Tmp,-0.5,Height + 0.5,0.0);
  D3DXMatrixMultiply(FMatProj,FMatProj,Tmp);
  D3DXMatrixOrthoOffCenterLH(Tmp,0,Width,0,Height,0.0,1.0);
  D3DXMatrixMultiply(FMatProj,FMatProj,Tmp);
end;
 (*
procedure THGEImpl.SoundDone;
begin
  if (FBass <> 0) then begin
    BASS_Stop;
    BASS_Free;
    FinalizeBassDLL;
    FBass := 0;
  end;
end;

function THGEImpl.SoundInit: Boolean;
begin
  if (not FUseSound) or (FBass <> 0) then begin
    Result := True;
    Exit;
  end;
  Result := False;

  if (InitializeBassDLL) then
    FBass := GetBassDLLHandle
  else
    FBass := 0;

  if (FBass = 0) then begin
    PostError('Can''t load BASS.DLL');
    Exit;
  end;

  if (HIWORD(BASS_GetVersion) <> BASSVERSION) then begin
    PostError('Incorrect BASS.DLL version');
    Exit;
  end;

  FSilent := False;
  if (not BASS_Init(-1,FSampleRate,0,FWnd,nil)) then begin
    System_Log('BASS Init failed, using no sound');
    BASS_Init(0,FSampleRate,0,FWnd,nil);
    FSilent := True;
  end else begin
    System_Log('Sound Device: %s',[BASS_GetDeviceDescription(1)]);
    System_Log('Sample rate: %d' +CRLF,[FSampleRate]);
  end;

  SetFXVolume(FFXVolume);
  SetMusVolume(FMusVolume);

  Result := True;
end;

function THGEImpl.Stream_Load(const Filename: String): IStream;
var
  Data: IResource;
  Size: Integer;
begin
  Data := Resource_Load(Filename,@Size);
  if (Data = nil) then
    Result := nil
  else begin
    Result := Stream_Load(Data,Size);
  end;
end;

function THGEImpl.Stream_Load(const Data: Pointer; const Size: Longword): IStream;
var
  Handle: HStream;
begin
  if (FBass <> 0) then begin
    if (FSilent) then begin
      Result := nil;
      Exit;
    end;

    Handle := BASS_StreamCreateFile(True,Data,0,Size,0);
    if (Handle = 0) then begin
      PostError('Can''t load stream');
      Result := nil;
      Exit;
    end;
    Result := TStream.Create(Handle,nil);
  end else
    Result := nil;
end;

function THGEImpl.Stream_Load(const Resource: IResource; const Size: Longword): IStream;
var
  Handle: HStream;
begin
  if (FBass <> 0) then begin
    if (FSilent) then begin
      Result := nil;
      Exit;
    end;

    Handle := BASS_StreamCreateFile(True,Resource.Handle,0,Size,0);
    if (Handle = 0) then begin
      PostError('Can''t load stream');
      Result := nil;
      Exit;
    end;
    Result := TStream.Create(Handle,Resource);
  end else
    Result := nil;
end;

function THGEImpl.Stream_Play(const Stream: IStream; const Loop: Boolean;
  const Volume: Integer): IChannel;
begin
  Result := Stream.Play(Loop,Volume);
end;               *)

function THGEImpl.System_GetErrorMessage: String;
begin
  Result := FError;
end;

function THGEImpl.System_GetState(const State: THGEStringState): String;
begin
  case State of
    HGE_ICON:
      Result := FIcon;
    HGE_TITLE:
      Result := FWinTitle;
    {HGE_INIFILE:
      Result := FIniFile;}
    HGE_LOGFILE:
      Result := FLogFile;
  else
    Result := '';
  end;
end;

function THGEImpl.System_GetState(const State: THGEIntState): Integer;
begin
  case State of
    HGE_SCREENWIDTH:
      Result := FScreenWidth;
    HGE_SCREENHEIGHT:
      Result := FScreenHeight;
    HGE_SCREENBPP:
      Result := FScreenBPP;
    {HGE_SAMPLERATE:
      Result := FSampleRate;  }
    {HGE_FXVOLUME:
      Result := FFXVolume;
    HGE_MUSVOLUME:
      Result := FMusVolume;  }
    HGE_FPS:
      Result := FHGEFPS;
  else
    Result := 0;
  end;
end;

function THGEImpl.System_GetState(const State: THGEFuncState): THGECallback;
begin
  case State of
    HGE_FRAMEFUNC:
      Result := FProcFrameFunc;
    HGE_RENDERFUNC:
      Result := FProcRenderFunc;
    HGE_FOCUSLOSTFUNC:
      Result := FProcFocusLostFunc;
    HGE_FOCUSGAINFUNC:
      Result := FProcFocusGainFunc;
    HGE_EXITFUNC:
      Result := FProcExitFunc;
  else
    Result := nil;
  end;
end;

function THGEImpl.System_GetState(const State: THGEBoolState): Boolean;
begin
  case State of
    HGE_WINDOWED:
      Result := FWindowed;
    HGE_ZBUFFER:
      Result := FZBuffer;
    HGE_TEXTUREFILTER:
      Result := FTextureFilter;
    {HGE_USESOUND:
      Result := FUseSound;  }
    HGE_DONTSUSPEND:
      Result := FDontSuspend;
    HGE_HIDEMOUSE:
      Result := FHideMouse;
    HGE_HARDWARE:
      Result := FHardwareTL;

  else
    Result := False;
  end;
end;

function THGEImpl.System_GetState(const State: THGEHWndState): HWnd;
begin
  case State of
    HGE_HWND:
      Result := FWnd;
    HGE_HWNDPARENT:
      Result := FWndParent;
  else
    Result := 0;
  end;
end;

function THGEImpl.System_Initiate: Boolean;
var
  OSVer: TOSVersionInfo;
  TM: TSystemTime;
  MemSt: TMemoryStatus;
  WinClass: TWndClass;
  Width, Height: Integer;
  boSuccess: Boolean;
  sErrorMsg: string;
begin
  Result := False;

  // Log system info

  System_Log('HGE Started..' + CRLF);

  System_Log('HGE version: %x.%x',
    [HGE_VERSION shr 8,HGE_VERSION and $FF]);
  GetLocalTime(TM);
  System_Log('Date: %02d.%02d.%d, %02d:%02d:%02d' + CRLF,
    [TM.wDay,TM.wMonth,TM.wYear,TM.wHour,TM.wMinute,TM.wSecond]);

  System_Log('Application: %s',[FWinTitle]);
  OSVer.dwOSVersionInfoSize := SizeOf(OSVer);
  GetVersionEx(OSVer);
  System_Log('OS: Windows %d.%d.%d',
    [OSVer.dwMajorVersion,OSVer.dwMinorVersion,OSVer.dwBuildNumber]);

  GlobalMemoryStatus(MemSt);
  System_Log('Memory: %dK total, %dK free' + CRLF,
    [MemSt.dwTotalPhys div 1024,MemSt.dwAvailPhys div 1024]);

  // Register window class

  FillChar(WinClass,SizeOf(WinClass),0);
  WinClass.style := CS_DBLCLKS or CS_OWNDC or CS_HREDRAW or CS_VREDRAW;
  WinClass.lpfnWndProc := @WindowProc;
  WinClass.hInstance := FInstance;
  WinClass.hCursor := LoadCursor(0,IDC_ARROW);
  WinClass.hbrBackground := HBrush(GetStockObject(BLACK_BRUSH));
  winclass.lpszClassName := WINDOW_CLASS_NAME;
  if (FIcon <> '') then
    WinClass.hIcon := LoadIcon(FInstance,PChar(FIcon))
  else
    WinClass.hIcon := LoadIcon(0,IDI_APPLICATION);

  if (RegisterClass(WinClass) = 0) then begin
    PostError('Can''t register window class');
    Exit;
  end;

  // Create window
  Width := FScreenWidth + GetSystemMetrics(SM_CXFIXEDFRAME) * 2;
  Height := FScreenHeight + GetSystemMetrics(SM_CYFIXEDFRAME) * 2
    + GetSystemMetrics(SM_CYCAPTION);

  FRectW.Left := (GetSystemMetrics(SM_CXSCREEN) - Width) div 2;
  FRectW.Top := (GetSystemMetrics(SM_CYSCREEN) - Height) div 2;
  FRectW.Right := FRectW.Left + Width;
  FRectW.Bottom := FRectW.Top + Height;
  FStyleW := WS_POPUP or WS_CAPTION or WS_SYSMENU or WS_MINIMIZEBOX or WS_VISIBLE; //WS_OVERLAPPED | WS_SYSMENU | WS_MINIMIZEBOX;

  FRectFS.Left := 0;
  FRectFS.top := 0;
  FRectFS.right := FScreenWidth;
  FRectFS.bottom := FScreenHeight;
  FStyleFS := WS_POPUP or WS_VISIBLE; //WS_POPUP

  if (FWndParent <> 0) then begin
    FRectW.Left := 0;
    FRectW.Top := 0;
    FRectW.Right := FScreenWidth;
    FRectW.Bottom := FScreenHeight;
    FStyleW := WS_CHILD or WS_VISIBLE;
    FWindowed := True;
  end;

  if (FWindowed) then
    FWnd := CreateWindowEx(0,WINDOW_CLASS_NAME,PChar(FWinTitle),FStyleW,
       FRectW.Left,FRectW.Top,FRectW.Right - FRectW.Left,
      FRectW.Bottom - FRectW.Top,FWndParent,0,FInstance,nil)
  else
    FWnd := CreateWindowEx(WS_EX_TOPMOST,WINDOW_CLASS_NAME,PChar(FWinTitle),
      FStyleFS,0,0,0,0,0,0,FInstance,nil);
  if (FWnd = 0) then begin
    PostError('Can''t create window');
    Exit;
  end;

  ShowWindow(FWnd,SW_SHOW);

  // Init subsystems

  TimeBeginPeriod(1);
  Random_Seed;
  InputInit;
  if (not GfxInit) then begin
    System_Shutdown;
    Exit;
  end;
  {if (not SoundInit) then begin
    System_Shutdown;
    Exit;
  end;   }
  boSuccess := True;
  sErrorMsg := '';
  if Assigned(FOnInitialize) then
    FOnInitialize(Self, boSuccess, sErrorMsg);

  if not boSuccess then begin
    PostError('Can''t Initialize');
    System_Shutdown;
    Exit;
  end;


  System_Log('Init done.' + CRLF);

  FTime := 0.0;
  FT0 := timeGetTime;
  FT0FPS := FT0;
  FDT := 0;
  FCFPS := 0;
  FFPS := 0;

  // Show splash

  // Done
  
  Result := True;
end;

function THGEImpl.System_Launch(const Url: String): Boolean;
begin
  if (ShellExecute(FWnd,nil,PChar(Url),nil,nil,SW_SHOWMAXIMIZED) > 32) then
    Result := True
  else
    Result := False;
end;

procedure THGEImpl.System_Log(const S: String);
begin
  System_Log(S,[]);
end;

procedure THGEImpl.System_Log(const Format: String; const Args: array of Const);
var
  HF: THandle;
  S: String;
  BytesWritten: Cardinal;
begin
  if (FLogFile = '') then
    Exit;

  HF := CreateFile(PChar(FLogFile),GENERIC_WRITE,FILE_SHARE_READ,nil,
    OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,0);
  if (HF = 0) then
    Exit;
  try
    SetFilePointer(HF,0,nil,FILE_END);
    S := SysUtils.Format(Format,Args) + CRLF;
    WriteFile(HF,S[1],Length(S),BytesWritten,nil);
  finally
    CloseHandle(HF);
  end;
end;

procedure THGEImpl.System_SetState(const State: THGEStringState;
  const Value: String);
//var
//  HF: THandle;
begin
  case State of
    HGE_ICON:
      begin
        FIcon := Value;
        if (FWnd <> 0) then
          SetClassLong(FWnd,GCL_HICON,LoadIcon(FInstance,PChar(FIcon)));
      end;
    HGE_TITLE:
      begin
        FWinTitle := Value;
        if (FWnd <> 0) then
          SetWindowText(FWnd,PChar(FWinTitle));
      end;
    {HGE_INIFILE:
      if (Value <> '') then
        FIniFile := Resource_MakePath(Value)
      else
        FIniFile := '';   }
    HGE_LOGFILE:
      {if (Value <> '') then begin
        FLogFile := Resource_MakePath(Value);
        HF := CreateFile(PChar(FLogFile),GENERIC_WRITE,0,nil,CREATE_ALWAYS,
          FILE_ATTRIBUTE_NORMAL,0);
        if (HF = INVALID_HANDLE_VALUE) then
          FLogFile := ''
        else
          CloseHandle(HF);
      end else
        FLogFile := '';  }
  end;
end;

procedure THGEImpl.System_SetState(const State: THGEIntState;
  const Value: Integer);
begin
  case State of
    HGE_SCREENWIDTH:
      if (FD3DDevice = nil) then
        FScreenWidth := Value;
    HGE_SCREENHEIGHT:
      if (FD3DDevice = nil) then
        FScreenHeight := Value;
    HGE_SCREENBPP:
      if (FD3DDevice = nil) then
        FScreenBPP := Value;
    {HGE_SAMPLERATE:
      if(FBass = 0) then
        FSampleRate := Value;  }
    {HGE_FXVOLUME:
      begin
        FFXVolume := Value;
        SetFXVolume(FFXVolume);
      end;
    HGE_MUSVOLUME:
      begin
        FMusVolume := Value;
        SetMusVolume(FMusVolume);
      end;   }
    HGE_FPS:
      begin
        if Assigned(FVertArray) then
          Exit;
        if Assigned(FD3DDevice) then begin
          if (((FHGEFPS >= 0) and (Value <0)) or ((FHGEFPS < 0) and (Value >= 0))) then begin
            if (Value =HGEFPS_VSYNC) then begin
              FD3DPPW.SwapEffect := D3DSWAPEFFECT_COPY_VSYNC;
              FD3DPPFS.FullScreen_PresentationInterval := D3DPRESENT_INTERVAL_ONE;
            end else begin
              FD3DPPW.SwapEffect := D3DSWAPEFFECT_COPY;
              FD3DPPFS.FullScreen_PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE;
            end;
//            if Assigned(FProcFocusLostFunc) then
//              FProcFocusLostFunc;
            GfxRestore();
//            if Assigned(FProcFocusGainFunc) then
//              FProcFocusGainFunc;
          end;
        end;
        FHGEFPS := Value;
        if (FHGEFPS > 0) then
          FFixedDelta := 1000 div Value
        else
          FFixedDelta := 0;
      end;
  end;
end;

procedure THGEImpl.System_SetState(const State: THGEBoolState;
  const Value: Boolean);
begin
  case State of
    HGE_WINDOWED:
      begin
        if (Assigned(FVertArray) or (FWndParent <> 0)) then
          Exit;
        if (Assigned(FD3DDevice) and (FWindowed <> Value)) then begin
          if (FD3DPPW.BackBufferFormat = D3DFMT_UNKNOWN)
            or (FD3DPPFS.BackBufferFormat = D3DFMT_UNKNOWN)
          then
            Exit;

          if (FWindowed) then
            GetWindowRect(FWnd,FRectW);
          FWindowed := Value;
          if (FWindowed) then
            FD3DPP := @FD3DPPW
          else
            FD3DPP := @FD3DPPFS;

          if (FormatId(FD3DPPW.BackBufferFormat) < 4) then
            FScreenBPP := 16
          else
            FScreenBPP := 32;

          GfxRestore;
          AdjustWindow;
        end else
          FWindowed := Value;
      end;
    HGE_ZBUFFER:
      if (FD3DDevice = nil)  then
        FZBuffer := Value;
    HGE_TEXTUREFILTER:
      begin
        FTextureFilter := Value;
        if Assigned(FD3DDevice) then begin
          RenderBatch;
          if (FTextureFilter) then begin
            FD3DDevice.SetTextureStageState(0,D3DTSS_MAGFILTER,D3DTEXF_LINEAR);
            FD3DDevice.SetTextureStageState(0,D3DTSS_MINFILTER,D3DTEXF_LINEAR);
          end else begin
            FD3DDevice.SetTextureStageState(0,D3DTSS_MAGFILTER,D3DTEXF_POINT);
            FD3DDevice.SetTextureStageState(0,D3DTSS_MINFILTER,D3DTEXF_POINT);
          end;
        end;
      end;
    {HGE_USESOUND:
      begin
        if (FUseSound <> Value) then begin
          FUseSound := Value;
          if FUseSound and (FWnd <> 0) then
            SoundInit();
          if(not FUseSound) and (FWnd <> 0) then
            SoundDone();
        end;
      end;   }
    HGE_HIDEMOUSE:
      FHideMouse := Value;
    HGE_HARDWARE:
      FHardwareTL := Value;
    HGE_DONTSUSPEND:
      FDontSuspend := Value;
  end;
end;

procedure THGEImpl.System_SetState(const State: THGEFuncState;
  const Value: THGECallback);
begin
  case State of
    HGE_FRAMEFUNC:
      FProcFrameFunc := Value;
    HGE_RENDERFUNC:
      FProcRenderFunc := Value;
    HGE_FOCUSLOSTFUNC:
      FProcFocusLostFunc := Value;
    HGE_FOCUSGAINFUNC:
      FProcFocusGainFunc := Value;
    HGE_GFXRESTOREFUNC:
      FProcGfxRestoreFunc := Value;
    HGE_EXITFUNC:
      FProcExitFunc := Value;
  end;
end;

procedure THGEImpl.System_SetState(const State: THGEHWndState;
  const Value: HWnd);
begin
  case State of
    HGE_HWNDPARENT:
      if (FWnd = 0) then
        FWndParent := Value;
  end;
end;

procedure THGEImpl.System_Shutdown;
begin
  System_Log(CRLF+'Finishing..');
  TimeEndPeriod(1);
  ClearQueue;
  //SoundDone;
  GfxDone;
  if (FWnd <> 0) then begin
    //ShowWindow(hwnd, SW_HIDE);
    //SetWindowLong(hwnd, GWL_EXSTYLE, GetWindowLong(hwnd, GWL_EXSTYLE) | WS_EX_TOOLWINDOW);
    //ShowWindow(hwnd, SW_SHOW);
    DestroyWindow(FWnd);
    FWnd := 0;
  end;
  if (FInstance <> 0) then
    UnregisterClass(WINDOW_CLASS_NAME,FInstance);

  System_Log('The End.');
end;

//НиЭМ
procedure THGEImpl.System_Snapshot(const Filename: String);
{var
  Surf: IDirect3DSurface8;
  ShotName: String;
  I: Integer;   }
begin
 { if (Filename = '') then begin
    I := 0;
    ShotName := Resource_EnumFiles('Shot???.bmp');
    while (ShotName <> '') do begin
      Inc(I);
      ShotName := Resource_EnumFiles;
    end;
    ShotName := Resource_MakePath(Format('Shot%3d.bmp',[I]));
  end else
    ShotName := Filename;

  if Assigned(FD3DDevice) then begin
    FD3DDevice.GetBackBuffer(0,D3DBACKBUFFER_TYPE_MONO,Surf);
    D3DXSaveSurfaceToFile(PChar(ShotName),D3DXIFF_BMP,Surf,nil,nil);
  end; }
end;

function THGEImpl.System_Start: Boolean;
var
  Msg: TMsg;
begin
  Result := False;
  if (FWnd = 0) then begin
    PostError('System_Start: System_Initiate wasn''t called');
    Exit;
  end;

  if (not Assigned(FProcFrameFunc)) then begin
    PostError('System_Start: No frame function defined');
    Exit;
  end;

  FActive := True;

  // MAIN LOOP

  while True do begin

		// Process window messages if not in "child mode"
		// (if in "child mode" the parent application will do this for us)

    if(FWndParent = 0) then begin
      if (PeekMessage(Msg,0,0,0,PM_REMOVE)) then begin
        if (Msg.message = WM_QUIT) then
          Break;
        // TranslateMessage(&msg);
        DispatchMessage(Msg);
        Continue;
      end;
    end;

		// Check if mouse is over HGE window for Input_IsMouseOver

		UpdateMouse();

		// If HGE window is focused or we have the "don't suspend" state - process the main loop

    if (FActive or FDontSuspend) then begin
			// Ensure we have at least 1ms time step
			// to not confuse user's code with 0
      repeat
        FDT := TimeGetTime - FT0;
      until (FDT >= 1);

			// If we reached the time for the next frame
			// or we just run in unlimited FPS mode, then
			// do the stuff
      if(FDT >= FFixedDelta) then begin
				// fDeltaTime = time step in seconds returned by Timer_GetDelta
        FDeltaTime := FDT / 1000.0;

				// Cap too large time steps usually caused by lost focus to avoid jerks
        if (FDeltaTime > 0.2) then begin
          if (FFixedDelta <> 0) then
            FDeltaTime := FFixedDelta / 1000.0
          else
            FDeltaTime := 0.01;
        end;
				// Update time counter returned Timer_GetTime
        FTime := FTime + FDeltaTime;

				// Store current time for the next frame
				// and count FPS
        FT0 := TimeGetTime;
        if (FT0 - FT0FPS <= 1000) then
          Inc(FCFPS)
        else begin
          FFPS := FCFPS;
          FCFPS := 0;
          FT0FPS := FT0;
        end;

				// Do user's stuff
        if (FProcFrameFunc) then
          Break;
        if Assigned(FProcRenderFunc) then
          FProcRenderFunc;

				// If if "child mode" - return after processing single frame
        if (FWndParent <> 0) then
          Break;

				// Clean up input events that were generated by
				// WindowProc and weren't handled by user's code
        ClearQueue;

				// If we use VSYNC - we could afford a little
				// sleep to lower CPU usage
//        if (not FWindowed) and (FHGEFPS = HGEFPS_VSYNC) then
//          Sleep(1);
      end else begin
  			// If we have a fixed frame rate and the time
	  		// for the next frame isn't too close, sleep a bit
        if ((FFixedDelta <> 0) and (FDT + 3 < FFixedDelta)) then
          Sleep(1);
      end;
    end else
      // If main loop is suspended - just sleep a bit
      // (though not too much to allow instant window
      // redraw if requested by OS)
      Sleep(1);
  end;
  ClearQueue;
  FActive := False;
  Result := True;
end;

function THGEImpl.Target_Create(const Width, Height: Integer;
  const ZBuffer: Boolean): ITarget;
var
  Tex: ITexture;
  DXTexture: IDirect3DTexture8;
  Depth: IDirect3DSurface8;
  Desc: TD3DSurfaceDesc;
begin
  Result := nil;

  if (Failed(D3DXCreateTexture(FD3DDevice,Width,Height,1,D3DUSAGE_RENDERTARGET,FD3DPP.BackBufferFormat,D3DPOOL_DEFAULT,DXTexture)))
  then begin
    PostError('Can''t create render target texture');
    Exit;
  end;
  Tex := TTexture.Create(DXTexture,Width,Height);

  DXTexture.GetLevelDesc(0,Desc);

  if (ZBuffer) then begin
    if (Failed(FD3DDevice.CreateDepthStencilSurface(Desc.Width,Desc.Height, D3DFMT_D16,D3DMULTISAMPLE_NONE,Depth)))
    then begin
      PostError('Can''t create render target depth buffer');
      Exit;
    end;
  end else
    Depth := nil;

  Result := TTarget.Create(Desc.Width,Desc.Height,Tex,Depth);
end;

function THGEImpl.Target_GetTexture(const Target: ITarget): ITexture;
begin
  if Assigned(Target) then
    Result := Target.Tex
  else
    Result := nil;
end;

function THGEImpl.Texture_Create(const Width, Height: Integer): ITexture;
var
  PTex: IDirect3DTexture8;
begin
  if (Failed(D3DXCreateTexture(FD3DDevice,Width,Height,
    1,          // Mip levels
    0,          // Usage
    D3DFMT_A8R8G8B8,  // Format
    D3DPOOL_MANAGED,  // Memory pool
    PTex)))
  then begin
    PostError('Can''t create texture');
    Result := nil
  end else
    Result := TTexture.Create(PTex,Width,Height);
end;

function THGEImpl.Texture_Create(const Width, Height:Integer; Pool: TD3DPool; Format: TD3DFormat): ITexture;
var
  PTex: IDirect3DTexture8;
begin
  if (Failed(D3DXCreateTexture(FD3DDevice,Width,Height,
    1,          // Mip levels
    0,          // Usage
    Format,  // Format
    Pool,  // Memory pool
    PTex)))
  then begin
    PostError('Can''t create texture');
    Result := nil
  end else
    Result := TTexture.Create(PTex, Width, Height);
end;

function THGEImpl.Texture_Create(const Width, Height: Integer; Tex: IDirect3DTexture8): ITexture;
begin
  Result := TTexture.Create(Tex, Width, Height);
end;

function THGEImpl.Texture_GetHeight(const Tex: ITexture;
  const Original: Boolean): Integer;
begin
  Result := Tex.GetHeight(Original);
end;

function THGEImpl.Texture_GetWidth(const Tex: ITexture;
  const Original: Boolean): Integer;
begin
  Result := Tex.GetWidth(Original);
end;
(*
function THGEImpl.Texture_LoadJPEG2000(const Data: Pointer;
  const Size: Longword; const Mipmap: Boolean;
  const Format: TOPJ_CodecFormat): ITexture;
var
  Params: TOPJ_DParameters;
  Info: POPJ_DInfo;
  CIO: POPJ_CIO;
  Image: POPJ_Image;
  I, MipmapLevels, X, Y: Integer;
  PTex: IDirect3DTexture8;
  LR: TD3DLockedRect;
  SD: TD3DSurfaceDesc;
  SR, SG, SB: PByte;
  D1, D2: PCardinal;
begin
  Result := nil;

  opj_set_default_decoder_parameters(Params);
  Info := opj_create_decompress(Format);
  if (Info = nil) then begin
    PostError('Cannot load JPEG2000 image');
    Exit;
  end;

  CIO := nil;
  Image := nil;
  try
    CIO := opj_cio_open(Info,Data,Size);
    if (CIO = nil) then begin
      PostError('Cannot load JPEG2000 image');
      Exit;
    end;
    opj_setup_decoder(Info,Params);

    Image := opj_decode(Info,CIO);
    if (Image = nil) then begin
      PostError('Cannot load JPEG2000 image');
      Exit;
    end;

    { Only support RGB, 8 bits/channel images }
    if (Image.NumComps <> 3) or (Image.ColorSpace <> ClrSpcSRGB) or (Image.Comps[0].Prec <> 8) then begin
      PostError('Unsupported  JPEG2000 image');
      Exit;
    end;

    { Don't support subsampled images and signed images }
    for I := 0 to 2 do
      if (Image.Comps[I].DX <> 1) or (Image.Comps[I].DY <> 1)
        or (Image.Comps[I].Sgnd = 1)
      then begin
        PostError('Unsupported  JPEG2000 image');
        Exit;
      end;

    { Create texture }
    if (Mipmap) then
      MipmapLevels := 0
    else
      MipmapLevels := 1;

    if(Failed(D3DXCreateTexture(FD3DDevice,Image.X1,Image.Y1,MipmapLevels,0,
      D3DFMT_A8R8G8B8,D3DPOOL_MANAGED,PTex)))
    then begin
      PostError('Can''t create texture');
      Exit;
    end;

    if (Failed(PTex.GetLevelDesc(0,SD))) then begin
      PostError('Can''t retrieve texture description');
      Exit;
    end;

    if (Failed(PTex.LockRect(0,LR,nil,0))) then begin
      PostError('Can''t lock texture');
      Exit;
    end;

    try
      { Copy image to texture }
      D1 := LR.pBits;
      for Y := 0 to Image.Y1 - 1 do begin
        SR := @Image.Comps[0].Data[Y * Image.X1];
        SG := @Image.Comps[1].Data[Y * Image.X1];
        SB := @Image.Comps[2].Data[Y * Image.X1];
        D2 := D1;
        for X := 0 to Image.X1 - 1 do begin
          D2^ := $FF000000 or SB^ or (SG^ shl 8) or (SR^ shl 16);
          Inc(SR,4); Inc(SG,4); Inc(SB,4); Inc(D2);
        end;
        Inc(PByte(D1),LR.Pitch);
      end;
    finally
      PTex.UnlockRect(0);
    end;

    { Create mipmap levels if specified }
    if (MipMap) then
      D3DXFilterTexture(PTex,nil,0,D3DX_DEFAULT);

    Result := TTexture.Create(PTex,SD.Width,SD.Height);
  finally
    opj_image_destroy(Image);
    opj_destroy_decompress(Info);
    opj_cio_close(CIO);
  end;
end;      *)
{
function THGEImpl.Texture_Load(const Filename: String; const Mipmap: Boolean): ITexture;
var
  Data: IResource;
  Size: Longword;
begin
  Data := Resource_Load(Filename,@Size);
  if (Data = nil) then
    Result := nil
  else begin
    Result := Texture_Load(Data.Handle,Size,Mipmap);
    Data := nil;
  end;
end;    }

(*
function THGEImpl.Texture_Load(const Data: Pointer; const Size: Longword;
  const Mipmap: Boolean): ITexture;
var
  Fmt1, Fmt2: TD3DFormat;
  PTex: IDirect3DTexture8;
  Info: TD3DXImageInfo;
  MipmapLevels: Integer;
begin
  Result := nil;
  { Check for JPEG2000 file (check for JP2 or J2K header).
    Use JPEG2000 extension to load this texture. }
  if (PLongword(Data)^ = $51FF4FFF) then begin
    Result := Texture_LoadJPEG2000(Data,Size,Mipmap,CodecJ2K);
    Exit;
  end else if (PInt64(Data)^ = $2020506A0C000000) then begin
    Result := Texture_LoadJPEG2000(Data,Size,Mipmap,CodecJP2);
    Exit;
  end;

  if (PLongword(Data)^ = $20534444) then begin // Compressed DDS format magic number
    Fmt1 := D3DFMT_UNKNOWN;
    Fmt2 := D3DFMT_A8R8G8B8;
  end else begin
    Fmt1 := D3DFMT_A8R8G8B8;
    Fmt2 := D3DFMT_UNKNOWN;
  end;

//  if( FAILED( D3DXCreateTextureFromFileInMemory( pD3DDevice, data, _size, &pTex ) ) ) pTex=NULL;
  if (Mipmap) then
    MipmapLevels := 0
  else
    MipmapLevels := 1;

  if(Failed(D3DXCreateTextureFromFileInMemoryEx(FD3DDevice,Data,Size,
    D3DX_DEFAULT, D3DX_DEFAULT,
    MipmapLevels,    // Mip levels
    0,          // Usage
    Fmt1,        // Format
    D3DPOOL_MANAGED,  // Memory pool
    D3DX_FILTER_NONE,  // Filter
    D3DX_DEFAULT,    // Mip filter
    0,          // Color key
    @Info,nil,PTex)))
  then
    if (Failed(D3DXCreateTextureFromFileInMemoryEx(FD3DDevice,Data,Size,
      D3DX_DEFAULT, D3DX_DEFAULT,
      MipmapLevels,    // Mip levels
      0,          // Usage
      Fmt2,        // Format
      D3DPOOL_MANAGED,  // Memory pool
      D3DX_FILTER_NONE,  // Filter
      D3DX_DEFAULT,    // Mip filter
      0,          // Color key
      @Info,nil,PTex)))
    then begin
      PostError('Can''t create texture');
      Exit;
    end;

  Result := TTexture.Create(PTex,Info.Width,Info.Height);
end;

function THGEImpl.Texture_Load(const ImageData: Pointer;
  const ImageSize: Longword; const AlphaData: Pointer;
  const AlphaSize: Longword; const Mipmap: Boolean): ITexture;
var
  ImageTexture, AlphaTexture: ITexture;
  A1, A2, I1, I2: PLongword;
  AlphaMask: Longword;
  AlphaShift, I, ImageWidth, ImageHeight, AlphaWidth, AlphaHeight: Integer;
  Width, Height, X, Y: Integer;
begin
  Result := nil;
  ImageTexture := Texture_Load(ImageData,ImageSize,False);
  if (ImageTexture = nil) then
    Exit;

  AlphaTexture := Texture_Load(AlphaData,AlphaSize,False);
  if (AlphaTexture = nil) then
    Exit;

  ImageWidth := ImageTexture.GetWidth;
  ImageHeight := ImageTexture.GetHeight;
  AlphaWidth := AlphaTexture.GetWidth;
  AlphaHeight := AlphaTexture.GetHeight;
  Width := Min(ImageWidth,AlphaWidth);
  Height := Min(ImageHeight,AlphaHeight);

  { Check if AlphaTexture has a valid alpha channel. If so, use alpha channel
    for masking. If not, use green channel for masking (it's assumed that the
    alpha image contains a greyscale mask image). }
  AlphaMask := $0000FF00;
  AlphaShift := 16;
  A1 := AlphaTexture.Lock;
  try
    for I := 0 to AlphaWidth * AlphaHeight - 1 do begin
      if ((A1^ and $FF000000) <> $FF000000) then begin
        AlphaMask := $FF000000;
        AlphaShift := 0;
        Break;
      end;
      Inc(A1);
    end;
  finally
    AlphaTexture.Unlock;
  end;

  { Apply alpha information in AlphaTexture to alpha channel in ImageTexture }
  I1 := ImageTexture.Lock(False);
  try
    A1 := AlphaTexture.Lock(True);
    try
      for Y := 0 to Height - 1 do begin
        A2 := A1;
        I2 := I1;
        for X := 0 to Width - 1 do begin
          I2^ := (I2^ and $00FFFFFF) or ((A2^ and AlphaMask) shl AlphaShift);
          Inc(A2);
          Inc(I2);
        end;
        Inc(A1,AlphaWidth);
        Inc(I1,ImageWidth);
      end;
    finally
      AlphaTexture.Unlock;
    end;
  finally
    ImageTexture.Unlock;
  end;

  Result := ImageTexture;
  AlphaTexture := nil;
end;
{
function THGEImpl.Texture_Load(const ImageFilename, AlphaFilename: String;
  const Mipmap: Boolean): ITexture;
var
  ImageData, AlphaData: IResource;
  ImageSize, AlphaSize: Longword;
begin
  Result := nil;

  ImageData := Resource_Load(ImageFilename,@ImageSize);
  if (ImageData = nil) then
    Exit;

  AlphaData := Resource_Load(AlphaFilename,@AlphaSize);
  if (AlphaData = nil) then
    Exit;

  Result := Texture_Load(ImageData.Handle,ImageSize,
    AlphaData.Handle,AlphaSize,Mipmap);
  ImageData := nil;
  AlphaData := nil;
end;      }  *)

function THGEImpl.Texture_Lock(const Tex: ITexture; const ReadOnly: Boolean;
  const Left, Top, Width, Height: Integer): PLongword;
begin
  Result := Tex.Lock(ReadOnly,Left,Top,Width,Height);
end;

procedure THGEImpl.Texture_Unlock(const Tex: ITexture);
begin
  Tex.Unlock;
end;

function THGEImpl.Timer_GetDelta: Single;
begin
  Result := FDeltaTime;
end;

function THGEImpl.Timer_GetFPS: Integer;
begin
  Result := FFPS;
end;

function THGEImpl.Timer_GetTime: Single;
begin
  Result := FTime;
end;

procedure THGEImpl.UpdateMouse;
var
  P: TPoint;
  R: TRect;
begin
  GetCursorPos(P);
  GetClientRect(FWnd,R);
  MapWindowPoints(FWnd,0,R,2);
  if (FCaptured or (PtInRect(R,P) and (WindowFromPoint(P) = FWnd)))then
    FMouseOver := True
  else
    FMouseOver := False;
end;

function THGEImpl.System_GetState(const State: THGEInitializeState): TInitializeEvent;
begin
  case State of
    HGE_INITIALIZE:
      Result := FOnInitialize;
  else
    Result := nil;
  end;
end;

function THGEImpl.System_GetState(const State: THGEFinalizeState): TNotifyEvent;
begin
  case State of
    HGE_FINALIZE:
      Result := FOnFinalize;
  else
    Result := nil;
  end;
end;

function THGEImpl.System_GetState(const State: THGENotifyEventState): TDeviceNotifyEvent;
begin
  case State of
    HGE_NOTIFYEVENT:
      Result := FOnNotifyEvent;
  else
    Result := nil;
  end;
end;

procedure THGEImpl.System_SetState(const State: THGEInitializeState; const Value: TInitializeEvent);
begin
  case State of
    HGE_INITIALIZE:
      begin
        FOnInitialize := Value;
      end;
  end;
end;

procedure THGEImpl.System_SetState(const State: THGEFinalizeState; const Value: TNotifyEvent);
begin
  case State of
    HGE_FINALIZE:
      begin
        FOnFinalize := Value;
      end;
  end;
end;

procedure THGEImpl.System_SetState(const State: THGENotifyEventState; const Value: TDeviceNotifyEvent);
begin
  case State of
    HGE_NOTIFYEVENT:
      begin
        FOnNotifyEvent := Value;
      end;
  end;
end;

end.
