@echo off
setlocal

set TEMPL=media
set FWFILES=fwfiles
set EXITCODE=0

rem
rem Input validation
rem
if /i "%1"=="/?" goto usage
if /i "%1"=="" goto usage
if /i "%~2"=="" goto usage
if /i not "%3"=="" goto usage

rem
rem Set environment variables for use in the script
rem
set WINPE_ARCH=%1
set WinPERoot=C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment
set SOURCE=%WinPERoot%\%WINPE_ARCH%
Set OSCDImgRoot=C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg
set FWFILESROOT=%OSCDImgRoot%\..\..\%WINPE_ARCH%\Oscdimg
set DEST=%~2
set WIMSOURCEPATH=%SOURCE%\en-us\winpe.wim

rem
rem Validate input architecture
rem
rem If the source directory as per input architecture does not exist,
rem it means the architecture is not present
rem
if not exist "%SOURCE%" (
  echo ERROR: The following processor architecture was not found: %WINPE_ARCH%.
  goto fail
)

rem
rem Validate the boot app directory location
rem
rem If the input architecture is validated, this directory must exist
rem This check is only to be extra careful
rem
if not exist "%FWFILESROOT%" (
  echo ERROR: The following path for firmware files was not found: "%FWFILESROOT%".
  goto fail
)

rem
rem Make sure the appropriate winpe.wim is present
rem
if not exist "%WIMSOURCEPATH%" (
  echo ERROR: WinPE WIM file does not exist: "%WIMSOURCEPATH%".
  goto fail
)

rem
rem Make sure the destination directory does not exist
rem
if exist "%DEST%" (
  echo ERROR: Destination directory exists: %2.
  goto fail
)

mkdir "%DEST%"
if errorlevel 1 (
  echo ERROR: Unable to create destination: %2.
  goto fail
)

echo.
echo ===================================================
echo Creating Windows PE customization working directory
echo.
echo     %DEST%
echo ===================================================
echo.

mkdir "%DEST%\%TEMPL%"
if errorlevel 1 (
  echo ERROR: Unable to create directory: "%DEST%\%TEMPL%".
  goto fail
)

mkdir "%DEST%\mount"
if errorlevel 1 (
  echo ERROR: Unable to create directory: "%DEST%\mount".
  goto fail
)

mkdir "%DEST%\%FWFILES%"
if errorlevel 1 (
  echo ERROR: Unable to create directory: "%DEST%\%FWFILES%".
  goto fail
)

rem
rem Copy the boot files and WinPE WIM to the destination location
rem
xcopy /herky "%SOURCE%\Media" "%DEST%\%TEMPL%\"
if errorlevel 1 (
  echo ERROR: Unable to copy boot files: "%SOURCE%\Media" to "%DEST%\%TEMPL%".
  goto fail
)

mkdir "%DEST%\%TEMPL%\sources"
if errorlevel 1 (
  echo ERROR: Unable to create directory: "%DEST%\%TEMPL%\sources".
  goto fail
)

copy "%WIMSOURCEPATH%" "%DEST%\%TEMPL%\sources\boot.wim"
if errorlevel 1 (
  echo ERROR: Unable to copy WinPE WIM: "%WIMSOURCEPATH%" to "%DEST%\%TEMPL%\sources\boot.wim".
  goto fail
)

rem
rem Copy the boot sector files to enable ISO creation and boot
rem
rem  UEFI boot uses efisys.bin
rem  BIOS boot uses etfsboot.com
rem

copy "%FWFILESROOT%\efisys.bin" "%DEST%\%FWFILES%"
if errorlevel 1 (
  echo ERROR: Unable to copy boot sector file: "%FWFILESROOT%\efisys.bin" to "%DEST%\%FWFILES%".
  goto fail
)

if not exist "%FWFILESROOT%\etfsboot.com" goto success

copy "%FWFILESROOT%\etfsboot.com" "%DEST%\%FWFILES%"
if errorlevel 1 (
  echo ERROR: Unable to copy boot sector file: "%FWFILESROOT%\etfsboot.com" to "%DEST%\%FWFILES%".
  goto fail
)

:success
set EXITCODE=0
echo.
echo Success
echo.
cd /d "%~2"
goto cleanup

:usage
set EXITCODE=1
echo Creates working directories for WinPE image customization and media creation.
echo.
echo copype { amd64 ^| x86 ^| arm ^| arm64 } ^<workingDirectory^>
echo.
echo  amd64             Copies amd64 boot files and WIM to ^<workingDirectory^>\media.
echo  x86               Copies x86 boot files and WIM to ^<workingDirectory^>\media.
echo  arm               Copies arm boot files and WIM to ^<workingDirectory^>\media.
echo  arm64             Copies arm64 boot files and WIM to ^<workingDirectory^>\media.
echo                    Note: ARM/ARM64 content may not be present in this ADK.
echo  workingDirectory  Creates the working directory at the specified location.
echo.
echo Example: copype amd64 C:\WinPE_amd64
goto cleanup

:fail
set EXITCODE=1
echo Failed!
goto cleanup

:cleanup
endlocal & exit /b %EXITCODE%
