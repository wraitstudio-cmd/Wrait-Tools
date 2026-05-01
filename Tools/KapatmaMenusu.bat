@echo off
title Sistem Yonetimi
mode con: cols=45 lines=15
color 0b

:menu
cls
echo.
echo  =========================================
echo             GUC SECENEKLERI
echo  =========================================
echo.
echo    [1] Bilgisayari Kapat
echo    [2] Yeniden Baslat
echo    [3] Vazgec / Cikis
echo.
echo  =========================================
echo.

set /p secim="Isleminiz (1-3): "

if "%secim%"=="1" goto :kapat
if "%secim%"=="2" goto :yeniden
if "%secim%"=="3" exit
goto :gecersiz

:kapat
echo.
echo Bilgisayar kapaniyor...
shutdown /s /t 5
exit

:yeniden
echo.
echo Bilgisayar yeniden baslatiliyor...
shutdown /r /t 5
exit

:gecersiz
echo.
echo Hatali secim! Tekrar deneyin.
timeout /t 2 >nul
goto :menu