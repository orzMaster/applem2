unit FrmAlpha;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, DropGroupPas;

type
  TFormAlpha = class(TForm)
    DropFileGroupBox1: TDropFileGroupBox;
    ProgressBar1: TProgressBar;
    procedure DropFileGroupBox1DropFile(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Open();
  end;

var
  FormAlpha: TFormAlpha;

implementation

{$R *.dfm}

uses
  wmMyImage;

{ TFormAlpha }

procedure TFormAlpha.DropFileGroupBox1DropFile(Sender: TObject);
var
  I: Integer;
  FileName: string;
  FileStream: TFileStream;
  OldHeader: TWMImageHeader;
begin
  ProgressBar1.Position := 0;
  ProgressBar1.Max := DropFileGroupBox1.Files.Count;
  for I := 0 to DropFileGroupBox1.Files.Count - 1 do begin
    FileName := DropFileGroupBox1.Files[I];
    ProgressBar1.Position := I + 1;
    FileStream := TFileStream.Create(FileName, fmOpenReadWrite or fmShareDenyNone);
    Try
      if FileStream.Read(OldHeader, SizeOf(OldHeader)) = SizeOf(OldHeader) then begin
      
      end;

      //AppendData(WMImages.FileName, StartPos, BufferLen - (EndPos - StartPos));
    Finally
      FileStream.Free;
    End;
  end;
  Application.MessageBox('完成！', '信息框', MB_OK + MB_ICONINFORMATION);
end;

procedure TFormAlpha.Open;
begin
  ShowModal;
end;

end.
