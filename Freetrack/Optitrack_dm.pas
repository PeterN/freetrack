unit Optitrack_dm;

interface

uses
  Windows, SysUtils, Classes, Math, OptiTrack_TLB, OleServer, Parameters,
  ExtCtrls, Forms, DSPack, Registry, Graphics, SyncObjs,
  ShellAPI, Seuillage_inc, FreeTrackTray;


type
  TOptitrackCamParam = record
    FrameRate : Integer;
    SenWidth : Integer;
    SenHeight : Integer;
  end;

  {TUpdateThread = class(TThread)
  protected
    procedure Execute; override;
  end;  }

  TdmOptitrack = class(TDataModule)
    NPCameraCollection1: TNPCameraCollection;
    NPCamera1: TNPCamera;
    procedure NPCameraCollection1DeviceArrival(ASender: TObject;
      const pCamera: INPCamera);
    procedure NPCameraCollection1DeviceRemoval(ASender: TObject;
      const pCamera: INPCamera);
    procedure NPCamera1FrameAvailable(ASender: TObject;
      const pCamera: INPCamera);
  private
    FWidth, FHeight : Integer;
    FOnLedDetected : TOnLedDetected;
    FOnNewSource, FOnLostSource : TOnSourceChange;
    ListPoint : TListPoint;
    FVisible : Boolean;
    aFrame : NPCameraFrame;
    FAvailable : Boolean;
    CamState : TCamState;
    TrackState : TTypeState;
    aCanvas : TCanvas;
    aVideoWindow : TVideoWindow;
    fOwner : TForm;
    FIRIllumination : Boolean;
    FOrient : array[TOrient] of Boolean;
    ListCam : TList;
    FZScalar : Single;
    FMinPointSize, FMaxPointSize : Integer;

    {UpdateOutputThread : TUpdateThread;
    eventUpdate : TEvent;     }


    procedure SetTracking(tracking : TTypeState);
    procedure SetHostAppRunning(value : Boolean);
    procedure DrawPointCross(aPoint : TPoint);
    procedure DrawScreenCross;
  public
    DisplayHandle : THandle;
    OptiCamParams : TOptitrackCamParam;

    eventFrameAvailable : TNPCameraFrameAvailable;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Play;
    procedure Pause;
    procedure PlayPaused;
    procedure Stop;
    procedure Select(aSerial : Integer);
    procedure Enum;
    function GetOrient(aOrient : TOrient) : Boolean;
    procedure SetThreshold(threshold : Integer);
    procedure SetIRIllum(lit : Boolean);
    procedure SetOrient(aOrient : TOrient; Value : Boolean);
    property OnLedDetected : TOnLedDetected read FOnLedDetected write FOnLedDetected;
    property OnNewSource : TOnSourceChange read FOnNewSource write FOnNewSource;
    property OnLostSource : TOnSourceChange read FOnLostSource write FOnLostSource;
    property Width : Integer read FWidth;
    property Height : Integer read FHeight;
    property Visible : Boolean read FVisible write FVisible;
    property Tracking : TTypeState write SetTracking;
    property HostAppRunning : Boolean write SetHostAppRunning;
    property Available : Boolean read FAvailable;
    property Orient[aOrient : TOrient] : Boolean read GetOrient write SetOrient;
    property ZScalar : Single read FZScalar write FZScalar;
    property MinPointSize : Integer read FMinPointSize write FMinPointSize;
    property MaxPointSize : Integer read FMaxPointSize write FMaxPointSize;
  end;

var
  dmOptitrack: TdmOptitrack;

implementation

type

  TCam = class
  private
    FCamPointer : INPCamera;
    FSerialNumber : Integer;
  public
    constructor Create(pCam : INPCamera; serialnumber : Integer);
    property CamPointer : INPCamera read FCamPointer write FCamPointer;
    property SerialNumber : Integer read FSerialNumber write FSerialNumber;
  end;

