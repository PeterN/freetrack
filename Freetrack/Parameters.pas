unit Parameters;

interface

uses
  Types, IniFiles, SysUtils, Math, Classes,
  Response, Seuillage_inc;

type
  TDOF = (dofYaw, dofPitch, dofRoll, dofPanX, dofPanY, dofPanZ);
  TTrackingMethod = (tmSinglePoint, tmThreePointClip, tmThreePointCap, tmFourPoint);
  TPerspectives = (pFront, pTop, pSide, pFirstPerson);
  THeadAids = (aidWhiteSky, aidSphere, aidAxes, aidLabels,
               aidTracking, aidLimitBox, aidLimitBoxAbs, aidLimitRotation,
               aidRenderFPS, aidPoseFPS);
  TKeyControl = ( keyPause, keyCenter,
                  keyCustomCenterSet, keyCustomCenterReset,
                  keySmoothStable, keySmoothRaw,
                  keyYaw, keyPitch, keyRoll, keyPanX, keyPanY, keyPanZ,
                  keyFreeTrack, keyTIR, keyMouse, keyJoy, keyKeyOutput, keySimConnect,
                  keyProfileA, keyProfileB, keyProfileC);
  TInputType = (inputtypeNone, inputtypeKeyboard, inputtypeMouse, inputtypeController);
  TKeyOutput = (keyoutPos, keyoutNeg);
  TKeyOutputDown = (kodNone, kodPos, kodNeg);
  TOutput = (outFreeTrack, outTIR, outMouse, outJoy, outKey, outSimConnect, outFS);
  TMouseSource = (mouseX, mouseY, mouseWheel);
  TFreeTrackFilter = (filterAuto, filterMMX, filterSSE2);
  TBinaryOptions = (boptLaunchatStartup, boptStartMinimized, boptConfirmClose, boptAutoMinimize,
              boptAutoLoadProfile, boptAutoSaveProfile);
  TCamState = (camStopped, camPlaying, camPaused);
  TCamSource = (camDemo, camVid, camWii, camOptitrack, camNone);
  TOrient = (orFlip, orMirror, orRotate);

  TOnLedDetected = procedure (ListPoint: TListPoint) of Object;
  TOnSourceChange = procedure(source : TCamSource; count : Integer) of Object;

  TPose = array[TDOF] of Single;

  RPoint3D32f  = record
    x, y, z : 	Single;
  end;

  PPoint3D32f = ^RPoint3D32f;
  TArrayOfPoint3D32f = array of RPoint3D32f;

  RPoint2D32f = record
    x, y : 	Single;
  end;
  PPoint2D32f = ^RPoint2D32f;
  TArrayOfPoint2D32f = array of RPoint2D32f;

  RPose_RT = record
    Pitch, Yaw, Roll : Single;
    PanX, PanY, PanZ : Single;
  end;

  TConfig = class (TObject)
  private
    FDimensions3PtsClip: TArrayOfPoint3D32f;
    FDimensions3PtsCap: TArrayOfPoint3D32f;
    FDimensions4Pts: TArrayOfPoint3D32f;
    FGlobalSmoothing: array[TDOF] of integer;
    FGlobalInverts: array[TDOF] of boolean;
    FGlobalSensitivity: array[TDOF] of Single;
    FHeadAids: array[THeadAids] of Boolean;
    FRotOffset: array[TTrackingMethod] of array[dofPanX..dofPanZ] of Integer;
    FProfileFilename: string;
    FThreshold: Integer;
    FTrackingMethod: TTrackingMethod;
    FInterpMultiplier: Integer;
    FInterpAutoMultiplier: Boolean;
    FInterpWebcamFPS: Integer;
    FAutoCentering: Boolean;
    FAutoCenteringSpeed: Integer;
    FBinaryOptions: array[TBinaryOptions] of Boolean;
    FLanguage: String;
    FCenter: array[TDOF] of Single;
    FCameraName: String;
    FCamPos : array[TDOF] of Integer;
    FCamPosAuto : array[TDOF] of Boolean;
    FCamFocalLength : Single;
    FCamSensorWidth : Single;
    FOptitrackIRIllum : Boolean;
    FCamAutoCalibrate : Boolean;
    FFilterName : String;
    FGlobalSmoothingZooming: Integer;
    function GetGlobalSmoothing(aAxle : TDOF): Integer;
    function GetGlobalInverts(aAxle : TDOF): Boolean;
    function GetGlobalSensitivity(aAxle : TDOF): Single;
    function GetHeadAids(aHeadAid : THeadAids): Boolean;
    function GetRotOffset(trackMethod : TTrackingMethod; axis : TDOF): Integer;
    function GetBinaryOptions(aOption : TBinaryOptions): Boolean;
    function GetCenter(aAxle : TDOF): Single;
    function GetCamPos(aDOF : TDOF): Integer;
    function GetCamPosAuto(aDOF : TDOF): Boolean;
    procedure SetGlobalSmoothing(aAxle : TDOF; const Value: Integer);
    procedure SetGlobalInverts(aAxle : TDOF; const Value: Boolean);
    procedure SetGlobalSensitivity(aAxle : TDOF; const Value: Single);
    procedure SetHeadAids(aHeadAid : THeadAids; const Value: Boolean);
    procedure SetRotOffset(trackMethod : TTrackingMethod; axis : TDOF; const Value: Integer);
    procedure SetBinaryOptions(aOption : TBinaryOptions; const Value: Boolean);
    procedure SetCenter(aAxle : TDOF; const Value: Single);
    procedure SetCamPos(aDOF : TDOF; const Value: Integer);
    procedure SetCamPosAuto(aDOF : TDOF; const Value : Boolean);
  public
    constructor Create(AOwner : TComponent; aIni : TIniFile); overload;
    procedure ReadParamsFromIni(Ini : TIniFile);
    procedure SaveParamsToIni(Ini: TIniFile);
    property Dimensions3PtsClip: TArrayOfPoint3D32f read FDimensions3PtsClip;
    property Dimensions3PtsCap: TArrayOfPoint3D32f read FDimensions3PtsCap;
    property Dimensions4Pts: TArrayOfPoint3D32f read FDimensions4Pts;
    property GlobalSmoothing[aAxle : TDOF]: Integer read GetGlobalSmoothing write SetGlobalSmoothing;
    property GlobalInverts[aAxle : TDOF]: Boolean read GetGlobalInverts write SetGlobalInverts;
    property GlobalSensitivity[aAxle : TDOF]: Single read GetGlobalSensitivity write SetGlobalSensitivity;
    property HeadAids[aHeadAid : THeadAids]: Boolean read GetHeadAids write SetHeadAids;
    property RotOffset[trackingmethod : TTrackingMethod; axis : TDOF]: Integer read GetRotOffset write SetRotOffset;
    property ProfileFilename: string read FProfileFilename write FProfileFilename;
    property Threshold: Integer read FThreshold write FThreshold;
    property TrackingMethod: TTrackingMethod read FTrackingMethod write FTrackingMethod;
    property InterpMultiplier: Integer read FInterpMultiplier write FInterpMultiplier;
    property InterpAutoMultiplier: Boolean read FInterpAutoMultiplier write FInterpAutoMultiplier;
    property InterpWebcamFPS: Integer read FInterpWebcamFPS write FInterpWebcamFPS;
    property AutoCentering: Boolean read FAutoCentering write FAutoCentering;
    property AutoCenteringSpeed: Integer read FAutoCenteringSpeed write FAutoCenteringSpeed;
    property BinaryOptions[aOption: TBinaryOptions]: Boolean read GetBinaryOptions write SetBinaryOptions;
    property Language: String read FLanguage write FLanguage;
    property Center[aAxle: TDOF]: Single read GetCenter write SetCenter;
    property CameraName: String read FCameraName write FCameraName;
    property CamPos[aDOF : TDOF] : Integer read GetCamPos write SetCamPos;
    property CamPosAuto[aDOF : TDOF] : Boolean read GetCamPosAuto write SetCamPosAuto;
    property CamSensorWidth: Single read FCamSensorWidth write FCamSensorWidth;
    property CamFocalLength: Single read FCamFocalLength write FCamFocalLength;
    property CamAutoCalibrate: Boolean read FCamAutoCalibrate write FCamAutoCalibrate;
    property OptitrackIRIllum: Boolean read FOptitrackIRIllum write FOptitrackIRIllum;
    property FilterName: String read FFilterName write FFilterName;
    property GlobalSmoothingZooming: Integer read FGlobalSmoothingZooming write FGlobalSmoothingZooming;
  end;


  TProfile = class (TObject)
  private
    fAverage: integer;
    fAxisEnabled: array[TDOF] of boolean;
    fAxisMap: array[TDOF] of TDOF;
    fSmoothing: array[TDOF] of Integer;
    fInverts: array[TDOF] of Boolean;
    fResponseCurves: array[TDOF] of TArray3Points;
    fSensitivity: array[TDOF] of Single;
    fKeyControls: array[TKeyControl] of string;
    fKeyControlsBeep: array[TKeyControl] of Boolean;
    fSmoothStableMultiplier: Integer;
    fSmoothRawMultiplier: Integer;
    fKeyControlsToggle: array[TKeyControl] of Boolean;
    fDynamicSmoothing: Integer;
    fMouseAutopan: Boolean;
    fMouseSource: array[TMouseSource] of TDOF;
    fMouseAxisEnabled: array[TMouseSource] of Boolean;
    fMouseAbsolute: Boolean;
    fPPJoyControllerNumber,fMouseWheelScale : Integer;
    fKeyOutputs: array[TDOF] of array[TKeyOutput] of string;
    fKeyOutputThresholds: array[TDOF] of Integer;
    fKeyOutputHold: array[TDOF] of Boolean;
    fCustomCenter: array[TDOF] of Single;
    fRelativeTrans: array[TDOF] of Boolean;
    fRollRelativeRot: Boolean;
    fIgnoreBackwardZ: Boolean;
    fSmoothingZooming: Integer;
    fMaintainPausedData: Boolean;
    function GetSmoothing(aAxle : TDOF): Integer;
    function GetInverts(aAxle : TDOF): Boolean;
    function GetAxisEnabled(aAxle : TDOF): Boolean;
    function GetResponseCurves(aAxle : TDOF): PArray3Points;
    function GetSensitivity(aAxle : TDOF): Single;
    function GetAxisMap(aAxle : TDOF): TDOF;
    function GetKeyControls(aKey : TKeyControl): String;
    function GetKeyControlsBeep(aKey : TKeyControl): Boolean;
    function GetKeyControlsToggle(aKey : TKeyControl): Boolean;
    function GetMouseSource(aSource : TMouseSource): TDOF;
    function GetMouseAxisEnabled(aAxis : TMouseSource): Boolean;
    function GetKeyOutputs(aDOF : TDOF; aKey : TKeyOutput): String;
    function GetKeyOutputThresholds(aDOF : TDOF): Integer;
    function GetKeyOutputHold(aDOF : TDOF): Boolean;
    function GetCustomCenter(aDOF : TDOF): Single;
    function GetRelativeTrans(aDOF : TDOF) : Boolean;
    procedure SetSmoothing(aAxle : TDOF; const Value: Integer);
    procedure SetInverts(aAxle : TDOF; const Value: Boolean);
    procedure SetSensitivity(aAxle : TDOF; const Value: Single);
    procedure SetAxisEnabled(aAxle : TDOF; const Value: Boolean);
    procedure SetAxisMap(aAxle : TDOF; const Value : TDOF);
    procedure SetKeyControls(aKey : TKeyControl; const Value: String);
    procedure SetKeyControlsBeep(aKey : TKeyControl; const Value: Boolean);
    procedure SetKeyControlsToggle(aKey : TKeyControl; const Value: Boolean);
    procedure SetMouseSource(aSource : TMouseSource; const Value: TDOF);
    procedure SetMouseAxisEnabled(aAxis : TMouseSource; const Value: Boolean);
    procedure SetKeyOutputs(aDOF : TDOF; aKey : TKeyOutput; const Value: String);
    procedure SetKeyOutputThresholds(aDOF: TDOF; const Value: Integer);
    procedure SetKeyOutputHold(aDOF: TDOF; const Value: Boolean);
    procedure SetCustomCenter(aDOF: TDOF; const Value: Single);
    procedure SetRelativeTrans(aDOF: TDOF; const Value: Boolean);
  public
    Output: array[TOutput] of Boolean;
    constructor Create(aIni : TIniFile); overload;
    procedure ReadParamsFromIni(aIni : TIniFile);
    procedure SaveParamsToIni(aIni: TIniFile);
    property Average : integer read fAverage write fAverage;
    property Smoothing[aAxle : TDOF]: Integer read GetSmoothing write SetSmoothing;
    property Inverts[aAxle : TDOF]: Boolean read GetInverts write SetInverts;
    property ResponseCurves[aAxle : TDOF]: PArray3Points read GetResponseCurves;
    property Sensitivity[aAxle : TDOF]: Single read GetSensitivity write SetSensitivity;
    property AxisEnabled[aAxle : TDOF]: Boolean read GetAxisEnabled write SetAxisEnabled;
    property AxisMap[aAxle : TDOF]: TDOF read GetAxisMap write SetAxisMap;
    property KeyControls[aKey : TKeyControl] : string read GetKeyControls write SetKeyControls;
    property KeyControlsBeep[aKey : TKeyControl]: Boolean read GetKeyControlsBeep write SetKeyControlsBeep;
    property KeyControlsToggle[aKey : TKeyControl]: Boolean read GetKeyControlsToggle write SetKeyControlsToggle;
    property SmoothStableMultiplier: Integer read fSmoothStableMultiplier write fSmoothStableMultiplier;
    property SmoothRawMultiplier: Integer read fSmoothRawMultiplier write fSmoothRawMultiplier;
    property DynamicSmoothing: Integer read fDynamicSmoothing write fDynamicSmoothing;
    property MouseAutopan: Boolean read FMouseAutopan write FMouseAutopan;
    property MouseSource[aSource : TMouseSource]: TDOF read GetMouseSource write SetMouseSource;
    property MouseAxisEnabled[aAxis : TMouseSource]: Boolean read GetMouseAxisEnabled write SetMouseAxisEnabled;
    property MouseAbsolute: Boolean read fMouseAbsolute write fMouseAbsolute;
    property PPJoyControllerNumber: Integer read fPPJoyControllerNumber write fPPJoyControllerNumber;
    property MouseWheelScale: Integer read fMouseWheelScale write fMouseWheelScale;
    property KeyOutputs[aDOF : TDOF; aKey : TKeyOutput]: string read GetKeyOutputs write SetKeyOutputs;
    property KeyOutputThresholds[aDOF : TDOF]: Integer read GetKeyOutputThresholds write SetKeyOutputThresholds;
    property KeyOutputHold[aDOF : TDOF]: Boolean read GetKeyOutputHold write SetKeyOutputHold;
    property CustomCenter[aAxle : TDOF]: Single read GetCustomCenter write SetCustomCenter;
    property RelativeTrans[aDOF : TDOF] : Boolean read GetRelativeTrans write SetRelativeTrans;
    property RollRelativeRot : Boolean read fRollRelativeRot write fRollRelativeRot;
    property SmoothingZooming : Integer read fSmoothingZooming write fSmoothingZooming;
    property IgnoreBackwardZ : Boolean read fIgnoreBackwardZ write fIgnoreBackwardZ;
    property MaintainPausedData : Boolean read fMaintainPausedData write fMaintainPausedData;
  end;

