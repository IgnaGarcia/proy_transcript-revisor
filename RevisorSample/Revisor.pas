unit Revisor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  System.JSON, Vcl.StdCtrls, Vcl.MPlayer, IOUtils, TextContainer;

type
  TForm1 = class(TForm)
    MediaPlayer1: TMediaPlayer;
    audioDialog: TOpenDialog;
    audioBtn: TButton;
    textBtn: TButton;
    textDialog: TOpenDialog;
    TFrame11: TextContainer.TFrame1;
    procedure audioBtnClick(Sender: TObject);
    procedure textBtnClick(Sender: TObject);
  private
  public
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
begin
  textDialog.Execute();

  TFrame11.linkData(TJSonObject.parseJSONValue(TFile.ReadAllText(textDialog.FileName)));
end;

end.
