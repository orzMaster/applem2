unit AsphyreWireframe;
//---------------------------------------------------------------------------
// AsphyreBillboards.pas                                Modified: 10-Mar-2007
// Asphyre billboards                                             Version 1.0
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
// The Original Code is AsphyreBillboards.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Windows, Direct3D9, D3DX9, Vectors3, Matrices4, AsphyreTypes, AsphyreUtils,
 AsphyreDevices, AsphyreEvents;

//---------------------------------------------------------------------------
const
 // The following parameters highly affect the rendering performance. The
 // higher values means that more primitives will fit in cache, but it will
 // also occupy more bandwidth, even when few primitives are rendered.
 //
 // These parameters can be fine-tuned in a finished product to improve the
 // overall performance.
 MaxCachedPrimitives = 4096;
 MaxCachedIndexes    = 8192;
 MaxCachedVertices   = 8192;

//---------------------------------------------------------------------------
type
 TWireframeMode = (wmUnspecified, wmLineList, wmTriangleList);

//---------------------------------------------------------------------------
 TAsphyreWireframe = class
 private
  FDevice     : TAsphyreDevice;
  VertexBuffer: IDirect3DVertexBuffer9;
  IndexBuffer : IDirect3DIndexBuffer9;
  VertexArray : Pointer;
  IndexArray  : Pointer;

  FVertexCache: Integer;
  FIndexCache : Integer;
  FVertexCount: Integer;
  FIndexCount : Integer;
  FCacheStall : Integer;

  FPrimitives   : Integer;
  FMaxPrimitives: Integer;
  FWireframeMode: TWireframeMode;

  procedure InitCacheSpec();
  procedure CreateStaticObjects();
  procedure DestroyStaticObjects();

  procedure OnDeviceCreate(Sender: TObject; EventParam: Pointer;
   var Success: Boolean); virtual;
  procedure OnDeviceDestroy(Sender: TObject; EventParam: Pointer;
   var Success: Boolean); virtual;

  function CreateDynamicBuffers(): Boolean;
  procedure DestroyDynamicBuffers();

  procedure OnDeviceReset(Sender: TObject; EventParam: Pointer;
   var Success: Boolean); virtual;
  procedure OnDeviceLost(Sender: TObject; EventParam: Pointer;
   var Success: Boolean); virtual;

  function UploadVertexBuffer(): Boolean;
  function UploadIndexBuffer(): Boolean;

  function PrepareDraw(): Boolean;
  function BufferDraw(): Boolean;

  procedure RequestCache(Mode: TWireframeMode; Vertices, Indices: Integer);
  function NextVertexEntry(): Pointer;
  procedure AddIndexEntry(Index: Integer);
 public
  property Device: TAsphyreDevice read FDevice;
  property WireframeMode: TWireframeMode read FWireframeMode;
  property CacheStall: Integer read FCacheStall;

  procedure DrawRect(const Pos, Vec1, Vec2: TVector3; const Colors: TColor4);
  procedure DrawWire(const Pos, Vec1, Vec2: TVector3; const Colors: TColor4);
  procedure DrawLine(const v0, v1: TVector3; Color: Cardinal);

  procedure FlushCache();

  constructor Create(ADevice: TAsphyreDevice);
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//----------------------------------------------------------------------------
const
 VertexType = D3DFVF_XYZ or D3DFVF_DIFFUSE;

//--------------------------------------------------------------------------
type
//--------------------------------------------------------------------------
 PVertexRecord = ^TVertexRecord;
 TVertexRecord = record
  Vertex : TVector3;
  Diffuse: Longword;
 end;

//---------------------------------------------------------------------------
constructor TAsphyreWireframe.Create(ADevice: TAsphyreDevice);
begin
 inherited Create();

 FDevice:= ADevice;

 EventDeviceCreate.Subscribe(OnDeviceCreate, FDevice);
 EventDeviceDestroy.Subscribe(OnDeviceDestroy, FDevice);
 EventDeviceReset.Subscribe(OnDeviceReset, FDevice);
 EventDeviceLost.Subscribe(OnDeviceLost, FDevice);

 VertexArray := nil;
 IndexArray  := nil;
 VertexBuffer:= nil;
 IndexBuffer := nil;
