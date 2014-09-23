unit MediaImages;
//---------------------------------------------------------------------------
// MediaImages.pas                                      Modified: 08-Jan-2007
// Resource management utility for Asphyre images                 Version 1.0
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
// The Original Code is MediaImages.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Direct3D9, D3DX9, Types, SysUtils, AsphyreXML, MediaUtils
 {$IFDEF DebugMode}, AsphyreDebug{$ENDIF};

//---------------------------------------------------------------------------
type
 PImageDesc = ^TImageDesc;
 TImageDesc = record
  Identifier  : string;          // unique image identifier
  DescType    : TImageDescType;  // type of desc: image, surface or dynamic
  Format      : TD3DFormat;      // target pixel format
  MipLevels   : Cardinal;        // number of mipmap levels
  PatSize     : TPoint;          // pattern size
  PatCount    : Integer;         // number of patterns
  PatPadSize  : TPoint;          // pattern padding size
  ColorKey    : Cardinal;        // color key, unused if alpha > 0
  DepthStencil: Boolean;         // whether to use depth/stencil buffer
  Size        : TPoint;          // the size of surface/dynamic texture
  Textures    : array of string; // the location of textures used in the image
 end;

//---------------------------------------------------------------------------
 TImageGroup = class
 private
  Data: array of TImageDesc;

  FName  : string;
  FOption: string;

  function GetCount(): Integer;
  function GetItem(Num: Integer): PImageDesc;
  function NewItem(): PImageDesc;
  procedure ParseItem(Node: TXMLNode);
 public
  property Name: string read FName;
  property Option: string read FOption;

  property Count: Integer read GetCount;
  property Item[Num: Integer]: PImageDesc read GetItem; default;

  function Find(const Text: string): PImageDesc;
  procedure ParseXML(Node: TXMLNode);

  constructor Create(const AName: string);
 end;

//---------------------------------------------------------------------------
 TImageGroups = class
 private
  Data: array of TImageGroup;

  function GetCount(): Integer;
  function GetItem(Num: Integer): TImageGroup;
  function GetGroup(const Name: string): TImageGroup;
  function NewGroup(const Name: string): TImageGroup;
  function GetTotal(): Integer;
 public
  property Count: Integer read GetCount;
  property Item[Num: Integer]: TImageGroup read GetItem;
  property Group[const Name: string]: TImageGroup read GetGroup;

  property Total: Integer read GetTotal;

  function IndexOf(Name: string): Integer;
  procedure Clear();

  function Find(const uid: string; Option: string): PImageDesc;
  procedure ParseLink(const Link: string);

  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
var
 ImageGroups: TImageGroups = nil;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
constructor TImageGroup.Create(const AName: string);
begin
 inherited Create();

 FName:= LowerCase(AName);
end;

//---------------------------------------------------------------------------
function TImageGroup.GetCount(): Integer;
begin
 Result:= Length(Data);
end;

//---------------------------------------------------------------------------
function TImageGroup.GetItem(Num: Integer): PImageDesc;
begin
 if (Num >= 0)and(Num < Length(Data)) then
  Result:= @Data[Num] else Result:= nil;
end;

//---------------------------------------------------------------------------
function TImageGroup.Find(const Text: string): PImageDesc;
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
function TImageGroup.NewItem(): PImageDesc;
var
 Index: Integer;
begin
 Index:= Length(Data);
 SetLength(Data, Index + 1);

 FillChar(Data[Index], SizeOf(TImageDesc), 0);

 // configure defaults
 Data[Index].Format      := D3DFMT_UNKNOWN;
 Data[Index].MipLevels   := D3DX_DEFAULT;
 Data[Index].DepthStencil:= False;
 Data[Index].DescType    := idtImage;
 Data[Index].PatCount    := 1;

 Result:= @Data[Index];
end;

//---------------------------------------------------------------------------
procedure TImageGroup.ParseItem(Node: TXMLNode);
var
 Desc  : PImageDesc;
 Aux   : TXMLNode;
 Name  : string;
 i, Num: Integer;
 Child : TXMLNode;
