unit AxeMon2;

interface
uses
  Windows, Classes, AxeMon,
  Grobal2, HGETextures, CliUtil, magiceff, Actor;

type

  {TFlyingSpider}

  TMolongKindSpider = class(TSkeletonOma)
  protected
  public
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
  end;

  TFiredrakeKingSpider = class(TActor)
  protected
    EffectSurface: TDirectDrawSurface; //0x240
    ax: Integer; //0x244
    ay: integer; //0x248
  public
    constructor Create; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean; boFlag: Boolean); override;
  end;

  TM2N4XKingSpider = class(TActor)
  protected
    EffectSurface: TDirectDrawSurface; //0x240
    ax: Integer; //0x244
    ay: integer; //0x248
  public
    constructor Create; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean; boFlag: Boolean); override;
  end;

  TXueyuKindSpider = class(TActor)
  protected
    EffectSurface: TDirectDrawSurface; //0x240
    ax: Integer; //0x244
    ay: integer; //0x248
    procedure CalcActorFrame; override;
  public
    constructor Create; override;
    procedure LoadSurface; override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean; boFlag: Boolean); override;
  end;

  T87KindSpider = class(TActor)
  protected
    EffectSurface: TDirectDrawSurface; //0x240
    ax: Integer; //0x244
    ay: integer; //0x248
    EffectSurfaceEx: TDirectDrawSurface; //0x240
    axEx: Integer; //0x244
    ayEx: integer; //0x248
    EffectTick: LongWord;
    EffectIdx: Byte;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
    procedure CalcActorFrame; override;
  public
    constructor Create; override;
    procedure LoadSurface; override;
    function Run(): Boolean; override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean; boFlag: Boolean); override;
  end;

  //±ê×¼Ë«ÖØ¹¥»÷¹ÖÎï
  TDoubleATKSpider = class(TActor)
  protected
    EffectSurface: TDirectDrawSurface; //0x240
    ax: Integer; //0x244
    ay: integer; //0x248
    EffectSurfaceEx: TDirectDrawSurface; //0x240
    axEx: Integer; //0x244
    ayEx: integer; //0x248
    EffectSurfaceEx2: TDirectDrawSurface; //0x240
    axEx2: Integer; //0x244
    ayEx2: integer; //0x248
    procedure CalcActorFrame; override;
  public
    constructor Create; override;
    procedure LoadSurface; override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean; boFlag: Boolean); override;
  end;

  //±¦Ïä¹ÖÎï
  TBoxSpider = class(TActor)
  protected
    EffectSurface: TDirectDrawSurface; //0x240
    ax: Integer; //0x244
    ay: integer; //0x248
    procedure CalcActorFrame; override;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
  public
    constructor Create; override;
    procedure LoadSurface; override;
    function Run(): Boolean; override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean; boFlag: Boolean); override;
  end;

  TPillarSpider = class(TActor)
  protected
    EffectSurface: TDirectDrawSurface; //0x240
    ax: Integer; //0x244
    ay: integer; //0x248
    procedure CalcActorFrame; override;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
  public
    constructor Create; override;
    procedure LoadSurface; override;
    function Run(): Boolean; override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean; boFlag: Boolean); override;
  end;

  //Ò©²Ý¹ÖÎï
  TGrassSpider = class(TActor)
  protected
    procedure CalcActorFrame; override;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
  public
    constructor Create; override;
    procedure LoadSurface; override;
    function Run(): Boolean; override;
  end;
implementation

uses
  ClMain, WIL, WMFile;

{ TMolongKindSpider }

procedure TMolongKindSpider.CalcActorFrame;
begin
  inherited;

end;

procedure TMolongKindSpider.LoadSurface;
begin
  inherited LoadSurface;
  m_boUseEffect := FALSE;
  case m_wAppearance of
    219: begin
        case m_nCurrentAction of
          SM_HIT: begin
              EffectSurface := g_WMons[22].GetCachedImage(m_nBodyOffset + 580 + m_nCurrentFrame, ax, ay);
              m_boUseEffect := TRUE;
            end;
          SM_NOWDEATH: begin
              EffectSurface := g_WMons[22].GetCachedImage(m_nBodyOffset + 160 + m_nCurrentFrame, ax, ay);
              m_boUseEffect := TRUE;
            end;
        end;
      end;
  end;
end;

{ TFiredrakeKingSpider }

procedure TFiredrakeKingSpider.CalcActorFrame;
begin
  m_boUseMagic := FALSE;
  m_nCurrentFrame := -1;
  m_nBodyOffset := GetOffset(m_wAppearance);
  m_Action := GetRaceByPM(m_btRace, m_wAppearance);
  if m_Action = nil then
    Exit;
  case m_nCurrentAction of
    SM_TURN: begin
        m_nStartFrame := m_Action.ActStand.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActStand.frame - 1;
        m_dwFrameTime := m_Action.ActStand.ftime;
        m_dwStartTime := GetTickCount;
        m_nDefFrameCount := m_Action.ActStand.frame;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_HIT: begin
        m_nStartFrame := m_Action.ActAttack.start + m_btDir * (m_Action.ActAttack.frame + m_Action.ActAttack.skip);
        m_nEndFrame := m_nStartFrame + m_Action.ActAttack.frame - 1;
        m_dwFrameTime := m_Action.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        //WarMode := TRUE;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_STRUCK: begin
        m_nStartFrame := m_Action.ActStruck.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActStruck.frame - 1;
        m_dwFrameTime := m_Action.ActStruck.ftime; //pm.ActStruck.ftime;
        m_dwStartTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_DEATH: begin
        m_nStartFrame := m_Action.ActDie.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActDie.frame - 1;
        m_nStartFrame := m_nEndFrame; //
        m_dwFrameTime := m_Action.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_NOWDEATH: begin
        m_nStartFrame := m_Action.ActDie.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActDie.frame - 1;
        m_dwFrameTime := m_Action.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_SKELETON: begin
        m_nStartFrame := m_Action.ActDeath.start + m_btDir;
        m_nEndFrame := m_nStartFrame + m_Action.ActDeath.frame - 1;
        m_dwFrameTime := m_Action.ActDeath.ftime;
        m_dwStartTime := GetTickCount;
      end;
  end;
