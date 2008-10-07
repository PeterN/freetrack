unit CamManager_fm;

interface

uses
  Classes, Forms, Windows, ComCtrls, ExtCtrls, Controls,
  Buttons, Dialogs, StrUtils, SysUtils, ActiveX, IniFiles, BaseClass,
  StdCtrls, Math, Messages, Registry, Parameters, Graphics, DKLang,
  PngSpeedButton, pngimage, FreeTrackTray, Pose, {Unit1, }DSPack;

type

  TOnStateChanged = procedure (Sender : TObject; isRunning : Boolean) of Object;
  TOnPropPageClick = procedure (hnd : THandle) of Object;

  TlocalRefClock = class(TBCBaseReferenceClock)
  private
  public
  end;

  TCamManager = class(TForm)
    ScrollBox2: TScrollBox;
    laDemoVideo: TLabel;
    DKLanguageController1: TDKLanguageController;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    laFPS: TLabel;
    Label19: TLabel;
    Label86: TLabel;
    laJitter: TLabel;
    Label1: TLabel;
    laFreetrackFilter: TLabel;
    Label57: TLabel;
    laBat: TLabel;
    laBatTitle: TLabel;
    butCamera: TPngSpeedButton;
    butStream: TPngSpeedButton;
    combCam: TComboBox;
    tbSeuil: TTrackBar;
    tsFrameRate: TTabSheet;
    Label17: TLabel;
    Label96: TLabel;
    Label2: TLabel;
    laOutputFPS: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    edManualInterp: TEdit;
    cbInterpAuto: TCheckBox;
    udInterpMultiplier: TUpDown;
    edInterpWebcamFPS: TEdit;
    udInterpWebcamFPS: TUpDown;
    tsPointSize: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    edMaxPointSize: TEdit;
    udMaxPointSize: TUpDown;
    edMinPointSize: TEdit;
    udMinPointSize: TUpDown;
    TabSheet2: TTabSheet;
    laWiiSens1: TLabel;
    laWiiSens2: TLabel;
    laWiiSens3: TLabel;
    laWiiSens4: TLabel;
    laWiiSens5: TLabel;
    laWiiSens6: TLabel;
    laWiiSens7: TLabel;
    laWiiSens8: TLabel;
    laWiiSens9: TLabel;
    laWiiSens10: TLabel;
    laWiiSens11: TLabel;
    tbWiiSens1: TTrackBar;
    tbWiiSens2: TTrackBar;
    tbWiiSens3: TTrackBar;
    tbWiiSens4: TTrackBar;
    tbWiiSens5: TTrackBar;
    tbWiiSens6: TTrackBar;
    tbWiiSens7: TTrackBar;
    tbWiiSens8: TTrackBar;
    tbWiiSens9: TTrackBar;
    tbWiiSens10: TTrackBar;
    tbWiiSens11: TTrackBar;
    Position: TTabSheet;
    Label8: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    edCamPosYaw: TEdit;
    udCamPosYaw: TUpDown;
    cbCamPosPitchAuto: TCheckBox;
    edCamPosPitch: TEdit;
    udCamPosPitch: TUpDown;
    edCamPosRoll: TEdit;
    udCamPosRoll: TUpDown;
    cbCamPosRollAuto: TCheckBox;
    cbOrientMirror: TCheckBox;
    cbOrientFlip: TCheckBox;
    cbOrientRotate: TCheckBox;
    cbShowUnscaledVid: TCheckBox;
    tsCalibration: TTabSheet;
    laSensorWidth: TLabel;
    laFocalLength: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    edCamSensorWidth: TEdit;
    udCamSensorWidth: TUpDown;
    Label18: TLabel;
    edCamFocalLength: TEdit;
    udCamFocalLength: TUpDown;
    cbOptitrackIRIllum: TCheckBox;
    Panel1: TPanel;
    Label20: TLabel;
    cbAutoCalibrate: TCheckBox;
    VideoWindow1: TVideoWindow;
    Label13: TLabel;
    Label14: TLabel;
    TabSheet3: TTabSheet;
    tbNoise1: TTrackBar;
    tbNoise2: TTrackBar;
    Label21: TLabel;
    Label22: TLabel;

    procedure tbSeuilChange(Sender: TObject);
    procedure OnSelectCam(Sender : TObject);
    procedure butCameraProperty(Sender: TObject);
    procedure butStreamProperty(Sender: TObject);
    procedure OrientChange(Sender: TObject);
    procedure cbShrinkVidClick(Sender: TObject);
    procedure cbInterpAutoClick(Sender: TObject);
    procedure udInterpMultiplierClick(Sender: TObject;
      Button: TUDBtnType);
    procedure udInterpWebcamFPSClick(Sender: TObject;
      Button: TUDBtnType);
    procedure udPointSizeClick(Sender: TObject; Button: TUDBtnType);
    procedure tbWiiSens1Change(Sender: TObject);
    procedure cbShowUnscaledVidClick(Sender: TObject);
    procedure udCamPositionClick(Sender: TObject; Button: TUDBtnType);
    procedure cbCamPosAutoClick(Sender: TObject);
    procedure cbOptitrackIRIllumClick(Sender: TObject);
    procedure udCamCalibrateClick(Sender: TObject; Button: TUDBtnType);
    procedure cbAutoCalibrateClick(Sender: TObject);
    procedure DSVideoWindowEx21OverlayVisible(Sender: TObject;
      Visible: Boolean);
    procedure DSVideoWindowEx21ColorKeyChanged(Sender: TObject);
    procedure VideoWindow1Paint(Sender: TObject);
    procedure tbNoiseChange(Sender: TObject);
    procedure DKLanguageController1LanguageChanged(Sender: TObject);

  private
    fOwner : TForm;

    FFps : integer;
    CamName : String;
    ScaleVid : Boolean;
    FSensorSize : TRect;

    FVisible : Boolean;

    FCamState : TCamState;
    FCamSource : TCamSource;
    FCamWidth, FCamHeight : Integer;

    Orient : array[TOrient] of Boolean;

    FOnDemoFinished : TNotifyEvent;
    FOnAlternatePlayPause : TNotifyEvent;
    FOnChangedSource : TNotifyEvent;
    FOnPropPageClick : TOnPropPageClick;

    FOnLedDetected: TOnLedDetected;
    FCameraPropertyOpen : boolean;
    FOnStateChanged: TOnStateChanged;

    abutStart : TPNGSpeedButton;
    ArraycbOrient : array[TOrient] of TCheckBox;
    ArrayudCamPosition : array[TDOF] of TUpDown;
    ArrayedCamPosition : array[TDOF] of TEdit;
    ArraycbCamPosAuto : array[TDOF] of TCheckBox;

    function GetFreeTrackFilter: String;
    procedure SetOnLedDetected(const Value: TOnLedDetected);
    procedure SelectCam(aCamName: string);
    procedure ClearUIData;
    procedure SetVideoWindowSize;
    procedure CamCalibrate;
    procedure GestOnStatusUpdate(batteryCharge : Integer);
    procedure GestOnSourceConnect(Sender : TObject);
    procedure GestOnSourceDisconnect(Sender : TObject);
    procedure GestOnNewSource(source : TCamSource; serial : Integer);
    procedure GestOnLostSource(source : TCamSource; serial : Integer);
    procedure GestOnStop(Sender : TObject);
    procedure GestOnTrackStateChange(Sender : TObject; state : TTypeState);
    procedure GestOnHostAppRunning(Sender : TObject; value : Boolean);
  public
    Constructor Create(AOwner : TComponent); override;
    Destructor Destroy;override;

    procedure LoadCfgFromIni(aIni: TIniFile);
    procedure SaveCfgToIni(aIni: TIniFile);
    procedure LoadGUIConfig;

    function Play : Boolean;
    procedure Pause;
    procedure Stop;

    procedure UpdateUIData(ScreenFPS, AvgJitterCount, ScreenNumberPoints : Integer);
    procedure SetVisible(isVisible : Boolean);

    property OnLedDetected : TOnLedDetected read FOnLedDetected write SetOnLedDetected;
    property OnStateChanged : TOnStateChanged read FOnStateChanged write FOnStateChanged;
    property CamState : TCamState read FCamState;
    property CamSource : TCamSource read FCamSource;
    property FPS : Integer read FFps write FFps;
    property CameraPropertyOpen : Boolean read FCameraPropertyOpen write FCameraPropertyOpen;
    property FreetrackFilter : String read GetFreeTrackFilter;
    property OnDemoFinished : TNotifyEvent read FOnDemoFinished write FOnDemoFinished;
    property SensorSize : TRect read FSensorSize write FSensorSize;
    property OnAlternatePlayPause : TNotifyEvent read FOnAlternatePlayPause write FOnAlternatePlayPause;
    property OnChangedsource : TNotifyEvent read FOnchangedSource write FOnChangedSource;
    property OnPropPageClick : TOnPropPageClick read FOnPropPageClick write FOnPropPageClick;
  end;


