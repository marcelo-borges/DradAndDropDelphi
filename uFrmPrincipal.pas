unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmPrincipal = class(TForm)
    memoPath: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure WMDROPFILES(var Msg: TMessage);
    procedure LBWindowProc(var Message: TMessage);
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses
  ShellAPI;

var
  OldLBWindowProc: TWndMethod;

{ TfrmPrincipal }

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  OldLBWindowProc := memoPath.WindowProc;
  memoPath.WindowProc := LBWindowProc;
  DragAcceptFiles(memoPath.Handle, True);
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  memoPath.WindowProc := OldLBWindowProc;
  DragAcceptFiles(memoPath.Handle, False);
end;

procedure TfrmPrincipal.LBWindowProc(var Message: TMessage);
begin
  if Message.Msg = WM_DROPFILES then
    WMDROPFILES(Message);
  OldLBWindowProc(Message);
end;

procedure TfrmPrincipal.WMDROPFILES(var Msg: TMessage);
var
  pcFileName: PChar;
  i, iSize, iFileCount: integer;
begin
  pcFileName := '';
  iFileCount := DragQueryFile(Msg.wParam, $FFFFFFFF, pcFileName, 255);
  for i := 0 to iFileCount - 1 do
  begin
    iSize := DragQueryFile(Msg.wParam, i, nil, 0) + 1;
    pcFileName := StrAlloc(iSize);
    DragQueryFile(Msg.wParam, i, pcFileName, iSize);
    if FileExists(pcFileName) then
      memoPath.Lines.Add(pcFileName);
    StrDispose(pcFileName);
  end;
  DragFinish(Msg.wParam);
end;

end.
