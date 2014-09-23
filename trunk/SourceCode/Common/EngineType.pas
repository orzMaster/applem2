unit EngineType;

interface
uses
  Windows, grobal2;
const
  LibName = 'M2Server.exe';
  MAPNAMELEN = 16;
  ACTORNAMELEN = 14;
  MAXPATHLEN = 255;
  DIRPATHLEN = 80;

  MODULE_USERLOGINEND = 1;
  MODULE_PLAYOPERATEMESSAGE = 2;
  MODULE_USERLOADANDSAVE = 3;
  MODULE_PLAYOBJECTMAKEGHOST = 4;
  MODULE_USERLOGINSTART = 5;

resourcestring
  g_sGameLogMsg1 = '%d'#9'%s'#9'%d'#9'%d'#9'%s'#9'%s'#9'%d'#9'%s'#9'%s';

type

  _TBANKPWD = string[6];
  _LPTBANKPWD = ^_TBANKPWD;
  _TMAPNAME = string[MAPNAMELEN];
  _LPTMAPNAME = ^_TMAPNAME;
  _TACTORNAME = string[ACTORNAMELEN];
  _LPTACTORNAME = ^_TACTORNAME;
  _TPATHNAME = string[MAXPATHLEN];
  _LPTPATHNAME = ^_TPATHNAME;
  _TDIRNAME = string[DIRPATHLEN];
  _LPTDIRNAME = ^_TDIRNAME;

  _TMSGCOLOR = TMSGCOLOR;
  _TMSGTYPE = TMSGTYPE;

  TAPIList = TObject;
  TAPIStringList = TObject;
  TBaseObject = TObject;
  TPlayObject = TObject;
  TNormNpc = TObject;
  TMerchant = TObject;
  TEnvirnoment = TObject;
  TUserEngine = TObject;
  TMagicManager = TObject;
  TGuild = TObject;
  //TItem         = TObject;

  _TSHORTSTRING = packed record
    btLen: Byte;
    Strings: array[0..High(Byte) - 1] of Char;
  end;

  _LPTSHORTSTRING = _LPTPATHNAME;

  _LPTDEFAULTMESSAGE = PTDEFAULTMESSAGE;
  _LPTSTDITEM = PTSTDITEM;
  _LPTUSERMAGIC = PTUSERMAGIC;
  _LPTABILITY = PTABILITY;
  _LPTPLAYUSEITEMS = PTPLAYUSEITEMS;
  _LPTUSERITEM = PTUSERITEM;
  //_TCLIENTITEM = TCLIENTITEM;
  _TDEFAULTMESSAGE = TDEFAULTMESSAGE;
  _TSTDITEM = TSTDITEM;
  _LPCHECKMSG = PTCHECKMSG;
  _TCHECKMSGCLASS = TCHECKMSGCLASS;

  _TOBJECTACTION = procedure(PlayObject: TObject); stdcall;
  _TOBJECTENGINE = procedure(UserEngine: TUserEngine); stdcall;
  _TOBJECTACTIONEX = function(PlayObject: TObject): Boolean; stdcall;
  _TOBJECTACTIONXY = procedure(AObject, BObject: TObject; nX, nY: Integer); stdcall;
  _TOBJECTACTIONXYD = procedure(AObject, BObject: TObject; nX, nY: Integer; btDir: Byte); stdcall;
  _TOBJECTACTIONXYDM = procedure(AObject, BObject: TObject; nX, nY: Integer; btDir: Byte; nMode: Integer); stdcall;
  _TOBJECTACTIONXYDWS = procedure(AObject, BObject: TObject; wIdent: Word; nX, nY: Integer; btDir: Byte;
    pszMsg: PChar); stdcall;
  _TOBJECTACTIONOBJECT = procedure(AObject, BObject, CObject: TObject; nInt: Integer); stdcall;
  _TOBJECTACTIONDETAILGOODS = procedure(Merchant: TObject; PlayObject: TObject; pszItemName: PChar; nInt: Integer);
  stdcall;
  _TOBJECTUSERCMD = function(AObject: TObject; pszCmd, pszParam1, pszParam2, pszParam3, pszParam4, pszParam5,
    pszParam6, pszParam7: PChar): Boolean; stdcall;
  _TPLAYSENDSOCKET = function(AObject: TObject; DefMsg: _LPTDEFAULTMESSAGE; pszMsg: PChar): Boolean; stdcall;
  _TOBJECTACTIONITEM = function(AObject: TObject; pszItemName: PChar): Boolean; stdcall;
  _TOBJECTCLIENTMSG = function(PlayObject: TObject; DefMsg: _LPTDEFAULTMESSAGE; Buff: PChar): Integer; stdcall;
  _TOBJECTACTIONFEATURE = function(AObject, BObject: TObject): Integer; stdcall;
  _TOBJECTACTIONSENDGOODS = procedure(AObject: TObject; nNpcRecog, nCount, nPostion: Integer; pszData: PChar); stdcall;
  _TOBJECTACTIONCHECKUSEITEM = function(nIdx: Integer; StdItem: _LPTSTDITEM): Boolean; stdcall;

  _TOBJECTACTIONENTERMAP = function(AObject: TObject; Envir: TObject; nX, nY: Integer): Boolean; stdcall;
  _TOBJECTFILTERMSG = procedure(PlayObject: TObject; pszSrcMsg: PChar; pszDestMsg: PChar; nDestLen: Integer); stdcall;

  _TEDCODE = procedure(pszSource: PChar; pszDest: PChar; nSrcLen, nDestLen: Integer); stdcall;
  _TDOSPELL = function(AObject: TObject; PlayObject: TPlayObject; UserMagic: _LPTUSERMAGIC; nTargetX, nTargetY: Integer;
    TargeTBaseObject: TBaseObject; varnHookStatus: Integer): Boolean; stdcall;

  _TSCRIPTCMD = function(pszCmd: PChar): Integer; stdcall;

  _TSCRIPTACTION = procedure(Npc: TObject;
    PlayObject: TObject;
    nCmdCode: Integer;
    pszParam1: PChar;
    nParam1: Integer;
    pszParam2: PChar;
    nParam2: Integer;
    pszParam3: PChar;
    nParam3: Integer;
    pszParam4: PChar;
    nParam4: Integer;
    pszParam5: PChar;
    nParam5: Integer;
    pszParam6: PChar;
    nParam6: Integer); stdcall;
  _TSCRIPTCONDITION = function(Npc: TObject;
    PlayObject: TObject;
    nCmdCode: Integer;
    pszParam1: PChar;
    nParam1: Integer;
    pszParam2: PChar;
    nParam2: Integer;
    pszParam3: PChar;
    nParam3: Integer;
    pszParam4: PChar;
    nParam4: Integer;
    pszParam5: PChar;
    nParam5: Integer;
    pszParam6: PChar;
    nParam6: Integer): Boolean; stdcall;

  _TOBJECTUSERLOADANDSAVE = procedure(boLoad, boLoadFail, boRun, boGhost: Boolean; nDBIndex: Integer); stdcall;

  _TOBJECTOPERATEMESSAGE = function(BaseObject: TObject;
    wIdent: Word;
    wParam: Word;
    nParam1: Integer;
    nParam2: Integer;
    nParam3: Integer;
    MsgObject: TObject;
    dwDeliveryTime: LongWord;
    pszMsg: PChar;
    var boReturn: Boolean): Boolean; stdcall;

  _TOBJECTUSERDATAMESSAGE = procedure(BaseObject: TObject;
    wIdent: Word;
    wParam: Word;
    nParam1: Integer;
    nParam2: Integer;
    nParam3: Integer;
    pszMsg: PChar); stdcall;

implementation

end.

