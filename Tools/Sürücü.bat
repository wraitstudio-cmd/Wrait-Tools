@echo off
chcp 65001 >nul
title Wrait OS - Sürücü Yönetim Merkezi
mode con: cols=85 lines=25
color 0b

:: Yönetici kontrolü
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo [!] HATA: Sürücü işlemleri için yönetici yetkisi gerekir!
    pause
    exit
)

:: Klasör Yapısını Oluştur (Yoksa oluşturur)
set "DATAPATH=%LocalAppData%\WraitOs_Data"
set "DRIVERPATH=%DATAPATH%\Drivers"

if not exist "%DATAPATH%" (
    mkdir "%DATAPATH%"
    echo [i] Veri klasörü oluşturuldu: %DATAPATH%
)

if not exist "%DRIVERPATH%" (
    mkdir "%DRIVERPATH%"
)

:menu
cls
echo.
echo  ===========================================================================
echo                    WRAIT OS - SÜRÜCÜ YEDEKLEME VE GERİ YÜKLER
echo  ===========================================================================
echo.
echo    Yol: %DRIVERPATH%
echo.
echo    [1] Sürücüleri Yedekle (LocalAppdata içine)
echo        - Mevcut tüm üçüncü taraf sürücüleri klasöre aktarır.
echo.
echo    [2] Sürücüleri Geri Yükle (Yedekten yükle)
echo        - Klasördeki tüm .inf dosyalarını sisteme tekrar kurar.
echo.
echo    [3] Yedek Klasörünü Aç (Windows Gezgini)
echo    [4] Yedekleri Temizle (Klasörü boşaltır)
echo.
echo    [X] ANA MENÜYE DÖN
echo  ===========================================================================
echo.

set /p sec="Seçiminizi yapın: "

if "%sec%"=="1" goto :yedekle
if "%sec%"=="2" goto :geriyukle
if "%sec%"=="3" goto :klasor_ac
if "%sec%"=="4" goto :temizle
if /i "%sec%"=="X" exit
goto :menu

:yedekle
cls
echo.
echo [!] Sürücüler dışa aktarılıyor... Bu işlem donanıma göre vakit alabilir.
echo [!] Lütfen bekleyin...
echo.
dism /online /export-driver /destination:"%DRIVERPATH%"
echo.
echo [!] İşlem başarıyla tamamlandı.
echo [!] Sürücüler şuraya kaydedildi: %DRIVERPATH%
pause
goto :menu

:geriyukle
cls
echo.
echo [!] Sürücüler geri yükleniyor...
echo [!] Bu işlem sisteminize sürücüleri otomatik olarak tanıtacaktır.
echo.
pnputil /add-driver "%DRIVERPATH%\*.inf" /subdirs /install
echo.
echo [!] Geri yükleme işlemi bitti.
pause
goto :menu

:klasor_ac
start "" "%DRIVERPATH%"
goto :menu

:temizle
echo.
echo [!] DİKKAT: Tüm yedeklenmiş sürücüler silinecek!
set /p onay="Emin misiniz? (E/H): "
if /i "%onay%"=="E" (
    del /q /s "%DRIVERPATH%\*.*" >nul
    echo [!] Temizlendi.
)
pause
goto :menu