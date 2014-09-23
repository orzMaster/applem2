unit Logo;

interface
uses
  Windows, SysUtils, Classes, Graphics, HGETextures, HGEBase, DirectXGraphics, HGECanvas, Grobal2;

{.$IF Var_Free = 1}
  {.$INCLUDE LogoBitempFree.inc}
{.$ELSE}
  {$INCLUDE LogoBitemp.inc}
{.$IFEND}

var
  g_LogoSurface: TDirectDrawSurface = nil;

procedure CreateLogoSurface();
procedure DestroyLogoSurface();

implementation
uses
  CLMain;

function DecodeRLE(const Source, Target: Pointer; Count: Cardinal; bitLength: Byte): Boolean;
var
  I, j: Integer;
  SourcePtr,
  TargetPtr: PByte;
  RunLength: Cardinal;
  Counter: Cardinal;
begin
  Counter := 0;
  TargetPtr := Target;
  SourcePtr := Source;

  while Counter < Count do begin
    RunLength := 1 + (SourcePtr^ and $7F);
    if SourcePtr^ > $7F then begin
      Inc(SourcePtr);
      for I := 0 to RunLength - 1 do begin
        for j := 1 to bitLength - 1 do
        begin
          TargetPtr^ := SourcePtr^;
          Inc(SourcePtr);
          Inc(TargetPtr);
        end;
        TargetPtr^ := SourcePtr^;
        Dec(SourcePtr, bitLength - 1);
        Inc(TargetPtr);
      end;
      Inc(SourcePtr, bitLength);
    end
    else begin
      Inc(SourcePtr);
      Move(SourcePtr^, TargetPtr^, bitLength * RunLength);
      Inc(SourcePtr, bitLength * RunLength);
      Inc(TargetPtr, bitLength * RunLength);
    end;
    Inc(Counter, bitLength * RunLength);
  end;
  Result := Counter = Count;
end;

procedure CreateLogoSurface();
var
  Access: TDXAccessInfo;
  WriteBuffer, ReadBuffer, DecodeBuffer: PChar;
  Y: Integer;
begin
  DestroyLogoSurface();
  g_LogoSurface := TDXImageTexture.Create(g_DXCanvas);
  g_LogoSurface.Size := Point(LogoWidth, LogoHeight);
  g_LogoSurface.PatternSize := Point(LogoWidth, LogoHeight);
  g_LogoSurface.Format := D3DFMT_A8R8G8B8;
  g_LogoSurface.Active := True;
  if g_LogoSurface.Active then begin
    if g_LogoSurface.Lock(lfWriteOnly, Access) then begin
      GetMem(DecodeBuffer, LogoWidth * LogoHeight * 4);
      Try
        if DecodeRLE(@LogoBuffer, DecodeBuffer, LogoWidth * LogoHeight * 4, 4) then
        begin
          for Y := 0 to LogoHeight - 1 do begin
            ReadBuffer := @DecodeBuffer[Y * LogoWidth * 4];
            WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
            Move(ReadBuffer^, WriteBuffer^, LogoWidth * 4);
          end;
        end;
        {for Y := 0 to LogoHeight - 1 do begin
          ReadBuffer := @LogoBuffer[Y * LogoWidth * 2];
          WriteBuffer := Pointer(Integer(Access.Bits) + (Access.Pitch * Y));
          Move(ReadBuffer^, WriteBuffer^, LogoWidth * 2);
        end;}
      Finally
        FreeMem(DecodeBuffer);
        g_LogoSurface.Unlock;
      End;
    end; 
  end else begin
    g_LogoSurface.Free;
    g_LogoSurface := nil;
  end;
end;

procedure DestroyLogoSurface();
begin
  if g_LogoSurface <> nil then g_LogoSurface.Free;
  g_LogoSurface := nil;
end;

end.
