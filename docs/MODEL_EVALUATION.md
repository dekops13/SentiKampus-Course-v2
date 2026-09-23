# Evaluasi Model Demo

Model baseline menggunakan TF-IDF + Logistic Regression. Dataset hanya 36 kalimat buatan (12 per kelas), sehingga tujuan evaluasi adalah **mengajarkan prosedur**, bukan mengklaim akurasi produksi.

Jalankan:

```cmd
cd reference\backend
python scripts\evaluate_model.py
```

Output menyertakan:

- accuracy;
- macro precision;
- macro recall;
- macro F1;
- confusion matrix;
- metrik per kelas.

Metode default adalah 3-fold stratified cross-validation. Saat modul model dikembangkan lebih lanjut, dataset harus diperbesar, sumber data dan skema anotasi harus didokumentasikan, lalu evaluasi menggunakan split yang mencegah leakage.
