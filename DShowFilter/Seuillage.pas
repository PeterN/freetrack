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

unit Seuillage;

interface

{$i FreetrackFilter.inc}

{.$define DEBUG}

uses
  BaseClass, DirectShow9, DSUtil, ActiveX, Windows, Math, Types, Seuillage_inc,
  Dialogs, cpuid, SeuillageProcessor
  {$ifdef DEBUG}
  ,Classes, SysUtils
  {$endif}
  ;

const
  {$ifdef SSE2}
  MM_SIZE = 16;
  {$else}
  MM_SIZE = 8;
  {$endif}

type
  TMaskSeuil =  array[0..MM_SIZE-1] of byte;

  TSeuillage  = class(TBCTransInPlaceFilter, IPersist, ISpecifyPropertyPages, ISeuil)
  private
    fSeuil : byte;
    fIsActive : Boolean;
    MinPointSize, MaxPointSize  : Integer;
    fOnLedDetected : TOnLedDetectedCB;

    fSeuillageProcessor : TSeuillageProcessor;
    function CanPerformTransform(const pMediaType : PAMMediaType) : boolean;
  public
    constructor CreateFromFactory(Factory: TBCClassFactory; const Controller: IInterface);override;
    Destructor Destroy;override;

    function CheckInputType(mtIn: PAMMediaType): HRESULT;override;
    function Transform(Sample: IMediaSample): HRESULT;override;

    (*** ISpecifyPropertyPages methods ***)
    function GetPages(out pages: TCAGUID): HResult; stdcall;

    (*** IFreeTrack methods ***)
    function SetMaxPointSize(Size : Byte): HResult;stdcall;
    function GetMaxPointSize(pSize : PByte): HResult;stdcall;
    function SetMinPointSize(Size : Byte): HResult;stdcall;
    function GetMinPointSize(pSize : PByte): HResult;stdcall;

    function SetNoise(noise1, noise2 : byte): HResult;stdcall;

    function GetSeuil( pbSeuil : PByte): HResult;stdcall;
    function SetSeuil(bSeuil : Byte): HResult;stdcall;

    function GetActive( pIsActive : PBoolean): HResult;stdcall;
    function SetActive(isActive : Boolean): HResult;stdcall;

    function SetCallback(pCallback :  TOnLedDetectedCB ): HResult; stdcall;
    function GetCallBack(var pCallback: TOnLedDetectedCB ): HResult; stdcall;
  end;


  
implementation

uses SeuilProp_fm;

const
  {$ifdef SSE2}
  SignOffset : TMaskSeuil = ($80, $80, $80, $80, $80, $80, $80, $80,
                             $80, $80, $80, $80, $80, $80, $80, $80);
  {$else}
  SignOffset : TMaskSeuil = ($80, $80, $80, $80, $80, $80, $80, $80);
  {$endif}

constructor TSeuillage.CreateFromFactory(Factory: TBCClassFactory; const Controller: IInterface);
begin
  inherited;

  fIsActive := False;

  fSeuil := 127;
  MinPointSize := 0;
  MaxPointSize := 119;
end;



Destructor TSeuillage.Destroy;
begin
  {$ifdef DEBUG}
   DbgLog('!!!!!!!!!!!!!!  TSeuillage.Destroy');
  {$endif}
  FreeAndNil(fSeuillageProcessor);

  inherited;
end;



///////////////////////////////////////////////////////////////////////
// canPerformTransform: We support RGB24 and RGB32 input
///////////////////////////////////////////////////////////////////////
function TSeuillage.CanPerformTransform(const pMediaType : PAMMediaType) : boolean;
begin
  Result := False;

  // we accept the following image type: (RGB24, ARGB32 or RGB32)
  if (IsEqualGUID(pMediaType.majortype, MEDIATYPE_Video)) then begin
    FreeAndNil(fSeuillageProcessor);
    fSeuillageProcessor := TSeuillageProcessorFactory.CreateSeuillageProcessor(pMediaType);
    if Assigned(fSeuillageProcessor) then begin
      fSeuillageProcessor.SetSeuil(fSeuil);
      fSeuillageProcessor.SetCallback(FOnLedDetected);
      fSeuillageProcessor.SetMaxPointSize(MaxPointSize);
      fSeuillageProcessor.SetMinPointSize(MinPointSize);
      Result := True;
    end else
      Result := False;
  end;
