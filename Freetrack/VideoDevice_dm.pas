unit VideoDevice_dm;

interface

uses
  Windows, SysUtils, Forms, Classes, Dialogs, Seuillage_inc, DSPack, DirectShow9,
  Parameters, DSUtil, StdCtrls, Registry, ShellApi, DKLang;

const
  DEMO_ZSCALAR = 395;
  DEMO_WIDTH = 320;
  DEMO_HEIGHT = 240;

type

  TdmVideoDevice = class(TDataModule)
    Graph: TFilterGraph;
    GraphDemo: TFilterGraph;
    Camera: TFilter;
    Seuillage: TFilter;
    procedure GraphDSEvent(sender: TComponent; Event, Param1,
      Param2: Integer);
  private
    SysDev : TSysDevEnum;
    InPinUnknow, OutPinUnknow : IPin;
    fOwner : TForm;
    aVideoWindow : TVideoWindow;
    aCombCam : TComboBox;
    FOnLedDetected : TOnLedDetected;
    FCompressor : TGUID;
    FFps : Integer;
    FCamWidth, FCamHeight : Integer;
    FFreetrackFilter : TFreetrackFilter;
    FFilterName : String;
    FMinPointSize, FMaxPointSize : Byte;
    FThreshold : Byte;
    FOnDemoFinished : TNotifyEvent;
    FCamSource : TCamSource;
    FAvailable : Boolean;

    function LoadDSFilter : Boolean;
    function PlayVid : Boolean;
    function PlayDemo : Boolean;
    function CheckValidSubType(subType : TGUID) : Boolean;
    function GetSeuilRouge: byte;
    function GetCompressor : String;
    procedure SetSeuilRouge(const Value: byte);
    procedure SetCompressor(const Value : String);
    procedure SetFilter(const Value : String);
    procedure SetMinPointSize(const Value : byte);
    procedure SetMaxPointSize(const Value : byte);
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function SelectVideo : Boolean;
    procedure SelectDemo;
    function Play : Boolean;
    procedure PlayPaused;
    procedure Stop;
    procedure Pause;
    function ShowStreamProp : Boolean;
    procedure ChangeVidOrient;
    procedure ShowForceCamForm;
    property SeuilRouge : byte read GetSeuilRouge write SetSeuilRouge;
    property OnLedDetected : TOnLedDetected read FOnLedDetected write FOnLedDetected;
    property OnDemoFinished : TNotifyEvent read FOnDemoFinished write FOnDemoFinished;
    property FilterName : String read FFilterName write SetFilter;
    property MinPointSize : Byte read FMinPointSize write SetMinPointSize;
    property MaxPointSize : Byte read FMaxPointSize write SetMaxPointSize;
    property Fps : Integer read FFps write FFps;
    property Compressor : String read GetCompressor write SetCompressor;
    property CamWidth : Integer read FCamWidth write FCamWidth;
    property CamHeight : Integer read FCamHeight write FCamHeight;
    property Available : Boolean read FAvailable write FAvailable;
    procedure SetNoise(noise1, noise2 : byte);
  end;

var
  dmVideoDevice: TdmVideoDevice;

implementation

uses
  cpuid, ForceCamProp_fm;

const
  FreetrackFilterTxt : array[TFreetrackFilter] of String = ('auto', 'MMX', 'SSE2');
  DEMO_FILENAME = 'demo.avi';

resourcestring
  KEY_FREETRACKFILTER = 'CLSID\{0A99F2CA-79C9-4312-B78E-ED6CB3829275}\InprocServer32';

{$R *.dfm}

constructor TdmVideoDevice.Create(AOwner : TComponent);
var
  i : Integer;
begin
  Inherited;
  fOwner := AOwner as TForm;
  aVideoWindow := fOwner.FindComponent('VideoWindow1') as TVideoWindow;
  aCombCam := fOwner.FindComponent('combCam') as TComboBox;

  FAvailable := LoadDSFilter;
  if FAvailable then begin
    // add camera sources (demo video must be first)
    // position in list used to identify video device
    aCombCam.AddItem((fOwner.FindComponent('laDemoVideo') as TLabel).Caption, Self);
    SysDev := TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
    if SysDev.CountFilters > 0 then
      for i := 0 to SysDev.CountFilters - 1 do
         aCombCam.AddItem(SysDev.Filters[i].FriendlyName, Self);
  end;

  ForceCamProp := TForceCamProp.Create(Self);
