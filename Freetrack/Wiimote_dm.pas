unit Wiimote_dm;

interface

uses
  Windows, Messages, Math, SysUtils, Classes, StdCtrls, ExtCtrls, Graphics, Forms,
  Dialogs, DSPack, JvHidControllerClass, Seuillage_inc, Parameters;


const
  WII_SEN_WIDTH = 1024;
  WII_SEN_HEIGHT = Trunc(0.75 * WII_SEN_WIDTH);
  WII_SCALED_WIDTH = 352;
  WII_SCALED_HEIGHT = Trunc(0.75 * WII_SCALED_WIDTH);
  WII_ZSCALAR = 1320;

type

  TAccelCalib = record
    X0, Y0, Z0,
    XG, YG, ZG : Integer;
  end;

  TOnStatusUpdate = procedure(batteryCharge : Integer) of Object;

  TdmWiimote = class(TDataModule)
    HIDCtrl: TJvHidDeviceController;
    StatusTimer: TTimer;
    SpeakerTimer: TTimer;
    procedure HIDCtrlDeviceChange(Sender: TObject);
    procedure StatusTimerTimer(Sender: TObject);
    procedure HIDCtrlRemoval(HidDev: TJvHidDevice);
    procedure SpeakerTimerTimer(Sender: TObject);
  private
    WiiCount : Integer;
    WiiMote : array[0..3] of TJvHiDDevice;
    ListPoint : TListPoint;
    fOwner : TForm;
    FOnLedDetected : TOnLedDetected;
    Buf: array [0..21] of Byte;
    PointSize : array [0..3] of Integer;
    ibuff : array [0..1024] of Integer;
    CamState : TCamState;
    FVisible : Boolean;
    FOrient : array[TOrient] of Boolean;
    OrientCount, SpeakerCount : Integer;

    FirstSensorStart : Boolean;

    FScaleVid, lastRotate : Boolean;
    vidwind_width : Integer;

    aCanvas : TCanvas;
    aVideoWindow : TVideoWindow;

    AccelCalib : TAccelCalib;
    ButtonRelease, GotStatus : Boolean;

    FConnected : Boolean;
    FOnStatusUpdate : TOnStatusUpdate;
    FOnStop, FOnConnect, FOnDisconnect : TNotifyEvent;
    FOnNewSource, FOnLostSource : TOnSourceChange;
    WiiSel : Integer;
    FSensitivity : Byte;
    FCamPos : array[TDOF] of Integer;
    procedure WriteData; overload;
    procedure WriteData(wiinumber : Integer); overload;
    procedure ClearData;
    procedure WriteRegistry(address : Integer; data : array of Byte; size : Integer);
    procedure DrawPoints;
    procedure GetStatus;
    procedure GestOnData(HidDev: TJvHidDevice; ReportID: Byte;
      const Data: Pointer; Size: Word);
    procedure UpdateVidRotation;
    procedure PlayPCMSound;
    procedure EnableIR;
    procedure DisableIR;
    procedure ReadAccelCalib;
    procedure GestOnUnplug(HidDev: TJvHidDevice);
    procedure TestButtons;
    function GetOrient(aOrient : TOrient) : Boolean;
    function GetCamPos(aDOF : TDOF) : Integer;
    procedure SetScaleVid(Value : Boolean);
    procedure SetOrient(aOrient : TOrient; Value : Boolean);
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function Play : Boolean;
    procedure Pause;
    procedure PlayPaused;
    procedure Stop;
    procedure SetThreshold(threshold : Integer);
    procedure Select(aWiiNumber : Integer);
    procedure SetIRReg(reg1 : array of Byte; reg2 : array of Byte);
    property OnLedDetected : TOnLedDetected read FOnLedDetected write FOnLedDetected;
    property OnStatusUpdate : TOnStatusUpdate read FOnStatusUpdate write FOnStatusUpdate;
    property OnConnect: TNotifyEvent read FOnConnect write FOnConnect;
    property OnDisconnect : TNotifyEvent read FOnDisconnect write FOnDisconnect;
    property OnNewSource : TOnSourceChange read FOnNewSource write FOnNewSource;
    property OnLostSource : TOnSourceChange read FOnLostSource write FOnLostSource;
    property Orient[aOrient : TOrient] : Boolean read GetOrient write SetOrient;
    property OnStop : TNotifyEvent read FOnStop write FOnStop;
    property Connected : Boolean read FConnected;
    property ScaleVid : Boolean read FScaleVid write SetScaleVid;
    property CamPos[aDOF : TDOF] : Integer read GetCamPos;
    property Visible : Boolean read FVisible write FVisible;
  end;