const
  NP_THRESHOLD_MIN = 1;
  NP_THRESHOLD_MAX = 253;
  NP_DRAW_SCALE_MIN = 0.1;
  NP_DRAW_SCALE_MAX = 15.0;
  NP_SMOOTHING_MIN = 10;
  NP_SMOOTHING_MAX = 120;
  NP_OPTION_STATUS_GREEN_ON_TRACKING = 0;
	NP_OPTION_TRACKED_OBJECT_COLOR	= NP_OPTION_STATUS_GREEN_ON_TRACKING + 1;
	NP_OPTION_UNTRACKED_OBJECTS_COLOR	= NP_OPTION_TRACKED_OBJECT_COLOR + 1;
	NP_OPTION_OBJECT_COLOR_OPTION	= NP_OPTION_UNTRACKED_OBJECTS_COLOR + 1;
	NP_OPTION_DRAW_SCALE	= NP_OPTION_OBJECT_COLOR_OPTION + 1;
	NP_OPTION_THRESHOLD	= NP_OPTION_DRAW_SCALE + 1;
	NP_OPTION_OBJECT_MASS_WEIGHT	= NP_OPTION_THRESHOLD + 1;
	NP_OPTION_OBJECT_RATIO_WEIGHT	= NP_OPTION_OBJECT_MASS_WEIGHT + 1;
	NP_OPTION_PROXIMITY_WEIGHT	= NP_OPTION_OBJECT_RATIO_WEIGHT + 1;
	NP_OPTION_STATIC_COUNT_WEIGHT	= NP_OPTION_PROXIMITY_WEIGHT + 1;
	NP_OPTION_SCREEN_CENTER_WEIGHT	= NP_OPTION_STATIC_COUNT_WEIGHT + 1;
	NP_OPTION_LAST_OBJECT_TRACKED_WEIGHT	= NP_OPTION_SCREEN_CENTER_WEIGHT + 1;
	NP_OPTION_OBJECT_MASS_MIN	= NP_OPTION_LAST_OBJECT_TRACKED_WEIGHT + 1;
	NP_OPTION_OBJECT_MASS_MAX	= NP_OPTION_OBJECT_MASS_MIN + 1;
	NP_OPTION_OBJECT_MASS_IDEAL	= NP_OPTION_OBJECT_MASS_MAX + 1;
	NP_OPTION_OBJECT_MASS_OUT_OF_RANGE	= NP_OPTION_OBJECT_MASS_IDEAL + 1;
	NP_OPTION_OBJECT_RATIO_MIN	= NP_OPTION_OBJECT_MASS_OUT_OF_RANGE + 1;
	NP_OPTION_OBJECT_RATIO_MAX	= NP_OPTION_OBJECT_RATIO_MIN + 1;
	NP_OPTION_OBJECT_RATIO_IDEAL	= NP_OPTION_OBJECT_RATIO_MAX + 1;
	NP_OPTION_OBJECT_RATIO_OUT_OF_RANGE	= NP_OPTION_OBJECT_RATIO_IDEAL + 1;
	NP_OPTION_PROXIMITY_MIN	= NP_OPTION_OBJECT_RATIO_OUT_OF_RANGE + 1;
	NP_OPTION_PROXIMITY_MAX	= NP_OPTION_PROXIMITY_MIN + 1;
	NP_OPTION_PROXIMITY_IDEAL	= NP_OPTION_PROXIMITY_MAX + 1;
	NP_OPTION_PROXIMITY_OUT_OF_RANGE	= NP_OPTION_PROXIMITY_IDEAL + 1;
	NP_OPTION_STATIC_COUNT_MIN	= NP_OPTION_PROXIMITY_OUT_OF_RANGE + 1;
	NP_OPTION_STATIC_COUNT_MAX	= NP_OPTION_STATIC_COUNT_MIN + 1;
	NP_OPTION_STATIC_COUNT_IDEAL	= NP_OPTION_STATIC_COUNT_MAX + 1;
	NP_OPTION_STATIC_COUNT_OUT_OF_RANGE	= NP_OPTION_STATIC_COUNT_IDEAL + 1;
	NP_OPTION_SCREEN_CENTER_MIN	= NP_OPTION_STATIC_COUNT_OUT_OF_RANGE + 1;
	NP_OPTION_SCREEN_CENTER_MAX	= NP_OPTION_SCREEN_CENTER_MIN + 1;
	NP_OPTION_SCREEN_CENTER_IDEAL	= NP_OPTION_SCREEN_CENTER_MAX + 1;
	NP_OPTION_SCREEN_CENTER_OUT_OF_RANGE	= NP_OPTION_SCREEN_CENTER_IDEAL + 1;
	NP_OPTION_LAST_OBJECT_MIN	= NP_OPTION_SCREEN_CENTER_OUT_OF_RANGE + 1;
	NP_OPTION_LAST_OBJECT_MAX	= NP_OPTION_LAST_OBJECT_MIN + 1;
	NP_OPTION_LAST_OBJECT_IDEAL	= NP_OPTION_LAST_OBJECT_MAX + 1;
	NP_OPTION_LAST_OBJECT_OUT_OF_RANGE	= NP_OPTION_LAST_OBJECT_IDEAL + 1;
	NP_OPTION_STATUS_LED_ON_START	= NP_OPTION_LAST_OBJECT_OUT_OF_RANGE + 1;
	NP_OPTION_ILLUMINATION_LEDS_ON_START	= NP_OPTION_STATUS_LED_ON_START + 1;
	NP_OPTION_CAMERA_ROTATION	= NP_OPTION_ILLUMINATION_LEDS_ON_START + 1;
	NP_OPTION_MIRROR_X	= NP_OPTION_CAMERA_ROTATION + 1;
	NP_OPTION_MIRROR_Y	= NP_OPTION_MIRROR_X + 1;
	NP_OPTION_SEND_EMPTY_FRAMES	= NP_OPTION_MIRROR_Y + 1;
	NP_OPTION_CAMERA_ID	= NP_OPTION_SEND_EMPTY_FRAMES + 1;
	NP_OPTION_CAMERA_ID_DEFAULT	= NP_OPTION_CAMERA_ID + 1;
	NP_OPTION_FRAME_RATE	= NP_OPTION_CAMERA_ID_DEFAULT + 1;
	NP_OPTION_FRAME_RATE_DEFAULT	= NP_OPTION_FRAME_RATE + 1;
	NP_OPTION_EXPOSURE	= NP_OPTION_FRAME_RATE_DEFAULT + 1;
	NP_OPTION_EXPOSURE_DEFAULT	= NP_OPTION_EXPOSURE + 1;
	NP_OPTION_VIDEO_TYPE	= NP_OPTION_EXPOSURE_DEFAULT + 1;
	NP_OPTION_VIDEO_TYPE_DEFAULT	= NP_OPTION_VIDEO_TYPE + 1;
	NP_OPTION_INTENSITY	= NP_OPTION_VIDEO_TYPE_DEFAULT + 1;
	NP_OPTION_INTENSITY_DEFAULT	= NP_OPTION_INTENSITY + 1;
	NP_OPTION_FRAME_DECIMATION	= NP_OPTION_INTENSITY_DEFAULT + 1;
	NP_OPTION_FRAME_DECIMATION_DEFAULT	= NP_OPTION_FRAME_DECIMATION + 1;
	NP_OPTION_MINIMUM_SEGMENT_LENGTH	= NP_OPTION_FRAME_DECIMATION_DEFAULT + 1;
	NP_OPTION_MINIMUM_SEGMENT_LENGTH_DEFAULT	= NP_OPTION_MINIMUM_SEGMENT_LENGTH + 1;
	NP_OPTION_MAXIMUM_SEGMENT_LENGTH	= NP_OPTION_MINIMUM_SEGMENT_LENGTH_DEFAULT + 1;
	NP_OPTION_MAXIMUM_SEGMENT_LENGTH_DEFAULT	= NP_OPTION_MAXIMUM_SEGMENT_LENGTH + 1;
	NP_OPTION_WINDOW_EXTENTS_X	= NP_OPTION_MAXIMUM_SEGMENT_LENGTH_DEFAULT + 1;
	NP_OPTION_WINDOW_EXTENTS_X_DEFAULT	= NP_OPTION_WINDOW_EXTENTS_X + 1;
	NP_OPTION_WINDOW_EXTENTS_X_END	= NP_OPTION_WINDOW_EXTENTS_X_DEFAULT + 1;
	NP_OPTION_WINDOW_EXTENTS_X_END_DEFAULT	= NP_OPTION_WINDOW_EXTENTS_X_END + 1;
	NP_OPTION_WINDOW_EXTENTS_Y	= NP_OPTION_WINDOW_EXTENTS_X_END_DEFAULT + 1;
	NP_OPTION_WINDOW_EXTENTS_Y_DEFAULT	= NP_OPTION_WINDOW_EXTENTS_Y + 1;
	NP_OPTION_WINDOW_EXTENTS_Y_END	= NP_OPTION_WINDOW_EXTENTS_Y_DEFAULT + 1;
	NP_OPTION_WINDOW_EXTENTS_Y_END_DEFAULT	= NP_OPTION_WINDOW_EXTENTS_Y_END + 1;
	NP_OPTION_RESET_FRAME_COUNT	= NP_OPTION_WINDOW_EXTENTS_Y_END_DEFAULT + 1;
	NP_OPTION_USER_HWND	= NP_OPTION_RESET_FRAME_COUNT + 1;
	NP_OPTION_MULTICAM	= NP_OPTION_USER_HWND + 1;
	NP_OPTION_MULTICAM_MASTER	= NP_OPTION_MULTICAM + 1;
	NP_OPTION_MULTICAM_GROUP_NOTIFY	= NP_OPTION_MULTICAM_MASTER + 1;
	NP_OPTION_NUMERIC_DISPLAY_ON	= NP_OPTION_MULTICAM_GROUP_NOTIFY + 1;
	NP_OPTION_NUMERIC_DISPLAY_OFF	= NP_OPTION_NUMERIC_DISPLAY_ON + 1;
	NP_OPTION_SEND_FRAME_MASK	= NP_OPTION_NUMERIC_DISPLAY_OFF + 1;
	NP_OPTION_TEXT_OVERLAY_OPTION	= NP_OPTION_SEND_FRAME_MASK + 1;
	NP_OPTION_USER_DEF1	= NP_OPTION_TEXT_OVERLAY_OPTION + 1;
	NP_OPTION_SCORING_ENABLED	= NP_OPTION_USER_DEF1 + 1;
	NP_OPTION_GRAYSCALE_DECIMATION	= NP_OPTION_SCORING_ENABLED + 1;
	NP_OPTION_OBJECT_CAP	= NP_OPTION_GRAYSCALE_DECIMATION + 1;
	NP_OPTION_HARDWARE_REVISION	= NP_OPTION_OBJECT_CAP + 1;

  NP_FRAME_SENDEMPTY	= $1;
	NP_FRAME_SENDINVALID	= $2;

  NP_HW_MODEL_OLDTRACKIR	= $100800a8;
	NP_HW_MODEL_SMARTNAV	= NP_HW_MODEL_OLDTRACKIR + 1;
	NP_HW_MODEL_TRACKIR	= NP_HW_MODEL_SMARTNAV + 1;
	NP_HW_MODEL_OPTITRACK	= NP_HW_MODEL_TRACKIR + 1;
	NP_HW_MODEL_UNKNOWN	= NP_HW_MODEL_OPTITRACK + 1;

  NP_HW_REVISION_OLDTRACKIR_LEGACY	= $200800b8;
	NP_HW_REVISION_OLDTRACKIR_BASIC	= NP_HW_REVISION_OLDTRACKIR_LEGACY + 1;
	NP_HW_REVISION_OLDTRACKIR_EG	= NP_HW_REVISION_OLDTRACKIR_BASIC + 1;
	NP_HW_REVISION_OLDTRACKIR_AT	= NP_HW_REVISION_OLDTRACKIR_EG + 1;
	NP_HW_REVISION_OLDTRACKIR_GX	= NP_HW_REVISION_OLDTRACKIR_AT + 1;
	NP_HW_REVISION_OLDTRACKIR_MAC	= NP_HW_REVISION_OLDTRACKIR_GX + 1;
	NP_HW_REVISION_SMARTNAV_BASIC	= NP_HW_REVISION_OLDTRACKIR_MAC + 1;
	NP_HW_REVISION_SMARTNAV_EG	= NP_HW_REVISION_SMARTNAV_BASIC + 1;
	NP_HW_REVISION_SMARTNAV_AT	= NP_HW_REVISION_SMARTNAV_EG + 1;
	NP_HW_REVISION_SMARTNAV_MAC_BASIC	= NP_HW_REVISION_SMARTNAV_AT + 1;
	NP_HW_REVISION_SMARTNAV_MAC_AT	= NP_HW_REVISION_SMARTNAV_MAC_BASIC + 1;
	NP_HW_REVISION_TRACKIR_BASIC	= NP_HW_REVISION_SMARTNAV_MAC_AT + 1;
	NP_HW_REVISION_TRACKIR_PRO	= NP_HW_REVISION_TRACKIR_BASIC + 1;
	NP_HW_REVISION_OPTITRACK_BASIC	= NP_HW_REVISION_TRACKIR_PRO + 1;
	NP_HW_REVISION_OPTITRACK_FLEX	= NP_HW_REVISION_OPTITRACK_BASIC + 1;
	NP_HW_REVISION_OPTITRACK_SLIM	= NP_HW_REVISION_OPTITRACK_FLEX + 1;
	NP_HW_REVISION_UNKNOWN	= NP_HW_REVISION_OPTITRACK_SLIM + 1;

  NP_OBJECT_COLOR_OPTION_ALL_SAME	= 0;
	NP_OBJECT_COLOR_OPTION_TRACKED_ONLY	= NP_OBJECT_COLOR_OPTION_ALL_SAME + 1;
	NP_OBJECT_COLOR_OPTION_SHADE_BY_RANK	= NP_OBJECT_COLOR_OPTION_TRACKED_ONLY + 1;
	NP_OBJECT_COLOR_OPTION_VECTOR	= NP_OBJECT_COLOR_OPTION_SHADE_BY_RANK + 1;
	NP_OBJECT_COLOR_OPTION_VECTOR_SHADE_BY_RANK	= NP_OBJECT_COLOR_OPTION_VECTOR + 1;

  NP_TEXT_OVERLAY_HEADER	= $1;
	NP_TEXT_OVERLAY_OBJECT	= $2;
	NP_TEXT_OVERLAY_OBJECT_HIGHLIGHT	= $4;

  NP_SWITCH_STATE_BOTH_DOWN	= 0;
	NP_SWITCH_STATE_ONE_DOWN	= $4;
	NP_SWITCH_STATE_TWO_DOWN	= $8;
	NP_SWITCH_STATE_BOTH_UP	= $c;

  NP_LED_ONE	= 0;
	NP_LED_TWO	= NP_LED_ONE + 1;
	NP_LED_THREE	= NP_LED_TWO + 1;
	NP_LED_FOUR	= NP_LED_THREE + 1;

  NP_CAMERA_ROTATION_0	= 0;
	NP_CAMERA_ROTATION_90	= NP_CAMERA_ROTATION_0 + 1;
	NP_CAMERA_ROTATION_180	= NP_CAMERA_ROTATION_90 + 1;
	NP_CAMERA_ROTATION_270	= NP_CAMERA_ROTATION_180 + 1;

  TRACKIR_3       = 4;
  TRACKIR_4       = 5;
  OPTITRACK_C120  = 6;
  OPTITRACK_V100  = 7;
  SMARTNAV_4      = 8;

  // focal_length/pixel_mm_width
  ZSCALAR_TRACKIR3 = 597;
  ZSCALAR_TRACKIR4 = 395;
  ZSCALAR_SMARTNAV4 = 817;
  ZSCALAR_C120 = 420;
  ZSCALAR_V100 = 750;


  OPTITRACK_FILENAME = 'OptiTrack.dll';

  KEY_OPTITRACK_LOCATION = 'TypeLib\{2627555C-CA32-4D0D-AA55-D04783A5497E}\1.0\0\win32';


