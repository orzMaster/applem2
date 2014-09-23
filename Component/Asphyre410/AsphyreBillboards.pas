unit AsphyreBillboards;
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
 Windows, Direct3D9, D3DX9, Vectors2, Vectors3, Vectors4, Matrices4,
 AsphyreTypes, AsphyreUtils, AsphyreDevices, AsphyreEvents, AsphyreEffects,
 AsphyreTextures, AsphyreImages, BBTypes;

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
 TBillboardPoints = array[0..3] of TVector4;

//---------------------------------------------------------------------------
 TAsphyreBB = class
 private
  FDevice   : TAsphyreDevice;
  FBBList   : TAsphyreBillboards;
  PosArray  : TVectors4;
  DepthOrder: array of Integer;

  VertexBuffer: IDirect3DVertexBuffer9;
  IndexBuffer : IDirect3DIndexBuffer9;
  VertexArray : Pointer;
  IndexArray  : Pointer;

  FVertexCache: Integer;
  FIndexCache : Integer;
  FVertexCount: Integer;
  FIndexCount : Integer;

  FPrimitives   : Integer;
  FMaxPrimitives: Integer;

  FCacheStall : Integer;
  CachedDrawFx: Integer;
  CachedTex   : TAsphyreCustomTexture;

  procedure InitCacheSpec();
  procedure CreateStaticObjects();
  procedure DestroyStaticObjects();

  procedure OnDeviceCreate(Sender: TObject; EventParam: Pointer;
   var Success: Boolean); virtual;
  procedure OnDeviceDestroy(Sender: TObject; EventParam: Pointer;
   var Success: Boolean); virtual;

  function CreateDynamicBuffers(): Boolean;
  procedure DestroyDynamicBuffers();
  procedure ResetDeviceStates();

  procedure OnDeviceReset(Sender: TObject; EventParam: Pointer;
   var Success: Boolean); virtual;
  procedure OnDeviceLost(Sender: TObject; EventParam: Pointer;
   var Success: Boolean); virtual;

  function UploadVertexBuffer(): Boolean;
  function UploadIndexBuffer(): Boolean;

  function PrepareDraw(): Boolean;
  function BufferDraw(): Boolean;

  procedure RequestCache(Vertices, Indices, DrawFx: Integer;
   ReqTex: TAsphyreCustomTexture);
  function NextVertexEntry(): Pointer;
  procedure AddIndexEntry(Index: Integer);
  procedure ResetCache();

  procedure MakeDepthOrder();
  procedure SortDepthOrder(Left, Right: Integer);
  procedure AddToCache(const Pos: TVector4; const Points: TPoint4;
   const Mapping: TPoint4; Color: Cardinal; Tex: TAsphyreCustomTexture;
   DrawFx: Integer);
 public
  property Device: TAsphyreDevice read FDevice;
  property BBList: TAsphyreBillboards read FBBList;

  // Indicates how many times the buffer has been flushed out inside current
  // scene block.
  property CacheStall: Integer read FCacheStall;

  procedure Draw(const Pos: TVector3; const Size: TPoint2; Phi: Single;
   Color: Cardinal; Image: TAsphyreCustomImage; Pattern: Integer;
   DrawFx: Integer);
  procedure Render(ViewMtx, ProjMtx: PMatrix4);

  constructor Create(ADevice: TAsphyreDevice);
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//----------------------------------------------------------------------------
const
 VertexType = D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1;

//--------------------------------------------------------------------------
type
//--------------------------------------------------------------------------
 PVertexRecord = ^TVertexRecord;
 TVertexRecord = record
  Vertex  : TVector3;
  Diffuse : Longword;
  TexCoord: TPoint2;
 end;

//---------------------------------------------------------------------------
constructor TAsphyreBB.Create(ADevice: TAsphyreDevice);
begin
 inherited Create();

 FDevice:= ADevice;
 FBBList:= TAsphyreBillboards.Create();

 PosArray:= TVectors4.Create();

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
destructor TAsphyreBB.Destroy();
begin
 DestroyDynamicBuffers();
 DestroyStaticObjects();

 EventDeviceLost.Unsubscribe(OnDeviceLost);
 EventDeviceReset.Unsubscribe(OnDeviceReset);
 EventDeviceDestroy.Unsubscribe(OnDeviceDestroy);
 EventDeviceCreate.Unsubscribe(OnDeviceCreate);

 PosArray.Free();
 FBBList.Free();

 inherited;
end;

//---------------------------------------------------------------------------
procedure TAsphyreBB.InitCacheSpec();
begin
 with FDevice.Caps9 do
  begin
   FMaxPrimitives:= Min2(MaxPrimitiveCount, MaxCachedPrimitives);
   FVertexCache:= Min2(MaxVertexIndex, MaxCachedVertices);
   FIndexCache:= Min2(MaxVertexIndex, MaxCachedIndexes);
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreBB.CreateStaticObjects();
begin
 ReallocMem(VertexArray, FVertexCache * SizeOf(TVertexRecord));
 FillChar(VertexArray^, FVertexCache * SizeOf(TVertexRecord), 0);

 ReallocMem(IndexArray, FIndexCache * SizeOf(Word));
 FillChar(IndexArray^, FIndexCache * SizeOf(Word), 0);
