unit USyntaxHighlighter;
{ Very simple Delphi syntax highlighter with limiting color coding support.
  Only '//'-comments are displayed correctly.
  De color settings are retreived from the registry if a version of Delphi
  (versions 2006 or later?) is installed on the machine. Otherwise a default
  color scheme is used. }
  
interface

uses
  Graphics, Windows, Classes;

type
  TSyntaxElement = (seWhitespace,seComment,seReservedWord,seIdentifier,
    seSymbol,seString,seNumber,seAssembler,seHotLink,sePlainText,seMarkedBlock,
    seSearchMatch,seExecutionPoint,seEnabledBreak,seDisabledBreak,
    seInvalidBreak,seErrorLine,seRightMargin,seFloatC,seOctalC,seHexC,
    seCharacterC,sePreprocessorC,seIllegalCharC);

  TElementSettings = record
    BackgroundColor: TColor;
    ForegroundColor: TColor;
    FontStyle      : TFontStyles;
  end;

  TSettingsArray = array [TSyntaxElement] of TElementSettings;

  TSyntaxHighlighter = class
  private
    FSettings: TSettingsArray;
    FReserved: TStringList;
    FFont    : TFont;
  protected
    procedure DefaultSettings;
    function LoadSettingsFromRegistry: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Draw(Canvas: TCanvas; R: TRect; const S: String);

    property EditorFont: TFont read FFont;
    // Font used in Delphi editor
  end;

implementation

uses
  Registry, SysUtils;

const
  ReservedWords: array [0..71] of String = (
    'and','array','as','asm','begin','case','class','const','constructor',
    'destructor','dispinterface','div','do','downto','else','end','except',
    'exports','file','finalization','finally','for','function','goto','if',
    'implementation','in','inherited','initialization','inline','interface',
    'is','label','library','mod','nil','not','object','of','or','out','packed',
    'procedure','program','property','raise','record','repeat','resourcestring',
    'set','shl','shr','string','then','threadvar','to','try','type','unit',
    'until','uses','var','while','with','xor','private','protected','public',
    'published','automated','at','on');

constructor TSyntaxHighlighter.Create;
var
  I: Integer;
begin
  inherited;
  FReserved := TStringList.Create;
  FReserved.Sorted := True;
  for I := 0 to High(ReservedWords) do
    FReserved.Add(ReservedWords[I]);
  FFont := TFont.Create;
  DefaultSettings;
  LoadSettingsFromRegistry;
end;

procedure TSyntaxHighlighter.DefaultSettings;
var
  I: TSyntaxElement;
begin
  for I := Low(TSyntaxElement) to High(TSyntaxElement) do
    with FSettings[I] do begin
      BackgroundColor := clWindow;
      ForegroundColor := clWindowText;
      FontStyle       := [];
    end;

  FSettings[seReservedWord].ForegroundColor := clTeal;
  FSettings[seString].ForegroundColor := clBlue;
  FSettings[seNumber].ForegroundColor := clBlue;
  FSettings[seComment].ForegroundColor := clNavy;

  FFont.Name := 'Courier New';
  FFont.Size := 8;
end;

destructor TSyntaxHighlighter.Destroy;
begin
  FFont.Free;
  FReserved.Free;
  inherited;
end;

procedure TSyntaxHighlighter.Draw(Canvas: TCanvas; R: TRect;
  const S: String);
