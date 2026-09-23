from fastapi import FastAPI

app = FastAPI(title="SentiKampus Starter API")


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "healthy"}


# TODO P2:
# 1. Buat schema request text.
# 2. Tambahkan POST /api/v1/predict.
# 3. Kembalikan JSON response yang konsisten.
#
# TODO P3:
# Hubungkan endpoint dengan model hasil training, bukan aturan if/else.
