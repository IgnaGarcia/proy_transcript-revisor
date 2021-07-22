program RevisorProj;

uses
  Vcl.Forms,
  Revisor in 'Revisor.pas' {Revision};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TRevision, Revision);
  Application.Run;
end.
