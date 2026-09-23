# API Contract SentiKampus

## GET `/health`

Response contoh:

```json
{
  "status": "ok",
  "model_loaded": true,
  "model_version": "demo-2.0.0"
}
```

## POST `/api/v1/predict`

Request:

```json
{
  "text": "Pelayanan akademik sangat membantu",
  "week": 7,
  "include_explanation": true
}
```

Response utama:

```json
{
  "label": "positif",
  "score": 0.71,
  "probabilities": {
    "negatif": 0.13,
    "netral": 0.16,
    "positif": 0.71
  },
  "model_version": "demo-2.0.0",
  "latency_ms": 3.48,
  "explanation": [
    {"term": "membantu", "contribution": 0.22}
  ],
  "capabilities": ["api", "model", "monitoring", "xai"],
  "trace_id": "...",
  "source": "api"
}
```

`score` adalah probabilitas kelas terpilih. `probabilities` menyediakan distribusi semua kelas untuk visualisasi pembelajaran. `explanation` merupakan kontribusi fitur model linear, bukan penjelasan psikologis penulis teks.

## GET `/api/v1/metrics`

Mengembalikan jumlah request, sukses/gagal, error rate, latency ringkas, dan distribusi label.

## GET `/api/v1/course/weeks`

Metadata alur demonstrasi 16 pertemuan.
