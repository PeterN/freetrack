unit FreeTrackTray;

interface

uses
  Windows, Classes, Menus, Graphics, Forms, messages,
  TrayIcon, PngImageList, PngSpeedButton, extctrls, DKLang;

type
  TTypeState = (tsOff, tsON_Ok, tsOn_HS);
  TIconArray = array[TTypeState] of TIcon;
  TTrayMenuCaption = (S_START, S_STOP, S_RESUME);

  TOnStateChanged = procedure (Sender : TObject; state : TTypeState) of Object;
  TOnHostAppRunning = procedure (Sender : TObject; value : Boolean) of Object;

  TFreeTrackTray = class(TTRayIcon)
  private
    aIcons : array[TTypeState] of TIcon;
    FState: TTypeState;
    FOnStateChanged: TOnStateChanged;
    FOnRestore: TNotifyEvent;
    FOnMinimize: TNotifyEvent;
    FHostAppRunning: Boolean;
    FOnHostAppRunning: TOnHostAppRunning;
    fOwner : TForm;
    FMenuState: TTrayMenuCaption;

    procedure GestMnuRestore(Sender: TObject);
    procedure GestMnuQuit(Sender: TObject);
    procedure GestDblClick(Sender: TObject);
    procedure GestMnuStart(Sender: TObject);
    procedure SetState(const Value: TTypeState);
    procedure SetHostAppRunning(value : Boolean);
    function GetIcon(Index : TTypeState): TIcon;
    procedure SetMenuCaption(const Value: TTrayMenuCaption);
  public
    aPopupMenu : TPopupMenu;
    Constructor Create(AOwner: TComponent); override;
    procedure Restore;override;
    procedure Minimize;override;
    property MenuCaption : TTrayMenuCaption read FMenuState write SetMenuCaption;
    property State : TTypeState read FState write SetState;
    property Icons[Index : TTypeState] : TIcon  read GetIcon;
    property OnStateChanged : TOnStateChanged read FOnStateChanged write FOnStateChanged;
    property OnRestore : TNotifyEvent read FOnRestore write FOnRestore;
    property OnMinimize : TNotifyEvent read FOnMinimize write FOnMinimize;
    property HostAppRunning : Boolean read FHostAppRunning write SetHostAppRunning;
    property OnHostAppRunning : TOnHostAppRunning read FOnHostAppRunning write FOnHostAppRunning;
  end;

var
  aFreeTrackTray : TFreeTrackTray;

implementation

{$R icons.res}


{ TFreeTrackTray }

constructor TFreeTrackTray.Create(AOwner: TComponent);
var
  aState : TTypeState;
begin
  inherited;
  aPopupMenu := TPopupMenu.Create(Self);

  aPopupMenu.Items.Add(TMenuItem.Create(aPopupMenu));
  aPopupMenu.Items[0].OnClick := GestMnuStart;

  aPopupMenu.Items.Add(TMenuItem.Create(aPopupMenu));
  aPopupMenu.Items[1].OnClick := GestMnuRestore;

  aPopupMenu.Items.Add(TMenuItem.Create(aPopupMenu));
  aPopupMenu.Items[2].OnClick := GestMnuQuit;

  SetMenuCaption(S_START);

  PopupMenu := aPopupMenu;
  OnDblClick := GestDblClick;
  Visible := False;

  for aState := low(TTypeState) to high(TTypeState) do
    aIcons[aState] := TIcon.Create;

  fOwner := AOwner as TForm;

  aIcons[tsOff] := (fOwner.FindComponent('imTrayIcon1') as TImage).Picture.Icon;
  aIcons[tsOn_HS] := (fOwner.FindComponent('imTrayIcon2') as TImage).Picture.Icon;
  aIcons[tsOn_OK] := (fOwner.FindComponent('imTrayIcon3') as TImage).Picture.Icon;

  State := tsOff;
  Icon := aIcons[tsOff];
end;



procedure TFreeTrackTray.GestDblClick(Sender: TObject);
begin
  Application.Restore;
  Application.BringToFront;
end;



procedure TFreeTrackTray.GestMnuQuit(Sender: TObject);
begin
  PostMessage( Application.MainForm.Handle, WM_Close, 0, 0);
end;



procedure TFreeTrackTray.GestMnuRestore(Sender: TObject);
begin
  GestDblClick(nil);
end;


procedure TFreeTrackTray.GestMnuStart(Sender: TObject);
begin
  (fOwner.FindComponent('butStart') as TPngSpeedButton).Click;
end;



function TFreeTrackTray.GetIcon(Index : TTypeState): TIcon;
begin
  Result := aIcons[Index];
end;




procedure TFreeTrackTray.Minimize;
begin
  inherited;
  Application.ShowMainForm := False;
  Visible := True;
  if Assigned(FOnMinimize) then
    FOnMinimize(Self);
end;



procedure TFreeTrackTray.Restore;
begin
  inherited;
  Visible := False;
  Application.ShowMainForm := True;
  Application.MainForm.Visible := True;
  if Assigned(FOnRestore) then
    FOnRestore(Self);
end;



procedure TFreeTrackTray.SetState(const Value: TTypeState);
begin
  if FState = Value then
    Exit;

  FState := Value;
  Icon := aIcons[Value];

  if Assigned(FOnStateChanged) then
    FOnStateChanged(Self, Value);
end;


procedure TFreeTrackTray.SetHostAppRunning(value : Boolean);
begin
  FHostAppRunning := value;
  if Assigned(FOnHostAppRunning) then
    FOnHostAppRunning(Self, value);
end;

procedure TFreeTrackTray.SetMenuCaption(const Value: TTrayMenuCaption);
begin
   FMenuState := Value;

   case FMenuState of
    S_START : aPopupMenu.Items[0].Caption := DKLangConstW('S_START');
    S_STOP  : aPopupMenu.Items[0].Caption := DKLangConstW('S_STOP');
    S_RESUME: aPopupMenu.Items[0].Caption := DKLangConstW('S_RESUME');
  end;

  aPopupMenu.Items[1].Caption := DKLangConstW('S_RESTORE');
  aPopupMenu.Items[2].Caption := DKLangConstW('S_QUIT');

end;

end.
