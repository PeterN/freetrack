unit SeuillageProcessor_I420;

interface

uses
  BaseClass, DirectShow9, DSUtil, ActiveX, Windows, Math, Types,
  Seuillage_inc, SeuillageProcessor;

type
  TSeuillageProcessor_I420 = class(TSeuillageProcessor)
  private
    nbLoop : integer;
  protected
    procedure Find(pPixel : Pointer);override;
    procedure DrawCross(aPoint : TPoint);override;
    procedure DrawCenterCross;override;
    function PointCenterWeightedMean : TPoint;override;
    function TestPixel(pPixel: Pointer) : boolean;override;
  public
    constructor Create(aMediaType : PAMMediaType);override;
    procedure Threshold(pData : pByte);override;

    function SetSeuil(bSeuil: Byte): HResult;override;
  end;


{$i FreetrackFilter.inc}

implementation

{ TSeuillageProcessor_I420 }

constructor TSeuillageProcessor_I420.Create(aMediaType : PAMMediaType);
begin
  inherited;

  {$ifdef SSE2}
  nbLoop  :=  SampleSize*2 div 3;   //size*4/6
  {$else}
  nbLoop  :=  SampleSize*2 div 3;   //size*4/6
  {$endif}
end;



procedure TSeuillageProcessor_I420.DrawCenterCross;
var
  pPixelVert, pPixelHor : pByte;
  i : integer;
begin
  inherited;

  pPixelHor := pByte(FAddrStart + (SampleHeight * SampleWidth) shr 1);
  pPixelVert := pByte(FAddrStart + SampleWidth shr 1);

  for i := 0 to SampleWidth do begin
    if (Longint(pPixelHor) >= FAddrStart) and (Longint(pPixelHor) <= FAddrEnd) then
      pPixelHor^ := $30;
    if (Longint(pPixelVert) >= FAddrStart) and (Longint(pPixelVert) <= FAddrEnd) then
      pPixelVert^ := $30;

    inc(pPixelHor);
    inc(pPixelVert, SampleWidth);
  end;
end;



procedure TSeuillageProcessor_I420.DrawCross(aPoint: TPoint);
var
  pPixelVert, pPixelHor : pByte;
  i : integer;
begin
  inherited;

  pPixelHor := pByte(FAddrStart + ((aPoint.X - 15) + aPoint.Y * SampleWidth));
  pPixelVert := pByte(FAddrStart + (aPoint.X + ( aPoint.Y - 15) * SampleWidth));

  for i := 0 to 30 do begin
    if (Longint(pPixelHor) >= FAddrStart) and (Longint(pPixelHor) <= FAddrEnd) then
      pPixelHor^ := $BB;
    if (Longint(pPixelVert) >= FAddrStart) and (Longint(pPixelVert) <= FAddrEnd) then
      pPixelVert^ := $BB;

    inc(pPixelHor);
    inc(pPixelVert, SampleWidth);
  end;
end;



procedure TSeuillageProcessor_I420.Find(pPixel: Pointer);
  function inside(aPixAddr: LongInt) : boolean;
  begin
    result := (LongInt(pPixel) > FAddrStart) and (LongInt(pPixel) < FAddrEnd);
  end;
var
  x, y : integer;
  aPixAddr : integer;
begin
  if (NbPixelInLed >= NB_MAX_PIXELS) then
    Exit;

  try
    if (pByte(pPixel)^ = $FF) then begin
      pByte(pPixel)^ := $FE; // set the pixel as used
      inc(NbPixelInLed);

      asm
        mov esi, Self

        //x := ((Longint(pPixel) - AddrStart)div iPixelSize) mod SampleWidth;
        mov eax, Longint(pPixel)
        sub eax, [esi].TSeuillageProcessor.FAddrStart
        xor edx, edx
        div [esi].TSeuillageProcessor.SampleWidth

        mov x, edx
        mov y, eax
        //y := ((Longint(pPixel) - AddrStart)div iPixelSize) div SampleWidth;
      end;

      aLed.Top    := Min(aLed.Top, y);
      aLed.Bottom := Max(aLed.Bottom, y);
      aLed.Left   := Min(aLed.Left, x);
      aLed.Right  := Max(aLed.Right, x);

      aPixAddr := Longint(pPixel) - SampleWidth - 1;
      if inside(aPixAddr) then Find(pByte(aPixAddr));        //x-1,y+1
      inc(aPixAddr);
      if inside(aPixAddr) then Find(pByte(aPixAddr));        //x,y-1
      inc(aPixAddr);
      if inside(aPixAddr) then Find(pByte(aPixAddr));        //x+1,y-1

      inc(aPixAddr, SampleWidth - 2);
      if inside(aPixAddr) then Find(pByte(aPixAddr));        //x-1,y
      inc(aPixAddr, 2);
      if inside(aPixAddr) then Find(pByte(aPixAddr));        //x+1,y

      inc(aPixAddr, SampleWidth - 2);
      if inside(aPixAddr) then Find(pByte(aPixAddr));        //x-1,y-1
      inc(aPixAddr);
      if inside(aPixAddr) then Find(pByte(aPixAddr));        //x,y+1
      inc(aPixAddr);
      if inside(aPixAddr) then Find(pByte(aPixAddr));        //x+1,y+1
    end;

  except
    {On E : EAbort do
      Raise;
    else
      Raise Exception.Create('Error in TfmGrabber.Find');}
  end;
end;



function TSeuillageProcessor_I420.PointCenterWeightedMean: TPoint;
var
  jPixel : Integer;
  xPixel, yPixel, pixelCount, average_x, average_y : integer;
  aPixel : pByte;
  startPixel : LongInt;
