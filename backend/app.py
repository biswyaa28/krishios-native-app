import os
import io
import json
import logging
from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from config import settings

# Import AI Gateway classes safely
from services.ai_gateway import AIGateway
from services.image_validator import ImageQualityValidator
from services.leaf_detector import YoloLeafDetector
from services.disease_classifier import PytorchDiseaseClassifier, FallbackDiseaseClassifier

logger = logging.getLogger("uvicorn.error")

try:
    import torch
    TORCH_AVAILABLE = True
except Exception as e:
    torch = None
    TORCH_AVAILABLE = False
    logger.warning(f"PyTorch native DLLs blocked by Windows Policy ({e}). Backend running with Agronomy AI Fallback Engine.")

app = FastAPI(
    title="KrishiOS AI Inference Backend",
    description="REST API for real-time crop disease diagnosis",
    version="1.0.0"
)

# Enable CORS for cross-platform clients (Flutter web/mobile) using config origins
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_CORS_ORIGINS,
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load class names mapping dynamically from JSON config
CLASS_NAMES_PATH = os.path.join(os.path.dirname(__file__), "services", "class_names.json")
try:
    with open(CLASS_NAMES_PATH, "r") as f:
        CLASS_NAMES = json.load(f)
except Exception as e:
    logger.error(f"Failed to load class_names.json from {CLASS_NAMES_PATH}: {e}")
    CLASS_NAMES = ["Tomato Early Blight", "Apple Scab", "Rice Leaf Blight", "Wheat Yellow Rust"]

# Initialize AI Gateway Stages
quality_validator = ImageQualityValidator()
leaf_detector = YoloLeafDetector(model_path=settings.LEAF_DETECTOR_PATH)

model = None
MODEL_PATH = settings.CLASSIFIER_PATH_TS if os.path.exists(settings.CLASSIFIER_PATH_TS) else settings.CLASSIFIER_PATH_PT

if TORCH_AVAILABLE and os.path.exists(MODEL_PATH):
    try:
        model = torch.jit.load(MODEL_PATH, map_location=torch.device("cpu"))
        model.eval()
        logger.info(f"Successfully loaded TorchScript model from {MODEL_PATH}")
    except Exception as e:
        logger.error(f"Failed to load TorchScript model from {MODEL_PATH}: {e}")
        model = None

if model is not None and TORCH_AVAILABLE:
    classifier = PytorchDiseaseClassifier(model, CLASS_NAMES)
else:
    logger.info("Using Fallback Agronomy Disease Classifier.")
    classifier = FallbackDiseaseClassifier(CLASS_NAMES)

gateway = AIGateway(quality_validator, leaf_detector, classifier)

@app.get("/health")
def health_check():
    """Verify backend and model loaded status."""
    return {
        "status": "healthy",
        "model_loaded": classifier is not None,
        "engine": "PyTorch C++ CPU" if (model is not None and TORCH_AVAILABLE) else "KrishiOS Agronomy Engine",
        "device": "cpu"
    }

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    """Diagnose crop disease from uploaded image file, executing the full validation pipeline."""
    if file.content_type and not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="Uploaded file must be an image.")

    try:
        image_data = await file.read()
        
        # Process image through AI Gateway pipeline
        result = await gateway.process_image(image_data)
        
        if not result["success"]:
            raise HTTPException(status_code=400, detail=result["message"])
            
        return {
            "prediction": result["prediction"],
            "confidence": result["confidence"],
            "class_index": result.get("class_index", 0),
            "health_score": result.get("health_score", 75.0),
            "metadata": result.get("metadata", {})
        }

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Inference error: {str(e)}")

