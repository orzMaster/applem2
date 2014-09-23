unit UGUIObject_Listbox;

interface

implementation

uses
  SysUtils, HGE, HGEGUI, HGESprite, HGERect, HGEGUICtrls, HGEFont, UTestBase;

var
  GUI: IHGEGUI;
  ListboxBackground: IHGESprite;
  Listbox: IHGEGUIListbox;

function FrameFunc: Boolean;
begin
  GUI.Update(Engine.Timer_GetDelta);
  Result := False;
end;

function RenderFunc: Boolean;
var
  R: THGERect;
begin
  Engine.Gfx_BeginScene;
  Engine.Gfx_Clear(0);

  R := Listbox.Rect;
  ListboxBackground.RenderStretch(R.X1 - 5,R.Y1 - 5,R.X2 + 5,R.Y2 + 5);
  GUI.Render;

  SmallFont.PrintF(10,10,HGETEXT_LEFT,
    'SelectedItem=%d'#13+
    'TopItem=%d'#13+
    'NumItems=%d'#13+
    'NumRows=%d'#13+
    'ItemText=%s',
    [Listbox.SelectedItem,Listbox.TopItem,Listbox.NumItems,Listbox.NumRows,
     Listbox.ItemText[Listbox.SelectedItem]]);
  Engine.Gfx_EndScene;

  Result := False;
end;

procedure Test;
var
  I: Integer;
begin
  Engine.System_SetState(HGE_FRAMEFUNC,FrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,RenderFunc);

  GUI := THGEGUI.Create;
  ListboxBackground := THGESprite.Create(nil,0,0,16,16);
  ListboxBackground.SetColor($FF808080);

  Listbox := THGEGUIListBox.Create(1,250,150,300,300,LargeFont,
    $FFFFFF00,$FF0000FF,$FFFFFFFF);
  for I := 1 to 20 do
    Listbox.AddItem('Listbox item ' + IntToStr(I));
  GUI.AddCtrl(Listbox);

  while Running do ;

  GUI := nil;
  Listbox := nil;
  ListboxBackground := nil;

  Engine.System_SetState(HGE_FRAMEFUNC,DefaultFrameFunc);
  Engine.System_SetState(HGE_RENDERFUNC,nil);
end;

initialization
  RegisterTest('hgeGUIListbox control','GUIObject\UGUIObject_Listbox',Test);

end.
