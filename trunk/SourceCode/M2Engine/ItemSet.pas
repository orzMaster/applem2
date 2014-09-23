unit ItemSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Spin;

type
  TfrmItemSet = class(TForm)
    PageControl: TPageControl;
    TabSheet8: TTabSheet;
    ItemSetPageControl: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox141: TGroupBox;
    Label108: TLabel;
    Label109: TLabel;
    EditItemExpRate: TSpinEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    TabSheet2: TTabSheet;
    GroupBox142: TGroupBox;
    Label110: TLabel;
    Label3: TLabel;
    EditItemPowerRate: TSpinEdit;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    ButtonItemSetSave: TButton;
    TabSheet9: TTabSheet;
    AddValuePageControl: TPageControl;
    TabSheet10: TTabSheet;
    TabSheet11: TTabSheet;
    TabSheet12: TTabSheet;
    TabSheet13: TTabSheet;
    TabSheet15: TTabSheet;
    TabSheet16: TTabSheet;
    ButtonAddValueSave: TButton;
    TabSheet18: TTabSheet;
    GroupBox3: TGroupBox;
    Label6: TLabel;
    EditMonRandomAddValue: TSpinEdit;
    Label7: TLabel;
    EditMakeRandomAddValue: TSpinEdit;
    GroupBox4: TGroupBox;
    Label8: TLabel;
    EditWeaponDCAddValueMaxLimit: TSpinEdit;
    EditWeaponDCAddValueRate: TSpinEdit;
    Label9: TLabel;
    GroupBox5: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    EditWeaponMCAddValueMaxLimit: TSpinEdit;
    EditWeaponMCAddValueRate: TSpinEdit;
    GroupBox6: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    EditWeaponSCAddValueMaxLimit: TSpinEdit;
    EditWeaponSCAddValueRate: TSpinEdit;
    GroupBox28: TGroupBox;
    Label85: TLabel;
    Label86: TLabel;
    EditGuildRecallTime: TSpinEdit;
    GroupBox29: TGroupBox;
    Label87: TLabel;
    Label88: TLabel;
    GroupBox44: TGroupBox;
    GroupBox45: TGroupBox;
    Label122: TLabel;
    Label123: TLabel;
    GroupBox42: TGroupBox;
    EditAttackPosionRate: TSpinEdit;
    Label120: TLabel;
    Label116: TLabel;
    EditAttackPosionTime: TSpinEdit;
    GroupBox43: TGroupBox;
    GroupBox46: TGroupBox;
    Label117: TLabel;
    Label118: TLabel;
    GroupBox47: TGroupBox;
    CheckBoxUserMoveCanDupObj: TCheckBox;
    CheckBoxUserMoveCanOnItem: TCheckBox;
    Label119: TLabel;
    EditUserMoveTime: TSpinEdit;
    Label121: TLabel;
    Label124: TLabel;
    EditNpcMakeRandomAddValue: TSpinEdit;
    Label125: TLabel;
    GroupBox48: TGroupBox;
    Label126: TLabel;
    Label127: TLabel;
    EditWeaponACAddValueMaxLimit: TSpinEdit;
    EditWeaponACAddValueRate: TSpinEdit;
    GroupBox52: TGroupBox;
    Label128: TLabel;
    Label129: TLabel;
    EditWeaponMACAddValueMaxLimit: TSpinEdit;
    EditWeaponMACAddValueRate: TSpinEdit;
    EditWeaponACAddRate: TSpinEdit;
    Label32: TLabel;
    EditWeaponDCAddRate: TSpinEdit;
    Label130: TLabel;
    EditWeaponMCAddRate: TSpinEdit;
    Label131: TLabel;
    EditWeaponMACAddRate: TSpinEdit;
    Label132: TLabel;
    EditWeaponSCAddRate: TSpinEdit;
    Label133: TLabel;
    GroupBox53: TGroupBox;
    Label134: TLabel;
    Label135: TLabel;
    Label136: TLabel;
    EditWeaponCCAddValueMaxLimit: TSpinEdit;
    EditWeaponCCAddValueRate: TSpinEdit;
    EditWeaponCCAddRate: TSpinEdit;
    TabSheet3: TTabSheet;
    TabSheet7: TTabSheet;
    GroupBox7: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    EditHelmetACAddValueMaxLimit: TSpinEdit;
    EditHelmetACAddValueRate: TSpinEdit;
    EditHelmetACAddRate: TSpinEdit;
    GroupBox8: TGroupBox;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    EditHelmetMACAddValueMaxLimit: TSpinEdit;
    EditHelmetMACAddValueRate: TSpinEdit;
    EditHelmetMACAddRate: TSpinEdit;
    GroupBox9: TGroupBox;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    EditHelmetCCAddValueMaxLimit: TSpinEdit;
    EditHelmetCCAddValueRate: TSpinEdit;
    EditHelmetCCAddRate: TSpinEdit;
    GroupBox10: TGroupBox;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    EditHelmetDCAddValueMaxLimit: TSpinEdit;
    EditHelmetDCAddValueRate: TSpinEdit;
    EditHelmetDCAddRate: TSpinEdit;
    GroupBox11: TGroupBox;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    EditHelmetMCAddValueMaxLimit: TSpinEdit;
    EditHelmetMCAddValueRate: TSpinEdit;
    EditHelmetMCAddRate: TSpinEdit;
    GroupBox12: TGroupBox;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    EditHelmetSCAddValueMaxLimit: TSpinEdit;
    EditHelmetSCAddValueRate: TSpinEdit;
    EditHelmetSCAddRate: TSpinEdit;
    GroupBox13: TGroupBox;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    EditDressACAddValueMaxLimit: TSpinEdit;
    EditDressACAddValueRate: TSpinEdit;
    EditDressACAddRate: TSpinEdit;
    GroupBox14: TGroupBox;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    EditDressMACAddValueMaxLimit: TSpinEdit;
    EditDressMACAddValueRate: TSpinEdit;
    EditDressMACAddRate: TSpinEdit;
    GroupBox15: TGroupBox;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    EditDressCCAddValueMaxLimit: TSpinEdit;
    EditDressCCAddValueRate: TSpinEdit;
    EditDressCCAddRate: TSpinEdit;
    GroupBox16: TGroupBox;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    EditDressDCAddValueMaxLimit: TSpinEdit;
    EditDressDCAddValueRate: TSpinEdit;
    EditDressDCAddRate: TSpinEdit;
    GroupBox17: TGroupBox;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    EditDressMCAddValueMaxLimit: TSpinEdit;
    EditDressMCAddValueRate: TSpinEdit;
    EditDressMCAddRate: TSpinEdit;
    GroupBox18: TGroupBox;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    EditDressSCAddValueMaxLimit: TSpinEdit;
    EditDressSCAddValueRate: TSpinEdit;
    EditDressSCAddRate: TSpinEdit;
    GroupBox19: TGroupBox;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    EditNecklaceACAddValueMaxLimit: TSpinEdit;
    EditNecklaceACAddValueRate: TSpinEdit;
    EditNecklaceACAddRate: TSpinEdit;
    GroupBox20: TGroupBox;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    EditNecklaceMACAddValueMaxLimit: TSpinEdit;
    EditNecklaceMACAddValueRate: TSpinEdit;
    EditNecklaceMACAddRate: TSpinEdit;
    GroupBox21: TGroupBox;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    EditNecklaceCCAddValueMaxLimit: TSpinEdit;
    EditNecklaceCCAddValueRate: TSpinEdit;
    EditNecklaceCCAddRate: TSpinEdit;
    GroupBox22: TGroupBox;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    EditNecklaceDCAddValueMaxLimit: TSpinEdit;
    EditNecklaceDCAddValueRate: TSpinEdit;
    EditNecklaceDCAddRate: TSpinEdit;
    GroupBox23: TGroupBox;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    EditNecklaceMCAddValueMaxLimit: TSpinEdit;
    EditNecklaceMCAddValueRate: TSpinEdit;
    EditNecklaceMCAddRate: TSpinEdit;
    GroupBox24: TGroupBox;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    EditNecklaceSCAddValueMaxLimit: TSpinEdit;
    EditNecklaceSCAddValueRate: TSpinEdit;
    EditNecklaceSCAddRate: TSpinEdit;
    GroupBox25: TGroupBox;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    EditArmRingACAddValueMaxLimit: TSpinEdit;
    EditArmRingACAddValueRate: TSpinEdit;
    EditArmRingACAddRate: TSpinEdit;
    GroupBox26: TGroupBox;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    EditArmRingMACAddValueMaxLimit: TSpinEdit;
    EditArmRingMACAddValueRate: TSpinEdit;
    EditArmRingMACAddRate: TSpinEdit;
    GroupBox27: TGroupBox;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    EditArmRingCCAddValueMaxLimit: TSpinEdit;
    EditArmRingCCAddValueRate: TSpinEdit;
    EditArmRingCCAddRate: TSpinEdit;
    GroupBox30: TGroupBox;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    EditArmRingDCAddValueMaxLimit: TSpinEdit;
    EditArmRingDCAddValueRate: TSpinEdit;
    EditArmRingDCAddRate: TSpinEdit;
    GroupBox31: TGroupBox;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    EditArmRingMCAddValueMaxLimit: TSpinEdit;
    EditArmRingMCAddValueRate: TSpinEdit;
    EditArmRingMCAddRate: TSpinEdit;
    GroupBox32: TGroupBox;
    Label84: TLabel;
    Label89: TLabel;
    Label90: TLabel;
    EditArmRingSCAddValueMaxLimit: TSpinEdit;
    EditArmRingSCAddValueRate: TSpinEdit;
    EditArmRingSCAddRate: TSpinEdit;
    GroupBox33: TGroupBox;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    EditRingACAddValueMaxLimit: TSpinEdit;
    EditRingACAddValueRate: TSpinEdit;
    EditRingACAddRate: TSpinEdit;
    GroupBox34: TGroupBox;
    Label94: TLabel;
    Label95: TLabel;
    Label96: TLabel;
    EditRingMACAddValueMaxLimit: TSpinEdit;
    EditRingMACAddValueRate: TSpinEdit;
    EditRingMACAddRate: TSpinEdit;
    GroupBox35: TGroupBox;
    Label97: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    EditRingCCAddValueMaxLimit: TSpinEdit;
    EditRingCCAddValueRate: TSpinEdit;
    EditRingCCAddRate: TSpinEdit;
    GroupBox36: TGroupBox;
    Label100: TLabel;
    Label101: TLabel;
    Label102: TLabel;
    EditRingDCAddValueMaxLimit: TSpinEdit;
    EditRingDCAddValueRate: TSpinEdit;
    EditRingDCAddRate: TSpinEdit;
    GroupBox37: TGroupBox;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    EditRingMCAddValueMaxLimit: TSpinEdit;
    EditRingMCAddValueRate: TSpinEdit;
    EditRingMCAddRate: TSpinEdit;
    GroupBox38: TGroupBox;
    Label106: TLabel;
    Label107: TLabel;
    Label111: TLabel;
    EditRingSCAddValueMaxLimit: TSpinEdit;
    EditRingSCAddValueRate: TSpinEdit;
    EditRingSCAddRate: TSpinEdit;
    GroupBox39: TGroupBox;
    Label112: TLabel;
    Label113: TLabel;
    Label114: TLabel;
    EditBeltACAddValueMaxLimit: TSpinEdit;
    EditBeltACAddValueRate: TSpinEdit;
    EditBeltACAddRate: TSpinEdit;
    GroupBox40: TGroupBox;
    Label115: TLabel;
    Label137: TLabel;
    Label138: TLabel;
    EditBeltMACAddValueMaxLimit: TSpinEdit;
    EditBeltMACAddValueRate: TSpinEdit;
    EditBeltMACAddRate: TSpinEdit;
    GroupBox41: TGroupBox;
    Label139: TLabel;
    Label140: TLabel;
    Label141: TLabel;
    EditBeltCCAddValueMaxLimit: TSpinEdit;
    EditBeltCCAddValueRate: TSpinEdit;
    EditBeltCCAddRate: TSpinEdit;
    GroupBox49: TGroupBox;
    Label142: TLabel;
    Label143: TLabel;
    Label144: TLabel;
    EditBeltDCAddValueMaxLimit: TSpinEdit;
    EditBeltDCAddValueRate: TSpinEdit;
    EditBeltDCAddRate: TSpinEdit;
    GroupBox50: TGroupBox;
    Label145: TLabel;
    Label146: TLabel;
    Label147: TLabel;
    EditBeltMCAddValueMaxLimit: TSpinEdit;
    EditBeltMCAddValueRate: TSpinEdit;
    EditBeltMCAddRate: TSpinEdit;
    GroupBox51: TGroupBox;
    Label148: TLabel;
    Label149: TLabel;
    Label150: TLabel;
    EditBeltSCAddValueMaxLimit: TSpinEdit;
    EditBeltSCAddValueRate: TSpinEdit;
    EditBeltSCAddRate: TSpinEdit;
    GroupBox54: TGroupBox;
    Label151: TLabel;
    Label152: TLabel;
    Label153: TLabel;
    EditBootACAddValueMaxLimit: TSpinEdit;
    EditBootACAddValueRate: TSpinEdit;
    EditBootACAddRate: TSpinEdit;
    GroupBox55: TGroupBox;
    Label154: TLabel;
    Label155: TLabel;
    Label156: TLabel;
    EditBootMACAddValueMaxLimit: TSpinEdit;
    EditBootMACAddValueRate: TSpinEdit;
    EditBootMACAddRate: TSpinEdit;
    GroupBox56: TGroupBox;
    Label157: TLabel;
    Label158: TLabel;
    Label159: TLabel;
    EditBootCCAddValueMaxLimit: TSpinEdit;
    EditBootCCAddValueRate: TSpinEdit;
    EditBootCCAddRate: TSpinEdit;
    GroupBox57: TGroupBox;
    Label160: TLabel;
    Label161: TLabel;
    Label162: TLabel;
    EditBootDCAddValueMaxLimit: TSpinEdit;
    EditBootDCAddValueRate: TSpinEdit;
    EditBootDCAddRate: TSpinEdit;
    GroupBox58: TGroupBox;
    Label163: TLabel;
    Label164: TLabel;
    Label165: TLabel;
    EditBootMCAddValueMaxLimit: TSpinEdit;
    EditBootMCAddValueRate: TSpinEdit;
    EditBootMCAddRate: TSpinEdit;
    GroupBox59: TGroupBox;
    Label166: TLabel;
    Label167: TLabel;
    Label168: TLabel;
    EditBootSCAddValueMaxLimit: TSpinEdit;
    EditBootSCAddValueRate: TSpinEdit;
    EditBootSCAddRate: TSpinEdit;
    GroupBox60: TGroupBox;
    Label169: TLabel;
    Label170: TLabel;
    Label171: TLabel;
    EditFlute1Rate: TSpinEdit;
    EditFlute2Rate: TSpinEdit;
    EditFlute3Rate: TSpinEdit;
    GroupBox61: TGroupBox;
    Label172: TLabel;
    Label173: TLabel;
    EditWuXinMinRate: TSpinEdit;
    EditWuXinMaxRate: TSpinEdit;
    CheckBoxMonRandom: TCheckBox;
    CheckBoxMakeRandom: TCheckBox;
    CheckBoxNpcMakeRandom: TCheckBox;
    TabSheet14: TTabSheet;
    TabSheet17: TTabSheet;
    TabSheet19: TTabSheet;
    TabSheet20: TTabSheet;
    TabSheet21: TTabSheet;
    GroupBox62: TGroupBox;
    Label174: TLabel;
    Label175: TLabel;
    Label176: TLabel;
    EditBellACAddValueMaxLimit: TSpinEdit;
    EditBellACAddValueRate: TSpinEdit;
    EditBellACAddRate: TSpinEdit;
    GroupBox63: TGroupBox;
    Label177: TLabel;
    Label178: TLabel;
    Label179: TLabel;
    EditBellMACAddValueMaxLimit: TSpinEdit;
    EditBellMACAddValueRate: TSpinEdit;
    EditBellMACAddRate: TSpinEdit;
    GroupBox64: TGroupBox;
    Label180: TLabel;
    Label181: TLabel;
    Label182: TLabel;
    EditBellDCAddValueMaxLimit: TSpinEdit;
    EditBellDCAddValueRate: TSpinEdit;
    EditBellDCAddRate: TSpinEdit;
    GroupBox65: TGroupBox;
    Label183: TLabel;
    Label184: TLabel;
    Label185: TLabel;
    EditBellCCAddValueMaxLimit: TSpinEdit;
    EditBellCCAddValueRate: TSpinEdit;
    EditBellCCAddRate: TSpinEdit;
    GroupBox66: TGroupBox;
    Label186: TLabel;
    Label187: TLabel;
    Label188: TLabel;
    EditSaddleACAddValueMaxLimit: TSpinEdit;
    EditSaddleACAddValueRate: TSpinEdit;
    EditSaddleACAddRate: TSpinEdit;
    GroupBox67: TGroupBox;
    Label189: TLabel;
    Label190: TLabel;
    Label191: TLabel;
    EditSaddleMACAddValueMaxLimit: TSpinEdit;
    EditSaddleMACAddValueRate: TSpinEdit;
    EditSaddleMACAddRate: TSpinEdit;
    GroupBox68: TGroupBox;
    Label192: TLabel;
    Label193: TLabel;
    Label194: TLabel;
    EditSaddleDCAddValueMaxLimit: TSpinEdit;
    EditSaddleDCAddValueRate: TSpinEdit;
    EditSaddleDCAddRate: TSpinEdit;
    GroupBox69: TGroupBox;
    Label195: TLabel;
    Label196: TLabel;
    Label197: TLabel;
    EditSaddleCCAddValueMaxLimit: TSpinEdit;
    EditSaddleCCAddValueRate: TSpinEdit;
    EditSaddleCCAddRate: TSpinEdit;
    GroupBox70: TGroupBox;
    Label198: TLabel;
    Label199: TLabel;
    Label200: TLabel;
    EditDecorationACAddValueMaxLimit: TSpinEdit;
    EditDecorationACAddValueRate: TSpinEdit;
    EditDecorationACAddRate: TSpinEdit;
    GroupBox71: TGroupBox;
    Label201: TLabel;
    Label202: TLabel;
    Label203: TLabel;
    EditDecorationMACAddValueMaxLimit: TSpinEdit;
    EditDecorationMACAddValueRate: TSpinEdit;
    EditDecorationMACAddRate: TSpinEdit;
    GroupBox72: TGroupBox;
    Label204: TLabel;
    Label205: TLabel;
    Label206: TLabel;
    EditDecorationDCAddValueMaxLimit: TSpinEdit;
    EditDecorationDCAddValueRate: TSpinEdit;
    EditDecorationDCAddRate: TSpinEdit;
    GroupBox73: TGroupBox;
    Label207: TLabel;
    Label208: TLabel;
    Label209: TLabel;
    EditDecorationCCAddValueMaxLimit: TSpinEdit;
    EditDecorationCCAddValueRate: TSpinEdit;
    EditDecorationCCAddRate: TSpinEdit;
    GroupBox74: TGroupBox;
    Label210: TLabel;
    Label211: TLabel;
    Label212: TLabel;
    EditNailACAddValueMaxLimit: TSpinEdit;
    EditNailACAddValueRate: TSpinEdit;
    EditNailACAddRate: TSpinEdit;
    GroupBox75: TGroupBox;
    Label213: TLabel;
    Label214: TLabel;
    Label215: TLabel;
    EditNailMACAddValueMaxLimit: TSpinEdit;
    EditNailMACAddValueRate: TSpinEdit;
    EditNailMACAddRate: TSpinEdit;
    GroupBox76: TGroupBox;
    Label216: TLabel;
    Label217: TLabel;
    Label218: TLabel;
    EditNailDCAddValueMaxLimit: TSpinEdit;
    EditNailDCAddValueRate: TSpinEdit;
    EditNailDCAddRate: TSpinEdit;
    GroupBox77: TGroupBox;
    Label219: TLabel;
    Label220: TLabel;
    Label221: TLabel;
    EditNailCCAddValueMaxLimit: TSpinEdit;
    EditNailCCAddValueRate: TSpinEdit;
    EditNailCCAddRate: TSpinEdit;
    GroupBox78: TGroupBox;
    Label222: TLabel;
    Label223: TLabel;
    Label224: TLabel;
    EditReinACAddValueMaxLimit: TSpinEdit;
    EditReinACAddValueRate: TSpinEdit;
    EditReinACAddRate: TSpinEdit;
    GroupBox79: TGroupBox;
    Label225: TLabel;
    Label226: TLabel;
    Label227: TLabel;
    EditReinMACAddValueMaxLimit: TSpinEdit;
    EditReinMACAddValueRate: TSpinEdit;
    EditReinMACAddRate: TSpinEdit;
    GroupBox80: TGroupBox;
    Label228: TLabel;
    Label229: TLabel;
    Label230: TLabel;
    EditReinDCAddValueMaxLimit: TSpinEdit;
    EditReinDCAddValueRate: TSpinEdit;
    EditReinDCAddRate: TSpinEdit;
    GroupBox81: TGroupBox;
    Label231: TLabel;
    Label232: TLabel;
    Label233: TLabel;
    EditReinCCAddValueMaxLimit: TSpinEdit;
    EditReinCCAddValueRate: TSpinEdit;
    EditReinCCAddRate: TSpinEdit;
    TabSheet22: TTabSheet;
    GroupBox82: TGroupBox;
    CheckBoxOpenArmStrengthen: TCheckBox;
    CheckBoxOpenItemFlute: TCheckBox;
    GroupBox83: TGroupBox;
    Label234: TLabel;
    EditAbilityMoveBaseRate: TSpinEdit;
    Label235: TLabel;
    EditAbilityMoveGold: TSpinEdit;
    procedure EditItemExpRateChange(Sender: TObject);
    procedure EditItemPowerRateChange(Sender: TObject);
    procedure ButtonItemSetSaveClick(Sender: TObject);
    procedure ButtonAddValueSaveClick(Sender: TObject);
    procedure EditMonRandomAddValueChange(Sender: TObject);
    procedure EditMakeRandomAddValueChange(Sender: TObject);
    procedure EditGuildRecallTimeChange(Sender: TObject);
    procedure EditAttackPosionRateChange(Sender: TObject);
    procedure EditAttackPosionTimeChange(Sender: TObject);
    procedure CheckBoxUserMoveCanDupObjClick(Sender: TObject);
    procedure CheckBoxUserMoveCanOnItemClick(Sender: TObject);
    procedure EditUserMoveTimeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditNpcMakeRandomAddValueChange(Sender: TObject);
    procedure EditWeaponACAddValueMaxLimitChange(Sender: TObject);
    procedure EditHelmetACAddValueMaxLimitChange(Sender: TObject);
    procedure EditDressACAddValueMaxLimitChange(Sender: TObject);
    procedure EditArmRingACAddValueMaxLimitChange(Sender: TObject);
    procedure EditRingACAddValueMaxLimitChange(Sender: TObject);
    procedure EditBeltACAddValueMaxLimitChange(Sender: TObject);
    procedure EditNecklaceACAddValueMaxLimitChange(Sender: TObject);
    procedure EditBootACAddValueMaxLimitChange(Sender: TObject);
    procedure EditFlute1RateChange(Sender: TObject);
    procedure EditFlute2RateChange(Sender: TObject);
    procedure EditFlute3RateChange(Sender: TObject);
    procedure EditWuXinMaxRateChange(Sender: TObject);
    procedure EditWuXinMinRateChange(Sender: TObject);
    procedure CheckBoxMonRandomClick(Sender: TObject);
    procedure CheckBoxMakeRandomClick(Sender: TObject);
    procedure CheckBoxNpcMakeRandomClick(Sender: TObject);
    procedure EditReinACAddValueMaxLimitChange(Sender: TObject);
    procedure EditBellACAddValueMaxLimitChange(Sender: TObject);
    procedure EditSaddleACAddValueMaxLimitChange(Sender: TObject);
    procedure EditDecorationACAddValueMaxLimitChange(Sender: TObject);
    procedure EditNailACAddValueMaxLimitChange(Sender: TObject);
    procedure CheckBoxOpenArmStrengthenClick(Sender: TObject);
    procedure CheckBoxOpenItemFluteClick(Sender: TObject);
    procedure EditAbilityMoveBaseRateChange(Sender: TObject);
    procedure EditAbilityMoveGoldChange(Sender: TObject);
  private
    boOpened: Boolean;
    boModValued: Boolean;
    procedure ModValue();
    procedure uModValue();
    procedure RefUnknowItem();
    procedure RefShapeItem();
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

