unit USprite_Texture;

interface

implementation

uses
  HGE, HGESprite, UTestBase;

procedure Test;
var
  Texture: ITexture;
  Sprite: IHGESprite;
begin
  Texture := Engine.Texture_Load('zazaka.png');
  Sprite := THGESprite.Create(Texture,0,0,Texture.GetWidth,Texture.GetHeight);
  Sprite.Render(10,10);
  // Change texture
  Texture := Engine.Texture_Load('texture.jpg');
  // Sprite keeps original dimensions
  Sprite.SetTexture(Texture);
  Sprite.Render(100,10);
  // Update texture rect to entire texture
  Sprite.SetTextureRect(0,0,Texture.GetWidth,Texture.GetHeight);
  Sprite.Render(200,10);
  // Set texture rect to "left ear"
  Sprite.SetTextureRect(100,170,70,90);
  Sprite.Render(10,100);
end;

initialization
  RegisterTest('Sprite texture functions','Sprite\USprite_Texture',Test);

end.
