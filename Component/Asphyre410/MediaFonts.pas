unit MediaFonts;
//---------------------------------------------------------------------------
// MediaFonts.pas                                       Modified: 20-Feb-2007
// Resource management system for Asphyre fonts                   Version 1.0
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
// The Original Code is MediaFonts.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Windows, Direct3D9, D3DX9, Types, SysUtils, AsphyreXML, Vectors2px,
 MediaUtils
 {$IFDEF DebugMode}, AsphyreDebug{$ENDIF};

//---------------------------------------------------------------------------
type
 TFontCharInfo = record
  AsciiCode: Integer;
  Width    : Integer;
 end;

//---------------------------------------------------------------------------
 PFontDesc = ^TFontDesc;
 TFontDesc = record
  // valuse common to all fonts
  Identifier : string;
  DescType   : TFontDescType;

  // values specific to bitmap fonts
  Image      : string;
  PatSize    : TPoint2px;
  PatCount   : Integer;
  FirstLetter: Integer;
  Interleave : Integer;
  BlankSpace : Single;

  CharInfo   : array of TFontCharInfo;

  procedure ResetCharInfo();
  function InsertCharInfo(AsciiCode, Width: Integer): Integer;
 end;

//---------------------------------------------------------------------------
 TFontGroup = class
 private
  Data: array of TFontDesc;

  FName  : string;
  FOption: string;

  function GetCount(): Integer;
  function GetItem(Num: Integer): PFontDesc;
  function NewItem(): PFontDesc;
  procedure ParseItem(Node: TXMLNode);
  procedure ParseFulldesc(Desc: PFontDesc; Node: TXMLNode);
 public
  property Name: string read FName;
  property Option: string read FOption;

  property Count: Integer read GetCount;
  property Item[Num: Integer]: PFontDesc read GetItem; default;

  function Find(const Text: string): PFontDesc;
  procedure ParseXML(Node: TXMLNode);

  constructor Create(const AName: string);
 end;

//---------------------------------------------------------------------------
 TFontGroups = class
 private
  Data: array of TFontGroup;

  function GetCount(): Integer;
  function GetItem(Num: Integer): TFontGroup;
  function GetGroup(const Name: string): TFontGroup;
  function NewGroup(const Name: string): TFontGroup;
  function GetTotal(): Integer;
 public
  property Count: Integer read GetCount;
  property Item[Num: Integer]: TFontGroup read GetItem;
  property Group[const Name: string]: TFontGroup read GetGroup;

  property Total: Integer read GetTotal;

  function IndexOf(Name: string): Integer;
  procedure Clear();

  function Find(const uid: string; Option: string): PFontDesc;
  procedure ParseLink(const Link: string);

  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
var
 FontGroups: TFontGroups = nil;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
procedure TFontDesc.ResetCharInfo();
begin
 SetLength(CharInfo, 0);
end;

//---------------------------------------------------------------------------
function TFontDesc.InsertCharInfo(AsciiCode, Width: Integer): Integer;
var
 Index: Integer;
begin
 Index:= Length(CharInfo);
 SetLength(CharInfo, Index + 1);

 CharInfo[Index].AsciiCode:= AsciiCode;
 CharInfo[Index].Width    := Width;

 Result:= Index;
end;

//---------------------------------------------------------------------------
constructor TFontGroup.Create(const AName: string);
begin
 inherited Create();

 FName:= LowerCase(AName);
end;

//---------------------------------------------------------------------------
function TFontGroup.GetCount(): Integer;
begin
 Result:= Length(Data);
end;

//---------------------------------------------------------------------------
function TFontGroup.GetItem(Num: Integer): PFontDesc;
begin
 if (Num >= 0)and(Num < Length(Data)) then
  Result:= @Data[Num] else Result:= nil;
end;

//---------------------------------------------------------------------------
function TFontGroup.Find(const Text: string): PFontDesc;
var
 LoText: ShortString;
 i: Integer;
begin
 LoText:= LowerCase(Text);
 Result:= nil;

 for i:= 0 to Length(Data) - 1 do
  if (Data[i].Identifier = LoText) then
   begin
    Result:= @Data[i];
    Break;
   end;
end;

