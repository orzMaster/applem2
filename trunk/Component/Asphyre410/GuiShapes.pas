unit GuiShapes;
//---------------------------------------------------------------------------
// GuiShapes.pas                                        Modified: 16-Feb-2007
// Polygonal shape utility classes for Asphyre GUI foundation     Version 1.0
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
// The Original Code is GuiShapes.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Types, SysUtils, Vectors2px, AsphyreXML, AsphyreClasses;

//---------------------------------------------------------------------------
type
 TGeometryShape = class
 public
  function PointInside(const Point: TPoint2px): Boolean; virtual; abstract;
  function BoundingBox(): TRect; virtual; abstract;
  procedure MoveBy(const Shift: TPoint2px); virtual; abstract;
  procedure Rescale(const Delta: TPoint2px); virtual; abstract;

  procedure LoadFromXML(Node: TXMLNode); virtual; abstract;
 end;

//---------------------------------------------------------------------------
 TPolygonShape = class(TGeometryShape)
 private
  Vertices: array of TPoint2px;

  function GetVertex(Num: Integer): PPoint2px;
  function GetVertexCount(): Integer;
 public
  property VertexCount: Integer read GetVertexCount;
  property Vertex[Num: Integer]: PPoint2px read GetVertex; default;

  function PointInside(const Point: TPoint2px): Boolean; override;
  function BoundingBox(): TRect; override;
  procedure MoveBy(const Shift: TPoint2px); override;
  procedure Rescale(const Delta: TPoint2px); override;

  procedure LoadFromXML(Node: TXMLNode); override;

  function Add(const Point: TPoint2px): Integer; overload;
  function Add(x, y: Integer): Integer; overload;
  procedure Remove(Num: Integer);
  procedure Clear();
 end;

//---------------------------------------------------------------------------
 TGuiShape = class
 private
  FName : string;
  Shapes2: array of TGeometryShape;

  Shapes: array of TPolygonShape;

  function Insert(Shape: TGeometryShape): Integer;

  function GetCount(): Integer;
  function GetShape(Num: Integer): TPolygonShape;
  function GetBoundingBox(): TRect;
  function GetPointInside(const Point: TPoint2px): Boolean;
 public
  property Name: string read FName;

  property Count: Integer read GetCount;
  property Shape[Num: Integer]: TPolygonShape read GetShape; default;

  property BoundingBox: TRect read GetBoundingBox;
  property PointInside[const Point: TPoint2px]: Boolean read GetPointInside;

  function Add(): TPolygonShape;
  procedure AddPoly(Coords: array of Integer);
  procedure Remove(Num: Integer);
  procedure Clear();

  procedure MakeRect(x, y, Width, Height: Integer);
  procedure MoveBy(const Shift: TPoint2px); overload;
  procedure MoveBy(dx, dy: Integer); overload;

  procedure LoadFromXML(Node: TXMLNode);

  constructor Create(const AName: string);
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
 TGuiShapes = class
 private
  List: TAsphyreList;

  function GetCount(): Integer;
  function GetItem(Index: Integer): TGuiShape;
  procedure FreeItem(List: TAsphyreList; Item: Pointer);
  function SortItem(List: TAsphyreList; Item1, Item2: Pointer): Integer;
  function FindItem(List: TAsphyreList; Item, User: Pointer): Integer;
  function GetShape(const Name: string): TGuiShape;
 public
  property Count: Integer read GetCount;
  property Items[Index: Integer]: TGuiShape read GetItem; default;
  property Shape[const Name: string]: TGuiShape read GetShape;

  function Insert(const Name: string): TGuiShape;
  function IndexOf(Shape: TGuiShape): Integer; overload;
  function IndexOf(const Name: string): Integer; overload;
  procedure Remove(Index: Integer);
  procedure Clear();

  procedure ParseLink(const Link: string);

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreUtils, MediaUtils;

//---------------------------------------------------------------------------
procedure TPolygonShape.LoadFromXML(Node: TXMLNode);
var
 VNode: TXMLNode;
 i, Index: Integer;
begin
 SetLength(Vertices, ParseInt(Node.FieldValue['vertices'], 0));

 for i:= 0 to Node.ChildCount - 1 do
  if (LowerCase(Node.Child[i].Name) = 'vertex') then
   begin
    VNode:= Node.Child[i];

    Index:= ParseInt(Node.FieldValue['index'], -1);
    if (Index >= 0)and(Index < Length(Vertices)) then
     begin
      Vertices[Index].x:= ParseInt(VNode.FieldValue['x'], 0);
      Vertices[Index].y:= ParseInt(VNode.FieldValue['y'], 0);
     end;
   end;
