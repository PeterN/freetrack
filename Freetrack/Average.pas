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

unit Average;

interface

uses
  Classes, Types, Parameters;

type
  TAverage = class (TObject)
  private
    FloatTotal: RPoint2D32f;
    FNbSamples: Integer;
    FPoint: TPoint;
    FPoint2D32f: RPoint2D32f;
    FVal: Single;
    IdxPoint: Integer;
    IdxPoint2D32f: Integer;
    IdxSingle: Integer;
    IntPts: array of TPoint;
    IntTotal: TPoint;
    Point2D32fs: TArrayOfPoint2D32f;
    Singles: array of single;
    SinglesTotal: Single;
    procedure SetNbSamples(const Value: Integer);
    procedure SetPoint(const Value: TPoint);
    procedure SetPoint2D32f(const Value: RPoint2D32f);
    procedure SetSingle(const Value: Single);
  public
    constructor Create;
    property NbSamples: Integer read FNbSamples write SetNbSamples;
    property Point: TPoint read FPoint write SetPoint;
    property Point2D32f: RPoint2D32f read FPoint2D32f write SetPoint2D32f;
    property Single: Single read FVal write SetSingle;
  end;
  


implementation

{
************************************************************* TAverage *************************************************************
}
{-


}
constructor TAverage.Create;
begin
  FNbSamples := 5;
end;

{-


}
procedure TAverage.SetNbSamples(const Value: Integer);
begin
  if Value > 0 then
    FNbSamples := Value
  else
    FNbSamples := 1;
end;

{-


}
procedure TAverage.SetPoint(const Value: TPoint);
begin
  if High(IntPts)+1 < FNbSamples then begin
    IdxPoint := High(IntPts) + 1;
    SetLength(IntPts, IdxPoint+1);
    IntPts[IdxPoint] := Value;
  end else begin
    IdxPoint := Succ(IdxPoint) mod  (High(IntPts) + 1);
    Dec(IntTotal.X, IntPts[IdxPoint].X);
    Dec(IntTotal.Y, IntPts[IdxPoint].Y);
    IntPts[IdxPoint] := Value;
  end;
  
  Inc(IntTotal.X, Value.X);
  Inc(IntTotal.Y, Value.Y);
  
  FPoint := Types.Point( Round(IntTotal.X / (High(IntPts)+1)), Round(IntTotal.Y / (High(IntPts)+1)));
end;

{-


}
procedure TAverage.SetPoint2D32f(const Value: RPoint2D32f);
var
  i, IdxPoint2D32f_remove : Integer;

begin
  if High(Point2D32fs)+1 < FNbSamples then begin
    IdxPoint2D32f := High(Point2D32fs) + 1;
    SetLength(Point2D32fs, IdxPoint2D32f+1);
    Point2D32fs[IdxPoint2D32f] := Value;
  end else if High(Point2D32fs)+1 > FNbSamples then begin
    IdxPoint2D32f := (Succ(IdxPoint2D32f) mod  (High(Point2D32fs) + 1));
    IdxPoint2D32f_remove := (Succ(IdxPoint2D32f) mod  (High(Point2D32fs) + 1));
    FloatTotal.x := FloatTotal.x - Point2D32fs[IdxPoint2D32f].X
                    - Point2D32fs[IdxPoint2D32f_remove].X;
    FloatTotal.y := FloatTotal.y - Point2D32fs[IdxPoint2D32f].Y
                    - Point2D32fs[IdxPoint2D32f_remove].Y;
    if IdxPoint2D32f_remove < High(Point2D32fs) then begin
      for i := IdxPoint2D32f_remove to (High(Point2D32fs) - 1) do
        Point2D32fs[i] := Point2D32fs[i + 1];
    end;
    if IdxPoint2D32f = High(Point2D32fs) then begin
      SetLength(Point2D32fs, High(Point2D32fs));
      Point2D32fs[IdxPoint2D32f - 1] := Value;
    end else begin
      SetLength(Point2D32fs, High(Point2D32fs));
      Point2D32fs[IdxPoint2D32f] := Value;
    end;
  end else begin
    IdxPoint2D32f := Succ(IdxPoint2D32f) mod  (High(Point2D32fs) + 1);
    FloatTotal.x := FloatTotal.x - Point2D32fs[IdxPoint2D32f].X;
    FloatTotal.y := FloatTotal.y - Point2D32fs[IdxPoint2D32f].Y;
    Point2D32fs[IdxPoint2D32f] := Value;
  end;
  
  FloatTotal.X := FloatTotal.X + Value.X;
  FloatTotal.Y := FloatTotal.Y + Value.Y;
  
  FPoint2D32f.x := FloatTotal.X / (High(Point2D32fs)+1);
  FPoint2D32f.y := FloatTotal.Y / (High(Point2D32fs)+1);
end;

{-


}
procedure TAverage.SetSingle(const Value: Single);
begin
  if High(Singles)+1 < FNbSamples then begin
    IdxSingle := High(Singles) + 1;
    SetLength(Singles, IdxSingle+1);
    Singles[IdxSingle] := Value;
  end else begin
    IdxSingle := Succ(IdxSingle) mod  (High(Singles) + 1);
    SinglesTotal := SinglesTotal - Singles[IdxSingle];
    Singles[IdxSingle] := Value;
  end;
  
  SinglesTotal := SinglesTotal + Value;
  
  FVal := SinglesTotal / (High(Singles)+1);
end;


end.
