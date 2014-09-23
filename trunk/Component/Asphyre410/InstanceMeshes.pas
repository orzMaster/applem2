unit InstanceMeshes;

//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Windows, Direct3D9, d3dx9, Vectors2, Vectors3, AsphyreUtils, AsphyreMeshes;

//---------------------------------------------------------------------------
// Enable the following option to enable the generation and usage of
// texture coordinates.
//---------------------------------------------------------------------------
{$define IncludeTexCoords}

//---------------------------------------------------------------------------
type
 PInstanceMeshVertex = ^TInstanceMeshVertex;
 TInstanceMeshVertex = packed record
  Position: TVector3;
  Normal  : TVector3;
  {$ifdef IncludeTexCoords}
  TexCoord: TPoint2;
  {$endif}
  Instance: Single;
 end;

//---------------------------------------------------------------------------
 TInstanceMesh = class(TAsphyreCustomMesh)
 private
  FNumCopies: Integer;

  VertexDecl: IDirect3DVertexDeclaration9;

  function CreateBuffers(Faces, Vertices: Integer): Boolean;
  function LockBuffers(Mesh: ID3DXMesh; out CurVertex,
   CurIndex: Pointer): Boolean;
  procedure UnlockBuffers(Mesh: ID3DXMesh);
 public
  property NumCopies: Integer read FNumCopies;

  function Generate(Source: TAsphyreCustomMesh; MaxCopies: Integer): Boolean;
  procedure DrawCopies(Copies: Integer);

  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
const
 {$ifdef IncludeTexCoords}
 VertexElementNo = 5;
 {$else}
 VertexElementNo = 4;
 {$endif}

//---------------------------------------------------------------------------
 VertexElements: array[0..VertexElementNo - 1] of TD3DVertexElement9 =
 (// Position
  (Stream: 0; Offset: 0; _Type: D3DDECLTYPE_FLOAT3;
   Method: D3DDECLMETHOD_DEFAULT; Usage: D3DDECLUSAGE_POSITION; UsageIndex: 0),
  // Normal
  (Stream: 0; Offset: 12; _Type: D3DDECLTYPE_FLOAT3;
   Method: D3DDECLMETHOD_DEFAULT; Usage: D3DDECLUSAGE_NORMAL; UsageIndex: 0),
  {$ifdef IncludeTexCoords}
  // TexCoord
  (Stream: 0; Offset: 24; _Type: D3DDECLTYPE_FLOAT2;
   Method: D3DDECLMETHOD_DEFAULT; Usage: D3DDECLUSAGE_TEXCOORD; UsageIndex: 0),
  // Instance Index
  (Stream: 0; Offset: 32; _Type: D3DDECLTYPE_FLOAT1;
   Method: D3DDECLMETHOD_DEFAULT; Usage: D3DDECLUSAGE_TEXCOORD; UsageIndex: 1),
  {$else}
  // Instance Index
  (Stream: 0; Offset: 24; _Type: D3DDECLTYPE_FLOAT1;
   Method: D3DDECLMETHOD_DEFAULT; Usage: D3DDECLUSAGE_TEXCOORD; UsageIndex: 1),
  {$endif}
  // D3DDECL_END()
  (Stream: $FF; Offset: 0; _Type: D3DDECLTYPE_UNUSED;
   Method: TD3DDeclMethod(0); Usage: TD3DDeclUsage(0); UsageIndex: 0));

//---------------------------------------------------------------------------
type
 PInputVertex = ^TInputVertex;
 TInputVertex = record
  Position: TVector3;
  Normal  : TVector3;
  {$ifdef IncludeTexCoords}
  TexCoord: TPoint2;
  {$endif}
 end;

//---------------------------------------------------------------------------
destructor TInstanceMesh.Destroy();
begin
 if (VertexDecl <> nil) then VertexDecl:= nil;

 inherited;
end;

//---------------------------------------------------------------------------
function TInstanceMesh.CreateBuffers(Faces, Vertices: Integer): Boolean;
begin
 if (VertexDecl <> nil) then VertexDecl:= nil;
 if (FDXMesh <> nil) then FDXMesh:= nil;

 Result:= Succeeded(Device.Dev9.CreateVertexDeclaration(@VertexElements[0],
  VertexDecl));
 if (not Result) then Exit;

 Result:= Succeeded(D3DXCreateMesh(Faces, Vertices, D3DXMESH_MANAGED or
  D3DXMESH_WRITEONLY, @VertexElements[0], Device.Dev9, FDXMesh));
end;

//---------------------------------------------------------------------------
function TInstanceMesh.LockBuffers(Mesh: ID3DXMesh; out CurVertex,
 CurIndex: Pointer): Boolean;
