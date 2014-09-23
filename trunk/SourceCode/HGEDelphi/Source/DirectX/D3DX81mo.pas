unit D3DX81mo;

interface
uses
  Windows, DirectXGraphics, JEDIFile;

type
  PD3DXMatrix = ^TD3DXMatrix;
  TD3DXMatrix = TD3DMatrix;

  PD3DXVector3 = ^TD3DXVector3;
  TD3DXVector3 = TD3DVector;

  TD3DXImageFileFormat = {$IFNDEF NOENUMS}({$ELSE}LongWord;
{$ENDIF}
{$IFDEF NOENUMS}const
{$ENDIF}
  D3DXIFF_BMP = 0{$IFNDEF NOENUMS}, {$ELSE};
{$ENDIF}
  D3DXIFF_JPG = 1{$IFNDEF NOENUMS}, {$ELSE};
{$ENDIF}
  D3DXIFF_TGA = 2{$IFNDEF NOENUMS}, {$ELSE};
{$ENDIF}
  D3DXIFF_PNG = 3{$IFNDEF NOENUMS}, {$ELSE};
{$ENDIF}
  D3DXIFF_DDS = 4{$IFNDEF NOENUMS}, {$ELSE};
{$ENDIF}
  D3DXIFF_PPM = 5{$IFNDEF NOENUMS}, {$ELSE};
{$ENDIF}
  D3DXIFF_DIB = 6{$IFNDEF NOENUMS}, {$ELSE};
{$ENDIF}
  D3DXIFF_FORCE_DWORD = $7FFFFFFF{$IFNDEF NOENUMS}){$ENDIF};

const
  IdentityMatrix: TD3DXMatrix = (_11: 1; _12: 0; _13: 0; _14: 0;
    _21: 0; _22: 1; _23: 0; _24: 0;
    _31: 0; _32: 0; _33: 1; _34: 0;
    _41: 0; _42: 0; _43: 0; _44: 1);
type
  TD3DXCreateTexture = function(Device: IDirect3DDevice8; Width, Height, MipLevels: Cardinal; Usage: LongWord; Format: TD3DFormat; Pool: TD3DPool; out Texture: IDirect3DTexture8): HResult; stdcall;
  TD3DXMatrixScaling = function(out out: TD3DXMatrix; sx, sy, sz: Single): PD3DXMatrix; stdcall;
  TD3DXMatrixTranslation = function(out out: TD3DXMatrix; x, y, z: Single): PD3DXMatrix; stdcall;
  TD3DXMatrixMultiply = function(out out: TD3DXMatrix; var M1, M2: TD3DXMatrix): PD3DXMatrix; stdcall;
  TD3DXMatrixOrthoOffCenterLH = function(out out: TD3DXMatrix; l, r, b, t, zn, zf: Single): PD3DXMatrix; stdcall;
  TD3DXMatrixRotationZ = function(out out: TD3DXMatrix; Angle: Single): PD3DXMatrix; stdcall;
  TD3DXSaveSurfaceToFile = function(DestFile: PAnsiChar; const DestFormat: TD3DXImageFileFormat; SrcSurface: IDirect3DSurface8; SrcPalette: PPaletteEntry; SrcRect: PRect): HResult; stdcall;

var
  D3DXSaveSurfaceToFile: TD3DXSaveSurfaceToFile = nil;
  D3DXMatrixRotationZ: TD3DXMatrixRotationZ = nil;
  D3DXMatrixOrthoOffCenterLH: TD3DXMatrixOrthoOffCenterLH = nil;
  D3DXMatrixMultiply: TD3DXMatrixMultiply = nil;
  D3DXMatrixTranslation: TD3DXMatrixTranslation = nil;
  D3DXMatrixScaling: TD3DXMatrixScaling = nil;
  D3DXCreateTexture: TD3DXCreateTexture = nil;

function D3DXMatrixIdentity(out out: TD3DXMatrix): PD3DXMatrix;
procedure InitializeDll();

implementation

function D3DXMatrixIdentity(out out: TD3DXMatrix): PD3DXMatrix;
begin
  out := IdentityMatrix;
  Result := @out;
end;

procedure InitializeDll();
begin
  if not Assigned(D3DXSaveSurfaceToFile) then begin
    D3DXSaveSurfaceToFile := JEDI.FindExport('D3DXSaveSurfaceToFileA');
    D3DXMatrixRotationZ := JEDI.FindExport('D3DXMatrixRotationZ');
    D3DXMatrixOrthoOffCenterLH := JEDI.FindExport('D3DXMatrixOrthoOffCenterLH');
    D3DXMatrixMultiply := JEDI.FindExport('D3DXMatrixMultiply');
    D3DXMatrixTranslation := JEDI.FindExport('D3DXMatrixTranslation');
    D3DXMatrixScaling := JEDI.FindExport('D3DXMatrixScaling');
    D3DXCreateTexture := JEDI.FindExport('D3DXCreateTexture');
  end;
end;

end.

