"use client";

import { useState } from "react";
import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";
import { Mail, MessageSquare, Send, CheckCircle2, AlertCircle } from "lucide-react";
import { GithubIcon } from "@/components/Icons";

export default function ContactPage() {
  const [formData, setFormData] = useState({ name: "", email: "", message: "" });
  const [status, setStatus] = useState<"idle" | "submitting" | "success" | "error">("idle");
  const [statusMsg, setStatusMsg] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!formData.name || !formData.email || !formData.message) return;

    setStatus("submitting");
    try {
      const res = await fetch("/api/contact", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(formData),
      });

      if (res.ok) {
        setStatus("success");
        setStatusMsg("Your message has been sent successfully to zorodev.exe@gmail.com!");
        setFormData({ name: "", email: "", message: "" });
      } else {
        setStatus("error");
        setStatusMsg("Failed to send message. Please try again or email zorodev.exe@gmail.com directly.");
      }
    } catch (err) {
      setStatus("error");
      setStatusMsg("Failed to send message. Please email zorodev.exe@gmail.com directly.");
    }
  };

  return (
    <main className="min-h-screen bg-[#F6F4ED] text-[#1A2919] relative">
      <Navbar />
      <div className="pt-36 pb-20 max-w-4xl mx-auto px-6 space-y-8">
        
        <div className="space-y-3">
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#233B22]/10 text-[#233B22] text-xs font-medium">
            <Mail className="w-3.5 h-3.5" />
            <span>CONTACT & SUPPORT</span>
          </div>
          <h1 className="text-3xl sm:text-5xl font-normal text-[#1A2919] tracking-tight text-serif-editorial">
            Get in Touch
          </h1>
          <p className="text-[#4B5E4A] text-base">
            Have questions about KrishiOS, feedback, or contribution inquiries? Reach out directly to Team 4 Brain.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-12 gap-8">
          {/* Contact Details Column */}
          <div className="md:col-span-5 editorial-card rounded-3xl p-8 border border-[#1A2919]/10 space-y-6 flex flex-col justify-between bg-white">
            <div className="space-y-4">
              <h3 className="text-xl font-bold text-[#1A2919] text-serif-editorial">Direct Contact</h3>
              <p className="text-xs text-[#4B5E4A] leading-relaxed">
                Connect directly with the core engineering team or submit issues to our public repository.
              </p>

              <div className="p-4 rounded-2xl bg-[#F6F4ED] border border-[#1A2919]/10 space-y-1">
                <span className="text-[10px] font-mono text-[#233B22] font-bold uppercase">PRIMARY EMAIL</span>
                <p className="text-xs font-mono font-bold text-[#1A2919]">zorodev.exe@gmail.com</p>
              </div>
            </div>

            <div className="space-y-4 pt-4">
              <a
                href="https://github.com/biswyaa28/krishios-native-app.git"
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-3 p-4 rounded-2xl bg-[#F6F4ED] hover:bg-[#233B22] hover:text-[#F6F4ED] border border-[#1A2919]/10 text-[#1A2919] transition-all text-sm font-medium"
              >
                <GithubIcon className="w-5 h-5 text-[#233B22]" />
                <span>GitHub Issues & Discussions</span>
              </a>
            </div>
          </div>

          {/* Contact Form Column */}
          <div className="md:col-span-7 editorial-card rounded-3xl p-8 border border-[#1A2919]/10 space-y-4 bg-white">
            <h3 className="text-xl font-bold text-[#1A2919] flex items-center gap-2 text-serif-editorial">
              <MessageSquare className="w-5 h-5 text-[#233B22]" />
              <span>Send Message</span>
            </h3>

            {status === "success" && (
              <div className="p-3.5 rounded-2xl bg-emerald-500/10 border border-emerald-500/30 text-[#233B22] text-xs flex items-center gap-2 font-medium">
                <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0" />
                <span>{statusMsg}</span>
              </div>
            )}

            {status === "error" && (
              <div className="p-3.5 rounded-2xl bg-red-500/10 border border-red-500/30 text-red-700 text-xs flex items-center gap-2 font-medium">
                <AlertCircle className="w-4 h-4 text-red-600 shrink-0" />
                <span>{statusMsg}</span>
              </div>
            )}

            <form onSubmit={handleSubmit} className="space-y-4 text-xs font-medium">
              <div className="space-y-1.5">
                <label className="text-[#4B5E4A]">Name</label>
                <input
                  type="text"
                  required
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  placeholder="Your Name"
                  className="w-full px-4 py-3 rounded-xl bg-[#F6F4ED] border border-[#1A2919]/10 text-[#1A2919] focus:outline-none focus:border-[#233B22] transition-colors"
                />
              </div>

              <div className="space-y-1.5">
                <label className="text-[#4B5E4A]">Email Address</label>
                <input
                  type="email"
                  required
                  value={formData.email}
                  onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                  placeholder="you@example.com"
                  className="w-full px-4 py-3 rounded-xl bg-[#F6F4ED] border border-[#1A2919]/10 text-[#1A2919] focus:outline-none focus:border-[#233B22] transition-colors"
                />
              </div>

              <div className="space-y-1.5">
                <label className="text-[#4B5E4A]">Message</label>
                <textarea
                  rows={4}
                  required
                  value={formData.message}
                  onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                  placeholder="How can we help?"
                  className="w-full px-4 py-3 rounded-xl bg-[#F6F4ED] border border-[#1A2919]/10 text-[#1A2919] focus:outline-none focus:border-[#233B22] transition-colors"
                />
              </div>

              <button
                type="submit"
                disabled={status === "submitting"}
                className="w-full py-3.5 rounded-full bg-[#233B22] hover:bg-[#1B2E1A] text-[#F6F4ED] font-bold text-sm flex items-center justify-center gap-2 transition-all shadow-md disabled:opacity-50"
              >
                <Send className="w-4 h-4" />
                <span>{status === "submitting" ? "Sending to zorodev.exe@gmail.com..." : "Send Message"}</span>
              </button>
            </form>
          </div>
        </div>

      </div>
      <Footer />
    </main>
  );
}