var
   aCamManager : TCamManager;

implementation

{$R *.dfm}

uses PoseDataOutput_fm, Wiimote_dm, Optitrack_dm, VideoDevice_dm,
  ForceCamProp_fm;



const
  OrientTxt : array[TOrient] of string = ('Flip', 'Mirror', 'Rotate');
  CamSourceTxt : array[TCamSource] of string = ('Demo ', 'Video ', 'Wii Remote ', 'Optitrack ', '');

resourcestring
  INI_CAMERA          = 'Camera';
  INI_CAMERA_FPS      = 'Fps';
  INI_CAMERA_WIDTH    = 'Width';
  INI_CAMERA_HEIGHT   = 'Height';
  INI_CAMERA_NAME     = 'Name';
  INI_CAMERA_COMPRESS = 'Compressor';
  INI_CAMERA_FILTER   = 'FreetrackFilter';
  INI_POINT_SIZE_MIN  = 'PointSizeMin';
  INI_POINT_SIZE_MAX  = 'PointSizeMax';

{ TCamManager }

constructor TCamManager.Create(AOwner : TComponent);
begin
  Inherited Create(AOwner);

  ArraycbOrient[orFlip] := cbOrientFlip;
  ArraycbOrient[orMirror] := cbOrientMirror;
  ArraycbOrient[orRotate] := cbOrientRotate;

  ArrayudCamPosition[dofYaw] := udCamPosYaw;
  ArrayudCamPosition[dofPitch] := udCamPosPitch;
  ArrayudCamPosition[dofRoll] := udCamPosRoll;

  ArrayedCamPosition[dofYaw] := edCamPosYaw;
  ArrayedCamPosition[dofPitch] := edCamPosPitch;
  ArrayedCamPosition[dofRoll] := edCamPosRoll;

  ArraycbCamPosAuto[dofPitch] := cbCamPosPitchAuto;
  ArraycbCamPosAuto[dofRoll] := cbCamPosRollAuto;

  {tbSeuil.Hint := DKLangConstW('S_HINT_THRESHOLD');
  laFPS.Hint := DKLangConstW('S_HINT_FPS');
  laJitter.Hint := DKLangConstW('S_HINT_JITTER');}

  PageControl1.TabIndex := 0;
  FCamState := camStopped;
  fOwner := AOwner as TForm;
  FVisible := True;

  // video devices must be added to source list before wiimote/optitrack
  dmVideoDevice := TdmVideoDevice.Create(Self);

  dmWiimote := TdmWiimote.Create(Self);
  dmWiimote.OnStatusUpdate := GestOnStatusUpdate;
  dmWiimote.OnConnect := GestOnSourceConnect;
  dmWiimote.OnDisconnect := GestOnSourceDisconnect;
  dmWiimote.OnNewSource := GestOnNewSource;
  dmWiimote.OnLostSource := GestOnLostSource;
  dmWiimote.OnStop := GestOnStop;

  dmOptitrack := TdmOptitrack.Create(Self);
  dmOptitrack.OnNewSource := GestOnNewSource;
  dmOptitrack.OnLostSource := GestOnLostSource;
  dmOptitrack.Enum;

  abutStart := (fOwner.FindComponent('butStart') as TPngSpeedButton);

  aFreeTrackTray.OnHostAppRunning := GestOnHostAppRunning;
  aFreeTrackTray.OnStateChanged := GestOnTrackStateChange;

  {aCanvas.Create;
  aCanvas.Handle := ScrollBox2.Handle;
  aCanvas.Brush.Style := bsClear;
  aCanvas.FloodFill(ScrollBox2.Width, ScrollBox2.Height, clWhite, fsSurface);   }

  LoadGUIConfig;
