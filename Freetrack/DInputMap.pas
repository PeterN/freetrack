unit DInputMap;

interface
uses
  Classes, Windows, SysUtils, DirectInput, StdCtrls,
  Messages, Parameters, StrUtils, ExtCtrls, Dialogs;


type

  TOnFinishedPoll = procedure (Sender : TObject; NewData : Boolean) of Object;

  TKeyStruct = record
    InputType : TInputType;
    Key: Word; // scancode
    Shift : TShiftState; // Ctrl, Shift, Alt
    Name : String[50]; 
    InterPressCount : Integer; // how long since key was last held
    PressCount : Integer; // how long key is held
    ControllerNum : Integer;  // joystick/controller device number
    InternalState : Boolean; // state of the control in FreeTrack
  end;

  PKeyStruct = ^TKeyStruct;

  TDInput = class(TDataModule)
    timerPoll: TTimer;
    procedure PollKeyControl(Sender: TObject);
    procedure PollKeyOutput(Sender: TObject);
  private
    dip: IDirectInput2A;

    Keyb, Mouse : IDirectInputDeviceA;
    KeybData : array[0..255] of byte;
    KeybCaps : DIDEVCAPS;

    MouseData : DIMOUSESTATE2;
    MouseCaps : DIDEVCAPS;
    MouseObjs : array of DIDEVICEOBJECTINSTANCE;
    aMouseObject : Integer;

    Controller : array of IDirectInputDevice2A;
    ControllerNumTotal : Integer;
    ControllerData : array of DIJOYSTATE2;
    ControllerCaps : array of DIDEVCAPS;
    ControllerObjs : array of array of DIDEVICEOBJECTINSTANCE;
    aControllerDevice : Integer;
    aControllerObject : Integer;

    PropString : DIPROPSTRING;
    //PropWord : DIPROPDWORD;

    KeyPoll : PKeyStruct;
    KeyPollCount : Integer;

    FOnFinishedPoll : TOnFinishedPoll;

    function GetKeyboardData(aKey : Integer) : byte;
    function GetMouseButtonData(aButton : Integer) : byte;
    function GetControllerButtonData(aController : Integer; aButton : Integer) : byte;

  public

    Constructor Create(AOWner : TComponent); override;
    Destructor Destroy; override;
    procedure ClearData;
    procedure UpdateData;
    procedure Str2CodeOutput(var Key : TKeyStruct);
    procedure Str2CodeControl(var Key : TKeyStruct);
    procedure StartPollControl(Key : PKeyStruct);
    procedure StartPollOutput(Key : PKeyStruct);
    procedure ClearKey(var Key : TKeyStruct);

    property KeyBut[aKey : Integer] : byte read GetKeyboardData;
    property MouseBut[aButton : Integer] : byte read GetMouseButtonData;
    property ControllerBut[aJoy : Integer; aButton : Integer] : byte read GetControllerButtonData;
    property OnFinishedPoll : TOnFinishedPoll read FOnFinishedPoll write FOnFinishedPoll;
  end;

var
  DInput : TDInput;

implementation

{$R *.dfm}

const
  S_ERROR_DIP = 'Failed to initialize DirectInput.';


function EnumControllersCallbackFunc(var lpddi: TDIDeviceInstanceA;  aDIP : TDInput): BOOL; stdcall;
begin
  SetLength(aDIP.Controller, aDIP.ControllerNumTotal + 1);
  SetLength(aDIP.ControllerData, aDIP.ControllerNumTotal + 1);
  SetLength(aDIP.ControllerCaps, aDIP.ControllerNumTotal + 1);
  SetLength(aDIP.ControllerObjs, aDIP.ControllerNumTotal + 1);

  if aDIP.dip.CreateDevice(lpddi.guidInstance, IDirectInputDeviceA(aDIP.Controller[aDIP.ControllerNumTotal]), nil) = DI_OK then begin
    aDIP.Controller[aDIP.ControllerNumTotal].SetDataFormat(c_dfDIJoystick2);
    aDIP.Controller[aDIP.ControllerNumTotal].SetCooperativeLevel(0, DISCL_BACKGROUND + DISCL_NONEXCLUSIVE);
    aDIP.Controller[aDIP.ControllerNumTotal].Acquire;

    aDIP.ControllerCaps[aDIP.ControllerNumTotal].dwSize := sizeof(DIDEVCAPS);
    aDIP.Controller[aDIP.ControllerNumTotal].GetCapabilities(aDIP.ControllerCaps[aDIP.ControllerNumTotal]);

    Inc(aDIP.ControllerNumTotal);
    result := DIENUM_CONTINUE;
  end else
    result := DIENUM_STOP;