end;


function TdmVideoDevice.LoadDSFilter;
var
  aKey : TRegistry;
  SeuilRouge  : ISeuil;
  aLocation, filterFile : String;
begin
  Result := True;

  aKey := TRegistry.Create(KEY_READ or KEY_WRITE);
  try
    aKey.RootKey := HKEY_CLASSES_ROOT;
    if aKey.OpenKey(KEY_FREETRACKFILTER, True) then
      aLocation := aKey.ReadString('') // read default
    else
      aLocation := '';
    aKey.CloseKey;
  finally
    aKey.Free;
  end;

  SetFilter(MyConfig.FilterName);
  case FFreeTrackFilter of
    filterSSE2: if not SupporteSEE2 then  MessageDlg(DKLangConstW('S_ERROR_SSE2_UNAVAILABLE'), mtError, [mbOk], 0);
    filterMMX: if SupporteSEE2 then  MessageDlg(DKLangConstW('S_ERROR_SSE2_AVAILABLE'), mtError, [mbOk], 0);
    filterAuto: if SupporteSEE2 then
        FFreeTrackFilter := filterSSE2
      else
        FFreeTrackFilter := filterMMX;
  end;
  MyConfig.FilterName := FreetrackFilterTxt[FFreeTrackFilter];

  filterFile := IncludeTrailingPathDelimiter( ExtractFilePath( Application.ExeName )) + 'FreeTrackFilter' + FreetrackFilterTxt[FFreetrackFilter] + '.ax';
  FFilterName := FreetrackFilterTxt[FFreeTrackFilter];

  // use local filter if registered filter is located elsewhere
  if (FFreeTrackFilter = filterAuto) or (aLocation = '') or (aLocation <> filterFile) then
    if FileExists(filterFile) then begin
      ShellExecute(0, 'open', 'Regsvr32', PChar('/s "' + filterFile ), '', SW_HIDE);
      LoadLibrary(PChar(filterFile));
      Sleep(100); // give it a chance
    end;

  // only activate graph after correct filter loaded
  Graph.Active := True;
  GraphDemo.Active := True;
  Seuillage.QueryInterface(IID_ISeuil, SeuilRouge);
  if not Assigned(SeuilRouge) then begin
    Graph.Active := False;
    MessageBeep(MB_ICONEXCLAMATION);
    MessageDlg(Format(DKLangConstW('S_ERROR_AX_REG_FAILED'), [filterFile]), mtError, [mbOk], 0);
    FOnLedDetected := nil;
    Result := False;
  end;
end;


procedure TdmVideoDevice.SelectDemo;
var
  SeuilRouge  : ISeuil;
begin
  FCamSource := camDemo;
  Graph.Active := False;
  Graph.ClearGraph;

  aVideoWindow.FilterGraph := GraphDemo;
  Seuillage.FilterGraph := GraphDemo;

  Seuillage.QueryInterface(IID_ISeuil, SeuilRouge);
  SeuilRouge.SetCallback(FOnLedDetected);
  SeuilRouge.SetActive(True);
end;


function TdmVideoDevice.SelectVideo : Boolean;
var
  VideoPin : IPin;
  SeuilRouge  : ISeuil;
  aStreamConfig : IAMStreamConfig;
  aAM_MEDIA_TYPE : PAMMediaType;
