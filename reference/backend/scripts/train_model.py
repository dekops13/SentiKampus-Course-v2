from __future__ import annotations

import argparse
import sys
from pathlib import Path


BACKEND_DIR = Path(__file__).resolve().parents[1]
if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))

from app.training import persist_demo_model  # noqa: E402


def main() -> None:
    parser = argparse.ArgumentParser(description="Melatih model demonstrasi SentiKampus.")
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=BACKEND_DIR / "models",
        help="Folder penyimpanan sentiment.pkl dan metadata.json.",
    )
    args = parser.parse_args()
    metadata = persist_demo_model(
        csv_path=BACKEND_DIR / "data" / "training_samples.csv",
        model_path=args.output_dir / "sentiment.pkl",
        metadata_path=args.output_dir / "metadata.json",
    )
    print("Model demonstrasi berhasil dibuat.")
    print(f"Versi model: {metadata['model_version']}")
    print(f"Jumlah contoh: {metadata['training_samples']}")
    print(f"Lokasi: {args.output_dir.resolve()}")


if __name__ == "__main__":
    main()