// global
var
  MyConfig : TConfig;
  MyProfile : TProfile;

const
  DOFTxt : array[TDOF] of string = ('Yaw', 'Pitch', 'Roll', 'X', 'Y', 'Z');
  HeadAidTxt : array[THeadAids] of String = ('WhiteSky', 'Sphere', 'Axes', 'Labels',
              'Tracking', 'LimitBox', 'LimitBoxAbs', 'LimitRotation', 'ScreenFPS', 'PoseFPS');
  KeyControlTxt : array[TKeyControl] of String = ('Pause', 'Center', 'CustomCenterSet', 'CustomCenterReset', 'SmoothStable', 'SmoothRaw', 'Yaw', 'Pitch', 'Roll', 'X', 'Y', 'Z', 'FreeTrack', 'TIR', 'Mouse', 'Joystick', 'Keymap', 'SimConnect',  'ProfileA', 'ProfileB', 'ProfileC');
  OutputTxt : array[TOutput] of String = ('FreeTrack', 'TIR', 'Mouse', 'PPJoy', 'Keys', 'SimConnect', 'FS');
  KeyOutputTxt : array[TKeyOutput] of String = ('Pos', 'Neg');
  MouseSourceTxt : array[TMouseSource] of String = ('MouseX', 'MouseY', 'MouseWheel');
  BinaryOptionsTxt : array[TBinaryOptions] of String = ('LaunchatStartup', 'StartMinimized', 'ConfirmClose', 'AutoMinimize', 'AutoLoadProfile', 'AutoSaveProfile');
  BinaryOptionsDefaults : array[TBinaryOptions] of Boolean = (False, False, True, True, True, False);
  RelativeTransTxt : array[TDOF] of String = ('RelativeTransYaw', 'RelativeTransPitch', 'RelativeTransRoll', 'RelativeTransX', 'RelativeTransY', 'RelativeTransZ');
  TTrackingMethodTxt : array[TTrackingMethod] of string = ('1p', '3pclip', '3pcap', '4p');

  RotOffsetDefault: array[TTrackingMethod] of array[dofPanX..dofPanZ] of Integer = (  (0,   0,   0),
                                                                                      (120, 90,  -60),
                                                                                      (0,   160, -70),
                                                                                      (0,   160, -70));
  {DimensionsDefault : array[TTrackingMethod] of array[0..4] of Integer = (  (0,   0,  0,   0,   0),
                                                                            (40, 30,  70,  80,  0),
                                                                            (40, 60,  100, 0,   0),
                                                                            (70, 80,  100, 20, 40) )
   }
