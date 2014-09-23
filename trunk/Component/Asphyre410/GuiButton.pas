unit GuiButton;
//---------------------------------------------------------------------------
// GuiButton.pas                                        Modified: 03-Mar-2007
// A simple button class for Asphyre GUI foundation               Version 1.0
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
// The Original Code is GuiButton.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Types, Vectors2px, AsphyreTypes, AsphyreFonts, GuiSkins, GuiTypes, GuiUtils,
 GuiObjects, GuiControls;

//---------------------------------------------------------------------------
type
 TGuiButton = class(TGuiControl)
 private
  FCaptCol   : TGuiFontCol;
  FCaptRect  : TRect;
  FCaptFont  : string;
  FCaptHAlign: THorizontalAlign;
  FCaptVAlign: TVerticalAlign;
  FCaption   : string;
  FCaptOpt   : TFontOptions;

  procedure DrawText(const DrawPos: TPoint2px);
  function GetCaptOpt(): PFontOptions;
 protected
  procedure DoDestroy(); override;
  procedure DoDraw(const DrawPos: TPoint2px); override;

  procedure DoDescribe(); override;
  procedure WriteProperty(Code: Cardinal; Source: Pointer); override;
 public
  property CaptCol: TGuiFontCol read FCaptCol;

  property CaptHAlign: THorizontalAlign read FCaptHAlign write FCaptHAlign;
  property CaptVAlign: TVerticalAlign read FCaptVAlign write FCaptVAlign;
  property CaptRect  : TRect read FCaptRect write FCaptRect;
  property CaptFont  : string read FCaptFont write FCaptFont;
  property CaptOpt   : PFontOptions read GetCaptOpt;
  property Caption   : string read FCaption write FCaption;

  constructor Create(AOwner: TGuiObject); override;
 end;

//---------------------------------------------------------------------------
implementation

uses
 SysUtils;

//---------------------------------------------------------------------------
const
 PropBase = $1000;

//---------------------------------------------------------------------------
constructor TGuiButton.Create(AOwner: TGuiObject);
begin
 inherited;

 FCaptHAlign:= haCenter;
 FCaptVAlign:= vaCenter;

 FCaptCol:= TGuiFontCol.Create();
 FCaptOpt.Reset();
end;

//---------------------------------------------------------------------------
procedure TGuiButton.DoDestroy();
begin
 FCaptCol.Free();

 inherited;
end;

//---------------------------------------------------------------------------
function TGuiButton.GetCaptOpt(): PFontOptions;
begin
 Result:= @FCaptOpt;
end;

//---------------------------------------------------------------------------
procedure TGuiButton.DoDraw(const DrawPos: TPoint2px);
begin
 inherited;

 if (FCaptFont <> '')and(FCaption <> '') then DrawText(DrawPos);
end;

//---------------------------------------------------------------------------
procedure TGuiButton.DoDescribe();
begin
 inherited;

 Describe(PropBase + $0, 'Caption',    gdtString);
 Describe(PropBase + $1, 'CaptOpt',    gdtFontOpt);
 Describe(PropBase + $2, 'CaptFont',   gdtString);
 Describe(PropBase + $3, 'CaptRect',   gdtRect);
 Describe(PropBase + $4, 'CaptHAlign', gdtHAlign);
 Describe(PropBase + $5, 'CaptVAlign', gdtVAlign);
 Describe(PropBase + $6, 'CaptCol',    gdtFontColor);
end;

//---------------------------------------------------------------------------
procedure TGuiButton.WriteProperty(Code: Cardinal; Source: Pointer);
begin
 case Code of
  PropBase + $0:
   FCaption:= PChar(Source);

  PropBase + $1:
   FCaptOpt:= PFontOptions(Source)^;

  PropBase + $2:
   FCaptFont:= PChar(Source);

  PropBase + $3:
   FCaptRect:= PRect(Source)^;

  PropBase + $4:
   FCaptHAlign:= THorizontalAlign(Source^);

  PropBase + $5:
   FCaptVAlign:= TVerticalAlign(Source^);

  PropBase + $6:
   FCaptCol.Assign(TGuiFontCol(Source));

  else inherited WriteProperty(Code, Source);
 end;
end;

//---------------------------------------------------------------------------
procedure TGuiButton.DrawText(const DrawPos: TPoint2px);
var
 Font: TAsphyreNativeFont;
 Shift: TPoint2px;
begin
 Font:= GuiFonts.Font[FCaptFont];
 if (Font = nil) then Exit;

 Font.Options^:= FCaptOpt;

 Shift:= ZeroPoint2px;
 if (MouseDown) then Shift:= Point2px(1, 1);

 Font.TextRect(FCaption, MoveRect(FCaptRect, DrawPos + Shift),
  FCaptHAlign, FCaptVAlign, FCaptCol.UseColor(GetSkinDrawType()));
end;

//---------------------------------------------------------------------------
end.
