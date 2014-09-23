{License, info, etc
 ------------------

This implementation is made by Walied Othman, to contact me
mail to Walied.Othman@Student.KULeuven.ac.be or
Triade@ace.Ulyssis.Student.KULeuven.ac.be,
always mention wether it 's about the FGInt for Delphi or for
FreePascal, or wether it 's about the 6xs, preferably in the subject line.
If you 're going to use these implementations, at least mention my
name or something and notify me so I may even put a link on my page.
This implementation is freeware and according to the coderpunks'
manifesto it should remain so, so don 't use these implementations
in commercial software.  Encryption, as a tool to ensure privacy
should be free and accessible for anyone.  If you plan to use these
implementations in a commercial application, contact me before
doing so, that way you can license the software to use it in commercial
Software.  If any algorithm is patented in your country, you should
acquire a license before using this software.  Modified versions of this
software must contain an acknowledgement of the original author (=me).
This implementaion is available at
http://ace.ulyssis.student.kuleuven.ac.be/~triade/

copyright 2000, Walied Othman
This header may not be removed.
}

unit FGIntRSA;

interface

uses Windows, SysUtils, Controls, FGInt;

function RSAEncrypt(P: string; var exp, modb: TFGInt): string;
function RSADecrypt(E: string; var exp, modb: TFGInt): string;
function RSAEncrypBuffer(Buf:PChar; BufLen: Integer; var Exp, Modb: TFGInt): string;
procedure RSADecryptBuffer(E: string; Buf:PChar; BufLen: Integer; var exp, modb: TFGInt);
procedure RSASign(M: string; var d, n, dp, dq, p, q: TFGInt; var S: string);
procedure RSAVerify(M, S: string; var e, n: TFGInt; var valid: boolean);

implementation

{$H+}

// Encrypt a string with the RSA algorithm, P^exp mod modb = E

procedure RSADecryptBuffer(E: string; Buf:PChar; BufLen: Integer; var exp, modb: TFGInt);
var
  i, j, modbits: longint;
  EGInt, temp, temp1, temp2, temp3, ppinvq, qqinvp, zero: TFGInt;
  tempstr1, tempstr2, tempstr3: string;
  d_p, d_q, p, q: TFGInt;
begin
  Base2StringToFGInt('0', zero);
  FGIntToBase2String(modb, tempstr1);
  modbits := length(tempstr1);
  convertBase256to2(E, tempstr1);
  while copy(tempstr1, 1, 1) = '0' do
    delete(tempstr1, 1, 1);
  while (length(tempstr1) mod modbits) <> 0 do
    tempstr1 := '0' + tempstr1;
  if exp.Number = nil then begin
    FGIntModInv(q, p, temp1);
    FGIntMul(q, temp1, qqinvp);
    FGIntDestroy(temp1);
    FGIntModInv(p, q, temp1);
    FGIntMul(p, temp1, ppinvq);
    FGIntDestroy(temp1);
  end;

  j := length(tempstr1) div modbits;
  tempstr2 := '';
  for i := 1 to j do begin
    tempstr3 := copy(tempstr1, 1, modbits);
    while (copy(tempstr3, 1, 1) = '0') and (length(tempstr3) > 1) do
      delete(tempstr3, 1, 1);
    Base2StringToFGInt(tempstr3, EGInt);
    delete(tempstr1, 1, modbits);
    if tempstr3 = '0' then
      FGIntCopy(zero, temp)
    else begin
      if exp.Number <> nil then
        FGIntMontgomeryModExp(EGInt, exp, modb, temp)
      else begin
        FGIntMontgomeryModExp(EGInt, d_p, p, temp1);
        FGIntMul(temp1, qqinvp, temp3);
        FGIntCopy(temp3, temp1);
        FGIntMontgomeryModExp(EGInt, d_q, q, temp2);
        FGIntMul(temp2, ppinvq, temp3);
        FGIntCopy(temp3, temp2);
        FGIntAddMod(temp1, temp2, modb, temp);
        FGIntDestroy(temp1);
        FGIntDestroy(temp2);
      end;
    end;
    FGIntDestroy(EGInt);
    tempstr3 := '';
    FGIntToBase2String(temp, tempstr3);
    while (length(tempstr3) mod (modbits - 1)) <> 0 do
      tempstr3 := '0' + tempstr3;
    tempstr2 := tempstr2 + tempstr3;
    FGIntdestroy(temp);
  end;

  if exp.Number = nil then begin
    FGIntDestroy(ppinvq);
    FGIntDestroy(qqinvp);
  end;
  while (not (copy(tempstr2, 1, 3) = '111')) and (length(tempstr2) > 3) do
    delete(tempstr2, 1, 1);
  delete(tempstr2, 1, 3);
  ConvertBase2to256Buf(tempstr2, Buf, BufLen);
  FGIntDestroy(zero);
