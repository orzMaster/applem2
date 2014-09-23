unit AsphyreScene;
//---------------------------------------------------------------------------
// AsphyreScene.pas                                     Modified: 09-Apr-2007
// High-level structure for making 3D scenes in Asphyre           Version 1.0
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
// The Original Code is AsphyreScene.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// M. Sc. Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//--------------------------------------------------------------------------
uses
 d3dx9, Vectors3, Matrices4, AsphyreMatrices;

//--------------------------------------------------------------------------
var
//--------------------------------------------------------------------------
// Standard Asphyre matrices
//--------------------------------------------------------------------------
 WorldMtx: TAsphyreMatrix = nil;
 ViewMtx : TAsphyreMatrix = nil;
 ProjMtx : TAsphyreMatrix = nil;

//--------------------------------------------------------------------------
// Combined matrices and positions to be used with shaders
//--------------------------------------------------------------------------
 ShdrCameraPosition       : TVector3;
 ShdrWorldView            : TMatrix4;
 ShdrWorldViewProjection  : TMatrix4;
 ShdrViewProjection       : TMatrix4;
 ShdrWorldInverse         : TMatrix4;
 ShdrWorldInverseTranspose: TMatrix4;

//--------------------------------------------------------------------------
procedure UpdateShdrCombined();

//--------------------------------------------------------------------------
implementation

//--------------------------------------------------------------------------
type
 PLMatrix4 = ^TLMatrix4;
 TLMatrix4 = array[0..15] of Single;

//--------------------------------------------------------------------------
procedure UpdateShdrCombined();
var
 View: PLMatrix4;
begin
 // -> World-View
 D3DXMatrixMultiply(TD3DXMatrix(ShdrWorldView),
  PD3DXMatrix(WorldMtx.RawMtx)^, PD3DXMatrix(ViewMtx.RawMtx)^);

 // -> View-Projection
 D3DXMatrixMultiply(TD3DXMatrix(ShdrViewProjection),
  PD3DXMatrix(ViewMtx.RawMtx)^, PD3DXMatrix(ProjMtx.RawMtx)^);

 // -> World-View-Projection
 D3DXMatrixMultiply(TD3DXMatrix(ShdrWorldViewProjection),
  PD3DXMatrix(WorldMtx.RawMtx)^, TD3DXMatrix(ShdrViewProjection));

 // -> World-Inverse-Transpose
 D3DXMatrixInverse(TD3DXMatrix(ShdrWorldInverse), nil,
  PD3DXMatrix(WorldMtx.RawMtx)^);
 D3DXMatrixTranspose(TD3DXMatrix(ShdrWorldInverseTranspose),
  TD3DXMatrix(ShdrWorldInverse));

 // -> View-Inverse
{ D3DXMatrixInverse(TD3DXMatrix(ShdrViewInverse), nil,
  PD3DXMatrix(ViewMtx.RawMtx)^);

 // -> Camera Position
 ShdrCameraPosition.x:= ShdrViewInverse.Data[3, 0];
 ShdrCameraPosition.y:= ShdrViewInverse.Data[3, 1];
 ShdrCameraPosition.z:= ShdrViewInverse.Data[3, 2];}

 View:= PLMatrix4(ViewMtx.RawMtx);
 ShdrCameraPosition.x:= -View[0] * View[12] - View[1] * View[13] -
  View[2] * View[14];
 ShdrCameraPosition.y:= -View[4] * View[12] - View[5] * View[13] -
  View[6] * View[14];
 ShdrCameraPosition.z:= -View[8] * View[12] - View[9] * View[13] -
  View[10] * View[14];
// ShdrCameraPosition:= ViewMtx.Position;
end;

//--------------------------------------------------------------------------
initialization
 WorldMtx:= TAsphyreMatrix.Create();
 ViewMtx := TAsphyreMatrix.Create();
 ProjMtx := TAsphyreMatrix.Create();

//--------------------------------------------------------------------------
finalization
 ProjMtx.Free();
 ViewMtx.Free();
 WorldMtx.Free();

//--------------------------------------------------------------------------
end.
