@echo off
title Wrait OS - Disk Yonetimi (Diskpart Yardimcisi)
mode con: cols=70 lines=30
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
echo                KOLAYLASTIRILMIS DISK YONETIMI
echo  ============================================================
echo.
echo    [1] Diskleri Listele (Hangi diskler var?)
echo    [2] Disk Sec (Islem yapmadan once mutlaka secin)
echo    [3] Secili Diski Temizle (FORMAT - DIKKAT!)
echo    [4] Yeni Bölüm Olustur (Tum diski tek parca yapar)
echo    [5] Surucu Harfi Ata (Otomatik harf verir)
echo    [6] Cikis
echo.
echo  ============================================================
echo.

set /p secim="Islem secin (1-6): "

if "%secim%"=="1" goto :liste
if "%secim%"=="2" goto :sec
if "%secim%"=="3" goto :temizle
if "%secim%"=="4" goto :olustur
if "%secim%"=="5" goto :harf
if "%secim%"=="6" exit
goto :gecersiz

:liste
cls
echo Mevcut Diskler:
echo.
(echo list disk) | diskpart
echo.
pause
goto :menu

:sec
echo.
set /p diskno="Islem yapacaginiz disk numarasini girin (Orn: 0 veya 1): "
echo sel disk %diskno% > ds_komut.txt
echo Diski sectim.
pause
goto :menu

:temizle
echo.
echo !!! UYARI: Secili diskteki TUM VERILER SILINECEK !!!
set /p onay="Eminim, devam et (E/H): "
if /i "%onay%"=="E" (
    echo sel disk %diskno% > ds_komut.txt
    echo clean >> ds_komut.txt
    diskpart /s ds_komut.txt
    echo Disk temizlendi.
) else (
    echo Islem iptal edildi.
)
pause
goto :menu

:olustur
echo.
echo Birinci bolum olusturuluyor ve formatlaniyor (Hizli NTFS)...
echo sel disk %diskno% > ds_komut.txt
echo create partition primary >> ds_komut.txt
echo format fs=ntfs quick >> ds_komut.txt
echo active >> ds_komut.txt
diskpart /s ds_komut.txt
echo Bolum olusturuldu.
pause
goto :menu

:harf
echo.
echo Surucu harfi ataniyor...
echo sel disk %diskno% > ds_komut.txt
echo sel part 1 >> ds_komut.txt
echo assign >> ds_komut.txt
diskpart /s ds_komut.txt
echo Harf atandi.
pause
goto :menu

:gecersiz
echo Hatali secim!
timeout /t 2 >nul
goto :menu