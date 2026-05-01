@echo off
title WRAIT OS - DRIVER ENGINE
color 0b

:: Admin Check
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] ADMIN PRIVILEGES REQUIRED
    pause
    exit
)

:: Folder Setup
set "WDRV=C:\WraitOS_Drivers"
if not exist "%WDRV%" mkdir "%WDRV%"

:menu
cls
echo ==========================================
echo       WRAIT OS // DRIVER ENGINE
echo ==========================================
echo.
echo  [1] BACKUP DRIVERS
echo  [2] RESTORE DRIVERS
echo  [3] OPEN FOLDER
echo  [4] DELETE BACKUPS
echo  [X] EXIT
echo.
echo ==========================================
set /p choice="INPUT > "

if "%choice%"=="1" goto backup
if "%choice%"=="2" goto restore
if "%choice%"=="3" goto openf
if "%choice%"=="4" goto delete
if /i "%choice%"=="X" exit
goto menu

:backup
cls
echo [+] Exporting drivers to %WDRV%...
dism /online /export-driver /destination:"%WDRV%"
echo [+] Done.
pause
goto menu

:restore
cls
echo [!] Importing drivers from %WDRV%...
pnputil /add-driver "%WDRV%\*.inf" /subdirs /install
echo [+] Done.
pause
goto menu

:openf
start explorer.exe "%WDRV%"
goto menu

:delete
cls
echo [!] Are you sure? (Y/N)
set /p confirm="> "
if /i "%confirm%"=="Y" (
    rd /s /q "%WDRV%"
    mkdir "%WDRV%"
    echo [+] Drivers Deleted.
)
pause
goto menu