end;


function EnumMouseObjectsCallbackFunc(var lpddoi: TDIDeviceObjectInstanceA; aDIP : TDInput): BOOL; stdcall;
begin
  aDIP.MouseObjs[aDIP.aMouseObject].dwSize := Sizeof(DIDEVICEOBJECTINSTANCE);
  aDIP.Mouse.GetObjectInfo(aDIP.MouseObjs[aDIP.aMouseObject], lpddoi.dwOfs, DIPH_BYOFFSET);

  Inc(aDIP.aMouseObject);

  result := DIENUM_CONTINUE;

end;


function EnumControllerObjectsCallbackFunc(var lpddoi: TDIDeviceObjectInstanceA; aDIP : TDInput): BOOL; stdcall;
begin
  aDIP.ControllerObjs[aDIP.aControllerDevice][aDIP.aControllerObject].dwSize := Sizeof(DIDEVICEOBJECTINSTANCE);
  aDIP.Controller[aDIP.aControllerDevice].GetObjectInfo(aDIP.ControllerObjs[aDIP.aControllerDevice][aDIP.aControllerObject], lpddoi.dwOfs, DIPH_BYOFFSET);

  Inc(aDIP.aControllerObject);

  result := DIENUM_CONTINUE;
end;



constructor TDInput.Create(AOWner : TComponent);
begin

  if not Failed( DirectInput8Create(hInstance, DIRECTINPUT_VERSION, IID_IDirectInput8, dip, nil)) then begin
    // keyboard
    dip.CreateDevice(GUID_Syskeyboard, Keyb, nil);
    Keyb.SetDataFormat(c_dfDIKeyboard);
    Keyb.SetCooperativeLevel(0, DISCL_BACKGROUND + DISCL_NONEXCLUSIVE);
    KeybCaps.dwSize := Sizeof(DIDEVCAPS);
    Keyb.GetCapabilities(KeybCaps);
    Keyb.Acquire;

    // mouse
    dip.CreateDevice(GUID_SysMouse, Mouse, nil);
    Mouse.SetDataFormat(c_dfDIMouse2);
    Mouse.SetCooperativeLevel(0, DISCL_BACKGROUND + DISCL_NONEXCLUSIVE);
    MouseCaps.dwSize := sizeof(DIDEVCAPS);
    Mouse.GetCapabilities(MouseCaps);
    Mouse.Acquire;

    //SetLength(MouseObjs, MouseCaps.dwButtons);
    //Mouse.EnumObjects(@EnumMouseObjectsCallbackFunc, Self, DIDFT_BUTTON);

    // controllers
    dip.EnumDevices(DI8DEVCLASS_GAMECTRL, @EnumControllersCallbackFunc, Self, DIEDFL_ATTACHEDONLY);

    {for i := 0 to ControllerNumTotal - 1 do begin
      aControllerDevice := i;
      SetLength(ControllerObjs[i], ControllerCaps[i].dwButtons);
      Controller[i].EnumObjects(@EnumControllerObjectsCallbackFunc, Self, DIDFT_BUTTON);
    end;   }

    Inherited;

  end else
    ShowMessage(S_ERROR_DIP);
end;



