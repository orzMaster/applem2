unit AsphyreShaderFX;
//---------------------------------------------------------------------------
// AsphyreShaderFX.pas                                  Modified: 02-Apr-2007
// A wrapper for HLSL shaders and effect framework                Version 1.0
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
// The Original Code is AsphyreShaderFX.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// M. Sc. Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Windows, Direct3D9, d3dx9, Vectors3, AsphyreDevices, AsphyreScene,
 AsphyreEvents;

//---------------------------------------------------------------------------
{$define DebugMode}

//---------------------------------------------------------------------------
type
 TShaderEffectMode = (semCompatibility, semPerformance, semQuality);

//---------------------------------------------------------------------------
 TShaderParameterType = (sptCustom, sptTexture, sptWorldViewProjection,
  sptViewProjection, sptWorldInverseTranspose, sptCameraPosition, sptWorld,
  sptWorldInverse, sptWorldView, sptProjection);

//---------------------------------------------------------------------------
 TShaderParameter = record
  Name  : string;
  Code  : Integer;
  PType : TShaderParameterType;
  Handle: TD3DXHandle;
 end;

//---------------------------------------------------------------------------
 TShaderTechnique = record
  Name  : string;
  Code  : Integer;
  Handle: TD3DXHandle;
 end;

//---------------------------------------------------------------------------
 TAsphyreShaderEffect = class
 private
  Parameters: array of TShaderParameter;
  Techniques: array of TShaderTechnique;

  FEffect: ID3DXEffect;
  FDevice: TAsphyreDevice;

  FNumPasses: Integer;

  function LoadHandles(): Boolean;
  function IndexOfParameter(Code: Integer): Integer;
  function IndexOfTechnique(Code: Integer): Integer;
  procedure ReleaseHandles();
  procedure RequestUpdateParam(Index: Integer);

  procedure OnDeviceReset(Sender: TObject; EventParam: Pointer;
   var Success: Boolean);
  procedure OnDeviceLost(Sender: TObject; EventParam: Pointer;
   var Success: Boolean);
 protected
  procedure DescParam(Param: TShaderParameterType; const Name: string;
   Code: Integer = -1);
  procedure DescTechnique(const Name: string; Code: Integer);
  procedure Describe(); virtual;

  procedure UpdateParam(Code: Integer; out DataPtr: Pointer;
   out DataSize: Integer); virtual;
  function UseTechnique(Code: Integer): Boolean;
  procedure UpdateTexture(Code: Integer;
   out ParamTex: IDirect3DTexture9); virtual;

  procedure UpdateAll();
  procedure BeginUpdate();
  procedure UpdateByCode(Code: Integer);
  procedure EndUpdate();
 public
  property Device: TAsphyreDevice read FDevice;
  property Effect: ID3DXEffect read FEffect;

  property NumPasses: Integer read FNumPasses;

  function LoadFromFile(const FileName: string): Boolean;

  procedure BeginAll();
  procedure EndAll();
  function BeginPass(PassNo: Integer): Boolean;
  procedure EndPass();

  procedure Update(); virtual;

  constructor Create(ADevice: TAsphyreDevice);
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
constructor TAsphyreShaderEffect.Create(ADevice: TAsphyreDevice);
begin
 inherited Create();

 FDevice:= ADevice;

 Describe();

 EventDeviceLost.Subscribe(OnDeviceLost, FDevice);
 EventDeviceReset.Subscribe(OnDeviceReset, FDevice);
end;

//---------------------------------------------------------------------------
destructor TAsphyreShaderEffect.Destroy();
begin
 EventDeviceReset.Unsubscribe(OnDeviceReset);
 EventDeviceLost.Unsubscribe(OnDeviceLost);

 ReleaseHandles();
 if (FEffect <> nil) then FEffect:= nil;

 inherited;
end;

//---------------------------------------------------------------------------
procedure TAsphyreShaderEffect.ReleaseHandles();
var
 i: Integer;