end;

//---------------------------------------------------------------------------
destructor TAsphyreWireframe.Destroy();
begin
 DestroyDynamicBuffers();
 DestroyStaticObjects();

 EventDeviceLost.Unsubscribe(OnDeviceLost);
 EventDeviceReset.Unsubscribe(OnDeviceReset);
 EventDeviceDestroy.Unsubscribe(OnDeviceDestroy);
 EventDeviceCreate.Unsubscribe(OnDeviceCreate);

 inherited;
end;

//---------------------------------------------------------------------------
procedure TAsphyreWireframe.InitCacheSpec();
begin
 with FDevice.Caps9 do
  begin
   FMaxPrimitives:= Min2(MaxPrimitiveCount, MaxCachedPrimitives);
   FVertexCache:= Min2(MaxVertexIndex, MaxCachedVertices);
   FIndexCache:= Min2(MaxVertexIndex, MaxCachedIndexes);
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreWireframe.CreateStaticObjects();
begin
 ReallocMem(VertexArray, FVertexCache * SizeOf(TVertexRecord));
 FillChar(VertexArray^, FVertexCache * SizeOf(TVertexRecord), 0);

 ReallocMem(IndexArray, FIndexCache * SizeOf(Word));
 FillChar(IndexArray^, FIndexCache * SizeOf(Word), 0);
end;

//---------------------------------------------------------------------------
procedure TAsphyreWireframe.DestroyStaticObjects();
begin
 if (IndexArray <> nil) then
  begin
   FreeMem(IndexArray);
   IndexArray:= nil;
  end;

 if (VertexArray <> nil) then
  begin
   FreeMem(VertexArray);
   VertexArray:= nil;
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreWireframe.OnDeviceCreate(Sender: TObject; EventParam: Pointer;
 var Success: Boolean);
begin
 Success:= (FDevice <> nil)and(FDevice is TAsphyreDevice);

 if (Success) then
  begin
   InitCacheSpec();
   CreateStaticObjects();
  end;
end;

//--------------------------------------------------------------------------
function TAsphyreWireframe.CreateDynamicBuffers(): Boolean;
begin
 // -> Dynamic Vertex Buffer
 Result:= Succeeded(TAsphyreDevice(FDevice).Dev9.CreateVertexBuffer(FVertexCache *
  SizeOf(TVertexRecord), D3DUSAGE_WRITEONLY or D3DUSAGE_DYNAMIC, VertexType,
  D3DPOOL_DEFAULT, VertexBuffer, nil));
 if (not Result) then Exit;

 // -> Dynamic Index Buffer
 Result:= Succeeded(TAsphyreDevice(FDevice).Dev9.CreateIndexBuffer(FIndexCache *
  SizeOf(Word), D3DUSAGE_WRITEONLY or D3DUSAGE_DYNAMIC, D3DFMT_INDEX16,
  D3DPOOL_DEFAULT, IndexBuffer, nil));
end;

//---------------------------------------------------------------------------
procedure TAsphyreWireframe.DestroyDynamicBuffers();
begin
 if (IndexBuffer <> nil) then IndexBuffer:= nil;
 if (VertexBuffer <> nil) then VertexBuffer:= nil;
end;

//---------------------------------------------------------------------------
procedure TAsphyreWireframe.OnDeviceDestroy(Sender: TObject; EventParam: Pointer;
 var Success: Boolean);
begin
 DestroyStaticObjects();
end;

//---------------------------------------------------------------------------
procedure TAsphyreWireframe.OnDeviceReset(Sender: TObject; EventParam: Pointer;
 var Success: Boolean);
begin
 Success:= CreateDynamicBuffers();
end;

