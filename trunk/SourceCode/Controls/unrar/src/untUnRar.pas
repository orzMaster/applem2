unit untUnRar;

interface

uses
  Windows;

const

  MSG1  = 'Error on close';
  MSG2  = 'No Password!';
  MSG3  = 'Used Pass is: ';
  MSG4  = 'UnRar.Dll not loaded';
  MSG5  = 'corrupt data';
  MSG6  = 'Fehlerhaftes Archiv';
  MSG7  = 'unknown format';
  MSG8  = 'Volumn-Error';
  MSG9  = 'error on create file';
  MSG10 = 'error on closing file';
  MSG11 = 'read error';
  MSG12 = 'write error';
  MSG14 = 'no memory';
  MSG16 = 'buffer to small';
  MSG17 = 'File Haeder corrupt';

  VOLDLGCAPTION  = 'Next Archive: ...';
  PASSDLGCAPTION = 'Password: ...';
  CANCELCAPTION  = 'Cancel';
  OKCAPTION      = 'Ok';

  COMPRESSMETHODSTORE   = 'store';
  COMPRESSMETHODFASTEST = 'fastest';
  COMPRESSMETHODFAST    = 'fast';
  COMPRESSMETHODNORMAL  = 'normal';
  COMPRESSMETHODGOOD    = 'good';
  COMPRESSMETHODBEST    = 'best';


  RAR_METHOD_STORE   = 48;
  RAR_METHOD_FASTEST = 49;
  RAR_METHOD_FAST    = 50;
  RAR_METHOD_NORMAL  = 51;
  RAR_METHOD_GOOD    = 52;
  RAR_METHOD_BEST    = 53;

  RAR_SUCCESS = 0;
  ERAR_COMMENTS_EXISTS = 1;
  ERAR_NO_COMMENTS     = 0;

  ERAR_END_ARCHIVE     = 10;
  ERAR_NO_MEMORY       = 11;
  ERAR_BAD_DATA        = 12;
  ERAR_BAD_ARCHIVE     = 13;
  ERAR_UNKNOWN_FORMAT  = 14;
  ERAR_EOPEN           = 15;
  ERAR_ECREATE         = 16;
  ERAR_ECLOSE          = 17;
  ERAR_EREAD           = 18;
  ERAR_EWRITE          = 19;
  ERAR_SMALL_BUF       = 20;
  ERAR_UNKNOWN         = 21;
  RAR_OM_LIST          = 0;
  RAR_OM_EXTRACT       = 1;
  RAR_SKIP             = 0;
  RAR_TEST             = 1;
  RAR_EXTRACT          = 2;
  RAR_VOL_ASK          = 0;
  RAR_VOL_NOTIFY       = 1;
  RAR_DLL_VERSION      = 3;

  UCM_CHANGEVOLUME     = 0;
  UCM_PROCESSDATA      = 1;
  UCM_NEEDPASSWORD     = 2;

  MAXRARCOMMENTSIZE = 1024 * 64;

type
  // Callback functions, the first 2 are deprecated - use TUnRarCallBack instead
  TProcessDataProc = function(Addr: PByte; Size: integer): integer; stdcall;
  TChangeVolProc   = function(ArcName: PChar; Mode: integer): integer; stdcall;
  TUnRarCallBack   = function(msg: Cardinal; UserData, P1, P2: longint): integer; stdcall;

  // Header for every file in an archive
  TRARHeaderData = record
    ArcName    : array[0..259] of char;
    FileName   : array[0..259] of char;
    Flags      : cardinal;
    PackSize   : cardinal;
    UnpSize    : cardinal;
    HostOS     : cardinal;
    FileCRC    : cardinal;
    FileTime   : cardinal;
    UnpVer     : cardinal;
    Method     : cardinal;
    FileAttr   : cardinal;
    CmtBuf     : PChar;
    CmtBufSize : cardinal;
    CmtSize    : cardinal;
    CmtState   : cardinal;
  end;
  PRARHeaderData = ^TRARHeaderData;

  // extended Header - not used in this component
  TRARHeaderDataEx = record
    ArcName      : array[0..1023] of char;
    ArcNameW     : array[0..1023] of WideChar;
    FileName     : array[0..1023] of char;
    FileNameW    : array[0..1023] of WideChar;
    Flags        : cardinal;
    PackSize     : cardinal;
    PackSizeHigh : cardinal;
    UnpSize      : cardinal;
    UnpSizeHigh  : cardinal;
    HostOS       : cardinal;
    FileCRC      : cardinal;
    FileTime     : cardinal;
    UnpVer       : cardinal;
    Method       : cardinal;
    FileAttr     : cardinal;
    CmtBuf       : PChar;
    CmtBufSize   : cardinal;
    CmtSize      : cardinal;
    CmtState     : cardinal;
    Reserved     : array[1..1024] of cardinal;
  end;
