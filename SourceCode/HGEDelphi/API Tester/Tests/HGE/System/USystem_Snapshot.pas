unit USystem_Snapshot;

interface

implementation

uses
  HGE, HGESprite, UTestBase;

procedure Test;
var
  Texture: ITexture;
  Sprite: IHGESprite;
begin
  // After execution, look for "snapshot.bmp" file in application directory
  Texture := Engine.Texture_Load('texture.jpg');
  Sprite := THGESprite.Create(Texture,0,0,Texture.GetWidth,Texture.GetHeight);
  Engine.Gfx_BeginScene;
  Engine.Gfx_Clear(0);
  Sprite.Render(144,44);
  Engine.Gfx_EndScene;
  Engine.System_Snapshot('snapshot.bmp');
end;

initialization
  RegisterTest('System_Snapshot','HGE\System\USystem_Snapshot',Test,[toManualGfx]);

end.
