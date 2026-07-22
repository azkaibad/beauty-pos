# 📋 PRD — Sistem POS Klinik Kecantikan & Treatment
### (Desktop & Mobile Cross-Platform)

> **Version:** 1.1  
> **Tanggal:** 21 Juli 2026  
> **Status:** In Progress — Stack Terkonfirmasi  
> **Klien:** Perusahaan Treatment & Produk Kecantikan  
> **Tech Stack:** Flutter (Desktop + Mobile) + Laravel 11 API  

---

## 1. Executive Summary

Sistem POS terintegrasi untuk klinik kecantikan yang mencakup manajemen antrian pasien, penjualan produk, pencatatan treatment, rekam medis, dan pelaporan keuangan. Aplikasi berjalan di **desktop (PC/laptop)** dan **mobile (Android/iOS)** dengan sinkronisasi data real-time.

### 🎯 Tujuan Utama
- Menggantikan proses manual dengan sistem digital terintegrasi
- Memisahkan alur **antrian → konsultasi → treatment → pembayaran** secara jelas
- Memastikan saldo/omset hanya tercatat setelah transaksi selesai & dibayar
- Menyediakan laporan keuangan harian/bulanan yang akurat dan bisa di-export Excel
- Memberikan akses sesuai peran (role-based) untuk keamanan data

---

## 2. Target Platform & Teknologi

### 2.1 Platform Target

| Platform | Device | Pengguna | Keterangan |
|----------|--------|----------|------------|
| **Desktop** (Windows) | PC / Laptop | Owner, Manager, Admin (Kasir), **Dokter** | Akses penuh sesuai role masing-masing |
| **Mobile** (Android & iOS) | Smartphone / Tablet | Owner, Manager, Admin, **Dokter** | Akses mobile untuk semua role, optimal untuk Dokter saat treatment |

> **📌 Catatan Dokter:** Dokter memiliki akses di **kedua platform** — desktop untuk penggunaan di meja kerja (rekam medis, konsultasi), dan mobile untuk fleksibilitas saat di ruang treatment.

### 2.2 Stack Teknologi (Final — Terkonfirmasi)

> **✅ Stack teknologi telah dikonfirmasi:** Flutter (Desktop + Mobile) + Laravel 11 API

| Layer | Teknologi | Versi | Keterangan |
|-------|-----------|-------|------------|
| **Backend API** | Laravel | 11.x | REST API + WebSocket, business logic terpusat |
| **Database** | MySQL | 8.0+ | Relational DB untuk data transaksional |
| **ORM** | Eloquent (Laravel) | — | Query builder & relasi antar tabel |
| **Desktop App** | Flutter Desktop | 3.x | Windows native app — satu codebase bersama mobile |
| **Mobile App** | Flutter | 3.x | Android & iOS — shared codebase dengan desktop |
| **State Management** | Riverpod / BLoC | — | Manajemen state Flutter yang scalable |
| **HTTP Client** | Dio (Flutter) | — | API calls dengan interceptor & retry |
| **Real-time Sync** | Laravel Reverb / Pusher | — | WebSocket untuk antrian & notifikasi real-time |
| **Cetak Struk** | flutter_esc_pos_utils | — | ESC/POS thermal printer via USB (desktop) & Bluetooth (mobile) |
| **Export Laporan** | laravel-excel (Maatwebsite) | 3.x | Export .xlsx langsung dari Laravel |
| **File Storage** | Laravel Storage + S3/MinIO | — | Penyimpanan foto rekam medis |
| **Auth** | Laravel Sanctum | — | Token-based auth untuk API |
| **Notifications** | Firebase FCM | — | Push notification ke mobile |

#### Alasan Memilih Flutter + Laravel:
- **Satu codebase Flutter** → compile ke Windows Desktop + Android + iOS, hemat waktu & biaya 40-60%
- **Laravel matang** → ekosistem lengkap (auth, queue, scheduler, excel export, file storage)
- **Shared UI Logic** → widget dan screen yang sama dapat dipakai di desktop & mobile dengan layout adaptation
- **Komunitas besar** → mudah troubleshoot, banyak package tersedia

### 2.3 Arsitektur Sistem

```
┌──────────────────────────────────────────────────────────────────┐
│                        CLOUD SERVER                               │
│                                                                   │
│  ┌──────────────────┐  ┌────────────┐  ┌─────────────────────┐  │
│  │   Laravel 11 API  │  │  MySQL 8   │  │    File Storage     │  │
│  │  ┌─────────────┐  │  │            │  │  (S3 / MinIO)       │  │
│  │  │  REST API   │  │  │  Database  │  │  - Foto Rekam Medis │  │
│  │  │  Sanctum    │  │  │  Terpusat  │  │  - Bukti Pengeluaran│  │
│  │  │  WebSocket  │  │  │            │  │  - Galeri & Aset    │  │
│  │  │  (Reverb)   │  │  └────────────┘  └─────────────────────┘  │
│  │  └─────────────┘  │                                            │
│  └────────┬───────────┘                                           │
│           │  REST API + WebSocket                                  │
└───────────┼──────────────────────────────────────────────────────┘
            │
     ┌──────┴──────────────────────────────────────┐
     │           FLUTTER CLIENT APPS                │
     │   (Shared codebase — 1 project Flutter)      │
     │                                              │
  ┌──┴─────────────┐  ┌──────────────────────────┐  │
  │ Flutter Desktop │  │     Flutter Mobile        │  │
  │   (Windows)     │  │   (Android & iOS)         │  │
  │                 │  │                           │  │
  │  👤 Owner        │  │  👤 Owner                  │  │
  │  👔 Manager      │  │  👔 Manager                │  │
  │  💼 Admin/Kasir  │  │  💼 Admin/Kasir            │  │
  │  🩺 Dokter       │  │  🩺 Dokter (rekam medis,  │  │
  │                 │  │     foto langsung kamera) │  │
  └─────────────────┘  └──────────────────────────┘  │
     └──────────────────────────────────────────────┘
```

#### Adaptive Layout Strategy (Flutter):
```
Flutter App
  ├── lib/
  │   ├── core/          ← Business logic, API service, models (shared)
  │   ├── features/      ← Fitur per modul (shared logic)
  │   └── ui/
  │       ├── desktop/   ← Layout khusus desktop (sidebar, panel)
  │       └── mobile/    ← Layout khusus mobile (bottom nav, drawer)
  └── (build target: windows / android / ios)
```

---

## 3. Sistem Peran & Permission (Role-Based Access Control)

### 3.1 Hierarki Peran

```
Owner (Level 4 — Akses Penuh)
  └── Manager (Level 3 — Akses Hampir Penuh)
        └── Admin/Kasir (Level 2 — Operasional Kasir)
        └── Dokter (Level 2 — Medis & Konsultasi)
```

### 3.2 Matriks Permission Detail

| Fitur / Modul | Owner | Manager | Admin (Kasir) | Dokter |
|---------------|:-----:|:-------:|:-------------:|:------:|
| **Dashboard Ringkasan** | ✅ Full | ✅ Full | ✅ Limited | ✅ Limited |
| **Kelola Pengguna (CRUD)** | ✅ | ✅ | ❌ | ❌ |
| **Kelola Cabang** | ✅ | ✅ | ❌ | ❌ |
| **Master Data (Produk, Treatment, Kategori)** | ✅ | ✅ | 👁️ View Only | 👁️ View Only |
| **Manajemen Antrian** | ✅ | ✅ | ✅ Kelola | 👁️ Lihat & Panggil Antrian Sendiri |
| **Konsultasi Pasien** | ✅ | ✅ | ❌ | ✅ Desktop & Mobile |
| **Rekam Medis (+ Upload Foto)** | ✅ | ✅ | ❌ | ✅ CRUD + Foto (Desktop & Mobile) |
| **Penjualan / Kasir (POS)** | ✅ | ✅ | ✅ Utama | ❌ |
| **Cetak Struk** | ✅ | ✅ | ✅ (jika sudah bayar) | ❌ |
| **Pengajuan Pengeluaran** | ✅ Approve | ✅ Approve | ✅ Ajukan | ❌ |
| **Closing Siang & Malam** | ✅ | ✅ | ✅ Eksekusi | ❌ |
| **Saldo & Omset** | ✅ | ✅ | ✅ View | ❌ |
| **Data Follow-Up Customer** | ✅ | ✅ | ✅ | ❌ |
| **Laporan Keuangan** | ✅ Full + Export | ✅ Full + Export | ❌ | ❌ |
| **Rekap Penjualan** | ✅ | ✅ | ✅ Harian | ❌ |
| **Rekap Treatment** | ✅ | ✅ | 👁️ View | ✅ Milik Sendiri |
| **Rekap Pengeluaran** | ✅ | ✅ | 👁️ View | ❌ |
| **Promo & Diskon** | ✅ | ✅ | ❌ | ❌ |
| **Testimoni** | ✅ | ✅ | ❌ | ❌ |
| **Galeri** | ✅ | ✅ | ❌ | ❌ |
| **Pengaturan Aplikasi** | ✅ | ✅ Limited | ❌ | ❌ |
| **Audit Log** | ✅ | ✅ | ❌ | ❌ |

> **📌 Catatan:**
> - **Admin/Kasir** fokus pada: pelayanan kasir, pengajuan pengeluaran, saldo/omset, data follow-up
> - **Manager & Owner** bisa mengakses semua fitur di desktop maupun mobile
> - **Dokter** akses di **Desktop** (konsultasi, rekam medis di meja kerja) **dan Mobile** (foto langsung kamera, fleksibel saat treatment)

#### Tampilan per Platform per Role:

| Role | Desktop (Windows) | Mobile (Android/iOS) |
|------|------------------|---------------------|
| **Owner** | Dashboard full, semua laporan, semua modul | Dashboard ringkas, notifikasi, approval |
| **Manager** | Dashboard full, semua modul, approval | Dashboard ringkas, approval pengeluaran |
| **Admin/Kasir** | POS layar penuh, antrian panel, closing | Antrian monitor, follow-up |
| **Dokter** | Antrian pasien, konsultasi, rekam medis, rekap | Rekam medis + foto kamera, antrian, konsultasi |

---

## 4. Modul & Fitur Detail

### 4.1 🏠 Dashboard

Dashboard disesuaikan per role:

**Owner & Manager:**
- Total customer hari ini / bulan ini
- Total omset hari ini (cash, transfer, QRIS)
- Jumlah dokter aktif
- Jumlah produk aktif
- Saldo terkini
- Grafik penjualan mingguan/bulanan
- Antrian aktif (real-time)
- Notifikasi pending (pengeluaran, closing, dll)

**Admin (Kasir):**
- Antrian aktif hari ini
- Total transaksi hari ini
- Saldo kas di tangan
- Notifikasi closing

**Dokter:**
- Antrian pasien (yang ditugaskan ke dokter tersebut)
- Jadwal konsultasi hari ini
- Rekam medis terbaru

---

### 4.2 📋 Sistem Antrian (Queue Management)

> **⚠️ PENTING: Alur antrian TIDAK langsung masuk ke pembayaran.** Antrian mengikuti flow bertahap sesuai kebutuhan pasien.

#### 4.2.1 Jenis Antrian

| Kode | Jenis Antrian | Alur |
|------|--------------|------|
| **K** | Konsultasi | Daftar → Tunggu → Konsultasi Dokter → Selesai / Lanjut Treatment |
| **T** | Treatment | Daftar → Tunggu → Treatment oleh Dokter/Terapis → Selesai → Pembayaran |
| **P** | Pembelian Produk | Daftar → Langsung ke Kasir → Pembayaran |

