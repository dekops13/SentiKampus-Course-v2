# Starter Flutter Android — P12

Folder ini baru digunakan saat ekstensi multi-platform.

```cmd
flutter create --project-name sentikampus_mobile_starter --platforms=android .
flutter pub get
flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

Tugas mahasiswa: membuat request ke `/api/v1/predict`, parsing response, menampilkan label/confidence/probabilitas, dan menangani error jaringan.
