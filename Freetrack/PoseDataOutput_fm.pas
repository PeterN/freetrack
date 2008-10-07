unit PoseDataOutput_fm;

interface

uses
  Windows, SysUtils, Classes, StdCtrls, ExtCtrls, CommCtrl, Math, Parameters,
  Controls, Forms, Messages, Variants, IniFiles, SyncObjs, Dialogs, DirectShow9,
  DKLang, FreeTrackTray, Response, CamManager_fm, HeadDisplay, Buttons,
  ComCtrls, pngimage, DInputMap, Seuillage_inc, uRawInput, BaseClass;

const
  WM_INTERP = WM_USER + 6;
  WM_NOJOY = WM_USER + 7;
  WM_NOSIMCONNECT = WM_USER + 9;
  WM_KEEPIDLE = WM_NOSIMCONNECT + 1;

  TRANS_PI_RANGE = 500/PI;

var
  rawIn : RAWINPUT;
  rawInDev : RAWINPUTDEVICE;

type
  TJoyState = packed record   // packed : all fields aligned bytewise
    Signature : Cardinal;	// (unsigned long), Signature to identify packet to PPJoy IOCTL
    NumAnalog : Byte; // Char
    Analog : array[0..5] of longint; // (signed long)
    NumDigital : Byte;
    Digital : array[0..5] of Byte;
  end;

  // Flight Sim
  TFSState = packed record
    Control : Integer;
    Value : Integer;
  end;

  TResProcess = packed record
    Name : String;
    Handle : THandle;
    Path : String;
  end;

  TUpdateThread = class(TThread)
  protected
    procedure Execute; override;
  end;

  TInterpPose = array[TDOF] of array of Single;

  TPoseDataOutput = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox13: TGroupBox;
    Panel6: TPanel;
    Label89: TLabel;
    Label90: TLabel;
    Label91: TLabel;
    Image24: TImage;
    combMouseXSource: TComboBox;
    combMouseYSource: TComboBox;
    cbMouseAutopan: TCheckBox;
    combMouseWheelSource: TComboBox;
    cbMouseOutput: TCheckBox;
    tbMouseWheelScale: TTrackBar;
    cbMouseAbsolute: TCheckBox;
    Panel12: TPanel;
    Label6: TLabel;
    imPPJoy: TImage;
    udPPJoyController: TUpDown;
    cbJoystickOutput: TCheckBox;
    edPPJoyController: TEdit;
    Panel16: TPanel;
    imTIROutput: TImage;
    imTIRViewsOutput: TImage;
    cbTIROutput: TCheckBox;
    Panel10: TPanel;
    cbSimConnectOutput: TCheckBox;
    Panel19: TPanel;
    imFreetrackOutput: TImage;
    cbFreetrackOutput: TCheckBox;
    TabSheet2: TTabSheet;
    PanelKeyboard: TPanel;
    Image25: TImage;
    Label101: TLabel;
    Label102: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    Label110: TLabel;
    Label111: TLabel;
    butKeyOutputYawNeg: TSpeedButton;
    butKeyOutputPitchPos: TSpeedButton;
    butKeyOutputRollPos: TSpeedButton;
    butKeyOutputPanXPos: TSpeedButton;
    butKeyOutputPanYPos: TSpeedButton;
    butKeyOutputPanZPos: TSpeedButton;
    butKeyOutputYawPos: TSpeedButton;
    butKeyOutputPitchNeg: TSpeedButton;
    butKeyOutputRollNeg: TSpeedButton;
    butKeyOutputPanXNeg: TSpeedButton;
    butKeyOutputPanYNeg: TSpeedButton;
    butKeyOutputPanZNeg: TSpeedButton;
    Image20: TImage;
    Image21: TImage;
    Image31: TImage;
    Image32: TImage;
    Image33: TImage;
    Image34: TImage;
    Image35: TImage;
    Image36: TImage;
    Image37: TImage;
    Image38: TImage;
    Image39: TImage;
    Image40: TImage;
    cbKeymapOutput: TCheckBox;
    tbKeyOutputYawThreshold: TTrackBar;
    tbKeyOutputPitchThreshold: TTrackBar;
    tbKeyOutputRollThreshold: TTrackBar;
    tbKeyOutputPanXThreshold: TTrackBar;
    tbKeyOutputPanYThreshold: TTrackBar;
    tbKeyOutputPanZThreshold: TTrackBar;
    cbKeyOutputPitchHold: TCheckBox;
    cbKeyOutputRollHold: TCheckBox;
    cbKeyOutputPanXHold: TCheckBox;
    cbKeyOutputPanYHold: TCheckBox;
    cbKeyOutputPanZHold: TCheckBox;
    ClearKeyOutputs: TButton;
    Panel1: TPanel;
    cbFSOutput: TCheckBox;
    laTIRViews: TLabel;
    PressedUITimer: TTimer;
    DKLanguageController1: TDKLanguageController;
    cbKeyOutputYawHold: TCheckBox;
    procedure cbOutputClick(Sender: TObject);
    procedure tbMouseWheelScaleChange(Sender: TObject);
    procedure udPPJoyControllerClick(Sender: TObject; Button: TUDBtnType);
    procedure tbKeyOutputThresholdChange(Sender: TObject);
    procedure cbKeyOutputHoldClick(Sender: TObject);
    procedure cbMouseModeClick(Sender: TObject);
    procedure combMouseSourceSelect(Sender: TObject);
    procedure GestSimConnectFail(Sender: TObject);
    procedure butKeyPollClick(Sender: TObject);
    procedure ClearKeyOutputsClick(Sender: TObject);
    procedure PressedUITimerTimer(Sender: TObject);
    procedure DKLanguageController1LanguageChanged(Sender: TObject);
  private
    fOwner : TForm;
    index_interpdata : Integer;

    simulatedKeyInputs : array[TDOF] of TInput;
    simulatedMouseInput : TInput;
    FrawInHandle : THandle;
    lastkeyDown : array[TDOF] of TKeyOutputDown;
    FPressedKeys : String;
    MouseState : array[TMouseSource] of Integer;

    PPJoyHandle : THandle;
    JoyState : TJoyState;
    FSState : array[TDOF] of TFSState;
    FSZoom : Word;

    lastSector : Integer;

    ScreenPoints : TArrayOfPoint2D32f;
    interp_pose, interp_rawpose : TInterpPose;
    PreviousPose, PreviousRawPose, FRespMax : TPose;

    eventUpdateOutput, eventUpdateComplete : TEvent;
    UpdateOutputThread : TUpdateThread;
    UpdateToken : array[0..3] of Cardinal;
    UpdateCompleteToken : Cardinal;
    numInterpSamples : Integer;
    hsemUpdate : THandle;
    localRefClock : TBCBaseReferenceClock;
    baseClock : TBCUnknown;

    procTIRDummy : TResProcess;

    dataID : smallint;
    Centering : Boolean;

    FTIRDll, FFreetrackDll : TFilename;

    FOnProgramID, FOnRegisterProgramHandle, FOnUnRegisterProgramHandle : UINT;


    KeyOutput : array[TDOF] of array[TKeyOutput] of TKeyStruct;

    ArraybutKeyOutput : array[TDOF] of array[TKeyOutput] of TSpeedButton;
    ArraycomboMouseSource: array[TMouseSource] of TComboBox;
    ArraytbKeyOutputThreshold: array[TDOF] of TTrackBar;
    ArraycbKeyOutputHold : array[TDOF] of TCheckBox;

    procedure StartResourceProcess(var proc : TResProcess);
    procedure EndResourceProcess(proc : TResProcess);
    procedure SetRespMax(aDOF : TDOF; Value : Single);
    procedure SetRawInHandle(Value : THandle);
    procedure DisplayNOJOY(var MSG : TMessage); message WM_NOJOY;
    procedure DisplayNOSIMCONNECT(var MSG : TMessage); message WM_NOSIMCONNECT;
    function GetProgramName : String;

    procedure ProfileDirty;
    procedure UpdateMouse;
    procedure UpdateJoystick;
    procedure UpdateKeyboard;
    procedure UpdateFSUIPC;
    procedure UpdateSimConnect;
  public
    //interp : Integer;
    ArraycbOutput : array[TOutput] of TCheckbox;
    Constructor Create(AOwner : TComponent); override;
    Destructor Destroy; override;
    procedure InitializeJoystick(joyNumber : Integer);
    procedure InterpolatePose(pose : TPose; RefClock : IReferenceClock);
    procedure InterpolateRawPose(pose : TPose);
    procedure UpdatePose(pose : TPose);
    procedure UpdateRawPose(pose : TPose);
    procedure UpdatePoints(points : TArrayOfPoint2D32f);
    procedure UpdateOutput;
    procedure UpdateKeyOutputs(Clear : Boolean);
    procedure KeyOutputRelease;
    procedure Stop;
    procedure CenterInterp;
    procedure LoadGUIProfile;
    property ProgramName : String read GetProgramName;
    property RespMax[aDOF : TDOF] : Single write SetRespMax;
    property FreetrackDll : TFilename read FFreetrackDll;
    property TIRDll : TFilename read FTIRDll;
    property OnProgramID : UINT read FOnProgramID;
    property OnRegisterProgramHandle : UINT read FOnRegisterProgramHandle;
    property OnUnRegisterProgramHandle : UINT read FOnUnRegisterProgramHandle;
    property PressedKeys : String read FPressedKeys;
    property RawInHandle : THandle write SetRawInHandle;
  end;


