# Environment Baseline

Gunakan baseline berikut agar variasi environment mahasiswa terkendali:

| Komponen | Baseline kelas |
|---|---|
| OS | Windows 11 64-bit |
| Python | 3.10.x |
| Git | versi modern yang tersedia |
| Docker | Docker Desktop, WSL2 backend |
| Flutter | 3.10.1 stable |
| Dart | bawaan Flutter 3.10.1 (Dart 3.x) |
| JDK | Temurin/OpenJDK 17 |
| Android SDK | API 33 |
| Emulator | Android 13, API 33, x86_64 |

## Pemeriksaan cepat

```cmd
python --version
git --version
docker --version
flutter --version
java -version
flutter doctor -v
flutter devices
```

Backend lokal Windows: `http://127.0.0.1:8000`.
Android emulator mengakses host Windows melalui: `http://10.0.2.2:8000`.

Untuk paket pembelajaran, jangan menaikkan versi tool di tengah semester kecuali ada alasan yang teruji dan terdokumentasi.
