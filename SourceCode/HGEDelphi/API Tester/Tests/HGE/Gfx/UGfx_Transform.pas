unit UGfx_Transform;

interface

implementation

uses
  Windows, HGE, HGESprite, UTestBase;

var
  Texture: ITexture;
  Sprite: IHGESprite;

function RenderFunc: Boolean;
var
  I: Integer;
begin
  Engine.Gfx_BeginScene();
  Engine.Gfx_Clear(0);
  for I := 0 to 3 do
    Sprite.RenderEx(
      100 + (I and 1) * 400,
      50 + (I div 2) * 300,
      0,0.4);
  Engine.Gfx_EndScene();

  Result := False;
end;

procedure Test;
var
  I: Integer;
  Scale: Single;
begin
  Texture := Engine.Texture_Load('texture.jpg');
  Sprite := THGESprite.Create(Texture,0,0,Texture.GetWidth,Texture.GetHeight);

  Engine.System_SetState(HGE_RENDERFUNC,RenderFunc);
  while Running do begin
    { Change displacement }
    I := 0;
    while Running and (I < 200) do begin
      Engine.Gfx_SetTransform(0,0,I,I,0,1,1);
      Inc(I,2);
      Sleep(10);
    end;
    while Running and (I >= 0) do begin
      Engine.Gfx_SetTransform(0,0,I,I,0,1,1);
      Dec(I,2);
      Sleep(10);
    end;
    { Change rotation around screen center }
    I := 0;
    while Running and (I <= 360) do begin
      Engine.Gfx_SetTransform(400,300,0,0,(I * Pi) / 180,1,1);
      Inc(I,2);
      Sleep(10);
    end;
    { Change scale }
    I := 100;
    while Running and (I < 198) do begin
      Engine.Gfx_SetTransform(400,300,0,0,0,I / 100,(200 - I) / 100);
      Inc(I,2);
      Sleep(10);
    end;
    while Running and (I > 0) do begin
      Engine.Gfx_SetTransform(400,300,0,0,0,I / 100,(200 - I) / 100);
      Dec(I,2);
      Sleep(10);
    end;
    while Running and (I <= 100) do begin
      Engine.Gfx_SetTransform(400,300,0,0,0,I / 100,(200 - I) / 100);
      Inc(I,2);
      Sleep(10);
    end;
    { Combine rotation and scale }
    I := 0;
    while Running and (I <= 360) do begin
      Scale := 0.05 + Abs((I - 180) / 190);
      Engine.Gfx_SetTransform(400,300,0,0,(I * Pi) / 180,Scale,Scale);
      Inc(I,2);
      Sleep(10);
    end;
  end;
  { Reset transform }
  Engine.Gfx_SetTransform;
  Engine.System_SetState(HGE_RENDERFUNC,nil);

  Sprite := nil;
  Texture := nil;
end;

initialization
  RegisterTest('Gfx_SetTransform','HGE\Gfx\UGfx_Transform',Test,[toManualGfx]);

end.