var
  PoseDataOutput : TPoseDataOutput;

implementation

{$R *.dfm}

uses
  SimConnect_dm, FPCUser, ProfilesMngr_fm, FTServer, TIRServer, TIRTypes;


const
  //joystick
  JOYSTICK_STATE_V1	= $53544143;
  FILE_DEVICE_UNKNOWN = 34;
  METHOD_BUFFERED = 0;
  FILE_ANY_ACCESS = 0;
  FUNC = 0;
  IOCTL = (FILE_DEVICE_UNKNOWN SHL 16) or (FUNC SHL 14) or (METHOD_BUFFERED SHL 2) or FILE_ANY_ACCESS;

  MOUSE_REL_SCALE = 500;
  MOUSE_REL_WHEEL_SCALE = 50000;
  MOUSE_AP_WHEEL_SCALE = 300;

  KEYEVENTF_KEYUP = $2;
  KEYEVENTF_UNICODE = $4;
  KEYEVENTF_SCANCODE = $8;

  TRACKIR = 'TrackIR';
  EXE = '.exe';

constructor TPoseDataOutput.Create(AOwner : TComponent);
var
  aDOF : TDOF;
begin
  Inherited;

  ArraycbOutput[outFreetrack] := cbFreetrackOutput;
  ArraycbOutput[outTIR] := cbTIROutput;
  ArraycbOutput[outMouse] := cbMouseOutput;
  ArraycbOutput[outJoy] := cbJoystickOutput;
  ArraycbOutput[outSimConnect] := cbSimConnectOutput;
  ArraycbOutput[outKey] := cbKeymapOutput;
  ArraycbOutput[outFS] := cbFSOutput;

  ArraybutKeyOutput[dofYaw][keyoutPos] := butKeyOutputYawPos;
  ArraybutKeyOutput[dofYaw][keyoutNeg]  := butKeyOutputYawNeg;
  ArraybutKeyOutput[dofPitch][keyoutPos] := butKeyOutputPitchPos;
  ArraybutKeyOutput[dofPitch][keyoutNeg] := butKeyOutputPitchNeg;
  ArraybutKeyOutput[dofRoll][keyoutPos] := butKeyOutputRollPos;
  ArraybutKeyOutput[dofRoll][keyoutNeg] := butKeyOutputRollNeg;
  ArraybutKeyOutput[dofPanX][keyoutPos] := butKeyOutputPanXPos;
  ArraybutKeyOutput[dofPanX][keyoutNeg] := butKeyOutputPanXNeg;
  ArraybutKeyOutput[dofPanY][keyoutPos] := butKeyOutputPanYPos;
  ArraybutKeyOutput[dofPanY][keyoutNeg] := butKeyOutputPanYNeg;
  ArraybutKeyOutput[dofPanZ][keyoutPos] := butKeyOutputPanZPos;
  ArraybutKeyOutput[dofPanZ][keyoutNeg] := butKeyOutputPanZNeg;

  ArraytbKeyOutputThreshold[dofYaw] := tbKeyOutputYawThreshold;
  ArraytbKeyOutputThreshold[dofPitch] := tbKeyOutputPitchThreshold;
  ArraytbKeyOutputThreshold[dofRoll] := tbKeyOutputRollThreshold;
  ArraytbKeyOutputThreshold[dofPanX] := tbKeyOutputPanXThreshold;
  ArraytbKeyOutputThreshold[dofPanY] := tbKeyOutputPanYThreshold;
  ArraytbKeyOutputThreshold[dofPanZ] := tbKeyOutputPanZThreshold;

  ArraycbKeyOutputHold[dofYaw] := cbKeyOutputYawHold;
  ArraycbKeyOutputHold[dofPitch] := cbKeyOutputPitchHold;
  ArraycbKeyOutputHold[dofRoll] := cbKeyOutputRollHold;
  ArraycbKeyOutputHold[dofPanX] := cbKeyOutputPanXHold;
  ArraycbKeyOutputHold[dofPanY] := cbKeyOutputPanYHold;
  ArraycbKeyOutputHold[dofPanZ] := cbKeyOutputPanZHold;

  ArraycomboMouseSource[mouseX] := combMouseXSource;
  ArraycomboMouseSource[mouseY] := combMouseYSource;
  ArraycomboMouseSource[mouseWheel] := combMouseWheelSource;

  {cbFreetrackOutput.Hint := DKLangConstW('S_HINT_FTSERVER');
  imFreetrackOutput.Hint := DKLangConstW('S_HINT_FTSERVER');
  cbTIROutput.HInt := DKLangConstW('S_HINT_TRACKIR');
  imTIROutput.Hint := DKLangConstW('S_HINT_TRACKIR');
  imTIRViewsOutput.Hint := DKLangConstW('S_HINT_TIRVIEWS');}

  SetLength(ScreenPoints, 4);

  PageControl1.TabIndex := 0;
  fOwner := AOwner as TForm;

  FFreetrackDll := FTCheckClientDLL;
  if FFreetrackDll <> '' then
    FTCreateMapping(fOwner.Handle);

  FTIRDll := TIRCheckClientDLL;
  if FTIRDll <> '' then
    TIRCreateMapping(fOwner.Handle);

  for aDOF := low(TDOF) to High(TDOF) do begin
    setlength(interp_pose[aDOF], 4);  // max 4 interpolations
    setlength(interp_rawpose[aDOF], 4);
  end;

  simulatedMouseInput.Itype := INPUT_MOUSE;
  for aDOF := Low(TDOF) to High(TDOF) do
    simulatedKeyInputs[aDOF].Itype := INPUT_KEYBOARD;

  // register mouse for WM_INPUT messages
  {rawInDev.usUsagePage := $01;
  rawInDev.usUsage := $02;
  rawInDev.dwFlags := RIDEV_INPUTSINK; // receive messages while in background
  rawInDev.hwndTarget := fOwner.Handle;
  RegisterRawInputDevices(@rawInDev, 1, SizeOf(rawInDev)); }

  //localRefClock.CreateFromFactory();
  //localRefClock.Create('baseClock', nil, hres, nil);

  JoyState.Signature := JOYSTICK_STATE_V1;
  JoyState.NumAnalog := 6;
  JoyState.NumDigital := 0;

  // FSUIPC offsets
  FSState[dofYaw].Control := 66504;
  FSState[dofPitch].Control := 66503;
  FSState[dofRoll].Control := 66505;

  eventUpdateOutput := TEvent.Create(nil, FALSE, FALSE, 'UpdateOutput');
  eventUpdateComplete := TEvent.Create(nil, FALSE, FALSE, 'UpdateComplete');
  UpdateOutputThread := TUpdateThread.Create(True);
  SetThreadPriority(UpdateOutputThread.Handle, REALTIME_PRIORITY_CLASS);

  FOnProgramID := RegisterWindowMessage(FT_PROGRAMID);
  FOnRegisterProgramHandle := RegisterWindowMessage(FT_REGISTER_PROGRAM_HANDLE);
  FOnUnregisterProgramHandle := RegisterWindowMessage(FT_UNREGISTER_PROGRAM_HANDLE);

  // create and run dummy TrackIR.exe (for Grand Prix Legends)
  procTIRDummy.Name := TRACKIR;
  StartResourceProcess(procTIRDummy);

   // disable interface options if unavailable
  if FFreetrackDll = '' then begin
    imFreetrackOutput.Hint := DKLangConstW('S_HINT_NO_FTCLIENT_DLL');
    cbFreetrackOutput.Enabled := False;
    cbFreetrackOutput.Checked := False;
  end;
  if FTIRDll = '' then begin
    imTIROutput.Hint := DKLangConstW('S_HINT_NO_NPCLIENT_DLL');
    cbTIROutput.Enabled := False;
    cbTIROutput.Checked := False;
  end;
  // test TIRViews.dll existence
  if not TIRViewsConnect then
    laTIRViews.Enabled := False
  else
    laTIRViews.Enabled := True;

  PressedUITimer.Enabled := True;

  if not dmSimConnect.SimConnectAvail then
    GestSimConnectFail(Self);