implementation

const
  INTEGER_DIV = 10000;    //to avoid to store float in ini file


{
************************************************************* TProfile *************************************************************
}
{-


}
constructor TProfile.Create(aIni : TIniFile);
begin
  inherited Create;
  //ReadParamsFromIni(aIni);
end;

{-


}
function TProfile.GetSmoothing(aAxle : TDOF): Integer;
begin
  Result := fSmoothing[aAxle];
end;

{-


}
function TProfile.GetInverts(aAxle : TDOF): Boolean;
begin
  Result := fInverts[aAxle];
end;



function TProfile.GetAxisEnabled(aAxle : TDOF): Boolean;
begin
  Result := fAxisEnabled[aAxle];
end;

{-


}
function TProfile.GetResponseCurves(aAxle : TDOF): PArray3Points;
begin
  Result := @fResponseCurves[aAxle];
end;

{-


}
function TProfile.GetSensitivity(aAxle : TDOF): Single;
begin
  Result := fSensitivity[aAxle];
end;


function TProfile.GetKeyControls(aKey : TKeyControl): String;
begin
  Result := fKeyControls[aKey];
end;



function TProfile.GetKeyControlsBeep(aKey : TKeyControl): Boolean;
begin
  Result := fKeyControlsBeep[aKey];
end;