var
  frmItemSet: TfrmItemSet;

implementation

uses M2Share;

{$R *.dfm}

{ TfrmItemSet }

procedure TfrmItemSet.ModValue;
begin
  boModValued := True;
  ButtonItemSetSave.Enabled := True;
  ButtonAddValueSave.Enabled := True;
end;

procedure TfrmItemSet.uModValue;
begin
  boModValued := False;
  ButtonItemSetSave.Enabled := False;
  ButtonAddValueSave.Enabled := False;
end;

procedure TfrmItemSet.Open;
begin
  boOpened := False;
  uModValue();

  EditItemExpRate.Value := g_Config.nItemExpRate;
  EditItemPowerRate.Value := g_Config.nItemPowerRate;

  EditMonRandomAddValue.Value := g_Config.nMonRandomAddValue;
  EditMakeRandomAddValue.Value := g_Config.nMakeRandomAddValue;
  EditNpcMakeRandomAddValue.Value := g_Config.nNpcMakeRandomAddValue;

  CheckBoxMonRandom.Checked := g_Config.boMonRandomIsOpenShow;
  CheckBoxMakeRandom.Checked := g_Config.boMakeRandomIsOpenShow;
  CheckBoxNPCMakeRandom.Checked := g_Config.boNPCMakeRandomIsOpenShow;

  EditFlute1Rate.Value := g_Config.nFlute1RateValue;
  EditFlute2Rate.Value := g_Config.nFlute2RateValue;
  EditFlute3Rate.Value := g_Config.nFlute3RateValue;
  EditWuXinMinRate.Value := g_Config.nWuXinMinRate;
  EditWuXinMaxRate.Value := g_Config.nWuXinMaxRate;

  EditHelmetACAddValueMaxLimit.Value := g_Config.IHelmet.nACMaxLimit;
  EditHelmetACAddValueRate.Value := g_Config.IHelmet.nACAddValueRate;
  EditHelmetACAddRate.Value := g_Config.IHelmet.nACAddRate;
  EditHelmetMACAddValueMaxLimit.Value := g_Config.IHelmet.nMACMaxLimit;
  EditHelmetMACAddValueRate.Value := g_Config.IHelmet.nMACAddValueRate;
  EditHelmetMACAddRate.Value := g_Config.IHelmet.nMACAddRate;
  EditHelmetDCAddValueMaxLimit.Value := g_Config.IHelmet.nDCMaxLimit;
  EditHelmetDCAddValueRate.Value := g_Config.IHelmet.nDCAddValueRate;
  EditHelmetDCAddRate.Value := g_Config.IHelmet.nDCAddRate;
  EditHelmetMCAddValueMaxLimit.Value := g_Config.IHelmet.nMCMaxLimit;
  EditHelmetMCAddValueRate.Value := g_Config.IHelmet.nMCAddValueRate;
  EditHelmetMCAddRate.Value := g_Config.IHelmet.nMCAddRate;
  EditHelmetSCAddValueMaxLimit.Value := g_Config.IHelmet.nSCMaxLimit;
  EditHelmetSCAddValueRate.Value := g_Config.IHelmet.nSCAddValueRate;
  EditHelmetSCAddRate.Value := g_Config.IHelmet.nSCAddRate;
  EditHelmetCCAddValueMaxLimit.Value := g_Config.IHelmet.nCCMaxLimit;
  EditHelmetCCAddValueRate.Value := g_Config.IHelmet.nCCAddValueRate;
  EditHelmetCCAddRate.Value := g_Config.IHelmet.nCCAddRate;

  EditWeaponACAddValueMaxLimit.Value := g_Config.IWeapon.nACMaxLimit;
  EditWeaponACAddValueRate.Value := g_Config.IWeapon.nACAddValueRate;
  EditWeaponACAddRate.Value := g_Config.IWeapon.nACAddRate;
  EditWeaponMACAddValueMaxLimit.Value := g_Config.IWeapon.nMACMaxLimit;
  EditWeaponMACAddValueRate.Value := g_Config.IWeapon.nMACAddValueRate;
  EditWeaponMACAddRate.Value := g_Config.IWeapon.nMACAddRate;
  EditWeaponDCAddValueMaxLimit.Value := g_Config.IWeapon.nDCMaxLimit;
  EditWeaponDCAddValueRate.Value := g_Config.IWeapon.nDCAddValueRate;
  EditWeaponDCAddRate.Value := g_Config.IWeapon.nDCAddRate;
  EditWeaponMCAddValueMaxLimit.Value := g_Config.IWeapon.nMCMaxLimit;
  EditWeaponMCAddValueRate.Value := g_Config.IWeapon.nMCAddValueRate;
  EditWeaponMCAddRate.Value := g_Config.IWeapon.nMCAddRate;
  EditWeaponSCAddValueMaxLimit.Value := g_Config.IWeapon.nSCMaxLimit;
  EditWeaponSCAddValueRate.Value := g_Config.IWeapon.nSCAddValueRate;
  EditWeaponSCAddRate.Value := g_Config.IWeapon.nSCAddRate;
  EditWeaponCCAddValueMaxLimit.Value := g_Config.IWeapon.nCCMaxLimit;
  EditWeaponCCAddValueRate.Value := g_Config.IWeapon.nCCAddValueRate;
  EditWeaponCCAddRate.Value := g_Config.IWeapon.nCCAddRate;

  EditDressACAddValueMaxLimit.Value := g_Config.IDress.nACMaxLimit;
  EditDressACAddValueRate.Value := g_Config.IDress.nACAddValueRate;
  EditDressACAddRate.Value := g_Config.IDress.nACAddRate;
  EditDressMACAddValueMaxLimit.Value := g_Config.IDress.nMACMaxLimit;
  EditDressMACAddValueRate.Value := g_Config.IDress.nMACAddValueRate;
  EditDressMACAddRate.Value := g_Config.IDress.nMACAddRate;
  EditDressDCAddValueMaxLimit.Value := g_Config.IDress.nDCMaxLimit;
  EditDressDCAddValueRate.Value := g_Config.IDress.nDCAddValueRate;
  EditDressDCAddRate.Value := g_Config.IDress.nDCAddRate;
  EditDressMCAddValueMaxLimit.Value := g_Config.IDress.nMCMaxLimit;
  EditDressMCAddValueRate.Value := g_Config.IDress.nMCAddValueRate;
  EditDressMCAddRate.Value := g_Config.IDress.nMCAddRate;
  EditDressSCAddValueMaxLimit.Value := g_Config.IDress.nSCMaxLimit;
  EditDressSCAddValueRate.Value := g_Config.IDress.nSCAddValueRate;
  EditDressSCAddRate.Value := g_Config.IDress.nSCAddRate;
  EditDressCCAddValueMaxLimit.Value := g_Config.IDress.nCCMaxLimit;
  EditDressCCAddValueRate.Value := g_Config.IDress.nCCAddValueRate;
  EditDressCCAddRate.Value := g_Config.IDress.nCCAddRate;

  EditNecklaceACAddValueMaxLimit.Value := g_Config.INecklace.nACMaxLimit;
  EditNecklaceACAddValueRate.Value := g_Config.INecklace.nACAddValueRate;
  EditNecklaceACAddRate.Value := g_Config.INecklace.nACAddRate;
  EditNecklaceMACAddValueMaxLimit.Value := g_Config.INecklace.nMACMaxLimit;
  EditNecklaceMACAddValueRate.Value := g_Config.INecklace.nMACAddValueRate;
  EditNecklaceMACAddRate.Value := g_Config.INecklace.nMACAddRate;
  EditNecklaceDCAddValueMaxLimit.Value := g_Config.INecklace.nDCMaxLimit;
  EditNecklaceDCAddValueRate.Value := g_Config.INecklace.nDCAddValueRate;
  EditNecklaceDCAddRate.Value := g_Config.INecklace.nDCAddRate;
  EditNecklaceMCAddValueMaxLimit.Value := g_Config.INecklace.nMCMaxLimit;
  EditNecklaceMCAddValueRate.Value := g_Config.INecklace.nMCAddValueRate;
  EditNecklaceMCAddRate.Value := g_Config.INecklace.nMCAddRate;
  EditNecklaceSCAddValueMaxLimit.Value := g_Config.INecklace.nSCMaxLimit;
  EditNecklaceSCAddValueRate.Value := g_Config.INecklace.nSCAddValueRate;
  EditNecklaceSCAddRate.Value := g_Config.INecklace.nSCAddRate;
  EditNecklaceCCAddValueMaxLimit.Value := g_Config.INecklace.nCCMaxLimit;
  EditNecklaceCCAddValueRate.Value := g_Config.INecklace.nCCAddValueRate;
  EditNecklaceCCAddRate.Value := g_Config.INecklace.nCCAddRate;

  EditRingACAddValueMaxLimit.Value := g_Config.IRing.nACMaxLimit;
  EditRingACAddValueRate.Value := g_Config.IRing.nACAddValueRate;
  EditRingACAddRate.Value := g_Config.IRing.nACAddRate;
  EditRingMACAddValueMaxLimit.Value := g_Config.IRing.nMACMaxLimit;
  EditRingMACAddValueRate.Value := g_Config.IRing.nMACAddValueRate;
  EditRingMACAddRate.Value := g_Config.IRing.nMACAddRate;
  EditRingDCAddValueMaxLimit.Value := g_Config.IRing.nDCMaxLimit;
  EditRingDCAddValueRate.Value := g_Config.IRing.nDCAddValueRate;
  EditRingDCAddRate.Value := g_Config.IRing.nDCAddRate;
  EditRingMCAddValueMaxLimit.Value := g_Config.IRing.nMCMaxLimit;
  EditRingMCAddValueRate.Value := g_Config.IRing.nMCAddValueRate;
  EditRingMCAddRate.Value := g_Config.IRing.nMCAddRate;
  EditRingSCAddValueMaxLimit.Value := g_Config.IRing.nSCMaxLimit;
  EditRingSCAddValueRate.Value := g_Config.IRing.nSCAddValueRate;
  EditRingSCAddRate.Value := g_Config.IRing.nSCAddRate;
  EditRingCCAddValueMaxLimit.Value := g_Config.IRing.nCCMaxLimit;
  EditRingCCAddValueRate.Value := g_Config.IRing.nCCAddValueRate;
  EditRingCCAddRate.Value := g_Config.IRing.nCCAddRate;

  EditArmRingACAddValueMaxLimit.Value := g_Config.IArmRing.nACMaxLimit;
  EditArmRingACAddValueRate.Value := g_Config.IArmRing.nACAddValueRate;
  EditArmRingACAddRate.Value := g_Config.IArmRing.nACAddRate;
  EditArmRingMACAddValueMaxLimit.Value := g_Config.IArmRing.nMACMaxLimit;
  EditArmRingMACAddValueRate.Value := g_Config.IArmRing.nMACAddValueRate;
  EditArmRingMACAddRate.Value := g_Config.IArmRing.nMACAddRate;
  EditArmRingDCAddValueMaxLimit.Value := g_Config.IArmRing.nDCMaxLimit;
  EditArmRingDCAddValueRate.Value := g_Config.IArmRing.nDCAddValueRate;
  EditArmRingDCAddRate.Value := g_Config.IArmRing.nDCAddRate;
  EditArmRingMCAddValueMaxLimit.Value := g_Config.IArmRing.nMCMaxLimit;
  EditArmRingMCAddValueRate.Value := g_Config.IArmRing.nMCAddValueRate;
  EditArmRingMCAddRate.Value := g_Config.IArmRing.nMCAddRate;
  EditArmRingSCAddValueMaxLimit.Value := g_Config.IArmRing.nSCMaxLimit;
  EditArmRingSCAddValueRate.Value := g_Config.IArmRing.nSCAddValueRate;
  EditArmRingSCAddRate.Value := g_Config.IArmRing.nSCAddRate;
  EditArmRingCCAddValueMaxLimit.Value := g_Config.IArmRing.nCCMaxLimit;
  EditArmRingCCAddValueRate.Value := g_Config.IArmRing.nCCAddValueRate;
  EditArmRingCCAddRate.Value := g_Config.IArmRing.nCCAddRate;

  EditBeltACAddValueMaxLimit.Value := g_Config.IBelt.nACMaxLimit;
  EditBeltACAddValueRate.Value := g_Config.IBelt.nACAddValueRate;
  EditBeltACAddRate.Value := g_Config.IBelt.nACAddRate;
  EditBeltMACAddValueMaxLimit.Value := g_Config.IBelt.nMACMaxLimit;
  EditBeltMACAddValueRate.Value := g_Config.IBelt.nMACAddValueRate;
  EditBeltMACAddRate.Value := g_Config.IBelt.nMACAddRate;
  EditBeltDCAddValueMaxLimit.Value := g_Config.IBelt.nDCMaxLimit;
  EditBeltDCAddValueRate.Value := g_Config.IBelt.nDCAddValueRate;
  EditBeltDCAddRate.Value := g_Config.IBelt.nDCAddRate;
  EditBeltMCAddValueMaxLimit.Value := g_Config.IBelt.nMCMaxLimit;
  EditBeltMCAddValueRate.Value := g_Config.IBelt.nMCAddValueRate;
  EditBeltMCAddRate.Value := g_Config.IBelt.nMCAddRate;
  EditBeltSCAddValueMaxLimit.Value := g_Config.IBelt.nSCMaxLimit;
  EditBeltSCAddValueRate.Value := g_Config.IBelt.nSCAddValueRate;
  EditBeltSCAddRate.Value := g_Config.IBelt.nSCAddRate;
  EditBeltCCAddValueMaxLimit.Value := g_Config.IBelt.nCCMaxLimit;
  EditBeltCCAddValueRate.Value := g_Config.IBelt.nCCAddValueRate;
  EditBeltCCAddRate.Value := g_Config.IBelt.nCCAddRate;

  EditBootACAddValueMaxLimit.Value := g_Config.IBoot.nACMaxLimit;
  EditBootACAddValueRate.Value := g_Config.IBoot.nACAddValueRate;
  EditBootACAddRate.Value := g_Config.IBoot.nACAddRate;
  EditBootMACAddValueMaxLimit.Value := g_Config.IBoot.nMACMaxLimit;
  EditBootMACAddValueRate.Value := g_Config.IBoot.nMACAddValueRate;
  EditBootMACAddRate.Value := g_Config.IBoot.nMACAddRate;
  EditBootDCAddValueMaxLimit.Value := g_Config.IBoot.nDCMaxLimit;
  EditBootDCAddValueRate.Value := g_Config.IBoot.nDCAddValueRate;
  EditBootDCAddRate.Value := g_Config.IBoot.nDCAddRate;
  EditBootMCAddValueMaxLimit.Value := g_Config.IBoot.nMCMaxLimit;
  EditBootMCAddValueRate.Value := g_Config.IBoot.nMCAddValueRate;
  EditBootMCAddRate.Value := g_Config.IBoot.nMCAddRate;
  EditBootSCAddValueMaxLimit.Value := g_Config.IBoot.nSCMaxLimit;
  EditBootSCAddValueRate.Value := g_Config.IBoot.nSCAddValueRate;
  EditBootSCAddRate.Value := g_Config.IBoot.nSCAddRate;
  EditBootCCAddValueMaxLimit.Value := g_Config.IBoot.nCCMaxLimit;
  EditBootCCAddValueRate.Value := g_Config.IBoot.nCCAddValueRate;
  EditBootCCAddRate.Value := g_Config.IBoot.nCCAddRate;

  EditReinACAddValueMaxLimit.Value := g_Config.IRein.nACMaxLimit;
  EditReinACAddValueRate.Value := g_Config.IRein.nACAddValueRate;
  EditReinACAddRate.Value := g_Config.IRein.nACAddRate;
  EditReinMACAddValueMaxLimit.Value := g_Config.IRein.nMACMaxLimit;
  EditReinMACAddValueRate.Value := g_Config.IRein.nMACAddValueRate;
  EditReinMACAddRate.Value := g_Config.IRein.nMACAddRate;
  EditReinDCAddValueMaxLimit.Value := g_Config.IRein.nDCMaxLimit;
  EditReinDCAddValueRate.Value := g_Config.IRein.nDCAddValueRate;
  EditReinDCAddRate.Value := g_Config.IRein.nDCAddRate;
  EditReinCCAddValueMaxLimit.Value := g_Config.IRein.nCCMaxLimit;
  EditReinCCAddValueRate.Value := g_Config.IRein.nCCAddValueRate;
  EditReinCCAddRate.Value := g_Config.IRein.nCCAddRate;

  EditBellACAddValueMaxLimit.Value := g_Config.IBell.nACMaxLimit;
  EditBellACAddValueRate.Value := g_Config.IBell.nACAddValueRate;
  EditBellACAddRate.Value := g_Config.IBell.nACAddRate;
  EditBellMACAddValueMaxLimit.Value := g_Config.IBell.nMACMaxLimit;
  EditBellMACAddValueRate.Value := g_Config.IBell.nMACAddValueRate;
  EditBellMACAddRate.Value := g_Config.IBell.nMACAddRate;
  EditBellDCAddValueMaxLimit.Value := g_Config.IBell.nDCMaxLimit;
  EditBellDCAddValueRate.Value := g_Config.IBell.nDCAddValueRate;
  EditBellDCAddRate.Value := g_Config.IBell.nDCAddRate;
  EditBellCCAddValueMaxLimit.Value := g_Config.IBell.nCCMaxLimit;
  EditBellCCAddValueRate.Value := g_Config.IBell.nCCAddValueRate;
  EditBellCCAddRate.Value := g_Config.IBell.nCCAddRate;

  EditSaddleACAddValueMaxLimit.Value := g_Config.ISaddle.nACMaxLimit;
  EditSaddleACAddValueRate.Value := g_Config.ISaddle.nACAddValueRate;
  EditSaddleACAddRate.Value := g_Config.ISaddle.nACAddRate;
  EditSaddleMACAddValueMaxLimit.Value := g_Config.ISaddle.nMACMaxLimit;
  EditSaddleMACAddValueRate.Value := g_Config.ISaddle.nMACAddValueRate;
  EditSaddleMACAddRate.Value := g_Config.ISaddle.nMACAddRate;
  EditSaddleDCAddValueMaxLimit.Value := g_Config.ISaddle.nDCMaxLimit;
  EditSaddleDCAddValueRate.Value := g_Config.ISaddle.nDCAddValueRate;
  EditSaddleDCAddRate.Value := g_Config.ISaddle.nDCAddRate;
  EditSaddleCCAddValueMaxLimit.Value := g_Config.ISaddle.nCCMaxLimit;
  EditSaddleCCAddValueRate.Value := g_Config.ISaddle.nCCAddValueRate;
  EditSaddleCCAddRate.Value := g_Config.ISaddle.nCCAddRate;

  EditDecorationACAddValueMaxLimit.Value := g_Config.IDecoration.nACMaxLimit;
  EditDecorationACAddValueRate.Value := g_Config.IDecoration.nACAddValueRate;
  EditDecorationACAddRate.Value := g_Config.IDecoration.nACAddRate;
  EditDecorationMACAddValueMaxLimit.Value := g_Config.IDecoration.nMACMaxLimit;
  EditDecorationMACAddValueRate.Value := g_Config.IDecoration.nMACAddValueRate;
  EditDecorationMACAddRate.Value := g_Config.IDecoration.nMACAddRate;
  EditDecorationDCAddValueMaxLimit.Value := g_Config.IDecoration.nDCMaxLimit;
  EditDecorationDCAddValueRate.Value := g_Config.IDecoration.nDCAddValueRate;
  EditDecorationDCAddRate.Value := g_Config.IDecoration.nDCAddRate;
  EditDecorationCCAddValueMaxLimit.Value := g_Config.IDecoration.nCCMaxLimit;
  EditDecorationCCAddValueRate.Value := g_Config.IDecoration.nCCAddValueRate;
  EditDecorationCCAddRate.Value := g_Config.IDecoration.nCCAddRate;

  EditNailACAddValueMaxLimit.Value := g_Config.INail.nACMaxLimit;
  EditNailACAddValueRate.Value := g_Config.INail.nACAddValueRate;
  EditNailACAddRate.Value := g_Config.INail.nACAddRate;
  EditNailMACAddValueMaxLimit.Value := g_Config.INail.nMACMaxLimit;
  EditNailMACAddValueRate.Value := g_Config.INail.nMACAddValueRate;
  EditNailMACAddRate.Value := g_Config.INail.nMACAddRate;
  EditNailDCAddValueMaxLimit.Value := g_Config.INail.nDCMaxLimit;
  EditNailDCAddValueRate.Value := g_Config.INail.nDCAddValueRate;
  EditNailDCAddRate.Value := g_Config.INail.nDCAddRate;
  EditNailCCAddValueMaxLimit.Value := g_Config.INail.nCCMaxLimit;
  EditNailCCAddValueRate.Value := g_Config.INail.nCCAddValueRate;
  EditNailCCAddRate.Value := g_Config.INail.nCCAddRate;

  EditGuildRecallTime.Value := g_Config.nGuildRecallTime;

  CheckBoxOpenArmStrengthen.Checked := g_Config.boOpenArmStrengthen;
  CheckBoxOpenItemFlute.Checked := g_Config.boOpenItemFlute;
  EditAbilityMoveBaseRate.Value := g_Config.vAbilityMoveSet.BaseRate;
  EditAbilityMoveGold.Value := g_Config.vAbilityMoveSet.Gold;

  RefUnknowItem();
  RefShapeItem();

  boOpened := True;
  PageControl.ActivePageIndex := 0;
  AddValuePageControl.ActivePageIndex := 0;
  ItemSetPageControl.ActivePageIndex := 0;
  ShowModal;
