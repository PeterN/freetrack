unit SideBarReg;

interface
uses
  Classes, SideBar, DesignIntf, DesignEditors, TypInfo, ComCtrls, SysUtils,
  Dialogs, MkRangeSlider;

type
  TSideBarEditor = class(TComponentEditor)
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

procedure Register;

implementation


procedure Register;
begin
  RegisterComponents('FreeTrack', [TSideBar]);
  RegisterComponentEditor(TSideBar,  TSideBarEditor);
  RegisterComponents('FreeTrack', [TmkRangeSlider]);
end;

{ TSideBarEditor }

procedure TSideBarEditor.ExecuteVerb(Index: Integer);
var
  ts : TTabSheet;
begin
  case index of
    0 : begin
      ts := TTabSheet.Create(Component);
      ts.PageControl := (Component as TSideBar).PageCtrl;
      ts.Name := Component.Name + '_Tabsheet' + intToStr(ts.PageControl.PageCount);
      ts.Caption := 'Tabsheet' + intToStr(ts.PageControl.PageCount);
    end;

    1 :
      (Component as TSideBar).PageCtrl.SelectNextPage(True, False);

    2 :
      (Component as TSideBar).PageCtrl.SelectNextPage(False, False);

    3 :
      if Assigned( (Component as TSideBar).PageCtrl.ActivePage) then
       (Component as TSideBar).PageCtrl.ActivePage.Free;
  end;
end;

function TSideBarEditor.GetVerb(Index: Integer): string;
begin
  case index of
    0 : Result := 'Ne&w page';
    1 : Result := 'Ne&xt page';
    2 : Result := '&Previous page';
    3 : Result := '&Delete page';
  end;
end;

function TSideBarEditor.GetVerbCount: Integer;
begin
  Result := 4;
end;



end.
