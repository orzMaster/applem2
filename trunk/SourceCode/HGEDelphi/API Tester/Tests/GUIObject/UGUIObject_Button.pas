unit UGUIObject_Button;

interface

implementation

uses
  Windows, HGE, HGEGUI, HGEGUICtrls, HGEFont, UTestBase;

var
  GUI: IHGEGUI;
  Button: IHGEGUIButton;

function FrameFunc: Boolean;
begin
  SetFocus(Engine.System_GetState(HGE_HWND));
  case Engine.Input_GetKey of
    HGEK_T: Button.Trigger := not Button.Trigger;
  end;

  GUI.Update(Engine.Timer_GetDelta);
  Result := False;
end;

function RenderFunc: Boolean;
const
  States: array [Boolean] of String = ('Released','Pressed');
begin
  Engine.Gfx_BeginScene;
  Engine.Gfx_Clear(0);
  GUI.Render;

  SmallFont.PrintF(10,10,HGETEXT_LEFT,
    'T=Toggle Trigger mode'#13+
    'State=%s',[States[Button.Pressed]]);
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
  Tex := Engine.Texture_Load('Button.png');

  Button := THGEGUIButton.Create(1,300,225,194,44,Tex,0,0);
  GUI.AddCtrl(Button);

  while Running do ;

  GUI := nil;
  Button := nil;

  Engine.System_SetState(HGE_FRAMEFUNC,DefaultFrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,nil);
end;

initialization
  RegisterTest('hgeGUIButton control','GUIObject\UGUIObject_Button',Test);

end.