end;

procedure TfrmItemSet.ButtonItemSetSaveClick(Sender: TObject);
begin
{$IF SoftVersion <> VERDEMO}
  Config.WriteInteger('Setup', 'ItemPowerRate', g_Config.nItemPowerRate);
  Config.WriteInteger('Setup', 'ItemExpRate', g_Config.nItemExpRate);
  Config.WriteInteger('Setup', 'GuildRecallTime', g_Config.nGuildRecallTime);
  Config.WriteInteger('Setup', 'GroupRecallTime', g_Config.nGroupRecallTime);
  Config.WriteInteger('Setup', 'GroupRecallTime', g_Config.nAttackPosionRate);
  Config.WriteInteger('Setup', 'AttackPosionRate', g_Config.nAttackPosionRate);
  Config.WriteInteger('Setup', 'AttackPosionTime', g_Config.nAttackPosionTime);
  Config.WriteBool('Setup', 'UserMoveCanDupObj', g_Config.boUserMoveCanDupObj);
  Config.WriteBool('Setup', 'UserMoveCanOnItem', g_Config.boUserMoveCanOnItem);
  Config.WriteInteger('Setup', 'UserMoveTime', g_Config.dwUserMoveTime);
  Config.WriteBool('Setup', 'OpenArmStrengthen', g_Config.boOpenArmStrengthen);
  Config.WriteBool('Setup', 'OpenItemFlute', g_Config.boOpenItemFlute);
  Config.WriteInteger('AbilityMove', 'BaseRate', g_Config.vAbilityMoveSet.BaseRate);
  Config.WriteInteger('AbilityMove', 'Gold', g_Config.vAbilityMoveSet.Gold);
{$IFEND}
  uModValue();
