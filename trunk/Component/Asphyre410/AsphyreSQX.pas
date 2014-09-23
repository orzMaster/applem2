unit AsphyreSQX;
//---------------------------------------------------------------------------
// AsphyreSQX.pas                                       Modified: 15-Jan-2007
// SQX Archive Interface                                          Version 1.0
//---------------------------------------------------------------------------
// The following code was written based on the existing SQX SDK 2.02
// documentation dated 20-Apr-2006 and some constants have been taken fron
// the headers generously provided by Do-wan Kim.
//
// The interfaced 'sqx20.dll' is developed by Sven Ritter as part of SQX
// Archiver. The full SQX-SDK can be downloaded from:
//     http://www.sqx-archiver.org/
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
// The Original Code is AsphyreSQX.pas.
//
// The Initial Developer of the Original Code is M. Sc. Yuriy Kotsarenko.
// Portions created by M. Sc. Yuriy Kotsarenko are Copyright (C) 2007,
// Afterwarp Interactive. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
uses
 Windows;

//---------------------------------------------------------------------------
const
 // The path and full name of SQX DLL. Can be modified to be loaded from a
 // specific folder relative to current path.
 SQX_DLL_NAME = 'sqx20.dll';

//---------------------------------------------------------------------------
// The possible values returned by SQX callback mechanism.
//---------------------------------------------------------------------------
 SQX_PROGRESS_CANCEL   = 0; // The current operation will be cancelled.
 SQX_PROGRESS_OK		   = 1; // Going on with the current operation.

 SQX_REPLACE_OVERWRITE = 0; // The specified file will be overwritten.
 SQX_REPLACE_SKIP      = 1; // The specified file will not be overwritten.
 SQX_REPLACE_CANCEL    = 2; // The current operation will be cancelled.

 SQX_PASSWORD_CANCEL   = 0; // The current operation will be cancelled.
 SQX_PASSWORD_OK       = 1; // Going on with the new password.

 SQX_SKIPFILE_SKIP     = 1; // The specified file will be skipped.
 SQX_SKIPFILE_CANCEL   = 2; // The current operation will be cancelled.

 SQX_NEXTDISK_CANCEL   = 0; // The current operation will be cancelled.
 SQX_NEXTDISK_OK       = 1; // Going on with the new folder to the next volume.

//---------------------------------------------------------------------------
// Values specifying the type of a callback.
//---------------------------------------------------------------------------
 SQX_CALLBACK_FILENAME        = 0; // SQX archiver is about to compress, extract, delete or test a file.
 SQX_CALLBACK_PROGRESS        = 1; // SQX archiver signals the progress of a file beeing compressed, extracted or tested.
 SQX_CALLBACK_REPLACE         = 2; // SQX archiver is about to overwrite either a file on disk (when extracting) or a file in the archive (when compressing).
 SQX_CALLBACK_PASSWORD        = 3; // SQX archiver needs a password to decrypt a file.
 SQX_CALLBACK_PASSWORD_HEADER = 4; // SQX archiver needs a password to decrypt the archive directory.
 SQX_CALLBACK_SKIP            = 5; // SQX archiver cannot open a file because it is locked by another application.
 SQX_CALLBACK_NEXTDISK        = 6; // SQX archiver needs the next volume when extracting or a new disk when compressing.
 SQX_CALLBACK_SIGNAL          = 7; // SQX archiver signals the next command.

