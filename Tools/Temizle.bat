@echo off
title Wrait OS - Sistem Temizlik Menusu
mode con: cols=60 lines=25
color 0b

:: Yonetici haklarini kontrol et
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Lutfen bu dosyayi SAG TIKLAYIP "Yonetici Olarak Calistir" deyin!
    pause
    exit
)

:menu
cls
echo.
echo  ============================================================
echo               SISTEM TEMIZLIK VE BAKIM MENUSU
echo  ============================================================
echo.
echo    [1] Hizli Temizlik (Gecici Dosyalar)
echo        - Temp, Prefetch ve Log dosyalarini siler.
echo.
echo    [2] Derin Temizlik (Sistem Atiklari)
echo        - Eski Windows guncelleme artiklarini ve kalintilari siler.
echo.
echo    [3] Tam Temizlik (Hizli + Derin + Disk Temizleme)
echo        - Tum gereksiz dosyalari ve geri donusum kutusunu bosaltir.
echo.
echo    [4] Geri Don / Cikis
echo.
echo  ============================================================
echo.

set /p secim="Yapmak istediginiz temizligi secin (1-4): "

if "%secim%"=="1" goto :hizli
if "%secim%"=="2" goto :derin
if "%secim%"=="3" goto :tam
if "%secim%"=="4" exit
goto :gecersiz

:hizli
echo.
echo Hizli temizlik baslatiliyor...
del /q /f /s %temp%\*
del /q /f /s C:\Windows\Temp\*
del /q /f /s C:\Windows\Prefetch\*
echo.
echo Hizli temizlik tamamlandi!
pause
goto :menu

:derin
echo.
echo Derin temizlik baslatiliyor (DISM bileşen temizligi)...
dism /online /cleanup-image /startcomponentcleanup
echo.
echo Derin temizlik tamamlandi!
pause
goto :menu

:tam
echo.
echo Tam temizlik baslatiliyor...
echo 1. Asama: Gecici dosyalar siliniyor...
del /q /f /s %temp%\*
del /q /f /s C:\Windows\Temp\*
echo 2. Asama: Windows guncelleme artiklari temizleniyor...
dism /online /cleanup-image /startcomponentcleanup /resetbase
echo 3. Asama: Disk temizleme araci calistiriliyor...
cleanmgr /sagerun:1
echo.
echo Tum temizlik islemleri basariyla bitti!
pause
goto :menu

:gecersiz
echo.
echo Hatali secim! Tekrar deneyin.
timeout /t 2 >nul
goto :menu