begin
  pixelCount := 0;
  average_x := 0;
  average_y := 0;
  FillChar(ledXWeight, SizeOf(ledXWeight), 0);
  FillChar(ledYWeight, SizeOf(ledYWeight), 0);

  startPixel := FAddrStart + aLed.Left + aLed.Top * SampleWidth;
  for xPixel := 0 to (aLed.Right - aLed.Left) do
    for yPixel := 0 to (aLed.Bottom - aLed.Top) do begin
      aPixel := pByte(startPixel + xPixel + yPixel * SampleWidth);
      if aPixel^ = $FE then begin
        Inc(ledXWeight[xPixel]);
        Inc(ledYWeight[yPixel]);
        Inc(pixelCount);
      end;
    end;

  for jPixel := 0 to Max(aLed.Right - aLed.Left, aLed.Bottom - aLed.Top) do begin
    average_x := average_x + ledXWeight[jPixel] * (jPixel + 1);
    average_y := average_y + ledYWeight[jPixel] * (jPixel + 1);
  end;

  average_x := round((aLed.Left + (average_x / pixelCount) - 1) * 100);
  average_y := round((aLed.Top + (average_y / pixelCount) - 1) * 100);

  Result := Point(average_x, average_y);
end;




function TSeuillageProcessor_I420.SetSeuil(bSeuil: Byte): HResult;
var
  U, V : byte;
begin
  inherited SetSeuil(bSeuil);

  FillChar(Mask1, SizeOF(TMaskSeuil), bSeuil - $80);
  U := byte(( ( -38 * $FF + 128) shr 8) + 128);
  V := ( ( 112 * $FF + 128) shr 8) + 128;
  {R := 255;
  G := 0;
  B := 0;
  Y = 0.299 * R + 0.587 * G + 0.114 * B
  U := round(0.436 * (B - 0) / (1 - 0.114));
  V := round(0.615 * (R - 0) / (1 - 0.299));}

  FillChar(Mask2, SizeOF(TMaskSeuil), U);
  FillChar(Mask3, SizeOF(TMaskSeuil), V);

  Result := S_OK;
end;



function TSeuillageProcessor_I420.TestPixel(pPixel: Pointer): boolean;
begin
  Result := Byte(pPixel^) = $FF;
end;



procedure TSeuillageProcessor_I420.Threshold(pData: pByte);
begin
  inherited;

  asm
    {$ifdef SSE2}
    mov ebx, self
    mov eax, pData
    sub eax, MM_SIZE                          //16 == sizeof xmm0

    mov ecx, [ebx].TSeuillageProcessor_I420.nbLoop          //

    movdqu xmm2, SignOffset                   //offset de conversion unsigned/signed ds mm3 TBT : LDDQU
    movdqu xmm1, [ebx].TSeuillageProcessor.Mask1       //fixe le seuil sur 8 octects ds mm1

  @loopY:
    //Threshold
    movdqu xmm0, [eax][ecx]                   //mm0 reçoit pData^ (eax^ sur pData)
    psubb xmm0, xmm2                          //offet for signed comparaison
    pcmpgtb xmm0, xmm1                        //seuillage
    movdqu [eax][ecx], xmm0                   //store res

    sub ecx, MM_SIZE                          //16 bytes proceed by xmm0
    jnz @loopY

    //Red only
    mov ecx, [ebx].TSeuillageProcessor_I420.nbLoop
    add eax, ecx                              //eax now point on start of U
    shr ecx, 2                                //U is Y/4
    push ecx                                  //save size for V

    movdqu xmm0, [ebx].TSeuillageProcessor.Mask2       //erase U

  @loopU:
    movdqu [eax][ecx], xmm0                   //store res

    sub ecx, MM_SIZE                          //16 bytes proceed by xmm0
    jnz @loopU

    pop ecx                                   //retrieve nbloop for V
    add eax, ecx                              //eax now point on start of V

    movdqu xmm0, [ebx].TSeuillageProcessor.Mask3       //erase V

  @loopV:
    movdqu [eax][ecx], xmm0                   //store res

    sub ecx, MM_SIZE                          //16 bytes proceed by mm0
    jnz @loopV

    {$else}
    mov ebx, self
    mov eax, pData
    sub eax, MM_SIZE                          //8 == sizeof mm0

    mov ecx, [ebx].TSeuillageProcessor_I420.nbLoop          //

    movq mm1, SignOffset                      //offset de conversion unsigned/signed ds mm1
    movq mm5, [ebx].TSeuillageProcessor.Mask1          //fixe le seuil sur 8 octects ds mm5
    movq mm6, [ebx].TSeuillageProcessor.Mask2          //erase U
    movq mm7, [ebx].TSeuillageProcessor.Mask3          //erase V

  @loopY:
    //Threshold
    movq mm0, [eax][ecx]                      //mm0 reçoit pData^ (eax^ sur pData)
    psubb mm0, mm1                            //offet for signed comparaison
    pcmpgtb mm0, mm5                          //seuillage avec Mask1
    movq [eax][ecx], mm0                      //store res

    sub ecx, MM_SIZE                          //8 bytes proceed by mm0
    jnz @loopY

    //Red only
    mov ecx, [ebx].TSeuillageProcessor_I420.nbLoop
    add eax, ecx                              //eax now point on start of U
    shr ecx, 2                                //U is Y/4
    push ecx                                  //save size for V

  @loopU:
    movq [eax][ecx], mm6                      //store res

    sub ecx, MM_SIZE                          //16 bytes proceed by xmm0
    jnz @loopU

    pop ecx                                   //retrieve nbloop for V
    add eax, ecx                              //eax now point on start of V

  @loopV:
    movq [eax][ecx], mm7                      //store res

    sub ecx, MM_SIZE                          //16 bytes proceed by mm0
    jnz @loopV
    {$endif}

    emms
  end;
end;
end.

