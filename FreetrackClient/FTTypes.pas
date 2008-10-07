unit FTTypes;

interface

uses
  Windows, Registry;

const
  FT_CLIENT_LOCATION = 'Software\Freetrack\FreetrackClient';
  FT_CLIENT_FILENAME = 'FreeTrackClient.Dll';
  FT_MM_DATA = 'FT_SharedMem';
  FREETRACK = 'Freetrack';
  FREETRACK_MUTEX = 'FT_Mutext';

type
  TFreeTrackData = packed record
    DataID : Cardinal;
    CamWidth : Integer;
    CamHeight : Integer;
    // virtual pose
    Yaw : Single;   // positive yaw to the left
    Pitch : Single; // positive pitch up
    Roll : Single;  // positive roll to the left
    X : Single;
    Y : Single;
    Z : Single;
    // raw pose with no smoothing, sensitivity, response curve etc. 
    RawYaw : Single;
    RawPitch : Single;
    RawRoll : Single;
    RawX : Single;
    RawY : Single;
    RawZ : Single;
    // raw points, sorted by Y, origin top left corner
    X1 : Single;
    Y1 : Single;
    X2 : Single;
    Y2 : Single;
    X3 : Single;
    Y3 : Single;
    X4 : Single;
    Y4 : Single;
  end;
  PFreetrackData = ^TFreetrackData;

var
  FTGetData : function (data : PFreeTrackData) : Boolean; stdcall;
  FTGetDllVersion : function : PChar; stdcall;
  // program name used to auto-load profile
  FTReportName : procedure (name : PAnsiChar); stdcall;
  FTProvider : function : PChar; stdcall;

function FTLoadDll : Boolean;
procedure FTCloseDll;


implementation

var
  hdll : THandle;

function FTLoadDll : Boolean;
var
  aKey : TRegistry;
begin
  Result := False;
  aKey := TRegistry.Create(KEY_READ);
  try
    aKey.RootKey := HKEY_CURRENT_USER;
    if aKey.OpenKey(FT_CLIENT_LOCATION, False) then begin
      hdll := LoadLibrary(PChar(aKey.ReadString('Path') + FT_CLIENT_FILENAME));
      if hdll <> 0 then begin
        @FTGetData := GetProcAddress(hdll, 'FTGetData');
        @FTGetDllVersion := GetProcAddress(hdll, 'FTGetDllVersion');
        @FTReportName := GetProcAddress(hdll, 'FTReportName');
        @FTProvider := GetProcAddress(hdll, 'FTProvider');
        Result := True;
      end;
    end;
  finally
    aKey.Free;
  end;
end;


procedure FTCloseDll;
begin
  FreeLibrary(hdll);
end;




end.