end;

procedure TfrmItemSet.EditItemExpRateChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.nItemExpRate := EditItemExpRate.Value;
  ModValue();
end;

procedure TfrmItemSet.EditItemPowerRateChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.nItemPowerRate := EditItemPowerRate.Value;
  ModValue();
end;

procedure TfrmItemSet.ButtonAddValueSaveClick(Sender: TObject);
begin
  Config.WriteInteger('Setup', 'MonRandomAddValue', g_Config.nMonRandomAddValue);
  Config.WriteInteger('Setup', 'MakeRandomAddValue', g_Config.nMakeRandomAddValue);
  Config.WriteInteger('Setup', 'NpcMakeRandomAddValue', g_Config.nNpcMakeRandomAddValue);
  Config.WriteInteger('Setup', 'Flute1RateValue', g_Config.nFlute1RateValue);
  Config.WriteInteger('Setup', 'Flute2RateValue', g_Config.nFlute2RateValue);
  Config.WriteInteger('Setup', 'Flute3RateValue', g_Config.nFlute3RateValue);
  Config.WriteBool('Setup', 'MonRandomIsOpenShow', g_Config.boMonRandomIsOpenShow);
  Config.WriteBool('Setup', 'MakeRandomIsOpenShow', g_Config.boMakeRandomIsOpenShow);
  Config.WriteBool('Setup', 'NPCMakeRandomIsOpenShow', g_Config.boNPCMakeRandomIsOpenShow);
  Config.WriteInteger('Setup', 'WuXinMinRateValue', g_Config.nWuXinMinRate);
  Config.WriteInteger('Setup', 'WuXinMaxRateValue', g_Config.nWuXinMaxRate);

  Config.WriteInteger('Setup', 'HelmetACMaxLimit', g_Config.IHelmet.nACMaxLimit);
  Config.WriteInteger('Setup', 'HelmetACAddValueRate', g_Config.IHelmet.nACAddValueRate);
  Config.WriteInteger('Setup', 'HelmetACAddRate', g_Config.IHelmet.nACAddRate);
  Config.WriteInteger('Setup', 'HelmetMACMaxLimit', g_Config.IHelmet.nMACMaxLimit);
  Config.WriteInteger('Setup', 'HelmetMACAddValueRate', g_Config.IHelmet.nMACAddValueRate);
  Config.WriteInteger('Setup', 'HelmetMACAddRate', g_Config.IHelmet.nMACAddRate);
  Config.WriteInteger('Setup', 'HelmetDCMaxLimit', g_Config.IHelmet.nDCMaxLimit);
  Config.WriteInteger('Setup', 'HelmetDCAddValueRate', g_Config.IHelmet.nDCAddValueRate);
  Config.WriteInteger('Setup', 'HelmetDCAddRate', g_Config.IHelmet.nDCAddRate);
  Config.WriteInteger('Setup', 'HelmetMCMaxLimit', g_Config.IHelmet.nMCMaxLimit);
  Config.WriteInteger('Setup', 'HelmetMCAddValueRate', g_Config.IHelmet.nMCAddValueRate);
  Config.WriteInteger('Setup', 'HelmetMCAddRate', g_Config.IHelmet.nMCAddRate);
  Config.WriteInteger('Setup', 'HelmetSCMaxLimit', g_Config.IHelmet.nSCMaxLimit);
  Config.WriteInteger('Setup', 'HelmetSCAddValueRate', g_Config.IHelmet.nSCAddValueRate);
  Config.WriteInteger('Setup', 'HelmetSCAddRate', g_Config.IHelmet.nSCAddRate);
  Config.WriteInteger('Setup', 'HelmetCCMaxLimit', g_Config.IHelmet.nCCMaxLimit);
  Config.WriteInteger('Setup', 'HelmetCCAddValueRate', g_Config.IHelmet.nCCAddValueRate);
  Config.WriteInteger('Setup', 'HelmetCCAddRate', g_Config.IHelmet.nCCAddRate);

  Config.WriteInteger('Setup', 'WeaponACMaxLimit', g_Config.IWeapon.nACMaxLimit);
  Config.WriteInteger('Setup', 'WeaponACAddValueRate', g_Config.IWeapon.nACAddValueRate);
  Config.WriteInteger('Setup', 'WeaponACAddRate', g_Config.IWeapon.nACAddRate);
  Config.WriteInteger('Setup', 'WeaponMACMaxLimit', g_Config.IWeapon.nMACMaxLimit);
  Config.WriteInteger('Setup', 'WeaponMACAddValueRate', g_Config.IWeapon.nMACAddValueRate);
  Config.WriteInteger('Setup', 'WeaponMACAddRate', g_Config.IWeapon.nMACAddRate);
  Config.WriteInteger('Setup', 'WeaponDCMaxLimit', g_Config.IWeapon.nDCMaxLimit);
  Config.WriteInteger('Setup', 'WeaponDCAddValueRate', g_Config.IWeapon.nDCAddValueRate);
  Config.WriteInteger('Setup', 'WeaponDCAddRate', g_Config.IWeapon.nDCAddRate);
  Config.WriteInteger('Setup', 'WeaponMCMaxLimit', g_Config.IWeapon.nMCMaxLimit);
  Config.WriteInteger('Setup', 'WeaponMCAddValueRate', g_Config.IWeapon.nMCAddValueRate);
  Config.WriteInteger('Setup', 'WeaponMCAddRate', g_Config.IWeapon.nMCAddRate);
  Config.WriteInteger('Setup', 'WeaponSCMaxLimit', g_Config.IWeapon.nSCMaxLimit);
  Config.WriteInteger('Setup', 'WeaponSCAddValueRate', g_Config.IWeapon.nSCAddValueRate);
  Config.WriteInteger('Setup', 'WeaponSCAddRate', g_Config.IWeapon.nSCAddRate);
  Config.WriteInteger('Setup', 'WeaponCCMaxLimit', g_Config.IWeapon.nCCMaxLimit);
  Config.WriteInteger('Setup', 'WeaponCCAddValueRate', g_Config.IWeapon.nCCAddValueRate);
  Config.WriteInteger('Setup', 'WeaponCCAddRate', g_Config.IWeapon.nCCAddRate);

  Config.WriteInteger('Setup', 'DressACMaxLimit', g_Config.IDress.nACMaxLimit);
  Config.WriteInteger('Setup', 'DressACAddValueRate', g_Config.IDress.nACAddValueRate);
  Config.WriteInteger('Setup', 'DressACAddRate', g_Config.IDress.nACAddRate);
  Config.WriteInteger('Setup', 'DressMACMaxLimit', g_Config.IDress.nMACMaxLimit);
  Config.WriteInteger('Setup', 'DressMACAddValueRate', g_Config.IDress.nMACAddValueRate);
  Config.WriteInteger('Setup', 'DressMACAddRate', g_Config.IDress.nMACAddRate);
  Config.WriteInteger('Setup', 'DressDCMaxLimit', g_Config.IDress.nDCMaxLimit);
  Config.WriteInteger('Setup', 'DressDCAddValueRate', g_Config.IDress.nDCAddValueRate);
  Config.WriteInteger('Setup', 'DressDCAddRate', g_Config.IDress.nDCAddRate);
  Config.WriteInteger('Setup', 'DressMCMaxLimit', g_Config.IDress.nMCMaxLimit);
  Config.WriteInteger('Setup', 'DressMCAddValueRate', g_Config.IDress.nMCAddValueRate);
  Config.WriteInteger('Setup', 'DressMCAddRate', g_Config.IDress.nMCAddRate);
  Config.WriteInteger('Setup', 'DressSCMaxLimit', g_Config.IDress.nSCMaxLimit);
  Config.WriteInteger('Setup', 'DressSCAddValueRate', g_Config.IDress.nSCAddValueRate);
  Config.WriteInteger('Setup', 'DressSCAddRate', g_Config.IDress.nSCAddRate);
  Config.WriteInteger('Setup', 'DressCCMaxLimit', g_Config.IDress.nCCMaxLimit);
  Config.WriteInteger('Setup', 'DressCCAddValueRate', g_Config.IDress.nCCAddValueRate);
  Config.WriteInteger('Setup', 'DressCCAddRate', g_Config.IDress.nCCAddRate);

  Config.WriteInteger('Setup', 'NecklaceACMaxLimit', g_Config.INecklace.nACMaxLimit);
  Config.WriteInteger('Setup', 'NecklaceACAddValueRate', g_Config.INecklace.nACAddValueRate);
  Config.WriteInteger('Setup', 'NecklaceACAddRate', g_Config.INecklace.nACAddRate);
  Config.WriteInteger('Setup', 'NecklaceMACMaxLimit', g_Config.INecklace.nMACMaxLimit);
  Config.WriteInteger('Setup', 'NecklaceMACAddValueRate', g_Config.INecklace.nMACAddValueRate);
  Config.WriteInteger('Setup', 'NecklaceMACAddRate', g_Config.INecklace.nMACAddRate);
  Config.WriteInteger('Setup', 'NecklaceDCMaxLimit', g_Config.INecklace.nDCMaxLimit);
  Config.WriteInteger('Setup', 'NecklaceDCAddValueRate', g_Config.INecklace.nDCAddValueRate);
  Config.WriteInteger('Setup', 'NecklaceDCAddRate', g_Config.INecklace.nDCAddRate);
  Config.WriteInteger('Setup', 'NecklaceMCMaxLimit', g_Config.INecklace.nMCMaxLimit);
  Config.WriteInteger('Setup', 'NecklaceMCAddValueRate', g_Config.INecklace.nMCAddValueRate);
  Config.WriteInteger('Setup', 'NecklaceMCAddRate', g_Config.INecklace.nMCAddRate);
  Config.WriteInteger('Setup', 'NecklaceSCMaxLimit', g_Config.INecklace.nSCMaxLimit);
  Config.WriteInteger('Setup', 'NecklaceSCAddValueRate', g_Config.INecklace.nSCAddValueRate);
  Config.WriteInteger('Setup', 'NecklaceSCAddRate', g_Config.INecklace.nSCAddRate);
  Config.WriteInteger('Setup', 'NecklaceCCMaxLimit', g_Config.INecklace.nCCMaxLimit);
  Config.WriteInteger('Setup', 'NecklaceCCAddValueRate', g_Config.INecklace.nCCAddValueRate);
  Config.WriteInteger('Setup', 'NecklaceCCAddRate', g_Config.INecklace.nCCAddRate);

  Config.WriteInteger('Setup', 'RingACMaxLimit', g_Config.IRing.nACMaxLimit);
  Config.WriteInteger('Setup', 'RingACAddValueRate', g_Config.IRing.nACAddValueRate);
  Config.WriteInteger('Setup', 'RingACAddRate', g_Config.IRing.nACAddRate);
  Config.WriteInteger('Setup', 'RingMACMaxLimit', g_Config.IRing.nMACMaxLimit);
  Config.WriteInteger('Setup', 'RingMACAddValueRate', g_Config.IRing.nMACAddValueRate);
  Config.WriteInteger('Setup', 'RingMACAddRate', g_Config.IRing.nMACAddRate);
  Config.WriteInteger('Setup', 'RingDCMaxLimit', g_Config.IRing.nDCMaxLimit);
  Config.WriteInteger('Setup', 'RingDCAddValueRate', g_Config.IRing.nDCAddValueRate);
  Config.WriteInteger('Setup', 'RingDCAddRate', g_Config.IRing.nDCAddRate);
  Config.WriteInteger('Setup', 'RingMCMaxLimit', g_Config.IRing.nMCMaxLimit);
  Config.WriteInteger('Setup', 'RingMCAddValueRate', g_Config.IRing.nMCAddValueRate);
  Config.WriteInteger('Setup', 'RingMCAddRate', g_Config.IRing.nMCAddRate);
  Config.WriteInteger('Setup', 'RingSCMaxLimit', g_Config.IRing.nSCMaxLimit);
  Config.WriteInteger('Setup', 'RingSCAddValueRate', g_Config.IRing.nSCAddValueRate);
  Config.WriteInteger('Setup', 'RingSCAddRate', g_Config.IRing.nSCAddRate);
  Config.WriteInteger('Setup', 'RingCCMaxLimit', g_Config.IRing.nCCMaxLimit);
  Config.WriteInteger('Setup', 'RingCCAddValueRate', g_Config.IRing.nCCAddValueRate);
  Config.WriteInteger('Setup', 'RingCCAddRate', g_Config.IRing.nCCAddRate);

  Config.WriteInteger('Setup', 'ArmRingACMaxLimit', g_Config.IArmRing.nACMaxLimit);
  Config.WriteInteger('Setup', 'ArmRingACAddValueRate', g_Config.IArmRing.nACAddValueRate);
  Config.WriteInteger('Setup', 'ArmRingACAddRate', g_Config.IArmRing.nACAddRate);
  Config.WriteInteger('Setup', 'ArmRingMACMaxLimit', g_Config.IArmRing.nMACMaxLimit);
  Config.WriteInteger('Setup', 'ArmRingMACAddValueRate', g_Config.IArmRing.nMACAddValueRate);
  Config.WriteInteger('Setup', 'ArmRingMACAddRate', g_Config.IArmRing.nMACAddRate);
  Config.WriteInteger('Setup', 'ArmRingDCMaxLimit', g_Config.IArmRing.nDCMaxLimit);
  Config.WriteInteger('Setup', 'ArmRingDCAddValueRate', g_Config.IArmRing.nDCAddValueRate);
  Config.WriteInteger('Setup', 'ArmRingDCAddRate', g_Config.IArmRing.nDCAddRate);
  Config.WriteInteger('Setup', 'ArmRingMCMaxLimit', g_Config.IArmRing.nMCMaxLimit);
  Config.WriteInteger('Setup', 'ArmRingMCAddValueRate', g_Config.IArmRing.nMCAddValueRate);
  Config.WriteInteger('Setup', 'ArmRingMCAddRate', g_Config.IArmRing.nMCAddRate);
  Config.WriteInteger('Setup', 'ArmRingSCMaxLimit', g_Config.IArmRing.nSCMaxLimit);
  Config.WriteInteger('Setup', 'ArmRingSCAddValueRate', g_Config.IArmRing.nSCAddValueRate);
  Config.WriteInteger('Setup', 'ArmRingSCAddRate', g_Config.IArmRing.nSCAddRate);
  Config.WriteInteger('Setup', 'ArmRingCCMaxLimit', g_Config.IArmRing.nCCMaxLimit);
  Config.WriteInteger('Setup', 'ArmRingCCAddValueRate', g_Config.IArmRing.nCCAddValueRate);
  Config.WriteInteger('Setup', 'ArmRingCCAddRate', g_Config.IArmRing.nCCAddRate);

  Config.WriteInteger('Setup', 'BeltACMaxLimit', g_Config.IBelt.nACMaxLimit);
  Config.WriteInteger('Setup', 'BeltACAddValueRate', g_Config.IBelt.nACAddValueRate);
  Config.WriteInteger('Setup', 'BeltACAddRate', g_Config.IBelt.nACAddRate);
  Config.WriteInteger('Setup', 'BeltMACMaxLimit', g_Config.IBelt.nMACMaxLimit);
  Config.WriteInteger('Setup', 'BeltMACAddValueRate', g_Config.IBelt.nMACAddValueRate);
  Config.WriteInteger('Setup', 'BeltMACAddRate', g_Config.IBelt.nMACAddRate);
  Config.WriteInteger('Setup', 'BeltDCMaxLimit', g_Config.IBelt.nDCMaxLimit);
  Config.WriteInteger('Setup', 'BeltDCAddValueRate', g_Config.IBelt.nDCAddValueRate);
  Config.WriteInteger('Setup', 'BeltDCAddRate', g_Config.IBelt.nDCAddRate);
  Config.WriteInteger('Setup', 'BeltMCMaxLimit', g_Config.IBelt.nMCMaxLimit);
  Config.WriteInteger('Setup', 'BeltMCAddValueRate', g_Config.IBelt.nMCAddValueRate);
  Config.WriteInteger('Setup', 'BeltMCAddRate', g_Config.IBelt.nMCAddRate);
  Config.WriteInteger('Setup', 'BeltSCMaxLimit', g_Config.IBelt.nSCMaxLimit);
  Config.WriteInteger('Setup', 'BeltSCAddValueRate', g_Config.IBelt.nSCAddValueRate);
  Config.WriteInteger('Setup', 'BeltSCAddRate', g_Config.IBelt.nSCAddRate);
  Config.WriteInteger('Setup', 'BeltCCMaxLimit', g_Config.IBelt.nCCMaxLimit);
  Config.WriteInteger('Setup', 'BeltCCAddValueRate', g_Config.IBelt.nCCAddValueRate);
  Config.WriteInteger('Setup', 'BeltCCAddRate', g_Config.IBelt.nCCAddRate);

  Config.WriteInteger('Setup', 'BootACMaxLimit', g_Config.IBoot.nACMaxLimit);
  Config.WriteInteger('Setup', 'BootACAddValueRate', g_Config.IBoot.nACAddValueRate);
  Config.WriteInteger('Setup', 'BootACAddRate', g_Config.IBoot.nACAddRate);
  Config.WriteInteger('Setup', 'BootMACMaxLimit', g_Config.IBoot.nMACMaxLimit);
  Config.WriteInteger('Setup', 'BootMACAddValueRate', g_Config.IBoot.nMACAddValueRate);
  Config.WriteInteger('Setup', 'BootMACAddRate', g_Config.IBoot.nMACAddRate);
  Config.WriteInteger('Setup', 'BootDCMaxLimit', g_Config.IBoot.nDCMaxLimit);
  Config.WriteInteger('Setup', 'BootDCAddValueRate', g_Config.IBoot.nDCAddValueRate);
  Config.WriteInteger('Setup', 'BootDCAddRate', g_Config.IBoot.nDCAddRate);
  Config.WriteInteger('Setup', 'BootMCMaxLimit', g_Config.IBoot.nMCMaxLimit);
  Config.WriteInteger('Setup', 'BootMCAddValueRate', g_Config.IBoot.nMCAddValueRate);
  Config.WriteInteger('Setup', 'BootMCAddRate', g_Config.IBoot.nMCAddRate);
  Config.WriteInteger('Setup', 'BootSCMaxLimit', g_Config.IBoot.nSCMaxLimit);
  Config.WriteInteger('Setup', 'BootSCAddValueRate', g_Config.IBoot.nSCAddValueRate);
  Config.WriteInteger('Setup', 'BootSCAddRate', g_Config.IBoot.nSCAddRate);
  Config.WriteInteger('Setup', 'BootCCMaxLimit', g_Config.IBoot.nCCMaxLimit);
  Config.WriteInteger('Setup', 'BootCCAddValueRate', g_Config.IBoot.nCCAddValueRate);
  Config.WriteInteger('Setup', 'BootCCAddRate', g_Config.IBoot.nCCAddRate);

  Config.WriteInteger('Setup', 'ReinACMaxLimit', g_Config.IRein.nACMaxLimit);
  Config.WriteInteger('Setup', 'ReinACAddValueRate', g_Config.IRein.nACAddValueRate);
  Config.WriteInteger('Setup', 'ReinACAddRate', g_Config.IRein.nACAddRate);
  Config.WriteInteger('Setup', 'ReinMACMaxLimit', g_Config.IRein.nMACMaxLimit);
  Config.WriteInteger('Setup', 'ReinMACAddValueRate', g_Config.IRein.nMACAddValueRate);
  Config.WriteInteger('Setup', 'ReinMACAddRate', g_Config.IRein.nMACAddRate);
  Config.WriteInteger('Setup', 'ReinDCMaxLimit', g_Config.IRein.nDCMaxLimit);
  Config.WriteInteger('Setup', 'ReinDCAddValueRate', g_Config.IRein.nDCAddValueRate);
  Config.WriteInteger('Setup', 'ReinDCAddRate', g_Config.IRein.nDCAddRate);
  Config.WriteInteger('Setup', 'ReinMCMaxLimit', g_Config.IRein.nMCMaxLimit);
  Config.WriteInteger('Setup', 'ReinMCAddValueRate', g_Config.IRein.nMCAddValueRate);
  Config.WriteInteger('Setup', 'ReinMCAddRate', g_Config.IRein.nMCAddRate);
  Config.WriteInteger('Setup', 'ReinSCMaxLimit', g_Config.IRein.nSCMaxLimit);
  Config.WriteInteger('Setup', 'ReinSCAddValueRate', g_Config.IRein.nSCAddValueRate);
  Config.WriteInteger('Setup', 'ReinSCAddRate', g_Config.IRein.nSCAddRate);
  Config.WriteInteger('Setup', 'ReinCCMaxLimit', g_Config.IRein.nCCMaxLimit);
  Config.WriteInteger('Setup', 'ReinCCAddValueRate', g_Config.IRein.nCCAddValueRate);
  Config.WriteInteger('Setup', 'ReinCCAddRate', g_Config.IRein.nCCAddRate);

  Config.WriteInteger('Setup', 'BellACMaxLimit', g_Config.IBell.nACMaxLimit);
  Config.WriteInteger('Setup', 'BellACAddValueRate', g_Config.IBell.nACAddValueRate);
  Config.WriteInteger('Setup', 'BellACAddRate', g_Config.IBell.nACAddRate);
  Config.WriteInteger('Setup', 'BellMACMaxLimit', g_Config.IBell.nMACMaxLimit);
  Config.WriteInteger('Setup', 'BellMACAddValueRate', g_Config.IBell.nMACAddValueRate);
  Config.WriteInteger('Setup', 'BellMACAddRate', g_Config.IBell.nMACAddRate);
  Config.WriteInteger('Setup', 'BellDCMaxLimit', g_Config.IBell.nDCMaxLimit);
  Config.WriteInteger('Setup', 'BellDCAddValueRate', g_Config.IBell.nDCAddValueRate);
  Config.WriteInteger('Setup', 'BellDCAddRate', g_Config.IBell.nDCAddRate);
  Config.WriteInteger('Setup', 'BellMCMaxLimit', g_Config.IBell.nMCMaxLimit);
  Config.WriteInteger('Setup', 'BellMCAddValueRate', g_Config.IBell.nMCAddValueRate);
  Config.WriteInteger('Setup', 'BellMCAddRate', g_Config.IBell.nMCAddRate);
  Config.WriteInteger('Setup', 'BellSCMaxLimit', g_Config.IBell.nSCMaxLimit);
  Config.WriteInteger('Setup', 'BellSCAddValueRate', g_Config.IBell.nSCAddValueRate);
  Config.WriteInteger('Setup', 'BellSCAddRate', g_Config.IBell.nSCAddRate);
  Config.WriteInteger('Setup', 'BellCCMaxLimit', g_Config.IBell.nCCMaxLimit);
  Config.WriteInteger('Setup', 'BellCCAddValueRate', g_Config.IBell.nCCAddValueRate);
  Config.WriteInteger('Setup', 'BellCCAddRate', g_Config.IBell.nCCAddRate);

  Config.WriteInteger('Setup', 'SaddleACMaxLimit', g_Config.ISaddle.nACMaxLimit);
  Config.WriteInteger('Setup', 'SaddleACAddValueRate', g_Config.ISaddle.nACAddValueRate);
  Config.WriteInteger('Setup', 'SaddleACAddRate', g_Config.ISaddle.nACAddRate);
  Config.WriteInteger('Setup', 'SaddleMACMaxLimit', g_Config.ISaddle.nMACMaxLimit);
  Config.WriteInteger('Setup', 'SaddleMACAddValueRate', g_Config.ISaddle.nMACAddValueRate);
  Config.WriteInteger('Setup', 'SaddleMACAddRate', g_Config.ISaddle.nMACAddRate);
  Config.WriteInteger('Setup', 'SaddleDCMaxLimit', g_Config.ISaddle.nDCMaxLimit);
  Config.WriteInteger('Setup', 'SaddleDCAddValueRate', g_Config.ISaddle.nDCAddValueRate);
  Config.WriteInteger('Setup', 'SaddleDCAddRate', g_Config.ISaddle.nDCAddRate);
  Config.WriteInteger('Setup', 'SaddleMCMaxLimit', g_Config.ISaddle.nMCMaxLimit);
  Config.WriteInteger('Setup', 'SaddleMCAddValueRate', g_Config.ISaddle.nMCAddValueRate);
  Config.WriteInteger('Setup', 'SaddleMCAddRate', g_Config.ISaddle.nMCAddRate);
  Config.WriteInteger('Setup', 'SaddleSCMaxLimit', g_Config.ISaddle.nSCMaxLimit);
  Config.WriteInteger('Setup', 'SaddleSCAddValueRate', g_Config.ISaddle.nSCAddValueRate);
  Config.WriteInteger('Setup', 'SaddleSCAddRate', g_Config.ISaddle.nSCAddRate);
  Config.WriteInteger('Setup', 'SaddleCCMaxLimit', g_Config.ISaddle.nCCMaxLimit);
  Config.WriteInteger('Setup', 'SaddleCCAddValueRate', g_Config.ISaddle.nCCAddValueRate);
  Config.WriteInteger('Setup', 'SaddleCCAddRate', g_Config.ISaddle.nCCAddRate);

  Config.WriteInteger('Setup', 'DecorationACMaxLimit', g_Config.IDecoration.nACMaxLimit);
  Config.WriteInteger('Setup', 'DecorationACAddValueRate', g_Config.IDecoration.nACAddValueRate);
  Config.WriteInteger('Setup', 'DecorationACAddRate', g_Config.IDecoration.nACAddRate);
  Config.WriteInteger('Setup', 'DecorationMACMaxLimit', g_Config.IDecoration.nMACMaxLimit);
  Config.WriteInteger('Setup', 'DecorationMACAddValueRate', g_Config.IDecoration.nMACAddValueRate);
  Config.WriteInteger('Setup', 'DecorationMACAddRate', g_Config.IDecoration.nMACAddRate);
  Config.WriteInteger('Setup', 'DecorationDCMaxLimit', g_Config.IDecoration.nDCMaxLimit);
  Config.WriteInteger('Setup', 'DecorationDCAddValueRate', g_Config.IDecoration.nDCAddValueRate);
  Config.WriteInteger('Setup', 'DecorationDCAddRate', g_Config.IDecoration.nDCAddRate);
  Config.WriteInteger('Setup', 'DecorationMCMaxLimit', g_Config.IDecoration.nMCMaxLimit);
  Config.WriteInteger('Setup', 'DecorationMCAddValueRate', g_Config.IDecoration.nMCAddValueRate);
  Config.WriteInteger('Setup', 'DecorationMCAddRate', g_Config.IDecoration.nMCAddRate);
  Config.WriteInteger('Setup', 'DecorationSCMaxLimit', g_Config.IDecoration.nSCMaxLimit);
  Config.WriteInteger('Setup', 'DecorationSCAddValueRate', g_Config.IDecoration.nSCAddValueRate);
  Config.WriteInteger('Setup', 'DecorationSCAddRate', g_Config.IDecoration.nSCAddRate);
  Config.WriteInteger('Setup', 'DecorationCCMaxLimit', g_Config.IDecoration.nCCMaxLimit);
  Config.WriteInteger('Setup', 'DecorationCCAddValueRate', g_Config.IDecoration.nCCAddValueRate);
  Config.WriteInteger('Setup', 'DecorationCCAddRate', g_Config.IDecoration.nCCAddRate);

  Config.WriteInteger('Setup', 'NailACMaxLimit', g_Config.INail.nACMaxLimit);
  Config.WriteInteger('Setup', 'NailACAddValueRate', g_Config.INail.nACAddValueRate);
  Config.WriteInteger('Setup', 'NailACAddRate', g_Config.INail.nACAddRate);
  Config.WriteInteger('Setup', 'NailMACMaxLimit', g_Config.INail.nMACMaxLimit);
  Config.WriteInteger('Setup', 'NailMACAddValueRate', g_Config.INail.nMACAddValueRate);
  Config.WriteInteger('Setup', 'NailMACAddRate', g_Config.INail.nMACAddRate);
  Config.WriteInteger('Setup', 'NailDCMaxLimit', g_Config.INail.nDCMaxLimit);
  Config.WriteInteger('Setup', 'NailDCAddValueRate', g_Config.INail.nDCAddValueRate);
  Config.WriteInteger('Setup', 'NailDCAddRate', g_Config.INail.nDCAddRate);
  Config.WriteInteger('Setup', 'NailMCMaxLimit', g_Config.INail.nMCMaxLimit);
  Config.WriteInteger('Setup', 'NailMCAddValueRate', g_Config.INail.nMCAddValueRate);
  Config.WriteInteger('Setup', 'NailMCAddRate', g_Config.INail.nMCAddRate);
  Config.WriteInteger('Setup', 'NailSCMaxLimit', g_Config.INail.nSCMaxLimit);
  Config.WriteInteger('Setup', 'NailSCAddValueRate', g_Config.INail.nSCAddValueRate);
  Config.WriteInteger('Setup', 'NailSCAddRate', g_Config.INail.nSCAddRate);
  Config.WriteInteger('Setup', 'NailCCMaxLimit', g_Config.INail.nCCMaxLimit);
  Config.WriteInteger('Setup', 'NailCCAddValueRate', g_Config.INail.nCCAddValueRate);
  Config.WriteInteger('Setup', 'NailCCAddRate', g_Config.INail.nCCAddRate);
  uModValue();
