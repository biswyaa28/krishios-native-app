"use client";

import { motion } from "framer-motion";
import { Lock, HardDrive, ShieldCheck, Key, ArrowRight } from "lucide-react";

interface Scene10Props {
  onNextScene?: () => void;
}

export default function Scene10_SecurityData({ onNextScene }: Scene10Props) {
  return (
    <div className="w-full h-full bg-[#0A120A] text-[#F6F4ED] flex flex-col justify-between p-6 sm:p-12 lg:p-16 relative overflow-hidden select-none">
      
      {/* Top Header */}
      <div className="relative z-10 flex items-center justify-between">
        <span className="text-xs font-mono text-[#A4B8A2] tracking-widest uppercase">
          10 / SECURITY & ENCRYPTED STORAGE
        </span>

        <div className="flex items-center gap-2 px-3 py-1.5 rounded-full bg-[#1B2E1A] border border-[#10B981]/30 text-xs font-mono text-[#10B981] font-bold">
          <Lock className="w-3.5 h-3.5" />
          <span>AES-256 ENCRYPTED HIVE LOCAL DB</span>
        </div>
      </div>

      {/* Main Headline */}
      <div className="relative z-10 max-w-3xl my-auto space-y-2">
        <h2 className="text-3xl sm:text-5xl font-normal tracking-tight text-serif-editorial text-[#F6F4ED]">
          Your Farm Data Stays Yours.
        </h2>
        <p className="text-sm sm:text-base text-[#A4B8A2] font-light leading-relaxed">
          Hive data is encrypted using a 256-bit key stored securely through flutter_secure_storage (EncryptedSharedPreferences on Android).
        </p>
      </div>

      {/* Physical Encryption Pipeline */}
      <div className="relative z-10 grid grid-cols-1 md:grid-cols-4 gap-6 my-auto">
        <div className="p-6 rounded-3xl bg-[#1B2E1A] border border-[#F6F4ED]/15 space-y-4">
          <div className="w-10 h-10 rounded-2xl bg-[#10B981]/20 flex items-center justify-center text-[#10B981]">
            <HardDrive className="w-5 h-5" />
          </div>
          <div>
            <h4 className="font-bold text-base text-[#F6F4ED] mb-1">1. Scan History</h4>
            <p className="text-xs text-[#A4B8A2]">Diagnostic report & crop foliage telemetry.</p>
          </div>
        </div>

        <div className="p-6 rounded-3xl bg-[#1B2E1A] border border-[#F6F4ED]/15 space-y-4">
          <div className="w-10 h-10 rounded-2xl bg-[#10B981]/20 flex items-center justify-center text-[#10B981]">
            <Lock className="w-5 h-5" />
          </div>
          <div>
            <h4 className="font-bold text-base text-[#F6F4ED] mb-1">2. Hive AesCipher</h4>
            <p className="text-xs text-[#A4B8A2]">Local binary box encryption algorithm.</p>
          </div>
        </div>

        <div className="p-6 rounded-3xl bg-[#1B2E1A] border border-[#F6F4ED]/15 space-y-4">
          <div className="w-10 h-10 rounded-2xl bg-[#10B981]/20 flex items-center justify-center text-[#10B981]">
            <Key className="w-5 h-5" />
          </div>
          <div>
            <h4 className="font-bold text-base text-[#F6F4ED] mb-1">3. 256-Bit Key</h4>
            <p className="text-xs text-[#A4B8A2]">Cryptographically generated 32-byte key.</p>
          </div>
        </div>

        <div className="p-6 rounded-3xl bg-[#1B2E1A] border border-[#10B981]/40 shadow-2xl space-y-4">
          <div className="w-10 h-10 rounded-2xl bg-[#10B981]/20 flex items-center justify-center text-[#10B981]">
            <ShieldCheck className="w-5 h-5" />
          </div>
          <div>
            <h4 className="font-bold text-base text-[#F6F4ED] mb-1">4. Secure Storage</h4>
            <p className="text-xs text-[#A4B8A2]">Android EncryptedSharedPreferences key vault.</p>
          </div>
        </div>
      </div>

      {/* Footer */}
      <div className="relative z-10 flex items-center justify-between border-t border-[#F6F4ED]/10 pt-3 text-xs font-mono text-[#A4B8A2]">
        <div>VERIFIED DATA STORAGE IMPLEMENTATION IN FRONTEND/LIB/SHARED/SERVICES/HIVE_SERVICE.DART</div>

        {onNextScene && (
          <button
            onClick={onNextScene}
            className="flex items-center gap-2 text-[#10B981] hover:underline"
          >
            <span>CONTINUE TO PLATFORM VISION</span>
            <ArrowRight className="w-3.5 h-3.5" />
          </button>
        )}
      </div>
    </div>
  );
}
