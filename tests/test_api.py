from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_root():
    response = client.get("/")

    assert response.status_code == 200
    assert response.json()["status"] == "running"


def test_health():
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


def test_readiness():
    response = client.get("/ready")

    assert response.status_code == 200
    assert response.json()["status"] == "ready"


def test_predict():
    response = client.post(
        "/predict",
        json={"text": "production AI platform"},
    )

    assert response.status_code == 200

    data = response.json()

    assert data["prediction"] == "Processed: production AI platform"
    assert data["confidence"] == 0.95
    assert data["model_version"] == "demo-v1"