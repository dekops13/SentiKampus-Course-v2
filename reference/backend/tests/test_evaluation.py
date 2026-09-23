from app.config import BACKEND_DIR
from app.evaluation import evaluate_demo_pipeline


def test_evaluation_report_has_expected_structure() -> None:
    report = evaluate_demo_pipeline(BACKEND_DIR / "data" / "training_samples.csv")
    assert report["samples"] == 36
    assert report["labels"] == ["negatif", "netral", "positif"]
    assert 0.0 <= report["accuracy"] <= 1.0
    assert 0.0 <= report["macro_f1"] <= 1.0
    assert len(report["confusion_matrix"]) == 3