end;


procedure TCamManager.LoadGUIConfig;
var
  butUD : TUDBtnType;
  aDOF : TDOF;
begin

  butUD := btNext;
  udInterpMultiplier.Position := MyConfig.InterpMultiplier;
  udInterpMultiplierClick(Self, butUD);
  cbInterpAuto.Checked := MyConfig.InterpAutoMultiplier;
  cbInterpAutoClick(Self);
  udInterpWebcamFPS.Position := MyConfig.InterpWebcamFPS;
  udInterpWebcamFPSClick(Self, butUD);

  // applied later on camera source selection
  udCamSensorWidth.Position := Round(MyConfig.CamSensorWidth * 10);
  udCamFocalLength.Position := Round(MyConfig.CamFocalLength * 10);

  // auto cam pos set when source selected
  for aDOF := dofYaw to dofRoll do
    ArrayudCamPosition[aDOF].Position := MyConfig.CamPos[aDOF];

  udCamPositionClick(Self, butUD);

  tbSeuil.Position := MyConfig.Threshold;
  tbSeuilChange(Self);

  laFreetrackFilter.Caption := dmVideoDevice.FilterName;
  laFreetrackFilter.Hint := format(DKLangConstW('S_HINT_FILTER'),[dmVideoDevice.FilterName]);
end;


procedure TCamManager.GestOnSourceConnect(Sender : TObject);
begin
  abutStart.Enabled := True;
end;


procedure TCamManager.GestOnSourceDisconnect(Sender : TObject);
begin
  if CamState = camPlaying then
    abutStart.Click // stop
  else if CamState = camPaused then begin
    abutStart.Click;  // resume
    abutStart.Click;  // stop
  end;
  abutStart.Enabled := False;
  laBat.Caption := '00';
  laBat.Color := clBtnFace;
end;


procedure TCamManager.GestOnNewSource(source : TCamSource; serial : Integer);
begin
  combCam.AddItem(CamSourceTxt[source] + '#' + InttoStr(serial), Self);
end;


procedure TCamManager.GestOnLostSource(source : TCamSource; serial : Integer);
var
  index : Integer;
begin
  if CamState = camPlaying then
    (fOwner.FindComponent('butStart') as TPngSpeedButton).Click; // stop
  if CamState = camPaused then begin
    (fOwner.FindComponent('butStart') as TPngSpeedButton).Click; // start
    (fOwner.FindComponent('butStart') as TPngSpeedButton).Click; // stop
  end;
  ClearUIData;
  index := combcam.Items.IndexOf(CamSourceTxt[source] + '#' + InttoStr(serial));
  if index >= 0 then begin
    combCam.Items.Delete(index);
    SelectCam('');
  end;
end;


procedure TCamManager.OnSelectCam(Sender : TObject);
var
  aDOF : TDOF;
