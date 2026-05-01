@echo off
title Kurtarma Menusu Yonlendirici
cls
color 0b

echo ===========================================
echo    GELISMIS SECENEKLER (KURTARMA) MODU
echo ===========================================
echo.
echo Bu islem bilgisayari Kurtarma Menusu ile acar.
echo Buradan Guvenli Mod, Sistem Geri Yukleme gibi 
echo ayarlara ulasabilirsiniz.
echo.

:onay_ekrani
set /p secim="Kurtarma moduna gecilsin mi? (E/H): "

if /i "%secim%"=="E" goto :devam
if /i "%secim%"=="H" goto :iptal
goto :gecersiz

:devam
echo.
echo Bilgisayar Kurtarma Modu'nda acilmak uzere kapatiliyor...
shutdown /r /o /t 5
exit

:iptal
echo.
echo Islem iptal edildi.
pause
exit

:gecersiz
echo.
echo Gecersiz secim! Lutfen E veya H harfini kullanin.
goto :onay_ekrani