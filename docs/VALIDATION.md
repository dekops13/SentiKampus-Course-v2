# Validation Checklist v2

Checklist sebelum paket digunakan di kelas:

- [ ] Python 3.10 dapat membuat venv.
- [ ] `pip install -r reference/backend/requirements.txt -r reference/backend/requirements-dev.txt` berhasil.
- [ ] `python reference/backend/scripts/train_model.py` menghasilkan artifact.
- [ ] `python reference/backend/scripts/evaluate_model.py` menghasilkan evaluation.json.
- [ ] `pytest -q` pada reference backend lulus.
- [ ] `/health` mengembalikan model_loaded=true.
- [ ] `/api/v1/predict` mengembalikan label, score, probabilities, latency, trace_id.
- [ ] Streamlit memanggil FastAPI dan menampilkan hasil.
- [ ] `docker compose up --build` menjalankan api:8000 dan web:8501.
- [ ] Flutter 3.10.1 menerima dependency (`flutter pub get`).
- [ ] Android Emulator API 33 terdeteksi oleh `flutter devices`.
- [ ] Flutter Android mengakses backend melalui `10.0.2.2:8000`.
- [ ] APK release lokal dapat di-install ke emulator.

Lihat `lecturer/VALIDATION_REPORT.md` untuk validasi yang dilakukan saat paket ini disusun.
