{$define debug}

{ Under GNU License
 check http://www.opensource.org/
 project by
 Nicolas Camil
 http://n.camil.chez.tiscali.fr
------------------------------

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public License for more details.}

unit Freetrack_fm;

interface

uses
  Windows, Messages, SysUtils, Variants, SyncObjs, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, IniFiles, Registry, ComCtrls, CommCtrl, ExtCtrls, Buttons, Math,
  TypInfo, DirectInput, CamManager_fm, Seuillage_inc, FreeTrackTray, Pose, Average,
  Response, HeadDisplay, UrlLink, Parameters, PngImageList, PngSpeedButton, pngimage,
  ImgList, DSPack, DirectShow9, jpeg, D3DX9, Direct3D9, DInputMap,
  DKLang;

const
  WM_UIDATA = WM_USER + 1;
  

type
  THostApp = class
  private
    FAppHandle : THandle;
  public
    constructor Create(handle : THandle);
    property Handle : THandle read FAppHandle write FAppHandle;
  end;

  TfmFreetrack = class(TForm)
    Panel1: TPanel;
    Panel8: TPanel;
    Panel7: TPanel;
    PageControl1: TPageControl;
    tsCam: TTabSheet;
    tsPan: TTabSheet;
    tsResponse: TTabSheet;
    Translation: TTabSheet;
    TabSheet1: TTabSheet;
    GroupBox3: TGroupBox;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    laGlobalSensitivityYaw: TLabel;
    laGlobalSensitivityPitch: TLabel;
    laGlobalSensitivityRoll: TLabel;
    laGlobalSensitivityX: TLabel;
    laGlobalSensitivityY: TLabel;
    laGlobalSensitivityZ: TLabel;
    laGlobalSmoothingYaw: TLabel;
    laGlobalSmoothingPitch: TLabel;
    laGlobalSmoothingRoll: TLabel;
    laGlobalSmoothingX: TLabel;
    laGlobalSmoothingY: TLabel;
    laGlobalSmoothingZ: TLabel;
    laGlobalSmoothingZooming: TLabel;
    Label61: TLabel;
    cbGlobalInvertX: TCheckBox;
    cbGlobalInvertY: TCheckBox;
    cbGlobalInvertZ: TCheckBox;
    cbGlobalInvertYaw: TCheckBox;
    cbGlobalInvertPitch: TCheckBox;
    cbGlobalInvertRoll: TCheckBox;
    tbGlobalSensitivityRoll: TTrackBar;
    tbGlobalSensitivityYaw: TTrackBar;
    tbGlobalSensitivityY: TTrackBar;
    tbGlobalSensitivityZ: TTrackBar;
    tbGlobalSmoothingYaw: TTrackBar;
    tbGlobalSmoothingPitch: TTrackBar;
    tbGlobalSmoothingRoll: TTrackBar;
    tbGlobalSmoothingX: TTrackBar;
    tbGlobalSmoothingY: TTrackBar;
    tbGlobalSmoothingZ: TTrackBar;
    tbGlobalSensitivityX: TTrackBar;
    tbGlobalSensitivityPitch: TTrackBar;
    tbGlobalSmoothingZooming: TTrackBar;
    TabSheet3: TTabSheet;
    TabSheet2: TTabSheet;
    tsDebug: TTabSheet;
    Memo1: TMemo;
    Panel2: TPanel;
    cbDebug: TCheckBox;
    Panel3: TPanel;
    Label2: TLabel;
    laImgA1: TLabel;
    laImgA2: TLabel;
    laImgA3: TLabel;
    laImgA4: TLabel;
    Rotation: TLabel;
    laYaw: TLabel;
    laPitch: TLabel;
    laRoll: TLabel;
    Label3: TLabel;
    laPanX: TLabel;
    laPanY: TLabel;
    laPanZ: TLabel;
    Label16: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label38: TLabel;
    laSmoothingMultiplier: TLabel;
    paHead: TPanel;
    Panel4: TPanel;
    cbZooming: TCheckBox;
    combView: TComboBox;
    btCenter: TPngSpeedButton;
    Image2: TImage;
    Image4: TImage;
    panPoints: TPanel;
    imPoint4: TImage;
    imPoint3: TImage;
    imPoint2: TImage;
    imPoint1: TImage;
    imPoint5: TImage;
    pcTrackMethod: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    GroupBox5: TGroupBox;
    Label20: TLabel;
    gb3PClipDimensions: TGroupBox;
    im3PDimensions: TImage;
    Label62: TLabel;
    Label63: TLabel;
    ed3PClipz1: TEdit;
    ed3PClipy1: TEdit;
    ed3PClipz2: TEdit;
    ed3PClipy2: TEdit;
    gb4PDimensions: TGroupBox;
    im4PDimensions: TImage;
    Label34: TLabel;
    Label35: TLabel;
    ed4Px1: TEdit;
    ed4Py1: TEdit;
    ed4Py2: TEdit;
    ed4Pz1: TEdit;
    ed4Pz2: TEdit;
    Label28: TLabel;
    Label30: TLabel;
    GroupBox7: TGroupBox;
    Label32: TLabel;
    Label33: TLabel;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Label36: TLabel;
    Image10: TImage;
    Label37: TLabel;
    Image11: TImage;
    Label31: TLabel;
    Image3: TImage;
    GroupBox8: TGroupBox;
    Label52: TLabel;
    Image12: TImage;
    Label54: TLabel;
    Image13: TImage;
    WhiteSky1: TMenuItem;
    Sphere1: TMenuItem;
    Axes1: TMenuItem;
    PopHead: TPopupMenu;
    Labels1: TMenuItem;
    Trackingaxes1: TMenuItem;
    Limitbox1: TMenuItem;
    Rotationlimits1: TMenuItem;
    Rotationlimits2: TMenuItem;
    imlistStartStop: TPngImageList;
    imListTrack: TPngImageList;
    Label56: TLabel;
    Image22: TImage;
    imTrack: TImage;
    imlistPointState: TPngImageList;
    imTrayIcon1: TImage;
    imTrayIcon2: TImage;
    imTrayIcon3: TImage;
    butStart: TPngSpeedButton;
    Label60: TLabel;
    Image26: TImage;
    Label64: TLabel;
    TabSheet7: TTabSheet;
    Label65: TLabel;
    Label67: TLabel;
    ed3PCapz: TEdit;
    ed3PCapy: TEdit;
    ed3PCapx: TEdit;
    GroupBox10: TGroupBox;
    Label68: TLabel;
    Image23: TImage;
    Label69: TLabel;
    Image27: TImage;
    Label72: TLabel;
    Image30: TImage;
    Image16: TImage;
    gb3PCapDimensions: TGroupBox;
    Label70: TLabel;
    Image28: TImage;
    timerKey: TTimer;
    PageControl2: TPageControl;
    TabSheet8: TTabSheet;
    RollCfg: TResponseCfg;
    PitchCfg: TResponseCfg;
    YawCfg: TResponseCfg;
    TabSheet9: TTabSheet;
    PanXCfg: TResponseCfg;
    PanYCfg: TResponseCfg;
    PanZCfg: TResponseCfg;
    GroupBox6: TGroupBox;
    cbLaunchatStartup: TCheckBox;
    cbConfirmClose: TCheckBox;
    cbStartMinimized: TCheckBox;
    ScrollBox1: TScrollBox;
    GroupBox4: TGroupBox;
    Label51: TLabel;
    Label27: TLabel;
    n: TImage;
    Label73: TLabel;
    cbCenterKeyBeep: TCheckBox;
    cbCenterKeyToggle: TCheckBox;
    cbPauseKeyBeep: TCheckBox;
    cbPauseKeyToggle: TCheckBox;
    GroupBox11: TGroupBox;
    GroupBox12: TGroupBox;
    Yaw: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    cbYawKeyBeep: TCheckBox;
    cbYawKeyToggle: TCheckBox;
    cbPitchKeyBeep: TCheckBox;
    cbPitchKeyToggle: TCheckBox;
    cbRollKeyBeep: TCheckBox;
    cbRollKeyToggle: TCheckBox;
    cbPanXKeyBeep: TCheckBox;
    cbPanXKeyToggle: TCheckBox;
    cbPanYKeyBeep: TCheckBox;
    cbPanYKeyToggle: TCheckBox;
    cbPanZKeyBeep: TCheckBox;
    cbPanZKeyToggle: TCheckBox;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    cbMouseKeyToggle: TCheckBox;
    cbMouseKeyBeep: TCheckBox;
    cbJoyKeyToggle: TCheckBox;
    cbJoyKeyBeep: TCheckBox;
    cbTIRKeyToggle: TCheckBox;
    cbTIRKeyBeep: TCheckBox;
    cbSimConnectKeyToggle: TCheckBox;
    cbSimConnectKeyBeep: TCheckBox;
    PopCurve: TPopupMenu;
    Linear1: TMenuItem;
    Mediumdeadzone1: TMenuItem;
    Largedeadzone1: TMenuItem;
    tsOutput: TTabSheet;
    cbAutoMinimize: TCheckBox;
    Smallsmooth1: TMenuItem;
    Mediumsmooth1: TMenuItem;
    Largesmooth1: TMenuItem;
    Smooth1: TMenuItem;
    Deadzone1: TMenuItem;
    Smalldeadzone1: TMenuItem;
    Copyto1: TMenuItem;
    Yaw1: TMenuItem;
    Pitch1: TMenuItem;
    Roll1: TMenuItem;
    X1: TMenuItem;
    Y1: TMenuItem;
    Z1: TMenuItem;
    All1: TMenuItem;
    Panel11: TPanel;
    laSmoothStable: TLabel;
    laCenter: TLabel;
    Splitter1: TSplitter;
    Splitter3: TSplitter;
    GroupBox14: TGroupBox;
    Label14: TLabel;
    Label74: TLabel;
    tbSmoothStable: TTrackBar;
    cbSmoothStableKeyBeep: TCheckBox;
    cbSmoothStableKeyToggle: TCheckBox;
    Image1: TImage;
    Label18: TLabel;
    Panel13: TPanel;
    laVersion: TLabel;
    Label4: TLabel;
    UrlLink1: TUrlLink;
    Image15: TImage;
    UrlLink3: TUrlLink;
    Label88: TLabel;
    Label93: TLabel;
    Panel14: TPanel;
    cbAutoLoadProfile: TCheckBox;
    laYawDZ: TLabel;
    laPitchDZ: TLabel;
    laRollDZ: TLabel;
    laPanXDZ: TLabel;
    laPanYDZ: TLabel;
    laPanZDZ: TLabel;
    Label99: TLabel;
    Label100: TLabel;
    cbSmoothRawKeyBeep: TCheckBox;
    cbSmoothRawKeyToggle: TCheckBox;
    tbSmoothRaw: TTrackBar;
    laSmoothRaw: TLabel;
    Label112: TLabel;
    cbKeyOutputKeyToggle: TCheckBox;
    cbKeyOutputKeyBeep: TCheckBox;
    laKeyOutput: TLabel;
    Label113: TLabel;
    cbAutoSaveProfile: TCheckBox;
    panButtons: TPanel;
    Bevel3: TBevel;
    Bevel2: TBevel;
    sbPage1: TPngSpeedButton;
    sbPage2: TPngSpeedButton;
    sbPage4: TPngSpeedButton;
    sbPage5: TPngSpeedButton;
    sbPage6: TPngSpeedButton;
    sbPage7: TPngSpeedButton;
    sbPage8: TPngSpeedButton;
    sbPage3: TPngSpeedButton;
    butkeyPause: TSpeedButton;
    butkeyCenter: TSpeedButton;
    butkeySmoothStable: TSpeedButton;
    butkeySmoothRaw: TSpeedButton;
    butkeyYaw: TSpeedButton;
    butkeyPitch: TSpeedButton;
    butkeyRoll: TSpeedButton;
    butkeyPanX: TSpeedButton;
    butkeyPanY: TSpeedButton;
    butkeyPanZ: TSpeedButton;
    butkeyTIR: TSpeedButton;
    butkeyMouse: TSpeedButton;
    butkeyJoy: TSpeedButton;
    butkeyKeyOutput: TSpeedButton;
    butkeySimConnect: TSpeedButton;
    Panel17: TPanel;
    Button2: TButton;
    DKLanguageController1: TDKLanguageController;
    Label104: TLabel;
    Label124: TLabel;
    Label125: TLabel;
    Label126: TLabel;
    Label127: TLabel;
    GroupBox15: TGroupBox;
    Label128: TLabel;
    Label129: TLabel;
    Label130: TLabel;
    butkeyProfileA: TSpeedButton;
    butkeyProfileB: TSpeedButton;
    butkeyProfileC: TSpeedButton;
    cbProfileBKeyToggle: TCheckBox;
    cbProfileBKeyBeep: TCheckBox;
    cbProfileCKeyToggle: TCheckBox;
    cbProfileCKeyBeep: TCheckBox;
    cbProfileAKeyToggle: TCheckBox;
    cbProfileAKeyBeep: TCheckBox;
    combProfileA: TComboBox;
    combProfileB: TComboBox;
    combProfileC: TComboBox;
    Panel5: TPanel;
    imTitle: TImage;
    Panel18: TPanel;
    combLanguage: TComboBox;
    Label59: TLabel;
    laImgB1: TLabel;
    laImgB2: TLabel;
    laImgB3: TLabel;
    laImgB4: TLabel;
    Label109: TLabel;
    Label114: TLabel;
    Label115: TLabel;
    Label116: TLabel;
    Label117: TLabel;
    Label118: TLabel;
    Label119: TLabel;
    Label120: TLabel;
    GroupBox9: TGroupBox;
    Label121: TLabel;
    Label122: TLabel;
    butkeyCustomCenterSet: TSpeedButton;
    butkeyCustomCenterReset: TSpeedButton;
    cbCustomCenterSetKeyBeep: TCheckBox;
    cbCustomCenterSetKeyToggle: TCheckBox;
    cbCustomCenterResetKeyBeep: TCheckBox;
    cbCustomCenterResetKeyToggle: TCheckBox;
    butkeyFreetrack: TSpeedButton;
    cbFreetrackKeyToggle: TCheckBox;
    cbFreetrackKeyBeep: TCheckBox;
    Label92: TLabel;
    paCam: TPanel;
    PageControl3: TPageControl;
    TabSheet11: TTabSheet;
    gpProfiles: TGroupBox;
    Splitter: TSplitter;
    TabSheet12: TTabSheet;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    laSmoothing: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    laSensitivityYaw: TLabel;
    laSensitivityPitch: TLabel;
    laSensitivityRoll: TLabel;
    laSensitivityX: TLabel;
    laSensitivityY: TLabel;
    laSensitivityZ: TLabel;
    laSmoothingYaw: TLabel;
    laSmoothingPitch: TLabel;
    laSmoothingRoll: TLabel;
    laSmoothingX: TLabel;
    laSmoothingY: TLabel;
    laSmoothingZ: TLabel;
    cbInvertX: TCheckBox;
    cbInvertY: TCheckBox;
    cbInvertZ: TCheckBox;
    cbInvertYaw: TCheckBox;
    cbInvertPitch: TCheckBox;
    cbInvertRoll: TCheckBox;
    tbSensitivityRoll: TTrackBar;
    tbSensitivityYaw: TTrackBar;
    tbSensitivityY: TTrackBar;
    tbSensitivityZ: TTrackBar;
    tbSmoothingYaw: TTrackBar;
    tbSmoothingPitch: TTrackBar;
    tbSmoothingRoll: TTrackBar;
    tbSmoothingX: TTrackBar;
    tbSmoothingY: TTrackBar;
    tbSmoothingZ: TTrackBar;
    tbSensitivityX: TTrackBar;
    tbSensitivityPitch: TTrackBar;
    GroupBox1: TGroupBox;
    laSmoothingZooming: TLabel;
    Label15: TLabel;
    laAverage: TLabel;
    Label66: TLabel;
    Label75: TLabel;
    laDynamicSmoothing: TLabel;
    tbSmoothingZooming: TTrackBar;
    tbAverage: TTrackBar;
    tbDynamicSmoothing: TTrackBar;
    GroupBox16: TGroupBox;
    Label1: TLabel;
    cbRelativeTransYaw: TCheckBox;
    cbRelativeTransPitch: TCheckBox;
    cbRelativeTransRoll: TCheckBox;
    cbRelativeTransX: TCheckBox;
    cbRelativeTransY: TCheckBox;
    cbRelativeTransZ: TCheckBox;
    GroupBox17: TGroupBox;
    laAutoCenteringSpeed: TLabel;
    cbRollRelativeRot: TCheckBox;
    cbAutoCentering: TCheckBox;
    tbAutoCenteringSpeed: TTrackBar;
    cbPortal: TCheckBox;
    GroupBox18: TGroupBox;
    butDefaultConfig: TButton;
    Label17: TLabel;
    GroupBox13: TGroupBox;
    cbBackwardZ: TCheckBox;
    RenderFPS1: TMenuItem;
    PoseFPS1: TMenuItem;
    Label85: TLabel;
    combAxisMapYaw: TComboBox;
    combAxisMapPitch: TComboBox;
    combAxisMapRoll: TComboBox;
    combAxisMapPanX: TComboBox;
    combAxisMapPanY: TComboBox;
    combAxisMapPanZ: TComboBox;
    laCustomCenter: TLabel;
    but3pClipApply: TButton;
    but3pCapApply: TButton;
    but4pCapApply: TButton;
    Label6: TLabel;
    Label19: TLabel;
    Label57: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    Label89: TLabel;
    Panel9: TPanel;
    sbTrack1P: TPngSpeedButton;
    sbTrack3PClip: TPngSpeedButton;
    sbTrack3PCap: TPngSpeedButton;
    sbTrack4P: TPngSpeedButton;
    Label29: TLabel;
    Label91: TLabel;
    Label95: TLabel;
    Label96: TLabel;
    TimertbTicks: TTimer;
    paRotOffsetCalibration: TPanel;
    gbRotOffsetCalibration: TGroupBox;
    laRotOffsetX: TLabel;
    laRotOffsetY: TLabel;
    laRotOffsetZ: TLabel;
    Label50: TLabel;
    Label53: TLabel;
    Label90: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label55: TLabel;
    tbRotOffsetX: TTrackBar;
    tbRotOffsetY: TTrackBar;
    tbRotOffsetZ: TTrackBar;
    Button1: TButton;
    Label21: TLabel;
    Image14: TImage;
    Label102: TLabel;
    Label98: TLabel;
    Image17: TImage;
    Label101: TLabel;
    Image18: TImage;
    Label71: TLabel;
    Image29: TImage;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    Image19: TImage;
    Label97: TLabel;
    sbHelp: TPngSpeedButton;
    lah1h2: TLabel;
    Label58: TLabel;
    laSensitivityReal: TButton;
    laSensitivityDefault: TButton;
    cbMaintainPausedData: TCheckBox;
    Image32: TImage;
    Image20: TImage;
    Image36: TImage;
    Image38: TImage;
    Image21: TImage;
    Image40: TImage;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    N111: TMenuItem;
    sbHowTo: TPngSpeedButton;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sbTrackingMethodClick(Sender: TObject);
    procedure tbSensitivityChange(Sender: TObject);
    procedure tbSmoothingChange(Sender: TObject);
    procedure tbSmoothingZoomingChange(Sender: TObject);
    procedure cbInvertClick(Sender: TObject);
    procedure tbGlobalSensitivityChange(Sender: TObject);
    procedure tbGlobalSmoothingChange(Sender: TObject);
    procedure tbGlobalSmoothingZoomingChange(Sender: TObject);
    procedure cbGlobalInvertClick(Sender: TObject);
    procedure tbRotOffsetChange(Sender: TObject);
    procedure tbAverageChange(Sender: TObject);
    procedure but3pClipApplyClick(Sender: TObject);
    procedure but3pCapApplyClick(Sender: TObject);
    procedure but4pCapApplyClick(Sender: TObject);
    procedure butRefreshProfileListClick(Sender: TObject);
    procedure butRotOffsetDefaultClick(Sender: TObject);
    procedure combViewChange(Sender: TObject);
    procedure sbPageChange(Sender: TObject);
    procedure cbKeyBeepClick(Sender: TObject);
    procedure butStartClick(Sender: TObject);
    procedure popHeadAids(Sender: TObject);
    procedure editEnterKeyPress(Sender: TObject; var Key: Char);
    procedure tbSmoothStableChange(Sender: TObject);
    procedure cbKeyToggleClick(Sender: TObject);
    procedure ManageKeyPress(Sender: TObject);
    procedure cbAutoCenteringClick(Sender: TObject);
    procedure tbAutoCenteringSpeedChange(Sender: TObject);
    procedure cbOptionsClick(Sender: TObject);
    procedure tbSmoothRawChange(Sender: TObject);
    procedure tbDynamicSmoothingChange(Sender: TObject);
    procedure popCurveClick(Sender: TObject);
    procedure Update3DWindowSize(Sender: TObject);
    procedure butKeyPollClick(Sender: TObject);
    procedure ClearKeyControlsClick(Sender: TObject);
    procedure combLanguageChange(Sender: TObject);
    procedure cbRelativeMovement(Sender: TObject);
    procedure butNewProfileClick(Sender : TObject);
    procedure butDefaultConfigClick(Sender: TObject);
    procedure cbPortalClick(Sender: TObject);
    procedure btCenterMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btCenterMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbBackwardZClick(Sender: TObject);
    procedure combAxisMapChange(Sender: TObject);
    procedure ed3PClipChange(Sender: TObject);
    procedure ed3PCapChange(Sender: TObject);
    procedure ed4PChange(Sender: TObject);
    procedure TimertbTicksTimer(Sender: TObject);
    procedure sbHelpClick(Sender: TObject);
    procedure laSensitivityRealClick(Sender: TObject);
    procedure laSensitivityDefaultClick(Sender: TObject);
    procedure SetSensitivity(aDOF : TDOF; const Value : Single);
    procedure cbMaintainPausedDataClick(Sender: TObject);
    procedure DKLanguageController1LanguageChanged(Sender: TObject);
    procedure sbHowToClick(Sender: TObject);


  private

    ScreenPoints : TArrayOfPoint2D32f;
    ScreenAverages : array[0..3] of TAverage;

    rootDirectory : String;
    PreventProfileDirtyStatus : Boolean;
    ScreenNumberPoints, ScreenFPS, SmoothStableMultiplier, previousNumPoints, Centering, NoSmoothingDelay : Integer;
    CurTick, LastTick, FrameCount, JitterCount, AvgJitterCount, InactiveCount : Integer;
    ZoomMultiplier, SmoothRawMultiplier, DynamicSmoothing : Single;
    RealPose, GamePose, PreviousGamePose, SmoothingSize, RawPose : TPose;
    previousTrackMethod : TTrackingMethod;

    HostList : TList;

    PrevRefCount, CurRefCount, TimebetweenFrames, HPFrequency : int64;

    KeyControl : array[TKeyControl] of TKeyStruct;
    KeyDblTapDelayCount : Integer;
    KeyChanged : Boolean;

    h1h2 : Th1h2;

    OnTaskBarCreated : UINT;

    ArrayLaImgA : array[0..3] of TLabel;
    ArrayLaImgB : array[0..3] of TLabel;

    ArrayLabelPose, ArrayLabelPoseDZ, ArrayLaSensitivity,
    ArrayLaSmoothing, ArrayLaGlobalSensitivity, ArrayLaGlobalSmoothing,
    ArrayLaRotOffset : array[TDOF] of TLabel;

    ArrayTbSensitivity, ArrayTbSmoothing, ArrayTbGlobalSensitivity,
    ArrayTbGlobalSmoothing, ArraytbRotOffset : array[TDOF] of TTrackBar;

    ArrayCbInverts : array[TDOF] of TCheckBox;
    ArrayResponseCfg : array[TDOF] of TResponseCfg;
    ArrayCbGlobalInverts  : array[TDOF] of TCheckBox;

    ArraysbPage : array[0..8] of TPngSpeedButton;
    ArraysbTrack : array[0..3] of TPngSpeedButton;
    ArrayimPoint : array[0..4] of TImage;

    ArraybutKeyControl : array[TKeyControl] of TSpeedButton;
    ArraycbKeyControlBeep,  ArraycbKeyControlToggle : array[TKeyControl] of TCheckBox;
    ArraycomboKeyProfile: array[keyProfileA..keyProfileC] of TComboBox;
    ArraycombAxisMap : array[TDOF] of TComboBox;

    ArraycbRelativeTrans : array[TDOF] of TCheckBox;

    ArraycbOptions : array[TBinaryOptions] of TCheckbox;

    procedure GUILoadProfile;
    procedure GUILoadConfig;

    procedure GestProfileSelected(Sender: TObject; aINI: TIniFile);
    procedure GestSaveProfile(Sender: TObject; aINI: TIniFile);
    procedure GestDefaultRequired(Sender: TObject; aINI: TIniFile);
    procedure GestProfileRenamed(Sender: TObject; aINI: TIniFile);
    procedure GestOnRestore(Sender: TObject);
    procedure GestOnMinimize(Sender: TObject);
    procedure GestResponseChanged(Sender : TObject);
    procedure GestOnChangedSource(Sender : TObject);
    procedure RefreshFormTitle;
    procedure LoadProfiles;
    procedure UpdateUIData(var MSG : TMessage); message WM_UIDATA;
    //procedure DisplayINTERP(var MSG : TMessage); message WM_INTERP;
    procedure GestStateChanged(Sender : TObject; isRunning : Boolean);
    procedure ProfileDirty;
    function CheckInstance(filename : String) : Boolean;
    procedure UpdateKeyControls(Clear : Boolean);
    procedure ApplyCenter(Sender: TObject);
    procedure AlternatePlayPause(Sender: TObject);
  public
    procedure DefaultHandler(var Message); override; //To display GameID debug memo
    procedure WndProc(var Message : TMessage); override;
    procedure KeyPollFinished(Sender: TObject; NewData : Boolean);
    procedure GestOnLedDetected(ListPoint : TListPoint);
    procedure RenderIdle(Sender : TObject; var Done: Boolean);
  end;


