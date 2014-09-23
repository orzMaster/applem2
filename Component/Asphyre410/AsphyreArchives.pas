unit AsphyreArchives;

//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Classes, SysUtils, AsphyreAsserts, MediaUtils;

//---------------------------------------------------------------------------
type
 TAsphyreArchiveID = string[8];

//---------------------------------------------------------------------------
 TAsphyreArchiveAttribute = (aaNoExtractToMem);
 TAsphyreArchiveAttributes = set of TAsphyreArchiveAttribute;

//---------------------------------------------------------------------------
 TAsphyreCustomArchive = class
 private
  FArchiveName: string;
 protected
  FAttributes: TAsphyreArchiveAttributes;

  function GetItemCount(): Integer; virtual; abstract;
  function GetItemName(Num: Integer): string; virtual; abstract;
  function OpenArchive(const FileName: string): Boolean; virtual; abstract;
  procedure CloseArchive(); virtual; abstract;
  procedure DoCreate(); virtual; abstract;
 public
  property Attributes: TAsphyreArchiveAttributes read FAttributes;
  property ArchiveName: string read FArchiveName;

  property ItemCount: Integer read GetItemCount;
  property ItemName[Num: Integer]: string read GetItemName;

  function Open(const Name: string): Boolean;
  procedure Close();

  function ExtractToDisk(const ItemName,
   DestPath: string): Boolean; virtual; abstract;
  function ExtractToStream(const ItemName: string;
   Stream: TStream): Boolean; virtual; abstract;

  constructor Create(); 
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
 TAsphyreArchiver = class of TAsphyreCustomArchive;

//---------------------------------------------------------------------------
 TArchiveAssociation = record
  Extension: string;
  Archive  : TAsphyreCustomArchive;
 end;

//---------------------------------------------------------------------------
 TAsphyreArchiveManager = class
 private
  Archives: array of TAsphyreCustomArchive;
  Associations: array of TArchiveAssociation;

  function FindInstance(const Archiver: TAsphyreArchiver): Integer;
  function IncludeArchiver(const Archiver: TAsphyreArchiver): TAsphyreCustomArchive;
  function FindExtension(const Extension: string): Integer;
  procedure RemoveAssociation(AsIndex: Integer);
  procedure ReleaseArchives();
 public
  // Registers a new extension/archiver combination.
  function RegisterExt(const Extension: string;
   Archiver: TAsphyreArchiver): Boolean;

  // Unregisters the specified extension.
  procedure UnregisterExt(const Extension: string);

  // Finds the archive associated with the given extension.
  function AssociatedArchive(const Extension: string): TAsphyreCustomArchive;

  // Checks whether the archiver can only extract to disk.
  function ShouldUseDisk(const Link: string): Boolean;

  function ExtractToDisk(const Link, DestPath: string): Boolean;
  function ExtractToStream(const Link: string; Stream: TStream): Boolean;

  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
var
 ArchiveManager: TAsphyreArchiveManager = nil;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
constructor TAsphyreCustomArchive.Create();
begin
 inherited;

 DoCreate();
end;

//---------------------------------------------------------------------------
destructor TAsphyreCustomArchive.Destroy();
begin
 if (FArchiveName <> '') then
  begin
   CloseArchive();
   FArchiveName:= '';
  end;
 
 inherited;
end;

//---------------------------------------------------------------------------
function TAsphyreCustomArchive.Open(const Name: string): Boolean;
begin
 if (LowerCase(FArchiveName) <> LowerCase(Name)) then
  begin
   Result:= OpenArchive(Name);
   if (Result) then FArchiveName:= Name else FArchiveName:= '';
  end else Result:= True;
end;

//---------------------------------------------------------------------------
procedure TAsphyreCustomArchive.Close();
begin
 if (FArchiveName <> '') then CloseArchive();
 FArchiveName:= '';
end;

//---------------------------------------------------------------------------
destructor TAsphyreArchiveManager.Destroy();
begin
 ReleaseArchives();
 inherited;
end;

//---------------------------------------------------------------------------
procedure TAsphyreArchiveManager.ReleaseArchives();
var
 i: Integer;
begin
 for i:= 0 to Length(Archives) - 1 do
  if (Archives[i] <> nil) then
   begin
    Archives[i].Free();
    Archives[i]:= nil;
   end;

 SetLength(Archives, 0);  
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveManager.FindInstance(
 const Archiver: TAsphyreArchiver): Integer;
