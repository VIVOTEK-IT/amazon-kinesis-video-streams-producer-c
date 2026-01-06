# vcpkg_build_windows.ps1

param(
    [string]$vcvarsPath = "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Auxiliary/Build/vcvars64.bat",
    [string]$installPath = "C:/Source/kvs_supergiftpack/",
    [string]$vcpkgTriplet = "x64-windows",
    [string]$toolchainFile = "C:/vcpkg/scripts/buildsystems/vcpkg.cmake"
)

$installPrefixDebug = Join-Path $installPath "Debug/producer"
$installPrefixRelease = Join-Path $installPath "Release/producer"
$buildDir = "build"

$env:VCPKG_DEFAULT_TRIPLET = $vcpkgTriplet

& $vcvarsPath x86_amd64

if (-not (Test-Path $buildDir)) {
    New-Item -ItemType Directory -Path $buildDir | Out-Null
}
Push-Location $buildDir

cmake -G "Visual Studio 17 2022" `
    -DBUILD_TEST=FALSE `
    -DCMAKE_TOOLCHAIN_FILE="$toolchainFile" `
    -DCMAKE_INSTALL_PREFIX="$installPrefixDebug" `
    -DBUILD_COMMON_LWS=TRUE `
    -DBUILD_COMMON_CURL=TRUE `
    ..

cmake --build . --config Debug --target install

cmake -G "Visual Studio 17 2022" `
    -DBUILD_TEST=FALSE `
    -DCMAKE_TOOLCHAIN_FILE="$toolchainFile" `
    -DCMAKE_INSTALL_PREFIX="$installPrefixRelease" `
    -DBUILD_COMMON_LWS=TRUE `
    -DBUILD_COMMON_CURL=TRUE `
    ..

cmake --build . --config Release --target install

Pop-Location