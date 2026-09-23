from pathlib import Path

from app.model_service import ModelService


def test_model_can_train_load_and_predict(tmp_path: Path) -> None:
    backend_dir = Path(__file__).resolve().parents[1]
    service = ModelService(
        model_path=tmp_path / "sentiment.pkl",
        metadata_path=tmp_path / "metadata.json",
        data_path=backend_dir / "data" / "training_samples.csv",
    )
    service.load_or_train()

    result = service.predict("Pelayanan kampus sangat membantu", include_explanation=True)

    assert result["label"] in {"positif", "netral", "negatif"}
    assert 0.0 <= result["score"] <= 1.0
    assert result["explanation"]
    assert service.version == "demo-2.0.0"