begin
 for i:= 0 to Length(Parameters) - 1 do
  if (Parameters[i].Handle <> nil) then Parameters[i].Handle:= nil;

 for i:= 0 to Length(Techniques) - 1 do
  if (Techniques[i].Handle <> nil) then Techniques[i].Handle:= nil;
end;

//---------------------------------------------------------------------------
procedure TAsphyreShaderEffect.Describe();
begin
 // no code
end;

//---------------------------------------------------------------------------
procedure TAsphyreShaderEffect.DescParam(Param: TShaderParameterType;
 const Name: string; Code: Integer = -1);
var
 Index: Integer;
begin
 Index:= Length(Parameters);
 SetLength(Parameters, Index + 1);

 Parameters[Index].Name  := Name;
 Parameters[Index].Code  := Code;
 Parameters[Index].PType := Param;
 Parameters[Index].Handle:= nil;
end;

//---------------------------------------------------------------------------
procedure TAsphyreShaderEffect.DescTechnique(const Name: string; Code: Integer);
var
 Index: Integer;
begin
 Index:= Length(Techniques);
 SetLength(Techniques, Index + 1);

 Techniques[Index].Name  := Name;
 Techniques[Index].Code  := Code;
end;

//---------------------------------------------------------------------------
function TAsphyreShaderEffect.LoadHandles(): Boolean;
var
 i: Integer;
begin
 Result:= True;

 for i:= 0 to Length(Parameters) - 1 do
  begin
   Parameters[i].Handle:= FEffect.GetParameterByName(nil,
    PAnsiChar(Parameters[i].Name));

   if (Parameters[i].Handle = nil) then
    begin
     Result:= False;
     Exit;
    end;
  end;

 for i:= 0 to Length(Techniques) - 1 do
  begin
   Techniques[i].Handle:= FEffect.GetTechniqueByName(PAnsiChar(Techniques[i].Name));

   if (Techniques[i].Handle = nil) then
    begin
     Result:= False;
     Exit;
    end;
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreShaderEffect.OnDeviceLost(Sender: TObject;
 EventParam: Pointer; var Success: Boolean);
begin
 if (FEffect <> nil) then FEffect.OnLostDevice();
end;

//---------------------------------------------------------------------------
procedure TAsphyreShaderEffect.OnDeviceReset(Sender: TObject;
 EventParam: Pointer; var Success: Boolean);
begin
 if (FEffect <> nil) then FEffect.OnResetDevice();
end;

//---------------------------------------------------------------------------
function TAsphyreShaderEffect.LoadFromFile(const FileName: string): Boolean;
{$ifdef DebugMode}
var
 Errors: ID3DXBuffer;
{$endif}
begin
 if (FEffect <> nil) then FEffect:= nil;

 {$ifdef DebugMode}
 Result:= Succeeded(D3DXCreateEffectFromFile(FDevice.Dev9, PAnsiChar(FileName),
  nil, nil, D3DXSHADER_DEBUG, nil, FEffect, @Errors));

 if (Errors <> nil) then
  OutputDebugString(Errors.GetBufferPointer());
 {$else}
 Result:= Succeeded(D3DXCreateEffectFromFile(FDevice.Dev9, PAnsiChar(FileName),
  nil, nil, 0, nil, FEffect, nil));
 {$endif}

 if (Result) then Result:= LoadHandles();
end;

//---------------------------------------------------------------------------
procedure TAsphyreShaderEffect.UpdateParam(Code: Integer; out DataPtr: Pointer;
 out DataSize: Integer);
begin
 DataPtr := nil;
 DataSize:= 0;
end;

//---------------------------------------------------------------------------
procedure TAsphyreShaderEffect.UpdateTexture(Code: Integer;
 out ParamTex: IDirect3DTexture9);
begin
 ParamTex:= nil;
end;

//---------------------------------------------------------------------------
function TAsphyreShaderEffect.IndexOfParameter(Code: Integer): Integer;
var
 i: Integer;
begin
 Result:= -1;

 for i:= 0 to Length(Parameters) - 1 do
  if (Parameters[i].Code = Code) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
function TAsphyreShaderEffect.IndexOfTechnique(Code: Integer): Integer;
var
 i: Integer;
