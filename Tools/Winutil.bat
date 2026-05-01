@echo off
chcp 65001 >nul
title Wrait OS - Chris Titus Tech Utility Loader
mode con: cols=85 lines=25
color 0b

:: Yönetici haklarını kontrol et
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    echo   HATA: BU ARACI ÇALIŞTIRMAK İÇİN YÖNETİCİ YETKİSİ ŞART!
    echo         LÜTFEN SAĞ TIKLAYIP "YÖNETİCİ OLARAK ÇALIŞTIR"IN.
    echo  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    pause
    exit
)

:menu
cls
echo.
echo  ===========================================================================
echo                    WRAIT OS - GELİŞMİŞ SİSTEM ARAÇLARI
echo  ===========================================================================
echo.
echo    [1] CHRIS TITUS TECH TOOLBOX (Hızlı Çalıştır)
echo        - Windows Debloat (Gereksizleri silme)
echo        - Performans Ayarları
echo        - Temel Yazılım Yükleyici
echo.
echo    [2] POWERSHELL'İ YÖNETİCİ OLARAK AÇ
echo    [3] ANA MENÜYE DÖN
echo.
echo  ===========================================================================
echo.

set /p sec="Seçiminizi yapın (1-3): "

if "%sec%"=="1" goto :ctt_run
if "%sec%"=="2" goto :ps_open
if "%sec%"=="3" exit
goto :menu

:ctt_run
cls
echo.
echo  [!] Chris Titus Tech Utility Başlatılıyor...
echo  [!] Lütfen bekleyin, PowerShell üzerinden arayüz açılacak.
echo.
echo  [KOMUT]: iwr -useb https://christitus.com/win ^| iex
echo.
:: İşte o sihirli komutun otomatik hali:
powershell -Command "iwr -useb https://christitus.com/win | iex"
echo.
echo  [!] İşlem tamamlandı veya araç kapatıldı.
pause
goto :menu

:ps_open
cls
echo PowerShell yönetici modunda açılıyor...
powershell -Command "Start-Process powershell -Verb RunAs"
goto :menu