begin

  if AnsiStartsStr(CamSourceTxt[camWii], combCam.Items[combCam.ItemIndex]) then
    FCamSource := camWii
  else if AnsiStartsStr(CamSourceTxt[camOptitrack], combCam.Items[combCam.ItemIndex]) then
    FCamSource := camOptitrack
  else if dmVideoDevice.Available then begin
    if combCam.Items[combCam.ItemIndex] = laDemoVideo.Caption then
      FCamSource := camDemo
    else
      FCamSource := camVid;  // can only be a video device with unknown name
  end else
    FCamSource := camNone;

  CamName := combCam.Items[combCam.ItemIndex];

  if not (FCamSource = camVid) then begin
    butCamera.Enabled := False;
    butStream.Enabled := False;
  end;

  dmWiimote.OnLedDetected := nil;
  dmOptitrack.OnLedDetected := nil;
  laBatTitle.Visible := False;
  laBat.Visible := False;
  laFreetrackFilter.Visible := False;
  tsFrameRate.TabVisible := False;
  tsPointSize.TabVisible := False;
  butStream.Visible := False;
  butCamera.Visible := False;
  cbOptitrackIRIllum.Visible := False;
  cbAutoCalibrate.Checked := False;
  cbAutoCalibrate.Enabled := False;
  ScaleVid := False;

  for aDOF := dofPitch to dofRoll do begin
    ArraycbCamPosAuto[aDOF].Enabled := False;
    ArraycbCamPosAuto[aDOF].Checked := False;
  end;

  dmWiimote.StatusTimer.Enabled := False;

  if PoseDataOutput <> nil then
    PoseDataOutput.cbMouseOutput.Enabled := True;

  case FCamSource of
    camWii : begin
      dmWiimote.Select(StrtoInt(AnsiReplaceStr(combCam.Items[combCam.ItemIndex], CamSourceTxt[camWii] + '#', '')));
      laBatTitle.Visible := True;
      laBat.Visible := True;
      cbAutoCalibrate.Enabled := True;
      cbAutoCalibrate.Checked := MyConfig.CamAutoCalibrate;
      for aDOF := dofPitch to dofRoll do begin
        ArraycbCamPosAuto[aDOF].Enabled := True;
        ArraycbCamPosAuto[aDOF].Checked := MyConfig.CamPosAuto[aDOF];;
      end;
      abutStart.Enabled := dmWiimote.Connected;
      ScaleVid := True;
    end;
    camOptitrack : begin
      if dmOptitrack.Available then begin
        dmOptitrack.Select(StrtoInt(AnsiReplaceStr(combCam.Items[combCam.ItemIndex], CamSourceTxt[camOptitrack] + '#', '')));
        // does camera have known calibration?
        if dmOptitrack.ZScalar <> 0 then begin
          cbAutoCalibrate.Enabled := True;
          cbAutoCalibrate.Checked := MyConfig.CamAutoCalibrate;
        end;
        tsPointSize.TabVisible := True;
        cbOptitrackIRIllum.Visible := True;
        abutStart.Enabled := True;

        cbOptitrackIRIllum.Checked := MyConfig.OptitrackIRIllum;
        cbOptitrackIRIllumClick(Self);
      end;
    end;
    camDemo : begin
      dmVideoDevice.SelectDemo;
      // prevent mouse emulation during demo video so that the mouse isn't stolen
      PoseDataOutput.cbMouseOutput.Checked := False;
      PoseDataOutput.cbMouseOutput.Enabled := False;
      cbAutoCalibrate.Enabled := True;
      cbAutoCalibrate.Checked := MyConfig.CamAutoCalibrate;
      abutStart.Enabled := True;
      tsFrameRate.TabVisible := True;
      tsPointSize.TabVisible := True;
      laFreetrackFilter.Visible := True;
    end;
    camVid : begin
      if dmVideoDevice.SelectVideo then begin
        abutStart.Enabled := True;
        tsFrameRate.TabVisible := True;
        tsPointSize.TabVisible := True;
        butStream.Visible := True;
        butCamera.Visible := True;
        butCamera.Enabled := True;
        butStream.Enabled := True;
        laFreetrackFilter.Visible := True;
        laFreetrackFilter.Caption := dmVideoDevice.FilterName;
        laFreetrackFilter.Hint := format(DKLangConstW('S_HINT_FILTER'),[dmVideoDevice.FilterName]);
      end else begin
        abutStart.Enabled := False;
        butCamera.Enabled := False;
        butStream.Enabled := False;
      end;
    end;
  end;

  SetVideoWindowSize;
  CamCalibrate;
  tbSeuilChange(Self);

  if Assigned(FOnChangedSource) then
    FOnChangedSource(Self);
end;


procedure TCamManager.SelectCam(aCamName: string);
begin
  CamName := '';

  (fOwner.FindComponent('butStart') as TPngSpeedButton).Enabled := False;
  butCamera.Enabled := False;
  butStream.Enabled := False;

  combCam.ItemIndex := combCam.Items.IndexOf(aCamName);
  if combCam.ItemIndex < 0 then // default to demo if in list
    combCam.ItemIndex := combCam.Items.IndexOf(laDemoVideo.Caption);

  CamName := aCamName;
  OnSelectCam(Self);
end;


