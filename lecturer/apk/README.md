# APK Demo Dosen

Binary APK tidak dibundel oleh generator paket karena APK harus dibangun dengan Flutter/Android toolchain target yang sudah divalidasi di komputer dosen.

Setelah `reference/mobile/android/` dihasilkan dan Android manifest development disiapkan:

```cmd
cd reference\mobile
flutter build apk --release --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

File hasil:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Install ke emulator:

```cmd
"%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe" install -r build\app\outputs\flutter-apk\app-release.apk
```

Setelah berhasil, salin `app-release.apk` ke folder ini jika ingin menyimpan fallback demo dosen.
