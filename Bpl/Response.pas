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

unit Response;

interface
uses
  Windows, Forms, Messages, SysUtils, Classes, Graphics, Controls, Math, Menus,
  ExtCtrls, IniFiles, Dialogs;

const
  WM_ASSIGN_MENU = WM_USER + 1;
  PTS_CONV = 51000;

  AXIS_SCALE = 16383;
  AXIS_RAD_SCALE = AXIS_SCALE / PI;
  AXIS_SCALE_INV = 1/AXIS_SCALE;
  AXIS_SCALE_DBL = 2*AXIS_SCALE;
  INV_PI = 1/PI;

type
  TGrabHandlePosition = (ghStart, gh1, gh2, {gh3, gh4, gh5, gh6, gh7, gh8, gh9, gh10, gh11,} ghEnd);
  TDefaultCurves = (  curveLinear, curveOnetoOne, curveSmallDeadzone, curveMediumDeadzone,
                      curveLargeDeadzone, curveSmallSmooth, curveMediumSmooth, curveLargeSmooth);
  TArray3Points = array[TGrabHandlePosition] of TPoint;
  PArray3Points = ^TArray3Points;

  TGrabEvent = procedure(Sender: TObject; sx,sy: integer) of object;
  TOnPtsUpdated = procedure(Sender: TObject; ControlUpdated: TGrabHandlePosition) of object;

  TGrabHandle = class(TCustomControl)
  private
    FCaptured: boolean;
    FControl: TControl;
    FParent: TWinControl;
    FHandlePosition: TGrabHandlePosition;
    FOnDrag: TGrabEvent;
    FOnEndDrag: TGrabEvent;
    FOnStartDrag: TGrabEvent;
    FVisible: boolean;
    function GetX: integer;
    function GetY: integer;
    procedure SetX(const Value: integer);
    procedure SetY(const Value: integer);
    procedure SetVisible(const v: boolean);
    procedure SetControl(const Value: TControl);
    procedure SetPosition;
    procedure SetPos(const Value: TPoint);
    procedure SetColor(const Value: TColor);
    function GetPos: TPoint;
  protected
    procedure SetParent(aParent : TWinControl);override;
    procedure WmMouseDown(var msg: TWmLButtonDown); message WM_LBUTTONDOWN;
    procedure WmMouseMove(var msg: TWmMouseMove); message WM_MOUSEMOVE;
    procedure WmMouseUp(var msg: TWmLButtonUp); message WM_LBUTTONUP;
  public
    constructor Create(AOwner: TComponent); override;

    procedure ResetPosition;

    property HandlePosition: TGrabHandlePosition read FHandlePosition write FHandlePosition;

    property Control: TControl read FControl write SetControl;

    property Visible: boolean read FVisible write SetVisible;
    property X : integer read GetX  write SetX;
    property Y : integer read GetY write SetY;
    property Pos : TPoint  read GetPos write SetPos;

    property OnDrag: TGrabEvent read FOnDrag write FOnDrag;
    property OnEndDrag: TGrabEvent read FOnEndDrag write FOnEndDrag;
    property OnStartDrag: TGrabEvent read FOnStartDrag write FOnStartDrag;
  end;

  TLigne = class(TControl)
  private
    FAllowMove: boolean;
    FCanvas : TCanvas;
    MyRgn : HRGN;

    fOwner : TComponent;

    FVisible: boolean;
    fOnStartDragHandle: TGrabEvent;
    fOnEndDragHandle : TGrabEvent;
    JustStarted : boolean;

    FOnControlPtsUpdated: TOnPtsUpdated;

    procedure SetVisible(const v: boolean);
    procedure GetCanvas;
    procedure FreeCanvas;

    procedure DrawSizeRect(Sender: TObject; sx,sy: integer);

    procedure GestStartDragHandle(Sender: TObject; sx,sy: integer);
    procedure GestDragHandle(Sender: TObject; sx,sy: integer);
    procedure GestEndDragHandle(Sender: TObject; sx,sy: integer);

    function GetWidth: Integer;
    procedure SetWidth(const Value: Integer);
    function GetHeight: Integer;
    procedure SetHeight(const Value: Integer);
    function GetParent: TWinControl;
    procedure SetAllowMove(const Value: boolean);

    function DistToLine(X1, Y1, X2, Y2, xpos, ypos : integer) : single;

    function GetControlPoints(aContolPoint: TGrabHandlePosition): TPoint;
    procedure SetControlPoints(aContolPoint: TGrabHandlePosition; const Value: TPoint);
  protected
    FControl: TControl;
    GrabHandles: array[TGrabHandlePosition] of TGrabHandle;

    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure SetParent(aParent: TWinControl);override;
  public
    MesPts : TArray3Points;
    constructor Create(AOwner: TComponent);override;

    property ControlPoints[ContolPoint : TGrabHandlePosition] : TPoint read GetControlPoints write SetControlPoints;
  published
    property Parent: TWinControl read GetParent write SetParent;
    property AllowMove: boolean read FAllowMove write SetAllowMove default true;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;

    property Visible : boolean read FVisible write SetVisible;

    property OnStartDragHandle: TGrabEvent read FOnStartDragHandle write FOnStartDragHandle;
    property OnEndDragHandle : TGrabEvent read fOnEndDragHandle write fOnEndDragHandle;
    property OnControlPtsUpdated : TOnPtsUpdated read FOnControlPtsUpdated write FOnControlPtsUpdated;
  end;

  TResponseCfg = Class(TPanel)
  private
    aPanel : TPanel;
    aLigne : TLigne;
    FScale: single;
    FName, FHorLabel, FVerLabel : String;
    FOnCurveChanged: TNotifyEvent;
    function GetHeight: Integer;
    function GetWidth: Integer;
    procedure SetHeight(const Value: Integer);
    procedure SetWidth(const Value: Integer);
    procedure AjustLigne;
    Function Bcalcul(t0: single): Tpoint;
    procedure DoUpdateConverted(Sender: TObject; ControlUpdated: TGrabHandlePosition);overload;
    procedure DoUpdateConverted(Sender: TObject; sx,sy: integer);overload;
    procedure UpdateConverted;
    function GetCaption: string;
    procedure SetCaption (const Value: string);
    procedure SetName(const Value : String);
    procedure SetHorLabel(const Value : String);
    procedure SetVerLabel(const Value : String);
    function GetName : String;
    function GetHorLabel : String;
    function GetVerLabel : String;

  protected
    procedure Paint;override;
    procedure Loaded;override;
  public
    Converted : array[-PTS_CONV..PTS_CONV] of single;
    Constructor Create(AOwner : TComponent);override;
    Destructor Destroy;override;

    procedure LoadCfgFromIni(aIni: TIniFile);overload;
    procedure LoadCfgFromIni(Points: PArray3Points);overload;
    procedure SaveCfgToIni(aIni: TIniFile);overload;
    procedure SaveCfgToIni(const Points: PArray3Points);overload;

    procedure Resize;override;
    procedure GetPoints(points : PArray3Points);

    procedure LoadDefaultCurve(curve : TDefaultCurves);

    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property Name: String read GetName write SetName;
    property HorLabel: String read GetHorLabel write SetHorLabel;
    property VerLabel: String read GetVerLabel write SetVerLabel;
  published
    property Caption : string read GetCaption write SetCaption;
    property OnCurveChanged : TNotifyEvent read FOnCurveChanged write FOnCurveChanged;
  end;