{$R *.dfm}

constructor TCam.Create(pcam : INPCamera; serialnumber : Integer);
begin
  FCamPointer := pcam;
  FSerialNumber := serialnumber;
end;

constructor TdmOptitrack.Create(AOwner : TComponent);
var
  aKey : TRegistry;
  aLocation : String;
begin
  // test whether Optitrack installed
  aKey := TRegistry.Create(KEY_READ);
  try
    aKey.RootKey := HKEY_CLASSES_ROOT;
    if aKey.OpenKey(KEY_OPTITRACK_LOCATION, True) then
      aLocation := aKey.ReadString('') // read default
    else
      aLocation := '';
    aKey.CloseKey;
  finally
    aKey.Free;
  end;

 if (aLocation <> '') and (LoadLibraryEx(PAnsiChar(aLocation), 0, LOAD_WITH_ALTERED_SEARCH_PATH) <> 0) then begin
    try
      Inherited;
      FAvailable := True;
    except
      FAvailable := False;
    end;
    FVisible := True;
    ListPoint := TListPoint.Create;
    ListCam := TList.Create;
    fOwner := AOwner as TForm;
    aVideoWindow := (fOwner.FindComponent('VideoWindow1') as TVideoWindow);
    aCanvas := (fOwner.FindComponent('VideoWindow1') as TVideoWindow).Canvas;
    aCanvas.Pen.Width := 1;
    aCanvas.TextHeight('10');
    aCanvas.Font.Color := clWhite;

    {UpdateOutputThread := TUpdateThread.Create(True);
    eventUpdate := TEvent.Create(nil, FALSE, FALSE, 'Update');     }

  end else
    FAvailable := False;

