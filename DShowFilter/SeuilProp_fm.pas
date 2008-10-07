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

unit SeuilProp_fm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  BaseClass, Dialogs, ComCtrls, Seuillage_inc, StdCtrls, Spin;


const
  CLSID_SeuilPageSettings : TGUID = '{F12C6F73-C49C-4599-925C-1A528EEE500C}';

type
  TfmSettings = class(TFormPropertyPage)
    TrackBar: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    cbActive: TCheckBox;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    spMinSize: TSpinEdit;
    spMaxSize: TSpinEdit;
    Label4: TLabel;
    procedure TrackBarChange(Sender: TObject);
    procedure cbActiveClick(Sender: TObject);
    procedure spMinSizeChange(Sender: TObject);
    procedure spMaxSizeChange(Sender: TObject);
  private
    Seuil : ISeuil;
  public
    function OnConnect(Unknown: IUnknown): HRESULT; override;
    function OnDisconnect: HRESULT; override;
    function OnApplyChanges: HRESULT; override;
  end;

var
  fmSettings: TfmSettings;

implementation

{$R *.dfm}

{ TfmSettings }

function TfmSettings.OnApplyChanges: HRESULT;
begin
  result := NOERROR;
end;

function TfmSettings.OnConnect(Unknown: IInterface): HRESULT;
var
  i : byte;
  b : boolean;
begin
  Unknown.QueryInterface(IID_ISeuil, Seuil);
  Seuil.GetSeuil(@i);
  TrackBar.Position := i;

  Seuil.GetActive(@b);
  cbActive.Checked := b;

  Seuil.GetMinPointSize(@i);
  spMinSize.Value := i;

  Seuil.GetMaxPointSize(@i);
  spMaxSize.Value := i;

  result := NOERROR;
  {$ifdef DEBUG}
  DbgLog('TfmSettings.OnConnect');
  {$endif}
end;



function TfmSettings.OnDisconnect: HRESULT;
begin
  result := NOERROR;
  {$ifdef DEBUG}
  DbgLog('TfmSettings.OnDisconnect');
  {$endif}
end;



procedure TfmSettings.TrackBarChange(Sender: TObject);
begin
  Seuil.SetSeuil(TrackBar.Position);
end;



procedure TfmSettings.cbActiveClick(Sender: TObject);
begin
  Seuil.SetActive(cbActive.Checked);
end;



procedure TfmSettings.spMinSizeChange(Sender: TObject);
begin
  Seuil.SetMinPointSize(spMinSize.Value);
  spMaxSize.MinValue := spMinSize.Value;
end;



procedure TfmSettings.spMaxSizeChange(Sender: TObject);
begin
  Seuil.SetMaxPointSize(spMaxSize.Value);
  spMinSize.MaxValue := spMaxSize.Value;
end;

initialization
  TBCClassFactory.CreatePropertyPage(TfmSettings, CLSID_SeuilPageSettings);

end.
