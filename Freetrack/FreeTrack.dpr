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

program FreeTrack;

{$R 'SimConnect.res' 'SimConnect.rc'}
{$R *.res}
{$R *.dkl_const.res}
{$R trackirexe.res}


uses
  Forms,
  Freetrack_fm in 'Freetrack_fm.pas' {fmFreetrack},
  Average in 'Average.pas',
  HeadDisplay in 'HeadDisplay.pas',
  FreeTrackTray in 'FreeTrackTray.pas',
  Parameters in 'Parameters.pas',
  ProfilesMngr_fm in 'ProfilesMngr_fm.pas' {ProfilesMngr},
  Pose in 'Pose.pas',
  ForceCamProp_fm in 'ForceCamProp_fm.pas' {ForceCamProp},
  SimConnect_dm in 'SimConnect_dm.pas' {dmSimConnect: TDataModule},
  SimConnect in 'SimConnect.pas',
  DInputMap in 'DInputMap.pas' {DInput: TDataModule},
  Response in '..\Bpl\Response.pas',
  UrlLink in '..\Bpl\UrlLink.pas',
  Wiimote_dm in 'Wiimote_dm.pas' {dmwiimote: TDataModule},
  Optitrack_dm in 'Optitrack_dm.pas' {dmOptitrack: TDataModule},
  PoseDataOutput_fm in 'PoseDataOutput_fm.pas' {PoseDataOutput : TPoseDataOutput},
  CamManager_fm in 'CamManager_fm.pas' {CamManager},
  VideoDevice_dm in 'VideoDevice_dm.pas' {dmVideoDevice: TDataModule};

begin
  Application.Initialize;
  Application.Title := 'FreeTrack';
  Application.CreateForm(TdmSimConnect, dmSimConnect);
  Application.CreateForm(TDInput, DInput);
  Application.CreateForm(TfmFreetrack, fmFreetrack);
  Application.Run;
end.
