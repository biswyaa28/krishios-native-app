from pathlib import Path

# The project root of the AI workspace (KrishiOS/ai)
PROJECT_ROOT = Path(__file__).resolve().parent.parent

# Datasets folders
DATASETS_DIR = PROJECT_ROOT / "datasets"
CLASSIFICATION_DATASET_DIR = DATASETS_DIR / "classification" / "plantvillage"
DETECTION_DATASET_DIR = DATASETS_DIR / "detection" / "plantdoc"

# Models folders
MODELS_DIR = PROJECT_ROOT / "models"
CLASSIFIER_MODEL_DIR = MODELS_DIR / "classifier"
DETECTOR_MODEL_DIR = MODELS_DIR / "detector"

# Export folder
EXPORTS_DIR = PROJECT_ROOT / "exports"

def get_project_root() -> Path:
    return PROJECT_ROOT