end;


destructor TPoseDataOutput.Destroy;
begin
    // ok to close FSUIPC if already closed
    FSUIPC_Close;

    TIRViewsDisconnect;

    eventUpdateOutput.Destroy;
    eventUpdateComplete.Destroy;
    CloseHandle(PPJoyHandle);
    UpdateOutputThread.Suspend;

    FTDestroyMapping;
    TIRDestroyMapping;

    EndResourceProcess(procTIRDummy);
    Inherited;
end;


procedure TPoseDataOutput.LoadGUIProfile;
var
  aDOF : TDOF;
  aKeyOutput : TKeyOutput;
  aMouseSource : TMouseSource;
  butUD : TUDBtnType;
  aOutput : TOutput;
begin

  for aOutput := Low(TOutput) to High(TOutput) do
    if ArraycbOutput[aOutput].Enabled then begin
      ArraycbOutput[aOutput].Checked := MyProfile.Output[aOutput];
      cbOutputClick(ArraycbOutput[aOutput]);
    end;

  cbMouseAbsolute.Checked := MyProfile.MouseAbsolute;

  butUD := btNext;
  udPPJoyController.Position := MyProfile.PPJoyControllerNumber;
  udPPJoyControllerClick(Self, butUD);

  for aDOF := Low(TDOF) to High(TDOF) do begin
    ArraytbKeyOutputThreshold[aDOF].Position := MyProfile.KeyOutputThresholds[aDOF];
    ArraycbKeyOutputHold[aDOF].Checked := MyProfile.KeyOutputHold[aDOF];
    for aKeyOutput := Low(TKeyOutput) to High(TKeyOutput) do begin
      KeyOutput[aDOF][aKeyOutput].Name := MyProfile.KeyOutputs[aDOF, aKeyOutput];
      ArraybutKeyOutput[aDOF][aKeyOutput].Caption := KeyOutput[aDOF][aKeyOutput].Name;
      DInput.Str2CodeOutput(KeyOutput[aDOF][aKeyOutput]);
    end;
  end;

  for aMouseSource := Low(TMouseSource) to High(TMouseSource) do
    if MyProfile.MouseAxisEnabled[aMouseSource] then
      ArraycomboMouseSource[aMouseSource].ItemIndex := Ord(MyProfile.MouseSource[aMouseSource]) + 1
    else
      ArraycomboMouseSource[aMouseSource].ItemIndex := 0;

  cbMouseAutopan.Checked := MyProfile.MouseAutopan;
  tbMouseWheelScale.Position := MyProfile.MouseWheelScale;
end;



procedure TPoseDataOutput.StartResourceProcess(var proc : TResProcess);
var
  winTemp : PAnsiChar;
  aProcessInformation : TProcessInformation;
  ExeFile : TFileStream;
  RStream : TResourceStream;
  aStartupInfo : TStartupInfo;
