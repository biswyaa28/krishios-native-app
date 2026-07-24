"use client";

import { useEffect, useRef } from "react";
import { Cpu, Database, Flame, Server, Code2, Layers, Cloud, HardDrive } from "lucide-react";
import { gsap } from "@/lib/gsap";

export default function TechStack() {
  const containerRef = useRef<HTMLDivElement>(null);
  const gridRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const ctx = gsap.context(() => {
      if (gridRef.current) {
        gsap.fromTo(
          gridRef.current.children,
          { opacity: 0, scale: 0.95, y: 30 },
          {
            opacity: 1,
            scale: 1,
            y: 0,
            duration: 0.7,
            stagger: 0.08,
            ease: "back.out(1.2)",
            scrollTrigger: {
              trigger: gridRef.current,
              start: "top 85%",
            },
          }
        );
      }
    }, containerRef);

    return () => ctx.revert();
  }, []);

  const techList = [
    {
      name: "Flutter",
      role: "Cross-Platform Client",
      icon: Code2,
      description: "Material 3 design system & Riverpod 2.6 state management.",
    },
    {
      name: "FastAPI",
      role: "Python REST Backend",
      icon: Server,
      description: "Multi-stage REST inference engine & AI gateway.",
    },
    {
      name: "Firebase",
      role: "Cloud Infrastructure",
      icon: Flame,
      description: "Authentication, Cloud Firestore, and Storage buckets.",
    },
    {
      name: "ONNX Runtime",
      role: "Edge AI Engine",
      icon: Cpu,
      description: "Local 38-class plant disease classification & YOLO detection.",
    },
    {
      name: "Hive",
      role: "Encrypted Local Cache",
      icon: HardDrive,
      description: "AES-256 encrypted local database storage.",
    },
    {
      name: "Next.js",
      role: "Web & Marketing Engine",
      icon: Layers,
      description: "App Router, TypeScript, and server-side static prerendering.",
    },
    {
      name: "Railway",
      role: "Cloud Container Hosting",
      icon: Cloud,
      description: "Containerized deployment & scalable backend API hosting.",
    },
  ];

  return (
    <section ref={containerRef} id="technology" className="py-24 relative overflow-hidden bg-[#F6F4ED]">
      <div className="max-w-7xl mx-auto px-6 relative z-10">
        
        {/* Section Header */}
        <div className="text-center max-w-3xl mx-auto mb-16 space-y-4">
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#233B22]/10 text-[#233B22] text-xs font-medium">
            <Database className="w-3.5 h-3.5" />
            <span>TECHNOLOGY STACK</span>
          </div>
          <h2 className="text-3xl sm:text-5xl font-normal tracking-tight text-[#1A2919] text-serif-editorial">
            Built With <span className="italic text-[#233B22]">Industry Standards</span>
          </h2>
          <p className="text-[#4B5E4A] text-base sm:text-lg">
            Powered by high-performance open-source frameworks and production-grade artificial intelligence runtimes.
          </p>
        </div>

        {/* Tech Editorial Cards Grid */}
        <div ref={gridRef} className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {techList.map((item, idx) => {
            const Icon = item.icon;
            return (
              <div
                key={idx}
                className="editorial-card rounded-3xl p-6 flex flex-col justify-between space-y-4 group"
              >
                <div className="space-y-3">
                  <div className="w-12 h-12 rounded-full bg-[#233B22]/10 flex items-center justify-center text-[#233B22] group-hover:scale-110 transition-transform">
                    <Icon className="w-6 h-6" />
                  </div>
                  <h3 className="text-base font-bold text-[#1A2919]">
                    {item.name}
                  </h3>
                  <span className="text-[10px] uppercase font-mono tracking-wider text-[#233B22] bg-[#233B22]/10 px-2.5 py-0.5 rounded-full font-bold inline-block">
                    {item.role}
                  </span>
                  <p className="text-xs text-[#4B5E4A] leading-relaxed pt-1">
                    {item.description}
                  </p>
                </div>
              </div>
            );
          })}
        </div>

      </div>
    </section>
  );
}
