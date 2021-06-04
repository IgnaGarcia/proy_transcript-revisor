unit Revisor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  System.JSON, Vcl.StdCtrls, Vcl.MPlayer, IOUtils, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    header: TPanel;
    audioBtn: TButton;
    textBtn: TButton;
    audioDialog: TOpenDialog;
    textDialog: TOpenDialog;
    saveBtn: TButton;
    exportBtn: TButton;

    paragrapghBtns: TPanel;
    joinBtn: TButton;
    divideBtn: TButton;

    footer: TPanel;
    MediaPlayer1: TMediaPlayer;
    playpauseBtn: TButton;
    rewindBtn: TButton;
    passBtn: TButton;

    content: TPanel;
    procedure audioBtnClick(Sender: TObject);
    procedure textBtnClick(Sender: TObject);
    procedure exportBtnClick(Sender: TObject);
    procedure saveBtnClick(Sender: TObject);

    procedure joinBtnClick(Sender: TObject);
    procedure divideBtnClick(Sender: TObject);

    procedure playpauseBtnClick(Sender: TObject);
    procedure rewindBtnClick(Sender: TObject);
    procedure passBtnClick(Sender: TObject);
  private
  public
    state : Boolean;
    size : Integer;
    lastMemoClicked : Integer;
    memoArray : array of TMemo;
    startTimeArray : array of Integer;

    procedure linkData(jData: TJSONArray; sender: TMediaPlayer);
    procedure memoClick(Sender: TObject);
    procedure deleteX(index : Integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{Funciones del Header}

procedure TForm1.textBtnClick(Sender: TObject);
{Cargar el JSON}
var jText : TJSONValue;
begin
  textDialog.Execute();
  jText := TJSonObject.parseJSONValue(TFile.ReadAllText(textDialog.FileName));
  linkData(jText as TJSONArray, MediaPlayer1);
end;

procedure TForm1.audioBtnClick(Sender: TObject);
{Cargar el audio}
begin
  if audioDialog.Execute() then
  begin
    MediaPlayer1.FileName := audioDialog.FileName;
    MediaPlayer1.Open;
    MediaPlayer1.TimeFormat := tfMilliseconds;
    state := false
  end;
end;

procedure TForm1.saveBtnClick(Sender: TObject);
{Guardar el json editado}
begin
 {TODO}
end;

procedure TForm1.exportBtnClick(Sender: TObject);
{Exportar el texto revisado}
begin
  {TODO}
end;

{Funciones de SubHeader}

procedure TForm1.divideBtnClick(Sender: TObject);
{Dividir en 2 parrafos}
begin
  {TODO}
end;

procedure TForm1.joinBtnClick(Sender: TObject);
{Juntar parrafos}
begin
  if lastMemoClicked = -1 then
  begin
    showMessage('No se ha seleccionado un parrafo');
  end
  else if size-1 = lastMemoClicked then
  begin
    showMessage('No se se puede unir el ultimo parrafo');
  end
  else
  begin
    memoArray[lastMemoClicked].Text :=  memoArray[lastMemoClicked].Text + memoArray[lastMemoClicked+1].Text;
    memoArray[lastMemoClicked+1].Free;
    deleteX(lastMemoClicked+1);
  end;
end;

procedure TForm1.deleteX(index: Integer);
{Elimina un elemento y colapsa los array 1 posicion}
var
  I: Integer;
begin
  for I := index to size-2 do
  begin
    startTimeArray[I] := startTimeArray[I+1];
    memoArray[I] := memoArray[I+1];
  end;
  size := size - 1;

  SetLength(memoArray, size);
  SetLength(startTimeArray, size);
end;

{Funciones del Content}

procedure TForm1.linkData(jData: TJSONArray; sender: TMediaPlayer);
{Cargar los parrafos creando Memo's}
var Memo: TMemo;
    jValue: TJSONValue;
    word: TJSONValue;
    words: String;
    I : Integer;
begin
  lastMemoClicked := -1;
  size := jData.Count;
  SetLength(memoArray, size);
  SetLength(startTimeArray, size);

  I := size-1;
  while(I>=0) do
  begin
    Memo := TMemo.Create(Self);
    with Memo do
    begin
      Name := 'memoEj'+I.ToString;
      Parent := Self;
      Align := alBottom;
    end;

    Memo.Lines.Clear;
    words := '';
    jValue := jData.Items[I];
    for word in jValue.FindValue('words') as TJSONArray do
    begin
          words := words + ' ' + word.FindValue('word').Value;
    end;

    Memo.Text := words;
    Memo.Tag := Integer(I);
    Memo.OnClick := memoClick;
    memoArray[I] := Memo;
    startTimeArray[I] := Round(jValue.GetValue<Double>('from') * 1000);

    I := I-1;
  end;
  content.Free;
  AutoScroll := true;
end;

procedure TForm1.memoClick(Sender: TObject);
{Captar el click de un memo}
begin
    if Sender is TMemo then
    begin
      with Sender as TMemo do
        lastMemoClicked := Tag;
        MediaPlayer1.Position := startTimeArray[Tag];
        MediaPlayer1.Play;
        state:= true;
    end;
end;

{Funciones del Footer}

procedure TForm1.playpauseBtnClick(Sender: TObject);
{Play/Pause del audio}
begin
  if MediaPlayer1.FileName <> '' then
  begin
    if state then
    begin
     MediaPlayer1.Pause;
     {Cuando se pausa se revobina 3segs}
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
{Revobinar audio 5seg}
begin
  if MediaPlayer1.FileName <> '' then
  begin
    MediaPlayer1.Pause;
    MediaPlayer1.Position := MediaPlayer1.Position - 5000;
    MediaPlayer1.Play;
  end;
end;

procedure TForm1.passBtnClick(Sender: TObject);
{Avanzar audio 5seg}
begin
  if MediaPlayer1.FileName <> '' then
  begin
    MediaPlayer1.Pause;
    MediaPlayer1.Position := MediaPlayer1.Position + 5000;
    MediaPlayer1.Play;
  end;
end;
end.

