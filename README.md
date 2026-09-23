# SentiKampus Course Package v2

Paket ini adalah **guided project** untuk mata kuliah Kecerdasan Buatan. Mahasiswa tidak hanya menjalankan aplikasi jadi dan juga tidak diwajibkan membangun seluruh stack dari nol pada pertemuan pertama. Mereka menerima scaffold, lalu melengkapi komponen sesuai urutan RPS.

## Struktur

```text
SentiKampus_Course_v2/
├── starter/      # scaffold mahasiswa, sengaja belum lengkap
├── reference/    # implementasi lengkap untuk dosen/referensi
│   ├── backend/  # FastAPI + model + monitoring + XAI + tests
│   ├── web/      # Streamlit, frontend utama tahap awal
│   └── mobile/   # Flutter Android, ekstensi multi-platform
├── docs/         # panduan course, arsitektur, API, evaluasi, validasi
├── lecturer/     # materi operasional dosen dan panduan APK demo
├── scripts/      # helper Windows
└── docker-compose.yml
```

## Baseline environment yang diseragamkan

- Windows 11
- Python 3.10.x
- Git
- VS Code
- Docker Desktop + WSL2
- Flutter 3.10.1 / Dart 3.x
- JDK 17
- Android Studio
- Android Emulator API 33 x86_64

## Quick start reference

Backend:

```cmd
cd reference\backend
python -m venv .venv
.venv\Scripts\activate
python -m pip install --upgrade pip
pip install -r requirements.txt -r requirements-dev.txt
python scripts\train_model.py
python scripts\evaluate_model.py
uvicorn app.main:app --reload
```

Web, pada CMD kedua:

```cmd
cd reference\web
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
set API_BASE_URL=http://127.0.0.1:8000
streamlit run app.py
```

Atau Docker:

```cmd
docker compose up --build
```

- API: `http://127.0.0.1:8000/docs`
- Streamlit: `http://127.0.0.1:8501`

Flutter Android digunakan pada fase multi-platform. Lihat `reference/mobile/README.md`.

## Batas penggunaan

Dataset dan model bersifat demonstratif. Jangan gunakan sistem ini untuk menilai mahasiswa/dosen, keputusan administratif, atau pemrosesan data pribadi. Gunakan input anonim.
