unit UResource_Load;

interface

implementation

uses
  Windows, HGE, UTestBase;

procedure Test;
var
  Resource: IResource;
  Effect: IEffect;
begin
  Resource := Engine.Resource_Load('menu.wav');
  Effect := Engine.Effect_Load(Resource.Handle,Resource.Size);
  Effect.Play;
  Sleep(200); // Wait for effect to finish before releasing it
end;

initialization
  RegisterTest('Resource_Load','HGE\Resource\UResource_Load',Test);

end.
