"use client";

import { motion } from "framer-motion";
import { CheckCircle2, Clock, Smartphone, Globe, Layers, ArrowRight } from "lucide-react";

interface Scene11Props {
  onNextScene?: () => void;
}

export default function Scene11_PlatformVision({ onNextScene }: Scene11Props) {
  return (
    <div className="w-full h-full bg-[#0A120A] text-[#F6F4ED] flex flex-col justify-between p-6 sm:p-12 lg:p-16 relative overflow-hidden select-none">
      
      {/* Top Header */}
      <div className="relative z-10 flex items-center justify-between">
        <span className="text-xs font-mono text-[#A4B8A2] tracking-widest uppercase">
          11 / PLATFORM ROADMAP & VISION
        </span>

        <div className="flex items-center gap-2 px-3 py-1.5 rounded-full bg-[#1B2E1A] border border-[#10B981]/30 text-xs font-mono text-[#10B981] font-bold">
          <Layers className="w-3.5 h-3.5" />
          <span>TRANSPARENT DEMARCATION</span>
        </div>
      </div>

      {/* Headline */}
      <div className="relative z-10 max-w-3xl my-auto space-y-2">
        <h2 className="text-3xl sm:text-5xl font-normal tracking-tight text-serif-editorial text-[#F6F4ED]">
          Platform Vision & Roadmap
        </h2>
        <p className="text-sm sm:text-base text-[#A4B8A2] font-light">
          Transparent distinction between active verified releases and planned future expansions.
        </p>
      </div>

      {/* Grid Split */}
      <div className="relative z-10 grid grid-cols-1 md:grid-cols-2 gap-8 my-auto">
        
        {/* Left Column: Available Now */}
        <div className="p-6 sm:p-8 rounded-3xl bg-[#1B2E1A] border border-[#10B981]/40 shadow-2xl space-y-6">
          <div className="flex items-center justify-between border-b border-[#F6F4ED]/10 pb-4">
            <div className="flex items-center gap-2 text-[#10B981]">
              <CheckCircle2 className="w-5 h-5" />
              <h4 className="font-bold text-base text-[#F6F4ED]">AVAILABLE NOW (RELEASED)</h4>
            </div>
            <span className="text-[10px] font-mono px-2.5 py-0.5 rounded-full bg-[#10B981] text-[#0A120A] font-bold">
              v1.0.0 RELEASE
            </span>
          </div>

          <div className="space-y-4 text-xs">
            <div className="space-y-1">
              <h5 className="font-bold text-sm text-[#F6F4ED] flex items-center gap-2">
                <span className="w-1.5 h-1.5 rounded-full bg-[#10B981]" />
                <span>Flutter Web Workstation & Next.js Site</span>
              </h5>
              <p className="text-[#A4B8A2] pl-3.5 leading-relaxed">
                Live web application at /app/index.html & serverless API endpoints.
              </p>
            </div>

            <div className="space-y-1">
              <h5 className="font-bold text-sm text-[#F6F4ED] flex items-center gap-2">
                <span className="w-1.5 h-1.5 rounded-full bg-[#10B981]" />
                <span>Android Release APK v1.0</span>
              </h5>
              <p className="text-[#A4B8A2] pl-3.5 leading-relaxed">
                Native release APK compiled via automated GitHub Actions runner.
              </p>
            </div>

            <div className="space-y-1">
              <h5 className="font-bold text-sm text-[#F6F4ED] flex items-center gap-2">
                <span className="w-1.5 h-1.5 rounded-full bg-[#10B981]" />
                <span>38-Class ONNX Neural Edge Engine</span>
              </h5>
              <p className="text-[#A4B8A2] pl-3.5 leading-relaxed">
                On-device EfficientNet-B0 classifier & YOLO leaf detector.
              </p>
            </div>
          </div>
        </div>

        {/* Right Column: Planned / Future Roadmap */}
        <div className="p-6 sm:p-8 rounded-3xl bg-[#1B2E1A]/40 border border-[#F6F4ED]/10 backdrop-blur-md space-y-6">
          <div className="flex items-center justify-between border-b border-[#F6F4ED]/10 pb-4">
            <div className="flex items-center gap-2 text-[#A4B8A2]">
              <Clock className="w-5 h-5 text-[#38BDF8]" />
              <h4 className="font-bold text-base text-[#F6F4ED]">PLANNED FUTURE HORIZONS</h4>
            </div>
            <span className="text-[10px] font-mono px-2.5 py-0.5 rounded-full bg-[#F6F4ED]/10 text-[#A4B8A2]">
              ROADMAP
            </span>
          </div>

          <div className="space-y-4 text-xs">
            <div className="space-y-1">
              <h5 className="font-bold text-sm text-[#F6F4ED] flex items-center gap-2">
                <span className="w-1.5 h-1.5 rounded-full bg-[#38BDF8]" />
                <span>Drone Foliage Scan Integration</span>
              </h5>
              <p className="text-[#A4B8A2] pl-3.5 leading-relaxed">
                Aerial multispectral image scanning for large farm plots.
              </p>
            </div>

            <div className="space-y-1">
              <h5 className="font-bold text-sm text-[#F6F4ED] flex items-center gap-2">
                <span className="w-1.5 h-1.5 rounded-full bg-[#38BDF8]" />
                <span>iOS Native CoreML Port</span>
              </h5>
              <p className="text-[#A4B8A2] pl-3.5 leading-relaxed">
                CoreML & Metal hardware acceleration deployment for iOS.
              </p>
            </div>

            <div className="space-y-1">
              <h5 className="font-bold text-sm text-[#F6F4ED] flex items-center gap-2">
                <span className="w-1.5 h-1.5 rounded-full bg-[#38BDF8]" />
                <span>Satellite Root-Zone Moisture Radar</span>
              </h5>
              <p className="text-[#A4B8A2] pl-3.5 leading-relaxed">
                Synthetic Aperture Radar (SAR) integration for soil telemetry.
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Footer */}
      <div className="relative z-10 flex items-center justify-between border-t border-[#F6F4ED]/10 pt-3 text-xs font-mono text-[#A4B8A2]">
        <div>HONEST DEMARCATION: FUTURE HORIZONS ARE NEVER PRESENTED AS RELEASED</div>

        {onNextScene && (
          <button
            onClick={onNextScene}
            className="flex items-center gap-2 text-[#10B981] hover:underline"
          >
            <span>MEET TEAM 4 BRAIN</span>
            <ArrowRight className="w-3.5 h-3.5" />
          </button>
        )}
      </div>
    </div>
  );
}
