program HGE_Tut01;
(*
** Haaf's Game Engine 1.7
** Copyright (C) 2003-2007, Relish Games
** hge.relishgames.com
**
** hge_tut01 - Minimal HGE application
**
** Delphi conversion by Erik van Bilsen
*)

{$R *.res}

uses
  Windows, HGE;

var
  HGE: IHGE = nil;

// This function will be called by HGE once per frame.
// Put your game loop code here. In this example we
// just check whether ESC key has been pressed.
function FrameFunc: Boolean;
begin
  // By returning "true" we tell HGE
  // to stop running the application.
  Result := HGE.Input_GetKeyState(HGEK_ESCAPE);
end;

begin
  ReportMemoryLeaksOnShutdown := True;

  // Here we use global pointer to HGE interface.
  // Instead you may use hgeCreate() every
  // time you need access to HGE. Just be sure to
  // have a corresponding hge->Release()
  // for each call to hgeCreate()
  HGE := HGECreate(HGE_VERSION);

  // Set our frame function
  HGE.System_SetState(HGE_FRAMEFUNC,FrameFunc);

  // Set the window title
  HGE.System_SetState(HGE_TITLE,'HGE Tutorial 01 - Minimal HGE application');

  // Run in windowed mode
  // Default window size is 800x600
  HGE.System_SetState(HGE_WINDOWED,True);

  // Don't use BASS for sound
  HGE.System_SetState(HGE_USESOUND,False);

  // Tries to initiate HGE with the states set.
  // If something goes wrong, "false" is returned
  // and more specific description of what have
  // happened can be read with System_GetErrorMessage().
  if (HGE.System_Initiate) then begin
    // Starts running FrameFunc().
    // Note that the execution "stops" here
    // until "true" is returned from FrameFunc().
    HGE.System_Start;
  end else begin
    // If HGE initialization failed show error message
    MessageBox(0,PChar(HGE.System_GetErrorMessage),'Error',
      MB_OK or MB_ICONERROR or MB_APPLMODAL);
  end;

  // Now ESC has been pressed or the user
  // has closed the window by other means.

  // Restore video mode and free
  // all allocated resources
  HGE.System_Shutdown;

  // Release the HGE interface.
  // If there are no more references,
  // the HGE object will be deleted.
  HGE := nil;
end.
