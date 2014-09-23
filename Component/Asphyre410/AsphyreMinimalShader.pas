unit AsphyreMinimalShader;

//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Direct3D9, d3dx9, Vectors3, Matrices4, AsphyreColors, AsphyreDevices,
 AsphyreShaderFX, AsphyreMeshes;

//---------------------------------------------------------------------------
type
 TAsphyreMinimalShader = class(TAsphyreShaderEffect)
 private
  TempColorValue: TD3DColorValue;
  TempLightVec  : TD3DXVector3;

  FDiffuseColor : TAsphyreColor;
  FSpecularColor: TAsphyreColor;
  FLightVector  : TVector3;
 protected
  procedure Describe(); override;
  procedure UpdateParam(Code: Integer; out DataPtr: Pointer;
   out DataSize: Integer); override;
 public
  property DiffuseColor : TAsphyreColor read FDiffuseColor write FDiffuseColor;
  property SpecularColor: TAsphyreColor read FSpecularColor write FSpecularColor;
  property LightVector  : TVector3 read FLightVector write FLightVector;

  procedure Draw(Mesh: TAsphyreCustomMesh);
  procedure DrawCol(Mesh: TAsphyreCustomMesh; const World: TMatrix4;
   Color: Cardinal);
  procedure DrawColSpec(Mesh: TAsphyreCustomMesh; const World: TMatrix4;
   Diffuse, Specular: Cardinal);

  constructor Create(ADevice: TAsphyreDevice);
 end;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 AsphyreScene;

//---------------------------------------------------------------------------
const
 ShdrDiffuseColor  = 1;
 ShdrSpecularColor = 2;
 ShdrLightVector   = 3;

//---------------------------------------------------------------------------
constructor TAsphyreMinimalShader.Create(ADevice: TAsphyreDevice);
begin
 inherited;

 FDiffuseColor := $FF00FF00;
 FSpecularColor:= $FFFFFFFF;
 FLightVector  := Norm3(Vector3(1.0, 1.0, 1.0));
end;

//---------------------------------------------------------------------------
procedure TAsphyreMinimalShader.Describe();
begin
 DescParam(sptWorldViewProjection,   'matWorldViewProj');
 DescParam(sptWorldInverseTranspose, 'matInvTransposeWorld');

 DescParam(sptCustom, 'vDic',        ShdrDiffuseColor);
 DescParam(sptCustom, 'vSpec',       ShdrSpecularColor);
 DescParam(sptCustom, 'vecLightDir', ShdrLightVector);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMinimalShader.UpdateParam(Code: Integer; out DataPtr: Pointer;
 out DataSize: Integer);
begin
 case Code of
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

  ShdrLightVector:
   begin
    TempLightVec:= TD3DXVector3(-Norm3(FLightVector));

    DataPtr := @TempLightVec;
    DataSize:= SizeOf(TD3DXVector3);
   end;
 end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreMinimalShader.Draw(Mesh: TAsphyreCustomMesh);
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
procedure TAsphyreMinimalShader.DrawCol(Mesh: TAsphyreCustomMesh;
 const World: TMatrix4; Color: Cardinal);
begin
 WorldMtx.LoadMtx(@World);

 DiffuseColor := Color;
 SpecularColor:= $FFFFFFFF;

 UpdateAll();

 Draw(Mesh);
end;

//---------------------------------------------------------------------------
procedure TAsphyreMinimalShader.DrawColSpec(Mesh: TAsphyreCustomMesh;
 const World: TMatrix4; Diffuse, Specular: Cardinal);
begin
 WorldMtx.LoadMtx(@World);

 DiffuseColor := Diffuse;
 SpecularColor:= Specular;

 UpdateAll();

 Draw(Mesh);
end;

//---------------------------------------------------------------------------
end.