//---------------------------------------------------------------------------
procedure TAsphyreWireframe.OnDeviceLost(Sender: TObject; EventParam: Pointer;
 var Success: Boolean);
begin
 DestroyDynamicBuffers();
end;

//---------------------------------------------------------------------------
function TAsphyreWireframe.UploadVertexBuffer(): Boolean;
var
 MemAddr: Pointer;
 BufSize: Integer;
begin
 BufSize:= FVertexCount * SizeOf(TVertexRecord);
 Result:= Succeeded(VertexBuffer.Lock(0, BufSize, MemAddr, D3DLOCK_DISCARD));

 if (Result) then
  begin
   Move(VertexArray^, MemAddr^, BufSize);
   Result:= Succeeded(VertexBuffer.Unlock());
  end;
end;

//---------------------------------------------------------------------------
function TAsphyreWireframe.UploadIndexBuffer(): Boolean;
var
 MemAddr: Pointer;
 BufSize: Integer;
begin
 BufSize:= FIndexCount * SizeOf(Word);
 Result:= Succeeded(IndexBuffer.Lock(0, BufSize, MemAddr, D3DLOCK_DISCARD));

 if (Result) then
  begin
   Move(IndexArray^, MemAddr^, BufSize);
   Result:= Succeeded(IndexBuffer.Unlock());
  end;
end;

//---------------------------------------------------------------------------
function TAsphyreWireframe.PrepareDraw(): Boolean;
begin
 with TAsphyreDevice(FDevice).Dev9 do
  begin
   // (1) Use our vertex buffer for displaying primitives.
   Result:= Succeeded(SetStreamSource(0, VertexBuffer, 0,
    SizeOf(TVertexRecord)));

   // (2) Use our index buffer to indicate the vertices of our primitives.
   if (Result) then
    Result:= Succeeded(SetIndices(IndexBuffer));

   // (3) Disable vertex shader.
   if (Result) then
    Result:= Succeeded(SetVertexShader(nil));

   // (4) Set the flexible vertex format of our vertex buffer.
   if (Result) then
    Result:= Succeeded(SetFVF(VertexType));
  end;
end;

//---------------------------------------------------------------------------
function TAsphyreWireframe.BufferDraw(): Boolean;
var
 Primitive: TD3DPrimitiveType;
begin
 Primitive:= D3DPT_TRIANGLELIST;
 if (FWireframeMode = wmLineList) then Primitive:= D3DPT_LINELIST;

 with FDevice.Dev9 do
  begin
   Result:= Succeeded(DrawIndexedPrimitive(Primitive, 0, 0, FVertexCount, 0,
    FPrimitives));
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreWireframe.FlushCache();
begin
 if (FVertexCount > 0)and(FPrimitives > 0) then
  begin
   if (UploadVertexBuffer())and(UploadIndexBuffer())and(PrepareDraw()) then
    BufferDraw();

   Inc(FCacheStall);
  end;

 FVertexCount:= 0;
 FIndexCount := 0;
 FPrimitives := 0;
 FCacheStall := 0;
 FWireframeMode:= wmUnspecified;
end;

//---------------------------------------------------------------------------
procedure TAsphyreWireframe.RequestCache(Mode: TWireframeMode; Vertices,
 Indices: Integer);
var
 NeedReset: Boolean;
begin
 NeedReset:= (FVertexCount + Vertices > FVertexCache);
 NeedReset:= NeedReset or (FIndexCount + Indices > FIndexCache);
 NeedReset:= NeedReset or (FWireframeMode = wmUnspecified) or
  (FWireframeMode <> Mode);

 if (NeedReset) then
  begin
   FlushCache();
   FWireframeMode:= Mode;
  end;
end;

//---------------------------------------------------------------------------
function TAsphyreWireframe.NextVertexEntry(): Pointer;
begin
 Result:= Pointer(Integer(VertexArray) + (FVertexCount * SizeOf(TVertexRecord)));
end;

