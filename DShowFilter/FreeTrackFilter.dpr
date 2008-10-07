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

library FreeTrackFilter;
{$i 'FreetrackFilter.inc'}
{$ifdef SSE2}
  {$LIBSUFFIX 'SSE2'}

{$else}
  {$LIBSUFFIX 'MMX'}
{$endif}



{%File 'FreetrackFilter.inc'}

uses
  Windows,
  SysUtils,
  BaseClass,
  Seuillage in 'Seuillage.pas',
  Seuillage_inc in 'Seuillage_inc.pas',
  SeuilProp_fm in 'SeuilProp_fm.pas' {fmSettings},
  cpuid in 'cpuid.pas',
  SeuillageProcessor in 'SeuillageProcessor.pas',
  SeuillageProcessor_RGB24 in 'SeuillageProcessor_RGB24.pas',
  SeuillageProcessor_RGB32 in 'SeuillageProcessor_RGB32.pas',
  SeuillageProcessor_CbCr in 'SeuillageProcessor_CbCr.pas',
  SeuillageProcessor_YUV in 'SeuillageProcessor_YUV.pas',
  SeuillageProcessor_YUYV in 'SeuillageProcessor_YUYV.pas',
  SeuillageProcessor_UYVY in 'SeuillageProcessor_UYVY.pas';

{$E ax}

{$R *.res}

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;
begin
end.
 