//MYC:2006/08/17  //PRARHeaderDataEx = TRARHeaderDataEx;
  PRARHeaderDataEx = ^TRARHeaderDataEx;

  // Archive-Data for opening rar-archive
  TRAROpenArchiveData = record
    ArcName    : PChar;
    OpenMode   : cardinal;
    OpenResult : cardinal;
    CmtBuf     : PChar;
    CmtBufSize : cardinal;
    CmtSize    : cardinal;
    CmtState   : cardinal;
  end;
  PRAROpenArchiveData = ^TRAROpenArchiveData;

  // extended Archive-Data - not used in this component
  TRAROpenArchiveDataEx = record
    ArcName    : PChar;
    ArcNameW   : PWideChar;
    OpenMode   : cardinal;
    OpenResult : cardinal;
    CmtBuf     : PChar;
    CmtBufSize : cardinal;
    CmtSize    : cardinal;
    CmtState   : cardinal;
    Flags      : cardinal;
    Reserved   : array[1..32] of cardinal;
  end;
  PRAROpenArchiveDataEx = ^TRAROpenArchiveDataEx;

var
  IsLoaded: boolean = false;
  RAROpenArchive        : function(ArchiveData: PRAROpenArchiveData): THandle; stdcall;
  RAROpenArchiveEx      : function(ArchiveData: PRAROpenArchiveDataEx): THandle; stdcall;
  RARCloseArchive       : function(hArcData: THandle): integer; stdcall;
  RARReadHeader         : function(hArcData: THandle; HeaderData: PRARHeaderData): Integer; stdcall;
  RARReadHeaderEx       : function(hArcData: THandle; HeaderData: PRARHeaderDataEx): Integer; stdcall;
  RARProcessFile        : function(hArcData: THandle; Operation: Integer; DestPath, DestName: PChar): Integer; stdcall;
  RARSetCallback        : procedure(hArcData: THandle; Callback: TUnRarCallback; UserData: longint); stdcall;
  RARSetChangeVolProc   : procedure(hArcData: THandle; ChangeVolProc: TChangeVolProc); stdcall;
  RARSetProcessDataProc : procedure(hArcData: THandle; ProcessDataProc: TProcessDataProc); stdcall;
  RARSetPassword        : procedure(hArcData: THandle; Password: PChar); stdcall;
  RARGetDllVersion      : function:Integer; stdcall;

implementation

uses unrarFile;

initialization
  begin
    @RAROpenArchive        := unrar.FindExport('RAROpenArchive');
    @RAROpenArchiveEx      := unrar.FindExport('RAROpenArchiveEx');
    @RARCloseArchive       := unrar.FindExport('RARCloseArchive');
    @RARReadHeader         := unrar.FindExport('RARReadHeader');
    @RARReadHeaderEx       := unrar.FindExport('RARReadHeaderEx');
    @RARProcessFile        := unrar.FindExport('RARProcessFile');
    @RARSetCallback        := unrar.FindExport('RARSetCallback');
    @RARSetChangeVolProc   := unrar.FindExport('RARSetChangeVolProc');
    @RARSetProcessDataProc := unrar.FindExport('RARSetProcessDataProc');
    @RARSetPassword        := unrar.FindExport('RARSetPassword');
    @RARGetDllVersion      := unrar.FindExport('RARGetDllVersion');
  end;

end.
