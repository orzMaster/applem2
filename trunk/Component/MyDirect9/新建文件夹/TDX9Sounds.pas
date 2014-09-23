unit TDX9Sounds;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, ExtCtrls, MMSystem, 
  MyDXBase, MyDXWave, MyDirectSound;

type

  {  EDirectSoundError  }

  EDirectSoundError = class(EDirectXError);
  EDirectSoundBufferError = class(EDirectSoundError);

  {  TDirectSound  }

  TDirectSoundBuffer = class;

  TDirectSound = class(TDirectX)
  private
    FBufferList: TList;
    FGlobalFocus: Boolean;
    FIDSound: IDirectSound8;
    FInRestoreBuffer: Boolean;
    FStickyFocus: Boolean;
    function GetBuffer(Index: Integer): TDirectSoundBuffer;
    function GetBufferCount: Integer;
    function GetIDSound: IDirectSound;
    function GetISound: IDirectSound;
  protected
    procedure CheckBuffer(Buffer: TDirectSoundBuffer);
    procedure DoRestoreBuffer; virtual;
  public
    constructor Create(GUID: PGUID);
    destructor Destroy; override;
    class function Drivers: TDirectXDrivers;
    property BufferCount: Integer read GetBufferCount;
    property Buffers[Index: Integer]: TDirectSoundBuffer read GetBuffer;
    property IDSound: IDirectSound read GetIDSound;
    property ISound: IDirectSound read GetISound;
  end;

  {  TDirectSoundBuffer  }

  TDirectSoundBuffer = class(TDirectX)
  private
    FDSound: TDirectSound;
    FIDSBuffer: IDirectSoundBuffer;
    FCaps: TDSBCaps;
    FFormat: PWaveFormatEx;
    FFormatSize: Integer;
    FLockAudioPtr1, FLockAudioPtr2: array[0..0] of Pointer;
    FLockAudioSize1, FLockAudioSize2: array[0..0] of DWORD;
    FLockCount: Integer;
    function GetBitCount: Longint;
    function GetFormat: PWaveFormatEx;
    function GetFrequency: Integer;
    function GetIDSBuffer: IDirectSoundBuffer;
    function GetIBuffer: IDirectSoundBuffer;
    function GetPlaying: Boolean;
    function GetPan: Integer;
    function GetPosition: Longint;
    function GetSize: Integer;
    function GetStatus: Integer;
    function GetVolume: Integer;
    procedure SetFrequency(Value: Integer);
    procedure SetIDSBuffer(Value: IDirectSoundBuffer);
    procedure SetPan(Value: Integer);
    procedure SetPosition(Value: Longint);
    procedure SetVolume(Value: Integer);
  protected
    procedure Check; override;
  public
    constructor Create(ADirectSound: TDirectSound);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function CreateBuffer(const BufferDesc: TDSBufferDesc): Boolean;
    procedure LoadFromFile(const FileName: string);
    procedure LoadFromMemory(const Format: TWaveFormatEx;
      Data: Pointer; Size: Integer);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromWave(Wave: TWave);
    function Lock(LockPosition, LockSize: Longint;
      var AudioPtr1: Pointer; var AudioSize1: Longint;
      var AudioPtr2: Pointer; var AudioSize2: Longint): Boolean;
    function Play(Loop: Boolean{$IFNDEF VER100} = False{$ENDIF}): Boolean;
    function Restore: Boolean;
    function SetFormat(const Format: TWaveFormatEx): Boolean;
    procedure SetSize(const Format: TWaveFormatEx; Size: Integer);
    procedure Stop;
    procedure UnLock;
    property BitCount: Longint read GetBitCount;
    property DSound: TDirectSound read FDSound;
    property Format: PWaveFormatEx read GetFormat;
    property FormatSize: Integer read FFormatSize;
    property Frequency: Integer read GetFrequency write SetFrequency;
    property IBuffer: IDirectSoundBuffer read GetIBuffer;
    property IDSBuffer: IDirectSoundBuffer read GetIDSBuffer write SetIDSBuffer;
    property Playing: Boolean read GetPlaying;
    property Pan: Integer read GetPan write SetPan;
    property Position: Longint read GetPosition write SetPosition;
    property Size: Integer read GetSize;
    property Volume: Integer read GetVolume write SetVolume;
  end;

  EDXSoundError = class(Exception);

  {  TCustomDXSound  }

  TCustomDX9Sound = class;

  TDXSoundOption = (soGlobalFocus, soStickyFocus, soExclusive);
  TDXSoundOptions = set of TDXSoundOption;

  TDXSoundNotifyType = (dsntDestroying, dsntInitializing, dsntInitialize, dsntFinalize, dsntRestore);
  TDXSoundNotifyEvent = procedure(Sender: TCustomDX9Sound; NotifyType: TDXSoundNotifyType) of object;

  TCustomDX9Sound = class(TComponent)
  private
    FAutoInitialize: Boolean;
    FCalledDoInitialize: Boolean;
    FDriver: PGUID;
    FDriverGUID: TGUID;
    FDSound: TDirectSound;
    FForm: TCustomForm;
    FInitialized: Boolean;
    FInternalInitialized: Boolean;
    FNotifyEventList: TList;
    FNowOptions: TDXSoundOptions;
    FOnFinalize: TNotifyEvent;
    FOnInitialize: TNotifyEvent;
    FOnInitializing: TNotifyEvent;
    FOnRestore: TNotifyEvent;
    FOptions: TDXSoundOptions;
    FPrimary: TDirectSoundBuffer;
    FSubClass: TControlSubClass;
    procedure FormWndProc(var Message: TMessage; DefWindowProc: TWndMethod);
    procedure NotifyEventList(NotifyType: TDXSoundNotifyType);
    procedure SetDriver(Value: PGUID);
    procedure SetForm(Value: TCustomForm);
    procedure SetOptions(Value: TDXSoundOptions);
  protected
    procedure DoFinalize; virtual;
    procedure DoInitialize; virtual;
    procedure DoInitializing; virtual;
    procedure DoRestore; virtual;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function Drivers: TDirectXDrivers;
    procedure Finalize;
    procedure Initialize;
    procedure Restore;
    procedure RegisterNotifyEvent(NotifyEvent: TDXSoundNotifyEvent);
    procedure UnRegisterNotifyEvent(NotifyEvent: TDXSoundNotifyEvent);

    property AutoInitialize: Boolean read FAutoInitialize write FAutoInitialize;
    property Driver: PGUID read FDriver write SetDriver;
    property DSound: TDirectSound read FDSound;
    property Initialized: Boolean read FInitialized;
    property NowOptions: TDXSoundOptions read FNowOptions;
    property Primary: TDirectSoundBuffer read FPrimary;
    property OnFinalize: TNotifyEvent read FOnFinalize write FOnFinalize;
    property OnInitialize: TNotifyEvent read FOnInitialize write FOnInitialize;
    property OnInitializing: TNotifyEvent read FOnInitializing write FOnInitializing;
    property OnRestore: TNotifyEvent read FOnRestore write FOnRestore;
    property Options: TDXSoundOptions read FOptions write SetOptions;
  end;

  {  TDXSound  }

  TDX9Sound = class(TCustomDX9Sound)
  published
    property AutoInitialize;
    property Options;
    property OnFinalize;
    property OnInitialize;
    property OnInitializing;
    property OnRestore;
  end;

  {  TSoundEngine  }

  TSoundEngine = class
  private
    FDSound: TDirectSound;
    FEffectList: TList;
    FEnabled: Boolean;
    FTimer: TTimer;
    FVolume: Byte;
    function GetEffect(Index: Integer): TDirectSoundBuffer;
    function GetEffectCount: Integer;
    procedure SetEnabled(Value: Boolean);
    procedure TimerEvent(Sender: TObject);
    procedure SetVolume(const Value: Byte);
  public
    constructor Create(ADSound: TDirectSound);
    destructor Destroy; override;
    procedure Clear;
    procedure EffectFile(const Filename: string; Loop, Wait: Boolean);
    procedure EffectStream(Stream: TStream; Loop, Wait: Boolean);
    procedure EffectWave(Wave: TWave; Loop, Wait: Boolean);
    property EffectCount: Integer read GetEffectCount;
    property Effects[Index: Integer]: TDirectSoundBuffer read GetEffect;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Volume: Byte read FVolume write SetVolume;
  end;