function TCamManager.Play;
begin
  Result := True;
  case FCamSource of
    camDemo : begin
      if CamState = camStopped then begin
        dmVideoDevice.OnLedDetected := FOnLedDetected;
        dmVideoDevice.OnDemoFinished := FOnDemoFinished;
        Result :=  dmVideoDevice.Play;
        // set defaults
        if Result then begin
          (fOwner.FindComponent('sbTrack3PClip') as TPngSpeedButton).Click;
          (fOwner.FindComponent('sbTrack3PClip') as TPngSpeedButton).Down := True;
          tbSeuil.Position := 30;

        end;
      end else if CamState = camPaused then
        dmVideoDevice.PlayPaused;
    end;
    camWii : begin
      if CamState = camStopped then begin
        if dmWiimote.Connected then begin
          dmWiimote.OnLedDetected := FOnLedDetected;
          Result := dmWiimote.Play;
        end else
          GestOnSourceDisconnect(Self);
      end else if CamState = camPaused then
        dmWiimote.PlayPaused;
    end;
    camVid : begin
      if CamState = camStopped then begin
        dmVideoDevice.OnLedDetected := FOnLedDetected;
        Result := dmVideoDevice.Play;
      end else if CamState = camPaused then
         dmVideoDevice.PlayPaused;
    end;
    camOptitrack: begin
      if CamState = camStopped then begin
        dmOptitrack.OnLedDetected := FOnLedDetected;
        // always assign events, so still works when tray is restarted
        aFreeTrackTray.OnHostAppRunning := GestOnHostAppRunning;
        aFreeTrackTray.OnStateChanged := GestOnTrackStateChange;
        dmOptitrack.DisplayHandle := VideoWindow1.Handle;
        dmOptitrack.Play;
      end else if CamState = camPaused then
        dmOptitrack.PlayPaused
    end;
    else Result := False;
  end;

  {if Seuillage.QueryInterface(IID_IBaseFilter, seuillageClock) = S_OK then
    localRefClock.Create('baseClock',  seuillageClock, hres, nil);   }

  FCamState := camPlaying;
  butStream.Enabled := False;
  combCam.Enabled := False;
end;


procedure TCamManager.Pause;
begin
  case FCamSource of
    camDemo, camVid : dmVideoDevice.Pause;
    camWii : dmWiimote.Pause;
    camOptiTrack : dmOptitrack.Pause;
  end;
  FCamState := camPaused;
  ClearUIData;
end;


procedure TCamManager.Stop;
begin
  case FCamSource of
    camDemo : dmVideoDevice.Stop;
    camVid : begin
      dmVideoDevice.Stop;
      butStream.Enabled := True;
    end;
    camWii : begin
      dmWiimote.Stop;
      VideoWindow1.Repaint;
    end;
    camOptitrack: begin
      dmOptitrack.Stop;
      VideoWindow1.Repaint;
    end;
  end;
  FCamState := camStopped;
  ClearUIData;
  combCam.Enabled := True;
end;



procedure TCamManager.SetOnLedDetected(const Value: TOnLedDetected);
begin
  FOnLedDetected := Value;
end;


function TCamManager.GetFreeTrackFilter: String;
begin
  Result := dmVideoDevice.FilterName;
end;


procedure TCamManager.LoadCfgFromIni(aIni: TIniFile);
var
  aOrient : TOrient;
  butUD : TUDBtnType;
begin
  butUD := btNext;
  dmVideoDevice.Fps := aIni.ReadInteger(INI_CAMERA, INI_CAMERA_FPS, 30);
  dmVideoDevice.Compressor := aIni.ReadString(INI_CAMERA, INI_CAMERA_COMPRESS, '');
  FCamWidth := aIni.ReadInteger(INI_CAMERA, INI_CAMERA_WIDTH, 320);
  FCamHeight := aIni.ReadInteger(INI_CAMERA, INI_CAMERA_HEIGHT, 240);
  dmVideoDevice.CamWidth := FCamWidth;
  dmVideoDevice.CamHeight := FCamHeight;

  CamName := aIni.ReadString(INI_CAMERA, INI_CAMERA_NAME, laDemoVideo.Caption);
  for aOrient := Low(TOrient) to orRotate do begin
    Orient[aOrient] := aIni.ReadBool(INI_CAMERA, OrientTxt[aOrient], False);
    ArraycbOrient[aOrient].Checked := Orient[aOrient];
  end;
  OrientChange(Self);
  udMinPointSize.Position := aIni.ReadInteger(INI_CAMERA, INI_POINT_SIZE_MIN, 2);
  udMaxPointSize.Position := aIni.ReadInteger(INI_CAMERA, INI_POINT_SIZE_MAX, 30);
  udPointSizeClick(Self, butUD);

  // check for other cam sources
  Application.ProcessMessages;
  SelectCam(CamName);
end;



procedure TCamManager.SaveCfgToIni(aIni: TIniFile);
var
  aOrient : TOrient;
begin
  if CamName = '' then
    Exit;

  aIni.WriteString(INI_CAMERA, INI_CAMERA_NAME, CamName);
  aIni.WriteInteger(INI_CAMERA, INI_CAMERA_FPS, dmVideoDevice.Fps);
  aIni.WriteInteger(INI_CAMERA, INI_CAMERA_WIDTH, FCamWidth);
  aIni.WriteInteger(INI_CAMERA, INI_CAMERA_HEIGHT, FCamHeight);
  aIni.WriteString(INI_CAMERA, INI_CAMERA_COMPRESS, dmVideoDevice.Compressor);
  aIni.WriteInteger(INI_CAMERA, INI_POINT_SIZE_MIN, udMinPointSize.Position);
  aIni.WriteInteger(INI_CAMERA, INI_POINT_SIZE_MAX, udMaxPointSize.Position);

  for aOrient := Low(TOrient) to High(TOrient) do
    aIni.WriteBool(INI_CAMERA, OrientTxt[aOrient], Orient[aOrient]);

end;



destructor TCamManager.Destroy;
begin
  butCamera.Enabled := False;
  butStream.Enabled := False;

  dmWiimote.OnStatusUpdate := nil;
  dmWiimote.OnConnect := nil;
  dmWiimote.OnDisconnect := nil;
  dmWiimote.OnNewSource := nil;
  dmWiimote.OnLostSource := nil;
  dmOptitrack.OnNewSource := nil;
  dmOptitrack.OnLostSource := nil;

  Inherited;
end;


