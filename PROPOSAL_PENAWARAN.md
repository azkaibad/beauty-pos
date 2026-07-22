# 📄 PROPOSAL PENAWARAN
## Pengembangan Sistem POS Klinik Kecantikan & Treatment
### Aplikasi Desktop & Mobile Terintegrasi

---

> **Nomor Proposal:** PROP/2026/07/001  
> **Tanggal:** 20 Juli 2026  
> **Berlaku Hingga:** 20 Agustus 2026 (30 hari)  
> **Diajukan oleh:** [Nama Developer / Perusahaan]  
> **Ditujukan kepada:** [Nama Klinik / Perusahaan Klien]  

---

## DAFTAR ISI

1. [Latar Belakang & Manfaat Sistem](#1-latar-belakang--manfaat-sistem)
2. [Ruang Lingkup & Spesifikasi Pekerjaan](#2-ruang-lingkup--spesifikasi-pekerjaan)
3. [Jadwal Pelaksanaan (Gantt Chart)](#3-jadwal-pelaksanaan-gantt-chart)
4. [Rincian Hari Kerja](#4-rincian-hari-kerja)
5. [Biaya & Jasa Pengembangan](#5-biaya--jasa-pengembangan)
6. [Dukungan Teknis & Ketentuan](#6-dukungan-teknis--ketentuan)
7. [Penutup](#7-penutup)

---

## 1. LATAR BELAKANG & MANFAAT SISTEM

### 1.1 Latar Belakang

Industri kecantikan dan perawatan kulit di Indonesia mengalami pertumbuhan pesat dalam beberapa tahun terakhir. Klinik kecantikan modern dituntut untuk memberikan pelayanan yang cepat, akurat, dan terorganisir — mulai dari pendaftaran pasien, konsultasi dokter, treatment, hingga pembayaran dan pelaporan keuangan.

Saat ini, banyak klinik kecantikan yang masih mengandalkan pencatatan manual atau menggunakan beberapa aplikasi terpisah yang tidak terintegrasi. Hal ini menyebabkan:

- ❌ **Antrian yang tidak terorganisir** — Pasien langsung diarahkan ke pembayaran tanpa proses konsultasi/treatment yang jelas
- ❌ **Pencatatan keuangan yang tidak akurat** — Saldo tercatat sebelum transaksi benar-benar selesai
- ❌ **Rekam medis tidak terdokumentasi** — Riwayat treatment dan foto before/after tidak tersimpan dengan baik
- ❌ **Laporan keuangan memakan waktu** — Rekap manual per metode pembayaran (cash, transfer, QRIS) rawan human error
- ❌ **Pengelolaan multi-device sulit** — Kasir di PC dan dokter di mobile tidak bisa bekerja dalam satu sistem

Berdasarkan kebutuhan tersebut, kami mengajukan penawaran untuk membangun **Sistem POS Klinik Kecantikan & Treatment** yang terintegrasi antara desktop dan mobile.

### 1.2 Manfaat Sistem

Dengan implementasi sistem ini, klien akan mendapatkan:

| No | Manfaat | Dampak |
|----|---------|--------|
| 1 | **Antrian Terstruktur** | Alur pasien jelas: Daftar → Konsultasi → Treatment → Pembayaran. Tidak ada lagi pasien yang langsung masuk ke kasir tanpa proses |
| 2 | **Akurasi Keuangan** | Saldo & omset hanya tercatat setelah pembayaran lunas. Eliminasi selisih kas akibat pencatatan prematur |
| 3 | **Closing Shift Otomatis** | Rekonsiliasi kas siang & malam dengan perbandingan data sistem vs aktual. Selisih langsung terdeteksi |
| 4 | **Rekam Medis Digital** | Dokter bisa mendokumentasikan treatment dengan foto before/after langsung dari smartphone |
| 5 | **Laporan 1-Klik** | Laporan bulanan dengan breakdown Cash, Transfer, QRIS, Kurir TF — langsung export ke Excel |
| 6 | **Multi-Platform** | Kasir bekerja di PC, dokter di smartphone — semua data tersinkronisasi real-time |
| 7 | **Keamanan Data** | Hak akses berbeda untuk Owner, Manager, Admin (Kasir), dan Dokter. Data medis terenkripsi |
| 8 | **Efisiensi Operasional** | Pengurangan waktu administrasi hingga 60%, memungkinkan staff fokus pada pelayanan pasien |
| 9 | **Follow-Up Otomatis** | Sistem mengingatkan staff untuk menghubungi pasien yang perlu kunjungan ulang |
| 10 | **Kontrol Pengeluaran** | Semua pengeluaran operasional melalui proses pengajuan dan persetujuan digital |

### 1.3 Keunggulan Solusi Kami

- **Satu Aplikasi untuk Semua** — Desktop dan mobile dalam satu ekosistem
- **Didesain Khusus untuk Klinik Kecantikan** — Bukan template umum, tapi dibuat sesuai workflow klinik
- **Modern & User-Friendly** — Tampilan bersih, mudah dipelajari oleh semua level staff
- **Skalabel** — Siap digunakan untuk 1 cabang maupun multi-cabang di masa depan
- **Support Jangka Panjang** — Maintenance dan dukungan teknis pasca-launch

---

## 2. RUANG LINGKUP & SPESIFIKASI PEKERJAAN

### 2.1 Platform yang Dikembangkan

| No | Platform | Teknologi | Keterangan |
|----|----------|-----------|------------|
| 1 | **Aplikasi Desktop** (Windows) | Flutter Desktop / Electron + Vue | Untuk kasir, admin, manager, owner |
| 2 | **Aplikasi Mobile** (Android & iOS) | Flutter | Untuk dokter, manager, owner |
| 3 | **Backend API** | Laravel 11 (PHP) | Server terpusat untuk semua platform |
| 4 | **Database** | MySQL / PostgreSQL | Penyimpanan data terpusat |
| 5 | **File Storage** | Cloud Storage (S3/MinIO) | Penyimpanan foto rekam medis |

### 2.2 Modul yang Dikembangkan

#### FASE 1 — Sistem Inti (Core System)

| No | Modul | Fitur Utama | Prioritas |
|----|-------|-------------|:---------:|
| 1 | **Autentikasi & Role Management** | Login, logout, 4 level role (Owner, Manager, Admin, Dokter), hak akses per modul | 🔴 Tinggi |
| 2 | **Dashboard** | Ringkasan per role, statistik real-time, notifikasi | 🔴 Tinggi |
| 3 | **Master Data** | CRUD Produk, Treatment, Kategori, Metode Pembayaran, Supplier | 🔴 Tinggi |
| 4 | **Manajemen Customer** | CRUD data pelanggan/pasien, riwayat kunjungan, pencarian | 🔴 Tinggi |
| 5 | **Sistem Antrian** | 3 jenis antrian (Konsultasi, Treatment, Pembelian), status tracking, panggil antrian | 🔴 Tinggi |
| 6 | **POS / Kasir** | Input penjualan, multi metode bayar, diskon, simpan transaksi, validasi pembayaran | 🔴 Tinggi |
| 7 | **Cetak Struk** | Cetak struk thermal (hanya jika sudah bayar), format kustom | 🔴 Tinggi |
| 8 | **Closing Siang & Malam** | Rekonsiliasi kas per shift, input aktual vs sistem, selisih, approval | 🔴 Tinggi |

#### FASE 2 — Fitur Lengkap

| No | Modul | Fitur Utama | Prioritas |
|----|-------|-------------|:---------:|
| 9 | **Rekam Medis** | CRUD rekam medis, upload foto (before/during/after), riwayat kunjungan, catatan dokter | 🟡 Sedang |
| 10 | **Treatment & Konsultasi** | Alur konsultasi → treatment, pencatatan tindakan, assign dokter | 🟡 Sedang |
| 11 | **Pengajuan Pengeluaran** | Pengajuan oleh admin, approval oleh manager/owner, bukti upload | 🟡 Sedang |
| 12 | **Data Follow-Up** | Tracking follow-up customer, status, reminder, riwayat kontak | 🟡 Sedang |
| 13 | **Manajemen Stok** | Stok masuk/keluar, stok opname, alert minimum, pergerakan stok | 🟡 Sedang |
| 14 | **Laporan & Rekap** | 13 jenis laporan, filter lengkap, export Excel (.xlsx) | 🟡 Sedang |

#### FASE 3 — Penyempurnaan

| No | Modul | Fitur Utama | Prioritas |
|----|-------|-------------|:---------:|
| 15 | **Multi-Cabang** | Manajemen cabang, stok per cabang, laporan per cabang | 🟢 Rendah |
| 16 | **Promo & Diskon** | Buat promo dengan periode, target produk/treatment | 🟢 Rendah |
| 17 | **Testimoni & Galeri** | Kelola testimoni customer, galeri foto klinik | 🟢 Rendah |
| 18 | **FAQ** | Kelola FAQ untuk customer | 🟢 Rendah |
| 19 | **Audit Log** | Log semua aktivitas user untuk keamanan | 🟢 Rendah |
| 20 | **Pengaturan Sistem** | Setting perusahaan, shift, struk, umum | 🟢 Rendah |

### 2.3 Spesifikasi Teknis

| Aspek | Spesifikasi |
|-------|-------------|
| Arsitektur | Client-Server (REST API + WebSocket) |
| Keamanan | JWT Authentication, HTTPS/TLS, bcrypt password hashing |
| Real-time | WebSocket untuk antrian dan notifikasi |
| Printer | ESC/POS protocol (USB untuk desktop, Bluetooth untuk mobile) |
| Export | Excel (.xlsx) untuk semua laporan |
| Backup | Auto backup harian ke cloud |
| Responsif | Desktop: optimized 1366px+, Mobile: 360px+ |

### 2.4 Deliverables (Yang Diserahkan)

| No | Deliverable | Format |
|----|------------|--------|
| 1 | Source code aplikasi Desktop | Repository Git |
| 2 | Source code aplikasi Mobile | Repository Git |
| 3 | Source code Backend API | Repository Git |
| 4 | Database & migrasi | SQL + Migration files |
| 5 | Installer Desktop (Windows) | .exe / .msix |
| 6 | APK / App Bundle (Android) | .apk / .aab |
| 7 | Build iOS (jika diperlukan) | .ipa (via TestFlight) |
| 8 | Dokumentasi teknis | Markdown / PDF |
| 9 | Panduan penggunaan (User Guide) | PDF + Video |
| 10 | Deployment ke server produksi | Live server |

---

## 3. JADWAL PELAKSANAAN (GANTT CHART)

### 3.1 Timeline Overview

**Total Durasi:** ±24 Minggu (6 Bulan)  
**Hari Kerja:** Senin — Jumat (5 hari/minggu)  
**Jam Kerja:** 8 jam/hari

### 3.2 Gantt Chart

```
FASE / MODUL                        Bln 1      Bln 2      Bln 3      Bln 4      Bln 5      Bln 6
                                  M1 M2 M3 M4 M1 M2 M3 M4 M1 M2 M3 M4 M1 M2 M3 M4 M1 M2 M3 M4 M1 M2 M3 M4
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────

▶ FASE 1 — SISTEM INTI
  Setup & Arsitektur              ████████
  Auth & Role Management              ████████
  Database & Master Data                   ████████████
  Manajemen Customer                            ████████
  Sistem Antrian                                     ████████████
  POS / Kasir                                                  ████████████
  Cetak Struk                                                       ████
  Closing Siang & Malam                                                  ████████
  Testing Fase 1                                                              ████████
  ── MILESTONE: Demo Fase 1 ──                                                     ◆

▶ FASE 2 — FITUR LENGKAP
  Rekam Medis + Upload Foto                                                         ████████████
  Treatment & Konsultasi                                                                  ████████
  Pengajuan Pengeluaran                                                                        ████████
  Data Follow-Up                                                                                    ████████
  Manajemen Stok                                                                                         ████████
  Laporan & Export Excel                                                                                      ████████████
  Testing Fase 2                                                                                                   ████████
  ── MILESTONE: Demo Fase 2 ──                                                                                          ◆

▶ FASE 3 — PENYEMPURNAAN
  Multi-Cabang                                                                                                           ████████
  Promo, Testimoni, Galeri                                                                                                    ████████
  FAQ & Audit Log                                                                                                                  ████
  Pengaturan Sistem                                                                                                                ████
  Final Testing & Bug Fix                                                                                                              ████████
  Deployment & Go-Live                                                                                                                      ████
  ── MILESTONE: Go-Live ──                                                                                                                      ◆

▶ PASCA-LAUNCH
  Monitoring & Support                                                                                                                      ████████
  Training User                                                                                                                                  ████
```

### 3.3 Milestone Utama

| Milestone | Target | Deliverable |
|-----------|--------|-------------|
| **Demo Fase 1** | Akhir Bulan ke-2 | Sistem POS + Antrian + Closing berjalan |
| **Demo Fase 2** | Akhir Bulan ke-4 | Rekam medis + Laporan + Stok lengkap |
| **Go-Live** | Akhir Bulan ke-6 | Seluruh fitur live, siap produksi |
| **Handover** | +2 Minggu setelah Go-Live | Source code + dokumentasi diserahkan |

---

## 4. RINCIAN HARI KERJA

### 4.1 Ringkasan per Fase

| Fase | Durasi (Minggu) | Hari Kerja | Jam Kerja |
|------|:-:|:-:|:-:|
| **Fase 1** — Sistem Inti | 10 | 50 hari | 400 jam |
| **Fase 2** — Fitur Lengkap | 8 | 40 hari | 320 jam |
| **Fase 3** — Penyempurnaan | 6 | 30 hari | 240 jam |
| **TOTAL** | **24** | **120 hari** | **960 jam** |

### 4.2 Rincian Detail per Modul

#### FASE 1 — SISTEM INTI (50 Hari Kerja)

| No | Modul / Pekerjaan | Estimasi (Hari) | Keterangan |
|----|-------------------|:-:|------------|
| 1 | Setup project & arsitektur (backend, desktop, mobile) | 5 | Boilerplate, config, CI/CD |
| 2 | Database design & migration | 3 | ERD, tabel, relasi, seeder |
| 3 | Autentikasi & Role Management | 5 | Login, JWT, RBAC, middleware |
| 4 | Dashboard (semua role) | 4 | Widget, statistik, realtime |
| 5 | Master Data (Produk, Treatment, Kategori, dll) | 5 | CRUD + validasi + search |
| 6 | Manajemen Customer | 4 | CRUD + riwayat + pencarian |
| 7 | Sistem Antrian | 7 | 3 jenis antrian, status flow, realtime, panggil |
| 8 | POS / Kasir | 7 | Input penjualan, multi payment, diskon, validasi |
| 9 | Cetak Struk (thermal printer) | 3 | ESC/POS, format struk, koneksi printer |
| 10 | Closing Siang & Malam | 4 | Form closing, selisih, approval, history |
| 11 | Testing & Bug Fix Fase 1 | 3 | Unit test, integration test, UAT |
| | **Subtotal Fase 1** | **50** | |

#### FASE 2 — FITUR LENGKAP (40 Hari Kerja)

| No | Modul / Pekerjaan | Estimasi (Hari) | Keterangan |
|----|-------------------|:-:|------------|
| 12 | Rekam Medis + Upload Foto | 7 | CRUD, upload, galeri, watermark, timeline |
| 13 | Treatment & Konsultasi | 5 | Alur konsultasi-treatment, assign dokter |
| 14 | Pengajuan Pengeluaran | 4 | Form pengajuan, approval flow, bukti |
| 15 | Data Follow-Up | 4 | Tracking, reminder, status, riwayat kontak |
| 16 | Manajemen Stok (In/Out, Opname) | 5 | Pergerakan stok, alert minimum, history |
| 17 | Laporan & Rekap (13 jenis) | 8 | Semua laporan + filter + export Excel |
| 18 | Saldo & Omset | 3 | Perhitungan saldo, breakdown metode bayar |
| 19 | Testing & Bug Fix Fase 2 | 4 | Unit test, integration test, UAT |
| | **Subtotal Fase 2** | **40** | |

#### FASE 3 — PENYEMPURNAAN (30 Hari Kerja)

| No | Modul / Pekerjaan | Estimasi (Hari) | Keterangan |
|----|-------------------|:-:|------------|
| 20 | Multi-Cabang | 5 | Assign user, stok, laporan per cabang |
| 21 | Promo & Diskon | 3 | Periode, target, nominal/persentase |
| 22 | Testimoni & Galeri | 3 | CRUD testimoni, upload galeri |
| 23 | FAQ | 1 | CRUD FAQ |
| 24 | Audit Log | 2 | Log aktivitas, filter, export |
| 25 | Pengaturan Sistem | 3 | Company, shift, struk, umum |
| 26 | UI/UX Polish & Responsif | 4 | Konsistensi UI, animasi, responsif |
| 27 | Final Testing & Bug Fix | 5 | Full regression test, performance test |
| 28 | Deployment & Go-Live | 2 | Server setup, deploy, DNS, SSL |
| 29 | User Guide & Dokumentasi | 2 | PDF panduan, video tutorial |
| | **Subtotal Fase 3** | **30** | |

### 4.3 Asumsi Hari Kerja

- **Hari kerja:** Senin — Jumat
- **Jam kerja:** 8 jam/hari efektif
- **Tidak termasuk:** Hari libur nasional, cuti bersama
- **Catatan:** Estimasi dapat berubah jika ada perubahan scope yang disepakati kedua belah pihak

---

## 5. BIAYA & JASA PENGEMBANGAN

### 5.1 Biaya Pengembangan Aplikasi

| No | Komponen | Detail | Biaya (Rp) |
|----|----------|--------|----------:|
| **FASE 1** | **Sistem Inti** | | |
| 1 | Setup, Arsitektur & Database | Project setup, boilerplate, ERD, migration | 3.000.000 |
| 2 | Autentikasi & Role Management | Login, JWT, 4-level RBAC | 3.500.000 |
| 3 | Dashboard (semua role) | Widget statistik, realtime, notifikasi | 2.500.000 |
| 4 | Master Data | CRUD Produk, Treatment, Kategori, dll | 3.000.000 |
| 5 | Manajemen Customer | CRUD + pencarian + riwayat | 2.500.000 |
| 6 | Sistem Antrian | 3 jenis antrian, realtime, panggil | 5.000.000 |
| 7 | POS / Kasir | Penjualan, multi-payment, diskon, validasi | 5.500.000 |
| 8 | Cetak Struk | Integrasi thermal printer, format struk | 2.000.000 |
| 9 | Closing Siang & Malam | Rekonsiliasi kas, selisih, approval | 3.000.000 |
| | **Subtotal Fase 1** | | **30.000.000** |
| | | | |
| **FASE 2** | **Fitur Lengkap** | | |
| 10 | Rekam Medis + Upload Foto | CRUD, galeri foto, watermark, timeline | 5.000.000 |
| 11 | Treatment & Konsultasi | Alur konsultasi-treatment, assign dokter | 3.500.000 |
| 12 | Pengajuan Pengeluaran | Pengajuan, approval flow, bukti | 2.500.000 |
| 13 | Data Follow-Up | Tracking, reminder, status | 2.500.000 |
| 14 | Manajemen Stok | In/Out, opname, alert minimum | 3.500.000 |
| 15 | Laporan & Rekap (13 jenis) | Semua laporan + filter + export Excel | 6.000.000 |
| 16 | Saldo & Omset | Perhitungan, breakdown metode bayar | 2.000.000 |
| | **Subtotal Fase 2** | | **25.000.000** |
| | | | |
| **FASE 3** | **Penyempurnaan** | | |
| 17 | Multi-Cabang | Manajemen cabang, stok, laporan | 3.000.000 |
| 18 | Promo, Testimoni, Galeri, FAQ | CRUD + upload media | 3.000.000 |
| 19 | Audit Log & Pengaturan | Log aktivitas, setting sistem | 2.000.000 |
| 20 | UI/UX Polish | Konsistensi, animasi, responsif | 2.000.000 |
| 21 | Testing & QA | Full regression, performance test | 2.500.000 |
| 22 | Deployment & Go-Live | Server, deploy, DNS, SSL | 1.500.000 |
| 23 | Dokumentasi & User Guide | PDF + video tutorial | 1.000.000 |
| | **Subtotal Fase 3** | | **15.000.000** |

### 5.2 Ringkasan Biaya Pengembangan

| Komponen | Biaya (Rp) |
|----------|----------:|
| Fase 1 — Sistem Inti | 30.000.000 |
| Fase 2 — Fitur Lengkap | 25.000.000 |
| Fase 3 — Penyempurnaan | 15.000.000 |
| **TOTAL BIAYA PENGEMBANGAN** | **70.000.000** |

### 5.3 Biaya Infrastruktur (Bulanan)

| No | Item | Biaya/Bulan (Rp) | Keterangan |
|----|------|----------------:|------------|
| 1 | Server VPS (Cloud) | 150.000 — 500.000 | Tergantung spesifikasi & provider |
| 2 | Domain (.com / .id) | ±15.000 | ±180.000/tahun dibagi 12 bulan |
| 3 | SSL Certificate | Gratis | Let's Encrypt (auto-renew) |
| 4 | Cloud Storage (foto rekam medis) | 50.000 — 200.000 | Tergantung volume foto |
| | **Estimasi Total/Bulan** | **215.000 — 715.000** | |

> **📌 Catatan:** Biaya infrastruktur ditanggung oleh klien dan dibayar terpisah dari biaya pengembangan.

### 5.4 Biaya Maintenance (Opsional, Pasca-Launch)

| Paket | Cakupan | Biaya/Bulan (Rp) |
|-------|---------|----------------:|
| **Basic** | Bug fix minor, monitoring server, backup | 1.500.000 |
| **Standard** | Basic + update fitur kecil (max 2x/bulan) + support via chat | 3.000.000 |
| **Premium** | Standard + fitur baru, optimasi, priority support, on-call | 5.000.000 |

> **📌 Catatan:** Maintenance dimulai setelah masa garansi (3 bulan pasca go-live) berakhir. Kontrak maintenance bersifat opsional dan terpisah.

### 5.5 Skema Pembayaran

Pembayaran dilakukan dalam **3 termin** sesuai milestone:

| Termin | Waktu | Persentase | Nominal (Rp) | Trigger |
|:------:|-------|:----------:|-------------:|---------|
| **1** | Awal proyek | 30% | 21.000.000 | Setelah penandatanganan kontrak & kick-off |
| **2** | Selesai Fase 1 + 2 | 40% | 28.000.000 | Setelah demo & approval Fase 1 dan Fase 2 |
| **3** | Go-Live | 30% | 21.000.000 | Setelah seluruh fitur live & handover |
| | **TOTAL** | **100%** | **70.000.000** | |

### 5.6 Metode Pembayaran

- Transfer Bank ke rekening [Nama Bank] a.n. [Nama Penerima]
- No. Rekening: [XXXX-XXXX-XXXX]
- Setiap pembayaran akan diberikan **kwitansi/invoice resmi**

---

## 6. DUKUNGAN TEKNIS & KETENTUAN

### 6.1 Garansi

| Aspek | Ketentuan |
|-------|-----------|
| **Masa Garansi** | **3 bulan** setelah go-live |
| **Cakupan** | Bug fix, error, dan malfungsi yang bukan disebabkan oleh modifikasi klien |
| **Response Time** | Critical: 4 jam, Major: 1×24 jam, Minor: 3×24 jam |
| **Channel** | WhatsApp, Email, Remote Access (AnyDesk/TeamViewer) |
| **Tidak Termasuk** | Penambahan fitur baru, perubahan design major, kerusakan akibat pihak ketiga |

### 6.2 Dukungan Teknis Selama Pengembangan

| Aspek | Ketentuan |
|-------|-----------|
| **Progress Report** | Laporan mingguan via WhatsApp/Email |
| **Demo** | Demo di setiap akhir fase (3x demo) |
| **Revisi** | Max **3 kali revisi** per modul (termasuk dalam biaya) |
| **Komunikasi** | WhatsApp untuk harian, Video call untuk demo & diskusi |
| **Akses** | Klien mendapat akses ke staging/preview selama development |

### 6.3 Hak Kekayaan Intelektual

| Aspek | Ketentuan |
|-------|-----------|
| **Source Code** | Menjadi **milik klien** setelah pembayaran lunas 100% |
| **Lisensi** | Klien berhak menggunakan, memodifikasi, dan mendistribusikan source code |
| **Library Pihak Ketiga** | Menggunakan library open-source berlisensi MIT/Apache (gratis) |
| **Portabilitas** | Klien berhak memindahkan ke developer lain setelah handover |

### 6.4 Ketentuan Umum

1. **Scope Change (Perubahan Lingkup)**
   - Perubahan fitur di luar ruang lingkup yang telah disepakati akan dikenakan biaya tambahan
   - Setiap perubahan scope harus disetujui secara tertulis oleh kedua belah pihak
   - Perubahan scope dapat mempengaruhi jadwal pelaksanaan

2. **Pembatalan Proyek**
   - Jika klien membatalkan proyek, pembayaran yang sudah dilakukan **tidak dapat dikembalikan**
   - Developer akan menyerahkan seluruh pekerjaan yang sudah dikerjakan hingga tanggal pembatalan
   - Pembatalan harus diinformasikan secara tertulis minimal **14 hari** sebelumnya

3. **Force Majeure**
   - Keterlambatan akibat force majeure (bencana alam, pandemi, kebijakan pemerintah) tidak dianggap sebagai pelanggaran kontrak
   - Kedua belah pihak akan bermusyawarah untuk menentukan jadwal baru

4. **Kerahasiaan (NDA)**
   - Developer menjaga kerahasiaan semua data dan informasi bisnis klien
   - Tidak akan membagikan data klien kepada pihak ketiga tanpa izin tertulis

5. **Keterlibatan Klien**
   - Klien wajib menyediakan kontak PIC (Person in Charge) yang dapat dihubungi
   - Klien wajib memberikan feedback/approval dalam waktu **maksimal 5 hari kerja**
   - Keterlambatan feedback dari klien dapat mempengaruhi jadwal pelaksanaan

### 6.5 Training & Onboarding

| Aspek | Ketentuan |
|-------|-----------|
| **Sesi Training** | 2 sesi (1x untuk admin/kasir, 1x untuk dokter) |
| **Durasi** | 2-3 jam per sesi |
| **Format** | Online via Zoom/Google Meet atau onsite (jika memungkinkan) |
| **Materi** | Video recording training + PDF panduan |
| **Peserta** | Maksimal 10 orang per sesi |

### 6.6 Server Level Agreement (SLA) Pasca-Launch

| Level | Deskripsi | Response Time | Resolution Time |
|-------|-----------|:------------:|:--------------:|
| 🔴 **Critical** | Sistem down total, tidak bisa transaksi | 4 jam | 12 jam |
| 🟠 **Major** | Fitur utama error (POS, antrian, closing) | 1×24 jam | 2×24 jam |
| 🟡 **Minor** | Fitur non-kritis error (laporan, galeri) | 3×24 jam | 5×24 jam |
| 🟢 **Low** | Improvement, UI tweak, typo | 5×24 jam | 7×24 jam |

> **📌 Catatan:** SLA berlaku selama masa garansi (3 bulan). Setelahnya, SLA mengikuti paket maintenance yang dipilih.

---

## 7. PENUTUP

Demikian proposal penawaran ini kami sampaikan. Kami berkomitmen untuk memberikan solusi teknologi terbaik yang sesuai dengan kebutuhan operasional klinik Anda.

Kami yakin bahwa sistem POS terintegrasi ini akan memberikan dampak signifikan dalam:
- **Efisiensi operasional** harian klinik
- **Akurasi data keuangan** yang lebih terpercaya
- **Pengalaman pelayanan** yang lebih baik bagi pasien
- **Kemudahan monitoring** bisnis dari mana saja

Kami terbuka untuk diskusi lebih lanjut mengenai penyesuaian fitur, jadwal, maupun skema pembayaran yang paling sesuai dengan kebutuhan Anda.

### Kontak

| | Detail |
|--|--------|
| **Nama** | [Nama Lengkap] |
| **Jabatan** | Software Developer |
| **Telepon/WA** | [Nomor Telepon] |
| **Email** | [Alamat Email] |
| **Portfolio** | [Link Portfolio/Website] |

---

### Tanda Tangan Persetujuan

Dengan menandatangani dokumen ini, kedua belah pihak menyetujui seluruh ketentuan yang tercantum dalam proposal ini.

| | **Pihak Pertama (Developer)** | **Pihak Kedua (Klien)** |
|--|:---:|:---:|
| **Nama** | _________________________ | _________________________ |
| **Jabatan** | _________________________ | _________________________ |
| **Tanggal** | _________________________ | _________________________ |
| **Tanda Tangan** | _________________________ | _________________________ |

---

> **Dokumen ini bersifat RAHASIA dan hanya ditujukan untuk pihak yang tercantum.**  
> **© 2026 [Nama Developer / Perusahaan]. All rights reserved.**
