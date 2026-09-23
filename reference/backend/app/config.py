from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path


BACKEND_DIR = Path(__file__).resolve().parents[1]


@dataclass(frozen=True)
class Settings:
    model_path: Path
    metadata_path: Path
    allowed_origins: list[str]
    log_level: str


def _resolve_path(value: str | None, fallback: Path) -> Path:
    if not value:
        return fallback
    path = Path(value)
    return path if path.is_absolute() else (BACKEND_DIR.parent / path).resolve()


def get_settings() -> Settings:
    origins = os.getenv("ALLOWED_ORIGINS", "*")
    return Settings(
        model_path=_resolve_path(
            os.getenv("MODEL_PATH"), BACKEND_DIR / "models" / "sentiment.pkl"
        ),
        metadata_path=_resolve_path(
            os.getenv("METADATA_PATH"), BACKEND_DIR / "models" / "metadata.json"
        ),
        allowed_origins=[item.strip() for item in origins.split(",") if item.strip()],
        log_level=os.getenv("LOG_LEVEL", "INFO").upper(),
    )

