unit AsphyreXML;
//---------------------------------------------------------------------------
// AsphyreXML.pas                                       Modified: 08-Jan-2007
// Asphyre XML wrapper                                            Version 1.0
//---------------------------------------------------------------------------
// Note: This component doesn't read or write data parts of XML and is
// primarily used to read nodes and their attributes only. This is because
// Asphyre does not use data parts of XML files.
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
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Types, Classes, SysUtils, LibXMLParser;

//---------------------------------------------------------------------------
type
 PXMLNodeField = ^TXMLNodeField;
 TXMLNodeField = record
  Name : string;
  Value: string;
 end;

//---------------------------------------------------------------------------
 TXMLNode = class
 private
  FName: string;
  Nodes: array of TXMLNode;
  Fields: array of TXMLNodeField;

  function GetChildCount(): Integer;
  function GetChild(Num: Integer): TXMLNode;
  function GetChildNode(const Name: string): TXMLNode;
  function GetFieldCount(): Integer;
  function GetField(Num: Integer): PXMLNodeField;
  function GetFieldValue(const Name: string): Variant;
  procedure SetFieldValue(const Name: string; const Value: Variant);
  function SubCode(Spacing: Integer): string;
 public
  property Name: string read FName;

  property ChildCount: Integer read GetChildCount;
  property Child[Num: Integer]: TXMLNode read GetChild;
  property ChildNode[const Name: string]: TXMLNode read GetChildNode;

  property FieldCount: Integer read GetFieldCount;
  property Field[Num: Integer]: PXMLNodeField read GetField;
  property FieldValue[const Name: string]: Variant read GetFieldValue write SetFieldValue;

  function AddChild(const Name: string): TXMLNode;
  function FindChildByName(const Name: string): Integer;

  function AddField(const Name: string; const Value: Variant): PXMLNodeField;
  function FindFieldByName(const Name: string): Integer;

  function GetCode(): string;
  procedure SaveToFile(const FileName: string);
  function SaveToStream(const Key: string; OutStream: TStream): Boolean;

  constructor Create(const AName: string);
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
function LoadXMLFromFile(const FileName: string): TXMLNode;
function LoadXMLFromStream(InStream: TStream): TXMLNode;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
function Spaces(Num: Integer): string;
var
 i: Integer;
begin
 Result:= '';
 for i:= 0 to Num - 1 do
  Result:= Result + ' ';
end;

//---------------------------------------------------------------------------
constructor TXMLNode.Create(const AName: string);
begin
 inherited Create();
 FName:= LowerCase(AName);
end;

//---------------------------------------------------------------------------
destructor TXMLNode.Destroy();
var
 i: Integer;
begin
 for i:= 0 to Length(Nodes) - 1 do
  if (Nodes[i] <> nil) then
   begin
    Nodes[i].Free();
    Nodes[i]:= nil;
   end;
 SetLength(Nodes, 0);

 inherited;
end;

//---------------------------------------------------------------------------
function TXMLNode.GetChildCount(): Integer;
begin
 Result:= Length(Nodes);
end;

//---------------------------------------------------------------------------
function TXMLNode.GetChild(Num: Integer): TXMLNode;
begin
 if (Num >= 0)and(Num < Length(Nodes)) then
  Result:= Nodes[Num] else Result:= nil;
end;

//---------------------------------------------------------------------------
function TXMLNode.FindChildByName(const Name: string): Integer;
var
 i: Integer;
begin
 Result:= -1;
 for i:= 0 to Length(Nodes) - 1 do
  if (Nodes[i].Name = Name) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
function TXMLNode.GetChildNode(const Name: string): TXMLNode;
var
 Index: Integer;
begin
 Index:= FindChildByName(Name);
 if (Index <> -1) then Result:= Nodes[Index] else Result:= nil;
end;

//---------------------------------------------------------------------------
function TXMLNode.GetFieldCount(): Integer;
begin
 Result:= Length(Fields);
end;

//---------------------------------------------------------------------------
function TXMLNode.GetField(Num: Integer): PXMLNodeField;
begin
 if (Num >= 0)and(Num < Length(Fields)) then
  Result:= @Fields[Num] else Result:= nil;
end;

//---------------------------------------------------------------------------
function TXMLNode.FindFieldByName(const Name: string): Integer;
var
 i: Integer;
begin
 Result:= -1;
 for i:= 0 to Length(Fields) - 1 do
  if (Fields[i].Name = Name) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
function TXMLNode.GetFieldValue(const Name: string): Variant;
var
 Index: Integer;
begin
 Index:= FindFieldByName(Name);
 if (Index <> -1) then Result:= Fields[Index].Value else Result:= '';
end;

//---------------------------------------------------------------------------
procedure TXMLNode.SetFieldValue(const Name: string; const Value: Variant);
var
 Index: Integer;
begin
 Index:= FindFieldByName(Name);
 if (Index <> -1) then Fields[Index].Value:= Value else AddField(Name, Value);
end;

//---------------------------------------------------------------------------
function TXMLNode.AddChild(const Name: string): TXMLNode;
var
 Index: Integer;
begin
 Index:= Length(Nodes);
 SetLength(Nodes, Index + 1);

 Nodes[Index]:= TXMLNode.Create(Name);
 Result:= Nodes[Index];
end;

//---------------------------------------------------------------------------
function TXMLNode.AddField(const Name: string;
 const Value: Variant): PXMLNodeField;
var
 Index: Integer;
begin
 Index:= Length(Fields);
 SetLength(Fields, Index + 1);

 Fields[Index].Name := Name;
 Fields[Index].Value:= Value;
 Result:= @Fields[Index];