implementation

var
  DirectSoundDrivers: TDirectXDrivers;
  DirectSoundCaptureDrivers: TDirectXDrivers;

function EnumDirectSoundDrivers_DSENUMCALLBACK(lpGuid: PGUID; lpstrDescription: {$IFDEF UNICODE}LPCTSTR{$ELSE}LPCSTR{$ENDIF};
  lpstrModule: {$IFDEF UNICODE}LPCTSTR{$ELSE}LPCSTR{$ENDIF}; lpContext: Pointer): BOOL; stdcall;
begin
  Result := True;
  with TDirectXDriver.Create(TDirectXDrivers(lpContext)) do
  begin
    Guid := lpGuid;
    Description := lpstrDescription;
    DriverName := lpstrModule;
  end;
end;

function EnumDirectSoundDrivers: TDirectXDrivers;
begin
  if DirectSoundDrivers = nil then
  begin
    DirectSoundDrivers := TDirectXDrivers.Create;
    try
      DirectSoundEnumerateA(@EnumDirectSoundDrivers_DSENUMCALLBACK, DirectSoundDrivers);
    except
      DirectSoundDrivers.Free;
      raise;
    end;
  end;

  Result := DirectSoundDrivers;
end;

{  TDirectSound  }

constructor TDirectSound.Create(GUID: PGUID);
begin
  inherited Create;
  FBufferList := TList.Create;

  if DirectSoundCreate8(GUID, FIDSound, nil) <> DS_OK then
    raise EDirectSoundError.CreateFmt(SCannotInitialized, [SDirectSound]);