procedure Register;

implementation

uses Types;

type
  RPoint2D32f  = record
    x, y : Single;
  end;

  TArrayOfPoint3D32f = array of RPoint2D32f;

const
  GRAB_WIDTH = 5;
  GRAB_HEIGHT = 5;
  MIN_DIST_LIGNE = 8;
  LIGNE_WIDTH = 1;

procedure Register;
begin
  RegisterComponents('FreeTrack', [TResponseCfg]);
end;

constructor TGrabHandle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Color := clBlack;
  Width := GRAB_WIDTH;
  Height := GRAB_HEIGHT;
  FCaptured := false;
  Parent := nil;
end;



function TGrabHandle.GetX: integer;
begin
  Result := Left + Width div 2;
end;



function TGrabHandle.GetY: integer;
begin
 Result := Top + Height div 2;
end;



function TGrabHandle.GetPos: TPoint;
begin
  Result := Point(GetX, GetY);
end;



procedure TGrabHandle.SetX(const Value: integer);
begin
  Left := Value - Width div 2;// - 1;
end;



procedure TGrabHandle.SetY(const Value: integer);
begin
  Top := Value - Height div 2;// - 1;
end;


procedure TGrabHandle.SetPos(const Value: TPoint);
begin
  SetX(Value.X);
  SetY(Value.Y);
end;


procedure TGrabHandle.SetColor(const Value: TColor);
begin
  Color := Value;
end;




procedure TGrabHandle.ResetPosition;
begin
  SetPosition;
end;



procedure TGrabHandle.SetControl(const Value: TControl);
begin
   if csDestroying in ComponentState then
    Exit;

  if FControl <> Value then begin
    FControl := Value;
    if Assigned(FControl) then begin
      Parent := FControl as TWinControl;
      inherited Visible := FVisible;
      //HandleNeeded;
      SetPosition;
    end else begin
      //DestroyWindowHandle;
      inherited Visible := False;
      Parent := nil;
    end;
  end;
end;




procedure TGrabHandle.SetParent(aParent: TWinControl);
begin
  Inherited;
  FParent := aParent;
  if FVisible <> inherited Visible then
    inherited Visible := FVisible and Assigned(FParent);
end;



procedure TGrabHandle.SetPosition;
begin
  if Assigned(FControl) then begin
    case FHandlePosition of
      ghStart : begin
        Left := (Owner as TControl).Left;
        Top := (Owner as TControl).Top;
      end;

      ghEnd : begin
        Left := (Owner as TControl).Left + (Owner as TControl).Width -  GRAB_WIDTH;
        Top := (Owner as TControl).Top + (Owner as TControl).Height - GRAB_HEIGHT;
      end;
    end;

    inherited Visible := FVisible;
  end;
