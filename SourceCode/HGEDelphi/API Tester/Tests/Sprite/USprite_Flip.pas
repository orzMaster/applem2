unit USprite_Flip;

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
  Sprite.RenderEx(10,10,0,0.5);
  // Flip horizontally
  Sprite.SetFlip(True,False);
  Sprite.RenderEx(276,10,0,0.5);
  // Flip vertically
  Sprite.SetFlip(False,True);
  Sprite.RenderEx(10,276,0,0.5);
  // Flip both ways
  Sprite.SetFlip(True,True);
  Sprite.RenderEx(276,276,0,0.5);
end;

initialization
  RegisterTest('Sprite flip function','Sprite\USprite_Flip',Test);

end.
