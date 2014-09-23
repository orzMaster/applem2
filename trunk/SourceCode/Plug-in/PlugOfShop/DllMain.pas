unit DllMain;

interface
uses
  Share, Windows, Classes, StrUtils, SysUtils, EngineAPI, EngineType;

procedure LoadPlug();
procedure InitPlug();
procedure UnInitPlug(boExit: Boolean);

function PlayObjectOperateMessage(BaseObject: TObject; wIdent: Word; wParam: Word;
  nParam1: Integer; nParam2: Integer; nParam3: Integer; MsgObject: TObject;
  dwDeliveryTime: LongWord; pszMsg: PChar; var boReturn: Boolean): Boolean; stdcall;

implementation
uses
  ShopEngine, Grobal2;

procedure LoadPlug();
var
  i: Integer;
begin
  m_GoldChangeList := TList.Create;
  for I := Low(m_ShopItemList) to High(m_ShopItemList) do
    m_ShopItemList[i] := TList.Create;
  for I := Low(m_ShopShowIdx) to High(m_ShopShowIdx) do m_ShopShowIdx[i] := 1;

  ProcessHumanCriticalSection := TUserEngine_GetProcessHumanCriticalSection;

  OldPlayObjectOperateMessage := TPlayObject_GetHookPlayOperateMessage();
  TPlayObject_SetHookPlayOperateMessage(PlayObjectOperateMessage);
end;

procedure InitPlug();
begin
  LoadShopList();
end;

procedure UnInitPlug(boExit: Boolean);
var
  i: Integer;
begin
  if not boExit then begin
    if not API_UnModule(MODULE_PLAYOPERATEMESSAGE, @PlayObjectOperateMessage, @OLDPLAYOBJECTOPERATEMESSAGE)
    then
      TPlayObject_SetHookPlayOperateMessage(OLDPLAYOBJECTOPERATEMESSAGE);
  end;
  ClearShopList();
  for I := Low(m_ShopItemList) to High(m_ShopItemList) do
    FreeAndNil(m_ShopItemList[i]);
  for I := 0 to m_GoldChangeList.Count - 1 do
    Dispose(pTGameGoldChange(m_GoldChangeList[i]));
  FreeAndNil(m_GoldChangeList);
end;

function PlayObjectOperateMessage(BaseObject: TObject; wIdent: Word; wParam: Word;
  nParam1: Integer; nParam2: Integer; nParam3: Integer; MsgObject: TObject;
  dwDeliveryTime: LongWord; pszMsg: PChar; var boReturn: Boolean): Boolean; stdcall;
begin
  Result := True; //该返回值暂时无作用
  boReturn := False; //返回 False 程序将不再匹配
  case wIdent of
    CM_SHOPGETLIST: GetShopItems(BaseObject, nParam1, nParam2);
    CM_SHOPBUYITEMBACK: begin
      if wParam = 0 then
        BuyShopItems(BaseObject, nParam2, nParam1, nParam3)
      else
        BuyShopItemsByPoint(BaseObject, nParam2, nParam1, nParam3);
    end;
    CM_SHOPGETGAMEPOINT: GetPoint(BaseObject, nParam1);
    RM_SHOPGAMEGOLDCHANGE: BuyShopItemsEx(BaseObject, pszMsg);
    RM_SHOPGETPOINT: GetPointEx(BaseObject, pszMsg);
  else begin
      if Assigned(OldPlayObjectOperateMessage) then begin //传递给下一个插件继续处理
        Result := OldPlayObjectOperateMessage(BaseObject, wIdent, wParam, nParam1,
          nParam2, nParam3, BaseObject, dwDeliveryTime, pszMsg, boReturn);
      end else boReturn := True; //返回 True 交给程序继续匹配
    end;
  end;
end;

end.