var
  dmWiimote: TdmWiimote;

implementation

const
  WII_FPS = 100;

  WII_REMOTE_VID = $057E;
  WII_REMOTE_PID = $0306;

  // Input report
  IN_BUTTONS				      = $30;
  IN_BUTTONS_ACCEL		    = $31;
  IN_BUTTONS_ACCEL_IR		  = $33; // extended with size info
  IN_BUTTONS_ACCEL_EXT	  = $35;
  IN_BUTTONS_ACCEL_IR_EXT	= $37; // basic with no size

  IN_STATUS						    = $20;
  IN_EEPROM               = $21;

  // Output report
  OUT_NONE			      = $00;
  OUT_LEDs			      = $11;
  OUT_TYPE			      = $12;
  OUT_IR				      = $13;
  OUT_SPEAKER_ENABLE	= $14;
  OUT_STATUS			    = $15;
  OUT_WRITEMEMORY		  = $16;
  OUT_READMEMORY		  = $17;
  OUT_SPEAKER_DATA	  = $18;
  OUT_SPEAKER_MUTE	  = $19;
  OUT_IR2			      	= $1a;

  // Registries
  REGISTER_CALIBRATION			      = $0016;
  REGISTER_IR					            = $04b00030;
	REGISTER_IR_SENSITIVITY_1		    = $04b00000;
	REGISTER_IR_SENSITIVITY_2		    = $04b0001a;
	REGISTER_IR_MODE				        = $04b00033;
	REGISTER_EXTENSION_INIT		      = $04a40040;
  REGISTER_EXTENSION_TYPE		      = $04a400fe;
  REGISTER_EXTENSION_CALIBRATION	= $04a40020;

  REGISTER_SPEAKER                = $04a20001;

  CAMPOS_DELTA = 3;


{$R *.dfm}


constructor TdmWiimote.Create(AOwner : TComponent);
begin
  Inherited;
  fOwner := AOwner as TForm;

  aVideoWindow := (fOwner.FindComponent('VideoWindow1') as TVideoWindow);
  aCanvas := (fOwner.FindComponent('VideoWindow1') as TVideoWindow).Canvas;

  FVisible := True;
  ListPoint := TListPoint.Create;

  FirstSensorStart := True;

  UpdateVidRotation;
  OrientCount := 50;
  SpeakerCount := 0;

end;


destructor TdmWiimote.Destroy;
begin
  if FConnected then
    Stop;
  StatusTimer.Enabled := False;
  Inherited;
end;


procedure TdmWiimote.HIDCtrlDeviceChange(Sender: TObject);
begin
  // get first free wiimote
  if (WiiMote[WiiCount] = nil) and HIDCtrl.CheckOutByID(WiiMote[WiiCount], WII_REMOTE_VID, WII_REMOTE_PID) then begin
    Inc(WiiCount);
    WiiMote[WiiCount - 1].OnUnplug := GestOnUnplug;
    if Assigned(FOnNewSource) then
      FOnNewSource(camWii, WiiCount);
  end;
end;


procedure TdmWiimote.Select(aWiiNumber : Integer);
var
  i : Integer;
