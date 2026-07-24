import os
import sys
import subprocess
import shutil
from pathlib import Path

def setup_and_download():
    # 1. Install roboflow package dynamically in the active environment
    print("[INFO] Checking / installing 'roboflow' SDK...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "-q", "roboflow"])

    # Import only after installation completes
    from roboflow import Roboflow

    API_KEY = "qWQKJ4ySeV66PQF72BCt"
    DOWNLOAD_DIR = r"O:\Hackthons\KrishiOS\ai\datasets\detection\plantdoc"

    # Make target directory
    Path(DOWNLOAD_DIR).mkdir(parents=True, exist_ok=True)

    print("[INFO] Connecting to Roboflow API...")
    rf = Roboflow(api_key=API_KEY)

    print("[INFO] Fetching PlantDoc dataset project...")
    project = rf.workspace("joseph-nelson").project("plantdoc")
    version = project.version(1)

    print("[INFO] Starting download via Roboflow SDK...")
    dataset = version.download("yolov8")
    downloaded_loc = dataset.location
    print(f"[INFO] Download completed to: {downloaded_loc}")

    # Move to the desired destination if needed
    target_abs = os.path.abspath(DOWNLOAD_DIR)
    source_abs = os.path.abspath(downloaded_loc)

    if target_abs != source_abs:
        print(f"[INFO] Relocating dataset to target directory: {DOWNLOAD_DIR}...")
        if os.path.exists(DOWNLOAD_DIR):
            shutil.rmtree(DOWNLOAD_DIR)
        shutil.move(downloaded_loc, DOWNLOAD_DIR)

    print("\n[SUCCESS] Dataset successfully saved to:")
    print(DOWNLOAD_DIR)

if __name__ == "__main__":
    setup_and_download()