var
  P, Q: PChar;
  C: Char;
  X, I: Integer;

  procedure Write(Element: TSyntaxElement; P: PChar);
  begin
    with Canvas, FSettings[Element] do begin
      Brush.Color := BackgroundColor;
      Font.Color  := ForegroundColor;
      Font.Style  := FontStyle;
      TextOut(X,R.Top,P);
      Inc(X,TextWidth(P));
    end;
  end;

  procedure DoSymbol;
  begin
    repeat
      Inc(P);
    until P^ in [#0,'''','_','A'..'Z','a'..'z','0'..'9',' ','$','#',#9];
    C := P^; P^ := #0;
    Write(seSymbol,Q);
    P^ := C;
  end;

begin
  P := PChar(S);
  X := R.Left;
  while P^ <> #0 do begin
    Q := P;
    case P^ of
           '/': if (P + 1)^ = '/' then begin
                  Write(seComment,Q);
                  Exit;
                end else
                  DoSymbol;
          '''': begin
                  repeat
                    Inc(P);
                  until P^ in ['''',#0];
                  if P^ = '''' then Inc(P);
                  C := P^; P^ := #0;
                  Write(seString,Q);
                  P^ := C;
                end;
           '_',
      'A'..'Z',
      'a'..'z': begin
                  repeat
                    Inc(P);
                  until not (P^ in ['_','A'..'Z','a'..'z','0'..'9']);
                  C := P^; P^ := #0;
                  if FReserved.Find(Q,I) then
                    Write(seReservedWord,Q)
                  else
                    Write(seIdentifier,Q);
                  P^ := C;
                end;
      '$','#',
      '0'..'9': begin
                  repeat
                    Inc(P);
                  until not (P^ in ['0'..'9','A'..'F','a'..'f','.','+','-']);
                  C := P^; P^ := #0;
                  Write(seNumber,Q);
                  P^ := C;
                end;
      ' ',#9  : begin
                  repeat
                    Inc(P);
                  until not (P^ in [' ',#9]);
                  C := P^; P^ := #0;
                  Write(seWhitespace,Q);
                  P^ := C;
                end;
    else
      DoSymbol;
    end;
  end;
end;

function TSyntaxHighlighter.LoadSettingsFromRegistry: Boolean;
var
  Reg    : TRegistry;
  Version: Integer;
  BaseKey: String;

  function IsBool(const Name: String): Boolean;
  var
    S: String;
  begin
    S := Reg.ReadString(Name);
    if (S = '') or (S = '0') or (CompareText(S,'FALSE') = 0) then
      Result := False
    else
      Result := True;
  end;

  procedure Load(Element: TSyntaxElement; const Key: String);
  var
    S: String;
  begin
    with Reg, FSettings[Element] do if OpenKey(BaseKey + Key,False) then try
      S := ReadString('Background Color New');
      if (S = '') or IsBool('Default Background') then
        BackgroundColor := clWindow
      else
        BackgroundColor := StringToColor(S);

      S := ReadString('Foreground Color New');
      if (S = '') or IsBool('Default Foreground') then
        ForegroundColor := clWindowText
      else
        ForegroundColor := StringToColor(S);

      FontStyle := [];
      if IsBool('Bold') then Include(FontStyle,fsBold);
      if IsBool('Italic') then Include(FontStyle,fsItalic);
      if IsBool('Underline') then Include(FontStyle,fsUnderline);
    except
    end;
  end;

begin
  Result := False;
  Reg := TRegistry.Create;
  with Reg do try
    Version := 9;
    while (Version > 1) do begin
      BaseKey := '\Software\Borland\BDS\' + IntToStr(Version) +
        '.0\Editor\Highlight\';
      if KeyExists(BaseKey + 'Number') then try
        Load(seWhitespace,'Whitespace');
        Load(seComment,'Comment');
        Load(seReservedWord,'Reserved word');
        Load(seIdentifier,'Identifier');
        Load(seSymbol,'Symbol');
        Load(seString,'String');
        Load(seNumber,'Number');
        Load(seAssembler,'Assembler');
        Load(seHotLink,'Hot Link');
        Load(sePlainText,'Plain text');
        Load(seMarkedBlock,'Marked block');
        Load(seSearchMatch,'Search match');
        Load(seExecutionPoint,'Execution point');
        Load(seEnabledBreak,'Enabled break');
        Load(seDisabledBreak,'Disabled break');
        Load(seInvalidBreak,'Invalid break');
        Load(seErrorLine,'Error line');
        Load(seRightMargin,'Right margin');
        Load(seFloatC,'Float');
        Load(seOctalC,'Octal');
        Load(seHexC,'Hex');
        Load(seCharacterC,'Character');
        Load(sePreprocessorC,'Preprocessor');
        Load(seIllegalCharC,'Illegal Char');

        SetLength(BaseKey,Length(BaseKey) - 10);
        if OpenKey(BaseKey + 'Options',False) then begin
          FFont.Name := ReadString('Editor Font');
          FFont.Size := ReadInteger('Font Size');
        end;

        Exit;
      except
      end;
      Dec(Version);
    end;
  finally
    Free;
  end;
end;

end.
