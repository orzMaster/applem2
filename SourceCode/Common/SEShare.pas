unit SEShare;

interface

const
  EXEDIRNAME = '1EXE\';
  
  MSGHEADCODE = $AA55AA55;

  SEC_CHECKPASS = 1000;
  SEC_GETFILELIST = 1001;
  SEC_GETFILE = 1002;
  SEC_PASS_GETFILE = 1004;

  SES_CHECKPASS_OK = 10000;
  SES_CHECKPASS_FAIR = 10001;
  SES_FILELIST = 10002;
  SES_FILE = 10003;
  SEC_PASS_GETFILE_FAIL = 10004;

type
  pTDefMessage = ^TDefMessage;
  TDefMessage = packed record
    Recog: LongWord;
    Ident: Word;
    Param: Integer;
    DataTime: TDateTime;
    DataSize: Integer;
  end;

function MakeDefMessage(wIdent: Word; nParam: Integer; DataTime: TDateTime; DataSize: Integer): TDefMessage;

implementation

function MakeDefMessage(wIdent: Word; nParam: Integer; DataTime: TDateTime; DataSize: Integer): TDefMessage;
begin
  FillChar(Result, SizeOf(Result), #0);
  Result.Recog := MSGHEADCODE;
  Result.Ident := wIdent;
  Result.Param := nParam;
  Result.DataTime := DataTime;
  Result.DataSize := DataSize;
end;

end.

