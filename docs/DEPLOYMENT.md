# Deployment Guide (P6)

Dokumen ini bersifat provider-neutral agar platform dapat disesuaikan dengan kebijakan kelas.

Minimum deployment backend:

1. deploy `reference/backend/Dockerfile`;
2. expose port aplikasi 8000 atau gunakan port yang diwajibkan platform;
3. gunakan `/health` sebagai health check;
4. simpan konfigurasi melalui environment variable, bukan hard-code;
5. gunakan HTTPS untuk URL publik;
6. set `API_BASE_URL` pada Streamlit/Flutter ke URL backend tersebut.

Untuk demo lokal tanpa cloud:

```cmd
docker compose up --build
```

Cloud URL dan kredensial tidak dimasukkan ke repository.