end;

destructor TDirectSound.Destroy;
begin
  while BufferCount > 0 do
    Buffers[BufferCount - 1].Free;
  FBufferList.Free;

  FIDSound := nil;
  inherited Destroy;
end;

class function TDirectSound.Drivers: TDirectXDrivers;
begin
  Result := EnumDirectSoundDrivers;
end;

procedure TDirectSound.CheckBuffer(Buffer: TDirectSoundBuffer);
begin
  case Buffer.DXResult of
    DSERR_BUFFERLOST:
      begin
        if not FInRestoreBuffer then
        begin
          FInRestoreBuffer := True;
          try
            DoRestoreBuffer;
          finally
            FInRestoreBuffer := False;
          end;
        end;
      end;
  end;
end;

procedure TDirectSound.DoRestoreBuffer;
begin
end;

function TDirectSound.GetBuffer(Index: Integer): TDirectSoundBuffer;
begin
  Result := FBufferList[Index];
end;

function TDirectSound.GetBufferCount: Integer;
begin
  Result := FBufferList.Count;
end;

function TDirectSound.GetIDSound: IDirectSound;
begin
  if Self <> nil then
    Result := FIDSound
  else
    Result := nil;
end;

function TDirectSound.GetISound: IDirectSound;
begin
  Result := IDSound;
  if Result = nil then
    raise EDirectSoundError.CreateFmt(SNotMade, ['IDirectSound']);
end;

{  TDirectSoundBuffer  }

constructor TDirectSoundBuffer.Create(ADirectSound: TDirectSound);
begin
  inherited Create;
  FDSound := ADirectSound;
  FDSound.FBufferList.Add(Self);
end;

destructor TDirectSoundBuffer.Destroy;
begin
  IDSBuffer := nil;
  FDSound.FBufferList.Remove(Self);
  inherited Destroy;
end;

procedure TDirectSoundBuffer.Assign(Source: TPersistent);
var
  TempBuffer: IDirectSoundBuffer;