//---------------------------------------------------------------------------
function TFontGroup.NewItem(): PFontDesc;
var
 Index: Integer;
begin
 Index:= Length(Data);
 SetLength(Data, Index + 1);

 FillChar(Data[Index], SizeOf(TFontDesc), 0);
 Data[Index].ResetCharInfo();

 Result:= @Data[Index];
end;

//---------------------------------------------------------------------------
procedure TFontGroup.ParseFulldesc(Desc: PFontDesc; Node: TXMLNode);
var
 Aux, Child: TXMLNode;
 i: Integer;
begin
 if (LowerCase(Node.Name) <> 'fontdesc') then Exit;

 // (1) Parse "pattern" node
 Aux:= Node.ChildNode['pattern'];
 if (Aux <> nil) then
  begin
   Desc.PatSize.X:= ParseInt(Aux.FieldValue['width'], 0);
   Desc.PatSize.Y:= ParseInt(Aux.FieldValue['height'], 0);
   Desc.PatCount := ParseInt(Aux.FieldValue['count'], 0);
  end;

 {$IFDEF DebugMode}
 DebugLog('   --> with ' + IntToStr(Desc.PatCount) + ' of ' +
  IntToStr(Desc.PatSize.X) + 'x' + IntToStr(Desc.PatSize.Y));
 {$ENDIF}

 // (2) Parse "text" node
 Aux:= Node.ChildNode['text'];
 if (Aux <> nil) then
  begin
   Desc.FirstLetter:= ParseInt(Aux.FieldValue['first_letter'], 0);
   Desc.Interleave := ParseInt(Aux.FieldValue['interleave'], 0);
  end;

 {$IFDEF DebugMode}
 DebugLog('   --> first letter ' + IntToStr(Desc.FirstLetter) +
  ' and interleave of ' + IntToStr(Desc.Interleave));
 {$ENDIF}

 // (3) Parse "charinfo" node
 Aux:= Node.ChildNode['charinfo'];
 if (Aux <> nil) then
  for i:= 0 to Aux.ChildCount - 1 do
   if (LowerCase(Aux.Child[i].Name) = 'item') then
    begin
     Child:= Aux.Child[i];

     Desc.InsertCharInfo(ParseInt(Child.FieldValue['ascii_code'], 0),
      ParseInt(Child.FieldValue['width'], 0));
    end;
end;

//---------------------------------------------------------------------------
procedure TFontGroup.ParseItem(Node: TXMLNode);
var
 Desc: PFontDesc;
 Name: string;
 Root: TXMLNode;
begin
 // (1) Determine resource type.
 Name:= LowerCase(Node.Name);
 if (Name <> 'font') then Exit;

 // (2) Create image description.
 Desc:= NewItem();
 
 Desc.Identifier:= LowerCase(Node.FieldValue['uid']);
 Desc.DescType  := ParseFontType(LowerCase(Node.FieldValue['type']));
 Desc.Image     := LowerCase(Node.FieldValue['image']);
 Desc.BlankSpace:= ParseFloat(LowerCase(Node.FieldValue['space']));

 {$IFDEF DebugMode}
 DebugLog('  ++ Font described as "' + Desc.Identifier + '".');
 {$ENDIF}

 // (3) Parse full bitmap font description.
 if (Node.FieldValue['desc'] <> '') then
  begin
   Root:= LoadLinkXML(Node.FieldValue['desc']);
   if (Root <> nil) then
    begin
     ParseFulldesc(Desc, Root);
     Root.Free();
    end else
    begin
     {$IFDEF DebugMode}
     DebugLog('Failed loading font desc link: ' + Node.FieldValue['fulldesc']);
     {$ENDIF}
    end;
  end;
end;

//---------------------------------------------------------------------------
procedure TFontGroup.ParseXML(Node: TXMLNode);
var
 i: Integer;
begin
 if (LowerCase(Node.Name) <> 'font-group') then Exit;

 FName  := LowerCase(Node.FieldValue['name']);
 FOption:= LowerCase(Node.FieldValue['option']);

 {$IFDEF DebugMode}
 DebugLog(' + New font group "' + FName + '", option "' + FOption + '".');
 {$ENDIF}

 for i:= 0 to Node.ChildCount - 1 do
  ParseItem(Node.Child[i]);
