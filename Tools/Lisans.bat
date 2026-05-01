@echo off
:: UTF-8 karakter desteği (Türkçe karakterlerin düzgün görünmesi için)
chcp 65001 >nul
title Wrait OS - Lisans ve Sistem Bilgisi
mode con: cols=75 lines=28
color 0b

:: Yonetici haklarini kontrol et
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    echo   HATA: Lutfen bu dosyayi SAG TIKLAYIP
    echo         "YONETICI OLARAK CALISTIR" secenegiyle acin.
    echo  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    pause
    exit
)

:menu
cls
echo.
echo  ============================================================
echo                LISANS VE SISTEM BILGISI PANELI
echo  ============================================================
echo.
echo    [1] Sistem Bilgilerini Goster (Donanim ve OS)
echo    [2] Lisans Durumunu Sorgula (Sureli mi, Kalici mi?)
echo    [3] Windows Pro Etkinlestir (KMS Dijital)
echo.
echo    [X] Islemi Iptal Et / Cikis
echo.
echo  ============================================================
echo.

set /p secim="Seciminizi yapin ve Enter'a basin: "

if /i "%secim%"=="1" goto :bilgi
if /i "%secim%"=="2" goto :durum
if /i "%secim%"=="3" goto :etkinlestir
if /i "%secim%"=="X" exit
goto :gecersiz

:bilgi
cls
echo.
echo [!] Sistem bilgileri toplaniyor, bu birkac saniye surebilir...
echo.
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type" /C:"Total Physical Memory"
echo.
echo Islemci Bilgisi:
wmic cpu get name | findstr /V "Name"
echo.
echo ------------------------------------------------------------
pause
goto :menu

:durum
cls
echo.
echo [!] Lisans durumu penceresi aciliyor...
slmgr /xpr
echo.
pause
goto :menu

:etkinlestir
cls
echo.
echo  ============================================================
echo             WINDOWS ETKINLESTIRME (Wrait OS)
echo  ============================================================
echo.
echo  [!] Internet baglantinizin oldugundan emin olun.
echo  [!] Islem sirasinda birkac onay penceresi cikabilir.
echo.
set /p onay="Devam etmek istiyor musunuz? (E/H): "
if /i "%onay%" NEQ "E" goto :menu

echo.
echo [1/3] Pro Anahtari Yukleniyor...
slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
echo [2/3] Sunucu Baglantisi Kuruluyor...
slmgr /skms kms8.msguides.com
echo [3/3] Aktivasyon Tetikleniyor...
slmgr /ato
echo.
echo [!] Islem tamamlandi. 
echo Ayarlar > Etkinlestirme kismindan kontrol edebilirsiniz.
pause
goto :menu

:gecersiz
echo.
echo [!] Hatali secim yaptiniz! 1, 2, 3 veya X kullanin.
timeout /t 2 >nul
goto :menu
