program TIRfake;

uses
  Forms,
  TIRfake_fm in 'TIRfake_fm.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'TrackIR';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
