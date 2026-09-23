from __future__ import annotations

import json
import logging
import pickle
from pathlib import Path
from typing import Any

import numpy as np
from sklearn.pipeline import Pipeline

from app.training import persist_demo_model


LOGGER = logging.getLogger(__name__)


class ModelService:
    """Loads and serves a locally generated, trusted demonstration artifact."""

    def __init__(self, model_path: Path, metadata_path: Path, data_path: Path) -> None:
        self.model_path = model_path
        self.metadata_path = metadata_path
        self.data_path = data_path
        self.pipeline: Pipeline | None = None
        self.metadata: dict[str, Any] = {}

    def load_or_train(self) -> None:
        if not self.model_path.exists():
            LOGGER.info("Model belum tersedia; melatih model demonstrasi lokal.")
            persist_demo_model(self.data_path, self.model_path, self.metadata_path)

        # Jangan pernah mengganti path ini dengan file pickle dari sumber yang tidak dipercaya.
        with self.model_path.open("rb") as handle:
            artifact = pickle.load(handle)  # noqa: S301 - artifact dibuat lokal oleh proyek ini.
        self.pipeline = artifact["pipeline"]
        self.metadata = artifact.get("metadata", {})

        if self.metadata_path.exists():
            disk_metadata = json.loads(self.metadata_path.read_text(encoding="utf-8"))
            self.metadata.update(disk_metadata)

    @property
    def is_loaded(self) -> bool:
        return self.pipeline is not None

    @property
    def version(self) -> str:
        return str(self.metadata.get("model_version", "unknown"))

    def predict(self, text: str, include_explanation: bool = False) -> dict[str, Any]:
        if self.pipeline is None:
            raise RuntimeError("Model belum dimuat.")

        probabilities = self.pipeline.predict_proba([text])[0]
        classifier = self.pipeline.named_steps["classifier"]
        index = int(np.argmax(probabilities))
        label = str(classifier.classes_[index])
        explanation = self._explain(text, index) if include_explanation else []
        probability_map = {
            str(class_name): round(float(probability), 6)
            for class_name, probability in zip(classifier.classes_, probabilities)
        }

        return {
            "label": label,
            "score": float(probabilities[index]),
            "probabilities": probability_map,
            "explanation": explanation,
        }

    def _explain(self, text: str, class_index: int) -> list[dict[str, float | str]]:
        if self.pipeline is None:
            return []
        vectorizer = self.pipeline.named_steps["vectorizer"]
        classifier = self.pipeline.named_steps["classifier"]
        vector = vectorizer.transform([text])
        feature_names = vectorizer.get_feature_names_out()

        coefficients = classifier.coef_[class_index]
        dense_vector = vector.toarray()[0]
        contributions = dense_vector * coefficients
        active = np.flatnonzero(dense_vector)
        ranked = sorted(active, key=lambda idx: abs(contributions[idx]), reverse=True)[:5]
        return [
            {
                "term": str(feature_names[idx]),
                "contribution": round(float(contributions[idx]), 4),
            }
            for idx in ranked
        ]

