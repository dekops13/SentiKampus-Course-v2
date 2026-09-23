$ErrorActionPreference = "Stop"

$ProjectDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
Set-Location (Join-Path $ProjectDir "backend")

if (-not (Test-Path ".venv")) {
    python -m venv .venv
}

& ".\.venv\Scripts\Activate.ps1"
pip install -r requirements.txt -r requirements-dev.txt
python scripts/train_model.py
uvicorn app.main:app --reload

