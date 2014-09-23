unit IEDCode;

{
  this unit for delphi2007 decodestring;
}

interface

uses
  Windows, SysUtils;

function IEnCodeString(inText: string): string;
function IDeCodeString(inText: string): string;

implementation

uses
  IdZLib;

const
  CMask_n4CEEF4: Integer = $408D4D;
  CMask_n4CEEF8: LongWord = $C08BA52E;
  CMask_w4CEF00: Word = $8D34;
  CMask_n4CEEFC: Integer = $408D97;
  CEncodeBitMasks: array [0 .. 255] of Byte = ( //
    $2F, $52, $03, $D2, $6B, $05, $8E, $CA, $60, $E4, $8F, $BC, $27, $36, $97, $FF, //
    $68, $41, $FB, $16, $2D, $E0, $B0, $51, $2A, $83, $FE, $46, $82, $12, $C4, $E5, //
    $18, $42, $EE, $C0, $7C, $28, $0D, $45, $DA, $73, $1A, $8C, $F5, $4E, $E3, $43, //
    $6A, $2C, $3E, $FA, $AF, $3F, $32, $67, $62, $64, $66, $E1, $DF, $D1, $F8, $58, //
    $C2, $57, $91, $89, $BF, $B3, $48, $E7, $53, $14, $7B, $F1, $B2, $DC, $EF, $DE, //
    $1C, $34, $93, $35, $A8, $40, $AB, $EB, $2E, $5C, $09, $5D, $0F, $06, $CD, $6E, //
    $7F, $B1, $A4, $5E, $39, $20, $AC, $FC, $65, $E6, $0A, $25, $50, $98, $85, $00, //
    $BA, $6F, $10, $D8, $E8, $95, $3C, $4A, $17, $24, $C8, $A1, $1D, $C3, $A5, $1E, //
    $31, $33, $8A, $F6, $77, $9F, $90, $0C, $CF, $C9, $79, $71, $BE, $B4, $4F, $B7, //
    $9B, $0E, $22, $F0, $87, $D6, $9D, $96, $0B, $08, $59, $FD, $3D, $AD, $D7, $47, //
    $38, $3B, $DB, $B9, $61, $80, $F7, $72, $04, $4B, $88, $A6, $B8, $F3, $E2, $DD, //
    $44, $49, $15, $54, $C1, $B6, $21, $7D, $81, $86, $F9, $D3, $76, $CB, $5A, $9A, //
    $11, $78, $D0, $7A, $5F, $B5, $37, $9C, $AA, $26, $8B, $C7, $7E, $5B, $D4, $94, //
    $E9, $1B, $01, $6C, $56, $A0, $30, $29, $A7, $A9, $2B, $AE, $07, $A2, $1F, $4C, //
    $69, $9E, $A3, $D9, $F4, $23, $55, $BD, $6D, $70, $3A, $ED, $F2, $74, $84, $75, //
    $EA, $BB, $92, $C5, $EC, $13, $99, $02, $8D, $D5, $19, $4D, $C6, $63, $CE, $CC //
    );

  CDecodeBitMasks: array [0 .. 255] of Byte = ( //
    $3A, $A3, $41, $FB, $66, $C6, $76, $B2, $B1, $D5, $A2, $F3, $A4, $8B, $C2, $59, //
    $A0, $8D, $5A, $DA, $2D, $28, $8C, $91, $3E, $32, $CC, $1F, $FE, $B6, $77, $9E, //
    $BB, $81, $F1, $B9, $71, $78, $55, $22, $70, $B8, $D3, $3F, $C5, $44, $97, $98, //
    $EC, $9F, $4A, $56, $D6, $E9, $4F, $E1, $00, $EF, $A9, $52, $62, $FC, $ED, $60, //
    $AA, $A1, $CD, $FA, $8F, $37, $09, $F6, $08, $7B, $9B, $79, $96, $1C, $D7, $47, //
    $FF, $C8, $C7, $2A, $49, $74, $80, $17, $BC, $CA, $6A, $CB, $89, $33, $BD, $4E, //
    $92, $B7, $18, $D0, $99, $D8, $7F, $A7, $3B, $2E, $AF, $53, $26, $07, $8E, $0A, //
    $73, $5D, $2B, $3D, $1A, $9A, $0F, $21, $7A, $16, $DF, $C0, $63, $C4, $E4, $40, //
    $4C, $27, $86, $7D, $C1, $29, $F4, $46, $EA, $4B, $48, $64, $E5, $1E, $CE, $14, //
    $E8, $69, $31, $9C, $36, $C3, $E6, $5B, $68, $A5, $12, $B3, $AC, $5E, $6E, $AD, //
    $F2, $39, $67, $65, $B5, $02, $B4, $E2, $01, $06, $A8, $42, $95, $DE, $50, $94, //
    $38, $FD, $5F, $4D, $D1, $A6, $82, $51, $34, $6C, $20, $05, $EE, $2C, $E3, $11, //
    $75, $E0, $D2, $87, $7C, $35, $23, $58, $F0, $57, $6F, $6D, $F9, $8A, $AE, $0B, //
    $AB, $2F, $13, $84, $1B, $15, $25, $61, $BA, $19, $CF, $EB, $9D, $43, $85, $72, //
    $B0, $88, $DB, $D9, $1D, $93, $BF, $DD, $54, $F8, $83, $10, $7E, $F7, $BE, $F5, //
    $03, $0E, $5C, $0D, $C9, $0C, $90, $3C, $45, $6B, $DC, $E7, $30, $04, $D4, $24 //
    );

