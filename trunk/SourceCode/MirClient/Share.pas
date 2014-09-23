unit Share;

interface

var
  CLIENTUPDATETIME: string = '2013.01.12';


const

  RUNLOGINCODE = 0; //进入游戏状态码,默认为0 测试为 9

  STDCLIENT = 0;
  RMCLIENT = 99;
  CLIENTTYPE = 0; //普通的为0 ,99 为管理客户端

  DEFFONTNAME = 'MS Sans Serif';
  DEFFONTSIZE = 9;

  DEBUG = 0;
  {SWH800 = 0;
  SWH1024 = 1;
  SWH = SWH800;  }

  MAXLEFT2 = 10;
  MAXTOP2 = 10;
  MAXTOP3 = -14;

  BGSURFACECOLOR = 8;

  DEFSCREENWIDTH = 800;
  DEFSCREENHEIGHT = 600;
  DEFWIDESCREENWIDTH = 1024;
  DEFWIDESCREENHEIGHT = 600;
  DEFMAXSCREENWIDTH = 1024;
  DEFMAXSCREENHEIGHT = 768;

  OPERATEHINTWIDTH = 425;
  OPERATEHINTHEIGHT = 32;
  OPERATEHINTX = 335;
  OPERATEHINTY = 474;

  MISSIONHINTWIDTH = 220 + 18;
  MISSIONHINTHEIGHT = 337;
  MISSIONHINTX = -238;
  MISSIONHINTY = 169;

  //MAPSURFACEWIDTH = g_FScreenWidth;
  //MAPSURFACEHEIGHT = g_FScreenHeight;
  //MAPSURFACEHEIGHT = g_FScreenHeight - 150;

  ADDSAYHEIGHT = 16;
  //ADDSAYWHDTH = g_FScreenWidth - 600 - 5;
  ADDSAYCOUNT = 5;

  WINLEFT = 60;
  WINTOP = 60;
  //WINRIGHT = g_FScreenWidth - 60;
  //BOTTOMEDGE = g_FScreenHeight - 60; // Bottom WINBOTTOM

  //MAPDIR = 'Map\'; //地图文件所在目录
  CONFIGFILE = 'Config\%s.ini';

  MAXX = 52;
  MAXY = 40;

 // MAXX = g_FScreenWidth div 20;
 // MAXY = g_FScreenWidth div 20;

  DEFAULTCURSOR = 0; //系统默认光标
  IMAGECURSOR = 1; //图形光标

  USECURSOR = IMAGECURSOR; //使用什么类型的光标

  {  MAXBAGITEMCL = 52;}
  MAXFONT = 8;
  ENEMYCOLOR = 69;
  ALLYCOLOR = 180;

  crMyNone = 1;
  crMyAttack = 2;
  crMyDialog = 3;
  crMyBuy = 4;
  crMySell = 5;
  crMyRepair = 6;
  crMySelItem = 7;
  crMyDeal = 8;
  crOpenBox = 9;
  crSrepair = 10;

var
  g_FScreenMode: Byte = 0;
  g_FScreenWidth: Integer = DEFSCREENWIDTH;
  g_FScreenHeight: Integer = DEFSCREENHEIGHT;


Type
  TCursorMode = (cr_None, cr_Buy, cr_Sell, cr_Repair, cr_SelItem, cr_Deal, cr_Srepair);

var
  g_CursorMode: TCursorMode = cr_None;
  TestTick2: LongWord;
  g_CanTab: Boolean = True;

function GetStrengthenText(nMasterLevel, nLevel: Integer): string;

implementation

uses
SysUtils;

function GetStrengthenText(nMasterLevel, nLevel: Integer): string;
begin
  Result := '';
  case nMasterLevel of
    3: begin
      case nLevel of
        0..2: Result := Format('Accuracy +%d', [nLevel + 1]);
        3..7: Result := Format('Health +%d', [(nLevel - 2) * 10]);
        8..12: Result := Format('Mana +%d', [(nLevel - 7) * 10]);
        13..15: Result := Format('Agility +%d', [nLevel - 12]);
      end;
    end;
    6: begin
      case nLevel of
        0..4: Result := Format('Element AC +%d', [nLevel + 1]) + '%';
        5..14: Result := Format('Experience Bonus +%d', [nLevel - 4]) + '%';
        15..19: Result := Format('Element Hit +%d', [nLevel - 14]) + '%';
      end;
    end;
    9: begin
      case nLevel of
        0..2:   Result := Format('AC +%d', [nLevel + 1]) + '%';
        3..5:   Result := Format('MAC +%d', [nLevel - 2]) + '%';
        6..10:  Result := Format('DC +%d', [nLevel - 5]);
        11..15: Result := Format('SC +%d', [nLevel - 10]);
        16..20: Result := Format('MC +%d', [nLevel - 15]);
      end;
    end;
    12: begin
      case nLevel of
        0..2: Result := Format('Bonus Damage +%d', [nLevel + 1]) + '%';
        3..11: Result := Format('Maximum Life Magic +%d', [nLevel - 1]) + '%';
        12..14: Result := Format('Damage Absorption +%d', [nLevel - 11]) + '%';
      end;
    end;
    15: begin
      case nLevel of
        0..2: Result := Format('Critical Hit +%d', [nLevel + 1]) + '%';
        3..23: Result := Format('DC,MC,SC +%d Points', [nLevel + 7]);
      end;
    end;
    18: begin
      case nLevel of
        0..5: Result := Format('Reduce Dura Loss %d0', [nLevel + 4]) + '%';
      end;
    end;
  end;
end;
 {
function GetStrengthenText(nMasterLevel, nLevel: Integer): string;
begin
  Result := '';
  case nMasterLevel of
    3: begin
      case nLevel of
        0, 1: Result := Format('最大生命值增加：%d点', [(nLevel + 1) * 10]);
        2, 3: Result := Format('最大魔法值增加：%d点', [(nLevel - 1) * 10]);
        4: Result := '体力恢复增加：10%';
        5: Result := '魔法恢复增加：10%';
        6: Result := '毒物恢复增加：10%';
      end;
    end;
    6: begin
      case nLevel of
        0: Result := '准确增加：1点';
        1: Result := '敏捷增加：1点';
        2..5: Result := Format('五行防御增加：%d', [nLevel]) + '%';
        6..9: Result := Format('五行伤害增加：%d', [nLevel - 4]) + '%';
      end;
    end;
    9: begin
      case nLevel of
        0..3:   Result := Format('最高防御增加：%d点', [nLevel + 2]);
        4..7:   Result := Format('最高魔御增加：%d点', [nLevel - 2]);
        8..11:  Result := Format('最高攻击增加：%d点', [nLevel - 6]);
        12..15: Result := Format('最高道术增加：%d点', [nLevel - 10]);
        16..19: Result := Format('最高魔法增加：%d点', [nLevel - 14]);
      end;
    end;
    12: begin
      case nLevel of
        0: Result := '魔法躲避增加：10%';
        1: Result := '毒物躲避增加：10%';
        2..4: Result := Format('伤害加成增加：%d', [nLevel - 1]) + '%';
        5..7: Result := Format('伤害吸收增加：%d', [nLevel - 4]) + '%';
      end;
    end;
    15: begin
      case nLevel of
        0..2: Result := Format('致命一击增加：%d', [nLevel + 1]) + '%';
      end;
    end;
    18: begin
      case nLevel of
        0..5: Result := Format('掉落机率减少：%d0', [nLevel + 4]) + '%';
        //6: Result := '永不掉落，不可交易，不可丢弃';
      end;
    end;
  end;
end;     }

end.


