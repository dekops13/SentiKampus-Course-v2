from __future__ import annotations

import logging
import time
import uuid
from contextlib import asynccontextmanager
from pathlib import Path
from typing import AsyncIterator

from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware

from app.config import BACKEND_DIR, Settings, get_settings
from app.course_weeks import COURSE_WEEKS, get_week
from app.model_service import ModelService
from app.monitoring import MetricsStore
from app.schemas import HealthResponse, PredictionRequest, PredictionResponse


def create_app(settings: Settings | None = None) -> FastAPI:
    active_settings = settings or get_settings()
    logging.basicConfig(level=active_settings.log_level)
    metrics = MetricsStore()
    model_service = ModelService(
        model_path=active_settings.model_path,
        metadata_path=active_settings.metadata_path,
        data_path=BACKEND_DIR / "data" / "training_samples.csv",
    )

    @asynccontextmanager
    async def lifespan(application: FastAPI) -> AsyncIterator[None]:
        model_service.load_or_train()
        application.state.model_service = model_service
        application.state.metrics = metrics
        yield

    application = FastAPI(
        title="SentiKampus API",
        version="1.0.0",
        description=(
            "API demonstrasi analisis sentimen masukan mahasiswa. "
            "Model bersifat edukatif dan tidak untuk keputusan administratif."
        ),
        lifespan=lifespan,
    )
    application.add_middleware(
        CORSMiddleware,
        allow_origins=active_settings.allowed_origins,
        allow_credentials=False,
        allow_methods=["GET", "POST"],
        allow_headers=["*"],
    )

    @application.middleware("http")
    async def attach_observability(request: Request, call_next):
        trace_id = request.headers.get("X-Trace-Id", str(uuid.uuid4()))
        request.state.trace_id = trace_id
        started = time.perf_counter()
        response = await call_next(request)
        response.headers["X-Trace-Id"] = trace_id
        response.headers["X-Process-Time-Ms"] = f"{(time.perf_counter() - started) * 1000:.2f}"
        return response

    @application.get("/", tags=["system"])
    def root() -> dict[str, str]:
        return {
            "name": "SentiKampus API",
            "message": "Buka /docs untuk mencoba API secara interaktif.",
        }

    @application.get("/health", response_model=HealthResponse, tags=["system"])
    def health() -> HealthResponse:
        return HealthResponse(
            status="ok" if model_service.is_loaded else "degraded",
            model_loaded=model_service.is_loaded,
            model_version=model_service.version,
        )

    @application.get("/api/v1/course/weeks", tags=["course"])
    def list_course_weeks() -> list[dict[str, object]]:
        return COURSE_WEEKS

    @application.get("/api/v1/course/weeks/{week}", tags=["course"])
    def course_week(week: int) -> dict[str, object]:
        result = get_week(week)
        if result is None:
            raise HTTPException(status_code=404, detail="Pertemuan tidak ditemukan.")
        return result

    @application.post(
        "/api/v1/predict",
        response_model=PredictionResponse,
        tags=["sentiment"],
    )
    def predict(payload: PredictionRequest, request: Request) -> PredictionResponse:
        started = time.perf_counter()
        trace_id = request.state.trace_id
        try:
            week = get_week(payload.week)
            if week is None:
                raise HTTPException(status_code=404, detail="Pertemuan tidak ditemukan.")
            result = model_service.predict(
                payload.text,
                include_explanation=payload.include_explanation or payload.week >= 7,
            )
            latency_ms = (time.perf_counter() - started) * 1000
            metrics.record(
                label=str(result["label"]),
                latency_ms=latency_ms,
                success=True,
                trace_id=trace_id,
            )
            return PredictionResponse(
                label=str(result["label"]),
                score=float(result["score"]),
                probabilities={
                    str(key): float(value)
                    for key, value in result["probabilities"].items()
                },
                model_version=model_service.version,
                latency_ms=round(latency_ms, 2),
                explanation=result["explanation"],
                capabilities=list(week["capabilities"]),
                trace_id=trace_id,
            )
        except HTTPException:
            raise
        except Exception as exc:
            latency_ms = (time.perf_counter() - started) * 1000
            metrics.record("error", latency_ms, False, trace_id)
            logging.exception("Prediksi gagal")
            raise HTTPException(status_code=500, detail="Prediksi gagal diproses.") from exc

    @application.get("/api/v1/metrics", tags=["monitoring"])
    def current_metrics() -> dict[str, object]:
        return metrics.snapshot()

    @application.post("/api/v1/metrics/reset", tags=["monitoring"])
    def reset_metrics() -> dict[str, str]:
        metrics.reset()
        return {"message": "Metrik demonstrasi telah direset."}

    return application


app = create_app()

