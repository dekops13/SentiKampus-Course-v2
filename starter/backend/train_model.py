"""Starter P3 — lengkapi training TF-IDF + classifier dan simpan artifact."""

import csv
import json
import pickle
from pathlib import Path

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline


BASE_DIR = Path(__file__).resolve().parent
DATA = BASE_DIR / "training_samples.csv"
MODEL_DIR = BASE_DIR / "models"
MODEL_PATH = MODEL_DIR / "sentiment.pkl"
METADATA_PATH = MODEL_DIR / "metadata.json"


def main():
    texts = []
    labels = []

    # 1. Baca dataset
    with DATA.open(encoding="utf-8", newline="") as file:
        reader = csv.DictReader(file)

        for row in reader:
            texts.append(row["text"].strip())
            labels.append(row["label"].strip())

    # 2. Bentuk pipeline
    pipeline = Pipeline(
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

    # 3. Training
    pipeline.fit(texts, labels)

    # 4. Siapkan folder model
    MODEL_DIR.mkdir(parents=True, exist_ok=True)

    # 5. Metadata sederhana
    metadata = {
        "model_name": "sentikampus-tfidf-logistic-regression",
        "model_version": "starter-p3",
        "training_samples": len(texts),
        "labels": sorted(set(labels)),
        "purpose": "Model demonstrasi pembelajaran SentiKampus",
    }

    # 6. Simpan artifact
    artifact = {
        "pipeline": pipeline,
        "metadata": metadata,
    }

    with MODEL_PATH.open("wb") as file:
        pickle.dump(artifact, file)

    METADATA_PATH.write_text(
        json.dumps(
            metadata,
            ensure_ascii=False,
            indent=2
        ),
        encoding="utf-8",
    )

    print("Model demonstrasi berhasil dibuat.")
    print(f"Jumlah contoh: {len(texts)}")
    print(f"Model: {MODEL_PATH}")
    print(f"Metadata: {METADATA_PATH}")


if __name__ == "__main__":
    main()
