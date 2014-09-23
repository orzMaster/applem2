unit UGUIObject_Text;

interface

implementation

uses
  Windows, HGE, HGEGUI, HGEGUICtrls, HGEFont, UTestBase;

var
  GUI: IHGEGUI;

function FrameFunc: Boolean;
begin
  SetFocus(Engine.System_GetState(HGE_HWND));
  case Engine.Input_GetKey of
    HGEK_C: GUI.SetColor(Cardinal(Engine.Random_Int(0,$FFFFFF)) or $FF000000);
  end;

  GUI.Update(Engine.Timer_GetDelta);
  Result := False;
end;

function RenderFunc: Boolean;
begin
  Engine.Gfx_BeginScene;
  Engine.Gfx_Clear(0);
  GUI.Render;

  SmallFont.Render(10,10,HGETEXT_LEFT,
    'C=Change color of all controls');
  Engine.Gfx_EndScene;

  Result := False;
end;

procedure Test;
const
  Text = 'The Quick'#13'Brown Fox Jumped'#13'Over The Lazy'#13'Dog';
var
  Control: IHGEGUIText;
begin
  Engine.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,RenderFunc);

  GUI := THGEGUI.Create;

  Control := THGEGUIText.Create(1,20,100,0,0,LargeFont);
  Control.Text := Text;
  GUI.AddCtrl(Control);

  Control := THGEGUIText.Create(2,400,100,0,0,LargeFont);
  Control.Text := Text;
  Control.Align := HGETEXT_CENTER;
  Control.Color := $FF00FFFF;
  GUI.AddCtrl(Control);

  Control := THGEGUIText.Create(3,780,100,0,0,LargeFont);
  Control.Text := Text;
  Control.Align := HGETEXT_RIGHT;
  GUI.AddCtrl(Control);

  while Running do ;

  GUI := nil;

  Engine.System_SetState(HGE_FRAMEFUNC,DefaultFrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,nil);
end;

initialization
  RegisterTest('hgeGUIText control','GUIObject\UGUIObject_Text',Test);

end.
