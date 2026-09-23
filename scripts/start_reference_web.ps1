$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..\reference\web")
if (-not (Test-Path ".venv")) { python -m venv .venv }
& .\.venv\Scripts\python.exe -m pip install -r requirements.txt
$env:API_BASE_URL = "http://127.0.0.1:8000"
& .\.venv\Scripts\python.exe -m streamlit run app.py
