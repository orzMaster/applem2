unit AsphyreEvents;
//---------------------------------------------------------------------------
// AsphyreEvents.pas                                    Modified: 20-Feb-2007
// Event subscriber for Asphyre notifications                    Version 1.01
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
// The Original Code is AsphyreEvents.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
type
 TAsphyreEventCallback = procedure(Sender: TObject; EventParam: Pointer;
  var Success: Boolean) of object;

//---------------------------------------------------------------------------
 PAsphyreEventItem = ^TAsphyreEventItem;
 TAsphyreEventItem = record
  Callback: TAsphyreEventCallback;
  Referer : TObject;
 end;

//---------------------------------------------------------------------------
type
 TAsphyreEvent = class
 private
  EventItems: array of TAsphyreEventItem;

  function GetCount(): Integer;
  procedure Remove(Index: Integer);
  function GetItem(Index: Integer): PAsphyreEventItem;
 protected
  function IndexOf(Callback: TAsphyreEventCallback): Integer;
 public
  property Count: Integer read GetCount;
  property Items[Index: Integer]: PAsphyreEventItem read GetItem; default;

  function Subscribe(Callback: TAsphyreEventCallback; Referer: TObject): Integer;
  procedure Unsubscribe(Callback: TAsphyreEventCallback);

  function Notify(Referer, Sender: TObject; EventParam: Pointer): Boolean;
 end;

//---------------------------------------------------------------------------
// Declare the most common events.
//---------------------------------------------------------------------------
var
 // DeviceCreate event occurs after the device has been created.
 //  -> All static (managed) resources should be loaded here.
 EventDeviceCreate: TAsphyreEvent = nil;

 // DeviceDestroy occurs before the device is to be destroyed.
 //  -> All static (managed) resources that were created in DeviceCreate
 //     event should be freed here.
 EventDeviceDestroy: TAsphyreEvent = nil;

 // DeviceReset occurs when the device is placed in functional state or is
 // recovered from lost state.
 //  -> All dynamic resources that cannot survive device loss should be
 //     created here.
 EventDeviceReset: TAsphyreEvent = nil;

 // DeviceLost occurs when the device loses its functional state or after it
 // has been lost.
 //  -> All dynamic resources created in DeviceReset event should be freed
 //     here.
 EventDeviceLost: TAsphyreEvent = nil;

 // DeviceFault occurs when a fatal error has occured with the device and
 // the execution can no longer continue. When this occurs, the application
 // should show an error message and terminate.
 EventDeviceFault: TAsphyreEvent = nil;

 // BeginScene occurs after successful call to IDirect3DDevice9.BeginScene.
 EventBeginScene: TAsphyreEvent = nil;

 // EndScene occurs before the call to IDirect3DDevice9.EndScene.
 EventEndScene: TAsphyreEvent = nil;

 // EventSymbolResolve occurs before the symbol is resolved; that is, when
 // an image is being created and loaded.
 EventSymbolResolve: TAsphyreEvent = nil;

 // EventResolveFailed occurs when the symbol resolution has failed; that is,
 // when an image or font could not be created or loaded.
 EventResolveFailed: TAsphyreEvent = nil;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
function TAsphyreEvent.GetCount(): Integer;
begin
 Result:= Length(EventItems);
end;

//---------------------------------------------------------------------------
function TAsphyreEvent.GetItem(Index: Integer): PAsphyreEventItem;
begin
 if (Index >= 0)and(Index < Length(EventItems)) then
  Result:= @EventItems[Index] else Result:= nil;
end;

//---------------------------------------------------------------------------
function TAsphyreEvent.IndexOf(Callback: TAsphyreEventCallback): Integer;
var
 i: Integer;
begin
 Result:= -1;
 for i:= 0 to Length(EventItems) - 1 do
  if (@EventItems[i].Callback = @Callback) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
function TAsphyreEvent.Subscribe(Callback: TAsphyreEventCallback;
 Referer: TObject): Integer;
var
 Index: Integer;
begin
 Index:= IndexOf(Callback);
 if (Index <> -1) then
  begin
   Result:= Index;
   Exit;
  end;

 Index:= Length(EventItems);
 SetLength(EventItems, Length(EventItems) + 1);

 EventItems[Index].Callback:= Callback;
 EventItems[Index].Referer := Referer;
 Result:= Index;
end;

//---------------------------------------------------------------------------
procedure TAsphyreEvent.Remove(Index: Integer);
var
 i: Integer;
begin
 if (Index < 0)or(Index >= Length(EventItems)) then Exit;

 for i:= Index to Length(EventItems) - 2 do
  EventItems[i]:= EventItems[i + 1];

 SetLength(EventItems, Length(EventItems) - 1);
end;

//---------------------------------------------------------------------------
procedure TAsphyreEvent.Unsubscribe(Callback: TAsphyreEventCallback);
begin
 Remove(IndexOf(Callback));
end;

//---------------------------------------------------------------------------
function TAsphyreEvent.Notify(Referer, Sender: TObject;
 EventParam: Pointer): Boolean;
var
 i: Integer;
begin
 Result:= True;

 for i:= 0 to Length(EventItems) - 1 do
  if (EventItems[i].Referer = Referer) then
   begin
    EventItems[i].Callback(Sender, EventParam, Result);
    if (not Result) then Break;
   end;
end;

//---------------------------------------------------------------------------
initialization
 EventDeviceCreate := TAsphyreEvent.Create();
 EventDeviceDestroy:= TAsphyreEvent.Create();
 EventDeviceReset  := TAsphyreEvent.Create();
 EventDeviceLost   := TAsphyreEvent.Create();
 EventDeviceFault  := TAsphyreEvent.Create();
 EventBeginScene   := TAsphyreEvent.Create();
 EventEndScene     := TAsphyreEvent.Create();
 EventSymbolResolve:= TAsphyreEvent.Create();
 EventResolveFailed:= TAsphyreEvent.Create();

//---------------------------------------------------------------------------
finalization
 EventResolveFailed.Free();
 EventSymbolResolve.Free();
 EventEndScene.Free();
 EventBeginScene.Free();
 EventDeviceFault.Free();
 EventDeviceLost.Free();
 EventDeviceReset.Free();
 EventDeviceDestroy.Free();
 EventDeviceCreate.Free();

//---------------------------------------------------------------------------
end.