begin
  WiiSel := aWiiNumber - 1;
  for i := 0 to WiiCount - 1 do
    WiiMote[i].OnData := nil;
  WiiMote[WiiSel].OnData := GestOnData;
  StatusTimer.Enabled := True;
end;


procedure TdmWiimote.GestOnUnplug(HidDev: TJvHidDevice);
var
  i : Integer;
begin
  for i := 0 to WiiCount - 1 do
    if WiiMote[i] = HidDev then
      if Assigned(FOnLostSource) then begin
        FOnLostSource(camWii, i + 1);
        Break;
      end;
end;


procedure TdmWiimote.GestOnData(HidDev: TJvHidDevice;
  ReportID: Byte; const Data: Pointer; Size: Word);
var
  i, offset, pSize, pitch, roll : Integer;
  x, y, z, temp, addr, accelmag : Single;
  batteryCharge : Integer;
begin

  for i := 0 to (Size - 1) do
    ibuff[i] := Integer(PChar(Data)[i]);

  case ReportID of
    IN_BUTTONS : begin
      TestButtons;
    end;

    IN_BUTTONS_ACCEL_IR : begin
      if CamState = camPlaying then begin
        ListPoint.Clear;
        for i := 0 to 3 do begin // 4 points
          offset := 5 + 3 * i;    // data starts at ibuf[5]
          pSize := ibuff[offset + 2] and $0f;
          // only use point size to determine point existence; x and y info unreliable
          if pSize < $0f then begin
            x := ibuff[offset] + ((ibuff[offset + 2] and $30) shl 4);
            y := WII_SEN_HEIGHT - (ibuff[offset + 1] + ((ibuff[offset + 2] and $c0) shl 2));
            pointSize[i] := pSize;

            // adjust for orientation
            if FOrient[orRotate] then begin
              // clockwise (looking at front of wiimote)
              temp := y;
              y := WII_SEN_WIDTH - x;
              x := temp;
              if FOrient[orFlip] then y := WII_SEN_WIDTH - y;
              if FOrient[orMirror]  then x := WII_SEN_HEIGHT - x;
            end else begin
              if FOrient[orFlip]  then y := WII_SEN_HEIGHT - y;
              if FOrient[orMirror] then x := WII_SEN_WIDTH - x;
            end; 

            ListPoint.Add(Point(Trunc(x * LISTPOINT_SCALER), Trunc(y * LISTPOINT_SCALER)));
          end;
        end;

        // determine wiimote orientation from accelerometer data
        if (OrientCount > WII_FPS * 0.5) then begin
          OrientCount := 0;
          x := (ibuff[2] - AccelCalib.X0) / (AccelCalib.XG - AccelCalib.X0);
          y := (ibuff[3] - AccelCalib.Y0) / (AccelCalib.YG - AccelCalib.Y0);
          z := (ibuff[4] - AccelCalib.Z0) / (AccelCalib.ZG - AccelCalib.Z0);

          accelmag := sqrt(sqr(x) + sqr(y) + sqr(z));

          // only determine orientation when acceleration magnitude is similar to force of gravity
          if (accelmag > 0.9) and (accelmag < 1.1) then begin
            pitch := -Round(RadToDeg(arcsin(y/accelmag)));
            roll := -Round(RadToDeg(arcsin(x/accelmag)));

            if z < 0 then roll := ifthen(x < 0, 1, -1) * 180 - roll;

            // ignore small movements (sensor noise)
            if (pitch > FCamPos[dofPitch] + CAMPOS_DELTA) or (pitch < FCamPos[dofPitch] - CAMPOS_DELTA) then
              FCamPos[dofPitch] := pitch;
            if (roll > FCamPos[dofRoll] + CAMPOS_DELTA) or (roll < FCamPos[dofRoll] - CAMPOS_DELTA) then
              FCamPos[dofRoll] := roll;

            if MyConfig.CamPosAuto[dofRoll] then
              // upright
              if abs(FCamPos[dofRoll]) < 45  then begin
                FOrient[orRotate] := False;
                FOrient[orFlip] := False;
                FOrient[orMirror] := False;
              // upside down
              end else if abs(FCamPos[dofRoll]) > 135 then begin
                FOrient[orRotate] := False;
                FOrient[orFlip] := True;
                FOrient[orMirror] := True;
              // anti-clockwise (looking at front of wiimote)
              end else if (FCamPos[dofRoll] < -45) and (FCamPos[dofRoll] > -135)  then begin
                FOrient[orRotate] := True;
                FOrient[orFlip] := True;
                FOrient[orMirror] := True;
              // clockwise  (looking at front of wiimote)
              end else if (FCamPos[dofRoll] > 45) and (FCamPos[dofRoll] < 135) then begin
                FOrient[orRotate] := True;
                FOrient[orFlip] := False;
                FOrient[orMirror] := False;
              end;
          end;
        end;
        Inc(OrientCount);

        if FVisible then begin
          if FOrient[orRotate] <> lastRotate then
            UpdateVidRotation;
          lastRotate := FOrient[orRotate];
          DrawPoints;
        end;

        TestButtons;
      end;
      if CamState = camPlaying then
        if Assigned(FOnLedDetected) then
          FOnLedDetected(ListPoint);
    end;

    IN_EEPROM : begin
      addr := (ibuff[3] shl 8) + ibuff[4]; // lower two bytes only

      if addr = REGISTER_CALIBRATION then begin
        AccelCalib.X0 := ibuff[5];
        AccelCalib.Y0 := ibuff[6];
        AccelCalib.Z0 := ibuff[7];
        AccelCalib.XG := ibuff[9];
        AccelCalib.YG := ibuff[10];
        AccelCalib.ZG := ibuff[11];
      end;
    end;

    IN_STATUS : begin
      if (CamState <> camPlaying) then begin
        ClearData;
        Buf[0] := OUT_TYPE;
        Buf[1] := $00; // update when data changed
        Buf[2] := IN_BUTTONS;
        WriteData;

        ClearData;
        Buf[0] := OUT_LEDs;
        Buf[1] := $10; // first led as power indicator
        WriteData;
      end;

      GotStatus := True;

      if not FConnected then begin
        if Assigned(FOnConnect) then
          FOnConnect(Self);
        FConnected := True;
        PlayPCMSound;
      end;

      batteryCharge := ibuff[5] div 2; // max 200 -> max 100
      if Assigned(FOnStatusUpdate) then
        FOnStatusUpdate(batteryCharge);
    end;
  end;

