unit SeuillageProcessor;

interface

uses
  BaseClass, DirectShow9, DSUtil, ActiveX, Windows, Math, Types, Dialogs,
  Seuillage_inc, cpuid;

{$i FreetrackFilter.inc}

const
  {$ifdef SSE2}
  MM_SIZE = 16;
  {$else}
  MM_SIZE = 8;
  {$endif}

type
  TMaskSeuil =  array[0..MM_SIZE-1] of byte;

  TSeuillageProcessor = class (TObject)
  protected
    aLed: TRect;
    FAddrEnd: LongInt;
    FAddrStart: LongInt;
    FOnLedDetected: TOnLedDetectedCB;
    iPixelSize: Integer;
    ledXWeight: array[0..200] of Integer;
    ledYWeight: array[0..200] of Integer;
    ListPoint: TListPoint;
    Mask1, Mask2, Mask3: TMaskSeuil;
    GreyMask : TMaskSeuil;
    Noise1, Noise2 : TMaskSeuil;
    MaxPointSize: Integer;
    MinPointSize: Integer;
    NbPixelInLed: Integer;
    nbPixels: Integer;
    SampleHeight: LongInt;
    SampleSize: LongInt;
    SampleWidth: LongInt;
    procedure DrawCenterCross; virtual; abstract;
    procedure DrawCross(aPoint : TPoint); virtual; abstract;
    procedure Find(pPixel : Pointer); dynamic; abstract;  // dynamic: required to avoid exception errors
    function Inside(aPixAddr: LongInt): Boolean; virtual;
    function PointCenterWeightedMean: TPoint; virtual; abstract;
    procedure SetAddrStart(const Value: LongInt); virtual;
    function TestPixel(pPixel: Pointer): Boolean; virtual; abstract;
  public
    constructor Create(pMediaType : PAMMediaType); virtual;
    destructor Destroy; override;
    procedure Locate(pPixel : Pointer; aClock : IReferenceClock);
    function SetCallback(pCallback :  TOnLedDetectedCB): HResult;
    function SetMaxPointSize(Size : Integer): HResult;
    function SetMinPointSize(Size : Integer): HResult;
    function SetSeuil(bSeuil : Byte): HResult; virtual;
    function SetNoise(n1, n2: Byte): HResult; virtual;
    procedure Threshold(pData : pByte); virtual;
    property AddrStart: LongInt read FAddrStart write SetAddrStart;
  end;
  


  TSeuillageProcessorFactory = class (TObject)
    class function CreateSeuillageProcessor(pMediaType : PAMMediaType): 
            TSeuillageProcessor;
  end;
  
const
  NB_MAX_PIXELS = 120;//80;
  NB_MIN_PIXELS = 3;
  MIN_LENGTH    = 1;

  PIX_LIGHT = $A0;
  PIX_USED = PIX_LIGHT + 1;
  PIX_TRACKED = $FF;

  POINT_MAX_DIM = 100;

  {$ifdef SSE2}
  SignOffset : TMaskSeuil = ($80, $80, $80, $80, $80, $80, $80, $80,
                             $80, $80, $80, $80, $80, $80, $80, $80);
  {$else}
  SignOffset : TMaskSeuil = ($80, $80, $80, $80, $80, $80, $80, $80);
  {$endif}


implementation

uses
  SeuillageProcessor_RGB24, SeuillageProcessor_CbCr, SeuillageProcessor_RGB32,
  SeuillageProcessor_YUV, SeuillageProcessor_YUYV, SeuillageProcessor_UYVY;

{ TSeuillageProcessor }


{
***************************** TSeuillageProcessor ******************************
}
constructor TSeuillageProcessor.Create(pMediaType : PAMMediaType);
var
  pvi: PVideoInfoHeader;
begin
  pvi := pMediaType.pbFormat;

  iPixelSize := pvi.bmiHeader.biBitCount div 8;
  nbPixels   := abs(pvi.bmiHeader.biWidth * pvi.bmiHeader.biHeight);
  SampleWidth := pvi.bmiHeader.biWidth;
  SampleHeight := abs(pvi.bmiHeader.biHeight);
  SampleSize   := pvi.bmiHeader.biSizeImage;

  ListPoint := TListPoint.Create;
end;



destructor TSeuillageProcessor.Destroy;
begin
  FreeAndNil(ListPoint);
  inherited;
end;



function TSeuillageProcessor.Inside(aPixAddr: LongInt): Boolean;
begin
  result := (aPixAddr > FAddrStart) and (aPixAddr < FAddrEnd);
