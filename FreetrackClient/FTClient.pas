unit FTClient;

interface

uses
  Windows, SysUtils, FTTypes;

function FTGetData(data : PFreetrackData) : Boolean; stdcall;
procedure FTReportName(name : PAnsiChar); stdcall;
function FTGetDllVersion : PChar; stdcall;
function FTProvider : PChar; stdcall;


function OpenMapping : Boolean;
procedure DestroyMapping;


implementation

const
  FT_PROGRAMID = 'FT_ProgramID';

var
  hFTMemMap : THandle;
  FTData : PFreetrackData;
  lastDataID : Cardinal;
  FTHandle : PHandle;
  FTProgramName : PAnsiChar;
  FTMutex: THandle;


function FTGetData(data : PFreetrackData) : Boolean;
begin
  Result := False;
  if Assigned(FTData) then begin
    if FTData^.DataID <> lastDataID then begin
      Move(FTData^, data^, SizeOf(TFreetrackData));
      lastDataID := FTData^.DataID;
      Result := True;
    end;
  end else
    OpenMapping;
end;


procedure FTReportName(name : PAnsiChar);
var
  MsgResult : Cardinal;
begin
  if OpenMapping and (WaitForSingleObject(FTMutex, 100) = WAIT_OBJECT_0) then begin
    Move(name^, FTProgramName^, 100);
    SendMessageTimeout(FTHandle^, RegisterWindowMessage(FT_PROGRAMID), 0, 0, 0, 2000, MsgResult);
    ReleaseMutex(FTMutex);
  end;
end;


function FTGetDllVersion : PChar;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
  verString : String;
  dllName : array[0..99] of PChar;
begin
  Result := '';
  GetModuleFilename(HInstance, @dllName, 100);
  VerInfoSize := GetFileVersionInfoSize(@dllName, Dummy);
  if not (VerInfoSize = 0) then begin
    GetMem(VerInfo, VerInfoSize);
    GetFileVersionInfo(@dllName, 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
    with VerValue^ do
    begin
      verString := IntToStr(dwFileVersionMS shr 16);
      verString := verString + '.' + IntToStr(dwFileVersionMS and $FFFF);
      verString := verString + '.' + IntToStr(dwFileVersionLS shr 16);
      verString := verString + '.' + IntToStr(dwFileVersionLS and $FFFF);
      Result := PChar(verString);
    end;
    FreeMem(VerInfo, VerInfoSize);
  end;
end;


function FTProvider : PChar;
begin
  Result := FREETRACK
end;





function OpenMapping : Boolean;
begin
  if hFTMemMap <> 0 then
    Result := True
  else begin
    hFTMemMap := OpenFileMapping(FILE_MAP_ALL_ACCESS, False, FT_MM_DATA);
    if (hFTMemMap <> 0) then begin
      FTData := MapViewOfFile(hFTMemMap, FILE_MAP_ALL_ACCESS, 0, 0, SizeOf(TFreeTrackData) + SizeOf(THandle) + 100);
      FTHandle := Pointer(DWord(FTData) + SizeOf(TFreeTrackData));
      FTProgramName := Pointer(DWord(FTHandle) + SizeOf(THandle));
      FTMutex := OpenMutex(MUTEX_ALL_ACCESS, False, FREETRACK_MUTEX);
    end;
    Result := Assigned(FTData);
  end;
end;


procedure DestroyMapping;
begin
  if FTData <> nil then begin
    UnMapViewofFile(FTData);
    FTData := nil;
  end;

  CloseHandle(FTMutex);
  CloseHandle(hFTMemMap);
  hFTMemMap := 0;
end;


end.
 