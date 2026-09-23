# Reference Backend — SentiKampus

Backend referensi menggunakan **Python 3.10**, FastAPI, scikit-learn, TF-IDF, dan Logistic Regression.
Modelnya sengaja kecil untuk pembelajaran alur engineering AI, bukan untuk penilaian manusia atau keputusan administratif.

## Menjalankan

```bash
python -m venv .venv
# Windows CMD: .venv\Scripts\activate
python -m pip install --upgrade pip
pip install -r requirements.txt -r requirements-dev.txt
python scripts/train_model.py
python scripts/evaluate_model.py
uvicorn app.main:app --reload
```

- Swagger: `http://127.0.0.1:8000/docs`
- Health: `http://127.0.0.1:8000/health`
- Predict: `POST http://127.0.0.1:8000/api/v1/predict`
- Metrics: `GET http://127.0.0.1:8000/api/v1/metrics`

## Pengujian

```bash
pytest -q
```

## Catatan evaluasi model

`python scripts/evaluate_model.py` menjalankan 3-fold stratified cross-validation dan menyimpan hasil pada `models/evaluation.json`. Dataset hanya 36 contoh buatan; metriknya digunakan untuk belajar evaluasi, bukan sebagai klaim performa model produksi.