begin
 // (1) Determine resource type.
 Name:= LowerCase(Node.Name);
 if (Name <> 'image') then Exit;

 // (2) Create image description.
 Desc:= NewItem();
 Desc.Identifier:= LowerCase(Node.FieldValue['uid']);
 Desc.DescType  := ParseImageType(LowerCase(Node.FieldValue['type']));

 {$IFDEF DebugMode}
 DebugLog('  ++ Image described as "' + Desc.Identifier + '".');
 {$ENDIF}

 // (3) Parse "format" node.
 Aux:= Node.ChildNode['format'];
 if (Aux <> nil) then
  begin
   Desc.Format   := ParseFormat(LowerCase(Aux.FieldValue['type']));
   Desc.MipLevels:= ParseCardinal(LowerCase(Aux.FieldValue['miplevels']),
    D3DX_DEFAULT);
   Desc.DepthStencil:= ParseBoolean(LowerCase(Aux.FieldValue['depthstencil']));
  end;

 // (4) Parse "pattern" node
 Aux:= Node.ChildNode['pattern'];
 if (Aux <> nil) then
  begin
   Desc.PatSize.X   := ParseInt(Aux.FieldValue['width'], 0);
   Desc.PatSize.Y   := ParseInt(Aux.FieldValue['height'], 0);
   Desc.PatCount    := ParseInt(Aux.FieldValue['count'], 1);
   Desc.PatPadSize.X:= ParseInt(Aux.FieldValue['padx'], 0);
   Desc.PatPadSize.Y:= ParseInt(Aux.FieldValue['pady'], 0);
  end;

 {$IFDEF DebugMode}
 DebugLog('   -> Pattern Size: ' + IntToStr(Desc.PatSize.X) + 'x' +
  IntToStr(Desc.PatSize.Y));
 DebugLog('   -> Number of patterns: ' + IntToStr(Desc.PatCount));
 {$ENDIF}

 // (5) Parse "colorkey" node.
 Aux:= Node.ChildNode['colorkey'];
 if (Aux <> nil) then
  Desc.ColorKey:= ParseColor(LowerCase(Aux.FieldValue['value']), 0);

 // (6) Parse "textures" node.
 Aux:= Node.ChildNode['textures'];
 if (Aux <> nil) then
  begin
   SetLength(Desc.Textures, ParseInt(Aux.FieldValue['count'], 1));

   {$IFDEF DebugMode}
   DebugLog('   -> Having ' + IntToStr(Length(Desc.Textures)) +
    ' textures in total.');
   {$ENDIF}

   for i:= 0 to Aux.ChildCount - 1 do
    begin
     Child:= Aux.Child[i];

     Num:= ParseInt(Child.FieldValue['num']);
     if (Num >= 0)and(Num < Length(Desc.Textures)) then
      Desc.Textures[Num]:= LowerCase(Child.FieldValue['source']);

     {$IFDEF DebugMode}
     DebugLog('   --> Using texture #' + IntToStr(Num) + ' from: ' +
      Desc.Textures[Num]);
     {$ENDIF}
    end;
  end;

 // (7) Parse "size" node.
 Aux:= Node.ChildNode['size'];
 if (Aux <> nil) then
  begin
   Desc.Size.X:= ParseInt(Aux.FieldValue['width'], 0);
   Desc.Size.Y:= ParseInt(Aux.FieldValue['height'], 0);

   {$IFDEF DebugMode}
   DebugLog('   -> Size defined as ' + IntToStr(Desc.Size.X) + 'x' +
    IntToStr(Desc.Size.Y));
   {$ENDIF}
  end;
end;

//---------------------------------------------------------------------------
procedure TImageGroup.ParseXML(Node: TXMLNode);
var
 i: Integer;
begin
 if (LowerCase(Node.Name) <> 'image-group') then Exit;

 FName  := LowerCase(Node.FieldValue['name']);
 FOption:= LowerCase(Node.FieldValue['option']);

 {$IFDEF DebugMode}
 DebugLog(' + New image group "' + FName + '", option "' + FOption + '".');
 {$ENDIF}

 for i:= 0 to Node.ChildCount - 1 do
  ParseItem(Node.Child[i]);
end;

//---------------------------------------------------------------------------
destructor TImageGroups.Destroy();
begin
 Clear();

 inherited;
end;

//---------------------------------------------------------------------------
function TImageGroups.GetCount: Integer;
begin
 Result:= Length(Data);
end;

//---------------------------------------------------------------------------
function TImageGroups.GetItem(Num: Integer): TImageGroup;
begin
 if (Num >= 0)and(Num < Length(Data)) then
  Result:= Data[Num] else Result:= nil;
end;

//---------------------------------------------------------------------------
function TImageGroups.IndexOf(Name: string): Integer;
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
function TImageGroups.GetGroup(const Name: string): TImageGroup;
var
 Index: Integer;
begin
 Result:= nil;
 Index := IndexOf(Name);

 if (Index <> -1) then Result:= Data[Index];
end;

//---------------------------------------------------------------------------
procedure TImageGroups.Clear();
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
function TImageGroups.GetTotal(): Integer;
var
 i: Integer;
begin
 Result:= 0;

 for i:= 0 to Length(Data) - 1 do
  Inc(Result, Data[i].Count);
end;

//---------------------------------------------------------------------------
function TImageGroups.Find(const uid: string; Option: string): PImageDesc;
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
function TImageGroups.NewGroup(const Name: string): TImageGroup;
var
 Index: Integer;
begin
 Index:= Length(Data);
 SetLength(Data, Index + 1);

 Data[Index]:= TImageGroup.Create(Name);
 Result:= Data[Index];
end;

//---------------------------------------------------------------------------
procedure TImageGroups.ParseLink(const Link: string);
var
 nName: string;
 Root : TXMLNode;
 gName: string;
 Group: TImageGroup;
 Text : string;
 i: Integer;
begin
 {$IFDEF DebugMode}
 DebugLog('Begin entry [image groups]: ' + Link);
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
   if (nName = 'image-group') then
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
 DebugLog('End entry [image groups]: ' + Link);
 {$ENDIF}
end;

//---------------------------------------------------------------------------
initialization
 ImageGroups:= TImageGroups.Create();

//---------------------------------------------------------------------------
finalization
 ImageGroups.Free();
 ImageGroups:= nil;

//---------------------------------------------------------------------------
end.