#### 4.2.2 Flow Antrian Detail

```
┌──────────┐     ┌────────────┐     ┌──────────────┐     ┌────────────┐     ┌──────────┐
│  DAFTAR  │────▶│  MENUNGGU  │────▶│  DILAYANI    │────▶│  SELESAI   │────▶│ PAYMENT  │
│(Registrasi)    │  (Antrian) │     │ (Konsul/     │     │ (Treatment │     │ (Kasir)  │
│          │     │            │     │  Treatment)  │     │  Done)     │     │          │
└──────────┘     └────────────┘     └──────────────┘     └────────────┘     └──────────┘
                                                                │
                                                    Saldo BELUM tercatat
                                                    sampai status = PAID
```

#### 4.2.3 Status Antrian

| Status | Keterangan | Saldo Tercatat? |
|--------|-----------|:-:|
| `REGISTERED` | Pasien sudah daftar, masuk antrian | ❌ |
| `WAITING` | Menunggu giliran | ❌ |
| `IN_PROGRESS` | Sedang dilayani (konsul/treatment) | ❌ |
| `COMPLETED` | Layanan selesai, menunggu pembayaran | ❌ |
| `PAID` | Sudah bayar | ✅ |
| `CANCELLED` | Dibatalkan | ❌ |

> **🚨 Rule kritis:**
> - Saldo / omset **HANYA tercatat** ketika status = `PAID`
> - Struk **HANYA bisa dicetak** ketika status = `PAID`
> - Treatment yang sedang berjalan **TIDAK boleh** masuk ke perhitungan saldo

#### 4.2.4 Tampilan Antrian

- **Display Monitor** (opsional): Layar TV di ruang tunggu menampilkan nomor antrian
- **Desktop**: Panel antrian real-time di sidebar/dashboard
- **Mobile (Dokter)**: Notifikasi push ketika pasien giliran berikutnya
- **Panggil Antrian**: Tombol "Panggil" dengan notifikasi suara/visual

#### 4.2.5 Informasi pada Kartu Antrian

```
┌─────────────────────────────────┐
│  No. Antrian: K-007             │
│  ─────────────────────────────  │
│  Nama    : Siti Aminah          │
│  Jenis   : Konsultasi           │
│  Dokter  : dr. Rina             │
│  Waktu   : 10:30 WIB            │
│  Status  : 🟡 Menunggu          │
└─────────────────────────────────┘
```

---

### 4.3 💊 Modul Treatment & Konsultasi

#### 4.3.1 Alur Konsultasi

1. Pasien dipanggil dari antrian
2. Dokter membuka profil pasien
3. Dokter mencatat keluhan, diagnosis, dan rekomendasi treatment
4. Dokter bisa menambahkan foto (before condition)
5. Jika perlu treatment → pasien di-assign ke antrian treatment
6. Jika hanya konsultasi → status = COMPLETED → ke kasir

#### 4.3.2 Alur Treatment

1. Pasien dipanggil dari antrian treatment
2. Dokter/terapis melakukan treatment
3. Dokter mengupload foto progress (during/after)
4. Dokter menandai treatment selesai
5. Status berubah ke `COMPLETED`
6. Pasien diarahkan ke kasir untuk pembayaran

#### 4.3.3 Data yang Dicatat

| Field | Tipe | Keterangan |
|-------|------|------------|
| ID Treatment | Auto | Nomor unik |
| Pasien | Reference | Link ke data customer |
| Dokter/Terapis | Reference | Link ke data praktisi |
| Jenis Treatment | Select | Dari master data treatment |
| Tanggal & Waktu | DateTime | Timestamp |
| Keluhan | Text | Input dokter |
| Diagnosis | Text | Input dokter |
| Tindakan | Text | Detail treatment yang dilakukan |
| Produk Digunakan | Multi-select | Produk treatment yang dipakai |
| Foto Before | Image[] | Max 5 foto |
| Foto After | Image[] | Max 5 foto |
| Catatan | Text | Catatan tambahan |
| Status | Enum | In Progress / Completed |

---

### 4.4 🩺 Rekam Medis (Medical Records)

> **📌 Catatan:** Modul ini **khusus diakses oleh Dokter** dan level di atasnya (Manager, Owner). Admin/Kasir **tidak bisa** mengakses rekam medis.

#### 4.4.1 Fitur Rekam Medis

- **Riwayat Kunjungan**: Timeline semua kunjungan pasien
- **Catatan Medis**: Keluhan, diagnosis, alergi, riwayat penyakit
- **Foto Dokumentasi**: Upload foto before/during/after treatment
  - Support kamera langsung dari mobile
  - Galeri foto per kunjungan
  - Zoom & annotasi pada foto
  - Watermark otomatis (tanggal + nama pasien)
- **Riwayat Treatment**: Semua treatment yang pernah dilakukan
- **Riwayat Produk**: Produk yang pernah digunakan/dibeli
- **Rekomendasi**: Catatan rekomendasi dokter untuk kunjungan berikutnya

#### 4.4.2 Struktur Data Rekam Medis

```
Customer
  └── Rekam Medis[]
        ├── Tanggal Kunjungan
        ├── Dokter Penanggung Jawab
        ├── Vital Signs (opsional)
        │     ├── Tekanan Darah
        │     ├── Berat Badan
        │     └── Tinggi Badan
        ├── Keluhan Utama
        ├── Riwayat Alergi
        ├── Diagnosis
        ├── Tindakan
        ├── Foto[]
        │     ├── Jenis (Before/During/After)
        │     ├── File Image
        │     ├── Keterangan
        │     └── Timestamp
        ├── Produk Digunakan[]
        ├── Treatment Dilakukan[]
        ├── Rekomendasi
        └── Catatan Lanjutan
```

---

### 4.5 🛒 Modul POS / Penjualan (Kasir)

#### 4.5.1 Alur Penjualan

```
Customer dari Antrian (COMPLETED)
         │
         ▼
┌─────────────────────┐
│  LAYAR KASIR (POS)  │
│  ┌───────────────┐  │
│  │ + Produk      │  │    ← Tambah item produk
│  │ + Treatment   │  │    ← Tambah item treatment (dari record)
│  └───────────────┘  │
│                     │
│  ┌─────────────────────────────────────┐
│  │ Item        │ Qty │ Harga │ Subtotal│
│  │─────────────┼─────┼───────┼─────────│
│  │ Facial Glow │  1  │ 250k  │  250k   │
│  │ Serum HA    │  2  │  75k  │  150k   │
│  └─────────────────────────────────────┘
│                     │
│  Total     : Rp 400.000                │
│  Diskon    : Rp  40.000 (10%)          │
│  Grand Total: Rp 360.000              │
│                     │
│  Metode Bayar: [Cash] [Transfer] [QRIS]│
│  Bayar     : Rp ________               │
│  Kembalian : Rp ________               │
│                     │
│  [SIMPAN TRANSAKSI]  [CETAK STRUK]     │
└─────────────────────┘
```

#### 4.5.2 Metode Pembayaran

| Metode | Kode | Keterangan |
|--------|------|------------|
| Cash | `CASH` | Uang tunai |
| Transfer Bank | `TRANSFER` | Transfer via bank |
| QRIS | `QRIS` | Scan QRIS |
| Kurir Transfer | `KURIR_TF` | Pembayaran via kurir/COD |
| Split Payment | `SPLIT` | Kombinasi 2+ metode |

#### 4.5.3 Rule Penting

> **🚨 PERHATIAN:**
> - **Struk TIDAK bisa dicetak** jika status pembayaran belum `PAID`
> - Tombol "Cetak Struk" di-disable / hidden jika belum lunas
> - Transaksi bisa disimpan dengan status `UNPAID` (pending) untuk dilanjutkan nanti
> - Split payment harus total = grand total, tidak boleh kurang

#### 4.5.4 Struk / Receipt

Format struk thermal printer (58mm/80mm):

```
========================================
        [NAMA KLINIK]
     [Alamat Klinik Lengkap]
       Telp: 0812-XXXX-XXXX
========================================
No. Transaksi : TRX-20260720-001
Tanggal       : 20/07/2026 14:30
Kasir         : Admin Rina
Customer      : Siti Aminah
Dokter        : dr. Rina
----------------------------------------
Item                  Qty   Harga
----------------------------------------
Facial Glow            1    250.000
Serum HA               2    150.000
----------------------------------------
Subtotal                     400.000
Diskon (10%)                 -40.000
----------------------------------------
TOTAL                        360.000
Bayar (Cash)                 400.000
Kembalian                     40.000
========================================
   Terima kasih atas kunjungan Anda!
        Sampai jumpa kembali
========================================
```

---

### 4.6 💰 Sistem Closing (Siang & Malam)

#### 4.6.1 Konsep Closing

Closing adalah proses rekonsiliasi kas di akhir shift. Ada **2 shift** per hari:

| Shift | Waktu | Closing |
|-------|-------|---------|
| **Siang** | 08:00 - 13:00 | Closing Siang (13:00) |
| **Malam** | 13:00 - 20:00 | Closing Malam (20:00) |

> **📌 Catatan:** Waktu shift bisa di-custom dari pengaturan oleh Owner/Manager.

#### 4.6.2 Data pada Form Closing

```
┌──────────────────────────────────────┐
│          CLOSING SHIFT SIANG         │
│       20 Juli 2026 — 08:00-15:00     │
│──────────────────────────────────────│
│                                      │
│  Jumlah Transaksi  : 15             │
│                                      │
│  ┌────────────┬───────────┬────────┐ │
│  │ Metode     │ Sistem    │ Aktual │ │
│  ├────────────┼───────────┼────────┤ │
│  │ Cash       │ 2.500.000 │ [____] │ │
│  │ Transfer   │ 1.800.000 │ [____] │ │
│  │ QRIS       │   750.000 │ [____] │ │
│  │ Kurir TF   │   300.000 │ [____] │ │
│  ├────────────┼───────────┼────────┤ │
│  │ TOTAL      │ 5.350.000 │ [____] │ │
│  └────────────┴───────────┴────────┘ │
│                                      │
│  Selisih: Rp ______                  │
│  Catatan: [________________________] │
│                                      │
│  [SUBMIT CLOSING]                    │
└──────────────────────────────────────┘
```

#### 4.6.3 Proses Closing

1. Admin/Kasir menginput jumlah uang **aktual** yang ada di kas
2. Sistem menampilkan **selisih** antara data sistem vs aktual
3. Jika ada selisih, wajib isi catatan alasan
4. Closing di-submit → Manager/Owner mendapat notifikasi
5. Manager/Owner review & approve closing
6. Setelah closing, kas di-reset untuk shift berikutnya

#### 4.6.4 Rule Closing

> **⚠️ PERHATIAN:**
> - Closing **wajib dilakukan** sebelum shift berikutnya mulai
> - Jika belum closing, sistem menampilkan **reminder/notifikasi**
> - Semua transaksi pending harus diselesaikan sebelum closing
> - Selisih di atas threshold tertentu (misal Rp 50.000) memerlukan approval Owner

---

### 4.7 📊 Modul Laporan & Rekap

#### 4.7.1 Jenis Laporan

