# Demo SentiKampus per Pertemuan — v2

## P1 — Architecture
Gunakan `docs/ARCHITECTURE.md`. Mahasiswa menggambar kembali alur input, frontend, API, model, output, dan deployment dengan bahasanya sendiri.

## P2 — FastAPI
Mulai dari `starter/backend/main.py`. Buat request/response JSON dan bandingkan dengan reference `/docs`.

## P3 — Model inference dan serialization
Latih model reference, buka `metadata.json`, jalankan `evaluate_model.py`, lalu bedakan training, evaluation, serialization, dan inference.

## P4 — Streamlit
Jalankan backend dan `reference/web/app.py`. Telusuri input UI → POST `/api/v1/predict` → response → visualisasi probabilitas.

## P5 — Docker
Jalankan `docker compose up --build`. Buktikan API dan Streamlit tetap berjalan dalam environment container.

## P6 — Deployment
Gunakan `docs/DEPLOYMENT.md`; tunjukkan perbedaan localhost, URL publik, konfigurasi, health check, dan HTTPS.

## P7 — Monitoring/latency/XAI
Lakukan beberapa prediksi, buka `/api/v1/metrics`, tampilkan latency dan contribution fitur. Tekankan bahwa explanation bukan kebenaran kausal.

## P8 — UTS prototype
Demo web end-to-end: kebutuhan → arsitektur → tiga kelas → kondisi API gagal → keterbatasan model.

## P9 — Integration testing
`pytest -q`; mahasiswa menambah minimal satu skenario invalid/error.

## P10 — UI/UX refinement
Perbaiki loading/error state, probabilitas, confidence, label tekstual, dan kemudahan penggunaan Streamlit.

## P11 — Progress API/architecture
Cocokkan diagram, endpoint, source file, dan pembagian tanggung jawab anggota tim.

## P12 — Multi-platform Flutter Android
Generate Android project, jalankan emulator API 33, gunakan `10.0.2.2:8000`, lalu buktikan web dan Android memakai endpoint yang sama.

## P13 — Stress test
Gunakan `reference/backend/load_test/locustfile.py`; catat users, RPS, failure, median/p95, dan interpretasi.

## P14 — Documentation
Anggota tim lain mencoba menjalankan proyek hanya dari README dan dokumen.

## P15 — End-to-end
Mulai dari service mati → nyalakan backend/web → prediksi → monitoring → tests → Android emulator bila digunakan.

## P16 — Final
Serahkan repository, dokumentasi, laporan pengujian, hasil evaluasi model, dan demonstrasi yang konsisten dengan produk.
