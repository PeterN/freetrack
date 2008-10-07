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

unit Seuillage_inc;

interface

uses
  Windows, Classes, DirectShow9;

const
  CLSID_Seuillage  : TGUID = '{0A99F2CA-79C9-4312-B78E-ED6CB3829275}';
  IID_ISeuil   : TGUID = '{6E52F36F-22F9-441B-827A-52B1DFE37584}';
  IID_IFreeTrackCallBack : TGUID = '{982E0244-94C2-4FE3-BE84-98074FE537C6}';

  // I420 same as IYUV
  MEDIASUBTYPE_I420 : TGUID ='{30323449-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_Y800 : TGUID ='{30303859-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_Y8 : TGUID ='{20203859-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_Y160 : TGUID ='{30363159-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_YV16 : TGUID ='{32315659-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_Y422 : TGUID ='{32323459-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_GREY : TGUID ='{59455247-0000-0010-8000-00AA00389B71}';

  LISTPOINT_SCALER = 100;
  LISTPOINT_SCALER_INV = 0.01;

  X_POINT_SIZE = 15;
  X_POINT_SIZE_HALF = X_POINT_SIZE div 2;

type
  TListPoint = class(TList)
  private
    function GetItems(Index: Integer): TPoint;
    procedure SetItems(Index: Integer; const Value: TPoint);
  public
    ReferenceClock : IReferenceClock;
    function SortY : boolean;
    function SortCap : boolean;
    function Add(const aPoint : TPoint): Integer;reintroduce;
    procedure Clear;override;

    property Items[Index: Integer] : TPoint read GetItems write SetItems; default;
  end;



  TListRect = class(TList)
  private
    FOffset: TPoint;
    function GetItems(Index: Integer): TRect;
    procedure SetItems(Index: Integer; const Value: TRect);
  public
    function Add(const aRect : TRect): Integer;reintroduce;
    procedure Delete(Index: Integer);
    procedure Clear; override;
    function Sort : boolean;

    property Items[Index: Integer] : TRect read GetItems write SetItems; default;
    property Offset : TPoint read FOffset write FOffset;
  end;


  TOnLedDetectedCB = procedure(Points : TListPoint) of object;

  ISeuil = interface(IUnknown)
    ['{6E52F36F-22F9-441B-827A-52B1DFE37584}']
    function SetMaxPointSize(Size : Byte): HResult;stdcall;
    function GetMaxPointSize(pSize : PByte): HResult;stdcall;
    function SetMinPointSize(Size : Byte): HResult;stdcall;
    function GetMinPointSize(pSize : PByte): HResult;stdcall;

    function SetNoise(noise1, noise2 : Byte): HResult;stdcall;

    function GetSeuil( pbSeuil : PByte): HResult;stdcall;
    function SetSeuil(bSeuil : Byte): HResult;stdcall;

    function GetActive( pIsActive : PBoolean): HResult;stdcall;
    function SetActive(isActive : Boolean): HResult;stdcall;

    function SetCallback(pCallback: TOnLedDetectedCB ): HResult;stdcall;
    function GetCallBack(var pCallback: TOnLedDetectedCB ): HResult;stdcall;
  end;



implementation


uses Types, Math;

function SortBy_Y(Item1, Item2 : Pointer):Integer;
begin
  //  >0 (positive)	Item1 est inférieur àItem2.
  //Result := TPoint(Item2^).y - TPoint(Item1^).y;
  Result := TPoint(Item1^).y - TPoint(Item2^).y;
end;


function SortBy_X(Item1, Item2 : Pointer):Integer;
begin
  //  >0 (positive)	Item1 est inférieur àItem2.
  //Result := TPoint(Item2^).y - TPoint(Item1^).y;
  Result := TPoint(Item1^).x - TPoint(Item2^).x;
end;



function TListPoint.GetItems(Index: Integer): TPoint;
begin
  Result := TPoint((inherited Items[index])^) ;
end;



procedure TListPoint.SetItems(Index: Integer; const Value: TPoint);
begin
  inherited Items[index] := @Value;
end;



function TListPoint.SortCap : boolean;
var
  i, TopY, IdxTop : integer;
begin
  inherited Sort(@SortBy_X);

  TopY := MaxInt;
  IdxTop := 0;
  for i := 0 to Count - 1 do
    if items[i].Y < TopY then begin
      TopY := Items[i].Y;
      IdxTop := i;
    end;

  Move(IdxTop, 0);

  Result := True;

end;


function TListPoint.SortY : boolean;
begin
  inherited Sort(@SortBy_Y);
  Result := True;
end;


function TListPoint.Add(const aPoint : TPoint): Integer;
var
  p : pointer;
begin
  GetMem(p, SizeOf(TPoint));
  TPoint(p^) := aPoint;
  Result := inherited Add(p);
end;



procedure TListPoint.Clear;
var
  i : integer;
begin
  for i := Count - 1 downto 0 do
    Delete(i);
  inherited Clear; 
end;



{ TListRect }

function SortRects(Item1, Item2 : Pointer):Integer;
begin
  //  >0 (positive)	Item1 est inférieur àItem2.
  Result := TRect(Item2^).Left - TRect(Item1^).Left;
end;


function TListRect.Add(const aRect: TRect): Integer;
var
  p : pointer;
begin
  GetMem(p, SizeOf(TRect));
  TRect(p^) := aRect;
  Result := inherited Add(p);
end;



procedure TListRect.Clear;
var
  i : integer;
begin
  for i := Count - 1 downto 0 do
    Delete(i);
  inherited Clear;
end;



procedure TListRect.Delete(Index: Integer);
begin
  FreeMem( inherited items[index]);
  inherited  Delete (Index);
end;



function TListRect.GetItems(Index: Integer): TRect;
begin
  Result := TRect((inherited Items[index])^) ;
  OffsetRect(Result, FOffset.X, FOffset.Y);
end;



procedure TListRect.SetItems(Index: Integer; const Value: TRect);
begin
  inherited Items[index] := @Value;
end;



function TListRect.Sort: boolean;
begin
  if Count = 4 then begin
    inherited Sort(@SortRects);

    //classe les 2 pts les + à gauche
    if Items[0].Top > Items[1].Top then
      Exchange(0, 1);

    //classe les 2 pts les + à droite
    if Items[2].Top > Items[3].Top then
      Exchange(2, 3);

     Result := True;
  end else
    Result := False;
end;

end.