begin
  FCamSource := camVid;
  Graph.Active := False;
  Graph.ClearGraph;
  Camera.BaseFilter.Moniker := SysDev.GetMoniker(aCombCam.ItemIndex - 1);
  ForceCamProp.SelectedCam := aCombCam.Items[aCombCam.ItemIndex];
  Graph.Active := True;

  //Find Camera capture pin
  if CheckDSError((Graph as ICaptureGraphBuilder2).FindPin(Camera, PINDIR_OUTPUT, @PIN_CATEGORY_CAPTURE, @MEDIATYPE_Video, FAlse, 0, VideoPin)) = S_OK then begin
    if (VideoPin.QueryInterface(IAMStreamConfig, aStreamConfig) = S_OK) then begin
      if aStreamConfig.GetFormat(aAM_MEDIA_TYPE) = S_OK then begin
        TVideoInfoHeader(aAM_MEDIA_TYPE.pbFormat^).bmiHeader.biWidth     := FCamWidth;
        TVideoInfoHeader(aAM_MEDIA_TYPE.pbFormat^).bmiHeader.biHeight    := FCamHeight;
        TVideoInfoHeader(aAM_MEDIA_TYPE.pbFormat^).bmiHeader.biSizeImage := FCamWidth * FCamHeight * 3;
        TVideoInfoHeader(aAM_MEDIA_TYPE.pbFormat^).AvgTimePerFrame       := trunc(10000000/FFps);

        aAM_MEDIA_TYPE.subtype := FCompressor;

        if aStreamConfig.SetFormat(TAMMediaType(aAM_MEDIA_TYPE^))<> S_OK then
          // Memo1.Lines.Add('Error settting resolution');
      end;
    end;
    aVideoWindow.FilterGraph := Graph;
    Seuillage.FilterGraph := Graph;

    Seuillage.QueryInterface(IID_ISeuil, SeuilRouge);
    SeuilRouge.SetCallback(FOnLedDetected);
    SeuilRouge.SetActive(True);
    Result := True;
  end else begin
    Graph.Stop;
    Graph.ClearGraph;
    Graph.Active := False;
    Result := False;
  end;
end;



function TdmVideoDevice.Play;
begin
  if FCamSource = camVid then
    Result := PlayVid
  else
    Result := PlayDemo;
end;


function TdmVideoDevice.PlayDemo;
var
  vidWindow : IVideoWindow;
  SeuilRouge  : ISeuil;
begin
  GraphDemo.ClearGraph;
  aVideoWindow.FilterGraph := GraphDemo;

  Seuillage.FilterGraph := Graph;
  Seuillage.FilterGraph := GraphDemo;

  Seuillage.QueryInterface( IID_ISeuil, SeuilRouge );
  SeuilRouge.SetCallback(FOnLedDetected);
  SeuilRouge.SetMinPointSize(FMinPointSize);
  SeuilRouge.SetMaxPointSize(FMaxPointSize);
  SeuilRouge.SetActive(True);

  if FileExists(DEMO_FILENAME) then begin
    CheckDSError(GraphDemo.RenderFile(DEMO_FILENAME));
    GraphDemo.Play;

    // prevent focus stealing on state change
    if GraphDemo.QueryInterface(IID_IVideoWindow, vidWindow) = S_OK then
      vidWindow.put_AutoShow(False);

    Result := True;
  end else begin
    MessageDlg(DKLangConstW('S_ERROR_VM_MISSINGDEMO'), mtError, [mbOK], 0);
    Result := False;
    Abort;
  end;

  SetSeuilRouge(FThreshold);
  SeuilRouge := SeuilRouge;
end;


function TdmVideoDevice.PlayVid;
var
  vidWindow : IVideoWindow;
  SeuilRouge  : ISeuil;
  aOverlayNotify : IOverlayNotify;
begin

  // ClearGraph needed in order to prevent loss of stream during displaychange events
  Graph.ClearGraph;
  aVideoWindow.FilterGraph := Graph;

  Seuillage.QueryInterface(IID_ISeuil, SeuilRouge);
  SeuilRouge.SetCallback(FOnLedDetected);
  SeuilRouge.SetMinPointSize(FMinPointSize);
  SeuilRouge.SetMaxPointSize(FMaxPointSize);
  SeuilRouge.SetActive(True);

  try
    CheckDSError((Graph as ICaptureGraphBuilder2).RenderStream(@PIN_CATEGORY_CAPTURE, @MEDIATYPE_Video, Camera as IBaseFilter, Seuillage as IBaseFilter, aVideoWindow as IBaseFilter));

    if Graph.QueryInterface(IID_IVideoWindow, vidWindow) = S_OK then begin
      vidWindow.put_Owner(aVideoWindow.Handle); // place in videowindow frame
      vidWindow.put_WindowStyle(WS_DLGFRAME); // no frame
      vidWindow.put_Visible(True);
      vidWindow.put_AutoShow(False);  // prevent focus stealing on state change
    end;

    {if Graph.QueryInterface(IID_IOverlayNotify, aOverlayNotify) = S_OK then begin
      aOverlayNotify.
    end;  }

    Graph.Play;

    Result := True;
  except
    Result := False;
    Abort;
  end;

  SetSeuilRouge(FThreshold);
  SeuilRouge := SeuilRouge;
end;

procedure TdmVideoDevice.PlayPaused;
begin
  if FCamSource = camVid then
    Graph.Play
  else
    GraphDemo.Play;
