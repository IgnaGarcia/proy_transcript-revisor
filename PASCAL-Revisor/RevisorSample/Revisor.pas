unit Revisor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  System.JSON, Vcl.StdCtrls, Vcl.MPlayer, IOUtils, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  MyParagraph = Class(TObject)
    public
      from: Double;
      toTime: Double;
      words: TMemo;
end;

type
  TForm1 = class(TForm)
    header: TPanel;
    chargeBtn: TButton;
    textDialog: TOpenDialog;
    saveBtn: TButton;
    exportBtn: TButton;
    exportDialog: TSaveDialog;

    paragrapghBtns: TPanel;
    joinBtn: TButton;
    divideBtn: TButton;

    ScrollBox1: TScrollBox;

    footer: TPanel;
    MediaPlayer1: TMediaPlayer;
    playpauseBtn: TButton;
    rewindBtn: TButton;
    passBtn: TButton;
    saveDialog: TSaveDialog;
    audioDialog: TOpenDialog;
    procedure chargeBtnClick(Sender: TObject);
    procedure saveBtnClick(Sender: TObject);
    procedure exportBtnClick(Sender: TObject);

    procedure joinBtnClick(Sender: TObject);
    procedure divideBtnClick(Sender: TObject);

    procedure playpauseBtnClick(Sender: TObject);
    procedure rewindBtnClick(Sender: TObject);
    procedure passBtnClick(Sender: TObject);
  private
  public
    state : Boolean;
    size : Integer;
    lastMemo : Integer;
    lastTStamp : Integer;
    audioSize : Integer;
    pArr : array of MyParagraph;

    procedure linkData(jData: TJSONArray; sender: TMediaPlayer);
    procedure memoClick(Sender: TObject);
    procedure deleteX(index : Integer);
    procedure chargeAudio();
    procedure chargeText();
  end;

var
  Form1: TForm1;

implementation
{$MAXSTACKSIZE 45943040}
{$R *.dfm}

{Funciones del Header}

