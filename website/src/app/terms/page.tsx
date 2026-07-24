import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";
import { FileText } from "lucide-react";

export default function TermsPage() {
  return (
    <main className="min-h-screen bg-[#F6F4ED] text-[#1A2919] relative">
      <Navbar />
      <div className="pt-36 pb-20 max-w-4xl mx-auto px-6 space-y-8">
        
        <div className="space-y-3">
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#233B22]/10 text-[#233B22] text-xs font-medium">
            <FileText className="w-3.5 h-3.5" />
            <span>TERMS OF SERVICE</span>
          </div>
          <h1 className="text-3xl sm:text-5xl font-normal text-[#1A2919] tracking-tight text-serif-editorial">
            Terms of Service
          </h1>
          <p className="text-[#4B5E4A] text-sm font-mono">
            Effective Date: July 24, 2026
          </p>
        </div>

        <div className="editorial-card rounded-3xl p-8 border border-[#1A2919]/10 space-y-6 text-[#4B5E4A] text-sm leading-relaxed bg-white">
          <section className="space-y-2">
            <h2 className="text-lg font-bold text-[#1A2919]">1. Acceptance of Terms</h2>
            <p>
              By downloading, installing, or using the KrishiOS Android application or official website, you agree to comply with and be bound by these Terms of Service.
            </p>
          </section>

          <section className="space-y-2">
            <h2 className="text-lg font-bold text-[#1A2919]">2. Agricultural Advisory Disclaimer</h2>
            <p>
              KrishiOS provides AI-assisted crop disease diagnosis and agronomy recommendations based on computer vision models and advisory engines. While our models strive for high statistical accuracy, field conditions vary. Recommendations should be validated alongside certified local agronomists for commercial agricultural application.
            </p>
          </section>

          <section className="space-y-2">
            <h2 className="text-lg font-bold text-[#1A2919]">3. Open Source & License</h2>
            <p>
              KrishiOS source code is licensed under standard open-source licenses specified in our official GitHub repository.
            </p>
          </section>

          <section className="space-y-2">
            <h2 className="text-lg font-bold text-[#1A2919]">4. Modifications to Service</h2>
            <p>
              Team 4 Brain reserves the right to modify, update, or discontinue features of the application or website at any time without prior notice.
            </p>
          </section>
        </div>

      </div>
      <Footer />
    </main>
  );
}
