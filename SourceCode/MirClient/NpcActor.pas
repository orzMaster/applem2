unit NpcActor;

interface

uses
  Windows, Classes, Graphics, SysUtils, Forms, Actor, HGE, 
  Grobal2, HGETextures, CliUtil, Wil;

type
  TQuiescenceNpcActor = class(TNpcActor)
  public
    constructor Create; override;
    function Run: Boolean; override;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
  end;

  TBaseNpcActor = class(TNpcActor)
  public
    constructor Create; override;
    function Run: Boolean; override;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
  end;

  TTreeNpcActor = class(TBaseNpcActor)
  public
    constructor Create; override;
    function Run: Boolean; override;
  end;

  TDynamicTreeNpcActor = class(TNpcActor)
    boblend: Boolean;
  public
    constructor Create; override;
    function Run: Boolean; override;
    function GetDefaultFrame(wmode: Boolean): Integer; override;
    procedure CalcActorFrame; override;
    procedure LoadSurface; override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: Integer; blend: Boolean; boFlag: Boolean); override;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: Integer); override;
  end;

  TDynamicTree2NpcActor = class(TDynamicTreeNpcActor)
  public
    procedure LoadSurface; override;
  end;

  TFlyDynamicNpcActor = class(TDynamicTreeNpcActor)
  public
    constructor Create; override;
    procedure LoadSurface; override;
  end;

  TMachineryNpcActor = class(TDynamicTreeNpcActor)
  public
    procedure LoadSurface; override;
  end;

  TStatuaryNpcActor = class(TBaseNpcActor)
    m_StatuarySurface: TDirectDrawSurface;
    m_StatuaryEffectSurface: TDirectDrawSurface;
    m_boShowStatuary: Boolean;
    m_nEffectx, m_nEffecty: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadSurface; override;
    procedure SetEffigyState(nEffigyState, nOffset: Integer); override;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: Integer; blend: Boolean; boFlag: Boolean); override;
  end;

  T2NpcActor = class(TBaseNpcActor)
  public
    function GetDefaultFrame(wmode: Boolean): Integer; override;
    procedure LoadSurface; override;
  end;

  TSnowmanNpcActor = class(TNpcActor)
  private
    m_dwEffectTick: LongWord;
    m_nEffectIndex: Integer;
  public
    constructor Create; override;
    function Run: Boolean; override;
    procedure LoadSurface; override;
  end;

  TFixedNpcActor = class(TNpcActor)
  public
    constructor Create; override;
    function Run: Boolean; override;
    procedure LoadSurface; override;
  end;

  TBoxNpcActor = class(TNpcActor)
  public
    constructor Create; override;
    function Run: Boolean; override;
    procedure LoadSurface; override;
  end;

  THeroNpcActor = class(TNpcActor)
  public
    constructor Create; override;
    function Run: Boolean; override;
  end;

  TDynamicBoxNpcActor = class(TNpcActor)
  private
    m_boBoxState: Byte;
    m_boRunEffect: Boolean;
    m_nEffectIndex: Integer;
    m_dwEffectTick: LongWord;
  public
    constructor Create; override;
    function Run: Boolean; override;
    procedure LoadSurface; override;
    procedure Click(); override;
  end;

  TTavernNpcActor = class(TNpcActor)
  private
    m_boRunEffect: Boolean;
    m_nEffectIndex: Integer;
    m_dwEffectTick: LongWord;
    m_btEffectType: Byte;
  public
    constructor Create; override;
    function Run: Boolean; override;
    procedure LoadSurface; override;
    procedure CalcActorFrame; override;
    procedure Click(); override;
  end;
implementation

uses
  MShare, WMFile, HGEBase;

{ TBaseNpcActor }

procedure TQuiescenceNpcActor.CalcActorFrame;
begin
  m_nBodyOffset := GetNpcOffset(m_wAppearance);
  m_nCurrentAction := 0;
end;

constructor TQuiescenceNpcActor.Create;
begin
  inherited Create;
end;

function TQuiescenceNpcActor.GetDefaultFrame(wmode: Boolean): Integer;
var
  cf: Integer;
  pm: pTMonsterAction;
