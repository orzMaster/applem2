unit AsphyreEffects;

//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Direct3D9, AsphyreAsserts;

//---------------------------------------------------------------------------
const
 fxUndefined   = -1;

//---------------------------------------------------------------------------
// The above effects are handled by internal handler. If you need to add
// additional effects, define them in your unit and include your handler
// function using EffectManager.Include(YourFunctionHere). Make sure to
// set Handled to TRUE.
//---------------------------------------------------------------------------
 fxuAdd         = $100;
 fxuAddNA       = $101;
 fxuBlend       = $102;
 fxuShadow      = $103;
 fxuMultiply    = $104;
 fxuInvMultiply = $105;
 fxuBlendNA     = $106;
 fxuSub         = $107;
 fxuRevSub      = $108;
 fxuMax         = $109;
 fxuMin         = $10A;
 fxuNoBlend     = $10F;
 fxuInvShadow   = $110;

 fxuMultiBlend  = $180;
 fxuMultiAdd    = $181;

 fxfDiffuse     = $200;
 fxfAlphaTest   = $400;

//---------------------------------------------------------------------------
// Composite rendering effects
//---------------------------------------------------------------------------
 fxFullBlend    = fxuBlend or fxfDiffuse or fxfAlphaTest;
 fxFullShadow   = fxuShadow or fxfDiffuse or fxfAlphaTest;
 fxFullAdd      = fxuAdd or fxfDiffuse or fxfAlphaTest;

//---------------------------------------------------------------------------
type
 TAsphyreEffectHandler = procedure(Sender: TObject; Dev9: IDirect3DDevice9;
  var Code: Integer; var Handled: Boolean) of object;

//---------------------------------------------------------------------------
 TAsphyreEffectManager = class
 private
  Data: array of TAsphyreEffectHandler;

  function GetHandler(Num: Integer): TAsphyreEffectHandler;
  function GetHandlersCount(): Integer;
  procedure DefaultEffectHandler(Sender: TObject; Dev9: IDirect3DDevice9;
   var Code: Integer; var Handled: Boolean);
 public
  property Handlers: Integer read GetHandlersCount;
  property Handler[Num: Integer]: TAsphyreEffectHandler read GetHandler; default;

  function IndexOf(Event: TAsphyreEffectHandler): Integer;
  procedure Remove(Index: Integer);

  function Include(Event: TAsphyreEffectHandler): Integer;
  procedure Exclude(Event: TAsphyreEffectHandler);

  function HandleCode(Sender: TObject; Dev9: IDirect3DDevice9;
   Code: Integer): Boolean;

  constructor Create();
 end;

//---------------------------------------------------------------------------
var
 EffectManager: TAsphyreEffectManager = nil;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
constructor TAsphyreEffectManager.Create();
begin
 inherited;
 
 Include(DefaultEffectHandler);
end;

//---------------------------------------------------------------------------
function TAsphyreEffectManager.GetHandlersCount(): Integer;
begin
 Result:= Length(Data);
end;

//---------------------------------------------------------------------------
function TAsphyreEffectManager.GetHandler(Num: Integer): TAsphyreEffectHandler;
begin
 Assert((Num >= 0)and(Num < Length(Data)), msgIndexOutOfBounds);
 Result:= Data[Num];
end;

//---------------------------------------------------------------------------
function TAsphyreEffectManager.IndexOf(Event: TAsphyreEffectHandler): Integer;
var
 i: Integer;
begin
 Result:= -1;
 
 for i:= 0 to Length(Data) - 1 do
  if (@Data[i] = @Event) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
function TAsphyreEffectManager.Include(Event: TAsphyreEffectHandler): Integer;
var
 Index: Integer;
begin
 Index:= IndexOf(Event);
 if (Index = -1) then
  begin
   Index:= Length(Data);
   SetLength(Data, Index + 1);

   Data[Index]:= Event;
  end;

 Result:= Index;
end;

//---------------------------------------------------------------------------
procedure TAsphyreEffectManager.Remove(Index: Integer);
var
 i: Integer;
begin
 Assert((Index >= 0)and(Index < Length(Data)), msgIndexOutOfBounds);

 for i:= Index to Length(Data) - 2 do
  Data[i]:= Data[i + 1];

 SetLength(Data, Length(Data) - 1);
end;

//---------------------------------------------------------------------------
procedure TAsphyreEffectManager.Exclude(Event: TAsphyreEffectHandler);
var
 Index: Integer;
begin
 Index:= IndexOf(Event);
 if (Index <> -1) then Remove(Index);