end;



procedure TSeuillageProcessor.Locate(pPixel : Pointer; aClock :
        IReferenceClock);
var
  iPixel: Integer;
  aPoint: TPoint;
  aPointXDim, aPointYDim: Integer;
begin
  AddrStart := longint(pPixel);
  ListPoint.Clear;
  for iPixel := 0 to (nbPixels shr 1)-1 do begin
    if TestPixel(pPixel) then begin
      aLed.Top := SampleHeight;
      aLed.Bottom := -1;
      aLed.Left := SampleWidth;
      aLed.Right := -1;
      NbPixelInLed := 0;

      Find(pByte(pPixel));

      aPointXDim := abs(aLed.Right - aLed.Left + 1);
      aPointYDim := abs(aLed.Bottom - aLed.Top + 1);

      if  (aPointXDim > MinPointSize) and (aPointYDim > MinPointSize) and
          (aPointXDim < MaxPointSize) and (aPointYDim < MaxPointSize) then begin

        aPoint := PointCenterWeightedMean;
        ListPoint.Add(aPoint);

        aPoint := Point(aLed.Left + (aLed.Right - aLed.Left) shr 1, aLed.Top + (aLed.Bottom - aLed.Top) shr 1);
        DrawCross(aPoint);
      end;

      if ListPoint.Count > 4 then
        Break;
    end;
    pPixel := Pointer(Longint(pPixel) + iPixelSize shl 1 );   //on test un pixel sur deux
  end;
  DrawCenterCross;

  ListPoint.ReferenceClock := aClock;
  if Assigned(FOnLedDetected) then
    FOnLedDetected(ListPoint);

end;



procedure TSeuillageProcessor.SetAddrStart(const Value: LongInt);
begin
  FAddrStart := Value;
  FAddrEnd   := AddrStart + SampleSize;
end;



function TSeuillageProcessor.SetCallback(pCallback :  TOnLedDetectedCB): 
        HResult;
begin
  FOnLedDetected := pCallback;
  Result := S_OK;
end;



function TSeuillageProcessor.SetMaxPointSize(Size : Integer): HResult;
begin
  MaxPointSize := Size;
  Result := S_OK;
end;



function TSeuillageProcessor.SetMinPointSize(Size : Integer): HResult;
begin
  MinPointSize := Size;
  Result := S_OK;
end;



function TSeuillageProcessor.SetSeuil(bSeuil : Byte): HResult;
begin
  FillChar(Mask1, SizeOf(TMaskSeuil), 127);
  FillChar(Mask2, SizeOf(TMaskSeuil), 127);
  FillChar(Mask3, SizeOf(TMaskSeuil), 127);
  FillChar(GreyMask, SizeOF(TMaskSeuil), 0);
  Result := S_OK;
end;


function TSeuillageProcessor.SetNoise(n1, n2: Byte): HResult;
begin
  FillChar(Noise1, SizeOf(TMaskSeuil), n1 - $80);
  FillChar(Noise2, SizeOf(TMaskSeuil), n2 - $80);
  Result := S_OK;
end;



procedure TSeuillageProcessor.Threshold(pData : pByte);
begin
  AddrStart := longint(pData);
end;


{
************************** TSeuillageProcessorFactory **************************
}
class function TSeuillageProcessorFactory.CreateSeuillageProcessor(pMediaType :
        PAMMediaType): TSeuillageProcessor;
begin
  Result := nil;

  if IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_RGB8) then
    Result := TSeuillageProcessor_YUV.Create(pMediaType);

  if IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_YVU9) or
    IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_IF09) or  // need codec to test
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

    Result := TSeuillageProcessor_YUV.Create(pMediaType);
    Exit;
  end;

  if (IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_RGB24))then begin
    Result := TSeuillageProcessor_RGB24.Create(pMediaType);
    Exit;
  end;

  if (IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_RGB32))then begin
    Result := TSeuillageProcessor_RGB32.Create(pMediaType);
    Exit;
  end;

  if IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_YUYV) or
    IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_YUY2) or // USB Video Class (USB)
    IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_YVYU) then begin

    Result := TSeuillageProcessor_YUYV.Create(pMediaType);
    Exit;
  end;

  if  IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_UYVY) or
      IsEqualGUID(pMediaType.subtype, MEDIASUBTYPE_Y422) then begin
    Result := TSeuillageProcessor_UYVY.Create(pMediaType);
    Exit;
  end;


end;



end.

