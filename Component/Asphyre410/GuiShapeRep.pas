unit GuiShapeRep;
//---------------------------------------------------------------------------
// GuiShapes.pas                                        Modified: 01-Mar-2007
// Freeform shapes for Asphyre GUI foundation                     Version 1.0
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
// The Original Code is GuiShapeRep.pas.
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
 public
  function PointInside(const Point: TPoint2px): Boolean; override;
  function BoundingBox(): TRect; override;
  procedure MoveBy(const Shift: TPoint2px); override;
  procedure Rescale(const Delta: TPoint2px); override;

  procedure LoadFromXML(Node: TXMLNode); override;
 end;

//---------------------------------------------------------------------------
 TGuiShape = class
 private
  FName : string;
  Shapes: array of TGeometryShape;

  function Insert(Shape: TGeometryShape): Integer;

  procedure ReleaseAll();
 public
  property Name: string read FName;

  function PointInside(const Point: TPoint2px): Boolean;
  function BoundingBox(): TRect;

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
var
 GuiShapes: TGuiShapes = nil;

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

    Index:= ParseInt(VNode.FieldValue['index'], -1);
    if (Index >= 0)and(Index < Length(Vertices)) then
     begin
      Vertices[Index].x:= ParseInt(VNode.FieldValue['x'], 0);
      Vertices[Index].y:= ParseInt(VNode.FieldValue['y'], 0);
     end;
   end;
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
 ReleaseAll();

 inherited;
end;

//---------------------------------------------------------------------------
procedure TGuiShape.ReleaseAll();
var
 i: Integer;
begin
 for i:= 0 to Length(Shapes) - 1 do
  Shapes[i].Free();

 SetLength(Shapes, 0);
end;

//---------------------------------------------------------------------------
function TGuiShape.BoundingBox(): TRect;
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
function TGuiShape.PointInside(const Point: TPoint2px): Boolean;
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
function TGuiShape.Insert(Shape: TGeometryShape): Integer;
var
 Index: Integer;
begin
 Index:= Length(Shapes);
 SetLength(Shapes, Index + 1);

 Shapes[Index]:= Shape;
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
 NodeName : string;
 ShapeName: string;
 Root : TXMLNode;
 Child: TXMLNode;
 Shape: TGuiShape;
 Text : string;
 i, j: Integer;
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
   NodeName:= LowerCase(Root.Child[i].Name);
   if (NodeName = 'shapes') then
    for j:= 0 to Root.Child[i].ChildCount - 1 do
     begin
      Child:= Root.Child[i].Child[j];
      if (LowerCase(Child.Name) = 'shape') then
       begin
        ShapeName:= LowerCase(Child.FieldValue['name']);
        if (Length(ShapeName) > 0) then
         begin
          Shape:= GetShape(ShapeName);
          if (Shape = nil) then Shape:= Insert(ShapeName);

          Shape.LoadFromXML(Child);
         end; // if
       end; // if
     end; // for

   if (NodeName = 'resource') then
    begin
     Text:= Root.Child[i].FieldValue['source'];
     if (Length(Text) > 0) then ParseLink(Text);
    end;
  end;

 Root.Free();
end;

//---------------------------------------------------------------------------
initialization
 GuiShapes:= TGuiShapes.Create();

//---------------------------------------------------------------------------
finalization
 GuiShapes.Free();
 GuiShapes:= nil;

//---------------------------------------------------------------------------
end.