end;

//---------------------------------------------------------------------------
function TPolygonShape.GetVertexCount(): Integer;
begin
 Result:= Length(Vertices);
end;

//---------------------------------------------------------------------------
function TPolygonShape.GetVertex(Num: Integer): PPoint2px;
begin
 if (Num >= 0)and(Num < Length(Vertices)) then
  Result:= @Vertices[Num] else Result:= nil;
end;

//---------------------------------------------------------------------------
function TPolygonShape.Add(const Point: TPoint2px): Integer;
var
 Num: Integer;
begin
 Num:= Length(Vertices);
 SetLength(Vertices, Num + 1);

 Vertices[Num]:= Point;
 Result:= Num;
end;

//---------------------------------------------------------------------------
function TPolygonShape.Add(x, y: Integer): Integer;
begin
 Result:= Add(Point2px(x, y));
end;

//---------------------------------------------------------------------------
procedure TPolygonShape.Remove(Num: Integer);
var
 i: Integer;
begin
 if (Num < 0)or(Num >= Length(Vertices)) then Exit;

 for i:= Num to Length(Vertices) - 2 do
  Vertices[i]:= Vertices[i + 1];

 SetLength(Vertices, Length(Vertices) - 1);
end;

//---------------------------------------------------------------------------
procedure TPolygonShape.Clear();
begin
 SetLength(Vertices, 0);
end;

//---------------------------------------------------------------------------
function TPolygonShape.BoundingBox(): TRect;
var
 i: Integer;
begin
 Result.Left  := High(Integer);
 Result.Right := Low(Integer);
 Result.Top   := High(Integer);
 Result.Bottom:= Low(Integer);

 for i:= 0 to Length(Vertices) - 1 do
  begin
   Result.Left  := Min2(Result.Left, Vertices[i].x);
   Result.Right := Max2(Result.Right, Vertices[i].x + 1);
   Result.Top   := Min2(Result.Top, Vertices[i].y);
   Result.Bottom:= Max2(Result.Bottom, Vertices[i].y + 1);
  end;
end;

//---------------------------------------------------------------------------
function TPolygonShape.PointInside(const Point: TPoint2px): Boolean;
var
 i, VertexCount: Integer;
 p1, p2: PPoint2px;
begin
 Result:= False;
 if (Length(Vertices) < 3)  then Exit;

 VertexCount:= Length(Vertices);

 p1:= @Vertices[0];
 for i:= 0 to VertexCount - 1 do
  begin
   p2:= @Vertices[(i + 1) mod VertexCount];
   if (Point.y > Min2(p1.y, p2.y)) then
     if (Point.y <= Max2(p1.y, p2.y)) then
       if (Point.x <= Max2(p1.x, p2.x)) then
         if (p1.y <> p2.y) then
          begin
           if (p1.x = p2.x)or(Point.x <= (Point.y - p1.y) * (p2.x - p1.x) div
            (p2.y - p1.y) + p1.x) then Result:= not Result;
          end;

   p1:= p2;
  end;
end;

//---------------------------------------------------------------------------
procedure TPolygonShape.MoveBy(const Shift: TPoint2px);
var
 i: Integer;
begin
 for i:= 0 to Length(Vertices) - 1 do
  Vertices[i]:= Vertices[i] + Shift;
end;

//---------------------------------------------------------------------------
procedure TPolygonShape.Rescale(const Delta: TPoint2px);
var
 i: Integer;
begin
 for i:= 0 to Length(Vertices) - 1 do
  begin
   Vertices[i].x:= iMul16(Vertices[i].x, Delta.x);
   Vertices[i].y:= iMul16(Vertices[i].y, Delta.y);
  end;
end;

//---------------------------------------------------------------------------
constructor TGuiShape.Create(const AName: string);
begin
 inherited Create();

 FName:= AName;
end;

//---------------------------------------------------------------------------
destructor TGuiShape.Destroy();
begin
 Clear();

 inherited;
end;

//---------------------------------------------------------------------------
function TGuiShape.GetCount(): Integer;
begin
 Result:= Length(Shapes);
end;

//---------------------------------------------------------------------------
function TGuiShape.GetShape(Num: Integer): TPolygonShape;
begin
 if (Num >= 0)and(Num < Length(Shapes)) then
  Result:= Shapes[Num] else Result:= nil;