end;

constructor TFiredrakeKingSpider.Create;
begin
  inherited Create;
  m_boOutside := True;
  EffectSurface := nil;
end;

procedure TFiredrakeKingSpider.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer; blend, boFlag: Boolean);
var
  ceff: TColorEffect;
begin
  if not (m_btDir in [0..7]) then
    exit;
  if GetTickCount - m_dwLoadSurfaceTime > 60 * 1000 then begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;

  ceff := GetDrawEffectValue;

  if m_BodySurface <> nil then begin
    DrawEffSurface(dsurface, m_BodySurface, dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY, blend, ceff);
  end;

  if m_boUseEffect then
    if EffectSurface <> nil then begin
      DrawBlend(dsurface,
        dx + ax + m_nShiftX,
        dy + ay + m_nShiftY,
        EffectSurface, 1);
    end;
end;

function TFiredrakeKingSpider.GetDefaultFrame(wmode: Boolean): Integer;
var
  cf: Integer;
  pm: pTMonsterAction;
begin
  Result := 0; //Jacky
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    Exit;
  m_dwDefFrameTick := pm.ActStand.ftime;
  if m_boDeath then begin
    {if m_boSkeleton then
      Result := pm.ActDeath.start
    else
      Result := pm.ActDie.start + (pm.ActDie.frame - 1);   }
    Result := 82;
  end
  else begin
    m_nDefFrameCount := pm.ActStand.frame;
    if m_nCurrentDefFrame < 0 then
      cf := 0
    else if m_nCurrentDefFrame >= pm.ActStand.frame then
      cf := 0
    else
      cf := m_nCurrentDefFrame;
    Result := pm.ActStand.start + cf;
  end;
end;

procedure TFiredrakeKingSpider.LoadSurface;
begin
  inherited LoadSurface;
  m_boUseEffect := FALSE;
  case m_wAppearance of
    800: begin
        case m_nCurrentAction of
          SM_HIT: begin
              EffectSurface := g_WDragonImages.GetCachedImage(m_nBodyOffset + 80 + m_nCurrentFrame, ax, ay);
              m_boUseEffect := TRUE;
            end;
          SM_NOWDEATH: begin
              EffectSurface := g_WDragonImages.GetCachedImage(m_nBodyOffset + 10 + m_nCurrentFrame, ax, ay);
              m_boUseEffect := TRUE;
              if m_nCurrentFrame > 59 then
                m_BodySurface := nil;
            end;
          SM_DEATH: m_BodySurface := nil;
        end;
      end;
  end;

end;

{ TXueyuKindSpider }

procedure TXueyuKindSpider.CalcActorFrame;
var
  meff: TMagicEff;
begin
  inherited CalcActorFrame;
  if (m_WMImages <> nil) and (m_Action <> nil) then begin
    case m_nCurrentAction of
      SM_HIT: begin
          if m_wAppearance = 329 then begin
            meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, g_WMons[27], 2540 + m_nStartFrame + 770, 10, 72, True, 100);
          end else begin
            meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages, m_nBodyOffset + m_nStartFrame + 770, 10, 72, True, 100);
          end;
          PlayScene.m_EffectList.Add(meff);
        end;
      SM_LIGHTING: begin
          m_nStartFrame := m_Action.ActCritical.start + m_btDir * (m_Action.ActCritical.frame + m_Action.ActCritical.skip);
          m_nEndFrame := m_nStartFrame + m_Action.ActCritical.frame - 1;
          m_dwFrameTime := m_Action.ActCritical.ftime;
          m_dwStartTime := GetTickCount;
          m_dwWarModeTime := GetTickCount;
          Shift(m_btDir, 0, 0, 1);
          if m_wAppearance = 329 then begin
            meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, g_WMons[27], 2540 + 1010, 10, 72, True, 100);
          end else begin
            meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages, m_nBodyOffset + 1010, 10, 72, True, 100);
          end;
          PlayScene.m_EffectList.Add(meff);
        end;
    end;
  end;
end;

constructor TXueyuKindSpider.Create;
begin
  inherited;
  EffectSurface := nil;
end;

procedure TXueyuKindSpider.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer; blend, boFlag: Boolean);
begin
  inherited;
  if m_boUseEffect then begin
    if EffectSurface <> nil then begin
      DrawBlend(DSurface, dx + ax + m_nShiftX, dy + ay + m_nShiftY, EffectSurface, 1);
      //DSurface.Draw(dx + ax + m_nShiftX, dy + ay + m_nShiftY, EffectSurface.ClientRect, EffectSurface, fxBlend);
      {if m_nCurrentAction = SM_NOWDEATH then
        DSurface.Draw(dx + ax + m_nShiftX, dy + ay + m_nShiftY, EffectSurface.ClientRect, EffectSurface, fxBlend)
      else
        DrawBlend(DSurface, dx + ax + m_nShiftX, dy + ay + m_nShiftY, EffectSurface, 1);    }
    end;
  end;
end;

procedure TXueyuKindSpider.LoadSurface;
begin
  m_boUseEffect := FALSE;
  if m_WMImages <> nil then begin
    if (not m_boReverseFrame) then
      m_BodySurface := m_WMImages.GetCachedImage(GetOffset(m_wAppearance) + m_nCurrentFrame, m_nPx, m_nPy)
    else
      m_BodySurface := m_WMImages.GetCachedImage(GetOffset(m_wAppearance) + m_nEndFrame - (m_nCurrentFrame - m_nStartFrame), m_nPx, m_nPy);

    if m_wAppearance = 329 then begin
      EffectSurface := g_WMons[27].GetCachedImage(2540 + 500 + m_nCurrentFrame, ax, ay);
    end else begin
      EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 500 + m_nCurrentFrame, ax, ay);
    end;
    m_boUseEffect := TRUE;
  end;