end;


procedure TdmVideoDevice.Stop;
begin
  case FCamSource of
    camVid: begin
      Graph.Stop;
      Graph.ClearGraph;
    end;
    camDemo: begin
      GraphDemo.Stop;
      GraphDemo.ClearGraph;
    end;
  end;

  aVideoWindow.Repaint;
  aVideoWindow.FilterGraph := nil;
end;


procedure TdmVideoDevice.Pause;
begin
  case FCamSource of
    camVid : Graph.Pause;
    camDemo : GraphDemo.Pause;
  end;
end;


function TdmVideoDevice.CheckValidSubType(subType : TGUID) : Boolean;
begin
  Result := False;
  if  IsEqualGUID(subType, MEDIASUBTYPE_YVU9) or
      IsEqualGUID(subType, MEDIASUBTYPE_IF09) or
      IsEqualGUID(subType, MEDIASUBTYPE_YV12) or
      IsEqualGUID(subType, MEDIASUBTYPE_IYUV) or
      IsEqualGUID(subType, MEDIASUBTYPE_I420) or
      IsEqualGUID(subType, MEDIASUBTYPE_NV12) or
      IsEqualGUID(subType, MEDIASUBTYPE_IMC1) or
      IsEqualGUID(subType, MEDIASUBTYPE_IMC2) or
      IsEqualGUID(subType, MEDIASUBTYPE_IMC3) or
      IsEqualGUID(subType, MEDIASUBTYPE_IMC4) or
      IsEqualGUID(subType, MEDIASUBTYPE_RGB8) or
      IsEqualGUID(subType, MEDIASUBTYPE_Y800) or
      IsEqualGUID(subType, MEDIASUBTYPE_Y8) or
      IsEqualGUID(subType, MEDIASUBTYPE_GREY) or

      IsEqualGUID(subType, MEDIASUBTYPE_YUYV) or
      IsEqualGUID(subType, MEDIASUBTYPE_YUY2) or
      IsEqualGUID(subType, MEDIASUBTYPE_YVYU) or

      IsEqualGUID(subType, MEDIASUBTYPE_UYVY) or
      IsEqualGUID(subType, MEDIASUBTYPE_Y422) or

      IsEqualGUID(subType, MEDIASUBTYPE_RGB24) or

      IsEqualGUID(subType, MEDIASUBTYPE_ARGB32) or
      IsEqualGUID(subType, MEDIASUBTYPE_RGB32) then
    Result := True;
end;


function TdmVideoDevice.ShowStreamProp : Boolean;
var
  VideoPin : IPin;
  aStreamConfig : IAMStreamConfig;
  aAM_MEDIA_TYPE : PAMMediaType;
begin
  Result := False;
  (Graph as ICaptureGraphBuilder2).FindPin(Camera, PINDIR_OUTPUT, @PIN_CATEGORY_CAPTURE, @MEDIATYPE_Video, False, 0, VideoPin);
  ShowPinPropertyPage(fOwner.Handle, VideoPin);
  if (VideoPin.QueryInterface(IAMStreamConfig, aStreamConfig) = S_OK) then
    if aStreamConfig.GetFormat(aAM_MEDIA_TYPE) = S_OK then begin
      Fps := Round(10000000 / TVideoInfoHeader2(aAM_MEDIA_TYPE.pbFormat^).AvgTimePerFrame);
      FCompressor := aAM_MEDIA_TYPE.subtype;
      FCamWidth := TVideoInfoHeader(aAM_MEDIA_TYPE.pbFormat^).bmiHeader.biWidth;
      FCamHeight := TVideoInfoHeader(aAM_MEDIA_TYPE.pbFormat^).bmiHeader.biHeight;
      Result := True;
      if not CheckValidSubType(FCompressor) then begin
        MessageBeep(MB_ICONEXCLAMATION);
        MessageDlg(Format(DKLangConstW('S_WARNING_UNSUPPORTED_MEDIATYPE'), [GuidToString(FCompressor)]), mtWarning, [mbOK], 0);
      end;
    end;
end;



destructor TdmVideoDevice.Destroy;
begin
  Graph.Stop;
  Graph.ClearGraph;
  Graph.Active := False;
  GraphDemo.Stop;
  GraphDemo.ClearGraph;
  GraphDemo.Active := False;
  Inherited;
end;