var
 i: Integer;
begin
 Result:= -1;

 for i:= 0 to Length(Archives) - 1 do
  if (Archives[i] is Archiver) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveManager.IncludeArchiver(
 const Archiver: TAsphyreArchiver): TAsphyreCustomArchive;
var
 Index: Integer;
begin
 Index:= FindInstance(Archiver);
 if (Index = -1) then
  begin
   Index:= Length(Archives);
   SetLength(Archives, Index + 1);

   Archives[Index]:= Archiver.Create();
  end;

 Result:= Archives[Index];
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveManager.FindExtension(const Extension: string): Integer;
var
 i: Integer;
begin
 Result:= -1;

 for i:= 0 to Length(Associations) - 1 do
  if (Associations[i].Extension = Extension) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveManager.RegisterExt(const Extension: string;
 Archiver: TAsphyreArchiver): Boolean;
var
 AsIndex: Integer;
begin
 AsIndex:= FindExtension(LowerCase(Extension));
 Result:= (AsIndex = -1);
 if (not Result) then Exit;

 AsIndex:= Length(Associations);
 SetLength(Associations, AsIndex + 1);
 Associations[AsIndex].Extension:= LowerCase(Extension);
 Associations[AsIndex].Archive  := IncludeArchiver(Archiver);
end;

//---------------------------------------------------------------------------
procedure TAsphyreArchiveManager.RemoveAssociation(AsIndex: Integer);
var
 i: Integer;
begin
 for i:= AsIndex to Length(Associations) - 2 do
  Associations[i]:= Associations[i + 1];

 SetLength(Associations, Length(Associations) - 1);
end;

//---------------------------------------------------------------------------
procedure TAsphyreArchiveManager.UnregisterExt(const Extension: string);
var
 AsIndex: Integer;
begin
 AsIndex:= FindExtension(LowerCase(Extension));
 if (AsIndex <> -1) then RemoveAssociation(AsIndex);
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveManager.AssociatedArchive(
 const Extension: string): TAsphyreCustomArchive;
var
 Index: Integer;
begin
 Result:= nil;

 Index:= FindExtension(LowerCase(Extension));
 if (Index <> -1) then Result:= Associations[Index].Archive;
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveManager.ShouldUseDisk(const Link: string): Boolean;
var
 Archive: TAsphyreCustomArchive;
begin
 Result:= True;

 Archive:= AssociatedArchive(ExtractFileExt(ExtractArchiveName(Link)));
 Assert(Archive <> nil, msgUnknownArchive);

 if (Archive <> nil) then
  Result:= aaNoExtractToMem in Archive.Attributes;
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveManager.ExtractToDisk(const Link,
 DestPath: string): Boolean;
var
 Archive: TAsphyreCustomArchive;
 ArchiveName: string;
begin
 Result:= False;

 ArchiveName:= ExtractArchiveName(Link);

 Archive:= AssociatedArchive(ExtractFileExt(ArchiveName));
 Assert(Archive <> nil, msgUnknownArchive);

 if (Archive <> nil) then
  begin
   Result:= Archive.OpenArchive(ArchiveName);

   if (Result) then
    Result:= Archive.ExtractToDisk(ExtractArchiveKey(Link), DestPath);
  end;
end;

//---------------------------------------------------------------------------
function TAsphyreArchiveManager.ExtractToStream(const Link: string;
 Stream: TStream): Boolean;
var
 Archive: TAsphyreCustomArchive;
 ArchiveName: string;
begin
 Result:= False;

 ArchiveName:= ExtractArchiveName(Link);

 Archive:= AssociatedArchive(ExtractFileExt(ArchiveName));
 Assert(Archive <> nil, msgUnknownArchive);

 if (Archive <> nil) then
  begin
   Result:= Archive.OpenArchive(ArchiveName);

   if (Result) then
    Result:= Archive.ExtractToStream(ExtractArchiveKey(Link), Stream);
  end;
end;

//---------------------------------------------------------------------------
initialization
 ArchiveManager:= TAsphyreArchiveManager.Create();

//---------------------------------------------------------------------------
finalization
 ArchiveManager.Free();
 ArchiveManager:= nil;

//---------------------------------------------------------------------------
end.