begin
  RStream := TResourceStream.Create(hInstance, proc.Name, 'EXE');
  GetMem(winTemp, 100);
  GetTempPath(100, winTemp);
  proc.Path := winTemp;
  winTemp := PChar(proc.Path + proc.Name + EXE);
  if not FileExists(winTemp) then begin
    ExeFile := TFileStream.Create(winTemp, fmCreate);
    ExeFile.CopyFrom(RStream, RStream.Size);
    RStream.Free;
    ExeFile.Free;
  end;

  ZeroMemory(@aStartupInfo, Sizeof(_STARTUPINFOA));
  aStartupInfo.cb := Sizeof(_STARTUPINFOA);
  aStartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  aStartupInfo.wShowWindow := SW_SHOWNORMAL;

  if not CreateProcess(winTemp, nil, nil, nil, False, IDLE_PRIORITY_CLASS, nil, nil, aStartupInfo, aProcessInformation) then
    ShowMessage(DKLangConstW('S_ERROR_DUMMYPROCESS'));

  proc.Handle := aProcessInformation.hProcess;
end;


procedure TPoseDataOutput.EndResourceProcess(proc : TResProcess);
var
  DummyExitCode : Cardinal;
begin
  // stop resource process
  if GetExitCodeProcess(proc.Handle, DummyExitCode) then
    TerminateProcess(proc.Handle, DummyExitCode);
  Sleep(100);

  // delete resource file
  DeleteFile(proc.Path + proc.Name + EXE);
  Sleep(10);
end;


function TPoseDataOutput.GetProgramName : String;
begin
  Result := FTGetProgramName;
end;


procedure TPoseDataOutput.InterpolatePose(pose : TPose; RefClock : IReferenceClock);
var
  CurRefCount, AdviseTime : Int64;
  aDOF : TDOF;
  delta : TPose;
  i : Integer;
begin
  if UpdateOutputThread.Suspended then UpdateOutputThread.Resume;

  // wait for all interpolations to be sent and average frame time elapsed before building/sending
  // new ones, only do when minimized so that it doesn't interfere with frame rate measurements.
  //if aFreeTrackTray.Visible then
    WaitForSingleObject(eventUpdateComplete.Handle, 100);

  if (aCamManager.CamState = camPlaying) and not Centering then begin  // prevent extra frames after pause
    RefClock.GetTime(CurRefCount);

    {interpolate data linearly between current and previous pose data,
    result stored in array and can be used until next pose update }
    for aDOF := Low(TDOF) to High(TDOF) do begin
      PreviousPose[aDOF] := interp_pose[aDOF, (MyConfig.InterpMultiplier - 1)];
      delta[aDOF] := pose[aDOF] - PreviousPose[aDOF];
      for i := 1 to MyConfig.InterpMultiplier do
        interp_pose[aDOF, i - 1] := PreviousPose[aDOF] + (i/MyConfig.InterpMultiplier) * delta[aDOF];
    end;
    index_interpdata := 0;
    numInterpSamples := MyConfig.InterpMultiplier;

    {if UpdateToken[0] = 0 then begin
      hSemUpdate := CreateSemaphore(nil, 0, $7FFFFFFF, nil);
      RefClock.GetTime(CurRefCount);
      AdviseTime := round((1/(MyConfig.InterpWebcamFPS))* 10000000 * (1/MyConfig.InterpMultiplier)); // use video manager fps
      RefClock.AdvisePeriodic(CurRefCount, AdviseTime, hSemUpdate, UpdateToken[0]);
    end;  }

    // set update events
    AdviseTime := round((1/(MyConfig.InterpWebcamFPS)) * 10000000 * (1/MyConfig.InterpMultiplier)); // use video manager fps
    for i := 1 to MyConfig.InterpMultiplier do begin
      RefClock.AdviseTime(CurRefCount, i * AdviseTime, eventUpdateOutput.Handle, UpdateToken[i]);
    end;

    // prevent premature frames
    //RefClock.AdviseTime(CurRefCount, AdviseTime * (i + 1), eventUpdateComplete.Handle, UpdateCompleteToken);
  end;
  Centering := False;
end;


procedure TPoseDataOutput.InterpolateRawPose(pose : TPose);
var
  aDOF : TDOF;
  delta : TPose;
  i : Integer;
begin
  {interpolate data linearly between current and previous pose data,
  result stored in array and can be used until next pose update }
  for aDOF := Low(TDOF) to High(TDOF) do begin
    PreviousRawPose[aDOF] := interp_rawpose[aDOF, (MyConfig.InterpMultiplier - 1)];
    delta[aDOF] := pose[aDOF] - PreviousRawPose[aDOF];
    for i := 0 to (MyConfig.InterpMultiplier - 1) do
      interp_rawpose[aDOF, i] := PreviousRawPose[aDOF] + (1 / MyConfig.InterpMultiplier) * (i+1) * delta[aDOF];
  end;
end;


procedure TPoseDataOutput.UpdatePose(pose : TPose);
var
  aDOF : TDOF;
begin
  //if aFreeTrackTray.Visible then
   // WaitForSingleObject(eventUpdateComplete.Handle, 100);
  if aCamManager.CamState = camPlaying then begin

  if UpdateOutputThread.Suspended then UpdateOutputThread.Resume;

  index_interpdata := 0;
  for aDOF := Low(TDOF) to High(TDOF) do begin
    PreviousPose[aDOF] := interp_pose[aDOF][0];
    interp_pose[aDOF][0] := pose[aDOF];
  end;
  numInterpSamples := 1;

  eventUpdateOutput.SetEvent;
  end;

  {localRefClock.GetTime(CurRefCount);
  AdviseTime := round((1/(100)) * 10000000);
  localRefClock.AdviseTime(CurRefCount, AdviseTime, eventUpdateOutput.Handle, UpdateToken[0]);    }

  // prevent premature frames
  //RefClock.AdviseTime(CurRefCount, AdviseTime, eventUpdateComplete.Handle, UpdateCompleteToken);
end;

procedure TPoseDataOutput.UpdateRawPose(pose : TPose);
var
  aDOF : TDOF;
begin
  for aDOF := Low(TDOF) to High(TDOF) do
    interp_rawpose[aDOF][0] := pose[aDOF];
end;


procedure TPoseDataOutput.UpdatePoints(points : TArrayOfPoint2D32f);
var
  i : Integer;
begin
  for i := 0 to 3 do
    Screenpoints[i] := points[i];
end;


