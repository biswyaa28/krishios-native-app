"use client";

import { Globe, Sparkles, ArrowRight, ShieldCheck } from "lucide-react";

export default function FlutterWebNotice() {
  return (
    <section className="py-12 relative">
      <div className="max-w-7xl mx-auto px-6">
        <div className="glass-card rounded-3xl p-8 sm:p-10 border border-emerald-500/30 bg-gradient-to-r from-emerald-950/40 via-slate-950 to-teal-950/40 relative overflow-hidden">
          
          {/* Subtle Glow Overlay */}
          <div className="absolute -right-20 -bottom-20 w-80 h-80 bg-emerald-500/15 rounded-full blur-3xl pointer-events-none" />

          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center relative z-10">
            <div className="lg:col-span-8 space-y-4 text-left">
              
              <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/30 text-xs font-mono text-emerald-400">
                <Globe className="w-3.5 h-3.5" />
                <span>Web Platform Announcement</span>
              </div>

              <h3 className="text-2xl sm:text-3xl font-extrabold text-white tracking-tight">
                Flutter Web Experience <span className="text-gradient">Coming Soon</span>
              </h3>

              <p className="text-slate-300 text-sm sm:text-base leading-relaxed max-w-2xl">
                A responsive Flutter Web experience will be available soon. Users will be able to sign in and access selected KrishiOS features, diagnostic history, and community discussions directly from any desktop or mobile browser.
              </p>
            </div>

            <div className="lg:col-span-4 flex items-center justify-start lg:justify-end">
              <div className="p-4 rounded-2xl glass-card border-white/10 flex flex-col gap-2 text-xs font-mono text-slate-300">
                <div className="flex items-center gap-2 text-emerald-400 font-bold">
                  <ShieldCheck className="w-4 h-4" />
                  <span>Browser Sync Ready</span>
                </div>
                <p className="text-slate-400 text-[11px]">
                  Cross-platform Cloud Firestore authentication sync enabled.
                </p>
              </div>
            </div>
          </div>

        </div>
      </div>
    </section>
  );
}
