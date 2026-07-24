"use client";

import { motion } from "framer-motion";
import Image from "next/image";
import { DemoSample, DEMO_SAMPLES } from "../data/demoSamples";
import { ShieldAlert, CheckCircle2, Leaf, Stethoscope, ArrowRight } from "lucide-react";

interface Scene04Props {
  selectedSample?: DemoSample | null;
  onNextScene?: () => void;
}

export default function Scene04_UnderstandDiagnosis({
  selectedSample,
  onNextScene,
}: Scene04Props) {
  // Fallback to sample 1 if none selected
  const sample = selectedSample || DEMO_SAMPLES[0];

  return (
    <div className="w-full h-full bg-[#0A120A] text-[#F6F4ED] flex flex-col justify-between p-6 sm:p-12 lg:p-16 relative overflow-hidden select-none">
      
      {/* Top Header */}
      <div className="relative z-10 flex items-center justify-between">
        <span className="text-xs font-mono text-[#A4B8A2] tracking-widest uppercase">
          04 / DIAGNOSTIC ANALYSIS
        </span>
        <div className="flex items-center gap-2 px-3 py-1.5 rounded-full bg-[#1B2E1A] border border-[#10B981]/30 text-xs font-mono text-[#10B981] font-bold">
          <Stethoscope className="w-3.5 h-3.5" />
          <span>BOTANICAL PATHOLOGY REPORT</span>
        </div>
      </div>

      {/* Main Grid Content */}
      <div className="relative z-10 grid grid-cols-1 lg:grid-cols-12 gap-8 my-auto items-center">
        
        {/* Left Column: Specimen Image & Visual Annotation */}
        <div className="lg:col-span-5 space-y-4">
          <div className="relative h-80 sm:h-96 rounded-3xl overflow-hidden border border-[#F6F4ED]/15 bg-[#1B2E1A] shadow-2xl">
            <img
              src={sample.imagePath}
              alt={sample.cropName}
              className="w-full h-full object-cover"
            />
            {/* Visual Botanical Annotation Badge */}
            <div className="absolute bottom-4 left-4 right-4 p-3 rounded-2xl bg-[#0A120A]/85 backdrop-blur-md border border-[#F6F4ED]/10 text-xs font-mono">
              <div className="text-[#10B981] font-bold text-[10px] uppercase">
                SPECIMEN {sample.specimenNumber} • FOLIAGE ANALYSIS
              </div>
              <div className="text-[#F6F4ED] font-semibold pt-0.5">
                {sample.expectedLabel}
              </div>
            </div>
          </div>
        </div>

        {/* Right Column: Factual Treatment & Risk Analysis */}
        <div className="lg:col-span-7 space-y-6">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8 }}
            className="space-y-2"
          >
            <h2 className="text-3xl sm:text-5xl font-normal tracking-tight text-serif-editorial text-[#F6F4ED]">
              Understanding the Pathology
            </h2>
            <p className="text-sm sm:text-base text-[#A4B8A2] font-light">
              Finding the disease is only the first step. The farmer needs actionable treatment protocols.
            </p>
          </motion.div>

          {/* Diagnostic Metrics Cards */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.2 }}
            className="grid grid-cols-2 gap-4"
          >
            <div className="p-4 rounded-2xl bg-[#1B2E1A] border border-[#F6F4ED]/10 space-y-1">
              <div className="text-[10px] font-mono text-[#A4B8A2]">CONFIDENCE RATING</div>
              <div className="text-2xl font-bold font-mono text-[#10B981]">
                {(sample.confidence * 100).toFixed(1)}%
              </div>
              <div className="text-[10px] text-[#A4B8A2]">Derived from verified inference</div>
            </div>

            <div className="p-4 rounded-2xl bg-[#1B2E1A] border border-[#F6F4ED]/10 space-y-1">
              <div className="text-[10px] font-mono text-[#A4B8A2]">HEALTH SCORE</div>
              <div className="text-2xl font-bold font-mono text-[#F6F4ED]">
                {sample.healthScore.toFixed(1)}%
              </div>
              <div className="text-[10px] text-[#A4B8A2]">Pathology severity index</div>
            </div>
          </motion.div>

          {/* Immediate Remedy Protocol */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.4 }}
            className="p-5 rounded-2xl bg-[#233B22] border border-[#10B981]/40 space-y-2"
          >
            <div className="flex items-center gap-2 text-[#10B981] font-mono text-xs font-bold">
              <ShieldAlert className="w-4 h-4" />
              <span>ICAR RECOMMENDED TREATMENT PROTOCOL</span>
            </div>
            <p className="text-sm text-[#F6F4ED] leading-relaxed">
              {sample.remedy}
            </p>
          </motion.div>

          {/* Transition CTA */}
          {onNextScene && (
            <button
              onClick={onNextScene}
              className="flex items-center gap-2 text-xs font-mono text-[#10B981] hover:underline pt-2"
            >
              <span>CONTINUE TO MULTILINGUAL ADVISORY</span>
              <ArrowRight className="w-3.5 h-3.5" />
            </button>
          )}
        </div>
      </div>

      {/* Footer Note */}
      <div className="relative z-10 text-xs font-mono text-[#A4B8A2]/60 border-t border-[#F6F4ED]/10 pt-3">
        ICAR AGRICULTURAL RESEARCH COMPLIANT DIAGNOSTIC PROTOCOLS
      </div>
    </div>
  );
}
