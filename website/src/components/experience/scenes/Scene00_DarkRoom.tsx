"use client";

import { motion } from "framer-motion";
import Image from "next/image";

interface Scene00Props {
  onBegin: () => void;
}

export default function Scene00_DarkRoom({ onBegin }: Scene00Props) {
  return (
    <div className="w-full h-full bg-[#0A120A] text-[#F6F4ED] flex flex-col items-center justify-center relative overflow-hidden select-none p-8">
      
      {/* Cinematic Agricultural Field Background (Discovered Slowly) */}
      <motion.div
        initial={{ opacity: 0, scale: 1.05 }}
        animate={{ opacity: 0.18, scale: 1 }}
        transition={{ duration: 3.5, ease: "easeOut" }}
        className="absolute inset-0 z-0 pointer-events-none"
      >
        <Image
          src="/Farmers.png"
          alt="Cinematic Agriculture Field"
          fill
          className="object-cover grayscale contrast-125 brightness-75"
          priority
        />
        <div className="absolute inset-0 bg-radial from-transparent via-[#0A120A]/70 to-[#0A120A]" />
      </motion.div>

      {/* Tiny Emerald Machine Pulse Point */}
      <motion.div
        initial={{ scale: 0, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        transition={{ duration: 0.8, delay: 0.4 }}
        className="relative z-10 w-2.5 h-2.5 rounded-full bg-[#10B981] shadow-[0_0_20px_#10B981] mb-8 animate-pulse"
      />

      {/* Dominant Title & Subtitles */}
      <div className="relative z-10 text-center space-y-6 max-w-4xl">
        <motion.h1
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 1.2, delay: 0.6, ease: [0.16, 1, 0.3, 1] }}
          className="text-7xl sm:text-9xl lg:text-[12rem] font-normal tracking-tight text-serif-editorial text-[#F6F4ED] leading-none"
        >
          KRISHIOS
        </motion.h1>

        <motion.p
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 1, delay: 1.2 }}
          className="text-xl sm:text-3xl text-[#A4B8A2] font-light tracking-wide"
        >
          AI for the field.
        </motion.p>

        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 0.6 }}
          transition={{ duration: 1, delay: 1.6 }}
          className="text-xs font-mono tracking-widest text-[#A4B8A2] uppercase pt-2"
        >
          Team 4 Brain
        </motion.div>
      </div>

      {/* Restrained Magnetic BEGIN Button */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.8, delay: 2.2 }}
        className="relative z-10 mt-16"
      >
        <button
          onClick={onBegin}
          className="group relative px-10 py-3.5 rounded-full border border-[#F6F4ED]/20 bg-[#1B2E1A]/40 backdrop-blur-md text-[#F6F4ED] text-xs font-mono uppercase tracking-widest transition-all duration-300 hover:border-[#10B981] hover:bg-[#10B981] hover:text-[#0A120A] shadow-2xl"
        >
          <span>BEGIN</span>
        </button>
      </motion.div>
    </div>
  );
}
