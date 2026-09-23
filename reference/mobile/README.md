# SentiKampus Mobile — Flutter Android

Mobile dipakai sebagai **ekstensi multi-platform**, setelah mahasiswa memahami model, API, dan web UI. Baseline kelas yang digunakan pada paket ini adalah Flutter 3.10.1, Dart 3.x, JDK 17, dan Android Emulator API 33.

## 1. Generate platform Android

```cmd
cd reference\mobile
powershell -ExecutionPolicy Bypass -File scripts\bootstrap_platforms.ps1
```

Atau langsung:

```cmd
flutter create --project-name sentikampus_mobile --platforms=android .
flutter pub get
```

Script bootstrap menjaga `lib/`, `test/`, dan `pubspec.yaml` paket ini.

## 2. Development HTTP pada Android emulator

Backend Windows diakses emulator melalui `10.0.2.2`.

Setelah folder `android/` terbentuk, tambahkan pada `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Dan pada elemen `<application>` untuk **development lokal saja**:

```xml
android:usesCleartextTraffic="true"
```

## 3. Menjalankan

Pastikan backend aktif, lalu:

```cmd
flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

## 4. Build APK untuk emulator

```cmd
flutter build apk --release --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

APK berada di `build/app/outputs/flutter-apk/app-release.apk`.

> APK tersebut adalah build pembelajaran untuk emulator lokal, bukan paket produksi/Play Store.
