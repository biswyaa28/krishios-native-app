"use client";

import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import Image from "next/image";
import { Wifi, WifiOff } from "lucide-react";

export default function Scene01_FieldCrisis() {
  const [signalBars, setSignalBars] = useState(4);

  useEffect(() => {
    const timer1 = setTimeout(() => setSignalBars(3), 2000);
    const timer2 = setTimeout(() => setSignalBars(2), 3000);
    const timer3 = setTimeout(() => setSignalBars(1), 4000);
    const timer4 = setTimeout(() => setSignalBars(0), 5000);

    return () => {
      clearTimeout(timer1);
      clearTimeout(timer2);
      clearTimeout(timer3);
      clearTimeout(timer4);
    };
  }, []);

  return (
    <div className="w-full h-full bg-[#0A120A] text-[#F6F4ED] flex flex-col justify-between p-8 sm:p-16 relative overflow-hidden select-none">
      
      {/* Background Photography Texture */}
      <div className="absolute inset-0 z-0 opacity-25 pointer-events-none">
        <Image
          src="/Farmers.png"
          alt="Agriculture Field"
          fill
          className="object-cover grayscale contrast-125"
        />
        <div className="absolute inset-0 bg-[#0A120A]/70" />
      </div>

      {/* Top Header Step */}
      <div className="relative z-10 flex items-center justify-between">
        <span className="text-xs font-mono text-[#A4B8A2] tracking-widest uppercase">
          01 / FIELD REALITY
        </span>

        {/* Signal Indicator */}
        <div className="flex items-center gap-2 px-3 py-1.5 rounded-full bg-[#1B2E1A] border border-[#F6F4ED]/10 text-xs font-mono">
          {signalBars > 0 ? (
            <>
              <Wifi className="w-4 h-4 text-[#10B981]" />
              <span>SIGNAL: {signalBars} BARS</span>
            </>
          ) : (
            <>
              <WifiOff className="w-4 h-4 text-[#EF4444] animate-pulse" />
              <span className="text-[#EF4444] font-bold">NO SIGNAL (OFFLINE)</span>
            </>
          )}
        </div>
      </div>

      {/* Center Paced Text Reveal */}
      <div className="relative z-10 max-w-4xl my-auto space-y-6">
        <motion.p
          initial={{ opacity: 0, y: 15 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, delay: 0.3 }}
          className="text-2xl sm:text-4xl text-[#A4B8A2] font-light"
        >
          A leaf changes.
        </motion.p>

        <motion.p
          initial={{ opacity: 0, y: 15 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, delay: 1.5 }}
          className="text-2xl sm:text-4xl text-[#A4B8A2] font-light"
        >
          A farmer notices.
        </motion.p>

        <motion.h2
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 1, delay: 2.8 }}
          className="text-4xl sm:text-7xl font-normal tracking-tight text-serif-editorial text-[#F6F4ED] pt-4"
        >
          What happens next?
        </motion.h2>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: signalBars === 0 ? 1 : 0, y: 0 }}
          transition={{ duration: 1 }}
          className="pt-8 border-t border-[#F6F4ED]/15"
        >
          <p className="text-xl sm:text-3xl text-[#F6F4ED] font-serif italic">
            The field shouldn't have to wait for the cloud.
          </p>
        </motion.div>
      </div>

      {/* Footer Note */}
      <div className="relative z-10 text-xs font-mono text-[#A4B8A2]/50">
        RURAL CONNECTIVITY BLACKOUT SCENARIO
      </div>
    </div>
  );
}