| No | Laporan | Deskripsi | Akses | Export |
|----|---------|-----------|-------|--------|
| 1 | **Laporan Penjualan Harian** | Detail transaksi per hari | Owner, Manager | Excel |
| 2 | **Laporan Penjualan Bulanan** | Ringkasan omset per bulan | Owner, Manager | Excel |
| 3 | **Laporan per Metode Bayar** | Total Cash, Transfer, QRIS, Kurir TF | Owner, Manager | Excel |
| 4 | **Rekap In/Out Produk** | Stok masuk & keluar produk retail | Owner, Manager | Excel |
| 5 | **Rekap In/Out Produk Treatment** | Stok produk yang dipakai treatment | Owner, Manager | Excel |
| 6 | **Rekap Stok Produk** | Stok terkini semua produk | Owner, Manager, Admin | Excel |
| 7 | **Rekap Rekam Medis** | Ringkasan rekam medis | Owner, Manager, Dokter | Excel |
| 8 | **Rekap Treatment** | Semua treatment yang dilakukan | Owner, Manager | Excel |
| 9 | **Rekap Praktisi/Dokter** | Jumlah pasien per dokter, omset per dokter | Owner, Manager | Excel |
| 10 | **Rekap Pengeluaran** | Semua pengeluaran operasional | Owner, Manager | Excel |
| 11 | **Laporan Saldo** | Saldo kas per shift/hari | Owner, Manager, Admin | Excel |
| 12 | **Laporan Omset** | Omset keseluruhan dengan breakdown | Owner, Manager, Admin | Excel |
| 13 | **Laporan Closing** | History closing siang & malam | Owner, Manager | Excel |

#### 4.7.2 Laporan Akhir Bulanan (Prioritas)

> **⭐ PENTING:** Laporan akhir bulan harus menampilkan breakdown per metode pembayaran dan bisa di-export ke Excel.

```
┌──────────────────────────────────────────────────────┐
│        LAPORAN AKHIR BULAN — JULI 2026               │
│──────────────────────────────────────────────────────│
│                                                      │
│  Periode     : 01/07/2026 — 31/07/2026              │
│  Total Transaksi: 487                                │
│                                                      │
│  ┌───────────────┬──────────────┬──────────┐        │
│  │ Metode Bayar  │ Total        │ %        │        │
│  ├───────────────┼──────────────┼──────────┤        │
│  │ Cash          │ 45.250.000   │ 38.2%    │        │
│  │ Transfer Bank │ 35.800.000   │ 30.2%    │        │
│  │ QRIS          │ 25.150.000   │ 21.2%    │        │
│  │ Kurir TF      │ 12.300.000   │ 10.4%    │        │
│  ├───────────────┼──────────────┼──────────┤        │
│  │ GRAND TOTAL   │ 118.500.000  │ 100%     │        │
│  └───────────────┴──────────────┴──────────┘        │
│                                                      │
│  Total Pengeluaran : Rp 22.350.000                  │
│  Laba Kotor        : Rp 96.150.000                  │
│                                                      │
│  [📥 EXPORT EXCEL]  [📄 CETAK PDF]                   │
└──────────────────────────────────────────────────────┘
```

#### 4.7.3 Filter Laporan

Semua laporan harus memiliki filter:
- **Rentang Tanggal**: Date range picker
- **Cabang**: Dropdown (jika multi-cabang)
- **Metode Pembayaran**: Multi-select
- **Dokter/Praktisi**: Dropdown
- **Kategori**: Produk / Treatment
- **Status**: Paid / Unpaid / All

---

### 4.8 💸 Pengajuan Pengeluaran

#### 4.8.1 Alur Pengajuan

```
Admin (Kasir) mengajukan     Manager/Owner            Pencairan
─────────────────────────    review & approve          ──────────
┌──────────┐                 ┌───────────┐             ┌──────────┐
│ DRAFT    │────submit──────▶│ PENDING   │───approve──▶│ APPROVED │
│          │                 │ APPROVAL  │             │          │
└──────────┘                 └─────┬─────┘             └──────────┘
                                   │
                                reject
                                   │
                              ┌────▼─────┐
                              │ REJECTED │
                              └──────────┘
```

#### 4.8.2 Data Pengajuan

| Field | Tipe | Keterangan |
|-------|------|------------|
| No. Pengajuan | Auto | Format: PGL-YYYYMMDD-XXX |
| Tanggal | Date | Tanggal pengajuan |
| Kategori | Select | Operasional / Pembelian Stok / Gaji / Lainnya |
| Deskripsi | Text | Detail pengeluaran |
| Nominal | Currency | Jumlah rupiah |
| Bukti | File | Upload foto/scan bukti |
| Diajukan oleh | Reference | Admin yang mengajukan |
| Status | Enum | Draft / Pending / Approved / Rejected |
| Catatan Approval | Text | Catatan dari Manager/Owner |

---

### 4.9 👥 Modul Data Follow-Up

#### 4.9.1 Tujuan
Melacak customer yang perlu di-follow up untuk kunjungan ulang, pembelian produk, atau treatment lanjutan.

#### 4.9.2 Fitur

- **Auto-reminder**: Sistem otomatis membuat follow-up berdasarkan rekomendasi dokter
- **Manual entry**: Admin bisa menambahkan follow-up manual
- **Status tracking**: Belum Dihubungi → Dihubungi → Berhasil / Tidak Berhasil
- **Riwayat kontak**: Log setiap kali customer di-follow up
- **Notifikasi**: Alert harian untuk daftar follow-up yang jatuh tempo

#### 4.9.3 Data Follow-Up

| Field | Tipe | Keterangan |
|-------|------|------------|
| Customer | Reference | Data customer |
| Jenis Follow-Up | Select | Kunjungan Ulang / Promo / Treatment Lanjutan / Pembelian Produk |
| Tanggal Follow-Up | Date | Kapan harus di-follow up |
| Prioritas | Enum | Tinggi / Sedang / Rendah |
| Catatan | Text | Detail follow-up |
| Status | Enum | Pending / Contacted / Success / Failed |
| Dihubungi oleh | Reference | Staff yang menghubungi |
| Hasil | Text | Hasil follow-up |

---

### 4.10 📦 Manajemen Produk & Stok

#### 4.10.1 Jenis Produk

| Jenis | Keterangan | Stok |
|-------|-----------|------|
| **Produk Retail** | Dijual langsung ke customer | Ada stok |
| **Produk Treatment** | Digunakan saat treatment | Ada stok (pengurangan otomatis) |

#### 4.10.2 Fitur Stok

- **Stok Masuk (In)**: Input pembelian/restok barang
- **Stok Keluar (Out)**: Penjualan / pemakaian treatment / expired / rusak
- **Stok Opname**: Pencocokan stok fisik vs sistem
- **Alert Stok Minimum**: Notifikasi ketika stok di bawah batas minimum
- **History Pergerakan**: Log semua pergerakan stok
- **Multi-cabang**: Stok terpisah per cabang

---

### 4.11 🏢 Manajemen Perusahaan

#### 4.11.1 Profil Perusahaan
- Nama klinik, alamat, telepon, logo
- Informasi yang muncul di struk
- Pengaturan jam operasional
- Pengaturan shift closing

#### 4.11.2 Cabang
- CRUD cabang
- Assign staff ke cabang
- Stok per cabang
- Laporan per cabang

#### 4.11.3 Kelola Pengguna
- CRUD user dengan role assignment
- Aktivasi/deaktivasi akun
- Reset password
- Assign cabang
- Log aktivitas user

---

### 4.12 📢 Modul Promosi

| Fitur | Deskripsi |
|-------|-----------|
| **Promo & Diskon** | Buat promo dengan periode, persentase/nominal, dan target produk/treatment |
| **Testimoni** | Kelola testimoni customer (foto before/after + review) |
| **Galeri** | Showcase foto treatment dan klinik |
| **FAQ** | Frequently asked questions untuk customer |

---

## 5. Desain UI/UX

### 5.1 Prinsip Desain

> **Modern, Simple, Clean** — Mengutamakan kemudahan penggunaan dengan tampilan yang bersih dan profesional.