end;

function RSAEncrypBuffer(Buf:PChar; BufLen: Integer; var Exp, Modb: TFGInt): string;
var
  i, j, modbits: longint;
  PGInt, temp, zero: TFGInt;
  tempstr1, tempstr2, tempstr3: string;
begin
  Result := '';
  Base2StringToFGInt('0', zero);
  FGIntToBase2String(modb, tempstr1);
  modbits := length(tempstr1);
  convertBase256Bufto2(Buf, BufLen, tempstr1);
  tempstr1 := '111' + tempstr1;
  j := modbits - 1;
  while (length(tempstr1) mod j) <> 0 do
    tempstr1 := '0' + tempstr1;

  j := length(tempstr1) div (modbits - 1);
  tempstr2 := '';
  for i := 1 to j do begin
    tempstr3 := copy(tempstr1, 1, modbits - 1);
    while (copy(tempstr3, 1, 1) = '0') and (length(tempstr3) > 1) do
      delete(tempstr3, 1, 1);
    Base2StringToFGInt(tempstr3, PGInt);
    delete(tempstr1, 1, modbits - 1);
    if tempstr3 = '0' then
      FGIntCopy(zero, temp)
    else
      FGIntMontgomeryModExp(PGInt, exp, modb, temp);
    FGIntDestroy(PGInt);
    tempstr3 := '';
    FGIntToBase2String(temp, tempstr3);
    while (length(tempstr3) mod modbits) <> 0 do
      tempstr3 := '0' + tempstr3;
    tempstr2 := tempstr2 + tempstr3;
    FGIntdestroy(temp);
  end;

  while (tempstr2[1] = '0') and (length(tempstr2) > 1) do
    delete(tempstr2, 1, 1);
  ConvertBase2To256(tempstr2, Result);
  FGIntDestroy(zero);
end;

function RSAEncrypt(P: string; var exp, modb: TFGInt): string;
var
  i, j, modbits: longint;
  PGInt, temp, zero: TFGInt;
  tempstr1, tempstr2, tempstr3: string;
begin
  Result := '';
  Base2StringToFGInt('0', zero);
  FGIntToBase2String(modb, tempstr1);
  modbits := length(tempstr1);
  convertBase256to2(P, tempstr1);
  tempstr1 := '111' + tempstr1;
  j := modbits - 1;
  while (length(tempstr1) mod j) <> 0 do
    tempstr1 := '0' + tempstr1;

  j := length(tempstr1) div (modbits - 1);
  tempstr2 := '';
  for i := 1 to j do begin
    tempstr3 := copy(tempstr1, 1, modbits - 1);
    while (copy(tempstr3, 1, 1) = '0') and (length(tempstr3) > 1) do
      delete(tempstr3, 1, 1);
    Base2StringToFGInt(tempstr3, PGInt);
    delete(tempstr1, 1, modbits - 1);
    if tempstr3 = '0' then
      FGIntCopy(zero, temp)
    else
      FGIntMontgomeryModExp(PGInt, exp, modb, temp);
    FGIntDestroy(PGInt);
    tempstr3 := '';
    FGIntToBase2String(temp, tempstr3);
    while (length(tempstr3) mod modbits) <> 0 do
      tempstr3 := '0' + tempstr3;
    tempstr2 := tempstr2 + tempstr3;
    FGIntdestroy(temp);
  end;

  while (tempstr2[1] = '0') and (length(tempstr2) > 1) do
    delete(tempstr2, 1, 1);
  ConvertBase2To256(tempstr2, Result);
  FGIntDestroy(zero);
end;

// Decrypt a string with the RSA algorithm, E^exp mod modb = D
// provide nil for exp.Number if you want a speedup by using the chinese
// remainder theorem, modb = p*q, d_p*e mod (p-1) = 1 and
// d_q*e mod (q-1) where e is the encryption exponent used

function RSADecrypt(E: string; var exp, modb: TFGInt): string;
var
  i, j, modbits: longint;
  EGInt, temp, temp1, temp2, temp3, ppinvq, qqinvp, zero: TFGInt;
  tempstr1, tempstr2, tempstr3: string;
  d_p, d_q, p, q: TFGInt;
