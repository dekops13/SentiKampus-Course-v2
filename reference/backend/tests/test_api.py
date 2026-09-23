from pathlib import Path

from fastapi.testclient import TestClient

from app.config import Settings
from app.main import create_app


def build_client(tmp_path: Path) -> TestClient:
    settings = Settings(
        model_path=tmp_path / "sentiment.pkl",
        metadata_path=tmp_path / "metadata.json",
        allowed_origins=["*"],
        log_level="WARNING",
    )
    return TestClient(create_app(settings))


def test_health_and_prediction(tmp_path: Path) -> None:
    with build_client(tmp_path) as client:
        health = client.get("/health")
        prediction = client.post(
            "/api/v1/predict",
            json={
                "text": "Dosen menjelaskan materi dengan jelas",
                "week": 7,
                "include_explanation": True,
            },
        )

    assert health.status_code == 200
    assert health.json()["model_loaded"] is True
    assert prediction.status_code == 200
    body = prediction.json()
    assert body["label"] in {"positif", "netral", "negatif"}
    assert set(body["probabilities"]) == {"positif", "netral", "negatif"}
    assert abs(sum(body["probabilities"].values()) - 1.0) < 0.001
    assert body["explanation"]
    assert prediction.headers["X-Trace-Id"]


def test_invalid_text_returns_422(tmp_path: Path) -> None:
    with build_client(tmp_path) as client:
        response = client.post(
            "/api/v1/predict",
            json={"text": " ", "week": 4},
        )
    assert response.status_code == 422


def test_metrics_and_course_mapping(tmp_path: Path) -> None:
    with build_client(tmp_path) as client:
        client.post(
            "/api/v1/predict",
            json={"text": "Jadwal kuliah tersusun dengan baik", "week": 4},
        )
        metrics = client.get("/api/v1/metrics")
        weeks = client.get("/api/v1/course/weeks")

    assert metrics.json()["total_requests"] == 1
    assert len(weeks.json()) == 16