procedure TCamManager.tbSeuilChange(Sender: TObject);
begin
  case Camsource of
    camVid, camDemo : if dmVideoDevice.Available then dmVideoDevice.SeuilRouge := tbSeuil.Position;
    camWii : dmWiimote.SetThreshold(tbSeuil.Position);
    camOptitrack : dmOptitrack.SetThreshold(tbSeuil.Position);
  end;
  MyConfig.Threshold := tbSeuil.Position;
end;


procedure TCamManager.butCameraProperty(Sender: TObject);
begin
  if not ForceCamProp.Visible then
    dmVideoDevice.ShowForceCamForm;
end;

procedure TCamManager.butStreamProperty(Sender: TObject);

begin
  if dmVideoDevice.ShowStreamProp then begin
    FCamWidth := dmVideoDevice.CamWidth;
    FCamHeight := dmVideoDevice.CamHeight;
    SetVideoWindowSize;
    CamCalibrate;
  end;
end;



procedure TCamManager.ClearUIData;
begin
  laJitter.Caption := '000';
  laJitter.Color := clBtnFace;
  laFPS.Caption := '000';
  laFPS.Color := clBtnFace;
end;


procedure TCamManager.UpdateUIData(ScreenFPS, AvgJitterCount, ScreenNumberPoints : Integer);
begin
  if FVisible then begin
    if (ScreenFPS > -1) then
      laFPS.Caption := format('%.3d', [ScreenFPS]);
    if (ScreenFPS < 20) then
      laFPS.Color := clRed
    else if (ScreenFPS < 27) then
      laFPS.Color := clYellow
    else
      laFPS.Color := clLime;

    if (AvgJitterCount > -1) then
      laJitter.Caption := format('%.3d', [AvgJitterCount]);
    if (AvgJitterCount > (ScreenFPS div 2)) then
      laJitter.Color := clRed
    else if (AvgJitterCount > (ScreenFPS div 3)) then
      laJitter.Color := clYellow
    else
      laJitter.Color := clLime;
  end;
end;


procedure TCamManager.GestOnStatusUpdate(batteryCharge : Integer);
var
  butUD : TUDBtnType;
begin
  butUD := btNext;
  laBat.Caption := InttoStr(batteryCharge) + '%';
  if batteryCharge < 10 then
    laBat.Color := clRed
  else if batteryCharge < 20 then
    laBat.Color := clYellow
  else
    laBat.Color := clLime;

  if cbCamPosPitchAuto.Checked then ArrayudCamPosition[dofPitch].Position := dmWiimote.CamPos[dofPitch];
  if cbCamPosRollAuto.Checked then ArrayudCamPosition[dofRoll].Position := dmWiimote.CamPos[dofRoll];
  udCamPositionClick(Self, butUD);

end;


procedure TCamManager.SetVisible(isVisible : Boolean);
begin
  if isVisible then begin
    FVisible := True;
    dmWiimote.Visible := True;
    dmOptitrack.Visible := True;
    if (camState <> camStopped) and ((CamSource = camDemo) or (CamSource = camVid)) then
      VideoWindow1.Visible := True;
  end else begin
    FVisible := False;
    ClearUIData;
    dmWiimote.Visible := False;
    dmOptitrack.Visible := False;
  end;
end;


procedure TCamManager.OrientChange(Sender: TObject);
var
  aOrient : TOrient;
begin
  for aOrient := Low(TOrient) to High(TOrient) do
    if Sender = ArraycbOrient[aOrient] then begin
      Orient[aOrient] := ArraycbOrient[aOrient].Checked;
      Break;
    end;

  cbOrientFlip.Enabled := True;
  cbOrientMirror.Enabled := True;
  if (CamSource <> camVid) and (CamSource <> camDemo) then
    cbOrientRotate.Enabled := True;

  case FCamSource of
    camWii : begin
      for aOrient := Low(TOrient) to High(TOrient) do
        dmWiimote.Orient[aOrient] := Orient[aOrient];
    end;
    camOptitrack : begin
      for aOrient := Low(TOrient) to High(TOrient) do
        dmOptitrack.Orient[aOrient] := Orient[aOrient];
    end;
    camDemo, camVid : begin
      for aOrient := Low(TOrient) to High(TOrient) do
        dmVideoDevice.ChangeVidOrient;
    end;
  end;
  SetVideoWindowSize;
end;



procedure TCamManager.GestOnStop(Sender : TObject);
begin
  if Assigned(FOnAlternatePlayPause) then
    FOnAlternatePlayPause(Self);
end;


procedure TCamManager.cbShrinkVidClick(Sender: TObject);
begin

  case FCamSource of
    camWii : begin
      if dmWiimote.Orient[orRotate] then begin

      end;
    end;
    camOptitrack : begin

    end;
    camDemo, camVid : begin

    end;
  end;
end;


procedure TCamManager.cbInterpAutoClick(Sender: TObject);
begin
   // keep total interpolations < 140fps
  if cbInterpAuto.Checked then begin
    if MyConfig.InterpWebcamFPS < 35 then
      MyConfig.InterpMultiplier := 4
    else if  MyConfig.InterpWebcamFPS < 45 then
      MyConfig.InterpMultiplier := 3
    else if  MyConfig.InterpWebcamFPS < 65 then
      MyConfig.InterpMultiplier := 2
    else MyConfig.InterpMultiplier := 1;
    udInterpMultiplier.Position := MyConfig.InterpMultiplier;
  end;
  MyConfig.InterpAutoMultiplier := cbInterpAuto.Checked;
  udInterpMultiplier.Enabled := not MyConfig.InterpAutoMultiplier;
  edManualInterp.Enabled := not MyConfig.InterpAutoMultiplier;
  laOutputFPS.Caption := InttoStr(MyConfig.InterpWebcamFPS * MyConfig.InterpMultiplier);
