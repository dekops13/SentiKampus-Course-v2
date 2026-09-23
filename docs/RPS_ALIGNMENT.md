# Keterkaitan Paket dengan RPS

Paket v2 mempertahankan urutan bahan kajian RPS: arsitektur → API → model inference/serialization → frontend web → Docker → deployment → monitoring/XAI → evaluasi prototype → integration testing → UI/UX → progress report → stress test → dokumentasi → demo akhir.

## Pemetaan implementasi

| Pertemuan | Implementasi paket |
|---|---|
| 1 | `docs/ARCHITECTURE.md`, analisis kebutuhan |
| 2 | `starter/backend`, `reference/backend/app/main.py` |
| 3 | `reference/backend/app/training.py`, `scripts/train_model.py`, `scripts/evaluate_model.py` |
| 4 | `reference/web/` Streamlit |
| 5 | `reference/backend/Dockerfile`, root `docker-compose.yml` |
| 6 | `docs/DEPLOYMENT.md` |
| 7 | monitoring endpoint + XAI linear |
| 8 | prototype web end-to-end |
| 9 | pytest + integration tests |
| 10 | probabilitas, confidence, error/loading state pada UI |
| 11 | review arsitektur/API |
| 12 | `reference/mobile/` Flutter Android sebagai ekstensi multi-platform |
| 13 | Locust + metrics |
| 14 | dokumentasi dan reproducibility |
| 15 | demo end-to-end web dan/atau Android |
| 16 | repository, dokumentasi, live app sesuai kebijakan pengampu |

Flutter tidak menggantikan Streamlit pada pertemuan 4. Mobile diposisikan sebagai pembuktian bahwa satu inference API dapat digunakan oleh lebih dari satu frontend.
