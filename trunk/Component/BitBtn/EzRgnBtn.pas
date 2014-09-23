unit EzRgnBtn;

//============================================================================//
//  This Unit contains EzRgnBtn component
//  Main functionality :
//       Component may hold and manage from 1 to 4 images for different
//       states of the component : Idle, Pressed, MouseOver & Disabled
//       Component may be painted in three different ways: as regular bitmap,
//       transparent and !!! may be CROPPED.
//
//  Main usage :
//       EzRgnBtn may be used as Panel or Button.
//
//  Notes : if one of the images is not filled then Component uses Idle image
//          for special state.
//
//          This unit also exports 2 funtions which are used by the EzRgnBtn
//          itself :
//                 CropWindow & UncropWindow
//          both functions may be used separately from the component.
//          See the Example project for other details
//
//         ==  public Methods ==
//
//         procedure Down( HowLong : longint );
//                   * simulates the Pressing on the EzRgnBtn.
//                     Simply light the button fro shorty time
//
//         ==  public and published Properties ==
//
//         property AutoRepeat : Boolean;
//                    * I enabled then when continue holding the EzRgnBtn pressing
//                      then generates Pressing on the component
//
//         property Enabled : boolean;
//         property Disabled : boolean;
//                    * Two properties fot Enable/Disable state of the EzRgnBtn
//                      The seconds is read only, but sometime may be very powerfull property
//
//         property PicIdle   : TPicture;
//         property PicDown   : TPicture;
//         property PicUp     : TPicture;
//         property PicDsbld  : TPicture;
//                    * Four states of the component. Idle - is Mandatory and three other
//                      are optional.
//
//         property PaintMode : TPaintMode;
//                    * Says to component how be painted. There are three ways:
//                      Normal, Crop and Transparent.
//
//         property ImageList : TImageList;
//                    * EzRgnBtn know to load the images from the TImageList, but
//                      it the images must be  in following order :
//                       image for Idle state, for MouseOver state, Pressed (Down) state
//                       and image for Disabled state. ImageList mat contain part of images
//                       but still, eg. it will try to take Disabled images from the
//                       4-th in the ImageList (If you want that your EzRgnBtn will
//                       have disabled state).
//
//         ==  public and published Events ==
//         property OnMouseDown  : TOnMouseEvent;
//         property OnMouseEnter : TOnMouseEvent;
//         property OnMouseLeave : TOnMouseEvent;
//         property OnMouseUp    : TOnMouseEvent;
//
//         ==  parent Events and Properties ==
//         property OnMouseMove;
//         property OnClick;
//         property Visible;
//         property PopUpMenu;
//         property ShowHint;
//
//           * All these events are very well known, so I have no to explain them
//
//  Author : Paul Krestol
//  Tested in Delphi 3, Delphi 4 and Delphi 5
//  Full sources are included
//  I will be happy to receive the bug list or any other suggestions from anyone
//  My contact @-mail is paul@mediasonic.co.il
//
//  I also 've developed list of other component for our internal projects.
//  Hope that this component may help you somehow in your developing
//============================================================================//

interface

uses
  Windows, Forms, Messages, SysUtils, Classes, Graphics, Controls, Dialogs, ExtCtrls;