end;

//---------------------------------------------------------------------------
procedure TAsphyreBB.DestroyStaticObjects();
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
procedure TAsphyreBB.OnDeviceCreate(Sender: TObject; EventParam: Pointer;
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
function TAsphyreBB.CreateDynamicBuffers(): Boolean;
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
procedure TAsphyreBB.DestroyDynamicBuffers();
begin
 if (IndexBuffer <> nil) then IndexBuffer:= nil;
 if (VertexBuffer <> nil) then VertexBuffer:= nil;
end;

//---------------------------------------------------------------------------
procedure TAsphyreBB.ResetDeviceStates();
begin
 FVertexCount:= 0;
 FIndexCount := 0;
 FPrimitives := 0;

 CachedDrawFx:= fxUndefined;
 CachedTex   := nil;

 FCacheStall:= 0;
end;

//---------------------------------------------------------------------------
procedure TAsphyreBB.OnDeviceDestroy(Sender: TObject; EventParam: Pointer;
 var Success: Boolean);
begin
 DestroyStaticObjects();
end;

//---------------------------------------------------------------------------
procedure TAsphyreBB.OnDeviceReset(Sender: TObject; EventParam: Pointer;
 var Success: Boolean);
begin
 Success:= CreateDynamicBuffers();
 if (Success) then ResetDeviceStates();
end;

//---------------------------------------------------------------------------
procedure TAsphyreBB.OnDeviceLost(Sender: TObject; EventParam: Pointer;
 var Success: Boolean);
begin
 DestroyDynamicBuffers();
end;

//---------------------------------------------------------------------------
function TAsphyreBB.UploadVertexBuffer(): Boolean;
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
function TAsphyreBB.UploadIndexBuffer(): Boolean;
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
function TAsphyreBB.PrepareDraw(): Boolean;
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
function TAsphyreBB.BufferDraw(): Boolean;
begin
 with FDevice.Dev9 do
  begin
   Result:= Succeeded(DrawIndexedPrimitive(D3DPT_TRIANGLELIST, 0, 0,
    FVertexCount, 0, FPrimitives));
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreBB.ResetCache();
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
end;

//---------------------------------------------------------------------------
procedure TAsphyreBB.RequestCache(Vertices, Indices, DrawFx: Integer;
 ReqTex: TAsphyreCustomTexture);
var
 NeedReset: Boolean;
begin
 NeedReset:= (FVertexCount + Vertices > FVertexCache);
 NeedReset:= NeedReset or (FIndexCount + Indices > FIndexCache);
 NeedReset:= NeedReset or (CachedDrawFx <> DrawFx) or (CachedTex <> ReqTex);

 if (NeedReset) then
  begin
   ResetCache();

   if (CachedTex <> ReqTex) then
    with FDevice.Dev9 do
     begin
      if (ReqTex <> nil) then ReqTex.Activate(0) else SetTexture(0, nil);
      CachedTex:= ReqTex;
     end;

   if (CachedDrawFx = fxUndefined)or(CachedDrawFx <> DrawFx) then
    EffectManager.HandleCode(Self, TAsphyreDevice(FDevice).Dev9, DrawFx);

   CachedDrawFx:= DrawFx;
  end;
end;

//---------------------------------------------------------------------------
function TAsphyreBB.NextVertexEntry(): Pointer;
begin
 Result:= Pointer(Integer(VertexArray) + (FVertexCount * SizeOf(TVertexRecord)));
end;

//---------------------------------------------------------------------------
procedure TAsphyreBB.AddIndexEntry(Index: Integer);
var
 Entry: PWord;
begin
 Entry:= Pointer(Integer(IndexArray) + (FIndexCount * SizeOf(Word)));
 Entry^:= Index;

 Inc(FIndexCount);
end;

//---------------------------------------------------------------------------
procedure TAsphyreBB.Draw(const Pos: TVector3; const Size: TPoint2;
 Phi: Single; Color: Cardinal; Image: TAsphyreCustomImage; Pattern: Integer;
 DrawFx: Integer);
var
 Item: TAsphyreBillboard;
begin
 Item.Size   := Size;
 Item.Color  := Color;
 Item.DrawFx := DrawFx;
 Item.Image  := Image;
 Item.Pattern:= Pattern;
 Item.Phi    := Phi;

 FBBList.Insert(Item);
 PosArray.Add(Pos);
end;

//---------------------------------------------------------------------------
procedure TAsphyreBB.SortDepthOrder(Left, Right: Integer);
var
 Lo, Hi: Integer;
 TempIndex: Integer;
 MidValue : Single;
begin
 Lo:= Left;
 Hi:= Right;
 MidValue:= PosArray[DepthOrder[(Left + Right) shr 1]].z;

 repeat
  while (PosArray[DepthOrder[Lo]].z < MidValue) do Inc(Lo);
  while (MidValue < PosArray[DepthOrder[Hi]].z) do Dec(Hi);

  if (Lo <= Hi) then
   begin
    TempIndex:= DepthOrder[Lo];
    DepthOrder[Lo]:= DepthOrder[Hi];
    DepthOrder[Hi]:= TempIndex;

    Inc(Lo);
    Dec(Hi);
   end;
 until (Lo > Hi);

 if (Left < Hi) then SortDepthOrder(Left, Hi);
 if (Lo < Right) then SortDepthOrder(Lo, Right);
end;

//---------------------------------------------------------------------------
procedure TAsphyreBB.MakeDepthOrder();
var
 i: Integer;
begin
 SetLength(DepthOrder, PosArray.Count);

 for i:= 0 to Length(DepthOrder) - 1 do
  DepthOrder[i]:= i;

 if (Length(DepthOrder) > 1) then
  SortDepthOrder(0, Length(DepthOrder) - 1);
end;

//---------------------------------------------------------------------------
procedure TAsphyreBB.AddToCache(const Pos: TVector4; const Points: TPoint4;
 const Mapping: TPoint4; Color: Cardinal; Tex: TAsphyreCustomTexture;
 DrawFx: Integer);
var
 Entry: PVertexRecord;
begin
 RequestCache(4, 6, DrawFx, Tex);

 AddIndexEntry(FVertexCount + 0);
 AddIndexEntry(FVertexCount + 1);
 AddIndexEntry(FVertexCount + 2);

 AddIndexEntry(FVertexCount + 3);
 AddIndexEntry(FVertexCount + 0);
 AddIndexEntry(FVertexCount + 2);

 Entry:= NextVertexEntry();
 Entry.Vertex  := Vector3(Points[3].x + Pos.x, Points[3].y + Pos.y, Pos.z);
 Entry.Diffuse := Color;
 Entry.TexCoord:= Mapping[3];
 Inc(FVertexCount);

 Entry:= NextVertexEntry();
 Entry.Vertex  := Vector3(Points[0].x + Pos.x, Points[0].y + Pos.y, Pos.z);
 Entry.Diffuse := Color;
 Entry.TexCoord:= Mapping[0];
 Inc(FVertexCount);

 Entry:= NextVertexEntry();
 Entry.Vertex  := Vector3(Points[1].x + Pos.x, Points[1].y + Pos.y, Pos.z);
 Entry.Diffuse := Color;
 Entry.TexCoord:= Mapping[1];
 Inc(FVertexCount);

 Entry:= NextVertexEntry();
 Entry.Vertex  := Vector3(Points[2].x + Pos.x, Points[2].y + Pos.y, Pos.z);
 Entry.Diffuse := Color;
 Entry.TexCoord:= Mapping[2];
 Inc(FVertexCount);

 Inc(FPrimitives, 2);
end;

//---------------------------------------------------------------------------
procedure TAsphyreBB.Render(ViewMtx, ProjMtx: PMatrix4);
var
 i, Index : Integer;
 Billboard: PAsphyreBillboard;
 Tex      : TAsphyreCustomTexture;
 Mapping  : TPoint4;
 Pos      : TVector4;
 Points   : TPoint4;
begin
 PosArray.Transform(PosArray, ViewMtx);

 MakeDepthOrder();
 if (Length(DepthOrder) < 1) then Exit;

 ResetDeviceStates();

 with FDevice.Dev9 do
  begin
   SetRenderState(D3DRS_LIGHTING, iFalse);
   SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE);
   SetRenderState(D3DRS_ZENABLE, D3DZB_TRUE);

   SetRenderState(D3DRS_ALPHABLENDENABLE, iTrue);

   SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
   SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
   SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);

   SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
   SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
   SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);

   SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_SELECTARG1);
   SetTextureStageState(1, D3DTSS_COLORARG1, D3DTA_CURRENT);

   SetTextureStageState(1, D3DTSS_ALPHAOP, D3DTOP_SELECTARG1);
   SetTextureStageState(1, D3DTSS_ALPHAARG1, D3DTA_CURRENT);

   SetTransform(D3DTS_WORLD, TD3DXMatrix(IdentityMtx4));
   SetTransform(D3DTS_VIEW, TD3DXMatrix(IdentityMtx4));
   SetTransform(D3DTS_PROJECTION, PD3DXMatrix(ProjMtx)^);
  end;

 for i:= Length(DepthOrder) - 1 downto 0  do
  begin
   Index:= DepthOrder[i];

   Billboard:= FBBList[Index];
   Pos:= PosArray[Index];

   if (Pos.z > 0.0) then
    begin
     if (Billboard.Image <> nil) then
      begin
       if (Billboard.Image is TAsphyreImage) then
        begin
         Tex:= TAsphyreImage(Billboard.Image).RetreiveTex(Billboard.Pattern,
          @Mapping);
        end else
        begin
         Tex:= Billboard.Image.Texture[0];
         Mapping:= TexFull4;
        end;
      end else Tex:= nil;

     Points:= pRotate4c(ZeroVec2, Billboard.Size, Billboard.Phi);

     AddToCache(Pos, Points, Mapping, Billboard.Color, Tex, Billboard.DrawFx);
    end;
  end;

 FBBList.Clear();
 PosArray.RemoveAll();

 ResetCache(); 
end;

//---------------------------------------------------------------------------
end.

