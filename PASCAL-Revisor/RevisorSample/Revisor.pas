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
    playpauseBtn: TButton;
    rewindBtn: TButton;
    passBtn: TButton;
    procedure audioBtnClick(Sender: TObject);
    procedure textBtnClick(Sender: TObject);
    procedure playpauseBtnClick(Sender: TObject);
    procedure rewindBtnClick(Sender: TObject);
    procedure passBtnClick(Sender: TObject);
  private
  public
    state: Boolean;
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
    MediaPlayer1.TimeFormat := tfMilliseconds;
    state := false
  end;
end;

procedure TForm1.playpauseBtnClick(Sender: TObject);
begin
  if MediaPlayer1.FileName <> '' then
  begin
    if state then
    begin
     MediaPlayer1.Pause;
     MediaPlayer1.Position := MediaPlayer1.Position - 3000;
     state := false ;
    end
    else
    begin
     MediaPlayer1.Play;
     state := true;
    end;
  end;
end;

procedure TForm1.rewindBtnClick(Sender: TObject);
begin
  if MediaPlayer1.FileName <> '' then
  begin
    MediaPlayer1.Pause;
    MediaPlayer1.Position := MediaPlayer1.Position - 5000;
    MediaPlayer1.Play;
  end;
end;

procedure TForm1.passBtnClick(Sender: TObject);
begin
  if MediaPlayer1.FileName <> '' then
  begin
    MediaPlayer1.Pause;
    MediaPlayer1.Position := MediaPlayer1.Position + 5000;
    MediaPlayer1.Play;
  end;
end;

procedure TForm1.textBtnClick(Sender: TObject);
var jText : TJSONValue;
begin
  textDialog.Execute();
  jText := TJSonObject.parseJSONValue(TFile.ReadAllText(textDialog.FileName));
  TFrame11.linkData(jText as TJSONArray, MediaPlayer1);
end;

end.

