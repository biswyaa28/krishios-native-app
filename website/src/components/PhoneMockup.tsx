"use client";

import { useState } from "react";
import { Camera, Mic, CloudSun, ShieldCheck, Cpu, WifiOff, CheckCircle2, Sparkles } from "lucide-react";

export default function PhoneMockup() {
  const [activeTab, setActiveTab] = useState<"scan" | "kavya" | "weather">("scan");

  return (
    <div className="relative mx-auto w-full max-w-sm sm:max-w-md lg:max-w-lg">
      
      {/* Background Soft Shadow */}
      <div className="absolute -inset-4 rounded-[44px] bg-[#233B22]/15 blur-2xl pointer-events-none" />

      {/* Device Frame */}
      <div className="relative rounded-[40px] p-4 sm:p-5 border border-[#1A2919]/10 shadow-2xl bg-[#1B2E1A] text-[#F6F4ED] overflow-hidden">
        
        {/* Top Header Bar */}
        <div className="flex items-center justify-between px-5 pt-1 pb-3 border-b border-[#F6F4ED]/10 text-[10px] font-mono">
          <div className="flex items-center gap-1.5 text-[#A4B8A2]">
            <span className="w-1.5 h-1.5 rounded-full bg-[#10B981] animate-ping" />
            <span>ONNX EDGE ENGINE</span>
          </div>
          <div className="flex items-center gap-2">
            <span className="px-2 py-0.5 rounded-full bg-[#F6F4ED]/10 text-[#F6F4ED] font-bold">
              14ms LATENCY
            </span>
            <div className="flex items-center gap-1 text-[#A4B8A2]">
              <WifiOff className="w-3 h-3" />
              <span>OFFLINE</span>
            </div>
          </div>
        </div>

        {/* Tab Switcher Toolbar */}
        <div className="grid grid-cols-3 gap-1.5 bg-[#233B22] p-1.5 rounded-2xl my-3 border border-[#F6F4ED]/10 text-xs font-medium">
          <button
            onClick={() => setActiveTab("scan")}
            className={`py-2 rounded-xl flex items-center justify-center gap-1.5 transition-all ${
              activeTab === "scan"
                ? "bg-[#F6F4ED] text-[#1A2919] font-bold shadow-md"
                : "text-[#A4B8A2] hover:text-[#F6F4ED]"
            }`}
          >
            <Camera className="w-3.5 h-3.5" />
            <span>AI SCAN</span>
          </button>

          <button
            onClick={() => setActiveTab("kavya")}
            className={`py-2 rounded-xl flex items-center justify-center gap-1.5 transition-all ${
              activeTab === "kavya"
                ? "bg-[#F6F4ED] text-[#1A2919] font-bold shadow-md"
                : "text-[#A4B8A2] hover:text-[#F6F4ED]"
            }`}
          >
            <Mic className="w-3.5 h-3.5" />
            <span>KAVYA AI</span>
          </button>

          <button
            onClick={() => setActiveTab("weather")}
            className={`py-2 rounded-xl flex items-center justify-center gap-1.5 transition-all ${
              activeTab === "weather"
                ? "bg-[#F6F4ED] text-[#1A2919] font-bold shadow-md"
                : "text-[#A4B8A2] hover:text-[#F6F4ED]"
            }`}
          >
            <CloudSun className="w-3.5 h-3.5" />
            <span>WEATHER</span>
          </button>
        </div>

        {/* Screen Viewport Window */}
        <div className="min-h-[350px] bg-[#F6F4ED] text-[#1A2919] rounded-3xl p-4 border border-[#1A2919]/10 flex flex-col justify-between">
          
          {activeTab === "scan" && (
            <div className="space-y-3.5 animate-in fade-in duration-300">
              
              <div className="relative h-44 rounded-2xl bg-[#1B2E1A] text-[#F6F4ED] p-3 flex flex-col justify-between overflow-hidden">
                <div className="absolute inset-x-0 h-0.5 bg-[#10B981] shadow-[0_0_10px_#10b981] animate-pulse" />

                <div className="relative z-10 flex justify-between items-center text-[10px] font-mono">
                  <span className="bg-[#233B22] px-2 py-0.5 rounded-full border border-[#F6F4ED]/10">ONNX C++ RUNTIME</span>
                  <span className="text-[#10B981] font-bold bg-[#10B981]/10 px-2 py-0.5 rounded-full">98.4% CONF</span>
                </div>

                <div className="relative z-10 text-center p-2">
                  <span className="text-[10px] font-mono uppercase tracking-widest text-[#A4B8A2]">
                    SOLANUM LYCOPERSICUM FOLIAGE
                  </span>
                  <p className="text-xs font-semibold text-[#F6F4ED] mt-1">Tomato Leaf Analyzed</p>
                </div>
              </div>

              <div className="p-3.5 rounded-2xl bg-white border border-[#1A2919]/10 space-y-2 shadow-sm">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-bold text-[#1A2919] flex items-center gap-1.5">
                    <CheckCircle2 className="w-4 h-4 text-[#233B22]" />
                    Tomato Late Blight
                  </span>
                  <span className="text-[10px] font-mono text-[#233B22] font-bold bg-[#233B22]/10 px-2 py-0.5 rounded-full">
                    VERIFIED
                  </span>
                </div>
                <p className="text-[11px] text-[#4B5E4A] leading-relaxed">
                  Fungal pathogen identified. Apply organic neem oil spray (5ml/L) at 7-day intervals.
                </p>
              </div>

            </div>
          )}

          {activeTab === "kavya" && (
            <div className="space-y-4 animate-in fade-in duration-300">
              <div className="p-3.5 rounded-2xl bg-white border border-[#1A2919]/10 space-y-2 shadow-sm">
                <div className="flex items-center gap-2 text-xs font-bold text-[#233B22]">
                  <Sparkles className="w-3.5 h-3.5" />
                  <span>Kavya Voice Agent (Hindi/Telugu)</span>
                </div>
                <div className="p-3 rounded-xl bg-[#F6F4ED] text-[11px] text-[#1A2919] font-medium border border-[#1A2919]/5">
                  &ldquo;संक्रमित पत्तियों को हटा दें। खेत में 5ml/L नीम के तेल का छिड़काव करें।&rdquo;
                </div>
              </div>

              <div className="p-4 rounded-2xl bg-white border border-[#1A2919]/10 flex flex-col items-center gap-2 shadow-sm">
                <div className="flex items-center gap-1.5 h-10">
                  {[35, 75, 45, 95, 60, 85, 100, 70, 50, 90, 40, 65, 30].map((height, i) => (
                    <div
                      key={i}
                      className="w-1 bg-[#233B22] rounded-full animate-pulse"
                      style={{ height: `${height}%`, animationDelay: `${i * 90}ms` }}
                    />
                  ))}
                </div>
                <span className="text-[10px] font-mono text-[#4B5E4A]">Listening to voice prompt...</span>
              </div>
            </div>
          )}

          {activeTab === "weather" && (
            <div className="space-y-3 animate-in fade-in duration-300">
              <div className="p-3.5 rounded-2xl bg-white border border-[#1A2919]/10 flex items-center justify-between shadow-sm">
                <div>
                  <span className="text-[10px] font-mono text-[#4B5E4A]">LOCATION STATION</span>
                  <h4 className="text-sm font-bold text-[#1A2919]">Patna, Bihar</h4>
                  <span className="text-xs text-[#233B22] font-semibold">28°C • Optimal Humidity</span>
                </div>
                <CloudSun className="w-8 h-8 text-amber-600" />
              </div>

              <div className="grid grid-cols-2 gap-2 text-xs font-mono">
                <div className="p-3 rounded-2xl bg-white border border-[#1A2919]/10 shadow-sm">
                  <span className="text-[10px] text-[#4B5E4A]">RAIN RADAR</span>
                  <p className="text-xs font-bold text-[#1A2919] mt-1">12% PROBABLE</p>
                </div>
                <div className="p-3 rounded-2xl bg-white border border-[#1A2919]/10 shadow-sm">
                  <span className="text-[10px] text-[#4B5E4A]">SOIL MOISTURE</span>
                  <p className="text-xs font-bold text-[#233B22] mt-1">64% OPTIMAL</p>
                </div>
              </div>
            </div>
          )}

          {/* Bottom Hardware Tag */}
          <div className="pt-3 border-t border-[#1A2919]/10 flex items-center justify-between text-[10px] font-mono text-[#4B5E4A]">
            <span className="flex items-center gap-1">
              <Cpu className="w-3.5 h-3.5 text-[#233B22]" />
              ONNX RUNTIME
            </span>
            <span className="flex items-center gap-1">
              <ShieldCheck className="w-3.5 h-3.5 text-[#233B22]" />
              AES-256 KEYSTORE
            </span>
          </div>

        </div>

      </div>
    </div>
  );
}
