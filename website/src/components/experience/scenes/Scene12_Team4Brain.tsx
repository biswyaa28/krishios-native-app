"use client";

import { motion } from "framer-motion";
import { Users, Code2, Sparkles, ArrowRight } from "lucide-react";
import { GithubIcon } from "../../Icons";

interface Scene12Props {
  onNextScene?: () => void;
}

export default function Scene12_Team4Brain({ onNextScene }: Scene12Props) {
  const teamMembers = [
    {
      name: "Team 4 Brain",
      role: "System Architecture & ML Engineering",
      desc: "Cross-platform Flutter development, ONNX C++ Edge AI integration, and FastAPI backend design.",
    },
  ];

  return (
    <div className="w-full h-full bg-[#0A120A] text-[#F6F4ED] flex flex-col justify-between p-6 sm:p-12 lg:p-16 relative overflow-hidden select-none">
      
      {/* Top Header */}
      <div className="relative z-10 flex items-center justify-between">
        <span className="text-xs font-mono text-[#A4B8A2] tracking-widest uppercase">
          12 / ENGINEERING TEAM
        </span>

        <div className="flex items-center gap-2 px-3 py-1.5 rounded-full bg-[#1B2E1A] border border-[#10B981]/30 text-xs font-mono text-[#10B981] font-bold">
          <Users className="w-3.5 h-3.5" />
          <span>TEAM 4 BRAIN</span>
        </div>
      </div>

      {/* Main Content */}
      <div className="relative z-10 max-w-4xl my-auto space-y-8">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8 }}
          className="space-y-4"
        >
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#10B981]/20 text-[#10B981] text-xs font-mono">
            <Sparkles className="w-3.5 h-3.5" />
            <span>HACKATHON BUILDERS</span>
          </div>

          <h2 className="text-4xl sm:text-7xl font-normal tracking-tight text-serif-editorial text-[#F6F4ED]">
            Team 4 Brain
          </h2>

          <p className="text-base sm:text-2xl text-[#A4B8A2] font-light max-w-2xl leading-relaxed">
            Built by engineers who wanted AI to work where it matters most—in the field, without cellular internet.
          </p>
        </motion.div>

        {/* Typographic Team Roster Card */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, delay: 0.3 }}
          className="p-8 rounded-3xl bg-[#1B2E1A] border border-[#10B981]/30 shadow-2xl space-y-4 max-w-2xl"
        >
          <div className="flex items-center justify-between border-b border-[#F6F4ED]/10 pb-4">
            <div>
              <h4 className="font-bold text-xl text-[#F6F4ED]">Team 4 Brain</h4>
              <p className="text-xs font-mono text-[#10B981]">KRISHIOS CORE CONTRIBUTORS</p>
            </div>
            <a
              href="https://github.com/ZoroDev0/KrishiOS.git"
              target="_blank"
              rel="noopener noreferrer"
              className="p-2.5 rounded-full bg-[#0A120A] text-[#10B981] hover:bg-[#10B981] hover:text-[#0A120A] transition-all"
            >
              <GithubIcon className="w-5 h-5" />
            </a>
          </div>

          <p className="text-sm text-[#A4B8A2] leading-relaxed">
            End-to-end implementation of offline ONNX edge AI inference, Flutter Material 3 cross-platform UI, Kavya multilingual advisory, and serverless FastAPI cloud fallback gateway.
          </p>
        </motion.div>
      </div>

      {/* Footer */}
      <div className="relative z-10 flex items-center justify-between border-t border-[#F6F4ED]/10 pt-3 text-xs font-mono text-[#A4B8A2]">
        <div>VERIFIED CONTRIBUTORS • TEAM 4 BRAIN</div>

        {onNextScene && (
          <button
            onClick={onNextScene}
            className="flex items-center gap-2 text-[#10B981] hover:underline"
          >
            <span>CONTINUE TO FINAL CLOSING</span>
            <ArrowRight className="w-3.5 h-3.5" />
          </button>
        )}
      </div>
    </div>
  );
}
