# 💄 Beauty POS — Sistem POS Klinik Kecantikan

> **Monorepo** — Laravel 11 API + Flutter Desktop & Mobile App  
> Sistem POS lengkap untuk klinik kecantikan dan treatment

[![Laravel](https://img.shields.io/badge/Laravel-11.x-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)](https://laravel.com)
[![Flutter](https://img.shields.io/badge/Flutter-3.44.7-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![PHP](https://img.shields.io/badge/PHP-8.3-777BB4?style=for-the-badge&logo=php&logoColor=white)](https://php.net)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://mysql.com)
[![Windows](https://img.shields.io/badge/Windows-Desktop-0078D6?style=for-the-badge&logo=windows&logoColor=white)](https://microsoft.com/windows)
[![Android](https://img.shields.io/badge/Android-APK-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://android.com)

---

## 📁 Struktur Monorepo

```
beauty-pos/
├── beauty-pos-api/        ← Laravel 11 REST API (Backend)
├── beauty_pos_app/        ← Flutter Cross-Platform App (Frontend)
└── PRD.md                 ← Product Requirements Document
```

---

## 📋 Tentang Project

Sistem POS terintegrasi untuk klinik kecantikan yang mencakup:

| Fitur | Status |
|-------|--------|
| 🔐 Autentikasi & RBAC (Owner, Manager, Admin, Dokter) | ✅ Fase 1 |
| 📋 Sistem antrian real-time (WebSocket) | ✅ Fase 1 |
| 🛒 POS / Kasir multi-metode pembayaran | 🔄 Fase 2 |
| 🏥 Rekam medis & upload foto | 🔄 Fase 2 |
| 💰 Closing shift Siang & Malam | 🔄 Fase 2 |
| 💸 Pengajuan & approval pengeluaran | 🔄 Fase 2 |
| 📊 Laporan keuangan & export Excel | 🔄 Fase 2 |
| 📞 Follow-up customer | 🔄 Fase 2 |
| 📢 Promo, testimoni, galeri, FAQ | 📋 Fase 3 |
| 📴 Offline mode (kasir tetap bisa input) | 📋 Fase 3 |

---

## 🛠️ Tech Stack

### Backend (`beauty-pos-api/`)
| Layer | Teknologi | Versi |
|-------|-----------|-------|
| Framework | Laravel | 11.x |
| Database | MySQL | 8.0+ |
| Auth | Laravel Sanctum | 4.x |
| Permission | Spatie Laravel Permission | 8.x |
| WebSocket | Laravel Reverb | 1.x |
| Export Excel | Maatwebsite Excel | 3.x |
| Image | Intervention Image | 3.x |

### Frontend (`beauty_pos_app/`)
| Layer | Teknologi | Versi |
|-------|-----------|-------|
| Framework | Flutter | 3.44.7 |
| State Management | Riverpod | 2.6.1 |
| Navigation | Go Router | 15.x |
| HTTP | Dio | 5.8.x |
| Fonts | Google Fonts | 6.x |

---

## 🚀 Cara Menjalankan

### 1. Backend API

```bash
cd beauty-pos-api

# Install dependencies
composer install

# Setup environment
cp .env.example .env
php artisan key:generate

# Konfigurasi DB di .env (DB_DATABASE, DB_USERNAME, DB_PASSWORD)

# Migrasi + seeder
php artisan migrate --seed

# Jalankan server
php artisan serve          # API: http://localhost:8000

# (Opsional) WebSocket server
php artisan reverb:start
```

### 2. Flutter App

```bash
cd beauty_pos_app

# Install dependencies
flutter pub get

# Pastikan API URL di lib/core/api/api_client.dart sesuai

# Jalankan di Windows
flutter run -d windows

# Jalankan di Android
flutter run -d <device-id>

# Build APK
flutter build apk --release

# Build Windows EXE
flutter build windows --release
```

---

## 🔑 Akun Default (Seeder)

| Role | Email | Password |
|------|-------|----------|
| **Owner** | owner@beautypos.com | password |
| **Manager** | manager@beautypos.com | password |
| **Admin/Kasir** | admin@beautypos.com | password |
| **Dokter** | dokter@beautypos.com | password |

---

## 🔐 Role & Permission Matrix

| Permission | Owner | Manager | Admin | Dokter |
|-----------|:-----:|:-------:|:-----:|:------:|
| `manage_users` | ✅ | ❌ | ❌ | ❌ |
| `manage_branches` | ✅ | ❌ | ❌ | ❌ |
| `manage_roles` | ✅ | ❌ | ❌ | ❌ |
| `manage_pos` | ✅ | ✅ | ✅ | ❌ |
| `manage_expenses` | ✅ | ✅ | ✅ | ❌ |
| `view_reports` | ✅ | ✅ | ❌ | ❌ |
| `manage_followup` | ✅ | ✅ | ✅ | ❌ |
| `manage_medical_records` | ✅ | ✅ | ❌ | ✅ |

---

## 🎨 Design System

**Tema:** Dark mode premium dengan nuansa rose gold khas industri kecantikan.

| Token | Value | Preview |
|-------|-------|---------|
| Primary | Rose Gold `#D4838F` | 🌸 |
| Accent | Gold `#BFA07A` | 🥇 |
| Background | Dark `#1A1218` | ⬛ |
| Surface | `#2E2228` | 🟫 |

---

## 📱 Platform Support

| Platform | Status | Output |
|----------|:------:|--------|
| **Windows** | ✅ Berhasil | `.exe` ~65MB |
| **Android** | ✅ Berhasil | `.apk` ~50MB |
| **iOS** | 📋 Planned | Butuh Mac |
| **Web** | ✅ Tersedia | `flutter run -d chrome` |

---

## 🗺️ Roadmap

| Fase | Minggu | Status | Deliverable |
|------|--------|:------:|-------------|
| **Fase 1** | 1–10 | ✅ **Selesai** | Auth, RBAC, Shell UI Desktop+Mobile, WebSocket setup, APK & EXE build |
| **Fase 2** | 11–18 | 🔄 **In Progress** | Master Data, Antrian, POS, Closing, Rekam Medis, Pengeluaran, Laporan |
| **Fase 3** | 19–24 | 📋 **Planned** | Promo, Offline mode, WhatsApp, Performance Optimization |

Lihat checklist lengkap Fase 2 di [PRD.md](./PRD.md#checklist-penyelesaian-fase-2)

---

## 📄 License

MIT License
