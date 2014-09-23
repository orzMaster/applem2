unit GuiObjects;
//---------------------------------------------------------------------------
// GuiObjects.pas                                       Modified: 03-Mar-2007
// The basic self-contained GUI object implementation             Version 1.0
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
// The Original Code is GuiObjects.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Types, SysUtils, Vectors2px, AsphyreXML, AsphyreTypes, MediaUtils, GuiTypes,
 AsphyreFonts;

//---------------------------------------------------------------------------
type
 PGuiProperty = ^TGuiProperty;
 TGuiProperty = record
  Code : Cardinal;
  Name : string;
  DType: TGuiDataType;
 end;

//---------------------------------------------------------------------------
 TGuiCustomObject = class
 private
  Properties: array of TGuiProperty;

  procedure SortProperties(Left, Right: Integer);
 protected
  function IndexOfProperty(const Name: string): Integer;
  function GetProperty(Index: Integer): PGuiProperty;

  procedure Describe(Code: Cardinal; const Name: string; DType: TGuiDataTYpe);
  procedure DoDescribe(); virtual;

  procedure WriteProperty(Code: Cardinal; Source: Pointer); virtual;
 public

  constructor Create();
 end;

//---------------------------------------------------------------------------
 TGuiObject = class(TGuiCustomObject)
 private
  FOwner: TGuiObject;
  FName : string;

  Children : array of TGuiObject;
  NoExclude: Boolean;

  SearchDirty: Boolean;
  SearchIndex: array of Integer;

  function GetChildCount(): Integer;
  function GetChild(Index: Integer): TGuiObject;
  function Insert(Component: TGuiObject): Integer;
  procedure Remove(Index: Integer);

  procedure SetName(const Value: string);
  function GetCtrl(const Name: string): TGuiObject;

  procedure FillSearchIndex();
  procedure SortSearchIndex(Left, Right: Integer);
  procedure MakeSearchIndex();
  function Include(Obj: TGuiObject): Integer;
  procedure Exclude(Obj: TGuiObject);
  function GetRootNode(): TGuiObject;
 protected
  procedure MarkSearchDirty();
  procedure MoveToFront(Index: Integer); virtual;
  procedure MoveToBack(Index: Integer); virtual;

  procedure DoDestroy(); virtual;
  procedure DoObjectLinked(Index: Integer; Obj: TGuiObject); virtual;
  procedure DoObjectUnlinked(Index: Integer; Obj: TGuiObject); virtual;

  procedure DoDescribe(); override;
  procedure WriteProperty(Code: Cardinal; Source: Pointer); override;
 public
  property Owner: TGuiObject read FOwner;
  property Name : string read FName write SetName;

  property ChildCount: Integer read GetChildCount;
  property Child[Index: Integer]: TGuiObject read GetChild;

  property RootNode: TGuiObject read GetRootNode;

  property Ctrl[const Name: string]: TGuiObject read GetCtrl; default;

  function IndexOf(Obj: TGuiObject): Integer; overload;
  function IndexOf(Name: string): Integer; overload;
  procedure RemoveAll();

  procedure LoadFromXML(Parent: TXMLNode);
  procedure ParseLink(const Link: string);

  constructor Create(AOwner: TGuiObject); virtual;
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 GuiSkins, GuiRegistry;

//---------------------------------------------------------------------------
const
 PropInc  = 16;
 PropBase = $10;

//---------------------------------------------------------------------------
function ParseFontOptions(Node: TXMLNode): TFontOptions;
var
 Aux: TXMLNode;
