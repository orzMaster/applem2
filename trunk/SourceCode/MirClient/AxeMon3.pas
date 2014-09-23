unit AxeMon3;

interface
uses
  Windows, Classes, 
  Grobal2, HGETextures, CliUtil, ClFunc, Actor;

type
  TMagicMonSpider = class(TActor) //Size:25C
  private
    m_nEffectFrame: Integer;
    m_nEffectEnd: Integer;
    m_nEffectStart: Integer;
  protected
    EffectSurface: TDirectDrawSurface; //0x240
    ax: Integer; //0x244
    ay: integer; //0x248
  public
    constructor Create; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    function Run: Boolean; override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer; blend: Boolean; boFlag: Boolean); override;
  end;

implementation

uses
  WIL;

{ TMagicMonSpider }

procedure TMagicMonSpider.CalcActorFrame;
var
  pm: PTMonsterAction;
begin
  m_nCurrentFrame := -1;
  m_boReverseFrame := FALSE;
  m_boUseEffect := FALSE;
  m_nEffectFrame := 0;

  m_nBodyOffset := GetOffset(m_wAppearance);
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then
    exit;

  case m_nCurrentAction of
    SM_TURN: begin
        m_nStartFrame := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip);
        m_nEndFrame := m_nStartFrame + pm.ActStand.frame - 1;
        m_dwFrameTime := pm.ActStand.ftime;
        m_dwStartTime := GetTickCount;
        m_nDefFrameCount := pm.ActStand.frame;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_WALK, SM_BACKSTEP: begin
        m_nStartFrame := pm.ActWalk.start + m_btDir * (pm.ActWalk.frame + pm.ActWalk.skip);
        m_nEndFrame := m_nStartFrame + pm.ActWalk.frame - 1;
        m_dwFrameTime := pm.ActWalk.ftime;
        m_dwStartTime := GetTickCount;
        m_nMaxTick := pm.ActWalk.UseTick;
        m_nCurTick := 0;
        m_nMoveStep := 1;
        if m_nCurrentAction = SM_WALK then
          Shift(m_btDir, m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1)
        else
          Shift(GetBack(m_btDir), m_nMoveStep, 0, m_nEndFrame - m_nStartFrame + 1);
      end;
    SM_HIT: begin
        m_nStartFrame := pm.ActAttack.start + m_btDir * (pm.ActAttack.frame + pm.ActAttack.skip);
        m_nEndFrame := m_nStartFrame + pm.ActAttack.frame - 1;
        m_dwFrameTime := pm.ActAttack.ftime;
        m_dwStartTime := GetTickCount;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
        case m_wAppearance of
          223, 231: begin
              m_boUseEffect := True;
              m_nEffectStart := m_nStartFrame + 80;
              m_nEffectEnd := m_nEffectStart + 10;
            end;
        end;
      end;
    SM_LIGHTING: begin
        m_nStartFrame := pm.ActCritical.start + m_btDir * (pm.ActCritical.frame + pm.ActCritical.skip);
        m_nEndFrame := m_nStartFrame + pm.ActCritical.frame - 1;
        m_dwFrameTime := pm.ActCritical.ftime;
        m_dwStartTime := GetTickCount;
        m_dwWarModeTime := GetTickCount;
        Shift(m_btDir, 0, 0, 1);
      end;
    SM_STRUCK: begin
        m_nStartFrame := pm.ActStruck.start + m_btDir * (pm.ActStruck.frame + pm.ActStruck.skip);
        m_nEndFrame := m_nStartFrame + pm.ActStruck.frame - 1;
        m_dwFrameTime := m_dwStruckFrameTime; //pm.ActStruck.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_DEATH: begin
        m_nStartFrame := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip);
        m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
        m_nStartFrame := m_nEndFrame; //
        m_dwFrameTime := pm.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_NOWDEATH: begin
        m_nStartFrame := pm.ActDie.start + m_btDir * (pm.ActDie.frame + pm.ActDie.skip);
        m_nEndFrame := m_nStartFrame + pm.ActDie.frame - 1;
        m_dwFrameTime := pm.ActDie.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_SKELETON: begin
        m_nStartFrame := pm.ActDeath.start;
        m_nEndFrame := m_nStartFrame + pm.ActDeath.frame - 1;
        m_dwFrameTime := pm.ActDeath.ftime;
        m_dwStartTime := GetTickCount;
      end;
    SM_ALIVE: begin
        m_nStartFrame := pm.ActDeath.start + m_btDir * (pm.ActDeath.frame + pm.ActDeath.skip);
        m_nEndFrame := m_nStartFrame + pm.ActDeath.frame - 1;
        m_dwFrameTime := pm.ActDeath.ftime;
        m_dwStartTime := GetTickCount;
      end;
  end;