type
  TOnMouseEvent = procedure( Msg: TWMMouse ) of object;

  TPaintMode = ( pmNormal, pmCrop, pmTransparent );

  TEzRgnBtn = class( TCustomControl )
  protected
    FFreeEvent : THandle;
    FCroped : boolean;
    FDownTimer : TTimer;
    procedure FOnDownTimerProc( Sender: TObject );
    procedure WMMouseEnter( var Msg : TWMMouse );               message CM_MOUSEENTER;
    procedure WMMouseLeave( var Msg : TWMMouse );               message CM_MOUSELEAVE;
    procedure WMLButtonUp( var Msg : TWMLButtonUp );            message WM_LBUTTONUP;
    procedure WMLButtonDown( var Msg : TWMLButtonUp );          message WM_LBUTTONDOWN;
    procedure WMLButtonDblClk( var Message: TWMLButtonDblClk ); message WM_LBUTTONDBLCLK;
    procedure Click; override;
    procedure SetEnabled( Value : boolean ); reintroduce;
    procedure TimerExpired( Sender: TObject); virtual;
  private
    FRepeatTimer : TTimer;
    FAutoRepeat : Boolean;
    FPaintMode    : TPaintMode;
    FDown         : boolean;
    FEnter        : boolean;
    FEnabled      : boolean;
    FDowned       : boolean;
    FOnMouseDown  : TOnMouseEvent;
    FOnMouseEnter : TOnMouseEvent;
    FOnMouseLeave : TOnMouseEvent;
    FOnMouseUp    : TOnMouseEvent;
    FOnMouseDownEx: TMouseEvent;
    FOnMouseUpEx  : TMouseEvent;
    FPicIdle      : TPicture;
    FPicDown      : TPicture;
    FPicDsbld     : TPicture;
    FPicUp        : TPicture;
    FImageList    : TImageList;
    FPressingTime : Longint;
    procedure SetPaintMode( Value : TPaintMode );
    procedure SetPicIdle( Value : TPicture );
    procedure SetPicDown( Value : TPicture );
    procedure SetPicDsbld( Value : TPicture );
    procedure SetPicUp( Value : TPicture );
    function  GetPicDown : TPicture;
    function  GetPicDsbld : TPicture;
    function  GetPicUp : TPicture;
    function  GetPicIdle : TPicture;
    function  GetDisabled : boolean;
    procedure PictureChanged( Sender: TObject );
    procedure CheckRepeatTimer;
    procedure SetImageList( Value : TImageList );
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure UncropCanvas;
    procedure CropCanvas;
    procedure Down( HowLong : longint );
  published
    property AutoRepeat: Boolean read FAutoRepeat write FAutoRepeat default False;
    property Enabled : boolean read FEnabled write SetEnabled;
    property Disabled : boolean read GetDisabled;
    //** Images for states **//
    property PicIdle   : TPicture read FPicIdle  write SetPicIdle;// stored StorePictures;
    property PicDown   : TPicture read FPicDown  write SetPicDown;// stored StorePictures;
    property PicUp     : TPicture read FPicUp    write SetPicUp;// stored StorePictures;
    property PicDsbld  : TPicture read FPicDsbld write SetPicDsbld;// stored StorePictures;
    property PaintMode : TPaintMode read FPaintMode write SetPaintMode;
    property ImageList : TImageList read FImageList write SetImageList;
    //** Events **//
    property OnMouseDown  : TOnMouseEvent read FOnMouseDown  write FOnMouseDown;
    property OnMouseEnter : TOnMouseEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave : TOnMouseEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseUp    : TOnMouseEvent read FOnMouseUp    write FOnMouseUp;

    property OnMouseDownEx  : TMouseEvent read FOnMouseDownEx  write FOnMouseDownEx;
    property OnMouseUpEx    : TMouseEvent read FOnMouseUpEx    write FOnMouseUpEx;
    //** Parent's properties **//
    property OnMouseMove;
    property OnClick;
    property Visible;
    property PopUpMenu;
    property ShowHint;
  end;

procedure Register;

//** Any WinControl object may be passed here as parameter **//
procedure CropWindow( Handle: HWnd; Picture : TPicture );
procedure UncropWindow( Handle: HWnd; Picture : TPicture );

implementation
{$R *.RES}

//============================================================================//
procedure Register;
begin
  RegisterComponents( 'Plus', [ TEzRgnBtn ] );
end;

//============================================================================//
constructor TEzRgnBtn.Create;
begin
  FEnabled := True;
  FPaintMode := pmNormal;
  FCroped := False;
  FDowned := False;
  inherited;
  ControlStyle := [ csCaptureMouse, csClickEvents, csSetCaption, csDoubleClicks, csAcceptsControls ];
  Width := 15;
  Height := 15;
  FPressingTime := 100;
  FFreeEvent := CreateEvent( nil, False, True, nil );
  FPicIdle   := TPicture.Create;
  FPicUp     := TPicture.Create;
  FPicDown   := TPicture.Create;
  FPicDsbld  := TPicture.Create;
  FPicIdle.OnChange  := PictureChanged;
  FPicUp.OnChange    := PictureChanged;
  FPicDown.OnChange  := PictureChanged;
  FPicDsbld.OnChange := PictureChanged;
  FEnter := False;
  FDown  := False;
  FRepeatTimer := TTimer.Create( Self );
  FRepeatTimer.Interval := 300;
  FRepeatTimer.OnTimer := TimerExpired;
  FRepeatTimer.Enabled  := False;
  FDownTimer := TTimer.Create( nil );
  FDownTimer.Enabled := False;
  FDownTimer.OnTimer := FOnDownTimerProc;
  FOnMouseDownEx := nil;
  FOnMouseUpEx := nil;
end;

//============================================================================//
destructor TEzRgnBtn.Destroy;
begin
  FPicIdle.Free;
  FPicDown.Free;
  FPicUp.Free;
  FPicDsbld.Free;
  CloseHandle( FFreeEvent );
  inherited;
end;

//============================================================================//
procedure TEzRgnBtn.TimerExpired(Sender: TObject);
begin
  Click;
end;

//============================================================================//
procedure TEzRgnBtn.CheckRepeatTimer;
begin
  FRepeatTimer.Enabled := FAutoRepeat and FEnter and FDown;
end;

