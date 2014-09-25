unit LogShare;

interface
uses
  Windows, Messages, SysUtils;

const
  GS_QUIT = 2000;
  SG_FORMHANDLE=1000;//Server HANLD
  SG_STARTNOW=1001;  //Starting the server...
  SG_STARTOK=1002;   //Start complete...

  tLogServer = 2;

  ADODBString = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False';
  ADODBSQL =
    'INSERT INTO Log (Action,Maps,X Coordinate,Y Coordinate,Character Name,Item Name,Item ID,Item Number,Transaction,Note 1,Note 2,Note 3) values (%s,'#39'%s'#39',%s,%s,'#39'%s'#39','#39'%s'#39',%s,%s,'#39'%s'#39','#39'%s'#39','#39'%s'#39','#39'%s'#39')';

type
  TLogClass = record
    sLogName: string[20];
    nLogIdx: Byte;
  end;
var
  sBaseDir: string = '.\BaseDir\';
  sServerName: string = 'Gameofmir';
  sCaption: string = 'LogDataServer';
  g_dwGameCenterHandle: THandle;
  nServerPort: Integer = 10000;
  g_boTeledata: Boolean = False;

  m_LogList: array[0..12] of TLogClass = (
    (sLogName: 'People Died'; nLogIdx: 0),
    (sLogName: 'Gold Change'; nLogIdx: 1),
    (sLogName: 'Bind Gold Change'; nLogIdx: 2),
    (sLogName: 'Point Volume Change'; nLogIdx: 3),
    (sLogName: 'Ingot Change'; nLogIdx: 4),
    (sLogName: 'Integral Change'; nLogIdx: 5),
    (sLogName: 'Number of Change'; nLogIdx: 6),
    (sLogName: 'Increase in Goods'; nLogIdx: 7),
    (sLogName: 'Reduce the Items'; nLogIdx: 8),
    (sLogName: 'Warehouse Access'; nLogIdx: 9),
    (sLogName: 'Strengthening Change'; nLogIdx: 10),
    (sLogName: 'Adjustment Items'; nLogIdx: 11),
    (sLogName: 'Prestige Change'; nLogIdx: 12)
  );

procedure SendGameCenterMsg(wIdent: Word; sSendMsg: string);
implementation

procedure SendGameCenterMsg(wIdent: Word; sSendMsg: string);
var
  SendData: TCopyDataStruct;
  nParam: Integer;
begin
  nParam := MakeLong(Word(tLogServer), wIdent);
  SendData.cbData := Length(sSendMsg) + 1;
  GetMem(SendData.lpData, SendData.cbData);
  StrCopy(SendData.lpData, PChar(sSendMsg));
  SendMessage(g_dwGameCenterHandle, WM_COPYDATA, nParam, Cardinal(@SendData));
  FreeMem(SendData.lpData);
end;

end.

