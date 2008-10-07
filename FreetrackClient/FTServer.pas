unit FTServer;

interface

uses
  Windows, Forms, SysUtils, Classes, Registry, Dialogs, Controls, DKLang, FTTypes;

type
 TClientDllState = (csRegCheck, csLoadDll, csSelectDll, csDoneOK);

procedure FTUpdateData(dataid : Cardinal; camwidth, camheight : Integer;
                        yaw, pitch, roll, panx, pany, panz : Single;
                        rawYaw, rawPitch, rawRoll, rawPanx, rawPany, rawPanz : Single;
                        x1, y1, x2, y2, x3, y3, x4, y4 : Single);
function FTCreateMapping(handle : THandle) : Boolean;
procedure FTDestroyMapping;
function FTCheckClientDLL : TFileName;
function FTGetProgramName : String;

implementation

var
  hFTMemMap : THandle;
  FTData : PFreeTrackData;
  FTHandle : PHandle;
  FTProgramName : PAnsiChar;
  FTMutex : THandle;

function FTCreateMapping(handle : THandle) : Boolean;
begin
  hFTMemMap := CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0, Sizeof(TFreetrackData) + SizeOf(FTHandle) + SizeOf(FTProgramName), FT_MM_DATA);
  if (hFTMemMap <> 0) and (GetLastError = ERROR_ALREADY_EXISTS) then begin
    CloseHandle(hFTMemMap);
    hFTMemMap := 0;
  end;

  hFTMemMap := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, FT_MM_DATA);
  if (hFTMemMap <> 0) then begin
    FTData := MapViewOfFile(hFTMemMap, FILE_MAP_ALL_ACCESS, 0, 0, SizeOf(TFreeTrackData) + SizeOf(THandle) + 100);
    FTHandle := Pointer(DWord(FTData) + SizeOf(TFreeTrackData));
    FTHandle^ := handle;
    FTProgramName := Pointer(DWord(FTHandle) + SizeOf(THandle));
    FTMutex := CreateMutex(nil, False, FREETRACK_MUTEX);
  end;

  Result := Assigned(FTData);
end;


procedure FTDestroyMapping;
begin
  if FTData <> nil then begin
    UnMapViewofFile(FTData);
    FTData := nil;
  end;

  CloseHandle(hFTMemMap);
  hFTMemMap := 0;
end;


procedure FTUpdateData(dataid : Cardinal; camwidth, camheight : Integer;
                        yaw, pitch, roll, panx, pany, panz : Single;
                        rawYaw, rawPitch, rawRoll, rawPanx, rawPany, rawPanz : Single;
                        x1, y1, x2, y2, x3, y3, x4, y4 : Single);
begin
  if (FTData <> nil) and (WaitForSingleObject(FTMutex, 100) = WAIT_OBJECT_0) then begin
    try
      FTData^.DataID := dataid;
      FTData^.CamWidth := camwidth;
      FTData^.CamHeight := camheight;
      FTData^.Yaw := yaw;
      FTData^.Pitch := pitch;
      FTData^.Roll := roll;
      FTData^.X := panx;
      FTData^.Y := pany;
      FTData^.Z := panz;
      FTData^.RawYaw := rawyaw;
      FTData^.RawPitch := rawpitch;
      FTData^.RawRoll := rawroll;
      FTData^.RawX := rawpanx;
      FTData^.RawY := rawpany;
      FTData^.RawZ := rawpanz;
      FTData^.x1 := x1;
      FTData^.y1 := y1;
      FTData^.x2 := x2;
      FTData^.y2 := y2;
      FTData^.x3 := x3;
      FTData^.y3 := y3;
      FTData^.x4 := x4;
      FTData^.y4 := y4;
    except
    end;
    ReleaseMutex(FTMutex);
  end;
end;


function FTGetProgramName : String;
begin
  Result := FTProgramName;
end;


function FTCheckClientDLL : TFileName;
var
  aLocation : string;
  aKey : TRegistry;
  aDLLHandle : THandle;
  ClientState: TClientDllState;
  LocalDllTested : Boolean;
begin
  LocalDllTested := False;
  aDLLHandle := INVALID_HANDLE_VALUE;
  aKey := TRegistry.Create(KEY_READ or KEY_WRITE);
  try
    ClientState := csRegCheck;

    while true do
      case ClientState of
        csRegCheck : begin
          ClientState := csSelectDll;
          aKey.RootKey := HKEY_CURRENT_USER;
          if aKey.OpenKey(FT_CLIENT_LOCATION, True) then begin
            aLocation := aKey.ReadString('Path');
            aLocation := IncludeTrailingPathDelimiter(aLocation) + FT_CLIENT_FILENAME;
            if FileExists(aLocation) then
              ClientState := csLoadDll;
          end;
        end;

        csLoadDll  : begin
          aDLLHandle := LoadLibrary(PChar(aLocation));
          FTProvider := GetProcAddress(aDLLHandle, 'FTProvider');
          if Assigned(FTProvider) and (FTProvider = FREETRACK) then
            ClientState := csDoneOK
          else if not LocalDllTested then
            ClientState := csSelectDll
          else begin
            aLocation := '';
            Break;
          end;
        end;

        csSelectDll: begin
          if aDLLHandle <> INVALID_HANDLE_VALUE then
            FreeLibrary(aDLLHandle);

          aLocation := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + FT_CLIENT_FILENAME;
          LocalDllTested := True;
          ClientState := csLoadDll;
        end;

        csDoneOK : begin
          if aKey.ReadString('Path') <> ExtractFilePath(aLocation) then
            aKey.WriteString('Path', ExtractFilePath(aLocation));

          Result := aLocation;
          Break;
        end;
      end;

    if aDLLHandle <> INVALID_HANDLE_VALUE then
      FreeLibrary(aDLLHandle);

  finally
    aKey.Free;
  end;
end;





end.