function TProfile.GetKeyControlsToggle(aKey : TKeyControl): Boolean;
begin
  Result := fKeyControlsToggle[aKey];
end;


function TProfile.GetMouseSource(aSource : TMouseSource): TDOF;
begin
  Result := fMouseSource[aSource];
end;


function TProfile.GetMouseAxisEnabled(aAxis : TMouseSource): Boolean;
begin
  Result := fMouseAxisEnabled[aAxis];
end;


function TProfile.GetKeyOutputs(aDOF : TDOF; aKey : TKeyOutput): String;
begin
  Result := fKeyOutputs[aDOF][aKey];
end;


function TProfile.GetKeyOutputThresholds(aDOF : TDOF): Integer;
begin
  Result := fKeyOutputThresholds[aDOF];
end;


function TProfile.GetKeyOutputHold(aDOF : TDOF): Boolean;
begin
  Result := fKeyOutputHold[aDOF];
end;


function TProfile.GetCustomCenter(aDOF : TDOF): Single;
begin
  Result := fCustomCenter[aDOF];
end;


function TProfile.GetRelativeTrans(aDOF : TDOF) : Boolean;
begin
  Result := fRelativeTrans[aDOF];
end;

function TProfile.GetAxisMap(aAxle : TDOF) : TDOF;
begin
  Result := fAxisMap[aAxle];
end;



procedure TProfile.ReadParamsFromIni(aIni : TIniFile);
var
  aDOF: TDOF;
  aKeyControl : TKeyControl;
  aKeyOutput : TKeyOutput;
  IdxPt: TGrabHandlePosition;
  aMouseSource : TMouseSource;
  aOutput : TOutput;
  defaultKey : String;
begin

  fAverage := aIni.ReadInteger('Advanced', 'Average', 1);
  fIgnoreBackwardZ := aIni.ReadBool('Advanced', 'IgnoreBackwardZ', False);
  fMaintainPausedData := aIni.ReadBool('Advanced', 'MaintainPausedData', False);
  fRollRelativeRot := aIni.ReadBool('Advanced', 'RollRelativeRot', False);

  for aDOF := dofYaw to dofPanZ do
    fRelativeTrans[aDOF] := aIni.ReadBool('Advanced', RelativeTransTxt[aDOF], False);

  for aDOF := low(TDOF) to High(TDOF) do begin
    for IdxPt := low(TGrabHandlePosition) to High(TGrabHandlePosition) do
      fResponseCurves[aDOF][IdxPt] := Point(aIni.ReadInteger(DOFTxt[aDOF]+'Cfg', 'X' + IntToStr(ord(IdxPt)), 0),
                                       aIni.ReadInteger(DOFTxt[aDOF]+'Cfg', 'Y' + intToStr(ord(IdxPt)), 0));

    fSensitivity[aDOF]  := aIni.ReadInteger('Sensitivity', DOFTxt[aDof], -1) / INTEGER_DIV;                                   
    fSmoothing[aDOF]    := aIni.ReadInteger('Smoothing', DOFTxt[aDof], 15);
    fInverts[aDOF]      := aIni.ReadBool('Inverted', DOFTxt[aDof], False);
    fAxisEnabled[aDOF]      := aIni.ReadBool('AxisEnabled', DOFTxt[aDof], True);
    fAxisMap[aDOF]          := TDOF(aIni.ReadInteger('AxisMap', DOFTxt[aDOF], Ord(aDOF)));
  end;

  fSmoothingZooming := aIni.ReadInteger('Smoothing', 'Zooming', 1);

  for aMouseSource := Low(TMouseSource) to High(TMouseSource) do begin
    fMouseSource[aMouseSource] := TDOF(aIni.ReadInteger('Output', MouseSourceTxt[aMouseSource], ifthen(aMouseSource = mouseY, 1, 0)));
    fMouseAxisEnabled[aMouseSource] := (aIni.ReadBool('Output', MouseSourceTxt[aMouseSource] + 'Enabled', Boolean(ifthen(aMouseSource = mouseWheel, 0, 1))));
  end;

  fMouseAutopan := aIni.ReadBool('Output', 'MouseAutopan', False);
  fMouseAbsolute := aIni.ReadBool('Output', 'MouseAbsolute', False);
  fMouseWheelScale := aIni.ReadInteger('Output', 'MouseWheelScale', 50);
  fPPJoyControllerNumber := aIni.ReadInteger('Output', 'PPJoyControllerNumber', 1);

  Output[outFreeTrack] := aIni.ReadBool('Output', 'FreeTrack', True);
  Output[outTIR] := aIni.ReadBool('Output', 'TIR', True);
  for aOutput := outMouse to High(TOutput) do
    Output[aOutput] := aIni.ReadBool('Output', OutputTxt[aOutput], False);

  fSmoothStableMultiplier := aIni.ReadInteger('Smoothing', 'SmoothStableMultiplier', 25);
  fSmoothRawMultiplier := aIni.ReadInteger('Smoothing', 'SmoothRawMultiplier', 25);
  fDynamicSmoothing := aIni.ReadInteger('Smoothing', 'Dynamic', 0);

  for aKeyControl := Low(TKeyControl) to High(TKeyControl) do begin
    case aKeyControl of
      keyPause : defaultKey := 'Shift + F9';
      keyCenter : defaultKey := 'Shift + F12';
      keyCustomCenterSet : defaultKey := 'Ctrl + F11';
      keyCustomCenterReset : defaultKey := 'Ctrl + Shift + F11';
      keySmoothStable : defaultKey := 'Shift + F7';
      keySmoothRaw : defaultKey := 'Shift + F8';
      keyYaw : defaultKey := 'Ctrl + Shift + F1';
      keyPitch : defaultKey := 'Ctrl + Shift + F2';
      keyRoll : defaultKey := 'Ctrl + Shift + F3';
      keyPanX : defaultKey := 'Ctrl + Shift + F4';
      keyPanY : defaultKey := 'Ctrl + Shift + F5';
      keyPanZ : defaultKey := 'Ctrl + Shift + F6';
      keyFreeTrack : defaultKey := 'Ctrl + Alt + F1';
      keyTIR : defaultKey := 'Ctrl + Alt + F2';
      keyMouse : defaultKey := 'Ctrl + Alt + F3';
      keyJoy : defaultKey := 'Ctrl + Alt + F4';
      keyKeyOutput : defaultKey := 'Ctrl + Alt + F5';
      keySimConnect : defaultKey := 'Ctrl + Alt + F6';
    end;
    fKeyControls[aKeyControl] := aIni.ReadString('Mapping', KeyControlTxt[aKeyControl], defaultKey);
    fKeyControlsBeep[aKeyControl] := aIni.ReadBool('Mapping', KeyControlTxt[aKeyControl] + 'Beep', True);
    if aKeyControl = keyCenter then
      fKeyControlsToggle[aKeyControl] := aIni.ReadBool('Mapping', KeyControlTxt[aKeyControl] + 'Toggle', False)
    else
      fKeyControlsToggle[aKeyControl] := aIni.ReadBool('Mapping', KeyControlTxt[aKeyControl] + 'Toggle', True);
  end;

  for aDOF := low(TDOF) to High(TDOF) do begin
    fKeyOutputThresholds[aDOF] := aIni.ReadInteger('OutputKeys', DOFTxt[aDOF] + 'Threshold', 50);
    fKeyOutputHold[aDOF] := aIni.ReadBool('OutputKeys', DOFTxt[aDOF] + 'Hold', True);
    for aKeyOutput := Low(TKeyOutput) to High(TKeyOutput) do
      fKeyOutputs[aDOF][aKeyOutput] := aIni.ReadString('OutputKeys', DOFTxt[aDOF] + KeyOutputTxt[aKeyOutput], '');
  end;

  for aDOF := low(TDOF) to High(TDOF) do
    fCustomCenter[aDOF] := aIni.ReadInteger('CustomCenter', DOFTxt[aDOF], 0) / INTEGER_DIV;

