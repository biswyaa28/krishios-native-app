"use client";

import { Users } from "lucide-react";
import { GithubIcon } from "./Icons";

export interface TeamMember {
  name: string;
  role: string;
  bio: string;
  avatarUrl?: string;
  githubUrl?: string;
  linkedinUrl?: string;
}

export const teamMembers: TeamMember[] = [
  {
    name: "Biswajit",
    role: "Backend Developer",
    bio: "Core Python FastAPI developer architecting multi-stage REST AI inference gateways and database integration.",
    githubUrl: "https://github.com/biswyaa28",
  },
  {
    name: "Sneha",
    role: "Figma & UI/UX Designer",
    bio: "Product designer crafting Material 3 visual systems, user flows, and field-optimized interfaces.",
  },
  {
    name: "Paarshvi",
    role: "Frontend & Research Works",
    bio: "Flutter engineer and agricultural domain researcher pioneering multi-lingual voice UX and agronomy datasets.",
    githubUrl: "https://github.com/paarshviv12",
  },
  {
    name: "Zoro",
    role: "Backend, AI & System Integration",
    bio: "AI Engineer & System Architect leading ONNX edge model quantization, C++ JNI interop, and end-to-end platform integration.",
    githubUrl: "https://github.com/ZoroDev0",
  },
];

export default function Team() {
  return (
    <section id="team" className="py-24 relative overflow-hidden bg-[#F6F4ED]">
      <div className="max-w-7xl mx-auto px-6 relative z-10">
        
        {/* Section Header */}
        <div className="text-center max-w-3xl mx-auto mb-16 space-y-4">
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#233B22]/10 text-[#233B22] text-xs font-medium">
            <Users className="w-3.5 h-3.5" />
            <span>CREATORS & ENGINEERING</span>
          </div>
          <h2 className="text-3xl sm:text-5xl font-normal tracking-tight text-[#1A2919] text-serif-editorial">
            Team <span className="italic text-[#233B22]">4 Brain</span>
          </h2>
          <p className="text-[#4B5E4A] text-base sm:text-lg">
            Building the future of AI-powered agriculture.
          </p>
        </div>

        {/* Team 4 Brain Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {teamMembers.map((member, idx) => (
            <div
              key={idx}
              className="editorial-card rounded-3xl p-6 flex flex-col justify-between space-y-4 group bg-white border border-[#1A2919]/10"
            >
              <div className="space-y-3">
                <div className="w-14 h-14 rounded-full bg-[#233B22] text-[#F6F4ED] flex items-center justify-center font-bold text-lg font-mono shadow-md group-hover:scale-105 transition-transform">
                  {member.name.substring(0, 2).toUpperCase()}
                </div>
                <div>
                  <h3 className="text-lg font-bold text-[#1A2919] text-serif-editorial">
                    {member.name}
                  </h3>
                  <span className="text-[11px] font-mono text-[#233B22] bg-[#233B22]/10 px-2.5 py-0.5 rounded-full font-bold inline-block mt-1">
                    {member.role}
                  </span>
                </div>
                <p className="text-xs text-[#4B5E4A] leading-relaxed">
                  {member.bio}
                </p>
              </div>

              <div className="flex items-center gap-3 pt-3 border-t border-[#1A2919]/10">
                {member.githubUrl && (
                  <a
                    href={member.githubUrl}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="w-8 h-8 rounded-full bg-[#F6F4ED] flex items-center justify-center text-[#4B5E4A] hover:bg-[#233B22] hover:text-[#F6F4ED] transition-colors"
                    aria-label={`${member.name}'s GitHub Profile`}
                  >
                    <GithubIcon className="w-4 h-4" />
                  </a>
                )}
              </div>
            </div>
          ))}
        </div>

        {/* Brand Mantra Banner */}
        <div className="mt-16 text-center max-w-3xl mx-auto p-10 rounded-3xl bg-[#233B22] text-[#F6F4ED] space-y-4 shadow-xl border border-[#1B2E1A]">
          <p className="text-xl sm:text-2xl font-normal text-serif-editorial leading-relaxed">
            &ldquo;KrishiOS &mdash; where <span className="italic text-[#A4B8A2]">krishi</span> (cultivation) meets wisdom. Built for the farmer who works the land, not the internet.&rdquo;
          </p>
          <div className="text-sm font-mono tracking-widest text-[#A4B8A2] uppercase">
            krishi &middot; संस्कृति &middot; cultivation
          </div>
        </div>

      </div>
    </section>
  );
}
