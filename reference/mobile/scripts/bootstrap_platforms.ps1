$ErrorActionPreference = "Stop"

$MobileDir = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$BackupDir = Join-Path ([System.IO.Path]::GetTempPath()) ("sentikampus-" + [System.Guid]::NewGuid())
New-Item -ItemType Directory -Path $BackupDir | Out-Null

try {
    Set-Location $MobileDir
    Copy-Item "lib" $BackupDir -Recurse
    Copy-Item "test" $BackupDir -Recurse
    Copy-Item "pubspec.yaml", "analysis_options.yaml", "README.md" $BackupDir

    flutter create --project-name sentikampus_mobile --platforms=android .

    Copy-Item (Join-Path $BackupDir "lib\*") "lib" -Recurse -Force
    Copy-Item (Join-Path $BackupDir "test\*") "test" -Recurse -Force
    Copy-Item (Join-Path $BackupDir "pubspec.yaml") "pubspec.yaml" -Force
    Copy-Item (Join-Path $BackupDir "analysis_options.yaml") "analysis_options.yaml" -Force
    Copy-Item (Join-Path $BackupDir "README.md") "README.md" -Force
    flutter pub get

    Write-Host "Platform Android selesai dibuat."
    Write-Host "Baca README.md untuk menentukan API_BASE_URL."
}
finally {
    if (Test-Path $BackupDir) {
        Remove-Item $BackupDir -Recurse -Force
    }
}