end;

{-


}
procedure TProfile.SaveParamsToIni(aIni: TIniFile);
var
  aDOF: TDOF;
  aKeyControl : TKeyControl;
  aKeyOutput : TKeyOutput;
  IdxPt: TGrabHandlePosition;
  aMouseSource : TMouseSource;
  aOutput : TOutput;
begin

  aIni.WriteInteger('Advanced', 'Average', fAverage);
  aIni.WriteBool('Advanced', 'IgnoreBackwardZ', fIgnoreBackwardZ);
  aIni.WriteBool('Advanced', 'MaintainPausedData', fMaintainPausedData);
  aIni.WriteBool('Advanced', 'RollRelativeRot', fRollRelativeRot);

  for aDOF := Low(TDOF) to High(TDOF) do
    aIni.WriteBool('Advanced', RelativeTransTxt[aDOF], fRelativeTrans[aDOF]);

  // use a separate loop to stop responses from mixing with other data in ini file
  for aDOF := low(TDOF) to High(TDOF) do begin
    aIni.WriteInteger('Sensitivity', DOFTxt[aDof], round(fSensitivity[aDOF] * INTEGER_DIV));
    aIni.WriteInteger('Smoothing', DOFTxt[aDof], fSmoothing[aDOF]);
    aIni.WriteBool('Inverted', DOFTxt[aDof], fInverts[aDOF]);
    aIni.WriteBool('AxisEnabled', DOFTxt[aDof], fAxisEnabled[aDOF]);
    aIni.WriteInteger('AxisMap', DOFTxt[aDof], Ord(fAxisMap[aDOF]));
  end;
  
  for aDOF := low(TDOF) to High(TDOF) do
    for IdxPt := low(TGrabHandlePosition) to High(TGrabHandlePosition) do  begin
      aIni.WriteInteger(DOFTxt[aDOF]+'Cfg', 'X' + IntToStr(ord(IdxPt)), fResponseCurves[aDOF][IdxPt].X);
      aIni.WriteInteger(DOFTxt[aDOF]+'Cfg', 'Y' + intToStr(ord(IdxPt)), fResponseCurves[aDOF][IdxPt].Y);
    end;

  aIni.WriteInteger('Smoothing', 'Zooming', fSmoothingZooming);

  for aMouseSource := Low(TMouseSource) to High(TMouseSource) do begin
    aIni.WriteInteger('Output', MouseSourceTxt[aMouseSource], Ord(fMouseSource[aMouseSource]));
    aIni.WriteBool('Output', MouseSourceTxt[aMouseSource] + 'Enabled', fMouseAxisEnabled[aMouseSource]);
  end;

  aIni.WriteBool('Output', 'MouseAutoPan',  fMouseAutopan);
  aIni.WriteBool('Output', 'MouseAbsolute',  fMouseAbsolute);
  aIni.WriteInteger('Output', 'MouseWheelScale', fMouseWheelScale);
  aIni.WriteInteger('Output', 'PPJoyControllerNumber', fPPJoyControllerNumber);

  for aOutput := Low(TOutput) to High(TOutput) do
    aIni.WriteBool('Output', OutputTxt[aOutput],  Output[aOutput]);

  aIni.WriteInteger('Smoothing', 'SmoothStableMultiplier', fSmoothStableMultiplier);
  aIni.WriteInteger('Smoothing', 'SmoothRawMultiplier', fSmoothRawMultiplier);
  aIni.WriteInteger('Smoothing', 'Dynamic', fDynamicSmoothing);

  for aKeyControl := Low(TKeyControl) to High(TKeyControl) do begin
    aIni.WriteString('Mapping', KeyControlTxt[aKeyControl], fKeyControls[aKeyControl]);
    aIni.WriteBool('Mapping', KeyControlTxt[aKeyControl] + 'Beep', fKeyControlsBeep[aKeyControl]);
    aIni.WriteBool('Mapping', KeyControlTxt[aKeyControl] + 'Toggle', fKeyControlsToggle[aKeyControl]);
  end;

  for aDOF := low(TDOF) to High(TDOF) do begin
    aIni.WriteInteger('OutputKeys', DOFTxt[aDOF] + 'Threshold', fKeyOutputThresholds[aDOF]);
    aIni.WriteBool('OutputKeys', DOFTxt[aDOF] + 'Hold', fKeyOutputHold[aDOF]);
    for aKeyOutput := Low(TKeyOutput) to High(TKeyOutput) do
      aIni.WriteString('OutputKeys', DOFTxt[aDOF] + KeyOutputTxt[aKeyOutput], fKeyOutputs[aDOF][aKeyOutput]);
  end;

  for aDOF := low(TDOF) to High(TDOF) do
    aIni.WriteInteger('CustomCenter', DOFTxt[aDOF], round(fCustomCenter[aDOF] * INTEGER_DIV));

