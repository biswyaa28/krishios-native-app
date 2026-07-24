"use client";

import { useState } from "react";
import { Camera, Bot, BarChart3, Users, Sparkles, CheckCircle2, LayoutGrid } from "lucide-react";

export default function AppScreenshots() {
  const [activeScreen, setActiveScreen] = useState(0);

  const screens = [
    {
      id: "scan",
      title: "AI Crop Scan",
      subtitle: "Capture crop foliage for instant sub-second local diagnosis.",
      icon: Camera,
      badge: "38-CLASS ONNX EDGE",
      previewText: "Tomato Late Blight Detected (98.4% Confidence)",
    },
    {
      id: "kavya",
      title: "Kavya Voice Advisor",
      subtitle: "Multi-lingual voice assistant for rural farming guidance.",
      icon: Bot,
      badge: "HINDI • TELUGU • ENGLISH",
      previewText: "Voice query processed: Organic neem treatment advisory",
    },
    {
      id: "stats",
      title: "Crop Telemetry",
      subtitle: "Interactive charts and localized weather metrics.",
      icon: BarChart3,
      badge: "REAL-TIME TELEMETRY",
      previewText: "Weekly Crop Health Score: 92% Optimal",
    },
    {
      id: "community",
      title: "Farmer Forum",
      subtitle: "Connect with regional agriculturalists and expert agronomists.",
      icon: Users,
      badge: "FIRESTORE CLOUD SYNC",
      previewText: "Community discussion: Organic pest prevention strategies",
    },
  ];

  return (
    <section id="experience" className="py-24 relative overflow-hidden bg-[#F6F4ED]">
      <div className="max-w-7xl mx-auto px-6 relative z-10">
        
        {/* Section Header */}
        <div className="text-center max-w-3xl mx-auto mb-16 space-y-4">
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#233B22]/10 text-[#233B22] text-xs font-medium">
            <LayoutGrid className="w-3.5 h-3.5" />
            <span>PRODUCT EXPERIENCE</span>
          </div>
          <h2 className="text-3xl sm:text-5xl font-normal tracking-tight text-[#1A2919] text-serif-editorial">
            Designed for <span className="italic text-[#233B22]">Sunlight Clarity & Speed</span>
          </h2>
          <p className="text-[#4B5E4A] text-base sm:text-lg">
            High-contrast Material 3 interface optimized for outdoor field operation under direct sunlight.
          </p>
        </div>

        {/* Tab Switcher Toolbar */}
        <div className="flex flex-wrap items-center justify-center gap-3 mb-12">
          {screens.map((screen, idx) => {
            const Icon = screen.icon;
            const isActive = activeScreen === idx;
            return (
              <button
                key={screen.id}
                onClick={() => setActiveScreen(idx)}
                className={`px-6 py-3 rounded-full text-xs font-medium flex items-center gap-2.5 transition-all ${
                  isActive
                    ? "bg-[#233B22] text-[#F6F4ED] shadow-md font-bold"
                    : "bg-white text-[#1A2919] border border-[#1A2919]/10 hover:bg-[#233B22] hover:text-[#F6F4ED]"
                }`}
              >
                <Icon className="w-4 h-4" />
                <span>{screen.title}</span>
              </button>
            );
          })}
        </div>

        {/* Display Frame Card */}
        <div className="editorial-card rounded-3xl p-6 sm:p-10 border border-[#1A2919]/10 max-w-4xl mx-auto">
          <div className="grid grid-cols-1 md:grid-cols-12 gap-8 items-center">
            
            <div className="md:col-span-5 space-y-4">
              <span className="text-[10px] font-mono uppercase tracking-widest text-[#233B22] bg-[#233B22]/10 px-3 py-1 rounded-full font-bold">
                {screens[activeScreen].badge}
              </span>
              <h3 className="text-2xl font-bold text-[#1A2919] text-serif-editorial">
                {screens[activeScreen].title}
              </h3>
              <p className="text-[#4B5E4A] text-sm leading-relaxed">
                {screens[activeScreen].subtitle}
              </p>
              
              <div className="pt-2 flex items-center gap-2 text-xs font-medium text-[#233B22]">
                <CheckCircle2 className="w-4 h-4" />
                <span>{screens[activeScreen].previewText}</span>
              </div>
            </div>

            <div className="md:col-span-7 flex justify-center">
              <div className="w-full h-64 sm:h-80 rounded-2xl bg-[#1B2E1A] text-[#F6F4ED] p-6 flex flex-col justify-between relative overflow-hidden group">
                <div className="flex items-center justify-between text-[10px] font-mono border-b border-[#F6F4ED]/10 pb-3">
                  <span>KRISHIOS MOBILE V1.0</span>
                  <span className="text-[#10B981] font-bold">VERIFIED RELEASE</span>
                </div>

                <div className="my-auto text-center space-y-3">
                  <div className="w-14 h-14 rounded-full bg-[#F6F4ED]/10 mx-auto flex items-center justify-center text-[#F6F4ED]">
                    {(() => {
                      const Icon = screens[activeScreen].icon;
                      return <Icon className="w-7 h-7" />;
                    })()}
                  </div>
                  <h4 className="text-lg font-bold text-[#F6F4ED] text-serif-editorial">
                    {screens[activeScreen].title}
                  </h4>
                  <p className="text-xs text-[#A4B8A2] max-w-sm mx-auto">
                    {screens[activeScreen].previewText}
                  </p>
                </div>

                <div className="text-[10px] font-mono text-[#A4B8A2] text-right border-t border-[#F6F4ED]/10 pt-3">
                  ANDROID RELEASE CANDIDATE 1 • ARM64
                </div>
              </div>
            </div>

          </div>
        </div>

      </div>
    </section>
  );
}
