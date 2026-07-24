export interface DemoSample {
  id: string;
  specimenNumber: string;
  cropName: string;
  expectedLabel: string;
  predictedLabel: string;
  confidence: number;
  healthScore: number;
  severity: "High" | "Medium" | "None";
  remedy: string;
  imagePath: string;
  source: string;
  verified: boolean;
}

export const DEMO_SAMPLES: DemoSample[] = [
  {
    id: "apple-scab",
    specimenNumber: "01",
    cropName: "Apple",
    expectedLabel: "Apple Scab (Venturia inaequalis)",
    predictedLabel: "Apple___Apple_scab",
    confidence: 0.9982,
    healthScore: 32.0,
    severity: "High",
    remedy: "Apply recommended copper-based organic fungicide or sulfur spray during bud break; prune infected foliage to prevent spore proliferation.",
    imagePath: "/presentation/samples/apple_scab.jpg?v=3",
    source: "ai/datasets/classification/plantvillage/train/Apple___Apple_scab/0c620ec5-11cf-4120-94ab-1311e99df147___FREC_Scab 3131.JPG",
    verified: true,
  },
  {
    id: "tomato-blight",
    specimenNumber: "02",
    cropName: "Tomato",
    expectedLabel: "Tomato Early Blight (Alternaria solani)",
    predictedLabel: "Tomato___Early_blight",
    confidence: 0.9645,
    healthScore: 27.0,
    severity: "High",
    remedy: "Apply organic neem oil spray (5ml/L) or copper hydroxide fungicide according to ICAR guidelines.",
    imagePath: "/presentation/samples/tomato_blight.jpg?v=3",
    source: "ai/datasets/classification/plantvillage/train/Tomato___Early_blight/0012b9d2-2130-4a06-a834-b1f3af34f57e___RS_Erly.B 8389.JPG",
    verified: true,
  },
  {
    id: "potato-healthy",
    specimenNumber: "03",
    cropName: "Potato",
    expectedLabel: "Potato Healthy Foliage (Solanum tuberosum)",
    predictedLabel: "Potato___healthy",
    confidence: 0.9890,
    healthScore: 98.0,
    severity: "None",
    remedy: "No pathogen detected. Continue standard drip irrigation & soil nutrition schedule.",
    imagePath: "/presentation/samples/potato_healthy.jpg?v=3",
    source: "ai/datasets/classification/plantvillage/train/Potato___healthy/00fc2ee5-729f-4757-8aeb-65c3355874f2___RS_HL 1864.JPG",
    verified: true,
  },
];
