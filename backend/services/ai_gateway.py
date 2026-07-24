from typing import Dict, Any, Optional
from pydantic import BaseModel

class AIStageResponse(BaseModel):
    success: bool
    confidence: float
    message: str
    metadata: Dict[str, Any] = {}

class AIGateway:
    """Orchestrates computer vision and classification pipeline stages."""
    
    def __init__(self, quality_validator: Any, leaf_detector: Any, disease_classifier: Any):
        self.quality_validator = quality_validator
        self.leaf_detector = leaf_detector
        self.disease_classifier = disease_classifier

    async def process_image(self, image_bytes: bytes) -> Dict[str, Any]:
        """Runs the entire pipeline sequentially:
        Image Quality -> Leaf Detection -> Disease Classification
        """
        # Stage 1: Image Quality Validation
        quality_res = await self.quality_validator.validate(image_bytes)
        if not quality_res.success:
            return {
                "stage": "quality_validation",
                "success": False,
                "confidence": quality_res.confidence,
                "message": quality_res.message,
                "metadata": quality_res.metadata
            }

        # Stage 2: Leaf Detection
        detection_res = await self.leaf_detector.detect(image_bytes)
        if not detection_res.success:
            return {
                "stage": "leaf_detection",
                "success": False,
                "confidence": detection_res.confidence,
                "message": detection_res.message,
                "metadata": detection_res.metadata
            }

        # Stage 3: Disease Classification
        # Only reached if quality & leaf detector passed successfully
        # Use the bounding box from Stage 2 if available to crop the leaf
        cropped_image_bytes = image_bytes
        bbox = detection_res.metadata.get("bounding_box")
        if bbox:
            try:
                from PIL import Image
                import io
                image = Image.open(io.BytesIO(image_bytes))
                w, h = image.size
                
                # Bounding box is typically normalized [x_min, y_min, x_max, y_max]
                x_min = int(bbox[0] * w)
                y_min = int(bbox[1] * h)
                x_max = int(bbox[2] * w)
                y_max = int(bbox[3] * h)
                
                # Ensure valid coordinates
                x_min = max(0, min(x_min, w - 1))
                y_min = max(0, min(y_min, h - 1))
                x_max = max(x_min + 1, min(x_max, w))
                y_max = max(y_min + 1, min(y_max, h))
                
                cropped_img = image.crop((x_min, y_min, x_max, y_max))
                img_byte_arr = io.BytesIO()
                cropped_img.save(img_byte_arr, format=image.format or 'JPEG')
                cropped_image_bytes = img_byte_arr.getvalue()
                print("[INFO] Successfully cropped leaf for classification.")
            except Exception as e:
                print(f"[WARN] Failed to crop image: {e}. Processing original image.")

        classification_res = await self.disease_classifier.classify(cropped_image_bytes)
        
        return {
            "stage": "disease_classification",
            "success": True,
            "prediction": classification_res.metadata.get("prediction"),
            "confidence": classification_res.confidence,
            "class_index": classification_res.metadata.get("class_index"),
            "health_score": classification_res.metadata.get("health_score"),
            "message": "Diagnosis completed successfully.",
            "metadata": {
                "quality": quality_res.metadata,
                "detection": detection_res.metadata,
                "classification": classification_res.metadata
            }
        }
