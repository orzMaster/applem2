unit GameInstancing;

//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 d3dx9, Matrices4, AsphyreUtils, InstanceMeshes, AsphyreScene;

//---------------------------------------------------------------------------
type
 PMeshInstance = ^TMeshInstance;
 TMeshInstance = record
  // Original instance data
  Mesh    : TInstanceMesh;
  Color   : Cardinal;
  WorldMtx: TMatrix4;

  // Calculated instance data
  WorldViewMtx: TMatrix4;
  InvWorldTMtx: TMatrix4;
 end;

//---------------------------------------------------------------------------
 TMeshInstances = class
 private
  Instances: array of TMeshInstance;
  DrawOrder: array of PMeshInstance;
  DataCount: Integer;
  Capacity : Integer;

  procedure Grow();
  procedure InitDrawOrder();
  function CompareDrawOrder(Left, Right: PMeshInstance): Integer;
  procedure SortDrawOrder(Left, Right: Integer);
 public
  function Draw(Mesh: TInstanceMesh; Color: Cardinal;
   const WorldMtx: TMatrix4): Integer;

  procedure Render();

  constructor Create();
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
var
 Instances: TMeshInstances = nil;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 GameTypes, InstanceShaders, GameMeshes;

//---------------------------------------------------------------------------
const
 MinGrow  = 4;
 GrowUnit = 8;

//---------------------------------------------------------------------------
constructor TMeshInstances.Create();
begin
 inherited;

 Capacity := 0;
 DataCount:= 0;
end;

//---------------------------------------------------------------------------
destructor TMeshInstances.Destroy();
begin

 inherited;
end;

//---------------------------------------------------------------------------
procedure TMeshInstances.Grow();
var
 Delta: Integer;
begin
 Delta:= MinGrow + (Capacity div GrowUnit);
 Inc(Capacity, Delta);

 SetLength(Instances, Capacity);
 SetLength(DrawOrder, Capacity);
end;

//---------------------------------------------------------------------------
function TMeshInstances.Draw(Mesh: TInstanceMesh; Color: Cardinal;
 const WorldMtx: TMatrix4): Integer;
begin
 if (DataCount >= Capacity) then Grow();

 Result:= DataCount;
 Inc(DataCount);

 // Insert instance data
 Instances[Result].Mesh    := Mesh;
 Instances[Result].Color   := Color;
 Instances[Result].WorldMtx:= WorldMtx;

 // Precalculate additional instance parameters
 with Instances[Result] do
  begin
   // -> World-View matrix
   D3DXMatrixMultiply(TD3DXMatrix(WorldViewMtx), TD3DXMatrix(WorldMtx),
    PD3DXMatrix(ViewMtx.RawMtx)^);

   // -> Inverse-World transpose matrix
   D3DXMatrixInverse(TD3DXMatrix(InvWorldTMtx), nil, TD3DXMatrix(WorldMtx));
   D3DXMatrixTranspose(TD3DXMatrix(InvWorldTMtx), TD3DXMatrix(InvWorldTMtx));
  end;
end;

//---------------------------------------------------------------------------
procedure TMeshInstances.InitDrawOrder();
var
 i: Integer;
begin
 for i:= 0 to DataCount - 1 do
  DrawOrder[i]:= @Instances[i];
end;

//---------------------------------------------------------------------------
function TMeshInstances.CompareDrawOrder(Left, Right: PMeshInstance): Integer;
begin
 if (Left.Mesh = Right.Mesh) then
  begin // Sort by depth
   Result:= 0;
   if (Left.WorldViewMtx.Data[3, 2] < Right.WorldViewMtx.Data[3, 2]) then
    Result:= -1 else
   if (Left.WorldViewMtx.Data[3, 2] > Right.WorldViewMtx.Data[3, 2]) then
    Result:= 1;
  end else
  begin // Sort by type
   Result:= -1;
   if (Integer(@Left.Mesh) > Integer(@Right.Mesh)) then Result:= 1;
  end;
end;

//---------------------------------------------------------------------------
procedure TMeshInstances.SortDrawOrder(Left, Right: Integer);
var
 Lo, Hi  : Integer;
 TempElem: PMeshInstance;
 MidValue: PMeshInstance;
begin
 Lo:= Left;
 Hi:= Right;
 MidValue:= DrawOrder[(Left + Right) div 2];

 repeat
  while (CompareDrawOrder(DrawOrder[Lo], MidValue) < 0) do Inc(Lo);
  while (CompareDrawOrder(DrawOrder[Hi], MidValue) > 0) do Dec(Hi);

  if (Lo <= Hi) then
   begin
    TempElem:= DrawOrder[Lo];
    DrawOrder[Lo]:= DrawOrder[Hi];
    DrawOrder[Hi]:= TempElem;

    Inc(Lo);
    Dec(Hi);
   end;
 until (Lo > Hi);

 if (Left < Hi) then SortDrawOrder(Left, Hi);
 if (Lo < Right) then SortDrawOrder(Lo, Right);
end;

//---------------------------------------------------------------------------
procedure TMeshInstances.Render();
var
 i: Integer;
 Mesh: TInstanceMesh;
 Count: Integer;
begin
 if (DataCount < 1) then Exit;

 InitDrawOrder();
 SortDrawOrder(0, DataCount - 1);

 Mesh := nil;
 Count:= 0;

 for i:= 0 to DataCount - 1 do
// for i:= DataCount - 1 downto 0 do
  begin
   if ((Mesh <> DrawOrder[i].Mesh)or(Count >= NumShdrInstances))and
    (Mesh <> nil) then
    begin
     InstanceShader.Update();
     Mesh.Draw2(InstanceShader, Count);
     Count:= 0;
    end;

   Mesh:= DrawOrder[i].Mesh;

   InstanceShader.WorldMtx[Count]:= DrawOrder[i].WorldMtx;
   InstanceShader.Color[Count]   := DrawOrder[i].Color;
   Inc(Count);


//   MeshCube.Draw(Shader, DrawOrder[i].WorldMtx, DrawOrder[i].Color);
  end;

 if (Count > 0) then
  begin
   InstanceShader.Update();
   Mesh.Draw2(InstanceShader, Count);
  end;

 DataCount:= 0; 
end;

//---------------------------------------------------------------------------
initialization
 Instances:= TMeshInstances.Create();

//---------------------------------------------------------------------------
finalization
 Instances.Free();
 Instances:= nil;

//---------------------------------------------------------------------------
end.
