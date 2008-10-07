unit TrayIcon;

interface


{
  A component to make it easier to create a system tray icon.
  Install this component in the Delphi IDE (Component, Install component)
  and drop it on a form, and the application automatically
  becomes a tray icon. This means that when the application is
  minimized, it does not minimize to a normal taskbar icon, but
  to the little system tray on the side of the taskbar. A popup
  menu is available from the system tray icon, and your application
  can process mouse events as the user moves the mouse over
  the system tray icon, clicks on the icon, etc.

  Copyright © 1996 Tempest Software. All rights reserved.
  You may use this software in an application without fee or royalty,
  provided this copyright notice remains intact.
}

uses
  Windows, Messages, ShellApi, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Menus;

{
  This message is sent to the special, hidden window for shell
  notification messages. Only derived classes might need to
  know about it.
}

const
  WM_CALLBACK_MESSAGE = WM_USER + 1;

type
  TTrayIcon = class (TComponent)
  private
    fClicked: Boolean;
    FData: TNotifyIconData;
    FHint: string;
    FIcon: TIcon;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnMinimize: TNotifyEvent;
    FOnMouseDown: TMouseEvent;
    FOnMouseMove: TMouseMoveEvent;
    FOnMouseUp: TMouseEvent;
    FOnRestore: TNotifyEvent;
    FPopupMenu: TPopupMenu;
    FVisible: Boolean;
    procedure SetVisible(const Value: Boolean);
  protected
    procedure AppMinimize(Sender: TObject);
    procedure AppRestore(Sender: TObject);
    procedure Changed; virtual;
    procedure Click; virtual;
    procedure DblClick; virtual;
    procedure DoMenu; virtual;
    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoMouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure EndSession; virtual;
    procedure OnMessage(var Msg: TMessage); virtual;
    procedure SetHint(const Hint: string); virtual;
    procedure SetIcon(Icon: TIcon); virtual;
    property Data: TNotifyIconData read FData;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    procedure Minimize; virtual;
    procedure Restore; virtual;
  published
    property Hint: string read FHint write SetHint;
    property Icon: TIcon read FIcon write SetIcon;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnMinimize: TNotifyEvent read FOnMinimize write FOnMinimize;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnRestore: TNotifyEvent read FOnRestore write FOnRestore;
    property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
    property Visible: Boolean read FVisible write SetVisible;
  end;
  

implementation


{
************************************************************ TTrayIcon *************************************************************
}
{-


}
constructor TTrayIcon.Create(Owner: TComponent);
  
  { Create the component. At run-time, automatically add a tray icon
    with a callback to a hidden window. Use the application icon and title.}
  
begin
  inherited Create(Owner);
  fIcon := TIcon.Create;
  fIcon.Assign(Application.Icon);
  if not (csDesigning in ComponentState) then
  begin
    FillChar(fData, SizeOf(fData), 0);
    fData.cbSize := SizeOf(fData);
    fData.Wnd  := AllocateHwnd(OnMessage); // handle to get notification message
    fData.hIcon  := Icon.Handle; // icon to display
    StrPLCopy(fData.szTip, Application.Title, SizeOf(fData.szTip) - 1);
    fData.uFlags := Nif_Icon or Nif_Message;
    if Application.Title <> '' then
      fData.uFlags := fData.uFlags or Nif_Tip;
    fData.uCallbackMessage := WM_CALLBACK_MESSAGE;
    if not Shell_NotifyIcon(NIM_ADD, @fData) then // add it
      raise EOutOfResources.Create('Cannot create shell notification icon');
      {
        Replace the application's minimize and restore handlers with
        special ones for the tray. The TrayIcon component has its own
        OnMinimize and OnRestore events that the user can set.
      }
    Application.OnMinimize := AppMinimize;
    Application.OnRestore  := AppRestore;
  end;
  FVisible := True;
end;

{-


}
destructor TTrayIcon.Destroy;
  
  { Remove the icon from the system tray.}
  
begin
  fIcon.Free;
  if not (csDesigning in ComponentState) then
    Shell_NotifyIcon(Nim_Delete, @fData);
  inherited Destroy;
end;

{-


}
procedure TTrayIcon.AppMinimize(Sender: TObject);
  
  { When the Application is minimized, minimize to the system tray.}
  
begin
  Minimize
end;

{-


}
procedure TTrayIcon.AppRestore(Sender: TObject);
  
  { When restoring from the system tray, restore the application. }
  
begin
  Restore
end;

{-


}
procedure TTrayIcon.Changed;
  
  { Whenever any information changes, update the system tray. }
  
begin
  if not (csDesigning in ComponentState) then
    Shell_NotifyIcon(NIM_MODIFY, @fData);
end;

{-


}
procedure TTrayIcon.Click;
begin
  if Assigned(fOnClick) then
    fOnClick(Self);
end;

{-


}
procedure TTrayIcon.DblClick;
begin
  if Assigned(fOnDblClick) then
    fOnDblClick(Self);
end;

{-


}
procedure TTrayIcon.DoMenu;
var
  Pt: TPoint;
  
  { When the user right clicks the icon, call DoMenu.
    If there is a popup menu, and if the window is minimized,
    then popup the menu.}
  
begin
  if (fPopupMenu <> nil) and not IsWindowVisible(Application.Handle) then
  begin
    GetCursorPos(Pt);
    SetForeGroundWindow(Application.MainForm.Handle);
    fPopupMenu.Popup(Pt.X, Pt.Y);
  end;
end;

{-


}
procedure TTrayIcon.DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(fOnMouseDown) then
    fOnMouseDown(Self, Button, Shift, X, Y);
