import os
from pathlib import Path
from typing import List

# Resolve directory locations dynamically
BACKEND_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = BACKEND_DIR.parent

try:
    from pydantic_settings import BaseSettings, SettingsConfigDict
    
    class Settings(BaseSettings):
        """Centralized production-ready settings class using pydantic-settings."""
        ALLOWED_CORS_ORIGINS: List[str] = ["*"]
        MODEL_DIR: str = str(PROJECT_ROOT / "ai" / "models")
        API_AUTH_TOKEN: str = ""
        
        @property
        def CLASSIFIER_PATH_TS(self) -> str:
            return os.path.join(self.MODEL_DIR, "classifier", "model.ts")
            
        @property
        def CLASSIFIER_PATH_PT(self) -> str:
            return os.path.join(self.MODEL_DIR, "classifier", "model.pt")
            
        @property
        def LEAF_DETECTOR_PATH(self) -> str:
            return os.path.join(self.MODEL_DIR, "detector", "leaf_detector.pt")
            
        @property
        def COCO_DETECTOR_PATH(self) -> str:
            return os.path.join(self.MODEL_DIR, "detector", "yolov8n.pt")

        model_config = SettingsConfigDict(
            env_file=str(BACKEND_DIR / ".env"),
            env_file_encoding="utf-8",
            extra="ignore"
        )
    settings = Settings()

except ImportError:
    class FallbackSettings:
        """Fallback settings class to guarantee execution if requirements are not yet installed."""
        def __init__(self):
            origins = os.getenv("ALLOWED_CORS_ORIGINS", "*")
            self.ALLOWED_CORS_ORIGINS = [o.strip() for o in origins.split(",")] if origins else ["*"]
            self.MODEL_DIR = os.getenv("MODEL_DIR", str(PROJECT_ROOT / "ai" / "models"))
            self.API_AUTH_TOKEN = os.getenv("API_AUTH_TOKEN", "")
            
        @property
        def CLASSIFIER_PATH_TS(self) -> str:
            return os.path.join(self.MODEL_DIR, "classifier", "model.ts")
            
        @property
        def CLASSIFIER_PATH_PT(self) -> str:
            return os.path.join(self.MODEL_DIR, "classifier", "model.pt")
            
        @property
        def LEAF_DETECTOR_PATH(self) -> str:
            return os.path.join(self.MODEL_DIR, "detector", "leaf_detector.pt")
            
        @property
        def COCO_DETECTOR_PATH(self) -> str:
            return os.path.join(self.MODEL_DIR, "detector", "yolov8n.pt")
            
    settings = FallbackSettings()
print(f"[INFO] Settings initialized. Model Directory: {settings.MODEL_DIR}")
