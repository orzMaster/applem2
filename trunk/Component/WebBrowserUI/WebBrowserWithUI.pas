unit WebBrowserWithUI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, SHDocVw, COmObj, ActiveX;

type
  TEnhancedWebBrowserUI = class(TPersistent)
  private
    FlatScrollBar: boolean;
    IE3DBorder: boolean;
    RightClickMenu: boolean;
    ScrollBar: boolean;
  public
    constructor Create;
  published
    property EnableScrollBars: boolean read ScrollBar write ScrollBar;
    property EnableFlatScrollBars: boolean read FlatScrollBar write
      FlatScrollBar;
    property EnableContextMenu: boolean read RightClickMenu write
      RightClickMenu;
    property Enable3DBorder: boolean read IE3DBorder write IE3DBorder;
  end;
  pDocHostUIInfo = ^TDocHostUIInfo;
  TDocHostUIInfo = packed record
    cbSize: ULONG;
    dwFlags: DWORD;
    dwDoubleClick: DWORD;
    pchHostCss: polestr;
    pchHostNS: polestr;
  end;
  IDocHostUIHandler = interface(IUnknown)
    ['{bd3f23c0-d43e-11cf-893b-00aa00bdce1a}']
    function ShowContextMenu(const dwID: DWORD; const ppt: PPOINT;
      const pcmdtReserved: IUnknown; const pdispReserved: IDispatch):
      HRESULT; stdcall;
    function GetHostInfo(var pInfo: TDOCHOSTUIINFO): HRESULT; stdcall;
    function ShowUI(const dwID: DWORD; const pActiveObject:
      IOleInPlaceActiveObject;
      const pCommandTarget: IOleCommandTarget; const pFrame:
      IOleInPlaceFrame;
      const pDoc: IOleInPlaceUIWindow): HRESULT; stdcall;
    function HideUI: HRESULT; stdcall;
    function UpdateUI: HRESULT; stdcall;
    function EnableModeless(const fEnable: BOOL): HRESULT; stdcall;
    function OnDocWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
    function OnFrameWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
    function ResizeBorder(const prcBorder: Integer; const pUIWindow: IOleInPlaceUIWindow; const fRameWindow: BOOL): HRESULT; stdcall;
    function TranslateAccelerator(const lpMsg: PMSG; const pguidCmdGroup:
      PGUID;
      const nCmdID: DWORD): HRESULT; stdcall;
    function GetOptionKeyPath(var pchKey: POLESTR; const dw: DWORD):
      HRESULT; stdcall;
    function GetDropTarget(const pDropTarget: IDropTarget;
      out ppDropTarget: IDropTarget): HRESULT; stdcall;
    function GetExternal(out ppDispatch: IDispatch): HRESULT; stdcall;
    function TranslateUrl(const dwTranslate: DWORD; const pchURLIn: POLESTR;
      var ppchURLOut: POLESTR): HRESULT; stdcall;
    function FilterDataObject(const pDO: IDataObject;
      out ppDORet: IDataObject): HRESULT; stdcall;
  end;

  TWebBrowserWithUI = class(TWebBrowser, IDocHostUIHandler)
  private
    { Private declarations }
    UIProperties: TEnhancedWebBrowserUI;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ShowContextMenu(const dwID: DWORD; const ppt: PPOINT; const pcmdtReserved: IUnknown; const pdispReserved: IDispatch): HRESULT; stdcall;
    function GetHostInfo(var pInfo: TDOCHOSTUIINFO): HRESULT; stdcall;
    function ShowUI(const dwID: DWORD; const pActiveObject: IOleInPlaceActiveObject; const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame;
      const pDoc: IOleInPlaceUIWindow): HRESULT; stdcall;
    function HideUI: HRESULT; stdcall;
    function UpdateUI: HRESULT; stdcall;
    function EnableModeless(const fEnable: BOOL): HRESULT; stdcall;
    function OnDocWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
    function OnFrameWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
    function ResizeBorder(const prcBorder: Integer; const pUIWindow: IOleInPlaceUIWindow; const fRameWindow: BOOL): HRESULT; stdcall;
    function TranslateAccelerator(const lpMsg: PMSG; const pguidCmdGroup: PGUID; const nCmdID: DWORD): HRESULT; stdcall;
    function GetOptionKeyPath(var pchKey: POLESTR; const dw: DWORD): HRESULT; stdcall;
    function GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HRESULT; stdcall;
    function GetExternal(out ppDispatch: IDispatch): HRESULT; stdcall;
    function TranslateUrl(const dwTranslate: DWORD; const pchURLIn: POLESTR; var ppchURLOut: POLESTR): HRESULT; stdcall;
    function FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HRESULT; stdcall;
    procedure WMSetFocus(var WMessage: TMessage); message WM_SETFOCUS;
    procedure WMKillFocus(var WMessage: TMessage); message WM_KILLFOCUS;
  published
    { Published declarations }
    property UISettings: TEnhancedWebBrowserUI read UIProperties write UIProperties;
  end;
