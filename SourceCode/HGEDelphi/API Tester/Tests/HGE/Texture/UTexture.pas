unit UTexture;

interface

implementation

uses
  HGE, HGESprite, HGEFont, UTestBase;

procedure Test;
var
  Texture: ITexture;
  Sprite: IHGESprite;
  W, H, X, Y: Integer;
  Color: Cardinal;
  P: PLongword;
begin
  // Load texture from file
  Texture := Engine.Texture_Load('texture.jpg');
  W := Texture.GetWidth;
  H := Texture.GetHeight;
  Sprite := THGESprite.Create(Texture,0,0,W,H);
  Sprite.RenderEx(10,10,0,0.7);
  LargeFont.PrintF(20,20,HGETEXT_LEFT,'Texture width: %d'#13'Texture height: %d',[W,H]);
  // Create new texture, lock pixels and fill with gradient
  Texture := Engine.Texture_Create(256,256);
  P := Texture.Lock(False);
  for Y := 0 to 255 do begin
    Color := $FF0000FF or Cardinal(Y shl 16);
    for X := 0 to 255 do begin
      P^ := Color;
      Inc(P);
    end;
  end;
  Texture.Unlock;
  Sprite := THGESprite.Create(Texture,0,0,256,256);
  Sprite.RenderEx(410,10,0,1.4);
end;

initialization
  RegisterTest('Texture Functions','HGE\Texture\UTexture',Test);

end.