end;


procedure TdmWiimote.TestButtons;
begin
  // button A
  if ((ibuff[1] and $08) <> 0) and ButtonRelease then
    if Assigned(FOnStop) then begin
      FOnStop(Self);
      ButtonRelease := False;
    end;

  if not ((ibuff[1] and $08) <> 0) then
    ButtonRelease := True;
end;



procedure TdmWiimote.DrawPoints;
var
  i, PointCount, x, y : Integer;
begin
  aVideoWindow.Repaint;

  PointCount := ListPoint.Count;
  for i := 0 to PointCount - 1 do begin
    x := Round(vidwind_width * ((ListPoint[i].X * LISTPOINT_SCALER_INV)/WII_SEN_WIDTH));
    y := Round(0.75 * vidwind_width * ((ListPoint[i].Y * LISTPOINT_SCALER_INV)/WII_SEN_HEIGHT));

    // points
    aCanvas.Pen.Color := clRed;
    aCanvas.Pen.Width := (PointSize[i] + 1) * 4;
    aCanvas.Moveto(x, y);
    aCanvas.Lineto(x, y);

    // point crosses
    aCanvas.Pen.Color := TColor($808080);
    aCanvas.Pen.Width := 1;
    aCanvas.Moveto(x - X_POINT_SIZE, y);
    aCanvas.Lineto(x + X_POINT_SIZE, y);
    aCanvas.Moveto(x, y - X_POINT_SIZE);
    aCanvas.Lineto(x, y + X_POINT_SIZE);

  end;

  // center cross
  aCanvas.Pen.Color := TColor($606060);
  aCanvas.Pen.Width := 1;
  aCanvas.Moveto(0, aVideoWindow.Height div 2);
  aCanvas.Lineto(aVideoWindow.Width, aVideoWindow.Height div 2);

  aCanvas.Moveto(aVideoWindow.Width div 2, 0);
  aCanvas.Lineto(aVideoWindow.Width div 2, aVideoWindow.Height);