//---------------------------------------------------------------------------
// The possible error codes returned by SQX functions.
//---------------------------------------------------------------------------
 SQX_ERR_SUCCESS                       = 0;  // No error.
 SQX_ERR_ERROR                         = 1;  // Unknown error in the last archive operation.
 SQX_ERR_FILE_NOT_FOUND                = 2;  // The system cannot find the file specified.
 SQX_ERR_PATH_NOT_FOUND	               = 3;  // The system cannot find the path specified.
 SQX_ERR_TOO_MANY_FILES                = 4;  // The system cannot open the file.
 SQX_ERR_ACCESS_DENIED                 = 5;  // Access is denied.
 SQX_ERR_INVALID_HANDLE                = 6;  // The file handle is invalid.
 SQX_ERR_DISK_FULL                     = 7;  // The disk is full.
 SQX_ERR_OUT_OF_MEMORY                 = 8;  // Not enough memory is available to complete this operation.
 SQX_ERR_CANT_ACCESS_TEMP_DIR          = 9;  // Cannot access temp folder during a delete or update operation on a solid archive.
 SQX_ERR_TEMP_DIR_FULL                 = 10; // Not enough space on drive for the temporary folder.
 SQX_ERR_USER_ABORT                    = 11; // Cancelled by user.
 SQX_ERR_INVALID_ARC_HANDLE            = 12; // Invalid archive handle.
 SQX_ERR_CANT_FIND_LANG_DATA           = 13; // Could not find the selected language file for self-extracting archives.
 SQX_ERR_UNKNOWN_SUBSTREAM             = 14; // The archive contains at least one unknown alternate data stream.
 SQX_ERR_BAD_SUBSTREAM_CRC             = 15; // Bad alternate stream CRC. Archive is probably corrupted.
 SQX_ERR_UNKNOWN_METHOD                = 16; // This method of compression is not supported by the archiver.
 SQX_ERR_FILE_ENCRYPTED                = 17; // Archive is encrypted with a password.
 SQX_ERR_BAD_CRC                       = 18; // Bad CRC. Archive is probably corrupted.
 SQX_ERR_CANT_CREATE_FILE              = 19; // Could not create file or folder.
 SQX_ERR_BAD_FILE_FORMAT               = 20; // Bad archive file format.
 SQX_ERR_FUNCTION_NOT_SUPPORTED        = 21; // Function is not supported.
 SQX_ERR_FUNC_NOT_SUPPORTED_BY_ARCHIVE = 22; // Function is not supported for this archive type.
 SQX_ERR_CANT_CREATE_ARC_DIR           = 23; // Could not create folder in archive. It already exists a folder with this name.
 SQX_ERR_INVALID_DIR_NAME	             = 24; // Could not create folder in archive. The folder name contains invalid characters.
 SQX_ERR_INVALID_FILE_NAME             = 25; // Could not create file in archive. The file name contains invalid characters.
 SQX_ERR_TOO_MANY_BROKEN_FBLOCKS       = 26; // The archive file contains too many damaged file blocks and cannot be repaired.
 SQX_ERR_ARCHIVE_OK_RDATA_NOT          = 27; // It seems that the archive has no errors, but the recovery data does not match the archive. Maybe this archive was edited by a program that could not identify the recovery data.
 SQX_ERR_RDATA_DAMAGED                 = 28; // The recovery data of the archive file is damaged, too. This archive file cannot be repaired.
 SQX_ERR_RDATA_NEW_VERSION             = 29; // The archive contains recovery data that cannot be used with this version of our software. The newest versions of our software are always available at http://www.speedproject.de/.
 SQX_ERR_RDATA_DOES_NOT_MATCH          = 30; // The recovery data does not match the archive. It seems that this archive was edited by a program that could not identify the recovery data.
 SQX_ERR_CANT_FIND_RDATA               = 31; // It seems that the archive does not contain any recovery data.
 SQX_ERR_ARCHIVE_IS_LOCKED             = 32; // Cannot modify locked archive.
 SQX_ERR_CANT_ADD_TO_MV                = 33; // It is not possible to add files to a multi-volume archive.
 SQX_ERR_CANT_DELETE_FROM_MV           = 34; // It is not possible to delete files from a multi-volume archive.
 SQX_ERR_NEED_1ST_VOLUME               = 35; // This file is part of a multi-volume archive. The first volume of the archive is needed to open it. Please select the first volume to open the archive.
 SQX_ERR_MISSING_VOLUME	               = 36; // The last volume of the archive could not be found.
 SQX_ERR_VOLUME_LIMIT_REACHED          = 37; // Cannot create more than 999 volumes.
 SQX_ERR_SFXSTUB_NOT_INSTALLED         = 38; // This system lacks the support for the SFX type you have selected. Please visit the download section of http://ww.speedproject.de/ to obtain complete support for SFX archives.
 SQX_ERR_BACKUP_READ_ACCESS_DENIED     = 39; // Read access to alternate data stream was denied. Only the file itself is being compressed.
 SQX_ERR_BACKUP_WRITE_ACCESS_DENIED    = 40; // Could not write alternate data stream (e.g. file comments).
 SQX_ERR_ACL_READ_ACCESS_DENIED        = 41; // Could not read security attributes. Only the file itself is being compressed.
 SQX_ERR_ACL_WRITE_ACCESS_DENIED       = 42; // Could not write security attributes.
 SQX_ERR_WRONG_ARCHIVER_VERSION        = 43; // This archive contains data created with a higher version of this software. Please download the lastest update of the software from http://www.speedproject.de/.
 SQX_ERR_CANT_COPY_SOURCE_TO_SOURCE    = 44; // Cannot copy an archive to itself. Please choose a different target name.
 SQX_ERR_VOLUMES_TOO_SMALL             = 45; // The volume size cannot be smaller than 130 kByte.
 SQX_ERR_ARCHIVE_VERSION_TOO_HIGH      = 46; // This archive can only be extracted. It is not possible to add files.
 SQX_ERR_EXT_RDATA_DOES_NOT_MATCH      = 47; // The external recovery data don't seem to belong to the selected archive.
 SQX_ERR_BAD_PARAMETER                 = 48; // The parameter is incorrect.
 SQX_ERR_EQUAL_PASSWORDS               = 49; // The passwords for the archive files and archive directory are identical. Please enter different passwords.
 SQX_ERR_REQUIRES_ENCRYPTION           = 50; // You cannot encrypt the archive directory without encrypting the files. Please enter one password for the archive directory and another password for the files.
 SQX_ERR_MISSING_HEADER_PASSWORD       = 51; // Please enter a password to encrypt the archive directory.
 SQX_ERR_MISSING_SQX_PRIVATE_KEY       = 52; // Could not find/access the private key required to encrypt the archive. Please make sure that the software can access all the keys in question.
 SQX_ERR_MISSING_SQX_AVKEY             = 53; // Could not find the key required to create a digital signature. Please make sure that the software can access the authentication key.
 SQX_ERR_MISSING_EXTERNAL_AVKEY        = 54; // Could not find/access the external key necessary to sign the archive. Please make sure that the software can access all keys in question.
 SQX_ERR_INVALID_SQX_AVKEY             = 55; // The key you have selected to create digital signatures is invalid.
 SQX_ERR_SQX_AVKEY_VERSION             = 56; // This version of the software cannot use the existing key to create digital signatures. Please download the lastest update of the software from http://www.speedproject.de/.
 SQX_ERR_SQX_AVDATA_VERSION            = 57; // This version of the software cannot process the digital signature embedded within the archive. Please download the lastest update of the software from http://www.speedproject.de/.
 SQX_ERR_SQX_BROKEN_AVRECORD           = 58; // The archive contains an invalid digital signature. The archive is either damaged or it has been manipulated.
 SQX_ERR_RIJNDAEL_RSA                  = 59; // Unexpected error in an encryption function. Please contact our product support.
 SQX_ERR_REQUIRES_NTFS                 = 60; // An option you selected requires NTFS.
 SQX_ERR_REQUIRES_WINNT                = 61; // An option you selected requires Windows NT.
 SQX_ERR_REQUIRES_W2K                  = 62; // An option you selected requires Windows 2000.
 SQX_ERR_REQUIRES_WINXP                = 63; // An option you selected requires Windows XP.
 SQX_ERR_REQUIRES_WINXP_SP1            = 64; // An option you selected requires Windows XP SP1.
 SQX_ERR_REQUIRES_WINXP_SP2            = 65; // An option you selected requires Windows XP SP2.
 SQX_ERR_REQUIRES_LONGHORN             = 66; // An option you selected requires Longhorn.
 SQX_ERR_NO_RESOURCES_FOUND            = 67; // The selected SFX stub does not contain resources. Can not modify SFX stub.
 SQX_ERR_UNKNOWN_ICON_FORMAT           = 68; // Could not determine the format of the selected icon file.
 SQX_ERR_NO_MATCHING_ICON_SIZE         = 69; // The selected SFX stub does not contain icons with valid sizes. Can not modify SFX stub.
 SQX_ERR_UNKNOWN_EXE_FORMAT            = 70; // The format of the selected SFX stub is unknown.
 SQX_ERR_REQUIRES_SOURCE_PATH          = 71; // The extended archive test requires the source path.
 SQX_ERR_FILE_DATA_NOT_EQUAL           = 72; // Extended archive test: The source on hard disk is different from the file in the archive.
 SQX_ERR_COMMENT_BIGGER_4K             = 73; // You cannot add to the archive comments longer than 4096 chars. Please shorten your comments and try again.
 SQX_ERR_CANT_CREATE_SFX_FROM_MV       = 74; // Cannot create a self-extracting archive from a multi-volume archive.

