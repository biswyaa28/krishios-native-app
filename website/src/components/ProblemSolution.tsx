"use client";

import { useEffect, useRef } from "react";
import { AlertTriangle, ShieldCheck } from "lucide-react";
import { gsap } from "@/lib/gsap";

export default function ProblemSolution() {
  const containerRef = useRef<HTMLDivElement>(null);
  const card1Ref = useRef<HTMLDivElement>(null);
  const card2Ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const ctx = gsap.context(() => {
      gsap.fromTo(
        [card1Ref.current, card2Ref.current],
        { opacity: 0, y: 50 },
        {
          opacity: 1,
          y: 0,
          duration: 1,
          stagger: 0.2,
          ease: "power3.out",
          scrollTrigger: {
            trigger: containerRef.current,
            start: "top 80%",
          },
        }
      );
    }, containerRef);

    return () => ctx.revert();
  }, []);

  return (
    <section ref={containerRef} id="problem" className="py-24 relative overflow-hidden bg-[#F6F4ED]">
      <div className="max-w-7xl mx-auto px-6 relative z-10">
        
        {/* Section Header */}
        <div className="text-center max-w-3xl mx-auto mb-16 space-y-4">
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#233B22]/10 text-[#233B22] text-xs font-medium">
            <span>The Agricultural Challenge</span>
          </div>
          <h2 className="text-3xl sm:text-5xl font-normal tracking-tight text-[#1A2919] text-serif-editorial">
            From Delayed Diagnostics to <span className="italic text-[#233B22]">Sub-Second Precision</span>
          </h2>
          <p className="text-[#4B5E4A] text-base sm:text-lg">
            Traditional cloud-only diagnostics fail in real-world farming environments due to spotty connectivity and severe processing delays.
          </p>
        </div>

        {/* Editorial Split Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          
          {/* Card 1: The Crisis */}
          <div ref={card1Ref} className="editorial-card rounded-3xl p-8 sm:p-10 space-y-6">
            <div className="flex items-center justify-between">
              <div className="w-12 h-12 rounded-full bg-red-500/10 border border-red-500/20 flex items-center justify-center text-red-700">
                <AlertTriangle className="w-6 h-6" />
              </div>
              <span className="text-[10px] font-mono uppercase tracking-widest text-red-700 bg-red-500/10 px-3 py-1 rounded-full font-bold">
                THE CRISIS
              </span>
            </div>

            <div className="space-y-3">
              <h3 className="text-2xl font-bold text-[#1A2919]">Cloud Isolation & 85% Crop Loss</h3>
              <p className="text-sm text-[#4B5E4A] leading-relaxed">
                Rural farmers in disconnected regions lose up to 85% of seasonal yield due to delayed fungal pathogen identification. Sending high-resolution imagery to remote cloud servers fails under 2G/3G connectivity or network blackouts.
              </p>
            </div>

            <div className="pt-4 border-t border-[#1A2919]/10 grid grid-cols-2 gap-4 text-xs font-mono">
              <div className="p-3 rounded-2xl bg-[#F6F4ED] border border-[#1A2919]/5">
                <span className="text-[#4B5E4A] text-[10px]">DIAGNOSTIC DELAY</span>
                <p className="text-sm font-bold text-red-700 mt-1">48 - 72 HOURS</p>
              </div>
              <div className="p-3 rounded-2xl bg-[#F6F4ED] border border-[#1A2919]/5">
                <span className="text-[#4B5E4A] text-[10px]">NETWORK DEPENDENCY</span>
                <p className="text-sm font-bold text-red-700 mt-1">100% CLOUD DEPENDENT</p>
              </div>
            </div>
          </div>

          {/* Card 2: The Solution (KrishiOS Shield) */}
          <div ref={card2Ref} className="olive-section-block p-8 sm:p-10 space-y-6 shadow-xl">
            <div className="flex items-center justify-between">
              <div className="w-12 h-12 rounded-full bg-[#F6F4ED]/10 border border-[#F6F4ED]/20 flex items-center justify-center text-[#F6F4ED]">
                <ShieldCheck className="w-6 h-6" />
              </div>
              <span className="text-[10px] font-mono uppercase tracking-widest text-[#F6F4ED] bg-[#F6F4ED]/10 px-3 py-1 rounded-full font-bold">
                KRISHIOS SHIELD
              </span>
            </div>

            <div className="space-y-3">
              <h3 className="text-2xl font-bold text-[#F6F4ED] text-serif-editorial">On-Device Edge Intelligence</h3>
              <p className="text-sm text-[#A4B8A2] leading-relaxed">
                KrishiOS compiles full 38-class plant disease classification neural networks directly into an on-device ONNX C++ runtime. Zero bytes of camera image data leave the device during scan processing.
              </p>
            </div>

            <div className="pt-4 border-t border-[#F6F4ED]/10 grid grid-cols-2 gap-4 text-xs font-mono">
              <div className="p-3 rounded-2xl bg-[#1B2E1A] border border-[#F6F4ED]/10">
                <span className="text-[#A4B8A2] text-[10px]">INFERENCE SPEED</span>
                <p className="text-sm font-bold text-[#F6F4ED] mt-1">&lt; 1 SEC (14ms)</p>
              </div>
              <div className="p-3 rounded-2xl bg-[#1B2E1A] border border-[#F6F4ED]/10">
                <span className="text-[#A4B8A2] text-[10px]">DATA TRANSMISSION</span>
                <p className="text-sm font-bold text-[#F6F4ED] mt-1">0 BYTES (OFFLINE)</p>
              </div>
            </div>
          </div>

        </div>

      </div>
    </section>
  );
}
