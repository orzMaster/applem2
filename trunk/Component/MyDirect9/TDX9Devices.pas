unit TDX9Devices;

interface
uses
  Windows, SysUtils, Classes, Forms, MyDirect3D9, MyDXBase, TDX9Canvas, TDX9Textures{, TDX9Sounds};

type
  TInitializeEvent = procedure(Sender: TObject; var Success: Boolean; var ErrorMsg: string) of object;
  TDeviceNotifyEvent = procedure(Sender: TObject; Msg: Cardinal) of object;

  TBitDepth = (bdLow, bdHigh);

  TDX9Device = class(TComponent)
  private
    FAutoInitialize: Boolean;
    FWidth: Integer;
    FHeight: Integer;
    FBitDepth: TBitDepth; //表面深度
    FRefresh: Integer; //更新速度
    FErrorMsg: String;

    FWindowed: Boolean; //是否窗口化
    FVSync: Boolean; //垂直同步
    FWindowHandle: THandle; //屏幕窗口句柄, 0为父窗口
    FHardwareTL: Boolean; //是否开启硬件加速
    FDepthBuffer: Boolean; //是否打开深度缓冲
    FLockBackBuffer: Boolean; //允许锁定后备缓冲区

    FInitialized: Boolean; //是否已初始化

    FOnFinalize: TNotifyEvent;
    FOnInitialize: TInitializeEvent;
    FOnRender: TNotifyEvent;
    FOnNotifyEvent: TDeviceNotifyEvent;

    NotifiedLost: Boolean;
    FCanvas: TDXDrawCanvas;
    FDXTexture: TDXTexture;
    FDI: D3DADAPTER_IDENTIFIER9;
    FAvailableTextureMem: LongWord;
    procedure SetDepthBuffer(const Value: Boolean);
    procedure SetRefresh(const Value: Integer);
    procedure SetSize(const Index, Value: Integer);
    procedure SetState(const Index: Integer; const Value: Boolean);
    procedure SetWindowHandle(const Value: THandle);
    procedure SetBitDepth(const Value: TBitDepth);
  protected
    procedure RefreshPresentParams();
    procedure UpdatePresentParams();
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    property Canvas: TDXDrawCanvas read FCanvas;

    function Initialize(): Boolean;
    function Finalize(): Boolean;
    function Reset(): Boolean;
    function CanDraw(): Boolean;

    function Clear(Color: Cardinal): Boolean; overload;
    function Clear(Color: Cardinal; ClearZBuf: Boolean): Boolean; overload;
    function BeginScene(): Boolean;
    function EndScene(): Boolean;
    function Render(Bkgrnd: Cardinal; FillBk: Boolean): Boolean;
    function RenderOn(Source: TDXRenderTargetTexture; Event: TNotifyEvent;
      Bkgrnd: Cardinal; FillBk: Boolean): Boolean;

    function Flip(): Boolean;

    property DXTexture: TDXTexture read FDXTexture;
    property boInitialized: Boolean read FInitialized;
    property InitError: String read FErrorMsg;
    property DI: D3DADAPTER_IDENTIFIER9 read FDI;
    property AvailableTextureMem: LongWord read FAvailableTextureMem;
  published
    property Width: Integer index 0 read FWidth write SetSize;
    property Height: Integer index 1 read FHeight write SetSize;
    property BitDepth: TBitDepth read FBitDepth write SetBitDepth;
    property Refresh: Integer read FRefresh write SetRefresh;

    property Windowed: Boolean index 0 read FWindowed write SetState;
    property VSync: Boolean index 1 read FVSync write SetState;
    property HardwareTL: Boolean index 2 read FHardwareTL write SetState;
    property LockBackBuffer: Boolean read FLockBackBuffer write FLockBackBuffer;

    property DepthBuffer: Boolean read FDepthBuffer write SetDepthBuffer;
    property WindowHandle: THandle read FWindowHandle write SetWindowHandle;

    property OnInitialize: TInitializeEvent read FOnInitialize write FOnInitialize;
    property OnFinalize: TNotifyEvent read FOnFinalize write FOnFinalize;
    property OnRender: TNotifyEvent read FOnRender write FOnRender;
    property OnNotifyEvent: TDeviceNotifyEvent read FOnNotifyEvent write FOnNotifyEvent;
    property AutoInitialize: Boolean read FAutoInitialize write FAutoInitialize;

  end;

procedure Register;

implementation

{uses
  TDX9Controls;    }

{ TDX9Device }

procedure Register;
begin
  RegisterComponents('MyDX9', [TDX9Device]);
  {RegisterComponents('MirGame', [TDWinManager, TDControl, TDButton, TDGrid, TDWindow, TDCheckBox, TDUpDown,
    TDHooKKey, TDEdit, TDImageEdit, TDComboBox, TDListView, TDMemo, TDPopUpMemu, TDTreeView]); }
