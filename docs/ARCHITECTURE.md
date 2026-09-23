# Arsitektur SentiKampus v2

## Tahap inti (web)

```text
Browser
  ↓
Streamlit Web UI
  ↓ HTTP/JSON
FastAPI
  ↓
TF-IDF + Logistic Regression
  ↓
Prediction + probabilities + explanation
  ↓
Streamlit
```

## Container

```text
Docker Compose
├── api :8000  → FastAPI + model
└── web :8501  → Streamlit → http://api:8000
```

## Ekstensi multi-platform

```text
                         ┌─ Streamlit Web
User → input → FastAPI ──┤
                         └─ Flutter Android Emulator
```

Pada Android Emulator, `10.0.2.2` menunjuk ke host Windows. Karena itu mobile development menggunakan `API_BASE_URL=http://10.0.2.2:8000` sedangkan web lokal menggunakan `http://127.0.0.1:8000`.

## Batas komponen

- **Model**: hanya menerima teks dan menghasilkan prediksi/probabilitas.
- **FastAPI**: validasi, contract, model inference, observability.
- **Streamlit/Flutter**: presentation dan interaction; tidak melatih model.
- **Docker**: environment reproducible.
- **Monitoring/testing**: bukti kualitas engineering, bukan dekorasi demo.
