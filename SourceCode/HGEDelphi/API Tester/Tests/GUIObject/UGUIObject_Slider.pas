unit UGUIObject_Slider;

interface

implementation

uses
  Windows, HGE, HGEGUI, HGEGUICtrls, HGEFont, HGESprite, HGERect, UTestBase;

var
  GUI: IHGEGUI;
  SliderBackground: IHGESprite;
  Slider1, Slider2, Slider3: IHGEGUISlider;
  Slider4, Slider5, Slider6: IHGEGUISlider;

function FrameFunc: Boolean;
begin
  SetFocus(Engine.System_GetState(HGE_HWND));
  GUI.Update(Engine.Timer_GetDelta);
  Result := False;
end;

procedure DrawSliderBackground(const R: THGERect; const DX: Integer = 0;
  const DY: Integer = 0);
begin
  SliderBackground.RenderStretch(R.X1 + DX,R.Y1 + DY,R.X2 - DX,R.Y2 - DY);
end;

function RenderFunc: Boolean;
begin
  Engine.Gfx_BeginScene;
  Engine.Gfx_Clear(0);

  DrawSliderBackground(Slider1.Rect);
  DrawSliderBackground(Slider2.Rect);
  DrawSliderBackground(Slider3.Rect,0,10);
  DrawSliderBackground(Slider4.Rect);
  DrawSliderBackground(Slider5.Rect);
  DrawSliderBackground(Slider6.Rect,10,0);

  GUI.Render;

  SmallFont.PrintF(10,10,HGETEXT_LEFT,
    'Slider1=%f'#13+
    'Slider2=%f'#13+
    'Slider3=%f'#13+
    'Slider4=%f'#13+
    'Slider5=%f'#13+
    'Slider6=%f',
    [Slider1.Value,Slider2.Value,Slider3.Value,
     Slider4.Value,Slider5.Value,Slider6.Value]);

  Engine.Gfx_EndScene;

  Result := False;
end;

procedure Test;
var
  Tex: ITexture;
begin
  Engine.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,RenderFunc);

  GUI := THGEGUI.Create;
  SliderBackground := THGESprite.Create(nil,0,0,16,16);
  SliderBackground.SetColor($FF808080);
  Tex := Engine.Texture_Load('Sliders.png');

  Slider1 := THGEGUISlider.Create(1,20,200,300,15,Tex,1,33,10,15);
  GUI.AddCtrl(Slider1);

  Slider2 := THGEGUISlider.Create(2,20,250,300,15,Tex,1,33,10,15);
  Slider2.SetMode(-100,100,HGESLIDER_BARRELATIVE);
  GUI.AddCtrl(Slider2);

  Slider3 := THGEGUISlider.Create(3,20,300,300,30,Tex,1,1,30,30);
  Slider3.SetMode(0,1,HGESLIDER_SLIDER);
  Slider3.Value := 0.25;
  GUI.AddCtrl(Slider3);

  Slider4 := THGEGUISlider.Create(4,400,100,15,300,Tex,17,37,15,10,True);
  GUI.AddCtrl(Slider4);

  Slider5 := THGEGUISlider.Create(5,450,100,15,300,Tex,17,37,15,10,True);
  Slider5.SetMode(-20,20,HGESLIDER_BARRELATIVE);
  Slider5.Value := 5;
  GUI.AddCtrl(Slider5);

  Slider6 := THGEGUISlider.Create(6,500,100,30,300,Tex,1,1,30,30,True);
  Slider6.SetMode(-2,2,HGESLIDER_SLIDER);
  Slider6.Value := 1;
  GUI.AddCtrl(Slider6);

  while Running do ;

  GUI := nil;
  Slider1 := nil;
  Slider2 := nil;
  Slider3 := nil;
  Slider4 := nil;
  Slider5 := nil;
  Slider6 := nil;
  SliderBackground := nil;

  Engine.System_SetState(HGE_FRAMEFUNC,DefaultFrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,nil);
end;

initialization
  RegisterTest('hgeGUISlider control','GUIObject\UGUIObject_Slider',Test);

end.
