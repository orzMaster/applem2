unit USprite_Color;

interface

implementation

uses
  SysUtils, HGE, HGESprite, HGEColor, HGEFont, UTestBase;

procedure Test;
const
  BlendModes: array [0..3] of Cardinal = (
    BLEND_COLORMUL or BLEND_ALPHABLEND,
    BLEND_COLORMUL or BLEND_ALPHAADD,
    BLEND_COLORADD or BLEND_ALPHABLEND,
    BLEND_COLORADD or BLEND_ALPHAADD);
  BlendModeStrings: array [0..3] of String = (
    'ColorMul + AlphaBlend (def.)',
    'ColorMul + AlphaAdd',
    'ColorAdd + AlphaBlend',
    'ColorAdd + AlphaAdd');
var
  Texture: ITexture;
  Sprite: IHGESprite;
  Color: THGEColor;
  I, Y: Integer;
begin
  Texture := Engine.Texture_Load('zazaka.png');
  Sprite := THGESprite.Create(Texture,0,0,Texture.GetWidth,Texture.GetHeight);
  Color := THGEColor.Create(0.5,0.2,0.7,1);
  Engine.Gfx_Clear(Color.GetHWColor);
  Y := 10;
  // Try all 4 blend modes
  for I := 0 to 3 do begin
    Sprite.SetBlendMode(BlendModes[I]);
    LargeFont.Render(330,Y + 20,HGETEXT_LEFT,
      Format('Blend mode: %s',[BlendModeStrings[I]]));
    Sprite.Render(10,Y);
    // Change color for entire sprite to red
    Color := THGEColor.Create(1,0,0,1);
    Sprite.SetColor(Color.GetHWColor);
    Sprite.Render(70,Y);
    // Set top color (vertices 0 and 1) to blue and bottom to green
    Color.R := 0; Color.B := 1;
    Sprite.SetColor(Color.GetHWColor,0);
    Sprite.SetColor(Color.GetHWColor,1);
    Color.B := 0; Color.G := 1;
    Sprite.SetColor(Color.GetHWColor,2);
    Sprite.SetColor(Color.GetHWColor,3);
    Sprite.Render(130,Y);
    // Different colors for all vertices
    Color.G := 0; Color.R := 1;
    Sprite.SetColor(Color.GetHWColor,0);
    Color.G := 1;
    Sprite.SetColor(Color.GetHWColor,3);
    Sprite.Render(190,Y);
    // Restore color (to white) but make bottom transparent
    Color := THGEColor.Create(1,1,1,1);
    Sprite.SetColor(Color.GetHWColor);
    Color.A := 0;
    Sprite.SetColor(Color.GetHWColor,2);
    Sprite.SetColor(Color.GetHWColor,3);
    Sprite.Render(250,Y);
    // Restore color
    Color := THGEColor.Create(1,1,1,1);
    Sprite.SetColor(Color.GetHWColor);
    Inc(Y,80);
  end;
end;

initialization
  RegisterTest('Sprite color and blend','Sprite\USprite_Color',Test);

end.
