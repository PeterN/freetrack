unit SeuillageProcessor_UYVY;

interface

uses
  BaseClass, DirectShow9, DSUtil, ActiveX, Windows, Math, Types,
  Seuillage_inc, SeuillageProcessor, SeuillageProcessor_CbCr;

type
  TSeuillageProcessor_UYVY = class (TSeuillageProcessor_CbCr)
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
  tagUYVYDouble = packed record
    UV : Byte;
    Y : Byte;
  end;
  UYVYDouble = tagUYVYDouble;
  PUYVYDouble = ^UYVYDouble;


{
*************************** TSeuillageProcessor_UYVY ***************************
}
procedure TSeuillageProcessor_UYVY.DrawCenterCross;
var
  pPixelVert, pPixelHor: PUYVYDouble;
  i: Integer;
  iPixelSizeXSampleWidth: Integer;
begin
  pPixelHor := PUYVYDouble(AddrStart + iPixelSize*(round(0.5 * SampleHeight)) * SampleWidth);
  pPixelVert := PUYVYDouble(AddrStart + iPixelSize*(round(0.5 * SampleWidth)));
  iPixelSizeXSampleWidth := iPixelSize*SampleWidth;
  
  for i := 0 to SampleWidth do begin
    if (Longint(pPixelHor) >= FAddrStart) and (Longint(pPixelHor) <= FAddrEnd) then
      pPixelHor^.Y := X_CENTER_COL;
    if (Longint(pPixelVert) >= FAddrStart) and (Longint(pPixelVert) <= FAddrEnd) then
      pPixelVert^.Y := X_CENTER_COL;
  
    pPixelHor  := PUYVYDouble(Longint(pPixelHor) + iPixelSize);
    pPixelVert := PUYVYDouble(Longint(pPixelVert) + iPixelSizeXSampleWidth);
  end;
end;



procedure TSeuillageProcessor_UYVY.DrawCross(aPoint : TPoint);
var
  pPixelLeft, pPixelRight, pPixelUp, pPixelDown: PUYVYDouble;
  i: Integer;
  iPixelSizeXSampleWidth: Integer;
begin
  pPixelLeft := PUYVYDouble(AddrStart + iPixelSize*(aPoint.X + aPoint.Y * SampleWidth));
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

    pPixelRight := PUYVYDouble(Longint(pPixelRight) + iPixelSize);
    pPixelLeft := PUYVYDouble(Longint(pPixelLeft) - iPixelSize);
    pPixelUp := PUYVYDouble(Longint(pPixelUp) - iPixelSizeXSampleWidth);
    pPixelDown := PUYVYDouble(Longint(pPixelDown) + iPixelSizeXSampleWidth);
  end;
end;

procedure TSeuillageProcessor_UYVY.Find(pPixel : Pointer);
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
    if (PUYVYDouble(pPixel).Y = PIX_LIGHT) then begin
      PUYVYDouble(pPixel).Y := PIX_USED; // set the pixel as used
  
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
        //y := ((Longint(pPixel) - AddrStart)div iPixelSize) div SampleWidth;
      end;
  
      aLed := Rect(Min(aLed.Left, x), Min(aLed.Top, y), Max(aLed.Right, x), Max(aLed.Bottom, y));
  
      iPixelSizeXSampleWidth := iPixelSize*SampleWidth;
  
      aPixAddr := Longint(pPixel) - iPixelSizeXSampleWidth - iPixelSize;
      if inside(aPixAddr) then Find(PUYVYDouble(aPixAddr));        //x-1,y+1
      inc(aPixAddr, iPixelSize);
      if inside(aPixAddr) then Find(PUYVYDouble(aPixAddr));        //x,y-1
      inc(aPixAddr, iPixelSize);
      if inside(aPixAddr) then Find(PUYVYDouble(aPixAddr));        //x+1,y-1
  
      inc(aPixAddr, iPixelSizeXSampleWidth - iPixelSize shl 1);
      if inside(aPixAddr) then Find(PUYVYDouble(aPixAddr));        //x-1,y
      inc(aPixAddr, iPixelSize shl 1);
      if inside(aPixAddr) then Find(PUYVYDouble(aPixAddr));        //x+1,y
  
      inc(aPixAddr, iPixelSizeXSampleWidth - iPixelSize shl 1);
      if inside(aPixAddr) then Find(PUYVYDouble(aPixAddr));        //x-1,y-1
      inc(aPixAddr, iPixelSize);
      if inside(aPixAddr) then Find(PUYVYDouble(aPixAddr));        //x,y+1
      inc(aPixAddr, iPixelSize);
      if inside(aPixAddr) then Find(PUYVYDouble(aPixAddr));        //x+1,y+1
    end;
  
  except
    {On E : EAbort do
      Raise;
    else
      Raise Exception.Create('Error in TfmGrabber.Find');}
  end;
end;

function TSeuillageProcessor_UYVY.PointCenterWeightedMean: TPoint;
var
  jPixel, xPixel, yPixel, iPixelSizeXSampleWidth: Integer;
  pixelCount, average_x, average_y: Integer;
  ledXWeight, ledYWeight: array[0..200] of Integer;
  aPixel: PUYVYDouble;
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
      aPixel := PUYVYDouble(startPixel + iPixelSize * xPixel + iPixelSizeXSampleWidth * yPixel);
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

function TSeuillageProcessor_UYVY.SetSeuil(bSeuil: Byte): HResult;
begin
  FillChar(Mask1, SizeOf(TMaskSeuil), $00);
  FillChar(UVMask, SizeOf(TMaskSeuil), $00);
  FillChar(GreyMask, SizeOf(TMaskSeuil), $00);

  {$ifdef SSE2}
    //15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
    //Y  V  Y  U   Y  V  Y  U  Y  V  Y  U  Y  V  Y  U
  Mask1[1] := bSeuil - $80;
  Mask1[3] := bSeuil - $80;
  Mask1[5] := bSeuil - $80;
  Mask1[7] := bSeuil - $80;
  Mask1[9] := bSeuil - $80;
  Mask1[11] := bSeuil - $80;
  Mask1[13] := bSeuil - $80;
  Mask1[15] := bSeuil - $80;

  UVMask[0] := $80;
  UVMask[2] := $80;
  UVMask[4] := $80;
  UVMask[6] := $80;
  UVMask[8] := $80;
  UVMask[10] := $80;
  UVMask[12] := $80;
  UVMask[14] := $80;

  GreyMask[1] := PIX_LIGHT;
  GreyMask[3] := PIX_LIGHT;
  GreyMask[5] := PIX_LIGHT;
  GreyMask[7] := PIX_LIGHT;
  GreyMask[9] := PIX_LIGHT;
  GreyMask[11] := PIX_LIGHT;
  GreyMask[13] := PIX_LIGHT;
  GreyMask[15] := PIX_LIGHT;


  {$else}
  Mask1[1] := bSeuil - $80;
  Mask1[3] := bSeuil - $80;
  Mask1[5] := bSeuil - $80;
  Mask1[7] := bSeuil - $80;

  UVMask[0] := $80;
  UVMask[2] := $80;
  UVMask[4] := $80;
  UVMask[6] := $80;

  GreyMask[1] := PIX_LIGHT;
  GreyMask[3] := PIX_LIGHT;
  GreyMask[5] := PIX_LIGHT;
  GreyMask[7] := PIX_LIGHT;
  {$endif}
  Result := S_OK;
end;

function TSeuillageProcessor_UYVY.TestPixel(pPixel: Pointer): Boolean;
begin
  Result := UYVYDouble(pPixel^).Y = PIX_LIGHT;
end;












end.

