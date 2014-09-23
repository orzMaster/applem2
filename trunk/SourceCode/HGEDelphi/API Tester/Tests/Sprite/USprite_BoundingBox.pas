unit USprite_BoundingBox;

interface

implementation

uses
  HGE, HGESprite, HGERect, UTestBase;

procedure Test;
var
  Texture: ITexture;
  Sprite: IHGESprite;
  R: THGERect;

  procedure RenderBox(const R: THGERect);
  begin
    Engine.Gfx_RenderLine(R.X1,R.Y1,R.X2,R.Y1);
    Engine.Gfx_RenderLine(R.X2,R.Y1,R.X2,R.Y2);
    Engine.Gfx_RenderLine(R.X2,R.Y2,R.X1,R.Y2);
    Engine.Gfx_RenderLine(R.X1,R.Y2,R.X1,R.Y1-1);
  end;

begin
  Texture := Engine.Texture_Load('texture.jpg');
  Sprite := THGESprite.Create(Texture,241,59,271,240);
  Sprite.SetHotSpot(Sprite.GetWidth / 2,Sprite.GetHeight / 2);
  // Get bounding box for normal rendering
  Sprite.Render(150,300);
  Sprite.GetBoundingBox(150,300,R);
  RenderBox(R);
  // Get bounding box for transformed rendering
  Sprite.RenderEx(550,300,-Pi / 4,1.5,0.75);
  Sprite.GetBoundingBoxEx(550,300,-Pi / 4,1.5,0.75,R);
  RenderBox(R);
end;

initialization
  RegisterTest('Sprite bounding box','Sprite\USprite_BoundingBox',Test);

end.