| Aspek | Guideline |
|-------|-----------|
| **Warna Primer** | Soft pink / rose gold (#E91E63 / #F48FB1) — sesuai industri kecantikan |
| **Warna Sekunder** | Deep purple / navy (#6A1B9A / #1A237E) untuk aksen profesional |
| **Background** | Putih bersih (#FFFFFF) dengan sentuhan light grey (#F5F5F5) |
| **Font** | Inter / Poppins — modern, bersih, mudah dibaca |
| **Icons** | Line icons (Phosphor / Lucide) — clean dan konsisten |
| **Spacing** | Generous whitespace, padding 16-24px |
| **Border Radius** | 8-12px untuk cards, 20px untuk buttons |
| **Shadow** | Subtle box-shadow untuk elevasi |

### 5.2 Layout Desktop

```
┌─────────────────────────────────────────────────────────┐
│  [Logo]  [Search]           [Notif] [User Profile]      │  ← Top Bar
├──────┬──────────────────────────────────────────────────┤
│      │                                                   │
│  S   │            CONTENT AREA                           │
│  I   │                                                   │
│  D   │   ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  E   │   │ Card 1   │  │ Card 2   │  │ Card 3   │      │
│  B   │   └──────────┘  └──────────┘  └──────────┘      │
│  A   │                                                   │
│  R   │   ┌──────────────────────────────────────┐       │
│      │   │         Main Table / Content          │       │
│  N   │   │                                      │       │
│  A   │   │                                      │       │
│  V   │   └──────────────────────────────────────┘       │
│      │                                                   │
├──────┴──────────────────────────────────────────────────┤
│  [Footer / Status Bar]                                   │
└─────────────────────────────────────────────────────────┘
```

### 5.3 Layout Mobile

```
┌─────────────────────┐
│ [☰] Title    [🔔][👤]│  ← App Bar
├─────────────────────┤
│                     │
│    Content Area     │
│                     │
│  ┌───────────────┐  │
│  │   Card View   │  │
│  └───────────────┘  │
│                     │
│  ┌───────────────┐  │
│  │   List Item   │  │
│  │   List Item   │  │
│  │   List Item   │  │
│  └───────────────┘  │
│                     │
├─────────────────────┤
│ [🏠] [📋] [🛒] [👤] │  ← Bottom Navigation
└─────────────────────┘
```

### 5.4 Komponen UI Utama

| Komponen | Deskripsi |
|----------|-----------|
| **Sidebar Navigation** | Collapsible sidebar dengan ikon + label, grouped by kategori |
| **Data Table** | Sortable, searchable, filterable, pagination |
| **Form Modal** | Slide-in panel / modal untuk input data |
| **Toast Notification** | Pop-up notifikasi di kanan atas |
| **Badge Counter** | Counter pada menu/ikon untuk pending items |
| **Status Chip** | Colored badge untuk status (Paid, Pending, dll) |
| **Date Range Picker** | Kalender range untuk filter laporan |
| **Search Autocomplete** | Pencarian customer/produk dengan autocomplete |

---

## 6. Fitur Non-Fungsional

### 6.1 Keamanan

| Aspek | Implementasi |
|-------|-------------|
| **Autentikasi** | JWT Token dengan refresh token |
| **Enkripsi** | HTTPS/TLS untuk semua komunikasi |
| **Session** | Auto-logout setelah idle 30 menit |
| **Password** | Minimal 8 karakter, hash bcrypt |
| **Audit Trail** | Log semua aksi CRUD dengan user, timestamp, dan detail perubahan |
| **Data Medis** | Enkripsi data rekam medis at-rest |

### 6.2 Performance

| Aspek | Target |
|-------|--------|
| **API Response** | < 500ms untuk operasi CRUD standar |
| **Page Load** | < 2 detik untuk halaman dashboard |
| **Concurrent Users** | Support 50+ user simultan |
| **Offline Mode** | Kasir tetap bisa input transaksi saat internet mati (sync saat online) |
| **Search** | < 300ms untuk pencarian customer/produk |

### 6.3 Integrasi

| Integrasi | Keterangan |
|-----------|-----------|
| **Thermal Printer** | ESC/POS via USB (desktop) dan Bluetooth (mobile) |
| **Barcode Scanner** | USB HID (desktop), kamera (mobile) |
| **WhatsApp** | Kirim struk/reminder via WhatsApp API (opsional, fase 2) |
| **Cloud Backup** | Auto backup harian ke cloud storage |

---

## 7. Sitemap & Navigation Structure

### 7.1 Menu Structure (by Role)

```
📱 SEMUA ROLE
├── 🏠 Dashboard
└── 👤 Profil Saya

👨‍💼 OWNER & MANAGER
├── 🏢 PERUSAHAAN
│   ├── Profil Perusahaan
│   ├── Kelola Pengguna
│   ├── Cabang
│   └── Master Data
│       ├── Kategori
│       ├── Produk
│       ├── Treatment
│       ├── Metode Pembayaran
│       └── Supplier
├── 📋 ANTRIAN
│   ├── Monitor Antrian
│   └── Riwayat Antrian
├── 💊 TRANSAKSI
│   ├── In/Out Produk
│   ├── In/Out Produk Treatment
│   ├── Rekam Medis (Read Only)
│   ├── Rekam Treatment
│   ├── Penjualan (POS)
│   ├── Pengeluaran (Approve)
│   └── Closing (Review)
├── 📊 LAPORAN
│   ├── Rekap In/Out Produk
│   ├── Rekap In/Out Produk Treatment
│   ├── Rekap Stok Produk
│   ├── Rekap Stok Produk Treatment
│   ├── Rekap Rekam Medis
│   ├── Rekap Treatment
│   ├── Rekap Penjualan
│   │   ├── Per Hari
│   │   ├── Per Bulan
│   │   └── Per Metode Bayar
│   ├── Rekap Praktisi
│   ├── Rekap Pengeluaran
│   ├── Saldo
│   ├── Omset
│   └── Laporan Closing
├── 📢 PROMOSI
│   ├── Data Follow Up
│   ├── Testimoni
│   ├── Promo
│   ├── Galeri
│   └── FAQ
└── ⚙️ PENGATURAN
    ├── Pengaturan Umum
    ├── Pengaturan Shift
    ├── Pengaturan Struk
    └── Audit Log

🧑‍💻 ADMIN (KASIR)
├── 📋 Antrian (Monitor & Kelola)
├── 🛒 Penjualan (POS) — Fungsi Utama
├── 💸 Pengajuan Pengeluaran
├── 💰 Closing Shift
├── 💵 Saldo & Omset (View)
├── 📊 Rekap Penjualan (Harian)
└── 📞 Data Follow Up

🩺 DOKTER
├── 📋 Antrian Saya
├── 🩺 Konsultasi
├── 💊 Treatment
├── 📝 Rekam Medis (CRUD + Upload Foto)
├── 📊 Rekap Treatment Saya
└── 📊 Rekap Rekam Medis Saya
```

---

## 8. Database Schema (High-Level ERD)

### 8.1 Tabel Utama

| Tabel | Keterangan |
|-------|-----------|
| `users` | Data pengguna (semua role) |
| `roles` | Definisi role (Owner, Manager, Admin, Dokter) |
| `permissions` | Definisi permission per modul |
| `role_permissions` | Relasi many-to-many role dan permission |
| `branches` | Data cabang |
| `branch_users` | Relasi user ke cabang |
| `customers` | Data pelanggan/pasien |
| `categories` | Kategori produk & treatment |
| `products` | Data produk (retail & treatment) |
| `treatments` | Data jenis treatment |
| `queues` | Data antrian pasien |
| `queue_types` | Jenis antrian (Konsultasi, Treatment, Pembelian) |
| `transactions` | Header transaksi penjualan |
| `transaction_items` | Detail item per transaksi |
| `payments` | Detail pembayaran per transaksi |
| `payment_methods` | Master metode pembayaran |
| `medical_records` | Rekam medis pasien |
| `medical_photos` | Foto rekam medis |
| `closings` | Data closing shift |
| `closing_details` | Detail per metode bayar pada closing |
| `expense_requests` | Pengajuan pengeluaran |
| `stock_movements` | Riwayat pergerakan stok |
| `follow_ups` | Data follow-up customer |
| `promos` | Data promo/diskon |
| `testimonials` | Data testimoni customer |
| `galleries` | Data galeri foto |
| `faqs` | Data FAQ |
| `audit_logs` | Log audit trail |
| `notifications` | Notifikasi sistem |
| `company_settings` | Pengaturan perusahaan/klinik |
| `shift_settings` | Pengaturan jam shift |

### 8.2 Relasi Antar Tabel (Ringkasan)

```
users ──┬── branches (many-to-many via branch_users)
        ├── transactions (one-to-many, sebagai kasir)
        ├── medical_records (one-to-many, sebagai dokter)
        ├── closings (one-to-many, yang melakukan closing)
        ├── expense_requests (one-to-many, pengaju & approver)
        └── audit_logs (one-to-many)

customers ──┬── queues (one-to-many)
            ├── transactions (one-to-many)
            ├── medical_records (one-to-many)
            └── follow_ups (one-to-many)

queues ──── transactions (one-to-one, opsional)

transactions ──┬── transaction_items (one-to-many)
               └── payments (one-to-many, support split payment)

medical_records ──── medical_photos (one-to-many)

products ──── stock_movements (one-to-many)

closings ──── closing_details (one-to-many)
```

---

## 9. Fase Pengembangan

### Fase 1 — MVP Core (8-10 Minggu)

| Minggu | Deliverable |
|--------|-------------|
| 1-2 | Setup project, database, auth, role & permission |
| 3-4 | Master data (user, produk, treatment, cabang, customer) |
| 5-6 | Sistem antrian + POS/kasir + pembayaran |
| 7-8 | Closing siang/malam + laporan dasar |
| 9-10 | Testing, bug fixing, deployment staging |

### Fase 2 — Complete Features (6-8 Minggu)

| Minggu | Deliverable |
|--------|-------------|
| 11-12 | Rekam medis + upload foto + konsultasi dokter |
| 13-14 | Pengajuan pengeluaran + follow-up customer |
| 15-16 | Laporan lengkap + export Excel |
| 17-18 | Stok opname + alert stok + multi-cabang |

### Fase 3 — Polish & Advanced (4-6 Minggu)

| Minggu | Deliverable |
|--------|-------------|
| 19-20 | Promo, testimoni, galeri, FAQ |
| 21-22 | Offline mode, WhatsApp integration |
| 23-24 | Performance optimization, security audit, go-live |

---

## 10. Saran & Rekomendasi Tambahan

> ### 💡 Saran dari Developer

### 10.1 Teknis

1. **Gunakan Flutter untuk semua platform** — Satu codebase untuk Android, iOS, dan Windows desktop. Hemat biaya development dan maintenance 40-60%.

2. **Offline-first architecture** — Kasir harus tetap bisa beroperasi saat internet mati. Gunakan local database (Hive/SQLite) dan sync saat online.

3. **Thermal printer universal** — Gunakan library ESC/POS yang support multiple brand (Epson, SUNMI, Bluetooth printer). Test di hardware yang akan digunakan sejak awal.

4. **Backup otomatis** — Implementasi auto-backup harian ke cloud. Data keuangan dan rekam medis tidak boleh hilang.

5. **Progressive Web App (PWA) sebagai alternatif** — Jika budget terbatas, pertimbangkan PWA yang bisa diinstall di desktop dan mobile tanpa perlu publish ke app store.

### 10.2 Bisnis

6. **Training user** — Siapkan video tutorial dan dokumentasi untuk setiap role. Kasir dan dokter biasanya butuh onboarding 1-2 hari.

7. **Fase pilot** — Launch di 1 cabang dulu sebelum rollout ke semua cabang. Kumpulkan feedback dan iterasi.

8. **Data migration** — Jika ada data dari sistem lama, siapkan script migrasi dan validasi data.

9. **SLA & Support** — Tentukan SLA untuk bug fixing (critical: 4 jam, major: 24 jam, minor: 1 minggu).

### 10.3 Fitur Tambahan (Nice to Have)

10. **Loyalty program** — Poin reward untuk customer yang sering datang
11. **Appointment booking** — Booking online via link/QR code
12. **Dashboard analytics** — Grafik tren penjualan, customer retention, top products
13. **Multi-bahasa** — Support Bahasa Indonesia + English
14. **Dark mode** — Opsi dark mode untuk penggunaan malam hari
15. **Biometric login** — Fingerprint/Face ID di mobile untuk login cepat

---

## 11. Open Questions (Perlu Dikonfirmasi ke Klien)

> **⚠️ Beberapa hal berikut perlu dikonfirmasi sebelum development dimulai:**

| No | Pertanyaan | Impact |
|----|-----------|--------|
| 1 | Berapa jumlah cabang yang akan menggunakan sistem ini? | Arsitektur multi-tenant |
| 2 | Printer thermal yang sudah dimiliki merek apa? (USB/Bluetooth?) | Library printer |
| 3 | Apakah perlu integrasi payment gateway (QRIS otomatis) atau manual? | Scope development |
| 4 | Berapa rata-rata transaksi per hari per cabang? | Capacity planning |
| 5 | Apakah data dari sistem lama (ASD Aesthetic Derma) perlu dimigrasikan? | Data migration |
| 6 | Apakah dokter menggunakan tablet atau smartphone saat treatment? | UI optimization |
| 7 | Apakah ada kebutuhan notifikasi WhatsApp ke customer? | Integrasi WA API |
| 8 | Berapa budget infrastruktur bulanan (server, hosting)? | Pilihan hosting |
| 9 | Apakah perlu fitur appointment/booking online untuk customer? | Scope fitur |
| 10 | Jam operasional shift bisa berbeda per cabang? | Logic shift/closing |

---

## 12. Acceptance Criteria Summary

### ✅ Kriteria Utama yang Harus Terpenuhi

- [ ] Sistem antrian berjalan dengan flow: Daftar → Tunggu → Dilayani → Selesai → Bayar
- [ ] Saldo/omset **TIDAK tercatat** sampai customer membayar (status PAID)
- [ ] Struk **TIDAK bisa dicetak** jika belum bayar
- [ ] Closing siang & malam berfungsi dengan rekonsiliasi kas
- [ ] Laporan bulanan menampilkan breakdown per metode bayar (Cash, Transfer, QRIS, Kurir TF)
- [ ] Laporan bisa di-export ke format Excel (.xlsx)
- [ ] Admin/kasir hanya bisa akses fitur kasir, pengeluaran, saldo, omset, dan follow-up
- [ ] Manager & Owner bisa akses semua fitur
- [ ] Dokter bisa CRUD rekam medis termasuk upload foto
- [ ] Aplikasi berjalan di desktop (Windows) dan mobile (Android/iOS)
- [ ] Data tersinkronisasi real-time antara desktop dan mobile
- [ ] 3 jenis antrian: Konsultasi, Treatment, Pembelian
- [ ] Role-based access control berfungsi sesuai matriks permission

---

## 13. FASE 1 — DETAIL TEKNIS LENGKAP
### Setup Project, Database, Autentikasi, Role & Permission

> **Status Fase 1:** 🔵 Siap Dikerjakan  
> **Estimasi:** 8–10 minggu | 50 hari kerja  
> **Stack:** Flutter 3.x + Laravel 11 + MySQL 8

---

### 13.1 Setup Project

#### 13.1.1 Backend — Laravel 11

**Struktur Direktori:**
```
beauty-pos-api/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   │       ├── AuthController.php
│   │   │       ├── UserController.php
│   │   │       └── RoleController.php
│   │   ├── Middleware/
│   │   │   ├── CheckRole.php          ← Validasi role per request
│   │   │   └── CheckPermission.php    ← Validasi permission per endpoint
│   │   └── Requests/                  ← Form Request Validation
│   ├── Models/
│   │   ├── User.php
│   │   ├── Role.php
│   │   ├── Permission.php
│   │   └── Branch.php
│   └── Services/
│       └── AuthService.php
├── database/
│   ├── migrations/
│   └── seeders/
│       ├── RoleSeeder.php
│       ├── PermissionSeeder.php
│       └── AdminUserSeeder.php
├── routes/
│   └── api.php
└── config/
    └── sanctum.php
```

**Packages yang diinstall:**
```bash
composer create-project laravel/laravel beauty-pos-api
composer require laravel/sanctum
composer require spatie/laravel-permission     # RBAC management
composer require maatwebsite/excel             # Export Excel
composer require intervention/image            # Resize/watermark foto
composer require laravel/reverb               # WebSocket server
composer require --dev barryvdh/laravel-ide-helper
```

**Konfigurasi `.env` utama:**
```env
APP_NAME="Beauty POS API"
APP_URL=https://api.yourdomain.com

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=beauty_pos
DB_USERNAME=root
DB_PASSWORD=

SANCTUM_STATEFUL_DOMAINS=localhost,127.0.0.1
SESSION_DRIVER=database

FILESYSTEM_DISK=local
AWS_BUCKET=beauty-pos-files   # jika pakai S3

BROADCAST_CONNECTION=reverb
REVERB_APP_ID=
REVERB_APP_KEY=
REVERB_APP_SECRET=
```

---

#### 13.1.2 Frontend — Flutter App

**Inisialisasi Project:**
```bash
flutter create beauty_pos --platforms=windows,android,ios
cd beauty_pos
```

**Struktur Direktori Flutter:**
```
beauty_pos/
├── lib/
│   ├── main.dart
│   ├── app.dart                   ← MaterialApp + Router config
│   ├── core/
│   │   ├── api/
│   │   │   ├── api_client.dart    ← Dio setup, base URL, interceptor
│   │   │   └── api_endpoints.dart ← Semua URL endpoint konstanta
│   │   ├── auth/
│   │   │   ├── auth_provider.dart ← Riverpod: state login/logout
│   │   │   └── token_storage.dart ← Simpan token (flutter_secure_storage)
│   │   ├── models/
│   │   │   ├── user.dart
│   │   │   ├── role.dart
│   │   │   └── permission.dart
│   │   ├── constants/
│   │   │   └── app_roles.dart     ← Enum roles & permissions
│   │   └── utils/
│   │       └── responsive.dart    ← Helper: isDesktop / isMobile
│   ├── features/
│   │   └── auth/
│   │       ├── login_screen.dart
│   │       ├── auth_repository.dart
│   │       └── auth_service.dart
│   └── ui/
│       ├── desktop/
│       │   ├── shell/
│       │   │   ├── desktop_shell.dart    ← Sidebar + content area
│       │   │   └── sidebar_nav.dart      ← Menu sidebar per role
│       │   └── theme/
│       │       └── desktop_theme.dart
│       └── mobile/
│           ├── shell/
│           │   ├── mobile_shell.dart     ← Bottom nav + drawer
│           │   └── bottom_nav.dart       ← Nav items per role
│           └── theme/
│               └── mobile_theme.dart
├── pubspec.yaml
└── (build target: windows / android / ios)
```

**Dependencies `pubspec.yaml`:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.0          # State management
  dio: ^5.4.0                        # HTTP client
  flutter_secure_storage: ^9.0.0    # Simpan token aman
  go_router: ^13.0.0                 # Navigation + deep linking
  shared_preferences: ^2.2.0        # Setting lokal
  intl: ^0.19.0                      # Format tanggal & currency Rupiah
  google_fonts: ^6.1.0               # Font Poppins / Inter
  flutter_svg: ^2.0.0               # Icon SVG
  image_picker: ^1.0.0              # Kamera & galeri (mobile)
  file_picker: ^6.1.0               # Pilih file (desktop)
  flutter_esc_pos_utils: ^4.0.0     # Thermal printer
  permission_handler: ^11.0.0       # Izin kamera, storage (mobile)
  connectivity_plus: ^5.0.0         # Deteksi koneksi internet
  web_socket_channel: ^2.4.0        # WebSocket untuk real-time
  cached_network_image: ^3.3.0      # Cache gambar
  shimmer: ^3.0.0                   # Loading skeleton effect
  fl_chart: ^0.67.0                 # Chart dashboard (grafik)
  data_table_2: ^2.5.0              # Data table responsif
  hive_flutter: ^1.1.0              # Local DB (offline cache)

dev_dependencies:
  flutter_lints: ^3.0.0
  build_runner: ^2.4.0
  hive_generator: ^2.0.0
  json_serializable: ^6.7.0
```

---

### 13.2 Database Schema

#### 13.2.1 ERD Overview

```
users ────────────────────────── roles
  │  (many-to-many via           │
  │   model_has_roles)           │
  │                              │
  │                        role_has_permissions
  │                              │
  └────────────────────── permissions
  │
  ├── branch_users ──── branches
  ├── personal_access_tokens (Sanctum)
  └── audit_logs
```

#### 13.2.2 Migrasi Database (Urutan Eksekusi)

| Urutan | Nama Migration | Tabel yang Dibuat |
|:------:|---------------|------------------|
| 1 | `create_branches_table` | `branches` |
| 2 | `create_users_table` | `users` |
| 3 | `create_permissions_tables` | `permissions`, `roles`, `model_has_roles`, `model_has_permissions`, `role_has_permissions` |
| 4 | `create_branch_users_table` | `branch_users` |
| 5 | `create_personal_access_tokens_table` | `personal_access_tokens` |
| 6 | `create_audit_logs_table` | `audit_logs` |

#### 13.2.3 Skema Tabel Detail

**Tabel: `branches`**
```sql
CREATE TABLE branches (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,            -- Nama cabang
    address     TEXT,                             -- Alamat lengkap
    phone       VARCHAR(20),
    email       VARCHAR(100),
    is_active   TINYINT(1) DEFAULT 1,
    created_at  TIMESTAMP NULL,
    updated_at  TIMESTAMP NULL,
    deleted_at  TIMESTAMP NULL                    -- Soft delete
);
```

**Tabel: `users`**
```sql
CREATE TABLE users (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    branch_id       BIGINT UNSIGNED,              -- Cabang utama (nullable untuk owner)
    name            VARCHAR(100) NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL,
    phone           VARCHAR(20),
    password        VARCHAR(255) NOT NULL,         -- bcrypt hash
    avatar          VARCHAR(255),                 -- Path foto profil
    is_active       TINYINT(1) DEFAULT 1,
    last_login_at   TIMESTAMP NULL,
    last_login_ip   VARCHAR(45),
    created_by      BIGINT UNSIGNED,              -- User yang membuat akun ini
    created_at      TIMESTAMP NULL,
    updated_at      TIMESTAMP NULL,
    deleted_at      TIMESTAMP NULL,

    FOREIGN KEY (branch_id) REFERENCES branches(id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);
```

**Tabel: `branch_users`** *(user bisa di-assign ke multiple cabang)*
```sql
CREATE TABLE branch_users (
    id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT UNSIGNED NOT NULL,
    branch_id   BIGINT UNSIGNED NOT NULL,
    is_primary  TINYINT(1) DEFAULT 0,             -- Cabang utama
    created_at  TIMESTAMP NULL,
    updated_at  TIMESTAMP NULL,

    UNIQUE KEY unique_user_branch (user_id, branch_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (branch_id) REFERENCES branches(id) ON DELETE CASCADE
);
```

**Tabel: `audit_logs`**
```sql
CREATE TABLE audit_logs (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED,
    branch_id       BIGINT UNSIGNED,
    action          VARCHAR(50) NOT NULL,          -- CREATE, UPDATE, DELETE, LOGIN, LOGOUT
    module          VARCHAR(50) NOT NULL,           -- users, transactions, medical_records, dll
    target_id       BIGINT UNSIGNED,               -- ID record yang diubah
    old_values      JSON,                          -- Data sebelum perubahan
    new_values      JSON,                          -- Data setelah perubahan
    ip_address      VARCHAR(45),
    user_agent      TEXT,
    created_at      TIMESTAMP NULL,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_action (user_id, action),
    INDEX idx_module (module),
    INDEX idx_created_at (created_at)
);
```

---

### 13.3 Autentikasi (Laravel Sanctum)

#### 13.3.1 Endpoint Auth

| Method | Endpoint | Akses | Deskripsi |
|--------|----------|-------|-----------|
| `POST` | `/api/v1/auth/login` | Public | Login dengan email & password |
| `POST` | `/api/v1/auth/logout` | Auth | Logout (revoke current token) |
| `GET` | `/api/v1/auth/me` | Auth | Data user yang sedang login |
| `POST` | `/api/v1/auth/refresh` | Auth | Refresh token |
| `POST` | `/api/v1/auth/change-password` | Auth | Ganti password |

#### 13.3.2 Login Flow

```
Flutter (Login Screen)
        │
        │  POST /api/v1/auth/login
        │  { email, password, device_name }
        │
        ▼
Laravel AuthController
        │
        ├── Validasi email & password
        ├── Cek user is_active = 1
        ├── Verifikasi bcrypt password
        ├── Catat last_login_at & last_login_ip
        ├── Buat Sanctum token (nama: device_name)
        ├── Load roles & permissions user
        ├── Catat audit_log: action=LOGIN
        │
        ▼
Response: {
    token: "1|xxxxxxxxxxx",
    user: {
        id, name, email, phone, avatar,
        branch_id, branch_name,
        roles: ["dokter"],
        permissions: ["konsultasi.view", "rekam_medis.create", ...]
    }
}
        │
        ▼
Flutter (AuthProvider)
        │
        ├── Simpan token ke flutter_secure_storage
        ├── Simpan user + permissions ke Riverpod state
        ├── Set default header: Authorization: Bearer {token}
        └── Navigate ke Shell (desktop atau mobile) sesuai platform
            dengan menu yang difilter berdasarkan permissions
```

#### 13.3.3 Token Management di Flutter

```dart
// core/auth/token_storage.dart
class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
```

```dart
// core/api/api_client.dart — Dio Interceptor
class ApiClient {
  static Dio create() {
    final dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl, // https://api.domain.com/api/v1
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ));

    // Token Injector
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await TokenStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      // 401 → auto redirect ke login
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await TokenStorage.clearAll();
          // Navigate ke login screen
          AppRouter.goToLogin();
        }
        handler.next(error);
      },
    ));

    return dio;
  }
}
```

---

### 13.4 Role & Permission

#### 13.4.1 Definisi Role (Seeder)

| Role Slug | Nama | Level | Deskripsi |
|-----------|------|:-----:|-----------|
| `owner` | Owner | 4 | Akses penuh ke semua fitur & cabang |
| `manager` | Manager | 3 | Akses hampir penuh, manage operasional |
| `admin` | Admin (Kasir) | 2 | Operasional kasir, POS, closing |
| `dokter` | Dokter | 2 | Medis — konsultasi, rekam medis, treatment |

#### 13.4.2 Daftar Permission Lengkap

Permission menggunakan format: `{module}.{action}`

| Modul | Permission | Owner | Manager | Admin | Dokter |
|-------|-----------|:-----:|:-------:|:-----:|:------:|
| **Auth** | `auth.login` | ✅ | ✅ | ✅ | ✅ |
| | `auth.change_password` | ✅ | ✅ | ✅ | ✅ |
| **Dashboard** | `dashboard.view` | ✅ | ✅ | ✅ | ✅ |
| | `dashboard.view_financial` | ✅ | ✅ | ❌ | ❌ |
| **Users** | `users.view` | ✅ | ✅ | ❌ | ❌ |
| | `users.create` | ✅ | ✅ | ❌ | ❌ |
| | `users.edit` | ✅ | ✅ | ❌ | ❌ |
| | `users.delete` | ✅ | ❌ | ❌ | ❌ |
| **Branches** | `branches.view` | ✅ | ✅ | ❌ | ❌ |
| | `branches.create` | ✅ | ❌ | ❌ | ❌ |
| | `branches.edit` | ✅ | ✅ | ❌ | ❌ |
| | `branches.delete` | ✅ | ❌ | ❌ | ❌ |
| **Master Data** | `master_data.view` | ✅ | ✅ | ✅ | ✅ |
| | `master_data.create` | ✅ | ✅ | ❌ | ❌ |
| | `master_data.edit` | ✅ | ✅ | ❌ | ❌ |
| | `master_data.delete` | ✅ | ✅ | ❌ | ❌ |
| **Customers** | `customers.view` | ✅ | ✅ | ✅ | ✅ |
| | `customers.create` | ✅ | ✅ | ✅ | ❌ |
| | `customers.edit` | ✅ | ✅ | ✅ | ❌ |
| **Antrian** | `queues.view` | ✅ | ✅ | ✅ | ✅ |
| | `queues.create` | ✅ | ✅ | ✅ | ❌ |
| | `queues.call` | ✅ | ✅ | ✅ | ✅ (milik sendiri) |
| | `queues.manage` | ✅ | ✅ | ✅ | ❌ |
| **POS/Sales** | `sales.view` | ✅ | ✅ | ✅ | ❌ |
| | `sales.create` | ✅ | ✅ | ✅ | ❌ |
| | `sales.print_receipt` | ✅ | ✅ | ✅ | ❌ |
| **Rekam Medis** | `medical_records.view` | ✅ | ✅ | ❌ | ✅ |
| | `medical_records.create` | ✅ | ✅ | ❌ | ✅ |
| | `medical_records.edit` | ✅ | ✅ | ❌ | ✅ (milik sendiri) |
| | `medical_records.upload_photo` | ✅ | ✅ | ❌ | ✅ |
| **Treatment** | `treatments.view` | ✅ | ✅ | 👁️ | ✅ |
| | `treatments.manage` | ✅ | ✅ | ❌ | ✅ |
| **Konsultasi** | `consultations.view` | ✅ | ✅ | ❌ | ✅ |
| | `consultations.create` | ✅ | ✅ | ❌ | ✅ |
| **Pengeluaran** | `expenses.view` | ✅ | ✅ | ✅ | ❌ |
| | `expenses.create` | ✅ | ✅ | ✅ | ❌ |
| | `expenses.approve` | ✅ | ✅ | ❌ | ❌ |
| **Closing** | `closing.view` | ✅ | ✅ | ✅ | ❌ |
| | `closing.execute` | ✅ | ✅ | ✅ | ❌ |
| | `closing.approve` | ✅ | ✅ | ❌ | ❌ |
| **Laporan** | `reports.view` | ✅ | ✅ | 👁️ Harian | ❌ |
| | `reports.export` | ✅ | ✅ | ❌ | ❌ |
| **Saldo/Omset** | `saldo.view` | ✅ | ✅ | ✅ | ❌ |
| **Follow-Up** | `followup.view` | ✅ | ✅ | ✅ | ❌ |
| | `followup.manage` | ✅ | ✅ | ✅ | ❌ |
| **Audit Log** | `audit_logs.view` | ✅ | ✅ | ❌ | ❌ |
| **Settings** | `settings.view` | ✅ | ✅ | ❌ | ❌ |
| | `settings.edit` | ✅ | ❌ | ❌ | ❌ |

#### 13.4.3 Implementasi Laravel (Spatie Permission)

**RoleSeeder.php:**
```php
<?php
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

