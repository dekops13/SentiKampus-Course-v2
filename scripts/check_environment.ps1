$ErrorActionPreference = "Continue"
Write-Host "=== SentiKampus Environment Check ==="
python --version
git --version
docker --version
flutter --version
java -version
flutter doctor -v
flutter devices
