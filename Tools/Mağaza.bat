@echo off
chcp 65001 >nul
title Wrait OS - Uygulama Magazasi
mode con: cols=85 lines=30
color 0b

:: Yonetici haklarini kontrol et
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo  [!] HATA: Uygulama yuklemek icin "Yonetici Olarak Calistir" gerekir!
    pause
    exit
)

:store_menu
cls
echo.
echo  ===========================================================================
echo                      WRAIT OS - UYGULAMA MAGAZASI
echo  ===========================================================================
echo.
echo    [1] Tarayicilar (Chrome, Brave, Opera)
echo    [2] Iletisim (Discord, WhatsApp, Telegram)
echo    [3] Oyuncu Araclari (Steam, Epic Games, Spotify)
echo    [4] Yazilim ve Araclar (VS Code, Notepad++, WinRAR, 7-Zip)
echo.
echo    [S] ISIMLE ARA VE YUKLE (Istediğin uygulamanın adını yaz)
echo    [G] TUM UYGULAMALARI GUNCELLE (Sistemdeki her şeyi tazeler)
echo.
echo    [X] ANA MENUYE DON
echo  ===========================================================================
echo.

set /p sec="Islem secin: "

if /i "%sec%"=="1" goto :browsers
if /i "%sec%"=="2" goto :social
if /i "%sec%"=="3" goto :games
if /i "%sec%"=="4" goto :tools
if /i "%sec%"=="S" goto :search_install
if /i "%sec%"=="G" goto :update_all
if /i "%sec%"=="X" exit
goto :store_menu

:search_install
cls
echo.
echo  [i] Yuklemek istediginiz uygulamanin adini yazin (Orn: vlc, zoom, spotify)
echo  [i] Iptal etmek icin bos birakip Enter'a basin.
echo.
set /p appname="Uygulama Adi: "
if "%appname%"=="" goto :store_menu

echo.
echo [!] "%appname%" araniyor ve yukleniyor...
winget install --name "%appname%" --interactive --accept-source-agreements --accept-package-agreements
echo.
echo [!] Islem bitti.
pause
goto :store_menu

:browsers
cls
echo [1] Google Chrome  [2] Brave  [3] Opera GX  [4] Geri
set /p b_sec="Secim: "
if "%b_sec%"=="1" winget install --id Google.Chrome
if "%b_sec%"=="2" winget install --id Brave.Brave
if "%b_sec%"=="3" winget install --id Opera.OperaGX
goto :store_menu

:social
cls
echo [1] Discord  [2] WhatsApp  [3] Telegram  [4] Geri
set /p s_sec="Secim: "
if "%s_sec%"=="1" winget install --id Discord.Discord
if "%s_sec%"=="2" winget install --id WhatsApp.WhatsApp
if "%s_sec%"=="3" winget install --id Telegram.TelegramDesktop
goto :store_menu

:games
cls
echo [1] Steam  [2] Epic Games  [3] Spotify  [4] Geri
set /p g_sec="Secim: "
if "%g_sec%"=="1" winget install --id Valve.Steam
if "%g_sec%"=="2" winget install --id EpicGames.EpicGamesLauncher
if "%g_sec%"=="3" winget install --id Spotify.Spotify
goto :store_menu

:tools
cls
echo [1] VS Code  [2] WinRAR  [3] 7-Zip  [4] Geri
set /p t_sec="Secim: "
if "%t_sec%"=="1" winget install --id Microsoft.VisualStudioCode
if "%t_sec%"=="2" winget install --id RARLab.WinRAR
if "%t_sec%"=="3" winget install --id 7zip.7zip
goto :store_menu

:update_all
cls
echo.
echo [!] Sistemdeki tum uygulamalar kontrol ediliyor...
winget upgrade --all
echo.
echo [!] Guncelleme islemi tamamlandi.
pause
goto :store_menu