function Encode6BitBuf(inBuffer, outBuffer: PChar; inSize, outSize: Integer): Integer;
var
  i: Integer;
  nRestCount: Integer;
  btMade: Byte;
  btCh: Byte;
  btRest: Byte;
begin
  Result := 0;
  nRestCount := 0;
  btRest := 0;
  for i := 0 to inSize - 1 do
  begin
    if Result >= outSize then
      Break;
    btCh := Byte(inBuffer[i]);
    asm
      push    edx
      mov     dl, [btch]
      rol     dl, 3
      mov     [btch], dl
      pop     edx
    end;
    btCh := (CEncodeBitMasks[btCh] xor CMask_n4CEEFC) xor CMask_n4CEEF4;
    btCh := btCh xor (HiByte(LoWord(CMask_n4CEEF8)) + LoByte(LoWord(CMask_n4CEEF8)));
    btMade := Byte((btRest or (btCh shr (2 + nRestCount))) and $3F);
    btRest := Byte(((btCh shl (8 - (2 + nRestCount))) shr 2) and $3F);
    Inc(nRestCount, 2);
    if nRestCount < 6 then
    begin
      outBuffer[Result] := Char(btMade + $3C);
      Inc(Result);
    end
    else
    begin
      if Result < outSize - 1 then
      begin
        outBuffer[Result] := Char(btMade + $3C);
        outBuffer[Result + 1] := Char(btRest + $3C);
        Inc(Result, 2);
      end
      else
      begin
        outBuffer[Result] := Char(btMade + $3C);
        Inc(Result);
      end;
      nRestCount := 0;
      btRest := 0;
    end;
  end;
  if nRestCount > 0 then
  begin
    outBuffer[Result] := Char(btRest + $3C);
    Inc(Result);
  end;
  outBuffer[Result] := #0;
end;

function Decode6BitBuf(inBuffer, outBuffer: PChar; inSize, outSize: Integer): Integer;
const
  CMasks: array [2 .. 6] of Byte = ($FC, $F8, $F0, $E0, $C0);
var
  i, nBitPos, nMadeBit: Integer;
  btCh, btTmp, btByte: Byte;
begin
  Result := 0;
  nBitPos := 2;
  nMadeBit := 0;
  btCh := 0;
  btTmp := 0;
  for i := 0 to inSize - 1 do
  begin
    if Integer(inBuffer[i]) - $3C >= 0 then
      btCh := Byte(inBuffer[i]) - $3C
    else
    begin
      // Result := 0;
      Break;
    end;
    if Result >= outSize then
      Break;
    if (nMadeBit + 6) >= 8 then
    begin
      btByte := Byte(btTmp or ((btCh and $3F) shr (6 - nBitPos)));
      btByte := btByte xor (HiByte(LoWord(CMask_n4CEEF8)) + LoByte(LoWord(CMask_n4CEEF8)));
      btByte := btByte xor LoByte(LoWord(CMask_n4CEEF4));
      btByte := CDecodeBitMasks[btByte] xor LoByte(CMask_w4CEF00);
      asm
        push    edx
        mov     dl, [btByte]
        ror     dl, 3
        mov     [btByte], dl
        pop     edx
      end;
      outBuffer[Result] := Char(btByte);
      Inc(Result);
      nMadeBit := 0;
      if nBitPos < 6 then
        Inc(nBitPos, 2)
      else
      begin
        nBitPos := 2;
        Continue;
      end;
    end;
    btTmp := Byte(Byte(btCh shl nBitPos) and CMasks[nBitPos]);
    Inc(nMadeBit, 8 - nBitPos);
  end;
  if (Result <= outSize) then
    outBuffer[Result] := #0;
end;

const
  CNormalBufLen = 10240;

function IEncodeString(inText: string): string;
var
  tmp, inBuffer: array [0 .. CNormalBufLen - 1] of Char;
{$IFDEF VER230}
  inSize: LongWord;
{$ELSE}
  inSize: Integer;
{$ENDIF}
  vCompress: Pointer;
begin
  Result := '';
  if inText = '' then
    exit;
  inSize := Length(inText);
  Move(PChar(inText)^, inBuffer, inSize);
  try
    CompressBuf(@inBuffer[0], inSize, vCompress, inSize);
    PByte(vCompress)^ := inSize;
    Move(vCompress^, inBuffer, inSize);
    OutputDebugString(PChar(format('0x%s', [IntToHex(PInteger(vCompress)^, 8)])));
    inBuffer[inSize] := #0;
    FreeMem(vCompress);
  except
    raise;
  end;
  Encode6BitBuf(@inBuffer[0], @tmp[0], inSize, CNormalBufLen);
  Result := StrPas(tmp);
end;

function IDeCodeString(inText: string): string;
var
  tmp: array [0 .. CNormalBufLen - 1] of Char;
  inSize: Integer;
  vCompress: Pointer;
begin
  inSize := Decode6BitBuf(PChar(inText), @tmp[0], Length(inText), CNormalBufLen);
  try
    tmp[0] := Char($78);
    DecompressBuf(@tmp[0], inSize, 0, vCompress, inSize);
    Move(vCompress^, tmp[0], inSize);
    tmp[inSize] := #0;
    FreeMem(vCompress);
  except
    raise;
  end;
  Result := StrPas(tmp);
end;

end.