end;


procedure TCamManager.udInterpMultiplierClick(Sender: TObject;
  Button: TUDBtnType);
begin
  MyConfig.InterpMultiplier := udInterpMultiplier.Position;
  laOutputFPS.Caption := InttoStr(MyConfig.InterpWebcamFPS * MyConfig.InterpMultiplier);
end;



procedure TCamManager.udInterpWebcamFPSClick(Sender: TObject;
  Button: TUDBtnType);
begin
  MyConfig.InterpWebcamFPS := udInterpWebcamFPS.Position;
  cbInterpAutoClick(Self);
end;



procedure TCamManager.udPointSizeClick(Sender: TObject;
  Button: TUDBtnType);
begin
  if udMinPointSize.Position > udMaxPointSize.Position then
    udMaxPointSize.Position := udMinPointSize.Position;
  if udMaxPointSize.Position < udMinPointSize.Position then
    udMinPointSize.Position := udMaxPointSize.Position;

  dmVideoDevice.MinPointSize := udMinPointSize.Position;
  dmVideoDevice.MaxPointSize := udMaxPointSize.Position;
  dmOptitrack.MinPointSize := udMinPointSize.Position;
  dmOptitrack.MaxPointSize := udMaxPointSize.Position;

end;


procedure TCamManager.tbWiiSens1Change(Sender: TObject);
begin
  laWiiSens1.Caption := IntToStr(tbWiiSens1.Position);
  laWiiSens2.Caption := IntToStr(tbWiiSens2.Position);
  laWiiSens3.Caption := IntToStr(tbWiiSens3.Position);
  laWiiSens4.Caption := IntToStr(tbWiiSens4.Position);
  laWiiSens5.Caption := IntToStr(tbWiiSens5.Position);
  laWiiSens6.Caption := IntToStr(tbWiiSens6.Position);
  laWiiSens7.Caption := IntToStr(tbWiiSens7.Position);
  laWiiSens8.Caption := IntToStr(tbWiiSens8.Position);
  laWiiSens9.Caption := IntToStr(tbWiiSens9.Position);
  laWiiSens10.Caption := IntToStr(tbWiiSens10.Position);
  laWiiSens11.Caption := IntToStr(tbWiiSens11.Position);

  dmWiimote.SetIRReg(  [tbWiiSens1.Position,
                        tbWiiSens2.Position,
                        tbWiiSens3.Position,
                        tbWiiSens4.Position,
                        tbWiiSens5.Position,
                        tbWiiSens6.Position,
                        tbWiiSens7.Position,
                        tbWiiSens8.Position,
                        tbWiiSens9.Position],
                       [tbWiiSens10.Position,
                        tbWiiSens11.Position ]);



end;



procedure TCamManager.cbShowUnscaledVidClick(Sender: TObject);
begin
  ScaleVid := not cbShowUnscaledVid.Checked;
  SetVideoWindowSize;
end;


procedure TCamManager.SetVideoWindowSize;
var
  temp : Integer;
  rect : TRect;
begin
  rect.right := DEMO_WIDTH;
  rect.bottom := DEMO_HEIGHT;
  if ScaleVid then begin
    case FCamSource of
      camWii : begin
        SetRect(rect, 0, 0, WII_SCALED_WIDTH, WII_SCALED_HEIGHT);
        dmWiimote.ScaleVid := True;
      end;
      camVid : SetRect(rect, 0, 0, dmVideoDevice.CamWidth, dmVideoDevice.CamHeight);
      camDemo : SetRect(rect, 0, 0, DEMO_WIDTH, DEMO_HEIGHT);
      camOptitrack : SetRect(rect, 0, 0, dmOptitrack.OptiCamParams.SenWidth, dmOptitrack.OptiCamParams.SenHeight);
    end;
  end else begin
    case FCamSource of
      camWii : begin
        SetRect(rect, 0, 0, WII_SEN_WIDTH, WII_SEN_HEIGHT);
        dmWiimote.ScaleVid := False;
      end;
      camVid : SetRect(rect, 0, 0, dmVideoDevice.CamWidth, dmVideoDevice.CamHeight);
      camDemo : SetRect(rect, 0, 0, DEMO_WIDTH, DEMO_HEIGHT);
      camOptitrack : SetRect(rect, 0, 0, dmOptitrack.OptiCamParams.SenWidth, dmOptitrack.OptiCamParams.SenHeight);
    end;
  end;

  if FCamSource = camWii then
    if Orient[orRotate] then begin
      temp := rect.Right;
      rect.Right := rect.Bottom;
      rect.Bottom := temp;
    end;

  case FCamSource of
    camWii : SetRect(FSensorSize, 0, 0, WII_SEN_WIDTH, WII_SEN_HEIGHT);
    camVid : SetRect(FSensorSize, 0, 0, FCamWidth, FCamHeight);
    camDemo : SetRect(FSensorSize, 0, 0, DEMO_WIDTH, DEMO_HEIGHT);
    camOptitrack : SetRect(FSensorSize, 0, 0, dmOptitrack.OptiCamParams.SenWidth, dmOptitrack.OptiCamParams.SenHeight);
  end;

  //rect.right := 2 * DEMO_WIDTH;
  //rect.bottom := 2 * DEMO_HEIGHT;

  VideoWindow1.Width := rect.Right;
  VideoWindow1.Height := rect.Bottom;
