program FreetrackTest;

uses
  Forms,
  FTTest in 'FTTest.pas' {Form1},
  FTTypes in 'FTTypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'FreeTrack Interface Test';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