class RolePermissionSeeder extends Seeder
{
    public function run(): void
    {
        app()[\Spatie\Permission\PermissionRegistrar::class]->forgetCachedPermissions();

        // Buat semua permissions
        $permissions = [
            // Auth
            'auth.login', 'auth.change_password',
            // Dashboard
            'dashboard.view', 'dashboard.view_financial',
            // Users
            'users.view', 'users.create', 'users.edit', 'users.delete',
            // Branches
            'branches.view', 'branches.create', 'branches.edit', 'branches.delete',
            // Master Data
            'master_data.view', 'master_data.create', 'master_data.edit', 'master_data.delete',
            // Customers
            'customers.view', 'customers.create', 'customers.edit',
            // Queues
            'queues.view', 'queues.create', 'queues.call', 'queues.manage',
            // Sales/POS
            'sales.view', 'sales.create', 'sales.print_receipt',
            // Medical Records
            'medical_records.view', 'medical_records.create',
            'medical_records.edit', 'medical_records.upload_photo',
            // Treatments
            'treatments.view', 'treatments.manage',
            // Consultations
            'consultations.view', 'consultations.create',
            // Expenses
            'expenses.view', 'expenses.create', 'expenses.approve',
            // Closing
            'closing.view', 'closing.execute', 'closing.approve',
            // Reports
            'reports.view', 'reports.export',
            // Saldo
            'saldo.view',
            // Follow-up
            'followup.view', 'followup.manage',
            // Audit & Settings
            'audit_logs.view', 'settings.view', 'settings.edit',
        ];

        foreach ($permissions as $perm) {
            Permission::firstOrCreate(['name' => $perm, 'guard_name' => 'sanctum']);
        }

        // Buat roles
        $owner   = Role::firstOrCreate(['name' => 'owner',   'guard_name' => 'sanctum']);
        $manager = Role::firstOrCreate(['name' => 'manager', 'guard_name' => 'sanctum']);
        $admin   = Role::firstOrCreate(['name' => 'admin',   'guard_name' => 'sanctum']);
        $dokter  = Role::firstOrCreate(['name' => 'dokter',  'guard_name' => 'sanctum']);

        // Owner: semua permission
        $owner->syncPermissions(Permission::all());

        // Manager: semua kecuali delete users, delete branches, settings.edit
        $manager->syncPermissions(
            Permission::whereNotIn('name', [
                'users.delete', 'branches.delete', 'branches.create', 'settings.edit'
            ])->get()
        );

        // Admin/Kasir: operasional kasir saja
        $admin->syncPermissions([
            'auth.login', 'auth.change_password',
            'dashboard.view',
            'master_data.view', 'customers.view', 'customers.create', 'customers.edit',
            'queues.view', 'queues.create', 'queues.call', 'queues.manage',
            'sales.view', 'sales.create', 'sales.print_receipt',
            'expenses.view', 'expenses.create',
            'closing.view', 'closing.execute',
            'reports.view',   // harian saja
            'saldo.view',
            'followup.view', 'followup.manage',
        ]);

        // Dokter: medis saja
        $dokter->syncPermissions([
            'auth.login', 'auth.change_password',
            'dashboard.view',
            'master_data.view',
            'customers.view',
            'queues.view', 'queues.call',
            'medical_records.view', 'medical_records.create',
            'medical_records.edit', 'medical_records.upload_photo',
            'treatments.view', 'treatments.manage',
            'consultations.view', 'consultations.create',
        ]);
    }
}
```

#### 13.4.4 Middleware Authorization Laravel

```php
// app/Http/Middleware/CheckPermission.php
class CheckPermission
{
    public function handle(Request $request, Closure $next, string $permission): Response
    {
        if (!$request->user()->hasPermissionTo($permission, 'sanctum')) {
            return response()->json([
                'message' => 'Anda tidak memiliki izin untuk akses ini.',
                'error'   => 'FORBIDDEN',
            ], 403);
        }
        return $next($request);
    }
}