end;

{ TDoubleATKSpider }

procedure TDoubleATKSpider.CalcActorFrame;
var
  meff: TMagicEff;
begin
 { if (m_WMImages <> nil) and (m_Action <> nil) and (m_nCurrentAction = SM_RUSH) then begin
    m_boUseMagic := FALSE;
    m_nCurrentFrame := -1;
    m_nBodyOffset := GetOffset(m_wAppearance);
    m_Action := GetRaceByPM(m_btRace, m_wAppearance);
    if m_Action = nil then Exit;

    m_nStartFrame := m_Action.ActCritical.start + m_btDir * (m_Action.ActCritical.frame + m_Action.ActCritical.skip);
    m_nEndFrame := m_nStartFrame + m_Action.ActCritical.frame - 1;
    m_dwFrameTime := m_Action.ActCritical.ftime;
    m_dwStartTime := GetTickCount;
    m_dwWarModeTime := GetTickCount;
    m_nMaxTick := m_Action.ActCritical.usetick;
    m_nCurTick := 0;
    m_nMoveStep := 1;
    Shift(m_btDir, 1, 0, m_nEndFrame - m_nStartFrame + 1);
    Exit;
  end;              }
  inherited CalcActorFrame;
  if (m_WMImages <> nil) and (m_Action <> nil) then begin
    case m_nCurrentAction of
      {SM_HIT: begin
          meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages,
            m_nBodyOffset + m_nStartFrame + 770, 10, 72, True, 100);
          PlayScene.m_EffectList.Add(meff);
        end; }
      SM_HIT: begin
          if m_wAppearance in [241, 250, 251] then begin
            m_nStartFrame := m_Action.ActCritical.start + m_btDir * (m_Action.ActCritical.frame + m_Action.ActCritical.skip);
            m_nEndFrame := m_nStartFrame + m_Action.ActCritical.frame - 1;
            m_dwFrameTime := m_Action.ActCritical.ftime;
            m_dwStartTime := GetTickCount;
            m_dwWarModeTime := GetTickCount;
            Shift(m_btDir, 0, 0, 1);
          end;

        end;
      SM_HIT_2: begin
          m_nStartFrame := m_Action.ActAttack2.start + m_btDir * (m_Action.ActAttack2.frame + m_Action.ActAttack2.skip);
          m_nEndFrame := m_nStartFrame + m_Action.ActAttack2.frame - 1;
          m_dwFrameTime := m_Action.ActAttack2.ftime;
          m_dwStartTime := GetTickCount;
          //WarMode := TRUE;
          m_dwWarModeTime := GetTickCount;
          Shift(m_btDir, 0, 0, 1);
          if (m_wAppearance = 527) then begin
            meff := TNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages, 3970, 20, 50, True);
            PlayScene.m_EffectList.Add(meff);
          end else
          if (m_wAppearance = 322) then begin
            meff := TNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages, 1330, 20, 50, True);
            PlayScene.m_EffectList.Add(meff);
          end else
          if m_wAppearance = 549 then begin
            meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages, 6880, 10, 60, True, 400);
            PlayScene.m_EffectList.Add(meff);
          end else
          if m_wAppearance = 564 then begin
            meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages, 2530, 10, 60, True, 500);
            PlayScene.m_EffectList.Add(meff);
          end else
          if m_wAppearance = 569 then begin
            meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages, 5440, 10, 60, True, 300);
            PlayScene.m_EffectList.Add(meff);
          end else
          if m_wAppearance = 559 then begin
            meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages, 7100, 10, 60, True, 400);
            PlayScene.m_EffectList.Add(meff);
          end;
        end;
      SM_HIT_3: begin
          m_nStartFrame := m_Action.ActAttack3.start + m_btDir * (m_Action.ActAttack3.frame + m_Action.ActAttack3.skip);
          m_nEndFrame := m_nStartFrame + m_Action.ActAttack3.frame - 1;
          m_dwFrameTime := m_Action.ActAttack3.ftime;
          m_dwStartTime := GetTickCount;
          //WarMode := TRUE;
          m_dwWarModeTime := GetTickCount;
          Shift(m_btDir, 0, 0, 1);
          if m_wAppearance = 517 then begin
            meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages, 4990, 10, 60, True, 420);
            PlayScene.m_EffectList.Add(meff);
          end;
          if m_wAppearance = 524 then begin
            meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY - 1, m_WMImages, 2490, 8, 60, True, 420);
            PlayScene.m_EffectList.Add(meff);
          end else
          if m_wAppearance = 569 then begin
            meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages, 5720, 10, 40, True, 300);
            PlayScene.m_EffectList.Add(meff);
            meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages, 5730, 12, 40, True, 300);
            PlayScene.m_EffectList.Add(meff);
          end;
        end;
      SM_HIT_4: begin
          m_nStartFrame := m_Action.ActAttack4.start + m_btDir * (m_Action.ActAttack4.frame + m_Action.ActAttack4.skip);
          m_nEndFrame := m_nStartFrame + m_Action.ActAttack4.frame - 1;
          m_dwFrameTime := m_Action.ActAttack4.ftime;
          m_dwStartTime := GetTickCount;
          //WarMode := TRUE;
          m_dwWarModeTime := GetTickCount;
          Shift(m_btDir, 0, 0, 1);
        end;
      SM_HIT_5: begin
          m_nStartFrame := m_Action.ActAttack5.start + m_btDir * (m_Action.ActAttack5.frame + m_Action.ActAttack5.skip);
          m_nEndFrame := m_nStartFrame + m_Action.ActAttack5.frame - 1;
          m_dwFrameTime := m_Action.ActAttack5.ftime;
          m_dwStartTime := GetTickCount;
          //WarMode := TRUE;
          m_dwWarModeTime := GetTickCount;
          Shift(m_btDir, 0, 0, 1);
        end;
      SM_RUSH: begin
          m_nStartFrame := m_Action.ActCritical.start + m_btDir * (m_Action.ActCritical.frame + m_Action.ActCritical.skip);
          m_nEndFrame := m_nStartFrame + m_Action.ActCritical.frame - 1;
          m_dwFrameTime := m_Action.ActCritical.ftime;
          m_dwStartTime := GetTickCount;
          m_dwWarModeTime := GetTickCount;
          m_nMaxTick := m_Action.ActCritical.usetick;
          m_nCurTick := 0;
          m_nMoveStep := 1;
          Shift(m_btDir, 1, 0, m_nEndFrame - m_nStartFrame + 1);
        end;
      SM_LIGHTING: begin
          m_nStartFrame := m_Action.ActCritical.start + m_btDir * (m_Action.ActCritical.frame + m_Action.ActCritical.skip);
          m_nEndFrame := m_nStartFrame + m_Action.ActCritical.frame - 1;
          m_dwFrameTime := m_Action.ActCritical.ftime;
          m_dwStartTime := GetTickCount;
          m_dwWarModeTime := GetTickCount;
          if m_wAppearance = 568 then Shift(m_btDir, 1, 0, m_nEndFrame - m_nStartFrame + 1)
          else Shift(m_btDir, 0, 0, 1);
          if m_wAppearance = 236 then begin  //À×Ñ×ÖëÍõ
            meff := TDelayNormalDrawEffect.Create(m_nTargetX, m_nTargetY, m_WMImages, 3730, 10, 100, True, 100);
            PlayScene.m_EffectList.Add(meff);
          end else
          if m_wAppearance = 506 then begin
            meff := TNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages, 3770, 10, 60, True);
            PlayScene.m_EffectList.Add(meff);
          end else
          if m_wAppearance = 517 then begin
            meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages, 4880, 10, 60, True, 450);
            PlayScene.m_EffectList.Add(meff);
          end else
          if m_wAppearance = 545 then begin
            meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages, 2730 + m_btDir * 10, 10, 60, True, 450);
            PlayScene.m_EffectList.Add(meff);
          end else
          if m_wAppearance = 547 then begin
            meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages, 4750, 10, 60, True, 450);
            PlayScene.m_EffectList.Add(meff);
          end else
          if m_wAppearance = 549 then begin
            meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages, 6870, 10, 60, True, 400);
            PlayScene.m_EffectList.Add(meff);
          end;
          {meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages,
            m_nBodyOffset + 1010, 10, 72, True, 100);
          PlayScene.m_EffectList.Add(meff); }
        end;
      
    end;
  end;