end;

procedure TdmOptitrack.Enum;
begin
  if FAvailable then begin
    NPCameraCollection1.Connect;
    NPCameraCollection1.Enum;
  end;
end;

procedure TdmOptitrack.Select(aSerial : Integer);
var
  i : Integer;
  scale : Double;
begin
  for i := 0 to ListCam.Count - 1 do begin
    if aSerial = TCam(ListCam.Items[i]).SerialNumber then begin
      NPCamera1.ConnectTo(TCam(ListCam.Items[i]).CamPointer);
      NPCamera1.Open;
      NPCamera1.OnFrameAvailable := NPCamera1FrameAvailable;
      NPCamera1.SetLED(NP_LED_TWO, False); // green

      // vector tracking only tracks up to 3 points, treat all points as same instead
      NPCamera1.SetOption(NP_OPTION_OBJECT_COLOR_OPTION, NP_OBJECT_COLOR_OPTION_ALL_SAME);

      NPCamera1.SetOption(NP_OPTION_SEND_EMPTY_FRAMES, True); // keep updating
      NPCamera1.SetOption(NP_OPTION_STATUS_GREEN_ON_TRACKING, False); // use different status light technique
      //NPCamera1.SetOption(NP_OPTION_TEXT_OVERLAY_OPTION, NP_TEXT_OVERLAY_HEADER + NP_TEXT_OVERLAY_OBJECT + NP_TEXT_OVERLAY_OBJECT_HIGHLIGHT);
       //scale := 2;
       //NPCamera1.SetOption(NP_OPTION_DRAW_SCALE, scale);

      NPCamera1.SetOption(NP_OPTION_TRACKED_OBJECT_COLOR, clRed);
      NPCamera1.SetOption(NP_OPTION_UNTRACKED_OBJECTS_COLOR, clRed);

      case NPCamera1.GetOption(NP_OPTION_HARDWARE_REVISION) of
        TRACKIR_3 : FZScalar := ZSCALAR_TRACKIR3;
        TRACKIR_4 : FZScalar := ZSCALAR_TRACKIR4;
        OPTITRACK_C120 : FZScalar := ZSCALAR_C120;
        OPTITRACK_V100 : FZScalar := ZSCALAR_V100;
        SMARTNAV_4 : FZScalar := ZSCALAR_SMARTNAV4;
        else FZScalar := 0;
      end;

      OptiCamParams.FrameRate := NPCamera1.FrameRate;
      OptiCamParams.SenWidth := NPCamera1.Width;
      OptiCamParams.SenHeight := NPCamera1.Height;

    end;
  end;
