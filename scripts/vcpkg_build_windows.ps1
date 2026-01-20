# vcpkg_build_windows.ps1

param(
    [string]$vcvarsPath = "C:/Program Files/Microsoft Visual Studio/2022/BuildTools/VC/Auxiliary/Build/vcvars64.bat",
    [string]$installPath = "C:/Source/kvs_supergiftpack/",
    [string]$vcpkgTriplet = "x64-windows",
    [string]$toolchainFile = "C:/vcpkg/scripts/buildsystems/vcpkg.cmake"
)

Import-Module "$PSScriptRoot\utilty.ps1" -Force
Import-Module "$PSScriptRoot\vcpkg_utilty.ps1" -Force

$installPrefixDebug = Join-Path $installPath "Debug/producer"
$installPrefixRelease = Join-Path $installPath "Release/producer"
$buildDir = "build"

$env:VCPKG_DEFAULT_TRIPLET = $vcpkgTriplet

Initialize-VcVarsEnvironment -VcVarsPath $vcvarsPath

if (-not (Test-Path $buildDir)) {
    New-Item -ItemType Directory -Path $buildDir | Out-Null
}
Push-Location $buildDir

Write-Host "Generating Debug configuration..." -ForegroundColor Cyan
cmake -G "Visual Studio 17 2022" `
    -DBUILD_TEST=FALSE `
    -DCMAKE_TOOLCHAIN_FILE="$toolchainFile" `
    -DCMAKE_INSTALL_PREFIX="$installPrefixDebug" `
    -DBUILD_COMMON_LWS=TRUE `
    -DBUILD_COMMON_CURL=TRUE `
    -DVCPKG_INSTALL_OPTIONS="--clean-after-build" `
    ..

Write-Host "Building Debug configuration..." -ForegroundColor Cyan
cmake --build . --config Debug --target install

Write-Host "Generating Release configuration..." -ForegroundColor Green
cmake -G "Visual Studio 17 2022" `
    -DBUILD_TEST=FALSE `
    -DCMAKE_TOOLCHAIN_FILE="$toolchainFile" `
    -DCMAKE_INSTALL_PREFIX="$installPrefixRelease" `
    -DBUILD_COMMON_LWS=TRUE `
    -DBUILD_COMMON_CURL=TRUE `
    -DVCPKG_INSTALL_OPTIONS="--clean-after-build" `
    ..

Write-Host "Building Release configuration..." -ForegroundColor Green
cmake --build . --config Release --target install

Write-Host "Build and installation completed." -ForegroundColor Yellow

Pop-Location