end;

procedure TfrmItemSet.EditMonRandomAddValueChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.nMonRandomAddValue := EditMonRandomAddValue.Value;
  ModValue();
end;

procedure TfrmItemSet.EditMakeRandomAddValueChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.nMakeRandomAddValue := EditMakeRandomAddValue.Value;
  ModValue();
end;

procedure TfrmItemSet.FormCreate(Sender: TObject);
begin
  PageControl.TabIndex := 0;
  ItemSetPageControl.TabIndex := 0;
  AddValuePageControl.TabIndex := 0;
end;

procedure TfrmItemSet.EditNailACAddValueMaxLimitChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.INail.nACMaxLimit := EditNailACAddValueMaxLimit.Value;
  g_Config.INail.nACAddValueRate := EditNailACAddValueRate.Value;
  g_Config.INail.nACAddRate := EditNailACAddRate.Value;
  g_Config.INail.nMACMaxLimit := EditNailMACAddValueMaxLimit.Value;
  g_Config.INail.nMACAddValueRate := EditNailMACAddValueRate.Value;
  g_Config.INail.nMACAddRate := EditNailMACAddRate.Value;
  g_Config.INail.nDCMaxLimit := EditNailDCAddValueMaxLimit.Value;
  g_Config.INail.nDCAddValueRate := EditNailDCAddValueRate.Value;
  g_Config.INail.nDCAddRate := EditNailDCAddRate.Value;
  g_Config.INail.nCCMaxLimit := EditNailCCAddValueMaxLimit.Value;
  g_Config.INail.nCCAddValueRate := EditNailCCAddValueRate.Value;
  g_Config.INail.nCCAddRate := EditNailCCAddRate.Value;
  ModValue();