procedure TPoseDataOutput.UpdateOutput;
begin

  // data identifier - if it doesn't change for some time the host application can reset view
  if MyProfile.MaintainPausedData or (aCamManager.CamState = camPlaying) then
    if dataID < High(dataID) then
      Inc(dataID)
    else
      dataID := 0;

  //FreeTrack
  if MyProfile.Output[outFreetrack] then
    FTUpdateData( dataID,
                  aCamManager.SensorSize.Right,
                  aCamManager.SensorSize.Bottom,
                  interp_pose[dofYaw][index_interpdata],
                  interp_pose[dofPitch][index_interpdata],
                  interp_pose[dofRoll][index_interpdata],
                  interp_pose[dofPanX][index_interpdata] * TRANS_PI_RANGE,
                  interp_pose[dofPanY][index_interpdata] * TRANS_PI_RANGE,
                  interp_pose[dofPanZ][index_interpdata] * TRANS_PI_RANGE,
                  interp_rawpose[dofYaw][index_interpdata],
                  interp_rawpose[dofPitch][index_interpdata],
                  interp_rawpose[dofRoll][index_interpdata],
                  interp_rawpose[dofPanX][index_interpdata],
                  interp_rawpose[dofPanY][index_interpdata],
                  interp_rawpose[dofPanZ][index_interpdata],
                  ScreenPoints[0].X,
                  ScreenPoints[0].Y,
                  ScreenPoints[1].X,
                  ScreenPoints[1].Y,
                  ScreenPoints[2].X,
                  ScreenPoints[2].Y,
                  ScreenPoints[3].X,
                  ScreenPoints[3].Y);


  // TIR
  if MyProfile.Output[outTIR] then
    TIRUpdateData(interp_pose[dofYaw][index_interpdata] * AXIS_RAD_SCALE,
                  -interp_pose[dofPitch][index_interpdata] * AXIS_RAD_SCALE,
                  interp_pose[dofRoll][index_interpdata] * AXIS_RAD_SCALE,
                  1.5 * interp_pose[dofPanX][index_interpdata] * AXIS_RAD_SCALE,
                  1.5 * interp_pose[dofPanY][index_interpdata] * AXIS_RAD_SCALE,
                  2.5 * interp_pose[dofPanZ][index_interpdata] * AXIS_RAD_SCALE,
                  dataID);


  // PPJoy joystick 
  if (PPJoyHandle <> 0) and MyProfile.Output[outJoy] then
    UpdateJoystick;

  // mouse
  // only send mouse data when all points visible so that mouse emulation can be easily disabled
  if cbMouseOutput.Enabled and MyProfile.Output[outMouse] and (aFreeTrackTray.State = tsON_Ok) then
    UpdateMouse;

    // keyboard
  if MyProfile.Output[outKey] and (aFreeTrackTray.State = tsON_Ok)  then
    UpdateKeyboard;

  // SimConnect (TIRViews is capable of SimConnect)
  if MyProfile.Output[outSimConnect] then
    UpdateSimConnect;

  // FSUIPC (FS2002 and FS2004)
  if MyProfile.Output[outFS] and (aFreeTrackTray.State = tsON_Ok) then
    UpdateFSUIPC;

  if not aFreeTrackTray.Visible then
    PostMessage(Handle, WM_KEEPIDLE, 0, 0);
    if HeadPanel <> nil then
      HeadPanel.Attitude( interp_pose[dofYaw][index_interpdata],
                          interp_pose[dofPitch][index_interpdata],
                          interp_pose[dofRoll][index_interpdata],
                          interp_pose[dofPanX][index_interpdata],
                          interp_pose[dofPanY][index_interpdata],
                          interp_pose[dofPanZ][index_interpdata]);

  if index_interpdata < (numInterpSamples - 1) then
    inc(index_interpdata)
  else
    eventUpdateComplete.SetEvent;

end;


procedure TPoseDataOutput.UpdateMouse;
var
  mouseData : array[TMouseSource] of Single;
  aMouseSource : TMouseSource;
begin
  if MyProfile.MouseAutopan then begin
    simulatedMouseInput.mi.dx := ifthen(MyProfile.MouseAxisEnabled[mouseX], 1, 0) * ifthen(MyProfile.MouseSource[mouseX] = dofYaw, -1, 1) * ifthen(MyProfile.MouseSource[mouseX] = dofPanX, -1, 1) * round(30  * interp_pose[MyProfile.MouseSource[mouseX]][index_interpdata] * INV_PI);
    simulatedMouseInput.mi.dy := ifthen(MyProfile.MouseAxisEnabled[mouseY], 1, 0) * -round(30 * interp_pose[MyProfile.MouseSource[mouseY]][index_interpdata] * INV_PI);
    mouseData[mouseWheel] := MOUSE_AP_WHEEL_SCALE * interp_pose[MyProfile.MouseSource[mouseWheel]][index_interpdata] * INV_PI;
  end else begin
    // absolute
    if MyProfile.MouseAbsolute then begin
      simulatedMouseInput.mi.dwFlags := MOUSEEVENTF_MOVE or MOUSEEVENTF_WHEEL or MOUSEEVENTF_ABSOLUTE;
      mouseData[mouseX] := AXIS_SCALE_DBL - AXIS_SCALE_DBL * (interp_pose[MyProfile.MouseSource[mouseX]][index_interpdata] * INV_PI);
      mouseData[mouseY] := AXIS_SCALE_DBL - AXIS_SCALE_DBL * (interp_pose[MyProfile.MouseSource[mouseY]][index_interpdata] * INV_PI);

      // track mouse state so axes can be disabled
      for aMouseSource := mouseX to mouseY do
        if MyProfile.MouseAxisEnabled[aMouseSource] then
          MouseState[aMouseSource] := round(mouseData[aMouseSource]);
          
      simulatedMouseInput.mi.dx := MouseState[mouseX];
      simulatedMouseInput.mi.dy := MouseState[mouseY];

      if index_interpdata = 0 then
        mouseData[mouseWheel] := MOUSE_REL_WHEEL_SCALE * (interp_pose[MyProfile.MouseSource[mouseWheel]][0] - PreviousPose[MyProfile.MouseSource[mouseWheel]]) * INV_PI
      else
        mouseData[mouseWheel] := 0;
    end else begin
      // relative
      simulatedMouseInput.mi.dwFlags := MOUSEEVENTF_MOVE or MOUSEEVENTF_WHEEL;
      if index_interpdata = 0 then begin
        mouseData[mouseX] := MOUSE_REL_SCALE * (interp_pose[MyProfile.MouseSource[mouseX]][index_interpdata] - PreviousPose[MyProfile.MouseSource[mouseX]])* INV_PI;
        mouseData[mouseY] := MOUSE_REL_SCALE * (interp_pose[MyProfile.MouseSource[mouseY]][index_interpdata] - PreviousPose[MyProfile.MouseSource[mouseY]])* INV_PI;
        mouseData[mouseWheel] := MOUSE_REL_WHEEL_SCALE * (interp_pose[MyProfile.MouseSource[mouseWheel]][0] - PreviousPose[MyProfile.MouseSource[mouseWheel]])* INV_PI;
      end else begin
        mouseData[mouseX] := MOUSE_REL_SCALE * (interp_pose[MyProfile.MouseSource[mouseX]][index_interpdata] - interp_pose[MyProfile.MouseSource[mouseX]][index_interpdata - 1])* INV_PI;
        mouseData[mouseY] := MOUSE_REL_SCALE * (interp_pose[MyProfile.MouseSource[mouseY]][index_interpdata] - interp_pose[MyProfile.MouseSource[mouseY]][index_interpdata - 1])* INV_PI;
        mouseData[mouseWheel] := 0;
      end;
      simulatedMouseInput.mi.dx := ifthen(MyProfile.MouseAxisEnabled[mouseX], 1, 0) * ifthen(MyProfile.MouseSource[mouseX] = dofPanX, -1, 1) * -round(ifthen((abs(mouseData[mouseX]) > 0.2) and (abs(mouseData[mouseX]) < 1) , sign(mouseData[mouseX]), mouseData[mouseX]));
      simulatedMouseInput.mi.dy := ifthen(MyProfile.MouseAxisEnabled[mouseY], 1, 0) * -round(ifthen((abs(mouseData[mouseY]) > 0.2) and (abs(mouseData[mouseY]) < 1) , sign(mouseData[mouseY]), mouseData[mouseY]));
    end;
  end;
  simulatedMouseInput.mi.mousedata := dword(ifthen(MyProfile.MouseAxisEnabled[mouseWheel], 1, 0) * round( 0.002 * MyProfile.MouseWheelScale * (mouseData[mouseWheel])));
  SendInput(1, simulatedMouseInput, sizeof(TInput));