end;

procedure TdmOptitrack.Play;
begin
  NPCamera1.Start;
  CamState := camPlaying;
end;

procedure TdmOptitrack.Pause;
begin
  // important that camera is started before calling setvideo
  if CamState = camPlaying then
    NPCamera1.SetVideo(False);
  NPCamera1.SetLED(NP_LED_ONE, False); // IR
  CamState := camPaused;
end;

procedure TdmOptitrack.PlayPaused;
begin
  // important that camera is started before calling setvideo
  if CamState = camPaused then
    NPCamera1.SetVideo(True);
  NPCamera1.SetLED(NP_LED_ONE, FIRIllumination); // IR
  CamState := camPlaying;
end;

procedure TdmOptitrack.Stop;
begin
  NPCamera1.Stop;
  CamState := camStopped;
end;

procedure TdmOptitrack.SetTracking(tracking : TTypeState);
begin
  if tracking = TrackState then
    Exit;

  TrackState := tracking;
  case TrackState of
    tsON_Ok : begin
      NPCamera1.SetLED(NP_LED_TWO, True); // green
      NPCamera1.SetLED(NP_LED_THREE, False); //red
    end;
    tsOn_HS : begin
      NPCamera1.SetLED(NP_LED_TWO, False); // green
      NPCamera1.SetLED(NP_LED_THREE, True); //red
    end;
    tsOff : begin
      NPCamera1.SetLED(NP_LED_TWO, False); // green
      NPCamera1.SetLED(NP_LED_THREE, False); //red
    end;
  end;