end;

//---------------------------------------------------------------------------
function TXMLNode.SubCode(Spacing: Integer): string;
var
 st: string;
 i: Integer;
begin
 st:= Spaces(Spacing) + '<' + FName;
 if (Length(Fields) > 0) then
  begin
   st:= st + ' ';
   for i:= 0 to Length(Fields) - 1 do
    begin
     st:= st + Fields[i].Name + '="' + Fields[i].Value + '"';
     if (i < Length(Fields) - 1) then st:= st + ' ';
    end;
  end;
 if (Length(Nodes) > 0) then
  begin
   st:= st + '>'#13#10;
   for i:= 0 to Length(Nodes) - 1 do
    st:= st + Nodes[i].SubCode(Spacing + 1);
   st:= st + Spaces(Spacing) + '</' + FName + '>'#13#10; 
  end else st:= st + ' />'#13#10;

 Result:= st; 
end;

//---------------------------------------------------------------------------
function TXMLNode.GetCode(): string;
begin
 Result:= SubCode(0);
end;

//---------------------------------------------------------------------------
procedure TXMLNode.SaveToFile(const FileName: string);
var
 Strings: TStrings;
begin
 Strings:= TStringList.Create();
 Strings.Text:= GetCode();

 try
  Strings.SaveToFile(FileName);
 finally
  Strings.Free();
 end;
end;

//---------------------------------------------------------------------------
function TXMLNode.SaveToStream(const Key: string; OutStream: TStream): Boolean;
var
 Strings: TStrings;
begin
 Strings:= TStringList.Create();
 Strings.Text:= GetCode();

 Result:= True;
 try
  try
   Strings.SaveToStream(OutStream);
  except
   Result:= False;
  end;
 finally
  Strings.Free();
 end;
end;

//--------------------------------------------------------------------------
function LoadEmptyRootNode(Parser: TXMLParser): TXMLNode;
var
 i: Integer;
begin
 Result:= TXMLNode.Create(Parser.CurName);

 with Parser.CurAttr do
  for i:= 0 to Count - 1 do
   Result.AddField(Name(i), Value(i));
end;

//---------------------------------------------------------------------------
procedure LoadNodeBody(TopNode: TXMLNode; Parser: TXMLParser);
var
 Aux: TXMLNode;
 i: Integer;
begin
 with Parser.CurAttr do
  for i:= 0 to Count - 1 do
   TopNode.AddField(Name(i), Value(i));

 while (Parser.Scan()) do
  case Parser.CurPartType of
   ptEndTag:
    Break;

   ptEmptyTag:
    begin
     Aux:= TopNode.AddChild(Parser.CurName);

     with Parser.CurAttr do
      for i:= 0 to Count - 1 do
       Aux.AddField(Name(i), Value(i));
    end;

   ptStartTag:
    begin
     Aux:= TopNode.AddChild(Parser.CurName);
     LoadNodeBody(Aux, Parser);
    end;
  end;
end;

//---------------------------------------------------------------------------
function LoadRootNode(Parser: TXMLParser): TXMLNode;
var
 Aux: TXMLNode;
 i: Integer;
begin
 Result:= TXMLNode.Create(Parser.CurName);

 // -> read attributes of root node
 with Parser.CurAttr do
  for i:= 0 to Count - 1 do
   Result.AddField(Name(i), Value(i));

 // -> parse the body
 while (Parser.Scan()) do
  case Parser.CurPartType of
   // exit out of root node
   ptEndTag:
    Break;

   // empty node inside of root node
   ptEmptyTag:
    begin
     Aux:= Result.AddChild(Parser.CurName);

     with Parser.CurAttr do
      for i:= 0 to Count - 1 do
       Aux.AddField(Name(i), Value(i));
    end;

   // new node owned by root node
   ptStartTag:
    begin
     Aux:= Result.AddChild(Parser.CurName);
     LoadNodeBody(Aux, Parser);
    end;
  end;
end;

//---------------------------------------------------------------------------
function LoadXMLFromFile(const FileName: string): TXMLNode;
var
 Parser: TXMLParser;
begin
 Result:= nil;

 Parser:= TXMLParser.Create();
 try
  Parser.LoadFromFile(FileName, fmOpenRead or fmShareDenyWrite);

  Parser.Normalize:= False;
  Parser.StartScan();

  while (Parser.Scan()) do
   case Parser.CurPartType of
    ptEmptyTag:
     begin
      Result:= LoadEmptyRootNode(Parser);
      Break;
     end;

    ptStartTag:
     begin
      Result:= LoadRootNode(Parser);
      Break;
     end;
   end;

 finally
  Parser.Free();
 end;
end;

//---------------------------------------------------------------------------
function LoadXMLFromStream(InStream: TStream): TXMLNode;
var
 Strings: TStrings;
 Parser : TXMLParser;
begin
 Result:= nil;

 Strings:= TStringList.Create();
 Parser:= TXMLParser.Create();
 try
  try
   Strings.LoadFromStream(InStream);

   Parser.LoadFromBuffer(PChar(Strings.Text));

   Parser.Normalize:= False;
   Parser.StartScan();

   while (Parser.Scan()) do
    case Parser.CurPartType of
     ptEmptyTag:
      begin
       Result:= LoadEmptyRootNode(Parser);
       Break;
      end;

     ptStartTag:
      begin
       Result:= LoadRootNode(Parser);
       Break;
      end;
    end;
  except
   Result.Free();
   Result:= nil;
  end;

 finally
  Strings.Free();
  Parser.Free();
 end;
end;

//---------------------------------------------------------------------------
end.