begin
  if Source = nil then
    IDSBuffer := nil
  else if Source is TWave then
    LoadFromWave(TWave(Source))
  else if Source is TDirectSoundBuffer then
  begin
    if TDirectSoundBuffer(Source).IDSBuffer = nil then
      IDSBuffer := nil
    else begin
      FDSound.DXResult := FDSound.ISound.DuplicateSoundBuffer(TDirectSoundBuffer(Source).IDSBuffer,
        TempBuffer);
      if FDSound.DXResult = 0 then
      begin
        IDSBuffer := TempBuffer;
      end;
    end;
  end else
    inherited Assign(Source);
end;

procedure TDirectSoundBuffer.Check;
begin
  FDSound.CheckBuffer(Self);
end;

function TDirectSoundBuffer.CreateBuffer(const BufferDesc: TDSBufferDesc): Boolean;
var
  TempBuffer: IDirectSoundBuffer;
begin
  IDSBuffer := nil;

  FDSound.DXResult := FDSound.ISound.CreateSoundBuffer(BufferDesc, TempBuffer, nil);
  FDXResult := FDSound.DXResult;
  Result := DXResult = DS_OK;
  if Result then
    IDSBuffer := TempBuffer;
end;

function TDirectSoundBuffer.GetBitCount: Longint;
begin
  Result := Format.wBitsPerSample;
end;

function TDirectSoundBuffer.GetFormat: PWaveFormatEx;
begin
  GetIBuffer;
  Result := FFormat;
end;

function TDirectSoundBuffer.GetFrequency: Integer;
begin
  DXResult := IBuffer.GetFrequency(DWORD(Result));
end;

function TDirectSoundBuffer.GetIDSBuffer: IDirectSoundBuffer;
begin
  if Self <> nil then
    Result := FIDSBuffer
  else
    Result := nil;
end;

function TDirectSoundBuffer.GetIBuffer: IDirectSoundBuffer;
begin
  Result := IDSBuffer;
  if Result = nil then
    raise EDirectSoundBufferError.CreateFmt(SNotMade, ['IDirectSoundBuffer']);
end;

function TDirectSoundBuffer.GetPlaying: Boolean;
begin
  Result := (GetStatus and (DSBSTATUS_PLAYING or DSBSTATUS_LOOPING)) <> 0;
end;

function TDirectSoundBuffer.GetPan: Integer;
begin
  DXResult := IBuffer.GetPan(Longint(Result));
end;

function TDirectSoundBuffer.GetPosition: Longint;
var
  dwCurrentWriteCursor: Longint;
begin
  IBuffer.GetCurrentPosition(@DWORD(Result), @DWORD(dwCurrentWriteCursor));
end;

function TDirectSoundBuffer.GetSize: Integer;
begin
  Result := FCaps.dwBufferBytes;
end;

function TDirectSoundBuffer.GetStatus: Integer;
begin
  DXResult := IBuffer.GetStatus(DWORD(Result));
end;

function TDirectSoundBuffer.GetVolume: Integer;
begin
  DXResult := IBuffer.GetVolume(Longint(Result));
end;

procedure TDirectSoundBuffer.LoadFromFile(const FileName: string);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TDirectSoundBuffer.LoadFromMemory(const Format: TWaveFormatEx;
  Data: Pointer; Size: Integer);
var
  Data1, Data2: Pointer;
  Data1Size, Data2Size: Longint;
begin
  SetSize(Format, Size);

  if Data <> nil then
  begin
    if Lock(0, Size, Data1, Data1Size, Data2, Data2Size) then
    begin
      try
        Move(Data^, Data1^, Data1Size);
        if Data2 <> nil then
          Move(Pointer(Longint(Data) + Data1Size)^, Data2^, Data2Size);
      finally
        UnLock;
      end;
    end else
    begin
      FIDSBuffer := nil;
      raise EDirectSoundBufferError.CreateFmt(SCannotLock, [SDirectSoundBuffer]);
    end;
  end;
end;

procedure TDirectSoundBuffer.LoadFromStream(Stream: TStream);
var
  Wave: TWave;
begin
  Wave := TWave.Create;
  try
    Wave.LoadFromStream(Stream);
    LoadFromWave(Wave);
  finally
    Wave.Free;
  end;
end;