end;

constructor TDoubleATKSpider.Create;
begin
  inherited;
  EffectSurface := nil;
  EffectSurfaceEx := nil;
  EffectSurfaceEx2 := nil;
end;

procedure TDoubleATKSpider.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer; blend, boFlag: Boolean);
begin
  inherited;
  if m_boUseEffect then begin
    if EffectSurface <> nil then begin
      DrawBlend(DSurface, dx + ax + m_nShiftX, dy + ay + m_nShiftY, EffectSurface, 1);
    end;
    if EffectSurfaceEx <> nil then begin
      DrawBlend(DSurface, dx + axEx + m_nShiftX, dy + ayEx + m_nShiftY, EffectSurfaceEx, 1);
    end;
    if EffectSurfaceEx2 <> nil then begin
      DrawBlend(DSurface, dx + axEx2 + m_nShiftX, dy + ayEx2 + m_nShiftY, EffectSurfaceEx2, 1);
    end;
  end;
end;

procedure TDoubleATKSpider.LoadSurface;
begin
  inherited LoadSurface;
  m_boUseEffect := FALSE;
  EffectSurface := nil;
  EffectSurfaceEx := nil;
  if m_WMImages <> nil then begin
    if m_wAppearance = 559 then begin
      m_boUseEffect := TRUE;
      EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 580 + m_nCurrentFrame, ax, ay);
    end else
    if m_wAppearance = 549 then begin
      m_boUseEffect := TRUE;
      EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 500 + m_nCurrentFrame, ax, ay);
    end else
    if (m_wAppearance = 545) or (m_wAppearance = 546) or (m_wAppearance = 547) or (m_wAppearance = 548) then begin
      m_boUseEffect := TRUE;
      EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 420 + m_nCurrentFrame, ax, ay);
      if m_nCurrentAction = SM_LIGHTING then begin
        if m_wAppearance = 547 then begin
          EffectSurfaceEx := m_WMImages.GetCachedImage(m_nBodyOffset + 490 + m_nCurrentFrame, axEx, ayEx);
        end else
        if m_wAppearance = 548 then begin
          EffectSurfaceEx := m_WMImages.GetCachedImage(m_nBodyOffset + 500 + m_nCurrentFrame, axEx, ayEx);
        end;
      end;
    end else
    if m_wAppearance = 535 then begin
      m_boUseEffect := TRUE;
      EffectSurfaceEx := m_WMImages.GetCachedImage(m_nBodyOffset + 670 + m_nCurrentFrame, axEx, ayEx);
    end else
    if m_wAppearance = 512 then begin
      m_boUseEffect := TRUE;
      EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 420 + m_nCurrentFrame, ax, ay);
      if m_nCurrentAction = SM_LIGHTING then begin
        EffectSurfaceEx := m_WMImages.GetCachedImage(m_nBodyOffset + 590 + m_nCurrentFrame, axEx, ayEx);
      end;
    end else
    if m_wAppearance = 503 then begin
      m_boUseEffect := TRUE;
      EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 340 + m_nCurrentFrame, ax, ay);
    end else begin
      case m_nCurrentAction of
        SM_HIT: begin
            case m_wAppearance of
              241, 250, 251: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 80 + m_nCurrentFrame, ax, ay);
              end;
              500: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 190 + m_nCurrentFrame, ax, ay);
              end;
              501: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 270 + m_nCurrentFrame, ax, ay);
              end;
              506: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 440 + (m_nCurrentFrame - m_nStartFrame), ax, ay);

              end;
              511: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 180 + m_nCurrentFrame, ax, ay);
              end;
              517: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 760 + m_nCurrentFrame, ax, ay);
              end;
              518: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 280 + m_nCurrentFrame, ax, ay);
              end;
              524: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 400 + m_nCurrentFrame, ax, ay);
              end;
              525, 320: begin
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 190 + m_nCurrentFrame, ax, ay);
                m_boUseEffect := TRUE;
              end;
              561: begin
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 260 + m_nCurrentFrame, ax, ay);
                m_boUseEffect := TRUE;
              end;
              563: begin
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 270 + m_nCurrentFrame, ax, ay);
                m_boUseEffect := TRUE;
              end;
              569: begin
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 480 + m_nCurrentFrame, ax, ay);
                m_boUseEffect := TRUE;
              end;
            end;
          end;
        SM_HIT_2: begin
            case m_wAppearance of
              255: begin
                  m_boUseEffect := TRUE;
                  EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 160 + m_nCurrentFrame, ax, ay);
                end;
              517: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 320 + m_nCurrentFrame, ax, ay);
                EffectSurfaceEx := m_WMImages.GetCachedImage(m_nBodyOffset + 600 + m_nCurrentFrame, axEx, ayEx);
              end;
              557: begin
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 160 + m_nCurrentFrame, ax, ay);
                m_boUseEffect := TRUE;
              end;
            end;
          end;
        SM_HIT_3: begin
            case m_wAppearance of
              517: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 320 + m_nCurrentFrame, ax, ay);
                EffectSurfaceEx := m_WMImages.GetCachedImage(m_nBodyOffset + 1100 + (m_nCurrentFrame - m_nStartFrame), axEx, ayEx);
              end;
            end;
          end;
        SM_HIT_4: begin

          end;
        SM_HIT_5: begin
            case m_wAppearance of
              524: begin
                  m_boUseEffect := TRUE;
                  EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 270 + m_nCurrentFrame, ax, ay);
                end;
            end;
          end;
        SM_WALK, SM_RUSHKUNG, SM_BACKSTEP: begin
            case m_wAppearance of
              517: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 580 + m_nCurrentFrame, ax, ay);
              end;
            end;
          end;
        SM_LIGHTING: begin
            case m_wAppearance of
              262: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 502 + m_nCurrentFrame - m_nStartFrame, ax, ay);
              end;
              501: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 510 + (m_nCurrentFrame - m_nStartFrame), ax, ay);
              end;
              505: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 420 + (m_nCurrentFrame - m_nStartFrame), ax, ay);

              end;
              {506: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 470 + (m_nCurrentFrame - m_nStartFrame), ax, ay);
              end; }
              515: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 740 + (m_nCurrentFrame - m_nStartFrame), ax, ay);
                EffectSurfaceEx := m_WMImages.GetCachedImage(m_nBodyOffset + 160 + m_nCurrentFrame, axEx, ayEx);
                EffectSurfaceEx2 := m_WMImages.GetCachedImage(m_nBodyOffset + 770 + (m_nCurrentFrame - m_nStartFrame), axEx2, ayEx2);
              end;
              516: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 470 + (m_nCurrentFrame - m_nStartFrame), ax, ay);
              end;
              517: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 1000 + (m_nCurrentFrame - m_nStartFrame), ax, ay);
              end;
              518: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 180 + m_nCurrentFrame, ax, ay);
              end;
              524: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 710 + m_nCurrentFrame, ax, ay);
              end;
              544: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 420 + (m_nCurrentFrame - m_nStartFrame), ax, ay);
              end;
              555: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 80 + m_nCurrentFrame, ax, ay);
              end;
              563: begin
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 160 + m_nCurrentFrame, ax, ay);
                m_boUseEffect := TRUE;
              end;
              565, 566, 567: begin
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 80 + m_nCurrentFrame, ax, ay);
                m_boUseEffect := TRUE;
              end;
              569: begin
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 420 + m_nCurrentFrame, ax, ay);
                EffectSurfaceEx := m_WMImages.GetCachedImage(m_nBodyOffset + 340 + m_nCurrentFrame, axEx, ayEx);
                m_boUseEffect := TRUE;
              end;
              557: begin
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 160 + m_nCurrentFrame, ax, ay);
                m_boUseEffect := TRUE;
              end;
              558: begin
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 160 + m_nCurrentFrame, ax, ay);
                m_boUseEffect := TRUE;
              end;
            end;
          end;
        SM_RUSH: begin
            case m_wAppearance of
              568: begin
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 90 + m_nCurrentFrame, ax, ay);
                m_boUseEffect := TRUE;
              end;
            end;
          end;
       SM_NOWDEATH: begin
            case m_wAppearance of
              243: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(1605 + (m_nCurrentFrame - m_nStartFrame), ax, ay);
              end;
              500: begin
                if (m_nCurrentFrame = m_nEndFrame) then begin
                  m_BodySurface := nil;
                end else
                if (m_nCurrentFrame - m_nStartFrame) < 9 then begin
                  m_BodySurface := m_WMImages.GetCachedImage(m_nBodyOffset + 270 + m_btDir * 10 + (m_nCurrentFrame - m_nStartFrame), m_nPx, m_nPy);
                end else begin
                  m_BodySurface := m_WMImages.GetCachedImage(m_nBodyOffset + (m_nCurrentFrame - 9), m_nPx, m_nPy);
                  m_boUseEffect := TRUE;
                  EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + ((m_nCurrentFrame - m_nStartFrame) - 9 + 510), ax, ay);
                end;
              end;
              501: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 270 + m_nCurrentFrame, ax, ay);
              end;
              505: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 450 + (m_nCurrentFrame - m_nStartFrame), ax, ay);
              end;
              517: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 910 + (m_nCurrentFrame - m_nStartFrame), ax, ay);
              end;
              525, 320: begin
                if (m_nCurrentFrame - m_nStartFrame) < 9 then begin
                  EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 340 + (m_nCurrentFrame - m_nStartFrame), ax, ay);
                  m_boUseEffect := TRUE;
                end else
                  m_boUseEffect := False;
              end;
              526, 321: begin
                if (m_nCurrentFrame - m_nStartFrame) < 9 then begin
                  EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 350 + (m_nCurrentFrame - m_nStartFrame), ax, ay);
                  m_boUseEffect := TRUE;
                end else
                  m_boUseEffect := False;
              end;
              560: begin
                m_boUseEffect := TRUE;
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 440 + (m_nCurrentFrame - m_nStartFrame), ax, ay);
              end;
              561: begin
                EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 500 + (m_nCurrentFrame - m_nStartFrame), ax, ay);
                m_boUseEffect := TRUE;
              end;
            end;
          end;
      end;
    end;
    {if (not m_boReverseFrame) then
      m_BodySurface := m_WMImages.GetCachedImage(GetOffset(m_wAppearance) + m_nCurrentFrame, m_nPx, m_nPy)
    else          (m_nCurrentFrame - m_nStartFrame)
      m_BodySurface := m_WMImages.GetCachedImage(GetOffset(m_wAppearance) + m_nEndFrame - (m_nCurrentFrame - m_nStartFrame),
        m_nPx, m_nPy);

    EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 500 + m_nCurrentFrame, ax, ay);
    m_boUseEffect := TRUE;   }
  end;
