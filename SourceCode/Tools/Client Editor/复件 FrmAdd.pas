unit FrmAdd;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, Graphics, Controls, Forms, WIL,
  Dialogs, StdCtrls, ComCtrls, TeCanvas, ExtCtrls, Spin, Gauges, Mask, RzEdit, RzStatus, RzPrgres, wmMyImage;

type
  pTFileListInfo = ^TFileListInfo;
  TFileListInfo = packed record
    FileName: string;
    nPx: SmallInt;
    nPy: SmallInt;
  end;
  
  TFormAdd = class(TForm)
    GroupBox1: TGroupBox;
    ImageStream: TRadioButton;
    WavaStream: TRadioButton;
    DataStream: TRadioButton;
    GroupBox2: TGroupBox;
    File_List: TListBox;
    ImageOption: TGroupBox;
    GroupBox4: TGroupBox;
    Mode_after: TRadioButton;
    Mode_Insert: TRadioButton;
    Mode_Bestrow: TRadioButton;
    GroupBox5: TGroupBox;
    Label3: TLabel;
    Label2: TLabel;
    File_Add: TButton;
    File_Del: TButton;
    File_Clear: TButton;
    GroupBox7: TGroupBox;
    Image_ImgAndOffset: TRadioButton;
    Image_Img: TRadioButton;
    Image_Offset: TRadioButton;
    GroupBox6: TGroupBox;
    Image_Offset_File: TRadioButton;
    Image_Offset_App: TRadioButton;
    Image_Offset_AppData: TEdit;
    Image_Alpha: TCheckBox;
    Image_RLE: TCheckBox;
    Image_Cut: TCheckBox;
    Label1: TLabel;
    File_Begin: TButton;
    WavaOption: TGroupBox;
    Wava_ZIP: TCheckBox;
    Wava_ZIP_Level: TSpinEdit;
    Label4: TLabel;
    DataOption: TGroupBox;
    Label5: TLabel;
    Data_ZIP: TCheckBox;
    Data_ZIP_Level: TSpinEdit;
    OpenDialog: TOpenDialog;
    ProgressBar: TProgressBar;
    Image_TColor: TRzColorEdit;
    Index_Start: TSpinEdit;
    Index_End: TSpinEdit;
    File_AddDIR: TButton;
    NoneOption: TGroupBox;
    Label6: TLabel;
    None_Count: TSpinEdit;
    NoneStream: TRadioButton;
    procedure ImageStreamClick(Sender: TObject);
    procedure File_BeginClick(Sender: TObject);
    procedure File_AddClick(Sender: TObject);
    procedure File_ClearClick(Sender: TObject);
    procedure File_DelClick(Sender: TObject);
    procedure File_AddDIRClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
//    FFileList: TStringList;
//    FImageOffsetList: TStringList;
    procedure ChangeControl(boBegin: Boolean = False);
    function LoadFileToBmp(sFileName: string): TBitmap;

    function FormatBitmap(const Bitmap: TBitmap; boAlpha, boRLE, boCut: Boolean; BColor: TColor; var Data: PChar): Integer;
    function FormatData(sFileName: string; boZIP: Boolean; nZIPLevel, nSize: Integer; var Data: PChar): Integer;
    function EncodeRLE(const Source, Target: Pointer; Count: Integer; BPP: Integer = 2): Integer;
  public
    procedure Open();
  end;

var
  FormAdd: TFormAdd;

implementation
uses
  ZShare, HUtil32, FrmMain;

{$R *.dfm}

{ TFormAdd }

