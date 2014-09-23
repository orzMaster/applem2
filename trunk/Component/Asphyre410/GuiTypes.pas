unit GuiTypes;
//---------------------------------------------------------------------------
// GuiTypes.pas                                         Modified: 03-Mar-2007
// The basic definitions for Asphyre GUI foundation               Version 1.1
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
// The Original Code is GuiTypes.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
{$include Asphyre4.inc}

//---------------------------------------------------------------------------
uses
 Types, SysUtils, Vectors2px, AsphyreTypes, AsphyreDevices, AsphyreCanvas,
 AsphyreImages, AsphyreFonts, AsphyreXML, AsphyreAsserts
 {$IFDEF DebugMode}, AsphyreDebug{$ENDIF};

//---------------------------------------------------------------------------
const
 msgGuiNoUseDevice = 'GuiUseDevice() method has not been called properly.';

//---------------------------------------------------------------------------
type
 TMouseEventType = (metDown, metUp, metMove, metClick, metDblClick, metEnter,
  metLeave);

//---------------------------------------------------------------------------
 TMouseButtonType = (mbtUnknown, mbtLeft, mbtRight, mbtMiddle);

//---------------------------------------------------------------------------
 TKeyEventType = (ketDown, ketUp, ketPress);

//---------------------------------------------------------------------------
 TSpecialKeyState = set of (sksShift, sksCtrl, sksAlt);

//---------------------------------------------------------------------------
 TGuiMouseEvent = procedure(Sender: TObject; const Pos: TPoint2px;
  Event: TMouseEventType; Button: TMouseButtonType;
  SpecialKeys: TSpecialKeyState) of object;

//---------------------------------------------------------------------------
 TGuiKeyEvent = procedure(Sender: TObject; Key: Integer;
  Event: TKeyEventType; SpecialKeys: TSpecialKeyState) of object;

//---------------------------------------------------------------------------
 TGuiDataType = (gdtUnknown, gdtInteger, gdtCardinal, gdtReal, gdtString,
  gdtPoint, gdtRect, gdtColor, gdtColor2, gdtSkin, gdtHAlign, gdtVAlign,
  gdtFontOpt, gdtFontColor, gdtBoolean);

//---------------------------------------------------------------------------
var
 GuiDevice: TAsphyreDevice = nil;
 GuiCanvas: TAsphyreCanvas = nil;
 GuiImages: TAsphyreImages = nil;
 GuiFonts : TAsphyreFonts = nil;

//---------------------------------------------------------------------------
procedure GuiUseDevice(Device: TAsphyreDevice);

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreEffects, MediaUtils, GuiUtils;

//---------------------------------------------------------------------------
procedure GuiUseDevice(Device: TAsphyreDevice);
begin
 GuiDevice:= Device;
 GuiCanvas:= Device.Canvas;
 GuiImages:= Device.Images;
 GuiFonts := Device.Fonts;
end;

//---------------------------------------------------------------------------
end.
