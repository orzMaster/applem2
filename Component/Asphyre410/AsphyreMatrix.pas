unit AsphyreMatrix;
//---------------------------------------------------------------------------
// AsphyreMatrix.pas                                    Modified: 06-Mar-2007
// Asphyre wrapper for Direct3D matrices                          Version 1.0
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
// The Original Code is AsphyreMatrix.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Direct3D9, D3DX9, Vectors3, Matrices4;

//---------------------------------------------------------------------------
type
 TAsphyreMatrix = class
 private
  MemAddr: Pointer;
  FRawMtx: PD3DXMatrix;
  AuxAddr: Pointer;
  AuxMtx : PD3DXMatrix;

 public
  property RawMtx: PD3DXMatrix read FRawMtx;

  procedure LoadIdentity();
  procedure LoadZero();

  procedure Translate(dx, dy, dz: Single); overload;
  procedure Translate(const Vec: TVector3); overload;
  procedure Scale(sx, sy, sz: Single); overload;
  procedure Scale(const Vec: TVector3); overload;

  procedure RotateX(Phi: Single);
  procedure RotateY(Phi: Single);
  procedure RotateZ(Phi: Single);
  procedure RotateBy(const v: TVector3; Phi: Single);

  procedure Multiply(Mtx: TAsphyreMatrix);

  procedure RotateXLocal(Phi: Single);
  procedure RotateYLocal(Phi: Single);
  procedure RotateZLocal(Phi: Single);

  procedure LookAtLH(const Eye, At, Up: TVector3);
  procedure LookAtRH(const Eye, At, Up: TVector3);

  procedure PerspectiveFovLH(FieldOfView, AspectRatio, MinRange,
   MaxRange: Single);
  procedure PerspectiveFovRH(FieldOfView, AspectRatio, MinRange,
   MaxRange: Single);

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
constructor TAsphyreMatrix.Create();
begin
 inherited;

 MemAddr:= AllocMem(SizeOf(TD3DXMatrix) + 16);
 FRawMtx:= Pointer(Integer(MemAddr) + ($10 - (Integer(MemAddr) and $0F)));

 AuxAddr:= AllocMem(SizeOf(TD3DXMatrix) + 16);
 AuxMtx := Pointer(Integer(AuxAddr) + ($10 - (Integer(AuxAddr) and $0F)));


 LoadIdentity();
end;

//---------------------------------------------------------------------------
destructor TAsphyreMatrix.Destroy();
begin
 FreeMem(AuxAddr);
 FreeMem(MemAddr);

 inherited;
end;

//---------------------------------------------------------------------------
procedure TAsphyreMatrix.LoadIdentity();
begin
 D3DXMatrixIdentity(FRawMtx^);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMatrix.LoadZero();
begin
 FillChar(FRawMtx^, SizeOf(TD3DXMatrix), 0);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMatrix.Translate(dx, dy, dz: Single);
begin
 D3DXMatrixTranslation(AuxMtx^, dx, dy, dz);
 D3DXMatrixMultiply(FRawMtx^, FRawMtx^, AuxMtx^);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMatrix.Translate(const Vec: TVector3);
begin
 D3DXMatrixTranslation(AuxMtx^, Vec.x, Vec.y, Vec.z);
 D3DXMatrixMultiply(FRawMtx^, FRawMtx^, AuxMtx^);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMatrix.Scale(sx, sy, sz: Single);
begin
 D3DXMatrixScaling(AuxMtx^, sx, sy, sz);
 D3DXMatrixMultiply(FRawMtx^, FRawMtx^, AuxMtx^);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMatrix.Scale(const Vec: TVector3);
begin
 D3DXMatrixScaling(AuxMtx^, Vec.x, Vec.y, Vec.z);
 D3DXMatrixMultiply(FRawMtx^, FRawMtx^, AuxMtx^);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMatrix.RotateX(Phi: Single);
begin
 D3DXMatrixRotationX(AuxMtx^, Phi);
 D3DXMatrixMultiply(FRawMtx^, FRawMtx^, AuxMtx^);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMatrix.RotateY(Phi: Single);
begin
 D3DXMatrixRotationY(AuxMtx^, Phi);
 D3DXMatrixMultiply(FRawMtx^, FRawMtx^, AuxMtx^);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMatrix.RotateZ(Phi: Single);
begin
 D3DXMatrixRotationZ(AuxMtx^, Phi);
 D3DXMatrixMultiply(FRawMtx^, FRawMtx^, AuxMtx^);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMatrix.Multiply(Mtx: TAsphyreMatrix);
begin
 D3DXMatrixMultiply(FRawMtx^, FRawMtx^, Mtx.RawMtx^);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMatrix.RotateBy(const v: TVector3; Phi: Single);
begin
 D3DXMatrixRotationAxis(AuxMtx^, TD3DXVector3(v), Phi);
 D3DXMatrixMultiply(FRawMtx^, FRawMtx^, AuxMtx^);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMatrix.RotateXLocal(Phi: Single);
var
 Axis: TVector3;
begin
 Axis.x:= FRawMtx.m[0, 0];
 Axis.y:= FRawMtx.m[0, 1];
 Axis.z:= FRawMtx.m[0, 2];
 RotateBy(Axis, Phi);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMatrix.RotateYLocal(Phi: Single);
var
 Axis: TVector3;
begin
 Axis.x:= FRawMtx.m[1, 0];
 Axis.y:= FRawMtx.m[1, 1];
 Axis.z:= FRawMtx.m[1, 2];
 RotateBy(Axis, Phi);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMatrix.RotateZLocal(Phi: Single);
var
 Axis: TVector3;
begin
 Axis.x:= FRawMtx.m[2, 0];
 Axis.y:= FRawMtx.m[2, 1];
 Axis.z:= FRawMtx.m[2, 2];
 RotateBy(Axis, Phi);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMatrix.LookAtLH(const Eye, At, Up: TVector3);
begin
 D3DXMatrixLookAtLH(AuxMtx^, TD3DXVector3(Eye), TD3DXVector3(At),
  TD3DXVector3(Up));
 D3DXMatrixMultiply(FRawMtx^, FRawMtx^, AuxMtx^);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMatrix.LookAtRH(const Eye, At, Up: TVector3);
begin
 D3DXMatrixLookAtRH(AuxMtx^, TD3DXVector3(Eye), TD3DXVector3(At),
  TD3DXVector3(Up));
 D3DXMatrixMultiply(FRawMtx^, FRawMtx^, AuxMtx^);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMatrix.PerspectiveFovLH(FieldOfView, AspectRatio, MinRange,
 MaxRange: Single);
begin
 D3DXMatrixPerspectiveFovLH(AuxMtx^, FieldOfView, AspectRatio, MinRange,
  MaxRange);
 D3DXMatrixMultiply(FRawMtx^, FRawMtx^, AuxMtx^);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMatrix.PerspectiveFovRH(FieldOfView, AspectRatio, MinRange,
 MaxRange: Single);
begin
 D3DXMatrixPerspectiveFovRH(AuxMtx^, FieldOfView, AspectRatio, MinRange,
  MaxRange);
 D3DXMatrixMultiply(FRawMtx^, FRawMtx^, AuxMtx^);
end;

//---------------------------------------------------------------------------
end.
