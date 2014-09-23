unit AsphyreMaterials;
//---------------------------------------------------------------------------
// AsphyreMaterials.pas                                 Modified: 11-Mar-2007
// Asphyre native material implementation                         Version 1.0
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
// The Original Code is AsphyreMaterials.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//--------------------------------------------------------------------------
uses
 Direct3D9, AsphyreClasses, AsphyreColors;

//--------------------------------------------------------------------------
type
 PAsphyreMaterial = ^TAsphyreMaterial;
 TAsphyreMaterial = record
  Diffuse : TAsphyreColor;
  Specular: TAsphyreColor;
  Ambient : TAsphyreColor;
  Emissive: TAsphyreColor;
  Power   : Single;

  class operator Implicit(const Material: TAsphyreMaterial): TD3DMaterial9;
  class operator Implicit(const Material: TD3DMaterial9): TAsphyreMaterial;
 end;

//--------------------------------------------------------------------------
 TAsphyreMaterials = class
 private
  List: TAsphyreList;

  function GetCount(): Integer;
  procedure SetCount(const Value: Integer);
  function GetItem(Index: Integer): PAsphyreMaterial;
  procedure FreeItem(List: TAsphyreList; Item: Pointer);
 public
  property Count: Integer read GetCount write SetCount;
  property Items[Index: Integer]: PAsphyreMaterial read GetItem; default;

  function Insert(): PAsphyreMaterial;
  function IndexOf(Material: PAsphyreMaterial): Integer; overload;
  procedure Remove(Index: Integer);
  procedure Clear();

  procedure InitDefaults();

  constructor Create();
  destructor Destroy(); override;
 end;

//--------------------------------------------------------------------------
implementation

//--------------------------------------------------------------------------
class operator TAsphyreMaterial.Implicit(
 const Material: TAsphyreMaterial): TD3DMaterial9;
begin
 Result.Diffuse := Material.Diffuse;
 Result.Specular:= Material.Specular;
 Result.Ambient := Material.Ambient;
 Result.Emissive:= Material.Emissive;
 Result.Power   := Material.Power;
end;

//--------------------------------------------------------------------------
class operator TAsphyreMaterial.Implicit(
 const Material: TD3DMaterial9): TAsphyreMaterial;
begin
 Result.Diffuse := Material.Diffuse;
 Result.Specular:= Material.Specular;
 Result.Ambient := Material.Ambient;
 Result.Emissive:= Material.Emissive;
 Result.Power   := Material.Power;
end;

//--------------------------------------------------------------------------
constructor TAsphyreMaterials.Create();
begin
 inherited;

 List:= TAsphyreList.Create();
 List.OnFreeItem:= FreeItem;
end;

//--------------------------------------------------------------------------
destructor TAsphyreMaterials.Destroy();
begin
 List.Free();

 inherited;
end;

//--------------------------------------------------------------------------
procedure TAsphyreMaterials.FreeItem(List: TAsphyreList; Item: Pointer);
begin
 FreeMem(Item, SizeOf(TD3DMaterial9));
end;

//--------------------------------------------------------------------------
function TAsphyreMaterials.GetCount(): Integer;
begin
 Result:= List.Count;
end;

//--------------------------------------------------------------------------
procedure TAsphyreMaterials.SetCount(const Value: Integer);
begin
 while (List.Count > Value)and(List.Count > 0) do List.Remove(List.Count - 1);
 while (List.Count < Value) do Insert();
end;

//--------------------------------------------------------------------------
function TAsphyreMaterials.GetItem(Index: Integer): PAsphyreMaterial;
begin
 Result:= PAsphyreMaterial(List[Index]);
end;

//--------------------------------------------------------------------------
function TAsphyreMaterials.Insert(): PAsphyreMaterial;
begin
 Result:= AllocMem(SizeOf(TAsphyreMaterial));
 List.Insert(Result);
end;

//--------------------------------------------------------------------------
function TAsphyreMaterials.IndexOf(Material: PAsphyreMaterial): Integer;
begin
 Result:= List.IndexOf(Material);
end;

//--------------------------------------------------------------------------
procedure TAsphyreMaterials.Remove(Index: Integer);
begin
 List.Remove(Index);
end;

//--------------------------------------------------------------------------
procedure TAsphyreMaterials.Clear();
begin
 List.Clear();
end;

//--------------------------------------------------------------------------
procedure TAsphyreMaterials.InitDefaults();
var
 i: Integer;
begin
 for i:= 0 to List.Count - 1 do
  with PAsphyreMaterial(List[i])^ do
   begin
    Diffuse := $FFFFFFFF;
    Ambient := $FFFFFFFF;
    Specular:= $FFFFFFFF;
    Emissive:= $00000000;
    Power   := 20.0;
   end;
end;

//--------------------------------------------------------------------------
end.