procedure TdmVideoDevice.SetSeuilRouge(const Value: byte);
var
  SeuilRouge : ISeuil;
begin
  FThreshold := Value;
  if Graph.Active or GraphDemo.Active then
    if ((Seuillage as IBaseFilter).QueryInterface(IID_ISeuil, SeuilRouge) = S_OK) then
      SeuilRouge.SetSeuil(Value)
    else
      MessageDlg(DKLangConstW('S_ERROR_VM_THRESHOLD'), mtError, [mbOK], 0);
end;



function TdmVideoDevice.GetSeuilRouge: byte;
var
  i : byte;
  SeuilRouge : ISeuil;
begin
  Result := 0;
  if Graph.Active or GraphDemo.Active then
    if ((Seuillage as IBaseFilter).QueryInterface(IID_ISeuil, SeuilRouge) = S_OK) then begin
      SeuilRouge.GetSeuil(@i);
      Result := i;
    end else
      MessageDlg(DKLangConstW('S_ERROR_VM_THRESHOLD'), mtError, [mbOK], 0);

end;


function TdmVideoDevice.GetCompressor : String;
begin
  Result := GUIDToString(FCompressor);
end;


procedure TdmVideoDevice.SetCompressor(const Value : String);
begin
  if Value = '' then
    FCompressor := MEDIASUBTYPE_YUYV
  else
    FCompressor := StringToGUID(Value);
end;


procedure TdmVideoDevice.SetFilter(const Value : String);
var
  aFreetrackFilter : TFreetrackFilter;
begin
  FFilterName := Value;
  for aFreetrackFilter := Low(TFreetrackFilter) to High(TFreetrackFilter) do
    if AnsiCompareText(FreeTrackFilterTxt[aFreetrackFilter], FFilterName) = 0 then
      FFreetrackFilter := TFreetrackFilter(aFreetrackFilter);
end;


procedure TdmVideoDevice.ChangeVidOrient;
var
  vmrMixer : IVMRMixerControl9;
  rect : TVMR9NORMALIZEDRECT;
begin
  // can mirror and flip video but not rotate
  {if Orient[orMirror] then begin
    rect.left := 1;
    rect.right := 0;
    rect.top := 0;
    rect.bottom := 1;
  end else if Orient[orFlip] then begin
    rect.left := 0;
    rect.right := 1;
    rect.top := 1;
    rect.bottom := 0;
  end else begin
    rect.left := 0;
    rect.right := 1;
    rect.top := 0;
    rect.bottom := 1;
  end;

  if VideoWindow1.QueryInterface(IID_IVMRMixerControl9, vmrMixer) = S_OK then
    vmrMixer.SetOutputRect(0, @rect);  }
end;


procedure TdmVideoDevice.GraphDSEvent(sender: TComponent; Event, Param1,
  Param2: Integer);
begin
  // EC_PAUSED occurs whenever graph is stopped, paused or played (but not play after pause)
  // why did I do this??
  //if (Event = EC_PAUSED) and (FCamSource = camVid) then
    //ForceCamProp.ForceProperties;

  if (Event = EC_COMPLETE) and (FCamSource = camDemo) then begin
    Stop;
    PlayDemo;
    if Assigned(FOnDemoFinished) then
      FOnDemoFinished(Self);
  end;
end;


procedure TdmVideoDevice.ShowForceCamForm;
begin
  // ShowFilterPropertyPage
  ForceCamProp.ShowStreamProp;
end;


procedure TdmVideoDevice.SetMinPointSize(const Value : byte);
var
  SeuilRouge  : ISeuil;
begin
  FMinPointSize := Value;
  if Seuillage.QueryInterface(IID_ISeuil, SeuilRouge) = S_OK then
    SeuilRouge.SetMinPointSize(FMinPointSize);
end;


procedure TdmVideoDevice.SetMaxPointSize(const Value : byte);
var
  SeuilRouge  : ISeuil;
begin
  FMaxPointSize := Value;
  if Seuillage.QueryInterface(IID_ISeuil, SeuilRouge) = S_OK then
    SeuilRouge.SetMaxPointSize(FMaxPointSize);
end;


procedure TdmVideoDevice.SetNoise(noise1, noise2 : byte);
var
  SeuilRouge  : ISeuil;
begin
  if Seuillage.QueryInterface(IID_ISeuil, SeuilRouge) = S_OK then
    SeuilRouge.SetNoise(noise1, noise2);
end;





end.
