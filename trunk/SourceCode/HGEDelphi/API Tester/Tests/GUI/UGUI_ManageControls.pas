unit UGUI_ManageControls;

interface

implementation

uses
  Windows, HGE, HGEFont, HGESprite, HGEGUI, HGEGUICtrls, UTestBase;

var
  GUI: IHGEGUI;
  ButtonTexture: ITexture;
  ControlId: Integer;
  Cursor: IHGESprite;

procedure AddControl;
var
  Control: IHGEGUIObject;
begin
  Inc(ControlId);
  Control := THGEGUIButton.Create(ControlId,Engine.Random_Float(0,600),
    Engine.Random_Float(0,550),194,44,ButtonTexture,0,0);
  GUI.AddCtrl(Control);
end;

procedure DeleteControl;
begin
  if (ControlId > 1) then begin
    GUI.DelCtrl(ControlId);
    Dec(ControlId);
  end;
end;

procedure MoveControl(const DX, DY: Integer);
var
  Control: IHGEGUIObject;
begin
  Control := GUI.GetCtrl(ControlId);
  GUI.MoveCtrl(ControlId,Control.Rect.X1 + DX,Control.Rect.Y1 + DY);
end;

procedure ShowHideControl;
var
  Control: IHGEGUIObject;
begin
  Control := GUI.GetCtrl(ControlId);
  GUI.ShowCtrl(ControlId,not Control.Visible);
end;

procedure EnableControl;
var
  Control: IHGEGUIObject;
begin
  Control := GUI.GetCtrl(ControlId);
  GUI.EnableCtrl(ControlId,not Control.Enabled);
end;

procedure MoveAllControls;
begin
  GUI.Move(Engine.Random_Float(-5,5),Engine.Random_Float(-5,5));
end;

function FrameFunc: Boolean;
begin
  SetFocus(Engine.System_GetState(HGE_HWND));
  case Engine.Input_GetKey of
    HGEK_A    : AddControl;
    HGEK_D    : DeleteControl;
    HGEK_S    : ShowHideControl;
    HGEK_E    : EnableControl;
    HGEK_LEFT : MoveControl(-4,0);
    HGEK_RIGHT: MoveControl(4,0);
    HGEK_UP   : MoveControl(0,-4);
    HGEK_DOWN : MoveControl(0,4);
    HGEK_M    : MoveAllControls;
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
    'A=Add control'#13+
    'D=Delete last control'#13+
    'S=Show/Hide last control'#13+
    'E=Enable/Disable last control'#13+
    'Cursor keys=Move last control'#13+
    'M=Move all controls');
  Engine.Gfx_EndScene;

  Result := False;
end;

procedure Test;
var
  Tex: ITexture;
begin
  Engine.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,RenderFunc);
  Engine.System_SetState(HGE_HIDEMOUSE,True);

  GUI := THGEGUI.Create;
  ButtonTexture := Engine.Texture_Load('Button.png');
  Tex := Engine.Texture_Load('cursor.png');
  Cursor := THGESprite.Create(Tex,0,0,32,32);

  GUI.SetCursor(Cursor);
  ControlId := 0;
  AddControl;

  while Running do ;

  GUI := nil;
  ButtonTexture := nil;
  Cursor := nil;

  Engine.System_SetState(HGE_FRAMEFUNC,DefaultFrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,nil);
  Engine.System_SetState(HGE_HIDEMOUSE,False);
end;

initialization
  RegisterTest('Control Management','GUI\UGUI_ManageControls',Test);

end.