begin
 Result.Reset();

 // -> "shadow" node
 Aux:= Node.ChildNode['shadow'];
 if (Aux <> nil) then
  begin
   Result.ShowShadow   := ParseBoolean(LowerCase(Aux.FieldValue['show']), False);
   Result.ShadowAlpha  := ParseInt(Aux.FieldValue['alpha'], 128);
   Result.ShadowDepth.x:= ParseInt(Aux.FieldValue['dx'], 2);
   Result.ShadowDepth.y:= ParseInt(Aux.FieldValue['dy'], 2);
  end;

 // -> "text" node
 Aux:= Node.ChildNode['text'];
 if (Aux <> nil) then
  begin
   Result.Kerning:= ParseInt(Aux.FieldValue['kerning'], 0);
   Result.Scale  := ParseInt(Aux.FieldValue['scale'], 65536);
   Result.Shift.x:= ParseInt(Aux.FieldValue['dx'], 0);
   Result.Shift.y:= ParseInt(Aux.FieldValue['dy'], 0);
  end;
end;

//---------------------------------------------------------------------------
constructor TGuiCustomObject.Create();
begin
 inherited;

 DoDescribe();
 if (Length(Properties) > 0) then SortProperties(0, Length(Properties) - 1);
end;

//---------------------------------------------------------------------------
function TGuiCustomObject.GetProperty(Index: Integer): PGuiProperty;
begin
 if (Index >= 0)and(Index < Length(Properties)) then
  Result:= @Properties[Index] else Result:= nil;
end;

//---------------------------------------------------------------------------
procedure TGuiCustomObject.Describe(Code: Cardinal; const Name: string;
 DType: TGuiDataTYpe);
var
 Index: Integer;
begin
 Index:= Length(Properties);
 SetLength(Properties, Index + 1);

 Properties[Index].Code := Code;
 Properties[Index].Name := Name;
 Properties[Index].DType:= DType;
end;

//---------------------------------------------------------------------------
procedure TGuiCustomObject.DoDescribe();
begin
 // no code
end;

//---------------------------------------------------------------------------
procedure TGuiCustomObject.WriteProperty(Code: Cardinal; Source: Pointer);
begin
 // no code
end;

//---------------------------------------------------------------------------
procedure TGuiCustomObject.SortProperties(Left, Right: Integer);
var
 Lo, Hi  : Integer;
 TempProp: TGuiProperty;
 MidValue: string;
begin
 Lo:= Left;
 Hi:= Right;
 MidValue:= Properties[(Left + Right) div 2].Name;

 repeat
  while (CompareText(Properties[Lo].Name, MidValue) < 0) do Inc(Lo);
  while (CompareText(Properties[Hi].Name, MidValue) > 0) do Dec(Hi);

  if (Lo <= Hi) then
   begin
    TempProp:= Properties[Lo];
    Properties[Lo]:= Properties[Hi];
    Properties[Hi]:= TempProp;

    Inc(Lo);
    Dec(Hi);
   end;
 until (Lo > Hi);

 if (Left < Hi) then SortProperties(Left, Hi);
 if (Lo < Right) then SortProperties(Lo, Right);
end;

//---------------------------------------------------------------------------
function TGuiCustomObject.IndexOfProperty(const Name: string): Integer;
var
 Lo, Hi, Mid, CompRes: Integer;
begin
 Result:= -1;

 Lo:= 0;
 Hi:= Length(Properties) - 1;

 while (Lo <= Hi) do
  begin
   Mid:= (Lo + Hi) div 2;

   CompRes:= CompareText(Properties[Mid].Name, Name);
   if (CompRes = 0) then
    begin
     Result:= Mid;
     Break;
    end;

   if (CompRes > 0) then Hi:= Mid - 1 else Lo:= Mid + 1;
 end;
end;

//---------------------------------------------------------------------------
constructor TGuiObject.Create(AOwner: TGuiObject);
begin
 inherited Create();

 NoExclude  := False;
 SearchDirty:= False;

 FOwner:= AOwner;
 if (FOwner <> nil) then FOwner.Include(Self);
end;

//---------------------------------------------------------------------------
destructor TGuiObject.Destroy();
begin
 RemoveAll();

 DoDestroy();

 if (FOwner <> nil)and(not NoExclude) then FOwner.Exclude(Self);

 inherited;
end;

//---------------------------------------------------------------------------
procedure TGuiObject.DoDestroy();
begin
 // no code
end;