end;


function TdmWiimote.Play;
begin
  CamState := camPlaying;

  ClearData;
  Buf[0] := OUT_LEDs;
  Buf[1] := $90;
  WriteData;

  ReadAccelCalib;

  EnableIR;

  Result := True;
end;


procedure TdmWiimote.Pause;
begin
  CamState := camPaused;
  // stop sensor to save battery power, restart is quick
  Stop;
end;


procedure TdmWiimote.PlayPaused;
begin
  CamState := camPlaying;
  Play;
end;


procedure TdmWiimote.Stop;
begin
  ListPoint.Clear;
  // can't stop while paused so safe to do this:
  if CamState <> camPaused then
    CamState := camStopped;

  SpeakerTimer.Enabled := False;

  ClearData;
  Buf[0] := OUT_SPEAKER_ENABLE;
  Buf[1] := $00;
  WriteData;

  DisableIR;

  ClearData;
  Buf[0] := OUT_LEDs;
  Buf[1] := $10; // first led as power indicator
  WriteData;

  ClearData;
  Buf[0] := OUT_TYPE;
  Buf[1] := $00; // update when data changed
  Buf[2] := IN_BUTTONS;
  WriteData;

end;



procedure TdmWiimote.EnableIR;
const
  // byte 6 sensitivity in reverse
  // byte 7 resolution, small, large and granularity
  // byte 8 sensitivity - doesn't work for low granularity large resolution (maybe auto?)
  //                    - small values (higher sensitivity) smoother than high values

  // Reg1c is optimized for smoothness my maxing sensitivities

  Reg1a : array [0..8] of Byte = ($00, $00, $00, $00, $00, $00, $90, $00, $C0);
  Reg1b : array [0..8] of Byte = ($02, $00, $00, $71, $01, $00, $aa, $00, $64);
  Reg1c : array [0..8] of Byte = ($00, $00, $00, $00, $00, $00, $FF, $00, $C0);

  // byte 0 and byte 1 sensitivity for small values

  Reg2a : array [0..1] of Byte = ($40, $00);
  Reg2b : array [0..1] of Byte = ($63, $03);
  Reg2c : array [0..1] of Byte = ($00, $00);

begin
  ClearData;
  Buf[0] := OUT_TYPE;
  Buf[1] := $04; // continuous reporting // only report when data changed (conserves battery and bt bandwidth)
  Buf[2] := IN_BUTTONS_ACCEL_IR; // extended
  WriteData;

  if FirstSensorStart then Sleep(100);

  // Enable sensor
  ClearData;
  Buf[0] := OUT_IR;
  Buf[1] := $04;
  WriteData;

  ClearData;
  Buf[0] := OUT_IR2;
  Buf[1] := $04;
  WriteData;

  if FirstSensorStart then Sleep(200);

  WriteRegistry(REGISTER_IR, [$08], 1);

  if FirstSensorStart then Sleep(50);

  WriteRegistry(REGISTER_IR_SENSITIVITY_1, Reg1c, Sizeof(Reg1c));

  if FirstSensorStart then Sleep(50);

  WriteRegistry(REGISTER_IR_SENSITIVITY_2, Reg2c, Sizeof(Reg2c));

  if FirstSensorStart then Sleep(50);

  WriteRegistry(REGISTER_IR_MODE, [IN_BUTTONS_ACCEL_IR], 1);

  if FirstSensorStart then Sleep(50);

  WriteRegistry(REGISTER_IR, [$08], 1);

  // only need sleep states when sensor is first started
  FirstSensorStart := False;
