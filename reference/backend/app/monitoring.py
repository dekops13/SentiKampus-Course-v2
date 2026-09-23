from __future__ import annotations

from collections import Counter, deque
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from threading import Lock


@dataclass(frozen=True)
class RecentRequest:
    timestamp: str
    label: str
    latency_ms: float
    success: bool
    trace_id: str


def _percentile(values: list[float], percentile: float) -> float:
    if not values:
        return 0.0

    ordered = sorted(values)
    position = (len(ordered) - 1) * percentile
    lower = int(position)
    upper = min(lower + 1, len(ordered) - 1)
    fraction = position - lower

    return ordered[lower] + (ordered[upper] - ordered[lower]) * fraction


class MetricsStore:
    def __init__(self, max_items: int = 500) -> None:
        self._items: deque[RecentRequest] = deque(maxlen=max_items)
        self._lock = Lock()

    def record(
        self,
        label: str,
        latency_ms: float,
        success: bool,
        trace_id: str,
    ) -> None:
        item = RecentRequest(
            timestamp=datetime.now(timezone.utc).isoformat(),
            label=label,
            latency_ms=round(latency_ms, 2),
            success=success,
            trace_id=trace_id,
        )

        with self._lock:
            self._items.append(item)

    def snapshot(self) -> dict[str, object]:
        with self._lock:
            items = list(self._items)

        latencies = [
            item.latency_ms
            for item in items
            if item.success
        ]

        labels = Counter(
            item.label
            for item in items
            if item.success
        )

        errors = sum(
            1
            for item in items
            if not item.success
        )

        total = len(items)

        return {
            "total_requests": total,
            "successful_requests": total - errors,
            "failed_requests": errors,
            "error_rate": round(
                errors / total,
                4
            ) if total else 0.0,
            "latency_ms": {
                "average": round(
                    sum(latencies) / len(latencies),
                    2
                ) if latencies else 0.0,
                "p50": round(
                    _percentile(latencies, 0.50),
                    2
                ),
                "p95": round(
                    _percentile(latencies, 0.95),
                    2
                ),
                "maximum": round(
                    max(latencies),
                    2
                ) if latencies else 0.0,
            },
            "label_distribution": dict(labels),
            "recent": [
                asdict(item)
                for item in items[-10:]
            ][::-1],
        }

    def reset(self) -> None:
        with self._lock:
            self._items.clear()