end;





procedure TGrabHandle.SetVisible(const v: boolean);
begin
  if FVisible <> v then begin
    FVisible := v;
    inherited Visible := FVisible and Assigned(Parent);

    if FVisible then
      Invalidate;
  end;
end;



procedure TGrabHandle.WmMouseDown(var msg: TWmLButtonDown);
var pt: TPoint;
begin
  if not FCaptured and ((MK_LBUTTON and msg.keys) <> 0) then begin
    SetCaptureControl(Self);
    FCaptured := true;
    if Assigned(FOnStartDrag) then begin
      pt := ClientToScreen(Point(msg.xpos, msg.ypos));
      FOnStartDrag(Self, pt.x, pt.y);
    end;
  end;
end;



procedure TGrabHandle.WmMouseMove(var msg: TWmMouseMove);
var pt: TPoint;
begin
  inherited;
  if FCaptured and Assigned(FOnDrag) then begin
    pt := ClientToScreen(Point(msg.xpos, msg.ypos));
    FOnDrag(Self, pt.x, pt.y);
  end;
end;



procedure TGrabHandle.WmMouseUp(var msg: TWmLButtonUp);
var pt: TPoint;
begin
  inherited;
  if FCaptured then begin
    if (MK_LBUTTON and msg.keys) = 0 then begin
      SetCaptureControl(nil);
      FCaptured := false;
      pt := ClientToScreen(Point(msg.xpos, msg.ypos));
      if Assigned(FOnEndDrag) then
        FOnEndDrag(Self, pt.x, pt.y);
    end;
  end;
end;


constructor TLigne.Create(AOwner: TComponent);
var
   h: TGrabHandlePosition;
begin
  inherited Create(AOwner);
  fOwner := AOwner;

  FAllowMove := true;
  //FMinimumMove := 3;

  //if not (csDesigning in ComponentState) then begin
    for h := low(TGrabHandlePosition) to High(TGrabHandlePosition) do begin
      GrabHandles[h] := TGrabHandle.Create(Self);
      GrabHandles[h].HandlePosition := h;
      GrabHandles[h].OnStartDrag := GestStartDragHandle;
      GrabHandles[h].OnDrag := GestDragHandle;
      GrabHandles[h].OnEndDrag := GestEndDragHandle;
      GrabHandles[h].Parent := FControl as TWinControl;
      GrabHandles[h].Visible := True;
    end;

  Visible := True;
end;




procedure TLigne.GestStartDragHandle(Sender: TObject; sx,sy: integer);
var
  aRect : TRect;
begin

  if Assigned(fOnStartDragHandle) then
    fOnStartDragHandle(Sender, sx, sy);

  SetVisible(False);
  if Assigned(FControl.Parent) then
    FControl.Parent.Repaint;  { to repaint under invisible GrabHandles }
  FControl.Repaint;          { to repaint under invisible GrabHandles }

  GetCanvas;

  //Limitation deplacement souris
  if Sender = GrabHandles[ghStart] then
    // BUGFIX: zero point was 3 pixels out of range
    aRect := Rect(0, FControl.Height-2, 1, FControl.Height-1)

  else if Sender = GrabHandles[ghEnd] then begin
   // if sx > Fcontrol.Width - 10 then
      aRect := Rect(0, 2, FControl.Width - 1, 2);   //FControl.Height
    //else
     // aRect := Rect(FControl.Width, 2, FControl.Width-1, 2);   //FControl.Height
  end else begin
    aRect := FControl.ClientRect;
    InflateRect(aRect, -(Sender as TGrabHandle).Width div 2, -(Sender as TGrabHandle).Height div 2)
    //InflateRect(aRect, -GrabHandles[gh3].X, -GrabHandles[gh3].Y);
  end;

  OffsetRect(aRect, FControl.ClientOrigin.X, FControl.ClientOrigin.Y);
  ClipCursor(@aRect);

  JustStarted := True;

end;



procedure TLigne.GestDragHandle(Sender: TObject; sx,sy: integer);
var
  aPt : TPoint;
  h: TGrabHandlePosition;
begin
  if JustStarted then
    JustStarted := False
  else begin
    FCanvas.PolyBezier(MesPts);
    {Form1.Memo1.Lines.Add('');
    Form1.Memo1.Lines.Add(Format('Erasing (%d;%d) (%d;%d) (%d;%d) (%d;%d)'; [
                          MesPts[0].X; MesPts[0].Y;
                          MesPts[1].X; MesPts[1].Y;
                          MesPts[2].X; MesPts[2].Y;
                          MesPts[3].X; MesPts[3].Y]));}
  end;

  aPt := FControl.ScreenToClient( Point(sx, sy));

  (Sender as TGrabHandle).Pos := aPt;
  for h := low(TGrabHandlePosition) to High(TGrabHandlePosition) do
    if GrabHandles[h] = Sender then begin
      MesPts[h] := aPt;
      Break;
    end;

  FCanvas.PolyBezier(MesPts);

  {Form1.Memo1.Lines.Add(Format('Drawing (%d;%d) (%d;%d) (%d;%d) (%d;%d)'; [
                          MesPts[0].X; MesPts[0].Y; MesPts[1].X; MesPts[1].Y;
                          MesPts[2].X; MesPts[2].Y;
                          MesPts[3].X; MesPts[3].Y]));}
