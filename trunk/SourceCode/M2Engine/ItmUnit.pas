unit ItmUnit;

interface
uses
  Windows, Classes, SysUtils, SDK, Grobal2;
type
  pTUnsealItem = ^TUnsealItem;
  TUnsealItem = packed record
    nAC: Word;
    nMAC: Word;
    nDC: Word;
    nMC: Word;
    nSC: Word;
    nRate: Word;
  end;

  TItemUnit = class
  private
    function GetRandomRange(nCount, nRate: Integer): Integer;
    procedure RandomBasic(UserItem: pTUserItem; UnsealItem: pTUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
    procedure RandomHorseArmBasic(UserItem: pTUserItem; UnsealItem: pTUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
  public
    constructor Create();
    destructor Destroy; override;
    function GetItemAddValue(PlayWuXin: Byte; UserItem: pTUserItem; var StdItem: TStdItem): Boolean;
    procedure RandomUpgradeItem(Item: pTUserItem; UnsealItem: TUnsealItem);
    procedure RandomUpgradeHelmet(UserItem: pTUserItem; UnsealItem: TUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
    procedure RandomUpgradeWeapon(UserItem: pTUserItem; UnsealItem: TUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
    procedure RandomUpgradeDress(UserItem: pTUserItem; UnsealItem: TUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
    procedure RandomUpgradeNecklace(UserItem: pTUserItem; UnsealItem: TUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
    procedure RandomUpgradeArmRing(UserItem: pTUserItem; UnsealItem: TUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
    procedure RandomUpgradeRing(UserItem: pTUserItem; UnsealItem: TUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
    procedure RandomUpgradeBelt(UserItem: pTUserItem; UnsealItem: TUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
    procedure RandomUpgradeBoot(UserItem: pTUserItem; UnsealItem: TUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
    procedure RandomUpgradeHorseArm(UserItem: pTUserItem; UnsealItem: TUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
  end;

var
  DefUnsealItem: TUnsealItem = (
    nAC: 0;
    nMAC: 0;
    nDC: 0;
    nMC: 0;
    nSC: 0;
    nRate: 0;
  );
implementation

uses HUtil32, M2Share;

{ TItemUnit }

constructor TItemUnit.Create;
begin
  //
end;

destructor TItemUnit.Destroy;
begin
  inherited;
end;


procedure TItemUnit.RandomBasic(UserItem: pTUserItem; UnsealItem: PTUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
begin
  if Random(UpgradeRate.nACAddRate - (_MIN(UnsealItem.nAC div 10, Round(UpgradeRate.nACAddRate * 0.6)))) = 0 then begin
    UserItem.Value.btValue[tb_AC2] := GetRandomRange(UpgradeRate.nACMaxLimit, UpgradeRate.nACAddValueRate);
  end;
  if Random(UpgradeRate.nMACAddRate - (_MIN(UnsealItem.nMAC div 10, Round(UpgradeRate.nMACAddRate * 0.6)))) = 0 then begin
    UserItem.Value.btValue[tb_MAC2] := GetRandomRange(UpgradeRate.nMACMaxLimit, UpgradeRate.nMACAddValueRate);
  end;
  if Random(UpgradeRate.nDCAddRate - (_MIN(UnsealItem.nDC div 15, Round(UpgradeRate.nDCAddRate * 0.6)))) = 0 then begin
    UserItem.Value.btValue[tb_DC2] := GetRandomRange(UpgradeRate.nDCMaxLimit, UpgradeRate.nDCAddValueRate);
  end;
  if Random(UpgradeRate.nMCAddRate - (_MIN(UnsealItem.nMC div 10, Round(UpgradeRate.nMCAddRate * 0.6)))) = 0 then begin
    UserItem.Value.btValue[tb_MC2] := GetRandomRange(UpgradeRate.nMCMaxLimit, UpgradeRate.nMCAddValueRate);
  end;
  if Random(UpgradeRate.nSCAddRate - (_MIN(UnsealItem.nSC div 10, Round(UpgradeRate.nSCAddRate * 0.6)))) = 0 then begin
    UserItem.Value.btValue[tb_SC2] := GetRandomRange(UpgradeRate.nSCMaxLimit, UpgradeRate.nSCAddValueRate);
  end;
end;

procedure TItemUnit.RandomHorseArmBasic(UserItem: pTUserItem; UnsealItem: pTUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
begin
  if Random(UpgradeRate.nACAddRate - (_MIN(UnsealItem.nAC div 10, Round(UpgradeRate.nACAddRate * 0.6)))) = 0 then begin
    UserItem.Value.btValue[tb_AC2] := GetRandomRange(UpgradeRate.nACMaxLimit, UpgradeRate.nACAddValueRate);
  end;
  if Random(UpgradeRate.nMACAddRate - (_MIN(UnsealItem.nMAC div 10, Round(UpgradeRate.nMACAddRate * 0.6)))) = 0 then begin
    UserItem.Value.btValue[tb_MAC2] := GetRandomRange(UpgradeRate.nMACMaxLimit, UpgradeRate.nMACAddValueRate);
  end;
  if Random(UpgradeRate.nDCAddRate - (_MIN(UnsealItem.nDC div 15, Round(UpgradeRate.nDCAddRate * 0.6)))) = 0 then begin
    UserItem.Value.btValue[tb_DC2] := GetRandomRange(UpgradeRate.nDCMaxLimit, UpgradeRate.nDCAddValueRate);
  end;
end;

//手镯
procedure TItemUnit.RandomUpgradeArmRing(UserItem: pTUserItem; UnsealItem: TUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
Const
  EspecialCount = 8;
  EspecialArr: array[0..EspecialCount - 1] of Byte = (tb_HealthRecover, tb_SpellRecover,
    tb_PoisonRecover, tb_AddAttack, tb_DelDamage, tb_Deadliness, tb_Hit, tb_Speed);
var
  nC, n10, nCCRate: Integer;
begin
  RandomBasic(UserItem, @UnsealItem, UpgradeRate);
  nCCRate := UpgradeRate.nCCAddRate;
  if UnsealItem.nRate > 0 then begin
    Try
      nCCRate := Round((1 - (_MIN(UnsealItem.nRate, 60) / 100)) * nCCRate);
    Except
      nCCRate := UpgradeRate.nCCAddRate;
    End;
  end;

  if Random(nCCRate) = 0 then begin
    nC := GetRandomRange(UpgradeRate.nCCMaxLimit, UpgradeRate.nCCAddValueRate);
    if Random(UpgradeRate.nCCAddRate) = 0 then begin
      UserItem.Value.btValue[EspecialArr[Random(EspecialCount)]] := nC;
    end else begin
      while nC > 0 do begin
        Inc(UserItem.Value.btValue[EspecialArr[Random(EspecialCount)]]);
        Dec(nC);
      end;
    end;
  end;

  nC := GetRandomRange(6, 12);
  if Random(20) < 15 then begin
    n10 := (nC + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;

//腰带
procedure TItemUnit.RandomUpgradeBelt(UserItem: pTUserItem; UnsealItem: TUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
Const
  EspecialCount = 7;
  EspecialArr: array[0..EspecialCount - 1] of Byte = (tb_HealthRecover, tb_SpellRecover, tb_PoisonRecover,
    tb_AddAttack, tb_DelDamage, tb_Deadliness, tb_Hit);
var
  nC, n10, nCCRate: Integer;
begin
  RandomBasic(UserItem, @UnsealItem, UpgradeRate);
  nCCRate := UpgradeRate.nCCAddRate;
  if UnsealItem.nRate > 0 then begin
    Try
      nCCRate := Round((1 - (_MIN(UnsealItem.nRate, 60) / 100)) * nCCRate);
    Except
      nCCRate := UpgradeRate.nCCAddRate;
    End;
  end;

  if Random(nCCRate) = 0 then begin
    nC := GetRandomRange(UpgradeRate.nCCMaxLimit, UpgradeRate.nCCAddValueRate);
    if Random(UpgradeRate.nCCAddRate) = 0 then begin
      UserItem.Value.btValue[EspecialArr[Random(EspecialCount)]] := nC;
    end else begin
      while nC > 0 do begin
        Inc(UserItem.Value.btValue[EspecialArr[Random(EspecialCount)]]);
        Dec(nC);
      end;
    end;
  end;

  nC := GetRandomRange(6, 12);
  if Random(20) < 15 then begin
    n10 := (nC + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;


//靴子
procedure TItemUnit.RandomUpgradeBoot(UserItem: pTUserItem; UnsealItem: TUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
Const
  EspecialCount = 7;
  EspecialArr: array[0..EspecialCount - 1] of Byte = (tb_HealthRecover, tb_SpellRecover, tb_PoisonRecover,
    tb_AddAttack, tb_DelDamage, tb_Deadliness, tb_Speed);
var
  nC, n10, nCCRate: Integer;
begin
  RandomBasic(UserItem, @UnsealItem, UpgradeRate);
  nCCRate := UpgradeRate.nCCAddRate;
  if UnsealItem.nRate > 0 then begin
    Try
      nCCRate := Round((1 - (_MIN(UnsealItem.nRate, 60) / 100)) * nCCRate);
    Except
      nCCRate := UpgradeRate.nCCAddRate;
    End;
  end;

  if Random(nCCRate) = 0 then begin
    nC := GetRandomRange(UpgradeRate.nCCMaxLimit, UpgradeRate.nCCAddValueRate);
    if Random(UpgradeRate.nCCAddRate) = 0 then begin
      UserItem.Value.btValue[EspecialArr[Random(EspecialCount)]] := nC;
    end else begin
      while nC > 0 do begin
        Inc(UserItem.Value.btValue[EspecialArr[Random(EspecialCount)]]);
        Dec(nC);
      end;
    end;
  end;

  nC := GetRandomRange(6, 12);
  if Random(20) < 15 then begin
    n10 := (nC + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;

//衣服
procedure TItemUnit.RandomUpgradeDress(UserItem: pTUserItem; UnsealItem: TUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
Const
  EspecialCount = 6;
  EspecialArr: array[0..EspecialCount - 1] of Byte = (tb_HealthRecover, tb_SpellRecover, tb_PoisonRecover,
    tb_AddAttack, tb_DelDamage, tb_Deadliness);
var
  nC, n10, nCCRate: Integer;
begin
  RandomBasic(UserItem, @UnsealItem, UpgradeRate);
  nCCRate := UpgradeRate.nCCAddRate;
  if UnsealItem.nRate > 0 then begin
    Try
      nCCRate := Round((1 - (_MIN(UnsealItem.nRate, 60) / 100)) * nCCRate);
    Except
      nCCRate := UpgradeRate.nCCAddRate;
    End;
  end;

  if Random(nCCRate) = 0 then begin
    nC := GetRandomRange(UpgradeRate.nCCMaxLimit, UpgradeRate.nCCAddValueRate);
    if Random(UpgradeRate.nCCAddRate) = 0 then begin
      UserItem.Value.btValue[EspecialArr[Random(EspecialCount)]] := nC;
    end else begin
      while nC > 0 do begin
        Inc(UserItem.Value.btValue[EspecialArr[Random(EspecialCount)]]);
        Dec(nC);
      end;
    end;
  end;

  nC := GetRandomRange(6, 10);
  if Random(8) < 6 then begin
    n10 := (nC + 1) * 2000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;

//头盔
procedure TItemUnit.RandomUpgradeHelmet(UserItem: pTUserItem; UnsealItem: TUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
Const
  EspecialCount = 6;
  EspecialArr: array[0..EspecialCount - 1] of Byte = (tb_HealthRecover, tb_SpellRecover, tb_PoisonRecover,
    tb_AddAttack, tb_DelDamage, tb_Deadliness);
var
  nC, n10, nCCRate: Integer;
begin
  RandomBasic(UserItem, @UnsealItem, UpgradeRate);
  nCCRate := UpgradeRate.nCCAddRate;
  if UnsealItem.nRate > 0 then begin
    Try
      nCCRate := Round((1 - (_MIN(UnsealItem.nRate, 60) / 100)) * nCCRate);
    Except
      nCCRate := UpgradeRate.nCCAddRate;
    End;
  end;

  if Random(nCCRate) = 0 then begin
    nC := GetRandomRange(UpgradeRate.nCCMaxLimit, UpgradeRate.nCCAddValueRate);
    if Random(UpgradeRate.nCCAddRate) = 0 then begin
      UserItem.Value.btValue[EspecialArr[Random(EspecialCount)]] := nC;
    end else begin
      while nC > 0 do begin
        Inc(UserItem.Value.btValue[EspecialArr[Random(EspecialCount)]]);
        Dec(nC);
      end;
    end;
  end;

  nC := GetRandomRange(6, 12);
  if Random(4) < 3 then begin
    n10 := (nC + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;

procedure TItemUnit.RandomUpgradeHorseArm(UserItem: pTUserItem; UnsealItem: TUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
var
  nC, nCCRate: Integer;
begin
  RandomHorseArmBasic(UserItem, @UnsealItem, UpgradeRate);
  nCCRate := UpgradeRate.nCCAddRate;
  if UnsealItem.nRate > 0 then begin
    Try
      nCCRate := Round((1 - (_MIN(UnsealItem.nRate, 60) / 100)) * nCCRate);
    Except
      nCCRate := UpgradeRate.nCCAddRate;
    End;
  end;

  if Random(nCCRate) = 0 then begin
    nC := GetRandomRange(UpgradeRate.nCCMaxLimit, UpgradeRate.nCCAddValueRate);
    if Random(UpgradeRate.nCCAddRate) = 0 then begin
      UserItem.Value.btValue[tb_HP] := nC;
    end else begin
      while nC > 0 do begin
        Inc(UserItem.Value.btValue[tb_HP]);
        Dec(nC);
      end;
    end;
  end;
end;

procedure TItemUnit.RandomUpgradeItem(Item: pTUserItem; UnsealItem: TUnsealItem);
var
  StdItem: pTStdItem;
  nMaxCount, nCount: Byte;
  AddWuXinAttack, DelWuXinAttack: Byte;
begin
  StdItem := UserEngine.GetStdItem(Item.wIndex);
  if StdItem = nil then Exit;
  if sm_HorseArm in StdItem.StdModeEx then begin
    case StdItem.StdMode of
      tm_Rein: RandomUpgradeHorseArm(Item, UnsealItem, @g_Config.IRein);
      tm_Bell: RandomUpgradeHorseArm(Item, UnsealItem, @g_Config.IBell);
      tm_Saddle: RandomUpgradeHorseArm(Item, UnsealItem, @g_Config.ISaddle);
      tm_Decoration: RandomUpgradeHorseArm(Item, UnsealItem, @g_Config.IDecoration);
      tm_Nail: RandomUpgradeHorseArm(Item, UnsealItem, @g_Config.INail);
    end;
  end else begin
    if not (sm_ArmingStrong in StdItem.StdModeEx) then Exit;
    Item.DuraMax := StdItem.DuraMax;
    AddWuXinAttack := Item.Value.btValue[tb_AddWuXinAttack];
    DelWuXinAttack := Item.Value.btValue[tb_DelWuXinAttack];
    SafeFillChar(Item.Value.btValue, SizeOf(Item.Value.btValue), #0);
    Item.Dura := ROUND((Item.DuraMax / 100) * (20 + Random(80)));
    case StdItem.StdMode of
      tm_Helmet: RandomUpgradeHelmet(Item, UnsealItem, @g_Config.IHelmet);
      tm_Weapon: RandomUpgradeWeapon(Item, UnsealItem, @g_Config.IWeapon);
      tm_Dress: RandomUpgradeDress(Item, UnsealItem, @g_Config.IDress);
      tm_Necklace: RandomUpgradeNecklace(Item, UnsealItem, @g_Config.INecklace);
      tm_Ring: RandomUpgradeRing(Item, UnsealItem, @g_Config.IRing);
      tm_ArmRing: RandomUpgradeArmRing(Item, UnsealItem, @g_Config.IArmRing);
      tm_Belt: RandomUpgradeBelt(Item, UnsealItem, @g_Config.IBelt);
      tm_Boot: RandomUpgradeBoot(Item, UnsealItem, @g_Config.IBoot);
    end;
    if CheckItemBindMode(Item, bm_Unknown) and (Item.Value.btWuXin = 0) then begin
      Item.Value.btWuXin := Random(5) + 1;
      RandomInitializeStrengthenInfo(Item);
      if g_Config.nWuXinMinRate > g_Config.nWuXinMaxRate then
        g_Config.nWuXinMaxRate := g_Config.nWuXinMinRate;
      nMaxCount := Random(g_Config.nWuXinMaxRate - g_Config.nWuXinMinRate + 1) + g_Config.nWuXinMinRate;
      nCount := Random(nMaxCount + 1);
      if nCount = 0 then Item.Value.btValue[tb_DelWuXinAttack] := nMaxCount
      else if nCount = nMaxCount then Item.Value.btValue[tb_AddWuXinAttack] := nMaxCount
      else begin
        Item.Value.btValue[tb_AddWuXinAttack] := nCount;
        Item.Value.btValue[tb_DelWuXinAttack] := _MAX(nMaxCount - nCount, 0);
      end;
      Item.Value.btFluteCount := 0;
      if g_Config.boOpenItemFlute then
      begin
        if Random(g_Config.nFlute3RateValue) = 0 then
          Item.Value.btFluteCount := 3
        else if Random(g_Config.nFlute2RateValue) = 0 then
          Item.Value.btFluteCount := 2
        else if Random(g_Config.nFlute1RateValue) = 0 then
          Item.Value.btFluteCount := 1;
      end;
    end else begin
      Item.Value.btValue[tb_AddWuXinAttack] := AddWuXinAttack;
      Item.Value.btValue[tb_DelWuXinAttack] := DelWuXinAttack;
    end;
  end;
  SetByteStatus(Item.btBindMode2, Ib2_Unknown, False);
end;

//项链
procedure TItemUnit.RandomUpgradeNecklace(UserItem: pTUserItem; UnsealItem: TUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
Const
  EspecialCount = 9;
  EspecialArr: array[0..EspecialCount - 1] of Byte = (tb_AntiMagic, tb_PoisonMagic,
    tb_HealthRecover, tb_SpellRecover, tb_PoisonRecover, tb_Luck, tb_AddAttack, tb_DelDamage, tb_Deadliness);
var
  nC, n10, nCCRate: Integer;
begin
  RandomBasic(UserItem, @UnsealItem, UpgradeRate);
  nCCRate := UpgradeRate.nCCAddRate;
  if UnsealItem.nRate > 0 then begin
    Try
      nCCRate := Round((1 - (_MIN(UnsealItem.nRate, 60) / 100)) * nCCRate);
    Except
      nCCRate := UpgradeRate.nCCAddRate;
    End;
  end;

  if Random(nCCRate) = 0 then begin
    nC := GetRandomRange(UpgradeRate.nCCMaxLimit, UpgradeRate.nCCAddValueRate);
    if Random(UpgradeRate.nCCAddRate) = 0 then begin
      UserItem.Value.btValue[EspecialArr[Random(EspecialCount)]] := nC;
    end else begin
      while nC > 0 do begin
        Inc(UserItem.Value.btValue[EspecialArr[Random(EspecialCount)]]);
        Dec(nC);
      end;
    end;
  end;

  nC := GetRandomRange(6, 12);
  if Random(20) < 15 then begin
    n10 := (nC + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;

//戒指
procedure TItemUnit.RandomUpgradeRing(UserItem: pTUserItem; UnsealItem: TUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
Const
  EspecialCount = 6;
  EspecialArr: array[0..EspecialCount - 1] of Byte = (tb_HealthRecover, tb_SpellRecover, tb_PoisonRecover,
    tb_AddAttack, tb_DelDamage, tb_Deadliness);
var
  nC, n10, nCCRate: Integer;
begin
  RandomBasic(UserItem, @UnsealItem, UpgradeRate);
  nCCRate := UpgradeRate.nCCAddRate;
  if UnsealItem.nRate > 0 then begin
    Try
      nCCRate := Round((1 - (_MIN(UnsealItem.nRate, 60) / 100)) * nCCRate);
    Except
      nCCRate := UpgradeRate.nCCAddRate;
    End;
  end;

  if Random(nCCRate) = 0 then begin
    nC := GetRandomRange(UpgradeRate.nCCMaxLimit, UpgradeRate.nCCAddValueRate);
    if Random(UpgradeRate.nCCAddRate) = 0 then begin
      UserItem.Value.btValue[EspecialArr[Random(EspecialCount)]] := nC;
    end else begin
      while nC > 0 do begin
        Inc(UserItem.Value.btValue[EspecialArr[Random(EspecialCount)]]);
        Dec(nC);
      end;
    end;
  end;

  nC := GetRandomRange(6, 12);
  if Random(20) < 15 then begin
    n10 := (nC + 1) * 1000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;

//武器
procedure TItemUnit.RandomUpgradeWeapon(UserItem: pTUserItem; UnsealItem: TUnsealItem; UpgradeRate: pTGameItemUpgradeRate);
Const
  EspecialCount = 6;
  EspecialArr: array[0..EspecialCount - 1] of Byte = (tb_Hit, tb_Speed, tb_Strong, tb_AddAttack, tb_DelDamage,
    tb_Deadliness);
var
  nC, n10, nCCRate: Integer;
begin
  RandomBasic(UserItem, @UnsealItem, UpgradeRate);
  nCCRate := UpgradeRate.nCCAddRate;
  if UnsealItem.nRate > 0 then begin
    Try
      nCCRate := Round((1 - (_MIN(UnsealItem.nRate, 60) / 100)) * nCCRate);
    Except
      nCCRate := UpgradeRate.nCCAddRate;
    End;
  end;

  if Random(nCCRate) = 0 then begin
    nC := GetRandomRange(UpgradeRate.nCCMaxLimit, UpgradeRate.nCCAddValueRate);
    if Random(UpgradeRate.nCCAddRate) = 0 then begin
      UserItem.Value.btValue[EspecialArr[Random(EspecialCount)]] := nC;
    end else begin
      while nC > 0 do begin
        Inc(UserItem.Value.btValue[EspecialArr[Random(EspecialCount)]]);
        Dec(nC);
      end;
    end;
  end;

  nC := GetRandomRange(12, 12);
  if Random(3) < 2 then begin
    n10 := (nC + 1) * 2000;
    UserItem.DuraMax := _MIN(65000, UserItem.DuraMax + n10);
    UserItem.Dura := _MIN(65000, UserItem.Dura + n10);
  end;
end;

function TItemUnit.GetItemAddValue(PlayWuXin: Byte; UserItem: pTUserItem; var StdItem: TStdItem): Boolean;
var
  i: integer;
  StdItemEx: pTStdItem;
begin
  Result := False;
  if sm_Arming in StdItem.StdModeEx then begin
    StdItem.AddWuXinAttack := 0;
    StdItem.DelWuXinAttack := 0;
    GetStrengthenAbility(UserItem, StdItem); //取强化装备属性
    StdItem.nAC := StdItem.nAC + UserItem.Value.btValue[tb_AC];
    StdItem.nAC2 := StdItem.nAC2 + UserItem.Value.btValue[tb_AC2];
    StdItem.nMAC := StdItem.nMAC + UserItem.Value.btValue[tb_MAC];
    StdItem.nMAC2 := StdItem.nMAC2 + UserItem.Value.btValue[tb_MAC2];
    StdItem.nDC := StdItem.nDC + UserItem.Value.btValue[tb_DC];
    StdItem.nDC2 := StdItem.nDC2 + UserItem.Value.btValue[tb_DC2];
    StdItem.nMC := StdItem.nMC + UserItem.Value.btValue[tb_MC];
    StdItem.nMC2 := StdItem.nMC2 + UserItem.Value.btValue[tb_MC2];
    StdItem.nSC := StdItem.nSC + UserItem.Value.btValue[tb_SC];
    StdItem.nSC2 := StdItem.nSC2 + UserItem.Value.btValue[tb_SC2];
    StdItem.HP := StdItem.HP + UserItem.Value.btValue[tb_HP];
    StdItem.MP := StdItem.MP + UserItem.Value.btValue[tb_MP];

    StdItem.AddAttack := StdItem.AddAttack + UserItem.Value.btValue[tb_AddAttack];
    StdItem.DelDamage := StdItem.DelDamage + UserItem.Value.btValue[tb_DelDamage];

    StdItem.HitPoint := StdItem.HitPoint + UserItem.Value.btValue[tb_Hit];
    StdItem.SpeedPoint := StdItem.SpeedPoint + UserItem.Value.btValue[tb_Speed];
    StdItem.Strong := StdItem.Strong + UserItem.Value.btValue[tb_Strong];
    StdItem.AntiMagic := StdItem.AntiMagic + UserItem.Value.btValue[tb_AntiMagic];
    StdItem.PoisonMagic := StdItem.PoisonMagic + UserItem.Value.btValue[tb_PoisonMagic];
    StdItem.HealthRecover := StdItem.HealthRecover + UserItem.Value.btValue[tb_HealthRecover];
    StdItem.SpellRecover := StdItem.SpellRecover + UserItem.Value.btValue[tb_SpellRecover];
    StdItem.PoisonRecover := StdItem.PoisonRecover + UserItem.Value.btValue[tb_PoisonRecover];
    StdItem.Deadliness := StdItem.Deadliness + UserItem.Value.btValue[tb_Deadliness]; 
    //StdItem.HitSpeed := StdItem.HitSpeed + UserItem.Value.btValue[tb_HitSpeed];
    if sm_ArmingStrong in StdItem.StdModeEx then begin
      if not g_Config.boCloseWuXin then begin
        if CheckWuXinConsistent(PlayWuXin, UserItem.Value.btWuXin) then begin
          StdItem.AddWuXinAttack := StdItem.AddWuXinAttack + UserItem.Value.btValue[tb_AddWuXinAttack];
        end
        else
        if CheckWuXinConsistent(UserItem.Value.btWuXin, PlayWuXin) then begin
          StdItem.DelWuXinAttack := StdItem.DelWuXinAttack + UserItem.Value.btValue[tb_DelWuXinAttack];
        end;
      end;

      if g_Config.boOpenItemFlute and (UserItem.Value.btFluteCount > 0) then begin
        for I := 0 to UserItem.Value.btFluteCount - 1 do begin
          if (I in [0..MAXFLUTECOUNT - 1]) then begin
            if UserItem.Value.wFlute[i] > 0 then begin
              StdItemEx := UserEngine.GetStdItem(UserItem.Value.wFlute[i]);
              if (StdItemEx <> nil) and (StdItemEx.StdMode = tm_MakeStone) and (StdItemEx.Shape = 3) then begin
                case StdItemEx.AniCount of
                  Itas_Ac: StdItem.nAC2 := StdItem.nAC2 + StdItemEx.Source;
                  Itas_Mac: StdItem.nMAC2 := StdItem.nMAC2 + StdItemEx.Source;
                  Itas_Dc: StdItem.nDC2 := StdItem.nDC2 + StdItemEx.Source;
                  Itas_Mc: StdItem.nMC2 := StdItem.nMC2 + StdItemEx.Source;
                  Itas_Sc: StdItem.nSC2 := StdItem.nSC2 + StdItemEx.Source;
                  Itas_Hp: StdItem.HP := StdItem.HP + StdItemEx.Source;
                  Itas_Mp: StdItem.MP := StdItem.MP + StdItemEx.Source;
                end;
              end;

            end;
          end else break;
        end;
      end;
    end;

    StdItem.Luck := StdItem.Luck + UserItem.Value.btValue[tb_Luck] - UserItem.Value.btValue[tb_UnLuck];
    Result := True;
  end;
end;

function TItemUnit.GetRandomRange(nCount, nRate: Integer): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to nCount - 1 do
    if Random(nRate) = 0 then
      Inc(Result);
end;

end.

