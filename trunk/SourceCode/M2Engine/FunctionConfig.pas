unit FunctionConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Spin, Grids, Grobal2;

type
  TfrmFunctionConfig = class(TForm)
    FunctionConfigControl: TPageControl;
    Label14: TLabel;
    TabSheet1: TTabSheet;
    TabSheetGeneral: TTabSheet;
    ButtonGeneralSave: TButton;
    ButtonSkillSave: TButton;
    TabSheet33: TTabSheet;
    TabSheet34: TTabSheet;
    TabSheet35: TTabSheet;
    GroupBox8: TGroupBox;
    Label13: TLabel;
    EditUpgradeWeaponMaxPoint: TSpinEdit;
    Label15: TLabel;
    EditUpgradeWeaponPrice: TSpinEdit;
    Label16: TLabel;
    EditUPgradeWeaponGetBackTime: TSpinEdit;
    Label17: TLabel;
    EditClearExpireUpgradeWeaponDays: TSpinEdit;
    Label18: TLabel;
    Label19: TLabel;
    GroupBox18: TGroupBox;
    ScrollBarUpgradeWeaponDCRate: TScrollBar;
    Label20: TLabel;
    EditUpgradeWeaponDCRate: TEdit;
    Label21: TLabel;
    ScrollBarUpgradeWeaponDCTwoPointRate: TScrollBar;
    EditUpgradeWeaponDCTwoPointRate: TEdit;
    Label22: TLabel;
    ScrollBarUpgradeWeaponDCThreePointRate: TScrollBar;
    EditUpgradeWeaponDCThreePointRate: TEdit;
    GroupBox19: TGroupBox;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    ScrollBarUpgradeWeaponSCRate: TScrollBar;
    EditUpgradeWeaponSCRate: TEdit;
    ScrollBarUpgradeWeaponSCTwoPointRate: TScrollBar;
    EditUpgradeWeaponSCTwoPointRate: TEdit;
    ScrollBarUpgradeWeaponSCThreePointRate: TScrollBar;
    EditUpgradeWeaponSCThreePointRate: TEdit;
    GroupBox20: TGroupBox;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    ScrollBarUpgradeWeaponMCRate: TScrollBar;
    EditUpgradeWeaponMCRate: TEdit;
    ScrollBarUpgradeWeaponMCTwoPointRate: TScrollBar;
    EditUpgradeWeaponMCTwoPointRate: TEdit;
    ScrollBarUpgradeWeaponMCThreePointRate: TScrollBar;
    EditUpgradeWeaponMCThreePointRate: TEdit;
    ButtonUpgradeWeaponSave: TButton;
    GroupBox21: TGroupBox;
    ButtonMasterSave: TButton;
    GroupBox22: TGroupBox;
    EditMasterOKLevel: TSpinEdit;
    Label29: TLabel;
    GroupBox23: TGroupBox;
    EditMasterOKCreditPoint: TSpinEdit;
    Label30: TLabel;
    EditMasterOKBonusPoint: TSpinEdit;
    Label31: TLabel;
    GroupBox24: TGroupBox;
    ScrollBarMakeMineHitRate: TScrollBar;
    EditMakeMineHitRate: TEdit;
    Label32: TLabel;
    Label33: TLabel;
    ScrollBarMakeMineRate: TScrollBar;
    EditMakeMineRate: TEdit;
    GroupBox25: TGroupBox;
    Label34: TLabel;
    Label35: TLabel;
    ScrollBarStoneTypeRate: TScrollBar;
    EditStoneTypeRate: TEdit;
    ScrollBarGoldStoneMax: TScrollBar;
    EditGoldStoneMax: TEdit;
    Label36: TLabel;
    ScrollBarSilverStoneMax: TScrollBar;
    EditSilverStoneMax: TEdit;
    Label37: TLabel;
    ScrollBarSteelStoneMax: TScrollBar;
    EditSteelStoneMax: TEdit;
    Label38: TLabel;
    EditBlackStoneMax: TEdit;
    ScrollBarBlackStoneMax: TScrollBar;
    ButtonMakeMineSave: TButton;
    GroupBox26: TGroupBox;
    Label39: TLabel;
    EditStoneMinDura: TSpinEdit;
    Label40: TLabel;
    EditStoneGeneralDuraRate: TSpinEdit;
    Label41: TLabel;
    EditStoneAddDuraRate: TSpinEdit;
    Label42: TLabel;
    EditStoneAddDuraMax: TSpinEdit;
    TabSheet37: TTabSheet;
    GroupBox27: TGroupBox;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    ScrollBarWinLottery1Max: TScrollBar;
    EditWinLottery1Max: TEdit;
    ScrollBarWinLottery2Max: TScrollBar;
    EditWinLottery2Max: TEdit;
    ScrollBarWinLottery3Max: TScrollBar;
    EditWinLottery3Max: TEdit;
    ScrollBarWinLottery4Max: TScrollBar;
    EditWinLottery4Max: TEdit;
    EditWinLottery5Max: TEdit;
    ScrollBarWinLottery5Max: TScrollBar;
    Label48: TLabel;
    ScrollBarWinLottery6Max: TScrollBar;
    EditWinLottery6Max: TEdit;
    EditWinLotteryRate: TEdit;
    ScrollBarWinLotteryRate: TScrollBar;
    Label49: TLabel;
    GroupBox28: TGroupBox;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    EditWinLottery1Gold: TSpinEdit;
    EditWinLottery2Gold: TSpinEdit;
    EditWinLottery3Gold: TSpinEdit;
    EditWinLottery4Gold: TSpinEdit;
    Label54: TLabel;
    EditWinLottery5Gold: TSpinEdit;
    Label55: TLabel;
    EditWinLottery6Gold: TSpinEdit;
    ButtonWinLotterySave: TButton;
    TabSheet38: TTabSheet;
    GroupBox29: TGroupBox;
    Label56: TLabel;
    EditReNewNameColor1: TSpinEdit;
    LabelReNewNameColor1: TLabel;
    Label58: TLabel;
    EditReNewNameColor2: TSpinEdit;
    LabelReNewNameColor2: TLabel;
    Label60: TLabel;
    EditReNewNameColor3: TSpinEdit;
    LabelReNewNameColor3: TLabel;
    Label62: TLabel;
    EditReNewNameColor4: TSpinEdit;
    LabelReNewNameColor4: TLabel;
    Label64: TLabel;
    EditReNewNameColor5: TSpinEdit;
    LabelReNewNameColor5: TLabel;
    Label66: TLabel;
    EditReNewNameColor6: TSpinEdit;
    LabelReNewNameColor6: TLabel;
    Label68: TLabel;
    EditReNewNameColor7: TSpinEdit;
    LabelReNewNameColor7: TLabel;
    Label70: TLabel;
    EditReNewNameColor8: TSpinEdit;
    LabelReNewNameColor8: TLabel;
    Label72: TLabel;
    EditReNewNameColor9: TSpinEdit;
    LabelReNewNameColor9: TLabel;
    Label74: TLabel;
    EditReNewNameColor10: TSpinEdit;
    LabelReNewNameColor10: TLabel;
    ButtonReNewLevelSave: TButton;
    GroupBox30: TGroupBox;
    Label57: TLabel;
    EditReNewNameColorTime: TSpinEdit;
    Label59: TLabel;
    TabSheet39: TTabSheet;
    ButtonMonUpgradeSave: TButton;
    GroupBox32: TGroupBox;
    Label65: TLabel;
    LabelMonUpgradeColor1: TLabel;
    Label67: TLabel;
    LabelMonUpgradeColor2: TLabel;
    Label69: TLabel;
    LabelMonUpgradeColor3: TLabel;
    Label71: TLabel;
    LabelMonUpgradeColor4: TLabel;
    Label73: TLabel;
    LabelMonUpgradeColor5: TLabel;
    Label75: TLabel;
    LabelMonUpgradeColor6: TLabel;
    Label76: TLabel;
    LabelMonUpgradeColor7: TLabel;
    Label77: TLabel;
    LabelMonUpgradeColor8: TLabel;
    EditMonUpgradeColor1: TSpinEdit;
    EditMonUpgradeColor2: TSpinEdit;
    EditMonUpgradeColor3: TSpinEdit;
    EditMonUpgradeColor4: TSpinEdit;
    EditMonUpgradeColor5: TSpinEdit;
    EditMonUpgradeColor6: TSpinEdit;
    EditMonUpgradeColor7: TSpinEdit;
    EditMonUpgradeColor8: TSpinEdit;
    GroupBox31: TGroupBox;
    Label61: TLabel;
    Label63: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    EditMonUpgradeKillCount1: TSpinEdit;
    EditMonUpgradeKillCount2: TSpinEdit;
    EditMonUpgradeKillCount3: TSpinEdit;
    EditMonUpgradeKillCount4: TSpinEdit;
    EditMonUpgradeKillCount5: TSpinEdit;
    EditMonUpgradeKillCount6: TSpinEdit;
    EditMonUpgradeKillCount7: TSpinEdit;
    EditMonUpLvNeedKillBase: TSpinEdit;
    EditMonUpLvRate: TSpinEdit;
    Label84: TLabel;
    CheckBoxReNewChangeColor: TCheckBox;
    GroupBox33: TGroupBox;
    CheckBoxReNewLevelClearExp: TCheckBox;
    GroupBox34: TGroupBox;
    Label85: TLabel;
    EditPKFlagNameColor: TSpinEdit;
    LabelPKFlagNameColor: TLabel;
    Label87: TLabel;
    EditPKLevel1NameColor: TSpinEdit;
    LabelPKLevel1NameColor: TLabel;
    Label89: TLabel;
    EditPKLevel2NameColor: TSpinEdit;
    LabelPKLevel2NameColor: TLabel;
    Label91: TLabel;
    EditAllyAndGuildNameColor: TSpinEdit;
    LabelAllyAndGuildNameColor: TLabel;
    Label93: TLabel;
    EditWarGuildNameColor: TSpinEdit;
    LabelWarGuildNameColor: TLabel;
    Label95: TLabel;
    EditInFreePKAreaNameColor: TSpinEdit;
    LabelInFreePKAreaNameColor: TLabel;
    TabSheet40: TTabSheet;
    Label86: TLabel;
    EditMonUpgradeColor9: TSpinEdit;
    LabelMonUpgradeColor9: TLabel;
    GroupBox35: TGroupBox;
    CheckBoxMasterDieMutiny: TCheckBox;
    Label88: TLabel;
    EditMasterDieMutinyRate: TSpinEdit;
    Label90: TLabel;
    EditMasterDieMutinyPower: TSpinEdit;
    Label92: TLabel;
    EditMasterDieMutinySpeed: TSpinEdit;
    GroupBox36: TGroupBox;
    Label94: TLabel;
    Label96: TLabel;
    CheckBoxSpiritMutiny: TCheckBox;
    EditSpiritMutinyTime: TSpinEdit;
    EditSpiritPowerRate: TSpinEdit;
    ButtonSpiritMutinySave: TButton;
    ButtonUpgradeWeaponDefaulf: TButton;
    ButtonMakeMineDefault: TButton;
    ButtonWinLotteryDefault: TButton;
    TabSheet42: TTabSheet;
    GroupBox44: TGroupBox;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    ScrollBarWeaponMakeUnLuckRate: TScrollBar;
    EditWeaponMakeUnLuckRate: TEdit;
    ScrollBarWeaponMakeLuckPoint1: TScrollBar;
    EditWeaponMakeLuckPoint1: TEdit;
    ScrollBarWeaponMakeLuckPoint2: TScrollBar;
    EditWeaponMakeLuckPoint2: TEdit;
    ScrollBarWeaponMakeLuckPoint2Rate: TScrollBar;
    EditWeaponMakeLuckPoint2Rate: TEdit;
    EditWeaponMakeLuckPoint3: TEdit;
    ScrollBarWeaponMakeLuckPoint3: TScrollBar;
    Label110: TLabel;
    ScrollBarWeaponMakeLuckPoint3Rate: TScrollBar;
    EditWeaponMakeLuckPoint3Rate: TEdit;
    ButtonWeaponMakeLuckDefault: TButton;
    ButtonWeaponMakeLuckSave: TButton;
    GroupBox47: TGroupBox;
    Label112: TLabel;
    CheckBoxBBMonAutoChangeColor: TCheckBox;
    EditBBMonAutoChangeColorTime: TSpinEdit;
    GroupBox62: TGroupBox;
    chkStartDropItemMapEvent: TCheckBox;
    MagicPageControl: TPageControl;
    TabSheet54: TTabSheet;
    GroupBox17: TGroupBox;
    Label12: TLabel;
    EditMagicAttackRage: TSpinEdit;
    TabSheet2: TTabSheet;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    GroupBox9: TGroupBox;
    CheckBoxLimitSwordLong: TCheckBox;
    GroupBox10: TGroupBox;
    Label4: TLabel;
    Label10: TLabel;
    EditSwordLongPowerRate: TSpinEdit;
    TabSheet4: TTabSheet;
    GroupBox56: TGroupBox;
    Label119: TLabel;
    Label120: TLabel;
    SpinEditSkill39Sec: TSpinEdit;
    GroupBox57: TGroupBox;
    CheckBoxDedingAllowPK: TCheckBox;
    GroupBox52: TGroupBox;
    Label135: TLabel;
    SpinEditDidingPowerRate: TSpinEdit;
    TabSheet5: TTabSheet;
    GroupBox48: TGroupBox;
    CheckBoxGroupMbAttackPlayObject: TCheckBox;
    CheckBoxGroupMbAttackSlave: TCheckBox;
    TabSheet6: TTabSheet;
    GroupBox50: TGroupBox;
    CheckBoxPullPlayObject: TCheckBox;
    CheckBoxPullCrossInSafeZone: TCheckBox;
    TabSheet7: TTabSheet;
    PageControl3: TPageControl;
    TabSheet8: TTabSheet;
    GroupBox38: TGroupBox;
    Label98: TLabel;
    EditMagTammingLevel: TSpinEdit;
    GroupBox45: TGroupBox;
    Label111: TLabel;
    EditTammingCount: TSpinEdit;
    GroupBox39: TGroupBox;
    Label99: TLabel;
    Label100: TLabel;
    EditMagTammingTargetLevel: TSpinEdit;
    EditMagTammingHPRate: TSpinEdit;
    TabSheet9: TTabSheet;
    GroupBox53: TGroupBox;
    Label117: TLabel;
    Label116: TLabel;
    SpinEditFireDelayTime: TSpinEdit;
    SpinEditFirePower: TSpinEdit;
    GroupBox46: TGroupBox;
    CheckBoxFireCrossInSafeZone: TCheckBox;
    GroupBox63: TGroupBox;
    CheckBoxFireChgMapExtinguish: TCheckBox;
    TabSheet10: TTabSheet;
    GroupBox37: TGroupBox;
    Label97: TLabel;
    EditMagTurnUndeadLevel: TSpinEdit;
    TabSheet11: TTabSheet;
    GroupBox15: TGroupBox;
    Label9: TLabel;
    EditElecBlizzardRange: TSpinEdit;
    TabSheet12: TTabSheet;
    GroupBox13: TGroupBox;
    Label7: TLabel;
    EditFireBoomRage: TSpinEdit;
    TabSheet13: TTabSheet;
    GroupBox14: TGroupBox;
    Label8: TLabel;
    EditSnowWindRange: TSpinEdit;
    TabSheet15: TTabSheet;
    PageControl4: TPageControl;
    TabSheet16: TTabSheet;
    TabSheet17: TTabSheet;
    GroupBox51: TGroupBox;
    CheckBoxPlayObjectReduceMP: TCheckBox;
    GroupBox16: TGroupBox;
    Label11: TLabel;
    EditAmyOunsulPoint: TSpinEdit;
    TabSheet18: TTabSheet;
    GroupBox5: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    EditBoneFammName: TEdit;
    EditBoneFammCount: TSpinEdit;
    GroupBox6: TGroupBox;
    GridBoneFamm: TStringGrid;
    TabSheet19: TTabSheet;
    GroupBox11: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    EditDogzName: TEdit;
    EditDogzCount: TSpinEdit;
    GroupBox12: TGroupBox;
    GridDogz: TStringGrid;
    TabSheet20: TTabSheet;
    GroupBox41: TGroupBox;
    Label101: TLabel;
    Label102: TLabel;
    EditMabMabeHitRandRate: TSpinEdit;
    EditMabMabeHitMinLvLimit: TSpinEdit;
    GroupBox43: TGroupBox;
    Label104: TLabel;
    EditMabMabeHitMabeTimeRate: TSpinEdit;
    GroupBox42: TGroupBox;
    Label103: TLabel;
    EditMabMabeHitSucessRate: TSpinEdit;
    GroupBox7: TGroupBox;
    Label147: TLabel;
    Label148: TLabel;
    Label149: TLabel;
    Label150: TLabel;
    Label151: TLabel;
    Label152: TLabel;
    Label153: TLabel;
    Label154: TLabel;
    Label155: TLabel;
    Label156: TLabel;
    Label157: TLabel;
    Label158: TLabel;
    Label159: TLabel;
    Label160: TLabel;
    SpinEditHPStoneStartRate: TSpinEdit;
    SpinEditHPStoneIntervalTime: TSpinEdit;
    SpinEditHPStoneAddRate: TSpinEdit;
    SpinEditMPStoneStartRate: TSpinEdit;
    SpinEditMPStoneIntervalTime: TSpinEdit;
    SpinEditMPStoneAddRate: TSpinEdit;
    SpinEditHPStoneDecDura: TSpinEdit;
    SpinEditMPStoneDecDura: TSpinEdit;
    grp1: TGroupBox;
    chkMonSayMsg: TCheckBox;
    chkCheckGuild: TCheckBox;
    chkStartPickUpItemMapEvent: TCheckBox;
    chkStartHeavyHitMapEvent: TCheckBox;
    chkStartWalkMapEvent: TCheckBox;
    chkStartRunMapEvent: TCheckBox;
    grp2: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    seFirePlayDamageTimeRate: TSpinEdit;
    seFireMonDamageTimeRate: TSpinEdit;
    ts1: TTabSheet;
    ts2: TTabSheet;
    ts3: TTabSheet;
    ts4: TTabSheet;
    grp3: TGroupBox;
    lbl3: TLabel;
    seSkill110PowerRate: TSpinEdit;
    grp4: TGroupBox;
    lbl4: TLabel;
    seSkill111PowerRate: TSpinEdit;
    grp5: TGroupBox;
    lbl5: TLabel;
    seSkill112PowerRate: TSpinEdit;
    grp6: TGroupBox;
    lbl6: TLabel;
    seSkill113PowerRate: TSpinEdit;
    ts5: TTabSheet;
    ts6: TTabSheet;
    ts7: TTabSheet;
    ts8: TTabSheet;
    grp7: TGroupBox;
    lbl7: TLabel;
    seSkill114PowerRate: TSpinEdit;
    grp8: TGroupBox;
    lbl8: TLabel;
    seSkill115PowerRate: TSpinEdit;
    grp9: TGroupBox;
    lbl9: TLabel;
    seSkill116PowerRate: TSpinEdit;
    grp10: TGroupBox;
    lbl10: TLabel;
    seSkill117PowerRate: TSpinEdit;
    ts9: TTabSheet;
    ts10: TTabSheet;
    ts11: TTabSheet;
    ts12: TTabSheet;
    grp11: TGroupBox;
    lbl11: TLabel;
    seSkill118PowerRate: TSpinEdit;
    grp12: TGroupBox;
    lbl12: TLabel;
    seSkill119PowerRate: TSpinEdit;
    grp13: TGroupBox;
    lbl13: TLabel;
    seSkill120PowerRate: TSpinEdit;
    grp14: TGroupBox;
    lbl14: TLabel;
    seSkill121PowerRate: TSpinEdit;
    TabSheet14: TTabSheet;
    ButtonMakeMagicSave: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditMakeMagicAddPoint: TSpinEdit;
    Label113: TLabel;
    EditMakeMagicUsePoint: TSpinEdit;
    Label114: TLabel;
    EditMakeMagicAddRate: TSpinEdit;
    Label115: TLabel;
    EditMakeMagicMaxLevel: TSpinEdit;
    grp15: TGroupBox;
    GridMakeMagic: TStringGrid;
    lbl15: TLabel;
    seEditMakeMagicMaxBeginLevel: TSpinEdit;
    TabSheet21: TTabSheet;
    GroupBox2: TGroupBox;
    Label118: TLabel;
    Label124: TLabel;
    EditNakedAddPoint: TSpinEdit;
    EditNakedBeginLevel: TSpinEdit;
    GroupBox3: TGroupBox;
    EditNakedAc2Point: TSpinEdit;
    Label121: TLabel;
    Label122: TLabel;
    EditNakedAcPoint: TSpinEdit;
    Label123: TLabel;
    Label125: TLabel;
    Label126: TLabel;
    EditNakedMac2Point: TSpinEdit;
    Label127: TLabel;
    EditNakedMacPoint: TSpinEdit;
    Label128: TLabel;
    Label129: TLabel;
    EditNakedDc2Point: TSpinEdit;
    Label130: TLabel;
    EditNakedDcPoint: TSpinEdit;
    Label131: TLabel;
    Label132: TLabel;
    EditNakedMC2Point: TSpinEdit;
    Label133: TLabel;
    EditNakedMCPoint: TSpinEdit;
    Label134: TLabel;
    Label136: TLabel;
    EditNakedSC2Point: TSpinEdit;
    Label137: TLabel;
    EditNakedSCPoint: TSpinEdit;
    Label138: TLabel;
    Label139: TLabel;
    EditNakedHPPoint: TSpinEdit;
    ButtonNakedSave: TButton;
    ComboBoxMakeMagicType: TComboBox;
    TabSheet22: TTabSheet;
    GroupBox4: TGroupBox;
    GridLiterary: TStringGrid;
    ButtonLiterarySave: TButton;
    TabSheet23: TTabSheet;
    GroupBox40: TGroupBox;
    ButtonFunSave: TButton;
    CheckBoxShowStrengthenInfo: TCheckBox;
    CheckBoxShowCBOForm: TCheckBox;
    CheckBoxShowMakeMagicForm: TCheckBox;
    GroupBox49: TGroupBox;
    CheckBoxExpIsCumulative: TCheckBox;
    CheckBoxExpOffLienSave: TCheckBox;
    CheckBoxExpOffLineRunTime: TCheckBox;
    GroupBox54: TGroupBox;
    CheckBoxWarLongWide: TCheckBox;
    CheckBoxNotShiftKey: TCheckBox;
    GroupBox55: TGroupBox;
    EditPullulation: TSpinEdit;
    Label140: TLabel;
    CheckBoxCancelDropItemHint: TCheckBox;
    GroupBox58: TGroupBox;
    Label141: TLabel;
    EditUnLuckMaxCount: TSpinEdit;
    TabSheet24: TTabSheet;
    GroupBox59: TGroupBox;
    Label142: TLabel;
    EditSkill70PowerRate: TSpinEdit;
    CheckBoxSkill70MbAttackMon: TCheckBox;
    CheckBoxSkill70MbAttackHuman: TCheckBox;
    CheckBoxSkill70MbAttackSlave: TCheckBox;
    TabSheet25: TTabSheet;
    GroupBox60: TGroupBox;
    Label143: TLabel;
    EditSkill71PowerRate: TSpinEdit;
    CheckBoxSkill71MbAttackMon: TCheckBox;
    CheckBoxSkill71MbAttackHuman: TCheckBox;
    CheckBoxSkill71MbAttackSlave: TCheckBox;
    TabSheet26: TTabSheet;
    GroupBox61: TGroupBox;
    Label144: TLabel;
    EditSkill72PowerRate: TSpinEdit;
    CheckBoxSkill72MbAttackMon: TCheckBox;
    CheckBoxSkill72MbAttackHuman: TCheckBox;
    CheckBoxSkill72MbAttackSlave: TCheckBox;
    CheckBoxSkill72Damagearmor: TCheckBox;
    CheckBoxSkill72DecHealth: TCheckBox;
    CheckBoxSkill72MbFastParalysis: TCheckBox;
    CheckBoxSkill71MbFastParalysis: TCheckBox;
    CheckBoxSkill70MbFastParalysis: TCheckBox;
    CheckBoxSkill70RunGuard: TCheckBox;
    CheckBoxSkill70RunNpc: TCheckBox;
    CheckBoxSkill70RunMon: TCheckBox;
    CheckBoxSkill70RunHum: TCheckBox;
    CheckBoxSkill70WarDisHumRun: TCheckBox;
    TabSheet27: TTabSheet;
    GroupBox64: TGroupBox;
    CheckBoxSkill63RunGuard: TCheckBox;
    CheckBoxSkill63RunNpc: TCheckBox;
    CheckBoxSkill63RunMon: TCheckBox;
    CheckBoxSkill63RunHum: TCheckBox;
    CheckBoxSkill63WarDisHumRun: TCheckBox;
    TabSheet28: TTabSheet;
    PageControl1: TPageControl;
    TabSheet29: TTabSheet;
    TabSheet30: TTabSheet;
    GroupBox65: TGroupBox;
    Label145: TLabel;
    EditEtenMagicSize: TSpinEdit;
    GroupBox66: TGroupBox;
    Label146: TLabel;
    EditEtenPowerRate: TSpinEdit;
    TabSheet31: TTabSheet;
    GroupBox67: TGroupBox;
    Label161: TLabel;
    Label162: TLabel;
    EditMoonSpiritName: TEdit;
    EditMoonSpiritCount: TSpinEdit;
    GroupBox68: TGroupBox;
    GridMoonSpirit: TStringGrid;
    GroupBox69: TGroupBox;
    Label163: TLabel;
    EditProtectShieldRunRate0: TSpinEdit;
    Label164: TLabel;
    EditProtectShieldDelDamage0: TSpinEdit;
    Label165: TLabel;
    Label166: TLabel;
    EditProtectShieldRunRate1: TSpinEdit;
    Label167: TLabel;
    EditProtectShieldDelDamage1: TSpinEdit;
    Label168: TLabel;
    Label169: TLabel;
    EditProtectShieldRunRate2: TSpinEdit;
    Label170: TLabel;
    EditProtectShieldDelDamage2: TSpinEdit;
    Label171: TLabel;
    Label172: TLabel;
    EditProtectShieldRunRate3: TSpinEdit;
    Label173: TLabel;
    EditProtectShieldDelDamage3: TSpinEdit;
    Label174: TLabel;
    TabSheet32: TTabSheet;
    TabSheet36: TTabSheet;
    GroupBox70: TGroupBox;
    CheckBoxSkill66ReduceMP: TCheckBox;
    TabSheet41: TTabSheet;
    GroupBox71: TGroupBox;
    CheckBoxAllow32HorseGetExp: TCheckBox;
    ButtonSaveHorse: TButton;
    GroupBox72: TGroupBox;
    CheckBoxAllow33HorseGetExp: TCheckBox;
    Edit32HorseGetExpRate: TSpinEdit;
    Label175: TLabel;
    Edit33HorseGetExpRate: TSpinEdit;
    Label176: TLabel;
    Edit33HorseGetExpRate2: TSpinEdit;
    Label177: TLabel;
    GroupBox73: TGroupBox;
    Label178: TLabel;
    EditHorseAliveTime: TSpinEdit;
    Label179: TLabel;
    Label180: TLabel;
    Label181: TLabel;
    Label182: TLabel;
    Label183: TLabel;
    EditTakeOnHorseUseTime: TSpinEdit;
    Label184: TLabel;
    GroupBox74: TGroupBox;
    Label185: TLabel;
    EditDomesticationRate: TSpinEdit;
    CheckBoxDomesticationUseWeapon: TCheckBox;
    CheckBoxDomesticationCheckLevel: TCheckBox;
    GroupBox75: TGroupBox;
    Label186: TLabel;
    EditMagicAttackMonsteRate: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure ButtonGeneralSaveClick(Sender: TObject);
    procedure CheckBoxLimitSwordLongClick(Sender: TObject);
    procedure ButtonSkillSaveClick(Sender: TObject);
    procedure EditBoneFammNameChange(Sender: TObject);
    procedure EditBoneFammCountChange(Sender: TObject);
    procedure EditSwordLongPowerRateChange(Sender: TObject);
    procedure EditFireBoomRageChange(Sender: TObject);
    procedure EditSnowWindRangeChange(Sender: TObject);
    procedure EditElecBlizzardRangeChange(Sender: TObject);
    procedure EditDogzCountChange(Sender: TObject);
    procedure EditDogzNameChange(Sender: TObject);
    procedure GridBoneFammSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure EditAmyOunsulPointChange(Sender: TObject);
    procedure EditMagicAttackRageChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponDCRateChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponDCTwoPointRateChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponDCThreePointRateChange(
      Sender: TObject);
    procedure ScrollBarUpgradeWeaponSCRateChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponSCTwoPointRateChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponSCThreePointRateChange(
      Sender: TObject);
    procedure ScrollBarUpgradeWeaponMCRateChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponMCTwoPointRateChange(Sender: TObject);
    procedure ScrollBarUpgradeWeaponMCThreePointRateChange(
      Sender: TObject);
    procedure EditUpgradeWeaponMaxPointChange(Sender: TObject);
    procedure EditUpgradeWeaponPriceChange(Sender: TObject);
    procedure EditUPgradeWeaponGetBackTimeChange(Sender: TObject);
    procedure EditClearExpireUpgradeWeaponDaysChange(Sender: TObject);
    procedure ButtonUpgradeWeaponSaveClick(Sender: TObject);
    procedure EditMasterOKLevelChange(Sender: TObject);
    procedure ButtonMasterSaveClick(Sender: TObject);
    procedure EditMasterOKCreditPointChange(Sender: TObject);
    procedure EditMasterOKBonusPointChange(Sender: TObject);
    procedure ScrollBarMakeMineHitRateChange(Sender: TObject);
    procedure ScrollBarMakeMineRateChange(Sender: TObject);
    procedure ScrollBarStoneTypeRateChange(Sender: TObject);
    procedure ScrollBarGoldStoneMaxChange(Sender: TObject);
    procedure ScrollBarSilverStoneMaxChange(Sender: TObject);
    procedure ScrollBarSteelStoneMaxChange(Sender: TObject);
    procedure ScrollBarBlackStoneMaxChange(Sender: TObject);
    procedure ButtonMakeMineSaveClick(Sender: TObject);
    procedure EditStoneMinDuraChange(Sender: TObject);
    procedure EditStoneGeneralDuraRateChange(Sender: TObject);
    procedure EditStoneAddDuraRateChange(Sender: TObject);
    procedure EditStoneAddDuraMaxChange(Sender: TObject);
    procedure ButtonWinLotterySaveClick(Sender: TObject);
    procedure EditWinLottery1GoldChange(Sender: TObject);
    procedure EditWinLottery2GoldChange(Sender: TObject);
    procedure EditWinLottery3GoldChange(Sender: TObject);
    procedure EditWinLottery4GoldChange(Sender: TObject);
    procedure EditWinLottery5GoldChange(Sender: TObject);
    procedure EditWinLottery6GoldChange(Sender: TObject);
    procedure ScrollBarWinLottery1MaxChange(Sender: TObject);
    procedure ScrollBarWinLottery2MaxChange(Sender: TObject);
    procedure ScrollBarWinLottery3MaxChange(Sender: TObject);
    procedure ScrollBarWinLottery4MaxChange(Sender: TObject);
    procedure ScrollBarWinLottery5MaxChange(Sender: TObject);
    procedure ScrollBarWinLottery6MaxChange(Sender: TObject);
    procedure ScrollBarWinLotteryRateChange(Sender: TObject);
    procedure ButtonReNewLevelSaveClick(Sender: TObject);
    procedure EditReNewNameColor1Change(Sender: TObject);
    procedure EditReNewNameColor2Change(Sender: TObject);
    procedure EditReNewNameColor3Change(Sender: TObject);
    procedure EditReNewNameColor4Change(Sender: TObject);
    procedure EditReNewNameColor5Change(Sender: TObject);
    procedure EditReNewNameColor6Change(Sender: TObject);
    procedure EditReNewNameColor7Change(Sender: TObject);
    procedure EditReNewNameColor8Change(Sender: TObject);
    procedure EditReNewNameColor9Change(Sender: TObject);
    procedure EditReNewNameColor10Change(Sender: TObject);
    procedure EditReNewNameColorTimeChange(Sender: TObject);
    procedure FunctionConfigControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure ButtonMonUpgradeSaveClick(Sender: TObject);
    procedure EditMonUpgradeColor1Change(Sender: TObject);
    procedure EditMonUpgradeColor2Change(Sender: TObject);
    procedure EditMonUpgradeColor3Change(Sender: TObject);
    procedure EditMonUpgradeColor4Change(Sender: TObject);
    procedure EditMonUpgradeColor5Change(Sender: TObject);
    procedure EditMonUpgradeColor6Change(Sender: TObject);
    procedure EditMonUpgradeColor7Change(Sender: TObject);
    procedure EditMonUpgradeColor8Change(Sender: TObject);
    procedure EditMonUpgradeColor9Change(Sender: TObject);
    procedure CheckBoxReNewChangeColorClick(Sender: TObject);
    procedure CheckBoxReNewLevelClearExpClick(Sender: TObject);
    procedure EditPKFlagNameColorChange(Sender: TObject);
    procedure EditPKLevel1NameColorChange(Sender: TObject);
    procedure EditPKLevel2NameColorChange(Sender: TObject);
    procedure EditAllyAndGuildNameColorChange(Sender: TObject);
    procedure EditWarGuildNameColorChange(Sender: TObject);
    procedure EditInFreePKAreaNameColorChange(Sender: TObject);
    procedure EditMonUpgradeKillCount1Change(Sender: TObject);
    procedure EditMonUpgradeKillCount2Change(Sender: TObject);
    procedure EditMonUpgradeKillCount3Change(Sender: TObject);
    procedure EditMonUpgradeKillCount4Change(Sender: TObject);
    procedure EditMonUpgradeKillCount5Change(Sender: TObject);
    procedure EditMonUpgradeKillCount6Change(Sender: TObject);
    procedure EditMonUpgradeKillCount7Change(Sender: TObject);
    procedure EditMonUpLvNeedKillBaseChange(Sender: TObject);
    procedure EditMonUpLvRateChange(Sender: TObject);
    procedure CheckBoxMasterDieMutinyClick(Sender: TObject);
    procedure EditMasterDieMutinyRateChange(Sender: TObject);
    procedure EditMasterDieMutinyPowerChange(Sender: TObject);
    procedure EditMasterDieMutinySpeedChange(Sender: TObject);
    procedure ButtonSpiritMutinySaveClick(Sender: TObject);
    procedure CheckBoxSpiritMutinyClick(Sender: TObject);
    procedure EditSpiritMutinyTimeChange(Sender: TObject);
    procedure EditSpiritPowerRateChange(Sender: TObject);
    procedure EditMagTurnUndeadLevelChange(Sender: TObject);
    procedure EditMagTammingLevelChange(Sender: TObject);
    procedure EditMagTammingTargetLevelChange(Sender: TObject);
    procedure EditMagTammingHPRateChange(Sender: TObject);
    procedure chkMonSayMsgClick(Sender: TObject);
    procedure ButtonUpgradeWeaponDefaulfClick(Sender: TObject);
    procedure ButtonMakeMineDefaultClick(Sender: TObject);
    procedure ButtonWinLotteryDefaultClick(Sender: TObject);
    procedure EditMabMabeHitRandRateChange(Sender: TObject);
    procedure EditMabMabeHitMinLvLimitChange(Sender: TObject);
    procedure EditMabMabeHitSucessRateChange(Sender: TObject);
    procedure EditMabMabeHitMabeTimeRateChange(Sender: TObject);
    procedure ButtonWeaponMakeLuckDefaultClick(Sender: TObject);
    procedure ButtonWeaponMakeLuckSaveClick(Sender: TObject);
    procedure ScrollBarWeaponMakeUnLuckRateChange(Sender: TObject);
    procedure ScrollBarWeaponMakeLuckPoint1Change(Sender: TObject);
    procedure ScrollBarWeaponMakeLuckPoint2Change(Sender: TObject);
    procedure ScrollBarWeaponMakeLuckPoint2RateChange(Sender: TObject);
    procedure ScrollBarWeaponMakeLuckPoint3Change(Sender: TObject);
    procedure ScrollBarWeaponMakeLuckPoint3RateChange(Sender: TObject);
    procedure EditTammingCountChange(Sender: TObject);
    procedure CheckBoxFireCrossInSafeZoneClick(Sender: TObject);
    procedure CheckBoxBBMonAutoChangeColorClick(Sender: TObject);
    procedure EditBBMonAutoChangeColorTimeChange(Sender: TObject);
    procedure CheckBoxGroupMbAttackPlayObjectClick(Sender: TObject);
    procedure CheckBoxPullPlayObjectClick(Sender: TObject);
    procedure CheckBoxPlayObjectReduceMPClick(Sender: TObject);
    procedure CheckBoxGroupMbAttackSlaveClick(Sender: TObject);
    procedure SpinEditSkill39SecChange(Sender: TObject);
    procedure CheckBoxDedingAllowPKClick(Sender: TObject);
    procedure CheckBoxPullCrossInSafeZoneClick(Sender: TObject);
    procedure chkStartDropItemMapEventClick(Sender: TObject);
    procedure CheckBoxFireChgMapExtinguishClick(Sender: TObject);
    procedure SpinEditFireDelayTimeClick(Sender: TObject);
    procedure SpinEditFirePowerClick(Sender: TObject);
    procedure chkCheckGuildClick(Sender: TObject);
    procedure SpinEditHPStoneStartRateChange(Sender: TObject);
    procedure SpinEditHPStoneIntervalTimeChange(Sender: TObject);
    procedure SpinEditHPStoneAddRateChange(Sender: TObject);
    procedure SpinEditHPStoneDecDuraChange(Sender: TObject);
    procedure SpinEditMPStoneStartRateChange(Sender: TObject);
    procedure SpinEditMPStoneIntervalTimeChange(Sender: TObject);
    procedure SpinEditMPStoneAddRateChange(Sender: TObject);
    procedure SpinEditMPStoneDecDuraChange(Sender: TObject);
    procedure chkStartPickUpItemMapEventClick(Sender: TObject);
    procedure chkStartHeavyHitMapEventClick(Sender: TObject);
    procedure chkStartWalkMapEventClick(Sender: TObject);
    procedure chkStartRunMapEventClick(Sender: TObject);
    procedure SpinEditFireDelayTimeChange(Sender: TObject);
    procedure SpinEditFirePowerChange(Sender: TObject);
    procedure seFirePlayDamageTimeRateChange(Sender: TObject);
    procedure seFireMonDamageTimeRateChange(Sender: TObject);
    procedure seSkill110PowerRateChange(Sender: TObject);
    procedure seSkill111PowerRateChange(Sender: TObject);
    procedure seSkill112PowerRateChange(Sender: TObject);
    procedure seSkill113PowerRateChange(Sender: TObject);
    procedure seSkill115PowerRateChange(Sender: TObject);
    procedure seSkill116PowerRateChange(Sender: TObject);
    procedure seSkill117PowerRateChange(Sender: TObject);
    procedure seSkill118PowerRateChange(Sender: TObject);
    procedure seSkill119PowerRateChange(Sender: TObject);
    procedure seSkill120PowerRateChange(Sender: TObject);
    procedure seSkill121PowerRateChange(Sender: TObject);
    procedure seSkill114PowerRateChange(Sender: TObject);
    procedure ButtonMakeMagicSaveClick(Sender: TObject);
    procedure EditMakeMagicAddPointChange(Sender: TObject);
    procedure EditMakeMagicUsePointChange(Sender: TObject);
    procedure EditMakeMagicAddRateChange(Sender: TObject);
    procedure EditMakeMagicMaxLevelChange(Sender: TObject);
    procedure seEditMakeMagicMaxBeginLevelChange(Sender: TObject);
    procedure EditNakedAddPointChange(Sender: TObject);
    procedure EditNakedBeginLevelChange(Sender: TObject);
    procedure EditNakedAc2PointChange(Sender: TObject);
    procedure EditNakedMac2PointChange(Sender: TObject);
    procedure EditNakedDc2PointChange(Sender: TObject);
    procedure EditNakedMC2PointChange(Sender: TObject);
    procedure EditNakedSC2PointChange(Sender: TObject);
    procedure EditNakedHPPointChange(Sender: TObject);
    procedure EditNakedAcPointChange(Sender: TObject);
    procedure EditNakedMacPointChange(Sender: TObject);
    procedure EditNakedDcPointChange(Sender: TObject);
    procedure EditNakedMCPointChange(Sender: TObject);
    procedure EditNakedSCPointChange(Sender: TObject);
    procedure ButtonNakedSaveClick(Sender: TObject);
    procedure ComboBoxMakeMagicTypeChange(Sender: TObject);
    procedure ButtonLiterarySaveClick(Sender: TObject);
    procedure GridLiterarySetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
    procedure CheckBoxShowStrengthenInfoClick(Sender: TObject);
    procedure CheckBoxShowCBOFormClick(Sender: TObject);
    procedure CheckBoxShowMakeMagicFormClick(Sender: TObject);
    procedure ButtonFunSaveClick(Sender: TObject);
    procedure CheckBoxExpIsCumulativeClick(Sender: TObject);
    procedure CheckBoxExpOffLienSaveClick(Sender: TObject);
    procedure CheckBoxExpOffLineRunTimeClick(Sender: TObject);
    procedure CheckBoxWarLongWideClick(Sender: TObject);
    procedure CheckBoxNotShiftKeyClick(Sender: TObject);
    procedure EditPullulationChange(Sender: TObject);
    procedure CheckBoxCancelDropItemHintClick(Sender: TObject);
    procedure EditUnLuckMaxCountChange(Sender: TObject);
    procedure EditSkill70PowerRateChange(Sender: TObject);
    procedure EditSkill71PowerRateChange(Sender: TObject);
    procedure EditSkill72PowerRateChange(Sender: TObject);
    procedure CheckBoxSkill70MbAttackMonClick(Sender: TObject);
    procedure CheckBoxSkill71MbAttackMonClick(Sender: TObject);
    procedure CheckBoxSkill72MbAttackMonClick(Sender: TObject);
    procedure CheckBoxSkill72MbAttackHumanClick(Sender: TObject);
    procedure CheckBoxSkill71MbAttackHumanClick(Sender: TObject);
    procedure CheckBoxSkill70MbAttackHumanClick(Sender: TObject);
    procedure CheckBoxSkill70MbAttackSlaveClick(Sender: TObject);
    procedure CheckBoxSkill71MbAttackSlaveClick(Sender: TObject);
    procedure CheckBoxSkill72MbAttackSlaveClick(Sender: TObject);
    procedure CheckBoxSkill72DamagearmorClick(Sender: TObject);
    procedure CheckBoxSkill72DecHealthClick(Sender: TObject);
    procedure CheckBoxSkill70MbFastParalysisClick(Sender: TObject);
    procedure CheckBoxSkill71MbFastParalysisClick(Sender: TObject);
    procedure CheckBoxSkill72MbFastParalysisClick(Sender: TObject);
    procedure CheckBoxSkill70RunHumClick(Sender: TObject);
    procedure CheckBoxSkill70RunMonClick(Sender: TObject);
    procedure CheckBoxSkill70RunNpcClick(Sender: TObject);
    procedure CheckBoxSkill70RunGuardClick(Sender: TObject);
    procedure CheckBoxSkill70WarDisHumRunClick(Sender: TObject);
    procedure SpinEditDidingPowerRateChange(Sender: TObject);
    procedure CheckBoxSkill63RunHumClick(Sender: TObject);
    procedure CheckBoxSkill63RunMonClick(Sender: TObject);
    procedure CheckBoxSkill63RunNpcClick(Sender: TObject);
    procedure CheckBoxSkill63RunGuardClick(Sender: TObject);
    procedure CheckBoxSkill63WarDisHumRunClick(Sender: TObject);
    procedure GridMakeMagicSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
    procedure EditMoonSpiritCountChange(Sender: TObject);
    procedure EditEtenMagicSizeChange(Sender: TObject);
    procedure EditEtenPowerRateChange(Sender: TObject);
    procedure EditProtectShieldRunRate0Change(Sender: TObject);
    procedure EditProtectShieldRunRate1Change(Sender: TObject);
    procedure EditProtectShieldRunRate2Change(Sender: TObject);
    procedure EditProtectShieldRunRate3Change(Sender: TObject);
    procedure EditProtectShieldDelDamage0Change(Sender: TObject);
    procedure EditProtectShieldDelDamage1Change(Sender: TObject);
    procedure EditProtectShieldDelDamage2Change(Sender: TObject);
    procedure EditProtectShieldDelDamage3Change(Sender: TObject);
    procedure CheckBoxSkill66ReduceMPClick(Sender: TObject);
    procedure ButtonSaveHorseClick(Sender: TObject);
    procedure CheckBoxAllow32HorseGetExpClick(Sender: TObject);
    procedure CheckBoxAllow33HorseGetExpClick(Sender: TObject);
    procedure Edit32HorseGetExpRateChange(Sender: TObject);
    procedure Edit33HorseGetExpRateChange(Sender: TObject);
    procedure Edit33HorseGetExpRate2Change(Sender: TObject);
    procedure EditHorseAliveTimeChange(Sender: TObject);
    procedure EditTakeOnHorseUseTimeChange(Sender: TObject);
    procedure EditDomesticationRateChange(Sender: TObject);
    procedure CheckBoxDomesticationUseWeaponClick(Sender: TObject);
    procedure CheckBoxDomesticationCheckLevelClick(Sender: TObject);
    procedure EditMagicAttackMonsteRateChange(Sender: TObject);

  private
    boOpened: Boolean;
    boModValued: Boolean;
    procedure ModValue();
    procedure uModValue();
    procedure RefReNewLevelConf;
    procedure RefUpgradeWeapon;
    procedure RefMakeMine;
    procedure RefWinLottery;
    procedure RefMonUpgrade;
    procedure RefGeneral;
    procedure RefSpiritMutiny;
    procedure RefMagicSkill;
    procedure RefMonSayMsg;
    procedure RefWeaponMakeLuck();
    procedure RefCopyHumConf;
    procedure RefMakeMagic;
    procedure RefHorseInfo();
    { Private declarations }
  public
    procedure Open;
    { Public declarations }
  end;