end;

{-


}
procedure TProfile.SetSmoothing(aAxle : TDOF; const Value: Integer);
begin
  fSmoothing[aAxle] := Value;
end;

{-


}
procedure TProfile.SetInverts(aAxle : TDOF; const Value: Boolean);
begin
  fInverts[aAxle] := Value;
end;


procedure TProfile.SetAxisEnabled(aAxle : TDOF; const Value: Boolean);
begin
  fAxisEnabled[aAxle] := Value;
end;

{-


}
procedure TProfile.SetSensitivity(aAxle : TDOF; const Value: Single);
begin
  fSensitivity[aAxle] := Value;
end;



procedure TProfile.SetKeyControls(aKey : TKeyControl; const Value: String);
begin
  fKeyControls[aKey] := Value;
end;


procedure TProfile.SetKeyControlsBeep(aKey : TKeyControl; const Value: Boolean);
begin
 fKeyControlsBeep[aKey] := Value;
end;


procedure TProfile.SetKeyControlsToggle(aKey : TKeyControl; const Value: Boolean);
begin
 fKeyControlsToggle[aKey] := Value;
end;



procedure TProfile.SetMouseSource(aSource : TMouseSource; const Value: TDOF);
begin
  fMouseSource[aSource] := Value;
end;


procedure TProfile.SetMouseAxisEnabled(aAxis : TMouseSource; const Value: Boolean);
begin
  fMouseAxisEnabled[aAxis] := Value;
end;


procedure TProfile.SetKeyOutputs(aDOF : TDOF; aKey : TKeyOutput; const Value: String);
begin
  fKeyOutputs[aDOF][aKey] := Value;
end;


procedure TProfile.SetKeyOutputThresholds(aDOF: TDOF; const Value: Integer);
begin
  fKeyOutputThresholds[aDOF] := Value;
end;



procedure TProfile.SetKeyOutputHold(aDOF: TDOF; const Value: Boolean);
begin
  fKeyOutputHold[aDOF] := Value;
end;


procedure TProfile.SetCustomCenter(aDOF: TDOF; const Value: Single);
begin
  fCustomCenter[aDOF] := Value;
end;


procedure TProfile.SetRelativeTrans(aDOF: TDOF; const Value: Boolean);
begin
  fRelativeTrans[aDOF] := Value;
end;


procedure TProfile.SetAxisMap(aAxle : TDOF; const Value : TDOF);
begin
  fAxisMap[aAxle] := Value;
end;



{
************************************************************* TConfig **************************************************************
}
{-


}
constructor TConfig.Create(AOwner : TComponent; aIni : TIniFile);
begin
  inherited Create;
  ReadParamsFromIni(aIni);
end;

{-


}
function TConfig.GetGlobalSmoothing(aAxle : TDOF): Integer;
begin
  Result := FGlobalSmoothing[aAxle];
end;

{-


}
function TConfig.GetGlobalInverts(aAxle : TDOF): Boolean;
begin
  Result := FGlobalInverts[aAxle];
end;

{-


}
function TConfig.GetGlobalSensitivity(aAxle : TDOF): Single;
begin
  Result := FGlobalSensitivity[aAxle];
end;

{-


}
function TConfig.GetHeadAids(aHeadAid : THeadAids): Boolean;
begin
  Result := FHeadAids[aHeadAid];
end;

{-


}
function TConfig.GetRotOffset(trackMethod : TTrackingMethod; axis : TDOF): Integer;
begin
  Result := FRotOffset[trackMethod][axis];
end;


function TConfig.GetBinaryOptions(aOption : TBinaryOptions): Boolean;
begin
  Result := FBinaryOptions[aOption];
end;


function TConfig.GetCenter(aAxle : TDOF): Single;
begin
  Result := FCenter[aAxle];
end;


function TConfig.GetCamPos(aDOF : TDOF): Integer;
begin
  Result := FCamPos[aDOF];
end;


function TConfig.GetCamPosAuto(aDOF : TDOF): Boolean;
begin
  Result := FCamPosAuto[aDOF];
end;


{-


}



procedure TConfig.ReadParamsFromIni(Ini : TIniFile);
var
  aDOF: TDOF;
  aHeadAid: THeadAids;
  aOption : TBinaryOptions;
  aTrackMethod : TTrackingMethod;
