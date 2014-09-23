unit MudUtil;

interface
uses
  Windows, Classes, SysUtils;
type
  TQuickID = record
    sAccount: string[16];
    sChrName: string[20];
    nIndex: Integer;
    nSelectID: Integer;
  end;
  pTQuickID = ^TQuickID;
  TQuickList = class(TStringList)
  private
    CriticalSection: TRTLCriticalSection;
    function GetCaseSensitive: Boolean;
    procedure SetCaseSensitive(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure SortString(nMin, nMax: Integer);
    function GetIndex(sName: string): Integer;
    function AddRecord(sName: string; nIndex: Integer): Boolean;
    function DelRecord(nIndex: Integer; sChrName: string): Boolean;
    function DelRecordEx(sChrName: string): Boolean;
    procedure Lock;
    procedure UnLock;
  published
    property boCaseSensitive: Boolean read GetCaseSensitive write SetCaseSensitive;
  end;
  TQuickIDList = class(TStringList)
  public
    destructor Destroy; override;
    procedure AddRecord(sAccount, sChrName: string; nIndex, nSelIndex: Integer);
    procedure DelRecord(nIndex: Integer; sChrName: string);
    procedure DelRecordEx(nIndex: Integer);
    function GetChrList(sAccount: string; var ChrNameList: TList): Integer;
  end;

  TQuickIndexList = class(TStringList)
  public
    destructor Destroy; override;
    procedure AddRecord(sChrName, sDelChrName: string; nIndex: Integer);
    procedure DelRecord(nIndex: Integer);
    function GetIndex(sChrName: string): Integer;
    procedure LoadFromFile(const FileName: string); override;
    procedure SaveToFile(const FileName: string); override;
  end;

  TQuickIntegerList = class(TList)
  public
    function AddInteger(nIndex: Integer; boAdd: Boolean): Boolean;
  end;

  TQuickStringList = class(TStringList)
  public
    function AddString(nIndex: string; Item: TObject; boAdd: Boolean): Boolean;
  end;

  TQuickStringPointerList = class(TStringList)
  public
    procedure AddString(nIndex: string; Item: Pointer);
    procedure SortString(nMin, nMax: Integer);
  end;

  TQuickStringAddList = class(TStringList)
  public
    function AddString(nIndex: string; boAdd: Boolean): Boolean;
  end;

  TQuickListList = class(TStringList)
  public
    procedure AddString(nIndex: string; Item: TObject);
  end;

  TQuickPointList = class(TList)
    m_List: TList;
  public
    constructor Create();
    destructor Destroy; override;
    procedure ClearPointer;
    procedure Clear; override;
    procedure DeleteEx(Index: Integer);
    function AddPointer(nIndex: Integer; Item: Pointer; boAdd: Boolean): Pointer;
    function GetPointer(nIndex: Integer): Pointer;
  end;

implementation

uses
  Hutil32;

procedure TQuickListList.AddString(nIndex: string; Item: TObject);
begin
end;

constructor TQuickPointList.Create();
begin
  inherited Create;
  m_List := TList.Create;
end;

procedure TQuickPointList.DeleteEx(Index: Integer);
begin
  Delete(Index);
  if (Index >= 0) and (Index < m_List.Count) then
    m_List.Delete(Index);
end;

destructor TQuickPointList.Destroy;
begin
  m_List.Free;
  inherited;

end;

procedure TQuickPointList.Clear;
begin
  inherited;
  ClearPointer();
end;

procedure TQuickPointList.ClearPointer();
begin
  m_List.Clear;
end;

function TQuickPointList.GetPointer(nIndex: Integer): Pointer;
begin
  Result := m_List.Items[nIndex];
end;

function TQuickPointList.AddPointer(nIndex: Integer; Item: Pointer; boAdd:
  Boolean): Pointer;
var
  nLow, nHigh, nMed, n1C, n20: Integer;
begin
  Result := nil;
  if Count = 0 then begin
    Add(Pointer(nIndex));
    m_List.Add(Item);
  end
  else begin
    if Count = 1 then begin
      nMed := Integer(Items[0]) - nIndex;
      if nMed > 0 then begin
        Add(Pointer(nIndex));
        m_List.Add(Item);
      end
      else begin
        if nMed < 0 then begin
          Insert(0, Pointer(nIndex));
          m_List.Insert(0, Item);
        end
        else begin
          Result := m_List.Items[0];
          if boAdd then begin
            Add(Pointer(nIndex));
            m_List.Add(Item);
          end;
        end;
      end;
    end
    else begin
      nLow := 0;
      nHigh := Count - 1;
      nMed := (nHigh - nLow) div 2 + nLow;
      while (true) do begin
        if (nHigh - nLow) = 1 then begin
          n20 := Integer(Items[nHigh]) - nIndex;
          if n20 > 0 then begin
            Insert(nHigh + 1, Pointer(nIndex));
            m_List.Insert(nHigh + 1, Item);
            break;
          end
          else begin
            if (Integer(Items[nHigh]) - nIndex) = 0 then begin
              Result := m_List.Items[nHigh];
              if boAdd then begin
                Insert(nHigh + 1, Pointer(nIndex));
                m_List.Insert(nHigh + 1, Item);
              end;
              break;
            end
            else begin
              n20 := Integer(Items[nLow]) - nIndex;
              if n20 > 0 then begin
                Insert(nLow + 1, Pointer(nIndex));
                m_List.Insert(nLow + 1, Item);
                break;
              end
              else begin
                if n20 < 0 then begin
                  Insert(nLow, Pointer(nIndex));
                  m_List.Insert(nLow, Item);
                  break;
                end
                else begin
                  Result := m_List.Items[nLow];
                  if boAdd then begin
                    Insert(nLow + 1, Pointer(nIndex));
                    m_List.Insert(nLow + 1, Item);
                  end;
                  break;
                end;
              end;
            end;
          end;
        end
        else begin
          n1C := Integer(Items[nMed]) - nIndex;
          if n1C > 0 then begin
            nLow := nMed;
            nMed := (nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          if n1C < 0 then begin
            nHigh := nMed;
            nMed := (nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          Result := m_List.Items[nMed];
          if boAdd then begin
            Insert(nMed + 1, Pointer(nIndex));
            m_List.Insert(nMed + 1, Item);
          end;
          break;
        end;
      end;
    end;
  end;
end;

function TQuickStringAddList.AddString(nIndex: string; boAdd: Boolean): Boolean;
var
  nLow, nHigh, nMed, n1C, n20: Integer;
begin
  Result := False;
  if Count = 0 then begin
    if boAdd then
      Add(nIndex);
  end
  else begin
    if Count = 1 then begin
      nMed := CompareText(nIndex, Strings[0]);
      if nMed > 0 then begin
        if boAdd then
          Add(nIndex);
      end
      else begin
        if nMed < 0 then begin
          if boAdd then
            Insert(0, nIndex);
        end
        else begin
          Result := True;
        end;
      end;
    end
    else begin
      nLow := 0;
      nHigh := Count - 1;
      nMed := (nHigh - nLow) div 2 + nLow;
      while (true) do begin
        if (nHigh - nLow) = 1 then begin
          n20 := CompareText(nIndex, Strings[nHigh]);
          if n20 > 0 then begin
            if boAdd then
              Insert(nHigh + 1, nIndex);
            break;
          end
          else begin
            if CompareText(nIndex, Strings[nHigh]) = 0 then begin
              Result := True;
              break;
            end
            else begin
              n20 := CompareText(nIndex, Strings[nLow]);
              if n20 > 0 then begin
                if boAdd then
                  Insert(nLow + 1, nIndex);
                break;
              end
              else begin
                if n20 < 0 then begin
                  if boAdd then
                    Insert(nLow, nIndex);
                  break;
                end
                else begin
                  Result := True;
                  break;
                end;
              end;
            end;
          end;
        end
        else begin
          n1C := CompareText(nIndex, Strings[nMed]);
          if n1C > 0 then begin
            nLow := nMed;
            nMed := (nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          if n1C < 0 then begin
            nHigh := nMed;
            nMed := (nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          Result := True;
          break;
        end;
      end;
    end;
  end;
end;

function TQuickStringList.AddString(nIndex: string; Item: TObject; boAdd:
  Boolean): Boolean;
var
  nLow, nHigh, nMed, n1C, n20: Integer;
begin
  Result := False;
  if Count = 0 then begin
    AddObject(nIndex, Item);
  end
  else begin
    if Count = 1 then begin
      nMed := CompareText(nIndex, Strings[0]);
      if nMed > 0 then begin
        AddObject(nIndex, Item);
      end
      else begin
        if nMed < 0 then begin
          InsertObject(0, nIndex, Item);
        end
        else begin
          if boAdd then
            AddObject(nIndex, Item);
          Result := True;
        end;
      end;
    end
    else begin
      nLow := 0;
      nHigh := Count - 1;
      nMed := (nHigh - nLow) div 2 + nLow;
      while (true) do begin
        if (nHigh - nLow) = 1 then begin
          n20 := CompareText(nIndex, Strings[nHigh]);
          if n20 > 0 then begin
            InsertObject(nHigh + 1, nIndex, Item);
            break;
          end
          else begin
            if CompareText(nIndex, Strings[nHigh]) = 0 then begin
              if boAdd then
                InsertObject(nHigh + 1, nIndex, Item);
              Result := True;
              break;
            end
            else begin
              n20 := CompareText(nIndex, Strings[nLow]);
              if n20 > 0 then begin
                InsertObject(nLow + 1, nIndex, Item);
                break;
              end
              else begin
                if n20 < 0 then begin
                  InsertObject(nLow, nIndex, Item);
                  break;
                end
                else begin
                  if boAdd then
                    InsertObject(nLow + 1, nIndex, Item);
                  Result := True;
                  break;
                end;
              end;
            end;
          end;
        end
        else begin
          n1C := CompareText(nIndex, Strings[nMed]);
          if n1C > 0 then begin
            nLow := nMed;
            nMed := (nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          if n1C < 0 then begin
            nHigh := nMed;
            nMed := (nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          if boAdd then
            InsertObject(nMed + 1, nIndex, Item);
          Result := True;
          break;
        end;
      end;
    end;
  end;
end;

function TQuickIntegerList.AddInteger(nIndex: Integer; boAdd: Boolean): Boolean;
var
  nLow, nHigh, nMed, n1C, n20: Integer;
begin
  Result := False;
  if Count = 0 then begin
    Add(Pointer(nIndex));
  end
  else begin
    if Count = 1 then begin
      nMed := Integer(Items[0]) - nIndex;
      if nMed > 0 then begin
        Add(Pointer(nIndex));
      end
      else begin
        if nMed < 0 then begin
          Insert(0, Pointer(nIndex));
        end
        else begin
          if boAdd then
            Add(Pointer(nIndex));
          Result := True;
        end;
      end;
    end
    else begin
      nLow := 0;
      nHigh := Count - 1;
      nMed := (nHigh - nLow) div 2 + nLow;
      while (true) do begin
        if (nHigh - nLow) = 1 then begin
          n20 := Integer(Items[nHigh]) - nIndex;
          if n20 > 0 then begin
            Insert(nHigh + 1, Pointer(nIndex));
            break;
          end
          else begin
            if (Integer(Items[nHigh]) - nIndex) = 0 then begin
              if boAdd then
                Insert(nHigh + 1, Pointer(nIndex));
              Result := True;
              break;
            end
            else begin
              n20 := Integer(Items[nLow]) - nIndex;
              if n20 > 0 then begin
                Insert(nLow + 1, Pointer(nIndex));
                break;
              end
              else begin
                if n20 < 0 then begin
                  Insert(nLow, Pointer(nIndex));
                  break;
                end
                else begin
                  if boAdd then
                    Insert(nLow + 1, Pointer(nIndex));
                  Result := True;
                  break;
                end;
              end;
            end;
          end;
        end
        else begin
          n1C := Integer(Items[nMed]) - nIndex;
          if n1C > 0 then begin
            nLow := nMed;
            nMed := (nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          if n1C < 0 then begin
            nHigh := nMed;
            nMed := (nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          if boAdd then
            Insert(nMed + 1, Pointer(nIndex));
          Result := True;
          break;
        end;
      end;
    end;
  end;
end;

procedure TQuickIDList.AddRecord(sAccount, sChrName: string; nIndex, nSelIndex:
  Integer);

var
  QuickID: pTQuickID;
  ChrList: TList;
  nLow, nHigh, nMed, n1C, n20: Integer;
begin
  New(QuickID);
  QuickID.sAccount := sAccount;
  QuickID.sChrName := sChrName;
  QuickID.nIndex := nIndex;
  QuickID.nSelectID := nSelIndex;
  if Count = 0 then begin
    ChrList := TList.Create;
    ChrList.Add(QuickID);
    AddObject(sAccount, ChrList);
  end
  else begin
    if Count = 1 then begin
      nMed := CompareText(sAccount, Self.Strings[0]);
      if nMed > 0 then begin
        ChrList := TList.Create;
        ChrList.Add(QuickID);
        AddObject(sAccount, ChrList);
      end
      else begin
        if nMed < 0 then begin
          ChrList := TList.Create;
          ChrList.Add(QuickID);
          InsertObject(0, sAccount, ChrList);
        end
        else begin
          ChrList := TList(Self.Objects[0]);
          ChrList.Add(QuickID);
        end;
      end;
    end
    else begin
      nLow := 0;
      nHigh := Self.Count - 1;
      nMed := (nHigh - nLow) div 2 + nLow;
      while (true) do begin
        if (nHigh - nLow) = 1 then begin
          n20 := CompareText(sAccount, Self.Strings[nHigh]);
          if n20 > 0 then begin
            ChrList := TList.Create;
            ChrList.Add(QuickID);
            InsertObject(nHigh + 1, sAccount, ChrList);
            break;
          end
          else begin
            if CompareText(sAccount, Self.Strings[nHigh]) = 0 then begin
              ChrList := TList(Self.Objects[nHigh]);
              ChrList.Add(QuickID);
              break;
            end
            else begin
              n20 := CompareText(sAccount, Self.Strings[nLow]);
              if n20 > 0 then begin
                ChrList := TList.Create;
                ChrList.Add(QuickID);
                InsertObject(nLow + 1, sAccount, ChrList);
                break;
              end
              else begin
                if n20 < 0 then begin
                  ChrList := TList.Create;
                  ChrList.Add(QuickID);
                  InsertObject(nLow, sAccount, ChrList);
                  break;
                end
                else begin
                  ChrList := TList(Self.Objects[n20]);
                  ChrList.Add(QuickID);
                  break;
                end;
              end;
            end;
          end;

        end
        else begin
          n1C := CompareText(sAccount, Self.Strings[nMed]);
          if n1C > 0 then begin
            nLow := nMed;
            nMed := (nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          if n1C < 0 then begin
            nHigh := nMed;
            nMed := (nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          ChrList := TList(Self.Objects[nMed]);
          ChrList.Add(QuickID);
          break;
        end;
      end;
    end;
  end;
end;

function TQuickList.DelRecordEx(sChrName: string): Boolean;
var
  i: integer;
begin
  Result := False;
  Lock;
  try
    I := Self.IndexOf(sChrName);
    if I > -1 then begin
      Self.Delete(I);
      Result := True;
    end;
  finally
    UnLock;
  end;
end;

function TQuickList.DelRecord(nIndex: Integer; sChrName: string): Boolean;

var
  i: integer;
begin
  Result := False;
  Lock;
  try
    I := Self.IndexOf(sChrName);
    if (nIndex = Integer(Self.Objects[I])) then begin
      Self.Delete(I);
      Result := True;
    end;

  finally
    UnLock;
  end;
end;

destructor TQuickIDList.Destroy;
var
  QuickID: pTQuickID;
  ChrList: TList;
  i, II: integer;
begin
  for i := 0 to Count - 1 do begin
    ChrList := TList(Objects[i]);
    for II := 0 to ChrList.Count - 1 do begin
      QuickID := ChrList.Items[II];
      Dispose(QuickID);
    end;
    ChrList.Free;
  end;
  inherited;
end;

procedure TQuickIDList.DelRecordEx(nIndex: Integer);
var
  QuickID: pTQuickID;
  ChrList: TList;
  i: integer;
begin
  if (Self.Count - 1) < nIndex then
    exit;
  ChrList := TList(Self.Objects[nIndex]);
  for i := 0 to ChrList.Count - 1 do begin
    QuickID := ChrList.Items[i];
    Dispose(QuickID);
  end;
  ChrList.Free;
  Self.Delete(nIndex);
end;

procedure TQuickIDList.DelRecord(nIndex: Integer; sChrName: string);

var
  QuickID: pTQuickID;
  ChrList: TList;
  i: integer;
begin
  if (Self.Count - 1) < nIndex then
    exit;
  ChrList := TList(Self.Objects[nIndex]);
  for i := 0 to ChrList.Count - 1 do begin
    QuickID := ChrList.Items[i];
    if QuickID.sChrName = sChrName then begin
      Dispose(QuickID);
      ChrList.Delete(i);
      break;
    end;
  end;
  if ChrList.Count <= 0 then begin
    ChrList.Free;
    Self.Delete(nIndex);
  end;
end;

function TQuickIDList.GetChrList(sAccount: string; var ChrNameList: TList): Integer;

var
  nHigh, nLow, nMed, n20, n24: Integer;
begin
  Result := -1;
  if Self.Count = 0 then
    exit;
  if Self.Count = 1 then begin
    if CompareText(sAccount, Self.Strings[0]) = 0 then begin
      ChrNameList := TList(Self.Objects[0]);
      Result := 0;
    end;
  end
  else begin
    nLow := 0;
    nHigh := Self.Count - 1;
    nMed := (nHigh - nLow) div 2 + nLow;
    n24 := -1;
    while (True) do begin
      if (nHigh - nLow) = 1 then begin
        if CompareText(sAccount, Self.Strings[nHigh]) = 0 then
          n24 := nHigh;
        if CompareText(sAccount, Self.Strings[nLow]) = 0 then
          n24 := nLow;
        break;
      end
      else begin
        n20 := CompareText(sAccount, Self.Strings[nMed]);
        if n20 > 0 then begin
          nLow := nMed;
          nMed := (nHigh - nLow) div 2 + nLow;
          Continue;
        end;
        if n20 < 0 then begin
          nHigh := nMed;
          nMed := (nHigh - nLow) div 2 + nLow;
          Continue;
        end;
        n24 := nMed;
        break;
      end;
    end;
    if n24 <> -1 then
      ChrNameList := TList(Self.Objects[n24]);
    Result := n24;
  end;
end;

function TQuickList.GetIndex(sName: string): Integer;

var
  nLow, nHigh, nMed, nCompareVal: Integer;

begin
  Result := -1;
  if Self.Count <> 0 then begin
    if Self.Sorted then begin
      if Self.Count = 1 then begin
        if CompareText(sName, Self.Strings[0]) = 0 then
          Result := 0;
      end
      else begin
        nLow := 0;
        nHigh := Self.Count - 1;
        nMed := (nHigh - nLow) div 2 + nLow;
        while (true) do begin
          if (nHigh - nLow) = 1 then begin
            if CompareText(sName, Self.Strings[nHigh]) = 0 then
              Result := nHigh;
            if CompareText(sName, Self.Strings[nLow]) = 0 then
              Result := nLow;
            break;
          end
          else begin
            ;
            nCompareVal := CompareText(sName, Self.Strings[nMed]);
            if nCompareVal > 0 then begin
              nLow := nMed;
              nMed := (nHigh - nLow) div 2 + nLow;
              Continue;
            end;
            if nCompareVal < 0 then begin
              nHigh := nMed;
              nMed := (nHigh - nLow) div 2 + nLow;
              Continue;
            end;
            Result := nMed;
            break;
          end;
        end;
      end;
    end
    else begin
      if Self.Count = 1 then begin
        if CompareText(sName, Self.Strings[0]) = 0 then
          Result := 0;
      end
      else begin

        nLow := 0;
        nHigh := Self.Count - 1;
        nMed := (nHigh - nLow) div 2 + nLow;
        while (true) do begin
          if (nHigh - nLow) = 1 then begin
            if CompareText(sName, Self.Strings[nHigh]) = 0 then
              Result := nHigh;
            if CompareText(sName, Self.Strings[nLow]) = 0 then
              Result := nLow;
            break;
          end
          else begin
            nCompareVal := CompareText(sName, Self.Strings[nMed]);
            if nCompareVal > 0 then begin
              nLow := nMed;
              nMed := (nHigh - nLow) div 2 + nLow;
              Continue;
            end;
            if nCompareVal < 0 then begin
              nHigh := nMed;
              nMed := (nHigh - nLow) div 2 + nLow;
              Continue;
            end;
            Result := nMed;
            break;
          end;
        end;
      end;
    end;
  end;

end;

procedure TQuickList.SortString(nMin, nMax: Integer);

var
  ntMin, ntMax: Integer;
  s18: string;
begin
  if Self.Count > 0 then
    while (True) do begin
      ntMin := nMin;
      ntMax := nMax;
      s18 := Self.Strings[(nMin + nMax) shr 1];
      while (True) do begin
        while (CompareText(Self.Strings[ntMin], s18) < 0) do
          Inc(ntMin);
        while (CompareText(Self.Strings[ntMax], s18) > 0) do
          Dec(ntMax);
        if ntMin <= ntMax then begin
          Self.Exchange(ntMin, ntMax);
          Inc(ntMin);
          Dec(ntMax);
        end;
        if ntMin > ntMax then
          break
      end;
      if nMin < ntMax then
        SortString(nMin, ntMax);
      nMin := ntMin;
      if ntMin >= nMax then
        break;
    end;
end;

function TQuickList.AddRecord(sName: string; nIndex: Integer): Boolean;

var
  nLow, nHigh, nMed, nCompareVal: Integer;
begin
  Result := True;
  if Self.Count = 0 then begin
    Self.AddObject(sName, TObject(nIndex));
  end
  else begin
    if Self.Sorted then begin
      if Self.Count = 1 then begin
        nMed := CompareText(sName, Self.Strings[0]);
        if nMed > 0 then
          Self.AddObject(sName, TObject(nIndex))
        else begin
          if nMed < 0 then
            Self.InsertObject(0, sName, TObject(nIndex));
        end;
      end
      else begin
        nLow := 0;
        nHigh := Self.Count - 1;
        nMed := (nHigh - nLow) div 2 + nLow;
        while (true) do begin
          if (nHigh - nLow) = 1 then begin
            nMed := CompareText(sName, Self.Strings[nHigh]);
            if nMed > 0 then begin
              Self.InsertObject(nHigh + 1, sName, TObject(nIndex));
              break;
            end
            else begin
              nMed := CompareText(sName, Self.Strings[nLow]);
              if nMed > 0 then begin
                Self.InsertObject(nLow + 1, sName, TObject(nIndex));
                break;
              end
              else begin
                if nMed < 0 then begin
                  Self.InsertObject(nLow, sName, TObject(nIndex));
                  break;
                  ;
                end
                else begin
                  Result := False;
                  break;
                end;
              end;
            end;
          end
          else begin
            nCompareVal := CompareText(sName, Self.Strings[nMed]);
            if nCompareVal > 0 then begin
              nLow := nMed;
              nMed := (nHigh - nLow) div 2 + nLow;
              Continue;
            end;
            if nCompareVal < 0 then begin
              nHigh := nMed;
              nMed := (nHigh - nLow) div 2 + nLow;
              Continue;
            end;
            Result := False;
            break;
          end;
        end;
      end;
    end
    else begin
      if Self.Count = 1 then begin
        nMed := CompareText(sName, Self.Strings[0]);
        if nMed > 0 then
          Self.AddObject(sName, TObject(nIndex))
        else begin
          if nMed < 0 then
            Self.InsertObject(0, sName, TObject(nIndex));
        end;
      end
      else begin
        nLow := 0;
        nHigh := Self.Count - 1;
        nMed := (nHigh - nLow) div 2 + nLow;
        while (true) do begin
          if (nHigh - nLow) = 1 then begin
            nMed := CompareText(sName, Self.Strings[nHigh]);
            if nMed > 0 then begin
              Self.InsertObject(nHigh + 1, sName, TObject(nIndex));
              break;
            end
            else begin
              nMed := CompareText(sName, Self.Strings[nLow]);
              if nMed > 0 then begin
                Self.InsertObject(nLow + 1, sName, TObject(nIndex));
                break;
              end
              else begin
                if nMed < 0 then begin
                  Self.InsertObject(nLow, sName, TObject(nIndex));
                  break;
                end
                else begin
                  Result := False;
                  break;
                end;
              end;
            end;
          end
          else begin
            nCompareVal := CompareText(sName, Self.Strings[nMed]);
            if nCompareVal > 0 then begin
              nLow := nMed;
              nMed := (nHigh - nLow) div 2 + nLow;
              Continue;
            end;
            if nCompareVal < 0 then begin
              nHigh := nMed;
              nMed := (nHigh - nLow) div 2 + nLow;
              Continue;
            end;
            Result := False;
            break;
          end;
        end;
      end;
    end;
  end;
end;

function TQuickList.GetCaseSensitive: Boolean;
begin
  result := CaseSensitive;
end;

procedure TQuickList.SetCaseSensitive(const Value: Boolean);
begin
  CaseSensitive := Value;
end;

procedure TQuickList.Lock;
begin
  EnterCriticalSection(CriticalSection);
end;

procedure TQuickList.UnLock;
begin
  LeaveCriticalSection(CriticalSection);
end;

constructor TQuickList.Create;
begin
  inherited;
  InitializeCriticalSection(CriticalSection);
end;

destructor TQuickList.Destroy;
begin
  DeleteCriticalSection(CriticalSection);
  inherited;
end;

{ TQuickIndexList }

procedure TQuickIndexList.AddRecord(sChrName, sDelChrName: string; nIndex: Integer);
var
  ChrList: TStringList;
  nLow, nHigh, nMed, n1C, n20: Integer;
begin
  if Count = 0 then begin
    ChrList := TStringList.Create;
    ChrList.AddObject(sDelChrName, TObject(nIndex));
    AddObject(sChrName, ChrList);
  end
  else begin
    if Count = 1 then begin
      nMed := CompareText(sChrName, Self.Strings[0]);
      if nMed > 0 then begin
        ChrList := TStringList.Create;
        ChrList.AddObject(sDelChrName, TObject(nIndex));
        AddObject(sChrName, ChrList);
      end
      else begin
        if nMed < 0 then begin
          ChrList := TStringList.Create;
          ChrList.AddObject(sDelChrName, TObject(nIndex));
          InsertObject(0, sChrName, ChrList);
        end
        else begin
          ChrList := TStringList(Self.Objects[0]);
          ChrList.AddObject(sDelChrName, TObject(nIndex));
        end;
      end;
    end
    else begin
      nLow := 0;
      nHigh := Self.Count - 1;
      nMed := (nHigh - nLow) div 2 + nLow;
      while (true) do begin
        if (nHigh - nLow) = 1 then begin
          n20 := CompareText(sChrName, Self.Strings[nHigh]);
          if n20 > 0 then begin
            ChrList := TStringList.Create;
            ChrList.AddObject(sDelChrName, TObject(nIndex));
            InsertObject(nHigh + 1, sChrName, ChrList);
            break;
          end
          else begin
            if CompareText(sChrName, Self.Strings[nHigh]) = 0 then begin
              ChrList := TStringList(Self.Objects[nHigh]);
              ChrList.AddObject(sDelChrName, TObject(nIndex));
              break;
            end
            else begin
              n20 := CompareText(sChrName, Self.Strings[nLow]);
              if n20 > 0 then begin
                ChrList := TStringList.Create;
                ChrList.AddObject(sDelChrName, TObject(nIndex));
                InsertObject(nLow + 1, sChrName, ChrList);
                break;
              end
              else begin
                if n20 < 0 then begin
                  ChrList := TStringList.Create;
                  ChrList.AddObject(sDelChrName, TObject(nIndex));
                  InsertObject(nLow, sChrName, ChrList);
                  break;
                end
                else begin
                  ChrList := TStringList(Self.Objects[n20]);
                  ChrList.AddObject(sDelChrName, TObject(nIndex));
                  break;
                end;
              end;
            end;
          end;

        end
        else begin
          n1C := CompareText(sChrName, Self.Strings[nMed]);
          if n1C > 0 then begin
            nLow := nMed;
            nMed := (nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          if n1C < 0 then begin
            nHigh := nMed;
            nMed := (nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          ChrList := TStringList(Self.Objects[nMed]);
          ChrList.AddObject(sDelChrName, TObject(nIndex));
          break;
        end;
      end;
    end;
  end;
end;

procedure TQuickIndexList.DelRecord(nIndex: Integer);
begin
  if (Self.Count - 1) < nIndex then
    exit;
  TStringList(Self.Objects[nIndex]).Free;
  ;
  Self.Delete(nIndex);
end;

destructor TQuickIndexList.Destroy;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    TStringList(Objects[i]).Free;
  inherited;
end;

function TQuickIndexList.GetIndex(sChrName: string): Integer;
var
  nHigh, nLow, nMed, n20, n24: Integer;
begin
  Result := -1;
  if Self.Count = 0 then
    exit;
  if Self.Count = 1 then begin
    if CompareText(sChrName, Self.Strings[0]) = 0 then begin
      Result := 0;
    end;
  end
  else begin
    nLow := 0;
    nHigh := Self.Count - 1;
    nMed := (nHigh - nLow) div 2 + nLow;
    n24 := -1;
    while (True) do begin
      if (nHigh - nLow) = 1 then begin
        if CompareText(sChrName, Self.Strings[nHigh]) = 0 then
          n24 := nHigh;
        if CompareText(sChrName, Self.Strings[nLow]) = 0 then
          n24 := nLow;
        break;
      end
      else begin
        n20 := CompareText(sChrName, Self.Strings[nMed]);
        if n20 > 0 then begin
          nLow := nMed;
          nMed := (nHigh - nLow) div 2 + nLow;
          Continue;
        end;
        if n20 < 0 then begin
          nHigh := nMed;
          nMed := (nHigh - nLow) div 2 + nLow;
          Continue;
        end;
        n24 := nMed;
        break;
      end;
    end;
    Result := n24;
  end;
end;

procedure TQuickIndexList.LoadFromFile(const FileName: string);
var
  TempList: TStringList;
  I: Integer;
  str, sChrName, sDelName, sDelID: string;
  nDelID: Integer;
begin
  TempList := TStringList.Create;
  try
    if FileExists(FileName) then begin
      TempList.LoadFromFile(FileName);
      for I := 0 to TempList.Count - 1 do begin
        str := TempList[i];
        if (str <> '') and (str[1] <> ';') then begin
          str := GetValidStr3(str, sChrName, [#9, ' ']);
          str := GetValidStr3(str, sDelName, [#9, ' ']);
          str := GetValidStr3(str, sDelID, [#9, ' ']);
          nDelID := StrToIntDef(sDelID, -1);
          if nDelID > 0 then begin
            AddRecord(sChrName, sDelName, nDelID);
          end;
        end;
      end;
    end;
  finally
    TempList.Free;
  end;
end;

procedure TQuickIndexList.SaveToFile(const FileName: string);
var
  TempList, ChrList: TStringList;
  I, II: Integer;
begin
  TempList := TStringList.Create;
  try
    for I := 0 to Count - 1 do begin
      ChrList := TStringList(Self.Objects[i]);
      for II := 0 to ChrList.Count - 1 do begin
        TempList.Add(Strings[i] + #9 + ChrList[II] + #9 + IntToStr(Integer(ChrList.Objects[II])));
      end;
    end;
    TempList.SaveToFile(FileName);
  finally
    TempList.Free;
  end;
end;

{ TQuickStringPointerList }

procedure TQuickStringPointerList.AddString(nIndex: string; Item: Pointer);
var
  nLow, nHigh, nMed, n1C, n20: Integer;
begin
  if Count = 0 then begin
    AddObject(nIndex, TObject(Item));
  end
  else begin
    if Count = 1 then begin
      nMed := CompareText(Strings[0], nIndex);
      if nMed < 0 then begin
        AddObject(nIndex, TObject(Item));
      end
      else begin
        if nMed > 0 then begin
          InsertObject(0, nIndex, TObject(Item));
        end
        else begin
          AddObject(nIndex, TObject(Item));
        end;
      end;
    end
    else begin
      nLow := 0;
      nHigh := Count - 1;
      nMed := (nHigh - nLow) div 2 + nLow;
      while (true) do begin
        if (nHigh - nLow) = 1 then begin
          n20 := CompareText(Strings[nHigh], nIndex);
          if n20 < 0 then begin
            InsertObject(nHigh + 1, nIndex, TObject(Item));
            break;
          end
          else begin
            if CompareText(Strings[nHigh], nIndex) = 0 then begin
              InsertObject(nHigh + 1, nIndex, TObject(Item));
              break;
            end
            else begin
              n20 := CompareText(Strings[nLow], nIndex);
              if n20 < 0 then begin
                InsertObject(nLow + 1, nIndex, TObject(Item));
                break;
              end
              else begin
                if n20 > 0 then begin
                  InsertObject(nLow, nIndex, TObject(Item));
                  break;
                end
                else begin
                  InsertObject(nLow + 1, nIndex, TObject(Item));
                  break;
                end;
              end;
            end;
          end;
        end
        else begin
          n1C := CompareText(Strings[nMed], nIndex);
          if n1C < 0 then begin
            nLow := nMed;
            nMed := (nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          if n1C > 0 then begin
            nHigh := nMed;
            nMed := (nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          InsertObject(nMed + 1, nIndex, TObject(Item));
          break;
        end;
      end;
    end;
  end;
  {if Count = 0 then begin
    AddObject(nIndex, TObject(Item));
  end
  else begin
    if Count = 1 then begin
      nMed := CompareText(nIndex, Strings[0]);
      if nMed < 0 then begin
        AddObject(nIndex, TObject(Item));
      end
      else begin
        if nMed > 0 then begin
          InsertObject(0, nIndex, TObject(Item));
        end
        else begin
          AddObject(nIndex, TObject(Item));
        end;
      end;
    end
    else begin
      nLow := 0;
      nHigh := Count - 1;
      nMed := (nHigh - nLow) div 2 + nLow;
      while (true) do begin
        if (nHigh - nLow) = 1 then begin
          n20 := CompareText(nIndex, Strings[nHigh]);
          if n20 < 0 then begin
            InsertObject(nHigh + 1, nIndex, TObject(Item));
            break;
          end
          else begin
            if CompareText(nIndex, Strings[nHigh]) = 0 then begin
              InsertObject(nHigh + 1, nIndex, TObject(Item));
              break;
            end
            else begin
              n20 := CompareText(nIndex, Strings[nLow]);
              if n20 < 0 then begin
                InsertObject(nLow + 1, nIndex, TObject(Item));
                break;
              end
              else begin
                if n20 > 0 then begin
                  InsertObject(nLow, nIndex, TObject(Item));
                  break;
                end
                else begin
                  InsertObject(nLow + 1, nIndex, TObject(Item));
                  break;
                end;
              end;
            end;
          end;
        end
        else begin
          n1C := CompareText(nIndex, Strings[nMed]);
          if n1C < 0 then begin
            nLow := nMed;
            nMed := (nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          if n1C > 0 then begin
            nHigh := nMed;
            nMed := (nHigh - nLow) div 2 + nLow;
            Continue;
          end;
          InsertObject(nMed + 1, nIndex, TObject(Item));
          break;
        end;
      end;
    end;
  end;  }
end;

procedure TQuickStringPointerList.SortString(nMin, nMax: Integer);
var
  ntMin, ntMax: Integer;
  s18: string;
begin
  if Self.Count > 0 then
    while (True) do begin
      ntMin := nMin;
      ntMax := nMax;
      s18 := Self.Strings[(nMin + nMax) shr 1];
      while (True) do begin
        while (CompareText(Self.Strings[ntMin], s18) < 0) do
          Inc(ntMin);
        while (CompareText(Self.Strings[ntMax], s18) > 0) do
          Dec(ntMax);
        if ntMin <= ntMax then begin
          Self.Exchange(ntMin, ntMax);
          Inc(ntMin);
          Dec(ntMax);
        end;
        if ntMin > ntMax then
          break
      end;
      if nMin < ntMax then
        SortString(nMin, ntMax);
      nMin := ntMin;
      if ntMin >= nMax then
        break;
    end;
end;

end.

