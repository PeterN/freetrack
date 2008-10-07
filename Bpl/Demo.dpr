program Demo;

uses
  Forms,
  Demo_fm in 'Demo_fm.pas' {fmDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmDemo, fmDemo);
  Application.Run;
end.
