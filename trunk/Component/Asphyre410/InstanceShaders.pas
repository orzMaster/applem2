unit InstanceShaders;
//---------------------------------------------------------------------------
// AsphyreBasicShaders.pas                              Modified: 09-Apr-2007
// High-level wrapper for basic Asphyre shader effect             Version 1.0
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
// The Original Code is AsphyreBasicShaders.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// M. Sc. Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Direct3D9, d3dx9, Vectors3, Matrices4, AsphyreColors, AsphyreDevices,
 AsphyreShaderFX, InstanceMeshes;

//---------------------------------------------------------------------------
const
 NumShdrInstances = 24;

//---------------------------------------------------------------------------
type
 TInstanceShadingType = (istGouraud, istPhong);

//---------------------------------------------------------------------------
 TInstanceShader = class(TAsphyreShaderEffect)
 private
  TempLightVec: TD3DXVector3;
  FLightVector: TVector3;
  FShadingType: TInstanceShadingType;

  InstanceWorld: array[0..NumShdrInstances - 1] of TMatrix4;
  InstanceColor: array[0..NumShdrInstances - 1] of TD3DColorValue;
  InstanceInvTWorld: array[0..NumShdrInstances - 1] of TMatrix4;

  InstanceMesh: TInstanceMesh;
  InstanceNo  : Integer;
 protected
  procedure Describe(); override;
  procedure UpdateParam(Code: Integer; out DataPtr: Pointer;
   out DataSize: Integer); override;
 public
  property LightVector: TVector3 read FLightVector write FLightVector;
  property ShadingType: TInstanceShadingType read FShadingType write FShadingType;

  procedure Draw(Mesh: TInstanceMesh; const World: TMatrix4; Color: Cardinal);
  procedure Flush();

  procedure Update(); override;

  constructor Create(ADevice: TAsphyreDevice);
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
const
 ShdrLightVector   = 1;
 ShdrGouraud       = 2;
 ShdrPhong         = 3;

 ShdrInstanceWorld     = 4;
 ShdrInstanceInvTWorld = 5;
 ShdrInstanceColor     = 6;

//---------------------------------------------------------------------------
constructor TInstanceShader.Create(ADevice: TAsphyreDevice);
begin
 inherited;

 FLightVector:= Norm3(Vector3(1.0, 1.0, -1.0));
 InstanceNo:= 0;
end;

//---------------------------------------------------------------------------
procedure TInstanceShader.Describe();
begin
 DescParam(sptViewProjection, 'ViewProjection');
 DescParam(sptCameraPosition, 'CameraPos');

 DescParam(sptCustom, 'LightVector',   ShdrLightVector);

 DescParam(sptCustom, 'InstanceWorld',     ShdrInstanceWorld);
 DescParam(sptCustom, 'InstanceInvTWorld', ShdrInstanceInvTWorld);
 DescParam(sptCustom, 'InstanceColor',     ShdrInstanceColor);

 DescTechnique('GouraudShading', ShdrGouraud);
 DescTechnique('PhongShading', ShdrPhong);
end;

//---------------------------------------------------------------------------
procedure TInstanceShader.UpdateParam(Code: Integer; out DataPtr: Pointer;
 out DataSize: Integer);
begin
 case Code of
  ShdrLightVector:
   begin
    TempLightVec:= TD3DXVector3(-Norm3(FLightVector));

    DataPtr := @TempLightVec;
    DataSize:= SizeOf(TD3DXVector3);
   end;

  ShdrInstanceWorld:
   begin
    DataPtr := @InstanceWorld;
    DataSize:= SizeOf(InstanceWorld);
   end;

  ShdrInstanceInvTWorld:
   begin
    DataPtr := @InstanceInvTWorld;
    DataSize:= SizeOf(InstanceInvTWorld);
   end;

  ShdrInstanceColor:
   begin
    DataPtr := @InstanceColor;
    DataSize:= SizeOf(InstanceColor);
   end;
 end;
end;

//---------------------------------------------------------------------------
procedure TInstanceShader.Update();
begin
 inherited;

 case FShadingType of
  istGouraud:
   UseTechnique(ShdrGouraud);

  istPhong:
   UseTechnique(ShdrPhong);
 end;
end;

//---------------------------------------------------------------------------
procedure TInstanceShader.Draw(Mesh: TInstanceMesh; const World: TMatrix4;
 Color: Cardinal);
begin
 if (Mesh <> InstanceMesh)or(InstanceNo >= NumShdrInstances)or
  (InstanceNo >= Mesh.NumCopies) then
  begin
   if (InstanceMesh <> nil) then Flush();

   InstanceMesh:= Mesh;
  end;

 InstanceWorld[InstanceNo]:= World;
 InstanceColor[InstanceNo]:= D3DXColorFromDWord(Color);

 D3DXMatrixInverse(TD3DXMatrix(InstanceInvTWorld[InstanceNo]), nil,
  TD3DXMatrix(InstanceWorld[InstanceNo]));
 D3DXMatrixTranspose(TD3DXMatrix(InstanceInvTWorld[InstanceNo]),
  TD3DXMatrix(InstanceInvTWorld[InstanceNo]));

 Inc(InstanceNo);
end;

//---------------------------------------------------------------------------
procedure TInstanceShader.Flush();
var
 PassNo: Integer;
begin
 UpdateAll();

 for PassNo:= 0 to NumPasses - 1 do
  begin
   if (not BeginPass(PassNo)) then Break;

   InstanceMesh.DrawCopies(InstanceNo);

   EndPass();
  end;

 InstanceNo:= 0; 
end;

//---------------------------------------------------------------------------
end.
