"use client";

import { motion } from "framer-motion";
import Link from "next/link";
import { Download, ExternalLink, RefreshCw, Sparkles, CheckCircle2 } from "lucide-react";
import { GithubIcon } from "../../Icons";

interface Scene13Props {
  onResetExperience?: () => void;
}

export default function Scene13_FinalMoment({ onResetExperience }: Scene13Props) {
  return (
    <div className="w-full h-full bg-[#0A120A] text-[#F6F4ED] flex flex-col justify-between p-6 sm:p-12 lg:p-16 relative overflow-hidden select-none">
      
      {/* Background Texture & Soft Ambient Glow */}
      <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_center,rgba(16,185,129,0.12)_0%,rgba(10,18,10,0.98)_80%)] pointer-events-none" />

      {/* Top Header */}
      <div className="relative z-10 flex items-center justify-between">
        <span className="text-xs font-mono text-[#A4B8A2] tracking-widest uppercase">
          13 / NARRATIVE CLOSURE
        </span>

        {onResetExperience && (
          <button
            onClick={onResetExperience}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-[#1B2E1A] border border-[#F6F4ED]/15 text-xs font-mono text-[#A4B8A2] hover:text-[#F6F4ED] transition-colors"
          >
            <RefreshCw className="w-3.5 h-3.5" />
            <span>RESTART PRESENTATION</span>
          </button>
        )}
      </div>

      {/* Main Closing Hero Content */}
      <div className="relative z-10 max-w-4xl my-auto text-center mx-auto space-y-8">
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 1 }}
          className="space-y-4"
        >
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#10B981]/20 text-[#10B981] text-xs font-mono font-bold tracking-widest uppercase border border-[#10B981]/30">
            <Sparkles className="w-3.5 h-3.5" />
            <span>KRISHIOS EXECUTIVE SUMMARY</span>
          </div>

          <h1 className="text-5xl sm:text-8xl font-normal tracking-tight text-serif-editorial text-[#F6F4ED] leading-none">
            KRISHIOS
          </h1>

          <p className="text-xl sm:text-3xl text-[#A4B8A2] font-light max-w-2xl mx-auto pt-2 leading-relaxed">
            AI for the field. <br className="hidden sm:inline" />
            <span className="text-[#10B981] font-normal">Even when the cloud isn't there.</span>
          </p>
        </motion.div>

        {/* Meaningful Action CTAs */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, delay: 0.4 }}
          className="flex flex-wrap items-center justify-center gap-4 pt-4"
        >
          <Link
            href="/app/index.html"
            className="px-6 py-3.5 rounded-2xl bg-[#10B981] text-[#0A120A] font-mono font-bold text-xs hover:bg-[#059669] hover:text-white transition-all shadow-xl flex items-center gap-2"
          >
            <ExternalLink className="w-4 h-4" />
            <span>EXPLORE KRISHIOS WORKSTATION</span>
          </Link>

          <a
            href="https://github.com/ZoroDev0/KrishiOS/releases/download/v1.0.0/app-release.apk"
            target="_blank"
            rel="noopener noreferrer"
            className="px-6 py-3.5 rounded-2xl bg-[#1B2E1A] border border-[#10B981]/50 text-[#10B981] font-mono font-bold text-xs hover:bg-[#10B981] hover:text-[#0A120A] transition-all shadow-xl flex items-center gap-2"
          >
            <Download className="w-4 h-4" />
            <span>DOWNLOAD ANDROID RELEASE APK</span>
          </a>

          <a
            href="https://github.com/ZoroDev0/KrishiOS.git"
            target="_blank"
            rel="noopener noreferrer"
            className="px-5 py-3.5 rounded-2xl bg-[#1B2E1A] border border-[#F6F4ED]/15 text-[#F6F4ED] font-mono text-xs hover:border-[#F6F4ED]/40 transition-all flex items-center gap-2"
          >
            <GithubIcon className="w-4 h-4" />
            <span>GITHUB REPOSITORY</span>
          </a>
        </motion.div>
      </div>

      {/* Footer */}
      <div className="relative z-10 flex flex-col sm:flex-row items-center justify-between gap-2 border-t border-[#F6F4ED]/10 pt-3 text-xs font-mono text-[#A4B8A2]">
        <div className="flex items-center gap-2">
          <CheckCircle2 className="w-4 h-4 text-[#10B981]" />
          <span>TEAM 4 BRAIN • KRISHIOS PRESENTATION COMPLETE</span>
        </div>
        <div className="text-[#10B981]">READY FOR JUDGE QUESTIONS</div>
      </div>
    </div>
  );
}