@app.post("/detect_leaf")
async def detect_leaf(file: UploadFile = File(...)):
    """Run validation pipeline up to leaf detection (without running classification)."""
    if file.content_type and not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="Uploaded file must be an image.")

    try:
        image_data = await file.read()
        
        # Stage 1: Quality Validation
        quality_res = await quality_validator.validate(image_data)
        if not quality_res.success:
            return {
                "success": False,
                "stage": "quality_validation",
                "confidence": quality_res.confidence,
                "message": quality_res.message,
                "metadata": quality_res.metadata
            }
            
        # Stage 2: Leaf Detection
        detect_res = await leaf_detector.detect(image_data)
        return {
            "success": detect_res.success,
            "stage": "leaf_detection",
            "confidence": detect_res.confidence,
            "message": detect_res.message,
            "metadata": detect_res.metadata
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Detection error: {str(e)}")

from pydantic import BaseModel

class ChatRequest(BaseModel):
    message: str
    crop: str
    diagnosis: str
    language: str = "en"

@app.post("/chat")
async def chat(request: ChatRequest):
    """Agricultural AI advisory chatbot endpoint supporting localization."""
    msg = request.message.lower()
    crop = request.crop
    diagnosis = request.diagnosis
    lang = request.language

    response = ""
    
    # Generic agricultural AI agent responses
    if lang == "hi":
        response = f"निदान: {crop} ({diagnosis})। आपके प्रश्न '{request.message}' के संबंध में कृषि विशेषज्ञ की सलाह:\n\n"
        if "जैविक" in msg or "organic" in msg:
            response += "• संक्रमित पत्तियों को नष्ट करें और खेत की साफ-सफाई रखें। नीम का तेल (Neem oil) 5 मिली/लीटर पानी में मिलाकर 7-10 दिनों के अंतराल पर छिड़कें।"
        elif "रासायनिक" in msg or "chemical" in msg:
            response += "• यदि प्रकोप गंभीर हो, तो मैन्कोज़ेब (Mancozeb) या कॉपर ऑक्सीक्लोराइड 2.5 ग्राम प्रति लीटर पानी में मिलाकर स्प्रे करें।"
        elif "बचाव" in msg or "रोकथाम" in msg or "prevent" in msg:
            response += "• स्वस्थ प्रमाणित बीज बोएं। फसल चक्र अपनाएं और सिंचाई केवल शाम या सुबह के समय सीधे जड़ों में करें।"
        else:
            response += "• पौधों की नियमित जांच करें और पर्याप्त सूर्य का प्रकाश सुनिश्चित करें। जैविक उर्वरकों का उपयोग कर पौधों की प्रतिरोधक क्षमता बढ़ाएं।"
    elif lang == "te":
        response = f"వ్యాధి నిర్ధారణ: {crop} ({diagnosis})। మీ ప్రశ్న '{request.message}' పై కృషిఅసిస్టెంట్ సలహా:\n\n"
        if "సేంద్రీయ" in msg or "organic" in msg:
            response += "• వ్యాధి సోకిన ఆకులను తీసివేయండి. లీటరు నీటికి 5 మి.లీ వేప నూనె కలిపి ప్రతి 7-10 రోజులకు ఒకసారి స్ప్రే చేయండి."
        elif "రసాయన" in msg or "chemical" in msg:
            response += "• తెగులు తీవ్రంగా ఉంటే, లీటరు నీటికి 2.5 గ్రాముల మ్యాంకోజెబ్ లేదా కాపర్ ఆక్సిక్లోరైడ్ కలిపి పిచికారీ చేయండి."
        elif "నివారణ" in msg or "prevent" in msg:
            response += "• ధృవీకరించబడిన ఆరోగ్యకరమైన విత్తనాలను వాడండి. పంట మార్పిడి పద్ధతిని పాటించండి మరియు తేమ నిలువకుండా చూసుకోండి."
        else:
            response += "• మొక్కలకు తగినంత సూర్యరశ్మి మరియు గాలి తగిలేలా చూసుకోండి. సేంద్రీయ ఎరువులు వాడి పంట రోగ నిరోధక శక్తిని పెంచండి."
    else:
        # Default English
        response = f"Advisory for {crop} showing symptoms of {diagnosis} regarding '{request.message}':\n\n"
        if "organic" in msg:
            response += "• Remove and burn infected foliage immediately. Apply organic neem oil spray (5ml/L) or copper-based soaps every 7-10 days."
        elif "chemical" in msg or "pesticide" in msg:
            response += "• For severe outbreaks, apply broad-spectrum fungicides like Mancozeb or Copper Oxychloride according to package dosage instruction."
        elif "prevent" in msg or "avoid" in msg:
            response += "• Plant disease-resistant varieties, practice strict crop rotation, and water at the base of the plant to keep leaves dry."
        else:
            response += "• Ensure proper plant spacing for ventilation. Keep soil well-drained and enrich it with organic compost to boost disease resistance."

    return {"response": response}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8080)
