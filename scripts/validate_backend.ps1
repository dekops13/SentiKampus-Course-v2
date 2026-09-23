$ErrorActionPreference = "Stop"
$Backend = (Resolve-Path (Join-Path $PSScriptRoot "..\reference\backend")).Path
Set-Location $Backend
if (-not (Test-Path ".venv")) { python -m venv .venv }
& .\.venv\Scripts\python.exe -m pip install --upgrade pip
& .\.venv\Scripts\python.exe -m pip install -r requirements.txt -r requirements-dev.txt
& .\.venv\Scripts\python.exe scripts\train_model.py
& .\.venv\Scripts\python.exe scripts\evaluate_model.py
& .\.venv\Scripts\python.exe -m pytest -q
Write-Host "Backend validation selesai."