begin
 Result:= -1;

 for i:= 0 to Length(Techniques) - 1 do
  if (Techniques[i].Code = Code) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
function TAsphyreShaderEffect.UseTechnique(Code: Integer): Boolean;
var
 Index: Integer;
begin
 Index:= IndexOfTechnique(Code);
 if (Index = -1)or(FEffect = nil) then
  begin
   Result:= False;
   Exit;
  end;

 Result:= Succeeded(FEffect.SetTechnique(Techniques[Index].Handle));
end;

//---------------------------------------------------------------------------
procedure TAsphyreShaderEffect.RequestUpdateParam(Index: Integer);
var
 DataPtr : Pointer;
 DataSize: Integer;
 TempTex : IDirect3DTexture9;
begin
 with Parameters[Index] do
  case PType of
   sptWorldViewProjection:
    FEffect.SetMatrix(Handle, TD3DXMatrix(ShdrWorldViewProjection));

   sptViewProjection:
    FEffect.SetMatrix(Handle, TD3DXMatrix(ShdrViewProjection));

   sptWorldInverseTranspose:
    FEffect.SetMatrix(Handle, TD3DXMatrix(ShdrWorldInverseTranspose));

   sptWorldView:
    FEffect.SetMatrix(Handle, TD3DXMatrix(ShdrWorldView));

   sptWorldInverse:
    FEffect.SetMatrix(Handle, TD3DXMatrix(ShdrWorldInverse));

   sptWorld:
    FEffect.SetMatrix(Handle, PD3DXMatrix(WorldMtx.RawMtx)^);

   sptProjection:
    FEffect.SetMatrix(Handle, PD3DXMatrix(ProjMtx.RawMtx)^);

   sptCameraPosition:
    FEffect.SetValue(Handle, @ShdrCameraPosition, SizeOf(TVector3));

   sptTexture:
    begin
     UpdateTexture(Code, TempTex);
     FEffect.SetTexture(Handle, TempTex);

     TempTex:= nil;
    end;

   sptCustom:
    begin
     UpdateParam(Code, DataPtr, DataSize);
     if (DataPtr <> nil)and(DataSize > 0) then
      FEffect.SetValue(Handle, DataPtr, DataSize);
    end;
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreShaderEffect.UpdateAll();
var
 i: Integer;
begin
 BeginUpdate();

 for i:= 0 to Length(Parameters) - 1 do
  RequestUpdateParam(i);

 EndUpdate();
end;

//---------------------------------------------------------------------------
procedure TAsphyreShaderEffect.BeginAll();
begin
 if (FEffect <> nil) then FEffect._Begin(@FNumPasses, 0);
end;

//---------------------------------------------------------------------------
procedure TAsphyreShaderEffect.EndAll();
begin
 if (FEffect <> nil) then FEffect._End();
end;

//---------------------------------------------------------------------------
function TAsphyreShaderEffect.BeginPass(PassNo: Integer): Boolean;
begin
 if (FEffect = nil) then
  begin
   Result:= False;
   Exit;
  end;

 Result:= Succeeded(FEffect.BeginPass(PassNo));
end;

//---------------------------------------------------------------------------
procedure TAsphyreShaderEffect.EndPass();
begin
 if (FEffect <> nil) then FEffect.EndPass();
end;

//---------------------------------------------------------------------------
procedure TAsphyreShaderEffect.Update();
begin
 UpdateAll();
end;

//---------------------------------------------------------------------------
procedure TAsphyreShaderEffect.BeginUpdate();
begin
 UpdateShdrCombined();
end;

//---------------------------------------------------------------------------
procedure TAsphyreShaderEffect.EndUpdate();
begin
 FEffect.CommitChanges();
end;

//---------------------------------------------------------------------------
procedure TAsphyreShaderEffect.UpdateByCode(Code: Integer);
var
 Index: Integer;
begin
 Index:= IndexOfParameter(Code);
 if (Index = -1) then Exit;

 RequestUpdateParam(Index);
end;

//---------------------------------------------------------------------------
end.
