$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..\reference\backend")
if (-not (Test-Path ".venv")) { python -m venv .venv }
& .\.venv\Scripts\python.exe -m pip install -r requirements.txt -r requirements-dev.txt
& .\.venv\Scripts\python.exe scripts\train_model.py
& .\.venv\Scripts\python.exe -m uvicorn app.main:app --reload