end;

{ TBoxSpider }

procedure TBoxSpider.CalcActorFrame;
begin
  m_btDir := m_btDir mod 3;
  inherited CalcActorFrame;
  if (m_WMImages <> nil) and (m_Action <> nil) then begin
    (*case m_nCurrentAction of
      SM_HIT: begin
          if m_wAppearance in [241, 250, 251] then begin
            m_nStartFrame := m_Action.ActCritical.start + m_btDir * (m_Action.ActCritical.frame + m_Action.ActCritical.skip);
            m_nEndFrame := m_nStartFrame + m_Action.ActCritical.frame - 1;
            m_dwFrameTime := m_Action.ActCritical.ftime;
            m_dwStartTime := GetTickCount;
            m_dwWarModeTime := GetTickCount;
            Shift(m_btDir, 0, 0, 1);
          end;
        end;
      SM_LIGHTING: begin
          m_nStartFrame := m_Action.ActCritical.start + m_btDir * (m_Action.ActCritical.frame + m_Action.ActCritical.skip);
          m_nEndFrame := m_nStartFrame + m_Action.ActCritical.frame - 1;
          m_dwFrameTime := m_Action.ActCritical.ftime;
          m_dwStartTime := GetTickCount;
          m_dwWarModeTime := GetTickCount;
          Shift(m_btDir, 0, 0, 1);
          if m_wAppearance = 236 then begin  //À×Ñ×ÖëÍõ
            meff := TDelayNormalDrawEffect.Create(m_nTargetX, m_nTargetY, m_WMImages,
              3730, 10, 100, True, 100);
            PlayScene.m_EffectList.Add(meff);
          end;
          {meff := TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages,
            m_nBodyOffset + 1010, 10, 72, True, 100);
          PlayScene.m_EffectList.Add(meff); }
        end;
    end;  *)
  end;
