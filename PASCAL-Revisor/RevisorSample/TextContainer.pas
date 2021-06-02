unit TextContainer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  System.JSON, Vcl.StdCtrls, Vcl.MPlayer, Vcl.ExtCtrls;

type
  TFrame1 = class(TFrame)
    joinBtn: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure joinBtnClick(Sender: TObject);
  private
  public
    mPlayer : TMediaPlayer;
    memoArray : array of TMemo;
    startTimeArray: array of Integer;
    procedure linkData(jData: TJSONArray; sender: TMediaPlayer);
    procedure memoClick(Sender: TObject);
  end;

implementation

{$R *.dfm}

procedure TFrame1.joinBtnClick(Sender: TObject);
begin
  memoArray[0].Text :=  memoArray[0].Text + memoArray[1].Text;
  if startTimeArray[0] > startTimeArray[1] then
  begin
     startTimeArray[0]:= startTimeArray[1];
  end;
  memoArray[1].Free;
  { safe delete paragraph }
end;

procedure TFrame1.linkData(jData: TJSONArray; sender: TMediaPlayer);
var Memo: TMemo;
    jValue: TJSONValue;
    word: TJSONValue;
    words: String;
    cont : Integer;
begin
  mPlayer := sender;
  setLength(memoArray, 20);
  setLength(startTimeArray, 20);
  cont := 0;

  for jValue in jData do
  begin
    Memo := TMemo.Create(Self);
    Memo.Parent:= Panel2;
    with Memo do
    begin
      Name := 'memoEj'+cont.ToString;
      Parent := Self;
      Align := alBottom;
    end;

    Memo.Lines.Clear;
    words := '';
    for word in jValue.FindValue('words') as TJSONArray do
    begin
          words := words + ' ' + word.FindValue('word').Value;
    end;

    Memo.Text := words;
    Memo.Tag := Integer(cont);
    Memo.OnClick := memoClick;
    memoArray[cont] := Memo;
    startTimeArray[cont] := Round(jValue.GetValue<Double>('from') * 1000);

    cont := cont+1;
  end;
  AutoScroll := true;
end;


procedure TFrame1.memoClick(Sender: TObject);
begin
    if Sender is TMemo then
    begin
      with Sender as TMemo do
        mPlayer.Position := startTimeArray[Tag];
        mPlayer.Play;
    end;
end;
end.