//============================================================================//
procedure TEzRgnBtn.Click;
begin
  if FEnabled then inherited;
end;

//============================================================================//
// Activate button
procedure TEzRgnBtn.WMMouseEnter( var Msg: TWMMouse );
begin
  inherited;
  if FEnter then Exit;
  FEnter := True;
  PictureChanged( Self );
  if Assigned( FOnMouseEnter ) then FOnMouseEnter( Msg );
  CheckRepeatTimer;
end;

//============================================================================//
// Diactivate button
procedure TEzRgnBtn.WMMouseLeave( var Msg: TWMMouse );
begin
  inherited;
  FEnter := False;
  PictureChanged( Self );
  if Assigned( FOnMouseLeave ) then FOnMouseLeave( Msg );
  CheckRepeatTimer;
end;

//============================================================================//
procedure TEzRgnBtn.WMLButtonDown(var Msg: TWMMouse);
begin
  inherited;
  FDown := True;
  PictureChanged( Self );
  if Assigned( FOnMouseDown ) then FOnMouseDown( Msg );
  if Assigned( FOnMouseDownEx ) then FOnMouseDownEx(Self, mbLeft, KeysToShiftState(Msg.Keys), Msg.XPos, Msg.YPos);
  CheckRepeatTimer;
end;

//============================================================================//
procedure TEzRgnBtn.WMLButtonUp(var Msg: TWMMouse);
begin
  inherited;
  FDown := False;
  PictureChanged( Self );
  if Assigned( FOnMouseUp ) then FOnMouseUp( Msg );
  if Assigned( FOnMouseUpEx ) then FOnMouseUpEx(Self, mbLeft, KeysToShiftState(Msg.Keys), Msg.XPos, Msg.YPos);
  CheckRepeatTimer;
end;

//============================================================================//
procedure TEzRgnBtn.SetPicIdle( Value : TPicture );
begin
  FPicIdle.Assign( Value );
  PictureChanged( Self );
  if FCroped then begin
    UncropCanvas;
    CropCanvas;
  end;
end;

//============================================================================//
procedure TEzRgnBtn.SetPicDown( Value : TPicture );
begin
  FPicDown.Assign( Value );
end;

//============================================================================//
procedure TEzRgnBtn.SetPicUp( Value : TPicture );
begin
  FPicUp.Assign( Value );
end;

//============================================================================//
procedure TEzRgnBtn.SetPicDsbld( Value : TPicture );
begin
  FPicDsbld.Assign( Value );
end;

//============================================================================//
procedure TEzRgnBtn.SetPaintMode( Value : TPaintMode );
begin
  if FPaintMode = Value then Exit;
  if FPaintMode = pmCrop then UncropCanvas;
  FPaintMode := Value;
  if FPaintMode = pmCrop then CropCanvas;
  PictureChanged( Self );
end;

//============================================================================//
procedure TEzRgnBtn.Paint;
var
  Rect : TRect;
  TransparentColor : TColor;
  tmpPicture : TPicture;
begin
  inherited;
  if ( ( FDown and FEnter ) or ( FDowned ) ) and Enabled then tmpPicture := GetPicDown
  else
  if ( FEnter and ( not FDown ) and Enabled ) then tmpPicture := GetPicUp
  else
  if ( FDown and ( not FEnter ) ) then tmpPicture := GetPicIdle
  else
    tmpPicture := GetPicIdle;

  if not Assigned( tmpPicture.Graphic ) then Exit;

  WaitForSingleObject( FFreeEvent, INFINITE );   //** Wait until be able to continue **//
  Width := tmpPicture.Graphic.Width;
  Height := tmpPicture.Graphic.Height;
  Rect := Classes.Rect( 0, 0, tmpPicture.Graphic.Width, tmpPicture.Graphic.Height );

  if FPaintMode = pmTransparent then begin
    TransparentColor := tmpPicture.Bitmap.Canvas.Pixels[ 0, 0 ];
    Canvas.Brush.Style := bsClear;
    Canvas.BrushCopy( Rect, tmpPicture.Bitmap, Rect, TransparentColor );
  end
  else begin
    Canvas.CopyRect( Rect, tmpPicture.Bitmap.Canvas, Rect );
  end;
  SetEvent( FFreeEvent );
end;

//============================================================================//
procedure TEzRgnBtn.CropCanvas;
begin
  if FPaintMode <> pmCrop then Exit;
  if FCroped then Exit;
  if not Assigned( FPicIdle ) then Exit;
  WaitForSingleObject( FFreeEvent, INFINITE );   //** Wait until be able to continue **//
  CropWindow( Handle, FPicIdle );
  SetEvent( FFreeEvent );
  FCroped := True;
end;