end;

constructor TBoxSpider.Create;
begin
  inherited;
  EffectSurface := nil;
  m_boShowHealthBar := False;
end;

procedure TBoxSpider.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer; blend, boFlag: Boolean);
begin
  inherited;
  if m_boUseEffect then begin
    if EffectSurface <> nil then begin
      DrawBlend(DSurface, dx + ax + m_nShiftX, dy + ay + m_nShiftY, EffectSurface, 1);
    end;
  end;
end;

function TBoxSpider.GetDefaultFrame(wmode: Boolean): Integer;
begin
  m_btDir := m_btDir mod 3;
  Result := inherited GetDefaultFrame(wmode);
end;

procedure TBoxSpider.LoadSurface;
begin
  m_btDir := m_btDir mod 3;
  inherited LoadSurface;
  m_boUseEffect := FALSE;
  if m_WMImages <> nil then begin
   (* case m_nCurrentAction of
      SM_HIT: begin
          if m_wAppearance in [241, 250, 251] then begin
            m_boUseEffect := TRUE;
            EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 80 + m_nCurrentFrame, ax, ay);
          end;
        end;
      SM_LIGHTING: begin
          if m_wAppearance = 262 then begin
            m_boUseEffect := TRUE;
            EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 502 + m_nCurrentFrame - m_nStartFrame, ax, ay);
          end;
        end;
    end;
    {if (not m_boReverseFrame) then
      m_BodySurface := m_WMImages.GetCachedImage(GetOffset(m_wAppearance) + m_nCurrentFrame, m_nPx, m_nPy)
    else
      m_BodySurface := m_WMImages.GetCachedImage(GetOffset(m_wAppearance) + m_nEndFrame - (m_nCurrentFrame - m_nStartFrame),
        m_nPx, m_nPy);

    EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 500 + m_nCurrentFrame, ax, ay);
    m_boUseEffect := TRUE;   }  *)
  end;
end;

function TBoxSpider.Run(): Boolean;
begin
  m_btDir := m_btDir mod 3;
  Result := inherited Run;
end;

{ TGrassSpider }

procedure TGrassSpider.CalcActorFrame;
begin
  m_btDir := 0;
  inherited CalcActorFrame;
end;

constructor TGrassSpider.Create;
begin
  inherited;

end;

function TGrassSpider.GetDefaultFrame(wmode: Boolean): Integer;
begin
  m_btDir := 0;
  Result := inherited GetDefaultFrame(wmode);
end;

procedure TGrassSpider.LoadSurface;
begin
  m_btDir := 0;
  inherited LoadSurface;
  m_boUseEffect := FALSE;
end;

function TGrassSpider.Run: Boolean;
begin
  m_btDir := 0;
  Result := inherited Run;
end;

{ TM2N4XKingSpider }