end;

//---------------------------------------------------------------------------
function TGuiShape.Add(): TPolygonShape;
var
 Num: Integer;
begin
 Num:= Length(Shapes);
 SetLength(Shapes, Num + 1);

 Shapes[Num]:= TPolygonShape.Create();
 Result:= Shapes[Num];
end;

//---------------------------------------------------------------------------
procedure TGuiShape.Remove(Num: Integer);
var
 i: Integer;
begin
 if (Num < 0)or(Num >= Length(Shapes)) then Exit;

 Shapes[Num].Free();

 for i:= Num to Length(Shapes) - 2 do
  Shapes[i]:= Shapes[i + 1];

 SetLength(Shapes, Length(Shapes) - 1);
end;

//---------------------------------------------------------------------------
procedure TGuiShape.Clear();
var
 i: Integer;
begin
 for i:= 0 to Length(Shapes) - 1 do
  Shapes[i].Free();

 SetLength(Shapes, 0); 
end;

//---------------------------------------------------------------------------
function TGuiShape.GetBoundingBox(): TRect;
var
 i: Integer;
 ShapeRect: TRect;
begin
 Result.Left  := High(Integer);
 Result.Right := Low(Integer);
 Result.Top   := High(Integer);
 Result.Bottom:= Low(Integer);

 for i:= 0 to Length(Shapes) - 1 do
  begin
   ShapeRect:= Shapes[i].BoundingBox;

   Result.Left  := Min2(Result.Left, ShapeRect.Left);
   Result.Right := Max2(Result.Right, ShapeRect.Right);
   Result.Top   := Min2(Result.Top, ShapeRect.Top);
   Result.Bottom:= Max2(Result.Bottom, ShapeRect.Bottom);
  end;
end;

//---------------------------------------------------------------------------
function TGuiShape.GetPointInside(const Point: TPoint2px): Boolean;
var
 i: Integer;
begin
 Result:= False;

 for i:= 0 to Length(Shapes) - 1 do
  begin
   Result:= Result or Shapes[i].PointInside(Point);
   if (Result) then Break;
  end;
end;

//---------------------------------------------------------------------------
procedure TGuiShape.MakeRect(x, y, Width, Height: Integer);
var
 Poly: TPolygonShape;
begin
 Clear();

 Poly:= Add();
 Poly.Add(x, y);
 Poly.Add(x + Width - 1, y);
 Poly.Add(x + Width - 1, y + Height - 1);
 Poly.Add(x, y + Height - 1);
end;

//---------------------------------------------------------------------------
procedure TGuiShape.MoveBy(const Shift: TPoint2px);
var
 i: Integer;
begin
 for i:= 0 to Length(Shapes) - 1 do
  Shapes[i].MoveBy(Shift);
end;

//---------------------------------------------------------------------------
procedure TGuiShape.MoveBy(dx, dy: Integer);
begin
 MoveBy(Point2px(dx, dy));
end;

//---------------------------------------------------------------------------
procedure TGuiShape.AddPoly(Coords: array of Integer);
var
 Poly  : TPolygonShape;
 Vertex: TPoint2px;
 i     : Integer;
begin
 Poly:= Add();

 Vertex:= ZeroPoint2px;
 for i:= Low(Coords) to High(Coords) do
  begin
   if (i and $01 = $00) then
    Vertex.x:= Coords[i] else Vertex.y:= Coords[i];

   if (i and $01 = $01) then

   Poly.Add(Vertex);
  end;
end;

//---------------------------------------------------------------------------
function TGuiShape.Insert(Shape: TGeometryShape): Integer;
var
 Index: Integer;
begin
 Index:= Length(Shapes2);
 SetLength(Shapes2, Index + 1);

 Shapes2[Index]:= Shape;
 Result:= Index;
end;

//---------------------------------------------------------------------------
procedure TGuiShape.LoadFromXML(Node: TXMLNode);
var
 i: Integer;
 Shape: TGeometryShape;
 Child: TXMLNode;
 Move : TPoint2px;
 Scale: TPoint2px;