//============================================================================//
procedure TEzRgnBtn.UncropCanvas;
begin
  WaitForSingleObject( FFreeEvent, INFINITE );   //** Wait until be able to continue **//
  UncropWindow( Handle, FPicIdle );
  SetEvent( FFreeEvent );
  FCroped := False;
end;

//============================================================================//
procedure TEzRgnBtn.PictureChanged( Sender: TObject );
begin
  Paint;
end;

//============================================================================//
function  TEzRgnBtn.GetDisabled : boolean;
begin
  Result := not Enabled;
end;

//============================================================================//
procedure TEzRgnBtn.SetEnabled( Value : boolean );
begin
  if FEnabled = Value then Exit;
  FEnabled := Value;
  PictureChanged( Self );
end;

//============================================================================//
function TEzRgnBtn.GetPicDown : TPicture;
begin
  if Assigned( FPicDown.Graphic ) then Result := FPicDown
    else Result := GetPicIdle;
end;

//============================================================================//
function TEzRgnBtn.GetPicDsbld : TPicture;
begin
  if Assigned( FPicDsbld.Graphic ) then Result := FPicDsbld
    else Result := FPicIdle;
end;

//============================================================================//
function TEzRgnBtn.GetPicUp : TPicture;
begin
  if Assigned( FPicUp.Graphic ) then Result := FPicUp
    else Result := GetPicIdle;
end;

//============================================================================//
function TEzRgnBtn.GetPicIdle : TPicture;
begin
  Result := nil;
  case FEnabled of
    True : Result := FPicIdle;
    False : Result := GetPicDsbld;
  end;
end;

//============================================================================//
procedure TEzRgnBtn.WMLButtonDblClk( var Message: TWMLButtonDblClk );
begin
//  Click;
//  if Assigned( OnClick ) then OnClick( Self );
end;

//============================================================================//
procedure TEzRgnBtn.FOnDownTimerProc( Sender: TObject );
begin
  FDownTimer.Enabled := False;
  FDowned := False;
  PictureChanged( Self );
end;

//============================================================================//
procedure TEzRgnBtn.Down( HowLong : longint );
begin
  if HowLong <> 0 then FPressingTime := HowLong;
  FDownTimer.Interval := FPressingTime;
  FDownTimer.Enabled := True;
  FDowned := True;
  PictureChanged( Self );
end;

//============================================================================//
procedure TEzRgnBtn.SetImageList( Value : TImageList );
var
  BitMap : TBitMap;
begin
  if FImageList = Value then Exit;
  FImageList := Value;
  if Assigned( FImageList ) then
  begin
    BitMap := TBitMap.Create;
    if Value.Count > 0 then
    begin
      FImageList.GetBitmap( 0, BitMap );
      PicIdle.Bitmap.Assign( BitMap );
    end;
    if Value.Count > 1 then
    begin
      FImageList.GetBitmap( 1, BitMap );
      PicUp.Bitmap.Assign( BitMap );
    end;
    if Value.Count > 2 then
    begin
      FImageList.GetBitmap( 2, BitMap );
      PicDown.Bitmap.Assign( BitMap );
    end;
    if Value.Count > 3 then
    begin
      FImageList.GetBitmap( 3, BitMap );
      PicDsbld.Bitmap.Assign( BitMap );
    end;
    BitMap.Free;
  end;
end;


//============================================================================//
//============================================================================//
//============================================================================//
procedure CropWindow( Handle: HWnd; Picture : TPicture );
var
  hrgn, hrgn1 : integer;
  hdc : integer;
  x, y : integer;
  Color : TColor;
begin
  Color := Picture.Bitmap.Canvas.Pixels[ 0, 0 ];
  hdc := GetDC( Handle );
  hrgn := CreateRectRgn( 0, 0, Picture.Graphic.Width, Picture.Graphic.Height );
  for x := 1 to Picture.Graphic.Width do
    for y := 1 to Picture.Graphic.Height do
      if Picture.Bitmap.Canvas.Pixels[ x - 1, y - 1 ] = Color then begin
        hrgn1 := CreateRectRgn( x - 1, y - 1, x, y);
        CombineRgn( hrgn, hrgn, hrgn1, RGN_DIFF );
        DeleteObject( hrgn1 );
      end;
  SetWindowRgn( Handle, hrgn, true );
  //DeleteObject( hrgn );
  ReleaseDC( Handle, hdc);
end;

//============================================================================//
//============================================================================//
//============================================================================//
procedure UncropWindow( Handle: HWnd; Picture : TPicture );
var
  hrgn : integer;
  hdc : integer;
begin
  hdc := GetDC( Handle );
  hrgn := CreateRectRgn( 0, 0, Picture.Graphic.Width , Picture.Graphic.Height );
  SetWindowRgn( Handle, hrgn, true );
  ReleaseDC( Handle, hdc );
end;

end.