// routes/api.php — contoh penggunaan
Route::middleware(['auth:sanctum'])->prefix('v1')->group(function () {

    // Auth
    Route::post('/auth/logout',          [AuthController::class, 'logout']);
    Route::get('/auth/me',               [AuthController::class, 'me']);
    Route::post('/auth/change-password', [AuthController::class, 'changePassword']);

    // Users — hanya owner & manager
    Route::middleware('permission:users.view')->group(function () {
        Route::get('/users',          [UserController::class, 'index']);
        Route::get('/users/{id}',     [UserController::class, 'show']);
    });
    Route::middleware('permission:users.create')->post('/users',       [UserController::class, 'store']);
    Route::middleware('permission:users.edit')->put('/users/{id}',     [UserController::class, 'update']);
    Route::middleware('permission:users.delete')->delete('/users/{id}',[UserController::class, 'destroy']);

    // Medical Records — owner, manager, dokter
    Route::middleware('permission:medical_records.view')->group(function () {
        Route::get('/medical-records',       [MedicalRecordController::class, 'index']);
        Route::get('/medical-records/{id}',  [MedicalRecordController::class, 'show']);
    });
    Route::middleware('permission:medical_records.create')
         ->post('/medical-records',          [MedicalRecordController::class, 'store']);
    Route::middleware('permission:medical_records.upload_photo')
         ->post('/medical-records/{id}/photos', [MedicalRecordController::class, 'uploadPhoto']);
});
```

#### 13.4.5 Permission Check di Flutter

```dart
// core/constants/app_roles.dart
class AppPermissions {
  static const String dashboardView        = 'dashboard.view';
  static const String dashboardViewFinancial = 'dashboard.view_financial';
  static const String usersView            = 'users.view';
  static const String salesCreate          = 'sales.create';
  static const String medicalRecordsCreate = 'medical_records.create';
  static const String medicalRecordsUploadPhoto = 'medical_records.upload_photo';
  static const String closingExecute       = 'closing.execute';
  static const String reportsExport        = 'reports.export';
  // ... dan seterusnya
}

// core/auth/auth_provider.dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(apiClientProvider));
});

class AuthState {
  final User? user;
  final List<String> permissions;  // ['sales.create', 'closing.execute', ...]
  final bool isAuthenticated;

  bool hasPermission(String permission) => permissions.contains(permission);
  bool hasRole(String role) => user?.roles.contains(role) ?? false;
}

