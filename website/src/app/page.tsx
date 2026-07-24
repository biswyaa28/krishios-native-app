import Navbar from "@/components/Navbar";
import Hero from "@/components/Hero";
import ProblemSolution from "@/components/ProblemSolution";
import Features from "@/components/Features";
import AppScreenshots from "@/components/AppScreenshots";
import DownloadSection from "@/components/DownloadSection";
import TechStack from "@/components/TechStack";
import About from "@/components/About";
import Team from "@/components/Team";
import Footer from "@/components/Footer";

export default function Home() {
  return (
    <main className="min-h-screen bg-[#F6F4ED] text-[#1A2919] selection:bg-[#233B22]/20 selection:text-[#1A2919] relative">
      <Navbar />
      <Hero />
      <ProblemSolution />
      <Features />
      <AppScreenshots />
      <DownloadSection />
      <TechStack />
      <About />
      <Team />
      <Footer />
    </main>
  );
}