begin
  Result := 0; //Jacky
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then Exit;
  m_dwDefFrameTick := pm.ActStand.ftime;
  m_nDefFrameCount := pm.ActStand.frame;
  if m_nCurrentDefFrame < 0 then cf := 0
  else if m_nCurrentDefFrame >= pm.ActStand.frame then cf := 0
  else cf := m_nCurrentDefFrame;
  Result := pm.ActStand.start + cf
end;

procedure TQuiescenceNpcActor.LoadSurface;
begin
  inherited LoadSurface;
  m_EffSurface := GetNpcImg(m_nBodyOffset + m_nEffectFrame + 12, m_nEffX, m_nEffY);
end;

function TQuiescenceNpcActor.Run: Boolean;
begin
  Result := inherited Run;
  m_btDir := 0;
  m_boUseEffect := True;
end;

{ TBaseNpcActor }

procedure TBaseNpcActor.CalcActorFrame;
begin
  m_nBodyOffset := GetNpcOffset(m_wAppearance);
  m_nCurrentAction := 0;
end;

constructor TBaseNpcActor.Create;
begin
  inherited;

end;

function TBaseNpcActor.GetDefaultFrame(wmode: Boolean): Integer;
var
  cf: Integer;
  pm: pTMonsterAction;
begin
  Result := 0; //Jacky
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then Exit;
  if m_boCanModDir then m_btDir := m_btDir mod 3;
  m_dwDefFrameTick := pm.ActStand.ftime;
  m_nDefFrameCount := pm.ActStand.frame;
  if m_nCurrentDefFrame < 0 then cf := 0
  else if m_nCurrentDefFrame >= pm.ActStand.frame then cf := 0
  else cf := m_nCurrentDefFrame;
  Result := pm.ActStand.start + m_btDir * (pm.ActStand.frame + pm.ActStand.skip) + cf
end;

procedure TBaseNpcActor.LoadSurface;
begin
  inherited LoadSurface;
  if m_wAppearance = 94 then begin
    m_boUseEffect := True;
    m_EffSurface := GetNpcImg(m_nBodyOffset + 4 + m_nCurrentFrame, m_nEffX, m_nEffY);
  end;
end;

function TBaseNpcActor.Run: Boolean;
begin
  Result := inherited Run;
end;

{ TTreeNpcActor }

constructor TTreeNpcActor.Create;
begin
  inherited;

end;

function TTreeNpcActor.Run: Boolean;
begin
  m_btDir := 0;
  Result := inherited Run;
end;

{ TDynamicTreeNpcActor }

procedure TDynamicTreeNpcActor.CalcActorFrame;
begin
  m_nBodyOffset := GetNpcOffset(m_wAppearance);
  m_nCurrentAction := 0;
end;

constructor TDynamicTreeNpcActor.Create;
begin
  inherited;
  m_boShowHealthBar := False;
end;

procedure TDynamicTreeNpcActor.DrawChr(dsurface: TDirectDrawSurface; dx, dy: Integer; blend, boFlag: Boolean);
begin
  if m_boCanModDir then m_btDir := m_btDir mod 3;
  boblend := blend;
  if GetTickCount - m_dwLoadSurfaceTime > 60 * 1000 then begin
    m_dwLoadSurfaceTime := GetTickCount;
    LoadSurface;
  end;
  if m_BodySurface <> nil then begin
    DrawEffSurface(dsurface,
      m_BodySurface,
      dx + m_nPx + m_nShiftX,
      dy + m_nPy + m_nShiftY,
      blend,
      GetDrawEffectValue);
  end;
end;

procedure TDynamicTreeNpcActor.DrawEff(dsurface: TDirectDrawSurface; dx, dy: Integer);
begin
  if m_boUseEffect and (m_EffSurface <> nil) then begin
    if m_wAppearance in [82, 160, 167, 168] then
      DrawEffSurface(dsurface,
        m_EffSurface,
        dx + m_nEffX + m_nShiftX,
        dy + m_nEffY + m_nShiftY,
        boblend,
        ceNone, 1)
    else
      DrawEffSurface(dsurface,
        m_EffSurface,
        dx + m_nEffX + m_nShiftX,
        dy + m_nEffY + m_nShiftY,
        boblend,
        GetDrawEffectValue);
  end;
end;

function TDynamicTreeNpcActor.GetDefaultFrame(wmode: Boolean): Integer;
var
  cf: Integer;
  pm: pTMonsterAction;