end;


procedure TPoseDataOutput.UpdateJoystick;
var
  aDOF : TDOF;
  result, error : Cardinal;
begin
  for aDOF := Low(TDOF) to High(TDOF) do
    JoyState.Analog[Ord(aDOF)] := Min(AXIS_SCALE_DBL, (Max(1, round(AXIS_SCALE * (interp_pose[aDOF][index_interpdata] * INV_PI + 1)))));

  if not DeviceIoControl(PPJoyHandle, IOCTL , @JoyState, sizeof(JoyState), nil, 0, result, nil) then begin
    error := GetLastError;
    MessageBeep(MB_ICONEXCLAMATION);
    PostMessage(Handle, WM_NOJOY, 0, 0);
    if error = 2 then
      MessageDlg(DKLangConstW('S_ERROR_PPJOY_DEVICE_DELETED'), mtError, [mbOK], 0)
    else if error <> 6 then // error 6 occurs when selected ppjoy joystick does not exist
      MessageDlg(DKLangConstW('S_ERROR_PPJOY') + ' ' + InttoStr(error), mtError, [mbOK], 0);
  end;
end;


procedure TPoseDataOutput.UpdateKeyboard;
var
  aDOF : TDOF;
  currentSector : Integer;
  keyDown : TKeyOutputDown;
begin

  // make sure keys aren't simulated during assignment (timerkey disabled)
  if (index_interpdata = 0) and (fOwner.FindComponent('timerKey') as TTimer).Enabled then begin
    for aDOF := Low(TDOF) to High(TDOF) do begin
      //if MyProfile.KeyOutputHold[aDOF] then begin
        currentSector := 0;
        if interp_pose[aDOF][index_interpdata] > 0.01 * MyProfile.KeyOutputThresholds[aDOF] * FRespMax[aDOF] then
          keyDown := kodPos
        else if interp_pose[aDOF][index_interpdata] < -0.01 * MyProfile.KeyOutputThresholds[aDOF] * FRespMax[aDOF] then
          keyDown := kodNeg
        else
          keyDown := kodNone;
      //end else begin
        {if  (abs(interp_pose[aDOF][index_interpdata]) > 0.01 * MyProfile.KeyOutputThresholds[aDOF] * FRespMax[dofYaw]) then begin
          for i := 1 to 8 do
            if  (interp_pose[aDOF][index_interpdata] > (0.01 * MyProfile.KeyOutputThresholds[aDOF]) * FRespMax[dofYaw]) and
                (interp_pose[aDOF][index_interpdata] < (0.01 * MyProfile.KeyOutputThreshwqolds[aDOF] + 0.01 * i) * FRespMax[dofYaw]) then begin
              keyDown := kodPos;
              currentSector := i;
            end else if (interp_pose[aDOF][index_interpdata] < -(0.01 * MyProfile.KeyOutputThresholds[aDOF]) * FRespMax[dofYaw]) and
                        (interp_pose[aDOF][index_interpdata] > -(0.01 * MyProfile.KeyOutputThresholds[aDOF] + 0.01 * i) * FRespMax[dofYaw]) then begin
              keyDown := kodNeg;
              currentSector := -i;
            end;
        end else begin
          keyDown := kodNone;
          currentSector := 0;
        end;    }
      //end;

      {Simulated keydown events appear only as a single key press in text fields because the keyboard repeat count,
      which sends multiple keydown messages, is not simulated. However it works fine in programs that expect
      only a single keydown event when the key is held, like games. }
      if (keyDown <> lastkeyDown[aDOF]) {or not MyProfile.KeyOutputHold[aDOF]} then begin
        // release last key
        if lastkeyDown[aDOF] <> kodNone then begin
          // need to use scancode for simulated keypress to be recognised by games
          simulatedKeyInputs[aDOF].ki.dwFlags := KEYEVENTF_SCANCODE or KEYEVENTF_KEYUP;
          ArraybutKeyOutput[aDOF][TKeyOutput(Ord(lastkeyDown[aDOF]) - 1)].Down := False;
          simulatedKeyInputs[aDOF].ki.wScan := KeyOutput[aDOF][TKeyOutput(Ord(lastkeyDown[aDOF]) - 1)].Key;
          if simulatedKeyInputs[aDOF].ki.wScan <> 0 then begin
            SendInput(1, simulatedKeyInputs[aDOF], sizeof(simulatedKeyInputs[aDOF]));
          end;
        end;

        // press new key
        if (keyDown <> kodNone) or (currentSector <> lastSector) then begin
          simulatedKeyInputs[aDOF].ki.dwFlags := KEYEVENTF_SCANCODE;
          ArraybutKeyOutput[aDOF][TKeyOutput(Ord(keyDown) - 1)].Down := True;
          simulatedKeyInputs[aDOF].ki.wScan := KeyOutput[aDOF][TKeyOutput(Ord(keyDown) - 1)].Key;
          if simulatedKeyInputs[aDOF].ki.wScan <> 0 then begin
            SendInput(1, simulatedKeyInputs[aDOF], sizeof(simulatedKeyInputs[aDOF]));
          end;
        end;
      end;

      lastKeyDown[aDOF] := keyDown;
      lastSector := currentSector;
    end;
  end;
end;


procedure TPoseDataOutput.UpdateSimConnect;
{var
  panz, zoom : Single;    }
