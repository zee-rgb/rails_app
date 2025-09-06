import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_root_endpoint():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "AI Service is running"}

def test_analyze_endpoint_positive():
    response = client.post(
        "/analyze",
        json={"text": "I love this! It's amazing!"}
    )
    assert response.status_code == 200
    data = response.json()
    assert "sentiment" in data
    assert "confidence" in data
    assert "processed_text" in data
    assert data["sentiment"] in ["positive", "negative", "neutral"]
    assert 0 <= data["confidence"] <= 1

def test_analyze_endpoint_negative():
    response = client.post(
        "/analyze",
        json={"text": "I hate this! It's terrible!"}
    )
    assert response.status_code == 200
    data = response.json()
    assert data["sentiment"] in ["positive", "negative", "neutral"]

def test_analyze_endpoint_missing_text():
    response = client.post("/analyze", json={})
    assert response.status_code == 422  # Validation error
    assert "field required" in response.text.lower()

# This test requires pytest-mock to be installed
def test_analyze_endpoint_error_handling(mocker):
    # Mock the analysis function to raise an exception
    mocker.patch(
        "main.analyze_text",
        side_effect=Exception("Something went wrong")
    )
    
    response = client.post(
        "/analyze",
        json={"text": "This should fail"}
    )
    
    assert response.status_code == 500
    assert "error" in response.json()
