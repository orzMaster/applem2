unit AsphyreDXUtils;

//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Direct3D9;

//---------------------------------------------------------------------------
function ToD3DColorValue(Color: Cardinal): TD3DColorValue;
function FromD3DColorValue(const Value: TD3DColorValue): Cardinal;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
function ToD3DColorValue(Color: Cardinal): TD3DColorValue;
begin
 Result.b:= (Color and $FF) / 255.0;
 Result.g:= ((Color shr 8) and $FF) / 255.0;
 Result.r:= ((Color shr 16) and $FF) / 255.0;
 Result.a:= ((Color shr 24) and $FF) / 255.0;
end;

//---------------------------------------------------------------------------
function FromD3DColorValue(const Value: TD3DColorValue): Cardinal;
begin
 Result:= Round(Value.b * 255.0) or (Round(Value.g * 255.0) shl 8) or
  (Round(Value.r * 255.0) shl 16) or (Round(Value.a * 255.0) shl 24);
end;

//---------------------------------------------------------------------------
end.