procedure TDirectSoundBuffer.LoadFromWave(Wave: TWave);
begin
  LoadFromMemory(Wave.Format^, Wave.Data, Wave.Size);
end;

function TDirectSoundBuffer.Lock(LockPosition, LockSize: Longint;
  var AudioPtr1: Pointer; var AudioSize1: Longint;
  var AudioPtr2: Pointer; var AudioSize2: Longint): Boolean;
begin
  Result := False;
  if IDSBuffer = nil then Exit;

  if FLockCount > High(FLockAudioPtr1) then Exit;
  DXResult := IBuffer.Lock(LockPosition, LockSize,
    FLockAudioPtr1[FLockCount], FLockAudioSize1[FLockCount],
    FLockAudioPtr2[FLockCount], FLockAudioSize2[FLockCount], 0);
  Result := DXResult = DS_OK;

  if Result then
  begin
    AudioPtr1 := FLockAudioPtr1[FLockCount];
    AudioPtr2 := FLockAudioPtr2[FLockCount];
    AudioSize1 := FLockAudioSize1[FLockCount];
    AudioSize2 := FLockAudioSize2[FLockCount];
    Inc(FLockCount);
  end;
end;

function TDirectSoundBuffer.Play(Loop: Boolean): Boolean;
begin
  if Loop then
    DXResult := IBuffer.Play(0, 0, DSBPLAY_LOOPING)
  else
    DXResult := IBuffer.Play(0, 0, 0);
  Result := DXResult = DS_OK;
end;

function TDirectSoundBuffer.Restore: Boolean;
begin
  DXResult := IBuffer.Restore;
  Result := DXResult = DS_OK;
end;

function TDirectSoundBuffer.SetFormat(const Format: TWaveFormatEx): Boolean;
begin
  DXResult := IBuffer.SetFormat(FFormat^);
  Result := DXResult = DS_OK;

  if Result then
  begin
    FreeMem(FFormat);
    FFormat := nil;
    FFormatSize := 0;
    if IBuffer.GetFormat(PWaveFormatEx(nil), 0, @DWORD(FFormatSize)) = DS_OK then
    begin
      GetMem(FFormat, FFormatSize);
      IBuffer.GetFormat(FFormat, FFormatSize, nil);
    end;
  end;
end;

procedure TDirectSoundBuffer.SetFrequency(Value: Integer);
begin
  DXResult := IBuffer.SetFrequency(Value);
end;

procedure TDirectSoundBuffer.SetIDSBuffer(Value: IDirectSoundBuffer);
begin
  if FIDSBuffer = Value then Exit;

  FIDSBuffer := Value;
  FillChar(FCaps, SizeOf(FCaps), 0);
  FreeMem(FFormat);
  FFormat := nil;
  FFormatSize := 0;
  FLockCount := 0;

  if FIDSBuffer <> nil then
  begin
    FCaps.dwSize := SizeOf(FCaps);
    IBuffer.GetCaps(FCaps);

    if IBuffer.GetFormat(PWaveFormatEx(nil), 0, @DWORD(FFormatSize)) = DS_OK then
    begin
      GetMem(FFormat, FFormatSize);
      IBuffer.GetFormat(FFormat, FFormatSize, nil);
    end;
  end;
end;

procedure TDirectSoundBuffer.SetPan(Value: Integer);
begin
  DXResult := IBuffer.SetPan(Value);
end;

procedure TDirectSoundBuffer.SetPosition(Value: Longint);
begin
  DXResult := IBuffer.SetCurrentPosition(Value);
end;

const
  DSBCAPS_CTRLDEFAULT = DSBCAPS_CTRLFREQUENCY or DSBCAPS_CTRLPAN or DSBCAPS_CTRLVOLUME;

procedure TDirectSoundBuffer.SetSize(const Format: TWaveFormatEx; Size: Integer);
var
  BufferDesc: TDSBufferDesc;
