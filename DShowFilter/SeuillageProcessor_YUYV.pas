unit SeuillageProcessor_YUYV;

interface

uses
  BaseClass, DirectShow9, DSUtil, ActiveX, Windows, Math, Types,
  Seuillage_inc, SeuillageProcessor, SeuillageProcessor_CbCr;

type
  TSeuillageProcessor_YUYV = class (TSeuillageProcessor_CbCr)
  protected
    procedure DrawCenterCross; override;
    procedure DrawCross(aPoint : TPoint); override;
    procedure Find(pPixel : Pointer); override;
    function PointCenterWeightedMean: TPoint; override;
    function TestPixel(pPixel: Pointer): Boolean; override;
  public
    function SetSeuil(bSeuil: Byte): HResult; override;
  end;

{$i FreetrackFilter.inc}

implementation


type
  tagYUYVDouble = packed record
    Y : Byte;
    UV : Byte;
  end;
  YUYVDouble = tagYUYVDouble;
  PYUYVDouble = ^YUYVDouble;

{
*************************** TSeuillageProcessor_YUYV ***************************
}
procedure TSeuillageProcessor_YUYV.DrawCenterCross;
var
  pPixelVert, pPixelHor: PYUYVDouble;
  i: Integer;
  iPixelSizeXSampleWidth: Integer;
begin
  pPixelHor := PYUYVDouble(AddrStart + iPixelSize*(round(0.5 * SampleHeight)) * SampleWidth);
  pPixelVert := PYUYVDouble(AddrStart + iPixelSize*(round(0.5 * SampleWidth)));
  iPixelSizeXSampleWidth := iPixelSize*SampleWidth;
  
  for i := 0 to SampleWidth do begin
    if (Longint(pPixelHor) >= FAddrStart) and (Longint(pPixelHor) <= FAddrEnd) then
      pPixelHor^.Y := X_CENTER_COL;
    if (Longint(pPixelVert) >= FAddrStart) and (Longint(pPixelVert) <= FAddrEnd) then
      pPixelVert^.Y := X_CENTER_COL;
  
    pPixelHor  := PYUYVDouble(Longint(pPixelHor) + iPixelSize);
    pPixelVert := PYUYVDouble(Longint(pPixelVert) + iPixelSizeXSampleWidth);
  end;
end;

procedure TSeuillageProcessor_YUYV.DrawCross(aPoint : TPoint);
var
  pPixelLeft, pPixelRight, pPixelUp, pPixelDown: PYUYVDouble;
  i: Integer;
  iPixelSizeXSampleWidth: Integer;
begin
  pPixelLeft := PYUYVDouble(AddrStart + iPixelSize*(aPoint.X + aPoint.Y * SampleWidth));
  pPixelRight := pPixelLeft;
  pPixelUp  := pPixelLeft;
  pPixelDown := pPixelLeft;
  iPixelSizeXSampleWidth := iPixelSize*SampleWidth;

  for i := 0 to X_POINT_SIZE do begin
    if (aPoint.Y - i) > 0 then
      pPixelUp^.Y := X_POINT_COL;
    if (aPoint.X - i) > 0 then
      pPixelLeft^.Y := X_POINT_COL;

    if (aPoint.Y + i) < SampleHeight then
      pPixelDown^.Y := X_POINT_COL;
    if (aPoint.X + i)  < SampleWidth then
      pPixelRight^.Y := X_POINT_COL;

    pPixelRight := PYUYVDouble(Longint(pPixelRight) + iPixelSize);
    pPixelLeft := PYUYVDouble(Longint(pPixelLeft) - iPixelSize);
    pPixelUp := PYUYVDouble(Longint(pPixelUp) - iPixelSizeXSampleWidth);
    pPixelDown := PYUYVDouble(Longint(pPixelDown) + iPixelSizeXSampleWidth);
  end;
end;

procedure TSeuillageProcessor_YUYV.Find(pPixel : Pointer);
var
  x, y: Integer;
  iPixelSizeXSampleWidth, aPixAddr: Integer;
  _AddrStart: Integer;
begin
  _AddrStart := FAddrStart;
  
  if  ((aLed.Bottom - aLed.Top) > POINT_MAX_DIM) or
      ((aLed.Right - aLed.Left) > POINT_MAX_DIM) then
    Exit;

  try
    if (PYUYVDouble(pPixel).Y = PIX_LIGHT) then begin
      PYUYVDouble(pPixel).Y := PIX_USED; // set the pixel as used

      asm
        mov esi, Self
        mov eax, Longint(pPixel)
        sub eax, _AddrStart
        xor edx, edx
        mov ecx, 2
        div ecx
        div [esi].TSeuillageProcessor.SampleWidth
        mov x, edx
        //x := ((Longint(pPixel) - AddrStart)div iPixelSize) mod SampleWidth;

        mov y, eax
        //y := SampleHeight - ((Longint(pPixel) - AddrStart)div iPixelSize) div SampleWidth;
      end;

      aLed := Rect(Min(aLed.Left, x), Min(aLed.Top, y), Max(aLed.Right, x), Max(aLed.Bottom, y));

      iPixelSizeXSampleWidth := iPixelSize*SampleWidth;

      aPixAddr := Longint(pPixel) - iPixelSizeXSampleWidth - iPixelSize;
      if inside(aPixAddr) then Find(PYUYVDouble(aPixAddr));        //x-1,y+1
      inc(aPixAddr, iPixelSize);
      if inside(aPixAddr) then Find(PYUYVDouble(aPixAddr));        //x,y-1
      inc(aPixAddr, iPixelSize);
      if inside(aPixAddr) then Find(PYUYVDouble(aPixAddr));        //x+1,y-1

      inc(aPixAddr, iPixelSizeXSampleWidth - iPixelSize shl 1);
      if inside(aPixAddr) then Find(PYUYVDouble(aPixAddr));        //x-1,y
      inc(aPixAddr, iPixelSize shl 1);
      if inside(aPixAddr) then Find(PYUYVDouble(aPixAddr));        //x+1,y
  
      inc(aPixAddr, iPixelSizeXSampleWidth - iPixelSize shl 1);
      if inside(aPixAddr) then Find(PYUYVDouble(aPixAddr));        //x-1,y-1
      inc(aPixAddr, iPixelSize);
      if inside(aPixAddr) then Find(PYUYVDouble(aPixAddr));        //x,y+1
      inc(aPixAddr, iPixelSize);
      if inside(aPixAddr) then Find(PYUYVDouble(aPixAddr));        //x+1,y+1   
    end;
  
  except
    {On E : EAbort do
      Raise;
    else
      Raise Exception.Create('Error in TfmGrabber.Find');}
  end;
