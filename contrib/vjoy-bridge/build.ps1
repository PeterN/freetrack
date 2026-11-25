<#
  Builds FreeTrack for vJoy and makes a zip in .\dist
  Usage:
    .\build.ps1                 # small zip, needs .NET 8 Desktop Runtime on the PC
    .\build.ps1 -SelfContained  # bigger zip, runs without installing .NET
    .\build.ps1 -SkipTests
#>
param(
    [switch]$SelfContained,
    [switch]$SkipTests
)

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) {
    Write-Error "The .NET 8 SDK is not installed. Get it from https://dotnet.microsoft.com/download/dotnet/8.0"
}

if (-not $SkipTests) {
    Write-Host "Running tests..." -ForegroundColor Cyan
    dotnet test tests/FreeTrackVJoy.Tests -c Release
    if ($LASTEXITCODE -ne 0) { Write-Error "Tests failed - not packaging." }
}

[xml]$proj = Get-Content src/FreeTrackVJoy/FreeTrackVJoy.csproj
$version = $proj.Project.PropertyGroup.Version | Where-Object { $_ } | Select-Object -First 1
$flavor  = if ($SelfContained) { 'selfcontained' } else { 'small' }
$out     = Join-Path 'build' $flavor
$zipName = "FreeTrackForVJoy-$version-$flavor.zip"

if (Test-Path $out) { Remove-Item $out -Recurse -Force }

Write-Host "Publishing ($flavor)..." -ForegroundColor Cyan
$sc = if ($SelfContained) { 'true' } else { 'false' }
dotnet publish src/FreeTrackVJoy -c Release -r win-x64 --self-contained $sc `
    -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -o $out
if ($LASTEXITCODE -ne 0) { Write-Error "Build failed." }

# Only our own files go in the zip. No vJoy or FreeTrack files (see THIRD-PARTY-NOTICES.md).
Copy-Item README.md, LICENSE, THIRD-PARTY-NOTICES.md -Destination $out
Get-ChildItem $out -Filter *.pdb | Remove-Item

$forbidden = 'vJoyInterface.dll','vJoyInterfaceWrap.dll','TIRViews.dll','NPClient*.dll','OptiTrack*.dll','SimConnect.dll','borlndmm.dll'
foreach ($f in $forbidden) {
    if (Get-ChildItem $out -Filter $f -Recurse) { Write-Error "Third-party file $f ended up in the package - remove it." }
}

New-Item -ItemType Directory -Force dist | Out-Null
$zip = Join-Path 'dist' $zipName
if (Test-Path $zip) { Remove-Item $zip }
Compress-Archive -Path (Join-Path $out '*') -DestinationPath $zip
Write-Host "Done: $zip" -ForegroundColor Green
