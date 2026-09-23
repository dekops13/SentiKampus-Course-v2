from __future__ import annotations

import json
import os
import urllib.error
import urllib.request

import streamlit as st

API_BASE_URL = os.getenv("API_BASE_URL", "http://127.0.0.1:8000").rstrip("/")


def get_json(path: str) -> dict:
    request = urllib.request.Request(f"{API_BASE_URL}{path}", method="GET")
    with urllib.request.urlopen(request, timeout=5) as response:
        return json.loads(response.read().decode("utf-8"))


def post_json(path: str, payload: dict) -> dict:
    body = json.dumps(payload).encode("utf-8")
    request = urllib.request.Request(
        f"{API_BASE_URL}{path}",
        data=body,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=8) as response:
        return json.loads(response.read().decode("utf-8"))


st.set_page_config(page_title="SentiKampus Web", page_icon="🎓", layout="centered")
st.title("🎓 SentiKampus")
st.caption("Web UI pembelajaran AI — Streamlit → FastAPI → Model")

with st.sidebar:
    st.subheader("Koneksi API")
    st.code(API_BASE_URL)
    try:
        health = get_json("/health")
        st.success(f"API aktif · model {health.get('model_version', '-')}")
    except Exception as exc:
        st.error(f"API belum dapat dihubungi: {exc}")
    st.info("Model demo tidak boleh digunakan untuk keputusan administratif atau penilaian individu.")

text = st.text_area(
    "Masukan mahasiswa",
    value="Pelayanan akademik sangat membantu",
    height=120,
    help="Gunakan teks anonim. Jangan masukkan nama, NIM, nomor telepon, atau data pribadi.",
)
week = st.selectbox("Konteks pertemuan", options=list(range(1, 17)), index=3)
include_explanation = st.checkbox("Tampilkan penjelasan fitur", value=week >= 7)

if st.button("Analisis Sentimen", type="primary", use_container_width=True):
    if len(text.strip()) < 3:
        st.warning("Teks minimal tiga karakter.")
    else:
        try:
            with st.spinner("Mengirim teks ke FastAPI dan menjalankan inference..."):
                result = post_json(
                    "/api/v1/predict",
                    {
                        "text": text.strip(),
                        "week": int(week),
                        "include_explanation": include_explanation,
                    },
                )
            st.subheader(result["label"].upper())
            st.metric("Confidence kelas terpilih", f"{result['score'] * 100:.1f}%")
            st.caption(
                f"Model {result['model_version']} · {result['latency_ms']:.2f} ms · Trace {result['trace_id'][:8]}"
            )

            st.markdown("#### Probabilitas kelas")
            for label, probability in sorted(result.get("probabilities", {}).items()):
                st.write(f"**{label.capitalize()}** — {probability * 100:.1f}%")
                st.progress(float(probability))

            if include_explanation:
                st.markdown("#### Penjelasan sederhana")
                explanation = result.get("explanation", [])
                if explanation:
                    st.dataframe(explanation, use_container_width=True, hide_index=True)
                else:
                    st.caption("Tidak ada fitur aktif yang cukup informatif untuk ditampilkan.")

            with st.expander("Lihat JSON response"):
                st.json(result)
        except urllib.error.HTTPError as exc:
            detail = exc.read().decode("utf-8", errors="replace")
            st.error(f"API mengembalikan HTTP {exc.code}: {detail}")
        except Exception as exc:
            st.error(f"Prediksi gagal: {exc}")