//---------------------------------------------------------------------------
procedure TGuiObject.DoObjectLinked(Index: Integer; Obj: TGuiObject);
begin
 // no code
end;

//---------------------------------------------------------------------------
procedure TGuiObject.DoObjectUnlinked(Index: Integer; Obj: TGuiObject);
begin
 // no code
end;

//---------------------------------------------------------------------------
function TGuiObject.GetChildCount(): Integer;
begin
 Result:= Length(Children);
end;

//---------------------------------------------------------------------------
function TGuiObject.GetChild(Index: Integer): TGuiObject;
begin
 if (Index >= 0)and(Index < Length(Children)) then
  Result:= Children[Index] else Result:= nil;
end;

//---------------------------------------------------------------------------
function TGuiObject.IndexOf(Obj: TGuiObject): Integer;
var
 i: Integer;
begin
 Result:= -1;
 for i:= 0 to Length(Children) - 1 do
  if (Children[i] = Obj) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
function TGuiObject.Insert(Component: TGuiObject): Integer;
var
 Index: Integer;
begin
 Index:= Length(Children);
 SetLength(Children, Index + 1);

 Children[Index]:= Component;
 Result:= Index;
end;

//---------------------------------------------------------------------------
function TGuiObject.Include(Obj: TGuiObject): Integer;
begin
 Result:= IndexOf(Obj);
 if (Result = -1) then
  begin
   Result:= Insert(Obj);
   DoObjectLinked(Result, Obj);
  end;
end;

//---------------------------------------------------------------------------
procedure TGuiObject.Remove(Index: Integer);
var
 i: Integer;
begin
 if (Index < 0)or(Index >= Length(Children)) then Exit;

 for i:= Index to Length(Children) - 2 do
  Children[i]:= Children[i + 1];

 SetLength(Children, Length(Children) - 1);
end;

//---------------------------------------------------------------------------
procedure TGuiObject.Exclude(Obj: TGuiObject);
var
 Index: Integer;
begin
 Index:= IndexOf(Obj);

 if (Index <> -1) then
  begin
   Remove(Index);
   DoObjectUnlinked(Index, Obj);
  end;
end;

//---------------------------------------------------------------------------
procedure TGuiObject.RemoveAll();
var
 i: Integer;
begin
 for i:= 0 to Length(Children) - 1 do
  if (Children[i] <> nil) then
   begin
    Children[i].NoExclude:= True;
    Children[i].Free();
    Children[i]:= nil;
   end;

 SetLength(Children, 0);
end;

//---------------------------------------------------------------------------
procedure TGuiObject.SetName(const Value: string);
begin
 FName:= Value;
 if (FOwner <> nil) then FOwner.MarkSearchDirty();
end;

//---------------------------------------------------------------------------
procedure TGuiObject.MoveToBack(Index: Integer);
var
 Temp: TGuiObject;
 i: Integer;
begin
 Temp:= Children[Index];

 for i:= Index to Length(Children) - 2 do
  Children[i]:= Children[i + 1];

 Children[Length(Children) - 1]:= Temp;
end;

//---------------------------------------------------------------------------
procedure TGuiObject.MoveToFront(Index: Integer);
var
 Temp: TGuiObject;
 i: Integer;
begin
 Temp:= Children[Index];

 for i:= Index downto 1 do
  Children[i]:= Children[i - 1];

 Children[0]:= Temp;
end;

//---------------------------------------------------------------------------
procedure TGuiObject.MarkSearchDirty();
begin
 SearchDirty:= Length(Children) > 1;
end;

//---------------------------------------------------------------------------
procedure TGuiObject.FillSearchIndex();
var
 i: Integer;
begin
 SetLength(SearchIndex, Length(Children));

 for i:= 0 to Length(SearchIndex) - 1 do
  SearchIndex[i]:= i;
end;

//---------------------------------------------------------------------------
procedure TGuiObject.SortSearchIndex(Left, Right: Integer);
var
 Lo, Hi: Integer;
 TempIndex: Integer;
 MidValue: string;