//---------------------------------------------------------------------------
type
 TSqxString = packed array[0..MAX_PATH - 1] of Char;

//---------------------------------------------------------------------------
 TSqxCallbackInfo = packed record
  CallbackType   : Longword;
  SourceFileName : PChar;
  TargetFileName : PChar;
  Progress       : Integer;
  FindDataExist  : PWin32FindData;
  FindDataReplace: PWin32FindData;
  CryptKey       : TSqxString;
  OldCryptKey    : TSqxString;
  CryptFileName  : TSqxString;
  TotalSize      : Longword;
  DiskNum        : Longword;
  NextDiskPath   : TSqxString;
  Signal         : Longword;
  BlockSize      : Int64;
 end;

//---------------------------------------------------------------------------
 TSqxCallback = function(Param: Pointer;
  var CallbackInfo: TSqxCallbackInfo): Integer; stdcall;

//---------------------------------------------------------------------------
 TSqxAvInfo = packed record
  AVInfoPresent: Boolean;
  AV_ID        : TSqxString;
  CreationTime : Int64;
end;

//---------------------------------------------------------------------------
 TSqxArcInfo = packed record
  Size             : Longword;
  FileFormat       : Longword;
  ArcerMajorVersion: Longword;
  ArcerMinorVersion: Longword;
  DictionarySize   : Longword;
  RecoveryData     : LongBool;
  Encryption       : Longword;
  Solid            : LongBool;
  HostOS           : Longword;
  TotalFiles       : Longword;
  CompressedSize   : Int64;
  UncompressedSize : Int64;
  Ratio            : Integer;
  HeaderEncrypted  : LongBool;
  IsMultiVolume    : LongBool;
  ArchiveComment   : LongBool;
  FileComments     : LongBool;
  AvInfo           : TSqxAvInfo;