begin
  Result := 0; //Jacky
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then Exit;
  m_dwDefFrameTick := pm.ActStand.ftime;
  m_nDefFrameCount := pm.ActStand.frame;
  if m_nCurrentDefFrame < 0 then cf := 0
  else if m_nCurrentDefFrame >= pm.ActStand.frame then cf := 0
  else cf := m_nCurrentDefFrame;
  Result := pm.ActStand.start + cf
end;

procedure TDynamicTreeNpcActor.LoadSurface;
begin
  m_BodySurface := GetNpcImg(m_nBodyOffset, m_nPx, m_nPy);
  if m_wAppearance in [167, 168] then
    m_EffSurface := GetNpcImg(m_nBodyOffset + m_nCurrentFrame + 10, m_nEffX, m_nEffY)
  else
    m_EffSurface := GetNpcImg(m_nBodyOffset + m_nCurrentFrame + 1, m_nEffX, m_nEffY);
end;

function TDynamicTreeNpcActor.Run: Boolean;
begin
  Result := inherited Run;
  m_btDir := 0;
  m_boUseEffect := True;
end;

{ TFlyDynamicNpcActor }

constructor TFlyDynamicNpcActor.Create;
begin
  inherited;
  
end;

procedure TFlyDynamicNpcActor.LoadSurface;
begin
  m_BodySurface := GetNpcImg(m_nBodyOffset + m_nCurrentFrame, m_nPx, m_nPy);
  m_EffSurface := GetNpcImg(m_nBodyOffset + m_nCurrentFrame + 12, m_nEffX, m_nEffY);
end;

{ TMachineryNpcActor }

procedure TMachineryNpcActor.LoadSurface;
begin
  m_BodySurface := GetNpcImg(m_nBodyOffset + m_nCurrentFrame, m_nPx, m_nPy);
  m_EffSurface := nil;
end;

{ TStatuaryNpcActor }

constructor TStatuaryNpcActor.Create;
begin
  inherited;
  m_boShowStatuary := False;
  m_StatuarySurface := nil;
  m_StatuaryEffectSurface := nil;
end;

destructor TStatuaryNpcActor.Destroy;
begin
  if m_StatuarySurface <> nil then m_StatuarySurface.Free;
  if m_StatuaryEffectSurface <> nil then m_StatuaryEffectSurface.Free;
  inherited;
end;

procedure TStatuaryNpcActor.DrawChr(dsurface: TDirectDrawSurface; dx, dy: Integer; blend, boFlag: Boolean);
var
  Rect: TRect;
begin
  inherited;
  if m_boShowStatuary and (m_StatuarySurface <> nil) then begin
    if m_StatuaryEffectSurface <> nil then begin
      Rect := m_StatuaryEffectSurface.ClientRect;
      Rect.Left := dx + m_nEffectx - 10;
      Rect.Top := dy + m_nEffecty - 60;
      Rect.Right := Round(Rect.Right * 1.2) + Rect.Left;
      Rect.Bottom := Round(Rect.Bottom * 1.2) + Rect.Top;
      dsurface.StretchDraw(Rect, m_StatuaryEffectSurface.ClientRect, m_StatuaryEffectSurface, fxAnti);
    end;
    Rect := m_StatuarySurface.ClientRect;
    Rect.Left := dx - 105;
    Rect.Top := dy - 170;
    Rect.Right := Round(Rect.Right * 1.2) + Rect.Left;
    Rect.Bottom := Round(Rect.Bottom * 1.2) + Rect.Top;
    dsurface.StretchDraw(Rect, m_StatuarySurface.ClientRect, m_StatuarySurface, True);
  end;
end;

procedure TStatuaryNpcActor.LoadSurface;
begin
  m_EffSurface := nil;
  m_boUseEffect := False;
  m_BodySurface := GetNpcImg(m_nBodyOffset, m_nPx, m_nPy);
end;

procedure TStatuaryNpcActor.SetEffigyState(nEffigyState, nOffset: Integer);
var
  nHpx, nHpy: Integer;
  d: TDirectDrawSurface;
  nHair, nDress, nWeapon, nEffect: Integer;
