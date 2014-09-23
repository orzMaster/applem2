unit D3DX81mobb;

interface
uses
  Windows, DirectXGraphics, JEDIFile;


const D3DX81DLLName = 'JEDI.dll';

type
  PD3DXMatrix = ^TD3DXMatrix;
  TD3DXMatrix = TD3DMatrix;

  PD3DXVector3 = ^TD3DXVector3;
  TD3DXVector3 = TD3DVector;

  TD3DXImageFileFormat = {$IFNDEF NOENUMS}({$ELSE}LongWord;{$ENDIF}
{$IFDEF NOENUMS}const{$ENDIF}
    D3DXIFF_BMP         = 0{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
    D3DXIFF_JPG         = 1{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
    D3DXIFF_TGA         = 2{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
    D3DXIFF_PNG         = 3{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
    D3DXIFF_DDS         = 4{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
    D3DXIFF_PPM         = 5{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
    D3DXIFF_DIB         = 6{$IFNDEF NOENUMS},{$ELSE};{$ENDIF}
    D3DXIFF_FORCE_DWORD = $7fffffff{$IFNDEF NOENUMS}){$ENDIF};

const IdentityMatrix : TD3DXMatrix = (_11 : 1; _12 : 0; _13 : 0; _14 : 0;
                                      _21 : 0; _22 : 1; _23 : 0; _24 : 0;
                                      _31 : 0; _32 : 0; _33 : 1; _34 : 0;
                                      _41 : 0; _42 : 0; _43 : 0; _44 : 1);

function D3DXMatrixIdentity(out Out : TD3DXMatrix) : PD3DXMatrix;

function D3DXCreateTexture(Device : IDirect3DDevice8; Width, Height, MipLevels : Cardinal; Usage : LongWord; Format : TD3DFormat; Pool : TD3DPool; out Texture : IDirect3DTexture8) : HResult; stdcall;

function D3DXMatrixScaling(out Out : TD3DXMatrix; sx, sy, sz : Single) : PD3DXMatrix; stdcall; overload;

function D3DXMatrixTranslation(out Out : TD3DXMatrix; x, y, z : Single) : PD3DXMatrix; stdcall; overload;

function D3DXMatrixMultiply(out Out : TD3DXMatrix; var M1, M2 : TD3DXMatrix) : PD3DXMatrix; stdcall; overload;

function D3DXMatrixOrthoOffCenterLH(out Out : TD3DXMatrix; l, r, b, t, zn, zf : Single) : PD3DXMatrix; stdcall; overload;

function D3DXMatrixRotationZ(out Out : TD3DXMatrix; Angle : Single) : PD3DXMatrix; stdcall; overload;

function D3DXSaveSurfaceToFile(DestFile : PAnsiChar; const DestFormat : TD3DXImageFileFormat; SrcSurface : IDirect3DSurface8; SrcPalette : PPaletteEntry; SrcRect : PRect) : HResult; stdcall; overload;

implementation

function D3DXCreateTexture(Device : IDirect3DDevice8; Width, Height, MipLevels : Cardinal; Usage : LongWord; Format : TD3DFormat; Pool : TD3DPool; out Texture : IDirect3DTexture8) : HResult; stdcall; external D3DX81DLLName;

function D3DXMatrixScaling(out Out : TD3DXMatrix; sx, sy, sz : Single) : PD3DXMatrix; stdcall; external D3DX81DLLName;

function D3DXMatrixTranslation(out Out : TD3DXMatrix; x, y, z : Single) : PD3DXMatrix; stdcall; external D3DX81DLLName;

function D3DXMatrixMultiply(out Out : TD3DXMatrix; var M1, M2 : TD3DXMatrix) : PD3DXMatrix; stdcall; external D3DX81DLLName;

function D3DXMatrixOrthoOffCenterLH(out Out : TD3DXMatrix; l, r, b, t, zn, zf : Single) : PD3DXMatrix; stdcall; external D3DX81DLLName;

function D3DXMatrixRotationZ(out Out : TD3DXMatrix; Angle : Single) : PD3DXMatrix; stdcall; external D3DX81DLLName;

function D3DXSaveSurfaceToFile(DestFile : PAnsiChar; const DestFormat : TD3DXImageFileFormat; SrcSurface : IDirect3DSurface8; SrcPalette : PPaletteEntry; SrcRect : PRect) : HResult; stdcall; external D3DX81DLLName name 'D3DXSaveSurfaceToFileA';

function D3DXMatrixIdentity(out Out : TD3DXMatrix) : PD3DXMatrix;
begin
  Out := IdentityMatrix;
  Result := @Out;
end;

end.
