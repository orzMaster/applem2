unit USprite_Render;

interface

implementation

uses
  HGE, HGESprite, UTestBase;

procedure Test;
var
  Texture: ITexture;
  Sprite: IHGESprite;
begin
  Texture := Engine.Texture_Load('texture.jpg');
  Sprite := THGESprite.Create(Texture,0,0,Texture.GetWidth,Texture.GetHeight);
  // Top-left
  Sprite.Render(10,10);
  // Bottom-left
  Sprite.RenderStretch(10,532,522,590);
  // Top-right
  Sprite.RenderEx(532,10,-Pi / 8,0.3,0.6);
  // Bottom-right
  Sprite.Render4V(532,300, 790,350, 790,540, 532,590);
end;

initialization
  RegisterTest('Sprite rendering','Sprite\USprite_Render',Test);

end.