end;



procedure TLigne.GestEndDragHandle(Sender: TObject; sx,sy: integer);
var
  NewPos: TPoint;
begin
  if not Assigned(FControl) then
    Exit;

  if (Sender <> GrabHandles[gh1]) and (Sender <> GrabHandles[gh2]) then begin
    NewPos := FControl.ScreenToClient(Point(sx, sy));
    (Sender as TGrabHandle).X := NewPos.x;
    (Sender as TGrabHandle).Y := NewPos.Y;

    if Sender = GrabHandles[ghStart] then
      GrabHandles[ghEnd].Invalidate
    else
      GrabHandles[ghStart].Invalidate;

    FreeCanvas;


    Left := MinIntValue([GrabHandles[ghStart].Left, GrabHandles[ghEnd].Left]);
    Top := MinIntValue([GrabHandles[ghStart].Top, GrabHandles[ghEnd].Top]);
    inherited Width := Abs(GrabHandles[ghStart].Left - GrabHandles[ghEnd].Left) + GRAB_WIDTH;
    inherited Height := Abs(GrabHandles[ghStart].Top - GrabHandles[ghEnd].Top) + GRAB_HEIGHT;

//test  FCanvas.Rectangle( BoundsRect) ;
//test  FreeCanvas;
  end;

  ClipCursor(nil);

  if Assigned(fOnEndDragHandle) then
    fOnEndDragHandle(Sender, sx, sy);

  SetVisible(True);
  if Assigned(FControl.Parent) then
    FControl.Parent.Repaint;  { to repaint under invisible GrabHandles }
  FControl.Repaint;          { to repaint under invisible GrabHandles }
end;



procedure TLigne.SetVisible(const v: boolean);
var h: TGrabHandlePosition;
begin
  inherited;
  FVisible := V;
  for h := low(TGrabHandlePosition) to high(TGrabHandlePosition) do
    if Assigned(GrabHandles[h]) then
      if v then
        GrabHandles[h].Visible := FAllowMove
      else
        GrabHandles[h].Visible := v;

  if V then begin
    Left := MinIntValue([GrabHandles[ghStart].Left, GrabHandles[ghEnd].Left]);
    Top := MinIntValue([GrabHandles[ghStart].Top, GrabHandles[ghEnd].Top]);

    inherited Width  := Abs(GrabHandles[ghStart].Left - GrabHandles[ghEnd].Left) + GRAB_WIDTH;
    inherited Height := Abs(GrabHandles[ghStart].Top - GrabHandles[ghEnd].Top) + GRAB_HEIGHT;
  end;
end;



procedure TLigne.FreeCanvas;
var
   h: THandle;
begin
  if Assigned(FCanvas) then begin
    
    SelectClipRgn(FCanvas.Handle, 0);
    DeleteObject(MyRgn);

    h := FCanvas.Handle;
    FCanvas.Handle := 0;
    ReleaseDC(Parent.Handle, h);
    FCanvas.Free;
    FCanvas := nil;
  end;
end;




procedure TLigne.GetCanvas;
var
  h: THandle;
begin
  h := 0;
  FCanvas := TCanvas.Create;
  try
    h := GetWindowDC(Parent.Handle);
    FCanvas.Handle := h;
    FCanvas.Brush.Color := clBlack;
    FCanvas.Brush.Style := bsClear;

    FCanvas.Pen.Color := clBlack;
    FCanvas.Pen.Style := psSolid;
    FCanvas.Pen.Mode  := pmNot;
    FCanvas.Pen.Width := LIGNE_WIDTH;

  except
    FCanvas.Handle := 0;
    if h <> 0 then
      ReleaseDC(Parent.Handle, h);
    FCanvas.Free;
    FCanvas := nil;
  end;
end;



procedure TLigne.DrawSizeRect(Sender: TObject; sx,sy: integer);
{var
  Origin : TPoint;
  aPt : TPoint;}
begin
  {if not Assigned(FControl) or not Assigned(FCanvas) then
    Exit;

  if Sender = GrabHandles[ghStart] then
    Origin := ( Point(GrabHandles[ghEnd].X; GrabHandles[ghEnd].Y))
  else
    Origin := ( Point(GrabHandles[ghStart].X; GrabHandles[ghStart].Y));

  FCanvas.PenPos := Origin;
  if JustStarted then
    JustStarted := False
  else begin
    aPt := FControl.ScreenToClient(FLastGrabPos);
    FCanvas.LineTo(aPt.X; aPt.Y);
  end;

  FCanvas.PenPos := Origin;
  aPt := FControl.ScreenToClient(Point(sx; sy));
  FCanvas.LineTo(aPt.X; aPt.Y);

  FLastGrabPos := Point(sx; sy);}
end;




