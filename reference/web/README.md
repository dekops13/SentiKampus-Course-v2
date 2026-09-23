# SentiKampus Web — Streamlit

Frontend web ini ditempatkan lebih awal daripada Flutter karena sesuai alur RPS: mahasiswa mempelajari kontrak API dan integrasi UI sederhana sebelum masuk ke ekstensi multi-platform Android.

## Menjalankan

Pastikan reference backend aktif di port 8000.

```bash
cd reference/web
python -m venv .venv
# Windows CMD: .venv\Scripts\activate
pip install -r requirements.txt
streamlit run app.py
```

Default API: `http://127.0.0.1:8000`.

Jika backend berada di alamat lain:

```cmd
set API_BASE_URL=http://127.0.0.1:8000
streamlit run app.py
```
