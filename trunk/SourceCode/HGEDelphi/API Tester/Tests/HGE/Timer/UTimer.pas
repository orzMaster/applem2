unit UTimer;

interface

implementation

uses
  SysUtils, HGE, HGEFont, HGESprite, UTestBase;

var
  Texture: ITexture;
  MainSprite: IHGESprite;
  X, Y, DX, DY: Single;

function FrameFunc: Boolean;
var
  DT: Single;
begin
  DT := Engine.Timer_GetDelta;

  X := X + (DX * DT);
  if (X < 16) or (X > 784) then begin
    DX := -DX;
    X := X + (DX * DT * 2);
  end;

  Y := Y + (DY * DT);
  if (Y < 16) or (Y > 584) then begin
    DY := -DY;
    Y := Y + (DY * DT * 2);
  end;

  Result := False;
end;

function RenderFunc: Boolean;
begin
  Engine.Gfx_BeginScene();
  Engine.Gfx_Clear(0);
  MainSprite.Render(X,Y);
  SmallFont.PrintF(5,5,HGETEXT_LEFT,
    'Time_GetTime: %.3f'#13+
    'Time_GetDelta: %.4f'#13+
    'Time_GetFPS: %d',
    [Engine.Timer_GetTime,Engine.Timer_GetDelta,Engine.Timer_GetFPS]);
  Engine.Gfx_EndScene();

  Result := False;
end;

procedure Test;
begin
  Engine.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,RenderFunc);

  X := 20; Y := 20; DX := 400; DY := 500;

  Texture := Engine.Texture_Load('particles.png');

  MainSprite := THGESprite.Create(Texture,96,64,32,32);
  MainSprite.SetColor($FFFFA000);
  MainSprite.SetHotSpot(16,16);

  while Running do ;
  
  MainSprite := nil;
  Texture := nil;
  Engine.System_SetState(HGE_FRAMEFUNC,DefaultFrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,nil);
end;

initialization
  RegisterTest('Timer Functions','HGE\Timer\UTimer',Test,[toManualGfx]);

end.