end;

//---------------------------------------------------------------------------
 TSqxFileTime = packed record
  BlockPresent  : Boolean;
  CreationTime  : Int64;
  LastAccessTime: Int64;
  LastWriteTime : Int64;
end;

//---------------------------------------------------------------------------
 PSqxArcNode = ^TSqxArcNode;
 TSqxArcNode = packed record
  FileName      : PChar;
  FileNameLen   : Longword;
  ExtraName     : PChar;
  ExtraNameLen  : Longword;
  FileNameType  : Longword;
  Size          : Int64;
  SizeOrig      : Int64;
  DosFileTime   : Longword;
  Attributes    : Longword;
  ArcerVersion  : Longword;
  FileCRC       : Longword;
  HostOS        : Longword;
  Method        : Longword;
  CommentLen    : Longword;
  Comment       : PChar;
  Encrypted     : LongBool;
  Tagged        : LongBool;
  MappedMethod  : Longword;
  ExtendedError : Longword;
  FileTime      : TSqxFileTime;
end;

//---------------------------------------------------------------------------
 PSqxArcListNode = ^TSqxArcListNode;
 TSqxArcListNode = packed record
  Next   : PSqxArcListNode;
  ArcNode: PSqxArcNode;
 end;

//---------------------------------------------------------------------------
 PSqxArcList = ^TSqxArcList;
 TSqxArcList = packed record
  ItemCount: Longword;
  Head     : PSqxArcListNode;
  Tail     : PSqxArcListNode;
 end;

