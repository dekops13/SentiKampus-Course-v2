from __future__ import annotations

from pydantic import BaseModel, Field, field_validator


class PredictionRequest(BaseModel):
    text: str = Field(min_length=3, max_length=500, examples=["Pelayanan akademik sangat membantu"])
    week: int = Field(default=4, ge=1, le=16)
    include_explanation: bool = False

    @field_validator("text")
    @classmethod
    def normalize_text(cls, value: str) -> str:
        cleaned = " ".join(value.split())
        if len(cleaned) < 3:
            raise ValueError("Teks harus berisi sedikitnya 3 karakter bermakna.")
        return cleaned


class ExplanationItem(BaseModel):
    term: str
    contribution: float


class PredictionResponse(BaseModel):
    label: str
    score: float
    probabilities: dict[str, float]
    model_version: str
    latency_ms: float
    explanation: list[ExplanationItem]
    capabilities: list[str]
    trace_id: str
    source: str = "api"


class HealthResponse(BaseModel):
    status: str
    model_loaded: bool
    model_version: str

