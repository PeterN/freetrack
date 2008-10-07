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
unit SideBar;

interface

uses
  Windows, Messages, Classes, ExtCtrls, ComCtrls, Controls, Forms, Graphics, SysUtils,
  Dialogs;

type
  TAnimateDir = (adDown, adUp);

  TSideBar = Class(TCustomPanel)
  private
    FPageCtrl : TPageControl;
    FButtonHeight: integer;
    DownIndex: integer;
    Leaved : Boolean;
    FTabVisible: Boolean;
    procedure SetButtonHeight(const Value: integer);
    procedure DrawButtons;
    procedure GestOnChange(Sender : TObject);
    procedure RedrawButton(Index : integer);
    procedure SetTabVisible(const Value: Boolean);
    procedure CreateComponent(Reader: TReader; ComponentClass: TComponentClass; var Component: TComponent);
    procedure AnimateChange(Index : integer; aDir : TAnimateDir);
  protected
    procedure Paint; override;
    procedure Loaded; override;
    procedure GetChildren (Proc : TGetChildProc; Root: TComponent);override;
    procedure ReadState(Reader: TReader); override;
    procedure CustomAlignPosition(Control: TControl; var NewLeft, NewTop, NewWidth,
      NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure CMMouseLeave(var msg : TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var msg : TMessage); message CM_MOUSEENTER;
  public
    Constructor Create(AOwner : TComponent);override;
    Destructor Destroy;override;
  published
    property PageCtrl : TPageControl read FPageCtrl write FPageCtrl;// stored false;
    property ButtonHeight : integer read FButtonHeight write SetButtonHeight;
    property TabVisible : Boolean read FTabVisible write SetTabVisible;
  end;



implementation

uses Types;

const
  STEP_SIZE = 5;

{ TSideBar }

constructor TSideBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FButtonHeight := 25;

  //BorderStyle := bsNone;
  FPageCtrl := TPageControl.Create(Self);
  FPageCtrl.Name := AOwner.name + '_PC';
  FPageCtrl.Parent := Self;
  FPageCtrl.Width := Width;
  FPageCtrl.SetSubComponent(True);
  FPageCtrl.Align := alCustom;
  FPageCtrl.OnChange := GestOnChange;

  DownIndex := -1;
  Leaved := False;
  FPageCtrl.Style := tsFlatButtons;
  try
    FPageCtrl.TabHeight := 1;
  except
  end;
end;



destructor TSideBar.Destroy;
begin
  FreeAndNil(FPageCtrl);
  inherited;
end;


procedure TSideBar.DrawButtons;
var
  TextPos, i : integer;
  aRect, R1 : TRect;
begin
  aRect := Self.ClientRect;
  aRect.Bottom := FButtonHeight;
  for i := 0 to FPageCtrl.PageCount - 1 do begin
    R1 := aRect;
    if (i <> DownIndex) or Leaved then
      Frame3D(Canvas,R1,clBtnHighlight,clBtnShadow,1)
    else
      Frame3D(Canvas,R1,clBtnShadow,clBtnHighlight,1);

    TextPos := (Width - Canvas.TextWidth(FPageCtrl.Pages[i].Caption)) div 2;
    Canvas.TextOut(TextPos, aRect.Top + 5, FPageCtrl.Pages[i].Caption);

    OffsetRect(aRect, 0, FButtonHeight);
    if i = FPageCtrl.ActivePageIndex then
      OffsetRect(aRect, 0, FPageCtrl.Height);

  end;
end;



procedure TSideBar.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
  inherited;
  Proc(FPageCtrl);
end;


procedure TSideBar.Paint;
var
  aRect : TRect;
begin
  inherited;

  //Draw frame
  aRect := FPageCtrl.ClientRect;
  FPageCtrl.Canvas.Pen.Color := clBtnShadow;
  FPageCtrl.Canvas.PenPos := Point(aRect.Left, 0);
  FPageCtrl.Canvas.LineTo(0, 0);
  FPageCtrl.Canvas.LineTo(0, aRect.Bottom-1);
  FPageCtrl.Canvas.Pen.Color := clBtnHighlight;
  FPageCtrl.Canvas.LineTo(aRect.Right-1, aRect.Bottom-1);
  FPageCtrl.Canvas.LineTo(aRect.Right-1, 0);

  if Assigned(FPageCtrl) then
    DrawButtons;
end;



procedure TSideBar.SetButtonHeight(const Value: integer);
begin
  FButtonHeight := Value;
  GestOnChange(Self);
  Invalidate;
end;



procedure TSideBar.CreateComponent(Reader: TReader;
  ComponentClass: TComponentClass; var Component: TComponent);
begin
  //if Assigned(Component) and Assigned(Component.Owner)then
  //  ShowMessage(Reader.Parent.Name);
    
  if ComponentClass = TPageControl then
    Component := FPageCtrl;
end;



procedure TSideBar.ReadState(Reader: TReader);
begin
  Reader.OnCreateComponent := CreateComponent;
  inherited;
end;



procedure TSideBar.GestOnChange(Sender: TObject);
var
  aRect : TRect;
begin

  //Realign
  aRect := ClientRect;
  AlignControls(FPageCtrl, aRect);
end;



procedure TSideBar.Loaded;
begin
  inherited;

  if not (csDesigning in ComponentState) then begin
    TabVisible := False;

    Invalidate;
  end else
    if not TabVisible then
      GestOnChange(Self);
end;



procedure TSideBar.CustomAlignPosition(Control: TControl; var NewLeft, NewTop, NewWidth,
      NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
begin
  inherited;
  if Control = FPageCtrl then begin
    NewWidth := Width;
    NewTop := FButtonHeight * (FPageCtrl.ActivePageIndex+1);
    NewHeight := Self.Height - FButtonHeight * FPageCtrl.PageCount ;
  end;
end;



procedure TSideBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if DownIndex <= FPageCtrl.ActivePageIndex then begin
    If not leaved and (Y <= (DownIndex+1) * FButtonHeight) then begin
      AnimateChange(DownIndex, adDown);
      FPageCtrl.ActivePageIndex := DownIndex;
      GestOnChange(Self);
    end;
  end else
    If not leaved and (Y <= (DownIndex+1) * FButtonHeight + FPageCtrl.Height) then begin
      AnimateChange(DownIndex, adUp);
      FPageCtrl.ActivePageIndex := DownIndex;
      GestOnChange(Self);
    end;

  RedrawButton( DownIndex);
  Leaved := False;
  DownIndex := -1;
end;





procedure TSideBar.RedrawButton(Index : integer);
var
  aRect : TRect;
begin
  aRect := ClientRect;
  aRect.Bottom := FButtonHeight;
  OffsetRect(aRect, 0, DownIndex*FButtonHeight);

  if DownIndex > FPageCtrl.ActivePageIndex then
    OffsetRect(aRect, 0, FPageCtrl.Height);

  InvalidateRect(Handle, @aRect, False);
  //Invalidate;
  FPageCtrl.Refresh;
end;



procedure TSideBar.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, NewDownIndex : integer;
  ClickPos : integer;
begin
  inherited;
  NewDownIndex := -1;
  Leaved := False;

  //find clicked button
  ClickPos := ButtonHeight;
  i := 0;
  while i <= FPageCtrl.PageCount - 1 do begin
    if Y <= ClickPos then begin
      NewDownIndex := i;
      Break;
    end else
      if i = FPageCtrl.ActivePageIndex then
        inc(ClickPos, FPageCtrl.Height);
    inc(ClickPos, FButtonHeight);
    inc(i);
  end;
  if NewDownIndex <> FPageCtrl.ActivePageIndex then begin
    DownIndex := NewDownIndex;
    RedrawButton( DownIndex);
  end;
end;



procedure TSideBar.CMMouseLeave(var msg: TMessage);
begin
  Leaved := True;
  RedrawButton( DownIndex);
end;



procedure TSideBar.CMMouseEnter(var msg: TMessage);
begin
  if Leaved then
    Leaved := False;
  RedrawButton( DownIndex);
end;



procedure TSideBar.SetTabVisible(const Value: Boolean);
var
  i, j : integer;
begin
  FTabVisible := Value;

  if FTabVisible then
    FPageCtrl.TabHeight := 0
  else
    FPageCtrl.TabHeight := 1;

  j := FPageCtrl.ActivePageIndex;
    if j < 0 then
      j := 0;

  for i := 0 to FPageCtrl.PageCount - 1 do
    FPageCtrl.Pages[i].TabVisible := Value;

  FPageCtrl.ActivePageIndex := j;
  GestOnChange(Self);
end;


procedure TSideBar.AnimateChange(Index: integer; aDir: TAnimateDir);
var
  i : integer;
  aSrcRect, aDeltaRect : TRect;
  aDC: HDC;
  brushf: hbrush;
begin
  aSrcRect := FPageCtrl.BoundsRect;
  aDC := GetWindowDC(Handle);
  brushf := CreateSolidBrush(ColorToRGB(clBtnFace));
  try
    case aDir of
      adDown : begin
        aSrcRect.Top := (Index+1) * FButtonHeight + 1;

          repeat
            BitBlt(aDC, //dest
                   aSrcRect.Left, aSrcRect.Top + STEP_SIZE, aSrcRect.Right, aSrcRect.Bottom - aSrcRect.Top - STEP_SIZE,
                   aDC,  //src
                   aSrcRect.Left, aSrcRect.Top,
                   SRCCOPY	);

            CopyRect(aDeltaRect, aSrcRect);
            aDeltaRect.Bottom := aDeltaRect.Top + STEP_SIZE;

            //Clean up behind
            FillRect(aDC, aDeltaRect, brushf );

            aSrcRect.Top := aSrcRect.Top + STEP_SIZE;

          //pause to make the effect visible
          for i := 0 to 50000 do
            Application.ProcessMessages;

          until aSrcRect.Top >= aSrcRect.Bottom;
      end;

      adUp : begin
        aSrcRect.Top := Index * FButtonHeight + 1;
        repeat
          BitBlt(aDC, //dest
                   aSrcRect.Left, aSrcRect.Top, aSrcRect.Right, aSrcRect.Bottom - aSrcRect.Top - STEP_SIZE,
                   aDC,  //src
                   aSrcRect.Left, aSrcRect.Top + STEP_SIZE,
                   SRCCOPY	);

          CopyRect(aDeltaRect, aSrcRect);
          aSrcRect.Bottom := aSrcRect.Bottom - STEP_SIZE;

          //Clean up behind
          aDeltaRect.Top := aDeltaRect.Bottom - STEP_SIZE;
          FillRect(aDC, aDeltaRect, brushf );

          //pause to make the effect visible
          for i := 0 to 50000 do 
            Application.ProcessMessages;

        until aSrcRect.Top >= aSrcRect.Bottom;

      end;
    end;

  finally
    ReleaseDC(Handle, aDC);
    DeleteObject(brushf);
  end;
end;

initialization
  RegisterClasses([TPageControl, TTabSheet]);


end.
