unit AsphyreInputs;
//---------------------------------------------------------------------------
// AsphyreInputs.pas                                    Modified: 28-Jan-2007
// Control system for Asphyre input components                    Version 1.0
//---------------------------------------------------------------------------
// Important Notice:
//
// If you modify/use this code or one of its parts either in original or
// modified form, you must comply with Mozilla Public License v1.1,
// specifically section 3, "Distribution Obligations". Failure to do so will
// result in the license breach, which will be resolved in the court.
// Remember that violating author's rights is considered a serious crime in
// many countries. Thank you!
//
// !! Please *read* Mozilla Public License 1.1 document located at:
//  http://www.mozilla.org/MPL/
//
// If you require any clarifications about the license, feel free to contact
// us or post your question on our forums at: http://www.afterwarp.net
//---------------------------------------------------------------------------
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS"
// basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
// License for the specific language governing rights and limitations
// under the License.
//
// The Original Code is AsphyreInputs.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Windows, DirectInput, AsphyreAsserts, AsphyreKeyboard, AsphyreMouse,
 AsphyreJoystick;

//---------------------------------------------------------------------------
type
 TAsphyreInput = class
 private
  FDirectInput8: IDirectInput8;
  FInitialized : Boolean;
  FKeyboard    : TAsphyreKeyboard;
  FMouse       : TAsphyreMouse;
  FJoysticks   : TAsphyreJoysticks;
  FWindowHandle: THandle;
 public
  property DirectInput8: IDirectInput8 read FDirectInput8;
  property Initialized : Boolean read FInitialized;

  // This must contain a valid handle to existing application window.
  property WindowHandle: THandle read FWindowHandle write FWindowHandle;

  property Keyboard : TAsphyreKeyboard read FKeyboard;
  property Mouse    : TAsphyreMouse read FMouse;
  property Joysticks: TAsphyreJoysticks read FJoysticks;

  function Initialize(): Boolean;
  procedure Finalize();

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
var
 AsphyreInput: TAsphyreInput = nil;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
constructor TAsphyreInput.Create();
begin
 inherited;

 FKeyboard := TAsphyreKeyboard.Create(Self);
 FMouse    := TAsphyreMouse.Create(Self);
 FJoysticks:= TAsphyreJoysticks.Create(Self);
end;

//---------------------------------------------------------------------------
destructor TAsphyreInput.Destroy();
begin
 FJoysticks.Free();
 FMouse.Free();
 FKeyboard.Free();

 if (FInitialized) then Finalize();
 
 inherited;
end;

//---------------------------------------------------------------------------
function TAsphyreInput.Initialize(): Boolean;
begin
 Assert(not FInitialized, msgAlreadyInitialized);

 Result:= Succeeded(DirectInput8Create(hInstance, DIRECTINPUT_VERSION,
  IID_IDirectInput8, FDirectInput8, nil));

 FInitialized:= Result;
end;

//---------------------------------------------------------------------------
procedure TAsphyreInput.Finalize();
begin
 FJoysticks.Finalize();
 FMouse.Finalize();
 FKeyboard.Finalize();

 if (FDirectInput8 <> nil) then FDirectInput8:= nil;

 FInitialized:= False;
end;

//---------------------------------------------------------------------------
initialization
 AsphyreInput:= TAsphyreInput.Create();

//---------------------------------------------------------------------------
finalization
 AsphyreInput.Free();
 AsphyreInput:= nil;

//---------------------------------------------------------------------------
end.
