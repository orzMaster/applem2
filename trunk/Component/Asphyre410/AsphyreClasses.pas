unit AsphyreClasses;
//---------------------------------------------------------------------------
// AsphyreClasses.pas                                   Modified: 03-Mar-2007
// Asphyre container class implementation                         Version 1.0
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
// The Original Code is GuiTypes.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 AsphyreUtils;

//---------------------------------------------------------------------------
type
 TAsphyreList = class;

//---------------------------------------------------------------------------
 TAsphyreFreeEvent = procedure(List: TAsphyreList; Item: Pointer) of object;
 TAsphyreSortEvent = function(List: TAsphyreList; Item1,
  Item2: Pointer): Integer of object;
 TAsphyreFindEvent = function(List: TAsphyreList; Item,
  User: Pointer): Integer of object; 

//---------------------------------------------------------------------------
 TAsphyreList = class
 private
  Data     : array of Pointer;
  FCount   : Integer;
  FCapacity: Integer;
  DataDirty: Boolean;
  UserDirty: Boolean;
  DataIndex: array of Integer;
  UserIndex: array of Integer;

  FOnFreeItem: TAsphyreFreeEvent;
  FOnSortItem: TAsphyreSortEvent;
  FOnFindItem: TAsphyreFindEvent;

  procedure SetCapacity(const Value: Integer);
  procedure Grow();
  function GetItems(Index: Integer): Pointer;
  procedure InitDataIndex();
  procedure SortDataIndex(Left, Right: Integer);
  procedure UpdateDataIndex();
  procedure InitUserIndex();
  procedure SortUserIndex(Left, Right: Integer);
  procedure UpdateUserIndex();
 public
  property Capacity: Integer read FCapacity write SetCapacity;

  property Count: Integer read FCount;
  property Items[Index: Integer]: Pointer read GetItems; default;

  // This event should release the item, if necessary.
  property OnFreeItem: TAsphyreFreeEvent read FOnFreeItem write FOnFreeItem;

  // This event should compare two items by custom criteria for sorting.
  property OnSortItem: TAsphyreSortEvent read FOnSortItem write FOnSortItem;

  // This event should compare item with custom criteria for quick search.
  property OnFindItem: TAsphyreFindEvent read FOnFindItem write FOnFindItem;

  function Insert(Item: Pointer): Integer;
  procedure Remove(Index: Integer);
  function IndexOf(Item: Pointer): Integer;
  function FindBy(User: Pointer): Integer;
  procedure Clear();

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
const
 MinGrow  = 4;
 GrowUnit = 8;

//---------------------------------------------------------------------------
constructor TAsphyreList.Create();
begin
 inherited;

 FCount   := 0;
 FCapacity:= 0;
 DataDirty:= False;
 UserDirty:= False;
end;

//---------------------------------------------------------------------------
destructor TAsphyreList.Destroy();
begin
 Clear();

 inherited;
end;

//---------------------------------------------------------------------------
procedure TAsphyreList.SetCapacity(const Value: Integer);
begin
 FCapacity:= Max2(FCount, Value);

 SetLength(Data, FCapacity);
 SetLength(DataIndex, FCapacity);
 SetLength(UserIndex, FCapacity);
end;

//---------------------------------------------------------------------------
procedure TAsphyreList.Grow();
var
 Delta: Integer;
begin
 Delta:= MinGrow + (FCapacity div GrowUnit);
 Inc(FCapacity, Delta);

 SetLength(Data, FCapacity);
 SetLength(DataIndex, FCapacity);
 SetLength(UserIndex, FCapacity);
end;

//---------------------------------------------------------------------------
function TAsphyreList.GetItems(Index: Integer): Pointer;
begin
 if (Index >= 0)and(Index < FCount) then
  Result:= Data[Index] else Result:= nil;
end;

//---------------------------------------------------------------------------
function TAsphyreList.Insert(Item: Pointer): Integer;
begin
 if (FCount >= FCapacity) then Grow();

 Result:= FCount;
 Inc(FCount);

 Data[Result]:= Item;

 DataDirty:= True;
 UserDirty:= True;
end;

//---------------------------------------------------------------------------
procedure TAsphyreList.Remove(Index: Integer);
var
 i: Integer;
 Item: Pointer;
begin
 if (Index < 0)or(Index >= FCount) then Exit;

 Item:= Data[Index];

 for i:= Index to FCount - 2 do
  Data[i]:= Data[i + 1];

 Dec(FCount);
 DataDirty:= True;
 UserDirty:= True;

 if (Assigned(FOnFreeItem)) then FOnFreeItem(Self, Item);
end;

//---------------------------------------------------------------------------
procedure TAsphyreList.Clear();
var
 i: Integer;
