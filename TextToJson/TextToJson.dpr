program TextToJson;

uses
  System.JSON;

function readFile(var path: String) : String;
var
  archivo: Text;
  linea, acum: String;

begin
    assign(archivo, path);
    reset(archivo);

    while not eof(archivo) do
    begin
      readLn(archivo, linea);
      acum := acum + linea;
    end;

    close(archivo);
    result := acum;
end;

var
 input, path: String;
 jData: TJSONValue;

begin
  path := 'D:\Projects\LEL\DelphiRevisor\data\data.json';
  writeLn('Ingrese el path al archivo: ');
  readLn(path);

  input := readFile(path);
  jData := TJSonObject.parseJSONValue(input);
  writeLn(jData.GetValue<integer>('result_index'));

  read;
end.

