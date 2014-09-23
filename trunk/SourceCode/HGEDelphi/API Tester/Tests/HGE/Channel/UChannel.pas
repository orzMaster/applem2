unit UChannel;

interface

implementation

uses
  Windows, HGE, HGEFont, UTestBase;

procedure Test;
var
  Music: IMusic;
  Channel: IChannel;
  I, J: Integer;
  P, S: Single;
begin
  Music := Engine.Music_Load('Music.s3m');
  Channel := Music.Play(True); // Looped

  // Slowly increase volume
  I := 0;
  while Running and (I <= 100) do begin
    Channel.SetVolume(I);
    Inc(I,10);
    Sleep(100);
  end;

  // Pan from center to left to right to center again
  I := 0; J := -10;
  while Running do begin
    Channel.SetPanning(I);
    Inc(I,J);
    if (I = 0) and (J < 0) then
      Break;
    if (I <= -100) or (I >= 100) then
      J := -J;
    Sleep(100);
  end;

  // Change pitch from 1.0 to 0.5 to 2.0 to 1.0 again
  P := 1; S := 0.95;
  while Running do begin
    Channel.SetPitch(P);
    P := P * S;
    if (P >= 0.96) and (P <= 1.04) and (S < 1) then begin
      Channel.SetPitch(1);
      Break;
    end;
    if (P <= 0.5) or (P >= 2.0) then
      S := 1 / S;
    Sleep(100);
  end;

  Sleep(500);
  Channel.Pause;
  Sleep(500);
  Channel.Resume;

  // Show playback position
  while Running do begin
    Engine.Gfx_BeginScene;
    Engine.Gfx_Clear(0);
    LargeFont.PrintF(10,10,HGETEXT_LEFT,'%.4f / %.4f',[Channel.GetPos,Channel.GetLength]);
    Engine.Gfx_EndScene;
    Sleep(20);
  end;
end;

initialization
  RegisterTest('Channel Functions','HGE\Channel\UChannel',Test,[toManualGfx]);

end.
