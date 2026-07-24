"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { Wifi, WifiOff, Cpu, HardDrive, Lock, Cloud, Server, Radio, ArrowRight } from "lucide-react";

interface Scene08Props {
  onNextScene?: () => void;
}

export default function Scene08_OfflineToggle({ onNextScene }: Scene08Props) {
  const [isOnline, setIsOnline] = useState(true);

  return (
    <div className="w-full h-full bg-[#0A120A] text-[#F6F4ED] flex flex-col justify-between p-6 sm:p-12 lg:p-16 relative overflow-hidden select-none">
      
      {/* Top Header */}
      <div className="relative z-10 flex items-center justify-between">
        <span className="text-xs font-mono text-[#A4B8A2] tracking-widest uppercase">
          08 / HYBRID ARCHITECTURE VISUALIZER
        </span>

        {/* Interactive Network Toggle */}
        <div className="flex items-center gap-3">
          <span className="text-xs font-mono text-[#A4B8A2]">SIMULATE NETWORK:</span>
          <button
            onClick={() => setIsOnline(!isOnline)}
            className={`px-4 py-2 rounded-full font-mono text-xs font-bold transition-all flex items-center gap-2 border shadow-lg ${
              isOnline
                ? "bg-[#38BDF8]/20 text-[#38BDF8] border-[#38BDF8]/40"
                : "bg-[#10B981]/20 text-[#10B981] border-[#10B981]/40"
            }`}
          >
            {isOnline ? (
              <>
                <Wifi className="w-4 h-4 text-[#38BDF8]" />
                <span>STATE: ONLINE</span>
              </>
            ) : (
              <>
                <WifiOff className="w-4 h-4 text-[#10B981] animate-pulse" />
                <span>STATE: OFFLINE (ZERO SIGNAL)</span>
              </>
            )}
          </button>
        </div>
      </div>

      {/* Main Headline */}
      <div className="relative z-10 max-w-3xl my-auto space-y-2">
        <h2 className="text-3xl sm:text-5xl font-normal tracking-tight text-serif-editorial text-[#F6F4ED]">
          Remove the Internet.
        </h2>
        <p className="text-sm sm:text-base text-[#A4B8A2] font-light">
          {isOnline
            ? "Toggle the network switch to observe how KrishiOS isolates core AI intelligence to the device."
            : "The cloud disappeared. KrishiOS didn't. Core neural inference remains 100% active."}
        </p>
      </div>

      {/* Architecture Split Visualization */}
      <div className="relative z-10 grid grid-cols-1 md:grid-cols-2 gap-8 my-auto">
        
        {/* Left Column: On-Device Android Runtime (Stays Active Always) */}
        <div className="p-6 rounded-3xl bg-[#1B2E1A] border border-[#10B981]/50 shadow-2xl space-y-6 relative overflow-hidden">
          <div className="flex items-center justify-between border-b border-[#F6F4ED]/10 pb-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-2xl bg-[#10B981]/20 flex items-center justify-center text-[#10B981]">
                <Cpu className="w-5 h-5" />
              </div>
              <div>
                <h4 className="font-bold text-base text-[#F6F4ED]">On-Device Android Runtime</h4>
                <p className="text-[10px] font-mono text-[#10B981]">OFFLINE-FIRST ARCHITECTURE</p>
              </div>
            </div>

            <span className="px-2.5 py-1 rounded-full bg-[#10B981] text-[#0A120A] font-mono text-[10px] font-bold">
              100% ACTIVE
            </span>
          </div>

          <div className="space-y-3 font-mono text-xs">
            <div className="p-3 rounded-xl bg-[#0A120A] border border-[#10B981]/30 flex items-center justify-between">
              <span className="text-[#F6F4ED]">ONNX Edge AI Engine</span>
              <span className="text-[#10B981] font-bold">ACTIVE (13.33ms)</span>
            </div>

            <div className="p-3 rounded-xl bg-[#0A120A] border border-[#10B981]/30 flex items-center justify-between">
              <span className="text-[#F6F4ED]">Hive AES-256 Local DB</span>
              <span className="text-[#10B981] font-bold">ACTIVE (LOCAL)</span>
            </div>

            <div className="p-3 rounded-xl bg-[#0A120A] border border-[#10B981]/30 flex items-center justify-between">
              <span className="text-[#F6F4ED]">38-Class Pathology Model</span>
              <span className="text-[#10B981] font-bold">ACTIVE (EMBEDDED)</span>
            </div>
          </div>
        </div>

        {/* Right Column: Cloud Services (Fades out when OFFLINE) */}
        <div
          className={`p-6 rounded-3xl border transition-all duration-500 space-y-6 ${
            isOnline
              ? "bg-[#1B2E1A]/80 border-[#38BDF8]/40 shadow-2xl"
              : "bg-[#0A120A]/40 border-[#F6F4ED]/5 opacity-40 grayscale"
          }`}
        >
          <div className="flex items-center justify-between border-b border-[#F6F4ED]/10 pb-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-2xl bg-[#38BDF8]/20 flex items-center justify-center text-[#38BDF8]">
                <Cloud className="w-5 h-5" />
              </div>
              <div>
                <h4 className="font-bold text-base text-[#F6F4ED]">Cloud Services & API Gateway</h4>
                <p className="text-[10px] font-mono text-[#38BDF8]">HYBRID SCALING LAYER</p>
              </div>
            </div>

            <span
              className={`px-2.5 py-1 rounded-full font-mono text-[10px] font-bold ${
                isOnline
                  ? "bg-[#38BDF8] text-[#0A120A]"
                  : "bg-[#EF4444]/20 text-[#EF4444]"
              }`}
            >
              {isOnline ? "CONNECTED" : "DISCONNECTED"}
            </span>
          </div>

          <div className="space-y-3 font-mono text-xs">
            <div className="p-3 rounded-xl bg-[#0A120A] border border-[#F6F4ED]/10 flex items-center justify-between">
              <span className="text-[#F6F4ED]">Vercel / FastAPI Backend Gateway</span>
              <span className={isOnline ? "text-[#38BDF8] font-bold" : "text-[#EF4444]"}>
                {isOnline ? "ONLINE" : "UNAVAILABLE"}
              </span>
            </div>

            <div className="p-3 rounded-xl bg-[#0A120A] border border-[#F6F4ED]/10 flex items-center justify-between">
              <span className="text-[#F6F4ED]">Firebase Auth & Firestore Sync</span>
              <span className={isOnline ? "text-[#38BDF8] font-bold" : "text-[#EF4444]"}>
                {isOnline ? "ONLINE" : "UNAVAILABLE"}
              </span>
            </div>

            <div className="p-3 rounded-xl bg-[#0A120A] border border-[#F6F4ED]/10 flex items-center justify-between">
              <span className="text-[#F6F4ED]">Open-Meteo GPS Weather API</span>
              <span className={isOnline ? "text-[#38BDF8] font-bold" : "text-[#EF4444]"}>
                {isOnline ? "ONLINE" : "CACHED LOCAL"}
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Transition CTA & Footer */}
      <div className="relative z-10 flex items-center justify-between border-t border-[#F6F4ED]/10 pt-3 text-xs font-mono text-[#A4B8A2]">
        <div>AND ANDROID RUNTIME ARCHITECTURE VISUALIZER</div>

        {onNextScene && (
          <button
            onClick={onNextScene}
            className="flex items-center gap-2 text-[#10B981] hover:underline"
          >
            <span>INSPECT AI NEURAL PIPELINE</span>
            <ArrowRight className="w-3.5 h-3.5" />
          </button>
        )}
      </div>
    </div>
  );
}
