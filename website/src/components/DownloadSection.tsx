"use client";

import { Download, Smartphone, Apple, Monitor, Laptop, Globe, TabletIcon, ShieldCheck } from "lucide-react";

export default function DownloadSection() {
  const platforms = [
    {
      name: "Android Platform",
      subtitle: "ARM64-v8a / ARMv7",
      status: "AVAILABLE NOW",
      available: true,
      href: "https://github.com/biswyaa28/krishios-native-app.git",
      icon: Smartphone,
      note: "Release Candidate 1 APK",
    },
    {
      name: "Flutter Web Platform",
      subtitle: "Modern Web Desktop Browsers",
      status: "AVAILABLE NOW",
      available: true,
      href: "/app/index.html",
      icon: Globe,
      note: "Instant Web Desktop Workspace",
    },
    {
      name: "iPhone (iOS)",
      subtitle: "iOS 15+",
      status: "COMING SOON",
      available: false,
      icon: Apple,
      note: "App Store Review Phase",
    },
    {
      name: "iPadOS",
      subtitle: "iPadOS 15+",
      status: "COMING SOON",
      available: false,
      icon: TabletIcon,
      note: "Tablet Canvas Sync",
    },
    {
      name: "Windows Desktop",
      subtitle: "Windows 10 / 11",
      status: "COMING SOON",
      available: false,
      icon: Monitor,
      note: "Desktop Station Package",
    },
    {
      name: "macOS Desktop",
      subtitle: "macOS 12+ (Apple Silicon)",
      status: "COMING SOON",
      available: false,
      icon: Laptop,
      note: "Native Apple Silicon Build",
    },
    {
      name: "Linux GTK",
      subtitle: "Ubuntu / Debian",
      status: "COMING SOON",
      available: false,
      icon: Monitor,
      note: "Linux Native Binary",
    },
  ];

  return (
    <section id="download" className="py-24 relative overflow-hidden bg-[#F6F4ED]">
      <div className="max-w-7xl mx-auto px-6 relative z-10">
        
        {/* Section Header */}
        <div className="text-center max-w-3xl mx-auto mb-16 space-y-4">
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#233B22]/10 text-[#233B22] text-xs font-medium">
            <Download className="w-3.5 h-3.5" />
            <span>DISTRIBUTION MATRIX</span>
          </div>
          <h2 className="text-3xl sm:text-5xl font-normal tracking-tight text-[#1A2919] text-serif-editorial">
            Get <span className="italic text-[#233B22]">KrishiOS Today</span>
          </h2>
          <p className="text-[#4B5E4A] text-base sm:text-lg">
            Download the verified production Android APK binary directly or launch the instant Flutter Web desktop workspace.
          </p>
        </div>

        {/* Primary Release Block */}
        <div className="olive-section-block p-8 sm:p-14 max-w-4xl mx-auto text-center mb-16 shadow-2xl relative overflow-hidden">
          <div className="relative z-10 space-y-6">
            <div className="inline-flex items-center gap-2 text-xs font-mono text-[#F6F4ED] bg-[#F6F4ED]/10 px-4 py-1.5 rounded-full font-bold">
              <ShieldCheck className="w-4 h-4 text-[#10B981]" />
              <span>VERIFIED ANDROID APK • VERSION 1.0.0 (RC1)</span>
            </div>

            <h3 className="text-2xl sm:text-4xl font-normal text-[#F6F4ED] tracking-tight text-serif-editorial">
              Ready for Field Deployment
            </h3>

            <p className="text-[#A4B8A2] text-sm sm:text-base max-w-xl mx-auto leading-relaxed">
              Includes 38-class ONNX edge models, Kavya voice advisory, hardware AES-256 encrypted local cache, and weather telemetry.
            </p>

            <div className="pt-2 flex flex-col sm:flex-row items-center justify-center gap-4">
              <a
                href="https://github.com/biswyaa28/krishios-native-app.git"
                target="_blank"
                rel="noopener noreferrer"
                className="w-full sm:w-auto px-8 py-4 rounded-full bg-[#F6F4ED] text-[#233B22] font-bold text-sm hover:bg-white transition-all shadow-lg flex items-center justify-center gap-3"
              >
                <Download className="w-4 h-4" />
                <span>Download Android APK v1.0</span>
              </a>

              <a
                href="/app/index.html"
                target="_blank"
                rel="noopener noreferrer"
                className="w-full sm:w-auto px-8 py-4 rounded-full bg-[#1B2E1A] text-[#F6F4ED] border border-[#F6F4ED]/20 font-bold text-sm hover:bg-[#233B22] transition-all shadow-lg flex items-center justify-center gap-3"
              >
                <Globe className="w-4 h-4 text-[#10B981]" />
                <span>Launch Web Desktop App</span>
              </a>
            </div>
          </div>
        </div>

        {/* Platform Availability Matrix Grid */}
        <div className="space-y-6 max-w-5xl mx-auto">
          <h3 className="text-[#1A2919] font-normal text-2xl text-center text-serif-editorial">
            Platform Availability Roadmap
          </h3>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            {platforms.map((platform, idx) => {
              const IconComp = platform.icon;
              return (
                <div
                  key={idx}
                  className={`p-5 rounded-2xl border transition-all flex flex-col justify-between space-y-4 ${
                    platform.available
                      ? "bg-white border-[#233B22]/30 shadow-md"
                      : "bg-white/60 border-[#1A2919]/10"
                  }`}
                >
                  <div className="space-y-3">
                    <div className="flex items-center justify-between">
                      <div
                        className={`w-9 h-9 rounded-xl flex items-center justify-center ${
                          platform.available
                            ? "bg-[#233B22] text-[#F6F4ED]"
                            : "bg-[#1A2919]/5 text-[#4B5E4A]"
                        }`}
                      >
                        <IconComp className="w-4 h-4" />
                      </div>
                      <span
                        className={`text-[10px] font-mono font-bold px-2.5 py-0.5 rounded-full ${
                          platform.available
                            ? "bg-[#10B981]/15 text-[#10B981]"
                            : "bg-[#1A2919]/5 text-[#4B5E4A]"
                        }`}
                      >
                        {platform.status}
                      </span>
                    </div>

                    <div>
                      <h4 className="font-bold text-sm text-[#1A2919]">
                        {platform.name}
                      </h4>
                      <p className="text-[11px] text-[#4B5E4A]">{platform.subtitle}</p>
                    </div>
                  </div>

                  <div className="pt-3 border-t border-[#1A2919]/10 flex items-center justify-between text-[11px] text-[#4B5E4A]">
                    <span>{platform.note}</span>
                    {platform.available && platform.href && (
                      <a
                        href={platform.href}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-[#233B22] font-bold hover:underline"
                      >
                        Launch &rarr;
                      </a>
                    )}
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