// Contoh penggunaan di Widget:
Consumer(builder: (context, ref, _) {
  final auth = ref.watch(authProvider);
  if (!auth.hasPermission(AppPermissions.reportsExport)) {
    return const SizedBox.shrink(); // Sembunyikan tombol Export
  }
  return ElevatedButton(
    onPressed: () => exportExcel(),
    child: const Text('Export Excel'),
  );
})
```

---

### 13.5 Adaptive Layout (Desktop vs Mobile)

```dart
// core/utils/responsive.dart
class Responsive {
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 1024;
}

// app.dart — Router berdasarkan platform
Widget build(BuildContext context) {
  return MaterialApp.router(
    routerConfig: AppRouter.router,
    builder: (context, child) {
      // Wrap dengan platform-aware shell
      if (Responsive.isDesktop(context)) {
        return DesktopShell(child: child!);
      } else {
        return MobileShell(child: child!);
      }
    },
  );
}
```

**Desktop Shell (sidebar navigation):**
```
┌─────────────────────────────────────────────────────────────┐
│  [Logo Klinik]   [Search...]           [🔔 2] [👤 Nama Role]│
├────────────┬────────────────────────────────────────────────┤
│ 🏠 Dashboard│                                                │
│ 📋 Antrian  │          CONTENT AREA                         │
│ 🛒 POS      │   (Berubah sesuai menu yang dipilih)          │
│ 💸 Pengelua.│                                                │
│ 💰 Closing  │                                                │
│ 📊 Laporan  │                                                │
│ 📞 Follow-up│                                                │
│─────────────│                                                │
│ ⚙️ Setting  │                                                │
│ 🚪 Logout   │                                                │
└────────────┴────────────────────────────────────────────────┘
  (Menu = filtered by permissions dari AuthState)
```

**Mobile Shell (bottom navigation + drawer):**
```
┌─────────────────────┐
│ [☰] Klinik   [🔔][👤]│
├─────────────────────┤
│                     │
│   CONTENT AREA      │
│                     │
├─────────────────────┤
│ [🏠] [📋] [+] [📊][👤]│
└─────────────────────┘
  (Bottom nav = 4-5 item terpenting per role)
  (Selebihnya di Drawer)