begin
  {  IDirectSoundBuffer made.  }
  FillChar(BufferDesc, SizeOf(BufferDesc), 0);

  with BufferDesc do
  begin
    dwSize := SizeOf(TDSBufferDesc);
    dwFlags := DSBCAPS_CTRLDEFAULT;
    if DSound.FStickyFocus then
      dwFlags := dwFlags or DSBCAPS_STICKYFOCUS
    else if DSound.FGlobalFocus then
      dwFlags := dwFlags or DSBCAPS_GLOBALFOCUS;
    dwBufferBytes := Size;
    lpwfxFormat := @Format;
  end;

  if not CreateBuffer(BufferDesc) then
    raise EDirectSoundBufferError.CreateFmt(SCannotMade, [SDirectSoundBuffer]);
end;

procedure TDirectSoundBuffer.SetVolume(Value: Integer);
begin
  DXResult := IBuffer.SetVolume(Value);
end;

procedure TDirectSoundBuffer.Stop;
begin
  DXResult := IBuffer.Stop;
end;

procedure TDirectSoundBuffer.Unlock;
begin
  if IDSBuffer = nil then Exit;
  if FLockCount = 0 then Exit;

  Dec(FLockCount);
  DXResult := IBuffer.UnLock(FLockAudioPtr1[FLockCount], FLockAudioSize1[FLockCount],
    FLockAudioPtr2[FLockCount], FLockAudioSize2[FLockCount]);
end;

{  TSoundEngine  }

constructor TSoundEngine.Create(ADSound: TDirectSound);
begin
  inherited Create;
  FDSound := ADSound;
  FEnabled := True;

  FEffectList := TList.Create;
  FTimer := TTimer.Create(nil);
  FTimer.Interval := 500;
  FTimer.OnTimer := TimerEvent;

  FVolume := 100;
end;

destructor TSoundEngine.Destroy;
begin
  Clear;
  FTimer.Free;
  FEffectList.Free;
  inherited Destroy;
end;

procedure TSoundEngine.Clear;
var
  i: Integer;
begin
  for i := EffectCount - 1 downto 0 do
    Effects[i].Free;
  FEffectList.Clear;
end;

procedure TSoundEngine.EffectFile(const Filename: string; Loop, Wait: Boolean);
var
  Stream: TFileStream;
begin
  if FVolume = 0 then exit;
  
  Stream := TFileStream.Create(Filename, fmOpenRead or fmShareDenyWrite);
  try
    EffectStream(Stream, Loop, Wait);
  finally
    Stream.Free;
  end;
end;

procedure TSoundEngine.EffectStream(Stream: TStream; Loop, Wait: Boolean);
var
  Wave: TWave;
begin
  if FVolume = 0 then exit;
  Wave := TWave.Create;
  try
    Wave.LoadfromStream(Stream);
    EffectWave(Wave, Loop, Wait);
  finally
    Wave.Free;
  end;
end;

procedure TSoundEngine.EffectWave(Wave: TWave; Loop, Wait: Boolean);
var
  Buffer: TDirectSoundBuffer;
begin
  if FVolume = 0 then exit;
  if not FEnabled then Exit;

  if Wait then
  begin
    Buffer := TDirectSoundBuffer.Create(FDSound);
    try
      Buffer.LoadFromWave(Wave);
      Buffer.Volume := FVolume * 40 - 4000;
      Buffer.Play(False);
      while Buffer.Playing do
        Sleep(1);
    finally
      Buffer.Free;
    end;
  end else
  begin
    Buffer := TDirectSoundBuffer.Create(FDSound);
    try
      Buffer.LoadFromWave(Wave);
      //raise EDirectSoundBufferError.CreateFmt('Hint %d', [Buffer.Volume]);
      Buffer.Volume := FVolume * 40 - 4000;

      Buffer.Play(Loop);
    except
      Buffer.Free;
      raise;
    end;
    FEffectList.Add(Buffer);
  end;
end;

function TSoundEngine.GetEffect(Index: Integer): TDirectSoundBuffer;
begin
  Result := TDirectSoundBuffer(FEffectList[Index]);
end;

function TSoundEngine.GetEffectCount: Integer;
begin
  Result := FEffectList.Count;
end;

procedure TSoundEngine.SetEnabled(Value: Boolean);
var
  i: Integer;
