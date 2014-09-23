unit UAlpha_Load;

interface

implementation

uses
  HGE, HGESprite, HGEFont, UTestBase;

procedure Test;
var
  Texture: ITexture;
  Sprite: IHGESprite;
begin
  // Background
  Texture := Engine.Texture_Load('bg2.png');
  Sprite := THGESprite.Create(Texture,0,0,800,600);
  Sprite.Render(0,0);

  // Image without mask
  SmallFont.Render(10,5,HGETEXT_LEFT,'Image');
  Texture := Engine.Texture_Load('lena.jp2');
  Sprite := THGESprite.Create(Texture,0,0,Texture.GetWidth,Texture.GetHeight);
  Sprite.Render(10,20);

  // Mask
  SmallFont.Render(790,5,HGETEXT_RIGHT,'Mask');
  Texture := Engine.Texture_Load('mask.png');
  Sprite := THGESprite.Create(Texture,0,0,Texture.GetWidth,Texture.GetHeight);
  Sprite.Render(790 - Texture.GetWidth,20);

  // Image with mask
  SmallFont.Render(400,585,HGETEXT_CENTER,'Composited');
  Texture := Engine.Texture_Load('lena.jp2','mask.png');
  Sprite := THGESprite.Create(Texture,0,0,Texture.GetWidth,Texture.GetHeight);
  Sprite.Render((800 - Texture.GetWidth) / 2,580 - Texture.GetHeight);
end;

initialization
  RegisterTest('Load separate image and alpha channel','Extensions\SeparateAlpha\UAlpha_Load',Test);

end.
