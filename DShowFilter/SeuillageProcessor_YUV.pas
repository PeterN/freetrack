unit SeuillageProcessor_YUV;

interface

uses
  BaseClass, DirectShow9, DSUtil, ActiveX, Windows, Math, Types,
  Seuillage_inc, SeuillageProcessor_CbCr, SeuillageProcessor;

type
  TSeuillageProcessor_YUV = class (TSeuillageProcessor_CbCr)
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


{
*************************** TSeuillageProcessor_YUV ****************************
}
procedure TSeuillageProcessor_YUV.DrawCenterCross;
var
  pPixelVert, pPixelHor: pByte;
  i: Integer;
begin
  pPixelHor := pByte(FAddrStart + (SampleHeight * SampleWidth) shr 1);
  pPixelVert := pByte(FAddrStart + SampleWidth shr 1);
  
  for i := 0 to SampleWidth do begin
    if (Longint(pPixelHor) >= FAddrStart) and (Longint(pPixelHor) <= YEnd) then
      pPixelHor^ := X_CENTER_COL;
    if (Longint(pPixelVert) >= FAddrStart) and (Longint(pPixelVert) <= YEnd) then
      pPixelVert^ := X_CENTER_COL;
  
    inc(pPixelHor);
    inc(pPixelVert, SampleWidth);
  end;
end;



procedure TSeuillageProcessor_YUV.DrawCross(aPoint : TPoint);
var
  pPixelLeft, pPixelRight, pPixelUp, pPixelDown: pByte;
  i: Integer;
begin
  pPixelLeft := pByte(AddrStart + (aPoint.X + aPoint.Y * SampleWidth));
  pPixelRight := pPixelLeft;
  pPixelUp  := pPixelLeft;
  pPixelDown := pPixelLeft;
  
  for i := 0 to X_POINT_SIZE do begin
    if (aPoint.Y - i) > 0 then
      pPixelUp^ := X_POINT_COL;
    if (aPoint.X - i) > 0 then
      pPixelLeft^ := X_POINT_COL;
  
    if (aPoint.Y + i) < SampleHeight then
      pPixelDown^ := X_POINT_COL;
    if (aPoint.X + i)  < SampleWidth then
      pPixelRight^ := X_POINT_COL;

    inc(pPixelRight);
    dec(pPixelLeft);
    inc(pPixelDown, SampleWidth);
    dec(pPixelUp, SampleWidth);
  end;
end;



procedure TSeuillageProcessor_YUV.Find(pPixel : Pointer);
var
  x, y: Integer;
  aPixAddr: Integer;
  _AddrStart: Integer;
begin
inherited;
    if  ((aLed.Bottom - aLed.Top) > POINT_MAX_DIM) or
      ((aLed.Right - aLed.Left) > POINT_MAX_DIM) then
    Exit;
  _AddrStart := FAddrStart;

  try
    if (pByte(pPixel)^ = PIX_LIGHT) then begin
      pByte(pPixel)^ := PIX_USED; // set the pixel as used
  
      asm
        mov esi, Self

        //x := ((Longint(pPixel) - AddrStart)div iPixelSize) mod SampleWidth;
        mov eax, Longint(pPixel)
        sub eax, _AddrStart
        xor edx, edx
        div [esi].TSeuillageProcessor.SampleWidth
  
        mov x, edx
        mov y, eax
        //y := ((Longint(pPixel) - AddrStart)div iPixelSize) div SampleWidth;
      end;
  
      aLed := Rect(Min(aLed.Left, x), Min(aLed.Top, y), Max(aLed.Right, x), Max(aLed.Bottom, y));
  
      aPixAddr := Longint(pPixel) - SampleWidth - iPixelSize;
      if inside(aPixAddr) then Find(pByte(aPixAddr));        //x-1,y+1
      inc(aPixAddr);
      if inside(aPixAddr) then Find(pByte(aPixAddr));        //x,y-1
      inc(aPixAddr);
      if inside(aPixAddr) then Find(pByte(aPixAddr));        //x+1,y-1
  
      inc(aPixAddr, SampleWidth - iPixelSize shl 1);
      if inside(aPixAddr) then Find(pByte(aPixAddr));        //x-1,y
      inc(aPixAddr, iPixelSize shl 1);
      if inside(aPixAddr) then Find(pByte(aPixAddr));        //x+1,y
  
      inc(aPixAddr, SampleWidth - iPixelSize shl 1);
      if inside(aPixAddr) then Find(pByte(aPixAddr));        //x-1,y-1
      inc(aPixAddr);
      if inside(aPixAddr) then Find(pByte(aPixAddr));        //x,y+1
      inc(aPixAddr);
      if inside(aPixAddr) then Find(pByte(aPixAddr));        //x+1,y+1
    end
  
  except
    {On E : EAbort do
      Raise;
    else
      Raise Exception.Create('Error in TfmGrabber.Find');}
  end;
end;



function TSeuillageProcessor_YUV.PointCenterWeightedMean: TPoint;
var
  jPixel: Integer;
  xPixel, yPixel, pixelCount, average_x, average_y: Integer;
  ledXWeight, ledYWeight: array[0..200] of Integer;
  aPixel: pByte;
  startPixel: LongInt;
begin
  
  pixelCount := 0;
  average_x := 0;
  average_y := 0;
  for jPixel := 0 to High(ledXWeight) do begin
    ledXWeight[jPixel] := 0;
    ledYWeight[jPixel] := 0;
  end;
  
  // range limits used to avoid integer overflow
  startPixel := AddrStart + aLed.Left + aLed.Top * SampleWidth;
  for xPixel := 0 to Min(aLed.Right - aLed.Left, MaxPointSize) do
    for yPixel := 0 to Min(aLed.Bottom - aLed.Top, MaxPointSize) do begin
      aPixel := pByte(startPixel + xPixel + yPixel * SampleWidth);
      if aPixel^ = PIX_USED then begin
        aPixel^ := PIX_TRACKED;
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



function TSeuillageProcessor_YUV.SetSeuil(bSeuil: Byte): HResult;
begin
  FillChar(Mask1, SizeOF(TMaskSeuil), bSeuil - $80);
  FillChar(UVMask, SizeOF(TMaskSeuil), 0);
  FillChar(GreyMask, SizeOF(TMaskSeuil), PIX_LIGHT);
  Result := S_OK;
end;



function TSeuillageProcessor_YUV.TestPixel(pPixel: Pointer): Boolean;
begin
  Result := Byte(pPixel^) = PIX_LIGHT;
end;

end.