const
  DOCHOSTUIFLAG_DIALOG = $00000001;
  DOCHOSTUIFLAG_DISABLE_HELP_MENU = $00000002;
  DOCHOSTUIFLAG_NO3DBORDER = $00000004;
  DOCHOSTUIFLAG_SCROLL_NO = $00000008;
  DOCHOSTUIFLAG_DISABLE_SCRIPT_INACTIVE = $00000010;
  DOCHOSTUIFLAG_OPENNEWWIN = $00000020;
  DOCHOSTUIFLAG_DISABLE_OFFSCREEN = $00000040;
  DOCHOSTUIFLAG_FLAT_SCROLLBAR = $00000080;
  DOCHOSTUIFLAG_DIV_BLOCKDEFAULT = $00000100;
  DOCHOSTUIFLAG_ACTIVATE_CLIENTHIT_ONLY = $00000200;
  DOCHOSTUIFLAG_OVERRIDEBEHAVIOURFACTORY = $00000400;
  DOCHOSTUIFLAG_CODEPAGELINKEDFONTS = $00000800;
  DOCHOSTUIFLAG_URL_ENCODING_DISABLE_UTF8 = $00001000;
  DOCHOSTUIFLAG_URL_ENCODING_ENABLE_UTF8 = $00002000;
  DOCHOSTUIFLAG_ENABLE_FORMS_AUTOCOMPLETE = $00004000;
  IID_IDocHostUIHandler: TGUID = '{bd3f23c0-d43e-11CF-893b-00aa00bdce1a}';

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TWebBrowserWithUI]);
end;

{ TEnhancedWebBrowserUI }

constructor TEnhancedWebBrowserUI.Create;
begin
  ScrollBar := True;
  FlatScrollBar := False;
  IE3DBorder := True;
  RightClickMenu := True;
end;

{ TWebBrowserWithUI }

constructor TWebBrowserWithUI.Create(AOwner: TComponent);
begin
  inherited;
  UIProperties := TEnhancedWebBrowserUI.Create;
end;

destructor TWebBrowserWithUI.Destroy;
begin
  UIProperties.Free;
  inherited;
end;

function TWebBrowserWithUI.EnableModeless(const fEnable: BOOL): HRESULT;
begin
  result := S_FALSE;
end;

function TWebBrowserWithUI.FilterDataObject(const pDO: IDataObject;
  out ppDORet: IDataObject): HRESULT;
begin
  result := S_FALSE;
end;

function TWebBrowserWithUI.GetDropTarget(const pDropTarget: IDropTarget;
  out ppDropTarget: IDropTarget): HRESULT;
begin
  result := S_FALSE;
end;

function TWebBrowserWithUI.GetExternal(out ppDispatch: IDispatch): HRESULT;
begin
  result := S_OK;
end;

function TWebBrowserWithUI.GetHostInfo(var pInfo: TDOCHOSTUIINFO): HRESULT;
begin
  pInfo.cbSize := SizeOf(pInfo);
  pInfo.dwFlags := 0;
  if not UIProperties.EnableScrollBars then
    pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_SCROLL_NO;
  if UIProperties.EnableFlatScrollBars then
    pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_FLAT_SCROLLBAR;
  if not UIProperties.Enable3DBorder then
    pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_NO3DBORDER;
  result := S_OK;
end;

function TWebBrowserWithUI.GetOptionKeyPath(var pchKey: POLESTR;
  const dw: DWORD): HRESULT;
begin
  result := S_FALSE;
end;

function TWebBrowserWithUI.HideUI: HRESULT;
begin
  result := S_FALSE;
end;

function TWebBrowserWithUI.OnDocWindowActivate(
  const fActivate: BOOL): HRESULT;
begin
  result := S_FALSE;
end;

function TWebBrowserWithUI.OnFrameWindowActivate(
  const fActivate: BOOL): HRESULT;
begin
  result := S_FALSE;
end;

function TWebBrowserWithUI.ResizeBorder(const prcBorder: Integer;
  const pUIWindow: IOleInPlaceUIWindow; const fRameWindow: BOOL): HRESULT;
begin
  result := S_FALSE;
end;

function TWebBrowserWithUI.ShowContextMenu(const dwID: DWORD;
  const ppt: PPOINT; const pcmdtReserved: IUnknown;
  const pdispReserved: IDispatch): HRESULT;
begin
  if UIProperties.EnableContextMenu then
    result := S_FALSE
  else
    result := S_OK;
end;

function TWebBrowserWithUI.ShowUI(const dwID: DWORD;
  const pActiveObject: IOleInPlaceActiveObject;
  const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame;
  const pDoc: IOleInPlaceUIWindow): HRESULT;
begin
  result := S_FALSE;
end;

function TWebBrowserWithUI.TranslateAccelerator(const lpMsg: PMSG;
  const pguidCmdGroup: PGUID; const nCmdID: DWORD): HRESULT;
begin
  result := S_FALSE;
end;

function TWebBrowserWithUI.TranslateUrl(const dwTranslate: DWORD;
  const pchURLIn: POLESTR; var ppchURLOut: POLESTR): HRESULT;
begin
  result := S_FALSE;
end;

function TWebBrowserWithUI.UpdateUI: HRESULT;
begin
  result := S_FALSE;
end;

procedure TWebBrowserWithUI.WMKillFocus(var WMessage: TMessage);
begin

end;

procedure TWebBrowserWithUI.WMSetFocus(var WMessage: TMessage);
begin

end;

end.