//---------------------------------------------------------------------------
 TSqxExtractOptions = packed record
  Size                      : Longword;
  Password                  : TSqxString;
  PasswordHeader            : TSqxString;
  TempDir                   : TSqxString;
  RelativePath              : TSqxString;
  OutputPath                : TSqxString;
  ResetArchiveAttribute     : LongBool;
  OverwriteAlways           : LongBool;
  KeepBrokenFiles           : LongBool;
  CreateFolders             : LongBool;
  RestoreACLs               : LongBool;
  RestoreStreams            : LongBool;
  RestoreUnicodeNames       : LongBool;
  RestoreWin32FileTimes     : LongBool;
  RestoreDirectoryTimeStamps: LongBool;
  AutoRestoreComments       : LongBool;
  SetZoneID                 : LongBool;
end;

//---------------------------------------------------------------------------
// Initializes an application's use of the SQX archiver functions and creates
// an archiver handle.
//---------------------------------------------------------------------------
function SqxInitArchive(ArchiveName: PChar; Callback: TSqxCallback;
 Param: Pointer; var Archive: THandle): Integer; stdcall;
 external SQX_DLL_NAME;

//---------------------------------------------------------------------------
// Closes a SQX archive handle.
//---------------------------------------------------------------------------
procedure SqxDoneArchive(Archive: THandle); stdcall; external SQX_DLL_NAME;

//---------------------------------------------------------------------------
// Creates a file list that is used to pass a list of file names to SQX
// archiver when creating, extracting or manipulating SQX archives.
//---------------------------------------------------------------------------
function SqxInitFileList(Archive: THandle): THandle; stdcall;
 external SQX_DLL_NAME;

//---------------------------------------------------------------------------
// Destroys a file list created with the SqxInitFileList function.
//---------------------------------------------------------------------------
procedure SqxDoneFileList(Archive: THandle; FileMaskList: THandle); stdcall;
 external SQX_DLL_NAME;

//---------------------------------------------------------------------------
// Adds a file name to a file list.
//---------------------------------------------------------------------------
procedure SqxAppendFileList(Archive: THandle; FileMaskList: THandle;
 FileName: PChar); stdcall; external SQX_DLL_NAME;

//---------------------------------------------------------------------------
// Creates a file list that is used to pass a list of file names and file
// properties to the caller when listing SQX archives with the SqxListFiles
// function.
//---------------------------------------------------------------------------
function SqxInitArcFileList(Archive: THandle): PSqxArcList; stdcall;
 external SQX_DLL_NAME;

//---------------------------------------------------------------------------
// Destroys a file list created with the SqxInitArcFileList function.
//---------------------------------------------------------------------------
procedure SqxDoneArcFileList(Archive: THandle; ArcFileList: PSqxArcList);
 stdcall; external SQX_DLL_NAME;

//---------------------------------------------------------------------------
// List the contents of an archive.
//---------------------------------------------------------------------------
function SqxListFiles(Archive: THandle; FileMaskList: THandle;
 ArcFileList: PSqxArcList; var ArchiveInfo: TSqxArcInfo): Integer; stdcall;
 external SQX_DLL_NAME;

//---------------------------------------------------------------------------
// Extracts one or more files from an archive.
//---------------------------------------------------------------------------
function SqxExtractFiles(Archive: THandle; Callback: TSqxCallback;
 Param: Pointer; FileMaskList: THandle;
 var ExtractOptions: TSqxExtractOptions): Integer; stdcall;
 external SQX_DLL_NAME;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
end.
