unit SeuillageProcessor_CbCr;

interface

uses
  BaseClass, DirectShow9, DSUtil, ActiveX, Windows, Math, Types,
  Seuillage_inc, SeuillageProcessor;

type
  TSeuillageProcessor_CbCr = class (TSeuillageProcessor)
  protected
    PlanarUVPresent: Integer;
    UVShiftY: Byte;
    YEnd: Integer;
    UVMask: TMaskSeuil;
    ZeroMask: TMaskSeuil;
    OldData: array of byte;
    nbLoop : Integer;
    function Inside(aPixAddr: LongInt): Boolean; override;
    procedure SetAddrStart(const Value: longint); override;
  public
    constructor Create(pMediaType : PAMMediaType); override;
    function SetSeuil(bSeuil: Byte): HResult; override;
    procedure Threshold(pData : pByte); override;
  end;

const
  X_POINT_COL = $80;
  X_CENTER_COL = $50;

  POINT_MAX_DIM = 100;

  X_POINT_SIZE = 15;
  X_POINT_SIZE_HALF = X_POINT_SIZE div 2;

  
{$i FreetrackFilter.inc}

implementation

{
*************************** TSeuillageProcessor_CbCr ***************************
}
constructor TSeuillageProcessor_CbCr.Create(pMediaType : PAMMediaType);
begin
  inherited;

  if IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_YVU9) or
    IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_IF09) or   // need codec to test
    IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_YV12) or
    IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_YV16) or   // need codec to test
    IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_IYUV) or
    IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_I420) or
    IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_NV12) or  // USB Video Class (USB)
    IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_IMC1) or
    IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_IMC2) or
    IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_IMC3) or
    IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_IMC4) or
    IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_Y800) or  // need codec to test
    IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_Y8) or    // need codec to test
    IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_RGB8) or
    IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_GREY) then begin

    PlanarUVPresent := 1;
    nbLoop := nbPixels;

    if IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_YVU9) then
      UVshiftY := 3    // 4x4 subsamples
    else if IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_IF09) then
      UVshiftY := 2    // two sets of 4x4 subsamples
    else if IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_YV16) then
      UVshiftY := 0   // 2x1 subsamples
    else
      UVshiftY := 1;  // 2x2 subsamples

  end else begin
    PlanarUVPresent := 0;
    nbLoop := SampleSize;
  end;

   FillChar(ZeroMask, SizeOf(TMaskSeuil), $80);
   SetLength(OldData, nbLoop);
end;



function TSeuillageProcessor_CbCr.Inside(aPixAddr: LongInt): Boolean;
begin
  Result := (aPixAddr > FAddrStart) and (aPixAddr < YEnd);
end;



procedure TSeuillageProcessor_CbCr.SetAddrStart(const Value: longint);
begin
  inherited;
  YEnd := FAddrStart + nbLoop;
end;



function TSeuillageProcessor_CbCr.SetSeuil(bSeuil: Byte): HResult;
begin
  FillChar(ZeroMask, SizeOf(TMaskSeuil), $80);
  Result := S_OK;
end;

                                                                 // faster but less protection