end;

//---------------------------------------------------------------------------
destructor TFontGroups.Destroy();
begin
 Clear();

 inherited;
end;

//---------------------------------------------------------------------------
function TFontGroups.GetCount: Integer;
begin
 Result:= Length(Data);
end;

//---------------------------------------------------------------------------
function TFontGroups.GetItem(Num: Integer): TFontGroup;
begin
 if (Num >= 0)and(Num < Length(Data)) then
  Result:= Data[Num] else Result:= nil;
end;

//---------------------------------------------------------------------------
function TFontGroups.IndexOf(Name: string): Integer;
var
 i: Integer;
begin
 Name:= LowerCase(Name);
 Result:= -1;

 for i:= 0 to Length(Data) - 1 do
  if (Data[i].Name = Name) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
function TFontGroups.GetGroup(const Name: string): TFontGroup;
var
 Index: Integer;
begin
 Result:= nil;
 Index := IndexOf(Name);

 if (Index <> -1) then Result:= Data[Index];
end;

//---------------------------------------------------------------------------
procedure TFontGroups.Clear();
var
 i: Integer;
begin
 for i:= 0 to Length(Data) - 1 do
  if (Data[i] <> nil) then
   begin
    Data[i].Free();
    Data[i]:= nil;
   end;

 SetLength(Data, 0);
end;

//---------------------------------------------------------------------------
function TFontGroups.GetTotal(): Integer;
var
 i: Integer;
begin
 Result:= 0;

 for i:= 0 to Length(Data) - 1 do
  Inc(Result, Data[i].Count);
end;

//---------------------------------------------------------------------------
function TFontGroups.Find(const uid: string; Option: string): PFontDesc;
var
 i: Integer;
begin
 Result:= nil;
 Option:= LowerCase(Option);

 for i:= 0 to Length(Data) - 1 do
  if (Option = '')or(Data[i].Option = '')or(LowerCase(Data[i].Option) = Option) then
   begin
    Result:= Data[i].Find(uid);
    if (Result <> nil) then Break;
   end;
end;

//---------------------------------------------------------------------------
function TFontGroups.NewGroup(const Name: string): TFontGroup;
var
 Index: Integer;
begin
 Index:= Length(Data);
 SetLength(Data, Index + 1);

 Data[Index]:= TFontGroup.Create(Name);
 Result:= Data[Index];
end;

//---------------------------------------------------------------------------
procedure TFontGroups.ParseLink(const Link: string);
var
 nName: string;
 Root : TXMLNode;
 gName: string;
 Group: TFontGroup;
 Text : string;
 i: Integer;
begin
 {$IFDEF DebugMode}
 DebugLog('Begin entry [font groups]: ' + Link);
 {$ENDIF}

 Root:= LoadLinkXML(Link);
 if (Root = nil) then Exit;

 if (LowerCase(Root.Name) <> 'unires')  then
  begin
   {$IFDEF DebugMode}
   DebugLog('Root node is not UNIRES, exiting.');
   {$ENDIF}

   Root.Free();
   Exit;
  end;

 for i:= 0 to Root.ChildCount - 1 do
  begin
   nName:= LowerCase(Root.Child[i].Name);
   if (nName = 'font-group') then
    begin
     gName:= LowerCase(Root.Child[i].FieldValue['name']);
     if (Length(gName) > 0) then
      begin
       Group:= GetGroup(gName);
       if (Group = nil) then Group:= NewGroup(gName);

       Group.ParseXML(Root.Child[i]);
      end;
    end;

   if (nName = 'resource') then
    begin
     Text:= Root.Child[i].FieldValue['source'];
     if (Length(Text) > 0) then ParseLink(Text);
    end;
  end;

 Root.Free();

 {$IFDEF DebugMode}
 DebugLog('End entry [font groups]: ' + Link);
 {$ENDIF}
end;

//---------------------------------------------------------------------------
initialization
 FontGroups:= TFontGroups.Create();

//---------------------------------------------------------------------------
finalization
 FontGroups.Free();
 FontGroups:= nil;

//---------------------------------------------------------------------------
end.
