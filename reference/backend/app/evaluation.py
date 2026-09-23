from __future__ import annotations

from typing import Any

from sklearn.metrics import (
    accuracy_score,
    confusion_matrix,
    precision_recall_fscore_support,
)
from sklearn.model_selection import StratifiedKFold, cross_val_predict

from app.training import build_demo_pipeline, read_samples


def evaluate_demo_pipeline(csv_path, folds: int = 3) -> dict[str, Any]:
    """Evaluate the small teaching dataset with stratified cross-validation.

    The result is for learning how evaluation works, not for claiming deployment
    quality. With only 36 hand-written samples, every metric is highly uncertain.
    """
    texts, labels = read_samples(csv_path)
    label_order = sorted(set(labels))
    cv = StratifiedKFold(n_splits=folds, shuffle=True, random_state=42)
    pipeline = build_demo_pipeline()
    predictions = cross_val_predict(pipeline, texts, labels, cv=cv)

    accuracy = accuracy_score(labels, predictions)
    macro_precision, macro_recall, macro_f1, _ = precision_recall_fscore_support(
        labels,
        predictions,
        labels=label_order,
        average="macro",
        zero_division=0,
    )
    per_precision, per_recall, per_f1, per_support = precision_recall_fscore_support(
        labels,
        predictions,
        labels=label_order,
        average=None,
        zero_division=0,
    )

    per_class = {
        label: {
            "precision": round(float(per_precision[i]), 4),
            "recall": round(float(per_recall[i]), 4),
            "f1": round(float(per_f1[i]), 4),
            "support": int(per_support[i]),
        }
        for i, label in enumerate(label_order)
    }

    return {
        "evaluation_type": f"{folds}-fold stratified cross-validation",
        "samples": len(texts),
        "labels": label_order,
        "accuracy": round(float(accuracy), 4),
        "macro_precision": round(float(macro_precision), 4),
        "macro_recall": round(float(macro_recall), 4),
        "macro_f1": round(float(macro_f1), 4),
        "confusion_matrix": confusion_matrix(
            labels, predictions, labels=label_order
        ).tolist(),
        "per_class": per_class,
        "warning": (
            "Dataset ini sangat kecil dan dibuat untuk demonstrasi. "
            "Metrik tidak boleh dipakai sebagai klaim performa produksi."
        ),
    }
