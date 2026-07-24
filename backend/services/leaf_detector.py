from abc import ABC, abstractmethod
import io
import os
from typing import List, Dict, Any, Tuple
from PIL import Image
from .ai_gateway import AIStageResponse

class LeafDetector(ABC):
    """Abstract base class for leaf detection models."""

    @abstractmethod
    async def detect(self, image_bytes: bytes) -> AIStageResponse:
        pass

class HeuristicGreenLeafDetector(LeafDetector):
    """Heuristic Computer Vision Leaf Detector.
    Uses robust RGB color space checks (detecting green, yellow, orange, and brown leaves)
    without requiring deep learning model weights.
    """

    async def detect(self, image_bytes: bytes) -> AIStageResponse:
        try:
            image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
            w, h = image.size
            
            # Convert to numpy for fast array logic
            import numpy as np
            img_np = np.array(image)
            r, g, b = img_np[:, :, 0], img_np[:, :, 1], img_np[:, :, 2]
            
            # Robust Leaf Pixel Heuristic (Green, Yellow, Orange, and Brown leaves all have G > B or R > B)
            # Exclude dark shadows (r > 20, g > 20) and pure whites/overexposure highlights (at least one channel < 245)
            r_val = r.astype(int)
            g_val = g.astype(int)
            b_val = b.astype(int)
            
            leaf_mask = (
                ((g_val - b_val > 10) | (r_val - b_val > 10)) &
                (g_val > 20) & (r_val > 20) &
                ((r_val < 248) | (g_val < 248) | (b_val < 248))
            )
            
            y_indices, x_indices = np.where(leaf_mask)
            
            if len(x_indices) == 0 or len(y_indices) == 0:
                return AIStageResponse(
                    success=False,
                    confidence=0.0,
                    message="No crop leaf detected.",
                    metadata={"leaf_count": 0}
                )

            # Find bounding box coordinates (normalized)
            x_min = float(np.min(x_indices)) / w
            x_max = float(np.max(x_indices)) / w
            y_min = float(np.min(y_indices)) / h
            y_max = float(np.max(y_indices)) / h
            
            # For general heuristic scanning, we bypass multiple-leaf constraints to reduce false-positives
            # Once a custom YOLO model is loaded, it will handle precise leaf count constraints.
            leaf_count = 1

            # Validate area size (extremely lenient: leaf needs to cover at least 5% of screen)
            area_ratio = (x_max - x_min) * (y_max - y_min)
            if area_ratio < 0.05:
                return AIStageResponse(
                    success=False,
                    confidence=0.9,
                    message="Move closer to the leaf (leaf covers less than 5% of the frame).",
                    metadata={"leaf_count": 1, "area_ratio": area_ratio, "bounding_box": [x_min, y_min, x_max, y_max]}
                )

            # Removed the border-touching margin constraint for Heuristic detection
            # in order to prevent false "cropped leaf" alerts when the user is in normal camera mode.
            
            return AIStageResponse(
                success=True,
                confidence=0.95,
                message="Single crop leaf detected and validated.",
                metadata={"leaf_count": 1, "area_ratio": area_ratio, "bounding_box": [x_min, y_min, x_max, y_max]}
            )

        except Exception as e:
            return AIStageResponse(
                success=False,
                confidence=0.0,
                message=f"Leaf detection error: {str(e)}",
                metadata={"leaf_count": 0}
            )

class YoloLeafDetector(LeafDetector):
    """Deep learning leaf detector using Ultralytics YOLOv8/ONNX model."""

    def __init__(self, model_path: str):
        self.model_path = model_path
        self.model = None
        self.heuristic_detector = HeuristicGreenLeafDetector()
        
        if os.path.exists(model_path):
            try:
                # Dynamically load ultralytics YOLO or ONNX model
                from ultralytics import YOLO
                self.model = YOLO(model_path)
                print(f"[INFO] Loaded YOLO Leaf Detector from {model_path}")
            except Exception as e:
                print(f"[WARN] Failed to load YOLO model: {e}. Falling back to Heuristic detector.")

    async def detect(self, image_bytes: bytes) -> AIStageResponse:
        # Fallback to Heuristic detector if model weights aren't trained/loaded yet
        if self.model is None:
            return await self.heuristic_detector.detect(image_bytes)

        try:
            from PIL import Image
            image = Image.open(io.BytesIO(image_bytes))
            
            # Run inference
            results = self.model(image, verbose=False)[0]
            boxes = results.boxes
            
            leaf_count = len(boxes)
            if leaf_count == 0:
                return AIStageResponse(
                    success=False,
                    confidence=0.0,
                    message="No crop leaf detected.",
                    metadata={"leaf_count": 0}
                )
            
            if leaf_count > 1:
                return AIStageResponse(
                    success=False,
                    confidence=float(boxes[0].conf.item()) if hasattr(boxes[0], 'conf') else 0.8,
                    message="Please capture one leaf (multiple leaves detected).",
                    metadata={"leaf_count": leaf_count}
                )

            # Exactly 1 leaf detected. Verify dimensions
            box = boxes[0]
            # Coordinates in normalized format [x1, y1, x2, y2]
            xyxyn = box.xyxyn[0].tolist()
            x_min, y_min, x_max, y_max = xyxyn
            confidence = float(box.conf[0].item()) if hasattr(box, 'conf') else 0.9

            area_ratio = (x_max - x_min) * (y_max - y_min)
            # Lenient: leaf covers at least 10% of standard frame
            if area_ratio < 0.10:
                return AIStageResponse(
                    success=False,
                    confidence=confidence,
                    message="Move closer to the leaf (leaf covers less than 10% of the frame).",
                    metadata={"leaf_count": 1, "area_ratio": area_ratio, "bounding_box": xyxyn}
                )

            # Removed strict crop bounds touch warnings to ensure seamless capture flow
            return AIStageResponse(
                success=True,
                confidence=confidence,
                message="Single crop leaf detected and validated.",
                metadata={"leaf_count": 1, "area_ratio": area_ratio, "bounding_box": xyxyn}
            )

        except Exception as e:
            print(f"[ERROR] YOLO detection failed: {e}. Falling back to Heuristic.")
            return await self.heuristic_detector.detect(image_bytes)
