"use client";

import { motion } from "framer-motion";
import PhoneMockup from "../../PhoneMockup";

export default function Scene02_PhoneReveal() {
  return (
    <div className="w-full h-full bg-[#0A120A] text-[#F6F4ED] flex flex-col justify-between p-8 sm:p-16 relative overflow-hidden select-none">
      
      {/* Top Header */}
      <div className="relative z-10 flex items-center justify-between">
        <span className="text-xs font-mono text-[#A4B8A2] tracking-widest uppercase">
          02 / THE REVEAL
        </span>

        <div className="px-3 py-1.5 rounded-full bg-[#1B2E1A] border border-[#10B981]/30 text-xs font-mono text-[#10B981] font-bold">
          ON-DEVICE AI • ANDROID
        </div>
      </div>

      {/* Main Content Grid */}
      <div className="relative z-10 grid grid-cols-1 lg:grid-cols-12 gap-12 my-auto items-center">
        
        {/* Left Column Text */}
        <div className="lg:col-span-6 space-y-6">
          <motion.h2
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 1 }}
            className="text-4xl sm:text-7xl font-normal tracking-tight text-serif-editorial text-[#F6F4ED] leading-[1.1]"
          >
            So we moved <br />
            the intelligence <span className="italic text-[#10B981]">here</span>.
          </motion.h2>

          <motion.p
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 1, delay: 0.3 }}
            className="text-base sm:text-xl text-[#A4B8A2] font-light max-w-lg leading-relaxed"
          >
            Embedding ONNX neural networks directly inside the Flutter runtime environment on Android devices.
          </motion.p>
        </div>

        {/* Right Column Phone Reveal */}
        <div className="lg:col-span-6 flex justify-center">
          <motion.div
            initial={{ opacity: 0, scale: 0.9, y: 30 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            transition={{ duration: 1, delay: 0.2 }}
            className="w-full max-w-md"
          >
            <PhoneMockup />
          </motion.div>
        </div>
      </div>

      {/* Footer Note */}
      <div className="relative z-10 text-xs font-mono text-[#A4B8A2]/50">
        KRISHIOS ON-DEVICE ENGINE • ZERO SERVER DEPENDENCY
      </div>
    </div>
  );
}
