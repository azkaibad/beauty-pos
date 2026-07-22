# 💄 Beauty POS — Flutter App

> **Flutter Cross-Platform App** untuk Sistem POS Klinik Kecantikan & Treatment  
> Desktop (Windows) + Mobile (Android/iOS) — satu codebase

[![Flutter](https://img.shields.io/badge/Flutter-3.44.7-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12.2-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Android](https://img.shields.io/badge/Android-APK-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://android.com)
[![Windows](https://img.shields.io/badge/Windows-Desktop-0078D6?style=for-the-badge&logo=windows&logoColor=white)](https://microsoft.com/windows)

---

## 📋 Tentang Project

Flutter app cross-platform untuk sistem POS klinik kecantikan dengan:
- 🖥️ **Desktop (Windows)**: Collapsible sidebar, multi-panel layout
- 📱 **Mobile (Android/iOS)**: Bottom navigation, drawer, kamera
- 🎨 **Adaptive Layout**: Otomatis switching Desktop/Mobile berdasarkan screen size
- 🔐 **Permission-based Menu**: Menu tampil sesuai role pengguna
- ⚡ **Real-time**: Sinkronisasi antrian & notifikasi via WebSocket

---

## 🛠️ Tech Stack

| Layer | Package | Versi |
|-------|---------|-------|
| **State Management** | Flutter Riverpod | 2.6.1 |
| **Navigation** | Go Router | 15.x |
| **HTTP Client** | Dio | 5.8.x |
| **Storage** | Shared Preferences | 2.3.x |
| **UI — Fonts** | Google Fonts | 6.x |
| **UI — Shimmer** | Shimmer | 3.0.0 |
| **UI — SVG** | Flutter SVG | 2.x |
| **Images** | Cached Network Image | 3.x |

---

## 🚀 Menjalankan App

### Prerequisites
- Flutter SDK 3.44.7+
- Android SDK 36 (untuk build Android)
- Visual Studio Build Tools 2026 (untuk build Windows)
- Java JDK 17+ (Android Studio bundled JBR)

### Setup

```bash
# 1. Clone repository
git clone https://github.com/azkaibad/beauty-pos-app.git
cd beauty-pos-app

# 2. Install dependencies
flutter pub get

# 3. Konfigurasi API URL di lib/core/network/api_client.dart
# baseUrl: 'http://your-api-url/api/v1'

# 4. Jalankan di Windows
flutter run -d windows

# 5. Jalankan di Android (HP terhubung)
flutter run -d <device-id>

# 6. Build APK release
flutter build apk --release

# 7. Build Windows EXE release
flutter build windows --release
```

---

## 📁 Struktur Direktori

```
lib/
├── core/
│   ├── models/
│   │   └── user_model.dart          — Model user + permissions
│   ├── network/
│   │   ├── api_client.dart          — Dio HTTP client + interceptors
│   │   └── auth_interceptor.dart    — Auto-attach token + 401 handler
│   ├── router/
│   │   └── app_router.dart          — GoRouter + auth guard
│   ├── storage/
│   │   └── token_storage.dart       — SharedPreferences token storage
│   └── utils/
│       └── responsive.dart          — Desktop/Mobile breakpoint helper
│
├── features/
│   ├── auth/
│   │   ├── auth_provider.dart       — Riverpod auth state
│   │   └── login_screen.dart        — Login UI (shared desktop & mobile)
│   ├── dashboard/
│   │   └── dashboard_screen.dart    — Dashboard (per role)
│   └── profile/
│       └── profile_screen.dart      — Profil & ganti password
│
└── ui/
    ├── desktop/
    │   ├── shell/
    │   │   ├── desktop_shell.dart   — Sidebar + content shell
    │   │   ├── loading_widget.dart  — Shimmer placeholder
    │   │   └── app_snackbar.dart    — Toast notification
    │   └── theme/
    │       └── app_theme.dart       — AppColors + AppTheme
    └── mobile/
        └── shell/
            └── mobile_shell.dart    — Bottom nav + drawer shell
```

---

## 🎨 Design System

| Token | Value |
|-------|-------|
| **Primary** | Rose Gold `#D4838F` |
| **Accent** | Gold `#BFA07A` |
| **Background** | Dark `#1A1218` |
| **Surface** | `#2E2228` |
| **Text Primary** | `#F5EEF0` |
| **Success** | `#6DBF8A` |
| **Error** | `#CF6679` |

**Tema:** Dark mode premium dengan nuansa rose gold khas industri kecantikan.

---

## 🔐 Permission-Based Navigation

Menu sidebar/bottom nav otomatis tampil sesuai permission user:

| Menu | Permission Required |
|------|-------------------|
| Dashboard | Semua role |
| Kasir / POS | `manage_pos` |
| Antrian | `manage_pos` atau `manage_medical_records` |
| Rekam Medis | `manage_medical_records` |
| Pengeluaran | `manage_expenses` |
| Laporan | `view_reports` |
| Follow-Up | `manage_followup` |

---

## 📱 Platform Support

| Platform | Status | Output |
|----------|:------:|--------|
| **Windows** | ✅ Berhasil | `.exe` ~65MB |
| **Android** | ✅ Berhasil | `.apk` ~50MB |
| **iOS** | 📋 Planned | Butuh Mac untuk build |
| **Web** | ✅ Tersedia | `flutter run -d chrome` |

---

## 🗺️ Roadmap

| Fase | Status | Fitur |
|------|:------:|-------|
| **Fase 1** | ✅ **Selesai** | Login, Shell Desktop/Mobile, Profil, Router, Design System |
| **Fase 2** | 🔄 In Progress | Master Data UI, Antrian, POS/Kasir, Closing, Rekam Medis, Laporan |
| **Fase 3** | 📋 Planned | Offline mode, Thermal print, WhatsApp, Push notification |

---

## 🔗 Repository Terkait

- **Backend API**: [beauty-pos-api](https://github.com/azkaibad/beauty-pos-api)

---

## 📄 License

MIT License