procedure TLigne.WMPaint(var Msg: TWMPaint);
var
  TempCanvas : TControlCanvas;
  points : array[0..50] of TPoint;
  i : Integer;
  x1, y1 : Single;
begin
  if not Visible then
    Exit;

  TempCanvas := TControlCanvas.Create;
  TempCanvas.Control := FControl;

  TempCanvas.Pen.Color := clGray;
  TempCanvas.Pen.Style := psSolid;

  // linear guide line
  TempCanvas.Polyline([Point(0,FControl.Height), Point(GrabHandles[ghEnd].X, 0)]);


  TempCanvas.Pen.Width := LIGNE_WIDTH;
  TempCanvas.Pen.Color := clBlack;
  TempCanvas.Pen.Style := psSolid;
  //TempCanvas.PolyBezier(MesPts);

  {GrabHandles[ghStart].Color := clRed;
  GrabHandles[gh3].Color := clRed;
  GrabHandles[gh6].Color := clRed;
  GrabHandles[gh9].Color := clRed;
  GrabHandles[ghEnd].Color := clRed; }

  SetBkMode(TempCanvas.Handle, TRANSPARENT);
  TempCanvas.TextOut(FControl.Width div 2 - 20, FControl.Height - 40, ' ' + (fOwner as TResponseCfg).Name + ' ');
  TempCanvas.TextOut(1, 5, ' ' + (fOwner as TResponseCfg).VerLabel + ' ');
  TempCanvas.TextOut(FControl.Width - 40, FControl.Height - 15, ' ' + (fOwner as TResponseCfg).HorLabel + ' ');

  for i := 0 to 50 do begin
    x1 := 2 * Trunc(RadToDeg((fOwner as TResponseCfg).Converted[round(i * 1000)]));
    y1 := 100 - 2*i;
    points[i] := Point(Round(x1), Round(y1));
  end;   


  TempCanvas.Polyline(points);

  TempCanvas.Free;
end;



function TLigne.GetWidth: Integer;
begin
  Result := inherited Width;
end;



procedure TLigne.SetWidth(const Value: Integer);
begin
  inherited Width := Value;
  GrabHandles[ghStart].ResetPosition;
  GrabHandles[ghEnd].ResetPosition;
end;



function TLigne.GetHeight: Integer;
begin
 Result := inherited Height;
end;



procedure TLigne.SetHeight(const Value: Integer);
begin
  inherited Height := Value;
  GrabHandles[ghStart].ResetPosition;
  GrabHandles[ghEnd].ResetPosition;
end;


function TLigne.GetParent: TWinControl;
begin
  Result := inherited Parent;
end;



procedure TLigne.SetParent(aParent: TWinControl);
var
  h : TGrabHandlePosition;
begin
  if csDestroying in ComponentState then begin
    inherited;
    Exit;
  end;

  if inherited Parent <> aParent then begin
    inherited;
    FControl := aParent;
    for h := low(TGrabHandlePosition) to high(TGrabHandlePosition) do
      if Assigned(GrabHandles[h]) then
        GrabHandles[h].Control := FControl;
  end;
end;



procedure TLigne.SetAllowMove(const Value: boolean);
var
  h : TGrabHandlePosition;
begin
  FAllowMove := Value;
  for h := low(TGrabHandlePosition) to high(TGrabHandlePosition) do
    GrabHandles[h].Visible := Value;
end;



function TLigne.DistToLine(X1, Y1, X2, Y2, xpos, ypos : integer): single;
begin
  Result := (Y2 - Y1) * (Left + xpos) - (X2 - X1) * (Top + ypos) - X1 * (Y2 - Y1) + Y1 * (X2 - X1);
  Result := Abs(Result / Sqrt( Sqr(Y2 - Y1) + Sqr( X2 - X1)));
end;



function TLigne.GetControlPoints(aContolPoint: TGrabHandlePosition): TPoint;
begin
  Result := Point(GrabHandles[aContolPoint].X, GrabHandles[aContolPoint].Y);
end;



procedure TLigne.SetControlPoints(aContolPoint: TGrabHandlePosition; const Value: TPoint);
begin
  GrabHandles[aContolPoint].X := Value.X;
  GrabHandles[aContolPoint].Y := Value.Y;
  MesPts[aContolPoint] := Value;
  if Assigned(FOnControlPtsUpdated ) then
    FOnControlPtsUpdated(Self, aContolPoint);
end;



{ TResponseCfg }

constructor TResponseCfg.Create(AOwner: TComponent);
begin
  inherited;
  FScale := 1;

  aPanel := TPanel.Create(Self);
  aPanel.Top := 1;
  aPanel.Left := 22;
  aPanel.Color := $00A56D3A;
  aPanel.Parent := Self;
  aPanel.BevelOuter := bvNone;
  aPanel.Anchors := [akLeft, akTop, akRight, akBottom];
  aPanel.Visible := True;

  aLigne := TLigne.Create(Self);
  aLigne.Parent := aPanel;

  aLigne.OnControlPtsUpdated := DoUpdateConverted;
  aLigne.OnEndDragHandle := DoUpdateConverted;

  aPanel.Width := Width - aPanel.Left - 1;
  aPanel.Height := Height - 16;

  LoadDefaultCurve(curveMediumDeadzone);
