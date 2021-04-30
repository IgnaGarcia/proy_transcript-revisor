unit Revisor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.JSON, Vcl.StdCtrls, Vcl.MPlayer, IOUtils;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    MediaPlayer1: TMediaPlayer;
    audioDialog: TOpenDialog;
    audioBtn: TButton;
    textBtn: TButton;
    textDialog: TOpenDialog;
    procedure audioBtnClick(Sender: TObject);
    procedure textBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.audioBtnClick(Sender: TObject);
begin
  if audioDialog.Execute() then
  begin
    MediaPlayer1.FileName := audioDialog.FileName;
    MediaPlayer1.Open;
  end;
end;

procedure TForm1.textBtnClick(Sender: TObject);
var
 input: String;
 jData: TJSONValue;
begin
  textDialog.Execute();
  Memo1.Lines.Clear;

  input := TFile.ReadAllText(textDialog.FileName);
  jData := TJSonObject.parseJSONValue(input);

  Memo1.Lines.Append(jData.ToString);
end;

end.
