unit TextContainer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  System.JSON, Vcl.StdCtrls;

type
  TFrame1 = class(TFrame)
  private
  public
    procedure linkData(jData: TJSONValue);
  end;

implementation

{$R *.dfm}

procedure TFrame1.linkData(jData: TJSONValue);
var Memo: TMemo;
    jValue: TJSONValue;
    jSubValue: TJSONValue;
    jArray: TJSONArray;
    memoArray : array of TMemo;
    cont : Integer;
begin
  setLength(memoArray, 20);
  cont := 0;

  for jValue in jData.FindValue('results') as TJSONArray do
  begin
    Memo := TMemo.Create(Self);
    with Memo do
    begin
      Name := 'memoEj'+cont.ToString;
      Parent := Self;
      Align := alTop;
    end;

    Memo.Lines.Clear;
    jArray := jValue.FindValue('alternatives') as TJSONArray;
    jSubValue := jArray.Items[0] as TJSONValue;
    Memo.Text := jSubValue.FindValue('transcript').Value;

    memoArray[cont] := Memo;
    cont := cont+1
  end;
end;

end.