//---------------------------------------------------------------------------
procedure TAsphyreWireframe.AddIndexEntry(Index: Integer);
var
 Entry: PWord;
begin
 Entry:= Pointer(Integer(IndexArray) + (FIndexCount * SizeOf(Word)));
 Entry^:= Index;

 Inc(FIndexCount);
end;

//---------------------------------------------------------------------------
procedure TAsphyreWireframe.DrawRect(const Pos, Vec1, Vec2: TVector3;
 const Colors: TColor4);
var
 Entry: PVertexRecord;
begin
 RequestCache(wmTriangleList, 4, 6);

 AddIndexEntry(FVertexCount + 0);
 AddIndexEntry(FVertexCount + 1);
 AddIndexEntry(FVertexCount + 2);

 AddIndexEntry(FVertexCount + 3);
 AddIndexEntry(FVertexCount + 0);
 AddIndexEntry(FVertexCount + 2);

 Entry:= NextVertexEntry();
 Entry.Vertex := Pos - (Vec1 + Vec2);
 Entry.Diffuse:= Colors[3];
 Inc(FVertexCount);

 Entry:= NextVertexEntry();
 Entry.Vertex := Pos + Vec1 - Vec2;
 Entry.Diffuse:= Colors[0];
 Inc(FVertexCount);

 Entry:= NextVertexEntry();
 Entry.Vertex := Pos + Vec1 + Vec2;
 Entry.Diffuse:= Colors[1];
 Inc(FVertexCount);

 Entry:= NextVertexEntry();
 Entry.Vertex := Pos + Vec2 - Vec1;
 Entry.Diffuse:= Colors[2];
 Inc(FVertexCount);

 Inc(FPrimitives, 2);
end;

//---------------------------------------------------------------------------
procedure TAsphyreWireframe.DrawWire(const Pos, Vec1, Vec2: TVector3;
 const Colors: TColor4);
var
 Entry: PVertexRecord;
begin
 RequestCache(wmLineList, 4, 8);

 AddIndexEntry(FVertexCount + 0);
 AddIndexEntry(FVertexCount + 1);
 AddIndexEntry(FVertexCount + 1);
 AddIndexEntry(FVertexCount + 2);
 AddIndexEntry(FVertexCount + 2);
 AddIndexEntry(FVertexCount + 3);
 AddIndexEntry(FVertexCount + 3);
 AddIndexEntry(FVertexCount + 0);

 Entry:= NextVertexEntry();
 Entry.Vertex := Pos - (Vec1 + Vec2);
 Entry.Diffuse:= Colors[3];
 Inc(FVertexCount);

 Entry:= NextVertexEntry();
 Entry.Vertex := Pos + Vec1 - Vec2;
 Entry.Diffuse:= Colors[0];
 Inc(FVertexCount);

 Entry:= NextVertexEntry();
 Entry.Vertex := Pos + Vec1 + Vec2;
 Entry.Diffuse:= Colors[1];
 Inc(FVertexCount);

 Entry:= NextVertexEntry();
 Entry.Vertex := Pos + Vec2 - Vec1;
 Entry.Diffuse:= Colors[2];
 Inc(FVertexCount);

 Inc(FPrimitives, 4);
end;

//---------------------------------------------------------------------------
procedure TAsphyreWireframe.DrawLine(const v0, v1: TVector3; Color: Cardinal);
var
 Entry: PVertexRecord;
begin
 RequestCache(wmLineList, 2, 2);

 AddIndexEntry(FVertexCount + 0);
 AddIndexEntry(FVertexCount + 1);

 Entry:= NextVertexEntry();
 Entry.Vertex := v0;
 Entry.Diffuse:= Color;
 Inc(FVertexCount);

 Entry:= NextVertexEntry();
 Entry.Vertex := v1;
 Entry.Diffuse:= Color;
 Inc(FVertexCount);

 Inc(FPrimitives);
end;

//---------------------------------------------------------------------------
end.

