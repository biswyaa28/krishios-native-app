import io
import os
from PIL import Image, ImageStat, ImageFilter
from .ai_gateway import AIStageResponse

class ImageQualityValidator:
    """Validates image clarity, lighting, exposure, and filters out non-plant objects (like humans or animals)."""

    def __init__(self, blur_threshold: float = 30.0, low_light_threshold: float = 30.0, high_light_threshold: float = 245.0):
        self.blur_threshold = blur_threshold
        self.low_light_threshold = low_light_threshold
        self.high_light_threshold = high_light_threshold
        self.yolo_coco = None

        # Load pre-trained COCO YOLOv8n to identify and filter out humans/animals/vehicles
        try:
            from ultralytics import YOLO
            # Cache the model file in the models folder
            model_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "ai", "models", "detector"))
            os.makedirs(model_dir, exist_ok=True)
            model_path = os.path.join(model_dir, "yolov8n.pt")
            
            # This will load it if it exists locally, or download it to the cached path automatically
            self.yolo_coco = YOLO(model_path)
            print(f"[INFO] Loaded COCO YOLOv8n object filter from {model_path}")
        except Exception as e:
            print(f"[WARN] Failed to load COCO YOLO model: {e}. Non-leaf filtering will be inactive.")

    async def validate(self, image_bytes: bytes) -> AIStageResponse:
        try:
            # Load PIL Image
            image = Image.open(io.BytesIO(image_bytes))
            
            # 1. Human / Animal check using COCO model
            if self.yolo_coco is not None:
                try:
                    results = self.yolo_coco(image, verbose=False)[0]
                    for box in results.boxes:
                        cls_id = int(box.cls[0].item())
                        conf = float(box.conf[0].item())
                        
                        if conf > 0.45:
                            if cls_id == 0:  # Person class index is 0 in COCO
                                return AIStageResponse(
                                    success=False,
                                    confidence=conf,
                                    message="Human detected. Please scan a crop leaf instead.",
                                    metadata={"detected_class": "person"}
                                )
                            elif 14 <= cls_id <= 23:  # Bird, Cat, Dog, Horse, Sheep, Cow, Elephant, Bear, Zebra, Giraffe
                                return AIStageResponse(
                                    success=False,
                                    confidence=conf,
                                    message="Animal detected. Please scan a crop leaf instead.",
                                    metadata={"detected_class": "animal"}
                                )
                except Exception as e:
                    print(f"[WARN] COCO object validation failed: {e}")

            # 2. Check Brightness / Exposure using Grayscale Mean
            gray_img = image.convert("L")
            stat = ImageStat.Stat(gray_img)
            mean_brightness = stat.mean[0]

            if mean_brightness < self.low_light_threshold:
                return AIStageResponse(
                    success=False,
                    confidence=0.0,
                    message="Improve lighting (image is too dark).",
                    metadata={"brightness": mean_brightness}
                )
            
            if mean_brightness > self.high_light_threshold:
                return AIStageResponse(
                    success=False,
                    confidence=0.0,
                    message="Reduce exposure (image is too bright/overexposed).",
                    metadata={"brightness": mean_brightness}
                )

            # 3. Check Blur Score (Laplacian/Edge Variance)
            blur_score = 0.0
            try:
                import cv2
                import numpy as np
                nparr = np.frombuffer(image_bytes, np.uint8)
                cv_img = cv2.imdecode(nparr, cv2.IMREAD_GRAYSCALE)
                if cv_img is not None:
                    blur_score = cv2.Laplacian(cv_img, cv2.CV_64F).var()
                else:
                    raise ImportError("Failed to decode CV2 image.")
            except ImportError:
                # PIL Fallback: Apply edge find filter and calculate standard variance
                edge_img = gray_img.filter(ImageFilter.FIND_EDGES)
                stat_edge = ImageStat.Stat(edge_img)
                blur_score = stat_edge.var[0] * 0.4
                print(f"[INFO] Using PIL fallback for blur detection. Calculated score: {blur_score:.2f}")

            if blur_score < self.blur_threshold:
                return AIStageResponse(
                    success=False,
                    confidence=0.0,
                    message="Image is blurry. Please hold steady.",
                    metadata={"blur_score": blur_score, "brightness": mean_brightness}
                )

            return AIStageResponse(
                success=True,
                confidence=1.0,
                message="Image quality passed validation.",
                metadata={"blur_score": blur_score, "brightness": mean_brightness}
            )

        except Exception as e:
            return AIStageResponse(
                success=False,
                confidence=0.0,
                message=f"Quality check error: {str(e)}"
            )