procedure TDInput.ClearData;
var
  aController : Integer;
begin
  FillChar(KeybData, SizeOf(KeybData), 0);
  FillChar(MouseData, SizeOf(MouseData), 0);
  for aController := 0 to ControllerNumTotal - 1 do
    FillChar(ControllerData[aController], SizeOf(DIJOYSTATE2), 0);
end;



procedure TDInput.UpdateData;
var
  aController : Integer;
begin
  Keyb.GetDeviceState(SizeOf(KeybData), @KeybData);
  Mouse.GetDeviceState(SizeOf(MouseData), @MouseData);

  for aController := 0 to ControllerNumTotal - 1 do begin
    if Controller[aController].Poll = DIERR_INPUTLOST then begin
      Controller[aController].Acquire;
      Controller[aController].Poll;
    end;
    Controller[aController].GetDeviceState(SizeOf(DIJOYSTATE2), @ControllerData[aController]);
  end;
  
  KeybData[0] := 0;
end;



procedure TDInput.Str2CodeControl(var Key : TKeyStruct);
var
  aDIPString : String;
  aScanCode : Integer;
begin
  if not (Key.Name = '') then begin
    aDIPString := Key.Name;
    if AnsiContainsStr(aDIPString, 'Mouse') then begin
      Key.InputType := inputtypeMouse;
      Delete(aDIPString, 1, 6);
      if aDIPString = '' then
        Key.Key := 1
      else
        Key.Key := StrtoInt(aDIPString);
    end else if AnsiContainsStr(aDIPString, 'Controller') then begin
      // Controller[controlnumber]_[buttonnumber]
      Key.InputType := inputtypeController;
      Delete(aDIPString, 1, 10);
      if AnsiLeftStr(aDIPString, 2) = '' then
        Key.ControllerNum := 0
      else
        Key.ControllerNum := StrtoInt(AnsiLeftStr(aDIPString, 2)) - 1;
      Delete(aDIPString, 1, 3);
      if aDIPString = '' then
        Key.Key := 0
      else
        Key.Key := StrtoInt(aDIPString);
    end else begin
      Key.InputType := inputtypeKeyboard;
      Key.Key := 0;
      Key.Shift := [];
      if AnsiContainsStr(aDIPString, 'Ctrl') then begin
        Include(Key.Shift, ssCtrl);
        aDIPString := StringReplace(aDIPString, 'Ctrl', '', [rfReplaceAll, rfIgnoreCase]);
      end;
      if AnsiContainsStr(aDIPString, 'Shift') then begin
        Include(Key.Shift, ssShift);
        aDIPString := StringReplace(aDIPString, 'Shift', '', [rfReplaceAll, rfIgnoreCase]);
      end;
      if AnsiContainsStr(aDIPString, 'Alt') then begin
        Include(Key.Shift, ssAlt);
        aDIPString := StringReplace(aDIPString, 'Alt', '', [rfReplaceAll, rfIgnoreCase]);
      end;
      aDIPString := StringReplace(aDIPString, ' + ', '', [rfReplaceAll, rfIgnoreCase]);

      PropString.diph.dwSize := Sizeof(DIPROPSTRING);
      PropString.diph.dwHeaderSize := Sizeof(DIPROPHEADER);
      PropString.diph.dwHow := DIPH_BYOFFSET;

      for aScanCode := 2 to High(KeybData) - 1 do begin
        PropString.diph.dwObj := aScanCode;
        Keyb.GetProperty(DIPROP_KEYNAME, PropString.diph);
        if PropString.wsz = aDIPString then begin
          Key.Key := aScanCode;
          Break;
        end;
      end;
    end;
  end else
    ClearKey(Key);
end;


procedure TDInput.Str2CodeOutput(var Key : TKeyStruct);
var
  aDIPString : String;
  aScanCode : Integer;
  aPAnsiChar : PAnsiChar;
