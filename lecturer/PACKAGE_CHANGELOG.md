# Package Changelog — v2

Perubahan utama dari paket lama:

1. memisahkan `starter/` dan `reference/`;
2. menambahkan Streamlit sebagai frontend web utama P4;
3. memosisikan Flutter Android sebagai ekstensi multi-platform P12;
4. menyamakan baseline Python 3.10, Flutter 3.10.1/Dart 3.x, JDK 17, Android API 33;
5. mengganti Docker base image menjadi Python 3.10;
6. menambahkan evaluasi 3-fold stratified CV, macro metrics, dan confusion matrix;
7. menambahkan distribusi probabilitas pada API contract;
8. mempertahankan monitoring, XAI linear, Locust, pytest, dan course metadata;
9. menambahkan Docker Compose untuk FastAPI + Streamlit;
10. menambahkan panduan build/install APK khusus emulator, tanpa menganggapnya APK produksi.
