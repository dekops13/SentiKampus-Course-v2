# Desain Pembelajaran: Guided Project

## Prinsip

SentiKampus adalah kendaraan pembelajaran untuk mencapai kemampuan analisis, implementasi, pemilihan metode, evaluasi, dan solusi multi-platform. Instalasi tool hanya prasyarat operasional, bukan tujuan utama mata kuliah.

## Alur teknis

```text
P1  Architecture
 ↓
P2  FastAPI / API contract
 ↓
P3  Model training + serialization + evaluation
 ↓
P4  Streamlit Web UI
 ↓
P5  Docker
 ↓
P6  Deployment
 ↓
P7  Monitoring + latency + XAI
 ↓
P8  Prototype evaluation
 ↓
P9  Integration testing
 ↓
P10 UI/UX + prediction visualization
 ↓
P11 Progress architecture/API
 ↓
P12 Flutter Android extension (same API)
 ↓
P13 Stress test
 ↓
P14 Documentation
 ↓
P15 End-to-end demo
 ↓
P16 Final repository/demo
```

## Kenapa web lebih dahulu?

Streamlit memberi cognitive load yang lebih rendah untuk memahami alur `input → HTTP → API → inference → output`. Setelah konsep stabil, Flutter Android memperlihatkan bahwa API yang sama dapat melayani platform berbeda. Dengan demikian mobile menjadi bukti arsitektur multi-platform, bukan pengalih perhatian dari konsep AI dan API pada minggu awal.