begin
 if (Mesh = nil) then
  begin
   Result:= False;
   Exit;
  end;

 Result:= Succeeded(Mesh.LockVertexBuffer(0, CurVertex));
 if (not Result) then Exit;

 Result:= Succeeded(Mesh.LockIndexBuffer(0, CurIndex));
 if (not Result) then
  begin
   Mesh.UnlockVertexBuffer();
   CurVertex:= nil;
  end;
end;

//---------------------------------------------------------------------------
procedure TInstanceMesh.UnlockBuffers(Mesh: ID3DXMesh);
begin
 if (Mesh <> nil) then
  begin
   Mesh.UnlockIndexBuffer();
   Mesh.UnlockVertexBuffer();
  end;
end;

//---------------------------------------------------------------------------
function TInstanceMesh.Generate(Source: TAsphyreCustomMesh;
 MaxCopies: Integer): Boolean;
var
 NumVertices, NumFaces, CopyNo, VertexNo, FaceNo: Integer;
 CurVertex: PInstanceMeshVertex;
 CurIndex : PWord;
 SrcVertex: PInputVertex;
 SrcIndex : PWord;
 SrcStride: Integer;
 InVertex : PInputVertex;
 InIndex  : PWord;
 IndexAdd : Integer;
begin
 // (1) Calculate new geometry information.
 with Source.DXMesh do
  begin
   FNumCopies := Min2(65536 div GetNumVertices(), MaxCopies);
   NumVertices:= Integer(GetNumVertices()) * FNumCopies;
   NumFaces   := Integer(GetNumFaces()) * FNumCopies;
  end;

 // (2) Create vertex & index buffers.
 Result:= CreateBuffers(NumFaces, NumVertices);
 if (not Result) then Exit;

 // (3) Obtain direct access to new vertex & index buffers.
 Result:= LockBuffers(FDXMesh, Pointer(CurVertex), Pointer(CurIndex));
 if (not Result) then Exit;

 // (4) Obtain direct access to input vertex & index buffers.
 Result:= LockBuffers(Source.DXMesh, Pointer(SrcVertex), Pointer(SrcIndex));
 if (not Result) then
  begin
   UnlockBuffers(FDXMesh);
   Exit;
  end;

 SrcStride:= Source.DXMesh.GetNumBytesPerVertex();

 // (5) Create multiple instances of the same geometry.
 for CopyNo:= 0 to FNumCopies - 1 do
  begin
   InVertex:= SrcVertex;
   InIndex := SrcIndex;

   // -> copy vertices
   for VertexNo:= 0 to Source.DXMesh.GetNumVertices() - 1 do
    begin
     CurVertex.Position:= InVertex.Position;
     CurVertex.Normal  := InVertex.Normal;
     {$ifdef IncludeTexCoords}
     CurVertex.TexCoord:= InVertex.TexCoord;
     {$endif}
     CurVertex.Instance:= CopyNo;

     Inc(CurVertex);
     Inc(Integer(InVertex), SrcStride);
    end;

   // -> copy indices
   IndexAdd:= Integer(Source.DXMesh.GetNumVertices()) * CopyNo;
   for FaceNo:= 0 to Source.DXMesh.GetNumFaces() - 1 do
    begin
     CurIndex^:= InIndex^ + IndexAdd;
     Inc(CurIndex);
     Inc(InIndex);
     CurIndex^:= InIndex^ + IndexAdd;
     Inc(CurIndex);
     Inc(InIndex);
     CurIndex^:= InIndex^ + IndexAdd;
     Inc(CurIndex);
     Inc(InIndex);
    end;
  end;

 UnlockBuffers(Source.DXMesh);
 UnlockBuffers(FDXMesh);
end;

//---------------------------------------------------------------------------
procedure TInstanceMesh.DrawCopies(Copies: Integer);
var
 VertexBuffer: IDirect3DVertexBuffer9;
 IndexBuffer : IDirect3DIndexBuffer9;
 PassNo, NoVertices, NoFaces: Integer;
begin
 FDXMesh.GetVertexBuffer(VertexBuffer);
 FDXMesh.GetIndexBuffer(IndexBuffer);

 NoVertices:= FDXMesh.GetNumVertices();
 NoFaces   := (Integer(FDXMesh.GetNumFaces()) div FNumCopies) * Copies;

 Inc(TotalVerticesNo, NoVertices);
 Inc(TotalFacesNo, NoFaces);

 with Device.Dev9 do
  begin
   SetStreamSource(0, VertexBuffer, 0, FDXMesh.GetNumBytesPerVertex());
   SetIndices(IndexBuffer);
   SetVertexDeclaration(VertexDecl);

   DrawIndexedPrimitive(D3DPT_TRIANGLELIST, 0, 0, NoVertices, 0, NoFaces);
  end;
 Inc(DrawPrimitiveCalls);

 IndexBuffer:= nil;
 VertexBuffer:= nil;
end;

//---------------------------------------------------------------------------
end.
