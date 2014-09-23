unit GuiForms;

//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Types, Vectors2px, AsphyreTypes, AsphyreFonts, GuiShapeRep, GuiTypes, GuiUtils,
 GuiObjects, GuiControls;

//---------------------------------------------------------------------------
type
 TGuiForm = class(TGuiControl)
 private
  FDragShape : string;
  DragClick  : TPoint2px;
  DragInit   : TPoint2px;
  Dragging   : Boolean;
  FCaptRect  : TRect;
  FCaptColor : TColor2;
  FCaptFont  : string;
  FCaptHAlign: THorizontalAlign;
  FCaptVAlign: TVerticalAlign;
  FCaption   : string;
  FCaptOpt   : TFontOptions;

  procedure DrawText(const DrawPos: TPoint2px);
  function GetCaptOpt(): PFontOptions;
 protected
  procedure DoMouseEvent(const Pos: TPoint2px; Event: TMouseEventType;
   Button: TMouseButtonType; SpecialKeys: TSpecialKeyState); override;
  procedure DoDraw(const DrawPos: TPoint2px); override;

  procedure DoDescribe(); override;
  procedure WriteProperty(Code: Cardinal; Source: Pointer); override;
 public
  property DragShape : string read FDragShape write FDragShape;

  property CaptHAlign: THorizontalAlign read FCaptHAlign write FCaptHAlign;
  property CaptVAlign: TVerticalAlign read FCaptVAlign write FCaptVAlign;
  property CaptRect  : TRect read FCaptRect write FCaptRect;
  property CaptColor : TColor2 read FCaptColor write FCaptColor;
  property CaptFont  : string read FCaptFont write FCaptFont;
  property CaptOpt   : PFontOptions read GetCaptOpt;
  property Caption   : string read FCaption write FCaption;

  procedure SetFocus(); override;

  constructor Create(AOwner: TGuiObject); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
const
 PropBase = $1000;

//---------------------------------------------------------------------------
constructor TGuiForm.Create(AOwner: TGuiObject);
begin
 inherited;

 FCaptHAlign:= haCenter;
 FCaptVAlign:= vaCenter;
 Dragging   := False;

 FCaptOpt.Reset();
end;

//---------------------------------------------------------------------------
function TGuiForm.GetCaptOpt(): PFontOptions;
begin
 Result:= @FCaptOpt;
end;

//---------------------------------------------------------------------------
procedure TGuiForm.DoMouseEvent(const Pos: TPoint2px; Event: TMouseEventType;
 Button: TMouseButtonType; SpecialKeys: TSpecialKeyState);
begin
 if (Event = metDown)and(Button = mbtLeft)and
  (PointInside(FDragShape, Pos))and(not Dragging) then
  begin
   DragInit := Origin;
   DragClick:= Pos;
   Dragging := True;
  end;

 if (Dragging)and(Button = mbtLeft)and(Event = metUp) then Dragging:= False;
 if (Dragging)and(Event = metMove) then
  Origin:= DragInit + Pos - DragClick;
end;

//---------------------------------------------------------------------------
procedure TGuiForm.DrawText(const DrawPos: TPoint2px);
var
 Font: TAsphyreNativeFont;
begin
 Font:= GuiFonts.Font[FCaptFont];
 if (Font = nil) then Exit;

 Font.Options^:= FCaptOpt;

 Font.TextRect(FCaption, MoveRect(FCaptRect, DrawPos),
  FCaptHAlign, FCaptVAlign, FCaptColor);
end;

//---------------------------------------------------------------------------
procedure TGuiForm.SetFocus();
begin
 inherited;

 BringToFront();
end;

//---------------------------------------------------------------------------
procedure TGuiForm.DoDraw(const DrawPos: TPoint2px);
begin
 if (FCaptFont <> '')and(FCaption <> '') then DrawText(DrawPos);
end;

//---------------------------------------------------------------------------
procedure TGuiForm.DoDescribe();
begin
 inherited;

 Describe(PropBase + $0, 'Caption',    gdtString);
 Describe(PropBase + $1, 'CaptOpt',    gdtFontOpt);
 Describe(PropBase + $2, 'CaptFont',   gdtString);
 Describe(PropBase + $3, 'CaptColor',  gdtColor2);
 Describe(PropBase + $4, 'CaptRect',   gdtRect);
 Describe(PropBase + $5, 'CaptHAlign', gdtHAlign);
 Describe(PropBase + $6, 'CaptVAlign', gdtVAlign);
 Describe(PropBase + $7, 'DragShape',  gdtString);
end;

//---------------------------------------------------------------------------
procedure TGuiForm.WriteProperty(Code: Cardinal; Source: Pointer);
begin
 case Code of
  PropBase + $0:
   FCaption:= PChar(Source);

  PropBase + $1:
   FCaptOpt:= PFontOptions(Source)^;

  PropBase + $2:
   FCaptFont:= PChar(Source);

  PropBase + $3:
   FCaptColor:= PColor2(Source)^;

  PropBase + $4:
   FCaptRect:= PRect(Source)^;

  PropBase + $5:
   FCaptHAlign:= THorizontalAlign(Source^);

  PropBase + $6:
   FCaptVAlign:= TVerticalAlign(Source^);

  PropBase + $7:
   FDragShape:= PChar(Source);

  else inherited WriteProperty(Code, Source);
 end;
end;

//---------------------------------------------------------------------------
end.
