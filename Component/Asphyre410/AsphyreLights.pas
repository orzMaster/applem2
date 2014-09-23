unit AsphyreLights;
//---------------------------------------------------------------------------
// AsphyreLights.pas                                    Modified: 28-Jan-2007
// Direct3D wrapper for Light Sources in 3D                      Version 1.01
//---------------------------------------------------------------------------
// Important Notice:
//
// If you modify/use this code or one of its parts either in original or
// modified form, you must comply with Mozilla Public License v1.1,
// specifically section 3, "Distribution Obligations". Failure to do so will
// result in the license breach, which will be resolved in the court.
// Remember that violating author's rights is considered a serious crime in
// many countries. Thank you!
//
// !! Please *read* Mozilla Public License 1.1 document located at:
//  http://www.mozilla.org/MPL/
//
// If you require any clarifications about the license, feel free to contact
// us or post your question on our forums at: http://www.afterwarp.net
//---------------------------------------------------------------------------
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS"
// basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
// License for the specific language governing rights and limitations
// under the License.
//
// The Original Code is AsphyreLights.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//--------------------------------------------------------------------------
uses
 Direct3D9, Vectors3, AsphyreAsserts, TrueColors;

//--------------------------------------------------------------------------
type
 TAsphyreLightType = (altOmni, altDirectional, ltSpotlight);

//--------------------------------------------------------------------------
 PAsphyreLight = ^TAsphyreLight;
 TAsphyreLight = record
  Active   : Boolean;           // The status of light source
  LightType: TAsphyreLightType; // Type of light source
  Diffuse  : TTrueColor;        // Diffuse color of light
  Specular : TTrueColor;        // Specular color of light
  Ambient  : TTrueColor;        // Ambient color of light
  Position : TVector3;          // Position in world space
  Direction: TVector3;          // Direction in world space
  Range    : Single;            // Cutoff range
  Falloff  : Single;            // Falloff
  Theta    : Single;            // Inner angle of spotlight cone
  Phi      : Single;            // Outer angle of spotlight cone
  AttenConstant : Single;       // Constant attenuation
  AttenLinear   : Single;       // Linear attenuation
  AttenQuadratic: Single;       // Quadratic attenuation
 end;

//--------------------------------------------------------------------------
 TAsphyreLights = class
 private
  FScene: TObject;
  Lights: array[0..7] of TAsphyreLight;

  function GetLight(Num: Integer): PAsphyreLight;
  procedure LightToStruct(Source: PAsphyreLight; Dest: PD3DLight9);
 protected
  procedure ResetLights();
 public
  property Scene: TObject read FScene;
  property Light[Num: Integer]: PAsphyreLight read GetLight; default;

  constructor Create(AScene: TObject);

  function UpdateStates(): Boolean;
 end;

//--------------------------------------------------------------------------
implementation

//--------------------------------------------------------------------------
uses
 AsphyreScene;

//--------------------------------------------------------------------------
constructor TAsphyreLights.Create(AScene: TObject);
begin
 inherited Create();

 FScene:= AScene;
 Assert((FScene <> nil)and(FScene is TAsphyreScene), msgInvalidOwner);

 ResetLights();
end;

//--------------------------------------------------------------------------
function TAsphyreLights.GetLight(Num: Integer): PAsphyreLight;
begin
 Assert((Num >= 0)and(Num <= 7), msgIndexOutOfBounds);
 Result:= @Lights[Num];
end;

//--------------------------------------------------------------------------
procedure TAsphyreLights.ResetLights();
var
 i: Integer;
begin
 for i:= Low(Lights) to High(Lights) do
  begin
   FillChar(Lights[i], SizeOf(TAsphyreLight), 0);

   Lights[i].Diffuse  := $FFFFFF;
   Lights[i].Ambient  := $202020;
   Lights[i].Specular := $FFFFFF;
   Lights[i].LightType:= altOmni;
   Lights[i].Range    := 4000.0;
   Lights[i].Direction:= UnityVec3;

   Lights[i].AttenConstant:= 1.0;
  end;
end;

//--------------------------------------------------------------------------
procedure TAsphyreLights.LightToStruct(Source: PAsphyreLight;
 Dest: PD3DLight9);
begin
 case Source.LightType of
  altOmni:
   Dest._Type:= D3DLIGHT_POINT;

  altDirectional:
   Dest._Type:= D3DLIGHT_DIRECTIONAL;

  ltSpotlight:
   Dest._Type:= D3DLIGHT_SPOT;
 end;

 Dest.Diffuse  := TD3DColorValue(Source.Diffuse);
 Dest.Specular := TD3DColorValue(Source.Specular);
 Dest.Ambient  := TD3DColorValue(Source.Ambient);
 Dest.Position := TD3DVector(Source.Position);
 Dest.Direction:= TD3DVector(Source.Direction);
 Dest.Falloff  := Source.Falloff;
 Dest.Theta    := Source.Theta;
 Dest.Phi      := Source.Phi;
 Dest.Range    := Source.Range;

 Dest.Attenuation0:= Source.AttenConstant;
 Dest.Attenuation1:= Source.AttenLinear;
 Dest.Attenuation2:= Source.AttenQuadratic;
end;

//--------------------------------------------------------------------------
function TAsphyreLights.UpdateStates(): Boolean;
var
 CurLight: TD3DLight9;
 i, LightIndex: Integer;
begin
 Assert(TAsphyreScene(FScene).Device.Initialized, msgNotInitialized);

 Result:= True;

 LightIndex:= 0;
 for i:= Low(Lights) to High(Lights) do
  if (Lights[i].Active) then
   begin
    LightToStruct(@Lights[i], @CurLight);

    with TAsphyreScene(FScene).Device.Dev9 do
     begin
      SetLight(LightIndex, CurLight);
      LightEnable(LightIndex, True);
     end;

    Inc(LightIndex); 
   end;

 // disable the rest of lights
 for i:= LightIndex to 7 do
  TAsphyreScene(FScene).Device.Dev9.LightEnable(i, False);
end;

//--------------------------------------------------------------------------
end.
