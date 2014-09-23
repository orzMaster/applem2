unit USprite_Hotspot;

interface

implementation

uses
  HGE, HGESprite, UTestBase;

procedure Test;
var
  Texture: ITexture;
  Sprite: IHGESprite;
  I, Y: Integer;
begin
  Texture := Engine.Texture_Load('zazaka.png');
  Sprite := THGESprite.Create(Texture,0,0,Texture.GetWidth,Texture.GetHeight);
  Y := 0;
  // Hot spot at top-left corner by default
  for I := 0 to 1 do begin
    // Render at hot spot
    Sprite.Render(60,Y+60);
    Engine.Gfx_RenderLine(60,Y+50,60,Y+130);
    Engine.Gfx_RenderLine(50,Y+60,130,Y+60);
    // Scaling from hot spot
    Sprite.RenderEx(200,Y+60,0,1.5);
    Engine.Gfx_RenderLine(200,Y+50,200,Y+130);
    Engine.Gfx_RenderLine(190,Y+60,270,Y+60);
    // Rotate around hot spot
    Sprite.RenderEx(350,Y+60,-Pi / 4);
    Engine.Gfx_RenderLine(350,Y+50,350,Y+130);
    Engine.Gfx_RenderLine(340,Y+60,420,Y+60);
    // Set hot spot to center of sprite and repeat
    Sprite.SetHotSpot(Sprite.GetWidth / 2,Sprite.GetHeight / 2); 
    Inc(Y,200);
  end;
end;

initialization
  RegisterTest('Sprite Hot Spot','Sprite\USprite_Hotspot',Test);

end.
