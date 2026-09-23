from __future__ import annotations

import json
import sys
from pathlib import Path

BACKEND_DIR = Path(__file__).resolve().parents[1]
if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))

from app.evaluation import evaluate_demo_pipeline  # noqa: E402


if __name__ == "__main__":
    report = evaluate_demo_pipeline(BACKEND_DIR / "data" / "training_samples.csv")
    output = BACKEND_DIR / "models" / "evaluation.json"
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps(report, ensure_ascii=False, indent=2))
    print(f"\nLaporan evaluasi disimpan di: {output}")