end;



procedure TResponseCfg.Loaded;
begin
  inherited;

  // seems to be needed for Response data to be loaded properly into Converted
  aPanel.Width := Width - aPanel.Left - 1;
  aPanel.Height := Height - 16;

  AjustLigne;

  //UpdateConverted;
  //aPanel.Repaint;
end;



destructor TResponseCfg.Destroy;
begin
  FreeAndNil(aLigne);
  FreeAndNil( aPanel);
  
  inherited;
end;



function TResponseCfg.GetHeight: Integer;
begin
  Result := inherited Height;
end;



function TResponseCfg.GetWidth: Integer;
begin
  Result := inherited Width;
end;





procedure TResponseCfg.SetHeight(const Value: Integer);
var
  aRect : TRect;
begin
  inherited Height := Value;
  AlignControls(aPanel, aRect);
  AjustLigne;
end;


function TResponseCfg.GetName : String;
begin
  Result := FName;
end;


function TResponseCfg.GetHorLabel : String;
begin
  Result := FHorLabel;
end;


function TResponseCfg.GetVerLabel : String;
begin
  Result := FVerLabel;
end;



procedure TResponseCfg.SetWidth(const Value: Integer);
var
  aRect : TRect;
begin
  inherited Width := Value;
  AlignControls(aPanel, aRect);
  AjustLigne;
end;


procedure TResponseCfg.SetName(const Value : String);
begin
  FName := Value;
end;


procedure TResponseCfg.SetHorLabel(const Value : String);
begin
  FHorLabel := Value;
end;


procedure TResponseCfg.SetVerLabel(const Value : String);
begin
  FVerLabel := Value;
end;

procedure TResponseCfg.AjustLigne;
begin
  aLigne.ControlPoints[ghStart] := Point(0, aLigne.Parent.Height-2);
  aLigne.ControlPoints[ghEnd] := Point(Min(aLigne.ControlPoints[ghEnd].X,  aLigne.Parent.Width), 2);
end;



procedure TResponseCfg.Paint;
var
  i, j,
  xSize, ySize : integer;
begin
  inherited;

  ySize := Canvas.TextHeight('1') div 2;

  i := aPanel.Height;
  while i > 0 do begin
    Canvas.PenPos := Point(22, i);
    Canvas.LineTo(18, i);

    j := (aPanel.Height - i) div 2; //3
    if (j mod 10) = 0 then begin
      xSize := Canvas.TextWidth(IntToStr(j));
      Canvas.TextOut(16 - xSize, i - ySize, IntToStr(j));
    end;
    Dec(i, 40);
  end;

  i := aPanel.Left;
  while (i - aPanel.Left) < aPanel.Width do begin
    Canvas.PenPos := Point(i, aPanel.Height);
    Canvas.LineTo(i, aPanel.Height + 4);

    j := (i - aPanel.Left) div 2;
    if (j mod 10) = 0 then begin
      xSize := Canvas.TextWidth(IntToStr(j)) div 2;
      Canvas.TextOut(i - xSize, aPanel.Height + 2, IntToStr(j));
    end;
    Inc(i, 40);
  end;
end;



procedure TResponseCfg.DoUpdateConverted(Sender: TObject; ControlUpdated: TGrabHandlePosition);
begin
  UpdateConverted;
end;



procedure TResponseCfg.DoUpdateConverted(Sender: TObject; sx,sy: integer);
begin
  UpdateConverted;
  if Assigned(FOnCurveChanged) then
    FOnCurveChanged(Self);
  aPanel.Repaint;
end;



procedure TResponseCfg.UpdateConverted;
var
  y : integer;
//  Tempo : array[0..90] of integer;
 // count, i : Integer;
begin
  if csDesigning in ComponentState then
    Exit;
  FillChar(Converted, SizeOf(Converted), 0);
  //FillChar(Tempo; SizeOf(Tempo); 0);

  {t := 0;
  while t <= 2 do begin
    aPt := Bcalcul(t);

    //Converted[tcRadian, aPt.y div 2] := aPt.X / (aPanel.Width - 18) * 2/3*PI;
    Converted[tcRadian, aPt.y] := aPt.X / (aPanel.Width - 18);// * 2/3*PI;
    t := t + 0.001;
  end;}
  Bcalcul(0);

  // fill negative with mirrored data
  for y := 1 to High(Converted) do
    Converted[-y] := -Converted[y];

  {Count := 0;
  for i := Low(Converted[tcRadian]) to High(Converted[tcRadian]) do
    if Converted[tcRadian, i] = 0 then
      Inc(count);

  if count > 200 then
  showmessage(InttoStr(count));  }

end;



Function TResponseCfg.Bcalcul(t0: single): Tpoint;
  function Point2D32f(a, b : single) : RPoint2D32f;
  begin
    Result.x := a;
    Result.y := b;
  end;
