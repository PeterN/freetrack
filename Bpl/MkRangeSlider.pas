{******************************************************************************}
{                  MkRangeSlider.PAS - Range slider                            }
{                  v1.0  march 2002                                            }
{                        by Michael Kochiashvili                               }
{                        kochini@iberiapac.ge                                  }
{                        http://www.iberiapac.ge/~kochini/                     }
{******************************************************************************}
unit MkRangeSlider; interface
uses SysUtils, Messages, Windows, Classes, Controls, ExtCtrls, Graphics,
  Dialogs;

type
  EmkRangeSlider = class(Exception);
  TmkRangeSlider = class;

  TmkPositionChangeEvent = procedure(Sender: TObject; Value : integer) of object;
  TmkGetRullerLength = procedure( Sender: TObject; var Value : integer) of object;

  TmkPointsArray = record
    Origin : TPoint;
    Points : array of TPoint;
    end;
  TmkOrientation = ( rsHorizontal, rsVertical);
  TmkTickStyle   = ( rsBottomRight, rsTopLeft);
  TmkThumbStyle  = ( rsStandard, rsTriangle, rsCorner, rsArrow, rsRectangle);
  TmkMoveSliders = ( rsMinSlider, rsMaxSlider, rsBothSliders);

  // Thumbnail bitmap for slider
  TmkThumbBitmap = class( TBitMap)
  private
    FSlider: TmkRangeSlider;
    FOrigin: TPoint;
    Bkg : TBitMap;
    BkgRect : TRect;
    FInitialDrawing: boolean;
  protected
    property Slider : TmkRangeSlider read FSlider write FSlider;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Origin : TPoint read FOrigin write FOrigin;
    { When true Draw saves initial background and then resets InitialDrawing}
    property InitialDrawing : boolean write FInitialDrawing;
    { draws bitmap on Canvas at Value position
      relative to Ruller's middle line using Origin}
    procedure Draw( ACanvas : TCanvas; Value : integer; Orientation : TmkOrientation);reintroduce;
    function MyPoint( X, Y : integer) : boolean;
    end;

  TmkRangeSlider = class( TCustomControl)
  private
    FMaxPosition: integer;
    FMinPosition: integer;
    FMax: integer;
    FMin: integer;
    FOrientation: TmkOrientation;
    FTickStyle: TmkTickStyle;
    FFrequency: integer;
    FThumbStyle: TmkThumbStyle;
    FOnMinChange: TmkPositionChangeEvent;
    FOnMaxPosChange: TmkPositionChangeEvent;
    FOnMaxChange: TmkPositionChangeEvent;
    FOnMinPosChange: TmkPositionChangeEvent;
    FOnChange: TNotifyEvent;
    FRullerWidth: integer;
    FOnGetRullerLength: TmkGetRullerLength;
    FOnBeforeChange: TNotifyEvent;
    FValue: integer;
    FColorLow: TColor;
    FColorHi: TColor;
    FColorMid: TColor;

    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;

    procedure SetMaxPosition(const Value: integer);
    procedure SetMinPosition(const Value: integer);
    procedure SetMax(const Value: integer);
    procedure SetMin(const Value: integer);
    procedure SetOrientation(const Value: TmkOrientation);
    procedure SetTickStyle(const Value: TmkTickStyle);
    procedure SetFrequency(const Value: integer);
    procedure SetThumbStyle(const Value: TmkThumbStyle);
    procedure SetRullerWidth(const Value: integer);
    procedure SetOnGetRullerLength(const Value: TmkGetRullerLength);
    procedure SetOnBeforeChange(const Value: TNotifyEvent);
  protected
    FDragging: Boolean;
    FDragOffset : integer;
    FDragThumb : TmkThumbBitmap;
    FOldMinPos, FOldMaxPos : integer;
    FGenerateChangeEvent : boolean;
    FScaleFactor : integer;
    MinThumb, MaxThumb : TmkThumbBitmap;
    ThumbPoints : TmkPointsArray;
    FRullerRect : TRect;
    FPixelsPerStep : double; // pixels per one unit
    FRullerLength : integer; // ruller length

    { preparing Thumbnail Points}
    procedure MakePointsArray( Style : TmkThumbStyle);
    function MakeThumbPoints( PA : TmkPointsArray;
                              Flip : boolean;
                              Scale : integer;
                              RotateClockSteps : integer
                              ) : TmkPointsArray;
    function GetThumbDimensions( PA : TmkPointsArray) : TPoint;
    procedure CreateThumbBmp( Bmp : TmkThumbBitmap; PA : TmkPointsArray);

    procedure CheckPositionValues;
    procedure MoveSlider( Slider : TmkMoveSliders; Value : integer);

    procedure CreateThumbnails; // Create thumbnail Bitmaps
    procedure CalcRullerDimensions;
    procedure DrawRuller( ACanvas : TCanvas);
    procedure DrawMinThumb( ACanvas : TCanvas);
    procedure DrawMaxThumb( ACanvas : TCanvas);

    procedure Paint; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    property RullerWidth : integer read FRullerWidth write SetRullerWidth;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property RullerRect : TRect read FRullerRect;
    property RullerLength : integer read FRullerLength;
    function ValueToPix( Value : integer) : integer;
    function PixToValue( Pix : integer) : integer;
    { Duplicates KeyDown for}
    procedure DoKeyDown( var Key: Word; Shift: TShiftState);
  published
    property Min : integer read FMin write SetMin;
    property Max : integer read FMax write SetMax;
    property MinPosition : integer read FMinPosition write SetMinPosition;
    property MaxPosition : integer read FMaxPosition write SetMaxPosition;
    property Value : integer read FValue write FValue;
    { If Frequecy = 0 the ticks are autocalculated}
    property Frequency : integer read FFrequency write SetFrequency default 0;
    property Orientation : TmkOrientation read FOrientation write SetOrientation default rsHorizontal;
    property TickStyle : TmkTickStyle read FTickStyle write SetTickStyle default rsBottomRight;
    property ThumbStyle : TmkThumbStyle read FThumbStyle write SetThumbStyle default rsStandard;
    property ColorLow : TColor read FColorLow write FColorLow;
    property ColorMid : TColor read FColorMid write FColorMid;
    property ColorHi : TColor read FColorHi write FColorHi;

    property OnMinChange : TmkPositionChangeEvent read FOnMinChange write FOnMinChange;
    property OnMaxChange : TmkPositionChangeEvent read FOnMaxChange write FOnMaxChange;
    property OnMaxPosChange : TmkPositionChangeEvent read FOnMaxPosChange write FOnMaxPosChange;
    property OnMinPosChange : TmkPositionChangeEvent read FOnMinPosChange write FOnMinPosChange;
    property OnChange : TNotifyEvent read FOnChange write FOnChange;
    { If assigned then calculate ruller length and return in Value
      If Value = 0 then autoLength}
    property OnGetRullerLength : TmkGetRullerLength read FOnGetRullerLength write SetOnGetRullerLength;

    { Useful to store values before they changed}
    property OnBeforeChange : TNotifyEvent read FOnBeforeChange write SetOnBeforeChange;

    property Align;
    property Anchors;
    property Constraints;
    property Enabled;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
  end;


implementation


const
  { First point (0-index) of this array is Origin}
  mktpStandardPoints : array[0..4] of TPoint = (
    ( X:3; Y:3), ( X:0; Y:0), ( X:3; Y:0), ( X:3; Y:7), ( X:0; Y:4));
  mktpTrianglePoints : array[0..3] of TPoint = (
    ( X:3; Y:3), ( X:3; Y:0), ( X:3; Y:6), ( X:0; Y:3));
  mktpCornerPoints : array[0..3] of TPoint = (
    ( X:6; Y:3), ( X:0; Y:0), ( X:6; Y:0), ( X:6; Y:6));
  mktpArrowPoints : array[0..7] of TPoint = (
    ( X:7; Y:4), ( X:0; Y:3), ( X:3; Y:3), ( X:3; Y:0), ( X:7; Y:4), ( X:3; Y:8), ( X:3; Y:5), ( X:0; Y:5));
  mktpRectanglePoints : array[0..4] of TPoint = (
    //( X:2; Y:3), ( X:0; Y:0), ( X:4; Y:0), ( X:4; Y:5), ( X:2; Y:7), ( X:0; Y:5));
    ( X:3; Y:3), ( X:0; Y:0), ( X:3; Y:0), ( X:3; Y:7), ( X:0; Y:7));


const
  TransparentColor = clRed;
  MinRullerLength = 30;

{ TmkRangeSlider }

constructor TmkRangeSlider.Create(AOwner: TComponent);
  function CreateThumbImages : TmkThumbBitmap;
  begin
    Result := TmkThumbBitmap.Create;
    Result.Slider := Self;
  end;
begin
  inherited;
  DoubleBuffered := false;
//  ControlStyle := ControlStyle + [csReplicatable];
  TabStop := true;
  Width := 200;
  Height := 32;
  FRullerWidth := 11;

  ThumbPoints.Origin := Point( 0, 0);
  ThumbPoints.Points := NIL;

  FThumbStyle := rsStandard;
  FOrientation := rsHorizontal;
  FTickStyle := rsBottomRight;
  FMin := 0;
  FMax := 10;
  FMinPosition := FMin;
  FMaxPosition := FMax;
  FFrequency := 0;
  FGenerateChangeEvent := true;

  FColorLow := clGray;
  FColorMid := $0080FFFF;
  FColorHi  := $005EAEFF;

  FScaleFactor := 3; //2 nico

  MinThumb := CreateThumbImages;
  MaxThumb := CreateThumbImages;

  CreateThumbnails;
  CalcRullerDimensions;
end;

procedure TmkRangeSlider.CreateThumbBmp(Bmp: TmkThumbBitmap; PA: TmkPointsArray);
var
  Dimension : TPoint;
  TmpBmp : TBitMap;

  { Works perfect when line degrees are 0, 45, 90, 135, 180 ... }
  procedure MakeEdges( Bmp : TBitMap;
                       PA : TmkPointsArray;
                       OffsetX, OffsetY : integer;
                       AColor : TColor);
  var Cou : integer; TmpPA : TmkPointsArray;
  begin
    Bmp.Transparent := true;
    Bmp.TransparentColor := TransparentColor;
    SetLength( TmpPA.Points, High( PA.Points) + 1);
    TmpPA.Points := Copy( PA.Points, 0, High( PA.Points) + 1);
    with Bmp.Canvas do begin
      Brush.Color := Bmp.TransparentColor;
      FillRect( ClipRect);

      Pen.Color := AColor;
      Brush.Color := AColor;
      Polygon( TmpPA.Points);

      Pen.Color := {clBlack;} Bmp.TransparentColor;
      Brush.Color := Bmp.TransparentColor;

      for Cou := 0 to High(TmpPA.Points) do begin
        TmpPA.Points[Cou].X := TmpPA.Points[Cou].X + OffsetX;
        TmpPA.Points[Cou].Y := TmpPA.Points[Cou].Y + OffsetY;
        end;
      Polygon( TmpPA.Points);
      end;
  end;

  procedure OverlayBmp( BaseBmp, OverBmp : TBitMap);
  begin BaseBmp.Canvas.Draw( 0, 0, OverBmp); end;

begin
  Dimension := GetThumbDimensions( PA);
  Bmp.Width := Dimension.X;
  Bmp.Height := Dimension.Y;
  Bmp.TransparentColor := TransparentColor;
  Bmp.TransparentMode := tmFixed;

  { Draw main polygon}
  with Bmp.Canvas do begin
    Brush.Color := TransparentColor;;
    Pen.Color := clBtnFace;
    FillRect( ClipRect);
    Brush.Color := clBtnFace;
    Polygon( PA.Points);
    end;

  { Shadows BitMap}
  TmpBmp := TBitMap.Create;
  try
    TmpBmp.Width := Dimension.X;
    TmpBmp.Height := Dimension.Y;

    MakeEdges( TmpBmp, PA, 0, 1, clBtnHighlight);
    OverlayBmp( Bmp, TmpBmp);
    MakeEdges( TmpBmp, PA, 1, 0, clBtnHighlight);
    OverlayBmp( Bmp, TmpBmp);
    MakeEdges( TmpBmp, PA, 0, -1, clBtnShadow);
    OverlayBmp( Bmp, TmpBmp);
    MakeEdges( TmpBmp, PA, -1, 0, clBtnShadow);
    OverlayBmp( Bmp, TmpBmp);

  finally TmpBmp.Free; end;

  Bmp.Origin := PA.Origin;
end;

procedure TmkRangeSlider.CreateThumbnails;

  procedure MakeThumbsSou( Rotate : integer; Flip : boolean);
  var TP : TmkPointsArray;
  begin
    TP := MakeThumbPoints( ThumbPoints, Flip, FScaleFactor, Rotate);
    CreateThumbBmp( MinThumb, TP);

    TP := MakeThumbPoints( ThumbPoints, NOT Flip, FScaleFactor, Rotate);
    CreateThumbBmp( MaxThumb, TP);
  end;

begin
  MakePointsArray( FThumbStyle);
  if Orientation = rsHorizontal then begin
    if TickStyle = rsBottomRight then MakeThumbsSou( 0, false) else
    if TickStyle = rsTopLeft then MakeThumbsSou( 2, true);
    Constraints.MinWidth := 50;
    Constraints.MinHeight := 10;
    end {rsHorizontal} else
  if Orientation = rsVertical then begin
    if TickStyle = rsBottomRight then MakeThumbsSou( 3, true) else
    if TickStyle = rsTopLeft then MakeThumbsSou( 1, false);
    Constraints.MinWidth := 10;
    Constraints.MinHeight := 50;
    end; {rsVertical}
end;

destructor TmkRangeSlider.Destroy;
begin
  ThumbPoints.Points := NIL;
  MinThumb.Free;
  MaxThumb.Free;
  inherited;
end;

procedure TmkRangeSlider.DrawRuller( ACanvas : TCanvas);
var
  Bmp : TBitMap;
  R : TRect;

  procedure SouDrawRuller;
  begin
    with Bmp.Canvas do begin
      Brush.Color := cl3DLight;
      FillRect( ClipRect);
      Pen.Color := clBtnShadow;
//      Rectangle( ClipRect);
      R := ClipRect;
      Frame3D( Bmp.Canvas, R, clBtnShadow, clBtnHighLight, 1);
      end;

    //nico
    //Zone morte
    R := Bmp.Canvas.ClipRect;
    InflateRect(R, -3, -3);
    if Orientation = rsHorizontal then
      R.Right := FMinPosition
    else
      R.Bottom := FMinPosition;
    Bmp.Canvas.Brush.Color := FColorLow;
    Bmp.Canvas.FillRect(R);

    //Zone simple click
    R := Bmp.Canvas.ClipRect;
    InflateRect(R, -3, -3);
    if Orientation = rsHorizontal then begin
      R.Left :=  FMinPosition;
      R.Right := FMaxPosition ;
    end else begin
      R.Top := FMinPosition;
      R.Bottom := FMaxPosition;
    end;
    Bmp.Canvas.Brush.Color := FColorMid;
    Bmp.Canvas.FillRect(R);

    //Zone double click
    R := Bmp.Canvas.ClipRect;
    InflateRect(R, -3, -3);
    if Orientation = rsHorizontal then begin
      R.Left :=  FMaxPosition ;
    end else begin
      R.Top := FMaxPosition;
    end;
    Bmp.Canvas.Brush.Color := FColorHi;
    Bmp.Canvas.FillRect(R);
  end;

  procedure SouDrawTicks;
  const
    MinPixPerTic = 5; // minimal distance between tick markers in pixels
  var
    Steps, CurrStep, BigStep : integer;


    function MinSteps : integer;
    const  TmkFact : array[0..2] of integer = (1, 2, 5);
    var
      SMult, FInd: integer;

      function CurPixPerTic : integer;
      begin
        Result := ( FRullerLength * TmkFact[ FInd] * SMult) DIV ( Max - Min);
      end;

    begin
      FInd := low( TmkFact);
      SMult := 1;
      while CurPixPerTic < MinPixPerTic do begin
        if FInd = High( TmkFact) then begin
          FInd := low( TmkFact);
          SMult := SMult * 10;
          end
        else Inc( FInd);
        end;
      Result := TmkFact[ FInd] * SMult;
    end;

    procedure DrawSimpleTick;
    var R : TRect;
    begin
      R := Bounds( 0, 0, 2, 2);
      if Orientation = rsHorizontal then begin
        OffsetRect( R, ValueToPix( CurrStep) - R.Right DIV 2,
                       RullerWidth DIV 2 - R.Bottom DIV 2);
        end
      else begin
        OffsetRect( R, RullerWidth DIV 2 - R.Right DIV 2,
                       ValueToPix( CurrStep) - R.Bottom DIV 2);
        end;
      Bmp.Canvas.Ellipse( R);
    end;

    procedure Draw10thTick;
    const RDist = 2;
    var R : TRect;
    begin
      if Orientation = rsHorizontal then begin
        R := Bounds( 0, 0, 2, RullerWidth - 2 * RDist);
        OffsetRect( R, ValueToPix( CurrStep) - R.Right DIV 2,
                       RullerWidth DIV 2 - R.Bottom DIV 2);
        end
      else begin
        R := Bounds( 0, 0, RullerWidth - 2 * RDist, 2);
        OffsetRect( R, RullerWidth DIV 2 - R.Right DIV 2,
                       ValueToPix( CurrStep) - R.Bottom DIV 2);
        end;
      Bmp.Canvas.Ellipse( R);
    end;

  begin { SouDrawTicks}
    Bmp.Canvas.Brush.Color := clBlack;
    Bmp.Canvas.Pen.Color := clBtnShadow {clBlack};
    if FFrequency <= 0 then Steps := MinSteps
    else                    Steps := FFrequency;
    if Steps >= 100 then BigStep := 1000 else
    if Steps >= 10 then BigStep := 100 else
    if Steps >= 1 then BigStep := 10 else
                       BigStep := 1;
    CurrStep := Min - ( Min MOD Steps);
    while CurrStep < Max do begin
      if CurrStep MOD BigStep = 0 then Draw10thTick
      else                             DrawSimpleTick;
      inc( CurrStep, Steps);
      end;
  end; { SouDrawTicks}

begin
  CalcRullerDimensions;
  Bmp := TBitMap.Create;
  try
    if Orientation = rsHorizontal then begin
      Bmp.Width := FRullerLength;
      Bmp.Height := RullerWidth;
      end { rsHorizontal}
    else begin
      Bmp.Height := FRullerLength;
      Bmp.Width := RullerWidth;
    end; { rsVertical}

    SouDrawRuller; // draw ruller on Bmp
 //   SouDrawTicks;  // draw ticks    nico

    ACanvas.Draw( FRullerRect.Left, FRullerRect.Top, Bmp);
//    SysUtils.Beep;
  finally
    Bmp.Free;
    end;
end;

function TmkRangeSlider.GetThumbDimensions(PA: TmkPointsArray): TPoint;
var Cou : integer;
begin
  Result.X := -MaxInt;
  Result.Y := -Maxint;
  for Cou := 0 to High( PA.Points) do begin
    if PA.Points[Cou].X >= Result.X then Result.X := PA.Points[Cou].X;
    if PA.Points[Cou].Y >= Result.Y then Result.Y := PA.Points[Cou].Y;
    end;
  inc( Result.X); inc( Result.Y);
end;

procedure TmkRangeSlider.KeyDown(var Key: Word; Shift: TShiftState);
var IncDir : integer;
begin
  inherited;
  FGenerateChangeEvent := true;
  if Orientation = rsHorizontal then IncDir := 1 else IncDir := -1;
  case Key of
    VK_LEFT, VK_DOWN  : begin
      if ssShift IN Shift then MoveSlider( rsBothSliders, -1*IncDir) else
      if ssCtrl  IN Shift then MoveSlider( rsMaxSlider, -1*IncDir) else
      MoveSlider( rsMinSlider, -1*IncDir);
      Key := VK_CLEAR;
      end;
    VK_RIGHT, VK_UP : begin
      if ssShift IN Shift then MoveSlider( rsBothSliders, 1*IncDir) else
      if ssCtrl  IN Shift then MoveSlider( rsMaxSlider, 1*IncDir) else
      MoveSlider( rsMinSlider, 1*IncDir);
      Key := VK_CLEAR;
      end;
   end;
end;

procedure TmkRangeSlider.MakePointsArray( Style: TmkThumbStyle);
var Cou : integer;
begin
  ThumbPoints.Points := NIL;
  case Style of
    rsStandard : begin
      ThumbPoints.Origin := mktpStandardPoints[0];
      SetLength( ThumbPoints.Points, High( mktpStandardPoints) + 1 - 1{for Origin});
      for Cou := 1 to High( mktpStandardPoints) do ThumbPoints.Points[Cou-1] := mktpStandardPoints[Cou];
      end;
    rsTriangle : begin
      ThumbPoints.Origin := mktpTrianglePoints[0];
      SetLength( ThumbPoints.Points, High( mktpTrianglePoints) + 1 - 1{for Origin});
      for Cou := 1 to High( mktpTrianglePoints) do ThumbPoints.Points[Cou-1] := mktpTrianglePoints[Cou];
      end;
    rsCorner : begin
      ThumbPoints.Origin := mktpCornerPoints[0];
      SetLength( ThumbPoints.Points, High( mktpCornerPoints) + 1 - 1{for Origin});
      for Cou := 1 to High( mktpCornerPoints) do ThumbPoints.Points[Cou-1] := mktpCornerPoints[Cou];
      end;
    rsArrow : begin
      ThumbPoints.Origin := mktpArrowPoints[0];
      SetLength( ThumbPoints.Points, High( mktpArrowPoints) + 1 - 1{for Origin});
      for Cou := 1 to High( mktpArrowPoints) do ThumbPoints.Points[Cou-1] := mktpArrowPoints[Cou];
      end;
    rsRectangle : begin
      ThumbPoints.Origin := mktpRectanglePoints[0];
      SetLength( ThumbPoints.Points, High( mktpRectanglePoints) + 1 - 1{for Origin});
      for Cou := 1 to High( mktpRectanglePoints) do ThumbPoints.Points[Cou-1] := mktpRectanglePoints[Cou];
      end;
    else begin
      ThumbPoints.Origin := mktpStandardPoints[0];
      SetLength( ThumbPoints.Points, High( mktpStandardPoints) + 1 - 1{for Origin});
      for Cou := 1 to High( mktpStandardPoints) do ThumbPoints.Points[Cou-1] := mktpStandardPoints[Cou];
      end;

    end;
end;

function TmkRangeSlider.MakeThumbPoints(PA: TmkPointsArray; Flip: boolean;
  Scale, RotateClockSteps: integer): TmkPointsArray;
var
  SouPA : TmkPointsArray;
  ALength : integer;

  procedure HorizontalFlip;
  var Cou : integer; TmpPA : TmkPointsArray;
  begin
    SetLength( TmpPA.Points, High( SouPA.Points) + 1);
    {flip origin}
    TmpPA.Origin.X := - SouPA.Origin.X;
    TmpPA.Origin.Y :=   SouPA.Origin.Y;
    {flip points}
    for Cou := 0 to High( SouPA.Points) do begin
      TmpPA.Points[ High( SouPA.Points) - Cou].X := - SouPA.Points[ Cou].X;
      TmpPA.Points[ High( SouPA.Points) - Cou].Y :=   SouPA.Points[ Cou].Y;
      end;
    {copy to source}  
    SouPA.Origin := TmpPA.Origin;  
    SouPA.Points := Copy( TmpPA.Points, 0, High( SouPA.Points) + 1);
    TmpPA.Points := NIL;
  end;

  procedure Rotate;
  var Cou, SinS, CosS, MinX, MinY : integer; TmpPA : TmkPointsArray;
  begin
    // duplicate Source
    SetLength( TmpPA.Points, High( SouPA.Points));
    TmpPA.Points := Copy( SouPA.Points, 0, High( SouPA.Points) + 1);
    case RotateClockSteps MOD 4 of
      0: begin SinS :=  0; CosS :=  1; end;
      1: begin SinS := -1; CosS :=  0; end;
      2: begin SinS :=  0; CosS := -1; end;
      3: begin SinS :=  1; CosS :=  0; end;
      end;
    MinX := Maxint; MinY := Maxint;
    // make transformation of Origin
    TmpPA.Origin.X :=    SouPA.Origin.X  * CosS + SouPA.Origin.Y * SinS;
    TmpPA.Origin.Y := -( SouPA.Origin.X) * SinS + SouPA.Origin.Y * CosS;
    // make transformation of Points
    for Cou := 0 to High( SouPA.Points) do begin
      TmpPA.Points[ Cou].X :=    SouPA.Points[ Cou].X  * CosS + SouPA.Points[ Cou].Y * SinS;
      TmpPA.Points[ Cou].Y := -( SouPA.Points[ Cou].X) * SinS + SouPA.Points[ Cou].Y * CosS;
      if TmpPA.Points[ Cou].X <= MinX then MinX := TmpPA.Points[ Cou].X;
      if TmpPA.Points[ Cou].Y <= MinY then MinY := TmpPA.Points[ Cou].Y;
      end;
    if MinX >= 0 then MinX := 0;
    if MinY >= 0 then MinY := 0;
    // move to positive area
    TmpPA.Origin.X := TmpPA.Origin.X - MinX;
    TmpPA.Origin.Y := TmpPA.Origin.Y - MinY;
    for Cou := 0 to High( TmpPA.Points) do begin
      TmpPA.Points[ Cou].X := TmpPA.Points[ Cou].X - MinX;
      TmpPA.Points[ Cou].Y := TmpPA.Points[ Cou].Y - MinY;
      end;
    // replace source with transformed array
    SouPA.Origin := TmpPA.Origin;
    SouPA.Points := Copy( TmpPA.Points, 0, High( TmpPA.Points) + 1);
    TmpPA.Points := NIL;
  end;

  procedure Zoom;
  var Cou : integer;
  begin
    SouPA.Origin.X := SouPA.Origin.X * Scale;
    SouPA.Origin.Y := SouPA.Origin.Y * Scale;
    for Cou := 0 to High( SouPA.Points) do begin
      SouPA.Points[ Cou].X := SouPA.Points[ Cou].X * Scale;
      SouPA.Points[ Cou].Y := SouPA.Points[ Cou].Y * Scale;
      end;
  end;

begin
  // duplicate Source points
  SetLength( SouPA.Points, High( PA.Points));
  SouPA.Origin := PA.Origin;
  SouPA.Points := Copy( PA.Points, 0, High( PA.Points) + 1);

  if Flip then HorizontalFlip;
  Rotate;
  Zoom;
  { Copy to result}
  ALength := High( SouPA.Points) + 1;
  SetLength( Result.Points, ALength);
  Result.Points := Copy( SouPA.Points, 0, ALength);
  Result.Origin := SouPA.Origin;

  SouPA.Points := NIL;
end;

procedure TmkRangeSlider.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if NOT Focused then begin SetFocus; {Refresh;} end;

  if Button <> mbLeft then exit;

  if MinThumb.MyPoint( X, Y) then begin
    FDragThumb := MinThumb;
    FDragOffset := ValueToPix( MinPosition);
    end else
  if MaxThumb.MyPoint( X, Y) then begin
    FDragThumb := MaxThumb;
    FDragOffset := ValueToPix( MaxPosition);
    end else
  FDragThumb := NIL;

  if FDragThumb = NIL then exit;  // mouse is not in thumbs

  if Orientation = rsHorizontal then FDragOffset := FDragOffset - X
  else                               FDragOffset := FDragOffset - Y;
  FDragging := true;
  FGenerateChangeEvent := false;
  FOldMinPos := MinPosition;
  FOldMaxPos := MaxPosition;
end;

procedure TmkRangeSlider.MouseMove(Shift: TShiftState; X, Y: Integer);
var NewMaxP, NewMinP, FDragValue, OldMaxP, OldMinP : integer;

  function CheckValue( Value : integer) : boolean;
  begin
    Result := ( Value <= Max) AND ( Value >= Min);
  end;

begin
  inherited;

  if NOT FDragging then exit;
  OldMaxP := MaxPosition;
  OldMinP := MinPosition;
  if Orientation = rsHorizontal then FDragValue := X
  else                               FDragValue := Y;
  if FDragThumb = MinThumb then begin
    NewMinP := PixToValue( FDragValue + FDragOffset);
    if ssShift IN Shift then begin
      NewMaxP := OldMaxP + ( NewMinP - OldMinP);
      if CheckValue( NewMinP) AND CheckValue( NewMaxP) then begin
        MinPosition := NewMinP; MaxPosition := NewMaxP; end;
      end
    else MinPosition := NewMinP;
    end else
  if FDragThumb = MaxThumb then begin
    NewMaxP := PixToValue( FDragValue + FDragOffset);
    if ssShift IN Shift then begin
      NewMinP := OldMinP + ( NewMaxP - OldMaxP);
      if CheckValue( NewMinP) AND CheckValue( NewMaxP) then begin
        MaxPosition := NewMaxP; MinPosition := NewMinP; end;
      end
    else MaxPosition := NewMaxP;
    end;
end;

procedure TmkRangeSlider.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  FDragging := false;
  if { FGenerateChangeEvent} true AND
     (( FOldMinPos <> MinPosition) OR ( FOldMaxPos <> MaxPosition)) then begin
    FGenerateChangeEvent := true;
    if Assigned( OnChange) then
      OnChange( Self);
    invalidate;
  end;
end;

procedure TmkRangeSlider.Paint;
var Bmp : TBitMap;

  procedure PaintFrame;
  var R : TRect;
  begin
    R := Bmp.Canvas.ClipRect;
    Frame3D( Bmp.Canvas, R, clBtnShadow, clBtnHighLight, 1);
  end;

begin
  Bmp := TBitMap.Create;
  try
    Bmp.Width := Width; Bmp.Height := Height;
//    Bmp.Transparent := true;
//    Bmp.TransparentColor := TransparentColor;
    with Bmp.Canvas do begin
      Brush.Color := {TransparentColor;} Self.Color;
      FillRect( ClipRect);
      end;

    DrawRuller( Bmp.Canvas);

    MinThumb.InitialDrawing := true;
    DrawMinThumb( Bmp.Canvas);

    MaxThumb.InitialDrawing := true;
    DrawMaxThumb( Bmp.Canvas);

//    if Focused then Bmp.Canvas.DrawFocusRect( Bmp.Canvas.ClipRect);

//    PaintFrame;

    Self.Canvas.CopyRect( Self.Canvas.ClipRect, Bmp.Canvas, Self.Canvas.ClipRect);
//    Self.Canvas.Draw( 0, 0, Bmp);
  finally Bmp.Free; end;

{
  OutputDebugString( 'Painting');

  DrawRuller( Self.Canvas);

  MinThumb.InitialDrawing := true;
  DrawMinThumb( Self.Canvas); // redraw Min thumb

  MaxThumb.InitialDrawing := true;
  DrawMaxThumb( Self.Canvas); // redraw Max thumb
}
//  if Focused then Canvas.DrawFocusRect( Canvas.ClipRect);
end;

procedure TmkRangeSlider.SetFrequency(const Value: integer);
begin
  if FFrequency = Value then exit;
  if Value < 0 then exit;
  if Assigned( FOnBeforeChange) then FOnBeforeChange( Self);
  FFrequency := Value;
  Refresh;
end;

procedure TmkRangeSlider.SetMax(const Value: integer);
begin
  if Value <= Min then raise EmkRangeSlider.Create('Max <= Min');
  FMax := Value;
  if ( csReading IN ComponentState) OR
     ( csUpdating IN ComponentState) OR
     ( csLoading IN ComponentState) then exit;
  if Assigned( FOnBeforeChange) then FOnBeforeChange( Self);
  CheckPositionValues;
  Refresh;
  if Assigned( FOnMaxChange) then FOnMaxChange( Self, FMax);
  if Assigned( OnChange) AND FGenerateChangeEvent then OnChange( Self);
end;

procedure TmkRangeSlider.DrawMaxThumb( ACanvas : TCanvas);
begin
  MaxThumb.Draw( ACanvas, ValueToPix( MaxPosition), Orientation);
end;

procedure TmkRangeSlider.SetMaxPosition(const Value: integer);
begin
  if FMaxPosition = Value then exit;
  if ( csReading IN ComponentState) OR
     ( csUpdating IN ComponentState) OR
     ( csLoading IN ComponentState) then begin
    FMaxPosition := Value;
    exit;
    end;
  if Assigned( FOnBeforeChange) then FOnBeforeChange( Self);
  if Value < FMinPosition then
    FMaxPosition := FMinPosition
  else
    if Value > Max then
      FMaxPosition := Max
    else
      FMaxPosition := Value;
//  Refresh;
  DrawRuller( Self.Canvas);
  DrawMinThumb( Self.Canvas);
  DrawMaxThumb( Self.Canvas);

  if Assigned( FOnMaxPosChange) then FOnMaxPosChange( Self, FMaxPosition);
  if Assigned( OnChange) AND FGenerateChangeEvent then OnChange( Self);
end;

procedure TmkRangeSlider.SetMin(const Value: integer);
begin
  if Value >= Max then raise EmkRangeSlider.Create('Min >= Max');
  FMin := Value;
  if ( csReading IN ComponentState) OR
     ( csUpdating IN ComponentState) OR
     ( csLoading IN ComponentState) then exit;
  if Assigned( FOnBeforeChange) then FOnBeforeChange( Self);
  CheckPositionValues;
  Refresh;
  if Assigned( FOnMinChange) then FOnMinChange( Self, FMin);
  if Assigned( OnChange) AND FGenerateChangeEvent then OnChange( Self);
end;

procedure TmkRangeSlider.DrawMinThumb( ACanvas : TCanvas);
begin
  MinThumb.Draw( ACanvas, ValueToPix( MinPosition)-1, Orientation)
end;

procedure TmkRangeSlider.SetMinPosition(const Value: integer);
begin
  if FMinPosition = Value then exit;
  if ( csReading IN ComponentState) OR
     ( csUpdating IN ComponentState) OR
     ( csLoading IN ComponentState) then begin
    FMinPosition := Value;
    exit;
    end;
  if Assigned( FOnBeforeChange) then FOnBeforeChange( Self);
  if Value < Min then
    FMinPosition := Min
  else
    if Value > FMaxPosition then
      FMinPosition := FMaxPosition
    else
      FMinPosition := Value;
//  Refresh;
  DrawRuller( Self.Canvas);
  DrawMinThumb( Self.Canvas);
  DrawMaxThumb( Self.Canvas);

  if Assigned( FOnMinPosChange) then FOnMinPosChange( Self, FMinPosition);
  if Assigned( OnChange) AND FGenerateChangeEvent then OnChange( Self);
end;

procedure TmkRangeSlider.SetOrientation(const Value: TmkOrientation);
begin
  if FOrientation = Value then exit;
  if Assigned( FOnBeforeChange) then FOnBeforeChange( Self);
  FOrientation := Value;

  if ComponentState * [csLoading, csUpdating] = [] then
    SetBounds(Left, Top, Height, Width);
(*
  if (csDesigning IN ComponentState) AND ( NOT (csLoading IN ComponentState)) then begin
    TmpInt := Width; Width := Height; Height := TmpInt; // swap Width and height
    end;
*)    
  CreateThumbnails;
  CalcRullerDimensions;
  Refresh;
end;

procedure TmkRangeSlider.SetThumbStyle(const Value: TmkThumbStyle);
begin
  if FThumbStyle = Value then exit;
  if Assigned( FOnBeforeChange) then FOnBeforeChange( Self);
  FThumbStyle := Value;
  CreateThumbnails;
  CalcRullerDimensions;
  Refresh;
end;

procedure TmkRangeSlider.SetTickStyle(const Value: TmkTickStyle);
begin
  if FTickStyle = Value then exit;
  if Assigned( FOnBeforeChange) then FOnBeforeChange( Self);
  FTickStyle := Value;
  CreateThumbnails;
  CalcRullerDimensions;
  Refresh;
end;

function TmkRangeSlider.PixToValue(Pix: integer): integer;
begin
  Result := round( Pix / FPixelsPerStep) + FMin;
end;

function TmkRangeSlider.ValueToPix(Value: integer): integer;
begin
  Result := round( (Value - FMin) * FPixelsPerStep);
end;

procedure TmkRangeSlider.CMEnter(var Message: TCMGotFocus);
begin
  inherited;
//  Refresh;
end;

procedure TmkRangeSlider.CMExit(var Message: TCMExit);
begin
  inherited;
//  Refresh;
end;

procedure TmkRangeSlider.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TmkRangeSlider.MoveSlider(Slider: TmkMoveSliders; Value: integer);
begin
  case Slider of
    rsMinSlider : MinPosition := MinPosition + Value;
    rsMaxSlider : MaxPosition := MaxPosition + Value;
    rsBothSliders : begin
      if ( MinPosition + Value >= Min) AND ( MinPosition + Value <= Max) AND
         ( MaxPosition + Value >= Min) AND ( MaxPosition + Value <= Max) then begin
        MinPosition := MinPosition + Value;
        MaxPosition := MaxPosition + Value;
        end;
      end;
    end;
end;

procedure TmkRangeSlider.SetRullerWidth(const Value: integer);
begin
  FRullerWidth := Value;
end;

procedure TmkRangeSlider.SetOnGetRullerLength(
  const Value: TmkGetRullerLength);
begin
  FOnGetRullerLength := Value;
end;

procedure TmkRangeSlider.CalcRullerDimensions;
const
  RullerShrink = 6;
  RullerMinOffset = 2;
var ROfs : integer;
begin
  { Get Ruller length}
  if csDesigning IN ComponentState then FRullerLength := 0
  else begin
    if Assigned( FOnGetRullerLength) then begin
      FOnGetRullerLength( Self, FRullerLength);
      if FRullerLength < MinRullerLength then FRullerLength := MinRullerLength;
      end
    else FRullerLength := 0;
    end;

  { Calculate ruller dimensions}
  if Orientation = rsHorizontal then begin
    if FRullerLength <= 0 then FRullerLength := Width - 2 * MinThumb.Width - RullerShrink
    else Width := FRullerLength + 2 * MinThumb.Width + RullerShrink;
    FRullerRect := Bounds( 0, 0, FRullerLength, RullerWidth);
    if MinThumb.Origin.Y <= RullerWidth DIV 2 then ROfs := RullerMinOffset
    else ROfs := MinThumb.Origin.Y - RullerWidth DIV 2 + RullerMinOffset;
    OffsetRect( FRullerRect, MinThumb.Width + RullerShrink DIV 2, ROfs);
    end { rsHorizontal}
  else begin
    if FRullerLength <= 0 then FRullerLength := Height - 2 * MinThumb.Height - RullerShrink
    else Height := FRullerLength + 2 * MinThumb.Height + RullerShrink;
    FRullerRect := Bounds( 0, 0, RullerWidth, FRullerLength);
    if MinThumb.Origin.X <= RullerWidth DIV 2 then ROfs := RullerMinOffset
    else ROfs := MinThumb.Origin.X - RullerWidth DIV 2 + RullerMinOffset;
    OffsetRect( FRullerRect, ROfs, MinThumb.Height + RullerShrink DIV 2);
    end; { rsVertical}
  FPixelsPerStep := FRullerLength / ( Max - Min);
end;

procedure TmkRangeSlider.CheckPositionValues;
begin
  if FMinPosition < FMin then FMinPosition := FMin;
  if FMaxPosition < FMin then FMaxPosition := FMin;
  if FMinPosition > FMax then FMinPosition := FMax;
  if FMaxPosition > FMax then FMaxPosition := FMax;
end;

procedure TmkRangeSlider.SetOnBeforeChange(const Value: TNotifyEvent);
begin
  FOnBeforeChange := Value;
end;

procedure TmkRangeSlider.DoKeyDown(var Key: Word; Shift: TShiftState);
begin
  KeyDown( Key, Shift);
end;



{ TmkThumbBitmap }

constructor TmkThumbBitmap.Create;
begin
  inherited;
  Transparent := true;
  FSlider := NIL;
  FOrigin := Point( 0, 0);
  Bkg := TBitMap.Create;
  FInitialDrawing := false;
end;

destructor TmkThumbBitmap.Destroy;
begin
  Bkg.Free;
  inherited;
end;

procedure TmkThumbBitmap.Draw( ACanvas : TCanvas; Value : integer; Orientation : TmkOrientation);
  function CalcThumbRect : TRect;
  var AbsPoint : TPoint;
  begin
    with Slider.RullerRect do begin
      if Orientation = rsHorizontal then
        AbsPoint := Point( Left + Value, Top + ((Bottom - Top) DIV 2))
      else
        AbsPoint := Point( Left + (( Right - Left) DIV 2), Top + Value);
      end;
    Result := Bounds( AbsPoint.X - FOrigin.X, AbsPoint.Y - FOrigin.Y, Width, Height);
  end;

  procedure SaveCurrentBkg;
  begin
    BkgRect := CalcThumbRect;
    Bkg.Canvas.CopyRect( Bkg.Canvas.ClipRect, ACanvas, BkgRect);
  end;
begin
  if NOT Assigned( FSlider) then raise
    EmkRangeSlider.Create('Slider not assigned to bitmap');
  if FInitialDrawing then begin { save initial background}
    //OutputDebugString( 'FInitialDrawing');
    Bkg.Width := Width; Bkg.Height := Height;
    SaveCurrentBkg;
    FInitialDrawing := false;
    end
  else begin { restore old background}
    ACanvas.CopyRect( BkgRect, Bkg.Canvas, Bkg.Canvas.ClipRect);
    SaveCurrentBkg;
    end;
  //OutputDebugString( 'Thumb Drawing');
  ACanvas.Draw( BkgRect.Left, BkgRect.Top, Self);
end;

function TmkThumbBitmap.MyPoint(X, Y: integer): boolean;
begin
  Result :=
    PtInRect( BkgRect, Point( X, Y));
end;

end.
