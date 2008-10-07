unit SeuillageProcessor_RGB32;

interface

uses
  BaseClass, DirectShow9, DSUtil, ActiveX, Windows, Math, Types,
  Seuillage_inc, SeuillageProcessor, SysUtils;

type
  TSeuillageProcessor_RGB32 = class (TSeuillageProcessor)
  protected
    procedure DrawCenterCross; override;
    procedure DrawCross(aPoint : TPoint); override;
    procedure Find(pPixel : Pointer); override;
    function PointCenterWeightedMean: TPoint; override;
    function TestPixel(pPixel: Pointer): Boolean; override;
  public
    function SetSeuil(bSeuil: Byte): HResult; override;
    procedure Threshold(pData : pByte); override;
  end;
  

{$i FreetrackFilter.inc}

implementation

const
  X_POINT_COL = $80;
  X_CENTER_COL = $50;


{
************************** TSeuillageProcessor_RGB32 ***************************
}
procedure TSeuillageProcessor_RGB32.DrawCenterCross;
var
  pPixelVert, pPixelHor : PRGBQuad;
  i : integer;
  iPixelSizeXSampleWidth : integer;
begin
  pPixelHor := PRGBQuad(FAddrStart + iPixelSize*(round(0.5 * SampleHeight)) * SampleWidth);
  pPixelVert := PRGBQuad(FAddrStart + iPixelSize*(round(0.5 * SampleWidth)));
  iPixelSizeXSampleWidth := iPixelSize*SampleWidth;

  for i := 0 to SampleWidth do begin
    if (Longint(pPixelHor) >= FAddrStart) and (Longint(pPixelHor) <= FAddrEnd) then
      FillChar(pPixelHor^, iPixelSize, X_CENTER_COL);
    if (Longint(pPixelVert) >= FAddrStart) and (Longint(pPixelVert) <= FAddrEnd) then
      FillChar(pPixelVert^, iPixelSize, X_CENTER_COL);

    pPixelHor  := PRGBQuad(Longint(pPixelHor) + iPixelSize);
    pPixelVert := PRGBQuad(Longint(pPixelVert) + iPixelSizeXSampleWidth);
  end;
end;



procedure TSeuillageProcessor_RGB32.DrawCross(aPoint : TPoint);
var
  pPixelLeft, pPixelRight, pPixelUp, pPixelDown : PRGBQuad;
  i : integer;
  iPixelSizeXSampleWidth : integer;
begin
  pPixelLeft := PRGBQuad(AddrStart + iPixelSize*(aPoint.X + (SampleHeight - aPoint.Y) * SampleWidth));
  pPixelRight := pPixelLeft;
  pPixelUp  := pPixelLeft;
  pPixelDown := pPixelLeft;
  iPixelSizeXSampleWidth := iPixelSize*SampleWidth;

  for i := 0 to X_POINT_SIZE do begin
    if (aPoint.Y - i) > 0 then
      FillChar(pPixelUp^, iPixelSize, X_POINT_COL);
    if (aPoint.X - i) > 0 then
      FillChar(pPixelLeft^, iPixelSize, X_POINT_COL);

    if (aPoint.Y + i) < SampleHeight then
      FillChar(pPixelDown^, iPixelSize, X_POINT_COL);
    if (aPoint.X + i)  < SampleWidth then
      FillChar(pPixelRight^, iPixelSize, X_POINT_COL);

    pPixelRight := PRGBQuad(Longint(pPixelRight) + iPixelSize);
    pPixelLeft := PRGBQuad(Longint(pPixelLeft) - iPixelSize);
    pPixelUp := PRGBQuad(Longint(pPixelUp) + iPixelSizeXSampleWidth);
    pPixelDown := PRGBQuad(Longint(pPixelDown) - iPixelSizeXSampleWidth);
  end;
end;



procedure TSeuillageProcessor_RGB32.Find(pPixel : Pointer);
var
  x, y : integer;
  iPixelSizeXSampleWidth, aPixAddr : integer;
begin
  if  ((aLed.Bottom - aLed.Top) > POINT_MAX_DIM) or
      ((aLed.Right - aLed.Left) > POINT_MAX_DIM) then
    Exit;

  try
    if PRGBQuad(pPixel).rgbRed = PIX_LIGHT then begin
      PRGBQuad(pPixel).rgbRed := PIX_USED; // set the pixel as used

      asm
        mov esi, Self
        //x := ((Longint(pPixel) - AddrStart)div iPixelSize) mod SampleWidth;
        mov eax, Longint(pPixel)
        sub eax, [esi].TSeuillageProcessor.FAddrStart
        xor edx, edx
        mov ecx, [esi].TSeuillageProcessor.iPixelSize
        div ecx
        div [esi].TSeuillageProcessor.SampleWidth

        mov x, edx

        mov ecx, [esi].TSeuillageProcessor.SampleHeight
        sub ecx, eax
        mov y, ecx
        //y := SampleHeight - ((Longint(pPixel) - AddrStart)div iPixelSize) div SampleWidth;
      end;

      aLed := Rect(Min(aLed.Left, x), Min(aLed.Top, y), Max(aLed.Right, x), Max(aLed.Bottom, y));

      iPixelSizeXSampleWidth := iPixelSize*SampleWidth;

      aPixAddr := Longint(pPixel) - iPixelSizeXSampleWidth - iPixelSize;
      if inside(aPixAddr) then Find(PRGBQuad(aPixAddr));        //x-1,y+1
      inc(aPixAddr, iPixelSize);
      if inside(aPixAddr) then Find(PRGBQuad(aPixAddr));        //x,y-1
      inc(aPixAddr, iPixelSize);
      if inside(aPixAddr) then Find(PRGBQuad(aPixAddr));        //x+1,y-1

      inc(aPixAddr, iPixelSizeXSampleWidth - iPixelSize shl 1);
      if inside(aPixAddr) then Find(PRGBQuad(aPixAddr));        //x-1,y
      inc(aPixAddr, iPixelSize shl 1);
      if inside(aPixAddr) then Find(PRGBQuad(aPixAddr));        //x+1,y

      inc(aPixAddr, iPixelSizeXSampleWidth - iPixelSize shl 1);
      if inside(aPixAddr) then Find(PRGBQuad(aPixAddr));        //x-1,y-1
      inc(aPixAddr, iPixelSize);
      if inside(aPixAddr) then Find(PRGBQuad(aPixAddr));        //x,y+1
      inc(aPixAddr, iPixelSize);
      if inside(aPixAddr) then Find(PRGBQuad(aPixAddr));        //x+1,y+1   
    end;

  except
    {On E : EAbort do
      Raise;
    else
      Raise Exception.Create('Error in TfmGrabber.Find');}
  end;
