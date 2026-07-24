"use client";

import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Cpu, CheckCircle2, Layers, HardDrive, ArrowRight, Code } from "lucide-react";

interface Scene09Props {
  onNextScene?: () => void;
}

export default function Scene09_HowKrishiOSThinks({ onNextScene }: Scene09Props) {
  const [showDetails, setShowDetails] = useState(false);

  const pipelineStages = [
    { num: "01", name: "Camera Input", detail: "Foliage image capture via device camera", tech: "Flutter Image Picker" },
    { num: "02", name: "Quality Validation", detail: "Blur & brightness pre-check filter", tech: "OpenCV / Image Processor" },
    { num: "03", name: "YOLO Leaf Detector", detail: "Foliage bounding box detection (12.1MB)", tech: "leaf_detector.onnx" },
    { num: "04", name: "38-Class Classifier", detail: "EfficientNet-B0 neural inference (16.7MB)", tech: "classifier.onnx" },
    { num: "05", name: "Diagnosis & Remedy", detail: "Pathology identification & treatment", tech: "Agronomy Rule Engine" },
    { num: "06", name: "Encrypted Storage", detail: "Hive local box key encryption", tech: "flutter_secure_storage" },
  ];

  return (
    <div className="w-full h-full bg-[#0A120A] text-[#F6F4ED] flex flex-col justify-between p-6 sm:p-12 lg:p-16 relative overflow-hidden select-none">
      
      {/* Top Header */}
      <div className="relative z-10 flex items-center justify-between">
        <span className="text-xs font-mono text-[#A4B8A2] tracking-widest uppercase">
          09 / AI NEURAL PIPELINE
        </span>

        <button
          onClick={() => setShowDetails(!showDetails)}
          className="flex items-center gap-1.5 px-3.5 py-1.5 rounded-full bg-[#1B2E1A] border border-[#10B981]/40 text-xs font-mono text-[#10B981] font-bold hover:bg-[#10B981]/20 transition-all"
        >
          <Code className="w-3.5 h-3.5" />
          <span>{showDetails ? "HIDE TENSOR DETAILS" : "SHOW ENGINEERING DETAILS"}</span>
        </button>
      </div>

      {/* Headline */}
      <div className="relative z-10 max-w-3xl my-auto space-y-2">
        <h2 className="text-3xl sm:text-5xl font-normal tracking-tight text-serif-editorial text-[#F6F4ED]">
          How KrishiOS Thinks
        </h2>
        <p className="text-sm sm:text-base text-[#A4B8A2] font-light">
          A 6-stage offline neural inference pipeline executing in 13.33ms on device.
        </p>
      </div>

      {/* Animated Pipeline Stages Grid */}
      <div className="relative z-10 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-6 gap-4 my-auto">
        {pipelineStages.map((stage, idx) => (
          <motion.div
            key={idx}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5, delay: idx * 0.1 }}
            className="p-4 rounded-2xl bg-[#1B2E1A] border border-[#F6F4ED]/15 space-y-3 hover:border-[#10B981]/50 transition-colors"
          >
            <div className="flex items-center justify-between">
              <span className="text-xs font-mono text-[#10B981] font-bold">{stage.num}</span>
              <CheckCircle2 className="w-4 h-4 text-[#10B981]" />
            </div>

            <div>
              <h4 className="font-bold text-sm text-[#F6F4ED] mb-1">{stage.name}</h4>
              <p className="text-[11px] text-[#A4B8A2] leading-relaxed">{stage.detail}</p>
            </div>

            <div className="pt-2 border-t border-[#F6F4ED]/10 text-[9px] font-mono text-[#10B981]">
              {stage.tech}
            </div>
          </motion.div>
        ))}
      </div>

      {/* Engineering Tensor Details Drawer Modal */}
      <AnimatePresence>
        {showDetails && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 20 }}
            className="relative z-20 p-6 rounded-3xl bg-[#1B2E1A] border border-[#10B981]/40 shadow-2xl space-y-4 max-w-3xl mx-auto font-mono text-xs text-[#A4B8A2]"
          >
            <div className="flex justify-between items-center border-b border-[#F6F4ED]/10 pb-2 text-[#F6F4ED] font-bold">
              <span>EFFICIENTNET-B0 TENSOR SPECIFICATION</span>
              <span className="text-[#10B981]">VERIFIED EXPORT REPORT</span>
            </div>

            <div className="grid grid-cols-2 sm:grid-cols-3 gap-4">
              <div>
                <span className="text-[#A4B8A2]">INPUT SHAPE:</span>
                <div className="text-[#F6F4ED] font-bold">[1, 3, 224, 224]</div>
              </div>
              <div>
                <span className="text-[#A4B8A2]">AVERAGE LATENCY:</span>
                <div className="text-[#10B981] font-bold">13.33ms (CPU CUDA)</div>
              </div>
              <div>
                <span className="text-[#A4B8A2]">CLASSIFIER SIZE:</span>
                <div className="text-[#F6F4ED] font-bold">16.7 MB ONNX</div>
              </div>
              <div>
                <span className="text-[#A4B8A2]">DETECTOR SIZE:</span>
                <div className="text-[#F6F4ED] font-bold">12.1 MB YOLO</div>
              </div>
              <div>
                <span className="text-[#A4B8A2]">NORMALIZATION MEAN:</span>
                <div className="text-[#F6F4ED]">[0.485, 0.456, 0.406]</div>
              </div>
              <div>
                <span className="text-[#A4B8A2]">NORMALIZATION STD:</span>
                <div className="text-[#F6F4ED]">[0.229, 0.224, 0.225]</div>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Footer */}
      <div className="relative z-10 flex items-center justify-between border-t border-[#F6F4ED]/10 pt-3 text-xs font-mono text-[#A4B8A2]">
        <div>VERIFIED MODEL SPECIFICATIONS DERIVED FROM AI/OUTPUTS/EXPORT_REPORT.JSON</div>

        {onNextScene && (
          <button
            onClick={onNextScene}
            className="flex items-center gap-2 text-[#10B981] hover:underline"
          >
            <span>INSPECT SECURITY & LOCAL DATA</span>
            <ArrowRight className="w-3.5 h-3.5" />
          </button>
        )}
      </div>
    </div>
  );
}
