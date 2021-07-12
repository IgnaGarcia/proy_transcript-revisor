unit TextEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Memo2: TMemo;
    procedure Open1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Open1Click(Sender: TObject);
var Memo: TMemo;
begin
  OpenDialog1.Execute();
  Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
  showmessage(Memo1.Top.ToString + ' ' + Memo1.Height.ToString);
  showMessage(Memo2.Top.ToString + ' ' + Memo2.Height.ToString);

  Memo := TMemo.Create(Self);
  Memo.Name := 'memoEj';
  Memo.Align := alTop;
  Memo.Top := Memo1.Top + Memo1.Height;
  Memo.Parent := Self;
  showmessage(Memo.Top.ToString + ' ' + Memo.Height.ToString);
end;

end.