end;




procedure TCamManager.udCamPositionClick(Sender: TObject;
  Button: TUDBtnType);
var
  aDOF : TDOF;
begin
  for aDOF := dofYaw to dofRoll do
    MyConfig.CamPos[aDOF] := ArrayudCamPosition[aDOF].Position;
end;



procedure TCamManager.cbCamPosAutoClick(Sender: TObject);
var
  aDOF : TDOF;
begin
  for aDOF := dofPitch to dofRoll do
    if Sender = ArraycbCamPosAuto[aDOF] then begin
      MyConfig.CamPosAuto[aDOF] := ArraycbCamPosAuto[aDOF].Checked;
      ArrayudCamPosition[aDOF].Enabled := not MyConfig.CamPosAuto[aDOF];
      ArrayedCamPosition[aDOF].Enabled := not MyConfig.CamPosAuto[aDOF];
    end;

  cbOrientFlip.Enabled := not MyConfig.CamPosAuto[dofRoll];
  cbOrientMirror.Enabled := not MyConfig.CamPosAuto[dofRoll];
  cbOrientRotate.Enabled := not MyConfig.CamPosAuto[dofRoll];
end;



procedure TCamManager.GestOnTrackStateChange(Sender : TObject; state : TTypeState);
begin
  if CamSource = camOptitrack then
    dmOptitrack.Tracking := state;

end;

procedure TCamManager.GestOnHostAppRunning(Sender : TObject; value : Boolean);
begin
  if CamSource = camOptitrack then
    dmOptitrack.HostAppRunning := value;
end;



procedure TCamManager.cbOptitrackIRIllumClick(Sender: TObject);
begin
  MyConfig.OptitrackIRIllum := cbOptitrackIRIllum.Checked;
  dmOptitrack.SetIRIllum(MyConfig.OptitrackIRIllum);
end;


procedure TCamManager.CamCalibrate;
var
  customZScalar : Single;
begin


  if cbAutoCalibrate.Checked then begin
    edCamSensorWidth.Text := 'NA';
    edCamFocalLength.Text := 'NA';
  end else begin
    edCamSensorWidth.Text := Format('%.1f', [udCamSensorWidth.Position * 0.1]);
    edCamFocalLength.Text := Format('%.1f', [udCamFocalLength.Position * 0.1]);
  end;
  MyConfig.CamSensorWidth := udCamSensorWidth.Position * 0.1;
  MyConfig.CamFocalLength := udCamFocalLength.Position * 0.1;

  customZScalar := MyConfig.CamFocalLength/(MyConfig.CamSensorWidth/SensorSize.Right);

  edCamSensorWidth.Enabled := not cbAutoCalibrate.Checked;
  edCamFocalLength.Enabled := not cbAutoCalibrate.Checked;
  udCamSensorWidth.Enabled := not cbAutoCalibrate.Checked;
  udCamFocalLength.Enabled := not cbAutoCalibrate.Checked;

  case FCamSource of
    camWii:
      if cbAutoCalibrate.Checked then
        MyPoseObj.ZScalar := WII_ZSCALAR
      else
        MyPoseObj.ZScalar := customZScalar;
    camOptitrack:
      if cbAutoCalibrate.Checked then
        MyPoseObj.ZScalar := dmOptitrack.ZScalar
      else
        MyPoseObj.ZScalar := customZScalar;
    camDemo:
      if cbAutoCalibrate.Checked then
        MyPoseObj.ZScalar := DEMO_ZSCALAR
      else
        MyPoseObj.ZScalar := customZScalar;
    camVid: MyPoseObj.ZScalar := customZScalar;
  end;
end;



procedure TCamManager.udCamCalibrateClick(Sender: TObject;
  Button: TUDBtnType);
begin
  CamCalibrate;
end;

procedure TCamManager.cbAutoCalibrateClick(Sender: TObject);
begin
  CamCalibrate;
end;


procedure TCamManager.DSVideoWindowEx21OverlayVisible(Sender: TObject;
  Visible: Boolean);
begin
  // Panel1.Color := DSVideoWindowEx21.ColorKey;
  //DSVideoWindowEx21.
  //Panel1.BringToFront;



end;



procedure TCamManager.DSVideoWindowEx21ColorKeyChanged(Sender: TObject);
begin

  //Panel1.Color := VideoWindow1.ColorKey;
end;


procedure TCamManager.VideoWindow1Paint(Sender: TObject);
begin
  Panel1.Color := VideoWindow1.Color;
  Panel1.BringToFront;
end;

procedure TCamManager.tbNoiseChange(Sender: TObject);
begin
  dmVideoDevice.SetNoise(tbNoise1.Position, tbNoise2.Position);
end;

procedure TCamManager.DKLanguageController1LanguageChanged(
  Sender: TObject);
begin
  tbSeuil.Hint := DKLangConstW('S_HINT_THRESHOLD');
  laFPS.Hint := DKLangConstW('S_HINT_FPS');
  laJitter.Hint := DKLangConstW('S_HINT_JITTER');

  laFreetrackFilter.Hint := format(DKLangConstW('S_HINT_FILTER'),[dmVideoDevice.FilterName]);
end;

end.
