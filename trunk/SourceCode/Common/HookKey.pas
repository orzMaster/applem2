unit HookKey;

interface
uses
  Windows, Messages;

const
  WH_KEYBOARD_LL = 13;
  //定义一个常量好和上面哪个结构中的flags比较而得出ALT键是否按下
  LLKHF_ALTDOWN = $20;

type
  tagKBDLLHOOKSTRUCT = packed record
    vkCode: DWORD; //虚拟键值
    scanCode: DWORD; //扫描码值（没有用过）
  {一些扩展标志，这个值比较麻烦，MSDN上说得也不太明白，但是
  根据这个程序，这个标志值的第六位数（二进制）为1时ALT键按下为0相反。}
    flags: DWORD;
    time: DWORD; //消息时间戳
    dwExtraInfo: DWORD; //和消息相关的扩展信息
  end;
  KBDLLHOOKSTRUCT = tagKBDLLHOOKSTRUCT;
  PKBDLLHOOKSTRUCT = ^KBDLLHOOKSTRUCT;

function LowLevelKeyboardProc(nCode: Integer; WParam: WPARAM; LParam:
  LPARAM): LRESULT; stdcall;

function HookStar(): Boolean; //设置钩子
function HookEnd(): Boolean;

implementation

var
  hhkLowLevelKybd: HHOOK = 0;

function LowLevelKeyboardProc(nCode: Integer; WParam: WPARAM; LParam:
  LPARAM): LRESULT; stdcall;
var
  fEatKeystroke: BOOL;
  p: PKBDLLHOOKSTRUCT;
begin
  Result := 0;
  fEatKeystroke := FALSE;
  p := PKBDLLHOOKSTRUCT(lParam);
  //nCode值为HC_ACTION时表示WParam和LParam参数包涵了按键消息
  if (nCode = HC_ACTION) then
  begin
    //拦截按键消息并测试是否是Ctrl+Esc、Alt+Tab、和Alt+Esc功能键。
    case wParam of
      WM_KEYDOWN,
        WM_SYSKEYDOWN,
        WM_KEYUP,
        WM_SYSKEYUP:
        //ShowMessage(IntToStr(p.vkCode));
    end;
  end;

  if fEatKeystroke = True then
    Result := 1;
  if nCode <> 0 then
    Result := CallNextHookEx(0, nCode, wParam, lParam);
end;

function HookStar(): Boolean; //设置钩子
begin
  //设置键盘钩子
  Result := False;
  if hhkLowLevelKybd = 0 then
  begin
    hhkLowLevelKybd := SetWindowsHookExW(WH_KEYBOARD_LL,
      LowLevelKeyboardProc,
      Hinstance,
      0);
    if hhkLowLevelKybd <> 0 then Result := True;
  end;
end;

function HookEnd(): Boolean;
begin
  Result := False;
  if hhkLowLevelKybd <> 0 then
    if UnhookWindowsHookEx(hhkLowLevelKybd) <> False then
    begin
      hhkLowLevelKybd := 0;
      Result := True;
    end;
end;

initialization
  begin
  end;

finalization
  begin
  end;

end.

