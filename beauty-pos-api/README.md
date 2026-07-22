# 💄 Beauty POS — Backend API

> **Laravel 11 REST API** untuk Sistem POS Klinik Kecantikan & Treatment  
> Cross-platform: Desktop (Windows) + Mobile (Android/iOS)

[![Laravel](https://img.shields.io/badge/Laravel-11.x-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)](https://laravel.com)
[![PHP](https://img.shields.io/badge/PHP-8.3-777BB4?style=for-the-badge&logo=php&logoColor=white)](https://php.net)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://mysql.com)

---

## 📋 Tentang Project

Sistem POS terintegrasi untuk klinik kecantikan yang mencakup:
- 🔐 Autentikasi & role-based access control (RBAC)
- 👥 Manajemen pengguna multi-role (Owner, Manager, Admin/Kasir, Dokter)
- 🏥 Rekam medis & upload foto treatment
- 🛒 POS / Kasir dengan multi-metode pembayaran (Cash, Transfer, QRIS, Split)
- 📋 Sistem antrian real-time via WebSocket (Laravel Reverb)
- 💰 Closing shift Siang (08:00–13:00) & Malam (15:00–20:00)
- 💸 Pengajuan & approval pengeluaran
- 📊 Laporan keuangan lengkap & export Excel
- 📞 Follow-up customer otomatis

---

## 🛠️ Tech Stack

| Layer | Teknologi | Versi |
|-------|-----------|-------|
| **Framework** | Laravel | 11.x |
| **Database** | MySQL | 8.0+ |
| **Auth** | Laravel Sanctum | 4.x |
| **Permission** | Spatie Laravel Permission | 8.x |
| **WebSocket** | Laravel Reverb | 1.x |
| **Export Excel** | Maatwebsite Excel | 3.x |
| **Image** | Intervention Image | 3.x |
| **PHP** | PHP | 8.3+ |

---

## 🚀 Instalasi

### Prerequisites
- PHP 8.3+
- Composer
- MySQL 8.0+

### Langkah Instalasi

```bash
# 1. Clone repository
git clone https://github.com/azkaibad/beauty-pos-api.git
cd beauty-pos-api

# 2. Install dependencies
composer install

# 3. Copy & konfigurasi environment
cp .env.example .env
php artisan key:generate

# 4. Konfigurasi database di .env
# DB_DATABASE=beauty_pos
# DB_USERNAME=root
# DB_PASSWORD=

# 5. Jalankan migrasi + seeder
php artisan migrate --seed

# 6. Jalankan server
php artisan serve

# 7. (Opsional) Jalankan WebSocket server
php artisan reverb:start
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

## 📡 API Endpoints (Fase 1)

### Auth
| Method | Endpoint | Deskripsi | Auth |
|--------|----------|-----------|------|
| `POST` | `/api/v1/login` | Login & dapatkan token | ❌ |
| `POST` | `/api/v1/logout` | Logout & hapus token | ✅ |
| `GET` | `/api/v1/me` | Data user + permissions | ✅ |
| `POST` | `/api/v1/change-password` | Ganti password | ✅ |

### Response Format
```json
{
  "status": "success",
  "data": {
    "user": {
      "id": 1,
      "name": "Owner",
      "email": "owner@beautypos.com",
      "roles": [{ "name": "owner" }],
      "permissions": [
        { "id": 1, "name": "manage_users" },
        { "id": 5, "name": "manage_pos" }
      ]
    },
    "token": "1|abc123..."
  }
}
```

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

## 📁 Struktur Direktori

```
beauty-pos-api/
├── app/
│   ├── Http/
│   │   ├── Controllers/Api/
│   │   │   └── AuthController.php
│   │   ├── Middleware/
│   │   │   └── CheckPermission.php
│   │   └── Requests/Api/
│   │       ├── LoginRequest.php
│   │       └── ChangePasswordRequest.php
│   └── Models/
│       ├── User.php
│       ├── Branch.php
│       └── AuditLog.php
├── database/
│   ├── migrations/
│   │   ├── create_branches_table.php
│   │   └── create_audit_logs_table.php
│   └── seeders/
│       ├── RolePermissionSeeder.php
│       └── UserSeeder.php
└── routes/
    └── api.php
```

---

## 🗺️ Roadmap

| Fase | Status | Fitur |
|------|:------:|-------|
| **Fase 1** | ✅ **Selesai** | Auth, RBAC, Shell UI, Audit Log, WebSocket setup |
| **Fase 2** | 🔄 In Progress | Master Data, Antrian, POS/Kasir, Closing, Rekam Medis, Pengeluaran, Laporan |
| **Fase 3** | 📋 Planned | Promo, Offline Mode, WhatsApp Integration, Performance Optimization |

---

## 📄 License

MIT License