procedure TFormAdd.ChangeControl(boBegin: Boolean);
begin
  ImageStream.Enabled := not boBegin;
  WavaStream.Enabled := not boBegin;
  DataStream.Enabled := not boBegin;
  NoneStream.Enabled := not boBegin;

  File_Begin.Enabled := not boBegin;
  File_Add.Enabled := not boBegin;
  File_AddDIR.Enabled := not boBegin;
  File_Del.Enabled := (not boBegin) and (File_List.ItemIndex <> -1);
  File_Clear.Enabled := (not boBegin) and (File_List.Items.Count > 0);

  ImageOption.Visible := ImageStream.Checked;
  WavaOption.Visible := WavaStream.Checked;
  DataOption.Visible := DataStream.Checked;
  NoneOption.Visible := NoneStream.Checked;

  Mode_after.Enabled := (not boBegin);
  Mode_Insert.Enabled := (not boBegin);
  Mode_Bestrow.Enabled := (not boBegin);
  Index_End.Enabled := False;
  if NoneOption.Visible then begin
    None_Count.Enabled := (not boBegin);
    if Mode_Bestrow.Checked then begin
      Mode_Bestrow.Checked := False;
      Mode_after.Checked := True;
    end;
    Mode_Bestrow.Enabled := False;
  end
  else if DataOption.Visible then begin
    Data_ZIP_Level.Enabled := (not boBegin) and Data_ZIP.Checked;
    label5.Enabled := Data_ZIP_Level.Enabled;
  end
  else if WavaOption.Visible then begin
    Wava_ZIP_Level.Enabled := (not boBegin) and Wava_ZIP.Checked;
    label4.Enabled := Wava_ZIP_Level.Enabled;
  end
  else if ImageOption.Visible then begin
    Image_ImgAndOffset.Enabled := not boBegin;
    Image_Img.Enabled := not boBegin;
    Image_Offset.Enabled := not boBegin;
    Image_Alpha.Enabled := (not boBegin) and (not Image_Offset.Checked);
    Image_RLE.Enabled := (not boBegin) and (not Image_Offset.Checked);
    Image_Cut.Enabled := (not boBegin) and (not Image_Offset.Checked);
    Image_TColor.Enabled := (not boBegin) and (not Image_Offset.Checked) and (not Image_Alpha.Checked);
    Label1.Enabled := Image_TColor.Enabled;
    Image_Offset_File.Enabled := (not boBegin) and (not Image_Img.Checked);
    Image_Offset_App.Enabled := (not boBegin) and (not Image_Img.Checked);
    Image_Offset_AppData.Enabled := (not boBegin) and (not Image_Img.Checked) and (Image_Offset_App.Checked);

    if Image_Offset.Checked then
      Image_Offset_File.Caption := '使用文件列表'
    else
      Image_Offset_File.Caption := '同名坐标文件';

    Mode_after.Enabled := (not boBegin) and (Image_ImgAndOffset.Checked { or Image_Img.Checked});
    Mode_Insert.Enabled := (not boBegin) and (Image_ImgAndOffset.Checked { or Image_Img.Checked});
    Mode_Bestrow.Enabled := (not boBegin) and (Image_ImgAndOffset.Checked or Image_Img.Checked or Image_Offset.Checked);

    Mode_after.Checked := Mode_after.Checked and (not Image_Offset.Checked) and (not Image_Img.Checked);
    Mode_Insert.Checked := Mode_Insert.Checked and (not Image_Offset.Checked) and (not Image_Img.Checked);
    Mode_Bestrow.Checked := Mode_Bestrow.Checked or Image_Offset.Checked or Image_Img.Checked;

    Index_End.Enabled := (not boBegin) and Image_Offset.Checked and Image_Offset_App.Checked;
  end;

  Index_Start.Enabled := (not boBegin) and (Mode_Insert.Checked or Mode_Bestrow.Checked);
  Label2.Enabled := Index_Start.Enabled;
  Label3.Enabled := Index_End.Enabled;
  if not Index_End.Enabled then
    Index_End.Value := Index_Start.Value + (File_List.Count - 1);
  GroupBox2.Caption := '文件列表(' + IntToStr(File_List.Count) + ')';
end;

procedure TFormAdd.File_AddClick(Sender: TObject);
var
  i: integer;
  FileName, FIdxFile, TempStr, sX, sY: string;
  TempList: TStringList;
  FileListInfo: pTFileListInfo;
begin
  OpenDialog.FileName := '';
  if OpenDialog.Execute(Handle) and (OpenDialog.FileName <> '') and (OpenDialog.Files.Count > 0) then begin
    ChangeControl(True);
    File_List.Visible := False;
    TempList := TStringList.Create;
    ProgressBar.Max := OpenDialog.Files.Count;
    try
      for I := 0 to OpenDialog.Files.Count - 1 do begin
        FileName := ExtractFileName(OpenDiaLog.Files[i]);
        New(FileListInfo);
        FileListInfo.FileName := OpenDiaLog.Files[i];
        FileListInfo.nPx := 0;
        FileListInfo.nPy := 0;
        File_List.Items.AddObject(FileName, TObject(FileListInfo));
        FIdxFile := ExtractFilePath(Filename) + IMAGEOFFSETDIR + ExtractFileNameOnly(FileName) + '.txt';
        if FileExists(FIdxFile) then begin
          TempList.LoadFromFile(FIdxFile);
          if TempList.Count > 0 then begin
            TempStr := Templist[0];
            TempStr := GetValidStr3(TempStr, sX, [' ', ',']);
            TempStr := GetValidStr3(TempStr, sY, [' ', ',']);
            FileListInfo.nPx := StrToIntDef(sX, 0);
            FileListInfo.nPy := StrToIntDef(sY, 0);
          end;
        end;
        ProgressBar.Position := I + 1;
      end;
    finally
      TempList.Free;
      File_List.Visible := True;
      ChangeControl();
    end;
  end;