begin
  if nEffigyState = -1 then begin
    m_boShowStatuary := False;
    if m_StatuarySurface <> nil then m_StatuarySurface.Free;
    if m_StatuaryEffectSurface <> nil then m_StatuaryEffectSurface.Free;
    m_StatuarySurface := nil;
    m_StatuaryEffectSurface := nil;
  end else begin
    if m_StatuarySurface = nil then m_StatuarySurface := MakeDXImageTexture(200, 200, WILFMT_A4R4G4B4);
    m_StatuarySurface.Clear;
    nHair := HUMHAIRANFRAME * HAIRfeature(nEffigyState);
    nDress := DRESSfeature(nEffigyState);
    nWeapon := WEAPONfeature(nEffigyState);
    nEffect := RACEfeature(nEffigyState);
    if nEffect > 0 then begin
      d := GetWHumWinImage((nEffect - 1) * HUMANFRAME + nOffset, m_nEffectx, m_nEffecty);
      if (d <> nil) and (d.Width > 16) and (d.Height > 16) then begin
        if (m_StatuaryEffectSurface <> nil) and (m_StatuaryEffectSurface.Width >= d.Width) and (m_StatuaryEffectSurface.Height >= d.Height) then begin
          m_StatuaryEffectSurface.Clear;
        end else begin
          m_StatuaryEffectSurface.Free;
          m_StatuaryEffectSurface := MakeDXImageTexture(d.Width, d.Height, WILFMT_A4R4G4B4);
        end;
        CopyByGrayScale(d, m_StatuaryEffectSurface, 0, 0);
        m_boShowStatuary := True;
      end else begin
        if m_StatuaryEffectSurface <> nil then m_StatuaryEffectSurface.Free;
        m_StatuaryEffectSurface := nil;
      end;
    end else begin
      if m_StatuaryEffectSurface <> nil then m_StatuaryEffectSurface.Free;
      m_StatuaryEffectSurface := nil;
    end;

    d := GetWWeaponImg(nWeapon, 0, nOffset, nHpx, nHpy);
    if d <> nil then begin
      CopyByGrayScale(d, m_StatuarySurface, 80 + nHpx, 110 + nHpy);
      m_boShowStatuary := True;
    end;

    d := GetWHumImg(nDress, 0, nOffset, nHpx, nHpy);
    if d <> nil then begin
      CopyByGrayScale(d, m_StatuarySurface, 80 + nHpx, 110 + nHpy);
      m_boShowStatuary := True;
    end;

    d := g_WHairImgImages.GetCachedImage(nHair + nOffset, nHpx, nHpy);
    if d <> nil then begin
      CopyByGrayScale(d, m_StatuarySurface, 80 + nHpx, 110 + nHpy);
      m_boShowStatuary := True;
    end;
  end;

end;

{ T2NpcActor }

function T2NpcActor.GetDefaultFrame(wmode: Boolean): Integer;
var
  cf: Integer;
  pm: pTMonsterAction;
begin
  Result := 0; //Jacky
  pm := GetRaceByPM(m_btRace, m_wAppearance);
  if pm = nil then Exit;
  m_btDir := 0;
  m_dwDefFrameTick := pm.ActStand.ftime;
  m_nDefFrameCount := pm.ActStand.frame;
  if m_nCurrentDefFrame < 0 then cf := 0
  else if m_nCurrentDefFrame >= pm.ActStand.frame then cf := 0
  else cf := m_nCurrentDefFrame;
  Result := pm.ActStand.start + pm.ActStand.frame + pm.ActStand.skip + cf
end;

procedure T2NpcActor.LoadSurface;
begin
  //inherited;
  m_BodySurface := GetNpcImg(m_nBodyOffset{ + m_nCurrentFrame}, m_nPx, m_nPy);
end;

{ TDynamicTree2NpcActor }

procedure TDynamicTree2NpcActor.LoadSurface;
begin
  m_BodySurface := GetNpcImg(m_nBodyOffset + m_nCurrentFrame, m_nPx, m_nPy);
  m_EffSurface := GetNpcImg(m_nBodyOffset + m_nCurrentFrame + 20, m_nEffX, m_nEffY);
end;

{ TSnowmanNpcActou }

constructor TSnowmanNpcActor.Create;
begin
  inherited Create;
  m_dwEffectTick := GetTickCount;
  m_nEffectIndex := 0;
end;