begin
  
  FTrackingMethod := TTrackingMethod(Ini.ReadInteger('Defaults', 'Tracking_Method', 0));
  FThreshold := Ini.ReadInteger('Defaults', 'Threshold', 100);
  FProfileFilename := Ini.ReadString('Defaults', 'Profile', 'Default.ftp');
  FInterpMultiplier := Ini.ReadInteger('Defaults', 'InterpMultiplier', 2);
  FInterpAutoMultiplier := Ini.ReadBool('Defaults', 'InterpAutoMultiplier', True);
  FInterpWebcamFPS := Ini.ReadInteger('Defaults', 'InterpWebcamFPS', 30);
  FAutoCentering := Ini.ReadBool('Defaults', 'AutoCentering', False);
  FAutoCenteringSpeed := Ini.ReadInteger('Defaults', 'AutoCenteringSpeed', 25);
  FLanguage := Ini.ReadString('Defaults', 'Language', 'auto');

  for aDOF := low(TDOF) to High(TDOF) do
    FCenter[aDOF] := Ini.ReadInteger('Center', DOFTxt[aDof], 0) / INTEGER_DIV;

  for aDOF := dofYaw to dofRoll do begin
    FCamPos[aDOF] := Ini.ReadInteger('CamPos', DOFTxt[aDOF], 0);
    FCamPosAuto[aDOF] := Ini.ReadBool('CamPosAuto', DOFTxt[aDOF], True);
  end;
  FCamSensorWidth := Ini.ReadInteger('Camera', 'CamSensorWidth', 30000) / INTEGER_DIV;
  FCamFocalLength := Ini.ReadInteger('Camera', 'CamFocalLength', 37000) / INTEGER_DIV;
  FCamAutoCalibrate := Ini.ReadBool('Camera', 'CamAutoCalibrate', True);
  FOptitrackIRIllum := Ini.ReadBool('Camera', 'OptitrackIRIllum', False);
  FFilterName := Ini.ReadString('Camera', 'FilterName', 'auto');

  for aOption := Low(TBinaryOptions) to High(TBinaryOptions) do
    FBinaryOptions[aOption] := Ini.ReadBool('BinaryOptions', BinaryOptionsTxt[aOption], BinaryOptionsDefaults[aOption]);

  for aHeadAid := Low(THeadAids) to aidLimitRotation do
    FHeadAids[aHeadAid] := Ini.ReadBool('HeadAids', HeadAidTxt[aHeadAid], True);
  for aHeadAid := aidRenderFPS to aidPoseFPS do
    FHeadAids[aHeadAid] := Ini.ReadBool('HeadAids', HeadAidTxt[aHeadAid], False);

  SetLength(FDimensions3PtsClip, 2);

  FDimensions3PtsClip[0].y := abs(Ini.ReadInteger('Threepoint_clip_dimensions', 'y1', 40));
  FDimensions3PtsClip[0].z := abs(Ini.ReadInteger('Threepoint_clip_dimensions', 'z1', 30));
  FDimensions3PtsClip[1].y := abs(Ini.ReadInteger('Threepoint_clip_dimensions', 'y2', 70));
  FDimensions3PtsClip[1].z := abs(Ini.ReadInteger('Threepoint_clip_dimensions', 'z2', 80));
  SetLength(FDimensions3PtsCap, 1);
  
  FDimensions3PtsCap[0].x := abs(Ini.ReadInteger('Threepoint_cap_dimensions', 'x', 40));
  FDimensions3PtsCap[0].y := abs(Ini.ReadInteger('Threepoint_cap_dimensions', 'y', 60));
  FDimensions3PtsCap[0].z := abs(Ini.ReadInteger('Threepoint_cap_dimensions', 'z', 100));

  SetLength(FDimensions4Pts, 4);
  FDimensions4Pts[1].x := abs(Ini.ReadInteger('Fourpoint_dimensions', 'x1', 70));
  FDimensions4Pts[1].y := abs(Ini.ReadInteger('Fourpoint_dimensions', 'y1', 80));
  FDimensions4Pts[1].z := abs(Ini.ReadInteger('Fourpoint_dimensions', 'z1', 100));
  FDimensions4Pts[2].y := abs(Ini.ReadInteger('Fourpoint_dimensions', 'y2', 20));
  FDimensions4Pts[2].z := abs(Ini.ReadInteger('Fourpoint_dimensions', 'z2', 40));
  
  // ensure no zero entries to prevent coplanar exception
  if FDimensions3PtsClip[0].z = 0 then FDimensions3PtsClip[0].z := 40;
  if FDimensions3PtsClip[0].y = 0 then FDimensions3PtsClip[0].y := 30;
  if FDimensions3PtsClip[1].z = 0 then FDimensions3PtsClip[1].z := 70;
  if FDimensions3PtsClip[1].y = 0 then FDimensions3PtsClip[1].y := 80;

  if FDimensions3PtsCap[0].x = 0 then FDimensions3PtsCap[0].x := 40;
  if FDimensions3PtsCap[0].y = 0 then FDimensions3PtsCap[0].y := 60;
  if FDimensions3PtsCap[0].z = 0 then FDimensions3PtsCap[0].z := 100;

  if FDimensions4Pts[1].x = 0 then FDimensions4Pts[1].x := 70;
  if FDimensions4Pts[1].y = 0 then FDimensions4Pts[1].y := 80;
  if FDimensions4Pts[1].z = 0 then FDimensions4Pts[1].z := 100;
  if FDimensions4Pts[2].y = 0 then FDimensions4Pts[2].y := 20;
  if FDimensions4Pts[2].z = 0 then FDimensions4Pts[2].z := 40;

  FRotOffset[tmThreePointClip][dofPanX] :=  Ini.ReadInteger('RotOffset', TTrackingMethodTxt[tmThreePointClip] + DOFTxt[dofPanX], RotOffsetDefault[tmThreePointClip][dofPanX]);
  FRotOffset[tmThreePointClip][dofPanY] :=  Ini.ReadInteger('RotOffset', TTrackingMethodTxt[tmThreePointClip] + DOFTxt[dofPanY], RotOffsetDefault[tmThreePointClip][dofPanY]);
  FRotOffset[tmThreePointClip][dofPanZ] :=  Ini.ReadInteger('RotOffset', TTrackingMethodTxt[tmThreePointClip] + DOFTxt[dofPanZ], RotOffsetDefault[tmThreePointClip][dofPanZ]);
  for aTrackMethod := tmThreePointCap to tmFourPoint do begin
    FRotOffset[aTrackMethod][dofPanX] :=  Ini.ReadInteger('RotOffset', TTrackingMethodTxt[aTrackMethod] + DOFTxt[dofPanX], RotOffsetDefault[aTrackMethod][dofPanX]);
    FRotOffset[aTrackMethod][dofPanY] :=  Ini.ReadInteger('RotOffset', TTrackingMethodTxt[aTrackMethod] + DOFTxt[dofPanY], RotOffsetDefault[aTrackMethod][dofPanY]);
    FRotOffset[aTrackMethod][dofPanZ] :=  Ini.ReadInteger('RotOffset', TTrackingMethodTxt[aTrackMethod] + DOFTxt[dofPanZ], RotOffsetDefault[aTrackMethod][dofPanZ]);
  end;
  
  for aDOF := low(TDOF) to High(TDOF) do begin
    FGlobalInverts[aDOF]     := Ini.ReadBool('Inverted', DOFTxt[aDof], False);
    FGlobalSensitivity[aDOF] := Ini.ReadInteger('Sensitivity', DOFTxt[aDof], INTEGER_DIV) / INTEGER_DIV;
    FGlobalSmoothing[aDOF]   := Ini.ReadInteger('Smoothing', DOFTxt[aDof], 100);
  end;

  FGlobalSmoothingZooming := Ini.ReadInteger('Smoothing', 'Zooming', 1 );