procedure TM2N4XKingSpider.CalcActorFrame;
begin
  m_boUseMagic := FALSE;
  m_nCurrentFrame := -1;
  m_nBodyOffset := GetOffset(m_wAppearance);
  m_Action := GetRaceByPM(m_btRace, m_wAppearance);
  if m_Action = nil then Exit;
  case m_nCurrentAction of
    SM_TURN: begin
        m_nStartFrame := m_Action.ActStand.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActStand.frame - 1;
        m_dwFrameTime := m_Action.ActStand.ftime;
        m_dwStartTime := GetTickCount;
        m_nDefFrameCount := m_Action.ActStand.frame;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_HIT: begin
        m_nStartFrame := m_Action.ActAttack.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActAttack.frame - 1;
        m_dwFrameTime := m_Action.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        //WarMode := TRUE;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
        PlayScene.m_EffectList.Add(TDelayNormalDrawEffect.Create(m_nCurrX, m_nCurrY, m_WMImages, 2530, 8, 100, False, 100));
      end;
    SM_LIGHTING: begin
        m_nStartFrame := m_Action.ActCritical.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActCritical.frame - 1;
        m_dwFrameTime := m_Action.ActCritical.ftime;
        m_dwStartTime := GetTickCount;
        //WarMode := TRUE;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_STRUCK: begin
        m_nStartFrame := m_Action.ActStruck.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActStruck.frame - 1;
        m_dwFrameTime := m_Action.ActStruck.ftime; //pm.ActStruck.ftime;
        m_dwStartTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_DEATH: begin
        m_nStartFrame := m_Action.ActDie.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActDie.frame - 1;
        m_nStartFrame := m_nEndFrame; //
        m_dwFrameTime := m_Action.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_NOWDEATH: begin
        m_nStartFrame := m_Action.ActDie.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActDie.frame - 1;
        m_dwFrameTime := m_Action.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_SKELETON: begin
        m_nStartFrame := m_Action.ActDeath.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActDeath.frame - 1;
        m_dwFrameTime := m_Action.ActDeath.ftime;
        m_dwStartTime := GetTickCount;
      end;
  end;
end;

constructor TM2N4XKingSpider.Create;
begin
  inherited Create;
  EffectSurface := nil;
end;

procedure TM2N4XKingSpider.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer; blend, boFlag: Boolean);
var
  ceff: TColorEffect;
begin
  if GetTickCount - m_dwLoadSurfaceTime > 60 * 1000 then begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;

  ceff := GetDrawEffectValue;

  if m_BodySurface <> nil then begin
    DrawEffSurface(dsurface, m_BodySurface, dx + m_nPx + m_nShiftX, dy + m_nPy + m_nShiftY, blend, ceff);
  end;

  if m_boUseEffect then
    if EffectSurface <> nil then begin
      DrawBlend(dsurface, dx + ax + m_nShiftX, dy + ay + m_nShiftY, EffectSurface, 1);
    end;
end;

function TM2N4XKingSpider.GetDefaultFrame(wmode: Boolean): Integer;
var
  cf: Integer;
  pm: pTMonsterAction;
begin
  Result := 0;
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then Exit;
  m_dwDefFrameTick := pm.ActStand.ftime;
  if m_boDeath then begin
    if m_boSkeleton then Result := pm.ActDeath.start
    else Result := pm.ActDie.start + (pm.ActDie.frame - 1);
  end
  else begin
    m_nDefFrameCount := pm.ActStand.frame;
    if m_nCurrentDefFrame < 0 then cf := 0
    else if m_nCurrentDefFrame >= pm.ActStand.frame then cf := 0
    else cf := m_nCurrentDefFrame;
    Result := pm.ActStand.start + cf;
  end;
end;

procedure TM2N4XKingSpider.LoadSurface;
begin
  inherited LoadSurface;
  m_boUseEffect := FALSE;
  {case m_wAppearance of
    800: begin
        case m_nCurrentAction of
          SM_HIT: begin
              EffectSurface := g_WDragonImages.GetCachedImage(m_nBodyOffset + 80 + m_nCurrentFrame, ax, ay);
              m_boUseEffect := TRUE;
            end;
          SM_NOWDEATH: begin
              EffectSurface := g_WDragonImages.GetCachedImage(m_nBodyOffset + 10 + m_nCurrentFrame, ax, ay);
              m_boUseEffect := TRUE;
              if m_nCurrentFrame > 59 then
                m_BodySurface := nil;
            end;
          SM_DEATH: m_BodySurface := nil;
        end;
      end;
  end;     }
end;

{ T87KindSpider }

procedure T87KindSpider.CalcActorFrame;
begin
  m_boUseMagic := FALSE;
  m_nCurrentFrame := -1;
  m_nBodyOffset := GetOffset(m_wAppearance);
  m_Action := GetRaceByPM(m_btRace, m_wAppearance);
  if m_Action = nil then Exit;
  case m_nCurrentAction of
    SM_TURN: begin
        m_nStartFrame := m_Action.ActStand.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActStand.frame - 1;
        m_dwFrameTime := m_Action.ActStand.ftime;
        m_dwStartTime := GetTickCount;
        m_nDefFrameCount := m_Action.ActStand.frame;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_HIT: begin
        m_nStartFrame := m_Action.ActAttack.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActAttack.frame - 1;
        m_dwFrameTime := m_Action.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_DEATH: begin
        m_nStartFrame := m_Action.ActDie.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActDie.frame - 1;
        m_nStartFrame := m_nEndFrame; //
        m_dwFrameTime := m_Action.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_NOWDEATH: begin
        m_nStartFrame := m_Action.ActDie.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActDie.frame - 1;
        m_dwFrameTime := m_Action.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
  end;
end;

constructor T87KindSpider.Create;
begin
  inherited;
  EffectSurface := nil;
  EffectSurfaceEx := nil;
  EffectTick := GetTickCount;
  EffectIdx := 0;
  m_boOutside := True;
end;

