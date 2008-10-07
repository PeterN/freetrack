unit FTTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  StdCtrls, FTTypes, ExtCtrls;

type
  TForm1 = class(TForm)
    timerData: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    laYaw: TLabel;
    laPitch: TLabel;
    laRoll: TLabel;
    laPanX: TLabel;
    laPanY: TLabel;
    laPanZ: TLabel;
    Label6: TLabel;
    laVersion: TLabel;
    Label9: TLabel;
    laDllLoaded: TLabel;
    laDataID: TLabel;
    Label7: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    laRawYaw: TLabel;
    laRawPitch: TLabel;
    laRawRoll: TLabel;
    laRawX: TLabel;
    laRawY: TLabel;
    laRawZ: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label11: TLabel;
    Label26: TLabel;
    laPoint1: TLabel;
    laPoint2: TLabel;
    laPoint3: TLabel;
    laPoint4: TLabel;
    Label18: TLabel;
    laCamResolution: TLabel;
    Label19: TLabel;
    laProgramName: TLabel;
    Label17: TLabel;
    Label22: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    procedure timerDataTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FTData : TFreetrackData;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  PROGRAM_NAME = 'FreeTrack Test';
  PROGRAM_ID = 1337;

procedure TForm1.timerDataTimer(Sender: TObject);
begin
  if FTGetData(@FTData) then begin
    laDataID.Caption := InttoStr(FTData.DataID);
    laYaw.Caption := Format('%.3f', [FTData.Yaw]);
    laPitch.Caption := Format('%.3f', [FTData.Pitch]);
    laRoll.Caption := Format('%.3f', [FTData.Roll]);
    laPanX.Caption := Format('%.3f', [FTData.X]);
    laPanY.Caption := Format('%.3f', [FTData.Y]);
    laPanZ.Caption := Format('%.3f', [FTData.Z]);

    laRawYaw.Caption := Format('%.3f', [FTData.RawYaw]);
    laRawPitch.Caption := Format('%.3f', [FTData.RawPitch]);
    laRawRoll.Caption := Format('%.3f', [FTData.RawRoll]);
    laRawX.Caption := Format('%.3f', [FTData.RawX]);
    laRawY.Caption := Format('%.3f', [FTData.RawY]);
    laRawZ.Caption := Format('%.3f', [FTData.RawZ]);

    laCamResolution.Caption := Format('%d x %d', [FTData.CamWidth, FTData.CamHeight]);

    laPoint1.Caption := Format('(%.1f, %.1f)', [FTData.X1, FTData.Y1]);
    laPoint2.Caption := Format('(%.1f, %.1f)', [FTData.X2, FTData.Y2]);
    laPoint3.Caption := Format('(%.1f, %.1f)', [FTData.X3, FTData.Y3]);
    laPoint4.Caption := Format('(%.1f, %.1f)', [FTData.X4, FTData.Y4]);

  end;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  if FTLoadDll then begin
    timerData.Enabled := True;
    laDllLoaded.Caption := 'True';
    laProgramName.Caption := PROGRAM_NAME;
    FTReportName(PAnsiChar(PROGRAM_NAME));
    laVersion.Caption := FTGetDllVersion;
  end;
end;


procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FTCloseDll;
end;

end.