begin
 if (not Assigned(FOnFreeItem)) then
  begin
   FCount:= 0;
   SetCapacity(0);
   Exit;
  end;

 for i:= FCount - 1 downto 0 do
  begin
   FOnFreeItem(Self, Data[i]);
   Dec(FCount);
  end;

 SetCapacity(0);
end;

//---------------------------------------------------------------------------
procedure TAsphyreList.InitDataIndex();
var
 i: Integer;
begin
 for i:= 0 to FCount - 1 do
  DataIndex[i]:= i;
end;

//---------------------------------------------------------------------------
procedure TAsphyreList.SortDataIndex(Left, Right: Integer);
var
 Lo, Hi   : Integer;
 TempIndex: Integer;
 MidValue : Integer;
begin
 Lo:= Left;
 Hi:= Right;
 MidValue:= Integer(Data[DataIndex[(Left + Right) div 2]]);

 repeat
  while (Integer(Data[DataIndex[Lo]]) < MidValue) do Inc(Lo);
  while (MidValue < Integer(Data[DataIndex[Hi]])) do Dec(Hi);

  if (Lo <= Hi) then
   begin
    TempIndex:= DataIndex[Lo];
    DataIndex[Lo]:= DataIndex[Hi];
    DataIndex[Hi]:= TempIndex;

    Inc(Lo);
    Dec(Hi);
   end;
 until (Lo > Hi);

 if (Left < Hi) then SortDataIndex(Left, Hi);
 if (Lo < Right) then SortDataIndex(Lo, Right);
end;

//---------------------------------------------------------------------------
procedure TAsphyreList.UpdateDataIndex();
begin
 InitDataIndex();
 if (FCount > 1) then SortDataIndex(0, FCount - 1);
 DataDirty:= False;
end;

//---------------------------------------------------------------------------
function TAsphyreList.IndexOf(Item: Pointer): Integer;
var
 Lo, Hi, Mid: Integer;
begin
 if (DataDirty) then UpdateDataIndex();

 Result:= -1;

 Lo:= 0;
 Hi:= FCount - 1;

 while (Lo <= Hi) do
  begin
   Mid:= (Lo + Hi) div 2;

   if (Data[DataIndex[Mid]] = Item) then
    begin
     Result:= DataIndex[Mid];
     Break;
    end;

   if (Integer(Data[DataIndex[Mid]]) > Integer(Item)) then Hi:= Mid - 1
    else Lo:= Mid + 1;
 end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreList.InitUserIndex();
var
 i: Integer;
begin
 for i:= 0 to FCount - 1 do
  UserIndex[i]:= i;
end;

//---------------------------------------------------------------------------
procedure TAsphyreList.SortUserIndex(Left, Right: Integer);
var
 Lo, Hi   : Integer;
 MidValue : Pointer;
 TempIndex: Integer;
begin
 Lo:= Left;
 Hi:= Right;
 MidValue:= Data[UserIndex[(Left + Right) div 2]];

 repeat
  while (FOnSortItem(Self, Data[UserIndex[Lo]], MidValue) < 0) do Inc(Lo);
  while (FOnSortItem(Self, Data[UserIndex[Hi]], MidValue) > 0) do Dec(Hi);

  if (Lo <= Hi) then
   begin
    TempIndex:= UserIndex[Lo];
    UserIndex[Lo]:= UserIndex[Hi];
    UserIndex[Hi]:= TempIndex;

    Inc(Lo);
    Dec(Hi);
   end;
 until (Lo > Hi);

 if (Left < Hi) then SortUserIndex(Left, Hi);
 if (Lo < Right) then SortUserIndex(Lo, Right);
end;

//---------------------------------------------------------------------------
procedure TAsphyreList.UpdateUserIndex();
begin
 InitUserIndex();
 if (FCount > 1) then SortUserIndex(0, FCount - 1);
 UserDirty:= False;
end;

//---------------------------------------------------------------------------
function TAsphyreList.FindBy(User: Pointer): Integer;
var
 Lo, Hi, Mid: Integer;
begin
 if (UserDirty) then UpdateUserIndex();

 Result:= -1;

 Lo:= 0;
 Hi:= FCount - 1;

 while (Lo <= Hi) do
  begin
   Mid:= (Lo + Hi) div 2;

   if (FOnFindItem(Self, Data[UserIndex[Mid]], User) = 0) then
    begin
     Result:= UserIndex[Mid];
     Break;
    end;

   if (FOnFindItem(Self, Data[UserIndex[Mid]], User) > 0) then Hi:= Mid - 1
    else Lo:= Mid + 1;
 end;
end;

//---------------------------------------------------------------------------
end.