end;

procedure TFormAdd.File_AddDIRClick(Sender: TObject);
var
  sStr: string;
  sr: TSearchRec;
  I: Integer;
  FIdxFile, TempStr, sX, sY: string;
  TempList: TStringList;
  FileListInfo: pTFileListInfo;
begin
  sStr := BrowseForFolder(Handle, '请选择文件夹');
  if sStr <> '' then begin
    if RightStr(sStr, 1) <> '\' then
      sStr := sStr + '\';
    ChangeControl(True);
    File_List.Visible := False;
    TempList := TStringList.Create;
    I := FindFirst(sStr + '*.*', faAnyFile, sr);
    try
      while i = 0 do begin
        if (Sr.Attr and faDirectory) = 0 then begin
          if sr.Name[1] <> '.' then begin
            New(FileListInfo);
            FileListInfo.FileName := sStr + sr.Name;
            FileListInfo.nPx := 0;
            FileListInfo.nPy := 0;
            File_List.Items.AddObject(sr.Name, TObject(FileListInfo));
            FIdxFile := sStr + IMAGEOFFSETDIR + sr.Name + '.txt';
            if FileExists(FIdxFile) then begin
              TempList.LoadFromFile(FIdxFile);
              if TempList.Count > 0 then begin
                TempStr := Templist[0];
                TempStr := GetValidStr3(TempStr, sX, [' ', ',']);
                TempStr := GetValidStr3(TempStr, sY, [' ', ',']);
                FileListInfo.nPx := StrToIntDef(sX, 0);
                FileListInfo.nPy := StrToIntDef(sY, 0);
              end;
            end;
          end;
        end;
        i := FindNext(sr);
      end;
    finally
      FindClose(sr);
      TempList.Free;
      File_List.Visible := True;
      ChangeControl();
    end;

  end;
end;

procedure TFormAdd.File_BeginClick(Sender: TObject);
const
  MAXBUFFERLEN = 1024 * 1024 * 50;
  MAXFILESIZE = 1024 * 1024 * 10;
var
  i, X, Y, nI: Integer;
  StartInt, EndInt, StartPos, EndPos: Integer;
  TempStr, sX, sY: string;
  AddBufferCount: Integer;
  BufferLen, DataBufferLen: Integer;
  Buffer, DataBuffer: PChar;
  Bitmap: TBitmap;
  OffsetList: TList;
  OffsetStrList: TStringList;
  ImageInfo: wmMyImage.TWMImageInfo;
  WMImages: wmMyImage.TWMMyImageImages;
  FileListInfo: pTFileListInfo;