end;



function TSeuillage.CheckInputType(mtIn: PAMMediaType): HRESULT;
begin
  {$ifdef DEBUG}
   DbgLog('!!!!!!!!!!!!!!  TSeuillage.CheckInputType');
  {$endif}
  if (canPerformTransform(mtIn)) then
    Result := S_OK
  else
    Result := VFW_E_TYPE_NOT_ACCEPTED;
end;




function TSeuillage.GetPages(out pages: TCAGUID): HResult;
begin
  {$ifdef DEBUG}
  DbgLog('!!!!!!!!!!!!!!  TSeuillage.GetPages');
  {$endif}
  Pages.cElems := 1;
  Pages.pElems := CoTaskMemAlloc(sizeof(TGUID) * Pages.cElems);
  if (Pages.pElems = nil) then begin
    Result := E_OUTOFMEMORY;
    Exit;
  end;
  Pages.pElems^[0] := CLSID_SeuilPageSettings;
  Result := S_OK;
end;



function TSeuillage.SetMinPointSize(Size : Byte): HResult;
begin
  MinPointSize := Size - 1;
  Result := S_OK;

  if Assigned(fSeuillageProcessor) then
    Result := fSeuillageProcessor.SetMinPointSize(MinPointSize);   // 0 point size is diameter 1
end;



function TSeuillage.SetMaxPointSize(Size : Byte): HResult;
begin
  MaxPointSize  := Size-1;
  Result := S_OK;

  if Assigned(fSeuillageProcessor) then
    Result := fSeuillageProcessor.SetMaxPointSize(MaxPointSize);  // 0 point size is diameter 1
end;



function TSeuillage.GetSeuil( pbSeuil : PByte): HResult;
begin
  pbSeuil^ := fSeuil;
  Result := S_OK;
end;



function TSeuillage.SetSeuil(bSeuil : Byte): HResult;
begin
  fSeuil := bSeuil;
  Result := S_OK;

  if Assigned(fSeuillageProcessor) then
    Result := fSeuillageProcessor.SetSeuil(bSeuil);
end;



function TSeuillage.SetNoise(noise1, noise2 : Byte): HResult;
begin
  Result := S_OK;

  if Assigned(fSeuillageProcessor) then
    Result := fSeuillageProcessor.SetNoise(noise1, noise2);
end;



function TSeuillage.GetActive(pIsActive: PBoolean): HResult;
begin
  pIsActive^ := fIsActive;
  Result := S_OK;
end;



function TSeuillage.SetActive(isActive: Boolean): HResult;
begin
  fIsActive := isActive;
  Result := S_OK;
end;



function TSeuillage.SetCallback(pCallback: TOnLedDetectedCB): HResult;
begin
  FOnLedDetected := pCallback;
  if Assigned(fSeuillageProcessor) then
    Result := fSeuillageProcessor.SetCallback(pCallback)
  else
    Result := S_OK;
end;



function TSeuillage.GetCallBack(var pCallback: TOnLedDetectedCB): HResult;
begin
  pCallback := FOnLedDetected;
  Result := S_OK;
end;



function TSeuillage.Transform(Sample: IMediaSample): HRESULT;
var
  pData : pByte;         // Pointer to the actual image buffer
begin
  if not (Assigned(fSeuillageProcessor) and fIsActive) then begin
    Result := S_OK;
    Exit;
  end;

  FLock.Lock;
  try
    Sample.GetPointer(pData);
    fSeuillageProcessor.Threshold(pData);
    fSeuillageProcessor.Locate(pData, FClock);
  finally
    FLock.UnLock;
  end;

  Result := S_OK;
end;


function TSeuillage.GetMaxPointSize(pSize: PByte): HResult;
begin
  pSize^ := MaxPointSize + 1;
  Result := S_OK;
end;



function TSeuillage.GetMinPointSize(pSize: PByte): HResult;
begin
  pSize^ := MinPointSize + 1;
  Result := S_OK;
end;



initialization
  TBCClassFactory.CreateFilter(TSeuillage, 'FreeTrackFilter', CLSID_Seuillage,
                               CLSID_LegacyAmFilterCategory, MERIT_DO_NOT_USE, 0, nil);


end.