begin
  for i := EffectCount - 1 downto 0 do
    Effects[i].Free;
  FEffectList.Clear;

  FEnabled := Value;
  FTimer.Enabled := Value;
end;

procedure TSoundEngine.SetVolume(const Value: Byte);
begin
  if Value in [0..100] then
    FVolume := Value;
end;

procedure TSoundEngine.TimerEvent(Sender: TObject);
var
  i: Integer;
begin
  for i := EffectCount - 1 downto 0 do
    if not TDirectSoundBuffer(FEffectList[i]).Playing then
    begin
      TDirectSoundBuffer(FEffectList[i]).Free;
      FEffectList.Delete(i);
    end;
end;

{  TCustomDXSound  }

type
  TDXSoundDirectSound = class(TDirectSound)
  private
    FDXSound: TCustomDX9Sound;
  protected
    procedure DoRestoreBuffer; override;
  end;

procedure TDXSoundDirectSound.DoRestoreBuffer;
begin
  inherited DoRestoreBuffer;
  FDXSound.Restore;
end;

constructor TCustomDX9Sound.Create(AOwner: TComponent);
begin
  FNotifyEventList := TList.Create;
  inherited Create(AOwner);
  FAutoInitialize := True;
  Options := [];
end;

destructor TCustomDX9Sound.Destroy;
begin
  Finalize;
  NotifyEventList(dsntDestroying);
  FNotifyEventList.Free;
  inherited Destroy;
end;

type
  PDXSoundNotifyEvent = ^TDXSoundNotifyEvent;

procedure TCustomDX9Sound.RegisterNotifyEvent(NotifyEvent: TDXSoundNotifyEvent);
var
  Event: PDXSoundNotifyEvent;
begin
  UnRegisterNotifyEvent(NotifyEvent);

  New(Event);
  Event^ := NotifyEvent;
  FNotifyEventList.Add(Event);

  if Initialized then
  begin
    NotifyEvent(Self, dsntInitialize);
    NotifyEvent(Self, dsntRestore);
  end;
end;

procedure TCustomDX9Sound.UnRegisterNotifyEvent(NotifyEvent: TDXSoundNotifyEvent);
var
  Event: PDXSoundNotifyEvent;
  i: Integer;
begin
  for i := 0 to FNotifyEventList.Count - 1 do
  begin
    Event := FNotifyEventList[i];
    if (TMethod(Event^).Code = TMethod(NotifyEvent).Code) and
      (TMethod(Event^).Data = TMethod(NotifyEvent).Data) then
    begin
      Dispose(Event);
      FNotifyEventList.Delete(i);

      if Initialized then
        NotifyEvent(Self, dsntFinalize);

      Break;
    end;
  end;
end;

procedure TCustomDX9Sound.NotifyEventList(NotifyType: TDXSoundNotifyType);
var
  i: Integer;
begin
  for i := FNotifyEventList.Count - 1 downto 0 do
    PDXSoundNotifyEvent(FNotifyEventList[i])^(Self, NotifyType);
end;

procedure TCustomDX9Sound.FormWndProc(var Message: TMessage; DefWindowProc: TWndMethod);
begin
  case Message.Msg of
    WM_CREATE:
      begin
        DefWindowProc(Message);
        SetForm(FForm);
        Exit;
      end;
  end;
  DefWindowProc(Message);
end;

class function TCustomDX9Sound.Drivers: TDirectXDrivers;
begin
  Result := EnumDirectSoundDrivers;
end;

procedure TCustomDX9Sound.DoFinalize;
begin
  if Assigned(FOnFinalize) then FOnFinalize(Self);
end;

procedure TCustomDX9Sound.DoInitialize;
begin
  if Assigned(FOnInitialize) then FOnInitialize(Self);
end;

procedure TCustomDX9Sound.DoInitializing;
begin
  if Assigned(FOnInitializing) then FOnInitializing(Self);
end;

procedure TCustomDX9Sound.DoRestore;
begin
  if Assigned(FOnRestore) then FOnRestore(Self);
end;