begin
  GetMem(aPAnsiChar, 50);
  if not (Key.Name = '') then begin
    aDIPString := Key.Name;
    Key.InputType := inputtypeKeyboard;
    Key.Key := 0;
    Key.Shift := [];

    for aScanCode := 2 to 255 do begin
      GetKeyNameText(aScanCode shl 16, aPAnsiChar, 50);
      if aPAnsiChar = aDIPString then begin
        Key.Key := aScanCode;
        Break;
      end;
    end;
  end else
    ClearKey(Key);
end;



procedure TDInput.StartPollControl(Key : PKeyStruct);
begin
  KeyPoll := Key;
  KeyPollCount := 0;
  timerPoll.OnTimer := PollKeyControl;
  timerPoll.Enabled := True;
end;


procedure TDInput.StartPollOutput(Key : PKeyStruct);
var
  aVK : Byte;
begin
  KeyPoll := Key;
  KeyPollCount := 0;
  for aVK := 2 to 255 do
    GetAsyncKeyState(aVK);
  timerPoll.OnTimer := PollKeyOutput;
  timerPoll.Enabled := True;
end;


procedure TDInput.PollKeyControl(Sender: TObject);
var
  keyPressed : Boolean;
  aScanCode : Byte;
  aController: Integer;
begin
  UpdateData;

  keyPressed := False;

  // escape cancels poll and clears assigned key
  if (KeybData[DIK_ESCAPE] = $80) then begin
    ClearKey(KeyPoll^);
    keyPressed := True;
  end;

  // left click cancels poll without clearing assigned key
  if (MouseData.rgbButtons[0] = $80) or (KeyPollCount > 100) then begin
    timerPoll.Enabled := False;
    FOnFinishedPoll(Self, False);
    Exit;
  end;

  // keyboard
  if not KeyPressed then begin
    for aScanCode := 2 to High(KeybData) do
      if not (aScanCode in [DIK_LCONTROL, DIK_RCONTROL, DIK_LSHIFT, DIK_RSHIFT, DIK_LALT, DIK_RALT]) and
          (KeybData[aScanCode] = $80) then begin
        KeyPoll.InputType:= inputtypeKeyboard;
        KeyPoll.Key := aScanCode;
        KeyPoll.Shift := [];
        if (KeybData[DIK_LCONTROL] = $80) or (KeybData[DIK_RCONTROL] = $80) then Include(KeyPoll.Shift, ssCtrl);
        if (KeybData[DIK_LSHIFT] = $80) or (KeybData[DIK_RSHIFT] = $80) then Include(KeyPoll.Shift, ssShift);
        if (KeybData[DIK_LALT] = $80) or (KeybData[DIK_RALT] = $80) then Include(KeyPoll.Shift, ssAlt);

        KeyPoll.Name := '';
        if ssCtrl in KeyPoll.Shift then KeyPoll.Name := KeyPoll.Name + 'Ctrl + ';
        if ssShift in KeyPoll.Shift then KeyPoll.Name := KeyPoll.Name + 'Shift + ';
        if ssAlt in KeyPoll.Shift then KeyPoll.Name := KeyPoll.Name + 'Alt + ';

        PropString.diph.dwSize := Sizeof(DIPROPSTRING);
        PropString.diph.dwHeaderSize := Sizeof(DIPROPHEADER);
        PropString.diph.dwObj := KeyPoll.Key;
        PropString.diph.dwHow := DIPH_BYOFFSET;

        Keyb.GetProperty(DIPROP_KEYNAME, PropString.diph);
        KeyPoll.Name := KeyPoll.Name + String(PropString.wsz);
        keyPressed := True;
        Break;
      end;
  end;


  // mouse, left button cannot be assigned
  if not KeyPressed then begin
    for aScanCode := 1 to MouseCaps.dwButtons do
      if MouseData.rgbButtons[aScanCode] = $80 then begin
        KeyPoll.InputType := inputtypeMouse;
        KeyPoll.Key := aScanCode;


        KeyPoll.Name := 'Mouse_' + InttoStr(KeyPoll.Key);
        //KeyPoll.Name := String(MouseObjs[aScanCode].tszName);

        keyPressed := True;
        Break;
      end;
  end;

  // controllers
  if not KeyPressed then begin
    for aController := 0 to ControllerNumTotal - 1 do
      for aScanCode := 0 to ControllerCaps[aController].dwButtons do
        if (ControllerData[aController].rgbButtons[aScanCode] = $80) then begin
          KeyPoll.InputType := inputtypeController;
          KeyPoll.ControllerNum := aController;
          KeyPoll.Key := aScanCode;

          //KeyPoll.Name := String(ControllerObjs[aController][aScanCode].tszName);
          KeyPoll.Name := 'Controller' + format('%.2d',[aController + 1]) + '_' + InttoStr(KeyPoll.Key);

          keyPressed := True;
          Break;
        end;
  end;


  if KeyPressed then begin
    timerPoll.Enabled := False;
    FOnFinishedPoll(Self, True);
  end;

  Inc(KeyPollCount);
