# Validation Report — SentiKampus Course Package v2

Tanggal penyusunan: 17 September 2026.

## Validasi yang dijalankan saat paket dibuat

- Python source backend dikompilasi tanpa syntax error.
- Backend test suite: **5 passed**.
- Training baseline berhasil membuat model `demo-2.0.0` dari 36 contoh.
- Evaluasi 3-fold stratified cross-validation berhasil dijalankan.
- Hasil baseline saat validasi: accuracy 0.3333 dan macro-F1 0.3471. Angka rendah ini dipertahankan sebagai bukti bahwa dataset demo belum layak dijadikan model final; model akan dikembangkan pada tahap pembelajaran berikutnya.
- `POST /api/v1/predict` berhasil mengembalikan label, score, probabilities, latency, explanation, capabilities, dan trace ID.
- Source Streamlit dan starter Python lolos pemeriksaan syntax.
- `docker-compose.yml` dan seluruh file YAML utama dapat diparse.

## Validasi yang harus dilakukan pada komputer dosen

Build Docker dan Flutter/Android tidak dijalankan di environment generator paket karena Docker daemon dan Flutter SDK tidak tersedia di sana. Target package sudah diselaraskan dengan baseline yang sebelumnya berhasil digunakan pada komputer dosen:

- Python 3.10.x;
- Flutter 3.10.1 / Dart 3.x;
- JDK 17;
- Android API 33 x86_64;
- Docker Desktop + WSL2.

Gunakan `scripts/check_environment.ps1` dan `scripts/validate_backend.ps1`, kemudian ikuti `reference/mobile/README.md` untuk build/install APK emulator.

## Artifact model

File pickle hasil validasi **tidak dibundel** ke ZIP agar tidak membawa artifact serialization lintas versi Python/scikit-learn. Model reference dibuat ulang dengan `python scripts/train_model.py` pada environment target.
