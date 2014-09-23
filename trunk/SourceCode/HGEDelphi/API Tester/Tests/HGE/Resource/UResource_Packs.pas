unit UResource_Packs;

interface

implementation

uses
  HGE, HGESprite, UTestBase;

procedure Test;
var
  Resource: IResource;
  Texture: ITexture;
  Sprite: IHGESprite;
begin
  if (not Engine.Resource_AttachPack('Resources.paq')) then
    Error('Cannot load resource pack');
  // Load resource from Resources.paq file
  Resource := Engine.Resource_Load('bg.png');
  Texture := Engine.Texture_Load(Resource.Handle,Resource.Size);
  Sprite := THGESprite.Create(Texture,0,0,800,600);
  Sprite.Render(0,0);
  Engine.Resource_RemoveAllPacks;
end;

initialization
  RegisterTest('Resource Packs','HGE\Resource\UResource_Packs',Test);

end.
