import os
import sys
from pathlib import Path
import pytest

# Add parent backend/ directory to python path
BACKEND_DIR = Path(__file__).resolve().parent.parent
if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(0, str(BACKEND_DIR))

from fastapi.testclient import TestClient
from app import app

@pytest.fixture(scope="module")
def client():
    """Returns a TestClient instance for backend endpoint validation."""
    with TestClient(app) as test_client:
        yield test_client
