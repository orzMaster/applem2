unit UTarget;

interface

implementation

uses
  HGE, HGESprite, UTestBase;

procedure Test;
var
  Texture: ITexture;
  Target: ITarget;
  Sprite, TargetSprite: IHGESprite;
begin
  Texture := Engine.Texture_Load('texture.jpg');
  Sprite := THGESprite.Create(Texture,0,0,Texture.GetWidth,Texture.GetHeight);
  Target := Engine.Target_Create(512,512,False);
  TargetSprite := THGESprite.Create(Target.GetTexture,0,0,512,512);
  // Render sprite to target, 3 times
  Engine.Gfx_BeginScene(Target);
  Engine.Gfx_Clear(0);
  Sprite.RenderEx(0,0,0,0.7);
  Sprite.RenderEx(150,150,0,0.5);
  Sprite.RenderEx(300,300,0,0.3);
  Engine.Gfx_EndScene;
  // Render target to screen, 3 times with decreasing opacity and rotation
  Engine.Gfx_BeginScene;
  Engine.Gfx_Clear(0);
  TargetSprite.Render(200,150);
  TargetSprite.SetColor($AAFFFFFF);
  TargetSprite.RenderEx(200,150,-Pi / 8,0.8);
  TargetSprite.SetColor($55FFFFFF);
  TargetSprite.RenderEx(200,150,-Pi / 4,0.6);
  Engine.Gfx_EndScene;
end;

initialization
  RegisterTest('Target Functions','HGE\Target\UTarget',Test,[toManualGfx]);

end.