begin
 Lo:= Left;
 Hi:= Right;
 MidValue:= Children[SearchIndex[(Left + Right) shr 1]].Name;

 repeat
  while (CompareText(Children[SearchIndex[Lo]].Name, MidValue) < 0) do Inc(Lo);
  while (CompareText(Children[SearchIndex[Hi]].Name, MidValue) > 0) do Dec(Hi);

  if (Lo <= Hi) then
   begin
    TempIndex:= SearchIndex[Lo];
    SearchIndex[Lo]:= SearchIndex[Hi];
    SearchIndex[Hi]:= TempIndex;

    Inc(Lo);
    Dec(Hi);
   end;
 until (Lo > Hi);

 if (Left < Hi) then SortSearchIndex(Left, Hi);
 if (Lo < Right) then SortSearchIndex(Lo, Right);
end;

//---------------------------------------------------------------------------
procedure TGuiObject.MakeSearchIndex();
begin
 FillSearchIndex();

 if (Length(SearchIndex) > 1) then
  SortSearchIndex(0, Length(SearchIndex) - 1);

 SearchDirty:= False;
end;

//---------------------------------------------------------------------------
function TGuiObject.IndexOf(Name: string): Integer;
var
 Lo, Hi, Mid, CompRes: Integer;
begin
 if (SearchDirty) then MakeSearchIndex();

 Name  := LowerCase(Name);
 Result:= -1;

 Lo:= 0;
 Hi:= Length(SearchIndex) - 1;

 while (Lo <= Hi) do
  begin
   Mid:= (Lo + Hi) div 2;

   CompRes:= CompareText(Children[SearchIndex[Mid]].Name, Name);
   if (CompRes = 0) then
    begin
     Result:= SearchIndex[Mid];
     Break;
    end;

   if (CompRes > 0) then Hi:= Mid - 1 else Lo:= Mid + 1;
 end;
end;

//---------------------------------------------------------------------------
function TGuiObject.GetCtrl(const Name: string): TGuiObject;
var
 i, Index: Integer;
begin
 if (CompareText(FName, Name) = 0) then
  begin
   Result:= Self;
   Exit;
  end;

 Index:= IndexOf(Name);
 if (Index <> -1) then
  begin
   Result:= Children[Index];
   Exit;
  end;

 Result:= nil;
 for i:= 0 to Length(Children) - 1 do
  begin
   Result:= Children[i].Ctrl[Name];
   if (Result <> nil) then Break;
  end;
end;

//---------------------------------------------------------------------------
function TGuiObject.GetRootNode(): TGuiObject;
begin
 Result:= Self;
 while (Result.Owner <> nil) do Result:= Result.Owner;
end;

//---------------------------------------------------------------------------
procedure TGuiObject.DoDescribe();
begin
 Describe(PropBase + $0, 'Name', gdtString);
end;

//---------------------------------------------------------------------------
procedure TGuiObject.WriteProperty(Code: Cardinal; Source: Pointer);
begin
 case Code of
  PropBase + $0:
   FName:= PChar(Source);
 end;
end;

//---------------------------------------------------------------------------
procedure TGuiObject.LoadFromXML(Parent: TXMLNode);
var
 i: Integer;
 NodeName: string;
 Ctrl : TGuiObject;
 Node: TXMLNode;
 Prop: PGuiProperty;
 Value : Integer;
 VReal : Real;
 VText : string;
 VPoint: TPoint2px;
 VSize : TPoint2px;
 VRect : TRect;
 VCol2 : TColor2;
 VFOpt : TFontOptions;
 VSkin : TGuiSkin;
 VFCol : TGuiFontCol;