end;


destructor TdmOptitrack.Destroy;
begin
  if FAvailable then begin
    NPCamera1.Stop;
    NPCamera1.Close;
    NPCamera1.Disconnect;
    NPCameraCollection1.Disconnect;
    Inherited;
  end;
end;


procedure TdmOptitrack.NPCameraCollection1DeviceArrival(ASender: TObject;
  const pCamera: INPCamera);
begin
  if Assigned(FOnNewSource) then
    FOnNewSource(camOptitrack, pCamera.SerialNumber);

  {need to use own list to track camera pointers and serials because when a camera is physically
  remove only the pointer address can be used to identify the camera}
  ListCam.Add(TCam.Create(pCamera, pCamera.SerialNumber));

  pCamera.Open;
 {camera MUST be started at least once to enable standby mode (flashing green light)
  before closing so that it can be later enumerated properly}
  pCamera.Start;
  pCamera.Stop;

  pCamera.SetLED(NP_LED_ONE, False); // IR
  pCamera.SetLED(NP_LED_TWO, False); // green
  pCamera.SetLED(NP_LED_THREE, False); //red
  pCamera.SetLED(NP_LED_FOUR, False); //blue
  pCamera.Close;
end;


procedure TdmOptitrack.NPCameraCollection1DeviceRemoval(ASender: TObject;
  const pCamera: INPCamera);