var
  frmFunctionConfig: TfrmFunctionConfig;

implementation

uses M2Share, HUtil32, SDK;

{$R *.dfm}

{ TfrmFunctionConfig }


procedure TfrmFunctionConfig.ModValue;
begin
  boModValued := True;
  ButtonGeneralSave.Enabled := True;
  ButtonSkillSave.Enabled := True;
  ButtonUpgradeWeaponSave.Enabled := True;
  ButtonMasterSave.Enabled := True;
  ButtonMakeMineSave.Enabled := True;
  ButtonWinLotterySave.Enabled := True;
  ButtonReNewLevelSave.Enabled := True;
  ButtonMonUpgradeSave.Enabled := True;
  ButtonSpiritMutinySave.Enabled := True;
  ButtonMakeMagicSave.Enabled := True;
  ButtonNakedSave.Enabled := True;
  ButtonLiterarySave.Enabled := True;
  ButtonFunSave.Enabled := True;
  ButtonWeaponMakeLuckSave.Enabled := True;
  ButtonSaveHorse.Enabled := True;
  //ButtonMonSayMsgSave.Enabled := True;
  //ButtonSellOffSave.Enabled := True;
end;

procedure TfrmFunctionConfig.uModValue;
begin
  boModValued := False;
  ButtonGeneralSave.Enabled := False;
  ButtonSkillSave.Enabled := False;
  ButtonUpgradeWeaponSave.Enabled := False;
  ButtonMasterSave.Enabled := False;
  ButtonMakeMineSave.Enabled := False;
  ButtonWinLotterySave.Enabled := False;
  ButtonReNewLevelSave.Enabled := False;
  ButtonMonUpgradeSave.Enabled := False;
  ButtonSpiritMutinySave.Enabled := False;
  ButtonMakeMagicSave.Enabled := False;
  ButtonNakedSave.Enabled := False;
  ButtonLiterarySave.Enabled := False;
  ButtonFunSave.Enabled := False;
  ButtonWeaponMakeLuckSave.Enabled := False;
  ButtonSaveHorse.Enabled := False;
  //ButtonMonSayMsgSave.Enabled := False;
  //ButtonSellOffSave.Enabled := False;