end;



function TSeuillageProcessor_RGB32.PointCenterWeightedMean: TPoint;
var
  jPixel, xPixel, yPixel, iPixelSizeXSampleWidth: Integer;
  pixelCount, average_x, average_y: Integer;
  ledXWeight, ledYWeight: array[0..200] of Integer;
  aPixel: PRGBQuad;
  startPixel: LongInt;
begin

  pixelCount := 0;
  average_x := 0;
  average_y := 0;
  ZeroMemory(@ledXWeight, SizeOf(ledXWeight));
  ZeroMemory(@ledYWeight, SizeOf(ledXWeight));
  
  iPixelSizeXSampleWidth := iPixelSize * SampleWidth;
  
  // RGB Y axis is inverted
  // range limits used to avoid integer overflow
  startPixel := AddrStart + iPixelSize * (aLed.Left + (SampleHeight - aLed.Top) * SampleWidth);
  for xPixel := 0 to Min(aLed.Right - aLed.Left, MaxPointSize)  do
    for yPixel := 0 to Min(aLed.Bottom - aLed.Top, MaxPointSize) do begin
      aPixel := PRGBQuad(startPixel + iPixelSize * xPixel - iPixelSizeXSampleWidth * yPixel);
      if aPixel.rgbRed = PIX_USED then begin
        aPixel.rgbRed := PIX_TRACKED;
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



function TSeuillageProcessor_RGB32.SetSeuil(bSeuil: Byte): HResult;
begin
  inherited SetSeuil(bSeuil);

  FillChar(GreyMask, SizeOf(TMaskSeuil), PIX_LIGHT);
  {$ifdef SSE2}
  //15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
  // X  R  G  B  X  R  G  B  X  R  G  B  X  R  G  B
  Mask1[2] := bSeuil - $80;
  Mask1[6] := bSeuil - $80;
  Mask1[10] := bSeuil - $80;
  Mask1[14] := bSeuil - $80;

  {$else}
  //  7  6  5  4   3  2  1  0
  //  X  R  G  B   X  R  G  B
  Mask1[2] := bSeuil - $80;
  Mask1[6] := bSeuil - $80;

  {$endif}

  Result := S_OK;
end;



function TSeuillageProcessor_RGB32.TestPixel(pPixel: Pointer): Boolean;
begin
  Result := RGBQuad(pPixel^).rgbRed = PIX_LIGHT;
end;



procedure TSeuillageProcessor_RGB32.Threshold(pData : pByte);
begin
  inherited;
  
  asm
    {$ifdef SSE2}
    mov eax, pData                            //eax point on first image bit
    sub eax, MM_SIZE                          //16 = sizeof xmm0
    mov ebx, self

    mov ecx, [ebx].TSeuillageProcessor.SampleSize      //1 loop updates 48 bytes
    movdqu xmm3, SignOffset                   //offset pour la conversion non-signé/signé
    movdqu xmm4, [ebx].TSeuillageProcessor.GreyMask
    movdqu xmm5, [ebx].TSeuillageProcessor.Mask1       //fixe le seuil sur 8 octects ds xmm1

    @loop:
    movdqu xmm0, [eax][ecx]
    movdqu xmm1, [eax][ecx - 1]
    movdqu xmm2, [eax][ecx - 2]
    PAVGB xmm0, xmm1                          // average across RGB
    PAVGB xmm1, xmm2
    PAVGB xmm0, xmm1
    PSUBB xmm0, xmm3                          // signed
    PCMPGTB xmm0, xmm5                        // compare
    PAND xmm0, xmm4                           // greymask
    movdqu [eax][ecx], xmm0                   // store

    sub ecx, MM_SIZE

    jnz @loop

    {$else}
    mov eax, pData                            //eax point on first image bit
    sub eax, MM_SIZE                          //16 = sizeof xmm0
    mov ebx, self

    mov ecx, [ebx].TSeuillageProcessor.SampleSize      //1 loop updates 48 bytes
    movq mm3, SignOffset                      //offset pour la conversion non-signé/signé
    movq mm4, [ebx].TSeuillageProcessor.GreyMask
    movq mm5, [ebx].TSeuillageProcessor.Mask1          //fixe le seuil sur 8 octects ds xmm1

    @loop:
    movq mm0, [eax][ecx]
    movq mm1, [eax][ecx - 1]
    movq mm2, [eax][ecx - 2]
    PAVGB mm0, mm1                          // average across RGB
    PAVGB mm1, mm2
    PAVGB mm0, mm1
    PSUBB mm0, mm3                          // signed
    PCMPGTB mm0, mm5                        // compare
    PAND mm0, mm4                           // greymask
    movq [eax][ecx], mm0                   // store

    sub ecx, MM_SIZE

    jnz @loop
    {$endif}

    emms
    end;
end;

end.