end;

procedure TdmWiimote.DisableIR;
begin
  ClearData;
  Buf[0] := OUT_IR;
  Buf[1] := $00;
  WriteData;

  ClearData;
  Buf[0] := OUT_IR2;
  Buf[1] := $00;
  WriteData;
end;


procedure TdmWiimote.ReadAccelCalib;
begin
  ClearData;
  Buf[0] := OUT_READMEMORY;
  Buf[1] := $00; // eeprom
  Buf[2] := $00; // address
  Buf[3] := $00;
  Buf[4] := $16;
  Buf[5] := $00;
  Buf[6] := $07; // seven bytes
  WriteData;
end;


procedure TdmWiimote.GetStatus;
begin
  ClearData;
  Buf[0] := OUT_STATUS;
  WriteData;
end;


procedure TdmWiimote.PlayPCMSound;
const                                                    // volume
  RegSpeak : array [0..6] of Byte = ($00, $04, $00, $1A, $20, $00, $00);
begin
  ClearData;
  Buf[0] := OUT_SPEAKER_ENABLE;
  Buf[1] := $04;
  WriteData;

  ClearData;
  Buf[0] := OUT_SPEAKER_MUTE;
  Buf[1] := $04;
  WriteData;

  WriteRegistry(REGISTER_SPEAKER + 8, [$01], 1);
  WriteRegistry(REGISTER_SPEAKER, [$08], 1);

  WriteRegistry(REGISTER_SPEAKER, RegSpeak , Sizeof(RegSpeak));

  WriteRegistry(REGISTER_SPEAKER + 7, [$01], 1);

  ClearData;
  Buf[0] := OUT_SPEAKER_MUTE;
  Buf[1] := $00;
  WriteData;

  // wait for speaker to turn on
  Sleep(300);

  SpeakerTimer.Enabled := True;

end;


procedure TdmWiimote.SpeakerTimerTimer(Sender: TObject);
const
  //high frequency
  PCMData1 : array [0..19] of Byte =   ($C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3,
                                        $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3, $C3);

  PCMData2 : array [0..19] of Byte =   ($CC, $33, $CC, $33, $CC, $33, $CC, $33, $CC, $33,
                                        $CC, $33, $CC, $33, $CC, $33, $CC, $33, $CC, $33);
  // low frequency
  PCMData3 : array [0..19] of Byte =   ($CC, $CC, $33, $33, $CC, $CC, $33, $33, $CC, $CC,
                                        $33, $33, $CC, $CC, $33, $33, $CC, $CC, $33, $33);
begin

  if SpeakerCount < 4 then begin
    ClearData;
    Buf[0] := OUT_SPEAKER_DATA;
    Buf[1] := 20 shl 3;
    Move(PCMData2, Buf[2], 20);
    WriteData;
  end else if SpeakerCount < 6 then begin
    ClearData;
    Buf[0] := OUT_SPEAKER_DATA;
    Buf[1] := 20 shl 3;
    Move(PCMData1, Buf[2], 20);
    WriteData;
  end else begin
    ClearData;
    Buf[0] := OUT_SPEAKER_DATA;
    Buf[1] := 20 shl 3;
    Move(PCMData2, Buf[2], 20);
    WriteData;
  end;

  Inc(SpeakerCount);
  if SpeakerCount > 10 then begin
    SpeakerTimer.Enabled := False;
    SpeakerCount := 0;

    Sleep(1000);

    // turn off speaker to conserve batteries
    ClearData;
    Buf[0] := OUT_SPEAKER_ENABLE;
    Buf[1] := $00;
    WriteData;
  end;
end;


procedure TdmWiimote.WriteData;
var
  sizeWritten, reportLength : Cardinal;
