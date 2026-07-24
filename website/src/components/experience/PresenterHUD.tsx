"use client";

import { useState, useEffect } from "react";
import { ChevronLeft, ChevronRight, RotateCcw, Maximize2, Minimize2, Radio, Zap, X } from "lucide-react";

interface PresenterHUDProps {
  currentScene: number;
  totalScenes: number;
  onNext: () => void;
  onPrev: () => void;
  onGoToScene: (index: number) => void;
  onReset: () => void;
  isFullscreen: boolean;
  onToggleFullscreen: () => void;
  isLiveMode: boolean;
  onToggleLiveMode: () => void;
  isOpen: boolean;
  onClose: () => void;
  sceneNames: string[];
}

export default function PresenterHUD({
  currentScene,
  totalScenes,
  onNext,
  onPrev,
  onGoToScene,
  onReset,
  isFullscreen,
  onToggleFullscreen,
  isLiveMode,
  onToggleLiveMode,
  isOpen,
  onClose,
  sceneNames,
}: PresenterHUDProps) {
  const [seconds, setSeconds] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => {
      setSeconds((prev) => prev + 1);
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  const formatTime = (totalSec: number) => {
    const mins = Math.floor(totalSec / 60);
    const secs = totalSec % 60;
    return `${String(mins).padStart(2, "0")}:${String(secs).padStart(2, "0")}`;
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-x-4 top-4 z-50 p-4 rounded-2xl bg-[#0D1A0D]/95 backdrop-blur-2xl border border-[#10B981]/30 text-[#F6F4ED] shadow-2xl animate-in fade-in duration-200">
      <div className="flex flex-col md:flex-row items-center justify-between gap-4">
        
        {/* Left: Presenter Mode Indicator & Timer */}
        <div className="flex items-center gap-3 text-xs font-mono">
          <div className="flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-[#10B981]/20 text-[#10B981] font-bold">
            <span className="w-2 h-2 rounded-full bg-[#10B981] animate-ping" />
            <span>PRESENTER HUD</span>
          </div>

          <div className="px-2.5 py-1 rounded-full bg-[#F6F4ED]/10 text-[#A4B8A2]">
            TIMER: <span className="text-[#F6F4ED] font-bold">{formatTime(seconds)}</span>
          </div>

          {/* Mode Toggle */}
          <button
            onClick={onToggleLiveMode}
            className={`px-3 py-1 rounded-full text-[11px] font-bold border transition-colors flex items-center gap-1.5 ${
              isLiveMode
                ? "bg-[#38BDF8]/20 text-[#38BDF8] border-[#38BDF8]/40"
                : "bg-[#10B981]/20 text-[#10B981] border-[#10B981]/40"
            }`}
          >
            <Radio className="w-3 h-3" />
            <span>{isLiveMode ? "LIVE CLOUD DEMO" : "DEMO MODE (VERIFIED)"}</span>
          </button>
        </div>

        {/* Center: Scene Selector */}
        <div className="flex items-center gap-1 overflow-x-auto max-w-xl py-1">
          {sceneNames.map((name, idx) => (
            <button
              key={idx}
              onClick={() => onGoToScene(idx)}
              className={`px-3 py-1 rounded-lg text-xs font-mono transition-colors shrink-0 ${
                idx === currentScene
                  ? "bg-[#10B981] text-[#0A120A] font-bold"
                  : "bg-[#F6F4ED]/10 text-[#A4B8A2] hover:bg-[#F6F4ED]/20 hover:text-[#F6F4ED]"
              }`}
            >
              {idx + 1}. {name}
            </button>
          ))}
        </div>

        {/* Right: Actions */}
        <div className="flex items-center gap-2">
          <button
            onClick={onPrev}
            disabled={currentScene === 0}
            className="p-1.5 rounded-lg bg-[#F6F4ED]/10 hover:bg-[#F6F4ED]/20 disabled:opacity-30 transition-colors"
            title="Previous (Left Arrow)"
          >
            <ChevronLeft className="w-4 h-4" />
          </button>

          <button
            onClick={onNext}
            disabled={currentScene === totalScenes - 1}
            className="p-1.5 rounded-lg bg-[#F6F4ED]/10 hover:bg-[#F6F4ED]/20 disabled:opacity-30 transition-colors"
            title="Next (Right Arrow / Space)"
          >
            <ChevronRight className="w-4 h-4" />
          </button>

          <button
            onClick={onReset}
            className="p-1.5 rounded-lg bg-[#F6F4ED]/10 hover:bg-[#F6F4ED]/20 transition-colors text-[#A4B8A2] hover:text-[#F6F4ED]"
            title="Reset Scene (R)"
          >
            <RotateCcw className="w-4 h-4" />
          </button>

          <button
            onClick={onToggleFullscreen}
            className="p-1.5 rounded-lg bg-[#F6F4ED]/10 hover:bg-[#F6F4ED]/20 transition-colors text-[#A4B8A2] hover:text-[#F6F4ED]"
            title="Toggle Fullscreen (F)"
          >
            {isFullscreen ? <Minimize2 className="w-4 h-4" /> : <Maximize2 className="w-4 h-4" />}
          </button>

          <button
            onClick={onClose}
            className="p-1.5 rounded-lg bg-[#EF4444]/20 text-[#EF4444] hover:bg-[#EF4444]/30 transition-colors ml-2"
            title="Close HUD (P or Esc)"
          >
            <X className="w-4 h-4" />
          </button>
        </div>
      </div>
    </div>
  );
}