var
  x2,y2: Single;
  t : Single;	    //the time interval
  temp1, temp2 : Single;
  n, i, y2_current, y2_previous : Integer;
  aPoint : TGrabHandlePosition;
  Points1, Points2, Points3, Points4 : array[0..3] of RPoint2D32f;
  Points : TArrayOfPoint3D32f;
  P1, C1, C2, P2 : RPoint2D32f;
const
  k = 0.0001;// AXIS_SCALE_INV; 	//time step value for drawing curve
  NChooseI : array[0..3] of Integer = (1, 3, 3, 1);
begin

  {for aPoint := ghStart to gh3 do
    Points1[Ord(aPoint)] := Point2D32f(aLigne.GrabHandles[aPoint].Pos.X div 2, (aPanel.Height -2 -aLigne.GrabHandles[aPoint].Pos.Y) div 2);

  for aPoint := gh3 to gh6 do
    Points2[Ord(aPoint) - 3] := Point2D32f(aLigne.GrabHandles[aPoint].Pos.X div 2, (aPanel.Height -2 -aLigne.GrabHandles[aPoint].Pos.Y) div 2);

  for aPoint := gh6 to gh9 do
    Points3[Ord(aPoint) - 6] := Point2D32f(aLigne.GrabHandles[aPoint].Pos.X div 2, (aPanel.Height -2 -aLigne.GrabHandles[aPoint].Pos.Y) div 2);

  for aPoint := gh9 to ghEnd do
    Points4[Ord(aPoint) - 9] := Point2D32f(aLigne.GrabHandles[aPoint].Pos.X div 2, (aPanel.Height -2 -aLigne.GrabHandles[aPoint].Pos.Y) div 2);
          }
  P1 := Point2D32f(aLigne.GrabHandles[ghStart].Pos.X/2, (aPanel.Height -2 -aLigne.GrabHandles[ghStart].Pos.Y)/2);
  C1 := Point2D32f(aLigne.GrabHandles[gh1].Pos.X/2, (aPanel.Height -2 -aLigne.GrabHandles[gh1].Pos.Y)/2);
  C2 := Point2D32f(aLigne.GrabHandles[gh2].Pos.X/2, (aPanel.Height -2 -aLigne.GrabHandles[gh2].Pos.Y)/2);
  P2 := Point2D32f(aLigne.GrabHandles[ghEnd].Pos.X/2, (aPanel.Height -2 -aLigne.GrabHandles[ghEnd].Pos.Y)/2);


  //Bernstein polynomial:  (n Choose i) * t^i * (1-t)^(n-i)
  // 3rd order Bernstein is a Bezier curve,
  // join four 3rd order Beziers together
  // parametric parameter is t on [0, 1]

  y2_previous := 0;
	t := k;
  repeat
    x2 := 0;
    y2 := 0;


   { if t < 0.25 then begin
      Points := @Points1;
      temp1 := 4*t;
    end else if t < 0.5 then begin
      Points := @Points2;
      temp1 := 4*(t - 0.25);
    end else if t < 0.75 then begin
      Points := @Points3;
      temp1 := 4*(t - 0.5);
    end else begin
      Points := @Points4;
      temp1 := 4*(t - 0.75);
    end;
    temp2 := 1 - temp1;

    for i := 0 to 3 do begin
      x2 := x2 + NChooseI[i] * power(temp1, i) * power(temp2, 3 - i) * Points[i].X;
      y2 := y2 + NChooseI[i] * power(temp1, i) * power(temp2, 3 - i) * Points[i].Y;
    end; }

    x2 := (P1.x+t*(-P1.x*3+t*(3*P1.x - P1.x*t)))+t*(3*C1.x+t*(-6*C1.x+
          C1.x*3*t))+t*t*(C2.x*3-C2.x*3*t)+ P2.x*t*t*t;

    y2 := (P1.y+t*(-P1.y*3+t*(3*P1.y- P1.y*t)))+t*(3*C1.y+t*(-6*C1.y+
          C1.y*3*t))+t*t*(C2.y*3-C2.y*3*t)+ P2.y*t*t*t;

    //draw curve
    //offscreenG.drawLine((int)x1,(int)y1,(int)x2,(int)y2);

    // ensure that array elements that are skipped over have correct value
    y2_current := trunc(y2*1000);
    for i := 1 to (y2_current - y2_previous) do
      Converted[y2_previous + i] := DegToRad(x2);
    y2_previous := y2_current;

    t := t + k;
	until t >= 1+k;  


end;




procedure TResponseCfg.LoadCfgFromIni(aIni: TIniFile);
var
  aPoint : TGrabHandlePosition;
begin
  if aIni.SectionExists(Name) then
    for aPoint := Low(TGrabHandlePosition) to High(TGrabHandlePosition) do
      aLigne.ControlPoints[aPoint] := Point(aIni.ReadInteger(Name, 'X_Ctrl' + InttoStr(Ord(aPoint)), 0),
                                           aIni.ReadInteger(Name, 'Y_Ctrl' + InttoStr(Ord(aPoint)), 0));
  UpdateConverted;
end;



procedure TResponseCfg.LoadCfgFromIni(Points: PArray3Points);
var
  aPoint : TGrabHandlePosition;
