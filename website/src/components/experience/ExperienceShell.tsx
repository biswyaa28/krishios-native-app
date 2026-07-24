"use client";

import { useState, useEffect, useCallback, ReactNode } from "react";
import { AnimatePresence, motion } from "framer-motion";
import PresenterHUD from "./PresenterHUD";

interface ExperienceShellProps {
  scenes: {
    id: string;
    name: string;
    component: (props: {
      onNextScene?: () => void;
      onPrevScene?: () => void;
      onResetExperience?: () => void;
      isLiveMode?: boolean;
    }) => ReactNode;
  }[];
}

export default function ExperienceShell({ scenes }: ExperienceShellProps) {
  const [currentScene, setCurrentScene] = useState(0);
  const [isFullscreen, setIsFullscreen] = useState(false);
  const [isLiveMode, setIsLiveMode] = useState(false);
  const [isHudOpen, setIsHudOpen] = useState(false);

  const totalScenes = scenes.length;

  const goToNext = useCallback(() => {
    setCurrentScene((prev) => Math.min(prev + 1, totalScenes - 1));
  }, [totalScenes]);

  const goToPrev = useCallback(() => {
    setCurrentScene((prev) => Math.max(prev - 1, 0));
  }, []);

  const goToScene = useCallback((index: number) => {
    if (index >= 0 && index < totalScenes) {
      setCurrentScene(index);
    }
  }, [totalScenes]);

  const resetCurrentScene = useCallback(() => {
    // Re-mounts scene component by forcing state update
    const current = currentScene;
    setCurrentScene(-1);
    setTimeout(() => setCurrentScene(current), 10);
  }, [currentScene]);

  const toggleFullscreen = useCallback(() => {
    if (!document.fullscreenElement) {
      document.documentElement.requestFullscreen().catch(() => {});
      setIsFullscreen(true);
    } else {
      if (document.exitFullscreen) {
        document.exitFullscreen().catch(() => {});
        setIsFullscreen(false);
      }
    }
  }, []);

  // Global Keyboard Listener
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === "ArrowRight" || e.key === "Space" || e.key === "PageDown") {
        e.preventDefault();
        goToNext();
      } else if (e.key === "ArrowLeft" || e.key === "PageUp") {
        e.preventDefault();
        goToPrev();
      } else if (e.key === "p" || e.key === "P") {
        e.preventDefault();
        setIsHudOpen((prev) => !prev);
      } else if (e.key === "r" || e.key === "R") {
        e.preventDefault();
        resetCurrentScene();
      } else if (e.key === "f" || e.key === "F") {
        e.preventDefault();
        toggleFullscreen();
      } else if (e.key === "Escape") {
        setIsHudOpen(false);
      }
    };

    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [goToNext, goToPrev, toggleFullscreen, resetCurrentScene]);

  // Fullscreen change listener
  useEffect(() => {
    const handleFullscreenChange = () => {
      setIsFullscreen(!!document.fullscreenElement);
    };
    document.addEventListener("fullscreenchange", handleFullscreenChange);
    return () => document.removeEventListener("fullscreenchange", handleFullscreenChange);
  }, []);

  return (
    <div className="w-screen h-screen overflow-hidden bg-[#0A120A] text-[#F6F4ED] relative select-none font-sans">
      
      {/* Viewport Scene Container */}
      <div className="w-full h-full relative">
        <AnimatePresence mode="wait">
          {currentScene >= 0 && (
            <motion.div
              key={currentScene}
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.5, ease: [0.16, 1, 0.3, 1] }}
              className="w-full h-full"
            >
              {scenes[currentScene].component({
                onNextScene: goToNext,
                onPrevScene: goToPrev,
                onResetExperience: resetCurrentScene,
                isLiveMode,
              })}
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      {/* Secret Presenter HUD (Opened via 'P') */}
      <PresenterHUD
        currentScene={currentScene}
        totalScenes={totalScenes}
        onNext={goToNext}
        onPrev={goToPrev}
        onGoToScene={goToScene}
        onReset={resetCurrentScene}
        isFullscreen={isFullscreen}
        onToggleFullscreen={toggleFullscreen}
        isLiveMode={isLiveMode}
        onToggleLiveMode={() => setIsLiveMode((prev) => !prev)}
        isOpen={isHudOpen}
        onClose={() => setIsHudOpen(false)}
        sceneNames={scenes.map((s) => s.name)}
      />

      {/* Bottom Hint for Presenter */}
      {!isHudOpen && (
        <div className="fixed bottom-4 right-6 z-40 text-[10px] font-mono text-[#A4B8A2]/40 pointer-events-none">
          PRESS 'P' FOR PRESENTER MODE • USE ARROW KEYS TO NAVIGATE
        </div>
      )}
    </div>
  );
}