begin
 FName:= Parent.FieldValue['name'];

 for i:= 0 to Parent.ChildCount - 1 do
  begin
   Node:= Parent.Child[i];
   NodeName:= LowerCase(Node.Name);

   if (NodeName = 'property') then
    begin
     Prop:= GetProperty(IndexOfProperty(Node.FieldValue['name']));
     if (Prop = nil) then Continue;

     case Prop.DType of
      gdtInteger:
       begin
        Value:= ParseInt(Node.FieldValue['value'], 0);
        WriteProperty(Prop.Code, @Value);
       end;

      gdtCardinal:
       begin
        Value:= Integer(ParseCardinal(Node.FieldValue['value'], 0));
        WriteProperty(Prop.Code, @Value);
       end;

      gdtReal:
       begin
        VReal:= ParseFloat(Node.FieldValue['value'], 0.0);
        WriteProperty(Prop.Code, @VReal);
       end;

      gdtString:
       begin
        VText:= Node.FieldValue['text'];
        WriteProperty(Prop.Code, PChar(VText));
       end;

      gdtBoolean:
       begin
        Value:= Integer(ParseBoolean(Node.FieldValue['value']));
        WriteProperty(Prop.Code, @Value);
       end;

      gdtPoint:
       begin
        VPoint.x:= ParseInt(Node.FieldValue['x'], 0);
        VPoint.y:= ParseInt(Node.FieldValue['y'], 0);
        WriteProperty(Prop.Code, @VPoint);
       end;

      gdtRect:
       begin
        VPoint.x:= ParseInt(Node.FieldValue['x'], 0);
        VPoint.y:= ParseInt(Node.FieldValue['y'], 0);
        VSize.x := ParseInt(Node.FieldValue['width'], 0);
        VSize.y := ParseInt(Node.FieldValue['height'], 0);
        VRect   := Bounds(VPoint.x, VPoint.y, VSize.x, VSize.y);
        WriteProperty(Prop.Code, @VRect);
       end;

      gdtColor:
       begin
        Value:= Integer(ParseColorField(Node));
        WriteProperty(Prop.Code, @Value);
       end;

      gdtColor2:
       begin
        VCol2:= ParseColor2Field(Node);
        WriteProperty(Prop.Code, @VCol2);
       end;

      gdtHAlign:
       begin
        Value:= Integer(ParseHAlign(LowerCase(Node.FieldValue['align'])));
        WriteProperty(Prop.Code, @Value);
       end;

      gdtVAlign:
       begin
        Value:= Integer(ParseVAlign(LowerCase(Node.FieldValue['align'])));
        WriteProperty(Prop.Code, @Value);
       end;

      gdtFontOpt:
       begin
        VFOpt:= ParseFontOptions(Node);
        WriteProperty(Prop.Code, @VFOpt);
       end;

     gdtSkin:
      begin
       VSkin:= TGuiSkin.Create();
       VSkin.LoadFromXML(Node);
       WriteProperty(Prop.Code, VSkin);
       VSkin.Free();
      end;

     gdtFontColor:
      begin
       VFCol:= TGuiFontCol.Create();
       VFCol.LoadFromXML(Node);
       WriteProperty(Prop.Code, VFCol);
       VFCol.Free();
      end;
     end; // case
    end; // if Property
   if (NodeName = 'control') then
    begin
     Ctrl:= CreateGuiClass(LowerCase(Node.FieldValue['class']), Self);
     if (Ctrl <> nil) then Ctrl.LoadFromXML(Node);
    end;
  end;
end;

//---------------------------------------------------------------------------
procedure TGuiObject.ParseLink(const Link: string);
var
 NodeName: string;
 Root : TXMLNode;
 Child: TXMLNode;
 Ctrl : TGuiObject;
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
   if (NodeName = 'agui') then
    for j:= 0 to Root.Child[i].ChildCount - 1 do
     begin
      Child:= Root.Child[i].Child[j];
      if (LowerCase(Child.Name) = 'control') then
       begin
        Ctrl:= CreateGuiClass(LowerCase(Child.FieldValue['class']), Self);
        if (Ctrl <> nil) then Ctrl.LoadFromXML(Child);
       end;
     end;

   if (NodeName = 'resource') then
    begin
     Text:= Root.Child[i].FieldValue['source'];
     if (Length(Text) > 0) then ParseLink(Text);
    end;
  end;

 Root.Free();
end;

//---------------------------------------------------------------------------
end.
