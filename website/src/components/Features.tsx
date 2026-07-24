"use client";

import { useEffect, useRef } from "react";
import { Cpu, ShieldCheck, Zap, Camera, WifiOff, Layout, Bot, CloudLightning, Layers, ExternalLink, BookOpen } from "lucide-react";
import { gsap } from "@/lib/gsap";

export interface DocLink {
  label: string;
  url: string;
}

export interface FeatureItem {
  icon: any;
  title: string;
  description: string;
  docs: DocLink[];
}

export default function Features() {
  const containerRef = useRef<HTMLDivElement>(null);
  const cardsRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const ctx = gsap.context(() => {
      if (cardsRef.current) {
        gsap.fromTo(
          cardsRef.current.children,
          { opacity: 0, y: 40 },
          {
            opacity: 1,
            y: 0,
            duration: 0.8,
            stagger: 0.1,
            ease: "power2.out",
            scrollTrigger: {
              trigger: cardsRef.current,
              start: "top 80%",
            },
          }
        );
      }
    }, containerRef);

    return () => ctx.revert();
  }, []);

  const features: FeatureItem[] = [
    {
      icon: Cpu,
      title: "On-Device ONNX Edge AI",
      description: "Runs full 38-class neural classification directly on device without server internet data.",
      docs: [
        { label: "ONNX", url: "https://onnx.ai/" },
        { label: "ONNX Runtime", url: "https://onnxruntime.ai/" },
      ],
    },
    {
      icon: Camera,
      title: "YOLO Quality Validation",
      description: "Camera pipeline checks image sharpness, illumination, and foliage focus prior to inference.",
      docs: [
        { label: "Ultralytics YOLO", url: "https://docs.ultralytics.com/" },
      ],
    },
    {
      icon: Zap,
      title: "Sub-Second Diagnosis",
      description: "Get instant crop health scores and disease remedies in under 1 second (14ms latency).",
      docs: [
        { label: "ONNX Performance", url: "https://onnxruntime.ai/docs/performance/" },
      ],
    },
    {
      icon: WifiOff,
      title: "Zero Internet Core",
      description: "Engineered specifically for remote farming blackouts with 100% offline edge functionality.",
      docs: [
        { label: "Android Offline-first", url: "https://developer.android.com/topic/architecture/data-layer/offline-first" },
      ],
    },
    {
      icon: ShieldCheck,
      title: "AES-256 KeyStore Security",
      description: "Hive encryption keys are protected via Android KeyStore EncryptedSharedPreferences.",
      docs: [
        { label: "AES Cryptography", url: "https://csrc.nist.gov/projects/cryptographic-standards-and-guidelines" },
        { label: "Android Keystore", url: "https://developer.android.com/privacy-and-security/keystore" },
        { label: "EncryptedSharedPreferences", url: "https://developer.android.com/reference/androidx/security/crypto/EncryptedSharedPreferences" },
      ],
    },
    {
      icon: Bot,
      title: "Kavya Voice Advisory",
      description: "Interactive multi-lingual voice guidance in Hindi, Telugu, and English.",
      docs: [
        { label: "Android TextToSpeech", url: "https://developer.android.com/reference/android/speech/tts/TextToSpeech" },
        { label: "SpeechRecognizer", url: "https://developer.android.com/reference/android/speech/SpeechRecognizer" },
      ],
    },
    {
      icon: Layout,
      title: "Material 3 Responsive Shell",
      description: "Built with Riverpod 2.6 state management and high-contrast field-optimized controls.",
      docs: [
        { label: "Material Design 3", url: "https://m3.material.io/" },
        { label: "Flutter Material 3", url: "https://docs.flutter.dev/ui/design/material" },
        { label: "Riverpod 2.6", url: "https://riverpod.dev/" },
      ],
    },
    {
      icon: CloudLightning,
      title: "FastAPI Hybrid Gateway",
      description: "Connects to cloud servers when online for telemetry sync and continuous model updates.",
      docs: [
        { label: "FastAPI", url: "https://fastapi.tiangolo.com/" },
        { label: "Pydantic V2", url: "https://docs.pydantic.dev/" },
        { label: "Uvicorn ASGI", url: "https://www.uvicorn.org/" },
      ],
    },
  ];

  return (
    <section ref={containerRef} id="features" className="py-12 relative overflow-hidden bg-[#F6F4ED]">
      <div className="max-w-7xl mx-auto px-6 relative z-10">
        
        {/* Deep Olive Section Block */}
        <div className="olive-section-block p-8 sm:p-14 border border-[#1A2919]/10 shadow-2xl space-y-12">
          
          {/* Section Header */}
          <div className="text-center max-w-3xl mx-auto space-y-4">
            <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#F6F4ED]/10 text-[#F6F4ED] text-xs font-mono">
              <Layers className="w-3.5 h-3.5" />
              <span>SYSTEM ARCHITECTURE & CAPABILITIES</span>
            </div>
            <h2 className="text-3xl sm:text-5xl font-normal tracking-tight text-[#F6F4ED] text-serif-editorial">
              What Makes <span className="italic">KrishiOS Unique?</span>
            </h2>
            <p className="text-[#A4B8A2] text-base sm:text-lg">
              A state-of-the-art intelligent platform combining offline edge intelligence with cloud advisory synchronization.
            </p>
          </div>

          {/* Feature Grid with Self-Contained Documentation Links */}
          <div ref={cardsRef} className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {features.map((feature, idx) => {
              const IconComp = feature.icon;
              return (
                <div
                  key={idx}
                  className="rounded-3xl p-6 bg-[#1B2E1A] border border-[#F6F4ED]/10 hover:border-[#F6F4ED]/30 transition-all group flex flex-col justify-between space-y-6"
                >
                  <div className="space-y-4">
                    <div className="w-10 h-10 rounded-2xl bg-[#F6F4ED]/10 flex items-center justify-center text-[#F6F4ED]">
                      <IconComp className="w-5 h-5" />
                    </div>
                    <h3 className="text-lg font-bold text-[#F6F4ED] text-serif-editorial">
                      {feature.title}
                    </h3>
                    <p className="text-xs text-[#A4B8A2] leading-relaxed">
                      {feature.description}
                    </p>
                  </div>

                  {/* Integrated Official Documentation Pills */}
                  <div className="pt-4 border-t border-[#F6F4ED]/10 space-y-2.5">
                    <div className="flex items-center gap-1.5 text-[10px] font-mono font-bold tracking-wider text-[#A4B8A2] uppercase">
                      <BookOpen className="w-3 h-3 text-[#10B981]" />
                      <span>Official Documentation</span>
                    </div>
                    
                    <div className="flex flex-wrap gap-1.5">
                      {feature.docs.map((doc, dIdx) => (
                        <a
                          key={dIdx}
                          href={doc.url}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="inline-flex items-center gap-1 px-2.5 py-1 rounded-lg bg-[#233B22] border border-[#F6F4ED]/15 text-[11px] font-mono text-[#F6F4ED] hover:bg-[#10B981] hover:text-[#1B2E1A] hover:border-[#10B981] transition-all"
                        >
                          <span>{doc.label}</span>
                          <ExternalLink className="w-2.5 h-2.5 shrink-0" />
                        </a>
                      ))}
                    </div>
                  </div>
                </div>
              );
            })}
          </div>

        </div>
      </div>
    </section>
  );
}
