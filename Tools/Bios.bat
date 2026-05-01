@echo off
title UEFI/BIOS Yonlendirici
cls
color 0b

echo ===========================================
echo   BILGISAYAR UEFI AYARLARINA GIRILECEK
echo ===========================================
echo.
echo Dikkat: Bilgisayar hemen yeniden baslatilacak. 
echo Lutfen acik olan tum calismalarinizi kaydedin.
echo.

:onay_ekrani
set /p secim="Devam etmek istiyor musunuz? (E/H): "

if /i "%secim%"=="E" goto :devam
if /i "%secim%"=="H" goto :iptal
goto :gecersiz

:devam
echo.
echo Sistem hazirlaniyor... BIOS'a yonlendiriliyorsunuz.
shutdown /r /fw /t 3
exit

:iptal
echo.
echo Islem kullanici tarafindan iptal edildi.
pause
exit

:gecersiz
echo.
echo Gecersiz secim! Lutfen sadece E veya H harfini kullanin.
goto :onay_ekrani