end;

procedure TfrmItemSet.EditNecklaceACAddValueMaxLimitChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.INecklace.nACMaxLimit := EditNecklaceACAddValueMaxLimit.Value;
  g_Config.INecklace.nACAddValueRate := EditNecklaceACAddValueRate.Value;
  g_Config.INecklace.nACAddRate := EditNecklaceACAddRate.Value;
  g_Config.INecklace.nMACMaxLimit := EditNecklaceMACAddValueMaxLimit.Value;
  g_Config.INecklace.nMACAddValueRate := EditNecklaceMACAddValueRate.Value;
  g_Config.INecklace.nMACAddRate := EditNecklaceMACAddRate.Value;
  g_Config.INecklace.nDCMaxLimit := EditNecklaceDCAddValueMaxLimit.Value;
  g_Config.INecklace.nDCAddValueRate := EditNecklaceDCAddValueRate.Value;
  g_Config.INecklace.nDCAddRate := EditNecklaceDCAddRate.Value;
  g_Config.INecklace.nMCMaxLimit := EditNecklaceMCAddValueMaxLimit.Value;
  g_Config.INecklace.nMCAddValueRate := EditNecklaceMCAddValueRate.Value;
  g_Config.INecklace.nMCAddRate := EditNecklaceMCAddRate.Value;
  g_Config.INecklace.nSCMaxLimit := EditNecklaceSCAddValueMaxLimit.Value;
  g_Config.INecklace.nSCAddValueRate := EditNecklaceSCAddValueRate.Value;
  g_Config.INecklace.nSCAddRate := EditNecklaceSCAddRate.Value;
  g_Config.INecklace.nCCMaxLimit := EditNecklaceCCAddValueMaxLimit.Value;
  g_Config.INecklace.nCCAddValueRate := EditNecklaceCCAddValueRate.Value;
  g_Config.INecklace.nCCAddRate := EditNecklaceCCAddRate.Value;
  ModValue();
