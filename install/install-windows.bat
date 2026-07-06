@echo off
:: Forge installer for Windows
:: Installs forge.exe to %USERPROFILE%\AppData\Local\Programs\Forge
:: and creates the ROM directory structure.
::
:: Two layouts supported:
::   (1) Real download bundle (forge-windows-x86_64-{thin,fat}.zip, extracted): this
::       script sits NEXT TO forge.exe, plus catalog.json + cores\ for fat.
::   (2) In-repo dev layout: forge\install\install-windows.bat alongside forge\dist\*.
setlocal

set INSTALL_DIR=%USERPROFILE%\AppData\Local\Programs\Forge
set ROM_DIR=%USERPROFILE%\Documents\Forge\roms
set CORES_INSTALL_DIR=%USERPROFILE%\Documents\Forge\cores
set SCRIPT_DIR=%~dp0
set BINARY=
set CORES_DIR=

if exist "%SCRIPT_DIR%forge.exe" (
    set BINARY=%SCRIPT_DIR%forge.exe
    if exist "%SCRIPT_DIR%cores" set CORES_DIR=%SCRIPT_DIR%cores
)

if not defined BINARY (
    if exist "%SCRIPT_DIR%..\dist\forge-windows-x86_64-thin.exe" (
        set BINARY=%SCRIPT_DIR%..\dist\forge-windows-x86_64-thin.exe
    ) else if exist "%SCRIPT_DIR%..\dist\forge-windows-x86_64-fat.exe" (
        set BINARY=%SCRIPT_DIR%..\dist\forge-windows-x86_64-fat.exe
    )
    if exist "%SCRIPT_DIR%..\catalog\cores" set CORES_DIR=%SCRIPT_DIR%..\catalog\cores
)

echo Forge Installer - Windows
echo -------------------------

if not defined BINARY (
    echo Error: no forge.exe found next to this script or in ..\dist\
    exit /b 1
)

echo Installing to %INSTALL_DIR%\forge.exe ...
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
copy /y "%BINARY%" "%INSTALL_DIR%\forge.exe" >nul

:: Add to user PATH if not already present
echo %PATH% | find /i "%INSTALL_DIR%" >nul
if errorlevel 1 (
    setx PATH "%PATH%;%INSTALL_DIR%" >nul
    echo Added %INSTALL_DIR% to PATH.
    echo Restart your terminal for PATH changes to take effect.
)

echo Creating ROM directories at %ROM_DIR% ...
for %%s in (nes snes genesis psx gb gba sms gamegear n64 pce arcade) do (
    if not exist "%ROM_DIR%\%%s" mkdir "%ROM_DIR%\%%s"
)

if defined CORES_DIR (
    echo Fat bundle detected -- installing bundled cores to %CORES_INSTALL_DIR% ...
    if not exist "%CORES_INSTALL_DIR%" mkdir "%CORES_INSTALL_DIR%"
    copy /y "%CORES_DIR%\*.sigpkg" "%CORES_INSTALL_DIR%\" >nul
)

echo.
echo Done. Run: forge
echo Place ROMs in: %ROM_DIR%\^<system^>\
echo.
"%INSTALL_DIR%\forge.exe"
pause
