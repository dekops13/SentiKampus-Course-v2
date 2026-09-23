from locust import HttpUser, between, task


SAMPLES = [
    "Pelayanan akademik sangat membantu",
    "Internet kampus sering terputus",
    "Kuliah dimulai pukul delapan",
]


class SentiKampusUser(HttpUser):
    wait_time = between(0.5, 1.5)

    def on_start(self) -> None:
        self.index = 0

    @task(4)
    def predict(self) -> None:
        text = SAMPLES[self.index % len(SAMPLES)]
        self.index += 1
        self.client.post(
            "/api/v1/predict",
            json={"text": text, "week": 13, "include_explanation": False},
            name="POST /api/v1/predict",
        )

    @task(1)
    def health(self) -> None:
        self.client.get("/health", name="GET /health")

