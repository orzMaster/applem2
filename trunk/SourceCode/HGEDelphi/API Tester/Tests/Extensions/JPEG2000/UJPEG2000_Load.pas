unit UJPEG2000_Load;

interface

implementation

uses
  HGE, HGESprite, UTestBase;

procedure Test;
var
  Texture: ITexture;
  Sprite: IHGESprite;
begin
  Texture := Engine.Texture_Load('lena.jp2');
  Sprite := THGESprite.Create(Texture,0,0,Texture.GetWidth,Texture.GetHeight);
  Sprite.Render(10,10);
end;

initialization
  RegisterTest('Load JPEG2000 image','Extensions\JPEG2000\UJPEG2000_Load',Test);

end.