begin
  {if cbSimConnectZoom.Checked then begin
    panz := 0;
     if interp_pose[dofPanZ][index_interpdata] > 0 then
      zoom := 20 + round(44 * abs(interp_pose[dofPanZ][index_interpdata] - FRespMax[dofPanZ]) / FRespMax[dofPanZ])
     else
      zoom := round(64 * abs(10 * interp_pose[dofPanZ][index_interpdata] - FRespMax[dofPanZ]) / FRespMax[dofPanZ]);
    dimSimConnect.UpdateZoom(zoom);
  end else
    panz := interp_pose[dofPanZ][index_interpdata] * AXIS_RAD_SCALE;  }

  dmSimConnect.UpdateData(  interp_pose[dofYaw][index_interpdata],
                              -interp_pose[dofPitch][index_interpdata],
                              interp_pose[dofRoll][index_interpdata],
                              interp_pose[dofPanX][index_interpdata] * AXIS_RAD_SCALE,
                              interp_pose[dofPanY][index_interpdata] * AXIS_RAD_SCALE,
                              interp_pose[dofPanZ][index_interpdata] * AXIS_RAD_SCALE);
end;



procedure TPoseDataOutput.UpdateFSUIPC;
var
  result : Cardinal;
  aDOF : TDOF;
begin
  // Yaw, Pitch, Roll and Zoom
  FSUIPC_Open(SIM_ANY, result);
  if  ((result = FSUIPC_ERR_OK) or (result = FSUIPC_ERR_OPEN)) and 
      ((FSUIPC_FS_Version = SIM_FS2K2) or (FSUIPC_FS_Version = SIM_FS2K4)) then begin

    // view pan is absolute
    FSState[dofYaw].Value := round(interp_pose[dofYaw][index_interpdata] * AXIS_RAD_SCALE);
    FSState[dofPitch].Value := -round(interp_pose[dofPitch][index_interpdata] * AXIS_RAD_SCALE);
    FSState[dofRoll].Value := round(interp_pose[dofRoll][index_interpdata] * AXIS_RAD_SCALE);

    for aDOF := dofYaw to dofRoll do
      if MyProfile.AxisEnabled[aDOF] then
        FSUIPC_Write($3110, 8, @FSState[aDOF], result);

    // don't steal zoom control unless axis enabled
    if (MyConfig.TrackingMethod <> tmSinglePoint) and MyProfile.AxisEnabled[dofPanZ] then begin
      if interp_pose[dofPanZ][index_interpdata] > 0 then
        FSZoom := 20 + round(44 * abs(interp_pose[dofPanZ][index_interpdata] - FRespMax[dofPanZ]) / FRespMax[dofPanZ])
      else
        FSZoom := round(64 * abs(10 * interp_pose[dofPanZ][index_interpdata] - FRespMax[dofPanZ]) / FRespMax[dofPanZ]);
      FSUIPC_Write($832E, 2, @FSZoom, result);
    end;
    FSUIPC_Process(result);
    if result = FSUIPC_ERR_SENDMSG then
      FSUIPC_Close; //timeout (1 second) so assume FS closed
  end;
end;