procedure T87KindSpider.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer; blend, boFlag: Boolean);
begin
  inherited;
  if (EffectSurface <> nil) and (not m_boDeath) then begin
    DrawBlend(DSurface, dx + ax + m_nShiftX, dy + ay + m_nShiftY, EffectSurface, 1);
  end;
  if EffectSurfaceEx <> nil then begin
    DSurface.Draw(dx + axEx + m_nShiftX, dy + ayEx + m_nShiftY, EffectSurfaceEx, True);
  end;
end;

function T87KindSpider.GetDefaultFrame(wmode: Boolean): Integer;
var
  cf: Integer;
  pm: pTMonsterAction;
begin
  Result := 0; //Jacky
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then Exit;
  m_dwDefFrameTick := pm.ActStand.ftime;
  if m_boDeath then begin
    Result := pm.ActDie.start + (pm.ActDie.frame - 1);
  end
  else begin
    m_nDefFrameCount := pm.ActStand.frame;
    if m_nCurrentDefFrame < 0 then cf := 0
    else if m_nCurrentDefFrame >= pm.ActStand.frame then cf := 0
    else cf := m_nCurrentDefFrame;
    Result := pm.ActStand.start + cf;
  end;
end;

procedure T87KindSpider.LoadSurface;
begin
  inherited;
  if m_WMImages <> nil then begin
    EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 50 + EffectIdx, ax, ay);
    if m_nCurrentAction = SM_NOWDEATH then begin
      EffectSurfaceEx := m_WMImages.GetCachedImage(m_nBodyOffset + 20 + m_nCurrentFrame, axEx, ayEx);
    end else begin
      EffectSurfaceEx := m_WMImages.GetCachedImage(m_nBodyOffset + 30, axEx, ayEx);
    end;
  end;
end;

function T87KindSpider.Run: Boolean;
begin
  m_btDir := 0;
  if GetTickCount > EffectTick then begin
    EffectTick := GetTickCount + 120;
    Inc(EffectIdx);
    if EffectIdx > 5 then EffectIdx := 0;
  end;
  Result := inherited Run;
end;

{ TPillarSpider }

procedure TPillarSpider.CalcActorFrame;
begin
  m_boUseMagic := FALSE;
  m_nCurrentFrame := -1;
  m_nBodyOffset := GetOffset(m_wAppearance);
  m_Action := GetRaceByPM(m_btRace, m_wAppearance);
  if m_Action = nil then Exit;

  case m_nCurrentAction of
    SM_TURN: begin
        m_nStartFrame := m_Action.ActStand.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActStand.frame - 1;
        m_dwFrameTime := m_Action.ActStand.ftime;
        m_dwStartTime := GetTickCount;
        m_nDefFrameCount := m_Action.ActStand.frame;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_WALK, SM_RUSH, SM_RUSHKUNG, SM_BACKSTEP: begin
        m_nStartFrame := m_Action.ActStand.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActStand.frame - 1;
        m_dwFrameTime := m_Action.ActStand.ftime;
        m_dwStartTime := GetTickCount;
        m_nMaxTick := m_Action.ActStand.usetick;
        m_nCurTick := 0;
        m_nMoveStep := 1;
        Shift(m_btDir, m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
    SM_HIT: begin
        m_nStartFrame := m_Action.ActAttack.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActAttack.frame - 1;
        m_dwFrameTime := m_Action.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_STRUCK: begin
        m_nStartFrame := m_Action.ActStruck.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActStruck.frame - 1;
        m_dwFrameTime := m_dwStruckFrameTime;
        m_dwStartTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_DEATH: begin
        m_nStartFrame := m_Action.ActDie.start ;
        m_nEndFrame := m_nStartFrame + m_Action.ActDie.frame - 1;
        m_nStartFrame := m_nEndFrame; //
        m_dwFrameTime := m_Action.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_NOWDEATH: begin
        m_nStartFrame := m_Action.ActDie.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActDie.frame - 1;
        m_dwFrameTime := m_Action.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_SKELETON: begin
        m_nStartFrame := m_Action.ActDeath.start;
        m_nEndFrame := m_nStartFrame + m_Action.ActDeath.frame - 1;
        m_dwFrameTime := m_Action.ActDeath.ftime;
        m_dwStartTime := GetTickCount;
      end;
  end;

end;

constructor TPillarSpider.Create;
begin
  inherited;
  EffectSurface := nil;
end;

procedure TPillarSpider.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer; blend, boFlag: Boolean);
begin
  inherited;
  if m_boUseEffect then begin
    if EffectSurface <> nil then begin
      DrawBlend(DSurface, dx + ax + m_nShiftX, dy + ay + m_nShiftY, EffectSurface, 1);
    end;
  end;
end;

function TPillarSpider.GetDefaultFrame(wmode: Boolean): Integer;
var
  cf: Integer;
  pm: pTMonsterAction;
begin
  Result := 0; //Jacky
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then Exit;
  m_dwDefFrameTick := pm.ActStand.ftime;
  if m_boDeath then begin
    Result := pm.ActDie.start + (pm.ActDie.frame - 1);
  end
  else begin
    m_nDefFrameCount := pm.ActStand.frame;
    if m_nCurrentDefFrame < 0 then
      cf := 0
    else if m_nCurrentDefFrame >= pm.ActStand.frame then
      cf := 0
    else
      cf := m_nCurrentDefFrame;
    Result := pm.ActStand.start + cf;
  end;
end;

procedure TPillarSpider.LoadSurface;
begin
  inherited LoadSurface;
  m_boUseEffect := FALSE;
  if m_WMImages <> nil then begin
    case m_nCurrentAction of
        SM_HIT: begin
            m_boUseEffect := TRUE;
            m_BodySurface := m_WMImages.GetCachedImage(m_nBodyOffset + (m_nCurrentFrame mod 2), m_nPx, m_nPy);
            EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + m_nCurrentFrame, ax, ay);
          end;
        SM_NOWDEATH: begin
            m_boUseEffect := TRUE;
            EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + 30 + m_nCurrentFrame, ax, ay);
          end;
    end;
  end;
end;

function TPillarSpider.Run: Boolean;
begin
  m_btDir := 0;
  Result := inherited Run;
end;

end.