begin
  if Assigned(WiiMote[WiiSel]) then begin
    WiiMote[WiiSel].OpenFile;
    reportLength := WiiMote[WiiSel].Caps.OutputReportByteLength;
    WiiMote[WiiSel].WriteFile(Buf, reportLength, sizeWritten);
    WiiMote[WiiSel].CloseFile;
  end;
end;


procedure TdmWiimote.WriteData(wiinumber : Integer);
var
  sizeWritten, reportLength : Cardinal;
begin
  if Assigned(WiiMote[wiinumber]) then begin
    WiiMote[wiinumber].OpenFile;
    reportLength := WiiMote[wiinumber].Caps.OutputReportByteLength;
    WiiMote[wiinumber].WriteFile(Buf, reportLength, sizeWritten);
    WiiMote[wiinumber].CloseFile;
  end;
end;


procedure TdmWiimote.ClearData;
begin
  FillChar(Buf, Sizeof(Buf), 0);
end;


procedure TdmWiimote.WriteRegistry(address : Integer; data : array of Byte; size : Integer);
begin
  ClearData;
  Buf[0] := OUT_WRITEMEMORY;
  Buf[1] := (address and $FF000000) shr 24;
  Buf[2] := (address and $00FF0000) shr 16;
  Buf[3] := (address and $0000FF00) shr 8;
  Buf[4] := (address and $000000FF);
  Buf[5] := size;
  Move(data, Buf[6], size);
  WriteData;
end;


procedure TdmWiimote.StatusTimerTimer(Sender: TObject);
begin
  if not GotStatus then begin
    if FConnected and Assigned(FOnDisconnect) then
        FOnDisconnect(Self);
    FConnected := False;
  end;

  GotStatus := False;
  GetStatus;
end;


procedure TdmWiimote.HIDCtrlRemoval(HidDev: TJvHidDevice);
var
  i : Integer;
begin
  StatusTimer.Enabled := False;
  for i := 0 to WiiCount - 1 do begin
    if Assigned(FOnLostSource) then
      FOnLostSource(camWii, i);
    HIDCtrl.CheckIn(WiiMote[i]);
    WiiMote[i] := nil;
  end;
  WiiCount := 0;
end;


procedure TdmWiimote.UpdateVidRotation;
var
  width, height : Integer;
begin
  // clockwise 90 degree rotation for portrait orientation
  if FOrient[orRotate] then begin
    width := Trunc(vidwind_width * 0.75);
    height := vidwind_width;
  end else begin
    width := vidwind_width;
    height := Trunc(vidwind_width * 0.75);
  end;
  aVideoWindow.Width := width;
  aVideoWindow.Height := height;  
end;


procedure TdmWiimote.SetThreshold(threshold : Integer);
begin
  FSensitivity := threshold;
  if FConnected then
    WriteRegistry(REGISTER_IR_SENSITIVITY_1 + 8, [Byte(Trunc((FSensitivity)))], 1);
end;


procedure TdmWiimote.SetOrient(aOrient : TOrient; Value : Boolean);
begin
  FOrient[aOrient] := Value;

  if aOrient = orRotate then
    UpdateVidRotation;
end;


function TdmWiimote.GetOrient(aOrient : TOrient) : Boolean;
begin
  Result := FOrient[aOrient];
end;


procedure TdmWiimote.SetIRReg(reg1 : array of Byte; reg2: array of Byte);
begin
  WriteRegistry(REGISTER_IR_SENSITIVITY_1, reg1, Sizeof(reg1));
  WriteRegistry(REGISTER_IR_SENSITIVITY_2, reg2, Sizeof(reg2));
end;


procedure TdmWiimote.SetScaleVid(Value : Boolean);
begin
  FScaleVid := Value;
  if ScaleVid then
    vidwind_width := WII_SCALED_WIDTH
  else
    vidwind_width := WII_SEN_WIDTH;

end;


function TdmWiimote.GetCamPos(aDOF : TDOF) : Integer;
begin
  Result := FCamPos[aDOF];
end;






end.
