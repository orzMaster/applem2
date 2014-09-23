unit GuiUtils;

//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Vectors2px, Types, Classes, SysUtils, Controls, AsphyreXML, AsphyreTypes,
 GuiTypes;

//---------------------------------------------------------------------------
function MoveRect(const Rect: TRect; const Point: TPoint2px): TRect;


//---------------------------------------------------------------------------
function ShortRect(const Rect1, Rect2: TRect): TRect;
function InvMoveRect(const Rect: TRect; const Point: TPoint): TRect;
function RectLastPx(const Rect: TRect): TRect;
function ShrinkRect(const Rect: TRect; const hIn, vIn: Integer): TRect;

//---------------------------------------------------------------------------
function Color4Visible(const Colors: TColor4): Boolean;
procedure Color4toXML(const Colors: TColor4; Parent: TXMLNode);
procedure XMLtoColor4(Node: TXMLNode; var Colors: TColor4);

//---------------------------------------------------------------------------
function EmbedStrings(const Text: string): string;
function UnembedStrings(const Text: string): string;
function Button2Gui(Button: TMouseButton): TMouseButtonType;
function ShiftState2Special(Shift: TShiftState): TSpecialKeyState;

//---------------------------------------------------------------------------
procedure GuiFindSkin(var SkinIndex: Integer; var Skin: string);

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreUtils, AsphyreImages, MediaUtils;

//---------------------------------------------------------------------------
function MoveRect(const Rect: TRect; const Point: TPoint2px): TRect;
begin
 Result.Left  := Rect.Left   + Point.x;
 Result.Top   := Rect.Top    + Point.y;
 Result.Right := Rect.Right  + Point.x;
 Result.Bottom:= Rect.Bottom + Point.y;
end;

//---------------------------------------------------------------------------
function ShortRect(const Rect1, Rect2: TRect): TRect;
begin
 Result.Left  := Max2(Rect1.Left, Rect2.Left);
 Result.Top   := Max2(Rect1.Top, Rect2.Top);
 Result.Right := Min2(Rect1.Right, Rect2.Right);
 Result.Bottom:= Min2(Rect1.Bottom, Rect2.Bottom);
end;

//---------------------------------------------------------------------------
function InvMoveRect(const Rect: TRect; const Point: TPoint): TRect;
begin
 Result.Left  := Rect.Left   - Point.X;
 Result.Top   := Rect.Top    - Point.Y;
 Result.Right := Rect.Right  - Point.X;
 Result.Bottom:= Rect.Bottom - Point.Y;
end;

//---------------------------------------------------------------------------
function RectLastPx(const Rect: TRect): TRect;
begin
 Result.Left  := Rect.Left;
 Result.Top   := Rect.Top;
 Result.Right := Rect.Right  - 1;
 Result.Bottom:= Rect.Bottom - 1;
end;

//---------------------------------------------------------------------------
function ShrinkRect(const Rect: TRect; const hIn, vIn: Integer): TRect;
begin
 Result.Left:= Rect.Left + hIn;
 Result.Top:= Rect.Top + vIn;
 Result.Right:= Rect.Right - hIn;
 Result.Bottom:= Rect.Bottom - vIn;
end;

//---------------------------------------------------------------------------
function Color4Visible(const Colors: TColor4): Boolean;
begin
 Result:= (Colors[0] or Colors[1] or Colors[2] or Colors[3]) shr 24 > 0;
end;

//---------------------------------------------------------------------------
procedure Color4toXML(const Colors: TColor4; Parent: TXMLNode);
var
 Node: TXMLNode;
begin
 Node:= Parent.AddChild('color4');

 // -> "colors"
 Node:= Node.AddChild('colors');
 Node.AddField('c1', '#' + IntToHex(Colors[0] and $FFFFFF, 6));
 Node.AddField('c2', '#' + IntToHex(Colors[1] and $FFFFFF, 6));
 Node.AddField('c3', '#' + IntToHex(Colors[2] and $FFFFFF, 6));
 Node.AddField('c4', '#' + IntToHex(Colors[3] and $FFFFFF, 6));

 // -> "alpha"
 Node:= Node.AddChild('alphas');
 Node.AddField('a1', IntToStr(Colors[0] shr 24));
 Node.AddField('a2', IntToStr(Colors[1] shr 24));
 Node.AddField('a3', IntToStr(Colors[2] shr 24));
 Node.AddField('a4', IntToStr(Colors[3] shr 24));
