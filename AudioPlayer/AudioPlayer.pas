unit AudioPlayer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, MMSystem, Vcl.MPlayer,
  Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    btnAddAudio: TButton;
    diag1: TOpenDialog;
    ListBox1: TListBox;
    MediaPlayer1: TMediaPlayer;
    Timer1: TTimer;
    procedure btnAddAudioClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnAddAudioClick(Sender: TObject);
begin
  if diag1.Execute() then
  begin
    ListBox1.items.clear;
    ListBox1.items.add(diag1.FileName);
    MediaPlayer1.FileName := diag1.FileName;
    MediaPlayer1.Open;
    Timer1.Enabled := true;
  end;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
    ListBox1.items.add(IntToStr(MediaPlayer1.Position));
end;

end.