begin
  for aPoint := Low(TGrabHandlePosition) to High(TGrabHandlePosition) do
    aLigne.ControlPoints[aPoint] := Points[aPoint];

  UpdateConverted;
  aPanel.Repaint;
end;



procedure TResponseCfg.SaveCfgToIni(aIni: TIniFile);
var
  aPoint : TGrabHandlePosition;
begin
  for aPoint := Low(TGrabHandlePosition) to High(TGrabHandlePosition) do begin
    aIni.WriteInteger(Name, 'X_Ctrl' + InttoStr(Ord(aPoint)), aLigne.GrabHandles[aPoint].Pos.X);
    aIni.WriteInteger(Name, 'Y_Ctrl' + InttoStr(Ord(aPoint)), aLigne.GrabHandles[aPoint].Pos.Y);
  end;
end;



procedure TResponseCfg.SaveCfgToIni(const Points: PArray3Points);
var
  aPoint : TGrabHandlePosition;
begin
  for aPoint := Low(TGrabHandlePosition) to High(TGrabHandlePosition) do
    Points[aPoint] := aLigne.ControlPoints[aPoint];
end;


procedure TResponseCfg.SetCaption(const Value: String);
begin
  inherited Caption := Value;
  aPanel.Caption := Value;
end;



function TResponseCfg.GetCaption: string;
begin
  Result := inherited Caption;
end;



procedure TResponseCfg.Resize;
begin
  inherited;
  AjustLigne;
end;


procedure TResponseCfg.LoadDefaultCurve(curve : TDefaultCurves);
begin
  case curve of
    curveLinear : begin
      aLigne.ControlPoints[ghStart] := Point(0, 102);
      aLigne.ControlPoints[gh1] := Point(53, 85);
      aLigne.ControlPoints[gh2] := Point(106, 69);
      {aLigne.ControlPoints[gh3] := Point(160, 52);
      aLigne.ControlPoints[gh4] := Point(213, 35);
      aLigne.ControlPoints[gh5] := Point(266, 19);
      aLigne.ControlPoints[gh6] := Point(266, 19);
      aLigne.ControlPoints[gh7] := Point(266, 19);
      aLigne.ControlPoints[gh8] := Point(266, 19);
      aLigne.ControlPoints[gh9] := Point(266, 19);  }
      aLigne.ControlPoints[ghEnd ] := Point(320, 2);
    end;
    curveOnetoOne : begin
      aLigne.ControlPoints[ghStart] := Point(0, 102);
      aLigne.ControlPoints[gh1] := Point(35, 69);
      aLigne.ControlPoints[gh2] := Point(69, 35);
      aLigne.ControlPoints[ghEnd ] := Point(102, 2);
    end;
    curveSmallDeadzone : begin
      aLigne.ControlPoints[ghStart] := Point(0, 102);
      aLigne.ControlPoints[gh1] := Point(2, 92);
      aLigne.ControlPoints[gh2] := Point(2, 85);
      aLigne.ControlPoints[ghEnd ] := Point(320, 2);
    end;
    curveMediumDeadzone : begin
      aLigne.ControlPoints[ghStart] := Point(0, 102);
      aLigne.ControlPoints[gh1] := Point(2, 69);
      aLigne.ControlPoints[gh2] := Point(2, 77);
      aLigne.ControlPoints[ghEnd ] := Point(320, 2);
    end;
    curveLargeDeadzone : begin
      aLigne.ControlPoints[ghStart] := Point(0, 102);
      aLigne.ControlPoints[gh1] := Point(2, 53);
      aLigne.ControlPoints[gh2] := Point(2, 54);
      aLigne.ControlPoints[ghEnd ] := Point(320, 2);
    end;
    curveSmallSmooth : begin
      aLigne.ControlPoints[ghStart] := Point(0, 102);
      aLigne.ControlPoints[gh1] := Point(33, 66);
      aLigne.ControlPoints[gh2] := Point(146, 29);
      aLigne.ControlPoints[ghEnd ] := Point(320, 2);
    end;
    curveMediumSmooth : begin
      aLigne.ControlPoints[ghStart] := Point(0, 102);
      aLigne.ControlPoints[gh1] := Point(27, 52);
      aLigne.ControlPoints[gh2] := Point(137, 21);
      aLigne.ControlPoints[ghEnd ] := Point(320, 2);
    end;
    curveLargeSmooth : begin
      aLigne.ControlPoints[ghStart] := Point(0, 102);
      aLigne.ControlPoints[gh1] := Point(9, 41);
      aLigne.ControlPoints[gh2] := Point(95, 16);
      aLigne.ControlPoints[ghEnd ] := Point(320, 2);
    end;

  end;
  UpdateConverted;
  aPanel.Repaint;
  if Assigned(FOnCurveChanged) then
    FOnCurveChanged(Self);
end;


procedure TResponseCfg.GetPoints(points : PArray3Points);
var
  aPoint : TGrabHandlePosition;
begin
  for aPoint := Low(TGrabHandlePosition) to High(TGrabHandlePosition) do
    Points[aPoint] := aLigne.ControlPoints[aPoint];
end;




end.