var
  i : Integer;
begin
  {pCamera is a null pointer when camera is physically removed,
  NPCameraCollection count goes to zero before item removal can be managed}
  for i := 0 to ListCam.Count - 1 do
    if TCam(ListCam.Items[i]).CamPointer = pCamera then begin
      if Assigned(FOnLostSource) then
        FOnLostSource(camOptitrack, TCam(ListCam.Items[i]).SerialNumber);
      ListCam.Delete(i);
    end;
end;


procedure TdmOptitrack.NPCamera1FrameAvailable(ASender: TObject;
  const pCamera: INPCamera);
var
  i: Integer;
  temp, x, y : Single;
  aNPPoint : NPObject;
begin
  aFrame := NPCamera1.GetFrame(0);
  ListPoint.Clear;

  if FVisible then begin
    NPCamera1.DrawFrame(aFrame, DisplayHandle);
    DrawScreenCross;
  end;

  if (aFrame <> nil) and not aFrame.IsEmpty and not aFrame.IsCorrupt then begin
    for i := 0 to aFrame.Count - 1 do begin
      aNPPoint := aFrame.Item(i);
      if  (aNPPoint.Width > FMinPointSize) and (aNPPoint.Width < FMaxPointSize) and
          (aNPPoint.Height > FMinPointSize) and (aNPPoint.Height < FMaxPointSize) and
          (aNPPoint.Score > 1) and (aNPPoint.Rank < 6)  then  begin
        // coordinates are float
        x := aNPPoint.X;
        y := aNPPoint.Y;

        // draw point crosses before transformation
        if FVisible then
          DrawPointCross(Point(Round(x), Round(y)));

        // don't bother using Optitrack transform functions which also moves origin to centre
        if FOrient[orRotate] then begin
          // clockwise (looking at front of camera)
          temp := y;
          y := OptiCamParams.SenWidth - x;
          x := temp;
          if FOrient[orFlip] then y := OptiCamParams.SenWidth - y;
          if FOrient[orMirror]  then x := OptiCamParams.SenHeight - x;
        end else begin
          if FOrient[orFlip]  then y := OptiCamParams.SenHeight - y;
          if FOrient[orMirror] then x := OptiCamParams.SenWidth - x;
        end;

        ListPoint.Add(Point(Trunc(x * LISTPOINT_SCALER), Trunc(y * LISTPOINT_SCALER)));
      end;
    end;
  end;

  if Assigned(FOnLedDetected) then
    FOnLedDetected(ListPoint);

  aFrame.Free;

