unit UFont;

interface

implementation

uses
  HGE, HGEFont, UTestBase;

var
  Font1, Font2: IHGEFont;
  FontScale, FontScaleFactor, FontRotation: Single;
  FontTracking, FontTrackingDelta: Single;

function FrameFunc: Boolean;
var
  Delta: Single;
begin
  Delta := Engine.Timer_GetDelta;

  FontScale := FontScale * (1 + (FontScaleFactor * Delta));
  if (FontScale > 2) or (FontScale < 0.5) then
    FontScaleFactor := -FontScaleFactor;

  FontRotation := FontRotation + Delta * 2;

  FontTracking := FontTracking + (FontTrackingDelta * Delta);
  if (FontTracking > 5) or (FontTracking < -5) then
    FontTrackingDelta := -FontTrackingDelta;

  Result := False;
end;

function RenderFunc: Boolean;
begin
  Engine.Gfx_BeginScene;
  Engine.Gfx_Clear(0);

  Font1.SetColor($FFFFFFFF);
  Font1.Render(10,10,HGETEXT_LEFT,'Font 1');

  Font1.SetColor($FFFFFF00);
  Font1.Render(400,10,HGETEXT_LEFT,'Yellow font');
  Font1.SetColor($FFFFFFFF);

  Font1.SetScale(FontScale);
  Font1.Render(10,50,HGETEXT_LEFT,'Scaled font');
  Font1.SetScale(1);

  Font1.SetProportion(FontScale);
  Font1.Render(400,50,HGETEXT_LEFT,'Proportioned font');
  Font1.SetProportion(1);

  Font1.SetRotation(FontRotation);
  Font1.Render(20,120,HGETEXT_LEFT,'Rotated font');
  Font1.SetRotation(0);

  Font1.SetTracking(FontTracking);
  Font1.Render(400,120,HGETEXT_LEFT,'Font tracking');
  Font1.SetTracking(0);

  Font1.SetSpacing(FontScale);
  Font1.Render(10,150,HGETEXT_LEFT,'Font spacing'#13'Line 2');
  Font1.SetSpacing(1);

  Font2.Render(10,250,HGETEXT_LEFT,'Font 2');
  Font2.PrintF(10,270,HGETEXT_LEFT,'Height Font 1: %f, Height Font 2: %f',
    [Font1.GetHeight,Font2.GetHeight]);
  Font2.PrintF(10,290,HGETEXT_LEFT,'String width of text "Foo Bar": Font 1: %f, Font 2: %f',
    [Font1.GetStringWidth('Foo Bar'),Font2.GetStringWidth('Foo Bar')]);

  Font2.Render(10,310,HGETEXT_LEFT,'Font 1 sprite for "A" character:');
  Font1.GetSprite('A').Render(10,330);

  Engine.Gfx_EndScene;

  Result := False;
end;

procedure Test;
begin
  Engine.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,RenderFunc);

  Font1 := THGEFont.Create('font1.fnt');
  Font2 := THGEFont.Create('font2.fnt');
  FontScale := 1;
  FontScaleFactor := 0.4;
  FontRotation := 0;
  FontTracking := 0;
  FontTrackingDelta := 3;

  while Running do ;

  Font1 := nil;
  Font2 := nil;

  Engine.System_SetState(HGE_FRAMEFUNC,DefaultFrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,nil);
end;

initialization
  RegisterTest('Font stuff','Font\UFont',Test);

end.
