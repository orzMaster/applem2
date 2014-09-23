unit RSA;

interface

uses
  SysUtils, Classes, FGInt, FGIntPrimeGeneration, FGIntRSA;

type
  TRSA = class(TComponent)
  private
    FCommonalityKey: TFGInt;
    FCommonalityKeySet: Boolean;
    FCommonalityMode: TFGInt;
    FCommonalityModeSet: Boolean;
    FPrivateKey: TFGInt;
    FPrivateKeySet: Boolean;
    FServer: Boolean;
    procedure FWriteCommonalityKey(Value: string);
    function FReadCommonalityKey(): string;
    procedure FWriteCommonalityMode(Value: string);
    function FReadCommonalityMode(): string;
    procedure FWritePrivateKey(Value: string);
    function FReadPrivateKey(): string;
  protected
    { Protected declarations }
  public
    function EncryptStr(sMsg: string): string;
    function DecryptStr(sMsg: string): string;
    function EncryptBuffer(Buffer: PChar; BuffLen: Integer): string;
    procedure DecryptBuffer(sMsg: string; Buffer: PChar; BuffLen: Integer);
    function EncryptStr16(sMsg: string): string;
    function DecryptStr16(sMsg: string): string;

  published
    property CommonalityKey: string read FReadCommonalityKey write FWriteCommonalityKey;
    property CommonalityMode: string read FReadCommonalityMode write FWriteCommonalityMode;
    property PrivateKey: string read FReadPrivateKey write FWritePrivateKey;
    property Server: Boolean read FServer write FServer default False;
  end;

procedure Register;

implementation


procedure Register;
begin
  RegisterComponents('Samples', [TRSA]);
end;

function TRSA.FReadCommonalityKey(): string;
begin
  Result := '';
  if FCommonalityKeySet then
    FGIntToBase10String(FCommonalityKey, Result);
end;

procedure TRSA.FWriteCommonalityKey(Value: string);
begin
  if Value <> '' then begin
    Base10StringToFGInt(Value, FCommonalityKey);
    FCommonalityKeySet := True;
  end;
end;

procedure TRSA.FWriteCommonalityMode(Value: string);
begin
  if Value <> '' then begin
    Base10StringToFGInt(Value, FCommonalityMode);
    FCommonalityModeSet := True;
  end;
end;

function TRSA.FReadCommonalityMode(): string;
begin
  Result := '';
  if FCommonalityModeSet then
    FGIntToBase10String(FCommonalityMode, Result);
end;

procedure TRSA.FWritePrivateKey(Value: string);
begin
  if Value <> '' then begin
    Base10StringToFGInt(Value, FPrivateKey);
    FPrivateKeySet := True;
  end;
end;

function TRSA.FReadPrivateKey(): string;
begin
  Result := '';
  if FPrivateKeySet then
    FGIntToBase10String(FPrivateKey, Result);
end;

function TRSA.DecryptStr(sMsg: string): string;
var
  Test: string;
begin
  Try
    if sMsg <> '' then begin
      ConvertBase64to256(sMsg, Test);
      if FServer then
        Result := RSADecrypt(Test, FPrivateKey, FCommonalityMode)
      else
        Result := RSADecrypt(Test, FCommonalityKey, FCommonalityMode);
    end;
  Except
    Result := '';
  End;
end;

procedure TRSA.DecryptBuffer(sMsg: string; Buffer: PChar; BuffLen: Integer);
var
  Test: string;
begin
  if sMsg <> '' then begin
    ConvertBase64to256(sMsg, Test);
    if FServer then
      RSADecryptBuffer(Test, Buffer, BuffLen, FPrivateKey, FCommonalityMode)
    else
      RSADecryptBuffer(Test, Buffer, BuffLen, FCommonalityKey, FCommonalityMode);
  end;
end;

function TRSA.EncryptStr(sMsg: string): string;
var
  Test: string;
begin
  if sMsg <> '' then begin
    if FServer then
      Test := RSAEncrypt(sMsg, FPrivateKey, FCommonalityMode)
    else
      Test := RSAEncrypt(sMsg, FCommonalityKey, FCommonalityMode);
    ConvertBase256to64(Test, Result);
  end;
end;

function TRSA.EncryptBuffer(Buffer: PChar; BuffLen: Integer): string;
var
  Test: string;
begin
  Result := '';
  if BuffLen > 0 then begin
    if FServer then
      Test := RSAEncrypBuffer(Buffer, BuffLen, FPrivateKey, FCommonalityMode)
    else
      Test := RSAEncrypBuffer(Buffer, BuffLen, FCommonalityKey, FCommonalityMode);
    ConvertBase256to64(Test, Result);
  end;
end;

function TRSA.EncryptStr16(sMsg: string): string;
var
  Test: string;
  I: integer;
begin
  Test := EncryptStr(sMsg);
  Result := '';
  try
    for i := 1 to Length(Test) do begin
      Result := Result + IntToHex(Byte(Test[i]), 0);
    end;
  except
  end;
end;

function TRSA.DecryptStr16(sMsg: string): string;
var
  Test: string;
  I: integer;
begin
  Test := '';
  Result := '';
  try
    for i := 1 to Length(sMsg) div 2 do begin
      Test := Test + Char(Byte(StrToInt('$' + Copy(sMsg, I * 2 - 1, 2))));
    end;
    Result := DecryptStr(Test);
  except
  end;
end;

end.
 