end;


procedure TdmOptitrack.DrawPointCross(aPoint : TPoint);
begin
  aCanvas.Pen.Color := TColor($808080);
  aCanvas.Moveto(aPoint.x - X_POINT_SIZE, aPoint.y);
  aCanvas.Lineto(aPoint.x + X_POINT_SIZE, aPoint.y);
  aCanvas.Moveto(aPoint.x, aPoint.y - X_POINT_SIZE);
  aCanvas.Lineto(aPoint.x, aPoint.y + X_POINT_SIZE);
end;


procedure TdmOptitrack.DrawScreenCross;
begin
  aCanvas.Pen.Color := TColor($606060);
  aCanvas.Moveto(0, aVideoWindow.Height div 2);
  aCanvas.Lineto(aVideoWindow.Width, aVideoWindow.Height div 2);

  aCanvas.Moveto(aVideoWindow.Width div 2, 0);
  aCanvas.Lineto(aVideoWindow.Width div 2, aVideoWindow.Height);
end;


procedure TdmOptitrack.SetThreshold(threshold : Integer);
begin
  NPCamera1.SetOption(NP_OPTION_THRESHOLD, Min(NP_THRESHOLD_MAX, Max(NP_THRESHOLD_MIN, threshold)));
end;


procedure TdmOptitrack.SetIRIllum(lit : Boolean);
begin
  FIRIllumination := lit;
  NPCamera1.SetOption(NP_OPTION_ILLUMINATION_LEDS_ON_START, FIRIllumination);
  if (CamState = camPlaying) then
    NPCamera1.SetLED(NP_LED_ONE, FIRIllumination); // IR
end;

function TdmOptitrack.GetOrient(aOrient : TOrient) : Boolean;
begin
  Result := FOrient[aOrient];
end;

procedure TdmOptitrack.SetOrient(aOrient : TOrient; Value : Boolean);
begin
  FOrient[aOrient] := Value;
end;

procedure TdmOptitrack.SetHostAppRunning(value : Boolean);
begin
  NPCamera1.SetLED(NP_LED_FOUR, value); //blue
end;


{procedure TUpdateThread.Execute;
begin
  repeat
    WaitForSingleObject((dmOptitrack.eventFrameAvailable as TEvent).Handle, 30);
    NPCamera1FrameAvailable(Self, nil);
  until Terminated;
end;   }








end.