begin
  Result := '';
  Base2StringToFGInt('0', zero);
  FGIntToBase2String(modb, tempstr1);
  modbits := length(tempstr1);
  convertBase256to2(E, tempstr1);
  while copy(tempstr1, 1, 1) = '0' do
    delete(tempstr1, 1, 1);
  while (length(tempstr1) mod modbits) <> 0 do
    tempstr1 := '0' + tempstr1;
  if exp.Number = nil then begin
    FGIntModInv(q, p, temp1);
    FGIntMul(q, temp1, qqinvp);
    FGIntDestroy(temp1);
    FGIntModInv(p, q, temp1);
    FGIntMul(p, temp1, ppinvq);
    FGIntDestroy(temp1);
  end;

  j := length(tempstr1) div modbits;
  tempstr2 := '';
  for i := 1 to j do begin
    tempstr3 := copy(tempstr1, 1, modbits);
    while (copy(tempstr3, 1, 1) = '0') and (length(tempstr3) > 1) do
      delete(tempstr3, 1, 1);
    Base2StringToFGInt(tempstr3, EGInt);
    delete(tempstr1, 1, modbits);
    if tempstr3 = '0' then
      FGIntCopy(zero, temp)
    else begin
      if exp.Number <> nil then
        FGIntMontgomeryModExp(EGInt, exp, modb, temp)
      else begin
        FGIntMontgomeryModExp(EGInt, d_p, p, temp1);
        FGIntMul(temp1, qqinvp, temp3);
        FGIntCopy(temp3, temp1);
        FGIntMontgomeryModExp(EGInt, d_q, q, temp2);
        FGIntMul(temp2, ppinvq, temp3);
        FGIntCopy(temp3, temp2);
        FGIntAddMod(temp1, temp2, modb, temp);
        FGIntDestroy(temp1);
        FGIntDestroy(temp2);
      end;
    end;
    FGIntDestroy(EGInt);
    tempstr3 := '';
    FGIntToBase2String(temp, tempstr3);
    while (length(tempstr3) mod (modbits - 1)) <> 0 do
      tempstr3 := '0' + tempstr3;
    tempstr2 := tempstr2 + tempstr3;
    FGIntdestroy(temp);
  end;

  if exp.Number = nil then begin
    FGIntDestroy(ppinvq);
    FGIntDestroy(qqinvp);
  end;
  while (not (copy(tempstr2, 1, 3) = '111')) and (length(tempstr2) > 3) do
    delete(tempstr2, 1, 1);
  delete(tempstr2, 1, 3);
  ConvertBase2To256(tempstr2, Result);
  FGIntDestroy(zero);
end;

// Sign strings with the RSA algorithm, M^d mod n = S
// provide nil for exp.Number if you want a speedup by using the chinese
// remainder theorem, n = p*q, dp*e mod (p-1) = 1 and
// dq*e mod (q-1) where e is the encryption exponent used

procedure RSASign(M: string; var d, n, dp, dq, p, q: TFGInt; var S: string);
var
  MGInt, SGInt, temp, temp1, temp2, temp3, ppinvq, qqinvp: TFGInt;
begin
  Base256StringToFGInt(M, MGInt);
  if d.Number <> nil then
    FGIntMontgomeryModExp(MGInt, d, n, SGInt)
  else begin
    FGIntModInv(p, q, temp);
    FGIntMul(p, temp, ppinvq);
    FGIntDestroy(temp);
    FGIntModInv(q, p, temp);
    FGIntMul(q, temp, qqinvp);
    FGIntDestroy(temp);
    FGIntMontgomeryModExp(MGInt, dp, p, temp1);
    FGIntMul(temp1, qqinvp, temp2);
    FGIntCopy(temp2, temp1);
    FGIntMontgomeryModExp(MGInt, dq, q, temp2);
    FGIntMul(temp2, ppinvq, temp3);
    FGIntCopy(temp3, temp2);
    FGIntAddMod(temp1, temp2, n, SGInt);
    FGIntDestroy(temp1);
    FGIntDestroy(temp2);
    FGIntDestroy(ppinvq);
    FGIntDestroy(qqinvp);
  end;
  FGIntToBase256String(SGInt, S);
  FGIntDestroy(MGInt);
  FGIntDestroy(SGInt);
end;

// Verify digitally signed strings with the RSA algorihthm,
// If M = S^e mod n then ok:=true else ok:=false

procedure RSAVerify(M, S: string; var e, n: TFGInt; var valid: boolean);
var
  MGInt, SGInt, temp: TFGInt;
begin
  Base256StringToFGInt(S, SGInt);
  Base256StringToFGInt(M, MGInt);
  FGIntMod(MGInt, n, temp);
  FGIntCopy(temp, MGInt);
  FGIntMontgomeryModExp(SGInt, e, n, temp);
  FGIntCopy(temp, SGInt);
  valid := (FGIntCompareAbs(SGInt, MGInt) = Eq);
  FGIntDestroy(SGInt);
  FGIntDestroy(MGInt);
end;

end.