procedure TForm1.chargeBtnClick(Sender: TObject);
{Cargar audio t JSON}
var I: Integer;
begin
  if pArr = nil then
  begin
    chargeText();
    chargeAudio();
  end
  else if MessageDlg('Desea sobreescribir la revision? puede que haya cambios sin guardar',mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
  begin
    MediaPlayer1.Close;
    for I := 0 to size-1 do
    begin
      pArr[I].words.Free;
      pArr[I].Free;
    end;
    chargeText();
    chargeAudio();
  end;
end;

procedure TForm1.chargeText();
{Cargar el JSON}
var jText : TJSONValue;
begin
  if textDialog.Execute() then
  begin
    jText := TJSonObject.parseJSONValue(TFile.ReadAllText(textDialog.FileName));
    linkData(jText as TJSONArray, MediaPlayer1);
  end;
end;

procedure TForm1.chargeAudio();
{Cargar el audio}
begin
  if audioDialog.Execute() then
  begin
    MediaPlayer1.FileName := audioDialog.FileName;
    MediaPlayer1.Open;
    audioSize := MediaPlayer1.Length;
    state := false
  end;
end;

procedure TForm1.saveBtnClick(Sender: TObject);
{Guardar el JSON de revision}
var
  I: Integer;
  jsonObject: TJSONObject;
  jsonArray: TJSONArray;
begin
  saveDialog.Execute();
  jsonArray := TJSONArray.Create();
  for I := 0 to size-1 do
  begin
    jsonObject := TJSONObject.Create();

    jsonObject.AddPair('from', TJSONNumber.Create(pArr[I].from));
    jsonObject.AddPair('to', TJSONNumber.Create(pArr[I].toTime));
    jsonObject.AddPair('words', pArr[I].words.Text);
    jsonArray.AddElement(jsonObject);
  end;
  TFile.WriteAllText(saveDialog.FileName+'.json', jsonArray.ToJSON);
end;

procedure TForm1.exportBtnClick(Sender: TObject);
{Exportar el texto revisado}
var
Fichero: TextFile;
I: Integer;
begin
  if exportDialog.Execute then
    if FileExists(exportDialog.FileName) then
      raise Exception.Create('File already exists. Cannot overwrite.')
    else
      AssignFile(Fichero, exportDialog.FileName+'.txt');
      try
        Rewrite(Fichero);
        for I := 0 to size-1 do
        begin
          WriteLn(Fichero, pArr[I].words.Text);
          WriteLn(Fichero, '');
        end;
      finally
      CloseFile(Fichero);
      end;
end;


{Funciones de SubHeader}

procedure TForm1.divideBtnClick(Sender: TObject);
{Dividir en 2 parrafos}
var Memo: TMemo;
  paragraph: MyParagraph;
  pArrAux : array of MyParagraph;
  I: Integer;
begin
  {TODO}
  if lastMemo = -1 then
  begin
    showMessage('No se ha seleccionado un parrafo');
  end
  else
  begin
    Memo := TMemo.Create(Self);
    Memo.Text := copy(pArr[lastMemo].words.Text, pArr[lastMemo].words.SelStart+1, length(pArr[lastMemo].words.Text));
    pArr[lastMemo].words.Text := copy(pArr[lastMemo].words.Text, 0, pArr[lastMemo].words.SelStart);

    Memo.OnClick := memoClick;
    Memo.Align := alTop;
    Memo.Top := pArr[lastMemo].words.Top + pArr[lastMemo].words.Height;
    Memo.Parent := ScrollBox1;

    Memo.Height := 19 + Memo.Lines.Count * 13;
    pArr[lastMemo].words.Height := 19 + pArr[lastMemo].words.Lines.Count * 13;

    paragraph := MyParagraph.Create();
    paragraph.words := Memo;
    paragraph.toTime := pArr[lastMemo].toTime;
    paragraph.from := pArr[lastMemo].from;
    //pArr[lastMemo].toTime := ;

    SetLength(pArrAux, size+1);
    for I := lastMemo+1 to size do
    begin
        if (I = lastMemo+1) then
        begin
           pArrAux[I] := pArr[I];
           pArr[I] := paragraph;
           paragraph.words.Tag := I
        end
        else
        begin
           pArrAux[I] := pArr[I];
           pArr[I] := pArrAux[I-1];
           pArr[I].words.Tag := I
        end;
    end;
    size := size+1;
  end;
end;

procedure TForm1.joinBtnClick(Sender: TObject);
{Juntar parrafos}
begin
  if lastMemo = -1 then
  begin
    showMessage('No se ha seleccionado un parrafo');
  end
  else if size-1 = lastMemo then
  begin
    showMessage('No se se puede unir el ultimo parrafo');
  end
  else
  begin
    pArr[lastMemo].words.Text :=  pArr[lastMemo].words.Text + pArr[lastMemo+1].words.Text;
    pArr[lastMemo].toTime :=  pArr[lastMemo+1].toTime;
    pArr[lastMemo].words.Height := 19 + pArr[lastMemo].words.Lines.Count * 13;
    pArr[lastMemo+1].words.Free;
    deleteX(lastMemo+1);
  end;
end;

procedure TForm1.deleteX(index: Integer);
{Elimina un elemento y colapsa los array 1 posicion}
var
  I: Integer;
begin
  for I := index+1 to size-1 do
  begin
    pArr[I-1] := pArr[I];
    pArr[I].words.Tag := pArr[I].words.Tag - 1;
  end;
  size := size - 1;
end;

{Funciones del Content}

procedure TForm1.linkData(jData: TJSONArray; sender: TMediaPlayer);
{Cargar los parrafos creando Memo's}
var Memo: TMemo;
    jValue: TJSONValue;
    I : Integer;
    paragraph: MyParagraph;
begin
  lastMemo := -1;
  size := jData.Count;
  SetLength(pArr, size+100);

  I := size-1;
  lastTStamp := Round(jData.Items[I].GetValue<Double>('to') * 1000);
  while(I>=0) do
  begin
    Memo := TMemo.Create(Self);
    Memo.Name := 'memoEj'+I.ToString;

    jValue := jData.Items[I];
    Memo.Text := jValue.FindValue('words').Value;

    Memo.Parent := ScrollBox1;
    Memo.Align := alTop;
    Memo.Tag := I;
    Memo.OnClick := memoClick;
    Memo.Height := 19 + Memo.Lines.Count * 13;

    paragraph := MyParagraph.Create();
    paragraph.words := Memo;
    paragraph.from := jValue.GetValue<Double>('from');
    paragraph.toTime := jValue.GetValue<Double>('to');
    pArr[I] := paragraph;

    I := I-1;
  end;
  AutoScroll := true;
end;


procedure TForm1.memoClick(Sender: TObject);
{Captar el click de un memo}
begin
  if Sender is TMemo then
  begin
    with Sender as TMemo do
    begin
      if (lastMemo <> Tag ) then
      begin
        lastMemo := Tag;
        MediaPlayer1.Position := Round(pArr[Tag].from*(audioSize/lastTStamp))*1000 - 3000;
        if state then
        begin
          MediaPlayer1.Play;
        end;
      end;
    end;
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
     MediaPlayer1.Position := MediaPlayer1.Position - 3000*Round(pArr[Tag].from*(audioSize/lastTStamp));
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
    MediaPlayer1.Position := MediaPlayer1.Position - 3000*Round(pArr[Tag].from*(audioSize/lastTStamp));
    MediaPlayer1.Play;
  end;
end;

procedure TForm1.passBtnClick(Sender: TObject);
{Avanzar audio 5seg}
begin
  if MediaPlayer1.FileName <> '' then
  begin
    MediaPlayer1.Pause;
    MediaPlayer1.Position := MediaPlayer1.Position + 3000*Round(pArr[Tag].from*(audioSize/lastTStamp));
    MediaPlayer1.Play;
  end;
end;
end.
