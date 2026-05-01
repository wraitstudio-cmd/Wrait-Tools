@echo off
title Wrait OS - Sistem Onarim Menusu
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
echo               SISTEM ONARIM VE BAKIM MENUSU
echo  ============================================================
echo.
echo    [1] Hizli Onarim (SFC Scannow)
echo        - Sistem dosyalarini tarar ve bozuk olanlari onarir.
echo.
echo    [2] Derin Onarim (DISM Onarimi)
echo        - Windows imajini internetten kontrol eder ve tazeler.
echo.
echo    [3] Tam Onarim (Disk Kontrolu - CHKDSK)
echo        - Disk hatalarini bulur ve bir sonraki acilista onarir.
echo.
echo    [4] Geri Don / Cikis
echo.
echo  ============================================================
echo.

set /p secim="Yapmak istediginiz onarimi secin (1-4): "

if "%secim%"=="1" goto :hizli
if "%secim%"=="2" goto :derin
if "%secim%"=="3" goto :tam
if "%secim%"=="4" exit
goto :gecersiz

:hizli
echo.
echo Hizli onarim baslatiliyor (SFC)...
sfc /scannow
echo.
echo Islem tamamlandi.
pause
goto :menu

:derin
echo.
echo Derin onarim baslatiliyor (DISM)...
echo Bu islem internet hizina bagli olarak zaman alabilir.
dism /online /cleanup-image /restorehealth
echo.
echo Islem tamamlandi.
pause
goto :menu

:tam
echo.
echo Tam onarim (Disk Kontrolu) planlaniyor...
echo Disk su an kullanimda oldugu icin bir sonraki acilista taranacak.
echo Onay veriyor musunuz? (E/H)
chkdsk C: /f /r
echo.
echo Bilgisayari yeniden baslattiginizda tarama baslayacaktir.
pause
goto :menu

:gecersiz
echo.
echo Hatali secim! Tekrar deneyin.
timeout /t 2 >nul
goto :menu