procedure TSnowmanNpcActor.LoadSurface;
begin
  if m_wAppearance = 78 then begin
    m_BodySurface := GetNpcImg(m_nBodyOffset, m_nPx, m_nPy);
    m_boUseEffect := True;
    m_EffSurface := GetNpcImg(m_nBodyOffset + 10 + m_nEffectIndex, m_nEffX, m_nEffY);
  end else begin
    inherited LoadSurface;
    m_boUseEffect := True;
    m_EffSurface := GetNpcImg(m_nBodyOffset + 60 + m_nEffectIndex, m_nEffX, m_nEffY);
  end;
end;

function TSnowmanNpcActor.Run: Boolean;
begin
  if GetTickCount > m_dwEffectTick then begin
    m_dwEffectTick := GetTickCount + 150;
    Inc(m_nEffectIndex);
    if m_nEffectIndex > 11 then m_nEffectIndex := 0;
    
  end;
  Result := inherited Run;
end;

{ TFixedNpcActor }

constructor TFixedNpcActor.Create;
begin
  inherited;
  m_boCanAnimation := False;
  m_boCanChangeDir := False;
  m_boCanModDir := False;
  m_boShowHealthBar := False;
end;

procedure TFixedNpcActor.LoadSurface;
begin
  if m_wAppearance in [80, 81, 96] then m_BodySurface := GetNpcImg(m_nBodyOffset + m_btDir * 10, m_nPx, m_nPy)
  else m_BodySurface := GetNpcImg(m_nBodyOffset + m_btDir, m_nPx, m_nPy);
end;

function TFixedNpcActor.Run: Boolean;
begin
  Result := inherited Run;
end;

{ TBoxNpcActor }

constructor TBoxNpcActor.Create;
begin
  inherited;
  m_boCanAnimation := False;
  m_boCanChangeDir := False;
  m_boCanModDir := False;
end;

procedure TBoxNpcActor.LoadSurface;
begin
  m_boUseEffect := False;
  m_BodySurface := GetNpcImg(m_nBodyOffset + m_nCurrentFrame, m_nPx, m_nPy);
  case m_wAppearance of
    {58: begin
        m_boUseEffect := True;
        m_EffSurface := GetNpcImg(m_nBodyOffset + m_nCurrentFrame + 420, m_nEffX, m_nEffY);
      end;
    59: begin
        m_boUseEffect := True;
        m_EffSurface := GetNpcImg(m_nBodyOffset + m_nCurrentFrame + 360, m_nEffX, m_nEffY);
      end; }
    60: begin
        m_boUseEffect := True;
        m_EffSurface := GetNpcImg(m_nBodyOffset + m_nCurrentFrame + 120, m_nEffX, m_nEffY);
      end;
    61: begin
        m_boUseEffect := True;
        m_EffSurface := GetNpcImg(m_nBodyOffset + m_nCurrentFrame + 240, m_nEffX, m_nEffY);
      end;
    62: begin
        m_boUseEffect := True;
        m_EffSurface := GetNpcImg(m_nBodyOffset + m_nCurrentFrame + 60, m_nEffX, m_nEffY);
      end;
    63: begin
        m_boUseEffect := True;
        m_EffSurface := GetNpcImg(m_nBodyOffset + m_nCurrentFrame + 4, m_nEffX, m_nEffY);
      end;
    64: begin
        m_boUseEffect := True;
        m_EffSurface := GetNpcImg(m_nBodyOffset + m_nCurrentFrame + 4, m_nEffX, m_nEffY);
      end;
  end;
end;

function TBoxNpcActor.Run: Boolean;
begin
  if m_wAppearance = 74 then m_btDir := 0;
  
  Result := inherited Run;
end;

{ THeroNpcActor }

constructor THeroNpcActor.Create;
begin
  inherited;
  m_boCanChangeDir := False;
  m_boCanModDir := False;
end;

function THeroNpcActor.Run: Boolean;
begin
  m_btDir := 0;
  Result := inherited Run;
end;

{ TDynamicBoxNpcActor }

procedure TDynamicBoxNpcActor.Click;
begin
  if not m_boRunEffect then begin
    case m_boBoxState of
      0: begin
          m_boRunEffect := True;
          m_nEffectIndex := 0;
          m_dwEffectTick := GetTickCount + 100;
        end;
    end;
  end;
end;

constructor TDynamicBoxNpcActor.Create;
begin
  inherited;
  m_boCanAnimation := False;
  m_boCanChangeDir := False;
  m_boCanModDir := False;
  m_boBoxState := 0;
  m_boRunEffect := False;
  m_nEffectIndex := 0;
  m_dwEffectTick := GetTickCount;