end;

function TSeuillageProcessor_YUYV.PointCenterWeightedMean: TPoint;
var
  jPixel, xPixel, yPixel, iPixelSizeXSampleWidth: Integer;
  pixelCount, average_x, average_y: Integer;
  ledXWeight, ledYWeight: array[0..200] of Integer;
  aPixel: PYUYVDouble;
  startPixel: LongInt;
begin
  
  pixelCount := 0;
  average_x := 0;
  average_y := 0;
  for jPixel := 0 to High(ledXWeight) do begin
    ledXWeight[jPixel] := 0;
    ledYWeight[jPixel] := 0;
  end;

  iPixelSizeXSampleWidth := iPixelSize * SampleWidth;

  // range limits used to avoid integer overflow
  startPixel := AddrStart + iPixelSize * (aLed.Left + aLed.Top * SampleWidth);
  for xPixel := 0 to Min(aLed.Right - aLed.Left, MaxPointSize)  do
    for yPixel := 0 to Min(aLed.Bottom - aLed.Top, MaxPointSize) do begin
      aPixel := PYUYVDouble(startPixel + iPixelSize * xPixel + iPixelSizeXSampleWidth * yPixel);
      if aPixel.Y = PIX_USED then begin
        aPixel^.Y := PIX_TRACKED;
        Inc(ledXWeight[xPixel]);
        Inc(ledYWeight[yPixel]);
        Inc(pixelCount);
      end;
    end;

  for jPixel := 0 to Min(Max(aLed.Right - aLed.Left, aLed.Bottom - aLed.Top), MaxPointSize) do begin
    average_x := average_x + ledXWeight[jPixel] * (jPixel + 1);
    average_y := average_y + ledYWeight[jPixel] * (jPixel + 1);
  end;
  
  average_x := round((aLed.Left + (average_x / pixelCount) - 1) * LISTPOINT_SCALER);
  average_y := round((aLed.Top + (average_y / pixelCount) - 1) * LISTPOINT_SCALER);

  Result := Point(average_x, average_y);
end;

function TSeuillageProcessor_YUYV.SetSeuil(bSeuil: Byte): HResult;
begin
  FillChar(Mask1, SizeOf(TMaskSeuil), $00);
  FillChar(UVMask, SizeOf(TMaskSeuil), $00);
  FillChar(GreyMask, SizeOf(TMaskSeuil), $00);
  {$ifdef SSE2}
    //15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
    //V  Y  U  Y  V   Y  U  Y  V  Y  U  Y  V  Y  U  Y
  Mask1[0] := bSeuil - $80;
  Mask1[2] := bSeuil - $80;
  Mask1[4] := bSeuil - $80;
  Mask1[6] := bSeuil - $80;
  Mask1[8] := bSeuil - $80;
  Mask1[10] := bSeuil - $80;
  Mask1[12] := bSeuil - $80;
  Mask1[14] := bSeuil - $80;

  UVMask[1] := $80;
  UVMask[3] := $80;
  UVMask[5] := $80;
  UVMask[7] := $80;
  UVMask[9] := $80;
  UVMask[11] := $80;
  UVMask[13] := $80;
  UVMask[15] := $80;

  GreyMask[0] := PIX_LIGHT;
  GreyMask[2] := PIX_LIGHT;
  GreyMask[4] := PIX_LIGHT;
  GreyMask[6] := PIX_LIGHT;
  GreyMask[8] := PIX_LIGHT;
  GreyMask[10] := PIX_LIGHT;
  GreyMask[12] := PIX_LIGHT;
  GreyMask[14] := PIX_LIGHT;

  {$else}
  Mask1[0] := bSeuil - $80;
  Mask1[2] := bSeuil - $80;
  Mask1[4] := bSeuil - $80;
  Mask1[6] := bSeuil - $80;

  UVMask[1] := $80;
  UVMask[3] := $80;
  UVMask[5] := $80;
  UVMask[7] := $80;

  GreyMask[0] := PIX_LIGHT;
  GreyMask[2] := PIX_LIGHT;
  GreyMask[4] := PIX_LIGHT;
  GreyMask[6] := PIX_LIGHT;
  {$endif}
  Result := S_OK;


end;

function TSeuillageProcessor_YUYV.TestPixel(pPixel: Pointer): Boolean;
begin
  Result := YUYVDouble(pPixel^).Y = PIX_LIGHT;
end;









end.
