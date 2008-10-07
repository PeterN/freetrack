unit UrlLink;

interface

uses
  Windows, Messages, Classes, Controls, StdCtrls, Graphics, ShellApi;

type
  TUrlLink = Class(TLabel)
    procedure CMMouseEnter(var Msg: TMessage); message CM_MouseEnter;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MouseLeave;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
  end;

procedure Register;

  
implementation


{ TUrlLink }

procedure TUrlLink.CMMouseEnter(var Msg: TMessage);
begin
  if not (csDesigning in ComponentState) then begin
    Font.Style := Font.Style + [fsUnderline];
    Cursor := crHandPoint;
  end;
end;

procedure TUrlLink.CMMouseLeave(var Msg: TMessage);
begin
  if not (csDesigning in ComponentState) then begin
    Font.Style := Font.Style - [fsUnderline];
    Cursor := crDefault;
  end;
end;

procedure Register;
begin
  RegisterComponents('Freetrack', [TUrlLink]);
end;

procedure TUrlLink.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  ShellExecute(0, 'open', PChar(caption),nil,nil, SW_SHOWNORMAL);
end;

end.