end;

constructor TMagicMonSpider.Create;
begin
  inherited;
  EffectSurface := nil;
  m_nEffectFrame := 0;
  m_nEffectEnd := 0;
  m_nEffectStart := 0;
  m_boUseEffect := FALSE;
end;

procedure TMagicMonSpider.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer; blend, boFlag: Boolean);
var
  ceff: TColorEffect;
begin
  if not (m_btDir in [0..7]) then exit;
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

procedure TMagicMonSpider.LoadSurface;
begin
  inherited;
  if m_boUseEffect then begin
    if (m_WMImages <> nil) then begin
      EffectSurface := m_WMImages.GetCachedImage(m_nBodyOffset + m_nEffectStart + m_nEffectFrame, ax, ay);
    end;
  end;
end;

function TMagicMonSpider.Run: Boolean;
var
  prv: integer;
  m_dwFrameTimetime: longword;
begin
  Result := False;
  if (m_nCurrentAction = SM_WALK) or (m_nCurrentAction = SM_BACKSTEP) or
    (m_nCurrentAction = SM_RUN) or (m_nCurrentAction = SM_HORSERUN) then
    exit;

  m_boMsgMuch := FALSE;
  if m_MsgList.Count >= 2 then
    m_boMsgMuch := TRUE;

  RunActSound(m_nCurrentFrame - m_nStartFrame);
  RunFrameAction(m_nCurrentFrame - m_nStartFrame);

  prv := m_nCurrentFrame;
  if m_nCurrentAction <> 0 then begin
    if (m_nCurrentFrame < m_nStartFrame) or (m_nCurrentFrame > m_nEndFrame) then
      m_nCurrentFrame := m_nStartFrame;

    if m_boMsgMuch then
      m_dwFrameTimetime := Round(m_dwFrameTime * 2 / 3)
    else
      m_dwFrameTimetime := m_dwFrameTime;

    if GetTickCount - m_dwStartTime > m_dwFrameTimetime then begin
      if m_nCurrentFrame < m_nEndFrame then begin
        Inc(m_nCurrentFrame);
        Inc(m_nEffectFrame);
        m_dwStartTime := GetTickCount;
      end
      else begin
        if m_boUseEffect then begin
          if (m_nEffectStart + m_nEffectFrame) < m_nEffectEnd then begin
            Inc(m_nEffectFrame);
            prv := 0;
            m_dwStartTime := GetTickCount;
          end else begin
            m_nCurrentAction := 0;
            m_boUseEffect := FALSE;
          end;
        end else begin
          m_nCurrentAction := 0;
          m_boUseEffect := FALSE;
        end;
      end;
    end;
    m_nCurrentDefFrame := 0;
    m_dwDefFrameTime := GetTickCount;
  end
  else begin
    if GetTickCount - m_dwSmoothMoveTime > 200 then begin
      if GetTickCount - m_dwDefFrameTime > 500 then begin
        m_dwDefFrameTime := GetTickCount;
        Inc(m_nCurrentDefFrame);
        if m_nCurrentDefFrame >= m_nDefFrameCount then
          m_nCurrentDefFrame := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> m_nCurrentFrame then begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
    Result := True;
  end;
end;

end.

