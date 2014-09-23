unit Share;

interface
uses
Windows,Classes,EngineType;

const
  SHOPLISTNAME  = 'ShopItemList.txt';
  STATUSTEXT: array[Boolean] of String[2] = (' ', '¡Ì');

type
  pTGameGoldChange = ^TGameGoldChange;
  TGameGoldChange = packed record
    nGoldCount: Integer;
    boAdd: Boolean;
    nIndex: Byte;
    ItemIndex: Integer;
    ItemName: string[14];
  end;

var
  ProcessHumanCriticalSection: PRTLCriticalSection;
  m_ShopItemList: array[0..5] of TList;
  m_ShopShowIdx: array[0..5] of Word; 
  OldPlayObjectOperateMessage: _TOBJECTOPERATEMESSAGE;
  m_GoldChangeList: TList;

implementation

initialization
begin

end;

finalization
begin

end;


end.
