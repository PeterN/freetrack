unit TIRfake_fm;

interface

uses
  Windows, SysUtils, Forms;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function CheckInstance(filename : String) : Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

const
  TIR_FILENAME = 'TrackIR.exe';

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.ShowMainForm := False;
  if CheckInstance(TIR_FILENAME) then begin
    Application.Terminate;
    Abort;
  end;
  SetProcessWorkingSetSize(GetCurrentProcess, $ffffffff, $ffffffff);
end;

function TForm1.CheckInstance(filename : String) : Boolean;
var
  hSem : THandle;
begin
  // create sémaphore.
  hSem := CreateSemaphore(nil, 0, 1, PChar(filename));

  // Already exist ?
  if (hSem <> 0) and (GetLastError = ERROR_ALREADY_EXISTS) then begin
    CloseHandle(hSem);
    Result := True;
  end else
    Result := False;
end;

end.