end;

{-


}
procedure TTrayIcon.DoMouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(fOnMouseMove) then
    fOnMouseMove(Self, Shift, X, Y);
end;

{-


}
procedure TTrayIcon.DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(fOnMouseUp) then
    fOnMouseUp(Self, Button, Shift, X, Y);
end;

{-


}
procedure TTrayIcon.EndSession;
  
  { Allow Windows to exit by deleting the shell notify icon. }
  
begin
  Shell_NotifyIcon(Nim_Delete, @fData);
end;

{-


}
procedure TTrayIcon.Minimize;
  
  { When the application minimizes, hide it, so only the icon
    in the system tray is visible.}
  
begin
  ShowWindow(Application.Handle, SW_HIDE);
  if Assigned(fOnMinimize) then
    fOnMinimize(Self);
end;

{-


}
procedure TTrayIcon.OnMessage(var Msg: TMessage);
  
  {
    Message handler for the hidden shell notification window.
    Most messages use Wm_Callback_Message as the Msg ID, with
    WParam as the ID of the shell notify icon data. LParam is
    a message ID for the actual message, e.g., Wm_MouseMove.
    Another important message is Wm_EndSession, telling the
    shell notify icon to delete itself, so Windows can shut down.
  
    Send the usual Delphi events for the mouse messages. Also
    interpolate the OnClick event when the user clicks the
    left button, and popup the menu, if there is one, for
    right click events.
  }
    { Return the state of the shift keys. }
    function ShiftState: TShiftState;
    begin
      Result := [];
      if GetKeyState(VK_SHIFT) < 0 then
        Include(Result, ssShift);
      if GetKeyState(VK_CONTROL) < 0 then
        Include(Result, ssCtrl);
      if GetKeyState(VK_MENU) < 0 then
        Include(Result, ssAlt);
    end;
  var
    Pt: TPoint;
    Shift: TShiftState;
  
begin
  case Msg.Msg of
    Wm_QueryEndSession:
      Msg.Result := 1;
    Wm_EndSession:
      if TWmEndSession(Msg).EndSession then
        EndSession;
    Wm_Callback_Message:
      case Msg.lParam of
        WM_MOUSEMOVE:
          begin
            Shift := ShiftState;
            GetCursorPos(Pt);
            DoMouseMove(Shift, Pt.X, Pt.Y);
          end;
        WM_LBUTTONDOWN:
          begin
            Shift := ShiftState + [ssLeft];
            GetCursorPos(Pt);
            DoMouseDown(mbLeft, Shift, Pt.X, Pt.Y);
            fClicked := True;
          end;
        WM_LBUTTONUP:
          begin
            Shift := ShiftState + [ssLeft];
            GetCursorPos(Pt);
            if fClicked then
            begin
              fClicked := False;
              Click;
            end;
            DoMouseUp(mbLeft, Shift, Pt.X, Pt.Y);
          end;
        WM_LBUTTONDBLCLK:
          DblClick;
        WM_RBUTTONDOWN:
          begin
            Shift := ShiftState + [ssRight];
            GetCursorPos(Pt);
            DoMouseDown(mbRight, Shift, Pt.X, Pt.Y);
            DoMenu;
          end;
        WM_RBUTTONUP:
          begin
            Shift := ShiftState + [ssRight];
            GetCursorPos(Pt);
            DoMouseUp(mbRight, Shift, Pt.X, Pt.Y);
          end;
        WM_RBUTTONDBLCLK:
          DblClick;
        WM_MBUTTONDOWN:
          begin
            Shift := ShiftState + [ssMiddle];
            GetCursorPos(Pt);
            DoMouseDown(mbMiddle, Shift, Pt.X, Pt.Y);
          end;
        WM_MBUTTONUP:
          begin
            Shift := ShiftState + [ssMiddle];
            GetCursorPos(Pt);
            DoMouseUp(mbMiddle, Shift, Pt.X, Pt.Y);
          end;
        WM_MBUTTONDBLCLK:
          DblClick;
      end;
  end;
end;

{-


}
procedure TTrayIcon.Restore;
  
  { Restore the application by making its window visible again,
    which is a little weird since its window is invisible, having
    no height or width, but that's what determines whether the button
    appears on the taskbar.}
  
begin
  ShowWindow(Application.Handle, SW_RESTORE);
  if Assigned(fOnRestore) then
    fOnRestore(Self);
end;

{-


}
procedure TTrayIcon.SetHint(const Hint: string);
  
  { Set a new hint, which is the tool tip for the shell icon. }
  
begin
  if fHint <> Hint then
  begin
    fHint := Hint;
    StrPLCopy(fData.szTip, Hint, SizeOf(fData.szTip) - 1);
    if Hint <> '' then
      fData.uFlags := fData.uFlags or Nif_Tip
    else
      fData.uFlags := fData.uFlags and not Nif_Tip;
    Changed;
  end;
end;

{-


}
procedure TTrayIcon.SetIcon(Icon: TIcon);
  
  { Set a new icon. Update the system tray. }
  
begin
  if fIcon <> Icon then begin
    fIcon.Assign(Icon);
    fData.hIcon := Icon.Handle;
    Changed;
  end;
end;

{-


}
procedure TTrayIcon.SetVisible(const Value: Boolean);
begin
  if FVisible = Value then
    Exit;
  
  FVisible := Value;
  if FVisible then
    Shell_NotifyIcon(NIM_ADD, @fData)
  else
    Shell_NotifyIcon(Nim_Delete, @fData);
end;


end.