end;

procedure TfrmItemSet.EditNpcMakeRandomAddValueChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.nNpcMakeRandomAddValue := EditNpcMakeRandomAddValue.Value;
  ModValue();
end;

procedure TfrmItemSet.EditReinACAddValueMaxLimitChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.IRein.nACMaxLimit := EditReinACAddValueMaxLimit.Value;
  g_Config.IRein.nACAddValueRate := EditReinACAddValueRate.Value;
  g_Config.IRein.nACAddRate := EditReinACAddRate.Value;
  g_Config.IRein.nMACMaxLimit := EditReinMACAddValueMaxLimit.Value;
  g_Config.IRein.nMACAddValueRate := EditReinMACAddValueRate.Value;
  g_Config.IRein.nMACAddRate := EditReinMACAddRate.Value;
  g_Config.IRein.nDCMaxLimit := EditReinDCAddValueMaxLimit.Value;
  g_Config.IRein.nDCAddValueRate := EditReinDCAddValueRate.Value;
  g_Config.IRein.nDCAddRate := EditReinDCAddRate.Value;
  g_Config.IRein.nCCMaxLimit := EditReinCCAddValueMaxLimit.Value;
  g_Config.IRein.nCCAddValueRate := EditReinCCAddValueRate.Value;
  g_Config.IRein.nCCAddRate := EditReinCCAddRate.Value;
  ModValue();
end;

procedure TfrmItemSet.EditRingACAddValueMaxLimitChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.IRing.nACMaxLimit := EditRingACAddValueMaxLimit.Value;
  g_Config.IRing.nACAddValueRate := EditRingACAddValueRate.Value;
  g_Config.IRing.nACAddRate := EditRingACAddRate.Value;
  g_Config.IRing.nMACMaxLimit := EditRingMACAddValueMaxLimit.Value;
  g_Config.IRing.nMACAddValueRate := EditRingMACAddValueRate.Value;
  g_Config.IRing.nMACAddRate := EditRingMACAddRate.Value;
  g_Config.IRing.nDCMaxLimit := EditRingDCAddValueMaxLimit.Value;
  g_Config.IRing.nDCAddValueRate := EditRingDCAddValueRate.Value;
  g_Config.IRing.nDCAddRate := EditRingDCAddRate.Value;
  g_Config.IRing.nMCMaxLimit := EditRingMCAddValueMaxLimit.Value;
  g_Config.IRing.nMCAddValueRate := EditRingMCAddValueRate.Value;
  g_Config.IRing.nMCAddRate := EditRingMCAddRate.Value;
  g_Config.IRing.nSCMaxLimit := EditRingSCAddValueMaxLimit.Value;
  g_Config.IRing.nSCAddValueRate := EditRingSCAddValueRate.Value;
  g_Config.IRing.nSCAddRate := EditRingSCAddRate.Value;
  g_Config.IRing.nCCMaxLimit := EditRingCCAddValueMaxLimit.Value;
  g_Config.IRing.nCCAddValueRate := EditRingCCAddValueRate.Value;
  g_Config.IRing.nCCAddRate := EditRingCCAddRate.Value;
  ModValue();
end;

procedure TfrmItemSet.EditSaddleACAddValueMaxLimitChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.ISaddle.nACMaxLimit := EditSaddleACAddValueMaxLimit.Value;
  g_Config.ISaddle.nACAddValueRate := EditSaddleACAddValueRate.Value;
  g_Config.ISaddle.nACAddRate := EditSaddleACAddRate.Value;
  g_Config.ISaddle.nMACMaxLimit := EditSaddleMACAddValueMaxLimit.Value;
  g_Config.ISaddle.nMACAddValueRate := EditSaddleMACAddValueRate.Value;
  g_Config.ISaddle.nMACAddRate := EditSaddleMACAddRate.Value;
  g_Config.ISaddle.nDCMaxLimit := EditSaddleDCAddValueMaxLimit.Value;
  g_Config.ISaddle.nDCAddValueRate := EditSaddleDCAddValueRate.Value;
  g_Config.ISaddle.nDCAddRate := EditSaddleDCAddRate.Value;
  g_Config.ISaddle.nCCMaxLimit := EditSaddleCCAddValueMaxLimit.Value;
  g_Config.ISaddle.nCCAddValueRate := EditSaddleCCAddValueRate.Value;
  g_Config.ISaddle.nCCAddRate := EditSaddleCCAddRate.Value;
  ModValue();
end;

procedure TfrmItemSet.EditGuildRecallTimeChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.nGuildRecallTime := EditGuildRecallTime.Value;
  ModValue();
end;

procedure TfrmItemSet.EditHelmetACAddValueMaxLimitChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.IHelmet.nACMaxLimit := EditHelmetACAddValueMaxLimit.Value;
  g_Config.IHelmet.nACAddValueRate := EditHelmetACAddValueRate.Value;
  g_Config.IHelmet.nACAddRate := EditHelmetACAddRate.Value;
  g_Config.IHelmet.nMACMaxLimit := EditHelmetMACAddValueMaxLimit.Value;
  g_Config.IHelmet.nMACAddValueRate := EditHelmetMACAddValueRate.Value;
  g_Config.IHelmet.nMACAddRate := EditHelmetMACAddRate.Value;
  g_Config.IHelmet.nDCMaxLimit := EditHelmetDCAddValueMaxLimit.Value;
  g_Config.IHelmet.nDCAddValueRate := EditHelmetDCAddValueRate.Value;
  g_Config.IHelmet.nDCAddRate := EditHelmetDCAddRate.Value;
  g_Config.IHelmet.nMCMaxLimit := EditHelmetMCAddValueMaxLimit.Value;
  g_Config.IHelmet.nMCAddValueRate := EditHelmetMCAddValueRate.Value;
  g_Config.IHelmet.nMCAddRate := EditHelmetMCAddRate.Value;
  g_Config.IHelmet.nSCMaxLimit := EditHelmetSCAddValueMaxLimit.Value;
  g_Config.IHelmet.nSCAddValueRate := EditHelmetSCAddValueRate.Value;
  g_Config.IHelmet.nSCAddRate := EditHelmetSCAddRate.Value;
  g_Config.IHelmet.nCCMaxLimit := EditHelmetCCAddValueMaxLimit.Value;
  g_Config.IHelmet.nCCAddValueRate := EditHelmetCCAddValueRate.Value;
  g_Config.IHelmet.nCCAddRate := EditHelmetCCAddRate.Value;
  ModValue();
end;

procedure TfrmItemSet.RefUnknowItem;
begin

end;

procedure TfrmItemSet.RefShapeItem;
begin
  EditAttackPosionRate.Value := g_Config.nAttackPosionRate;
  EditAttackPosionTime.Value := g_Config.nAttackPosionTime;
  CheckBoxUserMoveCanDupObj.Checked := g_Config.boUserMoveCanDupObj;
  CheckBoxUserMoveCanOnItem.Checked := g_Config.boUserMoveCanOnItem;
  EditUserMoveTime.Value := g_Config.dwUserMoveTime;
end;

procedure TfrmItemSet.EditAbilityMoveBaseRateChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.vAbilityMoveSet.BaseRate := EditAbilityMoveBaseRate.Value;
  ModValue();
end;

procedure TfrmItemSet.EditAbilityMoveGoldChange(Sender: TObject);
begin
  if not boOpened then
    Exit;
  g_Config.vAbilityMoveSet.Gold := EditAbilityMoveGold.Value;
  ModValue();
end;

procedure TfrmItemSet.EditArmRingACAddValueMaxLimitChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.IArmRing.nACMaxLimit := EditArmRingACAddValueMaxLimit.Value;
  g_Config.IArmRing.nACAddValueRate := EditArmRingACAddValueRate.Value;
  g_Config.IArmRing.nACAddRate := EditArmRingACAddRate.Value;
  g_Config.IArmRing.nMACMaxLimit := EditArmRingMACAddValueMaxLimit.Value;
  g_Config.IArmRing.nMACAddValueRate := EditArmRingMACAddValueRate.Value;
  g_Config.IArmRing.nMACAddRate := EditArmRingMACAddRate.Value;
  g_Config.IArmRing.nDCMaxLimit := EditArmRingDCAddValueMaxLimit.Value;
  g_Config.IArmRing.nDCAddValueRate := EditArmRingDCAddValueRate.Value;
  g_Config.IArmRing.nDCAddRate := EditArmRingDCAddRate.Value;
  g_Config.IArmRing.nMCMaxLimit := EditArmRingMCAddValueMaxLimit.Value;
  g_Config.IArmRing.nMCAddValueRate := EditArmRingMCAddValueRate.Value;
  g_Config.IArmRing.nMCAddRate := EditArmRingMCAddRate.Value;
  g_Config.IArmRing.nSCMaxLimit := EditArmRingSCAddValueMaxLimit.Value;
  g_Config.IArmRing.nSCAddValueRate := EditArmRingSCAddValueRate.Value;
  g_Config.IArmRing.nSCAddRate := EditArmRingSCAddRate.Value;
  g_Config.IArmRing.nCCMaxLimit := EditArmRingCCAddValueMaxLimit.Value;
  g_Config.IArmRing.nCCAddValueRate := EditArmRingCCAddValueRate.Value;
  g_Config.IArmRing.nCCAddRate := EditArmRingCCAddRate.Value;
  ModValue();
