# 🖥️ WRAIT OS | Advanced Kernel & System Core

<p align="center">
  <img src="https://img.shields.io/badge/Version-1.0.0-brightgreen?style=for-the-badge&logo=windows11">
  <img src="https://img.shields.io/badge/Language-C%23%20%7C%20ASM%20%7C%20Batch-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/License-MIT-orange?style=for-the-badge">
</p>

---

## ⚡ Hakkında
**WraitOS**, Windows mimarisi üzerine inşa edilmiş, düşük seviyeli sistem araçlarını ve kernel yapılandırmalarını tek bir panelden yöneten özel bir işletim sistemi katmanıdır. Gelişmiş otomasyon betikleri ve C# ile yazılmış çekirdek yönetim paneli sayesinde sistem üzerinde tam kontrol sağlar.

> **Status:** Active Development (v1.0 - Stable)

---

## 🚀 Öne Çıkan Özellikler

*   **🛡️ Core Master Panel:** C# ve GDI+ kullanılarak geliştirilmiş, sürükle-bırak destekli şık ve hızlı yönetim arayüzü.
*   **📡 Smart Update Engine:** GitHub API tabanlı çalışan, sistem dosyalarını ve sürücüleri (Driver.bat) otomatik güncelleyen motor.
*   **⚙️ Low-Level Automation:** Kayıt defteri (Registry) optimizasyonları ve CMD tabanlı sistem araçları entegrasyonu.
*   **📦 Modüler Yapı:** `Tools/` klasörüne eklenen her `.bat` dosyasını otomatik algılayan dinamik menü sistemi.

---

### 🛠️ Kurulum (Installation)

1.  **Setup Dosyasını İndirin:**
    *   [WraitOS_Setup.exe](https://github.com/wraitstudio-cmd/Wrait-Tools/raw/main/WraitOS_Setup.exe) (veya hazırladığın Setup dosyasının linki) adresine gidin ve dosyayı indirin.

2.  **Kurulumu Başlatın:**
    *   İndirdiğiniz `.exe` dosyasına çift tıklayın.
    *   Windows "Bilinmeyen Yayıncı" uyarısı verirse "Ek Bilgi" -> "Yine de Çalıştır" seçeneğine tıklayın.
    *   Kurulum sihirbazındaki adımları takip ederek WraitOS'u sisteminize kurun.

3.  **.NET Framework Kontrolü:**
    *   WraitOS'un çalışması için sisteminizde **.NET Framework 4.8** veya üzeri bir sürümün yüklü olması gerekir. Eğer yüklü değilse, program açılırken sizi indirme sayfasına yönlendirecektir.

4.  **Sistemi Başlatın:**
    *   Kurulum bittikten sonra masaüstüne gelen **WraitOS** kısayoluna sağ tıklayıp "Yönetici Olarak Çalıştır" diyerek sistem araçlarını kullanmaya başlayabilirsiniz.

---

## 📁 Dosya Yapısı
```text
WraitOS/
├── WraitOS.cs          # Ana sistem çekirdek kodu (C#)
├── WraitOS.exe          # Derlenmiş çalıştırılabilir dosya
├── version.vrs          # Sürüm takip dosyası
└── Tools/               # Sistem araçları ve .bat scriptleri
    └── Driver.bat       # Donanım ve sürücü yönetim betiği