end;



procedure TDInput.PollKeyOutput(Sender: TObject);
var
  aVK : Byte;
  i : Integer;
  aPAnsiChar : PAnsiChar;
  MouseClick : Boolean;
begin
  UpdateData;

  // escape cancels poll and clears assigned key
  if (KeybData[DIK_ESCAPE] = $80) then begin
    ClearKey(KeyPoll^);
    timerPoll.Enabled := False;
    FOnFinishedPoll(Self, True);
    Exit;
  end;

  // mouse click cancels poll without clearing assigned key
  MouseClick := False;
  for i := 0 to MouseCaps.dwButtons - 1 do
    if MouseData.rgbButtons[i] = $80 then
      MouseClick := True;
  if MouseClick or (KeyPollCount > 100) then begin
    timerPoll.Enabled := False;
    FOnFinishedPoll(Self, False);
    Exit;
  end;   

  // keyboard
  for aVK := 2 to 255 do
    if (GetAsyncKeyState(aVK) = 1) or (GetAsyncKeyState(aVK) = -32768)  then begin  // MSB indicates key down
      KeyPoll.InputType := inputtypeKeyboard;

      KeyPoll.Key := MapVirtualKeyEx(aVK, 0, GetKeyboardLayout(0));
      if aVK in [VK_INSERT, VK_DELETE, VK_HOME, VK_END, VK_NEXT, VK_PRIOR, VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN] then
        KeyPoll.Key := KeyPoll.Key or $100;  // extended

      KeyPoll.Shift := [];

      GetMem(aPAnsiChar, 50);
      GetKeyNameText(KeyPoll.Key shl 16, aPAnsiChar, 50);
      KeyPoll.Name := aPAnsiChar;

      timerPoll.Enabled := False;
      FOnFinishedPoll(Self, True);
      Break;
    end;


  Inc(KeyPollCount);
end;



function TDInput.GetKeyboardData(aKey : Integer) : byte;
begin
  Result := KeybData[aKey];
end;



function TDInput.GetMouseButtonData(aButton : Integer) : byte;
begin
  Result := MouseData.rgbButtons[aButton];
end;



function TDInput.GetControllerButtonData(aController : Integer; aButton : Integer) : byte;
begin
  Result := ControllerData[aController].rgbButtons[aButton];
end;


procedure TDInput.ClearKey(var Key : TKeyStruct);
begin
  Key.InputType:= inputtypeNone;
  Key.Key := 0;
  Key.Shift := [];
  Key.Name := '';
  Key.ControllerNum := 0;
  Key.InterPressCount := 1;
end;



destructor TDInput.Destroy;
var
  aController : Integer;
begin
  timerPoll.Enabled := False;
  Keyb.Unacquire;
  Mouse.Unacquire;
  for aController := 0 to ControllerNumTotal - 1 do
    Controller[aController].Unacquire;
end;







end.


