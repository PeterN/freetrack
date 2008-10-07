unit SimConnect_dm;

interface

uses
  Windows, SysUtils, Classes, SimConnect, ExtCtrls, Dialogs, Math;

type
  Tfs = (fs9, fsX);

  TdmSimConnect = class(TDataModule)
    TimerCnx: TTimer;
    procedure TimerCnxTimer(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    fFs : Tfs;
    hSimConnect: THandle;
    FOnSimConnectFail : TNotifyEvent;
    FAvailable : Boolean;
  public
    procedure Connect( aFS : Tfs);
    procedure Disconnect;
    Procedure UpdateData(Yaw, Pitch, Roll, PanX, PanY, PanZ : single);
    function SimConnectAvail : Boolean;
    property OnSimConnectFail : TNotifyEvent read FOnSimConnectFail write FOnSimConnectFail;
    property Available : Boolean read FAvailable;
    procedure UpdateZoom(panz : single);
  end;

var
  dmSimConnect: TdmSimConnect;

implementation

const
  KEY_ID_MIN                = $00010000;
  KEY_ZOOM_IN               = KEY_ID_MIN + 119;
  KEY_ZOOM_OUT              = KEY_ID_MIN + 120;
  KEY_ZOOM_MINUS            = KEY_ID_MIN + 182;
  KEY_ZOOM_PLUS             = KEY_ID_MIN + 183;
  KEY_ZOOM_IN_FINE          = KEY_ID_MIN + 218;
  KEY_ZOOM_OUT_FINE         = KEY_ID_MIN + 219;

  SIMCONNECT_GROUP_PRIORITY_HIGHEST           = 1;
  SIMCONNECT_EVENT_FLAG_GROUPID_IS_PRIORITY   = 3;


{$R *.dfm}

{ TdmSimConnect }

procedure TdmSimConnect.Connect(aFS: Tfs);
begin
  fFs := aFS;
  case fFs of
    fs9 : ;

    fsX : begin
      if not InitSimConnect then begin
        if Assigned(FOnSimConnectFail) then
          FOnSimConnectFail(Self);
      end else
        TimerCnx.Enabled := True;
    end;

  end;
end;



procedure TdmSimConnect.Disconnect;
begin
  TimerCnx.Enabled := False;
  CloseSimConnect;
end;



procedure TdmSimConnect.TimerCnxTimer(Sender: TObject);
begin
  if SUCCEEDED(SimConnect_Open(hSimConnect, 'Set Data', 0, 0, 0, 0)) then
    TimerCnx.Enabled := False;
end;


procedure TdmSimConnect.UpdateData(Yaw, Pitch, Roll, PanX, PanY, PanZ : single);
begin
  if IsSimConnectInitialized then begin
    Yaw   := -RadToDeg(Yaw);
    Pitch := RadToDeg(Pitch);
    Roll  := RadToDeg(Roll);
    PanX  := -PanX;
    PanY  := PanY;
    PanZ  := -PanZ;
    SimConnect_CameraSetRelative6DOF(hSimConnect, PanX, PanY, PanZ,
                                                  Pitch, Roll, Yaw);

  end;
end;


procedure TdmSimConnect.UpdateZoom(panz : single);
begin
  if panz > 0 then
    SimConnect_TransmitClientEvent(hSimConnect, 0, KEY_ZOOM_IN_FINE, 0, SIMCONNECT_GROUP_PRIORITY_HIGHEST, SIMCONNECT_EVENT_FLAG_GROUPID_IS_PRIORITY)
  else
    SimConnect_TransmitClientEvent(hSimConnect, 0, KEY_ZOOM_OUT_FINE, 0, SIMCONNECT_GROUP_PRIORITY_HIGHEST, SIMCONNECT_EVENT_FLAG_GROUPID_IS_PRIORITY);
end;


procedure TdmSimConnect.DataModuleDestroy(Sender: TObject);
begin
  CloseSimConnect;
end;


function TdmSimConnect.SimConnectAvail: Boolean;
begin
  Result := InitSimConnect;
  FAvailable := Result;
end;

end.