end;

function TDX9Device.BeginScene: Boolean;
begin
  Result := Succeeded(Direct3DDevice.BeginScene());
  if (Result) then begin
    FCanvas.Notify(msgBeginScene);
    if Assigned(FOnNotifyEvent) then
      FOnNotifyEvent(Self, msgBeginScene);
  end;
end;

function TDX9Device.Clear(Color: Cardinal): Boolean;
begin
  Result := Clear(Color, FDepthBuffer);
end;

function TDX9Device.Clear(Color: Cardinal; ClearZBuf: Boolean): Boolean;
var
  Flags: Cardinal;
begin
  Flags := D3DCLEAR_TARGET;
  if (ClearZBuf) then
    Flags := Flags or D3DCLEAR_ZBUFFER;

  Result := Succeeded(Direct3DDevice.Clear(0, nil, Flags, DisplaceRB(Color), 1.0, 0));
end;

constructor TDX9Device.Create(AOwner: TComponent);
begin
  inherited;
  FBitDepth := bdLow;
  FWidth := 800;
  FHeight := 600;
  FRefresh := 0;

  FWindowed := True;
  FVSync := True;
  FWindowHandle := 0;
  FHardwareTL := True;
  FDepthBuffer := True;

  FInitialized := False;
  FCanvas := TDXDrawCanvas.Create;
  FOnNotifyEvent := nil;
  FOnFinalize := nil;
  FOnInitialize := nil;
  FOnRender := nil;
  FAutoInitialize := True;
  FDXTexture := nil;
  FLockBackBuffer := False;
  FErrorMsg := '';
  FAvailableTextureMem := 0;

  FillChar(FDI, SizeOf(FDI), #0);
  FillChar(DeviceCaps, SizeOf(DeviceCaps), #0);
end;

destructor TDX9Device.Destroy;
begin
  if (FInitialized) then
    Finalize();
  FCanvas.Free;
  if FDXTexture <> nil then
    FDXTexture.Free;
  inherited;
end;

function TDX9Device.EndScene: Boolean;
begin
  FCanvas.Notify(msgEndScene);
  if Assigned(FOnNotifyEvent) then
    FOnNotifyEvent(Self, msgEndScene);
  Result := Succeeded(Direct3DDevice.EndScene());
end;

function TDX9Device.Finalize: Boolean;
begin
  Result := True;

  // (1) Verify conditions.
  if (not FInitialized) then begin
    Result := False;
    Exit;
  end;

  // (2) Call notification event.
  if (Assigned(FOnFinalize)) then
    FOnFinalize(Self);

  // (3) Broadcast finalize notification to subscribed components.
  FCanvas.Notify(msgDeviceFinalize);
  if Assigned(FOnNotifyEvent) then
    FOnNotifyEvent(Self, msgDeviceFinalize);

  // (4) Release Direct3D objects.
  if (Direct3DDevice <> nil) then
    Direct3DDevice := nil;
  if (Direct3D <> nil) then
    Direct3D := nil;
  if FDXTexture <> nil then
    FDXTexture.Free;
  FDXTexture := nil;

  // (5) Change status to [not DeviceActive]
  FInitialized := False;
end;

function TDX9Device.CanDraw(): Boolean;
begin

  Result := False;
  if Direct3DDevice = nil then exit;

  case Direct3DDevice.TestCooperativeLevel() of
    D3D_OK: Result := True;  //正常

    D3DERR_DEVICELOST: begin //丢失设备
        if (not NotifiedLost) then begin
          FCanvas.Notify(msgDeviceLost);
          if Assigned(FOnNotifyEvent) then
            FOnNotifyEvent(Self, msgDeviceLost);
          NotifiedLost := True;
        end;
      end;
    D3DERR_DEVICENOTRESET: begin   //可以恢复设备
        if (not NotifiedLost) then begin
          FCanvas.Notify(msgDeviceLost);
          if Assigned(FOnNotifyEvent) then
            FOnNotifyEvent(Self, msgDeviceLost);
          NotifiedLost := True;
        end;
        if (Succeeded(Direct3DDevice.Reset(PresentParams))) and (NotifiedLost) then begin
          FCanvas.Notify(msgDeviceRecovered);
          if Assigned(FOnNotifyEvent) then
            FOnNotifyEvent(Self, msgDeviceRecovered);
          NotifiedLost := False;
        end;
      end;
    D3DERR_DRIVERINTERNALERROR: begin
        if (Failed(Direct3DDevice.Reset(PresentParams))) then
          Finalize();
      end;
  end;
end;

function TDX9Device.Flip: Boolean;
var
  Res: Integer;
begin
  // (1) Verify conditions.
  if (not FInitialized) then begin
    Result := False;
    Exit;
  end;

  // (2) Present the scene.
  Res := Direct3DDevice.Present(nil, nil, 0, nil);

  // (3) Device has been lost?
  if (Res = D3DERR_DEVICELOST) then begin
    // notify everyone that we've lost our device
    if (not NotifiedLost) then begin
      FCanvas.Notify(msgDeviceLost);
      if Assigned(FOnNotifyEvent) then
        FOnNotifyEvent(Self, msgDeviceLost);
      NotifiedLost := True;
    end;

    // can the device be restored?
    Res := Direct3DDevice.TestCooperativeLevel();

    // try to restore the device
    if (Res = D3DERR_DEVICENOTRESET) then begin
      Res := Direct3DDevice.Reset(PresentParams);
      if (Succeeded(Res)) and (NotifiedLost) then begin
        FCanvas.Notify(msgDeviceRecovered);
        if Assigned(FOnNotifyEvent) then
          FOnNotifyEvent(Self, msgDeviceRecovered);
        NotifiedLost := False;
      end;
    end;
  end;

  // (4) Driver error? try resetting...
  if (Res = D3DERR_DRIVERINTERNALERROR) then begin
    Res := Direct3DDevice.Reset(PresentParams);
    // if cannot reset the device - we're done, finalize the device
    if (Failed(Res)) then
      Finalize();
  end;

  // (5) Verify the result.
  Result := Succeeded(Res);
end;

function TDX9Device.Initialize: Boolean;
var
  Res: Integer;
begin
  Result := False;
  FErrorMsg := 'Direct3D nil';
  if (FInitialized) or (Direct3D <> nil) or (Direct3DDevice <> nil) then
    Exit;

  FErrorMsg := 'Create Direct3D error';
  Direct3D := Direct3DCreate9(D3D_SDK_VERSION);
  if (Direct3D = nil) then Exit;
  FillChar(FDI, SizeOf(FDI), #0);
  if Direct3D.GetAdapterCount > 0 then Direct3D.GetAdapterIdentifier(0, 0, FDI);
  
  RefreshPresentParams();

  FErrorMsg := 'CreateDevice error';
  if (FHardwareTL) then begin
    Res := Direct3D.CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, PresentParams.hDeviceWindow,
      D3DCREATE_HARDWARE_VERTEXPROCESSING, @PresentParams, Direct3DDevice);
  end
  else
    Res := D3D_OK; // for the next call

  // -> if FAILED, try software vertex processing
  if (Failed(Res)) or (not FHardwareTL) then
    Res := Direct3D.CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, PresentParams.hDeviceWindow,
      D3DCREATE_SOFTWARE_VERTEXPROCESSING, @PresentParams, Direct3DDevice);

  Result := Succeeded(Res);

  // (5) Retreive device capabilities.
  FillChar(DeviceCaps, SizeOf(DeviceCaps), #0);
  if (Result) then begin
    FErrorMsg := 'GetDeviceCaps error';      
    FAvailableTextureMem := Direct3DDevice.GetAvailableTextureMem;
    Result := Succeeded(Direct3DDevice.GetDeviceCaps(DeviceCaps));
  end;

  //if (Result) then
    //Result := Succeeded(Direct3DDevice.SetDialogBoxMode(TRUE));

  // (6) Mark that we have not lost the device.
  NotifiedLost := False;
  if Result then begin
    FErrorMsg := '电脑配置达不到游戏运行最低要求。';
    Result := (DeviceCaps.MaxTextureWidth > 2000) and (DeviceCaps.MaxTextureHeight > 2000) and
      (Direct3DDevice.GetAvailableTextureMem > 16 * 1024 * 1024);
  end;
  //Result := False;

  // (7) Change status to [DeviceActive]
  FInitialized := Result;
  if (Result) then begin
    Direct3DDevice.SetDialogBoxMode(TRUE);
    // (8) Broadcast InitDevice notification to subscribed components.
    Result := FCanvas.Notify(msgDeviceInitialize);
    FErrorMsg := 'Device Initialize error';
    if Assigned(FOnNotifyEvent) then
      FOnNotifyEvent(Self, msgDeviceInitialize);
    if (not Result) then
      Finalize();
    FDXTexture := TDXTexture.Create(FCanvas);
    // (9) Call notification events.
    if (Assigned(FOnInitialize)) then begin
      FOnInitialize(Self, Result, FErrorMsg);
      if (not Result) then
        Finalize();
    end;
  end;
end;

procedure TDX9Device.Loaded;
begin
  inherited Loaded;

  {if FAutoInitialize and (not (csDesigning in ComponentState)) then begin
    try
      Initialize;
    except
      on E: EDirectSoundError do
        ;
    else
      raise;
    end;
  end;   }
end;

procedure TDX9Device.RefreshPresentParams;
begin
  FillChar(PresentParams, SizeOf(TD3DPresentParameters), 0);

  with PresentParams do begin
    Windowed := Self.FWindowed;

    if (FWindowHandle = 0) then begin
      if (Assigned(Owner)) and (Owner is TCustomForm) then
        hDeviceWindow := TCustomForm(Owner).Handle;
    end
    else
      hDeviceWindow := FWindowHandle;

    BackBufferWidth := FWidth;
    BackBufferHeight := FHeight;
    SwapEffect := D3DSWAPEFFECT_DISCARD;
    MultiSampleType := D3DMULTISAMPLE_NONE;
    BackBufferCount := 1;

    if (not FWindowed) then
      BackBufferFormat := DXBestBackFormat(FBitDepth = bdHigh, FWidth, FHeight, FRefresh)
    else
      BackBufferFormat := DXGetDisplayFormat();

    FullScreen_RefreshRateInHz := FRefresh;
    PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE;
    if (FVSync) then
      PresentationInterval := D3DPRESENT_INTERVAL_ONE;

    if FLockBackBuffer {and FWindowed} then
      Flags := D3DPRESENTFLAG_LOCKABLE_BACKBUFFER;
      
    if (FDepthBuffer) then begin
      EnableAutoDepthStencil := True;
      Flags := D3DPRESENTFLAG_DISCARD_DEPTHSTENCIL or Flags;

      AutoDepthStencilFormat := DXBestDepthFormat(FBitDepth = bdHigh, BackBufferFormat);
    end;
  end;
end;

function TDX9Device.Render(Bkgrnd: Cardinal; FillBk: Boolean): Boolean;
begin
  Result := False;
  if FInitialized and ((FillBk) and (Clear(Bkgrnd))) and Assigned(FOnRender) and BeginScene() then begin
    try
      FOnRender(Self);
    finally
      Result := EndScene();
    end;
  end;
end;

function TDX9Device.RenderOn(Source: TDXRenderTargetTexture; Event: TNotifyEvent;
  Bkgrnd: Cardinal; FillBk: Boolean): Boolean;
begin
  Result := False;
  if (Source = nil) or (Source.State <> tsReady) or (not FInitialized) or (not Assigned(Event)) then
    exit;
  if not Source.BeginRender or ((FillBk) and (not Clear(Bkgrnd, Source.DepthBuffer))) then
    exit;

  BeginScene();
  try
    Event(Self);
  finally
    EndScene();
    Source.EndRender();
  end;
end;

function TDX9Device.Reset: Boolean;
begin
  if (not FInitialized) then begin
    Result := False;
    Exit;
  end;
  FCanvas.Notify(msgDeviceLost);
  if Assigned(FOnNotifyEvent) then
    FOnNotifyEvent(Self, msgDeviceLost);
  UpdatePresentParams();
  Result := Succeeded(Direct3DDevice.Reset(PresentParams));
  if (Result) then begin
    FCanvas.Notify(msgDeviceRecovered);
    if Assigned(FOnNotifyEvent) then
      FOnNotifyEvent(Self, msgDeviceRecovered);
  end;
end;

procedure TDX9Device.SetBitDepth(const Value: TBitDepth);
begin
  //if (not FInitialized) then
  FBitDepth := Value;
end;

procedure TDX9Device.SetDepthBuffer(const Value: Boolean);
begin
  if (not FInitialized) then
    FDepthBuffer := Value;
end;

procedure TDX9Device.SetRefresh(const Value: Integer);
begin
  if (not FInitialized) then
    FRefresh := Value;
end;

procedure TDX9Device.SetSize(const Index, Value: Integer);
begin
  case Index of
    0: FWidth := Value;
    1: FHeight := Value;
  end;
  if (FInitialized) then
    Reset();
end;

procedure TDX9Device.SetState(const Index: Integer; const Value: Boolean);
begin
  case Index of
    0: FWindowed := Value;
    1: FVSync := Value;
    2: FHardwareTL := Value;
  end;
  if (FInitialized) then
    Reset();
end;

procedure TDX9Device.SetWindowHandle(const Value: THandle);
begin
  if (not FInitialized) then
    FWindowHandle := Value;
end;

procedure TDX9Device.UpdatePresentParams;
begin
  with PresentParams do begin
    BackBufferWidth := FWidth;
    BackBufferHeight := FHeight;
    Windowed := FWindowed;

    if (not FWindowed) then
      BackBufferFormat := DXBestBackFormat(FBitDepth = bdHigh, FWidth, FHeight, FRefresh)
    else
      BackBufferFormat := DXGetDisplayFormat();

    PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE;
    if (VSync) then
      PresentationInterval := D3DPRESENT_INTERVAL_ONE;

  end;
end;

end.

