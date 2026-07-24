"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import AppScreenshots from "../../AppScreenshots";
import { ArrowLeft, Monitor, Smartphone, Sparkles, ExternalLink } from "lucide-react";

interface Scene07Props {
  onReturnToStory?: () => void;
}

export default function Scene07_ProductSandbox({ onReturnToStory }: Scene07Props) {
  const [viewMode, setViewMode] = useState<"live" | "preview">("live");
  const [iframeError, setIframeError] = useState(false);

  return (
    <div className="w-full h-full bg-[#0A120A] text-[#F6F4ED] flex flex-col justify-between p-4 sm:p-8 relative overflow-hidden select-none">
      
      {/* Top Navigation Control Bar */}
      <div className="relative z-20 flex items-center justify-between border-b border-[#F6F4ED]/10 pb-3 px-2">
        <div className="flex items-center gap-3">
          <button
            onClick={onReturnToStory}
            className="flex items-center gap-2 px-4 py-2 rounded-full bg-[#10B981] text-[#0A120A] font-bold text-xs font-mono hover:bg-[#059669] hover:text-white transition-all shadow-lg"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>RETURN TO STORY</span>
          </button>

          <span className="hidden sm:inline-block text-xs font-mono text-[#A4B8A2]">
            07 / KRISHIOS WORKSTATION SANDBOX
          </span>
        </div>

        {/* View Mode Switcher */}
        <div className="flex items-center gap-2">
          <button
            onClick={() => setViewMode("live")}
            className={`px-3 py-1.5 rounded-full text-xs font-mono transition-colors flex items-center gap-1.5 ${
              viewMode === "live"
                ? "bg-[#10B981]/20 text-[#10B981] font-bold border border-[#10B981]"
                : "bg-[#1B2E1A] text-[#A4B8A2] hover:text-[#F6F4ED]"
            }`}
          >
            <Monitor className="w-3.5 h-3.5" />
            <span>LIVE WORKSTATION</span>
          </button>

          <button
            onClick={() => setViewMode("preview")}
            className={`px-3 py-1.5 rounded-full text-xs font-mono transition-colors flex items-center gap-1.5 ${
              viewMode === "preview"
                ? "bg-[#10B981]/20 text-[#10B981] font-bold border border-[#10B981]"
                : "bg-[#1B2E1A] text-[#A4B8A2] hover:text-[#F6F4ED]"
            }`}
          >
            <Smartphone className="w-3.5 h-3.5" />
            <span>SCREENSHOT PREVIEW</span>
          </button>

          <a
            href="/app/index.html"
            target="_blank"
            rel="noopener noreferrer"
            className="p-2 rounded-full bg-[#1B2E1A] text-[#A4B8A2] hover:text-[#F6F4ED] transition-colors"
            title="Open in new tab"
          >
            <ExternalLink className="w-4 h-4" />
          </a>
        </div>
      </div>

      {/* Main Sandbox Content */}
      <div className="relative z-10 my-auto w-full h-[calc(100vh-140px)] rounded-3xl overflow-hidden border border-[#F6F4ED]/15 bg-[#1B2E1A] shadow-2xl flex items-center justify-center">
        
        {viewMode === "live" && !iframeError ? (
          <iframe
            src="/app/index.html"
            title="KrishiOS Live Product Workstation"
            className="w-full h-full border-0 rounded-3xl"
            onError={() => setIframeError(true)}
          />
        ) : (
          <div className="w-full h-full overflow-y-auto p-6">
            <AppScreenshots />
          </div>
        )}
      </div>

      {/* Footer Note */}
      <div className="relative z-20 text-xs font-mono text-[#A4B8A2]/60 flex items-center justify-between px-2 pt-2 border-t border-[#F6F4ED]/10">
        <div>INTERACTIVE DEMO SANDBOX • PRESS ESC OR CLICK 'RETURN TO STORY' AT ANY TIME</div>
        <div className="text-[#10B981] font-bold">LIVE FLUTTER WORKSTATION EMBED</div>
      </div>
    </div>
  );
}
