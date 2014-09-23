unit BBTypes;
//---------------------------------------------------------------------------
// BBTypes.pas                                          Modified: 09-Mar-2007
// Billboard type storage                                         Version 1.1
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
// The Original Code is BBTypes.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Vectors2, AsphyreTypes, AsphyreClasses, AsphyreImages;

//---------------------------------------------------------------------------
type
 PAsphyreBillboard = ^TAsphyreBillboard;
 TAsphyreBillboard = record
  Size    : TPoint2;
  Phi     : Single;
  Color   : Cardinal;
  DrawFx  : Integer;
  Image   : TAsphyreCustomImage;
  Pattern : Integer;
 end;

//---------------------------------------------------------------------------
 TAsphyreBillboards = class
 private
  List: TAsphyreList;

  function GetCount(): Integer;
  function GetItem(Index: Integer): PAsphyreBillboard;
  procedure FreeItem(List: TAsphyreList; Item: Pointer);
 public
  property Count: Integer read GetCount;
  property Items[Index: Integer]: PAsphyreBillboard read GetItem; default;

  function Insert(const Billboard: TAsphyreBillboard): Integer;
  function IndexOf(Billboard: PAsphyreBillboard): Integer; overload;
  procedure Remove(Index: Integer);
  procedure Clear();

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
constructor TAsphyreBillboards.Create();
begin
 inherited;

 List:= TAsphyreList.Create();
 List.OnFreeItem:= FreeItem;
end;

//---------------------------------------------------------------------------
destructor TAsphyreBillboards.Destroy();
begin
 List.Free();

 inherited;
end;

//---------------------------------------------------------------------------
procedure TAsphyreBillboards.FreeItem(List: TAsphyreList; Item: Pointer);
begin
 FreeMem(Item, SizeOf(TAsphyreBillboard));
end;

//---------------------------------------------------------------------------
function TAsphyreBillboards.GetCount(): Integer;
begin
 Result:= List.Count;
end;

//---------------------------------------------------------------------------
function TAsphyreBillboards.GetItem(Index: Integer): PAsphyreBillboard;
begin
 Result:= PAsphyreBillboard(List[Index]);
end;

//---------------------------------------------------------------------------
function TAsphyreBillboards.Insert(const Billboard: TAsphyreBillboard): Integer;
var
 Item: PAsphyreBillboard;
begin
 GetMem(Item, SizeOf(TAsphyreBillboard));
 Move(Billboard, Item^, SizeOf(TAsphyreBillboard));
 Result:= List.Insert(Item);
end;

//---------------------------------------------------------------------------
function TAsphyreBillboards.IndexOf(Billboard: PAsphyreBillboard): Integer;
begin
 Result:= List.IndexOf(Billboard);
end;

//---------------------------------------------------------------------------
procedure TAsphyreBillboards.Remove(Index: Integer);
begin
 List.Remove(Index);
end;

//---------------------------------------------------------------------------
procedure TAsphyreBillboards.Clear();
begin
 List.Clear();
end;

//---------------------------------------------------------------------------
end.