end;

{-


}
procedure TConfig.SaveParamsToIni(Ini: TIniFile);
var
  i: Integer;
  aDOF: TDOF;
  aHeadAid: THeadAids;
  aOption : TBinaryOptions;
  aTrackMethod : TTrackingMethod;
begin
  Ini.WriteInteger('Defaults', 'Tracking_Method', ord(FTrackingMethod));
  Ini.WriteInteger('Defaults', 'Threshold', FThreshold);
  Ini.WriteString('Defaults', 'Profile', FProfileFilename);
  Ini.WriteInteger('Defaults', 'InterpMultiplier', FInterpMultiplier);
  Ini.WriteBool('Defaults', 'InterpAutoMultiplier', FInterpAutoMultiplier);
  Ini.WriteInteger('Defaults', 'InterpWebcamFPS', FInterpWebcamFPS);
  Ini.WriteBool('Defaults', 'AutoCentering', FAutoCentering);
  Ini.WriteInteger('Defaults', 'AutoCenteringSpeed', FAutoCenteringSpeed);
  Ini.WriteString('Defaults', 'Language', FLanguage);


  for aDOF := low(TDOF) to High(TDOF) do
    Ini.WriteInteger('Center', DOFTxt[aDOF], round(fCenter[aDOF] * INTEGER_DIV));

  for aDOF := dofYaw to dofRoll do begin
    Ini.WriteInteger('CamPos', DOFTxt[aDOF], FCamPos[aDOF]);
    Ini.WriteBool('CamPosAuto', DOFTxt[aDOF], FCamPosAuto[aDOF]);
  end;
  Ini.WriteInteger('Camera', 'CamSensorWidth', round(FCamSensorWidth * INTEGER_DIV));
  Ini.WriteInteger('Camera', 'CamFocalLength', round(FCamFocalLength * INTEGER_DIV));
  Ini.WriteBool('Camera', 'CamAutoCalibrate', FCamAutoCalibrate);
  Ini.WriteBool('Camera', 'OptitrackIRIllum', FOptitrackIRIllum);
  Ini.WriteString('Camera', 'FilterName', FFilterName);

  for aOption := Low(TBinaryOptions) to High(TBinaryOptions) do
    Ini.WriteBool('BinaryOptions', BinaryOptionsTxt[aOption], FBinaryOptions[aOption]);

  for aHeadAid := Low(THeadAids) to High(THeadAids) do begin
    Ini.WriteBool('HeadAids', HeadAidTxt[aHeadAid], FHeadAids[aHeadAid]);
  end;
  
  for i := 0 to 1 do begin
    Ini.WriteInteger('Threepoint_clip_dimensions', Format('z%d', [i+1]), round(abs(FDimensions3PtsClip[i].z)));
    Ini.WriteInteger('Threepoint_clip_dimensions', Format('y%d', [i+1]), round(abs(FDimensions3PtsClip[i].y)));
  end;

  Ini.WriteInteger('Threepoint_cap_dimensions', 'x', round(abs(FDimensions3PtsCap[0].x)));
  Ini.WriteInteger('Threepoint_cap_dimensions', 'y', round(abs(FDimensions3PtsCap[0].y)));
  Ini.WriteInteger('Threepoint_cap_dimensions', 'z', round(abs(FDimensions3PtsCap[0].z)));

  Ini.WriteInteger('Fourpoint_dimensions', 'x1', round(abs(FDimensions4Pts[1].x)));
  Ini.WriteInteger('Fourpoint_dimensions', 'y1', round(abs(FDimensions4Pts[1].y)));
  Ini.WriteInteger('Fourpoint_dimensions', 'z1', round(abs(FDimensions4Pts[1].z)));
  Ini.WriteInteger('Fourpoint_dimensions', 'y2', round(abs(FDimensions4Pts[2].y)));
  Ini.WriteInteger('Fourpoint_dimensions', 'z2', round(abs(FDimensions4Pts[2].z)));

  for aTrackMethod := Low(TTrackingMethod) to High(TTrackingMethod) do
    for aDOF := dofPanX to dofPanZ do
      Ini.WriteInteger('RotOffset', TTrackingMethodTxt[aTrackMethod] + DOFTxt[aDOF], FRotOffset[aTrackMethod][aDOF]);
  
  for aDOF := Low(TDOF) to High(TDOF) do begin
    Ini.WriteBool('Inverted', DOFTxt[aDof], FGlobalInverts[aDOF]);
    Ini.WriteInteger('Sensitivity', DOFTxt[aDof], round(FGlobalSensitivity[aDOF] * INTEGER_DIV));
    Ini.WriteInteger('Smoothing', DOFTxt[aDof], FGlobalSmoothing[aDOF]);
  end;
  
  Ini.WriteInteger('Smoothing', 'Zooming', FGlobalSmoothingZooming);
end;

{-



}
procedure TConfig.SetGlobalSmoothing(aAxle : TDOF; const Value: Integer);
begin
  FGlobalSmoothing[aAxle] := Value;
end;

{-


}
procedure TConfig.SetGlobalInverts(aAxle : TDOF; const Value: Boolean);
begin
  FGlobalInverts[aAxle] := Value;
end;

{-


}
procedure TConfig.SetGlobalSensitivity(aAxle : TDOF; const Value: Single);
begin
  FGlobalSensitivity[aAxle] := Value;
end;

{-


}
procedure TConfig.SetHeadAids(aHeadAid : THeadAids; const Value: Boolean);
begin
  FHeadAids[aHeadAid] := Value;
end;

{-


}
procedure TConfig.SetRotOffset(trackMethod : TTrackingMethod; axis : TDOF; const Value : Integer);
begin
  FRotOffset[trackMethod][axis] := Value;
end;


procedure TConfig.SetBinaryOptions(aOption : TBinaryOptions; const Value: Boolean);
begin
  FBinaryOptions[aOption] := Value;
end;


procedure TConfig.SetCenter(aAxle : TDOF; const Value: Single);
begin
  FCenter[aAxle] := Value;
end;

procedure TConfig.SetCamPos(aDOF : TDOF; const Value: Integer);
begin
  FCamPos[aDOF] := Value;
end;

procedure TConfig.SetCamPosAuto(aDOF : TDOF; const Value: Boolean);
begin
  FCamPosAuto[aDOF] := Value;
end;




end.