end;

procedure TDynamicBoxNpcActor.LoadSurface;
begin
  if not m_boRunEffect then begin
    m_boUseEffect := False;
    m_BodySurface := GetNpcImg(m_nBodyOffset +  m_nCurrentFrame, m_nPx, m_nPy);
  end else begin
    m_boUseEffect := True;
    if m_boBoxState = 0 then begin
      m_BodySurface := GetNpcImg(m_nBodyOffset + 4 + m_nEffectIndex, m_nPx, m_nPy);
      m_EffSurface := GetNpcImg(m_nBodyOffset + 14 + m_nEffectIndex, m_nEffX, m_nEffY);
    end else
    if m_boBoxState = 1 then begin
      m_BodySurface := GetNpcImg(m_nBodyOffset + 22, m_nPx, m_nPy);
      m_EffSurface := GetNpcImg(m_nBodyOffset + 21, m_nEffX, m_nEffY);
    end else
    if m_boBoxState = 2 then begin
      m_BodySurface := GetNpcImg(m_nBodyOffset + 22 + m_nEffectIndex, m_nPx, m_nPy);
      m_EffSurface := GetNpcImg(m_nBodyOffset + 14 + (7 - m_nEffectIndex), m_nEffX, m_nEffY);
    end;
  end;
end;

function TDynamicBoxNpcActor.Run: Boolean;
begin
  m_btDir := 0;
  if m_boRunEffect then begin
    if m_boBoxState = 0 then begin
      if GetTickCount > m_dwEffectTick then begin
        m_dwEffectTick := GetTickCount + 100;
        if m_nEffectIndex < 6 then Inc(m_nEffectIndex)
        else begin
          m_boBoxState := 1;
          m_dwEffectTick := GetTickCount + 900;
        end;
      end;
    end else
    if m_boBoxState = 1 then begin
      if GetTickCount > m_dwEffectTick then begin
        m_dwEffectTick := GetTickCount + 100;
        m_boBoxState := 2;
        m_nEffectIndex := 0;
      end;
    end else
    if m_boBoxState = 2 then begin
      if GetTickCount > m_dwEffectTick then begin
        m_dwEffectTick := GetTickCount + 100;
        if m_nEffectIndex < 7 then Inc(m_nEffectIndex)
        else begin
          m_boBoxState := 0;
          m_boRunEffect := False;
        end;
      end;
    end;
  end;
  Result := inherited Run;
end;

{ TTavernNpcActor }

procedure TTavernNpcActor.CalcActorFrame;
begin
  inherited CalcActorFrame;
  if m_nCurrentAction = SM_DIGUP then begin
    if not m_boRunEffect then begin
      m_boRunEffect := True;
      m_nEffectIndex := 0;
      m_btEffectType := Random(2);
      m_dwEffectTick := GetTickCount + 150;
    end;
  end;
end;

procedure TTavernNpcActor.Click;
begin
  SendMsg(SM_DIGUP, m_nCurrX, m_nCurrY, m_btDir, m_nFeature, m_nState, '', 0);
end;

constructor TTavernNpcActor.Create;
begin
  inherited;
  m_boRunEffect := False;
  m_nEffectIndex := 0;
  m_dwEffectTick := GetTickCount;
end;

procedure TTavernNpcActor.LoadSurface;
begin
  if m_boRunEffect then begin
    m_boUseEffect := True;
    m_BodySurface := GetNpcImg(4250 + m_nEffectIndex, m_nPx, m_nPy);
    if m_btEffectType = 0 then m_EffSurface := GetNpcImg(4250 + m_nEffectIndex + 80, m_nEffX, m_nEffY)
    else m_EffSurface := GetNpcImg(4250 + m_nEffectIndex + 160, m_nEffX, m_nEffY);
  end else
    inherited LoadSurface;
end;

function TTavernNpcActor.Run: Boolean;
begin
  if m_boRunEffect then begin
    if GetTickCount > m_dwEffectTick then begin
      m_dwEffectTick := GetTickCount + 150;
      if m_nEffectIndex < 79 then Inc(m_nEffectIndex)
      else begin
        m_boRunEffect := False;
      end;
    end;
  end;
  Result := inherited Run;
end;

end.
