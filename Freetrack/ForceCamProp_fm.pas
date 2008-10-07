unit ForceCamProp_fm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Commctrl, ActiveX, DSPack, DirectShow9, DSUtil,
  BaseClass, IniFiles, Math, DKLang;

type

  TControl = record
    Checked : Integer;
    TrackbarPos : Integer;
  end;

  TPropertyPageSite = class(TObject, IPropertyPageSite)
  private
    FRefCount : Cardinal;
  public
    function QueryInterface(const IID : TGUID; out Obj) : HRESULT; stdcall;
    function _AddRef : Integer; stdcall;
    function _Release : Integer; stdcall;

    function OnStatusChange(flags: Longint): HRESULT; stdcall;
    function GetLocaleID(out localeID: TLCID): HRESULT; stdcall;
    function GetPageContainer(out unk: IUnknown): HRESULT; stdcall;
    function TranslateAccelerator(msg: PMsg): HRESULT; stdcall;
  end;


  TForceCamProp = class(TForm)
    DKLanguageController1: TDKLanguageController;
    pcPropPages: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    butApply: TButton;
    butCancel: TButton;
    butOK: TButton;
    clickTimer: TTimer;
    procedure butApplyClick(Sender: TObject);
    procedure butCancelClick(Sender: TObject);
    procedure butOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure clickTimerTimer(Sender: TObject);

  private
    Camera: TFilter;
    fOwner : TDataModule;
    exposureSetting : Integer;
    tsPages : TList;
    hPropPage : array[0..100] of THandle;
    ControlNumber : array[0..2] of Integer;
    pPageSite : TPropertyPageSite;
    pPage : array[0..100] of IPropertyPage;
    CAGUID : TCAGUID;
    Control : array[0..299] of TControl;
    FSelectedCam : String;
    SavedCam : String;
    function AddSheet(name : String; rectPage : TRect) : THandle;
    procedure HandleClick;
    procedure SaveProperties;
    procedure Cleanup;
    procedure ApplyPage;

  public
    Constructor Create(AOwner : TComponent); override;
    procedure ShowStreamProp;
    procedure ForceProperties;
    procedure LoadCfgFromIni(aIni: TIniFile);
    procedure SaveCfgToIni(aIni: TIniFile);
    property SelectedCam : String read FSelectedCam write FSelectedCam;
  end;


var
  ForceCamProp: TForceCamProp;

implementation

uses DInputMap;

const
  PAGE_NUM = 4;

{$R *.dfm}


constructor TForceCamProp.Create(AOwner : TComponent);
begin
  Inherited;
  fOwner := AOwner as TDataModule;
  Camera := fOwner.FindComponent('Camera') as TFilter;
  tsPages := TList.Create;

end;


function TForceCamProp.AddSheet(name : String; rectPage : TRect) : THandle;
var
  i : Integer;
begin
  tsPages.Add(TTabSheet.Create(pcPropPages));
  i := tsPages.Count - 1;
  TTabSheet(tsPages.Items[i]).PageControl := pcPropPages;
  TTabSheet(tsPages.Items[i]).Caption := name;
  if pcPropPages.Width < rectPage.Right + 10 then
    pcPropPages.Width := rectPage.Right + 10;
  if pcPropPages.Height < rectPage.Bottom + 10 then
    pcPropPages.Height := rectPage.Bottom + 10;
  if Self.Width < rectPage.Right + 25 then
    Self.Width := rectPage.Right + 25;
  if Self.Height < rectPage.Bottom + 80 then
    Self.Height := rectPage.Bottom + 80;
  Result := TTabSheet(tsPages.Items[i]).Handle;
end;


procedure TForceCamProp.ForceProperties;
var
  dsSpecifyPropertyPages : ISpecifyPropertyPages;
  pPageSite : TPropertyPageSite;
  pPage : array[0..100] of IPropertyPage;
  CAGUID : TCAGUID;
  dsCameraControl : IAMCameraControl;
  rectTiny : TRect;
  hDlg, hCtrl : THandle;
  TrackBarRange, TrackBarMin, aControl : Integer;
  pCamera : IBaseFilter;
  i, ctrlNum : Integer;
  aPAnsiChar : PAnsiChar;
  ctrlName : String;
  kplus, kminus : Cardinal;