end;

procedure TfrmItemSet.EditAttackPosionRateChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.nAttackPosionRate := EditAttackPosionRate.Value;
  ModValue();
end;

procedure TfrmItemSet.EditAttackPosionTimeChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.nAttackPosionTime := EditAttackPosionTime.Value;
  ModValue();
end;

procedure TfrmItemSet.EditBellACAddValueMaxLimitChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.IBell.nACMaxLimit := EditBellACAddValueMaxLimit.Value;
  g_Config.IBell.nACAddValueRate := EditBellACAddValueRate.Value;
  g_Config.IBell.nACAddRate := EditBellACAddRate.Value;
  g_Config.IBell.nMACMaxLimit := EditBellMACAddValueMaxLimit.Value;
  g_Config.IBell.nMACAddValueRate := EditBellMACAddValueRate.Value;
  g_Config.IBell.nMACAddRate := EditBellMACAddRate.Value;
  g_Config.IBell.nDCMaxLimit := EditBellDCAddValueMaxLimit.Value;
  g_Config.IBell.nDCAddValueRate := EditBellDCAddValueRate.Value;
  g_Config.IBell.nDCAddRate := EditBellDCAddRate.Value;
  g_Config.IBell.nCCMaxLimit := EditBellCCAddValueMaxLimit.Value;
  g_Config.IBell.nCCAddValueRate := EditBellCCAddValueRate.Value;
  g_Config.IBell.nCCAddRate := EditBellCCAddRate.Value;
  ModValue();
end;

procedure TfrmItemSet.EditBeltACAddValueMaxLimitChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.IBelt.nACMaxLimit := EditBeltACAddValueMaxLimit.Value;
  g_Config.IBelt.nACAddValueRate := EditBeltACAddValueRate.Value;
  g_Config.IBelt.nACAddRate := EditBeltACAddRate.Value;
  g_Config.IBelt.nMACMaxLimit := EditBeltMACAddValueMaxLimit.Value;
  g_Config.IBelt.nMACAddValueRate := EditBeltMACAddValueRate.Value;
  g_Config.IBelt.nMACAddRate := EditBeltMACAddRate.Value;
  g_Config.IBelt.nDCMaxLimit := EditBeltDCAddValueMaxLimit.Value;
  g_Config.IBelt.nDCAddValueRate := EditBeltDCAddValueRate.Value;
  g_Config.IBelt.nDCAddRate := EditBeltDCAddRate.Value;
  g_Config.IBelt.nMCMaxLimit := EditBeltMCAddValueMaxLimit.Value;
  g_Config.IBelt.nMCAddValueRate := EditBeltMCAddValueRate.Value;
  g_Config.IBelt.nMCAddRate := EditBeltMCAddRate.Value;
  g_Config.IBelt.nSCMaxLimit := EditBeltSCAddValueMaxLimit.Value;
  g_Config.IBelt.nSCAddValueRate := EditBeltSCAddValueRate.Value;
  g_Config.IBelt.nSCAddRate := EditBeltSCAddRate.Value;
  g_Config.IBelt.nCCMaxLimit := EditBeltCCAddValueMaxLimit.Value;
  g_Config.IBelt.nCCAddValueRate := EditBeltCCAddValueRate.Value;
  g_Config.IBelt.nCCAddRate := EditBeltCCAddRate.Value;
  ModValue();
end;

procedure TfrmItemSet.EditBootACAddValueMaxLimitChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.IBoot.nACMaxLimit := EditBootACAddValueMaxLimit.Value;
  g_Config.IBoot.nACAddValueRate := EditBootACAddValueRate.Value;
  g_Config.IBoot.nACAddRate := EditBootACAddRate.Value;
  g_Config.IBoot.nMACMaxLimit := EditBootMACAddValueMaxLimit.Value;
  g_Config.IBoot.nMACAddValueRate := EditBootMACAddValueRate.Value;
  g_Config.IBoot.nMACAddRate := EditBootMACAddRate.Value;
  g_Config.IBoot.nDCMaxLimit := EditBootDCAddValueMaxLimit.Value;
  g_Config.IBoot.nDCAddValueRate := EditBootDCAddValueRate.Value;
  g_Config.IBoot.nDCAddRate := EditBootDCAddRate.Value;
  g_Config.IBoot.nMCMaxLimit := EditBootMCAddValueMaxLimit.Value;
  g_Config.IBoot.nMCAddValueRate := EditBootMCAddValueRate.Value;
  g_Config.IBoot.nMCAddRate := EditBootMCAddRate.Value;
  g_Config.IBoot.nSCMaxLimit := EditBootSCAddValueMaxLimit.Value;
  g_Config.IBoot.nSCAddValueRate := EditBootSCAddValueRate.Value;
  g_Config.IBoot.nSCAddRate := EditBootSCAddRate.Value;
  g_Config.IBoot.nCCMaxLimit := EditBootCCAddValueMaxLimit.Value;
  g_Config.IBoot.nCCAddValueRate := EditBootCCAddValueRate.Value;
  g_Config.IBoot.nCCAddRate := EditBootCCAddRate.Value;
  ModValue();
end;

procedure TfrmItemSet.EditDecorationACAddValueMaxLimitChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.IDecoration.nACMaxLimit := EditDecorationACAddValueMaxLimit.Value;
  g_Config.IDecoration.nACAddValueRate := EditDecorationACAddValueRate.Value;
  g_Config.IDecoration.nACAddRate := EditDecorationACAddRate.Value;
  g_Config.IDecoration.nMACMaxLimit := EditDecorationMACAddValueMaxLimit.Value;
  g_Config.IDecoration.nMACAddValueRate := EditDecorationMACAddValueRate.Value;
  g_Config.IDecoration.nMACAddRate := EditDecorationMACAddRate.Value;
  g_Config.IDecoration.nDCMaxLimit := EditDecorationDCAddValueMaxLimit.Value;
  g_Config.IDecoration.nDCAddValueRate := EditDecorationDCAddValueRate.Value;
  g_Config.IDecoration.nDCAddRate := EditDecorationDCAddRate.Value;
  g_Config.IDecoration.nCCMaxLimit := EditDecorationCCAddValueMaxLimit.Value;
  g_Config.IDecoration.nCCAddValueRate := EditDecorationCCAddValueRate.Value;
  g_Config.IDecoration.nCCAddRate := EditDecorationCCAddRate.Value;
  ModValue();
end;

procedure TfrmItemSet.EditDressACAddValueMaxLimitChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.IDress.nACMaxLimit := EditDressACAddValueMaxLimit.Value;
  g_Config.IDress.nACAddValueRate := EditDressACAddValueRate.Value;
  g_Config.IDress.nACAddRate := EditDressACAddRate.Value;
  g_Config.IDress.nMACMaxLimit := EditDressMACAddValueMaxLimit.Value;
  g_Config.IDress.nMACAddValueRate := EditDressMACAddValueRate.Value;
  g_Config.IDress.nMACAddRate := EditDressMACAddRate.Value;
  g_Config.IDress.nDCMaxLimit := EditDressDCAddValueMaxLimit.Value;
  g_Config.IDress.nDCAddValueRate := EditDressDCAddValueRate.Value;
  g_Config.IDress.nDCAddRate := EditDressDCAddRate.Value;
  g_Config.IDress.nMCMaxLimit := EditDressMCAddValueMaxLimit.Value;
  g_Config.IDress.nMCAddValueRate := EditDressMCAddValueRate.Value;
  g_Config.IDress.nMCAddRate := EditDressMCAddRate.Value;
  g_Config.IDress.nSCMaxLimit := EditDressSCAddValueMaxLimit.Value;
  g_Config.IDress.nSCAddValueRate := EditDressSCAddValueRate.Value;
  g_Config.IDress.nSCAddRate := EditDressSCAddRate.Value;
  g_Config.IDress.nCCMaxLimit := EditDressCCAddValueMaxLimit.Value;
  g_Config.IDress.nCCAddValueRate := EditDressCCAddValueRate.Value;
  g_Config.IDress.nCCAddRate := EditDressCCAddRate.Value;
  ModValue();
end;

procedure TfrmItemSet.EditFlute1RateChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.nFlute1RateValue := EditFlute1Rate.Value;
  ModValue();
end;

procedure TfrmItemSet.EditFlute2RateChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.nFlute2RateValue := EditFlute2Rate.Value;
  ModValue();
end;

procedure TfrmItemSet.EditFlute3RateChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.nFlute3RateValue := EditFlute3Rate.Value;
  ModValue();
end;

procedure TfrmItemSet.CheckBoxMakeRandomClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boMakeRandomIsOpenShow := CheckBoxMakeRandom.Checked;
  ModValue();
end;

procedure TfrmItemSet.CheckBoxMonRandomClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boMonRandomIsOpenShow := CheckBoxMonRandom.Checked;
  ModValue();
end;

procedure TfrmItemSet.CheckBoxNpcMakeRandomClick(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.boNPCMakeRandomIsOpenShow := CheckBoxNPCMakeRandom.Checked;
  ModValue();
end;

procedure TfrmItemSet.CheckBoxOpenArmStrengthenClick(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.boOpenArmStrengthen := CheckBoxOpenArmStrengthen.Checked;
  ModValue();
end;

procedure TfrmItemSet.CheckBoxOpenItemFluteClick(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.boOpenItemFlute := CheckBoxOpenItemFlute.Checked;
  ModValue();
end;

procedure TfrmItemSet.CheckBoxUserMoveCanDupObjClick(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.boUserMoveCanDupObj := CheckBoxUserMoveCanDupObj.Checked;
  ModValue();
end;

procedure TfrmItemSet.CheckBoxUserMoveCanOnItemClick(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.boUserMoveCanOnItem := CheckBoxUserMoveCanOnItem.Checked;
  ModValue();
end;

procedure TfrmItemSet.EditUserMoveTimeChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.dwUserMoveTime := EditUserMoveTime.Value;
  ModValue();
end;

procedure TfrmItemSet.EditWeaponACAddValueMaxLimitChange(Sender: TObject);
begin
  if not boOpened then exit;
  g_Config.IWeapon.nACMaxLimit := EditWeaponACAddValueMaxLimit.Value;
  g_Config.IWeapon.nACAddValueRate := EditWeaponACAddValueRate.Value;
  g_Config.IWeapon.nACAddRate := EditWeaponACAddRate.Value;
  g_Config.IWeapon.nMACMaxLimit := EditWeaponMACAddValueMaxLimit.Value;
  g_Config.IWeapon.nMACAddValueRate := EditWeaponMACAddValueRate.Value;
  g_Config.IWeapon.nMACAddRate := EditWeaponMACAddRate.Value;
  g_Config.IWeapon.nDCMaxLimit := EditWeaponDCAddValueMaxLimit.Value;
  g_Config.IWeapon.nDCAddValueRate := EditWeaponDCAddValueRate.Value;
  g_Config.IWeapon.nDCAddRate := EditWeaponDCAddRate.Value;
  g_Config.IWeapon.nMCMaxLimit := EditWeaponMCAddValueMaxLimit.Value;
  g_Config.IWeapon.nMCAddValueRate := EditWeaponMCAddValueRate.Value;
  g_Config.IWeapon.nMCAddRate := EditWeaponMCAddRate.Value;
  g_Config.IWeapon.nSCMaxLimit := EditWeaponSCAddValueMaxLimit.Value;
  g_Config.IWeapon.nSCAddValueRate := EditWeaponSCAddValueRate.Value;
  g_Config.IWeapon.nSCAddRate := EditWeaponSCAddRate.Value;
  g_Config.IWeapon.nCCMaxLimit := EditWeaponCCAddValueMaxLimit.Value;
  g_Config.IWeapon.nCCAddValueRate := EditWeaponCCAddValueRate.Value;
  g_Config.IWeapon.nCCAddRate := EditWeaponCCAddRate.Value;
  ModValue();
end;

procedure TfrmItemSet.EditWuXinMaxRateChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.nWuXinMaxRate := EditWuXinMaxRate.Value;
  ModValue();
end;

procedure TfrmItemSet.EditWuXinMinRateChange(Sender: TObject);
begin
  if not boOpened then
    exit;
  g_Config.nWuXinMinRate := EditWuXinMinRate.Value;
  ModValue();
end;

end.