begin
 FName:= Node.FieldValue['name'];

 // load shapes
 for i:= 0 to Node.ChildCount - 1 do
  if (LowerCase(Node.Child[i].Name) = 'polygon') then
   begin
    Shape:= TPolygonShape.Create();
    Insert(Shape);

    Shape.LoadFromXML(Node.Child[i]);
   end;

 // -> "moveby" node
 Child:= Node.ChildNode['moveby'];
 if (Child <> nil) then
  begin
   Move.x:= ParseInt(Child.FieldValue['x'], 0);
   Move.y:= ParseInt(Child.FieldValue['y'], 0);
  end else Move:= ZeroPoint2px;

 // -> "rescale" node
 Child:= Node.ChildNode['rescale'];
 if (Child <> nil) then
  begin
   Scale.x:= ParseInt(Child.FieldValue['x'], 65536);
   Scale.y:= ParseInt(Child.FieldValue['y'], 65536);
  end else Scale:= Point2px(65536, 65536);

 // move and rescale shapes
 for i:= 0 to Length(Shapes) - 1 do
  begin
   Shapes[i].MoveBy(Move);
   Shapes[i].Rescale(Scale);
  end;
end;

//---------------------------------------------------------------------------
constructor TGuiShapes.Create();
begin
 inherited;

 List:= TAsphyreList.Create();
 List.OnFreeItem:= FreeItem;
 List.OnSortItem:= SortItem;
 List.OnFindItem:= FindItem;
end;

//---------------------------------------------------------------------------
destructor TGuiShapes.Destroy();
begin
 List.Free();

 inherited;
end;

//---------------------------------------------------------------------------
procedure TGuiShapes.FreeItem(List: TAsphyreList; Item: Pointer);
begin
 TGuiShape(Item).Free();
end;

//---------------------------------------------------------------------------
function TGuiShapes.SortItem(List: TAsphyreList; Item1,
 Item2: Pointer): Integer;
begin
 Result:= CompareText(TGuiShape(Item1).Name, TGuiShape(Item2).Name);
end;

//---------------------------------------------------------------------------
function TGuiShapes.FindItem(List: TAsphyreList; Item, User: Pointer): Integer;
begin
 Result:= CompareText(TGuiShape(Item).Name, PChar(User));
end;

//---------------------------------------------------------------------------
function TGuiShapes.GetCount(): Integer;
begin
 Result:= List.Count;
end;

//---------------------------------------------------------------------------
function TGuiShapes.GetItem(Index: Integer): TGuiShape;
begin
 Result:= TGuiShape(List[Index]);
end;

//---------------------------------------------------------------------------
function TGuiShapes.Insert(const Name: string): TGuiShape;
begin
 Result:= TGuiShape.Create(Name);
 List.Insert(Result);
end;

//---------------------------------------------------------------------------
function TGuiShapes.IndexOf(Shape: TGuiShape): Integer;
begin
 Result:= List.IndexOf(Shape);
end;

//---------------------------------------------------------------------------
procedure TGuiShapes.Remove(Index: Integer);
begin
 List.Remove(Index);
end;

//---------------------------------------------------------------------------
procedure TGuiShapes.Clear();
begin
 List.Clear();
end;

//---------------------------------------------------------------------------
function TGuiShapes.IndexOf(const Name: string): Integer;
begin
 Result:= List.FindBy(PChar(Name));
end;

//---------------------------------------------------------------------------
function TGuiShapes.GetShape(const Name: string): TGuiShape;
var
 Index: Integer;
begin
 Index:= IndexOf(Name);
 if (Index <> -1) then Result:= TGuiShape(List[Index]) else Result:= nil;
end;

//---------------------------------------------------------------------------
procedure TGuiShapes.ParseLink(const Link: string);
var
 nName: string;
 Root : TXMLNode;
 sName: string;
 Shape: TGuiShape;
 Text : string;
 i: Integer;
begin
 Root:= LoadLinkXML(Link);
 if (Root = nil) then Exit;

 if (LowerCase(Root.Name) <> 'unires')  then
  begin
   Root.Free();
   Exit;
  end;

 for i:= 0 to Root.ChildCount - 1 do
  begin
   nName:= LowerCase(Root.Child[i].Name);
   if (nName = 'shape') then
    begin
     sName:= LowerCase(Root.Child[i].FieldValue['name']);
     if (Length(sName) > 0) then
      begin
       Shape:= GetShape(sName);
       if (Shape = nil) then Shape:= Insert(sName);

       Shape.LoadFromXML(Root.Child[i]);
      end;
    end;

   if (nName = 'resource') then
    begin
     Text:= Root.Child[i].FieldValue['source'];
     if (Length(Text) > 0) then ParseLink(Text);
    end;
  end;

 Root.Free();
end;

//---------------------------------------------------------------------------
end.