end;

procedure TfrmFunctionConfig.FunctionConfigControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if boModValued then begin
    if
      Application.MessageBox('参数设置已经被修改，是否确认不保存修改的设置？',
      '确认信息', MB_YESNO + MB_ICONQUESTION) = IDYES then begin
      uModValue
    end
    else
      AllowChange := False;
  end;
end;

procedure TfrmFunctionConfig.Open;
var
  i: Integer;
begin
  boOpened := False;
  uModValue();

  RefGeneral();
  {CheckBoxHungerSystem.Checked := g_Config.boHungerSystem;
  CheckBoxHungerDecHP.Checked := g_Config.boHungerDecHP;
  CheckBoxHungerDecPower.Checked := g_Config.boHungerDecPower;

  CheckBoxHungerSystemClick(CheckBoxHungerSystem);  }

  SpinEditHPStoneStartRate.Value := g_Config.HPStoneStartRate;
  SpinEditMPStoneStartRate.Value := g_Config.MPStoneStartRate;
  SpinEditHPStoneIntervalTime.Value := Trunc(g_Config.HPStoneIntervalTime / 1000);
  SpinEditMPStoneIntervalTime.Value := Trunc(g_Config.MPStoneIntervalTime / 1000);
  SpinEditHPStoneAddRate.Value := g_Config.HPStoneAddRate;
  SpinEditMPStoneAddRate.Value := g_Config.MPStoneAddRate;
  SpinEditHPStoneDecDura.Value := g_Config.HPStoneDecDura;
  SpinEditMPStoneDecDura.Value := g_Config.MPStoneDecDura;

  EditPullulation.Value := g_Config.nPullulationCount;

  {CheckBoxEnablePasswordLock.Checked := g_Config.boPasswordLockSystem;
  CheckBoxLockGetBackItem.Checked := g_Config.boLockGetBackItemAction;
  CheckBoxLockDealItem.Checked := g_Config.boLockDealAction;
  CheckBoxLockDropItem.Checked := g_Config.boLockDropAction;
  CheckBoxLockWalk.Checked := g_Config.boLockWalkAction;
  CheckBoxLockRun.Checked := g_Config.boLockRunAction;
  CheckBoxLockHit.Checked := g_Config.boLockHitAction;
  CheckBoxLockSpell.Checked := g_Config.boLockSpellAction;
  CheckBoxLockSendMsg.Checked := g_Config.boLockSendMsgAction;
  CheckBoxLockInObMode.Checked := g_Config.boLockInObModeAction;

  CheckBoxLockLogin.Checked := g_Config.boLockHumanLogin;
  CheckBoxLockUseItem.Checked := g_Config.boLockUserItemAction;

  CheckBoxEnablePasswordLockClick(CheckBoxEnablePasswordLock);
  CheckBoxLockLoginClick(CheckBoxLockLogin);

  EditErrorPasswordCount.Value := g_Config.nPasswordErrorCountLock; }



  //SpinEditSellOffCount.Value := g_Config.nUserSellOffCount;
  //SpinEditSellOffTax.Value := g_Config.nUserSellOffTax;

  SpinEditFireDelayTime.Value := g_Config.nFireDelayTimeRate;
  SpinEditFirePower.Value := g_Config.nFirePowerRate;
  seFirePlayDamageTimeRate.Value := g_Config.nFirePlayDamageTimeRate;
  seFireMonDamageTimeRate.Value := g_Config.nFireMonDamageTimeRate;
  CheckBoxFireChgMapExtinguish.Checked := g_Config.boChangeMapFireExtinguish;

  SpinEditDidingPowerRate.Value := g_Config.nDidingPowerRate;
  

  EditBoneFammName.Text := g_Config.sBoneFamm;
  EditBoneFammCount.Value := g_Config.nBoneFammCount;

  for i := Low(g_Config.BoneFammArray) to High(g_Config.BoneFammArray) do begin
    if g_Config.BoneFammArray[i].nHumLevel <= 0 then break;

    GridBoneFamm.Cells[0, i + 1] := IntToStr(g_Config.BoneFammArray[i].nHumLevel);
    GridBoneFamm.Cells[1, i + 1] := g_Config.BoneFammArray[i].sMonName;
    GridBoneFamm.Cells[2, i + 1] := IntToStr(g_Config.BoneFammArray[i].nCount);
    GridBoneFamm.Cells[3, i + 1] := IntToStr(g_Config.BoneFammArray[i].nLevel);
  end;

  EditDogzName.Text := g_Config.sDogz;
  EditDogzCount.Value := g_Config.nDogzCount;
  for i := Low(g_Config.DogzArray) to High(g_Config.DogzArray) do begin
    if g_Config.DogzArray[i].nHumLevel <= 0 then break;
    GridDogz.Cells[0, i + 1] := IntToStr(g_Config.DogzArray[i].nHumLevel);
    GridDogz.Cells[1, i + 1] := g_Config.DogzArray[i].sMonName;
    GridDogz.Cells[2, i + 1] := IntToStr(g_Config.DogzArray[i].nCount);
    GridDogz.Cells[3, i + 1] := IntToStr(g_Config.DogzArray[i].nLevel);
  end;

  EditMoonSpiritName.Text := g_Config.sMoonSpirit;
  EditMoonSpiritCount.Value := g_Config.nMoonSpiritCount;
  for i := Low(g_Config.MoonSpiritArray) to High(g_Config.MoonSpiritArray) do begin
    if g_Config.MoonSpiritArray[i].nHumLevel <= 0 then break;
    GridMoonSpirit.Cells[0, i + 1] := IntToStr(g_Config.MoonSpiritArray[i].nHumLevel);
    GridMoonSpirit.Cells[1, i + 1] := g_Config.MoonSpiritArray[i].sMonName;
    GridMoonSpirit.Cells[2, i + 1] := IntToStr(g_Config.MoonSpiritArray[i].nCount);
    GridMoonSpirit.Cells[3, i + 1] := IntToStr(g_Config.MoonSpiritArray[i].nLevel);
  end;

  RefMagicSkill();

  RefUpgradeWeapon();
  RefMakeMine();
  RefWinLottery();
  EditMasterOKLevel.Value := g_Config.nMasterOKLevel;
  EditMasterOKCreditPoint.Value := g_Config.nMasterOKCreditPoint;
  EditMasterOKBonusPoint.Value := g_Config.nMasterOKBonusPoint;

  CheckBoxPullPlayObject.Checked := g_Config.boPullPlayObject;
  CheckBoxPullCrossInSafeZone.Checked := g_Config.boPullCrossInSafeZone;
  CheckBoxPullCrossInSafeZone.Enabled := g_Config.boPullPlayObject;

  CheckBoxPlayObjectReduceMP.Checked := g_Config.boPlayObjectReduceMP;
  CheckBoxGroupMbAttackSlave.Checked := g_Config.boGroupMbAttackSlave;
  {CheckBoxItemName.Checked := g_Config.boChangeUseItemNameByPlayName;
  EditItemName.Text := g_Config.sChangeUseItemName; }
  CheckBoxDedingAllowPK.Checked := g_Config.boDedingAllowPK;

  SpinEditSkill39Sec.Value := g_Config.nDedingUseTime;
  chkStartDropItemMapEvent.Checked := g_Config.boStartDropItemMapEvent;
  chkStartPickUpItemMapEvent.Checked := g_Config.boStartPickUpItemMapEvent;
  chkStartHeavyHitMapEvent.Checked := g_Config.boStartHeavyHitMapEvent;
  chkStartWalkMapEvent.Checked := g_Config.boStartWalkMapEvent;
  chkStartRunMapEvent.Checked := g_Config.boStartRunMapEvent;

  chkCheckGuild.Checked := g_Config.boCheckGuild;
  RefReNewLevelConf();
  RefMonUpgrade();
  RefSpiritMutiny();
  RefMonSayMsg();
  RefWeaponMakeLuck();

  RefCopyHumConf;
  RefMakeMagic;
  RefHorseInfo();

  EditNakedAddPoint.Value := g_Config.NakedAddInfo.nNakedLevelUpAddCount;
  EditNakedBeginLevel.Value := g_Config.wNakedBeginLevel;
  EditNakedAc2Point.Value := g_Config.NakedAddInfo.nNakedAcCount;
  EditNakedAcPoint.Value := g_Config.NakedAddInfo.nNakedAcMaxCount;
  EditNakedMac2Point.Value := g_Config.NakedAddInfo.nNakedMAcCount;
  EditNakedMacPoint.Value := g_Config.NakedAddInfo.nNakedMAcMaxCount;
  EditNakedDc2Point.Value := g_Config.NakedAddInfo.nNakedDcCount;
  EditNakedDcPoint.Value := g_Config.NakedAddInfo.nNakedDcMaxCount;
  EditNakedMc2Point.Value := g_Config.NakedAddInfo.nNakedMcCount;
  EditNakedMcPoint.Value := g_Config.NakedAddInfo.nNakedMcMaxCount;
  EditNakedSc2Point.Value := g_Config.NakedAddInfo.nNakedScCount;
  EditNakedScPoint.Value := g_Config.NakedAddInfo.nNakedScMaxCount;
  EditNakedHPPoint.Value := g_Config.NakedAddInfo.nNakedHPCount;

  GridLiterary.Cells[0, 0] := '文采数量';
  GridLiterary.Cells[1, 0] := '经验倍数';

  for i := Low(g_Config.LiteraryConfine) to High(g_Config.LiteraryConfine) do begin
    if g_Config.LiteraryConfine[i].nLiteraryCount <= 0 then break;
    GridLiterary.Cells[0, i + 1] := IntToStr(g_Config.LiteraryConfine[i].nLiteraryCount);
    GridLiterary.Cells[1, i + 1] := IntToStr(g_Config.LiteraryConfine[i].nExpRate);
  end;

  CheckBoxShowStrengthenInfo.Checked := CheckIntStatus(g_Config.nSetupInfo, M2SETUP_SHOWSTRENGTHENINFO);
  CheckBoxShowCBOForm.Checked := CheckIntStatus(g_Config.nSetupInfo, M2SETUP_SHOWCBOFORM);
  CheckBoxShowMakeMagicForm.Checked := CheckIntStatus(g_Config.nSetupInfo, M2SETUP_SHOWMAKEMAGICFORM);
  CheckBoxWarLongWide.Checked := CheckIntStatus(g_Config.nSetupInfo, M2SETUP_SHOWWARLONGWIDE);
  CheckBoxNotShiftKey.Checked := CheckIntStatus(g_Config.nSetupInfo, M2SETUP_NOTSHIFTKEY);
  CheckBoxCancelDropItemHint.Checked := CheckIntStatus(g_Config.nSetupInfo, M2SETUP_CANCELDROPITEMHINT);

  CheckBoxExpIsCumulative.Checked := g_Config.boExpIsCumulative;
  CheckBoxExpOffLienSave.Checked := g_Config.boExpOffLienSave;
  CheckBoxExpOffLineRunTime.Enabled := g_Config.boExpOffLienSave;
  if not g_Config.boExpOffLienSave then begin
    CheckBoxExpOffLineRunTime.Checked := False;
    g_Config.boExpOffLineRunTime := False;
  end else begin
    CheckBoxExpOffLineRunTime.Checked := g_Config.boExpOffLineRunTime;
  end;

  boOpened := True;
  FunctionConfigControl.ActivePageIndex := 0;
  ShowModal;
end;

procedure TfrmFunctionConfig.FormCreate(Sender: TObject);
begin
  GridBoneFamm.Cells[0, 0] := '人物等级';
  GridBoneFamm.Cells[1, 0] := '怪物名称';
  GridBoneFamm.Cells[2, 0] := '数量';
  GridBoneFamm.Cells[3, 0] := '等级';

  GridDogz.Cells[0, 0] := '人物等级';
  GridDogz.Cells[1, 0] := '怪物名称';
  GridDogz.Cells[2, 0] := '数量';
  GridDogz.Cells[3, 0] := '等级';

  GridMoonSpirit.Cells[0, 0] := '人物等级';
  GridMoonSpirit.Cells[1, 0] := '怪物名称';
  GridMoonSpirit.Cells[2, 0] := '数量';
  GridMoonSpirit.Cells[3, 0] := '等级';
  FunctionConfigControl.ActivePageIndex := 0;
  MagicPageControl.ActivePageIndex := 0;
  PageControl1.ActivePageIndex := 0;
  PageControl2.ActivePageIndex := 0;
  PageControl3.ActivePageIndex := 0;
  PageControl4.ActivePageIndex := 0;

{$IF SoftVersion = VERDEMO}
  Caption := '功能设置[演示版本，所有设置调整有效，但不能保存]'
{$IFEND}
end;

procedure TfrmFunctionConfig.RefGeneral();
begin
  EditPKFlagNameColor.Value := g_Config.btPKFlagNameColor;
  EditPKLevel1NameColor.Value := g_Config.btPKLevel1NameColor;
  EditPKLevel2NameColor.Value := g_Config.btPKLevel2NameColor;
  EditAllyAndGuildNameColor.Value := g_Config.btAllyAndGuildNameColor;
  EditWarGuildNameColor.Value := g_Config.btWarGuildNameColor;
  EditInFreePKAreaNameColor.Value := g_Config.btInFreePKAreaNameColor;
end;

procedure TfrmFunctionConfig.RefHorseInfo;
begin
  EditHorseAliveTime.Value := g_Config.nHorseAliveTime;
  EditTakeOnHorseUseTime.Value := g_Config.nTakeOnHorseUseTime;
  Edit33HorseGetExpRate.Value := g_Config.n33HorseGetExpRate;
  Edit33HorseGetExpRate2.Value := g_Config.n33HorseGetExpRate2;
  Edit32HorseGetExpRate.Value := g_Config.n32HorseGetExpRate;
  CheckBoxAllow33HorseGetExp.Checked := g_Config.boAllow33HorseGetExp;
  CheckBoxAllow32HorseGetExp.Checked := g_Config.boAllow32HorseGetExp;
  Edit33HorseGetExpRate.Enabled := g_Config.boAllow33HorseGetExp;
  Edit32HorseGetExpRate.Enabled := g_Config.boAllow32HorseGetExp;

  EditDomesticationRate.Value := g_Config.nDomesticationRate;
  CheckBoxDomesticationUseWeapon.Checked := g_Config.boDomesticationUseWeapon;
  CheckBoxDomesticationCheckLevel.Checked := g_Config.boDomesticationCheckLevel;
end;

procedure TfrmFunctionConfig.ButtonLiterarySaveClick(Sender: TObject);
var
  i: Integer;