procedure TSeuillageProcessor_CbCr.Threshold(pData : pByte); assembler;
{var
  diff, n2mask : TMaskSeuil;
{var
  aLoop : Integer;
  n1, n2 : TMaskSeuil;
  pOldData : pByte;
  diff : TMaskSeuil;
begin
  {inherited;

  aLoop := nbLoop;
  n1 := Noise1;
  n2 := Noise2;
  pOldData := @OldData;    }
//begin
  //inherited;
  asm
    push ebx

    mov ebx, self
    mov eax, pData
    mov edx, [ebx].TSeuillageProcessor.OldData
    sub eax, MM_SIZE
    sub edx, MM_SIZE

    mov ecx, [ebx].TSeuillageProcessor.nbLoop
    {$ifdef SSE2}

    movdqu xmm6, SignOffset

    // Dynamic noise reduction
    // too jerky, avoid using a discrete threshold and think continuous instead
   { @loopY1:
    movdqu xmm1, [ebx].TSeuillageProcessor.Noise1
    movdqu xmm2, [ebx].TSeuillageProcessor.Noise2

    movdqu xmm0, [eax][ecx]                    // newdata
    movdqu xmm4, [edx][ecx]                    // olddata
    PSUBB xmm0, xmm6                          // signed newdata
    PSUBB xmm4, xmm6                          // signed olddata
    PCMPGTB xmm0, xmm4                          // newdata > olddata
    movdqu xmm5, [eax][ecx]                    // newdata
    PSUBB xmm5, xmm4                           // diff1 := newdata - olddata
    PAND xmm5, xmm0                            // diff1 masked
    movdqu xmm3, [eax][ecx]                    // newdata
    PSUBB xmm4, xmm3                           // diff2 := olddata - newdata
    PANDN xmm0, xmm4                           // diff2 masked
    PADDD xmm0, xmm5                           // diff = diff1 + diff2
    movdqu diff, xmm0

    movdqu xmm4, [eax][ecx]                   // newdata
    movdqu xmm3, [edx][ecx]                   // olddata
    PCMPGTB xmm0, xmm2                        // diff > noise2
    movdqu n2mask, xmm0
    PAND xmm4, xmm0                           // use new data above noise2
    PANDN xmm0, xmm3                          // clear room for newdata in olddata
    PADDD xmm0, xmm4                          // combine
    movdqu xmm5, xmm0

    movdqu xmm0, diff                         // diff
    movdqu xmm4, [eax][ecx]                   // newdata
    movdqu xmm6, n2mask
    PANDN xmm6, xmm0                            // remove all diff above noise2
    PCMPGTB xmm6, xmm1                        // diff > noise1 and < noise2
    PAND xmm4, xmm6                           // newdata with diff between noise1 and noise2
    PAVGB xmm4, xmm5                          // average

    movdqu [eax][ecx], xmm4                   // store in newdata
    movdqu [edx][ecx], xmm4                   // store in olddata

    sub ecx, MM_SIZE
    jnz @loopY1 }

    movdqu xmm2, SignOffset                //offset de conversion unsigned/signed ds mm3 TBT : LDDQU
    movdqu xmm3, [ebx].TSeuillageProcessor.Mask1       //fixe le seuil sur 8 octects ds mm1
    movdqu xmm4, [ebx].TSeuillageProcessor.UVMask
    movdqu xmm5, [ebx].TSeuillageProcessor.GreyMask
    mov ecx, [ebx].TSeuillageProcessor.nbLoop

    //Threshold
    @loopY2:
    movdqu xmm0, [eax][ecx]                   //mm0 reçoit pData^ (eax^ sur pData)
    PSUBB xmm0, xmm2                          //offet for signed comparaison
    PCMPGTB xmm0, xmm3                        //seuillage
    PAND xmm0, xmm5                           //greymask
    PADDD xmm0, xmm4                          //set u and v to neutral for packed case
    movdqu [eax][ecx], xmm0

    sub ecx, MM_SIZE                          //16 bytes proceed by xmm0
    jnz @loopY2

    mov ecx, [ebx].TSeuillageProcessor_CbCr.PlanarUVPresent     // only clear UV component if present!
    cmp ecx, 1
    jne @skipUV

    movdqu xmm4, [ebx].TSeuillageProcessor_CbCr.ZeroMask

    //UV
    mov ecx, [ebx].TSeuillageProcessor.nbLoop
    add eax, ecx                              //eax now point on start of UV
    mov cl, [ebx].TSeuillageProcessor_CbCr.UVshiftY
    shr ecx, cl                              // UV range

    @loopUV:
    movdqu [eax][ecx], xmm4                   //store res
  
    sub ecx, MM_SIZE                          //16 bytes proceed by mm0
    jnz @loopUV
    @skipUV:    

    {$else}
    movq mm2, SignOffset                      //offset de conversion unsigned/signed ds mm1
    movq mm3, [ebx].TSeuillageProcessor.Mask1       //fixe le seuil sur 8 octects ds mm1
    movq mm4, [ebx].TSeuillageProcessor.UVMask
    movq mm5, [ebx].TSeuillageProcessor.GreyMask

    @loopY:
    //Threshold
    movq mm0, [eax][ecx]                      //mm0 reçoit pData^ (eax^ sur pData)
    PSUBB mm0, mm2                            //offet for signed comparaison
    PCMPGTB mm0, mm3                          //seuillage avec Mask1
    PAND mm0, mm5                              //greymask
    PADDD mm0, mm4                            //if packed, set u and v to neutral
    movq [eax][ecx], mm0                      //store res

    sub ecx, MM_SIZE                          //16 bytes proceed by mm0
    jnz @loopY

    mov ecx, [ebx].TSeuillageProcessor_CbCr.PlanarUVPresent       // only clear UV component if present!
    cmp ecx, 1
    jne @skipUV

    movq mm4, [ebx].TSeuillageProcessor_CbCr.ZeroMask
  
    //UV
    mov ecx, [ebx].TSeuillageProcessor.nbLoop
    add eax, ecx                              //eax now point on start of UV
    mov cl, [ebx].TSeuillageProcessor_CbCr.UVshiftY
    shr ecx, cl                              // UV range

    @loopUV:
    movq [eax][ecx], mm4                      //store res
  
    sub ecx, MM_SIZE                          //16 bytes proceed by mm0
    jnz @loopUV
    @skipUV:
  
    {$endif}

    pop ebx
    emms
  end;
//end;



end.