var
  fmFreetrack: TfmFreeTrack;

implementation

uses ShellAPI, TrayIcon, ProfilesMngr_fm, ForceCamProp_fm, PoseDataOutput_fm;

{$R *.dfm}

const
  INTEGER_DIV = 0.0001;
  TRACKING_NUMBER_OF_POINTS : array[TTrackingMethod] of integer = (1,3,3,4);
  RESP_MAX = 50000;
  RESP_INTEGER_SCALER = 1000;
  S_FREETRACK = 'FreeTrack';
  SENSITIVITY_MAX = 20;




constructor THostApp.Create(handle : THandle);
begin
  Self.FAppHandle := handle;
end;


procedure TfmFreetrack.FormCreate(Sender: TObject);
  function GetVersion(AppName : TFileName): string;
  var
    VerInfoSize: DWORD;
    VerInfo: Pointer;
    VerValueSize: DWORD;
    VerValue: PVSFixedFileInfo;
    Dummy: DWORD;
  begin
    Result := '';
    VerInfoSize := GetFileVersionInfoSize(PChar(AppName), Dummy);
    if VerInfoSize = 0 then begin
       ShowMessage(AppName + #13#10 +SysErrorMessage(GetLastError));
       Exit;
    end;
    GetMem(VerInfo, VerInfoSize);
    GetFileVersionInfo(PChar(AppName), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
    with VerValue^ do
    begin
      Result := IntToStr(dwFileVersionMS shr 16);
      Result := Result + '.' + IntToStr(dwFileVersionMS and $FFFF);
      Result := Result + '.' + IntToStr(dwFileVersionLS shr 16);
      Result := Result + '.' + IntToStr(dwFileVersionLS and $FFFF);
    end;
    FreeMem(VerInfo, VerInfoSize);
  end;


var
  i : Integer;
  configIni : TIniFile;
  aFilter : TFileName;
  aKey : TKeyControl;
  AllowMultiInst, StartMinimized : Boolean;
  LangID : Integer;
  aDOF : TDOF;
begin
  Application.ShowMainForm := False;

  AllowMultiInst := False;
  for i := 1 to ParamCount do
    if (ParamStr(i) = '/multi') then
      AllowMultiInst := True;

  if not AllowMultiInst and CheckInstance(ExtractFileName(Application.ExeName)) then begin
    MessageBeep(MB_ICONEXCLAMATION);
    MessageDlg(DKLangConstW('S_ERROR_ALREADY_RUNNING'), mtError, [mbOK], 0);
    Application.Terminate;
    Abort;
  end;

  if FindWindow(nil, 'NaturalPoint') <> 0 then begin
    MessageBeep(MB_ICONEXCLAMATION);
    MessageDlg(DKLangConstW('S_ERROR_NP_SOFTWARE_RUNNING'), mtError, [mbOK], 0);
    Application.Terminate;
    Abort;
  end;

  rootDirectory := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  configIni := TIniFile.Create(rootDirectory + 'Freetrack.ini');

  try
    ArrayLaImgA[0] := laImgA1;
    ArrayLaImgA[1] := laImgA2;
    ArrayLaImgA[2] := laImgA3;
    ArrayLaImgA[3] := laImgA4;

    ArrayLaImgB[0] := laImgB1;
    ArrayLaImgB[1] := laImgB2;
    ArrayLaImgB[2] := laImgB3;
    ArrayLaImgB[3] := laImgB4;

    ArrayLabelPose[dofYaw] := laYaw;
    ArrayLabelPose[dofPitch] := laPitch;
    ArrayLabelPose[dofRoll] := laRoll;
    ArrayLabelPose[dofPanX] := laPanX;
    ArrayLabelPose[dofPanY] := laPanY;
    ArrayLabelPose[dofPanZ] := laPanZ;

    ArrayLabelPoseDZ[dofYaw] := laYawDZ;
    ArrayLabelPoseDZ[dofPitch] := laPitchDZ;
    ArrayLabelPoseDZ[dofRoll] := laRollDZ;
    ArrayLabelPoseDZ[dofPanX] := laPanXDZ;
    ArrayLabelPoseDZ[dofPanY] := laPanYDZ;
    ArrayLabelPoseDZ[dofPanZ] := laPanZDZ;

    ArrayTbSensitivity[dofYaw] := tbSensitivityYaw;
    ArrayTbSensitivity[dofPitch] := tbSensitivityPitch;
    ArrayTbSensitivity[dofRoll] := tbSensitivityRoll;
    ArrayTbSensitivity[dofPanX] := tbSensitivityX;
    ArrayTbSensitivity[dofPanY] := tbSensitivityY;
    ArrayTbSensitivity[dofPanZ] := tbSensitivityZ;

    ArrayLaSensitivity[dofYaw] := laSensitivityYaw;
    ArrayLaSensitivity[dofPitch] := laSensitivityPitch;
    ArrayLaSensitivity[dofRoll] := laSensitivityRoll;
    ArrayLaSensitivity[dofPanX] := laSensitivityX;
    ArrayLaSensitivity[dofPanY] := laSensitivityY;
    ArrayLaSensitivity[dofPanZ] := laSensitivityZ;

    ArrayTbSmoothing[dofYaw] := tbSmoothingYaw;
    ArrayTbSmoothing[dofPitch] := tbSmoothingPitch;
    ArrayTbSmoothing[dofRoll] := tbSmoothingRoll;
    ArrayTbSmoothing[dofPanX] := tbSmoothingX;
    ArrayTbSmoothing[dofPanY] := tbSmoothingY;
    ArrayTbSmoothing[dofPanZ] := tbSmoothingZ;

    ArrayLaSmoothing[dofYaw] := laSmoothingYaw;
    ArrayLaSmoothing[dofPitch] := laSmoothingPitch;
    ArrayLaSmoothing[dofRoll] := laSmoothingRoll;
    ArrayLaSmoothing[dofPanX] := laSmoothingX;
    ArrayLaSmoothing[dofPanY] := laSmoothingY;
    ArrayLaSmoothing[dofPanZ] := laSmoothingZ;

    ArrayCbInverts[dofYaw]   := cbInvertYaw;
    ArrayCbInverts[dofPitch] := cbInvertPitch;
    ArrayCbInverts[dofRoll]  := cbInvertRoll;
    ArrayCbInverts[dofPanX]  := cbInvertX;
    ArrayCbInverts[dofPanY]  := cbInvertY;
    ArrayCbInverts[dofPanZ]  := cbInvertZ;

    ArrayTbGlobalSensitivity[dofYaw] := tbGlobalSensitivityYaw;
    ArrayTbGlobalSensitivity[dofPitch] := tbGlobalSensitivityPitch;
    ArrayTbGlobalSensitivity[dofRoll] := tbGlobalSensitivityRoll;
    ArrayTbGlobalSensitivity[dofPanX] := tbGlobalSensitivityX;
    ArrayTbGlobalSensitivity[dofPanY] := tbGlobalSensitivityY;
    ArrayTbGlobalSensitivity[dofPanZ] := tbGlobalSensitivityZ;

    ArrayLaGlobalSensitivity[dofYaw] := laGlobalSensitivityYaw;
    ArrayLaGlobalSensitivity[dofPitch] := laGlobalSensitivityPitch;
    ArrayLaGlobalSensitivity[dofRoll] := laGlobalSensitivityRoll;
    ArrayLaGlobalSensitivity[dofPanX] := laGlobalSensitivityX;
    ArrayLaGlobalSensitivity[dofPanY] := laGlobalSensitivityY;
    ArrayLaGlobalSensitivity[dofPanZ] := laGlobalSensitivityZ;

    ArrayTbGlobalSmoothing[dofYaw] := tbGlobalSmoothingYaw;
    ArrayTbGlobalSmoothing[dofPitch] := tbGlobalSmoothingPitch;
    ArrayTbGlobalSmoothing[dofRoll] := tbGlobalSmoothingRoll;
    ArrayTbGlobalSmoothing[dofPanX] := tbGlobalSmoothingX;
    ArrayTbGlobalSmoothing[dofPanY] := tbGlobalSmoothingY;
    ArrayTbGlobalSmoothing[dofPanZ] := tbGlobalSmoothingZ;

    ArrayLaGlobalSmoothing[dofYaw] := laGlobalSmoothingYaw;
    ArrayLaGlobalSmoothing[dofPitch] := laGlobalSmoothingPitch;
    ArrayLaGlobalSmoothing[dofRoll] := laGlobalSmoothingRoll;
    ArrayLaGlobalSmoothing[dofPanX] := laGlobalSmoothingX;
    ArrayLaGlobalSmoothing[dofPanY] := laGlobalSmoothingY;
    ArrayLaGlobalSmoothing[dofPanZ] := laGlobalSmoothingZ;

    ArrayCbGlobalInverts[dofYaw]   := cbGlobalInvertYaw;
    ArrayCbGlobalInverts[dofPitch] := cbGlobalInvertPitch;
    ArrayCbGlobalInverts[dofRoll]  := cbGlobalInvertRoll;
    ArrayCbGlobalInverts[dofPanX]  := cbGlobalInvertX;
    ArrayCbGlobalInverts[dofPanY]  := cbGlobalInvertY;
    ArrayCbGlobalInverts[dofPanZ]  := cbGlobalInvertZ;

    ArraysbPage[0] := sbPage1;
    ArraysbPage[1] := sbPage2;
    ArraysbPage[2] := sbPage3;
    ArraysbPage[3] := sbPage4;
    ArraysbPage[4] := sbPage5;
    ArraysbPage[5] := sbPage6;
    ArraysbPage[6] := sbPage7;
    ArraysbPage[7] := sbPage8;

    ArraysbTrack[0] := sbTrack1P;
    ArraysbTrack[1] := sbTrack3PClip;
    ArraysbTrack[2] := sbTrack3PCap;
    ArraysbTrack[3] := sbTrack4P;

    ArrayimPoint[0] := imPoint1;
    ArrayimPoint[1] := imPoint2;
    ArrayimPoint[2] := imPoint3;
    ArrayimPoint[3] := imPoint4;
    ArrayimPoint[4] := imPoint5;

    ArraybutKeyControl[keyPause] := butkeyPause;
    ArraybutKeyControl[keyCenter] := butkeyCenter;
    ArraybutKeyControl[keyCustomCenterSet] := butkeyCustomCenterSet;
    ArraybutKeyControl[keyCustomCenterReset] := butkeyCustomCenterReset;
    ArraybutKeyControl[keySmoothStable] := butkeySmoothStable;
    ArraybutKeyControl[keySmoothRaw] := butkeySmoothRaw;
    ArraybutKeyControl[keyYaw] := butkeyYaw;
    ArraybutKeyControl[keyPitch] := butkeyPitch;
    ArraybutKeyControl[keyRoll] := butkeyRoll;
    ArraybutKeyControl[keyPanX] := butkeyPanX;
    ArraybutKeyControl[keyPanY] := butkeyPanY;
    ArraybutKeyControl[keyPanZ] := butkeyPanZ;
    ArraybutKeyControl[keyFreetrack] := butkeyFreetrack;
    ArraybutKeyControl[keyTIR] := butkeyTIR;
    ArraybutKeyControl[keyMouse] := butkeyMouse;
    ArraybutKeyControl[keyJoy] := butkeyJoy;
    ArraybutKeyControl[keyKeyOutput] := butkeyKeyOutput;
    ArraybutKeyControl[keySimConnect] := butkeySimConnect;
    ArraybutKeyControl[keyProfileA] := butkeyProfileA;
    ArraybutKeyControl[keyProfileB] := butkeyProfileB;
    ArraybutKeyControl[keyProfileC] := butkeyProfileC;


    ArraycbKeyControlBeep[keyCenter] := cbCenterKeyBeep;
    ArraycbKeyControlBeep[keyPause] := cbPauseKeyBeep;
    ArraycbKeyControlBeep[keyCustomCenterSet] := cbCustomCenterSetKeyBeep;
    ArraycbKeyControlBeep[keyCustomCenterReset] := cbCustomCenterResetKeyBeep;
    ArraycbKeyControlBeep[keySmoothStable] := cbSmoothStableKeyBeep;
    ArraycbKeyControlBeep[keySmoothRaw] := cbSmoothRawKeyBeep;
    ArraycbKeyControlBeep[keyYaw] := cbYawKeyBeep;
    ArraycbKeyControlBeep[keyPitch] := cbPitchKeyBeep;
    ArraycbKeyControlBeep[keyRoll] := cbRollKeyBeep;
    ArraycbKeyControlBeep[keyPanX] := cbPanXKeyBeep;
    ArraycbKeyControlBeep[keyPanY] := cbPanYKeyBeep;
    ArraycbKeyControlBeep[keyPanZ] := cbPanZKeyBeep;
    ArraycbKeyControlBeep[keyFreetrack] := cbFreetrackKeyBeep;
    ArraycbKeyControlBeep[keyTIR] := cbTIRKeyBeep;
    ArraycbKeyControlBeep[keyMouse] := cbMouseKeyBeep;
    ArraycbKeyControlBeep[keyJoy] := cbJoyKeyBeep;
    ArraycbKeyControlBeep[keyKeyOutput] := cbKeyOutputKeyBeep;
    ArraycbKeyControlBeep[keySimConnect] := cbSimConnectKeyBeep;
    ArraycbKeyControlBeep[keyProfileA] := cbProfileAKeyBeep;
    ArraycbKeyControlBeep[keyProfileB] := cbProfileBKeyBeep;
    ArraycbKeyControlBeep[keyProfileC] := cbProfileCKeyBeep;

    ArraycbKeyControlToggle[keyPause] := cbPauseKeyToggle;
    ArraycbKeyControlToggle[keyCenter] := cbCenterKeyToggle;
    ArraycbKeyControlToggle[keyCustomCenterSet] := cbCustomCenterSetKeyToggle;
    ArraycbKeyControlToggle[keyCustomCenterReset] := cbCustomCenterResetKeyToggle;
    ArraycbKeyControlToggle[keySmoothStable] := cbSmoothStableKeyToggle;
    ArraycbKeyControlToggle[keySmoothRaw] := cbSmoothRawKeyToggle;
    ArraycbKeyControlToggle[keyYaw] := cbYawKeyToggle;
    ArraycbKeyControlToggle[keyPitch] := cbPitchKeyToggle;
    ArraycbKeyControlToggle[keyRoll] := cbRollKeyToggle;
    ArraycbKeyControlToggle[keyPanX] := cbPanXKeyToggle;
    ArraycbKeyControlToggle[keyPanY] := cbPanYKeyToggle;
    ArraycbKeyControlToggle[keyPanZ] := cbPanZKeyToggle;
    ArraycbKeyControlToggle[keyFreetrack] := cbFreetrackKeyToggle;
    ArraycbKeyControlToggle[keyTIR] := cbTIRKeyToggle;
    ArraycbKeyControlToggle[keyMouse] := cbMouseKeyToggle;
    ArraycbKeyControlToggle[keyJoy] := cbJoyKeyToggle;
    ArraycbKeyControlToggle[keyKeyOutput] := cbKeyOutputKeyToggle;
    ArraycbKeyControlToggle[keySimConnect] := cbSimConnectKeyToggle;
    ArraycbKeyControlToggle[keyProfileA] := cbProfileAKeyToggle;
    ArraycbKeyControlToggle[keyProfileB] := cbProfileBKeyToggle;
    ArraycbKeyControlToggle[keyProfileC] := cbProfileCKeyToggle;

    ArraycomboKeyProfile[keyProfileA] := combProfileA;
    ArraycomboKeyProfile[keyProfileB] := combProfileB;
    ArraycomboKeyProfile[keyProfileC] := combProfileC;

    ArraycombAxisMap[dofYaw]   := combAxisMapYaw;
    ArraycombAxisMap[dofPitch] := combAxisMapPitch;
    ArraycombAxisMap[dofRoll]  := combAxisMapRoll;
    ArraycombAxisMap[dofPanX]  := combAxisMapPanX;
    ArraycombAxisMap[dofPanY]  := combAxisMapPanY;
    ArraycombAxisMap[dofPanZ]  := combAxisMapPanZ;

    ArrayResponseCfg[dofYaw]   := YawCfg;
    ArrayResponseCfg[dofPitch] := PitchCfg;
    ArrayResponseCfg[dofRoll]  := RollCfg;
    ArrayResponseCfg[dofPanX]  := PanXCfg;
    ArrayResponseCfg[dofPanY]  := PanYCfg;
    ArrayResponseCfg[dofPanZ]  := PanZCfg;

    ArraycbOptions[boptLaunchatStartup] := cbLaunchatStartup;
    ArraycbOptions[boptStartMinimized] := cbStartMinimized;
    ArraycbOptions[boptConfirmClose] := cbConfirmClose;
    ArraycbOptions[boptAutoMinimize] := cbAutoMinimize;
    ArraycbOptions[boptAutoLoadProfile] := cbAutoLoadProfile;
    ArraycbOptions[boptAutoSaveProfile] := cbAutoSaveProfile;

    ArraycbRelativeTrans[dofYaw] := cbRelativeTransYaw;
    ArraycbRelativeTrans[dofPitch] := cbRelativeTransPitch;
    ArraycbRelativeTrans[dofRoll] := cbRelativeTransRoll;
    ArraycbRelativeTrans[dofPanX] := cbRelativeTransX;
    ArraycbRelativeTrans[dofPanY] := cbRelativeTransY;
    ArraycbRelativeTrans[dofPanZ] := cbRelativeTransZ;

    ArraytbRotOffset[dofPanX] := tbRotOffsetX;
    ArraytbRotOffset[dofPanY] := tbRotOffsetY;
    ArraytbRotOffset[dofPanZ] := tbRotOffsetZ;

    ArraylaRotOffset[dofPanX] := laRotOffsetX;
    ArraylaRotOffset[dofPanY] := laRotOffsetY;
    ArraylaRotOffset[dofPanZ] := laRotOffsetZ;

    for i := 0 to 3 do
      ScreenAverages[i] := TAverage.Create;

    SetLength(ScreenPoints, 4);
    ScreenFPS := 30;   // needed to keep smoothing on at startup due to fps dependency 
    FrameCount := 30;
    PageControl1.ActivePageIndex := 0;

    MyConfig := TConfig.Create(Self, configIni);
    MyProfile := TProfile.Create(nil);
    MyPoseObj := TPoseObject.Create;

    CreateDir(rootDirectory + 'Profiles\');

    ProfilesMngr := TProfilesMngr.Create(Self);
    ProfilesMngr.Parent := gpProfiles;
    ProfilesMngr.OnProfileSelected := GestProfileSelected;
    ProfilesMngr.OnSaveProfile := GestSaveProfile;
    ProfilesMngr.OnDefaultRequired := GestDefaultRequired;
    ProfilesMngr.OnProfileRenamed := GestProfileRenamed;
    ProfilesMngr.butRefreshProfileList.onClick := butRefreshProfileListClick;
    ProfilesMngr.butNewProfile.onClick := butNewProfileClick;
    ProfilesMngr.Visible := True;
    ProfilesMngr.SetProgramsList(rootDirectory + 'Programs.ini');

    // before cam manager
    PoseDataOutput := TPoseDataOutput.Create(Self);
    PoseDataOutput.Parent := tsOutput;
    PoseDataOutput.Visible := True;

    aFreeTrackTray := TFreeTrackTray.Create(Self);
    aFreeTrackTray.OnRestore := GestOnRestore;
    aFreeTrackTray.OnMinimize := GestOnMinimize;

    aCamManager := TCamManager.Create(Self);
    aCamManager.OnLedDetected := GestOnLedDetected;
    aCamManager.OnStateChanged := GestStateChanged;
    aCamManager.OnDemoFinished := ApplyCenter;
    aCamManager.OnAlternatePlayPause := AlternatePlayPause;
    aCamManager.OnChangedsource := GestOnChangedSource;
    aCamManager.LoadCfgFromIni(configIni);
    aCamManager.Parent := paCam;
    aCamManager.Visible := True;

    ForceCamProp.LoadCfgFromIni(configIni);

    HeadPanel := THeadDisplay.Create(paHead);
    HeadPanel.Visible := False;
    Application.OnIdle := RenderIdle;

    HostList := TList.Create;

    GUILoadConfig;
    LoadProfiles;

    SetPriorityClass(GetCurrentProcess, NORMAL_PRIORITY_CLASS);

    LangManager.DefaultLanguageID := 1033; // english US
    LangManager.ScanForLangFiles(rootDirectory + '\Language\', '*.lng', False);
    // populate language list
    for i := 0 to LangManager.LanguageCount-1 do
      combLanguage.AddItem(LangManager.LanguageNames[i], Self);
    // try to find a translation that matches the user language
    if AnsiCompareText(MyConfig.Language, 'auto') = 0 then begin
      LangID := GetUserDefaultLangID;
      for i := 0 to LangManager.LanguageCount-1 do
        if ((LangManager.LanguageIDs[i] and $3FF) = (LangID and $3FF)) then // mask sublanguage
          combLanguage.ItemIndex := LangManager.IndexOfLanguageID(LangManager.LanguageIDs[i]);
    // load last language
    end else
      for i := 0 to LangManager.LanguageCount-1 do
        if LangManager.LanguageNames[i] = MyConfig.Language then
          combLanguage.ItemIndex := i;
    // default to english US
    if combLanguage.ItemIndex = -1 then
      combLanguage.ItemIndex := LangManager.IndexOfLanguageID(1033);
    combLanguageChange(Self);

    //Display version in About tabsheet
    laVersion.Caption := #13#10'FreeTrack ' + GetVersion(Application.ExeName);
    aFilter := rootDirectory  + 'FreeTrackFilter' + aCamManager.FreetrackFilter + '.ax';
    if FileExists(aFilter) then
      laVersion.Caption := laVersion.Caption + #13#10 + 'FreeTrackFilter ' + GetVersion(aFilter);
    if FileExists(PoseDataOutput.FreetrackDll) then
      laVersion.Caption := laVersion.Caption + #13#10 + 'FreeTrackClient ' + GetVersion(PoseDataOutput.FreetrackDll);
    if FileExists(PoseDataOutput.TIRDll) then
      laVersion.Caption := laVersion.Caption + #13#10 + 'NPClient ' + GetVersion(PoseDataOutput.TIRDll);

    Application.HintColor := clSkyBlue;
    Application.HintPause := 1000;
    Application.HintHidePause := 10000;


    YawCfg.Name := DKLangConstW('S_YAW');
    PitchCfg.Name := DKLangConstW('S_PITCH');
    RollCfg.Name := DKLangConstW('S_ROLL');
    PanXCfg.Name := DKLangConstW('S_PANX');
    PanYCfg.Name := DKLangConstW('S_PANY');
    PanZCfg.Name := DKLangConstW('S_PANZ');
    for aDOF := Low(TDOF) to High(TDOF) do begin
      ArrayResponseCfg[aDOF].VerLabel := DKLangConstW('S_RESP_LABEL_IN');
      ArrayResponseCfg[aDOF].HorLabel := DKLangConstW('S_RESP_LABEL_OUT');
      ArrayResponseCfg[aDOF].OnCurveChanged := GestResponseChanged;
    end;

    OnTaskBarCreated := RegisterWindowMessage('TaskbarCreated');

    // prevent hotkeys from triggering on startup due to zero inter-press count
    for aKey := Low(TKeyControl) to High(TKeyControl) do
      KeyControl[aKey].InterPressCount := 1;

    DInput.OnFinishedPoll := KeyPollFinished;
    timerKey.Enabled := True;

    StartMinimized := False;
    for i := 1 to ParamCount do
      if (ParamStr(i) = '/tray') then
        StartMinimized := True;
    if MyConfig.BinaryOptions[boptStartMinimized] then
      StartMinimized := True;

    if StartMinimized then
      Application.Minimize
    else if not Application.Terminated then
      Application.ShowMainForm := True;

    // trim memory usage
    SetProcessWorkingSetSize(GetCurrentProcess, $ffffffff, $ffffffff);

    sbHowTo.Visible := FileExists(IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'help.chm');
  finally
    configIni.Free;
  end;
end;


procedure TfmFreetrack.GUILoadConfig;
var
  defstyle: dWord;
  aDOF : TDOF;
  aHeadAid : THeadAids;
  aOption : TBinaryOptions;
begin

  sbTrackingMethodClick(ArraysbTrack[Ord(MyConfig.TrackingMethod)]);
  ArraysbTrack[Ord(MyConfig.TrackingMethod)].Down := True;

  // Model measurement boxes, numbers only
  defstyle := GetWindowLong(ed3PClipz1.Handle, GWL_STYLE);
  SetWindowLong(ed3PClipz1.Handle, GWL_STYLE, defstyle or ES_NUMBER or ES_LEFT);
  SetWindowLong(ed3PClipz2.Handle, GWL_STYLE, defstyle or ES_NUMBER or ES_LEFT);
  SetWindowLong(ed3PClipy1.Handle, GWL_STYLE, defstyle or ES_NUMBER or ES_LEFT);
  SetWindowLong(ed3PClipy2.Handle, GWL_STYLE, defstyle or ES_NUMBER or ES_LEFT);

  SetWindowLong(ed3PCapx.Handle, GWL_STYLE, defstyle or ES_NUMBER);
  SetWindowLong(ed3PCapy.Handle, GWL_STYLE, defstyle or ES_NUMBER);
  SetWindowLong(ed3PCapz.Handle, GWL_STYLE, defstyle or ES_NUMBER);

  SetWindowLong(ed4Px1.Handle, GWL_STYLE, defstyle or ES_NUMBER);
  SetWindowLong(ed4Py1.Handle, GWL_STYLE, defstyle or ES_NUMBER);
  SetWindowLong(ed4Py2.Handle, GWL_STYLE, defstyle or ES_NUMBER);
  SetWindowLong(ed4Pz1.Handle, GWL_STYLE, defstyle or ES_NUMBER);
  SetWindowLong(ed4Pz2.Handle, GWL_STYLE, defstyle or ES_NUMBER);

  case MyConfig.TrackingMethod of
    tmThreePointClip : MyPoseObj.Initialize3PClipModel(MyConfig.Dimensions3PtsClip);
    tmThreePointCap : MyPoseObj.Initialize3PCapModel(MyConfig.Dimensions3PtsCap);
    tmFourPoint : MyPoseObj.Initialize4PModel(MyConfig.Dimensions4Pts);
  end;

  ed3PClipz1.text := InttoStr(round(abs(MyConfig.Dimensions3PtsClip[0].z)));
  ed3PClipz2.text := InttoStr(round(abs(MyConfig.Dimensions3PtsClip[1].z)));
  ed3PClipy1.text := InttoStr(round(abs(MyConfig.Dimensions3PtsClip[0].y)));
  ed3PClipy2.text := InttoStr(round(abs(MyConfig.Dimensions3PtsClip[1].y)));

  ed3PCapx.text := InttoStr(round(abs(MyConfig.Dimensions3PtsCap[0].x)));
  ed3PCapy.text := InttoStr(round(abs(MyConfig.Dimensions3PtsCap[0].y)));
  ed3PCapz.text := InttoStr(round(abs(MyConfig.Dimensions3PtsCap[0].z)));

  ed4Px1.text := InttoStr(round(abs(MyConfig.Dimensions4Pts[1].x)));
  ed4Py1.text := InttoStr(round(abs(MyConfig.Dimensions4Pts[1].y)));
  ed4Py2.text := InttoStr(round(abs(MyConfig.Dimensions4Pts[2].y)));
  ed4Pz1.text := InttoStr(round(abs(MyConfig.Dimensions4Pts[1].z)));
  ed4Pz2.text := InttoStr(round(abs(MyConfig.Dimensions4Pts[2].z)));

  but3pClipApply.Enabled := False;
  but3pCapApply.Enabled := False;
  but4pCapApply.Enabled := False;

  for aDOF := Low(TDOF) to High(TDOF) do  begin
    ArrayTbGlobalSensitivity[aDOF].Position := Round((MyConfig.GlobalSensitivity[aDOF]/SENSITIVITY_MAX) * ArrayTbGlobalSensitivity[aDOF].Max);
    ArrayLaGlobalSensitivity[aDOF].Caption := format('%.1f', [MyConfig.GlobalSensitivity[aDOF]]);
  end;

  for aDOF := Low(TDOF) to High(TDOF) do begin
    ArrayTbGlobalSmoothing[aDOF].Position := MyConfig.GlobalSmoothing[aDOF];
    ArrayLaGlobalSmoothing[aDOF].Caption := format('%d', [ArrayTbGlobalSmoothing[aDOF].Position]);
  end;

  for aHeadAid := Low(THeadAids) to High(THeadAids) do begin
    if MyConfig.HeadAids[aHeadAid] then PopHead.Items.Items[Ord(aHeadAid)].Checked := True;
    if HeadPanel <> nil then
      HeadPanel.HeadAids[aHeadAid] := MyConfig.HeadAids[aHeadAid];
  end;

  tbGlobalSmoothingZooming.Position := MyConfig.GlobalSmoothingZooming;
  laGlobalSmoothingZooming.Caption := format('%d', [tbGlobalSmoothingZooming.Position]);

  cbGlobalInvertYaw.Checked   := MyConfig.GlobalInverts[dofYaw];
  cbGlobalInvertPitch.Checked := MyConfig.GlobalInverts[dofPitch];
  cbGlobalInvertRoll.Checked  := MyConfig.GlobalInverts[dofRoll];
  cbGlobalInvertX.Checked     := MyConfig.GlobalInverts[dofPanX];
  cbGlobalInvertY.Checked     := MyConfig.GlobalInverts[dofPanY];
  cbGlobalInvertZ.Checked     := MyConfig.GlobalInverts[dofPanZ];

  cbAutoCentering.Checked := MyConfig.AutoCentering;
  cbAutoCenteringClick(Self);
  tbAutoCenteringSpeed.Position := MyConfig.AutoCenteringSpeed;
  tbAutoCenteringSpeedChange(Self);

  for aOption := Low(TBinaryOptions) to High(TBinaryOptions) do
    ArraycbOptions[aOption].Checked := MyConfig.BinaryOptions[aOption];

end;


procedure TfmFreetrack.GUILoadProfile;
var
  aDOF : TDOF;
  aKeyControl: TKeyControl;
begin

  PreventProfileDirtyStatus := True;

  PoseDataOutput.LoadGUIProfile;

  tbAverage.Position := MyProfile.Average;
  tbAverageChange(Self);

  cbBackwardZ.Checked := MyProfile.IgnoreBackwardZ;
  cbMaintainPausedData.Checked := MyProfile.MaintainPausedData;

  for aDOF := Low(TDOF) to High(TDOF) do
    SetSensitivity(aDOF, MyProfile.Sensitivity[aDOF]);

  for aDOF := Low(TDOF) to High(TDOF) do begin
    ArrayTbSmoothing[aDOF].Position := MyProfile.Smoothing[aDOF];
    tbSmoothingChange(ArrayTbSmoothing[aDOF]);
  end;

  for aDOF := Low(TDOF) to High(TDOF) do
    ArrayCbInverts[aDOF].Checked := MyProfile.Inverts[aDOF];

  for aDOF := Low(TDOF) to High(TDOF) do
    if MyProfile.AxisEnabled[aDOF] then
      ArraycombAxisMap[aDOF].ItemIndex := Ord(MyProfile.AxisMap[aDOF]) + 1
    else
      ArraycombAxisMap[aDOF].ItemIndex := 0;

  cbRollRelativeRot.Checked := MyProfile.RollRelativeRot;
  for aDOF := Low(TDOF) to High(TDOF) do
    ArraycbRelativeTrans[aDOF].Checked := MyProfile.RelativeTrans[aDOF];

  tbSmoothingZooming.Position := MyProfile.SmoothingZooming;
  laSmoothingZooming.Caption := format('%d', [tbSmoothingZooming.Position]);

  tbDynamicSmoothing.Position := MyProfile.DynamicSmoothing;
  tbDynamicSmoothingChange(Self);

  YawCfg.LoadCfgFromIni(MyProfile.ResponseCurves[dofYaw]);
  PitchCfg.LoadCfgFromIni(MyProfile.ResponseCurves[dofPitch]);
  RollCfg.LoadCfgFromIni(MyProfile.ResponseCurves[dofRoll]);

  PanXCfg.LoadCfgFromIni(MyProfile.ResponseCurves[dofPanX]);
  PanYCfg.LoadCfgFromIni(MyProfile.ResponseCurves[dofPanY]);
  PanZCfg.LoadCfgFromIni(MyProfile.ResponseCurves[dofPanZ]);

  // setup axis limits in HeadPanel
  GestResponseChanged(Self);

  RefreshFormTitle;

  tbSmoothStable.Position := MyProfile.SmoothStableMultiplier;
  SmoothStableMultiplier := 1;
  ZoomMultiplier := 1;
  Centering := 10;

  tbSmoothRaw.Position := MyProfile.SmoothRawMultiplier;
  SmoothRawMultiplier := 1;

  for aKeyControl := Low(TKeyControl) to High(TKeyControl) do begin
    ArraycbKeyControlBeep[aKeyControl].Checked := MyProfile.KeyControlsBeep[aKeyControl];
    if aKeyControl <> keyPause then
      ArraycbKeyControlToggle[aKeyControl].Checked := MyProfile.KeyControlsToggle[aKeyControl];
    KeyControl[aKeyControl].Name := MyProfile.KeyControls[aKeyControl];
    ArraybutKeyControl[aKeyControl].Caption := KeyControl[aKeyControl].Name;
    DInput.Str2CodeControl(KeyControl[aKeyControl]);
  end;

  ApplyCenter(Self);
  NoSmoothingDelay := 5;
  PreventProfileDirtyStatus := False;
  ProfilesMngr.ProfileIsDirty := False;

end;


procedure TfmFreetrack.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  configIni : TIniFile;
  saveChangesResult : Integer;
begin
  configIni := TIniFile.Create(rootDirectory  + 'Freetrack.ini');
  try

    if MyConfig.BinaryOptions[boptConfirmClose] then
      if MessageDlg(DKLangConstW('S_QUERY_CONFIRM_CLOSE'), mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        Abort;

    if ProfilesMngr.ProfileIsDirty then
      if not MyConfig.BinaryOptions[boptAutoSaveProfile] then begin
        saveChangesResult := MessageDlg(Format(DKLangConstW('S_QUERY_SAVE_CHANGES'), [ChangeFileExt(ExtractFilename(MyConfig.ProfileFilename), '')]),mtConfirmation, mbYesNoCancel, 0);
        if saveChangesResult = mrYes then
          ProfilesMngr.butSaveProfileClick(Self)
        else if saveChangesResult = mrCancel then
          Abort;
      end else
        ProfilesMngr.butSaveProfileClick(Self);

    timerKey.Enabled := False;
    DInput.timerPoll.Enabled := False;
    Application.OnIdle := nil;

    ProfilesMngr.SaveToFile(configIni);

    if aCamManager.CamState = camPlaying then
      butStartClick(Self) // stop
    else if aCamManager.CamState = camPaused then begin
      butStartClick(Self); // resume
      butStartClick(Self); // stop
    end;

    aCamManager.SaveCfgToIni(configIni);
    aCamManager.OnStateChanged := nil;
    aCamManager.OnLedDetected := nil;

    ForceCamProp.SaveCfgToIni(configIni);

    MyConfig.SaveParamsToIni(configIni);

  finally
    configIni.Free;
  end;
end;



procedure TfmFreetrack.GestOnLedDetected(ListPoint: TListPoint);
var
  i : Integer;
  aDOF: TDOF;
  PoseTmp, GamePoseTmp, delta : TPose;
  matTrans, matRot : TD3DXMatrix;
  RollRelative : Integer;
begin

  // timing
  CurTick := GetTickCount;
  if (CurTick > LastTick) then begin
    ScreenFPS := FrameCount;
    LastTick := CurTick + 1000;
    FrameCount := 0;
  end else
    inc(FrameCount);

  // jitter
  if not aFreeTrackTray.visible then begin
    if (aCamManager.CamSource = camVid) or (aCamManager.CamSource = camDemo) then
      ListPoint.ReferenceClock.GetTime(CurRefCount)
    else begin
      QueryPerformanceCounter(CurRefCount);
      QueryPerformanceFrequency(HPFrequency);
      CurRefCount := Trunc((CurRefCount/ HPFrequency) * 10000000);
    end;

    TimebetweenFrames := (CurRefCount - PrevRefCount);
    PrevRefCount := CurRefCount;

    if  ((10000000/TimebetweenFrames) < ScreenFPS - 0.4*ScreenFPS) or
        ((10000000/TimebetweenFrames) > ScreenFPS + 0.4*ScreenFPS) then
      inc(JitterCount);
    if FrameCount = 0 then begin
      AvgJitterCount := JitterCount;
      JitterCount := 0;
    end;
  end;

  ScreenNumberPoints := ListPoint.Count;

  if ScreenNumberPoints = TRACKING_NUMBER_OF_POINTS[MyConfig.TrackingMethod] then begin

    // smallest y value to top
    ListPoint.SortY;
    // sort by x and then move point with smallest y value to top of list for cap tracking
    if  (MyConfig.TrackingMethod = tmThreePointCap) or
        (MyConfig.TrackingMethod = tmFourPoint) then
      ListPoint.SortCap;

    for i := 0 to ScreenNumberPoints-1 do begin
        ScreenPoints[i] := Point2D32f( ListPoint[i].X * LISTPOINT_SCALER_INV - aCamManager.SensorSize.Right * 0.5,
                                      -ListPoint[i].Y * LISTPOINT_SCALER_INV + aCamManager.SensorSize.Bottom * 0.5);

      //average - number of frames averaged is percentage of total frame rate
      ScreenAverages[i].NbSamples := Trunc(ScreenFPS * (MyProfile.Average/tbAverage.Max));
      ScreenAverages[i].Point2D32f := ScreenPoints[i];
      ScreenPoints[i] := ScreenAverages[i].Point2D32f;
    end;
    for i := ScreenNumberPoints to 3 do
      ScreenPoints[i] := Point2D32f(0, 0);

    PoseDataOutput.UpdatePoints(ScreenPoints);

    if aCamManager.CamState = camPlaying then
      aFreeTrackTray.State := tsON_Ok;

    // determine pose estimate
    case MyConfig.TrackingMethod of
      tmSinglePoint : begin
        RawPose[dofYaw]   := (Screenpoints[0].x/(aCamManager.SensorSize.Right * 0.5)) * (pi * 0.4);
        RawPose[dofPitch] := (Screenpoints[0].y/(aCamManager.SensorSize.Bottom * 0.5)) * (pi * 0.4);
        for aDOF := dofRoll to dofPanZ do
          RawPose[aDOF] := 0;
      end;
      tmThreePointClip :
        if MyPoseObj.AlterPoseClip(ScreenPoints, PoseTmp, h1h2) then
          for aDOF := Low(TDOF) to High(TDOF) do
            RawPose[aDOF] := PoseTmp[aDOF];
      tmThreePointCap :
        if MyPoseObj.AlterPoseCap(ScreenPoints, PoseTmp, h1h2) then
          for aDOF := Low(TDOF) to High(TDOF) do
            RawPose[aDOF] := PoseTmp[aDOF];
      tmFourPoint :
        if MyPoseObj.Posit(ScreenPoints, PoseTmp) then
          for aDOF := Low(TDOF) to High(TDOF) do
            RawPose[aDOF] := PoseTmp[aDOF];
    end;


    // scale translation to pi so that all axes are in the range +/-pi
    //apply inverts and axis ouput mapping
    for aDOF := Low(TDOF) to High(TDOF) do
      if MyProfile.AxisEnabled[aDOF] then
        RealPose[aDOF] := ifthen(MyProfile.AxisMap[aDOF] > dofRoll, 1/TRANS_PI_RANGE, 1) *
                          ifthen(MyProfile.Inverts[aDOF] xor MyConfig.GlobalInverts[aDOF], -1, 1) *
                          RawPose[MyProfile.AxisMap[aDOF]];

    // matrix is actually 4x4, fill matrix to make sure there are no NAN entries
    D3DXMatrixIdentity(matTrans);
    // account for camera orientation for translation
    matTrans._11 := RealPose[dofPanX];  matTrans._12 := 0;                  matTrans._13 := 0;
    matTrans._21 := 0;                  matTrans._22 := RealPose[dofPanY];  matTrans._23 := 0;
    matTrans._31 := 0;                  matTrans._32 := 0;                  matTrans._33 := RealPose[dofPanZ];

    // wii point coordinates adjusted for orientation so roll should be relative to nearest axis
    {if (aCamManager.CamSource = camWii) then begin
      RollRelative := MyConfig.CamPos[dofRoll] mod 90;
      if abs(RollRelative) > 45 then RollRelative := 90 - RollRelative;
    end else
      RollRelative := MyConfig.CamPos[dofRoll];      }

    RollRelative := 0;

    D3DXMatrixRotationYawPitchRoll(matRot, DegToRad(MyConfig.CamPos[dofYaw]), DegToRad(-MyConfig.CamPos[dofPitch]), DegToRad(RollRelative) );
    D3DXMatrixMultiply(matTrans, matTrans, matRot);

    RealPose[dofPanX] := matTrans._11 + matTrans._21 + matTrans._31;
    RealPose[dofPanY] := matTrans._12 + matTrans._22 + matTrans._32;
    RealPose[dofPanZ]:= matTrans._13 + matTrans._23 + matTrans._33;

    // only need to interpolate webcam frames
    if (aCamManager.CamSource = camWii) or (aCamManager.CamSource = camOptitrack)  then
      PoseDataOutput.UpdateRawPose(RawPose)
    else
      PoseDataOutput.InterpolateRawPose(RawPose);

    // manual centering
    if KeyControl[keyCenter].InternalState or (Centering > 0) then
      for aDOF := Low(TDOF) to High(TDOF) do
        MyConfig.Center[aDOF] := RealPose[aDOF];

    // auto centering
    {if MyConfig.AutoCentering then
      for aDOF := Low(TDOF) to High(TDOF) do
        //if (SmallDeltaCount[aDOF] > 500) then
          case aDOF of
            dofYaw..dofRoll : MyConfig.Center[aDOF] := MyConfig.Center[aDOF] + 0.00001 * MyConfig.AutoCenteringSpeed * sign(GamePose[aDOF]) * (abs(GamePose[aDOF])/(1000 + abs(GamePose[aDOF])));
            dofPanX..dofPanZ : MyConfig.Center[aDOF] := MyConfig.Center[aDOF] + 0.001 * MyConfig.AutoCenteringSpeed * sign(GamePose[aDOF]) * (abs(GamePose[aDOF])/(1000 + abs(GamePose[aDOF])));
          end;  }

    // Relative to center
    for aDOF := Low(TDOF) to High(TDOF) do
      GamePoseTmp[aDOF]  := RealPose[aDOF] - MyConfig.Center[aDOF];

    // Scale smoothing according to zoom - use data from previous frame which has sensitivity and response applied
    if  ((MyProfile.SmoothingZooming > 1) or  (MyConfig.GlobalSmoothingZooming > 1)) and
        (GamePose[dofPanZ] < -ArrayResponseCfg[dofPanZ].Converted[RESP_MAX]/4) then begin
      ZoomMultiplier := 1 + 5000 * (abs(GamePose[dofPanZ]) - ArrayResponseCfg[dofPanZ].Converted[RESP_MAX]/4) * MyProfile.SmoothingZooming * MyConfig.GlobalSmoothingZooming * INTEGER_DIV;
      if (ZoomMultiplier < 1.01) then
        ZoomMultiplier := 1;
    end else
      ZoomMultiplier := 1;

    // smoothing
    for aDOF := low(TDOF) to High(TDOF) do begin
      delta[aDOF] := abs(GamePoseTmp[aDOF] - PreviousGamePose[aDOF]);

      // make centering and initial pose immediate by using small smoothing (but NOT zero)
      if (Centering > 0) or (NoSmoothingDelay > 0) then begin
        SmoothingSize[aDOF] := 0.0001;
        delta[aDOF] := 1;
        Dec(NoSmoothingDelay);
      end else begin
        // smoothing proportional to frame rate
        case aDOF of
          dofYaw, dofPitch, dofPanX, dofPanY : SmoothingSize[aDOF] := 0.001 * ScreenFPS * MyProfile.Smoothing[aDOF] * MyConfig.GlobalSmoothing[aDOF] * INTEGER_DIV * ZoomMultiplier;
          dofRoll : SmoothingSize[aDOF] := 0.003 * ScreenFPS * MyProfile.Smoothing[aDOF] * MyConfig.GlobalSmoothing[aDOF] * INTEGER_DIV * ZoomMultiplier;
          dofPanZ : SmoothingSize[aDOF] := 0.001 * ScreenFPS * MyProfile.Smoothing[aDOF] * MyConfig.GlobalSmoothing[aDOF] * INTEGER_DIV;
        end;

        // dynamic deadzone decreases for fast movements
        SmoothingSize[aDOF] := (SmoothingSize[aDOF] * DynamicSmoothing * 10 / (DynamicSmoothing + 1000 * abs(delta[aDOF])));

        if KeyControl[keySmoothStable].InternalState then
          SmoothingSize[aDOF] := SmoothingSize[aDOF] * SmoothStableMultiplier;
        if KeyControl[keySmoothRaw].InternalState then
          SmoothingSize[aDOF] := SmoothingSize[aDOF] * SmoothRawMultiplier;
      end;

      {equation favours previous pose if pose change is small
      favours current pose if pose change is large
      result is jitter reduction with only a small reduction in low-to-mid speed responsiveness}
      GamePoseTmp[aDOF] := ((GamePoseTmp[aDOF] * delta[aDOF]) / (delta[aDOF] + SmoothingSize[aDOF]))
                            + ((PreviousGamePose[aDOF] * SmoothingSize[aDOF]) / (delta[aDOF] + SmoothingSize[aDOF]));

      // feedback
      PreviousGamePose[aDOF] := GamePoseTmp[aDOF];

      // sensitivity, then response curves (important to apply after smoothing)
      GamePoseTmp[aDOF] := Max(-RESP_MAX, Min(RESP_MAX, RESP_INTEGER_SCALER * {RESP_NOSCALING *} RadtoDeg(MyProfile.Sensitivity[aDOF] * MyConfig.GlobalSensitivity[aDOF] * GamePoseTmp[aDOF])));
      GamePose[aDOF] := ArrayResponseCfg[aDOF].Converted[Round(GamePoseTmp[aDOF])];
    end;

    // auto centering
     { case aDOF of
        dofYaw :  if deltaAverages[aDOF].Single < (YawCfg.Scale) then Inc(SmallDeltaCount[aDOF]) else SmallDeltaCount[aDOF] := 0;
        dofPitch : if deltaAverages[aDOF].Single < (PitchCfg.Scale) then Inc(SmallDeltaCount[aDOF]) else SmallDeltaCount[aDOF] := 0;
        dofRoll : if deltaAverages[aDOF].Single < (RollCfg.Scale) then Inc(SmallDeltaCount[aDOF]) else SmallDeltaCount[aDOF] := 0;
        dofPanX..dofPanZ : if deltaAverages[aDOF].Single < 20 then Inc(SmallDeltaCount[aDOF]) else SmallDeltaCount[aDOF] := 0;
      end;   }

    // radial deadzone
    //GamePose[dofYaw] := GamePose[dofYaw] * abs(YawCfg.Converted[Round(Sqrt(Sqr(GamePose[dofYaw]) + Sqr(GamePose[dofPitch])))] / YawCfg.Converted[RESP_MAX]);
    //GamePose[dofPitch] := GamePose[dofPitch] * abs(PitchCfg.Converted[Round(Sqrt(Sqr(GamePose[dofYaw]) + Sqr(GamePose[dofPitch])))] / PitchCfg.Converted[RESP_MAX]);

    // Portal mode
    {if cbPortal.Checked then begin
      GamePose[dofYaw] := GamePose[dofYaw] - 0.2 * GamePose[dofPanX];
      GamePose[dofPitch] := GamePose[dofPitch] -0.2 * GamePose[dofPanY];
      GamePose[dofPanZ] := 0.3 * GamePose[dofPanZ];
    end; }

    // view relative translation
    if (MyProfile.RelativeTrans[dofYaw] or MyProfile.RelativeTrans[dofPitch] or MyProfile.RelativeTrans[dofRoll]) then begin
      // matrix is actually 4x4, fill matrix to make sure there are no NAN entries
      D3DXMatrixIdentity(matTrans);
      matTrans._11 := GamePose[dofPanX];  matTrans._12 := 0;                  matTrans._13 := 0;
      matTrans._21 := 0;                  matTrans._22 := GamePose[dofPanY];  matTrans._23 := 0;
      matTrans._31 := 0;                  matTrans._32 := 0;                  matTrans._33 := GamePose[dofPanZ];

      D3DXMatrixRotationYawPitchRoll(matRot, ifthen(MyProfile.RelativeTrans[dofYaw], -GamePose[dofYaw], 0),
                                             ifthen(MyProfile.RelativeTrans[dofPitch], GamePose[dofPitch], 0),
                                             ifthen(MyProfile.RelativeTrans[dofRoll], -GamePose[dofRoll], 0));
      D3DXMatrixMultiply(matTrans, matTrans, matRot);

      if MyProfile.RelativeTrans[dofPanX] then GamePose[dofPanX] := matTrans._11 + matTrans._21 + matTrans._31;
      if MyProfile.RelativeTrans[dofPanY] then GamePose[dofPanY] := matTrans._12 + matTrans._22 + matTrans._32;
      if MyProfile.RelativeTrans[dofPanZ] then GamePose[dofPanZ]:= matTrans._13 + matTrans._23 + matTrans._33;
    end;

    //Ignore backward Z
    if MyProfile.IgnoreBackwardZ and (GamePose[dofPanZ] > 0) then
      GamePose[dofPanZ] := 0;

    // apply custom center and limit (response curve relative to custom center)
    for aDOF := Low(TDOF) to High(TDOF) do
      GamePose[aDOF] := Max(-ArrayResponseCfg[aDOF].Converted[RESP_MAX], Min(ArrayResponseCfg[aDOF].Converted[RESP_MAX], MyProfile.CustomCenter[aDOF] + GamePose[aDOF]));

    if Centering > 0 then
      Dec(Centering);

  end else if aCamManager.CamState = camPlaying then begin
    aFreeTrackTray.State := tsOn_HS;
    PoseDataOutput.KeyOutputRelease;
  end;

  {always update trackir data with old points to maintain data when points lost}

  if (aCamManager.CamSource = camWii) or (aCamManager.CamSource = camOptitrack)  then
    PoseDataOutput.UpdatePose(GamePose)
  else
    PoseDataOutput.InterpolatePose(GamePose, ListPoint.ReferenceClock);

end;



procedure TfmFreetrack.btCenterMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyControl[keyCenter].InternalState := True;
  ApplyCenter(Self);
end;


procedure TfmFreetrack.btCenterMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  KeyControl[keyCenter].InternalState := False;
end;


procedure TfmFreetrack.ApplyCenter(Sender : TObject);
var
  aDOF : TDOF;
begin
  for aDOF := Low(TDOF) to High(TDOF) do begin
    GamePose[aDOF] := MyProfile.CustomCenter[aDOF];
    PreviousGamePose[aDOF] := MyProfile.CustomCenter[aDOF];
  end;
  PoseDataOutput.CenterInterp;
  Centering := 1;

  // allow centering while webcam paused
  if (aCamManager.CamState <> camPlaying) or (aFreeTrackTray.State = tsOn_HS) then begin
    PoseDataOutput.UpdateOutput;
    Centering := 10; //ensure the first orientation is used as the center
  end;
end;


procedure TfmFreetrack.ManageKeyPress(Sender : TObject);
var
  pressed : array [TKeyControl] of boolean;
  aKey : TKeyControl;
  aDOF : TDOF;
  aOutput : TOutput;
  KeyPressed : Boolean;
  hWind, hControl : THandle;
  aPoint : TPoint;
begin

  // enable property page control on click (for cameras with disabled auto-exposure)
  if aCamManager.CameraPropertyOpen and ((DInput.MouseBut[0] and $80) > 0) then begin
    GetCursorPos(aPoint);
    hWind := WindowFromPoint(aPoint);

    if hWind <> 0 then begin
      Windows.ScreenToClient(hWind, aPoint);
      hControl := ChildWindowFromPoint(hWind, aPoint);
      if hControl <> 0 then
        EnableWindow(hControl, TRUE);
    end;
  end;

  // minimize when inactive
  if not aFreeTrackTray.Visible then
    if MyConfig.BinaryOptions[boptAutoMinimize] then begin
      if not Application.Active then
        Inc(InactiveCount)
      else
        InactiveCount := 0;

      if InactiveCount > 400 then     // roughly 20 seconds
        PostMessage(Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
    end;

  KeyPressed := False;
  DInput.ClearData;
  DInput.UpdateData;

  for aKey := Low(TKeyControl) to High(TKeyControl) do begin
    pressed[aKey] := False;
    case KeyControl[aKey].InputType of
      inputtypeKeyboard : begin
        pressed[aKey] := ((DInput.KeyBut[KeyControl[aKey].Key] and $80) > 0) and
        ((ifthen(ssCtrl in KeyControl[aKey].Shift, $80, 0) xor (DInput.KeyBut[DIK_LCONTROL] or DInput.KeyBut[DIK_RCONTROL])) = 0) and
        ((ifthen(ssShift in KeyControl[aKey].Shift, $80, 0) xor (DInput.KeyBut[DIK_LSHIFT] or DInput.KeyBut[DIK_RSHIFT])) = 0) and
        ((ifthen(ssAlt in KeyControl[aKey].Shift, $80, 0) xor (DInput.KeyBut[DIK_LALT] or DInput.KeyBut[DIK_RALT])) = 0);
      end;
      inputtypeMouse : pressed[aKey] := (DInput.MouseBut[KeyControl[aKey].Key] and $80) > 0;
      inputtypeController : pressed[aKey] := (DInput.ControllerBut[KeyControl[aKey].ControllerNum, KeyControl[aKey].Key] and $80) > 0;
    end;

    // double tap changes Toggle mode
    if not (aKey in [keyPause, keyCustomCenterSet, keyCustomCenterReset]) then begin
      if (pressed[aKey] and (KeyControl[aKey].InterPressCount > 0) and
                            (KeyControl[aKey].InterPressCount < 3) and
                            (KeyControl[aKey].PressCount < 3)) then begin
        PreventProfileDirtyStatus := True;
        ArraycbKeyControlToggle[aKey].Checked := not ArraycbKeyControlToggle[aKey].Checked;
        PreventProfileDirtyStatus := False;
        pressed[aKey] := False;
        KeyDblTapDelayCount := 0;
        KeyControl[aKey].InterPressCount := 8; // prevent a double tap retrigger
        if MyProfile.KeyControlsBeep[aKey] then
          MessageBeep(MB_ICONEXCLAMATION);
      end;
    end;

    // how long was last key pressed?
    if pressed[aKey] then begin
      keyPressed := True;
      if (KeyControl[aKey].InterPressCount > 0) then
        KeyControl[aKey].PressCount := 0 // reset when key first pressed
      else
        Inc(KeyControl[aKey].PressCount);
    end;

    // show which keys are being pressed
    if (KeyControl[aKey].InterPressCount = 0) and not KeyChanged then
      ArraybutKeyControl[aKey].Down := True
    else
      ArraybutKeyControl[aKey].Down := False;

    if (KeyDblTapDelayCount > 3) and not KeyChanged then
      // key down
      if (pressed[aKey] and (KeyControl[aKey].InterPressCount > 0))
        // key release
       or ((not MyProfile.KeyControlsToggle[aKey]) and (not pressed[aKey]) and (KeyControl[aKey].InterPressCount = 0)) then begin
        // beep on down
        if (MyProfile.KeyControlsBeep[aKey] and (KeyControl[aKey].InterPressCount > 0)) then
          MessageBeep(0);
        case aKey of
          keyPause: AlternatePlayPause(Self);

          keyCenter:
            if not KeyControl[aKey].InternalState then
              ApplyCenter(Self);

          keyCustomCenterSet: begin
            KeyControl[keyCustomCenterSet].InternalState := True;
            for aDOF := Low(TDOF) to High(TDOF) do
              MyProfile.CustomCenter[aDOF] := GamePose[aDOF];
          end;

          keyCustomCenterReset: begin
            KeyControl[keyCustomCenterSet].InternalState := False;
            for aDOF := Low(TDOF) to High(TDOF) do
              MyProfile.CustomCenter[aDOF] := 0;
          end;

          keySmoothStable:
            if KeyControl[aKey].InternalState then
              SmoothStableMultiplier := 1
            else
              SmoothStableMultiplier := MyProfile.SmoothStableMultiplier;

          keySmoothRaw:
            if KeyControl[aKey].InternalState then
              SmoothRawMultiplier := 1
            else
              SmoothRawMultiplier := 1 - 0.01 * MyProfile.SmoothRawMultiplier;

          keyYaw..keyPanZ: begin
            PreventProfileDirtyStatus := True;
            aDOF := TDOF(Ord(aKey) - 6);
            if ArraycombAxisMap[aDOF].ItemIndex <> 0 then
              ArraycombAxisMap[aDOF].ItemIndex := 0
            else
              ArraycombAxisMap[aDOF].ItemIndex := Ord(MyProfile.AxisMap[aDOF]) + 1;
            combAxisMapChange(ArraycombAxisMap[aDOF]);
            PreventProfileDirtyStatus := False;
          end;
          
          keyFreetrack..keySimConnect: begin
            PreventProfileDirtyStatus := True; // don't register as a profile change
            aOutput := TOutput(Ord(aKey) - 12);
            if PoseDataOutput.ArraycbOutput[aOutput].Enabled then
              PoseDataOutput.ArraycbOutput[aOutput].Checked := not PoseDataOutput.ArraycbOutput[aOutput].Checked;
            PreventProfileDirtyStatus := False;
          end;
        end;
        if aKey <> keyCustomCenterSet then
          KeyControl[aKey].InternalState := not KeyControl[aKey].InternalState;
      end;

    if not pressed[aKey] then
      Inc(KeyControl[aKey].InterPressCount)
    else
      KeyControl[aKey].InterPressCount := 0;

  end;

  // don't trigger if any key still held after mapping
  if KeyChanged and not keyPressed then
    KeyChanged := False;

  Inc(KeyDblTapDelayCount);

  //HMI Update
  PostMessage(Handle, WM_UIDATA, 0, 0);
end;


procedure TfmFreetrack.butStartClick(Sender: TObject);
begin

  if (aCamManager.CamSource = camDemo) and (aCamManager.CamState = camStopped) then
    Centering := 10;

  case aCamManager.CamState of
    camStopped, camPaused : begin
      aCamManager.OnLedDetected := GestOnLedDetected;
      if aCamManager.Play then begin

        // no DSEvent when paused graph is resumed
        if aCamManager.CamSource = camVid then
          ForceCamProp.ForceProperties;

        butStart.Caption := DKLangConstW('S_STOP');
        aFreeTrackTray.MenuCaption := S_STOP;
        butStart.PngImage := imlistStartStop.PngImages.Items[1].PngImage;

        NoSmoothingDelay := 3;
        if HeadPanel <> nil then HeadPanel.Visible := True;
        GestStateChanged(Self, True);
      end;
    end;

    camPlaying : begin
      aCamManager.OnLedDetected := nil;
      aCamManager.Stop;
      sleep(40);
      PoseDataOutput.Stop;

      butStart.Caption := DKLangConstW('S_START');
      aFreeTrackTray.MenuCaption := S_START;
      butStart.PngImage := imlistStartStop.PngImages.Items[0].PngImage;

      if HeadPanel <> nil then HeadPanel.Visible := False;

      previousNumPoints := 0;
      ScreenNumberPoints := 0;
      GestStateChanged(Self, False);
    end;
  end;
end;


procedure TfmFreetrack.AlternatePlayPause(Sender: TObject);
begin
  case aCamManager.CamState of
    camStopped : butStartClick(Self);
    camPaused : butStartClick(Self);
    camPlaying : begin
      aCamManager.Pause;
      PoseDataOutput.KeyOutputRelease;
      butStart.Caption := DKLangConstW('S_RESUME');
      aFreeTrackTray.MenuCaption := S_RESUME;
      butStart.PngImage := imlistStartStop.PngImages.Items[0].PngImage;
      GestStateChanged(Self, False);
    end;
  end;
end;


procedure TfmFreetrack.UpdateUIData;
var
  i : Integer;
  aDOF : TDOF;
begin
  for i := Low(ScreenPoints) to High(ScreenPoints) do begin
    ArrayLaImgA[i].Caption := format('%.1f,', [ScreenPoints[i].X]);
    ArrayLaImgB[i].Caption := format('%.1f', [ScreenPoints[i].Y]);
  end;

  for aDOF := Low(TDOF) to High(TDOF) do begin
    if aDOF in [dofYaw, dofPitch, dofRoll] then ArrayLabelPose[aDOF].Caption := format('%.2f', [RadToDeg(GamePose[aDOF])]);
    if aDOF in [dofPanX, dofPanY, dofPanZ] then ArrayLabelPose[aDOF].Caption := format('%.2f', [GamePose[aDOF] * TRANS_PI_RANGE]);
    ArrayLabelPoseDZ[aDOF].Caption := format('%.1f', [SmoothingSize[aDOF]]);
    laKeyOutput.Caption := PoseDataOutput.PressedKeys;
  end;

  laSmoothingMultiplier.Caption := format('%.1f', [ZoomMultiplier * SmoothStableMultiplier * SmoothRawMultiplier]);

  if (ZoomMultiplier * SmoothStableMultiplier * SmoothRawMultiplier) > 1.05 then
    laSmoothingMultiplier.Color := clYellow
  else if (ZoomMultiplier * SmoothStableMultiplier * SmoothRawMultiplier) < 0.999 then
    laSmoothingMultiplier.Color := clAqua
  else
    laSmoothingMultiplier.Color := clBtnFace;

  laSmoothStable.Enabled := KeyControl[keySmoothStable].InternalState;
  laSmoothRaw.Enabled := KeyControl[keySmoothRaw].InternalState;
  laCenter.Enabled := KeyControl[keyCenter].InternalState;
  laCustomCenter.Enabled := KeyControl[keyCustomCenterSet].InternalState;

  lah1h2.Caption := format('%1f %1f ',[h1h2[0], h1h2[1]]);
  if (h1h2[0] = 999) or (h1h2[1] = 999) then
    lah1h2.Color := clRed
  else
    lah1h2.Color := clBtnFace;

  if aCamManager.camState = camPlaying then
    aCamManager.UpdateUIData(ScreenFPS, AvgJitterCount, ScreenNumberPoints);

  // number of visible points graphic
  if (previousNumPoints <> ScreenNumberPoints) or (previousTrackMethod <> MyConfig.TrackingMethod) then begin
    if ScreenNumberPoints = TRACKING_NUMBER_OF_POINTS[MyConfig.TrackingMethod] then
      for  i := 0 to (ScreenNumberPoints - 1) do ArrayimPoint[i].Picture.Graphic := imlistPointState.PngImages.Items[2].PngImage // locked
    else
      for i := 0 to (ScreenNumberPoints - 1) do ArrayimPoint[i].Picture.Graphic := imlistPointState.PngImages.Items[1].PngImage;    // not locked

    if previousNumPoints <= 5 then
      for i := ScreenNumberPoints to (previousNumPoints - 1) do
        ArrayimPoint[i].Picture.Graphic := imlistPointState.PngImages.Items[0].PngImage; // grey

    previousNumPoints := ScreenNumberPoints;
    previousTrackMethod := MyConfig.TrackingMethod;
  end;

  if cbDebug.Checked then
  {Memo1.Lines.Add(format('%s   =  %.3f    %.3f    %.3f', [s, RadToDeg(PoseParams.Yaw),
                                                          RadToDeg(PoseParams.Pitch),
                                                          RadToDeg(PoseParams.Roll)]));}
end;



procedure TfmFreetrack.GestStateChanged(Sender: TObject; isRunning: Boolean);
var
  i : Integer;
begin
  if isRunning then begin
    aFreeTrackTray.State := tsOn_HS;
    previousNumPoints := 0;
  end else begin
    aFreeTrackTray.State := tsOff;
    AvgJitterCount := 0;
    for i := 0 to 4 do
      ArrayimPoint[i].Picture.Graphic := imlistPointState.PngImages.Items[0].PngImage;
  end;
end;



procedure TfmFreetrack.tbSensitivityChange(Sender: TObject);
var
  aDOF : TDOF;
begin
  for aDOF := low(TDOF) to High(TDOF) do begin
    if (Sender = ArrayTbSensitivity[aDOF]) then begin
      MyProfile.Sensitivity[aDOF] := (ArrayTbSensitivity[aDOF].Position * SENSITIVITY_MAX)/ArrayTbSensitivity[aDOF].Max;
      ArrayLaSensitivity[aDOF].Caption := format('%.1f', [MyProfile.Sensitivity[aDOF]]);
      Break;
    end;
  end;
  ProfileDirty;
end;


procedure TfmFreetrack.tbSmoothingChange(Sender: TObject);
var
  aDOF : TDOF;
begin
  for aDOF := low(TDOF) to High(TDOF) do begin
    if (Sender = ArrayTbSmoothing[aDOF]) then begin
      MyProfile.Smoothing[aDOF] := ArrayTbSmoothing[aDOF].Position;
      ArrayLaSmoothing[aDOF].Caption := format('%d', [ArrayTbSmoothing[aDOF].Position]);
      Break;
    end;
  end;
  ProfileDirty;
end;



procedure TfmFreetrack.tbSmoothingZoomingChange(Sender: TObject);
begin
  MyProfile.SmoothingZooming := tbSmoothingZooming.Position;
  laSmoothingZooming.Caption := format('%d', [tbSmoothingZooming.Position]);
  ProfileDirty;
end;


procedure TfmFreetrack.tbDynamicSmoothingChange(Sender: TObject);
begin
  DynamicSmoothing := round(power(3, 0.25 * (41 - tbDynamicSmoothing.Position)));
  MyProfile.DynamicSmoothing := tbDynamicSmoothing.Position;
  laDynamicSmoothing.Caption := format('%d', [tbDynamicSmoothing.Position]);
  ProfileDirty;
end;



procedure TfmFreetrack.cbInvertClick(Sender: TObject);
var
  aAxle : TDOF;
begin
  for aAxle := low(TDOF) to High(TDOF) do
    if (Sender = ArrayCbInverts[aAxle]) then begin
      MyProfile.Inverts[aAxle] := (Sender as TCheckBox).Checked;
      Break;
    end;
  ProfileDirty;
end;



procedure TfmFreetrack.tbGlobalSensitivityChange(Sender: TObject);
var
  aDOF : TDOF;
begin
  for aDOF := low(TDOF) to High(TDOF) do begin
    if (Sender = ArrayTbGlobalSensitivity[aDOF]) then begin
      MyConfig.GlobalSensitivity[aDOF] := (ArrayTbGlobalSensitivity[aDOF].Position * SENSITIVITY_MAX)/ArrayTbGlobalSensitivity[aDOF].Max;
      ArrayLaGlobalSensitivity[aDOF].Caption := format('%.1f', [MyConfig.GlobalSensitivity[aDOF]]);
      Break;
    end;
  end;
end;


procedure TfmFreetrack.tbGlobalSmoothingChange(Sender: TObject);
var
  aDOF : TDOF;
begin
  for aDOF := low(TDOF) to High(TDOF) do begin
    if (Sender = ArrayTbGlobalSmoothing[aDOF]) then begin
      Myconfig.GlobalSmoothing[aDOF] := ArrayTbGlobalSmoothing[aDOF].Position;
      ArrayLaGlobalSmoothing[aDOF].Caption := format('%d', [ArrayTbGlobalSmoothing[aDOF].Position]);
      Break;
    end;
  end;
end;

procedure TfmFreetrack.tbGlobalSmoothingZoomingChange(Sender: TObject);
begin
  MyConfig.GlobalSmoothingZooming := tbGlobalSmoothingZooming.Position;
  laGlobalSmoothingZooming.Caption := format('%d', [tbGlobalSmoothingZooming.Position]);
end;



procedure TfmFreetrack.cbGlobalInvertClick(Sender: TObject);
var
  aAxle : TDOF;
begin
  for aAxle := low(TDOF) to High(TDOF) do
    if (Sender = ArrayCbGlobalInverts[aAxle]) then begin
      MyConfig.GlobalInverts[aAxle] := (Sender as TCheckBox).Checked;
      Break;
    end;
end;




procedure TfmFreetrack.sbTrackingMethodClick(Sender: TObject);
var
  aDOF : TDOF;
  butIndex, i : Integer;
begin


  for butIndex := 0 to 3 do
    if Sender = ArraysbTrack[butIndex] then begin
      MyConfig.TrackingMethod := TTrackingMethod(butIndex);
      Break;
    end;

  // clear
  for i := 0 to 3 do begin
    ScreenPoints[i].x := 0;
    ScreenPoints[i].y := 0;
  end;

  // center view
  Centering := 10;

  // Model position - x and y negative to swap trackbar direction around
  tbRotOffsetX.Position := -MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanX];
  tbRotOffsetY.Position := MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanY];
  tbRotOffsetZ.Position := -MyConfig.RotOffset[MyConfig.TrackingMethod, dofPanZ];

  tbRotOffsetChange(tbRotOffsetX);
  tbRotOffsetChange(tbRotOffsetY);
  tbRotOffsetChange(tbRotOffsetZ);

  case MyConfig.TrackingMethod of
    tmSinglePoint: begin
      for aDOF := Low(TDOF) to High(TDOF) do
        MyConfig.Center[aDOF] := 0;
      pcTrackMethod.ActivePageIndex := Ord(tmSinglePoint);
      imTrack.Picture.Graphic := imListTrack.PngImages.Items[0].PngImage;
      paRotOffsetCalibration.Visible := False;
      Exit;
    end;

    tmThreePointClip: begin
      pcTrackMethod.ActivePageIndex := Ord(tmThreePointClip);
      imTrack.Picture.Graphic := imListTrack.PngImages.Items[1].PngImage;
      MyPoseObj.Initialize3PClipModel(MyConfig.Dimensions3PtsClip);
      paRotOffsetCalibration.Visible := True;
      Exit;
    end;

    tmThreePointCap: begin
      pcTrackMethod.ActivePageIndex := Ord(tmThreePointCap);
      imTrack.Picture.Graphic := imListTrack.PngImages.Items[2].PngImage;
      MyPoseObj.Initialize3PCapModel(MyConfig.Dimensions3PtsCap);
      paRotOffsetCalibration.Visible := True;
      Exit;
    end;

    tmFourPoint: begin
      pcTrackMethod.ActivePageIndex := Ord(tmFourPoint);
      imTrack.Picture.Graphic := imListTrack.PngImages.Items[3].PngImage;
      MyPoseObj.Initialize4PModel(MyConfig.Dimensions4Pts);
      paRotOffsetCalibration.Visible := True;
      Exit;
    end;
  end;
end;



procedure TfmFreetrack.tbRotOffsetChange(Sender: TObject);
var
  aDOF : TDOF;
begin
  for aDOF := Low(TDOF) to High(TDOF) do
    if Sender = ArraytbRotOffset[aDOF] then begin
      MyConfig.RotOffset[MyConfig.TrackingMethod, aDOF] :=  ifthen(aDOF in [dofPanX, dofPanZ], -1, 1) * ArraytbRotOffset[aDOF].Position;
      ArraylaRotOffset[aDOF].Caption := format('%d', [MyConfig.RotOffset[MyConfig.TrackingMethod, aDOF]]);
      Exit;
    end;
end;



procedure TfmFreetrack.tbAverageChange(Sender: TObject);
begin
  MyProfile.Average := tbAverage.Position;
  laAverage.Caption := format('%d' + '%%', [tbAverage.Position]);
  ProfileDirty;
end;



procedure TfmFreetrack.but3pClipApplyClick(Sender: TObject);
var
  valid : Boolean;
begin
  Valid := True;
  if (StrtoInt(ed3PClipz1.text) < 1) then begin
    ed3PClipz1.text := InttoStr(round(MyConfig.Dimensions3PtsClip[0].z));
    ed3PClipz1.SetFocus;
    Valid := False;
  end else if (StrtoInt(ed3PClipz2.text) < 1) then begin
    ed3PClipz2.text := InttoStr(round(MyConfig.Dimensions3PtsClip[1].z));
    ed3PClipz2.SetFocus;
    Valid := False;
  end else if (StrtoInt(ed3PClipy1.text) < 1) then begin
    ed3PClipy1.text := InttoStr(round(MyConfig.Dimensions3PtsClip[0].y));
    ed3PClipy1.SetFocus;
    Valid := False;
  end else if (StrtoInt(ed3PClipy2.text) < 1) then begin
    ed3PClipy2.text := InttoStr(round(MyConfig.Dimensions3PtsClip[1].y));
    ed3PClipy2.SetFocus;
    Valid := False;
  end;

  if Valid then begin
    MyConfig.Dimensions3PtsClip[0].z := StrtoInt(ed3PClipz1.text);
    MyConfig.Dimensions3PtsClip[1].z := StrtoInt(ed3PClipz2.text);
    MyConfig.Dimensions3PtsClip[0].y := StrtoInt(ed3PClipy1.text);
    MyConfig.Dimensions3PtsClip[1].y := StrtoInt(ed3PClipy2.text);
    MyPoseObj.Initialize3PClipModel(MyConfig.Dimensions3PtsClip);
    but3pClipApply.Enabled := False;
  end else begin
    beep;
    MessageDlg(DKLangConstW('S_ERROR_MODEL_ZERO'), mtError, [mbOK], 0);
  end;
end;



procedure TfmFreetrack.but3pCapApplyClick(Sender: TObject);
var
  Valid : Boolean;
begin
  Valid := True;
  if  (StrtoInt(ed3PCapx.text) < 1) then begin
    ed3PCapx.text := InttoStr(round(MyConfig.Dimensions3PtsCap[0].x));
    ed3PCapx.SetFocus;
    Valid := False;
  end else if (StrtoInt(ed3PCapy.text) < 1) then begin
    ed3PCapy.text := InttoStr(round(MyConfig.Dimensions3PtsCap[0].y));
    ed3PCapy.SetFocus;
    Valid := False;
  end else if (StrtoInt(ed3PCapz.text) < 1) then begin
    ed3PCapz.text := InttoStr(round(MyConfig.Dimensions3PtsCap[0].z));
    ed3PCapz.SetFocus;
    Valid := False;
  end;

  if StrtoInt(ed3PCapz.text) < StrtoInt(ed3PCapy.text) then
    MessageDlg(DKLangConstW('S_WARNING_MODEL_3P_PITCH'), mtWarning, [mbOK], 0);
  if StrtoInt(ed3PCapx.text) > 1.2 * StrtoInt(ed3PCapz.text) then
    MessageDlg(DKLangConstW('S_WARNING_MODEL_3P_YAW'), mtWarning, [mbOK], 0);

  if Valid then begin
    MyConfig.Dimensions3PtsCap[0].x := StrtoInt(ed3PCapx.text);
    MyConfig.Dimensions3PtsCap[0].y := StrtoInt(ed3PCapy.text); 
    MyConfig.Dimensions3PtsCap[0].z := StrtoInt(ed3PCapz.text);
    MyPoseObj.Initialize3PCapModel(MyConfig.Dimensions3PtsCap);
    but3pCapApply.Enabled := False;
  end else begin
    beep;
    MessageDlg(DKLangConstW('S_ERROR_MODEL_ZERO'), mtError, [mbOK], 0);
  end;
end;



procedure TfmFreetrack.but4pCapApplyClick(Sender: TObject);
var
  Valid : Boolean;
begin
  Valid := True;
  if  (StrtoInt(ed4Px1.text) < 1) then begin
    ed4Px1.text := InttoStr(round(MyConfig.Dimensions4Pts[1].x));
    ed4Px1.SetFocus;
    Valid := False;
  end else if (StrtoInt(ed4Py1.text) < 1) then begin
    ed4Py1.text := InttoStr(round(MyConfig.Dimensions4Pts[1].y));
    ed4Py1.SetFocus;
    Valid := False;
  end else if (StrtoInt(ed4Pz1.text) < 1) then begin
    ed4Pz1.text := InttoStr(round(MyConfig.Dimensions4Pts[1].z));
    ed4Pz1.SetFocus;
    Valid := False;
  end else if (StrtoInt(ed4Py2.text) < 1) then begin
    ed4Py2.text := InttoStr(round(MyConfig.Dimensions4Pts[2].y));
    ed4Py2.SetFocus;
    Valid := False;
  end else if (StrtoInt(ed4Pz2.text) < 1) then begin
    ed4Pz2.text := InttoStr(round(MyConfig.Dimensions4Pts[2].z));
    ed4Pz2.SetFocus;
    Valid := False;
  end;

  if Valid then begin
    // model dimensions ensure coplanar is impossible as long as all dimensions > 0
    MyConfig.Dimensions4Pts[1].x := StrtoInt(ed4Px1.text);
    MyConfig.Dimensions4Pts[1].y := StrtoInt(ed4Py1.text);
    MyConfig.Dimensions4Pts[1].z := StrtoInt(ed4Pz1.text);
    MyConfig.Dimensions4Pts[2].y := StrtoInt(ed4Py2.text);
    MyConfig.Dimensions4Pts[2].z := StrtoInt(ed4Pz2.text);
    MyPoseObj.Initialize4PModel(MyConfig.Dimensions4Pts);
    but4pCapApply.Enabled := False;
  end else begin
    beep;
    MessageDlg(DKLangConstW('S_ERROR_MODEL_ZERO'), mtError, [mbOK], 0);
  end;
end;



procedure TfmFreetrack.GestSaveProfile(Sender: TObject; aINI: TIniFile);
begin

  YawCfg.SaveCfgToIni(MyProfile.ResponseCurves[dofYaw]);
  PitchCfg.SaveCfgToIni(MyProfile.ResponseCurves[dofPitch]);
  RollCfg.SaveCfgToIni(MyProfile.ResponseCurves[dofRoll]);

  PanXCfg.SaveCfgToIni(MyProfile.ResponseCurves[dofPanX]);
  PanYCfg.SaveCfgToIni(MyProfile.ResponseCurves[dofPanY]);
  PanZCfg.SaveCfgToIni(MyProfile.ResponseCurves[dofPanZ]);

  MyProfile.SaveParamsToIni(aIni);

  RefreshFormTitle;
end;


procedure TfmFreetrack.GestProfileSelected(Sender: TObject; aINI: TIniFile);
begin
  MyProfile.ReadParamsFromIni(aIni);
  MyConfig.ProfileFilename := aIni.Filename;
  GUILoadProfile;
end;


procedure TfmFreetrack.LoadProfiles;
var
  aIni : TIniFile;
begin
  aIni := TIniFile.Create(rootDirectory  + 'Freetrack.ini');
  ProfilesMngr.LoadFromFile(aIni, rootDirectory  + 'Profiles', ChangeFileExt(ExtractFilename(MyConfig.ProfileFilename), ''));
  aIni.Free;
end;


procedure TfmFreetrack.GestDefaultRequired(Sender: TObject; aINI: TIniFile);
var
  aProfile: TProfile;
begin
  aProfile := TProfile.Create(aIni);  //read default values in the blank file
  aProfile.ReadParamsFromIni(aIni);

  PreventProfileDirtyStatus := True;
  YawCfg.LoadDefaultCurve(curveLinear);
  PitchCfg.LoadDefaultCurve(curveLinear);
  RollCfg.LoadDefaultCurve(curveLinear);

  PanXCfg.LoadDefaultCurve(curveLinear);
  PanYCfg.LoadDefaultCurve(curveLinear);
  PanZCfg.LoadDefaultCurve(curveLinear);
  PreventProfileDirtyStatus := False;

  YawCfg.SaveCfgToIni(aProfile.ResponseCurves[dofYaw]);
  PitchCfg.SaveCfgToIni(aProfile.ResponseCurves[dofPitch]);
  RollCfg.SaveCfgToIni(aProfile.ResponseCurves[dofRoll]);

  PanXCfg.SaveCfgToIni(aProfile.ResponseCurves[dofPanX]);
  PanYCfg.SaveCfgToIni(aProfile.ResponseCurves[dofPanY]);
  PanZCfg.SaveCfgToIni(aProfile.ResponseCurves[dofPanZ]);

  aProfile.SaveParamsToIni(aINI);
  aProfile.Free;
end;



procedure TfmFreetrack.butRefreshProfileListClick(Sender: TObject);
var
  configIni : TIniFile;
begin
  configIni := TIniFile.Create(rootDirectory + 'Freetrack.ini');
  try
    ProfilesMngr.SaveToFile(configIni);
  finally
    configIni.Free;
  end;
  LoadProfiles;
end;

procedure TfmFreetrack.butNewProfileClick(Sender : TObject);
begin
  ProfilesMngr.butNewProfileClick(rootDirectory + 'Profiles\');
end;


procedure TfmFreetrack.ProfileDirty;
begin
  if not PreventProfileDirtyStatus then begin
    ProfilesMngr.ProfileIsDirty := True;
    RefreshFormTitle;
  end;
end;


procedure TfmFreetrack.butRotOffsetDefaultClick(Sender: TObject);
begin
  // x and y trackbar directions reversed
  tbRotOffsetX.Position := -RotOffsetDefault[MyConfig.TrackingMethod, dofPanX];
  tbRotOffsetY.Position := RotOffsetDefault[MyConfig.TrackingMethod, dofPanY];
  tbRotOffsetZ.Position := -RotOffsetDefault[MyConfig.TrackingMethod, dofPanZ];
end;


procedure TfmFreetrack.combViewChange(Sender: TObject);
begin
  if (HeadPanel <> nil) then
    if (Sender = combView) then begin

      case combView.ItemIndex of
        0 : HeadPanel.ChangePerspective(pFront);
        1 : HeadPanel.ChangePerspective(pTop);
        2 : HeadPanel.ChangePerspective(pSide);
        3 : HeadPanel.ChangePerspective(pFirstPerson);
      end;

      cbZooming.Enabled :=  combView.ItemIndex = 3;
    end else if (Sender = cbZooming) then
      HeadPanel.Zooming := cbZooming.Checked;

end;


procedure TfmFreetrack.sbPageChange(Sender: TObject);
var
  butIndex : Integer;
begin
  for butIndex := 0 to 8 do begin
    if (Sender = ArraysbPage[butIndex]) then begin
      case butIndex of
        0 : begin
          aCamManager.SetVisible(True);
          aCamManager.PageControl1.TabIndex := 0;
        end;
        1 : PageControl3.TabIndex := 0;
        2 : PoseDataOutput.PageControl1.TabIndex := 0;
        4 : PageControl1.SetFocus;
      end;
      PageControl1.ActivePageIndex := butIndex;
      Break;
    end;
  end;
  TimertbTicks.Enabled := True;
end;



function TfmFreetrack.CheckInstance(filename : String) : Boolean;
var
  hSem : THandle;
begin
  // create sémaphore.
  hSem := CreateSemaphore(nil, 0, 1, PChar(filename));

  // Already exist ?
  if (hSem <> 0) and (GetLastError = ERROR_ALREADY_EXISTS) then begin
    CloseHandle(hSem);
    Result := True;
  end else
    Result := False;
end;




procedure TfmFreetrack.cbKeyBeepClick(Sender: TObject);
var
  aKey : TKeyControl;
begin
  for aKey := Low(TKeyControl) to High(TKeyControl) do
    if Sender = ArraycbKeyControlBeep[aKey] then begin
      MyProfile.KeyControlsBeep[aKey] := ArraycbKeyControlBeep[aKey].Checked;
      Break;
    end;
  ProfileDirty;
end;



procedure TfmFreetrack.GestResponseChanged(Sender : TObject);
var
  aDOF : TDOF;
begin
  ProfileDirty;
  for aDOF := Low(TDOF) to High(TDOF) do begin
    PoseDataOutput.RespMax[aDOF] := ArrayResponseCfg[aDOF].Converted[RESP_MAX];
    if HeadPanel <> nil then
      HeadPanel.RespMax[aDOF] := ArrayResponseCfg[aDOF].Converted[RESP_MAX];
  end;

end;



procedure TfmFreetrack.popHeadAids(Sender: TObject);
var
  aHeadAid : THeadAids;
begin
  for aHeadAid := Low(THeadAids) to High(THeadAids) do begin
    if PopHead.Items.Items[Ord(aHeadAid)].Checked then
      MyConfig.HeadAids[aHeadAid] := True
    else
      MyConfig.HeadAids[aHeadAid] := False;
    if HeadPanel <> nil then HeadPanel.HeadAids[aHeadAid] := MyConfig.HeadAids[aHeadAid];
  end;
  if PopHead.Items.Items[Ord(aidAxes)].Checked = False then begin
    PopHead.Items.Items[Ord(aidLabels)].Checked := False;
    MyConfig.HeadAids[aidLabels] := False;
    if HeadPanel <> nil then HeadPanel.HeadAids[aidLabels] := MyConfig.HeadAids[aidLabels];
    PopHead.Items.Items[Ord(aidLabels)].Enabled := False;
  end else PopHead.Items.Items[Ord(aidLabels)].Enabled := True;
end;




procedure TfmFreetrack.editEnterKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin  // enter
    Key := #0;  // eat key

    // cycle around dimension edit boxes
    if ed3PClipz1.Focused then ed3PClipy1.SetFocus
    else if ed3PClipy1.Focused then ed3PClipy2.SetFocus
    else if ed3PClipy2.Focused then ed3PClipz2.SetFocus
    else if ed3PClipz2.Focused then ed3PClipz1.SetFocus;

    if ed3PCapy.Focused then ed3PCapz.SetFocus
    else if ed3PCapz.Focused then ed3PCapx.SetFocus
    else if ed3PCapx.Focused then ed3PCapy.SetFocus;

    if ed4Pz1.Focused then ed4Py1.SetFocus
    else if ed4Py1.Focused then ed4Py2.SetFocus
    else if ed4Py2.Focused then ed4Pz2.SetFocus
    else if ed4Pz2.Focused then ed4Px1.SetFocus
    else if ed4Px1.Focused then ed4Pz1.SetFocus;
  end
end;


procedure TfmFreetrack.GestOnMinimize(Sender: TObject);
begin
  FreeandNil(HeadPanel);
  aCamManager.SetVisible(False);
  PoseDataOutput.PressedUITimer.Enabled := False;
end;


procedure TfmFreetrack.GestOnRestore(Sender: TObject);
var
  aHeadAid : THeadAids;
begin
  InactiveCount := 0;

  // low resolution display can change form constraints
  fmFreetrack.Constraints.MinHeight := 564;
  fmFreetrack.Constraints.MinWidth := 812;

  PageControl1.Constraints.MinHeight := 427;
  PageControl1.Height := 427;

  Panel8.Constraints.MinWidth := 400;
  Panel8.Width := 400;

  aCamManager.SetVisible(True);
  aCamManager.Align := alClient;

  PoseDataOutput.PressedUITimer.Enabled := True;

  // create and initialize 3d scene
  HeadPanel := THeadDisplay.Create(paHead);
  if (aCamManager.CamState = camStopped) then
    HeadPanel.Visible := False;
  PreventProfileDirtyStatus := True;
  GestResponseChanged(Self);
  PreventProfileDirtyStatus := False;
  combViewChange(combView);
  combViewChange(cbZooming);
  HeadPanel.RestoreAttitude(  GamePose[dofYaw],
                              GamePose[dofPitch],
                              GamePose[dofRoll],
                              GamePose[dofPanX],
                              GamePose[dofPanY],
                              GamePose[dofPanZ]);
  for aHeadAid := Low(THeadAids) to High(THeadAids) do begin
    if MyConfig.HeadAids[aHeadAid] then PopHead.Items.Items[Ord(aHeadAid)].Checked := True;
    if HeadPanel <> nil then HeadPanel.HeadAids[aHeadAid] := MyConfig.HeadAids[aHeadAid];
  end;
end;

procedure TfmFreetrack.DefaultHandler(var Message);
var
  i : Integer;
begin
  inherited;

  // receive program id report
  if PoseDataOutput <> nil then begin
    if TMessage(Message).Msg = PoseDataOutput.OnProgramID then
      if ProfilesMngr.AutoLoadProfile(TMessage(Message).WParam, PoseDataOutput.ProgramName) and
          MyConfig.BinaryOptions[boptAutoMinimize] then
        PostMessage(Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
    // monitor trackir enabled applications running
    if TMessage(Message).Msg = PoseDataOutput.OnRegisterProgramhandle then begin
      HostList.Add(THostApp.Create(TMessage(Message).WParam));
      aFreeTrackTray.HostAppRunning := True;
    end;
    if TMessage(Message).Msg = PoseDataOutput.OnUnRegisterProgramhandle then begin
      i := 0;
      while i < HostList.Count do
        if THostApp(HostList.Items[i]).Handle = TMessage(Message).WParam then
          HostList.Delete(i)
        else
          Inc(i);
      if HostList.Count = 0 then
        aFreeTrackTray.HostAppRunning := False;
    end;
  end;

  // restore trayicon on explorer restart
  if TMessage(Message).Msg = OnTaskBarCreated then begin
    aFreeTrackTray := TFreeTrackTray.Create(Self);
    aFreeTrackTray.OnRestore := GestOnRestore;
    aFreeTrackTray.OnMinimize := GestOnMinimize;
    if not Application.ShowMainForm then
      aFreeTrackTray.Visible := True;
  end;

end;


procedure TfmFreetrack.tbSmoothStableChange(Sender: TObject);
begin
  if KeyControl[keySmoothStable].InternalState then
    SmoothStableMultiplier := tbSmoothStable.Position;
  MyProfile.SmoothStableMultiplier := tbSmoothStable.Position;
end;

procedure TfmFreetrack.tbSmoothRawChange(Sender: TObject);
begin
  if KeyControl[keySmoothRaw].InternalState then
    SmoothRawMultiplier := 1 -  0.01 * tbSmoothRaw.Position;
  MyProfile.SmoothRawMultiplier := tbSmoothRaw.Position;
end;


procedure TfmFreetrack.cbKeyToggleClick(Sender: TObject);
var
  aKey : TKeyControl;
begin
  for aKey := Low(TKeyControl) to High(TKeyControl) do
    if Sender = ArraycbKeyControlToggle[aKey] then begin
      MyProfile.KeyControlsToggle[aKey] := ArraycbKeyControlToggle[aKey].Checked;


      // default off for toggling
      {if not MyProfile.KeyControlsToggle[aKey] then
        case aKey of
          keyCenter : CenterHeld := False;
          keyPause : begin
            aCamManager.Pause;
            butStartClick(Self);
          end;
          keySmoothStable : begin
            SmoothStableState := False;
            SmoothStableMultiplier := 1;
          end;
          keySmoothRaw : begin
            SmoothRawState := False;
            SmoothRawMultiplier := 1;
          end;
          keyYaw..keyPanZ : begin
            aDOF := TDOF(Ord(aKey) - 6);
            // alternate between off and chosen axis
            if ArraycombAxisMap[aDOF].ItemIndex <> 0 then
              ArraycombAxisMap[aDOF].ItemIndex := 0
            else
              ArraycombAxisMap[aDOF].ItemIndex := Ord(MyProfile.AxisMap[aDOF]) + 1;
            combAxisMapChange(Self);
          end;
          keyFreetrack..keyKeyOutput : begin
            aOutput := TOutput(Ord(aKey) - 12);
            PoseDataOutput.ArraycbOutput[aOutput].Checked := not ArraycbKeyControlToggle[aKey].Checked;
          end;
        end; }
      Exit;
    end;
  ProfileDirty;
end;



procedure TfmFreetrack.cbAutoCenteringClick(Sender: TObject);
begin
  MyConfig.AutoCentering := cbAutoCentering.Checked;
end;


procedure TfmFreetrack.tbAutoCenteringSpeedChange(Sender: TObject);
begin
  laAutoCenteringSpeed.Caption := InttoStr(tbAutoCenteringSpeed.Position);
  MyConfig.AutoCenteringSpeed := tbAutoCenteringSpeed.Position;
end;


{procedure TfmFreetrack.DisplayInterp(var MSG : TMessage);
begin
  //Memo1.Lines.Add(format('%d  %.5f   %d', [current_interp, (CurHPCount - PrevHPCount)/HPFrequency, ifthen(((CurHPCount - PrevHPCount)/HPFrequency) > 0.015, 22222222222222, 0)]));
  //Memo1.Lines.Add(format('ScreenFPS %d', [ScreenFPS]));
  //Memo1.Lines.Add(format('MOUSEWHEEL %d', [simulatedInput.mi.mousedata]));

  //Memo1.Lines.Add(format('X: %d  Y: %d  Z: %d', [FSPosition.X, FSPosition.Y, FSPosition.Z]));

  //PrevHPCount := CurHPCount;
end;    }


procedure TfmFreetrack.popCurveClick(Sender: TObject);
var
  aDOF : TDOF;
begin
  case (Sender as TMenuItem).Parent.MenuIndex of
    -1 : (PopCurve.PopupComponent as TResponseCfg).LoadDefaultCurve(TDefaultCurves((Sender as TMenuItem).MenuIndex));
    2 : (PopCurve.PopupComponent as TResponseCfg).LoadDefaultCurve(TDefaultCurves((Sender as TMenuItem).MenuIndex + 2));
    3 : (PopCurve.PopupComponent as TResponseCfg).LoadDefaultCurve(TDefaultCurves((Sender as TMenuItem).MenuIndex + 5));
    4 : begin
      if (PopCurve.PopupComponent as TResponseCfg) = YawCfg then aDOF := dofYaw
      else if (PopCurve.PopupComponent as TResponseCfg) = PitchCfg then aDOF := dofPitch
      else if (PopCurve.PopupComponent as TResponseCfg) = RollCfg then aDOF := dofRoll
      else if (PopCurve.PopupComponent as TResponseCfg) = PanXCfg then aDOF := dofPanX
      else if (PopCurve.PopupComponent as TResponseCfg) = PanYCfg then aDOF := dofPanY
      else if (PopCurve.PopupComponent as TResponseCfg) = PanZCfg then aDOF := dofPanZ;

      (PopCurve.PopupComponent as TResponseCfg).GetPoints(MyProfile.ResponseCurves[aDOF]);

      case (Sender as TMenuItem).MenuIndex of
        0 : YawCfg.LoadCfgFromIni(MyProfile.ResponseCurves[aDOF]);
        1 : PitchCfg.LoadCfgFromIni(MyProfile.ResponseCurves[aDOF]);
        2 : RollCfg.LoadCfgFromIni(MyProfile.ResponseCurves[aDOF]);
        3 : PanXCfg.LoadCfgFromIni(MyProfile.ResponseCurves[aDOF]);
        4 : PanYCfg.LoadCfgFromIni(MyProfile.ResponseCurves[aDOF]);
        5 : PanZCfg.LoadCfgFromIni(MyProfile.ResponseCurves[aDOF]);
        6 : begin
          YawCfg.LoadCfgFromIni(MyProfile.ResponseCurves[aDOF]);
          PitchCfg.LoadCfgFromIni(MyProfile.ResponseCurves[aDOF]);
          RollCfg.LoadCfgFromIni(MyProfile.ResponseCurves[aDOF]);
          PanXCfg.LoadCfgFromIni(MyProfile.ResponseCurves[aDOF]);
          PanYCfg.LoadCfgFromIni(MyProfile.ResponseCurves[aDOF]);
          PanZCfg.LoadCfgFromIni(MyProfile.ResponseCurves[aDOF]);
        end;
      end;
    end;
  end;
  ProfileDirty;
end;



procedure TfmFreetrack.GestProfileRenamed(Sender: TObject; aINI: TIniFile);
begin
  MyConfig.ProfileFilename := aINI.FileName;
  RefreshFormTitle;
end;


procedure TfmFreetrack.RefreshFormTitle;
begin
  fmFreetrack.Caption := DKLangConstW('S_FREETRACK') + ' - ' + ChangeFileExt(ExtractFilename(MyConfig.ProfileFilename), '');
  aFreeTrackTray.Hint := DKLangConstW('S_FREETRACK') + ' - ' + ChangeFileExt(ExtractFilename(MyConfig.ProfileFilename), '');
  if ProfilesMngr.ProfileIsDirty then begin
    fmFreetrack.Caption := fmFreetrack.Caption + '  ' + DKLangConstW('S_MODIFIED');
    aFreeTrackTray.Hint := aFreeTrackTray.Hint + '  ' + DKLangConstW('S_MODIFIED');
  end;
end;


procedure TfmFreetrack.Update3DWindowSize(Sender: TObject);
begin
  if HeadPanel <> nil then HeadPanel.Resized := True;
end;


procedure TfmFreetrack.cbOptionsClick(Sender: TObject);
var
  RegIniFile : TRegIniFile;
  aOption : TBinaryOptions;
begin

  for aOption := Low(TBinaryOptions) to High(TBinaryOptions) do
    if Sender = ArraycbOptions[aOption] then begin
      MyConfig.BinaryOptions[aOption] := ArraycbOptions[aOption].Checked;
      Break;
    end;

  case aOption of
    boptLaunchatStartup : begin
      RegIniFile := TRegIniFile.Create('');
      with RegIniFile do begin
        RegIniFile.RootKey := HKEY_LOCAL_MACHINE;
        if MyConfig.BinaryOptions[boptLaunchatStartup] then
          RegIniFile.WriteString('Software\Microsoft\Windows\' + 'CurrentVersion\Run'#0, S_FREETRACK, Application.ExeName + ' /tray')
        else
          RegIniFile.DeleteKey('Software\Microsoft\Windows\' + 'CurrentVersion\Run'#0, S_FREETRACK);
        Free;
      end;
    end;
    boptAutoLoadProfile : ProfilesMngr.AutoLoad := MyConfig.BinaryOptions[aOption];
    boptAutoSaveProfile : ProfilesMngr.AutoSave := MyConfig.BinaryOptions[aOption];
  end;
end;



procedure TfmFreetrack.butKeyPollClick(Sender: TObject);
var
  aKeyControl : TKeyControl;
begin

  // set focus to pagecontrol so that key input doesn't change a form control
  PageControl1.SetFocus;

  DInput.ClearData;

  for aKeyControl := Low(TKeyControl) to High(TKeyControl) do
    if Sender = ArraybutKeyControl[aKeyControl] then begin
      ArraybutKeyControl[aKeyControl].Down := True;
      ArraybutKeyControl[aKeyControl].Caption := DKLangConstW('S_PRESS_CONTROL');
      timerKey.Enabled := False;
      DInput.StartPollControl(@KeyControl[aKeyControl]);
      Exit;
    end;
end;


procedure TfmFreetrack.KeyPollFinished(Sender: TObject; NewData : Boolean);
begin

  timerKey.Enabled := True;

  UpdateKeyControls(False);
  PoseDataOutput.UpdateKeyOutputs(False);

  if NewData then begin
    ProfileDirty;
    KeyChanged := True;
  end;

end;


procedure TfmFreetrack.UpdateKeyControls(Clear : Boolean);
var
  aKeyControl : TKeyControl;
begin
  for aKeyControl := Low(TKeyControl) to High(TKeyControl) do begin
    if Clear then DInput.ClearKey(KeyControl[aKeyControl]);
    ArraybutKeyControl[aKeyControl].Down := False;
    ArraybutKeyControl[aKeyControl].Caption := KeyControl[aKeyControl].Name;
    MyProfile.KeyControls[aKeyControl] := KeyControl[aKeyControl].Name;
  end;
end;


procedure TfmFreetrack.ClearKeyControlsClick(Sender: TObject);
begin
  UpdateKeyControls(True);
end;


procedure TfmFreetrack.combLanguageChange(Sender: TObject);
var
  DevicesIndex, ViewIndex, MouseXIndex, MouseYIndex, MouseWheelIndex, ProfileAIndex,
  ProfileBIndex, ProfileCIndex : Integer;
  aDOF : TDOF;
  ArraycombAxisMapIndex : array[TDOF] of Integer;
  demoAvailable : Boolean;
begin
  demoAvailable := False;
  // store combobox indexes
  DevicesIndex := aCamManager.combCam.ItemIndex;
  if aCamManager.combCam.Items.IndexOf(aCamManager.laDemoVideo.Caption) > 0 then
    demoAvailable := True;
  ViewIndex := combView.ItemIndex;
  MouseXIndex := PoseDataOutput.combMouseXSource.ItemIndex;
  MouseYIndex := PoseDataOutput.combMouseYSource.ItemIndex;
  MouseWheelIndex := PoseDataOutput.combMouseWheelSource.ItemIndex;
  ProfileAIndex := combProfileA.ItemIndex;
  ProfileBIndex := combProfileB.ItemIndex;
  ProfileCIndex := combProfileC.ItemIndex;
  for aDOF := Low(TDOF) to High(TDOF) do
    ArraycombAxisMapIndex[aDOF] := ArraycombAxisMap[aDOF].ItemIndex;

  // change language
  MyConfig.Language := LangManager.LanguageNames[combLanguage.ItemIndex];
  LangManager.LanguageID :=  LangManager.LanguageIDs[combLanguage.ItemIndex];
  RefreshFormTitle;

  case aCamManager.CamState of
    camStopped : butStart.Caption := DKLangConstW('S_START');
    camPaused : butStart.Caption := DKLangConstW('S_RESUME');
    camPlaying : butStart.Caption := DKLangConstW('S_STOP');
  end;

  // restore combobox indexes
  if demoAvailable then
    aCamManager.combCam.AddItem(aCamManager.laDemoVideo.Caption, Self);
  aCamManager.combCam.ItemIndex := DevicesIndex;
  combView.ItemIndex := ViewIndex;
  PoseDataOutput.combMouseXSource.ItemIndex := MouseXIndex;
  PoseDataOutput.combMouseYSource.ItemIndex := MouseYIndex;
  PoseDataOutput.combMouseWheelSource.ItemIndex := MouseWheelIndex;
  combProfileA.ItemIndex :=  ProfileAIndex;
  combProfileB.ItemIndex := ProfileBIndex;
  combProfileC.ItemIndex := ProfileCIndex;
  for aDOF := Low(TDOF) to High(TDOF) do
    ArraycombAxisMap[aDOF].ItemIndex := ArraycombAxisMapIndex[aDOF];
end;


procedure TfmFreetrack.RenderIdle(Sender : TObject; var Done: Boolean);
begin
  if (HeadPanel <> nil) or not aFreetrackTray.Visible then
    if HeadPanel.Visible then begin
        HeadPanel.ReDraw3D;
        // message needed for maintaining onidle
        //PostMessage(Handle, WM_KEEPIDLE, 0, 0);
    end;
end;


procedure TfmFreetrack.cbRelativeMovement(Sender: TObject);
var
  aDOF : TDOF;
begin
  if Sender = cbRollRelativeRot then
    MyProfile.RollRelativeRot := cbRollRelativeRot.Checked
  else
    for aDOF := Low(TDOF) to High(TDOF) do
      if Sender = ArraycbRelativeTrans[aDOF] then begin
        MyProfile.RelativeTrans[aDOF] := ArraycbRelativeTrans[aDOF].Checked;
        Break;
      end;
end;


procedure TfmFreetrack.butDefaultConfigClick(Sender: TObject);
var
  configIni : TInifile;
begin
  if MessageDlg(DKLangConstW('S_QUERY_CONFIG_DEFAULTS'), mtWarning, [mbYes, mbNo], 0) = mrYes then begin

    if aCamManager.CamState = camPlaying then
      butStartClick(Self) // stop
    else if aCamManager.CamState = camPaused then begin
      butStartClick(Self); // resume
      butStartClick(Self); // stop
    end;

    DeleteFile(rootDirectory + 'Freetrack.ini');
    configIni := TIniFile.Create(rootDirectory + 'Freetrack.ini');
    MyConfig := TConfig.Create(Self, configIni);
    aCamManager.LoadCfgFromIni(configIni);
    aCamManager.LoadGUIConfig;
    ForceCamProp.LoadCfgFromIni(configIni);
    GUILoadConfig;
    ProfilesMngr.SaveToFile(configIni);
  end;
end;

procedure TfmFreetrack.cbPortalClick(Sender: TObject);
begin
  if (HeadPanel <> nil) then
    HeadPanel.Portal := cbPortal.Checked;
end;


procedure TfmFreetrack.cbBackwardZClick(Sender: TObject);
begin
  MyProfile.IgnoreBackwardZ := cbBackwardZ.Checked;
end;


procedure TfmFreetrack.combAxisMapChange(Sender: TObject);
var
  aDOF : TDOF;
begin
  for aDOF := Low(TDOF) to High(TDOF) do
    if Sender = ArraycombAxisMap[aDOF] then begin
      if ArraycombAxisMap[aDOF].ItemIndex = 0 then begin
        MyProfile.AxisEnabled[aDOF] := False;
        // stop smoothing so that disabled axis doesn't keep changing
        NoSmoothingDelay := 3;
      end else begin
        MyProfile.AxisEnabled[aDOF] := True;
        MyProfile.AxisMap[aDOF] := TDOF(ArraycombAxisMap[aDOF].ItemIndex - 1);
      end;
    end;
  ProfileDirty;
end;


procedure TfmFreetrack.WndProc(var Message : TMessage);
begin
  {if Message.Msg = WM_INPUT then begin
    PoseDataOutput.RawInHandle := Message.LParam;
  end;   }
  inherited;
end;


procedure TfmFreetrack.ed3pClipChange(Sender: TObject);
begin
  but3pClipApply.Enabled := True;
end;


procedure TfmFreetrack.ed3PCapChange(Sender: TObject);
begin
  but3pCapApply.Enabled := True;
end;

procedure TfmFreetrack.ed4PChange(Sender: TObject);
begin
  but4pCapApply.Enabled := True;
end;



procedure TfmFreetrack.TimertbTicksTimer(Sender: TObject);
begin
  {TTrackBar bug: only way to get trackbar ticks to appear is to call settick when
  trackbar has been made visible at least once}
  tbRotOffsetX.SetTick(0);
  tbRotOffsetY.SetTick(0);
  tbRotOffsetZ.SetTick(0);
  TimertbTicks.Enabled := False;
end;

procedure TfmFreetrack.GestOnChangedSource(Sender : TObject);
begin
  Centering := 10;
end;


procedure TfmFreetrack.sbHelpClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'FreeTrack.chm', '', '', SW_SHOW);
end;

procedure TfmFreetrack.laSensitivityRealClick(Sender: TObject);
var
  aDOF : TDOF;
begin
  for aDOF := Low(TDOF) to High(TDOF) do
    SetSensitivity(aDOF, 1);
end;

procedure TfmFreetrack.laSensitivityDefaultClick(Sender: TObject);
var
  aDOF : TDOF;
begin
  for aDOF := Low(TDOF) to High(TDOF) do
    case aDOF of
      dofYaw : SetSensitivity(aDOF, 7);
      dofPitch : SetSensitivity(aDOF, 7);
      dofRoll : SetSensitivity(aDOF, 3);
      dofPanX : SetSensitivity(aDOF, 5);
      dofPanY : SetSensitivity(aDOF, 7);
      dofPanZ : SetSensitivity(aDOF, 3);
    end;
end;

procedure TfmFreetrack.SetSensitivity(aDOF : TDOF; const Value : Single);
begin
  ArrayTbSensitivity[aDOF].Position := round((Value * ArrayTbSensitivity[aDOF].Max)/SENSITIVITY_MAX);
  tbSensitivityChange(ArrayLaSensitivity[aDOF]);
end;



procedure TfmFreetrack.cbMaintainPausedDataClick(Sender: TObject);
begin
  MyProfile.MaintainPausedData := cbMaintainPausedData.Checked;
end;

procedure TfmFreetrack.DKLanguageController1LanguageChanged(
  Sender: TObject);
var aKey : TKeyControl;
begin
  tbSensitivityYaw.Hint := DKLangConstW('S_HINT_SENSITIVITY');
  tbSensitivityPitch.Hint := DKLangConstW('S_HINT_SENSITIVITY');
  tbSensitivityRoll.Hint := DKLangConstW('S_HINT_SENSITIVITY');
  tbSensitivityX.Hint := DKLangConstW('S_HINT_SENSITIVITY');
  tbSensitivityY.Hint := DKLangConstW('S_HINT_SENSITIVITY');
  tbSensitivityZ.Hint := DKLangConstW('S_HINT_SENSITIVITY');
  tbSmoothingYaw.Hint := DKLangConstW('S_HINT_SMOOTHING');
  tbSmoothingPitch.Hint := DKLangConstW('S_HINT_SMOOTHING');
  tbSmoothingRoll.Hint := DKLangConstW('S_HINT_SMOOTHING');
  tbSmoothingX.Hint := DKLangConstW('S_HINT_SMOOTHING');
  tbSmoothingY.Hint := DKLangConstW('S_HINT_SMOOTHING');
  tbSmoothingZ.Hint := DKLangConstW('S_HINT_SMOOTHING');

  tbGlobalSensitivityYaw.Hint := DKLangConstW('S_HINT_SENSITIVITY');
  tbGlobalSensitivityPitch.Hint := DKLangConstW('S_HINT_SENSITIVITY');
  tbGlobalSensitivityRoll.Hint := DKLangConstW('S_HINT_SENSITIVITY');
  tbGlobalSensitivityX.Hint := DKLangConstW('S_HINT_SENSITIVITY');
  tbGlobalSensitivityY.Hint := DKLangConstW('S_HINT_SENSITIVITY');
  tbGlobalSensitivityZ.Hint := DKLangConstW('S_HINT_SENSITIVITY');
  tbGlobalSmoothingYaw.Hint := DKLangConstW('S_HINT_SMOOTHING');
  tbGlobalSmoothingPitch.Hint := DKLangConstW('S_HINT_SMOOTHING');
  tbGlobalSmoothingRoll.Hint := DKLangConstW('S_HINT_SMOOTHING');
  tbGlobalSmoothingX.Hint := DKLangConstW('S_HINT_SMOOTHING');
  tbGlobalSmoothingY.Hint := DKLangConstW('S_HINT_SMOOTHING');
  tbGlobalSmoothingZ.Hint := DKLangConstW('S_HINT_SMOOTHING');

  for aKey := Low(TKeyControl) to High(TKeyControl) do
    ArraycbKeyControlToggle[aKey].Hint := DKLangConstW('S_HINT_KEYCONTROL_TOGGLE');

  tbSmoothingZooming.Hint := DKLangConstW('S_HINT_SMOOTHINGZOOMING');
  tbGlobalSmoothingZooming.Hint := DKLangConstW('S_HINT_SMOOTHINGZOOMING');
  tbDynamicSmoothing.Hint := DKLangConstW('S_HINT_DYNAMICSMOOTHING');

  cbAutoLoadProfile.Hint := DKLangConstW('S_HINT_AUTOLOADPROFILE');
  cbAutoMinimize.Hint := DKLangConstW('S_HINT_AUTOMINIMIZE');
  cbRelativeTransYaw.Hint := DKLangConstW('S_HINT_VIEW_RELATIVE_TRANS_ROT');
  cbRelativeTransPitch.Hint := DKLangConstW('S_HINT_VIEW_RELATIVE_TRANS_ROT');
  cbRelativeTransRoll.Hint := DKLangConstW('S_HINT_VIEW_RELATIVE_TRANS_ROT');

  cbRelativeTransX.Hint := DKLangConstW('S_HINT_VIEW_RELATIVE_TRANS_TRANS');
  cbRelativeTransY.Hint := DKLangConstW('S_HINT_VIEW_RELATIVE_TRANS_TRANS');
  cbRelativeTransZ.Hint := DKLangConstW('S_HINT_VIEW_RELATIVE_TRANS_TRANS');

  cbMaintainPausedData.Hint := DKLangConstW('S_HINT_MAINTAIN_PAUSED_DATA');

  //re-assign the same value to generate translation
  aFreeTrackTray.MenuCaption := aFreeTrackTray.MenuCaption;
end;



procedure TfmFreetrack.sbHowToClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'Help.chm', '', '', SW_SHOW);
end;

end.