end;

//---------------------------------------------------------------------------
function TAsphyreEffectManager.HandleCode(Sender: TObject;
 Dev9: IDirect3DDevice9; Code: Integer): Boolean;
var
 i: Integer;
begin
 Result:= False;

 for i:= Length(Data) - 1 downto 0 do
  begin
   Data[i](Sender, Dev9, Code, Result);
   if (Result) then Break;
  end;
end;

//---------------------------------------------------------------------------
procedure TAsphyreEffectManager.DefaultEffectHandler(Sender: TObject;
 Dev9: IDirect3DDevice9; var Code: Integer; var Handled: Boolean);
begin
 case Code of
  fxuMultiBlend:
   with Dev9 do
    begin
     SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
     SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
     SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);

     SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_BLENDTEXTUREALPHA);
     SetTextureStageState(1, D3DTSS_COLORARG1, D3DTA_TEXTURE);
     SetTextureStageState(1, D3DTSS_COLORARG2, D3DTA_CURRENT);


     SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
     SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
     SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);

     SetTextureStageState(1, D3DTSS_ALPHAOP, D3DTOP_BLENDTEXTUREALPHA);
     SetTextureStageState(1, D3DTSS_ALPHAARG1, D3DTA_CURRENT);

     SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, 0);
     SetTextureStageState(1, D3DTSS_TEXCOORDINDEX, 1);

     SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
     SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
     SetSamplerState(0, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR);
     SetSamplerState(1, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
     SetSamplerState(1, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
     SetSamplerState(1, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR);

     SetRenderState(D3DRS_SRCBLEND,  D3DBLEND_SRCALPHA);
     SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
     SetRenderState(D3DRS_BLENDOP,   D3DBLENDOP_ADD);

     SetRenderState(D3DRS_ALPHATESTENABLE, iTrue);
     SetRenderState(D3DRS_ALPHAFUNC, D3DCMP_GREATEREQUAL);
     SetRenderState(D3DRS_ALPHAREF, $00000001);
     SetRenderState(D3DRS_ALPHABLENDENABLE, iTrue);

     Handled:= True;
     Exit;
    end;

  fxuMultiAdd:
   with Dev9 do
    begin
     SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
     SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
     SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);

     SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_BLENDTEXTUREALPHA);
     SetTextureStageState(1, D3DTSS_COLORARG1, D3DTA_TEXTURE);
     SetTextureStageState(1, D3DTSS_COLORARG2, D3DTA_CURRENT);


     SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
     SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
     SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);

     SetTextureStageState(1, D3DTSS_ALPHAOP, D3DTOP_SELECTARG1);
     SetTextureStageState(1, D3DTSS_ALPHAARG1, D3DTA_CURRENT);

     SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, 0);
     SetTextureStageState(1, D3DTSS_TEXCOORDINDEX, 1);

     SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
     SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
     SetSamplerState(0, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR);
     SetSamplerState(1, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
     SetSamplerState(1, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
     SetSamplerState(1, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR);

     SetRenderState(D3DRS_SRCBLEND,  D3DBLEND_SRCALPHA);
     SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
     SetRenderState(D3DRS_BLENDOP,   D3DBLENDOP_ADD);

     SetRenderState(D3DRS_ALPHATESTENABLE, iTrue);
     SetRenderState(D3DRS_ALPHAFUNC, D3DCMP_GREATEREQUAL);
     SetRenderState(D3DRS_ALPHAREF, $00000001);
     SetRenderState(D3DRS_ALPHABLENDENABLE, iTrue);

    Handled:= True;
    Exit;
   end;
   else
   with Dev9 do
    begin
     SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DISABLE);
     SetTextureStageState(1, D3DTSS_ALPHAOP, D3DTOP_DISABLE);
     SetTextureStageState(1, D3DTSS_COLORARG1, D3DTA_CURRENT);
     SetTextureStageState(1, D3DTSS_ALPHAARG1, D3DTA_CURRENT);
    end;
  end;

 if (Code and fxfDiffuse > 0)  then
  begin
   Dev9.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
   Dev9.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
   Code:= Code xor fxfDiffuse;
  end else
  begin
   Dev9.SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_SELECTARG1);
   Dev9.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_SELECTARG1);
  end;

 if (Code and fxfAlphaTest > 0) then
  begin
   Dev9.SetRenderState(D3DRS_ALPHATESTENABLE, iTrue);
   Dev9.SetRenderState(D3DRS_ALPHAFUNC, D3DCMP_GREATEREQUAL);
   Dev9.SetRenderState(D3DRS_ALPHAREF, $00000001);
   Code:= Code xor fxfAlphaTest;
  end else
  begin
   Dev9.SetRenderState(D3DRS_ALPHATESTENABLE, iFalse);
  end;

 if (Code = fxuNoBlend) then
  begin
   Dev9.SetRenderState(D3DRS_ALPHABLENDENABLE, iFalse);
  end else
  begin
   Dev9.SetRenderState(D3DRS_ALPHABLENDENABLE, iTrue);
  end;

 case Code of
  fxuAdd:
   begin
    Dev9.SetRenderState(D3DRS_SRCBLEND,  D3DBLEND_SRCALPHA);
    Dev9.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
    Dev9.SetRenderState(D3DRS_BLENDOP,   D3DBLENDOP_ADD);

    Handled:= True;
   end;

  fxuAddNA:
   begin
    Dev9.SetRenderState(D3DRS_SRCBLEND,  D3DBLEND_ONE);
    Dev9.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
    Dev9.SetRenderState(D3DRS_BLENDOP,   D3DBLENDOP_ADD);

    Handled:= True;
   end;

  fxuBlend:
   begin
    Dev9.SetRenderState(D3DRS_SRCBLEND,  D3DBLEND_SRCALPHA);
    Dev9.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
    Dev9.SetRenderState(D3DRS_BLENDOP,   D3DBLENDOP_ADD);

    Handled:= True;
   end;

  fxuShadow:
   begin
    Dev9.SetRenderState(D3DRS_SRCBLEND,  D3DBLEND_ZERO);
    Dev9.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
    Dev9.SetRenderState(D3DRS_BLENDOP,   D3DBLENDOP_ADD);

    Handled:= True;
   end;

  fxuInvShadow:
   begin
    Dev9.SetRenderState(D3DRS_SRCBLEND,  D3DBLEND_ZERO);
    Dev9.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_SRCALPHA);
    Dev9.SetRenderState(D3DRS_BLENDOP,   D3DBLENDOP_ADD);

    Handled:= True;
   end;

  fxuMultiply:
   begin
    Dev9.SetRenderState(D3DRS_SRCBLEND,  D3DBLEND_ZERO);
    Dev9.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_SRCCOLOR);
    Dev9.SetRenderState(D3DRS_BLENDOP,   D3DBLENDOP_ADD);

    Handled:= True;
   end;

  fxuInvMultiply:
   begin
    Dev9.SetRenderState(D3DRS_SRCBLEND,  D3DBLEND_ZERO);
    Dev9.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCCOLOR);
    Dev9.SetRenderState(D3DRS_BLENDOP,   D3DBLENDOP_ADD);

    Handled:= True;
   end;

  fxuBlendNA:
   begin
    Dev9.SetRenderState(D3DRS_SRCBLEND,  D3DBLEND_SRCCOLOR);
    Dev9.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCCOLOR);
    Dev9.SetRenderState(D3DRS_BLENDOP,   D3DBLENDOP_ADD);

    Handled:= True;
   end;

  fxuSub:
   begin
    Dev9.SetRenderState(D3DRS_SRCBLEND,  D3DBLEND_SRCALPHA);
    Dev9.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
    Dev9.SetRenderState(D3DRS_BLENDOP,   D3DBLENDOP_SUBTRACT);

    Handled:= True;
   end;

  fxuRevSub:
   begin
    Dev9.SetRenderState(D3DRS_SRCBLEND,  D3DBLEND_SRCALPHA);
    Dev9.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
    Dev9.SetRenderState(D3DRS_BLENDOP,   D3DBLENDOP_REVSUBTRACT);

    Handled:= True;
   end;

  fxuMax:
   begin
    Dev9.SetRenderState(D3DRS_SRCBLEND,  D3DBLEND_ONE);
    Dev9.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
    Dev9.SetRenderState(D3DRS_BLENDOP,   D3DBLENDOP_MAX);

    Handled:= True;
   end;

  fxuMin:
   begin
    Dev9.SetRenderState(D3DRS_SRCBLEND,  D3DBLEND_ONE);
    Dev9.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_ONE);
    Dev9.SetRenderState(D3DRS_BLENDOP,   D3DBLENDOP_MIN);

    Handled:= True;
   end;

 end;
end;

//---------------------------------------------------------------------------
initialization
 EffectManager:= TAsphyreEffectManager.Create();

//---------------------------------------------------------------------------
finalization
 EffectManager.Free();
 EffectManager:= nil;

//---------------------------------------------------------------------------
end.