begin
  // create property pages - don't confuse this hidden local property page site with the global visible one
  if Camera.QueryInterface(IID_ISpecifyPropertyPages,  dsSpecifyPropertyPages) <> S_OK then Exit;
  if dsSpecifyPropertyPages.GetPages(CAGUID) <> S_OK then Exit;
  pPageSite := TPropertyPageSite.Create;
  pPageSite._AddRef;
  pCamera := Camera as IBaseFilter;
  for i := 0 to PAGE_NUM do
    if CoCreateInstance(CAGUID.pElems[i], nil, CLSCTX_INPROC_SERVER, IPropertyPage, pPage[i]) = S_OK then begin
      pPage[i].SetPageSite(pPageSite);
      if pPage[i].SetObjects(1, @pCamera) = S_OK then begin
        rectTiny.Top := 0;
        rectTiny.Left := 0;
        rectTiny.Right := 1;
        rectTiny.Bottom := 1;
        pPage[i].Activate(Application.Handle, rectTiny, FALSE);
      end;
    end;

  {get current cam settings if camera device changed
  memoryless settings lost when changing cameras
  don't filter by class name because it is unreliable}
  if AnsiCompareStr(FSelectedCam, SavedCam) <> 0 then begin
    // save current settings
    SavedCam := FSelectedCam;
    ctrlNum := 0;
    hDlg := 0;
    hDlg := FindWindowExA(Application.Handle, hDlg, nil, nil);
    while (hDlg <> 0) do begin
      hCtrl := 0;
      hCtrl := FindWindowExA(hDlg, hCtrl, nil, nil);
      while (hCtrl <> 0) do begin
        if ctrlNum < High(Control) then begin
          Control[ctrlNum].Checked := SendMessage(hCtrl, BM_GETCHECK, 0, 0);
          Control[ctrlNum].TrackbarPos := SendMessage(hCtrl, TBM_GETPOS, 0, 0);
        end;
        Inc(ctrlNum);
        hCtrl := FindWindowExA(hDlg, hCtrl, nil, nil);
      end;
      hDlg := FindWindowExA(Application.Handle, hDlg, nil, nil);
    end;
  end else begin
    // apply settings twice with a time delay in-between to ensure correctly applied
    for i := 0 to 1 do begin
      GetMem(aPAnsiChar, 30);
      ctrlNum := 0;
      hDlg := 0;
      hDlg := FindWindowExA(Application.Handle, hDlg, nil, nil);
      while (hDlg <> 0) do begin
        hCtrl := 0;
        hCtrl := FindWindowExA(hDlg, hCtrl, nil, nil);
        while (hCtrl <> 0) do begin
          EnableWindow(hCtrl, TRUE); // enable control
          // can't identify control type so send trackbar and checkbox messages

          {TRACKBAR
           Use keypress so that trackbar doesn't reset to default with every setpos attempt
           WM_COMMAND to a button is registered as a click}
          SendMessage(hCtrl, WM_KEYDOWN, VK_LEFT, 0);
          SendMessage(hCtrl, TBM_SETPOS, WPARAM(TRUE), Control[ctrlNum].TrackbarPos);

          {CHECKBOXES
          Do not want to press buttons, especially the Default button!
          Difficult to identify checkboxes vs buttons
          WM_COMMAND to a button is registered as a click
          Use special property of checkboxes, can change using key plus/minus}
          if Control[ctrlNum].Checked = BST_CHECKED then
            SendMessage(hCtrl, WM_CHAR, Byte('+'), 0)
          else
            SendMessage(hCtrl, WM_CHAR, Byte('-'), 0);

          Inc(ctrlNum);
          hCtrl := FindWindowExA(hDlg, hCtrl, nil, nil);
        end;
        hDlg := FindWindowExA(Application.Handle, hDlg, nil, nil);
      end;
      Sleep(100);
    end;
  end;

  // apply and deactivate
  for i := 0 to CAGUID.cElems - 1 do
    if pPage[i] <> nil then begin
      pPage[i].Apply;
      pPage[i].Deactivate;
      pPage[i].SetPageSite(nil);
    end;
end;



procedure TForceCamProp.ShowStreamProp;
var
  SpecifyPropertyPages : ISpecifyPropertyPages;
  pFilter : IBaseFilter;
  rectPage : TRect;
  i : Integer;
  pPageInfo : tagPROPPAGEINFO;

begin
  if Self.Visible then Exit;

  // allow for vfw?

  {create property pages - build manually instead of using OleCreatePropertyFrame so that handle
  counting starts from the first page instead of the current page. Count needs to be unique because it is
  used to identify each control }
  if Camera.QueryInterface(IID_ISpecifyPropertyPages, SpecifyPropertyPages) <> S_OK then Exit;
  if SpecifyPropertyPages.GetPages(CAGUID) <> S_OK then Exit;
  pPageSite := TPropertyPageSite.Create;
  pPageSite._AddRef;
  pFilter := Camera as IBaseFilter;
  for i := 0 to PAGE_NUM do begin
    if CoCreateInstance(CAGUID.pElems[i], nil, CLSCTX_INPROC_SERVER, IPropertyPage, pPage[i]) = S_OK then begin
      pPage[i].GetPageInfo(pPageInfo);
      pPage[i].SetPageSite(pPageSite);
      if pPage[i].SetObjects(1, @pFilter) = S_OK then begin
        rectPage.Top := 0;
        rectPage.Left := 0;
        rectPage.Right := pPageInfo.size.cx;
        rectPage.Bottom := pPageInfo.size.cy;
        hPropPage[i] := AddSheet(pPageInfo.pszTitle, rectPage);
        pPage[i].Activate(hPropPage[i], rectPage, FALSE);
      end;
    end;
  end;
  ForceCamProp.Visible := True;
  clickTimer.Enabled := True;
end;


procedure TForceCamProp.HandleClick;
var
  hWind, hControl, hParent : THandle;
  aPoint : TPoint;
  i : Integer;
begin
   if ((DInput.MouseBut[0] and $80) > 0) then begin

    // enable apply button when dirty
    if not butApply.Enabled then
      for i := 0 to PAGE_NUM do
        if (pPage[i] <> nil) and (pPage[i].IsPageDirty = 0) then begin
          butApply.Enabled := True;
          Break;
        end;

    // enable property page control on click (for cameras with disabled auto-exposure checkboxes)
    // restrict to controls that are parents of the camera property pages
    GetCursorPos(aPoint);
    hWind := WindowFromPoint(aPoint);
    if hWind <> 0 then begin
      Windows.ScreenToClient(hWind, aPoint);
      hControl := ChildWindowFromPoint(hWind, aPoint);
      if hControl <> 0 then begin
        hParent := GetParent(GetParent(hControl));
        for i := 0 to PAGE_NUM do
          if hPropPage[i] = hParent then
            EnableWindow(hControl, TRUE);
      end;
    end;
  end;
end;


procedure TForceCamProp.clickTimerTimer(Sender: TObject);
begin
  HandleClick;
end;


procedure TForceCamProp.SaveProperties;
var
  hDlg, hCtrl : THandle;
  ctrlNum, pageNum : Integer;
  aPAnsiChar : PAnsiChar;
  ctrlName : String;
  Checked, TrackBarPos : Integer;
begin
  SavedCam := FSelectedCam;
  GetMem(aPAnsiChar, 30);
  ctrlNum := 0;
  for pageNum := 0 to PAGE_NUM do
    if hPropPage[pageNum] <> 0 then begin
      hDLg := 0;
      hDlg := FindWindowExA(hPropPage[pageNum], hDlg, nil, nil);
      while hDlg <> 0 do begin
        hCtrl := 0;
        hCtrl := FindWindowExA(hDlg, hCtrl, nil, nil);
        while hCtrl <> 0 do begin
          //GetDlgItemTextA(hDlg, GetDlgCtrlID(hCtrl), aPAnsiChar, 25);
          if ctrlNum < High(Control) then begin
            Control[ctrlNum].Checked := SendMessage(hCtrl, BM_GETCHECK, 0, 0);
            Control[ctrlNum].TrackbarPos := SendMessage(hCtrl, TBM_GETPOS, 0, 0);
          end;
          Inc(ctrlNum);
          hCtrl := FindWindowExA(hDlg, hCtrl, nil, nil);
        end;
        hDlg := FindWindowExA(hPropPage[pageNum], hDlg, nil, nil);
      end;
    end;
end;


procedure TForceCamProp.ApplyPage;
var
  i : Integer;
begin
  for i := 0 to CAGUID.cElems - 1 do
    if pPage[i] <> nil then
      pPage[i].Apply;
  butApply.Enabled := False;
end;


procedure TForceCamProp.Cleanup;
var
  i : Integer;
begin
  for i := 0 to CAGUID.cElems - 1 do
    if pPage[i] <> nil then begin
      pPage[i].Deactivate;
      pPage[i].SetPageSite(nil);
    end;
  CoTaskMemFree(CAGUID.pElems);

  for i := 0 to tsPages.Count - 1 do
    TTabSheet(tsPages.Items[i]).PageControl := nil;
  tsPages.Clear;
  butApply.Enabled := False;
end;


procedure TForceCamProp.butOKClick(Sender: TObject);
begin
  butApplyClick(Self);
  butCancelClick(Self);
end;


procedure TForceCamProp.butCancelClick(Sender: TObject);
begin
  ForceCamProp.Visible := False;
  clickTimer.Enabled := False;
  Cleanup;
end;


procedure TForceCamProp.butApplyClick(Sender: TObject);
begin
  SaveProperties;
  ApplyPage;
end;


procedure TForceCamProp.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  butCancelClick(Self);
end;


procedure TForceCamProp.LoadCfgFromIni(aIni: TIniFile);
var
  i : Integer;
begin
  SavedCam := aIni.ReadString('CameraProp', 'SavedCam', '');
  for i := 0 to High(Control) do begin
    Control[i].Checked := aIni.ReadInteger('CameraProp', 'Checkbox' + InttoStr(i), 0);
    Control[i].TrackbarPos := aIni.ReadInteger('CameraProp', 'Trackbar' + InttoStr(i), 0);
  end;
end;


procedure TForceCamProp.SaveCfgToIni(aIni: TIniFile);
var
  i : Integer;
begin
  {need to erase the cameraprop section because only non-zero values are being saved
  so last saved changes will remain otherwise}
  aIni.EraseSection('CameraProp');
  aIni.WriteString('CameraProp', 'SavedCam', SavedCam);
  for i := 0 to High(Control) do begin
    // only store non-zero values
    if (Control[i].Checked <> 0) then
      aIni.WriteInteger('CameraProp', 'Checkbox' + InttoStr(i), Control[i].Checked);
    if (Control[i].TrackbarPos <> 0) then
      aIni.WriteInteger('CameraProp', 'Trackbar' + InttoStr(i), Control[i].TrackbarPos);
  end;
end;




// ***************************** TPropertyPageSite **************************

function TPropertyPageSite.QueryInterface(const IID : TGUID; out Obj) : HRESULT;
begin
  if GetInterface(IID, Obj) then begin
    result := S_OK;
  end else
    result := E_NOINTERFACE;
end;


function TPropertyPageSite._AddRef : Integer;
begin
  Inc(FRefCount);
  result := FRefCount;
end;


function TPropertyPageSite._Release : Integer;
begin
  Dec(FRefCount);
  result := FRefCount;
end;


function TPropertyPageSite.OnStatusChange(flags: Longint): HRESULT;
begin
  result := S_OK;
end;


function TPropertyPageSite.GetLocaleID(out localeID: TLCID): HRESULT;
begin
  localeID := 0;
  result := S_OK;
end;


function TPropertyPageSite.GetPageContainer(out unk: IUnknown): HRESULT;
begin
  unk := nil;
  result := E_NOTIMPL;
end;


function TPropertyPageSite.TranslateAccelerator(msg: PMsg): HRESULT;
begin
  msg := nil;
  result := E_NOTIMPL;
end;
















end.