begin
  SafeFillChar(g_Config.LiteraryConfine[0], SizeOf(g_Config.LiteraryConfine), #0);
  for i := Low(g_Config.LiteraryConfine) to High(g_Config.LiteraryConfine) do begin
    if GridLiterary.Cells[0, i + 1] = '' then break;
    g_Config.LiteraryConfine[i].nLiteraryCount := StrToIntDef(GridLiterary.Cells[0, i + 1], -1);
    g_Config.LiteraryConfine[i].nExpRate := StrToIntDef(GridLiterary.Cells[1, i + 1], -1);
    Config.WriteInteger('Setup', 'LiteraryCount' + IntToStr(I + 1), g_Config.LiteraryConfine[i].nLiteraryCount);
    Config.WriteInteger('Setup', 'LiteraryExpRate' + IntToStr(I + 1), g_Config.LiteraryConfine[i].nExpRate);
  end;
  uModValue();
end;

procedure TfrmFunctionConfig.ButtonMakeMagicSaveClick(Sender: TObject);
var
  I, k: Integer;
begin
  Config.WriteInteger('Setup', 'MakeMagicAddPoint', g_Config.btMakeMagicAddPoint);
  Config.WriteInteger('Setup', 'MakeMagicUsePoint', g_Config.btMakeMagicUsePoint);
  Config.WriteInteger('Setup', 'MakeMagicAddRate', g_Config.btMakeMagicAddRate);
  Config.WriteInteger('Setup', 'MakeMagicMaxLevel', g_Config.btMakeMagicMaxLevel);
  Config.WriteInteger('Setup', 'MakeMagicBeginLevel', g_Config.nMakeMagicBeginLevel);

  //SafeFillChar(g_Config.MakeMagicConfine, SizeOf(g_Config.MakeMagicConfine), #0);
  for k := Low(g_Config.MakeMagicConfine) to High(g_Config.MakeMagicConfine) do begin
    for I := Low(g_Config.MakeMagicConfine[k]) to High(g_Config.MakeMagicConfine[k]) do begin
      Config.WriteInteger('Setup', 'MakeMagic' + MAKEMAGICSAVENAME[k] + 'MagicLevel' + IntToStr(I + 1), g_Config.MakeMagicConfine[k][i].nMagicLevel);
      Config.WriteInteger('Setup', 'MakeMagic' + MAKEMAGICSAVENAME[k] + 'HumLevel' + IntToStr(I + 1), g_Config.MakeMagicConfine[k][i].nHumLevel);
    end;
  end;
 { for i := Low(g_Config.MakeMagicConfine) to High(g_Config.MakeMagicConfine) do begin
    Config.WriteInteger('Setup', 'MakeMagicConfineMagicLevel' + IntToStr(I + 1), 0);
    Config.WriteInteger('Setup', 'MakeMagicConfineHumLevel' + IntToStr(I + 1), 0);
  end;   }
  {
  for i := Low(g_Config.MakeMagicConfine) to High(g_Config.MakeMagicConfine) do begin
    if GridMakeMagic.Cells[0, i + 1] = '' then
      break;

    g_Config.MakeMagicConfine[i].nMagicLevel := StrToIntDef(GridMakeMagic.Cells[0, i + 1], -1);
    g_Config.MakeMagicConfine[i].nHumLevel := StrToIntDef(GridMakeMagic.Cells[1, i + 1], -1);
    Config.WriteInteger('Setup', 'MakeMagicConfineMagicLevel' + IntToStr(I + 1), g_Config.MakeMagicConfine[i].nMagicLevel);
    Config.WriteInteger('Setup', 'MakeMagicConfineHumLevel' + IntToStr(I + 1), g_Config.MakeMagicConfine[i].nHumLevel);

  end; }
  uModValue();
end;

procedure TfrmFunctionConfig.ButtonFunSaveClick(Sender: TObject);
begin
  Config.WriteInteger('Setup', 'SetupInfo', g_Config.nSetupInfo);
  Config.WriteBool('Setup', 'ExpIsCumulative', g_Config.boExpIsCumulative);
  Config.WriteBool('Setup', 'ExpOffLienSave', g_Config.boExpOffLienSave);
  Config.WriteBool('Setup', 'ExpOffLineRunTime', g_Config.boExpOffLineRunTime);
  uModValue();
end;

procedure TfrmFunctionConfig.ButtonGeneralSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteBool('Setup', 'HungerSystem', g_Config.boHungerSystem);
  Config.WriteBool('Setup', 'HungerDecHP', g_Config.boHungerDecHP);
  Config.WriteBool('Setup', 'HungerDecPower', g_Config.boHungerDecPower);

  Config.WriteInteger('Setup', 'PKFlagNameColor', g_Config.btPKFlagNameColor);
  Config.WriteInteger('Setup', 'AllyAndGuildNameColor', g_Config.btAllyAndGuildNameColor);
  Config.WriteInteger('Setup', 'WarGuildNameColor', g_Config.btWarGuildNameColor);
  Config.WriteInteger('Setup', 'InFreePKAreaNameColor', g_Config.btInFreePKAreaNameColor);
  Config.WriteInteger('Setup', 'PKLevel1NameColor', g_Config.btPKLevel1NameColor);
  Config.WriteInteger('Setup', 'PKLevel2NameColor', g_Config.btPKLevel2NameColor);

  Config.WriteBool('Setup', 'StartDropItemMapEvent', g_Config.boStartDropItemMapEvent);
  Config.WriteBool('Setup', 'StartPickUpItemMapEvent', g_Config.boStartPickUpItemMapEvent);
  Config.WriteBool('Setup', 'StartHeavyHitMapEvent', g_Config.boStartHeavyHitMapEvent);
  Config.WriteBool('Setup', 'StartWalkMapEvent', g_Config.boStartWalkMapEvent);
  Config.WriteBool('Setup', 'StartRunMapEvent', g_Config.boStartRunMapEvent);

  Config.WriteBool('Setup', 'CheckGuild', g_Config.boCheckGuild);
  Config.WriteBool('Setup', 'MonSayMsg', g_Config.boMonSayMsg);
  Config.WriteBool('Setup', 'ChangeUseItemNameByPlayName', g_Config.boChangeUseItemNameByPlayName);
  Config.WriteString('Setup', 'ChangeUseItemName', g_Config.sChangeUseItemName);

  Config.WriteInteger('Setup', 'HPStoneStartRate', g_Config.HPStoneStartRate);
  Config.WriteInteger('Setup', 'MPStoneStartRate', g_Config.MPStoneStartRate);
  Config.WriteInteger('Setup', 'HPStoneIntervalTime',
    g_Config.HPStoneIntervalTime);
  Config.WriteInteger('Setup', 'MPStoneIntervalTime',
    g_Config.MPStoneIntervalTime);
  Config.WriteInteger('Setup', 'HPStoneAddRate', g_Config.HPStoneAddRate);
  Config.WriteInteger('Setup', 'MPStoneAddRate', g_Config.MPStoneAddRate);
  Config.WriteInteger('Setup', 'HPStoneDecDura', g_Config.HPStoneDecDura);
  Config.WriteInteger('Setup', 'MPStoneDecDura', g_Config.MPStoneDecDura);
  Config.WriteInteger('Setup', 'PullulationCount', g_Config.nPullulationCount);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.EditMagicAttackMonsteRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMagicAttackMonsteRate := EditMagicAttackMonsteRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMagicAttackRageChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMagicAttackRage := EditMagicAttackRage.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.RefMagicSkill;
begin
  EditSwordLongPowerRate.Value := g_Config.nSwordLongPowerRate;
  CheckBoxLimitSwordLong.Checked := g_Config.boLimitSwordLong;
  EditFireBoomRage.Value := g_Config.nFireBoomRage;
  EditSnowWindRange.Value := g_Config.nSnowWindRange;
  EditElecBlizzardRange.Value := g_Config.nElecBlizzardRange;
  EditMagicAttackRage.Value := g_Config.nMagicAttackRage;
  EditAmyOunsulPoint.Value := g_Config.nAmyOunsulPoint;
  EditMagTurnUndeadLevel.Value := g_Config.nMagTurnUndeadLevel;
  EditMagTammingLevel.Value := g_Config.nMagTammingLevel;
  EditMagTammingTargetLevel.Value := g_Config.nMagTammingTargetLevel;
  EditMagTammingHPRate.Value := g_Config.nMagTammingHPRate;
  EditTammingCount.Value := g_Config.nMagTammingCount;
  EditMabMabeHitRandRate.Value := g_Config.nMabMabeHitRandRate;
  EditMabMabeHitMinLvLimit.Value := g_Config.nMabMabeHitMinLvLimit;
  EditMabMabeHitSucessRate.Value := g_Config.nMabMabeHitSucessRate;
  EditMabMabeHitMabeTimeRate.Value := g_Config.nMabMabeHitMabeTimeRate;
  CheckBoxFireCrossInSafeZone.Checked := g_Config.boDisableInSafeZoneFireCross;
  CheckBoxGroupMbAttackPlayObject.Checked := g_Config.boGroupMbAttackPlayObject;

  seSkill110PowerRate.Value := g_Config.nSkill110PowerRate;
  seSkill111PowerRate.Value := g_Config.nSkill111PowerRate;
  seSkill112PowerRate.Value := g_Config.nSkill112PowerRate;
  seSkill113PowerRate.Value := g_Config.nSkill113PowerRate;
  seSkill114PowerRate.Value := g_Config.nSkill114PowerRate;
  seSkill115PowerRate.Value := g_Config.nSkill115PowerRate;
  seSkill116PowerRate.Value := g_Config.nSkill116PowerRate;
  seSkill117PowerRate.Value := g_Config.nSkill117PowerRate;
  seSkill118PowerRate.Value := g_Config.nSkill118PowerRate;
  seSkill119PowerRate.Value := g_Config.nSkill119PowerRate;
  seSkill120PowerRate.Value := g_Config.nSkill120PowerRate;
  seSkill121PowerRate.Value := g_Config.nSkill121PowerRate;

  CheckBoxSkill63RunHum.Checked := g_Config.boSkill63RunHum;
  CheckBoxSkill63RunMon.Checked := g_Config.boSkill63RunMon;
  CheckBoxSkill63RunNpc.Checked := g_Config.boSkill63RunNpc;
  CheckBoxSkill63RunGuard.Checked := g_Config.boSkill63RunGuard;
  CheckBoxSkill63WarDisHumRun.Checked := g_Config.boSkill63WarDisHumRun;

  EditSkill70PowerRate.Value := g_Config.nSkill70PowerRate;
  CheckBoxSkill70MbAttackMon.Checked := g_Config.boSkill70MbAttackMon;
  CheckBoxSkill70MbAttackHuman.Checked := g_Config.boSkill70MbAttackHuman;
  CheckBoxSkill70MbAttackSlave.Checked := g_Config.boSkill70MbAttackSlave;
  CheckBoxSkill70MbFastParalysis.Checked := g_Config.boSkill70MbFastParalysis;
  CheckBoxSkill70RunHum.Checked := g_Config.boSkill70RunHum;
  CheckBoxSkill70RunMon.Checked := g_Config.boSkill70RunMon;
  CheckBoxSkill70RunNpc.Checked := g_Config.boSkill70RunNpc;
  CheckBoxSkill70RunGuard.Checked := g_Config.boSkill70RunGuard;
  CheckBoxSkill70WarDisHumRun.Checked := g_Config.boSkill70WarDisHumRun;

  EditSkill71PowerRate.Value := g_Config.nSkill71PowerRate;
  CheckBoxSkill71MbAttackMon.Checked := g_Config.boSkill71MbAttackMon;
  CheckBoxSkill71MbAttackHuman.Checked := g_Config.boSkill71MbAttackHuman;
  CheckBoxSkill71MbAttackSlave.Checked := g_Config.boSkill71MbAttackSlave;
  CheckBoxSkill71MbFastParalysis.Checked := g_Config.boSkill71MbFastParalysis;

  EditSkill72PowerRate.Value := g_Config.nSkill72PowerRate;
  CheckBoxSkill72MbAttackMon.Checked := g_Config.boSkill72MbAttackMon;
  CheckBoxSkill72MbAttackHuman.Checked := g_Config.boSkill72MbAttackHuman;
  CheckBoxSkill72MbAttackSlave.Checked := g_Config.boSkill72MbAttackSlave;
  CheckBoxSkill72Damagearmor.Checked := g_Config.boSkill72Damagearmor;
  CheckBoxSkill72DecHealth.Checked := g_Config.boSkill72DecHealth;
  CheckBoxSkill72MbFastParalysis.Checked := g_Config.boSkill72MbFastParalysis;

  CheckBoxSkill66ReduceMP.Checked := g_Config.boSkill66ReduceMP;

  EditEtenMagicSize.Value := g_Config.nEtenMagicSize;
  EditEtenPowerRate.Value := g_Config.nEtenPowerRate;

  EditProtectShieldRunRate0.Value := g_Config.nProtectShieldRunRate0;
  EditProtectShieldRunRate1.Value := g_Config.nProtectShieldRunRate1;
  EditProtectShieldRunRate2.Value := g_Config.nProtectShieldRunRate2;
  EditProtectShieldRunRate3.Value := g_Config.nProtectShieldRunRate3;
  EditProtectShieldDelDamage0.Value := g_Config.nProtectShieldDelDamage0;
  EditProtectShieldDelDamage1.Value := g_Config.nProtectShieldDelDamage1;
  EditProtectShieldDelDamage2.Value := g_Config.nProtectShieldDelDamage2;
  EditProtectShieldDelDamage3.Value := g_Config.nProtectShieldDelDamage3;
end;

procedure TfrmFunctionConfig.EditBoneFammCountChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nBoneFammCount := EditBoneFammCount.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditDogzCountChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nDogzCount := EditDogzCount.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxLimitSwordLongClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boLimitSwordLong := CheckBoxLimitSwordLong.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditSwordLongPowerRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nSwordLongPowerRate := EditSwordLongPowerRate.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.EditBoneFammNameChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  ModValue();
end;

procedure TfrmFunctionConfig.EditDogzNameChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  ModValue();
end;

procedure TfrmFunctionConfig.EditDomesticationRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nDomesticationRate := EditDomesticationRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditFireBoomRageChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nFireBoomRage := EditFireBoomRage.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditHorseAliveTimeChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nHorseAliveTime := EditHorseAliveTime.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditSkill70PowerRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nSkill70PowerRate := EditSkill70PowerRate.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.EditSkill71PowerRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nSkill71PowerRate := EditSkill71PowerRate.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.EditSkill72PowerRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nSkill72PowerRate := EditSkill72PowerRate.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.EditSnowWindRangeChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nSnowWindRange := EditSnowWindRange.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditElecBlizzardRangeChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nElecBlizzardRange := EditElecBlizzardRange.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditEtenMagicSizeChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nEtenMagicSize := EditEtenMagicSize.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.EditEtenPowerRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nEtenPowerRate := EditEtenPowerRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMagTurnUndeadLevelChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMagTurnUndeadLevel := EditMagTurnUndeadLevel.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMakeMagicAddPointChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.btMakeMagicAddPoint := EditMakeMagicAddPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMakeMagicAddRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.btMakeMagicAddRate := EditMakeMagicAddRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMakeMagicMaxLevelChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.btMakeMagicMaxLevel := EditMakeMagicMaxLevel.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMakeMagicUsePointChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.btMakeMagicUsePoint := EditMakeMagicUsePoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.GridBoneFammSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  if not boOpened then Exit;
  ModValue();
end;

procedure TfrmFunctionConfig.GridLiterarySetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
begin
  if not boOpened then Exit;
  ModValue();
end;

procedure TfrmFunctionConfig.GridMakeMagicSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
var
  i, k: Integer;
begin
  if not boOpened then Exit;
  if ComboBoxMakeMagicType.ItemIndex in [Low(g_Config.MakeMagicConfine)..High(g_Config.MakeMagicConfine)] then begin
    k := ComboBoxMakeMagicType.ItemIndex;
    FillChar(g_Config.MakeMagicConfine[k][0], SizeOf(g_Config.MakeMagicConfine[k]), #0);
    for I := Low(g_Config.MakeMagicConfine[k]) to High(g_Config.MakeMagicConfine[k]) do begin
      if GridMakeMagic.Cells[0, i + 1] = '' then break;
      g_Config.MakeMagicConfine[k][i].nMagicLevel := StrToIntDef(GridMakeMagic.Cells[0, i + 1], -1);
      g_Config.MakeMagicConfine[k][i].nHumLevel := StrToIntDef(GridMakeMagic.Cells[1, i + 1], -1);
    end;
  end;
  ModValue();
end;

procedure TfrmFunctionConfig.EditAmyOunsulPointChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nAmyOunsulPoint := EditAmyOunsulPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxFireChgMapExtinguishClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boChangeMapFireExtinguish := CheckBoxFireChgMapExtinguish.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxFireCrossInSafeZoneClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boDisableInSafeZoneFireCross := CheckBoxFireCrossInSafeZone.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxGroupMbAttackPlayObjectClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boGroupMbAttackPlayObject := CheckBoxGroupMbAttackPlayObject.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.ButtonSaveHorseClick(Sender: TObject);
begin
  Config.WriteBool('Setup', 'Allow32HorseGetExp', g_Config.boAllow32HorseGetExp);
  Config.WriteInteger('Setup', '32HorseGetExpRate', g_Config.n32HorseGetExpRate);
  Config.WriteBool('Setup', 'Allow33HorseGetExp', g_Config.boAllow33HorseGetExp);
  Config.WriteInteger('Setup', '33HorseGetExpRate', g_Config.n33HorseGetExpRate);
  Config.WriteInteger('Setup', '33HorseGetExpRate2', g_Config.n33HorseGetExpRate2);
  Config.WriteInteger('Setup', 'HorseAliveTime', g_Config.nHorseAliveTime);
  Config.WriteInteger('Setup', 'TakeOnHorseUseTime', g_Config.nTakeOnHorseUseTime);
  Config.WriteInteger('Setup', 'DomesticationRate', g_Config.nDomesticationRate);
  Config.WriteBool('Setup', 'DomesticationUseWeapon', g_Config.boDomesticationUseWeapon);
  Config.WriteBool('Setup', 'DomesticationCheckLevel', g_Config.boDomesticationCheckLevel);
  uModValue();
end;

procedure TfrmFunctionConfig.ButtonSkillSaveClick(Sender: TObject);
var
  i: Integer;
  RecallArray: array[0..9] of TRecallMigic;
  Rect: TGridRect;
begin
  SafeFillChar(RecallArray, SizeOf(RecallArray), #0);

  for i := Low(RecallArray) to High(RecallArray) do begin
    RecallArray[i].nHumLevel := StrToIntDef(GridBoneFamm.Cells[0, i + 1], -1);
    RecallArray[i].sMonName := Trim(GridBoneFamm.Cells[1, i + 1]);
    RecallArray[i].nCount := StrToIntDef(GridBoneFamm.Cells[2, i + 1], -1);
    RecallArray[i].nLevel := StrToIntDef(GridBoneFamm.Cells[3, i + 1], -1);
    if GridBoneFamm.Cells[0, i + 1] = '' then
      break;
    if (RecallArray[i].nHumLevel <= 0) then begin
      Application.MessageBox('人物等级设置错误.', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 0;
      Rect.Top := i + 1;
      Rect.Right := 0;
      Rect.Bottom := i + 1;
      GridBoneFamm.Selection := Rect;
      Exit;
    end;
    if UserEngine.GetMonRace(RecallArray[i].sMonName) <= 0 then begin
      Application.MessageBox('怪物名称设置错误.', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 1;
      Rect.Top := i + 1;
      Rect.Right := 1;
      Rect.Bottom := i + 1;
      GridBoneFamm.Selection := Rect;
      Exit;
    end;
    if RecallArray[i].nCount <= 0 then begin
      Application.MessageBox('召唤数量设置错误.', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 2;
      Rect.Top := i + 1;
      Rect.Right := 2;
      Rect.Bottom := i + 1;
      GridBoneFamm.Selection := Rect;
      Exit;
    end;
    if RecallArray[i].nLevel < 0 then begin
      Application.MessageBox('召唤等级设置错误.', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 3;
      Rect.Top := i + 1;
      Rect.Right := 3;
      Rect.Bottom := i + 1;
      GridBoneFamm.Selection := Rect;
      Exit;
    end;
  end;

  SafeFillChar(RecallArray, SizeOf(RecallArray), #0);
  for i := Low(RecallArray) to High(RecallArray) do begin
    RecallArray[i].nHumLevel := StrToIntDef(GridDogz.Cells[0, i + 1], -1);
    RecallArray[i].sMonName := Trim(GridDogz.Cells[1, i + 1]);
    RecallArray[i].nCount := StrToIntDef(GridDogz.Cells[2, i + 1], -1);
    RecallArray[i].nLevel := StrToIntDef(GridDogz.Cells[3, i + 1], -1);
    if GridDogz.Cells[0, i + 1] = '' then break;
    if (RecallArray[i].nHumLevel <= 0) then begin
      Application.MessageBox('人物等级设置错误.', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 0;
      Rect.Top := i + 1;
      Rect.Right := 0;
      Rect.Bottom := i + 1;
      GridDogz.Selection := Rect;
      Exit;
    end;
    if UserEngine.GetMonRace(RecallArray[i].sMonName) <= 0 then begin
      Application.MessageBox('怪物名称设置错误.', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 1;
      Rect.Top := i + 1;
      Rect.Right := 1;
      Rect.Bottom := i + 1;
      GridDogz.Selection := Rect;
      Exit;
    end;
    if RecallArray[i].nCount <= 0 then begin
      Application.MessageBox('召唤数量设置错误.', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 2;
      Rect.Top := i + 1;
      Rect.Right := 2;
      Rect.Bottom := i + 1;
      GridDogz.Selection := Rect;
      Exit;
    end;
    if RecallArray[i].nLevel < 0 then begin
      Application.MessageBox('召唤等级设置错误.', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 3;
      Rect.Top := i + 1;
      Rect.Right := 3;
      Rect.Bottom := i + 1;
      GridDogz.Selection := Rect;
      Exit;
    end;
  end;

  SafeFillChar(RecallArray, SizeOf(RecallArray), #0);
  for i := Low(RecallArray) to High(RecallArray) do begin
    RecallArray[i].nHumLevel := StrToIntDef(GridMoonSpirit.Cells[0, i + 1], -1);
    RecallArray[i].sMonName := Trim(GridMoonSpirit.Cells[1, i + 1]);
    RecallArray[i].nCount := StrToIntDef(GridMoonSpirit.Cells[2, i + 1], -1);
    RecallArray[i].nLevel := StrToIntDef(GridMoonSpirit.Cells[3, i + 1], -1);
    if GridMoonSpirit.Cells[0, i + 1] = '' then break;
    if (RecallArray[i].nHumLevel <= 0) then begin
      Application.MessageBox('人物等级设置错误.', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 0;
      Rect.Top := i + 1;
      Rect.Right := 0;
      Rect.Bottom := i + 1;
      GridMoonSpirit.Selection := Rect;
      Exit;
    end;
    if UserEngine.GetMonRace(RecallArray[i].sMonName) <= 0 then begin
      Application.MessageBox('怪物名称设置错误.', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 1;
      Rect.Top := i + 1;
      Rect.Right := 1;
      Rect.Bottom := i + 1;
      GridMoonSpirit.Selection := Rect;
      Exit;
    end;
    if RecallArray[i].nCount <= 0 then begin
      Application.MessageBox('召唤数量设置错误.', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 2;
      Rect.Top := i + 1;
      Rect.Right := 2;
      Rect.Bottom := i + 1;
      GridMoonSpirit.Selection := Rect;
      Exit;
    end;
    if RecallArray[i].nLevel < 0 then begin
      Application.MessageBox('召唤等级设置错误.', '错误信息', MB_OK + MB_ICONERROR);
      Rect.Left := 3;
      Rect.Top := i + 1;
      Rect.Right := 3;
      Rect.Bottom := i + 1;
      GridMoonSpirit.Selection := Rect;
      Exit;
    end;
  end;

  g_Config.sBoneFamm := Trim(EditBoneFammName.Text);
  g_Config.sDogz := Trim(EditDogzName.Text);
  g_Config.sMoonSpirit := Trim(EditMoonSpiritName.Text);

  SafeFillChar(g_Config.BoneFammArray, SizeOf(g_Config.BoneFammArray), #0);
  for i := Low(g_Config.BoneFammArray) to High(g_Config.BoneFammArray) do begin
    Config.WriteInteger('Setup', 'BoneFammHumLevel' + IntToStr(i), 0);
    Config.WriteString('Names', 'BoneFamm' + IntToStr(i), '');
    Config.WriteInteger('Setup', 'BoneFammCount' + IntToStr(i), 0);
    Config.WriteInteger('Setup', 'BoneFammLevel' + IntToStr(i), 0);
  end;
  for i := Low(g_Config.BoneFammArray) to High(g_Config.BoneFammArray) do begin
    if GridBoneFamm.Cells[0, i + 1] = '' then break;
    g_Config.BoneFammArray[i].nHumLevel := StrToIntDef(GridBoneFamm.Cells[0, i + 1], -1);
    g_Config.BoneFammArray[i].sMonName := Trim(GridBoneFamm.Cells[1, i + 1]);
    g_Config.BoneFammArray[i].nCount := StrToIntDef(GridBoneFamm.Cells[2, i + 1], -1);
    g_Config.BoneFammArray[i].nLevel := StrToIntDef(GridBoneFamm.Cells[3, i + 1], -1);

    Config.WriteInteger('Setup', 'BoneFammHumLevel' + IntToStr(i), g_Config.BoneFammArray[i].nHumLevel);
    Config.WriteString('Names', 'BoneFamm' + IntToStr(i), g_Config.BoneFammArray[i].sMonName);
    Config.WriteInteger('Setup', 'BoneFammCount' + IntToStr(i), g_Config.BoneFammArray[i].nCount);
    Config.WriteInteger('Setup', 'BoneFammLevel' + IntToStr(i), g_Config.BoneFammArray[i].nLevel);
  end;

  SafeFillChar(g_Config.DogzArray, SizeOf(g_Config.DogzArray), #0);
  for i := Low(g_Config.DogzArray) to High(g_Config.DogzArray) do begin
    Config.WriteInteger('Setup', 'DogzHumLevel' + IntToStr(i), 0);
    Config.WriteString('Names', 'Dogz' + IntToStr(i), '');
    Config.WriteInteger('Setup', 'DogzCount' + IntToStr(i), 0);
    Config.WriteInteger('Setup', 'DogzLevel' + IntToStr(i), 0);
  end;
  for i := Low(g_Config.DogzArray) to High(g_Config.DogzArray) do begin
    if GridDogz.Cells[0, i + 1] = '' then break;

    g_Config.DogzArray[i].nHumLevel := StrToIntDef(GridDogz.Cells[0, i + 1], -1);
    g_Config.DogzArray[i].sMonName := Trim(GridDogz.Cells[1, i + 1]);
    g_Config.DogzArray[i].nCount := StrToIntDef(GridDogz.Cells[2, i + 1], -1);
    g_Config.DogzArray[i].nLevel := StrToIntDef(GridDogz.Cells[3, i + 1], -1);

    Config.WriteInteger('Setup', 'DogzHumLevel' + IntToStr(i), g_Config.DogzArray[i].nHumLevel);
    Config.WriteString('Names', 'Dogz' + IntToStr(i), g_Config.DogzArray[i].sMonName);
    Config.WriteInteger('Setup', 'DogzCount' + IntToStr(i), g_Config.DogzArray[i].nCount);
    Config.WriteInteger('Setup', 'DogzLevel' + IntToStr(i), g_Config.DogzArray[i].nLevel);
  end;

  SafeFillChar(g_Config.MoonSpiritArray, SizeOf(g_Config.MoonSpiritArray), #0);
  for i := Low(g_Config.MoonSpiritArray) to High(g_Config.MoonSpiritArray) do begin
    Config.WriteInteger('Setup', 'MoonSpiritHumLevel' + IntToStr(i), 0);
    Config.WriteString('Names', 'MoonSpirit' + IntToStr(i), '');
    Config.WriteInteger('Setup', 'MoonSpiritCount' + IntToStr(i), 0);
    Config.WriteInteger('Setup', 'MoonSpiritLevel' + IntToStr(i), 0);
  end;
  for i := Low(g_Config.MoonSpiritArray) to High(g_Config.MoonSpiritArray) do begin
    if GridMoonSpirit.Cells[0, i + 1] = '' then break;

    g_Config.MoonSpiritArray[i].nHumLevel := StrToIntDef(GridMoonSpirit.Cells[0, i + 1], -1);
    g_Config.MoonSpiritArray[i].sMonName := Trim(GridMoonSpirit.Cells[1, i + 1]);
    g_Config.MoonSpiritArray[i].nCount := StrToIntDef(GridMoonSpirit.Cells[2, i + 1], -1);
    g_Config.MoonSpiritArray[i].nLevel := StrToIntDef(GridMoonSpirit.Cells[3, i + 1], -1);

    Config.WriteInteger('Setup', 'MoonSpiritHumLevel' + IntToStr(i), g_Config.MoonSpiritArray[i].nHumLevel);
    Config.WriteString('Names', 'MoonSpirit' + IntToStr(i), g_Config.MoonSpiritArray[i].sMonName);
    Config.WriteInteger('Setup', 'MoonSpiritCount' + IntToStr(i), g_Config.MoonSpiritArray[i].nCount);
    Config.WriteInteger('Setup', 'MoonSpiritLevel' + IntToStr(i), g_Config.MoonSpiritArray[i].nLevel);
  end;

{$IF SoftVersion <> VERDEMO}
  Config.WriteBool('Setup', 'LimitSwordLong', g_Config.boLimitSwordLong);
  Config.WriteInteger('Setup', 'SwordLongPowerRate', g_Config.nSwordLongPowerRate);
  Config.WriteInteger('Setup', 'BoneFammCount', g_Config.nBoneFammCount);
  Config.WriteString('Names', 'BoneFamm', g_Config.sBoneFamm);
  Config.WriteInteger('Setup', 'DogzCount', g_Config.nDogzCount);
  Config.WriteString('Names', 'Dogz', g_Config.sDogz);
  Config.WriteInteger('Setup', 'MoonSpiritCount', g_Config.nMoonSpiritCount);
  Config.WriteString('Names', 'MoonSpirit', g_Config.sMoonSpirit);
  Config.WriteInteger('Setup', 'FireBoomRage', g_Config.nFireBoomRage);
  Config.WriteInteger('Setup', 'SnowWindRange', g_Config.nSnowWindRange);
  Config.WriteInteger('Setup', 'ElecBlizzardRange', g_Config.nElecBlizzardRange);
  Config.WriteInteger('Setup', 'AmyOunsulPoint', g_Config.nAmyOunsulPoint);

  Config.WriteInteger('Setup', 'MagicAttackRage', g_Config.nMagicAttackRage);
  Config.WriteInteger('Setup', 'MagTurnUndeadLevel', g_Config.nMagTurnUndeadLevel);
  Config.WriteInteger('Setup', 'MagTammingLevel', g_Config.nMagTammingLevel);
  Config.WriteInteger('Setup', 'MagTammingTargetLevel', g_Config.nMagTammingTargetLevel);
  Config.WriteInteger('Setup', 'MagTammingTargetHPRate', g_Config.nMagTammingHPRate);
  Config.WriteInteger('Setup', 'MagTammingCount', g_Config.nMagTammingCount);

  Config.WriteInteger('Setup', 'MabMabeHitRandRate', g_Config.nMabMabeHitRandRate);
  Config.WriteInteger('Setup', 'MabMabeHitMinLvLimit', g_Config.nMabMabeHitMinLvLimit);
  Config.WriteInteger('Setup', 'MabMabeHitSucessRate', g_Config.nMabMabeHitSucessRate);
  Config.WriteInteger('Setup', 'MabMabeHitMabeTimeRate', g_Config.nMabMabeHitMabeTimeRate);

  Config.WriteBool('Setup', 'DisableInSafeZoneFireCross', g_Config.boDisableInSafeZoneFireCross);
  Config.WriteBool('Setup', 'GroupMbAttackPlayObject', g_Config.boGroupMbAttackPlayObject);

  Config.WriteBool('Setup', 'PullPlayObject', g_Config.boPullPlayObject);
  Config.WriteBool('Setup', 'PullCrossInSafeZone', g_Config.boPullCrossInSafeZone);

  Config.WriteBool('Setup', 'GroupMbAttackSlave', g_Config.boGroupMbAttackSlave);
  Config.WriteBool('Setup', 'DamageMP', g_Config.boPlayObjectReduceMP);

  Config.WriteInteger('Setup', 'MagicValidTimeRate', g_Config.nMagDelayTimeDoubly);
  Config.WriteInteger('Setup', 'MagicPowerRate', g_Config.nMagPowerDoubly);
  Config.WriteInteger('Setup', 'MagicDedingUseTime', g_Config.nDedingUseTime);

  Config.WriteBool('Setup', 'DedingAllowPK', g_Config.boDedingAllowPK);

  Config.WriteInteger('Setup', 'FireDelayTimeRate', g_Config.nFireDelayTimeRate);
  Config.WriteInteger('Setup', 'FirePowerRate', g_Config.nFirePowerRate);
  Config.WriteInteger('Setup', 'FirePlayDamageTimeRate', g_Config.nFirePlayDamageTimeRate);
  Config.WriteInteger('Setup', 'FireMonDamageTimeRate', g_Config.nFireMonDamageTimeRate);
  Config.WriteBool('Setup', 'ChangeMapFireExtinguish', g_Config.boChangeMapFireExtinguish);
  Config.WriteInteger('Setup', 'DidingPowerRate', g_Config.nDidingPowerRate);

  Config.WriteInteger('Setup', 'Skill110PowerRate', g_Config.nSkill110PowerRate);
  Config.WriteInteger('Setup', 'Skill111PowerRate', g_Config.nSkill111PowerRate);
  Config.WriteInteger('Setup', 'Skill112PowerRate', g_Config.nSkill112PowerRate);
  Config.WriteInteger('Setup', 'Skill113PowerRate', g_Config.nSkill113PowerRate);
  Config.WriteInteger('Setup', 'Skill114PowerRate', g_Config.nSkill114PowerRate);
  Config.WriteInteger('Setup', 'Skill115PowerRate', g_Config.nSkill115PowerRate);
  Config.WriteInteger('Setup', 'Skill116PowerRate', g_Config.nSkill116PowerRate);
  Config.WriteInteger('Setup', 'Skill117PowerRate', g_Config.nSkill117PowerRate);
  Config.WriteInteger('Setup', 'Skill118PowerRate', g_Config.nSkill118PowerRate);
  Config.WriteInteger('Setup', 'Skill119PowerRate', g_Config.nSkill119PowerRate);
  Config.WriteInteger('Setup', 'Skill120PowerRate', g_Config.nSkill120PowerRate);
  Config.WriteInteger('Setup', 'Skill121PowerRate', g_Config.nSkill121PowerRate);

  Config.WriteBool('Setup', 'Skill63RunHum', g_Config.boSkill63RunHum);
  Config.WriteBool('Setup', 'Skill63RunMon', g_Config.boSkill63RunMon);
  Config.WriteBool('Setup', 'Skill63RunNpc', g_Config.boSkill63RunNpc);
  Config.WriteBool('Setup', 'Skill63RunGuard', g_Config.boSkill63RunGuard);
  Config.WriteBool('Setup', 'Skill63WarDisHumRun', g_Config.boSkill63WarDisHumRun);

  Config.WriteInteger('Setup', 'Skill70PowerRate', g_Config.nSkill70PowerRate);
  Config.WriteBool('Setup', 'Skill70MbAttackMon', g_Config.boSkill70MbAttackMon);
  Config.WriteBool('Setup', 'Skill70MbAttackHuman', g_Config.boSkill70MbAttackHuman);
  Config.WriteBool('Setup', 'Skill70MbAttackSlave', g_Config.boSkill70MbAttackSlave);
  Config.WriteBool('Setup', 'Skill70MbFastParalysis', g_Config.boSkill70MbFastParalysis);
  Config.WriteBool('Setup', 'Skill70RunHum', g_Config.boSkill70RunHum);
  Config.WriteBool('Setup', 'Skill70RunMon', g_Config.boSkill70RunMon);
  Config.WriteBool('Setup', 'Skill70RunNpc', g_Config.boSkill70RunNpc);
  Config.WriteBool('Setup', 'Skill70RunGuard', g_Config.boSkill70RunGuard);
  Config.WriteBool('Setup', 'Skill70WarDisHumRun', g_Config.boSkill70WarDisHumRun);
  Config.WriteInteger('Setup', 'Skill71PowerRate', g_Config.nSkill71PowerRate);
  Config.WriteBool('Setup', 'Skill71MbAttackMon', g_Config.boSkill71MbAttackMon);
  Config.WriteBool('Setup', 'Skill71MbAttackHuman', g_Config.boSkill71MbAttackHuman);
  Config.WriteBool('Setup', 'Skill71MbAttackSlave', g_Config.boSkill71MbAttackSlave);
  Config.WriteBool('Setup', 'Skill71MbFastParalysis', g_Config.boSkill71MbFastParalysis);
  Config.WriteInteger('Setup', 'Skill72PowerRate', g_Config.nSkill72PowerRate);
  Config.WriteBool('Setup', 'Skill72MbAttackMon', g_Config.boSkill72MbAttackMon);
  Config.WriteBool('Setup', 'Skill72MbAttackHuman', g_Config.boSkill72MbAttackHuman);
  Config.WriteBool('Setup', 'Skill72MbAttackSlave', g_Config.boSkill72MbAttackSlave);
  Config.WriteBool('Setup', 'Skill72Damagearmor', g_Config.boSkill72Damagearmor);
  Config.WriteBool('Setup', 'Skill72DecHealth', g_Config.boSkill72DecHealth);
  Config.WriteBool('Setup', 'Skill72MbFastParalysis', g_Config.boSkill72MbFastParalysis);

  Config.WriteInteger('Setup', 'EtenMagicSize', g_Config.nEtenMagicSize);
  Config.WriteInteger('Setup', 'EtenPowerRate', g_Config.nEtenPowerRate);
  Config.WriteInteger('Setup', 'ProtectShieldRunRate0', g_Config.nProtectShieldRunRate0);
  Config.WriteInteger('Setup', 'ProtectShieldRunRate1', g_Config.nProtectShieldRunRate1);
  Config.WriteInteger('Setup', 'ProtectShieldRunRate2', g_Config.nProtectShieldRunRate2);
  Config.WriteInteger('Setup', 'ProtectShieldRunRate3', g_Config.nProtectShieldRunRate3);
  Config.WriteInteger('Setup', 'ProtectShieldDelDamage0', g_Config.nProtectShieldDelDamage0);
  Config.WriteInteger('Setup', 'ProtectShieldDelDamage1', g_Config.nProtectShieldDelDamage1);
  Config.WriteInteger('Setup', 'ProtectShieldDelDamage2', g_Config.nProtectShieldDelDamage2);
  Config.WriteInteger('Setup', 'ProtectShieldDelDamage3', g_Config.nProtectShieldDelDamage3);

  Config.WriteBool('Setup', 'Skill66ReduceMP', g_Config.boSkill66ReduceMP);

  Config.WriteInteger('Setup', 'MagicAttackMonsteRate', g_Config.nMagicAttackMonsteRate);

  {分身术}
  {if g_Config.sCopyHumName = '' then begin
    Application.MessageBox('分身人物名称不能为空.', '错误信息', MB_OK + MB_ICONERROR);
    Exit;
  end;
  Config.WriteInteger('Setup', 'CopyHumanBagCount', g_Config.nCopyHumanBagCount);
  Config.WriteInteger('Setup', 'AllowCopyHumanCount', g_Config.nAllowCopyHumanCount);
  Config.WriteBool('Setup', 'AddMasterName', g_Config.boAddMasterName);
  Config.WriteString('Setup', 'CopyHumName', g_Config.sCopyHumName);
  Config.WriteInteger('Setup', 'CopyHumAddHPRate', g_Config.nCopyHumAddHPRate);
  Config.WriteInteger('Setup', 'CopyHumAddMPRate', g_Config.nCopyHumAddMPRate);
  Config.WriteString('Setup', 'CopyHumBagItems1', g_Config.sCopyHumBagItems1);
  Config.WriteString('Setup', 'CopyHumBagItems2', g_Config.sCopyHumBagItems2);
  Config.WriteString('Setup', 'CopyHumBagItems3', g_Config.sCopyHumBagItems3);
  Config.WriteBool('Setup', 'AllowGuardAttack', g_Config.boAllowGuardAttack);

  Config.WriteInteger('Setup', 'WarrorAttackTime', g_Config.dwWarrorAttackTime);
  Config.WriteInteger('Setup', 'WizardAttackTime', g_Config.dwWizardAttackTime);
  Config.WriteInteger('Setup', 'TaoistAttackTime', g_Config.dwTaoistAttackTime);

  Config.WriteBool('Setup', 'AllowReCallMobOtherHum', g_Config.boAllowReCallMobOtherHum);
  Config.WriteBool('Setup', 'NeedLevelHighTarget', g_Config.boNeedLevelHighTarget);   }
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.RefUpgradeWeapon();
begin
  ScrollBarUpgradeWeaponDCRate.Position := g_Config.nUpgradeWeaponDCRate;
  ScrollBarUpgradeWeaponDCTwoPointRate.Position :=
    g_Config.nUpgradeWeaponDCTwoPointRate;
  ScrollBarUpgradeWeaponDCThreePointRate.Position :=
    g_Config.nUpgradeWeaponDCThreePointRate;

  ScrollBarUpgradeWeaponMCRate.Position := g_Config.nUpgradeWeaponMCRate;
  ScrollBarUpgradeWeaponMCTwoPointRate.Position :=
    g_Config.nUpgradeWeaponMCTwoPointRate;
  ScrollBarUpgradeWeaponMCThreePointRate.Position :=
    g_Config.nUpgradeWeaponMCThreePointRate;

  ScrollBarUpgradeWeaponSCRate.Position := g_Config.nUpgradeWeaponSCRate;
  ScrollBarUpgradeWeaponSCTwoPointRate.Position :=
    g_Config.nUpgradeWeaponSCTwoPointRate;
  ScrollBarUpgradeWeaponSCThreePointRate.Position :=
    g_Config.nUpgradeWeaponSCThreePointRate;

  EditUpgradeWeaponMaxPoint.Value := g_Config.nUpgradeWeaponMaxPoint;
  EditUpgradeWeaponPrice.Value := g_Config.nUpgradeWeaponPrice;
  EditUPgradeWeaponGetBackTime.Value := g_Config.dwUPgradeWeaponGetBackTime div
    1000;
  EditClearExpireUpgradeWeaponDays.Value :=
    g_Config.nClearExpireUpgradeWeaponDays;
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponDCRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarUpgradeWeaponDCRate.Position;
  EditUpgradeWeaponDCRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponDCRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponDCTwoPointRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarUpgradeWeaponDCTwoPointRate.Position;
  EditUpgradeWeaponDCTwoPointRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponDCTwoPointRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponDCThreePointRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarUpgradeWeaponDCThreePointRate.Position;
  EditUpgradeWeaponDCThreePointRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponDCThreePointRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponSCRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarUpgradeWeaponSCRate.Position;
  EditUpgradeWeaponSCRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponSCRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponSCTwoPointRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarUpgradeWeaponSCTwoPointRate.Position;
  EditUpgradeWeaponSCTwoPointRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponSCTwoPointRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponSCThreePointRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarUpgradeWeaponSCThreePointRate.Position;
  EditUpgradeWeaponSCThreePointRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponSCThreePointRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponMCRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarUpgradeWeaponMCRate.Position;
  EditUpgradeWeaponMCRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponMCRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponMCTwoPointRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarUpgradeWeaponMCTwoPointRate.Position;
  EditUpgradeWeaponMCTwoPointRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponMCTwoPointRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarUpgradeWeaponMCThreePointRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarUpgradeWeaponMCThreePointRate.Position;
  EditUpgradeWeaponMCThreePointRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponMCThreePointRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.EditUpgradeWeaponMaxPointChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponMaxPoint := EditUpgradeWeaponMaxPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditUpgradeWeaponPriceChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nUpgradeWeaponPrice := EditUpgradeWeaponPrice.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditUnLuckMaxCountChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nWeaponMakeUnLuckMaxCount := EditUnLuckMaxCount.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditUPgradeWeaponGetBackTimeChange(Sender:
  TObject);
begin
  if not boOpened then
    Exit;
  g_Config.dwUPgradeWeaponGetBackTime := EditUPgradeWeaponGetBackTime.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.EditClearExpireUpgradeWeaponDaysChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nClearExpireUpgradeWeaponDays :=
    EditClearExpireUpgradeWeaponDays.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.ButtonUpgradeWeaponSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup', 'UpgradeWeaponMaxPoint',
    g_Config.nUpgradeWeaponMaxPoint);
  Config.WriteInteger('Setup', 'UpgradeWeaponPrice',
    g_Config.nUpgradeWeaponPrice);
  Config.WriteInteger('Setup', 'ClearExpireUpgradeWeaponDays',
    g_Config.nClearExpireUpgradeWeaponDays);
  Config.WriteInteger('Setup', 'UPgradeWeaponGetBackTime',
    g_Config.dwUPgradeWeaponGetBackTime);

  Config.WriteInteger('Setup', 'UpgradeWeaponDCRate',
    g_Config.nUpgradeWeaponDCRate);
  Config.WriteInteger('Setup', 'UpgradeWeaponDCTwoPointRate',
    g_Config.nUpgradeWeaponDCTwoPointRate);
  Config.WriteInteger('Setup', 'UpgradeWeaponDCThreePointRate',
    g_Config.nUpgradeWeaponDCThreePointRate);

  Config.WriteInteger('Setup', 'UpgradeWeaponMCRate',
    g_Config.nUpgradeWeaponMCRate);
  Config.WriteInteger('Setup', 'UpgradeWeaponMCTwoPointRate',
    g_Config.nUpgradeWeaponMCTwoPointRate);
  Config.WriteInteger('Setup', 'UpgradeWeaponMCThreePointRate',
    g_Config.nUpgradeWeaponMCThreePointRate);

  Config.WriteInteger('Setup', 'UpgradeWeaponSCRate',
    g_Config.nUpgradeWeaponSCRate);
  Config.WriteInteger('Setup', 'UpgradeWeaponSCTwoPointRate',
    g_Config.nUpgradeWeaponSCTwoPointRate);
  Config.WriteInteger('Setup', 'UpgradeWeaponSCThreePointRate',
    g_Config.nUpgradeWeaponSCThreePointRate);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.ButtonUpgradeWeaponDefaulfClick(
  Sender: TObject);
begin
  if Application.MessageBox('是否确认恢复默认设置？', '确认信息',
    MB_YESNO +
    MB_ICONQUESTION) <> IDYES then begin
    Exit;
  end;
  g_Config.nUpgradeWeaponMaxPoint := 20;
  g_Config.nUpgradeWeaponPrice := 10000;
  g_Config.nClearExpireUpgradeWeaponDays := 8;
  g_Config.dwUPgradeWeaponGetBackTime := 60 * 60 * 1000;

  g_Config.nUpgradeWeaponDCRate := 100;
  g_Config.nUpgradeWeaponDCTwoPointRate := 30;
  g_Config.nUpgradeWeaponDCThreePointRate := 200;

  g_Config.nUpgradeWeaponMCRate := 100;
  g_Config.nUpgradeWeaponMCTwoPointRate := 30;
  g_Config.nUpgradeWeaponMCThreePointRate := 200;

  g_Config.nUpgradeWeaponSCRate := 100;
  g_Config.nUpgradeWeaponSCTwoPointRate := 30;
  g_Config.nUpgradeWeaponSCThreePointRate := 200;
  RefUpgradeWeapon();
end;

procedure TfrmFunctionConfig.EditMasterOKLevelChange(Sender: TObject);
begin
  if EditMasterOKLevel.Text = '' then begin
    EditMasterOKLevel.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nMasterOKLevel := EditMasterOKLevel.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMasterOKCreditPointChange(
  Sender: TObject);
begin
  if EditMasterOKCreditPoint.Text = '' then begin
    EditMasterOKCreditPoint.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nMasterOKCreditPoint := EditMasterOKCreditPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMasterOKBonusPointChange(Sender: TObject);
begin
  if EditMasterOKBonusPoint.Text = '' then begin
    EditMasterOKBonusPoint.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nMasterOKBonusPoint := EditMasterOKBonusPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.ButtonMasterSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup', 'MasterOKLevel', g_Config.nMasterOKLevel);
  Config.WriteInteger('Setup', 'MasterOKCreditPoint',
    g_Config.nMasterOKCreditPoint);
  Config.WriteInteger('Setup', 'MasterOKBonusPoint',
    g_Config.nMasterOKBonusPoint);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.ButtonMakeMineSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup', 'MakeMineHitRate', g_Config.nMakeMineHitRate);
  Config.WriteInteger('Setup', 'MakeMineRate', g_Config.nMakeMineRate);
  Config.WriteInteger('Setup', 'StoneTypeRate', g_Config.nStoneTypeRate);
  Config.WriteInteger('Setup', 'StoneTypeRateMin', g_Config.nStoneTypeRateMin);
  Config.WriteInteger('Setup', 'GoldStoneMin', g_Config.nGoldStoneMin);
  Config.WriteInteger('Setup', 'GoldStoneMax', g_Config.nGoldStoneMax);
  Config.WriteInteger('Setup', 'SilverStoneMin', g_Config.nSilverStoneMin);
  Config.WriteInteger('Setup', 'SilverStoneMax', g_Config.nSilverStoneMax);
  Config.WriteInteger('Setup', 'SteelStoneMin', g_Config.nSteelStoneMin);
  Config.WriteInteger('Setup', 'SteelStoneMax', g_Config.nSteelStoneMax);
  Config.WriteInteger('Setup', 'BlackStoneMin', g_Config.nBlackStoneMin);
  Config.WriteInteger('Setup', 'BlackStoneMax', g_Config.nBlackStoneMax);
  Config.WriteInteger('Setup', 'StoneMinDura', g_Config.nStoneMinDura);
  Config.WriteInteger('Setup', 'StoneGeneralDuraRate',
    g_Config.nStoneGeneralDuraRate);
  Config.WriteInteger('Setup', 'StoneAddDuraRate', g_Config.nStoneAddDuraRate);
  Config.WriteInteger('Setup', 'StoneAddDuraMax', g_Config.nStoneAddDuraMax);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.ButtonMakeMineDefaultClick(Sender: TObject);
begin
  if Application.MessageBox('是否确认恢复默认设置？', '确认信息',
    MB_YESNO +
    MB_ICONQUESTION) <> IDYES then begin
    Exit;
  end;
  g_Config.nMakeMineHitRate := 4;
  g_Config.nMakeMineRate := 12;
  g_Config.nStoneTypeRate := 120;
  g_Config.nStoneTypeRateMin := 56;
  g_Config.nGoldStoneMin := 0;
  g_Config.nGoldStoneMax := 2;
  g_Config.nSilverStoneMin := 3;
  g_Config.nSilverStoneMax := 20;
  g_Config.nSteelStoneMin := 21;
  g_Config.nSteelStoneMax := 45;
  g_Config.nBlackStoneMin := 46;
  g_Config.nBlackStoneMax := 56;
  g_Config.nStoneMinDura := 3000;
  g_Config.nStoneGeneralDuraRate := 13000;
  g_Config.nStoneAddDuraRate := 20;
  g_Config.nStoneAddDuraMax := 10000;
  RefMakeMine();
end;

procedure TfrmFunctionConfig.RefMakeMagic;
begin
  EditMakeMagicAddPoint.Value := g_Config.btMakeMagicAddPoint;
  EditMakeMagicUsePoint.Value := g_Config.btMakeMagicUsePoint;
  EditMakeMagicAddRate.Value := g_Config.btMakeMagicAddRate;
  EditMakeMagicMaxLevel.Value := g_Config.btMakeMagicMaxLevel;
  seEditMakeMagicMaxBeginLevel.Value := g_Config.nMakeMagicBeginLevel;

  GridMakeMagic.Cells[0, 0] := '技能等级';
  GridMakeMagic.Cells[1, 0] := '人物等级';
  ComboBoxMakeMagicTypeChange(ComboBoxMakeMagicType);
end;

procedure TfrmFunctionConfig.RefMakeMine();
begin
  ScrollBarMakeMineHitRate.Position := g_Config.nMakeMineHitRate;
  ScrollBarMakeMineHitRate.Min := 0;
  ScrollBarMakeMineHitRate.Max := 10;

  ScrollBarMakeMineRate.Position := g_Config.nMakeMineRate;
  ScrollBarMakeMineRate.Min := 0;
  ScrollBarMakeMineRate.Max := 50;

  ScrollBarStoneTypeRate.Position := g_Config.nStoneTypeRate;
  ScrollBarStoneTypeRate.Min := g_Config.nStoneTypeRateMin;
  ScrollBarStoneTypeRate.Max := 500;

  ScrollBarGoldStoneMax.Min := 0;
  ScrollBarGoldStoneMax.Max := g_Config.nSilverStoneMax;

  ScrollBarSilverStoneMax.Min := g_Config.nGoldStoneMax;
  ScrollBarSilverStoneMax.Max := g_Config.nSteelStoneMax;

  ScrollBarSteelStoneMax.Min := g_Config.nSilverStoneMax;
  ScrollBarSteelStoneMax.Max := g_Config.nStoneTypeRate{g_Config.nBlackStoneMax};

  //ScrollBarBlackStoneMax.Min := g_Config.nSteelStoneMax;
  //ScrollBarBlackStoneMax.Max := g_Config.nStoneTypeRate;

  ScrollBarGoldStoneMax.Position := g_Config.nGoldStoneMax;
  ScrollBarSilverStoneMax.Position := g_Config.nSilverStoneMax;
  ScrollBarSteelStoneMax.Position := g_Config.nSteelStoneMax;
  ScrollBarBlackStoneMax.Position := g_Config.nBlackStoneMax;

  EditStoneMinDura.Value := g_Config.nStoneMinDura div 1000;
  EditStoneGeneralDuraRate.Value := g_Config.nStoneGeneralDuraRate div 1000;
  EditStoneAddDuraRate.Value := g_Config.nStoneAddDuraRate;
  EditStoneAddDuraMax.Value := g_Config.nStoneAddDuraMax div 1000;
end;

procedure TfrmFunctionConfig.ScrollBarMakeMineHitRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarMakeMineHitRate.Position;
  EditMakeMineHitRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nMakeMineHitRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarMakeMineRateChange(Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarMakeMineRate.Position;
  EditMakeMineRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  g_Config.nMakeMineRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarStoneTypeRateChange(Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarStoneTypeRate.Position;
  EditStoneTypeRate.Text := IntToStr(nPostion);
  if not boOpened then Exit;
  ScrollBarSteelStoneMax.Max := nPostion;
  g_Config.nStoneTypeRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarGoldStoneMaxChange(Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarGoldStoneMax.Position;
  EditGoldStoneMax.Text := IntToStr(g_Config.nGoldStoneMin) + '-' + IntToStr(g_Config.nGoldStoneMax);
  if not boOpened then Exit;
  g_Config.nGoldStoneMax := nPostion;
  g_Config.nSilverStoneMin := nPostion + 1;
  ScrollBarSilverStoneMax.Min := nPostion + 1;
  EditSilverStoneMax.Text := IntToStr(g_Config.nSilverStoneMin) + '-' + IntToStr(g_Config.nSilverStoneMax);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarSilverStoneMaxChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarSilverStoneMax.Position;
  EditSilverStoneMax.Text := IntToStr(g_Config.nSilverStoneMin) + '-' + IntToStr(g_Config.nSilverStoneMax);
  if not boOpened then Exit;
  g_Config.nSilverStoneMax := nPostion;
  ScrollBarGoldStoneMax.Max := nPostion - 1;
  g_Config.nSteelStoneMin := nPostion + 1;
  ScrollBarSteelStoneMax.Min := nPostion + 1;

  EditGoldStoneMax.Text := IntToStr(g_Config.nGoldStoneMin) + '-' + IntToStr(g_Config.nGoldStoneMax);
  EditSteelStoneMax.Text := IntToStr(g_Config.nSteelStoneMin) + '-' + IntToStr(g_Config.nSteelStoneMax);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarSteelStoneMaxChange(Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarSteelStoneMax.Position;
  EditSteelStoneMax.Text := IntToStr(g_Config.nSteelStoneMin) + '-' + IntToStr(g_Config.nSteelStoneMax);
  if not boOpened then Exit;
  g_Config.nBlackStoneMin := nPostion + 1;
  ScrollBarSilverStoneMax.Max := nPostion - 1;
  ScrollBarStoneTypeRate.Min := nPostion;
  g_Config.nSteelStoneMax := nPostion;
  {ScrollBarSilverStoneMax.Max := nPostion - 1;
  g_Config.nBlackStoneMin := nPostion + 1;
  ScrollBarBlackStoneMax.Min := nPostion + 1;
  g_Config.nSteelStoneMax := nPostion;   }
  EditSilverStoneMax.Text := IntToStr(g_Config.nSilverStoneMin) + '-' + IntToStr(g_Config.nSilverStoneMax);
  EditBlackStoneMax.Text := IntToStr(g_Config.nBlackStoneMin) + '-' + IntToStr(g_Config.nBlackStoneMax);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarBlackStoneMaxChange(Sender: TObject);
{var
  nPostion: Integer;  }
begin
{  nPostion := ScrollBarBlackStoneMax.Position;
  EditBlackStoneMax.Text := IntToStr(g_Config.nBlackStoneMin) + '-' +
    IntToStr(g_Config.nBlackStoneMax);
  if not boOpened then
    Exit;
  ScrollBarSteelStoneMax.Max := nPostion - 1;
  ScrollBarStoneTypeRate.Min := nPostion;
  g_Config.nBlackStoneMax := nPostion;
  EditSteelStoneMax.Text := IntToStr(g_Config.nSteelStoneMin) + '-' +
    IntToStr(g_Config.nSteelStoneMax);
  ModValue(); }
end;

procedure TfrmFunctionConfig.EditStoneMinDuraChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nStoneMinDura := EditStoneMinDura.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.EditStoneGeneralDuraRateChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nStoneGeneralDuraRate := EditStoneGeneralDuraRate.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.EditStoneAddDuraRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nStoneAddDuraRate := EditStoneAddDuraRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditStoneAddDuraMaxChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nStoneAddDuraMax := EditStoneAddDuraMax.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.RefWinLottery;
begin
  ScrollBarWinLotteryRate.Max := 100000;
  ScrollBarWinLotteryRate.Position := g_Config.nWinLotteryRate;
  ScrollBarWinLottery1Max.Max := g_Config.nWinLotteryRate;
  ScrollBarWinLottery1Max.Min := g_Config.nWinLottery1Min;
  ScrollBarWinLottery2Max.Max := g_Config.nWinLottery1Max;
  ScrollBarWinLottery2Max.Min := g_Config.nWinLottery2Min;
  ScrollBarWinLottery3Max.Max := g_Config.nWinLottery2Max;
  ScrollBarWinLottery3Max.Min := g_Config.nWinLottery3Min;
  ScrollBarWinLottery4Max.Max := g_Config.nWinLottery3Max;
  ScrollBarWinLottery4Max.Min := g_Config.nWinLottery4Min;
  ScrollBarWinLottery5Max.Max := g_Config.nWinLottery4Max;
  ScrollBarWinLottery5Max.Min := g_Config.nWinLottery5Min;
  ScrollBarWinLottery6Max.Max := g_Config.nWinLottery5Max;
  ScrollBarWinLottery6Max.Min := g_Config.nWinLottery6Min;
  ScrollBarWinLotteryRate.Min := g_Config.nWinLottery1Max;

  ScrollBarWinLottery1Max.Position := g_Config.nWinLottery1Max;
  ScrollBarWinLottery2Max.Position := g_Config.nWinLottery2Max;
  ScrollBarWinLottery3Max.Position := g_Config.nWinLottery3Max;
  ScrollBarWinLottery4Max.Position := g_Config.nWinLottery4Max;
  ScrollBarWinLottery5Max.Position := g_Config.nWinLottery5Max;
  ScrollBarWinLottery6Max.Position := g_Config.nWinLottery6Max;

  EditWinLottery1Gold.Value := g_Config.nWinLottery1Gold;
  EditWinLottery2Gold.Value := g_Config.nWinLottery2Gold;
  EditWinLottery3Gold.Value := g_Config.nWinLottery3Gold;
  EditWinLottery4Gold.Value := g_Config.nWinLottery4Gold;
  EditWinLottery5Gold.Value := g_Config.nWinLottery5Gold;
  EditWinLottery6Gold.Value := g_Config.nWinLottery6Gold;
end;

procedure TfrmFunctionConfig.ButtonWinLotterySaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup', 'WinLottery1Gold', g_Config.nWinLottery1Gold);
  Config.WriteInteger('Setup', 'WinLottery2Gold', g_Config.nWinLottery2Gold);
  Config.WriteInteger('Setup', 'WinLottery3Gold', g_Config.nWinLottery3Gold);
  Config.WriteInteger('Setup', 'WinLottery4Gold', g_Config.nWinLottery4Gold);
  Config.WriteInteger('Setup', 'WinLottery5Gold', g_Config.nWinLottery5Gold);
  Config.WriteInteger('Setup', 'WinLottery6Gold', g_Config.nWinLottery6Gold);
  Config.WriteInteger('Setup', 'WinLottery1Min', g_Config.nWinLottery1Min);
  Config.WriteInteger('Setup', 'WinLottery1Max', g_Config.nWinLottery1Max);
  Config.WriteInteger('Setup', 'WinLottery2Min', g_Config.nWinLottery2Min);
  Config.WriteInteger('Setup', 'WinLottery2Max', g_Config.nWinLottery2Max);
  Config.WriteInteger('Setup', 'WinLottery3Min', g_Config.nWinLottery3Min);
  Config.WriteInteger('Setup', 'WinLottery3Max', g_Config.nWinLottery3Max);
  Config.WriteInteger('Setup', 'WinLottery4Min', g_Config.nWinLottery4Min);
  Config.WriteInteger('Setup', 'WinLottery4Max', g_Config.nWinLottery4Max);
  Config.WriteInteger('Setup', 'WinLottery5Min', g_Config.nWinLottery5Min);
  Config.WriteInteger('Setup', 'WinLottery5Max', g_Config.nWinLottery5Max);
  Config.WriteInteger('Setup', 'WinLottery6Min', g_Config.nWinLottery6Min);
  Config.WriteInteger('Setup', 'WinLottery6Max', g_Config.nWinLottery6Max);
  Config.WriteInteger('Setup', 'WinLotteryRate', g_Config.nWinLotteryRate);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.ButtonWinLotteryDefaultClick(Sender: TObject);
begin
  if Application.MessageBox('是否确认恢复默认设置？', '确认信息',
    MB_YESNO +
    MB_ICONQUESTION) <> IDYES then begin
    Exit;
  end;

  g_Config.nWinLottery1Gold := 1000000;
  g_Config.nWinLottery2Gold := 200000;
  g_Config.nWinLottery3Gold := 100000;
  g_Config.nWinLottery4Gold := 10000;
  g_Config.nWinLottery5Gold := 1000;
  g_Config.nWinLottery6Gold := 500;
  g_Config.nWinLottery6Min := 1;
  g_Config.nWinLottery6Max := 4999;
  g_Config.nWinLottery5Min := 14000;
  g_Config.nWinLottery5Max := 15999;
  g_Config.nWinLottery4Min := 16000;
  g_Config.nWinLottery4Max := 16149;
  g_Config.nWinLottery3Min := 16150;
  g_Config.nWinLottery3Max := 16169;
  g_Config.nWinLottery2Min := 16170;
  g_Config.nWinLottery2Max := 16179;
  g_Config.nWinLottery1Min := 16180;
  g_Config.nWinLottery1Max := 16185;
  g_Config.nWinLotteryRate := 30000;
  RefWinLottery();
end;

procedure TfrmFunctionConfig.EditWinLottery1GoldChange(Sender: TObject);
begin
  if EditWinLottery1Gold.Text = '' then begin
    EditWinLottery1Gold.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nWinLottery1Gold := EditWinLottery1Gold.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditWinLottery2GoldChange(Sender: TObject);
begin
  if EditWinLottery2Gold.Text = '' then begin
    EditWinLottery2Gold.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nWinLottery2Gold := EditWinLottery2Gold.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditWinLottery3GoldChange(Sender: TObject);
begin
  if EditWinLottery3Gold.Text = '' then begin
    EditWinLottery3Gold.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nWinLottery3Gold := EditWinLottery3Gold.Value;
  ModValue();

end;

procedure TfrmFunctionConfig.EditWinLottery4GoldChange(Sender: TObject);
begin
  if EditWinLottery4Gold.Text = '' then begin
    EditWinLottery4Gold.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nWinLottery4Gold := EditWinLottery4Gold.Value;
  ModValue();

end;

procedure TfrmFunctionConfig.EditWinLottery5GoldChange(Sender: TObject);
begin
  if EditWinLottery5Gold.Text = '' then begin
    EditWinLottery5Gold.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nWinLottery5Gold := EditWinLottery5Gold.Value;
  ModValue();

end;

procedure TfrmFunctionConfig.EditWinLottery6GoldChange(Sender: TObject);
begin
  if EditWinLottery6Gold.Text = '' then begin
    EditWinLottery6Gold.Text := '0';
    Exit;
  end;
  if not boOpened then
    Exit;
  g_Config.nWinLottery6Gold := EditWinLottery6Gold.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWinLottery1MaxChange(Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarWinLottery1Max.Position;
  EditWinLottery1Max.Text := IntToStr(g_Config.nWinLottery1Min) + '-' +
    IntToStr(g_Config.nWinLottery1Max);
  if not boOpened then
    Exit;
  g_Config.nWinLottery1Max := nPostion;
  ScrollBarWinLottery2Max.Max := nPostion - 1;
  ScrollBarWinLotteryRate.Min := nPostion;
  EditWinLottery1Max.Text := IntToStr(g_Config.nWinLottery1Min) + '-' +
    IntToStr(g_Config.nWinLottery1Max);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWinLottery2MaxChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarWinLottery2Max.Position;
  EditWinLottery2Max.Text := IntToStr(g_Config.nWinLottery2Min) + '-' +
    IntToStr(g_Config.nWinLottery2Max);
  if not boOpened then
    Exit;
  g_Config.nWinLottery1Min := nPostion + 1;
  ScrollBarWinLottery1Max.Min := nPostion + 1;
  g_Config.nWinLottery2Max := nPostion;
  EditWinLottery2Max.Text := IntToStr(g_Config.nWinLottery2Min) + '-' +
    IntToStr(g_Config.nWinLottery2Max);
  EditWinLottery1Max.Text := IntToStr(g_Config.nWinLottery1Min) + '-' +
    IntToStr(g_Config.nWinLottery1Max);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWinLottery3MaxChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarWinLottery3Max.Position;
  EditWinLottery3Max.Text := IntToStr(g_Config.nWinLottery3Min) + '-' +
    IntToStr(g_Config.nWinLottery3Max);
  if not boOpened then
    Exit;
  g_Config.nWinLottery2Min := nPostion + 1;
  ScrollBarWinLottery2Max.Min := nPostion + 1;
  g_Config.nWinLottery3Max := nPostion;
  EditWinLottery3Max.Text := IntToStr(g_Config.nWinLottery3Min) + '-' +
    IntToStr(g_Config.nWinLottery3Max);
  EditWinLottery2Max.Text := IntToStr(g_Config.nWinLottery2Min) + '-' +
    IntToStr(g_Config.nWinLottery2Max);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWinLottery4MaxChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarWinLottery4Max.Position;
  EditWinLottery4Max.Text := IntToStr(g_Config.nWinLottery4Min) + '-' +
    IntToStr(g_Config.nWinLottery4Max);
  if not boOpened then
    Exit;
  g_Config.nWinLottery3Min := nPostion + 1;
  ScrollBarWinLottery3Max.Min := nPostion + 1;
  g_Config.nWinLottery4Max := nPostion;
  EditWinLottery4Max.Text := IntToStr(g_Config.nWinLottery4Min) + '-' +
    IntToStr(g_Config.nWinLottery4Max);
  EditWinLottery3Max.Text := IntToStr(g_Config.nWinLottery3Min) + '-' +
    IntToStr(g_Config.nWinLottery3Max);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWinLottery5MaxChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarWinLottery5Max.Position;
  EditWinLottery5Max.Text := IntToStr(g_Config.nWinLottery5Min) + '-' +
    IntToStr(g_Config.nWinLottery5Max);
  if not boOpened then
    Exit;
  g_Config.nWinLottery4Min := nPostion + 1;
  ScrollBarWinLottery4Max.Min := nPostion + 1;
  g_Config.nWinLottery5Max := nPostion;
  EditWinLottery5Max.Text := IntToStr(g_Config.nWinLottery5Min) + '-' +
    IntToStr(g_Config.nWinLottery5Max);
  EditWinLottery4Max.Text := IntToStr(g_Config.nWinLottery4Min) + '-' +
    IntToStr(g_Config.nWinLottery4Max);
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWinLottery6MaxChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarWinLottery6Max.Position;
  EditWinLottery6Max.Text := IntToStr(g_Config.nWinLottery6Min) + '-' +
    IntToStr(g_Config.nWinLottery6Max);
  if not boOpened then
    Exit;
  g_Config.nWinLottery5Min := nPostion + 1;
  ScrollBarWinLottery5Max.Min := nPostion + 1;
  g_Config.nWinLottery6Max := nPostion;
  EditWinLottery6Max.Text := IntToStr(g_Config.nWinLottery6Min) + '-' +
    IntToStr(g_Config.nWinLottery6Max);
  EditWinLottery5Max.Text := IntToStr(g_Config.nWinLottery5Min) + '-' +
    IntToStr(g_Config.nWinLottery5Max);
  ModValue();

end;

procedure TfrmFunctionConfig.ScrollBarWinLotteryRateChange(
  Sender: TObject);
var
  nPostion: Integer;
begin
  nPostion := ScrollBarWinLotteryRate.Position;
  EditWinLotteryRate.Text := IntToStr(nPostion);
  if not boOpened then
    Exit;
  ScrollBarWinLottery1Max.Max := nPostion;
  g_Config.nWinLotteryRate := nPostion;
  ModValue();
end;

procedure TfrmFunctionConfig.seEditMakeMagicMaxBeginLevelChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nMakeMagicBeginLevel := seEditMakeMagicMaxBeginLevel.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.seFireMonDamageTimeRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nFireMonDamageTimeRate := seFireMonDamageTimeRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.seFirePlayDamageTimeRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nFirePlayDamageTimeRate := seFirePlayDamageTimeRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.seSkill110PowerRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nSkill110PowerRate := seSkill110PowerRate.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.seSkill111PowerRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nSkill111PowerRate := seSkill111PowerRate.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.seSkill112PowerRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nSkill112PowerRate := seSkill112PowerRate.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.seSkill113PowerRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nSkill113PowerRate := seSkill113PowerRate.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.seSkill114PowerRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nSkill114PowerRate := seSkill114PowerRate.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.seSkill115PowerRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nSkill115PowerRate := seSkill115PowerRate.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.seSkill116PowerRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nSkill116PowerRate := seSkill116PowerRate.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.seSkill117PowerRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nSkill117PowerRate := seSkill117PowerRate.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.seSkill118PowerRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nSkill118PowerRate := seSkill118PowerRate.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.seSkill119PowerRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nSkill119PowerRate := seSkill119PowerRate.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.seSkill120PowerRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nSkill120PowerRate := seSkill120PowerRate.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.seSkill121PowerRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nSkill121PowerRate := seSkill121PowerRate.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.RefReNewLevelConf();
begin
  EditReNewNameColor1.Value := g_Config.ReNewNameColor[0];
  EditReNewNameColor2.Value := g_Config.ReNewNameColor[1];
  EditReNewNameColor3.Value := g_Config.ReNewNameColor[2];
  EditReNewNameColor4.Value := g_Config.ReNewNameColor[3];
  EditReNewNameColor5.Value := g_Config.ReNewNameColor[4];
  EditReNewNameColor6.Value := g_Config.ReNewNameColor[5];
  EditReNewNameColor7.Value := g_Config.ReNewNameColor[6];
  EditReNewNameColor8.Value := g_Config.ReNewNameColor[7];
  EditReNewNameColor9.Value := g_Config.ReNewNameColor[8];
  EditReNewNameColor10.Value := g_Config.ReNewNameColor[9];
  EditReNewNameColorTime.Value := g_Config.dwReNewNameColorTime div 1000;
  CheckBoxReNewChangeColor.Checked := g_Config.boReNewChangeColor;
  CheckBoxReNewLevelClearExp.Checked := g_Config.boReNewLevelClearExp;
end;

procedure TfrmFunctionConfig.ButtonReNewLevelSaveClick(Sender: TObject);
{$IF SoftVersion <> VERDEMO}
var
  i: Integer;
{$IFEND}
begin
{$IF SoftVersion <> VERDEMO}
  for i := Low(g_Config.ReNewNameColor) to High(g_Config.ReNewNameColor) do begin
    Config.WriteInteger('Setup', 'ReNewNameColor' + IntToStr(i),
      g_Config.ReNewNameColor[i]);
  end;
  Config.WriteInteger('Setup', 'ReNewNameColorTime',
    g_Config.dwReNewNameColorTime);
  Config.WriteBool('Setup', 'ReNewChangeColor', g_Config.boReNewChangeColor);
  Config.WriteBool('Setup', 'ReNewLevelClearExp',
    g_Config.boReNewLevelClearExp);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor1Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditReNewNameColor1.Value;
  LabelReNewNameColor1.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[0] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor2Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditReNewNameColor2.Value;
  LabelReNewNameColor2.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[1] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor3Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditReNewNameColor3.Value;
  LabelReNewNameColor3.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[2] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor4Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditReNewNameColor4.Value;
  LabelReNewNameColor4.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[3] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor5Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditReNewNameColor5.Value;
  LabelReNewNameColor5.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[4] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor6Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditReNewNameColor6.Value;
  LabelReNewNameColor6.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[5] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor7Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditReNewNameColor7.Value;
  LabelReNewNameColor7.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[6] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor8Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditReNewNameColor8.Value;
  LabelReNewNameColor8.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[7] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor9Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditReNewNameColor9.Value;
  LabelReNewNameColor9.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[8] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColor10Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditReNewNameColor10.Value;
  LabelReNewNameColor10.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.ReNewNameColor[9] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditReNewNameColorTimeChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.dwReNewNameColorTime := EditReNewNameColorTime.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.RefMonUpgrade();
begin
  EditMonUpgradeColor1.Value := g_Config.SlaveColor[0];
  EditMonUpgradeColor2.Value := g_Config.SlaveColor[1];
  EditMonUpgradeColor3.Value := g_Config.SlaveColor[2];
  EditMonUpgradeColor4.Value := g_Config.SlaveColor[3];
  EditMonUpgradeColor5.Value := g_Config.SlaveColor[4];
  EditMonUpgradeColor6.Value := g_Config.SlaveColor[5];
  EditMonUpgradeColor7.Value := g_Config.SlaveColor[6];
  EditMonUpgradeColor8.Value := g_Config.SlaveColor[7];
  EditMonUpgradeColor9.Value := g_Config.SlaveColor[8];
  EditMonUpgradeKillCount1.Value := g_Config.MonUpLvNeedKillCount[0];
  EditMonUpgradeKillCount2.Value := g_Config.MonUpLvNeedKillCount[1];
  EditMonUpgradeKillCount3.Value := g_Config.MonUpLvNeedKillCount[2];
  EditMonUpgradeKillCount4.Value := g_Config.MonUpLvNeedKillCount[3];
  EditMonUpgradeKillCount5.Value := g_Config.MonUpLvNeedKillCount[4];
  EditMonUpgradeKillCount6.Value := g_Config.MonUpLvNeedKillCount[5];
  EditMonUpgradeKillCount7.Value := g_Config.MonUpLvNeedKillCount[6];
  EditMonUpLvNeedKillBase.Value := g_Config.nMonUpLvNeedKillBase;
  EditMonUpLvRate.Value := g_Config.nMonUpLvRate;

  CheckBoxMasterDieMutiny.Checked := g_Config.boMasterDieMutiny;
  EditMasterDieMutinyRate.Value := g_Config.nMasterDieMutinyRate;
  EditMasterDieMutinyPower.Value := g_Config.nMasterDieMutinyPower;
  EditMasterDieMutinySpeed.Value := g_Config.nMasterDieMutinySpeed;

  CheckBoxMasterDieMutinyClick(CheckBoxMasterDieMutiny);

  CheckBoxBBMonAutoChangeColor.Checked := g_Config.boBBMonAutoChangeColor;
  EditBBMonAutoChangeColorTime.Value := g_Config.dwBBMonAutoChangeColorTime div
    1000;
end;

procedure TfrmFunctionConfig.ButtonMonUpgradeSaveClick(Sender: TObject);
{$IF SoftVersion <> VERDEMO}
var
  i: Integer;
{$IFEND}
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup', 'MonUpLvNeedKillBase',
    g_Config.nMonUpLvNeedKillBase);
  Config.WriteInteger('Setup', 'MonUpLvRate', g_Config.nMonUpLvRate);
  for i := Low(g_Config.MonUpLvNeedKillCount) to
    High(g_Config.MonUpLvNeedKillCount) do begin
    Config.WriteInteger('Setup', 'MonUpLvNeedKillCount' + IntToStr(i),
      g_Config.MonUpLvNeedKillCount[i]);
  end;

  for i := Low(g_Config.SlaveColor) to High(g_Config.SlaveColor) do begin
    Config.WriteInteger('Setup', 'SlaveColor' + IntToStr(i),
      g_Config.SlaveColor[i]);
  end;
  Config.WriteBool('Setup', 'MasterDieMutiny', g_Config.boMasterDieMutiny);
  Config.WriteInteger('Setup', 'MasterDieMutinyRate',
    g_Config.nMasterDieMutinyRate);
  Config.WriteInteger('Setup', 'MasterDieMutinyPower',
    g_Config.nMasterDieMutinyPower);
  Config.WriteInteger('Setup', 'MasterDieMutinyPower',
    g_Config.nMasterDieMutinySpeed);

  Config.WriteBool('Setup', 'BBMonAutoChangeColor',
    g_Config.boBBMonAutoChangeColor);
  Config.WriteInteger('Setup', 'BBMonAutoChangeColorTime',
    g_Config.dwBBMonAutoChangeColorTime);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.ButtonNakedSaveClick(Sender: TObject);
begin
  Config.WriteInteger('Setup', 'NakedBeginLevel', g_Config.wNakedBeginLevel);
  Config.WriteInteger('Setup', 'NakedLevelUpAddCount', g_Config.NakedAddInfo.nNakedLevelUpAddCount);
  Config.WriteInteger('Setup', 'NakedAcCount', g_Config.NakedAddInfo.nNakedAcCount);
  Config.WriteInteger('Setup', 'NakedAcMaxCount', g_Config.NakedAddInfo.nNakedAcMaxCount);
  Config.WriteInteger('Setup', 'NakedMAcCount', g_Config.NakedAddInfo.nNakedMAcCount);
  Config.WriteInteger('Setup', 'NakedMAcMaxCount', g_Config.NakedAddInfo.nNakedMAcMaxCount);
  Config.WriteInteger('Setup', 'NakedDcCount', g_Config.NakedAddInfo.nNakedDcCount);
  Config.WriteInteger('Setup', 'NakedDcMaxCount', g_Config.NakedAddInfo.nNakedDcMaxCount);
  Config.WriteInteger('Setup', 'NakedMcCount', g_Config.NakedAddInfo.nNakedMcCount);
  Config.WriteInteger('Setup', 'NakedMcMaxCount', g_Config.NakedAddInfo.nNakedMcMaxCount);
  Config.WriteInteger('Setup', 'NakedScCount', g_Config.NakedAddInfo.nNakedScCount);
  Config.WriteInteger('Setup', 'NakedScMaxCount', g_Config.NakedAddInfo.nNakedScMaxCount);
  Config.WriteInteger('Setup', 'NakedHPCount', g_Config.NakedAddInfo.nNakedHPCount);
  uModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor1Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditMonUpgradeColor1.Value;
  LabelMonUpgradeColor1.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[0] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor2Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditMonUpgradeColor2.Value;
  LabelMonUpgradeColor2.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[1] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor3Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditMonUpgradeColor3.Value;
  LabelMonUpgradeColor3.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[2] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor4Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditMonUpgradeColor4.Value;
  LabelMonUpgradeColor4.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[3] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor5Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditMonUpgradeColor5.Value;
  LabelMonUpgradeColor5.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[4] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor6Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditMonUpgradeColor6.Value;
  LabelMonUpgradeColor6.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[5] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor7Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditMonUpgradeColor7.Value;
  LabelMonUpgradeColor7.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[6] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor8Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditMonUpgradeColor8.Value;
  LabelMonUpgradeColor8.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[7] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeColor9Change(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditMonUpgradeColor9.Value;
  LabelMonUpgradeColor9.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.SlaveColor[8] := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxReNewChangeColorClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boReNewChangeColor := CheckBoxReNewChangeColor.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxReNewLevelClearExpClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boReNewLevelClearExp := CheckBoxReNewLevelClearExp.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditPKFlagNameColorChange(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditPKFlagNameColor.Value;
  LabelPKFlagNameColor.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.btPKFlagNameColor := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditPKLevel1NameColorChange(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditPKLevel1NameColor.Value;
  LabelPKLevel1NameColor.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.btPKLevel1NameColor := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditPKLevel2NameColorChange(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditPKLevel2NameColor.Value;
  LabelPKLevel2NameColor.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.btPKLevel2NameColor := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditProtectShieldDelDamage0Change(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nProtectShieldDelDamage0 := EditProtectShieldDelDamage0.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.EditProtectShieldDelDamage1Change(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nProtectShieldDelDamage1 := EditProtectShieldDelDamage1.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.EditProtectShieldDelDamage2Change(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nProtectShieldDelDamage2 := EditProtectShieldDelDamage2.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.EditProtectShieldDelDamage3Change(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nProtectShieldDelDamage3 := EditProtectShieldDelDamage3.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.EditProtectShieldRunRate0Change(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nProtectShieldRunRate0 := EditProtectShieldRunRate0.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.EditProtectShieldRunRate1Change(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nProtectShieldRunRate1 := EditProtectShieldRunRate1.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.EditProtectShieldRunRate2Change(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nProtectShieldRunRate2 := EditProtectShieldRunRate2.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.EditProtectShieldRunRate3Change(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nProtectShieldRunRate3 := EditProtectShieldRunRate3.Value;
  ModValue()
end;

procedure TfrmFunctionConfig.EditPullulationChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.nPullulationCount := EditPullulation.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.Edit32HorseGetExpRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.n32HorseGetExpRate := Edit32HorseGetExpRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.Edit33HorseGetExpRate2Change(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.n33HorseGetExpRate2 := Edit33HorseGetExpRate2.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.Edit33HorseGetExpRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.n33HorseGetExpRate := Edit33HorseGetExpRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditAllyAndGuildNameColorChange(
  Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditAllyAndGuildNameColor.Value;
  LabelAllyAndGuildNameColor.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.btAllyAndGuildNameColor := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditWarGuildNameColorChange(Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditWarGuildNameColor.Value;
  LabelWarGuildNameColor.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.btWarGuildNameColor := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditInFreePKAreaNameColorChange(
  Sender: TObject);
var
  btColor: Byte;
begin
  btColor := EditInFreePKAreaNameColor.Value;
  LabelInFreePKAreaNameColor.Color := GetRGB(btColor);
  if not boOpened then
    Exit;
  g_Config.btInFreePKAreaNameColor := btColor;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount1Change(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.MonUpLvNeedKillCount[0] := EditMonUpgradeKillCount1.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount2Change(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.MonUpLvNeedKillCount[1] := EditMonUpgradeKillCount2.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount3Change(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.MonUpLvNeedKillCount[2] := EditMonUpgradeKillCount3.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount4Change(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.MonUpLvNeedKillCount[3] := EditMonUpgradeKillCount4.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount5Change(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.MonUpLvNeedKillCount[4] := EditMonUpgradeKillCount5.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount6Change(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.MonUpLvNeedKillCount[5] := EditMonUpgradeKillCount6.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpgradeKillCount7Change(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.MonUpLvNeedKillCount[6] := EditMonUpgradeKillCount7.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpLvNeedKillBaseChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMonUpLvNeedKillBase := EditMonUpLvNeedKillBase.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMonUpLvRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMonUpLvRate := EditMonUpLvRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMoonSpiritCountChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nMoonSpiritCount := EditMoonSpiritCount.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditNakedAc2PointChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.NakedAddInfo.nNakedAcCount := EditNakedAc2Point.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditNakedAcPointChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.NakedAddInfo.nNakedAcMaxCount := EditNakedAcPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditNakedAddPointChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.NakedAddInfo.nNakedLevelUpAddCount := EditNakedAddPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditNakedBeginLevelChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.wNakedBeginLevel := EditNakedBeginLevel.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditNakedDc2PointChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.NakedAddInfo.nNakedDcCount := EditNakedDc2Point.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditNakedDcPointChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.NakedAddInfo.nNakedDcMaxCount := EditNakedDcPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditNakedHPPointChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.NakedAddInfo.nNakedHPCount := EditNakedHPPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditNakedMac2PointChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.NakedAddInfo.nNakedMAcCount := EditNakedMAc2Point.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditNakedMacPointChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.NakedAddInfo.nNakedMAcMaxCount := EditNakedMAcPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditNakedMC2PointChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.NakedAddInfo.nNakedMcCount := EditNakedMc2Point.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditNakedMCPointChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.NakedAddInfo.nNakedMcMaxCount := EditNakedMcPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditNakedSC2PointChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.NakedAddInfo.nNakedScCount := EditNakedSc2Point.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditNakedSCPointChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.NakedAddInfo.nNakedScMaxCount := EditNakedScPoint.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxMasterDieMutinyClick(Sender: TObject);
begin
  if CheckBoxMasterDieMutiny.Checked then begin
    EditMasterDieMutinyRate.Enabled := True;
    EditMasterDieMutinyPower.Enabled := True;
    EditMasterDieMutinySpeed.Enabled := True;
  end
  else begin
    EditMasterDieMutinyRate.Enabled := False;
    EditMasterDieMutinyPower.Enabled := False;
    EditMasterDieMutinySpeed.Enabled := False;
  end;
  if not boOpened then
    Exit;
  g_Config.boMasterDieMutiny := CheckBoxMasterDieMutiny.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMasterDieMutinyRateChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMasterDieMutinyRate := EditMasterDieMutinyRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMasterDieMutinyPowerChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMasterDieMutinyPower := EditMasterDieMutinyPower.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMasterDieMutinySpeedChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMasterDieMutinySpeed := EditMasterDieMutinySpeed.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxWarLongWideClick(Sender: TObject);
begin
  if not boOpened then Exit;
  SetIntStatus(g_Config.nSetupInfo, M2SETUP_SHOWWARLONGWIDE, CheckBoxWarLongWide.Checked);
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxNotShiftKeyClick(Sender: TObject);
begin
  if not boOpened then Exit;
  SetIntStatus(g_Config.nSetupInfo, M2SETUP_NOTSHIFTKEY, CheckBoxNotShiftKey.Checked);
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxAllow32HorseGetExpClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boAllow32HorseGetExp := CheckBoxAllow32HorseGetExp.Checked;
  Edit32HorseGetExpRate.Enabled := g_Config.boAllow32HorseGetExp;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxAllow33HorseGetExpClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boAllow33HorseGetExp := CheckBoxAllow33HorseGetExp.Checked;
  Edit33HorseGetExpRate.Enabled := g_Config.boAllow33HorseGetExp;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxBBMonAutoChangeColorClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boBBMonAutoChangeColor := CheckBoxBBMonAutoChangeColor.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxCancelDropItemHintClick(Sender: TObject);
begin
  if not boOpened then Exit;
  SetIntStatus(g_Config.nSetupInfo, M2SETUP_CANCELDROPITEMHINT, CheckBoxCancelDropItemHint.Checked);
  ModValue();
end;

procedure TfrmFunctionConfig.EditBBMonAutoChangeColorTimeChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.dwBBMonAutoChangeColorTime := EditBBMonAutoChangeColorTime.Value *
    1000;
  ModValue();
end;

procedure TfrmFunctionConfig.RefSpiritMutiny();
begin
  CheckBoxSpiritMutiny.Checked := g_Config.boSpiritMutiny;
  EditSpiritMutinyTime.Value := g_Config.dwSpiritMutinyTime div (60 * 1000);
  EditSpiritPowerRate.Value := g_Config.nSpiritPowerRate;
  CheckBoxSpiritMutinyClick(CheckBoxSpiritMutiny);
end;

procedure TfrmFunctionConfig.ButtonSpiritMutinySaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteBool('Setup', 'SpiritMutiny', g_Config.boSpiritMutiny);
  Config.WriteInteger('Setup', 'SpiritMutinyTime', g_Config.dwSpiritMutinyTime);
  Config.WriteInteger('Setup', 'SpiritPowerRate', g_Config.nSpiritPowerRate);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.CheckBoxShowCBOFormClick(Sender: TObject);
begin
  if not boOpened then Exit;
  SetIntStatus(g_Config.nSetupInfo, M2SETUP_SHOWCBOFORM, CheckBoxShowCBOForm.Checked);
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxShowMakeMagicFormClick(Sender: TObject);
begin
  if not boOpened then Exit;
  SetIntStatus(g_Config.nSetupInfo, M2SETUP_SHOWMAKEMAGICFORM, CheckBoxShowMakeMagicForm.Checked);
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxShowStrengthenInfoClick(Sender: TObject);
begin
  if not boOpened then Exit;
  SetIntStatus(g_Config.nSetupInfo, M2SETUP_SHOWSTRENGTHENINFO, CheckBoxShowStrengthenInfo.Checked);
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill63RunGuardClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill63RunGuard := CheckBoxSkill63RunGuard.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill63RunHumClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill63RunHum := CheckBoxSkill63RunHum.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill63RunMonClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill63RunMon := CheckBoxSkill63RunMon.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill63RunNpcClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill63RunNpc := CheckBoxSkill63RunNpc.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill63WarDisHumRunClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill63WarDisHumRun := CheckBoxSkill63WarDisHumRun.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill66ReduceMPClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill66ReduceMP := CheckBoxSkill66ReduceMP.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill70MbAttackHumanClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill70MbAttackHuman := CheckBoxSkill70MbAttackHuman.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill70MbAttackMonClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill70MbAttackMon := CheckBoxSkill70MbAttackMon.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill70MbAttackSlaveClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill70MbAttackSlave := CheckBoxSkill70MbAttackSlave.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill70MbFastParalysisClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill70MbFastParalysis := CheckBoxSkill70MbFastParalysis.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill70RunGuardClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill70RunGuard := CheckBoxSkill70RunGuard.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill70RunHumClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill70RunHum := CheckBoxSkill70RunHum.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill70RunMonClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill70RunMon := CheckBoxSkill70RunMon.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill70RunNpcClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill70RunNpc := CheckBoxSkill70RunNpc.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill70WarDisHumRunClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill70WarDisHumRun := CheckBoxSkill70WarDisHumRun.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill71MbAttackHumanClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill71MbAttackHuman := CheckBoxSkill71MbAttackHuman.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill71MbAttackMonClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill71MbAttackMon := CheckBoxSkill71MbAttackMon.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill71MbAttackSlaveClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill71MbAttackSlave := CheckBoxSkill71MbAttackSlave.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill71MbFastParalysisClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill71MbFastParalysis := CheckBoxSkill71MbFastParalysis.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill72DamagearmorClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill72Damagearmor := CheckBoxSkill72Damagearmor.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill72DecHealthClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill72DecHealth := CheckBoxSkill72DecHealth.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill72MbAttackHumanClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill72MbAttackHuman := CheckBoxSkill72MbAttackHuman.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill72MbAttackMonClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill72MbAttackMon := CheckBoxSkill72MbAttackMon.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill72MbAttackSlaveClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill72MbAttackSlave := CheckBoxSkill72MbAttackSlave.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSkill72MbFastParalysisClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boSkill72MbFastParalysis := CheckBoxSkill72MbFastParalysis.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxSpiritMutinyClick(Sender: TObject);
begin
  if CheckBoxSpiritMutiny.Checked then begin
    EditSpiritMutinyTime.Enabled := True;
    //    EditSpiritPowerRate.Enabled:=True;
  end
  else begin
    EditSpiritMutinyTime.Enabled := False;
    EditSpiritPowerRate.Enabled := False;
  end;
  if not boOpened then
    Exit;
  g_Config.boSpiritMutiny := CheckBoxSpiritMutiny.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.EditSpiritMutinyTimeChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.dwSpiritMutinyTime := EditSpiritMutinyTime.Value * 60 * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.EditSpiritPowerRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nSpiritPowerRate := EditSpiritPowerRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMagTammingLevelChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMagTammingLevel := EditMagTammingLevel.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMagTammingTargetLevelChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMagTammingTargetLevel := EditMagTammingTargetLevel.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMagTammingHPRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMagTammingHPRate := EditMagTammingHPRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditTakeOnHorseUseTimeChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nTakeOnHorseUseTime := EditTakeOnHorseUseTime.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditTammingCountChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMagTammingCount := EditTammingCount.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMabMabeHitRandRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMabMabeHitRandRate := EditMabMabeHitRandRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMabMabeHitMinLvLimitChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMabMabeHitMinLvLimit := EditMabMabeHitMinLvLimit.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMabMabeHitSucessRateChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMabMabeHitSucessRate := EditMabMabeHitSucessRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.EditMabMabeHitMabeTimeRateChange(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nMabMabeHitMabeTimeRate := EditMabMabeHitMabeTimeRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.RefMonSayMsg;
begin
  chkMonSayMsg.Checked := g_Config.boMonSayMsg;
end;

procedure TfrmFunctionConfig.chkMonSayMsgClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boMonSayMsg := chkMonSayMsg.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.RefWeaponMakeLuck;
begin
  ScrollBarWeaponMakeUnLuckRate.Min := 1;
  ScrollBarWeaponMakeUnLuckRate.Max := 50;
  ScrollBarWeaponMakeUnLuckRate.Position := g_Config.nWeaponMakeUnLuckRate;

  ScrollBarWeaponMakeLuckPoint1.Min := 1;
  ScrollBarWeaponMakeLuckPoint1.Max := 10;
  ScrollBarWeaponMakeLuckPoint1.Position := g_Config.nWeaponMakeLuckPoint1;

  ScrollBarWeaponMakeLuckPoint2.Min := 1;
  ScrollBarWeaponMakeLuckPoint2.Max := 10;
  ScrollBarWeaponMakeLuckPoint2.Position := g_Config.nWeaponMakeLuckPoint2;

  ScrollBarWeaponMakeLuckPoint3.Min := 1;
  ScrollBarWeaponMakeLuckPoint3.Max := 10;
  ScrollBarWeaponMakeLuckPoint3.Position := g_Config.nWeaponMakeLuckPoint3;

  ScrollBarWeaponMakeLuckPoint2Rate.Min := 1;
  ScrollBarWeaponMakeLuckPoint2Rate.Max := 50;
  ScrollBarWeaponMakeLuckPoint2Rate.Position :=
    g_Config.nWeaponMakeLuckPoint2Rate;

  ScrollBarWeaponMakeLuckPoint3Rate.Min := 1;
  ScrollBarWeaponMakeLuckPoint3Rate.Max := 50;
  ScrollBarWeaponMakeLuckPoint3Rate.Position := g_Config.nWeaponMakeLuckPoint3Rate;
  EditUnLuckMaxCount.Value := g_Config.nWeaponMakeUnLuckMaxCount;
end;

procedure TfrmFunctionConfig.ButtonWeaponMakeLuckDefaultClick(
  Sender: TObject);
begin
  if Application.MessageBox('是否确认恢复默认设置？', '确认信息',
    MB_YESNO +
    MB_ICONQUESTION) <> IDYES then begin
    Exit;
  end;
  g_Config.nWeaponMakeUnLuckRate := 20;
  g_Config.nWeaponMakeLuckPoint1 := 1;
  g_Config.nWeaponMakeLuckPoint2 := 3;
  g_Config.nWeaponMakeLuckPoint3 := 7;
  g_Config.nWeaponMakeLuckPoint2Rate := 6;
  g_Config.nWeaponMakeLuckPoint3Rate := 40;
  RefWeaponMakeLuck();
end;

procedure TfrmFunctionConfig.ButtonWeaponMakeLuckSaveClick(
  Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup', 'WeaponMakeUnLuckRate', g_Config.nWeaponMakeUnLuckRate);
  Config.WriteInteger('Setup', 'WeaponMakeLuckPoint1', g_Config.nWeaponMakeLuckPoint1);
  Config.WriteInteger('Setup', 'WeaponMakeLuckPoint2', g_Config.nWeaponMakeLuckPoint2);
  Config.WriteInteger('Setup', 'WeaponMakeLuckPoint3', g_Config.nWeaponMakeLuckPoint3);
  Config.WriteInteger('Setup', 'WeaponMakeLuckPoint2Rate', g_Config.nWeaponMakeLuckPoint2Rate);
  Config.WriteInteger('Setup', 'WeaponMakeLuckPoint3Rate', g_Config.nWeaponMakeLuckPoint3Rate);
  Config.WriteInteger('Setup', 'WeaponMakeUnLuckMaxCount', g_Config.nWeaponMakeUnLuckMaxCount);
{$IFEND}
  uModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWeaponMakeUnLuckRateChange(
  Sender: TObject);
var
  nInteger: Integer;
begin
  nInteger := ScrollBarWeaponMakeUnLuckRate.Position;
  EditWeaponMakeUnLuckRate.Text := IntToStr(nInteger);
  if not boOpened then
    Exit;
  g_Config.nWeaponMakeUnLuckRate := nInteger;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWeaponMakeLuckPoint1Change(
  Sender: TObject);
var
  nInteger: Integer;
begin
  nInteger := ScrollBarWeaponMakeLuckPoint1.Position;
  EditWeaponMakeLuckPoint1.Text := IntToStr(nInteger);
  if not boOpened then
    Exit;
  g_Config.nWeaponMakeLuckPoint1 := nInteger;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWeaponMakeLuckPoint2Change(
  Sender: TObject);
var
  nInteger: Integer;
begin
  nInteger := ScrollBarWeaponMakeLuckPoint2.Position;
  EditWeaponMakeLuckPoint2.Text := IntToStr(nInteger);
  if not boOpened then
    Exit;
  g_Config.nWeaponMakeLuckPoint2 := nInteger;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWeaponMakeLuckPoint2RateChange(
  Sender: TObject);
var
  nInteger: Integer;
begin
  nInteger := ScrollBarWeaponMakeLuckPoint2Rate.Position;
  EditWeaponMakeLuckPoint2Rate.Text := IntToStr(nInteger);
  if not boOpened then
    Exit;
  g_Config.nWeaponMakeLuckPoint2Rate := nInteger;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWeaponMakeLuckPoint3Change(
  Sender: TObject);
var
  nInteger: Integer;
begin
  nInteger := ScrollBarWeaponMakeLuckPoint3.Position;
  EditWeaponMakeLuckPoint3.Text := IntToStr(nInteger);
  if not boOpened then
    Exit;
  g_Config.nWeaponMakeLuckPoint3 := nInteger;
  ModValue();
end;

procedure TfrmFunctionConfig.ScrollBarWeaponMakeLuckPoint3RateChange(
  Sender: TObject);
var
  nInteger: Integer;
begin
  nInteger := ScrollBarWeaponMakeLuckPoint3Rate.Position;
  EditWeaponMakeLuckPoint3Rate.Text := IntToStr(nInteger);
  if not boOpened then
    Exit;
  g_Config.nWeaponMakeLuckPoint3Rate := nInteger;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxPullPlayObjectClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boPullPlayObject := CheckBoxPullPlayObject.Checked;
  CheckBoxPullCrossInSafeZone.Enabled := CheckBoxPullPlayObject.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxPlayObjectReduceMPClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boPlayObjectReduceMP := CheckBoxPlayObjectReduceMP.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxGroupMbAttackSlaveClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boGroupMbAttackSlave := CheckBoxGroupMbAttackSlave.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditSkill39SecChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nDedingUseTime := SpinEditSkill39Sec.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxDedingAllowPKClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boDedingAllowPK := CheckBoxDedingAllowPK.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxDomesticationCheckLevelClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boDomesticationCheckLevel := CheckBoxDomesticationCheckLevel.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxDomesticationUseWeaponClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boDomesticationUseWeapon := CheckBoxDomesticationUseWeapon.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxExpIsCumulativeClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boExpIsCumulative := CheckBoxExpIsCumulative.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxExpOffLienSaveClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boExpOffLienSave := CheckBoxExpOffLienSave.Checked;
  CheckBoxExpOffLineRunTime.Enabled := g_Config.boExpOffLienSave;
  if not g_Config.boExpOffLienSave then begin
    CheckBoxExpOffLineRunTime.Checked := False;
    g_Config.boExpOffLineRunTime := False;
  end;
  ModValue();
end;

procedure TfrmFunctionConfig.CheckBoxExpOffLineRunTimeClick(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.boExpOffLineRunTime := CheckBoxExpOffLineRunTime.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditDidingPowerRateChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nDidingPowerRate := SpinEditDidingPowerRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditFireDelayTimeChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nFireDelayTimeRate := SpinEditFireDelayTime.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditFireDelayTimeClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nFireDelayTimeRate := SpinEditFireDelayTime.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditFirePowerChange(Sender: TObject);
begin
  if not boOpened then Exit;
  g_Config.nFirePowerRate := SpinEditFirePower.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditFirePowerClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.nFirePowerRate := SpinEditFirePower.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditHPStoneAddRateChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.HPStoneAddRate := SpinEditHPStoneAddRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditHPStoneDecDuraChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.HPStoneDecDura := SpinEditHPStoneDecDura.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditHPStoneIntervalTimeChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.HPStoneIntervalTime := SpinEditHPStoneIntervalTime.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditHPStoneStartRateChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.HPStoneStartRate := SpinEditHPStoneStartRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditMPStoneAddRateChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.MPStoneAddRate := SpinEditMPStoneAddRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditMPStoneDecDuraChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.MPStoneDecDura := SpinEditMPStoneDecDura.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditMPStoneIntervalTimeChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.MPStoneIntervalTime := SpinEditMPStoneIntervalTime.Value * 1000;
  ModValue();
end;

procedure TfrmFunctionConfig.SpinEditMPStoneStartRateChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.MPStoneStartRate := SpinEditMPStoneStartRate.Value;
  ModValue();
end;

procedure TfrmFunctionConfig.RefCopyHumConf;
begin

end;

procedure TfrmFunctionConfig.CheckBoxPullCrossInSafeZoneClick(
  Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boPullCrossInSafeZone := CheckBoxPullCrossInSafeZone.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.chkStartDropItemMapEventClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boStartDropItemMapEvent := chkStartDropItemMapEvent.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.chkStartHeavyHitMapEventClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boStartHeavyHitMapEvent := chkStartHeavyHitMapEvent.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.chkStartPickUpItemMapEventClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boStartPickUpItemMapEvent := chkStartPickUpItemMapEvent.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.chkStartRunMapEventClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boStartRunMapEvent := chkStartRunMapEvent.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.chkStartWalkMapEventClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boStartWalkMapEvent := chkStartWalkMapEvent.Checked;
  ModValue();
end;

procedure TfrmFunctionConfig.ComboBoxMakeMagicTypeChange(Sender: TObject);
var
  i, k: Integer;
begin
  if ComboBoxMakeMagicType.ItemIndex in [Low(g_Config.MakeMagicConfine)..High(g_Config.MakeMagicConfine)] then begin
    k := ComboBoxMakeMagicType.ItemIndex;
    for I := Low(g_Config.MakeMagicConfine[k]) to High(g_Config.MakeMagicConfine[k]) do begin
      if (g_Config.MakeMagicConfine[k][I].nMagicLevel > 0) or (g_Config.MakeMagicConfine[k][I].nHumLevel > 0) then begin
        GridMakeMagic.Cells[0, i + 1] := IntToStr(g_Config.MakeMagicConfine[k][I].nMagicLevel);
        GridMakeMagic.Cells[1, i + 1] := IntToStr(g_Config.MakeMagicConfine[k][I].nHumLevel);
      end else begin
        GridMakeMagic.Cells[0, i + 1] := '';
        GridMakeMagic.Cells[1, i + 1] := '';
      end;
    end;
  end;
end;

procedure TfrmFunctionConfig.chkCheckGuildClick(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.boCheckGuild := chkCheckGuild.Checked;
  ModValue();
end;

end.