procedure TCustomDX9Sound.Finalize;
begin
  if FInternalInitialized then
  begin
    try
      FSubClass.Free; FSubClass := nil;

      try
        if FCalledDoInitialize then
        begin
          FCalledDoInitialize := False;
          DoFinalize;
        end;
      finally
        NotifyEventList(dsntFinalize);
      end;
    finally
      FInitialized := False;
      FInternalInitialized := False;

      SetOptions(FOptions);

      FPrimary.Free; FPrimary := nil;
      FDSound.Free; FDSound := nil;
    end;
  end;
end;

procedure TCustomDX9Sound.Initialize;
const
  PrimaryDesc: TDSBufferDesc = (
    dwSize: SizeOf(PrimaryDesc);
    dwFlags: DSBCAPS_PRIMARYBUFFER);
var
  Component: TComponent;
begin
  Finalize;

  Component := Owner;
  while (Component <> nil) and (not (Component is TCustomForm)) do
    Component := Component.Owner;
  if Component = nil then
    raise EDXSoundError.Create(SNoForm);

  NotifyEventList(dsntInitializing);
  DoInitializing;

  FInternalInitialized := True;
  try
    {  DirectSound initialization.  }
    FDSound := TDXSoundDirectSound.Create(Driver);
    TDXSoundDirectSound(FDSound).FDXSound := Self;

    FDSound.FGlobalFocus := soGlobalFocus in FNowOptions;

    {  Primary buffer made.  }
    FPrimary := TDirectSoundBuffer.Create(FDSound);
    if not FPrimary.CreateBuffer(PrimaryDesc) then
      raise EDXSoundError.CreateFmt(SCannotMade, [SDirectSoundPrimaryBuffer]);

    FInitialized := True;

    SetForm(TCustomForm(Component));
  except
    Finalize;
    raise;
  end;

  NotifyEventList(dsntInitialize);

  FCalledDoInitialize := True; DoInitialize;

  Restore;
end;

procedure TCustomDX9Sound.Loaded;
begin
  inherited Loaded;

  if FAutoInitialize and (not (csDesigning in ComponentState)) then
  begin
    try
      Initialize;
    except
      on E: EDirectSoundError do ;
    else raise;
    end;
  end;
end;

procedure TCustomDX9Sound.Restore;
begin
  if FInitialized then
  begin
    NotifyEventList(dsntRestore);
    DoRestore;
  end;
end;

procedure TCustomDX9Sound.SetDriver(Value: PGUID);
begin
  if not IsBadHugeReadPtr(Value, SizeOf(TGUID)) then
  begin
    FDriverGUID := Value^;
    FDriver := @FDriverGUID;
  end else
    FDriver := Value;
end;

procedure TCustomDX9Sound.SetForm(Value: TCustomForm);
var
  Level: Integer;
begin
  FForm := Value;

  FSubClass.Free;
  FSubClass := TControlSubClass.Create(FForm, FormWndProc);

  if FInitialized then
  begin
    if soExclusive in FNowOptions then
      Level := DSSCL_EXCLUSIVE
    else
      Level := DSSCL_NORMAL;

    FDSound.DXResult := FDSound.ISound.SetCooperativeLevel(FForm.Handle, Level);
  end;
end;

procedure TCustomDX9Sound.SetOptions(Value: TDXSoundOptions);
const
  DXSoundOptions = [soGlobalFocus, soStickyFocus, soExclusive];
  InitOptions: TDXSoundOptions = [soExclusive];
var
  OldOptions: TDXSoundOptions;
begin
  FOptions := Value;

  if Initialized then
  begin
    OldOptions := FNowOptions;

    FNowOptions := (FNowOptions - (DXSoundOptions - InitOptions)) +
      (Value - InitOptions);

    FDSound.FGlobalFocus := soGlobalFocus in FNowOptions;
    FDSound.FStickyFocus := soStickyFocus in FNowOptions;
  end else
    FNowOptions := FOptions;
end;

initialization
finalization
  DirectSoundDrivers.Free;
  DirectSoundCaptureDrivers.Free;
end.

