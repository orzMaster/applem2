unit UInput;

interface

implementation

uses
  Windows, HGE, HGEFont, UTestBase;

procedure Test;
var
  X, Y: Single;
  Key, LastKey, Wheel, LastWheel, Chr, LastChr: Integer;
  Event, LastEvent: THGEInputEvent;
begin
  LastWheel := 0; LastKey := 0; LastChr := 0;
  LastEvent.EventType := -1;
  while Running do begin
    SetFocus(Engine.System_GetState(HGE_HWND));
    Engine.Gfx_BeginScene;
    Engine.Gfx_Clear(0);

    Engine.Input_GetMousePos(X,Y);
    Wheel := Engine.Input_GetMouseWheel;
    if (Wheel <> 0) then
      LastWheel := Wheel;
    LargeFont.PrintF(10,10,HGETEXT_LEFT,'Mouse X=%.1f, Y=%.1f, Wheel=%d, Over=%d',
      [X,Y,LastWheel,Ord(Engine.Input_IsMouseOver)]);

    Key := Engine.Input_GetKey;
    if (Key <> 0) then
      LastKey := Key;
    LargeFont.PrintF(10,40,HGETEXT_LEFT,'Key=%d (%s)',
      [LastKey,Engine.Input_GetKeyName(LastKey)]);

    Chr := Engine.Input_GetChar;
    if (Chr <> 0) then
      LastChr := Chr;
    LargeFont.PrintF(10,70,HGETEXT_LEFT,'Char=%d (%s)',
      [LastChr,Char(LastChr)]);

    if (Engine.Input_GetEvent(Event)) then
      LastEvent := Event;
    LargeFont.PrintF(10,100,HGETEXT_LEFT,
      'Event, Type=%d, Key=%d, Flags=%x, Chr=%d, Wheel=%d, X=%.1f, Y=%.1f',
      [LastEvent.EventType,LastEvent.Key,LastEvent.Flags,
       LastEvent.Chr,LastEvent.Wheel,LastEvent.X,LastEvent.Y]);

    Engine.Gfx_EndScene;
    Sleep(20);
  end;
end;

initialization
  RegisterTest('Input Functions','HGE\Input\UInput',Test,[toManualGfx]);

end.
