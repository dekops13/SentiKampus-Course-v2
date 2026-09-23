#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mobile_dir="$(cd "$script_dir/.." && pwd)"
backup_dir="$(mktemp -d)"

cleanup() {
  rm -rf "$backup_dir"
}
trap cleanup EXIT

cd "$mobile_dir"
cp -R lib test "$backup_dir/"
cp pubspec.yaml analysis_options.yaml README.md "$backup_dir/"

flutter create --project-name sentikampus_mobile --platforms=android .

cp -R "$backup_dir/lib/." lib/
cp -R "$backup_dir/test/." test/
cp "$backup_dir/pubspec.yaml" pubspec.yaml
cp "$backup_dir/analysis_options.yaml" analysis_options.yaml
cp "$backup_dir/README.md" README.md
flutter pub get

echo "Platform Android selesai dibuat."
echo "Baca README.md untuk menentukan API_BASE_URL."