begin
  if (g_WMImages = nil) or (not g_WMImages.boInitialize) or (g_WMImages.ReadOnly) or
    (not (g_WMImages is TWMMyImageImages)) then
    exit;
  WMImages := TWMMyImageImages(g_WMImages);
  StartInt := Index_Start.Value;
  EndInt := Index_End.Value;
  
  TempStr := Image_Offset_AppData.Text;
  TempStr := GetValidStr3(TempStr, sX, [' ', ',']);
  TempStr := GetValidStr3(TempStr, sY, [' ', ',']);
  X := StrToIntDef(sX, 0);
  Y := StrToIntDef(sY, 0);

  if Mode_Insert.Checked and (StartInt >= g_WMImages.ImageCount) then begin
    Application.MessageBox('起始编号设置错误', '提示信息！', MB_OK or MB_ICONASTERISK);
    exit;
  end;
  if Mode_Bestrow.Checked and (EndInt >= g_WMImages.ImageCount) then begin
    Application.MessageBox('结束编号设置错误', '提示信息！', MB_OK or MB_ICONASTERISK);
    exit;
  end;

  if ImageStream.Checked and Image_Offset.Checked and Image_Offset_App.Checked then begin
    for I := StartInt to EndInt do begin
      WMImages.UpdateImageXY(I, X, Y);
    end;
    FormMain.DrawGrid.RowCount := g_WMImages.ImageCount div 6 + 1;
    FormMain.DrawGrid.Repaint;
    if MessageBox(Handle, '执行完成，是否退出导入界面？', '提示信息', MB_OKCANCEL + MB_ICONQUESTION) = IDOK then begin
      Close;
    end;
    exit;
  end;

  if Mode_Bestrow.Checked and ((EndInt - StartInt) <> File_List.Items.Count - 1) then begin
    Application.MessageBox('文件数量与编号设置不相同，无法完成覆盖！', '提示信息', MB_OK or
      MB_ICONASTERISK);
    exit;
  end;

  if NoneStream.Checked then begin
    for I := 0 to None_Count.Value - 1 do begin
      if Mode_after.Checked then begin
        g_WMImages.AddIndex(-1, 0);
      end
      else if Mode_Insert.Checked then begin
        g_WMImages.AddIndex(StartInt, 0);
      end;
    end;
    g_WMImages.SaveIndexList;
    FormMain.DrawGrid.RowCount := g_WMImages.ImageCount div 6 + 1;
    FormMain.DrawGrid.Repaint;
    if MessageBox(Handle, '执行完成，是否退出导入界面？', '提示信息', MB_OKCANCEL + MB_ICONQUESTION) = IDOK then begin
      Close;
    end;
    exit;
  end;
  if (File_List.Items.Count <= 0) then begin
    MessageBox(Handle, '请先选项要打包的文件！', '提示信息', MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  ChangeControl(True);
  ProgressBar.Max := File_List.Items.Count;

  //建立缓冲
  BufferLen := 0;
  AddBufferCount := StartInt;
  GetMem(Buffer, MAXBUFFERLEN);
  OffsetList := TList.Create;
  OffsetStrList := TStringList.Create;
  DataBuffer := nil;
  Bitmap := nil;
  try
{
  以下为自己使用的方式
  如果说用于玩家动态增加或修改打包文件数据,不采用清除原数据
  直接在尾部增加数据,更改索引值既可
  采用该方式的好处是可以加快修改数据的速度,坏处是文件是不断增大
}
  for nI := 0 to File_List.Items.Count - 1 do begin
    for I := 0 to 0 do begin
      BufferLen := 0;
      AddBufferCount := StartInt;
      OffsetList.Clear;
      OffsetStrList.Clear;
      DataBuffer := nil;
      Bitmap := nil;
      
      FileListInfo := pTFileListInfo(File_List.Items.Objects[nI]);
      AddBufferCount := StrToIntDef(ExtractFileNameOnly(FileListInfo.FileName), -1);
      if AddBufferCount = -1 then Continue;
      StartInt := AddBufferCount;
      EndInt := AddBufferCount;   

      DataBuffer := nil;
      Bitmap := nil;
      DataBufferLen := 0;
      if ImageStream.Checked then begin
        if Image_Offset.Checked then begin //更新坐标
          X := 0;
          Y := 0;
          Try
            OffsetStrList.LoadFromFile(FileListInfo.FileName);
            if OffsetStrList.Count > 0 then begin
              TempStr := OffsetStrList[0];
              TempStr := GetValidStr3(TempStr, sX, [' ', ',']);
              TempStr := GetValidStr3(TempStr, sY, [' ', ',']);
              X := StrToIntDef(sX, 0);
              Y := StrToIntDef(sY, 0);
            end;
          Except
          End;
          WMImages.UpdateImageXY(StartInt + I, X, Y);
        end else begin   //更新图片和坐标
          if Image_ImgAndOffset.Checked and Image_Offset_File.Checked then begin
            X := FileListInfo.nPx;
            Y := FileListInfo.nPy;
          end;
          Try
            Bitmap := LoadFileToBmp(FileListInfo.FileName);  //将不同类型的图型文件转换为BMP类型
          Except
            Bitmap := nil;
          End;
          if Bitmap = nil then begin
            if MessageBox(Handle, PChar(FileListInfo.FileName + #13#10 + '未支持该文件类型或格式不正确，是否继续？'),
              '提示信息', MB_OKCANCEL + MB_ICONWARNING + MB_DEFBUTTON2) = IDOK then
            begin
              if Mode_after.Checked then begin
                g_WMImages.AddIndex(-1, 0);
              end
              else if Mode_Insert.Checked then begin
                OffsetList.Add(Pointer(-1));
              end
              else if Mode_Bestrow.Checked then begin
                OffsetList.Add(Pointer(-1));
              end;
              Continue;
            end else break;
          end;
          if (Bitmap.Width < MINIMAGESIZE) or (Bitmap.Height < MINIMAGESIZE) or
            (Bitmap.Width > MAXIMAGESIZE) or (Bitmap.Height > MAXIMAGESIZE) then begin
            if Mode_after.Checked then begin
              g_WMImages.AddIndex(-1, 0);
            end
            else if Mode_Insert.Checked then begin
              OffsetList.Add(Pointer(-1));
            end
            else if Mode_Bestrow.Checked then begin
              OffsetList.Add(Pointer(-1));
            end;
            Continue;
          end else begin
            //将图型数据转换为存储数据
            DataBufferLen := FormatBitmap(Bitmap, Image_Alpha.Checked, Image_RLE.Checked, Image_Cut.Checked,
              Image_TColor.SelectedColor, DataBuffer);
            if Image_ImgAndOffset.Checked then begin
              FillChar(ImageInfo, SizeOf(ImageInfo), #0);
              ImageInfo.DXInfo.px := X;
              ImageInfo.DXInfo.py := Y;
            end else begin
              ImageInfo := WMImages.GetDataImageInfo(StartInt + I);
            end;
            ImageInfo.DXInfo.nWidth := Bitmap.Width;
            ImageInfo.DXInfo.nHeight := Bitmap.Height;
            ImageInfo.btFileType := FILETYPE_IMAGE;
            ImageInfo.boEncrypt := Image_RLE.Checked;
            ImageInfo.nDataSize := DataBufferLen;
          end;
          if Bitmap <> nil then begin
            Bitmap.Free;
            Bitmap := nil;
          end;
        end;
      end
      else if WavaStream.Checked then begin    //音频数据处理

      

      end
      else if DataStream.Checked then begin    //其它数据处理
        Try
          DataBufferLen := FileSize(FileListInfo.FileName);
          if (DataBufferLen > MAXFILESIZE) or (DataBufferLen <= 0) then begin
            if MessageBox(Handle, PChar(FileListInfo.FileName + #13#10 +
              '文件超出大小限制，数据大小(' + IntToStr(DataBufferLen) + ')，是否继续？'),
              '提示信息', MB_OKCANCEL + MB_ICONWARNING + MB_DEFBUTTON2) = IDOK then
            begin
              if Mode_after.Checked then begin
                g_WMImages.AddIndex(-1, 0);
              end
              else if Mode_Insert.Checked then begin
                OffsetList.Add(Pointer(-1));
              end
              else if Mode_Bestrow.Checked then begin
                OffsetList.Add(Pointer(-1));
              end;
              Continue;
            end else break;
          end;
          DataBufferLen := FormatData(FileListInfo.FileName, Data_ZIP.Checked, Data_ZIP_Level.Value, DataBufferLen, DataBuffer);
          FillChar(ImageInfo, SizeOf(ImageInfo), #0);
          ImageInfo.btFileType := FILETYPE_DATA;
          ImageInfo.boZip := Data_ZIP.Checked;
          ImageInfo.btZipLevel := (Data_ZIP_Level.Value) and $FF shl 4;
          ImageInfo.nDataSize := DataBufferLen;
        Except
          DataBufferLen := 0;
        End;
        if DataBufferLen = 0 then begin
          if MessageBox(Handle, PChar(FileListInfo.FileName + #13#10 + '压缩该文件错误，是否继续？'),
              '提示信息', MB_OKCANCEL + MB_ICONWARNING + MB_DEFBUTTON2) = IDOK then
          begin
            if Mode_after.Checked then begin
              g_WMImages.AddIndex(-1, 0);
            end
            else if Mode_Insert.Checked then begin
              OffsetList.Add(Pointer(-1));
            end
            else if Mode_Bestrow.Checked then begin
              OffsetList.Add(Pointer(-1));
            end;
            Continue;
          end else break;
        end;
      end;
      if (DataBufferLen > 0) and (DataBuffer <> nil) then begin
        if DataBufferLen + SizeOf(ImageInfo) > MAXBUFFERLEN then begin
          Application.MessageBox(PChar(FileListInfo.FileName + #13#10 +
            '内存溢出，数据大小(' + IntToStr(DataBufferLen) + ')'), '提示信息', MB_OK + MB_ICONSTOP);
          break;
        end;
        if Mode_after.Checked then begin   //尾部增加的数据
          WMImages.AddDataToFile(@ImageInfo, DataBuffer, DataBufferLen);
        end else begin
          if (DataBufferLen + SizeOf(ImageInfo) + BufferLen) > MAXBUFFERLEN then begin
            if Mode_Insert.Checked then begin
              StartPos := WMImages.GetDataOffset(AddBufferCount, False);
              if (StartPos <= 0) then begin
                Application.MessageBox('文件索引错误！', '提示信息', MB_OK + MB_ICONSTOP);
                break;
              end;
              AppendData(WMImages.FileName, StartPos, BufferLen); //申请空间
              WMImages.AddDataToFile(StartPos, Buffer, BufferLen);
              WMImages.InsertOffsetToList(OffsetList, AddBufferCount, StartPos, BufferLen);
              Inc(AddBufferCount, OffsetList.Count);
            end else begin
              StartPos := WMImages.GetDataOffset(AddBufferCount, False);
              EndPos := WMImages.GetDataOffset(AddBufferCount + OffsetList.Count, False);
              if (StartPos <= 0) or (EndPos <= 0) or (EndPos < StartPos) then begin
                Application.MessageBox('文件索引错误！', '提示信息', MB_OK + MB_ICONSTOP);
                break;
              end;
              if BufferLen > (EndPos - StartPos) then begin
                AppendData(WMImages.FileName, StartPos, BufferLen - (EndPos - StartPos)); //申请空间
              end else
              if BufferLen < (EndPos - StartPos) then begin
                RemoveData(WMImages.FileName, StartPos, (EndPos - StartPos) - BufferLen); //删除空间
              end;
              WMImages.AddDataToFile(StartPos, Buffer, BufferLen);
              WMImages.UpdateOffsetToList(OffsetList, AddBufferCount, StartPos, BufferLen - (EndPos - StartPos));
              Inc(AddBufferCount, OffsetList.Count);
            end;
            BufferLen := 0;
            OffsetList.Clear;
          end;
          OffsetList.Add(Pointer(BufferLen));
          Move(ImageInfo, Buffer[BufferLen], SizeOf(ImageInfo));
          Move(DataBuffer^, Buffer[BufferLen + SizeOf(ImageInfo)], DataBufferLen);
          Inc(BufferLen, SizeOf(ImageInfo) + DataBufferLen);
        end;
      end else begin
        if Mode_after.Checked then begin
          g_WMImages.AddIndex(-1, 0);
        end
        else if Mode_Insert.Checked then begin
          OffsetList.Add(Pointer(-1));
        end
        else if Mode_Bestrow.Checked then begin
          OffsetList.Add(Pointer(-1));
        end;
      end;
      if DataBuffer <> nil then begin
        FreeMem(DataBuffer);
        DataBuffer := nil;
      end;
      ProgressBar.Position := I + 1;
    end;
    if (BufferLen > 0) or (OffsetList.Count > 0) then begin
      if Mode_Insert.Checked then begin
        StartPos := WMImages.GetDataOffset(AddBufferCount, False);
        if (StartPos > 0) then begin
          AppendData(WMImages.FileName, StartPos, BufferLen); //申请空间
          WMImages.AddDataToFile(StartPos, Buffer, BufferLen);
          WMImages.InsertOffsetToList(OffsetList, AddBufferCount, StartPos, BufferLen);
        end else
          Application.MessageBox('文件索引错误！', '提示信息', MB_OK + MB_ICONSTOP);
      end else begin
        StartPos := WMImages.GetDataOffset(AddBufferCount, False);
        EndPos := WMImages.GetDataOffset(AddBufferCount + OffsetList.Count, False);
        if (StartPos > 0) and (EndPos > 0) and (EndPos >= StartPos) then begin
          if BufferLen > (EndPos - StartPos) then begin
            AppendData(WMImages.FileName, StartPos, BufferLen - (EndPos - StartPos)); //申请空间
          end else
          if BufferLen < (EndPos - StartPos) then begin
            RemoveData(WMImages.FileName, StartPos, (EndPos - StartPos) - BufferLen); //删除空间
          end;
          WMImages.AddDataToFile(StartPos, Buffer, BufferLen);
          WMImages.UpdateOffsetToList(OffsetList, AddBufferCount, StartPos, BufferLen - (EndPos - StartPos));
        end else
          Application.MessageBox('文件索引错误！', '提示信息', MB_OK + MB_ICONSTOP);
      end;
    end;
    if Bitmap <> nil then
      Bitmap.Free;
    if DataBuffer <> nil then begin
      FreeMem(DataBuffer);
    end;
    Bitmap := nil;
    DataBuffer := nil;
  end;
    g_WMImages.SaveIndexList;
    FormMain.DrawGrid.RowCount := g_WMImages.ImageCount div 6 + 1;
    FormMain.DrawGrid.Repaint;
  finally
    if Bitmap <> nil then
      Bitmap.Free;
    if DataBuffer <> nil then begin
      FreeMem(DataBuffer);
    end;
    OffsetList.Free;
    OffsetStrList.Free;
    FreeMem(Buffer);
    ChangeControl(False);
  end;
  if MessageBox(Handle, '执行完成，是否退出导入界面？', '提示信息', MB_OKCANCEL + MB_ICONQUESTION) = IDOK then begin
    Close;
  end;
end;

function TFormAdd.EncodeRLE(const Source, Target: Pointer; Count: Integer; BPP: Integer): Integer;
var
  DiffCount, // pixel count until two identical
  SameCount: Integer; // number of identical adjacent pixels
  SourcePtr,
    TargetPtr: PByte;

begin
  Result := 0;
  SourcePtr := Source;
  TargetPtr := Target;
  while Count > 0 do begin
    DiffCount := CountDiffPixels(SourcePtr, BPP, Count);
    SameCount := CountSamePixels(SourcePtr, BPP, Count);
    if DiffCount > 128 then DiffCount := 128;
    if SameCount > 128 then SameCount := 128;
    if DiffCount > 0 then begin
      TargetPtr^ := DiffCount - 1;
      Inc(TargetPtr);
      Dec(Count, DiffCount);
      Inc(Result, (DiffCount * BPP) + 1);
      while DiffCount > 0 do begin
        TargetPtr^ := SourcePtr^;
        Inc(SourcePtr);
        Inc(TargetPtr);
        if BPP > 1 then begin
          TargetPtr^ := SourcePtr^;
          Inc(SourcePtr);
          Inc(TargetPtr);
        end;
        Dec(DiffCount);
      end;
    end;
    if SameCount > 1 then begin
      TargetPtr^ := (SameCount - 1) or $80;
      Inc(TargetPtr);
      Dec(Count, SameCount);
      Inc(Result, BPP + 1);
      Inc(SourcePtr, (SameCount - 1) * BPP);
      TargetPtr^ := SourcePtr^;
      Inc(SourcePtr);
      Inc(TargetPtr);
      if BPP > 1 then begin
        TargetPtr^ := SourcePtr^;
        Inc(SourcePtr);
        Inc(TargetPtr);
      end;
    end;
  end;
end;

procedure TFormAdd.File_ClearClick(Sender: TObject);
var
  i: integer;
begin
  for I := 0 to File_List.Items.Count - 1 do begin
    Dispose(pTFileListInfo(File_List.Items.Objects[I]))
  end;
  File_List.Items.Clear;
  ChangeControl();
end;

procedure TFormAdd.File_DelClick(Sender: TObject);
var
  i: integer;
begin
  for I := File_List.Count - 1 downto 0 do begin
    if File_List.Selected[I] then begin
      Dispose(pTFileListInfo(File_List.Items.Objects[I]));
      File_List.Items.Delete(I);
    end;
  end;
  ChangeControl();
end;

procedure TFormAdd.ImageStreamClick(Sender: TObject);
begin
  ChangeControl();
end;

function TFormAdd.LoadFileToBmp(sFileName: string): TBitmap;
var
  FileStream: TFileStream;
  ChrBuff: array[0..9] of Char;
begin
  Result := nil;
  FileStream := TFileStream.Create(sFileName, fmOpenRead or fmShareDenyNone);
  try
    FileStream.Read(ChrBuff[0], SizeOf(ChrBuff));
    FileStream.Seek(0, 0);
    if (ChrBuff[0] + ChrBuff[1]) = 'BM' then begin   //BMP
      Result := TBitmap.Create;
      Result.LoadFromStream(FileStream);
    end;
  finally
    FileStream.Free;
  end;
end;

function TFormAdd.FormatBitmap(const Bitmap: TBitmap; boAlpha, boRLE, boCut: Boolean; BColor: TColor;
  var Data: PChar): Integer;
var
  nBuffLen: Integer;
  Buffer: PChar;
  nY, nX: Integer;
  PDWord: PWord;
  P32RGB: PRGBQuad;
  CheckColor: Integer;
begin
  Data := nil;
  Result := 0;
  nBuffLen := Bitmap.Width * Bitmap.Height * 2;
  Buffer := AllocMem(nBuffLen);
  CheckColor := DisplaceRB(BColor) and $FFFFFF;
  Try
    if not boAlpha then begin
      Bitmap.PixelFormat := pf32bit;
      for nY := 0 to Bitmap.Height - 1 do begin
        if boCut then P32RGB := PRGBQuad(Bitmap.ScanLine[Bitmap.Height - 1 - nY])
        else P32RGB := PRGBQuad(Bitmap.ScanLine[nY]);
        PDWord := PWord(@Buffer[Bitmap.Width * 2 * nY]);
        for nX := 0 to Bitmap.Width - 1 do begin
          if (PInteger(P32RGB)^ and $FFFFFF) = CheckColor then begin
            PDWord^ := 0;
          end else begin
            PDWord^ := ($F0 shl 8) + ((WORD(P32RGB.rgbRed) and $F0) shl 4) +
              (WORD(P32RGB.rgbGreen) and $F0) + (WORD(P32RGB.rgbBlue) shr 4);
          end;
          Inc(P32RGB);
          Inc(PDWord);
        end;
      end;
    end else begin
      if Bitmap.PixelFormat = pf32bit then begin
        for nY := 0 to Bitmap.Height - 1 do begin
          if boCut then P32RGB := PRGBQuad(Bitmap.ScanLine[Bitmap.Height - 1 - nY])
          else P32RGB := PRGBQuad(Bitmap.ScanLine[nY]);
          PDWord := PWord(@Buffer[Bitmap.Width * 2 * nY]);
          for nX := 0 to Bitmap.Width - 1 do begin
            PDWord^ := (WORD(P32RGB.rgbReserved) and $F0 shl 8) + ((WORD(P32RGB.rgbRed) and $F0) shl 4) +
                (WORD(P32RGB.rgbGreen) and $F0) + (WORD(P32RGB.rgbBlue) shr 4);
            Inc(P32RGB);
            Inc(PDWord);
          end;
        end;
      end
      else
      if Bitmap.PixelFormat = pf16bit then begin
        for nY := 0 to Bitmap.Height - 1 do begin
          if boCut then Move(Bitmap.ScanLine[Bitmap.Height - 1 - nY]^, Buffer[Bitmap.Width * 2 * nY], Bitmap.Width * 2)
          else Move(Bitmap.ScanLine[nY]^, Buffer[Bitmap.Width * 2 * nY], Bitmap.Width * 2);
        end;
      end;
    end;

    if boRLE then begin
      Data := AllocMem(nBuffLen * 2);
      Result := EncodeRLE(Buffer, Data, Bitmap.Width * Bitmap.Height);
      FreeMem(Buffer);
    end else begin
      Result := nBuffLen;
      Data := Buffer;
    end;
  Except
    FreeMem(Buffer);
  End;
end;

function TFormAdd.FormatData(sFileName: string; boZIP: Boolean; nZIPLevel, nSize: Integer; var Data: PChar): Integer;
var
  FileName: string;
  nFileLen: Integer;
  fhandle: THandle;
  Buffer: PChar;
begin
  Result := 0;
  FileName := ExtractFileName(sFileName);
  nFileLen := Length(FileName);
  if nFileLen <= 0 then exit;
  fhandle := FileOpen(sFileName, fmOpenRead or fmShareDenyNone);
  if (fhandle > 0) then begin
    Result := nSize + Length(FileName) + SizeOf(Integer);
    GetMem(Buffer, nSize + nFileLen + SizeOf(Integer));
    Try
      Move(nFileLen, Buffer^, SizeOf(Integer));
      Move(FileName[1], Buffer[SizeOf(Integer)], nFileLen);
      if FileRead(fhandle, Buffer[nFileLen + SizeOf(Integer)], nSize) = nSize then begin
        if boZIP and (nZIPLevel > 0) then begin
          Result := ZIPCompress(Buffer, Result, nZIPLevel, Data);
        end else begin
          Result := nSize + nFileLen + SizeOf(Integer);
          GetMem(Data, Result);
          Move(Buffer^, Data^, Result);
        end;
      end;
    Finally
      FreeMem(Buffer);
      FileClose(fhandle);
    End;
  end;
end;

procedure TFormAdd.FormDestroy(Sender: TObject);
begin
  File_ClearClick(File_Clear);
end;

procedure TFormAdd.Open;
begin
  Index_Start.Value := g_SelectImageIndex;
  Index_End.Value := g_SelectImageIndex;
  ChangeControl;
  ShowModal;
end;

end.

