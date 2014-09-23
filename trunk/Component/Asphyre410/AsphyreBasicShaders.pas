unit AsphyreBasicShaders;
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
 AsphyreShaderFX, AsphyreMeshes;

//---------------------------------------------------------------------------
type
 TAsphyreShadingType = (astGouraud, astPhong);

//---------------------------------------------------------------------------
 TAsphyreBasicShader = class(TAsphyreShaderEffect)
 private
  TempColorValue: TD3DColorValue;
  TempLightVec  : TD3DXVector3;

  FAmbientColor : TAsphyreColor;
  FDiffuseColor : TAsphyreColor;
  FSpecularColor: TAsphyreColor;
  FSpecularPower: Single;
  FLightVector  : TVector3;
  FShadingType  : TAsphyreShadingType;
 protected
  procedure Describe(); override;
  procedure UpdateParam(Code: Integer; out DataPtr: Pointer;
   out DataSize: Integer); override;
 public
  property AmbientColor : TAsphyreColor read FAmbientColor write FAmbientColor;
  property DiffuseColor : TAsphyreColor read FDiffuseColor write FDiffuseColor;
  property SpecularColor: TAsphyreColor read FSpecularColor write FSpecularColor;
  property SpecularPower: Single read FSpecularPower write FSpecularPower;
  property LightVector  : TVector3 read FLightVector write FLightVector;
  property ShadingType  : TAsphyreShadingType read FShadingType write FShadingType;

  procedure Draw(Mesh: TAsphyreCustomMesh);
  procedure DrawCol(Mesh: TAsphyreCustomMesh; const World: TMatrix4;
   Color: Cardinal);
  procedure DrawColSpec(Mesh: TAsphyreCustomMesh; const World: TMatrix4;
   Diffuse, Specular: Cardinal);

  procedure Update(); override;

  constructor Create(ADevice: TAsphyreDevice);
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreScene;

//---------------------------------------------------------------------------
const
 ShdrAmbientColor  = 1;
 ShdrDiffuseColor  = 2;
 ShdrSpecularColor = 3;
 ShdrSpecularPower = 4;
 ShdrLightVector   = 5;
 ShdrGouraud       = 6;
 ShdrPhong         = 7;

//---------------------------------------------------------------------------
constructor TAsphyreBasicShader.Create(ADevice: TAsphyreDevice);
begin
 inherited;

 FAmbientColor := $FF202020;
 FDiffuseColor := $FF00FF00;
 FSpecularColor:= $FFFFFFFF;
 FSpecularPower:= 20.0;
 FLightVector  := Norm3(Vector3(1.0, 1.0, 1.0));
end;

//---------------------------------------------------------------------------
procedure TAsphyreBasicShader.Describe();
begin
 DescParam(sptWorldViewProjection,   'WorldViewProjection');
 DescParam(sptWorldInverseTranspose, 'WorldInverseTranspose');
 DescParam(sptCameraPosition,        'CameraPos');
 DescParam(sptWorld,                 'World');

 DescParam(sptCustom, 'AmbientColor',  ShdrAmbientColor);
 DescParam(sptCustom, 'DiffuseColor',  ShdrDiffuseColor);
 DescParam(sptCustom, 'SpecularColor', ShdrSpecularColor);
 DescParam(sptCustom, 'SpecularPower', ShdrSpecularPower);
 DescParam(sptCustom, 'LightVector',   ShdrLightVector);

 DescTechnique('GouraudShading', ShdrGouraud);
 DescTechnique('PhongShading',   ShdrPhong);
end;

//---------------------------------------------------------------------------
procedure TAsphyreBasicShader.UpdateParam(Code: Integer; out DataPtr: Pointer;
 out DataSize: Integer);
begin
 case Code of
  ShdrAmbientColor:
   begin
    TempColorValue:= FAmbientColor;

    DataPtr := @TempColorValue;
    DataSize:= SizeOf(TD3DColorValue);
   end;

  ShdrDiffuseColor:
   begin
    TempColorValue:= FDiffuseColor;

    DataPtr := @TempColorValue;
    DataSize:= SizeOf(TD3DColorValue);
   end;

  ShdrSpecularColor:
   begin
    TempColorValue:= FSpecularColor;

    DataPtr := @TempColorValue;
    DataSize:= SizeOf(TD3DColorValue);
   end;

  ShdrSpecularPower:
   begin
    DataPtr := @FSpecularPower;
    DataSize:= SizeOf(Single);
   end;

  ShdrLightVector:
   begin
    TempLightVec:= TD3DXVector3(-Norm3(FLightVector));

    DataPtr := @TempLightVec;
    DataSize:= SizeOf(TD3DXVector3);
   end;
 end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreBasicShader.Update();
begin
 inherited;

 case FShadingType of
  astGouraud:
   UseTechnique(ShdrGouraud);

  astPhong:
   UseTechnique(ShdrPhong);
 end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreBasicShader.Draw(Mesh: TAsphyreCustomMesh);
var
 PassNo: Integer;
begin
 for PassNo:= 0 to NumPasses - 1 do
  begin
   if (not BeginPass(PassNo)) then Break;

   Mesh.Draw();

   EndPass();
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreBasicShader.DrawCol(Mesh: TAsphyreCustomMesh;
 const World: TMatrix4; Color: Cardinal);
begin
 WorldMtx.LoadMtx(@World);

 DiffuseColor := Color;
 AmbientColor := cBlend(0, Color, 32);
 SpecularColor:= $FFFFFFFF;

 UpdateAll();

 Draw(Mesh);
end;

//---------------------------------------------------------------------------
procedure TAsphyreBasicShader.DrawColSpec(Mesh: TAsphyreCustomMesh;
 const World: TMatrix4; Diffuse, Specular: Cardinal);
begin
 WorldMtx.LoadMtx(@World);

 DiffuseColor := Diffuse;
 AmbientColor := cBlend(0, Diffuse, 32);
 SpecularColor:= Specular;

 UpdateAll();

 Draw(Mesh);
end;

//---------------------------------------------------------------------------
end.
