"use client";

import { useEffect, useRef } from "react";
import Link from "next/link";
import { Download, Sparkles } from "lucide-react";
import PhoneMockup from "./PhoneMockup";
import { GithubIcon } from "./Icons";
import { gsap } from "@/lib/gsap";

export default function Hero() {
  const containerRef = useRef<HTMLDivElement>(null);
  const headlineRef = useRef<HTMLHeadingElement>(null);
  const subtitleRef = useRef<HTMLParagraphElement>(null);
  const ctaRef = useRef<HTMLDivElement>(null);
  const phoneRef = useRef<HTMLDivElement>(null);
  const badgeRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const ctx = gsap.context(() => {
      const tl = gsap.timeline({ defaults: { ease: "power3.out", duration: 1 } });

      tl.fromTo(badgeRef.current, { opacity: 0, y: -20 }, { opacity: 1, y: 0, duration: 0.8 })
        .fromTo(headlineRef.current, { opacity: 0, y: 30 }, { opacity: 1, y: 0 }, "-=0.5")
        .fromTo(subtitleRef.current, { opacity: 0, y: 20 }, { opacity: 1, y: 0 }, "-=0.6")
        .fromTo(ctaRef.current, { opacity: 0, y: 20 }, { opacity: 1, y: 0 }, "-=0.6")
        .fromTo(phoneRef.current, { opacity: 0, scale: 0.95, y: 40 }, { opacity: 1, scale: 1, y: 0, duration: 1.2 }, "-=0.8");

      if (phoneRef.current) {
        gsap.to(phoneRef.current, {
          y: 40,
          scrollTrigger: {
            trigger: containerRef.current,
            start: "top top",
            end: "bottom top",
            scrub: 1,
          },
        });
      }
    }, containerRef);

    return () => ctx.revert();
  }, []);

  return (
    <section ref={containerRef} className="relative pt-36 pb-24 md:pt-44 md:pb-32 overflow-hidden bg-[#F6F4ED]">
      <div className="absolute top-0 inset-x-0 h-96 bg-gradient-to-b from-[#233B22]/10 via-[#F6F4ED]/50 to-[#F6F4ED] pointer-events-none" />

      <div className="max-w-7xl mx-auto px-6 relative z-10">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-8 items-center">
          
          <div className="lg:col-span-7 space-y-6 text-center lg:text-left">
            
            <div ref={badgeRef} className="inline-flex items-center gap-2.5 px-4 py-1.5 rounded-full bg-[#233B22]/10 text-[#233B22] text-xs font-medium">
              <Sparkles className="w-3.5 h-3.5 text-[#233B22]" />
              <span>KrishiOS v1.0 • Hybrid Neural Edge Platform</span>
            </div>

            <h1 ref={headlineRef} className="text-4xl sm:text-6xl xl:text-7xl font-normal tracking-tight leading-[1.1] text-[#1A2919] text-serif-editorial">
              The Intelligence of the Earth, <br className="hidden sm:inline" />
              <span className="italic font-normal text-[#233B22]">On Your Device.</span>
            </h1>

            <p ref={subtitleRef} className="text-base sm:text-xl text-[#4B5E4A] max-w-2xl mx-auto lg:mx-0 font-normal leading-relaxed">
              Empowering farmers with instantaneous crop disease diagnostics, local ONNX neural edge AI, multi-lingual Kavya voice advisory, and zero internet dependency.
            </p>

            <div ref={ctaRef} className="flex flex-col sm:flex-row flex-wrap items-center justify-center lg:justify-start gap-4 pt-4">
              <Link
                href="#download"
                className="w-full sm:w-auto px-8 py-4 rounded-full bg-[#233B22] text-[#F6F4ED] font-medium text-sm hover:bg-[#1B2E1A] shadow-xl shadow-[#233B22]/20 transition-all hover:scale-[1.02] flex items-center justify-center gap-3 group"
              >
                <Download className="w-4 h-4 group-hover:translate-y-0.5 transition-transform" />
                <span>Download Android APK v1.0</span>
              </Link>

              <a
                href="https://github.com/biswyaa28/krishios-native-app.git"
                target="_blank"
                rel="noopener noreferrer"
                className="w-full sm:w-auto px-7 py-4 rounded-full bg-white border border-[#1A2919]/10 text-[#1A2919] font-medium text-sm hover:bg-[#233B22] hover:text-[#F6F4ED] transition-all flex items-center justify-center gap-2.5 shadow-sm"
              >
                <GithubIcon className="w-4 h-4" />
                <span>GitHub Repository</span>
              </a>
            </div>
          </div>

          <div ref={phoneRef} className="lg:col-span-5 flex justify-center">
            <PhoneMockup />
          </div>

        </div>
      </div>
    </section>
  );
}