```

---

### 13.6 Checklist Penyelesaian Fase 1

#### Backend (Laravel):
- [ ] Setup project Laravel 11 + konfigurasi `.env`
- [ ] Install packages (Sanctum, Spatie Permission, Reverb)
- [ ] Buat migrasi: `branches`, `users`, `branch_users`, `audit_logs`
- [ ] Buat model dengan relasi Eloquent (User, Role, Permission, Branch)
- [ ] Buat `RolePermissionSeeder` dengan 4 role + semua permission
- [ ] Buat `AdminUserSeeder` (akun owner awal)
- [ ] Implement `AuthController` (login, logout, me, change-password)
- [ ] Implement `CheckPermission` middleware
- [ ] Konfigurasi route `api.php` dengan middleware permission
- [ ] Setup `AuditLog` observer di setiap model
- [ ] Setup Laravel Reverb (WebSocket channel auth)
- [ ] Unit test auth flow (login berhasil, token invalid, forbidden)
- [ ] Postman collection / API documentation

#### Flutter (Desktop + Mobile):
- [ ] Inisialisasi project Flutter dengan target: windows, android, ios
- [ ] Setup struktur direktori `core/`, `features/`, `ui/desktop/`, `ui/mobile/`
- [ ] Konfigurasi Dio (`ApiClient`) dengan base URL + interceptor
- [ ] Implement `TokenStorage` dengan `flutter_secure_storage`
- [ ] Implement `AuthProvider` (Riverpod) dengan state: user + permissions
- [ ] Buat `LoginScreen` (shared desktop & mobile)
- [ ] Buat `DesktopShell` dengan collapsible sidebar + permission filter menu
- [ ] Buat `MobileShell` dengan bottom navigation + drawer + permission filter
- [ ] Implement `Responsive` helper untuk adaptive layout
- [ ] Buat halaman profil & ganti password
- [ ] Implement auto-logout saat token expired (401 interceptor)
- [ ] Test build Windows `.exe`
- [ ] Test build Android `.apk`

---

---

> **Dokumen ini akan di-update sesuai feedback dan konfirmasi dari klien.**  
> **Stack Terkonfirmasi: Flutter (Desktop + Mobile) + Laravel 11 API + MySQL**  
> **Fase 1 siap dikerjakan. Fase selanjutnya akan didokumentasikan setelah Fase 1 selesai.**

---

### 13.7 Checklist Penyelesaian Fase 2

> **Durasi Estimasi:** 6–8 Minggu (Minggu 11–18)  
> **Fokus:** Master Data, Antrian, POS/Kasir, Closing, Rekam Medis, Pengeluaran, Follow-Up, Laporan

---

#### 🗄️ Backend — Master Data (Minggu 11–12)

**Migrasi & Model:**
- [ ] Migrasi tabel `customers` (nama, HP, email, tanggal lahir, jenis kelamin, alamat, foto)
- [ ] Migrasi tabel `categories` (untuk produk & treatment)
- [ ] Migrasi tabel `products` (nama, kategori, harga_jual, harga_beli, stok, jenis: retail/treatment, stok_minimum)
- [ ] Migrasi tabel `treatments` (nama, kategori, durasi, harga, deskripsi)
- [ ] Migrasi tabel `payment_methods` (cash, transfer, QRIS, kurir_tf)
- [ ] Migrasi tabel `company_settings` (nama klinik, alamat, telp, logo, struk config)
- [ ] Migrasi tabel `shift_settings` (waktu mulai/selesai shift siang & malam)
- [ ] Migrasi tabel `stock_movements` (produk, jumlah, tipe: in/out, keterangan, user)
- [ ] Buat model + relasi Eloquent untuk semua tabel di atas

**API Endpoints Master Data:**
- [ ] `GET/POST/PUT/DELETE /api/v1/customers` — CRUD customer
- [ ] `GET /api/v1/customers/{id}` — Detail customer + riwayat transaksi
- [ ] `GET/POST/PUT/DELETE /api/v1/categories` — CRUD kategori
- [ ] `GET/POST/PUT/DELETE /api/v1/products` — CRUD produk (+ filter jenis)
- [ ] `GET/POST/PUT/DELETE /api/v1/treatments` — CRUD treatment
- [ ] `GET/POST/PUT/DELETE /api/v1/payment-methods` — CRUD metode bayar
- [ ] `GET/PUT /api/v1/company-settings` — Baca & update pengaturan perusahaan
- [ ] `GET/PUT /api/v1/shift-settings` — Baca & update pengaturan shift
- [ ] `POST /api/v1/stock-movements` — Input stok masuk/keluar
- [ ] `GET /api/v1/stock-movements` — Riwayat pergerakan stok (filter: produk, tipe, tanggal)

---

#### 🏥 Backend — Antrian (Minggu 12)

- [ ] Migrasi tabel `queues` (customer, jenis: K/T/P, dokter, status, nomor_antrian, branch)
- [ ] Migrasi tabel `queue_types` (Konsultasi, Treatment, Pembelian)
- [ ] `GET/POST /api/v1/queues` — Daftar & tambah antrian
- [ ] `PUT /api/v1/queues/{id}/status` — Update status (WAITING → IN_PROGRESS → COMPLETED)
- [ ] `POST /api/v1/queues/{id}/call` — Panggil antrian (trigger WebSocket event)
- [ ] `GET /api/v1/queues/active` — Antrian aktif hari ini (realtime via Reverb)
- [ ] `GET /api/v1/queues/history` — Riwayat antrian (filter: tanggal, status, dokter)
- [ ] Laravel Reverb event `QueueCalled` → broadcast ke semua client
- [ ] Seeder antrian dummy untuk testing

---

#### 🛒 Backend — POS / Transaksi (Minggu 12–13)

- [ ] Migrasi tabel `transactions` (customer, kasir, subtotal, diskon, total, status: UNPAID/PAID, queue_id)
- [ ] Migrasi tabel `transaction_items` (transaksi, produk/treatment, qty, harga_satuan, subtotal)
- [ ] Migrasi tabel `payments` (transaksi, metode, jumlah — support split payment)
- [ ] `POST /api/v1/transactions` — Buat transaksi baru (draft)
- [ ] `GET /api/v1/transactions` — List transaksi (filter: tanggal, status, kasir)
- [ ] `GET /api/v1/transactions/{id}` — Detail transaksi
- [ ] `PUT /api/v1/transactions/{id}/pay` — Proses pembayaran → status PAID
- [ ] `GET /api/v1/transactions/{id}/receipt` — Data struk untuk print
- [ ] Validasi: struk hanya bisa diakses jika status = PAID
- [ ] Rule: saldo/omset hanya tercatat saat status = PAID

---

#### 💰 Backend — Closing Shift (Minggu 13)

- [ ] Migrasi tabel `closings` (shift: siang/malam, tanggal, user, status: pending/approved)
- [ ] Migrasi tabel `closing_details` (closing_id, metode_bayar, nominal_sistem, nominal_aktual, selisih)
- [ ] `POST /api/v1/closings` — Submit closing (dengan detail per metode bayar)
- [ ] `GET /api/v1/closings` — List closing (filter: tanggal, shift, status)
- [ ] `GET /api/v1/closings/{id}` — Detail closing
- [ ] `PUT /api/v1/closings/{id}/approve` — Owner/Manager approve closing
- [ ] `GET /api/v1/closings/summary` — Ringkasan saldo sistem per shift hari ini
- [ ] Validasi: closing tidak bisa dilakukan jika ada transaksi UNPAID pada shift tersebut

---

#### 🩺 Backend — Rekam Medis & Konsultasi (Minggu 11–12)

- [ ] Migrasi tabel `medical_records` (customer, dokter, tanggal, keluhan, diagnosis, tindakan, catatan, vital_signs)
- [ ] Migrasi tabel `medical_photos` (medical_record_id, file_path, jenis: before/during/after, keterangan)
- [ ] `GET/POST /api/v1/medical-records` — CRUD rekam medis
- [ ] `GET /api/v1/medical-records/{id}` — Detail rekam medis + foto
- [ ] `POST /api/v1/medical-records/{id}/photos` — Upload foto (max 5, validasi ukuran & tipe)
- [ ] `DELETE /api/v1/medical-records/{id}/photos/{photoId}` — Hapus foto
- [ ] Middleware: hanya Dokter, Manager, Owner yang bisa akses
- [ ] Laravel Storage config untuk file foto (local atau S3)
- [ ] Watermark otomatis pada foto (tanggal + nama pasien) — opsional fase ini

---

#### 💸 Backend — Pengajuan Pengeluaran (Minggu 13–14)

- [ ] Migrasi tabel `expense_requests` (nomor, tanggal, kategori, deskripsi, nominal, bukti_file, pengaju_id, approver_id, status)
- [ ] `GET/POST /api/v1/expenses` — List & tambah pengajuan
- [ ] `GET /api/v1/expenses/{id}` — Detail pengajuan
- [ ] `POST /api/v1/expenses/{id}/approve` — Owner/Manager approve
- [ ] `POST /api/v1/expenses/{id}/reject` — Owner/Manager reject + catatan
- [ ] `POST /api/v1/expenses/{id}/upload-bukti` — Upload foto bukti pengeluaran
- [ ] Notifikasi ke Manager/Owner saat ada pengajuan baru (via Reverb)

---

#### 📞 Backend — Follow-Up Customer (Minggu 14)

- [ ] Migrasi tabel `follow_ups` (customer, jenis, tanggal_followup, prioritas, catatan, status, staff_id, hasil)
- [ ] `GET/POST /api/v1/follow-ups` — CRUD follow-up
- [ ] `PUT /api/v1/follow-ups/{id}/contact` — Update status + hasil kontak
- [ ] `GET /api/v1/follow-ups/today` — Follow-up yang jatuh tempo hari ini
- [ ] Auto-create follow-up dari rekomendasi dokter di rekam medis (trigger/observer)

---

#### 📊 Backend — Laporan & Export (Minggu 15–16)

- [ ] `GET /api/v1/reports/sales/daily` — Penjualan harian (filter: tanggal, cabang)
- [ ] `GET /api/v1/reports/sales/monthly` — Penjualan bulanan (filter: bulan, tahun)
- [ ] `GET /api/v1/reports/sales/by-payment` — Breakdown per metode bayar
- [ ] `GET /api/v1/reports/stock/movements` — Rekap in/out produk
- [ ] `GET /api/v1/reports/stock/current` — Stok terkini semua produk
- [ ] `GET /api/v1/reports/medical-records` — Rekap rekam medis
- [ ] `GET /api/v1/reports/treatments` — Rekap treatment
- [ ] `GET /api/v1/reports/practitioners` — Rekap per dokter/praktisi
- [ ] `GET /api/v1/reports/expenses` — Rekap pengeluaran
- [ ] `GET /api/v1/reports/balance` — Laporan saldo per shift/hari
- [ ] `GET /api/v1/reports/revenue` — Laporan omset dengan breakdown
- [ ] `GET /api/v1/reports/closings` — History closing siang & malam
- [ ] Install & konfigurasi `maatwebsite/excel` (Laravel Excel)
- [ ] `GET /api/v1/reports/export/{type}` — Export semua laporan ke `.xlsx`

---

#### 📦 Backend — Stok Opname (Minggu 17–18)

- [ ] `POST /api/v1/stock/opname` — Mulai stok opname (lock stok)
- [ ] `PUT /api/v1/stock/opname/{id}` — Input stok fisik per produk
- [ ] `POST /api/v1/stock/opname/{id}/finish` — Selesaikan opname & rekonsiliasi
- [ ] `GET /api/v1/products/low-stock` — Produk dengan stok di bawah minimum
- [ ] Alert stok minimum: notifikasi via Reverb ke Owner/Manager

---

#### 📱 Flutter — Master Data UI (Minggu 11–12)

**Customer:**
- [ ] Layar daftar customer (search, filter, pagination)
- [ ] Form tambah/edit customer (nama, HP, email, tgl lahir, jenis kelamin, alamat, foto)
- [ ] Layar detail customer (info + riwayat transaksi + riwayat kunjungan)

**Produk & Treatment:**
- [ ] Layar daftar produk (filter: jenis, kategori, stok)
- [ ] Form tambah/edit produk (termasuk stok minimum & harga)
- [ ] Layar daftar treatment
- [ ] Form tambah/edit treatment
- [ ] Layar kategori (CRUD)

**Stok:**
- [ ] Layar riwayat pergerakan stok
- [ ] Form input stok masuk/keluar
- [ ] Badge alert stok minimum di sidebar/menu

---

#### 📋 Flutter — Antrian UI (Minggu 12)

- [ ] Layar monitor antrian real-time (kartu antrian per status)
- [ ] Form daftar antrian baru (pilih customer, jenis, dokter)
- [ ] Tombol "Panggil" antrian → broadcast WebSocket
- [ ] Update status antrian (swipe/button: Panggil → Dilayani → Selesai)
- [ ] Badge counter antrian aktif di sidebar/bottom nav
- [ ] Mobile (Dokter): notifikasi push saat dipanggil

---

#### 🛒 Flutter — POS / Kasir UI (Minggu 12–13)

- [ ] Layar kasir fullscreen (desktop): panel produk kiri + keranjang kanan
- [ ] Mobile kasir: tab produk & keranjang
- [ ] Search & pilih produk/treatment ke keranjang
- [ ] Edit qty, hapus item dari keranjang
- [ ] Input diskon (persentase / nominal)
- [ ] Pilih metode bayar (Cash / Transfer / QRIS / Kurir TF / Split)
- [ ] Kalkulasi kembalian otomatis
- [ ] Split payment: input nominal per metode
- [ ] Simpan transaksi → status UNPAID
- [ ] Proses bayar → status PAID
- [ ] Tombol cetak struk (hanya aktif jika PAID)
- [ ] Layar riwayat transaksi (filter, search)

---

#### 💰 Flutter — Closing Shift UI (Minggu 13)

- [ ] Layar form closing (tabel metode bayar: sistem vs aktual)
- [ ] Kalkulasi selisih otomatis per metode
- [ ] Input catatan jika ada selisih
- [ ] Submit closing → notifikasi ke Manager/Owner
- [ ] Layar review & approve closing (untuk Manager/Owner)
- [ ] Layar history closing (filter: tanggal, shift)
- [ ] Reminder/badge jika shift belum closing

---

#### 🩺 Flutter — Rekam Medis UI (Minggu 11–12)

- [ ] Layar daftar rekam medis (search by customer/dokter/tanggal)
- [ ] Layar detail rekam medis (timeline kunjungan)
- [ ] Form input rekam medis baru (keluhan, diagnosis, tindakan, vital signs)
- [ ] Galeri foto per rekam medis (grid before/during/after)
- [ ] Upload foto dari galeri (Desktop & Mobile)
- [ ] Upload foto langsung dari kamera (Mobile — Dokter)
- [ ] Zoom & view foto fullscreen
- [ ] Form rekomendasi dokter (auto-trigger follow-up)

---

#### 💸 Flutter — Pengeluaran UI (Minggu 13–14)

- [ ] Layar daftar pengajuan pengeluaran (filter: status, tanggal, kategori)
- [ ] Form pengajuan baru (kategori, deskripsi, nominal, upload bukti)
- [ ] Layar detail pengajuan (status timeline: Draft → Pending → Approved/Rejected)
- [ ] Layar approve/reject (Manager/Owner) + input catatan
- [ ] Badge counter pengajuan pending di sidebar

---

#### 📞 Flutter — Follow-Up UI (Minggu 14)

- [ ] Layar daftar follow-up (filter: status, prioritas, tanggal)
- [ ] Form tambah follow-up manual
- [ ] Update status + input hasil kontak
- [ ] Layar follow-up hari ini (reminder harian)
- [ ] Badge counter follow-up jatuh tempo

---

#### 📊 Flutter — Laporan UI (Minggu 15–16)

- [ ] Layar laporan penjualan harian (tabel + chart bar)
- [ ] Layar laporan penjualan bulanan (summary + chart)
- [ ] Layar laporan per metode bayar (pie chart)
- [ ] Layar rekap produk in/out
- [ ] Layar rekap stok terkini (tabel dengan alert stok minimum)
- [ ] Layar rekap rekam medis
- [ ] Layar rekap treatment
- [ ] Layar rekap per praktisi/dokter
- [ ] Layar rekap pengeluaran
- [ ] Layar saldo & omset
- [ ] Layar laporan closing (history)
- [ ] Filter tanggal (DateRangePicker) di semua laporan
- [ ] Tombol export Excel → download file `.xlsx`
- [ ] Install `fl_chart` untuk grafik (bar, pie, line chart)

---

#### 📦 Flutter — Stok Opname UI (Minggu 17–18)

- [ ] Layar stok opname (input stok fisik per produk)
- [ ] Layar ringkasan hasil opname (selisih per produk)
- [ ] Layar produk stok minimum alert

---

#### ⚙️ Flutter — Pengaturan (Minggu 18)

- [ ] Layar pengaturan perusahaan (nama, alamat, logo, config struk)
- [ ] Layar pengaturan shift (waktu mulai/selesai siang & malam)
- [ ] Layar kelola pengguna (CRUD user, assign role & cabang)
- [ ] Layar kelola cabang (CRUD cabang)
- [ ] Layar audit log (read-only, filter: user, modul, tanggal)

---

#### 🔧 Komponen UI Baru (Fase 2)

- [ ] `AppDataTable` — Tabel sortable + searchable + pagination (reusable)
- [ ] `AppDateRangePicker` — Filter tanggal range untuk laporan
- [ ] `AppStatusChip` — Badge berwarna untuk status (PAID/UNPAID/PENDING/dll)
- [ ] `AppSearchAutocomplete` — Search customer/produk dengan autocomplete
- [ ] `AppImagePicker` — Upload foto dari kamera & galeri (mobile-aware)
- [ ] `AppQueueCard` — Kartu antrian dengan status & animasi realtime
- [ ] `AppBarChart` / `AppPieChart` — Komponen grafik menggunakan `fl_chart`
- [ ] `AppFormSlider` — Slide-in panel untuk form input (desktop)
- [ ] `AppConfirmDialog` — Dialog konfirmasi reusable (delete, approve, dll)
- [ ] `AppCurrencyInput` — Input field format Rupiah otomatis

---

#### 🧪 Build & Testing Fase 2

- [ ] Unit test API: antrian, transaksi, closing, rekam medis
- [ ] Integration test: flow antrian → POS → closing
- [ ] Test permission filter: Admin tidak bisa akses rekam medis
- [ ] Test split payment (total harus sama dengan grand total)
- [ ] Test export Excel semua laporan
- [ ] Test upload foto rekam medis (kamera + galeri)
- [ ] Test realtime antrian via WebSocket Reverb
- [ ] Test build APK (Android) & EXE (Windows) setelah Fase 2 selesai

---

## 📊 Estimasi Progress Fase 2

| Komponen | Total Item | Selesai | Progress |
|----------|:----------:|:-------:|:--------:|
| Backend — Master Data | 20 | 0 | 🔴 0% |
| Backend — Antrian | 8 | 0 | 🔴 0% |
| Backend — POS/Transaksi | 10 | 0 | 🔴 0% |
| Backend — Closing | 8 | 0 | 🔴 0% |
| Backend — Rekam Medis | 7 | 0 | 🔴 0% |
| Backend — Pengeluaran | 7 | 0 | 🔴 0% |
| Backend — Follow-Up | 5 | 0 | 🔴 0% |
| Backend — Laporan & Export | 14 | 0 | 🔴 0% |
| Backend — Stok Opname | 5 | 0 | 🔴 0% |
| Flutter — Master Data UI | 12 | 0 | 🔴 0% |
| Flutter — Antrian UI | 7 | 0 | 🔴 0% |
| Flutter — POS/Kasir UI | 15 | 0 | 🔴 0% |
| Flutter — Closing UI | 7 | 0 | 🔴 0% |
| Flutter — Rekam Medis UI | 10 | 0 | 🔴 0% |
| Flutter — Pengeluaran UI | 5 | 0 | 🔴 0% |
| Flutter — Follow-Up UI | 5 | 0 | 🔴 0% |
| Flutter — Laporan UI | 15 | 0 | 🔴 0% |
| Flutter — Stok Opname UI | 3 | 0 | 🔴 0% |
| Flutter — Pengaturan | 5 | 0 | 🔴 0% |
| Komponen UI Baru | 10 | 0 | 🔴 0% |
| Build & Testing Fase 2 | 8 | 0 | 🔴 0% |
| **TOTAL FASE 2** | **191** | **0** | 🔴 **0%** |

