from __future__ import annotations

import csv
import json
import pickle
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

import sklearn
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline


def read_samples(csv_path: Path) -> tuple[list[str], list[str]]:
    texts: list[str] = []
    labels: list[str] = []

    with csv_path.open(encoding="utf-8", newline="") as handle:
        for row in csv.DictReader(handle):
            texts.append(row["text"].strip())
            labels.append(row["label"].strip())

    if len(texts) < 9 or len(set(labels)) < 3:
        raise ValueError(
            "Data demo harus memuat sedikitnya 9 contoh dan 3 kelas."
        )

    return texts, labels


def build_demo_pipeline() -> Pipeline:
    """Create an unfitted pipeline so training and evaluation share one definition."""

    return Pipeline(
        steps=[
            (
                "vectorizer",
                TfidfVectorizer(
                    lowercase=True,
                    ngram_range=(1, 2),
                    min_df=1,
                    sublinear_tf=True,
                ),
            ),
            (
                "classifier",
                LogisticRegression(
                    max_iter=1000,
                    class_weight="balanced",
                    random_state=42,
                ),
            ),
        ]
    )


def train_demo_pipeline(csv_path: Path) -> Pipeline:
    texts, labels = read_samples(csv_path)

    pipeline = build_demo_pipeline()
    pipeline.fit(texts, labels)

    return pipeline


def persist_demo_model(
    csv_path: Path,
    model_path: Path,
    metadata_path: Path,
) -> dict[str, Any]:

    pipeline = train_demo_pipeline(csv_path)
    texts, labels = read_samples(csv_path)

    model_path.parent.mkdir(parents=True, exist_ok=True)
    metadata_path.parent.mkdir(parents=True, exist_ok=True)

    metadata: dict[str, Any] = {
        "model_name": "sentikampus-tfidf-logistic-regression",
        "model_version": "demo-2.0.0",
        "trained_at": datetime.now(timezone.utc).isoformat(),
        "training_samples": len(texts),
        "labels": sorted(set(labels)),
        "scikit_learn_version": sklearn.__version__,
        "purpose": (
            "Demonstrasi pembelajaran; "
            "bukan untuk keputusan administratif."
        ),
    }

    artifact = {
        "pipeline": pipeline,
        "metadata": metadata,
    }

    with model_path.open("wb") as handle:
        pickle.dump(
            artifact,
            handle,
            protocol=pickle.HIGHEST_PROTOCOL,
        )

    metadata_path.write_text(
        json.dumps(
            metadata,
            ensure_ascii=False,
            indent=2,
        ),
        encoding="utf-8",
    )

    return metadata