end;

//---------------------------------------------------------------------------
procedure XMLtoColor4(Node: TXMLNode; var Colors: TColor4);
var
 Child: TXMLNode;
begin
 if (LowerCase(Node.Name) <> 'color4') then Exit;

 // -> "colors"
 Child:= Node.ChildNode['colors'];
 if (Child <> nil) then
  begin
   Colors[0]:= ParseColor(Child.FieldValue['c1']);
   Colors[1]:= ParseColor(Child.FieldValue['c2']);
   Colors[2]:= ParseColor(Child.FieldValue['c3']);
   Colors[3]:= ParseColor(Child.FieldValue['c4']);
  end;

 // -> "alphas"
 Child:= Node.ChildNode['alphas'];
 if (Child <> nil) then
  begin
   Colors[0]:= (Colors[0] and $FFFFFF) or
    (ParseCardinal(Child.FieldValue['a1']) shl 24);
   Colors[1]:= (Colors[1] and $FFFFFF) or
    (ParseCardinal(Child.FieldValue['a2']) shl 24);
   Colors[2]:= (Colors[2] and $FFFFFF) or
    (ParseCardinal(Child.FieldValue['a3']) shl 24);
   Colors[3]:= (Colors[3] and $FFFFFF) or
    (ParseCardinal(Child.FieldValue['a4']) shl 24);
  end;
end;

//---------------------------------------------------------------------------
function EmbedStrings(const Text: string): string;
var
 i: Integer;
begin
 Result:= '';
 for i:= 1 to Length(Text) do
  begin
   if (Text[i] = #10) then Result:= Result + '\c\l';
   if (not (Text[i] in [#10, #13])) then Result:= Result + Text[i];
  end;
end;

//---------------------------------------------------------------------------
function UnembedStrings(const Text: string): string;
var
 i: Integer;
begin
 Result:= '';

 i:= 1;
 while (i <= Length(Text)) do
  begin
   if (i < Length(Text) - 3)and(Text[i] = '\')and(Text[i + 1] = 'c')and
    (Text[i + 2] = '\')and(Text[i] = 'l') then
    begin
     Result:= Result + #13#10;
     Inc(i, 4);
    end else
    begin
     Result:= Result + Text[i];
     Inc(i);
    end;
  end;
end;

//---------------------------------------------------------------------------
function Button2Gui(Button: TMouseButton): TMouseButtonType;
begin
 Result:= mbtUnknown;
 case Button of
  mbLeft  : Result:= mbtLeft;
  mbRight : Result:= mbtRight;
  mbMiddle: Result:= mbtMiddle;
 end;
end;

//---------------------------------------------------------------------------
function ShiftState2Special(Shift: TShiftState): TSpecialKeyState;
begin
 Result:= [];

 if (ssShift in Shift) then Result:= Result + [sksShift];
 if (ssCtrl in Shift) then Result:= Result + [sksCtrl];
 if (ssAlt in Shift) then Result:= Result + [sksAlt];
end;

//---------------------------------------------------------------------------
procedure GuiFindSkin(var SkinIndex: Integer; var Skin: string);
var
 Image: TAsphyreCustomImage;
begin
 // check whether the skin index has been already resolved
 if (SkinIndex <> -1) then
  begin
   Image:= GuiImages[SkinIndex];
   if (Image <> nil)and(Image.Name = Skin) then Exit;

   SkinIndex:= -1;
  end;

 // okay if no skin is specified
 if (Skin = '') then Exit;

 // resolve skin index
 Image:= GuiImages.Image[Skin];
 if (Image <> nil) then SkinIndex:= Image.ImageIndex else Skin:= '';
end;

//---------------------------------------------------------------------------
end.