procedure TPoseDataOutput.InitializeJoystick(joyNumber : Integer);
begin
  PPJoyHandle := CreateFile(PAnsiChar(format('\\.\PPJoyIOCTL%d', [joyNumber])), GENERIC_WRITE, FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  if PPJoyHandle = INVALID_HANDLE_VALUE then begin
    cbJoystickOutput.Enabled := False;
    cbJoystickOutput.Checked := False;
    imPPJoy.Hint := DKLangConstW('S_ERROR_PPJOY_NOTFOUND');
  end else begin
    cbJoystickOutput.Enabled := True;
    imPPJoy.Hint := '';
  end;
end;



{
******************************* TUpdateThread *********************************
}

procedure TUpdateThread.Execute;
begin
  repeat  // 30 ms wait for games like ArmA with very small timeout
    WaitForSingleObject({PoseDataOutput.hsemUpdate} PoseDataOutput.eventUpdateOutput.Handle, 30);
    PoseDataOutput.UpdateOutput;
  until Terminated;
end;



procedure TPoseDataOutput.SetRespMax(aDOF : TDOF; Value : Single);
begin
  FRespMax[aDOF] := Value;
end;


procedure TPoseDataOutput.Stop;
begin
  UpdateOutputThread.Suspend;
  KeyOutputRelease;
end;


procedure TPoseDataOutput.CenterInterp;
var
  i : Integer;
  aDOF : TDOF;
begin
  Centering := True;
  for aDOF := Low(TDOF) to High(TDOF) do
    for i := 0 to (MyConfig.InterpMultiplier - 1) do begin
      interp_pose[aDOF][i] := MyProfile.CustomCenter[aDOF];
      PreviousPose[aDOF] := MyProfile.CustomCenter[aDOF];
    end;
end;


procedure TPoseDataOutput.cbOutputClick(Sender: TObject);
var
  aOutput : TOutput;
begin
  for aOutput := Low(TOutput) to High(TOutput) do
    if Sender = ArraycbOutput[aOutput] then begin
      MyProfile.Output[aOutput] := ArraycbOutput[aOutput].Checked;
      case aOutput of
        outTIR : if MyProfile.Output[outTIR] then begin
            if TIRViewsConnect then begin
              laTIRViews.Enabled := True;
              cbSimConnectOutput.Checked := False;
              cbSimConnectOutput.Enabled := False;
              cbFSOutput.Checked := False;
              cbFSOutput.Enabled := False;
            end else
              laTIRViews.Enabled := False;
          end else begin
            TIRViewsDisconnect;
            cbSimConnectOutput.Enabled := True;
            cbSimConnectOutput.Checked := MyProfile.Output[outSimConnect];
            cbFSOutput.Enabled := True;
            cbFSOutput.Checked := MyProfile.Output[outFS];
            cbOutputClick(Self);
          end;
        outSimConnect :
          if Assigned(dmSimConnect) then
            if MyProfile.Output[outSimConnect] then
              dmSimConnect.Connect(fsX)
            else
              dmSimConnect.Disconnect;
        outFS : FSUIPC_Close;
      end;

      // release simulated keypresses
      if not MyProfile.Output[outKey] then
        KeyOutputRelease;

      ProfileDirty;
      Break;
    end;
end;


procedure TPoseDataOutput.tbMouseWheelScaleChange(Sender: TObject);
begin
  MyProfile.MouseWheelScale := tbMouseWheelScale.Position;
  ProfileDirty;
end;


procedure TPoseDataOutput.udPPJoyControllerClick(Sender: TObject; Button: TUDBtnType);
begin
  MyProfile.PPJoyControllerNumber := udPPJoyController.Position;
  InitializeJoystick(MyProfile.PPJoyControllerNumber);
  ProfileDirty;
end;



procedure TPoseDataOutput.tbKeyOutputThresholdChange(Sender: TObject);
var
  aDOF : TDOF;
begin
  for aDOF := Low(TDOF) to High(TDOF) do
    if Sender = ArraytbKeyOutputThreshold[aDOF] then
      MyProfile.KeyOutputThresholds[aDOF] := ArraytbKeyOutputThreshold[aDOF].Position;
  ProfileDirty;
end;

procedure TPoseDataOutput.cbKeyOutputHoldClick(Sender: TObject);
var
  aDOF : TDOF;
begin
  for aDOF := Low(TDOF) to High(TDOF) do
    if Sender = ArraycbKeyOutputHold[aDOF] then
      MyProfile.KeyOutputHold[aDOF] := ArraycbKeyOutputHold[aDOF].Checked;
  ProfileDirty;
end;


procedure TPoseDataOutput.cbMouseModeClick(Sender: TObject);
begin
  if (Sender = cbMouseAutopan) and cbMouseAbsolute.Checked then begin
    cbMouseAbsolute.Checked := not cbMouseAutopan.Checked;
  end else if (Sender = cbMouseAbsolute) and cbMouseAutopan.Checked then begin
    cbMouseAutopan.Checked := not cbMouseAbsolute.Checked;
  end;

  MyProfile.MouseAutopan := cbMouseAutopan.Checked;
  MyProfile.MouseAbsolute := cbMouseAbsolute.Checked;

  ProfileDirty;
end;


procedure TPoseDataOutput.combMouseSourceSelect(Sender: TObject);
var
  aSource : TMouseSource;
begin
  for aSource := Low(TMouseSource) to High(TMouseSource) do
    if Sender = ArraycomboMouseSource[aSource] then begin
      if ArraycomboMouseSource[aSource].ItemIndex = 0 then
        MyProfile.MouseAxisEnabled[aSource] := False
      else begin
        MyProfile.MouseAxisEnabled[aSource] := True;
        MyProfile.MouseSource[aSource] := TDOF(ArraycomboMouseSource[aSource].ItemIndex - 1);
      end;
    end;
  ProfileDirty;
end;


procedure TPoseDataOutput.GestSimConnectFail(Sender: TObject);
begin
  cbSimConnectOutput.Checked := False;
  cbSimConnectOutput.Enabled := False;
  MyProfile.Output[outSimConnect] := False;
end;


procedure TPoseDataOutput.DisplayNOJOY(var MSG : TMessage);
begin
  cbJoystickOutput.Checked := False;
end;


procedure TPoseDataOutput.DisplayNOSIMCONNECT(var MSG : TMessage);
begin
  cbSimConnectOutput.Checked := False;
end;



procedure TPoseDataOutput.butKeyPollClick(Sender: TObject);
var
  aKeyOutput : TKeyOutput;
  aDOF : TDOF;
begin
  // set focus to page so that key input doesn't change a form control
  PanelKeyboard.SetFocus;

  DInput.ClearData;

  for aDOF := Low(TDOF) to High(TDOF) do
    for aKeyOutput := Low(TKeyOutput) to High(TKeyOutput) do
      if Sender = ArraybutKeyOutput[aDOF][aKeyOutput] then begin
        ArraybutKeyOutput[aDOF][aKeyOutput].Down := True;
        ArraybutKeyOutput[aDOF][aKeyOutput].Caption := DKLangConstW('S_PRESS_KEY');
        (fOwner.FindComponent('timerKey')  as TTimer).Enabled := False;
        KeyOutputRelease;
        DInput.StartPollOutput(@KeyOutput[aDOF][aKeyOutput]);
        Exit;
      end;
end;



procedure TPoseDataOutput.UpdateKeyOutputs(Clear : Boolean);
var
  aKeyOutput : TKeyOutput;
  aDOF : TDOF;
begin
  for aDOF := Low(TDOF) to High(TDOF) do
    for aKeyOutput := Low(TKeyOutput) to High(TKeyOutput) do begin
      if Clear then DInput.ClearKey(KeyOutput[aDOF][aKeyOutput]);
      ArraybutKeyOutput[aDOF][aKeyOutput].Down := False;
      ArraybutKeyOutput[aDOF][aKeyOutput].Caption := KeyOutput[aDOF][aKeyOutput].Name;
      MyProfile.KeyOutputs[aDOF, aKeyOutput] := KeyOutput[aDOF][aKeyOutput].Name;
    end;
end;


procedure TPoseDataOutput.KeyOutputRelease;
var
  aDOF : TDOF;
begin
  for aDOF := Low(TDOF) to High(TDOF) do
    if lastKeyDown[aDOF] <> kodNone then begin
      simulatedKeyInputs[aDOF].ki.dwFlags := KEYEVENTF_SCANCODE or KEYEVENTF_KEYUP;
      ArraybutKeyOutput[aDOF][TKeyOutput(Ord(lastkeyDown[aDOF]) - 1)].Down := False;
      simulatedKeyInputs[aDOF].ki.wScan := KeyOutput[aDOF][TKeyOutput(Ord(lastkeyDown[aDOF]) - 1)].Key;
      if simulatedKeyInputs[aDOF].ki.wScan <> 0 then
        SendInput(1, simulatedKeyInputs[aDOF], sizeof(simulatedKeyInputs[aDOF]));
      lastkeyDown[aDOF] := kodNone;
    end;
end;


procedure TPoseDataOutput.ClearKeyOutputsClick(Sender: TObject);
begin
  UpdateKeyOutputs(True);
end;



procedure TPoseDataOutput.ProfileDirty;
begin
  //if not PreventProfileDirtyStatus then begin
  ProfilesMngr.ProfileIsDirty := True;
end;



procedure TPoseDataOutput.PressedUITimerTimer(Sender: TObject);
var
  Keyname : array[0..25] of char;
  aDOF : TDOF;
begin
  FPressedKeys := '';
  for aDOF := Low(TDOF) to High(TDOF) do begin
    GetKeyNameText(simulatedKeyInputs[aDOF].ki.wScan shl 16, Keyname, 25);
    if lastkeyDown[aDOF] <> kodNone then
      FPressedKeys := FPressedKeys + Keyname;
  end;
end;


procedure TPoseDataOutput.SetRawInHandle(Value : THandle);
var
  head : RAWINPUTHEADER;
  headSize : Cardinal;
begin
  headSize := SizeOf(head);
  GetRawInputData(Value, RID_HEADER, @head, headSize, SizeOf(RAWINPUTHEADER));
  if head.dwType = RIM_TYPEMOUSE then
    FRawInHandle := Value;
end;



procedure TPoseDataOutput.DKLanguageController1LanguageChanged(
  Sender: TObject);
begin
  cbFreetrackOutput.Hint := DKLangConstW('S_HINT_FTSERVER');
  imFreetrackOutput.Hint := DKLangConstW('S_HINT_FTSERVER');
  cbTIROutput.HInt := DKLangConstW('S_HINT_TRACKIR');
  imTIROutput.Hint := DKLangConstW('S_HINT_TRACKIR');
  imTIRViewsOutput.Hint := DKLangConstW('S_HINT_TIRVIEWS');
end;

end.


