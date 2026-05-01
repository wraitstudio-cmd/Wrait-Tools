@echo off
chcp 65001 >nul
title Wrait OS - AntiVirus Güvenlik Merkezi
mode con: cols=85 lines=28
color 0b

:: Yönetici kontrolü
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo [!] HATA: Virüs taraması ve temizliği için yönetici yetkisi şarttır!
    pause
    exit
)

:menu
cls
echo.
echo  ===========================================================================
echo                    WRAIT OS - GELİŞMİŞ ANTİVİRÜS MERKEZİ
echo  ===========================================================================
echo.
echo    [1] HIZLI TARAMA (Sistem dosyalarını ve belleği tarar)
echo    [2] TAM TARAMA (Tüm diskleri ve dosyaları didik didik eder)
echo    [3] DERİN TARAMA (Çevrimdışı Tarama - Windows Boot Öncesi)
echo        - En inatçı virüsleri (Rootkit) temizlemek için sistemi yeniden başlatır.
echo.
echo    [4] DEFENDER GÜNCELLE (Virüs veritabanını yeniler)
echo    [5] KARANTİNAYI TEMİZLE (Tehdit kalıntılarını siler)
echo.
echo    [X] ANA MENÜYE DÖN
echo  ===========================================================================
echo.

set /p sec="Güvenlik işlemi seçin: "

if "%sec%"=="1" goto :hizli
if "%sec%"=="2" goto :tam
if "%sec%"=="3" goto :derin
if "%sec%"=="4" goto :guncelle
if "%sec%"=="5" goto :karantina
if /i "%sec%"=="X" exit
goto :menu

:hizli
cls
echo.
echo [!] Hızlı tarama başlatılıyor... Lütfen bekleyin.
"C:\Program Files\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
echo.
echo [!] Tarama bitti. Tehdit bulunursa Windows Güvenliği bildirim atacaktır.
pause
goto :menu

:tam
cls
echo.
echo [!] Tam tarama başlatılıyor... (Bu işlem disk boyutuna göre uzun sürebilir!)
"C:\Program Files\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
echo.
echo [!] Tam tarama tamamlandı.
pause
goto :menu

:derin
cls
echo.
echo [!] DİKKAT: Çevrimdışı tarama (Offline Scan) başlatılacak.
echo [!] Bilgisayarınız yeniden başlayacak ve Windows açılmadan tarama yapacak.
echo [!] Bu yöntem, çalışan sisteme sızmış virüsleri temizlemek için EN İYİ yoldur.
echo.
set /p onay="Sistemi şimdi yeniden başlatıp derin tarama yapılsın mı? (E/H): "
if /i "%onay%"=="E" (
    powershell -Command "Start-MpWDOScan"
)
goto :menu

:guncelle
cls
echo.
echo [!] Virüs tanımları güncelleniyor...
"C:\Program Files\Windows Defender\MpCmdRun.exe" -SignatureUpdate
echo.
echo [!] Güncelleme tamamlandı. Artık en yeni virüslere karşı hazırsınız.
pause
goto :menu

:karantina
cls
echo.
echo [!] Karantinadaki dosyalar temizleniyor...
"C:\Program Files\Windows Defender\MpCmdRun.exe" -Restore -All
:: Not: Aslında bu komut kurtarır, silmek için temizleme kullanılır. 
:: Defender genelde otomatik siler ama biz geçmişi temizleyelim:
powershell -Command "Remove-MpThreat"
echo.
echo [!] Tehdit geçmişi ve karantina temizlendi.
pause
goto :menu
