"use client";

import Image from "next/image";
import { Target, Heart, ShieldCheck } from "lucide-react";

export default function About() {
  return (
    <section id="about" className="py-24 relative overflow-hidden bg-[#F6F4ED]">
      <div className="max-w-7xl mx-auto px-6 relative z-10">
        <div className="editorial-card rounded-[40px] p-8 sm:p-12 border border-[#1A2919]/10 relative overflow-hidden bg-white">
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">
            
            {/* Left Column: Mission Content */}
            <div className="lg:col-span-7 space-y-6">
              <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#233B22]/10 text-[#233B22] text-xs font-medium">
                <Target className="w-3.5 h-3.5" />
                <span>OUR MISSION</span>
              </div>

              <h2 className="text-3xl sm:text-5xl font-normal tracking-tight text-[#1A2919] leading-tight text-serif-editorial">
                Transforming Agriculture with <span className="italic text-[#233B22]">Accessible Edge AI</span>
              </h2>

              <p className="text-[#4B5E4A] text-base sm:text-lg leading-relaxed">
                KrishiOS was built to bridge the gap between advanced artificial intelligence and field-level farming reality. By compiling state-of-the-art neural networks into lightweight ONNX edge models, KrishiOS grants farmers instant, internet-independent disease diagnosis right from their smartphones.
              </p>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-6 pt-6 border-t border-[#1A2919]/10">
                <div className="space-y-2">
                  <div className="flex items-center gap-2 text-[#233B22] font-bold text-base">
                    <Heart className="w-5 h-5" />
                    <span>Farmer First Approach</span>
                  </div>
                  <p className="text-xs text-[#4B5E4A] leading-relaxed">
                    Designed specifically for rural illumination, low bandwidth, and local language preferences (English, Hindi, Telugu).
                  </p>
                </div>

                <div className="space-y-2">
                  <div className="flex items-center gap-2 text-[#233B22] font-bold text-base">
                    <ShieldCheck className="w-5 h-5" />
                    <span>Data Sovereignty & Security</span>
                  </div>
                  <p className="text-xs text-[#4B5E4A] leading-relaxed">
                    All local database caches are protected using hardware-backed AES-256 KeyStore encryption.
                  </p>
                </div>
              </div>
            </div>

            {/* Right Column: Farmers Field Photography Image with Caption Below */}
            <div className="lg:col-span-5 flex flex-col items-center justify-center">
              <div className="relative w-full h-[360px] sm:h-[400px] rounded-3xl overflow-hidden border border-[#1A2919]/10 shadow-lg group">
                <Image
                  src="/Farmers.png"
                  alt="Farmers working in agricultural fields"
                  fill
                  className="object-cover group-hover:scale-105 transition-transform duration-500"
                  sizes="(max-width: 1024px) 100vw, 40vw"
                  priority
                />
              </div>
              <p className="text-center text-xs font-medium text-[#4B5E4A] font-mono mt-3">
                Agricultural Empowerment • Field Operations
              </p>
            </div>

          </div>
        </div>
      </div>
    </section>
  );
}
