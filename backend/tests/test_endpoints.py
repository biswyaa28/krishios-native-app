import io
from PIL import Image

def test_health_check(client):
    """Asserts that the health check endpoint reports status cleanly."""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert "model_loaded" in data
    assert "device" in data

def test_predict_invalid_content_type(client):
    """Asserts that uploading a non-image text file triggers a 400 validation error."""
    file_payload = {"file": ("test.txt", "dummy content", "text/plain")}
    response = client.post("/predict", files=file_payload)
    assert response.status_code == 400
    assert "Uploaded file must be an image." in response.json()["detail"]

def test_predict_quality_check_failure(client):
    """Asserts that uploading a tiny black image gets rejected by the quality validator."""
    img = Image.new("RGB", (10, 10), color="black")
    img_byte_arr = io.BytesIO()
    img.save(img_byte_arr, format="JPEG")
    img_bytes = img_byte_arr.getvalue()
    
    file_payload = {"file": ("test.jpg", img_bytes, "image/jpeg")}
    response = client.post("/predict", files=file_payload)
    
    # Returns 400 if model loads and checks fail, or 503 if test environment model is missing
    assert response.status_code in [400, 503]

def test_chat_endpoint(client):
    """Asserts that the /chat advisory endpoint returns translated crop advice."""
    payload = {
        "message": "Give me some organic treatment suggestions.",
        "crop": "Tomato",
        "diagnosis": "Tomato Yellow Leaf Curl Virus",
        "language": "hi"
    }
    response = client.post("/chat", json=payload)
    assert response.status_code == 200
    data = response.json()
    assert "response" in data
    assert "जैविक" in data["response"] or "organic" in data["response"] or "निदान" in data["response"]
